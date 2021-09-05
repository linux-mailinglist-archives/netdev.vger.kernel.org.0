Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65EA4010A4
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237589AbhIEPvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 11:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236513AbhIEPvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 11:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630857019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dt3+lUrr17xrCqRRoNhFo4SoQOQwGb+2P4GqnUIMZG4=;
        b=ZGDlo0d5jxQ1ZDCumKj0VG6tpGI/E76mQRQZzSiaQXq5SQoouQ5n0ykhQ0/+rarJ7+IkBz
        Vki8ZuEHELeC+KDepNrk71EJr16msnlxY2GQfQ00g1azTZ11vdoZGv+wR0YXwyxaC/B3ZI
        YW9GsgG1YfR0i05pNY/Ko4b0XYIJk3s=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-0bnvgPJHNVS8GHnyYDEgSw-1; Sun, 05 Sep 2021 11:50:18 -0400
X-MC-Unique: 0bnvgPJHNVS8GHnyYDEgSw-1
Received: by mail-ed1-f72.google.com with SMTP id bf22-20020a0564021a5600b003c86b59e291so2297493edb.18
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 08:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dt3+lUrr17xrCqRRoNhFo4SoQOQwGb+2P4GqnUIMZG4=;
        b=lCy9NMcq2ZVQvCzT6m3S86QJMHSD69pToOmD1Uc4qn68Ar6lyK5ctbxCFL7b8HEldM
         Q1zPQDYLK6UKySy91Ne4YkQ1ahi+lNnNDnTJxsdJguDgGDc0WX3Mzv5dWZYllaBljhaK
         rP/4tFz6cfP0YhFhP4NAUxZVxdQAY7jEIzgQg8faGRgKE6OCL8ZX3cDDulQJA6gcZwud
         7Hm9FCd6j8PWDkZZnoFlQscb2fiWH6n1rqUpepBUg3qBJjyuxC0ZRWJiBNuVj0ZgHDoY
         EIsGpHQ9LwBtRZmGdUNnsC9RFXrhEZqVgmUDqbWfkGY3nfmtCwCF3NllLVm4iwKCdkdC
         qP3Q==
X-Gm-Message-State: AOAM530s3P/DvLrMDpMUCN4L+6WqPTqwAOyPpgH+5M990pPsOQJjPJbk
        6d2J3v0fmbYKtep4MDAlTrNCJKtlXXq274YIXvGpy6LQIMWlXzs7GjDVpKjGTXaUuQKxbxk9Psy
        J7LKC6yxVEzGlhBMU
X-Received: by 2002:aa7:c514:: with SMTP id o20mr9209156edq.318.1630857016058;
        Sun, 05 Sep 2021 08:50:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/Vr1hTVx3/Sty6LNqcZMAJAOmpd1FUx3LtNW8reY+9FMDFhx51QrJugo5epYEB0BNnX/rsw==
X-Received: by 2002:aa7:c514:: with SMTP id o20mr9209144edq.318.1630857015928;
        Sun, 05 Sep 2021 08:50:15 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id g18sm2495519ejr.99.2021.09.05.08.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 08:50:15 -0700 (PDT)
Date:   Sun, 5 Sep 2021 11:50:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v4 2/6] virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR'
 bit.
Message-ID: <20210905115002-mutt-send-email-mst@kernel.org>
References: <20210903061353.3187150-1-arseny.krasnov@kaspersky.com>
 <20210903061523.3187714-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903061523.3187714-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 09:15:20AM +0300, Arseny Krasnov wrote:
> This bit is used to handle POSIX MSG_EOR flag passed from
> userspace in 'send*()' system calls. It marks end of each
> record and is visible to receiver using 'recvmsg()' system
> call.
> 
> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Spec patch for this?

> ---
>  include/uapi/linux/virtio_vsock.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> index 8485b004a5f8..64738838bee5 100644
> --- a/include/uapi/linux/virtio_vsock.h
> +++ b/include/uapi/linux/virtio_vsock.h
> @@ -98,6 +98,7 @@ enum virtio_vsock_shutdown {
>  /* VIRTIO_VSOCK_OP_RW flags values */
>  enum virtio_vsock_rw {
>  	VIRTIO_VSOCK_SEQ_EOM = 1,
> +	VIRTIO_VSOCK_SEQ_EOR = 2,
>  };
>  
>  #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
> -- 
> 2.25.1

