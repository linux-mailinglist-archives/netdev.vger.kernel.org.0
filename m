Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADBA29D5B8
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbgJ1WIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbgJ1WH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:07:58 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E43C0613D1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:07:58 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id c21so954283ljj.0
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nh9xokiPkvqctf6o6zrnNObT3/K5gBk3pqgZqJN8Tz4=;
        b=gGqY+2qo6+4NBrOHXPjQznWhQil69vqLuQf/ygGqTj5nB8gqz9iyPlDsx3eW+mb/L3
         vaiWek7eP7yf9wSnOVeAbqOl8NfI2+zhDPX0W+1V2rJg1fAFr/yAnyz5bg15Cr5HPqjp
         2ThDE8qwD2JWQ99PoPYizbw5Bj7UTCkbd58u619vyxmpjiFdlLac3oPUqz0uc4mXkc0u
         6H6Tp/gQnII0ukP+px4/VL2jigHIq8OimQwnwHNaVWK8jIeoXYb57TWkmG9i0YWQSHPo
         XGngxTPhZA0vnlTHK0y5zAAXEgCVWhUwgsBvUS0fY3R3kXn0DzIVYE9V6OB7LrT7M5Ev
         ys4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nh9xokiPkvqctf6o6zrnNObT3/K5gBk3pqgZqJN8Tz4=;
        b=D24UBgFhcuozefg2BpXIl4rpAv3GYB5zzi5bzPx9rVHqiBxvqCpJAHnCu6Vfgu82jg
         wJNNOXsJS2+0qTPdtyBicSP6A1cAT3aQWN2THL86OQO/AMwriiAxfTZy04NXnscq2GmU
         l9zy/9b41Mf2yOgzEb786WeTt7O0ceMf3ysY9XU3eG0wPpq83ew8BOhcwbkNH3qXg+z0
         Ihnx5Fzy5u8mrsyOTdNGbSz9Vyw782O83A+P0UcyRvP9vvgdSGfRv2hsoktNsJMrKBLZ
         ++CKKUjBdlyQvWU6g5LRv7T0BWVmceiQsX0bjpSPcZERc9rCJFnGOa2ivBI+7JT48t1f
         KXnQ==
X-Gm-Message-State: AOAM531t3wAsKBXp8ja51swQlyQXjutApYGsOSqU8y2y9oEJt7CdM1tR
        orWxnFHIPQbgi+uV4bvxRSKXKbeLoVde5wCw
X-Google-Smtp-Source: ABdhPJyYC5c2S6JHnw4GRJyIA/FO92N7v6Bf96rJ5XpQFzMfybB7o68SWtKoxjxjN01TcFxIPFOnRw==
X-Received: by 2002:a5d:420b:: with SMTP id n11mr111731wrq.218.1603902523138;
        Wed, 28 Oct 2020 09:28:43 -0700 (PDT)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id e11sm43003wrj.75.2020.10.28.09.28.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2020 09:28:42 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net,
        manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bbhatt@codeaurora.org, willemdebruijn.kernel@gmail.com,
        jhugo@codeaurora.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v8 1/2] bus: mhi: Add mhi_queue_is_full function
Date:   Wed, 28 Oct 2020 17:34:57 +0100
Message-Id: <1603902898-25233-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function can be used by client driver to determine whether it's
possible to queue new elements in a channel ring.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v1->v5: not part of the series
 v6: Add this commit, used for stopping TX queue
 v7: no change
 v8: remove static change (up to the compiler)

 drivers/bus/mhi/core/main.c | 11 +++++++++++
 include/linux/mhi.h         |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index a588eac..bab38d2 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -1173,6 +1173,17 @@ int mhi_queue_buf(struct mhi_device *mhi_dev, enum dma_data_direction dir,
 }
 EXPORT_SYMBOL_GPL(mhi_queue_buf);
 
+bool mhi_queue_is_full(struct mhi_device *mhi_dev, enum dma_data_direction dir)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *mhi_chan = (dir == DMA_TO_DEVICE) ?
+					mhi_dev->ul_chan : mhi_dev->dl_chan;
+	struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
+
+	return mhi_is_ring_full(mhi_cntrl, tre_ring);
+}
+EXPORT_SYMBOL_GPL(mhi_queue_is_full);
+
 int mhi_send_cmd(struct mhi_controller *mhi_cntrl,
 		 struct mhi_chan *mhi_chan,
 		 enum mhi_cmd_type cmd)
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 9d67e75..f72c3a4 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -745,4 +745,11 @@ int mhi_queue_buf(struct mhi_device *mhi_dev, enum dma_data_direction dir,
 int mhi_queue_skb(struct mhi_device *mhi_dev, enum dma_data_direction dir,
 		  struct sk_buff *skb, size_t len, enum mhi_flags mflags);
 
+/**
+ * mhi_queue_is_full - Determine whether queueing new elements is possible
+ * @mhi_dev: Device associated with the channels
+ * @dir: DMA direction for the channel
+ */
+bool mhi_queue_is_full(struct mhi_device *mhi_dev, enum dma_data_direction dir);
+
 #endif /* _MHI_H_ */
-- 
2.7.4

