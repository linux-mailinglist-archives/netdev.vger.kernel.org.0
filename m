Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850CD4D4111
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 07:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiCJGVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 01:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235429AbiCJGVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 01:21:44 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C04D12B754;
        Wed,  9 Mar 2022 22:20:43 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id v13so3179703qkv.3;
        Wed, 09 Mar 2022 22:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P9mdgV1XcI8IYrQOmfFrftDWPLsJMx8c+0mnYSxEQCM=;
        b=XXiqYFo82xt3V6MW1qsaBB6Oip1Rco2s9XFxnj7SyhZ0ERyLa17rMIdWOuffYM5nLE
         u/EFK89BlbyVPBC6QUQdp1D82F96LgWbCuw+t/7iUtJhgAdtB6q0vP78WEPYPERm3/M4
         3jn0dFN8GaqFsUPcYBb7m/eKlxCdtG0kF2/QNAVAOl3CwR7AhFcPEVFGz6V435F670Kx
         pruYGeSL3N7sWCbKPjCJF1VUw5feTZULdckC5Ey4x9lFZokR8I8raEB35HvIb3FSvZRZ
         TiweK6yo/q2wXzGNtZfVa25r77CWqVNKilBYrrdMyeGIsfmI25hmVTKUVt7J6kpzEWz2
         u+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P9mdgV1XcI8IYrQOmfFrftDWPLsJMx8c+0mnYSxEQCM=;
        b=GC6GO2mrNXeTD1cS0typcw2iFQI5RGcA8fgUeulXDJSnHua+OpqauZB5fAjFL/L8bT
         Q+ruvqCxUk3HjaWm2Lycrh+keYyBx/9AHgeAwLdTLpzpB7IgO1uHhi3le3DPHwpMy3Vr
         GaXL70/Vllpyc3tjYl8npJIwW6rIa0vdGFdamMzOjdq1n5hNXhntoQ1QZZM4x0jskQMC
         dmfpxCLqZYM0FBI2cnd9NaKD+zGzz5zGOqLqUV+RoOPxf1CNL7FoS8ixrCnANB7wblsd
         yLIj8hpKJ2yK+sFesTLYRDG976BmL6+NbH/FF1m8Kiswm9z+Zzgcpkqy4xZk8Qm3PYtd
         CoNw==
X-Gm-Message-State: AOAM531zpvF+J9lGjHPiI8Yz2r1EJEB/V2V0bSuZKQ1bk4Kf2R/GI5em
        9Bw6CAUckg6FviiF2ePg0/gFJy8R1hU=
X-Google-Smtp-Source: ABdhPJw3m8kz4Ro/w2SSoJI+eAuokN5vD5axE9OhoEIuf7w47DkNOq0P0kxAx2uX4ou8ke80U7bznQ==
X-Received: by 2002:a05:620a:200f:b0:67b:3fb7:8784 with SMTP id c15-20020a05620a200f00b0067b3fb78784mr2034196qka.336.1646893242661;
        Wed, 09 Mar 2022 22:20:42 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id f34-20020a05622a1a2200b002e1a35ed1desm2149227qtb.94.2022.03.09.22.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 22:20:41 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     sebastian.hesselbarth@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] net: mv643xx_eth: use platform_get_irq() instead of platform_get_resource()
Date:   Thu, 10 Mar 2022 06:20:35 +0000
Message-Id: <20220310062035.2084669-1-chi.minghao@zte.com.cn>
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

From: Minghao Chi <chi.minghao@zte.com.cn>

It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
for requesting IRQ's resources any more, as they can be not ready yet in
case of DT-booting.

platform_get_irq() instead is a recommended way for getting IRQ even if
it was not retrieved earlier.

It also makes code simpler because we're getting "int" value right away
and no conversion from resource to int is required.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
v1->v2:
  - Add a space after "net:".
  - Use WARN_ON instead of BUG_ON
 drivers/net/ethernet/marvell/mv643xx_eth.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index c31cbbae0eca..34fa5ab21d62 100644
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
@@ -3189,9 +3188,10 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	timer_setup(&mp->rx_oom, oom_timer_wrapper, 0);
 
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	BUG_ON(!res);
-	dev->irq = res->start;
+	irq = platform_get_irq(pdev, 0);
+	if (WARN_ON(irq < 0))
+		return irq;
+	dev->irq = irq;
 
 	dev->netdev_ops = &mv643xx_eth_netdev_ops;
 
-- 
2.25.1

