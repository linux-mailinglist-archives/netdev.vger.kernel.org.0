Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5182A37F70A
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhEMLrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:47:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232005AbhEMLrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620906352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MT3wo5NP4c6jdkY4rdnz2C8pxWgXXp6JkWRd1hEobAU=;
        b=Oz+d1hkbtQQL4nu0JPtUVsoz5ubvinQZZMwfOWPPFxdUqQllwtQgt9LpZi1ICzFKX8ehzX
        iDeNpXkWdgkF8GQ9PhKD/H34oSZjPtUopIksYeCxAJPtQke6NKHHztDY0IPtHeLhWf3168
        D2uSs6TYR5zRkQAfX5xocRST0EuI9So=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-mtwcU8mfOUmIrz625pfr4w-1; Thu, 13 May 2021 07:45:48 -0400
X-MC-Unique: mtwcU8mfOUmIrz625pfr4w-1
Received: by mail-ed1-f70.google.com with SMTP id i19-20020a05640242d3b0290388cea34ed3so14472557edc.15
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 04:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MT3wo5NP4c6jdkY4rdnz2C8pxWgXXp6JkWRd1hEobAU=;
        b=RgTBEt1PJJzodeEEYdaPgCMEUM2z2dDERZ/V2X8BwIZPH+xrbYHKno7C2cbSYqXz2J
         NNxF6euxA2TFbFxYhCNVFJsfyajn/lEzkrDETSl5lR541pF0Q2a9suEREf6JV2WZ09Fk
         9aB3GWqYgfUTMJWaib1nvObkkh5yAVSv1IhHi/5Yzep4eIXjKyiiLmzjxp2Mr+TEo3bn
         oCpy0OvfrfPhSLQTDj5M2JYY4wOoqr4dnsoWEa7y2KCYmokYCJZJCgPV0jttr64HcEVY
         H1wZvZeQG0++uI3mwvJr9rLlq9eAtDv7Vrh70tT8lOnBHq0KfXXrS8RBL5W387pTwdbk
         ZPBg==
X-Gm-Message-State: AOAM530a/DfEoEIPLLSEoBLYVHtwNioOSrj4oee6KpJGfSIkaLtQD9bj
        c+7HYCo3SVr1BRZ6tzN/xZ780Ko875KX+yWpoFSlg0GnwXTfXOhVemxH+/7/xLD0wVmuVog2yVL
        ljWHCRW2a43rj8pP5
X-Received: by 2002:aa7:db90:: with SMTP id u16mr49671406edt.106.1620906347032;
        Thu, 13 May 2021 04:45:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK9y97PFsnFtKG2m387tQ7wMAVv4mrXxkCxS1dn+cI2Zu3pe2nfVjZZrdViT0h2czbettl2g==
X-Received: by 2002:aa7:db90:: with SMTP id u16mr49671388edt.106.1620906346853;
        Thu, 13 May 2021 04:45:46 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id f7sm1685809ejz.95.2021.05.13.04.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:45:46 -0700 (PDT)
Date:   Thu, 13 May 2021 13:45:43 +0200
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
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 10/19] virtio/vsock: defines and constants for
 SEQPACKET
Message-ID: <20210513114543.hucvkhky3tlmvabl@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163508.3431890-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163508.3431890-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:35:05PM +0300, Arseny Krasnov wrote:
>This adds set of defines and constants for SOCK_SEQPACKET
>support in vsock. Here is link to spec patch, which uses it:
>
>https://lists.oasis-open.org/archives/virtio-comment/202103/msg00069.html

Will you be submitting a new version?

>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/uapi/linux/virtio_vsock.h | 9 +++++++++
> 1 file changed, 9 insertions(+)
>
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 1d57ed3d84d2..3dd3555b2740 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -38,6 +38,9 @@
> #include <linux/virtio_ids.h>
> #include <linux/virtio_config.h>
>
>+/* The feature bitmap for virtio vsock */
>+#define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>+
> struct virtio_vsock_config {
> 	__le64 guest_cid;
> } __attribute__((packed));
>@@ -65,6 +68,7 @@ struct virtio_vsock_hdr {
>
> enum virtio_vsock_type {
> 	VIRTIO_VSOCK_TYPE_STREAM = 1,
>+	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
> };
>
> enum virtio_vsock_op {
>@@ -91,4 +95,9 @@ enum virtio_vsock_shutdown {
> 	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
> };
>
>+/* VIRTIO_VSOCK_OP_RW flags values */
>+enum virtio_vsock_rw {
>+	VIRTIO_VSOCK_SEQ_EOR = 1,
>+};
>+
> #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>-- 
>2.25.1
>

Looks good:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

