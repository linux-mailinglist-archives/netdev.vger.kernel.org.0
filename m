Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4ED6B2C9
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbfGQAXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:23:21 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39839 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbfGQAXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:23:21 -0400
Received: by mail-oi1-f194.google.com with SMTP id m202so17099199oig.6;
        Tue, 16 Jul 2019 17:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=II5t7xXFbfBgQJHak24dyTai7VO42Pm3JKrGMChFOUY=;
        b=XmcetWm8AKndqUA4ABKAoDLKqKWD8HMKdQW7OKIBHNCYYpuO/yGqzX4xxY7Zjo44GA
         OjRxdh/Dlo3ryhLt3LaXnjMQ1al6N2wrmTriCy6a4PT0zFCK3TjrhyR+s9HLbz0Aqab5
         VWK7Pv55cdJnUTRIIgzN/tFBuPaQ9FvXO1yCQcWMy0XvhPGNzg5tgnJ7AFHFYM4S8pps
         qB5Jp8RSJtkSNN6qkGVzEcNxtYtG8tXDAjH2MaIxMgoY+XctYTtWgIAvl1Exnrt5gyGh
         7zBhKwPNucjk04akB6aWakmaa8WafhgzfZUXGkxAnifyrelwam8mJ3IMXrxKzO3P6rg0
         vyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=II5t7xXFbfBgQJHak24dyTai7VO42Pm3JKrGMChFOUY=;
        b=g4V9viJD9Ap41+/0BiXRD8ioVpeXKiFC5uEGskYlnsskOvKUPyruA1tv+a3V+iN3Gw
         ZcDqh1erQwO109fpMt68NIxo/SlpYcP79c21DcCm59Gkf8DQ1DDlu5cvJGJgf/7eoSjT
         hhz5BIFvPNdMyYA5oJ/0nw3fzkqj3wU7dih7rdyYCoqhkzQSSV5fK/Ysq6Jao4P9oHGz
         tjHDj/Bv4DjONzURkevThcPCemGx68DTG5EaATB/g5p7g9h/EYordJTbX6LkFkyQZ8/z
         qcqm850djNCtWULOw/8Dh1i83cYQBGkhMXerBeH2mYO7z8VLIB/VKe6S42TxLCjE7mqM
         PIvQ==
X-Gm-Message-State: APjAAAW4P1JXhvv/Eu9HbEGg604+fBXb7FvRPNVlbp+4SrzxOvGXjK6d
        PftMbL33E1GPEflrpvzCZCgp568RVaCU4X0WDHQ=
X-Google-Smtp-Source: APXvYqzlDXwgIUEfeTBGhDqx9Wh1ZgAPgjKp7XY0ESkWRpbIvobSlPsvwaLug1jWir8ir9T1vKfy4RC39GAifJE5DvM=
X-Received: by 2002:a05:6808:98:: with SMTP id s24mr17584663oic.127.1563322999838;
 Tue, 16 Jul 2019 17:23:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
 <20190716002650.154729-3-ppenkov.kernel@gmail.com> <CACAyw99Umy6gaAu1DFTgemRXpZWmxeTSeCZDwdHWzLWeG8Ur3Q@mail.gmail.com>
In-Reply-To: <CACAyw99Umy6gaAu1DFTgemRXpZWmxeTSeCZDwdHWzLWeG8Ur3Q@mail.gmail.com>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Tue, 16 Jul 2019 17:23:09 -0700
Message-ID: <CAGdtWsR1a6fMsuB6u6yi1+r_n8Sm6kE-NcgjZa2aVS5_cmLSSg@mail.gmail.com>
Subject: Re: [bpf-next RFC 2/6] tcp: add skb-less helpers to retrieve SYN cookie
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 4:35 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 16 Jul 2019 at 01:27, Petar Penkov <ppenkov.kernel@gmail.com> wrote:
> >
> > From: Petar Penkov <ppenkov@google.com>
> >
> > This patch allows generation of a SYN cookie before an SKB has been
> > allocated, as is the case at XDP.
> >
> > Signed-off-by: Petar Penkov <ppenkov@google.com>
> > ---
> >  include/net/tcp.h    | 11 ++++++
> >  net/ipv4/tcp_input.c | 79 ++++++++++++++++++++++++++++++++++++++++++++
> >  net/ipv4/tcp_ipv4.c  |  8 +++++
> >  net/ipv6/tcp_ipv6.c  |  8 +++++
> >  4 files changed, 106 insertions(+)
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index cca3c59b98bf..a128e22c0d5d 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -414,6 +414,17 @@ void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
> >                        int estab, struct tcp_fastopen_cookie *foc);
> >  const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
> >
> > +/*
> > + *     BPF SKB-less helpers
> > + */
> > +u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
> > +                        struct tcphdr *tch, u32 *cookie);
> > +u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
> > +                        struct tcphdr *tch, u32 *cookie);
> > +u16 tcp_get_syncookie(struct request_sock_ops *rsk_ops,
> > +                     const struct tcp_request_sock_ops *af_ops,
> > +                     struct sock *sk, void *iph, struct tcphdr *tch,
> > +                     u32 *cookie);
> >  /*
> >   *     TCP v4 functions exported for the inet6 API
> >   */
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 8892df6de1d4..1406d7e0953c 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -3782,6 +3782,52 @@ static void smc_parse_options(const struct tcphdr *th,
> >  #endif
> >  }
> >
> > +/* Try to parse the MSS option from the TCP header. Return 0 on failure, clamped
> > + * value on success.
> > + *
> > + * Invoked for BPF SYN cookie generation, so th should be a SYN.
> > + */
> > +static u16 tcp_parse_mss_option(const struct net *net, const struct tcphdr *th,
> > +                               u16 user_mss)
>
> net seems unused?

Ah, good catch! Will remove this in the v2.

>
> > +{
> > +       const unsigned char *ptr = (const unsigned char *)(th + 1);
> > +       int length = (th->doff * 4) - sizeof(struct tcphdr);
> > +       u16 mss = 0;
> > +
> > +       while (length > 0) {
> > +               int opcode = *ptr++;
> > +               int opsize;
> > +
> > +               switch (opcode) {
> > +               case TCPOPT_EOL:
> > +                       return mss;
> > +               case TCPOPT_NOP:        /* Ref: RFC 793 section 3.1 */
> > +                       length--;
> > +                       continue;
> > +               default:
> > +                       if (length < 2)
> > +                               return mss;
> > +                       opsize = *ptr++;
> > +                       if (opsize < 2) /* "silly options" */
> > +                               return mss;
> > +                       if (opsize > length)
> > +                               return mss;     /* fail on partial options */
> > +                       if (opcode == TCPOPT_MSS && opsize == TCPOLEN_MSS) {
> > +                               u16 in_mss = get_unaligned_be16(ptr);
> > +
> > +                               if (in_mss) {
> > +                                       if (user_mss && user_mss < in_mss)
> > +                                               in_mss = user_mss;
> > +                                       mss = in_mss;
> > +                               }
> > +                       }
> > +                       ptr += opsize - 2;
> > +                       length -= opsize;
> > +               }
> > +       }
> > +       return mss;
> > +}
> > +
> >  /* Look for tcp options. Normally only called on SYN and SYNACK packets.
> >   * But, this can also be called on packets in the established flow when
> >   * the fast version below fails.
> > @@ -6464,6 +6510,39 @@ static void tcp_reqsk_record_syn(const struct sock *sk,
> >         }
> >  }
> >
> > +u16 tcp_get_syncookie(struct request_sock_ops *rsk_ops,
> > +                     const struct tcp_request_sock_ops *af_ops,
> > +                     struct sock *sk, void *iph, struct tcphdr *th,
> > +                     u32 *cookie)
> > +{
> > +       u16 mss = 0;
> > +#ifdef CONFIG_SYN_COOKIES
> > +       bool is_v4 = rsk_ops->family == AF_INET;
> > +       struct tcp_sock *tp = tcp_sk(sk);
> > +
> > +       if (sock_net(sk)->ipv4.sysctl_tcp_syncookies != 2 &&
> > +           !inet_csk_reqsk_queue_is_full(sk))
> > +               return 0;
> > +
> > +       if (!tcp_syn_flood_action(sk, rsk_ops->slab_name))
> > +               return 0;
> > +
> > +       if (sk_acceptq_is_full(sk)) {
> > +               NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
> > +               return 0;
> > +       }
> > +
> > +       mss = tcp_parse_mss_option(sock_net(sk), th, tp->rx_opt.user_mss);
> > +       if (!mss)
> > +               mss = af_ops->mss_clamp;
> > +
> > +       tcp_synq_overflow(sk);
> > +       *cookie = is_v4 ? __cookie_v4_init_sequence(iph, th, &mss)
> > +                       : __cookie_v6_init_sequence(iph, th, &mss);
> > +#endif
> > +       return mss;
> > +}
> > +
> >  int tcp_conn_request(struct request_sock_ops *rsk_ops,
> >                      const struct tcp_request_sock_ops *af_ops,
> >                      struct sock *sk, struct sk_buff *skb)
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index d57641cb3477..0e06e59784bd 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1515,6 +1515,14 @@ static struct sock *tcp_v4_cookie_check(struct sock *sk, struct sk_buff *skb)
> >         return sk;
> >  }
> >
> > +u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
> > +                        struct tcphdr *tch, u32 *cookie)
> > +{
> > +       return tcp_get_syncookie(&tcp_request_sock_ops,
> > +                                &tcp_request_sock_ipv4_ops, sk, iph, tch,
> > +                                cookie);
> > +}
> > +
> >  /* The socket must have it's spinlock held when we get
> >   * here, unless it is a TCP_LISTEN socket.
> >   *
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index d56a9019a0fe..ce46cdba54bc 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -1058,6 +1058,14 @@ static struct sock *tcp_v6_cookie_check(struct sock *sk, struct sk_buff *skb)
> >         return sk;
> >  }
> >
> > +u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
> > +                        struct tcphdr *tch, u32 *cookie)
> > +{
> > +       return tcp_get_syncookie(&tcp6_request_sock_ops,
> > +                                &tcp_request_sock_ipv6_ops, sk, iph, tch,
> > +                                cookie);
> > +}
> > +
> >  static int tcp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
> >  {
> >         if (skb->protocol == htons(ETH_P_IP))
> > --
> > 2.22.0.510.g264f2c817a-goog
> >
>
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
