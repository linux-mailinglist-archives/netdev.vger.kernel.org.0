Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486525F067B
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 10:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiI3Ich (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 04:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiI3Icd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 04:32:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7903AE7C;
        Fri, 30 Sep 2022 01:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664526750; x=1696062750;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V8b0GVjrIXaRPpRlaBUOD4E08uZuA6csHqP34esyS3w=;
  b=UyWKhOxuvzu+1rjgLrBcH48fg5kfeGtt0o/E7SHjDgrE1F7RHbHGzidj
   XyWdq46R/iSjB4dhib46DzDHN1kwXObvJgZbVNvc/Kcm5f0PDYaCrH0US
   4wV3IqiOe+1BDRVThNqed2pmy8/I8ds+PNpT4Tpc9wK8M5T62zkmRVzhd
   +8epDskvP36of9EcqVO50k5Fd8krgFB3VUP4qwsig0GuD27aDzeYfwsa8
   lppQGGoSs7quByXQUliTdC/AgtbAhxcvduMjmRaR6ydoTyILTF9IlIdkc
   QNnGNhfLk1d2VKMlV+KQc8Spu4CkVhSicC3biyPtdtuWsjujjU9vQU+Gw
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="116203006"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Sep 2022 01:32:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 30 Sep 2022 01:32:29 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 30 Sep 2022 01:32:27 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/2] net: lan966x: Add police and mirror using tc-matchall
Date:   Fri, 30 Sep 2022 10:35:38 +0200
Message-ID: <20220930083540.347686-1-horatiu.vultur@microchip.com>
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

Add tc-matchall classifier offload support both for ingress and egress.
For this add support for the port police and port mirroring action support.
Port police can happen only on ingress while port mirroring is supported
both on ingress and egress

Horatiu Vultur (2):
  net: lan966x: Add port police support using tc-matchall
  net: lan966x: Add port mirroring support using tc-matchall

 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  44 ++++
 .../microchip/lan966x/lan966x_mirror.c        | 138 ++++++++++
 .../microchip/lan966x/lan966x_police.c        | 235 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  96 +++++++
 .../ethernet/microchip/lan966x/lan966x_tc.c   |  50 ++++
 .../microchip/lan966x/lan966x_tc_matchall.c   |  95 +++++++
 7 files changed, 660 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mirror.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_police.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c

-- 
2.33.0

