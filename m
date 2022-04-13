Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4120B4FECC4
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiDMCPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiDMCPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:15:11 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D6D21E1D
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:12:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o5so586236pjr.0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IYA55uiVGhqxcEOjiccMB/s0yKHhQ0Xnh8lFs5j8JqI=;
        b=1JO4dDnI5T0UIQXSuUDyqpXGfYGTP3MYZm5FsA/etCyWcl/FvUZlTh7Djvldt2B4zw
         XjKCIiHjsxJpW3Ujci+1HBXzb4+Z4vaiO5udaHvOkJZtHh2uEWj/jF6Me7h8fgUrk6eI
         jH1Bzqcx9uPNyefg4WyV5pELy3lqQMC4Pl7ZF/6LgJTdjOX+2VK6MavoVqhSaUB8W+4o
         YnO9QuDSMdjN1iLylWHc1RSmRVKAB8cpJNP46bQNOQv3oFUNLak+uIwXqNxxJegO+2KR
         z9GXcH2l5CWmOCswIon7Hrez5U2fKiLzW8O66M6SV8ekp2mr+mthlyjvv7dFcH8RN4YL
         G/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IYA55uiVGhqxcEOjiccMB/s0yKHhQ0Xnh8lFs5j8JqI=;
        b=OMinoNb8nV13+D8c4EuA1aYr5k1xkKRPpz8T97YzxIhHOpK09tXtK9l88OFwZK47n1
         UYafutuS/xajj0/3gRf+nx+FkWTJN+cIbrUbmDFvLH8hgkqGm1rTFXm3sFig2xBmeMaL
         9iY3QAYpdM3NOqRvpUnB+Fj4jYnP6FK5DFB5p/sXaKa6PmU6loUmNWoCO0tNVjk8gDOW
         j9rpR8hgGQiPJEF2Ab3pVgtzoJ5kSdVz9tt7cLI5vKU3xQPNZ5T0h4IkrryiNICw5ZK3
         2/X97V9FQDggHRVdTgQadU6Z2G1L4d3FgqV+Z0qzWfUAHfGTaw4OPMJXdjLzbSAdHHmo
         8vlQ==
X-Gm-Message-State: AOAM5332jmTwu9Mkshm5pdXzrzSvaxmqHj++Ty+tqne9cAm7eSiFa4Tc
        yxQPNi/NPnV6IYGHd2YtobTheg==
X-Google-Smtp-Source: ABdhPJypwtnEAQWTobp6q2e3b9vIq/omiPP3BX/zbzI0dwUDZYfcz4liSjby3XpuAD8D5+eySvtn2g==
X-Received: by 2002:a17:90b:4b42:b0:1cb:a399:a59e with SMTP id mi2-20020a17090b4b4200b001cba399a59emr8148145pjb.23.1649815967068;
        Tue, 12 Apr 2022 19:12:47 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id lk16-20020a17090b33d000b001c9e804f2c6sm858611pjb.56.2022.04.12.19.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 19:12:46 -0700 (PDT)
Message-ID: <22271a21-2999-2f2f-9270-c7233aa79c6d@kernel.dk>
Date:   Tue, 12 Apr 2022 20:12:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, io-uring@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
References: <20220412202613.234896-1-axboe@kernel.dk>
 <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
 <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk>
 <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
 <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk>
 <CANn89i+1UJHYwDocWuaxzHoiPrJwi0WR0mELMidYBXYuPcLumg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANn89i+1UJHYwDocWuaxzHoiPrJwi0WR0mELMidYBXYuPcLumg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/22 8:05 PM, Eric Dumazet wrote:
> On Tue, Apr 12, 2022 at 7:01 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/12/22 7:54 PM, Eric Dumazet wrote:
>>> On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 4/12/22 6:40 PM, Eric Dumazet wrote:
>>>>>
>>>>> On 4/12/22 13:26, Jens Axboe wrote:
>>>>>> Hi,
>>>>>>
>>>>>> If we accept a connection directly, eg without installing a file
>>>>>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
>>>>>> we have a socket for recv/send that we can fully serialize access to.
>>>>>>
>>>>>> With that in mind, we can feasibly skip locking on the socket for TCP
>>>>>> in that case. Some of the testing I've done has shown as much as 15%
>>>>>> of overhead in the lock_sock/release_sock part, with this change then
>>>>>> we see none.
>>>>>>
>>>>>> Comments welcome!
>>>>>>
>>>>> How BH handlers (including TCP timers) and io_uring are going to run
>>>>> safely ? Even if a tcp socket had one user, (private fd opened by a
>>>>> non multi-threaded program), we would still to use the spinlock.
>>>>
>>>> But we don't even hold the spinlock over lock_sock() and release_sock(),
>>>> just the mutex. And we do check for running eg the backlog on release,
>>>> which I believe is done safely and similarly in other places too.
>>>
>>> So lets say TCP stack receives a packet in BH handler... it proceeds
>>> using many tcp sock fields.
>>>
>>> Then io_uring wants to read/write stuff from another cpu, while BH
>>> handler(s) is(are) not done yet,
>>> and will happily read/change many of the same fields
>>
>> But how is that currently protected?
> 
> It is protected by current code.
> 
> What you wrote would break TCP stack quite badly.

No offense, but your explanations are severely lacking. By "current
code"? So what you're saying is that it's protected by how the code
currently works? From how that it currently is? Yeah, that surely
explains it.

> I suggest you setup/run a syzbot server/farm, then you will have a
> hundred reports quite easily.

Nowhere am I claiming this is currently perfect, and it should have had
an RFC on it. Was hoping for some constructive criticism on how to move
this forward, as high frequency TCP currently _sucks_ in the stack.
Instead I get useless replies, not very encouraging.

I've run this quite extensively on just basic send/receive over sockets,
so it's not like it hasn't been run at all. And it's been fine so far,
no ill effects observed. If we need to tighten down the locking, perhaps
a valid use would be to simply skip the mutex and retain the bh lock for
setting owner. As far as I can tell, should still be safe to skip on
release, except if we need to process the backlog. And it'd serialize
the owner setting with the BH, which seems to be your main objection in.
Mostly guessing here, based on the in-depth replies.

But it'd be nice if we could have a more constructive dialogue about
this, rather than the weird dismisiveness.

-- 
Jens Axboe

