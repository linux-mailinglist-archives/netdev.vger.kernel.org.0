Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C764E41C0AD
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 10:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbhI2IeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 04:34:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240284AbhI2IeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 04:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632904342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=33L2kvYESyBjFzI5T12hFb+rWTsyBJjmF6Rb3+aaSJw=;
        b=DPhtQRATFXW5DUFG4STk4GLNZOfKTq2utGGfhyMf423oCtWqRNIPl0k9OwXB917mrfZEPg
        tQVRbCitHUN0IGWUpfghaY0cePxKbE5b3l4TfLfnb4LBnVKJPXKNj6Z6vMF5+2gn1Y3J1T
        kxSMUQ6vnDNnJ74psLR1lPqCkZIAoHg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-mf82CESzNSG4Dgs6IYZ5ig-1; Wed, 29 Sep 2021 04:32:20 -0400
X-MC-Unique: mf82CESzNSG4Dgs6IYZ5ig-1
Received: by mail-wm1-f71.google.com with SMTP id v5-20020a1cac05000000b0030b85d2d479so858654wme.9
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 01:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=33L2kvYESyBjFzI5T12hFb+rWTsyBJjmF6Rb3+aaSJw=;
        b=Uh23krLMq+GL2Qxq5/zXpWW8ulgQyf5AnK9rE/DVa742L6oA/IhrxFbmLgRYEk1Q/3
         mJK7zeXGpR90xQQAxkR/CRaI4TASb/djuRciZdgrGG8m3CD7DGwdcVaYLak/pQizKdfQ
         zwZVErNxCSVuHkIxiHzeiriWQISf64Rdg9waNGhg6T3d6Wepp8bY5SZMeFIL1nKy1PGg
         fqg+os4ZQC0hyFoOnqKS2SVmDOv800SkIl2CtgTzxhUdcW3U7FRmfJJyxevAszCOklz/
         mW2Dx3TTLAL8MQ2N5DtVaUqQirdI+lwxjd+uLoIdhCwMU/8Q+sJfnpB6AvKyMv/46hbH
         PRTw==
X-Gm-Message-State: AOAM532250t2dO03kz1gZ5g9g96U9zzZdbhBazRGHQS/fKg828/Tn6xf
        M+f17dcb9Jq4o6FV587mNThSx2ndvUHo0EChX1y3OceszjlcEG7wC28bGgmZWN1f4wy5WmHzRyP
        ONPn5neBXAN7FG62j
X-Received: by 2002:a1c:4407:: with SMTP id r7mr9093109wma.69.1632904339601;
        Wed, 29 Sep 2021 01:32:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiFH8QvVbSSfltUTVNYrFe4cgpOa802Pjd2dc9VAv6jOjC98+5gHvsdXJBd6/yPoXBjvvJDg==
X-Received: by 2002:a1c:4407:: with SMTP id r7mr9093089wma.69.1632904339405;
        Wed, 29 Sep 2021 01:32:19 -0700 (PDT)
Received: from redhat.com ([2.55.12.29])
        by smtp.gmail.com with ESMTPSA id l21sm851391wme.39.2021.09.29.01.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 01:32:18 -0700 (PDT)
Date:   Wed, 29 Sep 2021 04:32:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cindy Lu <lulu@redhat.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa:fix the worng input in config_cb
Message-ID: <20210929043142-mutt-send-email-mst@kernel.org>
References: <20210929075437.12985-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929075437.12985-1-lulu@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 03:54:37PM +0800, Cindy Lu wrote:
> Fix the worng input in for config_cb,
> in function vhost_vdpa_config_cb, the input
> cb.private was used as struct vhost_vdpa,
> So the inuput was worng here, fix this issue
> 
> Signed-off-by: Cindy Lu <lulu@redhat.com>

Maybe add

Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")

and fix typos in the commit log.

> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 942666425a45..e532cbe3d2f7 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -322,7 +322,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
>  	struct eventfd_ctx *ctx;
>  
>  	cb.callback = vhost_vdpa_config_cb;
> -	cb.private = v->vdpa;
> +	cb.private = v;
>  	if (copy_from_user(&fd, argp, sizeof(fd)))
>  		return  -EFAULT;
>  
> -- 
> 2.21.3

