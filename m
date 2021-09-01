Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887163FD017
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242522AbhIAADJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241638AbhIAADH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:03:07 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3858C061575;
        Tue, 31 Aug 2021 17:02:11 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id e133so1881102ybh.0;
        Tue, 31 Aug 2021 17:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJROg9nKYeDHsPA+zUJoTFsTIZiswC6JkF6rV7YqPh4=;
        b=TmbhOH6QnaYA8KwUtrcoqZwnHztDiSm3QboMYBB7XlBGLmjiJV+REGCTrIVLkkZPm/
         DNh43A8ZKhWyRrtQ7/Lzd4s9/L24ha+9FyoCpaENiLsrxBRFbaTSZqv5I9pIDDMnt8af
         eVBvlFuUhFgKw9budzyVoLjcZVHrVNIJ9mWBEu54KkbM5QefQGd+6wuhDuoP5Truob6K
         64BFx1d2GWLkIV/+IDYXXqzRkowcB/ZLKlKgStZcnoxgfD76adv1SraAJmQ6LiwblB/5
         EJrZfU5fUJ2tmDs+huuKkJQLdrbWDMFkEds1WmJer4BWpxSah0OFr5/TeIcOIEQ+w7RD
         60Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJROg9nKYeDHsPA+zUJoTFsTIZiswC6JkF6rV7YqPh4=;
        b=nDDEtZSljW/9FLL3Kh+3lJL19AQQt1t8mi3caZ0DztDVTB3TNJnJgnFWsNK5GQwnTu
         hfszdr2jhg8q6TpCA9KHaXnHtXNFaVrjmHk11neDq23P5QkPgmZO6mPXwJmcQ/LQsHTv
         pLDs4vPYz+swLhrrO0EcvbSX8RdT7b2SdPsfV9QZxq8XVCnmhtNUAzmI88ZjDcx6ehHp
         AjdxyHrsi5T3oexkvneOgvL3bIgkAgQKlAc8cROlQaM92UUmufeXBeHJ6cpcyfq39hRk
         x0loOLNAnHeI1TcJwtk6ZBmP4iytxG1dfiY6hTUFqVjKAUUFy4ojW4g+Visl7a7Z+xp8
         SqMA==
X-Gm-Message-State: AOAM531P7aFlrC78Ilxguhp8csR7K84XBhwJoOBPBMk/8LbnIp5Be85F
        0XnCbZss0Cg3kl8n4OzMx1ayshfQD61prSE+Xn8FlFxR
X-Google-Smtp-Source: ABdhPJxVp5giCBTW8ND2KTzbfXQ1BtZI8EgREuyQunWcRnzXUngma0wLPfhQCK108Vh4FWwOivPl5ZRKB6rB9Ti1EaE=
X-Received: by 2002:a25:bb13:: with SMTP id z19mr35589933ybg.347.1630454531213;
 Tue, 31 Aug 2021 17:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210826193922.66204-1-jolsa@kernel.org> <20210826193922.66204-18-jolsa@kernel.org>
 <CAEf4BzbvhgG8uLtkWHYmTBzKnPSJOLAmqDum0tZn1LNVi-8-nw@mail.gmail.com>
In-Reply-To: <CAEf4BzbvhgG8uLtkWHYmTBzKnPSJOLAmqDum0tZn1LNVi-8-nw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 17:02:00 -0700
Message-ID: <CAEf4Bza5wz49r0QfuJ8d_3bxw9Cy3D_vGtFPkQ1OUJDQn6XKbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 17/27] bpf: Add multi trampoline attach support
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 4:36 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Aug 26, 2021 at 12:41 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding new multi trampoline link (BPF_LINK_TYPE_TRACING_MULTI)
> > as an interface to attach program to multiple functions.
> >
> > The link_create bpf_attr interface already has 'bpf_prog' file
> > descriptor, that defines the program to be attached. It must be
> > loaded with BPF_F_MULTI_FUNC flag.
> >
> > Adding new multi_btf_ids/multi_btf_ids_cnt link_create bpf_attr
> > fields that provides BTF ids.
> >
> > The new link gets multi trampoline (via bpf_trampoline_multi_get)
> > and links the provided program with embedded trampolines and the
> > 'main' trampoline with new multi link/unlink functions:
> >
> >   int bpf_trampoline_multi_link_prog(struct bpf_prog *prog,
> >                                      struct bpf_trampoline_multi *tr);
> >   int bpf_trampoline_multi_unlink_prog(struct bpf_prog *prog,
> >                                        struct bpf_trampoline_multi *tr);
> >
> > If embedded trampoline contains fexit programs, we need to switch
> > its model to the multi trampoline model (because of the final 'ret'
> > argument). We keep the count of attached multi func programs for each
> > trampoline, so we can tell when to switch the model.

Related to my comments on the next patch, if we switch the order of
return value and always reserve 6 slots for input args, regardless of
the actual number of function input args, that should make this
upgrade logic unnecessary, right?

> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf.h            |   5 ++
> >  include/uapi/linux/bpf.h       |   5 ++
> >  kernel/bpf/core.c              |   1 +
> >  kernel/bpf/syscall.c           | 120 +++++++++++++++++++++++++++++++++
> >  kernel/bpf/trampoline.c        |  87 ++++++++++++++++++++++--
> >  tools/include/uapi/linux/bpf.h |   5 ++
> >  6 files changed, 219 insertions(+), 4 deletions(-)
> >
>
> [...]
>
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 1f9d336861f0..9533200ffadf 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1008,6 +1008,7 @@ enum bpf_link_type {
> >         BPF_LINK_TYPE_NETNS = 5,
> >         BPF_LINK_TYPE_XDP = 6,
> >         BPF_LINK_TYPE_PERF_EVENT = 7,
> > +       BPF_LINK_TYPE_TRACING_MULTI = 8,
> >
> >         MAX_BPF_LINK_TYPE,
> >  };
> > @@ -1462,6 +1463,10 @@ union bpf_attr {
> >                                  */
> >                                 __u64           bpf_cookie;
> >                         } perf_event;
> > +                       struct {
> > +                               __aligned_u64   multi_btf_ids;          /* addresses to attach */
> > +                               __u32           multi_btf_ids_cnt;      /* addresses count */
> > +                       };
>
> Please follow the pattern of perf_event, name this struct "multi".
>
> >                 };
> >         } link_create;
> >
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index bad03dde97a2..6c16ac43dd91 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
>
> [...]
>
> > +
> > +       bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING_MULTI,
> > +                     &bpf_tracing_multi_link_lops, prog);
> > +       link->attach_type = prog->expected_attach_type;
> > +       link->multi = multi;
> > +
> > +       err = bpf_link_prime(&link->link, &link_primer);
> > +       if (err)
> > +               goto out_free;
> > +       err = bpf_trampoline_multi_link_prog(prog, multi);
> > +       if (err)
> > +               goto out_free;
>
> bpf_link_cleanup(), can't free link after priming. Look at other
> places using bpf_link.
>
>
> > +       return bpf_link_settle(&link_primer);
> > +
> > +out_free:
> > +       bpf_trampoline_multi_put(multi);
> > +       kfree(link);
> > +out_free_ids:
> > +       kfree(btf_ids);
> > +       return err;
> > +}
> > +
>
> [...]
