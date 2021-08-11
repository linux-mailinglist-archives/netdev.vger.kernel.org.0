Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33E3E8CBA
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 11:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbhHKJBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 05:01:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29602 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236473AbhHKJBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 05:01:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628672437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xVYk6O6UbKVQlEk4hpiQ+ioYAfkIhHzccxHN1Fx+454=;
        b=hePHulxC8UlcraAHRT2aUEJTodurv0JfJB9iGv/keICH5v5gAk1a4MswaPA2PaGeGq6jQO
        e99154TPgPsnoOaGSIYAW6iAJjQy74HNu5CREQhux9Ps7/Kze5KZNfk+7obpIdZMDC+uox
        yjQKBYEESEuCGB7QEYKXU/3iLbs/0kc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-XqItpWd_PrClQWJrhssX6A-1; Wed, 11 Aug 2021 05:00:36 -0400
X-MC-Unique: XqItpWd_PrClQWJrhssX6A-1
Received: by mail-ej1-f71.google.com with SMTP id k21-20020a1709062a55b0290590e181cc34so423804eje.3
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 02:00:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xVYk6O6UbKVQlEk4hpiQ+ioYAfkIhHzccxHN1Fx+454=;
        b=Qjzcofk82Y8Qf6ZsCeYnGb5+5qWZg6nbvpOoStD5IJAkdMMUncmNWrI3ngy+nZnbWc
         La489LlShKvBh4QKd9sQWUylicyO2P+bbQlJBA3CaA49KouP6MeqTsrqst7ll2sJkrjy
         m0KYOk+0RcW/E+suwPbpgJhdbHbGKyWmvV1HyZYIYYtkuiE5Ip1xZ597PDs+mmaAzbxG
         oJxtS41+Or4mIfqEe/eOw+RQqcw5hs3J0NO3TKPIoPZCWBowF/t/cD4MVHwxBizrUhAv
         b9JXGEmmReVhfN9Oy3wEf1slqG6g12Z+i7LLsCH1U5vKH8kx2QdRYmKSy66Q3ddCQDm+
         agzQ==
X-Gm-Message-State: AOAM5300vuKnkjcmioAxpgmBUGk73YDH3Y0Yq37sC7CSCM5ywD5kdu8X
        APLOWMHfesVGP7CbVTaJTXs+zey+gx4iJ/OKd5BkXwb0CzsO+5TrWg6jLkljLaCYoj83ATOYOhY
        HEVpZbst+254pKjRG
X-Received: by 2002:a17:906:a08a:: with SMTP id q10mr2593173ejy.100.1628672433786;
        Wed, 11 Aug 2021 02:00:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+Wh3oVEmn3QZnNAXMGsVm3JaAoH4eSr1ZKRKUam8aqa4jKG8XOA/RBO+z8M1b/2H29w2Viw==
X-Received: by 2002:a17:906:a08a:: with SMTP id q10mr2593146ejy.100.1628672433523;
        Wed, 11 Aug 2021 02:00:33 -0700 (PDT)
Received: from steredhat (a-nu5-14.tin.it. [212.216.181.13])
        by smtp.gmail.com with ESMTPSA id l19sm4147213edb.86.2021.08.11.02.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:00:33 -0700 (PDT)
Date:   Wed, 11 Aug 2021 11:00:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 1/5] virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOM' bit
Message-ID: <20210811090030.snu5ckf6bdkzxdg7@steredhat>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
 <20210810113956.1214463-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210810113956.1214463-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:39:53PM +0300, Arseny Krasnov wrote:

The title is confusing, we are renaming EOR in EOM.

>This bit is used to mark end of messages('EOM' - end of message), while
>'VIRIO_VSOCK_SEQ_EOR' is used to pass MSG_EOR. Also rename 'record' to
>'message' in implementation as it is different things.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c                   | 12 ++++++------
> include/uapi/linux/virtio_vsock.h       |  3 ++-
> net/vmw_vsock/virtio_transport_common.c | 14 +++++++-------
> 3 files changed, 15 insertions(+), 14 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index f249622ef11b..feaf650affbe 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -178,15 +178,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 			 * small rx buffers, headers of packets in rx queue are
> 			 * created dynamically and are initialized with 
> 			 header
> 			 * of current packet(except length). But in case of
>-			 * SOCK_SEQPACKET, we also must clear record delimeter
>-			 * bit(VIRTIO_VSOCK_SEQ_EOR). Otherwise, instead of one
>-			 * packet with delimeter(which marks end of record),
>+			 * SOCK_SEQPACKET, we also must clear message delimeter
>+			 * bit(VIRTIO_VSOCK_SEQ_EOM). Otherwise, instead of one
>+			 * packet with delimeter(which marks end of message),
> 			 * there will be sequence of packets with delimeter
> 			 * bit set. After initialized header will be copied to
> 			 * rx buffer, this bit will be restored.
> 			 */
>-			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
>-				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
>+				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
> 				restore_flag = true;
> 			}
> 		}
>@@ -225,7 +225,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		 */
> 		if (pkt->off < pkt->len) {
> 			if (restore_flag)
>-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>
> 			/* We are queueing the same virtio_vsock_pkt to handle
> 			 * the remaining bytes, and we want to deliver it
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 3dd3555b2740..64738838bee5 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -97,7 +97,8 @@ enum virtio_vsock_shutdown {
>
> /* VIRTIO_VSOCK_OP_RW flags values */
> enum virtio_vsock_rw {
>-	VIRTIO_VSOCK_SEQ_EOR = 1,
>+	VIRTIO_VSOCK_SEQ_EOM = 1,
>+	VIRTIO_VSOCK_SEQ_EOR = 2,
         ^
I think is better to add this new flag in a separate patch.

> };
>
> #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 081e7ae93cb1..4d5a93beceb0 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -77,7 +77,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
>
> 		if (msg_data_left(info->msg) == 0 &&
> 		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
>-			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
> 	}
>
> 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
>@@ -457,7 +457,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 				dequeued_len += pkt_len;
> 		}
>
>-		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
>+		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
> 			msg_ready = true;
> 			vvs->msg_count--;
> 		}
>@@ -1029,7 +1029,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 		goto out;
> 	}
>
>-	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
>+	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)
> 		vvs->msg_count++;
>
> 	/* Try to copy small packets into the buffer of last packet queued,
>@@ -1044,12 +1044,12 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>
> 		/* If there is space in the last packet queued, we copy the
> 		 * new packet in its buffer. We avoid this if the last packet
>-		 * queued has VIRTIO_VSOCK_SEQ_EOR set, because this is
>-		 * delimiter of SEQPACKET record, so 'pkt' is the first packet
>-		 * of a new record.
>+		 * queued has VIRTIO_VSOCK_SEQ_EOM set, because this is
>+		 * delimiter of SEQPACKET message, so 'pkt' is the first packet
>+		 * of a new message.
> 		 */
> 		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
>-		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)) {
>+		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)) {
> 			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
> 			       pkt->len);
> 			last_pkt->len += pkt->len;
>-- 
>2.25.1
>

The rest LGTM!

Thanks,
Stefano

