Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC66691A55
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjBJIvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjBJIvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:51:07 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CA07B16D;
        Fri, 10 Feb 2023 00:50:55 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id ba1so4299697wrb.5;
        Fri, 10 Feb 2023 00:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F7ziMABkVyvrrp1x3IhWF4+PJQWoWvtElCrMHPrFdA0=;
        b=Yp9sTvWML+jfrlKcKa5ebRc3gYOImOBYWpHgCnWuWKAKsMRFHiT+8fD4CvnoZGTHq7
         PvXN40RKXoFlIQMt5klPL0dv/WKtTecLtKqBO0+lAtaEfrmCTC+TclxseW59TsS9Wglj
         /phjpbJW8mV9EL8XhF/JoIH3t+93pNwO2D/zGi0ORaVKK5KlB239m/bh+s3lo48uzivo
         lTChZ3DxyPTsehA+maazfdOYeEePiE00ojsXpteFdfNp1r/8NsilWyWvqixozzJ8jfT8
         ZJVxgwq+uuPRVvymAe/kcHUH6HAFcCl3WKxyLs6E821PCp3VEEnBWat9gqRAkyqFxReD
         yVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F7ziMABkVyvrrp1x3IhWF4+PJQWoWvtElCrMHPrFdA0=;
        b=1RclDFqbliK479Igc1tw+jvRvPJlt9M2i0rW2qYa5nx2wIgrGW7uy7dXHus2MvnHLH
         LKZJU84Ae84ktNmOIYDUErcLUDbPVUPod1ny+4fAKUSUUpcTgJJYQmk36i19CG5JB8Z5
         9vqLL8u1YKnZnpZj4NyUkm2x4uTGEhQxyE5tNnVbJ/KjofjbhHHpGmzMVPAZhD5IhQeT
         a6h/DzjOCIdAOWEomOesV3r49Sl5a4o7efq+Jjwzaul5bnRI7Pev165ED5UVNWeHH0JE
         PprBBRJgum9AvV+/2ynTcKZKBO+FdgGhmjtspT0FOM14vWmrRJfW7UqVkMgyo/RNezXX
         wgqA==
X-Gm-Message-State: AO0yUKUy9KKOvKwu6oB9F6PSuUqwP4A1LeviSrejsWp6H0c9CULGzPHj
        gOPBBNHEflsDpxG4NZNrEZE=
X-Google-Smtp-Source: AK7set/02aNi7JSh7EusN4jBb5iVenKF3/VNLDwZeVzRcuc79iwAyeLqewnwOcpS9+BARpdUJd/2Rw==
X-Received: by 2002:a5d:5687:0:b0:2c5:3d80:edca with SMTP id f7-20020a5d5687000000b002c53d80edcamr3492877wrv.62.1676019053950;
        Fri, 10 Feb 2023 00:50:53 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id r8-20020adff708000000b002c53cd6d281sm2849648wrp.4.2023.02.10.00.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:50:53 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:50:51 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
Subject: Re: [PATCH v6 net-next 6/8] sfc: obtain device mac address based on
 firmware handle for ef100
Message-ID: <Y+YFa62Yuz9kHtzM@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-7-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208142519.31192-7-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:25:17PM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Getting device mac address is currently based on a specific MCDI command
> only available for the PF. This patch changes the MCDI command to a
> generic one for PFs and VFs based on a client handle. This allows both
> PFs and VFs to ask for their mac address during initialization using the
> CLIENT_HANDLE_SELF.
> 
> Moreover, the patch allows other client handles which will be used by
> the PF to ask for mac addresses linked to VFs. This is necessary for
> suporting the port_function_hw_addr_get devlink function in further
> patches.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c | 10 +++++++
>  drivers/net/ethernet/sfc/ef100_nic.c    | 37 +++++++++++++------------
>  drivers/net/ethernet/sfc/ef100_nic.h    |  2 ++
>  3 files changed, 31 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> index 368147359299..d916877b5a9a 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> @@ -359,6 +359,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  {
>  	struct efx_nic *efx = &probe_data->efx;
>  	struct efx_probe_data **probe_ptr;
> +	struct ef100_nic_data *nic_data;
>  	struct net_device *net_dev;
>  	int rc;
>  
> @@ -410,6 +411,15 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>  	/* Don't fail init if RSS setup doesn't work. */
>  	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
>  
> +	nic_data = efx->nic_data;
> +	rc = ef100_get_mac_address(efx, net_dev->perm_addr, CLIENT_HANDLE_SELF,
> +				   efx->type->is_vf);
> +	if (rc)
> +		return rc;
> +	/* Assign MAC address */
> +	eth_hw_addr_set(net_dev, net_dev->perm_addr);
> +	ether_addr_copy(nic_data->port_id, net_dev->perm_addr);
> +
>  	/* devlink creation, registration and lock */
>  	rc = efx_probe_devlink_and_lock(efx);
>  	if (rc)
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index aa11f0925e27..aa48c79a2149 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -130,23 +130,34 @@ static void ef100_mcdi_reboot_detected(struct efx_nic *efx)
>  
>  /*	MCDI calls
>   */
> -static int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address)
> +int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
> +			  int client_handle, bool empty_ok)
>  {
> -	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_MAC_ADDRESSES_OUT_LEN);
> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CLIENT_MAC_ADDRESSES_OUT_LEN(1));
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_CLIENT_MAC_ADDRESSES_IN_LEN);
>  	size_t outlen;
>  	int rc;
>  
>  	BUILD_BUG_ON(MC_CMD_GET_MAC_ADDRESSES_IN_LEN != 0);
> +	MCDI_SET_DWORD(inbuf, GET_CLIENT_MAC_ADDRESSES_IN_CLIENT_HANDLE,
> +		       client_handle);
>  
> -	rc = efx_mcdi_rpc(efx, MC_CMD_GET_MAC_ADDRESSES, NULL, 0,
> -			  outbuf, sizeof(outbuf), &outlen);
> +	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CLIENT_MAC_ADDRESSES, inbuf,
> +			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
>  	if (rc)
>  		return rc;
> -	if (outlen < MC_CMD_GET_MAC_ADDRESSES_OUT_LEN)
> -		return -EIO;
>  
> -	ether_addr_copy(mac_address,
> -			MCDI_PTR(outbuf, GET_MAC_ADDRESSES_OUT_MAC_ADDR_BASE));
> +	if (outlen >= MC_CMD_GET_CLIENT_MAC_ADDRESSES_OUT_LEN(1)) {
> +		ether_addr_copy(mac_address,
> +				MCDI_PTR(outbuf, GET_CLIENT_MAC_ADDRESSES_OUT_MAC_ADDRS));
> +	} else if (empty_ok) {
> +		pci_warn(efx->pci_dev,
> +			 "No MAC address provisioned for client ID %#x.\n",
> +			 client_handle);
> +		eth_zero_addr(mac_address);
> +	} else {
> +		return -ENOENT;
> +	}
>  	return 0;
>  }
>  
> @@ -1117,13 +1128,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>  	struct net_device *net_dev = efx->net_dev;
>  	int rc;
>  
> -	rc = ef100_get_mac_address(efx, net_dev->perm_addr);
> -	if (rc)
> -		goto fail;
> -	/* Assign MAC address */
> -	eth_hw_addr_set(net_dev, net_dev->perm_addr);
> -	memcpy(nic_data->port_id, net_dev->perm_addr, ETH_ALEN);
> -
>  	if (!nic_data->grp_mae)
>  		return 0;
>  
> @@ -1163,9 +1167,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>  		efx->fixed_features |= NETIF_F_HW_TC;
>  	}
>  #endif
> -	return 0;
> -
> -fail:
>  	return rc;
>  }
>  
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
> index 496aea43c60f..e59044072333 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.h
> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
> @@ -92,4 +92,6 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx);
>  int ef100_phy_probe(struct efx_nic *efx);
>  int ef100_filter_table_probe(struct efx_nic *efx);
>  
> +int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
> +			  int client_handle, bool empty_ok);
>  #endif	/* EFX_EF100_NIC_H */
> -- 
> 2.17.1
