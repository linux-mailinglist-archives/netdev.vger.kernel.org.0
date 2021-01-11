Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882E22F21D1
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbhAKVav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbhAKVav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:30:51 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7168C061786;
        Mon, 11 Jan 2021 13:30:10 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id y4so200687ybn.3;
        Mon, 11 Jan 2021 13:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RvGf6kc7zDhdTuhiRUm3rPshEUiVdgSP6fcnsau5qRM=;
        b=pPM8dKyZkJGURUgByBfUGu/47CPJhvUc9rxeTBkyuM+t/LOSuZwQjrW7eD4CfBVuEQ
         mnDo7pfyVFSWmiDibsQkqVwmTtJpaRw4m8XqKXcXZRgIvtfyMQW5MLPGWwZTux34O5rk
         xlKDD6otyaKdC6aJTLzweLrfBZja4otj5LOCi0t6LJdNpdVKhvcL2xvuCJvD3oyEFhww
         pdfvp0kzr45hWV4T3gMYa1gHzq+Y+8Z8MlW7rz6DXCmnwzc52pKuFqKDGh3tvNlNnJWX
         nlCRkyxtpys49X8/PFR6uIh0us7fORKA1yET2j/+zq+hwARAb2neDXeWUkvivZ1QiS5E
         loJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RvGf6kc7zDhdTuhiRUm3rPshEUiVdgSP6fcnsau5qRM=;
        b=couHvd1Z9A7hPNS2AqVAg9gg39DcsMxkg6hpu0RktKpBZ1MO1pmolU+CjxHkyw4bdm
         PleTdt0RCn8L0cddTLNhpAY3Hcixtp8VCtD7Ln2FaJYBPyDWTCVJkmYDZSo4HQS1KsCA
         GloCmtrA2UKNKpaBGdia3GyBDKdh5nGlGSKxbQvfzO77f6oXTkAsHsvUOAktjADx74Kk
         AeDVszI4Ynqq5ERwpGA7bpqPjVg3rMqKxnrNUQ36QUCliedxIudUlgkEk1QShzE0csiZ
         PFlnvPlLww4SkDp1c5/V14oxxnpTnv5NmhwmOqllZQiP85HzFIO4dGBEpkLxuETq1FW0
         g4eQ==
X-Gm-Message-State: AOAM531plBpw8oNqolKx1V91nBpq75g9F+CqW37GDugik9ehmvQHVqZS
        YW7shD7bJMi1iq3vxkEpkJ6k6D9bQP8xeXczvWQ=
X-Google-Smtp-Source: ABdhPJz+as0DOrQQQeAIYCwSAV9Rm7C6yHLisJJC2Hk1JQC2RtH146VOVFqQDFu/gQToVQb/7PS3gAUhsn461GU89yA=
X-Received: by 2002:a25:854a:: with SMTP id f10mr2441756ybn.510.1610400610237;
 Mon, 11 Jan 2021 13:30:10 -0800 (PST)
MIME-Version: 1.0
References: <20210108220930.482456-1-andrii@kernel.org> <20210108220930.482456-6-andrii@kernel.org>
 <b301f6b8-afed-6d55-42d3-6587b75fadb9@fb.com>
In-Reply-To: <b301f6b8-afed-6d55-42d3-6587b75fadb9@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 13:29:59 -0800
Message-ID: <CAEf4BzYtBXr_8HnQEcHn9nQfmMzq_wfdF3jFWzFtOpSF1Uwfug@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/7] bpf: support BPF ksym variables in kernel modules
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 8:13 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> > Add support for directly accessing kernel module variables from BPF programs
> > using special ldimm64 instructions. This functionality builds upon vmlinux
> > ksym support, but extends ldimm64 with src_reg=BPF_PSEUDO_BTF_ID to allow
> > specifying kernel module BTF's FD in insn[1].imm field.
> >
> > During BPF program load time, verifier will resolve FD to BTF object and will
> > take reference on BTF object itself and, for module BTFs, corresponding module
> > as well, to make sure it won't be unloaded from under running BPF program. The
> > mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
> >
> > One interesting change is also in how per-CPU variable is determined. The
> > logic is to find .data..percpu data section in provided BTF, but both vmlinux
> > and module each have their own .data..percpu entries in BTF. So for module's
> > case, the search for DATASEC record needs to look at only module's added BTF
> > types. This is implemented with custom search function.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Ack with a minor nit below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   include/linux/bpf.h          |  10 +++
> >   include/linux/bpf_verifier.h |   3 +
> >   include/linux/btf.h          |   3 +
> >   kernel/bpf/btf.c             |  31 +++++++-
> >   kernel/bpf/core.c            |  23 ++++++
> >   kernel/bpf/verifier.c        | 149 ++++++++++++++++++++++++++++-------
> >   6 files changed, 189 insertions(+), 30 deletions(-)
> >
> [...]
> >   /* replace pseudo btf_id with kernel symbol address */
> >   static int check_pseudo_btf_id(struct bpf_verifier_env *env,
> >                              struct bpf_insn *insn,

[...]

> >       } else {
> >               aux->btf_var.reg_type = PTR_TO_BTF_ID;
> > -             aux->btf_var.btf = btf_vmlinux;
> > +             aux->btf_var.btf = btf;
> >               aux->btf_var.btf_id = type;
> >       }
> > +
> > +     /* check whether we recorded this BTF (and maybe module) already */
> > +     for (i = 0; i < env->used_btf_cnt; i++) {
> > +             if (env->used_btfs[i].btf == btf) {
> > +                     btf_put(btf);
> > +                     return 0;
>
> An alternative way is to change the above code as
>                         err = 0;
>                         goto err_put;

I didn't do it, because it's not really an error case, which err_put
implies. If in the future we'll have some more clean up to do, it
might make sense, I suppose.

>
> > +             }
> > +     }
> > +
> > +     if (env->used_btf_cnt >= MAX_USED_BTFS) {
> > +             err = -E2BIG;
> > +             goto err_put;
> > +     }
> > +
> > +     btf_mod = &env->used_btfs[env->used_btf_cnt];
> > +     btf_mod->btf = btf;
> > +     btf_mod->module = NULL;
> > +
> > +     /* if we reference variables from kernel module, bump its refcount */
> > +     if (btf_is_module(btf)) {
> > +             btf_mod->module = btf_try_get_module(btf);
> > +             if (!btf_mod->module) {
> > +                     err = -ENXIO;
> > +                     goto err_put;
> > +             }
> > +     }
> > +
> > +     env->used_btf_cnt++;
> > +
> >       return 0;
> > +err_put:
> > +     btf_put(btf);
> > +     return err;
> >   }
> >
> [...]
