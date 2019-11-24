Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF972108264
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 07:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfKXGzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 01:55:22 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38189 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfKXGzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 01:55:22 -0500
Received: by mail-qk1-f194.google.com with SMTP id e2so10008727qkn.5;
        Sat, 23 Nov 2019 22:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pg/2zvDecEDrbGcuE8bZ7gVLYNmiahgMqCGafpaf9a0=;
        b=Moqqs33SSY1ZnBgmzaP/fNGoqpKiOmvpDxlozVXFih2R0NuSa95KbuucVb19uBMKb/
         ESwNgWPW2bVDqPmWoGh4s8z3uRZVARlpGKQIH1kSYLrkLoojAz1wyCawwC29t8nzs020
         0UQak9/29pAAgHf6iqUuL/SQ/quENX79l/gJRE4SW4LzIVrLvZ9+OERSFkT/y58xVWOs
         1he56fSB7GP4iUsHvHePDvbh+iz8hzDjpHKl1tYeregIBv6gGGiuH/cFi9CIETI7EQ2w
         rQ8fGWeUZXKmwiIN9iBUMnKg2yXr+n1W1tXQd+XtKrf9mp6L8wl0gGoxRzHwwKMZjFxC
         hO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pg/2zvDecEDrbGcuE8bZ7gVLYNmiahgMqCGafpaf9a0=;
        b=VQR6bbT2qqeRul+7onwWAoLVw+JuJ7Aj1D/bSpTBrYE0ebdS4zWT6r+BylAopq1BKC
         MUKElkepO1GOsgYORbzO5BhAucHNkbkPuuwkBdv8NzP04yYp4zGKyAO0R94KJa0KHRJr
         CKY9Qt25rswa33yWpZVQKMQKvn5zFJDyrfxQlK4OcbWtGZxB8875AdKxh+N2mRf0Ad5e
         DQFqLlVZ4jV8FmqxyIXqfVa73FboZeLTntLFNdvrJ1ljKraVv2RsCSnhpamg6naCxevT
         jL+x3RAimJQvla2zUUNO6kxaNCW3UNEbDufT5v7/XwoFivnZqzCUE63TQl7PkOxK+1Ho
         MTzQ==
X-Gm-Message-State: APjAAAV5PkjHtukFVh77ekkJGSOk2IviuLz49CmphJj23vwyPWg2paAr
        vMBRxUuJZWHTjMTTGyfItBguFRRPDmBBt6KSXiA=
X-Google-Smtp-Source: APXvYqxUb88/yMstPztyy+bjom+7M/lNmRuVQwHGcULRAckCtXzZnH9UjvscYcZqteqT9MhNqC9K8IncXdheb86VCQg=
X-Received: by 2002:a37:aa45:: with SMTP id t66mr3933432qke.218.1574578519243;
 Sat, 23 Nov 2019 22:55:19 -0800 (PST)
MIME-Version: 1.0
References: <20191123071226.6501-1-bjorn.topel@gmail.com> <20191123071226.6501-2-bjorn.topel@gmail.com>
 <20191124015504.yypqw4gx52e5e6og@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191124015504.yypqw4gx52e5e6og@ast-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sun, 24 Nov 2019 07:55:07 +0100
Message-ID: <CAJ+HfNhtgvRyvnNT7_iSs9RD3rV_y8++pLddWy+i+Eya5_BJVw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/6] bpf: introduce BPF dispatcher
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Nov 2019 at 02:55, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Nov 23, 2019 at 08:12:20AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > +
> > +             err =3D emit_jump(&prog,                  /* jmp thunk */
> > +                             __x86_indirect_thunk_rdx, prog);
>
> could you please add a comment that this is gcc specific and gate it
> by build_bug_on ?
> I think even if compiler stays the change of flags:
> RETPOLINE_CFLAGS_GCC :=3D -mindirect-branch=3Dthunk-extern -mindirect-bra=
nch-register
> may change the name of this helper?
> I wonder whether it's possible to make it compiler independent.
>
> > diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> > new file mode 100644
> > index 000000000000..385dd76ab6d2
> > --- /dev/null
> > +++ b/kernel/bpf/dispatcher.c
> > @@ -0,0 +1,208 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright(c) 2019 Intel Corporation. */
> > +
> > +#ifdef CONFIG_RETPOLINE
>
> I'm worried that such strong gating will make the code rot. Especially it=
's not
> covered by selftests.
> Could you please add xdp_call_run() to generic xdp and add a selftest ?
> Also could you please benchmark it without retpoline?
> iirc direct call is often faster than indirect, so I suspect this optimiz=
ation
> may benefit non-mitigated kernels.
>
> > +#define DISPATCHER_HASH_BITS 10
> > +#define DISPATCHER_TABLE_SIZE (1 << DISPATCHER_HASH_BITS)
> > +
> > +static struct hlist_head dispatcher_table[DISPATCHER_TABLE_SIZE];
>
> there is one DEFINE_XDP_CALL per driver, so total number of such
> dispatch routines is pretty small. 1<<10 hash table is overkill.
> The hash table itself is overkill :)
>
> How about adding below:
>
> > +#define BPF_DISPATCHER_MAX 16
> > +
> > +struct bpf_dispatcher {
> > +     struct hlist_node hlist;
> > +     void *func;
> > +     struct bpf_prog *progs[BPF_DISPATCHER_MAX];
> > +     int num_progs;
> > +     void *image;
> > +     u64 selector;
> > +};
>
> without hlist and without func to DEFINE_XDP_CALL() macro?
> Then bpf_dispatcher_lookup() will become bpf_dispatcher_init()
> and the rest will become a bit simpler?
>
> > +
> > +     set_vm_flush_reset_perms(image);
> > +     set_memory_x((long)image, 1);
> > +     d->image =3D image;
>
> Can you add a common helper for this bit to share between
> bpf dispatch and bpf trampoline?
>
> > +static void bpf_dispatcher_update(struct bpf_dispatcher *d)
> > +{
> > +     void *old_image =3D d->image + ((d->selector + 1) & 1) * PAGE_SIZ=
E / 2;
> > +     void *new_image =3D d->image + (d->selector & 1) * PAGE_SIZE / 2;
> > +     s64 ips[BPF_DISPATCHER_MAX] =3D {}, *ipsp =3D &ips[0];
> > +     int i, err;
> > +
> > +     if (!d->num_progs) {
> > +             bpf_arch_text_poke(d->func, BPF_MOD_JUMP_TO_NOP,
> > +                                old_image, NULL);
> > +             return;
>
> how does it work? Without doing d->selector =3D 0; the next addition
> will try to do JUMP_TO_JUMP and will fail...
>
> > +     }
> > +
> > +     for (i =3D 0; i < BPF_DISPATCHER_MAX; i++) {
> > +             if (d->progs[i])
> > +                     *ipsp++ =3D (s64)(uintptr_t)d->progs[i]->bpf_func=
;
> > +     }
> > +     err =3D arch_prepare_bpf_dispatcher(new_image, &ips[0], d->num_pr=
ogs);
> > +     if (err)
> > +             return;
> > +
> > +     if (d->selector) {
> > +             /* progs already running at this address */
> > +             err =3D bpf_arch_text_poke(d->func, BPF_MOD_JUMP_TO_JUMP,
> > +                                      old_image, new_image);
> > +     } else {
> > +             /* first time registering */
> > +             err =3D bpf_arch_text_poke(d->func, BPF_MOD_NOP_TO_JUMP,
> > +                                      NULL, new_image);
> > +     }
> > +     if (err)
> > +             return;
> > +     d->selector++;
> > +}
>
> Not sure how to share selector logic between dispatch and trampoline.
> But above selector=3D0; weirdness is a sign that sharing is probably nece=
ssary?
>
> > +
> > +void bpf_dispatcher_change_prog(void *func, struct bpf_prog *from,
> > +                             struct bpf_prog *to)
> > +{
> > +     struct bpf_dispatcher *d;
> > +     bool changed =3D false;
> > +
> > +     if (from =3D=3D to)
> > +             return;
> > +
> > +     mutex_lock(&dispatcher_mutex);
> > +     d =3D bpf_dispatcher_lookup(func);
> > +     if (!d)
> > +             goto out;
> > +
> > +     changed |=3D bpf_dispatcher_remove_prog(d, from);
> > +     changed |=3D bpf_dispatcher_add_prog(d, to);
> > +
> > +     if (!changed)
> > +             goto out;
> > +
> > +     bpf_dispatcher_update(d);
> > +     if (!d->num_progs)
> > +             bpf_dispatcher_free(d);
>
> I think I got it why it works.
> Every time the prog cnt goes to zero you free the trampoline right away
> and next time it will be allocated again and kzalloc() will zero selector=
.
> That's hard to spot.
> Also if user space does for(;;) attach/detach;
> it will keep stressing bpf_jit_alloc_exec.
> In case of bpf trampoline attach/detach won't be stressing it.
> Only load/unload which are much slower due to verification.
> I guess such difference is ok.
>

Alexei, thanks for all feedback (on the weekend)! I agree with all of
above, and especially missing selftests and too much code duplication.

I'll do a respin, but that'll be in the next window, given that Linus
will (probably) tag the release today.


Bj=C3=B6rn
