Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB74102ADF
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfKSRhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:37:01 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:50012 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfKSRhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:37:01 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJHatn8093112;
        Tue, 19 Nov 2019 11:36:55 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574185015;
        bh=BLr+0isCzO1Blg7PXSeJwgTgKxpKl4VHpA3jAmPlYk8=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=HH5vGbgGaj1Z3Q1qHigK5XGucX/BPcwv0l/VLrYl4DriQ0bVybEZkGGlQRrBoeD0m
         w1jusa5G5x4ue9aqUPFr8Y6AR22Je8Q8tl4ECImswR0FPQmHR44EDRGhblYwRl5bok
         jCqzgBI3NGEdCbRGQP+kF0XeQKIgSmEx+QsY0pH4=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJHat37006430;
        Tue, 19 Nov 2019 11:36:55 -0600
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 11:36:54 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 11:36:54 -0600
Received: from [10.250.33.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJHarAq096039;
        Tue, 19 Nov 2019 11:36:53 -0600
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
Message-ID: <0b1bbbea-d9e4-224c-d425-30d9485f8042@ti.com>
Date:   Tue, 19 Nov 2019 11:35:17 -0600
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
>>> When SGMII support was added in commit
>>> 507ddd5c0d47ad869f361c71d700ffe7f12d1dd6
>> That's adding 6-wire mode support, the version of the driver I use with
>> SGMII in 4.14 is much older and not far from the original submission.
>>
>> Is there anything that might be missing for SGMII you are aware of?
>>
> I forwarded this to our PHY support guy as I did not work on the SGMII 
> device they shipped.
>
> I only had a RGMII certified device.

I only got half the info but the FIFO depth is not required for RGMII.  
They are still trying to determine if it is for SGMII

Waiting on a response from someone OoO

Dan


>
> Dan
>
