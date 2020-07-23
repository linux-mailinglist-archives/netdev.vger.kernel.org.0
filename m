Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B412822A3F0
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733289AbgGWA5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWA47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:56:59 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0319C0619DC;
        Wed, 22 Jul 2020 17:56:59 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e13so3914113qkg.5;
        Wed, 22 Jul 2020 17:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r4x432qA5hR55A+1BypDK7/xCTrq8/X3fxHXauaKEWg=;
        b=Qr43xhDveFtA5VU5DZwih0ZTmz7VCm31i56Dy8Zj6pORgJiNAlgtcmq41ii2wgD5qn
         wD3HR+PIVmBHfsg0IKBCi4SIP6E4l9VfzE986ilsW4kGb4Ma0AUnMCDSvi1CjPXEndU2
         lL0YrrXDGnpwObnsn08ccToFvx3dbaFvQIutz47Z2/899R1EMBQINJEq40bKnT70ltOw
         aODf9EPzB+maukm2Y1L0zNFpe79liFJeVsEnzTqSrBk+2M1iMvtMuLMxkfxkD7cFDUyd
         LSlpFd/bsMQ7Y9MxphsOGkLxAe5Wv3XP3iP+Oscu67Kzx2ebf89I/j2k7SgtzFtOXKR1
         cSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r4x432qA5hR55A+1BypDK7/xCTrq8/X3fxHXauaKEWg=;
        b=M/EhjQgGQdwTwnF/HcsTdkeh7jieHyV7QTMQsVtmsbmaJjpCKXu4e5lcfoJkYhgF/M
         HxgAZK8JsfOr0XEe3f6OcpXE8ns9BNiwEFvi+okeZhlv5val8YOK18HsQhG+p6YpjniT
         EJPeLWmcXL0z9Gj46HVPFKPY5qR93LPpGyDwP+E3O9SVYu4MasVQAKxw7/DX5WFrKVGQ
         i0xteLJEHraam7ysfeUfaS4Tg3lIuLanmIZp6SMqGvBNXUO5AaJtLgJmlrt2+UOUtK1S
         xDSHKizgp4E6xAy34JcV3uaIwOdn2p4bLH0BnQTw+KkUs8Ud/GYjQopQMYzameuE5fpG
         NxYg==
X-Gm-Message-State: AOAM532rZdiTQ5zjXqmmNhZabfsrPRr4uU1BXPxP2b1+DRq73yFYDqaR
        TfqaUrc37L+QfyLlbpBmXwImjoz2GDPD/pJeWwU=
X-Google-Smtp-Source: ABdhPJz5IZMbJYD7IkddiDAGzYHK9PPzCE1tQIqzi0fayvvKfxhCoNZY3VWERPgURqZ3fiRT3Mz6cRhRAXXRQYFuySo=
X-Received: by 2002:a37:7683:: with SMTP id r125mr2804264qkc.39.1595465818954;
 Wed, 22 Jul 2020 17:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk> <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
 <87mu3zentu.fsf@toke.dk> <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYd4Xrn4EqzqHCTuJ8TnZiTC1vWWvd=9Np+LNrgbtxOcQ@mail.gmail.com>
 <20200720233455.6ito7n2eqojlfnvk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYtD9dGUy3hZRRAA56CaVvW7xTR9tp0dXKyVQXym046eQ@mail.gmail.com>
 <20200722002918.574pruibvlxfblyq@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbdE441MgpEAv+nLBYUXZRz_tzGvmf87rw68hOvT0bwfw@mail.gmail.com> <20200723003236.w2z7sqbd4jjqamgx@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200723003236.w2z7sqbd4jjqamgx@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Jul 2020 17:56:47 -0700
Message-ID: <CAEf4Bzaby8iCwEWHPxiJn2PAf6iOyhgcm_-pfR75z9UvXqk2GA@mail.gmail.com>
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

On Wed, Jul 22, 2020 at 5:32 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jul 21, 2020 at 11:02:04PM -0700, Andrii Nakryiko wrote:
> >
> > Just one technical moment, let me double-check my understanding again.
> > You seem to be favoring pre-creating bpf_tracing_link because there is
> > both tgt_prog (that we refcnt on EXT prog load) and we also lookup and
> > initialize trampoline in check_attach_btf_id(). Of course there is
> > also expected_attach_type, but that's a trivial known enum, so I'm
> > ignoring it. So because we have those two entities which on attach are
> > supposed to be owned by bpf_tracing_link, you just want to pre-create
> > a "shell" of bpf_tracing_link, and then on attach complete its
> > initialization, is that right? That certainly simplifies attach logic
> > a bit and I think it's fine.
>
> Right. It just feels cleaner to group objects for the same purpose.
>
> > But also it seems like we'll be creating and initializing a
> > **different** trampoline on re-attach to prog Y. Now attach will do
> > different things depending on whether tgt_prog_fd is provided or not.
>
> Right, but it can be a common helper instead that is creating a 'shell'
> of bpf_tracing_link.
> Calling it from prog_load and from raw_tp_open is imo clean enough.
> No copy paste of code.
> If that was the concern.
>
> > So I wonder why not just unify this trampoline initialization and do
> > it at attach time? For all valid EXT use cases today the result is the
> > same: everything still works the same. For cases where we for some
> > reason can't initialize bpf_trampoline, that failure will happen at
> > attach time, not on a load time. But that seems fine, because that's
> > going to be the case for re-attach (with tgt_prog_fd) anyways. Looking
> > through the verifier code, it doesn't seem like it does anything much
> > with prog->aux->trampoline, unless I missed something, so it must be
> > ok to do it after load? It also seems to avoid this double BTF
> > validation concern you have, no? Thoughts?
>
> bpf_trampoline_link_prog() is attach time call.
> but bpf_trampoline_lookup() is one to one with the target.
> When load_prog holds the target it's a right time to prep all things
> about the target. Notice that key into trampoline_lookup() is
> key = ((u64)aux->id) << 32 | btf_id;
> of the target prog.
> Can it be done at raw_tp_open time?
> I guess so, but feels kinda weird to me to split the target preparation
> job into several places.

ok, sounds good to me
