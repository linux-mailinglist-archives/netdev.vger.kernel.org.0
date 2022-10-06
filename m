Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B753C5F71C5
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 01:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiJFX2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 19:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiJFX2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 19:28:35 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7203BEB7C9;
        Thu,  6 Oct 2022 16:28:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id sc25so1721940ejc.12;
        Thu, 06 Oct 2022 16:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=SFtTygd13gnjeXlSaquv1ZHXw+HfAHR5AS6QJdlQ3mo=;
        b=XOqIbegB5myFnnNWstvTjhEHQ8TsH4coI7nVbqq5BXgHJYHCpp0UGkrRqW2DQKalc8
         Wk89RH1iz23wGkIzyrdPDoiXjEcLG2k8hUqQNBxZZeU7Pikn1/2chwruYkaKCPqRFbUn
         BdUnGDfUFEOLDDn0qXyRR2nEv+tpA+77bcurMig93yXVeIRcpJ6ajlMc493mTx6xVlnl
         HxDIEtZ2nTDv6uevLMsY3j/IFOP0WdJbshMJXb5STvkTdBK6rIzsfFxrPrfKHw9nhcNp
         7xiMBUhT22vtFnJKEpgR1TTC1lJMSkEiOs+8hHnRuuyEZFaodkszY+/XjyvoM6uviCZt
         RDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=SFtTygd13gnjeXlSaquv1ZHXw+HfAHR5AS6QJdlQ3mo=;
        b=JrTYJb63t3rfmHyR0Ho1ZMaOD7RhBCP9QfC2iqa9dHG9jgmug7T8tqIKvSt7AFGrhV
         tBisGHj4E7lC1dCurVGnq4JmP/lhzlAPVdE2VIJCZVhMK6TQh6cm2ZnAxeNPAnhxe5in
         hdGq+nwGtmM1SafO0wVA/yLoDKBJ0BvdXX8Bv/X5+lnzuYtheui3cwpzA1m981R3xqXU
         Jn04HrZdZ/0WzCPh4NKXJfT2WQyPO5qK+d988WuRPpvxDHqWch2G5U4etix1gHBBrby8
         G46OeHkVwS50vCjbPZ5ZRiqt6RIbN9zJf22zPQNXx+vXFh2736ca9CEmie8ULaObXpHO
         Sn1Q==
X-Gm-Message-State: ACrzQf3dfSPTCNUs694Yvgcb1FZePRJHXm3pDXEB7Cm9gPnn0DMdgCRH
        tOmdh7gzTVA1V9ZbPtjSPfIS/aHM9B8e3JEhR8I=
X-Google-Smtp-Source: AMsMyM5tCyLLkkyqfZa4OjdXfD+Yru8XHsRttziDXU9RaxSsDXdNccmCLUgx1T+2X8xFTnR93pCo245i5yK3vxlekKI=
X-Received: by 2002:a17:907:1c98:b0:78d:3b06:dc8f with SMTP id
 nb24-20020a1709071c9800b0078d3b06dc8fmr1838226ejc.58.1665098912840; Thu, 06
 Oct 2022 16:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com> <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
In-Reply-To: <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Oct 2022 16:28:21 -0700
Message-ID: <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Joe Stringer <joe@cilium.io>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 6, 2022 at 2:29 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/6/22 7:00 AM, Alexei Starovoitov wrote:
> > On Wed, Oct 05, 2022 at 01:11:34AM +0200, Daniel Borkmann wrote:
> [...]
> >
> > I cannot help but feel that prio logic copy-paste from old tc, netfilter and friends
> > is done because "that's how things were done in the past".
> > imo it was a well intentioned mistake and all networking things (tc, netfilter, etc)
> > copy-pasted that cumbersome and hard to use concept.
> > Let's throw away that baggage?
> > In good set of cases the bpf prog inserter cares whether the prog is first or not.
> > Since the first prog returning anything but TC_NEXT will be final.
> > I think prog insertion flags: 'I want to run first' vs 'I don't care about order'
> > is good enough in practice. Any complex scheme should probably be programmable
> > as any policy should. For example in Meta we have 'xdp chainer' logic that is similar
> > to libxdp chaining, but we added a feature that allows a prog to jump over another
> > prog and continue the chain. Priority concept cannot express that.
> > Since we'd have to add some "policy program" anyway for use cases like this
> > let's keep things as simple as possible?
> > Then maybe we can adopt this "as-simple-as-possible" to XDP hooks ?
> > And allow bpf progs chaining in the kernel with "run_me_first" vs "run_me_anywhere"
> > in both tcx and xdp ?
> > Naturally "run_me_first" prog will be the only one. No need for F_REPLACE flags, etc.
> > The owner of "run_me_first" will update its prog through bpf_link_update.
> > "run_me_anywhere" will add to the end of the chain.
> > In XDP for compatibility reasons "run_me_first" will be the default.
> > Since only one prog can be enqueued with such flag it will match existing single prog behavior.
> > Well behaving progs will use (like xdp-tcpdump or monitoring progs) will use "run_me_anywhere".
> > I know it's far from covering plenty of cases that we've discussed for long time,
> > but prio concept isn't really covering them either.
> > We've struggled enough with single xdp prog, so certainly not advocating for that.
> > Another alternative is to do: "queue_at_head" vs "queue_at_tail". Just as simple.
> > Both simple versions have their pros and cons and don't cover everything,
> > but imo both are better than prio.
>
> Yeah, it's kind of tricky, imho. The 'run_me_first' vs 'run_me_anywhere' are two
> use cases that should be covered (and actually we kind of do this in this set, too,
> with the prios via prio=x vs prio=0). Given users will only be consuming the APIs
> via libs like libbpf, this can also be abstracted this way w/o users having to be
> aware of prios.

but the patchset tells different story.
Prio gets exposed everywhere in uapi all the way to bpftool
when it's right there for users to understand.
And that's the main problem with it.
The user don't want to and don't need to be aware of it,
but uapi forces them to pick the priority.

> Anyway, where it gets tricky would be when things depend on ordering,
> e.g. you have BPF progs doing: policy, monitoring, lb, monitoring, encryption, which
> would be sth you can build today via tc BPF: so policy one acts as a prefilter for
> various cidr ranges that should be blocked no matter what, then monitoring to sample
> what goes into the lb, then lb itself which does snat/dnat, then monitoring to see what
> the corresponding pkt looks that goes to backend, and maybe encryption to e.g. send
> the result to wireguard dev, so it's encrypted from lb node to backend.

That's all theory. Your cover letter example proves that in
real life different service pick the same priority.
They simply don't know any better.
prio is an unnecessary magic that apps _have_ to pick,
so they just copy-paste and everyone ends up using the same.

> For such
> example, you'd need prios as the 'run_me_anywhere' doesn't guarantee order, so there's
> a case for both scenarios (concrete layout vs loose one), and for latter we could
> start off with and internal prio around x (e.g. 16k), so there's room to attach in
> front via fixed prio, but also append to end for 'don't care', and that could be
> from lib pov the default/main API whereas prio would be some kind of extended one.
> Thoughts?

If prio was not part of uapi, like kernel internal somehow,
and there was a user space daemon, systemd, or another bpf prog,
module, whatever that users would interface to then
the proposed implementation of prio would totally make sense.
prio as uapi is not that.
