Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2431D420A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgEOAWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726287AbgEOAWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:22:01 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A18EC061A0C;
        Thu, 14 May 2020 17:22:00 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f13so879126qkh.2;
        Thu, 14 May 2020 17:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=15AOlchk7fRad5R+3mC2j7vHmPP4kH2DOR0zT0J1IlQ=;
        b=jVPLPfvhAovcC8rbfLFbYTtjbMxwQDVqknMtcLy2eSPVkV6z5Eygrv7v99gYGwLuVH
         1sGpB9XA+70nUQiU6lJCE20sH8kRRzQcvWcYb/gi2OyD6/jdjGfG3S415ykU/oNWM/Sz
         453CcYhyTeSYBkfqntwMT8+Fq5Z/0cMG5PiUqNJVpmIjws4QKCQjrkfTlKS34XpXs2qz
         4/+TIWMlshe+icQJZXB7Uno0XcAkPEqQFi3ud9lS2DHarRl9P3wHs2u3Jc/j9LGj6L1E
         5QY2HsbJmp1hENgFFNMDoUbNmMEf0+8ZyFnX3w1XT8csv1iUBSM1c05NVNFhYq7cda9K
         EK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=15AOlchk7fRad5R+3mC2j7vHmPP4kH2DOR0zT0J1IlQ=;
        b=AJyGf9ohcyaWUuv2MuSofOXGeYTF2z3vXZTfl94HRnTxxJoeMFDjjcv17UvjOuQXN2
         HSzFW+mN6f8EWdx0nLjjFUJZRw1jOYgXe9BonTvXYBRGi1Uw5wZjFPb3bBfC54fL0HMM
         2MFP7V+71gsuZCYKpyp+0HeXpmBNrvKL/2d+oF9TUo1m3Ox3p1Nbyjigtsdj4tCFKDCP
         7O2QfjD7xJYhpJIxiF+kuzfNEtXP/1OPsN17E1gjerbGFJtT6L8Is7Eda6nlJBiTFZ9e
         Wd4SM2siZ2oJ/poFyEO2P0aJ+MjIgzo5/CAwX1TqXfzvcvm27cZS9uCdwr3nWr47hrEG
         answ==
X-Gm-Message-State: AOAM530aKNsYiF+q94mTyPK7Y+U8RijwaMqj7PzPoKQNZnxwLA7kDz0y
        ZT/+x+ddZKts5RaQzjNpMRyxU0PRWaUpKOX1MII=
X-Google-Smtp-Source: ABdhPJx76qqdezdu7tfRxjKpBlo0kO/Pkg1f596NjE/xYp3qW2czrDoypUgpP7RlicUy9lrhb044F6QTB3hQSG1JfLs=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr1025378qka.449.1589502119791;
 Thu, 14 May 2020 17:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com> <1589263005-7887-8-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1589263005-7887-8-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 17:21:48 -0700
Message-ID: <CAEf4BzYRT9QNtkjqP6k=BmCzVEyswR9boLRw2gDfR=rAg-gV8w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 7/7] bpf: add tests for %pT format specifier
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 10:59 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> tests verify we get > 0 return value from bpf_trace_print()
> using %pT format specifier with various modifiers/pointer
> values.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

There is no need to use perf buffer for returning results to
user-space. See prog_tests/skeleton.c and progs/test_skeleton.c for a
very minimalistic and simple way to do tests like this.

>  .../selftests/bpf/prog_tests/trace_printk_btf.c    | 83 ++++++++++++++++++++++
>  .../selftests/bpf/progs/netif_receive_skb.c        | 81 +++++++++++++++++++++
>  2 files changed, 164 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk_btf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c

[...]

> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> new file mode 100644
> index 0000000..b5148df
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> @@ -0,0 +1,81 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020, Oracle and/or its affiliates. */
> +#include <linux/bpf.h>
> +#include <stdbool.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(int));
> +} perf_buf_map SEC(".maps");
> +
> +struct result {
> +       int ret;
> +       int subtest;
> +       int num_subtest;
> +};
> +
> +typedef struct {
> +       int counter;
> +} atomic_t;
> +typedef struct refcount_struct {
> +       atomic_t refs;
> +} refcount_t;
> +
> +struct sk_buff {
> +       /* field names and sizes should match to those in the kernel */
> +       unsigned int len, data_len;
> +       __u16 mac_len, hdr_len, queue_mapping;
> +       struct net_device *dev;
> +       /* order of the fields doesn't matter */
> +       refcount_t users;
> +       unsigned char *data;
> +       char __pkt_type_offset[0];
> +       char cb[48];
> +};


please use vmlinux.h instead of duplicating these definitions (which
also will start failing, when sk_buff definition will change).

> +
> +#define CHECK_PRINTK(_fmt, _p, res)                                    \
> +       do {                                                            \
> +               char fmt[] = _fmt;                                      \
> +               ++(res)->num_subtest;                                   \
> +               if ((res)->ret >= 0) {                                  \
> +                       ++(res)->subtest;                               \
> +                       (res)->ret = bpf_trace_printk(fmt, sizeof(fmt), \
> +                                                     (_p));            \
> +               }                                                       \
> +       } while (0)
> +
> +/* TRACE_EVENT(netif_receive_skb,
> + *     TP_PROTO(struct sk_buff *skb),
> + */
> +SEC("tp_btf/netif_receive_skb")
> +int BPF_PROG(trace_netif_receive_skb, struct sk_buff *skb)
> +{
> +       char skb_type[] = "struct sk_buff";
> +       struct __btf_ptr nullp = { .ptr = 0, .type = skb_type };
> +       struct __btf_ptr p = { .ptr = skb, .type = skb_type };
> +       struct result res = { 0, 0 };
> +
> +       CHECK_PRINTK("%pT\n", &p, &res);
> +       CHECK_PRINTK("%pTc\n", &p, &res);
> +       CHECK_PRINTK("%pTN\n", &p, &res);
> +       CHECK_PRINTK("%pTx\n", &p, &res);
> +       CHECK_PRINTK("%pT0\n", &p, &res);
> +       CHECK_PRINTK("%pTcNx0\n", &p, &res);
> +       CHECK_PRINTK("%pT\n", &nullp, &res);
> +       CHECK_PRINTK("%pTc\n", &nullp, &res);
> +       CHECK_PRINTK("%pTN\n", &nullp, &res);
> +       CHECK_PRINTK("%pTx\n", &nullp, &res);
> +       CHECK_PRINTK("%pT0\n", &nullp, &res);
> +       CHECK_PRINTK("%pTcNx0\n", &nullp, &res);

with global variables this would be:

int pT = 0;
int pTc = 0;
/* and so on */

then inside BPF_PROG:

pT = bpf_printk("%pT\n", &p);
pTc = bpf_printk("%pTc\n", &p);
/* and so on */

CHECK_PRINTK isn't necessary, IMO. bpf_printk is defined in bpf_helpers.h

> +
> +       bpf_perf_event_output(ctx, &perf_buf_map, BPF_F_CURRENT_CPU,
> +                             &res, sizeof(res));
> +
> +       return 0;
> +}
> --
> 1.8.3.1
>
