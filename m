Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582C03C367
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 07:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391171AbfFKFVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 01:21:20 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39244 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391044AbfFKFVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 01:21:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id i34so13075494qta.6;
        Mon, 10 Jun 2019 22:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SK1nr6e/IQruUd6K4MJq+bdWbcaM5x45pX6JLMdcey0=;
        b=kt7AEM4Rj+F8+dy8yiT0RW/xyrb9+enazFkCYXUwFnKsPjTU2N8P3ADr/QQ/dJJRAw
         CiPd7R35Hdz1XGZ0Av9keD2oTdcXBQiR6tn150N7h4LZMEGHE6xHJdjZdOMBNd7+n1Oz
         vzvhS2Et99murispr6VyyjQvn5Yr+HvloDe2cNv3SkhbI8qKLPc+B/NSz8gNJ/y/3rXn
         qVHag8PMPPnBBb3LRZ66EiOZ+XhCKNN8tYeW53bnAppx6zbV9KnZhrwSFYOWcNIMsmQl
         yixlVhLGm7TCPuyRc1abi5ctyngCULvGMp3IaSjSQ1h76oofjFxzTHr161XqbFJQ6Rmd
         wtww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SK1nr6e/IQruUd6K4MJq+bdWbcaM5x45pX6JLMdcey0=;
        b=k6FJogaeq51rP/thsIumJcvv8k0tV+sfuFSwaofzAixhTWjOF78vwgfLKuZeWcYBBA
         WVMIqrf3AvoRlmn9+/zZHbopFWRdCJN03s9lCVmQGKHabzENFsbo+Eeg0M4JP6sieXRK
         WW7UARyhQJBaJJ/Fyw5YPDqcoejeoFPNMmPQzl3u9ByLhVPQR0tbqzLP7/+/eEl5/sTG
         8Y65Lu1wh02q+Jwwibpe/mP71qzlc+uGg5pbT3xXRCTe7MXMx1c83jlcuKgPxcREVKzF
         YfCC9LQabW9o3wiH4Kjgt11iLtCefq4T1H1s9cW960crWNZStzRBTC5KT1iulswvrBDz
         81vw==
X-Gm-Message-State: APjAAAVwiDMY3LLvYZgqKWflSaelA0wBF4fksofkWvRtAoxe+dCAQb5Y
        s/IUOQ/N/8k3mL35U826BBVEvusXX53o1ZQb4IE=
X-Google-Smtp-Source: APXvYqxoLuPEOBoXwc2DChE3MeBxGPQdvXx5j6GOs+w3lI//eezctUadsxzoh6ME3U1SRyMaZg0lz4N2kN1d40c0z7Q=
X-Received: by 2002:ac8:1087:: with SMTP id a7mr48866882qtj.141.1560230478347;
 Mon, 10 Jun 2019 22:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com>
In-Reply-To: <20190611044747.44839-1-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Jun 2019 22:21:07 -0700
Message-ID: <CAEf4Bzauq8GNk9F2z4vh1fqQuKg_7BusbhwmFU+gS16e8oKGmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] BTF-defined BPF map definitions
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 9:48 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set implements initial version (as discussed at LSF/MM2019
> conference) of a new way to specify BPF maps, relying on BTF type information,
> which allows for easy extensibility, preserving forward and backward
> compatibility. See details and examples in description for patch #6.
>
> [0] contains an outline of follow up extensions to be added after this basic
> set of features lands. They are useful by itself, but also allows to bring
> libbpf to feature-parity with iproute2 BPF loader. That should open a path
> forward for BPF loaders unification.
>
> Patch #1 centralizes commonly used min/max macro in libbpf_internal.h.
> Patch #2 extracts .BTF and .BTF.ext loading loging from elf_collect().
> Patch #3 refactors map initialization logic into user-provided maps and global
> data maps, in preparation to adding another way (BTF-defined maps).
> Patch #4 adds support for map definitions in multiple ELF sections and
> deprecates bpf_object__find_map_by_offset() API which doesn't appear to be
> used anymore and makes assumption that all map definitions reside in single
> ELF section.
> Patch #5 splits BTF intialization from sanitization/loading into kernel to
> preserve original BTF at the time of map initialization.
> Patch #6 adds support for BTF-defined maps.
> Patch #7 adds new test for BTF-defined map definition.
> Patch #8 converts test BPF map definitions to use BTF way.
>
> [0] https://lore.kernel.org/bpf/CAEf4BzbfdG2ub7gCi0OYqBrUoChVHWsmOntWAkJt47=FE+km+A@mail.gmail.com/
>
> rfc->v1:
> - error out on unknown field by default (Stanislav, Jakub, Lorenz);
>
> Andrii Nakryiko (8):
>   libbpf: add common min/max macro to libbpf_internal.h
>   libbpf: extract BTF loading and simplify ELF parsing logic
>   libbpf: refactor map initialization
>   libbpf: identify maps by section index in addition to offset
>   libbpf: split initialization and loading of BTF
>   libbpf: allow specifying map definitions using BTF
>   selftests/bpf: add test for BTF-defined maps
>   selftests/bpf: switch tests to BTF-defined map definitions

I'm posting this as v1 to move discussion forward.

Important point that we haven't discussed extensively is whether we
should allow applications to specify custom fields as part of map
definition and if yes, what's the best way to expose that to
application.

I think we should avoid that and let applications handle app-specific
per-map customizations using "associated" app-specific metadata
struct, e.g.:

/* map definition for libbpf */
struct {
    __u32 *key;
    struct my_value *value;
    __u32 type;
} my_fancy_map SEC(".maps") = {
    .type = BPF_MAP_TYPE_ARRAY,
};

/* app-specific associated metadata, based on map name convention */
struct {
    struct my_fancy_meta tag;
    __u32 some_app_id;
} my_fancy_map__metadata = {
    .tag = {
        /* ... */
    },
    .some_app_id = 123,
};

Then application itself can find corresponding BTF variable/type and
parse data as it sees fit.

In any case, it's not hard to add this later, but it would be good to
see some realistic use cases where app-specific stuff needs to be part
of BPF map definition.

Some reasons to avoid this:
1. Potential name conflicts when in the future libbpf adds a new
supported field.
2. Need to add APIs to expose this to application (callback, or expose
map definition BTF type ID, or something along those lines). As app
metadata can be of any type, we'll need to stick to very generic
information, like: BTF type ID of struct + field info (name, #,
offset, size), pointer to data section. At that point complexity of
dealing with this extra metadata seems equivalent to just letting app
find `my_fancy_map__metadata` struct and parse it, while also
complicating libbpf APIs.
3. In general, mixing together standardized map definition with ad-hoc
application metadata seems like a bad idea and makes documenting all
that more awkward.

As for syntax of key/value type capturing. We are down to two
realistic candidates:

1. struct {
    __u32 *key;
    struct my_value *value;
} ...

2. struct {
    struct {
        __u32 key;
        struct my_value value;
    } types[]; /* has to be last field, or otherwise need explicit [0] size */
} ...


I prefer first for simplicity and less visual clutter. That pointer
can be explained very succinctly in documentation, I don't think it's
a big deal or is hard to grasp. In both cases we'll need to include
justification of why it's not just inlined types (ELF size savings).

There will be three distinctive cases for key/value syntax:

- pointer to some type: this captures key/value type and size, without
pre-initializing map;
- inlined struct w/ another map definition - map-in-map case, pretty
distinctive special case;
- array of elements of some type - static pre-initialization w/
values, initially supported for BPF_MAP_TYPE_PROG_ARRAY and
map-in-maps, but potentially can be extended further, e.g., for normal
arrays.

Latter two are advanced rare cases, but indispensable for when you need it.

Hope this helps a bit, thanks!


>
>  tools/lib/bpf/bpf.c                           |   7 +-
>  tools/lib/bpf/bpf_prog_linfo.c                |   5 +-
>  tools/lib/bpf/btf.c                           |   3 -
>  tools/lib/bpf/btf.h                           |   1 +
>  tools/lib/bpf/btf_dump.c                      |   3 -
>  tools/lib/bpf/libbpf.c                        | 767 +++++++++++++-----
>  tools/lib/bpf/libbpf_internal.h               |   7 +
>  tools/testing/selftests/bpf/progs/bpf_flow.c  |  18 +-
>  .../selftests/bpf/progs/get_cgroup_id_kern.c  |  18 +-
>  .../testing/selftests/bpf/progs/netcnt_prog.c |  22 +-
>  .../selftests/bpf/progs/sample_map_ret0.c     |  18 +-
>  .../selftests/bpf/progs/socket_cookie_prog.c  |   9 +-
>  .../bpf/progs/sockmap_verdict_prog.c          |  36 +-
>  .../selftests/bpf/progs/test_btf_newkv.c      |  73 ++
>  .../bpf/progs/test_get_stack_rawtp.c          |  27 +-
>  .../selftests/bpf/progs/test_global_data.c    |  27 +-
>  tools/testing/selftests/bpf/progs/test_l4lb.c |  45 +-
>  .../selftests/bpf/progs/test_l4lb_noinline.c  |  45 +-
>  .../selftests/bpf/progs/test_map_in_map.c     |  20 +-
>  .../selftests/bpf/progs/test_map_lock.c       |  22 +-
>  .../testing/selftests/bpf/progs/test_obj_id.c |   9 +-
>  .../bpf/progs/test_select_reuseport_kern.c    |  45 +-
>  .../bpf/progs/test_send_signal_kern.c         |  22 +-
>  .../bpf/progs/test_skb_cgroup_id_kern.c       |   9 +-
>  .../bpf/progs/test_sock_fields_kern.c         |  60 +-
>  .../selftests/bpf/progs/test_spin_lock.c      |  33 +-
>  .../bpf/progs/test_stacktrace_build_id.c      |  44 +-
>  .../selftests/bpf/progs/test_stacktrace_map.c |  40 +-
>  .../testing/selftests/bpf/progs/test_tc_edt.c |   9 +-
>  .../bpf/progs/test_tcp_check_syncookie_kern.c |   9 +-
>  .../selftests/bpf/progs/test_tcp_estats.c     |   9 +-
>  .../selftests/bpf/progs/test_tcpbpf_kern.c    |  18 +-
>  .../selftests/bpf/progs/test_tcpnotify_kern.c |  18 +-
>  tools/testing/selftests/bpf/progs/test_xdp.c  |  18 +-
>  .../selftests/bpf/progs/test_xdp_noinline.c   |  60 +-
>  tools/testing/selftests/bpf/test_btf.c        |  10 +-
>  .../selftests/bpf/test_queue_stack_map.h      |  20 +-
>  .../testing/selftests/bpf/test_sockmap_kern.h |  72 +-
>  38 files changed, 1187 insertions(+), 491 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_btf_newkv.c
>
> --
> 2.17.1
>
