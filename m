Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7844A8C5F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353721AbiBCTVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbiBCTVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:21:22 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4EDC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:21:21 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id a13so6944581wrh.9
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 11:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XdbGRqUg5JGdaBYx8J7beSJfyOOetv388ml4l0LATOg=;
        b=a1Scvrb5aoGaCcKnwq3836fvlnCLVsfTX86b8FIeKvGxlkNxg5NEIv0wujbNUXoQRp
         Np6eRELsuZQsjFV5xeGIvs0OXDDRHbyOXTY+/YzJksOQUAr7h7mT6M4yeKT44ekiINdh
         NyBwauBI/rNRchXawfwWpl+sUMZqrK4WU+fugCMRJPRFB+jILITXjAwHvCAt7soTDVYQ
         d4rSwjjSwFePUEvLD6N9EhtWEVN5OsvMoZJINBgDMm9l/oDSfb4kpOKYQJRfB59wo7nE
         lAzZBIwD7mEUYalbtX5IifIVlLpLtZGxMv6XByBUiYmjTxrJlT0S64uQWHiAWh9Y3dkb
         gHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XdbGRqUg5JGdaBYx8J7beSJfyOOetv388ml4l0LATOg=;
        b=APdmnq2kQf5nfSHOiWxIwwSNAJUPIDPbtZPsYiRF9H/9c59xQtmpqhuGl1egnazSKe
         KACiMp0wqv8e2L9+S+E3lOkzSpNL5ksfSRfkW4XvhyxlY/z25TSoOUOHOFdvhogddI2k
         7LzSHR3nPuMNsqI6giNGyFlhjkloQfXbHBZI5lFGxoVgt4ui488brCkV2Lc//uh93bVb
         FM0QTwiyDdVGdwn2OJKbJh0Jumq06Yl4CXTy2R0rbU7JiucDUAzE/WJhdyfVtaVDBBjF
         tFrkEDDR/ndfHS9mf3QcLG6vaxyWc7iM1QVJ2YLrlXZ8D2NxiUzZpIs8caAntYkPnSvd
         RH+w==
X-Gm-Message-State: AOAM533ZCSwLlnWxIKF95eOOwvc5j7M6NEy/QZM7isG0Xa1nbr8LLDCp
        0AgOtd+A+GtbgG0S98iu3v3w20mJ2PI=
X-Google-Smtp-Source: ABdhPJwwR8JA3Z3sntCeghrkincoPq6k0OT5GIdo5BJFmDJ0uAODmnpQxi87mVrByKkVL2C+mjWBDg==
X-Received: by 2002:a05:6000:2a7:: with SMTP id l7mr31161149wry.170.1643916080103;
        Thu, 03 Feb 2022 11:21:20 -0800 (PST)
Received: from [192.168.0.108] ([77.126.86.139])
        by smtp.gmail.com with ESMTPSA id y6sm14801287wrl.46.2022.02.03.11.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 11:21:19 -0800 (PST)
Message-ID: <f5206993-c967-eec2-4679-6054f954c271@gmail.com>
Date:   Thu, 3 Feb 2022 21:21:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [net-next v3 00/10] page_pool: Add page_pool stat counters
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        Saeed Mahameed <saeed@kernel.org>, brouer@redhat.com
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
 <bb50fffb-afa8-b258-5382-fe56294cd7b0@redhat.com>
 <CALALjgyF8X3Y7CqmxWbDH2R+Pgn=6=Vs7sUCuzSEH=BxLYR7Tg@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <CALALjgyF8X3Y7CqmxWbDH2R+Pgn=6=Vs7sUCuzSEH=BxLYR7Tg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/2022 7:30 PM, Joe Damato wrote:
> On Wed, Feb 2, 2022 at 6:31 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>> Adding Cc. Tariq and Saeed, as they wanted page_pool stats in the past.
>>
>> On 02/02/2022 02.12, Joe Damato wrote:
>>> Greetings:
>>>
>>> Sending a v3 as I noted some issues with the procfs code in patch 10 I
>>> submit in v2 (thanks, kernel test robot) and fixing the placement of the
>>> refill stat increment in patch 8.
>>
>> Could you explain why a single global stats (/proc/net/page_pool_stat)
>> for all page_pool instances for all RX-queues makes sense?
>>
>> I think this argument/explanation belongs in the cover letter.
> 
> I included an explanation in the v2 cover letter where those changes
> occurred, but you are right: I should have also included it in the v3
> cover letter.
> 
> My thought process was this:
> 
> - Stats now have to be enabled by an explicit kernel config option, so
> the user has to know what they are doing
> - Advanced users can move softirqs to CPUs as they wish and they could
> isolate a particular set of RX-queues on a set of CPUs this way
> - The result is that there is no need to expose anything to the
> drivers and no modifications to drivers are necessary once the single
> kernel config option is enabled and softirq affinity is configured
> 
> I had assumed by not exposing new APIs / page pool internals and by
> not requiring drivers to make any changes, I would have a better shot
> of getting my patches accepted.
> 
> It sounds like both you and Ilias strongly prefer per-pool-per-cpu
> stats, so I can make that change in the v4.
> 
>> What are you using this for?
> 
> I currently graph NIC driver stats from a number of different vendors
> to help better understand the performance of those NICs under my
> company's production workload.
> 
> For example, on i40e, I submit changes to the upstream driver [1] and
> am graphing those stats to better understand memory reuse rate. We
> have seen some issues around mm allocation contention in production
> workloads with certain NICs and system architectures.
> 
> My findings with mlx5 have indicated that the proprietary page reuse
> algorithm in the driver, with our workload, does not provide much
> memory re-use, and causes pressure against the kernel's page
> allocator.  The page pool should help remedy this, but without stats I
> don't have a clear way to measure the effect.
> 
> So in short: I'd like to gather and graph stats about the page pool
> API to determine how much impact the page pool API has on page reuse
> for mlx5 in our workload.
> 
Hi Joe, Jesper, Ilias, and all,

We plan to totally remove the in-driver page-cache and fully rely on 
page-pool for the allocations and dma mapping. This did not happen until 
now as the page pool did not support elevated page refcount (multiple 
frags per-page) and stats.

I'm happy to see that these are getting attention! Thanks for investing 
time and effort to push these tasks forward!

>> And do Tariq and Saeeds agree with this single global stats approach?
> 
> I don't know; I hope they'll chime in.
> 

I agree with Jesper and Ilias. Global per-cpu pool stats are very 
limited. There is not much we can do with the super-position of several 
page-pools. IMO, these stats can be of real value only when each cpu has 
a single pool. Otherwise, the summed stats of two or more pools won't 
help much in observability, or debug.

Tariq

> As I mentioned above, I don't really mind which approach is preferred
> by you all. I had assumed that something with fewer external APIs
> would be more likely to be accepted, and so I made that change in v2.
> 
>>> I only modified the placement of the refill stat, but decided to re-run the
>>> benchmarks used in the v2 [1], and the results are:
>>
>> I appreciate that you are running the benchmarks.
> 
> Sure, no worries. As you mentioned in the other thread, perhaps some
> settings need to be adjusted to show more relevant data on faster
> systems.
> 
> When I work on the v4, I will take a look at the benchmarks and
> explain any modifications made to them or their options when
> presenting the test results.
> 
>>> Test system:
> 
> [...]
> 
> Thanks,
> Joe
> 
> [1]: https://patchwork.ozlabs.org/project/intel-wired-lan/cover/1639769719-81285-1-git-send-email-jdamato@fastly.com/
