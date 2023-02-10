Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B785E691A69
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjBJIzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbjBJIzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:55:06 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3F58661C;
        Fri, 10 Feb 2023 00:55:04 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id r2so4298546wrv.7;
        Fri, 10 Feb 2023 00:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oytTrK8uB+n9m87mo+0OrCa0wPjo42ng3CF/hRN1mgo=;
        b=imuXWPqYwuc6dboQ7oTX2sgb8gbWly9VRi5V5YWOWlJxYDht3KPRrjDXAxFmu/DiyO
         aLsa07O32Qx3LfHhZGdU+1jjnEve7gJTHEqd1X8mjEsnvNfdWW6XakOdj2HsB4AjlNPk
         d8TIS7GGhN8NzLOEwkOLQEKDQRaz6w/ulqEQxJikrfiHwq3dUmxpC7DnR6e4ARA/c/6S
         UsZUMBrRtQlQVdADILW6x5ke84IAnp+rHiHX7T8y9tVQWxTxehVOo7oVxRYK3klCssjl
         Mixo1MrNden0Az9D5zyNWDuUgsX36PnvHIncwwjoTtzlI5Tds3EY0TEZRMqyxfUHhBcA
         mgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oytTrK8uB+n9m87mo+0OrCa0wPjo42ng3CF/hRN1mgo=;
        b=LqFdUk1Qy9soJpEurxl+ORAJ8r0MrnTFOA/AuZ42iizSvdia4FVbfiSJALJy+Z9V9F
         d3KJthopX/Q5dBNZ6azhlkt5h4f2vGgZrducl1hvvXhAW7fr53bKfKUR/Al8GQObi99F
         v0jqnmOHtX5j8wN1qepzqK3jp1SM97QO/yJeS3V5tLbh5cwoLvZXRZfBy9oKgM2S/BtC
         insROWYr37eLkKNJ5hafo4a2WGomDUasx8e9ZQIwfoLX9/EsmuNgV4Jyi3P3gVE2/pZ0
         J9MfEtdmgaMSJuBuy00iezpD7czhIr0wDwDTiYAtocIFK28wvexsv8+mV+lV+bTAV3Yv
         fRlg==
X-Gm-Message-State: AO0yUKUyMndsVFeEq8mYpkjDJFOg/HtJHlLcJW/gmqqHtOi5UaJyRZK+
        gnOsWmJk3Jeg+/kke5IJcEM=
X-Google-Smtp-Source: AK7set/HUlksUVTBiTkjiUx/uv+vpEANaskWuC0xd+CtGZe4IIna+vpYFpEsHAlXkLx9UWUbkdeyDQ==
X-Received: by 2002:adf:db88:0:b0:2c1:28dc:1551 with SMTP id u8-20020adfdb88000000b002c128dc1551mr13101970wri.1.1676019302694;
        Fri, 10 Feb 2023 00:55:02 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id m6-20020adffe46000000b002c3ed120cf8sm3106684wrs.61.2023.02.10.00.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:55:02 -0800 (PST)
Date:   Fri, 10 Feb 2023 08:55:00 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH bpf-next] sfc: move xdp_features configuration in
 efx_pci_probe_post_io()
Message-ID: <Y+YGZLdd6/WmY6s7@gmail.com>
Mail-Followup-To: Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com, ecree.xilinx@gmail.com
References: <9bd31c9a29bcf406ab90a249a28fc328e5578fd1.1675875404.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bd31c9a29bcf406ab90a249a28fc328e5578fd1.1675875404.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many thanks Lorenzo. It got applied in record time!
Martin

On Wed, Feb 08, 2023 at 05:58:40PM +0100, Lorenzo Bianconi wrote:
> Move xdp_features configuration from efx_pci_probe() to
> efx_pci_probe_post_io() since it is where all the other basic netdev
> features are initialised.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/sfc/efx.c       | 8 ++++----
>  drivers/net/ethernet/sfc/siena/efx.c | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 18ff8d8cff42..9569c3356b4a 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -1025,6 +1025,10 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
>  	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
>  	net_dev->features |= efx->fixed_features;
>  
> +	net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
> +				NETDEV_XDP_ACT_REDIRECT |
> +				NETDEV_XDP_ACT_NDO_XMIT;
> +
>  	rc = efx_register_netdev(efx);
>  	if (!rc)
>  		return 0;
> @@ -1078,10 +1082,6 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
>  
>  	pci_info(pci_dev, "Solarflare NIC detected\n");
>  
> -	efx->net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
> -				     NETDEV_XDP_ACT_REDIRECT |
> -				     NETDEV_XDP_ACT_NDO_XMIT;
> -
>  	if (!efx->type->is_vf)
>  		efx_probe_vpd_strings(efx);
>  
> diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
> index a6ef21845224..ef52ec71d197 100644
> --- a/drivers/net/ethernet/sfc/siena/efx.c
> +++ b/drivers/net/ethernet/sfc/siena/efx.c
> @@ -1007,6 +1007,10 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
>  	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
>  	net_dev->features |= efx->fixed_features;
>  
> +	net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
> +				NETDEV_XDP_ACT_REDIRECT |
> +				NETDEV_XDP_ACT_NDO_XMIT;
> +
>  	rc = efx_register_netdev(efx);
>  	if (!rc)
>  		return 0;
> @@ -1048,10 +1052,6 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
>  
>  	pci_info(pci_dev, "Solarflare NIC detected\n");
>  
> -	efx->net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
> -				     NETDEV_XDP_ACT_REDIRECT |
> -				     NETDEV_XDP_ACT_NDO_XMIT;
> -
>  	if (!efx->type->is_vf)
>  		efx_probe_vpd_strings(efx);
>  
> -- 
> 2.39.1
