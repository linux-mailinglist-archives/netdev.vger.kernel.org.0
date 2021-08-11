Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E2D3E8CD1
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 11:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbhHKJGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 05:06:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236397AbhHKJGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 05:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628672773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nY+KsOIvdmq/I8f8sHJvd3e52ylxx2cGgSYbPUMLTyI=;
        b=dfCHBeibix8mWwilFzqiAj8jYXl6P/PrYH4dQ7fdDrkL4VMPxlVbhUAynIFVi4vGbA/hWX
        sb2+ubHQkwvNOPAKKX8Ug+HprAwgin9Lf2BnbczoLlRaCro96pDbUTlCG9EnFiK4ovFHLt
        /0C7iCImodKKdBZcQS+Pm2kWJMacR9c=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-cHG0tQsDMAWFezJTSoh_mQ-1; Wed, 11 Aug 2021 05:06:11 -0400
X-MC-Unique: cHG0tQsDMAWFezJTSoh_mQ-1
Received: by mail-ej1-f72.google.com with SMTP id ci25-20020a1709072679b029058e79f6c38aso420663ejc.13
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 02:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nY+KsOIvdmq/I8f8sHJvd3e52ylxx2cGgSYbPUMLTyI=;
        b=Tt6f6ciYDrBHzX9kixhXBecz1+ZHiI3ZP88I/VYbdRniq1Ccjsvj58BcfGMaWpx9FM
         mDpeP/Nzv/jpTTv5MERBfwwGGa0k4uWjndd2o3Vd8U7mqk1ZncyBF4j7LGc+T4FxpMqS
         R3HlVNyHpY8ltmieK6cqfWVGEhhNqGsuVdBviG59sXtV5FioSXu4nmBzkPDVDwDX4l0d
         ksesMn1L6u9EUHPbkZ6bMFyupVPP97oVxDhxde12ZUPKfF5d18+HJZAV6nMo0Zjx2Rlt
         i2nTLT/ZqNPgyKseSxf+wsO4IAJ2ZrROeF/G93btcjX0LtKW0/GVBNiKzlYAGAfiy4SV
         aYZw==
X-Gm-Message-State: AOAM532L6I9gUI1ffR+hx66tKfyrNbJn96vWQldVHFA5mDQEM4hAuCB7
        3fXIKiILfswNKnw1myP/j5ooQDHglTkUuExL5sT3K5IrRYAI0J1PXVNTyA7UMiFE9Rjq9MBxMt6
        NMxJ0gZ5fAH0TdcO+
X-Received: by 2002:a17:906:e57:: with SMTP id q23mr2580418eji.483.1628672770531;
        Wed, 11 Aug 2021 02:06:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydlQt4cUzS593TJoOXM9aBHzAXiW4JJ0JmGJ2tgg4wf8bTFkdPRDcvQCA3d1fcsJESLEh/Sg==
X-Received: by 2002:a17:906:e57:: with SMTP id q23mr2580395eji.483.1628672770414;
        Wed, 11 Aug 2021 02:06:10 -0700 (PDT)
Received: from steredhat (a-nu5-14.tin.it. [212.216.181.13])
        by smtp.gmail.com with ESMTPSA id m12sm7955692ejd.21.2021.08.11.02.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:06:10 -0700 (PDT)
Date:   Wed, 11 Aug 2021 11:06:07 +0200
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
Subject: Re: [RFC PATCH v2 2/5] vhost/vsock: support MSG_EOR bit processing
Message-ID: <20210811090607.bl3cjsjrsg2ss7dp@steredhat>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
 <20210810114018.1214619-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210810114018.1214619-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:40:15PM +0300, Arseny Krasnov wrote:
>It works in the same way as 'end-of-message' bit: if packet has
>'EOM' bit, also check for 'EOR' bit.

Please describe all changes, e.g. the new variable to accumulate flags 
to restore.

>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> drivers/vhost/vsock.c | 12 ++++++++----
> 1 file changed, 8 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index feaf650affbe..06fc132b13c8 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -114,7 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		size_t nbytes;
> 		size_t iov_len, payload_len;
> 		int head;
>-		bool restore_flag = false;
>+		uint32_t flags_to_restore = 0;
>
> 		spin_lock_bh(&vsock->send_pkt_list_lock);
> 		if (list_empty(&vsock->send_pkt_list)) {
>@@ -187,7 +187,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 			 */
> 			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
> 				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>-				restore_flag = true;
>+				flags_to_restore |= le32_to_cpu(VIRTIO_VSOCK_SEQ_EOM);
>+
>+				if (le32_to_cpu(pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR)) {
>+					pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>+					flags_to_restore |= le32_to_cpu(VIRTIO_VSOCK_SEQ_EOR);
                                                             ^
I'm not sure this is needed, VIRTIO_VSOCK_SEQ_EOR is represented in the 
cpu endianess.

I think here you can simpy do `flags_to_restore |= VIRTIO_VSOCK_SEQ_EOR` 
then use `pkt->hdr.flags |= cpu_to_le32(flags_to_restore);` as you 
already do.

>+				}
> 			}
> 		}
>
>@@ -224,8 +229,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		 * to send it with the next available buffer.
> 		 */
> 		if (pkt->off < pkt->len) {
>-			if (restore_flag)
>-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>+			pkt->hdr.flags |= cpu_to_le32(flags_to_restore);
>
> 			/* We are queueing the same virtio_vsock_pkt to handle
> 			 * the remaining bytes, and we want to deliver it
>-- 
>2.25.1
>

