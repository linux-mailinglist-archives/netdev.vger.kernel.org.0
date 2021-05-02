Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0003370F9A
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhEBXIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhEBXIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:18 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6349C06138C;
        Sun,  2 May 2021 16:07:25 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id w3so5208829ejc.4;
        Sun, 02 May 2021 16:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lYqK9YRHHnuGkI9ulk7v00/heYAj9vUyZJDfP5lfq/E=;
        b=DSn686F0VV+As8BCUFt+ee8I30sHDQ/cKmQkeeC+h5AF5znHnFLMOHRli8ao8kE2cA
         JjqbnRqs6qegicG8hckc8W7zly5FKLNfFp3U4EZfX6mOYbegoL15YTbJjdSMBZV1OXt2
         4v0vxG8MSMyvEdwrekfLwlmef6hBgMw0FIsd4jH5zZiBN1NnVWlzI+Sar3pFrgNEMIYL
         NYfIHNz+N4TlGt61hwXZxZP48m0DD0kc4fNuJGazrUl7g8Q15MmHO5u6E4I4gXyPlsjl
         1NrBZYRBWRhJJkSaAiM2f8z+UKUWXNgF3LlMG4JxRLhG6wlL0tKIFxLxu8rADG1IQJLq
         joNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lYqK9YRHHnuGkI9ulk7v00/heYAj9vUyZJDfP5lfq/E=;
        b=JpUJRt/7ypNH+m509gnwpvzQWGYvuutnA6ZLyDNY1/iUmd78t5+I3/dmr6LoDctmEF
         DC+scqA3re/FJMTn0dVL0XxfjwaA3Ms0czf/N3P5jwzucbwEpx9aHUXoNzXYW5ktzbBm
         aWiI9YjKKWHAZgo3fKu0hdNKz0dyFk1cANIs3v2QwT7Vo9nibV3rwY/rV16682AwOMkh
         bFk8V/5HQ53Jw8v8Cg5GGv2TzMi1ffivu9cncWSKKXaRxnDHzjC07GZeAg7dXW88kmmR
         rctJGAKGcuPXJdB5sbbiiIacYgpFMssIEBYEleq7VvJaaBsdk8ZmuFBVwrwesgfoOZcL
         ms2w==
X-Gm-Message-State: AOAM5316UY1AABcWmK5ho1+rmDeprQbFpmgOyYb1ECz9hu3Y2yullmyP
        EmP5qmztLBJpvMo7OozM1II=
X-Google-Smtp-Source: ABdhPJxIBu9icU4XjQflnbajhqLlKeqgDfwnMHMSOFujSvNYaEXs1uS+09TJ/coa+/fwdxDidqfcqw==
X-Received: by 2002:a17:906:a10e:: with SMTP id t14mr13960271ejy.103.1619996844518;
        Sun, 02 May 2021 16:07:24 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:24 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 10/17] net: dsa: qca8k: make rgmii delay configurable
Date:   Mon,  3 May 2021 01:07:02 +0200
Message-Id: <20210502230710.30676-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The legacy qsdk code used a different delay instead of the max value.
Qsdk use 1 ps for rx and 2 ps for tx. Make these values configurable
using the standard rx/tx-internal-delay-ps ethernet binding and apply
qsdk values by default. The connected gmac doesn't add any delay so no
additional delay is added to tx/rx.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 51 +++++++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/qca8k.h | 11 +++++----
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5478bee39c6e..d522398d504e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -763,6 +763,47 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 	return 0;
 }
 
+static int
+qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
+{
+	struct device_node *ports, *port;
+	u32 val;
+
+	ports = of_get_child_by_name(priv->dev->of_node, "ports");
+	if (!ports)
+		return -EINVAL;
+
+	/* Assume only one port with rgmii-id mode */
+	for_each_available_child_of_node(ports, port) {
+		if (!of_property_match_string(port, "phy-mode", "rgmii-id"))
+			continue;
+
+		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
+			val = 2;
+
+		if (val > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii rx delay is limited to more than 3ps, setting to the max value");
+			priv->rgmii_rx_delay = 3;
+		} else {
+			priv->rgmii_rx_delay = val;
+		}
+
+		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
+			val = 1;
+
+		if (val > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii tx delay is limited to more than 3ps, setting to the max value");
+			priv->rgmii_tx_delay = 3;
+		} else {
+			priv->rgmii_rx_delay = val;
+		}
+	}
+
+	of_node_put(ports);
+
+	return 0;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -792,6 +833,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_of_rgmii_delay(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
@@ -1003,8 +1048,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		 */
 		qca8k_write(priv, reg,
 			    QCA8K_PORT_PAD_RGMII_EN |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY(priv->rgmii_tx_delay) |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY(priv->rgmii_rx_delay) |
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		/* QCA8337 requires to set rgmii rx delay */
 		if (data->id == QCA8K_ID_QCA8337)
 			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 0b503f78bf92..80830bb42736 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -36,12 +36,11 @@
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
-#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		\
-						((0x8 + (x & 0x3)) << 22)
-#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		\
-						((0x10 + (x & 0x3)) << 20)
-#define   QCA8K_MAX_DELAY				3
+#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		((x) << 22)
+#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		((x) << 20)
+#define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
+#define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_PWS					0x010
 #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
@@ -251,6 +250,8 @@ struct qca8k_match_data {
 
 struct qca8k_priv {
 	u8 switch_revision;
+	u8 rgmii_tx_delay;
+	u8 rgmii_rx_delay;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

