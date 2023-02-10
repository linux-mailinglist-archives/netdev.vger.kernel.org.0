Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CCF691A65
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjBJIxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjBJIxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:53:33 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D945E22DC9;
        Fri, 10 Feb 2023 00:53:31 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f23-20020a05600c491700b003dff4480a17so5089299wmp.1;
        Fri, 10 Feb 2023 00:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5YouWUSyGDs79r1PakCCDL8yJjJshem2HAyPWj13v98=;
        b=o4uFStJlsCCrgGP4w3uQme5dTX1jgxPWXafcLov/6CALK1pGeQv9xgjR5x+9+xqsAZ
         PwsNLEd74yikBInVku/tCgzmhrCqTXQCgS1dya9rFjHhIxMikQ21s8ShDutZw6dt9qi6
         4qeZ7dUoOFKoKeLL9T0zRkfR7XcGb9/6tybB+pATdcZ1Xxi/pTidf5csiutiehUJgJvD
         WQ2SwSghe+P1snHzhPhCSenROiVveJ8ZWtLOOmr9Tth0wzuHPehKbYEc/HOofiK1rKo7
         Z77XG0osk8Di54d596NVFE/ntP82bguVsY3Sdv8wA7fxHPoNkYdZzG81klE9naHXfDaq
         4gHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YouWUSyGDs79r1PakCCDL8yJjJshem2HAyPWj13v98=;
        b=iNrRULamssVHQdKTcC7T91fPUdlr8JwPYMAP0lCVw4JBJQfoJdXeVt0mj6RFw93kX8
         gdNeNPFSq+sZNYev8dZPin03Lp5wh0kZCUOPNzA1okTrsPkPFcZ/74Aa1jS02DR5gz+C
         FCLAa73QS0vU3RXJNgzaPHOR8MHWMHElwEaJOHFTSVj3a303sQlbKxPnTIKJTJHUoaqX
         KD9dsKqSulRLgFaitvXfcy+8C6we1Wqvoj6GPUPhj/HaJpH0N+wcSdtpcBlpczGkQff7
         mNz7wcw/faMZBnIKQnJXKRhie4OKIvugMIg8UQIjkNNAKlNihygC7Ow9ZgZ43KY2B/Yg
         j1oA==
X-Gm-Message-State: AO0yUKUcNzIz1UxFZjDcakzDOgiwUty1XkvnkLgh6jG72Z5FUAhw+Ezx
        IuaSomfrAZrhn4Uv6vu3Wxc=
X-Google-Smtp-Source: AK7set+jPe+frWC+MQkhF3AQ1yLatU+WxwsIhruhJ0p0DfMRqJH2ulJPriomKE4LdZ4rofT2kNt+tg==
X-Received: by 2002:a05:600c:1e8a:b0:3df:e57d:f4ba with SMTP id be10-20020a05600c1e8a00b003dfe57df4bamr15320821wmb.7.1676019210527;
        Fri, 10 Feb 2023 00:53:30 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id w19-20020a05600c475300b003e11f280b8bsm1541894wmo.44.2023.02.10.00.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:53:30 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:53:28 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
Subject: Re: [PATCH v6 net-next 8/8] sfc: add support for devlink
 port_function_hw_addr_set in ef100
Message-ID: <Y+YGCN59uCVWaH4m@gmail.com>
Mail-Followup-To: alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
 <20230208142519.31192-9-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208142519.31192-9-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:25:19PM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Using the builtin client handle id infrastructure, add support for
> setting the mac address linked to mports in ef100. This implies to
> execute an MCDI command for giving the address to the firmware for
> the specific devlink port.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx_devlink.c | 42 ++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index 68d04c2176d3..9fc2fe862303 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -103,6 +103,47 @@ static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
>  	return rc;
>  }
>  
> +static int efx_devlink_port_addr_set(struct devlink_port *port,
> +				     const u8 *hw_addr, int hw_addr_len,
> +				     struct netlink_ext_ack *extack)
> +{
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_CLIENT_MAC_ADDRESSES_IN_LEN(1));
> +	struct efx_devlink *devlink = devlink_priv(port->devlink);
> +	struct mae_mport_desc *mport_desc;
> +	efx_qword_t pciefn;
> +	u32 client_id;
> +	int rc;
> +
> +	mport_desc = container_of(port, struct mae_mport_desc, dl_port);
> +
> +	if (!ef100_mport_is_vf(mport_desc)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Port MAC change not allowed");
> +		return -EPERM;
> +	}
> +
> +	EFX_POPULATE_QWORD_3(pciefn,
> +			     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
> +			     PCIE_FUNCTION_VF, mport_desc->vf_idx,
> +			     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
> +
> +	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
> +	if (rc) {
> +		NL_SET_ERR_MSG_MOD(extack, "No internal client_ID");
> +		return rc;
> +	}
> +
> +	MCDI_SET_DWORD(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_CLIENT_HANDLE,
> +		       client_id);
> +
> +	ether_addr_copy(MCDI_PTR(inbuf, SET_CLIENT_MAC_ADDRESSES_IN_MAC_ADDRS),
> +			hw_addr);
> +
> +	rc = efx_mcdi_rpc(devlink->efx, MC_CMD_SET_CLIENT_MAC_ADDRESSES, inbuf,
> +			  sizeof(inbuf), NULL, 0, NULL);
> +
> +	return rc;
> +}
> +
>  static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
>  					    struct devlink_info_req *req,
>  					    unsigned int partition_type,
> @@ -557,6 +598,7 @@ static const struct devlink_ops sfc_devlink_ops = {
>  #ifdef CONFIG_SFC_SRIOV
>  	.info_get			= efx_devlink_info_get,
>  	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
> +	.port_function_hw_addr_set	= efx_devlink_port_addr_set,
>  #endif
>  };
>  
> -- 
> 2.17.1
