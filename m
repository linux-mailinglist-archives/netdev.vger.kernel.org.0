Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3311213B6A
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 19:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfEDR0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 13:26:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43814 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfEDR0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 13:26:15 -0400
Received: by mail-qt1-f196.google.com with SMTP id r3so446526qtp.10;
        Sat, 04 May 2019 10:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vPyW6g0bqUV5YGH5iLBj0sshJdwXORQBAsNC9tevW7M=;
        b=Mhb901KZ/tkbWbHmGHC33dnI33bePClKTUbB4fSGNKTTuRgG+eu5UHNsHdrIIXsrmw
         3DrLK8vPmWyFBUJjkUSbdrQe5MHRGu0cTGjrlxUEX3NiivppuiNFhING/gu1nPg8ZCPd
         wqJQtK0Q7yq7TcRCrWaGTK8iljpJALBWS+T1T/oKzd0GQydDeyWWROtFjvxPjKSM52nt
         qN9xiunGTwTuuFE+OfeyGmtueA1adM66p8wGRHjjRgEy4UyUJxPbd5saWHuIls1wvxaX
         hL8bcXEQf88oKQfCAnYn6d0iuZchtPCbHkqHbjgX0Wt6C9/OOdfuOpk92Eicyay7Js5n
         xjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vPyW6g0bqUV5YGH5iLBj0sshJdwXORQBAsNC9tevW7M=;
        b=EhXHtIyqOOdPxeF1kMxr4hFkHisNQDjdqVbc1tzHPm1GKQPAGl3qbn3xYGf7sP/cUU
         ulU2YCdLm5jaJ7CC6i21bXkNPtxXdZpJcWrnEmWAbm0culcTXtv6090qf3ZCCA8698xJ
         8Nh+F5mrWH6kiksL61NVPBOaxOu6vzYBWSS93zyBbidMw0UE511NtSiBmdFH/6tHX31s
         FaT7rU4NWCFDl2LufaCDdEXZv1QaI/4XWq1Dx3wDdMgFxG6r4tays/AJyJhVskqAWuqw
         FZJGmb6csV1kq3rD+bBBZQ4tc/KYfBgoejAP3xcm9MWf3Lxol9IVIvXmfkhzj2R3hXXj
         BYww==
X-Gm-Message-State: APjAAAWhp0LaQzV7S3Biy+q0sIIBzLquNjOBvzXH4Vg/mQjIhPYwnfO9
        yU+RsLnSVqEeCivDk41PFr+MD/7/cse1ivUIXYc=
X-Google-Smtp-Source: APXvYqynmnxvM26E+hvtJy14rbvzKaR3z1OPQFlgb0TRCYnXwvNh0y8gGiCH5p1O/+qxW5+J2c5EM9SaVlIb88j8nOI=
X-Received: by 2002:ac8:2bb9:: with SMTP id m54mr8430883qtm.303.1556990773522;
 Sat, 04 May 2019 10:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190430181215.15305-1-maximmi@mellanox.com> <20190430181215.15305-5-maximmi@mellanox.com>
In-Reply-To: <20190430181215.15305-5-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 4 May 2019 19:26:02 +0200
Message-ID: <CAJ+HfNho0H7qq+hFn7Ri=9Y+KGEcM19SOChfPZxwkyqJNymKcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/16] xsk: Extend channels to support
 combined XSK/non-XSK traffic
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Apr 2019 at 20:12, Maxim Mikityanskiy <maximmi@mellanox.com> wro=
te:
>
> Currently, the drivers that implement AF_XDP zero-copy support (e.g.,
> i40e) switch the channel into a different mode when an XSK is opened. It
> causes some issues that have to be taken into account. For example, RSS
> needs to be reconfigured to skip the XSK-enabled channels, or the XDP
> program should filter out traffic not intended for that socket and
> XDP_PASS it with an additional copy. As nothing validates or forces the
> proper configuration, it's easy to have packets drops, when they get
> into an XSK by mistake, and, in fact, it's the default configuration.
> There has to be some tool to have RSS reconfigured on each socket open
> and close event, but such a tool is problematic to implement, because no
> one reports these events, and it's race-prone.
>
> This commit extends XSK to support both kinds of traffic (XSK and
> non-XSK) in the same channel. It implies having two RX queues in
> XSK-enabled channels: one for the regular traffic, and the other for
> XSK. It solves the problem with RSS: the default configuration just
> works without the need to manually reconfigure RSS or to perform some
> possibly complicated filtering in the XDP layer. It makes it easy to run
> both AF_XDP and regular sockets on the same machine. In the XDP program,
> the QID's most significant bit will serve as a flag to indicate whether
> it's the XSK queue or not. The extension is compatible with the legacy
> configuration, so if one wants to run the legacy mode, they can
> reconfigure RSS and ignore the flag in the XDP program (implemented in
> the reference XDP program in libbpf). mlx5e will support this extension.
>
> A single XDP program can run both with drivers supporting or not
> supporting this extension. The xdpsock sample and libbpf are updated
> accordingly.
>

I'm still not a fan of this, or maybe I'm not following you. It makes
it more complex and even harder to use. Let's take a look at the
kernel nomenclature. "ethtool" uses netdevs and channels. A channel is
a Rx queue or a Tx queue. In AF_XDP we call the channel a queue, which
is what kernel uses internally (netdev_rx_queue, netdev_queue).

Today, AF_XDP can attach to an existing queue for ingress. (On the
egress side, we're using "a queue", but the "XDP queue". XDP has these
"shadow queues" which are separated from the netdev. This is a bit
messy, and we can't really configure them. I believe Jakub has some
ideas here. :-) For now, let's leave egress aside.)

If an application would like to get all the traffic from a netdev,
it'll create an equal amout of sockets as the queues and bind to the
queues. Yes, even the queues in the RSS  set.

What you would like (I think):
a) is a way of spawning a new queue for a netdev, that is not part of
the stack and/or RSS set
b) steering traffic to that queue using a configuration mechanism (tc?
some yet to be hacked BPF configuration hook?)

With your mechanism you're doing this in contrived way. This makes the
existing AF_XDP model *more* complex/hard(er) to use.

How do you steer traffic to this dual-channel RQ? So you have a netdev
receiving on all queues. Then, e.g., the last queue is a "dual
channel" queue that can receive traffic from some other filter. How do
you use it?



Bj=C3=B6rn

> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  include/uapi/linux/if_xdp.h       |  11 +++
>  net/xdp/xsk.c                     |   5 +-
>  samples/bpf/xdpsock_user.c        |  10 ++-
>  tools/include/uapi/linux/if_xdp.h |  11 +++
>  tools/lib/bpf/xsk.c               | 116 ++++++++++++++++++++++--------
>  tools/lib/bpf/xsk.h               |   4 ++
>  6 files changed, 126 insertions(+), 31 deletions(-)
>
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index 9ae4b4e08b68..cf6ff1ecc6bd 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -82,4 +82,15 @@ struct xdp_desc {
>
>  /* UMEM descriptor is __u64 */
>
> +/* The driver may run a dedicated XSK RQ in the channel. The XDP program=
 uses
> + * this flag bit in the queue index to distinguish between two RQs of th=
e same
> + * channel.
> + */
> +#define XDP_QID_FLAG_XSKRQ (1 << 31)
> +
> +static inline __u32 xdp_qid_get_channel(__u32 qid)
> +{
> +       return qid & ~XDP_QID_FLAG_XSKRQ;
> +}
> +
>  #endif /* _LINUX_IF_XDP_H */
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 998199109d5c..114ba17acb09 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -104,9 +104,12 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct =
xdp_buff *xdp, u32 len)
>
>  int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>  {
> +       struct xdp_rxq_info *rxq =3D xdp->rxq;
> +       u32 channel =3D xdp_qid_get_channel(rxq->queue_index);
>         u32 len;
>
> -       if (xs->dev !=3D xdp->rxq->dev || xs->queue_id !=3D xdp->rxq->que=
ue_index)
> +       if (xs->dev !=3D rxq->dev || xs->queue_id !=3D channel ||
> +           xs->zc !=3D (rxq->mem.type =3D=3D MEM_TYPE_ZERO_COPY))
>                 return -EINVAL;
>
>         len =3D xdp->data_end - xdp->data;
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index d08ee1ab7bb4..a6b13025ee79 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -62,6 +62,7 @@ enum benchmark_type {
>
>  static enum benchmark_type opt_bench =3D BENCH_RXDROP;
>  static u32 opt_xdp_flags =3D XDP_FLAGS_UPDATE_IF_NOEXIST;
> +static u32 opt_libbpf_flags;
>  static const char *opt_if =3D "";
>  static int opt_ifindex;
>  static int opt_queue;
> @@ -306,7 +307,7 @@ static struct xsk_socket_info *xsk_configure_socket(s=
truct xsk_umem_info *umem)
>         xsk->umem =3D umem;
>         cfg.rx_size =3D XSK_RING_CONS__DEFAULT_NUM_DESCS;
>         cfg.tx_size =3D XSK_RING_PROD__DEFAULT_NUM_DESCS;
> -       cfg.libbpf_flags =3D 0;
> +       cfg.libbpf_flags =3D opt_libbpf_flags;
>         cfg.xdp_flags =3D opt_xdp_flags;
>         cfg.bind_flags =3D opt_xdp_bind_flags;
>         ret =3D xsk_socket__create(&xsk->xsk, opt_if, opt_queue, umem->um=
em,
> @@ -346,6 +347,7 @@ static struct option long_options[] =3D {
>         {"interval", required_argument, 0, 'n'},
>         {"zero-copy", no_argument, 0, 'z'},
>         {"copy", no_argument, 0, 'c'},
> +       {"combined", no_argument, 0, 'C'},
>         {0, 0, 0, 0}
>  };
>
> @@ -365,6 +367,7 @@ static void usage(const char *prog)
>                 "  -n, --interval=3Dn     Specify statistics update inter=
val (default 1 sec).\n"
>                 "  -z, --zero-copy      Force zero-copy mode.\n"
>                 "  -c, --copy           Force copy mode.\n"
> +               "  -C, --combined       Driver supports combined XSK and =
non-XSK traffic in a channel.\n"
>                 "\n";
>         fprintf(stderr, str, prog);
>         exit(EXIT_FAILURE);
> @@ -377,7 +380,7 @@ static void parse_command_line(int argc, char **argv)
>         opterr =3D 0;
>
>         for (;;) {
> -               c =3D getopt_long(argc, argv, "Frtli:q:psSNn:cz", long_op=
tions,
> +               c =3D getopt_long(argc, argv, "Frtli:q:psSNn:czC", long_o=
ptions,
>                                 &option_index);
>                 if (c =3D=3D -1)
>                         break;
> @@ -420,6 +423,9 @@ static void parse_command_line(int argc, char **argv)
>                 case 'F':
>                         opt_xdp_flags &=3D ~XDP_FLAGS_UPDATE_IF_NOEXIST;
>                         break;
> +               case 'C':
> +                       opt_libbpf_flags |=3D XSK_LIBBPF_FLAGS__COMBINED_=
CHANNELS;
> +                       break;
>                 default:
>                         usage(basename(argv[0]));
>                 }
> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux=
/if_xdp.h
> index 9ae4b4e08b68..cf6ff1ecc6bd 100644
> --- a/tools/include/uapi/linux/if_xdp.h
> +++ b/tools/include/uapi/linux/if_xdp.h
> @@ -82,4 +82,15 @@ struct xdp_desc {
>
>  /* UMEM descriptor is __u64 */
>
> +/* The driver may run a dedicated XSK RQ in the channel. The XDP program=
 uses
> + * this flag bit in the queue index to distinguish between two RQs of th=
e same
> + * channel.
> + */
> +#define XDP_QID_FLAG_XSKRQ (1 << 31)
> +
> +static inline __u32 xdp_qid_get_channel(__u32 qid)
> +{
> +       return qid & ~XDP_QID_FLAG_XSKRQ;
> +}
> +
>  #endif /* _LINUX_IF_XDP_H */
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index a95b06d1f81d..969dfd856039 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -76,6 +76,12 @@ struct xsk_nl_info {
>         int fd;
>  };
>
> +enum qidconf {
> +       QIDCONF_REGULAR,
> +       QIDCONF_XSK,
> +       QIDCONF_XSK_COMBINED,
> +};
> +
>  /* For 32-bit systems, we need to use mmap2 as the offsets are 64-bit.
>   * Unfortunately, it is not part of glibc.
>   */
> @@ -139,7 +145,7 @@ static int xsk_set_xdp_socket_config(struct xsk_socke=
t_config *cfg,
>                 return 0;
>         }
>
> -       if (usr_cfg->libbpf_flags & ~XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)
> +       if (usr_cfg->libbpf_flags & ~XSK_LIBBPF_FLAGS_MASK)
>                 return -EINVAL;
>
>         cfg->rx_size =3D usr_cfg->rx_size;
> @@ -267,44 +273,93 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk=
)
>         /* This is the C-program:
>          * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>          * {
> -        *     int *qidconf, index =3D ctx->rx_queue_index;
> +        *     int *qidconf, qc;
> +        *     int index =3D ctx->rx_queue_index & ~(1 << 31);
> +        *     bool is_xskrq =3D ctx->rx_queue_index & (1 << 31);
>          *
> -        *     // A set entry here means that the correspnding queue_id
> -        *     // has an active AF_XDP socket bound to it.
> +        *     // A set entry here means that the corresponding queue_id
> +        *     // has an active AF_XDP socket bound to it. Value 2 means
> +        *     // it's zero-copy multi-RQ mode.
>          *     qidconf =3D bpf_map_lookup_elem(&qidconf_map, &index);
>          *     if (!qidconf)
>          *         return XDP_ABORTED;
>          *
> -        *     if (*qidconf)
> +        *     qc =3D *qidconf;
> +        *
> +        *     if (qc =3D=3D 2)
> +        *         qc =3D is_xskrq ? 1 : 0;
> +        *
> +        *     switch (qc) {
> +        *     case 0:
> +        *         return XDP_PASS;
> +        *     case 1:
>          *         return bpf_redirect_map(&xsks_map, index, 0);
> +        *     }
>          *
> -        *     return XDP_PASS;
> +        *     return XDP_ABORTED;
>          * }
>          */
>         struct bpf_insn prog[] =3D {
> -               /* r1 =3D *(u32 *)(r1 + 16) */
> -               BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 16),
> -               /* *(u32 *)(r10 - 4) =3D r1 */
> -               BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
> -               BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> -               BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
> -               BPF_LD_MAP_FD(BPF_REG_1, xsk->qidconf_map_fd),
> +               /* Load index. */
> +               /* r6 =3D *(u32 *)(r1 + 16) */
> +               BPF_LDX_MEM(BPF_W, BPF_REG_6, BPF_REG_ARG1, 16),
> +               /* w7 =3D w6 */
> +               BPF_MOV32_REG(BPF_REG_7, BPF_REG_6),
> +               /* w7 &=3D 2147483647 */
> +               BPF_ALU32_IMM(BPF_AND, BPF_REG_7, ~XDP_QID_FLAG_XSKRQ),
> +               /* *(u32 *)(r10 - 4) =3D r7 */
> +               BPF_STX_MEM(BPF_W, BPF_REG_FP, BPF_REG_7, -4),
> +
> +               /* Call bpf_map_lookup_elem. */
> +               /* r2 =3D r10 */
> +               BPF_MOV64_REG(BPF_REG_ARG2, BPF_REG_FP),
> +               /* r2 +=3D -4 */
> +               BPF_ALU64_IMM(BPF_ADD, BPF_REG_ARG2, -4),
> +               /* r1 =3D qidconf_map ll */
> +               BPF_LD_MAP_FD(BPF_REG_ARG1, xsk->qidconf_map_fd),
> +               /* call 1 */
>                 BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
> -               BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> -               BPF_MOV32_IMM(BPF_REG_0, 0),
> -               /* if r1 =3D=3D 0 goto +8 */
> -               BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 8),
> -               BPF_MOV32_IMM(BPF_REG_0, 2),
> -               /* r1 =3D *(u32 *)(r1 + 0) */
> -               BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
> -               /* if r1 =3D=3D 0 goto +5 */
> -               BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
> -               /* r2 =3D *(u32 *)(r10 - 4) */
> -               BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
> -               BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_10, -4),
> +
> +               /* Check the return value. */
> +               /* if r0 =3D=3D 0 goto +14 */
> +               BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 14),
> +
> +               /* Check qc =3D=3D QIDCONF_XSK_COMBINED. */
> +               /* r6 >>=3D 31 */
> +               BPF_ALU64_IMM(BPF_RSH, BPF_REG_6, 31),
> +               /* r1 =3D *(u32 *)(r0 + 0) */
> +               BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0),
> +               /* if r1 =3D=3D 2 goto +1 */
> +               BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, QIDCONF_XSK_COMBINED, 1),
> +
> +               /* qc !=3D QIDCONF_XSK_COMBINED */
> +               /* r6 =3D r1 */
> +               BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
> +
> +               /* switch (qc) */
> +               /* w0 =3D 2 */
> +               BPF_MOV32_IMM(BPF_REG_0, XDP_PASS),
> +               /* if w6 =3D=3D 0 goto +8 */
> +               BPF_JMP32_IMM(BPF_JEQ, BPF_REG_6, QIDCONF_REGULAR, 8),
> +               /* if w6 !=3D 1 goto +6 */
> +               BPF_JMP32_IMM(BPF_JNE, BPF_REG_6, QIDCONF_XSK, 6),
> +
> +               /* Call bpf_redirect_map. */
> +               /* r1 =3D xsks_map ll */
> +               BPF_LD_MAP_FD(BPF_REG_ARG1, xsk->xsks_map_fd),
> +               /* w2 =3D w7 */
> +               BPF_MOV32_REG(BPF_REG_ARG2, BPF_REG_7),
> +               /* w3 =3D 0 */
>                 BPF_MOV32_IMM(BPF_REG_3, 0),
> +               /* call 51 */
>                 BPF_EMIT_CALL(BPF_FUNC_redirect_map),
> -               /* The jumps are to this instruction */
> +               /* exit */
> +               BPF_EXIT_INSN(),
> +
> +               /* XDP_ABORTED */
> +               /* w0 =3D 0 */
> +               BPF_MOV32_IMM(BPF_REG_0, XDP_ABORTED),
> +               /* exit */
>                 BPF_EXIT_INSN(),
>         };
>         size_t insns_cnt =3D sizeof(prog) / sizeof(struct bpf_insn);
> @@ -483,6 +538,7 @@ static int xsk_update_bpf_maps(struct xsk_socket *xsk=
, int qidconf_value,
>
>  static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>  {
> +       int qidconf_value =3D QIDCONF_XSK;
>         bool prog_attached =3D false;
>         __u32 prog_id =3D 0;
>         int err;
> @@ -505,7 +561,11 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk=
)
>                 xsk->prog_fd =3D bpf_prog_get_fd_by_id(prog_id);
>         }
>
> -       err =3D xsk_update_bpf_maps(xsk, true, xsk->fd);
> +       if (xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__COMBINED_CHANNEL=
S)
> +               if (xsk->zc)
> +                       qidconf_value =3D QIDCONF_XSK_COMBINED;
> +
> +       err =3D xsk_update_bpf_maps(xsk, qidconf_value, xsk->fd);
>         if (err)
>                 goto out_load;
>
> @@ -717,7 +777,7 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>         if (!xsk)
>                 return;
>
> -       (void)xsk_update_bpf_maps(xsk, 0, 0);
> +       (void)xsk_update_bpf_maps(xsk, QIDCONF_REGULAR, 0);
>
>         optlen =3D sizeof(off);
>         err =3D getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &opt=
len);
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 82ea71a0f3ec..be26a2423c04 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -180,6 +180,10 @@ struct xsk_umem_config {
>
>  /* Flags for the libbpf_flags field. */
>  #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
> +#define XSK_LIBBPF_FLAGS__COMBINED_CHANNELS (1 << 1)
> +#define XSK_LIBBPF_FLAGS_MASK ( \
> +       XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD | \
> +       XSK_LIBBPF_FLAGS__COMBINED_CHANNELS)
>
>  struct xsk_socket_config {
>         __u32 rx_size;
> --
> 2.19.1
>
