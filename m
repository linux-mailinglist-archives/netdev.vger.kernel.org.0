Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D296F4FED17
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiDMCk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiDMCk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:40:56 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12773101C9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:38:37 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q3so760322plg.3
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fLgDjeHVYbXkfhaYx0Do2mV56Jvy8fglOjLawJ1rbTc=;
        b=P3MfXovjlQ2qgEWYmVCqkuXandknnLCXm8IY+usb3p1H22UXtH93guyKo53g49KDwl
         8Tkz8jTU1yS3F7V2BrjAzcJUL9yhbhyi+MOT784mO1WaqjAxKIGtYb5Ilg7tZGwcz3ZR
         1DjxqFKnJEx7hKjtmHsYTD4x6nOJGaJAgh857eD5oIiFge1p2afx7WgE3YLnfKvlQUis
         mjo4JMHaFzPPRGZv+d8FDuIEAOTbm85fIB3PxTvJToLdVq/G0oZCBNK7Ro12LJTigsO/
         IBOp1JhYMYDmNFQoMb8z9ZSXXiwTLRNsJe2B3pT4qxwJiLOPJ196X8H384gVUkE1m/3K
         Mniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fLgDjeHVYbXkfhaYx0Do2mV56Jvy8fglOjLawJ1rbTc=;
        b=Ipw4EBS7gDrqP3k2okpjuTX/GckEvAR8DIaoAdIzR1srqrGJGL5kUUIq8j+Hac7rgF
         VEN3eV/hoir7Y04HAdk1suPu1oxUpsK1kGi9jhvmxfg/2IJqknRrs3BQzJPDeUmCtE0t
         Vh4l7QvAEcNYHCPy2MagaoavxClMIYM8KmjLVOz2c3/lpzl3PqZD6ZhxbkEEaG+RZQU3
         GLYyItcv95BpHuaONCpVmTGvHIgKTulWXa9AGBFksXy4PAd3ojHhYTUhI3h1J+Z13JbW
         GUXnOcw/MTCug0KXnaeoLDx/jcBSA5xUk19WY/3sGi5Q1mwpbeJ81qai63OwR5lxh8HW
         1JQg==
X-Gm-Message-State: AOAM532MYkW666sufktzs82fBL1muo21cOBS2yOCQWt79DAPvQ5+ErxN
        P/B5BScNrFCZUXLUXo8IcXNnSQ==
X-Google-Smtp-Source: ABdhPJzKACTDxfOvoHXgoDtih2bWYIVirNbxvz45rdqdf2S0W8tv4ibDtfL1Vm8j4Af/khsZpObLQw==
X-Received: by 2002:a17:90b:1d04:b0:1c7:1174:56ae with SMTP id on4-20020a17090b1d0400b001c7117456aemr8144046pjb.153.1649817516516;
        Tue, 12 Apr 2022 19:38:36 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090a6c9000b001cc3a8b4fd6sm907727pjj.7.2022.04.12.19.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 19:38:35 -0700 (PDT)
Message-ID: <8a762692-3e0a-f7e8-ff80-38c0da73647e@kernel.dk>
Date:   Tue, 12 Apr 2022 20:38:34 -0600
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
 <22271a21-2999-2f2f-9270-c7233aa79c6d@kernel.dk>
 <CANn89iKXTbDJ594KN5K8u4eowpTWKdxXJ4hBQOqkuiZGcS7x0A@mail.gmail.com>
 <d39a2713-9172-3dd6-4a37-dad178a5bb57@kernel.dk>
 <CANn89iKVtHLNUMRPP276-w31usKwWnFhQp04W1CbD-TqOnRAiw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANn89iKVtHLNUMRPP276-w31usKwWnFhQp04W1CbD-TqOnRAiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/22 8:32 PM, Eric Dumazet wrote:
> On Tue, Apr 12, 2022 at 7:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/12/22 8:19 PM, Eric Dumazet wrote:
>>> On Tue, Apr 12, 2022 at 7:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 4/12/22 8:05 PM, Eric Dumazet wrote:
>>>>> On Tue, Apr 12, 2022 at 7:01 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 4/12/22 7:54 PM, Eric Dumazet wrote:
>>>>>>> On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>
>>>>>>>> On 4/12/22 6:40 PM, Eric Dumazet wrote:
>>>>>>>>>
>>>>>>>>> On 4/12/22 13:26, Jens Axboe wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> If we accept a connection directly, eg without installing a file
>>>>>>>>>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
>>>>>>>>>> we have a socket for recv/send that we can fully serialize access to.
>>>>>>>>>>
>>>>>>>>>> With that in mind, we can feasibly skip locking on the socket for TCP
>>>>>>>>>> in that case. Some of the testing I've done has shown as much as 15%
>>>>>>>>>> of overhead in the lock_sock/release_sock part, with this change then
>>>>>>>>>> we see none.
>>>>>>>>>>
>>>>>>>>>> Comments welcome!
>>>>>>>>>>
>>>>>>>>> How BH handlers (including TCP timers) and io_uring are going to run
>>>>>>>>> safely ? Even if a tcp socket had one user, (private fd opened by a
>>>>>>>>> non multi-threaded program), we would still to use the spinlock.
>>>>>>>>
>>>>>>>> But we don't even hold the spinlock over lock_sock() and release_sock(),
>>>>>>>> just the mutex. And we do check for running eg the backlog on release,
>>>>>>>> which I believe is done safely and similarly in other places too.
>>>>>>>
>>>>>>> So lets say TCP stack receives a packet in BH handler... it proceeds
>>>>>>> using many tcp sock fields.
>>>>>>>
>>>>>>> Then io_uring wants to read/write stuff from another cpu, while BH
>>>>>>> handler(s) is(are) not done yet,
>>>>>>> and will happily read/change many of the same fields
>>>>>>
>>>>>> But how is that currently protected?
>>>>>
>>>>> It is protected by current code.
>>>>>
>>>>> What you wrote would break TCP stack quite badly.
>>>>
>>>> No offense, but your explanations are severely lacking. By "current
>>>> code"? So what you're saying is that it's protected by how the code
>>>> currently works? From how that it currently is? Yeah, that surely
>>>> explains it.
>>>>
>>>>> I suggest you setup/run a syzbot server/farm, then you will have a
>>>>> hundred reports quite easily.
>>>>
>>>> Nowhere am I claiming this is currently perfect, and it should have had
>>>> an RFC on it. Was hoping for some constructive criticism on how to move
>>>> this forward, as high frequency TCP currently _sucks_ in the stack.
>>>> Instead I get useless replies, not very encouraging.
>>>>
>>>> I've run this quite extensively on just basic send/receive over sockets,
>>>> so it's not like it hasn't been run at all. And it's been fine so far,
>>>> no ill effects observed. If we need to tighten down the locking, perhaps
>>>> a valid use would be to simply skip the mutex and retain the bh lock for
>>>> setting owner. As far as I can tell, should still be safe to skip on
>>>> release, except if we need to process the backlog. And it'd serialize
>>>> the owner setting with the BH, which seems to be your main objection in.
>>>> Mostly guessing here, based on the in-depth replies.
>>>>
>>>> But it'd be nice if we could have a more constructive dialogue about
>>>> this, rather than the weird dismisiveness.
>>>>
>>>>
>>>
>>> Sure. It would be nice that I have not received such a patch series
>>> the day I am sick.
>>
>> I'm sorry that you are sick - but if you are not in a state to reply,
>> then please just don't. It sets a bad example. It was sent to the list,
>> not to you personally.
> 
> I tried to be as constructive as possible, and Jakub pinged me about

Are you serious?! I don't think I've ever received less constructive
feedback in 20+ years of working on the kernel.

> this series,
> so I really thought Jakub was okay with it.
> 
> So I am a bit concerned.

I did show it to Jakub a week or so ago, probably that was why. But why
the concern?! It's just a patchseries proposed for discussion. Something
that happens every day.

>> Don't check email then, putting the blame on ME for posting a patchset
>> while you are sick is uncalled for and rude. If I had a crystal ball, I
>> would not be spending my time working on the kernel. You know what
>> would've been a better idea? Replying that you are sick and that you are
>> sorry for being an ass on the mailing list.
> 
> Wow.

Putting the blame on me for your emails, since I posted a patchset while
you're sick, is just rude.

-- 
Jens Axboe

