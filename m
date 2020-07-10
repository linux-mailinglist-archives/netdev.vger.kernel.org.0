Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD321BD39
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgGJS4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgGJS4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 14:56:04 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B00C08C5DC;
        Fri, 10 Jul 2020 11:56:04 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id e3so3048793qvo.10;
        Fri, 10 Jul 2020 11:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4iEWXT+iHGuXcysmkhU8k7akOyMnbrSk4nJ/4eewiJA=;
        b=n1+SWq9jsA2ms54ovRDqOtudNbj3kVNu2L4fk9UNzpS4FNziYNMRm9nVtshWMYlTWz
         r4G7TpnhU1fhWDkhyEOfHssdcQE3R58S6fMzIyOACGSDjMtxBoNpOvdCMJbumc1V335s
         rhF0n1wQyzCWo8hL+co+AwpHXnso4uH2f1PRIMDEV/isoZeUr2/3Y5rlofYsIDQRwTir
         Pkx8qqIJa1iArff7/5cdVMKalXmxKLw8XOOL56PHbMzMmBkNA5hmNmo9xKb7fqqBrtrM
         BU/AmT7x4fpC1B/OJSo6vz7VfT4cUjYpEoHvsUfxFBSSoa928elVncpCoC2vKOZ4brxk
         1NQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4iEWXT+iHGuXcysmkhU8k7akOyMnbrSk4nJ/4eewiJA=;
        b=BrM/BgTIoDc3V8I442nDc6wpJ0eY0aKiHddIjrwQdZRFINqW8V42OrR44rTqPThTkc
         ytY0V49dd55VYAVCaIYMhCDyCK/l0Bb4+HmPClFFhghSTI2tnqU7wI6X3urwevXjGaPw
         gjmM5xwD9EJPf7Ul6nwfOyA8nCh8tVljKmnzj6cNBjF8GQ7MHcspEIXkIcqa50vJ+z8z
         6M8OrFD9LAOecux63QgTOWjHUACXbQzo3Q1HJXfn/NiT23GEHoSm/HrX4l8mImvjCibz
         yTmpVBfLHoLnnSMjzc+2okq80neYHre442cSkejwFTC4FzBhbx4xyMPDSdP5xgzmLa5S
         ZJsg==
X-Gm-Message-State: AOAM532WizF8cdJnjHt0/0qPgbzjSN406UmEIXauQLeuOikl57QDZj6M
        p+5Ygj5HKmpu8YlVqgXP9EGToeFP0lXEA6xka1s=
X-Google-Smtp-Source: ABdhPJzwihxclcnORL5tHFJuvdfaxM8MzfBjAua2WABkYz/wACzm6ouskAwRaF4kpHc5M9VcbxI5j2UCZ9+Y9wYLEOI=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr65403166qvb.228.1594407363526;
 Fri, 10 Jul 2020 11:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-13-jakub@cloudflare.com>
 <CAEf4BzbrUZhpxfw_eeJJCoo46_x1Y8naE19qoVUWi5sTSNSdzA@mail.gmail.com>
 <87h7ugadpt.fsf@cloudflare.com> <CAEf4BzY75c+gARvkmQ8OtbpDbZvBkia4qMyxO7HCoOeu=B1AxQ@mail.gmail.com>
 <87d053ahqn.fsf@cloudflare.com>
In-Reply-To: <87d053ahqn.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Jul 2020 11:55:52 -0700
Message-ID: <CAEf4Bzbxiwk6reDxF78V36mRhavc9j=woQiib7SjsQ=LbcGJQg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 12/16] libbpf: Add support for SK_LOOKUP
 program type
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 1:37 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Fri, Jul 10, 2020 at 01:13 AM CEST, Andrii Nakryiko wrote:
> > On Thu, Jul 9, 2020 at 8:51 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> On Thu, Jul 09, 2020 at 06:23 AM CEST, Andrii Nakryiko wrote:
> >> > On Thu, Jul 2, 2020 at 2:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >> >>
> >> >> Make libbpf aware of the newly added program type, and assign it a
> >> >> section name.
> >> >>
> >> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> >> ---
> >> >>
> >> >> Notes:
> >> >>     v3:
> >> >>     - Move new libbpf symbols to version 0.1.0.
> >> >>     - Set expected_attach_type in probe_load for new prog type.
> >> >>
> >> >>     v2:
> >> >>     - Add new libbpf symbols to version 0.0.9. (Andrii)
> >> >>
> >> >>  tools/lib/bpf/libbpf.c        | 3 +++
> >> >>  tools/lib/bpf/libbpf.h        | 2 ++
> >> >>  tools/lib/bpf/libbpf.map      | 2 ++
> >> >>  tools/lib/bpf/libbpf_probes.c | 3 +++
> >> >>  4 files changed, 10 insertions(+)
> >> >>
> >> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> >> index 4ea7f4f1a691..ddcbb5dd78df 100644
> >> >> --- a/tools/lib/bpf/libbpf.c
> >> >> +++ b/tools/lib/bpf/libbpf.c
> >> >> @@ -6793,6 +6793,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
> >> >>  BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
> >> >>  BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
> >> >>  BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
> >> >> +BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
> >> >>
> >> >>  enum bpf_attach_type
> >> >>  bpf_program__get_expected_attach_type(struct bpf_program *prog)
> >> >> @@ -6969,6 +6970,8 @@ static const struct bpf_sec_def section_defs[] = {
> >> >>         BPF_EAPROG_SEC("cgroup/setsockopt",     BPF_PROG_TYPE_CGROUP_SOCKOPT,
> >> >>                                                 BPF_CGROUP_SETSOCKOPT),
> >> >>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
> >> >> +       BPF_EAPROG_SEC("sk_lookup",             BPF_PROG_TYPE_SK_LOOKUP,
> >> >> +                                               BPF_SK_LOOKUP),
> >> >
> >> > So it's a BPF_PROG_TYPE_SK_LOOKUP with attach type BPF_SK_LOOKUP. What
> >> > other potential attach types could there be for
> >> > BPF_PROG_TYPE_SK_LOOKUP? How the section name will look like in that
> >> > case?
> >>
> >> BPF_PROG_TYPE_SK_LOOKUP won't have any other attach types that I can
> >> forsee. There is a single attach type shared by tcp4, tcp6, udp4, and
> >> udp6 hook points. If we hook it up in the future say to sctp, I expect
> >> the same attach point will be reused.
> >
> > So you needed to add to bpf_attach_type just to fit into link_create
> > model of attach_type -> prog_type, right? As I mentioned extending
> > bpf_attach_type has a real cost on each cgroup, so we either need to
> > solve that problem (and I think that would be the best) or we can
> > change link_create logic to not require attach_type for programs like
> > SK_LOOKUP, where it's clear without attach type.
>
> Right. I was thinking about that a bit. For prog types map 1:1 to an
> attach type, like flow_dissector or proposed sk_lookup, we don't really
> to know the attach type to attach the program.
>
> PROG_QUERY is more problematic though. But I imagine we could introduce
> a flag like BPF_QUERY_F_BY_PROG_TYPE that would make the kernel
> interpret attr->query.attach_type as prog type.
>
> PROG_DETACH is yet another story but sk_lookup uses only link-based
> attachment, so I'm ignoring it here.
>
> What also might get in the way is the fact that there is no
> bpf_attach_type value reserved for unspecified attach type at the
> moment. We would have to ensure that the first enum,
> BPF_CGROUP_INET_INGRESS, is not treated as an exact attach type.
>

I think we should just solve this for cgroup the same way you did it
for netns. We'll keep adding new attach types regardless, so better
solve the problem, rather than artificially avoid it.


> >
> > Second order question was if we have another attach type, having
> > SEC("sk_lookup/just_kidding_something_else") would be a bit weird :)
> > But it seems like that's not a concern.
>
> Yes. Sorry, I didn't mean to leave it unanswered. Just assumed that it
> was obvious that it's not the case.
>
> I've been happily using the part of section name following "sk_lookup"
> prefix to name the programs just to make section names in ELF object
> unique:
>
>   SEC("sk_lookup/lookup_pass")
>   SEC("sk_lookup/lookup_drop")
>   SEC("sk_lookup/redir_port")

oh, right, which reminds me: how about adding / to sk_lookup in that
libbpf table, so that it's always sk_lookup/<something> for section
name? We did similar change to xdp_devmap recently, and it seems like
a good trend overall to have / separation between program type and
whatever extra name user wants to give?
