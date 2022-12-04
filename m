Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745C2641A6D
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 03:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiLDCcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 21:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiLDCcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 21:32:02 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA0317045;
        Sat,  3 Dec 2022 18:32:00 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l11so11349783edb.4;
        Sat, 03 Dec 2022 18:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HU9K/uU2O96BLqORVMH8PciVr3ArBlQTaW+uVE80HNo=;
        b=j4YtYNqrdTgzxx2Apr9zU8rA4GDtx13v1qsj/6xmckj/UVAq5bAn4bFtrkMX6MYe9u
         yZ5HZp21T4tRz6vElABjgIcjsjacKeh8IIM3UbBKBDA4DkfOniAAD2BZ5ZQ5Ui9BsoSl
         rPXkubBYi6L1zrts/8MVpgFIWzcKkKT8gt0h74zWY6bgPbVqllhyhSw9QHauB1CeMeOG
         oAEQBsPD+Dnpy+k1+DbVZpt8HvUdczY4yeMGBfldttvu3lFCjHfVdNkXYKbOFEnNXohE
         a4q/7lO3oeDIdrAlRMt6MRPel4tu4H58Nc5PLqkVUHb/agm8GFZes4HwL/B4fwgpOUT2
         tFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HU9K/uU2O96BLqORVMH8PciVr3ArBlQTaW+uVE80HNo=;
        b=dj7EgMxsZw6YCWb2MVC4Hv0S41IB8BZrVgp2x9xyvrvhQ5afcjXYkk0KMIxnqmzcRc
         RgzKBCQD/0+5PI4ISbYL93UiHzqgRGwiv41111WRik0N9uPDAI+wqNA0/6DoicCPUal9
         TQGZCSv8jiDd0s2t1vVcR8OBCXUK4sX6Q42juucdrIwT35ZWtQZb3zNe26GofOGUA6bN
         J+0u2uU5MI0PMar4jKHZ9PfJvgJLWKkiCAaCwVwBJoShCkOst4ZWqfhCGOxMsWNeEIjW
         dGNK+RcgoI2JpiJc5OhOwVhpZPHgJrsi36qiRImiWZ0SR+44BNwxA6pu6utcfKJNIVIK
         fwkA==
X-Gm-Message-State: ANoB5pkbDjpAQEbtabevROndayDUCfOri1BFagdlFAp6+gpwxjxdqUUL
        NPD/lkJVVsuMNNEi7/LvXlQ=
X-Google-Smtp-Source: AA0mqf5X9b44CPLo/1rp3Qi9p10wLdvIsu8JzXbZDhLb7nRTDrh9gNvAewFemo7vjn85lX09Onwt3w==
X-Received: by 2002:a05:6402:1045:b0:461:68e1:ced5 with SMTP id e5-20020a056402104500b0046168e1ced5mr4308387edu.142.1670121119268;
        Sat, 03 Dec 2022 18:31:59 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id f23-20020a17090631d700b007add62dafbasm4630814ejf.157.2022.12.03.18.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 18:31:58 -0800 (PST)
Date:   Sun, 4 Dec 2022 03:32:06 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next 4/4] driver/ncn26000: add PLCA support
Message-ID: <38623984f6235a1521e6b0ad2ea958abc84ad708.1670119328.git.piergiorgio.beruto@gmail.com>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds PLCA support to the ncn26000 driver. Also add helper
functions to read/write standard OPEN Alliance PLCA registers to
phylib (genphy_c45_plca_get_cfg, genphy_c45_plca_set_cfg,
genphy_c45_plca_get_status).

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 drivers/net/phy/ncn26000.c |  20 +++-
 drivers/net/phy/phy-c45.c  | 187 +++++++++++++++++++++++++++++++++++++
 include/linux/phy.h        |  10 +-
 include/uapi/linux/mdio.h  |  31 ++++++
 net/ethtool/plca.c         |   2 +-
 5 files changed, 245 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/ncn26000.c b/drivers/net/phy/ncn26000.c
index 65a34edc5b20..39197823cf16 100644
--- a/drivers/net/phy/ncn26000.c
+++ b/drivers/net/phy/ncn26000.c
@@ -27,14 +27,27 @@
 #define NCN26000_IRQ_PLCAREC_BIT                ((u16)(1 << 4))
 #define NCN26000_IRQ_PHYSCOL_BIT                ((u16)(1 << 5))
 
+#define TO_TMR_DEFAULT				((u16)32)
+
 struct ncn26000_priv {
 	u16 enabled_irqs;
 };
 
 static int ncn26000_config_init(struct phy_device *phydev)
 {
-	// TODO: add vendor-specific tuning (ENI, CMC, ...)
-	return 0;
+	int ret;
+
+	/* HW bug workaround: the default value of the PLCA TO_TIMER should be
+	 * 32, where the current version of NCN26000 reports 24. This will be
+	 * fixed in future PHY versions. For the time being, we force the right
+	 * default here.
+	 */
+	ret = phy_write_mmd(phydev,
+			    MDIO_MMD_OATC14,
+			    MDIO_OATC14_PLCA_TOTMR,
+			    TO_TMR_DEFAULT);
+
+	return ret;
 }
 
 static int ncn26000_enable(struct phy_device *phydev)
@@ -177,6 +190,9 @@ static struct phy_driver ncn26000_driver[] = {
 		.config_intr            = ncn26000_config_intr,
 		.config_aneg		= ncn26000_enable,
 		.handle_interrupt       = ncn26000_handle_interrupt,
+		.get_plca_cfg		= genphy_c45_plca_get_cfg,
+		.set_plca_cfg		= genphy_c45_plca_set_cfg,
+		.get_plca_status	= genphy_c45_plca_get_status,
 	},
 };
 
diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index a87a4b3ffce4..9ed3b6858103 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -931,6 +931,193 @@ int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_fast_retrain);
 
+/**
+ * genphy_c45_plca_get_cfg - get PLCA configuration from standard registers
+ * @phydev: target phy_device struct
+ * @plca_cfg: output structure to store the PLCA configuration
+ *
+ * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
+ *   Management Registers specifications, this function can be used to retrieve
+ *   the current PLCA configuration from the standard registers in MMD 31.
+ */
+int genphy_c45_plca_get_cfg(struct phy_device *phydev,
+			    struct phy_plca_cfg *plca_cfg)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_IDVER);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->version = (u32)ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_CTRL0);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->enabled = !!(((u16)ret) & MDIO_OATC14_PLCA_EN);
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_CTRL1);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->node_cnt = (((u16)ret) & MDIO_OATC14_PLCA_NCNT) >> 8;
+	plca_cfg->node_id = (((u16)ret) & MDIO_OATC14_PLCA_ID);
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_TOTMR);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->to_tmr = (u16)ret & MDIO_OATC14_PLCA_TOT;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_BURST);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->burst_cnt = (((u16)ret) & MDIO_OATC14_PLCA_MAXBC) >> 8;
+	plca_cfg->burst_tmr = (((u16)ret) & MDIO_OATC14_PLCA_BTMR);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_plca_get_cfg);
+
+/**
+ * genphy_c45_plca_set_cfg - set PLCA configuration using standard registers
+ * @phydev: target phy_device struct
+ * @plca_cfg: structure containing the PLCA configuration. Fields set to -1 are
+ * not to be changed.
+ *
+ * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
+ *   Management Registers specifications, this function can be used to modify
+ *   the PLCA configuration using the standard registers in MMD 31.
+ */
+int genphy_c45_plca_set_cfg(struct phy_device *phydev,
+			    const struct phy_plca_cfg *plca_cfg)
+{
+	int ret;
+	u16 val;
+
+	// PLCA IDVER is read-only
+	if (plca_cfg->version >= 0)
+		return -EINVAL;
+
+	// first of all, disable PLCA if required
+	if (plca_cfg->enabled == 0) {
+		ret = phy_clear_bits_mmd(phydev,
+					 MDIO_MMD_OATC14,
+					 MDIO_OATC14_PLCA_CTRL0,
+					 MDIO_OATC14_PLCA_EN);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (plca_cfg->node_cnt >= 0 || plca_cfg->node_id >= 0) {
+		if (plca_cfg->node_cnt < 0 || plca_cfg->node_id < 0) {
+			ret = phy_read_mmd(phydev,
+					   MDIO_MMD_OATC14,
+					   MDIO_OATC14_PLCA_CTRL1);
+
+			if (ret < 0)
+				return ret;
+
+			val = (u16)ret;
+		}
+
+		if (plca_cfg->node_cnt >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_NCNT) |
+			      (u16)(plca_cfg->node_cnt << 8);
+
+		if (plca_cfg->node_id >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_ID) |
+			      (u16)(plca_cfg->node_id);
+
+		ret = phy_write_mmd(phydev,
+				    MDIO_MMD_OATC14,
+				    MDIO_OATC14_PLCA_CTRL1,
+				    val);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (plca_cfg->to_tmr >= 0) {
+		ret = phy_write_mmd(phydev,
+				    MDIO_MMD_OATC14,
+				    MDIO_OATC14_PLCA_TOTMR,
+				    (u16)plca_cfg->to_tmr);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (plca_cfg->burst_cnt >= 0 || plca_cfg->burst_tmr >= 0) {
+		if (plca_cfg->burst_cnt < 0 || plca_cfg->burst_tmr < 0) {
+			ret = phy_read_mmd(phydev,
+					   MDIO_MMD_OATC14,
+					   MDIO_OATC14_PLCA_BURST);
+
+			if (ret < 0)
+				return ret;
+
+			val = (u16)ret;
+		}
+
+		if (plca_cfg->burst_cnt >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_MAXBC) |
+			      (u16)(plca_cfg->burst_cnt << 8);
+
+		if (plca_cfg->burst_tmr >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_BTMR) |
+			      (u16)(plca_cfg->burst_tmr);
+
+		ret = phy_write_mmd(phydev,
+				    MDIO_MMD_OATC14,
+				    MDIO_OATC14_PLCA_BURST,
+				    val);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	// if we need to enable PLCA, do it at the end
+	if (plca_cfg->enabled > 0) {
+		ret = phy_set_bits_mmd(phydev,
+				       MDIO_MMD_OATC14,
+				       MDIO_OATC14_PLCA_CTRL0,
+				       MDIO_OATC14_PLCA_EN);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_plca_set_cfg);
+
+/**
+ * genphy_c45_plca_get_status - get PLCA status from standard registers
+ * @phydev: target phy_device struct
+ * @plca_st: output structure to store the PLCA status
+ *
+ * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
+ *   Management Registers specifications, this function can be used to retrieve
+ *   the current PLCA status information from the standard registers in MMD 31.
+ */
+int genphy_c45_plca_get_status(struct phy_device *phydev,
+			       struct phy_plca_status *plca_st)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_STATUS);
+	if (ret < 0)
+		return ret;
+
+	plca_st->pst = !!(((u16)ret) & MDIO_OATC14_PLCA_PST);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_plca_get_status);
+
 struct phy_driver genphy_c45_driver = {
 	.phy_id         = 0xffffffff,
 	.phy_id_mask    = 0xffffffff,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2dfb85c6e596..4548c8e8f6a9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -811,7 +811,7 @@ struct phy_plca_cfg {
  * struct phy_plca_status - Status of the PLCA (Physical Layer Collision
  * Avoidance) Reconciliation Sublayer.
  *
- * @status: The PLCA status as reported by the PST bit in the PLCA STATUS
+ * @pst: The PLCA status as reported by the PST bit in the PLCA STATUS
  *	register(31.CA03), indicating BEACON activity.
  *
  * A structure containing status information of the PLCA RS configuration.
@@ -819,7 +819,7 @@ struct phy_plca_cfg {
  * what is actually used.
  */
 struct phy_plca_status {
-	bool status;
+	bool pst;
 };
 
 /**
@@ -1745,6 +1745,12 @@ int genphy_c45_loopback(struct phy_device *phydev, bool enable);
 int genphy_c45_pma_resume(struct phy_device *phydev);
 int genphy_c45_pma_suspend(struct phy_device *phydev);
 int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable);
+int genphy_c45_plca_get_cfg(struct phy_device *phydev,
+			    struct phy_plca_cfg *plca_cfg);
+int genphy_c45_plca_set_cfg(struct phy_device *phydev,
+			    const struct phy_plca_cfg *plca_cfg);
+int genphy_c45_plca_get_status(struct phy_device *phydev,
+			       struct phy_plca_status *plca_st);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 75b7257a51e1..a9f166c511c0 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -26,6 +26,7 @@
 #define MDIO_MMD_C22EXT		29	/* Clause 22 extension */
 #define MDIO_MMD_VEND1		30	/* Vendor specific 1 */
 #define MDIO_MMD_VEND2		31	/* Vendor specific 2 */
+#define MDIO_MMD_OATC14		MDIO_MMD_VEND2
 
 /* Generic MDIO registers. */
 #define MDIO_CTRL1		MII_BMCR
@@ -89,6 +90,14 @@
 #define MDIO_PMA_LASI_TXSTAT	0x9004	/* TX_ALARM status */
 #define MDIO_PMA_LASI_STAT	0x9005	/* LASI status */
 
+/* Open Alliance TC14 registers */
+#define MDIO_OATC14_PLCA_IDVER	0xca00  /* PLCA ID and version */
+#define MDIO_OATC14_PLCA_CTRL0	0xca01	/* PLCA Control register 0 */
+#define MDIO_OATC14_PLCA_CTRL1	0xca02	/* PLCA Control register 1 */
+#define MDIO_OATC14_PLCA_STATUS	0xca03	/* PLCA Status register */
+#define MDIO_OATC14_PLCA_TOTMR	0xca04	/* PLCA TO Timer register */
+#define MDIO_OATC14_PLCA_BURST	0xca05	/* PLCA BURST mode register */
+
 /* Control register 1. */
 /* Enable extended speed selection */
 #define MDIO_CTRL1_SPEEDSELEXT		(BMCR_SPEED1000 | BMCR_SPEED100)
@@ -436,4 +445,26 @@ static inline __u16 mdio_phy_id_c45(int prtad, int devad)
 #define MDIO_USXGMII_5000FULL		0x1a00	/* 5000Mbps full-duplex */
 #define MDIO_USXGMII_LINK		0x8000	/* PHY link with copper-side partner */
 
+/* Open Alliance TC14 PLCA IDVER register */
+#define MDIO_OATC14_PLCA_IDM		0xff00	/* PLCA MAP ID */
+#define MDIO_OATC14_PLCA_VER		0x00ff	/* PLCA MAP version */
+
+/* Open Alliance TC14 PLCA CTRL0 register */
+#define MDIO_OATC14_PLCA_EN		0x8000  /* PLCA enable */
+#define MDIO_OATC14_PLCA_RST		0x4000  /* PLCA reset */
+
+/* Open Alliance TC14 PLCA CTRL1 register */
+#define MDIO_OATC14_PLCA_NCNT		0xff00	/* PLCA node count */
+#define MDIO_OATC14_PLCA_ID		0x00ff	/* PLCA local node ID */
+
+/* Open Alliance TC14 PLCA STATUS register */
+#define MDIO_OATC14_PLCA_PST		0x8000	/* PLCA status indication */
+
+/* Open Alliance TC14 PLCA TOTMR register */
+#define MDIO_OATC14_PLCA_TOT		0x00ff
+
+/* Open Alliance TC14 PLCA BURST register */
+#define MDIO_OATC14_PLCA_MAXBC		0xff00
+#define MDIO_OATC14_PLCA_BTMR		0x00ff
+
 #endif /* _UAPI__LINUX_MDIO_H__ */
diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
index 371d8098225e..ab50d8b48bd6 100644
--- a/net/ethtool/plca.c
+++ b/net/ethtool/plca.c
@@ -269,7 +269,7 @@ static int plca_get_status_fill_reply(struct sk_buff *skb,
 				      const struct ethnl_reply_data *reply_base)
 {
 	const struct plca_reply_data *data = PLCA_REPDATA(reply_base);
-	const u8 status = data->plca_st.status;
+	const u8 status = data->plca_st.pst;
 
 	if (nla_put_u8(skb, ETHTOOL_A_PLCA_STATUS, !!status))
 		return -EMSGSIZE;
-- 
2.35.1

