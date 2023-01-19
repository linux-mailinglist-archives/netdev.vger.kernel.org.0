Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384D06746E8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 00:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjASXFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 18:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjASXEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 18:04:42 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1327B1EC2
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:56:40 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v13so4739500eda.11
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SYzf9HQ2zlUGg3W9mPTO46OUelCFeD43C5kDuMpqvvU=;
        b=pXYdwUYtSxHogD1l+kDYFbRzwNvcs4Yq4ulD3fwZgn4Lbyw98DRR0gofVKaHwRMkG0
         Z8eyMNh6IpWlojrx/NZM+QGlLPdl+0FdYBO8Tk6Ruy0Rwd89hEcPxwFUaYDSfA3KQkbx
         wHRI498eygOJOyZN4X8MWR59DKi9RlZg4Lo2AHgR+tQ4WZ/fLMt4USEOGN5LAAPQ8qPP
         bdwD5aTGtJt0qmYwrHpKwi79xuEOnSAWVbmbtBxho2xRCcH9Z8jMsKvdzABF+nWs369E
         0pQxHiX3z57GpBOQI8vOT5nNcqfkFY80f9z9QjbrYrrA+LStNSRVpqVgNNj8l2nsjwXl
         tvcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SYzf9HQ2zlUGg3W9mPTO46OUelCFeD43C5kDuMpqvvU=;
        b=pKAQrl+xu75+zUhrlW/4v1gWdS9Zo0eZUDJO9+0FyiBmcuqAi/unUsih0eFTFiaCxo
         9crkR76uCsjbGxUnL3+m0RLxz5LaHnB6bb1Eeib7qwMCaZiv9f9em/Jjbpo0bthNKYbU
         wM6Il0tdUPXZigSXnfLiMHdLUNVD2II2NHNz94fqjDHhb8ZyhGMNKIQUmiRzHGT6cjne
         wRVCOQTdR1Apw6RaXiPFympN8eboKxEZnAOt6W8fgVLp5Bt6wtkiFXsb705k/HvKd72t
         HU0+6Z1eAYE++LOuZYc/SwAo+LRaG/Og/k+nLRdlckZiuaTzHxALnW/Xoany69pbJujZ
         jySg==
X-Gm-Message-State: AFqh2kpyM/0z7koqdv6zcSggXMLZSAhCRublcQqHNB951BAuv5kqOpe4
        lNHJrsHOBRBPj8J4q5iWkOw=
X-Google-Smtp-Source: AMrXdXtF9IP2s6z+07gKEoKa8OoYIDT6JSpK9fzswy9qaIjIix7cUoQbSi1UTt0aFFRx4FVc8YEs2A==
X-Received: by 2002:a05:6402:448d:b0:498:2f9f:3442 with SMTP id er13-20020a056402448d00b004982f9f3442mr13693762edb.2.1674168999104;
        Thu, 19 Jan 2023 14:56:39 -0800 (PST)
Received: from ?IPV6:2a01:c23:c477:4300:3c6e:3915:fc5a:2ff1? (dynamic-2a01-0c23-c477-4300-3c6e-3915-fc5a-2ff1.c23.pool.telefonica.de. [2a01:c23:c477:4300:3c6e:3915:fc5a:2ff1])
        by smtp.googlemail.com with ESMTPSA id er25-20020a056402449900b0049e06995d99sm6750247edb.75.2023.01.19.14.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 14:56:38 -0800 (PST)
Message-ID: <84871cc7-2f96-7252-768f-5f869208045b@gmail.com>
Date:   Thu, 19 Jan 2023 23:56:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: mdio: mux-meson-g12a: use devm_clk_get_enabled
 to simplify the code
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hilman <khilman@baylibre.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch> <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
 <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
 <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
Content-Language: en-US
In-Reply-To: <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_clk_get_enabled() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/mdio/mdio-mux-meson-g12a.c | 27 ++++++--------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
index 4a2e94faf..1c1ed6e11 100644
--- a/drivers/net/mdio/mdio-mux-meson-g12a.c
+++ b/drivers/net/mdio/mdio-mux-meson-g12a.c
@@ -55,7 +55,6 @@ struct g12a_mdio_mux {
 	bool pll_is_enabled;
 	void __iomem *regs;
 	void *mux_handle;
-	struct clk *pclk;
 	struct clk *pll;
 };
 
@@ -302,6 +301,7 @@ static int g12a_mdio_mux_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct g12a_mdio_mux *priv;
+	struct clk *pclk;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -314,34 +314,21 @@ static int g12a_mdio_mux_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->regs))
 		return PTR_ERR(priv->regs);
 
-	priv->pclk = devm_clk_get(dev, "pclk");
-	if (IS_ERR(priv->pclk))
-		return dev_err_probe(dev, PTR_ERR(priv->pclk),
+	pclk = devm_clk_get_enabled(dev, "pclk");
+	if (IS_ERR(pclk))
+		return dev_err_probe(dev, PTR_ERR(pclk),
 				     "failed to get peripheral clock\n");
 
-	/* Make sure the device registers are clocked */
-	ret = clk_prepare_enable(priv->pclk);
-	if (ret) {
-		dev_err(dev, "failed to enable peripheral clock");
-		return ret;
-	}
-
 	/* Register PLL in CCF */
 	ret = g12a_ephy_glue_clk_register(dev);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = mdio_mux_init(dev, dev->of_node, g12a_mdio_switch_fn,
 			    &priv->mux_handle, dev, NULL);
-	if (ret) {
+	if (ret)
 		dev_err_probe(dev, ret, "mdio multiplexer init failed\n");
-		goto err;
-	}
 
-	return 0;
-
-err:
-	clk_disable_unprepare(priv->pclk);
 	return ret;
 }
 
@@ -354,8 +341,6 @@ static int g12a_mdio_mux_remove(struct platform_device *pdev)
 	if (priv->pll_is_enabled)
 		clk_disable_unprepare(priv->pll);
 
-	clk_disable_unprepare(priv->pclk);
-
 	return 0;
 }
 
-- 
2.39.0


