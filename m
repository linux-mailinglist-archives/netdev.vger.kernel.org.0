Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5FC42F860
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241463AbhJOQk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:40:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241380AbhJOQk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 12:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634315899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OL1xVkJ1GZ3Vp5ZR2VEcp/JIFWoJLAIj138sahWf0nI=;
        b=NOpGfMXRuFgdOyETbQos7lxomZy5caANyRh3AwP6wyg8ZX49FVWEHouoFESn+1ZvJJRW0B
        ACF66jgHu3nRsn9zgqudeO5Ki5AalzcSCLxsMJ4JY1CmCRuhX903fzGQjqkVyZ0IqORPne
        IHMCE72aMQItwED2qWVao3zePgVQiEQ=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-JSACGs1LO2Gh6Ut1xc4l6Q-1; Fri, 15 Oct 2021 12:38:18 -0400
X-MC-Unique: JSACGs1LO2Gh6Ut1xc4l6Q-1
Received: by mail-oo1-f70.google.com with SMTP id c8-20020a4ad208000000b002b6b6df6b7fso4368928oos.13
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 09:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OL1xVkJ1GZ3Vp5ZR2VEcp/JIFWoJLAIj138sahWf0nI=;
        b=Ld+zz93sECjqeTKGvas57YFuatsqoWeIHn8YtIEzsqfZCXCFmcrp8IKfjt888ReKqg
         DvECjmCkXz21YqeTbwctQcbUaWs77sKHWyqI+mV2MsRqg7oWdbQyVz38xbGQS7n+uOBU
         nFWt2M0lqVQry8bZm3LXIS8RsUztD+6WnGbn/lcy1637hHAir9nkwtkCZdBu80eSF07+
         SfoenU9jpd5Jggwh3ex0DnosJsFMilWuA5cna8VUaPcWXbCJs5nMY17srKfixT8yCjXZ
         jSiSZIn4RH7Sx8Jx7GTPms3beC9j+f83Z9XuAYk1vQ0YN9rJ09paCdq+O2rVTGeLPSL/
         PTUQ==
X-Gm-Message-State: AOAM530mtIBAh3n8z8qcsSQgriIZavbrLUx1NFPV6utW3gEbBjOZjETe
        Ki6UDhaSV46vfVByW0PDwu+gF8ZLBcmGmigw18iBfU1X+TZzLC3HBAeVmC9uIvl8KwOzHR15kfw
        oA94UGLkpeFJSzL2I
X-Received: by 2002:a4a:adca:: with SMTP id t10mr9780929oon.19.1634315897609;
        Fri, 15 Oct 2021 09:38:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy07XqbfRReKgHIu02thE2BC8q9a60k39yM0PD78yJmMQBceFMI+pcgwV8uY+kr3MAVEOqLnA==
X-Received: by 2002:a4a:adca:: with SMTP id t10mr9780920oon.19.1634315897403;
        Fri, 15 Oct 2021 09:38:17 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a10sm1334513otb.7.2021.10.15.09.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:38:17 -0700 (PDT)
Date:   Fri, 15 Oct 2021 10:38:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 mlx5-next 07/13] vfio: Add 'invalid' state
 definitions
Message-ID: <20211015103815.4b165d43.alex.williamson@redhat.com>
In-Reply-To: <20211013094707.163054-8-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
        <20211013094707.163054-8-yishaih@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 12:47:01 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Add 'invalid' state definition to be used by drivers to set/check
> invalid state.
> 
> In addition dropped the non complied macro VFIO_DEVICE_STATE_SET_ERROR
> (i.e SATE instead of STATE) which seems unusable.

s/non complied/non-compiled/

We can certainly assume it's unused based on the typo, but removing it
or fixing it should be a separate patch.

> Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/linux/vfio.h      | 5 +++++
>  include/uapi/linux/vfio.h | 4 +---
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index b53a9557884a..6a8cf6637333 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -252,4 +252,9 @@ extern int vfio_virqfd_enable(void *opaque,
>  			      void *data, struct virqfd **pvirqfd, int fd);
>  extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
>  
> +static inline bool vfio_is_state_invalid(u32 state)
> +{
> +	return state >= VFIO_DEVICE_STATE_INVALID;
> +}


Redundant, we already have !VFIO_DEVICE_STATE_VALID(state)

> +
>  #endif /* VFIO_H */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..7f8fdada5eb3 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -609,6 +609,7 @@ struct vfio_device_migration_info {
>  #define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
>  #define VFIO_DEVICE_STATE_SAVING    (1 << 1)
>  #define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> +#define VFIO_DEVICE_STATE_INVALID   (VFIO_DEVICE_STATE_RESUMING + 1)

Nak, device_state is not an enum, this is only one of the states we
currently define as invalid and usage such as the inline above ignores
the device state mask below, which induces future limits on how we can
expand the device_state field.  Thanks,

Alex

>  #define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
>  				     VFIO_DEVICE_STATE_SAVING |  \
>  				     VFIO_DEVICE_STATE_RESUMING)
> @@ -621,9 +622,6 @@ struct vfio_device_migration_info {
>  	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
>  					      VFIO_DEVICE_STATE_RESUMING))
>  
> -#define VFIO_DEVICE_STATE_SET_ERROR(state) \
> -	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> -					     VFIO_DEVICE_STATE_RESUMING)
>  
>  	__u32 reserved;
>  	__u64 pending_bytes;

