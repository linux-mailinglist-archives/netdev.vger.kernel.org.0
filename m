Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94E73A5974
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 18:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhFMQDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 12:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231887AbhFMQDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 12:03:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6E446109E;
        Sun, 13 Jun 2021 16:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623600073;
        bh=6XtbqBMiV++spgtUrHW4ONaxsafcflcg/T61pQoP0LU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qACohP6sLJcb8WgGmP7iRsdOWVo+ZKoDZaK7tOXgSAyh/amkW9qqBaJFmtzIpS6NN
         hueQdAj4uWctorvaPM6GIlBQ2XO+wHgKqXkEWi2AvUFXvvq2uUtaA5Ce1CWNyXyQKD
         REDrj3Eilvk+TU/ff/oEnRT8i9O65dmv/twNU8YnTjDoNyV0a+LEZu1RbuidigaiAL
         /feaEfhQf3B2DBEasJnJJCuQT0lmlTnDly+UedHO7rbolda8zQAbLLCds3CxLO2Ehk
         BBM1AoBlkU505ZYcHZaElQxI1Uzez/E5YmTMpaaicp9dS5+oZ7Ny2y33R3hVi7euWX
         u7WrTIFNBw16Q==
Date:   Sun, 13 Jun 2021 19:01:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: Re: [PATCH V5 16/16] net: iosm: infrastructure
Message-ID: <YMYrxfpr4q8R1mcq@unreal>
References: <20210613125023.18945-1-m.chetan.kumar@intel.com>
 <20210613125023.18945-17-m.chetan.kumar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613125023.18945-17-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 06:20:23PM +0530, M Chetan Kumar wrote:
> 1) Kconfig & Makefile changes for IOSM Driver compilation.
> 2) Add IOSM Driver documentation.
> 3) Modified MAINTAINER file for IOSM Driver addition.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
> ---
> v5: Update mbim port name in doc to wwan0mbim0.
> v4: Adapt to wwan subsystem rtnet_link framework.
> v3:
> * Clean-up driver/net Kconfig & Makefile (Changes available as
>   part of wwan subsystem).
> * Removed NET dependency key word from iosm Kconfig.
> * Removed IOCTL section from documentation.
> v2:
> * Moved driver documentation to RsT file.
> * Modified if_link.h file to support link type iosm.
> ---
>  .../networking/device_drivers/index.rst       |  1 +
>  .../networking/device_drivers/wwan/index.rst  | 18 ++++
>  .../networking/device_drivers/wwan/iosm.rst   | 96 +++++++++++++++++++
>  MAINTAINERS                                   |  7 ++
>  drivers/net/wwan/Kconfig                      | 12 +++
>  drivers/net/wwan/Makefile                     |  1 +
>  drivers/net/wwan/iosm/Makefile                | 26 +++++
>  7 files changed, 161 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/wwan/index.rst
>  create mode 100644 Documentation/networking/device_drivers/wwan/iosm.rst
>  create mode 100644 drivers/net/wwan/iosm/Makefile

<...>

> +obj-$(CONFIG_IOSM) += iosm/
> diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
> new file mode 100644
> index 000000000000..cdeeb9357af6
> --- /dev/null
> +++ b/drivers/net/wwan/iosm/Makefile
> @@ -0,0 +1,26 @@
> +# SPDX-License-Identifier: (GPL-2.0-only)
> +#
> +# Copyright (C) 2020-21 Intel Corporation.
> +#
> +
> +iosm-y = \
> +	iosm_ipc_task_queue.o	\
> +	iosm_ipc_imem.o			\
> +	iosm_ipc_imem_ops.o		\
> +	iosm_ipc_mmio.o			\
> +	iosm_ipc_port.o			\
> +	iosm_ipc_wwan.o			\
> +	iosm_ipc_uevent.o		\
> +	iosm_ipc_pm.o			\
> +	iosm_ipc_pcie.o			\
> +	iosm_ipc_irq.o			\
> +	iosm_ipc_chnl_cfg.o		\
> +	iosm_ipc_protocol.o		\
> +	iosm_ipc_protocol_ops.o	\
> +	iosm_ipc_mux.o			\
> +	iosm_ipc_mux_codec.o
> +
> +obj-$(CONFIG_IOSM) := iosm.o
> +
> +# compilation flags
> +ccflags-y += -DDEBUG

Please no, default kernel code should be in release quality.

Thanks

> -- 
> 2.25.1
> 
