Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09ECD387A88
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 15:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243387AbhERN7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 09:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343739AbhERN7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 09:59:31 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8E2C061573
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 06:58:11 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z137-20020a1c7e8f0000b02901774f2a7dc4so1654668wmc.0
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 06:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vMyccDObEmjyUCovO+Driz6eLppd/QP0Vbhv3sy0Vzw=;
        b=XypU0co7hOXtdPsmr2/DvAl0A4Q5XWKEHWA+xs+BJRDUZraNQNXlvrq2eRjs/QmZ8a
         2nQxqMXr18DbK/B+TwSLQm/JcNmOP4arVRh8gx6wUYZNCQcI//IvOaeN+hw2+43yOPaB
         EUU7rrglPXo4zE+a1p+SdlsZuuEUV41cakO3Qp3nnNZBZ/5c3etAZLKoXXtSip8jfOKg
         I4YTqd4HvnrCkIj2DMactNdMUridIA0y6IN1CEciFrk41msHvzMEHEilH12BN0garqXP
         n3a/5Q4Mr8I0+PCqdnkpiO+bOKwHMbtQhscoDoAxdngQdYmSYnSxakemu7nMo2QE7QVk
         RZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=vMyccDObEmjyUCovO+Driz6eLppd/QP0Vbhv3sy0Vzw=;
        b=fZoR6K5HAXUgwIYXeNBwdlNs159u3dGgDfh5V8nv2c7ShX4Se8BVs97e266B3SAmmn
         KvRpQn4QilckXf/MxQD6aNreD2FGo0dRPVtIMKtdw0Z9nNYyg1dGx55r+Te0/GBPtiUA
         ZRU3QbzWKJN/m67Y9f9dy1uPEqzNr+a1m7EE01vSENx/W/3kse/SkXSfi65Vq4xdUbbv
         xiyUYhMdznfPxgOg4oPcO6EB7fi+a34MxMF1maNolnxRB3AWC6/zuMTJuaX+tGc8XQXz
         pmPBQ8T2AG+FzKMSGfDSJn0gE932P88m49TSn73KuFGsPR3pudL9cIghm1+0Vvg5Tauu
         7dcw==
X-Gm-Message-State: AOAM533JE1aXlpTmc7h9CBvDZCv8jzWQysLHfOgM1YaRY6GoscDZRxtt
        iVXKbOIYwBd3QTNLSxYk4Os4P9zc8AY=
X-Google-Smtp-Source: ABdhPJwBCakrVjqV6SCRj28ciaIpcslc5W4VNL+ypwc9wWJuvga2WnqZDL1ATpJUvjYPUClHp09/bQ==
X-Received: by 2002:a05:600c:4f44:: with SMTP id m4mr5721763wmq.50.1621346290694;
        Tue, 18 May 2021 06:58:10 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id v12sm24253401wrv.76.2021.05.18.06.58.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 May 2021 06:58:10 -0700 (PDT)
Date:   Tue, 18 May 2021 14:58:07 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] sfc: don't use netif_info et al before
 net_device is registered
Message-ID: <20210518135807.yswqnksmobc3yei3@gmail.com>
Mail-Followup-To: Heiner Kallweit <hkallweit1@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b6773ec4-82ac-51f8-0531-f1d6b30dc9a6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6773ec4-82ac-51f8-0531-f1d6b30dc9a6@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 11:29:12PM +0200, Heiner Kallweit wrote:
> Using netif_info() before the net_device is registered results in ugly
> messages like the following:
> sfc 0000:01:00.1 (unnamed net_device) (uninitialized): Solarflare NIC detected
> Therefore use pci_info() et al until net_device is registered.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Hard to believe I've seen those messages for years and not noticed.
Thanks!

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index c746ca723..4fd9903ff 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -722,8 +722,7 @@ static int efx_register_netdev(struct efx_nic *efx)
>  	efx->state = STATE_READY;
>  	smp_mb(); /* ensure we change state before checking reset_pending */
>  	if (efx->reset_pending) {
> -		netif_err(efx, probe, efx->net_dev,
> -			  "aborting probe due to scheduled reset\n");
> +		pci_err(efx->pci_dev, "aborting probe due to scheduled reset\n");
>  		rc = -EIO;
>  		goto fail_locked;
>  	}
> @@ -990,8 +989,7 @@ static int efx_pci_probe_main(struct efx_nic *efx)
>  	rc = efx->type->init(efx);
>  	up_write(&efx->filter_sem);
>  	if (rc) {
> -		netif_err(efx, probe, efx->net_dev,
> -			  "failed to initialise NIC\n");
> +		pci_err(efx->pci_dev, "failed to initialise NIC\n");
>  		goto fail3;
>  	}
>  
> @@ -1038,8 +1036,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
>  	if (efx->type->sriov_init) {
>  		rc = efx->type->sriov_init(efx);
>  		if (rc)
> -			netif_err(efx, probe, efx->net_dev,
> -				  "SR-IOV can't be enabled rc %d\n", rc);
> +			pci_err(efx->pci_dev, "SR-IOV can't be enabled rc %d\n",
> +				rc);
>  	}
>  
>  	/* Determine netdevice features */
> @@ -1106,8 +1104,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
>  	if (rc)
>  		goto fail1;
>  
> -	netif_info(efx, probe, efx->net_dev,
> -		   "Solarflare NIC detected\n");
> +	pci_info(pci_dev, "Solarflare NIC detected\n");
>  
>  	if (!efx->type->is_vf)
>  		efx_probe_vpd_strings(efx);
> -- 
> 2.31.1
