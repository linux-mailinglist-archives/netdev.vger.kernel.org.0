Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080F561DD58
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 19:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiKESqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 14:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiKESqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 14:46:07 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8764917433
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 11:46:05 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so9678902pjh.1
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 11:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nc07ysxTqjdeYroqU/Py+Cc5pz6/5akm+LWPTzs22lM=;
        b=Uu5cP5eghF4pgUgY/XizX9fx/s8T59rC0f/zOeW0k0OWcqIInRi41taMDHi8l5OC8c
         tVHS/ZaJi2VtVtv/3VQQHGpWDxL91raJQMK5urk99DmHCwiPQrSi9MTKCk7r/WXDlAhQ
         a4+eiJexHw8GGhmgcczIGF1r0AfECMdOOGb4VL0006ah4RFoc6xejb+TUprB4PIJPqzG
         rHFr3/jxjsySsWqxfotuPHnFTE5c0rHjZeCkJRDCbnbq9+Ga/s3z0k67LizUL/wokqYy
         7hEfAm7mDFvRMolOqw//fSrGOA+VK2dePTnHHFlQ2IrgWaMjCejLG8x04pVoCap7RlJu
         3LvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nc07ysxTqjdeYroqU/Py+Cc5pz6/5akm+LWPTzs22lM=;
        b=mwZY6RIHCYYolXKsFqeQdTyKoVwc4hhfe5F6brAmL+vkyCgtfXZImzjXNkjI4rEyFo
         U+vHk0XkNiVzVKOAgwk9n1zx7qiFgFFSDH4OEUEdv4wI3dDOc+RMPUtdvFoVqcW126xH
         chjg2plBA/ZmdYk87+AAbkT6EMc7KbB2tnej6wwbVPhMIPCkvp2jvCt+OaP3tFxpQ6sK
         7T+sY31MKLjkByByExzL8kWvI8iEBpcQJqD1jEK3Gq5eX3pEU4+atMnYOZ5rrhFCb0vV
         oOd2PXkHktgGruh2PSSW4iLWRP/j1lQyzQPAdm/D8hnBcpmaP16BA1IE2osT38G0RYTS
         bzUQ==
X-Gm-Message-State: ACrzQf3vM8KuhImLPiSa9F2ll/DUTHdTXYOFzNG+GhIpG7XL+iRuNbLC
        HGBgGoLBfVmAc5anKC3XwF+gpw==
X-Google-Smtp-Source: AMsMyM7iE0o4ORt9oTXFShOWd2GbbH8AYwuy0ar6SkYjAaqbv+7jTN+eop4OJBVOfb1IgY4tC1gmDg==
X-Received: by 2002:a17:90a:6889:b0:20d:7716:b05f with SMTP id a9-20020a17090a688900b0020d7716b05fmr519368pjd.104.1667673964976;
        Sat, 05 Nov 2022 11:46:04 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902650500b0017f74cab9eesm1974495plk.128.2022.11.05.11.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Nov 2022 11:46:04 -0700 (PDT)
Message-ID: <e3c55fda-043e-9cc7-3248-63574b374c13@kernel.dk>
Date:   Sat, 5 Nov 2022 12:46:03 -0600
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
 <46cb04ca-467c-2e33-f221-3e2a2eaabbda@kernel.dk>
 <fe28e9fa-b57b-8da6-383c-588f6e84f04f@kernel.dk>
 <CA+FuTSfEqmx_rHPLaSp+o+tYzqCvF6oSjSOse0KoFvXj9xK9Cw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+FuTSfEqmx_rHPLaSp+o+tYzqCvF6oSjSOse0KoFvXj9xK9Cw@mail.gmail.com>
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

On 11/5/22 12:05 PM, Willem de Bruijn wrote:
> On Sat, Nov 5, 2022 at 1:39 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>>> FWIW, when adding nsec resolution I initially opted for an init-based
>>>> approach, passing a new flag to epoll_create1. Feedback then was that
>>>> it was odd to have one syscall affect the behavior of another. The
>>>> final version just added a new epoll_pwait2 with timespec.
>>>
>>> I'm fine with just doing a pure syscall variant too, it was my original
>>> plan. Only changed it to allow for easier experimentation and adoption,
>>> and based on the fact that most use cases would likely use a fixed value
>>> per context anyway.
>>>
>>> I think it'd be a shame to drop the ctl, unless there's strong arguments
>>> against it. I'm quite happy to add a syscall variant too, that's not a
>>> big deal and would be a minor addition. Patch 6 should probably cut out
>>> the ctl addition and leave that for a patch 7, and then a patch 8 for
>>> adding a syscall.
>> I split the ctl patch out from the core change, and then took a look at
>> doing a syscall variant too. But there are a few complications there...
>> It would seem to make the most sense to build this on top of the newest
>> epoll wait syscall, epoll_pwait2(). But we're already at the max number
>> of arguments there...
>>
>> Arguably pwait2 should've been converted to use some kind of versioned
>> struct instead. I'm going to take a stab at pwait3 with that kind of
>> interface.
> 
> Don't convert to a syscall approach based solely on my feedback. It
> would be good to hear from others.

It's not just based on your feedback, if you read the original cover
letter, then that is the question that is posed in terms of API - ctl to
modify it, new syscall, or both? So figured I should at least try and
see what the syscall would look like.

> At a high level, I'm somewhat uncomfortable merging two syscalls for
> behavior that already works, just to save half the syscall overhead.
> There is no shortage of calls that may make some sense for a workload
> to merge. Is the quoted 6-7% cpu cycle reduction due to saving one
> SYSENTER/SYSEXIT (as the high resolution timer wake-up will be the
> same), or am I missing something more fundamental?

No, it's not really related to saving a single syscall, and you'd
potentially save more than just one as well. If we look at the two
extremes of applications, one will be low load and you're handling
probably just 1 event per loop. Not really interesting. At the other
end, you're fully loaded, and by the time you check for events, you have
'maxevents' (or close to) available. That obviously reduces system
calls, but more importantly, it also allows the application to get some
batching effects from processing these events.

In the medium range, there's enough processing to react pretty quickly
to events coming in, and you then end up doing just 1 event (or close to
that). To overcome that, we have some applications that detect this
medium range and do an artificial sleep before calling epoll_wait().
That was a nice effiency win for them. But we can do this a lot more
efficiently in the kernel. That was the idea behind this, and the
initial results from TAO (which does that sleep hack) proved it to be
more than worthwhile. Syscall reduction is one thing, improved batching
another, and just as importanly is sleep+wakeup reductions.

-- 
Jens Axboe
