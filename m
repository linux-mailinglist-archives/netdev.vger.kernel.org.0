Return-Path: <netdev+bounces-4069-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 310DE70A721
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 12:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5DF11C20A82
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 10:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FBD83D9C;
	Sat, 20 May 2023 10:18:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA512115
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 10:18:44 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F63D189
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 03:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZLSnpDfUL+2pKFnwJlzbHnQTJxGjWioCGdyEP9GpgQ0=; b=DrRTdbcCzLGptW4HeYFWSSTonr
	ssoEXfQkCjlNsn9wLumA2GQ4Nu6grDVzxQW1bZkMfhICma8oDYNJz25sGvSwNWbWr4VbeN80BLog/
	LPPlAogqsD8yB2YJCnoWhe3cMkYgBXGQUP0ljr7m49erpqIqkQn+lV0HiZQFEClQyE9300+ln6ghJ
	Ky0HFsmpOff/ZHX4o4XM7B6n9NP7o69qrkKTxPIQs5QkDtJLjAiu1YppyCwc5EDivI5nu9QLT4HLI
	a99isikqOg7nSqIOC404BlvtoPPRUs/PJot9u/lF+lsrh0MobB+DUXauhVPR8oSX/ZMSo251A5xQl
	2iv1+WSg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55016 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q0JfS-0004CH-Rx; Sat, 20 May 2023 11:18:30 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q0JfS-006Dqc-8t; Sat, 20 May 2023 11:18:30 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Josua Mayer <josua@solid-run.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: sfp: add support for a couple of copper
 multi-rate modules
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q0JfS-006Dqc-8t@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Sat, 20 May 2023 11:18:30 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for the Fiberstore SFP-10G-T and Walsun HXSX-ATRC-1
modules. Internally, the PCB silkscreen has what seems to be a part
number of WT_502. Fiberstore use v2.2 whereas Walsun use v2.6.

These modules contain a Marvell AQrate AQR113C PHY, accessible through
I2C 0x51 using the "rollball" protocol. In both cases, the PHY is
programmed to use 10GBASE-R with pause-mode rate adaption.

Unlike the other rollball modules, these only need a four second delay
before we can talk to the PHY.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4799976a1609..7ddebf38ef3d 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -170,7 +170,6 @@ static const enum gpiod_flags gpio_flags[] = {
  * on board (for a copper SFP) time to initialise.
  */
 #define T_WAIT			msecs_to_jiffies(50)
-#define T_WAIT_ROLLBALL		msecs_to_jiffies(25000)
 #define T_START_UP		msecs_to_jiffies(300)
 #define T_START_UP_BAD_GPON	msecs_to_jiffies(60000)
 
@@ -351,6 +350,27 @@ static void sfp_fixup_ignore_tx_fault(struct sfp *sfp)
 	sfp->tx_fault_ignore = true;
 }
 
+// For 10GBASE-T short-reach modules
+static void sfp_fixup_10gbaset_30m(struct sfp *sfp)
+{
+	sfp->id.base.connector = SFF8024_CONNECTOR_RJ45;
+	sfp->id.base.extended_cc = SFF8024_ECC_10GBASE_T_SR;
+}
+
+static void sfp_fixup_rollball_proto(struct sfp *sfp, unsigned int secs)
+{
+	sfp->mdio_protocol = MDIO_I2C_ROLLBALL;
+	sfp->module_t_wait = msecs_to_jiffies(secs * 1000);
+}
+
+static void sfp_fixup_fs_10gt(struct sfp *sfp)
+{
+	sfp_fixup_10gbaset_30m(sfp);
+
+	// These SFPs need 4 seconds before the PHY can be accessed
+	sfp_fixup_rollball_proto(sfp, 4);
+}
+
 static void sfp_fixup_halny_gsfp(struct sfp *sfp)
 {
 	/* Ignore the TX_FAULT and LOS signals on this module.
@@ -362,8 +382,8 @@ static void sfp_fixup_halny_gsfp(struct sfp *sfp)
 
 static void sfp_fixup_rollball(struct sfp *sfp)
 {
-	sfp->mdio_protocol = MDIO_I2C_ROLLBALL;
-	sfp->module_t_wait = T_WAIT_ROLLBALL;
+	// Rollball SFPs need 25 seconds before the PHY can be accessed
+	sfp_fixup_rollball_proto(sfp, 25);
 }
 
 static void sfp_fixup_rollball_cc(struct sfp *sfp)
@@ -428,6 +448,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("ALCATELLUCENT", "3FE46541AA", sfp_quirk_2500basex,
 		  sfp_fixup_long_startup),
 
+	// Fiberstore SFP-10G-T doesn't identify as copper, and uses the
+	// Rollball protocol to talk to the PHY.
+	SFP_QUIRK_F("FS", "SFP-10G-T", sfp_fixup_fs_10gt),
+
 	SFP_QUIRK_F("HALNy", "HL-GSFP", sfp_fixup_halny_gsfp),
 
 	// HG MXPD-483II-F 2.5G supports 2500Base-X, but incorrectly reports
@@ -445,6 +469,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 
+	// Walsun HXSX-ATRC-1 doesn't identify as copper, and uses the
+	// Rollball protocol to talk to the PHY.
+	SFP_QUIRK_F("Walsun", "HXSX-ATRC-1", sfp_fixup_fs_10gt),
+
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
 	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
-- 
2.30.2


