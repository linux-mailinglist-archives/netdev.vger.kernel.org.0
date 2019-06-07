Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC2385D1
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 09:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfFGH5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 03:57:33 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33784 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbfFGH5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 03:57:32 -0400
Received: by mail-ed1-f66.google.com with SMTP id h9so1739984edr.0
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 00:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Y0dqNgN5GRlPumwnSwim+P7xV+jz6U0uadHjVytHrk=;
        b=KW+UbysjArNVACv4q6+549r7+cTv3EkG+0hIgp5Gzs8ersC7PVJ/arg0EbqcKW/BDT
         7m/td0oX1nSkgEGBxV+/rFF94cYaaujJuBaZbnkb6j43aX9EoDSuUh2jbUn90a72Q1m6
         wWSpptOZ5QJhMjkYz1VNG/I1tEoevoc3dgNZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=1Y0dqNgN5GRlPumwnSwim+P7xV+jz6U0uadHjVytHrk=;
        b=bRYcmj5dN9/UnUO6ZhdJFKdKAcUWRwgvQPdNhJmWic5dFzyReyyniPbw6gg5lAgx4r
         TqpqbSNkw08emakejTJpEL0/2LRdkckTqpKJqiaWXdrX+xb0vE+nXlJe4iIWln1Y8tVf
         C3fGnEZKb1n9tmRmOrTKEjAi1S0dna320j/JCoweukjGTC30HGkWN2zuEhwsu2oLdytF
         SrVi7OgpmerDDQe+6YquGDGznsoLuZh/OTU63DSgPF6tCIvAHWWJLghhJPhY/Ygwv1n4
         XO4oWK2vGiF+vteGc6df7unTTf2Rxnxd1IjZba5tfL94Zih3Y7on7I9tt+jSyQJcp53s
         fx5Q==
X-Gm-Message-State: APjAAAWB8cdgBJ/M/5EjMHVcT8NKhUha3YE72hu9ih1ey+rZi8fd1jhz
        TxgXbafRrlpOvny/4lQ6QCXm2w==
X-Google-Smtp-Source: APXvYqxb9k77uDmPH+x6SZW7m5DzVGO6PSl0oSp7JXNVVPERM605KEjklDJiu0Eyo4Ib14+dHcCJGA==
X-Received: by 2002:a17:906:4f8f:: with SMTP id o15mr45250693eju.129.1559894251343;
        Fri, 07 Jun 2019 00:57:31 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id f3sm241948ejc.15.2019.06.07.00.57.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 00:57:30 -0700 (PDT)
Date:   Fri, 7 Jun 2019 09:57:28 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     marex@denx.de, stefan@agner.ch, airlied@linux.ie, daniel@ffwll.ch,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        b.zolnierkie@samsung.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, a.hajda@samsung.com, mchehab@kernel.org,
        p.zabel@pengutronix.de, hkallweit1@gmail.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers: (video|gpu): fix warning same module names
Message-ID: <20190607075728.GE21222@phenom.ffwll.local>
Mail-Followup-To: Anders Roxell <anders.roxell@linaro.org>, marex@denx.de,
        stefan@agner.ch, airlied@linux.ie, shawnguo@kernel.org,
        s.hauer@pengutronix.de, b.zolnierkie@samsung.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, a.hajda@samsung.com,
        mchehab@kernel.org, p.zabel@pengutronix.de, hkallweit1@gmail.com,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20190606094712.23715-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606094712.23715-1-anders.roxell@linaro.org>
X-Operating-System: Linux phenom 4.14.0-3-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 11:47:12AM +0200, Anders Roxell wrote:
> When building with CONFIG_DRM_MXSFB and CONFIG_FB_MXS enabled as
> loadable modules, we see the following warning:
> 
> warning: same module names found:
>   drivers/video/fbdev/mxsfb.ko
>   drivers/gpu/drm/mxsfb/mxsfb.ko
> 
> Rework so the names matches the config fragment.
> 
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I'm assuming Bart will pick this one up for fbdev.
-Daniel

> ---
>  drivers/gpu/drm/mxsfb/Makefile | 4 ++--
>  drivers/video/fbdev/Makefile   | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/mxsfb/Makefile b/drivers/gpu/drm/mxsfb/Makefile
> index ff6e358088fa..5d49d7548e66 100644
> --- a/drivers/gpu/drm/mxsfb/Makefile
> +++ b/drivers/gpu/drm/mxsfb/Makefile
> @@ -1,3 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -mxsfb-y := mxsfb_drv.o mxsfb_crtc.o mxsfb_out.o
> -obj-$(CONFIG_DRM_MXSFB)	+= mxsfb.o
> +drm-mxsfb-y := mxsfb_drv.o mxsfb_crtc.o mxsfb_out.o
> +obj-$(CONFIG_DRM_MXSFB)	+= drm-mxsfb.o
> diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
> index 655f2537cac1..7ee967525af2 100644
> --- a/drivers/video/fbdev/Makefile
> +++ b/drivers/video/fbdev/Makefile
> @@ -131,7 +131,8 @@ obj-$(CONFIG_FB_VGA16)            += vga16fb.o
>  obj-$(CONFIG_FB_OF)               += offb.o
>  obj-$(CONFIG_FB_MX3)		  += mx3fb.o
>  obj-$(CONFIG_FB_DA8XX)		  += da8xx-fb.o
> -obj-$(CONFIG_FB_MXS)		  += mxsfb.o
> +obj-$(CONFIG_FB_MXS)		  += fb-mxs.o
> +fb-mxs-objs			  := mxsfb.o
>  obj-$(CONFIG_FB_SSD1307)	  += ssd1307fb.o
>  obj-$(CONFIG_FB_SIMPLE)           += simplefb.o
>  
> -- 
> 2.20.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
