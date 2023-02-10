Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323446919FD
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjBJI2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbjBJI2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:28:15 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05705894D;
        Fri, 10 Feb 2023 00:28:13 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id by3so2929307wrb.10;
        Fri, 10 Feb 2023 00:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WNyR2dKtdJRwE8UawZHaeJYApSQ4jL89IONyCqjtAWU=;
        b=SAR+43xwXCxDAnUsz1aEX4977QPGzQ+IvJBpwooFMdb45NaIPgxHZTNZ1KDKX0wxfO
         NSunoylDAczrJRpFJAng/3KlzImAAgl0DkBy+yRwPt9UOJ3RrPZpGbE4dwZAISgKeBZZ
         x2PHUK/XU9eF+oOFEvV3E57FTHGL93LbhmKNiTELiJ7MjRbTGSfaG/Et+utTc9sUtGno
         N82hW1nVx9zRO12vGnojXxCxkyyIA9t7NEJumUtNW0khqigUIKQUzhDxY/bofQm8Uqcv
         vtK/vqrkMmT4GbeTuv7L+CONCV2jLPOgFDe3J1Z3UC+HnaFs9sBAbO2noEzyW1Tc70Fx
         HGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WNyR2dKtdJRwE8UawZHaeJYApSQ4jL89IONyCqjtAWU=;
        b=qw84VPhmU1SeprCnB8SMFRWZK3V+C0D3aMw6LsXr20lm5kvzMZTF46JLujjoxnxZ2g
         H1aVZ3q51g5saR0xbGMGAlhkicHqAKBs851Ro7nFV1/Q8SFz6MIHx6cHXoSZQqKOFiLe
         haUiRqRaCB+vsivZED8BwXT65vej2/C/NZdHQfchVSF4Wow+oIlS1LxP0Z4/7o1j7igY
         SwdEEsLswTm/B1Ol2h8l7jhsWQC0epZ/FnPrO4mT0EYH6lUc6e4VrJb16tcoeO5GgCmG
         rGlgVLmpCFT4lRJJB1IhIGuUST4gf8nlKAV36Cs5gBJ0uHzY/YgWEsyfUUllAR2EKSUv
         B+qA==
X-Gm-Message-State: AO0yUKXOUUVYMfVsH/qzgByNZOSU+sJh1SzG8T94S+lk5VJeplHefEsR
        bOn1I/wJQrPq2fKUaiUDEeE=
X-Google-Smtp-Source: AK7set9WBNlWg+JlofPdBzd2ivBQUp6wBQL78+JL71NBuKJ6wEizyDe0iQev6G5ayvDVi5GD7jyIog==
X-Received: by 2002:adf:fac9:0:b0:2c4:645:da3f with SMTP id a9-20020adffac9000000b002c40645da3fmr7010791wrs.48.1676017692429;
        Fri, 10 Feb 2023 00:28:12 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id h12-20020adff4cc000000b002be505ab59asm3071876wrp.97.2023.02.10.00.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:28:12 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:28:10 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
Subject: Re: [PATCH v6 net-next 1/8] sfc: add devlink support for ef100
Message-ID: <Y+X/zoltG4QlaUql@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-2-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208142519.31192-2-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:25:12PM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Add devlink infrastructure support. Further patches add devlink
> info and devlink port support.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/Kconfig        |  1 +
>  drivers/net/ethernet/sfc/Makefile       |  3 +-
>  drivers/net/ethernet/sfc/ef100_netdev.c | 10 ++++
>  drivers/net/ethernet/sfc/efx_devlink.c  | 64 +++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/efx_devlink.h  | 22 +++++++++
>  drivers/net/ethernet/sfc/net_driver.h   |  2 +
>  6 files changed, 101 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
>  create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h
> 
> diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
> index 0950e6b0508f..4af36ba8906b 100644
> --- a/drivers/net/ethernet/sfc/Kconfig
> +++ b/drivers/net/ethernet/sfc/Kconfig
> @@ -22,6 +22,7 @@ config SFC
>  	depends on PTP_1588_CLOCK_OPTIONAL
>  	select MDIO
>  	select CRC32
> +	select NET_DEVLINK
>  	help
>  	  This driver supports 10/40-gigabit Ethernet cards based on
>  	  the Solarflare SFC9100-family controllers.
> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
> index 712a48d00069..55b9c73cd8ef 100644
> --- a/drivers/net/ethernet/sfc/Makefile
> +++ b/drivers/net/ethernet/sfc/Makefile
> @@ -6,7 +6,8 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
>  			   mcdi.o mcdi_port.o mcdi_port_common.o \
>  			   mcdi_functions.o mcdi_filters.o mcdi_mon.o \
>  			   ef100.o ef100_nic.o ef100_netdev.o \
> -			   ef100_ethtool.o ef100_rx.o ef100_tx.o
> +			   ef100_ethtool.o ef100_rx.o ef100_tx.o \
> +			   efx_devlink.o
>  sfc-$(CONFIG_SFC_MTD)	+= mtd.o
>  sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>                             mae.o tc.o tc_bindings.o tc_counters.o
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> index ddcc325ed570..6cf74788b27a 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> @@ -24,6 +24,7 @@
>  #include "rx_common.h"
>  #include "ef100_sriov.h"
>  #include "tc_bindings.h"
> +#include "efx_devlink.h"
>  
>  static void ef100_update_name(struct efx_nic *efx)
>  {
> @@ -332,6 +333,7 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>  		efx_ef100_pci_sriov_disable(efx, true);
>  #endif
>  
> +	efx_fini_devlink_lock(efx);
>  	ef100_unregister_netdev(efx);
>  
>  #ifdef CONFIG_SFC_SRIOV
> @@ -345,6 +347,8 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>  	kfree(efx->phy_data);
>  	efx->phy_data = NULL;
>  
> +	efx_fini_devlink_and_unlock(efx);
> +
>  	free_netdev(efx->net_dev);
>  	efx->net_dev = NULL;
>  	efx->state = STATE_PROBED;
> @@ -405,6 +409,11 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  	/* Don't fail init if RSS setup doesn't work. */
>  	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
>  
> +	/* devlink creation, registration and lock */
> +	rc = efx_probe_devlink_and_lock(efx);
> +	if (rc)
> +		pci_info(efx->pci_dev, "devlink registration failed");
> +
>  	rc = ef100_register_netdev(efx);
>  	if (rc)
>  		goto fail;
> @@ -424,5 +433,6 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  	}
>  
>  fail:
> +	efx_probe_devlink_unlock(efx);
>  	return rc;
>  }
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> new file mode 100644
> index 000000000000..57a7023d3cb6
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -0,0 +1,64 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/****************************************************************************
> + * Driver for AMD network controllers and boards
> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#include "efx_devlink.h"
> +
> +struct efx_devlink {
> +	struct efx_nic *efx;
> +};
> +
> +static const struct devlink_ops sfc_devlink_ops = {
> +};
> +
> +void efx_fini_devlink_lock(struct efx_nic *efx)
> +{
> +	if (efx->devlink)
> +		devl_lock(efx->devlink);
> +}
> +
> +void efx_fini_devlink_and_unlock(struct efx_nic *efx)
> +{
> +	if (efx->devlink) {
> +		devl_unregister(efx->devlink);
> +		devl_unlock(efx->devlink);
> +		devlink_free(efx->devlink);
> +		efx->devlink = NULL;
> +	}
> +}
> +
> +int efx_probe_devlink_and_lock(struct efx_nic *efx)
> +{
> +	struct efx_devlink *devlink_private;
> +
> +	if (efx->type->is_vf)
> +		return 0;
> +
> +	efx->devlink = devlink_alloc(&sfc_devlink_ops,
> +				     sizeof(struct efx_devlink),
> +				     &efx->pci_dev->dev);
> +	if (!efx->devlink)
> +		return -ENOMEM;
> +
> +	devl_lock(efx->devlink);
> +	devlink_private = devlink_priv(efx->devlink);
> +	devlink_private->efx = efx;
> +
> +	devl_register(efx->devlink);
> +
> +	return 0;
> +}
> +
> +void efx_probe_devlink_unlock(struct efx_nic *efx)
> +{
> +	if (!efx->devlink)
> +		return;
> +
> +	devl_unlock(efx->devlink);
> +}
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
> new file mode 100644
> index 000000000000..8ff85b035e87
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/efx_devlink.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/****************************************************************************
> + * Driver for AMD network controllers and boards
> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#ifndef _EFX_DEVLINK_H
> +#define _EFX_DEVLINK_H
> +
> +#include "net_driver.h"
> +#include <net/devlink.h>
> +
> +int efx_probe_devlink_and_lock(struct efx_nic *efx);
> +void efx_probe_devlink_unlock(struct efx_nic *efx);
> +void efx_fini_devlink_lock(struct efx_nic *efx);
> +void efx_fini_devlink_and_unlock(struct efx_nic *efx);
> +
> +#endif	/* _EFX_DEVLINK_H */
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 3b49e216768b..d036641dc043 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -994,6 +994,7 @@ enum efx_xdp_tx_queues_mode {
>   *      xdp_rxq_info structures?
>   * @netdev_notifier: Netdevice notifier.
>   * @tc: state for TC offload (EF100).
> + * @devlink: reference to devlink structure owned by this device
>   * @mem_bar: The BAR that is mapped into membase.
>   * @reg_base: Offset from the start of the bar to the function control window.
>   * @monitor_work: Hardware monitor workitem
> @@ -1179,6 +1180,7 @@ struct efx_nic {
>  	struct notifier_block netdev_notifier;
>  	struct efx_tc_state *tc;
>  
> +	struct devlink *devlink;
>  	unsigned int mem_bar;
>  	u32 reg_base;
>  
> -- 
> 2.17.1
