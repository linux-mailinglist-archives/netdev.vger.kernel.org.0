Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02ABF6B108B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 19:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCHSBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 13:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjCHSBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 13:01:25 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CBBC6428;
        Wed,  8 Mar 2023 10:01:21 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p16so10323943wmq.5;
        Wed, 08 Mar 2023 10:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678298480;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xCXYyOVnsRK6qjjJH2JpdR1wPGIdSk7GM1vgJw4rXyo=;
        b=O7uLwe9Qv4hO7gERxXUmU30UH6oV/Bl/G6vMsdYboTVj2nzbpYXnHmR/Lgp+RDplp5
         XItMPr5/CjRMYA3uL31IcTwzpF2SHNJ29rKoLYfuRmTVWF/4Lb0+nP3EN6NUDkzIH4LE
         lofRNYC6cT2xDvc9oamUGP6Uvnk3n0YPZ350B6H11z2QdaIzzmrKYdKob5Ejz+bVCD7l
         eThdLtaugThtUfEok6i8rzfb1ZkQ3gqbAZxbe/aDeBMl2Pp92oLE3xGAPpBfjZst/nIY
         huqWxaloiX1EGLcmj1hLahDfXHt9cprYDjF5Sg/90NyHqPvDM34YqnWiGo1VC4tZLbGD
         cmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678298480;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xCXYyOVnsRK6qjjJH2JpdR1wPGIdSk7GM1vgJw4rXyo=;
        b=EZA3IWL4lyNr5P/SrtcKCmNsKzhSUX1AwAs0ap6GFvO8iA9Gcaf4h5hMqLB+E4QleN
         ySEUQHmVsseyKiOUPOqay0rzp7RQMqDJP93nu5f16lce3zgrp6EceqQUB7PMC1V2uXZW
         MaMQZF2ljxL/F11oMFPqbEFX+O1zo7KG2Sl57PNOdJBGjyd1Ii+HXfxPF9xgxEPl3sTE
         IPL5WD9YgrH8Rqr6BtIyYnq1HlpHLi1S2BC6TCY47Uko5bfC2sIpTioGnFdDaHkRaHkV
         a1VruwK3k7EhZ4kBa4jE8gST4r+s1ql3wD/Ci2x5ywhGyQSUBjgpn8uCKX4/65dC/sfo
         laIg==
X-Gm-Message-State: AO0yUKVvGACEhpfeYK9iaCdb4HpgPz1mJtcrV1oMd7KLiKgQSsR/OYdI
        aneBVeeUE9uYFgBmtB31O1Y=
X-Google-Smtp-Source: AK7set8pEE5d3DOulKS83ATbVd1lOVdw9nJrZYj5VGNloCZoRzCH2dMbkGMeReTg5H71XM4c8EpUzA==
X-Received: by 2002:a05:600c:468e:b0:3eb:29fe:f922 with SMTP id p14-20020a05600c468e00b003eb29fef922mr17243149wmo.29.1678298479713;
        Wed, 08 Mar 2023 10:01:19 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id l14-20020a05600c4f0e00b003de2fc8214esm175128wmq.20.2023.03.08.10.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 10:01:19 -0800 (PST)
Date:   Wed, 8 Mar 2023 18:01:17 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v2 11/14] sfc: use PF's IOMMU domain for running
 VF's MCDI commands
Message-ID: <ZAjNbSN38YY+vbwS@gmail.com>
Mail-Followup-To: Gautam Dawar <gautam.dawar@amd.com>,
        linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-12-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307113621.64153-12-gautam.dawar@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 05:06:13PM +0530, Gautam Dawar wrote:
> This changeset uses MC_CMD_CLIENT_CMD to execute VF's MCDI
> commands when running in vDPA mode (STATE_VDPA).
> Also, use the PF's IOMMU domain for executing the encapsulated
> VF's MCDI commands to isolate DMA of guest buffers in the VF's
> IOMMU domain.
> This patch also updates the PCIe FN's client id in the efx_nic
> structure which is required while running MC_CMD_CLIENT_CMD.
> 
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100.c      |   1 +
>  drivers/net/ethernet/sfc/ef100_nic.c  |  35 +++++++++
>  drivers/net/ethernet/sfc/mcdi.c       | 108 ++++++++++++++++++++++----
>  drivers/net/ethernet/sfc/mcdi.h       |   2 +-
>  drivers/net/ethernet/sfc/net_driver.h |   2 +
>  drivers/net/ethernet/sfc/ptp.c        |   4 +-
>  6 files changed, 132 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
> index c1c69783db7b..8453c9ba0f41 100644
> --- a/drivers/net/ethernet/sfc/ef100.c
> +++ b/drivers/net/ethernet/sfc/ef100.c
> @@ -465,6 +465,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
>  	efx->type = (const struct efx_nic_type *)entry->driver_data;
>  
>  	efx->pci_dev = pci_dev;
> +	efx->client_id = MC_CMD_CLIENT_ID_SELF;
>  	pci_set_drvdata(pci_dev, efx);
>  	rc = efx_init_struct(efx, pci_dev);
>  	if (rc)
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index bda4fcbe1126..cd9f724a9e64 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -206,9 +206,11 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>  		  "firmware reports num_mac_stats = %u\n",
>  		  efx->num_mac_stats);
>  
> +#ifdef CONFIG_SFC_VDPA

More opportunities to use IS_ENABLED(CONFIG_SFC_VDPA) in this patch
in stead of the #ifdef.

Martin

>  	nic_data->vdpa_supported = efx_ef100_has_cap(nic_data->datapath_caps3,
>  						     CLIENT_CMD_VF_PROXY) &&
>  				   efx->type->is_vf;
> +#endif
>  	return 0;
>  }
>  
> @@ -1086,6 +1088,35 @@ static int ef100_check_design_params(struct efx_nic *efx)
>  	return rc;
>  }
>  
> +static int efx_ef100_update_client_id(struct efx_nic *efx)
> +{
> +	struct ef100_nic_data *nic_data = efx->nic_data;
> +	unsigned int pf_index = PCIE_FUNCTION_PF_NULL;
> +	unsigned int vf_index = PCIE_FUNCTION_VF_NULL;
> +	efx_qword_t pciefn;
> +	int rc;
> +
> +	if (efx->pci_dev->is_virtfn)
> +		vf_index = nic_data->vf_index;
> +	else
> +		pf_index = nic_data->pf_index;
> +
> +	/* Construct PCIE_FUNCTION structure */
> +	EFX_POPULATE_QWORD_3(pciefn,
> +			     PCIE_FUNCTION_PF, pf_index,
> +			     PCIE_FUNCTION_VF, vf_index,
> +			     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
> +	/* look up self client ID */
> +	rc = efx_ef100_lookup_client_id(efx, pciefn, &efx->client_id);
> +	if (rc) {
> +		pci_warn(efx->pci_dev,
> +			 "%s: Failed to get client ID, rc %d\n",
> +			 __func__, rc);
> +	}
> +
> +	return rc;
> +}
> +
>  /*	NIC probe and remove
>   */
>  static int ef100_probe_main(struct efx_nic *efx)
> @@ -1173,6 +1204,10 @@ static int ef100_probe_main(struct efx_nic *efx)
>  		goto fail;
>  	efx->port_num = rc;
>  
> +	rc = efx_ef100_update_client_id(efx);
> +	if (rc)
> +		goto fail;
> +
>  	efx_mcdi_print_fwver(efx, fw_version, sizeof(fw_version));
>  	pci_dbg(efx->pci_dev, "Firmware version %s\n", fw_version);
>  
> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
> index a7f2c31071e8..3bf1ebe05775 100644
> --- a/drivers/net/ethernet/sfc/mcdi.c
> +++ b/drivers/net/ethernet/sfc/mcdi.c
> @@ -145,14 +145,15 @@ void efx_mcdi_fini(struct efx_nic *efx)
>  	kfree(efx->mcdi);
>  }
>  
> -static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
> -				  const efx_dword_t *inbuf, size_t inlen)
> +static void efx_mcdi_send_request(struct efx_nic *efx, u32 client_id,
> +				  unsigned int cmd, const efx_dword_t *inbuf,
> +				  size_t inlen)
>  {
>  	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
>  #ifdef CONFIG_SFC_MCDI_LOGGING
>  	char *buf = mcdi->logging_buffer; /* page-sized */
>  #endif
> -	efx_dword_t hdr[2];
> +	efx_dword_t hdr[5];
>  	size_t hdr_len;
>  	u32 xflags, seqno;
>  
> @@ -179,7 +180,7 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>  				     MCDI_HEADER_XFLAGS, xflags,
>  				     MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
>  		hdr_len = 4;
> -	} else {
> +	} else if (client_id == efx->client_id) {
>  		/* MCDI v2 */
>  		BUG_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
>  		EFX_POPULATE_DWORD_7(hdr[0],
> @@ -194,6 +195,35 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>  				     MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
>  				     MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
>  		hdr_len = 8;
> +	} else {
> +		/* MCDI v2 */
> +		WARN_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
> +		/* MCDI v2 with credentials of a different client */
> +		BUILD_BUG_ON(MC_CMD_CLIENT_CMD_IN_LEN != 4);
> +		/* Outer CLIENT_CMD wrapper command with client ID */
> +		EFX_POPULATE_DWORD_7(hdr[0],
> +				     MCDI_HEADER_RESPONSE, 0,
> +				     MCDI_HEADER_RESYNC, 1,
> +				     MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
> +				     MCDI_HEADER_DATALEN, 0,
> +				     MCDI_HEADER_SEQ, seqno,
> +				     MCDI_HEADER_XFLAGS, xflags,
> +				     MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
> +		EFX_POPULATE_DWORD_2(hdr[1],
> +				     MC_CMD_V2_EXTN_IN_EXTENDED_CMD,
> +				     MC_CMD_CLIENT_CMD,
> +				     MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen + 12);
> +		MCDI_SET_DWORD(&hdr[2],
> +			       CLIENT_CMD_IN_CLIENT_ID, client_id);
> +
> +		/* MCDIv2 header for inner command */
> +		EFX_POPULATE_DWORD_2(hdr[3],
> +				     MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
> +				     MCDI_HEADER_DATALEN, 0);
> +		EFX_POPULATE_DWORD_2(hdr[4],
> +				     MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
> +				     MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
> +		hdr_len = 20;
>  	}
>  
>  #ifdef CONFIG_SFC_MCDI_LOGGING
> @@ -474,7 +504,8 @@ static void efx_mcdi_release(struct efx_mcdi_iface *mcdi)
>  			&mcdi->async_list, struct efx_mcdi_async_param, list);
>  		if (async) {
>  			mcdi->state = MCDI_STATE_RUNNING_ASYNC;
> -			efx_mcdi_send_request(efx, async->cmd,
> +			efx_mcdi_send_request(efx, efx->client_id,
> +					      async->cmd,
>  					      (const efx_dword_t *)(async + 1),
>  					      async->inlen);
>  			mod_timer(&mcdi->async_timer,
> @@ -797,7 +828,7 @@ static int efx_mcdi_proxy_wait(struct efx_nic *efx, u32 handle, bool quiet)
>  	return mcdi->proxy_rx_status;
>  }
>  
> -static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
> +static int _efx_mcdi_rpc(struct efx_nic *efx, u32 client_id, unsigned int cmd,
>  			 const efx_dword_t *inbuf, size_t inlen,
>  			 efx_dword_t *outbuf, size_t outlen,
>  			 size_t *outlen_actual, bool quiet, int *raw_rc)
> @@ -811,7 +842,7 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>  		return -EINVAL;
>  	}
>  
> -	rc = efx_mcdi_rpc_start(efx, cmd, inbuf, inlen);
> +	rc = efx_mcdi_rpc_start(efx, client_id, cmd, inbuf, inlen);
>  	if (rc)
>  		return rc;
>  
> @@ -836,7 +867,8 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>  
>  			/* We now retry the original request. */
>  			mcdi->state = MCDI_STATE_RUNNING_SYNC;
> -			efx_mcdi_send_request(efx, cmd, inbuf, inlen);
> +			efx_mcdi_send_request(efx, efx->client_id, cmd,
> +					      inbuf, inlen);
>  
>  			rc = _efx_mcdi_rpc_finish(efx, cmd, inlen,
>  						  outbuf, outlen, outlen_actual,
> @@ -855,16 +887,44 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>  	return rc;
>  }
>  
> +#ifdef CONFIG_SFC_VDPA
> +static bool is_mode_vdpa(struct efx_nic *efx)
> +{
> +	if (efx->pci_dev->is_virtfn &&
> +	    efx->pci_dev->physfn &&
> +	    efx->state == STATE_VDPA &&
> +	    efx->vdpa_nic)
> +		return true;
> +
> +	return false;
> +}
> +#endif
> +
>  static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
>  				   const efx_dword_t *inbuf, size_t inlen,
>  				   efx_dword_t *outbuf, size_t outlen,
>  				   size_t *outlen_actual, bool quiet)
>  {
> +#ifdef CONFIG_SFC_VDPA
> +	struct efx_nic *efx_pf;
> +#endif
>  	int raw_rc = 0;
>  	int rc;
>  
> -	rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
> -			   outbuf, outlen, outlen_actual, true, &raw_rc);
> +#ifdef CONFIG_SFC_VDPA
> +	if (is_mode_vdpa(efx)) {
> +		efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
> +		rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd, inbuf,
> +				   inlen, outbuf, outlen, outlen_actual,
> +				   true, &raw_rc);
> +	} else {
> +#endif
> +		rc = _efx_mcdi_rpc(efx, efx->client_id, cmd, inbuf,
> +				   inlen, outbuf, outlen, outlen_actual, true,
> +				   &raw_rc);
> +#ifdef CONFIG_SFC_VDPA
> +	}
> +#endif
>  
>  	if ((rc == -EPROTO) && (raw_rc == MC_CMD_ERR_NO_EVB_PORT) &&
>  	    efx->type->is_vf) {
> @@ -881,9 +941,22 @@ static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
>  
>  		do {
>  			usleep_range(delay_us, delay_us + 10000);
> -			rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
> -					   outbuf, outlen, outlen_actual,
> -					   true, &raw_rc);
> +#ifdef CONFIG_SFC_VDPA
> +			if (is_mode_vdpa(efx)) {
> +				efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
> +				rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd,
> +						   inbuf, inlen, outbuf, outlen,
> +						   outlen_actual, true,
> +						   &raw_rc);
> +			} else {
> +#endif
> +				rc = _efx_mcdi_rpc(efx, efx->client_id,
> +						   cmd, inbuf, inlen, outbuf,
> +						   outlen, outlen_actual, true,
> +						   &raw_rc);
> +#ifdef CONFIG_SFC_VDPA
> +			}
> +#endif
>  			if (delay_us < 100000)
>  				delay_us <<= 1;
>  		} while ((rc == -EPROTO) &&
> @@ -939,7 +1012,7 @@ int efx_mcdi_rpc(struct efx_nic *efx, unsigned cmd,
>   * function and is then responsible for calling efx_mcdi_display_error
>   * as needed.
>   */
> -int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
> +int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned int cmd,
>  		       const efx_dword_t *inbuf, size_t inlen,
>  		       efx_dword_t *outbuf, size_t outlen,
>  		       size_t *outlen_actual)
> @@ -948,7 +1021,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
>  				       outlen_actual, true);
>  }
>  
> -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
> +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
>  		       const efx_dword_t *inbuf, size_t inlen)
>  {
>  	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
> @@ -965,7 +1038,7 @@ int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
>  		return -ENETDOWN;
>  
>  	efx_mcdi_acquire_sync(mcdi);
> -	efx_mcdi_send_request(efx, cmd, inbuf, inlen);
> +	efx_mcdi_send_request(efx, client_id, cmd, inbuf, inlen);
>  	return 0;
>  }
>  
> @@ -1009,7 +1082,8 @@ static int _efx_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
>  		 */
>  		if (mcdi->async_list.next == &async->list &&
>  		    efx_mcdi_acquire_async(mcdi)) {
> -			efx_mcdi_send_request(efx, cmd, inbuf, inlen);
> +			efx_mcdi_send_request(efx, efx->client_id,
> +					      cmd, inbuf, inlen);
>  			mod_timer(&mcdi->async_timer,
>  				  jiffies + MCDI_RPC_TIMEOUT);
>  		}
> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
> index dafab52aaef7..2c526d2edeb6 100644
> --- a/drivers/net/ethernet/sfc/mcdi.h
> +++ b/drivers/net/ethernet/sfc/mcdi.h
> @@ -150,7 +150,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
>  		       efx_dword_t *outbuf, size_t outlen,
>  		       size_t *outlen_actual);
>  
> -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
> +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
>  		       const efx_dword_t *inbuf, size_t inlen);
>  int efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned cmd, size_t inlen,
>  			efx_dword_t *outbuf, size_t outlen,
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 1da71deac71c..948c7a06403a 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -859,6 +859,7 @@ struct efx_mae;
>   * @secondary_list: List of &struct efx_nic instances for the secondary PCI
>   *	functions of the controller, if this is for the primary function.
>   *	Serialised by rtnl_lock.
> + * @client_id: client ID of this PCIe function
>   * @type: Controller type attributes
>   * @legacy_irq: IRQ number
>   * @workqueue: Workqueue for port reconfigures and the HW monitor.
> @@ -1022,6 +1023,7 @@ struct efx_nic {
>  	struct list_head secondary_list;
>  	struct pci_dev *pci_dev;
>  	unsigned int port_num;
> +	u32 client_id;
>  	const struct efx_nic_type *type;
>  	int legacy_irq;
>  	bool eeh_disabled_legacy_irq;
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> index 9f07e1ba7780..d90d4f6b3824 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -1052,8 +1052,8 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
>  
>  	/* Clear flag that signals MC ready */
>  	WRITE_ONCE(*start, 0);
> -	rc = efx_mcdi_rpc_start(efx, MC_CMD_PTP, synch_buf,
> -				MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
> +	rc = efx_mcdi_rpc_start(efx, MC_CMD_CLIENT_ID_SELF, MC_CMD_PTP,
> +				synch_buf, MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
>  	EFX_WARN_ON_ONCE_PARANOID(rc);
>  
>  	/* Wait for start from MCDI (or timeout) */
> -- 
> 2.30.1
