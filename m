Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FA3DB04D
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 02:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhG3AcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 20:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhG3AcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 20:32:04 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F80C061765;
        Thu, 29 Jul 2021 17:32:01 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id w17so13036248ybl.11;
        Thu, 29 Jul 2021 17:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kSHXomxxiy7ULxfcFDer3ChErdOp/OG3+LX3KVwPf1E=;
        b=S1feKbsHTLGYMxrMndK8bCsUEcG5O8EypW88L+pKSIAS3WRbU++zi1Y17OtCbz1PjA
         llli6J9BG8L9YWcJAeckIDrHj6MPLjEIVWnTnpzuXXwt/wZg3G6cbjgPrcL863pEKltg
         r73iEwUg9ylYh4WJthlCGYu2VXZf9CCBxFI7BDVL4GMpThtdiGUi6NvJQVIW/5L+1dYO
         cXWwXf60ByhCvQiRuTAyYjVgYakv742taIBtPRspglzMOMm+VeTO0Ld2SNCGZ3r7zG3D
         8k+7xAYXGCtfcgc86HqXX7juKhwVgDLTnnfY6+gKpoGCgVEVx/8OwhbtCoxxsng+kpZN
         LddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kSHXomxxiy7ULxfcFDer3ChErdOp/OG3+LX3KVwPf1E=;
        b=BgLX5Zoa6GheLQ9WxO4h5BhVQPbVBnC0dX+G6XJuTHtyb/y6OZ7FN/NFa9XWz+62Kc
         kq7NEplmh8uy8s3TI36srpC++9kMLhvM+MxUmOC5H562Lqa6ULUjyoDmTaPSgnF8fih/
         KnSXq9HehFkS5NkwO2dSu4ujVLkRKWvbUJsHq6A3UCf+5c9iUsEOZrjBXrEJflNwLuiR
         5XdoZBWyJUcxc82bI0HaVZdOenmVQwpkbLhllOt5yLGmM4E3iUTJ6m8nLpleBNvPztjw
         JEmwr/J+UUS3dRUFjRHsnCo11AyvXUlcm/7em0WKRUButk3YhXEzEGGhT2NkGto2zCv2
         QvEQ==
X-Gm-Message-State: AOAM532b33oDasjPGeC4zgF/W7kovnFu3mlV8V4CrKtU3CCMRidYEyis
        qjgknt/PXEJmbUtFtjxiGmtpTmCCqHSckJ5rGy8=
X-Google-Smtp-Source: ABdhPJzRInD3fZ2PiozXyWu4P5s3LYJUtB4ywm/OJPWd2OjZuMkMEnYeURXb1lbr58kHSKWEGUyfpJfD1lMMjPEGWvk=
X-Received: by 2002:a25:b741:: with SMTP id e1mr10292028ybm.347.1627605120289;
 Thu, 29 Jul 2021 17:32:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162028.29512-1-quentin@isovalent.com>
In-Reply-To: <20210729162028.29512-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Jul 2021 17:31:49 -0700
Message-ID: <CAEf4BzbrQOr8Z2oiywT-zPBEz9jbP9_6oJXOW28LdOaqAy8pLw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/8] libbpf: rename btf__get_from_id() and
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

On Thu, Jul 29, 2021 at 9:20 AM Quentin Monnet <quentin@isovalent.com> wrote:
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
> The old functions are marked for deprecation for the next minor version
> (0.6) of libbpf.
>
> The last patch is a trivial change to bpftool to add support for dumping
> split BTF objects by referencing them by their id (and not only by their
> BTF path).
>
> [0] https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>
> v3:
> - Use libbpf_err_ptr() in btf__load_from_kernel_by_id(), ERR_PTR() in
>   bpftool's get_map_kv_btf().
> - Move the definition of btf__load_from_kernel_by_id() closer to the
>   btf__parse() group in btf.h (move the legacy function with it).
> - Fix a bug on the return value in libbpf_find_prog_btf_id(), as a new
>   patch.
> - Move the btf__free() fixes to their own patch.
> - Add "Fixes:" tags to relevant patches.
> - Re-introduce deprecation (removed in v2) for the legacy functions, as a
>   new macro LIBBPF_DEPRECATED_SINCE(major, minor, message).
>
> v2:
> - Remove deprecation marking of legacy functions (patch 4/6 from v1).
> - Make btf__load_from_kernel_by_id{,_split}() return the btf struct, adjust
>   surrounding code and call btf__free() when missing.
> - Add new functions to v0.5.0 API (and not v0.6.0).
>
> Quentin Monnet (8):
>   libbpf: return non-null error on failures in libbpf_find_prog_btf_id()
>   libbpf: rename btf__load() as btf__load_into_kernel()
>   libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
>   tools: free BTF objects at various locations
>   tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
>   libbpf: prepare deprecation of btf__get_from_id(), btf__load()
>   libbpf: add split BTF support for btf__load_from_kernel_by_id()
>   tools: bpftool: support dumping split BTF by id
>
>  tools/bpf/bpftool/btf.c                      |  8 ++---
>  tools/bpf/bpftool/btf_dumper.c               |  6 ++--
>  tools/bpf/bpftool/map.c                      | 14 ++++-----
>  tools/bpf/bpftool/prog.c                     | 29 +++++++++++------
>  tools/lib/bpf/Makefile                       |  3 ++
>  tools/lib/bpf/btf.c                          | 33 ++++++++++++++------
>  tools/lib/bpf/btf.h                          |  7 ++++-
>  tools/lib/bpf/libbpf.c                       | 11 ++++---
>  tools/lib/bpf/libbpf.map                     |  3 ++
>  tools/lib/bpf/libbpf_common.h                | 19 +++++++++++
>  tools/perf/util/bpf-event.c                  | 11 ++++---
>  tools/perf/util/bpf_counter.c                | 12 +++++--
>  tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
>  13 files changed, 113 insertions(+), 47 deletions(-)
>
> --
> 2.30.2
>

I dropped patch #7 with deprecations and LIBBPF_DEPRECATED_SINCE and
applied to bpf-next.

Current LIBBPF_DEPRECATED_SINCE approach doesn't work (and you should
have caught this when you built selftests/bpf, what happened there?).
bpftool build generates warnings like this:

In file included from /data/users/andriin/linux/tools/lib/bpf/libbpf.h:20,
                 from xlated_dumper.c:10:
/data/users/andriin/linux/tools/lib/bpf/libbpf_common.h:22:23:
warning: "LIBBPF_MAJOR_VERSION" is not defined, evaluates to 0
[-Wundef]
  __LIBBPF_GET_VERSION(LIBBPF_MAJOR_VERSION, LIBBPF_MINOR_VERSION)
                       ^~~~~~~~~~~~~~~~~~~~


And it makes total sense. LIBBPF_DEPRECATED_SINCE() assumes
LIBBPF_MAJOR_VERSION/LIBBPF_MINOR_VERSION is defined at compilation
time of the *application that is using libbpf*, not just libbpf's
compilation time. And that's clearly a bogus assumption which we can't
and shouldn't make. The right approach will be to define
LIBBPF_MAJOR_VERSION/LIBBPF_MINOR_VERSION in some sort of
auto-generated header, included from libbpf_common.h and installed as
part of libbpf package.

Anyways, I've removed all the LIBBPF_DEPRECATED_SINCE stuff and
applied all the rest, as it looks good and is a useful addition. We
should work some more on deprecation helpers, though.
