Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589354B90AA
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiBPSqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:46:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiBPSqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:46:52 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5B170842;
        Wed, 16 Feb 2022 10:46:39 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id h7-20020a17090a648700b001b927560c2bso3228756pjj.1;
        Wed, 16 Feb 2022 10:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y4qUT6p/ojssA+s5XpkcSdKzl/eCfrm+8A6a9qlh8p8=;
        b=WHYWNniFWxl0kfD4p9x4jmwixS7KtEgDunCFE59SLvehBCOGtwBHNvL7bMIBTytKF3
         LLYl1gAkvf+1Y53/a0tPAEIsXACZ8zs+qcKJEhvyAVKTjMXPzegkcdsyyR8J5/ZyHLYQ
         gd3WZWjrCmncARfP/rr9D1i9pHE3ForB5/p9J/lZnYpe74bh7JuQWSL+6RHE0qnPOz23
         siyXlZSNKbBcsqVBy/v3Zr+tk224TXuLcD2kX/+scBOMQKTgMiuXjivdMWex6b9DaMum
         tX2JcHq4ORV/vfSK30eCY+IojW5xbTD19Xhy1gy1f/qIpgnKsuxj4qjknTA9i55ORJfg
         Hb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y4qUT6p/ojssA+s5XpkcSdKzl/eCfrm+8A6a9qlh8p8=;
        b=d/ea22yliVxoUb7hmDJLM3blQReL84U1YXPgyHw++VAwpz6xbfNDILGt/3c65UjzpI
         6d/hB18l0imIQ2olabnlSZ7b9u2CfUh/FbW0D4PsExh2jaVlaEWvBm/zFmbxx7L3uU32
         mS+o0iJO8xm3Wl89A2Sz85hPeGlOmtm4u6+f9W2SbWTUk0wfdWeHlQLBI67uEfSgdRwe
         cQjFyBid7SgAx9FX1UB6X/K2ADwf4ClFt+re1upzyM74kb+TpjfeBItbkq01wdwkt9T8
         y6pW++3Lm6BDVI8kAWI206Vsrj1gV+e7ISHbtf0KZlUpf1sflqVaE3FrxAHMpOuRyK/G
         yqFQ==
X-Gm-Message-State: AOAM530KfrJyglXpYYgVSNJLlXvGJOL6zqPZn45ENWDHgAuchMjhKFFt
        +NrzLPEoqs7Iny5JtRVF40L8on/j588=
X-Google-Smtp-Source: ABdhPJzJeoMXADEy6V4Sl+21gwzsWdV57QczvYO60VYh2SY4plUMbPFJhZVnl9mX6TXMiAXE1x4Qaw==
X-Received: by 2002:a17:902:9007:b0:14f:3680:66d1 with SMTP id a7-20020a170902900700b0014f368066d1mr187990plp.91.1645037198106;
        Wed, 16 Feb 2022 10:46:38 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k3sm6051723pgt.29.2022.02.16.10.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 10:46:37 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, Jonas Gorski <jonas.gorski@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] Revert "net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname"
Date:   Wed, 16 Feb 2022 10:46:34 -0800
Message-Id: <20220216184634.2032460-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: Jonas Gorski <jonas.gorski@gmail.com>

This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.

Since idm_base and nicpm_base are still optional resources not present
on all platforms, this breaks the driver for everything except Northstar
2 (which has both).

The same change was already reverted once with 755f5738ff98 ("net:
broadcom: fix a mistake about ioremap resource").

So let's do it again.

Fixes: 3710e80952cf ("net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
[florian: Added comments to explain the resources are optional]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/ethernet/broadcom/bgmac-platform.c    | 23 +++++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index c6412c523637..b4381cd41979 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -172,6 +172,7 @@ static int bgmac_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct bgmac *bgmac;
+	struct resource *regs;
 	int ret;
 
 	bgmac = bgmac_alloc(&pdev->dev);
@@ -208,15 +209,23 @@ static int bgmac_probe(struct platform_device *pdev)
 	if (IS_ERR(bgmac->plat.base))
 		return PTR_ERR(bgmac->plat.base);
 
-	bgmac->plat.idm_base = devm_platform_ioremap_resource_byname(pdev, "idm_base");
-	if (IS_ERR(bgmac->plat.idm_base))
-		return PTR_ERR(bgmac->plat.idm_base);
-	else
+	/* The idm_base resource is optional for some platforms */
+	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "idm_base");
+	if (regs) {
+		bgmac->plat.idm_base = devm_ioremap_resource(&pdev->dev, regs);
+		if (IS_ERR(bgmac->plat.idm_base))
+			return PTR_ERR(bgmac->plat.idm_base);
 		bgmac->feature_flags &= ~BGMAC_FEAT_IDM_MASK;
+	}
 
-	bgmac->plat.nicpm_base = devm_platform_ioremap_resource_byname(pdev, "nicpm_base");
-	if (IS_ERR(bgmac->plat.nicpm_base))
-		return PTR_ERR(bgmac->plat.nicpm_base);
+	/* The nicpm_base resource is optional for some platforms */
+	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nicpm_base");
+	if (regs) {
+		bgmac->plat.nicpm_base = devm_ioremap_resource(&pdev->dev,
+							       regs);
+		if (IS_ERR(bgmac->plat.nicpm_base))
+			return PTR_ERR(bgmac->plat.nicpm_base);
+	}
 
 	bgmac->read = platform_bgmac_read;
 	bgmac->write = platform_bgmac_write;
-- 
2.25.1

