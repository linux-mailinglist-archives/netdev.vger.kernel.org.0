Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F94A621A94
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbiKHR2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbiKHR2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:28:41 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEAD13EB9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:28:40 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id h206so11975539iof.10
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 09:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z2BqUuITXKXD3x974ZU/jMzss9BnT6lrNhOqUMpYtPU=;
        b=3W+pnKFRVAc9AQTDhO6El3k7416sI0KF0+A0KcOgZqtz4zChJ0mWlwvvkjDgcRCXGs
         7q13hRRgz7VtL6M4f3qd8jicuCqaZ9KK+xfY7BWsD9ti0r/4yDkGECrGZe2VTX1jcAp3
         Y6jq8Ia5az44x8Gh+Uo4V5zifQecoh5zpoJeSWaztPFsxvsCyJd7Mvep83HnCBmNgVy0
         v1QVdfz+2lqsPS2Km3b6+EswLM7X98619OrHEjzxEb0JBedzncAxYf+4kIyqxaBtY0c8
         7dAlJkPTNug6ChKA/MBWDri1mmANV4GegKltjRmX987KpX1z4HC1izXPOS4PtoijwHEz
         NxhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2BqUuITXKXD3x974ZU/jMzss9BnT6lrNhOqUMpYtPU=;
        b=qnlZSPD75GU/X7nsSJvo+7tnsCEHeAxINxqTzgHvSusayQ9VGTf+gBZYBXS4YCQFkQ
         2EduAcypvQMGAiQs8g2xGXBB+5Y4MQebvMQiDftZPIkGm18uAR7qR3t7B0hOm456Jk3z
         6Avo+yiY/IQCKrFVOlNLvvR5v2DFm+S68CHwBOhq33rjwJiwd0UrP0mcxsupyYAq0xo4
         /6xCeCjpln/D1iwkDtWaIb9XeYEHTh9ILrscHSXNVbPTgBnAd/FG7A79T0rBTZFSHgN+
         JfN26FatFUOWOn73urbkOdaBDdpPzEkyyi160EnsBP08UZh54yS0+Fo0fjV+/mvxb54+
         ih5Q==
X-Gm-Message-State: ACrzQf3XIx6GswCgN0PkwjMsVHH14z8vljNjdnqChce4F1Z75RnzvJmM
        F/Ls8Cs+EJSIBSrfVdKxieqQvBfZ4MLkei41
X-Google-Smtp-Source: AMsMyM7qVs172OBX9dAWncPdKSGK0cORI7wWqLrF2XSDZUWhply6enufPx9b1ilUqvWuH6aTHnX7Fw==
X-Received: by 2002:a5d:9659:0:b0:6bb:8ed4:ac6c with SMTP id d25-20020a5d9659000000b006bb8ed4ac6cmr885964ios.6.1667928519364;
        Tue, 08 Nov 2022 09:28:39 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g5-20020a028505000000b0034294118e1bsm3994086jai.126.2022.11.08.09.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 09:28:38 -0800 (PST)
Message-ID: <ba524eab-eff7-5fad-06c2-8188cdf881a1@kernel.dk>
Date:   Tue, 8 Nov 2022 10:28:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <Y2lw4Qc1uI+Ep+2C@fedora>
 <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk> <Y2phEZKYuSmPL5B5@fedora>
 <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk> <Y2p/YcUFhFDUnLGq@fedora>
 <75c8f5fe-6d5f-32a9-1417-818246126789@kernel.dk> <Y2qQuiZvuML14wX0@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y2qQuiZvuML14wX0@fedora>
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

On 11/8/22 10:24 AM, Stefan Hajnoczi wrote:
> On Tue, Nov 08, 2022 at 09:15:23AM -0700, Jens Axboe wrote:
>> On 11/8/22 9:10 AM, Stefan Hajnoczi wrote:
>>> On Tue, Nov 08, 2022 at 07:09:30AM -0700, Jens Axboe wrote:
>>>> On 11/8/22 7:00 AM, Stefan Hajnoczi wrote:
>>>>> On Mon, Nov 07, 2022 at 02:38:52PM -0700, Jens Axboe wrote:
>>>>>> On 11/7/22 1:56 PM, Stefan Hajnoczi wrote:
>>>>>>> Hi Jens,
>>>>>>> NICs and storage controllers have interrupt mitigation/coalescing
>>>>>>> mechanisms that are similar.
>>>>>>
>>>>>> Yep
>>>>>>
>>>>>>> NVMe has an Aggregation Time (timeout) and an Aggregation Threshold
>>>>>>> (counter) value. When a completion occurs, the device waits until the
>>>>>>> timeout or until the completion counter value is reached.
>>>>>>>
>>>>>>> If I've read the code correctly, min_wait is computed at the beginning
>>>>>>> of epoll_wait(2). NVMe's Aggregation Time is computed from the first
>>>>>>> completion.
>>>>>>>
>>>>>>> It makes me wonder which approach is more useful for applications. With
>>>>>>> the Aggregation Time approach applications can control how much extra
>>>>>>> latency is added. What do you think about that approach?
>>>>>>
>>>>>> We only tested the current approach, which is time noted from entry, not
>>>>>> from when the first event arrives. I suspect the nvme approach is better
>>>>>> suited to the hw side, the epoll timeout helps ensure that we batch
>>>>>> within xx usec rather than xx usec + whatever the delay until the first
>>>>>> one arrives. Which is why it's handled that way currently. That gives
>>>>>> you a fixed batch latency.
>>>>>
>>>>> min_wait is fine when the goal is just maximizing throughput without any
>>>>> latency targets.
>>>>
>>>> That's not true at all, I think you're in different time scales than
>>>> this would be used for.
>>>>
>>>>> The min_wait approach makes it hard to set a useful upper bound on
>>>>> latency because unlucky requests that complete early experience much
>>>>> more latency than requests that complete later.
>>>>
>>>> As mentioned in the cover letter or the main patch, this is most useful
>>>> for the medium load kind of scenarios. For high load, the min_wait time
>>>> ends up not mattering because you will hit maxevents first anyway. For
>>>> the testing that we did, the target was 2-300 usec, and 200 usec was
>>>> used for the actual test. Depending on what the kind of traffic the
>>>> server is serving, that's usually not much of a concern. From your
>>>> reply, I'm guessing you're thinking of much higher min_wait numbers. I
>>>> don't think those would make sense. If your rate of arrival is low
>>>> enough that min_wait needs to be high to make a difference, then the
>>>> load is low enough anyway that it doesn't matter. Hence I'd argue that
>>>> it is indeed NOT hard to set a useful upper bound on latency, because
>>>> that is very much what min_wait is.
>>>>
>>>> I'm happy to argue merits of one approach over another, but keep in mind
>>>> that this particular approach was not pulled out of thin air AND it has
>>>> actually been tested and verified successfully on a production workload.
>>>> This isn't a hypothetical benchmark kind of setup.
>>>
>>> Fair enough. I just wanted to make sure the syscall interface that gets
>>> merged is as useful as possible.
>>
>> That is indeed the main discussion as far as I'm concerned - syscall,
>> ctl, or both? At this point I'm inclined to just push forward with the
>> ctl addition. A new syscall can always be added, and if we do, then it'd
>> be nice to make one that will work going forward so we don't have to
>> keep adding epoll_wait variants...
> 
> epoll_wait3() would be consistent with how maxevents and timeout work.
> It does not suffer from extra ctl syscall overhead when applications
> need to change min_wait.
> 
> The way the current patches add min_wait into epoll_ctl() seems hacky to
> me. struct epoll_event was meant for file descriptor event entries. It
> won't necessarily be large enough for future extensions (luckily
> min_wait only needs a uint64_t value). It's turning epoll_ctl() into an
> ioctl()/setsockopt()-style interface, which is bad for anything that
> needs to understand syscalls, like seccomp. A properly typed
> epoll_wait3() seems cleaner to me.

The ctl method is definitely a bit of an oddball. I've highlighted why
I went that way in earlier emails, but in summary:

- Makes it easy to adopt, just adding two lines at init time.

- Moves detection of availability to init time as well, rather than
  the fast path.

I don't think anyone would want to often change the wait, it's
something you'd set at init time. If you often want to change values
for some reason, then obviously a syscall parameter would be a lot
better.

epoll_pwait3() would be vastly different than the other ones, simply
because epoll_pwait2() is already using the maximum number of args.
We'd need to add an epoll syscall struct at that point, probably
with flags telling us if signal_struct or timeout is actually valid.

This is not to say I don't think we should add a syscall interface,
just some of the arguments pro and con from having actually looked
at it.

-- 
Jens Axboe


