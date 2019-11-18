Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C93A100C3E
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 20:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfKRTgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 14:36:25 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37207 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfKRTgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 14:36:25 -0500
Received: by mail-qt1-f194.google.com with SMTP id g50so21584366qtb.4;
        Mon, 18 Nov 2019 11:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FqGvQDVHM92kLrVRtf+25CcxGMEqrrwjSRL5oGlFW/o=;
        b=pENOY4BBO7dft1hfwavdDJ3BPhbCGxkn5LeTREUKrR+AHi7nEXebqmZDJoMsuTtigA
         2nbHRVfspMSbL+VnQnBj2BtusZc70qINs7YgTCLuSMTw0cKOzHvmCQs/M6mRkM3ZU1o/
         HGghFFM/wW0myv9yI52yp4gPHvw5FtFfNxz8OQIGPJRELSPeQzllZetOSw0jJZFwVOO2
         DVWbvQnhUp+FFaSPFJ6iuEtW2JLYh5zZ4oEYCsB6l0Z7rSEV/DkgNoBwNzhE72EObYO7
         V3hgc/pQO0jbu14WaTIeeTCGGWs6aANKSYCfkS0pTcxTZJQXoGPuCHBWO+fdGWs4dem8
         s6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FqGvQDVHM92kLrVRtf+25CcxGMEqrrwjSRL5oGlFW/o=;
        b=Ju0TCHNOi7P3ODtRmlcr+9Y/oPv0rfXhDZmZeQpNFrpG5/lo0VUJ88HXqbzdcYfsGM
         rRsp1gPu3Cyh8lw6P0MBw+T7aU/Pjzpu5iePSoj/l/8bgK91gOwIg37lmdHk7xDOC159
         X6CXA3oPF8DuGD+iSFt4edgOvT/w3pqUKk42Nqqx3ewWRpZMiLCsMa0mKLEPFU2zsuke
         Gm4zgn5NoVS68rkS4yxGubnmgXfSnMkA3fppw3md6WzzTSbcFjwr1S5w8X5BVJsDwic7
         fsx1iuXwiqYjoiyTvfLKXQrQwLA7gs+4/09pYheX86OknmiY4C7PW9c0u0XIPJJQiFvV
         8uPQ==
X-Gm-Message-State: APjAAAV2OuEQJBW+Tf1+0xDSBOUha8Idee31OFbXF1zQxv0uQeYrMYjk
        /EuPsfykCKilH4YOhHQHTQ6VSUNeF0SeV+milHk=
X-Google-Smtp-Source: APXvYqwSZ/NQr8SVsuncytOJJdI06Sv9HYHzjUet0/d+FMqqmZVBHBW5hWN33f1lqFC3B7bt9BS0BOVmdZPXeoYBzmU=
X-Received: by 2002:ac8:3fed:: with SMTP id v42mr28468327qtk.171.1574105783237;
 Mon, 18 Nov 2019 11:36:23 -0800 (PST)
MIME-Version: 1.0
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com>
In-Reply-To: <20191113204737.31623-3-bjorn.topel@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Nov 2019 11:36:12 -0800
Message-ID: <CAEf4BzZw+jX13JuiVueKhpufQ9qHEBc0xYtqKdhhUV00afx0Gw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 12:48 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The BPF dispatcher builds on top of the BPF trampoline ideas;
> Introduce bpf_arch_text_poke() and (re-)use the BPF JIT generate
> code. The dispatcher builds a dispatch table for XDP programs, for
> retpoline avoidance. The table is a simple binary search model, so
> lookup is O(log n). Here, the dispatch table is limited to four
> entries (for laziness reason -- only 1B relative jumps :-P). If the
> dispatch table is full, it will fallback to the retpoline path.
>
> An example: A module/driver allocates a dispatcher. The dispatcher is
> shared for all netdevs. Each netdev allocate a slot in the dispatcher
> and a BPF program. The netdev then uses the dispatcher to call the
> correct program with a direct call (actually a tail-call).
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  arch/x86/net/bpf_jit_comp.c |  96 ++++++++++++++++++
>  kernel/bpf/Makefile         |   1 +
>  kernel/bpf/dispatcher.c     | 197 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 294 insertions(+)
>  create mode 100644 kernel/bpf/dispatcher.c
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 28782a1c386e..d75aebf508b8 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -10,10 +10,12 @@
>  #include <linux/if_vlan.h>
>  #include <linux/bpf.h>
>  #include <linux/memory.h>
> +#include <linux/sort.h>
>  #include <asm/extable.h>
>  #include <asm/set_memory.h>
>  #include <asm/nospec-branch.h>
>  #include <asm/text-patching.h>
> +#include <asm/asm-prototypes.h>
>

[...]

> +
> +int arch_prepare_bpf_dispatcher(void *image, struct bpf_prog **progs,
> +                               int num_progs)
> +{
> +       u64 ips[BPF_DISPATCHER_MAX] =3D {};
> +       u8 *fallback, *prog =3D image;
> +       int i, err, cnt =3D 0;
> +
> +       if (!num_progs || num_progs > BPF_DISPATCHER_MAX)
> +               return -EINVAL;
> +
> +       for (i =3D 0; i < num_progs; i++)
> +               ips[i] =3D (u64)progs[i]->bpf_func;
> +
> +       EMIT2(0xEB, 5); /* jmp rip+5 (skip retpoline) */
> +       fallback =3D prog;
> +       err =3D emit_jmp(&prog,   /* jmp retpoline */
> +                      __x86_indirect_thunk_rdx, prog);
> +       if (err)
> +               return err;
> +
> +       sort(&ips[0], num_progs, sizeof(ips[i]), cmp_ips, NULL);

nit: sizeof(ips[i]) looks weird...

> +       return emit_bpf_dispatcher(&prog, 0, num_progs - 1, &ips[0], fall=
back);
> +}
> +
>  struct x64_jit_data {
>         struct bpf_binary_header *header;
>         int *addrs;

[...]

> +
> +static int bpf_dispatcher_add_prog(struct bpf_dispatcher *d,
> +                                  struct bpf_prog *prog)
> +{
> +       struct bpf_prog **entry =3D NULL;
> +       int i, err =3D 0;
> +
> +       if (d->num_progs =3D=3D BPF_DISPATCHER_MAX)
> +               return err;

err =3D=3D 0, not what you want, probably

> +
> +       for (i =3D 0; i < BPF_DISPATCHER_MAX; i++) {
> +               if (!entry && !d->progs[i])
> +                       entry =3D &d->progs[i];
> +               if (d->progs[i] =3D=3D prog)
> +                       return err;
> +       }
> +
> +       prog =3D bpf_prog_inc(prog);
> +       if (IS_ERR(prog))
> +               return err;
> +
> +       *entry =3D prog;
> +       d->num_progs++;
> +       return err;
> +}
> +
> +static void bpf_dispatcher_remove_prog(struct bpf_dispatcher *d,
> +                                      struct bpf_prog *prog)
> +{
> +       int i;
> +
> +       for (i =3D 0; i < BPF_DISPATCHER_MAX; i++) {
> +               if (d->progs[i] =3D=3D prog) {
> +                       bpf_prog_put(prog);
> +                       d->progs[i] =3D NULL;
> +                       d->num_progs--;

instead of allowing holes, why not swap removed prog with the last on
in d->progs?

> +                       break;
> +               }
> +       }
> +}
> +
> +int __weak arch_prepare_bpf_dispatcher(void *image, struct bpf_prog **pr=
ogs,
> +                                      int num_ids)
> +{
> +       return -ENOTSUPP;
> +}
> +
> +/* NB! bpf_dispatcher_update() might free the dispatcher! */
> +static int bpf_dispatcher_update(struct bpf_dispatcher *d)
> +{
> +       void *old_image =3D d->image + ((d->selector + 1) & 1) * PAGE_SIZ=
E / 2;
> +       void *new_image =3D d->image + (d->selector & 1) * PAGE_SIZE / 2;
> +       int err;
> +
> +       if (d->num_progs =3D=3D 0) {
> +               err =3D bpf_arch_text_poke(d->func, BPF_MOD_JMP_TO_NOP,
> +                                        old_image, NULL);
> +               bpf_dispatcher_free(d);
> +               goto out;
> +       }
> +
> +       err =3D arch_prepare_bpf_dispatcher(new_image, &d->progs[0],
> +                                         d->num_progs);
> +       if (err)
> +               goto out;
> +
> +       if (d->selector)
> +               /* progs already running at this address */
> +               err =3D bpf_arch_text_poke(d->func, BPF_MOD_JMP_TO_JMP,
> +                                        old_image, new_image);
> +       else
> +               /* first time registering */
> +               err =3D bpf_arch_text_poke(d->func, BPF_MOD_NOP_TO_JMP,
> +                                        NULL, new_image);
> +
> +       if (err)
> +               goto out;
> +       d->selector++;
> +
> +out:
> +       return err;
> +}
> +
> +void bpf_dispatcher_change_prog(void *func, struct bpf_prog *from,
> +                               struct bpf_prog *to)
> +{
> +       struct bpf_dispatcher *d;
> +
> +       if (!from && !to)
> +               return;
> +
> +       mutex_lock(&dispatcher_mutex);
> +       d =3D bpf_dispatcher_lookup(func);
> +       if (!d)
> +               goto out;
> +
> +       if (from)
> +               bpf_dispatcher_remove_prog(d, from);
> +
> +       if (to)
> +               bpf_dispatcher_add_prog(d, to);

this can fail

> +
> +       WARN_ON(bpf_dispatcher_update(d));

shouldn't dispatcher be removed from the list before freed? It seems
like handling dispatches freeing is better done here explicitly (and
you won't need to leave a NB remark)

> +
> +out:
> +       mutex_unlock(&dispatcher_mutex);
> +}
> +
> +static int __init init_dispatchers(void)
> +{
> +       int i;
> +
> +       for (i =3D 0; i < DISPATCHER_TABLE_SIZE; i++)
> +               INIT_HLIST_HEAD(&dispatcher_table[i]);
> +       return 0;
> +}
> +late_initcall(init_dispatchers);
> +
> +#endif
> --
> 2.20.1
>
