Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9D1432C1F
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhJSDQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhJSDQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 23:16:48 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4C4C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 20:14:36 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q5so18058922pgr.7
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 20:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=aM3Uu5Y3y5Vgada2bdPWHaQ5RiDRtrSzHIKW6V50leE=;
        b=eeY8dNlntVANS/YumjJeKJj3EiisMkt7ORQbYNbiJrNn2j5RLJeDnnqNZ2xjLg0/gC
         WEoMCb10GIAEaLRe295tQhPF7lQdErJd0ZUN1Y87RkNAJr5dxPQiBNvbnl9xqRNa1l/N
         9uaNftBK6wsiTb8nqVTwsysQRaVJNZWJ9poMTH2jGENqTUzyzNyLzCz4QvZktp4W1pqS
         0YWYAYRbtuawAGUMBaZMDuP9Ux1hrRO709/zM3eS6TINDoTI2bje3gw87p/0lDtJlL2U
         TszjhnOucLEe1Ld2ilVcsvghIVrlosxHrPkYyF/2e3c+Rwbb5ZJTvQ58SAt3Sqsn/oH/
         XAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aM3Uu5Y3y5Vgada2bdPWHaQ5RiDRtrSzHIKW6V50leE=;
        b=pmZM2+am7yvD6R7gDEGQStqENSV7a72Mt5pHOl68TDuAgxIgUt7joijCE6YPsDAg51
         DsKEuEO4W+x6Fwa/nuFiIgn18BzSxOqBqL+akVgang+p7b2hMB1+AjRQNgCENGDSSzFN
         vEiexBlrys1maYZMErst0Go2eSGlbBX9FyWSMIviQGSuIakjnfwFjlpKGdyxAUwEsHqG
         a2YMj9w5AP6LpJfwFF7YrvDOwxBWWCrtcnJHer2tec7q6GZZ+haN0UI9QXBOQXpY6C0S
         QnEUOjP0kOwzjRrMXXH6GgzOLo0qlYtugpB1njEFjk6ys5ptpSjG4PGYq/MHGFGErmTi
         Guhg==
X-Gm-Message-State: AOAM530Ja7wRccHPllL88ntw8pfK9L2UmPajBwinahrYPVYpCePdD7uv
        2zBHUIrdzyV+pAXIFVf8v6SS+g==
X-Google-Smtp-Source: ABdhPJwfYtqxpPN0L68LDtEG9zZo+GUWjRoapYQgmNZQnF4PdyJWOOIUoIKa0aug2G03DckNnuqyYA==
X-Received: by 2002:a05:6a00:198c:b0:44d:ce87:d164 with SMTP id d12-20020a056a00198c00b0044dce87d164mr10603571pfl.64.1634613276110;
        Mon, 18 Oct 2021 20:14:36 -0700 (PDT)
Received: from [10.70.253.117] ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id gm14sm791619pjb.40.2021.10.18.20.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 20:14:35 -0700 (PDT)
Message-ID: <b8f6c2f6-1b07-9306-46da-5ab170a125f9@bytedance.com>
Date:   Tue, 19 Oct 2021 11:14:30 +0800
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
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <CAADnVQKG5=qVSjZGzHEc0ijwiYABVCU1uc8vOQ-ZLibhpW--Hg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2021/10/19 上午9:57, Alexei Starovoitov 写道:
> On Sun, Oct 17, 2021 at 10:49 PM Chengming Zhou
> <zhouchengming@bytedance.com> wrote:
>>
>> 在 2021/10/16 上午3:58, Alexei Starovoitov 写道:
>>> On Fri, Oct 15, 2021 at 11:04 AM Chengming Zhou
>>> <zhouchengming@bytedance.com> wrote:
>>>>
>>>> We only use count for kmalloc hashtab not for prealloc hashtab, because
>>>> __pcpu_freelist_pop() return NULL when no more elem in pcpu freelist.
>>>>
>>>> But the problem is that __pcpu_freelist_pop() will traverse all CPUs and
>>>> spin_lock for all CPUs to find there is no more elem at last.
>>>>
>>>> We encountered bad case on big system with 96 CPUs that alloc_htab_elem()
>>>> would last for 1ms. This patch use count for prealloc hashtab too,
>>>> avoid traverse and spin_lock for all CPUs in this case.
>>>>
>>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>>>
>>> It's not clear from the commit log what you're solving.
>>> The atomic inc/dec in critical path of prealloc maps hurts performance.
>>> That's why it's not used.
>>>
>> Thanks for the explanation, what I'm solving is when hash table hasn't free
>> elements, we don't need to call __pcpu_freelist_pop() to traverse and
>> spin_lock all CPUs. The ftrace output of this bad case is below:
>>
>>  50)               |  htab_map_update_elem() {
>>  50)   0.329 us    |    _raw_spin_lock_irqsave();
>>  50)   0.063 us    |    lookup_elem_raw();
>>  50)               |    alloc_htab_elem() {
>>  50)               |      pcpu_freelist_pop() {
>>  50)   0.209 us    |        _raw_spin_lock();
>>  50)   0.264 us    |        _raw_spin_lock();
> 
> This is LRU map. Not hash map.
> It will grab spin_locks of other cpus
> only if all previous cpus don't have free elements.
> Most likely your map is actually full and doesn't have any free elems.
> Since it's an lru it will force free an elem eventually.
> 

Maybe I missed something, the map_update_elem function of LRU map is
htab_lru_map_update_elem() and the htab_map_update_elem() above is the
map_update_elem function of hash map.
Because of the implementation of percpu freelist used in hash map, it
will spin_lock all other CPUs when there is no free elements.

Thanks.

