Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EB01EC5BD
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 01:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgFBXaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 19:30:23 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:46648 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgFBXaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 19:30:23 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 052NIAut035519;
        Tue, 2 Jun 2020 18:18:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591139890;
        bh=B/WbR0ieFR+upVOAWaKc+gb7oNaJlchuQLeU7X+5h8Y=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=JtxlATgtWTz/2V6BwAKkhWz0uSMCAHH7hu8j/dHaq5mLzrhR57DeBrcKmdJNLcN6A
         C/3ifPvg/Kit9blAb2WUUT9luHQ0ddZsKFXSSRWgT+v17PVqHDUv9JF5vif0f6+t/E
         ijB233L/yeGGRCJ+Y8/jTKoLLwNsIg5nH9M2opNQ=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 052NIA0t032906
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Jun 2020 18:18:10 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 2 Jun
 2020 18:18:10 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 2 Jun 2020 18:18:10 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 052NI9Kh009536;
        Tue, 2 Jun 2020 18:18:09 -0500
Subject: Re: [PATCH net-next v5 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Florian Fainelli <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <20200602164522.3276-1-dmurphy@ti.com>
 <20200602164522.3276-5-dmurphy@ti.com>
 <c3c68dcd-ccf1-25fd-fc4c-4c30608a1cc8@gmail.com>
 <61888788-041f-7b93-9d99-7dad4c148021@ti.com>
 <6981527b-f155-a46b-574a-2e6621589ca4@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <f92f70b2-6e42-5bdb-187d-ecd8533b06a6@ti.com>
Date:   Tue, 2 Jun 2020 18:18:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6981527b-f155-a46b-574a-2e6621589ca4@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 6/2/20 6:13 PM, Florian Fainelli wrote:
>
> On 6/2/2020 4:10 PM, Dan Murphy wrote:
>> Florian
>>
>> On 6/2/20 5:33 PM, Florian Fainelli wrote:
>>> On 6/2/2020 9:45 AM, Dan Murphy wrote:
>>>> Add RGMII internal delay configuration for Rx and Tx.
>>>>
>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>> ---
>>> [snip]
>>>
>>>> +
>>>>    enum {
>>>>        DP83869_PORT_MIRRORING_KEEP,
>>>>        DP83869_PORT_MIRRORING_EN,
>>>> @@ -108,6 +113,8 @@ enum {
>>>>    struct dp83869_private {
>>>>        int tx_fifo_depth;
>>>>        int rx_fifo_depth;
>>>> +    s32 rx_id_delay;
>>>> +    s32 tx_id_delay;
>>>>        int io_impedance;
>>>>        int port_mirroring;
>>>>        bool rxctrl_strap_quirk;
>>>> @@ -232,6 +239,22 @@ static int dp83869_of_init(struct phy_device
>>>> *phydev)
>>>>                     &dp83869->tx_fifo_depth))
>>>>            dp83869->tx_fifo_depth = DP83869_PHYCR_FIFO_DEPTH_4_B_NIB;
>>>>    +    ret = of_property_read_u32(of_node, "rx-internal-delay-ps",
>>>> +                   &dp83869->rx_id_delay);
>>>> +    if (ret) {
>>>> +        dp83869->rx_id_delay =
>>>> +                dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
>>>> +        ret = 0;
>>>> +    }
>>>> +
>>>> +    ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
>>>> +                   &dp83869->tx_id_delay);
>>>> +    if (ret) {
>>>> +        dp83869->tx_id_delay =
>>>> +                dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
>>>> +        ret = 0;
>>>> +    }
>>> It is still not clear to me why is not the parsing being done by the PHY
>>> library helper directly?
>> Why would we do that for these properties and not any other?
> Those properties have a standard name, which makes them suitable for
> parsing by the core PHY library.
>> Unless there is a new precedence being set here by having the PHY
>> framework do all the dt node parsing for common properties.
> You could parse the vendor properties through the driver, let the PHY
> library parse the standard properties, and resolve any ordering
> precedence within the driver. In general, I would favor standard
> properties over vendor properties.
>
> Does this help?

Ok so new precedence then.

Because there are common properties like tx-fifo-depth, rx-fifo-depth, 
enet-phy-lane-swap and max_speed that the PHY framework should parse as 
well.

Dan

