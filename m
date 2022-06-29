Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA0055F479
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiF2Dyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiF2Dyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:54:51 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7B4205D8
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:54:50 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id t26-20020a9d775a000000b006168f7563daso11258431otl.2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zT6ZznFkaTdmQtDR/I7q1fiiUEuYnpac/NIGkYGkHto=;
        b=PjDxawVi8fuUKmHEmVY3MyqdQe+2K3+fKuARweOfe28onUai6eh3kl9INQ3iDTyTd9
         D9DCsytQ85brRliJJhrUYIbu3qEE3/Yy5O0tSUazL1ZItjQ7aUCrs+NenbwoUmbzB7WZ
         2d5jrbFHm7ma2u+i4OZp4bFxzDwEVFTvbBtQ8bqlCueIq2p0YCHwPtLoOzkfwlxXkAw5
         cIrelOjwfsDzDZgF5eY8F4cFew+4Rq14CUJgwxEUP8+w24p3k5Hp8thX9jszoMC6FBBj
         YVYU+YcI1ZPKPtrJj8ZAXYmvRGF55oaYX/hwdOnkYQnBBXBglGr51r6VSRgSQudh4E71
         +6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zT6ZznFkaTdmQtDR/I7q1fiiUEuYnpac/NIGkYGkHto=;
        b=XZp+9QNVCtysNi1VRXe3e79SKvO5fZ3DqiH0lVTpTK6HqRxZYhtHYkYcszCPYXUkz0
         KRRoNOJOwCkXo/E4nsZ2fbp7O300TwEE/03CoIHxt3dHIb6zdzEvNQBg9BrtVEaXXmTs
         KfakqbLLT0iG6LhgufqAoRM7kSSt2FGSTZKqRpjX05Ajgr5DjgAnqheZuj7ftsrJ5puc
         /PY9VM7Ca+L8vwQg8hDKqYINJpvC27i0/vpdZ834IZX3IYvssqkxTgRNJF60SVsoDYHM
         KvmVSeQ4/TH/znUvT3Jbjb4CXGjEoN/311fg/xuiy9hn2b9/TCbJcSpjvAixGzpLijm3
         CRpg==
X-Gm-Message-State: AJIora9IV7C60/2F6+v95yVyG0+yZQr7KTBQxFy3xt4AJT4k4iw/VWzE
        QNbfhIBmasnB7FhH3ppocWxQyNrJr/JS6g==
X-Google-Smtp-Source: AGRyM1skBgJbuybToBBlHaJULzqg9upc7Ua9MEs04ghUxBfggZZ+lRZE7nqZIZkhYiovcqt1uZduzA==
X-Received: by 2002:a05:6830:2459:b0:616:ce47:fae8 with SMTP id x25-20020a056830245900b00616ce47fae8mr609838otr.291.1656474889147;
        Tue, 28 Jun 2022 20:54:49 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id r6-20020a056870580600b001089aef1815sm5636756oap.20.2022.06.28.20.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:54:47 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next RFC 1/3] net: dsa: realtek: rename switch_ops to its usage, not users
Date:   Wed, 29 Jun 2022 00:54:32 -0300
Message-Id: <20220629035434.1891-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629035434.1891-1-luizluca@gmail.com>
References: <20220629035434.1891-1-luizluca@gmail.com>
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

The difference between ds_ops_smi and ds_ops_mdio is only the presence
of phy_{read,write} because the realtek-smi implements a custom slave
MII while realtek-mdio uses the standard slave mii created by DSA. It's
better to have a name that reflects why we need different switch_ops
instead of who is using it.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-mdio.c | 2 +-
 drivers/net/dsa/realtek/realtek-smi.c  | 2 +-
 drivers/net/dsa/realtek/realtek.h      | 4 ++--
 drivers/net/dsa/realtek/rtl8365mb.c    | 8 ++++----
 drivers/net/dsa/realtek/rtl8366rb.c    | 8 ++++----
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index c58f49d558d2..90624a5102b5 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -222,7 +222,7 @@ static int realtek_mdio_probe(struct mdio_device *mdiodev)
 	priv->ds->dev = dev;
 	priv->ds->num_ports = priv->num_ports;
 	priv->ds->priv = priv;
-	priv->ds->ops = var->ds_ops_mdio;
+	priv->ds->ops = var->ds_ops;
 
 	ret = dsa_register_switch(priv->ds);
 	if (ret) {
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 45992f79ec8d..3eb9d67fd2de 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -498,7 +498,7 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	priv->ds->num_ports = priv->num_ports;
 	priv->ds->priv = priv;
 
-	priv->ds->ops = var->ds_ops_smi;
+	priv->ds->ops = var->ds_ops_custom_slavemii;
 	ret = dsa_register_switch(priv->ds);
 	if (ret) {
 		dev_err_probe(dev, ret, "unable to register switch\n");
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 4fa7c6ba874a..004a9ae91ccf 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -116,8 +116,8 @@ struct realtek_ops {
 };
 
 struct realtek_variant {
-	const struct dsa_switch_ops *ds_ops_smi;
-	const struct dsa_switch_ops *ds_ops_mdio;
+	const struct dsa_switch_ops *ds_ops_custom_slavemii;
+	const struct dsa_switch_ops *ds_ops;
 	const struct realtek_ops *ops;
 	unsigned int clk_delay;
 	u8 cmd_read;
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index da31d8b839ac..35fd32c4d340 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -2086,7 +2086,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 	return 0;
 }
 
-static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
+static const struct dsa_switch_ops rtl8365mb_switch_ops_custom_slavemii = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
 	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
@@ -2105,7 +2105,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_stats64 = rtl8365mb_get_stats64,
 };
 
-static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
+static const struct dsa_switch_ops rtl8365mb_switch_ops = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
 	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
@@ -2133,8 +2133,8 @@ static const struct realtek_ops rtl8365mb_ops = {
 };
 
 const struct realtek_variant rtl8365mb_variant = {
-	.ds_ops_smi = &rtl8365mb_switch_ops_smi,
-	.ds_ops_mdio = &rtl8365mb_switch_ops_mdio,
+	.ds_ops_custom_slavemii = &rtl8365mb_switch_ops_custom_slavemii,
+	.ds_ops = &rtl8365mb_switch_ops,
 	.ops = &rtl8365mb_ops,
 	.clk_delay = 10,
 	.cmd_read = 0xb9,
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 25f88022b9e4..7c3de3be3a53 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1793,7 +1793,7 @@ static int rtl8366rb_detect(struct realtek_priv *priv)
 	return 0;
 }
 
-static const struct dsa_switch_ops rtl8366rb_switch_ops_smi = {
+static const struct dsa_switch_ops rtl8366rb_switch_ops_custom_slavemii = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
 	.phylink_mac_link_up = rtl8366rb_mac_link_up,
@@ -1816,7 +1816,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops_smi = {
 	.port_max_mtu = rtl8366rb_max_mtu,
 };
 
-static const struct dsa_switch_ops rtl8366rb_switch_ops_mdio = {
+static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
 	.phy_read = rtl8366rb_dsa_phy_read,
@@ -1858,8 +1858,8 @@ static const struct realtek_ops rtl8366rb_ops = {
 };
 
 const struct realtek_variant rtl8366rb_variant = {
-	.ds_ops_smi = &rtl8366rb_switch_ops_smi,
-	.ds_ops_mdio = &rtl8366rb_switch_ops_mdio,
+	.ds_ops_custom_slavemii = &rtl8366rb_switch_ops_custom_slavemii,
+	.ds_ops = &rtl8366rb_switch_ops,
 	.ops = &rtl8366rb_ops,
 	.clk_delay = 10,
 	.cmd_read = 0xa9,
-- 
2.36.1

