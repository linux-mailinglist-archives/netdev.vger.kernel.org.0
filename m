Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A186962153E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiKHOJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiKHOJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:09:37 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAA1CE36
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:09:34 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id io19so14271953plb.8
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e7so45kCZWiO9Fne67cf9GT73zH4jXuY/xOts4w/4F4=;
        b=0FpV3espfNl8M9gPAphHfZi1iEWRF72DrvEaptOlEw5H71MgjyGRaoHR9DKTC5kX8K
         kWRAnc5gqZ8ClrLMbjniM+mk5KgA5QXCG1STYHO8GXB1hcv+v4Noaaxd+ZsppImuao5y
         qEMxUNOXMOsvKrpGMWisvafed0ouWm7u7gGCLlZe3bQa4IzcBRiFh6yESzBvVsjZiKN4
         VeetDGbpvBCCR3NXvZ+ASKil0qkbNABdBI6zG03Vh1+D/l4RfkVom1GMxi7oSIJnPAbc
         GjEhT+48/spLero9rEdctpNBNCCHHyD21ltbCpxsh/Bx1mtd80BlCuqq4QjBX5EBPynD
         WxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e7so45kCZWiO9Fne67cf9GT73zH4jXuY/xOts4w/4F4=;
        b=tSd4QuJhBuUXl0h+hSjt6Mc1rKkPQsq5m1jYIrxbGcF2/+1yZxG2uWz6NRSstFdHNE
         MG63qH1cG4r+lglPifbPNynQtmJYXUBPbnLzF7L6Ch1qMJ9g1VLtXzckiQMaVFJBujJ2
         I/bSIPC3s8qJlJBphHHYFXfGFJUIwG+VlIXR3PlnFFoENGhsXzFHXa/+Cgiz3Row+JZy
         0C84Ws2Afhyu5aeoKrvDxO/uLB1qJR7VHo66YIeZizyKtqZg1GQNMVf/d0sXvL75jKN+
         0SRDu86CtC+VjIlFghGKoTG2sdIcMuryqo+3v5MXs1wAwqJcPBqFjNbx241b1u2yo+aJ
         XAAg==
X-Gm-Message-State: ACrzQf1fyW62Kpz4XlFXE5bbk2OgJMpRo1jYWmuoTVFoHY9ks/3ZY1v7
        IQCuR2YSdCTj/skwzBbvSwZsl4gFevZqdZ3G
X-Google-Smtp-Source: AMsMyM7H0CgVAUF8CN1mdrNYNs/We8zGOtzbz5ULoUh5Gg/fLMPaufxzd/Xx3P4jMv6oma+uAha/6g==
X-Received: by 2002:a17:90a:2b47:b0:213:a42a:13e5 with SMTP id y7-20020a17090a2b4700b00213a42a13e5mr58414355pjc.31.1667916573582;
        Tue, 08 Nov 2022 06:09:33 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id pc3-20020a17090b3b8300b00212cf2fe8c3sm21361986pjb.1.2022.11.08.06.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 06:09:32 -0800 (PST)
Message-ID: <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk>
Date:   Tue, 8 Nov 2022 07:09:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <Y2lw4Qc1uI+Ep+2C@fedora>
 <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk> <Y2phEZKYuSmPL5B5@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y2phEZKYuSmPL5B5@fedora>
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

On 11/8/22 7:00 AM, Stefan Hajnoczi wrote:
> On Mon, Nov 07, 2022 at 02:38:52PM -0700, Jens Axboe wrote:
>> On 11/7/22 1:56 PM, Stefan Hajnoczi wrote:
>>> Hi Jens,
>>> NICs and storage controllers have interrupt mitigation/coalescing
>>> mechanisms that are similar.
>>
>> Yep
>>
>>> NVMe has an Aggregation Time (timeout) and an Aggregation Threshold
>>> (counter) value. When a completion occurs, the device waits until the
>>> timeout or until the completion counter value is reached.
>>>
>>> If I've read the code correctly, min_wait is computed at the beginning
>>> of epoll_wait(2). NVMe's Aggregation Time is computed from the first
>>> completion.
>>>
>>> It makes me wonder which approach is more useful for applications. With
>>> the Aggregation Time approach applications can control how much extra
>>> latency is added. What do you think about that approach?
>>
>> We only tested the current approach, which is time noted from entry, not
>> from when the first event arrives. I suspect the nvme approach is better
>> suited to the hw side, the epoll timeout helps ensure that we batch
>> within xx usec rather than xx usec + whatever the delay until the first
>> one arrives. Which is why it's handled that way currently. That gives
>> you a fixed batch latency.
> 
> min_wait is fine when the goal is just maximizing throughput without any
> latency targets.

That's not true at all, I think you're in different time scales than
this would be used for.

> The min_wait approach makes it hard to set a useful upper bound on
> latency because unlucky requests that complete early experience much
> more latency than requests that complete later.

As mentioned in the cover letter or the main patch, this is most useful
for the medium load kind of scenarios. For high load, the min_wait time
ends up not mattering because you will hit maxevents first anyway. For
the testing that we did, the target was 2-300 usec, and 200 usec was
used for the actual test. Depending on what the kind of traffic the
server is serving, that's usually not much of a concern. From your
reply, I'm guessing you're thinking of much higher min_wait numbers. I
don't think those would make sense. If your rate of arrival is low
enough that min_wait needs to be high to make a difference, then the
load is low enough anyway that it doesn't matter. Hence I'd argue that
it is indeed NOT hard to set a useful upper bound on latency, because
that is very much what min_wait is.

I'm happy to argue merits of one approach over another, but keep in mind
that this particular approach was not pulled out of thin air AND it has
actually been tested and verified successfully on a production workload.
This isn't a hypothetical benchmark kind of setup.

-- 
Jens Axboe
