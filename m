Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62B0312B44
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhBHHx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 02:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhBHHxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 02:53:17 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F76C06178A
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 23:52:37 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id u14so15960331wri.3
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 23:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D1xoggkKUYPm/up9HUqtS9Xiw3MkdDwvnq8xK4ouEnc=;
        b=I2NJxtNZUfne1OWOrl4FXMaO3nzCvzA/Xdl+V5y7Qt3obKOhVHu6NdCg8cXnmLz+HO
         Jy5VrnFIDkFlBMEW53zRUtAM6EXC+2nt8ybs/MsUJTOP06R2EGrPpvibQMx8g27BDu/h
         f+YCL5iK55dA/WDVM5k13COKz3FJgFzNlUJmE7KEqDzeSzqg4CtWjcOK+wfimo0dLvIg
         f7hBw4lWhnXv9nor6omXkP2EZE/SQG/6pLnIL2RGMU5gX/itg2q42pu7KH4S+uLRT7at
         Dw82pl8RHx34Wz37Dq/Q8mdnnJQ4w11u1CV06J5o/Y/rJSVAP/RDUCjWKb+1HI+qLbIA
         DQgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D1xoggkKUYPm/up9HUqtS9Xiw3MkdDwvnq8xK4ouEnc=;
        b=Mbpt4G/Konm9jQL0OVi3s3W+epFSkz/BGqde6WhVmdwkHo0tH2/4Owt7wOS+FyKnpD
         rTxIoWEHOhqu7J+7x3kmo3ahywKFosVs8xpP8Q2BlLrudkDOTC+4DnKvqD0yRgtO/ioL
         c+UIdsHYyiuZWpeIWdYwy6LCdtkIBA14ytWgU2gSogPQEOTJOMbMpu2V4PAR0rxbVjRL
         uPdaoa82DnQ/nSM1k62+BuWNbPS7hYgb2y7mHLd2gQwB36HUT58TANsND4b6Eu3TMl6x
         UK+kuyWrTYrwtFjT0ExqKD7rmLUghjR+KFUtUBzFI2bFyakAdRZ/6vNlCP83Ue4hU1d9
         DQgA==
X-Gm-Message-State: AOAM530fsF5QdesrB06ShqJodDwadGeo/2NnFa5pA4TUc8Z+0cCxq47D
        YIEjYLYXCDS+kDpJelzZyhm0Jgzn36qdaA==
X-Google-Smtp-Source: ABdhPJzy6kdxYozrL4r0PcuuAoUXGacphXW/mfsODTEDRawK4OsAwb9xm+QwgBne9A57kD4k6MdzsA==
X-Received: by 2002:a5d:4a4e:: with SMTP id v14mr18504130wrs.80.1612770755536;
        Sun, 07 Feb 2021 23:52:35 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:2c22:849b:ef6a:c4b9])
        by smtp.gmail.com with ESMTPSA id g16sm18784952wmi.30.2021.02.07.23.52.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Feb 2021 23:52:35 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, ivan.mikhanchuk@quectel.com,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v4 1/5] net: mhi: Add protocol support
Date:   Mon,  8 Feb 2021 09:00:33 +0100
Message-Id: <1612771237-3782-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
References: <1612771237-3782-1-git-send-email-loic.poulain@linaro.org>
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI can transport different protocols, some are handled at upper level,
like IP and QMAP(rmnet/netlink), but others will need to be inside MHI
net driver, like mbim. This change adds support for protocol rx and
tx_fixup callbacks registration, that can be used to encode/decode the
targeted protocol.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 69 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 8800991..b92c2e1 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -34,11 +34,24 @@ struct mhi_net_dev {
 	struct net_device *ndev;
 	struct sk_buff *skbagg_head;
 	struct sk_buff *skbagg_tail;
+	const struct mhi_net_proto *proto;
+	void *proto_data;
 	struct delayed_work rx_refill;
 	struct mhi_net_stats stats;
 	u32 rx_queue_sz;
 };
 
+struct mhi_net_proto {
+	int (*init)(struct mhi_net_dev *mhi_netdev);
+	struct sk_buff * (*tx_fixup)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
+	void (*rx)(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb);
+};
+
+struct mhi_device_info {
+	const char *netname;
+	const struct mhi_net_proto *proto;
+};
+
 static int mhi_ndo_open(struct net_device *ndev)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
@@ -68,26 +81,35 @@ static int mhi_ndo_stop(struct net_device *ndev)
 static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
 	struct mhi_device *mdev = mhi_netdev->mdev;
 	int err;
 
+	if (proto && proto->tx_fixup) {
+		skb = proto->tx_fixup(mhi_netdev, skb);
+		if (unlikely(!skb))
+			goto exit_drop;
+	}
+
 	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
 	if (unlikely(err)) {
 		net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
 				    ndev->name, err);
-
-		u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
-		u64_stats_inc(&mhi_netdev->stats.tx_dropped);
-		u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
-
-		/* drop the packet */
 		dev_kfree_skb_any(skb);
+		goto exit_drop;
 	}
 
 	if (mhi_queue_is_full(mdev, DMA_TO_DEVICE))
 		netif_stop_queue(ndev);
 
 	return NETDEV_TX_OK;
+
+exit_drop:
+	u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
+	u64_stats_inc(&mhi_netdev->stats.tx_dropped);
+	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
+
+	return NETDEV_TX_OK;
 }
 
 static void mhi_ndo_get_stats64(struct net_device *ndev,
@@ -164,6 +186,7 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 				struct mhi_result *mhi_res)
 {
 	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
+	const struct mhi_net_proto *proto = mhi_netdev->proto;
 	struct sk_buff *skb = mhi_res->buf_addr;
 	int free_desc_count;
 
@@ -220,7 +243,10 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 			break;
 		}
 
-		netif_rx(skb);
+		if (proto && proto->rx)
+			proto->rx(mhi_netdev, skb);
+		else
+			netif_rx(skb);
 	}
 
 	/* Refill if RX buffers queue becomes low */
@@ -302,14 +328,14 @@ static struct device_type wwan_type = {
 static int mhi_net_probe(struct mhi_device *mhi_dev,
 			 const struct mhi_device_id *id)
 {
-	const char *netname = (char *)id->driver_data;
+	const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
 	struct device *dev = &mhi_dev->dev;
 	struct mhi_net_dev *mhi_netdev;
 	struct net_device *ndev;
 	int err;
 
-	ndev = alloc_netdev(sizeof(*mhi_netdev), netname, NET_NAME_PREDICTABLE,
-			    mhi_net_setup);
+	ndev = alloc_netdev(sizeof(*mhi_netdev), info->netname,
+			    NET_NAME_PREDICTABLE, mhi_net_setup);
 	if (!ndev)
 		return -ENOMEM;
 
@@ -318,6 +344,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	mhi_netdev->ndev = ndev;
 	mhi_netdev->mdev = mhi_dev;
 	mhi_netdev->skbagg_head = NULL;
+	mhi_netdev->proto = info->proto;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 	SET_NETDEV_DEVTYPE(ndev, &wwan_type);
 
@@ -337,8 +364,16 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	if (err)
 		goto out_err;
 
+	if (mhi_netdev->proto) {
+		err = mhi_netdev->proto->init(mhi_netdev);
+		if (err)
+			goto out_err_proto;
+	}
+
 	return 0;
 
+out_err_proto:
+	unregister_netdev(ndev);
 out_err:
 	free_netdev(ndev);
 	return err;
@@ -358,9 +393,19 @@ static void mhi_net_remove(struct mhi_device *mhi_dev)
 	free_netdev(mhi_netdev->ndev);
 }
 
+static const struct mhi_device_info mhi_hwip0 = {
+	.netname = "mhi_hwip%d",
+};
+
+static const struct mhi_device_info mhi_swip0 = {
+	.netname = "mhi_swip%d",
+};
+
 static const struct mhi_device_id mhi_net_id_table[] = {
-	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)"mhi_hwip%d" },
-	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)"mhi_swip%d" },
+	/* Hardware accelerated data PATH (to modem IPA), protocol agnostic */
+	{ .chan = "IP_HW0", .driver_data = (kernel_ulong_t)&mhi_hwip0 },
+	/* Software data PATH (to modem CPU) */
+	{ .chan = "IP_SW0", .driver_data = (kernel_ulong_t)&mhi_swip0 },
 	{}
 };
 MODULE_DEVICE_TABLE(mhi, mhi_net_id_table);
-- 
2.7.4

