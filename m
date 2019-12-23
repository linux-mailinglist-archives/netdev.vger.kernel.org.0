Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A94129BCD
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 00:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWX1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 18:27:04 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42359 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfLWX1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 18:27:04 -0500
Received: by mail-qv1-f67.google.com with SMTP id dc14so6903501qvb.9;
        Mon, 23 Dec 2019 15:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0n8hMYoUjyq8wCI+jpaSNinSDx+7b32OJMZRW1A1/+A=;
        b=Fi3Y8IA0v+x1T773Nbw4yYi3usH5SkJE+tzMlmkhJ+k6WA40oCiLB+0B8nBg4PuYCe
         e1NwkcxkHwdRAM+9i/YqJm1W/j03eLsa+sU/ayVElAElWV8Ijqfll/j6+XqCZRhdkr6s
         QeIxhVmodcO8Q/Ee3YlivTvLxNjYQ+rT9uuDZOCsFDd4FoAJYloaDx1qAb/Zf3gXgesv
         S1lg/woW4nP0FIPN8JQue+sp00PPmD/M2sWyDz9oTzJcAGuvUgHbWYhxXpnZ+Do51ozi
         SjpsX2OMr644zFhakTpe/hlQKUgX7Q37DgscO1gNuzUvooZq67mSiBWqC4bSJIzHv5z4
         IJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0n8hMYoUjyq8wCI+jpaSNinSDx+7b32OJMZRW1A1/+A=;
        b=SeGwZL1/BDbWGO3M2duYCU8ZA67lRPFq0cMdy7nadHgZTGqTXX0KGSjrYGnpd94Kac
         yJHYPtaL8uOTin4WrckeKFlp6OUx7rhIVESVN4cYWRSToATChgVb2h3IY87W+t+2yVEV
         b1g5+8VKJ9JcpGC8BYm+5mQYGwDaFdlP+EKGbTGlmaETujIra2pcKG7WmpCEdWEwucSH
         3xN7rEM4T1OpzBBA2Z+jyQXbFG73AhmGRP9YP+eXhNYmq7daUFXPtGoi0XMr2Q62mOvN
         iAOvkhTIRH6JtucHczoXAEJC7nvuSxMZkvwDdmc0E9tAUyH+7dN3Vck1xTGIjgDp5W5i
         Z7jQ==
X-Gm-Message-State: APjAAAUhbmkCpX8XDa5fqq73bLto59CyWQm04LoLci2Gh7dKs60UqwlG
        VceX2UKhoUMfxDfZ167I2D4dDRgGF9pTT5GQRxg=
X-Google-Smtp-Source: APXvYqyS5c76NL3hOXpkNdSsNJL3wtNCgvSJxXfBROpAOaC0AvMtc442XQAaPO0EUuJrp6HQJqI8AEu5s6Hr18VjfgI=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr26893558qvb.163.1577143620997;
 Mon, 23 Dec 2019 15:27:00 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062620.1184118-1-kafai@fb.com>
In-Reply-To: <20191221062620.1184118-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 15:26:50 -0800
Message-ID: <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds a bpf_dctcp example.  It currently does not do
> no-ECN fallback but the same could be done through the cgrp2-bpf.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++++++++++++++
>  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 218 +++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++++++++++++
>  3 files changed, 656 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c
>
> diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> new file mode 100644
> index 000000000000..7ba8c1b4157a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> @@ -0,0 +1,228 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __BPF_TCP_HELPERS_H
> +#define __BPF_TCP_HELPERS_H
> +
> +#include <stdbool.h>
> +#include <linux/types.h>
> +#include <bpf_helpers.h>
> +#include <bpf_core_read.h>
> +#include "bpf_trace_helpers.h"
> +
> +#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0, #fname"_sec", fname, ret_type, __VA_ARGS__)
> +#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1, #fname"_sec", fname, ret_type, __VA_ARGS__)
> +#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2, #fname"_sec", fname, ret_type, __VA_ARGS__)
> +#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3, #fname"_sec", fname, ret_type, __VA_ARGS__)
> +#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4, #fname"_sec", fname, ret_type, __VA_ARGS__)
> +#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5, #fname"_sec", fname, ret_type, __VA_ARGS__)

Should we try to put those BPF programs into some section that would
indicate they are used with struct opts? libbpf doesn't use or enforce
that (even though it could to derive and enforce that they are
STRUCT_OPS programs). So something like
SEC("struct_ops/<ideally-operation-name-here>"). I think having this
convention is very useful for consistency and to do a quick ELF dump
and see what is where. WDYT?

> +
> +struct sock_common {
> +       unsigned char   skc_state;
> +} __attribute__((preserve_access_index));
> +
> +struct sock {
> +       struct sock_common      __sk_common;
> +} __attribute__((preserve_access_index));
> +
> +struct inet_sock {
> +       struct sock             sk;
> +} __attribute__((preserve_access_index));
> +
> +struct inet_connection_sock {
> +       struct inet_sock          icsk_inet;
> +       __u8                      icsk_ca_state:6,
> +                                 icsk_ca_setsockopt:1,
> +                                 icsk_ca_dst_locked:1;
> +       struct {
> +               __u8              pending;
> +       } icsk_ack;
> +       __u64                     icsk_ca_priv[104 / sizeof(__u64)];
> +} __attribute__((preserve_access_index));
> +
> +struct tcp_sock {
> +       struct inet_connection_sock     inet_conn;
> +
> +       __u32   rcv_nxt;
> +       __u32   snd_nxt;
> +       __u32   snd_una;
> +       __u8    ecn_flags;
> +       __u32   delivered;
> +       __u32   delivered_ce;
> +       __u32   snd_cwnd;
> +       __u32   snd_cwnd_cnt;
> +       __u32   snd_cwnd_clamp;
> +       __u32   snd_ssthresh;
> +       __u8    syn_data:1,     /* SYN includes data */
> +               syn_fastopen:1, /* SYN includes Fast Open option */
> +               syn_fastopen_exp:1,/* SYN includes Fast Open exp. option */
> +               syn_fastopen_ch:1, /* Active TFO re-enabling probe */
> +               syn_data_acked:1,/* data in SYN is acked by SYN-ACK */
> +               save_syn:1,     /* Save headers of SYN packet */
> +               is_cwnd_limited:1,/* forward progress limited by snd_cwnd? */
> +               syn_smc:1;      /* SYN includes SMC */
> +       __u32   max_packets_out;
> +       __u32   lsndtime;
> +       __u32   prior_cwnd;
> +} __attribute__((preserve_access_index));
> +
> +static __always_inline struct inet_connection_sock *inet_csk(const struct sock *sk)
> +{
> +       return (struct inet_connection_sock *)sk;
> +}
> +
> +static __always_inline void *inet_csk_ca(const struct sock *sk)
> +{
> +       return (void *)inet_csk(sk)->icsk_ca_priv;
> +}
> +
> +static __always_inline struct tcp_sock *tcp_sk(const struct sock *sk)
> +{
> +       return (struct tcp_sock *)sk;
> +}
> +
> +static __always_inline bool before(__u32 seq1, __u32 seq2)
> +{
> +       return (__s32)(seq1-seq2) < 0;
> +}
> +#define after(seq2, seq1)      before(seq1, seq2)
> +
> +#define        TCP_ECN_OK              1
> +#define        TCP_ECN_QUEUE_CWR       2
> +#define        TCP_ECN_DEMAND_CWR      4
> +#define        TCP_ECN_SEEN            8
> +
> +enum inet_csk_ack_state_t {
> +       ICSK_ACK_SCHED  = 1,
> +       ICSK_ACK_TIMER  = 2,
> +       ICSK_ACK_PUSHED = 4,
> +       ICSK_ACK_PUSHED2 = 8,
> +       ICSK_ACK_NOW = 16       /* Send the next ACK immediately (once) */
> +};
> +
> +enum tcp_ca_event {
> +       CA_EVENT_TX_START = 0,
> +       CA_EVENT_CWND_RESTART = 1,
> +       CA_EVENT_COMPLETE_CWR = 2,
> +       CA_EVENT_LOSS = 3,
> +       CA_EVENT_ECN_NO_CE = 4,
> +       CA_EVENT_ECN_IS_CE = 5,
> +};
> +
> +enum tcp_ca_state {
> +       TCP_CA_Open = 0,
> +       TCP_CA_Disorder = 1,
> +       TCP_CA_CWR = 2,
> +       TCP_CA_Recovery = 3,
> +       TCP_CA_Loss = 4
> +};
> +
> +struct ack_sample {
> +       __u32 pkts_acked;
> +       __s32 rtt_us;
> +       __u32 in_flight;
> +} __attribute__((preserve_access_index));
> +
> +struct rate_sample {
> +       __u64  prior_mstamp; /* starting timestamp for interval */
> +       __u32  prior_delivered; /* tp->delivered at "prior_mstamp" */
> +       __s32  delivered;               /* number of packets delivered over interval */
> +       long interval_us;       /* time for tp->delivered to incr "delivered" */
> +       __u32 snd_interval_us;  /* snd interval for delivered packets */
> +       __u32 rcv_interval_us;  /* rcv interval for delivered packets */
> +       long rtt_us;            /* RTT of last (S)ACKed packet (or -1) */
> +       int  losses;            /* number of packets marked lost upon ACK */
> +       __u32  acked_sacked;    /* number of packets newly (S)ACKed upon ACK */
> +       __u32  prior_in_flight; /* in flight before this ACK */
> +       bool is_app_limited;    /* is sample from packet with bubble in pipe? */
> +       bool is_retrans;        /* is sample from retransmission? */
> +       bool is_ack_delayed;    /* is this (likely) a delayed ACK? */
> +} __attribute__((preserve_access_index));
> +
> +#define TCP_CA_NAME_MAX                16
> +#define TCP_CONG_NEEDS_ECN     0x2
> +
> +struct tcp_congestion_ops {
> +       __u32 flags;
> +
> +       /* initialize private data (optional) */
> +       void (*init)(struct sock *sk);
> +       /* cleanup private data  (optional) */
> +       void (*release)(struct sock *sk);
> +
> +       /* return slow start threshold (required) */
> +       __u32 (*ssthresh)(struct sock *sk);
> +       /* do new cwnd calculation (required) */
> +       void (*cong_avoid)(struct sock *sk, __u32 ack, __u32 acked);
> +       /* call before changing ca_state (optional) */
> +       void (*set_state)(struct sock *sk, __u8 new_state);
> +       /* call when cwnd event occurs (optional) */
> +       void (*cwnd_event)(struct sock *sk, enum tcp_ca_event ev);
> +       /* call when ack arrives (optional) */
> +       void (*in_ack_event)(struct sock *sk, __u32 flags);
> +       /* new value of cwnd after loss (required) */
> +       __u32  (*undo_cwnd)(struct sock *sk);
> +       /* hook for packet ack accounting (optional) */
> +       void (*pkts_acked)(struct sock *sk, const struct ack_sample *sample);
> +       /* override sysctl_tcp_min_tso_segs */
> +       __u32 (*min_tso_segs)(struct sock *sk);
> +       /* returns the multiplier used in tcp_sndbuf_expand (optional) */
> +       __u32 (*sndbuf_expand)(struct sock *sk);
> +       /* call when packets are delivered to update cwnd and pacing rate,
> +        * after all the ca_state processing. (optional)
> +        */
> +       void (*cong_control)(struct sock *sk, const struct rate_sample *rs);
> +
> +       char            name[TCP_CA_NAME_MAX];
> +};

Can all of these types come from vmlinux.h instead of being duplicated here?

> +
> +#define min(a, b) ((a) < (b) ? (a) : (b))
> +#define max(a, b) ((a) > (b) ? (a) : (b))
> +#define min_not_zero(x, y) ({                  \
> +       typeof(x) __x = (x);                    \
> +       typeof(y) __y = (y);                    \
> +       __x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
> +

[...]

> +static struct bpf_object *load(const char *filename, const char *map_name,
> +                              struct bpf_link **link)
> +{
> +       struct bpf_object *obj;
> +       struct bpf_map *map;
> +       struct bpf_link *l;
> +       int err;
> +
> +       obj = bpf_object__open(filename);
> +       if (CHECK(IS_ERR(obj), "bpf_obj__open_file", "obj:%ld\n",
> +                 PTR_ERR(obj)))
> +               return obj;
> +
> +       err = bpf_object__load(obj);
> +       if (CHECK(err, "bpf_object__load", "err:%d\n", err)) {
> +               bpf_object__close(obj);
> +               return ERR_PTR(err);
> +       }
> +
> +       map = bpf_object__find_map_by_name(obj, map_name);
> +       if (CHECK(!map, "bpf_object__find_map_by_name", "%s not found\n",
> +                   map_name)) {
> +               bpf_object__close(obj);
> +               return ERR_PTR(-ENOENT);
> +       }
> +

use skeleton instead?

> +       l = bpf_map__attach_struct_ops(map);
> +       if (CHECK(IS_ERR(l), "bpf_struct_ops_map__attach", "err:%ld\n",
> +                 PTR_ERR(l))) {
> +               bpf_object__close(obj);
> +               return (void *)l;
> +       }
> +
> +       *link = l;
> +
> +       return obj;
> +}
> +
> +static void test_dctcp(void)
> +{
> +       struct bpf_object *obj;
> +       /* compiler warning... */
> +       struct bpf_link *link = NULL;
> +
> +       obj = load("bpf_dctcp.o", "dctcp", &link);
> +       if (IS_ERR(obj))
> +               return;
> +
> +       do_test("bpf_dctcp");
> +
> +       bpf_link__destroy(link);
> +       bpf_object__close(obj);
> +}
> +
> +void test_bpf_tcp_ca(void)
> +{
> +       if (test__start_subtest("dctcp"))
> +               test_dctcp();
> +}

[...]
