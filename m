Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D30A3DA2E3
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhG2MLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbhG2MLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 08:11:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDFEC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 05:11:31 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h14so6625435wrx.10
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 05:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=8Nz6vB9p8A0wBJs6kkDYFIrrTzDZDT+uS9XB0IAUyko=;
        b=IX9QYptYV6st0L1XmOo2+ZVTD1czWMC0yv2A0wEKs5uhoKxyG1M8hYGFid/Rc9caoJ
         g3s8uihSolFDNGNVDmh/KcSkUnjuvxHUSlZem764aZk2d9p45qyVKzkwnR65zmpbIjwe
         oixk5YiEQMSk6egRcnGh8U5DvdkvMLdRPa8MA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=8Nz6vB9p8A0wBJs6kkDYFIrrTzDZDT+uS9XB0IAUyko=;
        b=hL9BrEIjg79AU9qnlAYBmm4tAvrdBQh0FzBrdVDbMnGTt8JLm0LpMwubnyl6o5gU0J
         wTG/nVC7wryeEJBC9e7VguCok5oUsaMSjjRYQMUcYzNxfCP/MZ1eaLiI3Pe/8NeirMoH
         aJxMZ/JKR0dRQWe0iIw5i1Heoc5+fUG/xvWV2eX/i3YrC9nNJD2YFZCP/VvFRe+iBloO
         vcyLZx8CDlfCUXtbEVnxG2DVAzB/GWdqapA3pTjDjZFwsF5ZrBsg/SoI8rPl6gTUf/V0
         qLKO/YZGM2Yu0GsPllEyytz3CC/sa4kQaMTERW36kECfc4XFPwF1Vh+F3Q3p6UWNePg2
         kyJw==
X-Gm-Message-State: AOAM530BLLy/qXgiqaCdBL6DyC2/zV/hrt/lj02kljQEgUD5HCEaSd0Q
        2FLT1QTKdvjDz5gUxmGsTrj9nw==
X-Google-Smtp-Source: ABdhPJyxNFOOp917FBlh8xg1Ee/DiYPVZ7Er8zzOKotZZKyVJ/yUFb4NW2JEu0Us3Suihgl1chkn3Q==
X-Received: by 2002:a5d:4e91:: with SMTP id e17mr4462754wru.7.1627560689971;
        Thu, 29 Jul 2021 05:11:29 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id a14sm3323850wrf.97.2021.07.29.05.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 05:11:29 -0700 (PDT)
Date:   Thu, 29 Jul 2021 14:11:27 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-kbuild@vger.kernel.org,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-block@vger.kernel.org, clang-built-linux@googlegroups.com,
        Keith Packard <keithpac@amazon.com>,
        linux-hardening@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 25/64] drm/mga/mga_ioc32: Use struct_group() for memcpy()
 region
Message-ID: <YQKa76A6XuFqgM03@phenom.ffwll.local>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kbuild@vger.kernel.org,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-block@vger.kernel.org, clang-built-linux@googlegroups.com,
        Keith Packard <keithpac@amazon.com>,
        linux-hardening@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-26-keescook@chromium.org>
 <YQDxmEYfppJ4wAmD@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQDxmEYfppJ4wAmD@kroah.com>
X-Operating-System: Linux phenom 5.10.0-7-amd64 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 07:56:40AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jul 27, 2021 at 01:58:16PM -0700, Kees Cook wrote:
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memcpy(), memmove(), and memset(), avoid
> > intentionally writing across neighboring fields.
> > 
> > Use struct_group() in struct drm32_mga_init around members chipset, sgram,
> > maccess, fb_cpp, front_offset, front_pitch, back_offset, back_pitch,
> > depth_cpp, depth_offset, depth_pitch, texture_offset, and texture_size,
> > so they can be referenced together. This will allow memcpy() and sizeof()
> > to more easily reason about sizes, improve readability, and avoid future
> > warnings about writing beyond the end of chipset.
> > 
> > "pahole" shows no size nor member offset changes to struct drm32_mga_init.
> > "objdump -d" shows no meaningful object code changes (i.e. only source
> > line number induced differences and optimizations).
> > 
> > Note that since this includes a UAPI header, struct_group() has been
> > explicitly redefined local to the header.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/gpu/drm/mga/mga_ioc32.c | 30 ++++++++++++++------------
> >  include/uapi/drm/mga_drm.h      | 37 ++++++++++++++++++++++++---------
> >  2 files changed, 44 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/mga/mga_ioc32.c b/drivers/gpu/drm/mga/mga_ioc32.c
> > index 4fd4de16cd32..fbd0329dbd4f 100644
> > --- a/drivers/gpu/drm/mga/mga_ioc32.c
> > +++ b/drivers/gpu/drm/mga/mga_ioc32.c
> > @@ -38,16 +38,21 @@
> >  typedef struct drm32_mga_init {
> >  	int func;
> >  	u32 sarea_priv_offset;
> > -	int chipset;
> > -	int sgram;
> > -	unsigned int maccess;
> > -	unsigned int fb_cpp;
> > -	unsigned int front_offset, front_pitch;
> > -	unsigned int back_offset, back_pitch;
> > -	unsigned int depth_cpp;
> > -	unsigned int depth_offset, depth_pitch;
> > -	unsigned int texture_offset[MGA_NR_TEX_HEAPS];
> > -	unsigned int texture_size[MGA_NR_TEX_HEAPS];
> > +	struct_group(always32bit,
> > +		int chipset;
> > +		int sgram;
> > +		unsigned int maccess;
> > +		unsigned int fb_cpp;
> > +		unsigned int front_offset;
> > +		unsigned int front_pitch;
> > +		unsigned int back_offset;
> > +		unsigned int back_pitch;
> > +		unsigned int depth_cpp;
> > +		unsigned int depth_offset;
> > +		unsigned int depth_pitch;
> > +		unsigned int texture_offset[MGA_NR_TEX_HEAPS];
> > +		unsigned int texture_size[MGA_NR_TEX_HEAPS];
> > +	);
> >  	u32 fb_offset;
> >  	u32 mmio_offset;
> >  	u32 status_offset;
> > @@ -67,9 +72,8 @@ static int compat_mga_init(struct file *file, unsigned int cmd,
> >  
> >  	init.func = init32.func;
> >  	init.sarea_priv_offset = init32.sarea_priv_offset;
> > -	memcpy(&init.chipset, &init32.chipset,
> > -		offsetof(drm_mga_init_t, fb_offset) -
> > -		offsetof(drm_mga_init_t, chipset));
> > +	memcpy(&init.always32bit, &init32.always32bit,
> > +	       sizeof(init32.always32bit));
> >  	init.fb_offset = init32.fb_offset;
> >  	init.mmio_offset = init32.mmio_offset;
> >  	init.status_offset = init32.status_offset;
> > diff --git a/include/uapi/drm/mga_drm.h b/include/uapi/drm/mga_drm.h
> > index 8c4337548ab5..61612e5ecab2 100644
> > --- a/include/uapi/drm/mga_drm.h
> > +++ b/include/uapi/drm/mga_drm.h
> > @@ -265,6 +265,16 @@ typedef struct _drm_mga_sarea {
> >  #define DRM_IOCTL_MGA_WAIT_FENCE    DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_WAIT_FENCE, __u32)
> >  #define DRM_IOCTL_MGA_DMA_BOOTSTRAP DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_DMA_BOOTSTRAP, drm_mga_dma_bootstrap_t)
> >  
> > +#define __struct_group(name, fields) \
> > +	union { \
> > +		struct { \
> > +			fields \
> > +		}; \
> > +		struct { \
> > +			fields \
> > +		} name; \
> > +	}
> > +
> >  typedef struct _drm_mga_warp_index {
> >  	int installed;
> >  	unsigned long phys_addr;
> > @@ -279,20 +289,25 @@ typedef struct drm_mga_init {
> >  
> >  	unsigned long sarea_priv_offset;
> >  
> > -	int chipset;
> > -	int sgram;
> > +	__struct_group(always32bit,
> > +		int chipset;
> > +		int sgram;
> >  
> > -	unsigned int maccess;
> > +		unsigned int maccess;
> >  
> > -	unsigned int fb_cpp;
> > -	unsigned int front_offset, front_pitch;
> > -	unsigned int back_offset, back_pitch;
> > +		unsigned int fb_cpp;
> > +		unsigned int front_offset;
> > +		unsigned int front_pitch;
> > +		unsigned int back_offset;
> > +		unsigned int back_pitch;
> >  
> > -	unsigned int depth_cpp;
> > -	unsigned int depth_offset, depth_pitch;
> > +		unsigned int depth_cpp;
> > +		unsigned int depth_offset;
> > +		unsigned int depth_pitch;
> >  
> > -	unsigned int texture_offset[MGA_NR_TEX_HEAPS];
> > -	unsigned int texture_size[MGA_NR_TEX_HEAPS];
> > +		unsigned int texture_offset[MGA_NR_TEX_HEAPS];
> > +		unsigned int texture_size[MGA_NR_TEX_HEAPS];
> > +	);
> >  
> >  	unsigned long fb_offset;
> >  	unsigned long mmio_offset;
> > @@ -302,6 +317,8 @@ typedef struct drm_mga_init {
> >  	unsigned long buffers_offset;
> >  } drm_mga_init_t;
> >  
> > +#undef __struct_group
> > +
> 
> Why can you use __struct_group in this uapi header, but not the
> networking one?

If there's others, maybe we can stuff the uapi __struct_group into
linux/types.h where all the other __ uapi types hang out?

Anyway mga is very dead, I don't anyone cares.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I'm assuming this goes in through a topic pull from you?

I'll leave the drm/amd one to figure out between you and Alex.
-Daniel

> 
> thanks,
> 
> greg k-h

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
