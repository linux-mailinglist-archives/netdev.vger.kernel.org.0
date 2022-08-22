Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4A559C9EC
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236487AbiHVUTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiHVUTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 16:19:45 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CEC12D3B
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:19:43 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u14so14565354wrq.9
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc;
        bh=ZvhYWEGtQKiCLgC/TdKtw1qwcTksPKFSJlKdptwhjp8=;
        b=nOcSHAAqWz3rpdN+eUkSo5Vd6YZ77FMRyKj+dhJU8xY0wxyA7t8Ld0SGFMfCxJ6VEk
         4UdR4KWRVsZLuR4OFCTjVdODxuZ9Z+3KQYWNrW1LvEmq0+RViRIxcZbOD/kMhuv7xRSd
         eN2EIujuuPw5vh0sIzOUALMh3Axe9Oh+Jgot1QkdWWVOQnfC3jpMm9nByZJohFDf4ywt
         k+95FaDbq3ZkEvIJihWAaQlPyF5u5e5MhtcUBRI4FR3nezLtIEsSjusjqAOPwqtQubRs
         sJokTMy0qNAL3uMWYYwqFI90iXqeYmGOnUAyJm665oT049F2xG80Q2HgYY3tBgAlLy98
         +w5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ZvhYWEGtQKiCLgC/TdKtw1qwcTksPKFSJlKdptwhjp8=;
        b=im1l2A4AFSERsWpm5sCdu/N6GRdzM7TKTpQHAVKtn6TOw+VlOPCYkTv/9tkbEfxXuT
         tJDYgFr0rsjkXZtxNEe38IsCSpyQq+zHLP+iabAh5G4GxQIsBvM9Sqi9wLU/epgaAnhC
         9wbwliuySIrjyWUcjlZJlTmQm8kkEqJtkQXvyUHGSGmRgFcKIpKtDPce9SLuvDtscyjF
         9F4xc/2GHZ7YD1L2k0mTU2BvSElzp69ER9quqzDOLmCgkMvTwhvwk9DYrb5EHN6KzBnu
         YZ4LE4jq4Xngbe2ZP6kTeDVEYUe+hZa9pTASmfvXS4iygdgopWaikz24Z3kG4kW4IW20
         Ez/g==
X-Gm-Message-State: ACgBeo3jCF9b86i0br4h4Tz1DbLkSKBqMe2X96Y/tLeX3fQaI6bjl9p2
        N+grSpr/lXQCUdPK7nIFZcNc/MZdpMQ=
X-Google-Smtp-Source: AA6agR4+aIIyudrsajEOWAn6CqX4SsEyCfZrmOBNnJazHuhRAk09JDSfYCS7RiFCf6z1LHiQs+SunA==
X-Received: by 2002:a5d:6712:0:b0:225:337c:3889 with SMTP id o18-20020a5d6712000000b00225337c3889mr10385108wru.59.1661199582374;
        Mon, 22 Aug 2022 13:19:42 -0700 (PDT)
Received: from ?IPV6:2a02:3100:954a:8e00:9543:2437:11af:ddd2? (dynamic-2a02-3100-954a-8e00-9543-2437-11af-ddd2.310.pool.telefonica.de. [2a02:3100:954a:8e00:9543:2437:11af:ddd2])
        by smtp.googlemail.com with ESMTPSA id j10-20020a5d564a000000b00225307f43fbsm12176680wrw.44.2022.08.22.13.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 13:19:41 -0700 (PDT)
Message-ID: <6018e2ca-a02f-f70f-cf9a-f635680a02ba@gmail.com>
Date:   Mon, 22 Aug 2022 22:19:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Chunhao Lin <hau@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com, kuba@kernel.org,
        davem@davemloft.net
References: <20220822160714.2904-1-hau@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v3 net-next] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
In-Reply-To: <20220822160714.2904-1-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.08.2022 18:07, Chunhao Lin wrote:
> rtl8168h(revid 0x2a) + rtl8211fs is for fiber related application.
> rtl8168h is connected to rtl8211fs mdio bus via its eeprom or gpio pins.
> In this patch, use bitbanged MDIO framework to access rtl8211fs via
> rtl8168h's eeprom or gpio pins.
> 
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/Kconfig      |   1 +
>  drivers/net/ethernet/realtek/r8169_main.c | 289 +++++++++++++++++++++-
>  2 files changed, 288 insertions(+), 2 deletions(-)
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
> index 1b7fdb4f056b..8051cdf46f85 100644
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
> @@ -344,6 +345,15 @@ enum rtl8125_registers {
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
> @@ -584,6 +594,24 @@ struct rtl8169_tc_offsets {
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
>  enum rtl_flag {
>  	RTL_FLAG_TASK_ENABLED = 0,
>  	RTL_FLAG_TASK_RESET_PENDING,
> @@ -596,6 +624,12 @@ enum rtl_dash_type {
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
> @@ -635,6 +669,10 @@ struct rtl8169_private {
>  	struct rtl_fw *rtl_fw;
>  
>  	u32 ocp_base;
> +
> +	enum rtl_sfp_if_type sfp_if_type;
> +
> +	struct mii_bus *mii_bus;	/* MDIO bus control */
>  };
>  
>  typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
> @@ -914,8 +952,12 @@ static void r8168g_mdio_write(struct rtl8169_private *tp, int reg, int value)
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
> @@ -1214,6 +1256,243 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
>  	}
>  }
>  
> +struct bb_info {
> +	struct rtl8169_private *tp;
> +	struct mdiobb_ctrl ctrl;
> +	struct rtl_sfp_if_mask sfp_mask;
> +	u16 pinoe_value;
> +	u16 pin_i_sel_1_value;
> +	u16 pin_i_sel_2_value;
> +};
> +
> +/* Data I/O pin control */
> +static void rtl_mdio_dir(struct mdiobb_ctrl *ctrl, int output)
> +{
> +	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
> +	struct rtl8169_private *tp = bitbang->tp;
> +	const u16 reg = PINOE;
> +	const u16 mask = bitbang->sfp_mask.mdio_oe_mask;
> +	u16 value;
> +
> +	value = bitbang->pinoe_value;
> +	if (output)
> +		value |= mask;
> +	else
> +		value &= ~mask;
> +	r8168_mac_ocp_write(tp, reg, value);
> +}
> +
> +/* Set bit data*/
> +static void rtl_set_mdio(struct mdiobb_ctrl *ctrl, int set)
> +{
> +	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
> +	struct rtl8169_private *tp = bitbang->tp;
> +	const u16 reg = PIN_I_SEL_2;
> +	const u16 mask = bitbang->sfp_mask.mdio_mask;
> +	u16 value;
> +
> +	value = bitbang->pin_i_sel_2_value;
> +	if (set)
> +		value |= mask;
> +	else
> +		value &= ~mask;
> +	r8168_mac_ocp_write(tp, reg, value);
> +}
> +
> +/* Get bit data*/
> +static int rtl_get_mdio(struct mdiobb_ctrl *ctrl)
> +{
> +	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
> +	struct rtl8169_private *tp = bitbang->tp;
> +	const u16 reg = MDIO_IN;
> +
> +	return (r8168_mac_ocp_read(tp, reg) & BIT(bitbang->sfp_mask.rb_pos)) != 0;
> +}
> +
> +/* MDC pin control */
> +static void rtl_mdc_ctrl(struct mdiobb_ctrl *ctrl, int set)
> +{
> +	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
> +	struct rtl8169_private *tp = bitbang->tp;
> +	const u16 mdc_reg = PIN_I_SEL_1;
> +	const u16 mask = bitbang->sfp_mask.mdc_mask;
> +	u16 value;
> +
> +	value = bitbang->pin_i_sel_1_value;
> +	if (set)
> +		value |= mask;
> +	else
> +		value &= ~mask;
> +	r8168_mac_ocp_write(tp, mdc_reg, value);
> +}
> +
> +/* mdio bus control struct */
> +static const struct mdiobb_ops bb_ops = {
> +	.owner = THIS_MODULE,
> +	.set_mdc = rtl_mdc_ctrl,
> +	.set_mdio_dir = rtl_mdio_dir,
> +	.set_mdio_data = rtl_set_mdio,
> +	.get_mdio_data = rtl_get_mdio,
> +};
> +
> +#define MDIO_READ 2
> +#define MDIO_WRITE 1
> +/* MDIO bus init function */
> +static int rtl_mdio_bitbang_init(struct rtl8169_private *tp)
> +{
> +	struct bb_info *bitbang;
> +	struct device *d = tp_to_dev(tp);
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
> +
> +	/* MII controller setting */
> +	new_bus = devm_mdiobus_alloc(d);
> +	if (!new_bus)
> +		return -ENOMEM;
> +
> +	new_bus->read = mdiobb_read;
> +	new_bus->write = mdiobb_write;
> +	new_bus->priv = &bitbang->ctrl;
> +

This looks like an open-coded version of alloc_mdio_bitbang().

> +	tp->mii_bus = new_bus;
> +
> +	return 0;
> +}
> +
> +static void rtl_sfp_bitbang_init(struct rtl8169_private *tp,
> +				  struct rtl_sfp_if_mask *sfp_mask)
> +{
> +	struct mii_bus *bus = tp->mii_bus;
> +	struct bb_info *bitbang = container_of(bus->priv, struct bb_info, ctrl);
> +
> +	r8168_mac_ocp_modify(tp, PINPU, sfp_mask->pin_mask, 0);
> +	r8168_mac_ocp_modify(tp, PINOE, 0, sfp_mask->pin_mask);
> +	bitbang->pinoe_value = r8168_mac_ocp_read(tp, PINOE);
> +	bitbang->pin_i_sel_1_value = r8168_mac_ocp_read(tp, PIN_I_SEL_1);
> +	bitbang->pin_i_sel_2_value = r8168_mac_ocp_read(tp, PIN_I_SEL_2);
> +	memcpy(&bitbang->sfp_mask, sfp_mask, sizeof(struct rtl_sfp_if_mask));
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
> +	bus->write(bus, bitbang->sfp_mask.phy_addr, reg, val);
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
> +	return bus->read(bus, bitbang->sfp_mask.phy_addr, reg);
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

There shouldn't be a dependency on a specific PHY type. It may not reflect your
use cases, but it should be perfectly possible to combine this MAC with other
PHY types, also from other vendors, supporting fiber.

> +static enum rtl_sfp_if_type rtl8168h_check_sfp(struct rtl8169_private *tp)
> +{
> +	int i;
> +	int const checkcnt = 4;
> +	static struct rtl_sfp_if_mask rtl_sfp_if_eeprom_mask = {
> +		0x0050, 0x0040, 0x000f, 0x0f00, 0, 6};
> +	static struct rtl_sfp_if_mask rtl_sfp_if_gpo_mask = {
> +		0x0210, 0x0200, 0xf000, 0x0f00, 1, 9};
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
> @@ -2195,6 +2474,9 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
>  	    tp->pci_dev->subsystem_device == 0xe000)
>  		phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
>  
> +	if (tp->sfp_if_type != RTL_SFP_IF_NONE)
> +		rtl_hw_sfp_phy_config(tp);
> +
>  	/* We may have called phy_speed_down before */
>  	phy_speed_up(tp->phydev);
>  
> @@ -2251,7 +2533,8 @@ static void rtl_prepare_power_down(struct rtl8169_private *tp)
>  		rtl_ephy_write(tp, 0x19, 0xff64);
>  
>  	if (device_may_wakeup(tp_to_dev(tp))) {
> -		phy_speed_down(tp->phydev, false);
> +		if (tp->sfp_if_type == RTL_SFP_IF_NONE)
> +			phy_speed_down(tp->phydev, false);
>  		rtl_wol_enable_rx(tp);
>  	}
>  }
> @@ -5386,6 +5669,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	tp->dash_type = rtl_check_dash(tp);
>  
> +	tp->sfp_if_type = rtl_check_sfp(tp);
> +
>  	tp->cp_cmd = RTL_R16(tp, CPlusCmd) & CPCMD_MASK;
>  
>  	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&

