Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1AB476249
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhLOTzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhLOTzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 14:55:53 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEBAC061574;
        Wed, 15 Dec 2021 11:55:52 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z5so79488892edd.3;
        Wed, 15 Dec 2021 11:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+FwOsMPFWuHD3Srr5u6p6BaVxiN7tOGCdTYxX9oGL+o=;
        b=iZZfv93BK2mUBBYQ9HStlRrkIUid0JR5mqBhFAVzgoSdsdGevV1qM4FxfpJmXtzMys
         jUixU/rthfXWIBwtD8daClZfqLVGLLPt9pC89XbWSqYvZFQAZUBuNq4M08ewPGSJvS0/
         w1y17xDhsg/oNWC5FO5GYLClVYqb01fO+pwGG7xm83gGQ3Hx8ED92M5CtsDLdWZbvWEt
         hIULSNMAIe0AtzxGs4u7qdPPJn6bmWbXB5YHGxWnEkRYwknuoP+k5XJVSiG6OGNN0lYz
         y2XmWakWd3Sv7+h5+nBQXXfuIZeRR/cfJ7xXCLE/i2KFB3FTalOvvKlulkda1LzbI1JC
         A5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+FwOsMPFWuHD3Srr5u6p6BaVxiN7tOGCdTYxX9oGL+o=;
        b=ghaJad1BYVbPcyEcRuRjBUY3ah9vsUXlJcFHxVOpZFx22lSJu7fYoV2eV95jBSWv50
         C2G6jEQki8wwVUHh0ti1WCmyauOhuTdiptH96OGZu9v+tzaGqRK4zTRiHai//Vlua//w
         ytf9RFtQG5fjOIzcx+jueDb5x/ZbAf/AL1Flimh5TFH2u/N7b+2CB0wbuVmt8WdMQ++0
         H240eyDv93hRC6DqEVzavphrnv0gFQgjm4q3nZZuwbLW4ACTDpthUXHqgGzpFwPU0j1/
         +BORBEGI50FQG8FZiz33gbChtRYvPixyLsYldmGmJfJ5ad9MtVJRHezuy1AB/b7pijKc
         vOlA==
X-Gm-Message-State: AOAM533rQ2/giFGAkgBg06Dki75Vef2HQp1/5nq0AV2FLGHaQAJRGQZi
        JgDgrtyX2BqWYq5wKaH0BgA=
X-Google-Smtp-Source: ABdhPJxgPSPCKdd+bs0T3S6jJAWO+RFNkXUXFnQDekQ03XwGYWVsUzFiNfApY9cxnxCs8Rz/fk+jgg==
X-Received: by 2002:a17:907:3d01:: with SMTP id gm1mr14554ejc.749.1639598150996;
        Wed, 15 Dec 2021 11:55:50 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id f27sm1032192ejj.193.2021.12.15.11.55.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 11:55:50 -0800 (PST)
Message-ID: <92f69969-42dc-204a-4138-16fdaaebb78d@gmail.com>
Date:   Wed, 15 Dec 2021 19:55:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
 <Yboc/G18R1Vi1eQV@google.com>
 <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com>
 <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com>
 <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
 <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 19:15, Stanislav Fomichev wrote:
> On Wed, Dec 15, 2021 at 10:54 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 12/15/21 18:24, sdf@google.com wrote:
>>> On 12/15, Pavel Begunkov wrote:
>>>> On 12/15/21 17:33, sdf@google.com wrote:
>>>>> On 12/15, Pavel Begunkov wrote:
>>>>>> On 12/15/21 16:51, sdf@google.com wrote:
>>>>>>> On 12/15, Pavel Begunkov wrote:
>>>>>>>> � /* Wrappers for __cgroup_bpf_run_filter_skb() guarded by cgroup_bpf_enabled. */
>>>>>>>> � #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)����������������� \
>>>>>>>> � ({����������������������������������������� \
>>>>>>>> ����� int __ret = 0;��������������������������������� \
>>>>>>>> -��� if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))������������� \
>>>>>>>> +��� if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&������������� \
>>>>>>>> +������� CGROUP_BPF_TYPE_ENABLED((sk), CGROUP_INET_INGRESS))���������� \
>>>>>>>
>>>>>>> Why not add this __cgroup_bpf_run_filter_skb check to
>>>>>>> __cgroup_bpf_run_filter_skb? Result of sock_cgroup_ptr() is already there
>>>>>>> and you can use it. Maybe move the things around if you want
>>>>>>> it to happen earlier.
>>>>>
>>>>>> For inlining. Just wanted to get it done right, otherwise I'll likely be
>>>>>> returning to it back in a few months complaining that I see measurable
>>>>>> overhead from the function call :)
>>>>>
>>>>> Do you expect that direct call to bring any visible overhead?
>>>>> Would be nice to compare that inlined case vs
>>>>> __cgroup_bpf_prog_array_is_empty inside of __cgroup_bpf_run_filter_skb
>>>>> while you're at it (plus move offset initialization down?).
>>>
>>>> Sorry but that would be waste of time. I naively hope it will be visible
>>>> with net at some moment (if not already), that's how it was with io_uring,
>>>> that's what I see in the block layer. And in anyway, if just one inlined
>>>> won't make a difference, then 10 will.
>>>
>>> I can probably do more experiments on my side once your patch is
>>> accepted. I'm mostly concerned with getsockopt(TCP_ZEROCOPY_RECEIVE).
>>> If you claim there is visible overhead for a direct call then there
>>> should be visible benefit to using CGROUP_BPF_TYPE_ENABLED there as
>>> well.
>>
>> Interesting, sounds getsockopt might be performance sensitive to
>> someone.
>>
>> FWIW, I forgot to mention that for testing tx I'm using io_uring
>> (for both zc and not) with good submission batching.
> 
> Yeah, last time I saw 2-3% as well, but it was due to kmalloc, see
> more details in 9cacf81f8161, it was pretty visible under perf.
> That's why I'm a bit skeptical of your claims of direct calls being
> somehow visible in these 2-3% (even skb pulls/pushes are not 2-3%?).

migrate_disable/enable together were taking somewhat in-between
1% and 1.5% in profiling, don't remember the exact number. The rest
should be from rcu_read_lock/unlock() in BPF_PROG_RUN_ARRAY_CG_FLAGS()
and other extra bits on the way.

I'm skeptical I'll be able to measure inlining one function,
variability between boots/runs is usually greater and would hide it.

> But tbf I don't understand how it all plays out with the io_uring.

1 syscall per N requests (N=32 IIRC), 1 fdget() per N, no payload
page referencing (for zc), and so on


> (mostly trying to understand where there is some gain left on the
> table for TCP_ZEROCOPY_RECEIVE).

-- 
Pavel Begunkov
