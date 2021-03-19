Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418293427BB
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhCSV1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhCSV1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 17:27:25 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC581C06175F;
        Fri, 19 Mar 2021 14:27:24 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id p3so5516332ybo.8;
        Fri, 19 Mar 2021 14:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VxejDbhaS8cE8NTx1JquAUxwEmt7HZqPQueRxhhitag=;
        b=Y/aH5M2w8PoSKjDJJ4lkPvV1ftFTB2TBnZ3v+lLXec4XP6+VVuSsj8ZAaIWKhYbdqO
         fEqPRJHOIhEmGQG+hfzv/GQvaI4iCO0BVruKdAeJ1QuPv4rKgVEmp0e2xTk0Gli++V7d
         FRYoiCuJDfRjfF5APednwti989afXe7R648fcXUHJrxwnhuBemaLlWBe2c3yZWMgW2Lw
         fOY2U4rAsFmff2YiRoKPH78mJsYhXtaGCAUbiOs8psgXWnTEGj4wqHj8q1+RIlHXtj2L
         eTuZf9im+nE+pURTysYDfqbemQa01lMGprLweDfQtn2r6pMBFyoaV0oty7J02JUjMegV
         vhqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VxejDbhaS8cE8NTx1JquAUxwEmt7HZqPQueRxhhitag=;
        b=r9fS/LEI6uCSgUDHO4zjMvfDKXBLAZNrjLeiTI2+oNggZonMZWco+02bTq5KnQhHhK
         eWpjahEOpu6e+G2OJS5tdQfdOMreqiDhptcc8IJ8MO4Q/SFR+i+oknphB+6VCnPY6UvV
         bYmMv91jbG4l9aeWJWTvaC32T3SmQ0HXPo9ZLbPSIVW4oNtswCD4FToOgHBeGSiv4ata
         stL27DAdci2pjRE9osw0ArI/DNqZO2YckVwqPBqq2x3xaUnyiND2ajSSqtlxnstmrzj4
         iAaqbuZnZHuMuswLplsK/bWcqICqWi9baQte2r6NbNSEcCqG5hUeTWO0s2sYBON+/ej2
         PLDg==
X-Gm-Message-State: AOAM531iQzdy47DRtt508XQwEJOqOid1wNz9NvZTUkQ+tIpgzKQ5OhFN
        4O7sy/Ylgk4guu2PRffmqmyTnxgc5jJGiVaYdM0=
X-Google-Smtp-Source: ABdhPJycRce2OPjVc0uJdMF8I2pBHpEJd+fP2KJj/dxCkPAISZZeSdJxNBWHS6ker9NIjoNleSMZ/nVI2W4u++5V6gg=
X-Received: by 2002:a25:7d07:: with SMTP id y7mr8938733ybc.425.1616189244067;
 Fri, 19 Mar 2021 14:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011348.4175708-1-kafai@fb.com>
 <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com>
 <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZx+1bN0VazE5t5_z8X+GXFZUmiLbpxZ-WfM_mLba0OYg@mail.gmail.com> <20210319052943.lt3mfmjd4iozvf6i@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210319052943.lt3mfmjd4iozvf6i@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Mar 2021 14:27:13 -0700
Message-ID: <CAEf4BzbFOQ-45Oo_rdPfHnpSjCDcdDhspGNyRK2_zJjP49VhJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 10:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Mar 18, 2021 at 09:13:56PM -0700, Andrii Nakryiko wrote:
> > On Thu, Mar 18, 2021 at 4:39 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Thu, Mar 18, 2021 at 03:53:38PM -0700, Andrii Nakryiko wrote:
> > > > On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > This patch makes BTF verifier to accept extern func. It is used for
> > > > > allowing bpf program to call a limited set of kernel functions
> > > > > in a later patch.
> > > > >
> > > > > When writing bpf prog, the extern kernel function needs
> > > > > to be declared under a ELF section (".ksyms") which is
> > > > > the same as the current extern kernel variables and that should
> > > > > keep its usage consistent without requiring to remember another
> > > > > section name.
> > > > >
> > > > > For example, in a bpf_prog.c:
> > > > >
> > > > > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> > > > >
> > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > >         '(anon)' type_id=18
> > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > > [ ... ]
> > > > > [33] DATASEC '.ksyms' size=0 vlen=1
> > > > >         type_id=25 offset=0 size=0
> > > > >
> > > > > LLVM will put the "func" type into the BTF datasec ".ksyms".
> > > > > The current "btf_datasec_check_meta()" assumes everything under
> > > > > it is a "var" and ensures it has non-zero size ("!vsi->size" test).
> > > > > The non-zero size check is not true for "func".  This patch postpones the
> > > > > "!vsi-size" test from "btf_datasec_check_meta()" to
> > > > > "btf_datasec_resolve()" which has all types collected to decide
> > > > > if a vsi is a "var" or a "func" and then enforce the "vsi->size"
> > > > > differently.
> > > > >
> > > > > If the datasec only has "func", its "t->size" could be zero.
> > > > > Thus, the current "!t->size" test is no longer valid.  The
> > > > > invalid "t->size" will still be caught by the later
> > > > > "last_vsi_end_off > t->size" check.   This patch also takes this
> > > > > chance to consolidate other "t->size" tests ("vsi->offset >= t->size"
> > > > > "vsi->size > t->size", and "t->size < sum") into the existing
> > > > > "last_vsi_end_off > t->size" test.
> > > > >
> > > > > The LLVM will also put those extern kernel function as an extern
> > > > > linkage func in the BTF:
> > > > >
> > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > >         '(anon)' type_id=18
> > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > >
> > > > > This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
> > > > > Also extern kernel function declaration does not
> > > > > necessary have arg name. Another change in btf_func_check() is
> > > > > to allow extern function having no arg name.
> > > > >
> > > > > The btf selftest is adjusted accordingly.  New tests are also added.
> > > > >
> > > > > The required LLVM patch: https://reviews.llvm.org/D93563
> > > > >
> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > ---
> > > >
> > > > High-level question about EXTERN functions in DATASEC. Does kernel
> > > > need to see them under DATASEC? What if libbpf just removed all EXTERN
> > > > funcs from under DATASEC and leave them as "free-floating" EXTERN
> > > > FUNCs in BTF.
> > > >
> > > > We need to tag EXTERNs with DATASECs mainly for libbpf to know whether
> > > > it's .kconfig or .ksym or other type of externs. Does kernel need to
> > > > care?
> > > Although the kernel does not need to know, since the a legit llvm generates it,
> > > I go with a proper support in the kernel (e.g. bpftool btf dump can better
> > > reflect what was there).
> >
> > LLVM also generates extern VAR with BTF_VAR_EXTERN, yet libbpf is
> > replacing it with fake INTs.
> Yep. I noticed the loop in collect_extern() in libbpf.
> It replaces the var->type with INT.
>
> > We could do just that here as well.
> What to replace in the FUNC case?

if we do that, I'd just replace them with same INTs. Or we can just
remove the entire DATASEC. Now it is easier to do with BTF write APIs.
Back then it was a major pain. I'd probably get rid of DATASEC
altogether instead of that INT replacement, if I had BTF write APIs.

>
> Regardless, supporting it properly in the kernel is a better way to go
> instead of asking the userspace to move around it.  It is not very
> complicated to support it in the kernel also.
>
> What is the concern of having the kernel to support it?

Just more complicated BTF validation logic, which means that there are
higher chances of permitting invalid BTF. And then the question is
what can the kernel do with those EXTERNs in BTF? Probably nothing.
And that .ksyms section is special, and purely libbpf convention.
Ideally kernel should not allow EXTERN funcs in any other DATASEC. Are
you willing to hard-code ".ksyms" name in kernel for libbpf's sake?
Probably not. The general rule, so far, was that kernel shouldn't see
any unresolved EXTERN at all. Now it's neither here nor there. EXTERN
funcs are ok, EXTERN vars are not.

>
> > If anyone would want to know all the kernel functions that some BPF
> > program is using, they could do it from the instruction dump, with
> > proper addresses and kernel function names nicely displayed there.
> > That's way more useful, IMO.
