Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B7733B0FF
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCOLZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:25:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229865AbhCOLZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615807523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EDcN82trASDnIA4Psf1sFMT849eJlpI4rz5LIx/ZPbc=;
        b=WgUWsfRv3QR39gHoZ7rU6BFn8tzrPZ0yj8uC9l0jOKogxJjqqk6OsspCd/uxkxZsq+shCv
        suKx4Swmj9IGVw7BnZs1vbW7dVrMs743ORXwH2HT77eHkvcx/c2Iw7uURkYVW4PT6fdIbA
        RVQ4I5/k+Yt5R/v7RjHHsjVKDOuWO5A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-QONxenzqOPKRVYITxKxRng-1; Mon, 15 Mar 2021 07:25:21 -0400
X-MC-Unique: QONxenzqOPKRVYITxKxRng-1
Received: by mail-wm1-f71.google.com with SMTP id l16so4279555wmc.0
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:25:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EDcN82trASDnIA4Psf1sFMT849eJlpI4rz5LIx/ZPbc=;
        b=ZQgxsVi5U8tTBo0FC/W2MXilQ3QGpC62zxdSo3f1lkwevDpVy2YO2urdtlbAgLIH7i
         B0Pp/Ac60usxnaZ45NucCrk5rYuliHq1dPMD9/UZVgdPOEDTI6wfzW+uMCWKSo6ySY2q
         ic73RQidNBZrZjJudyJouN6yYS27RnYn+zms5+WNGONrOT+Syv+IXiBmlgMQGPkiZrDg
         B1fQU3m3lDrfYj/xpJ2dBGGs6+VfYjIkzEKA5mf62buy6NRTHhMVQuhv6J7bUco6bqZH
         DgwjzIyaJFNmVgIuG8fjg2pkRZ4ctdwCKfFV8w4jFZVkfgPqJgWVR1GLunYi+usCY4qb
         Slug==
X-Gm-Message-State: AOAM533VWzfHjwcuoKnw/rxYNkcKAU8bxj/WRW6MjWiJd7OT/b4qUAUT
        Tu3T7e1CV/1fAUp8m60xGuR6d6XF6D+e3o60fR9uDVvSjz8ZNufQ2cCimrQXw4/4SGnalKY7xB6
        eb6ngqRJejIEKuYIx
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr26147144wrs.208.1615807519057;
        Mon, 15 Mar 2021 04:25:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxL+19i7o4WzIiaFHRonxgDt5TkAS6qK3oH8aOOuycb9DLxzp3yCNty1apS15aHGkiLlIToxQ==
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr26147121wrs.208.1615807518885;
        Mon, 15 Mar 2021 04:25:18 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id f22sm11933706wmb.31.2021.03.15.04.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:25:18 -0700 (PDT)
Date:   Mon, 15 Mar 2021 12:25:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 14/22] virtio/vsock: rest of SOCK_SEQPACKET support
Message-ID: <20210315112516.wa5yos6cbukcv3ww@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180312.3466235-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307180312.3466235-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 09:03:09PM +0300, Arseny Krasnov wrote:
>This adds rest of logic for SEQPACKET:
>1) SEQPACKET specific functions which send SEQ_BEGIN/SEQ_END.
>   Note that both functions may sleep to wait enough space for
>   SEQPACKET header.
>2) SEQ_BEGIN/SEQ_END in TAP packet capture.
>3) Send SHUTDOWN on socket close for SEQPACKET type.
>4) Set SEQPACKET packet type during send.
>5) Set MSG_EOR in flags for SEQPACKET during send.
>6) 'seqpacket_allow' flag to virtio transport.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/linux/virtio_vsock.h            |  8 +++
> net/vmw_vsock/virtio_transport_common.c | 87 ++++++++++++++++++++++++-
> 2 files changed, 93 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index d7edcfeb4cd2..6b45a8b98226 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -22,6 +22,7 @@ struct virtio_vsock_seqpack_state {
> 	u32 user_read_seq_len;
> 	u32 user_read_copied;
> 	u32 curr_rx_msg_id;
>+	u32 next_tx_msg_id;
> };
>
> /* Per-socket state (accessed via vsk->trans) */
>@@ -76,6 +77,8 @@ struct virtio_transport {
>
> 	/* Takes ownership of the packet */
> 	int (*send_pkt)(struct virtio_vsock_pkt *pkt);
>+
>+	bool seqpacket_allow;
> };
>
> ssize_t
>@@ -90,6 +93,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>
> size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
> int
>+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags,
>+				   size_t len);
>+int
> virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> 				   struct msghdr *msg,
> 				   int flags,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 9d86375935ce..8e9fdd8aba5d 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -139,6 +139,8 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 		break;
> 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
> 	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
>+	case VIRTIO_VSOCK_OP_SEQ_BEGIN:
>+	case VIRTIO_VSOCK_OP_SEQ_END:
> 		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONTROL);
> 		break;
> 	default:
>@@ -187,7 +189,12 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	struct virtio_vsock_pkt *pkt;
> 	u32 pkt_len = info->pkt_len;
>
>-	info->type = VIRTIO_VSOCK_TYPE_STREAM;
>+	info->type = virtio_transport_get_type(sk_vsock(vsk));
>+
>+	if (info->type == VIRTIO_VSOCK_TYPE_SEQPACKET &&
>+	    info->msg &&
>+	    info->msg->msg_flags & MSG_EOR)
>+		info->flags |= VIRTIO_VSOCK_RW_EOR;
>
> 	t_ops = virtio_transport_get_ops(vsk);
> 	if (unlikely(!t_ops))
>@@ -401,6 +408,43 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static int virtio_transport_seqpacket_send_ctrl(struct vsock_sock *vsk,
>+						int type,
>+						size_t len,
>+						int flags)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_pkt_info info = {
>+		.op = type,
>+		.vsk = vsk,
>+		.pkt_len = sizeof(struct virtio_vsock_seq_hdr)
>+	};
>+
>+	struct virtio_vsock_seq_hdr seq_hdr = {
>+		.msg_id = cpu_to_le32(vvs->seqpacket_state.next_tx_msg_id),
>+		.msg_len = cpu_to_le32(len)
>+	};
>+
>+	struct kvec seq_hdr_kiov = {
>+		.iov_base = (void *)&seq_hdr,
>+		.iov_len = sizeof(struct virtio_vsock_seq_hdr)
>+	};
>+
>+	struct msghdr msg = {0};
>+
>+	//XXX: do we need 'vsock_transport_send_notify_data' pointer?
>+	if (vsock_wait_space(sk_vsock(vsk),
>+			     sizeof(struct virtio_vsock_seq_hdr),
>+			     flags, NULL))
>+		return -1;
>+
>+	iov_iter_kvec(&msg.msg_iter, WRITE, &seq_hdr_kiov, 1, sizeof(seq_hdr));
>+
>+	info.msg = &msg;
>+
>+	return virtio_transport_send_pkt_info(vsk, &info);
>+}
>+
> static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
> {
> 	list_del(&pkt->list);
>@@ -582,6 +626,45 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>
>+int
>+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   int flags,
>+				   size_t len)
>+{
>+	int written;
>+
>+	if (msg->msg_iter.iov_offset == 0) {
>+		/* Send SEQBEGIN. */
>+		if (virtio_transport_seqpacket_send_ctrl(vsk,
>+							 VIRTIO_VSOCK_OP_SEQ_BEGIN,
>+							 len,
>+							 flags) < 0)
>+			return -1;
>+	}
>+
>+	written = virtio_transport_stream_enqueue(vsk, msg, len);
>+
>+	if (written < 0)
>+		return -1;
>+
>+	if (msg->msg_iter.count == 0) {
>+		struct virtio_vsock_sock *vvs = vsk->trans;
>+
>+		/* Send SEQEND. */
>+		if (virtio_transport_seqpacket_send_ctrl(vsk,
>+							 VIRTIO_VSOCK_OP_SEQ_END,
>+							 0,
>+							 flags) < 0)
>+			return -1;
>+
>+		vvs->seqpacket_state.next_tx_msg_id++;
>+	}

I suspect we should increment next_tx_msg_id even in case of an error to 
avoid issues with packets with same IDs, so in case of error I would do:

	if (/* error */) {
		written = -1;
		goto out;
	}

Then we can add the 'out' label and the id increment:

out:
	vvs->seqpacket_state.next_tx_msg_id++;
>+
>+	return written;
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
>+
> int
> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
>@@ -1001,7 +1084,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
> 	struct sock *sk = &vsk->sk;
> 	bool remove_sock = true;
>
>-	if (sk->sk_type == SOCK_STREAM)
>+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
> 		remove_sock = virtio_transport_close(vsk);
>
> 	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
>-- 
>2.25.1
>

