Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCBC68BDB0
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjBFNRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjBFNRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3FB23869
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N1-0007TM-Dr
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:19 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 259FC17139E
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:26 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D00BC1712AB;
        Mon,  6 Feb 2023 13:16:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9efcb8a8;
        Mon, 6 Feb 2023 13:16:22 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/47] can: rcar_canfd: Add support for R-Car Gen4
Date:   Mon,  6 Feb 2023 14:15:43 +0100
Message-Id: <20230206131620.2758724-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Despite the name, R-Car V3U (R8A779A0) was the first member of the R-Car
Gen4 family.  Generalize the support for R-Car V3U to other SoCs in the
R-Car Gen4 family by adding a family-specific compatible value, and by
replacing all references to "V3U" by "Gen4".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/61f6f34eb7bcc62ff604add98f1bcd2d2584187d.1674499048.git.geert+renesas@glider.be
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 99 ++++++++++++++++---------------
 1 file changed, 50 insertions(+), 49 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 6bf80cefc307..aa7fcd4a47d3 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -82,8 +82,8 @@
 #define RCANFD_GERFL_DEF		BIT(0)
 
 #define RCANFD_GERFL_ERR(gpriv, x) \
-	((x) & (reg_v3u(gpriv, RCANFD_GERFL_EEF0_7, \
-			RCANFD_GERFL_EEF(0) | RCANFD_GERFL_EEF(1)) | \
+	((x) & (reg_gen4(gpriv, RCANFD_GERFL_EEF0_7, \
+			 RCANFD_GERFL_EEF(0) | RCANFD_GERFL_EEF(1)) | \
 		RCANFD_GERFL_MES | \
 		((gpriv)->fdmode ? RCANFD_GERFL_CMPOF : 0)))
 
@@ -91,16 +91,16 @@
 
 /* RSCFDnCFDGAFLCFG0 / RSCFDnGAFLCFG0 */
 #define RCANFD_GAFLCFG_SETRNC(gpriv, n, x) \
-	(((x) & reg_v3u(gpriv, 0x1ff, 0xff)) << \
-	 (reg_v3u(gpriv, 16, 24) - ((n) & 1) * reg_v3u(gpriv, 16, 8)))
+	(((x) & reg_gen4(gpriv, 0x1ff, 0xff)) << \
+	 (reg_gen4(gpriv, 16, 24) - ((n) & 1) * reg_gen4(gpriv, 16, 8)))
 
 #define RCANFD_GAFLCFG_GETRNC(gpriv, n, x) \
-	(((x) >> (reg_v3u(gpriv, 16, 24) - ((n) & 1) * reg_v3u(gpriv, 16, 8))) & \
-	 reg_v3u(gpriv, 0x1ff, 0xff))
+	(((x) >> (reg_gen4(gpriv, 16, 24) - ((n) & 1) * reg_gen4(gpriv, 16, 8))) & \
+	 reg_gen4(gpriv, 0x1ff, 0xff))
 
 /* RSCFDnCFDGAFLECTR / RSCFDnGAFLECTR */
 #define RCANFD_GAFLECTR_AFLDAE		BIT(8)
-#define RCANFD_GAFLECTR_AFLPN(gpriv, x)	((x) & reg_v3u(gpriv, 0x7f, 0x1f))
+#define RCANFD_GAFLECTR_AFLPN(gpriv, x)	((x) & reg_gen4(gpriv, 0x7f, 0x1f))
 
 /* RSCFDnCFDGAFLIDj / RSCFDnGAFLIDj */
 #define RCANFD_GAFLID_GAFLLB		BIT(29)
@@ -118,13 +118,13 @@
 
 /* RSCFDnCFDCmNCFG - CAN FD only */
 #define RCANFD_NCFG_NTSEG2(gpriv, x) \
-	(((x) & reg_v3u(gpriv, 0x7f, 0x1f)) << reg_v3u(gpriv, 25, 24))
+	(((x) & reg_gen4(gpriv, 0x7f, 0x1f)) << reg_gen4(gpriv, 25, 24))
 
 #define RCANFD_NCFG_NTSEG1(gpriv, x) \
-	(((x) & reg_v3u(gpriv, 0xff, 0x7f)) << reg_v3u(gpriv, 17, 16))
+	(((x) & reg_gen4(gpriv, 0xff, 0x7f)) << reg_gen4(gpriv, 17, 16))
 
 #define RCANFD_NCFG_NSJW(gpriv, x) \
-	(((x) & reg_v3u(gpriv, 0x7f, 0x1f)) << reg_v3u(gpriv, 10, 11))
+	(((x) & reg_gen4(gpriv, 0x7f, 0x1f)) << reg_gen4(gpriv, 10, 11))
 
 #define RCANFD_NCFG_NBRP(x)		(((x) & 0x3ff) << 0)
 
@@ -189,16 +189,16 @@
 #define RCANFD_DCFG_DSJW(x)		(((x) & 0x7) << 24)
 
 #define RCANFD_DCFG_DTSEG2(gpriv, x) \
-	(((x) & reg_v3u(gpriv, 0x0f, 0x7)) << reg_v3u(gpriv, 16, 20))
+	(((x) & reg_gen4(gpriv, 0x0f, 0x7)) << reg_gen4(gpriv, 16, 20))
 
 #define RCANFD_DCFG_DTSEG1(gpriv, x) \
-	(((x) & reg_v3u(gpriv, 0x1f, 0xf)) << reg_v3u(gpriv, 8, 16))
+	(((x) & reg_gen4(gpriv, 0x1f, 0xf)) << reg_gen4(gpriv, 8, 16))
 
 #define RCANFD_DCFG_DBRP(x)		(((x) & 0xff) << 0)
 
 /* RSCFDnCFDCmFDCFG */
-#define RCANFD_V3U_FDCFG_CLOE		BIT(30)
-#define RCANFD_V3U_FDCFG_FDOE		BIT(28)
+#define RCANFD_GEN4_FDCFG_CLOE		BIT(30)
+#define RCANFD_GEN4_FDCFG_FDOE		BIT(28)
 #define RCANFD_FDCFG_TDCE		BIT(9)
 #define RCANFD_FDCFG_TDCOC		BIT(8)
 #define RCANFD_FDCFG_TDCO(x)		(((x) & 0x7f) >> 16)
@@ -233,10 +233,10 @@
 /* Common FIFO bits */
 
 /* RSCFDnCFDCFCCk */
-#define RCANFD_CFCC_CFTML(gpriv, x)	(((x) & 0xf) << reg_v3u(gpriv, 16, 20))
-#define RCANFD_CFCC_CFM(gpriv, x)	(((x) & 0x3) << reg_v3u(gpriv,  8, 16))
+#define RCANFD_CFCC_CFTML(gpriv, x)	(((x) & 0xf) << reg_gen4(gpriv, 16, 20))
+#define RCANFD_CFCC_CFM(gpriv, x)	(((x) & 0x3) << reg_gen4(gpriv,  8, 16))
 #define RCANFD_CFCC_CFIM		BIT(12)
-#define RCANFD_CFCC_CFDC(gpriv, x)	(((x) & 0x7) << reg_v3u(gpriv, 21,  8))
+#define RCANFD_CFCC_CFDC(gpriv, x)	(((x) & 0x7) << reg_gen4(gpriv, 21,  8))
 #define RCANFD_CFCC_CFPLS(x)		(((x) & 0x7) << 4)
 #define RCANFD_CFCC_CFTXIE		BIT(2)
 #define RCANFD_CFCC_CFE			BIT(0)
@@ -304,7 +304,7 @@
 #define RCANFD_RMND(y)			(0x00a8 + (0x04 * (y)))
 
 /* RSCFDnCFDRFCCx / RSCFDnRFCCx */
-#define RCANFD_RFCC(gpriv, x)		(reg_v3u(gpriv, 0x00c0, 0x00b8) + (0x04 * (x)))
+#define RCANFD_RFCC(gpriv, x)		(reg_gen4(gpriv, 0x00c0, 0x00b8) + (0x04 * (x)))
 /* RSCFDnCFDRFSTSx / RSCFDnRFSTSx */
 #define RCANFD_RFSTS(gpriv, x)		(RCANFD_RFCC(gpriv, x) + 0x20)
 /* RSCFDnCFDRFPCTRx / RSCFDnRFPCTRx */
@@ -314,13 +314,13 @@
 
 /* RSCFDnCFDCFCCx / RSCFDnCFCCx */
 #define RCANFD_CFCC(gpriv, ch, idx) \
-	(reg_v3u(gpriv, 0x0120, 0x0118) + (0x0c * (ch)) + (0x04 * (idx)))
+	(reg_gen4(gpriv, 0x0120, 0x0118) + (0x0c * (ch)) + (0x04 * (idx)))
 /* RSCFDnCFDCFSTSx / RSCFDnCFSTSx */
 #define RCANFD_CFSTS(gpriv, ch, idx) \
-	(reg_v3u(gpriv, 0x01e0, 0x0178) + (0x0c * (ch)) + (0x04 * (idx)))
+	(reg_gen4(gpriv, 0x01e0, 0x0178) + (0x0c * (ch)) + (0x04 * (idx)))
 /* RSCFDnCFDCFPCTRx / RSCFDnCFPCTRx */
 #define RCANFD_CFPCTR(gpriv, ch, idx) \
-	(reg_v3u(gpriv, 0x0240, 0x01d8) + (0x0c * (ch)) + (0x04 * (idx)))
+	(reg_gen4(gpriv, 0x0240, 0x01d8) + (0x0c * (ch)) + (0x04 * (idx)))
 
 /* RSCFDnCFDFESTS / RSCFDnFESTS */
 #define RCANFD_FESTS			(0x0238)
@@ -428,15 +428,15 @@
 /* RSCFDnRPGACCr */
 #define RCANFD_C_RPGACC(r)		(0x1900 + (0x04 * (r)))
 
-/* R-Car V3U Classical and CAN FD mode specific register map */
-#define RCANFD_V3U_FDCFG(m)		(0x1404 + (0x20 * (m)))
+/* R-Car Gen4 Classical and CAN FD mode specific register map */
+#define RCANFD_GEN4_FDCFG(m)		(0x1404 + (0x20 * (m)))
 
-#define RCANFD_V3U_GAFL_OFFSET		(0x1800)
+#define RCANFD_GEN4_GAFL_OFFSET		(0x1800)
 
 /* CAN FD mode specific register map */
 
 /* RSCFDnCFDCmXXX -> RCANFD_F_XXX(m) */
-#define RCANFD_F_DCFG(gpriv, m)		(reg_v3u(gpriv, 0x1400, 0x0500) + (0x20 * (m)))
+#define RCANFD_F_DCFG(gpriv, m)		(reg_gen4(gpriv, 0x1400, 0x0500) + (0x20 * (m)))
 #define RCANFD_F_CFDCFG(m)		(0x0504 + (0x20 * (m)))
 #define RCANFD_F_CFDCTR(m)		(0x0508 + (0x20 * (m)))
 #define RCANFD_F_CFDSTS(m)		(0x050c + (0x20 * (m)))
@@ -452,7 +452,7 @@
 #define RCANFD_F_RMDF(q, b)		(0x200c + (0x04 * (b)) + (0x20 * (q)))
 
 /* RSCFDnCFDRFXXx -> RCANFD_F_RFXX(x) */
-#define RCANFD_F_RFOFFSET(gpriv)	reg_v3u(gpriv, 0x6000, 0x3000)
+#define RCANFD_F_RFOFFSET(gpriv)	reg_gen4(gpriv, 0x6000, 0x3000)
 #define RCANFD_F_RFID(gpriv, x)		(RCANFD_F_RFOFFSET(gpriv) + (0x80 * (x)))
 #define RCANFD_F_RFPTR(gpriv, x)	(RCANFD_F_RFOFFSET(gpriv) + 0x04 + (0x80 * (x)))
 #define RCANFD_F_RFFDSTS(gpriv, x)	(RCANFD_F_RFOFFSET(gpriv) + 0x08 + (0x80 * (x)))
@@ -460,7 +460,7 @@
 	(RCANFD_F_RFOFFSET(gpriv) + 0x0c + (0x80 * (x)) + (0x04 * (df)))
 
 /* RSCFDnCFDCFXXk -> RCANFD_F_CFXX(ch, k) */
-#define RCANFD_F_CFOFFSET(gpriv)	reg_v3u(gpriv, 0x6400, 0x3400)
+#define RCANFD_F_CFOFFSET(gpriv)	reg_gen4(gpriv, 0x6400, 0x3400)
 
 #define RCANFD_F_CFID(gpriv, ch, idx) \
 	(RCANFD_F_CFOFFSET(gpriv) + (0x180 * (ch)) + (0x80 * (idx)))
@@ -596,28 +596,28 @@ static const struct rcar_canfd_hw_info rcar_gen3_hw_info = {
 	.shared_global_irqs = 1,
 };
 
+static const struct rcar_canfd_hw_info rcar_gen4_hw_info = {
+	.max_channels = 8,
+	.postdiv = 2,
+	.shared_global_irqs = 1,
+};
+
 static const struct rcar_canfd_hw_info rzg2l_hw_info = {
 	.max_channels = 2,
 	.postdiv = 1,
 	.multi_channel_irqs = 1,
 };
 
-static const struct rcar_canfd_hw_info r8a779a0_hw_info = {
-	.max_channels = 8,
-	.postdiv = 2,
-	.shared_global_irqs = 1,
-};
-
 /* Helper functions */
-static inline bool is_v3u(struct rcar_canfd_global *gpriv)
+static inline bool is_gen4(struct rcar_canfd_global *gpriv)
 {
-	return gpriv->info == &r8a779a0_hw_info;
+	return gpriv->info == &rcar_gen4_hw_info;
 }
 
-static inline u32 reg_v3u(struct rcar_canfd_global *gpriv,
-			  u32 v3u, u32 not_v3u)
+static inline u32 reg_gen4(struct rcar_canfd_global *gpriv,
+			   u32 gen4, u32 not_gen4)
 {
-	return is_v3u(gpriv) ? v3u : not_v3u;
+	return is_gen4(gpriv) ? gen4 : not_gen4;
 }
 
 static inline void rcar_canfd_update(u32 mask, u32 val, u32 __iomem *reg)
@@ -687,13 +687,13 @@ static void rcar_canfd_tx_failure_cleanup(struct net_device *ndev)
 
 static void rcar_canfd_set_mode(struct rcar_canfd_global *gpriv)
 {
-	if (is_v3u(gpriv)) {
-		u32 ch, val = gpriv->fdmode ? RCANFD_V3U_FDCFG_FDOE
-					    : RCANFD_V3U_FDCFG_CLOE;
+	if (is_gen4(gpriv)) {
+		u32 ch, val = gpriv->fdmode ? RCANFD_GEN4_FDCFG_FDOE
+					    : RCANFD_GEN4_FDCFG_CLOE;
 
 		for_each_set_bit(ch, &gpriv->channels_mask,
 				 gpriv->info->max_channels)
-			rcar_canfd_set_bit(gpriv->base, RCANFD_V3U_FDCFG(ch),
+			rcar_canfd_set_bit(gpriv->base, RCANFD_GEN4_FDCFG(ch),
 					   val);
 	} else {
 		if (gpriv->fdmode)
@@ -814,8 +814,8 @@ static void rcar_canfd_configure_afl_rules(struct rcar_canfd_global *gpriv,
 	/* Write number of rules for channel */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLCFG(ch),
 			   RCANFD_GAFLCFG_SETRNC(gpriv, ch, num_rules));
-	if (is_v3u(gpriv))
-		offset = RCANFD_V3U_GAFL_OFFSET;
+	if (is_gen4(gpriv))
+		offset = RCANFD_GEN4_GAFL_OFFSET;
 	else if (gpriv->fdmode)
 		offset = RCANFD_F_GAFL_OFFSET;
 	else
@@ -1350,7 +1350,7 @@ static void rcar_canfd_set_bittiming(struct net_device *dev)
 			   brp, sjw, tseg1, tseg2);
 	} else {
 		/* Classical CAN only mode */
-		if (is_v3u(gpriv)) {
+		if (is_gen4(gpriv)) {
 			cfg = (RCANFD_NCFG_NTSEG1(gpriv, tseg1) |
 			       RCANFD_NCFG_NBRP(brp) |
 			       RCANFD_NCFG_NSJW(gpriv, sjw) |
@@ -1507,7 +1507,7 @@ static netdev_tx_t rcar_canfd_start_xmit(struct sk_buff *skb,
 
 	dlc = RCANFD_CFPTR_CFDLC(can_fd_len2dlc(cf->len));
 
-	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) || is_v3u(gpriv)) {
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) || is_gen4(gpriv)) {
 		rcar_canfd_write(priv->base,
 				 RCANFD_F_CFID(gpriv, ch, RCANFD_CFFIFO_IDX), id);
 		rcar_canfd_write(priv->base,
@@ -1566,7 +1566,7 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 	u32 ch = priv->channel;
 	u32 ridx = ch + RCANFD_RFFIFO_IDX;
 
-	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) || is_v3u(gpriv)) {
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_FD) || is_gen4(gpriv)) {
 		id = rcar_canfd_read(priv->base, RCANFD_F_RFID(gpriv, ridx));
 		dlc = rcar_canfd_read(priv->base, RCANFD_F_RFPTR(gpriv, ridx));
 
@@ -1617,7 +1617,7 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
 		cf->len = can_cc_dlc2len(RCANFD_RFPTR_RFDLC(dlc));
 		if (id & RCANFD_RFID_RFRTR)
 			cf->can_id |= CAN_RTR_FLAG;
-		else if (is_v3u(gpriv))
+		else if (is_gen4(gpriv))
 			rcar_canfd_get_data(priv, cf, RCANFD_F_RFDF(gpriv, ridx, 0));
 		else
 			rcar_canfd_get_data(priv, cf, RCANFD_C_RFDF(ridx, 0));
@@ -2096,9 +2096,10 @@ static SIMPLE_DEV_PM_OPS(rcar_canfd_pm_ops, rcar_canfd_suspend,
 			 rcar_canfd_resume);
 
 static const __maybe_unused struct of_device_id rcar_canfd_of_table[] = {
+	{ .compatible = "renesas,r8a779a0-canfd", .data = &rcar_gen4_hw_info },
 	{ .compatible = "renesas,rcar-gen3-canfd", .data = &rcar_gen3_hw_info },
+	{ .compatible = "renesas,rcar-gen4-canfd", .data = &rcar_gen4_hw_info },
 	{ .compatible = "renesas,rzg2l-canfd", .data = &rzg2l_hw_info },
-	{ .compatible = "renesas,r8a779a0-canfd", .data = &r8a779a0_hw_info },
 	{ }
 };
 
-- 
2.39.1


