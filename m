Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB4A5AD89B
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiIERuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiIERud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:50:33 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0775F224;
        Mon,  5 Sep 2022 10:50:32 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id f4so6695291qkl.7;
        Mon, 05 Sep 2022 10:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=NIxejre8XSlpvZ705nvFUrxMRpB63yvrNzNcvR3IWeo=;
        b=HRbeyKuzFpMmFL3T6dCdhJNR2I8tnyzlLFo4PfVHb0+IsLTP/PwcxtJk7G/WXaFZtv
         fbkBJWjR48+c6CG+SY/roeM0NvZtu5YOPEiahvAktzHMW6kaCTqb+UN5a9ALu5pVkgkr
         1ehxy8+YtfXOcnSUVTFdNY2alQEQsRvV6benXsNXaYSINC6kc4RMO9lhX8NgTp6hGRdM
         B/zxTyjqEa+rHYqKMg84h8Fv5z0RPxJK0zJeumwbtXOl7sCQUPAnayc/9ozuI/2xuzKE
         OvDQPJp9Ku4OEabBZNSc03MPO6HBKiJPKBCg0r/5exq/GegS8lqketkuFJGtyJj4wvZj
         S1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=NIxejre8XSlpvZ705nvFUrxMRpB63yvrNzNcvR3IWeo=;
        b=tbYePU6WFlbKC7VGz1GhjMcZ/e1IyLysTKbsvoJ7udTc7Uwk7UL9YrfYBp4H31iI7A
         QVaARiSKlJg/MN6jCAtHuOsUl5LbuZ/+EkyJgxjCPGKGJPHEImWDshV43/7/lik0dvon
         3dC2TJlP5yf7cxn4xTFBAzpkwhLoIDdeufMwaO3TL4OBMalX/W4ybR83Nf5om0+VoITG
         zdTU7AnLsc0yl9b/v5OTkfwftlcfYrX5Jx+rH+4y/hWf1dO207skX9yYR60URIxCpfRg
         NB19UXeUHy0PKazKVa0vFKPS3f9Byo1o9tSk1u4RYDmOgD0+0Wx952DoxuNtAtlInevQ
         PP5g==
X-Gm-Message-State: ACgBeo3FZ5o/bPQj6W11Ap8qypf4OrhGrmtV0UokdALoUWYZ5VY4PwHG
        OalWR47rr0wwN7uoMuIgTukOOnRk0fD6Stg1160=
X-Google-Smtp-Source: AA6agR4AeWEab2VeYH3ZQqCHDhtVB8Gy64pypEwNlDKY17HHwSmi/SwuHlkJ0wy5t4bsgndt/hjL+D9Dk2A3yCkk9/o=
X-Received: by 2002:a05:620a:1011:b0:6bc:62fc:6e4 with SMTP id
 z17-20020a05620a101100b006bc62fc06e4mr33666187qkj.484.1662400231285; Mon, 05
 Sep 2022 10:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc> <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc> <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
 <1cc40302-f006-31a7-b270-30813b8f4b67@iogearbox.net> <CAHsH6GtCgb1getXASkqzN75cNfm7_GOg8Mng5ZY37yK99XBVMQ@mail.gmail.com>
 <CAADnVQLSQPnT+8EV15=6MHzMCpfcPn9SOONERLtO2TJY43JUhg@mail.gmail.com>
In-Reply-To: <CAADnVQLSQPnT+8EV15=6MHzMCpfcPn9SOONERLtO2TJY43JUhg@mail.gmail.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Mon, 5 Sep 2022 20:50:20 +0300
Message-ID: <CAHsH6GuiPvD5Z98=HWvKtR5FkP0rO_8Suhn6_njEgC54CGptXw@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Fri, Sep 2, 2022 at 7:53 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 31, 2022 at 10:18 PM Eyal Birger <eyal.birger@gmail.com> wrote:
> >
> > On Thu, Sep 1, 2022 at 1:16 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On 8/31/22 7:26 PM, Alexei Starovoitov wrote:
> > > > On Wed, Aug 31, 2022 at 8:53 AM Florian Westphal <fw@strlen.de> wrote:
> > > >> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > >>>> 1 and 2 have the upside that its easy to handle a 'file not found'
> > > >>>> error.
> > > >>>
> > > >>> I'm strongly against calling into bpf from the inner guts of nft.
> > > >>> Nack to all options discussed in this thread.
> > > >>> None of them make any sense.
> > > >>
> > > >> -v please.  I can just rework userspace to allow going via xt_bpf
> > > >> but its brain damaged.
> > > >
> > > > Right. xt_bpf was a dead end from the start.
> > > > It's time to deprecate it and remove it.
> > > >
> > > >> This helps gradually moving towards move epbf for those that
> > > >> still heavily rely on the classic forwarding path.
> > > >
> > > > No one is using it.
> > > > If it was, we would have seen at least one bug report over
> > > > all these years. We've seen none.
> > > >
> > > > tbh we had a fair share of wrong design decisions that look
> > > > very reasonable early on and turned out to be useless with
> > > > zero users.
> > > > BPF_PROG_TYPE_SCHED_ACT and BPF_PROG_TYPE_LWT*
> > > > are in this category. > All this code does is bit rot.
> > >
> > > +1
> > >
> > > > As a minimum we shouldn't step on the same rakes.
> > > > xt_ebpf would be the same dead code as xt_bpf.
> > >
> > > +1, and on top, the user experience will just be horrible. :(
> > >
> > > >> If you are open to BPF_PROG_TYPE_NETFILTER I can go that route
> > > >> as well, raw bpf program attachment via NF_HOOK and the bpf dispatcher,
> > > >> but it will take significantly longer to get there.
> > > >>
> > > >> It involves reviving
> > > >> https://lore.kernel.org/netfilter-devel/20211014121046.29329-1-fw@strlen.de/
> > > >
> > > > I missed it earlier. What is the end goal ?
> > > > Optimize nft run-time with on the fly generation of bpf byte code ?
> > >
> > > Or rather to provide a pendant to nft given existence of xt_bpf, and the
> > > latter will be removed at some point? (If so, can't we just deprecate the
> > > old xt_bpf?)
> >
> > FWIW we've been using both lwt bpf and xt_bpf on our production workloads
> > for a few years now.
> >
> > xt_bpf allows us to apply custom sophisticated policy logic at connection
> > establishment - which is not really possible (or efficient) using
> > iptables/nft constructs - without needing to reinvent all the facilities that
> > nf provides like connection tracking, ALGs, and simple filtering.
> >
> > As for lwt bpf, We use it for load balancing towards collect md tunnels.
> > While this can be done at tc egress for unfragmented packets, the lwt out hook -
> > when used in tandem with nf fragment reassembly - provides a hooking point
> > where a bpf program can see reassembled packets and load balance based on
> > their internals.
>
> Sounds very interesting!
> Any open source code to look at ?

For these projects there isn't at this point. But some of the benefit in these
specific hooking points is that our custom logic is very scoped and integrates
well with the "classical" forwarding path.

In netfilter we have an identity based policy engine provisioning sets of
bpf maps. These maps are use used by policy programs invoked by xt_bpf on
connection establishment as part of a larger set of iptables rules.

In LWT this solved us a problem with fragmented traffic, as our load
balancing solution supports - among other things - IPsec stickiness based
on ESP-in-UDP SPI and as such needs to see unfragemented traffic.

Eyal.
