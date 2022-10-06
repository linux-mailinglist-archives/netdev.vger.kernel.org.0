Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3935C5F5E5A
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 03:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJFBUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 21:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJFBUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 21:20:15 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CA712A8C;
        Wed,  5 Oct 2022 18:20:11 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id u28so214075qku.2;
        Wed, 05 Oct 2022 18:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=pSxcATDaN6aZDosI7dvlr8bHqcn5nPGoNRdPZ0UE/sE=;
        b=LCCA8W3lfaJPsyJvKVpoFh6okAPTDxEsr5JzMwFAh0LL4oxbFMtmRJ3zCALiZ7wBce
         yw3XgvLZvlilGxZ7/v9pp2kqnkyIagiMWIyxfDOGWJVYVHPmufwZm5WfQ2EzqEG5Fj6i
         gkKZJ1i1iF5SMxhNjfUoQ7TfVQjxO0K3rbhcykHdWbiZ3miGfiGFnNBrE7HH4PjsFhDz
         wYuUmoVI5b/UJFs8j8/J4HEVZhulDhTQVHSTnE5XDqKhDmGo9IVnfmRnMlzmjlq/C6je
         OzT3QgRlj3s+AqTX81DyXvsnWcGGIvfJ+QnlhJhPP7EbHfFkNM0a66wxzjBzJvYnE+C1
         zysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSxcATDaN6aZDosI7dvlr8bHqcn5nPGoNRdPZ0UE/sE=;
        b=HcBW8bMIFlWJ81VA4g5P5SwGWvZ8j/X0AJREWkcjaufweTzpeFiK8WJPPdv2DftL6d
         DUcoDY5X8H8+GeNM8749nMGLs5HSTEYWicLU0lh+kT0QPgSkT7qx+v29Ii0LtsjPjxZd
         dfW1dynTuk0LANYc4Ww/3nilpx2HqUBfWsV3bAa5aobcGhAT8X2DZtK+rxlIjXDclzh6
         CVwykfbcnOI+Ee9uVoUoZi8shnXm7S7Hltzx/ygvlyG6jFMBnv5Z8iUrGQoNCoGEn9pH
         IIwu1vgmvaQG0OxPEVvM+DsWw87Tx+M+FKnb2k3kHO9Ns4jy9eIvYjIcpFqnBx6ZFhbt
         LZgQ==
X-Gm-Message-State: ACrzQf2sPIIy7xSpA9sQODe+tuK+7rP9V2gN71n1v//IyJhFsKK2xaRW
        i/Pg3E2LWNDri9NWN68RCUs/d8hndbE7DOkdD7s=
X-Google-Smtp-Source: AMsMyM6Ro+lOwzWMuJzz+J8L8JSmVDxVxMM2/DOJgAIKb5CI3IsLvHEzmVPzm/iHR3TfzAVsY+t5Sw==
X-Received: by 2002:a05:620a:20dd:b0:6ce:bc87:a3c3 with SMTP id f29-20020a05620a20dd00b006cebc87a3c3mr1714922qka.336.1665019210035;
        Wed, 05 Oct 2022 18:20:10 -0700 (PDT)
Received: from C02G8BMUMD6R.bytedance.net (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id q34-20020a05620a2a6200b006b8d1914504sm18630622qkp.22.2022.10.05.18.20.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 18:20:09 -0700 (PDT)
Sender: Bobby Eshleman <bobbyeshleman@gmail.com>
From:   Bobby Eshleman <bobby.eshleman@gmail.com>
X-Google-Original-From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] vsock: replace virtio_vsock_pkt with sk_buff
Date:   Wed,  5 Oct 2022 18:19:44 -0700
Message-Id: <20221006011946.85130-1-bobby.eshleman@bytedance.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the struct virtio_vsock_pkt with struct sk_buff.

Using sk_buff in vsock benefits it by a) allowing vsock to be extended
for socket-related features like sockmap, b) vsock may in the future
use other sk_buff-dependent kernel capabilities, and c) vsock shares
commonality with other socket types.

This patch is taken from the original series found here:
https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/

Small-sized packet throughput improved by ~5% (from 18.53 Mb/s to 19.51
Mb/s). Tested using uperf, 16B payloads, 64 threads, 100s, averaged from
10 test runs (n=10). This improvement is likely due to packet merging.

Large-sized packet throughput decreases ~9% (from 27.25 Gb/s to 25.04
Gb/s). Tested using uperf, 64KB payloads, 64 threads, 100s, averaged
from 10 test runs (n=10).

Medium-sized packet throughput decreases ~5% (from 4.0 Gb/s to 3.81
Gb/s). Tested using uperf, 4k to 8k payload sizes picked randomly
according to normal distribution, 64 threads, 100s, averaged from 10
test runs (n=10).

All tests done in nested VMs (virtual host and virtual guest).

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
Changes in v2:
- Use alloc_skb() directly instead of sock_alloc_send_pskb() to minimize
  uAPI changes.
- Do not marshal errors to -ENOMEM for non-virtio implementations.
- No longer a part of the original series
- Some code cleanup and refactoring
- Include performance stats

 drivers/vhost/vsock.c                   | 215 +++++------
 include/linux/virtio_vsock.h            |  64 +++-
 net/vmw_vsock/af_vsock.c                |   1 +
 net/vmw_vsock/virtio_transport.c        | 206 +++++-----
 net/vmw_vsock/virtio_transport_common.c | 483 ++++++++++++------------
 net/vmw_vsock/vsock_loopback.c          |  51 +--
 6 files changed, 504 insertions(+), 516 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 368330417bde..6179e637602f 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -51,8 +51,7 @@ struct vhost_vsock {
 	struct hlist_node hash;
 
 	struct vhost_work send_pkt_work;
-	spinlock_t send_pkt_list_lock;
-	struct list_head send_pkt_list;	/* host->guest pending packets */
+	struct sk_buff_head send_pkt_queue; /* host->guest pending packets */
 
 	atomic_t queued_replies;
 
@@ -108,7 +107,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 	vhost_disable_notify(&vsock->dev, vq);
 
 	do {
-		struct virtio_vsock_pkt *pkt;
+		struct sk_buff *skb;
+		struct virtio_vsock_hdr *hdr;
 		struct iov_iter iov_iter;
 		unsigned out, in;
 		size_t nbytes;
@@ -116,31 +116,22 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		int head;
 		u32 flags_to_restore = 0;
 
-		spin_lock_bh(&vsock->send_pkt_list_lock);
-		if (list_empty(&vsock->send_pkt_list)) {
-			spin_unlock_bh(&vsock->send_pkt_list_lock);
+		skb = skb_dequeue(&vsock->send_pkt_queue);
+
+		if (!skb) {
 			vhost_enable_notify(&vsock->dev, vq);
 			break;
 		}
 
-		pkt = list_first_entry(&vsock->send_pkt_list,
-				       struct virtio_vsock_pkt, list);
-		list_del_init(&pkt->list);
-		spin_unlock_bh(&vsock->send_pkt_list_lock);
-
 		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
 					 &out, &in, NULL, NULL);
 		if (head < 0) {
-			spin_lock_bh(&vsock->send_pkt_list_lock);
-			list_add(&pkt->list, &vsock->send_pkt_list);
-			spin_unlock_bh(&vsock->send_pkt_list_lock);
+			skb_queue_head(&vsock->send_pkt_queue, skb);
 			break;
 		}
 
 		if (head == vq->num) {
-			spin_lock_bh(&vsock->send_pkt_list_lock);
-			list_add(&pkt->list, &vsock->send_pkt_list);
-			spin_unlock_bh(&vsock->send_pkt_list_lock);
+			skb_queue_head(&vsock->send_pkt_queue, skb);
 
 			/* We cannot finish yet if more buffers snuck in while
 			 * re-enabling notify.
@@ -153,26 +144,27 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		}
 
 		if (out) {
-			virtio_transport_free_pkt(pkt);
+			kfree_skb(skb);
 			vq_err(vq, "Expected 0 output buffers, got %u\n", out);
 			break;
 		}
 
 		iov_len = iov_length(&vq->iov[out], in);
-		if (iov_len < sizeof(pkt->hdr)) {
-			virtio_transport_free_pkt(pkt);
+		if (iov_len < sizeof(*hdr)) {
+			kfree_skb(skb);
 			vq_err(vq, "Buffer len [%zu] too small\n", iov_len);
 			break;
 		}
 
 		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, iov_len);
-		payload_len = pkt->len - pkt->off;
+		payload_len = skb->len - vsock_metadata(skb)->off;
+		hdr = vsock_hdr(skb);
 
 		/* If the packet is greater than the space available in the
 		 * buffer, we split it using multiple buffers.
 		 */
-		if (payload_len > iov_len - sizeof(pkt->hdr)) {
-			payload_len = iov_len - sizeof(pkt->hdr);
+		if (payload_len > iov_len - sizeof(*hdr)) {
+			payload_len = iov_len - sizeof(*hdr);
 
 			/* As we are copying pieces of large packet's buffer to
 			 * small rx buffers, headers of packets in rx queue are
@@ -185,31 +177,31 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			 * bits set. After initialized header will be copied to
 			 * rx buffer, these required bits will be restored.
 			 */
-			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
-				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+			if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) {
+				hdr->flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
 				flags_to_restore |= VIRTIO_VSOCK_SEQ_EOM;
 
-				if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
-					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+				if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOR) {
+					hdr->flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
 					flags_to_restore |= VIRTIO_VSOCK_SEQ_EOR;
 				}
 			}
 		}
 
 		/* Set the correct length in the header */
-		pkt->hdr.len = cpu_to_le32(payload_len);
+		hdr->len = cpu_to_le32(payload_len);
 
-		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
-		if (nbytes != sizeof(pkt->hdr)) {
-			virtio_transport_free_pkt(pkt);
+		nbytes = copy_to_iter(hdr, sizeof(*hdr), &iov_iter);
+		if (nbytes != sizeof(*hdr)) {
+			kfree_skb(skb);
 			vq_err(vq, "Faulted on copying pkt hdr\n");
 			break;
 		}
 
-		nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
+		nbytes = copy_to_iter(skb->data + vsock_metadata(skb)->off, payload_len,
 				      &iov_iter);
 		if (nbytes != payload_len) {
-			virtio_transport_free_pkt(pkt);
+			kfree_skb(skb);
 			vq_err(vq, "Faulted on copying pkt buf\n");
 			break;
 		}
@@ -217,31 +209,28 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		/* Deliver to monitoring devices all packets that we
 		 * will transmit.
 		 */
-		virtio_transport_deliver_tap_pkt(pkt);
+		virtio_transport_deliver_tap_pkt(skb);
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
+		vhost_add_used(vq, head, sizeof(*hdr) + payload_len);
 		added = true;
 
-		pkt->off += payload_len;
+		vsock_metadata(skb)->off += payload_len;
 		total_len += payload_len;
 
 		/* If we didn't send all the payload we can requeue the packet
 		 * to send it with the next available buffer.
 		 */
-		if (pkt->off < pkt->len) {
-			pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
+		if (vsock_metadata(skb)->off < skb->len) {
+			hdr->flags |= cpu_to_le32(flags_to_restore);
 
-			/* We are queueing the same virtio_vsock_pkt to handle
+			/* We are queueing the same skb to handle
 			 * the remaining bytes, and we want to deliver it
 			 * to monitoring devices in the next iteration.
 			 */
-			pkt->tap_delivered = false;
-
-			spin_lock_bh(&vsock->send_pkt_list_lock);
-			list_add(&pkt->list, &vsock->send_pkt_list);
-			spin_unlock_bh(&vsock->send_pkt_list_lock);
+			vsock_metadata(skb)->flags &= ~VIRTIO_VSOCK_METADATA_FLAGS_TAP_DELIVERED;
+			skb_queue_head(&vsock->send_pkt_queue, skb);
 		} else {
-			if (pkt->reply) {
+			if (vsock_metadata(skb)->flags & VIRTIO_VSOCK_METADATA_FLAGS_REPLY) {
 				int val;
 
 				val = atomic_dec_return(&vsock->queued_replies);
@@ -253,7 +242,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 					restart_tx = true;
 			}
 
-			virtio_transport_free_pkt(pkt);
+			consume_skb(skb);
 		}
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 	if (added)
@@ -278,28 +267,26 @@ static void vhost_transport_send_pkt_work(struct vhost_work *work)
 }
 
 static int
-vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
+vhost_transport_send_pkt(struct sk_buff *skb)
 {
 	struct vhost_vsock *vsock;
-	int len = pkt->len;
+	int len = skb->len;
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 
 	rcu_read_lock();
 
 	/* Find the vhost_vsock according to guest context id  */
-	vsock = vhost_vsock_get(le64_to_cpu(pkt->hdr.dst_cid));
+	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid));
 	if (!vsock) {
 		rcu_read_unlock();
-		virtio_transport_free_pkt(pkt);
+		kfree_skb(skb);
 		return -ENODEV;
 	}
 
-	if (pkt->reply)
+	if (vsock_metadata(skb)->flags & VIRTIO_VSOCK_METADATA_FLAGS_REPLY)
 		atomic_inc(&vsock->queued_replies);
 
-	spin_lock_bh(&vsock->send_pkt_list_lock);
-	list_add_tail(&pkt->list, &vsock->send_pkt_list);
-	spin_unlock_bh(&vsock->send_pkt_list_lock);
-
+	skb_queue_tail(&vsock->send_pkt_queue, skb);
 	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
 
 	rcu_read_unlock();
@@ -310,10 +297,8 @@ static int
 vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct vhost_vsock *vsock;
-	struct virtio_vsock_pkt *pkt, *n;
 	int cnt = 0;
 	int ret = -ENODEV;
-	LIST_HEAD(freeme);
 
 	rcu_read_lock();
 
@@ -322,20 +307,7 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 	if (!vsock)
 		goto out;
 
-	spin_lock_bh(&vsock->send_pkt_list_lock);
-	list_for_each_entry_safe(pkt, n, &vsock->send_pkt_list, list) {
-		if (pkt->vsk != vsk)
-			continue;
-		list_move(&pkt->list, &freeme);
-	}
-	spin_unlock_bh(&vsock->send_pkt_list_lock);
-
-	list_for_each_entry_safe(pkt, n, &freeme, list) {
-		if (pkt->reply)
-			cnt++;
-		list_del(&pkt->list);
-		virtio_transport_free_pkt(pkt);
-	}
+	cnt = virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
 
 	if (cnt) {
 		struct vhost_virtqueue *tx_vq = &vsock->vqs[VSOCK_VQ_TX];
@@ -352,11 +324,12 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 	return ret;
 }
 
-static struct virtio_vsock_pkt *
-vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
+static struct sk_buff *
+vhost_vsock_alloc_skb(struct vhost_virtqueue *vq,
 		      unsigned int out, unsigned int in)
 {
-	struct virtio_vsock_pkt *pkt;
+	struct sk_buff *skb;
+	struct virtio_vsock_hdr *hdr;
 	struct iov_iter iov_iter;
 	size_t nbytes;
 	size_t len;
@@ -366,50 +339,50 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
-	if (!pkt)
+	len = iov_length(vq->iov, out);
+
+	/* len contains both payload and hdr, so only add additional space for metadata */
+	skb = alloc_skb(len + sizeof(struct virtio_vsock_metadata), GFP_KERNEL);
+	if (!skb)
 		return NULL;
 
-	len = iov_length(vq->iov, out);
+	/* Only zero metadata, preserve the header */
+	memset(skb->head, 0, sizeof(struct virtio_vsock_metadata));
+	virtio_vsock_skb_reserve(skb);
 	iov_iter_init(&iov_iter, WRITE, vq->iov, out, len);
 
-	nbytes = copy_from_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
-	if (nbytes != sizeof(pkt->hdr)) {
+	hdr = vsock_hdr(skb);
+	nbytes = copy_from_iter(hdr, sizeof(*hdr), &iov_iter);
+	if (nbytes != sizeof(*hdr)) {
 		vq_err(vq, "Expected %zu bytes for pkt->hdr, got %zu bytes\n",
-		       sizeof(pkt->hdr), nbytes);
-		kfree(pkt);
+		       sizeof(*hdr), nbytes);
+		kfree_skb(skb);
 		return NULL;
 	}
 
-	pkt->len = le32_to_cpu(pkt->hdr.len);
+	len = le32_to_cpu(hdr->len);
 
 	/* No payload */
-	if (!pkt->len)
-		return pkt;
+	if (!len)
+		return skb;
 
 	/* The pkt is too big */
-	if (pkt->len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
-		kfree(pkt);
+	if (len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
+		kfree_skb(skb);
 		return NULL;
 	}
 
-	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
-	if (!pkt->buf) {
-		kfree(pkt);
-		return NULL;
-	}
+	virtio_vsock_skb_rx_put(skb);
 
-	pkt->buf_len = pkt->len;
-
-	nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
-	if (nbytes != pkt->len) {
-		vq_err(vq, "Expected %u byte payload, got %zu bytes\n",
-		       pkt->len, nbytes);
-		virtio_transport_free_pkt(pkt);
+	nbytes = copy_from_iter(skb->data, len, &iov_iter);
+	if (nbytes != len) {
+		vq_err(vq, "Expected %zu byte payload, got %zu bytes\n",
+		       len, nbytes);
+		kfree_skb(skb);
 		return NULL;
 	}
 
-	return pkt;
+	return skb;
 }
 
 /* Is there space left for replies to rx packets? */
@@ -496,7 +469,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 						  poll.work);
 	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
 						 dev);
-	struct virtio_vsock_pkt *pkt;
+	struct sk_buff *skb;
 	int head, pkts = 0, total_len = 0;
 	unsigned int out, in;
 	bool added = false;
@@ -511,6 +484,9 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 
 	vhost_disable_notify(&vsock->dev, vq);
 	do {
+		struct virtio_vsock_hdr *hdr;
+		u32 len;
+
 		if (!vhost_vsock_more_replies(vsock)) {
 			/* Stop tx until the device processes already
 			 * pending replies.  Leave tx virtqueue
@@ -532,26 +508,29 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			break;
 		}
 
-		pkt = vhost_vsock_alloc_pkt(vq, out, in);
-		if (!pkt) {
-			vq_err(vq, "Faulted on pkt\n");
+		skb = vhost_vsock_alloc_skb(vq, out, in);
+		if (!skb)
 			continue;
-		}
 
-		total_len += sizeof(pkt->hdr) + pkt->len;
+		len = skb->len;
 
 		/* Deliver to monitoring devices all received packets */
-		virtio_transport_deliver_tap_pkt(pkt);
+		virtio_transport_deliver_tap_pkt(skb);
+
+		hdr = vsock_hdr(skb);
 
 		/* Only accept correctly addressed packets */
-		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid &&
-		    le64_to_cpu(pkt->hdr.dst_cid) ==
+		if (le64_to_cpu(hdr->src_cid) == vsock->guest_cid &&
+		    le64_to_cpu(hdr->dst_cid) ==
 		    vhost_transport_get_local_cid())
-			virtio_transport_recv_pkt(&vhost_transport, pkt);
+			virtio_transport_recv_pkt(&vhost_transport, skb);
 		else
-			virtio_transport_free_pkt(pkt);
+			kfree_skb(skb);
+
 
-		vhost_add_used(vq, head, 0);
+		len += sizeof(*hdr);
+		vhost_add_used(vq, head, len);
+		total_len += len;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 
@@ -693,8 +672,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 		       VHOST_VSOCK_WEIGHT, true, NULL);
 
 	file->private_data = vsock;
-	spin_lock_init(&vsock->send_pkt_list_lock);
-	INIT_LIST_HEAD(&vsock->send_pkt_list);
+	skb_queue_head_init(&vsock->send_pkt_queue);
 	vhost_work_init(&vsock->send_pkt_work, vhost_transport_send_pkt_work);
 	return 0;
 
@@ -760,16 +738,7 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	vhost_vsock_flush(vsock);
 	vhost_dev_stop(&vsock->dev);
 
-	spin_lock_bh(&vsock->send_pkt_list_lock);
-	while (!list_empty(&vsock->send_pkt_list)) {
-		struct virtio_vsock_pkt *pkt;
-
-		pkt = list_first_entry(&vsock->send_pkt_list,
-				struct virtio_vsock_pkt, list);
-		list_del_init(&pkt->list);
-		virtio_transport_free_pkt(pkt);
-	}
-	spin_unlock_bh(&vsock->send_pkt_list_lock);
+	skb_queue_purge(&vsock->send_pkt_queue);
 
 	vhost_dev_cleanup(&vsock->dev);
 	kfree(vsock->dev.vqs);
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 35d7eedb5e8e..b1dff55c91a5 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -4,9 +4,47 @@
 
 #include <uapi/linux/virtio_vsock.h>
 #include <linux/socket.h>
+#include <vdso/bits.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
 
+/* Threshold for detecting small packets to copy */
+#define GOOD_COPY_LEN  128
+
+enum virtio_vsock_metadata_flags {
+	VIRTIO_VSOCK_METADATA_FLAGS_REPLY		= BIT(0),
+	VIRTIO_VSOCK_METADATA_FLAGS_TAP_DELIVERED	= BIT(1),
+};
+
+/* Used only by the virtio/vhost vsock drivers, not related to protocol */
+struct virtio_vsock_metadata {
+	size_t off;
+	enum virtio_vsock_metadata_flags flags;
+};
+
+#define vsock_hdr(skb) \
+	((struct virtio_vsock_hdr *) \
+	 ((void *)skb->head + sizeof(struct virtio_vsock_metadata)))
+
+#define vsock_metadata(skb) \
+	((struct virtio_vsock_metadata *)skb->head)
+
+#define VIRTIO_VSOCK_SKB_RESERVE_SIZE \
+	(sizeof(struct virtio_vsock_metadata) + sizeof(struct virtio_vsock_hdr))
+
+#define virtio_vsock_skb_reserve(skb) \
+	skb_reserve(skb, VIRTIO_VSOCK_SKB_RESERVE_SIZE)
+
+static inline void virtio_vsock_skb_rx_put(struct sk_buff *skb)
+{
+	u32 len;
+
+	len = le32_to_cpu(vsock_hdr(skb)->len);
+
+	if (len > 0)
+		skb_put(skb, len);
+}
+
 #define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
 #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
 #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
@@ -35,23 +73,10 @@ struct virtio_vsock_sock {
 	u32 last_fwd_cnt;
 	u32 rx_bytes;
 	u32 buf_alloc;
-	struct list_head rx_queue;
+	struct sk_buff_head rx_queue;
 	u32 msg_count;
 };
 
-struct virtio_vsock_pkt {
-	struct virtio_vsock_hdr	hdr;
-	struct list_head list;
-	/* socket refcnt not held, only use for cancellation */
-	struct vsock_sock *vsk;
-	void *buf;
-	u32 buf_len;
-	u32 len;
-	u32 off;
-	bool reply;
-	bool tap_delivered;
-};
-
 struct virtio_vsock_pkt_info {
 	u32 remote_cid, remote_port;
 	struct vsock_sock *vsk;
@@ -68,7 +93,7 @@ struct virtio_transport {
 	struct vsock_transport transport;
 
 	/* Takes ownership of the packet */
-	int (*send_pkt)(struct virtio_vsock_pkt *pkt);
+	int (*send_pkt)(struct sk_buff *skb);
 };
 
 ssize_t
@@ -149,11 +174,10 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 void virtio_transport_destruct(struct vsock_sock *vsk);
 
 void virtio_transport_recv_pkt(struct virtio_transport *t,
-			       struct virtio_vsock_pkt *pkt);
-void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt);
-void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt);
+			       struct sk_buff *skb);
+void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb);
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
 void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
-void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt);
-
+void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
+int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *queue);
 #endif /* _LINUX_VIRTIO_VSOCK_H */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index b4ee163154a6..de8a9b0ec3a0 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -748,6 +748,7 @@ static struct sock *__vsock_create(struct net *net,
 	vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
 	vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
 
+	sk->sk_allocation = GFP_KERNEL;
 	sk->sk_destruct = vsock_sk_destruct;
 	sk->sk_backlog_rcv = vsock_queue_rcv_skb;
 	sock_reset_flag(sk, SOCK_DONE);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ad64f403536a..ac8c7003835b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -21,6 +21,11 @@
 #include <linux/mutex.h>
 #include <net/af_vsock.h>
 
+#define VIRTIO_VSOCK_MAX_RX_HDR_PAYLOAD_SIZE	\
+	(VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE \
+		 - SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) \
+		 - VIRTIO_VSOCK_SKB_RESERVE_SIZE)
+
 static struct workqueue_struct *virtio_vsock_workqueue;
 static struct virtio_vsock __rcu *the_virtio_vsock;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
@@ -42,8 +47,7 @@ struct virtio_vsock {
 	bool tx_run;
 
 	struct work_struct send_pkt_work;
-	spinlock_t send_pkt_list_lock;
-	struct list_head send_pkt_list;
+	struct sk_buff_head send_pkt_queue;
 
 	atomic_t queued_replies;
 
@@ -101,41 +105,32 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 	vq = vsock->vqs[VSOCK_VQ_TX];
 
 	for (;;) {
-		struct virtio_vsock_pkt *pkt;
+		struct sk_buff *skb;
 		struct scatterlist hdr, buf, *sgs[2];
 		int ret, in_sg = 0, out_sg = 0;
 		bool reply;
 
-		spin_lock_bh(&vsock->send_pkt_list_lock);
-		if (list_empty(&vsock->send_pkt_list)) {
-			spin_unlock_bh(&vsock->send_pkt_list_lock);
-			break;
-		}
+		skb = skb_dequeue(&vsock->send_pkt_queue);
 
-		pkt = list_first_entry(&vsock->send_pkt_list,
-				       struct virtio_vsock_pkt, list);
-		list_del_init(&pkt->list);
-		spin_unlock_bh(&vsock->send_pkt_list_lock);
-
-		virtio_transport_deliver_tap_pkt(pkt);
+		if (!skb)
+			break;
 
-		reply = pkt->reply;
+		virtio_transport_deliver_tap_pkt(skb);
+		reply = vsock_metadata(skb)->flags & VIRTIO_VSOCK_METADATA_FLAGS_REPLY;
 
-		sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
+		sg_init_one(&hdr, vsock_hdr(skb), sizeof(*vsock_hdr(skb)));
 		sgs[out_sg++] = &hdr;
-		if (pkt->buf) {
-			sg_init_one(&buf, pkt->buf, pkt->len);
+		if (skb->len > 0) {
+			sg_init_one(&buf, skb->data, skb->len);
 			sgs[out_sg++] = &buf;
 		}
 
-		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, pkt, GFP_KERNEL);
+		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
 		/* Usually this means that there is no more space available in
 		 * the vq
 		 */
 		if (ret < 0) {
-			spin_lock_bh(&vsock->send_pkt_list_lock);
-			list_add(&pkt->list, &vsock->send_pkt_list);
-			spin_unlock_bh(&vsock->send_pkt_list_lock);
+			skb_queue_head(&vsock->send_pkt_queue, skb);
 			break;
 		}
 
@@ -163,33 +158,83 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
+static inline bool
+virtio_transport_skbs_can_merge(struct sk_buff *old, struct sk_buff *new)
+{
+	return (new->len < GOOD_COPY_LEN &&
+		skb_tailroom(old) >= new->len &&
+		vsock_hdr(new)->src_cid == vsock_hdr(old)->src_cid &&
+		vsock_hdr(new)->dst_cid == vsock_hdr(old)->dst_cid &&
+		vsock_hdr(new)->src_port == vsock_hdr(old)->src_port &&
+		vsock_hdr(new)->dst_port == vsock_hdr(old)->dst_port &&
+		vsock_hdr(new)->type == vsock_hdr(old)->type &&
+		vsock_hdr(new)->flags == vsock_hdr(old)->flags &&
+		le16_to_cpu(vsock_hdr(old)->op) == VIRTIO_VSOCK_OP_RW &&
+		le16_to_cpu(vsock_hdr(new)->op) == VIRTIO_VSOCK_OP_RW);
+}
+
+/* Add new sk_buff to queue.
+ *
+ * Merge the two most recent skbs together if possible.
+ */
+static void
+virtio_transport_add_to_queue(struct sk_buff_head *queue, struct sk_buff *new)
+{
+	struct sk_buff *old;
+
+	spin_lock_bh(&queue->lock);
+	if (skb_queue_empty_lockless(queue)) {
+		__skb_queue_tail(queue, new);
+		goto out;
+	}
+
+	old = skb_peek_tail(queue);
+
+	/* In order to reduce skb memory overhead, we merge new packets with
+	 * older packets if they pass virtio_transport_skbs_can_merge().
+	 */
+	if (!virtio_transport_skbs_can_merge(old, new)) {
+		__skb_queue_tail(queue, new);
+		goto out;
+	}
+
+	memcpy(skb_put(old, new->len), new->data, new->len);
+	vsock_hdr(old)->len = cpu_to_le32(old->len);
+	vsock_hdr(old)->buf_alloc = vsock_hdr(new)->buf_alloc;
+	vsock_hdr(old)->fwd_cnt = vsock_hdr(new)->fwd_cnt;
+	dev_kfree_skb_any(new);
+
+out:
+	spin_unlock_bh(&queue->lock);
+}
+
 static int
-virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
+virtio_transport_send_pkt(struct sk_buff *skb)
 {
+	struct virtio_vsock_hdr *hdr;
 	struct virtio_vsock *vsock;
-	int len = pkt->len;
+	int len = skb->len;
+
+	hdr = vsock_hdr(skb);
 
 	rcu_read_lock();
 	vsock = rcu_dereference(the_virtio_vsock);
 	if (!vsock) {
-		virtio_transport_free_pkt(pkt);
+		kfree_skb(skb);
 		len = -ENODEV;
 		goto out_rcu;
 	}
 
-	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid) {
-		virtio_transport_free_pkt(pkt);
+	if (le64_to_cpu(hdr->dst_cid) == vsock->guest_cid) {
+		kfree_skb(skb);
 		len = -ENODEV;
 		goto out_rcu;
 	}
 
-	if (pkt->reply)
+	if (vsock_metadata(skb)->flags & VIRTIO_VSOCK_METADATA_FLAGS_REPLY)
 		atomic_inc(&vsock->queued_replies);
 
-	spin_lock_bh(&vsock->send_pkt_list_lock);
-	list_add_tail(&pkt->list, &vsock->send_pkt_list);
-	spin_unlock_bh(&vsock->send_pkt_list_lock);
-
+	virtio_transport_add_to_queue(&vsock->send_pkt_queue, skb);
 	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
 
 out_rcu:
@@ -201,9 +246,7 @@ static int
 virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct virtio_vsock *vsock;
-	struct virtio_vsock_pkt *pkt, *n;
 	int cnt = 0, ret;
-	LIST_HEAD(freeme);
 
 	rcu_read_lock();
 	vsock = rcu_dereference(the_virtio_vsock);
@@ -212,20 +255,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 		goto out_rcu;
 	}
 
-	spin_lock_bh(&vsock->send_pkt_list_lock);
-	list_for_each_entry_safe(pkt, n, &vsock->send_pkt_list, list) {
-		if (pkt->vsk != vsk)
-			continue;
-		list_move(&pkt->list, &freeme);
-	}
-	spin_unlock_bh(&vsock->send_pkt_list_lock);
-
-	list_for_each_entry_safe(pkt, n, &freeme, list) {
-		if (pkt->reply)
-			cnt++;
-		list_del(&pkt->list);
-		virtio_transport_free_pkt(pkt);
-	}
+	cnt = virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
 
 	if (cnt) {
 		struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
@@ -246,38 +276,32 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 
 static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
 {
-	int buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
-	struct virtio_vsock_pkt *pkt;
-	struct scatterlist hdr, buf, *sgs[2];
+	struct scatterlist pkt, *sgs[1];
 	struct virtqueue *vq;
 	int ret;
 
 	vq = vsock->vqs[VSOCK_VQ_RX];
 
 	do {
-		pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
-		if (!pkt)
-			break;
+		struct sk_buff *skb;
+		const size_t len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE -
+				SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
-		pkt->buf = kmalloc(buf_len, GFP_KERNEL);
-		if (!pkt->buf) {
-			virtio_transport_free_pkt(pkt);
+		skb = alloc_skb(len, GFP_KERNEL);
+		if (!skb)
 			break;
-		}
 
-		pkt->buf_len = buf_len;
-		pkt->len = buf_len;
+		memset(skb->head, 0, VIRTIO_VSOCK_SKB_RESERVE_SIZE);
 
-		sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
-		sgs[0] = &hdr;
+		sg_init_one(&pkt, vsock_hdr(skb), VIRTIO_VSOCK_MAX_RX_HDR_PAYLOAD_SIZE);
+		sgs[0] = &pkt;
 
-		sg_init_one(&buf, pkt->buf, buf_len);
-		sgs[1] = &buf;
-		ret = virtqueue_add_sgs(vq, sgs, 0, 2, pkt, GFP_KERNEL);
-		if (ret) {
-			virtio_transport_free_pkt(pkt);
+		ret = virtqueue_add_sgs(vq, sgs, 0, 1, skb, GFP_KERNEL);
+		if (ret < 0) {
+			kfree_skb(skb);
 			break;
 		}
+
 		vsock->rx_buf_nr++;
 	} while (vq->num_free);
 	if (vsock->rx_buf_nr > vsock->rx_buf_max_nr)
@@ -299,12 +323,12 @@ static void virtio_transport_tx_work(struct work_struct *work)
 		goto out;
 
 	do {
-		struct virtio_vsock_pkt *pkt;
+		struct sk_buff *skb;
 		unsigned int len;
 
 		virtqueue_disable_cb(vq);
-		while ((pkt = virtqueue_get_buf(vq, &len)) != NULL) {
-			virtio_transport_free_pkt(pkt);
+		while ((skb = virtqueue_get_buf(vq, &len)) != NULL) {
+			consume_skb(skb);
 			added = true;
 		}
 	} while (!virtqueue_enable_cb(vq));
@@ -529,7 +553,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
 	do {
 		virtqueue_disable_cb(vq);
 		for (;;) {
-			struct virtio_vsock_pkt *pkt;
+			struct sk_buff *skb;
 			unsigned int len;
 
 			if (!virtio_transport_more_replies(vsock)) {
@@ -540,23 +564,23 @@ static void virtio_transport_rx_work(struct work_struct *work)
 				goto out;
 			}
 
-			pkt = virtqueue_get_buf(vq, &len);
-			if (!pkt) {
+			skb = virtqueue_get_buf(vq, &len);
+			if (!skb)
 				break;
-			}
 
 			vsock->rx_buf_nr--;
 
 			/* Drop short/long packets */
-			if (unlikely(len < sizeof(pkt->hdr) ||
-				     len > sizeof(pkt->hdr) + pkt->len)) {
-				virtio_transport_free_pkt(pkt);
+			if (unlikely(len < sizeof(struct virtio_vsock_hdr) ||
+				     len > VIRTIO_VSOCK_MAX_RX_HDR_PAYLOAD_SIZE)) {
+				kfree_skb(skb);
 				continue;
 			}
 
-			pkt->len = len - sizeof(pkt->hdr);
-			virtio_transport_deliver_tap_pkt(pkt);
-			virtio_transport_recv_pkt(&virtio_transport, pkt);
+			virtio_vsock_skb_reserve(skb);
+			virtio_vsock_skb_rx_put(skb);
+			virtio_transport_deliver_tap_pkt(skb);
+			virtio_transport_recv_pkt(&virtio_transport, skb);
 		}
 	} while (!virtqueue_enable_cb(vq));
 
@@ -610,7 +634,7 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
 static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
 {
 	struct virtio_device *vdev = vsock->vdev;
-	struct virtio_vsock_pkt *pkt;
+	struct sk_buff *skb;
 
 	/* Reset all connected sockets when the VQs disappear */
 	vsock_for_each_connected_socket(&virtio_transport.transport,
@@ -637,23 +661,16 @@ static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
 	virtio_reset_device(vdev);
 
 	mutex_lock(&vsock->rx_lock);
-	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_RX])))
-		virtio_transport_free_pkt(pkt);
+	while ((skb = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_RX])))
+		kfree_skb(skb);
 	mutex_unlock(&vsock->rx_lock);
 
 	mutex_lock(&vsock->tx_lock);
-	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_TX])))
-		virtio_transport_free_pkt(pkt);
+	while ((skb = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_TX])))
+		kfree_skb(skb);
 	mutex_unlock(&vsock->tx_lock);
 
-	spin_lock_bh(&vsock->send_pkt_list_lock);
-	while (!list_empty(&vsock->send_pkt_list)) {
-		pkt = list_first_entry(&vsock->send_pkt_list,
-				       struct virtio_vsock_pkt, list);
-		list_del(&pkt->list);
-		virtio_transport_free_pkt(pkt);
-	}
-	spin_unlock_bh(&vsock->send_pkt_list_lock);
+	skb_queue_purge(&vsock->send_pkt_queue);
 
 	/* Delete virtqueues and flush outstanding callbacks if any */
 	vdev->config->del_vqs(vdev);
@@ -690,8 +707,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	mutex_init(&vsock->tx_lock);
 	mutex_init(&vsock->rx_lock);
 	mutex_init(&vsock->event_lock);
-	spin_lock_init(&vsock->send_pkt_list_lock);
-	INIT_LIST_HEAD(&vsock->send_pkt_list);
+	skb_queue_head_init(&vsock->send_pkt_queue);
 	INIT_WORK(&vsock->rx_work, virtio_transport_rx_work);
 	INIT_WORK(&vsock->tx_work, virtio_transport_tx_work);
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index ec2c2afbf0d0..19678bd45c23 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -23,9 +23,6 @@
 /* How long to wait for graceful shutdown of a connection */
 #define VSOCK_CLOSE_TIMEOUT (8 * HZ)
 
-/* Threshold for detecting small packets to copy */
-#define GOOD_COPY_LEN  128
-
 static const struct virtio_transport *
 virtio_transport_get_ops(struct vsock_sock *vsk)
 {
@@ -37,53 +34,64 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
 	return container_of(t, struct virtio_transport, transport);
 }
 
-static struct virtio_vsock_pkt *
-virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
+/* Returns a new packet on success, otherwise returns NULL.
+ *
+ * If NULL is returned, errp is set to a negative errno.
+ */
+static struct sk_buff *
+virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 			   size_t len,
 			   u32 src_cid,
 			   u32 src_port,
 			   u32 dst_cid,
-			   u32 dst_port)
+			   u32 dst_port,
+			   int *errp)
 {
-	struct virtio_vsock_pkt *pkt;
+	struct sk_buff *skb;
+	struct virtio_vsock_hdr *hdr;
+	void *payload;
+	const size_t skb_len = VIRTIO_VSOCK_SKB_RESERVE_SIZE + len;
 	int err;
 
-	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
-	if (!pkt)
+	skb = alloc_skb(skb_len, GFP_KERNEL);
+	if (!skb) {
+		*errp = -ENOMEM;
 		return NULL;
+	}
 
-	pkt->hdr.type		= cpu_to_le16(info->type);
-	pkt->hdr.op		= cpu_to_le16(info->op);
-	pkt->hdr.src_cid	= cpu_to_le64(src_cid);
-	pkt->hdr.dst_cid	= cpu_to_le64(dst_cid);
-	pkt->hdr.src_port	= cpu_to_le32(src_port);
-	pkt->hdr.dst_port	= cpu_to_le32(dst_port);
-	pkt->hdr.flags		= cpu_to_le32(info->flags);
-	pkt->len		= len;
-	pkt->hdr.len		= cpu_to_le32(len);
-	pkt->reply		= info->reply;
-	pkt->vsk		= info->vsk;
-
-	if (info->msg && len > 0) {
-		pkt->buf = kmalloc(len, GFP_KERNEL);
-		if (!pkt->buf)
-			goto out_pkt;
+	memset(skb->head, 0, VIRTIO_VSOCK_SKB_RESERVE_SIZE);
+	virtio_vsock_skb_reserve(skb);
+	payload = skb_put(skb, len);
 
-		pkt->buf_len = len;
+	hdr = vsock_hdr(skb);
+	hdr->type	= cpu_to_le16(info->type);
+	hdr->op		= cpu_to_le16(info->op);
+	hdr->src_cid	= cpu_to_le64(src_cid);
+	hdr->dst_cid	= cpu_to_le64(dst_cid);
+	hdr->src_port	= cpu_to_le32(src_port);
+	hdr->dst_port	= cpu_to_le32(dst_port);
+	hdr->flags	= cpu_to_le32(info->flags);
+	hdr->len	= cpu_to_le32(len);
 
-		err = memcpy_from_msg(pkt->buf, info->msg, len);
-		if (err)
+	if (info->msg && len > 0) {
+		err = memcpy_from_msg(payload, info->msg, len);
+		if (err) {
+			*errp = -ENOMEM;
 			goto out;
+		}
 
 		if (msg_data_left(info->msg) == 0 &&
 		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
-			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
 
 			if (info->msg->msg_flags & MSG_EOR)
-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+				hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
 		}
 	}
 
+	if (info->reply)
+		vsock_metadata(skb)->flags |= VIRTIO_VSOCK_METADATA_FLAGS_REPLY;
+
 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
 					 dst_cid, dst_port,
 					 len,
@@ -91,85 +99,26 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 					 info->op,
 					 info->flags);
 
-	return pkt;
+	return skb;
 
 out:
-	kfree(pkt->buf);
-out_pkt:
-	kfree(pkt);
+	kfree_skb(skb);
 	return NULL;
 }
 
 /* Packet capture */
 static struct sk_buff *virtio_transport_build_skb(void *opaque)
 {
-	struct virtio_vsock_pkt *pkt = opaque;
-	struct af_vsockmon_hdr *hdr;
-	struct sk_buff *skb;
-	size_t payload_len;
-	void *payload_buf;
-
-	/* A packet could be split to fit the RX buffer, so we can retrieve
-	 * the payload length from the header and the buffer pointer taking
-	 * care of the offset in the original packet.
-	 */
-	payload_len = le32_to_cpu(pkt->hdr.len);
-	payload_buf = pkt->buf + pkt->off;
-
-	skb = alloc_skb(sizeof(*hdr) + sizeof(pkt->hdr) + payload_len,
-			GFP_ATOMIC);
-	if (!skb)
-		return NULL;
-
-	hdr = skb_put(skb, sizeof(*hdr));
-
-	/* pkt->hdr is little-endian so no need to byteswap here */
-	hdr->src_cid = pkt->hdr.src_cid;
-	hdr->src_port = pkt->hdr.src_port;
-	hdr->dst_cid = pkt->hdr.dst_cid;
-	hdr->dst_port = pkt->hdr.dst_port;
-
-	hdr->transport = cpu_to_le16(AF_VSOCK_TRANSPORT_VIRTIO);
-	hdr->len = cpu_to_le16(sizeof(pkt->hdr));
-	memset(hdr->reserved, 0, sizeof(hdr->reserved));
-
-	switch (le16_to_cpu(pkt->hdr.op)) {
-	case VIRTIO_VSOCK_OP_REQUEST:
-	case VIRTIO_VSOCK_OP_RESPONSE:
-		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONNECT);
-		break;
-	case VIRTIO_VSOCK_OP_RST:
-	case VIRTIO_VSOCK_OP_SHUTDOWN:
-		hdr->op = cpu_to_le16(AF_VSOCK_OP_DISCONNECT);
-		break;
-	case VIRTIO_VSOCK_OP_RW:
-		hdr->op = cpu_to_le16(AF_VSOCK_OP_PAYLOAD);
-		break;
-	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
-	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
-		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONTROL);
-		break;
-	default:
-		hdr->op = cpu_to_le16(AF_VSOCK_OP_UNKNOWN);
-		break;
-	}
-
-	skb_put_data(skb, &pkt->hdr, sizeof(pkt->hdr));
-
-	if (payload_len) {
-		skb_put_data(skb, payload_buf, payload_len);
-	}
-
-	return skb;
+	return skb_clone((struct sk_buff *)opaque, GFP_ATOMIC);
 }
 
-void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
+void virtio_transport_deliver_tap_pkt(struct sk_buff *skb)
 {
-	if (pkt->tap_delivered)
+	if (vsock_metadata(skb)->flags & VIRTIO_VSOCK_METADATA_FLAGS_TAP_DELIVERED)
 		return;
 
-	vsock_deliver_tap(virtio_transport_build_skb, pkt);
-	pkt->tap_delivered = true;
+	vsock_deliver_tap(virtio_transport_build_skb, skb);
+	vsock_metadata(skb)->flags |= VIRTIO_VSOCK_METADATA_FLAGS_TAP_DELIVERED;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
 
@@ -192,8 +141,9 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	u32 src_cid, src_port, dst_cid, dst_port;
 	const struct virtio_transport *t_ops;
 	struct virtio_vsock_sock *vvs;
-	struct virtio_vsock_pkt *pkt;
+	struct sk_buff *skb;
 	u32 pkt_len = info->pkt_len;
+	int err;
 
 	info->type = virtio_transport_get_type(sk_vsock(vsk));
 
@@ -224,42 +174,47 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
 		return pkt_len;
 
-	pkt = virtio_transport_alloc_pkt(info, pkt_len,
+	skb = virtio_transport_alloc_skb(info, pkt_len,
 					 src_cid, src_port,
-					 dst_cid, dst_port);
-	if (!pkt) {
+					 dst_cid, dst_port,
+					 &err);
+	if (!skb) {
 		virtio_transport_put_credit(vvs, pkt_len);
-		return -ENOMEM;
+		return err;
 	}
 
-	virtio_transport_inc_tx_pkt(vvs, pkt);
+	virtio_transport_inc_tx_pkt(vvs, skb);
+
+	err = t_ops->send_pkt(skb);
 
-	return t_ops->send_pkt(pkt);
+	return err < 0 ? -ENOMEM : err;
 }
 
 static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
-					struct virtio_vsock_pkt *pkt)
+					struct sk_buff *skb)
 {
-	if (vvs->rx_bytes + pkt->len > vvs->buf_alloc)
+	if (vvs->rx_bytes + skb->len > vvs->buf_alloc)
 		return false;
 
-	vvs->rx_bytes += pkt->len;
+	vvs->rx_bytes += skb->len;
 	return true;
 }
 
 static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
-					struct virtio_vsock_pkt *pkt)
+					struct sk_buff *skb)
 {
-	vvs->rx_bytes -= pkt->len;
-	vvs->fwd_cnt += pkt->len;
+	vvs->rx_bytes -= skb->len;
+	vvs->fwd_cnt += skb->len;
 }
 
-void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt)
+void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb)
 {
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
+
 	spin_lock_bh(&vvs->rx_lock);
 	vvs->last_fwd_cnt = vvs->fwd_cnt;
-	pkt->hdr.fwd_cnt = cpu_to_le32(vvs->fwd_cnt);
-	pkt->hdr.buf_alloc = cpu_to_le32(vvs->buf_alloc);
+	hdr->fwd_cnt = cpu_to_le32(vvs->fwd_cnt);
+	hdr->buf_alloc = cpu_to_le32(vvs->buf_alloc);
 	spin_unlock_bh(&vvs->rx_lock);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_inc_tx_pkt);
@@ -303,29 +258,29 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 				size_t len)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	struct virtio_vsock_pkt *pkt;
+	struct sk_buff *skb, *tmp;
 	size_t bytes, total = 0, off;
 	int err = -EFAULT;
 
 	spin_lock_bh(&vvs->rx_lock);
 
-	list_for_each_entry(pkt, &vvs->rx_queue, list) {
-		off = pkt->off;
+	skb_queue_walk_safe(&vvs->rx_queue, skb,  tmp) {
+		off = vsock_metadata(skb)->off;
 
 		if (total == len)
 			break;
 
-		while (total < len && off < pkt->len) {
+		while (total < len && off < skb->len) {
 			bytes = len - total;
-			if (bytes > pkt->len - off)
-				bytes = pkt->len - off;
+			if (bytes > skb->len - off)
+				bytes = skb->len - off;
 
 			/* sk_lock is held by caller so no one else can dequeue.
 			 * Unlock rx_lock since memcpy_to_msg() may sleep.
 			 */
 			spin_unlock_bh(&vvs->rx_lock);
 
-			err = memcpy_to_msg(msg, pkt->buf + off, bytes);
+			err = memcpy_to_msg(msg, skb->data + off, bytes);
 			if (err)
 				goto out;
 
@@ -352,37 +307,40 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 				   size_t len)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	struct virtio_vsock_pkt *pkt;
+	struct sk_buff *skb;
 	size_t bytes, total = 0;
 	u32 free_space;
 	int err = -EFAULT;
 
 	spin_lock_bh(&vvs->rx_lock);
-	while (total < len && !list_empty(&vvs->rx_queue)) {
-		pkt = list_first_entry(&vvs->rx_queue,
-				       struct virtio_vsock_pkt, list);
+	while (total < len && !skb_queue_empty_lockless(&vvs->rx_queue)) {
+		skb = __skb_dequeue(&vvs->rx_queue);
 
 		bytes = len - total;
-		if (bytes > pkt->len - pkt->off)
-			bytes = pkt->len - pkt->off;
+		if (bytes > skb->len - vsock_metadata(skb)->off)
+			bytes = skb->len - vsock_metadata(skb)->off;
 
 		/* sk_lock is held by caller so no one else can dequeue.
 		 * Unlock rx_lock since memcpy_to_msg() may sleep.
 		 */
 		spin_unlock_bh(&vvs->rx_lock);
 
-		err = memcpy_to_msg(msg, pkt->buf + pkt->off, bytes);
+		err = memcpy_to_msg(msg, skb->data + vsock_metadata(skb)->off, bytes);
 		if (err)
 			goto out;
 
 		spin_lock_bh(&vvs->rx_lock);
 
 		total += bytes;
-		pkt->off += bytes;
-		if (pkt->off == pkt->len) {
-			virtio_transport_dec_rx_pkt(vvs, pkt);
-			list_del(&pkt->list);
-			virtio_transport_free_pkt(pkt);
+		vsock_metadata(skb)->off += bytes;
+
+		WARN_ON(vsock_metadata(skb)->off > skb->len);
+
+		if (vsock_metadata(skb)->off == skb->len) {
+			virtio_transport_dec_rx_pkt(vvs, skb);
+			consume_skb(skb);
+		} else {
+			__skb_queue_head(&vvs->rx_queue, skb);
 		}
 	}
 
@@ -414,7 +372,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 						 int flags)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	struct virtio_vsock_pkt *pkt;
+	struct sk_buff *skb;
 	int dequeued_len = 0;
 	size_t user_buf_len = msg_data_left(msg);
 	bool msg_ready = false;
@@ -426,14 +384,24 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 		return 0;
 	}
 
+	if (skb_queue_empty_lockless(&vvs->rx_queue)) {
+		spin_unlock_bh(&vvs->rx_lock);
+		return 0;
+	}
+
 	while (!msg_ready) {
-		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
+		struct virtio_vsock_hdr *hdr;
+
+		skb = __skb_dequeue(&vvs->rx_queue);
+		if (!skb)
+			break;
+		hdr = vsock_hdr(skb);
 
 		if (dequeued_len >= 0) {
 			size_t pkt_len;
 			size_t bytes_to_copy;
 
-			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
+			pkt_len = (size_t)le32_to_cpu(hdr->len);
 			bytes_to_copy = min(user_buf_len, pkt_len);
 
 			if (bytes_to_copy) {
@@ -444,7 +412,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				 */
 				spin_unlock_bh(&vvs->rx_lock);
 
-				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
+				err = memcpy_to_msg(msg, skb->data, bytes_to_copy);
 				if (err) {
 					/* Copy of message failed. Rest of
 					 * fragments will be freed without copy.
@@ -461,17 +429,16 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				dequeued_len += pkt_len;
 		}
 
-		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
+		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) {
 			msg_ready = true;
 			vvs->msg_count--;
 
-			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
+			if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOR)
 				msg->msg_flags |= MSG_EOR;
 		}
 
-		virtio_transport_dec_rx_pkt(vvs, pkt);
-		list_del(&pkt->list);
-		virtio_transport_free_pkt(pkt);
+		virtio_transport_dec_rx_pkt(vvs, skb);
+		kfree_skb(skb);
 	}
 
 	spin_unlock_bh(&vvs->rx_lock);
@@ -609,7 +576,7 @@ int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 
 	spin_lock_init(&vvs->rx_lock);
 	spin_lock_init(&vvs->tx_lock);
-	INIT_LIST_HEAD(&vvs->rx_queue);
+	skb_queue_head_init(&vvs->rx_queue);
 
 	return 0;
 }
@@ -809,16 +776,16 @@ void virtio_transport_destruct(struct vsock_sock *vsk)
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 
 static int virtio_transport_reset(struct vsock_sock *vsk,
-				  struct virtio_vsock_pkt *pkt)
+				  struct sk_buff *skb)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RST,
-		.reply = !!pkt,
+		.reply = !!skb,
 		.vsk = vsk,
 	};
 
 	/* Send RST only if the original pkt is not a RST pkt */
-	if (pkt && le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RST)
+	if (skb && le16_to_cpu(vsock_hdr(skb)->op) == VIRTIO_VSOCK_OP_RST)
 		return 0;
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -828,29 +795,32 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
  * attempt was made to connect to a socket that does not exist.
  */
 static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
-					  struct virtio_vsock_pkt *pkt)
+					  struct sk_buff *skb)
 {
-	struct virtio_vsock_pkt *reply;
+	struct sk_buff *reply;
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RST,
-		.type = le16_to_cpu(pkt->hdr.type),
+		.type = le16_to_cpu(hdr->type),
 		.reply = true,
 	};
+	int err;
 
 	/* Send RST only if the original pkt is not a RST pkt */
-	if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RST)
+	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
 		return 0;
 
-	reply = virtio_transport_alloc_pkt(&info, 0,
-					   le64_to_cpu(pkt->hdr.dst_cid),
-					   le32_to_cpu(pkt->hdr.dst_port),
-					   le64_to_cpu(pkt->hdr.src_cid),
-					   le32_to_cpu(pkt->hdr.src_port));
+	reply = virtio_transport_alloc_skb(&info, 0,
+					   le64_to_cpu(hdr->dst_cid),
+					   le32_to_cpu(hdr->dst_port),
+					   le64_to_cpu(hdr->src_cid),
+					   le32_to_cpu(hdr->src_port),
+					   &err);
 	if (!reply)
-		return -ENOMEM;
+		return err;
 
 	if (!t) {
-		virtio_transport_free_pkt(reply);
+		kfree_skb(reply);
 		return -ENOTCONN;
 	}
 
@@ -861,16 +831,11 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 static void virtio_transport_remove_sock(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	struct virtio_vsock_pkt *pkt, *tmp;
 
 	/* We don't need to take rx_lock, as the socket is closing and we are
 	 * removing it.
 	 */
-	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
-		list_del(&pkt->list);
-		virtio_transport_free_pkt(pkt);
-	}
-
+	__skb_queue_purge(&vvs->rx_queue);
 	vsock_remove_sock(vsk);
 }
 
@@ -984,13 +949,14 @@ EXPORT_SYMBOL_GPL(virtio_transport_release);
 
 static int
 virtio_transport_recv_connecting(struct sock *sk,
-				 struct virtio_vsock_pkt *pkt)
+				 struct sk_buff *skb)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 	int err;
 	int skerr;
 
-	switch (le16_to_cpu(pkt->hdr.op)) {
+	switch (le16_to_cpu(hdr->op)) {
 	case VIRTIO_VSOCK_OP_RESPONSE:
 		sk->sk_state = TCP_ESTABLISHED;
 		sk->sk_socket->state = SS_CONNECTED;
@@ -1011,7 +977,7 @@ virtio_transport_recv_connecting(struct sock *sk,
 	return 0;
 
 destroy:
-	virtio_transport_reset(vsk, pkt);
+	virtio_transport_reset(vsk, skb);
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = skerr;
 	sk_error_report(sk);
@@ -1020,34 +986,38 @@ virtio_transport_recv_connecting(struct sock *sk,
 
 static void
 virtio_transport_recv_enqueue(struct vsock_sock *vsk,
-			      struct virtio_vsock_pkt *pkt)
+			      struct sk_buff *skb)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_hdr *hdr;
 	bool can_enqueue, free_pkt = false;
+	u32 len;
 
-	pkt->len = le32_to_cpu(pkt->hdr.len);
-	pkt->off = 0;
+	hdr = vsock_hdr(skb);
+	len = le32_to_cpu(hdr->len);
+	vsock_metadata(skb)->off = 0;
 
 	spin_lock_bh(&vvs->rx_lock);
 
-	can_enqueue = virtio_transport_inc_rx_pkt(vvs, pkt);
+	can_enqueue = virtio_transport_inc_rx_pkt(vvs, skb);
 	if (!can_enqueue) {
 		free_pkt = true;
 		goto out;
 	}
 
-	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)
+	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
 		vvs->msg_count++;
 
 	/* Try to copy small packets into the buffer of last packet queued,
 	 * to avoid wasting memory queueing the entire buffer with a small
 	 * payload.
 	 */
-	if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
-		struct virtio_vsock_pkt *last_pkt;
+	if (len <= GOOD_COPY_LEN && !skb_queue_empty_lockless(&vvs->rx_queue)) {
+		struct virtio_vsock_hdr *last_hdr;
+		struct sk_buff *last_skb;
 
-		last_pkt = list_last_entry(&vvs->rx_queue,
-					   struct virtio_vsock_pkt, list);
+		last_skb = skb_peek_tail(&vvs->rx_queue);
+		last_hdr = vsock_hdr(last_skb);
 
 		/* If there is space in the last packet queued, we copy the
 		 * new packet in its buffer. We avoid this if the last packet
@@ -1055,35 +1025,34 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 		 * delimiter of SEQPACKET message, so 'pkt' is the first packet
 		 * of a new message.
 		 */
-		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
-		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)) {
-			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
-			       pkt->len);
-			last_pkt->len += pkt->len;
+		if (skb->len < skb_tailroom(last_skb) &&
+		    !(le32_to_cpu(last_hdr->flags) & VIRTIO_VSOCK_SEQ_EOR)) {
+			memcpy(skb_put(last_skb, skb->len), skb->data, skb->len);
 			free_pkt = true;
-			last_pkt->hdr.flags |= pkt->hdr.flags;
+			last_hdr->flags |= hdr->flags;
 			goto out;
 		}
 	}
 
-	list_add_tail(&pkt->list, &vvs->rx_queue);
+	__skb_queue_tail(&vvs->rx_queue, skb);
 
 out:
 	spin_unlock_bh(&vvs->rx_lock);
 	if (free_pkt)
-		virtio_transport_free_pkt(pkt);
+		kfree_skb(skb);
 }
 
 static int
 virtio_transport_recv_connected(struct sock *sk,
-				struct virtio_vsock_pkt *pkt)
+				struct sk_buff *skb)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 	int err = 0;
 
-	switch (le16_to_cpu(pkt->hdr.op)) {
+	switch (le16_to_cpu(hdr->op)) {
 	case VIRTIO_VSOCK_OP_RW:
-		virtio_transport_recv_enqueue(vsk, pkt);
+		virtio_transport_recv_enqueue(vsk, skb);
 		sk->sk_data_ready(sk);
 		return err;
 	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
@@ -1093,18 +1062,17 @@ virtio_transport_recv_connected(struct sock *sk,
 		sk->sk_write_space(sk);
 		break;
 	case VIRTIO_VSOCK_OP_SHUTDOWN:
-		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SHUTDOWN_RCV)
+		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SHUTDOWN_RCV)
 			vsk->peer_shutdown |= RCV_SHUTDOWN;
-		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
+		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
 			vsk->peer_shutdown |= SEND_SHUTDOWN;
 		if (vsk->peer_shutdown == SHUTDOWN_MASK &&
 		    vsock_stream_has_data(vsk) <= 0 &&
 		    !sock_flag(sk, SOCK_DONE)) {
 			(void)virtio_transport_reset(vsk, NULL);
-
 			virtio_transport_do_close(vsk, true);
 		}
-		if (le32_to_cpu(pkt->hdr.flags))
+		if (le32_to_cpu(vsock_hdr(skb)->flags))
 			sk->sk_state_change(sk);
 		break;
 	case VIRTIO_VSOCK_OP_RST:
@@ -1115,28 +1083,30 @@ virtio_transport_recv_connected(struct sock *sk,
 		break;
 	}
 
-	virtio_transport_free_pkt(pkt);
+	kfree_skb(skb);
 	return err;
 }
 
 static void
 virtio_transport_recv_disconnecting(struct sock *sk,
-				    struct virtio_vsock_pkt *pkt)
+				    struct sk_buff *skb)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 
-	if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RST)
+	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
 		virtio_transport_do_close(vsk, true);
 }
 
 static int
 virtio_transport_send_response(struct vsock_sock *vsk,
-			       struct virtio_vsock_pkt *pkt)
+			       struct sk_buff *skb)
 {
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RESPONSE,
-		.remote_cid = le64_to_cpu(pkt->hdr.src_cid),
-		.remote_port = le32_to_cpu(pkt->hdr.src_port),
+		.remote_cid = le64_to_cpu(hdr->src_cid),
+		.remote_port = le32_to_cpu(hdr->src_port),
 		.reply = true,
 		.vsk = vsk,
 	};
@@ -1145,10 +1115,11 @@ virtio_transport_send_response(struct vsock_sock *vsk,
 }
 
 static bool virtio_transport_space_update(struct sock *sk,
-					  struct virtio_vsock_pkt *pkt)
+					  struct sk_buff *skb)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
 	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 	bool space_available;
 
 	/* Listener sockets are not associated with any transport, so we are
@@ -1161,8 +1132,8 @@ static bool virtio_transport_space_update(struct sock *sk,
 
 	/* buf_alloc and fwd_cnt is always included in the hdr */
 	spin_lock_bh(&vvs->tx_lock);
-	vvs->peer_buf_alloc = le32_to_cpu(pkt->hdr.buf_alloc);
-	vvs->peer_fwd_cnt = le32_to_cpu(pkt->hdr.fwd_cnt);
+	vvs->peer_buf_alloc = le32_to_cpu(hdr->buf_alloc);
+	vvs->peer_fwd_cnt = le32_to_cpu(hdr->fwd_cnt);
 	space_available = virtio_transport_has_space(vsk);
 	spin_unlock_bh(&vvs->tx_lock);
 	return space_available;
@@ -1170,27 +1141,28 @@ static bool virtio_transport_space_update(struct sock *sk,
 
 /* Handle server socket */
 static int
-virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
+virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 			     struct virtio_transport *t)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 	struct vsock_sock *vchild;
 	struct sock *child;
 	int ret;
 
-	if (le16_to_cpu(pkt->hdr.op) != VIRTIO_VSOCK_OP_REQUEST) {
-		virtio_transport_reset_no_sock(t, pkt);
+	if (le16_to_cpu(hdr->op) != VIRTIO_VSOCK_OP_REQUEST) {
+		virtio_transport_reset_no_sock(t, skb);
 		return -EINVAL;
 	}
 
 	if (sk_acceptq_is_full(sk)) {
-		virtio_transport_reset_no_sock(t, pkt);
+		virtio_transport_reset_no_sock(t, skb);
 		return -ENOMEM;
 	}
 
 	child = vsock_create_connected(sk);
 	if (!child) {
-		virtio_transport_reset_no_sock(t, pkt);
+		virtio_transport_reset_no_sock(t, skb);
 		return -ENOMEM;
 	}
 
@@ -1201,10 +1173,10 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
 	child->sk_state = TCP_ESTABLISHED;
 
 	vchild = vsock_sk(child);
-	vsock_addr_init(&vchild->local_addr, le64_to_cpu(pkt->hdr.dst_cid),
-			le32_to_cpu(pkt->hdr.dst_port));
-	vsock_addr_init(&vchild->remote_addr, le64_to_cpu(pkt->hdr.src_cid),
-			le32_to_cpu(pkt->hdr.src_port));
+	vsock_addr_init(&vchild->local_addr, le64_to_cpu(hdr->dst_cid),
+			le32_to_cpu(hdr->dst_port));
+	vsock_addr_init(&vchild->remote_addr, le64_to_cpu(hdr->src_cid),
+			le32_to_cpu(hdr->src_port));
 
 	ret = vsock_assign_transport(vchild, vsk);
 	/* Transport assigned (looking at remote_addr) must be the same
@@ -1212,17 +1184,17 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
 	 */
 	if (ret || vchild->transport != &t->transport) {
 		release_sock(child);
-		virtio_transport_reset_no_sock(t, pkt);
+		virtio_transport_reset_no_sock(t, skb);
 		sock_put(child);
 		return ret;
 	}
 
-	if (virtio_transport_space_update(child, pkt))
+	if (virtio_transport_space_update(child, skb))
 		child->sk_write_space(child);
 
 	vsock_insert_connected(vchild);
 	vsock_enqueue_accept(sk, child);
-	virtio_transport_send_response(vchild, pkt);
+	virtio_transport_send_response(vchild, skb);
 
 	release_sock(child);
 
@@ -1240,29 +1212,30 @@ static bool virtio_transport_valid_type(u16 type)
  * lock.
  */
 void virtio_transport_recv_pkt(struct virtio_transport *t,
-			       struct virtio_vsock_pkt *pkt)
+			       struct sk_buff *skb)
 {
 	struct sockaddr_vm src, dst;
 	struct vsock_sock *vsk;
 	struct sock *sk;
 	bool space_available;
+	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 
-	vsock_addr_init(&src, le64_to_cpu(pkt->hdr.src_cid),
-			le32_to_cpu(pkt->hdr.src_port));
-	vsock_addr_init(&dst, le64_to_cpu(pkt->hdr.dst_cid),
-			le32_to_cpu(pkt->hdr.dst_port));
+	vsock_addr_init(&src, le64_to_cpu(hdr->src_cid),
+			le32_to_cpu(hdr->src_port));
+	vsock_addr_init(&dst, le64_to_cpu(hdr->dst_cid),
+			le32_to_cpu(hdr->dst_port));
 
 	trace_virtio_transport_recv_pkt(src.svm_cid, src.svm_port,
 					dst.svm_cid, dst.svm_port,
-					le32_to_cpu(pkt->hdr.len),
-					le16_to_cpu(pkt->hdr.type),
-					le16_to_cpu(pkt->hdr.op),
-					le32_to_cpu(pkt->hdr.flags),
-					le32_to_cpu(pkt->hdr.buf_alloc),
-					le32_to_cpu(pkt->hdr.fwd_cnt));
-
-	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
-		(void)virtio_transport_reset_no_sock(t, pkt);
+					le32_to_cpu(hdr->len),
+					le16_to_cpu(hdr->type),
+					le16_to_cpu(hdr->op),
+					le32_to_cpu(hdr->flags),
+					le32_to_cpu(hdr->buf_alloc),
+					le32_to_cpu(hdr->fwd_cnt));
+
+	if (!virtio_transport_valid_type(le16_to_cpu(hdr->type))) {
+		(void)virtio_transport_reset_no_sock(t, skb);
 		goto free_pkt;
 	}
 
@@ -1273,13 +1246,13 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	if (!sk) {
 		sk = vsock_find_bound_socket(&dst);
 		if (!sk) {
-			(void)virtio_transport_reset_no_sock(t, pkt);
+			(void)virtio_transport_reset_no_sock(t, skb);
 			goto free_pkt;
 		}
 	}
 
-	if (virtio_transport_get_type(sk) != le16_to_cpu(pkt->hdr.type)) {
-		(void)virtio_transport_reset_no_sock(t, pkt);
+	if (virtio_transport_get_type(sk) != le16_to_cpu(hdr->type)) {
+		(void)virtio_transport_reset_no_sock(t, skb);
 		sock_put(sk);
 		goto free_pkt;
 	}
@@ -1290,13 +1263,13 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	/* Check if sk has been closed before lock_sock */
 	if (sock_flag(sk, SOCK_DONE)) {
-		(void)virtio_transport_reset_no_sock(t, pkt);
+		(void)virtio_transport_reset_no_sock(t, skb);
 		release_sock(sk);
 		sock_put(sk);
 		goto free_pkt;
 	}
 
-	space_available = virtio_transport_space_update(sk, pkt);
+	space_available = virtio_transport_space_update(sk, skb);
 
 	/* Update CID in case it has changed after a transport reset event */
 	if (vsk->local_addr.svm_cid != VMADDR_CID_ANY)
@@ -1307,23 +1280,23 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	switch (sk->sk_state) {
 	case TCP_LISTEN:
-		virtio_transport_recv_listen(sk, pkt, t);
-		virtio_transport_free_pkt(pkt);
+		virtio_transport_recv_listen(sk, skb, t);
+		kfree_skb(skb);
 		break;
 	case TCP_SYN_SENT:
-		virtio_transport_recv_connecting(sk, pkt);
-		virtio_transport_free_pkt(pkt);
+		virtio_transport_recv_connecting(sk, skb);
+		kfree_skb(skb);
 		break;
 	case TCP_ESTABLISHED:
-		virtio_transport_recv_connected(sk, pkt);
+		virtio_transport_recv_connected(sk, skb);
 		break;
 	case TCP_CLOSING:
-		virtio_transport_recv_disconnecting(sk, pkt);
-		virtio_transport_free_pkt(pkt);
+		virtio_transport_recv_disconnecting(sk, skb);
+		kfree_skb(skb);
 		break;
 	default:
-		(void)virtio_transport_reset_no_sock(t, pkt);
-		virtio_transport_free_pkt(pkt);
+		(void)virtio_transport_reset_no_sock(t, skb);
+		kfree_skb(skb);
 		break;
 	}
 
@@ -1336,16 +1309,42 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	return;
 
 free_pkt:
-	virtio_transport_free_pkt(pkt);
+	kfree(skb);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
 
-void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
+/* Remove skbs found in a queue that have a vsk that matches.
+ *
+ * Each skb is freed.
+ *
+ * Returns the count of skbs that were reply packets.
+ */
+int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *queue)
 {
-	kfree(pkt->buf);
-	kfree(pkt);
+	int cnt = 0;
+	struct sk_buff *skb, *tmp;
+	struct sk_buff_head freeme;
+
+	skb_queue_head_init(&freeme);
+
+	spin_lock_bh(&queue->lock);
+	skb_queue_walk_safe(queue, skb, tmp) {
+		if (vsock_sk(skb->sk) != vsk)
+			continue;
+
+		__skb_unlink(skb, queue);
+		skb_queue_tail(&freeme, skb);
+
+		if (vsock_metadata(skb)->flags & VIRTIO_VSOCK_METADATA_FLAGS_REPLY)
+			cnt++;
+	}
+	spin_unlock_bh(&queue->lock);
+
+	skb_queue_purge(&freeme);
+
+	return cnt;
 }
-EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
+EXPORT_SYMBOL_GPL(virtio_transport_purge_skbs);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Asias He");
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 169a8cf65b39..792128e66869 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -16,7 +16,7 @@ struct vsock_loopback {
 	struct workqueue_struct *workqueue;
 
 	spinlock_t pkt_list_lock; /* protects pkt_list */
-	struct list_head pkt_list;
+	struct sk_buff_head pkt_queue;
 	struct work_struct pkt_work;
 };
 
@@ -27,13 +27,13 @@ static u32 vsock_loopback_get_local_cid(void)
 	return VMADDR_CID_LOCAL;
 }
 
-static int vsock_loopback_send_pkt(struct virtio_vsock_pkt *pkt)
+static int vsock_loopback_send_pkt(struct sk_buff *skb)
 {
 	struct vsock_loopback *vsock = &the_vsock_loopback;
-	int len = pkt->len;
+	int len = skb->len;
 
 	spin_lock_bh(&vsock->pkt_list_lock);
-	list_add_tail(&pkt->list, &vsock->pkt_list);
+	skb_queue_tail(&vsock->pkt_queue, skb);
 	spin_unlock_bh(&vsock->pkt_list_lock);
 
 	queue_work(vsock->workqueue, &vsock->pkt_work);
@@ -44,21 +44,8 @@ static int vsock_loopback_send_pkt(struct virtio_vsock_pkt *pkt)
 static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct vsock_loopback *vsock = &the_vsock_loopback;
-	struct virtio_vsock_pkt *pkt, *n;
-	LIST_HEAD(freeme);
 
-	spin_lock_bh(&vsock->pkt_list_lock);
-	list_for_each_entry_safe(pkt, n, &vsock->pkt_list, list) {
-		if (pkt->vsk != vsk)
-			continue;
-		list_move(&pkt->list, &freeme);
-	}
-	spin_unlock_bh(&vsock->pkt_list_lock);
-
-	list_for_each_entry_safe(pkt, n, &freeme, list) {
-		list_del(&pkt->list);
-		virtio_transport_free_pkt(pkt);
-	}
+	virtio_transport_purge_skbs(vsk, &vsock->pkt_queue);
 
 	return 0;
 }
@@ -121,20 +108,18 @@ static void vsock_loopback_work(struct work_struct *work)
 {
 	struct vsock_loopback *vsock =
 		container_of(work, struct vsock_loopback, pkt_work);
-	LIST_HEAD(pkts);
+	struct sk_buff_head pkts;
+	struct sk_buff *skb;
+
+	skb_queue_head_init(&pkts);
 
 	spin_lock_bh(&vsock->pkt_list_lock);
-	list_splice_init(&vsock->pkt_list, &pkts);
+	skb_queue_splice_init(&vsock->pkt_queue, &pkts);
 	spin_unlock_bh(&vsock->pkt_list_lock);
 
-	while (!list_empty(&pkts)) {
-		struct virtio_vsock_pkt *pkt;
-
-		pkt = list_first_entry(&pkts, struct virtio_vsock_pkt, list);
-		list_del_init(&pkt->list);
-
-		virtio_transport_deliver_tap_pkt(pkt);
-		virtio_transport_recv_pkt(&loopback_transport, pkt);
+	while ((skb = skb_dequeue(&pkts))) {
+		virtio_transport_deliver_tap_pkt(skb);
+		virtio_transport_recv_pkt(&loopback_transport, skb);
 	}
 }
 
@@ -148,7 +133,7 @@ static int __init vsock_loopback_init(void)
 		return -ENOMEM;
 
 	spin_lock_init(&vsock->pkt_list_lock);
-	INIT_LIST_HEAD(&vsock->pkt_list);
+	skb_queue_head_init(&vsock->pkt_queue);
 	INIT_WORK(&vsock->pkt_work, vsock_loopback_work);
 
 	ret = vsock_core_register(&loopback_transport.transport,
@@ -166,19 +151,13 @@ static int __init vsock_loopback_init(void)
 static void __exit vsock_loopback_exit(void)
 {
 	struct vsock_loopback *vsock = &the_vsock_loopback;
-	struct virtio_vsock_pkt *pkt;
 
 	vsock_core_unregister(&loopback_transport.transport);
 
 	flush_work(&vsock->pkt_work);
 
 	spin_lock_bh(&vsock->pkt_list_lock);
-	while (!list_empty(&vsock->pkt_list)) {
-		pkt = list_first_entry(&vsock->pkt_list,
-				       struct virtio_vsock_pkt, list);
-		list_del(&pkt->list);
-		virtio_transport_free_pkt(pkt);
-	}
+	skb_queue_purge(&vsock->pkt_queue);
 	spin_unlock_bh(&vsock->pkt_list_lock);
 
 	destroy_workqueue(vsock->workqueue);
-- 
2.35.1

