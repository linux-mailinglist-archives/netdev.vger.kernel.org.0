Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C2BF087D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbfKEVhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:37:48 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41039 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729830AbfKEVhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:37:47 -0500
Received: by mail-qt1-f195.google.com with SMTP id o3so31308680qtj.8;
        Tue, 05 Nov 2019 13:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UdTF48D5Kt/CE3Gcwyq07ed3jwz9oZyEExI7mYpVFj0=;
        b=mGCuTlCIywx7flepTari4xa/KazmeMpZL8TxPtn6RyWbUMfz/7Ss2onvHED4Tqz1Hl
         sgGfJUAw8swFR7bbiWogiXfUv4WxHadAKYqHwUPw2bpZeoYynAQJWpmu7EbIyUSE9cki
         kfIYEwtuKU7HEfnYXWY5R1jVQWHozeBaw9EGnMMANRg4yGHp1RDeaIQAVqSVnM7yAfm9
         4SHXHQt0pjkq727UmYalY0ic+l6nsH2bNyEWa/SXkdcv64cEPJe+jipMuQ9swMtx33mP
         DWSJz1fN96TBUmj6aKA+E7Q/sdSLwTvPhlUSx7zjD9/AtU1iuBSafKVWNyjM0u6nMeWx
         08nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UdTF48D5Kt/CE3Gcwyq07ed3jwz9oZyEExI7mYpVFj0=;
        b=pcTZZQWM0K9keFEkilcQ/YO55QDHeNR9KvczV5iC8xXvPRplKCYfhMxl5hwvZ6PEbq
         vnb9AnjNSG09Ll/SsnNNxHMldOF0Fp+4TvYiwaFHwrebY6AoHjWkMNBga9i6nfnDPTof
         wg26+48Qk3Ek5ukqhStCTU5N6oGqb0c2FlRvrCFoRz9qNpaFlPnJmOv7yksI6Ba+2mTt
         h8fXqMJE9oZYxtRJntWuu7aCmyEGSj4Gnl+Ka4NilkUqiaZO8eKhza1IGnGkqWVZiipz
         P6FozT6G+fYLFyo+qNLejNeRawYRAgRQcKHhFayjT2ubTmqOHzqAt3EMVnYlP47aFmO5
         1FDQ==
X-Gm-Message-State: APjAAAVcDuK/Anwlx8xSLRGx0oORETOA0CDjfNDr1lGQ1OdXs7q8KHL6
        OflTi+k7Ze35Soq5mYBr+7op3q4hvmPDXsM3pjI=
X-Google-Smtp-Source: APXvYqwhQcfSRtp91KwBkkmkWWAs1ZaKnh4kJpbPY5LRcJ/+zI1oXSCI6xkhwq91Vzch79szgnn340NqLi3i2mWiQno=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr18905966qtj.93.1572989864989;
 Tue, 05 Nov 2019 13:37:44 -0800 (PST)
MIME-Version: 1.0
References: <20191102220025.2475981-1-ast@kernel.org> <20191102220025.2475981-6-ast@kernel.org>
In-Reply-To: <20191102220025.2475981-6-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Nov 2019 13:37:33 -0800
Message-ID: <CAEf4BzY+dm2O3BwrEOiC5RJj3dN2D-FQ=ZJZraeO1iGijQirtA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/7] selftest/bpf: Simple test for fentry/fexit
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 2, 2019 at 3:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Add simple test for fentry and fexit programs around eth_type_trans.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

LGTM, but please fix formatting.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/kfree_skb.c      | 37 +++++++++++--
>  tools/testing/selftests/bpf/progs/kfree_skb.c | 52 +++++++++++++++++++
>  2 files changed, 86 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
> index 430b50de1583..d3402261bbae 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
> @@ -30,15 +30,17 @@ void test_kfree_skb(void)
>                 .file = "./kfree_skb.o",
>         };
>
> +       struct bpf_link *link = NULL, *link_fentry = NULL, *link_fexit = NULL;
> +       struct bpf_program *prog, *fentry, *fexit;
>         struct bpf_object *obj, *obj2 = NULL;
>         struct perf_buffer_opts pb_opts = {};
>         struct perf_buffer *pb = NULL;
> -       struct bpf_link *link = NULL;
> -       struct bpf_map *perf_buf_map;
> -       struct bpf_program *prog;
> +       struct bpf_map *perf_buf_map, *global_data;
>         __u32 duration, retval;
>         int err, pkt_fd, kfree_skb_fd;
>         bool passed = false;
> +       const int zero = 0;
> +       bool test_ok[2];
>
>         err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS, &obj, &pkt_fd);

too long ;)

>         if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
> @@ -51,9 +53,26 @@ void test_kfree_skb(void)
>         prog = bpf_object__find_program_by_title(obj2, "tp_btf/kfree_skb");
>         if (CHECK(!prog, "find_prog", "prog kfree_skb not found\n"))
>                 goto close_prog;
> +       fentry = bpf_object__find_program_by_title(obj2, "fentry/eth_type_trans");
> +       if (CHECK(!fentry, "find_prog", "prog eth_type_trans not found\n"))
> +               goto close_prog;
> +       fexit = bpf_object__find_program_by_title(obj2, "fexit/eth_type_trans");
> +       if (CHECK(!fexit, "find_prog", "prog eth_type_trans not found\n"))
> +               goto close_prog;
> +
> +       global_data = bpf_object__find_map_by_name(obj2, "kfree_sk.bss");
> +       if (CHECK(!global_data, "find global data", "not found\n"))
> +               goto close_prog;
> +
>         link = bpf_program__attach_raw_tracepoint(prog, NULL);
>         if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
>                 goto close_prog;
> +       link_fentry = bpf_program__attach_trace(fentry);
> +       if (CHECK(IS_ERR(link_fentry), "attach fentry", "err %ld\n", PTR_ERR(link_fentry)))
> +               goto close_prog;
> +       link_fexit = bpf_program__attach_trace(fexit);
> +       if (CHECK(IS_ERR(link_fexit), "attach fexit", "err %ld\n", PTR_ERR(link_fexit)))

checkpatch.pl?

> +               goto close_prog;
>

[...]
