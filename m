Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DCE5AB6E2
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 18:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbiIBQxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 12:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiIBQxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 12:53:23 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E5B10951D;
        Fri,  2 Sep 2022 09:53:22 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id r4so3455723edi.8;
        Fri, 02 Sep 2022 09:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Hgnkg36DqLyHXWGaLke37obXxrGvUZVl10tSfHjo3U4=;
        b=LXLy/fwogmYyQtsRaqYmDTarsLXs6H6jqpy/+U6imdMpWkXeBdHMq02Emi9CtWIyhM
         LoTLqiddSBOzvCxrNYnxDQOaU1pxAW7OzuDdR58CojiZD5b8Dz441uwudPN4F1n6cAWH
         0qeWdwH9QCASROczsCtDyJ2penS7go6xAbE6t0cqstn4P6b1FtvX9ZRk8d53UPmiicKl
         TgJd6pkJJanDuGS8T2mgAJYCXPFMXw4bFLhCKIb5DzqjbaCfQhdXYL9CLlZ6NO8eBK1j
         WTFTWex/DkT9CpM3A4fmOfKiN4cBEWYQowLxqVmWByB9OgalP4H1YFyKjG4Rm5TzA50C
         R0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Hgnkg36DqLyHXWGaLke37obXxrGvUZVl10tSfHjo3U4=;
        b=SLvFvhOux76VkgJ51i2sjDOSS6C7RV2vasein/epUOas9x2eE4AyGjAyj5J1T0cKee
         g46AHiVk2EK0WeVs3/6jb8s4U6ZnmQDquWIb2jrhT3MOsRb6SGvFyIL56eEt6eJXt2Mh
         1CxQK1Q+a9ScKthsviNALWj26s80wT82xbyH6j5NLdS/pQ/TzUhgxrU+ManEzyq7ekTl
         nAeoDiE69hkp7SwkE9Gs+FfaZFiLm95FlvTEZING/2npn6w+44MWMcST18+fhgrGAY/E
         At2B3LFXWH8W17m4Wvkx3St8lHUglkUPmfGp/4DxdELGnvhW8EyR4rBm9Gw606FuIUPk
         ZC7A==
X-Gm-Message-State: ACgBeo3Bb+8LCDORd26s+7iufFSlTMGfNd3RgeCDOKyxCgK6835fwN1b
        7T+QSaQJHujZzLdxgESLv3pS3nQL6RJ7KxRJkIM=
X-Google-Smtp-Source: AA6agR6qpPAfSFE5GOdTgEzZGiZRCjwM02CBGNPvle7mE1ssALvBAw6rJ766ER7pI56MhqS/bgsQZDIYCG4R9LzREPk=
X-Received: by 2002:a05:6402:27ca:b0:43e:ce64:ca07 with SMTP id
 c10-20020a05640227ca00b0043ece64ca07mr34714274ede.66.1662137600594; Fri, 02
 Sep 2022 09:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc> <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc> <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
 <1cc40302-f006-31a7-b270-30813b8f4b67@iogearbox.net> <CAHsH6GtCgb1getXASkqzN75cNfm7_GOg8Mng5ZY37yK99XBVMQ@mail.gmail.com>
In-Reply-To: <CAHsH6GtCgb1getXASkqzN75cNfm7_GOg8Mng5ZY37yK99XBVMQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 2 Sep 2022 09:53:09 -0700
Message-ID: <CAADnVQLSQPnT+8EV15=6MHzMCpfcPn9SOONERLtO2TJY43JUhg@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Florian Westphal <fw@strlen.de>,
        Andrii Nakryiko <andrii@kernel.org>,
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

On Wed, Aug 31, 2022 at 10:18 PM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> On Thu, Sep 1, 2022 at 1:16 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 8/31/22 7:26 PM, Alexei Starovoitov wrote:
> > > On Wed, Aug 31, 2022 at 8:53 AM Florian Westphal <fw@strlen.de> wrote:
> > >> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >>>> 1 and 2 have the upside that its easy to handle a 'file not found'
> > >>>> error.
> > >>>
> > >>> I'm strongly against calling into bpf from the inner guts of nft.
> > >>> Nack to all options discussed in this thread.
> > >>> None of them make any sense.
> > >>
> > >> -v please.  I can just rework userspace to allow going via xt_bpf
> > >> but its brain damaged.
> > >
> > > Right. xt_bpf was a dead end from the start.
> > > It's time to deprecate it and remove it.
> > >
> > >> This helps gradually moving towards move epbf for those that
> > >> still heavily rely on the classic forwarding path.
> > >
> > > No one is using it.
> > > If it was, we would have seen at least one bug report over
> > > all these years. We've seen none.
> > >
> > > tbh we had a fair share of wrong design decisions that look
> > > very reasonable early on and turned out to be useless with
> > > zero users.
> > > BPF_PROG_TYPE_SCHED_ACT and BPF_PROG_TYPE_LWT*
> > > are in this category. > All this code does is bit rot.
> >
> > +1
> >
> > > As a minimum we shouldn't step on the same rakes.
> > > xt_ebpf would be the same dead code as xt_bpf.
> >
> > +1, and on top, the user experience will just be horrible. :(
> >
> > >> If you are open to BPF_PROG_TYPE_NETFILTER I can go that route
> > >> as well, raw bpf program attachment via NF_HOOK and the bpf dispatcher,
> > >> but it will take significantly longer to get there.
> > >>
> > >> It involves reviving
> > >> https://lore.kernel.org/netfilter-devel/20211014121046.29329-1-fw@strlen.de/
> > >
> > > I missed it earlier. What is the end goal ?
> > > Optimize nft run-time with on the fly generation of bpf byte code ?
> >
> > Or rather to provide a pendant to nft given existence of xt_bpf, and the
> > latter will be removed at some point? (If so, can't we just deprecate the
> > old xt_bpf?)
>
> FWIW we've been using both lwt bpf and xt_bpf on our production workloads
> for a few years now.
>
> xt_bpf allows us to apply custom sophisticated policy logic at connection
> establishment - which is not really possible (or efficient) using
> iptables/nft constructs - without needing to reinvent all the facilities that
> nf provides like connection tracking, ALGs, and simple filtering.
>
> As for lwt bpf, We use it for load balancing towards collect md tunnels.
> While this can be done at tc egress for unfragmented packets, the lwt out hook -
> when used in tandem with nf fragment reassembly - provides a hooking point
> where a bpf program can see reassembled packets and load balance based on
> their internals.

Sounds very interesting!
Any open source code to look at ?
