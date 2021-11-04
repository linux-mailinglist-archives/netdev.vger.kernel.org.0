Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229854455BE
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 15:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhKDO6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 10:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhKDO6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 10:58:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1600EC061714;
        Thu,  4 Nov 2021 07:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=wrSeE0vHuSZ2IQmTnnM2PVhvw+BilCh/rk5TGFPdKSk=; b=Eh4M7NlL+I37REU8uB6I+KnMjR
        LvWyFTa5kAuwejLldEN9vErizVh/J+d+MtoKgIX8hLcUyQs0bQrtHqUvgvocQu2AyblYBrkKZOtCr
        nkswuz+/RRTheugcknSPh+zHbguRqyztns2mfT3FaPzTken1CeFsNS9hq8q8xTWOBxKHmarWfabJQ
        U33z7jzD7NxgDw50ZXhDPFB1+j6R0x4lQ+7xwFVmEpYiuPnlxVAzlJwAnN6P6jAaj4vqJ/6IKwUEG
        gW923fJRSkR8soOPh8sj0v5vVR19e6e/EgoEOZwD6Ge/9qW1No6V1Eog1k+A8Ta7SMBFmW9C4Jh/M
        pgEtde7w==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mie9J-00995Y-1C; Thu, 04 Nov 2021 14:55:29 +0000
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
 <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
 <YYLjaYCQHzqBzN1l@lunn.ch>
 <36d5bc6d40734ae0a9c1fb26d258f49f@sphcmbx02.sunplus.com.tw>
 <YYPZN9hPBJTBzVUl@lunn.ch>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3209bc4b-bde5-2e7e-4a91-429d2e83905e@infradead.org>
Date:   Thu, 4 Nov 2021 07:55:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYPZN9hPBJTBzVUl@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/21 5:59 AM, Andrew Lunn wrote:
> On Thu, Nov 04, 2021 at 05:31:57AM +0000, Wells Lu 呂芳騰 wrote:
>> Hi,
>>
>> Thanks a lot for review.
>>
>>>
>>>> config NET_VENDOR_SUNPLUS
>>>> 	bool "Sunplus devices"
>>>> 	default y
>>>> 	depends on ARCH_SUNPLUS
>>>
>>> Does it actually depend on ARCH_SUNPLUS? What do you make use of?
>>
>> ARCH_SUNPLUS will be defined for Sunplus family series SoC.
>> Ethernet devices of Sunplus are designed and used for Sunplus SoC.
>> So far, only two SoC of Sunplus have the network device.
>> I'd like to show up the selection only for Sunplus SoC.
> 
> So it does not actually depend on ARCH_SUNPLUS. There are a few cases
> where drivers have needed to call into arch specific code, which stops
> them building for any other arch.
> 
>>> Ideally, you want it to also build with COMPILE_TEST, so that the driver gets
>>> build by 0-day and all the other build bots.
>>
>> I am not sure if this is mandatory or not.
>> Should I add COMPILE_TEST as below?
>>
>> 	depends on ARCH_SUNPLUS | COMPILE_TEST
> 
> Yes.

Yes, but use "||" instead of one "|".

> 
>> Yes, the device is now only for Sunplus SP7021 SoC.
>> Devices in each SoC may have a bit difference because of adding new
>> function or improving something.
> 
> If it will compile with COMPILE_TEST on x86, mips, etc, you should
> allow it to compile with COMPILE_TEST. You get better compile testing
> that way.
> 
>       Andrew
> 


-- 
~Randy
