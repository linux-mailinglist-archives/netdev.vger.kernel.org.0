Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C111DF792
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 15:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgEWN1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 09:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387882AbgEWN12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 09:27:28 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CA6C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 06:27:27 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w7so12931458wre.13
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 06:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64kvwBG1/A4ZIpIpQ81Lq/ynCrPXhKaGjAzI5WzwgPE=;
        b=WCoxlxcAreaFf6FWNGwNvYKxgyg/0gU+HbaYFg23bXDv4PSZYQHZlcxTOz7FCYoubj
         5e5E0jUoENWF/3lKC2kOeluwhMEcroHJYd4LLhnNzHEnkUXIYnNGkbayPKVmcdBOa4Ct
         Zd7GHa3AvzA8wj3qLAFTjfju/dvJxGVk6M8DDJ+ik4ZotMuSwK1r56f3O59Uk50PFPVn
         R0DaSsNzfIUyeO9IWOXdsNRiOpScHj5lcBRivA9lt7wATE958fMmZQ8bNr/E3zw9Lp+a
         lRCGiGC2Qe4t821qu5XEVbdXbkQ+sQS32lFBOC3K6B9MwNUMYCIjE+kQk5GoDFnQ/755
         JQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64kvwBG1/A4ZIpIpQ81Lq/ynCrPXhKaGjAzI5WzwgPE=;
        b=giBaa39YIOHq/Q3fe+p0GEhsL3W28JxN2E67aJWbZjY01kHYLqnyueV6GIeTREDcb6
         TDXnWvDz0//fMeACuUP4ydhGsdx4KN+cZkdN2Cn10T3d069eK9B1ejbOyym+lDlySXNU
         yiZiP4XToaWAFC/xVdGHPPhZqaMMTSt2JWhmaAXOTx99SDLEmf+ZbZoHkQwMJxpXntOB
         YFdgL9OrLsy2C1N1z8If/ury6Sf4cg7FrDPCgEEcipYICr2q/NbeGqmneDGJ2Wx+e3AU
         p7fQnwq450fcprf8qN89+U/MrM4FGOvvPEIMOger6ORMfdLrcT2yEfATbV3E53lFwk/o
         Ol+Q==
X-Gm-Message-State: AOAM532zXmTYWF0jiRyU80ShEw+yX7f1JDWBjCFeS3FOzky4a4J3jnm7
        c9fIie63qCSeaFeyyLUbGdhPog==
X-Google-Smtp-Source: ABdhPJzIGyb5J01y0YxEKH5gekjElLjvEzQP6NEzA1GtaboJVo5CQutHS2WF+ceWndsriO45lbSBPQ==
X-Received: by 2002:adf:e3c1:: with SMTP id k1mr3797110wrm.33.1590240446683;
        Sat, 23 May 2020 06:27:26 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id g69sm8098703wmg.15.2020.05.23.06.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 06:27:26 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 5/5] net: ethernet: mtk_star_emac: use devm_register_netdev()
Date:   Sat, 23 May 2020 15:27:11 +0200
Message-Id: <20200523132711.30617-6-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200523132711.30617-1-brgl@bgdev.pl>
References: <20200523132711.30617-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Use the new devres variant of register_netdev() in the mtk-star-emac
driver and shrink the code by a couple lines.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 789c77af501f..b74349cede28 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1519,13 +1519,6 @@ static void mtk_star_mdiobus_unregister(void *data)
 	mdiobus_unregister(priv->mii);
 }
 
-static void mtk_star_unregister_netdev(void *data)
-{
-	struct net_device *ndev = data;
-
-	unregister_netdev(ndev);
-}
-
 static int mtk_star_probe(struct platform_device *pdev)
 {
 	struct device_node *of_node;
@@ -1641,15 +1634,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 
 	netif_napi_add(ndev, &priv->napi, mtk_star_poll, MTK_STAR_NAPI_WEIGHT);
 
-	ret = register_netdev(ndev);
-	if (ret)
-		return ret;
-
-	ret = devm_add_action_or_reset(dev, mtk_star_unregister_netdev, ndev);
-	if (ret)
-		return ret;
-
-	return 0;
+	return devm_register_netdev(dev, ndev);
 }
 
 static const struct of_device_id mtk_star_of_match[] = {
-- 
2.25.0

