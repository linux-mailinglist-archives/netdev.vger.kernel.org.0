Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6412F7134
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 04:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732714AbhAODwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 22:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbhAODv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 22:51:59 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623C8C0613C1;
        Thu, 14 Jan 2021 19:51:19 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id 18so3875730ybx.2;
        Thu, 14 Jan 2021 19:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n7wLYiMjEaRKegDkzieWsj2zpam31LaW/eah8yAZLEU=;
        b=ZiSpPgcggMO6tdSG0DvImE9bSXue3YfSQD2HUbQvxLXbiFxkIgYcTJ/i2ANgG09QE+
         lbwfArAZLP54xYp8sQQLjz46sJaazuUw7/esyBmpdhKknLqLzfH191ThbRl/1yB9bP+j
         jC/bfNnwwBUuQm1g6KTpHvnhIleruPV9vVhQ4TUyk4+QlvPrqPz7n2r+sHxtO784MN/r
         iXrvtgbHf1Fs1k34bqtp9cltpqedTDnL2ikAU814gsvvlM0Xv1ZhL2/Ir/eoTTBOkNax
         3S9Zo6AkrAWP1UxQ9LjyyOVFm46Dv1CJScoZpierC34DFS9wW6VwKkpkB/0YnEr9mZTN
         PqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n7wLYiMjEaRKegDkzieWsj2zpam31LaW/eah8yAZLEU=;
        b=cuZBWxFu415pUa0y+LlsgZqr4+Em2gZmwM5zaLh0nSqnjL1DvBVa+7wxwZkDwZZFYZ
         9L8p6FWYwBnu1qKxTMxiqPBEAlDht1Z9VHnUGFurw9sAk3tIB7lAy86pLU6EYQ+zLzzY
         xaEhmvIOSvaD2fdYk3i0HSIzlx95BLTo7vjjEiUFFqy7RHfm9m8GWABfa6aD97f1TQOc
         8SrTeIzYPQcxIWm0YcgoKBXi5mekVNznPt4gp094Opmfpi4homaemqxn5zH8fiaf7id6
         ZcvuX5FT1YZDmFLvcZww4CE2KXX3LFl3XvRAR5UliZ2Ls2Njai1jyLD2M3V/hYe7Zdto
         /tlQ==
X-Gm-Message-State: AOAM531wnUaDMmv9L8QnKEoRDXeYL4ooVHp0e+eY6F69Mgi51xAaoWu/
        lvq2FZLbP6hgVjA3nmKddRc5o9s27p3C3kq0U4E=
X-Google-Smtp-Source: ABdhPJzWn7SdNcy4ucDm9CL7J6PG3lP/+7DykRDNmDqDA/H8CoHNlUyOx/gst3RksBLlBsFTrYw15ifbUfH/KVaG5o0=
X-Received: by 2002:a25:4107:: with SMTP id o7mr14740119yba.459.1610682678580;
 Thu, 14 Jan 2021 19:51:18 -0800 (PST)
MIME-Version: 1.0
References: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com>
 <1610386373-24162-2-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzZu2MuNYs8rpObLo5Z4gkodY4H+8sbraAGYXJwVZC9mfg@mail.gmail.com> <alpine.LRH.2.23.451.2101141426320.30025@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2101141426320.30025@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 Jan 2021 19:51:07 -0800
Message-ID: <CAEf4BzZFTyAkMmz0+V_fcGHi+O1Cgunnwde=oqbyniE4rU3iYA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: share BTF "show" implementation
 between kernel and libbpf
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 7:37 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Mon, 11 Jan 2021, Andrii Nakryiko wrote:
>
> > On Mon, Jan 11, 2021 at 9:34 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > > Currently the only "show" function for userspace is to write the
> > > representation of the typed data to a string via
> > >
> > > LIBBPF_API int
> > > btf__snprintf(struct btf *btf, char *buf, int len, __u32 id, void *obj,
> > >               __u64 flags);
> > >
> > > ...but other approaches could be pursued including printf()-based
> > > show, or even a callback mechanism could be supported to allow
> > > user-defined show functions.
> > >
> >
> > It's strange that you saw btf_dump APIs, and yet decided to go with
> > this API instead. snprintf() is not a natural "method" of struct btf.
> > Using char buffer as an output is overly restrictive and inconvenient.
> > It's appropriate for kernel and BPF program due to their restrictions,
> > but there is no need to cripple libbpf APIs for that. I think it
> > should follow btf_dump APIs with custom callback so that it's easy to
> > just printf() everything, but also user can create whatever elaborate
> > mechanism they need and that fits their use case.
> >
> > Code reuse is not the ultimate goal, it should facilitate
> > maintainability, not harm it. There are times where sharing code
> > introduces unnecessary coupling and maintainability issues. And I
> > think this one is a very obvious case of that.
> >
>
> Okay, so I've been exploring adding dumper API support.  The initial
> approach I've been using is to provide an API like this:
>
> /* match show flags for bpf_show_snprintf() */
> enum {
>         BTF_DUMP_F_COMPACT      =       (1ULL << 0),
>         BTF_DUMP_F_NONAME       =       (1ULL << 1),
>         BTF_DUMP_F_ZERO         =       (1ULL << 3),
> };
>

I'd use bool fields instead, we are not constrained with extensibility
of this, no need for opaque "flags" field.

> struct btf_dump_emit_type_data_opts {
>         /* size of this struct, for forward/backward compatibility */
>         size_t sz;
>         void *data;

data is not optional, so should be moved out and be a direct argument
to btf_dump__emit_type_data()

>         int indent_level;
>         __u64 flags;
> };
> #define btf_dump_emit_type_data_opts__last_field flags
>
> LIBBPF_API int
> btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
>                          const struct btf_dump_emit_type_data_opts *opts);
>

yes, this is something more like what I had in mind

>
> ...so the opts play a similiar role to the struct btf_ptr + flags
> in bpf_snprintf_btf.  I've got this working, but the current
> implementation is tied to emitting the same C-based syntax as
> bpf_snprintf_btf(); though of course the printf function is invoked.
> So a use case looks something like this:
>
>         struct btf_dump_emit_type_data_opts opts;
>         char skbufmem[1024], skbufstr[8192];
>         struct btf *btf = libbpf_find_kernel_btf();
>         struct btf_dump *d;
>         __s32 skbid;
>         int indent = 0;
>
>         memset(skbufmem, 0xff, sizeof(skbufmem));
>         opts.data = skbufmem;
>         opts.sz = sizeof(opts);
>         opts.indent_level = indent;
>
>         d = btf_dump__new(btf, NULL, NULL, printffn);
>
>         skbid = btf__find_by_name_kind(btf, "sk_buff", BTF_KIND_STRUCT);
>         if (skbid < 0) {
>                 fprintf(stderr, "no skbuff, err %d\n", skbid);
>                 exit(1);
>         }
>
>         btf_dump__emit_type_data(d, skbid, &opts);
>
>
> ..and we get output of the form
>
> (struct sk_buff){
>  (union){
>   (struct){
>    .next = (struct sk_buff *)0xffffffffffffffff,
>    .prev = (struct sk_buff *)0xffffffffffffffff,
>    (union){
>     .dev = (struct net_device *)0xffffffffffffffff,
>     .dev_scratch = (long unsigned int)18446744073709551615,
>    },
>   },
> ...
>
> etc.  However it would be nice to find a way to help printf function
> providers emit different formats such as JSON without having to
> parse the data they are provided in the printf function.
> That would remove the need for the output flags, since the printf
> function provider could control display.

I might have missed the stated goal for the work you are doing with
these changes, but in my mind it's mostly debugging/information dump
of some captured data, for human consumption. I'm very skeptical about
trying to generalize it to support JSON and other "structured"
formats. Humans won't be reading JSON when they have the ability to
look at human-readable C-like syntax. For any other application where
they'd want more structured representation (e.g., if they want to
filter, aggregate, etc), it's not really hard to implement similar
(but tailored to the application's needs) logic just given a raw data
dump and BTF information. Luckily, BTF and C types are simple enough
to do this quite effortlessly.

So I'm all for doing a text dump APIs (similar to how BTF-to-C dumping
API works), but against designing it for JSON and other formats.

>
> If we provided an option to provider a "kind" printf function,
> and ensured that the BTF dumper sets a "kind" prior to each
> _internal_ call to the printf function, we could use that info
> to adapt output in various ways.  For example, consider the case
> where we want to emit C-type output.  We can use the kind
> info to control output for various scenarios:
>
> void c_dump_kind_printf(struct btf_dump *d, enum btf_dump_kind kind,
>                         void *ctx, const char *fmt, va_list args)
> {
>         switch (kind) {
>         case BTF_DUMP_KIND_TYPE_NAME:
>                 /* For C, add brackets around the type name string ( ) */
>                 btf_dump__printf(d, "(");
>                 btf_dump__vprintf(d, fmt, args);
>                 btf_dump__printf(d, ")");
>                 break;
>         case BTF_DUMP_KIND_MEMBER_NAME:
>                 /* for C, prefix a "." to member name, suffix a "=" */
>                 btf_dump__printf(d, ".");
>                 btf_dump__vprintf(d, fmt, args);
>                 btf_dump__printf(d, " = ");
>                 break;
>         ...

Curious, when you are going to dump an array, you'll have separate
enums for start of array, start of array element, end of array
element, end of array, etc? It feels a bit like re-inventing
high-level semantics of the C type system, which BTF is already doing
(in a different way, of course). Which is why I'm saying having BTF
and raw bytes dump seems to be a more appropriate approach for more
sophisticated applications that need to understand data, not just
pretty-print it.

>
> Whenever we internally call btf_dump_kind_printf() - and have
> a kind printf function - it is invoked, and once it's added formatting
> it invokes the printf function.  So there are two layers of callbacks
>
> - the kind callback determines what we print based on the kinds
>   of objects provided (type names, member names, type data, etc); and
> - the printf callback determines _how_ we print (e.g. to a file, stdout,
>   etc).
>
> The above suggests we'd need to add btf_dump__*printf() functions.
>
> This might allow us to refactor bpftool such that the
> type traversal code lived in libbpf, while the specifics of
> how that info is to be dumped live in bpftool.  We'd probably
> need to provide a C-style kind dumper out of the box in libbpf
> as a default mechanism.
>
> What do you think?
>
> Alan
