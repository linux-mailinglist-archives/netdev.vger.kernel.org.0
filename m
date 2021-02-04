Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741DB30FAF9
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbhBDSMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238846AbhBDSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:10:43 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD79C061788
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:10:03 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m1so3819493wml.2
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D1xoggkKUYPm/up9HUqtS9Xiw3MkdDwvnq8xK4ouEnc=;
        b=LTIc3u6c3DZDhhChstnwspg8FIR9Po9sRU9pZFQwA3omWkQrHG3MDZqIJ1QaDnSzmX
         szdoQOyPmGKTK+GUvhs6HEUpyZNryCWxC/I6etoP1WhemeOlfCWoJCbAMK2eH9aRCyCL
         cctCTtTm+3bqT0pE09ekflQsMA5L27vG4u/cAuXteNbAZKV0DWnTeXkVvJ/mQkHtBQkm
         3CNMCeWYjtpS93XiGklxWcHM0iBWZgD2uF6ARq74wb8d42n8Ve5ggQepuSNzDxG0m96y
         Jor92YIZXk+Ip08lF7ius8oI9i1M6c/ZwuIhIddPY6qccepzfgBybleCcYTPPpu5dMqD
         0g7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D1xoggkKUYPm/up9HUqtS9Xiw3MkdDwvnq8xK4ouEnc=;
        b=Xlt+WH0D0NqOpNGUAZFxZzKsYfw0WN1rt0zn2ZfON/iDNh6bZm1XcV8A5yVzQILnX3
         D7LtZQorlyEsGsipYCKO189IdhUF8KZVco2hemmac6T2cTO59iDD7wH6xHb26BARw5Lx
         LlwwQZi+lClz6nzUbAtuqTrYS81I6L0K5y5SmtYUYymqvc2eDZJVzmGwj/ZInW53VrAA
         yEjDgAdKlyE7xTBzj+a/33ZYcU3LQJwwpQQLpSyTxfqY+7AGqiOJi6WLN91fbPYQ/zaj
         gsHNI5A5oq3xlJ2OUQac4o8cVg9dc6eYGlhhrQT4b0hvjskUqXLBETvo+mZuxCdtgrUw
         826A==
X-Gm-Message-State: AOAM531pG8iQvIWAPpYcLbtXraPUe26sCVS2JEOUZSRNgXeEr2eI/gD4
        AgZVvOuO0eeP54IEAcg6OUZY+A==
X-Google-Smtp-Source: ABdhPJwCxKcKsWJwxzmNMvSPa0O20WH0Qf7jzxEl4WUhN2JewZ0lyiCq8VK+2AaV1epn5wJwXVLcDw==
X-Received: by 2002:a1c:2d48:: with SMTP id t69mr366927wmt.124.1612462201837;
        Thu, 04 Feb 2021 10:10:01 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id m6sm6313746wmq.13.2021.02.04.10.10.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 10:10:01 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bjorn@mork.no, dcbw@redhat.com,
        carl.yin@quectel.com, mpearson@lenovo.com, cchen50@lenovo.com,
        jwjiang@lenovo.com, ivan.zhang@quectel.com,
        naveen.kumar@quectel.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 1/5] net: mhi: Add protocol support
Date:   Thu,  4 Feb 2021 19:17:37 +0100
Message-Id: <1612462661-23045-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
References: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
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

