Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0676432CCA
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 06:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhJSEdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 00:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbhJSEdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 00:33:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008CCC061745
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 21:31:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y4so12823868plb.0
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 21:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=kUyPOxOMXQjfb93EBzGQrtg42go6hZCap05KTki6qvg=;
        b=jZy3/VkyXdo6REuE1SUusJ78rZRoslZ/270UGfNHirS09UqyUAI33+wrYEmfR8jhZ0
         YziDtnABBEWMDUbEAr6u7iYC9JpAbSrp3C0BZzrYoSedwfGKjYhEbPjpgJlotsRp5dFL
         RgVScCuEG1+ELqD75PeHh3LRoJDco6AHBnfzbJ66rOoW305By3nSPnB0U33Gfc8yqObz
         iy/cPejf5nmgtcR76t/1Z5nqAvWnRQmWSPrLQRcLQwtUeo5y9qjNX3z6bnc4xC3UWolJ
         L3Koltkp7ci1RYNxOVzAU4di+RSK4Swk+AXiRDfy8rtb+uZdm4uEYum/QitmOsBf2P2I
         e6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kUyPOxOMXQjfb93EBzGQrtg42go6hZCap05KTki6qvg=;
        b=svJUtF5NKzfpuu3j7dRsgtHs87oBNMBCko3Z/4YnbDkJaAcRT9QCcvKx2P9xY27hSJ
         2YwzJ9i5G4BT26xMFxzjzOug5xyxXkZQYhBDRzbkU5njfHTCufCavArWteXPoydTY4kc
         7j7Lz0kYCVrNeydwpHtMICagHg29JZ1lqtrAWrQ59N/GxjVu0N6EyvisJk8E90CqhqGD
         QBTKKtKcwf14YrxirMAThcS3eIiuBs5WVI4K3UGVYgfFnZY2t6T/+ymdKXQMqXW1VXf4
         EdqS63RVLazgWhGtudO/1XKh7PULkHEEVmW4gOS5YSEn5MvSfE5PaJB21GZGQgTLvouU
         zmHA==
X-Gm-Message-State: AOAM532cWF6ULQsh4pZq1bjuOSTmzIrmIsljP5jFjDDjkBU2roOT4w+r
        e+zPYptisbSovocY6dlQidMd1w==
X-Google-Smtp-Source: ABdhPJzgZDax87g2VGRQwcn15ZwkXG0NBB/M5S98KMwIeCzwCOo/xb2WMFiwx9pPHlbbAZpP7Cr0UQ==
X-Received: by 2002:a17:902:eccf:b0:13e:b002:d8bd with SMTP id a15-20020a170902eccf00b0013eb002d8bdmr30972903plh.48.1634617867472;
        Mon, 18 Oct 2021 21:31:07 -0700 (PDT)
Received: from [10.70.253.117] ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id t2sm1080172pgf.35.2021.10.18.21.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 21:31:07 -0700 (PDT)
Message-ID: <36b27bba-e20b-8fd4-1436-d2d4c0e86896@bytedance.com>
Date:   Tue, 19 Oct 2021 12:31:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [External] Re: [PATCH] bpf: use count for prealloc hashtab too
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20211015090353.31248-1-zhouchengming@bytedance.com>
 <CAADnVQ+A5LdWQTXFugNTceGcz_biV-uEJma4oT5UJKeHQBHQPw@mail.gmail.com>
 <6d7246b6-195e-ee08-06b1-2d1ec722e7b2@bytedance.com>
 <CAADnVQKG5=qVSjZGzHEc0ijwiYABVCU1uc8vOQ-ZLibhpW--Hg@mail.gmail.com>
 <b8f6c2f6-1b07-9306-46da-5ab170a125f9@bytedance.com>
 <CAADnVQJpcFXVE1j5aEdeyCoBZytzytiYP+3AwQxtWmNj6q-kNQ@mail.gmail.com>
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <CAADnVQJpcFXVE1j5aEdeyCoBZytzytiYP+3AwQxtWmNj6q-kNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2021/10/19 上午11:45, Alexei Starovoitov 写道:
> On Mon, Oct 18, 2021 at 8:14 PM Chengming Zhou
> <zhouchengming@bytedance.com> wrote:
>>
>> 在 2021/10/19 上午9:57, Alexei Starovoitov 写道:
>>> On Sun, Oct 17, 2021 at 10:49 PM Chengming Zhou
>>> <zhouchengming@bytedance.com> wrote:
>>>>
>>>> 在 2021/10/16 上午3:58, Alexei Starovoitov 写道:
>>>>> On Fri, Oct 15, 2021 at 11:04 AM Chengming Zhou
>>>>> <zhouchengming@bytedance.com> wrote:
>>>>>>
>>>>>> We only use count for kmalloc hashtab not for prealloc hashtab, because
>>>>>> __pcpu_freelist_pop() return NULL when no more elem in pcpu freelist.
>>>>>>
>>>>>> But the problem is that __pcpu_freelist_pop() will traverse all CPUs and
>>>>>> spin_lock for all CPUs to find there is no more elem at last.
>>>>>>
>>>>>> We encountered bad case on big system with 96 CPUs that alloc_htab_elem()
>>>>>> would last for 1ms. This patch use count for prealloc hashtab too,
>>>>>> avoid traverse and spin_lock for all CPUs in this case.
>>>>>>
>>>>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>>>>>
>>>>> It's not clear from the commit log what you're solving.
>>>>> The atomic inc/dec in critical path of prealloc maps hurts performance.
>>>>> That's why it's not used.
>>>>>
>>>> Thanks for the explanation, what I'm solving is when hash table hasn't free
>>>> elements, we don't need to call __pcpu_freelist_pop() to traverse and
>>>> spin_lock all CPUs. The ftrace output of this bad case is below:
>>>>
>>>>  50)               |  htab_map_update_elem() {
>>>>  50)   0.329 us    |    _raw_spin_lock_irqsave();
>>>>  50)   0.063 us    |    lookup_elem_raw();
>>>>  50)               |    alloc_htab_elem() {
>>>>  50)               |      pcpu_freelist_pop() {
>>>>  50)   0.209 us    |        _raw_spin_lock();
>>>>  50)   0.264 us    |        _raw_spin_lock();
>>>
>>> This is LRU map. Not hash map.
>>> It will grab spin_locks of other cpus
>>> only if all previous cpus don't have free elements.
>>> Most likely your map is actually full and doesn't have any free elems.
>>> Since it's an lru it will force free an elem eventually.
>>>
>>
>> Maybe I missed something, the map_update_elem function of LRU map is
>> htab_lru_map_update_elem() and the htab_map_update_elem() above is the
>> map_update_elem function of hash map.
>> Because of the implementation of percpu freelist used in hash map, it
>> will spin_lock all other CPUs when there is no free elements.
> 
> Ahh. Right. Then what's the point of optimizing the error case
> at the expense of the fast path?
> 

Yes, this patch only optimized the very bad case that no free elements left,
and add atomic operation in the fast path. Maybe the better workaround is not
allowing full hash map in our case or using LRU map?
But the problem of spinlock contention also exist even when the map is not full,
like some CPUs run out of its freelist but other CPUs seldom used, then have to
grab those CPUs' spinlock to get free element.
Should we change the current implementation of percpu freelist to percpu lockless freelist?

Thanks.
