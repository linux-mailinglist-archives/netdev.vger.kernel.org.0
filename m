Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F11F2D2188
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgLHDle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgLHDle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:41:34 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC609C061749;
        Mon,  7 Dec 2020 19:40:53 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id o71so14942107ybc.2;
        Mon, 07 Dec 2020 19:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O9mdzfe9NnrK0MpmIUCaPuIbBKHgZ43YDM2J3J3vi/0=;
        b=J0ZwgTp/efh2sCLW/Hs6kYmkoqxXrd4FwKCoLfRJctAZUa3sB6qIOwDJ79UIo37bGx
         0lTrx8Q2e8iqc8yJOZ62hLsYctt0J0WB0mAu2w1gJZpMfPz8sv5z00ioDskwAhCVuHhs
         z3aLSfLIVIoN5JEN7QMhexiiqmdg3pveJT7Y9ceE4VmSRVDsdJs9Jifi1XTfGKQdHhZ/
         LcBkvhZAQp7ORv2BTduy/BOd25e4UZaaCw7EtlMbs1fzAy/cfl+BXbh/iX1/J9u/fZ1Q
         JK+3GiQAuT6jEOqZAcdcSSfDmp88qzGV4iFbhCB2efOOVQVBxZMCZgKIOdufGng/CAZ2
         Ybkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O9mdzfe9NnrK0MpmIUCaPuIbBKHgZ43YDM2J3J3vi/0=;
        b=prNSxg9voqTrvOzT8GBdIOfaiXmviXYHd59yck+JuOvuqnvWFe6ukJPwYqiIvJUIbM
         upCMNIJvIfAip2tGNhuV6HlOSZBnQn2Bj5wWqa9BIFQAy56sN0fK0B9hvW3EReCazxf+
         pryYWlq9PUKIdPcIMkDjz3sS/ZyyCDaIE9eNRulxrkwPmRqsksOCwwIaZUVO7nSUH1q8
         hTnb2nlymgHO69VO8XouAKtgmJcZNVwc4jsOi9g/uFf+n3QoQPkwKA+8bRVzdcQTu1uT
         IQRCbO0d8UsWnTHLbZaeczn4o0h5ebIBfLfmK2krNJC5JdOzA6EflZoUEzJipqwtfI6k
         tyPw==
X-Gm-Message-State: AOAM532Y6YWNFT/hwhFJrym+gLfJzgfvgKIFoZBe/M48zv4p00vPkBUw
        eYqr4P7BlqePoqfTaxmDgpPy1yIeyPvP9U4NO0I=
X-Google-Smtp-Source: ABdhPJzOPYUk5Rep/Eayi++ddOu8+HIj8BAZMm8YgjKgNM8uKAyfb3VC4d9D84pwDoi/QDWSDQ/E16s8zBR4uNjVC9E=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr10289159ybg.27.1607398853059;
 Mon, 07 Dec 2020 19:40:53 -0800 (PST)
MIME-Version: 1.0
References: <20201205025140.443115-1-andrii@kernel.org> <alpine.LRH.2.23.451.2012071623080.3652@localhost>
 <20201208031206.26mpjdbrvqljj7vl@ast-mbp>
In-Reply-To: <20201208031206.26mpjdbrvqljj7vl@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Dec 2020 19:40:42 -0800
Message-ID: <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: support module BTF for
 BPF_TYPE_ID_TARGET CO-RE relocation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 7:12 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Dec 07, 2020 at 04:38:16PM +0000, Alan Maguire wrote:
> > On Fri, 4 Dec 2020, Andrii Nakryiko wrote:
> >
> > > When Clang emits ldimm64 instruction for BPF_TYPE_ID_TARGET CO-RE relocation,
> > > put module BTF FD, containing target type, into upper 32 bits of imm64.
> > >
> > > Because this FD is internal to libbpf, it's very cumbersome to test this in
> > > selftests. Manual testing was performed with debug log messages sprinkled
> > > across selftests and libbpf, confirming expected values are substituted.
> > > Better testing will be performed as part of the work adding module BTF types
> > > support to  bpf_snprintf_btf() helpers.
> > >
> > > Cc: Alan Maguire <alan.maguire@oracle.com>
> > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 19 ++++++++++++++++---
> > >  1 file changed, 16 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 9be88a90a4aa..539956f7920a 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -4795,6 +4795,7 @@ static int load_module_btfs(struct bpf_object *obj)
> > >
> > >             mod_btf = &obj->btf_modules[obj->btf_module_cnt++];
> > >
> > > +           btf__set_fd(btf, fd);
> > >             mod_btf->btf = btf;
> > >             mod_btf->id = id;
> > >             mod_btf->fd = fd;
> > > @@ -5445,6 +5446,10 @@ struct bpf_core_relo_res
> > >     __u32 orig_type_id;
> > >     __u32 new_sz;
> > >     __u32 new_type_id;
> > > +   /* FD of the module BTF containing the target candidate, or 0 for
> > > +    * vmlinux BTF
> > > +    */
> > > +   int btf_obj_fd;
> > >  };
> > >
> > >  /* Calculate original and target relocation values, given local and target
> > > @@ -5469,6 +5474,7 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
> > >     res->fail_memsz_adjust = false;
> > >     res->orig_sz = res->new_sz = 0;
> > >     res->orig_type_id = res->new_type_id = 0;
> > > +   res->btf_obj_fd = 0;
> > >
> > >     if (core_relo_is_field_based(relo->kind)) {
> > >             err = bpf_core_calc_field_relo(prog, relo, local_spec,
> > > @@ -5519,6 +5525,9 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
> > >     } else if (core_relo_is_type_based(relo->kind)) {
> > >             err = bpf_core_calc_type_relo(relo, local_spec, &res->orig_val);
> > >             err = err ?: bpf_core_calc_type_relo(relo, targ_spec, &res->new_val);
> > > +           if (!err && relo->kind == BPF_TYPE_ID_TARGET &&
> > > +               targ_spec->btf != prog->obj->btf_vmlinux)
> > > +                   res->btf_obj_fd = btf__fd(targ_spec->btf);
> >
> > Sorry about this Andrii, but I'm a bit stuck here.
> >
> > I'm struggling to get tests working where the obj fd is used to designate
> > the module BTF. Unless I'm missing something there are a few problems:
> >
> > - the fd association is removed by libbpf when the BPF program has loaded;
> > the module fds are closed and the module BTF is discarded.  However even if
> > that isn't done (and as you mentioned, we could hold onto BTF that is in
> > use, and I commented out the code that does that to test) - there's
> > another problem:
> > - I can't see a way to use the object fd value we set here later in BPF
> > program context; btf_get_by_fd() returns -EBADF as the fd is associated
> > with the module BTF in the test's process context, not necessarily in
> > the context that the BPF program is running.  Would it be possible in this
> > case to use object id? Or is there another way to handle the fd->module
> > BTF association that we need to make in BPF program context that I'm
> > missing?
> > - A more long-term issue; if we use fds to specify module BTFs and write
> > the object fd into the program, we can pin the BPF program such that it
> > outlives fds that refer to its associated BTF.  So unless we pinned the
> > BTF too, any code that assumed the BTF fd-> module mapping was valid would
> > start to break once the user-space side went away and the pinned program
> > persisted.
>
> All of the above are not issues. They are features of FD based approach.
> When the program refers to btf via fd the verifier needs to increment btf's refcnt
> so it won't go away while the prog is running. For module's BTF it means
> that the module can be unloaded, but its BTF may stay around if there is a prog
> that needs to access it.
> I think the missing piece in the above is that btf_get_by_fd() should be
> done at load time instead of program run-time.
> Everything FD based needs to behave similar to map_fds where ld_imm64 insn
> contains map_fd that gets converted to map_ptr by the verifier at load time.

Right. I was going to extend verifier to do the same for all used BTF
objects as part of ksym support for module BTFs. So totally agree.
Just didn't need it so far.

> In this case single ld_imm64 with 32-bit FD + 32-bit btf_id is not enough.
> So either libbpf or the verifier need to insert additional instruction.

So this part I haven't investigated in detail yet. But, if we are just
talking about keeping struct btf * pointer + BTF type id (u32) in a
single ldimm64, we actually have enough space by using both off + imm
fields in both parts of ldimm64 instruction. Gives exactly 8 + 4
bytes. But I don't know if the problem you are referring to is in the
JIT part.

Also, for the ldimm64 instruction generated by
__builtin_btf_type_id(), btf fd + btf type id are always the same,
regardless of code path, so we can easily use bpf_insn_aux_data to
keep any extra data there, no?

> I'm not sure yet how to extend 'struct btf_ptr' cleanly, so it looks good
> from C side.
> In the other patch I saw:
> struct btf_ptr {
>         void *ptr;
>         __u32 type_id;
> -       __u32 flags;            /* BTF ptr flags; unused at present. */
> +       __u32 obj_id;           /* BTF object; vmlinux if 0 */
>  };
> The removal of flags cannot be done, since it will break progs.

This was something that I suggested to avoid extra logic based on the
size of btf_ptr. Not super critical. The idea was that flags so far
were always enforced to be zero, which make it backwards compatible
and we can now re-use it instead for module BTF fd. If we need flags
later, then we can extend it. But as I said, it's not a critical part
of the design, so I won't fight that :)

> Probably something like this:
> struct btf_ptr {
>   void *ptr;
>   __u32 type_id;
>   __u32 flags;
>   __u64 btf_obj_fd; /* this is 32-bit FD for libbpf which will become pointer after load */
> };
> would be the most convenient from the bpf prog side. The ld_imm64 init of
> btf_obj_fd will be replaced with absolute btf pointer by the verifier. So when
> bpf_snprintf_btf() is called the prog will pass the kernel internal pointer
> of struct btf to the helper. No extra run-time checks needed.
> bpf_snprintf_btf() would print that type_id within given struct btf object.
> libbpf would need to deal with two relos. One to store btf_id from
> bpf_core_type_id_kernel() into type_id. And another to find module's BTF and
> store its FD into btf_obj_fd with ld_imm64. I'm still thinking to how to frame

So the latter we can do as yet another type of type-based CO-RE
relocation, if needed. But if we do that, we should probably revert
current __builtin_type_id(TYPE_ID_REMOTE) to just emit 32-bit register
assignment (no ldimm64).

As for how the verifier would translate such FD into struct btf *
pointer. We have something similar today with ldimm64 with
BPF_PSEUDO_BTF_ID, which resolves into kernel variables. Let's think
if we can re-use that, or we can just add another BPF_PSEUDO_xxx
"flavor"?

> that cleanly from C side.
> Other ideas?

I'll need to think a bit more about this. But some thoughts I've got so far.
