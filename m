Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62E524E8B1
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgHVQWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 12:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgHVQWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 12:22:17 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B889BC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 09:22:17 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s14so2264784plp.4
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 09:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B4jnxt+7nXgnRmVLjKHksdemzUDI4U6ylRq3GcvC2WM=;
        b=Y/4/HnOOzlBHBLBti9V7l/qNKTBKRLjpCgdmk++X2LrQyyd87/eBD6rJjqshuFo+4K
         IsCLiepA98Mvv4TwcolslBuM6ZpD7zFdhwHNa+8PXFpUllHpsa6jWijEKEksUaKnDsX8
         pevZ2m/zhhunO94lJC59so+d93lAYXWN+tyDgT4XXHtrag767GvxRNn2aCngRpxMXGZj
         A87CL8TNW126xYmTnGoFFfxOQdW75OTESNh5P6XmWZFeakBOVFBd1H0QWOvh1hF5+qIX
         bHbX0pwDBVGL8XMloyJdG+yWjS6AoCEN4OYYb7ZqgVjGnRR/xuMd2qU2D81z5QChkQoP
         URHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B4jnxt+7nXgnRmVLjKHksdemzUDI4U6ylRq3GcvC2WM=;
        b=E9acyav1PkjXO1pc3kKy3CJ8Hr8ecqRsciQomsPRoIBSI2TBZuaUmTHvT146yG0EUb
         ctqDEK0gZiwtw6McC4jLuaHFMIZxjhVx+r+10E3NLEzQDBI0M7SPudUZsvnOCTLJ63Z2
         kRXa9lTmuJbNj3Pmi+CRCvrtSVTVtqmCeDc+BfE5oTX0JGb8Rxmu6yvYakxLIONWsmQ6
         XaAmfWj6xNsB5CMv+fFfBpn0KnZmkjznb0kkOea0+ITNebc7r+y8whkUndaG8sjCeukZ
         1AA67f8HQSVTUi/nV+NiCykUz07kt//Gb5po0to7vDZdAmeHlUKxGb5K7iqv1vkrPU4Y
         LCTw==
X-Gm-Message-State: AOAM533SDw/UAmG5BU6ZFiBW0M6hoUlffw/dPGbWz9iDr93J3sAbacqT
        MgXZiLqI0r5BhHpUGVLdYSQFcqUy530=
X-Google-Smtp-Source: ABdhPJwthnzyJzpCL2fXWnwk9WvVmwyR/2Y0uv+ZRKiFDWiLVqtHyFYDrrdRa9u/bTcNjQk4KvVx5Q==
X-Received: by 2002:a17:902:b683:: with SMTP id c3mr6491574pls.248.1598113332440;
        Sat, 22 Aug 2020 09:22:12 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 7sm5474965pff.78.2020.08.22.09.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 09:22:11 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] net: add support for threaded NAPI polling
To:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
References: <20200821190151.9792-1-nbd@nbd.name>
 <20200821184924.5b5c421c@kicinski-fedora-PC1C0HJN>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <48e3082b-7d89-d0ad-f256-b1fa1dca0a45@gmail.com>
Date:   Sat, 22 Aug 2020 09:22:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821184924.5b5c421c@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/20 6:49 PM, Jakub Kicinski wrote:
> On Fri, 21 Aug 2020 21:01:50 +0200 Felix Fietkau wrote:
>> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
>> poll function does not perform well. Since NAPI poll is bound to the CPU it
>> was scheduled from, we can easily end up with a few very busy CPUs spending
>> most of their time in softirq/ksoftirqd and some idle ones.
>>
>> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
>> same except for using netif_threaded_napi_add instead of netif_napi_add.
>>
>> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
>> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
>> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
>> thread.
>>
>> With threaded NAPI, throughput seems stable and consistent (and higher than
>> the best results I got without it).
>>
>> Based on a patch by Hillf Danton
> 
> I've tested this patch on a non-NUMA system with a moderately
> high-network workload (roughly 1:6 network to compute cycles)
> - and it provides ~2.5% speedup in terms of RPS but 1/6/10% worse
> P50/P99/P999 latency.
> 
> I started working on a counter-proposal which uses a pool of threads
> dedicated to NAPI polling. It's not unlike the workqueue code but
> trying to be a little more clever. It gives me ~6.5% more RPS but at
> the same time lowers the p99 latency by 35% without impacting other
> percentiles. (I only started testing this afternoon, so hopefully the
> numbers will improve further).
> 
> I'm happy for this patch to be merged, it's quite nice, but I wanted 
> to give the heads up that I may have something that would replace it...
> 
> The extremely rough PoC, less than half-implemented code which is really
> too broken to share:
> https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/log/?h=tapi
> 

Yes, the idea of sharing a single napi_workq without the ability to perform
some per-queue tuning is probably okay for the class of devices Felix is interested in.

I vote for waiting a bit and see what you can achieve, since Felix showed no intent
to work on using kthreads instead of work queues.

Having one kthread per queue gives us existing instrumentation (sched stats),
and ability to decide for optimal affinities and priorities.

Thanks !
