Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635F858259B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiG0Lfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiG0Lfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:35:43 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F9143E54;
        Wed, 27 Jul 2022 04:35:42 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l23so31000139ejr.5;
        Wed, 27 Jul 2022 04:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lhvDDsJvBpWETgobXmvcinrpM6pJWb5xW40JaSHYLtA=;
        b=kmbStV5h1V5rK3xavw4QDCyr9Ovdu9p1aFAGN3WvZMHmmRPaMagRJKdP28uZsBy8tl
         y70fHyjeOwhGCakMJ0pF3EkSxaSQLuXguGohytVL43VS2UmLlcIEOzgbzzXf1VW5jauU
         uxGawNp8Tphr58jbr9iVr9Lzk8H4zS1/83Xj6jCkqCQquo+FlcLXbpXzr75pMFdJHYU9
         Q5s0rcCQD7cS31RE3iuIKooSRgY3CvsT+/dL4QAYLqvY56J3a3oKqs6hGX/pCGQykexo
         DS8HSQe5Mh2VYgns7hWQohBUY9HJJ9O3RoXgBol0b6W4rJIfhaIG6OxVPTAog9MuW0oF
         d95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lhvDDsJvBpWETgobXmvcinrpM6pJWb5xW40JaSHYLtA=;
        b=SmiF262N58E/psylW5YFv7SWkvUF7Qj8TTMlZ3s/eXbLnpYVgXVwpAji/2sK12Kyvo
         TDl6HpvO14Dh9vbwpY3L77PuL1nNKO1Caqf12plSasmjd/pp1dU/RTVeTX6Bun4XBqVF
         3NJ4XAhoKtL7L3OrfwNxXQsGAQb79jAK90nFTcJZI60x+2goK//KQ0zlLpJyBOAveBST
         4RVc3ry5ZM1CYRB5gl8jpC/ZQfgE1GYbIde37wtnU1K+TUNbQGcQTxjt6RWYW96Mg95L
         j2SHa5JuPXl30L5zPkRM2kxdz6SaXQYrb1EdXgjVpqlOhbmnuqXjSlZaVSfFgxZUp/U8
         DwXw==
X-Gm-Message-State: AJIora9NKsbQgSUsfFSUijwhwCSFWmm58A52Xu8to47hUrNoKrLeNUHd
        RZlkYjuJLmTHGWheOlpQWvY=
X-Google-Smtp-Source: AGRyM1vQLY0WEfwif8hEzFvoN1kO8+10tahucJPJv5Z+BZD91cnBrWfkkFaqa0YAU8bhgV7MNfNuwg==
X-Received: by 2002:a17:906:dc95:b0:72f:ab47:1692 with SMTP id cs21-20020a170906dc9500b0072fab471692mr17093133ejc.319.1658921740559;
        Wed, 27 Jul 2022 04:35:40 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:40 -0700 (PDT)
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
Subject: [net-next PATCH v5 01/14] net: dsa: qca8k: cache match data to speed up access
Date:   Wed, 27 Jul 2022 13:35:10 +0200
Message-Id: <20220727113523.19742-2-ansuelsmth@gmail.com>
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

Using of_device_get_match_data is expensive. Cache match data to speed
up access and rework user of match data to use the new cached value.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k.c | 35 +++++++++++------------------------
 drivers/net/dsa/qca/qca8k.h |  1 +
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
index 1cbb05b0323f..64524a721221 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k.c
@@ -1462,8 +1462,8 @@ static int qca8k_find_cpu_port(struct dsa_switch *ds)
 static int
 qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 {
+	const struct qca8k_match_data *data = priv->info;
 	struct device_node *node = priv->dev->of_node;
-	const struct qca8k_match_data *data;
 	u32 val = 0;
 	int ret;
 
@@ -1472,8 +1472,6 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 	 * Should be applied by default but we set this just to make sure.
 	 */
 	if (priv->switch_id == QCA8K_ID_QCA8327) {
-		data = of_device_get_match_data(priv->dev);
-
 		/* Set the correct package of 148 pin for QCA8327 */
 		if (data->reduced_package)
 			val |= QCA8327_PWS_PACKAGE148_EN;
@@ -1996,23 +1994,19 @@ static void qca8k_setup_pcs(struct qca8k_priv *priv, struct qca8k_pcs *qpcs,
 static void
 qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
 {
-	const struct qca8k_match_data *match_data;
 	struct qca8k_priv *priv = ds->priv;
 	int i;
 
 	if (stringset != ETH_SS_STATS)
 		return;
 
-	match_data = of_device_get_match_data(priv->dev);
-
-	for (i = 0; i < match_data->mib_count; i++)
+	for (i = 0; i < priv->info->mib_count; i++)
 		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
 			ETH_GSTRING_LEN);
 }
 
 static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *skb)
 {
-	const struct qca8k_match_data *match_data;
 	struct qca8k_mib_eth_data *mib_eth_data;
 	struct qca8k_priv *priv = ds->priv;
 	const struct qca8k_mib_desc *mib;
@@ -2031,10 +2025,9 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	if (port != mib_eth_data->req_port)
 		goto exit;
 
-	match_data = device_get_match_data(priv->dev);
 	data = mib_eth_data->data;
 
-	for (i = 0; i < match_data->mib_count; i++) {
+	for (i = 0; i < priv->info->mib_count; i++) {
 		mib = &ar8327_mib[i];
 
 		/* First 3 mib are present in the skb head */
@@ -2106,7 +2099,6 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 			uint64_t *data)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	const struct qca8k_match_data *match_data;
 	const struct qca8k_mib_desc *mib;
 	u32 reg, i, val;
 	u32 hi = 0;
@@ -2116,9 +2108,7 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
 		return;
 
-	match_data = of_device_get_match_data(priv->dev);
-
-	for (i = 0; i < match_data->mib_count; i++) {
+	for (i = 0; i < priv->info->mib_count; i++) {
 		mib = &ar8327_mib[i];
 		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
 
@@ -2141,15 +2131,12 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 static int
 qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
 {
-	const struct qca8k_match_data *match_data;
 	struct qca8k_priv *priv = ds->priv;
 
 	if (sset != ETH_SS_STATS)
 		return 0;
 
-	match_data = of_device_get_match_data(priv->dev);
-
-	return match_data->mib_count;
+	return priv->info->mib_count;
 }
 
 static int
@@ -3093,14 +3080,11 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
 {
-	const struct qca8k_match_data *data;
 	u32 val;
 	u8 id;
 	int ret;
 
-	/* get the switches ID from the compatible */
-	data = of_device_get_match_data(priv->dev);
-	if (!data)
+	if (!priv->info)
 		return -ENODEV;
 
 	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
@@ -3108,8 +3092,10 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
 		return -ENODEV;
 
 	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
-	if (id != data->id) {
-		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
+	if (id != priv->info->id) {
+		dev_err(priv->dev,
+			"Switch id detected %x but expected %x",
+			id, priv->info->id);
 		return -ENODEV;
 	}
 
@@ -3134,6 +3120,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->info = of_device_get_match_data(priv->dev);
 	priv->bus = mdiodev->bus;
 	priv->dev = &mdiodev->dev;
 
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index ec58d0e80a70..0b990b46890a 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -401,6 +401,7 @@ struct qca8k_priv {
 	struct qca8k_mdio_cache mdio_cache;
 	struct qca8k_pcs pcs_port_0;
 	struct qca8k_pcs pcs_port_6;
+	const struct qca8k_match_data *info;
 };
 
 struct qca8k_mib_desc {
-- 
2.36.1

