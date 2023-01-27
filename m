Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B4867E38D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 12:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbjA0LhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 06:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjA0Lgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 06:36:52 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BB822DD3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:36:22 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id m7so4694725wru.8
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZMvOkg8c6E27pI6AUOwQPDUMB8UTLi5/qPSaW785utE=;
        b=N3PTa5xo92M8Rx7am4+oPGNobgmkfgPYyzgDGm7crHz+yOk5ATii2jFvPnIeyWhf9R
         saIS8hEyn7B3Epv4B3dneT5vu3nqSuztIg8JgeiYmrVXJx4V6aLePHSC9rcRiMYrBrTF
         KXTqKV2oKNG61m3F767jb14nMkCJ5U1L99rtW6wrVFsqfu8LhBcO5cc8qJwJOjPm59Iu
         nTDLVEqekeEUwBk8ySErS0lQE9VkIh88nyCGPURdREfekmBPm0SGp0u+pkhdr/hZFbaW
         Pk83RmfbeJT6h3FZP15hSKmEypVLbVy6megdqGZLCz9mkMx+R4cWM9tYjAhvbaaHWQmj
         y8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMvOkg8c6E27pI6AUOwQPDUMB8UTLi5/qPSaW785utE=;
        b=oA9+DqYRKe9sc3eYUCX+z0KE/TCTIPkBO/vXRh6nPfaS9VRCwxWKp6grEkklLIkM/i
         EqEuCb7oAWc+uri5dlehPEHH579nTWeBOeZH0IlxwvkdOk2YYV7HWzntOMYwi56Xqy/q
         qTeRJrr6I5sleGbsNwy5nS89kmCRW6shU1ywlgDic8ntNZDRANXxIO1v0YSGa6qoCz1R
         HOoWLAGnu6akQBkSDaDB9nhfCy+r1/nClytlCr0DlWWXyJd+8JZxrcLmxUok3dhjKreF
         zz/VdRlyx2IxHiNaVd6VcO+uX+7PDaKzLM3W5IOE6YO6uv1zjJqegWxBxWczjhhL+0M/
         VvQg==
X-Gm-Message-State: AFqh2kp69jpyQcvllnJEJaAvzTUot1TGOoaDHtgMjV1YnRaN33PpllT6
        Y+hf8VTMARDJNp6ZKYmF168=
X-Google-Smtp-Source: AMrXdXtoCZKWrMkl4KbzLn/w4xtHxqfi2AshIsLzDA4RCvJSCaId7wu2VCxHIcWa2hxWqMnmlpdvsQ==
X-Received: by 2002:a5d:4606:0:b0:2bd:e960:9855 with SMTP id t6-20020a5d4606000000b002bde9609855mr34110395wrq.18.1674819329824;
        Fri, 27 Jan 2023 03:35:29 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id a13-20020adfeecd000000b002bbedd60a9asm3699138wrp.77.2023.01.27.03.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 03:35:29 -0800 (PST)
Date:   Fri, 27 Jan 2023 11:35:27 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH v3 net-next 5/8] sfc: add devlink port support for ef100
Message-ID: <Y9O2/+Vb+dQZVICv@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com
References: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
 <20230127093651.54035-6-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127093651.54035-6-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 09:36:48AM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Using the data when enumerating mports, create devlink ports just before
> netdevs are registered and remove those devlink ports after netdev has
> been unregistered.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c |  9 +++
>  drivers/net/ethernet/sfc/ef100_rep.c    | 22 ++++++
>  drivers/net/ethernet/sfc/ef100_rep.h    |  7 ++
>  drivers/net/ethernet/sfc/efx_devlink.c  | 97 +++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/efx_devlink.h  |  7 ++
>  drivers/net/ethernet/sfc/mae.h          |  2 +
>  drivers/net/ethernet/sfc/net_driver.h   |  2 +
>  7 files changed, 146 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> index b10a226f4a07..36774b55d413 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> @@ -335,7 +335,9 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>  
>  	/* devlink lock */
>  	efx_fini_devlink_start(efx);
> +
>  	ef100_unregister_netdev(efx);
> +	ef100_pf_unset_devlink_port(efx);
>  
>  #ifdef CONFIG_SFC_SRIOV
>  	efx_fini_tc(efx);
> @@ -423,6 +425,8 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  		rc = ef100_probe_netdev_pf(efx);
>  		if (rc)
>  			goto fail;
> +
> +		ef100_pf_set_devlink_port(efx);
>  	}
>  
>  	efx->netdev_notifier.notifier_call = ef100_netdev_event;
> @@ -433,7 +437,12 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  		goto fail;
>  	}
>  
> +	/* devlink unlock */
> +	efx_probe_devlink_done(efx);
> +	return rc;
>  fail:
> +	/* remove devlink port if does exist */
> +	ef100_pf_unset_devlink_port(efx);
>  	/* devlink unlock */
>  	efx_probe_devlink_done(efx);
>  	return rc;
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
> index ff5adfe3905e..b1637eb372ad 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -16,11 +16,48 @@
>  #include "mcdi.h"
>  #include "mcdi_functions.h"
>  #include "mcdi_pcol.h"
> +#include "mae.h"
> +#include "ef100_rep.h"
>  
>  struct efx_devlink {
>  	struct efx_nic *efx;
>  };
>  
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
> @@ -428,6 +465,66 @@ static const struct devlink_ops sfc_devlink_ops = {
>  	.info_get			= efx_devlink_info_get,
>  };
>  
> +static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
> +{
> +	struct mae_mport_desc *mport;
> +	u32 id;
> +
> +	if (efx_mae_lookup_mport(efx, idx, &id)) {
> +		/* This should not happen. */
> +		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
> +			pci_warn(efx->pci_dev, "No mport ID found for PF.\n");
> +		else
> +			pci_warn(efx->pci_dev, "No mport ID found for VF %u.\n",
> +				 idx);
> +		return NULL;
> +	}
> +
> +	mport = efx_mae_get_mport(efx, id);
> +	if (!mport) {
> +		/* This should not happen. */
> +		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
> +			pci_warn(efx->pci_dev, "No mport found for PF.\n");
> +		else
> +			pci_warn(efx->pci_dev, "No mport found for VF %u.\n",
> +				 idx);
> +		return NULL;
> +	}
> +
> +	if (efx_devlink_add_port(efx, mport)) {
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

I'd rather see these as static inline functions in the .h file.

> +
>  void efx_fini_devlink_start(struct efx_nic *efx)
>  {
>  	if (efx->devlink)
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
> index 8bcd077d8d8d..8d993ac2572b 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.h
> +++ b/drivers/net/ethernet/sfc/efx_devlink.h
> @@ -36,4 +36,11 @@ void efx_probe_devlink_done(struct efx_nic *efx);
>  void efx_fini_devlink_start(struct efx_nic *efx);
>  void efx_fini_devlink(struct efx_nic *efx);
>  
> +struct mae_mport_desc;

Why do you need this here? The new APIs below don't need it.

Martin

> +struct efx_rep;
> +
> +void ef100_pf_set_devlink_port(struct efx_nic *efx);
> +void ef100_rep_set_devlink_port(struct efx_rep *efv);
> +void ef100_pf_unset_devlink_port(struct efx_nic *efx);
> +void ef100_rep_unset_devlink_port(struct efx_rep *efv);
>  #endif	/* _EFX_DEVLINK_H */
> diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
> index d9adeafc0654..e1b7967132ad 100644
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
> @@ -44,6 +45,7 @@ struct mae_mport_desc {
>  	};
>  	struct rhash_head linkage;
>  	struct efx_rep *efv;
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
