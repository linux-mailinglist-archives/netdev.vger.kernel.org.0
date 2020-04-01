Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06AA219AF65
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732304AbgDAQIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 12:08:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35293 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727620AbgDAQIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 12:08:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585757290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hOVDtyF1AE9D3PmM9Cg9VpMJ2l3FcGqxQ8lNxLr5dIs=;
        b=SxJjXejhlEBLDSX9/KQ3PoWI4jiY7Qbtic8xN92A6yQDW/5QL9EbKZ5Gl2tYKqi8n0wjyV
        vqeTU65B+cIV9dchRlxJ7gQBOqFHNAtRX6H2mWarhu5AnDDdsLaSbtaatG524sgXrD/8KR
        UaNftzzwDuVW5BvgZRyQeqqw6aZsvRc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-B8-AnTu2MIOjwp-WRbJrNw-1; Wed, 01 Apr 2020 12:08:08 -0400
X-MC-Unique: B8-AnTu2MIOjwp-WRbJrNw-1
Received: by mail-wr1-f72.google.com with SMTP id h14so54680wrr.12
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 09:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hOVDtyF1AE9D3PmM9Cg9VpMJ2l3FcGqxQ8lNxLr5dIs=;
        b=umvXCE5htL4a2Pnd4A+4PA8o2DXj3r6zEmUKnBbTPFRJrlgbz5auDwS8UKPgfrD43U
         nt5PAOjyia6g87VdYsuk8ofmu9Qj/KTZ3nihcRlhXnpVBs43DxhA//umnwy/4xCRNbaQ
         xZEi4MwdZH2lC0Xxg40egzbDu4uBwU6GCyMPR1VgtvWyCK+CNgfbHIRzFs6UtU/Whs8n
         s/7MDb1j99wfdEjynMJ+qIYvgnVeqnC/+H7TlLkTcdV4cAaQo055Vhp5SMiG551yvRNi
         AcCL+F7CS0aez8Irdr6ZlouGL34DhfG5rxmSgVmC1jAXUjL1enhJsmoRVRgfMzO9MmRO
         V4Lw==
X-Gm-Message-State: ANhLgQ1QChfNOu+zsfiJoXGHhYDun89phAdPgPLOWRe/fwZRKbfdJPec
        YGeFWd1kUd5UTzA+qpKmy9B4bgPsqvGtqH5KXPWUW+6l2Da40Gfg3oEj2koQG911/WULFOn+Giv
        7BRlpzcJ++s68rekS
X-Received: by 2002:a5d:5704:: with SMTP id a4mr27652978wrv.95.1585757287402;
        Wed, 01 Apr 2020 09:08:07 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu/0IpuTVbC9txesB4+4J8VJA6MAuurHQYjHbAmRAHqQl2A8Juskzx4t/Kit00vNhGBgfiZ4Q==
X-Received: by 2002:a5d:5704:: with SMTP id a4mr27652949wrv.95.1585757287093;
        Wed, 01 Apr 2020 09:08:07 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id n6sm3579451wrp.30.2020.04.01.09.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 09:08:06 -0700 (PDT)
Date:   Wed, 1 Apr 2020 12:08:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, zhangweining@ruijie.com.cn
Subject: Re: [PATCH V9 1/9] vhost: refine vhost and vringh kconfig
Message-ID: <20200401120643-mutt-send-email-mst@kernel.org>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-2-jasowang@redhat.com>
 <20200401092004-mutt-send-email-mst@kernel.org>
 <6b4d169a-9962-6014-5423-1507059343e9@redhat.com>
 <20200401100954-mutt-send-email-mst@kernel.org>
 <3dd3b7e7-e3d9-dba4-00fc-868081f95ab7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dd3b7e7-e3d9-dba4-00fc-868081f95ab7@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 10:29:32PM +0800, Jason Wang wrote:
> >From 9b3a5d23b8bf6b0a11e65e688335d782f8e6aa5c Mon Sep 17 00:00:00 2001
> From: Jason Wang <jasowang@redhat.com>
> Date: Wed, 1 Apr 2020 22:17:27 +0800
> Subject: [PATCH] vhost: let CONFIG_VHOST to be selected by drivers
> 
> The defconfig on some archs enable vhost_net or vhost_vsock by
> default. So instead of adding CONFIG_VHOST=m to all of those files,
> simply letting CONFIG_VHOST to be selected by all of the vhost
> drivers. This fixes the build on the archs with CONFIG_VHOST_NET=m in
> their defconfig.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/Kconfig | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 2523a1d4290a..362b832f5338 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -11,19 +11,23 @@ config VHOST_RING
>  	  This option is selected by any driver which needs to access
>  	  the host side of a virtio ring.
>  
> -menuconfig VHOST
> -	tristate "Host kernel accelerator for virtio (VHOST)"
> -	depends on EVENTFD
> +config VHOST
> +	tristate
>  	select VHOST_IOTLB
>  	help
>  	  This option is selected by any driver which needs to access
>  	  the core of vhost.
>  
> -if VHOST
> +menuconfig VHOST_MENU
> +	bool "VHOST drivers"
> +	default y
> +
> +if VHOST_MENU
>  
>  config VHOST_NET
>  	tristate "Host kernel accelerator for virtio net"
>  	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> +	select VHOST
>  	---help---
>  	  This kernel module can be loaded in host kernel to accelerate
>  	  guest networking with virtio_net. Not to be confused with virtio_net
> @@ -35,6 +39,7 @@ config VHOST_NET
>  config VHOST_SCSI
>  	tristate "VHOST_SCSI TCM fabric driver"
>  	depends on TARGET_CORE && EVENTFD
> +	select VHOST
>  	default n
>  	---help---
>  	Say M here to enable the vhost_scsi TCM fabric module
> @@ -43,6 +48,7 @@ config VHOST_SCSI
>  config VHOST_VSOCK
>  	tristate "vhost virtio-vsock driver"
>  	depends on VSOCKETS && EVENTFD
> +	select VHOST
>  	select VIRTIO_VSOCKETS_COMMON
>  	default n
>  	---help---
> @@ -56,6 +62,7 @@ config VHOST_VSOCK
>  config VHOST_VDPA
>  	tristate "Vhost driver for vDPA-based backend"
>  	depends on EVENTFD
> +	select VHOST
>  	select VDPA
>  	help
>  	  This kernel module can be loaded in host kernel to accelerate

OK so I squashed this into the original buggy patch.
Could you please play with vhost branch of my tree on various
arches? If it looks ok to you let me know I'll push
this to next.


-- 
MST

