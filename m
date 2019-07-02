Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D8F5C643
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 02:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfGBAPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 20:15:54 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33902 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfGBAPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 20:15:54 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so33036549iot.1;
        Mon, 01 Jul 2019 17:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HCQZHC0ux0G6CbhS8r8sKyGtwp3k8AYjjTCX0SiZZPY=;
        b=dWgjfFC+80L1AVHWxf7Crmjltclf//TWc62CmmpuPDRInIiGE4eQ7rtSpjCS3HtbnM
         m8W4QV2nQjH0SX6n4PKferjIVT9PsZIUp02TwFTPe/OqVuN2vzWsjMWAclL3/+TlOz6l
         +w777wizaV67xOPd5lw2zvmqL/I9p3Q+pYu0riTzb8Br4pVTHTYHO3k/+cWQbzWmIil5
         2lnPJ/hKsxj0jJyhhQxBTXmD9OPTs6nrnbJ6u4ErcL/+DqnuBS/K8TaES1RL5mBqUgHP
         v2QY0HdnoD4LKJ/UZbsYc0VN8kDoOqHssonC17GamzOJpOyC9ULQP0rk/lygn1LQhjsy
         xuqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HCQZHC0ux0G6CbhS8r8sKyGtwp3k8AYjjTCX0SiZZPY=;
        b=DG6YEODYoyjNmPeQqpj7G/EkgwtjecSMA6sUTrF66nlWO1K0ugWerk5rdkBSJyLuws
         kv54EW/X++7cEKzQb+uMTK6FodaTvLFzfilCzcGQV/jynuiK28YN7ZWL64+T6XZYDRZP
         GEujAcwqh+1EybKSoJ1PXdnd2JFUZUESKtWIXtexA8ka24XX981EYaqv7fxjjm7QYOmn
         /+warK/hy7YpleZ4gt0YfgofaPpxMZ+wuJkrH8Smrb6CVGhiD0fkTyKYymYrl+QVAIUx
         FQCXp2RLAx2nj7eXSQ6Dy/wbEYPs+hoZYmluFKS+bLrRDUZfn+8aNgqZWqm8N4EM5Ofy
         gJrQ==
X-Gm-Message-State: APjAAAXO8/rcTm4yqKCRgRNj0Y06i3IKTKQyiNkhsElAyMER0gveYdF+
        eSXEThIpVIGflUHjxI1XjKRLXxBtatl2StWewhM=
X-Google-Smtp-Source: APXvYqxbg1Zr8phsK4Hnlr90RhJzy4wpqyEZ8fmyVi/BxitrtQGAuOVoy1VzJHQ9LiDVW+VvJcrJ8+KEpjSaoCP0e/o=
X-Received: by 2002:a5e:8704:: with SMTP id y4mr12992594ioj.135.1562026552722;
 Mon, 01 Jul 2019 17:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190701204821.44230-1-sdf@google.com> <20190701204821.44230-8-sdf@google.com>
In-Reply-To: <20190701204821.44230-8-sdf@google.com>
From:   Y Song <ys114321@gmail.com>
Date:   Mon, 1 Jul 2019 17:15:16 -0700
Message-ID: <CAH3MdRX+utr3w1gC537ui7nLOZ+b8yrSKeO3CMuszXG5sGg3NA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/8] samples/bpf: add sample program that
 periodically dumps TCP stats
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 1:49 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Uses new RTT callback to dump stats every second.
>
> $ mkdir -p /tmp/cgroupv2
> $ mount -t cgroup2 none /tmp/cgroupv2
> $ mkdir -p /tmp/cgroupv2/foo
> $ echo $$ >> /tmp/cgroupv2/foo/cgroup.procs
> $ bpftool prog load ./tcp_dumpstats_kern.o /sys/fs/bpf/tcp_prog
> $ bpftool cgroup attach /tmp/cgroupv2/foo sock_ops pinned /sys/fs/bpf/tcp_prog
> $ bpftool prog tracelog
> $ # run neper/netperf/etc
>
> Used neper to compare performance with and without this program attached
> and didn't see any noticeable performance impact.
>
> Sample output:
>   <idle>-0     [015] ..s.  2074.128800: 0: dsack_dups=0 delivered=242526
>   <idle>-0     [015] ..s.  2074.128808: 0: delivered_ce=0 icsk_retransmits=0
>   <idle>-0     [015] ..s.  2075.130133: 0: dsack_dups=0 delivered=323599
>   <idle>-0     [015] ..s.  2075.130138: 0: delivered_ce=0 icsk_retransmits=0
>   <idle>-0     [005] .Ns.  2076.131440: 0: dsack_dups=0 delivered=404648
>   <idle>-0     [005] .Ns.  2076.131447: 0: delivered_ce=0 icsk_retransmits=0
>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Priyaranjan Jha <priyarjha@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  samples/bpf/Makefile             |  1 +
>  samples/bpf/tcp_dumpstats_kern.c | 65 ++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)
>  create mode 100644 samples/bpf/tcp_dumpstats_kern.c

Currently, the bpf program into the repo. If we do not have another
script to use
this program for testing, the instructions in the commit message should be
added to the bpf program as comments so people know what to do with this file
without going through git commit message.

Is it possible to create a script to run with this bpf program?

>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 0917f8cf4fab..eaebbeead42f 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -154,6 +154,7 @@ always += tcp_iw_kern.o
>  always += tcp_clamp_kern.o
>  always += tcp_basertt_kern.o
>  always += tcp_tos_reflect_kern.o
> +always += tcp_dumpstats_kern.o
>  always += xdp_redirect_kern.o
>  always += xdp_redirect_map_kern.o
>  always += xdp_redirect_cpu_kern.o
> diff --git a/samples/bpf/tcp_dumpstats_kern.c b/samples/bpf/tcp_dumpstats_kern.c
> new file mode 100644
> index 000000000000..5d22bf61db65
> --- /dev/null
> +++ b/samples/bpf/tcp_dumpstats_kern.c
> @@ -0,0 +1,65 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +
> +#include "bpf_helpers.h"
> +#include "bpf_endian.h"
> +
> +#define INTERVAL                       1000000000ULL
> +
> +int _version SEC("version") = 1;
> +char _license[] SEC("license") = "GPL";
> +
> +struct {
> +       __u32 type;
> +       __u32 map_flags;
> +       int *key;
> +       __u64 *value;
> +} bpf_next_dump SEC(".maps") = {
> +       .type = BPF_MAP_TYPE_SK_STORAGE,
> +       .map_flags = BPF_F_NO_PREALLOC,
> +};
> +
> +SEC("sockops")
> +int _sockops(struct bpf_sock_ops *ctx)
> +{
> +       struct bpf_tcp_sock *tcp_sk;
> +       struct bpf_sock *sk;
> +       __u64 *next_dump;
> +       __u64 now;
> +
> +       switch (ctx->op) {
> +       case BPF_SOCK_OPS_TCP_CONNECT_CB:
> +               bpf_sock_ops_cb_flags_set(ctx, BPF_SOCK_OPS_RTT_CB_FLAG);
> +               return 1;
> +       case BPF_SOCK_OPS_RTT_CB:
> +               break;
> +       default:
> +               return 1;
> +       }
> +
> +       sk = ctx->sk;
> +       if (!sk)
> +               return 1;
> +
> +       next_dump = bpf_sk_storage_get(&bpf_next_dump, sk, 0,
> +                                      BPF_SK_STORAGE_GET_F_CREATE);
> +       if (!next_dump)
> +               return 1;
> +
> +       now = bpf_ktime_get_ns();
> +       if (now < *next_dump)
> +               return 1;
> +
> +       tcp_sk = bpf_tcp_sock(sk);
> +       if (!tcp_sk)
> +               return 1;
> +
> +       *next_dump = now + INTERVAL;
> +
> +       bpf_printk("dsack_dups=%u delivered=%u\n",
> +                  tcp_sk->dsack_dups, tcp_sk->delivered);
> +       bpf_printk("delivered_ce=%u icsk_retransmits=%u\n",
> +                  tcp_sk->delivered_ce, tcp_sk->icsk_retransmits);
> +
> +       return 1;
> +}
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
