Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A4A2FA6A5
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405658AbhARQre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:47:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405514AbhARPQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:16:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610982918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CZbtDN5Gw+UFvSHReUfgycsMMjh1vfja1yrt3ww/R4I=;
        b=QB+xN5SgPzjr8NcMr1WWQaSrDe+hTUslBwXR50DDMwoIfaFrFHpeRi19xCwkv36BBCjLT+
        RdzX/LhvIKmhXrpjJqSzvVxOTvLUROElJ0GEMoOCX07L6jzIcFQH/HfMUnxyE/DPqlor+N
        QJVlXFhcG+roTslTyL2mGW2osPEAJtI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-xscxwLapOcqEnfX3Gmj-dA-1; Mon, 18 Jan 2021 10:15:17 -0500
X-MC-Unique: xscxwLapOcqEnfX3Gmj-dA-1
Received: by mail-wr1-f72.google.com with SMTP id q2so8438226wrp.4
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:15:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CZbtDN5Gw+UFvSHReUfgycsMMjh1vfja1yrt3ww/R4I=;
        b=Uvb0znmGW/O9j4Cnq+eeWddviZAV/Tfntow6uU9/Z6qebKX3Bg9z5qheHnhMfaHa/U
         34ga8nVbHQjQWlXBwOCHT9KIlCEQsrNUDRvieWVQbxnT7tdHyb8SdSeHuAo4soSbz75G
         bgdRokwcQHzj/y1yfLkUb8ovYApGQV/24ZB1pmYbasYLjeBrLxozdrK8C/yvULITNiIa
         POoela+9xiR41OGJ0Nn20U6ol4KkrpAly+0tG6FBfiVVTB1vfoUEfzseQPJ8knZqL6r5
         mNocvyImbRpzsJi2vQW8puS2tUa2i15q57dYiHN0JIOOs5aELZNnrbgL8+7LG9pQ+j+O
         dqdw==
X-Gm-Message-State: AOAM533mntOl13mvTAkBCPkzSX31sjxjPcjXRu2nsvip/5YSDS4IXn68
        SHtNyplaQCPvl0Y3UWTeAbgqECmt5KyN/6OEKXm/mzurDzzdhrNbH8XTLCyAMTfiyFRBQzYhqdb
        LD19lecLh4/ORcO4q
X-Received: by 2002:adf:eb05:: with SMTP id s5mr26268595wrn.333.1610982916082;
        Mon, 18 Jan 2021 07:15:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwG6Wf2v1m/zesVibhlEgiALKELloiSwEDJP2jloIZwFeL7u55HYCoufMZGrWWXUkziIqXroQ==
X-Received: by 2002:adf:eb05:: with SMTP id s5mr26268581wrn.333.1610982915916;
        Mon, 18 Jan 2021 07:15:15 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id s1sm31095090wrv.97.2021.01.18.07.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 07:15:15 -0800 (PST)
Date:   Mon, 18 Jan 2021 16:15:12 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 10/13] virtio/vsock: update receive logic
Message-ID: <20210118151512.itolt7axlxovj267@steredhat>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
 <20210115054410.1456928-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210115054410.1456928-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 08:44:07AM +0300, Arseny Krasnov wrote:
>This modifies current receive logic for SEQPACKET support:
>1) Add 'SEQ_BEGIN' packet to socket's rx queue.
>2) Add 'RW' packet to rx queue, but without merging inside buffer of last
>   packet in queue.
>3) Perform check for packet type and socket type on receive(if mismatch,
>   then reset connection).
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 79 ++++++++++++++++++-------
> 1 file changed, 58 insertions(+), 21 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index fe1272e74517..c3e07eb1c666 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -397,6 +397,14 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static u16 virtio_transport_get_type(struct sock *sk)
>+{
>+	if (sk->sk_type == SOCK_STREAM)
>+		return VIRTIO_VSOCK_TYPE_STREAM;
>+	else
>+		return VIRTIO_VSOCK_TYPE_SEQPACKET;
>+}
>+
> static inline void virtio_transport_del_n_free_pkt(struct virtio_vsock_pkt *pkt)
> {
> 	list_del(&pkt->list);
>@@ -1050,39 +1058,49 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 			      struct virtio_vsock_pkt *pkt)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
>-	bool can_enqueue, free_pkt = false;
>+	bool free_pkt = false;
>
> 	pkt->len = le32_to_cpu(pkt->hdr.len);
> 	pkt->off = 0;
>
> 	spin_lock_bh(&vvs->rx_lock);
>
>-	can_enqueue = virtio_transport_inc_rx_pkt(vvs, pkt);
>-	if (!can_enqueue) {
>+	if (!virtio_transport_inc_rx_pkt(vvs, pkt)) {
> 		free_pkt = true;
> 		goto out;
> 	}
>
>-	/* Try to copy small packets into the buffer of last packet queued,
>-	 * to avoid wasting memory queueing the entire buffer with a small
>-	 * payload.
>-	 */
>-	if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
>-		struct virtio_vsock_pkt *last_pkt;
>+	switch (le32_to_cpu(pkt->hdr.type)) {
                 ^
hdr.type is __le16, so please use le16_to_cpu()

>+	case VIRTIO_VSOCK_TYPE_STREAM: {
>+		/* Try to copy small packets into the buffer of last 
>packet queued,
>+		 * to avoid wasting memory queueing the entire buffer with a small
>+		 * payload.
>+		 */
>+		if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
>+			struct virtio_vsock_pkt *last_pkt;
>
>-		last_pkt = list_last_entry(&vvs->rx_queue,
>-					   struct virtio_vsock_pkt, list);
>+			last_pkt = list_last_entry(&vvs->rx_queue,
>+						   struct virtio_vsock_pkt, list);
>
>-		/* If there is space in the last packet queued, we copy the
>-		 * new packet in its buffer.
>-		 */
>-		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
>-			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
>-			       pkt->len);
>-			last_pkt->len += pkt->len;
>-			free_pkt = true;
>-			goto out;
>+			/* If there is space in the last packet queued, we copy the
>+			 * new packet in its buffer.
>+			 */
>+			if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
>+				memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
>+				       pkt->len);
>+				last_pkt->len += pkt->len;
>+				free_pkt = true;
>+				goto out;
>+			}
> 		}
>+
>+		break;
>+	}
>+	case VIRTIO_VSOCK_TYPE_SEQPACKET: {
>+		break;
>+	}
>+	default:
>+		goto out;
> 	}
>
> 	list_add_tail(&pkt->list, &vvs->rx_queue);
>@@ -1101,6 +1119,14 @@ virtio_transport_recv_connected(struct sock *sk,
> 	int err = 0;
>
> 	switch (le16_to_cpu(pkt->hdr.op)) {
>+	case VIRTIO_VSOCK_OP_SEQ_BEGIN: {
>+		struct virtio_vsock_sock *vvs = vsk->trans;
>+
>+		spin_lock_bh(&vvs->rx_lock);
>+		list_add_tail(&pkt->list, &vvs->rx_queue);
>+		spin_unlock_bh(&vvs->rx_lock);
>+		return err;
>+	}
> 	case VIRTIO_VSOCK_OP_RW:
> 		virtio_transport_recv_enqueue(vsk, pkt);
> 		sk->sk_data_ready(sk);
>@@ -1247,6 +1273,12 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
> 	return 0;
> }
>
>+static bool virtio_transport_valid_type(u16 type)
>+{
>+	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
>+	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
>+}
>+
> /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
>  * lock.
>  */
>@@ -1272,7 +1304,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 					le32_to_cpu(pkt->hdr.buf_alloc),
> 					le32_to_cpu(pkt->hdr.fwd_cnt));
>
>-	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
>+	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
> 		(void)virtio_transport_reset_no_sock(t, pkt);
> 		goto free_pkt;
> 	}
>@@ -1289,6 +1321,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 		}
> 	}
>
>+	if (virtio_transport_get_type(sk) != le16_to_cpu(pkt->hdr.type)) {
>+		(void)virtio_transport_reset_no_sock(t, pkt);
>+		goto free_pkt;
>+	}
>+
> 	vsk = vsock_sk(sk);
>
> 	space_available = virtio_transport_space_update(sk, pkt);
>-- 
>2.25.1
>

