Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2293637EFAF
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhELXWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 19:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444026AbhELWxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 18:53:20 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C91C0610EA
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 15:43:56 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id a2so23898418qkh.11
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 15:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NbyJ52lo/KmaI1lmzIR9nAP6ZETday/C62CbdVi1cY4=;
        b=nZ2WySbdboM/kcmqJL4SqhJI1Rym8v3DmhYoAmIIPvqQcimNJQNlPVYwB6XOCkdykT
         OLU9Kx3G/XBshnMbUryhNJ9boStmuwIU3/h4/6KsfR8ZeKL1Rp7EoY2gmy7F/6y1QiF4
         +VG81yKBAjfMSW38/pljaVk8hk6tHyqaZn4ZYxK+fxzW/wY3GfyTJNOkEo4jScx/56fE
         yPHfvWqrDioe04B+djZsqiw+zVURjx5aIJ/hL061UMXIFFnnuXbWPzqOy8CdBptEX20y
         zZR7URSrpGQO4RGpoK6ZUk4ccCa6aOHs9cvGXTJvfOdJ34vczdGMBYZKEaur//PCdLNG
         u2YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NbyJ52lo/KmaI1lmzIR9nAP6ZETday/C62CbdVi1cY4=;
        b=UX7wJN4De6qTpbecXfspTzkgt8vo88YXGlQ9Yq6WoCmbEJvH+2ug2MuTOz2IdIu5+E
         IREouVyyILrwndsbuPqsUhXpkI/PO9t+O9t0BwKlXLxkO4HHi9Vgbk5TG/p8Yn2YjdQD
         ALAlO5H1wNuv0UJisx3M2Uu10oiFKTZF3s1G3YsAv4KnwFZKjmJcqDuv/rWgMGXuXvy/
         GCH6MysVcgbMkSrxQ9H4Qt+GhS7+QA0kABXCVO9Mmr2FefF9Qyxyzrus+kZkE0OuSd49
         hRJf36AOqu3EjwrTkfTdz4K+uohZg+zLaHKPRUuPnQvyVItTA4Hxwzk15P9MfzqpKDjM
         Y5IQ==
X-Gm-Message-State: AOAM530xU435rEK3FYNZ6hQuyokJE0YjqAQIgjSW9H8erUNJrm2zAXd1
        x84ql63J0mGtdF2JT7/PcLn5Lg==
X-Google-Smtp-Source: ABdhPJy5vmsx5YHZHlI2wZ/cyOKopA5+3pAS/nbVCzQLLdOqqQxL6Rzh1aHKLGo61cz4ESaeMapnFA==
X-Received: by 2002:a05:620a:70c:: with SMTP id 12mr35408930qkc.377.1620859436034;
        Wed, 12 May 2021 15:43:56 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-25-174-95-97-70.dsl.bell.ca. [174.95.97.70])
        by smtp.googlemail.com with ESMTPSA id x28sm1181491qtm.71.2021.05.12.15.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 15:43:55 -0700 (PDT)
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Joe Stringer <joe@cilium.io>, Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp>
 <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp>
 <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
 <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
 <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com>
 <CAOftzPh0cj_XRES8mrNWnyKFZDLpRez09NAofmu1F1JAZf43Cw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ac30da98-97cd-c105-def8-972a8ec573d6@mojatatu.com>
Date:   Wed, 12 May 2021 18:43:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAOftzPh0cj_XRES8mrNWnyKFZDLpRez09NAofmu1F1JAZf43Cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-11 1:05 a.m., Joe Stringer wrote:
> Hi Cong,
> 

>> and let me quote the original report here:
>>
>> "The current implementation (as of v1.2) for managing the contents of
>> the datapath connection tracking map leaves something to be desired:
>> Once per minute, the userspace cilium-agent makes a series of calls to
>> the bpf() syscall to fetch all of the entries in the map to determine
>> whether they should be deleted. For each entry in the map, 2-3 calls
>> must be made: One to fetch the next key, one to fetch the value, and
>> perhaps one to delete the entry. The maximum size of the map is 1
>> million entries, and if the current count approaches this size then
>> the garbage collection goroutine may spend a significant number of CPU
>> cycles iterating and deleting elements from the conntrack map."
> 
> I'm also curious to hear more details as I haven't seen any recent
> discussion in the common Cilium community channels (GitHub / Slack)
> around deficiencies in the conntrack garbage collection since we
> addressed the LRU issues upstream and switched back to LRU maps.

For our use case we cant use LRU. We need to account for every entry i.e
we dont want it to be gc without our consent. i.e we want to control
the GC. Your PR was pointing to LRU deleting some flow entries for TCP
which were just idling for example.


> There's an update to the report quoted from the same link above:
> 
> "In recent releases, we've moved back to LRU for management of the CT
> maps so the core problem is not as bad; furthermore we have
> implemented a backoff for GC depending on the size and number of
> entries in the conntrack table, so that in active environments the
> userspace GC is frequent enough to prevent issues but in relatively
> passive environments the userspace GC is only rarely run (to minimize
> CPU impact)."
> 
> By "core problem is not as bad", I would have been referring to the
> way that failing to garbage collect hashtables in a timely manner can
> lead to rejecting new connections due to lack of available map space.
> Switching back to LRU mitigated this concern. With a reduced frequency
> of running the garbage collection logic, the CPU impact is lower as
> well. I don't think we've explored batched map ops for this use case
> yet either, which would already serve to improve the CPU usage
> situation without extending the kernel.
> 

Will run some tests tomorrow to see the effect of batching vs nobatch
and capture cost of syscalls and cpu.

Note: even then, it is not a good general solution. Our entries can
go as high as 16M.
Our workflow is: 1) every 1-5 seconds you dump, 2) process for
what needs to be deleted etc, then do updates (another 1-3 seconds
worth of time). There is a point, depending on number of entries,
where there your time cost of processing exceeds your polling period.
The likelihood of entry state loss is high for even 1/2 sec loss
of sync.

> The main outstanding issue I'm aware of is that we will often have a
> 1:1 mapping of entries in the CT map and the NAT map, and ideally we'd
> like them to have tied fates but currently we have no mechanism to do
> this with LRU. When LRU eviction occurs, the entries can get out of
> sync until the next GC.

Yes, this ties as well to our use case (not NAT for us, but semantically
similar challenge). It goes the other way too, if userspace decides
to adjust your NAT table you need to purge related entries from the
cache.



> I could imagine timers helping with this if we

Yes, timers would solve this.

I am not even arguing that we need timers to solve these issues. I am
just saying it seems timers are just fundamental infra that is needed
even outside the scope of this.

cheers,
jamal
