Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB62E949B
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 13:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbhADMPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 07:15:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhADMPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 07:15:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF9FF21E92;
        Mon,  4 Jan 2021 12:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609762507;
        bh=ujE4ia0BZCEIoKHFwGJssPvikHau8MsYGuk81g80iRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OKkJGLadCQfFuWPr1tbn+w9hTwc0ISMeA8o/yHcdamNGWlgsk6Roi2lt2dr1ZKx3P
         OyHsC3Unamy6+JqA29im/B2IIcVJTNVEiMgCyHq2JO6ISG6fkLUIO/CEBXTYQxgJiz
         jnSyvqoySZ3DIMb7PnV3tyUhMwTjn/lYv2722nnwM0W8iscXii6sNDFIFVdXYfTvab
         LQz93Weo7hSPbaEgFi96lHHVQMwY3Iu/pu8hzYIAKXHIS4fhiXQd164LD8FeYMddN8
         T4z++6/TQCUWL6HRd1EpjziiBSpDenY1uoyauUZfwIZ/Hx2RWMJt/WBSsf1M5DrMjK
         U3mhGqccbyDNQ==
Date:   Mon, 4 Jan 2021 14:15:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v11 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20210104121502.GK31158@unreal>
References: <20210104082218.1389450-1-steen.hegelund@microchip.com>
 <20210104082218.1389450-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104082218.1389450-4-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 09:22:17AM +0100, Steen Hegelund wrote:
> Add the Microchip Sparx5 ethernet serdes PHY driver for the 6G, 10G and 25G
> interfaces available in the Sparx5 SoC.
>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/phy/Kconfig                        |    1 +
>  drivers/phy/Makefile                       |    1 +
>  drivers/phy/microchip/Kconfig              |   12 +
>  drivers/phy/microchip/Makefile             |    6 +
>  drivers/phy/microchip/sparx5_serdes.c      | 2443 ++++++++++++++++++
>  drivers/phy/microchip/sparx5_serdes.h      |  129 +
>  drivers/phy/microchip/sparx5_serdes_regs.h | 2695 ++++++++++++++++++++
>  7 files changed, 5287 insertions(+)
>  create mode 100644 drivers/phy/microchip/Kconfig
>  create mode 100644 drivers/phy/microchip/Makefile
>  create mode 100644 drivers/phy/microchip/sparx5_serdes.c
>  create mode 100644 drivers/phy/microchip/sparx5_serdes.h
>  create mode 100644 drivers/phy/microchip/sparx5_serdes_regs.h
>
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 00dabe5fab8a..df35c752f3aa 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -70,6 +70,7 @@ source "drivers/phy/ingenic/Kconfig"
>  source "drivers/phy/lantiq/Kconfig"
>  source "drivers/phy/marvell/Kconfig"
>  source "drivers/phy/mediatek/Kconfig"
> +source "drivers/phy/microchip/Kconfig"
>  source "drivers/phy/motorola/Kconfig"
>  source "drivers/phy/mscc/Kconfig"
>  source "drivers/phy/qualcomm/Kconfig"
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 32261e164abd..adac1b1a39d1 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -20,6 +20,7 @@ obj-y					+= allwinner/	\
>  					   lantiq/	\
>  					   marvell/	\
>  					   mediatek/	\
> +					   microchip/	\
>  					   motorola/	\
>  					   mscc/	\
>  					   qualcomm/	\
> diff --git a/drivers/phy/microchip/Kconfig b/drivers/phy/microchip/Kconfig
> new file mode 100644
> index 000000000000..0b1a818e01b8

<...>

> +struct sparx5_sd10g28_args {
> +	bool                 skip_cmu_cfg; /* Enable/disable CMU cfg */
> +	bool                 no_pwrcycle;  /* Omit initial power-cycle */
> +	bool                 txinvert;     /* Enable inversion of output data */
> +	bool                 rxinvert;     /* Enable inversion of input data */
> +	bool                 txmargin;     /* Set output level to  half/full */
> +	u16                  txswing;      /* Set output level */
> +	bool                 mute;         /* Mute Output Buffer */
> +	bool                 is_6g;
> +	bool                 reg_rst;
> +};

All those bools in structs can be squeezed into one u8, just use
bitfields, e.g. "u8 a:1;".

Also I strongly advise do not do vertical alignment, it will cause to
too many churn later when this code will be updated.

> +

<...>

> +static inline void __iomem *sdx5_addr(void __iomem *base[],
> +				      int id, int tinst, int tcnt,
> +				      int gbase, int ginst,
> +				      int gcnt, int gwidth,
> +				      int raddr, int rinst,
> +				      int rcnt, int rwidth)
> +{
> +#if defined(CONFIG_DEBUG_KERNEL)
> +	WARN_ON((tinst) >= tcnt);
> +	WARN_ON((ginst) >= gcnt);
> +	WARN_ON((rinst) >= rcnt);
> +#endif

Please don't put "#if defined(CONFIG_DEBUG_KERNEL)", print WARN_ON().

Thanks
