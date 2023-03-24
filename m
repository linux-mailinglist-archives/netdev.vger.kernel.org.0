Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5AD6C876D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 22:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjCXVYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 17:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjCXVYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 17:24:12 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82421BDFC
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:24:10 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j24so3106012wrd.0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679693049;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLFTrtR1oCgSFXu1eAtdOfFIXR58mSq/cky8xQk6wls=;
        b=ltVTAcJ8a4Q0n6KTVcecPh6HHRdOgTe9I+s04Yyyw9AfR7aWLPc7bzGoVmRMYz+I4F
         hgWRP+L/20mqMkUsjle0CpTgwEeWGBcGWNV7bQTovaWkd0CFQynkoEmZjdvMQwUmDu3E
         jfaA95v0QOaQVjhboYHeYrPA0Sd9qtLaFxEuh4Z6CNZ3C8b1Lj+u71GpZLfSNTPdzp+i
         mxNmweTab0gmqopQDMk7ivIMqjpqMWjFjBwo4vXQu28FM0RWxMp+Q12ZS3Dwgn59JeFT
         dvVtZAPPVMDRgWRqGg/ZdyGimAibVslLF2m4IZS7FWQ9e/VegbaQlfFgy/zKtf03cmNT
         +7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679693049;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sLFTrtR1oCgSFXu1eAtdOfFIXR58mSq/cky8xQk6wls=;
        b=VWiAQ2tI8VvwSdOe+8hlF8+aZgGSzvboVKsH0KbnJyy62ocoUBhHqPGvZa0tpXWDwr
         eT5/6Rj1b7Xl6qP8L9dsJneg1KvF7Bne8ltR+bjK28fGvBfgLoufg2vk0I89oOmf6+bP
         aKMfv063+j/gEJL8oWFc3UosNTKZzAeHh9c+uXECqdl8ORzETZh6cHxkF+IVeA4OqSjv
         1E7aG0mZ+OrPhFGhHitDXv0MNSwxZELIy28lwJKase8DrlwRckdtxlhCQYbfJCoQkpu+
         2bIu7muF8XVXhupGCOHvjjPsLo5nYQu6XDCHFfpBxuHZqWQt6j2tcZpctyce8ccNFOdW
         eoNQ==
X-Gm-Message-State: AAQBX9dhCOJ3BAXCSWtVnThzyW4kHD/k//RR7CYUQ15QdBkred/IlqY7
        gkg0wevO54QvnatZ3CLVkiU=
X-Google-Smtp-Source: AKy350aIk809RjhjcWg6hDfcx5dcNmUnOacEbrV+qNw/RO1HIE2F/jk2lE5hYv0Jmul5uMX5GiuDmQ==
X-Received: by 2002:a5d:6602:0:b0:2ce:a8a1:3085 with SMTP id n2-20020a5d6602000000b002cea8a13085mr3387714wru.28.1679693048730;
        Fri, 24 Mar 2023 14:24:08 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b926:df00:a161:16e2:f237:a7d4? (dynamic-2a01-0c23-b926-df00-a161-16e2-f237-a7d4.c23.pool.telefonica.de. [2a01:c23:b926:df00:a161:16e2:f237:a7d4])
        by smtp.googlemail.com with ESMTPSA id s15-20020a5d6a8f000000b002d743eeab39sm12392990wru.58.2023.03.24.14.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 14:24:08 -0700 (PDT)
Message-ID: <5603487f-3b80-b7ec-dbd2-609fa8020e58@gmail.com>
Date:   Fri, 24 Mar 2023 22:23:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: bcm7xxx: use devm_clk_get_optional_enabled
 to simplify the code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_clk_get_optional_enabled to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/bcm7xxx.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 75593e7d1..06be71ecd 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -45,7 +45,6 @@
 
 struct bcm7xxx_phy_priv {
 	u64	*stats;
-	struct clk *clk;
 };
 
 static int bcm7xxx_28nm_d0_afe_config_init(struct phy_device *phydev)
@@ -811,6 +810,7 @@ static void bcm7xxx_28nm_get_phy_stats(struct phy_device *phydev,
 static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 {
 	struct bcm7xxx_phy_priv *priv;
+	struct clk *clk;
 	int ret = 0;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
@@ -825,13 +825,9 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	if (!priv->stats)
 		return -ENOMEM;
 
-	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);
-	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
-
-	ret = clk_prepare_enable(priv->clk);
-	if (ret)
-		return ret;
+	clk = devm_clk_get_optional_enabled(&phydev->mdio.dev, NULL);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 
 	/* Dummy read to a register to workaround an issue upon reset where the
 	 * internal inverter may not allow the first MDIO transaction to pass
@@ -844,13 +840,6 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	return ret;
 }
 
-static void bcm7xxx_28nm_remove(struct phy_device *phydev)
-{
-	struct bcm7xxx_phy_priv *priv = phydev->priv;
-
-	clk_disable_unprepare(priv->clk);
-}
-
 #define BCM7XXX_28NM_GPHY(_oui, _name)					\
 {									\
 	.phy_id		= (_oui),					\
@@ -866,7 +855,6 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
-	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_28NM_EPHY(_oui, _name)					\
@@ -882,7 +870,6 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
-	.remove		= bcm7xxx_28nm_remove,				\
 	.read_mmd	= bcm7xxx_28nm_ephy_read_mmd,			\
 	.write_mmd	= bcm7xxx_28nm_ephy_write_mmd,			\
 }
@@ -908,7 +895,6 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 	/* PHY_BASIC_FEATURES */					\
 	.flags		= PHY_IS_INTERNAL,				\
 	.probe		= bcm7xxx_28nm_probe,				\
-	.remove		= bcm7xxx_28nm_remove,				\
 	.config_init	= bcm7xxx_16nm_ephy_config_init,		\
 	.config_aneg	= genphy_config_aneg,				\
 	.read_status	= genphy_read_status,				\
-- 
2.40.0

