Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEA24D9295
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 03:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344436AbiCOCbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 22:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbiCOCbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 22:31:36 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D52C47069;
        Mon, 14 Mar 2022 19:30:25 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id t5so17271648pfg.4;
        Mon, 14 Mar 2022 19:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k+lctjcega/lm2ZBvU+hlydPBj6Kg73fOYu885xUIbE=;
        b=pC4U+npabExy0OfY3xW0E7JlFzB/g2cZWGdMMfnk0EJSZjsN2LJOAS+TrXMY9LmT6I
         vXxkza6O6Q+rSRElhtdkBdfzufltMIao65ASYhLiEZA1H7g6CYkS0ovZ7dc8l5X01VIM
         LLbkCIwJcgB8/dgSv2lfR8c8EH2z9DqrZ0/xs6oEoqvV8wYVGyx1y79HqhzEMryMXbNv
         aM7PbXOtuhJlfM7c7XSTy5lYR085AVqb1mPKn2HJj7GlTn0Rqpn1T77i0A/Ox07vnHBt
         wTPFaKENpBIZ3Dh/ZcU4ckySd6Pje9mjV/CERRJzsqibKOP1Zygv4uK2PNvzLKRHB/c4
         HU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k+lctjcega/lm2ZBvU+hlydPBj6Kg73fOYu885xUIbE=;
        b=1dknxW+IJoLB1iGq8CQ3vGQ/mR5uXAQ3GkLDXC7PYb/szU9pWvMqH1eqgjVdY9G4EA
         M41MZJM5GOh7hpBzGiDCqz3NmEy8UlOmepr/LOyBvN++e5ez3mY2gXCgFhvbZ8E8rx/H
         0sfER5PUFYh4RbNdaYmQUaLZxIO+a3yzZDNoA7DX4/rLZrghKUG73wkjSivISgpvHuma
         +f7BvSaTTnELIIU8WuysQs83m40gGhkcz6Tm6hxuDIUizbg6Wyk8B9HkfvqPW8OYAckJ
         wOSA+lV7vbiij81S/QsqwIJqiLgsqC3u4bewhb37Q2v1qIlKUyWbL8QYPHGVBzmI2tne
         e+oQ==
X-Gm-Message-State: AOAM5338R9xm4yv3yV8p9mh0xwHQq7xmCGX+3gUdAXVgQaD47aUyX2+u
        c84Vycuyo2oKmfRo37UzVsE=
X-Google-Smtp-Source: ABdhPJwdZeDdQ7fYy48kPOH8Q6YXIxHPx00qmpQ9lcG8ijkcaY84HYa2qFr89qNdn3muORIIfJDNxg==
X-Received: by 2002:a63:8bc8:0:b0:380:b539:bea5 with SMTP id j191-20020a638bc8000000b00380b539bea5mr21719707pge.486.1647311424892;
        Mon, 14 Mar 2022 19:30:24 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id k14-20020a056a00134e00b004f83f05608esm2741807pfu.31.2022.03.14.19.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 19:30:24 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kuba@kernel.org
Cc:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: mv643xx_eth: undo some opreations in mv643xx_eth_probe
Date:   Tue, 15 Mar 2022 02:30:19 +0000
Message-Id: <20220315023019.2118163-1-chi.minghao@zte.com.cn>
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

Cannot directly return platform_get_irq return irq, there
are operations that need to be undone.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index e6cd4e214d79..6cd81737786e 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3189,8 +3189,11 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 
 
 	irq = platform_get_irq(pdev, 0);
-	if (WARN_ON(irq < 0))
+	if (WARN_ON(irq < 0)) {
+		clk_disable_unprepare(mp->clk);
+		free_netdev(dev);
 		return irq;
+	}
 	dev->irq = irq;
 
 	dev->netdev_ops = &mv643xx_eth_netdev_ops;
-- 
2.25.1

