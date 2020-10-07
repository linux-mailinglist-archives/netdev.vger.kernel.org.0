Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD5D285BCD
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgJGJUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgJGJUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 05:20:46 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B783C061755;
        Wed,  7 Oct 2020 02:20:46 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C5pj84kjPz1sQDL;
        Wed,  7 Oct 2020 11:20:43 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C5pj74HJQz1qrgF;
        Wed,  7 Oct 2020 11:20:43 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id VYMMc1HgUkul; Wed,  7 Oct 2020 11:20:41 +0200 (CEST)
X-Auth-Info: W9/37Ni918RcIcyXzdA0+Qdvp/oiccIGBrSH+KMYhBM=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed,  7 Oct 2020 11:20:41 +0200 (CEST)
Subject: Re: PHY reset question
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>
References: <20201006080424.GA6988@pengutronix.de>
 <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
 <42d4c4b2-d3ea-9130-ef7f-3d1955116fdc@denx.de>
 <0687984c-5768-7c71-5796-8e16169f5192@gmail.com>
 <20201007081410.jk5fi6x5w3ab3726@pengutronix.de>
 <7edb2e01-bec5-05b0-aa47-caf6e214e5a0@denx.de>
 <20201007090636.t5rsus3tnkwuekjj@pengutronix.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <2b6a1616-beb8-fd12-9932-1e7d1ef04769@denx.de>
Date:   Wed, 7 Oct 2020 11:20:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201007090636.t5rsus3tnkwuekjj@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/20 11:06 AM, Marco Felsch wrote:
> On 20-10-07 10:23, Marek Vasut wrote:
>> On 10/7/20 10:14 AM, Marco Felsch wrote:
>>> Hi Marek,
>>
>> Hi,
>>
>> [...]
>>
>>> On 20-10-06 14:11, Florian Fainelli wrote:
>>>> On 10/6/2020 1:24 PM, Marek Vasut wrote:
>>>
>>> ...
>>>
>>>>> If this happens on MX6 with FEC, can you please try these two patches?
>>>>>
>>>>> https://patchwork.ozlabs.org/project/netdev/patch/20201006135253.97395-1-marex@denx.de/
>>>>>
>>>>> https://patchwork.ozlabs.org/project/netdev/patch/20201006202029.254212-1-marex@denx.de/
>>>>
>>>> Your patches are not scaling across multiple Ethernet MAC drivers
>>>> unfortunately, so I am not sure this should be even remotely considered a
>>>> viable solution.
>>>
>>> Recently I added clk support for the smcs driver [1] and dropped the
>>> PHY_RST_AFTER_CLK_EN flag for LAN8710/20 devices because I had the same
>>> issues. Hope this will help you too.
>>>
>>> [1] https://www.spinics.net/lists/netdev/msg682080.html
>>
>> I feel this might be starting to go a bit off-topic here,
> 
> You're right, just wanted to provide you a link :)

Can you CC me on the next version of those patches ? I seems the LAN8710
is causing grief to many.

>> but isn't the
>> last patch 5/5 breaking existing setups ?
> 
> IMHO the solution proposed using the PHY_RST_AFTER_CLK_EN was wrong so
> we needed to fix that. Yes we need to take care of DT backward
> compatibility but we still must be able to fix wrong behaviours within
> the driver. I could also argue that PHY_RST_AFTER_CLK_EN solution was
> breaking exisitng setups too.
> 
>> The LAN8710 surely does need
>> clock enabled before the reset line is toggled.
> 
> Yep and therefore you can specify it yet within the DT.

So the idea is that the PHY enables the clock for itself . And if the
MAC doesn't export these clock as clk to which you can refer to in DT,
then you still need the PHY_RST_AFTER_CLK_EN flag, so the MAC can deal
with enabling the clock ? Or is the idea to fix the MAC drivers too ?
