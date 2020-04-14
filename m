Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE3B1A7331
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 07:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405653AbgDNFyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 01:54:05 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36697 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729230AbgDNFyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 01:54:02 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 491ZRm0Nd7z9sSt;
        Tue, 14 Apr 2020 15:53:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1586843638;
        bh=5CTXgwD6QRZ19R0dMPZNZMlbhZJTKR1ERFLzk/tOayw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rGDOlIHN9VhZPHk0xqQQTGt0JIeqe7ZuCMPimjxIqjtZ0UA6hVuTVpMDgMDbKLF3t
         Byzd1hqCI0OgLrCMXpU4cdONHOELBWF8A3sEG8Jaj9ggLQvb/trXrJEk3tAcOtLmBV
         nYbiOhJSSCgm4n6u+mAo7gMrEfF0Cf5y9d3HHUacZZzfn2OuszK9t8QRMpWr7emaXL
         mTiNgU4ldQAShaI7GU8oArrlpkmY/tjdxRai1o/bHIKYxP/M9N2nZIEzqItnl5wczs
         XEjj0FSxQ7L+v553P84EnjCs+cIm/VjAbjOlpBmlyvJnzHCM02OjI7D75vStEBNhD5
         Jk1fzaFhKL7pw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        jasowang@redhat.com
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] vhost: do not enable VHOST_MENU by default
In-Reply-To: <20200414024438.19103-1-jasowang@redhat.com>
References: <20200414024438.19103-1-jasowang@redhat.com>
Date:   Tue, 14 Apr 2020 15:54:05 +1000
Message-ID: <87h7xmk3ya.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
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
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/mips/configs/malta_kvm_defconfig  |  1 +
>  arch/powerpc/configs/powernv_defconfig |  1 +
>  arch/powerpc/configs/ppc64_defconfig   |  1 +
>  arch/powerpc/configs/pseries_defconfig |  1 +

Fine by me.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers

>  arch/s390/configs/debug_defconfig      |  1 +
>  arch/s390/configs/defconfig            |  1 +
>  drivers/vhost/Kconfig                  | 18 +++++-------------
>  7 files changed, 11 insertions(+), 13 deletions(-)
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
> index e79cbbdfea45..14d296dc18cd 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -12,23 +12,18 @@ config VHOST_RING
>  	  This option is selected by any driver which needs to access
>  	  the host side of a virtio ring.
>  
> -config VHOST
> -	tristate
> +menuconfig VHOST
> +	tristate "Vhost Devices"
>  	select VHOST_IOTLB
>  	help
> -	  This option is selected by any driver which needs to access
> -	  the core of vhost.
> -
> -menuconfig VHOST_MENU
> -	bool "VHOST drivers"
> -	default y
> +	  Enable option to support host kernel or hardware accelerator
> +	  for virtio device.
>  
> -if VHOST_MENU
> +if VHOST
>  
>  config VHOST_NET
>  	tristate "Host kernel accelerator for virtio net"
>  	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> -	select VHOST
>  	---help---
>  	  This kernel module can be loaded in host kernel to accelerate
>  	  guest networking with virtio_net. Not to be confused with virtio_net
> @@ -40,7 +35,6 @@ config VHOST_NET
>  config VHOST_SCSI
>  	tristate "VHOST_SCSI TCM fabric driver"
>  	depends on TARGET_CORE && EVENTFD
> -	select VHOST
>  	default n
>  	---help---
>  	Say M here to enable the vhost_scsi TCM fabric module
> @@ -49,7 +43,6 @@ config VHOST_SCSI
>  config VHOST_VSOCK
>  	tristate "vhost virtio-vsock driver"
>  	depends on VSOCKETS && EVENTFD
> -	select VHOST
>  	select VIRTIO_VSOCKETS_COMMON
>  	default n
>  	---help---
> @@ -63,7 +56,6 @@ config VHOST_VSOCK
>  config VHOST_VDPA
>  	tristate "Vhost driver for vDPA-based backend"
>  	depends on EVENTFD
> -	select VHOST
>  	depends on VDPA
>  	help
>  	  This kernel module can be loaded in host kernel to accelerate
> -- 
> 2.20.1
