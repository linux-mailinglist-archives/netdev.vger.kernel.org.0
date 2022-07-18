Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF421577AD4
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 08:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiGRGSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 02:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbiGRGSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 02:18:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E284011A26;
        Sun, 17 Jul 2022 23:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658125101; x=1689661101;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hgWkLdkB1n3PWMUmy3r/YjIibgoTXl+GCLlU28d3LCQ=;
  b=JEybVNn2K7C7+i6CP2AwWR8P89gTciIHC7vXcwwaBlOeZOlT15cvaMGG
   REhr7afIQa/lOM5Hh3qVR2OWQxFcja9VyKbnKMUnJ6ioFKkwXQ7MGmjwS
   3UzUDknQwGvZu3N4s/3tzMGRAZzVnu0JkF/bYad/eYNucikciBZMdZ2Xs
   CzsYqxl/enrtm+mryS86t4JMXbf7kl4WhsIGWqohxK3SSFTX8fEIkyKsk
   xOdVC0zrdHdvPHBrMNmL2bcNVBzV++VZZozNrGXG1cDQvQePFUbbIHA4W
   CisTNlegHI14Osdai6U4at3ivldEA5a0WLh1DbkixStKg5updmefyou/f
   A==;
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="165153195"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jul 2022 23:18:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 17 Jul 2022 23:18:18 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 17 Jul 2022 23:18:13 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Arun Ramadoss" <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next] net: dsa: microchip: fix the missing ksz8_r_mib_cnt
Date:   Mon, 18 Jul 2022 11:48:03 +0530
Message-ID: <20220718061803.4939-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the refactoring for the ksz8_dev_ops from ksz8795.c to
ksz_common.c, the ksz8_r_mib_cnt has been missed. So this patch adds the
missing one.

Fixes: 6ec23aaaac43 ("net: dsa: microchip: move ksz_dev_ops to ksz_common.c")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 28d7cb2ce98f..26bd239f4f07 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -150,6 +150,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.port_setup = ksz8_port_setup,
 	.r_phy = ksz8_r_phy,
 	.w_phy = ksz8_w_phy,
+	.r_mib_cnt = ksz8_r_mib_cnt,
 	.r_mib_pkt = ksz8_r_mib_pkt,
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,

base-commit: 2acd1022549e210edc4cfc9fc65b07b88751f0d9
-- 
2.36.1

