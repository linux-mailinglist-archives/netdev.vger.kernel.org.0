Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A935F877F
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 23:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJHVhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 17:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJHVhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 17:37:00 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D8632AA6
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 14:36:55 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j16so11908437wrh.5
        for <netdev@vger.kernel.org>; Sat, 08 Oct 2022 14:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7uG3ZwoeJ8S2/+XBx7dcqkAeHVN6aRkkIkDhwYHA8VU=;
        b=QpdsECDF+2BKbJ6TvJCCJhqSV/EvBgYuvZZ8A+7Tyi6JXo1Cr7g6iN07KZLgbWM0Xx
         9sJ7ksATUuKBlX6krzaTbdirHTR+PJTVNuEp/Em0+CtwQeW/6tXyYh8eEcF2OGF1pgU8
         pnDUBTJetZiV1Z0CsWii43iSENwWudgMXUHIxn7N+p35FC5RDdGypHFx26ccnTaqb6fH
         QILiO1f46/J5UEfdB9I4egj3YeAsUcDS0w4sACIxbm1Z5ASpB8LLmTi36pC/OgvpV9zb
         +dsWfqYJ/BJ69ia6Tpcu3YuCPj35jBpu4jdh1OQrm6EK6UWs1/jASx9kzQiW42vpqWEL
         gQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7uG3ZwoeJ8S2/+XBx7dcqkAeHVN6aRkkIkDhwYHA8VU=;
        b=H0VFkISl/QOGXRWSMYcAY6gOItCIPSiAxdZV8GXyIMql5aVC1R79SkyKZvW4k3R+MU
         O2tPFMreKAH54pchbyy9nMHdRpKxvEps1UqZSD1avkPQj01zUVDKlJYGiTlxM+2LjjR9
         +q32m71njpJj3G0o6kOhbsLeqq7CJ5maNPaWuscMKMIoLyKKbIOluPlMGA33d3bFSVpZ
         zWjhS+Nt8zq6UdO+WXBj+uxd5DBpEoaZzZvH/f1eAUCZxOuBaJ81dGrvAoc7of62k+3Y
         KxwGueNFzGsW6pprwtgxoyhXyjscT2/cUw69Su1HJJrhI5QOtXsEjqkM8DWUC/awJthy
         Z2yw==
X-Gm-Message-State: ACrzQf0p0PzY6wQNMl7bYemkkI5IcTw5NjQ82Wmbag3jomfTJEQShQ5P
        oZBnMsqotkMGQ9aaQxFjTHo=
X-Google-Smtp-Source: AMsMyM7M9XjFBDBBqXCNa9sFiDzCqiBkeKgMOzgUMVjxkJeVc7Sy/E7Raef9IbKHo1WRKWbtTJpa6A==
X-Received: by 2002:a5d:46c6:0:b0:22e:4b9a:3f02 with SMTP id g6-20020a5d46c6000000b0022e4b9a3f02mr7153835wrs.516.1665265013160;
        Sat, 08 Oct 2022 14:36:53 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b845:3000:401c:95b2:a7eb:33c5? (dynamic-2a01-0c23-b845-3000-401c-95b2-a7eb-33c5.c23.pool.telefonica.de. [2a01:c23:b845:3000:401c:95b2:a7eb:33c5])
        by smtp.googlemail.com with ESMTPSA id u10-20020a5d434a000000b00228de351fc0sm5366929wrr.38.2022.10.08.14.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Oct 2022 14:36:52 -0700 (PDT)
Message-ID: <bc6cf9cf-96bc-e1fd-964a-dfe4cfc8dc6b@gmail.com>
Date:   Sat, 8 Oct 2022 23:36:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Chunhao Lin <hau@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        Andrew Lunn <andrew@lunn.ch>
References: <20220915144807.3602-1-hau@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v4] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
In-Reply-To: <20220915144807.3602-1-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.09.2022 16:48, Chunhao Lin wrote:
> rtl8168h(revid 0x2a) + rtl8211fs is for fiber related application.
> rtl8168h is connected to rtl8211fs mdio bus via its eeprom or gpio pins.
> 
> In this patch, use bitbanged MDIO framework to access rtl8211fs via
> rtl8168h's eeprom or gpio pins.
> 
> And set mdiobb_ops owner to NULL to avoid increase module's refcount to
> prevent rmmod cannot be done.
> https://patchwork.kernel.org/project/linux-renesas-soc/patch/20200730100151.7490-1-ashiduka@fujitsu.com/
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/Kconfig      |   1 +
>  drivers/net/ethernet/realtek/r8169_main.c | 286 +++++++++++++++++++++-
>  2 files changed, 286 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
> index 93d9df55b361..20367114ac72 100644
> --- a/drivers/net/ethernet/realtek/Kconfig
> +++ b/drivers/net/ethernet/realtek/Kconfig
> @@ -100,6 +100,7 @@ config R8169
>  	depends on PCI
>  	select FW_LOADER
>  	select CRC32
> +	select MDIO_BITBANG
>  	select PHYLIB
>  	select REALTEK_PHY
>  	help
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index f6f63ba6593a..395eae62050a 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -28,6 +28,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/prefetch.h>
>  #include <linux/ipv6.h>
> +#include <linux/mdio-bitbang.h>
>  #include <asm/unaligned.h>
>  #include <net/ip6_checksum.h>
>  
> @@ -333,6 +334,15 @@ enum rtl8125_registers {
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
> @@ -573,6 +583,24 @@ struct rtl8169_tc_offsets {
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
> +	const u16 pin;
> +	const u16 mdio_oe;
> +	const u16 mdio;
> +	const u16 mdc;
> +	const u16 phy_addr;
> +	const u16 rb_pos;
> +};
> +
>  enum rtl_flag {
>  	RTL_FLAG_TASK_ENABLED = 0,
>  	RTL_FLAG_TASK_RESET_PENDING,
> @@ -585,6 +613,12 @@ enum rtl_dash_type {
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
> @@ -624,6 +658,10 @@ struct rtl8169_private {
>  	struct rtl_fw *rtl_fw;
>  
>  	u32 ocp_base;
> +
> +	enum rtl_sfp_if_type sfp_if_type;
> +
> +	struct mii_bus *mii_bus;	/* MDIO bus control */

This is at least misleading because mii_bus is unused for the
integrated copper PHY's. Maybe you can store the mii_bus in struct bb_info
and store the bb_info instance in struct rtl8169_private.

>  };
>  
>  typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
> @@ -1199,6 +1237,242 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
>  	}
>  }
>  
> +struct bb_info {
> +	struct rtl8169_private *tp;
> +	struct mdiobb_ctrl ctrl;
> +	struct rtl_sfp_if_mask mask;
> +	u16 pinoe;
> +	u16 pin_i_sel_1;
> +	u16 pin_i_sel_2;
> +};
> +
> +/* Data I/O pin control */
> +static void rtl_bb_mdio_dir(struct mdiobb_ctrl *ctrl, int output)
> +{
> +	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
> +	struct rtl8169_private *tp = bitbang->tp;
> +	const u16 mask = bitbang->mask.mdio_oe;
> +	const u16 reg = PINOE;
> +	u16 value;
> +
> +	value = bitbang->pinoe;
> +	if (output)
> +		value |= mask;
> +	else
> +		value &= ~mask;
> +	r8168_mac_ocp_write(tp, reg, value);
> +}
> +
> +/* Set bit data*/
> +static void rtl_bb_set_mdio(struct mdiobb_ctrl *ctrl, int set)
> +{
> +	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
> +	struct rtl8169_private *tp = bitbang->tp;
> +	const u16 mask = bitbang->mask.mdio;
> +	const u16 reg = PIN_I_SEL_2;
> +	u16 value;
> +
> +	value = bitbang->pin_i_sel_2;
> +	if (set)
> +		value |= mask;
> +	else
> +		value &= ~mask;
> +	r8168_mac_ocp_write(tp, reg, value);
> +}
> +
> +/* Get bit data*/
> +static int rtl_bb_get_mdio(struct mdiobb_ctrl *ctrl)
> +{
> +	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
> +	struct rtl8169_private *tp = bitbang->tp;
> +	const u16 reg = MDIO_IN;
> +
> +	return (r8168_mac_ocp_read(tp, reg) & BIT(bitbang->mask.rb_pos)) != 0;
> +}
> +
> +/* MDC pin control */
> +static void rtl_bb_mdc_ctrl(struct mdiobb_ctrl *ctrl, int set)
> +{
> +	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
> +	struct rtl8169_private *tp = bitbang->tp;
> +	const u16 mask = bitbang->mask.mdc;
> +	const u16 mdc_reg = PIN_I_SEL_1;
> +	u16 value;
> +
> +	value = bitbang->pin_i_sel_1;
> +	if (set)
> +		value |= mask;
> +	else
> +		value &= ~mask;
> +	r8168_mac_ocp_write(tp, mdc_reg, value);
> +}
> +
> +/* mdio bus control struct */
> +static const struct mdiobb_ops bb_ops = {
> +	.owner = NULL, /* set to NULL for not increase refcount */
> +	.set_mdc = rtl_bb_mdc_ctrl,
> +	.set_mdio_dir = rtl_bb_mdio_dir,
> +	.set_mdio_data = rtl_bb_set_mdio,
> +	.get_mdio_data = rtl_bb_get_mdio,
> +};
> +
> +#define MDIO_READ 2
> +#define MDIO_WRITE 1

This duplicates the defines in drivers/net/mdio/mdio-bitbang.c

> +/* MDIO bus init function */
> +static int rtl_mdio_bitbang_init(struct rtl8169_private *tp)
> +{
> +	struct device *d = tp_to_dev(tp);
> +	struct bb_info *bitbang;
> +	struct mii_bus *new_bus;
> +
> +	/* create bit control struct for PHY */
> +	bitbang = devm_kzalloc(d, sizeof(struct bb_info), GFP_KERNEL);
> +	if (!bitbang)
> +		return -ENOMEM;
> +
> +	/* bitbang init */
> +	bitbang->tp = tp;
> +	bitbang->ctrl.ops = &bb_ops;
> +	bitbang->ctrl.op_c22_read = MDIO_READ;
> +	bitbang->ctrl.op_c22_write = MDIO_WRITE;

MDIO_READ/WRITE are assigned by alloc_mdio_bitbang(), you don't need
this here.

> +
> +	/* MII controller setting */
> +	new_bus = alloc_mdio_bitbang(&bitbang->ctrl);

It seems the allocated MDIO bus is never registered.
This should be added.

> +	if (!new_bus)
> +		return -ENOMEM;
> +
> +	tp->mii_bus = new_bus;
> +
> +	return 0;
> +}
> +
> +static void rtl_sfp_bitbang_init(struct rtl8169_private *tp,
> +				  struct rtl_sfp_if_mask *mask)
> +{
> +	struct bb_info *bitbang =
> +		container_of(tp->mii_bus->priv, struct bb_info, ctrl);
> +
> +	r8168_mac_ocp_modify(tp, PINPU, mask->pin, 0);
> +	r8168_mac_ocp_modify(tp, PINOE, 0, mask->pin);
> +	bitbang->pinoe = r8168_mac_ocp_read(tp, PINOE);
> +	bitbang->pin_i_sel_1 = r8168_mac_ocp_read(tp, PIN_I_SEL_1);
> +	bitbang->pin_i_sel_2 = r8168_mac_ocp_read(tp, PIN_I_SEL_2);
> +	memcpy(&bitbang->mask, mask, sizeof(struct rtl_sfp_if_mask));
> +}
> +
> +static void rtl_sfp_mdio_write(struct rtl8169_private *tp,
> +				  u8 reg,
> +				  u16 val)
> +{
> +	struct mii_bus *bus = tp->mii_bus;
> +	struct bb_info *bitbang;
> +
> +	if (!bus)
> +		return;
> +
> +	bitbang = container_of(bus->priv, struct bb_info, ctrl);
> +	bus->write(bus, bitbang->mask.phy_addr, reg, val);
> +}
> +
> +static u16 rtl_sfp_mdio_read(struct rtl8169_private *tp,
> +				  u8 reg)
> +{
> +	struct mii_bus *bus = tp->mii_bus;
> +	struct bb_info *bitbang;
> +
> +	if (!bus)
> +		return ~0;
> +
> +	bitbang = container_of(bus->priv, struct bb_info, ctrl);
> +
> +	return bus->read(bus, bitbang->mask.phy_addr, reg);
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

As stated earlier, there should be no dependency on a specific external PHY
in a MAC driver. It's not clear why the bitbanged MDIO bus can't be used
with other PHY's.

> +static enum rtl_sfp_if_type rtl8168h_check_sfp(struct rtl8169_private *tp)
> +{
> +	static struct rtl_sfp_if_mask rtl_sfp_if_eeprom_mask = {
> +		0x0050, 0x0040, 0x000f, 0x0f00, 0, 6};
> +	static struct rtl_sfp_if_mask rtl_sfp_if_gpo_mask = {
> +		0x0210, 0x0200, 0xf000, 0x0f00, 1, 9};

You hard-code PHY addresses 0/1 here. Why not auto-probing?
And can't there be designs using other PHY addresses?

> +	int const checkcnt = 4;
> +	int i;
> +
> +	if (rtl_mdio_bitbang_init(tp))
> +		return RTL_SFP_IF_NONE;
> +
> +	rtl_sfp_bitbang_init(tp, &rtl_sfp_if_eeprom_mask);
> +	rtl_sfp_mdio_write(tp, 0x1f, 0x0000);
> +	for (i = 0; i < checkcnt; i++) {
> +		if (rtl_sfp_mdio_read(tp, MII_PHYSID1) != RTL8211FS_PHY_ID_1 ||
> +			rtl_sfp_mdio_read(tp, MII_PHYSID2) != RTL8211FS_PHY_ID_2)
> +			break;

See earlier comment on dependency on a specific PHY model.

> +	}
> +
> +	if (i == checkcnt)
> +		return RTL_SFP_IF_EEPROM;
> +
> +	rtl_sfp_bitbang_init(tp, &rtl_sfp_if_gpo_mask);
> +	rtl_sfp_mdio_write(tp, 0x1f, 0x0000);
> +	for (i = 0; i < checkcnt; i++) {
> +		if (rtl_sfp_mdio_read(tp, MII_PHYSID1) != RTL8211FS_PHY_ID_1 ||
> +			rtl_sfp_mdio_read(tp, MII_PHYSID2) != RTL8211FS_PHY_ID_2)
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

This PHY model specific initialization belongs to the PHY driver.
Presumably RTL8211FS support should be added to drivers/net/phy/realtek.c

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
> +	/* enable pass_linkctl_en */
> +	rtl_sfp_mdio_write(tp, 0x1f, 0x0a4b);
> +	rtl_sfp_mdio_modify(tp, 0x11, 0, BIT(4));
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
> @@ -2168,6 +2442,9 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
>  	    tp->pci_dev->subsystem_device == 0xe000)
>  		phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
>  
> +	if (tp->sfp_if_type != RTL_SFP_IF_NONE)
> +		rtl_hw_sfp_phy_config(tp);
> +
>  	/* We may have called phy_speed_down before */
>  	phy_speed_up(tp->phydev);
>  
> @@ -2224,7 +2501,8 @@ static void rtl_prepare_power_down(struct rtl8169_private *tp)
>  		rtl_ephy_write(tp, 0x19, 0xff64);
>  
>  	if (device_may_wakeup(tp_to_dev(tp))) {
> -		phy_speed_down(tp->phydev, false);
> +		if (tp->sfp_if_type == RTL_SFP_IF_NONE)
> +			phy_speed_down(tp->phydev, false);
>  		rtl_wol_enable_rx(tp);
>  	}
>  }
> @@ -4866,6 +5144,10 @@ static void rtl_remove_one(struct pci_dev *pdev)
>  	if (tp->dash_type != RTL_DASH_NONE)
>  		rtl8168_driver_stop(tp);
>  
> +	/* free bitbang info */
> +	if (tp->mii_bus)
> +		free_mdio_bitbang(tp->mii_bus);
> +
>  	rtl_release_firmware(tp);
>  
>  	/* restore original MAC address */
> @@ -5210,6 +5492,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	tp->dash_type = rtl_check_dash(tp);
>  
> +	tp->sfp_if_type = rtl_check_sfp(tp);
> +
>  	tp->cp_cmd = RTL_R16(tp, CPlusCmd) & CPCMD_MASK;
>  
>  	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&

