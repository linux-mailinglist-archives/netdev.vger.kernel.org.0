Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77362A0126
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgJ3JVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3JVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:21:36 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5527CC0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:21:36 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c18so2182285wme.2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=eXIACbCsgyr/MQngJDpXlLDV55Dv+Q+BQ5lb/PUNeAA=;
        b=LPc6x/PFRbER4n5vd3RRYPuhpe3Qc8Q2AKgJUnaqXhwei26VVqBH6zqL2Gm9OUU6WC
         Fj+yxwOziHGZYDvcmAQ+ANDMDSVWFzGf17qvixTCeV77NG+gxzqcsKbVE0o3+4+W2pPM
         1+Blg5qtdA/cUsvbsRK/8LOgIe+2e7l/iB9r5U606IR7oxVxvPvYBmVUm3ejvEtwJLUL
         7pRjCq/mxVt5IpZqBnp+rh3aMQweCgL/TcWKJB2RrzfxVg/C/hve0r5ccq110E4huxJZ
         PljTrFYjq4CYA0+dMwnVJW3/fkgqYfXbIgFhxQE3gjn9bvEsnCFQt9ymc4Dwou6Erzxu
         TrDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eXIACbCsgyr/MQngJDpXlLDV55Dv+Q+BQ5lb/PUNeAA=;
        b=KYaVjFC5qJyS3oiAsJbkH5dJtzYJ+80W+dtbYzUuVkiRrvppPHCyuCFr2ppIiRml7R
         V3J4q28SvFC4lCPLT6mAQl8z6wh/N44hAP+JomJJBa4UQ5Ylph+nkGdrdLAjI0zMkgjO
         BNa5GAQX7DmHqjAnEXjCSsnWK4tVKfc7xXqn3nMIxiHvhwtxywinSzLqOLSaTzigXbxk
         sOVMbPgWxM/f/CH1AojRRbUtwrTj7DA+hnw4nTIXzIV5T69Rcw4eQ2IYeQN5t86hy9sL
         kSNsv181MDS1RisEtBGKDKv+AiJnSE6rLHcxrJhFmz27TcwYM5vUCbzzDh6M47QUrwKH
         1BjA==
X-Gm-Message-State: AOAM531eWxywvgXLpFW9gg6EqIommUFP/DoV5jAI8pdfFWuek5oApwcN
        9IqHbiJ8lDwUuKdmTkYgHyldVA==
X-Google-Smtp-Source: ABdhPJxXtWrRm+Xdjo6g17kYVMn6hG0CbWMd1QrFwkAJnfxyIUo7I1Tw5nyjKtYiSP0c78I+AWOAXQ==
X-Received: by 2002:a7b:c20d:: with SMTP id x13mr1490585wmi.90.1604049694966;
        Fri, 30 Oct 2020 02:21:34 -0700 (PDT)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id c64sm3961111wme.29.2020.10.30.02.21.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Oct 2020 02:21:34 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bbhatt@codeaurora.org, willemdebruijn.kernel@gmail.com,
        jhugo@codeaurora.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v9 1/2] bus: mhi: Add mhi_queue_is_full function
Date:   Fri, 30 Oct 2020 10:27:51 +0100
Message-Id: <1604050072-1197-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function can be used by client driver to determine whether it's
possible to queue new elements in a channel ring.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 v1->v5: not part of the series
 v6: Add this commit, used for stopping TX queue
 v7: no change
 v8: remove static change (up to the compiler)
 v9: no change + Mani reviewed-by tag
 
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

