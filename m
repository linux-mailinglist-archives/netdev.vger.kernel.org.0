Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F7E16A6EC
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbgBXNII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:08:08 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727299AbgBXNIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:08:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582549687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8hYIHZTnTP03p6Yp4LlShbTvxf4UyOXsFmmyMPgeaYI=;
        b=ggAX4k2X/nrSgbEhTp+FSzWVvJrMksYG+aQw/fFewmeopr8t5GVMxVo8Ko0zK+ubk8SGlF
        slcxuKjlsB4HV3HQwEEAPxAoRubW2aGHP3ny957SSRsMQ4nXgMxVuNFfuWmPsz8ZWuE8fb
        Xrsh5GL39M8Fa5iDWYLTVJ0mm+w/AAE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-1KFA4pPFOt-nSzxZ1v6H2w-1; Mon, 24 Feb 2020 08:08:01 -0500
X-MC-Unique: 1KFA4pPFOt-nSzxZ1v6H2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A47AB107ACCA;
        Mon, 24 Feb 2020 13:07:55 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF3FB909E9;
        Mon, 24 Feb 2020 13:07:44 +0000 (UTC)
Subject: Re: [RFC PATCH 01/11] vfio: Remove Calxeda XGMAC reset driver
To:     Rob Herring <robh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218171321.30990-2-robh@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <23fda074-149e-9c77-5eee-4d6b591a6ebf@redhat.com>
Date:   Mon, 24 Feb 2020 14:07:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200218171321.30990-2-robh@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob, Alex,

On 2/18/20 6:13 PM, Rob Herring wrote:
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Do not apply yet.
> 
>  drivers/vfio/platform/reset/Kconfig           |  8 --
>  drivers/vfio/platform/reset/Makefile          |  2 -
>  .../reset/vfio_platform_calxedaxgmac.c        | 74 -------------------
>  3 files changed, 84 deletions(-)
>  delete mode 100644 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> 
> diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
> index 1edbe9ee7356..3668d1d92909 100644
> --- a/drivers/vfio/platform/reset/Kconfig
> +++ b/drivers/vfio/platform/reset/Kconfig
> @@ -1,12 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -config VFIO_PLATFORM_CALXEDAXGMAC_RESET
> -	tristate "VFIO support for calxeda xgmac reset"
> -	depends on VFIO_PLATFORM
> -	help
> -	  Enables the VFIO platform driver to handle reset for Calxeda xgmac
> -
> -	  If you don't know what to do here, say N.
> -
>  config VFIO_PLATFORM_AMDXGBE_RESET
>  	tristate "VFIO support for AMD XGBE reset"
>  	depends on VFIO_PLATFORM
> diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
> index 7294c5ea122e..be7960ce5dbc 100644
> --- a/drivers/vfio/platform/reset/Makefile
> +++ b/drivers/vfio/platform/reset/Makefile
> @@ -1,7 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> -vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
>  vfio-platform-amdxgbe-y := vfio_platform_amdxgbe.o
> 
> -obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
>  obj-$(CONFIG_VFIO_PLATFORM_AMDXGBE_RESET) += vfio-platform-amdxgbe.o
>  obj-$(CONFIG_VFIO_PLATFORM_BCMFLEXRM_RESET) += vfio_platform_bcmflexrm.o
> diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> deleted file mode 100644
> index 09a9453b75c5..000000000000
> --- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> +++ /dev/null
> @@ -1,74 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-only
> -/*
> - * VFIO platform driver specialized for Calxeda xgmac reset
> - * reset code is inherited from calxeda xgmac native driver
> - *
> - * Copyright 2010-2011 Calxeda, Inc.
> - * Copyright (c) 2015 Linaro Ltd.
> - *              www.linaro.org
> - */
> -
> -#include <linux/module.h>
> -#include <linux/kernel.h>
> -#include <linux/init.h>
> -#include <linux/io.h>
> -
> -#include "../vfio_platform_private.h"
> -
> -#define DRIVER_VERSION  "0.1"
> -#define DRIVER_AUTHOR   "Eric Auger <eric.auger@linaro.org>"
> -#define DRIVER_DESC     "Reset support for Calxeda xgmac vfio platform device"
> -
> -/* XGMAC Register definitions */
> -#define XGMAC_CONTROL           0x00000000      /* MAC Configuration */
> -
> -/* DMA Control and Status Registers */
> -#define XGMAC_DMA_CONTROL       0x00000f18      /* Ctrl (Operational Mode) */
> -#define XGMAC_DMA_INTR_ENA      0x00000f1c      /* Interrupt Enable */
> -
> -/* DMA Control registe defines */
> -#define DMA_CONTROL_ST          0x00002000      /* Start/Stop Transmission */
> -#define DMA_CONTROL_SR          0x00000002      /* Start/Stop Receive */
> -
> -/* Common MAC defines */
> -#define MAC_ENABLE_TX           0x00000008      /* Transmitter Enable */
> -#define MAC_ENABLE_RX           0x00000004      /* Receiver Enable */
> -
> -static inline void xgmac_mac_disable(void __iomem *ioaddr)
> -{
> -	u32 value = readl(ioaddr + XGMAC_DMA_CONTROL);
> -
> -	value &= ~(DMA_CONTROL_ST | DMA_CONTROL_SR);
> -	writel(value, ioaddr + XGMAC_DMA_CONTROL);
> -
> -	value = readl(ioaddr + XGMAC_CONTROL);
> -	value &= ~(MAC_ENABLE_TX | MAC_ENABLE_RX);
> -	writel(value, ioaddr + XGMAC_CONTROL);
> -}
> -
> -static int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
> -{
> -	struct vfio_platform_region *reg = &vdev->regions[0];
> -
> -	if (!reg->ioaddr) {
> -		reg->ioaddr =
> -			ioremap(reg->addr, reg->size);
> -		if (!reg->ioaddr)
> -			return -ENOMEM;
> -	}
> -
> -	/* disable IRQ */
> -	writel(0, reg->ioaddr + XGMAC_DMA_INTR_ENA);
> -
> -	/* Disable the MAC core */
> -	xgmac_mac_disable(reg->ioaddr);
> -
> -	return 0;
> -}
> -
> -module_vfio_reset_handler("calxeda,hb-xgmac", vfio_platform_calxedaxgmac_reset);
> -
> -MODULE_VERSION(DRIVER_VERSION);
> -MODULE_LICENSE("GPL v2");
> -MODULE_AUTHOR(DRIVER_AUTHOR);
> -MODULE_DESCRIPTION(DRIVER_DESC);
> --
> 2.20.1
> 
I do not have access to this HW anymore and I use Seattle to test
vfio-platform. So

Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

