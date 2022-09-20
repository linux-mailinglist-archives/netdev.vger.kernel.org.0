Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0287C5BE0E9
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiITI5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 04:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiITI5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 04:57:39 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4146B8FE;
        Tue, 20 Sep 2022 01:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663664255; x=1695200255;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JXesiNRaE8uoz/dTTwq+dSiyrT2T5zcGN2d60b05SEc=;
  b=n5sK2Uld50wSLOskGUntn9fVP/Z/Jmgr8FN06+VGUUlYCH1PkaO7dz5G
   T2mVrhsm2A8Pm6t/uHstpd42bEbsF9/toB4cLSxV7MMqMAfaZIa8JeJBZ
   Thn7QLLq1HI+/Chx9lTxnKD9Zs8ca1OJBLSc0BWS1QJLNzredvKs3wDik
   ci4tf2HYvAI4UTAJ5FD4ZNkD+PIttfp8//yUCuDDiukLw1LQZem4bnJw6
   7jkZD03Bg7sEd/xJGSuq77PybjOdiRVXcbAVdezFlRQrYIRhyCYeHkf1y
   fcVE0bCqSUO8aEWl5Zu2x5RXUOd/+hT8vFJ68sbEGmVC9qtvX2Uvq+Zdm
   g==;
X-IronPort-AV: E=Sophos;i="5.93,330,1654585200"; 
   d="scan'208";a="191583069"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2022 01:57:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 20 Sep 2022 01:57:34 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 20 Sep 2022 01:57:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/4] net: lan966x: Add mqprio and taprio support
Date:   Tue, 20 Sep 2022 11:00:06 +0200
Message-ID: <20220920090010.305172-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading QoS features with tc command to lan966x. The
offloaded QoS features are mqprio and taprio.

Horatiu Vultur (4):
  net: lan966x: Add define for number of priority queues NUM_PRIO_QUEUES
  net: lan966x: Add offload support for mqprio
  net: lan966x: Add registers used by taprio
  net: lan966x: Add offload support for taprio

 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |  11 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  17 +
 .../microchip/lan966x/lan966x_mqprio.c        |  28 +
 .../ethernet/microchip/lan966x/lan966x_port.c |   2 +
 .../ethernet/microchip/lan966x/lan966x_ptp.c  |   9 +-
 .../ethernet/microchip/lan966x/lan966x_regs.h | 159 ++++++
 .../microchip/lan966x/lan966x_taprio.c        | 528 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_tc.c   |  40 ++
 9 files changed, 792 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tc.c

-- 
2.33.0

