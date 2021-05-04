Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF1F37326E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhEDWbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhEDWao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:44 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB586C06134C;
        Tue,  4 May 2021 15:29:48 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id u13so9599528edd.3;
        Tue, 04 May 2021 15:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ste482S+caberMonV+nJ/r/9b0oXoNQbzg4c027HzJA=;
        b=YodBcEz/tDpTDjuPP6XSjtZtCF5vmImPMlBIKye/ziVWDEAX7UKLWIrw4brXkOyv9q
         RQnQ/s3SGqwqDsvfn6TKnVJroP/4waByqFuVfXDeVV/td8K84gUkG5uqexO2d3wcesoS
         lMTAMZ/nssqZSQUiUecp4fqbqRVsMmI1NMojAN6drFG/iR2YhmkzPODyYdBY+t0z6w8C
         nlxldkwfVx/M6AOmx0LhJVW2yGf3AUWZJJ9g7LSPkpGtG30s5vZtVZQLVXF1J+dNa0bf
         NFPvdxX4kKDeKTkYk1chKLaALeolFPF5irg1Y9msXEl5hp66b4iV361q6Kp/cSRwopO9
         9osQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ste482S+caberMonV+nJ/r/9b0oXoNQbzg4c027HzJA=;
        b=DByJjwsEwBPX9GdDq63Aq0aNImKsBuGiLh37Hv943Yns1Hv5hyNpMTCJfoamk+vvf5
         Q1UJqVmQrinZNQZHkCl4Y/qvHwpRqZ/yuVxpqtth2uAMNS2mAwvgZGG8W/XVjwK0XMio
         230/omm8ZCkPpODfmvFCKLLA8nzypEwogY/bxr3M7OistRNgE9bSq+BDKdxa0GjnJkfQ
         YH51IPQ3uAPM4DesC994fLZtupSLJiF4Ulku7cdSMvwJfr9hgl8iAxZX+VuVhELwHctG
         glO9dItTHQJ1Vcf052wB2tw7/Ja2x9Zoj3Jt90IPv7vu9rU2G4CUnqCXGji0hAKne2fo
         /y+w==
X-Gm-Message-State: AOAM530kw7ZgGSUkSrOkvEPyUA4jEwnJJuxD3Vc21memSFs8WRwH8gpw
        6zbdHrOC+5yvlGp/3BlbwkU=
X-Google-Smtp-Source: ABdhPJxVHAfjFXzXX59Y8cA8YNOojeYfzkSpaxcOgYx64pkY9jv05zEP0cVSVCC/ZiNMkYfPKhPmWQ==
X-Received: by 2002:aa7:d306:: with SMTP id p6mr11856593edq.168.1620167387444;
        Tue, 04 May 2021 15:29:47 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:47 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 13/20] net: dsa: qca8k: make rgmii delay configurable
Date:   Wed,  5 May 2021 00:29:07 +0200
Message-Id: <20210504222915.17206-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
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
index 22334d416f53..cb9b44769e92 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -779,6 +779,47 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
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
@@ -808,6 +849,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_of_rgmii_delay(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
@@ -1018,8 +1063,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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

