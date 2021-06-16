Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778833A9F27
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhFPPft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 11:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbhFPPfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 11:35:48 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EB9C06175F
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 08:33:41 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id 93so2161325qtc.10
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 08:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EY5S6UTnv01c5tJw2fF7YjNpF/veEdKB7tShfyrOncA=;
        b=EWJH91HRbn3GDnbXxwjiKTh11/b+5qwEyLs8PliXnIoU5ECucSzjDlFFunOSNSx+76
         GIi0LDhcUE0Mm5W+/ykk/YdbzJv4UkK+BfetlQXVEztHn4JZcUazNH8ss6xx8IVawegu
         452sM+FmvplI3Mz79ULNM3frhrGvHLE3hBLZVUWBUxmRQ36F7iGJsZoNPQaQ7YCAKgdH
         wBhK2qbCotbOZjLWeHnBzPaZk8n0Yz4cbzhOX3/XBajb6RJS6eIJSiM7hMuQnmbzZy7F
         5dQkP+1YeFmxdUluX0vqDvtlGZ1Q5tmw4/+UVHSvXKPrHECdGt6Jgq1JMrjTleegomQl
         Bcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EY5S6UTnv01c5tJw2fF7YjNpF/veEdKB7tShfyrOncA=;
        b=GBdAmWZBwoHUbcN1nPWPCwzPIOLPhIdt7b2eWz2NqbPWc0PfCeb9CFr+rY51+H7VzM
         6U3AY/DKGtUwgfmi8VPOOsXzv6F5Tvvx84vODtJZGuy9jTcqRhd4BYAZvxDAG59gtwRY
         C8Ac0pU9nnq3mKzJgVojC5e0X6175WJm+NPgRzGjRXMLCIJnosr9/iRvvSEJVjsGDYEc
         g3EvFCMGXWCWVGT/Ij/yyAIWkH8dZqvbqAYjLwAIxqexZ286u6235y4P7qgaCQHtQkrv
         7GHeXARrcXhYEg2odvKafH3rj0czBRvcP8b8pxG+sGJMQHJZ0ibFgNUynTqSsTERYHYt
         M7Gg==
X-Gm-Message-State: AOAM532O1e4q/SIME5fC3nIvD4dOoH+29PddIYw4xDCHyCigvrCxikc1
        +8J4eEuF6i8leNyeAd4EjIh5Rhbh+vltWqSJ
X-Google-Smtp-Source: ABdhPJwM2TW/6gBbZTWzLMChGlVmgwWggSa98o9CVfSnkYNeb+pBIOrVeU+DmWWTb9UoterAR4/h+g==
X-Received: by 2002:ac8:4b65:: with SMTP id g5mr474066qts.152.1623857620467;
        Wed, 16 Jun 2021 08:33:40 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-211.dsl.bell.ca. [184.148.47.211])
        by smtp.googlemail.com with ESMTPSA id y3sm1770103qkf.2.2021.06.16.08.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 08:33:39 -0700 (PDT)
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <CAM_iQpW7ZAz5rLAanMRg7R52Pn55N=puVkvoHcHF618wq8uA1g@mail.gmail.com>
 <877divs5py.fsf@toke.dk> <15cd0a9c-95a1-9766-fca1-4bf9d09e4100@iogearbox.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b44ee894-d94b-3afa-7bdb-e471b374d205@mojatatu.com>
Date:   Wed, 16 Jun 2021 11:33:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <15cd0a9c-95a1-9766-fca1-4bf9d09e4100@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-15 7:44 p.m., Daniel Borkmann wrote:
> On 6/15/21 1:54 PM, Toke Høiland-Jørgensen wrote:
>> Cong Wang <xiyou.wangcong@gmail.com> writes:
> [...]


> 
> Just to keep on brainstorming here, I wanted to bring back Alexei's 
> earlier quote:
> 
>    > I think it makes sense to create these objects as part of 
> establishing bpf_link.
>    > ingress qdisc is a fake qdisc anyway.
>    > If we could go back in time I would argue that its existence doesn't
>    > need to be shown in iproute2. It's an object that serves no purpose
>    > other than attaching filters to it. It doesn't do any queuing unlike
>    > real qdiscs.
>    > It's an artifact of old choices. Old doesn't mean good.
>    > The kernel is full of such quirks and oddities. New api-s shouldn't
>    > blindly follow them.
>    > tc qdisc add dev eth0 clsact
>    > is a useless command with nop effect.
> 

I am not sure what Alexei's statement about old vs good was getting at.
You have to have  hooks/locations to stick things. Does it matter what
you call that hook?

> The whole bpf_link in this context feels somewhat awkward because both 
> are two
> different worlds, one accessible via netlink with its own lifetime etc, 
> the other
> one tied to fds and bpf syscall. Back in the days we did the cls_bpf 
> integration
> since it felt the most natural at that time and it had support for both 
> the ingress
> and egress side, along with the direct action support which was added 
> later to have
> a proper fast path for BPF. One thing that I personally never liked is 
> that later
> on tc sadly became a complex, quirky dumping ground for all the nic hw 
> offloads (I
> guess mainly driven from ovs side) for which I have a hard time 
> convincing myself
> that this is used at scale in production. Stuff like af699626ee26 just 
> to pick one
> which annoyingly also adds to the fast path given distros will just 
> compile in most
> of these things (like NET_TC_SKB_EXT)... what if such bpf_link object is 
> not tied
> at all to cls_bpf or cls_act qdisc, and instead would implement the 
> tcf_classify_
> {egress,ingress}() as-is in that sense, similar like the bpf_lsm hooks. 


The choice is between generic architecture and appliance
only-what-you-need code (via ebpf).
Dont disagree that at times patches go in at the expense of the kernel
datapath complexity or cost. Unfortunately sometimes this is because
theres no sufficient review time - but thats a different topic.
We try to impose a rule which states that any hardware offload has
to have a kernel/software twin. Often that helps contain things.


> Meaning,
> you could run existing tc BPF prog without any modifications and without 
> additional
> extra overhead (no need to walk the clsact qdisc and then again into the 
> cls_bpf
> one). These tc BPF programs would be managed only from bpf() via tc 
> bpf_link api,
> and are otherwise not bothering to classic tc command (though they could 
> be dumped
> there as well for sake of visibility, though bpftool would be fitting 
> too). However,
> if there is something attached from classic tc side, it would also go 
> into the old
> style tcf_classify_ingress() implementation and walk whatever is there 
> so that nothing
> existing breaks (same as when no bpf_link would be present so that there 
> is no extra
> overhead). This would also allow for a migration path of multi prog from 
> cls_bpf to
> this new implementation. Details still tbd, but I would much rather like 
> such an
> approach than the current discussed one, and it would also fit better 
> given we don't
> run into this current mismatch of both worlds.
>

The danger is totally divorcing from tc when you have speacial
cases just for ebpf/tc i.e this is no different than what the
hardware offload making you unhappy. The ability to use existing
tools (user space tc in this case) to inter-work on both is
very useful.


 From the discussion on the control aspect with Kartikeya i
understood that we need some "transient state" which needs to get
created and stored somewhere before being applied to tc (example
creating the filters first and all necessary artificats then calling
internally to cls api).
Seems to me that the "transient state" belongs to bpf. And i understood
Kartikeya this was his design intent as well (which seems sane to me).


cheers,
jamal
