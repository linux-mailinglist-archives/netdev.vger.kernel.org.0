Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC9841C616
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344367AbhI2Nwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344274AbhI2Nwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 09:52:42 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6664FC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 06:50:59 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id y186so2844857pgd.0
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 06:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zSV4Z8mFbXMexrERVcO1h1NELPo9dMflMbt5n8Sf4Hk=;
        b=GezhHAWl6KBwmxXp8d37b+xMBu7zNaV/TIIRGw+bwSGRrZ0yFEW1EBxzxMW3nyG1/7
         be5ISkux+HWW7aE1US/KtGHFa04Tj7C50QiZfVphVkGIf2ZChrMonXAj5ZQCRFowl16m
         QG+y/Xdr61Zh47YsZHBqrPA+Y6iRkUam69Lkvkc0upjdrqyT6P7ku/i1fW4PSN74GtG1
         wBrqLB/AYv5Vr05uI9J4UlxhHsnjV8321q8/ycCyPiKJ0hHXF29EjQs5+IVUAgPkySrQ
         m7lO77C0f2MCEacicjcv0AoXqx/EsxR81S3U4xI2CtpaAt2kV38V6M5GcAaSSTGz4fcE
         3Eiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zSV4Z8mFbXMexrERVcO1h1NELPo9dMflMbt5n8Sf4Hk=;
        b=ALeGIjmOBHev+SOiyEI0oID2r1jeo8veGKUKXGdQUwrY72hDBYTxTx0a41u4unBLof
         ObImmLbeomj4np9biqeoraho+I/gNyJrbhllWZCArUMgXRltp9h8LXp24ZpEjGxWy7fu
         E4c17h8pC5QeYGzWpweyG65/3NuSRq2lX/7G12zp9IkgNGKnOBsHDk6HaVKFLShcCDAF
         0GWDWwxSeYH+g1zrU8bkKw2gDyObPNL8odxkPGzm/2B8Xq3q8VwelzEBOSMMDTybYRt7
         6cwwqEnOyPqBJCcUzNYhtFFSGSvebhM7pt6jB714rd8VchuxIsOOTn+n//mpSUyJUuHt
         qOUQ==
X-Gm-Message-State: AOAM532qiSmxh6RA6ISZuj/2tTA03vzRYfKrJ0ZTxqTchSF14l9HwN0N
        YZarncd4SrruG94Az3WAHAVhRs4HNCuPZA==
X-Google-Smtp-Source: ABdhPJwTtBcWbQKX/t61k/60uGU8jY/HnsHddE0T7ZQtDMgWl9mXtD2SzfRTWAYlTkhii00IZzvPKw==
X-Received: by 2002:a63:2d02:: with SMTP id t2mr83323pgt.1.1632923458516;
        Wed, 29 Sep 2021 06:50:58 -0700 (PDT)
Received: from localhost (122x211x248x161.ap122.ftth.ucom.ne.jp. [122.211.248.161])
        by smtp.gmail.com with ESMTPSA id f205sm2786218pfa.92.2021.09.29.06.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 06:50:57 -0700 (PDT)
From:   Punit Agrawal <punitagrawal@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        kuba@kernel.org, Punit Agrawal <punitagrawal@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Michael Riesch <michael.riesch@wolfvision.net>
Subject: [PATCH] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices
Date:   Wed, 29 Sep 2021 22:50:49 +0900
Message-Id: <20210929135049.3426058-1-punitagrawal@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
while getting rid of a runtime PM warning ended up breaking ethernet
on rk3399 based devices. By dropping an extra reference to the device,
the commit ends up enabling suspend / resume of the ethernet device -
which appears to be broken.

While the issue with runtime pm is being investigated, partially
revert commit 2d26f6e39afb to restore the network on rk3399.

Fixes: 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
Suggested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Punit Agrawal <punitagrawal@gmail.com>
Cc: Michael Riesch <michael.riesch@wolfvision.net>
---
Hi,

There's been a few reports of broken ethernet on rk3399 based
boards. The issue got introduced due to a late commit in the 5.14
cycle.

It would be great if this commit can be taken as a fix for the next rc
as well as applied to the 5.14 stable releases.

Thanks,
Punit

 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index ed817011a94a..6924a6aacbd5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/pm_runtime.h>
 
 #include "stmmac_platform.h"
 
@@ -1528,6 +1529,8 @@ static int rk_gmac_powerup(struct rk_priv_data *bsp_priv)
 		return ret;
 	}
 
+	pm_runtime_get_sync(dev);
+
 	if (bsp_priv->integrated_phy)
 		rk_gmac_integrated_phy_powerup(bsp_priv);
 
@@ -1539,6 +1542,8 @@ static void rk_gmac_powerdown(struct rk_priv_data *gmac)
 	if (gmac->integrated_phy)
 		rk_gmac_integrated_phy_powerdown(gmac);
 
+	pm_runtime_put_sync(&gmac->pdev->dev);
+
 	phy_power_on(gmac, false);
 	gmac_clk_enable(gmac, false);
 }
-- 
2.32.0

