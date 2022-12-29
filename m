Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CAE658DB1
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 15:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiL2OAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 09:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbiL2OAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 09:00:45 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACDFBE3D
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 06:00:19 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id co23so17462446wrb.4
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 06:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tirzwoCKleZSrmqza8eSDWBwxX2SfTStbo0Ru6BsGf0=;
        b=FLE21wIEnVM7ncSS4qzIoOx1IBkyoeSDfTq1/lSIOXDo7nPhnIZytI1jtSnJhoRHnY
         7tIK3YG/l2tiDwLMRm7IbPl9IxsK5OIkRKjddkiGHVyhfBc2mu5dg9XgCF1WLcDYKvGR
         IBv9vBwj4jKoXR4Hfl8wRmdGNVWNQyY81UlWcrxSqPQQh5GsD/SW3dHNu/Czk5gJv25D
         Bx6yekmr9rtNLrOuFDySSpb1UCNSQ8M2ilItd5rUW7vhTsuHVn//7n7TnohCLOiHWeKG
         I3iZnWbLDNUHzWDvdaRDUsT4KltaVJW1XfRzjaV6EB4FJRKQg8uLs8PJ40JhiN9XsCDO
         4GRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tirzwoCKleZSrmqza8eSDWBwxX2SfTStbo0Ru6BsGf0=;
        b=k+poSq+Usd8kco6HYrR/l3G2twSXGZO8th16mTzbJe/SBcQWJCmAXnnyjG5Gps0E+m
         ghjtDz/gGkRpj5oD0j2Ee8vNB7z/BGoWRCRV7bsNd/A+CujGuqyV0W9BLqp9MsnFstu1
         BoREIX3r/XQ2M91X3mYK54UDYMuI2L9+0KBlp5RlL9ivhDNfL+c+8hqmHwGjyZFbD7PP
         QnA3hI/z735maPH1qqANiHnr0Dcyj5UJwkejjCwjmm9OrDov6TG2l63oC9pJzLJ0A3u1
         XyA32J1lLf+Ihh6yVI6mfoFwr+FKI7i9xBjFxq/WEnkTZOLnbBLBZ5KCbe30Dc89HEIk
         DKFg==
X-Gm-Message-State: AFqh2kq8nczYgSEVd3tWHarbO6XdVDYxsxIFOkRt1UzixVEdTQEks+rE
        pZaGqTW8efksFGKIpoSfVNk1TxidK+PWdBBdRmoVF3N1z9uC3VZQ
X-Google-Smtp-Source: AMrXdXu32+lUVZZHB2DyW+INZwJ0Imn3bPqsasUkYmdM16E/cURCvRAChufzue0LNnXh95Ve4E9to7Ar0LaNpD3sl80=
X-Received: by 2002:adf:ec05:0:b0:242:1a08:dc1a with SMTP id
 x5-20020adfec05000000b002421a08dc1amr746328wrn.205.1672322417525; Thu, 29 Dec
 2022 06:00:17 -0800 (PST)
MIME-Version: 1.0
References: <20221229080207.1029-1-cuiyunhui@bytedance.com>
In-Reply-To: <20221229080207.1029-1-cuiyunhui@bytedance.com>
From:   =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Date:   Thu, 29 Dec 2022 22:00:30 +0800
Message-ID: <CAEEQ3wnocPEZsidQn5M1iK=FA1Y+VeYzb2PJUbJVyU7JC1azyQ@mail.gmail.com>
Subject: Re: [PATCH] tcp/udp: add tracepoint for send recv length
To:     edumazet@google.com, rostedt@goodmis.org, mhiramat@kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, duanxiongchun@bytedance.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, cuiyunhui@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

The following content is a supplement to the commit log of this patch.
In v2, the following content will be added to the commit log.

The purpose of adding these 4 tracepoints is to monitor the
tcp/udp traffic of per process and per cgroup.

Regarding monitoring the tcp/udp traffic of each process,
the existing implementation is https://www.atoptool.nl/netatop.php.
This solution is implemented by registering the hook function at
the hook point provided by the netfilter framework.

These hook functions may be in the soft interrupt context
and cannot directly obtain the pid. Some data structures
are added to bind packets and processes.
For example, struct taskinfobucket, struct taskinfo ...

Every time the process sends and receives packets it needs multiple hashmap=
s,
resulting in low performance and the problem of inaccurate tcp/udp
traffic statistics(for example: multiple threads share sockets).

Based on these 4 tracepoints, we have optimized and tested performance.
Time Per Request as an indicator,
without monitoring: 50.95ms, netatop: 63.27 ms, Hook on these
tracepoints: 52.24ms.
The performance has been improved 10 times.
The tcp/udp traffic of each process has also been accurately counted.

We also used these 4 tracepoints to monitor the traffic of each cgroup.

Therefore, these 4 tracepoints are the basis. Thanks.

Yunhui Cui <cuiyunhui@bytedance.com> =E4=BA=8E2022=E5=B9=B412=E6=9C=8829=E6=
=97=A5=E5=91=A8=E5=9B=9B 16:02=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Xiongchun Duan <duanxiongchun@bytedance.com>
>
> Add a tracepoint for capturing TCP segments with
> a send or receive length. This makes it easy to obtain
> the packet sending and receiving information of each process
> in the user mode, such as the netatop tool.
>
> Signed-off-by: Xiongchun Duan <duanxiongchun@bytedance.com>
> ---
>  include/trace/events/tcp.h | 41 ++++++++++++++++++++++++++++++++++++++
>  include/trace/events/udp.h | 34 +++++++++++++++++++++++++++++++
>  net/ipv4/tcp.c             |  7 +++++++
>  net/ipv4/udp.c             | 11 ++++++++--
>  4 files changed, 91 insertions(+), 2 deletions(-)
>
> diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
> index 901b440238d5..d9973c8508d1 100644
> --- a/include/trace/events/tcp.h
> +++ b/include/trace/events/tcp.h
> @@ -187,6 +187,47 @@ DEFINE_EVENT(tcp_event_sk, tcp_rcv_space_adjust,
>         TP_ARGS(sk)
>  );
>
> +/*
> + * tcp send/recv stream length
> + *
> + * Note: this class requires positive integer
> + */
> +DECLARE_EVENT_CLASS(tcp_stream_length,
> +
> +       TP_PROTO(struct sock *sk, int length, int error, int flags),
> +
> +       TP_ARGS(sk, length, error, flags),
> +
> +       TP_STRUCT__entry(
> +               __field(void *, sk)
> +               __field(int, length)
> +               __field(int, error)
> +               __field(int, flags)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->sk =3D sk;
> +               __entry->length =3D length;
> +               __entry->error =3D error;
> +               __entry->flags =3D flags;
> +       ),
> +
> +       TP_printk("sk address =3D %p, length =3D %d, error =3D %d flags =
=3D %u ",
> +               __entry->sk, __entry->length, __entry->error, __entry->fl=
ags)
> +);
> +
> +DEFINE_EVENT(tcp_stream_length, tcp_send_length,
> +       TP_PROTO(struct sock *sk, int length, int error, int flags),
> +
> +       TP_ARGS(sk, length, error, flags)
> +);
> +
> +DEFINE_EVENT(tcp_stream_length, tcp_recv_length,
> +       TP_PROTO(struct sock *sk, int length, int error, int flags),
> +
> +       TP_ARGS(sk, length, error, flags)
> +);
> +
>  TRACE_EVENT(tcp_retransmit_synack,
>
>         TP_PROTO(const struct sock *sk, const struct request_sock *req),
> diff --git a/include/trace/events/udp.h b/include/trace/events/udp.h
> index 336fe272889f..22181c91c8e2 100644
> --- a/include/trace/events/udp.h
> +++ b/include/trace/events/udp.h
> @@ -27,6 +27,40 @@ TRACE_EVENT(udp_fail_queue_rcv_skb,
>         TP_printk("rc=3D%d port=3D%hu", __entry->rc, __entry->lport)
>  );
>
> +DECLARE_EVENT_CLASS(udp_stream_length,
> +
> +       TP_PROTO(struct sock *sk, int length, int error, int flags),
> +
> +       TP_ARGS(sk, length, error, flags),
> +
> +       TP_STRUCT__entry(
> +               __field(void *, sk)
> +               __field(int, length)
> +               __field(int, error)
> +               __field(int, flags)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->sk =3D sk;
> +               __entry->length =3D length;
> +               __entry->error =3D error;
> +               __entry->flags =3D flags;
> +       ),
> +
> +       TP_printk("sk address =3D %p, length =3D %d, error=3D%d, flags =
=3D %u ",
> +       __entry->sk, __entry->length, __entry->error, __entry->flags)
> +);
> +
> +DEFINE_EVENT(udp_stream_length, udp_send_length,
> +       TP_PROTO(struct sock *sk, int length, int error, int flags),
> +       TP_ARGS(sk, length, error, flags)
> +);
> +
> +DEFINE_EVENT(udp_stream_length, udp_recv_length,
> +       TP_PROTO(struct sock *sk, int length, int error, int flags),
> +       TP_ARGS(sk, length, error, flags)
> +);
> +
>  #endif /* _TRACE_UDP_H */
>
>  /* This part must be outside protection */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index c567d5e8053e..5deb69e2d3e7 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -267,6 +267,7 @@
>  #include <linux/errqueue.h>
>  #include <linux/static_key.h>
>  #include <linux/btf.h>
> +#include <trace/events/tcp.h>
>
>  #include <net/icmp.h>
>  #include <net/inet_common.h>
> @@ -1150,6 +1151,7 @@ int tcp_sendpage(struct sock *sk, struct page *page=
, int offset,
>         lock_sock(sk);
>         ret =3D tcp_sendpage_locked(sk, page, offset, size, flags);
>         release_sock(sk);
> +       trace_tcp_send_length(sk, ret > 0 ? ret : 0, ret > 0 ? 0 : ret, 0=
);
>
>         return ret;
>  }
> @@ -1482,6 +1484,7 @@ int tcp_sendmsg(struct sock *sk, struct msghdr *msg=
, size_t size)
>         lock_sock(sk);
>         ret =3D tcp_sendmsg_locked(sk, msg, size);
>         release_sock(sk);
> +       trace_tcp_send_length(sk, ret > 0 ? ret : 0, ret > 0 ? 0 : ret, 0=
);
>
>         return ret;
>  }
> @@ -2647,6 +2650,10 @@ static int tcp_recvmsg_locked(struct sock *sk, str=
uct msghdr *msg, size_t len,
>
>         /* Clean up data we have read: This will do ACK frames. */
>         tcp_cleanup_rbuf(sk, copied);
> +       trace_tcp_recv_length(sk, (copied > 0 && !(flags & MSG_PEEK)) ?
> +                                  copied : 0,
> +                             (copied > 0 &&
> +                              !(flags & MSG_PEEK)) ? 0 : copied, flags);
>         return copied;
>
>  out:
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 9592fe3e444a..1b336af4df6d 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1300,6 +1300,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg=
, size_t len)
>         release_sock(sk);
>
>  out:
> +       trace_udp_send_length(sk, err =3D=3D 0 ? len : 0, err, 0);
>         ip_rt_put(rt);
>  out_free:
>         if (free)
> @@ -1364,8 +1365,10 @@ int udp_sendpage(struct sock *sk, struct page *pag=
e, int offset,
>                              page, offset, size, flags);
>         if (ret =3D=3D -EOPNOTSUPP) {
>                 release_sock(sk);
> -               return sock_no_sendpage(sk->sk_socket, page, offset,
> -                                       size, flags);
> +               ret =3D sock_no_sendpage(sk->sk_socket, page, offset,
> +                                      size, flags);
> +               trace_udp_send_length(sk, ret > 0 ? ret : 0, ret > 0 ? 0 =
: ret, 0);
> +               return ret;
>         }
>         if (ret < 0) {
>                 udp_flush_pending_frames(sk);
> @@ -1377,6 +1380,7 @@ int udp_sendpage(struct sock *sk, struct page *page=
, int offset,
>                 ret =3D udp_push_pending_frames(sk);
>         if (!ret)
>                 ret =3D size;
> +       trace_udp_send_length(sk, ret > 0 ? ret : 0, ret > 0 ? 0 : ret, 0=
);
>  out:
>         release_sock(sk);
>         return ret;
> @@ -1935,6 +1939,9 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg=
, size_t len, int flags,
>         if (flags & MSG_TRUNC)
>                 err =3D ulen;
>
> +       trace_udp_recv_length(sk, (err > 0 && !peeking) ? err : 0,
> +                             (err > 0 && !peeking) ? 0 : err, flags);
> +
>         skb_consume_udp(sk, skb, peeking ? -err : err);
>         return err;
>
> --
> 2.20.1
>
