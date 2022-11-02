Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD452617317
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 00:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiKBX5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 19:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiKBX5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 19:57:40 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977402713
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 16:57:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso246656pjc.5
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 16:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LG62y1Arah1sOy8u1xHueGp0d7Iv6aDR2vlgLvxBAqo=;
        b=Ob2diW8glhLuzEMfSr72jLAcK3yyTmyaHOwJsENEegRc7jQSXLlrMn8+U0W0iM0CmG
         iLJg6JNXvu/4KEbV/AP+PK8MRi3QhbyVvMcIOxPxbyJ4a+VB3NsAYyKoNGNUyKKAFqPK
         gf645jP1BH9r+NyHrlN0yt9lEkNlJDcWpTy/dwmIfrPdSEsT9Boyn6hoYft1HW7MjUpW
         0N0Qe1Lz3Y7aSr9OfWxbjY5kVyM98pmEWfT3iNj2O4Aep3D7Prjs26jA0HQ0G92XZzBg
         66Qtv3V8QsgCQtjM9hHLaH0O5TfxA7Yqnj3nWWtY1/nxjA9yIp+vXOZ40ggbI2gi9+Ja
         76IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LG62y1Arah1sOy8u1xHueGp0d7Iv6aDR2vlgLvxBAqo=;
        b=EiLYfWtH1wlmSMhwF8KwOWqcHYduUVYKSOjTEoX+z78fSYWfAdD0DT0kRVyEv7J57R
         YdhLlt3HD+B5pIpnPSh9hgZ/TTBCrGREnYMZGAV70lTG8U1fRcqUg2HJX2RBcsGWe+Bp
         XZpaUibLi2BQakzeCb6VYvg0IBNzCL6nlgzzxMfgXPwxM4eldYj5Avku9Jehje5O3E32
         pYT0FqNdlAWqTEKissnpKCKnxWvXaekwd6IEhdPz7sZ2CbUoX9dh+4Uy/35napU4ljQx
         Q+EuDUBVTBX6PWcRa3iXqtNtv3a4aSya7eKBs9rKWKdmcmKGrqiXhQnihF+fVSByeMxk
         /K4A==
X-Gm-Message-State: ACrzQf04X72WxMsbnisBy/AhDuoq5cMlrHS0JT67H3Ecjv7GZ6dOiVI0
        V/y9+hUl2mDQDTZJHVKcmjrD+w==
X-Google-Smtp-Source: AMsMyM7athH5okEZaA6xJ8ZVTT16f+JLZAGxpvNmGRYu7XbkSIeZ2P1rasAg4JltUxIXN6E8NlCO5Q==
X-Received: by 2002:a17:90a:ce81:b0:212:f61d:35c6 with SMTP id g1-20020a17090ace8100b00212f61d35c6mr27703359pju.243.1667433457972;
        Wed, 02 Nov 2022 16:57:37 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f11-20020a170902684b00b00186bc66d2cbsm8813376pln.73.2022.11.02.16.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 16:57:37 -0700 (PDT)
Message-ID: <46cb04ca-467c-2e33-f221-3e2a2eaabbda@kernel.dk>
Date:   Wed, 2 Nov 2022 17:57:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20221030220203.31210-1-axboe@kernel.dk>
 <CA+FuTSfj5jn8Wui+az2BrcpDFYF5m5ehwLiswwHMPJ2MK+S_Jw@mail.gmail.com>
 <02e5bf45-f877-719b-6bf8-c4ac577187a8@kernel.dk>
 <CA+FuTSd-HvtPVwRto0EGExm-Pz7dGpxAt+1sTb51P_QBd-N9KQ@mail.gmail.com>
 <88353f13-d1d8-ef69-bcdc-eb2aa17c7731@kernel.dk>
 <CA+FuTSdEKsN_47RtW6pOWEnrKkewuDBdsv_qAhR1EyXUr3obrg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+FuTSdEKsN_47RtW6pOWEnrKkewuDBdsv_qAhR1EyXUr3obrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/22 5:51 PM, Willem de Bruijn wrote:
> On Wed, Nov 2, 2022 at 7:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 11/2/22 5:09 PM, Willem de Bruijn wrote:
>>> On Wed, Nov 2, 2022 at 1:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 11/2/22 11:46 AM, Willem de Bruijn wrote:
>>>>> On Sun, Oct 30, 2022 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> tldr - we saw a 6-7% CPU reduction with this patch. See patch 6 for
>>>>>> full numbers.
>>>>>>
>>>>>> This adds support for EPOLL_CTL_MIN_WAIT, which allows setting a minimum
>>>>>> time that epoll_wait() should wait for events on a given epoll context.
>>>>>> Some justification and numbers are in patch 6, patches 1-5 are really
>>>>>> just prep patches or cleanups.
>>>>>>
>>>>>> Sending this out to get some input on the API, basically. This is
>>>>>> obviously a per-context type of operation in this patchset, which isn't
>>>>>> necessarily ideal for any use case. Questions to be debated:
>>>>>>
>>>>>> 1) Would we want this to be available through epoll_wait() directly?
>>>>>>    That would allow this to be done on a per-epoll_wait() basis, rather
>>>>>>    than be tied to the specific context.
>>>>>>
>>>>>> 2) If the answer to #1 is yes, would we still want EPOLL_CTL_MIN_WAIT?
>>>>>>
>>>>>> I think there are pros and cons to both, and perhaps the answer to both is
>>>>>> "yes". There are some benefits to doing this at epoll setup time, for
>>>>>> example - it nicely isolates it to that part rather than needing to be
>>>>>> done dynamically everytime epoll_wait() is called. This also helps the
>>>>>> application code, as it can turn off any busy'ness tracking based on if
>>>>>> the setup accepted EPOLL_CTL_MIN_WAIT or not.
>>>>>>
>>>>>> Anyway, tossing this out there as it yielded quite good results in some
>>>>>> initial testing, we're running more of it. Sending out a v3 now since
>>>>>> someone reported that nonblock issue which is annoying. Hoping to get some
>>>>>> more discussion this time around, or at least some...
>>>>>
>>>>> My main question is whether the cycle gains justify the code
>>>>> complexity and runtime cost in all other epoll paths.
>>>>>
>>>>> Syscall overhead is quite dependent on architecture and things like KPTI.
>>>>
>>>> Definitely interested in experiences from other folks, but what other
>>>> runtime costs do you see compared to the baseline?
>>>
>>> Nothing specific. Possible cost from added branches and moving local
>>> variables into structs with possibly cold cachelines.
>>>
>>>>> Indeed, I was also wondering whether an extra timeout arg to
>>>>> epoll_wait would give the same feature with less side effects. Then no
>>>>> need for that new ctrl API.
>>>>
>>>> That was my main question in this posting - what's the best api? The
>>>> current one, epoll_wait() addition, or both? The nice thing about the
>>>> current one is that it's easy to integrate into existing use cases, as
>>>> the decision to do batching on the userspace side or by utilizing this
>>>> feature can be kept in the setup path. If you do epoll_wait() and get
>>>> -1/EINVAL or false success on older kernels, then that's either a loss
>>>> because of thinking it worked, or a fast path need to check for this
>>>> specifically every time you call epoll_wait() rather than just at
>>>> init/setup time.
>>>>
>>>> But this is very much the question I already posed and wanted to
>>>> discuss...
>>>
>>> I see the value in being able to detect whether the feature is present.
>>>
>>> But a pure epoll_wait implementation seems a lot simpler to me, and
>>> more elegant: timeout is an argument to epoll_wait already.
>>>
>>> A new epoll_wait variant would have to be a new system call, so it
>>> would be easy to infer support for the feature.
>>
>> Right, but it'd still mean that you'd need to check this in the fast
>> path in the app vs being able to do it at init time.
> 
> A process could call the new syscall with timeout 0 at init time to
> learn whether the feature is supported.

That is pretty clunky, though... It'd work, but not a very elegant API.

>> Might there be
>> merit to doing both? From the conversion that we tried, the CTL variant
>> definitely made things easier to port. The new syscall would make enable
>> per-call delays however. There might be some merit to that, though I do
>> think that max_events + min_time is how you'd control batching anything
>> and that's suitably set in the context itself for most use cases.
> 
> I'm surprised a CTL variant is easier to port. An epoll_pwait3 with an
> extra argument only needs to pass that argument to do_epoll_wait.

It's literally adding two lines of code, that's it. A new syscall is way
worse both in terms of the userspace and kernel side for archs, and for
changing call sites in the app.

> FWIW, when adding nsec resolution I initially opted for an init-based
> approach, passing a new flag to epoll_create1. Feedback then was that
> it was odd to have one syscall affect the behavior of another. The
> final version just added a new epoll_pwait2 with timespec.

I'm fine with just doing a pure syscall variant too, it was my original
plan. Only changed it to allow for easier experimentation and adoption,
and based on the fact that most use cases would likely use a fixed value
per context anyway.

I think it'd be a shame to drop the ctl, unless there's strong arguments
against it. I'm quite happy to add a syscall variant too, that's not a
big deal and would be a minor addition. Patch 6 should probably cut out
the ctl addition and leave that for a patch 7, and then a patch 8 for
adding a syscall.

-- 
Jens Axboe
