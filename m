Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB3B322C0D
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhBWORL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:17:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52482 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230459AbhBWOQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 09:16:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614089728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FJIy5VYftDFzcS1eI6DBNLyuIitPJ8z3PjzMyrSe9Dk=;
        b=B5U5+UBpvE7LXHLq5XQCGdfnTPJsbVal8qtqYI3LRDaL/PTXlGnX/2VbILKmSM1u99ggXe
        gjv6nTeM+AZzNzEm/y42dYJ57327W0IQnWcJkZGEODM/aW2eYnl4U//MDOvWtO+ILMAaEG
        uDp1vOC2US9ET5KjKWp2ZFTWU88ic2k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-svCA1TLLM-6ot-Th7sQZ1g-1; Tue, 23 Feb 2021 09:15:09 -0500
X-MC-Unique: svCA1TLLM-6ot-Th7sQZ1g-1
Received: by mail-wm1-f72.google.com with SMTP id f18so711756wmq.3
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 06:15:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FJIy5VYftDFzcS1eI6DBNLyuIitPJ8z3PjzMyrSe9Dk=;
        b=XSOAEPVEOwx1h/7PNihR4nRg+Pv1s0fupJrMytRSUZN7/lwnPVvVlhNQY6SX5u5H/X
         pOT5TzscKtCyfFLm0ImOxTVJfNcFa356gU/PbK97AB1POZc7HYMf4jFifL8zIK+XM+u5
         NYGooNJBLg+aQcKCyc2RlSH2UgGXFEYmIvTrARFp3GIFvJRtINq6Xxwl3yENbWI3cwLo
         mckFrV4+MKFE+E853KxCmT8etVXO2R1g1YEhDld9YIYCQgYhXTprydgDgQeoi/BEvvHM
         cXemnlrG5NpG2kew3elkXbPpgiPHYz8dcCrCJ3cijDSEDVHDjLkXhJx78fj18iZRybPY
         VqNg==
X-Gm-Message-State: AOAM531DPsrv6xEO58flhxhYMLGflEbscLwBSyulNpShWgREyp3W6TaM
        5hgyaMyVXAuzh8h5Nto7ZPG9vdsF3rAuP7OLosq/UF6dvJzEsUDDq++EfFaT4nJkYk4t23X+ukd
        MDJ2WIf5JkdW+19iY
X-Received: by 2002:adf:ab52:: with SMTP id r18mr1516306wrc.65.1614089708385;
        Tue, 23 Feb 2021 06:15:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJv3H61BfIS/umFAmEQYS6QIB/suGeYp9cK+970moPYeLP1UMZPtXjRprXGHZ4qx4R6GVjHA==
X-Received: by 2002:adf:ab52:: with SMTP id r18mr1516282wrc.65.1614089708203;
        Tue, 23 Feb 2021 06:15:08 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u4sm31549861wrr.37.2021.02.23.06.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 06:15:07 -0800 (PST)
Date:   Tue, 23 Feb 2021 15:15:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 11/19] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210223141504.eojm7kgcpswrez6j@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053940.1068164-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053940.1068164-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 08:39:37AM +0300, Arseny Krasnov wrote:
>This adds transport callback and it's logic for SEQPACKET dequeue.
>Callback fetches RW packets from rx queue of socket until whole record
>is copied(if user's buffer is full, user is not woken up). This is done
>to not stall sender, because if we wake up user and it leaves syscall,
>nobody will send credit update for rest of record, and sender will wait
>for next enter of read syscall at receiver's side. So if user buffer is
>full, we just send credit update and drop data. If during copy SEQ_BEGIN
>was found(and not all data was copied), copying is restarted by reset
>user's iov iterator(previous unfinished data is dropped).
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/linux/virtio_vsock.h            |  10 +++
> include/uapi/linux/virtio_vsock.h       |  16 ++++
> net/vmw_vsock/virtio_transport_common.c | 114 ++++++++++++++++++++++++
> 3 files changed, 140 insertions(+)

This patch LGTM, maybe we only need to change 'msg_cnt' as we discussed 
on virtio-comment, but let's see if there are any other comments.

>
>diff --git a/include/linux/virtio_vsock.h 
>b/include/linux/virtio_vsock.h
>index dc636b727179..003d06ae4a85 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -36,6 +36,11 @@ struct virtio_vsock_sock {
> 	u32 rx_bytes;
> 	u32 buf_alloc;
> 	struct list_head rx_queue;
>+
>+	/* For SOCK_SEQPACKET */
>+	u32 user_read_seq_len;
>+	u32 user_read_copied;
>+	u32 curr_rx_msg_cnt;
> };
>
> struct virtio_vsock_pkt {
>@@ -80,6 +85,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+int
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags,
>+				   bool *msg_ready);
> s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
>
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 1d57ed3d84d2..cf9c165e5cca 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -63,8 +63,14 @@ struct virtio_vsock_hdr {
> 	__le32	fwd_cnt;
> } __attribute__((packed));
>
>+struct virtio_vsock_seq_hdr {
>+	__le32  msg_cnt;
>+	__le32  msg_len;
>+} __attribute__((packed));
>+
> enum virtio_vsock_type {
> 	VIRTIO_VSOCK_TYPE_STREAM = 1,
>+	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
> };
>
> enum virtio_vsock_op {
>@@ -83,6 +89,11 @@ enum virtio_vsock_op {
> 	VIRTIO_VSOCK_OP_CREDIT_UPDATE = 6,
> 	/* Request the peer to send the credit info to us */
> 	VIRTIO_VSOCK_OP_CREDIT_REQUEST = 7,
>+
>+	/* Record begin for SOCK_SEQPACKET */
>+	VIRTIO_VSOCK_OP_SEQ_BEGIN = 8,
>+	/* Record end for SOCK_SEQPACKET */
>+	VIRTIO_VSOCK_OP_SEQ_END = 9,
> };
>
> /* VIRTIO_VSOCK_OP_SHUTDOWN flags values */
>@@ -91,4 +102,9 @@ enum virtio_vsock_shutdown {
> 	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
> };
>
>+/* VIRTIO_VSOCK_OP_RW flags values */
>+enum virtio_vsock_rw {
>+	VIRTIO_VSOCK_RW_EOR = 1,
>+};
>+
> #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 833104b71a1c..d8ec2dfa2315 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -393,6 +393,108 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
>+{
>+	list_del(&pkt->list);
>+	virtio_transport_free_pkt(pkt);
>+}
>+
>+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>+						 struct msghdr *msg,
>+						 bool *msg_ready)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_pkt *pkt;
>+	int err = 0;
>+	size_t user_buf_len = msg->msg_iter.count;
>+
>+	*msg_ready = false;
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	while (!*msg_ready && !list_empty(&vvs->rx_queue) && !err) {
>+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>+
>+		switch (le16_to_cpu(pkt->hdr.op)) {
>+		case VIRTIO_VSOCK_OP_SEQ_BEGIN: {
>+			/* Unexpected 'SEQ_BEGIN' during record copy:
>+			 * Leave receive loop, 'EAGAIN' will restart it from
>+			 * outer receive loop, packet is still in queue and
>+			 * counters are cleared. So in next loop enter,
>+			 * 'SEQ_BEGIN' will be dequeued first. User's iov
>+			 * iterator will be reset in outer loop. Also
>+			 * send credit update, because some bytes could be
>+			 * copied. User will never see unfinished record.
>+			 */
>+			err = -EAGAIN;
>+			break;
>+		}
>+		case VIRTIO_VSOCK_OP_SEQ_END: {
>+			struct virtio_vsock_seq_hdr *seq_hdr;
>+
>+			seq_hdr = (struct virtio_vsock_seq_hdr *)pkt->buf;
>+			/* First check that whole record is received. */
>+
>+			if (vvs->user_read_copied != vvs->user_read_seq_len ||
>+			    (le32_to_cpu(seq_hdr->msg_cnt) - vvs->curr_rx_msg_cnt) != 1) {
>+				/* Tail of current record and head of next missed,
>+				 * so this EOR is from next record. Restart receive.
>+				 * Current record will be dropped, next headless will
>+				 * be dropped on next attempt to get record length.
>+				 */
>+				err = -EAGAIN;
>+			} else {
>+				/* Success. */
>+				*msg_ready = true;
>+			}
>+
>+			break;
>+		}
>+		case VIRTIO_VSOCK_OP_RW: {
>+			size_t bytes_to_copy;
>+			size_t pkt_len;
>+
>+			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
>+			bytes_to_copy = min(user_buf_len, pkt_len);
>+
>+			/* sk_lock is held by caller so no one else can dequeue.
>+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>+			 */
>+			spin_unlock_bh(&vvs->rx_lock);
>+
>+			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy)) {
>+				spin_lock_bh(&vvs->rx_lock);
>+				err = -EINVAL;
>+				break;
>+			}
>+
>+			spin_lock_bh(&vvs->rx_lock);
>+			user_buf_len -= bytes_to_copy;
>+			vvs->user_read_copied += pkt_len;
>+
>+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_RW_EOR)
>+				msg->msg_flags |= MSG_EOR;
>+			break;
>+		}
>+		default:
>+			;
>+		}
>+
>+		/* For unexpected 'SEQ_BEGIN', keep such packet in queue,
>+		 * but drop any other type of packet.
>+		 */
>+		if (le16_to_cpu(pkt->hdr.op) != VIRTIO_VSOCK_OP_SEQ_BEGIN) {
>+			virtio_transport_dec_rx_pkt(vvs, pkt);
>+			virtio_transport_remove_pkt(pkt);
>+		}
>+	}
>+
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	virtio_transport_send_credit_update(vsk);
>+
>+	return err;
>+}
>+
> ssize_t
> virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> 				struct msghdr *msg,
>@@ -405,6 +507,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
>
>+int
>+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags, bool *msg_ready)
>+{
>+	if (flags & MSG_PEEK)
>+		return -EOPNOTSUPP;
>+
>+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, msg_ready);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>+
> int
> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
>-- 
>2.25.1
>

