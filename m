Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27ED7500957
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241550AbiDNJK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238109AbiDNJK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:10:28 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6546E540;
        Thu, 14 Apr 2022 02:08:04 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ll10so4534597pjb.5;
        Thu, 14 Apr 2022 02:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYtINvSR5Dih3lqIftjEIHDwvXs93GlfwwGB+RQETjg=;
        b=G06GEOeVuuzjlWUCEo6hbJXjPuVWMHJvuXq9cM78tfK5tfEvemHx0U8OfWz1npch4h
         C+3BDn1yqytd1BrwWAwbciqRL/gs79YcAZ6HLGqwPqp5BAKzKWoQ6ATsh69IJOERDMxf
         M/dxJruoPKM/vxd2jZejIfb3hhrVVOq3y/VaiX0VBIZD9dFdwa1QudQChkYwV4DXHMr2
         QbZ1+XNAQfrurRt5meXb4lL7cYh5pDUdo/6TOAew4qs678sRKKaI8xSB1VfRct/mHN44
         o3cvXe1icyX3v4giaOJwOPbWkdjgxG/8vX2iWxWY/cJgmkdI4dsBM8fEovaj0qx3Wf0e
         uM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYtINvSR5Dih3lqIftjEIHDwvXs93GlfwwGB+RQETjg=;
        b=wd5XairboKg1WtY0lVmKSK3q773m87YWmUjPLs0X/6ytEzKHKaWFDRMJ9nm/OBqiTy
         mwjZ9IVOQfKAIEzSIHX8YEHxLcZmPRGUZcLpq96OYDlAOszSwaoVj8IAr9K8H5Jdgcha
         QXBWtPRryr+pGtFM1ous+j2xJ1q9E2o470urO3esZeDyzBhD6lqx/iajZLz+43yfW2TH
         fPGqwfVo6tVoCMIoSFHAa11uDYKJld2XDQpD/L5TuHMLAU18+DNycxGFHsxfiJK3b0rO
         pd/8Yg3DU7YCf5mbWubq1Cz9YFBd6ENWCSj8m3v3HexUctX3nYAK0qcRDVZ/9XDzea7/
         K14g==
X-Gm-Message-State: AOAM531nsfa7FDGe7s5u0gd+in1kOscyqlLuNiD1kC2URh113b+CVMEt
        zkW6LJqlQIU1ZPB9QgHan+c=
X-Google-Smtp-Source: ABdhPJz+6ah9if//yY1c2sHC40NolRb/XwCaxX0VprNKeLwyb7PtImEh0zH5k1pYYFwgPSqdAGNk9A==
X-Received: by 2002:a17:90b:3b84:b0:1cd:fe1c:151 with SMTP id pc4-20020a17090b3b8400b001cdfe1c0151mr2179837pjb.182.1649927283900;
        Thu, 14 Apr 2022 02:08:03 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090a150800b001cbaf536a3esm5496865pja.18.2022.04.14.02.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 02:08:03 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     grygorii.strashko@ti.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ethernet: ti: davinci_emac: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Thu, 14 Apr 2022 09:08:00 +0000
Message-Id: <20220414090800.2542064-1-chi.minghao@zte.com.cn>
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

Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
pm_runtime_put_noidle. This change is just to simplify the code, no
actual functional changes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/ti/davinci_emac.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 4b6aed78d392..9d1e98db308b 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1422,9 +1422,8 @@ static int emac_dev_open(struct net_device *ndev)
 	struct phy_device *phydev = NULL;
 	struct device *phy = NULL;
 
-	ret = pm_runtime_get_sync(&priv->pdev->dev);
+	ret = pm_runtime_resume_and_get(&priv->pdev->dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(&priv->pdev->dev);
 		dev_err(&priv->pdev->dev, "%s: failed to get_sync(%d)\n",
 			__func__, ret);
 		return ret;
@@ -1661,9 +1660,8 @@ static struct net_device_stats *emac_dev_getnetstats(struct net_device *ndev)
 	u32 stats_clear_mask;
 	int err;
 
-	err = pm_runtime_get_sync(&priv->pdev->dev);
+	err = pm_runtime_resume_and_get(&priv->pdev->dev);
 	if (err < 0) {
-		pm_runtime_put_noidle(&priv->pdev->dev);
 		dev_err(&priv->pdev->dev, "%s: failed to get_sync(%d)\n",
 			__func__, err);
 		return &ndev->stats;
@@ -1954,9 +1952,8 @@ static int davinci_emac_probe(struct platform_device *pdev)
 	netif_napi_add(ndev, &priv->napi, emac_poll, EMAC_POLL_WEIGHT);
 
 	pm_runtime_enable(&pdev->dev);
-	rc = pm_runtime_get_sync(&pdev->dev);
+	rc = pm_runtime_resume_and_get(&pdev->dev);
 	if (rc < 0) {
-		pm_runtime_put_noidle(&pdev->dev);
 		dev_err(&pdev->dev, "%s: failed to get_sync(%d)\n",
 			__func__, rc);
 		goto err_napi_del;
-- 
2.25.1


