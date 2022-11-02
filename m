Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D31C6172F1
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 00:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiKBXlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 19:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiKBXle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 19:41:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF0C165B2
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 16:37:16 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso210335pjc.5
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 16:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nNSwBSvvM/7zs+qbKrPNr1qxxwgXoG/o5gSkXOHnFZI=;
        b=ZwURBjzGFDZBQ1yMuHMzIfRMn8SqPP+sNA46B3HtmUVsIY/kVrFpsJLxS+BIgNCNP6
         4NoOl856z24W91iextUBFkkIiizh7ta5R2wzoYHtamCDxcO96TzEqWimM/Ss0nECWK3c
         PifDGes6RDyOPdziy3XD53csozI7NAmeiLK8FWZ4SVNow8E98tAAdUqSPLf1a0TJWTfh
         84TtNfv4rpthKkk7iyAVFkmiS6krj9x9vaAWh8macx8FVyfUjSDpGgJIUf/VqCxqUWIk
         gyJV6+irFkomUkA4IThYawhOQmAhPncDUm1fOu5gHTH88WTB9MXeHSXxMFCFs8MEIjNx
         xMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nNSwBSvvM/7zs+qbKrPNr1qxxwgXoG/o5gSkXOHnFZI=;
        b=jIGle7ljqk/6CaT4ZiXwennYCyZhusvQRj3siC9KxJku18/fWhz+yaWwX8bjBdi3z7
         ZuJ+qQVAtVUeq71KR76taoa1YPT64IeESVi32O9vQ3NZJf1WFN+FinvNkVlgGs6M9w24
         MBAI1zUeIXGtz3MQbko4xYCNG08/Iec69sYwAQaBkZ1+lh6u76E+58Y1VeweQ87lTOMc
         3MdjCuWOgv1IWTNBSz/Jb9h/R93buCJfmhH4jJ2dmZQDAMz5Re0UwsIIfukEVQSMYXKS
         7butOEAxWQmF/xIwJMEioTd7rWUP633XsdKHeH8+lP0K3cxutfCfVatmd2dl3ha8eKOx
         O3MQ==
X-Gm-Message-State: ACrzQf1L52TQ2DDrJhcI7mXR5N6m52gnzOw8AuXfctO5l9s2T8VnBA49
        kBJkM0G2vXEDSfknSw9eadjneNE8W8/bj0J7
X-Google-Smtp-Source: AMsMyM4mm575vnzh9fO9Mhs2WOglqFrd+vGFFMTdxw2e4F7jQdNwKlu3juZAcQdBMVW/NuWhMpIDFw==
X-Received: by 2002:a17:902:e1d3:b0:186:d8d7:1d1e with SMTP id t19-20020a170902e1d300b00186d8d71d1emr2137783pla.30.1667432235770;
        Wed, 02 Nov 2022 16:37:15 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902ea1000b001837b19ebb8sm8934155plg.244.2022.11.02.16.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 16:37:15 -0700 (PDT)
Message-ID: <88353f13-d1d8-ef69-bcdc-eb2aa17c7731@kernel.dk>
Date:   Wed, 2 Nov 2022 17:37:13 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+FuTSd-HvtPVwRto0EGExm-Pz7dGpxAt+1sTb51P_QBd-N9KQ@mail.gmail.com>
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

On 11/2/22 5:09 PM, Willem de Bruijn wrote:
> On Wed, Nov 2, 2022 at 1:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 11/2/22 11:46 AM, Willem de Bruijn wrote:
>>> On Sun, Oct 30, 2022 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> Hi,
>>>>
>>>> tldr - we saw a 6-7% CPU reduction with this patch. See patch 6 for
>>>> full numbers.
>>>>
>>>> This adds support for EPOLL_CTL_MIN_WAIT, which allows setting a minimum
>>>> time that epoll_wait() should wait for events on a given epoll context.
>>>> Some justification and numbers are in patch 6, patches 1-5 are really
>>>> just prep patches or cleanups.
>>>>
>>>> Sending this out to get some input on the API, basically. This is
>>>> obviously a per-context type of operation in this patchset, which isn't
>>>> necessarily ideal for any use case. Questions to be debated:
>>>>
>>>> 1) Would we want this to be available through epoll_wait() directly?
>>>>    That would allow this to be done on a per-epoll_wait() basis, rather
>>>>    than be tied to the specific context.
>>>>
>>>> 2) If the answer to #1 is yes, would we still want EPOLL_CTL_MIN_WAIT?
>>>>
>>>> I think there are pros and cons to both, and perhaps the answer to both is
>>>> "yes". There are some benefits to doing this at epoll setup time, for
>>>> example - it nicely isolates it to that part rather than needing to be
>>>> done dynamically everytime epoll_wait() is called. This also helps the
>>>> application code, as it can turn off any busy'ness tracking based on if
>>>> the setup accepted EPOLL_CTL_MIN_WAIT or not.
>>>>
>>>> Anyway, tossing this out there as it yielded quite good results in some
>>>> initial testing, we're running more of it. Sending out a v3 now since
>>>> someone reported that nonblock issue which is annoying. Hoping to get some
>>>> more discussion this time around, or at least some...
>>>
>>> My main question is whether the cycle gains justify the code
>>> complexity and runtime cost in all other epoll paths.
>>>
>>> Syscall overhead is quite dependent on architecture and things like KPTI.
>>
>> Definitely interested in experiences from other folks, but what other
>> runtime costs do you see compared to the baseline?
> 
> Nothing specific. Possible cost from added branches and moving local
> variables into structs with possibly cold cachelines.
> 
>>> Indeed, I was also wondering whether an extra timeout arg to
>>> epoll_wait would give the same feature with less side effects. Then no
>>> need for that new ctrl API.
>>
>> That was my main question in this posting - what's the best api? The
>> current one, epoll_wait() addition, or both? The nice thing about the
>> current one is that it's easy to integrate into existing use cases, as
>> the decision to do batching on the userspace side or by utilizing this
>> feature can be kept in the setup path. If you do epoll_wait() and get
>> -1/EINVAL or false success on older kernels, then that's either a loss
>> because of thinking it worked, or a fast path need to check for this
>> specifically every time you call epoll_wait() rather than just at
>> init/setup time.
>>
>> But this is very much the question I already posed and wanted to
>> discuss...
> 
> I see the value in being able to detect whether the feature is present.
> 
> But a pure epoll_wait implementation seems a lot simpler to me, and
> more elegant: timeout is an argument to epoll_wait already.
> 
> A new epoll_wait variant would have to be a new system call, so it
> would be easy to infer support for the feature.

Right, but it'd still mean that you'd need to check this in the fast
path in the app vs being able to do it at init time. Might there be
merit to doing both? From the conversion that we tried, the CTL variant
definitely made things easier to port. The new syscall would make enable
per-call delays however. There might be some merit to that, though I do
think that max_events + min_time is how you'd control batching anything
and that's suitably set in the context itself for most use cases.

-- 
Jens Axboe
