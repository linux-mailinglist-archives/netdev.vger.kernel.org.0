Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE4F503321
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356524AbiDOXc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356488AbiDOXcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:32:54 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8540326E1;
        Fri, 15 Apr 2022 16:30:23 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u15so17528018ejf.11;
        Fri, 15 Apr 2022 16:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qK8EHYcVP1VpWZMBJnIldFyQKkZ/NNk0wwcd5+1ocwY=;
        b=PGuhYCEdXh1KM9c86JOAbO91M9V65Efzz22Jv/amDheUvh7dGF00xPQbt11AlxThwK
         BD2+2S69AmflTeMsQdVL66sPc3Wa+pSZy/U4+1e/RJXWzcEUgACDgRoHe025VAbjF3vo
         cVtqaKR+yCG19sSh0LBiGZVDzdyzf7GoHfbxHXzjRa7qb8nmYx77L7w7VWb+4EfBKQ4Q
         PmiGE1dDr2H77sZkeiM2HEU6EGqJ+wEaIHb/wAaB2k7l8IBwy+kmKUj9RTqCKUX06DQB
         ekhE1pi+2RX4QLbTG/b1+uA/NHjTdf/gGDxqvwC8cIf9TQeeJCfhYyccc3ham6PkyNGl
         byYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qK8EHYcVP1VpWZMBJnIldFyQKkZ/NNk0wwcd5+1ocwY=;
        b=yKoq36TRVIFZWn2VqA0kkYNoF+SvlU1HPaensvq0XmABQ/4/oiabFCO09N9Lenb/34
         rPANee91XPPS92prJxOwfHaGLdabQ3eha3luVHTsKCDEa723UfOYb8PZQbYCMAZ2r8Am
         KLMeqjNGMlwaYqB1qoe9CkD7nWXMvurvWL3kEDsXAwvCh/Q4cODOc0fJRudbcARxpyBM
         laXfcZv7XvkL0Ff/FZhpPnV/C3wf7saZaKlkZE9ce9bqhSpwzuYztV2qn1hH1qEWIV5w
         FIe8GomkIfG0shIaLnL8whZZ8Rga7+Rrr4NCMVYJD8lzYjjZWc7ll+/o48niAXdvp7rG
         YQGA==
X-Gm-Message-State: AOAM530FmECTSHlZsnZoaN64+Qj/L+WJAeteVitr+8T3VSUVjzmSmHwO
        7z9JpeWutCSnYOM++vcyKQxSat4Unss=
X-Google-Smtp-Source: ABdhPJwRJgWX6ran0lDX03hoJcMgMqqoHlSBQKeMgvg8WKGhK7SigmEQ6fH1bv3wTlK51wY7UZPyUA==
X-Received: by 2002:a17:906:3082:b0:6e0:111f:8986 with SMTP id 2-20020a170906308200b006e0111f8986mr888730ejv.677.1650065422335;
        Fri, 15 Apr 2022 16:30:22 -0700 (PDT)
Received: from localhost.localdomain (host-79-33-253-62.retail.telecomitalia.it. [79.33.253.62])
        by smtp.googlemail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm2114588eje.173.2022.04.15.16.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 16:30:21 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v3 2/6] net: dsa: qca8k: drop port_sts from qca8k_priv
Date:   Sat, 16 Apr 2022 01:30:13 +0200
Message-Id: <20220415233017.23275-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220415233017.23275-1-ansuelsmth@gmail.com>
References: <20220415233017.23275-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port_sts is a thing of the past for this driver. It was something
present on the initial implementation of this driver and parts of the
original struct were dropped over time. Using an array of int to store if
a port is enabled or not to handle PM operation seems overkill. Switch
and use a simple u8 to store the port status where each bit correspond
to a port. (bit is set port is enabled, bit is not set, port is disabled)
Also add some comments to better describe why we need to track port
status.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 15 +++++++++------
 drivers/net/dsa/qca8k.h |  9 ++++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 4e27d9803a5f..766db0d43092 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2346,7 +2346,7 @@ qca8k_port_enable(struct dsa_switch *ds, int port,
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 
 	qca8k_port_set_status(priv, port, 1);
-	priv->port_sts[port].enabled = 1;
+	priv->port_enabled_map |= BIT(port);
 
 	if (dsa_is_user_port(ds, port))
 		phy_support_asym_pause(phy);
@@ -2360,7 +2360,7 @@ qca8k_port_disable(struct dsa_switch *ds, int port)
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 
 	qca8k_port_set_status(priv, port, 0);
-	priv->port_sts[port].enabled = 0;
+	priv->port_enabled_map &= ~BIT(port);
 }
 
 static int
@@ -3235,13 +3235,16 @@ static void qca8k_sw_shutdown(struct mdio_device *mdiodev)
 static void
 qca8k_set_pm(struct qca8k_priv *priv, int enable)
 {
-	int i;
+	int port;
 
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		if (!priv->port_sts[i].enabled)
+	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
+		/* Do not enable on resume if the port was
+		 * disabled before.
+		 */
+		if (!(priv->port_enabled_map & BIT(port)))
 			continue;
 
-		qca8k_port_set_status(priv, i, enable);
+		qca8k_port_set_status(priv, port, enable);
 	}
 }
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 562d75997e55..12d8d090298b 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -324,10 +324,6 @@ enum qca8k_mid_cmd {
 	QCA8K_MIB_CAST = 3,
 };
 
-struct ar8xxx_port_status {
-	int enabled;
-};
-
 struct qca8k_match_data {
 	u8 id;
 	bool reduced_package;
@@ -388,11 +384,14 @@ struct qca8k_priv {
 	u8 mirror_rx;
 	u8 mirror_tx;
 	u8 lag_hash_mode;
+	/* Each bit correspond to a port. This switch can support a max of 7 port.
+	 * Bit 1: port enabled. Bit 0: port disabled.
+	 */
+	u8 port_enabled_map;
 	bool legacy_phy_port_mapping;
 	struct qca8k_ports_config ports_config;
 	struct regmap *regmap;
 	struct mii_bus *bus;
-	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
 	struct dsa_switch *ds;
 	struct mutex reg_mutex;
 	struct device *dev;
-- 
2.34.1

