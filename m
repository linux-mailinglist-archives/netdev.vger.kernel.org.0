Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C0C5A8D3A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 07:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiIAFSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 01:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiIAFSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 01:18:36 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AE8109090;
        Wed, 31 Aug 2022 22:18:33 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id w18so12447375qki.8;
        Wed, 31 Aug 2022 22:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=uJN9pb7rprQ3Gc27MWDANcZXB9um/YbpQ3D1DbShuFk=;
        b=nHT54Ai4WgBBeRKUFudNPXLH7cFO1Nz1vcHiy5oF16LxVVazKqfyM/PLQzCA07EX3c
         6NF2qws42ylPRR2tgFaHjBk/wQYPpzcHvRglwEIExejYJbLcbgw/g3G9cPACfOeyLfRD
         kzyE0kUUUwOsrWhDrj/YBhJQLXU7bXBhhYpZXgYmBSccq5D9oMsEHuCYX8yFsrMUCZH1
         CIgo63wUTgvXVG6KetPqBKv4OiLOjTlttqBey63BlGb3AH8vVLfuQ2fnTiWxJSA//58Z
         +qSQ2Sn2c6tav2vZ8depzxZcqJW0oa5Dsf9pRjl/QDkKrwJDTuf9CdcOsdZUDCganwku
         gJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=uJN9pb7rprQ3Gc27MWDANcZXB9um/YbpQ3D1DbShuFk=;
        b=l9E2hN8pignmskhimYqTLwRuoUiS7HaLpiyDbCE2QT8K47TDGvpQ5Ob+o+CjbcF2F6
         P/77O989CspnSmNfaFUzfC9nXmiPx7GitZTlhgx+AkvthHe0Bpo4fiNU3dwexvM2HDGV
         jEhFlkR31dkcUgsziY24KglqXSTYTnwLsKnIUnbIT7SIc4X2XhcmCcXvdn7Kep2EfJ4o
         HerT3iNE6r3TyYlxhdTPzVpLCEspCgP9F75DJ3z4i6waz1Q2Gm31+85dHehYpghGeWYj
         Mu4QLMYJZDQ0gkxS/mrP2+ZHzu7dmN55K/JrFkdJ+VM/hGKzA5vQ+HzHy7jA4znRD49X
         jZuQ==
X-Gm-Message-State: ACgBeo2WK0vLeA2VGzEYf2xX+xu72dz3wdWJXtSL9tnFmI0bSEqoCoEd
        5AN4QJ5ggQMcwCOCqiuRQE28rEX/ptiGT7hltq4=
X-Google-Smtp-Source: AA6agR6AdC+MzLwcwV0Hf/oJm8mb970XPtArxOTOVRrtSe0m8u+jnpLpQIT35Moe9q3hqYsnHNqsKT3mXXsJ3MUaexI=
X-Received: by 2002:a05:620a:1786:b0:6bb:38b2:b1d7 with SMTP id
 ay6-20020a05620a178600b006bb38b2b1d7mr18289148qkb.510.1662009512690; Wed, 31
 Aug 2022 22:18:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc> <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc> <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
 <1cc40302-f006-31a7-b270-30813b8f4b67@iogearbox.net>
In-Reply-To: <1cc40302-f006-31a7-b270-30813b8f4b67@iogearbox.net>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 1 Sep 2022 08:18:20 +0300
Message-ID: <CAHsH6GtCgb1getXASkqzN75cNfm7_GOg8Mng5ZY37yK99XBVMQ@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 1, 2022 at 1:16 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/31/22 7:26 PM, Alexei Starovoitov wrote:
> > On Wed, Aug 31, 2022 at 8:53 AM Florian Westphal <fw@strlen.de> wrote:
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >>>> 1 and 2 have the upside that its easy to handle a 'file not found'
> >>>> error.
> >>>
> >>> I'm strongly against calling into bpf from the inner guts of nft.
> >>> Nack to all options discussed in this thread.
> >>> None of them make any sense.
> >>
> >> -v please.  I can just rework userspace to allow going via xt_bpf
> >> but its brain damaged.
> >
> > Right. xt_bpf was a dead end from the start.
> > It's time to deprecate it and remove it.
> >
> >> This helps gradually moving towards move epbf for those that
> >> still heavily rely on the classic forwarding path.
> >
> > No one is using it.
> > If it was, we would have seen at least one bug report over
> > all these years. We've seen none.
> >
> > tbh we had a fair share of wrong design decisions that look
> > very reasonable early on and turned out to be useless with
> > zero users.
> > BPF_PROG_TYPE_SCHED_ACT and BPF_PROG_TYPE_LWT*
> > are in this category. > All this code does is bit rot.
>
> +1
>
> > As a minimum we shouldn't step on the same rakes.
> > xt_ebpf would be the same dead code as xt_bpf.
>
> +1, and on top, the user experience will just be horrible. :(
>
> >> If you are open to BPF_PROG_TYPE_NETFILTER I can go that route
> >> as well, raw bpf program attachment via NF_HOOK and the bpf dispatcher,
> >> but it will take significantly longer to get there.
> >>
> >> It involves reviving
> >> https://lore.kernel.org/netfilter-devel/20211014121046.29329-1-fw@strlen.de/
> >
> > I missed it earlier. What is the end goal ?
> > Optimize nft run-time with on the fly generation of bpf byte code ?
>
> Or rather to provide a pendant to nft given existence of xt_bpf, and the
> latter will be removed at some point? (If so, can't we just deprecate the
> old xt_bpf?)

FWIW we've been using both lwt bpf and xt_bpf on our production workloads
for a few years now.

xt_bpf allows us to apply custom sophisticated policy logic at connection
establishment - which is not really possible (or efficient) using
iptables/nft constructs - without needing to reinvent all the facilities that
nf provides like connection tracking, ALGs, and simple filtering.

As for lwt bpf, We use it for load balancing towards collect md tunnels.
While this can be done at tc egress for unfragmented packets, the lwt out hook -
when used in tandem with nf fragment reassembly - provides a hooking point
where a bpf program can see reassembled packets and load balance based on
their internals.

Eyal.
