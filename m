Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D246D35ED36
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 08:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhDNGZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 02:25:23 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39386 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhDNGZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 02:25:21 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13E6OgMg087065;
        Wed, 14 Apr 2021 01:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618381482;
        bh=Tatg9a6e94y6CMD2F/1h6q8KcihISkNKSKxCVmDchLg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=POFmz0mINczFqTmRV4tMH4wqLntuBNuF7Ziamx3V0VWlQyvjPGVjC4DTuCSSfFyv/
         JVlWXxsGi8rvC/p5ZaS3B3uDydfg0V1D0WmXNz+pz8n7wceB9lZFd6hV2eOoXO/+yp
         axzDhfIOSxbf8j6rhpC8WgRSgO59dNtlZxbFjnSA=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13E6OgW4109341
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Apr 2021 01:24:42 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 14
 Apr 2021 01:24:42 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 14 Apr 2021 01:24:42 -0500
Received: from [172.24.145.148] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13E6Oa7I097401;
        Wed, 14 Apr 2021 01:24:37 -0500
Subject: Re: [PATCH 2/4] phy: phy-can-transceiver: Add support for generic CAN
 transceiver driver
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>
References: <20210409134056.18740-1-a-govindraju@ti.com>
 <20210409134056.18740-3-a-govindraju@ti.com>
 <fe0a8a9b-35c6-8f23-5968-0b14abb6078d@pengutronix.de>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <a7c72056-8d3d-f9ba-b8f0-868a4926a7d6@ti.com>
Date:   Wed, 14 Apr 2021 11:54:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fe0a8a9b-35c6-8f23-5968-0b14abb6078d@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 12/04/21 3:48 pm, Marc Kleine-Budde wrote:
> On 4/9/21 3:40 PM, Aswath Govindraju wrote:
>> The driver adds support for generic CAN transceivers. Currently
>> the modes supported by this driver are standby and normal modes for TI
>> TCAN1042 and TCAN1043 CAN transceivers.
>>
>> The transceiver is modelled as a phy with pins controlled by gpios, to put
>> the transceiver in various device functional modes. It also gets the phy
>> attribute max_link_rate for the usage of m_can drivers.
> 
> This driver should be independent of CAN driver, so you should not mention a
> specific driver here.
> 

I will substitute m_can with can in the respin.

>> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
>> ---
>>  drivers/phy/Kconfig               |   9 ++
>>  drivers/phy/Makefile              |   1 +
>>  drivers/phy/phy-can-transceiver.c | 140 ++++++++++++++++++++++++++++++
>>  3 files changed, 150 insertions(+)
>>  create mode 100644 drivers/phy/phy-can-transceiver.c
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 54c1f2f0985f..51902b629fc6 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -61,6 +61,15 @@ config USB_LGM_PHY
>>  	  interface to interact with USB GEN-II and USB 3.x PHY that is part
>>  	  of the Intel network SOC.
>>  
>> +config PHY_CAN_TRANSCEIVER
>> +	tristate "CAN transceiver PHY"
>> +	select GENERIC_PHY
>> +	help
>> +	  This option enables support for CAN transceivers as a PHY. This
>> +	  driver provides function for putting the transceivers in various
>> +	  functional modes using gpios and sets the attribute max link
>> +	  rate, for mcan drivers.
>> +
>>  source "drivers/phy/allwinner/Kconfig"
>>  source "drivers/phy/amlogic/Kconfig"
>>  source "drivers/phy/broadcom/Kconfig"
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index adac1b1a39d1..9c66101c9605 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -9,6 +9,7 @@ obj-$(CONFIG_PHY_LPC18XX_USB_OTG)	+= phy-lpc18xx-usb-otg.o
>>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
>>  obj-$(CONFIG_PHY_PISTACHIO_USB)		+= phy-pistachio-usb.o
>>  obj-$(CONFIG_USB_LGM_PHY)		+= phy-lgm-usb.o
>> +obj-$(CONFIG_PHY_CAN_TRANSCEIVER)	+= phy-can-transceiver.o
>>  obj-y					+= allwinner/	\
>>  					   amlogic/	\
>>  					   broadcom/	\
>> diff --git a/drivers/phy/phy-can-transceiver.c b/drivers/phy/phy-can-transceiver.c
>> new file mode 100644
>> index 000000000000..14496f6e1666
>> --- /dev/null
>> +++ b/drivers/phy/phy-can-transceiver.c
>> @@ -0,0 +1,140 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * phy-can-transceiver.c - phy driver for CAN transceivers
>> + *
>> + * Copyright (C) 2021 Texas Instruments Incorporated - http://www.ti.com
>> + *
>> + */
>> +#include<linux/phy/phy.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/module.h>
>> +#include<linux/gpio.h>
>> +#include<linux/gpio/consumer.h>
>> +
>> +struct can_transceiver_data {
>> +	u32 flags;
>> +#define STB_PRESENT	BIT(0)
>> +#define EN_PRESENT	BIT(1)
> 
> please add a common prefix to the defines

I will add a common prefix(GPIO) in the respin.

> 
>> +};
>> +
>> +struct can_transceiver_phy {
>> +	struct phy *generic_phy;
>> +	struct gpio_desc *standby_gpio;
>> +	struct gpio_desc *enable_gpio;
>> +};
>> +
>> +/* Power on function */
>> +static int can_transceiver_phy_power_on(struct phy *phy)
>> +{
>> +	struct can_transceiver_phy *can_transceiver_phy = phy_get_drvdata(phy);
>> +
>> +	if (can_transceiver_phy->standby_gpio)
>> +		gpiod_set_value_cansleep(can_transceiver_phy->standby_gpio, 0);
>> +	if (can_transceiver_phy->enable_gpio)
>> +		gpiod_set_value_cansleep(can_transceiver_phy->enable_gpio, 1);
> 
> Please add a newline before the return.
> 

Will make this change in the respin.

>> +	return 0;
>> +}
>> +
>> +/* Power off function */
>> +static int can_transceiver_phy_power_off(struct phy *phy)
>> +{
>> +	struct can_transceiver_phy *can_transceiver_phy = phy_get_drvdata(phy);
>> +
>> +	if (can_transceiver_phy->standby_gpio)
>> +		gpiod_set_value_cansleep(can_transceiver_phy->standby_gpio, 1);
>> +	if (can_transceiver_phy->enable_gpio)
>> +		gpiod_set_value_cansleep(can_transceiver_phy->enable_gpio, 0);
> 
> same here
> 

Will make this change in the respin

>> +	return 0;
>> +}
>> +
>> +static const struct phy_ops can_transceiver_phy_ops = {
>> +	.power_on	= can_transceiver_phy_power_on,
>> +	.power_off	= can_transceiver_phy_power_off,
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>> +static const struct can_transceiver_data tcan1042_drvdata = {
>> +	.flags = STB_PRESENT,
>> +};
>> +
>> +static const struct can_transceiver_data tcan1043_drvdata = {
>> +	.flags = STB_PRESENT | EN_PRESENT,
>> +};
>> +
>> +static const struct of_device_id can_transceiver_phy_ids[] = {
>> +	{
>> +		.compatible = "ti,tcan1042",
>> +		.data = &tcan1042_drvdata
>> +	},
>> +	{
>> +		.compatible = "ti,tcan1043",
>> +		.data = &tcan1043_drvdata
>> +	},
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, can_transceiver_phy_ids);
>> +
>> +int can_transceiver_phy_probe(struct platform_device *pdev)
>> +{
>> +	struct phy_provider *phy_provider;
>> +	struct device *dev = &pdev->dev;
>> +	struct can_transceiver_phy *can_transceiver_phy;
>> +	const struct can_transceiver_data *drvdata;
>> +	const struct of_device_id *match;
>> +	struct phy *phy;
>> +	struct gpio_desc *standby_gpio;
>> +	struct gpio_desc *enable_gpio;
>> +	u32 max_bitrate = 0;
>> +
>> +	can_transceiver_phy = devm_kzalloc(dev, sizeof(struct can_transceiver_phy), GFP_KERNEL);
> 
> error handling?
> 

Will add this in the respin.

>> +
>> +	match = of_match_node(can_transceiver_phy_ids, pdev->dev.of_node);
>> +	drvdata = match->data;
>> +
>> +	phy = devm_phy_create(dev, dev->of_node,
>> +			      &can_transceiver_phy_ops);
>> +	if (IS_ERR(phy)) {
>> +		dev_err(dev, "failed to create can transceiver phy\n");
>> +		return PTR_ERR(phy);
>> +	}
>> +
>> +	device_property_read_u32(dev, "max-bitrate", &max_bitrate);
>> +	phy->attrs.max_link_rate = max_bitrate / 1000000;
> 
> The problem is, there are CAN transceivers with a max of 83.3 kbit/s or 125 kbit/s.
> 

The only way that I was able to find for this is to add a phy attribute
"max_bit_rate" in include/linux/phy/phy.h. Would this be an acceptable
solution ?

>> +	can_transceiver_phy->generic_phy = phy;
>> +
>> +	if (drvdata->flags & STB_PRESENT) {
>> +		standby_gpio = devm_gpiod_get(dev, "standby",   GPIOD_OUT_LOW);
> 
> please use only one space after the ",".

Will correct this in respin.

> Why do you request the gpio standby low?

While probing the transceiver has to be in standby state and only after
calling the power on does the transceiver go to enable state. This was
the reason behind requesting gpio standby low.

Thank you for for review.

Regards,
Aswath

> 
>> +		if (IS_ERR(standby_gpio))
>> +			return PTR_ERR(standby_gpio);
>> +		can_transceiver_phy->standby_gpio = standby_gpio;
>> +	}
>> +
>> +	if (drvdata->flags & EN_PRESENT) {
>> +		enable_gpio = devm_gpiod_get(dev, "enable",   GPIOD_OUT_LOW);
>> +		if (IS_ERR(enable_gpio))
>> +			return PTR_ERR(enable_gpio);
>> +		can_transceiver_phy->enable_gpio = enable_gpio;
>> +	}
>> +
>> +	phy_set_drvdata(can_transceiver_phy->generic_phy, can_transceiver_phy);
>> +
>> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
>> +
>> +	return PTR_ERR_OR_ZERO(phy_provider);
>> +}
>> +
>> +static struct platform_driver can_transceiver_phy_driver = {
>> +	.probe = can_transceiver_phy_probe,
>> +	.driver = {
>> +		.name = "can-transceiver-phy",
>> +		.of_match_table = can_transceiver_phy_ids,
>> +	},
>> +};
>> +
>> +module_platform_driver(can_transceiver_phy_driver);
>> +
>> +MODULE_AUTHOR("Faiz Abbas <faiz_abbas@ti.com>");
>> +MODULE_AUTHOR("Aswath Govindraju <a-govindraju@ti.com>");
>> +MODULE_DESCRIPTION("CAN TRANSCEIVER PHY driver");
>> +MODULE_LICENSE("GPL v2");
>>
> 
> marc
> 

