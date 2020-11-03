Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E202A4D20
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgKCRfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:35:33 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47608 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgKCRfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:35:32 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A3HZRPk066684;
        Tue, 3 Nov 2020 11:35:27 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604424927;
        bh=W7y49awQhyYVVMmsSYn2fTrpiqhwtNzdGyjtxk/kf/E=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qwvSd6VoWk9icL4AMTQXD1AkIWRG+ct7pHhXCj/JFRh74guIK15HyXAE+JKibQLg4
         Wadfw+NfPWWPvYDIqWc7pquI93jA5+dVpJdENZQrSsCDhmkWvBRpQXtQYafD5a7OTT
         TlBJ/cS+O/QAe/eYMXHpNmusqM7LBGDmsR9F/d0E=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A3HZQ2t079464
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Nov 2020 11:35:26 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 3 Nov
 2020 11:35:26 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 3 Nov 2020 11:35:26 -0600
Received: from [10.250.36.55] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A3HZQQ7045673;
        Tue, 3 Nov 2020 11:35:26 -0600
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com> <20201030201515.GE1042051@lunn.ch>
 <202b6626-b7bf-3159-f474-56f6fa0c8247@ti.com>
 <20201103171838.GN1042051@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <f44af428-acd9-daef-3609-4d6ea24cd436@ti.com>
Date:   Tue, 3 Nov 2020 11:35:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201103171838.GN1042051@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 11/3/20 11:18 AM, Andrew Lunn wrote:
> On Tue, Nov 03, 2020 at 11:07:00AM -0600, Dan Murphy wrote:
>> Andrew
>>
>> On 10/30/20 3:15 PM, Andrew Lunn wrote:
>>>> +static int dp83td510_config_init(struct phy_device *phydev)
>>>> +{
>>>> +	struct dp83td510_private *dp83td510 = phydev->priv;
>>>> +	int mst_slave_cfg;
>>>> +	int ret = 0;
>>>> +
>>>> +	if (phy_interface_is_rgmii(phydev)) {
>>>> +		if (dp83td510->rgmii_delay) {
>>>> +			ret = phy_set_bits_mmd(phydev, DP83TD510_DEVADDR,
>>>> +					       DP83TD510_MAC_CFG_1, dp83td510->rgmii_delay);
>>>> +			if (ret)
>>>> +				return ret;
>>>> +		}
>>>> +	}
>>> Hi Dan
>>>
>>> I'm getting a bit paranoid about RGMII delays...
>> Not sure what this means.
> See the discussion and breakage around the realtek PHY. It wrongly
> implemented RGMII delays. When it was fixed, lots of board broke
> because the bug in the PHY driver hid bugs in the DT.
>
I will have to go find that thread. Do you have a link?
>>> Please don't use device_property_read_foo API, we don't want to give
>>> the impression it is O.K. to stuff DT properties in ACPI
>>> tables. Please use of_ API calls.
>> Hmm. Is this a new stance in DT handling for the networking tree?
>>
>> If it is should I go back and rework some of my other drivers that use
>> device_property APIs
> There is a slowly growing understanding what ACPI support in this area
> means. It seems to mean that the firmware should actually do all the
> setup, and the kernel should not touch the hardware configuration. But
> some developers are ignoring this, and just stuffing DT properties
> into ACPI tables and letting the kernel configure the hardware, if it
> happens to use the device_property_read API. So i want to make it
> clear that these properties are for device tree, and if you want to
> use ACPI, you should do things the ACPI way.
>
> For new code, i will be pushing for OF only calls. Older code is a bit
> more tricky. There might be boards out there using ACPI, but doing it
> wrongly, and stuffing OF properties into ACPI tables. We should try to
> avoid breaking them.

Got it.  I will move back to of_* calls

Dan


>        Andrew
