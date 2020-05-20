Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D9D1DB212
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgETLoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgETLob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:44:31 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F03C061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:44:30 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s8so2785954wrt.9
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YDvXJX4yV3p/HLngOBi/jKhO6RPUbYJQuBEN6OKUGtQ=;
        b=R7zN8JmITYNRLCw9ivuWeVAv4mugM84KU9YtOgLMG84n9N+ErPDlDOUXwmnnn6qAK0
         viPGPNbxdWUJXG4FO2NefKDnqLl+ENkQThQY7F7pVJLW7vTVZ1SfT47impUX3qDOd2VQ
         uEkDA/gG3TYp0MSKvb6EO3pf49EGvtOXQXJigVQlnn4NsSR4ny5rZcBkqy8g6uUU53O5
         M1yNyMEx4zclKGqRO8yeeGHcEX3Vt5PjHhwmyW0CwImOXcw/fAUlzgLkGY4MThV+pK2K
         h27XQSVc0pcPLN7VXSi/HBl9isXiwjvQ9x9/UtiIEgN+mxIitT8el5sMSp02Se1SEvP+
         QHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YDvXJX4yV3p/HLngOBi/jKhO6RPUbYJQuBEN6OKUGtQ=;
        b=Hni9wBLl4xgjvKW6MSsPQLy/KegaVattL4NRmDfCh4qR8krcHV/oJQlinMoUgL9kgq
         T2eCsYInxjgnV6MqRnRNEYP8FROuvx7u+mjTBBNo7t3P5iRQwa/KM8DoL43FMhWJUjYi
         sga0AiSgqg9uTXJxFdgFE4f+FlWpYxd8SHbieLb4O4Tu0/XL4kb+p5ecEcaOb4FDKF71
         MKgAWtX70ao4+mPTP35OCGsV9x52d6aF2VOAWH64qvXmx186IyQ7YoHUJfRxpP//SWwO
         0cex504aBjg269qlI2CcK9eazXKI9OwFiq/lw/kOo1WWV74SJjaLu60kA/qSt9KOtSVi
         frmQ==
X-Gm-Message-State: AOAM531+0wqdIKJajmUCadFMrv3Pd74z7TeTOyqnOSC2chZe5YuiDWVA
        SxMs14nEHD5dtSLr9WeHXOLwYw==
X-Google-Smtp-Source: ABdhPJxix/P9D3Mn5oh6fiWDRRTUhSOcXRz8XE3qxCx4RCTw666U9OaDVlR73p1lgKqZTh/IlvPteQ==
X-Received: by 2002:a5d:60c3:: with SMTP id x3mr3697173wrt.48.1589975069582;
        Wed, 20 May 2020 04:44:29 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id q2sm2530782wrx.60.2020.05.20.04.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:44:29 -0700 (PDT)
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
Subject: [PATCH 5/5] net: ethernet: mtk_eth_mac: use devm_register_netdev()
Date:   Wed, 20 May 2020 13:44:15 +0200
Message-Id: <20200520114415.13041-6-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200520114415.13041-1-brgl@bgdev.pl>
References: <20200520114415.13041-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Use the new devres variant of register_netdev() in the mtk-eth-mac
driver and shrink the code by a couple lines.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_mac.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_mac.c b/drivers/net/ethernet/mediatek/mtk_eth_mac.c
index 4dfe7c2c4e3d..2919ce27efeb 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_mac.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_mac.c
@@ -1513,13 +1513,6 @@ static void mtk_mac_clk_disable_unprepare(void *data)
 	clk_bulk_disable_unprepare(MTK_MAC_NCLKS, priv->clks);
 }
 
-static void mtk_mac_unregister_netdev(void *data)
-{
-	struct net_device *ndev = data;
-
-	unregister_netdev(ndev);
-}
-
 static int mtk_mac_probe(struct platform_device *pdev)
 {
 	struct device_node *of_node;
@@ -1631,15 +1624,7 @@ static int mtk_mac_probe(struct platform_device *pdev)
 
 	netif_napi_add(ndev, &priv->napi, mtk_mac_poll, MTK_MAC_NAPI_WEIGHT);
 
-	ret = register_netdev(ndev);
-	if (ret)
-		return ret;
-
-	ret = devm_add_action_or_reset(dev, mtk_mac_unregister_netdev, ndev);
-	if (ret)
-		return ret;
-
-	return 0;
+	return devm_register_netdev(dev, ndev);
 }
 
 static const struct of_device_id mtk_mac_of_match[] = {
-- 
2.25.0

