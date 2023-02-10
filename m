Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D87691A5C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjBJIwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjBJIw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:52:29 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2057F303C8;
        Fri, 10 Feb 2023 00:52:28 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id j25so4308250wrc.4;
        Fri, 10 Feb 2023 00:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBqLAVLRqn/imq0G1uCnOI/C4B9HuMfMv6Jp1izYp9o=;
        b=D3T4/65jb9YnZqBgdxBLnkHeszwIsRHCKY/8U230fZsOQ8lVRmBjM4WHhw/3p42ES5
         pV7ze0IvtON4rZ6v9OJFbWF8paRQcsCOfdnt84prLAE2N3CDag38uSHwyEZXiSU51IdV
         RcgbchMJ2mImiYP0NogJeJB8ayXgVpqEmMQBBezlxcTKvaWIWtnDKB2fSuJoMYfCkYPv
         BFiUKMBq+B2ZPR0raKtToXsCJ2gPdY+sFlPe2MVJ8GyHWamacdW+OFx/6z/dgx3PeNQW
         nkwtVq5SZgD0m6GmvcWD002wkjJG2scqMLXX5UMy9HIWuY1/q7gcvczPayn+BuRGbslH
         wlPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pBqLAVLRqn/imq0G1uCnOI/C4B9HuMfMv6Jp1izYp9o=;
        b=PxhdpNLXxe0VzpJsx/gkzIb77vLNCmSkaBDGnLcOrfmSwRg2TGzwtoU164aNw3h8/u
         QaP29N/ILyEWaxGfb9YbdLmQMAEouZ7pEmu+yn5T7Zr+x3t4l8mneDcT8uxP5KlDZguw
         2KXkJVLGlA6AMYALU9HsxXsdeHUVKBKelm2QCGWrybyHDCzTzzjErDLDY6/E0OYo+td3
         1YAlOCUADh/tzj5UEAi4sOCzSCQW8OEYomM50ZpyNno37/XTd6RgKhYC9uTLzD7DRIUu
         2Ii5u4rffYNPGja3mV3ehbqXzPnTOlEBg8Ck4oZya5XjgmTuD4q3b0PVT4DP7yfGtpCl
         3Trg==
X-Gm-Message-State: AO0yUKUPyKnL2XzaSuPv68/RFnZELDfSQsikWm0J6QmtAhCh866Nsygy
        /d57R7U1naeoyjYd+0oR5Bc=
X-Google-Smtp-Source: AK7set+cSNjBrFD7wH3ilEZpnhhPhkHbBwPiBToegZyShH2LPfujjEOdcLaj8uL3kOIyjS454X4YqQ==
X-Received: by 2002:a5d:6912:0:b0:2bf:f5fe:3135 with SMTP id t18-20020a5d6912000000b002bff5fe3135mr4552917wru.8.1676019146759;
        Fri, 10 Feb 2023 00:52:26 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id x15-20020adfec0f000000b002be5401ef5fsm3155092wrn.39.2023.02.10.00.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:52:26 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:52:24 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
Subject: Re: [PATCH v6 net-next 7/8] sfc: add support for devlink
 port_function_hw_addr_get in ef100
Message-ID: <Y+YFyI+FFQ3DDd6D@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-8-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208142519.31192-8-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:25:18PM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Using the builtin client handle id infrastructure, add support for
> obtaining the mac address linked to mports in ef100. This implies
> to execute an MCDI command for getting the data from the firmware
> for each devlink port.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/ef100_nic.c   | 27 +++++++++++++++
>  drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
>  drivers/net/ethernet/sfc/ef100_rep.c   |  8 +++++
>  drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
>  drivers/net/ethernet/sfc/efx_devlink.c | 46 ++++++++++++++++++++++++++
>  5 files changed, 83 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index aa48c79a2149..becd21c2325d 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -1122,6 +1122,33 @@ static int ef100_probe_main(struct efx_nic *efx)
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
> index 1b1276716113..68d04c2176d3 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -11,6 +11,7 @@
>  #include "efx_devlink.h"
>  #ifdef CONFIG_SFC_SRIOV
>  #include <linux/rtc.h>
> +#include "ef100_nic.h"
>  #include "mcdi.h"
>  #include "mcdi_functions.h"
>  #include "mcdi_pcol.h"
> @@ -58,6 +59,50 @@ static int efx_devlink_add_port(struct efx_nic *efx,
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
> +	int rc;
> +
> +	mport_desc = container_of(port, struct mae_mport_desc, dl_port);
> +
> +	if (!ef100_mport_on_local_intf(devlink->efx, mport_desc)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Port not on local interface");
> +		return -EINVAL;
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
> +		return -EIO;
> +	}
> +
> +	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
> +	if (rc) {
> +		NL_SET_ERR_MSG_MOD(extack, "No MAC available");
> +		return -ENOENT;
> +	}
> +
> +	*hw_addr_len = ETH_ALEN;
> +	return rc;
> +}
> +
>  static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>  					    struct devlink_info_req *req,
>  					    unsigned int partition_type,
> @@ -511,6 +556,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
>  static const struct devlink_ops sfc_devlink_ops = {
>  #ifdef CONFIG_SFC_SRIOV
>  	.info_get			= efx_devlink_info_get,
> +	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
>  #endif
>  };
>  
> -- 
> 2.17.1
