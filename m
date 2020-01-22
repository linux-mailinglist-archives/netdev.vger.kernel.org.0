Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654BD14597E
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgAVQKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:10:02 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38700 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgAVQKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:10:02 -0500
Received: by mail-pg1-f195.google.com with SMTP id a33so3774421pgm.5;
        Wed, 22 Jan 2020 08:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C5iTKL7lb1pE0dRp8K96ZECMNYTB52SkfAQAkbPl9Ro=;
        b=RaLPbBWv0L5AoDIsHCgc8o9yP8q0QH1Rte9lxbEs5T4xSuEg1bR0Xn0jufDHQTOzwB
         0JGypg17pPJYqQOD+6JyfYN26acPCkivLfWHOmPLoGc/R87+4yMZ0n47H9tUSlJFBtK2
         i+pJBTYuXdLf2KsfKdnJOBgvETNqLqHI+NXNOfci2TfMn9hhAV/M0SimIZoRM43ejtLq
         RZFxn8magVipfO/AVLvk0hRlrWCPSaxr35iNHUYdfTjDnr157NkIczGEBgypx4aYbJXL
         pNojbE85eH107AJ47w1jflmh13vlPueNUH5YKsJj9iqh5P2qodhUm5CZAxAystX3CxQZ
         GPSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=C5iTKL7lb1pE0dRp8K96ZECMNYTB52SkfAQAkbPl9Ro=;
        b=XygRzAydejWUHxcKWzD/kWnEE/qP7RHG/5QhRcbOXM8LPCLE45K/HaMQJsqyT76MMC
         kysbQsZEckvIMLsbtjw4wfI+z9RJ/RGHl6ljcxjalCNTYO4KP2OiA3KN4IHRoKVH556L
         JYaVEfxQ/Kq6pJVyEuDdG7MKfXACP78e9LGmecSNROBDFxYoMWE9Gz7eeLOxlEUgKBLx
         14gw3l5VOFFKvH6HG73oh1iCT9bjuE9HYBK78xAfn/YVD6mGy9w5UpnwgZjqk9610LU6
         Bv1p4uZcguVNWJTP+OE0Q2th8ZxlCguvFLZsn1j+oXABjBqQhcRFux6ql8BLHKkLHhVA
         RiXA==
X-Gm-Message-State: APjAAAX+cWA5kiPC4YaR5Quo6q13R/KP915pul2SspHT+H2sTpuCMs54
        RdsSyCVV7zNRIA0C2XN31+g=
X-Google-Smtp-Source: APXvYqxRmFaT/SacrObGlqkMP09Po5u3kiUv7jA//QOde+laRC9C7mBtqfc1tCvXenyp2UPJE78olg==
X-Received: by 2002:a65:6216:: with SMTP id d22mr11817106pgv.437.1579709401518;
        Wed, 22 Jan 2020 08:10:01 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::1:890d])
        by smtp.gmail.com with ESMTPSA id l2sm3852671pjt.31.2020.01.22.08.10.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 08:10:00 -0800 (PST)
Date:   Wed, 22 Jan 2020 08:09:59 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Martin Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: Re: [PATCH 1/6] bpf: Allow ctx access for pointers to scalar
Message-ID: <20200122160957.igyl2i4ybvbdfoiq@ast-mbp>
References: <20200121120512.758929-1-jolsa@kernel.org>
 <20200121120512.758929-2-jolsa@kernel.org>
 <CAADnVQKeR1VFEaRGY7Zy=P7KF8=TKshEy2inhFfi9qis9osS3A@mail.gmail.com>
 <0e114cc9-421d-a30d-db40-91ec7a2a7a34@fb.com>
 <20200122091336.GE801240@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122091336.GE801240@krava>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 10:13:36AM +0100, Jiri Olsa wrote:
> On Wed, Jan 22, 2020 at 02:33:32AM +0000, Yonghong Song wrote:
> > 
> > 
> > On 1/21/20 5:51 PM, Alexei Starovoitov wrote:
> > > On Tue, Jan 21, 2020 at 4:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >>
> > >> When accessing the context we allow access to arguments with
> > >> scalar type and pointer to struct. But we omit pointer to scalar
> > >> type, which is the case for many functions and same case as
> > >> when accessing scalar.
> > >>
> > >> Adding the check if the pointer is to scalar type and allow it.
> > >>
> > >> Acked-by: John Fastabend <john.fastabend@gmail.com>
> > >> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > >> ---
> > >>   kernel/bpf/btf.c | 13 ++++++++++++-
> > >>   1 file changed, 12 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > >> index 832b5d7fd892..207ae554e0ce 100644
> > >> --- a/kernel/bpf/btf.c
> > >> +++ b/kernel/bpf/btf.c
> > >> @@ -3668,7 +3668,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> > >>                      const struct bpf_prog *prog,
> > >>                      struct bpf_insn_access_aux *info)
> > >>   {
> > >> -       const struct btf_type *t = prog->aux->attach_func_proto;
> > >> +       const struct btf_type *tp, *t = prog->aux->attach_func_proto;
> > >>          struct bpf_prog *tgt_prog = prog->aux->linked_prog;
> > >>          struct btf *btf = bpf_prog_get_target_btf(prog);
> > >>          const char *tname = prog->aux->attach_func_name;
> > >> @@ -3730,6 +3730,17 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> > >>                   */
> > >>                  return true;
> > >>
> > >> +       tp = btf_type_by_id(btf, t->type);
> > >> +       /* skip modifiers */
> > >> +       while (btf_type_is_modifier(tp))
> > >> +               tp = btf_type_by_id(btf, tp->type);
> > >> +
> > >> +       if (btf_type_is_int(tp) || btf_type_is_enum(tp))
> > >> +               /* This is a pointer scalar.
> > >> +                * It is the same as scalar from the verifier safety pov.
> > >> +                */
> > >> +               return true;
> > > 
> > > The reason I didn't do it earlier is I was thinking to represent it
> > > as PTR_TO_BTF_ID as well, so that corresponding u8..u64
> > > access into this memory would still be possible.
> > > I'm trying to analyze the situation that returning a scalar now
> > > and converting to PTR_TO_BTF_ID in the future will keep progs
> > > passing the verifier. Is it really the case?
> > > Could you give a specific example that needs this support?
> > > It will help me understand this backward compatibility concern.
> > > What prog is doing with that 'u32 *' that is seen as scalar ?
> > > It cannot dereference it. Use it as what?
> > 
> > If this is from original bcc code, it will use bpf_probe_read for 
> > dereference. This is what I understand when I first reviewed this patch.
> > But it will be good to get Jiri's confirmation.
> 
> it blocked me from accessing 'filename' argument when I probed
> do_sys_open via trampoline in bcc, like:
> 
> 	KRETFUNC_PROBE(do_sys_open)
> 	{
> 	    const char *filename = (const char *) args[1];
> 
> AFAICS the current code does not allow for trampoline arguments
> being other pointers than to void or struct, the patch should
> detect that the argument is pointer to scalar type and let it
> pass

Got it. I've looked up your bcc patches and I agree that there is no way to
workaround. BTF type argument of that kernel function is 'const char *' and the
verifier will enforce that if bpf program tries to cast it the verifier will
still see 'const char *'. (It's done this way by design). How about we special
case 'char *' in the verifier? Then my concern regarding future extensibility
of 'int *' and 'long *' will go away.
Compilers have a long history special casing 'char *'. In particular signed
char because it's a pointer to null terminated string. I think it's still a
special pointer from pointer aliasing point of view. I think the verifier can
treat it as scalar here too. In the future the verifier will get smarter and
will recognize it as PTR_TO_NULL_STRING while 'u8 *', 'u32 *' will be
PTR_TO_BTF_ID. I think it will solve this particular issue. I like conservative
approach to the verifier improvements: start with strict checking and relax it
on case-by-case. Instead of accepting wide range of cases and cause potential
compatibility issues.
