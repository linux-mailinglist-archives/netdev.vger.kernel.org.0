Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F83126E3DD
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgIQSgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:36:52 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41856 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgIQSg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:36:26 -0400
X-Greylist: delayed 13114 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 14:36:25 EDT
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08HEvfcf109799;
        Thu, 17 Sep 2020 09:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600354661;
        bh=MUUriQmoDl0IAD2+idX5HWLt4OHGMZ2OvXBr/yXqYPE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ZKpGyqo57A7n6jxXx7n3Wxj53/PWhJRKroietC2X5tdvUpbXqL8dFoeHiQjODT55Z
         b+krQ8NSrtZiLqUZ1FagRiMMDAZw1S48+pEfzBGcRMxcWbFMq/7CMKs4rFUiXYlYT7
         xjHZGXTYSxTrlEMxRZouG02zHFsU1stRn+bLwooA=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08HEvfW8091773;
        Thu, 17 Sep 2020 09:57:41 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 17
 Sep 2020 09:57:41 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 17 Sep 2020 09:57:41 -0500
Received: from [10.250.32.129] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08HEvfeX021517;
        Thu, 17 Sep 2020 09:57:41 -0500
Subject: Re: [PATCH net-next 2/3] net: dp83869: Add ability to advertise Fiber
 connection
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200915181708.25842-1-dmurphy@ti.com>
 <20200915181708.25842-3-dmurphy@ti.com> <20200915201718.GD3526428@lunn.ch>
 <4b297d8a-b4da-0e19-a5fb-6dda89ca4148@ti.com>
 <20200916221313.GI3526428@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <44ee56f6-fd72-b479-3b96-7565a439e4bc@ti.com>
Date:   Thu, 17 Sep 2020 09:57:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916221313.GI3526428@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 9/16/20 5:13 PM, Andrew Lunn wrote:
> On Wed, Sep 16, 2020 at 03:54:34PM -0500, Dan Murphy wrote:
>> Andrew
>>
>> On 9/15/20 3:17 PM, Andrew Lunn wrote:
>>>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
>>>> +				 phydev->supported);
>>>> +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
>>>> +				 phydev->supported);
>>>> +
>>>> +		/* Auto neg is not supported in 100base FX mode */
>>> Hi Dan
>>>
>>> If it does not support auto neg, how do you decide to do half duplex?
>>> I don't see any code here which allows the user to configure it.
>> Ethtool has the provisions to set the duplex and speed right?.
> What i'm getting at is you say you support
> ETHTOOL_LINK_MODE_100baseFX_Full_BIT &
> ETHTOOL_LINK_MODE_100baseFX_Half_BIT. If there is no auto neg in FX
> mode, i'm questioning how these two different modes code be used? I'm
> guessing the PHY defaults to ETHTOOL_LINK_MODE_100baseFX_Full_BIT? How
> does the user set it to ETHTOOL_LINK_MODE_100baseFX_Half_BIT?

The user can use ethtool to set the speed and duplex. And ethtool uses 
the IOCTLs to configure the device.

So if the user creates their own HAL then they can use those IOCTLs as well.

The data sheet indicates

"In fiber mode, the speed is not
decided through auto-negotiation. Both sides of the link must be 
configured to the same operating speed."

>
>> The only call back I see which is valid is config_aneg which would still
>> require a user space tool to set the needed link modes.
> Correct. Maybe all you need to do is point me at the code in the
> driver which actually sets the PHY into half duplex in FX mode when
> the user asks for it. Is it just clearing BMCR_FULLDPLX?

Here is the full flow when setting the speed and duplex mode from the 
Ethtool or when the IOCTL's are called to update the PHY

phy_ethtool_ksettings_set updates the phydev->speed and phydev->duplex

Since Auto Neg is disabled the call to genphy_setup_forced is done in 
the __genphy_config_aneg in phy_device.

genphy_setup_forced updates the BMCR with the updated values.

So IMO there is no need to populate the config_aneg call back to

root@am335x-evm:~# ./ethtool -s eth0 speed 10 duplex half
[   92.098491] phy_ethtool_ksettings_set
[   92.102247] phy_ethtool_ksettings_set: speed 10 duplex 0
[   92.107755] phy_sanitize_settings
[   92.111085] phy_config_aneg
[   92.113930] genphy_config_aneg
[   92.116997] __genphy_config_aneg
[   92.120237] genphy_setup_forced
[   92.123419] genphy_setup_forced: Update the BMCR
root@am335x-evm:~# ./ethtool -s eth0 speed 100 duplex full
[  102.693105] phy_ethtool_ksettings_set
[  102.697029] phy_ethtool_ksettings_set: speed 100 duplex 1
[  102.702462] phy_sanitize_settings
[  102.705892] phy_config_aneg
[  102.708702] genphy_config_aneg
[  102.711770] __genphy_config_aneg
[  102.715051] genphy_setup_forced
[  102.718209] genphy_setup_forced: Update the BMCR

I am hoping this answers your question.

Dan

