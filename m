Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9AD29FB59
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgJ3Cd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3Cd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:33:27 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF52C0613CF;
        Thu, 29 Oct 2020 19:33:27 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id n142so3900336ybf.7;
        Thu, 29 Oct 2020 19:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqyWJvIbQ2m2Q07/bq5tarOXlrpOxgQxrm0lLsIywI4=;
        b=WgykwtdHaKmz2H54pqo/02jf77lvV2bEpU9uy4lUwMbpNZilswcC41Rm9GLoFkssrv
         vzpQMm66i3BipHrDEMUOHmLbdo0eYvOjHD/xCrXyrUdclpPWVbJtDpo3X0TJRJM13zGL
         Qi/7x2RncQg1Cw3OWd1bJnBe6U+yoxBn7PBaJzdC69fdneCLjWwlcAhlu0jFRfZp7HOJ
         DpdQFxd/z109P+MgNcasoyrTYUwPj+1fLgsmXML5OVD3KO8DBu9FqDxunyBZ57LnZpOb
         uDw7u30wGZrwNkesUr7CkeJVEkCJe/BiGkV+sM78CX3Gk5AftAnC2q55AH30sftVPlt6
         eqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqyWJvIbQ2m2Q07/bq5tarOXlrpOxgQxrm0lLsIywI4=;
        b=QswjeOJGnd/FimXcK3jgW/pgf0bcPv3Lc+cknYT6j/l7F7oLqD/uT1QBZA6IA9BJR3
         HQxCmKuRrudnUVS30K02W0jg9MXRiRE36iOGldRjQvIjkuIw3KNgtomlR16HF++Cpn/R
         jIiFdsNYeK7SQeNMnGEEyI6ZunKggo422j0Qn7RkmqdOy6i/GCMhO6cqsVilb75IA3aJ
         2o8ptqAua9vUADpY9Yz4JItU2O1ImKXzm8Cins5y3YqNj75MKshgVJt5mYFh0rLv6XjA
         y1AGMzv9mbusNr9NioV9Z06YUPv1iMquykGir3tEcp9jJizIuiiKdgRX6TEGG5dZymwd
         dSyA==
X-Gm-Message-State: AOAM530nw75LUv1T9zEf9zHqUZcZ2vTdCoZCcABePYVLH+mIDIYLSSPo
        fX+FrbJxybCIehPjwVTtB1WgGi5oMKSlU/nJ6j8=
X-Google-Smtp-Source: ABdhPJwxTZvtp9c3al0IBnwajkcu6AqoaKf0VGqZCGClaUCr5qEt4NLwwMqKyMZViLmoQpUduFfMLAkwXhs2OOiUcJg=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr550277ybg.459.1604025206750;
 Thu, 29 Oct 2020 19:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <4427E5BD-5EBF-47E8-B7F6-9255BEAE2D53@fb.com>
In-Reply-To: <4427E5BD-5EBF-47E8-B7F6-9255BEAE2D53@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 19:33:15 -0700
Message-ID: <CAEf4BzbtiByaU_-pEV8gVZH1N9_xCTWJBxb6DYPXF5p9b9+_kg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/11] libbpf: split BTF support
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 5:33 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > This patch set adds support for generating and deduplicating split BTF. This
> > is an enhancement to the BTF, which allows to designate one BTF as the "base
> > BTF" (e.g., vmlinux BTF), and one or more other BTFs as "split BTF" (e.g.,
> > kernel module BTF), which are building upon and extending base BTF with extra
> > types and strings.
> >
> > Once loaded, split BTF appears as a single unified BTF superset of base BTF,
> > with continuous and transparent numbering scheme. This allows all the existing
> > users of BTF to work correctly and stay agnostic to the base/split BTFs
> > composition.  The only difference is in how to instantiate split BTF: it
> > requires base BTF to be alread instantiated and passed to btf__new_xxx_split()
> > or btf__parse_xxx_split() "constructors" explicitly.
> >
> > This split approach is necessary if we are to have a reasonably-sized kernel
> > module BTFs. By deduping each kernel module's BTF individually, resulting
> > module BTFs contain copies of a lot of kernel types that are already present
> > in vmlinux BTF. Even those single copies result in a big BTF size bloat. On my
> > kernel configuration with 700 modules built, non-split BTF approach results in
> > 115MBs of BTFs across all modules. With split BTF deduplication approach,
> > total size is down to 5.2MBs total, which is on part with vmlinux BTF (at
> > around 4MBs). This seems reasonable and practical. As to why we'd need kernel
> > module BTFs, that should be pretty obvious to anyone using BPF at this point,
> > as it allows all the BTF-powered features to be used with kernel modules:
> > tp_btf, fentry/fexit/fmod_ret, lsm, bpf_iter, etc.
>
> Some high level questions. Do we plan to use split BTF for in-tree modules
> (those built together with the kernel) or out-of-tree modules (those built
> separately)? If it is for in-tree modules, is it possible to build split BTF
> into vmlinux BTF?

It will be possible to use for both in-tree and out-of-tree. For
in-tree, this will be integrated into the kernel build process. For
out-of-tree, whoever builds their kernel module will need to invoke
pahole -J with an extra flag pointing to the right vmlinux image (I
haven't looked into the exact details of this integration, maybe there
are already scripts in Linux repo that out-of-tree modules have to
use, in such case we can add this integration there).

Merging all in-tree modules' BTFs into vmlinux's BTF defeats the
purpose of the split BTF and will just increase the size of vmlinux
BTF unnecessarily.

>
> Thanks,
> Song
>
> [...]
