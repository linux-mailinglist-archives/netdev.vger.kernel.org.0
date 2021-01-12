Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066992F3AE2
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436620AbhALTnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436615AbhALTnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:43:17 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6243AC0617AA
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:42:02 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id m4so2384699wrx.9
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=95fcQ7XOzwxPXY92PHMXKGjY9iDFTd+3y3erYQ9GO9s=;
        b=1tCRinMHamPfSeGT7m65Y3aJyKfckJHdtuiPmHaE4Z5fAN3CngoISCY+eCrh3zIQAv
         EGhkjV84NQPvJCJxVOwNd9CE0wSnFoOAftnadDX8xYXaBW7qtglM9h/6WoA8pAgW+nL6
         4m82MlTv/1REnteWu+i3oDfcivx2yXiBbLVQWzMi+Tcckw3PucDqFLBtRMqasUzDWGmC
         Sab3HyYsjdlZjK/iK3QQ6jEyOIcH0Klo4LqQ2m33gvyaXOOJMwsc5ulFxyUXulZD4eRp
         /4MJfbr5A2VW61mdnl9hQIzqkj44NmcfjRN0ccLFjp1aO5yzGHEm11Np5MWflBTL9Wtv
         SGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=95fcQ7XOzwxPXY92PHMXKGjY9iDFTd+3y3erYQ9GO9s=;
        b=oMNZfk6PbPwIcthEzc+bu0zd3caFzmsMiNfKLLfleWhY225XSRpmOYxiccBUUstejr
         Kbiucqh/WsQbQ41hbnErHU7KfNQ8TbVMrNZEMjI9AuOxZ5J/OOgWCuQZCp11uitZ3/Mw
         udZoiLr6xnYtY3/3V9LPL51ju/EVPlbPIBTObpUNPb0eQdagYm+q1QP/qtC+fR10/9JP
         oT7NAgR9qzdwK/OPwYFgngUTjtzG1XXivRZqYhZ3CUK+GIuXul3zwQWQNqiNqaM35axG
         puXE3K7Ujwpbp59cl3nYJLeGhAcPjO658TW0c4NjKYKv+gLE03J1UtGz90XR+LAkqFsL
         R+2A==
X-Gm-Message-State: AOAM5300X7QsOJqzOtzR0OgzcYi9Ia6gWgQpc6KY9mkQzBZdNWo66xWw
        F1OtmtsoZXSbGAsls/DrB7v6MQ==
X-Google-Smtp-Source: ABdhPJwozaYVSn8b891ub9ZvGIip49TMHv9Wa+1fM6bn8ZY9QZR52VX9j+xhhl/b0ZukWBXo7jRRLw==
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr446833wrz.86.1610480521047;
        Tue, 12 Jan 2021 11:42:01 -0800 (PST)
Received: from f2.redhat.com (bzq-79-183-72-147.red.bezeqint.net. [79.183.72.147])
        by smtp.gmail.com with ESMTPSA id z63sm4885315wme.8.2021.01.12.11.41.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Jan 2021 11:42:00 -0800 (PST)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        rdunlap@infradead.org, willemb@google.com, gustavoars@kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        nogikh@google.com, pablo@netfilter.org, decui@microsoft.com,
        cai@lca.pw, jakub@cloudflare.com, elver@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Cc:     yan@daynix.com
Subject: [RFC PATCH 2/7] vhost: support for hash report virtio-net feature
Date:   Tue, 12 Jan 2021 21:41:38 +0200
Message-Id: <20210112194143.1494-3-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112194143.1494-1-yuri.benditovich@daynix.com>
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the virtio specification if VIRTIO_NET_F_HASH_REPORT
feature acked the virtio-net header is extended to hold the hash
value and hash report type.

Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
---
 drivers/vhost/net.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 531a00d703cd..31a894b9a992 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -73,7 +73,8 @@ enum {
 	VHOST_NET_FEATURES = VHOST_FEATURES |
 			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
 			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
-			 (1ULL << VIRTIO_F_ACCESS_PLATFORM)
+			 (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
+			 (1ULL << VIRTIO_NET_F_HASH_REPORT)
 };
 
 enum {
@@ -1108,14 +1109,16 @@ static void handle_rx(struct vhost_net *net)
 		.msg_controllen = 0,
 		.msg_flags = MSG_DONTWAIT,
 	};
-	struct virtio_net_hdr hdr = {
-		.flags = 0,
-		.gso_type = VIRTIO_NET_HDR_GSO_NONE
+	struct virtio_net_hdr_v1_hash hdrv1 = {
+		{
+			.flags = 0,
+			.gso_type = VIRTIO_NET_HDR_GSO_NONE
+		}
 	};
 	size_t total_len = 0;
 	int err, mergeable;
 	s16 headcount;
-	size_t vhost_hlen, sock_hlen;
+	size_t vhost_hlen, sock_hlen, extra_hlen;
 	size_t vhost_len, sock_len;
 	bool busyloop_intr = false;
 	struct socket *sock;
@@ -1137,9 +1140,12 @@ static void handle_rx(struct vhost_net *net)
 	vhost_hlen = nvq->vhost_hlen;
 	sock_hlen = nvq->sock_hlen;
 
+
 	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
 		vq->log : NULL;
 	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
+	extra_hlen = vhost_has_feature(vq, VIRTIO_NET_F_HASH_REPORT) ?
+		sizeof(hdrv1) - sizeof(hdrv1.hdr) : 0;
 
 	do {
 		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
@@ -1201,8 +1207,8 @@ static void handle_rx(struct vhost_net *net)
 		}
 		/* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
 		if (unlikely(vhost_hlen)) {
-			if (copy_to_iter(&hdr, sizeof(hdr),
-					 &fixup) != sizeof(hdr)) {
+			if (copy_to_iter(&hdrv1, sizeof(struct virtio_net_hdr),
+					 &fixup) != sizeof(struct virtio_net_hdr)) {
 				vq_err(vq, "Unable to write vnet_hdr "
 				       "at addr %p\n", vq->iov->iov_base);
 				goto out;
@@ -1211,7 +1217,7 @@ static void handle_rx(struct vhost_net *net)
 			/* Header came from socket; we'll need to patch
 			 * ->num_buffers over if VIRTIO_NET_F_MRG_RXBUF
 			 */
-			iov_iter_advance(&fixup, sizeof(hdr));
+			iov_iter_advance(&fixup, sizeof(struct virtio_net_hdr));
 		}
 		/* TODO: Should check and handle checksum. */
 
@@ -1223,6 +1229,18 @@ static void handle_rx(struct vhost_net *net)
 			vhost_discard_vq_desc(vq, headcount);
 			goto out;
 		}
+		if (unlikely(extra_hlen)) {
+			if (unlikely(vhost_hlen)) {
+				if (copy_to_iter(&hdrv1.hash_value, extra_hlen,
+						&fixup) != extra_hlen) {
+					vq_err(vq, "Unable to write extra_hdr "
+					"at addr %p\n", vq->iov->iov_base);
+					goto out;
+				}
+			} else {
+				iov_iter_advance(&fixup, extra_hlen);
+			}
+		}
 		nvq->done_idx += headcount;
 		if (nvq->done_idx > VHOST_NET_BATCH)
 			vhost_net_signal_used(nvq);
@@ -1624,6 +1642,9 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 			       (1ULL << VIRTIO_F_VERSION_1))) ?
 			sizeof(struct virtio_net_hdr_mrg_rxbuf) :
 			sizeof(struct virtio_net_hdr);
+	if (features & (1ULL << VIRTIO_NET_F_HASH_REPORT)) {
+		hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
+	}
 	if (features & (1 << VHOST_NET_F_VIRTIO_NET_HDR)) {
 		/* vhost provides vnet_hdr */
 		vhost_hlen = hdr_len;
-- 
2.17.1

