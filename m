Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F82229046
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgGVGCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgGVGCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:02:17 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E79C061794;
        Tue, 21 Jul 2020 23:02:17 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id e12so1018014qtr.9;
        Tue, 21 Jul 2020 23:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/KfXQuF2JJOoXjIPymwUQpwHoPclxEKAmVNRUCUP4pY=;
        b=D11QqbSSY4WpRR6QBKOdOMBPO64k+WOEuocbUi55fYbF+Ol0OZlpzHnQ8JI5RXMu1v
         dHznOGllAg9WwE3bZA0FujJRHsHdzQ90l0ihxNxG0ZYWoQUCi7VZCjF/T01tZR5Kq0yc
         MBek2X3cYm2dYkXQaZiv4/OOhJia6uAwyR2XydLR/EJCCwj5zttEHN0VmE8x76CneR+x
         EvaafIJLosdCtdUB+9/WWHOOEfMBLJwt0wIIIkdkEq4HfsUXK2lK4Ip6ZKY8JZcuhqYe
         vuMzc0YetJp/MPXj5kcfCBslaCxwWWEbOKhDWDS8MDKGDQMdNTpEs7Rfxzzp3wleAl8b
         UqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KfXQuF2JJOoXjIPymwUQpwHoPclxEKAmVNRUCUP4pY=;
        b=aV2Z3MXQWan+ySa4XCR3KOLtxKJO2K1HW2bEiEDxZGGyaqCohy5qTj4wlMf7sehqzX
         pVN5Hc/2NXUyT790cbUfCj+SgguX75NWM8XyW223/2rc9oGUdsCxsClbQAob8mDqyh8b
         ZhR+EQ4mfpUN9nBALhVhYmeBhl9KGduL8GonD0SV8pZkXIDq8ZH+7mSaC+OgZ18mbN4m
         SmnM5iJFIy9gmcvOs8e2ol9XKwU06xRYehgx/WKACSoidm7zlOdK/GnIQ1HXF9Ai/OE9
         iWr6q4/K5S0KdmKZhXkigOw48D+vdHXy4xguL9X61rIdVU/yrZdnW0mdmZC7AlRCFaE8
         Hylw==
X-Gm-Message-State: AOAM531OxGeGiVwEF/UO8cKZEsS9wcjgzme1HBGGh4kQLJUpNvPg6W+1
        gtMcBGEm8A/1HJr/FR5ZDFcp0FEo874/yDn3h20=
X-Google-Smtp-Source: ABdhPJx4O1FdwrbWNMhZlEht3VPXFw3HgyDpWAk7KvRNNnGYr9ftRtTK9jhF+hLO8PprnTFry3fRN+H3nMPg0wlwi7M=
X-Received: by 2002:ac8:18d4:: with SMTP id o20mr32200438qtk.141.1595397736298;
 Tue, 21 Jul 2020 23:02:16 -0700 (PDT)
MIME-Version: 1.0
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk> <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
 <87mu3zentu.fsf@toke.dk> <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYd4Xrn4EqzqHCTuJ8TnZiTC1vWWvd=9Np+LNrgbtxOcQ@mail.gmail.com>
 <20200720233455.6ito7n2eqojlfnvk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYtD9dGUy3hZRRAA56CaVvW7xTR9tp0dXKyVQXym046eQ@mail.gmail.com> <20200722002918.574pruibvlxfblyq@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200722002918.574pruibvlxfblyq@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Jul 2020 23:02:04 -0700
Message-ID: <CAEf4BzbdE441MgpEAv+nLBYUXZRz_tzGvmf87rw68hOvT0bwfw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/6] bpf: support attaching freplace programs
 to multiple attach points
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 5:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jul 20, 2020 at 08:48:04PM -0700, Andrii Nakryiko wrote:
> >
> > Right, I wanted to avoid taking a refcnt on aux->linked_prog during
> > PROG_LOAD. The reason for that was (and still is) that I don't get who
> > and when has to bpf_prog_put() original aux->linked_prog to allow the
> > prog X to be freed. I.e., after you re-attach to prog Y, how prog X is
> > released (assuming no active bpf_link is keeping it from being freed)?
> > That's my biggest confusion right now.
> >
> > I also didn't like the idea of half-creating bpf_tracing_link on
> > PROG_LOAD and then turning it into a real link with bpf_link_settle on
> > attach. That sounded like a hack to me.
>
> The link is kinda already created during prog_load of EXT type.
> Typically prog_load needs expected_attach_type that points to something
> that is not going to disappear. In case of EXT progs the situation is different,
> since the target can be unloaded. So the prog load cmd not only validates the
> program extension but links target and ext prog together at the same time.
> The target prog will be held until EXT prog is unloaded.
> I think it's important to preserve this semantics to the users that the target prog
> is frozen at load time and no races are going to happen later.
> Otherwise it leads to double validation at attach time and races.

Yes, I was confused because of the step you describe below (removal of
linked_prog from aux->linked_prog and moving it into BPF link on
attach). With that move, it makes sense to have that bpf_prog refcnt
bump on load, makes everything simpler.

>
> What raw_tp_open is doing right now is a hack. It allocates bpf_tracing_link,
> registers it into link_idr and activates trampoline, but in reality that link is already there.

That's an interesting way to look at this. For me it always felt
normal, because real linking is happening inside
bpf_trampoline_link_prog(). But it's a minor technicality, it's not
important enough to discuss.

> I think we can clean it up by creating bpf_tracing_link at prog load time.
> Whether to register it at that time into link_idr is up to discussion.
> (I think probably not).

yeah, I agree, let's not


> Then raw_tp_open will activate that allocated bpf_tracing_link via trampoline,
> _remove_ it from aux->linked_tracing_link (old linked_prog) and
> return FD to the user.

Ok, so this move from aux->linked_prog into BPF link itself is what
was missing, I wasn't sure whether you proposed doing that. With that
it makes more sense, even if it's a bit "asymmetrical" in that you can
attach only once using old-style EXT attach, but can attach and
re-attach many times if you specify tgt_prog_fd. But I think it's also
fine, I just wish we always required tgt_prog_fd...

> So this partially created link at load_time will become complete link and
> close of the link will detach EXT from the target and the target can be unloaded.
> (Currently the target cannot be unloaded until EXT is loaded which is not great).
> The EXT_prog->aux->linked_tracing_link (old linked_prog) will exist only during
> the time between prog_load and raw_tp_open without args.
> I think that would be a good clean up.

yep, I agree

> Then multi attach of EXT progs is clean too.
> New raw_tp_open with tgt_prog_fd/tgt_btf_id will validate EXT against the new target,
> link them via new bpf_tracing_link, activate it via trampoline and return FD.
> No link list anywhere.
> Note that this second validation of EXT against new target is light weight comparing
> to the load. The first load goes through all EXT instructions with verifier ctx of
> the target prog. The second validation needs to compare BTF proto tgr_prog_fd+tgt_btf_id
> with EXT's btf_id only (and check tgt_prog_fd->type/expected_attach_type).
> Since EXT was loaded earlier it has valid insns.

Right, this matches what I understood about this re-attach logic, great.

> So if you're thinking "cannot we validate insns at load time, but then remember
> tgt stuff instead of creating a partial link, and double validate BTF at raw_tp_open
> when it's called without tgt_prog_fd?"
> The answer is "yes, we can", but double validation of BTF I think is just a waste of cycles,
> when tgt prog could have been held a bit between load and attach.
> And it's race free. Whereas if we remember target prog_id at load then raw_tp_open is
> shooting in the dark. Unlikely, but that prog_id could have been reused.

Sure, I agree that there is no need to complicate everything with ID
(now that I understand the proposal better). My confusion came from
two things:

1. Current API usage would allow PROG_LOAD of EXT program, would take
refcnt on target program. RAW_TP_OPEN + close link to detach. Then, if
necessary again RAW_TP_OPEN, and the second (and subsequent times)
would succeed. But it seems like we are changing that to only allow
one RAW_TP_OPEN if one doesn't provide tgt_prog_fd. I think it's
acceptable, but it wasn't clear to me.

2. You were talking about turning aux->linked_prog into a linked list
of bpf_tracing_links, but I couldn't see the point. In your latest
version you didn't talk about this list of links, so it seems like
that's not necessary after all, right? I like that.


So I think we are in agreement overall.

Just one technical moment, let me double-check my understanding again.
You seem to be favoring pre-creating bpf_tracing_link because there is
both tgt_prog (that we refcnt on EXT prog load) and we also lookup and
initialize trampoline in check_attach_btf_id(). Of course there is
also expected_attach_type, but that's a trivial known enum, so I'm
ignoring it. So because we have those two entities which on attach are
supposed to be owned by bpf_tracing_link, you just want to pre-create
a "shell" of bpf_tracing_link, and then on attach complete its
initialization, is that right? That certainly simplifies attach logic
a bit and I think it's fine.

But also it seems like we'll be creating and initializing a
**different** trampoline on re-attach to prog Y. Now attach will do
different things depending on whether tgt_prog_fd is provided or not.
So I wonder why not just unify this trampoline initialization and do
it at attach time? For all valid EXT use cases today the result is the
same: everything still works the same. For cases where we for some
reason can't initialize bpf_trampoline, that failure will happen at
attach time, not on a load time. But that seems fine, because that's
going to be the case for re-attach (with tgt_prog_fd) anyways. Looking
through the verifier code, it doesn't seem like it does anything much
with prog->aux->trampoline, unless I missed something, so it must be
ok to do it after load? It also seems to avoid this double BTF
validation concern you have, no? Thoughts?

Regardless, thanks for elaborating, I think I get it end-to-end now.
