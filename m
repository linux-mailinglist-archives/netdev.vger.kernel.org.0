Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986453D3111
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 02:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhGWARw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 20:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhGWARv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 20:17:51 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21DDC061575;
        Thu, 22 Jul 2021 17:58:24 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id g19so6058707ybe.11;
        Thu, 22 Jul 2021 17:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XY9S1AuMOoiZLT8lu0UUrr/vYDSkg3NrmEXpExurs6I=;
        b=Pseb9EcPzgX6jMTwv7pcKjyFqf2tRQkxgzayVQe2QCFcU0Wb4H5si9TDZ25D7NKlk/
         JisVt93PVM0p4Xj3LkROlIPBDR+c7cFNPH+dGQzlfnA8UzWPToMtIQgBA7oikHKmVuf8
         9op4YVtT3wn66FhglFRzvI/3EHDL68TJgQRtyHBzKFn63w/WNIFX1/XfwwLiG1sYHDMy
         dXcamdHawBHeeoMdwaDYfugo7RRBOlVb0S6fAxLrcc7MdVvVmWRW8HOy0xhy308t4e1y
         WxPa2wIzxLUzYcEuYvYA1S4OUu5PmK/LJ4Vo0SJC1khwXCS2k7FZRHzmlNp+jAZd39Yv
         6U9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XY9S1AuMOoiZLT8lu0UUrr/vYDSkg3NrmEXpExurs6I=;
        b=Xo7gegMrQfo0m80BjS0Ev4ejHNahjGYQLBISOAjyiZIu7Y7z1eIlKHoIgTlmJXNzbq
         vIegLUCJrcQ3vTWZ1dTxEakdtlezxRGkSO1RipyzgtkOJjaU0RVUnOwFXqAft/556N0j
         bChf2+HEh1rdyNEwJMm8MjwHekTN9B/srW2apiq8LKu9UOSBlmVwX48MF32gqbEUUP0p
         kidtSjwBdAzU42JkllwRjG0dQs6GswLLRDC8UJW0iGrnCenus8PBTjLvGYSnWQXO5NkL
         4QXN3bJMiQbfN/2mZDOGP/umXx+7bfLw5V+GRbMTJDN6U6jOcS43JVgYD8Hu7bGZMoCB
         X2Xg==
X-Gm-Message-State: AOAM533hOHijQ+Z0n/yO6sn1SIoUIDXg91PVay/z5Xh4unNukJh0kevq
        7FFO1JjYYW1GRT/Jv/tJTLVjgRIr+1+bxRZuErc=
X-Google-Smtp-Source: ABdhPJzGzTxVj/JpF9qTEnQfrKJPD+U0Q2rtYGISHJltOe3KEgMF+xAreLhdr6wfeJtjqv0gw3H/D9d0DhFWYmuXabU=
X-Received: by 2002:a25:b203:: with SMTP id i3mr3066407ybj.260.1627001903881;
 Thu, 22 Jul 2021 17:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com>
In-Reply-To: <20210721153808.6902-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 17:58:12 -0700
Message-ID: <CAEf4Bzb30BNeLgio52OrxHk2VWfKitnbNUnO0sAXZTA94bYfmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/5] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> As part of the effort to move towards a v1.0 for libbpf [0], this set
> improves some confusing function names related to BTF loading from and to
> the kernel:
>
> - btf__load() becomes btf__load_into_kernel().
> - btf__get_from_id becomes btf__load_from_kernel_by_id().
> - A new version btf__load_from_kernel_by_id_split() extends the former to
>   add support for split BTF.
>
> The old functions are not removed or marked as deprecated yet, there
> should be in a future libbpf version.

Oh, and I was thinking about this whole deprecation having to be done
in two steps. It's super annoying to keep track of that. Ideally, we'd
have some macro that can mark API deprecated "in the future", when
actual libbpf version is >= to defined version. So something like
this:

LIBBPF_DEPRECATED_AFTER(V(0,5), "API that will be marked deprecated in v0.6")


We'd need to make sure that during the build time we have some
LIBBPF_VERSION macro available against which we compare the expected
version and add or not the __attribute__((deprecated)).

Does this make sense? WDYT? I haven't looked into how hard it would be
to implement this, but it should be easy enough, so if you'd like some
macro challenge, please take a stab at it.

Having this it would be possible to make all the deprecations at the
same time that we add replacement APIs and not ask anyone to follow-up
potentially a month or two later, right?

>
> The last patch is a trivial change to bpftool to add support for dumping
> split BTF objects by referencing them by their id (and not only by their
> BTF path).
>
> [0] https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>
> v2:
> - Remove deprecation marking of legacy functions (patch 4/6 from v1).
> - Make btf__load_from_kernel_by_id{,_split}() return the btf struct.
> - Add new functions to v0.5.0 API (and not v0.6.0).
>
> Quentin Monnet (5):
>   libbpf: rename btf__load() as btf__load_into_kernel()
>   libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
>   tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
>   libbpf: add split BTF support for btf__load_from_kernel_by_id()
>   tools: bpftool: support dumping split BTF by id
>
>  tools/bpf/bpftool/btf.c                      |  8 ++---
>  tools/bpf/bpftool/btf_dumper.c               |  6 ++--
>  tools/bpf/bpftool/map.c                      | 16 +++++-----
>  tools/bpf/bpftool/prog.c                     | 29 +++++++++++------
>  tools/lib/bpf/btf.c                          | 33 ++++++++++++++------
>  tools/lib/bpf/btf.h                          |  4 +++
>  tools/lib/bpf/libbpf.c                       |  7 +++--
>  tools/lib/bpf/libbpf.map                     |  3 ++
>  tools/perf/util/bpf-event.c                  | 11 ++++---
>  tools/perf/util/bpf_counter.c                | 12 +++++--
>  tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
>  11 files changed, 86 insertions(+), 47 deletions(-)
>
> --
> 2.30.2
>
