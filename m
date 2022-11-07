Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7A761F5D6
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 15:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiKGO0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 09:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbiKGOZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 09:25:47 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1B525EBD
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 06:20:06 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k7so11185955pll.6
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 06:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bDPd4h+RRaCGyF8qOvIYpOjJfOMMpF96RM907rLtuvI=;
        b=OVoR0s1UIaeoueQhoevz1/HANrcaGT/9cy9WcQUF25mkVNXbL2qb01pi80w5bg97DQ
         x2vcl3aKklhsf8iyLWYfkUIQ9KEJbnFGxWRFTkQohPRak1EN/glOzZKijjfgTUvLua/1
         FMVnd8Obtx+NnjH3Yr8up+tSIW4cG9u5pkF0oTciHzutgquYbIn4uRWnfqJMdjdBFHgz
         sba/3u0Zaxwldje4aUtloTsuTv2KvdhRpUHBJoX0POn/agSVr3LnrRMJYe9k1QtttDg2
         XLkA1M98NVCUIOHUTvy20du4nslnhKmxbHJ4Wh3liKDj5+JdXYt47f3S2vV2e6UnlUXu
         6QCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bDPd4h+RRaCGyF8qOvIYpOjJfOMMpF96RM907rLtuvI=;
        b=POxapoUIXNWCpyl1TOD3Hz/H53PgufyNEaliec66ZZ3nEXTmtCJT4WNx4eGTFD4Wku
         /a/W1nL4upQUAelsuizL3ejpE14wPGrm4dd/oafHsa5hqKou6aNAr3rGY6yClgE3W1ai
         k18+TkS81wDV/4/GOmpxPsEMLmD7me159KnpYZ6Gi96o7yeImYdfogu3AqeN6BEwQc0/
         vAqOHZjWOmGbqMKAjIcFKkO+eedRszd+MSD+RxEFE9wjVtocDciiOB81rdaFz3k119fu
         iwElcdgGWZuchNlY3stvFXC6BQP1G15MeVfkTqjv/5d42AAP0XTUY7YBSsIHT/OWAW91
         xIRA==
X-Gm-Message-State: ACrzQf0+UoyA5kmkccogmRA054YjB8mKjyBcLvizYSPcFNElAwRgEHjN
        pooKMq2J9auaPPlsfPfK8caCDQ==
X-Google-Smtp-Source: AMsMyM5sHEcEBNIdTmZAo8JYkMDFQ2UsPoYytocfmB4Ne3kQ6FxoGNEN6HNgsm6rm6UEWHa+Xj2vmg==
X-Received: by 2002:a17:903:258b:b0:186:8bb2:de32 with SMTP id jb11-20020a170903258b00b001868bb2de32mr52040037plb.63.1667830792428;
        Mon, 07 Nov 2022 06:19:52 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902a3c800b00186ad73e2d5sm5030353plb.208.2022.11.07.06.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 06:19:51 -0800 (PST)
Message-ID: <3c15b1fa-ec79-1f12-35dc-bbbe660bb94f@kernel.dk>
Date:   Mon, 7 Nov 2022 07:19:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20221030220203.31210-1-axboe@kernel.dk>
 <CA+FuTSfj5jn8Wui+az2BrcpDFYF5m5ehwLiswwHMPJ2MK+S_Jw@mail.gmail.com>
 <02e5bf45-f877-719b-6bf8-c4ac577187a8@kernel.dk>
 <CA+FuTSd-HvtPVwRto0EGExm-Pz7dGpxAt+1sTb51P_QBd-N9KQ@mail.gmail.com>
 <88353f13-d1d8-ef69-bcdc-eb2aa17c7731@kernel.dk>
 <CA+FuTSdEKsN_47RtW6pOWEnrKkewuDBdsv_qAhR1EyXUr3obrg@mail.gmail.com>
 <46cb04ca-467c-2e33-f221-3e2a2eaabbda@kernel.dk>
 <fe28e9fa-b57b-8da6-383c-588f6e84f04f@kernel.dk>
 <CA+FuTSfEqmx_rHPLaSp+o+tYzqCvF6oSjSOse0KoFvXj9xK9Cw@mail.gmail.com>
 <e3c55fda-043e-9cc7-3248-63574b374c13@kernel.dk>
 <CA+FuTSf9RVua+qUdOAQBGuwOrNysu3min5fDtWyKb3aRgth4vQ@mail.gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+FuTSf9RVua+qUdOAQBGuwOrNysu3min5fDtWyKb3aRgth4vQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/22 6:25 AM, Willem de Bruijn wrote:
> On Sat, Nov 5, 2022 at 2:46 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 11/5/22 12:05 PM, Willem de Bruijn wrote:
>>> On Sat, Nov 5, 2022 at 1:39 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>>>> FWIW, when adding nsec resolution I initially opted for an init-based
>>>>>> approach, passing a new flag to epoll_create1. Feedback then was that
>>>>>> it was odd to have one syscall affect the behavior of another. The
>>>>>> final version just added a new epoll_pwait2 with timespec.
>>>>>
>>>>> I'm fine with just doing a pure syscall variant too, it was my original
>>>>> plan. Only changed it to allow for easier experimentation and adoption,
>>>>> and based on the fact that most use cases would likely use a fixed value
>>>>> per context anyway.
>>>>>
>>>>> I think it'd be a shame to drop the ctl, unless there's strong arguments
>>>>> against it. I'm quite happy to add a syscall variant too, that's not a
>>>>> big deal and would be a minor addition. Patch 6 should probably cut out
>>>>> the ctl addition and leave that for a patch 7, and then a patch 8 for
>>>>> adding a syscall.
>>>> I split the ctl patch out from the core change, and then took a look at
>>>> doing a syscall variant too. But there are a few complications there...
>>>> It would seem to make the most sense to build this on top of the newest
>>>> epoll wait syscall, epoll_pwait2(). But we're already at the max number
>>>> of arguments there...
>>>>
>>>> Arguably pwait2 should've been converted to use some kind of versioned
>>>> struct instead. I'm going to take a stab at pwait3 with that kind of
>>>> interface.
>>>
>>> Don't convert to a syscall approach based solely on my feedback. It
>>> would be good to hear from others.
>>
>> It's not just based on your feedback, if you read the original cover
>> letter, then that is the question that is posed in terms of API - ctl to
>> modify it, new syscall, or both? So figured I should at least try and
>> see what the syscall would look like.
>>
>>> At a high level, I'm somewhat uncomfortable merging two syscalls for
>>> behavior that already works, just to save half the syscall overhead.
>>> There is no shortage of calls that may make some sense for a workload
>>> to merge. Is the quoted 6-7% cpu cycle reduction due to saving one
>>> SYSENTER/SYSEXIT (as the high resolution timer wake-up will be the
>>> same), or am I missing something more fundamental?
>>
>> No, it's not really related to saving a single syscall, and you'd
>> potentially save more than just one as well. If we look at the two
>> extremes of applications, one will be low load and you're handling
>> probably just 1 event per loop. Not really interesting. At the other
>> end, you're fully loaded, and by the time you check for events, you have
>> 'maxevents' (or close to) available. That obviously reduces system
>> calls, but more importantly, it also allows the application to get some
>> batching effects from processing these events.
>>
>> In the medium range, there's enough processing to react pretty quickly
>> to events coming in, and you then end up doing just 1 event (or close to
>> that). To overcome that, we have some applications that detect this
>> medium range and do an artificial sleep before calling epoll_wait().
>> That was a nice effiency win for them. But we can do this a lot more
>> efficiently in the kernel. That was the idea behind this, and the
>> initial results from TAO (which does that sleep hack) proved it to be
>> more than worthwhile. Syscall reduction is one thing, improved batching
>> another, and just as importanly is sleep+wakeup reductions.
> 
> Thanks for the context.
> 
> So this is akin to interrupt moderation in network interfaces. Would
> it make sense to wait for timeout or nr of events, whichever comes
> first, similar to rx_usecs/rx_frames. Instead of an unconditional
> sleep at the start.

There's no unconditional sleep at the start with my patches, not sure
where you are getting that from. You already have 'nr of events', that's
the maxevents being passed in. If nr_available >= maxevents, then no
sleep will take place. We did debate doing a minevents kind of thing as
well, but the time based metric is more usable.

-- 
Jens Axboe
