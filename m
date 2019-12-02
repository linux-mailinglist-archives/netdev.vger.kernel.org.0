Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E5C10F0D0
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 20:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfLBTlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 14:41:19 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37912 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbfLBTlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 14:41:18 -0500
Received: by mail-qt1-f195.google.com with SMTP id 14so998548qtf.5;
        Mon, 02 Dec 2019 11:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hnXSdtM2jXSIPFsEbX5RTRrRiyHO+CE1VUT7gOr/2M4=;
        b=fCK6Gg8hYc4SNe745wEdMOVP+HtvK5sIkeU+cJ9KOrU6HoobGT7wOKZIPSnqa/5RgO
         y6IA78Ybfqj2vuAeKNjfIR/GWPdPntaYhKI7S42diypnq3yh1qC0tOwuEtFlbOhDj4JL
         /RHHfmX4P9dIH72B02JeorGddEv8Qa+XJi92XXQMJaFDvDBpg1Qm2Ke/iHRIsAUIzlI8
         toRVUbdW3tqkpsA85WUDvfkk0zimuhDVLnOui1whGGXAL/5NzOiIVH7P8G7n5YBpAR8s
         i+VjMftbIzfS5NECgnKmhglTxN/u7E1ub0T47mriepqjskO3pEtP0rzIPPHknFyu8hEv
         9zzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hnXSdtM2jXSIPFsEbX5RTRrRiyHO+CE1VUT7gOr/2M4=;
        b=fAP3MVtVlYubAm9NM2P7wDv5VylStDxVApxwcTyL16KVDI6fnEUKPnPoPQTx83FwJw
         wIzNQHPZORzHtIL02As/7hV5Y+3pxEdTwJl69Btd5zb+M5XT1GpkuXQEJHi1NDQqHRDE
         Ez+OncWNFxxhehktdBe/aP0LLWxFhurlTzUe5Aer9GTR6ezRpertn5Y/8c4Yw/P+lfvL
         l9N9jQM4RGCatVXAX2mL9zL3sFX9X6MrYaxJ8y/+9NnfK5HI3cE9G7YEoW3y8T0xzksw
         BF1OzMYpnHe13Yrq9f4hkOnOnn00wz+PU770osGrg2mRZkVWI2r7VFjzvv1ZqifISVLG
         Hw0A==
X-Gm-Message-State: APjAAAXYPtubudkl/BsFd9o4SZTbbgZaqmeUgGCfXedIaFj5atlYDGeF
        L7gku8bmSCH0o73bBxooADO4x3ZngmKGyqHpY7g=
X-Google-Smtp-Source: APXvYqx79Jx15ZaMY0yYH5conUQninxbInqCLdXwSB5RAdUQYZp6whKm9yp12Mxb0nAX+zNiq3RaXHacEb4s2abb7ks=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr1081151qtq.93.1575315676789;
 Mon, 02 Dec 2019 11:41:16 -0800 (PST)
MIME-Version: 1.0
References: <20191202131847.30837-1-jolsa@kernel.org>
In-Reply-To: <20191202131847.30837-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Dec 2019 11:41:05 -0800
Message-ID: <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 5:19 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> adding support to link bpftool with libbpf dynamically,
> and config change for perf.
>
> It's now possible to use:
>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1
>
> which will detect libbpf devel package and if found, link it with bpftool.
>
> It's possible to use arbitrary installed libbpf:
>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/
>
> I based this change on top of Arnaldo's perf/core, because
> it contains libbpf feature detection code as dependency.
>
> Also available in:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   libbpf/dyn
>
> v4 changes:
>   - based on Toke's v3 post, there's no need for additional API exports:
>
>     Since bpftool uses bits of libbpf that are not exported as public API in
>     the .so version, we also pass in libbpf.a to the linker, which allows it to
>     pick up the private functions from the static library without having to
>     expose them as ABI.

Whoever understands how this is supposed to work, can you please
explain? From reading this, I think what we **want** is:

- all LIBBPF_API-exposed APIs should be dynamically linked against libbpf.so;
- everything else used from libbpf (e.g., netlink APIs), should come
from libbpf.a.

Am I getting the idea right?

If yes, are we sure it actually works like that in practice? I've
compiled with LIBBPF_DYNAMIC=1, and what I see is that libelf, libc,
zlib, etc functions do have relocations against them in ".rela.plt"
section. None of libbpf exposed APIs, though, have any of such
relocations. Which to me suggests that they are just statically linked
against libbpf.a and libbpf.so is just recorded in ELF as a dynamic
library dependency because of this extra -lbpf flag. Which kind of
defeats the purpose of this whole endeavor, no?

I'm no linker expert, though, so I apologize if I got it completely
wrong, would really appreciate someone to detail this a bit more.
Thanks!

>
>   - changing some Makefile variable names
>   - documenting LIBBPF_DYNAMIC and LIBBPF_DIR in the Makefile comment
>   - extending test_bpftool_build.sh with libbpf dynamic link
>
> thanks,
> jirka
>
>
> ---
> Jiri Olsa (6):
>       perf tools: Allow to specify libbpf install directory
>       bpftool: Allow to link libbpf dynamically
>       bpftool: Rename BPF_DIR Makefile variable to LIBBPF_SRC_DIR
>       bpftool: Rename LIBBPF_OUTPUT Makefile variable to LIBBPF_BUILD_OUTPUT
>       bpftool: Rename LIBBPF_PATH Makefile variable to LIBBPF_BUILD_PATH
>       selftests, bpftool: Add build test for libbpf dynamic linking
>
>  tools/bpf/bpftool/Makefile                        | 54 ++++++++++++++++++++++++++++++++++++++++++++++--------
>  tools/perf/Makefile.config                        | 27 ++++++++++++++++++++-------
>  tools/testing/selftests/bpf/test_bpftool_build.sh | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 119 insertions(+), 15 deletions(-)
>
