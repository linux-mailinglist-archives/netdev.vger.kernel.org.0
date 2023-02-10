Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69394691A4C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjBJItv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjBJItr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:49:47 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADE811E89;
        Fri, 10 Feb 2023 00:49:46 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j25so4301759wrc.4;
        Fri, 10 Feb 2023 00:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ONDivwoh8QUsmogHcG0yCAavVOmTdt4GxOVZ06LX95c=;
        b=LCGPPzp8rP/oLRAU8aNh81cwAQvNog46WkwysIFklLQeLSVRHQ8WPc7txYpYgGhNpt
         N58jM/2nwWEXMwskHi5gXZCVpSfByl59OKcq9xPljxJVdPJk5flNKLjflg0cdhTFMgRj
         m6Oy9UAi8JS6v2jfxSQB+oxmivhARvbK793wq56/Bh2jatYXecWsfFRLaYRndjTcP2ot
         b+6fCmOUuoRsCf7lXM7SA8bUEhaUZ/CbhxE4hpwfdUvwHEG8UTYUyiv1iyXzrCH4wn9Z
         QifcmJtB4n7LCMVAAPfy3w84GYwFXGzyS953o6tzICISmEY4FruMRpEI7cLk9J3QaSKE
         7e3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ONDivwoh8QUsmogHcG0yCAavVOmTdt4GxOVZ06LX95c=;
        b=Cdw4vVwbsl6szmvZRyzVZfWNZb7ZqILUykcM/9Czwaz45XLgcKOeYO/RP12OKGwl6b
         moWZKS10EY4IpJ9MBZWuYBNmFt/VxU2lb0kTUqKUJN2wnVHZlz7vaDHsKs8fNL3iVFyS
         vgLfPqKVJazZqmePthkxwTK1fCO6EE6xJnbYzSuPd9yDy4DgxuRUuMXHNNEeXO3Rnnu1
         T7DU8qPwZ4fFxIxlNQ1RZaz74BGoyZLJ86cHWCfZbWcvWOL38TG5ycJq9qzromslj7nO
         1QrrKB39uiK1C34UwmgX5Xknsa9TkLdWRFLbUhQKeZjD3oNbpWhlaPNbwSJoLoTx9X1I
         wgXA==
X-Gm-Message-State: AO0yUKXvt+agMKDou1dfNF1h4P+P/oQMyRmpBXs81ZZiJVNupGZqZpDv
        1nldFLuo4GR6MU2iL/tgJOI=
X-Google-Smtp-Source: AK7set+xI6lJlleF3i+f9wDzGr33Kjm9tyzCfZ4tr0m8r0klKdXJOrqO+6d6n28okMydvGGbPd5yog==
X-Received: by 2002:adf:fd46:0:b0:2c5:4b0a:bab5 with SMTP id h6-20020adffd46000000b002c54b0abab5mr765939wrs.32.1676018984578;
        Fri, 10 Feb 2023 00:49:44 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id m6-20020adffe46000000b002c3ed120cf8sm3096131wrs.61.2023.02.10.00.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:49:44 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:49:41 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
Subject: Re: [PATCH v6 net-next 5/8] sfc: add devlink port support for ef100
Message-ID: <Y+YFJeCl92+4fI/1@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-6-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208142519.31192-6-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:25:16PM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Using the data when enumerating mports, create devlink ports just before
> netdevs are registered and remove those devlink ports after netdev has
> been unregistered.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c |  10 +++
>  drivers/net/ethernet/sfc/ef100_rep.c    |  22 ++++++
>  drivers/net/ethernet/sfc/ef100_rep.h    |   7 ++
>  drivers/net/ethernet/sfc/efx_devlink.c  | 101 ++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/efx_devlink.h  |   9 +++
>  drivers/net/ethernet/sfc/mae.h          |   2 +
>  drivers/net/ethernet/sfc/net_driver.h   |   2 +
>  7 files changed, 153 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> index 6cf74788b27a..368147359299 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> @@ -337,6 +337,7 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>  	ef100_unregister_netdev(efx);
>  
>  #ifdef CONFIG_SFC_SRIOV
> +	ef100_pf_unset_devlink_port(efx);
>  	efx_fini_tc(efx);
>  #endif
>  
> @@ -422,6 +423,9 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  		rc = ef100_probe_netdev_pf(efx);
>  		if (rc)
>  			goto fail;
> +#ifdef CONFIG_SFC_SRIOV
> +		ef100_pf_set_devlink_port(efx);
> +#endif
>  	}
>  
>  	efx->netdev_notifier.notifier_call = ef100_netdev_event;
> @@ -432,7 +436,13 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  		goto fail;
>  	}
>  
> +	efx_probe_devlink_unlock(efx);
> +	return rc;
>  fail:
> +#ifdef CONFIG_SFC_SRIOV
> +	/* remove devlink port if does exist */
> +	ef100_pf_unset_devlink_port(efx);
> +#endif
>  	efx_probe_devlink_unlock(efx);
>  	return rc;
>  }
> diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
> index 9cd1a3ac67e0..6b5bc5d6955d 100644
> --- a/drivers/net/ethernet/sfc/ef100_rep.c
> +++ b/drivers/net/ethernet/sfc/ef100_rep.c
> @@ -16,6 +16,7 @@
>  #include "mae.h"
>  #include "rx_common.h"
>  #include "tc_bindings.h"
> +#include "efx_devlink.h"
>  
>  #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
>  
> @@ -297,6 +298,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
>  			i, rc);
>  		goto fail1;
>  	}
> +	ef100_rep_set_devlink_port(efv);
>  	rc = register_netdev(efv->net_dev);
>  	if (rc) {
>  		pci_err(efx->pci_dev,
> @@ -308,6 +310,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
>  		efv->net_dev->name);
>  	return 0;
>  fail2:
> +	ef100_rep_unset_devlink_port(efv);
>  	efx_ef100_deconfigure_rep(efv);
>  fail1:
>  	efx_ef100_rep_destroy_netdev(efv);
> @@ -323,6 +326,7 @@ void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv)
>  		return;
>  	netif_dbg(efx, drv, rep_dev, "Removing VF representor\n");
>  	unregister_netdev(rep_dev);
> +	ef100_rep_unset_devlink_port(efv);
>  	efx_ef100_deconfigure_rep(efv);
>  	efx_ef100_rep_destroy_netdev(efv);
>  }
> @@ -339,6 +343,24 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
>  		efx_ef100_vfrep_destroy(efx, efv);
>  }
>  
> +static bool ef100_mport_is_pcie_vnic(struct mae_mport_desc *mport_desc)
> +{
> +	return mport_desc->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
> +	       mport_desc->vnic_client_type == MAE_MPORT_DESC_VNIC_CLIENT_TYPE_FUNCTION;
> +}
> +
> +bool ef100_mport_on_local_intf(struct efx_nic *efx,
> +			       struct mae_mport_desc *mport_desc)
> +{
> +	struct ef100_nic_data *nic_data = efx->nic_data;
> +	bool pcie_func;
> +
> +	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
> +
> +	return nic_data->have_local_intf && pcie_func &&
> +		     mport_desc->interface_idx == nic_data->local_mae_intf;
> +}
> +
>  void efx_ef100_init_reps(struct efx_nic *efx)
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
> diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
> index 328ac0cbb532..ae6add4b0855 100644
> --- a/drivers/net/ethernet/sfc/ef100_rep.h
> +++ b/drivers/net/ethernet/sfc/ef100_rep.h
> @@ -22,6 +22,8 @@ struct efx_rep_sw_stats {
>  	atomic64_t rx_dropped, tx_errors;
>  };
>  
> +struct devlink_port;
> +
>  /**
>   * struct efx_rep - Private data for an Efx representor
>   *
> @@ -39,6 +41,7 @@ struct efx_rep_sw_stats {
>   * @rx_lock: protects @rx_list
>   * @napi: NAPI control structure
>   * @stats: software traffic counters for netdev stats
> + * @dl_port: devlink port associated to this netdev representor
>   */
>  struct efx_rep {
>  	struct efx_nic *parent;
> @@ -54,6 +57,7 @@ struct efx_rep {
>  	spinlock_t rx_lock;
>  	struct napi_struct napi;
>  	struct efx_rep_sw_stats stats;
> +	struct devlink_port *dl_port;
>  };
>  
>  int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
> @@ -69,4 +73,7 @@ struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
>  extern const struct net_device_ops efx_ef100_rep_netdev_ops;
>  void efx_ef100_init_reps(struct efx_nic *efx);
>  void efx_ef100_fini_reps(struct efx_nic *efx);
> +struct mae_mport_desc;
> +bool ef100_mport_on_local_intf(struct efx_nic *efx,
> +			       struct mae_mport_desc *mport_desc);
>  #endif /* EF100_REP_H */
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index c06efeac11e5..1b1276716113 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -14,6 +14,8 @@
>  #include "mcdi.h"
>  #include "mcdi_functions.h"
>  #include "mcdi_pcol.h"
> +#include "mae.h"
> +#include "ef100_rep.h"
>  #endif
>  
>  struct efx_devlink {
> @@ -21,6 +23,41 @@ struct efx_devlink {
>  };
>  
>  #ifdef CONFIG_SFC_SRIOV
> +static void efx_devlink_del_port(struct devlink_port *dl_port)
> +{
> +	if (!dl_port)
> +		return;
> +	devl_port_unregister(dl_port);
> +}
> +
> +static int efx_devlink_add_port(struct efx_nic *efx,
> +				struct mae_mport_desc *mport)
> +{
> +	bool external = false;
> +
> +	if (!ef100_mport_on_local_intf(efx, mport))
> +		external = true;
> +
> +	switch (mport->mport_type) {
> +	case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
> +		if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL)
> +			devlink_port_attrs_pci_vf_set(&mport->dl_port, 0, mport->pf_idx,
> +						      mport->vf_idx,
> +						      external);
> +		else
> +			devlink_port_attrs_pci_pf_set(&mport->dl_port, 0, mport->pf_idx,
> +						      external);
> +		break;
> +	default:
> +		/* MAE_MPORT_DESC_MPORT_ALIAS and UNDEFINED */
> +		return 0;
> +	}
> +
> +	mport->dl_port.index = mport->mport_id;
> +
> +	return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
> +}
> +
>  static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>  					    struct devlink_info_req *req,
>  					    unsigned int partition_type,
> @@ -477,6 +514,70 @@ static const struct devlink_ops sfc_devlink_ops = {
>  #endif
>  };
>  
> +#ifdef CONFIG_SFC_SRIOV
> +static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
> +{
> +	struct mae_mport_desc *mport;
> +	u32 id;
> +	int rc;
> +
> +	if (efx_mae_lookup_mport(efx, idx, &id)) {
> +		/* This should not happen. */
> +		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
> +			pci_warn_once(efx->pci_dev, "No mport ID found for PF.\n");
> +		else
> +			pci_warn_once(efx->pci_dev, "No mport ID found for VF %u.\n",
> +				      idx);
> +		return NULL;
> +	}
> +
> +	mport = efx_mae_get_mport(efx, id);
> +	if (!mport) {
> +		/* This should not happen. */
> +		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
> +			pci_warn_once(efx->pci_dev, "No mport found for PF.\n");
> +		else
> +			pci_warn_once(efx->pci_dev, "No mport found for VF %u.\n",
> +				      idx);
> +		return NULL;
> +	}
> +
> +	rc = efx_devlink_add_port(efx, mport);
> +	if (rc) {
> +		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
> +			pci_warn(efx->pci_dev,
> +				 "devlink port creation for PF failed.\n");
> +		else
> +			pci_warn(efx->pci_dev,
> +				 "devlink_port creationg for VF %u failed.\n",
> +				 idx);
> +		return NULL;
> +	}
> +
> +	return &mport->dl_port;
> +}
> +
> +void ef100_rep_set_devlink_port(struct efx_rep *efv)
> +{
> +	efv->dl_port = ef100_set_devlink_port(efv->parent, efv->idx);
> +}
> +
> +void ef100_pf_set_devlink_port(struct efx_nic *efx)
> +{
> +	efx->dl_port = ef100_set_devlink_port(efx, MAE_MPORT_DESC_VF_IDX_NULL);
> +}
> +
> +void ef100_rep_unset_devlink_port(struct efx_rep *efv)
> +{
> +	efx_devlink_del_port(efv->dl_port);
> +}
> +
> +void ef100_pf_unset_devlink_port(struct efx_nic *efx)
> +{
> +	efx_devlink_del_port(efx->dl_port);
> +}
> +#endif
> +
>  void efx_fini_devlink_lock(struct efx_nic *efx)
>  {
>  	if (efx->devlink)
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
> index a5269361c3e0..d544885d3dbf 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.h
> +++ b/drivers/net/ethernet/sfc/efx_devlink.h
> @@ -36,4 +36,13 @@ void efx_probe_devlink_unlock(struct efx_nic *efx);
>  void efx_fini_devlink_lock(struct efx_nic *efx);
>  void efx_fini_devlink_and_unlock(struct efx_nic *efx);
>  
> +#ifdef CONFIG_SFC_SRIOV
> +struct efx_rep;
> +
> +void ef100_pf_set_devlink_port(struct efx_nic *efx);
> +void ef100_rep_set_devlink_port(struct efx_rep *efv);
> +void ef100_pf_unset_devlink_port(struct efx_nic *efx);
> +void ef100_rep_unset_devlink_port(struct efx_rep *efv);
> +#endif
> +
>  #endif	/* _EFX_DEVLINK_H */
> diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
> index b9bf86c47cda..bec293a06733 100644
> --- a/drivers/net/ethernet/sfc/mae.h
> +++ b/drivers/net/ethernet/sfc/mae.h
> @@ -13,6 +13,7 @@
>  #define EF100_MAE_H
>  /* MCDI interface for the ef100 Match-Action Engine */
>  
> +#include <net/devlink.h>
>  #include "net_driver.h"
>  #include "tc.h"
>  #include "mcdi_pcol.h" /* needed for various MC_CMD_MAE_*_NULL defines */
> @@ -43,6 +44,7 @@ struct mae_mport_desc {
>  		};
>  	};
>  	struct rhash_head linkage;
> +	struct devlink_port dl_port;
>  };
>  
>  int efx_mae_enumerate_mports(struct efx_nic *efx);
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index bc9efbfb3d6b..fcd51d3992fa 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -998,6 +998,7 @@ struct efx_mae;
>   * @netdev_notifier: Netdevice notifier.
>   * @tc: state for TC offload (EF100).
>   * @devlink: reference to devlink structure owned by this device
> + * @dl_port: devlink port associated with the PF
>   * @mem_bar: The BAR that is mapped into membase.
>   * @reg_base: Offset from the start of the bar to the function control window.
>   * @monitor_work: Hardware monitor workitem
> @@ -1185,6 +1186,7 @@ struct efx_nic {
>  	struct efx_tc_state *tc;
>  
>  	struct devlink *devlink;
> +	struct devlink_port *dl_port;
>  	unsigned int mem_bar;
>  	u32 reg_base;
>  
> -- 
> 2.17.1
