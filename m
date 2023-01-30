Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2882680500
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 05:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbjA3EaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 23:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjA3EaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 23:30:21 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DD71E1C6
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 20:30:20 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso9896327pjb.4
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 20:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9op3L7LuUTNtIP2E9g8w0ujjjfEoF+FfOQITEoUg7as=;
        b=Wd/3EtW3kYNEWgHqGFRj2u8DSLSUrYqcsZnI0gOF6u6PR98C+Ssjomzemgr3Ak7+Pb
         DSCouop5LBY1U++pG/ScyMVaOFnpXVCqlBnva55jQ9c8vmEDHpLEAkgh2pBCyKE89stt
         ZG3OvtnehmP/LuXlz2Po8Dx0L/6yrBNWDkNJDXjoFLKLXXNe2kFlE8ERWtxbsAOitET6
         o0912sO3tBn4I+JQu8GpQ/y1PWjozBevyyD/eb/4NrT3xXgTo+w4jJxCmrVEm2mMqgyp
         EjtnOaQ1eiEHVR4Jby1X/jVx5lb1mVQJRqgR6SoOE6cw74sa82X9s7dB2xmcfEWZdFJQ
         IIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9op3L7LuUTNtIP2E9g8w0ujjjfEoF+FfOQITEoUg7as=;
        b=Qjnduth8fvIvnjrZNGB8xuOqkZrRYBWxD3fOl0spFkCzJirsqssLioEYGy7O27Iw7s
         /GVCRg+ra3ZaCd8I9adnSr+uVrVvQCsFOKpBcP30bHoiCZRGs83yBw3cj8vXFB1wJ2kr
         W9hc9wt5KGCx0CTvKSAd/mLMnY4/ULnnXPYfVbeWLEKScUzN/kK6DD+G0DVr1X3ocNzv
         WonMR95jyFSgjHt1PSdbyndKUkiQQNkYr+wQl4xf/wi0ZMwR63dltONcWJSyhnwP96Mi
         MqR7JuZGu8TNktDiP19hv3ivmXDWHDz8Gg+eGvWaLhuPQPAcE2Wz1N+ph6n0Ur3e8mUT
         3/Yw==
X-Gm-Message-State: AO0yUKXJRvQctWNw+S4kF+eaMMiKqlfEZXjdY4hodqoWz/818Im3I0IV
        Cst41d+Q6rVEN9k08aaDUcc=
X-Google-Smtp-Source: AK7set+IaGM/HkvN9UW1yXNPSLI1inTyVkB3N5TK8vTI+Sghped8a93Z/1qaTdgmVZyGC4ArDD+W6w==
X-Received: by 2002:a17:90b:4b81:b0:22c:1b8c:f49b with SMTP id lr1-20020a17090b4b8100b0022c1b8cf49bmr8344339pjb.35.1675053019744;
        Sun, 29 Jan 2023 20:30:19 -0800 (PST)
Received: from localhost ([98.97.45.87])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902900900b0018999a3dd7esm6643109plp.28.2023.01.29.20.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 20:30:19 -0800 (PST)
Date:   Sun, 29 Jan 2023 20:30:17 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Message-ID: <63d747d91add9_3367c208f1@john.notmuch>
In-Reply-To: <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
References: <20230124170346.316866-1-jhs@mojatatu.com>
 <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho>
 <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim wrote:
> On Sun, Jan 29, 2023 at 12:39 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Willem de Bruijn wrote:
> > > On Sat, Jan 28, 2023 at 10:10 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > > >
> >
> > [...]
> >
> >
> > Also there already exists a P4 backend that targets BPF.
> >
> >  https://github.com/p4lang/p4c
> 
> There's also one based on rust - does that mean we should rewrite our
> code in rust?
> Joking aside - rust was a suggestion made at a talk i did. I ended up
> adding a slide for the next talk which read:
> 
> Title: So... how is this better than KDE?
>   Attributed to Rusty Russell
>      Who attributes it to Cort Dougan
>       s/KDE/[rust/ebpf/dpdk/vpp/ovs]/g
> 
> We have very specific goals - of which the most important is met by
> what works today and we are reusing that.

OK, I may have missed your goals I read the cover letter and merely
scanned the patches. But, seeing we've chatted about this before
let me put my critique here.

P4TC as a software datapath:

1. We can already run P4 in software with P4C which compiles into an
   existing BPF implementations, nothing new needed. If we object
   to p4c implementation there are others (VMWare has one for XDP)
   or feel free to write any other DSL or abstraction over BPF.

2. 'tc' layer is not going to be as fast as XDP so without an XDP
   implementation we can't get best possible implementation.

3. Happy to admit I don't have data, but I'm not convinced a match
   action pipeline is an ideal implementation for software. It is
   done specifically in HW to facilitate CAMs/TCAMs and other special
   logic blocks that do not map well to general purpose CPU. BPF or
   other insn are better abstraction for software.

So I struggle to find upside as a purely software implementation.
If you took an XDP P4 backend and then had this implementation
showing performance or some other vector where a XDP implementation
underperformed that would be interesting. Then either we would have
good reason to try another datapath or 

P4TC as a hardware datapath:

1. We don't have a hardware/driver implementation to review so its
   difficult to even judge if this is a good idea or not.

2. I imagine most hardware can not create TCAMs/CAMs out of
   nothing. So there is a hard problem that I believe is not
   addressed here around how user knows their software blob
   can ever be offloaded at all. How you move to new hw and
   the blob can continue to work so and an so forth.

3. FPGA P4 implementations as far as I recall can use P4 to build
   the pipeline up front. But, once its built its not like you
   would (re)build it or (re)configure it on the fly. But the workflow
   doesn't align with how I understand these patches.

4. Has any vendor with a linux driver (maybe not even in kernel yet)
   open sourced anything that resembles a P4 pipeline? Without
   this its again hard to understand what is possible and what
   vendors will let users do.

P4TC as SW/HW running same P4:

1. This doesn't need to be done in kernel. If one compiler runs
   P4 into XDP or TC-BPF that is good and another compiler runs
   it into hw specific backend. This satisifies having both
   software and hardware implementation.

Extra commentary: I agree we've been chatting about this for a long
time but until some vendor (Intel?) will OSS and support a linux
driver and hardware with open programmable parser and MAT. I'm not
sure how we get P4 for Linux users. Does it exist and I missed it?

Thanks,
John

> 
> cheers,
> jamal
> 
> > So as a SW object we can just do the P4 compilation step in user
> > space and run it in BPF as suggested. Then for hw offload we really
> > would need to see some hardware to have any concrete ideas on how
> > to make it work.
> >
> 
> 
> > Also P4 defines a runtime API so would be good to see how all that
> > works with any proposed offload.

Yep agree with your other comment not really important can be built
on top of Netlink or BPF today.
