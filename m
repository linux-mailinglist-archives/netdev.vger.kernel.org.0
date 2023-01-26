Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5353B67D693
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 21:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjAZUj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 15:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjAZUjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 15:39:25 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD8E24120
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:39:23 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id j17so2032524wms.0
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZgatdbWz2FD9GEgxsoRHVJqmbzaK52XW7ywAP+xink=;
        b=FEBcBjO9m3Eod0WdkjmxkiGRB9P0AFYQuuJjQU5gqHy7eQEt+uJ7TvE7pm+9ZeBHMY
         spHhdQUgReDcMSfcmJOewZWIrDwOfrPxftwGBjDpQGRJaQsEOZzTyJcCKM+EGjI6/xC4
         xuOm8fmfvzJV7nxAUxK8zHt4t2iHNeuAYFFjukBmwcMfdqQHf/Cmo3oPlvPHTH5XCcfO
         deByPeM2l8kq85zcZDNUqs9Fu1kpCeJz2P1lyqEdkEp3q95mvhzh2BBBsHgrR1AsvzYn
         F0bY//iCPGe53ZfhvqohOFsZAEOjQBRPLv4KeCgx2Y0IWEWQxrmtmfcDkldTWVH52Mae
         4V5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GZgatdbWz2FD9GEgxsoRHVJqmbzaK52XW7ywAP+xink=;
        b=LZuoDFDOgnJt8QdAC6ZtGLZw6IMiX/Pb6D7lMutYarkJ58+52p1CYz5V/TKG7pJh6u
         g9J61huB2xsl/onYyE2igYhmK/BPDI/lwr3slaeTyvgWSuR4EK9grzbIRhC+4c/74UWQ
         RN4b7s5jRkuRNnTR+dvnUUfD/3A0YraCKmCrPaZV6ox6flV5ycCbR7uSQg0XLfQFKAgy
         UCZxh+kCtbXsRFZLjTEijBYZwzvay5tFlC9Twq+8ME6YNh5sNPnJJL9sL/v8f3yMLdVR
         mM+lTVnlhgNMTchClOmCrdyhxG3ONcazR7yEY3OeImj/CuNEgsk7uEIXYiu0IGmU0nY8
         8LJQ==
X-Gm-Message-State: AFqh2kpVOQl1fEbvdbjGMB+sGpE+9M3N3rCyJnPviKhYEa6UsbCx8bdY
        XBAru42laxOIk5i45oBGcYk=
X-Google-Smtp-Source: AMrXdXuejlGmeFkAbAis+YK9cjGTabhluoIdNOWdbcp2kIed5bwpGZdjyz1CMpaKMXk98+KbgkvpYQ==
X-Received: by 2002:a05:600c:6001:b0:3da:f80a:5e85 with SMTP id az1-20020a05600c600100b003daf80a5e85mr36084368wmb.26.1674765562233;
        Thu, 26 Jan 2023 12:39:22 -0800 (PST)
Received: from ?IPV6:2a01:c23:c0e4:9a00:897e:7437:5b21:dc78? (dynamic-2a01-0c23-c0e4-9a00-897e-7437-5b21-dc78.c23.pool.telefonica.de. [2a01:c23:c0e4:9a00:897e:7437:5b21:dc78])
        by smtp.googlemail.com with ESMTPSA id e19-20020a05600c439300b003cfd4e6400csm2353520wmn.19.2023.01.26.12.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 12:39:21 -0800 (PST)
Message-ID: <84fb199a-d459-646f-8522-0fe1f7455e26@gmail.com>
Date:   Thu, 26 Jan 2023 21:39:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: mdio: mux-meson-g12a: use __clk_is_enabled to
 simplify the code
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

By using __clk_is_enabled () we can avoid defining an own variable for
tracking whether enable counter is zero.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/mdio/mdio-mux-meson-g12a.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
index 1c1ed6e11..9d21fdf85 100644
--- a/drivers/net/mdio/mdio-mux-meson-g12a.c
+++ b/drivers/net/mdio/mdio-mux-meson-g12a.c
@@ -52,7 +52,6 @@
 #define MESON_G12A_MDIO_INTERNAL_ID 1
 
 struct g12a_mdio_mux {
-	bool pll_is_enabled;
 	void __iomem *regs;
 	void *mux_handle;
 	struct clk *pll;
@@ -152,14 +151,12 @@ static int g12a_enable_internal_mdio(struct g12a_mdio_mux *priv)
 	int ret;
 
 	/* Enable the phy clock */
-	if (!priv->pll_is_enabled) {
+	if (!__clk_is_enabled(priv->pll)) {
 		ret = clk_prepare_enable(priv->pll);
 		if (ret)
 			return ret;
 	}
 
-	priv->pll_is_enabled = true;
-
 	/* Initialize ephy control */
 	writel(EPHY_G12A_ID, priv->regs + ETH_PHY_CNTL0);
 	writel(FIELD_PREP(PHY_CNTL1_ST_MODE, 3) |
@@ -183,10 +180,8 @@ static int g12a_enable_external_mdio(struct g12a_mdio_mux *priv)
 	writel_relaxed(0x0, priv->regs + ETH_PHY_CNTL2);
 
 	/* Disable the phy clock if enabled */
-	if (priv->pll_is_enabled) {
+	if (__clk_is_enabled(priv->pll))
 		clk_disable_unprepare(priv->pll);
-		priv->pll_is_enabled = false;
-	}
 
 	return 0;
 }
@@ -338,7 +333,7 @@ static int g12a_mdio_mux_remove(struct platform_device *pdev)
 
 	mdio_mux_uninit(priv->mux_handle);
 
-	if (priv->pll_is_enabled)
+	if (__clk_is_enabled(priv->pll))
 		clk_disable_unprepare(priv->pll);
 
 	return 0;
-- 
2.39.1

