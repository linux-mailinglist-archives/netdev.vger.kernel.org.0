Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2253661575
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 14:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjAHNWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 08:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAHNWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 08:22:12 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7BC10054
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 05:22:09 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id gh17so13925401ejb.6
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 05:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GIzKUcxr6bc9GcJQyiY6Hcg8LN6LoaFpdzNZJooCtDw=;
        b=fZfk0kc8pWwnheYUa3ZVslxDFuaK66v24Icjjuv7GiJ2W1W1e/sUd4WKKwmONaFUNH
         nDMaQyTbzr51hHCkfIQ803wttVM4c1bG0ra5N+Ze6Hzp03hNoH/ymdo2tTmkYrPWNsWz
         q/r+3tsSuXAXu5gKYK5eKZTRxxBDgOJ5MmacokGLTA8vFUO7OqSdaVr5jBDd/puAsev0
         aQJX4jg1XJSkMjJihuxyiXBZrG0r4zD25TkRFxASAAtv0M/d719BBgWKgC/g2tLAMH6u
         vg6YXkF+FmI/Jr5kP5wWLAc4wc7LWhFmsp9oGK9x6eDfYbL5BfEhHLlLpy5yymC1384y
         lZFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GIzKUcxr6bc9GcJQyiY6Hcg8LN6LoaFpdzNZJooCtDw=;
        b=uGgZ93k3sVBu2yLeHofXlC5vd6jlnhvjUuvf6KgG4k0sNB5Tju+JplwLA8/5pALllw
         1fiXgmRIzJnBS33WGxk4WKWQmPZg/wlnBGH5Nq5nUG6gVKlCgHr6i+1AePk5rZ8Li0Zv
         XnfutEQB0b2oGdQc59+gVf0l4Pck00B8uWDhbVagTStELO5seKiX4wHv2fDdQlz/SXJf
         hBle405HFBjuxKsUsBgwHAo6wcIlgkBXKQUCGZLfb+QttXaOFxgiYb7NvUMKJGeDXCuT
         qZUHo6hcI3bDkvcmvojS4idPGXqkk3g2zIVjufjY/bksaMoq5SkMEWwo4Fa5FnghFz44
         /Qdg==
X-Gm-Message-State: AFqh2kpoD6VFrY7Hl+IoUgrl1ToizXt2xV9bEsYnKiFsveRWpwgqkins
        rZe3ALtEJfYehAF7odcc5mMCwjv524g=
X-Google-Smtp-Source: AMrXdXvxCc+sOwDgIpkYITs9CvZldC94wqtTlx7oIZctfvdYFdnsJuby3NzcmHjLlUsIsBcfAg2RfA==
X-Received: by 2002:a17:907:9b06:b0:83f:8e58:6427 with SMTP id kn6-20020a1709079b0600b0083f8e586427mr51385153ejc.63.1673184127813;
        Sun, 08 Jan 2023 05:22:07 -0800 (PST)
Received: from ?IPV6:2a01:c23:c473:c200:1008:623a:9401:4104? (dynamic-2a01-0c23-c473-c200-1008-623a-9401-4104.c23.pool.telefonica.de. [2a01:c23:c473:c200:1008:623a:9401:4104])
        by smtp.googlemail.com with ESMTPSA id b15-20020aa7c90f000000b004615f7495e0sm2534560edt.8.2023.01.08.05.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 05:22:07 -0800 (PST)
Message-ID: <3c63befe-828c-b5a1-606f-84a678532caf@gmail.com>
Date:   Sun, 8 Jan 2023 14:22:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Cc:     jiawenwu@net-swift.com
References: <20230108093903.27054-1-mengyuanlou@net-swift.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v6] net: ngbe: Add ngbe mdio bus driver.
In-Reply-To: <20230108093903.27054-1-mengyuanlou@net-swift.com>
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

On 08.01.2023 10:39, Mengyuan Lou wrote:
> Add mdio bus register for ngbe.
> The internal phy and external phy need to be handled separately.
> Add phy changed event detection.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
> Change log:
> v6: 
> 	Remove structure ngbe_adapter and ngbe_hw, put all members to structure wx.
> v5: address comments:
> 	Andrew Lunn: https://lore.kernel.org/netdev/Y5RjwYgetMdzlQVZ@lunn.ch/
> v4: address comments:
> 	Jiri Pirko: https://lore.kernel.org/netdev/Y5L9m%2FMMOG6GTNrb@nanopsycho/
> v3: address comments:
> 	Jakub Kicinski: https://lore.kernel.org/netdev/20221208194215.55bc2ee1@kernel.org/
> v2: address comments:
> 	Andrew Lunn: https://lore.kernel.org/netdev/Y4p0dQWijzQMlBmW@lunn.ch/
> 
>  drivers/net/ethernet/wangxun/Kconfig          |   1 +
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |   9 +
>  drivers/net/ethernet/wangxun/ngbe/Makefile    |   2 +-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  40 ++-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   1 +
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  37 ++-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c | 244 ++++++++++++++++++
>  drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h |  12 +
>  drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  24 ++
>  9 files changed, 356 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
>  create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h
> 
> diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
> index 86310588c6c1..0922beac3ec0 100644
> --- a/drivers/net/ethernet/wangxun/Kconfig
> +++ b/drivers/net/ethernet/wangxun/Kconfig
> @@ -25,6 +25,7 @@ config NGBE
>  	tristate "Wangxun(R) GbE PCI Express adapters support"
>  	depends on PCI
>  	select LIBWX
> +	select PHYLIB
>  	help
>  	  This driver supports Wangxun(R) GbE PCI Express family of
>  	  adapters.
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> index a52908d01c9c..165f61698177 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> @@ -133,11 +133,14 @@
>  /************************************* ETH MAC *****************************/
>  #define WX_MAC_TX_CFG                0x11000
>  #define WX_MAC_TX_CFG_TE             BIT(0)
> +#define WX_MAC_TX_CFG_SPEED_MASK     GENMASK(30, 29)
> +#define WX_MAC_TX_CFG_SPEED_1G       (0x3 << 29)
>  #define WX_MAC_RX_CFG                0x11004
>  #define WX_MAC_RX_CFG_RE             BIT(0)
>  #define WX_MAC_RX_CFG_JE             BIT(8)
>  #define WX_MAC_PKT_FLT               0x11008
>  #define WX_MAC_PKT_FLT_PR            BIT(0) /* promiscuous mode */
> +#define WX_MAC_WDG_TIMEOUT           0x1100C
>  #define WX_MAC_RX_FLOW_CTRL          0x11090
>  #define WX_MAC_RX_FLOW_CTRL_RFE      BIT(0) /* receive fc enable */
>  #define WX_MMC_CONTROL               0x11800
> @@ -330,6 +333,12 @@ struct wx {
>  	char eeprom_id[32];
>  	enum wx_reset_type reset_type;
>  
> +	/* PHY stuff */
> +	unsigned int link;
> +	int speed;
> +	int duplex;
> +	struct phy_device *phydev;
> +
>  	bool wol_enabled;
>  	bool ncsi_enabled;
>  	bool gpio_ctrl;
> diff --git a/drivers/net/ethernet/wangxun/ngbe/Makefile b/drivers/net/ethernet/wangxun/ngbe/Makefile
> index 391c2cbc1bb4..50fdca87d2a5 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/Makefile
> +++ b/drivers/net/ethernet/wangxun/ngbe/Makefile
> @@ -6,4 +6,4 @@
>  
>  obj-$(CONFIG_NGBE) += ngbe.o
>  
> -ngbe-objs := ngbe_main.o ngbe_hw.o
> +ngbe-objs := ngbe_main.o ngbe_hw.o ngbe_mdio.o
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> index 588de24b5e18..453ad736f9c7 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> @@ -39,16 +39,25 @@ int ngbe_eeprom_chksum_hostif(struct wx *wx)
>  static int ngbe_reset_misc(struct wx *wx)
>  {
>  	wx_reset_misc(wx);
> -	if (wx->mac_type == em_mac_type_rgmii)
> -		wr32(wx, NGBE_MDIO_CLAUSE_SELECT, 0xF);
>  	if (wx->gpio_ctrl) {
>  		/* gpio0 is used to power on/off control*/
>  		wr32(wx, NGBE_GPIO_DDR, 0x1);
> -		wr32(wx, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
> +		ngbe_sfp_modules_txrx_powerctl(wx, false);
>  	}
>  	return 0;
>  }
>  
> +void ngbe_sfp_modules_txrx_powerctl(struct wx *wx, bool swi)
> +{
> +	if (swi) {
> +		/* gpio0 is used to power on control*/
> +		wr32(wx, NGBE_GPIO_DR, 0);
> +	} else {
> +		/* gpio0 is used to power off control*/
> +		wr32(wx, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
> +	}
> +}
> +
>  /**
>   *  ngbe_reset_hw - Perform hardware reset
>   *  @wx: pointer to hardware structure
> @@ -59,15 +68,26 @@ static int ngbe_reset_misc(struct wx *wx)
>   **/
>  int ngbe_reset_hw(struct wx *wx)
>  {
> -	int status = 0;
> -	u32 reset = 0;
> +	u32 val = 0;
> +	int ret = 0;
>  
>  	/* Call wx stop to disable tx/rx and clear interrupts */
> -	status = wx_stop_adapter(wx);
> -	if (status != 0)
> -		return status;
> -	reset = WX_MIS_RST_LAN_RST(wx->bus.func);
> -	wr32(wx, WX_MIS_RST, reset | rd32(wx, WX_MIS_RST));
> +	ret = wx_stop_adapter(wx);
> +	if (ret != 0)
> +		return ret;
> +
> +	if (wx->mac_type != em_mac_type_mdi) {
> +		val = WX_MIS_RST_LAN_RST(wx->bus.func);
> +		wr32(wx, WX_MIS_RST, val | rd32(wx, WX_MIS_RST));
> +
> +		ret = read_poll_timeout(rd32, val,
> +					!(val & (BIT(9) << wx->bus.func)), 1000,
> +					100000, false, wx, 0x10028);
> +		if (ret) {
> +			wx_err(wx, "Lan reset exceed s maximum times.\n");
> +			return ret;
> +		}
> +	}
>  	ngbe_reset_misc(wx);
>  
>  	/* Store the permanent mac address */
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
> index 8d14d51c0a90..a4693e006816 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
> @@ -8,5 +8,6 @@
>  #define _NGBE_HW_H_
>  
>  int ngbe_eeprom_chksum_hostif(struct wx *wx);
> +void ngbe_sfp_modules_txrx_powerctl(struct wx *wx, bool swi);
>  int ngbe_reset_hw(struct wx *wx);
>  #endif /* _NGBE_HW_H_ */
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> index f66513ddf6d9..ed52f80b5475 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> @@ -9,10 +9,12 @@
>  #include <linux/aer.h>
>  #include <linux/etherdevice.h>
>  #include <net/ip.h>
> +#include <linux/phy.h>
>  
>  #include "../libwx/wx_type.h"
>  #include "../libwx/wx_hw.h"
>  #include "ngbe_type.h"
> +#include "ngbe_mdio.h"
>  #include "ngbe_hw.h"
>  
>  char ngbe_driver_name[] = "ngbe";
> @@ -146,11 +148,29 @@ static int ngbe_sw_init(struct wx *wx)
>  	return 0;
>  }
>  
> +static void ngbe_disable_device(struct wx *wx)
> +{
> +	struct net_device *netdev = wx->netdev;
> +
> +	/* disable receives */
> +	wx_disable_rx(wx);
> +	netif_tx_disable(netdev);
> +	if (wx->gpio_ctrl)
> +		ngbe_sfp_modules_txrx_powerctl(wx, false);
> +}
> +
>  static void ngbe_down(struct wx *wx)
>  {
> -	netif_carrier_off(wx->netdev);
> -	netif_tx_disable(wx->netdev);
> -};
> +	phy_stop(wx->phydev);
> +	ngbe_disable_device(wx);
> +}
> +
> +static void ngbe_up(struct wx *wx)
> +{
> +	if (wx->gpio_ctrl)
> +		ngbe_sfp_modules_txrx_powerctl(wx, true);
> +	phy_start(wx->phydev);
> +}
>  
>  /**
>   * ngbe_open - Called when a network interface is made active
> @@ -164,8 +184,13 @@ static void ngbe_down(struct wx *wx)
>  static int ngbe_open(struct net_device *netdev)
>  {
>  	struct wx *wx = netdev_priv(netdev);
> +	int err;
>  
>  	wx_control_hw(wx, true);
> +	err = ngbe_phy_connect(wx);
> +	if (err)
> +		return err;
> +	ngbe_up(wx);
>  
>  	return 0;
>  }
> @@ -186,6 +211,7 @@ static int ngbe_close(struct net_device *netdev)
>  	struct wx *wx = netdev_priv(netdev);
>  
>  	ngbe_down(wx);
> +	phy_disconnect(wx->phydev);
>  	wx_control_hw(wx, false);
>  
>  	return 0;
> @@ -385,6 +411,11 @@ static int ngbe_probe(struct pci_dev *pdev,
>  	eth_hw_addr_set(netdev, wx->mac.perm_addr);
>  	wx_mac_set_default_filter(wx, wx->mac.perm_addr);
>  
> +	/* phy Interface Configuration */
> +	err = ngbe_mdio_init(wx);
> +	if (err)
> +		goto err_free_mac_table;
> +
>  	err = register_netdev(netdev);
>  	if (err)
>  		goto err_register;
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
> new file mode 100644
> index 000000000000..ba88aca5b045
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
> @@ -0,0 +1,244 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
> +
> +#include <linux/ethtool.h>
> +#include <linux/iopoll.h>
> +#include <linux/pci.h>
> +#include <linux/phy.h>
> +
> +#include "../libwx/wx_type.h"
> +#include "../libwx/wx_hw.h"
> +#include "ngbe_type.h"
> +#include "ngbe_mdio.h"
> +
> +static int ngbe_phy_read_reg_internal(struct mii_bus *bus, int phy_addr, int regnum)
> +{
> +	struct wx *wx = bus->priv;
> +
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +	return (u16)rd32(wx, NGBE_PHY_CONFIG(regnum));
> +}
> +
> +static int ngbe_phy_write_reg_internal(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
> +{
> +	struct wx *wx = bus->priv;
> +
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +	wr32(wx, NGBE_PHY_CONFIG(regnum), value);
> +	return 0;
> +}
> +
> +static int ngbe_phy_read_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum)
> +{
> +	u32 command, device_type = 0;
> +	struct wx *wx = bus->priv;
> +	u32 val;
> +	int ret;
> +
> +	if (regnum & MII_ADDR_C45) {
> +		wr32(wx, NGBE_MDIO_CLAUSE_SELECT, 0x0);
> +		/* setup and write the address cycle command */
> +		command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
> +			  NGBE_MSCA_PA(phy_addr) |
> +			  NGBE_MSCA_DA(mdiobus_c45_devad(regnum));
> +	} else {
> +		wr32(wx, NGBE_MDIO_CLAUSE_SELECT, 0xF);
> +		/* setup and write the address cycle command */
> +		command = NGBE_MSCA_RA(regnum) |
> +			  NGBE_MSCA_PA(phy_addr) |
> +			  NGBE_MSCA_DA(device_type);
> +	}
> +	wr32(wx, NGBE_MSCA, command);
> +	command = NGBE_MSCC_CMD(NGBE_MSCA_CMD_READ) |
> +		  NGBE_MSCC_BUSY |
> +		  NGBE_MDIO_CLK(6);
> +	wr32(wx, NGBE_MSCC, command);
> +
> +	/* wait to complete */
> +	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
> +				100000, false, wx, NGBE_MSCC);
> +	if (ret) {
> +		wx_err(wx, "PHY address command did not complete.\n");
> +		return ret;
> +	}
> +
> +	return (u16)rd32(wx, NGBE_MSCC);
> +}
> +
> +static int ngbe_phy_write_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
> +{
> +	u32 command, device_type = 0;
> +	struct wx *wx = bus->priv;
> +	int ret;
> +	u16 val;
> +
> +	if (regnum & MII_ADDR_C45) {
> +		wr32(wx, NGBE_MDIO_CLAUSE_SELECT, 0x0);
> +		/* setup and write the address cycle command */
> +		command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
> +			  NGBE_MSCA_PA(phy_addr) |
> +			  NGBE_MSCA_DA(mdiobus_c45_devad(regnum));
> +	} else {
> +		wr32(wx, NGBE_MDIO_CLAUSE_SELECT, 0xF);
> +		/* setup and write the address cycle command */
> +		command = NGBE_MSCA_RA(regnum) |
> +			  NGBE_MSCA_PA(phy_addr) |
> +			  NGBE_MSCA_DA(device_type);
> +	}
> +	wr32(wx, NGBE_MSCA, command);
> +	command = value |
> +		  NGBE_MSCC_CMD(NGBE_MSCA_CMD_WRITE) |
> +		  NGBE_MSCC_BUSY |
> +		  NGBE_MDIO_CLK(6);
> +	wr32(wx, NGBE_MSCC, command);
> +
> +	/* wait to complete */
> +	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
> +				100000, false, wx, NGBE_MSCC);
> +	if (ret)
> +		wx_err(wx, "PHY address command did not complete.\n");
> +
> +	return ret;
> +}
> +
> +static int ngbe_phy_read_reg(struct mii_bus *bus, int phy_addr, int regnum)
> +{
> +	struct wx *wx = bus->priv;
> +	u16 phy_data;
> +
> +	if (wx->mac_type == em_mac_type_mdi)
> +		phy_data = ngbe_phy_read_reg_internal(bus, phy_addr, regnum);
> +	else
> +		phy_data = ngbe_phy_read_reg_mdi(bus, phy_addr, regnum);
> +
> +	return phy_data;
> +}
> +
> +static int ngbe_phy_write_reg(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
> +{
> +	struct wx *wx = bus->priv;
> +	int ret;
> +
> +	if (wx->mac_type == em_mac_type_mdi)
> +		ret = ngbe_phy_write_reg_internal(bus, phy_addr, regnum, value);
> +	else
> +		ret = ngbe_phy_write_reg_mdi(bus, phy_addr, regnum, value);
> +
> +	return ret;
> +}
> +
> +static void ngbe_handle_link_change(struct net_device *dev)
> +{
> +	struct wx *wx = netdev_priv(dev);
> +	struct phy_device *phydev;
> +	u32 lan_speed, reg;
> +
> +	phydev = wx->phydev;
> +	if (!(wx->link != phydev->link ||
> +	      wx->speed != phydev->speed ||
> +	      wx->duplex != phydev->duplex))
> +		return;
> +
> +	wx->link = phydev->link;
> +	wx->speed = phydev->speed;
> +	wx->duplex = phydev->duplex;
> +	switch (phydev->speed) {
> +	case SPEED_10:
> +		lan_speed = 0;
> +		break;
> +	case SPEED_100:
> +		lan_speed = 1;
> +		break;
> +	case SPEED_1000:
> +	default:
> +		lan_speed = 2;
> +		break;
> +	}
> +	wr32m(wx, NGBE_CFG_LAN_SPEED, 0x3, lan_speed);
> +
> +	if (phydev->link) {
> +		reg = rd32(wx, WX_MAC_TX_CFG);
> +		reg &= ~WX_MAC_TX_CFG_SPEED_MASK;
> +		reg |= WX_MAC_TX_CFG_SPEED_1G | WX_MAC_TX_CFG_TE;
> +		wr32(wx, WX_MAC_TX_CFG, reg);
> +		/* Re configure MAC RX */
> +		reg = rd32(wx, WX_MAC_RX_CFG);
> +		wr32(wx, WX_MAC_RX_CFG, reg);
> +		wr32(wx, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
> +		reg = rd32(wx, WX_MAC_WDG_TIMEOUT);
> +		wr32(wx, WX_MAC_WDG_TIMEOUT, reg);
> +	}
> +	phy_print_status(phydev);
> +}
> +
> +int ngbe_phy_connect(struct wx *wx)
> +{
> +	int ret;
> +
> +	ret = phy_connect_direct(wx->netdev,
> +				 wx->phydev,
> +				 ngbe_handle_link_change,
> +				 PHY_INTERFACE_MODE_RGMII_ID);
> +	if (ret) {
> +		wx_err(wx, "PHY connect failed.\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void ngbe_phy_fixup(struct wx *wx)
> +{
> +	struct phy_device *phydev = wx->phydev;
> +	struct ethtool_eee eee;
> +
> +	if (wx->mac_type != em_mac_type_mdi)
> +		return;
> +	/* disable EEE, EEE not supported by mac */
> +	memset(&eee, 0, sizeof(eee));
> +	phy_ethtool_set_eee(phydev, &eee);
> +
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> +}
> +
> +int ngbe_mdio_init(struct wx *wx)
> +{
> +	struct pci_dev *pdev = wx->pdev;
> +	struct mii_bus *mii_bus;
> +	int ret;
> +
> +	mii_bus = devm_mdiobus_alloc(&pdev->dev);
> +	if (!mii_bus)
> +		return -ENOMEM;
> +
> +	mii_bus->name = "ngbe_mii_bus";
> +	mii_bus->read = ngbe_phy_read_reg;
> +	mii_bus->write = ngbe_phy_write_reg;
> +	mii_bus->phy_mask = GENMASK(31, 4);
> +	mii_bus->probe_capabilities = MDIOBUS_C22_C45;
> +	mii_bus->parent = &pdev->dev;
> +	mii_bus->priv = wx;
> +
> +	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "ngbe-%x",
> +		 (pdev->bus->number << 8) | pdev->devfn);

There are helpers you can use here. And at least for r8169 it turned out
that there are setups where bus number + devfn isn't unique.
For your reference here how it's done in r8169.

snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));

And you didn't send the patch mail to the maintainers.
Use scripts/get_maintainers.pl.

> +	ret = devm_mdiobus_register(&pdev->dev, mii_bus);
> +	if (ret)
> +		return ret;
> +
> +	wx->phydev = phy_find_first(mii_bus);
> +	if (!wx->phydev)
> +		return -ENODEV;
> +
> +	phy_attached_info(wx->phydev);
> +	ngbe_phy_fixup(wx);
> +
> +	wx->link = 0;
> +	wx->speed = 0;
> +	wx->duplex = 0;
> +
> +	return 0;
> +}
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h
> new file mode 100644
> index 000000000000..0a6400dd89c4
> --- /dev/null
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * WangXun Gigabit PCI Express Linux driver
> + * Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
> + */
> +
> +#ifndef _NGBE_MDIO_H_
> +#define _NGBE_MDIO_H_
> +
> +int ngbe_phy_connect(struct wx *wx);
> +int ngbe_mdio_init(struct wx *wx);
> +#endif /* _NGBE_MDIO_H_ */
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> index 369d181930bc..612b9da2db8f 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> @@ -60,6 +60,26 @@
>  #define NGBE_EEPROM_VERSION_L			0x1D
>  #define NGBE_EEPROM_VERSION_H			0x1E
>  
> +/* mdio access */
> +#define NGBE_MSCA				0x11200
> +#define NGBE_MSCA_RA(v)				((0xFFFF & (v)))
> +#define NGBE_MSCA_PA(v)				((0x1F & (v)) << 16)
> +#define NGBE_MSCA_DA(v)				((0x1F & (v)) << 21)
> +#define NGBE_MSCC				0x11204
> +#define NGBE_MSCC_DATA(v)			((0xFFFF & (v)))
> +#define NGBE_MSCC_CMD(v)			((0x3 & (v)) << 16)
> +
> +enum NGBE_MSCA_CMD_value {
> +	NGBE_MSCA_CMD_RSV = 0,
> +	NGBE_MSCA_CMD_WRITE,
> +	NGBE_MSCA_CMD_POST_READ,
> +	NGBE_MSCA_CMD_READ,
> +};
> +
> +#define NGBE_MSCC_SADDR				BIT(18)
> +#define NGBE_MSCC_BUSY				BIT(22)
> +#define NGBE_MDIO_CLK(v)			((0x7 & (v)) << 19)
> +
>  /* Media-dependent registers. */
>  #define NGBE_MDIO_CLAUSE_SELECT			0x11220
>  
> @@ -72,6 +92,10 @@
>  #define NGBE_GPIO_DDR_0				BIT(0) /* SDP0 IO direction */
>  #define NGBE_GPIO_DDR_1				BIT(1) /* SDP1 IO direction */
>  
> +#define NGBE_PHY_CONFIG(reg_offset)		(0x14000 + ((reg_offset) * 4))
> +#define NGBE_CFG_LAN_SPEED			0x14440
> +#define NGBE_CFG_PORT_ST			0x14404
> +
>  /* Wake up registers */
>  #define NGBE_PSR_WKUP_CTL			0x15B80
>  /* Wake Up Filter Control Bit */

