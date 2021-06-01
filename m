Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A5396B6F
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 04:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhFACiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 22:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbhFACiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 22:38:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCFDC061574;
        Mon, 31 May 2021 19:36:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so569641pjs.2;
        Mon, 31 May 2021 19:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2OVxSeKlGQa+hnVanHgZWFQDTlIpKAAIk1DeojjE1ho=;
        b=dElHa+6HUI5/H+/9avy+0ej2L5RGZrTitHtRG4EaU6Ud2x8dTfxFpbo+cO01bxbivC
         qTihiT4InWOND6FO0YHnXokVaAzCrotfRECPmF8qL0I4vKiy1Zpy6qmyTpgVm+28nL/e
         bfjhLYVPsHZqnaKGgI22DOatI2gRn7jc48oB6Vfu05A0DJvApOAnu6Gp3HdN9za/vJx5
         OY6BeKB7thR7io0jTcrqg/JZ+mhLcHUsYHJ7RsdCb7akl7hYIXhiuetr2kzctJiweygL
         j/EgVXcuXCwEvondMSW0ExmzIJtD8oFcvE1joJ4ui3ESALJsY3srgavhHD62U8RrQW9K
         evzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2OVxSeKlGQa+hnVanHgZWFQDTlIpKAAIk1DeojjE1ho=;
        b=o/HHLw57uh5xdkjILgdnxVfMc9ljZaGfRhPcK2P/DkwiATZJMrm6T5oQ68TTI4cuoq
         TeASiHLi9kH6OMhkY5wYCqUcJzihzrIHJVPshKVfmW1yEOs0su90t0qpVWgSYjHGOBFD
         cL6E5b+1jMn8hiXKhkJZQP7Yf4zrUEQNYzQ7jGKT7RuNodMY6FVQyyJiNbSuahnowob9
         VQTr9pUHuVUMfLVREzNXou86AeHjAtsFgjUX7vLJ7rXkeAQavzy+ZuE/XRoHYXYCtga5
         gRMLpjjKPWw+7c/gSCAe9red1MDtuqMosVfJ0NC3GiOolXqNEp1DmiIeO+G0OV+j7Ca9
         nShQ==
X-Gm-Message-State: AOAM532hbeNJhh8Ti2rK7aD+jX+XcgIqc5860XoDnrD9Vew+0TWmqzkQ
        gdfE344CCZa70DdlgH5mJ9k=
X-Google-Smtp-Source: ABdhPJxfB6K7sQgb9Aqx0gpaUDFjBV0bkLEyF4je/RGsU0zz5PFj+ojsVNTqan+VXdp8rM4GdUYJ1A==
X-Received: by 2002:a17:90a:bf03:: with SMTP id c3mr22001931pjs.196.1622514997720;
        Mon, 31 May 2021 19:36:37 -0700 (PDT)
Received: from [10.230.2.159] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id hk15sm546202pjb.53.2021.05.31.19.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 19:36:37 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Kernel Panic in skb_release_data using genet
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
References: <20210524130147.7xv6ih2e3apu2zvu@gilmour>
 <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
 <20210524151329.5ummh4dfui6syme3@gilmour>
 <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
 <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
 <20210528163219.x6yn44aimvdxlp6j@gilmour>
 <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
Message-ID: <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
Date:   Mon, 31 May 2021 19:36:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/2021 9:48 AM, Florian Fainelli wrote:
> On 5/28/21 9:32 AM, Maxime Ripard wrote:
>> hi Florian,
>>
>> On Fri, May 28, 2021 at 09:21:27AM -0700, Florian Fainelli wrote:
>>> On 5/24/21 8:37 AM, Florian Fainelli wrote:
>>>>
>>>>
>>>> On 5/24/2021 8:13 AM, Maxime Ripard wrote:
>>>>> Hi Florian,
>>>>>
>>>>> On Mon, May 24, 2021 at 07:49:25AM -0700, Florian Fainelli wrote:
>>>>>> Hi Maxime,
>>>>>>
>>>>>> On 5/24/2021 6:01 AM, Maxime Ripard wrote:
>>>>>>> Hi Doug, Florian,
>>>>>>>
>>>>>>> I've been running a RaspberryPi4 with a mainline kernel for a while,
>>>>>>> booting from NFS. Every once in a while (I'd say ~20-30% of all boots),
>>>>>>> I'm getting a kernel panic around the time init is started.
>>>>>>>
>>>>>>> I was debugging a kernel based on drm-misc-next-2021-05-17 today with
>>>>>>> KASAN enabled and got this, which looks related:
>>>>>>
>>>>>> Is there a known good version that could be used for bisection or you
>>>>>> just started to do this test and you have no reference point?
>>>>>
>>>>> I've had this issue for over a year and never (I think?) got a good
>>>>> version, so while it might be a regression, it's not a recent one.
>>>>
>>>> OK, this helps and does not really help.
>>>>
>>>>>
>>>>>> How stable in terms of clocking is the configuration that you are using?
>>>>>> I could try to fire up a similar test on a Pi4 at home, or use one of
>>>>>> our 72112 systems which is the closest we have to a Pi4 and see if that
>>>>>> happens there as well.
>>>>>
>>>>> I'm not really sure about the clocking. Is there any clock you want to
>>>>> look at in particular?
>>>>
>>>> ARM, DDR, AXI, anything that could cause some memory corruption to occur
>>>> essentially. GENET clocks are fairly fixed, you have a 250MHz clock and
>>>> a 125MHz clock feeding the data path.
>>>>
>>>>>
>>>>> My setup is fairly simple: the firmware and kernel are loaded over TFTP
>>>>> and the rootfs is mounted over NFS, and the crash always occur around
>>>>> init start, so I guess when it actually starts to transmit a decent
>>>>> amount of data?
>>>>
>>>> Do you reproduce this problem with KASAN disabled, do you eventually
>>>> have a crash pointing back to the same location?
>>>>
>>>> I have a suspicion that this is all Pi4 specific because we regularly
>>>> run the GENET driver through various kernel versions (4.9, 5.4 and 5.10
>>>> and mainline) and did not run into that.
>>>
>>> I have not had time to get a set-up to reproduce what you are seeing,
>>> could you share your .config meanwhile? Thanks
>>
>> Sorry, I didn't have the time to check how the clock were behaving.
>>
>> You'll find attached my config.txt file and .config
>>
>> I'm booting the board entirely from TFTP (which might introduce some
>> issues in the "handoff" from the bootloader to the kernel), you'll find
>> some guide there:
>>
>> https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/net_tutorial.md
> 
> That is also how I boot my Pi4 at home, and I suspect you are right, if
> the VPU does not shut down GENET's DMA, and leaves buffer addresses in
> the on-chip descriptors that point to an address space that is managed
> totally differently by Linux, then we can have a serious problem and
> create some memory corruption when the ring is being reclaimed. I will
> run a few experiments to test that theory and there may be a solution
> using the SW_INIT reset controller to have a big reset of the controller
> before handing it over to the Linux driver.

Adding a WARN_ON(reg & DMA_EN) in bcmgenet_dma_disable() has not shown
that the TX or RX DMA have been left running during the hand over from
the VPU to the kernel. I checked out drm-misc-next-2021-05-17 to reduce
as much as possible the differences between your set-up and my set-up
but so far have not been able to reproduce the crash in booting from NFS
repeatedly, I will try again.
-- 
Florian


