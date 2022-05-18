Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9539652B2DC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbiERG5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbiERG5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:57:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175C22AE20
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:57:43 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id bh5so924634plb.6
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=H2/5LhVK5LQwWafqLqKW0LuSdW+8K8rE6sXyLUjvZ20=;
        b=g8OwWZUT6pVOSmhJMcD1IuJuzUFlb9xjGHTLOsfk/1ziY8+i9QNUa7qTP59l0kzQJf
         x6QpmgHJ6dDAolq1OUfgu+FJixdEmNuYFINVmdIUaDkq5LdWiVP72dRSBynUpBWOWh6k
         z08HVW2D2Tyx7ZhplteluRHtLu+/1TRHnSTmK809D3r8/Bfy/JA19dC5bXyuiZrwHkX+
         dfASEAHuUuDTkqI7QZYsGBKhZdM5ox6g56rpTmKYsVuK66F0P+Z416ESomTkzcDZRkQG
         UPKc6cGdOmbE3QQzWi9q/q65aJGvTPVeN5YYMZ4RSCpZMkh1Cx4WtmyFA0KAMaV9Deq1
         bw6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=H2/5LhVK5LQwWafqLqKW0LuSdW+8K8rE6sXyLUjvZ20=;
        b=WvRcHymFd3rR/doO5xNVGk4jn9dtd3pwHFfV8XZe24EfBeFzM2Nnkiil8eUHFVHk3X
         m5dibNnIB1V0/QftkqRgq+zYDarTnRTH4M60iSpFKYstILHOMgHs5b2AeIV2l4omY2iN
         dfwSETpfUj2kVrIfq2fw0ZeWOxId0UadX8RNZGY4/Vdyb6ecGoIcWJAH6gLOzKoT0siS
         YXBiywnP7pbKrGldRa3PneNDKIiDzwDZckxA575Qstu+IrZ5ZK5KZ6X4xsHWcK65byoP
         KL7eqh1eP4k0khQrl2UWuM2QdINEL2xAmOtADa24rkcgK54nX/4+wuYnVAsCVTNzGfIe
         DqcA==
X-Gm-Message-State: AOAM532+CV4YQGVxpmGCFt23bvvX/aRtoZ0utoE7VnLZ4GnjqACY4B8T
        p/SW8GMIk2J6xchF/OQCAKm/gg==
X-Google-Smtp-Source: ABdhPJxJlbhzV5O2GMcems2e9XBxlBAxVC0LqUD20RvDEwvEbfGmCERRxT6PGUhhJfXKbPvMh+1lJA==
X-Received: by 2002:a17:902:7483:b0:161:80be:cd37 with SMTP id h3-20020a170902748300b0016180becd37mr12249891pll.138.1652857062477;
        Tue, 17 May 2022 23:57:42 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id i132-20020a62878a000000b0050dc762813fsm1018256pfe.25.2022.05.17.23.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 23:57:42 -0700 (PDT)
Message-ID: <6ae715b3-96b1-2b42-4d1a-5267444d586b@bytedance.com>
Date:   Wed, 18 May 2022 14:57:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH] bpf: avoid grabbing spin_locks of all cpus
 when no free elems
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20220518062715.27809-1-zhoufeng.zf@bytedance.com>
 <CAADnVQ+x-A87Z9_c+3vuRJOYm=gCOBXmyCJQ64CiCNukHS6FpA@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAADnVQ+x-A87Z9_c+3vuRJOYm=gCOBXmyCJQ64CiCNukHS6FpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/18 下午2:32, Alexei Starovoitov 写道:
> On Tue, May 17, 2022 at 11:27 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> We encountered bad case on big system with 96 CPUs that
>> alloc_htab_elem() would last for 1ms. The reason is that after the
>> prealloc hashtab has no free elems, when trying to update, it will still
>> grab spin_locks of all cpus. If there are multiple update users, the
>> competition is very serious.
>>
>> So this patch add is_empty in pcpu_freelist_head to check freelist
>> having free or not. If having, grab spin_lock, or check next cpu's
>> freelist.
>>
>> Before patch: hash_map performance
>> ./map_perf_test 1
>> 0:hash_map_perf pre-alloc 975345 events per sec
>> 4:hash_map_perf pre-alloc 855367 events per sec
>> 12:hash_map_perf pre-alloc 860862 events per sec
>> 8:hash_map_perf pre-alloc 849561 events per sec
>> 3:hash_map_perf pre-alloc 849074 events per sec
>> 6:hash_map_perf pre-alloc 847120 events per sec
>> 10:hash_map_perf pre-alloc 845047 events per sec
>> 5:hash_map_perf pre-alloc 841266 events per sec
>> 14:hash_map_perf pre-alloc 849740 events per sec
>> 2:hash_map_perf pre-alloc 839598 events per sec
>> 9:hash_map_perf pre-alloc 838695 events per sec
>> 11:hash_map_perf pre-alloc 845390 events per sec
>> 7:hash_map_perf pre-alloc 834865 events per sec
>> 13:hash_map_perf pre-alloc 842619 events per sec
>> 1:hash_map_perf pre-alloc 804231 events per sec
>> 15:hash_map_perf pre-alloc 795314 events per sec
>>
>> hash_map the worst: no free
>> ./map_perf_test 2048
>> 6:worse hash_map_perf pre-alloc 28628 events per sec
>> 5:worse hash_map_perf pre-alloc 28553 events per sec
>> 11:worse hash_map_perf pre-alloc 28543 events per sec
>> 3:worse hash_map_perf pre-alloc 28444 events per sec
>> 1:worse hash_map_perf pre-alloc 28418 events per sec
>> 7:worse hash_map_perf pre-alloc 28427 events per sec
>> 13:worse hash_map_perf pre-alloc 28330 events per sec
>> 14:worse hash_map_perf pre-alloc 28263 events per sec
>> 9:worse hash_map_perf pre-alloc 28211 events per sec
>> 15:worse hash_map_perf pre-alloc 28193 events per sec
>> 12:worse hash_map_perf pre-alloc 28190 events per sec
>> 10:worse hash_map_perf pre-alloc 28129 events per sec
>> 8:worse hash_map_perf pre-alloc 28116 events per sec
>> 4:worse hash_map_perf pre-alloc 27906 events per sec
>> 2:worse hash_map_perf pre-alloc 27801 events per sec
>> 0:worse hash_map_perf pre-alloc 27416 events per sec
>> 3:worse hash_map_perf pre-alloc 28188 events per sec
>>
>> ftrace trace
>>
>> 0)               |  htab_map_update_elem() {
>> 0)   0.198 us    |    migrate_disable();
>> 0)               |    _raw_spin_lock_irqsave() {
>> 0)   0.157 us    |      preempt_count_add();
>> 0)   0.538 us    |    }
>> 0)   0.260 us    |    lookup_elem_raw();
>> 0)               |    alloc_htab_elem() {
>> 0)               |      __pcpu_freelist_pop() {
>> 0)               |        _raw_spin_lock() {
>> 0)   0.152 us    |          preempt_count_add();
>> 0)   0.352 us    |          native_queued_spin_lock_slowpath();
>> 0)   1.065 us    |        }
>>                   |        ...
>> 0)               |        _raw_spin_unlock() {
>> 0)   0.254 us    |          preempt_count_sub();
>> 0)   0.555 us    |        }
>> 0) + 25.188 us   |      }
>> 0) + 25.486 us   |    }
>> 0)               |    _raw_spin_unlock_irqrestore() {
>> 0)   0.155 us    |      preempt_count_sub();
>> 0)   0.454 us    |    }
>> 0)   0.148 us    |    migrate_enable();
>> 0) + 28.439 us   |  }
>>
>> The test machine is 16C, trying to get spin_lock 17 times, in addition
>> to 16c, there is an extralist.
> Is this with small max_entries and a large number of cpus?
>
> If so, probably better to fix would be to artificially
> bump max_entries to be 4x of num_cpus.
> Racy is_empty check still wastes the loop.

This hash_map worst testcase with 16 CPUs, map's max_entries is 1000.

This is the test case I constructed, it is to fill the map on purpose, 
and then

continue to update, just to reproduce the problem phenomenon.

The bad case we encountered with 96 CPUs, map's max_entries is 10240.


