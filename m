Return-Path: <netdev+bounces-6280-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF647157E1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E644E281093
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22EFD12B6A;
	Tue, 30 May 2023 08:03:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C0112B69
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:03:51 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B320A0
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:03:48 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-96f5685f902so620260366b.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685433826; x=1688025826;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZDQmGnPHv6ezG6Cu/Wi0dPCoccGEHfllbGUk1GgH9HA=;
        b=ImMG1/lY1XvtpJW0NTPOkO6k8l5jXdKQqXpaFxUg9Yhq3m0AoyalzrCIvxhg1/l+Zb
         jBdVOFxMnYnEohnrbDf4B4nc66R7kmN3xBTU9g9L671J8tUcD2M4u+VR7UefqWxlcsPE
         d8ukJOOqGQRHlzqlYVYEVCovvsgjT0YOcdm0MU0GsrXLe1LByuLHpwEcYL1iXZPxuXcW
         efqZxHl0NSB1/lFbR9sU/MWa7/8qrJs3thExtthPLUoJH20PEOq4Ey7+QGUdWhmYAV42
         m2Ge9jP4XI3o7iejnFvc/6+zR4vkPk8khiSviD9pkp9aDTfTqfJLbdkjQESIormgIHf3
         FsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685433826; x=1688025826;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDQmGnPHv6ezG6Cu/Wi0dPCoccGEHfllbGUk1GgH9HA=;
        b=Fh7NO1tYoK4IVUJT5EzQYMhQoWrHrJO064QM+6vMtGEjIMlKMFp/HRrN+Tw6OsnrMw
         MyGanUgA93Ay+4kiE+Xh5pgwGY0+5WPWHAjdE0ahvjBNtz3HSVohjMRSh1MR6QnplGIn
         OME0so+0fiv0DRaVHj8U8FVaXqZVdMIB45/ToTsdXvgpGHFNy8NcY9EYZOtKJPRq+zxL
         N1PxnrM8dcu54UZ3omy82FlA6hh2ob7ao7LKwom3RckyLTUX+ra+++GNmE5xfkarEyKw
         xorA/+SsAlaoB7tML3ZCRBFL3LSTgF3XFnBusuCkv6RjoXc8qHq19y36QRp5JA+uZVz0
         STNA==
X-Gm-Message-State: AC+VfDzVF7H/Jhdd0nXbNmx5afNyLr9Di+FlbrQDALUSIJa16ccsmvBe
	H/1ME7M7yFoYPIfAocT4Gic=
X-Google-Smtp-Source: ACHHUZ4ymKHyoQbnzAwqN2KhlKKZuWrezfdl5p5tZ+nycUJz7u6bQBaM2/BLWLpGVOWEgiJo/0WIGA==
X-Received: by 2002:a17:907:80c:b0:96f:e5af:ac5f with SMTP id wv12-20020a170907080c00b0096fe5afac5fmr1588657ejb.47.1685433826457;
        Tue, 30 May 2023 01:03:46 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id z2-20020a170906074200b0096f4c9ce526sm6992756ejb.225.2023.05.30.01.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 01:03:46 -0700 (PDT)
Date: Tue, 30 May 2023 09:03:43 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, leon@kernel.org,
	saeedm@nvidia.com, moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 10/15] devlink: move
 port_fn_hw_addr_get/set() to devlink_port_ops
Message-ID: <ZHWt357tA3QIN3CU@gmail.com>
Mail-Followup-To: Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	michal.wilczynski@intel.com, jacob.e.keller@intel.com
References: <20230526102841.2226553-1-jiri@resnulli.us>
 <20230526102841.2226553-11-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526102841.2226553-11-jiri@resnulli.us>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 12:28:36PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Move port_fn_hw_addr_get/set() from devlink_ops into newly introduced
> devlink_port_ops.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

For sfc:
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
> v1->v2:
> - avoid ops check as they no longer could be null
> ---
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |  2 -
>  .../mellanox/mlx5/core/esw/devlink_port.c     |  4 +
>  .../net/ethernet/mellanox/mlx5/core/eswitch.h | 12 +--
>  .../mellanox/mlx5/core/eswitch_offloads.c     | 12 +--
>  drivers/net/ethernet/sfc/efx_devlink.c        | 86 +++++++++----------
>  include/net/devlink.h                         | 38 ++++----
>  net/devlink/leftover.c                        | 15 ++--
>  7 files changed, 80 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> index bfaec67abf0d..1e96f32bd1b5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -310,8 +310,6 @@ static const struct devlink_ops mlx5_devlink_ops = {
>  	.eswitch_inline_mode_get = mlx5_devlink_eswitch_inline_mode_get,
>  	.eswitch_encap_mode_set = mlx5_devlink_eswitch_encap_mode_set,
>  	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
> -	.port_function_hw_addr_get = mlx5_devlink_port_function_hw_addr_get,
> -	.port_function_hw_addr_set = mlx5_devlink_port_function_hw_addr_set,
>  	.rate_leaf_tx_share_set = mlx5_esw_devlink_rate_leaf_tx_share_set,
>  	.rate_leaf_tx_max_set = mlx5_esw_devlink_rate_leaf_tx_max_set,
>  	.rate_node_tx_share_set = mlx5_esw_devlink_rate_node_tx_share_set,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> index d9c17481b972..78d12c377900 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
> @@ -66,6 +66,8 @@ static void mlx5_esw_dl_port_free(struct devlink_port *dl_port)
>  }
>  
>  static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
> +	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
> +	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>  };
>  
>  int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_num)
> @@ -139,6 +141,8 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
>  }
>  
>  static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
> +	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
> +	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>  };
>  
>  int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> index 280dc71b032c..f70124ad71cf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> @@ -506,12 +506,12 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
>  					struct netlink_ext_ack *extack);
>  int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
>  					enum devlink_eswitch_encap_mode *encap);
> -int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
> -					   u8 *hw_addr, int *hw_addr_len,
> -					   struct netlink_ext_ack *extack);
> -int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
> -					   const u8 *hw_addr, int hw_addr_len,
> -					   struct netlink_ext_ack *extack);
> +int mlx5_devlink_port_fn_hw_addr_get(struct devlink_port *port,
> +				     u8 *hw_addr, int *hw_addr_len,
> +				     struct netlink_ext_ack *extack);
> +int mlx5_devlink_port_fn_hw_addr_set(struct devlink_port *port,
> +				     const u8 *hw_addr, int hw_addr_len,
> +				     struct netlink_ext_ack *extack);
>  int mlx5_devlink_port_fn_roce_get(struct devlink_port *port, bool *is_enabled,
>  				  struct netlink_ext_ack *extack);
>  int mlx5_devlink_port_fn_roce_set(struct devlink_port *port, bool enable,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 7a65dcf01dba..1b2f5e273525 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -3957,9 +3957,9 @@ is_port_function_supported(struct mlx5_eswitch *esw, u16 vport_num)
>  	       mlx5_esw_is_sf_vport(esw, vport_num);
>  }
>  
> -int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
> -					   u8 *hw_addr, int *hw_addr_len,
> -					   struct netlink_ext_ack *extack)
> +int mlx5_devlink_port_fn_hw_addr_get(struct devlink_port *port,
> +				     u8 *hw_addr, int *hw_addr_len,
> +				     struct netlink_ext_ack *extack)
>  {
>  	struct mlx5_eswitch *esw;
>  	struct mlx5_vport *vport;
> @@ -3986,9 +3986,9 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
>  	return 0;
>  }
>  
> -int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
> -					   const u8 *hw_addr, int hw_addr_len,
> -					   struct netlink_ext_ack *extack)
> +int mlx5_devlink_port_fn_hw_addr_set(struct devlink_port *port,
> +				     const u8 *hw_addr, int hw_addr_len,
> +				     struct netlink_ext_ack *extack)
>  {
>  	struct mlx5_eswitch *esw;
>  	u16 vport_num;
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index e74f74037405..b82dad50a5b1 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -26,46 +26,6 @@ struct efx_devlink {
>  
>  #ifdef CONFIG_SFC_SRIOV
>  
> -static const struct devlink_port_ops sfc_devlink_port_ops = {
> -};
> -
> -static void efx_devlink_del_port(struct devlink_port *dl_port)
> -{
> -	if (!dl_port)
> -		return;
> -	devl_port_unregister(dl_port);
> -}
> -
> -static int efx_devlink_add_port(struct efx_nic *efx,
> -				struct mae_mport_desc *mport)
> -{
> -	bool external = false;
> -
> -	if (!ef100_mport_on_local_intf(efx, mport))
> -		external = true;
> -
> -	switch (mport->mport_type) {
> -	case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
> -		if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL)
> -			devlink_port_attrs_pci_vf_set(&mport->dl_port, 0, mport->pf_idx,
> -						      mport->vf_idx,
> -						      external);
> -		else
> -			devlink_port_attrs_pci_pf_set(&mport->dl_port, 0, mport->pf_idx,
> -						      external);
> -		break;
> -	default:
> -		/* MAE_MPORT_DESC_MPORT_ALIAS and UNDEFINED */
> -		return 0;
> -	}
> -
> -	mport->dl_port.index = mport->mport_id;
> -
> -	return devl_port_register_with_ops(efx->devlink, &mport->dl_port,
> -					   mport->mport_id,
> -					   &sfc_devlink_port_ops);
> -}
> -
>  static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
>  				     int *hw_addr_len,
>  				     struct netlink_ext_ack *extack)
> @@ -164,6 +124,48 @@ static int efx_devlink_port_addr_set(struct devlink_port *port,
>  	return rc;
>  }
>  
> +static const struct devlink_port_ops sfc_devlink_port_ops = {
> +	.port_fn_hw_addr_get = efx_devlink_port_addr_get,
> +	.port_fn_hw_addr_set = efx_devlink_port_addr_set,
> +};
> +
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
> +	return devl_port_register_with_ops(efx->devlink, &mport->dl_port,
> +					   mport->mport_id,
> +					   &sfc_devlink_port_ops);
> +}
> +
>  #endif
>  
>  static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
> @@ -615,10 +617,6 @@ static int efx_devlink_info_get(struct devlink *devlink,
>  
>  static const struct devlink_ops sfc_devlink_ops = {
>  	.info_get			= efx_devlink_info_get,
> -#ifdef CONFIG_SFC_SRIOV
> -	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
> -	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
> -#endif
>  };
>  
>  #ifdef CONFIG_SFC_SRIOV
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 6fd1697d0443..984829e9239e 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1429,28 +1429,6 @@ struct devlink_ops {
>  	int (*trap_policer_counter_get)(struct devlink *devlink,
>  					const struct devlink_trap_policer *policer,
>  					u64 *p_drops);
> -	/**
> -	 * @port_function_hw_addr_get: Port function's hardware address get function.
> -	 *
> -	 * Should be used by device drivers to report the hardware address of a function managed
> -	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't support port
> -	 * function handling for a particular port.
> -	 *
> -	 * Note: @extack can be NULL when port notifier queries the port function.
> -	 */
> -	int (*port_function_hw_addr_get)(struct devlink_port *port, u8 *hw_addr,
> -					 int *hw_addr_len,
> -					 struct netlink_ext_ack *extack);
> -	/**
> -	 * @port_function_hw_addr_set: Port function's hardware address set function.
> -	 *
> -	 * Should be used by device drivers to set the hardware address of a function managed
> -	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't support port
> -	 * function handling for a particular port.
> -	 */
> -	int (*port_function_hw_addr_set)(struct devlink_port *port,
> -					 const u8 *hw_addr, int hw_addr_len,
> -					 struct netlink_ext_ack *extack);
>  	/**
>  	 * @port_fn_roce_get: Port function's roce get function.
>  	 *
> @@ -1651,6 +1629,16 @@ void devlink_free(struct devlink *devlink);
>   * @port_unsplit: Callback used to unsplit the port group back into
>   *		  a single port.
>   * @port_type_set: Callback used to set a type of a port.
> + * @port_fn_hw_addr_get: Callback used to set port function's hardware address.
> + *			 Should be used by device drivers to report
> + *			 the hardware address of a function managed
> + *			 by the devlink port.
> + * @port_fn_hw_addr_set: Callback used to set port function's hardware address.
> + *			 Should be used by device drivers to set the hardware
> + *			 address of a function managed by the devlink port.
> + *
> + * Note: Driver should return -EOPNOTSUPP if it doesn't support
> + * port function (@port_fn_*) handling for a particular port.
>   */
>  struct devlink_port_ops {
>  	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
> @@ -1659,6 +1647,12 @@ struct devlink_port_ops {
>  			    struct netlink_ext_ack *extack);
>  	int (*port_type_set)(struct devlink_port *devlink_port,
>  			     enum devlink_port_type port_type);
> +	int (*port_fn_hw_addr_get)(struct devlink_port *port, u8 *hw_addr,
> +				   int *hw_addr_len,
> +				   struct netlink_ext_ack *extack);
> +	int (*port_fn_hw_addr_set)(struct devlink_port *port,
> +				   const u8 *hw_addr, int hw_addr_len,
> +				   struct netlink_ext_ack *extack);
>  };
>  
>  void devlink_port_init(struct devlink *devlink,
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index 7fbcd58fb21e..861d9c2a80aa 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -691,8 +691,7 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
>  	return 0;
>  }
>  
> -static int devlink_port_fn_hw_addr_fill(const struct devlink_ops *ops,
> -					struct devlink_port *port,
> +static int devlink_port_fn_hw_addr_fill(struct devlink_port *port,
>  					struct sk_buff *msg,
>  					struct netlink_ext_ack *extack,
>  					bool *msg_updated)
> @@ -701,10 +700,10 @@ static int devlink_port_fn_hw_addr_fill(const struct devlink_ops *ops,
>  	int hw_addr_len;
>  	int err;
>  
> -	if (!ops->port_function_hw_addr_get)
> +	if (!port->ops->port_fn_hw_addr_get)
>  		return 0;
>  
> -	err = ops->port_function_hw_addr_get(port, hw_addr, &hw_addr_len,
> +	err = port->ops->port_fn_hw_addr_get(port, hw_addr, &hw_addr_len,
>  					     extack);
>  	if (err) {
>  		if (err == -EOPNOTSUPP)
> @@ -884,8 +883,7 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
>  		return -EMSGSIZE;
>  
>  	ops = port->devlink->ops;
> -	err = devlink_port_fn_hw_addr_fill(ops, port, msg, extack,
> -					   &msg_updated);
> +	err = devlink_port_fn_hw_addr_fill(port, msg, extack, &msg_updated);
>  	if (err)
>  		goto out;
>  	err = devlink_port_fn_caps_fill(ops, port, msg, extack,
> @@ -1156,7 +1154,6 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
>  					     const struct nlattr *attr,
>  					     struct netlink_ext_ack *extack)
>  {
> -	const struct devlink_ops *ops = port->devlink->ops;
>  	const u8 *hw_addr;
>  	int hw_addr_len;
>  
> @@ -1177,7 +1174,7 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
>  		}
>  	}
>  
> -	return ops->port_function_hw_addr_set(port, hw_addr, hw_addr_len,
> +	return port->ops->port_fn_hw_addr_set(port, hw_addr, hw_addr_len,
>  					      extack);
>  }
>  
> @@ -1201,7 +1198,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
>  	struct nlattr *attr;
>  
>  	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
> -	    !ops->port_function_hw_addr_set) {
> +	    !devlink_port->ops->port_fn_hw_addr_set) {
>  		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
>  				    "Port doesn't support function attributes");
>  		return -EOPNOTSUPP;
> -- 
> 2.39.2

