Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB9E57EF73
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiGWOTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237479AbiGWOT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:19:26 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262301C10C;
        Sat, 23 Jul 2022 07:19:25 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id r9-20020a1c4409000000b003a34ac64bdfso799389wma.1;
        Sat, 23 Jul 2022 07:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=C8kzD0JzPswLobJ7sKwgOf7aZPC0Em801txgcu10yYs=;
        b=JUwOnbmC0zxvKWJ1D1UUbyCd3tlFKoqSuaWDL+aJAavXN+5B6gCC+NZ+ImRAvBZy/O
         +b+HYCZYBhiWluFvaBTcWwvaaQUkVETWcxdfpLPhJ6UYoaE4VbEXlxzBAY/b/AMoEZlQ
         +8vt0VyzIRL2Hgm0jyt1V/o+b02qcng0e7Pfkat+vs/Bz3mfj29o3iUvc+r2lHG3Xc8+
         2gMP2qVAfYGCowOS2jEt/fmjZzPybwxcnAPcfKXp6ystYnm48PCWI5E7SFzfK1mNq3Hl
         VwDuA5ApPkPhg3v8rDU9VdsAd42PN0KWdRfNgX9yccAX6uYldsL0nO/0KSIMXQgfBBPu
         Y/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C8kzD0JzPswLobJ7sKwgOf7aZPC0Em801txgcu10yYs=;
        b=m3u0FjUA6gfWRSnern8mMevdF9DWoZEU6b2bnFxEnyO4bufbYDt5osxMgr+EyiNogt
         4zums+UIDmafLKf5hbzgfDLZ2c/Hn1n0PRMRsfBP3vDxXGc8lkq595BrA3P2kI+HdbnZ
         jdlTCHIu0B+vchq1po07hNaeVgO0kpCSMT3k8hZ1G4O2s5/I44G4Bgv0CEiudbgdv96h
         pLV83Mpd+C3hw6yhyegXqI+rqW2eNCJ3uvgpKOANgh+EQuO4ATFLwXu8nFoz5YmPE4NX
         DTR9HUgF6d1s1puZcdsHoFskbhANomiYPABYYW2q++YH4l8uDcFikZRTlWsoYvSGyWv+
         OVUw==
X-Gm-Message-State: AJIora/9nsretFv8C0QZKRdpEsp8Lomkd2d63aurNiXqW/T5n5ivLGp4
        m0DWh8QNxQm3tJZyia27/axGQvyOfqQ=
X-Google-Smtp-Source: AGRyM1sMaojzgKi/v5ZymkETHKRCzKJIwTE0Cor7mFaUBDUhXWSacLIIcVKIh73jPSb8hOOdbjPSQQ==
X-Received: by 2002:a05:600c:4e0d:b0:3a3:bc7:e9ec with SMTP id b13-20020a05600c4e0d00b003a30bc7e9ecmr16016546wmq.167.1658585963352;
        Sat, 23 Jul 2022 07:19:23 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:22 -0700 (PDT)
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
Subject: [net-next PATCH v3 01/14] net: dsa: qca8k: cache match data to speed up access
Date:   Sat, 23 Jul 2022 16:18:32 +0200
Message-Id: <20220723141845.10570-2-ansuelsmth@gmail.com>
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

Using of_device_get_match_data is expensive. Cache match data to speed
up access and rework user of match data to use the new cached value.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k.c | 28 ++++++++++------------------
 drivers/net/dsa/qca/qca8k.h |  1 +
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
index 1cbb05b0323f..212b284f9f73 100644
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
@@ -3168,6 +3155,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (ret)
 		return ret;
 
+	/* Cache match data in priv struct.
+	 * Match data is already checked in read_switch_id.
+	 */
+	priv->info = of_device_get_match_data(priv->dev);
+
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
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

