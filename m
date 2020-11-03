Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD632A4C4B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgKCRHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:07:12 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42046 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgKCRHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:07:12 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A3H75ZD057067;
        Tue, 3 Nov 2020 11:07:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604423226;
        bh=5jr2NaHoF/hYVKjlqvgEQz3+dRAvWa8eW4Ujvs32+RY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=CS6LP50iXykiutgauJNqZeRIeMrm5mtqICHJFsNl9vNMAU3AJvuiVnVEfCaIYbpmN
         QKutN8OoFdrUugIALtp9YjoCcvMT56qnR75REUByZ4L0nt530rsdTz+lJ01MIVQJ3m
         hfXskvmoSN122687jcgQMsNUA72Z6RBxpoyolA7U=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A3H75H4072200
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Nov 2020 11:07:05 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 3 Nov
 2020 11:07:05 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 3 Nov 2020 11:07:05 -0600
Received: from [10.250.36.55] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A3H75hd041336;
        Tue, 3 Nov 2020 11:07:05 -0600
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com> <20201030201515.GE1042051@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <202b6626-b7bf-3159-f474-56f6fa0c8247@ti.com>
Date:   Tue, 3 Nov 2020 11:07:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030201515.GE1042051@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 10/30/20 3:15 PM, Andrew Lunn wrote:
>> +static int dp83td510_config_init(struct phy_device *phydev)
>> +{
>> +	struct dp83td510_private *dp83td510 = phydev->priv;
>> +	int mst_slave_cfg;
>> +	int ret = 0;
>> +
>> +	if (phy_interface_is_rgmii(phydev)) {
>> +		if (dp83td510->rgmii_delay) {
>> +			ret = phy_set_bits_mmd(phydev, DP83TD510_DEVADDR,
>> +					       DP83TD510_MAC_CFG_1, dp83td510->rgmii_delay);
>> +			if (ret)
>> +				return ret;
>> +		}
>> +	}
> Hi Dan
>
> I'm getting a bit paranoid about RGMII delays...
Not sure what this means.
>
>> +static int dp83td510_read_straps(struct phy_device *phydev)
>> +{
>> +	struct dp83td510_private *dp83td510 = phydev->priv;
>> +	int strap;
>> +
>> +	strap = phy_read_mmd(phydev, DP83TD510_DEVADDR, DP83TD510_SOR_1);
>> +	if (strap < 0)
>> +		return strap;
>> +
>> +	if (strap & DP83TD510_RGMII)
>> +		dp83td510->is_rgmii = true;
>> +
>> +	return 0;
>> +};
> So dp83td510->is_rgmii is the strapping configuration. So if one of
> the four RGMII modes is selected, your appear to ignore which of the
> four is selected, and program the hardware with the strapping?
>
> That seems like a bad idea.
I will re-look at this code.
>
>> +#if IS_ENABLED(CONFIG_OF_MDIO)
>> +static int dp83td510_of_init(struct phy_device *phydev)
>> +{
>> +	struct dp83td510_private *dp83td510 = phydev->priv;
>> +	struct device *dev = &phydev->mdio.dev;
>> +	struct device_node *of_node = dev->of_node;
>> +	s32 rx_int_delay;
>> +	s32 tx_int_delay;
>> +	int ret;
>> +
>> +	if (!of_node)
>> +		return -ENODEV;
>> +
>> +	ret = dp83td510_read_straps(phydev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	dp83td510->hi_diff_output = device_property_read_bool(&phydev->mdio.dev,
>> +							      "tx-rx-output-high");
>> +
>> +	if (device_property_read_u32(&phydev->mdio.dev, "tx-fifo-depth",
>> +				     &dp83td510->tx_fifo_depth))
>> +		dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_5_B_NIB;
> Please don't use device_property_read_foo API, we don't want to give
> the impression it is O.K. to stuff DT properties in ACPI
> tables. Please use of_ API calls.

Hmm. Is this a new stance in DT handling for the networking tree?

If it is should I go back and rework some of my other drivers that use 
device_property APIs

Dan

