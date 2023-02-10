Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163F7691A40
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjBJIqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbjBJIql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:46:41 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919E0113E2;
        Fri, 10 Feb 2023 00:46:39 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so3506646wmb.2;
        Fri, 10 Feb 2023 00:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=II9d5b0ziZxauh6Y5uKygkaWSJhGJw05IGQVeeXQIPs=;
        b=ddMKhbW0lbL4Uh7unvl5bMN8QpLF0+OcS2EjiYFe/rw9pSUlk8VmoDYzuyBBpS8NGt
         uvW3BJE+85rDfkB2m6KZZw/OjH1LM/qkTyLuuzXV5EG5+ooJkMSU8cStIQF7BiD0RK+4
         Shy4hi86EUM6jhdWjfPsmAy5PteEkDJuoUXoWstIbDVnjBFOBIODXwMKdWjbHridp7oY
         2gqlhP6XBsJJHrpSKKoJVHH8rmCoui1c5iPBm/EVVDJ26CHyts0P6z7LnJ8LNhnrsrUA
         c1s0qHOzMgGnwWos5doqouIozbLd5mFKYuzDLJrIhu2Q9Hq0xdEY4GrCy6q4rUp/pnhf
         IErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=II9d5b0ziZxauh6Y5uKygkaWSJhGJw05IGQVeeXQIPs=;
        b=SoI5r42RrwmZQC18Jd9GEFW+L9dTNvHu05Mri+afkNZqPqZ198waOso50QH8Yr1rMl
         j792wgQZd3F7OikveEzmOwqqUl5/yYVAsxQ4YfZ1wDU7ubDDUaZGsAiocAN+jGLtSVI4
         b6hukxyrNeCKOnBElk7ZmlQY4Sx0XObwpkauTrOmyeqJa2G0CZ1dnuoqZfEVuIZrmOke
         RkQrjUF5SfvD07NaYiGZCSGLUcIKGVEOspM7ccR3AxJMfROflfd2dPsAaz5qL7cRETbH
         DeIF1YR/zW14/bwPjC/Uj2M90oaJfN1mJCHBc81sn/SIjAWFsIN7FbKQaPCyQ/y3F5b0
         +2nA==
X-Gm-Message-State: AO0yUKXj2qjqiPZJyppHEezRuzSrIt2eb4anM6znaCJ/RoDbDKSZU77m
        i87DFTRE2UFmsbcrc9usvI0vCJZhPWc=
X-Google-Smtp-Source: AK7set9+p5rKg1DCuBpnQnpZjqH31i/poKlF/IRHY0TO2ph1zyuZF7dVaLWmDXs7lqUKrgmM+zvJhA==
X-Received: by 2002:a05:600c:a686:b0:3e0:fad:5fa8 with SMTP id ip6-20020a05600ca68600b003e00fad5fa8mr12179185wmb.33.1676018797986;
        Fri, 10 Feb 2023 00:46:37 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id c10-20020a05600c170a00b003df241f52e8sm3961158wmn.42.2023.02.10.00.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:46:37 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:46:35 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
Subject: Re: [PATCH v6 net-next 3/8] sfc: enumerate mports in ef100
Message-ID: <Y+YEa07aM6OcFyYQ@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-4-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208142519.31192-4-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:25:14PM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> MAE ports (mports) are the ports on the EF100 embedded switch such
> as networking PCIe functions, the physical port, and potentially
> others.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

I can see this patch uses ifdef CONFIG_SFC_SRIOV, which makes sense
to me as it is for for devlink port.
The previous patch [2/8] is for devlink dev info, which must always
work. Even without SRIOV.

> ---
>  drivers/net/ethernet/sfc/ef100_nic.c  |  27 ++++
>  drivers/net/ethernet/sfc/ef100_nic.h  |   4 +
>  drivers/net/ethernet/sfc/ef100_rep.c  |  22 +++
>  drivers/net/ethernet/sfc/ef100_rep.h  |   2 +
>  drivers/net/ethernet/sfc/mae.c        | 191 ++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/mae.h        |  36 +++++
>  drivers/net/ethernet/sfc/mcdi.h       |   5 +
>  drivers/net/ethernet/sfc/net_driver.h |   4 +
>  8 files changed, 291 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index ad686c671ab8..07e7dca0e4f2 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -747,6 +747,19 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
>  			   id);
>  	nic_data->base_mport = id;
>  	nic_data->have_mport = true;
> +
> +	/* Construct mport selector for "calling PF" */
> +	efx_mae_mport_uplink(efx, &selector);
> +	/* Look up actual mport ID */
> +	rc = efx_mae_lookup_mport(efx, selector, &id);
> +	if (rc)
> +		return rc;
> +	if (id >> 16)
> +		netif_warn(efx, probe, efx->net_dev, "Bad own m-port id %#x\n",
> +			   id);
> +	nic_data->own_mport = id;
> +	nic_data->have_own_mport = true;
> +
>  	return 0;
>  }
>  #endif
> @@ -1126,6 +1139,14 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>  			   rc);
>  	}
>  
> +	rc = efx_init_mae(efx);
> +	if (rc)
> +		netif_warn(efx, probe, net_dev,
> +			   "Failed to init MAE rc %d; representors will not function\n",
> +			   rc);
> +	else
> +		efx_ef100_init_reps(efx);
> +
>  	rc = efx_init_tc(efx);
>  	if (rc) {
>  		/* Either we don't have an MAE at all (i.e. legacy v-switching),
> @@ -1157,6 +1178,12 @@ void ef100_remove(struct efx_nic *efx)
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
>  
> +#ifdef CONFIG_SFC_SRIOV
> +	if (efx->mae) {
> +		efx_ef100_fini_reps(efx);
> +		efx_fini_mae(efx);
> +	}
> +#endif
>  	efx_mcdi_detach(efx);
>  	efx_mcdi_fini(efx);
>  	if (nic_data)
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
> index 0295933145fa..496aea43c60f 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.h
> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
> @@ -74,6 +74,10 @@ struct ef100_nic_data {
>  	u64 stats[EF100_STAT_COUNT];
>  	u32 base_mport;
>  	bool have_mport; /* base_mport was populated successfully */
> +	u32 own_mport;
> +	u32 local_mae_intf; /* interface_idx that corresponds to us, in mport enumerate */
> +	bool have_own_mport; /* own_mport was populated successfully */
> +	bool have_local_intf; /* local_mae_intf was populated successfully */
>  	bool grp_mae; /* MAE Privilege */
>  	u16 tso_max_hdr_len;
>  	u16 tso_max_payload_num_segs;
> diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
> index 81ab22c74635..ebe7b1275713 100644
> --- a/drivers/net/ethernet/sfc/ef100_rep.c
> +++ b/drivers/net/ethernet/sfc/ef100_rep.c
> @@ -9,6 +9,7 @@
>   * by the Free Software Foundation, incorporated herein by reference.
>   */
>  
> +#include <linux/rhashtable.h>
>  #include "ef100_rep.h"
>  #include "ef100_netdev.h"
>  #include "ef100_nic.h"
> @@ -341,6 +342,27 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
>  		efx_ef100_vfrep_destroy(efx, efv);
>  }
>  
> +void efx_ef100_init_reps(struct efx_nic *efx)
> +{
> +	struct ef100_nic_data *nic_data = efx->nic_data;
> +	int rc;
> +
> +	nic_data->have_local_intf = false;
> +	rc = efx_mae_enumerate_mports(efx);
> +	if (rc)
> +		pci_warn(efx->pci_dev,
> +			 "Could not enumerate mports (rc=%d), are we admin?",
> +			 rc);
> +}
> +
> +void efx_ef100_fini_reps(struct efx_nic *efx)
> +{
> +	struct efx_mae *mae = efx->mae;
> +
> +	rhashtable_free_and_destroy(&mae->mports_ht, efx_mae_remove_mport,
> +				    NULL);
> +}
> +
>  static int efx_ef100_rep_poll(struct napi_struct *napi, int weight)
>  {
>  	struct efx_rep *efv = container_of(napi, struct efx_rep, napi);
> diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
> index c21bc716f847..328ac0cbb532 100644
> --- a/drivers/net/ethernet/sfc/ef100_rep.h
> +++ b/drivers/net/ethernet/sfc/ef100_rep.h
> @@ -67,4 +67,6 @@ void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf);
>   */
>  struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
>  extern const struct net_device_ops efx_ef100_rep_netdev_ops;
> +void efx_ef100_init_reps(struct efx_nic *efx);
> +void efx_ef100_fini_reps(struct efx_nic *efx);
>  #endif /* EF100_REP_H */
> diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
> index 583baf69981c..725a3ab31087 100644
> --- a/drivers/net/ethernet/sfc/mae.c
> +++ b/drivers/net/ethernet/sfc/mae.c
> @@ -9,8 +9,11 @@
>   * by the Free Software Foundation, incorporated herein by reference.
>   */
>  
> +#include <linux/rhashtable.h>
> +#include "ef100_nic.h"
>  #include "mae.h"
>  #include "mcdi.h"
> +#include "mcdi_pcol.h"
>  #include "mcdi_pcol_mae.h"
>  
>  int efx_mae_allocate_mport(struct efx_nic *efx, u32 *id, u32 *label)
> @@ -490,6 +493,163 @@ static bool efx_mae_asl_id(u32 id)
>  	return !!(id & BIT(31));
>  }
>  
> +/* mport handling */
> +static const struct rhashtable_params efx_mae_mports_ht_params = {
> +	.key_len	= sizeof(u32),
> +	.key_offset	= offsetof(struct mae_mport_desc, mport_id),
> +	.head_offset	= offsetof(struct mae_mport_desc, linkage),
> +};
> +
> +struct mae_mport_desc *efx_mae_get_mport(struct efx_nic *efx, u32 mport_id)
> +{
> +	return rhashtable_lookup_fast(&efx->mae->mports_ht, &mport_id,
> +				      efx_mae_mports_ht_params);
> +}
> +
> +static int efx_mae_add_mport(struct efx_nic *efx, struct mae_mport_desc *desc)
> +{
> +	struct efx_mae *mae = efx->mae;
> +	int rc;
> +
> +	rc = rhashtable_insert_fast(&mae->mports_ht, &desc->linkage,
> +				    efx_mae_mports_ht_params);
> +
> +	if (rc) {
> +		pci_err(efx->pci_dev, "Failed to insert MPORT %08x, rc %d\n",
> +			desc->mport_id, rc);
> +		kfree(desc);
> +		return rc;
> +	}
> +
> +	return rc;
> +}
> +
> +void efx_mae_remove_mport(void *desc, void *arg)
> +{
> +	struct mae_mport_desc *mport = desc;
> +
> +	synchronize_rcu();
> +	kfree(mport);
> +}
> +
> +static int efx_mae_process_mport(struct efx_nic *efx,
> +				 struct mae_mport_desc *desc)
> +{
> +	struct ef100_nic_data *nic_data = efx->nic_data;
> +	struct mae_mport_desc *mport;
> +
> +	mport = efx_mae_get_mport(efx, desc->mport_id);
> +	if (!IS_ERR_OR_NULL(mport)) {
> +		netif_err(efx, drv, efx->net_dev,
> +			  "mport with id %u does exist!!!\n", desc->mport_id);
> +		return -EEXIST;
> +	}
> +
> +	if (nic_data->have_own_mport &&
> +	    desc->mport_id == nic_data->own_mport) {
> +		WARN_ON(desc->mport_type != MAE_MPORT_DESC_MPORT_TYPE_VNIC);
> +		WARN_ON(desc->vnic_client_type !=
> +			MAE_MPORT_DESC_VNIC_CLIENT_TYPE_FUNCTION);
> +		nic_data->local_mae_intf = desc->interface_idx;
> +		nic_data->have_local_intf = true;
> +		pci_dbg(efx->pci_dev, "MAE interface_idx is %u\n",
> +			nic_data->local_mae_intf);
> +	}
> +
> +	return efx_mae_add_mport(efx, desc);
> +}
> +
> +#define MCDI_MPORT_JOURNAL_LEN \
> +	ALIGN(MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_LENMAX_MCDI2, 4)
> +
> +int efx_mae_enumerate_mports(struct efx_nic *efx)
> +{
> +	efx_dword_t *outbuf = kzalloc(MCDI_MPORT_JOURNAL_LEN, GFP_KERNEL);
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_READ_JOURNAL_IN_LEN);
> +	MCDI_DECLARE_STRUCT_PTR(desc);
> +	size_t outlen, stride, count;
> +	int rc = 0, i;
> +
> +	if (!outbuf)
> +		return -ENOMEM;
> +	do {
> +		rc = efx_mcdi_rpc(efx, MC_CMD_MAE_MPORT_READ_JOURNAL, inbuf,
> +				  sizeof(inbuf), outbuf,
> +				  MCDI_MPORT_JOURNAL_LEN, &outlen);
> +		if (rc)
> +			goto fail;
> +		if (outlen < MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_MPORT_DESC_DATA_OFST) {
> +			rc = -EIO;
> +			goto fail;
> +		}
> +		count = MCDI_DWORD(outbuf, MAE_MPORT_READ_JOURNAL_OUT_MPORT_DESC_COUNT);
> +		if (!count)
> +			continue; /* not break; we want to look at MORE flag */
> +		stride = MCDI_DWORD(outbuf, MAE_MPORT_READ_JOURNAL_OUT_SIZEOF_MPORT_DESC);
> +		if (stride < MAE_MPORT_DESC_LEN) {
> +			rc = -EIO;
> +			goto fail;
> +		}
> +		if (outlen < MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_LEN(count * stride)) {
> +			rc = -EIO;
> +			goto fail;
> +		}
> +
> +		for (i = 0; i < count; i++) {
> +			struct mae_mport_desc *d;
> +
> +			d = kzalloc(sizeof(*d), GFP_KERNEL);
> +			if (!d) {
> +				rc = -ENOMEM;
> +				goto fail;
> +			}
> +
> +			desc = (efx_dword_t *)
> +				_MCDI_PTR(outbuf, MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_MPORT_DESC_DATA_OFST +
> +					  i * stride);
> +			d->mport_id = MCDI_STRUCT_DWORD(desc, MAE_MPORT_DESC_MPORT_ID);
> +			d->flags = MCDI_STRUCT_DWORD(desc, MAE_MPORT_DESC_FLAGS);
> +			d->caller_flags = MCDI_STRUCT_DWORD(desc,
> +							    MAE_MPORT_DESC_CALLER_FLAGS);
> +			d->mport_type = MCDI_STRUCT_DWORD(desc,
> +							  MAE_MPORT_DESC_MPORT_TYPE);
> +			switch (d->mport_type) {
> +			case MAE_MPORT_DESC_MPORT_TYPE_NET_PORT:
> +				d->port_idx = MCDI_STRUCT_DWORD(desc,
> +								MAE_MPORT_DESC_NET_PORT_IDX);
> +				break;
> +			case MAE_MPORT_DESC_MPORT_TYPE_ALIAS:
> +				d->alias_mport_id = MCDI_STRUCT_DWORD(desc,
> +								      MAE_MPORT_DESC_ALIAS_DELIVER_MPORT_ID);
> +				break;
> +			case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
> +				d->vnic_client_type = MCDI_STRUCT_DWORD(desc,
> +									MAE_MPORT_DESC_VNIC_CLIENT_TYPE);
> +				d->interface_idx = MCDI_STRUCT_DWORD(desc,
> +								     MAE_MPORT_DESC_VNIC_FUNCTION_INTERFACE);
> +				d->pf_idx = MCDI_STRUCT_WORD(desc,
> +							     MAE_MPORT_DESC_VNIC_FUNCTION_PF_IDX);
> +			d->vf_idx = MCDI_STRUCT_WORD(desc,
> +						     MAE_MPORT_DESC_VNIC_FUNCTION_VF_IDX);
> +				break;
> +			default:
> +				/* Unknown mport_type, just accept it */
> +				break;
> +			}
> +			rc = efx_mae_process_mport(efx, d);
> +			/* Any failure will be due to memory allocation faiure,
> +			 * so there is no point to try subsequent entries.
> +			 */
> +			if (rc)
> +				goto fail;
> +		}
> +	} while (MCDI_FIELD(outbuf, MAE_MPORT_READ_JOURNAL_OUT, MORE) &&
> +		 !WARN_ON(!count));
> +fail:
> +	kfree(outbuf);
> +	return rc;
> +}
> +
>  int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
>  {
>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_ALLOC_OUT_LEN);
> @@ -805,3 +965,34 @@ int efx_mae_delete_rule(struct efx_nic *efx, u32 id)
>  		return -EIO;
>  	return 0;
>  }
> +
> +int efx_init_mae(struct efx_nic *efx)
> +{
> +	struct ef100_nic_data *nic_data = efx->nic_data;
> +	struct efx_mae *mae;
> +	int rc;
> +
> +	if (!nic_data->have_mport)
> +		return -EINVAL;
> +
> +	mae = kmalloc(sizeof(*mae), GFP_KERNEL);
> +	if (!mae)
> +		return -ENOMEM;
> +
> +	rc = rhashtable_init(&mae->mports_ht, &efx_mae_mports_ht_params);
> +	if (rc < 0) {
> +		kfree(mae);
> +		return rc;
> +	}
> +	efx->mae = mae;
> +	mae->efx = efx;
> +	return 0;
> +}
> +
> +void efx_fini_mae(struct efx_nic *efx)
> +{
> +	struct efx_mae *mae = efx->mae;
> +
> +	kfree(mae);
> +	efx->mae = NULL;
> +}
> diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
> index 72343e90e222..daa29d2cde96 100644
> --- a/drivers/net/ethernet/sfc/mae.h
> +++ b/drivers/net/ethernet/sfc/mae.h
> @@ -27,6 +27,39 @@ void efx_mae_mport_mport(struct efx_nic *efx, u32 mport_id, u32 *out);
>  
>  int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
>  
> +struct mae_mport_desc {
> +	u32 mport_id;
> +	u32 flags;
> +	u32 caller_flags; /* enum mae_mport_desc_caller_flags */
> +	u32 mport_type; /* MAE_MPORT_DESC_MPORT_TYPE_* */
> +	union {
> +		u32 port_idx; /* for mport_type == NET_PORT */
> +		u32 alias_mport_id; /* for mport_type == ALIAS */
> +		struct { /* for mport_type == VNIC */
> +			u32 vnic_client_type; /* MAE_MPORT_DESC_VNIC_CLIENT_TYPE_* */
> +			u32 interface_idx;
> +			u16 pf_idx;
> +			u16 vf_idx;
> +		};
> +	};
> +	struct rhash_head linkage;
> +};
> +
> +int efx_mae_enumerate_mports(struct efx_nic *efx);
> +struct mae_mport_desc *efx_mae_get_mport(struct efx_nic *efx, u32 mport_id);
> +void efx_mae_put_mport(struct efx_nic *efx, struct mae_mport_desc *desc);
> +
> +/**
> + * struct efx_mae - MAE information
> + *
> + * @efx: The associated NIC
> + * @mports_ht: m-port descriptions from MC_CMD_MAE_MPORT_READ_JOURNAL
> + */
> +struct efx_mae {
> +	struct efx_nic *efx;
> +	struct rhashtable mports_ht;
> +};
> +
>  int efx_mae_start_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue);
>  int efx_mae_stop_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue);
>  void efx_mae_counters_grant_credits(struct work_struct *work);
> @@ -60,4 +93,7 @@ int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
>  			u32 prio, u32 acts_id, u32 *id);
>  int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
>  
> +int efx_init_mae(struct efx_nic *efx);
> +void efx_fini_mae(struct efx_nic *efx);
> +void efx_mae_remove_mport(void *desc, void *arg);
>  #endif /* EF100_MAE_H */
> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
> index 32f54ce2492e..d280ad8f7836 100644
> --- a/drivers/net/ethernet/sfc/mcdi.h
> +++ b/drivers/net/ethernet/sfc/mcdi.h
> @@ -229,6 +229,9 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
>  #define MCDI_WORD(_buf, _field)						\
>  	((u16)BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 2) +	\
>  	 le16_to_cpu(*(__force const __le16 *)MCDI_PTR(_buf, _field)))
> +#define MCDI_STRUCT_WORD(_buf, _field)                                  \
> +	((void)BUILD_BUG_ON_ZERO(_field ## _LEN != 2),  \
> +	le16_to_cpu(*(__force const __le16 *)MCDI_STRUCT_PTR(_buf, _field)))
>  /* Write a 16-bit field defined in the protocol as being big-endian. */
>  #define MCDI_STRUCT_SET_WORD_BE(_buf, _field, _value) do {		\
>  	BUILD_BUG_ON(_field ## _LEN != 2);				\
> @@ -241,6 +244,8 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
>  	EFX_POPULATE_DWORD_1(*_MCDI_STRUCT_DWORD(_buf, _field), EFX_DWORD_0, _value)
>  #define MCDI_DWORD(_buf, _field)					\
>  	EFX_DWORD_FIELD(*_MCDI_DWORD(_buf, _field), EFX_DWORD_0)
> +#define MCDI_STRUCT_DWORD(_buf, _field)                                 \
> +	EFX_DWORD_FIELD(*_MCDI_STRUCT_DWORD(_buf, _field), EFX_DWORD_0)
>  /* Write a 32-bit field defined in the protocol as being big-endian. */
>  #define MCDI_STRUCT_SET_DWORD_BE(_buf, _field, _value) do {		\
>  	BUILD_BUG_ON(_field ## _LEN != 4);				\
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index d036641dc043..bc9efbfb3d6b 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -845,6 +845,8 @@ enum efx_xdp_tx_queues_mode {
>  	EFX_XDP_TX_QUEUES_BORROWED	/* queues borrowed from net stack */
>  };
>  
> +struct efx_mae;
> +
>  /**
>   * struct efx_nic - an Efx NIC
>   * @name: Device name (net device name or bus id before net device registered)
> @@ -881,6 +883,7 @@ enum efx_xdp_tx_queues_mode {
>   * @msi_context: Context for each MSI
>   * @extra_channel_types: Types of extra (non-traffic) channels that
>   *	should be allocated for this NIC
> + * @mae: Details of the Match Action Engine
>   * @xdp_tx_queue_count: Number of entries in %xdp_tx_queues.
>   * @xdp_tx_queues: Array of pointers to tx queues used for XDP transmit.
>   * @xdp_txq_queues_mode: XDP TX queues sharing strategy.
> @@ -1044,6 +1047,7 @@ struct efx_nic {
>  	struct efx_msi_context msi_context[EFX_MAX_CHANNELS];
>  	const struct efx_channel_type *
>  	extra_channel_type[EFX_MAX_EXTRA_CHANNELS];
> +	struct efx_mae *mae;
>  
>  	unsigned int xdp_tx_queue_count;
>  	struct efx_tx_queue **xdp_tx_queues;
> -- 
> 2.17.1
