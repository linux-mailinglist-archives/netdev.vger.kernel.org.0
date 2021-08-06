Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238783E23FA
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 09:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243615AbhHFH3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 03:29:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243213AbhHFH3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 03:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628234934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YI2lpjNjLO4bbJ7dq0evOTMBQAQSvAtnohvXHPYKA6U=;
        b=Pi65d7bLQW4iZhslq9LdcUVYHkvCNIo9uMv61fSFFrchNPKsiFy0zAFoJbaD1BhT4AkD8c
        chmqzMdphc8bTNZTqEVcNijtFACFINRB+yvD93rtm96k8s98GpUrgFMHu8Lx5VewdcSs9F
        cbpdVW9B6AJWajkb1IZ4wFp28e4wFlA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-ggymw0h8Npy7JzchfMzjJg-1; Fri, 06 Aug 2021 03:28:53 -0400
X-MC-Unique: ggymw0h8Npy7JzchfMzjJg-1
Received: by mail-ej1-f71.google.com with SMTP id x5-20020a1709064bc5b02905305454f5d1so2848397ejv.10
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 00:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YI2lpjNjLO4bbJ7dq0evOTMBQAQSvAtnohvXHPYKA6U=;
        b=XoDjfCJ3CUqSGePEg6auWxsfk3uKVCspqsvaEWyeQk2m+acJGUoAyByFD1iTpsBMSk
         mLjPAiPXMZcTQO0liq7nVBnYphsREZPDZ16QD0CqSlyPsDdV+oeAwi0Y4TNm0y1RExsv
         JW++/qP/BR+9SBHASe3jEVmhPwFZWHgXzaR4ikYA6Xw1xvNiKOLD5LcPD0IEG6+WKXuf
         Hnq8Pb6UQncdE4F2nCbugNMZefnTCMPcx2uNtyzYlhCaRLTcj+kWrkGfB/GYIKmvYzNp
         agbYXb9OXov1hNNac6sFWoDiBdY+fjJBXDG16Dj2g2HCzej/DhkkyVGIaBQCsshrYf+L
         Qctg==
X-Gm-Message-State: AOAM531wv3hNFkPHZ/Sc/J7rhgSuU0VDF3AYHdfjaF89qdG02Uu6fDhF
        L09Pr1tQXNsJepek98s1WH8wH+XPhri0N6ZgQTI8qnioeQIkEf38Ao7akena60xJ0CYR8FXuxwo
        DiHvB+FPGCFd9Sy0f
X-Received: by 2002:aa7:c794:: with SMTP id n20mr546489eds.244.1628234932578;
        Fri, 06 Aug 2021 00:28:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKisyk358bceGT2heyJE0PRcG1aZN0zSV/ZG+Jy0+uAynRlV6ioYSXV4qTARzSycSTWVsKSA==
X-Received: by 2002:aa7:c794:: with SMTP id n20mr546475eds.244.1628234932453;
        Fri, 06 Aug 2021 00:28:52 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id i16sm3423692edr.38.2021.08.06.00.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 00:28:52 -0700 (PDT)
Date:   Fri, 6 Aug 2021 09:28:49 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 3/7] vhost/vsock: support MSG_EOR bit processing
Message-ID: <20210806072849.4by3wbdkg2bsierm@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210726163341.2589759-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210726163341.2589759-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 07:33:38PM +0300, Arseny Krasnov wrote:
>It works in the same way as 'end-of-message' bit: if packet has
>'EOM' bit, also check for 'EOR' bit.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c | 12 +++++++++++-
> 1 file changed, 11 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 3b55de70ac77..3e2b150f9c6f 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -115,6 +115,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		size_t iov_len, payload_len;
> 		int head;
> 		bool restore_msg_eom_flag = false;
>+		bool restore_msg_eor_flag = false;

Since we now have 2 flags to potentially restore, we could use a single
variable (e.g. uint32_t flags_to_restore), initialized to 0.

We can set all the flags we need to restore and then simply put it
in or with the `pkt->hdr.flags` field.

> 		spin_lock_bh(&vsock->send_pkt_list_lock);
> 		if (list_empty(&vsock->send_pkt_list)) {
>@@ -188,6 +189,11 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
> 				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
> 				restore_msg_eom_flag = true;
>+
>+				if (le32_to_cpu(pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)) {
                                                                ^
Here it should be `le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR`

>+					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+					restore_msg_eor_flag = true;
>+				}
> 			}
> 		}
>
>@@ -224,9 +230,13 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		 * to send it with the next available buffer.
> 		 */
> 		if (pkt->off < pkt->len) {
>-			if (restore_msg_eom_flag)
>+			if (restore_msg_eom_flag) {
> 				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>
>+				if (restore_msg_eor_flag)
>+					pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+			}
>+

If we use a single variable, here we can simply do:

			pkt->hdr.flags |= cpu_to_le32(flags_to_restore);

Stefano

