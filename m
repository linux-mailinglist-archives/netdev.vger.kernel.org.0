Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7760C3B2199
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhFWUMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:12:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229755AbhFWUMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 16:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624478998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SNHwVtAYqqtfz9mNkeT55CF9XxIVuvyFxJlzIeVcLAk=;
        b=T7kl5mwIocf6iUR8dEivC49xk7FE0taqlw2K7PSd9l5wHbAfc7P2y1U8rRmD1KmVaAixXO
        0Q3kckPJ9rPKDRhzlmq96XTCgBQRE44n3oqrrBhQAJZbQaoaZouXXLWFTGEbXTUBvD8xB3
        DUnlJ81xfjLKyH36UZ5GXDFlezZF4H0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-yF3YF8UiNzOPWnlKczGv9w-1; Wed, 23 Jun 2021 16:09:57 -0400
X-MC-Unique: yF3YF8UiNzOPWnlKczGv9w-1
Received: by mail-wr1-f72.google.com with SMTP id f9-20020a5d64c90000b029011a3c2a0337so1467334wri.0
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 13:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SNHwVtAYqqtfz9mNkeT55CF9XxIVuvyFxJlzIeVcLAk=;
        b=F+fSgd68/hXSJlOPeSt1dUNHEkvBriLc7zmc/UQTYKhxdlRuMrDKHAAb6QG9luxKfd
         XFPBGoUpbjNxQEBO6/OQpFY5faYX1SG5qsikFGCGqVtjHpTW5SX7txDzZuVpg8lqnMpc
         EXQOX4IP12kKjDgl4aq5EN3P9aANSOH9E/h8BX/NUvb+uVZscUPoLfXEazPoBHdaY3xC
         3GSOuaXCMg45+F1u52+MNd4ws5iRfWPC7vge5XmosnjxD793IuRbxwfc0eUr71tZzYi5
         SII2zgpCc8RgjTcuw/ABvLL11pgPR3ydc/e2qFdSrU+kdrihwkJyIHDJSbe0kse5BJIz
         gCjQ==
X-Gm-Message-State: AOAM532JruaXgCBWQSL6RtXB7npp1ByNNSNA5kpjGANjeCYjDrTVovJB
        2NlrhODK/IbEi1u1XTt9ZAfWm6+qSX4Y98ikKOcuA8Jrp3IiQDBzoM91ysBCrNOjOJy82IDXJGG
        Y3Lm1505BZMaqUA7Y
X-Received: by 2002:a1c:7212:: with SMTP id n18mr1676695wmc.58.1624478996041;
        Wed, 23 Jun 2021 13:09:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySpClCIQvpk/WXfIxuefSHcb638VT2EVIOvY1Um/TAJISNA6URG63qxqeWkIJOdkwi3J0frg==
X-Received: by 2002:a1c:7212:: with SMTP id n18mr1676677wmc.58.1624478995902;
        Wed, 23 Jun 2021 13:09:55 -0700 (PDT)
Received: from redhat.com ([77.124.79.210])
        by smtp.gmail.com with ESMTPSA id p20sm836135wma.19.2021.06.23.13.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:09:55 -0700 (PDT)
Date:   Wed, 23 Jun 2021 16:09:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Neeraj Upadhyay <neeraju@codeaurora.org>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vringh: Use wiov->used to check for read/write desc order
Message-ID: <20210623160923-mutt-send-email-mst@kernel.org>
References: <1624361873-6097-1-git-send-email-neeraju@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624361873-6097-1-git-send-email-neeraju@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 05:07:53PM +0530, Neeraj Upadhyay wrote:
> As iov->used is incremented when descriptors are processed
> in __vringh_iov(), use it to check for incorrect read
> and write descriptor order.

Could the commit log be clearer? why is wiov->i incorrect here?

> Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
> ---
>  drivers/vhost/vringh.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 4af8fa2..14e2043 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -359,7 +359,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
>  			iov = wiov;
>  		else {
>  			iov = riov;
> -			if (unlikely(wiov && wiov->i)) {
> +			if (unlikely(wiov && wiov->used)) {
>  				vringh_bad("Readable desc %p after writable",
>  					   &descs[i]);
>  				err = -EINVAL;
> -- 
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
> hosted by The Linux Foundation

