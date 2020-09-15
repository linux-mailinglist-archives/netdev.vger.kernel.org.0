Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8765026B4B3
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgIOXaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:30:15 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57460 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbgIOX3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:29:32 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08FNTNTg075733;
        Tue, 15 Sep 2020 18:29:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600212563;
        bh=f31VW0gtdRpGEDp6axuwxXoDMfdhCxcxnCweY4Nqnpc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=oV1FNHWbs4X5N/wyU7TnZjYg49dt0/riQh95fTuZhOAp1hd8Ae7p/IxTyvYd+Tv6h
         8T3xekBvlYs0p2bpczQ0OWe7B0W6iNw8j4wRxdLE5kNGLmLbLpCDeIXNOyQ2zOa0kx
         mo1A92x6AuYuu72S2GDusHF5gnDudV0iJbURHKMQ=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08FNTNrt030035;
        Tue, 15 Sep 2020 18:29:23 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 15
 Sep 2020 18:29:22 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 15 Sep 2020 18:29:22 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08FNTMif048879;
        Tue, 15 Sep 2020 18:29:22 -0500
Subject: Re: [PATCH net-next 1/3] ethtool: Add 100base-FX link mode entries
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200915181708.25842-1-dmurphy@ti.com>
 <20200915181708.25842-2-dmurphy@ti.com> <20200915202113.GE3526428@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <f2a38c01-8726-a7fe-f645-2c83fe30b932@ti.com>
Date:   Tue, 15 Sep 2020 18:29:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200915202113.GE3526428@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 9/15/20 3:21 PM, Andrew Lunn wrote:
> On Tue, Sep 15, 2020 at 01:17:06PM -0500, Dan Murphy wrote:
>> Add entries for the 100base-FX full and half duplex supported modes.
>>
>> $ ethtool eth0
>>          Supported ports: [ TP    MII     FIBRE ]
>>          Supported link modes:   10baseT/Half 10baseT/Full
>>                                  100baseT/Half 100baseT/Full
>>                                  100baseFX/Half 100baseFX/Full
>>          Supported pause frame use: Symmetric Receive-only
>>          Supports auto-negotiation: No
>>          Supported FEC modes: Not reported
>>          Advertised link modes:  10baseT/Half 10baseT/Full
>>                                  100baseT/Half 100baseT/Full
>>                                  100baseFX/Half 100baseFX/Full
> I thought this PHY could not switch between TP and Fibre. It has a
> strap which decides? So i would expect the supported modes to be
> either BaseT or BaseFX. Not both. Same for Advertised?
>
>         Andrew

I found that the phy-device was setting all these bits in phy_init in 
features_init.

My first pass was to clear all these bits as well because the PHY was 
still advertising these modes.

But you are right this PHY cannot switch without strapping.

I can clear these bits.

Dan

