Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4B067E4B9
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbjA0MKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbjA0MKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:10:31 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C747F31E
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:04:31 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vw16so13022572ejc.12
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUM6nYF9FordTnvLTtKa8NxQwQUkHdUrnzh+9xn+FRY=;
        b=IiwuWsAlQPQnsaQxV5CxQ10ZG/qL8Ys99tdj6iXA1C4ztoi3wR1uYeTsXqszSVE2wr
         3VV/u8TnyO9PxFSzrDvnumHcialf7zR47ZwKVhgr8uGvye4joNaSQjDBReSkD7PtTU/C
         lFXLmYBws5OKnA4y3A2n+Zalbe3CjGDRcXFiUUVsOYxa1jQj3yVA0eeFqZmuTc//wLRw
         KNc0BaitkD1jItaci+RF3gNhDpKFzs2VWifmCsgWXVAyxdwcXKJnyFnEPJ+TQZZeu69U
         DQ2QibG/x7Rco2chdQNQ9p40I1KnCrU53O+kqlq311PvH/L0m3OUVFOlts8m5WQcSpA6
         afxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUM6nYF9FordTnvLTtKa8NxQwQUkHdUrnzh+9xn+FRY=;
        b=5+BQKQF0fhg0hMOToUDPQXDXASzw+F4VOLdwDNLaYa2axiAqupyvzfsig6TeYEvU1r
         ALydhGHGDf+QRnDvjCe92KwLtJSTlvPKZhXRc6oBAr5OmaDQPYLP7jKD9IvlWSAoipLq
         gTGAlFAc8SAkyjjbn7nLHIOCU6/U0W6G45xgIIJNxD56BcirIEFlFyb3a00kNLZ4Y51h
         y8k5tgbtp52A1HZgeY4nVG1y1XufSrkAR9OexLy97X0QjPZXd9vwIJbQ7CzBOeh9vwko
         lNN+K7HUpu3MQ0o89JvMuTfqklM9dpi+aFJtfuRkD9C0ERGOqPMgAsUHQDmD0sGfGXg+
         hvIg==
X-Gm-Message-State: AFqh2koHolblIJYCjPNFnHRSUdTPzGlDm9jTjaajGg63bAvGiN+F6lRn
        jXJPNrwnbvmtj4ogPva05pNLIk8Mjag=
X-Google-Smtp-Source: AK7set9GQRFfSPvhUqI4c/mQz7Qx3HhWHfi9fFeiDM8o7GLlnoVZTiEpnUyifeMDmR6tICkOtCiOrA==
X-Received: by 2002:adf:b346:0:b0:2bf:b5e4:cd63 with SMTP id k6-20020adfb346000000b002bfb5e4cd63mr9653396wrd.8.1674820287458;
        Fri, 27 Jan 2023 03:51:27 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id q3-20020adff503000000b002bfae1398bbsm3828857wro.42.2023.01.27.03.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 03:51:26 -0800 (PST)
Date:   Fri, 27 Jan 2023 11:51:24 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH v3 net-next 7/8] sfc: add support for devlink
 port_function_hw_addr_get in ef100
Message-ID: <Y9O6vChVqWKFjgC8@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com
References: <20230127093651.54035-1-alejandro.lucero-palau@amd.com>
 <20230127093651.54035-8-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127093651.54035-8-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 09:36:50AM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Using the builtin client handle id infrastructure, this patch adds
> support for obtaining the mac address linked to mports in ef100. This
> implies to execute an MCDI command for getting the data from the
> firmware for each devlink port.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_nic.c   | 27 ++++++++++++++++
>  drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
>  drivers/net/ethernet/sfc/ef100_rep.c   |  8 +++++
>  drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
>  drivers/net/ethernet/sfc/efx_devlink.c | 44 ++++++++++++++++++++++++++
>  5 files changed, 81 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index bcf937fb3d95..e64a7fb5353b 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -1121,6 +1121,33 @@ static int ef100_probe_main(struct efx_nic *efx)
>  	return rc;
>  }
>  
> +/* MCDI commands are related to the same device issuing them. This function
> + * allows to do an MCDI command on behalf of another device, mainly PFs setting
> + * things for VFs.
> + */
> +int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id)
> +{
> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CLIENT_HANDLE_OUT_LEN);
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_CLIENT_HANDLE_IN_LEN);
> +	u64 pciefn_flat = le64_to_cpu(pciefn.u64[0]);
> +	size_t outlen;
> +	int rc;
> +
> +	MCDI_SET_DWORD(inbuf, GET_CLIENT_HANDLE_IN_TYPE,
> +		       MC_CMD_GET_CLIENT_HANDLE_IN_TYPE_FUNC);
> +	MCDI_SET_QWORD(inbuf, GET_CLIENT_HANDLE_IN_FUNC,
> +		       pciefn_flat);
> +
> +	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CLIENT_HANDLE, inbuf, sizeof(inbuf),
> +			  outbuf, sizeof(outbuf), &outlen);
> +	if (rc)
> +		return rc;
> +	if (outlen < sizeof(outbuf))
> +		return -EIO;
> +	*id = MCDI_DWORD(outbuf, GET_CLIENT_HANDLE_OUT_HANDLE);
> +	return 0;
> +}
> +
>  int ef100_probe_netdev_pf(struct efx_nic *efx)
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
> index e59044072333..f1ed481c1260 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.h
> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
> @@ -94,4 +94,5 @@ int ef100_filter_table_probe(struct efx_nic *efx);
>  
>  int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
>  			  int client_handle, bool empty_ok);
> +int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
>  #endif	/* EFX_EF100_NIC_H */
> diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
> index 6b5bc5d6955d..0b3083ef0ead 100644
> --- a/drivers/net/ethernet/sfc/ef100_rep.c
> +++ b/drivers/net/ethernet/sfc/ef100_rep.c
> @@ -361,6 +361,14 @@ bool ef100_mport_on_local_intf(struct efx_nic *efx,
>  		     mport_desc->interface_idx == nic_data->local_mae_intf;
>  }
>  
> +bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc)
> +{
> +	bool pcie_func;
> +
> +	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
> +	return pcie_func && (mport_desc->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL);
> +}
> +
>  void efx_ef100_init_reps(struct efx_nic *efx)
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
> diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
> index ae6add4b0855..a042525a2240 100644
> --- a/drivers/net/ethernet/sfc/ef100_rep.h
> +++ b/drivers/net/ethernet/sfc/ef100_rep.h
> @@ -76,4 +76,5 @@ void efx_ef100_fini_reps(struct efx_nic *efx);
>  struct mae_mport_desc;
>  bool ef100_mport_on_local_intf(struct efx_nic *efx,
>  			       struct mae_mport_desc *mport_desc);
> +bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc);
>  #endif /* EF100_REP_H */
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index b1637eb372ad..2c84e89bd007 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -58,6 +58,49 @@ static int efx_devlink_add_port(struct efx_nic *efx,
>  	return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
>  }
>  
> +static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
> +				     int *hw_addr_len,
> +				     struct netlink_ext_ack *extack)
> +{
> +	struct efx_devlink *devlink = devlink_priv(port->devlink);
> +	struct mae_mport_desc *mport_desc;
> +	efx_qword_t pciefn;
> +	u32 client_id;
> +	int rc = 0;
> +
> +	mport_desc = container_of(port, struct mae_mport_desc, dl_port);
> +
> +	if (!ef100_mport_on_local_intf(devlink->efx, mport_desc)) {
> +		rc = -EINVAL;
> +		NL_SET_ERR_MSG_MOD(extack, "Port not on local interface");

Since we're giving this addional info we should at least provide the
mport_id to help us diagnose the issue.

> +		goto out;
> +	}
> +
> +	if (ef100_mport_is_vf(mport_desc))
> +		EFX_POPULATE_QWORD_3(pciefn,
> +				     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
> +				     PCIE_FUNCTION_VF, mport_desc->vf_idx,
> +				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
> +	else
> +		EFX_POPULATE_QWORD_3(pciefn,
> +				     PCIE_FUNCTION_PF, mport_desc->pf_idx,
> +				     PCIE_FUNCTION_VF, PCIE_FUNCTION_VF_NULL,
> +				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
> +
> +	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
> +	if (rc) {
> +		NL_SET_ERR_MSG_MOD(extack, "No internal client_ID for port");
> +		goto out;
> +	}
> +
> +	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
> +	if (rc != 0)
> +		NL_SET_ERR_MSG_MOD(extack, "No available MAC for port");

Same.

Martin

> +out:
> +	*hw_addr_len = ETH_ALEN;
> +	return rc;
> +}
> +
>  static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>  					    struct devlink_info_req *req,
>  					    unsigned int partition_type,
> @@ -463,6 +506,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
>  
>  static const struct devlink_ops sfc_devlink_ops = {
>  	.info_get			= efx_devlink_info_get,
> +	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
>  };
>  
>  static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
> -- 
> 2.17.1
