Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EBA476BA0
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhLPINd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbhLPINc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 03:13:32 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE05C06173F
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:31 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so21918031pjb.1
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XISBkJ9Crd6jiFe2nR3x45N/LGif0AtQioDOU5UAxUw=;
        b=dzCg6eOZJ8u+crYspN4cNSeNmLfBCQ0LxLtycnczCIwcEEvRoepJIoqsjWRYmq92EW
         bvCSl92ZWVpgg30vsB3ZToW73W0mu3vvBOkHUxv3zk7Uh5XQmaw4uLM70CWnu8buGYne
         vJOrjLIlMHl3r2pdYl9AKJ6N2QmDhMtXHR3RIA1DDTijJXh/4M+pDkFCcRxp1k1tOYGq
         7MYtjX21Doowg6F32vd/XjwP06PtTi2/20tOVgl87rtnuuiVzwcjbDJfbzgceNMnn3j5
         Yje+2H1W/CiNTXyXyxaevdZHGVNK7lS+0KxP/DxZFA8R1czpnNpwi2bajcDWvpqIm6Du
         7vKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XISBkJ9Crd6jiFe2nR3x45N/LGif0AtQioDOU5UAxUw=;
        b=1hJiNCnmqM8TRb93MuJ4HHCCYXXFDpdbq9+OVINW3Amd2nHHAgmm9GmJQFLC+bUyUQ
         fajDT/zg59KEy6xQwrHKsJHkaG7X/951068aGGWbBb0HCN3IroY1WgIw7oRWVCY8vGVZ
         j0ri0X4+XyeQjzeFMFuRfrX+T+5FlgxdJb3R55xGqoydailf3Wdnxh7MRr2v3Lqgv61w
         dkNMNYefbWnnQFojeYgrcmEEccJjih5f62B/feNW0sG6w+LqQfYhkM53RkyNMlc31ZUO
         iH+eayIaGOtUZ9KCGYmTA3kSwuTylOI4QbV/4GfInXcDsRwnHkKxB9WxdoD4MpOr0zXI
         YpfA==
X-Gm-Message-State: AOAM530Qf6pHtbDZ8d/Cf2BMyHxEMKFnMRuZrD0/jq9meyYMl2SeAvt1
        Z+AIRure08Pz7zAPlHXWHHqR
X-Google-Smtp-Source: ABdhPJyasEMKerkEr5YAA2ScuzdIAwjjnOuU/VubXO2lYKkr8h1yx6eSqE86eQ9xoMocFZQxYkbb3Q==
X-Received: by 2002:a17:90a:3d41:: with SMTP id o1mr4602336pjf.215.1639642411340;
        Thu, 16 Dec 2021 00:13:31 -0800 (PST)
Received: from localhost.localdomain ([117.193.208.121])
        by smtp.gmail.com with ESMTPSA id u38sm326835pfg.4.2021.12.16.00.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:13:30 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, thomas.perrot@bootlin.com,
        aleksander@aleksander.es, slark_xiao@163.com,
        christophe.jaillet@wanadoo.fr, keescook@chromium.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 08/10] bus: mhi: core: Add an API for auto queueing buffers for DL channel
Date:   Thu, 16 Dec 2021 13:42:25 +0530
Message-Id: <20211216081227.237749-9-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
References: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
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
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Co-developed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/internal.h |  6 +++++-
 drivers/bus/mhi/core/main.c     | 21 +++++++++++++++++----
 include/linux/mhi.h             | 21 ++++++++++++++++-----
 net/qrtr/mhi.c                  |  2 +-
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
index 9d72b1d1e986..e2e10474a9d9 100644
--- a/drivers/bus/mhi/core/internal.h
+++ b/drivers/bus/mhi/core/internal.h
@@ -682,8 +682,12 @@ void mhi_deinit_free_irq(struct mhi_controller *mhi_cntrl);
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
index 930aba666b67..ffde617f93a3 100644
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
@@ -1610,8 +1613,7 @@ void mhi_reset_chan(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan)
 	read_unlock_bh(&mhi_cntrl->pm_lock);
 }
 
-/* Move channel to start state */
-int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
+static int __mhi_prepare_for_transfer(struct mhi_device *mhi_dev, unsigned int flags)
 {
 	int ret, dir;
 	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
@@ -1622,7 +1624,7 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
 		if (!mhi_chan)
 			continue;
 
-		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan);
+		ret = mhi_prepare_channel(mhi_cntrl, mhi_chan, flags);
 		if (ret)
 			goto error_open_chan;
 	}
@@ -1640,8 +1642,19 @@ int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
 
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

