Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D3F184A39
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 16:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCMPHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 11:07:51 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:47072 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCMPHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 11:07:51 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02DF7ldL049377;
        Fri, 13 Mar 2020 10:07:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584112067;
        bh=GR5w5xndlHpg2huTUFHevQHKlS7Ne1sG2FUatp7XZyQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=wJdKg3v4wb+JOCRzK8s5/j1HTSru9hIMKmfhMG65a+xpBlt8BANuVqqaonLDyq2Nt
         kO/4mFoMCGIXj+w9ey4/BS3Y6bldnlS2iQ4pqPw/MFoazX+N9PB9Nuyn9dwL2aZr7d
         2GhTpHatjcK2t97Vhm7QQXkhqMrJn9y08ErRRlHU=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02DF7lfS072311
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Mar 2020 10:07:47 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 13
 Mar 2020 10:07:46 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 13 Mar 2020 10:07:46 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02DF7iJj129846;
        Fri, 13 Mar 2020 10:07:45 -0500
Subject: Re: [for-next PATCH v2 1/5] phy: ti: gmii-sel: simplify config
 dependencies between net drivers and gmii phy
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Sekhar Nori <nsekhar@ti.com>, Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200303160029.345-1-grygorii.strashko@ti.com>
 <20200303160029.345-2-grygorii.strashko@ti.com>
 <a6dc55bb-090f-d1de-90c7-247197d3748e@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <34c01cc2-55ed-8160-45eb-b75ca768bfb0@ti.com>
Date:   Fri, 13 Mar 2020 17:07:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a6dc55bb-090f-d1de-90c7-247197d3748e@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On 05/03/2020 13:06, Kishon Vijay Abraham I wrote:
> Hi Dave,
> 
> On 03/03/20 9:30 pm, Grygorii Strashko wrote:
>> The phy-gmii-sel can be only auto selected in Kconfig and now the pretty
>> complex Kconfig dependencies are defined for phy-gmii-sel driver, which
>> also need to be updated every time phy-gmii-sel is re-used for any new
>> networking driver.
>>
>> Simplify Kconfig definition for phy-gmii-sel PHY driver - drop all
>> dependencies and from networking drivers and rely on using 'imply
>> PHY_TI_GMII_SEL' in Kconfig definitions for networking drivers instead.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/net/ethernet/ti/Kconfig | 1 +
> 
> I can pick this in my tree. Can you give your Acked-by since there is a
> small change in drivers/net?

Sorry for disturbing you, but what's the final decision here?



> 
> Thanks
> Kishon
>>   drivers/phy/ti/Kconfig          | 3 ---
>>   2 files changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
>> index bf98e0fa7d8b..8a6ca16eee3b 100644
>> --- a/drivers/net/ethernet/ti/Kconfig
>> +++ b/drivers/net/ethernet/ti/Kconfig
>> @@ -53,6 +53,7 @@ config TI_CPSW
>>   	select MFD_SYSCON
>>   	select PAGE_POOL
>>   	select REGMAP
>> +	imply PHY_TI_GMII_SEL
>>   	---help---
>>   	  This driver supports TI's CPSW Ethernet Switch.
>>   
>> diff --git a/drivers/phy/ti/Kconfig b/drivers/phy/ti/Kconfig
>> index 6dbe9d0b9ff3..15a3bcf32308 100644
>> --- a/drivers/phy/ti/Kconfig
>> +++ b/drivers/phy/ti/Kconfig
>> @@ -106,11 +106,8 @@ config TWL4030_USB
>>   
>>   config PHY_TI_GMII_SEL
>>   	tristate
>> -	default y if TI_CPSW=y || TI_CPSW_SWITCHDEV=y
>> -	depends on TI_CPSW || TI_CPSW_SWITCHDEV || COMPILE_TEST
>>   	select GENERIC_PHY
>>   	select REGMAP
>> -	default m
>>   	help
>>   	  This driver supports configuring of the TI CPSW Port mode depending on
>>   	  the Ethernet PHY connected to the CPSW Port.
>>

-- 
Best regards,
grygorii
