Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1D4E367E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbiCVCRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbiCVCRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:17:18 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94D62CCA8;
        Mon, 21 Mar 2022 19:14:37 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n35so7949907wms.5;
        Mon, 21 Mar 2022 19:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pQbf7iGYZbf1aURiBPER2SslgHTAcNmDZn6J10o+zx8=;
        b=QgjoZXxW9XjeJx6tl7jhthMRCN1yYSuJTVOXtqzVquvaPAH7PV6ReENpXpJR1N/+E5
         xOT+DSg8iutJnstH/tbQ3do6ODVMEOlbvnWitx0w2QeLk2w3atiXl6uRyJ2ip88Aakay
         sB+TU5Z3wos/Lp4sLWa6/5N1CQ+PBJod7eruIbW16p2ICFjmZdM1hEb0QzEanWlui5+x
         bSraMhWJKN8Kw/Y3XXOJJfIyu+ylVayaa1tRotEm4Dpw19RSTqTiXyzbgKe644Ylh7pI
         nzfkQqlNsLw7n8KxFfxzirldF1re656/R3AnHOxSVDMap75JN/8Q88vpYeyHZ9y9fUtj
         d8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pQbf7iGYZbf1aURiBPER2SslgHTAcNmDZn6J10o+zx8=;
        b=3fuw+/4coEZOPrnJZV0Y6CUc2izrLpHWw02KDpzAwLAJ1K6aDMuAF8fCtL3s4FFEX6
         A8cMUj6U0e4W/irNRIlBBABe+lK5vdzqnAbSk1WnjxeDnuifZlg2bXcTfLZ+7OtHOQ+x
         guUY3e3LuCi663/veDDz04WvtvK6/VzxoIDS++KrA34YoTeQ/SPVPkv/z1L6naguA02n
         6nSfahThkWxIUZbnH5fznOxn8XZp7WyWp9LsuL68d74T3B6x/sQz3tMtl6Bn6KCTTCnn
         dfLR55hlfFjROMdpg1uqKCJt5WcFHLg7Um4bZfTw4E/0/JbHGdS6QdIqEhkNR9uj1ZIF
         yCTA==
X-Gm-Message-State: AOAM5315cBhoGBRusRvPi+if9/S3NbveL4HnVJxJ+mKODtIWrRsdlvbf
        xJsQCU39ylbyMniUd5RoswM=
X-Google-Smtp-Source: ABdhPJxkutwPB2uel9GTM0z0PMGhFRA5Hs+vtTTJs07jpj9cMnEY7AqD/3joAw+ZAX8rVmVlodX4Og==
X-Received: by 2002:a05:600c:1c1e:b0:38c:b393:b355 with SMTP id j30-20020a05600c1c1e00b0038cb393b355mr1579417wms.92.1647915276351;
        Mon, 21 Mar 2022 19:14:36 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.googlemail.com with ESMTPSA id m2-20020a056000024200b00205718e3a3csm177968wrz.2.2022.03.21.19.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:14:35 -0700 (PDT)
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
Subject: [net-next PATCH 2/4] drivers: net: dsa: qca8k: drop port_sts from qca8k_priv
Date:   Tue, 22 Mar 2022 02:45:04 +0100
Message-Id: <20220322014506.27872-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220322014506.27872-1-ansuelsmth@gmail.com>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
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
index 4366d87b4bbd..33cedae6875c 100644
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
@@ -3251,13 +3251,16 @@ static void qca8k_sw_shutdown(struct mdio_device *mdiodev)
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

