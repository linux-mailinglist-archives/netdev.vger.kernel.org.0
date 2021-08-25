Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73B33F7EF8
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 01:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhHYXXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 19:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhHYXXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 19:23:00 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89163C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 16:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=gO1iuUW0NZ2sDeRc/80HBwfRUrBeSxrAq39/9Y6nDsg=; b=p+yevKw3OMTiA1Ea4h/LxipB7K
        Oh/j8v4aXG3AjRAINsE3IClZOA8WQ73J5rO+bjHRxy/JVlNS/f/8ajwOiCsDVAUM0tP9NCEiLwqhR
        IXlM69DdWV/ngopGKzP3fIIcwjLblegTs5hZrX1Bqyblz64cZmNKT5SHl5nbHOFtMU6RPPcXu7R6b
        UrKkvFiGU24afyHOX9ZqmtI7V+fRlxT3rKGBgkj09SMX7Kpi3D9sRDpf67u+oCWJKoR2gP96RSGO/
        CTTOlxxytL9uerZQg5ZJxC42+4PA69831+nFns4eYUqlHNdU82o3VyNSxbKNp58eMzHyTCwD8vGWs
        RO7D6iIQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJ2Dk-008hKL-If; Wed, 25 Aug 2021 23:22:12 +0000
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>
References: <20210813203026.27687-1-rdunlap@infradead.org>
 <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
 <20210820153100.GA9604@hoboy.vegasvil.org>
 <80be0a74-9b0d-7386-323c-c261ca378eef@infradead.org>
 <CAK8P3a11wvEhoEutCNBs5NqiZ2VUA1r-oE1CKBBaYbu_abr4Aw@mail.gmail.com>
 <20210825170813.7muvouqsijy3ysrr@bsd-mbp.dhcp.thefacebook.com>
 <8f0848a6-354d-ff58-7d41-8610dc095773@infradead.org>
 <20210825204042.5v7ad3ntor6s3pq3@bsd-mbp.dhcp.thefacebook.com>
 <35952ae9-07a5-11aa-76ae-d698bcaa9804@infradead.org>
 <20210825211415.mbr2bikxmqts7ie4@bsd-mbp.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4c87845c-c39b-3d1d-74bc-915f7e86d82e@infradead.org>
Date:   Wed, 25 Aug 2021 16:22:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210825211415.mbr2bikxmqts7ie4@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 2:14 PM, Jonathan Lemon wrote:
> On Wed, Aug 25, 2021 at 01:45:57PM -0700, Randy Dunlap wrote:
>> On 8/25/21 1:40 PM, Jonathan Lemon wrote:
>>> On Wed, Aug 25, 2021 at 10:29:51AM -0700, Randy Dunlap wrote:
>>>> On 8/25/21 10:08 AM, Jonathan Lemon wrote:
>>>>> On Wed, Aug 25, 2021 at 12:55:25PM +0200, Arnd Bergmann wrote:
>>>>>> On Tue, Aug 24, 2021 at 11:48 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>>>>>>
>>>>>>> On 8/20/21 8:31 AM, Richard Cochran wrote:
>>>>>>>> On Fri, Aug 20, 2021 at 12:45:42PM +0200, Arnd Bergmann wrote:
>>>>>>>>
>>>>>>>>> I would also suggest removing all the 'imply' statements, they
>>>>>>>>> usually don't do what the original author intended anyway.
>>>>>>>>> If there is a compile-time dependency with those drivers,
>>>>>>>>> it should be 'depends on', otherwise they can normally be
>>>>>>>>> left out.
>>>>>>>>
>>>>>>>> +1
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> Removing the "imply" statements is simple enough and the driver
>>>>>>> still builds cleanly without them, so Yes, they aren't needed here.
>>>>>>>
>>>>>>> Removing the SPI dependency is also clean.
>>>>>>>
>>>>>>> The driver does use I2C, MTD, and SERIAL_8250 interfaces, so they
>>>>>>> can't be removed without some other driver changes, like using
>>>>>>> #ifdef/#endif (or #if IS_ENABLED()) blocks and some function stubs.
>>>>>>
>>>>>> If the SERIAL_8250 dependency is actually required, then using
>>>>>> 'depends on' for this is probably better than an IS_ENABLED() check.
>>>>>> The 'select' is definitely misplaced here, that doesn't even work when
>>>>>> the dependencies fo 8250 itself are not met, and it does force-enable
>>>>>> the entire TTY subsystem.
>>>>>
>>>>> So, something like the following (untested) patch?
>>>>> I admit to not fully understanding all the nuances around Kconfig.
>>>>
>>>> Hi,
>>>>
>>>> You can also remove the "select NET_DEVLINK". The driver builds fine
>>>> without it. And please drop the "default n" while at it.
>>>
>>> I had to add this one because devlink is a dependency and the kbuild
>>> robot generated a config without it.
>>
>> What kind of dependency is devlink?
>> The driver builds without NET_DEVLINK.
> 
> It really doesn't.  Odds are one of the network drivers is also
> selecting this as well, so it is hidden.
> 

OK, my mistake. Thanks.

-- 
~Randy

