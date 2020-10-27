Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726C829B7F1
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798592AbgJ0P26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 11:28:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1798553AbgJ0P2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 11:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603812531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mlWO+8V1OcYguip2KBsMhYWBSFJwL/+zUDmEZaIbfJ4=;
        b=WKldZ05uRRnd7jfUDf+eXY82dU6qVMRserWCR3AQCKsYULu3T/y8B1yqIJaoitr6iizuYf
        Hx7lIZ9x8eFNLDGBeLFdrw9z15q1vuarALmscrBIZPINoUz/eJ8klX323OFv0aC1cstaWE
        Yh5Pr3+u/a7yyxYmFlfv0y6WmGdUXC4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-K2fLeYs7PyadhveQAf8nww-1; Tue, 27 Oct 2020 11:28:49 -0400
X-MC-Unique: K2fLeYs7PyadhveQAf8nww-1
Received: by mail-wm1-f71.google.com with SMTP id 13so728129wmf.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 08:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mlWO+8V1OcYguip2KBsMhYWBSFJwL/+zUDmEZaIbfJ4=;
        b=CN15FcECXHDaYaCR+xu3t7oT23mbU+Gdqoc7k+3ZkoTWWphcO5pJgCUZ+5aNn7FdR2
         kVY0bqZnwPsa2P643G3LfbTUhiPLB5pjZKqyO8JN9VQopxxvz1DivtnvaVGoKshkCMca
         /fONEo4YvNH/jObbbEafHfp9mmeqOtuwmBo3u8VVLkmkMQ7lX5p2lZL+mLpstp5XKr+I
         1gFdfkwysNPiqgJTvutEiwMzwgDFY8+yo/XYgaJH4y4ZPiQ1n+wf9FCw4xXb4OftQclc
         LhO3o9ASdRuujizb8erE52eM9n+Yl+Udk4qYPzpOPKeEm4w2jMg6S1nVW0RBfnVoJee9
         wUbA==
X-Gm-Message-State: AOAM530zj2l1BRGkh2sOPfaYa5xLO+1TBiViUYpentNLe3B3HDYxKXmU
        n+Bwcx3eCCX/8LeKXss3rStIOZbud9m4iKM4wjvI7zMluwaARe2ImsAffWkIkDZBOM0YXBYwbkI
        oJsjac3Z2mxrZYWsy
X-Received: by 2002:a1c:2cd7:: with SMTP id s206mr3177570wms.182.1603812526991;
        Tue, 27 Oct 2020 08:28:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuH3n7lQ9eR5dnqf6yc1oFeHmyleXhbTjubsRyj6zs3Jak/y/oaUl12gqM18qHQ8tFGKD6AA==
X-Received: by 2002:a1c:2cd7:: with SMTP id s206mr3177537wms.182.1603812526789;
        Tue, 27 Oct 2020 08:28:46 -0700 (PDT)
Received: from redhat.com (bzq-109-65-21-184.red.bezeqint.net. [109.65.21.184])
        by smtp.gmail.com with ESMTPSA id 3sm2370433wmd.19.2020.10.27.08.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 08:28:45 -0700 (PDT)
Date:   Tue, 27 Oct 2020 11:28:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-gpio@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 3/8] vhost: vringh: use krealloc_array()
Message-ID: <20201027112607-mutt-send-email-mst@kernel.org>
References: <20201027121725.24660-1-brgl@bgdev.pl>
 <20201027121725.24660-4-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027121725.24660-4-brgl@bgdev.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 01:17:20PM +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Use the helper that checks for overflows internally instead of manually
> calculating the size of the new array.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

No problem with the patch, it does introduce some symmetry in the code.

Acked-by: Michael S. Tsirkin <mst@redhat.com>



> ---
>  drivers/vhost/vringh.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 8bd8b403f087..08a0e1c842df 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -198,7 +198,8 @@ static int resize_iovec(struct vringh_kiov *iov, gfp_t gfp)
>  
>  	flag = (iov->max_num & VRINGH_IOV_ALLOCATED);
>  	if (flag)
> -		new = krealloc(iov->iov, new_num * sizeof(struct iovec), gfp);
> +		new = krealloc_array(iov->iov, new_num,
> +				     sizeof(struct iovec), gfp);
>  	else {
>  		new = kmalloc_array(new_num, sizeof(struct iovec), gfp);
>  		if (new) {
> -- 
> 2.29.1

