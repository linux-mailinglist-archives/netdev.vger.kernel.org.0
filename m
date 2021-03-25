Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22899348DD5
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 11:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhCYKTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 06:19:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230158AbhCYKSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 06:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616667528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hUhrozeu57DSs+XU36A+D781UPvSZ/VpjRmqBL1uGQ0=;
        b=G50sxMj5thVD/DJZQ5Vwj3ZKrDDwHlRCjVAcCHlROtH6/2INADomWyc6yclZUxgonL7u4N
        K6cbq/3/CsFh1JSNSTWBCXGGxQ4qacH41GOWzBh9pu3/3oovfKr1ODx8Zn1gLwn58AgMiV
        7zc0WZiOogXUiNoBGPdZso7VFdsbCa4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-0iiJQNdpMZW4tTGyYRVlVQ-1; Thu, 25 Mar 2021 06:18:47 -0400
X-MC-Unique: 0iiJQNdpMZW4tTGyYRVlVQ-1
Received: by mail-wm1-f69.google.com with SMTP id f9so1488133wml.0
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 03:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hUhrozeu57DSs+XU36A+D781UPvSZ/VpjRmqBL1uGQ0=;
        b=CovDyFPwspH5qCgbGRDv/6Vicce+dvrPri+mT/gJv48iDoT4UX/zyVq28Q3mntfZ+8
         akJd3ibnx8jH5Z7KF0ctov9GBh0HnS+0bO4bccJjgtkVWd3Sj3kqOTgEf7CDdkS2AulN
         wlvTa0X8smNiP0gT59qTOVpLmFOqmxWBI8HggFIjAib+oYMeVHir3nzqka/ucvQK3Dur
         C4SpO0eo1x4CdDBNkIbfhsndAR0mnZic3vrMnJb1blQlO8CfnFCqO0WG5T2Ce8VR6uXm
         pt4OaSeJ/lBlTBJhvnjNICQiQpDJdizi6+3CqtFKdaC3as83jClH6hR74XvXE2DU7w6/
         58Cg==
X-Gm-Message-State: AOAM53262jsiJo077FRKpbmLnHHkmAt0BZZf1kTyYS5mNjNUQW6OYD01
        ZW4phkM3RUB8hm4rhebERzcfJxcwCqumi6o8RyLQfK7Dfo1GG5dDNJSTy3JHSn+MO+Hr2itfzb7
        Sm6tMwfMPNDLIGfMq
X-Received: by 2002:adf:f54c:: with SMTP id j12mr8113107wrp.264.1616667524631;
        Thu, 25 Mar 2021 03:18:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBlfzI+IvG48qHisDpU2ibEIiKoa3byd0gc11GfyaF7IgQ3ryeVPTESrDxVp1YDKp4p64vHw==
X-Received: by 2002:adf:f54c:: with SMTP id j12mr8113089wrp.264.1616667524435;
        Thu, 25 Mar 2021 03:18:44 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id m11sm7294285wri.44.2021.03.25.03.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 03:18:44 -0700 (PDT)
Date:   Thu, 25 Mar 2021 11:18:41 +0100
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
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 14/22] virtio/vsock: rest of SOCK_SEQPACKET support
Message-ID: <20210325101841.o7gs7peafxwb7rfd@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131332.2461409-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323131332.2461409-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 04:13:29PM +0300, Arseny Krasnov wrote:
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
> v6 -> v7:
> In 'virtio_transport_seqpacket_enqueue()', 'next_tx_msg_id' is updated
> in both cases when message send successfully or error occured.
>
> include/linux/virtio_vsock.h            |  7 ++
> net/vmw_vsock/virtio_transport_common.c | 88 ++++++++++++++++++++++++-
> 2 files changed, 93 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 0e3aa395c07c..ab5f56fd7251 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -22,6 +22,7 @@ struct virtio_vsock_seq_state {
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
>@@ -89,6 +92,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       size_t len, int flags);
>
> int
>+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   size_t len);
>+int
> virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> 				   struct msghdr *msg,
> 				   int flags,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index bfe0d7026bf8..01a56c7da8bd 100644
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
>+		.msg_id = cpu_to_le32(vvs->seq_state.next_tx_msg_id),
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
>@@ -595,6 +639,46 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> }
> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>
>+int
>+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
>+				   struct msghdr *msg,
>+				   size_t len)
>+{
>+	int written = -1;
>+
>+	if (msg->msg_iter.iov_offset == 0) {
>+		/* Send SEQBEGIN. */
>+		if (virtio_transport_seqpacket_send_ctrl(vsk,
>+							 VIRTIO_VSOCK_OP_SEQ_BEGIN,
>+							 len,
>+							 msg->msg_flags) < 0)
>+			goto out;
>+	}
>+
>+	written = virtio_transport_stream_enqueue(vsk, msg, len);
>+
>+	if (written < 0)
>+		goto out;
>+
>+	if (msg->msg_iter.count == 0) {
>+		/* Send SEQEND. */
>+		virtio_transport_seqpacket_send_ctrl(vsk,
>+						     VIRTIO_VSOCK_OP_SEQ_END,
>+						     0,
>+						     msg->msg_flags);

What happen if this fail?

In the previous version we returned -1, now we return the bytes 
transmitted, is that right?

The rest LGTM.

>+	}
>+out:
>+	/* Update next id on error or message transmission done. */
>+	if (written < 0 || msg->msg_iter.count == 0) {
>+		struct virtio_vsock_sock *vvs = vsk->trans;
>+
>+		vvs->seq_state.next_tx_msg_id++;
>+	}
>+
>+	return written;
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
>+
> int
> virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
>@@ -1014,7 +1098,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
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

