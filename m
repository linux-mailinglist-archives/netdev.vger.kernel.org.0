Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C0C4D2681
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiCIDzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 22:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiCIDzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 22:55:44 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A116615C655;
        Tue,  8 Mar 2022 19:54:46 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id h5so937869qtb.7;
        Tue, 08 Mar 2022 19:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3AnU9Aw0S8nKPjVhQO3Ey4h6OxbAyzguVs1GxMYrKEo=;
        b=odF4RdsRy6igp0d9euwQqk3rSPZztSUITDfjRv59le4QxaHB0XZaBCjhG66ViG/g2U
         l/LKZFPYdC4xe7nDmpacqpM7D525VnvJYBXQ5PT9MO8UKYpw1HYguupVymWYcDocT2dc
         7OwKvlrvceg1MiD21KwHBQWtoaANL3sRFu3OfWUNs0BUp5eRTHvmf9AyfuwGkMd6mvr8
         yboyXL4jiQkikv7OvS4PLv9AkgYkCmMTBOObp8KhGOnRDLRKj2rhoTLRiHO439/lFP3p
         iqcYR69fvG0QDjZfI1SSs//x7FNqZz4KqojD7KXg3kMKyoVtI+0HYyYf3JbsQNHP+TXv
         K7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3AnU9Aw0S8nKPjVhQO3Ey4h6OxbAyzguVs1GxMYrKEo=;
        b=KoHu7BPq2WwVLNXTzr1Le94A5XtlZcbZ0wMcseh3qruKsnsx8a4+vhTS2rE9bZ2QPy
         mRJJs1tkkNnnCXq6q5VqSb7jEVdkHrWYTPWCUSU7VBxFGHfvOCxTRGlA3Qhzs9fcpotw
         3uA0Jk9DswPFn3zznWSNtEnQBBPPYhD6TAta9W/9NFgtGbQhGV/U9o9xu/khHBjZEpnE
         iCLYKXW2g6jcYWzVeLaC5hSJw1+o6F7jdRrMxBOrHRw5mwTgYcmnDYVRbWoyvd8OAbO1
         iY5QgBZuqlDfdC+K+68RAYFS1vBsmN83i4Qo9LfSrHgFFTea/+yuDzIy+nF3NhSa+fnF
         1Wag==
X-Gm-Message-State: AOAM530jgqXsAWOi3YGYn/ftT00QU3h7MlzCrTWXK/j5nT+ML35O8SI4
        hk0jjMbMiznt8T8z7Z6HkS5dQ3Hr79Y=
X-Google-Smtp-Source: ABdhPJyZbVpcvjzZsCMysqXw+UtrwFpIexJhyM6RUbX4sFZ7XpihRdm+vrTOYgy6nWX6ddF7zWU1Ww==
X-Received: by 2002:ac8:7d8b:0:b0:2de:622:59b2 with SMTP id c11-20020ac87d8b000000b002de062259b2mr16805029qtd.484.1646798085839;
        Tue, 08 Mar 2022 19:54:45 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b202-20020ae9ebd3000000b0067b11d53365sm413052qkg.47.2022.03.08.19.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 19:54:44 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     sebastian.hesselbarth@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net:mv643xx_eth: use platform_get_irq() instead of platform_get_resource()
Date:   Wed,  9 Mar 2022 03:54:38 +0000
Message-Id: <20220309035438.2080808-1-chi.minghao@zte.com.cn>
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

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
for requesting IRQ's resources any more, as they can be not ready yet in
case of DT-booting.

platform_get_irq() instead is a recommended way for getting IRQ even if
it was not retrieved earlier.

It also makes code simpler because we're getting "int" value right away
and no conversion from resource to int is required.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 143ca8be5eb5..125d18430296 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3092,8 +3092,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	struct mv643xx_eth_private *mp;
 	struct net_device *dev;
 	struct phy_device *phydev = NULL;
-	struct resource *res;
-	int err;
+	int err, irq;
 
 	pd = dev_get_platdata(&pdev->dev);
 	if (pd == NULL) {
@@ -3189,9 +3188,9 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	timer_setup(&mp->rx_oom, oom_timer_wrapper, 0);
 
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	BUG_ON(!res);
-	dev->irq = res->start;
+	irq = platform_get_irq(pdev, 0);
+	BUG_ON(irq < 0);
+	dev->irq = irq;
 
 	dev->netdev_ops = &mv643xx_eth_netdev_ops;
 
-- 
2.25.1

