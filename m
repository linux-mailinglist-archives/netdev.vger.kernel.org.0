Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DBE1AD2FA
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 00:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgDPWz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 18:55:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58010 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728305AbgDPWzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 18:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587077720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9lsbeDYugkp9ahth1JLAh0S0ZCsR0PhUH/EAQX/EDRo=;
        b=YXp1wDWMlS95lNTvHr/63zvYqLyR0Ei21irmqm9e/eJyniatCswli+7CfZeQZRlxmyEGTt
        XnISVHn4P8gh35Ie5MMJRNCnV1XdyUu2LIlwsUzJeTWUpI6W0hIc9Y87cDeea2yOdd8sgA
        50aAreKZNJxB09TU4I1H2epj06Hn+4k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-A5jKCKabOp6X3YpD-9uXIQ-1; Thu, 16 Apr 2020 18:55:16 -0400
X-MC-Unique: A5jKCKabOp6X3YpD-9uXIQ-1
Received: by mail-wm1-f71.google.com with SMTP id o26so111833wmh.1
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 15:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9lsbeDYugkp9ahth1JLAh0S0ZCsR0PhUH/EAQX/EDRo=;
        b=mW4YunDnXaS0pPg8xdPkbQ1NpFX3OSc1OPoACt+O1TWU0TUQp4FxC7fzLUfF592sfT
         FZ9VbdgMvrsMCvp0+ceHQPG89I1Qvhgz8RJUVgjU6a2GaenNs13FyUYKMAMevQcrA//5
         2Upqexcd6277prEDB8SLeTg4GQ9Q3xZtDbsVskDAhScsbZaES026wYdbS7dyPkxEDgSj
         bYBmH24GiOhKKr2ZedfWyuFpvmnxvU7Elhrwn4NjAp5VxbHmLv+anTX5ufryDI7YoJ7c
         E6U+HP/L3280DhNexUL0JHX2uiIThzEVf004q4JEBa0FMjK8Kh/5DYhCgRQuyM2JvUbE
         g2AQ==
X-Gm-Message-State: AGi0PuZIhzuHUFUzC4+Oeq3H7wUGVX+5AUCEwoa0b33/fpmFnyzqFQnT
        jzhij/l75ghSWld09Y+mcbYWVSbWRgxKevm0YJQ2rJv/F3TcwR9xzYGW7wyn5Seb5WyPuXXH+iE
        6+DIWmAupYTrwXpVh
X-Received: by 2002:adf:9d83:: with SMTP id p3mr610163wre.142.1587077715594;
        Thu, 16 Apr 2020 15:55:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypKqqEBtScGXpogtjB81/FXXZd5Rlg+Ab1dKWQPXOFKpcRMvC/kGOOlvzZHP/qvFjygZmEu/KA==
X-Received: by 2002:adf:9d83:: with SMTP id p3mr610136wre.142.1587077715334;
        Thu, 16 Apr 2020 15:55:15 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id 138sm5885051wmb.14.2020.04.16.15.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 15:55:14 -0700 (PDT)
Date:   Thu, 16 Apr 2020 18:55:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        tsbogend@alpha.franken.de, benh@kernel.crashing.org,
        paulus@samba.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH V2] vhost: do not enable VHOST_MENU by default
Message-ID: <20200416185426-mutt-send-email-mst@kernel.org>
References: <20200415024356.23751-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415024356.23751-1-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 10:43:56AM +0800, Jason Wang wrote:
> We try to keep the defconfig untouched after decoupling CONFIG_VHOST
> out of CONFIG_VIRTUALIZATION in commit 20c384f1ea1a
> ("vhost: refine vhost and vringh kconfig") by enabling VHOST_MENU by
> default. Then the defconfigs can keep enabling CONFIG_VHOST_NET
> without the caring of CONFIG_VHOST.
> 
> But this will leave a "CONFIG_VHOST_MENU=y" in all defconfigs and even
> for the ones that doesn't want vhost. So it actually shifts the
> burdens to the maintainers of all other to add "CONFIG_VHOST_MENU is
> not set". So this patch tries to enable CONFIG_VHOST explicitly in
> defconfigs that enables CONFIG_VHOST_NET and CONFIG_VHOST_VSOCK.
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com> (s390)
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I rebased this on top of OABI fix since that
seems more orgent to fix.
Pushed to my vhost branch pls take a look and
if possible test.
Thanks!

> ---
> Change since V1:
> - depends on EVENTFD for VHOST
> ---
>  arch/mips/configs/malta_kvm_defconfig  |  1 +
>  arch/powerpc/configs/powernv_defconfig |  1 +
>  arch/powerpc/configs/ppc64_defconfig   |  1 +
>  arch/powerpc/configs/pseries_defconfig |  1 +
>  arch/s390/configs/debug_defconfig      |  1 +
>  arch/s390/configs/defconfig            |  1 +
>  drivers/vhost/Kconfig                  | 26 +++++++++-----------------
>  7 files changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/mips/configs/malta_kvm_defconfig b/arch/mips/configs/malta_kvm_defconfig
> index 8ef612552a19..06f0c7a0ca87 100644
> --- a/arch/mips/configs/malta_kvm_defconfig
> +++ b/arch/mips/configs/malta_kvm_defconfig
> @@ -18,6 +18,7 @@ CONFIG_PCI=y
>  CONFIG_VIRTUALIZATION=y
>  CONFIG_KVM=m
>  CONFIG_KVM_MIPS_DEBUG_COP0_COUNTERS=y
> +CONFIG_VHOST=m
>  CONFIG_VHOST_NET=m
>  CONFIG_MODULES=y
>  CONFIG_MODULE_UNLOAD=y
> diff --git a/arch/powerpc/configs/powernv_defconfig b/arch/powerpc/configs/powernv_defconfig
> index 71749377d164..404245b4594d 100644
> --- a/arch/powerpc/configs/powernv_defconfig
> +++ b/arch/powerpc/configs/powernv_defconfig
> @@ -346,5 +346,6 @@ CONFIG_CRYPTO_DEV_VMX=y
>  CONFIG_VIRTUALIZATION=y
>  CONFIG_KVM_BOOK3S_64=m
>  CONFIG_KVM_BOOK3S_64_HV=m
> +CONFIG_VHOST=m
>  CONFIG_VHOST_NET=m
>  CONFIG_PRINTK_TIME=y
> diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
> index 7e68cb222c7b..4599fc7be285 100644
> --- a/arch/powerpc/configs/ppc64_defconfig
> +++ b/arch/powerpc/configs/ppc64_defconfig
> @@ -61,6 +61,7 @@ CONFIG_ELECTRA_CF=y
>  CONFIG_VIRTUALIZATION=y
>  CONFIG_KVM_BOOK3S_64=m
>  CONFIG_KVM_BOOK3S_64_HV=m
> +CONFIG_VHOST=m
>  CONFIG_VHOST_NET=m
>  CONFIG_OPROFILE=m
>  CONFIG_KPROBES=y
> diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
> index 6b68109e248f..4cad3901b5de 100644
> --- a/arch/powerpc/configs/pseries_defconfig
> +++ b/arch/powerpc/configs/pseries_defconfig
> @@ -321,5 +321,6 @@ CONFIG_CRYPTO_DEV_VMX=y
>  CONFIG_VIRTUALIZATION=y
>  CONFIG_KVM_BOOK3S_64=m
>  CONFIG_KVM_BOOK3S_64_HV=m
> +CONFIG_VHOST=m
>  CONFIG_VHOST_NET=m
>  CONFIG_PRINTK_TIME=y
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index 0c86ba19fa2b..6ec6e69630d1 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -57,6 +57,7 @@ CONFIG_PROTECTED_VIRTUALIZATION_GUEST=y
>  CONFIG_CMM=m
>  CONFIG_APPLDATA_BASE=y
>  CONFIG_KVM=m
> +CONFIG_VHOST=m
>  CONFIG_VHOST_NET=m
>  CONFIG_VHOST_VSOCK=m
>  CONFIG_OPROFILE=m
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index 6b27d861a9a3..d1b3bf83d687 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -57,6 +57,7 @@ CONFIG_PROTECTED_VIRTUALIZATION_GUEST=y
>  CONFIG_CMM=m
>  CONFIG_APPLDATA_BASE=y
>  CONFIG_KVM=m
> +CONFIG_VHOST=m
>  CONFIG_VHOST_NET=m
>  CONFIG_VHOST_VSOCK=m
>  CONFIG_OPROFILE=m
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index e79cbbdfea45..29f171a53d8a 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -12,23 +12,19 @@ config VHOST_RING
>  	  This option is selected by any driver which needs to access
>  	  the host side of a virtio ring.
>  
> -config VHOST
> -	tristate
> +menuconfig VHOST
> +	tristate "Vhost Devices"
> +	depends on EVENTFD
>  	select VHOST_IOTLB
>  	help
> -	  This option is selected by any driver which needs to access
> -	  the core of vhost.
> +	  Enable option to support host kernel or hardware accelerator
> +	  for virtio device.
>  
> -menuconfig VHOST_MENU
> -	bool "VHOST drivers"
> -	default y
> -
> -if VHOST_MENU
> +if VHOST
>  
>  config VHOST_NET
>  	tristate "Host kernel accelerator for virtio net"
> -	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> -	select VHOST
> +	depends on NET && (TUN || !TUN) && (TAP || !TAP)
>  	---help---
>  	  This kernel module can be loaded in host kernel to accelerate
>  	  guest networking with virtio_net. Not to be confused with virtio_net
> @@ -39,8 +35,7 @@ config VHOST_NET
>  
>  config VHOST_SCSI
>  	tristate "VHOST_SCSI TCM fabric driver"
> -	depends on TARGET_CORE && EVENTFD
> -	select VHOST
> +	depends on TARGET_CORE
>  	default n
>  	---help---
>  	Say M here to enable the vhost_scsi TCM fabric module
> @@ -48,8 +43,7 @@ config VHOST_SCSI
>  
>  config VHOST_VSOCK
>  	tristate "vhost virtio-vsock driver"
> -	depends on VSOCKETS && EVENTFD
> -	select VHOST
> +	depends on VSOCKETS
>  	select VIRTIO_VSOCKETS_COMMON
>  	default n
>  	---help---
> @@ -62,8 +56,6 @@ config VHOST_VSOCK
>  
>  config VHOST_VDPA
>  	tristate "Vhost driver for vDPA-based backend"
> -	depends on EVENTFD
> -	select VHOST
>  	depends on VDPA
>  	help
>  	  This kernel module can be loaded in host kernel to accelerate
> -- 
> 2.20.1

