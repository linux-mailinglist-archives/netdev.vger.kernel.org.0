Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DF3520D58
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbiEJF5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 01:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiEJF5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 01:57:02 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CE611948F
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:53:04 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id v11so14071634pff.6
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 22:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=hFPZlOrD/A5L9itirMqY09jIldfwhWlMFZ4kJKsxVqI=;
        b=8VkXDXhovv95HK+Lp425GS8WIyMwtuBDJ+VdAgoNHyV0gKw4uSSV+n6SQ911T2Lwjq
         v+kAkSwuVo/yFISElEEM4BLaVA8gahkAsfSm/Douq1zdhCnZ/HYvXaoDdbITN9phcREs
         FbjsH4vIX0Hzp8FsQoE3UoHsckt00UnMA+R05y/zdOXNcfKtAyKG5BLnizlzvXi0NlMu
         S9dx/TgBeLbJjnc9Ql6dBI7qQRvKmAjSNx0glxly1PzZer2lkouxXcOvAQVshiPCuHWa
         mSIJGc6B/zZFKh2RlZu/5UAxGPdFWhCbXOSYXf/L5x7AYNsLQg3BObhWT6IdMUZR2TWi
         ii9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hFPZlOrD/A5L9itirMqY09jIldfwhWlMFZ4kJKsxVqI=;
        b=qWHlBanvOz3hF6x4JsWcx/GczoGH0xItqMlSsnzcET1K777peDMEqi7iXFfRM60W/w
         0zwsSOynFLzqwdYU0LFwrsLVGnIQp5o3DthDatHwtSBDU8tshgq0GU/+MisAGVCGL+9G
         LZBPawzewkqRBx/eXfwJaSZYdtZyoL6TeREaYByvHRZJ1PD0v0ZQ9jiiKLIdhgPJlCzm
         dEnJjiTCPvEx395vX01TOSrwLsnDLq5poVYRnjJ4yPto30AnUGowxmw+Ur/GteGy10Oz
         zCxM9zjj8hOutTDcqneSJFqbS+/E1tTAyZUymPCFLMn8yyW/cMdhwK7iTpuVpNtk6M3X
         04KQ==
X-Gm-Message-State: AOAM530GE/uzQTk2UtuJa7pek7oE70qt93zTpX+ZfkXEIkB40sC0YCc1
        RJ9g1B+gEkGUs28HEh1ydRzKJg==
X-Google-Smtp-Source: ABdhPJwleNG9ZC/Ct3KgCrLH5h08X2vnPz/6kODQpudSZUdjtVYZupevJjEuqDQeUvUfKRcdm7Woog==
X-Received: by 2002:a63:1a01:0:b0:3c2:1974:1686 with SMTP id a1-20020a631a01000000b003c219741686mr15736997pga.595.1652161984312;
        Mon, 09 May 2022 22:53:04 -0700 (PDT)
Received: from [10.86.119.184] ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id h27-20020a056a00001b00b0050dc76281d7sm9960882pfk.177.2022.05.09.22.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 22:53:03 -0700 (PDT)
Message-ID: <e003aa4e-0837-b819-390e-72da65e50c67@bytedance.com>
Date:   Tue, 10 May 2022 13:52:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [External] Re: [PATCH bpf-next] bpf: add
 bpf_map_lookup_percpu_elem for percpu map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20220507024840.42662-1-zhoufeng.zf@bytedance.com>
 <CAEf4BzZD5q2j229_gL_nDFse2v=k2Ea0nfguH+sOA2O1Nm5sQw@mail.gmail.com>
 <CAJD7tkbd8qA-4goUCVW6Tf0xGpj2OSBXncpWhrWFn5y010oBMw@mail.gmail.com>
 <d20aef2a-273a-3183-0923-bde9657d4418@bytedance.com>
 <CAADnVQL+Vq5y47J++VCppti1728w3U0maxg9d4SqAtArY+h1yg@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAADnVQL+Vq5y47J++VCppti1728w3U0maxg9d4SqAtArY+h1yg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/10 上午11:15, Alexei Starovoitov 写道:
> On Mon, May 9, 2022 at 7:41 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>> 在 2022/5/10 上午9:04, Yosry Ahmed 写道:
>>> On Mon, May 9, 2022 at 5:34 PM Andrii Nakryiko
>>> <andrii.nakryiko@gmail.com> wrote:
>>>> On Fri, May 6, 2022 at 7:49 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>>>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>>>
>>>>> Trace some functions, such as enqueue_task_fair, need to access the
>>>>> corresponding cpu, not the current cpu, and bpf_map_lookup_elem percpu map
>>>>> cannot do it. So add bpf_map_lookup_percpu_elem to accomplish it for
>>>>> percpu_array_map, percpu_hash_map, lru_percpu_hash_map.
>>>>>
>>>>> The implementation method is relatively simple, refer to the implementation
>>>>> method of map_lookup_elem of percpu map, increase the parameters of cpu, and
>>>>> obtain it according to the specified cpu.
>>>>>
>>>> I don't think it's safe in general to access per-cpu data from another
>>>> CPU. I'd suggest just having either a ARRAY_OF_MAPS or adding CPU ID
>>>> as part of the key, if you need such a custom access pattern.
>>> I actually just sent an RFC patch series containing a similar patch
>>> for the exact same purpose. There are instances in the kernel where
>>> per-cpu data is accessed from other cpus (e.g.
>>> mem_cgroup_css_rstat_flush()). I believe, like any other variable,
>>> percpu data can be safe or not safe to access, based on the access
>>> pattern. It is up to the user to coordinate accesses to the variable.
>>>
>>> For example, in my use case, one of the accessors only reads percpu
>>> values of different cpus, so it should be safe. If a user accesses
>>> percpu data of another cpu without guaranteeing safety, they corrupt
>>> their own data. I understand that the main purpose of percpu data is
>>> lockless (and therefore fast) access, but in some use cases the user
>>> may be able to safely (and locklessly) access the data concurrently.
>>>
>> Regarding data security, I think users need to consider before using it,
>> such
>> as hook enqueue_task_fair, the function itself takes the rq lock of the
>> corresponding cpu, there is no problem, and the kernel only provides a
>> method,
>> like bpf_per_cpu_ptr and bpf_this_cpu_ptr, data security needs to be
>> guaranteed
>> by users in different scenarios, such as using bpf_spin_lock.
> Right. The new helper looks useful and is safe.
> Please add a selftest and respin.


Ok, will do. Thanks.


