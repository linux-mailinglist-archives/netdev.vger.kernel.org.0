Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0C11474CD
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 00:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgAWX3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 18:29:46 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46316 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729288AbgAWX3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 18:29:45 -0500
Received: by mail-pf1-f195.google.com with SMTP id n9so143727pff.13
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 15:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KLJZo46tQPRXDmKRyvfvXMbLAN2h1kL3Vua+/I58BTE=;
        b=hcYWKNAo8Cy8EeRiueJAEn+mXal6m5OY6GOKQabIHmRKD6AGZLLsfjrNZKv3rt9MFc
         JTAf6Lqkvg5zu5qR+nH7g7Ou3JUx87svy/KnmRVTQRQNNl+gn/17w+2G1xdrH07eBTrF
         ey32vEsWdRNpQN0unvqosgXbFWv9VUiHd/tmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KLJZo46tQPRXDmKRyvfvXMbLAN2h1kL3Vua+/I58BTE=;
        b=uND40z6bbNBJLgQLYLKaBfQEpaGXcz/dlLWUuile7DPBrxVHw1og1pDnRPQmrATe68
         nm3U6dnK+nmGMEhyJeKi5PQQ/yc4+6IjTMYo9/sfId2oZr3srqk5R/7QlguZB51Pgtl8
         S/o8T9M0GxZFNZnqi5YJIXEy8l7d219GLxGlzFAzAj330qBaTQIs3X1Zy5dWhUHi/6zn
         X5fbPk6hda9Pb4ZjJwkBkrQxTxQyR51Ma4hm7FQEqUahoA1pU6ldGHMm21Y3UixKIs/X
         DTh702sc7YP4wnqq+maVSWNdIbl0RGV4lS5TCzg8HG50UQxJm+9tl383xiNh9mGOs0iI
         SrdQ==
X-Gm-Message-State: APjAAAV7efm1tMOBGpBzUWQmFVyFbp4DqyVeRl5yTk3AUWdK6L7ErL2e
        bxJEMdiGGzJlQYjRnxMriQSfNw==
X-Google-Smtp-Source: APXvYqzGg6/xG/ALOXguOUyZGSJKC0EKTomJZgx4LZsRS1iAXgQ5k6JifZ8wlhHRo551vRDHtc+yCw==
X-Received: by 2002:a62:d405:: with SMTP id a5mr661947pfh.254.1579822185284;
        Thu, 23 Jan 2020 15:29:45 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id 3sm3973649pjg.27.2020.01.23.15.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 15:29:44 -0800 (PST)
From:   Stephen Boyd <swboyd@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] ath10k: Use device_get_match_data() to simplify code
Date:   Thu, 23 Jan 2020 15:29:44 -0800
Message-Id: <20200123232944.39247-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use device_get_match_data() here to simplify the code a bit.

Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 19a4d053d1de..88900f0399f5 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1466,7 +1466,6 @@ MODULE_DEVICE_TABLE(of, ath10k_snoc_dt_match);
 static int ath10k_snoc_probe(struct platform_device *pdev)
 {
 	const struct ath10k_snoc_drv_priv *drv_data;
-	const struct of_device_id *of_id;
 	struct ath10k_snoc *ar_snoc;
 	struct device *dev;
 	struct ath10k *ar;
@@ -1474,14 +1473,13 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	int ret;
 	u32 i;
 
-	of_id = of_match_device(ath10k_snoc_dt_match, &pdev->dev);
-	if (!of_id) {
+	dev = &pdev->dev;
+	drv_data = device_get_match_data(dev);
+	if (!drv_data) {
 		dev_err(&pdev->dev, "failed to find matching device tree id\n");
 		return -EINVAL;
 	}
 
-	drv_data = of_id->data;
-	dev = &pdev->dev;
 
 	ret = dma_set_mask_and_coherent(dev, drv_data->dma_mask);
 	if (ret) {
-- 
Sent by a computer, using git, on the internet

