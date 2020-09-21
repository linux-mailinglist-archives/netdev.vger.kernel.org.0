Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5205271C24
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 09:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgIUHhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 03:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgIUHhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 03:37:17 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD9CC0613CE
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:37:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k15so11584650wrn.10
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=N3NUdo+DwpnJaRzbu3ClRmdDKBhnsZkqlLToVcKy1Wc=;
        b=eg8GQYRbCOsZtUi5Kl4zm67GzO6te2SL2d9mOpZjX8lyadDMcRNo7fsDUDxV+wuDn9
         g0SzdglOGxuZsxrznxn1Ie0mOkNaFParV0nhuGit5gHihKOU/n3H6q7Z6cqFIiAhpeSv
         wATs5JLfIUeSRNqdp4nDLCEEZQrc7H4i4lIfJrNBioqkumKHCqN56zv1jDAvKh5UkJv3
         VdHHHiC2Yn5osWzJCAs5i+rzGO/vxe3pzwuFOB5HN8jdimyldYmxDRgje5U5OcMqq682
         1gPyoX/TIOUh9Mb7I5IlA9iY0fGkLkNtASlHso4VYJKmoxNu5uAwiMeeeB54lXvtZZ+R
         oCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N3NUdo+DwpnJaRzbu3ClRmdDKBhnsZkqlLToVcKy1Wc=;
        b=S+9MU9jfO9AazEXm0pe0MAAn9DZRRinyVsFN0ptnhtOVmoErtOSTp1rTS8odloaRsL
         IDekfN6NU/WeNwdAij3jS2DKkuee14zshkSB+Mg+rEJzsJRphLPx/2mDmPOQayl+563/
         fgmH4RXl/lw/P6UyrsTLxDe9aVaFZPyNEQmfnDSQ6yKDgRJI3lkHG6Z4Y6pgvHfzwjCd
         cHGG/opmeugUPGni38aALh7WqR46mT1q59vsGJLNCnxhTFJpML3ro0uuabQH8Cb5fnb+
         a0E5hMurNUKsA4YoJUJGpuFkW1TzTysX2d5gGwVkaaURPmd9o+CUCeoe6t2yWhMRhjRO
         Kq+g==
X-Gm-Message-State: AOAM530BR0RCY6mVkTCOLIWVpaglDQE2GO7ZxggaBbjxQsKp5mgjZj9+
        lOZoxcMy7PqW9lsB8WC4YBFt5Q==
X-Google-Smtp-Source: ABdhPJzdhBhEeyzI9dWn6DZf412QQCk747FGLZw6+1cXqj1V/SmzBVdPTBP2oQPlXeeU7j+jmhA19w==
X-Received: by 2002:adf:f10a:: with SMTP id r10mr48960861wro.86.1600673835750;
        Mon, 21 Sep 2020 00:37:15 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:490:8730:5875:9da3:b857:e7f4])
        by smtp.gmail.com with ESMTPSA id v9sm19976761wrv.35.2020.09.21.00.37.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2020 00:37:14 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 1/2] bus: mhi: Remove auto-start option
Date:   Mon, 21 Sep 2020 09:43:03 +0200
Message-Id: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is really no point having an auto-start for channels.
This is confusing for the device drivers, some have to enable the
channels, others don't have... and waste resources (e.g. pre allocated
buffers) that may never be used.

This is really up to the MHI device(channel) driver to manage the state
of its channels.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: split MHI and qrtr changes in dedicated commits

 drivers/bus/mhi/core/init.c     | 9 ---------
 drivers/bus/mhi/core/internal.h | 1 -
 include/linux/mhi.h             | 2 --
 3 files changed, 12 deletions(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index dccc824..8798deb 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -721,7 +721,6 @@ static int parse_ch_cfg(struct mhi_controller *mhi_cntrl,
 		mhi_chan->offload_ch = ch_cfg->offload_channel;
 		mhi_chan->db_cfg.reset_req = ch_cfg->doorbell_mode_switch;
 		mhi_chan->pre_alloc = ch_cfg->auto_queue;
-		mhi_chan->auto_start = ch_cfg->auto_start;
 
 		/*
 		 * If MHI host allocates buffers, then the channel direction
@@ -1119,11 +1118,6 @@ static int mhi_driver_probe(struct device *dev)
 			goto exit_probe;
 
 		ul_chan->xfer_cb = mhi_drv->ul_xfer_cb;
-		if (ul_chan->auto_start) {
-			ret = mhi_prepare_channel(mhi_cntrl, ul_chan);
-			if (ret)
-				goto exit_probe;
-		}
 	}
 
 	ret = -EINVAL;
@@ -1157,9 +1151,6 @@ static int mhi_driver_probe(struct device *dev)
 	if (ret)
 		goto exit_probe;
 
-	if (dl_chan && dl_chan->auto_start)
-		mhi_prepare_channel(mhi_cntrl, dl_chan);
-
 	mhi_device_put(mhi_dev);
 
 	return ret;
diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index 5a81a42..73b52a0 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -563,7 +563,6 @@ struct mhi_chan {
 	bool configured;
 	bool offload_ch;
 	bool pre_alloc;
-	bool auto_start;
 	bool wake_capable;
 };
 
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 811e686..0d277c7 100644
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
2.7.4

