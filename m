Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F4151A40A
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352498AbiEDPcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350433AbiEDPcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:32:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880AB44757
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651678117; x=1683214117;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=muTtVu2SzvdErrdbUMDAkakwEH8pLUWqic7NtI8H03k=;
  b=au6S+cjRuOgiruOnJNJSY6r7EqudZvTpHUQWzLLf61jMOVSkNbs2QXFF
   kOMrhpdaTcNxfEd5eLLFOeujXQxP+qjusyv4XKIW5TGb0P22j71GJCh+W
   fO9ZKjuM0QrMTWpft8ObQJMAHYEaEBAinp8J6uHk7lRMaNyGqEdWt6OWV
   oeDCi4Ezeocq4wKptJ1TkY6r/uPno1OPFByl1FkC/nIr4AsgV5Iwz26T6
   PCi+t/5juQLRoBMrKMZ8tpyXggjtnSVPQTZ8MIIC8/nvatH3tZxes1o49
   5WYMiXOlIEA6Xbz56F2k6D4yuERmH2Xt7tJMtiyYT3V27gOGUc5SSipzW
   g==;
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="162716387"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2022 08:28:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 4 May 2022 08:28:36 -0700
Received: from chn-vm-ungapp01.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 4 May 2022 08:28:36 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <woojung.huh@microchip.com>, <yuiko.oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <ravi.hegde@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: [PATCH v3 net-next 1/2] net: phy: microchip: update LAN88xx phy ID and phy ID mask.
Date:   Wed, 4 May 2022 08:28:21 -0700
Message-ID: <20220504152822.11890-2-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220504152822.11890-1-yuiko.oshino@microchip.com>
References: <20220504152822.11890-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

update LAN88xx phy ID and phy ID mask because the existing code conflicts with the LAN8742 phy.

The current phy IDs on the available hardware.
        LAN8742 0x0007C130, 0x0007C131
        LAN88xx 0x0007C132

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/phy/microchip.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index 9f1f2b6c97d4..ccecee2524ce 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -344,8 +344,12 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
 
 static struct phy_driver microchip_phy_driver[] = {
 {
-	.phy_id		= 0x0007c130,
-	.phy_id_mask	= 0xfffffff0,
+	.phy_id		= 0x0007c132,
+	/* This mask (0xfffffff2) is to differentiate from
+	 * LAN8742 (phy_id 0x0007c130 and 0x0007c131)
+	 * and allows future phy_id revisions.
+	 */
+	.phy_id_mask	= 0xfffffff2,
 	.name		= "Microchip LAN88xx",
 
 	/* PHY_GBIT_FEATURES */
@@ -369,7 +373,7 @@ static struct phy_driver microchip_phy_driver[] = {
 module_phy_driver(microchip_phy_driver);
 
 static struct mdio_device_id __maybe_unused microchip_tbl[] = {
-	{ 0x0007c130, 0xfffffff0 },
+	{ 0x0007c132, 0xfffffff2 },
 	{ }
 };
 
-- 
2.25.1

