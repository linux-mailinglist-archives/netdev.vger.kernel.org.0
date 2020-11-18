Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25A62B75F1
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 06:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgKRFb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 00:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRFb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 00:31:28 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CE4C0613D4
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 21:31:28 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id t8so681620pfg.8
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 21:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PZ0QCIA20El2MRacEHi3Dqx2l9Pt/uOvrOyEb5RrjSo=;
        b=AaFcyCjTYhbv/RYh1tMspvU5/0QozZMYg1ooVrllJBMTa1+jSZGiznQKhWZ7ys7P3Z
         Tc+mA2Lfte79zKHM47RyGj2wBfdWGsBJAz+SKSEOt39ii9G39WpTWr/8C2qb/gG6bLl1
         nHQNITgmxxh6D3eKPeAOitgKCQTkyPlfoFQUXNZ+09yQ5wlBPAllnDDCPqrQoJGoOb/f
         NjT06Ry3Q6sygRaNGxC4InIdxfx55IAPayvLesc6AyRIgEaO6hGgXJ7JKqzf/czcxUTW
         bfgMfT6wGW+XgkroENEOmet6YysJtm7a4tFY7I8wVWIkIUk4Y5ZqI85baHKcxC5oQTka
         aksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PZ0QCIA20El2MRacEHi3Dqx2l9Pt/uOvrOyEb5RrjSo=;
        b=k1qPUY91Vy4XugwHdz6Yha4/kB69jcb43NJLB93T4lzeYv6aUh50B4Wmk3kWufv3Ko
         GVuPs3R4+FTDznF3n3KntZTS6Q5VLbizlSwJmmhK3124vDxQlr1QuvGU4lNA+WaHeKS5
         76tTAUKhq6Z7tO22XTQTBI1NklVpy+0LlHRxkOsmBmfn5rkJZCMEeWhEq0suaauBgG39
         KrvRGYlnwziuLnzKem+EyRZ1x8VmgJtxq8RFTC7K+PM6/0j+EQ7aZZyBGb1pRwJSm9+g
         BrpAaQJox/Y72tvFmYopMFrNdHaCjZDDsFB4kaB3mAk7ekfENNFvP2du56QK2rA0nX7W
         rVjA==
X-Gm-Message-State: AOAM532A7oQQS4O82QGh4W3XF8IDhh1i8lxLfvp3kS7GPApYMNX82otg
        Lb4mJluRV9dak0nBercORhey
X-Google-Smtp-Source: ABdhPJwIt85VuGYkAYwIONU1QZz0EJr0pWl3K7c3zyf5cYzD/Oemr/56MOALtp48rzS5wxhCQzdrSg==
X-Received: by 2002:a05:6a00:134d:b029:18b:2cde:d747 with SMTP id k13-20020a056a00134db029018b2cded747mr2736391pfu.60.1605677488054;
        Tue, 17 Nov 2020 21:31:28 -0800 (PST)
Received: from localhost.localdomain ([103.59.133.81])
        by smtp.googlemail.com with ESMTPSA id h11sm23114572pfo.69.2020.11.17.21.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 21:31:27 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     linux-arm-msm@vger.kernel.org, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        netdev@vger.kernel.org, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] bus: mhi: Remove auto-start option
Date:   Wed, 18 Nov 2020 11:01:02 +0530
Message-Id: <20201118053102.13119-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

There is really no point having an auto-start for channels.
This is confusing for the device drivers, some have to enable the
channels, others don't have... and waste resources (e.g. pre allocated
buffers) that may never be used.

This is really up to the MHI device(channel) driver to manage the state
of its channels.

While at it, let's also remove the auto-start option from ath11k mhi
controller.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[mani: clubbed ath11k change]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/init.c           | 9 ---------
 drivers/bus/mhi/core/internal.h       | 1 -
 drivers/net/wireless/ath/ath11k/mhi.c | 4 ----
 include/linux/mhi.h                   | 2 --
 4 files changed, 16 deletions(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 0ffdebde8265..381fdea2eb9f 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -758,7 +758,6 @@ static int parse_ch_cfg(struct mhi_controller *mhi_cntrl,
 		mhi_chan->offload_ch = ch_cfg->offload_channel;
 		mhi_chan->db_cfg.reset_req = ch_cfg->doorbell_mode_switch;
 		mhi_chan->pre_alloc = ch_cfg->auto_queue;
-		mhi_chan->auto_start = ch_cfg->auto_start;
 
 		/*
 		 * If MHI host allocates buffers, then the channel direction
@@ -1160,11 +1159,6 @@ static int mhi_driver_probe(struct device *dev)
 			goto exit_probe;
 
 		ul_chan->xfer_cb = mhi_drv->ul_xfer_cb;
-		if (ul_chan->auto_start) {
-			ret = mhi_prepare_channel(mhi_cntrl, ul_chan);
-			if (ret)
-				goto exit_probe;
-		}
 	}
 
 	ret = -EINVAL;
@@ -1198,9 +1192,6 @@ static int mhi_driver_probe(struct device *dev)
 	if (ret)
 		goto exit_probe;
 
-	if (dl_chan && dl_chan->auto_start)
-		mhi_prepare_channel(mhi_cntrl, dl_chan);
-
 	mhi_device_put(mhi_dev);
 
 	return ret;
diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index 7989269ddd96..33c23203c531 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -563,7 +563,6 @@ struct mhi_chan {
 	bool configured;
 	bool offload_ch;
 	bool pre_alloc;
-	bool auto_start;
 	bool wake_capable;
 };
 
diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index aded9a719d51..47a1ce1bee4f 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -24,7 +24,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
 		.auto_queue = false,
-		.auto_start = false,
 	},
 	{
 		.num = 1,
@@ -39,7 +38,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
 		.auto_queue = false,
-		.auto_start = false,
 	},
 	{
 		.num = 20,
@@ -54,7 +52,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
 		.auto_queue = false,
-		.auto_start = true,
 	},
 	{
 		.num = 21,
@@ -69,7 +66,6 @@ static struct mhi_channel_config ath11k_mhi_channels[] = {
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
 		.auto_queue = true,
-		.auto_start = true,
 	},
 };
 
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index d4841e5a5f45..6522a4adc794 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -214,7 +214,6 @@ enum mhi_db_brst_mode {
  * @offload_channel: The client manages the channel completely
  * @doorbell_mode_switch: Channel switches to doorbell mode on M0 transition
  * @auto_queue: Framework will automatically queue buffers for DL traffic
- * @auto_start: Automatically start (open) this channel
  * @wake-capable: Channel capable of waking up the system
  */
 struct mhi_channel_config {
@@ -232,7 +231,6 @@ struct mhi_channel_config {
 	bool offload_channel;
 	bool doorbell_mode_switch;
 	bool auto_queue;
-	bool auto_start;
 	bool wake_capable;
 };
 
-- 
2.17.1

