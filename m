Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3877457F782
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiGXWwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbiGXWvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:51:55 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06899E096;
        Sun, 24 Jul 2022 15:51:16 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id u12so6879346edd.5;
        Sun, 24 Jul 2022 15:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AYOGko4ppgYP9xznRcX/kRKsYpTDwxpUszJ78oUY2fA=;
        b=h8jGSttyybh6356DcjrawkHAAe+588pTTdctaMlBhoggXBnXy2X2vIMF+JURDgP/mx
         McZ0I9a9USDlJttgRjG2XVwUFGuTFTa09CyddGeG+4poc36VDD2gQpnizoJq3vMJ9dYs
         W12aNlHkeyo4sdYXZwC8NCx7GUNo39wY56MPz1y78I24hioZ4mDwaX3eOpq9WLGMnJP7
         9QQE74DOzACFY77aB1JnVSUCvJUzv2VPWBugS6hfRF3T5RLs+DFTjs2WEjvXtGf2Q2iX
         7LAaZz5e82GrDAC81qrwXOFbjETvkC+HoJwSDdNlPYW3yK3fxYtFl3vVyG621qE3qvUB
         ukSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AYOGko4ppgYP9xznRcX/kRKsYpTDwxpUszJ78oUY2fA=;
        b=F+6PzSh2+9aSGxm6mtCsPlI7uTUEVOGwjsHpKVsKFWzHtIxhrjea46jjzQIVcNRewq
         kLw6xH+SH0dVkzuzwPf1tx0dGcnRgs7fD/gegJ+OA5ChTAcfQJm//p0p5+6M85qVG1fo
         1mEiSxHE8ROEKAI6NfBb83IhaOlpkckZkEqu/XRe9yr7H6c5C/DnQ64oG8BWI+/Io9+z
         oyeUQ07cBSEAL8enKkd8pxuMR2eWIa54TKntSWHVe/GyABsSQTk5XZ/WVtiH52mW0hGS
         rTfuPc1Eh94Dv5O94+ilJLogIWT8fbrq3v/S3Wj6K0o/MUjUxUysqT12t2xW5l6r+coh
         JmOQ==
X-Gm-Message-State: AJIora+LFd9O/3TsITv2hutiGQB7tAmsdHDLlQrdy0G8Bw8LhGf4fM7s
        NIDdJ5MCF8mXmp1YbZgdam0=
X-Google-Smtp-Source: AGRyM1syUe5lWc7pKxW/4vrlvBkZheKDyx06UBN+oegjgPgeiGarfHvsYtuM8n4uA8+il3yRgBWXDg==
X-Received: by 2002:a05:6402:4255:b0:43a:c03f:1aa4 with SMTP id g21-20020a056402425500b0043ac03f1aa4mr11008619edb.146.1658703075008;
        Sun, 24 Jul 2022 15:51:15 -0700 (PDT)
Received: from localhost.localdomain (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.googlemail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm4645238ejc.205.2022.07.24.15.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:51:14 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [net-next PATCH v4 09/14] net: dsa: qca8k: move set age/MTU/port enable/disable functions to common code
Date:   Sun, 24 Jul 2022 22:19:33 +0200
Message-Id: <20220724201938.17387-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724201938.17387-1-ansuelsmth@gmail.com>
References: <20220724201938.17387-1-ansuelsmth@gmail.com>
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
index f25aaf8d4ec8..75efba7a4fa0 100644
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
index a50c21c90e81..7e573827dac6 100644
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

