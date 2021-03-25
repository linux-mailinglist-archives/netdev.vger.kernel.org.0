Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32487348DF6
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 11:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCYK12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 06:27:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230053AbhCYK1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 06:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616668021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YnnJOjLqRsNOiRCl1VmxWYaDtnFLgBh+G/O9tqpx3N4=;
        b=eQBdZo0ZAFBCEb79grPnk85P9vptY2tbCFgwjUTqUW7IhML5wO6/qWqZ/cZRv/KeEcshyb
        XjaEx/+lScB3AwZyapjoQF7KfRc3zut3hc43eAVMmXg/QDHZGkGE2j82E+NmsnQL6fBVNk
        73w75ob4bN3PIrUDeIOEjvN3jpH+H/c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-G9cBs4XgMx2GoQEmoALU7w-1; Thu, 25 Mar 2021 06:26:59 -0400
X-MC-Unique: G9cBs4XgMx2GoQEmoALU7w-1
Received: by mail-wm1-f70.google.com with SMTP id k132so1498571wma.1
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 03:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YnnJOjLqRsNOiRCl1VmxWYaDtnFLgBh+G/O9tqpx3N4=;
        b=XUOYVvCqYDGMuw1QLGvRVcAOsvw3UNUuCm7J8ZmQ2eHUJTDZsGK3OWh4Se3yy4Rf43
         r51lBbcmr03YZVKEC8w+RRGB8xie9F0omNSZzLhPFNW+2wMIq3iObvD/smJ2lPjcoV+F
         VvwuZ05PDNK4H2betHSjElV4oc7KdKtST6DjZWaWTncikc9rMs15LAG9ghQt073StzR4
         9WcWdxMl8KWZDZvzA7sIDDdbdgqk7mN923AIxeZ78yPiGZk9iumzfajvuR+KccRY5Wbg
         I++XDHaRbs6kANjVxaOA2//DyoBCbYbMBA1OOZBya/0HKlYNtRBTNIbkRAlaKYmb+Jp7
         VX1g==
X-Gm-Message-State: AOAM532W6JXlsRgf+zKc9DpalwE69o7mnud2t8UAmbT7u9rqhbioMknc
        imduXhu7hVyFVhWEOcp6oLdchYNzJB5DLS7RXwvvbKQkVeS6gteUJ4l27q39J8k/A7PxDojyidd
        Sdcd5DscnvBmG+BlS
X-Received: by 2002:adf:fd48:: with SMTP id h8mr8238598wrs.229.1616668018214;
        Thu, 25 Mar 2021 03:26:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBTujIWNkDzf/wNwRNzZd57i5I9jgY+9t+YqLrMxkr/bkSu6aLA/urK8lINmqRAJa9Wu/cyw==
X-Received: by 2002:adf:fd48:: with SMTP id h8mr8238578wrs.229.1616668018030;
        Thu, 25 Mar 2021 03:26:58 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id p17sm5370291wmq.47.2021.03.25.03.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 03:26:57 -0700 (PDT)
Date:   Thu, 25 Mar 2021 11:26:55 +0100
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
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 15/22] virtio/vsock: SEQPACKET support feature bit
Message-ID: <20210325102655.ujyfpapvwnubcggn@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131352.2461534-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323131352.2461534-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 04:13:49PM +0300, Arseny Krasnov wrote:
>This adds new virtio vsock specific feature bit which means
>SOCK_SEQPACKET support. Guest negotiates this bit with vhost,
>thus checking that vhost side supports SEQPACKET.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/uapi/linux/virtio_vsock.h | 3 +++
> 1 file changed, 3 insertions(+)

Since you have this patch, I think you can generalize the title, update 
the description, and merge here the changes I mentioned in patch 11/22 
about changes of include/uapi/linux/virtio_vsock.h.

So you can have a single patch with the new virtio-spec defines and 
structs related to SEQPACKET, of course then we move it before patch 11.

What do you think?

Stefano

>
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 692f8078cced..619aaebb355a 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -38,6 +38,9 @@
> #include <linux/virtio_ids.h>
> #include <linux/virtio_config.h>
>
>+/* The feature bitmap for virtio vsock */
>+#define VIRTIO_VSOCK_F_SEQPACKET	0	/* SOCK_SEQPACKET supported */
>+
> struct virtio_vsock_config {
> 	__le64 guest_cid;
> } __attribute__((packed));
>-- 
>2.25.1
>

