Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AC257D4D7
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbiGUUfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbiGUUfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:35:38 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8AA4E840;
        Thu, 21 Jul 2022 13:35:36 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id z23so5076059eju.8;
        Thu, 21 Jul 2022 13:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=mV/dw7vkpS6dqZh16XxyiXycD9pTjTsGfMdvE5yLq8o=;
        b=g9kp/TvFvMzRDLWx0dMOfD2iH1Ro/KmgVlw1R3yhsOhp1AAUM0K29u+v3Oj1t0RAsM
         9gWwDceB8DPYyaUZA1cqjs9FSrV+SwV2YLRYSgjLLhJ5yjqGALM92JRgSbVUqugMkgaH
         FVQGAoAL8wyxouJ36BkcObai5KT+PMJnOPrqm2GsD+onrUWwcl9wXtHNRk79qE3dBFyJ
         5YCqQ0P5Cd5GRa/vPTqk49I6FtLVTLUBGHBJc3yPetSaRS18EB4X3M8MRVeFfWy/o7PC
         DhAEaFRl0Tev0cRvabIMes6rkGmrGetdc27ZvDSJSlqLsmz7O0FYmynVVQZZMO1vdRHu
         CClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=mV/dw7vkpS6dqZh16XxyiXycD9pTjTsGfMdvE5yLq8o=;
        b=XgGgDS6daQWkxGJCJtAERSW+j5F3vsObASCtg9Oy6TtExlJt5eqGdfbe3XkJQtcMfP
         S4u5AP+cbzil2njKpAplEUeRj5GSpkl+L+mWzHMzMunMIDJpKsmt58ekZ2H2AqQLb/v/
         KdBXZSaN/KAkGkndkvZD6HzMZge1Jv5H/rj34vKGCP+y36b5GGcXkgDXTHQglqPimQFQ
         4HfURp1R+QGXAnaPQfJfE5oEKIfxbvY4xMmTyRZQ4aJvKdgzsfHtBYXC/MhemrHxYm2V
         iSaypZpm05WpxqALxNuMqYVfqzw/X6WI5egs0/HtUx/OSjjhIGjgARMiImBISGYphOvQ
         q91w==
X-Gm-Message-State: AJIora+XAhWk+ntmn+XjDqxR1PufoRWOjYAMG196OAkrU9Px8LoaZvuE
        4B36sTWV9wtzn4m/cqaNUk2q5YI6l/Q=
X-Google-Smtp-Source: AGRyM1tvboGHiZgeI1dBfLVJJ6Hn+aFO5AbWerH8UMOmMnBmGB7bx6BP55wq6EKFabtg1VPd9Z1eWA==
X-Received: by 2002:a17:907:7f8e:b0:72f:11ec:f5f8 with SMTP id qk14-20020a1709077f8e00b0072f11ecf5f8mr278485ejc.343.1658435734463;
        Thu, 21 Jul 2022 13:35:34 -0700 (PDT)
Received: from ?IPV6:2a01:c22:6e18:3e00:5147:bc1c:8bf1:863a? (dynamic-2a01-0c22-6e18-3e00-5147-bc1c-8bf1-863a.c22.pool.telefonica.de. [2a01:c22:6e18:3e00:5147:bc1c:8bf1:863a])
        by smtp.googlemail.com with ESMTPSA id y3-20020aa7ccc3000000b0043577da51f1sm1558873edt.81.2022.07.21.13.35.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 13:35:33 -0700 (PDT)
Message-ID: <356f4285-1e83-ab14-c890-4131acd8e61d@gmail.com>
Date:   Thu, 21 Jul 2022 22:35:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Chunhao Lin <hau@realtek.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org
References: <20220721144550.4405-1-hau@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
In-Reply-To: <20220721144550.4405-1-hau@realtek.com>
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

On 21.07.2022 16:45, Chunhao Lin wrote:
> rtl8168h(revid 0x2a) + rtl8211fs is for fiber related application.
> rtl8168h will control rtl8211fs via its eeprom or gpo pins.

RTL8168h has an integrated PHY, how is it with rev 0x2a? Can this version
be used with an external PHY only?
And how about the case that somebody combines this chip version with
another PHY that supports fiber? It seems the code makes the assumption
that rev2a is always coupled with an external RTL8211FS.

Are there any realworld devices that use RTL8168H with fiber?

> Fiber module will be connected to rtl8211fs. The link speed between
> rtl8168h and rtl8211fs is decied by fiber module.
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 315 +++++++++++++++++++++-
>  1 file changed, 313 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 1b7fdb4f056b..aa817e2f919a 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -344,6 +344,15 @@ enum rtl8125_registers {
>  	EEE_TXIDLE_TIMER_8125	= 0x6048,
>  };
>  
> +enum rtl8168_sfp_registers {
> +	MDIO_IN			= 0xdc04,
> +	PINOE			= 0xdc06,
> +	PIN_I_SEL_1		= 0xdc08,
> +	PIN_I_SEL_2		= 0xdc0A,
> +	PINPU			= 0xdc18,
> +	GPOUTPIN_SEL	= 0xdc20,
> +};
> +
>  #define RX_VLAN_INNER_8125	BIT(22)
>  #define RX_VLAN_OUTER_8125	BIT(23)
>  #define RX_VLAN_8125		(RX_VLAN_INNER_8125 | RX_VLAN_OUTER_8125)
> @@ -584,6 +593,30 @@ struct rtl8169_tc_offsets {
>  	__le16	rx_missed;
>  };
>  
> +struct rtl_sfp_if_info {
> +	u16 mdio_oe_i;
> +	u16 mdio_oe_o;
> +	u16 mdio_pu;
> +	u16 mdio_pd;
> +	u16 mdc_pu;
> +	u16 mdc_pd;
> +};
> +
> +struct rtl_sfp_if_mask {
> +	const u16 pin_mask;
> +	const u16 mdio_oe_mask;
> +	const u16 mdio_mask;
> +	const u16 mdc_mask;
> +	const u16 phy_addr;
> +	const u16 rb_pos;
> +};
> +
> +struct rtl_sfp_if_mask rtl_sfp_if_eeprom_mask = {
> +	0x0050, 0x0040, 0x000f, 0x0f00, 0, 6};
> +
> +struct rtl_sfp_if_mask rtl_sfp_if_gpo_mask = {
> +	0x0210, 0x0200, 0xf000, 0x0f00, 1, 9};
> +
>  enum rtl_flag {
>  	RTL_FLAG_TASK_ENABLED = 0,
>  	RTL_FLAG_TASK_RESET_PENDING,
> @@ -596,6 +629,12 @@ enum rtl_dash_type {
>  	RTL_DASH_EP,
>  };
>  
> +enum rtl_sfp_if_type {
> +	RTL_SFP_IF_NONE,
> +	RTL_SFP_IF_EEPROM,
> +	RTL_SFP_IF_GPIO,
> +};
> +
>  struct rtl8169_private {
>  	void __iomem *mmio_addr;	/* memory map physical address */
>  	struct pci_dev *pci_dev;
> @@ -635,6 +674,8 @@ struct rtl8169_private {
>  	struct rtl_fw *rtl_fw;
>  
>  	u32 ocp_base;
> +
> +	enum rtl_sfp_if_type sfp_if_type;
>  };
>  
>  typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
> @@ -914,8 +955,12 @@ static void r8168g_mdio_write(struct rtl8169_private *tp, int reg, int value)
>  	if (tp->ocp_base != OCP_STD_PHY_BASE)
>  		reg -= 0x10;
>  
> -	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR)
> +	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR) {
> +		if (tp->sfp_if_type != RTL_SFP_IF_NONE && value & BMCR_PDOWN)
> +			return;
> +
>  		rtl8168g_phy_suspend_quirk(tp, value);
> +	}
>  
>  	r8168_phy_ocp_write(tp, tp->ocp_base + reg * 2, value);
>  }
> @@ -1214,6 +1259,266 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
>  	}
>  }
>  
> +static void rtl_sfp_shift_bit_in(struct rtl8169_private *tp,
> +				  struct rtl_sfp_if_info *sfp_if_info, u32 val, int count)
> +{
> +	int i;
> +	const u16 mdc_reg = PIN_I_SEL_1;
> +	const u16 mdio_reg = PIN_I_SEL_2;
> +
> +	for (i = (count - 1); i >= 0; i--) {
> +		r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info->mdc_pd);
> +		if (val & BIT(i))
> +			r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info->mdio_pu);
> +		else
> +			r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info->mdio_pd);
> +		r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info->mdc_pu);
> +	}
> +}
> +
> +static u16 rtl_sfp_shift_bit_out(struct rtl8169_private *tp,
> +				  struct rtl_sfp_if_info *sfp_if_info, u16 rb_pos)
> +{
> +	int i;
> +	u16 data = 0;
> +	const u16 mdc_reg = PIN_I_SEL_1;
> +	const u16 mdio_in_reg = MDIO_IN;
> +
> +	for (i = 15; i >= 0; i--) {
> +		r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info->mdc_pu);
> +		r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info->mdc_pd);
> +		data += r8168_mac_ocp_read(tp, mdio_in_reg) & BIT(rb_pos) ? BIT(i) : 0;
> +	}
> +
> +	return data;
> +}
> +
> +static void rtl_select_sfp_if(struct rtl8169_private *tp,
> +				  struct rtl_sfp_if_mask *sfp_if_mask,
> +				  struct rtl_sfp_if_info *sfp_if_info)
> +{
> +	u16 pinoe_value, pin_i_sel_1_value, pin_i_sel_2_value;
> +
> +	r8168_mac_ocp_modify(tp, PINPU, sfp_if_mask->pin_mask, 0);
> +	r8168_mac_ocp_modify(tp, PINOE, 0, sfp_if_mask->pin_mask);
> +
> +	pinoe_value = r8168_mac_ocp_read(tp, PINOE);
> +	pin_i_sel_1_value = r8168_mac_ocp_read(tp, PIN_I_SEL_1);
> +	pin_i_sel_2_value = r8168_mac_ocp_read(tp, PIN_I_SEL_2);
> +
> +	sfp_if_info->mdio_oe_i = pinoe_value & ~sfp_if_mask->mdio_oe_mask;
> +	sfp_if_info->mdio_oe_o = pinoe_value | sfp_if_mask->mdio_oe_mask;
> +	sfp_if_info->mdio_pd = pin_i_sel_2_value & ~sfp_if_mask->mdio_mask;
> +	sfp_if_info->mdio_pu = pin_i_sel_2_value | sfp_if_mask->mdio_mask;
> +	sfp_if_info->mdc_pd = pin_i_sel_1_value & ~sfp_if_mask->mdc_mask;
> +	sfp_if_info->mdc_pu = pin_i_sel_1_value | sfp_if_mask->mdc_mask;
> +}
> +
> +#define RT_SFP_ST (1)
> +#define RT_SFP_OP_W (1)
> +#define RT_SFP_OP_R (2)
> +#define RT_SFP_TA_W (2)
> +#define RT_SFP_TA_R (0)
> +
> +static void rtl_sfp_if_write(struct rtl8169_private *tp,
> +				  struct rtl_sfp_if_mask *sfp_if_mask, u8 reg, u16 val)
> +{
> +	struct rtl_sfp_if_info sfp_if_info = {0};
> +	const u16 mdc_reg = PIN_I_SEL_1;
> +	const u16 mdio_reg = PIN_I_SEL_2;
> +
> +	rtl_select_sfp_if(tp, sfp_if_mask, &sfp_if_info);
> +
> +	/* change to output mode */
> +	r8168_mac_ocp_write(tp, PINOE, sfp_if_info.mdio_oe_o);
> +
> +	/* init sfp interface */
> +	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pd);
> +	r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info.mdio_pu);
> +
> +	/* preamble 32bit of 1 */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, 0xffffffff, 32);
> +
> +	/* opcode write */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_ST, 2);
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_OP_W, 2);
> +
> +	/* phy address */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, sfp_if_mask->phy_addr, 5);
> +
> +	/* phy reg */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, reg, 5);
> +
> +	/* turn-around(TA) */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_TA_W, 2);
> +
> +	/* write phy data */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, val, 16);
> +}
> +
> +static u16 rtl_sfp_if_read(struct rtl8169_private *tp,
> +				  struct rtl_sfp_if_mask *sfp_if_mask, u8 reg)
> +{
> +	struct rtl_sfp_if_info sfp_if_info = {0};
> +	const u16 mdc_reg = PIN_I_SEL_1;
> +	const u16 mdio_reg = PIN_I_SEL_2;
> +
> +	rtl_select_sfp_if(tp, sfp_if_mask, &sfp_if_info);
> +
> +	/* change to output mode */
> +	r8168_mac_ocp_write(tp, PINOE, sfp_if_info.mdio_oe_o);
> +
> +	/* init sfp interface */
> +	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pd);
> +	r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info.mdio_pd);
> +
> +	/* preamble 32bit of 1 */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, 0xffffffff, 32);
> +
> +	/* opcode read */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_ST, 2);
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_OP_R, 2);
> +
> +	/* phy address */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, sfp_if_mask->phy_addr, 5);
> +
> +	/* phy reg */
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, reg, 5);
> +
> +	/* turn-around(TA) */
> +	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pd);
> +	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pu);
> +	rtl_sfp_shift_bit_in(tp, &sfp_if_info, 0, 1);
> +
> +	/* change to input mode */
> +	r8168_mac_ocp_write(tp, PINOE, sfp_if_info.mdio_oe_i);
> +
> +	/* read phy data */
> +	return rtl_sfp_shift_bit_out(tp, &sfp_if_info, sfp_if_mask->rb_pos);
> +}
> +
> +static void rtl_sfp_eeprom_write(struct rtl8169_private *tp, u8 reg,
> +				  u16 val)
> +{
> +	rtl_sfp_if_write(tp, &rtl_sfp_if_eeprom_mask, reg, val);
> +}
> +
> +static u16 rtl_sfp_eeprom_read(struct rtl8169_private *tp, u8 reg)
> +{
> +	return rtl_sfp_if_read(tp, &rtl_sfp_if_eeprom_mask, reg);
> +}
> +
> +static void rtl_sfp_gpo_write(struct rtl8169_private *tp, u8 reg,
> +				  u16 val)
> +{
> +	rtl_sfp_if_write(tp, &rtl_sfp_if_gpo_mask, reg, val);
> +}
> +
> +static u16 rtl_sfp_gpo_read(struct rtl8169_private *tp, u8 reg)
> +{
> +	return rtl_sfp_if_read(tp, &rtl_sfp_if_gpo_mask, reg);
> +}
> +
> +static void rtl_sfp_mdio_write(struct rtl8169_private *tp,
> +				  u8 reg,
> +				  u16 val)
> +{
> +	switch (tp->sfp_if_type) {
> +	case RTL_SFP_IF_EEPROM:
> +		return rtl_sfp_eeprom_write(tp, reg, val);
> +	case RTL_SFP_IF_GPIO:
> +		return rtl_sfp_gpo_write(tp, reg, val);
> +	default:
> +		return;
> +	}
> +}
> +
> +static u16 rtl_sfp_mdio_read(struct rtl8169_private *tp,
> +				  u8 reg)
> +{
> +	switch (tp->sfp_if_type) {
> +	case RTL_SFP_IF_EEPROM:
> +		return rtl_sfp_eeprom_read(tp, reg);
> +	case RTL_SFP_IF_GPIO:
> +		return rtl_sfp_gpo_read(tp, reg);
> +	default:
> +		return 0xffff;
> +	}
> +}
> +
> +static void rtl_sfp_mdio_modify(struct rtl8169_private *tp, u32 reg, u16 mask,
> +				 u16 set)
> +{
> +	u16 data = rtl_sfp_mdio_read(tp, reg);
> +
> +	rtl_sfp_mdio_write(tp, reg, (data & ~mask) | set);
> +}
> +
> +#define RTL8211FS_PHY_ID_1 0x001c
> +#define RTL8211FS_PHY_ID_2 0xc916
> +
> +static enum rtl_sfp_if_type rtl8168h_check_sfp(struct rtl8169_private *tp)
> +{
> +	int i;
> +	int const checkcnt = 4;
> +
> +	rtl_sfp_eeprom_write(tp, 0x1f, 0x0000);
> +	for (i = 0; i < checkcnt; i++) {
> +		if (rtl_sfp_eeprom_read(tp, 0x02) != RTL8211FS_PHY_ID_1 ||
> +			rtl_sfp_eeprom_read(tp, 0x03) != RTL8211FS_PHY_ID_2)
> +			break;
> +	}
> +
> +	if (i == checkcnt)
> +		return RTL_SFP_IF_EEPROM;
> +
> +	rtl_sfp_gpo_write(tp, 0x1f, 0x0000);
> +	for (i = 0; i < checkcnt; i++) {
> +		if (rtl_sfp_gpo_read(tp, 0x02) != RTL8211FS_PHY_ID_1 ||
> +			rtl_sfp_gpo_read(tp, 0x03) != RTL8211FS_PHY_ID_2)
> +			break;
> +	}
> +
> +	if (i == checkcnt)
> +		return RTL_SFP_IF_GPIO;
> +
> +	return RTL_SFP_IF_NONE;
> +}
> +
> +static enum rtl_sfp_if_type rtl_check_sfp(struct rtl8169_private *tp)
> +{
> +	switch (tp->mac_version) {
> +	case RTL_GIGA_MAC_VER_45:
> +	case RTL_GIGA_MAC_VER_46:
> +		if (tp->pci_dev->revision == 0x2a)
> +			return rtl8168h_check_sfp(tp);
> +		else
> +			return RTL_SFP_IF_NONE;
> +	default:
> +		return RTL_SFP_IF_NONE;
> +	}
> +}
> +
> +static void rtl_hw_sfp_phy_config(struct rtl8169_private *tp)
> +{
> +	/* disable ctap */
> +	rtl_sfp_mdio_write(tp, 0x1f, 0x0a43);
> +	rtl_sfp_mdio_modify(tp, 0x19, BIT(6), 0);
> +
> +	/* change Rx threshold */
> +	rtl_sfp_mdio_write(tp, 0x1f, 0x0dcc);
> +	rtl_sfp_mdio_modify(tp, 0x14, 0, BIT(2) | BIT(3) | BIT(4));
> +
> +	/* switch pin34 to PMEB pin */
> +	rtl_sfp_mdio_write(tp, 0x1f, 0x0d40);
> +	rtl_sfp_mdio_modify(tp, 0x16, 0, BIT(5));
> +
> +	rtl_sfp_mdio_write(tp, 0x1f, 0x0000);
> +
> +	/* disable ctap */
> +	phy_modify_paged(tp->phydev, 0x0a43, 0x11, BIT(6), 0);
> +}
> +
>  static void rtl_set_d3_pll_down(struct rtl8169_private *tp, bool enable)
>  {
>  	switch (tp->mac_version) {
> @@ -2195,6 +2500,9 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
>  	    tp->pci_dev->subsystem_device == 0xe000)
>  		phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
>  
> +	if (tp->sfp_if_type != RTL_SFP_IF_NONE)
> +		rtl_hw_sfp_phy_config(tp);
> +
>  	/* We may have called phy_speed_down before */
>  	phy_speed_up(tp->phydev);
>  
> @@ -2251,7 +2559,8 @@ static void rtl_prepare_power_down(struct rtl8169_private *tp)
>  		rtl_ephy_write(tp, 0x19, 0xff64);
>  
>  	if (device_may_wakeup(tp_to_dev(tp))) {
> -		phy_speed_down(tp->phydev, false);
> +		if (tp->sfp_if_type == RTL_SFP_IF_NONE)
> +			phy_speed_down(tp->phydev, false);
>  		rtl_wol_enable_rx(tp);
>  	}
>  }
> @@ -5386,6 +5695,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	tp->dash_type = rtl_check_dash(tp);
>  
> +	tp->sfp_if_type = rtl_check_sfp(tp);
> +
>  	tp->cp_cmd = RTL_R16(tp, CPlusCmd) & CPCMD_MASK;
>  
>  	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&

