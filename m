Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14B42A0D9F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgJ3SlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgJ3SlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:41:05 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DBAC0613CF;
        Fri, 30 Oct 2020 11:30:59 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id m188so5918698ybf.2;
        Fri, 30 Oct 2020 11:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NudX4n3QUbIMKdjUaAuCUx9HsnXJXU+X0TWHhojMmc8=;
        b=PWeMS4BY0Vtcum/l1sfo20MCwqrdolqjcB+j0JzqTBmd6eIUyEcMmCMSgrFvkJQXmc
         QkBBVCrZov0hp6UIk1GfZES2sCfEDdAXnWwwErIIrt593Lq5ubBap4IbhT3jhX0VeVUE
         hOoluLjaHclNHchylIA7H0hh4UQ/TXJA+4M0fw38uRitI/oxiST06MKzSlE2xRf2nZDA
         R/m/msp9rqzDvWgCEKuETx9+nPmDmsbR0tM0KJAY+IAFIvBiflliHviQEyGfOCk3XX7T
         JvvDBNtZM0kdnFocvd1fdnevuK0+hYS4LztQctDsoaVJa6GU4U60GIwpYzcLmDmIetIy
         irNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NudX4n3QUbIMKdjUaAuCUx9HsnXJXU+X0TWHhojMmc8=;
        b=LwPGk3NMMB273GNiHLzWTIEsomwMgU58JMnkHsewmbGEQAkzzZ91qxBHX6F+CyZX/P
         87Zo9AIgqjDYM/s1T8HudSwfN+vC5goonX6OgvccAPS/MaWFcpZV/T7o+A8Hhc2Bdq94
         DsGKFXcfEEO91yp5W8tpKgkrBG9LFJf0x9jm6cMP8EQ+s4c/NZ2S527gRq9REr8msPqc
         Z2fSdNhOOEwVPvZ06K8pE5do/aJxlJjfWVGGeP+GkZGlL1NTJnp2f71yQMqhZ6kQS5kg
         SDTkUD7a53Ss+cY+kd843SQDmgoDcX+vRbH39VZfVwi2BUAWUt7Vv5bnMc2PS1Ofqlc9
         gIjA==
X-Gm-Message-State: AOAM53066OXxYJ21JuBQIMj+p+gWx9anL2L2G7+ElVICYL7HzjfD2ABZ
        0+LtYp8WnqgVPlGqoHa47LQMAnLMYrnC051hJWdgC+kLSyYuzA==
X-Google-Smtp-Source: ABdhPJzOg/ZcL3/HHm74nct4ghm2+RkxmremugaS4xAjm8QHCVJvqi9Ix+sgC1FxLlEDM5w9rlCwJ2YoF38bKgHDJ5A=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr5520897ybl.347.1604082658167;
 Fri, 30 Oct 2020 11:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <4427E5BD-5EBF-47E8-B7F6-9255BEAE2D53@fb.com>
 <CAEf4BzbtiByaU_-pEV8gVZH1N9_xCTWJBxb6DYPXF5p9b9+_kg@mail.gmail.com> <alpine.LRH.2.21.2010301144050.25037@localhost>
In-Reply-To: <alpine.LRH.2.21.2010301144050.25037@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Oct 2020 11:30:47 -0700
Message-ID: <CAEf4BzbqkbYOybjtdMJRGOO3XKtEJ4ytz+SeKSteJNtsyVAbfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/11] libbpf: split BTF support
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 5:06 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Thu, 29 Oct 2020, Andrii Nakryiko wrote:
>
> > On Thu, Oct 29, 2020 at 5:33 PM Song Liu <songliubraving@fb.com> wrote:
> > >
> > >
> > >
> > > > On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> > > >
> > > > This patch set adds support for generating and deduplicating split BTF. This
> > > > is an enhancement to the BTF, which allows to designate one BTF as the "base
> > > > BTF" (e.g., vmlinux BTF), and one or more other BTFs as "split BTF" (e.g.,
> > > > kernel module BTF), which are building upon and extending base BTF with extra
> > > > types and strings.
> > > >
> > > > Once loaded, split BTF appears as a single unified BTF superset of base BTF,
> > > > with continuous and transparent numbering scheme. This allows all the existing
> > > > users of BTF to work correctly and stay agnostic to the base/split BTFs
> > > > composition.  The only difference is in how to instantiate split BTF: it
> > > > requires base BTF to be alread instantiated and passed to btf__new_xxx_split()
> > > > or btf__parse_xxx_split() "constructors" explicitly.
> > > >
> > > > This split approach is necessary if we are to have a reasonably-sized kernel
> > > > module BTFs. By deduping each kernel module's BTF individually, resulting
> > > > module BTFs contain copies of a lot of kernel types that are already present
> > > > in vmlinux BTF. Even those single copies result in a big BTF size bloat. On my
> > > > kernel configuration with 700 modules built, non-split BTF approach results in
> > > > 115MBs of BTFs across all modules. With split BTF deduplication approach,
> > > > total size is down to 5.2MBs total, which is on part with vmlinux BTF (at
> > > > around 4MBs). This seems reasonable and practical. As to why we'd need kernel
> > > > module BTFs, that should be pretty obvious to anyone using BPF at this point,
> > > > as it allows all the BTF-powered features to be used with kernel modules:
> > > > tp_btf, fentry/fexit/fmod_ret, lsm, bpf_iter, etc.
> > >
> > > Some high level questions. Do we plan to use split BTF for in-tree modules
> > > (those built together with the kernel) or out-of-tree modules (those built
> > > separately)? If it is for in-tree modules, is it possible to build split BTF
> > > into vmlinux BTF?
> >
> > It will be possible to use for both in-tree and out-of-tree. For
> > in-tree, this will be integrated into the kernel build process. For
> > out-of-tree, whoever builds their kernel module will need to invoke
> > pahole -J with an extra flag pointing to the right vmlinux image (I
> > haven't looked into the exact details of this integration, maybe there
> > are already scripts in Linux repo that out-of-tree modules have to
> > use, in such case we can add this integration there).
> >
> > Merging all in-tree modules' BTFs into vmlinux's BTF defeats the
> > purpose of the split BTF and will just increase the size of vmlinux
> > BTF unnecessarily.
> >
>
> Again more of a question about how module BTF will be exposed, but
> I'm wondering if there will be a way for a consumer to ask for
> type info across kernel and module BTF, i.e. something like
> libbpf_find_kernel_btf_id() ?

I'm still playing with the options, but I think libbpf will do all the
search across vmlinux and modules. I'm considering allowing users to
specify module name as an optional hint. Just in case if there are
conflicting types/functions in two different modules with the same
name.

> Similarly will __builtin_btf_type_id()
> work across both vmlinux and modules? I'm thinking of the case where we
> potentially don't know which module a type is defined in.

I think we'll need another built-in/relocation to specify
module/vmlinux ID. Type ID itself is not unique enough to identify the
module.

Alternatively, we can extend its return type to u64 and have BTF
object ID in upper 4 bytes, and BTF type ID in lower 4 bytes. Need to
think about this and discuss it with Yonghong.

>
> I realize in some cases type names may refer to different types in
> different modules (not sure how frequent this is in practice?) but
> I'm curious how the split model for modules will interact with existing
> APIs and helpers.
>
> In some cases it's likely that modules may share types with
> each other that they do not share with vmlinux; in such cases
> will those types get deduplicated also, or is deduplication just
> between kernel/module, and not module/module?

Yes, they will be duplicated in two modules. It's a start schema,
where vmlinux BTF is the base for all kernel modules. It's technically
possible to have a longer chain of BTFs, but we'd need to deal with
dependencies between modules, making sure that dependent BTF is loaded
and available first, etc. That can be added later without breaking
anything, if there is a need.

>
> Sorry I know these questions aren't about this patchset in
> particular, but I'm just trying to get a sense of the bigger
> picture. Thanks!

These are fair questions, I just didn't want to go into too many
details in this particular patch set, because it's pretty agnostic to
all of those concerns. The next patch set will be dealing with all the
details of kernel/user space interface.

>
> Alan
