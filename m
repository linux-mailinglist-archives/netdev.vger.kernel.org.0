Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E62D5BFDB6
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiIUMVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiIUMV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:21:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BF88A7D1;
        Wed, 21 Sep 2022 05:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663762887; x=1695298887;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JVrR3XE5rdbRqPkOwqzLWzWpdgvYrmb6XcUjcFc9UpE=;
  b=0r5b9Z8pXpQif872mSU4YZL59cqMThYxWkAR4gZW4Wbe7IETviUNOmZ1
   C+J3OSQjqmCcEeEDehBfLJIyeFqHXJOSJR5THwPl8HO3IPGTnfofwfBDR
   1eRsrWbvJJqVd1A9ugLKoKZnSoYx/g1BgRaJg6/cKK+md9BMd85/sZR9r
   73qYHQXBDTs883Z4TX7Er/SOaHWRAa3/sX1F6A5x26a4rKsm1l74GDryg
   Ffk8DebEvACqVMTj6EKzNZm5S9aCsrgLlxuN7k4drO7uS72FErtSNlrcf
   3434K6XXP+P4wY8gGzPh2YHJPVYZWjSyEIxQKysM0t4cwikHHbH4+cmuC
   A==;
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="174903291"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Sep 2022 05:21:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 21 Sep 2022 05:21:19 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 21 Sep 2022 05:21:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/4] net: lan966x: Add mqprio and taprio support
Date:   Wed, 21 Sep 2022 14:25:34 +0200
Message-ID: <20220921122538.2079744-1-horatiu.vultur@microchip.com>
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

v1->v2:
- fix compilation warning
- rename lan966x_taprio_enable/disable to lan966x_taprio_add/del

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

