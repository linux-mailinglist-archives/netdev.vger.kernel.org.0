Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F13C3C9455
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 01:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbhGNXVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 19:21:40 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:40682 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhGNXVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 19:21:39 -0400
Received: by mail-io1-f48.google.com with SMTP id l5so4229111iok.7;
        Wed, 14 Jul 2021 16:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FdCuHjoP1NxBak0aeuDJS4GB02OelsJIJfGisEvtn9Y=;
        b=qH0oSl60vriukOTx2xV3Gk4yPWQrp3st2gjFQHfFp5cdeAPGtAE6jNWjMcFMm/qoWi
         gplZnbPcy+Nha7DSbCbUkmJNQ7rWOZ9SohwbMIeomDNH1P4jq9c67rxvlFSKlKrUKV+e
         Z0hrLfPu1U1d11qBuhxnexKfSmLmHNQyvd4ODzIwjqaQrUdO0Io3//evrAb0UZxB6enb
         Z2VolyQSZJrKm0eByh85FWNrDFURE94DfSEFvpnRcTHHxhIyyXw0icKU9EgUa81RSYcV
         2lx7o8nkxi0t3dzCWkJvOsifhVdDA631EFktHixHhO9XzUjYuPoJcundv5dMFXmm/E80
         dyrw==
X-Gm-Message-State: AOAM530PXlp+bW4WciYYXqCS6gT1i3XW+FEAnR97Ngg1Vsn6M6+uF79c
        MS51FBvP/nfoPE3Hm995cg==
X-Google-Smtp-Source: ABdhPJzG3c7oabuQlVbl5iiFgVJiq7JRZ9AG0ODhFSYUK8MJoATHyCvOY8D5wmh81aijlp75MufimQ==
X-Received: by 2002:a02:9508:: with SMTP id y8mr588048jah.28.1626304727482;
        Wed, 14 Jul 2021 16:18:47 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id r4sm2021422ilb.42.2021.07.14.16.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 16:18:46 -0700 (PDT)
Received: (nullmailer pid 3727815 invoked by uid 1000);
        Wed, 14 Jul 2021 23:18:44 -0000
Date:   Wed, 14 Jul 2021 17:18:44 -0600
From:   Rob Herring <robh@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH V1 net-next 3/5] net: fec: add imx8mq and imx8qm new
 versions support
Message-ID: <20210714231844.GA3723991@robh.at.kernel.org>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
 <20210709081823.18696-4-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709081823.18696-4-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 04:18:21PM +0800, Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> The ENET of imx8mq and imx8qm are basically the same as imx6sx,
> but they have new features support based on imx6sx, like:
> - imx8mq: supports IEEE 802.3az EEE standard.
> - imx8qm: supports RGMII mode delayed clock.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec.h      | 13 ++++++++++
>  drivers/net/ethernet/freescale/fec_main.c | 30 +++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index 2e002e4b4b4a..c1f93aa79d63 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -472,6 +472,19 @@ struct bufdesc_ex {
>   */
>  #define FEC_QUIRK_HAS_MULTI_QUEUES	(1 << 19)
>  
> +/* i.MX8MQ ENET IP version add new feature to support IEEE 802.3az EEE
> + * standard. For the transmission, MAC supply two user registers to set
> + * Sleep (TS) and Wake (TW) time.
> + */
> +#define FEC_QUIRK_HAS_EEE		(1 << 20)
> +
> +/* i.MX8QM ENET IP version add new feture to generate delayed TXC/RXC
> + * as an alternative option to make sure it works well with various PHYs.
> + * For the implementation of delayed clock, ENET takes synchronized 250MHz
> + * clocks to generate 2ns delay.
> + */
> +#define FEC_QUIRK_DELAYED_CLKS_SUPPORT	(1 << 21)
> +
>  struct bufdesc_prop {
>  	int qid;
>  	/* Address of Rx and Tx buffers */
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 8aea707a65a7..dd0b8715e84e 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -135,6 +135,26 @@ static const struct fec_devinfo fec_imx6ul_info = {
>  		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
>  };
>  
> +static const struct fec_devinfo fec_imx8mq_info = {
> +	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
> +		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
> +		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
> +		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
> +		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
> +		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
> +		  FEC_QUIRK_HAS_EEE,
> +};
> +
> +static const struct fec_devinfo fec_imx8qm_info = {
> +	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
> +		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
> +		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
> +		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
> +		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
> +		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
> +		  FEC_QUIRK_DELAYED_CLKS_SUPPORT,
> +};
> +
>  static struct platform_device_id fec_devtype[] = {
>  	{
>  		/* keep it for coldfire */
> @@ -161,6 +181,12 @@ static struct platform_device_id fec_devtype[] = {
>  	}, {
>  		.name = "imx6ul-fec",
>  		.driver_data = (kernel_ulong_t)&fec_imx6ul_info,
> +	}, {
> +		.name = "imx8mq-fec",
> +		.driver_data = (kernel_ulong_t)&fec_imx8mq_info,
> +	}, {
> +		.name = "imx8qm-fec",
> +		.driver_data = (kernel_ulong_t)&fec_imx8qm_info,
>  	}, {
>  		/* sentinel */
>  	}
> @@ -175,6 +201,8 @@ enum imx_fec_type {
>  	MVF600_FEC,
>  	IMX6SX_FEC,
>  	IMX6UL_FEC,
> +	IMX8MQ_FEC,
> +	IMX8QM_FEC,
>  };
>  
>  static const struct of_device_id fec_dt_ids[] = {
> @@ -185,6 +213,8 @@ static const struct of_device_id fec_dt_ids[] = {
>  	{ .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
>  	{ .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
>  	{ .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
> +	{ .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
> +	{ .compatible = "fsl,imx8qm-fec", .data = &fec_devtype[IMX8QM_FEC], },

I don't think these are documented.

Rob
