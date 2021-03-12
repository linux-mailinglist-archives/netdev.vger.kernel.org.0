Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18771339122
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhCLPVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:21:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231730AbhCLPU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615562455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XNhlw58yD5yXI9Wev/02PZnuhLLW5yA/Trw5RjUWlz8=;
        b=YsGwYCKnU1cvfhechO5ZIWBUZi6RVanAX/JQReoAhqwQc37+my+l/7YNakJtSkC1Da7bnb
        MbvNVzMbN22pdt3MWtohMQQrLZnRfE0ozqu2Mha5ezcV+VHOxXR/E17cujAy2EzYr0aYU9
        AW9m0ctO/TBWQX2fNUW93A7hAnVNORw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-rs8BeedWOLKRubRG6vUu1g-1; Fri, 12 Mar 2021 10:20:54 -0500
X-MC-Unique: rs8BeedWOLKRubRG6vUu1g-1
Received: by mail-wm1-f69.google.com with SMTP id 73so5482965wma.3
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 07:20:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XNhlw58yD5yXI9Wev/02PZnuhLLW5yA/Trw5RjUWlz8=;
        b=k6uDpgs9RDxO8Dt43/qlkALfpEGJOjmPu/qb0KuSYXw6IhRsQIlIbKSeUm4y7kvfRK
         Y3SM9DVqLLJQEXwKKFYcmsXZZ88Rrg9u5SmBMhW2gaJwrEQAJrMWXxsr9J5lw1PVIfD+
         G8UnCE2kT1k7FXk0A1KDzo/FB7y+vANK97Q5QTQFzBtVpvUeKRI2KTsn6i3wuzJkRLRq
         szWQM2cI4eXkaZMmxKhB2bp3nmZsX0a7AtpTbrgyxj03EC5HLtQmU9lASmtBVBKD8FHE
         pw6gzMkrpjlH4OOlbxWtrISAvvz4qZaoUZMYOrFPFqU/OaYHua/QpdbPXjtkfH0ND0uU
         O0zg==
X-Gm-Message-State: AOAM531iR34x35aGJrwnwD3Byi0bxF7aWFfHYcFsKHZT1QXrh+wShby2
        fvK7CPJhbnZHZ96+zDGNWMiIx85aaAFgXTf2C6WaCraFNn0nJDua2Y1xqsiefh1lUWR4gQ2Km3v
        Ee38NtOJ1EVB7zp+P
X-Received: by 2002:adf:8562:: with SMTP id 89mr14637739wrh.101.1615562452730;
        Fri, 12 Mar 2021 07:20:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwOgAMv5zfx20zVxHk8NkAVCtdDWRTDNIVXsPFGWUxUqnBQhG1JfeKtcQP8FzSMF5UIyygdGw==
X-Received: by 2002:adf:8562:: with SMTP id 89mr14637714wrh.101.1615562452552;
        Fri, 12 Mar 2021 07:20:52 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id s84sm2463651wme.11.2021.03.12.07.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:20:52 -0800 (PST)
Date:   Fri, 12 Mar 2021 16:20:49 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v6 12/22] virtio/vsock: fetch length for SEQPACKET
 record
Message-ID: <20210312152049.iiarapjotp6eqho2@steredhat>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
 <20210307180235.3465973-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210307180235.3465973-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 09:02:31PM +0300, Arseny Krasnov wrote:
>This adds transport callback which tries to fetch record begin marker
>from socket's rx queue. It is called from af_vsock.c before reading data
>packets of record.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/linux/virtio_vsock.h            |  1 +
> net/vmw_vsock/virtio_transport_common.c | 53 +++++++++++++++++++++++++
> 2 files changed, 54 insertions(+)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 466a5832d2f5..d7edcfeb4cd2 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -88,6 +88,7 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags);
>
>+size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
> int
> virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> 				   struct msghdr *msg,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 5f1e283e43f3..6fc78fec41c0 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -399,6 +399,59 @@ static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
> 	virtio_transport_free_pkt(pkt);
> }
>
>+static size_t virtio_transport_drop_until_seq_begin(struct virtio_vsock_sock *vvs)
>+{
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
>+size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk)
>+{
>+	struct virtio_vsock_seq_hdr *seq_hdr;
>+	struct virtio_vsock_sock *vvs;
>+	struct virtio_vsock_pkt *pkt;
>+	size_t bytes_dropped;
>+
>+	vvs = vsk->trans;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	/* Fetch all orphaned 'RW' packets and send credit update. */
>+	bytes_dropped = virtio_transport_drop_until_seq_begin(vvs);
>+
>+	if (list_empty(&vvs->rx_queue))
>+		goto out;

What do we return to in this case?

IIUC we return the len of the previous packet, should we set 
vvs->seqpacket_state.user_read_seq_len to 0?

>+
>+	pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>+
>+	vvs->seqpacket_state.user_read_copied = 0;
>+
>+	seq_hdr = (struct virtio_vsock_seq_hdr *)pkt->buf;
>+	vvs->seqpacket_state.user_read_seq_len = 
>le32_to_cpu(seq_hdr->msg_len);
>+	vvs->seqpacket_state.curr_rx_msg_id = le32_to_cpu(seq_hdr->msg_id);
>+	virtio_transport_dec_rx_pkt(vvs, pkt);
>+	virtio_transport_remove_pkt(pkt);
>+out:
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	if (bytes_dropped)
>+		virtio_transport_send_credit_update(vsk);
>+
>+	return vvs->seqpacket_state.user_read_seq_len;
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_get_len);
>+
> static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 						 struct msghdr *msg,
> 						 bool *msg_ready)
>-- 
>2.25.1
>

