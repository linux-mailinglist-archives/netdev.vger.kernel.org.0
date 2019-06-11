Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCB83C25A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388847AbfFKEhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:37:10 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41090 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfFKEhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:37:10 -0400
Received: by mail-qt1-f196.google.com with SMTP id 33so4837389qtr.8;
        Mon, 10 Jun 2019 21:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2VpHqTtoIr2WKto7cuYhJoVTJ0OD/hwftu7D+UU2YMs=;
        b=ZjrMFV7xhdsNyaXDtUR+LKBr6UOzpy/3RJ/kVcHT+O1xgDquAsK8uTbKU7L9cG6yJy
         SO0AVOJIAeOyF/PmcL0c77nd4NnCu0lR6m0z2E0m+V0pPbCybPNM8n58CJhac4+B9Q6/
         xfUhmrLaCvt6Ddw4CxPgOubz2QNyPR20l5I91NcbCNfS+ysuANgCGxled1CeQgMa8XRM
         0Qz5vd7OTuEH4bygdC+quSHaHlGuHaFq+pUWFpObiSbLI0AFyvLryQbfU2AC1ECrUy4b
         Jp/1ELtvQlN9T3qrgq8BNzhUQ3l3W236BFswnLnRrLDd/JbRYwjpBOdaGK812c5bCW61
         1xmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2VpHqTtoIr2WKto7cuYhJoVTJ0OD/hwftu7D+UU2YMs=;
        b=mXIMc4uThw/t3HXm7O6xcbauX+4ECH4uNExjQeQ/DAwkhq7852QyNB0Hn6aHOsVvMm
         2e0HV909lUWXUlCn8g8hI5WHnArmdtPdfZt4Ve89kgUFywZU48i1fZTgwlB4hctidq83
         CigKzWv7B8bJzL7OkCb2TPKK4Jf07+bGnaXdaXneJwA+OlAnjRtv2O2thPiBKC3UukF7
         /Etg11Z5zumM3hTBd8UEGYt4ZNFx3y+t2aZdksR5o6/1gW0mh766H2fw9D8o2UnHrhp2
         UUycEe7h4NOhtspnJqs54gGbtt+WVNTaiaUwukUaNGDY8viwAMAuHTiV35iUdo1hjMTH
         M2qw==
X-Gm-Message-State: APjAAAWcqksJ82BS1RgpfironaEnezWSFAmXZ6DgIySMqFdOETDhr50B
        pfKJR5tK16w5JptSSpgIBIJL6GDuYEZbWv2pcY4=
X-Google-Smtp-Source: APXvYqy51DzsUzfz9KHdrwVq2Lt3cwo87M+wlbz7TFEt24KsPYPdogqEmeMlK9iPuEorqusanqdkY00IcSI3RItdH/k=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr39622788qta.93.1560227829440;
 Mon, 10 Jun 2019 21:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190611043505.14664-1-andriin@fb.com>
In-Reply-To: <20190611043505.14664-1-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Jun 2019 21:36:58 -0700
Message-ID: <CAEf4BzajDtVbKa+z-goL18pyBj9TKpq0-QGW6nKvQY=yBqDCVA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/8] BTF-defined BPF map definitions
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

On Mon, Jun 10, 2019 at 9:35 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set implements initial version (as discussed at LSF/MM2019
> conference) of a new way to specify BPF maps, relying on BTF type information,
> which allows for easy extensibility, preserving forward and backward
> compatibility. See details and examples in description for patch #6.
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

Argh, forgot to remove RFC part, will resend, sorry for spam!
