Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9136578FB1
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbiGSBPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236691AbiGSBP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:28 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A1CBE28;
        Mon, 18 Jul 2022 18:15:18 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id b26so19471104wrc.2;
        Mon, 18 Jul 2022 18:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6aOY98biC6M1I3non1I8SYQxbDiXNrOM6JAiDc+TH7k=;
        b=a6QZmg/Ba5UDeW/XYEkDwmUTyvL1LhFcR0Z3tB1rOR/DQOaOjc/QhXcEPlrdBIurf+
         eadPKX7bWJaq4Dgo+VZMAba/Z623vra26mWrvImK3Cqc+CuL3tQ8MX6asoD7xwoTNYS0
         uvZk8fOmgVa+mFhaG2aCz0MogofzyVCZZmvE7hAuFpGp56Uvs5YDToBtjX2th9ooX8CA
         gX/LoSEF9E8G+WOed+VvvAIAArYrNW/j31Fh7yiZsqlfQQfbwTnsCVFeKiFEe5lnmVw2
         S3p3CQrN59QWGncDA+bj24XH9dJzBoWQP1uKlLKn7NPB45919A8pczJnzg+WgA+tb/uH
         ft/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6aOY98biC6M1I3non1I8SYQxbDiXNrOM6JAiDc+TH7k=;
        b=a5CVGtneZaizgX8A/cz9eFOjkYIxDSdmp5xuBp5hYzUWYT1yCNT5/I22iUaAgR3ajH
         TFVxz6DQd5j6Eba/QtE7BINhSvoN9oFysF8T3zmteBKsFduHBU1r6xK8ozJXDuOLx1ul
         13fV0aoRYj/gytZp461htOYkiOcIWn4va4N4vA+c4oz534UI0PfvC71zGcoctaJGH5tD
         dZQ+WA1Fh+baTWjbALpgfmUBb/wfOKKMOlcDiQs2olYCKcAAFyPhd0mSRiF2iSB1ATnV
         X2ABhaAbS2oxGAwg0gXQfAcCKdUhzB+caSxeA9G4DVDiDWZw+jagXePRq2SKghjTY4O/
         DYiA==
X-Gm-Message-State: AJIora9kuYHGMh34n4hN+r5MlAkN7A96wHiWL3MbgKiZtiBb7O67u92n
        QQgDzPIrFFpJDdW+bA3tw4k=
X-Google-Smtp-Source: AGRyM1uVY+dLVDqyVl0kwaMGvWWba8hokvlxIIZrji4KFrsIXvF7H3ooskCbYbxgOcZ3kLLNypoF/Q==
X-Received: by 2002:a5d:64a3:0:b0:21d:ad9e:afd7 with SMTP id m3-20020a5d64a3000000b0021dad9eafd7mr24334480wrp.524.1658193317692;
        Mon, 18 Jul 2022 18:15:17 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:17 -0700 (PDT)
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
Subject: [net-next PATCH v2 08/15] net: dsa: qca8k: move fast age/MTU/port enable/disable functions to common code
Date:   Tue, 19 Jul 2022 02:57:19 +0200
Message-Id: <20220719005726.8739-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719005726.8739-1-ansuelsmth@gmail.com>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
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

The same fast age, MTU and port enable/disable function are used by
driver based on qca8k family switch.
Move them to common code to make them accessible also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 98 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 98 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        | 13 ++++
 3 files changed, 111 insertions(+), 98 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 729f63a865d1..95bf65121ed6 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1575,104 +1575,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static void
-qca8k_port_fast_age(struct dsa_switch *ds, int port)
-{
-	struct qca8k_priv *priv = ds->priv;
-
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
-	mutex_unlock(&priv->reg_mutex);
-}
-
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
index 129a82172945..598d6577835a 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -715,3 +715,101 @@ void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
 	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
 		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
+
+void
+qca8k_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
+	mutex_unlock(&priv->reg_mutex);
+}
+
+int
+qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
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
+	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL, QCA8K_ATU_AGE_TIME_MASK,
+				  QCA8K_ATU_AGE_TIME(val));
+}
+
+int
+qca8k_port_enable(struct dsa_switch *ds, int port,
+		  struct phy_device *phy)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
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
+void
+qca8k_port_disable(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+
+	qca8k_port_set_status(priv, port, 0);
+	priv->port_enabled_map &= ~BIT(port);
+}
+
+int
+qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
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
+	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
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
+int
+qca8k_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return QCA8K_MAX_MTU;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index dd3072e2f23c..bc9078ae2b70 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -469,4 +469,17 @@ int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
 void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
 			     struct dsa_bridge bridge);
 
+/* Common fast age function */
+void qca8k_port_fast_age(struct dsa_switch *ds, int port);
+int qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs);
+
+/* Common port enable/disable function */
+int qca8k_port_enable(struct dsa_switch *ds, int port,
+		      struct phy_device *phy);
+void qca8k_port_disable(struct dsa_switch *ds, int port);
+
+/* Common MTU function */
+int qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu);
+int qca8k_port_max_mtu(struct dsa_switch *ds, int port);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

