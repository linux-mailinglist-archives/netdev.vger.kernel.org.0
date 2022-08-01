Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8AA5862A4
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 04:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239043AbiHACdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 22:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbiHACc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 22:32:58 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1459B13CC5;
        Sun, 31 Jul 2022 19:32:58 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s206so8533045pgs.3;
        Sun, 31 Jul 2022 19:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=JlhlolBNeXxkDjV//2ef/jXtAKI/H1zfuYrT43FexCc=;
        b=oJt1bVNqQEFIfZQAQxWeGYb4Jb6DQ47rwBYVBOjX6AABvHZbQBP77ZDjADBJEtWowA
         wo+CV4xFXZkrYNrxrTtnho/DgaNvR9RsHkd5Ta3tOHvM4AzfklTAD12fFxuA36L3l88U
         bx/hyJKTDbyEGKXB7ruFkwLZZ3A0MJGZGY+dzq3mleTCqJKdpy66Wim8NPsBoL0Hn8qF
         9Hs9BiLeyZVf8PvfynobbVK3l5Hd4bWyBswRLH+py6tDdVNFHhAxtzMZMJGePKXlKhnu
         pXq2s5H0cwv0RC7Xy2ALSdwm2/wiD+xxT2reSZWiUyimrWgUcv/Bg0Tv9DOrVtAbzKyg
         J02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=JlhlolBNeXxkDjV//2ef/jXtAKI/H1zfuYrT43FexCc=;
        b=X+tRtLhF2ht2fmF3+qsQrp4tAzpEvqQo3GiR5scQEU57qfsOSB8J7TKoBO72Ct/V7f
         idtKh7pYxsQKdxdr72FjLXLGS3Rze8RNfpb7gVHcUSTKv88Uucn83KrqV8Y6AQKgIcAO
         pvgIDBFho3uUXYsDACEQJZnmdaymc59wwlwSXi5uK8UKS1a8r40SQRvWdRa8MX/B+T5o
         O9Wke+vnzCLqC/E/d7SrsA8rkmLfG8FBaBIUOKOWoY+4H11hZiIZfu3RuIuHb0BB/fo+
         OEML449APQxt96286SW5LgDNpWIgZwZNxrABCriRL27ULmUF9a+yrJEYH/s7CvK4SJ8t
         U0pQ==
X-Gm-Message-State: ACgBeo1tnMbvs7EcZ/KArYb6BRAuu25x2rnmkF5wrQGg0omVsnYd9kvd
        6Qi2jIrhZrTDJoGD0QtV49ACUtfO70s=
X-Google-Smtp-Source: AA6agR5tMVXiBYKF3nI/RS/QQ00QvV+tAPQDpE0yDtZBdWFBtPB+rzkcZ5ivAsWawv+skl1UPESH9w==
X-Received: by 2002:a63:27c3:0:b0:41b:cd2c:af9f with SMTP id n186-20020a6327c3000000b0041bcd2caf9fmr6306784pgn.609.1659321177496;
        Sun, 31 Jul 2022 19:32:57 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 13-20020a62140d000000b0052ce4074fddsm4897703pfu.145.2022.07.31.19.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 19:32:57 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] can: ctucanfd:using the pm_runtime_resume_and_get to  simplify the code
Date:   Mon,  1 Aug 2022 02:32:53 +0000
Message-Id: <20220801023253.1594906-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Using pm_runtime_resume_and_get() to instade of  pm_runtime_get_sync
and pm_runtime_put_noidle.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index 6b281f6eb9b4..36c3381d0927 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -1199,11 +1199,10 @@ static int ctucan_open(struct net_device *ndev)
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	ret = pm_runtime_get_sync(priv->dev);
+	ret = pm_runtime_resume_and_get(priv->dev);
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
 			   __func__, ret);
-		pm_runtime_put_noidle(priv->dev);
 		return ret;
 	}
 
@@ -1281,10 +1280,9 @@ static int ctucan_get_berr_counter(const struct net_device *ndev, struct can_ber
 	struct ctucan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	ret = pm_runtime_get_sync(priv->dev);
+	ret = pm_runtime_resume_and_get(priv->dev);
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n", __func__, ret);
-		pm_runtime_put_noidle(priv->dev);
 		return ret;
 	}
 
@@ -1394,11 +1392,10 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 
 	if (pm_enable_call)
 		pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
 			   __func__, ret);
-		pm_runtime_put_noidle(priv->dev);
 		goto err_pmdisable;
 	}
 
-- 
2.25.1
