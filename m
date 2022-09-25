Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C24F5E9573
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiIYSn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbiIYSn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:43:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860CE2B626;
        Sun, 25 Sep 2022 11:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664131434; x=1695667434;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EOSN/UYw3FtbzLVDPAbCUVUyyCNr6nKc9JqjrXMbKTA=;
  b=VEImBlZtqBpo7n2ENPh+JprOPt7BBjrMqNNcG3jvIZaNrcsHUM17r0DS
   t5x78rZOqo1JTTgamAmC7ot+JHn1QCEeu5bF5rzqSnffpCg8QPBV/xamv
   3hYmTDvtW/N3ibPTb63rAjhPB3dQA6nkfgVAOqqReW0cd7PY/TAnmhKr5
   7RlKQj8fn4tQP3r8ekoCuB1733DdaDOP8VSFxt51uIeBasHLm0F9MBkPU
   CNfOfHQRpdAAuF1/FAyEgA/F/XYip8w92lJvxxFK+KuijkDQCDCeQI8h1
   F984raLuJaxv3kCaZaaF6/r79WiwuNYclk3rTGEVBf3Ao6IowxHcBTbej
   g==;
X-IronPort-AV: E=Sophos;i="5.93,344,1654585200"; 
   d="scan'208";a="115319822"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Sep 2022 11:43:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 25 Sep 2022 11:43:53 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 25 Sep 2022 11:43:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/3] net: lan966x: Add tbf, cbs, ets support
Date:   Sun, 25 Sep 2022 20:46:30 +0200
Message-ID: <20220925184633.4148143-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading QoS features with tc command to lan966x.
The offloaded Qos features are tbf, cbs and ets.

Horatiu Vultur (3):
  net: lan966x: Add offload support for tbf
  net: lan966x: Add offload support for cbs
  net: lan966x: Add offload support for ets

 .../net/ethernet/microchip/lan966x/Makefile   |  3 +-
 .../ethernet/microchip/lan966x/lan966x_cbs.c  | 70 ++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_ets.c  | 96 +++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h | 19 ++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 50 ++++++++++
 .../ethernet/microchip/lan966x/lan966x_tbf.c  | 85 ++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_tc.c   | 43 +++++++++
 7 files changed, 365 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_cbs.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ets.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tbf.c

-- 
2.33.0

