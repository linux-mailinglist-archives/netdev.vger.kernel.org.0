Return-Path: <netdev+bounces-10198-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B802C72CC69
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 720D4281193
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD0721CFB;
	Mon, 12 Jun 2023 17:23:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF57722D5A
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:23:19 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E52B2
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:17 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-65592a7cb54so4544131b3a.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686590597; x=1689182597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oDuv+g/0XRvJo0yG4qkvO5UlPZUnGZfMWyMTGOYfexg=;
        b=2K3cU329VMyFIb3jm2NC1xMwCoV2p3eCj99k6BZoAsFQrOfokA5YcXp2v7ocWEYoEl
         lUQF2jKvE6TPLRun9eXJDCg0ehSxuyMu3DGCRDNtgURj3w2Ep6OU31amOgGSwYhrOX52
         FeiX1Bf42TrsOSeKlyTE8XTB+QWabKcMcAMQIVLp4oZA9lGnT5edv84OqLxV2jTJGqYW
         wexUVL7n/xzWWTzRkxVvUNCDmBEhn60i2ysfjgSvLh1JlEfoTuKAVu4N5mKEmGLCXgvd
         W8x6kvqZLNLVdQvvac92GZTt5nxmpBycZZL6YmhvoK+ifF2oLu3pVhBfpicxuEvb/4/0
         LLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686590597; x=1689182597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDuv+g/0XRvJo0yG4qkvO5UlPZUnGZfMWyMTGOYfexg=;
        b=ljxWMPtaC9stJvZjQX2pCKOPR0vPvKX9NaeopRz5D7Zzzf6KnCgnXfnjqKmNRBXhs2
         Cu0fbzK4d0TE+Y/TxBiVWHNiFqwHvAXgfNxLl0dAhXOO+hSAi5Cr/0YFHhUAt0uMpTFK
         33VjvK5KuMjWhdhIj05M97f4RgmgRWFyArY/wBNUM9uHLXldjrNFu59vOy/0+bClG3ao
         SJdSDRKR00ATH8cM2nWAwj7KHW/8GeDQY92QixfG1uTaqoVojsDnWAIGpSlScvNCeL3Q
         Gh+Gz8toXExHOrRpPEz7uaFB/VL0KmZRZu1FLLmnQdxYH4FzqlI6gcuMgVyzyahXNQQV
         1G4w==
X-Gm-Message-State: AC+VfDx7Ezcbwa2b5Qk/1SRUC7kkjJD7Jc5/KSDA8IR1lj9yTzqAm5Ec
	HWEXSMkG+t7TpROyDIRse9PmN0c=
X-Google-Smtp-Source: ACHHUZ6oj9zIPCtyBLcuQ6c6H2lhHZgxEY+zCP6QyTdZNpxSiXXcWElW3XWanZwS51/DQOOrLzvVvqY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2353:b0:653:9883:40ec with SMTP id
 j19-20020a056a00235300b00653988340ecmr3037128pfj.5.1686590597062; Mon, 12 Jun
 2023 10:23:17 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:23:05 -0700
In-Reply-To: <20230612172307.3923165-1-sdf@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230612172307.3923165-6-sdf@google.com>
Subject: [RFC bpf-next 5/7] net: veth: implement devtx timestamp kfuncs
From: Stanislav Fomichev <sdf@google.com>
To: bpf@vger.kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Have a software-base example for kfuncs to showcase how it
can be used in the real devices and to have something to
test against in the selftests.

Both path (skb & xdp) are covered. Only the skb path is really
tested though.

Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/veth.c | 94 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 614f3e3efab0..eb78d51d8352 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -27,6 +27,7 @@
 #include <linux/bpf_trace.h>
 #include <linux/net_tstamp.h>
 #include <net/page_pool.h>
+#include <net/devtx.h>
 
 #define DRV_NAME	"veth"
 #define DRV_VERSION	"1.0"
@@ -123,6 +124,13 @@ struct veth_xdp_buff {
 	struct sk_buff *skb;
 };
 
+struct veth_devtx_frame {
+	struct devtx_frame frame;
+	bool request_timestamp;
+	ktime_t xdp_tx_timestamp;
+	struct sk_buff *skb;
+};
+
 static int veth_get_link_ksettings(struct net_device *dev,
 				   struct ethtool_link_ksettings *cmd)
 {
@@ -314,9 +322,29 @@ static int veth_xdp_rx(struct veth_rq *rq, struct sk_buff *skb)
 }
 
 static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
-			    struct veth_rq *rq, bool xdp)
+			    struct veth_rq *rq, bool xdp, bool request_timestamp)
 {
-	return __dev_forward_skb(dev, skb) ?: xdp ?
+	struct net_device *src_dev = skb->dev;
+	int ret;
+
+	ret = __dev_forward_skb(dev, skb);
+	if (ret)
+		return ret;
+
+	if (devtx_complete_enabled(src_dev)) {
+		struct veth_devtx_frame ctx;
+
+		if (unlikely(request_timestamp))
+			__net_timestamp(skb);
+
+		devtx_frame_from_skb(&ctx.frame, skb);
+		ctx.frame.data -= ETH_HLEN; /* undo eth_type_trans pull */
+		ctx.frame.len += ETH_HLEN;
+		ctx.skb = skb;
+		devtx_complete(src_dev, &ctx.frame);
+	}
+
+	return xdp ?
 		veth_xdp_rx(rq, skb) :
 		__netif_rx(skb);
 }
@@ -343,6 +371,7 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
+	bool request_timestamp = false;
 	struct veth_rq *rq = NULL;
 	struct net_device *rcv;
 	int length = skb->len;
@@ -356,6 +385,15 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 	}
 
+	if (devtx_submit_enabled(dev)) {
+		struct veth_devtx_frame ctx;
+
+		devtx_frame_from_skb(&ctx.frame, skb);
+		ctx.request_timestamp = false;
+		devtx_submit(dev, &ctx.frame);
+		request_timestamp = ctx.request_timestamp;
+	}
+
 	rcv_priv = netdev_priv(rcv);
 	rxq = skb_get_queue_mapping(skb);
 	if (rxq < rcv->real_num_rx_queues) {
@@ -370,7 +408,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	skb_tx_timestamp(skb);
-	if (likely(veth_forward_skb(rcv, skb, rq, use_napi) == NET_RX_SUCCESS)) {
+	if (likely(veth_forward_skb(rcv, skb, rq, use_napi, request_timestamp) == NET_RX_SUCCESS)) {
 		if (!use_napi)
 			dev_lstats_add(dev, length);
 	} else {
@@ -483,6 +521,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
 	int i, ret = -ENXIO, nxmit = 0;
+	ktime_t tx_timestamp = 0;
 	struct net_device *rcv;
 	unsigned int max_len;
 	struct veth_rq *rq;
@@ -511,9 +550,32 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 		void *ptr = veth_xdp_to_ptr(frame);
 
 		if (unlikely(xdp_get_frame_len(frame) > max_len ||
-			     __ptr_ring_produce(&rq->xdp_ring, ptr)))
+			     __ptr_ring_full(&rq->xdp_ring)))
+			break;
+
+		if (devtx_submit_enabled(dev)) {
+			struct veth_devtx_frame ctx;
+
+			devtx_frame_from_xdp(&ctx.frame, frame);
+			ctx.request_timestamp = false;
+			devtx_submit(dev, &ctx.frame);
+
+			if (unlikely(ctx.request_timestamp))
+				tx_timestamp = ktime_get_real();
+		}
+
+		if (unlikely(__ptr_ring_produce(&rq->xdp_ring, ptr)))
 			break;
 		nxmit++;
+
+		if (devtx_complete_enabled(dev)) {
+			struct veth_devtx_frame ctx;
+
+			devtx_frame_from_xdp(&ctx.frame, frame);
+			ctx.xdp_tx_timestamp = tx_timestamp;
+			ctx.skb = NULL;
+			devtx_complete(dev, &ctx.frame);
+		}
 	}
 	spin_unlock(&rq->xdp_ring.producer_lock);
 
@@ -1732,6 +1794,28 @@ static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
 	return 0;
 }
 
+static int veth_devtx_sb_request_timestamp(const struct devtx_frame *_ctx)
+{
+	struct veth_devtx_frame *ctx = (struct veth_devtx_frame *)_ctx;
+
+	ctx->request_timestamp = true;
+
+	return 0;
+}
+
+static int veth_devtx_cp_timestamp(const struct devtx_frame *_ctx, u64 *timestamp)
+{
+	struct veth_devtx_frame *ctx = (struct veth_devtx_frame *)_ctx;
+
+	if (ctx->skb) {
+		*timestamp = ctx->skb->tstamp;
+		return 0;
+	}
+
+	*timestamp = ctx->xdp_tx_timestamp;
+	return 0;
+}
+
 static const struct net_device_ops veth_netdev_ops = {
 	.ndo_init            = veth_dev_init,
 	.ndo_open            = veth_open,
@@ -1756,6 +1840,8 @@ static const struct net_device_ops veth_netdev_ops = {
 static const struct xdp_metadata_ops veth_xdp_metadata_ops = {
 	.xmo_rx_timestamp		= veth_xdp_rx_timestamp,
 	.xmo_rx_hash			= veth_xdp_rx_hash,
+	.xmo_sb_request_timestamp	= veth_devtx_sb_request_timestamp,
+	.xmo_cp_timestamp		= veth_devtx_cp_timestamp,
 };
 
 #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
-- 
2.41.0.162.gfafddb0af9-goog


