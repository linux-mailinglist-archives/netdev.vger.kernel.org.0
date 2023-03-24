Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6660A6C8481
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjCXSHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbjCXSHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:07:20 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B5D1DBAA
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:06:09 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id m2so2665071wrh.6
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679681168;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=29gzwfTDqQIKh84PweRohtsZRfLe1oRnatdEHtQFCik=;
        b=SqROm6enyhXsjaieRj51yDyrCY9XxQ7EW9pW5FfQSN7l3NeDD38iGgjo/ZgzEOMAqQ
         800sb/9qJRE8PfvS7Za2U3esXR3E1vPf9y0uHypGzJ9GRuLGT/lwBcrC0RpmSZDDMPXn
         M4ZOlEk4y0mKftopKC2/aH/jhWTZNIV9+011U5Lj0n76CN5Dl5lP+trwIYPq3e1T/We2
         ozZo96CVbyFgv3IbenImFYvOzvfKm1WCA0p7beBq0wIxPHWU/qV3EmAywGe6Y1T6QwSq
         DOBoL8DotnwfrMDBvGz9+SbzRXgcPWSFAuot1OIysEfq/mMTP62G8xgiOX+DyDx07q0h
         bVww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679681168;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=29gzwfTDqQIKh84PweRohtsZRfLe1oRnatdEHtQFCik=;
        b=eZIPZSMemptHrwDCUWsMIR3+c/nvCmqhJOTJHuGA6c0W3WuSPYEFfBh/yDvgyTBobx
         PFRZD8RGQ5zMaDUKa0Sh6dYxQOBG84Ow7SSUZYFSS+jtOf3deQOEj/o/Hu2sHYp7f+2K
         KeW508zDAvJcaLA6MZMpJNQW4UhP6lXjHOShS8acQit35xsATUIZCnoRMvjwyqZMU6qy
         kMTCM4FPTZis+zmbthLtUcPSe0YGL9aQfz+qhxxBFvCGIaM1byMDKj0PpkvW2tclds0p
         iCKhFsMzDfjfGA1x5XVoODYPUx2gtoinNZjyvNCVlFsUauLsVEyFEwbEPmv8v2/vqOzY
         5+WQ==
X-Gm-Message-State: AAQBX9erHcCrbwXyEYjs3ilRnNoka/UyAFvv9YhY4lVm4k14aVIVe7Lj
        JqGLiAIBM7VUp397U4Lp3sA=
X-Google-Smtp-Source: AKy350bozDB2wiiQfZd+/UZNQia6L+kBbI01m3eJLsKL4Ly3KURz4H87lVi4xvL75MAkA1l8HE1fsg==
X-Received: by 2002:adf:e30c:0:b0:2d1:5698:3f70 with SMTP id b12-20020adfe30c000000b002d156983f70mr5979056wrj.29.1679681168365;
        Fri, 24 Mar 2023 11:06:08 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b926:df00:a161:16e2:f237:a7d4? (dynamic-2a01-0c23-b926-df00-a161-16e2-f237-a7d4.c23.pool.telefonica.de. [2a01:c23:b926:df00:a161:16e2:f237:a7d4])
        by smtp.googlemail.com with ESMTPSA id e11-20020a5d65cb000000b002c55de1c72bsm18847485wrw.62.2023.03.24.11.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 11:06:08 -0700 (PDT)
Message-ID: <8d1e588f-72a4-ffff-f0f3-dbb071838a08@gmail.com>
Date:   Fri, 24 Mar 2023 19:05:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: [PATCH net-next 4/4] net: phy: bcm7xxx: remove getting reference
 clock
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
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
References: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
In-Reply-To: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
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

Now that getting the reference clock has been moved to phylib,
we can remove it here.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/bcm7xxx.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 75593e7d1..c608e0439 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -11,7 +11,6 @@
 #include "bcm-phy-lib.h"
 #include <linux/bitops.h>
 #include <linux/brcmphy.h>
-#include <linux/clk.h>
 #include <linux/mdio.h>
 
 /* Broadcom BCM7xxx internal PHY registers */
@@ -45,7 +44,6 @@
 
 struct bcm7xxx_phy_priv {
 	u64	*stats;
-	struct clk *clk;
 };
 
 static int bcm7xxx_28nm_d0_afe_config_init(struct phy_device *phydev)
@@ -825,14 +823,6 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	if (!priv->stats)
 		return -ENOMEM;
 
-	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);
-	if (IS_ERR(priv->clk))
-		return PTR_ERR(priv->clk);
-
-	ret = clk_prepare_enable(priv->clk);
-	if (ret)
-		return ret;
-
 	/* Dummy read to a register to workaround an issue upon reset where the
 	 * internal inverter may not allow the first MDIO transaction to pass
 	 * the MDIO management controller and make us return 0xffff for such
@@ -844,13 +834,6 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
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
@@ -866,7 +849,6 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
-	.remove		= bcm7xxx_28nm_remove,				\
 }
 
 #define BCM7XXX_28NM_EPHY(_oui, _name)					\
@@ -882,7 +864,6 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
-	.remove		= bcm7xxx_28nm_remove,				\
 	.read_mmd	= bcm7xxx_28nm_ephy_read_mmd,			\
 	.write_mmd	= bcm7xxx_28nm_ephy_write_mmd,			\
 }
@@ -908,7 +889,6 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 	/* PHY_BASIC_FEATURES */					\
 	.flags		= PHY_IS_INTERNAL,				\
 	.probe		= bcm7xxx_28nm_probe,				\
-	.remove		= bcm7xxx_28nm_remove,				\
 	.config_init	= bcm7xxx_16nm_ephy_config_init,		\
 	.config_aneg	= genphy_config_aneg,				\
 	.read_status	= genphy_read_status,				\
-- 
2.40.0


