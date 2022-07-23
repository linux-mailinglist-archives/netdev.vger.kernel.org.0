Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1476C57EF93
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbiGWOVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237758AbiGWOVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:21:03 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B646B18;
        Sat, 23 Jul 2022 07:20:11 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id b21-20020a05600c4e1500b003a32bc8612fso3914218wmq.3;
        Sat, 23 Jul 2022 07:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Orbvc6CQW1YKg6Y2sGBCgufY8y05m0PedIHBV+w/coI=;
        b=YlhJxfdHBafgSyGFosLw2Dy4zSPi0x0JPAWYduhM6VJ1IPnpnrxdBK2CmK6l8ZD+Hj
         CxkGx0G2EG+YEORNr6bkp0u07VIVRyiTScg/Tgmw1updChIPbGoIz0/rwYJKJXhFWfrK
         aQfjo109ubPBnbTYqXihj2dD095lDCRvgwCcvg51DLu6dJT0xFK/fZsK4MVdBUA2S/Gj
         H6wZhtDOwRJX/90hyHO6iDGyxivKp7CaYXlTGvEKeQOhzuOBcN3hoWc7pWsVXDPjy7GT
         l46IZU2huShakQDh5hYwK70iuyq/0z2KiD7YLle/cnFDe/b+jbS62G/cSbhlq6IS7SME
         rn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Orbvc6CQW1YKg6Y2sGBCgufY8y05m0PedIHBV+w/coI=;
        b=j5UAQkzQy3t7gczIgT4ZkMqkgDeYQMiY/H/wUBu+XFhxnwHpRKngqkb8DwA+wGbPkh
         6cXIY6XDlvsQpwx864WN4NLoOYXtSpTnSt//0lrQFwJd7rx3VbFZif+z6SR+jmQ59lKX
         7z05r6GHhGtJ7lwU/cdtEjt0vI9RVIV64EffiH9dz6I6Iu1mUhpglfzDRjNHg3jeOA0a
         gonT/c1yy8fXzeXQyQpAL23jayaWjaeykcy3FepY4cygbl9iIxHIvR4HplSKYaDbGfC2
         6utwQFytw40ju/ZQJr9ip73YJTIZbfpZCkzXtXPH4Fz2F2uehtLDBJFDRJ2CaM3X2lZb
         mgDg==
X-Gm-Message-State: AJIora9OImUyPwuJq7zoZOMrIzGQjnzhjlaiuiGPNryH8MUV5rWS5F6l
        3VnyVxEmee2tvp+cuLlKz0g=
X-Google-Smtp-Source: AGRyM1t3Aiw5eTXBtPSa+h8APipjqt/dtYQwmgLlEKqk3CdtFCHw9DVp1U3KlGw92ZPKwS9EIeYflg==
X-Received: by 2002:a1c:7707:0:b0:3a2:fedc:392 with SMTP id t7-20020a1c7707000000b003a2fedc0392mr3072091wmi.20.1658586009451;
        Sat, 23 Jul 2022 07:20:09 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:20:09 -0700 (PDT)
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
Subject: [net-next PATCH v3 14/14] net: dsa: qca8k: move read_switch_id function to common code
Date:   Sat, 23 Jul 2022 16:18:45 +0200
Message-Id: <20220723141845.10570-15-ansuelsmth@gmail.com>
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

The same function to read the switch id is used by drivers based on
qca8k family switch. Move them to common code to make them accessible
also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 30 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 31 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  1 +
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 34d0c4cea68d..9fed3b638739 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1877,36 +1877,6 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.connect_tag_protocol	= qca8k_connect_tag_protocol,
 };
 
-static int qca8k_read_switch_id(struct qca8k_priv *priv)
-{
-	const struct qca8k_match_data *data;
-	u32 val;
-	u8 id;
-	int ret;
-
-	/* get the switches ID from the compatible */
-	data = of_device_get_match_data(priv->dev);
-	if (!data)
-		return -ENODEV;
-
-	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
-	if (ret < 0)
-		return -ENODEV;
-
-	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
-	if (id != data->id) {
-		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
-		return -ENODEV;
-	}
-
-	priv->switch_id = id;
-
-	/* Save revision to communicate to the internal PHY driver */
-	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
-
-	return 0;
-}
-
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 02559990a097..c33e9e11c322 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -8,6 +8,7 @@
 
 #include <linux/netdevice.h>
 #include <net/dsa.h>
+#include <linux/of_platform.h>
 #include <linux/if_bridge.h>
 
 #include "qca8k.h"
@@ -1207,3 +1208,33 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
 {
 	return qca8k_lag_refresh_portmap(ds, port, lag, true);
 }
+
+int qca8k_read_switch_id(struct qca8k_priv *priv)
+{
+	const struct qca8k_match_data *data;
+	u32 val;
+	u8 id;
+	int ret;
+
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(priv->dev);
+	if (!data)
+		return -ENODEV;
+
+	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
+	if (ret < 0)
+		return -ENODEV;
+
+	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
+	if (id != data->id) {
+		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
+		return -ENODEV;
+	}
+
+	priv->switch_id = id;
+
+	/* Save revision to communicate to the internal PHY driver */
+	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
+
+	return 0;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index e6cf1ad68a9f..efbd3438aba8 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -432,6 +432,7 @@ extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
 int qca8k_mib_init(struct qca8k_priv *priv);
 void qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable);
+int qca8k_read_switch_id(struct qca8k_priv *priv);
 
 /* Common read/write/rmw function */
 int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
-- 
2.36.1

