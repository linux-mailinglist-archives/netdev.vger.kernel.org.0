Return-Path: <netdev+bounces-4080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F4570A905
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 18:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D045281170
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 16:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C528F5C;
	Sat, 20 May 2023 16:13:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694508F57
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 16:13:39 +0000 (UTC)
Received: from smtp.missinglinkelectronics.com (smtp.missinglinkelectronics.com [162.55.135.183])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCCD10A
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 09:13:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp.missinglinkelectronics.com (Postfix) with ESMTP id 8692E2066D;
	Sat, 20 May 2023 18:07:25 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at missinglinkelectronics.com
Received: from smtp.missinglinkelectronics.com ([127.0.0.1])
	by localhost (mail.missinglinkelectronics.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MdvyU3nrGRcS; Sat, 20 May 2023 18:07:25 +0200 (CEST)
Received: from humpen-bionic2.mle (p578c5bfe.dip0.t-ipconnect.de [87.140.91.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: david)
	by smtp.missinglinkelectronics.com (Postfix) with ESMTPSA id 4AB7F205F3;
	Sat, 20 May 2023 18:07:23 +0200 (CEST)
From: David Epping <david.epping@missinglinkelectronics.com>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	David Epping <david.epping@missinglinkelectronics.com>
Subject: [PATCH net 2/3] net: phy: mscc: add support for VSC8501
Date: Sat, 20 May 2023 18:06:02 +0200
Message-Id: <20230520160603.32458-3-david.epping@missinglinkelectronics.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

The VSC8501 PHY can use the same driver implementation as the VSC8502.
Adding the PHY ID and copying the handler functions of VSC8502 is
sufficient to operate it.

Signed-off-by: David Epping <david.epping@missinglinkelectronics.com>
---
 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index a50235fdf7d9..79cbb2418664 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -276,6 +276,7 @@ enum rgmii_clock_delay {
 /* Microsemi PHY ID's
  *   Code assumes lowest nibble is 0
  */
+#define PHY_ID_VSC8501			  0x00070530
 #define PHY_ID_VSC8502			  0x00070630
 #define PHY_ID_VSC8504			  0x000704c0
 #define PHY_ID_VSC8514			  0x00070670
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index bd81a4b041e5..29fc27a16805 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2316,6 +2316,30 @@ static int vsc85xx_probe(struct phy_device *phydev)
 
 /* Microsemi VSC85xx PHYs */
 static struct phy_driver vsc85xx_driver[] = {
+{
+	.phy_id		= PHY_ID_VSC8501,
+	.name		= "Microsemi GE VSC8501 SyncE",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_BASIC_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init	= &vsc85xx_config_init,
+	.config_aneg    = &vsc85xx_config_aneg,
+	.read_status	= &vsc85xx_read_status,
+	.handle_interrupt = vsc85xx_handle_interrupt,
+	.config_intr	= &vsc85xx_config_intr,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc85xx_probe,
+	.set_wol	= &vsc85xx_wol_set,
+	.get_wol	= &vsc85xx_wol_get,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings    = &vsc85xx_get_strings,
+	.get_stats      = &vsc85xx_get_stats,
+},
 {
 	.phy_id		= PHY_ID_VSC8502,
 	.name		= "Microsemi GE VSC8502 SyncE",
@@ -2656,6 +2680,7 @@ static struct phy_driver vsc85xx_driver[] = {
 module_phy_driver(vsc85xx_driver);
 
 static struct mdio_device_id __maybe_unused vsc85xx_tbl[] = {
+	{ PHY_ID_VSC8501, 0xfffffff0, },
 	{ PHY_ID_VSC8502, 0xfffffff0, },
 	{ PHY_ID_VSC8504, 0xfffffff0, },
 	{ PHY_ID_VSC8514, 0xfffffff0, },
-- 
2.17.1


