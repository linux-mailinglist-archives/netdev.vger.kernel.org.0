Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6752D42B1F1
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbhJMBSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbhJMBSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:33 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D356EC06174E;
        Tue, 12 Oct 2021 18:16:30 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y12so3215214eda.4;
        Tue, 12 Oct 2021 18:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nv0JI2Yi8F4ugKm2nq2I47PKUAQY85Q9w+53j/w2fIA=;
        b=JA7NRxTB8H/hd+hnPyTXgsECCFdvW5PaPq6oNUl9/vpxHBPcWIDiK+7Q+FH9NdFbJ+
         9C/U4JmxJw+DlLqTta8FssMr2gYitII0NFxhE699tEbn3sBTxKYtdanceUj26Fplg1g7
         94IWAY8sueel1RJsf+Z1bFPpHGhCyIek/y060Aylvg046BcyNUbzxcWk8c5oOo7kHbfe
         +tMBD576XajYPEHid9hfqIA7WOXBoxwC3wSz7MRQxgNLHQa17Blc/57XFf6+Dh0sL2KR
         H2Dc2VfzhktYTL7M8PUALb+UWWF04SvYCHkV3Pd00p92VgcPNnbWnuIbCwPHo00eGTlw
         hgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nv0JI2Yi8F4ugKm2nq2I47PKUAQY85Q9w+53j/w2fIA=;
        b=6u8yKXBc9yMXQ3QF6gbN65RSd/RHG40dJUIM7jYqyrpOAT7FEgDYrF/qx2eMhWj4h4
         vhNI4WAHww++GZD+t++oJEXbk0Qj1kwURza1fwdlLnVbtXkC5gLJT9efzL/ikjG9B9a2
         hyqX09Ej6vzKg7cF2Ao7AgHZ5wCKSw47DCBLbnL5ygMAde7EqPrrssVEpqbMBtmF9Uw9
         8ENMv5Wfvreg16f+i3L74IVBlsKkxuPsQSEa3F2W2mj2VlItEM1511yQEZZVSlGJvWya
         NCS5oMdLlI9HWOZqyJCbDb61bsnQsod9BGFW1o2bFrL+um1LIIpKTZnHDQyk6t3oMaQj
         X3QA==
X-Gm-Message-State: AOAM532TKFEns9EHtz9RMdj5LRK8K3v+/1xHgm6fIMYVXvC4Z7N4Hqbd
        ekJuDg4heRc3pnv8PnSJtKU=
X-Google-Smtp-Source: ABdhPJwAUsZ0f9WAAqySWpJ0c7cdAGtRwoKzO7CVWYXl1fh5QCkfCOw/rylQ/h6j+Smy2aXq0REwqA==
X-Received: by 2002:a17:906:d0ca:: with SMTP id bq10mr37891812ejb.25.1634087789341;
        Tue, 12 Oct 2021 18:16:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:29 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v6 03/16] net: dsa: qca8k: add support for sgmii falling edge
Date:   Wed, 13 Oct 2021 03:16:09 +0200
Message-Id: <20211013011622.10537-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for this in the qca8k driver. Also add support for SGMII
rx/tx clock falling edge. This is only present for pad0, pad5 and
pad6 have these bit reserved from Documentation. Add a comment that this
is hardcoded to PAD0 as qca8327/28/34/37 have an unique sgmii line and
setting falling in port0 applies to both configuration with sgmii used
for port0 or port6.

Co-developed-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 63 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  4 +++
 2 files changed, 67 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a892b897cd0d..22d6e4abb986 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -977,6 +977,42 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 	return ret;
 }
 
+static int
+qca8k_parse_port_config(struct qca8k_priv *priv)
+{
+	struct device_node *port_dn;
+	phy_interface_t mode;
+	struct dsa_port *dp;
+	int port, ret;
+
+	/* We have 2 CPU port. Check them */
+	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
+		/* Skip every other port */
+		if (port != 0 && port != 6)
+			continue;
+
+		dp = dsa_to_port(priv->ds, port);
+		port_dn = dp->dn;
+
+		if (!of_device_is_available(port_dn))
+			continue;
+
+		ret = of_get_phy_mode(port_dn, &mode);
+		if (ret)
+			continue;
+
+		if (mode == PHY_INTERFACE_MODE_SGMII) {
+			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
+				priv->sgmii_tx_clk_falling_edge = true;
+
+			if (of_property_read_bool(port_dn, "qca,sgmii-rxclk-falling-edge"))
+				priv->sgmii_rx_clk_falling_edge = true;
+		}
+	}
+
+	return 0;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -990,6 +1026,11 @@ qca8k_setup(struct dsa_switch *ds)
 		return -EINVAL;
 	}
 
+	/* Parse CPU port config to be later used in phy_link mac_config */
+	ret = qca8k_parse_port_config(priv);
+	if (ret)
+		return ret;
+
 	mutex_init(&priv->reg_mutex);
 
 	/* Start by setting up the register mapping */
@@ -1274,6 +1315,28 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		}
 
 		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
+
+		/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
+		 * falling edge is set writing in the PORT0 PAD reg
+		 */
+		if (priv->switch_id == QCA8K_ID_QCA8327 ||
+		    priv->switch_id == QCA8K_ID_QCA8337)
+			reg = QCA8K_REG_PORT0_PAD_CTRL;
+
+		val = 0;
+
+		/* SGMII Clock phase configuration */
+		if (priv->sgmii_rx_clk_falling_edge)
+			val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
+
+		if (priv->sgmii_tx_clk_falling_edge)
+			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
+
+		if (val)
+			ret = qca8k_rmw(priv, reg,
+					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
+					val);
 		break;
 	default:
 		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index fc7db94cc0c9..bc9c89dd7e71 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -35,6 +35,8 @@
 #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
 #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
+#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
+#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
@@ -260,6 +262,8 @@ struct qca8k_priv {
 	u8 switch_revision;
 	u8 rgmii_tx_delay;
 	u8 rgmii_rx_delay;
+	bool sgmii_rx_clk_falling_edge;
+	bool sgmii_tx_clk_falling_edge;
 	bool legacy_phy_port_mapping;
 	struct regmap *regmap;
 	struct mii_bus *bus;
-- 
2.32.0

