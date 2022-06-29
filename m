Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DB955F490
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiF2DzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiF2Dy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:54:58 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A5E29808
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:54:54 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-101bb9275bcso19771665fac.8
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 20:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QNzQn/kZnGRmAeuFru6HW4F7EfldgkyUkpR5YkXQfwk=;
        b=UKVg5bxtqemAHqpSOlx+3tgwdsaBX8xJwuhu6vYY+rBpngnr0vweVAX4gv6dTDgcdT
         7xdxYV2mXsRRu0+Kue8r3FooDPFaKVSslELHddyeFINJ7hBAu2FZhbFpTOkIYgTCV/6W
         7gEgy1ElqyjC1b/BmffTE29aILjwlqHzGTPCCzLJxWNigJiiOPAue6QFjy95PuASuZE6
         Mg+8KZVOu9RqxYMUv1EFcBfH/nLLHWXDboFZojyo8vaNWFstmMqDzHRXUGdJTp1lJ0cY
         c6ulmq9DRk0rfG3VCNS/OZwkWQXjgQvJdMxyN8pw7VqKwIe9wPNws5w9H4BbEIQEY0uL
         0URQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QNzQn/kZnGRmAeuFru6HW4F7EfldgkyUkpR5YkXQfwk=;
        b=kLWX2C/W7PZpYJCmJ91siSugoTyf0+IpzxQ+g+NF/lulbzocyEbSh3U1ga3qCQniv9
         htjRrGK2jAdrtdjqH0qEop0nHKvQL+RMR2jx8i5yYxvXvqZlsiFG5+RWACnd73gPrT2d
         Lxy3Ui2QeVjEFVOpVqJIk7+4Tm1+gCGvq5ye8UG2pGBHTEgpj3BN+ACBxu2lI77yb5VP
         IO38faL5q+OnBQedtxDdxvhimyZGKZVv9IYtFf4NNTN8MznG869/qlEiGA1xFyXjrynF
         ENlpr/APJDJ4gYY4ncix4K+hAvarwh5SEQEf8JMR/Kb2zPdMsHMKmGNjyprztuion7FU
         B09A==
X-Gm-Message-State: AJIora8be9iOuK9Rkr65z4VuNMXzCIHzWSxXhKhqS6cjACWlkwipu3SR
        nJ1SYh4U/jG8qnuXMTXWrj6nQzfuV4+RrA==
X-Google-Smtp-Source: AGRyM1tq7/Gme7OzCGkvoyg8PgO0fSMvOwDqTCzHG3XpVFZ4hrVSRGtTeuJNy4m/JwY+qStXgBdt0w==
X-Received: by 2002:a05:6870:b414:b0:10b:8204:7e95 with SMTP id x20-20020a056870b41400b0010b82047e95mr727264oap.88.1656474893256;
        Tue, 28 Jun 2022 20:54:53 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id r6-20020a056870580600b001089aef1815sm5636756oap.20.2022.06.28.20.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:54:52 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next RFC 2/3] net: dsa: realtek: deprecate custom slave mii
Date:   Wed, 29 Jun 2022 00:54:33 -0300
Message-Id: <20220629035434.1891-3-luizluca@gmail.com>
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

The custom slave mii was required only to parse the OF mdio node.
However, since fe7324b932, the standard slave mii created by dsa already
looks for an "mdio" node.

The realtek-smi was using a compatible string ("realtek,smi-mdio") to
find the slave mdio node. Although device-tree bindings and examples all
use "mdio". If the name does not match "mdio", the driver will still use
the custom mii slave. The driver will also ask to remove the compatible
string if it exists in the "mdio" node.

After a grace period, we can remove:
- realtek_variant.ds_ops_custom_slavemii
- realtek_ops.phy_{read,write}
- realtek_ops.setup_interface
- {rtl8365mb,rtl8366rb}_phy_{read,write}
- realtek_smi_setup_mdio

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-smi.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 3eb9d67fd2de..c3668a9208ac 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -379,6 +379,10 @@ static int realtek_smi_setup_mdio(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
+	dev_warn(priv->dev,
+		 "Rename '%s' to 'mdio' and remove the compatible string\n",
+		  mdio_np->full_name);
+
 	priv->slave_mii_bus = devm_mdiobus_alloc(priv->dev);
 	if (!priv->slave_mii_bus) {
 		ret = -ENOMEM;
@@ -412,10 +416,10 @@ static int realtek_smi_setup_mdio(struct dsa_switch *ds)
 static int realtek_smi_probe(struct platform_device *pdev)
 {
 	const struct realtek_variant *var;
+	struct device_node *np, *mdio_np;
 	struct device *dev = &pdev->dev;
 	struct realtek_priv *priv;
 	struct regmap_config rc;
-	struct device_node *np;
 	int ret;
 
 	var = of_device_get_match_data(dev);
@@ -452,7 +456,6 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	priv->cmd_write = var->cmd_write;
 	priv->ops = var->ops;
 
-	priv->setup_interface = realtek_smi_setup_mdio;
 	priv->write_reg_noack = realtek_smi_write_reg_noack;
 
 	dev_set_drvdata(dev, priv);
@@ -497,8 +500,20 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	priv->ds->dev = dev;
 	priv->ds->num_ports = priv->num_ports;
 	priv->ds->priv = priv;
+	priv->ds->ops = var->ds_ops;
+
+	mdio_np = of_get_child_by_name(np, "mdio");
+	if (mdio_np) {
+		if (of_device_is_compatible(mdio_np, "realtek,smi-mdio"))
+			dev_warn(dev, "Remove deprecated prop '%s' from '%s'",
+				 "compatible = \"realtek,smi-mdio\"",
+				 mdio_np->full_name);
+		of_node_put(mdio_np);
+	} else {
+		priv->ds->ops = var->ds_ops_custom_slavemii;
+		priv->setup_interface = realtek_smi_setup_mdio;
+	}
 
-	priv->ds->ops = var->ds_ops_custom_slavemii;
 	ret = dsa_register_switch(priv->ds);
 	if (ret) {
 		dev_err_probe(dev, ret, "unable to register switch\n");
-- 
2.36.1

