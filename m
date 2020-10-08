Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C600287A79
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgJHRA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:00:56 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:34518 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgJHRAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 13:00:55 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 098H0oeN031355;
        Thu, 8 Oct 2020 12:00:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602176450;
        bh=Fb5y0qYnS2/v0qcuhEtz+otsFlzC+73Oa2AqokeyOWs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Di3863Ag9nQCexzB7RA/eMhlvfurs36GS/1wTyikPdhbhgVxj15bE+xbR7KaXPPDP
         EU7jc36EtG6V/kfGmwKwxZM8uIOvMxT/OtH0l2ULioOtdY4vKD1eEfxvXBhuc+zgOM
         dP/kmt+VX+kQvfIU1e2/FhAye7KDtlaXVGg4wIZQ=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 098H0ox7062737
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 8 Oct 2020 12:00:50 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 8 Oct
 2020 12:00:50 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 8 Oct 2020 12:00:50 -0500
Received: from [10.250.67.147] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 098H0na1024161;
        Thu, 8 Oct 2020 12:00:49 -0500
Subject: Re: [PATCH net-next 2/2] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
To:     Heiner Kallweit <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201008162347.5290-1-dmurphy@ti.com>
 <20201008162347.5290-3-dmurphy@ti.com>
 <62bbff66-c2f0-df0c-82c2-7bd8b9d63220@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <2baf2f6a-bad1-d008-fa11-3389c6b38f5b@ti.com>
Date:   Thu, 8 Oct 2020 12:00:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <62bbff66-c2f0-df0c-82c2-7bd8b9d63220@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner

On 10/8/20 11:51 AM, Heiner Kallweit wrote:
> On 08.10.2020 18:23, Dan Murphy wrote:
>> The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
>> that supports 10M single pair cable.
>>
>> The device supports both 2.4-V p2p and 1-V p2p output voltage as defined
>> by IEEE 802.3cg 10Base-T1L specfications. These modes can be forced via
>> the device tree or the device is defaulted to auto negotiation to
>> determine the proper p2p voltage.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   drivers/net/phy/Kconfig     |   6 +

<snip>


>> +static struct phy_driver dp83td510_driver[] = {
>> +	{
>> +		PHY_ID_MATCH_MODEL(DP83TD510E_PHY_ID),
>> +		.name		= "TI DP83TD510E",
>> +		.probe          = dp83td510_probe,
>> +		.config_init	= dp83td510_config_init,
>> +		.soft_reset	= dp83td510_phy_reset,
>> +		.features	= PHY_BASIC_FEATURES,
> Per default phylib uses genphy_read_abilities() to auto-detect
> the features. Doesn't your PHY support the needed clause 22
> standard registers? Or are they incorrectly populated?
>
> Maybe better than setting PHY_BASIC_FEATURES and then removing
> unsuported features in dp83td510_config_init() would be to
> implement phy_driver callback get_features. Then you can set
> the supported fatures directly.
>
Thanks for the review.  I will have to look at this maybe the call back 
will be better.

I will probably post v2 after net-next opens for 5.10.

I wanted to get some reviews on this patch before net-next closes for 
the merge window.

Dan

