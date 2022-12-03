Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8C9641763
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 15:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiLCOyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 09:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLCOym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 09:54:42 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AC91E3CD
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 06:54:41 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ml11so17888370ejb.6
        for <netdev@vger.kernel.org>; Sat, 03 Dec 2022 06:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ods86W3+C2dvi6VndBUsGUrfwCOdRzBIJcjCJIgrvOk=;
        b=UiDMekw6xEEVVaeVpcWOvi4CALzboR9V6ue21R4aUnMJBmwsPwT+5Fx1r0Uv4hyyQM
         ujqpGwF1nKWm4WQHdcIcaSnf0PpAWzJ66AhpHN89JhGAHKA3OuqGjLtvusoQsWIsQY4S
         /yxl1dPzoi557n3Kv0U0aPNVeS8GTS3LygPPeRIbI0zCtq3+Z/4iEQ77k6JyBkN7Bc6Q
         IyCURw/VLqnQmL4UZcCkPcPriVjvywT1WIEYeH0XyG+GRCc5znYAqBVnTyZPcWtjPCrM
         VXWuv9RGPjy/KpZOfJLXpQvFLFWnUU5WaBwwATqjQwQ/0pwDhtOJwXYgcyZNEDOHy91N
         C/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ods86W3+C2dvi6VndBUsGUrfwCOdRzBIJcjCJIgrvOk=;
        b=MV0rj32X5T86LOGRIlr0fS4jVDuXGuF57ejfsfStxu1U/gLB1ydyxg/DLvCokYg0ZI
         zDA7UnnZ31DjF823P99NiAT7oIArmEOBuRBFbE5s4l7kOda8U0QEmaJ0B1T+3lCwD4df
         gQfs9HFXNR6Nz4Zlpuk++bzabvN9fU+2og65AI3YRFsTTCR19CPMbjuu9AN+Cpy6HJxL
         U+bjqapujHByc3tayY1nVrGNerP7HxqTYmzcbC1m8mdrX5f6jtQ2Sq+rnlm8087AlaZ6
         xe3IC9tekzCzxWanmzbV1wyoqN4wSWjBewQjMzpAOvfHyK+QKYYhh2kVliDcDhJO62fX
         0D3A==
X-Gm-Message-State: ANoB5pkFnj5myr72+yzRoUiSzDM2DVytoBLW+5GcXJUesctQlOLXW2H5
        IrQzAg8L2E6Vt8Fr8fzs1iApQQl8iJA=
X-Google-Smtp-Source: AA0mqf5w+wKjLCxk7VQuKDkCPYCLJA7fYJls5W5kDN9M4KpoMBf0FUdu5Rx4546wfo/ZfRgraCFQwA==
X-Received: by 2002:a17:906:5583:b0:78d:b3ef:656c with SMTP id y3-20020a170906558300b0078db3ef656cmr46366194ejp.627.1670079279552;
        Sat, 03 Dec 2022 06:54:39 -0800 (PST)
Received: from ?IPV6:2a01:c23:b8bf:f00:3dde:1995:93c5:8974? (dynamic-2a01-0c23-b8bf-0f00-3dde-1995-93c5-8974.c23.pool.telefonica.de. [2a01:c23:b8bf:f00:3dde:1995:93c5:8974])
        by smtp.googlemail.com with ESMTPSA id ef3-20020a05640228c300b00463b9d47e1fsm4085113edb.71.2022.12.03.06.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Dec 2022 06:54:39 -0800 (PST)
Message-ID: <199a6a2d-f66f-bd7c-45af-44c115715eac@gmail.com>
Date:   Sat, 3 Dec 2022 15:54:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To:     Chunhao Lin <hau@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <20221201143911.4449-1-hau@realtek.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
In-Reply-To: <20221201143911.4449-1-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.12.2022 15:39, Chunhao Lin wrote:
> rtl8168h(revid 0x2a) + rtl8211fs is for utp to fiber application.
> rtl8168h is connected to rtl8211fs utp interface. And fiber is connected
> to rtl8211fs sfp interface. rtl8168h use its eeprm or gpo pins to control
> rtl8211fs mdio bus.
> 
You mention a SFP interface. Does this mean that combination RTL8168H/RTL8211FS
needs a SFP module for fiber connectivity?
If yes, which software component is controlling the SFP I2C interface?

> In this patch, driver will register a phy device which uses bitbanged MDIO
> framework to access rtl8211fs.
> 
> Becuse driver only needs to set rtl8211fs phy parameters, so after setting
> rtl8211fs phy parameters, it will release  phy device.
> 
That's not clear to me. Starting with the most obvious questions:
How are link up/down events propagated to the MAC driver?

And when bringing down the network interface or suspending the system
I think you want to stop the PHY.

> Fiber does not support speed down, so driver will not speed down phy when
> system suspend or shutdown.
> 
See comment below at the related code change.

> Driver will set mdiobb_ops owner to NULL when call alloc_mdio_bitbang().
> That avoid increase module's refcount to prevent rmmod cannot be done.
> https://patchwork.kernel.org/project/linux-renesas-soc/patch/20200730100151.7490-1-ashiduka@fujitsu.com/
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
> v4 -> v5: register a phy device for rtl8211fs
> 
>  drivers/net/ethernet/realtek/Kconfig      |   1 +
>  drivers/net/ethernet/realtek/r8169_main.c | 247 +++++++++++++++++++++-
>  2 files changed, 247 insertions(+), 1 deletion(-)
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
> index 5bc1181f829b..cd6cd64a197f 100644
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
> @@ -325,6 +326,15 @@ enum rtl8168_registers {
>  #define EARLY_TALLY_EN			(1 << 16)
>  };
>  
> +enum rtl_bb_registers {
> +	MDIO_IN			= 0xdc04,
> +	PINOE			= 0xdc06,
> +	PIN_I_SEL_1		= 0xdc08,
> +	PIN_I_SEL_2		= 0xdc0A,
> +	PINPU			= 0xdc18,
> +	GPOUTPIN_SEL	= 0xdc20,
> +};
> +
>  enum rtl8125_registers {
>  	IntrMask_8125		= 0x38,
>  	IntrStatus_8125		= 0x3c,
> @@ -573,6 +583,14 @@ struct rtl8169_tc_offsets {
>  	__le16	rx_missed;
>  };
>  
> +struct rtl_bb_mask {
> +	const u16 pin;
> +	const u16 mdio_oe;
> +	const u16 mdio;
> +	const u16 mdc;
> +	const u16 rb_pos;
> +};

It shouldn't be needed to mark every member as const.
If you don't want that a struct instance can be changed,
pass a reference as "const struct rtl_bb_mask *".

> +
>  enum rtl_flag {
>  	RTL_FLAG_TASK_ENABLED = 0,
>  	RTL_FLAG_TASK_RESET_PENDING,
> @@ -624,6 +642,12 @@ struct rtl8169_private {
>  	struct rtl_fw *rtl_fw;
>  
>  	u32 ocp_base;
> +
> +	struct {
> +		struct mii_bus *mii_bus;
> +		struct phy_device *phydev;

We have a phydev member in in struct rtl8169_private already,
why can't you use it and need a separate one instead?

> +		struct bb_info *ctrl;
> +	} bb;
>  };
>  
>  typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
> @@ -1199,6 +1223,217 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
>  	}
>  }
>  
> +struct bb_info {
> +	struct rtl8169_private *tp;
> +	struct mdiobb_ctrl ctrl;
> +	struct rtl_bb_mask mask;

Why not just storing a pointer to one of the two possible mask structs?

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
> +static void rtl_bb_init(struct bb_info *bitbang, struct rtl_bb_mask *mask)
> +{
> +	struct rtl8169_private *tp = bitbang->tp;
> +
> +	r8168_mac_ocp_modify(tp, PINPU, mask->pin, 0);
> +	r8168_mac_ocp_modify(tp, PINOE, 0, mask->pin);

A comment would be nice explaining what these calls do.

> +	bitbang->pinoe = r8168_mac_ocp_read(tp, PINOE);
> +	bitbang->pin_i_sel_1 = r8168_mac_ocp_read(tp, PIN_I_SEL_1);
> +	bitbang->pin_i_sel_2 = r8168_mac_ocp_read(tp, PIN_I_SEL_2);
> +	memcpy(&bitbang->mask, mask, sizeof(struct rtl_bb_mask));
> +}
> +
> +/* Bitbang MDIO bus init function */
> +static int rtl_bb_mdio_bus_init(struct rtl8169_private *tp,
> +				  struct rtl_bb_mask *mask)
> +{
> +	struct pci_dev *pdev = tp->pci_dev;
> +	struct bb_info *bitbang;
> +	struct mii_bus *new_bus;
> +	int rc = 0;
> +
> +	/* create bit control struct for PHY */
> +	bitbang = kzalloc(sizeof(struct bb_info), GFP_KERNEL);
> +	if (!bitbang) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* bitbang init */
> +	bitbang->tp = tp;
> +	bitbang->ctrl.ops = &bb_ops;
> +
> +	/* Bitbang MII controller setting */
> +	new_bus = alloc_mdio_bitbang(&bitbang->ctrl);
> +	if (!new_bus) {
> +		rc = -ENOMEM;
> +		goto err_bb_init_0;
> +	}
> +
> +	new_bus->name = "r8169_bb_mii_bus";
> +	new_bus->parent = &pdev->dev;
> +	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-bb-%x-%x",
> +		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
> +
> +	rtl_bb_init(bitbang, mask);
> +
> +	rc = mdiobus_register(new_bus);
> +	if (rc)
> +		goto err_bb_init_1;
> +
> +	tp->bb.phydev = mdiobus_get_phy(new_bus, 0);

You check PHY address 0 only. But a PHY could be at any PHY address.

> +	if (!tp->bb.phydev) {
> +		rc = -ENODEV;
> +		goto err_bb_init_2;
> +	} else if (!tp->bb.phydev->drv) {
> +		/* Most chip versions fail with the genphy driver.
> +		 * Therefore ensure that the dedicated PHY driver is loaded.
> +		 */
> +		rc =  -EUNATCH;
> +		goto err_bb_init_2;
> +	}
> +
> +	tp->bb.mii_bus = new_bus;
> +	tp->bb.ctrl = bitbang;
> +out:
> +	return rc;
> +
> +err_bb_init_2:
> +	mdiobus_unregister(new_bus);
> +err_bb_init_1:
> +	free_mdio_bitbang(new_bus);
> +err_bb_init_0:
> +	kfree(bitbang);
> +	goto out;
> +}
> +
> +static void rtl_bb_mdio_bus_release(struct rtl8169_private *tp)
> +{
> +	/* Unregister mdio bus */
> +	mdiobus_unregister(tp->bb.mii_bus);
> +
> +	/* free bitbang info */
> +	free_mdio_bitbang(tp->bb.mii_bus);
> +
> +	/* free bit control struct */
> +	kfree(tp->bb.ctrl);
> +}
> +
> +static int __rtl_check_bb_mdio_bus(struct rtl8169_private *tp)
> +{
> +	static struct rtl_bb_mask pin_mask_eeprom = {
> +		0x0050, 0x0040, 0x000f, 0x0f00, 6};
> +	static struct rtl_bb_mask pin_mask_gpo = {
> +		0x0210, 0x0200, 0xf000, 0x0f00, 9};
> +

Would be better to use the folloing here:

static const struct rtl_bb_mask pin_mask_eeprom = {
	.pin = xxx;
	...
};

> +	if (!rtl_bb_mdio_bus_init(tp, &pin_mask_eeprom) ||
> +		!rtl_bb_mdio_bus_init(tp, &pin_mask_gpo))
> +		return 0;
> +
> +	return -1;

The caller doesn't use the errno, so you could change the
return value type to bool.

> +}
> +
> +static bool rtl_supports_bb_mdio_bus(struct rtl8169_private *tp)
> +{
> +	return tp->mac_version == RTL_GIGA_MAC_VER_46 &&
> +		   tp->pci_dev->revision == 0x2a;
> +}
> +
> +static int rtl_check_bb_mdio_bus(struct rtl8169_private *tp)
> +{
> +	if (rtl_supports_bb_mdio_bus(tp))
> +		return __rtl_check_bb_mdio_bus(tp);
> +	return -1;

Also here the return value type better would be bool.

> +}
> +
> +static void rtl8169_init_bb_phy(struct rtl8169_private *tp)
> +{
> +	struct phy_device *phydev = tp->bb.phydev;
> +
> +	/* disable ctap */
> +	phy_modify_paged(phydev, 0x0a43, 0x19, BIT(6), 0);
> +
> +	/* change Rx threshold */
> +	phy_modify_paged(phydev, 0x0dcc, 0x14, 0, BIT(2) | BIT(3) | BIT(4));
> +
> +	/* switch pin34 to PMEB pin */
> +	phy_modify_paged(phydev, 0x0d40, 0x16, 0, BIT(5));
> +
> +	/* enable pass_linkctl_en */
> +	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(4));
> +}

As stated earlier, PHY initialization should be done in the PHY driver,
not in the MAC driver.

> +
>  static void rtl_set_d3_pll_down(struct rtl8169_private *tp, bool enable)
>  {
>  	switch (tp->mac_version) {
> @@ -2171,6 +2406,14 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
>  	    tp->pci_dev->subsystem_device == 0xe000)
>  		phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
>  
> +	if (!rtl_check_bb_mdio_bus(tp)) {
> +		rtl8169_init_bb_phy(tp);
> +		/* disable ctap */
> +		phy_modify_paged(tp->phydev, 0x0a43, 0x11, BIT(6), 0);

See previous comment, this belongs into the PHY driver.

> +
> +		rtl_bb_mdio_bus_release(tp);
> +	}
> +
>  	/* We may have called phy_speed_down before */
>  	phy_speed_up(tp->phydev);
>  
> @@ -2227,7 +2470,9 @@ static void rtl_prepare_power_down(struct rtl8169_private *tp)
>  		rtl_ephy_write(tp, 0x19, 0xff64);
>  
>  	if (device_may_wakeup(tp_to_dev(tp))) {
> -		phy_speed_down(tp->phydev, false);
> +		/* Fiber not support speed down */

phy_speed_down() will switch to the slowest mode supported by both
link partners. If the local PHY doesn't support a speed below 1Gbps
then the call to phy_speed_down() is a no-op, it won't hurt.
Therefore I see no reason to add complexity for skipping this call.

Another question may be whether switching to a slower speed is
benefitial to power consumption in general on fiber.
That's something I can't answer. But if true, we should add
to phy_speed_down() to do nothing if port is PORT_FIBRE.

> +		if (!tp->bb.mii_bus)
> +			phy_speed_down(tp->phydev, false);
>  		rtl_wol_enable_rx(tp);
>  	}
>  }

