Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE12293AD1
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 14:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394190AbgJTMC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:02:28 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:38034 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393918AbgJTMAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 08:00:22 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09KC0GUR003227;
        Tue, 20 Oct 2020 07:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1603195216;
        bh=WkBuNAsxFhLn/ukEf+V0rbkpMqs338cpGgVIPXm4TZw=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=KYv5Miw/6LO1Jt+KdvwAME2yESbB8NvCzjE4+gxHKseA1mGn28JxdztrRBLd8eMCT
         GI2DxbxlFumLYqMOMY0QoXtaVctCXiwihS/HuHV1yNZtsR1ZTgkAmlg1tjwptmnbGY
         nNaJehZs/icjs84z8libUPSSpNxh0AG5QdDTKkZg=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09KC0GXH036661
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 07:00:16 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 20
 Oct 2020 07:00:16 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 20 Oct 2020 07:00:16 -0500
Received: from [10.250.70.26] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09KC0Fue053012;
        Tue, 20 Oct 2020 07:00:15 -0500
Subject: Re: [PATCH net-next 2/2] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
From:   Dan Murphy <dmurphy@ti.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201008162347.5290-1-dmurphy@ti.com>
 <20201008162347.5290-3-dmurphy@ti.com> <20201016220240.GM139700@lunn.ch>
 <31cbfec4-3f1c-d760-3035-2ff9ec43e4b7@ti.com>
 <20201019215506.GY139700@lunn.ch>
 <4add1229-ad74-48e9-064d-e12d62ecc574@ti.com>
Message-ID: <0e7c70ad-91f0-b3b7-bf28-c258f1a0a0e0@ti.com>
Date:   Tue, 20 Oct 2020 07:00:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4add1229-ad74-48e9-064d-e12d62ecc574@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 10/19/20 5:04 PM, Dan Murphy wrote:
> Andrew
>
> On 10/19/20 4:55 PM, Andrew Lunn wrote:
>> On Mon, Oct 19, 2020 at 04:33:18PM -0500, Dan Murphy wrote:
>>> Andrew
>>>
>>> On 10/16/20 5:02 PM, Andrew Lunn wrote:
>>>> On Thu, Oct 08, 2020 at 11:23:47AM -0500, Dan Murphy wrote:
>>>>> The DP83TD510E is an ultra-low power Ethernet physical layer 
>>>>> transceiver
>>>>> that supports 10M single pair cable.
>>>> Hi Dan
>>>>
>>>> I think you are going to have to add
>>>> ETHTOOL_LINK_MODE_10baseT1_Full_BIT? We already have 100T1 and 1000T1,
>>>> but not 10T1 :-(
>>> The data sheet says 10baseT1L.  Which is not there either and seems 
>>> to be
>>> the latest 802.3cg spec and has a greater max distance and used for 
>>> IoT and
>>> Automotive.
>> Hi Dan
>>
>> Do you know anything about interropibility? Can a T1 and a T1L talk to
>> each other, if suitably close? I'm wondering if this device should say
>> it is both T1 and T1L? Or just T1L?
>
> I personally don't know about interoperability my tests were T1L to 
> T1L but I forwarded these questions to my HW PHY team.
>
HW team says no to interoperability.  So we can just add T1L and 
advertise that type.

The DP83TD510L capability is limited to 10Base-T1L only.

Dan

