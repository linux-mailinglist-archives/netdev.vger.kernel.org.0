Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4B14FE749
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiDLRjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358425AbiDLRjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:39:17 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8131461A33;
        Tue, 12 Apr 2022 10:36:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id p15so38745247ejc.7;
        Tue, 12 Apr 2022 10:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BoJnx9jWECbEjAnZSa13BlCrzfnPk12ci4iBhXRs5SY=;
        b=P0zvGRCBpqsmXzSP6cK6TpMZbKHrh4pYdwFfCgr9dcbwI+MQQHj84TviZ7uq7FaaeQ
         x9JWYGKP/EjQJXITFbqLqdspB+ExH3uRySmm9aDlDTl469CgjvprX7nGGvy2bT2SNk/3
         rSxAWhh59WxJbXzTIyHJ62kDQNTPHkl54G0vM+0iZYIqzJPDEwvd+/d7468PEYqsiOTf
         TxNYMjkO84TMqF+rQ/VfhStK0EKB0RJnBvs3hOJdhBCRgIwb3ILye4FGyrOOTbS1NgDN
         Rz5iyE0XATdx8Iczn8F4D+C7qk36YVGpELGPCegrZ2DE9JWns+4FEu/B2RF+KaNGAwg2
         uxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BoJnx9jWECbEjAnZSa13BlCrzfnPk12ci4iBhXRs5SY=;
        b=Mk/176/LB9E6ywjFKvudmTNoHTCYznJGtJaKiN/t3AcpFgA2slq1xwdnoR7EZfiBca
         9V/N+gbmCsSYw9m91aZIlcQOl8q9omoe497cggM3Jw7JbF8H953incpYj8hJ8B6Lx4S5
         tj0ozL7Z4GCG49OXqEsprOk2d3VLmE51UVAVONNdFXuyzlfpGHlWHxOOL7W8X5mk9Kmt
         pDfYiIdaca1hMyRPGTXJBr63wWr4ASZtbIIGs+ItCoFFsOvS+juDlBmYAPKSm26gCfgZ
         Bn/dVWTbC79kxkmtsfQTSCsqRMkli6ySZy7IlkNH1ZOaR4GP/LxVE1xrfH7qBySTCdjL
         sTXw==
X-Gm-Message-State: AOAM530FV0684WmaQpk8Y4cU9ekwPhQFy6L/7Dwau50YGZznXlOZgwcp
        2Fxp7AgJdNUXT/C7+XJA4vx4XM3LueY=
X-Google-Smtp-Source: ABdhPJx0t5iHxFTfYF+f90nBzCNnd6QUHqseqq0sLl4sYSVOTKFjpOqQhmg9Vw1gUb8WbIXg9XSPOw==
X-Received: by 2002:a17:907:6093:b0:6e0:dabf:1a9f with SMTP id ht19-20020a170907609300b006e0dabf1a9fmr35900675ejc.424.1649785010831;
        Tue, 12 Apr 2022 10:36:50 -0700 (PDT)
Received: from localhost.localdomain ([5.171.105.8])
        by smtp.googlemail.com with ESMTPSA id n11-20020a50cc4b000000b0041d8bc4f076sm48959edi.79.2022.04.12.10.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:36:50 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 2/4] drivers: net: dsa: qca8k: drop port_sts from qca8k_priv
Date:   Tue, 12 Apr 2022 19:30:17 +0200
Message-Id: <20220412173019.4189-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412173019.4189-1-ansuelsmth@gmail.com>
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
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
---
 drivers/net/dsa/qca8k.c | 15 +++++++++------
 drivers/net/dsa/qca8k.h |  9 ++++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 820eeab19873..5f447b586cfa 100644
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
@@ -3234,13 +3234,16 @@ static void qca8k_sw_shutdown(struct mdio_device *mdiodev)
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

