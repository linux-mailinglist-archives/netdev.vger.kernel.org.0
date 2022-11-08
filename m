Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F2D621933
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 17:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiKHQP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 11:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiKHQP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 11:15:28 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A7753EDB
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 08:15:25 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id s10so9976905ioa.5
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 08:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GOOfSEYU17x7lW1mqeOYHAxqV1vrJzMhRnJ6jcrQTOI=;
        b=e1St1Y9udR0/nj90z94foyJrJ/mzlShjP0N/7N59idoPMW0xoxVnf78HiR/g27DNSZ
         aFXhVhqtYn4CTSteWZ3rV47He+PsRhYJun05Eon387RDHJWbkybD/Op7gGQ/9r03/uJZ
         Rs/hKzJwlBobB9uDkXqPRD8XMbuB8DKkper16UEVKQq80r9Jx3y4W7KoqGZ6xsX4rATr
         Uu2kESsANla5KtnfNMfgR6WsgmpCl6uAhXd4P8CZNhttOrHxu0LtnKoTRAwdO9ZpYA6n
         Joc5N8E7eZnC3MAqhz3bin82Ncb6lXmpNk856eHdFD2slFU7fWMPOnF5EykNUAZF7RsX
         8Ltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GOOfSEYU17x7lW1mqeOYHAxqV1vrJzMhRnJ6jcrQTOI=;
        b=LAOk8l53SXsno47LgshGRAJRi/JpEQNSi8kQ2YSVEey5qQXk6CDClbqtIw14u/fgUU
         cA5ieHKAQGVEiSxQ58OpBdyNqhUBxMZV23b1A6xxuX8GAEWWtGVZMwm015US3TevLmzX
         7PLiRynnEtPYOK26QH55L2ODnHw+domPEc4QBsN5MZBDh10F5Mh/njlwYrlnN4lx7PKV
         M4DRIYlvSXxlDfkFJNVEJOv+wlwimSh7deeYpKqEIUHfxq2et00yke9nSr2O18AlCrKY
         UcJAbTxNA7uiUt22ITkUewiIMsrUcNUy2bCIx3C6g1+K6kba2w9V3UzS9R5NtPYf6mvE
         tzYA==
X-Gm-Message-State: ACrzQf1o2VrdLlXAYIr38aPM1afzLufE9e1BNvkwKcy2YyikAhaHU2dd
        1JDubHjxBPkQrnpPSawynfZtzw==
X-Google-Smtp-Source: AMsMyM61Zi2wQyEOc95fNAuneImn5zVZickePKLuvqc2EAZe7l/PZ02Y5H7fKVGqSQbuo1veAuYQaQ==
X-Received: by 2002:a6b:4417:0:b0:6ca:d30a:913d with SMTP id r23-20020a6b4417000000b006cad30a913dmr34357226ioa.180.1667924125121;
        Tue, 08 Nov 2022 08:15:25 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y9-20020a029509000000b003758390c97esm3914291jah.83.2022.11.08.08.15.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 08:15:24 -0800 (PST)
Message-ID: <75c8f5fe-6d5f-32a9-1417-818246126789@kernel.dk>
Date:   Tue, 8 Nov 2022 09:15:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <Y2lw4Qc1uI+Ep+2C@fedora>
 <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk> <Y2phEZKYuSmPL5B5@fedora>
 <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk> <Y2p/YcUFhFDUnLGq@fedora>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y2p/YcUFhFDUnLGq@fedora>
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

On 11/8/22 9:10 AM, Stefan Hajnoczi wrote:
> On Tue, Nov 08, 2022 at 07:09:30AM -0700, Jens Axboe wrote:
>> On 11/8/22 7:00 AM, Stefan Hajnoczi wrote:
>>> On Mon, Nov 07, 2022 at 02:38:52PM -0700, Jens Axboe wrote:
>>>> On 11/7/22 1:56 PM, Stefan Hajnoczi wrote:
>>>>> Hi Jens,
>>>>> NICs and storage controllers have interrupt mitigation/coalescing
>>>>> mechanisms that are similar.
>>>>
>>>> Yep
>>>>
>>>>> NVMe has an Aggregation Time (timeout) and an Aggregation Threshold
>>>>> (counter) value. When a completion occurs, the device waits until the
>>>>> timeout or until the completion counter value is reached.
>>>>>
>>>>> If I've read the code correctly, min_wait is computed at the beginning
>>>>> of epoll_wait(2). NVMe's Aggregation Time is computed from the first
>>>>> completion.
>>>>>
>>>>> It makes me wonder which approach is more useful for applications. With
>>>>> the Aggregation Time approach applications can control how much extra
>>>>> latency is added. What do you think about that approach?
>>>>
>>>> We only tested the current approach, which is time noted from entry, not
>>>> from when the first event arrives. I suspect the nvme approach is better
>>>> suited to the hw side, the epoll timeout helps ensure that we batch
>>>> within xx usec rather than xx usec + whatever the delay until the first
>>>> one arrives. Which is why it's handled that way currently. That gives
>>>> you a fixed batch latency.
>>>
>>> min_wait is fine when the goal is just maximizing throughput without any
>>> latency targets.
>>
>> That's not true at all, I think you're in different time scales than
>> this would be used for.
>>
>>> The min_wait approach makes it hard to set a useful upper bound on
>>> latency because unlucky requests that complete early experience much
>>> more latency than requests that complete later.
>>
>> As mentioned in the cover letter or the main patch, this is most useful
>> for the medium load kind of scenarios. For high load, the min_wait time
>> ends up not mattering because you will hit maxevents first anyway. For
>> the testing that we did, the target was 2-300 usec, and 200 usec was
>> used for the actual test. Depending on what the kind of traffic the
>> server is serving, that's usually not much of a concern. From your
>> reply, I'm guessing you're thinking of much higher min_wait numbers. I
>> don't think those would make sense. If your rate of arrival is low
>> enough that min_wait needs to be high to make a difference, then the
>> load is low enough anyway that it doesn't matter. Hence I'd argue that
>> it is indeed NOT hard to set a useful upper bound on latency, because
>> that is very much what min_wait is.
>>
>> I'm happy to argue merits of one approach over another, but keep in mind
>> that this particular approach was not pulled out of thin air AND it has
>> actually been tested and verified successfully on a production workload.
>> This isn't a hypothetical benchmark kind of setup.
> 
> Fair enough. I just wanted to make sure the syscall interface that gets
> merged is as useful as possible.

That is indeed the main discussion as far as I'm concerned - syscall,
ctl, or both? At this point I'm inclined to just push forward with the
ctl addition. A new syscall can always be added, and if we do, then it'd
be nice to make one that will work going forward so we don't have to
keep adding epoll_wait variants...

-- 
Jens Axboe
