Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A401C9491
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgEGPNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:13:46 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:41494 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbgEGPNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 11:13:45 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 047FDSCZ022341;
        Thu, 7 May 2020 10:13:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588864408;
        bh=JigUTKaOo4sgONci8PXgDOfebCbTpuRTJNtVrPnbctU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=RbmK7xm9yOZFVs+ttHo5bXF539JZ8ER2CBiXRvPOCTCURR1GNhIh/lbhEkL7m9wef
         BzFo3c3eFGjl1ix7NT5Kg7kQKiuBzvxcYAn8rjtfCVUrHw3FnbpavEVF/GKMCIuV8t
         ijvIaqvsnjP+AvtayKi0vyn9DK6hVLGdkhjlOgHE=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 047FDSZm044323;
        Thu, 7 May 2020 10:13:28 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 7 May
 2020 10:13:27 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 7 May 2020 10:13:27 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 047FDPHZ107963;
        Thu, 7 May 2020 10:13:26 -0500
Subject: Re: [PATCH next] ARM: dts: am437x: fix networking on boards with
 ksz9031 phy
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20200506190835.31342-1-grygorii.strashko@ti.com>
 <20200507044056.4smicagmxve5yshn@pengutronix.de>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <7c36e45f-5617-22dd-d1cf-7a2558aac459@ti.com>
Date:   Thu, 7 May 2020 18:13:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507044056.4smicagmxve5yshn@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/05/2020 07:40, Oleksij Rempel wrote:
> Hi Grygorii,
> 
> thank you for you patches!
> 
> On Wed, May 06, 2020 at 10:08:35PM +0300, Grygorii Strashko wrote:
>> Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
>> KSZ9031 PHY") the networking is broken on boards:
>>   am437x-gp-evm
>>   am437x-sk-evm
>>   am437x-idk-evm
>>
>> All above boards have phy-mode = "rgmii" and this is worked before, because
>> KSZ9031 PHY started with default RGMII internal delays configuration (TX
>> off, RX on 1.2 ns) and MAC provided TX delay. After above commit, the
>> KSZ9031 PHY starts handling phy mode properly and disables RX delay, as
>> result networking is become broken.
>>
>> Fix it by switching to phy-mode = "rgmii-rxid" to reflect previous
>> behavior.
>>
>> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Philippe Schenker <philippe.schenker@toradex.com>
>> Fixes: commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   arch/arm/boot/dts/am437x-gp-evm.dts  | 2 +-
>>   arch/arm/boot/dts/am437x-idk-evm.dts | 2 +-
>>   arch/arm/boot/dts/am437x-sk-evm.dts  | 4 ++--
>>   3 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
>> index 811c8cae315b..d692e3b2812a 100644
>> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
>> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
>> @@ -943,7 +943,7 @@
>>   
>>   &cpsw_emac0 {
>>   	phy-handle = <&ethphy0>;
>> -	phy-mode = "rgmii";
>> +	phy-mode = "rgmii-rxid";
>>   };
>>   
>>   &elm {
>> diff --git a/arch/arm/boot/dts/am437x-idk-evm.dts b/arch/arm/boot/dts/am437x-idk-evm.dts
>> index 9f66f96d09c9..a7495fb364bf 100644
>> --- a/arch/arm/boot/dts/am437x-idk-evm.dts
>> +++ b/arch/arm/boot/dts/am437x-idk-evm.dts
>> @@ -504,7 +504,7 @@
>>   
>>   &cpsw_emac0 {
>>   	phy-handle = <&ethphy0>;
>> -	phy-mode = "rgmii";
>> +	phy-mode = "rgmii-id";
>>   };
> 
> Do you have here really rgmii-id?
> 

Right, thanks you.

-- 
Best regards,
grygorii
