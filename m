Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB64342E95
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 18:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhCTRTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 13:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhCTRSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 13:18:48 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DBDC061574;
        Sat, 20 Mar 2021 10:18:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id m3so1785930ybt.0;
        Sat, 20 Mar 2021 10:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=luZnT/ERJg8BvZckrdj81QcgNmPYCUKVXvK/8U9Ib4M=;
        b=i6GGm2ejZRnvw9xVQANtPsmII5y207Wybr6fwB3eRzAoDUfnX8jEQaMltCOW38vB53
         3XjDNqe+P4L9wdg/F3WGPH2NHzMKuF4dGn4DbYZoAXbZXbBntvxEePMOCTxeL+5446Oj
         SUv4CjtheRygN2AqfHUFsgYCqhN9thdlKgqpmC14lSxHBjbL5V6vVQ4hslT61n6aOu9g
         XMDec/gsrNCQHBEfaI05f4XnzGTogviFEbD3bt6/k53youL+hXzvlaBBt/QAoYFYoK6a
         Mt1deSQ+VfpiO+fhuWXNwhTZGXRPqVD4W6FwMSvkLFzaMFnT1LZzcnoIHPNgPcRkRYi7
         hUsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=luZnT/ERJg8BvZckrdj81QcgNmPYCUKVXvK/8U9Ib4M=;
        b=GVZzHIjNZ4PcqPahbbEx9/Mjw9H0smK7SCIo1q3VA2Aa6FFHjy6OM7SDmFiTX7BfjI
         LfZukyyBOdUpl7Dn3lZVPPJvxv39eRO7YtHcbekUIF9xHZOObhVR7HJ/5wclpq201vPG
         gj/UI9ucbc/mIL43QeU1hnGVokG2nJeLnxOGhmzDzaagOdjeW16D7B2ncqwqJWBavxMg
         8mLa4d3zQJEWXo8FGJEagQwKLYUUD7ovTvB6VMIekpDJom2QW0cF+LbpZECGUwXfczK1
         O0CTgFPb4aOjTae2V2LI9D1GPdfpIXHZMlRNOi6YYnK3mPCX0fNAPXtdbFRZuZY79/V8
         mazg==
X-Gm-Message-State: AOAM531pgjbzgWsF/DUX99mJomMw2v8Y1L+7M11Qh+Es6QMjj1J+TRl+
        sKdOgOdPH4MQIxnpjCJYdshY1HnO4DXPyjmEzoA=
X-Google-Smtp-Source: ABdhPJx7uWTcnVhdLjpf2P/xlLKFBliOvSQjq6z4yAqSTBea0bMuzT7ChsN+hMSjPH7t2AbbO134uZ9FTrzd9xaVToM=
X-Received: by 2002:a25:7d07:: with SMTP id y7mr13807060ybc.425.1616260727571;
 Sat, 20 Mar 2021 10:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011348.4175708-1-kafai@fb.com> <CAEf4Bzb57BrVOHRzikejK1ubWrZ_cd2FCS6BW6_E-2KuzJGrPg@mail.gmail.com>
 <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZx+1bN0VazE5t5_z8X+GXFZUmiLbpxZ-WfM_mLba0OYg@mail.gmail.com>
 <20210319052943.lt3mfmjd4iozvf6i@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbFOQ-45Oo_rdPfHnpSjCDcdDhspGNyRK2_zJjP49VhJw@mail.gmail.com>
 <20210319221950.5cd3ub3gpjcztzmt@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bza6Fiv+AFJc9-L=S6Duvm7wyyjvqoDGEED3TDTmwiZvVQ@mail.gmail.com>
 <20210319224532.7wlmhrgtrvkwqmzg@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZm1o-ZqXTpUcVnbZDX57pGqARwjHjm_=aspgj3ahHZLg@mail.gmail.com> <20210320001313.xhwiia46qsjh2k7k@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210320001313.xhwiia46qsjh2k7k@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 20 Mar 2021 10:18:36 -0700
Message-ID: <CAEf4BzaJMmmz3JvUJs0ja5yrx_WEssE_R7t_uPAwEHFe+SY9Nw@mail.gmail.com>
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

On Fri, Mar 19, 2021 at 5:13 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Mar 19, 2021 at 04:02:27PM -0700, Andrii Nakryiko wrote:
> > On Fri, Mar 19, 2021 at 3:45 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Fri, Mar 19, 2021 at 03:29:57PM -0700, Andrii Nakryiko wrote:
> > > > On Fri, Mar 19, 2021 at 3:19 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Fri, Mar 19, 2021 at 02:27:13PM -0700, Andrii Nakryiko wrote:
> > > > > > On Thu, Mar 18, 2021 at 10:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > On Thu, Mar 18, 2021 at 09:13:56PM -0700, Andrii Nakryiko wrote:
> > > > > > > > On Thu, Mar 18, 2021 at 4:39 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, Mar 18, 2021 at 03:53:38PM -0700, Andrii Nakryiko wrote:
> > > > > > > > > > On Tue, Mar 16, 2021 at 12:01 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > This patch makes BTF verifier to accept extern func. It is used for
> > > > > > > > > > > allowing bpf program to call a limited set of kernel functions
> > > > > > > > > > > in a later patch.
> > > > > > > > > > >
> > > > > > > > > > > When writing bpf prog, the extern kernel function needs
> > > > > > > > > > > to be declared under a ELF section (".ksyms") which is
> > > > > > > > > > > the same as the current extern kernel variables and that should
> > > > > > > > > > > keep its usage consistent without requiring to remember another
> > > > > > > > > > > section name.
> > > > > > > > > > >
> > > > > > > > > > > For example, in a bpf_prog.c:
> > > > > > > > > > >
> > > > > > > > > > > extern int foo(struct sock *) __attribute__((section(".ksyms")))
> > > > > > > > > > >
> > > > > > > > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > > > > > > > >         '(anon)' type_id=18
> > > > > > > > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > > > > > > > > [ ... ]
> > > > > > > > > > > [33] DATASEC '.ksyms' size=0 vlen=1
> > > > > > > > > > >         type_id=25 offset=0 size=0
> > > > > > > > > > >
> > > > > > > > > > > LLVM will put the "func" type into the BTF datasec ".ksyms".
> > > > > > > > > > > The current "btf_datasec_check_meta()" assumes everything under
> > > > > > > > > > > it is a "var" and ensures it has non-zero size ("!vsi->size" test).
> > > > > > > > > > > The non-zero size check is not true for "func".  This patch postpones the
> > > > > > > > > > > "!vsi-size" test from "btf_datasec_check_meta()" to
> > > > > > > > > > > "btf_datasec_resolve()" which has all types collected to decide
> > > > > > > > > > > if a vsi is a "var" or a "func" and then enforce the "vsi->size"
> > > > > > > > > > > differently.
> > > > > > > > > > >
> > > > > > > > > > > If the datasec only has "func", its "t->size" could be zero.
> > > > > > > > > > > Thus, the current "!t->size" test is no longer valid.  The
> > > > > > > > > > > invalid "t->size" will still be caught by the later
> > > > > > > > > > > "last_vsi_end_off > t->size" check.   This patch also takes this
> > > > > > > > > > > chance to consolidate other "t->size" tests ("vsi->offset >= t->size"
> > > > > > > > > > > "vsi->size > t->size", and "t->size < sum") into the existing
> > > > > > > > > > > "last_vsi_end_off > t->size" test.
> > > > > > > > > > >
> > > > > > > > > > > The LLVM will also put those extern kernel function as an extern
> > > > > > > > > > > linkage func in the BTF:
> > > > > > > > > > >
> > > > > > > > > > > [24] FUNC_PROTO '(anon)' ret_type_id=15 vlen=1
> > > > > > > > > > >         '(anon)' type_id=18
> > > > > > > > > > > [25] FUNC 'foo' type_id=24 linkage=extern
> > > > > > > > > > >
> > > > > > > > > > > This patch allows BTF_FUNC_EXTERN in btf_func_check_meta().
> > > > > > > > > > > Also extern kernel function declaration does not
> > > > > > > > > > > necessary have arg name. Another change in btf_func_check() is
> > > > > > > > > > > to allow extern function having no arg name.
> > > > > > > > > > >
> > > > > > > > > > > The btf selftest is adjusted accordingly.  New tests are also added.
> > > > > > > > > > >
> > > > > > > > > > > The required LLVM patch: https://reviews.llvm.org/D93563
> > > > > > > > > > >
> > > > > > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > > > > > ---
> > > > > > > > > >
> > > > > > > > > > High-level question about EXTERN functions in DATASEC. Does kernel
> > > > > > > > > > need to see them under DATASEC? What if libbpf just removed all EXTERN
> > > > > > > > > > funcs from under DATASEC and leave them as "free-floating" EXTERN
> > > > > > > > > > FUNCs in BTF.
> > > > > > > > > >
> > > > > > > > > > We need to tag EXTERNs with DATASECs mainly for libbpf to know whether
> > > > > > > > > > it's .kconfig or .ksym or other type of externs. Does kernel need to
> > > > > > > > > > care?
> > > > > > > > > Although the kernel does not need to know, since the a legit llvm generates it,
> > > > > > > > > I go with a proper support in the kernel (e.g. bpftool btf dump can better
> > > > > > > > > reflect what was there).
> > > > > > > >
> > > > > > > > LLVM also generates extern VAR with BTF_VAR_EXTERN, yet libbpf is
> > > > > > > > replacing it with fake INTs.
> > > > > > > Yep. I noticed the loop in collect_extern() in libbpf.
> > > > > > > It replaces the var->type with INT.
> > > > > > >
> > > > > > > > We could do just that here as well.
> > > > > > > What to replace in the FUNC case?
> > > > > >
> > > > > > if we do that, I'd just replace them with same INTs. Or we can just
> > > > > > remove the entire DATASEC. Now it is easier to do with BTF write APIs.
> > > > > > Back then it was a major pain. I'd probably get rid of DATASEC
> > > > > > altogether instead of that INT replacement, if I had BTF write APIs.
> > > > > Do you mean vsi->type = INT?
> > > >
> > > > yes, that's what existing logic does for EXTERN var
> > > There may be no var.
> > >
> >
> > sure, but we have btf__add_var(), if we really want VAR ;)
> >
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > Regardless, supporting it properly in the kernel is a better way to go
> > > > > > > instead of asking the userspace to move around it.  It is not very
> > > > > > > complicated to support it in the kernel also.
> > > > > > >
> > > > > > > What is the concern of having the kernel to support it?
> > > > > >
> > > > > > Just more complicated BTF validation logic, which means that there are
> > > > > > higher chances of permitting invalid BTF. And then the question is
> > > > > > what can the kernel do with those EXTERNs in BTF? Probably nothing.
> > > > > > And that .ksyms section is special, and purely libbpf convention.
> > > > > > Ideally kernel should not allow EXTERN funcs in any other DATASEC. Are
> > > > > > you willing to hard-code ".ksyms" name in kernel for libbpf's sake?
> > > > > > Probably not. The general rule, so far, was that kernel shouldn't see
> > > > > > any unresolved EXTERN at all. Now it's neither here nor there. EXTERN
> > > > > > funcs are ok, EXTERN vars are not.
> > > > > Exactly, it is libbpf convention.  The kernel does not need to enforce it.
> > > > > The kernel only needs to be able to support the debug info generated by
> > > > > llvm and being able to display/dump it later.
> > > > >
> > > > > There are many other things in the BTF that the kernel does not need to
> > > >
> > > > Curious, what are those many other things?
> > > VAR '_license'.
> > > deeper things could be STRUCT 'tcp_congestion_ops' and the types under it.
> > >
> >
> > kernel is aware of DATASEC in general, it validates variable sizes and
> > offsets, and datasec size itself.
> Yeah, the kernel still thinks it is data only now.
> With func in datasec, I think the name "data"sec may be a bit out-dated.

yep, should have been called SECTION, probably

>
> > DATASEC can be assigned as
> > value_type_id for maps. So I guess technically you are correct that it
> > doesn't care about VAR _license specifically, but it has to care about
> > DATASEC/VARs in general. Same applies to STRUCT 'tcp_congestion_ops'.
> >
> > I'm fine with extending the kernel with EXTERN funcs, btw. I just
> > don't think it's necessary. But then also let's support EXTERN vars
> > for consistency.
> cool. lets explore EXTERN vars support.
>
> > > > >
> > > > > To support EXTERN var, the kernel part should be fine.  I am only not
> > > > > sure why it has to change the vs->size and vs->offset in libbpf?
> > > >
> > > > vs->size and vs->offset are adjusted to match int type. Otherwise
> > > > kernel BTF validation will complain about DATASEC size mismatch.
> > > make sense. so if there is no need to replace it with INT,
> > > they can be left as is?
> >
> > If kernel start supporting EXTERN vars, yes, we won't need to touch
> > it.
> From test_ksyms.c:
> [22] DATASEC '.ksyms' size=0 vlen=5
>      type_id=12 offset=0 size=1
>      type_id=13 offset=0 size=1
>
> For extern, does it make sense for the libbpf to assign 0 to
> both var offset and size since it does not matter?

That's how it is generated and yes, I think that's how it should be
kept once kernel supports EXTERN VAR. libbpf is adjusting offsets and
sizes in addition to marking VAR itself as GLOBAL_ALLOCATED. If kernel
supports EXTERN VAR natively, none of that needs to happen (on newer
kernels only, of course).

> In the kernel, it can ensure a datasec only has all extern or no extern.
> array_map_check_btf() will ensure the datasec has no extern.

It certainly makes it less surprising from handling BTF, but it feels
like an arbitrary policy, rather than technical restriction. You can
mark allocated variables and externs with the same section name and
Clang will probably happily generate a single DATASEC with a mix of
externs and non-externs. Is that inherently a bad thing? I'm not sure.
Basically, I don't know if the kernel should care and enforce or not.

>
> > But of course to support older kernels libbpf will still have to
> > do this. EXTERN vars won't reduce the amount of libbpf logic.
