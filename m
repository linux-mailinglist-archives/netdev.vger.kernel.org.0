Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A137729A6A0
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 09:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894948AbgJ0IdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 04:33:19 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33577 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894934AbgJ0IdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 04:33:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id l20so542180wme.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 01:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=U/MlWRxuh8uUr+vmJkiS4054PFdvq7A/wa6DJ1XOAEc=;
        b=wugiRjSdvw8wQdvKpUxTNVedcZ6NOrfWbbgBdzXhMOX5kI/Ns/djPwPgsMC0EvqHvS
         fbTh5HGLKo5rKK3Pi5pTYYM1dHY5H+Vx7Z1k9WKsxSPZtCqthMRpAVbHQ/eIFIly1h0G
         JMxmF+A6HDD28PUWW8u1hTqmkXYVoJ0nU5C+eWE7IOrgnpscmRmRFt/MXzcLIxX/XAOj
         xbZiBrWNiIXvrO4nFh/SMrD7pmikuGIDevF9l6UwASJR3Rq+kIY0pzB6tX3kuGTv8HMk
         kZcnavOvYKeBZnRv0qXXKcbJbzlEYCol+fNt+RLn+zf5WP6XhN8Ars/gViNdnMFdSh0U
         L8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U/MlWRxuh8uUr+vmJkiS4054PFdvq7A/wa6DJ1XOAEc=;
        b=fAYCu1RMZnh7ripMzxZNz2q3b/1wgK4UWesxCwKj+2TGfFV8taQChkTUkQGvUqiE4W
         VLGebIGAPoS6hss/1rloogCSq6BYLNwWuEZq4X9wx+X/z8lyiDnonbTi0mKvF79ekDRB
         wHIztAcYSREzFHUYCLEIsO8wU5FIcuG5VDOeNgk4/6oN3WKmqNE9gUtxdZJNFJtXmcAO
         aFrKFf6KHyiUjenI6WMaqa/pijxVtqQ1RV/Z1DFhJ05FBjyPwSkOGjBHrDl/u77+6qSI
         GteanSti2xgfccMLhNaqwsdouX8jdydUVI7GCcJT4OYGO1Nrpp+9mL+18efc+x2I+7Gk
         p7ww==
X-Gm-Message-State: AOAM532JPGAl3wF9j+wNslEQkNHvq7pUQOdn7jTRzt+aUtbQLfOaScuC
        B82x8Tc24VQqhAnuoQD5tHjOMA==
X-Google-Smtp-Source: ABdhPJysd+TQD2LRMFSTrN483vEA9Is4itZxLwdZPhjQpsh3lOLfjolcK0ML0phnkCIVl+a/fFT0Fw==
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr1372275wmm.135.1603787594035;
        Tue, 27 Oct 2020 01:33:14 -0700 (PDT)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id u6sm976361wmj.40.2020.10.27.01.33.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2020 01:33:13 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net,
        manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v7 1/2] bus: mhi: Add mhi_queue_is_full function
Date:   Tue, 27 Oct 2020 09:39:36 +0100
Message-Id: <1603787977-6975-1-git-send-email-loic.poulain@linaro.org>
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

 drivers/bus/mhi/core/main.c | 15 +++++++++++++--
 include/linux/mhi.h         |  7 +++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index a588eac..44aa11f 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -943,8 +943,8 @@ void mhi_ctrl_ev_task(unsigned long data)
 	}
 }
 
-static bool mhi_is_ring_full(struct mhi_controller *mhi_cntrl,
-			     struct mhi_ring *ring)
+static inline bool mhi_is_ring_full(struct mhi_controller *mhi_cntrl,
+				    struct mhi_ring *ring)
 {
 	void *tmp = ring->wp + ring->el_size;
 
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

