Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED791B0F43
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgDTPGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgDTPGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:06:46 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F47C061A0C;
        Mon, 20 Apr 2020 08:06:46 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id p25so5048046pfn.11;
        Mon, 20 Apr 2020 08:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ebTJK3VIsFc6VNFg3gPxRYeNnxObdYDofUcsgMI3igM=;
        b=K6f02Z7TYGsc3/2J7vMCj5h0qZ8t1zLmDg8M46bUXvub7eC8fyZ1Xo+ftlQLSSQorB
         a1bF5dZu8PX21RP4904YvDlPybcuNPbjms1EEwHzGkSU+hHQWWDJ9u3o6PtNpxzr776F
         Ym7yLtWxGXv07H701hSp5vF6w6Ys/2A3+SjgNQZzXa7UU5mLUG1efqklk8IDeoz/SF2y
         VNleTPLRcAi3RqfZ28ntM+nlcInAVvLs+DFWCiZjHQEhK59S0OM48alXJQcDoEBpeIxf
         Vym0Xn7JijQJniqUaMPhciLI064kLcUgZf3aP2KxYlO8sulyRJIiGIV7iV/vsels6dsg
         9Jog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ebTJK3VIsFc6VNFg3gPxRYeNnxObdYDofUcsgMI3igM=;
        b=NOI7QqOyZzrdGLITqD6GBfKJi95vmY68XW6zQ2UfEJ3K3zQ3ftECkObRbHxCXC9rHR
         jZSJiOnXHTHhhDoCHenVs9KwsIYBMH1rQ0D3FlrMup12FAyXuvFOHdtiCNKVEr7yQ+SA
         lJcVxRfXTAu59XY+FJcokFlW4Ij8W+sJP5CNazm9z+trmLZckNgeotpjbxsrgHG0/sVj
         10FE36/i7DVNxFO8v5z4luBj20j2p70sDdp2dkqvoa+9NTsb0LaA6bHUNnfTXp1ezbrI
         XB14R+ukw2yCanUSRdHsZlZ4GvxUXy8RTVe6XG99F28Mr9XsGHUVgA6gjc2CwAM2I1DI
         Zm0Q==
X-Gm-Message-State: AGi0PuZscHhvO6fN6in+sMwSmY8/UGqqmzPPUr/i71e3wUMlZ0mFhDmF
        ZzXLd1XIv05T/V8/aMTpyfQ=
X-Google-Smtp-Source: APiQypLYT+kzB5ZNagQxYzYx7UKNIkqCzey0XV2xcIagr6BlIGA76rjh7t3gPX6nS44gOHK/KmNIGg==
X-Received: by 2002:a62:6443:: with SMTP id y64mr16817917pfb.13.1587395206380;
        Mon, 20 Apr 2020 08:06:46 -0700 (PDT)
Received: from localhost (89.208.244.140.16clouds.com. [89.208.244.140])
        by smtp.gmail.com with ESMTPSA id b29sm1327297pfp.68.2020.04.20.08.06.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Apr 2020 08:06:45 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     davem@davemloft.net, ynezz@true.cz, swboyd@chromium.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH net-next v1] net: broadcom: convert to devm_platform_ioremap_resource_byname()
Date:   Mon, 20 Apr 2020 23:06:41 +0800
Message-Id: <20200420150641.2528-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the function devm_platform_ioremap_resource_byname() to simplify
source code which calls the functions platform_get_resource_byname()
and devm_ioremap_resource(). Remove also a few error messages which
became unnecessary with this software refactoring.

Suggested-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 .../net/ethernet/broadcom/bgmac-platform.c    | 33 +++++++------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index c46c1b1416f7..a5d1a6cb9ce3 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -172,7 +172,6 @@ static int bgmac_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct bgmac *bgmac;
-	struct resource *regs;
 	const u8 *mac_addr;
 
 	bgmac = bgmac_alloc(&pdev->dev);
@@ -202,31 +201,21 @@ static int bgmac_probe(struct platform_device *pdev)
 	if (bgmac->irq < 0)
 		return bgmac->irq;
 
-	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "amac_base");
-	if (!regs) {
-		dev_err(&pdev->dev, "Unable to obtain base resource\n");
-		return -EINVAL;
-	}
-
-	bgmac->plat.base = devm_ioremap_resource(&pdev->dev, regs);
+	bgmac->plat.base =
+		devm_platform_ioremap_resource_byname(pdev, "amac_base");
 	if (IS_ERR(bgmac->plat.base))
 		return PTR_ERR(bgmac->plat.base);
 
-	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "idm_base");
-	if (regs) {
-		bgmac->plat.idm_base = devm_ioremap_resource(&pdev->dev, regs);
-		if (IS_ERR(bgmac->plat.idm_base))
-			return PTR_ERR(bgmac->plat.idm_base);
-		bgmac->feature_flags &= ~BGMAC_FEAT_IDM_MASK;
-	}
+	bgmac->plat.idm_base =
+		devm_platform_ioremap_resource_byname(pdev, "idm_base");
+	if (IS_ERR(bgmac->plat.idm_base))
+		return PTR_ERR(bgmac->plat.idm_base);
+	bgmac->feature_flags &= ~BGMAC_FEAT_IDM_MASK;
 
-	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nicpm_base");
-	if (regs) {
-		bgmac->plat.nicpm_base = devm_ioremap_resource(&pdev->dev,
-							       regs);
-		if (IS_ERR(bgmac->plat.nicpm_base))
-			return PTR_ERR(bgmac->plat.nicpm_base);
-	}
+	bgmac->plat.nicpm_base =
+		devm_platform_ioremap_resource_byname(pdev, "nicpm_base");
+	if (IS_ERR(bgmac->plat.nicpm_base))
+		return PTR_ERR(bgmac->plat.nicpm_base);
 
 	bgmac->read = platform_bgmac_read;
 	bgmac->write = platform_bgmac_write;
-- 
2.25.0

