Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8CE689ACB
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbjBCN7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbjBCN65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:58:57 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3BEA910B;
        Fri,  3 Feb 2023 05:56:04 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id mc11so15468416ejb.10;
        Fri, 03 Feb 2023 05:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M41FlFBQ7mgIzPbCsx423etKdwTB5ZX9hDQfZf/x5+Y=;
        b=Gn4Wwt1+vc+ukO3ArixF5iilxLrh2bjH73Oxg4fkE6twi8TnRaJH+374qruHTtI/4C
         ixpfrB20/pUv56JSVGjxrkkJ5MkHZmO7qnoRSoqQnBpk/pWK4yA5hvy6b2oZgkXnsWRC
         HuSCzS3EdGblvP3U4Z8D109FS72OQlGIaH5N0+SbNPiZUxLGjkBZhyRgRe7VYh99V5IZ
         f81O8/PFNvbgySZKyunFi8mEgJlYxo4PJICBtQ0NuLSLMwNgj24pZis0UvQEP/4cStwe
         yqTnnW7BRbawpseA7+J36HwSDxc/FhFZQyvcBe8R5MLh/G87OAbtYqLGELID6ABbEgAX
         cDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M41FlFBQ7mgIzPbCsx423etKdwTB5ZX9hDQfZf/x5+Y=;
        b=fbrW2DTkgw7AKMDmcsQtqynvjjw64lMtskaqycyDGB4VgzGDaWTgmcDEGgpSlT/Sih
         tWompT1Aeq9SYZHX76/xKXlOm98u87VVzf4PrvumcxYTJUuNzR/3LT5o7Lk0n/x2dVXi
         E9L/0Wch9QZv3Lmr5DpZDyuc4lKdpbwbFzwbMK5CD2R0v6xdBxjbl/O3JatX7rKPrLEW
         fN24ZeXddw5Xygbz4sjGPwRh+LEEo2JWvAuI6+xum2+r+U1Ik0ZXfpc8vi7sO2QyXV/g
         RSXumrnUJx2X7ozbehWXmL25N12d4NOPTBvgV9HzimvP+2uf6BpFLIbHNHN329WUY6ol
         Em8Q==
X-Gm-Message-State: AO0yUKUXPiShwI2ssHBxVzQCKKnE6mqxpWN7Ec480v0hHrpX5MFl8p7S
        T3JrgGBGQd6LxpauL39dhuc=
X-Google-Smtp-Source: AK7set8o1uoM+srfOLO+Xw7mNZW0xKUWApvKf2668pmR3rpb0xvCL+4QZWPZJaKbl/GzBX95hwc0WQ==
X-Received: by 2002:a17:907:3e82:b0:87d:5ba:c2da with SMTP id hs2-20020a1709073e8200b0087d05bac2damr13585778ejc.41.1675432507578;
        Fri, 03 Feb 2023 05:55:07 -0800 (PST)
Received: from ?IPV6:2a01:c23:b81c:5800:35d1:8a7b:e98f:ea5? (dynamic-2a01-0c23-b81c-5800-35d1-8a7b-e98f-0ea5.c23.pool.telefonica.de. [2a01:c23:b81c:5800:35d1:8a7b:e98f:ea5])
        by smtp.googlemail.com with ESMTPSA id cw20-20020a170906c79400b008787c8427c1sm1390120ejb.214.2023.02.03.05.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 05:55:07 -0800 (PST)
Message-ID: <0f81d14d-50cb-b807-b103-8fa066d0769c@gmail.com>
Date:   Fri, 3 Feb 2023 14:55:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michael@walle.cc
References: <20230203122542.436305-1-horatiu.vultur@microchip.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230203122542.436305-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.02.2023 13:25, Horatiu Vultur wrote:
> The LAN8841 is completely integrated triple-speed (10BASE-T/ 100BASE-TX/
> 1000BASE-T) Ethernet physical layer transceivers for transmission and
> reception of data on standard CAT-5, as well as CAT-5e and CAT-6,
> unshielded twisted pair (UTP) cables.
> The LAN8841 offers the industry-standard GMII/MII as well as the RGMII.
> Some of the features of the PHY are:
> - Wake on LAN
> - Auto-MDIX
> - IEEE 1588-2008 (V2)
> - LinkMD Capable diagnosis
> 
> Currently the patch offers support only for link configuration.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> v1->v2:
> - Remove hardcoded values
> - Fix typo in commit message
> ---
>  drivers/net/phy/micrel.c   | 227 +++++++++++++++++++++++++++++++++++--
>  include/linux/micrel_phy.h |   1 +
>  2 files changed, 219 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index d5b80c31ab91c..53c37ac66c343 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -26,6 +26,7 @@
>  #include <linux/phy.h>
>  #include <linux/micrel_phy.h>
>  #include <linux/of.h>
> +#include <linux/irq.h>
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/ptp_clock_kernel.h>
> @@ -268,6 +269,9 @@ struct kszphy_type {
>  	u16 interrupt_level_mask;
>  	u16 cable_diag_reg;
>  	unsigned long pair_mask;
> +	u16 disable_dll_tx_bit;
> +	u16 disable_dll_rx_bit;
> +	u16 disable_dll_mask;
>  	bool has_broadcast_disable;
>  	bool has_nand_tree_disable;
>  	bool has_rmii_ref_clk_sel;
> @@ -364,6 +368,19 @@ static const struct kszphy_type ksz9021_type = {
>  	.interrupt_level_mask	= BIT(14),
>  };
>  
> +static const struct kszphy_type ksz9131_type = {
> +	.interrupt_level_mask	= BIT(14),
> +	.disable_dll_tx_bit	= BIT(12),
> +	.disable_dll_rx_bit	= BIT(12),
> +	.disable_dll_mask	= BIT_MASK(12),
> +};
> +
> +static const struct kszphy_type lan8841_type = {
> +	.disable_dll_tx_bit	= BIT(14),
> +	.disable_dll_rx_bit	= BIT(14),
> +	.disable_dll_mask	= BIT_MASK(14),
> +};
> +
>  static int kszphy_extended_write(struct phy_device *phydev,
>  				u32 regnum, u16 val)
>  {
> @@ -1172,19 +1189,18 @@ static int ksz9131_of_load_skew_values(struct phy_device *phydev,
>  #define KSZ9131RN_MMD_COMMON_CTRL_REG	2
>  #define KSZ9131RN_RXC_DLL_CTRL		76
>  #define KSZ9131RN_TXC_DLL_CTRL		77
> -#define KSZ9131RN_DLL_CTRL_BYPASS	BIT_MASK(12)
>  #define KSZ9131RN_DLL_ENABLE_DELAY	0
> -#define KSZ9131RN_DLL_DISABLE_DELAY	BIT(12)
>  
>  static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
>  {
> +	const struct kszphy_type *type = phydev->drv->driver_data;
>  	u16 rxcdll_val, txcdll_val;
>  	int ret;
>  
>  	switch (phydev->interface) {
>  	case PHY_INTERFACE_MODE_RGMII:
> -		rxcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> -		txcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		rxcdll_val = type->disable_dll_rx_bit;
> +		txcdll_val = type->disable_dll_tx_bit;
>  		break;
>  	case PHY_INTERFACE_MODE_RGMII_ID:
>  		rxcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> @@ -1192,10 +1208,10 @@ static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
>  		break;
>  	case PHY_INTERFACE_MODE_RGMII_RXID:
>  		rxcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> -		txcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		txcdll_val = type->disable_dll_tx_bit;
>  		break;
>  	case PHY_INTERFACE_MODE_RGMII_TXID:
> -		rxcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		rxcdll_val = type->disable_dll_rx_bit;
>  		txcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
>  		break;
>  	default:
> @@ -1203,13 +1219,13 @@ static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
>  	}
>  
>  	ret = phy_modify_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
> -			     KSZ9131RN_RXC_DLL_CTRL, KSZ9131RN_DLL_CTRL_BYPASS,
> +			     KSZ9131RN_RXC_DLL_CTRL, type->disable_dll_mask,
>  			     rxcdll_val);
>  	if (ret < 0)
>  		return ret;
>  
>  	return phy_modify_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
> -			      KSZ9131RN_TXC_DLL_CTRL, KSZ9131RN_DLL_CTRL_BYPASS,
> +			      KSZ9131RN_TXC_DLL_CTRL, type->disable_dll_mask,
>  			      txcdll_val);
>  }
>  
> @@ -3152,6 +3168,183 @@ static int lan8814_probe(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +#define LAN8841_MMD_TIMER_REG			0
> +#define LAN8841_MMD0_REGISTER_17		17
> +#define LAN8841_MMD0_REGISTER_17_DROP_OPT(x)	((x) & 0x3)
> +#define LAN8841_MMD0_REGISTER_17_XMIT_TOG_TX_DIS	BIT(3)
> +#define LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG	2
> +#define LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG_MAGJACK	BIT(14)
> +#define LAN8841_MMD_ANALOG_REG			28
> +#define LAN8841_ANALOG_CONTROL_1		1
> +#define LAN8841_ANALOG_CONTROL_1_PLL_TRIM(x)	(((x) & 0x3) << 5)
> +#define LAN8841_ANALOG_CONTROL_10		13
> +#define LAN8841_ANALOG_CONTROL_10_PLL_DIV(x)	((x) & 0x3)
> +#define LAN8841_ANALOG_CONTROL_11		14
> +#define LAN8841_ANALOG_CONTROL_11_LDO_REF(x)	(((x) & 0x7) << 12)
> +#define LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT	69
> +#define LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT_VAL 0xbffc
> +#define LAN8841_BTRX_POWER_DOWN			70
> +#define LAN8841_BTRX_POWER_DOWN_QBIAS_CH_A	BIT(0)
> +#define LAN8841_BTRX_POWER_DOWN_BTRX_CH_A	BIT(1)
> +#define LAN8841_BTRX_POWER_DOWN_QBIAS_CH_B	BIT(2)
> +#define LAN8841_BTRX_POWER_DOWN_BTRX_CH_B	BIT(3)
> +#define LAN8841_BTRX_POWER_DOWN_BTRX_CH_C	BIT(5)
> +#define LAN8841_BTRX_POWER_DOWN_BTRX_CH_D	BIT(7)
> +#define LAN8841_ADC_CHANNEL_MASK		198
> +static int lan8841_config_init(struct phy_device *phydev)
> +{
> +	char *rx_data_skews[4] = {"rxd0-skew-psec", "rxd1-skew-psec",
> +				  "rxd2-skew-psec", "rxd3-skew-psec"};
> +	char *tx_data_skews[4] = {"txd0-skew-psec", "txd1-skew-psec",
> +				  "txd2-skew-psec", "txd3-skew-psec"};
> +	char *clk_skews[2] = {"rxc-skew-psec", "txc-skew-psec"};
> +	struct device_node *of_node;
> +	int ret;
> +
> +	if (phy_interface_is_rgmii(phydev)) {
> +		ret = ksz9131_config_rgmii_delay(phydev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	of_node = phydev->mdio.dev.of_node;
> +	if (!of_node)
> +		goto hw_init;
> +
> +	ret = ksz9131_of_load_skew_values(phydev, of_node,
> +					  MII_KSZ9031RN_CLK_PAD_SKEW, 5,
> +					  clk_skews, 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ksz9131_of_load_skew_values(phydev, of_node,
> +					  MII_KSZ9031RN_RX_DATA_PAD_SKEW, 4,
> +					  rx_data_skews, 4);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ksz9131_of_load_skew_values(phydev, of_node,
> +					  MII_KSZ9031RN_TX_DATA_PAD_SKEW, 4,
> +					  tx_data_skews, 4);
> +	if (ret < 0)
> +		return ret;
> +
> +hw_init:
> +	/* 100BT Clause 40 improvenent errata */
> +	phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +		      LAN8841_ANALOG_CONTROL_1,
> +		      LAN8841_ANALOG_CONTROL_1_PLL_TRIM(0x2));
> +	phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +		      LAN8841_ANALOG_CONTROL_10,
> +		      LAN8841_ANALOG_CONTROL_10_PLL_DIV(0x1));
> +
> +	/* 10M/100M Ethernet Signal Tuning Errata for Shorted-Center Tap
> +	 * Magnetics
> +	 */
> +	ret = phy_read_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
> +			   LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG);
> +	if (ret & LAN8841_OPERATION_MODE_STRAP_OVERRIDE_LOW_REG_MAGJACK) {
> +		phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +			      LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT,
> +			      LAN8841_TX_LOW_I_CH_C_D_POWER_MANAGMENT_VAL);
> +		phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +			      LAN8841_BTRX_POWER_DOWN,
> +			      LAN8841_BTRX_POWER_DOWN_QBIAS_CH_A |
> +			      LAN8841_BTRX_POWER_DOWN_BTRX_CH_A |
> +			      LAN8841_BTRX_POWER_DOWN_QBIAS_CH_B |
> +			      LAN8841_BTRX_POWER_DOWN_BTRX_CH_B |
> +			      LAN8841_BTRX_POWER_DOWN_BTRX_CH_C |
> +			      LAN8841_BTRX_POWER_DOWN_BTRX_CH_D);
> +	}
> +
> +	/* LDO Adjustment errata */
> +	phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
> +		      LAN8841_ANALOG_CONTROL_11,
> +		      LAN8841_ANALOG_CONTROL_11_LDO_REF(1));
> +
> +	/* 100BT RGMII latency tuning errata */
> +	phy_write_mmd(phydev, MDIO_MMD_PMAPMD,
> +		      LAN8841_ADC_CHANNEL_MASK, 0x0);
> +	phy_write_mmd(phydev, LAN8841_MMD_TIMER_REG,
> +		      LAN8841_MMD0_REGISTER_17,
> +		      LAN8841_MMD0_REGISTER_17_DROP_OPT(2) |
> +		      LAN8841_MMD0_REGISTER_17_XMIT_TOG_TX_DIS);
> +
> +	return 0;
> +}
> +
> +#define LAN8841_OUTPUT_CTRL			25
> +#define LAN8841_OUTPUT_CTRL_INT_BUFFER		BIT(14)
> +#define LAN8841_CTRL				31
> +#define LAN8841_CTRL_INTR_POLARITY		BIT(14)
> +static int lan8841_config_intr(struct phy_device *phydev)
> +{
> +	struct irq_data *irq_data;
> +	int temp = 0;
> +
> +	irq_data = irq_get_irq_data(phydev->irq);
> +	if (!irq_data)
> +		return 0;
> +
> +	if (irqd_get_trigger_type(irq_data) & IRQ_TYPE_LEVEL_HIGH) {
> +		/* Change polarity of the interrupt */

Why this a little bit esoteric logic? Can't you set the interrupt
to level-low in the chip (like most other ones), and then define
the polarity the usual way e.g. in DT?

> +		phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> +			   LAN8841_OUTPUT_CTRL_INT_BUFFER,
> +			   LAN8841_OUTPUT_CTRL_INT_BUFFER);
> +		phy_modify(phydev, LAN8841_CTRL,
> +			   LAN8841_CTRL_INTR_POLARITY,
> +			   LAN8841_CTRL_INTR_POLARITY);
> +	} else {
> +		/* It is enough to set INT buffer to open-drain because then
> +		 * the interrupt will be active low.
> +		 */
> +		phy_modify(phydev, LAN8841_OUTPUT_CTRL,
> +			   LAN8841_OUTPUT_CTRL_INT_BUFFER, 0);
> +	}
> +
> +	/* enable / disable interrupts */
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		temp = LAN8814_INT_LINK;
> +
> +	return phy_write(phydev, LAN8814_INTC, temp);
> +}
> +
> +static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
> +{
> +	int irq_status;
> +
> +	irq_status = phy_read(phydev, LAN8814_INTS);
> +	if (irq_status < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	if (irq_status & LAN8814_INT_LINK) {
> +		phy_trigger_machine(phydev);
> +		return IRQ_HANDLED;
> +	}
> +
> +	return IRQ_NONE;
> +}
> +
> +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER 3
> +#define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN BIT(0)
> +static int lan8841_probe(struct phy_device *phydev)
> +{
> +	int err;
> +
> +	err = kszphy_probe(phydev);
> +	if (err)
> +		return err;
> +
> +	if (phy_read_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
> +			 LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER) &
> +	    LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN)
> +		phydev->interface = PHY_INTERFACE_MODE_RGMII_RXID;
> +
> +	return 0;
> +}
> +
>  static struct phy_driver ksphy_driver[] = {
>  {
>  	.phy_id		= PHY_ID_KS8737,
> @@ -3361,13 +3554,28 @@ static struct phy_driver ksphy_driver[] = {
>  	.resume		= kszphy_resume,
>  	.config_intr	= lan8804_config_intr,
>  	.handle_interrupt = lan8804_handle_interrupt,
> +}, {
> +	.phy_id		= PHY_ID_LAN8841,
> +	.phy_id_mask	= MICREL_PHY_ID_MASK,
> +	.name		= "Microchip LAN8841 Gigabit PHY",
> +	.driver_data	= &lan8841_type,
> +	.config_init	= lan8841_config_init,
> +	.probe		= lan8841_probe,
> +	.soft_reset	= genphy_soft_reset,
> +	.config_intr	= lan8841_config_intr,
> +	.handle_interrupt = lan8841_handle_interrupt,
> +	.get_sset_count = kszphy_get_sset_count,
> +	.get_strings	= kszphy_get_strings,
> +	.get_stats	= kszphy_get_stats,
> +	.suspend	= genphy_suspend,
> +	.resume		= genphy_resume,
>  }, {
>  	.phy_id		= PHY_ID_KSZ9131,
>  	.phy_id_mask	= MICREL_PHY_ID_MASK,
>  	.name		= "Microchip KSZ9131 Gigabit PHY",
>  	/* PHY_GBIT_FEATURES */
>  	.flags		= PHY_POLL_CABLE_TEST,
> -	.driver_data	= &ksz9021_type,
> +	.driver_data	= &ksz9131_type,
>  	.probe		= kszphy_probe,
>  	.config_init	= ksz9131_config_init,
>  	.config_intr	= kszphy_config_intr,
> @@ -3446,6 +3654,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
>  	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
>  	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
>  	{ PHY_ID_LAN8804, MICREL_PHY_ID_MASK },
> +	{ PHY_ID_LAN8841, MICREL_PHY_ID_MASK },
>  	{ }
>  };
>  
> diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
> index 771e050883db7..8bef1ab62bba3 100644
> --- a/include/linux/micrel_phy.h
> +++ b/include/linux/micrel_phy.h
> @@ -31,6 +31,7 @@
>  #define PHY_ID_KSZ9131		0x00221640
>  #define PHY_ID_LAN8814		0x00221660
>  #define PHY_ID_LAN8804		0x00221670
> +#define PHY_ID_LAN8841		0x00221650
>  
>  #define PHY_ID_KSZ886X		0x00221430
>  #define PHY_ID_KSZ8863		0x00221435

