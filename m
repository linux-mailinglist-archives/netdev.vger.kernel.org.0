Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C96B1ABDC9
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 12:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504815AbgDPKVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 06:21:07 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60451 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504719AbgDPKSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 06:18:38 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 492wD73L8Nz1qs0h;
        Thu, 16 Apr 2020 12:18:27 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 492wD33N72z1qql0;
        Thu, 16 Apr 2020 12:18:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id PdO30bTPsrjo; Thu, 16 Apr 2020 12:18:24 +0200 (CEST)
X-Auth-Info: 79TXxPoCzdaEAN6EY605hQWaeINUDqeOHYPeFLyprvM=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 16 Apr 2020 12:18:24 +0200 (CEST)
Subject: Re: [PATCH V4 00/19] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200415143909.wmtmud3vkkwzjv73@wunner.de>
 <ac0f7227-a4ae-b6cd-36ec-3bcb02b1adbe@denx.de>
 <20200415151236.ii5hib25eslbvmfk@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <e4cfbb61-1d54-b7ca-9ab7-653fbd59aeed@denx.de>
Date:   Thu, 16 Apr 2020 12:18:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200415151236.ii5hib25eslbvmfk@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/20 5:12 PM, Lukas Wunner wrote:
> On Wed, Apr 15, 2020 at 04:51:39PM +0200, Marek Vasut wrote:
>> On 4/15/20 4:39 PM, Lukas Wunner wrote:
>> I reinstated the indirect access, so things did change. Besides, there
>> performance for the parallel option is back where it was with the old
>> driver, which is important for me.
> 
> Okay, I see.
> 
> 
>>> We're using CONFIG_PREEMPT_RT_FULL=y.  I'm sorry for not mentioning this
>>> earlier, I didn't assume it would make such a big difference but
>>> apparently it does.
>>
>> Do you also have the RT patch applied ?
> 
> Yes, the branch I linked to also contains the RT patches.

OK, I see. I am only testing against latest linux-next with no extra
patches. Can you do that as well ?

Here is all you need:
https://git.kernel.org/pub/scm/linux/kernel/git/marex/linux-2.6.git/log/?h=ks8851-v5

>>> This is the branch I've tested today:
>>> https://github.com/l1k/linux/commits/revpi-4.19-marek-v4
>>
>> You seem to have quite a few more patches in that repository than just
>> this series, some of them even touching the RPi SPI driver and it's DMA
>> implementation.
> 
> Those are just the patches I mainlined, but backported to v4.19.
> This branch is based on the Raspberry Pi Foundation's downstream
> repository, they still ship v4.19.  Their repo has more performant
> drivers for USB, SD/MMC etc. which haven't been mainlined yet.
> But the SPI portion is the same as in mainline because I always
> submit to mainline and let the patches percolate down to their repo.

Above I linked current linux-next with KS8851 patches applied (plus
fixes for the next version of this series, including the RPi3 DT patch
and config I used to test the SPI version), so please use that.

>>>> I used two different drivers -- the iMX SPI and the STM32 SPI -- I would
>>>> say that if both show the same behavior, it's unlikely to be the driver.
>>>
>>> Hm, so why did it work with the RasPi but not with the others?
>>
>> I didn't have a chance to debug this yet.
> 
> I was just curious if those drivers don't work as well as the one
> for the RasPi. :-)  That would be funny because the RasPi is generally
> considered a toy in the embedded space and the platforms you've
> mentioned are taken more seriously I think.

My guess would be that the SPI in the RPi is just ignoring various
non-critical transmission errors to cater for all the "toy" hardware,
but that's just pure speculation.

[...]
