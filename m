Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB54B318CCE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhBKN6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 08:58:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231289AbhBKN4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 08:56:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613051678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hxm3tTBn4jpC6LAEFWbuTMk8WJ6nzBBMJfllj+PHWYk=;
        b=g1xu6t+aHMeU7a2dZLKAQFgfNSb0iMxfhj++aDfBBEBOPfOz86NPrVmOQPNRgf2De44x+U
        002WqsU05S8UxKhC8+ZCcN5gpHzoAisJoFWM6DAi2EFbgFdKhd0FzpXbC9ojUcv4Bp4ZzI
        NFQcuryMgHMMFNewmEtX83t7Zc9X8+g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-UrpWZStYPjCnFnrk-WU_aw-1; Thu, 11 Feb 2021 08:54:33 -0500
X-MC-Unique: UrpWZStYPjCnFnrk-WU_aw-1
Received: by mail-ed1-f71.google.com with SMTP id m16so4612257edd.21
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 05:54:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hxm3tTBn4jpC6LAEFWbuTMk8WJ6nzBBMJfllj+PHWYk=;
        b=N77JpKulqCy6vW+ymg/oYY1w0Q6ZdbiF9FAMmeRfICAOPt9dPV1WUKtON+E5WpFNyn
         c+Fan4wPgn9hYrLwLBXs/1UQIJH2VL0loV0CCs59PL6QSr3xV9WuDBSTva4WlQMJiWeB
         uMWzCTVde3fq/iKiC8Rjr94G+h+DJiPGmU60s+4oUlwy2kh/AL5yfKI5WlPqpFZLu7Hf
         Tx1gcPkjV0mGlA5ulCP3tw7JYFZdfv/8NjekV6l2JVOR7PT8Qvt9oIKjaeenju7a6HAD
         LRFPtNbODG6XveNIs6bVuAV5nBwdH5ST9Uby58Xf04LcjP41jjRDWZqB3QcqbcLBbJYx
         kgbg==
X-Gm-Message-State: AOAM530+iA1vNhL/QoBEl0jITmhkBiGf544kl786dzFGp4oKIGz7Olje
        wbhAGPFUPZBQlvGgA9EMUSa0LppFvYAgR2ErN4JEj/JVQMfHdhNXcpoVeZ3YInAMTraPwpGfC4u
        VKip8ooJrs6Hn3E6N
X-Received: by 2002:a05:6402:c7:: with SMTP id i7mr8555268edu.328.1613051671724;
        Thu, 11 Feb 2021 05:54:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhf36slYK/Z4DzWe3EiY0KpuhoDQbyLZt+nUxs1qtlMk6tNk3eG5Zt0lXrC2f5uTSX31cVjQ==
X-Received: by 2002:a05:6402:c7:: with SMTP id i7mr8555253edu.328.1613051671462;
        Thu, 11 Feb 2021 05:54:31 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id u17sm4121142edr.0.2021.02.11.05.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 05:54:31 -0800 (PST)
Date:   Thu, 11 Feb 2021 14:54:28 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 09/17] virtio/vsock: dequeue callback for
 SOCK_SEQPACKET
Message-ID: <20210211135428.k6cncu3m7ee4odhl@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151649.805359-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151649.805359-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:16:46PM +0300, Arseny Krasnov wrote:
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
> include/linux/virtio_vsock.h            |   5 +
> include/uapi/linux/virtio_vsock.h       |  16 ++++
> net/vmw_vsock/virtio_transport_common.c | 120 ++++++++++++++++++++++++
> 3 files changed, 141 insertions(+)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index dc636b727179..4d0de3dee9a4 100644
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
>index 5956939eebb7..4572d01c8ea5 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -397,6 +397,126 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
>+{
>+	list_del(&pkt->list);
>+	virtio_transport_free_pkt(pkt);
>+}
>+
>+static size_t virtio_transport_drop_until_seq_begin(struct virtio_vsock_sock *vvs)
>+{

This function is not used here, but in the next patch, so I'd add this 
with the next patch.

>+	struct virtio_vsock_pkt *pkt, *n;
>+	size_t bytes_dropped = 0;
>+
>+	list_for_each_entry_safe(pkt, n, &vvs->rx_queue, list) {
>+		if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_SEQ_BEGIN)
>+			break;
>+
>+		bytes_dropped += le32_to_cpu(pkt->hdr.len);
>+		virtio_transport_dec_rx_pkt(vvs, pkt);
>+		virtio_transport_remove_pkt(pkt);
>+	}
>+
>+	return bytes_dropped;
>+}
>+
>+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>+						 struct msghdr *msg,
>+						 bool *msg_ready)
>+{

Also this function is not used, maybe you can add in this patch the 
virtio_transport_seqpacket_dequeue() implementation.

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
>+	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_SEQPACKET,
>+					    NULL);
>+
>+	return err;
>+}
>+
> ssize_t
> virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> 				struct msghdr *msg,
>-- 
>2.25.1
>

