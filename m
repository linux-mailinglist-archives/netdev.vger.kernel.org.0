Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6956543378A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 15:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbhJSNrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 09:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbhJSNrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 09:47:24 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C530C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 06:45:10 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t7so4951897pgl.9
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 06:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2kvblXUORr+LJ9sIpb+2/3CnmQvxl21vFOz3lnIkYl8=;
        b=ACOWtTbBdqr6n8/6fbONuWoxQ4aC40vjOZCY+0hBAqVulRiUeBGVy/uNk5O+CbU1oG
         Bnxa/S41TszsImaFBxWvNlC9QSWo5J6zxDlA8OiLqovnn8WE4vws464pWBGW23L3G5FU
         cxmQyAbliHsLgtW1yBexQKf1Owzrjr1twIhJ9kX2dLmcYufcnUkLbKyg8FR+QXAKXueM
         NDuxsUPW57AUumfn9DGjeTxRa08qQ4V+fKnIGtkbYVZcVVYmMs4QyFpqLqo9U+MfQ/du
         p0r/4amTWdkW3Pw6JSuOq3mlorWcG0SU6uKi4y/ny9rP4rymDrFOTSFIgpVDj/vhYDyn
         YmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2kvblXUORr+LJ9sIpb+2/3CnmQvxl21vFOz3lnIkYl8=;
        b=FVACqnWMt96rNFcx2ByYJFk08zsEqq+hyKi7Eu3LKN0ikLSGfD9BYXnlAT81ReF3OV
         T+lEL7YTKXmZHA6QVjfbO6S/GGectN/+tH1wlztAvc44Wy/L9aMGGy2YCsZf0IfrSqW3
         R5BebiSB8xrGE8SQKaTqbR1NyXaXJ7S3rYapHub6T5x8z28xdKOccyXaI2+qzFU7n0pB
         xmxZigttCW5iO3oVDv8E7Tgew7P+5GXE6F8yr7qeOcvCtKtD2sdbV6aKfCX0yiLvry+w
         SxtH7BFJfcj9eCEW1FKZwliM8lUkTImDUkpCzW7dcDouJjturbtzmOoyGDn8yxEADAoU
         jJyA==
X-Gm-Message-State: AOAM5326uo4Oeu81P0xpErd5t5Zq/0GKdlXnWhrpqZXhD8hQ+64bJEOV
        Zoig0ZeHCweHhMD81kG+0jdj
X-Google-Smtp-Source: ABdhPJwkzM8K/S35sLMOqJWgvEmqhuUFJK41/CNo7PdRWqg+sY8+d/nvxMGiDTtng58xs7XykQFiJg==
X-Received: by 2002:a63:6bc2:: with SMTP id g185mr23973933pgc.356.1634651109413;
        Tue, 19 Oct 2021 06:45:09 -0700 (PDT)
Received: from localhost.localdomain ([202.21.43.8])
        by smtp.gmail.com with ESMTPSA id lp9sm3295358pjb.35.2021.10.19.06.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 06:45:08 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     mhi@lists.linux.dev
Cc:     loic.poulain@linaro.org, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        netdev@vger.kernel.org
Subject: [PATCH] bus: mhi: Add mhi_prepare_for_transfer_autoqueue API for DL auto queue
Date:   Tue, 19 Oct 2021 19:14:51 +0530
Message-Id: <20211019134451.174318-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new API "mhi_prepare_for_transfer_autoqueue" for using with client
drivers like QRTR to request MHI core to autoqueue buffers for the DL
channel along with starting both UL and DL channels.

So far, the "auto_queue" flag specified by the controller drivers in
channel definition served this purpose but this will be removed at some
point in future.

Cc: netdev@vger.kernel.org
Co-developed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---

Dave, Jakub: This patch should go through MHI tree. But since the QRTR driver
is also modified, this needs an Ack from you.

 drivers/bus/mhi/core/internal.h |  6 +++++-
 drivers/bus/mhi/core/main.c     | 21 +++++++++++++++++----
 include/linux/mhi.h             | 21 ++++++++++++++++-----
 net/qrtr/mhi.c                  |  2 +-
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index 3a732afaf73e..597da2cce069 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -681,8 +681,12 @@ void mhi_deinit_free_irq(struct mhi_controller *mhi_cntrl);
 void mhi_rddm_prepare(struct mhi_controller *mhi_cntrl,
 		      struct image_info *img_info);
 void mhi_fw_load_handler(struct mhi_controller *mhi_cntrl);
+
+/* Automatically allocate and queue inbound buffers */
+#define MHI_CH_INBOUND_ALLOC_BUFS BIT(0)
 int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
-			struct mhi_chan *mhi_chan);
+			struct mhi_chan *mhi_chan, unsigned int flags);
+
 int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
 		       struct mhi_chan *mhi_chan);
 void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index b15c5bc37dd4..eaa1f62d16a5 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -1430,7 +1430,7 @@ static void mhi_unprepare_channel(struct mhi_controller *mhi_cntrl,
 }
 
 int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
-			struct mhi_chan *mhi_chan)
+			struct mhi_chan *mhi_chan, unsigned int flags)
 {
 	int ret = 0;
 	struct device *dev = &mhi_chan->mhi_dev->dev;
@@ -1455,6 +1455,9 @@ int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
 	if (ret)
 		goto error_pm_state;
 
+	if (mhi_chan->dir == DMA_FROM_DEVICE)
+		mhi_chan->pre_alloc = !!(flags & MHI_CH_INBOUND_ALLOC_BUFS);
+
 	/* Pre-allocate buffer for xfer ring */
 	if (mhi_chan->pre_alloc) {
 		int nr_el = get_nr_avail_ring_elements(mhi_cntrl,
@@ -1609,8 +1612,7 @@ void mhi_reset_chan(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan)
 	read_unlock_bh(&mhi_cntrl->pm_lock);
 }
 
-/* Move channel to start state */
-int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
+int __mhi_prepare_for_transfer(struct mhi_device *mhi_dev, unsigned int flags)
 {
 	int ret, dir;
 	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
@@ -1621,7 +1623,7 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
 		if (!mhi_chan)
 			continue;
 
-		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan);
+		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan, flags);
 		if (ret)
 			goto error_open_chan;
 	}
@@ -1639,8 +1641,19 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
 
 	return ret;
 }
+
+int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
+{
+	return __mhi_prepare_for_transfer(mhi_dev, 0);
+}
 EXPORT_SYMBOL_GPL(mhi_prepare_for_transfer);
 
+int mhi_prepare_for_transfer_autoqueue(struct mhi_device *mhi_dev)
+{
+	return __mhi_prepare_for_transfer(mhi_dev, MHI_CH_INBOUND_ALLOC_BUFS);
+}
+EXPORT_SYMBOL_GPL(mhi_prepare_for_transfer_autoqueue);
+
 void mhi_unprepare_from_transfer(struct mhi_device *mhi_dev)
 {
 	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 723985879035..271db1d6da85 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -717,15 +717,26 @@ void mhi_device_put(struct mhi_device *mhi_dev);
 
 /**
  * mhi_prepare_for_transfer - Setup UL and DL channels for data transfer.
- *                            Allocate and initialize the channel context and
- *                            also issue the START channel command to both
- *                            channels. Channels can be started only if both
- *                            host and device execution environments match and
- *                            channels are in a DISABLED state.
  * @mhi_dev: Device associated with the channels
+ *
+ * Allocate and initialize the channel context and also issue the START channel
+ * command to both channels. Channels can be started only if both host and
+ * device execution environments match and channels are in a DISABLED state.
  */
 int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
 
+/**
+ * mhi_prepare_for_transfer_autoqueue - Setup UL and DL channels with auto queue
+ *                                      buffers for DL traffic
+ * @mhi_dev: Device associated with the channels
+ *
+ * Allocate and initialize the channel context and also issue the START channel
+ * command to both channels. Channels can be started only if both host and
+ * device execution environments match and channels are in a DISABLED state.
+ * The MHI core will automatically allocate and queue buffers for the DL traffic.
+ */
+int mhi_prepare_for_transfer_autoqueue(struct mhi_device *mhi_dev);
+
 /**
  * mhi_unprepare_from_transfer - Reset UL and DL channels for data transfer.
  *                               Issue the RESET channel command and let the
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index fa611678af05..18196e1c8c2f 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -79,7 +79,7 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	int rc;
 
 	/* start channels */
-	rc = mhi_prepare_for_transfer(mhi_dev);
+	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
 	if (rc)
 		return rc;
 
-- 
2.25.1

