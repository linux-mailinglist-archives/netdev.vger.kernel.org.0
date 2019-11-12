Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F582F878B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 05:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKLEjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 23:39:10 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34061 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLEjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 23:39:09 -0500
Received: by mail-qk1-f193.google.com with SMTP id 205so13401761qkk.1;
        Mon, 11 Nov 2019 20:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=COjJKZ2uAVpvVDD7ww5NbmSyIU6TkvVXtJiWfockJ54=;
        b=FagQlia3k/sLNZyIRy/Fj5t5hf/Ptch3NFpqus853KKbYeNIGw5u0ShmpKeeTCP3yX
         d4+dJ/0fC4O+ZiuGCWpqNxMQ/iWQ2kw9f2eRiihJHFYe7NLWSdHoVkN+ak7m8XJaesO7
         SRbSrnTuLfyB6a9c462TX9Ygx9F6jBvygMcrv9wiApvRaWt3NikLQm4QnM52SK7Vh1O0
         E//lzeo9iQx17RQ2UJuHU1pYR4CYPPpX/XYGodAyUUtrtlw+sXTr+EnruQFlTs4gzJmo
         tx9OE9/8gfBa0A+QaOOskTt5pIRH8JDWjAO5/hoVMUpkwVyNwA7k2x4/kqCjItFDMMd5
         L73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=COjJKZ2uAVpvVDD7ww5NbmSyIU6TkvVXtJiWfockJ54=;
        b=O7tH4nImH18SCQzUSlbxk0k7LqNBPoiy42v4lqc4Jj2nLEZcwt/2fNnzWpdPgJmYMX
         /45DsMth3XIdDgCdMnGDOy1lqSZ5spPkNukBmPrrjQyd+4jQHRSE/1VYT1JCYGCcSdrv
         GNXeKDZ0JgU3nzC9P4rOtZ2NHBvkdVIpekTVLos/AKJTeK5Xr/Uov4S6TfnUFjes5bxu
         H6a21BuLGhamzsbSOjUot6CGCB20cpRdQioXzzY40oxCgDNoqdeskU5caseq+Imvi5Gq
         dZfTNO7XQrE+nTDtrkpKIX6FPR+6+07OYUF/j5iYTNN2vvc930lC4Nw6mjJG8yfuszoa
         GJ7Q==
X-Gm-Message-State: APjAAAWc3LaBQPEe7WhCzAXBA/mqhL51cHN26r9geqrKRgCKXs0tdtCw
        CvDwDGmq9p6ZkFLpDYSSeBrARssbqWsMTwcK9RU=
X-Google-Smtp-Source: APXvYqzkFIOTRT9CS4e2BVivu0yr/woBJiZm0Xcoy/1hnLREnEOELcj5c9MC+dMzTa96yQc64K/I13r9/3uSZGnOpjY=
X-Received: by 2002:a05:620a:12b2:: with SMTP id x18mr14194160qki.437.1573533546126;
 Mon, 11 Nov 2019 20:39:06 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-16-ast@kernel.org>
 <CAEf4BzZAEqv4kJy133PAMt81xaDBTcYDqNHSJP81X+2AitHpOQ@mail.gmail.com> <20191111230358.t3tcqkxaupcxyfap@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191111230358.t3tcqkxaupcxyfap@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Nov 2019 20:38:54 -0800
Message-ID: <CAEf4BzahNJXbpJ6mfhDT=G-dspCg-Zzm9jGYUexxfz62Yop_oQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 3:04 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Nov 09, 2019 at 11:17:37PM -0800, Andrii Nakryiko wrote:
> > On Thu, Nov 7, 2019 at 10:41 PM Alexei Starovoitov <ast@kernel.org> wrote:
> > >
> > > Allow FENTRY/FEXIT BPF programs to attach to other BPF programs of any type
> > > including their subprograms. This feature allows snooping on input and output
> > > packets in XDP, TC programs including their return values. In order to do that
> > > the verifier needs to track types not only of vmlinux, but types of other BPF
> > > programs as well. The verifier also needs to translate uapi/linux/bpf.h types
> > > used by networking programs into kernel internal BTF types used by FENTRY/FEXIT
> > > BPF programs. In some cases LLVM optimizations can remove arguments from BPF
> > > subprograms without adjusting BTF info that LLVM backend knows. When BTF info
> > > disagrees with actual types that the verifiers sees the BPF trampoline has to
> > > fallback to conservative and treat all arguments as u64. The FENTRY/FEXIT
> > > program can still attach to such subprograms, but won't be able to recognize
> > > pointer types like 'struct sk_buff *' into won't be able to pass them to
> > > bpf_skb_output() for dumping to user space.
> > >
> > > The BPF_PROG_LOAD command is extended with attach_prog_fd field. When it's set
> > > to zero the attach_btf_id is one vmlinux BTF type ids. When attach_prog_fd
> > > points to previously loaded BPF program the attach_btf_id is BTF type id of
> > > main function or one of its subprograms.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  arch/x86/net/bpf_jit_comp.c |  3 +-
> > >  include/linux/bpf.h         |  2 +
> > >  include/linux/btf.h         |  1 +
> > >  include/uapi/linux/bpf.h    |  1 +
> > >  kernel/bpf/btf.c            | 58 +++++++++++++++++++---
> > >  kernel/bpf/core.c           |  2 +
> > >  kernel/bpf/syscall.c        | 19 +++++--
> > >  kernel/bpf/verifier.c       | 98 +++++++++++++++++++++++++++++--------
> > >  kernel/trace/bpf_trace.c    |  2 -
> > >  9 files changed, 151 insertions(+), 35 deletions(-)
> > >
> >
> > [...]
> >
> > > +
> > > +static bool btf_translate_to_vmlinux(struct bpf_verifier_log *log,
> > > +                                    struct btf *btf,
> > > +                                    const struct btf_type *t,
> > > +                                    struct bpf_insn_access_aux *info)
> > > +{
> > > +       const char *tname = __btf_name_by_offset(btf, t->name_off);
> > > +       int btf_id;
> > > +
> > > +       if (!tname) {
> > > +               bpf_log(log, "Program's type doesn't have a name\n");
> > > +               return false;
> > > +       }
> > > +       if (strcmp(tname, "__sk_buff") == 0) {
> >
> > might be a good idea to ensure that t's type is also a struct?
> >
> > > +               btf_id = btf_resolve_helper_id(log, &bpf_skb_output_proto, 0);
> >
> > This is kind of ugly and high-maintenance. Have you considered having
> > something like this, to do this mapping:
> >
> > struct bpf_ctx_mapping {
> >     struct sk_buff *__sk_buff;
> >     struct xdp_buff *xdp_md;
> > };
> >
> > So field name is a name you are trying to match, while field type is
> > actual type you are mapping to? You won't need to find special
> > function protos (like bpf_skb_output_proto), it will be easy to
> > extend, you'll have real vmlinux types automatically captured for you
> > (you'll just have to initially find bpf_ctx_mapping's btf_id).
>
> I was thinking something along these lines.
> The problem with single struct like above is that it's centralized.
> convert_ctx_access callbacks are all over the place.
> So I'm thinking to add macro like this to bpf.h
> +#define BPF_RECORD_CTX_CONVERSION(user_type, kernel_type) \
> +       ({typedef kernel_type (*bpf_ctx_convert)(user_type); \
> +        (void) (bpf_ctx_convert) (void *) 0;})
>
> and then do
> BPF_RECORD_CTX_CONVERSION(struct bpf_xdp_sock, struct xdp_sock);
> inside convert_ctx_access functions (like bpf_xdp_sock_convert_ctx_access).
> There will be several typedefs with 'bpf_ctx_convert' name. The
> btf_translate_to_vmlinux() will iterate over them. Speed is not criticial here,

I guess that works as well. Please leave a comment explaining the idea
behind this distributed mapping :)

> but long term we probably need to merge prog's BTF with vmlinux's BTF, so most
> of the type comparison is done during prog load. It probably should reduce the
> size of prog's BTF too. Renumbering of prog's BTF will be annoying though.
> Something to consider long term.
>
> >
> > > +               if (btf_id < 0)
> > > +                       return false;
> > > +               info->btf_id = btf_id;
> > > +               return true;
> > > +       }
> > > +       return false;
> > > +}
> > >
> >
> > [...]
> >
> > > +               if (tgt_prog && conservative) {
> > > +                       struct btf_func_model *m = &tr->func.model;
> > > +
> > > +                       /* BTF function prototype doesn't match the verifier types.
> > > +                        * Fall back to 5 u64 args.
> > > +                        */
> > > +                       for (i = 0; i < 5; i++)
> > > +                               m->arg_size[i] = 8;
> > > +                       m->ret_size = 8;
> > > +                       m->nr_args = 5;
> > > +                       prog->aux->attach_func_proto = NULL;
> > > +               } else {
> > > +                       ret = btf_distill_func_proto(&env->log, btf, t,
> > > +                                                    tname, &tr->func.model);
> >
> > there is nothing preventing some parallel thread to modify
> > tr->func.model in parallel, right? Should these modifications be
> > either locked or at least WRITE_ONCE, similar to
> > btf_resolve_helper_id?
>
> hmm. Right. There is a race with bpf_trampoline_lookup. One thread could have
> just created the trampoline and still doing distill, while another thread is
> trying to use it after getting it from bpf_trampoline_lookup. The fix choices
> are not pretty. Either to add a mutex to check_attach_btf_id() or do
> bpf_trampoline_lookup_or_create() with extra callback that does
> btf_distill_func_proto while bpf_trampoline_lookup_or_create is holding
> trampoline_mutex or move most of the check_attach_btf_id() logic into
> bpf_trampoline_lookup_or_create().
> I tried to keep trampoline as abstract concept, but with callback or move
> the verifer and btf logic will bleed into trampoline. Hmm.

yeah, that sounds too intrusive. I'd change btf_distill_func_proto to
accept struct btf_func_model **m, allocate model dynamically, and then
compare_exchange the final constructed model pointer.

Similarly for "fallback to conservative" case.

>
