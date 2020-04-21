Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FFA1B3219
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 23:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgDUVta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 17:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgDUVt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 17:49:29 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F13C0610D5;
        Tue, 21 Apr 2020 14:49:29 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id v10so3301527qvr.2;
        Tue, 21 Apr 2020 14:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HlobnsamuaJir+BuWuVJAFrORgSh+GZQTDJieK+KurI=;
        b=JW1VLAjw+XdVtJZStaU+ubD0AHQRcvgGzZZDlFV8FtxuJH8T8El1F5EclmqoBy6ltO
         bxxg+vs2RUzbzNAScvIwnjlfoziMaBlEnJkszYSMoGmfnYVwO6c27ShknaSNKEcaziRT
         2R/caaY+tiUcBL8yB4ruhOE0YDc1gDWFLfSUgqgKPGxg0u8eUwpVHVobX8BsGXE7KgX5
         z+masLScG/LrTaZD49YGQwpN2BJqxiJRJyFXq4M1Qf8bAXD79p1DuPIp6iwyuLf7PIbL
         43Z8HHXpnW5sU8RJiK4bdGxPrCM+JckUM5nRZ5vIMxJfcfsIpBRhiaA9Kv8QA8v60zUr
         jKVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HlobnsamuaJir+BuWuVJAFrORgSh+GZQTDJieK+KurI=;
        b=XsS+VrJHkAF9wRQR61kTr3DtUna77NGO+DKqWhvs2f8wb1WmcNr7qtt52bON+Mp1le
         CCk9EqzqUeC+ZWleZlM7H49Yht0Df6Bz98iwZf0+t/9zsCyMpbLiJ7mTM7yOdWLySmOV
         Ha7uewz/TvjM25fbRK1H9YCU5Io3V9Nf9goknzWqkU5jdXVXC1fvo6jY1dUnspiufn+L
         zeAGxpscvXvAwrRmssjXdivMLiDb040oen06Tl7+uG/gTgXRrhRe+WwICEBLXtDzF29P
         7OgTu+kdRITmfOhSJHtoiGjQiNGxsPlFfo3250iCsgUBwEmVZ17poh6IRrY7uhgdGwFo
         lIDw==
X-Gm-Message-State: AGi0PuYZ0pDXOxiyvDD6o9MvkDY6hE0rBcXh7Cz0n1NnYZFe3ZAK+DW/
        3qTbTn8H7zUo0MaU1iCil6JDfuQGSipF6Mfcd0g=
X-Google-Smtp-Source: APiQypLbFmUS5KmD4fMiIXc/5ExaWkSlCsSBYwEd/JWJ3vppr67ZQsHM9cMIN2Hx8c4SM4lsFznqmFZc6pxF0ENcRvo=
X-Received: by 2002:a0c:eb09:: with SMTP id j9mr274761qvp.196.1587505768851;
 Tue, 21 Apr 2020 14:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200301081045.3491005-1-andriin@fb.com> <20200303005951.72szj5sb5rveh4xp@ast-mbp>
 <CAEf4BzYsC-5j_+je1pZ_JNsyuPV9_JrLSzpp6tfUvm=3KBNL-A@mail.gmail.com> <CAEf4Bza+oHc4eJESnPCQh0rRcKtPWqu3SYkzP52B4BLu2O0=6w@mail.gmail.com>
In-Reply-To: <CAEf4Bza+oHc4eJESnPCQh0rRcKtPWqu3SYkzP52B4BLu2O0=6w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Apr 2020 14:49:17 -0700
Message-ID: <CAEf4BzbOw3=NAMA4GJq9s6KvDHfh9a3_vTHM940P+jYWfoty2Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Improve raw tracepoint BTF types preservation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 8:59 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Mar 2, 2020 at 8:10 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Mar 2, 2020 at 4:59 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Sun, Mar 01, 2020 at 12:10:42AM -0800, Andrii Nakryiko wrote:
> > > > Fix issue with not preserving btf_trace_##call structs when compiled under
> > > > Clang. Additionally, capture raw tracepoint arguments in raw_tp_##call
> > > > structs, directly usable from BPF programs. Convert runqslower to use those
> > > > for proof of concept and to simplify code further.
> > >
> > > Not only folks compile kernel with clang they use the latest BPF/BTF features
> > > with it. This is very nice to see!
> > > I've applied 1st patch to make clang compiled kernel emit proper BTF.
> > >
> > > As far as patch 2 I'm not sure about 'raw_tp_' prefix. tp_btf type of progs can
> > > use the same structs. So I think there could be a better name. Also bpftool can
> > > generate them as well while emitting vmlinux.h. I think that will avoid adding
> > > few kilobytes to vmlinux BTF that kernel isn't going to use atm.
> >
> > Fair enough, I'll follow up with bpftool changes to generate such
> > structs. I'm thinking to use tp_args_xxx name pattern, unless someone
> > has a better idea :)
>
> Bad news. BTF_KIND_FUNC_PROTOs don't capture argument names and having
> something like:
>
> struct tp_args_sched_switch {
>     bool arg1;
>     struct task_struct *arg2;
>     struct task_struct *arg3;
> };
>
> doesn't seem like a good solution...

I'd like to surface this one more time. I'd like to give just a bit
more context first, though.

Currently, when using various types of BPF programs (kprobe,
fentry/fexit, lsm, etc), one can use few ways to extract input
arguments of the "intercepted" function. One of the more user-friendly
ways to do it is through BPF_PROG macro. So BPF code would look like
this:

SEC("lsm/file_mprotect")
int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
             unsigned long reqprot, unsigned long prot, int ret)
{
    if (ret != 0) { ... }
    /* use cma, reqprot, etc directly as variables */
}

This is kind of nice, but involves quite a bit of macro magic and
requires user to find and copy/paste those function prototypes and
track whether they ever change.

The alternative for this would be to have a memory-layout-compatible
struct, that can be used directly as a context. For the above example:

struct btf_lsm_file_mprotect_ctx {
    struct vm_area_struct *vma;
    unsigned long reqprot;
    int ret __attribute__((aligned(8)));
};

With that, one can do a nice pure C code:

int test_int_hook(struct btf_lsm_file_mprotect_ctx *ctx)
{
    if (ctx->ret != 0) { ... }
    /* here instead of using vma, reqprot and ret directly,
     * one would access them as ctx fields: ctx->vma, ctx->reqprot
     */
}

The benefit of the latter is that, hopefully, no one will have to
write such struct definitions by hand, they would be generated as part
of vmlinux.h and would come directly from kernel BTF (in one way or
another, see below). One added benefit is that such struct is
CO-RE-relocatable, so if fields are ever, say, reordered or removed,
by using CO-RE mechanisms one can write a compiled-once BPF program to
accommodate such changes and even incompatibilities.

Now to why I'm bringing this up again.

The original plan was to use bpftool to convert func_protos that are
used directly by kernel (e.g., btf_trace_xxx ones for raw tracepoints)
to dump them as memory layout-compatible structs at the end of
vmlinux.h for use by BPF programs. Unfortunately, I don't think that
will work because func_proto arguments don't preserve their names in
BTF. Which, as I pointed out in previous email, ruins usability of
generated structs.

So I'd like to solicit feedback on how we can proceed from here. I see
few possible ways to go about this:

1. Do nothing. Always an option. It sucks for users (they need to
copy-paste function definitions, use BPF_PROG macro, etc), but is
awesome for kernel (no changes, no extra stuff).

2. Bite a bullet and add compatible struct definitions into kernel
itself. It will slightly increase kernel BTF, but will require no
changes on user-space and tooling side. vmlinux.h just magically gets
proper structs that are directly usable from BPF programs. One
objection to that is that those structs are not directly used by
kernel and thus are just a dead weight.

3. Bite even bigger bullet and convert current uses of func_proto in
kernel to struct. That way we don't have unnecessary types laying
around in the kernel, verifier actually will use these structs for
verification. There might be a concern about backwards compatibility.
Libbpf can easily accommodate such changes by searching for either
struct or func_proto, whichever is available, but one can argue that
we have to leave existing btf_trace_xxx func protos intact if that's
considered to be part of UAPI.

4. Milder variant of #3 would be to convert typedef of func_protos
into a use of proper FUNCs. They still use func_proto, but that
func_proto actually preserves argument names, and would allow bpftool
to dump proper structs. Same considerations of what to do with
backwards compatibility of btf_trace_xxx typedefs+func_proto, but
won't require much verifier changes, because it's still going to be
func_proto that need to be used for verification. This is what
Yonghong's bpfdump changes actually do: they use __init empty funcs to
provide types for verifier.

I think it's important to discuss this, because more and more BPF
program types are relying on using similar approach (e.g., LSM,
bpfdump), and it would be nice to provide a good **and uniform**
solution to let users just use a proper context structure directly,
instead of using BPF_PROG macro (best case, worst case it's a direct
u64 array conversions) and copy-pasting definition.

Thanks for any feedback upfront!
