Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943FD57EF81
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237666AbiGWOUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237676AbiGWOTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:19:55 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5531C92D;
        Sat, 23 Jul 2022 07:19:53 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z13so9990054wro.13;
        Sat, 23 Jul 2022 07:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Nos7PQ0XBCrolX+QKwHZI/dAjELjlt6Wsc04alPRFPA=;
        b=awjrGP+/sGj6D1LC+vJjM7sRmixpZNi81wzhWfLwB1I/NsdShBCClW1ZYDVUFkFKrx
         bDIRqi8t1cuWg/DGzqKkHBrdrZUGkNeRfPANffY6k2ZCrW4+wyQX789E0ZRUglTyeOYL
         F/6fbAU5j0nA6giTQyw6L145BmakOWbasVCvjl9BhAFn7xwzNczogMsv8fCA8vowNeWq
         7Ub49zEGk4qUZX/Xu0GvCOpoIDd5AMcYkgy4SdltCpEcoVzBzUeG+TXYgtgZE02KxVOF
         k6NYeCY5mILgiTi5Mpv/eBVLxJrzNVeGENhk4UyzmrepicdO5J700s7AoXjAXqLxbL5K
         ULhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nos7PQ0XBCrolX+QKwHZI/dAjELjlt6Wsc04alPRFPA=;
        b=lZxP1IC5jTCyPkM3Wqbi1tU+Bw45HKZMqnlmEDoNFUyzS1SZpD+cIq/gS8QB7h8Jbs
         AhcmAqkxSldG8bz3+8FJl5fKXV7iLfdJnKQxwrym6iQt79Cmcdt5EZ7XzCOVM1aqTGpm
         IqzZRzTj+dlVNbmLEiDzaT+krOuYuOIedrrheuyD+9QbKpdMdbQM5azUZh7yxqZn9Efe
         cuHBEsKSTYK4/a4RyQBhIRGIfFgXQgT8LW3hGXpxTYaR1uOJXylNBxA1jVZ+uV9gGbVZ
         xPFPqZ7TAFZkf8DYQQ+FuY2ZieYyPpn9dy8wq8wZ4DHOOzyaVB/ZqWoB5ix+4zKUmnno
         ucNw==
X-Gm-Message-State: AJIora9VuFhNhGd14iEcr1Xn2n6zaitOfB95Np+BWqChPBauiI1diUIr
        czj85KKRupHNhal7UIFN8Ao=
X-Google-Smtp-Source: AGRyM1u1JlOst7u2M3EMMSxFrRAh7sXXqcNwPKLqKiswQj1eFuwvE+2hUAawtHYM8uOPI8PfL310MA==
X-Received: by 2002:adf:fbd2:0:b0:21e:7f74:5df1 with SMTP id d18-20020adffbd2000000b0021e7f745df1mr766426wrs.43.1658585992008;
        Sat, 23 Jul 2022 07:19:52 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:51 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v3 09/14] net: dsa: qca8k: move set age/MTU/port enable/disable functions to common code
Date:   Sat, 23 Jul 2022 16:18:40 +0200
Message-Id: <20220723141845.10570-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220723141845.10570-1-ansuelsmth@gmail.com>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca/qca8k-common.c | 88 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        | 12 ++++
 3 files changed, 100 insertions(+), 88 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index c4fce50a91f7..41f9198d1f25 100644
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
index 754d3bee20cb..1f9249c7657b 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -373,3 +373,91 @@ void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
 	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
 		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
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
+void
+qca8k_port_disable(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
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
index e16263fec91f..40592b1c69a2 100644
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

