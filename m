Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3CF36746E
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 22:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245692AbhDUUuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 16:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242846AbhDUUuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 16:50:20 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6092EC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 13:49:45 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z5so14381668edr.11
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 13:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7l+9imnPAQTV01gj5+Xj5zW2sUUBl6VFTSmn6QnuBUY=;
        b=amop35T3o4RAk1g6DtqEJXe1mZqtWWGZvN/mF8EADmmXFCSQXwXCeb8vH9+o11s4LN
         EBJmVxv15mJzxOmxrC52S0EsBolyWLXpEyc2N5jrwHSOMjvFLZAhwv5BJs58Ds4bKPk3
         jUcZw/0H2i+svMM6/7G1a4lpqUtpL0haFK4cD2L9vudaXvxr4BE3Vzmp4TQBm17tfOzb
         2fWxG0c3Zxz8TTJQEEEHsvvyE4IAKBZwY97bS4AbQqCw1l2u8N7W8IZ5Nmpr5jUPB2h3
         7IhYw4cfGnMBI75X/TQH2bGI46wOHO2N83BJJJtKp+IYylUCP+Hr3YeLe3ueLdl6Cn3p
         C0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7l+9imnPAQTV01gj5+Xj5zW2sUUBl6VFTSmn6QnuBUY=;
        b=Bw3ANf1M+ZVrPNWZGsGxZTA70uSyEpLBBLFv4Rvfu55P83ybovckC80rOn6pYOKejG
         fsSmUpPB1qBNcmHnZhQyKfS7prJnfzvYqptz3rC2RwDuBJJzzNxWWzAcGebCsbnjo2VC
         gz7o1opYysGBl+MtIVCplQ08ujMxsfbi7Rf+c2mj9TjEMKvdcSmwu6s/8ulQdC41Iu+r
         N5yBI9VOtCId0Qqi3vJJdLqJoH+t5Y6eMbYkyCjLuK+2ZREZSTAj2yuI+8wJvgDjTVFr
         WKXjnATJ3YCxoMsE/zb6PWf9eFZ1sMdhe738wa+VkGht3d0wscy6mZF75S8l+cHIQS0t
         fKXA==
X-Gm-Message-State: AOAM530Ltdr5KEYp/u2mfRdWhf2jzDGj/Lru77uxpDXwsxBRVWWANhtj
        bU+Lb9ev17ohfhmyE4lH2qk=
X-Google-Smtp-Source: ABdhPJyUFJHoA+7z8clL9UILjD9u5kHwBxvRg6p13ulO3jgawsw4RQqDZIwKyv/hKZOXrpPNobhEbg==
X-Received: by 2002:a05:6402:382:: with SMTP id o2mr34387052edv.370.1619038184161;
        Wed, 21 Apr 2021 13:49:44 -0700 (PDT)
Received: from [192.168.2.2] (81-204-249-205.fixed.kpn.net. [81.204.249.205])
        by smtp.gmail.com with ESMTPSA id z22sm474319edm.57.2021.04.21.13.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 13:49:43 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] net: stmmac: Add RK3566 SoC support
To:     Ezequiel Garcia <ezequiel@collabora.com>, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
References: <20210421203409.40717-1-ezequiel@collabora.com>
 <20210421203409.40717-4-ezequiel@collabora.com>
From:   Johan Jonker <jbx6244@gmail.com>
Message-ID: <a3cef507-6480-eff8-625c-c5167db718f3@gmail.com>
Date:   Wed, 21 Apr 2021 22:49:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20210421203409.40717-4-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/21 10:34 PM, Ezequiel Garcia wrote:
> From: David Wu <david.wu@rock-chips.com>
> 
> Add constants and callback functions for the dwmac present
> on RK3566 SoCs. As can be seen, the base structure
> is the same, only registers and the bits in them moved slightly.
> 
> The dwmac IP core version v5.1, and so the compatible string
> is expected to be:
> 
>   compatible = "rockchip,rk3566-gmac", "snps,dwmac-4.20a";
> 
> Signed-off-by: David Wu <david.wu@rock-chips.com>
> [Ezequiel: Separate rk3566-gmac support]
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  .../bindings/net/rockchip-dwmac.txt           |  1 +
>  .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 89 +++++++++++++++++++
>  2 files changed, 90 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
> index 3b71da7e8742..3bd4bbcd6c65 100644
> --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
> @@ -12,6 +12,7 @@ Required properties:
>     "rockchip,rk3366-gmac": found on RK3366 SoCs
>     "rockchip,rk3368-gmac": found on RK3368 SoCs
>     "rockchip,rk3399-gmac": found on RK3399 SoCs

> +   "rockchip,rk3566-gmac", "snps,dwmac-4.20a": found on RK3566 SoCs

This is still a text document.
rob+dt has now scripts that check for undocumented compatibility
strings, so first convert rockchip-dwmac.txt to YAML and then add this
in a separated patch.

Johan

>     "rockchip,rv1108-gmac": found on RV1108 SoCs
>   - reg: addresses and length of the register sets for the device.
>   - interrupts: Should contain the GMAC interrupts.
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> index d2637d83899e..a8850bcd980f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> @@ -948,6 +948,94 @@ static const struct rk_gmac_ops rk3399_ops = {
>  	.set_rmii_speed = rk3399_set_rmii_speed,
>  };
>  
> +#define RK3568_GRF_GMAC0_CON0		0x0380
> +#define RK3568_GRF_GMAC0_CON1		0x0384
> +#define RK3568_GRF_GMAC1_CON0		0x0388
> +#define RK3568_GRF_GMAC1_CON1		0x038c
> +
> +/* RK3568_GRF_GMAC0_CON1 && RK3568_GRF_GMAC1_CON1 */
> +#define RK3568_GMAC_PHY_INTF_SEL_RGMII	\
> +		(GRF_BIT(4) | GRF_CLR_BIT(5) | GRF_CLR_BIT(6))
> +#define RK3568_GMAC_PHY_INTF_SEL_RMII	\
> +		(GRF_CLR_BIT(4) | GRF_CLR_BIT(5) | GRF_BIT(6))
> +#define RK3568_GMAC_FLOW_CTRL			GRF_BIT(3)
> +#define RK3568_GMAC_FLOW_CTRL_CLR		GRF_CLR_BIT(3)
> +#define RK3568_GMAC_RXCLK_DLY_ENABLE		GRF_BIT(1)
> +#define RK3568_GMAC_RXCLK_DLY_DISABLE		GRF_CLR_BIT(1)
> +#define RK3568_GMAC_TXCLK_DLY_ENABLE		GRF_BIT(0)
> +#define RK3568_GMAC_TXCLK_DLY_DISABLE		GRF_CLR_BIT(0)
> +
> +/* RK3568_GRF_GMAC0_CON0 && RK3568_GRF_GMAC1_CON0 */
> +#define RK3568_GMAC_CLK_RX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 8)
> +#define RK3568_GMAC_CLK_TX_DL_CFG(val)	HIWORD_UPDATE(val, 0x7F, 0)
> +
> +static void rk3566_set_to_rgmii(struct rk_priv_data *bsp_priv,
> +				int tx_delay, int rx_delay)
> +{
> +	struct device *dev = &bsp_priv->pdev->dev;
> +
> +	if (IS_ERR(bsp_priv->grf)) {
> +		dev_err(dev, "Missing rockchip,grf property\n");
> +		return;
> +	}
> +
> +	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> +		     RK3568_GMAC_PHY_INTF_SEL_RGMII |
> +		     RK3568_GMAC_RXCLK_DLY_ENABLE |
> +		     RK3568_GMAC_TXCLK_DLY_ENABLE);
> +
> +	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON0,
> +		     RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> +		     RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> +}
> +
> +static void rk3566_set_to_rmii(struct rk_priv_data *bsp_priv)
> +{
> +	struct device *dev = &bsp_priv->pdev->dev;
> +
> +	if (IS_ERR(bsp_priv->grf)) {
> +		dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
> +		return;
> +	}
> +
> +	regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> +		     RK3568_GMAC_PHY_INTF_SEL_RMII);
> +}
> +
> +static void rk3566_set_gmac_speed(struct rk_priv_data *bsp_priv, int speed)
> +{
> +	struct device *dev = &bsp_priv->pdev->dev;
> +	unsigned long rate;
> +	int ret;
> +
> +	switch (speed) {
> +	case 10:
> +		rate = 2500000;
> +		break;
> +	case 100:
> +		rate = 25000000;
> +		break;
> +	case 1000:
> +		rate = 125000000;
> +		break;
> +	default:
> +		dev_err(dev, "unknown speed value for GMAC speed=%d", speed);
> +		return;
> +	}
> +
> +	ret = clk_set_rate(bsp_priv->clk_mac_speed, rate);
> +	if (ret)
> +		dev_err(dev, "%s: set clk_mac_speed rate %ld failed %d\n",
> +			__func__, rate, ret);
> +}
> +
> +static const struct rk_gmac_ops rk3566_ops = {
> +	.set_to_rgmii = rk3566_set_to_rgmii,
> +	.set_to_rmii = rk3566_set_to_rmii,
> +	.set_rgmii_speed = rk3566_set_gmac_speed,
> +	.set_rmii_speed = rk3566_set_gmac_speed,
> +};
> +
>  #define RV1108_GRF_GMAC_CON0		0X0900
>  
>  /* RV1108_GRF_GMAC_CON0 */
> @@ -1512,6 +1600,7 @@ static const struct of_device_id rk_gmac_dwmac_match[] = {
>  	{ .compatible = "rockchip,rk3366-gmac", .data = &rk3366_ops },
>  	{ .compatible = "rockchip,rk3368-gmac", .data = &rk3368_ops },
>  	{ .compatible = "rockchip,rk3399-gmac", .data = &rk3399_ops },
> +	{ .compatible = "rockchip,rk3566-gmac", .data = &rk3566_ops },
>  	{ .compatible = "rockchip,rv1108-gmac", .data = &rv1108_ops },
>  	{ }
>  };
> 

