Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E9CF8330
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKKXEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:04:05 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45033 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKKXEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 18:04:04 -0500
Received: by mail-pl1-f193.google.com with SMTP id az9so7628482plb.11;
        Mon, 11 Nov 2019 15:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OQipHrDD6TrzwgDanFTxu8nqMGSKkhoKfvaM3dFL2Og=;
        b=ON8GGCh3i08gyRnk7ieMoN0FB6WA290X8Aqx+6t3v5YX5Jo/YIuhlZUvXq3mJMOYXT
         rYcGLyRhD4/T3TuUeiq74taN75bMhwQOAa1a58Htqvzk7+fjy5brkhUWEka2iwQpIj1S
         PyRLSdhtcogaWVmLYsy7ndW09IANIvBitNjjLUgjD9+NORpaApOShzkgrAQkpLdOv2du
         Rhtg7BKuuYd88dcLW365fV8sXMJPpDuH35/dfCY1y9Ui2ulGWyi3gGJF9kVsQzAbAeg6
         4fX4ZZJGNqd2vkmUgXf3qiDosbdtJS2RvKureXd3mOTADwwGbM3IH1BnF0vA253CLJEE
         EyOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OQipHrDD6TrzwgDanFTxu8nqMGSKkhoKfvaM3dFL2Og=;
        b=NMaJJT5iOn3ZEy2kjXlsqdaN1aqaoVFi26HKLo2BVDm+fRy/4V0Dm4A+wz1gxHbfdG
         C+h+nuLIajh8XMCBG0cNAOIm7987ye7gQyyJHTbAMSfG8caZTeUz1f6CIteuKe6MvLJz
         rLDpEObajbw0wTBU28ZP3JpMpLocPZ1WcL845HWmqRuVUamQMw0UDWgwifOqfer2ZXiy
         rtLUiA1OqCjk/Xh/UzHTohOEcqd3JjOy9sJWZjWrxj/o3MhVXo8ieNRKlpmNsHI7riVk
         G0bZq7AKrfqOhTt0vp9bAXbc+2hksmwnfCj/4S+uibaMDvsJRzHoLkWFbIOFceHKasm+
         08cA==
X-Gm-Message-State: APjAAAVAeRToXHYephA23BYy0ZdOBJ4hUAscLXrpTEzwiA6xdNrWTJoP
        8D2ttI8B2EJ3q4F8U3bw16E=
X-Google-Smtp-Source: APXvYqzykJDkeqiBms2GXvdf2pzUfxy76dfrn/0uw1n4wtCgH1odDvb55Jz27Q9iJHbU+aImprWj3w==
X-Received: by 2002:a17:902:74c6:: with SMTP id f6mr28860182plt.167.1573513443341;
        Mon, 11 Nov 2019 15:04:03 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::a925])
        by smtp.gmail.com with ESMTPSA id w26sm23198811pfj.123.2019.11.11.15.04.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 15:04:01 -0800 (PST)
Date:   Mon, 11 Nov 2019 15:04:00 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
Message-ID: <20191111230358.t3tcqkxaupcxyfap@ast-mbp.dhcp.thefacebook.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-16-ast@kernel.org>
 <CAEf4BzZAEqv4kJy133PAMt81xaDBTcYDqNHSJP81X+2AitHpOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZAEqv4kJy133PAMt81xaDBTcYDqNHSJP81X+2AitHpOQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 11:17:37PM -0800, Andrii Nakryiko wrote:
> On Thu, Nov 7, 2019 at 10:41 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > Allow FENTRY/FEXIT BPF programs to attach to other BPF programs of any type
> > including their subprograms. This feature allows snooping on input and output
> > packets in XDP, TC programs including their return values. In order to do that
> > the verifier needs to track types not only of vmlinux, but types of other BPF
> > programs as well. The verifier also needs to translate uapi/linux/bpf.h types
> > used by networking programs into kernel internal BTF types used by FENTRY/FEXIT
> > BPF programs. In some cases LLVM optimizations can remove arguments from BPF
> > subprograms without adjusting BTF info that LLVM backend knows. When BTF info
> > disagrees with actual types that the verifiers sees the BPF trampoline has to
> > fallback to conservative and treat all arguments as u64. The FENTRY/FEXIT
> > program can still attach to such subprograms, but won't be able to recognize
> > pointer types like 'struct sk_buff *' into won't be able to pass them to
> > bpf_skb_output() for dumping to user space.
> >
> > The BPF_PROG_LOAD command is extended with attach_prog_fd field. When it's set
> > to zero the attach_btf_id is one vmlinux BTF type ids. When attach_prog_fd
> > points to previously loaded BPF program the attach_btf_id is BTF type id of
> > main function or one of its subprograms.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  arch/x86/net/bpf_jit_comp.c |  3 +-
> >  include/linux/bpf.h         |  2 +
> >  include/linux/btf.h         |  1 +
> >  include/uapi/linux/bpf.h    |  1 +
> >  kernel/bpf/btf.c            | 58 +++++++++++++++++++---
> >  kernel/bpf/core.c           |  2 +
> >  kernel/bpf/syscall.c        | 19 +++++--
> >  kernel/bpf/verifier.c       | 98 +++++++++++++++++++++++++++++--------
> >  kernel/trace/bpf_trace.c    |  2 -
> >  9 files changed, 151 insertions(+), 35 deletions(-)
> >
> 
> [...]
> 
> > +
> > +static bool btf_translate_to_vmlinux(struct bpf_verifier_log *log,
> > +                                    struct btf *btf,
> > +                                    const struct btf_type *t,
> > +                                    struct bpf_insn_access_aux *info)
> > +{
> > +       const char *tname = __btf_name_by_offset(btf, t->name_off);
> > +       int btf_id;
> > +
> > +       if (!tname) {
> > +               bpf_log(log, "Program's type doesn't have a name\n");
> > +               return false;
> > +       }
> > +       if (strcmp(tname, "__sk_buff") == 0) {
> 
> might be a good idea to ensure that t's type is also a struct?
> 
> > +               btf_id = btf_resolve_helper_id(log, &bpf_skb_output_proto, 0);
> 
> This is kind of ugly and high-maintenance. Have you considered having
> something like this, to do this mapping:
> 
> struct bpf_ctx_mapping {
>     struct sk_buff *__sk_buff;
>     struct xdp_buff *xdp_md;
> };
> 
> So field name is a name you are trying to match, while field type is
> actual type you are mapping to? You won't need to find special
> function protos (like bpf_skb_output_proto), it will be easy to
> extend, you'll have real vmlinux types automatically captured for you
> (you'll just have to initially find bpf_ctx_mapping's btf_id).

I was thinking something along these lines.
The problem with single struct like above is that it's centralized.
convert_ctx_access callbacks are all over the place.
So I'm thinking to add macro like this to bpf.h
+#define BPF_RECORD_CTX_CONVERSION(user_type, kernel_type) \
+       ({typedef kernel_type (*bpf_ctx_convert)(user_type); \
+        (void) (bpf_ctx_convert) (void *) 0;})

and then do
BPF_RECORD_CTX_CONVERSION(struct bpf_xdp_sock, struct xdp_sock);
inside convert_ctx_access functions (like bpf_xdp_sock_convert_ctx_access).
There will be several typedefs with 'bpf_ctx_convert' name. The
btf_translate_to_vmlinux() will iterate over them. Speed is not criticial here,
but long term we probably need to merge prog's BTF with vmlinux's BTF, so most
of the type comparison is done during prog load. It probably should reduce the
size of prog's BTF too. Renumbering of prog's BTF will be annoying though.
Something to consider long term.

> 
> > +               if (btf_id < 0)
> > +                       return false;
> > +               info->btf_id = btf_id;
> > +               return true;
> > +       }
> > +       return false;
> > +}
> >
> 
> [...]
> 
> > +               if (tgt_prog && conservative) {
> > +                       struct btf_func_model *m = &tr->func.model;
> > +
> > +                       /* BTF function prototype doesn't match the verifier types.
> > +                        * Fall back to 5 u64 args.
> > +                        */
> > +                       for (i = 0; i < 5; i++)
> > +                               m->arg_size[i] = 8;
> > +                       m->ret_size = 8;
> > +                       m->nr_args = 5;
> > +                       prog->aux->attach_func_proto = NULL;
> > +               } else {
> > +                       ret = btf_distill_func_proto(&env->log, btf, t,
> > +                                                    tname, &tr->func.model);
> 
> there is nothing preventing some parallel thread to modify
> tr->func.model in parallel, right? Should these modifications be
> either locked or at least WRITE_ONCE, similar to
> btf_resolve_helper_id?

hmm. Right. There is a race with bpf_trampoline_lookup. One thread could have
just created the trampoline and still doing distill, while another thread is
trying to use it after getting it from bpf_trampoline_lookup. The fix choices
are not pretty. Either to add a mutex to check_attach_btf_id() or do
bpf_trampoline_lookup_or_create() with extra callback that does
btf_distill_func_proto while bpf_trampoline_lookup_or_create is holding
trampoline_mutex or move most of the check_attach_btf_id() logic into
bpf_trampoline_lookup_or_create().
I tried to keep trampoline as abstract concept, but with callback or move
the verifer and btf logic will bleed into trampoline. Hmm.

