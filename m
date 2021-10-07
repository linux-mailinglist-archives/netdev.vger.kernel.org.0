Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CB8425C71
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240851AbhJGTpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbhJGTpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:45:17 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DD8C061755
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:43:23 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id p18so7925209vsu.7
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p4NuL35X6Zwa74Ub7hhGNsOOhc7yEa+ucW32Y1XSIEg=;
        b=gPkLWZQ6LSQSA4R5NImb2Zxe+A4oy9/cCIoiRoyY1fHfYMGP18cVBaVscKKZfft5Qv
         8xRbF24RXah8LCW0O+FOmCTCI+nQSzL2dH0ZyKuya0rvsCEPdSwXhiTU8XiOzRtDkESt
         RQYKFPzTdOhbLJRVDm0TdFxBewEJ98b8IKVjalmJwBr4uHxafY8QftGNj5snJHH/icxx
         jupgHJxwAD6BVMKXUV5ZvROIiqT7A0NfiBnXLCmEI9z54SJkPdfgWInNkr4JGNNpwOjV
         I0IameGY+xLsoRLmG6+SZiad50mHero3Kho/gkwmSK7mbcahMGevlo2Jb/RZ9X4Olhpw
         OMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p4NuL35X6Zwa74Ub7hhGNsOOhc7yEa+ucW32Y1XSIEg=;
        b=E6sokts6NhNDFP8HLcV//aiQmKanLW/PwlwxoxoVVa+6ntc1vz0KtD9G1UIipunucb
         hE+LeGCHgqAqlyW2Hkyop9Li5B32rOmAnB2G3osfe3o6o8GW2ABo1lhrmFhKyM+Br97j
         74JSBipKNDndbcOjpquf8zlQh8FUQLBGUegALHDe6NyVdkLtMHWAwBC4lxl+sD7N6wkT
         jzcSw4ZFmoAbpfbf47TPnBkIZ7/RE8Deje9d67wF4THzGq56+N/rYLQuW6QUjcUjLfRS
         FAAaMVyLnxGD83dR8C9aPqz5hUEWZ7m1HY6p5dOrY8LFfXyfLDLcqDAsVs8BaHYQGH2M
         t5XA==
X-Gm-Message-State: AOAM531rmFA2Kz+9zH0VJMH5YQNmiOfrY9fi860a7360X26IBDymtvSU
        1dNSJI5jP5upO7LkoKq2YziwXUaCy2ghkYlnwJLY4g==
X-Google-Smtp-Source: ABdhPJxoTWlafsWNP+6Zko1t0bQuEsJ3fgWv0z+6au5Ky9IQD0Iwc+JEMqrgV9B+6pngy98tVMDRBKIzo2s2s199W+c=
X-Received: by 2002:a67:f2cc:: with SMTP id a12mr6364534vsn.24.1633635802858;
 Thu, 07 Oct 2021 12:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211003192208.6297-1-quentin@isovalent.com> <CAEf4Bzb1MftD6KEvBqgs=wR5VVSLrir_tVBPwwvLu2RvW5=tNA@mail.gmail.com>
In-Reply-To: <CAEf4Bzb1MftD6KEvBqgs=wR5VVSLrir_tVBPwwvLu2RvW5=tNA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Thu, 7 Oct 2021 20:43:11 +0100
Message-ID: <CACdoK4+4iB-aquCgxXV9BYcXZpPrREZrnm+G8hau-SOt8QPtqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/10] install libbpf headers when using the library
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 at 19:28, Andrii Nakryiko <andrii.nakryiko@gmail.com> wr=
ote:
>
> On Sun, Oct 3, 2021 at 12:22 PM Quentin Monnet <quentin@isovalent.com> wr=
ote:
> >
> > Libbpf is used at several locations in the repository. Most of the time=
,
> > the tools relying on it build the library in its own directory, and inc=
lude
> > the headers from there. This works, but this is not the cleanest approa=
ch.
> > It generates objects outside of the directory of the tool which is bein=
g
> > built, and it also increases the risk that developers include a header =
file
> > internal to libbpf, which is not supposed to be exposed to user
> > applications.
> >
> > This set adjusts all involved Makefiles to make sure that libbpf is bui=
lt
> > locally (with respect to the tool's directory or provided build directo=
ry),
> > and by ensuring that "make install_headers" is run from libbpf's Makefi=
le
> > to export user headers properly.
> >
> > This comes at a cost: given that the libbpf was so far mostly compiled =
in
> > its own directory by the different components using it, compiling it on=
ce
> > would be enough for all those components. With the new approach, each
> > component compiles its own version. To mitigate this cost, efforts were
> > made to reuse the compiled library when possible:
> >
> > - Make the bpftool version in samples/bpf reuse the library previously
> >   compiled for the selftests.
> > - Make the bpftool version in BPF selftests reuse the library previousl=
y
> >   compiled for the selftests.
> > - Similarly, make resolve_btfids in BPF selftests reuse the same compil=
ed
> >   library.
> > - Similarly, make runqslower in BPF selftests reuse the same compiled
> >   library; and make it rely on the bpftool version also compiled from t=
he
> >   selftests (instead of compiling its own version).
> > - runqslower, when compiled independently, needs its own version of
> >   bpftool: make them share the same compiled libbpf.
> >
> > As a result:
> >
> > - Compiling the samples/bpf should compile libbpf just once.
> > - Compiling the BPF selftests should compile libbpf just once.
> > - Compiling the kernel (with BTF support) should now lead to compiling
> >   libbpf twice: one for resolve_btfids, one for kernel/bpf/preload.
> > - Compiling runqslower individually should compile libbpf just once. Sa=
me
> >   thing for bpftool, resolve_btfids, and kernel/bpf/preload/iterators.
> >
> > (Not accounting for the boostrap version of libbpf required by bpftool,
> > which was already placed under a dedicated .../boostrap/libbpf/ directo=
ry,
> > and for which the count remains unchanged.)
> >
> > A few commits in the series also contain drive-by clean-up changes for
> > bpftool includes, samples/bpf/.gitignore, or test_bpftool_build.sh. Ple=
ase
> > refer to individual commit logs for details.
> >
> > v3:
>
> Please see few problems with libbpf_hdrs phony targets. Seems like
> they all can be order-only dependencies and not causing unnecessary
> rebuilds.

Nice catch, I didn't realise it would force rebuilding :(. I'll
address it in the next version. I'll also add a few adjustments to
libbpf's and bpftool's Makefiles to make sure we don't recompile when
not necessary, because of the header files that are currently
installed unconditionally.

> Can you please also normalize your patch prefixes for bpftool and
> other tools? We've been using a short and simple "bpftool: " prefix
> for bpftool-related changes, and for other tools it would be just
> "tools/runqslower" or "tools/resolve_btfids". Please update
> accordingly. Thanks!

$ git log --oneline --pretty=3D'format:%s' -- tools/bpf/bpftool/ | \
        grep -oE '^(bpftool:|tools: bpftool:)' | sort | uniq -c
   128 bpftool:
   194 tools: bpftool:

... And =E2=80=9Cwe=E2=80=9D've been using =E2=80=9Ctools: bpftool:=E2=80=
=9D since the early days :).
But yeah sure, I'll adjust. Shorter looks better. Just wondering, are
those prefixes documented anywhere?

Thanks,
Quentin
