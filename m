Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329203A09F
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 18:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfFHQNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 12:13:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41996 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbfFHQNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 12:13:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so5024553wrl.9
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 09:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2hn8gQ5XKqOZHUfoZCcL1Uq3RCdKIxFQsrGuqnESdjQ=;
        b=cCXkpnXhaeUlcmojQoK9Qm6FFQ4zypuesxEdDxH1XAbeLjS1ns00MoMEAWtXs2BPGX
         yln3DLmtIncEB9jFuwEOFH+svRe41H1CS13Rqs8ByMUuaBanCrc0jbw04gGJjSHsd8m2
         2AviIfCSieIeF+/48KPhMtR14xIW1puI38ZZDr8oIzXzQsJDC64ukdLgeddu5gcxrooJ
         rpbwgqOKw8JmrYJaALLC3SAvZcXN7o5QzqGcock9r30MzUn172TkokIMPLmjVJALfVgv
         mDPpXfatK6jI9J4rKOnoQOk7wt+41ivV0pMjo12ef50dZBdIiUCaW4eSvmnIEJLabgQp
         Yadw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2hn8gQ5XKqOZHUfoZCcL1Uq3RCdKIxFQsrGuqnESdjQ=;
        b=SDW/56vOCjPHLIxw+gPr7nn49AjU7G7a0H4n8vxZqV6xSxFSPrHYrV3OKxQXLw+c3K
         bYBBoliYI1JL3qgvDmi8JZh2yWcXSgnFQ8zHtfR+IpE773gTCgtUHO4oX1pC5tE/RM5d
         sO9tU49OZ5u+i/LQEkQSnKa/KOjUqq6KGNVQ+WoNxkUa3aZ7GOjFUdqmYCMCv4X3pAK7
         QJ1qDx44A4nfuf3gDiEQT+Evqgmd5gnoblZuYVbjhqYb7Ahz6SDvZKi/wm3Y76DT27Ro
         MK3hjZ3RiLwVTmkVFFnwGOy/eEszVHsU+MuHBmoSRKSqFYN6Yrv3eXsU3Z3Y2BhJFaEt
         J+PQ==
X-Gm-Message-State: APjAAAUgKZMYjJ6ZzSBh0OXFvvD6Uy3nqNTNzgvrsz513bX1BOTcYzAR
        xsJ2uY1GHittkyTpic4rvPM=
X-Google-Smtp-Source: APXvYqzjfY+sOZaWX+Pju0pxZzrT0HYJl/CrjesBWQyHDjsJH/tvEp15E+PwJBHCBVriq9r+fsdQpw==
X-Received: by 2002:a5d:6389:: with SMTP id p9mr23211504wru.297.1560010385458;
        Sat, 08 Jun 2019 09:13:05 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id l18sm3934221wrv.38.2019.06.08.09.13.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 09:13:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: sja1105: Add RGMII delay support for P/Q/R/S chips
Date:   Sat,  8 Jun 2019 19:12:28 +0300
Message-Id: <20190608161228.5730-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608161228.5730-1-olteanv@gmail.com>
References: <20190608161228.5730-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per the DT phy-mode specification, RGMII delays are applied by the
MAC when there is no PHY present on the link.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h          |  1 +
 drivers/net/dsa/sja1105/sja1105_clocking.c | 98 +++++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_spi.c      |  5 ++
 3 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index a37ece1b94cf..12cfcae0dc11 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -168,6 +168,7 @@ typedef enum {
 	SJA1105_SPEED_AUTO	= 0,
 } sja1105_speed_t;
 
+int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port);
 int sja1105_clocking_setup_port(struct sja1105_private *priv, int port);
 int sja1105_clocking_setup(struct sja1105_private *priv);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 5c7cea22b647..608126a15d72 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -19,6 +19,17 @@ struct sja1105_cfg_pad_mii_tx {
 	u64 clk_ipud;
 };
 
+struct sja1105_cfg_pad_mii_id {
+	u64 rxc_stable_ovr;
+	u64 rxc_delay;
+	u64 rxc_bypass;
+	u64 rxc_pd;
+	u64 txc_stable_ovr;
+	u64 txc_delay;
+	u64 txc_bypass;
+	u64 txc_pd;
+};
+
 /* UM10944 Table 82.
  * IDIV_0_C to IDIV_4_C control registers
  * (addr. 10000Bh to 10000Fh)
@@ -377,7 +388,84 @@ static int sja1105_rgmii_cfg_pad_tx_config(struct sja1105_private *priv,
 					   packed_buf, SJA1105_SIZE_CGU_CMD);
 }
 
-static int sja1105_rgmii_clocking_setup(struct sja1105_private *priv, int port)
+static void
+sja1105_cfg_pad_mii_id_packing(void *buf, struct sja1105_cfg_pad_mii_id *cmd,
+			       enum packing_op op)
+{
+	const int size = SJA1105_SIZE_CGU_CMD;
+
+	sja1105_packing(buf, &cmd->rxc_stable_ovr, 15, 15, size, op);
+	sja1105_packing(buf, &cmd->rxc_delay,      14, 10, size, op);
+	sja1105_packing(buf, &cmd->rxc_bypass,      9,  9, size, op);
+	sja1105_packing(buf, &cmd->rxc_pd,          8,  8, size, op);
+	sja1105_packing(buf, &cmd->txc_stable_ovr,  7,  7, size, op);
+	sja1105_packing(buf, &cmd->txc_delay,       6,  2, size, op);
+	sja1105_packing(buf, &cmd->txc_bypass,      1,  1, size, op);
+	sja1105_packing(buf, &cmd->txc_pd,          0,  0, size, op);
+}
+
+/* Valid range in degrees is an integer between 73.8 and 101.7 */
+static inline u64 sja1105_rgmii_delay(u64 phase)
+{
+	/* UM11040.pdf: The delay in degree phase is 73.8 + delay_tune * 0.9.
+	 * To avoid floating point operations we'll multiply by 10
+	 * and get 1 decimal point precision.
+	 */
+	phase *= 10;
+	return (phase - 738) / 9;
+}
+
+/* The RGMII delay setup procedure is 2-step and gets called upon each
+ * .phylink_mac_config. Both are strategic.
+ * The reason is that the RX Tunable Delay Line of the SJA1105 MAC has issues
+ * with recovering from a frequency change of the link partner's RGMII clock.
+ * The easiest way to recover from this is to temporarily power down the TDL,
+ * as it will re-lock at the new frequency afterwards.
+ */
+int sja1105pqrs_setup_rgmii_delay(const void *ctx, int port)
+{
+	const struct sja1105_private *priv = ctx;
+	const struct sja1105_regs *regs = priv->info->regs;
+	struct sja1105_cfg_pad_mii_id pad_mii_id = {0};
+	u8 packed_buf[SJA1105_SIZE_CGU_CMD] = {0};
+	int rc;
+
+	if (priv->rgmii_rx_delay[port])
+		pad_mii_id.rxc_delay = sja1105_rgmii_delay(90);
+	if (priv->rgmii_tx_delay[port])
+		pad_mii_id.txc_delay = sja1105_rgmii_delay(90);
+
+	/* Stage 1: Turn the RGMII delay lines off. */
+	pad_mii_id.rxc_bypass = 1;
+	pad_mii_id.rxc_pd = 1;
+	pad_mii_id.txc_bypass = 1;
+	pad_mii_id.txc_pd = 1;
+	sja1105_cfg_pad_mii_id_packing(packed_buf, &pad_mii_id, PACK);
+
+	rc = sja1105_spi_send_packed_buf(priv, SPI_WRITE,
+					 regs->pad_mii_id[port],
+					 packed_buf, SJA1105_SIZE_CGU_CMD);
+	if (rc < 0)
+		return rc;
+
+	/* Stage 2: Turn the RGMII delay lines on. */
+	if (priv->rgmii_rx_delay[port]) {
+		pad_mii_id.rxc_bypass = 0;
+		pad_mii_id.rxc_pd = 0;
+	}
+	if (priv->rgmii_tx_delay[port]) {
+		pad_mii_id.txc_bypass = 0;
+		pad_mii_id.txc_pd = 0;
+	}
+	sja1105_cfg_pad_mii_id_packing(packed_buf, &pad_mii_id, PACK);
+
+	return sja1105_spi_send_packed_buf(priv, SPI_WRITE,
+					   regs->pad_mii_id[port],
+					   packed_buf, SJA1105_SIZE_CGU_CMD);
+}
+
+static int sja1105_rgmii_clocking_setup(struct sja1105_private *priv, int port,
+					sja1105_mii_role_t role)
 {
 	struct device *dev = priv->ds->dev;
 	struct sja1105_mac_config_entry *mac;
@@ -429,6 +517,12 @@ static int sja1105_rgmii_clocking_setup(struct sja1105_private *priv, int port)
 	}
 	if (!priv->info->setup_rgmii_delay)
 		return 0;
+	/* The role has no hardware effect for RGMII. However we use it as
+	 * a proxy for this interface being a MAC-to-MAC connection, with
+	 * the RGMII internal delays needing to be applied by us.
+	 */
+	if (role == XMII_MAC)
+		return 0;
 
 	return priv->info->setup_rgmii_delay(priv, port);
 }
@@ -575,7 +669,7 @@ int sja1105_clocking_setup_port(struct sja1105_private *priv, int port)
 		rc = sja1105_rmii_clocking_setup(priv, port, role);
 		break;
 	case XMII_MODE_RGMII:
-		rc = sja1105_rgmii_clocking_setup(priv, port);
+		rc = sja1105_rgmii_clocking_setup(priv, port, role);
 		break;
 	default:
 		dev_err(dev, "Invalid interface mode specified: %d\n",
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index feb9e0422a68..f7e51debb930 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -531,6 +531,7 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.rgu = 0x100440,
 	/* UM10944.pdf, Table 86, ACU Register overview */
 	.pad_mii_tx = {0x100800, 0x100802, 0x100804, 0x100806, 0x100808},
+	.pad_mii_id = {0x100810, 0x100811, 0x100812, 0x100813, 0x100814},
 	.rmii_pll1 = 0x10000A,
 	.cgu_idiv = {0x10000B, 0x10000C, 0x10000D, 0x10000E, 0x10000F},
 	.mac = {0x200, 0x202, 0x204, 0x206, 0x208},
@@ -587,6 +588,7 @@ struct sja1105_info sja1105p_info = {
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
@@ -601,6 +603,7 @@ struct sja1105_info sja1105q_info = {
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
@@ -615,6 +618,7 @@ struct sja1105_info sja1105r_info = {
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
@@ -630,6 +634,7 @@ struct sja1105_info sja1105s_info = {
 	.regs			= &sja1105pqrs_regs,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
-- 
2.17.1

