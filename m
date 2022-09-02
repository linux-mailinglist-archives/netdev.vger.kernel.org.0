Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04335AB727
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 19:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbiIBRGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 13:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiIBRGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 13:06:42 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A00510F08F;
        Fri,  2 Sep 2022 10:06:41 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id r4so3500071edi.8;
        Fri, 02 Sep 2022 10:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vF2XFYpw7mhuMnmB37UaTh5IVPPGdbZxnrBG6qs8Iwg=;
        b=nliIoJ1NcIgUFFEUicHIiY9PRwcOIUikhXzqB/tRbd3cHjjYzW3z5A+EWFjBiaAYzL
         jnpXgNN28BePrcf/2qwKpzmkC5KhkMeIHJbozFn5Ab0oXve8QOFX2WOiiescBHdoQEPY
         8hq7b2Bs1tamoam0UD/l3pziKVjxoEOZUeZ7YxUyqCilFrDVfkLHdFp0zi0eg2byPBb1
         MaWfAWtS+Ec9KHIvHcKuXau9E1w0Q9EWC2VimU0cwd/R3YRU9AiJRgVNgIhawqoe4vSD
         Qq7xeQPlHsM041Otd1vIhPWtITaSTs1DKbwStybKaxep8jhctuaFwF1pHkH72Mb4mFOb
         K1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vF2XFYpw7mhuMnmB37UaTh5IVPPGdbZxnrBG6qs8Iwg=;
        b=dK/DKsnHxcgfhDZP2P5bQOKWkzA91wGY2JmXqt+e1Q/WIVCjKqHadTwRDt+3rMM+jO
         vT42w2EAYO1/M52sYJRMI/6fCmEulb/+ACjClXi3gbKBQuGePfZtqOkMboUcnPhM6/4Y
         3cbQo30hSQwumb9JgHd6WCD8k7jAc0Uuq07X44KbsoqYmLoh/i5sbSe0CYvrw+mR4ruo
         qAg41rF/uJ/P3IKtNeZ9oA/vU9qL6w+S2Q2/ugPf6omEq3Ltj9PJpC0OuUCi5PoL6tRY
         VqjL65IuSbDD89rD2QP4XBkq+exEnbyKY9Rbkczd0tDTE3tSEg8WQKkg8npcMrRZHa1Y
         DuIQ==
X-Gm-Message-State: ACgBeo0JvgVBxN+LFuhQuX4kUzUdBEDGTCn3cEkp680LskBndGW+CHAn
        OyBvIWsiURlHmnmtjAAkWeCTfr6Wd3NR5xyuZVl/gvqh
X-Google-Smtp-Source: AA6agR6yW6d4dajYWkFyaBsN8yOnSjDIP+pOnl+k8E7jJQ5Gl1tSb5WxqX3GXV92VDitaUoVbuxFR93goPIhYfIVM8A=
X-Received: by 2002:a05:6402:28cd:b0:448:3856:41a3 with SMTP id
 ef13-20020a05640228cd00b00448385641a3mr24319182edb.6.1662138399947; Fri, 02
 Sep 2022 10:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <87v8q84nlq.fsf@toke.dk> <20220831125608.GA8153@breakpoint.cc>
 <87o7w04jjb.fsf@toke.dk> <20220831135757.GC8153@breakpoint.cc>
 <87ilm84goh.fsf@toke.dk> <20220831152624.GA15107@breakpoint.cc>
 <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc> <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
 <1cc40302-f006-31a7-b270-30813b8f4b67@iogearbox.net> <20220901101401.GC4334@breakpoint.cc>
In-Reply-To: <20220901101401.GC4334@breakpoint.cc>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 2 Sep 2022 10:06:28 -0700
Message-ID: <CAADnVQJUDcahx2R58zEPNi_uRdgUNtKKUTqndDY-NVd03pB_+Q@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
To:     Florian Westphal <fw@strlen.de>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
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

On Thu, Sep 1, 2022 at 3:14 AM Florian Westphal <fw@strlen.de> wrote:
>
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> > On 8/31/22 7:26 PM, Alexei Starovoitov wrote:
> > > On Wed, Aug 31, 2022 at 8:53 AM Florian Westphal <fw@strlen.de> wrote:
> > > As a minimum we shouldn't step on the same rakes.
> > > xt_ebpf would be the same dead code as xt_bpf.
> >
> > +1, and on top, the user experience will just be horrible. :(
>
> Compared to what?
>
> > > > If you are open to BPF_PROG_TYPE_NETFILTER I can go that route
> > > > as well, raw bpf program attachment via NF_HOOK and the bpf dispatcher,
> > > > but it will take significantly longer to get there.
> > > >
> > > > It involves reviving
> > > > https://lore.kernel.org/netfilter-devel/20211014121046.29329-1-fw@strlen.de/
> > >
> > > I missed it earlier. What is the end goal ?
> > > Optimize nft run-time with on the fly generation of bpf byte code ?
> >
> > Or rather to provide a pendant to nft given existence of xt_bpf, and the
> > latter will be removed at some point? (If so, can't we just deprecate the
> > old xt_bpf?)
>
> See my reply to Alexey, immediate goal was to get rid of the indirect
> calls by providing a tailored/jitted equivalent of nf_hook_slow().
>
> The next step could be to allow implementation of netfilter hooks
> (i.e., kernel modules that call nf_register_net_hook()) in bpf
> but AFAIU it requires addition of BPF_PROG_TYPE_NETFILTER etc.

We were adding new prog and maps types in the past.
Now new features are being added differently.
All of the networking either works with sk_buff-s or xdp frames.
We try hard not to add any new uapi helpers.
Everything is moving to kfuncs.
Other sub-systems should be able to use bpf without touching
the bpf core. See hid-bpf as an example.
It needs several verifier improvements, but doesn't need
new prog types, helpers, etc.

> After that, yes, one could think about how to jit nft_do_chain() and
> all the rest of the nft machinery.

Sounds like a ton of work. All that just to accelerate nft a bit?
I think there are more impactful projects to work on.
For example, accelerating classic iptables with bpf would immediately
help a bunch of users.
