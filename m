Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8E8680A85
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 11:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbjA3KNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 05:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbjA3KNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 05:13:16 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E333012F0D
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 02:13:13 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id o18so1043717wrj.3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 02:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NSrRoN8Sn+noj/edYkHOJ2ZvIJ4gyBflrK9vY78XuaM=;
        b=ARChxwy9t7uXKRcGolrMAe3CXFyqzVQIL4nTvs/ATf3JpxSPV0fBQOqYoBbdDGyNbU
         HUWtyM+WxAPrWBjvBelLakn39GK5ark2Gl2viFYRAeeEZzIPvEQ4h/b24nxGkwcfauWA
         WpT7GreJKY2lmk6PhZHyfGWOF3KDiFvJbFVKHTexWmRE30cDzjX1HV/MefxdPrOsMS6j
         sepVWvu+2JTrvRdIQyPfLm68buGDVKTfAWh1yRkutYmHA1fDebh0slma7xMIz0L4WBE1
         oTJdjOGdWPdbeC5WCBXvCj4nrnQOOTYlkZQjIzD048c8qV4yjXLfzwAJt4CQQZOHq7tr
         xDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSrRoN8Sn+noj/edYkHOJ2ZvIJ4gyBflrK9vY78XuaM=;
        b=kTmC3yBPBpjlJRjFnVEAAuMUze/ek6VDh9mgbGV7fTRs/5i2mKHlhXhMAg2+A5vc46
         xBemE9cwAF2OChxnakynJuPGPg3vcwDBFmQgl+ID0UEXFH0eUvN2kfvPJfQzI+JuO5Ml
         cKxrN+uQxTkJLv4pVabkP93BQl7cmh1kvRjANHrAsbSZyXlQogM1zfLuEkIYH3jsgF8+
         IRgPW2nosj0cHlsaFNMALhe7XgIM6nCZWpqOfyH9PEhpI1XV+9ERl+hcK74kJgx0m4Iq
         Ci0p8IJ4iQWZxLgvWu0vcQO2vx4KRu+9kCKTP8Sh3CLmWYTgZoUEa/hMaJloe6XMsP3E
         I0pA==
X-Gm-Message-State: AO0yUKXdAoz81EXW1nR25FINWYhj1BNbbo2h9+VtDM5t4beYqkCzNcNu
        2ja+ndFiNEcvKGURoCChyNBnS45LzW7cHJ96ib0=
X-Google-Smtp-Source: AK7set9HvMG6tQgawXsM7nIycn6cSjuixufB3oM3Ps+raAtIzPLnm+sZPJCywpDgJCsPnXazMYn/cg==
X-Received: by 2002:a05:6000:1805:b0:2bf:af86:ea05 with SMTP id m5-20020a056000180500b002bfaf86ea05mr20381929wrh.39.1675073592369;
        Mon, 30 Jan 2023 02:13:12 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z12-20020adff74c000000b00291f1a5ced6sm11447565wrp.53.2023.01.30.02.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 02:13:11 -0800 (PST)
Date:   Mon, 30 Jan 2023 11:13:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Message-ID: <Y9eYNsklxkm8CkyP@nanopsycho>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63d747d91add9_3367c208f1@john.notmuch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 30, 2023 at 05:30:17AM CET, john.fastabend@gmail.com wrote:
>Jamal Hadi Salim wrote:
>> On Sun, Jan 29, 2023 at 12:39 AM John Fastabend
>> <john.fastabend@gmail.com> wrote:
>> >
>> > Willem de Bruijn wrote:
>> > > On Sat, Jan 28, 2023 at 10:10 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> > > >
>> >
>> > [...]
>> >
>> >
>> > Also there already exists a P4 backend that targets BPF.
>> >
>> >  https://github.com/p4lang/p4c
>> 
>> There's also one based on rust - does that mean we should rewrite our
>> code in rust?
>> Joking aside - rust was a suggestion made at a talk i did. I ended up
>> adding a slide for the next talk which read:
>> 
>> Title: So... how is this better than KDE?
>>   Attributed to Rusty Russell
>>      Who attributes it to Cort Dougan
>>       s/KDE/[rust/ebpf/dpdk/vpp/ovs]/g
>> 
>> We have very specific goals - of which the most important is met by
>> what works today and we are reusing that.
>
>OK, I may have missed your goals I read the cover letter and merely
>scanned the patches. But, seeing we've chatted about this before
>let me put my critique here.
>
>P4TC as a software datapath:
>
>1. We can already run P4 in software with P4C which compiles into an
>   existing BPF implementations, nothing new needed. If we object
>   to p4c implementation there are others (VMWare has one for XDP)
>   or feel free to write any other DSL or abstraction over BPF.
>
>2. 'tc' layer is not going to be as fast as XDP so without an XDP
>   implementation we can't get best possible implementation.
>
>3. Happy to admit I don't have data, but I'm not convinced a match
>   action pipeline is an ideal implementation for software. It is
>   done specifically in HW to facilitate CAMs/TCAMs and other special
>   logic blocks that do not map well to general purpose CPU. BPF or
>   other insn are better abstraction for software.
>
>So I struggle to find upside as a purely software implementation.
>If you took an XDP P4 backend and then had this implementation
>showing performance or some other vector where a XDP implementation
>underperformed that would be interesting. Then either we would have
>good reason to try another datapath or 
>
>P4TC as a hardware datapath:
>
>1. We don't have a hardware/driver implementation to review so its
>   difficult to even judge if this is a good idea or not.
>
>2. I imagine most hardware can not create TCAMs/CAMs out of
>   nothing. So there is a hard problem that I believe is not
>   addressed here around how user knows their software blob
>   can ever be offloaded at all. How you move to new hw and
>   the blob can continue to work so and an so forth.
>
>3. FPGA P4 implementations as far as I recall can use P4 to build
>   the pipeline up front. But, once its built its not like you
>   would (re)build it or (re)configure it on the fly. But the workflow
>   doesn't align with how I understand these patches.
>
>4. Has any vendor with a linux driver (maybe not even in kernel yet)
>   open sourced anything that resembles a P4 pipeline? Without
>   this its again hard to understand what is possible and what
>   vendors will let users do.
>
>P4TC as SW/HW running same P4:
>
>1. This doesn't need to be done in kernel. If one compiler runs
>   P4 into XDP or TC-BPF that is good and another compiler runs
>   it into hw specific backend. This satisifies having both
>   software and hardware implementation.
>
>Extra commentary: I agree we've been chatting about this for a long
>time but until some vendor (Intel?) will OSS and support a linux
>driver and hardware with open programmable parser and MAT. I'm not
>sure how we get P4 for Linux users. Does it exist and I missed it?


John, I think that your summary is quite accurate. Regarding SW
implementation, I have to admit I also fail to see motivation to have P4
specific datapath instead of having XDP/eBPF one, that could run P4
compiled program. The only motivation would be that if somehow helps to
offload to HW. But can it?

Regarding HW implementation. I believe that every HW implementation is
very specific and to find some common intermediate kernel uAPI is
probably not possible (correct me if I'm wrong, that that is the
impression I'm getting from all parties). Then the only option is to
allow userspace to insert HW-speficic blob that is an output of
per-vendor P4 compilator.

Now is this blob uAPI channel possible to be introduced? How it should
look like? How to enforce limitations so it is not exploited for other
purposes as a kernel bypass?



>
>Thanks,
>John
>
>> 
>> cheers,
>> jamal
>> 
>> > So as a SW object we can just do the P4 compilation step in user
>> > space and run it in BPF as suggested. Then for hw offload we really
>> > would need to see some hardware to have any concrete ideas on how
>> > to make it work.
>> >
>> 
>> 
>> > Also P4 defines a runtime API so would be good to see how all that
>> > works with any proposed offload.
>
>Yep agree with your other comment not really important can be built
>on top of Netlink or BPF today.
