Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFDE454A88
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237626AbhKQQKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbhKQQKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 11:10:25 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847C3C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 08:07:26 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a9so5671253wrr.8
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 08:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XXUl1J4Yjw0CBovSGazX2BrNb57TY0RNQOkDUEKFWVo=;
        b=W7UVNH6jRnL00Cg7pSSQfVHpTpkbkHBDx5fpuegLXu2XC+oiZutzhlGaZv/WA8BuUs
         h8bH6FW/W0wESZPffwJTOeiY2m75LdFfShfmn7XMOxQTTrcDii/DAJ4EKe1g+ZpKwGup
         tytqTqsYGQN9wHWiOLi4RImwScbgtyDcxGGyipHUcKWQQ09uft47n1AntIWXhdT8DmTW
         QymUrc2vDbzsClep0VQP1qwV1JaO3zC0elqzzsrflt3pi8Kt3m4epu8Iriu4B+dcduv+
         HUjMQP9J+mRr3rCwT/7F4dZLtMDEPvgY+jt+UYteco9YURNtvMWIbXmGk3ONCx7dm2el
         ZJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XXUl1J4Yjw0CBovSGazX2BrNb57TY0RNQOkDUEKFWVo=;
        b=7Gf7DREcg19/ej76djsRWSFi9+9kYCMT2+m9Vi59ggiGhZKrQxGg5gcN2sEPpzbr1k
         evD1IGacl7OqUd8ckUYoRuG7W+RtY5VNQln7j2mOdOW6B0jZLaNj1WVgFt7YMUVBzLcQ
         iLterriy/gOPY0z21ubxK2GtTrcIwmVhKiexN3u8B9eb25MnBd7ajW16C2Rb5bvcrI2T
         j280vCJkT8IhoF37TUgynshCF3N44MPNKTcxKTBJXaP7MWP5ct27O+53KXCWsqqgXmLR
         ziOyM6kmfrBkM3ULyu3SRJ9To3t5u3JUc6NFAlRh7lSD15Sv75ovMnIyIlEZe5B1F97+
         yJ7g==
X-Gm-Message-State: AOAM533hdPUOtn+h3bH0L7juNqO6HcBza0z4l7eedMkSfJWBEdaD0HB6
        nxvUrb/Py+lhLEt8umKOFA0=
X-Google-Smtp-Source: ABdhPJxDoLLMa2vAPOsjko9uRYtQq0B4WQD7JgYwzFlfP3w4tTTHyDNJmvUd6rXX/bC6tnfBNY7geA==
X-Received: by 2002:a5d:6a4d:: with SMTP id t13mr21589412wrw.104.1637165245183;
        Wed, 17 Nov 2021 08:07:25 -0800 (PST)
Received: from jonas-desktop.lan (dslb-088-076-253-246.088.076.pools.vodafone-ip.de. [88.76.253.246])
        by smtp.gmail.com with ESMTPSA id p19sm174493wmq.4.2021.11.17.08.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 08:07:24 -0800 (PST)
From:   Jonas Gorski <jonas.gorski@gmail.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dejin Zheng <zhengdejin5@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH] Revert "net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname"
Date:   Wed, 17 Nov 2021 17:07:18 +0100
Message-Id: <20211117160718.122929-1-jonas.gorski@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.

Since idm_base and nicpm_base are still optional resources not present
on all platforms, this breaks the driver for everything except Northstar
2 (which has both).

The same change was already reverted once with 755f5738ff98 ("net:
broadcom: fix a mistake about ioremap resource").

So let's do it again.

Fixes: 3710e80952cf ("net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 .../net/ethernet/broadcom/bgmac-platform.c    | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index c6412c523637..d8b5e8dca7d0 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -172,6 +172,7 @@ static int bgmac_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct bgmac *bgmac;
+	struct resource *regs;
 	int ret;
 
 	bgmac = bgmac_alloc(&pdev->dev);
@@ -208,15 +209,21 @@ static int bgmac_probe(struct platform_device *pdev)
 	if (IS_ERR(bgmac->plat.base))
 		return PTR_ERR(bgmac->plat.base);
 
-	bgmac->plat.idm_base = devm_platform_ioremap_resource_byname(pdev, "idm_base");
-	if (IS_ERR(bgmac->plat.idm_base))
-		return PTR_ERR(bgmac->plat.idm_base);
-	else
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

