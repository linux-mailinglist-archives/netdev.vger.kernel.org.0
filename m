Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593B6433B0D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhJSPuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:50:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhJSPuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 11:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634658506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3Piw9dqGW8KX5c4wzu0TReP8OMfYCDJCIB53OxyOgc=;
        b=dyXR1MJvJHhNyCzA5yJ99S22ZgXmdlTmieh+owxJJ8S7bNw3UjW4iS3mcGtNl6soeF7vft
        9BOmGMLWNu8vmn35dysJ0lfOUTV9K/JIrCGydgpMtwiiOKNxyzhWVBwNIzb7Uxqw8ZOmci
        OKhb0qaB/+u0OKJAUPzlWXdZwRF6h7Q=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-xqhyGAsbNHGCWXH8lfY1PA-1; Tue, 19 Oct 2021 11:48:23 -0400
X-MC-Unique: xqhyGAsbNHGCWXH8lfY1PA-1
Received: by mail-oi1-f198.google.com with SMTP id w69-20020acac648000000b00298a3aee9a6so2099756oif.4
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 08:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u3Piw9dqGW8KX5c4wzu0TReP8OMfYCDJCIB53OxyOgc=;
        b=heuzCNWupAP0pKmiahYpWu8FSFst4+mLdic2i57osUsUKHIuPSlgF/Q2ffa18rYDe8
         LlQ9expSNzydtK6lZzVjU+j5TZTqWrklS0+Tu01StS1lNY26nBXWhME0pL2Y3xc8CN2P
         /hEv/f5KNCgQ4GZbhNY4DRriTFjajEAm1iGDR0/wU+6FMOuyxm3uRGcYZ7RRBVvBrvAl
         EHTA6wOJ8rMyJtDs94Q2MA6W4vbh/7Iwo1ZX/El0XpikTukQldEIvQOw3XfAU1+Fo48t
         azwxbNdMOgeGDE+Kq6nhcE3qGcR/szCEGstqHOm3fkfZyeTxUL88BKMTtRqEEw319DOx
         XabA==
X-Gm-Message-State: AOAM532J9uq6PGHkLVKtpXJrenPs0eBfCHrcH1SvrX933YWPd/rKsiGc
        6KR7pwHxOfqr1AJVXQHFRAbw8NxhlAO3gZm4W+C26EQVHFjnQnM4m3JnlsCQcrhOIOxtR/DLFyY
        HndfmVHzZTYlXBO5c
X-Received: by 2002:a05:6830:308a:: with SMTP id f10mr6082820ots.150.1634658502497;
        Tue, 19 Oct 2021 08:48:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsvt2knK92qkTY42CACssaCcc4yXHQw/N/K5pD6CeNVMYIgblNrRm1oMRU/lODA/PQz3J/Ag==
X-Received: by 2002:a05:6830:308a:: with SMTP id f10mr6082810ots.150.1634658502306;
        Tue, 19 Oct 2021 08:48:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bk8sm3226393oib.57.2021.10.19.08.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:48:21 -0700 (PDT)
Date:   Tue, 19 Oct 2021 09:48:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V2 mlx5-next 08/14] vfio: Add a macro for
 VFIO_DEVICE_STATE_ERROR
Message-ID: <20211019094820.2e9bfc01.alex.williamson@redhat.com>
In-Reply-To: <20211019105838.227569-9-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
        <20211019105838.227569-9-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 13:58:32 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Add a macro for VFIO_DEVICE_STATE_ERROR to be used to set/check an error
> state.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 114ffcefe437..6d41a0f011db 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -631,6 +631,8 @@ struct vfio_device_migration_info {
>  	__u64 data_size;
>  };
>  
> +#define VFIO_DEVICE_STATE_ERROR (VFIO_DEVICE_STATE_SAVING | \
> +				 VFIO_DEVICE_STATE_RESUMING)

This should be with the other VFIO_DEVICE_STATE_foo #defines.  I'd
probably put it between _RESUMING and _MASK.  Thanks,

Alex

>  /*
>   * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
>   * which allows direct access to non-MSIX registers which happened to be within

