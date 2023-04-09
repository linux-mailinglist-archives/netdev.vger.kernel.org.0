Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB566DC0D8
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 19:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDIRRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 13:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjDIRRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 13:17:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83963581
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6407B60C16
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 17:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C958C433D2;
        Sun,  9 Apr 2023 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681060644;
        bh=vt0tQJQtx+K57B8hj4GZObrXeekqz92a4/nvk62p1Mo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j74q23mzibnwoS+KJohKyXE1pd+ecOLCYpxVPI/2w8mRXZ1juP1ZBPGMs1sduMzBn
         AOALi/KL9UmT/VbKHWnLRXzK+j5fgtEFOEEAkQNgpgW3xyADV7BUASIfSHmEMs9hei
         4tWY+h45n37xc+XTmbsBU54Tg3+sMZNiw0Vuon0dGtP/Lt/39x/Orkd6DqsnPVarEW
         wV19x11J+BvHACJ/imdkajM7iDFVLoQvk+LMaPS7GGxoYUilWqDt8SPLzAqSRZ/wMS
         2K0ALowWKs67p+5bsv7cBcj9O1JtNtpLE1X71m9kaRVpdMxGYIayGs0HsYuC9n/6Jm
         hZJDs2mkjATWQ==
Date:   Sun, 9 Apr 2023 20:17:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 14/14] pds_core: Kconfig and pds_core.rst
Message-ID: <20230409171720.GI182481@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-15-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-15-shannon.nelson@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:43PM -0700, Shannon Nelson wrote:
> Documentation and Kconfig hook for building the driver.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  .../device_drivers/ethernet/amd/pds_core.rst     | 16 ++++++++++++++++
>  MAINTAINERS                                      |  9 +++++++++
>  drivers/net/ethernet/amd/Kconfig                 | 12 ++++++++++++
>  drivers/net/ethernet/amd/Makefile                |  1 +
>  4 files changed, 38 insertions(+)
> 
> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
> index 9449451b538f..c5ef20f361da 100644
> --- a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
> @@ -114,6 +114,22 @@ The driver supports a devlink health reporter for FW status::
>    # devlink health diagnose pci/0000:2b:00.0 reporter fw
>     Status: healthy State: 1 Generation: 0 Recoveries: 0
>  
> +Enabling the driver
> +===================
> +
> +The driver is enabled via the standard kernel configuration system,
> +using the make command::
> +
> +  make oldconfig/menuconfig/etc.
> +
> +The driver is located in the menu structure at:
> +
> +  -> Device Drivers
> +    -> Network device support (NETDEVICES [=y])
> +      -> Ethernet driver support
> +        -> AMD devices
> +          -> AMD/Pensando Ethernet PDS_CORE Support
> +
>  Support
>  =======
>  
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 30ca644d704f..95b5f25a2c06 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1041,6 +1041,15 @@ F:	drivers/gpu/drm/amd/include/vi_structs.h
>  F:	include/uapi/linux/kfd_ioctl.h
>  F:	include/uapi/linux/kfd_sysfs.h
>  
> +AMD PDS CORE DRIVER
> +M:	Shannon Nelson <shannon.nelson@amd.com>
> +M:	Brett Creeley <brett.creeley@amd.com>
> +M:	drivers@pensando.io

I don't know if we have any policy here, but prefer if we won't add
private distribution lists to MAINTAINERS file. It is very annoying
to send emails to these lists and get responses from random people.

> +L:	netdev@vger.kernel.org
> +S:	Supported
> +F:	Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
> +F:	drivers/net/ethernet/amd/pds_core/

You forgot to add includes to this list.

Thanks

> +
>  AMD SPI DRIVER
>  M:	Sanjay R Mehta <sanju.mehta@amd.com>
>  S:	Maintained
> diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
> index ab42f75b9413..235fcacef5c5 100644
> --- a/drivers/net/ethernet/amd/Kconfig
> +++ b/drivers/net/ethernet/amd/Kconfig
> @@ -186,4 +186,16 @@ config AMD_XGBE_HAVE_ECC
>  	bool
>  	default n
>  
> +config PDS_CORE
> +	tristate "AMD/Pensando Data Systems Core Device Support"
> +	depends on 64BIT && PCI
> +	help
> +	  This enables the support for the AMD/Pensando Core device family of
> +	  adapters.  More specific information on this driver can be
> +	  found in
> +	  <file:Documentation/networking/device_drivers/ethernet/amd/pds_core.rst>.
> +
> +	  To compile this driver as a module, choose M here. The module
> +	  will be called pds_core.
> +
>  endif # NET_VENDOR_AMD
> diff --git a/drivers/net/ethernet/amd/Makefile b/drivers/net/ethernet/amd/Makefile
> index 42742afe9115..2dcfb84731e1 100644
> --- a/drivers/net/ethernet/amd/Makefile
> +++ b/drivers/net/ethernet/amd/Makefile
> @@ -17,3 +17,4 @@ obj-$(CONFIG_PCNET32) += pcnet32.o
>  obj-$(CONFIG_SUN3LANCE) += sun3lance.o
>  obj-$(CONFIG_SUNLANCE) += sunlance.o
>  obj-$(CONFIG_AMD_XGBE) += xgbe/
> +obj-$(CONFIG_PDS_CORE) += pds_core/
> -- 
> 2.17.1
> 
