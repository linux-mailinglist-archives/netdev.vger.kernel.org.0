Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827E43F7D53
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 22:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbhHYUqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 16:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239932AbhHYUqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 16:46:46 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC85C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 13:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=W8HubMk2k127/cjthS0iFTTQjAWrh+oTRlU1IO0/1XI=; b=3VXIkonCXPgh5swcF2mdZo8MWW
        2G859Tg/fqcNDyW4useUmOD7rj3LKc+UAKqm+egmS9JWlzwyjDt/GH4J4UqDAcmkR41EcPbg/2WFO
        7yP2GnC6SPLK2IPVB0sbcOsT5bhKmH+YTRXJjIgMaI0oWJjoA1NmPGXDJmj+EsIB2C0Qz8idc+m6y
        pXKARBGf5vTpwHFNkYqavo16W3Xuqb9OfAYOwB8Wm6o305p0ANnTJPuwB9zJq9+Y3Z/vvJHn34mRr
        bqBhvWlwkoIEMKXmu79UjSGJzgI0ioi4X0zjbSP85EH4Nd77tN/uSVq4G05WuUBlu42dc/YiQIUu9
        7/EYMigA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIzmY-008Sjt-5W; Wed, 25 Aug 2021 20:45:58 +0000
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
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <35952ae9-07a5-11aa-76ae-d698bcaa9804@infradead.org>
Date:   Wed, 25 Aug 2021 13:45:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210825204042.5v7ad3ntor6s3pq3@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 1:40 PM, Jonathan Lemon wrote:
> On Wed, Aug 25, 2021 at 10:29:51AM -0700, Randy Dunlap wrote:
>> On 8/25/21 10:08 AM, Jonathan Lemon wrote:
>>> On Wed, Aug 25, 2021 at 12:55:25PM +0200, Arnd Bergmann wrote:
>>>> On Tue, Aug 24, 2021 at 11:48 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>>>>
>>>>> On 8/20/21 8:31 AM, Richard Cochran wrote:
>>>>>> On Fri, Aug 20, 2021 at 12:45:42PM +0200, Arnd Bergmann wrote:
>>>>>>
>>>>>>> I would also suggest removing all the 'imply' statements, they
>>>>>>> usually don't do what the original author intended anyway.
>>>>>>> If there is a compile-time dependency with those drivers,
>>>>>>> it should be 'depends on', otherwise they can normally be
>>>>>>> left out.
>>>>>>
>>>>>> +1
>>>>>
>>>>> Hi,
>>>>>
>>>>> Removing the "imply" statements is simple enough and the driver
>>>>> still builds cleanly without them, so Yes, they aren't needed here.
>>>>>
>>>>> Removing the SPI dependency is also clean.
>>>>>
>>>>> The driver does use I2C, MTD, and SERIAL_8250 interfaces, so they
>>>>> can't be removed without some other driver changes, like using
>>>>> #ifdef/#endif (or #if IS_ENABLED()) blocks and some function stubs.
>>>>
>>>> If the SERIAL_8250 dependency is actually required, then using
>>>> 'depends on' for this is probably better than an IS_ENABLED() check.
>>>> The 'select' is definitely misplaced here, that doesn't even work when
>>>> the dependencies fo 8250 itself are not met, and it does force-enable
>>>> the entire TTY subsystem.
>>>
>>> So, something like the following (untested) patch?
>>> I admit to not fully understanding all the nuances around Kconfig.
>>
>> Hi,
>>
>> You can also remove the "select NET_DEVLINK". The driver builds fine
>> without it. And please drop the "default n" while at it.
> 
> I had to add this one because devlink is a dependency and the kbuild
> robot generated a config without it.

What kind of dependency is devlink?
The driver builds without NET_DEVLINK.


> The 'imply' statements were added because while the driver builds
> without them, the resources don't show up unless the platform
> modules are also present.  This was really confusing users, since
> they selected the OCP driver and then were not able to use the
> flash since the XILINX modules had not been selected.
> 
> Is there a better way of specifying these type of dependencies?

Documentation/  and/or one can add comments/docs in the Kconfig help
section.


-- 
~Randy

