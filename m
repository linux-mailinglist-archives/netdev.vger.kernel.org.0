Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0364A2A4CA5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgKCRYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:04 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:46512 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgKCRYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:03 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A3HNwPW072377;
        Tue, 3 Nov 2020 11:23:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604424238;
        bh=9kuksq4yFMyIjn0oeqUqnIj/lw1ExH8Ewm915oA7JAI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=TtMneYH2VgghEwI9nWETot7BPBuBdB3i7CNjLMQ0OwX3Rn+gs3YrgYmy4pk+JSJS4
         JD7SSFz1DXufR2BjXT8b8HZRu8Kmpz/8TlYZ8O/KrkuN6YXV2K1bymWi72KDDvLdb+
         rTqdgtDIsL0TCSaPEfiCkvLm+uI+/Gu8nePsrVeE=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A3HNw1M058948
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Nov 2020 11:23:58 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 3 Nov
 2020 11:23:57 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 3 Nov 2020 11:23:57 -0600
Received: from [10.250.36.55] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A3HNvJs041617;
        Tue, 3 Nov 2020 11:23:57 -0600
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com>
 <20201030160330.622c55a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5b32a56b-f054-5790-c5cf-bf1e86403bad@ti.com>
 <20201103172153.GO1042051@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <d51ef446-1528-5d3f-8548-831598a005a7@ti.com>
Date:   Tue, 3 Nov 2020 11:23:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201103172153.GO1042051@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 11/3/20 11:21 AM, Andrew Lunn wrote:
> On Tue, Nov 03, 2020 at 11:09:44AM -0600, Dan Murphy wrote:
>> Hello
>>
>> On 10/30/20 6:03 PM, Jakub Kicinski wrote:
>>> On Fri, 30 Oct 2020 12:29:50 -0500 Dan Murphy wrote:
>>>> The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
>>>> that supports 10M single pair cable.
>>>>
>>>> The device supports both 2.4-V p2p and 1-V p2p output voltage as defined
>>>> by IEEE 802.3cg 10Base-T1L specfications. These modes can be forced via
>>>> the device tree or the device is defaulted to auto negotiation to
>>>> determine the proper p2p voltage.
>>>>
>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>> drivers/net/phy/dp83td510.c:70:11: warning: symbol 'dp83td510_feature_array' was not declared. Should it be static?
>> I did not see this warning. Did you use W=1?
> I _think_ that one is W=1. All the PHY drivers are W=1 clean, and i
> want to keep it that way. And i hope to make it the default in a lot
> of the network code soon.
OK I built with the W=1 before submission I did not see this but I will 
try some other things.
>>> Also this:
>>>
>>> WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
>>> #429: FILE: drivers/net/phy/dp83td510.c:371:
>>> +		return -ENOTSUPP;
>>>
>>> WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
>>> #524: FILE: drivers/net/phy/dp83td510.c:466:
>>> +		return -ENOTSUPP;
>> Same with these warnings how where they reproduced?
Same as above
>>> ERROR: space required before the open parenthesis '('
>>> #580: FILE: drivers/net/phy/dp83td510.c:522:
>>> +		if(phydev->autoneg) {
>>>
>>> ERROR: space required before the open parenthesis '('
>>> #588: FILE: drivers/net/phy/dp83td510.c:530:
>>> +		if(phydev->autoneg) {
>>>
> These look like checkpatch.
These I missed
>>> And please try to wrap the code on 80 chars on the non trivial lines:
>> What is the LoC limit for networking just for my clarification and I will
>> align with that.
> 80. I would not be too surprised to see checkpatch getting a patch to
> set it to 80 for networking code.

OK I will align the lines to 80 then.

Dan


>      Andrew
