Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BF95825AD
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiG0Lgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiG0LgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:36:08 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B184A819;
        Wed, 27 Jul 2022 04:35:55 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ez10so30827138ejc.13;
        Wed, 27 Jul 2022 04:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4YypBtO7DBxDIqaV2gvYUg5aIwcrwgavrc6e5GQ6Kf8=;
        b=ql+C+HwjAJjtdveNobuTAyDgyj2jIkqv31cLrtYSK4FAdcOgyS2bXKs8Q/npqKfKxg
         1nVbjZV2MIxC9NlwouxavMPZjw5huhWE6EPeKTwNbck9xfQPECVPQ5jREKVb6lOUVO1z
         1pf+4KpfmerMbGTeqlPVJPNihRIMV2XG5PYxcsqWHh/5appqK3oOkbzgEWnR724JqzuN
         /2rtHrLsGpHYAClP4isEr7UIaEQEL4KqXCcVvxv1cyo+GHr4iVoNK/KHBsZfpJgkRvvI
         +pOnWeqnxfiHHDEHF+q3OSxfCgYQTWqbDb0DFCCb/T+lLuYwE7IWui+T0gkSJ1rHsSBZ
         6jJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4YypBtO7DBxDIqaV2gvYUg5aIwcrwgavrc6e5GQ6Kf8=;
        b=jvw1EuKYFU6RUttXI1ybaij3xR4TYX7sd1xwgj6ZOVsmIUJQtwWQJDRRMR7UDIUV81
         pfA/Rg7uqPK6aBegA24tzDWbxPrk31B5k3gac2SQUKdFNAWX123M8urzHEdaG4yo0wzN
         AUEPMq37v3VxgBu+7n6oa9o14RQoGGgcQ6/kzKm7O5lrM3vI91rEEooq0enJMi9qv+yA
         7LQApauCmofnMISFXNwhIWePSn7OVqzXJnRmudrIqROrWqJX0z9+BtVlPpYNqTQT3Mw7
         RrFbuHv6ph6OeMVgFM4FxtDgNKaLRfcr/2jexuejyMvCMNxYrBYV/zf7JQuAKUJ1BG1t
         o1JA==
X-Gm-Message-State: AJIora98busP56r8HxlrkT9O3n6eooiJ6h7EhXVDk6Gb3W5xZC/dy83F
        vuBbuSAz47FTLrGJGlSyeXjOB5yKbUEGok63
X-Google-Smtp-Source: AGRyM1uGkbcW1tPhlVZArEULqYo1sYQarQDmCTFaj8cfhQy5263gBZbUg0ledRuq964m2YyZOWpKxw==
X-Received: by 2002:a17:907:a218:b0:72b:8aae:3f8c with SMTP id qp24-20020a170907a21800b0072b8aae3f8cmr17708077ejc.191.1658921753402;
        Wed, 27 Jul 2022 04:35:53 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:53 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v5 09/14] net: dsa: qca8k: move set age/MTU/port enable/disable functions to common code
Date:   Wed, 27 Jul 2022 13:35:18 +0200
Message-Id: <20220727113523.19742-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727113523.19742-1-ansuelsmth@gmail.com>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same set age, MTU and port enable/disable function are used by
driver based on qca8k family switch.
Move them to common code to make them accessible also by other drivers.
While at it also drop unnecessary qca8k_priv cast for void pointers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 88 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 85 +++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        | 12 ++++
 3 files changed, 97 insertions(+), 88 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 11d3116733af..1815863502c9 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1908,94 +1908,6 @@ qca8k_port_fast_age(struct dsa_switch *ds, int port)
 	mutex_unlock(&priv->reg_mutex);
 }
 
-static int
-qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
-{
-	struct qca8k_priv *priv = ds->priv;
-	unsigned int secs = msecs / 1000;
-	u32 val;
-
-	/* AGE_TIME reg is set in 7s step */
-	val = secs / 7;
-
-	/* Handle case with 0 as val to NOT disable
-	 * learning
-	 */
-	if (!val)
-		val = 1;
-
-	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL, QCA8K_ATU_AGE_TIME_MASK,
-				  QCA8K_ATU_AGE_TIME(val));
-}
-
-static int
-qca8k_port_enable(struct dsa_switch *ds, int port,
-		  struct phy_device *phy)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-
-	qca8k_port_set_status(priv, port, 1);
-	priv->port_enabled_map |= BIT(port);
-
-	if (dsa_is_user_port(ds, port))
-		phy_support_asym_pause(phy);
-
-	return 0;
-}
-
-static void
-qca8k_port_disable(struct dsa_switch *ds, int port)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-
-	qca8k_port_set_status(priv, port, 0);
-	priv->port_enabled_map &= ~BIT(port);
-}
-
-static int
-qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	/* We have only have a general MTU setting.
-	 * DSA always set the CPU port's MTU to the largest MTU of the slave
-	 * ports.
-	 * Setting MTU just for the CPU port is sufficient to correctly set a
-	 * value for every port.
-	 */
-	if (!dsa_is_cpu_port(ds, port))
-		return 0;
-
-	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
-	 * the switch panics.
-	 * Turn off both cpu ports before applying the new value to prevent
-	 * this.
-	 */
-	if (priv->port_enabled_map & BIT(0))
-		qca8k_port_set_status(priv, 0, 0);
-
-	if (priv->port_enabled_map & BIT(6))
-		qca8k_port_set_status(priv, 6, 0);
-
-	/* Include L2 header / FCS length */
-	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
-
-	if (priv->port_enabled_map & BIT(0))
-		qca8k_port_set_status(priv, 0, 1);
-
-	if (priv->port_enabled_map & BIT(6))
-		qca8k_port_set_status(priv, 6, 1);
-
-	return ret;
-}
-
-static int
-qca8k_port_max_mtu(struct dsa_switch *ds, int port)
-{
-	return QCA8K_MAX_MTU;
-}
-
 static int
 qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 		      u16 port_mask, u16 vid)
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 13069c9ba3e6..e25df4b23b9a 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -368,3 +368,88 @@ void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
 	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
 		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
+
+int qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
+{
+	struct qca8k_priv *priv = ds->priv;
+	unsigned int secs = msecs / 1000;
+	u32 val;
+
+	/* AGE_TIME reg is set in 7s step */
+	val = secs / 7;
+
+	/* Handle case with 0 as val to NOT disable
+	 * learning
+	 */
+	if (!val)
+		val = 1;
+
+	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL,
+				  QCA8K_ATU_AGE_TIME_MASK,
+				  QCA8K_ATU_AGE_TIME(val));
+}
+
+int qca8k_port_enable(struct dsa_switch *ds, int port,
+		      struct phy_device *phy)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	qca8k_port_set_status(priv, port, 1);
+	priv->port_enabled_map |= BIT(port);
+
+	if (dsa_is_user_port(ds, port))
+		phy_support_asym_pause(phy);
+
+	return 0;
+}
+
+void qca8k_port_disable(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	qca8k_port_set_status(priv, port, 0);
+	priv->port_enabled_map &= ~BIT(port);
+}
+
+int qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	/* We have only have a general MTU setting.
+	 * DSA always set the CPU port's MTU to the largest MTU of the slave
+	 * ports.
+	 * Setting MTU just for the CPU port is sufficient to correctly set a
+	 * value for every port.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
+	 * the switch panics.
+	 * Turn off both cpu ports before applying the new value to prevent
+	 * this.
+	 */
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 0);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 0);
+
+	/* Include L2 header / FCS length */
+	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu +
+			  ETH_HLEN + ETH_FCS_LEN);
+
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 1);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 1);
+
+	return ret;
+}
+
+int qca8k_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return QCA8K_MAX_MTU;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index edb2b23a02b9..e7d4df253b8c 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -463,4 +463,16 @@ int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
 void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
 			     struct dsa_bridge bridge);
 
+/* Common port enable/disable function */
+int qca8k_port_enable(struct dsa_switch *ds, int port,
+		      struct phy_device *phy);
+void qca8k_port_disable(struct dsa_switch *ds, int port);
+
+/* Common MTU function */
+int qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu);
+int qca8k_port_max_mtu(struct dsa_switch *ds, int port);
+
+/* Common fast age function */
+int qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

