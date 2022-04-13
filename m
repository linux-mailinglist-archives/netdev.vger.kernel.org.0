Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2554FF3A4
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiDMJh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiDMJhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:37:55 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFE653E10;
        Wed, 13 Apr 2022 02:35:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id md4so1413954pjb.4;
        Wed, 13 Apr 2022 02:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/a7BzFN2ctOPRBd9oUWUrScQo5EEkuSIQfpImBe6rnE=;
        b=I90iibzSdzn+cqhB2DXoa6KLTCJaYar2EiIgmCSBrZVg3dCjj52kRl5OqwkY2lHsys
         l8aIKnzASwNb2U5xuJ4ZBayF3bLN9uv9cVQg5wwpQLRSkdFhdrArdvqJhd3vBJyS4JaN
         wR28i/Xa6FsfHvSbPLoA/98HZOMC7EHbN3w6bmn4HZsYfAVoc1TtWaaoxJE7JT09oeqj
         YbC1H89SiJDCxWA92uclljjTOpyqudsq+KYPLavzpDc4cfMCbngPGzwmDyaMd3xK2WkT
         VScZ71aPK8bbAihoXtNTL4x6JPKX83xbFd5dB6o8sqOiFQE4zfHianOCtoJpUFcNNx52
         /VmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/a7BzFN2ctOPRBd9oUWUrScQo5EEkuSIQfpImBe6rnE=;
        b=VyT3Ard7MMoackziZB92Gjlmsg/7GSdI9a5ivuDs5msc58KFri+tiEFPF2Q+Ok+9xW
         Yv5mQul1MXL8Q15NWw1e1pKnbJtjDpPRRyVpQusgYW8LYQ5dVyqkuyLvI7gnOCF1fZR5
         7KtJIQsUEf2+xi7LBowjDy1bE3ZmFys8QxDsAeZr3P9ywiG0lBKWrzt6aRPcTSST/PMW
         1/ptBSo1/wY267IdQ4Qu4zRVGv9Dns4uPbpS7zfCghbCqPbwXhpJUrLTXvQID/sikcX8
         raZzjpgzsRXJDxct6WedVBz+gw46CPaqMheF9W4Edwi63RZBo+C8Z6H4HnZd3hyVSn1r
         Xa9g==
X-Gm-Message-State: AOAM5300J5jsB/XP1ZpmdXcQibdM5hsmG2iOXPfhjv6HoFYYjltSowUe
        qaUdyTLgo45cZtifxJUeJNE=
X-Google-Smtp-Source: ABdhPJwTJVrtAYTdoE6pUKxTEQVVIrUZU1wLgzdAsEDbTjMXYK0ZJfLhWxBoBhx+EB116oYkPExZRg==
X-Received: by 2002:a17:90b:390c:b0:1c7:9a94:1797 with SMTP id ob12-20020a17090b390c00b001c79a941797mr9728575pjb.221.1649842533823;
        Wed, 13 Apr 2022 02:35:33 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id md4-20020a17090b23c400b001cb66e3e1f8sm2409048pjb.0.2022.04.13.02.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:35:33 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     grygorii.strashko@ti.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ethernet: ti: cpsw_new: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
Date:   Wed, 13 Apr 2022 09:35:29 +0000
Message-Id: <20220413093529.2538378-1-chi.minghao@zte.com.cn>
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

Using pm_runtime_resume_and_get is more appropriate
for simplifing code

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/ti/cpsw_new.c | 33 ++++++++++--------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index bd4b1528cf99..13e54b05953c 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -449,11 +449,9 @@ static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
 	if (vid == cpsw->data.default_vlan)
 		return 0;
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* In dual EMAC, reserved VLAN id should not be used for
 	 * creating VLAN interfaces as this can break the dual
@@ -829,11 +827,9 @@ static int cpsw_ndo_open(struct net_device *ndev)
 
 	dev_info(priv->dev, "starting ndev. mode: %s\n",
 		 cpsw_is_switch_en(cpsw) ? "switch" : "dual_mac");
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* Notify the stack of the actual queue counts. */
 	ret = netif_set_real_num_tx_queues(ndev, cpsw->tx_ch_num);
@@ -985,11 +981,9 @@ static int cpsw_ndo_set_mac_address(struct net_device *ndev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	vid = cpsw->slaves[slave_no].port_vlan;
 	flags = ALE_VLAN | ALE_SECURE;
@@ -1024,11 +1018,9 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
 	if (vid == cpsw->data.default_vlan)
 		return 0;
 
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
+	ret = pm_runtime_resume_and_get(cpsw->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* reset the return code as pm_runtime_get_sync() can return
 	 * non zero values as well.
@@ -1918,9 +1910,8 @@ static int cpsw_probe(struct platform_device *pdev)
 	/* Need to enable clocks with runtime PM api to access module
 	 * registers
 	 */
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(dev);
 		pm_runtime_disable(dev);
 		return ret;
 	}
@@ -2045,11 +2036,9 @@ static int cpsw_remove(struct platform_device *pdev)
 	struct cpsw_common *cpsw = platform_get_drvdata(pdev);
 	int ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	cpsw_unregister_notifiers(cpsw);
 	cpsw_unregister_devlink(cpsw);
-- 
2.25.1


