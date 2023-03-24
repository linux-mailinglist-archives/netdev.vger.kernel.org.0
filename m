Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E56C83C5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjCXRwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbjCXRwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:10 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD0F1B2C0;
        Fri, 24 Mar 2023 10:51:46 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id x8so2092440qvr.9;
        Fri, 24 Mar 2023 10:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wXQEQPWX7BChXSTzE5sZfWk0yY1AAKansMO3jYxACZw=;
        b=ivgR1jloxGZQfdlLuHFKvGk+JsXdNnK60atDZbah23gzHJlVSXexwTvl+E33i8DQbN
         /loLp3HMihM6p/826e8MWB+3f0sdDTBpx+S5Rbw5H6+2sDeCOigvosPx9GhlqKfXTzW/
         /gyzTt61u+18M8kGBhf/2f3VCVNSd8shtgOiitW5vFPFOE33u9OFRhroMeYxC9Pj73wR
         J0F9fWiNw/+IpCkfzauBb2sn9PtcFtSpG7j3RqmIlJSagi3LAJrRDmOECWZmGDpPQABA
         tq8tgLYcA0Mdorm93Bg6mY8i6ekGG7lBK0EeLdlPFBxbvsotbLGlB4Xbj6XYtiqdiWgq
         7qQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wXQEQPWX7BChXSTzE5sZfWk0yY1AAKansMO3jYxACZw=;
        b=frjaP+GM1of4gxNxSWs0/ziYlpmMthbGcRTszF8D9orf3+kmZjhu5khI3a2IuPkce8
         824L84pqrawcR2U8tSRHtXoieFru9vOzZSlYi4MojXERLINHNY60Zjff6oeKwWvVAAfm
         IYgpLpNSzHi9iJsl9WJLvX/ZJ+Ggh8Uqn+ccVRTHcAge5MuC8fq/g52ifpsj/FiN8Bvd
         vd77NqI+0FjkXkzLfUTp0uS+O+Em+62JyxNVU2XMLbzO4WUxCXJj7oKR4Ob1eOuiLnHd
         BJKkn7my8eh3E9gJW8dwi4z89vlXkGUcG7ppobbpgHyiDu+r5dV8CUgVuIZCXRrQh8k/
         ONpQ==
X-Gm-Message-State: AAQBX9cW1xmD9idsRVL+46o1Eti36EaHZPSWCn+Ce6gNnL2DDCwzZgcS
        PNsa6ytvAXc8TcbWL1QaO/E=
X-Google-Smtp-Source: AKy350bT8j3Rm6Ve5ExWcGHNVuE/Cig+X5dvbER31s93FGk3hN2AYqOnFFp9AtqXqRdj/QRm/2r/tQ==
X-Received: by 2002:a05:6214:48c:b0:56f:8ef:693 with SMTP id pt12-20020a056214048c00b0056f08ef0693mr6155609qvb.0.1679680304961;
        Fri, 24 Mar 2023 10:51:44 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id i13-20020a056214030d00b005dd8b9345ccsm835936qvu.100.2023.03.24.10.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:44 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v4 06/10] net: sunhme: Switch SBUS to devres
Date:   Fri, 24 Mar 2023 13:51:32 -0400
Message-Id: <20230324175136.321588-7-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230324175136.321588-1-seanga2@gmail.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PCI half of this driver was converted in commit 914d9b2711dd ("sunhme:
switch to devres"). Do the same for the SBUS half.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 118 +++++++++---------------------
 1 file changed, 35 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index e9613db3bdee..9cd3448aca3e 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2313,29 +2313,28 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	struct net_device *dev;
 	int i, qfe_slot = -1;
 	u8 addr[ETH_ALEN];
-	int err = -ENODEV;
+	int err;
 
 	sbus_dp = op->dev.parent->of_node;
 
 	/* We can match PCI devices too, do not accept those here. */
 	if (!of_node_name_eq(sbus_dp, "sbus") && !of_node_name_eq(sbus_dp, "sbi"))
-		return err;
+		return -ENODEV;
 
 	if (is_qfe) {
 		qp = quattro_sbus_find(op);
 		if (qp == NULL)
-			goto err_out;
+			return -ENODEV;
 		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++)
 			if (qp->happy_meals[qfe_slot] == NULL)
 				break;
 		if (qfe_slot == 4)
-			goto err_out;
+			return -ENODEV;
 	}
 
-	err = -ENOMEM;
-	dev = alloc_etherdev(sizeof(struct happy_meal));
+	dev = devm_alloc_etherdev(&op->dev, sizeof(struct happy_meal));
 	if (!dev)
-		goto err_out;
+		return -ENOMEM;
 	SET_NETDEV_DEV(dev, &op->dev);
 
 	/* If user did not specify a MAC address specifically, use
@@ -2369,46 +2368,45 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 
 	spin_lock_init(&hp->happy_lock);
 
-	err = -ENODEV;
 	if (qp != NULL) {
 		hp->qfe_parent = qp;
 		hp->qfe_ent = qfe_slot;
 		qp->happy_meals[qfe_slot] = dev;
 	}
 
-	hp->gregs = of_ioremap(&op->resource[0], 0,
-			       GREG_REG_SIZE, "HME Global Regs");
-	if (!hp->gregs) {
+	hp->gregs = devm_platform_ioremap_resource(op, 0);
+	if (IS_ERR(hp->gregs)) {
 		dev_err(&op->dev, "Cannot map global registers.\n");
-		goto err_out_free_netdev;
+		err = PTR_ERR(hp->gregs);
+		goto err_out_clear_quattro;
 	}
 
-	hp->etxregs = of_ioremap(&op->resource[1], 0,
-				 ETX_REG_SIZE, "HME TX Regs");
-	if (!hp->etxregs) {
+	hp->etxregs = devm_platform_ioremap_resource(op, 1);
+	if (IS_ERR(hp->etxregs)) {
 		dev_err(&op->dev, "Cannot map MAC TX registers.\n");
-		goto err_out_iounmap;
+		err = PTR_ERR(hp->etxregs);
+		goto err_out_clear_quattro;
 	}
 
-	hp->erxregs = of_ioremap(&op->resource[2], 0,
-				 ERX_REG_SIZE, "HME RX Regs");
-	if (!hp->erxregs) {
+	hp->erxregs = devm_platform_ioremap_resource(op, 2);
+	if (IS_ERR(hp->erxregs)) {
 		dev_err(&op->dev, "Cannot map MAC RX registers.\n");
-		goto err_out_iounmap;
+		err = PTR_ERR(hp->erxregs);
+		goto err_out_clear_quattro;
 	}
 
-	hp->bigmacregs = of_ioremap(&op->resource[3], 0,
-				    BMAC_REG_SIZE, "HME BIGMAC Regs");
-	if (!hp->bigmacregs) {
+	hp->bigmacregs = devm_platform_ioremap_resource(op, 3);
+	if (IS_ERR(hp->bigmacregs)) {
 		dev_err(&op->dev, "Cannot map BIGMAC registers.\n");
-		goto err_out_iounmap;
+		err = PTR_ERR(hp->bigmacregs);
+		goto err_out_clear_quattro;
 	}
 
-	hp->tcvregs = of_ioremap(&op->resource[4], 0,
-				 TCVR_REG_SIZE, "HME Tranceiver Regs");
-	if (!hp->tcvregs) {
+	hp->tcvregs = devm_platform_ioremap_resource(op, 4);
+	if (IS_ERR(hp->tcvregs)) {
 		dev_err(&op->dev, "Cannot map TCVR registers.\n");
-		goto err_out_iounmap;
+		err = PTR_ERR(hp->tcvregs);
+		goto err_out_clear_quattro;
 	}
 
 	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
@@ -2428,13 +2426,12 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	hp->happy_bursts = of_getintprop_default(sbus_dp,
 						 "burst-sizes", 0x00);
 
-	hp->happy_block = dma_alloc_coherent(hp->dma_dev,
-					     PAGE_SIZE,
-					     &hp->hblock_dvma,
-					     GFP_ATOMIC);
-	err = -ENOMEM;
-	if (!hp->happy_block)
-		goto err_out_iounmap;
+	hp->happy_block = dmam_alloc_coherent(&op->dev, PAGE_SIZE,
+					      &hp->hblock_dvma, GFP_KERNEL);
+	if (!hp->happy_block) {
+		err = -ENOMEM;
+		goto err_out_clear_quattro;
+	}
 
 	/* Force check of the link first time we are brought up. */
 	hp->linkcheck = 0;
@@ -2472,10 +2469,10 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	happy_meal_set_initial_advertisement(hp);
 	spin_unlock_irq(&hp->happy_lock);
 
-	err = register_netdev(hp->dev);
+	err = devm_register_netdev(&op->dev, dev);
 	if (err) {
 		dev_err(&op->dev, "Cannot register net device, aborting.\n");
-		goto err_out_free_coherent;
+		goto err_out_clear_quattro;
 	}
 
 	platform_set_drvdata(op, hp);
@@ -2490,31 +2487,9 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 
 	return 0;
 
-err_out_free_coherent:
-	dma_free_coherent(hp->dma_dev,
-			  PAGE_SIZE,
-			  hp->happy_block,
-			  hp->hblock_dvma);
-
-err_out_iounmap:
-	if (hp->gregs)
-		of_iounmap(&op->resource[0], hp->gregs, GREG_REG_SIZE);
-	if (hp->etxregs)
-		of_iounmap(&op->resource[1], hp->etxregs, ETX_REG_SIZE);
-	if (hp->erxregs)
-		of_iounmap(&op->resource[2], hp->erxregs, ERX_REG_SIZE);
-	if (hp->bigmacregs)
-		of_iounmap(&op->resource[3], hp->bigmacregs, BMAC_REG_SIZE);
-	if (hp->tcvregs)
-		of_iounmap(&op->resource[4], hp->tcvregs, TCVR_REG_SIZE);
-
+err_out_clear_quattro:
 	if (qp)
 		qp->happy_meals[qfe_slot] = NULL;
-
-err_out_free_netdev:
-	free_netdev(dev);
-
-err_out:
 	return err;
 }
 #endif
@@ -2891,28 +2866,6 @@ static int hme_sbus_probe(struct platform_device *op)
 	return happy_meal_sbus_probe_one(op, is_qfe);
 }
 
-static int hme_sbus_remove(struct platform_device *op)
-{
-	struct happy_meal *hp = platform_get_drvdata(op);
-	struct net_device *net_dev = hp->dev;
-
-	unregister_netdev(net_dev);
-
-	of_iounmap(&op->resource[0], hp->gregs, GREG_REG_SIZE);
-	of_iounmap(&op->resource[1], hp->etxregs, ETX_REG_SIZE);
-	of_iounmap(&op->resource[2], hp->erxregs, ERX_REG_SIZE);
-	of_iounmap(&op->resource[3], hp->bigmacregs, BMAC_REG_SIZE);
-	of_iounmap(&op->resource[4], hp->tcvregs, TCVR_REG_SIZE);
-	dma_free_coherent(hp->dma_dev,
-			  PAGE_SIZE,
-			  hp->happy_block,
-			  hp->hblock_dvma);
-
-	free_netdev(net_dev);
-
-	return 0;
-}
-
 static const struct of_device_id hme_sbus_match[] = {
 	{
 		.name = "SUNW,hme",
@@ -2936,7 +2889,6 @@ static struct platform_driver hme_sbus_driver = {
 		.of_match_table = hme_sbus_match,
 	},
 	.probe		= hme_sbus_probe,
-	.remove		= hme_sbus_remove,
 };
 
 static int __init happy_meal_sbus_init(void)
-- 
2.37.1

