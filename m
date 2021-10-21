Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5F0435EA1
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhJUKJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbhJUKJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:09:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378E8C06161C;
        Thu, 21 Oct 2021 03:07:05 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i12so179664wrb.7;
        Thu, 21 Oct 2021 03:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lJ5VWnCKzJUxsEb5WXqBp1tX6Jd2/Goa19ZNuDx2zbY=;
        b=I2vBIlEDPcFsZ05k3kMzo4kRJ2geEppMpkr4CtWNblQGP1wotFk7UZ53i7zlPGyNkm
         AHMoMtovSifZeMEDcWuEO+6KGUuco02L8Z/8eytzKuZZvj0UB6LfLMLU6solL4Rbh77V
         iOYeuIovCNftFtjEVmqBGMU2SV0JvD53/cZuj3cQOTWJPt+DBtYAluGuEog0qkC3YCcl
         Xr90bcxBjotlEmQ3PoGCZVFZtpn9uh13ayewG1xs/SqtkudRjAvgBq1ZMFGhYau5s/2w
         iwnyBXoSSxRHQ/jOiDW3xyLMOfjpWxmbL+db2CssWJtQZO2z7GULYy9Hu9HKk7KF5KCh
         9kQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=lJ5VWnCKzJUxsEb5WXqBp1tX6Jd2/Goa19ZNuDx2zbY=;
        b=gHOxrAgW7nHMOBwDE7Z9zCsJ/3sR8qS2VDEoxfDsxRndyUDfQFkjj3vDzO85cAURK4
         SUcmH714Aay2514e7KlN+AMSVC6MOAwGbwlYABF5qjQfq3kiOwtSHRWINfwFY98d1LvJ
         ga4noF9N8g4W2eQhFjDq2AXBi+eVeUQcyr66h4VTMXSBHwGFGyZegqmSMCila9psBuSr
         Ko8WKiezbqEzB3IYuSQBN5XL2R+XhfE+9zdTsT7AGjGG+9b4gAfP7yOqnVYu6HBpBICr
         TJADGrBLEMYaAC/LH5L+qZQv+9BkCkaHfoK9t1mul4eUDyEGhq7v3T3+YWkA1bIgmAdB
         4ASA==
X-Gm-Message-State: AOAM533yFVH0w3Ardkbpyp+tm62RXFo43Cv9m+UqU6WvVio0uuDUfvau
        UHAzj+RVCmB/N5xxOl8KbeE=
X-Google-Smtp-Source: ABdhPJw0tUsP8ixLPHkHh+UEbMjxXwVBkTvlEio6NRSbwje8NNxCZob12fvKRAYETMIN1zGC9ZuEYQ==
X-Received: by 2002:a05:6000:8a:: with SMTP id m10mr1854481wrx.115.1634810823861;
        Thu, 21 Oct 2021 03:07:03 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id v185sm7573709wme.35.2021.10.21.03.07.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Oct 2021 03:07:03 -0700 (PDT)
Date:   Thu, 21 Oct 2021 11:07:01 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Erik Ekman <erik@kryo.se>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: Don't use netif_info before net_device setup
Message-ID: <20211021100701.k2dzn7mn5exyofkm@gmail.com>
Mail-Followup-To: Erik Ekman <erik@kryo.se>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211019224016.26530-1-erik@kryo.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019224016.26530-1-erik@kryo.se>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 12:40:16AM +0200, Erik Ekman wrote:
> Use pci_info instead to avoid unnamed/uninitialized noise:
> 
> [197088.688729] sfc 0000:01:00.0: Solarflare NIC detected
> [197088.690333] sfc 0000:01:00.0: Part Number : SFN5122F
> [197088.729061] sfc 0000:01:00.0 (unnamed net_device) (uninitialized): no SR-IOV VFs probed
> [197088.729071] sfc 0000:01:00.0 (unnamed net_device) (uninitialized): no PTP support
> 
> Inspired by fa44821a4ddd ("sfc: don't use netif_info et al before
> net_device is registered") from Heiner Kallweit.
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/ptp.c         | 4 ++--
>  drivers/net/ethernet/sfc/siena_sriov.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> index a39c5143b386..797e51802ccb 100644
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -648,7 +648,7 @@ static int efx_ptp_get_attributes(struct efx_nic *efx)
>  	} else if (rc == -EINVAL) {
>  		fmt = MC_CMD_PTP_OUT_GET_ATTRIBUTES_SECONDS_NANOSECONDS;
>  	} else if (rc == -EPERM) {
> -		netif_info(efx, probe, efx->net_dev, "no PTP support\n");
> +		pci_info(efx->pci_dev, "no PTP support\n");
>  		return rc;
>  	} else {
>  		efx_mcdi_display_error(efx, MC_CMD_PTP, sizeof(inbuf),
> @@ -824,7 +824,7 @@ static int efx_ptp_disable(struct efx_nic *efx)
>  	 * should only have been called during probe.
>  	 */
>  	if (rc == -ENOSYS || rc == -EPERM)
> -		netif_info(efx, probe, efx->net_dev, "no PTP support\n");
> +		pci_info(efx->pci_dev, "no PTP support\n");
>  	else if (rc)
>  		efx_mcdi_display_error(efx, MC_CMD_PTP,
>  				       MC_CMD_PTP_IN_DISABLE_LEN,
> diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena_sriov.c
> index 83dcfcae3d4b..441e7f3e5375 100644
> --- a/drivers/net/ethernet/sfc/siena_sriov.c
> +++ b/drivers/net/ethernet/sfc/siena_sriov.c
> @@ -1057,7 +1057,7 @@ void efx_siena_sriov_probe(struct efx_nic *efx)
>  		return;
>  
>  	if (efx_siena_sriov_cmd(efx, false, &efx->vi_scale, &count)) {
> -		netif_info(efx, probe, efx->net_dev, "no SR-IOV VFs probed\n");
> +		pci_info(efx->pci_dev, "no SR-IOV VFs probed\n");
>  		return;
>  	}
>  	if (count > 0 && count > max_vfs)
> -- 
> 2.31.1
