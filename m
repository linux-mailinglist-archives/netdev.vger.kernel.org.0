Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58892621B8F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbiKHSMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234231AbiKHSMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:12:00 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D6B4B99F
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:11:59 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id h9so22334919wrt.0
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 10:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1o2x75QMXnEx7W9bo3sYlpr0oxVXvlHN3ieGl1S2FPc=;
        b=ujEcfx2JBqa8tGPUt5e3C3LQcP1CU3B5jOJvJRtkbqcSjMkGYHWeqnwOke9HxmmCe8
         17cBtyAyhYSgh6EsCEbH8p/X0IcSBkasuJTvONH7Z2EKSF34By622568NRHz8VqyvLDm
         ZxU4G5j7EgRNhQ+f++AUPlEcdbmgsBV2NnXXHOopQLLH2pDmOF9S7YzN5MxHIoup1FQN
         zwcmouVS7G/4AODBGfinpB7DZAkops9B5eftWRfjesoDnCJKJQ9DkBdW+zagwH6EhiKQ
         wftR6OF1Pist9ZCelaDTyx8Wu1nAgo+MNtmLpXrO8bxpdBx9uRsOj3gNuAVX43ZO/oMQ
         +jsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1o2x75QMXnEx7W9bo3sYlpr0oxVXvlHN3ieGl1S2FPc=;
        b=qbvs3QK3ce20CRc0Hnb7IAVLNeNQYCDBkVFK2LMtZrI7R7Kv/G582WbhBcyzafEtb2
         ugx977oeMomXO2lr5aiow0bic6cMH5SgeXQPGYQ637fSo8rqBAfitOvv6lip4YLPTPax
         112Q55zIM9UA/FyXj0FL5VcETJO7AXg82b7hZnLhegP4CyKcXPobnOqhjtvBtZIhGr62
         //e1Kc2o5e6jaYM8j2x3Ne1SWQNFfTTcUeh+fjc3AbbnHnE8OaVNzsx3eMH4FrLqwII1
         NvN4ZJefSx7zuFN5xzDKppXMWeAraX9y2+tmzW1Q4i0QrKR9Nxiin+x/J4ZuiybnaCCl
         4t4w==
X-Gm-Message-State: ACrzQf3PsL7splbAKdH/2hYKdLogK0c6WlBg1f3YH7iQRJuIsqiHSBHB
        Dp9kzDBzm1fhs3c4zxyTkxDwFA==
X-Google-Smtp-Source: AMsMyM46T3ygu8aE3hms50qeFNA7xpoMMLYu6LHnqgB1v/YWuMtPVEqXyZ7xHAb0PHNcaazHqES6EA==
X-Received: by 2002:a05:6000:24f:b0:236:76e8:33fd with SMTP id m15-20020a056000024f00b0023676e833fdmr35567148wrz.215.1667931117970;
        Tue, 08 Nov 2022 10:11:57 -0800 (PST)
Received: from nicolas-Precision-3551.home ([2001:861:5180:dcc0:7d10:e9e8:fd9a:2f72])
        by smtp.gmail.com with ESMTPSA id q12-20020a5d61cc000000b002238ea5750csm13037109wrv.72.2022.11.08.10.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 10:11:57 -0800 (PST)
From:   Nicolas Frayer <nfrayer@baylibre.com>
To:     nm@ti.com, ssantosh@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, peter.ujfalusi@gmail.com,
        vkoul@kernel.org, dmaengine@vger.kernel.org,
        grygorii.strashko@ti.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     khilman@baylibre.com, glaroque@baylibre.com, nfrayer@baylibre.com
Subject: [PATCH v4 1/4] soc: ti: Convert allocations to devm
Date:   Tue,  8 Nov 2022 19:11:41 +0100
Message-Id: <20221108181144.433087-2-nfrayer@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221108181144.433087-1-nfrayer@baylibre.com>
References: <20221108181144.433087-1-nfrayer@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changed the memory and resource allocations in the probe function
to devm. Also added a remove callback.

Signed-off-by: Nicolas Frayer <nfrayer@baylibre.com>
---
 drivers/soc/ti/k3-socinfo.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/soc/ti/k3-socinfo.c b/drivers/soc/ti/k3-socinfo.c
index 91f441ee6175..19f3e74f5376 100644
--- a/drivers/soc/ti/k3-socinfo.c
+++ b/drivers/soc/ti/k3-socinfo.c
@@ -96,21 +96,18 @@ static int k3_chipinfo_probe(struct platform_device *pdev)
 	partno_id = (jtag_id & CTRLMMR_WKUP_JTAGID_PARTNO_MASK) >>
 		 CTRLMMR_WKUP_JTAGID_PARTNO_SHIFT;
 
-	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	soc_dev_attr = devm_kzalloc(&pdev->dev, sizeof(*soc_dev_attr), GFP_KERNEL);
 	if (!soc_dev_attr)
 		return -ENOMEM;
 
-	soc_dev_attr->revision = kasprintf(GFP_KERNEL, "SR%x.0", variant);
-	if (!soc_dev_attr->revision) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	soc_dev_attr->revision = devm_kasprintf(&pdev->dev, GFP_KERNEL, "SR%x.0", variant);
+	if (!soc_dev_attr->revision)
+		return -ENOMEM;
 
 	ret = k3_chipinfo_partno_to_names(partno_id, soc_dev_attr);
 	if (ret) {
 		dev_err(dev, "Unknown SoC JTAGID[0x%08X]\n", jtag_id);
-		ret = -ENODEV;
-		goto err_free_rev;
+		return -ENODEV;
 	}
 
 	node = of_find_node_by_path("/");
@@ -118,22 +115,26 @@ static int k3_chipinfo_probe(struct platform_device *pdev)
 	of_node_put(node);
 
 	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR(soc_dev)) {
-		ret = PTR_ERR(soc_dev);
-		goto err_free_rev;
-	}
+	if (IS_ERR(soc_dev))
+		return PTR_ERR(soc_dev);
+
+	platform_set_drvdata(pdev, soc_dev);
 
 	dev_info(dev, "Family:%s rev:%s JTAGID[0x%08x] Detected\n",
 		 soc_dev_attr->family,
 		 soc_dev_attr->revision, jtag_id);
 
 	return 0;
+}
+
+static int k3_chipinfo_remove(struct platform_device *pdev)
+{
+	struct soc_device *soc_dev = platform_get_drvdata(pdev);
 
-err_free_rev:
-	kfree(soc_dev_attr->revision);
-err:
-	kfree(soc_dev_attr);
-	return ret;
+	if (soc_dev)
+		soc_device_unregister(soc_dev);
+
+	return 0;
 }
 
 static const struct of_device_id k3_chipinfo_of_match[] = {
@@ -147,6 +148,7 @@ static struct platform_driver k3_chipinfo_driver = {
 		.of_match_table = k3_chipinfo_of_match,
 	},
 	.probe = k3_chipinfo_probe,
+	.remove = k3_chipinfo_remove,
 };
 
 static int __init k3_chipinfo_init(void)
-- 
2.25.1

