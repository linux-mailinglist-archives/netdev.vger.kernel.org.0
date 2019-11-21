Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F377105B1A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfKUUZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:25:45 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34832 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfKUUZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:25:45 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xALKPeDd092219;
        Thu, 21 Nov 2019 14:25:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574367940;
        bh=j6UDmmyjdDsVZH6BoXnkfo8wX14pJC2HOeaKzGhqW/A=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=irCrJxC9jxu2m+ml73K4tDxWp1qaUFAY2zJ1VxUAh70pWLfENFJ5AfuwucQDCt8MY
         Z9xXm0uy5m63lWQoNQf5L5aQkJrg8UAQamARYEQ5B/QDDeiVu0YvXye7k3H3H+5iUf
         17mE9wIs0+OUJMfNQW/vTir6vyhwvE3Un61YVadU=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xALKPeXj087655
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Nov 2019 14:25:40 -0600
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 21
 Nov 2019 14:25:39 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 21 Nov 2019 14:25:39 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xALKPcB5042197;
        Thu, 21 Nov 2019 14:25:38 -0600
Subject: Re: dp83867: Why does ti,fifo-depth set only TX, and why is it
 mandatory?
From:   Dan Murphy <dmurphy@ti.com>
To:     Adrian Bunk <bunk@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>
References: <20191114162431.GA21979@localhost>
 <190bd4d3-4bbd-3684-da31-2335b7c34c2a@ti.com>
 <20191114194715.GA29047@localhost>
 <d20a0c5a-507c-dd75-0951-e0733daf4a6e@ti.com>
Message-ID: <08b61f8c-bd7b-7ea7-2e47-50ddb540d67f@ti.com>
Date:   Thu, 21 Nov 2019 14:24:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d20a0c5a-507c-dd75-0951-e0733daf4a6e@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adrian

On 11/14/19 2:01 PM, Dan Murphy wrote:
> Adrian
>
> On 11/14/19 1:47 PM, Adrian Bunk wrote:
>> On Thu, Nov 14, 2019 at 11:53:36AM -0600, Dan Murphy wrote:
>>> Adrian
>> Hi Dan,
>>
>>> ...
>>>> 2. Why is it a mandatory property?
>>>> Perhaps I am missing something obvious, but why can't the driver 
>>>> either
>>>> leave the value untouched or set the maximum when nothing is 
>>>> configured?
>>> When the driver was originally written it was written only for RGMII
>>> interfaces as that is the MII that the data sheet references and 
>>> does not
>>> reference SGMII.  We did not have SGMII samples available at that time.
>>> According to the HW guys setting the FIFO depth is required for RGMII
>>> interfaces.
>> My reading of the datasheets is that it isn't needed at all for RGMII,
>> only for SGMII and gigabit GMII.
>>
>> Which makes it weird that it is only written in the RGMII case where it
>> is documented to be disabled.
>>
>> And there is a documented default value so writing shouldn't be 
>> mandatory
>> in any case.
>>
>> Perhaps I am looking at the wrong datasheets or there's a hardware 
>> errata?
>>
OK the HW team said that FIFO depth is no longer a mandatory field to be 
written for either RGMII or SGMII.

So my suggestion here is that we deprecate, but support in the driver, 
the ti-fifo-depth, and add the already documented

rx-fifo-depth and tx-fifo-depth as optional DT entries.

So I can change the driver and DT docs and test the RGMII device as 
above as long as we are in agreement

Dan

