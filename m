Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC06C64B32A
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 11:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbiLMKXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 05:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbiLMKXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 05:23:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF022AFA
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670926963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WOdJZ4+YAA99rLyfuCyUEChk2/0d6Aa8xLZq7S9j/ZQ=;
        b=eXmBO6SNiiNt3dExO/G40KPPVsI/fw0m3E3155J+f1mUSprPl4KfOq4w/QsShgLBUzkT++
        Ti215nOAB47I6b/OYbmpe99ouBDKLkqZ/GmIzgL/4YJUvPiZMsgXb0XJeq9EMfMi9PZ4Wp
        HkL3Anxfk2Uqp6v7+fVtpSPQ9ckYLe4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-H-MRfDWkPIq4dCRzL7rAmA-1; Tue, 13 Dec 2022 05:22:40 -0500
X-MC-Unique: H-MRfDWkPIq4dCRzL7rAmA-1
Received: by mail-ed1-f72.google.com with SMTP id z16-20020a05640235d000b0046d0912ae25so6898215edc.5
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:22:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOdJZ4+YAA99rLyfuCyUEChk2/0d6Aa8xLZq7S9j/ZQ=;
        b=c7NprOpMxhzXawu/E+f9cpfrDDy4X0OuaijB9qEhHzhWFhtn+CSlVUrpvNxhdZ4mwt
         mxrv8aJMZZbwe+1fdpPwHdlgf8r0MAMWZb3s4ikI5gku/32j2047x7e/luvtDtFUZEwd
         gK02+TM+EXWahIiFN7F9v2Hf2u9gmRHKL/IOJsx0fFae79wUEkmC6cg8g7mPbQDuhFKZ
         aUtXgHzwiQ2aE//h1Erg86Y59pWuik65KWfneZ52QCng9Jy8DO4PCS35aDBJZ64+2x0X
         t4GlhVxQvHRczo/D7tfa/kQ+0tGjv+gFsWd+ZkRaMpDCTK5zrcSEEy0RvFgn8L0Er+kx
         /M+g==
X-Gm-Message-State: ANoB5pmafqkZpXTEzYH8nSp0Tp9eeaS7nKCAlrvsf2KhCObrUN6/uPR7
        pMWo++x6vwteeEIsZyg8WPk6HMALf/dOFjnMAvWyDXN3fH2LXgIy9NF1zRB6RYE4FR00L/CJZXo
        Q+p2bbDuipRja4QWG
X-Received: by 2002:a17:906:4c98:b0:7ad:b14f:dea4 with SMTP id q24-20020a1709064c9800b007adb14fdea4mr16898783eju.14.1670926959181;
        Tue, 13 Dec 2022 02:22:39 -0800 (PST)
X-Google-Smtp-Source: AA0mqf62A0CHJ+LRqF/5S71nWJ/QeQckzlBLQXLyr6RWlAWstxYEjrumFkhQ7u1Pf72YneFBQz8BmQ==
X-Received: by 2002:a17:906:4c98:b0:7ad:b14f:dea4 with SMTP id q24-20020a1709064c9800b007adb14fdea4mr16898752eju.14.1670926958667;
        Tue, 13 Dec 2022 02:22:38 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id d4-20020a170906304400b007c0934db0e0sm4421794ejd.141.2022.12.13.02.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 02:22:37 -0800 (PST)
Date:   Tue, 13 Dec 2022 11:22:32 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
Message-ID: <20221213102232.n2mc3y7ietabncax@sgarzare-redhat>
References: <20221213072549.1997724-1-bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221213072549.1997724-1-bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 07:25:49AM +0000, Bobby Eshleman wrote:
>This commit changes virtio/vsock to use sk_buff instead of
>virtio_vsock_pkt. Beyond better conforming to other net code, using
>sk_buff allows vsock to use sk_buff-dependent features in the future
>(such as sockmap) and improves throughput.
>
>This patch introduces the following performance changes:
>
>Tool/Config: uperf w/ 64 threads, SOCK_STREAM
>Test Runs: 5, mean of results
>Before: commit 95ec6bce2a0b ("Merge branch 'net-ipa-more-endpoints'")
>
>Test: 64KB, g2h
>Before: 21.63 Gb/s
>After: 25.59 Gb/s (+18%)
>
>Test: 16B, g2h
>Before: 11.86 Mb/s
>After: 17.41 Mb/s (+46%)
>
>Test: 64KB, h2g
>Before: 2.15 Gb/s
>After: 3.6 Gb/s (+67%)
>
>Test: 16B, h2g
>Before: 14.38 Mb/s
>After: 18.43 Mb/s (+28%)
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
>
>Note: v6 was only tested from basic sanity checking in uperf, socat, and
>the vsock_test tests in the mainline, but not the new tests from
>Arseniy's test/vsock patches.

I tested with Arseniy's test/vsock patches applied and everything looks 
good!

I left just a couple of comments above based on Paolo review on v5 
related to skb_queue_empty_lockless().

>
>Changes in v6:
>- use skb->cb instead of skb->_skb_refdst
>- use lock-free __skb_queue_purge for rx_queue when rx_lock held
>
>Changes in v5:
>- last_skb instead of skb: last_hdr->len = cpu_to_le32(last_skb->len)
>
>Changes in v4:
>- vdso/bits.h -> linux/bits.h
>- add virtio_vsock_alloc_skb() helper
>- virtio/vsock: rename buf_len -> total_len
>- update last_hdr->len
>- fix build_skb() for vsockmon (tested)
>- add queue helpers
>- use spin_{unlock/lock}_bh() instead of spin_lock()/spin_unlock()
>- note: I only ran a few g2h tests to check that this change
>  had no perf impact. The above data is still from patch
>  v3.
>
>Changes in v3:
>- fix seqpacket bug
>- use zero in vhost_add_used(..., 0) device doesn't write to buffer
>- use xmas tree style declarations
>- vsock_hdr() -> virtio_vsock_hdr() and other include file style fixes
>- no skb merging
>- save space by not using vsock_metadata
>- use _skb_refdst instead of skb buffer space for flags
>- use skb_pull() to keep track of read bytes instead of using an an
>  extra variable 'off' in the skb buffer space
>- remove unnecessary sk_allocation assignment
>- do not zero hdr needlessly
>- introduce virtio_transport_skb_len() because skb->len changes now
>- use spin_lock() directly on queue lock instead of sk_buff_head helpers
>  which use spin_lock_irqsave() (e.g., skb_dequeue)
>- do not reduce buffer size to be page size divisible
>- Note: the biggest performance change came from loosening the spinlock
>  variation and not reducing the buffer size.
>
>Changes in v2:
>- Use alloc_skb() directly instead of sock_alloc_send_pskb() to minimize
>  uAPI changes.
>- Do not marshal errors to -ENOMEM for non-virtio implementations.
>- No longer a part of the original series
>- Some code cleanup and refactoring
>- Include performance stats
>
> drivers/vhost/vsock.c                   | 213 +++++-------
> include/linux/virtio_vsock.h            | 132 ++++++--
> net/vmw_vsock/virtio_transport.c        | 149 +++------
> net/vmw_vsock/virtio_transport_common.c | 422 +++++++++++++-----------
> net/vmw_vsock/vsock_loopback.c          |  51 +--
> 5 files changed, 501 insertions(+), 466 deletions(-)
>
> drivers/vhost/vsock.c                   | 213 +++++-------
> include/linux/virtio_vsock.h            | 132 ++++++--
> net/vmw_vsock/virtio_transport.c        | 149 +++------
> net/vmw_vsock/virtio_transport_common.c | 422 +++++++++++++-----------
> net/vmw_vsock/vsock_loopback.c          |  51 +--
> 5 files changed, 501 insertions(+), 466 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5703775af129..2a5994b029b2 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -51,8 +51,7 @@ struct vhost_vsock {
> 	struct hlist_node hash;
>
> 	struct vhost_work send_pkt_work;
>-	spinlock_t send_pkt_list_lock;
>-	struct list_head send_pkt_list;	/* host->guest pending packets */
>+	struct sk_buff_head send_pkt_queue; /* host->guest pending packets */
>
> 	atomic_t queued_replies;
>
>@@ -108,40 +107,33 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 	vhost_disable_notify(&vsock->dev, vq);
>
> 	do {
>-		struct virtio_vsock_pkt *pkt;
>+		struct virtio_vsock_hdr *hdr;
>+		size_t iov_len, payload_len;
> 		struct iov_iter iov_iter;
>+		u32 flags_to_restore = 0;
>+		struct sk_buff *skb;
> 		unsigned out, in;
> 		size_t nbytes;
>-		size_t iov_len, payload_len;
> 		int head;
>-		u32 flags_to_restore = 0;
>
>-		spin_lock_bh(&vsock->send_pkt_list_lock);
>-		if (list_empty(&vsock->send_pkt_list)) {
>-			spin_unlock_bh(&vsock->send_pkt_list_lock);
>+		spin_lock(&vsock->send_pkt_queue.lock);
>+		skb = __skb_dequeue(&vsock->send_pkt_queue);
>+		spin_unlock(&vsock->send_pkt_queue.lock);
>+
>+		if (!skb) {
> 			vhost_enable_notify(&vsock->dev, vq);
> 			break;
> 		}
>
>-		pkt = list_first_entry(&vsock->send_pkt_list,
>-				       struct virtio_vsock_pkt, list);
>-		list_del_init(&pkt->list);
>-		spin_unlock_bh(&vsock->send_pkt_list_lock);
>-
> 		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> 					 &out, &in, NULL, NULL);
> 		if (head < 0) {
>-			spin_lock_bh(&vsock->send_pkt_list_lock);
>-			list_add(&pkt->list, &vsock->send_pkt_list);
>-			spin_unlock_bh(&vsock->send_pkt_list_lock);
>+			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
> 			break;
> 		}
>
> 		if (head == vq->num) {
>-			spin_lock_bh(&vsock->send_pkt_list_lock);
>-			list_add(&pkt->list, &vsock->send_pkt_list);
>-			spin_unlock_bh(&vsock->send_pkt_list_lock);
>-
>+			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
> 			/* We cannot finish yet if more buffers snuck in while
> 			 * re-enabling notify.
> 			 */
>@@ -153,26 +145,27 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		}
>
> 		if (out) {
>-			virtio_transport_free_pkt(pkt);
>+			kfree_skb(skb);
> 			vq_err(vq, "Expected 0 output buffers, got %u\n", out);
> 			break;
> 		}
>
> 		iov_len = iov_length(&vq->iov[out], in);
>-		if (iov_len < sizeof(pkt->hdr)) {
>-			virtio_transport_free_pkt(pkt);
>+		if (iov_len < sizeof(*hdr)) {
>+			kfree_skb(skb);
> 			vq_err(vq, "Buffer len [%zu] too small\n", iov_len);
> 			break;
> 		}
>
> 		iov_iter_init(&iov_iter, READ, &vq->iov[out], in, iov_len);
>-		payload_len = pkt->len - pkt->off;
>+		payload_len = skb->len;
>+		hdr = virtio_vsock_hdr(skb);
>
> 		/* If the packet is greater than the space available in the
> 		 * buffer, we split it using multiple buffers.
> 		 */
>-		if (payload_len > iov_len - sizeof(pkt->hdr)) {
>-			payload_len = iov_len - sizeof(pkt->hdr);
>+		if (payload_len > iov_len - sizeof(*hdr)) {
>+			payload_len = iov_len - sizeof(*hdr);
>
> 			/* As we are copying pieces of large packet's buffer to
> 			 * small rx buffers, headers of packets in rx 
> 			 queue are
>@@ -185,31 +178,30 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 			 * bits set. After initialized header will be copied to
> 			 * rx buffer, these required bits will be restored.
> 			 */
>-			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
>-				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>+			if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) {
>+				hdr->flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
> 				flags_to_restore |= 
> 				VIRTIO_VSOCK_SEQ_EOM;
>
>-				if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
>-					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+				if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOR) {
>+					hdr->flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
> 					flags_to_restore |= VIRTIO_VSOCK_SEQ_EOR;
> 				}
> 			}
> 		}
>
> 		/* Set the correct length in the header */
>-		pkt->hdr.len = cpu_to_le32(payload_len);
>+		hdr->len = cpu_to_le32(payload_len);
>
>-		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
>-		if (nbytes != sizeof(pkt->hdr)) {
>-			virtio_transport_free_pkt(pkt);
>+		nbytes = copy_to_iter(hdr, sizeof(*hdr), &iov_iter);
>+		if (nbytes != sizeof(*hdr)) {
>+			kfree_skb(skb);
> 			vq_err(vq, "Faulted on copying pkt hdr\n");
> 			break;
> 		}
>
>-		nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
>-				      &iov_iter);
>+		nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
> 		if (nbytes != payload_len) {
>-			virtio_transport_free_pkt(pkt);
>+			kfree_skb(skb);
> 			vq_err(vq, "Faulted on copying pkt buf\n");
> 			break;
> 		}
>@@ -217,31 +209,28 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		/* Deliver to monitoring devices all packets that we
> 		 * will transmit.
> 		 */
>-		virtio_transport_deliver_tap_pkt(pkt);
>+		virtio_transport_deliver_tap_pkt(skb);
>
>-		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
>+		vhost_add_used(vq, head, sizeof(*hdr) + payload_len);
> 		added = true;
>
>-		pkt->off += payload_len;
>+		skb_pull(skb, payload_len);
> 		total_len += payload_len;
>
> 		/* If we didn't send all the payload we can requeue the packet
> 		 * to send it with the next available buffer.
> 		 */
>-		if (pkt->off < pkt->len) {
>-			pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
>+		if (skb->len > 0) {
>+			hdr->flags |= cpu_to_le32(flags_to_restore);
>
>-			/* We are queueing the same virtio_vsock_pkt to handle
>+			/* We are queueing the same skb to handle
> 			 * the remaining bytes, and we want to deliver it
> 			 * to monitoring devices in the next iteration.
> 			 */
>-			pkt->tap_delivered = false;
>-
>-			spin_lock_bh(&vsock->send_pkt_list_lock);
>-			list_add(&pkt->list, &vsock->send_pkt_list);
>-			spin_unlock_bh(&vsock->send_pkt_list_lock);
>+			virtio_vsock_skb_clear_tap_delivered(skb);
>+			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
> 		} else {
>-			if (pkt->reply) {
>+			if (virtio_vsock_skb_reply(skb)) {
> 				int val;
>
> 				val = 
> 				atomic_dec_return(&vsock->queued_replies);
>@@ -253,7 +242,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 					restart_tx = true;
> 			}
>
>-			virtio_transport_free_pkt(pkt);
>+			consume_skb(skb);
> 		}
> 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
> 	if (added)
>@@ -278,28 +267,26 @@ static void vhost_transport_send_pkt_work(struct vhost_work *work)
> }
>
> static int
>-vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
>+vhost_transport_send_pkt(struct sk_buff *skb)
> {
>+	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
> 	struct vhost_vsock *vsock;
>-	int len = pkt->len;
>+	int len = skb->len;
>
> 	rcu_read_lock();
>
> 	/* Find the vhost_vsock according to guest context id  */
>-	vsock = vhost_vsock_get(le64_to_cpu(pkt->hdr.dst_cid));
>+	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid));
> 	if (!vsock) {
> 		rcu_read_unlock();
>-		virtio_transport_free_pkt(pkt);
>+		kfree_skb(skb);
> 		return -ENODEV;
> 	}
>
>-	if (pkt->reply)
>+	if (virtio_vsock_skb_reply(skb))
> 		atomic_inc(&vsock->queued_replies);
>
>-	spin_lock_bh(&vsock->send_pkt_list_lock);
>-	list_add_tail(&pkt->list, &vsock->send_pkt_list);
>-	spin_unlock_bh(&vsock->send_pkt_list_lock);
>-
>+	virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
> 	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
>
> 	rcu_read_unlock();
>@@ -310,10 +297,8 @@ static int
> vhost_transport_cancel_pkt(struct vsock_sock *vsk)
> {
> 	struct vhost_vsock *vsock;
>-	struct virtio_vsock_pkt *pkt, *n;
> 	int cnt = 0;
> 	int ret = -ENODEV;
>-	LIST_HEAD(freeme);
>
> 	rcu_read_lock();
>
>@@ -322,20 +307,7 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
> 	if (!vsock)
> 		goto out;
>
>-	spin_lock_bh(&vsock->send_pkt_list_lock);
>-	list_for_each_entry_safe(pkt, n, &vsock->send_pkt_list, list) {
>-		if (pkt->vsk != vsk)
>-			continue;
>-		list_move(&pkt->list, &freeme);
>-	}
>-	spin_unlock_bh(&vsock->send_pkt_list_lock);
>-
>-	list_for_each_entry_safe(pkt, n, &freeme, list) {
>-		if (pkt->reply)
>-			cnt++;
>-		list_del(&pkt->list);
>-		virtio_transport_free_pkt(pkt);
>-	}
>+	cnt = virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
>
> 	if (cnt) {
> 		struct vhost_virtqueue *tx_vq = &vsock->vqs[VSOCK_VQ_TX];
>@@ -352,12 +324,14 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
> 	return ret;
> }
>
>-static struct virtio_vsock_pkt *
>-vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
>+static struct sk_buff *
>+vhost_vsock_alloc_skb(struct vhost_virtqueue *vq,
> 		      unsigned int out, unsigned int in)
> {
>-	struct virtio_vsock_pkt *pkt;
>+	struct virtio_vsock_hdr *hdr;
> 	struct iov_iter iov_iter;
>+	struct sk_buff *skb;
>+	size_t payload_len;
> 	size_t nbytes;
> 	size_t len;
>
>@@ -366,50 +340,47 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> 		return NULL;
> 	}
>
>-	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
>-	if (!pkt)
>+	len = iov_length(vq->iov, out);
>+
>+	/* len contains both payload and hdr */
>+	skb = virtio_vsock_alloc_skb(len, GFP_KERNEL);
>+	if (!skb)
> 		return NULL;
>
>-	len = iov_length(vq->iov, out);
> 	iov_iter_init(&iov_iter, WRITE, vq->iov, out, len);
>
>-	nbytes = copy_from_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
>-	if (nbytes != sizeof(pkt->hdr)) {
>+	hdr = virtio_vsock_hdr(skb);
>+	nbytes = copy_from_iter(hdr, sizeof(*hdr), &iov_iter);
>+	if (nbytes != sizeof(*hdr)) {
> 		vq_err(vq, "Expected %zu bytes for pkt->hdr, got %zu bytes\n",
>-		       sizeof(pkt->hdr), nbytes);
>-		kfree(pkt);
>+		       sizeof(*hdr), nbytes);
>+		kfree_skb(skb);
> 		return NULL;
> 	}
>
>-	pkt->len = le32_to_cpu(pkt->hdr.len);
>+	payload_len = le32_to_cpu(hdr->len);
>
> 	/* No payload */
>-	if (!pkt->len)
>-		return pkt;
>+	if (!payload_len)
>+		return skb;
>
> 	/* The pkt is too big */
>-	if (pkt->len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
>-		kfree(pkt);
>+	if (payload_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
>+		kfree_skb(skb);
> 		return NULL;
> 	}
>
>-	pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
>-	if (!pkt->buf) {
>-		kfree(pkt);
>-		return NULL;
>-	}
>+	virtio_vsock_skb_rx_put(skb);
>
>-	pkt->buf_len = pkt->len;
>-
>-	nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
>-	if (nbytes != pkt->len) {
>-		vq_err(vq, "Expected %u byte payload, got %zu bytes\n",
>-		       pkt->len, nbytes);
>-		virtio_transport_free_pkt(pkt);
>+	nbytes = copy_from_iter(skb->data, payload_len, &iov_iter);
>+	if (nbytes != payload_len) {
>+		vq_err(vq, "Expected %zu byte payload, got %zu bytes\n",
>+		       payload_len, nbytes);
>+		kfree_skb(skb);
> 		return NULL;
> 	}
>
>-	return pkt;
>+	return skb;
> }
>
> /* Is there space left for replies to rx packets? */
>@@ -496,9 +467,9 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> 						  poll.work);
> 	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
> 						 dev);
>-	struct virtio_vsock_pkt *pkt;
> 	int head, pkts = 0, total_len = 0;
> 	unsigned int out, in;
>+	struct sk_buff *skb;
> 	bool added = false;
>
> 	mutex_lock(&vq->mutex);
>@@ -511,6 +482,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>
> 	vhost_disable_notify(&vsock->dev, vq);
> 	do {
>+		struct virtio_vsock_hdr *hdr;
>+
> 		if (!vhost_vsock_more_replies(vsock)) {
> 			/* Stop tx until the device processes already
> 			 * pending replies.  Leave tx virtqueue
>@@ -532,24 +505,26 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> 			break;
> 		}
>
>-		pkt = vhost_vsock_alloc_pkt(vq, out, in);
>-		if (!pkt) {
>+		skb = vhost_vsock_alloc_skb(vq, out, in);
>+		if (!skb) {
> 			vq_err(vq, "Faulted on pkt\n");
> 			continue;
> 		}
>
>-		total_len += sizeof(pkt->hdr) + pkt->len;
>+		total_len += sizeof(*hdr) + skb->len;
>
> 		/* Deliver to monitoring devices all received packets */
>-		virtio_transport_deliver_tap_pkt(pkt);
>+		virtio_transport_deliver_tap_pkt(skb);
>+
>+		hdr = virtio_vsock_hdr(skb);
>
> 		/* Only accept correctly addressed packets */
>-		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid &&
>-		    le64_to_cpu(pkt->hdr.dst_cid) ==
>+		if (le64_to_cpu(hdr->src_cid) == vsock->guest_cid &&
>+		    le64_to_cpu(hdr->dst_cid) ==
> 		    vhost_transport_get_local_cid())
>-			virtio_transport_recv_pkt(&vhost_transport, pkt);
>+			virtio_transport_recv_pkt(&vhost_transport, skb);
> 		else
>-			virtio_transport_free_pkt(pkt);
>+			kfree_skb(skb);
>
> 		vhost_add_used(vq, head, 0);
> 		added = true;
>@@ -693,8 +668,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
> 		       VHOST_VSOCK_WEIGHT, true, NULL);
>
> 	file->private_data = vsock;
>-	spin_lock_init(&vsock->send_pkt_list_lock);
>-	INIT_LIST_HEAD(&vsock->send_pkt_list);
>+	skb_queue_head_init(&vsock->send_pkt_queue);
> 	vhost_work_init(&vsock->send_pkt_work, vhost_transport_send_pkt_work);
> 	return 0;
>
>@@ -760,16 +734,7 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
> 	vhost_vsock_flush(vsock);
> 	vhost_dev_stop(&vsock->dev);
>
>-	spin_lock_bh(&vsock->send_pkt_list_lock);
>-	while (!list_empty(&vsock->send_pkt_list)) {
>-		struct virtio_vsock_pkt *pkt;
>-
>-		pkt = list_first_entry(&vsock->send_pkt_list,
>-				struct virtio_vsock_pkt, list);
>-		list_del_init(&pkt->list);
>-		virtio_transport_free_pkt(pkt);
>-	}
>-	spin_unlock_bh(&vsock->send_pkt_list_lock);
>+	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
>
> 	vhost_dev_cleanup(&vsock->dev);
> 	kfree(vsock->dev.vqs);
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 35d7eedb5e8e..0385df976d41 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -3,10 +3,116 @@
> #define _LINUX_VIRTIO_VSOCK_H
>
> #include <uapi/linux/virtio_vsock.h>
>+#include <linux/bits.h>
> #include <linux/socket.h>
> #include <net/sock.h>
> #include <net/af_vsock.h>
>
>+#define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
>+
>+enum virtio_vsock_skb_flags {
>+	VIRTIO_VSOCK_SKB_FLAGS_REPLY		= BIT(0),
>+	VIRTIO_VSOCK_SKB_FLAGS_TAP_DELIVERED	= BIT(1),
>+};
>+
>+struct virtio_vsock_skb_cb {
>+	bool reply;
>+	bool tap_delivered;
>+};
>+
>+#define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))
>+
>+static inline struct virtio_vsock_hdr *virtio_vsock_hdr(struct sk_buff *skb)
>+{
>+	return (struct virtio_vsock_hdr *)skb->head;
>+}
>+
>+static inline bool virtio_vsock_skb_reply(struct sk_buff *skb)
>+{
>+	return VIRTIO_VSOCK_SKB_CB(skb)->reply;
>+}
>+
>+static inline void virtio_vsock_skb_set_reply(struct sk_buff *skb)
>+{
>+	VIRTIO_VSOCK_SKB_CB(skb)->reply = true;
>+}
>+
>+static inline bool virtio_vsock_skb_tap_delivered(struct sk_buff *skb)
>+{
>+	return VIRTIO_VSOCK_SKB_CB(skb)->tap_delivered;
>+}
>+
>+static inline void virtio_vsock_skb_set_tap_delivered(struct sk_buff *skb)
>+{
>+	VIRTIO_VSOCK_SKB_CB(skb)->tap_delivered = true;
>+}
>+
>+static inline void virtio_vsock_skb_clear_tap_delivered(struct sk_buff *skb)
>+{
>+	VIRTIO_VSOCK_SKB_CB(skb)->tap_delivered = false;
>+}
>+
>+static inline void virtio_vsock_skb_rx_put(struct sk_buff *skb)
>+{
>+	u32 len;
>+
>+	len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
>+
>+	if (len > 0)
>+		skb_put(skb, len);
>+}
>+
>+static inline struct sk_buff *virtio_vsock_alloc_skb(unsigned int size, gfp_t mask)
>+{
>+	struct sk_buff *skb;
>+
>+	skb = alloc_skb(size, mask);
>+	if (!skb)
>+		return NULL;
>+
>+	skb_reserve(skb, VIRTIO_VSOCK_SKB_HEADROOM);
>+	return skb;
>+}
>+
>+static inline void
>+virtio_vsock_skb_queue_head(struct sk_buff_head *list, struct sk_buff *skb)
>+{
>+	spin_lock_bh(&list->lock);
>+	__skb_queue_head(list, skb);
>+	spin_unlock_bh(&list->lock);
>+}
>+
>+static inline void
>+virtio_vsock_skb_queue_tail(struct sk_buff_head *list, struct sk_buff *skb)
>+{
>+	spin_lock_bh(&list->lock);
>+	__skb_queue_tail(list, skb);
>+	spin_unlock_bh(&list->lock);
>+}
>+
>+static inline struct sk_buff *virtio_vsock_skb_dequeue(struct sk_buff_head *list)
>+{
>+	struct sk_buff *skb;
>+
>+	spin_lock_bh(&list->lock);
>+	skb = __skb_dequeue(list);
>+	spin_unlock_bh(&list->lock);
>+
>+	return skb;
>+}
>+
>+static inline void virtio_vsock_skb_queue_purge(struct sk_buff_head *list)
>+{
>+	spin_lock_bh(&list->lock);
>+	__skb_queue_purge(list);
>+	spin_unlock_bh(&list->lock);
>+}
>+
>+static inline size_t virtio_vsock_skb_len(struct sk_buff *skb)
>+{
>+	return (size_t)(skb_end_pointer(skb) - skb->head);
>+}
>+
> #define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
> #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
> #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
>@@ -35,23 +141,10 @@ struct virtio_vsock_sock {
> 	u32 last_fwd_cnt;
> 	u32 rx_bytes;
> 	u32 buf_alloc;
>-	struct list_head rx_queue;
>+	struct sk_buff_head rx_queue;
> 	u32 msg_count;
> };
>
>-struct virtio_vsock_pkt {
>-	struct virtio_vsock_hdr	hdr;
>-	struct list_head list;
>-	/* socket refcnt not held, only use for cancellation */
>-	struct vsock_sock *vsk;
>-	void *buf;
>-	u32 buf_len;
>-	u32 len;
>-	u32 off;
>-	bool reply;
>-	bool tap_delivered;
>-};
>-
> struct virtio_vsock_pkt_info {
> 	u32 remote_cid, remote_port;
> 	struct vsock_sock *vsk;
>@@ -68,7 +161,7 @@ struct virtio_transport {
> 	struct vsock_transport transport;
>
> 	/* Takes ownership of the packet */
>-	int (*send_pkt)(struct virtio_vsock_pkt *pkt);
>+	int (*send_pkt)(struct sk_buff *skb);
> };
>
> ssize_t
>@@ -149,11 +242,10 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
> void virtio_transport_destruct(struct vsock_sock *vsk);
>
> void virtio_transport_recv_pkt(struct virtio_transport *t,
>-			       struct virtio_vsock_pkt *pkt);
>-void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt);
>-void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt);
>+			       struct sk_buff *skb);
>+void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb);
> u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
> void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>-void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt);
>-
>+void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
>+int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
> #endif /* _LINUX_VIRTIO_VSOCK_H */
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index ad64f403536a..28b5a8e8e094 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -42,8 +42,7 @@ struct virtio_vsock {
> 	bool tx_run;
>
> 	struct work_struct send_pkt_work;
>-	spinlock_t send_pkt_list_lock;
>-	struct list_head send_pkt_list;
>+	struct sk_buff_head send_pkt_queue;
>
> 	atomic_t queued_replies;
>
>@@ -101,41 +100,31 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 	vq = vsock->vqs[VSOCK_VQ_TX];
>
> 	for (;;) {
>-		struct virtio_vsock_pkt *pkt;
> 		struct scatterlist hdr, buf, *sgs[2];
> 		int ret, in_sg = 0, out_sg = 0;
>+		struct sk_buff *skb;
> 		bool reply;
>
>-		spin_lock_bh(&vsock->send_pkt_list_lock);
>-		if (list_empty(&vsock->send_pkt_list)) {
>-			spin_unlock_bh(&vsock->send_pkt_list_lock);
>+		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
>+		if (!skb)
> 			break;
>-		}
>-
>-		pkt = list_first_entry(&vsock->send_pkt_list,
>-				       struct virtio_vsock_pkt, list);
>-		list_del_init(&pkt->list);
>-		spin_unlock_bh(&vsock->send_pkt_list_lock);
>
>-		virtio_transport_deliver_tap_pkt(pkt);
>+		virtio_transport_deliver_tap_pkt(skb);
>+		reply = virtio_vsock_skb_reply(skb);
>
>-		reply = pkt->reply;
>-
>-		sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
>+		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
> 		sgs[out_sg++] = &hdr;
>-		if (pkt->buf) {
>-			sg_init_one(&buf, pkt->buf, pkt->len);
>+		if (skb->len > 0) {
>+			sg_init_one(&buf, skb->data, skb->len);
> 			sgs[out_sg++] = &buf;
> 		}
>
>-		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, pkt, GFP_KERNEL);
>+		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
> 		/* Usually this means that there is no more space available in
> 		 * the vq
> 		 */
> 		if (ret < 0) {
>-			spin_lock_bh(&vsock->send_pkt_list_lock);
>-			list_add(&pkt->list, &vsock->send_pkt_list);
>-			spin_unlock_bh(&vsock->send_pkt_list_lock);
>+			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
> 			break;
> 		}
>
>@@ -164,32 +153,32 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> }
>
> static int
>-virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
>+virtio_transport_send_pkt(struct sk_buff *skb)
> {
>+	struct virtio_vsock_hdr *hdr;
> 	struct virtio_vsock *vsock;
>-	int len = pkt->len;
>+	int len = skb->len;
>+
>+	hdr = virtio_vsock_hdr(skb);
>
> 	rcu_read_lock();
> 	vsock = rcu_dereference(the_virtio_vsock);
> 	if (!vsock) {
>-		virtio_transport_free_pkt(pkt);
>+		kfree_skb(skb);
> 		len = -ENODEV;
> 		goto out_rcu;
> 	}
>
>-	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid) {
>-		virtio_transport_free_pkt(pkt);
>+	if (le64_to_cpu(hdr->dst_cid) == vsock->guest_cid) {
>+		kfree_skb(skb);
> 		len = -ENODEV;
> 		goto out_rcu;
> 	}
>
>-	if (pkt->reply)
>+	if (virtio_vsock_skb_reply(skb))
> 		atomic_inc(&vsock->queued_replies);
>
>-	spin_lock_bh(&vsock->send_pkt_list_lock);
>-	list_add_tail(&pkt->list, &vsock->send_pkt_list);
>-	spin_unlock_bh(&vsock->send_pkt_list_lock);
>-
>+	virtio_vsock_skb_queue_tail(&vsock->send_pkt_queue, skb);
> 	queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>
> out_rcu:
>@@ -201,9 +190,7 @@ static int
> virtio_transport_cancel_pkt(struct vsock_sock *vsk)
> {
> 	struct virtio_vsock *vsock;
>-	struct virtio_vsock_pkt *pkt, *n;
> 	int cnt = 0, ret;
>-	LIST_HEAD(freeme);
>
> 	rcu_read_lock();
> 	vsock = rcu_dereference(the_virtio_vsock);
>@@ -212,20 +199,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
> 		goto out_rcu;
> 	}
>
>-	spin_lock_bh(&vsock->send_pkt_list_lock);
>-	list_for_each_entry_safe(pkt, n, &vsock->send_pkt_list, list) {
>-		if (pkt->vsk != vsk)
>-			continue;
>-		list_move(&pkt->list, &freeme);
>-	}
>-	spin_unlock_bh(&vsock->send_pkt_list_lock);
>-
>-	list_for_each_entry_safe(pkt, n, &freeme, list) {
>-		if (pkt->reply)
>-			cnt++;
>-		list_del(&pkt->list);
>-		virtio_transport_free_pkt(pkt);
>-	}
>+	cnt = virtio_transport_purge_skbs(vsk, &vsock->send_pkt_queue);
>
> 	if (cnt) {
> 		struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
>@@ -246,38 +220,28 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
>
> static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
> {
>-	int buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
>-	struct virtio_vsock_pkt *pkt;
>-	struct scatterlist hdr, buf, *sgs[2];
>+	int total_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE + VIRTIO_VSOCK_SKB_HEADROOM;
>+	struct scatterlist pkt, *p;
> 	struct virtqueue *vq;
>+	struct sk_buff *skb;
> 	int ret;
>
> 	vq = vsock->vqs[VSOCK_VQ_RX];
>
> 	do {
>-		pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
>-		if (!pkt)
>+		skb = virtio_vsock_alloc_skb(total_len, GFP_KERNEL);
>+		if (!skb)
> 			break;
>
>-		pkt->buf = kmalloc(buf_len, GFP_KERNEL);
>-		if (!pkt->buf) {
>-			virtio_transport_free_pkt(pkt);
>+		memset(skb->head, 0, VIRTIO_VSOCK_SKB_HEADROOM);
>+		sg_init_one(&pkt, virtio_vsock_hdr(skb), total_len);
>+		p = &pkt;
>+		ret = virtqueue_add_sgs(vq, &p, 0, 1, skb, GFP_KERNEL);
>+		if (ret < 0) {
>+			kfree_skb(skb);
> 			break;
> 		}
>
>-		pkt->buf_len = buf_len;
>-		pkt->len = buf_len;
>-
>-		sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
>-		sgs[0] = &hdr;
>-
>-		sg_init_one(&buf, pkt->buf, buf_len);
>-		sgs[1] = &buf;
>-		ret = virtqueue_add_sgs(vq, sgs, 0, 2, pkt, GFP_KERNEL);
>-		if (ret) {
>-			virtio_transport_free_pkt(pkt);
>-			break;
>-		}
> 		vsock->rx_buf_nr++;
> 	} while (vq->num_free);
> 	if (vsock->rx_buf_nr > vsock->rx_buf_max_nr)
>@@ -299,12 +263,12 @@ static void virtio_transport_tx_work(struct work_struct *work)
> 		goto out;
>
> 	do {
>-		struct virtio_vsock_pkt *pkt;
>+		struct sk_buff *skb;
> 		unsigned int len;
>
> 		virtqueue_disable_cb(vq);
>-		while ((pkt = virtqueue_get_buf(vq, &len)) != NULL) {
>-			virtio_transport_free_pkt(pkt);
>+		while ((skb = virtqueue_get_buf(vq, &len)) != NULL) {
>+			consume_skb(skb);
> 			added = true;
> 		}
> 	} while (!virtqueue_enable_cb(vq));
>@@ -529,7 +493,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
> 	do {
> 		virtqueue_disable_cb(vq);
> 		for (;;) {
>-			struct virtio_vsock_pkt *pkt;
>+			struct sk_buff *skb;
> 			unsigned int len;
>
> 			if (!virtio_transport_more_replies(vsock)) {
>@@ -540,23 +504,22 @@ static void virtio_transport_rx_work(struct work_struct *work)
> 				goto out;
> 			}
>
>-			pkt = virtqueue_get_buf(vq, &len);
>-			if (!pkt) {
>+			skb = virtqueue_get_buf(vq, &len);
>+			if (!skb)
> 				break;
>-			}
>
> 			vsock->rx_buf_nr--;
>
> 			/* Drop short/long packets */
>-			if (unlikely(len < sizeof(pkt->hdr) ||
>-				     len > sizeof(pkt->hdr) + pkt->len)) {
>-				virtio_transport_free_pkt(pkt);
>+			if (unlikely(len < sizeof(struct virtio_vsock_hdr) ||
>+				     len > virtio_vsock_skb_len(skb))) {
>+				kfree_skb(skb);
> 				continue;
> 			}
>
>-			pkt->len = len - sizeof(pkt->hdr);
>-			virtio_transport_deliver_tap_pkt(pkt);
>-			virtio_transport_recv_pkt(&virtio_transport, 
>pkt);
>+			virtio_vsock_skb_rx_put(skb);
>+			virtio_transport_deliver_tap_pkt(skb);
>+			virtio_transport_recv_pkt(&virtio_transport, skb);
> 		}
> 	} while (!virtqueue_enable_cb(vq));
>
>@@ -610,7 +573,7 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
> static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
> {
> 	struct virtio_device *vdev = vsock->vdev;
>-	struct virtio_vsock_pkt *pkt;
>+	struct sk_buff *skb;
>
> 	/* Reset all connected sockets when the VQs disappear */
> 	vsock_for_each_connected_socket(&virtio_transport.transport,
>@@ -637,23 +600,16 @@ static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
> 	virtio_reset_device(vdev);
>
> 	mutex_lock(&vsock->rx_lock);
>-	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_RX])))
>-		virtio_transport_free_pkt(pkt);
>+	while ((skb = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_RX])))
>+		kfree_skb(skb);
> 	mutex_unlock(&vsock->rx_lock);
>
> 	mutex_lock(&vsock->tx_lock);
>-	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_TX])))
>-		virtio_transport_free_pkt(pkt);
>+	while ((skb = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_TX])))
>+		kfree_skb(skb);
> 	mutex_unlock(&vsock->tx_lock);
>
>-	spin_lock_bh(&vsock->send_pkt_list_lock);
>-	while (!list_empty(&vsock->send_pkt_list)) {
>-		pkt = list_first_entry(&vsock->send_pkt_list,
>-				       struct virtio_vsock_pkt, list);
>-		list_del(&pkt->list);
>-		virtio_transport_free_pkt(pkt);
>-	}
>-	spin_unlock_bh(&vsock->send_pkt_list_lock);
>+	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
>
> 	/* Delete virtqueues and flush outstanding callbacks if any */
> 	vdev->config->del_vqs(vdev);
>@@ -690,8 +646,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	mutex_init(&vsock->tx_lock);
> 	mutex_init(&vsock->rx_lock);
> 	mutex_init(&vsock->event_lock);
>-	spin_lock_init(&vsock->send_pkt_list_lock);
>-	INIT_LIST_HEAD(&vsock->send_pkt_list);
>+	skb_queue_head_init(&vsock->send_pkt_queue);
> 	INIT_WORK(&vsock->rx_work, virtio_transport_rx_work);
> 	INIT_WORK(&vsock->tx_work, virtio_transport_tx_work);
> 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index a9980e9b9304..3d2b9a4aefae 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -37,53 +37,56 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
> 	return container_of(t, struct virtio_transport, transport);
> }
>
>-static struct virtio_vsock_pkt *
>-virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
>+/* Returns a new packet on success, otherwise returns NULL.
>+ *
>+ * If NULL is returned, errp is set to a negative errno.
>+ */
>+static struct sk_buff *
>+virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> 			   size_t len,
> 			   u32 src_cid,
> 			   u32 src_port,
> 			   u32 dst_cid,
> 			   u32 dst_port)
> {
>-	struct virtio_vsock_pkt *pkt;
>+	const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
>+	struct virtio_vsock_hdr *hdr;
>+	struct sk_buff *skb;
>+	void *payload;
> 	int err;
>
>-	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
>-	if (!pkt)
>+	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
>+	if (!skb)
> 		return NULL;
>
>-	pkt->hdr.type		= cpu_to_le16(info->type);
>-	pkt->hdr.op		= cpu_to_le16(info->op);
>-	pkt->hdr.src_cid	= cpu_to_le64(src_cid);
>-	pkt->hdr.dst_cid	= cpu_to_le64(dst_cid);
>-	pkt->hdr.src_port	= cpu_to_le32(src_port);
>-	pkt->hdr.dst_port	= cpu_to_le32(dst_port);
>-	pkt->hdr.flags		= cpu_to_le32(info->flags);
>-	pkt->len		= len;
>-	pkt->hdr.len		= cpu_to_le32(len);
>-	pkt->reply		= info->reply;
>-	pkt->vsk		= info->vsk;
>+	hdr = virtio_vsock_hdr(skb);
>+	hdr->type	= cpu_to_le16(info->type);
>+	hdr->op		= cpu_to_le16(info->op);
>+	hdr->src_cid	= cpu_to_le64(src_cid);
>+	hdr->dst_cid	= cpu_to_le64(dst_cid);
>+	hdr->src_port	= cpu_to_le32(src_port);
>+	hdr->dst_port	= cpu_to_le32(dst_port);
>+	hdr->flags	= cpu_to_le32(info->flags);
>+	hdr->len	= cpu_to_le32(len);
>
> 	if (info->msg && len > 0) {
>-		pkt->buf = kmalloc(len, GFP_KERNEL);
>-		if (!pkt->buf)
>-			goto out_pkt;
>-
>-		pkt->buf_len = len;
>-
>-		err = memcpy_from_msg(pkt->buf, info->msg, len);
>+		payload = skb_put(skb, len);
>+		err = memcpy_from_msg(payload, info->msg, len);
> 		if (err)
> 			goto out;
>
> 		if (msg_data_left(info->msg) == 0 &&
> 		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
>-			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>+			hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>
> 			if (info->msg->msg_flags & MSG_EOR)
>-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+				hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
> 		}
> 	}
>
>+	if (info->reply)
>+		virtio_vsock_skb_set_reply(skb);
>+
> 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
> 					 dst_cid, dst_port,
> 					 len,
>@@ -91,19 +94,18 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
> 					 info->op,
> 					 info->flags);
>
>-	return pkt;
>+	return skb;
>
> out:
>-	kfree(pkt->buf);
>-out_pkt:
>-	kfree(pkt);
>+	kfree_skb(skb);
> 	return NULL;
> }
>
> /* Packet capture */
> static struct sk_buff *virtio_transport_build_skb(void *opaque)
> {
>-	struct virtio_vsock_pkt *pkt = opaque;
>+	struct virtio_vsock_hdr *pkt_hdr;
>+	struct sk_buff *pkt = opaque;
> 	struct af_vsockmon_hdr *hdr;
> 	struct sk_buff *skb;
> 	size_t payload_len;
>@@ -113,10 +115,11 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 	 * the payload length from the header and the buffer pointer taking
> 	 * care of the offset in the original packet.
> 	 */
>-	payload_len = le32_to_cpu(pkt->hdr.len);
>-	payload_buf = pkt->buf + pkt->off;
>+	pkt_hdr = virtio_vsock_hdr(pkt);
>+	payload_len = pkt->len;
>+	payload_buf = pkt->data;
>
>-	skb = alloc_skb(sizeof(*hdr) + sizeof(pkt->hdr) + payload_len,
>+	skb = alloc_skb(sizeof(*hdr) + sizeof(*pkt_hdr) + payload_len,
> 			GFP_ATOMIC);
> 	if (!skb)
> 		return NULL;
>@@ -124,16 +127,16 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 	hdr = skb_put(skb, sizeof(*hdr));
>
> 	/* pkt->hdr is little-endian so no need to byteswap here */
>-	hdr->src_cid = pkt->hdr.src_cid;
>-	hdr->src_port = pkt->hdr.src_port;
>-	hdr->dst_cid = pkt->hdr.dst_cid;
>-	hdr->dst_port = pkt->hdr.dst_port;
>+	hdr->src_cid = pkt_hdr->src_cid;
>+	hdr->src_port = pkt_hdr->src_port;
>+	hdr->dst_cid = pkt_hdr->dst_cid;
>+	hdr->dst_port = pkt_hdr->dst_port;
>
> 	hdr->transport = cpu_to_le16(AF_VSOCK_TRANSPORT_VIRTIO);
>-	hdr->len = cpu_to_le16(sizeof(pkt->hdr));
>+	hdr->len = cpu_to_le16(sizeof(*pkt_hdr));
> 	memset(hdr->reserved, 0, sizeof(hdr->reserved));
>
>-	switch (le16_to_cpu(pkt->hdr.op)) {
>+	switch (le16_to_cpu(pkt_hdr->op)) {
> 	case VIRTIO_VSOCK_OP_REQUEST:
> 	case VIRTIO_VSOCK_OP_RESPONSE:
> 		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONNECT);
>@@ -154,7 +157,7 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 		break;
> 	}
>
>-	skb_put_data(skb, &pkt->hdr, sizeof(pkt->hdr));
>+	skb_put_data(skb, pkt_hdr, sizeof(*pkt_hdr));
>
> 	if (payload_len) {
> 		skb_put_data(skb, payload_buf, payload_len);
>@@ -163,13 +166,13 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 	return skb;
> }
>
>-void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
>+void virtio_transport_deliver_tap_pkt(struct sk_buff *skb)
> {
>-	if (pkt->tap_delivered)
>+	if (virtio_vsock_skb_tap_delivered(skb))
> 		return;
>
>-	vsock_deliver_tap(virtio_transport_build_skb, pkt);
>-	pkt->tap_delivered = true;
>+	vsock_deliver_tap(virtio_transport_build_skb, skb);
>+	virtio_vsock_skb_set_tap_delivered(skb);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
>
>@@ -192,8 +195,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	u32 src_cid, src_port, dst_cid, dst_port;
> 	const struct virtio_transport *t_ops;
> 	struct virtio_vsock_sock *vvs;
>-	struct virtio_vsock_pkt *pkt;
> 	u32 pkt_len = info->pkt_len;
>+	struct sk_buff *skb;
>
> 	info->type = virtio_transport_get_type(sk_vsock(vsk));
>
>@@ -224,42 +227,47 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> 		return pkt_len;
>
>-	pkt = virtio_transport_alloc_pkt(info, pkt_len,
>+	skb = virtio_transport_alloc_skb(info, pkt_len,
> 					 src_cid, src_port,
> 					 dst_cid, dst_port);
>-	if (!pkt) {
>+	if (!skb) {
> 		virtio_transport_put_credit(vvs, pkt_len);
> 		return -ENOMEM;
> 	}
>
>-	virtio_transport_inc_tx_pkt(vvs, pkt);
>+	virtio_transport_inc_tx_pkt(vvs, skb);
>
>-	return t_ops->send_pkt(pkt);
>+	return t_ops->send_pkt(skb);
> }
>
> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>-					struct virtio_vsock_pkt *pkt)
>+					struct sk_buff *skb)
> {
>-	if (vvs->rx_bytes + pkt->len > vvs->buf_alloc)
>+	if (vvs->rx_bytes + skb->len > vvs->buf_alloc)
> 		return false;
>
>-	vvs->rx_bytes += pkt->len;
>+	vvs->rx_bytes += skb->len;
> 	return true;
> }
>
> static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
>-					struct virtio_vsock_pkt *pkt)
>+					struct sk_buff *skb)
> {
>-	vvs->rx_bytes -= pkt->len;
>-	vvs->fwd_cnt += pkt->len;
>+	int len;
>+
>+	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
>+	vvs->rx_bytes -= len;
>+	vvs->fwd_cnt += len;
> }
>
>-void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt)
>+void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *skb)
> {
>+	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
>+
> 	spin_lock_bh(&vvs->rx_lock);
> 	vvs->last_fwd_cnt = vvs->fwd_cnt;
>-	pkt->hdr.fwd_cnt = cpu_to_le32(vvs->fwd_cnt);
>-	pkt->hdr.buf_alloc = cpu_to_le32(vvs->buf_alloc);
>+	hdr->fwd_cnt = cpu_to_le32(vvs->fwd_cnt);
>+	hdr->buf_alloc = cpu_to_le32(vvs->buf_alloc);
> 	spin_unlock_bh(&vvs->rx_lock);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_inc_tx_pkt);
>@@ -303,29 +311,29 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
> 				size_t len)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
>-	struct virtio_vsock_pkt *pkt;
> 	size_t bytes, total = 0, off;
>+	struct sk_buff *skb, *tmp;
> 	int err = -EFAULT;
>
> 	spin_lock_bh(&vvs->rx_lock);
>
>-	list_for_each_entry(pkt, &vvs->rx_queue, list) {
>-		off = pkt->off;
>+	skb_queue_walk_safe(&vvs->rx_queue, skb,  tmp) {
>+		off = 0;
>
> 		if (total == len)
> 			break;
>
>-		while (total < len && off < pkt->len) {
>+		while (total < len && off < skb->len) {
> 			bytes = len - total;
>-			if (bytes > pkt->len - off)
>-				bytes = pkt->len - off;
>+			if (bytes > skb->len - off)
>+				bytes = skb->len - off;
>
> 			/* sk_lock is held by caller so no one else can dequeue.
> 			 * Unlock rx_lock since memcpy_to_msg() may sleep.
> 			 */
> 			spin_unlock_bh(&vvs->rx_lock);
>
>-			err = memcpy_to_msg(msg, pkt->buf + off, bytes);
>+			err = memcpy_to_msg(msg, skb->data + off, bytes);
> 			if (err)
> 				goto out;
>
>@@ -352,37 +360,38 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 				   size_t len)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
>-	struct virtio_vsock_pkt *pkt;
> 	size_t bytes, total = 0;
>-	u32 free_space;
>+	struct sk_buff *skb;
> 	int err = -EFAULT;
>+	u32 free_space;
>
> 	spin_lock_bh(&vvs->rx_lock);
>-	while (total < len && !list_empty(&vvs->rx_queue)) {
>-		pkt = list_first_entry(&vvs->rx_queue,
>-				       struct virtio_vsock_pkt, list);
>+	while (total < len && !skb_queue_empty_lockless(&vvs->rx_queue)) {

As Paolo suggested on the v5, we should use skb_queue_empty() since we 
are under a lock (rx_lock) that is protecting the rx_queue.

>+		skb = __skb_dequeue(&vvs->rx_queue);
>
> 		bytes = len - total;
>-		if (bytes > pkt->len - pkt->off)
>-			bytes = pkt->len - pkt->off;
>+		if (bytes > skb->len)
>+			bytes = skb->len;
>
> 		/* sk_lock is held by caller so no one else can dequeue.
> 		 * Unlock rx_lock since memcpy_to_msg() may sleep.
> 		 */
> 		spin_unlock_bh(&vvs->rx_lock);
>
>-		err = memcpy_to_msg(msg, pkt->buf + pkt->off, bytes);
>+		err = memcpy_to_msg(msg, skb->data, bytes);
> 		if (err)
> 			goto out;
>
> 		spin_lock_bh(&vvs->rx_lock);
>
> 		total += bytes;
>-		pkt->off += bytes;
>-		if (pkt->off == pkt->len) {
>-			virtio_transport_dec_rx_pkt(vvs, pkt);
>-			list_del(&pkt->list);
>-			virtio_transport_free_pkt(pkt);
>+		skb_pull(skb, bytes);
>+
>+		if (skb->len == 0) {
>+			virtio_transport_dec_rx_pkt(vvs, skb);
>+			consume_skb(skb);
>+		} else {
>+			__skb_queue_head(&vvs->rx_queue, skb);
> 		}
> 	}
>
>@@ -414,10 +423,10 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 						 int flags)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
>-	struct virtio_vsock_pkt *pkt;
> 	int dequeued_len = 0;
> 	size_t user_buf_len = msg_data_left(msg);
> 	bool msg_ready = false;
>+	struct sk_buff *skb;
>
> 	spin_lock_bh(&vvs->rx_lock);
>
>@@ -427,13 +436,18 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 	}
>
> 	while (!msg_ready) {
>-		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>+		struct virtio_vsock_hdr *hdr;
>+
>+		skb = __skb_dequeue(&vvs->rx_queue);
>+		if (!skb)
>+			break;
>+		hdr = virtio_vsock_hdr(skb);
>
> 		if (dequeued_len >= 0) {
> 			size_t pkt_len;
> 			size_t bytes_to_copy;
>
>-			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>+			pkt_len = (size_t)le32_to_cpu(hdr->len);
> 			bytes_to_copy = min(user_buf_len, pkt_len);
>
> 			if (bytes_to_copy) {
>@@ -444,7 +458,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 				 */
> 				spin_unlock_bh(&vvs->rx_lock);
>
>-				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
>+				err = memcpy_to_msg(msg, skb->data, bytes_to_copy);
> 				if (err) {
> 					/* Copy of message failed. Rest of
> 					 * fragments will be freed without copy.
>@@ -452,6 +466,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 					dequeued_len = err;
> 				} else {
> 					user_buf_len -= bytes_to_copy;
>+					skb_pull(skb, bytes_to_copy);
> 				}
>
> 				spin_lock_bh(&vvs->rx_lock);
>@@ -461,17 +476,16 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 				dequeued_len += pkt_len;
> 		}
>
>-		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
>+		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) {
> 			msg_ready = true;
> 			vvs->msg_count--;
>
>-			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>+			if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOR)
> 				msg->msg_flags |= MSG_EOR;
> 		}
>
>-		virtio_transport_dec_rx_pkt(vvs, pkt);
>-		list_del(&pkt->list);
>-		virtio_transport_free_pkt(pkt);
>+		virtio_transport_dec_rx_pkt(vvs, skb);
>+		kfree_skb(skb);
> 	}
>
> 	spin_unlock_bh(&vvs->rx_lock);
>@@ -609,7 +623,7 @@ int virtio_transport_do_socket_init(struct vsock_sock *vsk,
>
> 	spin_lock_init(&vvs->rx_lock);
> 	spin_lock_init(&vvs->tx_lock);
>-	INIT_LIST_HEAD(&vvs->rx_queue);
>+	skb_queue_head_init(&vvs->rx_queue);
>
> 	return 0;
> }
>@@ -806,16 +820,16 @@ void virtio_transport_destruct(struct vsock_sock *vsk)
> EXPORT_SYMBOL_GPL(virtio_transport_destruct);
>
> static int virtio_transport_reset(struct vsock_sock *vsk,
>-				  struct virtio_vsock_pkt *pkt)
>+				  struct sk_buff *skb)
> {
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RST,
>-		.reply = !!pkt,
>+		.reply = !!skb,
> 		.vsk = vsk,
> 	};
>
> 	/* Send RST only if the original pkt is not a RST pkt */
>-	if (pkt && le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RST)
>+	if (skb && le16_to_cpu(virtio_vsock_hdr(skb)->op) == VIRTIO_VSOCK_OP_RST)
> 		return 0;
>
> 	return virtio_transport_send_pkt_info(vsk, &info);
>@@ -825,29 +839,30 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
>  * attempt was made to connect to a socket that does not exist.
>  */
> static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>-					  struct virtio_vsock_pkt *pkt)
>+					  struct sk_buff *skb)
> {
>-	struct virtio_vsock_pkt *reply;
>+	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_RST,
>-		.type = le16_to_cpu(pkt->hdr.type),
>+		.type = le16_to_cpu(hdr->type),
> 		.reply = true,
> 	};
>+	struct sk_buff *reply;
>
> 	/* Send RST only if the original pkt is not a RST pkt */
>-	if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RST)
>+	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
> 		return 0;
>
>-	reply = virtio_transport_alloc_pkt(&info, 0,
>-					   le64_to_cpu(pkt->hdr.dst_cid),
>-					   le32_to_cpu(pkt->hdr.dst_port),
>-					   le64_to_cpu(pkt->hdr.src_cid),
>-					   le32_to_cpu(pkt->hdr.src_port));
>+	reply = virtio_transport_alloc_skb(&info, 0,
>+					   le64_to_cpu(hdr->dst_cid),
>+					   le32_to_cpu(hdr->dst_port),
>+					   le64_to_cpu(hdr->src_cid),
>+					   le32_to_cpu(hdr->src_port));
> 	if (!reply)
> 		return -ENOMEM;
>
> 	if (!t) {
>-		virtio_transport_free_pkt(reply);
>+		kfree_skb(reply);
> 		return -ENOTCONN;
> 	}
>
>@@ -858,16 +873,11 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> static void virtio_transport_remove_sock(struct vsock_sock *vsk)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
>-	struct virtio_vsock_pkt *pkt, *tmp;
>
> 	/* We don't need to take rx_lock, as the socket is closing and we are
> 	 * removing it.
> 	 */
>-	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
>-		list_del(&pkt->list);
>-		virtio_transport_free_pkt(pkt);
>-	}
>-
>+	__skb_queue_purge(&vvs->rx_queue);
> 	vsock_remove_sock(vsk);
> }
>
>@@ -981,13 +991,14 @@ EXPORT_SYMBOL_GPL(virtio_transport_release);
>
> static int
> virtio_transport_recv_connecting(struct sock *sk,
>-				 struct virtio_vsock_pkt *pkt)
>+				 struct sk_buff *skb)
> {
>+	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
> 	struct vsock_sock *vsk = vsock_sk(sk);
>-	int err;
> 	int skerr;
>+	int err;
>
>-	switch (le16_to_cpu(pkt->hdr.op)) {
>+	switch (le16_to_cpu(hdr->op)) {
> 	case VIRTIO_VSOCK_OP_RESPONSE:
> 		sk->sk_state = TCP_ESTABLISHED;
> 		sk->sk_socket->state = SS_CONNECTED;
>@@ -1008,7 +1019,7 @@ virtio_transport_recv_connecting(struct sock *sk,
> 	return 0;
>
> destroy:
>-	virtio_transport_reset(vsk, pkt);
>+	virtio_transport_reset(vsk, skb);
> 	sk->sk_state = TCP_CLOSE;
> 	sk->sk_err = skerr;
> 	sk_error_report(sk);
>@@ -1017,34 +1028,37 @@ virtio_transport_recv_connecting(struct sock *sk,
>
> static void
> virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>-			      struct virtio_vsock_pkt *pkt)
>+			      struct sk_buff *skb)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
> 	bool can_enqueue, free_pkt = false;
>+	struct virtio_vsock_hdr *hdr;
>+	u32 len;
>
>-	pkt->len = le32_to_cpu(pkt->hdr.len);
>-	pkt->off = 0;
>+	hdr = virtio_vsock_hdr(skb);
>+	len = le32_to_cpu(hdr->len);
>
> 	spin_lock_bh(&vvs->rx_lock);
>
>-	can_enqueue = virtio_transport_inc_rx_pkt(vvs, pkt);
>+	can_enqueue = virtio_transport_inc_rx_pkt(vvs, skb);
> 	if (!can_enqueue) {
> 		free_pkt = true;
> 		goto out;
> 	}
>
>-	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)
>+	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
> 		vvs->msg_count++;
>
> 	/* Try to copy small packets into the buffer of last packet queued,
> 	 * to avoid wasting memory queueing the entire buffer with a small
> 	 * payload.
> 	 */
>-	if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
>-		struct virtio_vsock_pkt *last_pkt;
>+	if (len <= GOOD_COPY_LEN && !skb_queue_empty_lockless(&vvs->rx_queue)) {

Same here.

If there are no major changes to be made, I think the next version is 
the final ones, though we are now in the merge window, so net-next is 
closed [1], only RFCs can be sent [2].

I suggest you wait until the merge window is over (two weeks usually) to 
send the next version.

Thanks again for this great work!
Stefano

[1] http://vger.kernel.org/~davem/net-next.html
[2] https://www.kernel.org/doc/html/v6.0/process/maintainer-netdev.html#how-often-do-changes-from-these-trees-make-it-to-the-mainline-linus-tree

