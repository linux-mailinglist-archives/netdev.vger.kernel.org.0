Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0832B366815
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbhDUJes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:34:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41510 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238079AbhDUJer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618997654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lpoI9NRVB9qsYiKBOjY+ZdCUBK0VWmcEa3eQmAnrZgM=;
        b=UtGy74ILGTHzWrTPKwacuiYvdVU9Z4t2kxsMYb8ldWrM5zSc20FNOkV6ZjFwRjOg/jpS3z
        pGHsqExOn/VOdNCYFjF/d3yw99mpXTNpVKFIByBqVzpyH7UHxSI2dISfEHLPVh6kLfpn/2
        P0XMKgdxc8wXM0LZoXJm8lqmNDX5DSA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-NsKEaY4xMxmoHUL2xgV3aQ-1; Wed, 21 Apr 2021 05:34:13 -0400
X-MC-Unique: NsKEaY4xMxmoHUL2xgV3aQ-1
Received: by mail-ed1-f72.google.com with SMTP id f9-20020a50fe090000b02903839889635cso12727341edt.14
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 02:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lpoI9NRVB9qsYiKBOjY+ZdCUBK0VWmcEa3eQmAnrZgM=;
        b=TbJQ2ClrChRi1ttkwAN5Ci0fzhjsVUYMC2f3LINyIuliaPeYW0mqukJaF5oJAVwKEO
         g2LIiKI8F/dcEahU6FwHDqWfb1XmnLB2HNOo+nnhbKmLrICDqj/vuz4omokREMkfrUan
         m56P5zfsRKQ2aQx1hVo/syJIa5UthjhbYAhD9/mFPws17CJFOTVhOTM5g55IbQDTelqu
         BAbFdA4YYaSkM+ewJUZoSR2RnWM6tPulDjIhwlNJIKr6R1l0emEiudKn46ih/gBvEs1d
         u0tJPIfxfc5UDDtnTid1USOQri0BHbjCRlVQZHA74txl5UYYLY1aTz4aKtskzoyCtY7E
         VsuQ==
X-Gm-Message-State: AOAM530gkB73Nyux7HEUGCBa+lsAPo4mvzbmum7B03k73nIHD/OqDwLD
        xAWBg3W9qBPJYqY/moB/dze+sY/QDT21xTKTNp87s5yRmtz0CseRlBdEz98NpHWy1Objy5YR0h3
        HQTfhipq8YobwMetP
X-Received: by 2002:a17:906:5a83:: with SMTP id l3mr16652034ejq.50.1618997651891;
        Wed, 21 Apr 2021 02:34:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydZjMGm8LWfdlf7IEz5Kzgw+nZROXo4yoyEKgJ4CVcOLHoFG40yO1hYMeXrSjiHD1qHIw/Iw==
X-Received: by 2002:a17:906:5a83:: with SMTP id l3mr16652025ejq.50.1618997651755;
        Wed, 21 Apr 2021 02:34:11 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id f19sm2606693edu.12.2021.04.21.02.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:34:11 -0700 (PDT)
Date:   Wed, 21 Apr 2021 11:34:09 +0200
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
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v8 16/19] vsock/loopback: enable SEQPACKET for
 transport
Message-ID: <20210421093409.latwryhd7scomdav@steredhat>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124642.3406320-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210413124642.3406320-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 03:46:39PM +0300, Arseny Krasnov wrote:
>This adds SEQPACKET ops for loopback transport and 'seqpacket_allow()'
>callback.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>---
> net/vmw_vsock/vsock_loopback.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index a45f7ffca8c5..d38ffdbecc84 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -63,6 +63,8 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
> 	return 0;
> }
>
>+static bool vsock_loopback_seqpacket_allow(void);
>+
> static struct virtio_transport loopback_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -89,6 +91,10 @@ static struct virtio_transport loopback_transport = {
> 		.stream_is_active         = virtio_transport_stream_is_active,
> 		.stream_allow             = virtio_transport_stream_allow,
>
>+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>+		.seqpacket_allow          = vsock_loopback_seqpacket_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>@@ -103,8 +109,14 @@ static struct virtio_transport loopback_transport = {
> 	},
>
> 	.send_pkt = vsock_loopback_send_pkt,
>+	.seqpacket_allow = true
> };
>
>+static bool vsock_loopback_seqpacket_allow(void)
>+{
>+	return loopback_transport.seqpacket_allow;
>+}

here I think we could always return true, since we will remove 
`.seqpacket_allow` from struct virtio_transport.

>+
> static void vsock_loopback_work(struct work_struct *work)
> {
> 	struct vsock_loopback *vsock =
>-- 
>2.25.1
>

