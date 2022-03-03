Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5836E4CC3E1
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbiCCRc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235479AbiCCRcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:32:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B955019F457
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646328686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PD/UAjee6iu7MwOt5iw3w8GxURRgj+hEeLghI5ezEhk=;
        b=MKeOFCRZSTdD3Qd9HrIe/8b5IMN8E8bb6FjK7ivXuz0eHRtEQdisiX4oPqOhUOsZX6Uvnr
        IHQEDuwPrs4OnCd9YjXC/pZsj2xwEPEL80iuQDPCVkrlNAlt4pAOUufIM7ZJzpU95Mwt1I
        ZWNtGyOdIPLBwp3ddDo8ilgUDsFFgVM=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-Ny87tnQ9N0W0TNphPnAA9Q-1; Thu, 03 Mar 2022 12:31:25 -0500
X-MC-Unique: Ny87tnQ9N0W0TNphPnAA9Q-1
Received: by mail-lf1-f70.google.com with SMTP id z24-20020a056512371800b0043ea4caa07cso1804878lfr.17
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 09:31:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=PD/UAjee6iu7MwOt5iw3w8GxURRgj+hEeLghI5ezEhk=;
        b=1Zn4Aup8umUFVBVGh5M2LS/QfIVyfHiCL7Wv3JvKmILNfHCbU1td/QJbbp3tpC6gHL
         nzvFzpVrCem5tGB+fcFWxHZVuaaFgIjYXXdFs4BjnGM/HzyIa68O7LBHpECy95c8bbzV
         NEksHuFiEJ0xc1HDFVk0wk+TAVAA+XpPNaE0czAnw5ls1MozS+sTxgRN2ewOfDArGS5F
         Dr9/Ncjk4PJvyo88btfX8NV7CB1cIQy+9ZZF0QDRRO1qEdFS7qiy9o8b7LXAGC5Hy09J
         rSOosLYiwzjTvkIGJPBCnelCY5ssptJ8884k1f2DORvzDYKtuL8FbFNp+4pvKcg877a+
         /OeA==
X-Gm-Message-State: AOAM533mDyUKEnE8AHKiBfvea11GcdslyDVW4h4UnzTLH0kMVkzXaKzK
        LHh8OkYBFnEpE+cYCW61t2q9akY0FV2m/xzIElkHuHRqqb66+2KFGoDdUBWJDqdIKzYQfITROlf
        CIFLL537uneSDiFvV
X-Received: by 2002:a05:651c:982:b0:244:c35d:b1ef with SMTP id b2-20020a05651c098200b00244c35db1efmr23622370ljq.243.1646328683812;
        Thu, 03 Mar 2022 09:31:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/Gh7tK0NZRXBQYXef7sfppQ2gPtfiE4IrUcAU3T88og4oObHpepdwCcLciftgBpuziddT9A==
X-Received: by 2002:a05:651c:982:b0:244:c35d:b1ef with SMTP id b2-20020a05651c098200b00244c35db1efmr23622347ljq.243.1646328683552;
        Thu, 03 Mar 2022 09:31:23 -0800 (PST)
Received: from [10.30.0.98] (195-67-91-243.customer.telia.com. [195.67.91.243])
        by smtp.gmail.com with ESMTPSA id g10-20020a19ac0a000000b00441e497867fsm539781lfc.93.2022.03.03.09.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 09:31:22 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d6621a7b-12ad-1e3d-848f-fff576be2dfd@redhat.com>
Date:   Thu, 3 Mar 2022 18:31:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <YiC0BwndXiwxGDNz@linutronix.de> <875yovdtm4.fsf@toke.dk>
 <YiDM0WRlWuM2jjNJ@linutronix.de>
In-Reply-To: <YiDM0WRlWuM2jjNJ@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/03/2022 15.12, Sebastian Andrzej Siewior wrote:
> On 2022-03-03 14:59:47 [+0100], Toke Høiland-Jørgensen wrote:
>> Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
>>
>>> Since the commit mentioned below __xdp_reg_mem_model() can return a NULL
>>> pointer. This pointer is dereferenced in trace_mem_connect() which leads
>>> to segfault. It can be reproduced with enabled trace events during ifup.
>>>
>>> Only assign the arguments in the trace-event macro if `xa' is set.
>>> Otherwise set the parameters to 0.
>>>
>>> Fixes: 4a48ef70b93b8 ("xdp: Allow registering memory model without rxq reference")
>>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>
>> Hmm, so before the commit you mention, the tracepoint wasn't triggered
>> at all in the code path that now sets xdp_alloc is NULL. So I'm
>> wondering if we should just do the same here? Is the trace event useful
>> in all cases?
> 
> Correct. It says:
> |              ip-1230    [003] .....     3.053473: mem_connect: mem_id=0 mem_type=PAGE_SHARED allocator=0000000000000000 ifindex=2
> 
>> Alternatively, if we keep it, I think the mem.id and mem.type should be
>> available from rxq->mem, right?
> 
> Yes, if these are the same things. In my case they are also 0:
> 
> |              ip-1245    [000] .....     3.045684: mem_connect: mem_id=0 mem_type=PAGE_SHARED allocator=0000000000000000 ifindex=2
> |        ifconfig-1332    [003] .....    21.030879: mem_connect: mem_id=0 mem_type=PAGE_SHARED allocator=0000000000000000 ifindex=3
> 
> So depends on what makes sense that tp can be skipped for xa == NULL or
> remain with
>                 __entry->mem_id         = rxq->mem.id;
>                 __entry->mem_type       = rxq->mem.type;
> 	       __entry->allocator      = xa ? xa->allocator : NULL;
> 
> if it makes sense.
> 

I have two bpftrace scripts [1] and [2] that use this tracepoint.
It is scripts to help driver developers detect memory leaks when using 
page_pool from their drivers.

I'm a little pressured on time, so I've not evaluated if your change 
makes sense.
In the scripts I do use both mem.id and mem.type.


[1] 
https://github.com/xdp-project/xdp-project/blob/master/areas/mem/bpftrace/xdp_mem_track01.bt

[2] 
https://github.com/xdp-project/xdp-project/blob/master/areas/mem/bpftrace/xdp_mem_track02.bt

--Jesper

