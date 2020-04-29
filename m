Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47721BE2CF
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgD2PeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:34:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58440 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726781AbgD2PeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588174439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KKID24VeS04+SIozIuc8RuLZZFKJ5rduUKOoVcekO0A=;
        b=DTfHQiWKRtAyE2lEbFaH9KNJI8+pp0mk3IxAYfEd4GBccOey0ttX3dmGPX8qovLK4F6thr
        WInLciA3zAPOq0PVyoiRsS4wSkuw1uy1r+EMOhupevSmJRJ3vXhWFPr6y6/UbXAymtzI+m
        O7Koyy2uRhx4BSrpunK6FkRn+Ryng9U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-7hxvdgFRPxSYLTs3SfcR1g-1; Wed, 29 Apr 2020 11:33:56 -0400
X-MC-Unique: 7hxvdgFRPxSYLTs3SfcR1g-1
Received: by mail-wm1-f72.google.com with SMTP id w2so1380651wmc.3
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 08:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KKID24VeS04+SIozIuc8RuLZZFKJ5rduUKOoVcekO0A=;
        b=c7m1R14ovzklytsS9RhQXrW2fKBbcgTxuIzzlqttu3qOtxr5VReHXmTAvtuuBdKjyU
         ZfhT9/Hi3ysAZd4m4mSGXIdN8gDU1j8SDY/xdJcefju7q1PTxqELp2QduCxEPI8wghcJ
         yXRU2FbkLqqigyO747lGLezet8VARdrrnLEKdtF1efL5QQHeBgf8mKKg6BWtokjmZ2ZC
         w+6JZ+5HDxDFN/UpW1kwsgyHVe5lsCVC20J6N2YqlAhkwAJ59MMYc1g8o7f7ogtPKZno
         /Lw/ydREY23wfRmaqLJtWgryPJzkkp7jEQdrgJsHQ8vpd60grPhvK7ZR9qH4/bl8bpy2
         j5RA==
X-Gm-Message-State: AGi0PuZFssN0gggvKlCp53vrWjAfLKMCU3TNQnk/kuriqQ+MM5vODxRv
        1ib4LDtUMLl7MF+Egej1ZsenJWGmDcCCedztYR5RaEfGJdypUXBQOSRaUCUhPxmbKkeOaRkozFQ
        tL0f8y7HwxYtiJgkp
X-Received: by 2002:adf:fecd:: with SMTP id q13mr42286151wrs.12.1588174435306;
        Wed, 29 Apr 2020 08:33:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypJv7rM5XZdPpYa0XbuMbltzbpsnlCYEladdinC4riKF/z7q+xHJZ0Lq2AB1h1HtNI76PDhJ5w==
X-Received: by 2002:adf:fecd:: with SMTP id q13mr42286134wrs.12.1588174435068;
        Wed, 29 Apr 2020 08:33:55 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id u7sm8832675wmg.41.2020.04.29.08.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 08:33:54 -0700 (PDT)
Date:   Wed, 29 Apr 2020 11:33:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jason Wang <jasowang@redhat.com>, Tiwei Bie <tiwei.bie@intel.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: fix default for vhost_iotlb
Message-ID: <20200429113232-mutt-send-email-mst@kernel.org>
References: <20200429142317.1847441-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429142317.1847441-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 04:23:04PM +0200, Arnd Bergmann wrote:
> During randconfig build testing, I ran into a configuration that has
> CONFIG_VHOST=m, CONFIG_VHOST_IOTLB=m and CONFIG_VHOST_RING=y, which
> makes the iotlb implementation left out from vhost_ring, and in turn
> leads to a link failure of the vdpa_sim module:
> 
> ERROR: modpost: "vringh_set_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_init_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_iov_push_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_iov_pull_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_complete_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> ERROR: modpost: "vringh_getdesc_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
> 
> Work around it by setting the default for VHOST_IOTLB to avoid this
> configuration.
> 
> Fixes: e6faeaa12841 ("vhost: drop vring dependency on iotlb")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I fixed this a while ago locally but never got around to sending the
> fix. If the problem has been addressed differently in the meantime,
> please ignore this one.


So I ended up not sending e6faeaa12841 upstream because of this problem.
But hey, that's a nice idea!
I'll queue something like this for the next release.

> ---
>  drivers/vhost/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 2c75d164b827..ee5f85761024 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config VHOST_IOTLB
>  	tristate
> +	default y if VHOST=m && VHOST_RING=y
>  	help
>  	  Generic IOTLB implementation for vhost and vringh.
>  	  This option is selected by any driver which needs to support
> -- 
> 2.26.0

