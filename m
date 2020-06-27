Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A84020C33D
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 19:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgF0RRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 13:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgF0RRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 13:17:40 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A607C061794
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 10:17:40 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id p204so2306461ybc.11
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 10:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H7HRMHL/+DTjLoiHGFta2cnT5jFeaabjVtDI5/tzLRM=;
        b=D+xx+wbWhQg7qwWQrY02o1FjX9rHOSDmYHHkc+zkcuKLjfCGXm75iPdXhRtiVLkQTK
         0/76sqEKXmtcflfVFEsKpWNvbw9l8nf+zFcc31bWgB21CUMoktMHRQISHEk+yNbsHAGw
         B7q28TFJOZZ+Z/ZeA19fCUQVpS6q6iP3RdwGrwwXqPK4l4XuJJuamTJ7aXgKNmmorqZD
         Pi5ZRnNeOxkkqZNvG8lahun2Jg77SwiwSypiV9LMQYKZ8ScjfmOilGCW8ISu+5bqUcOX
         CrGrUcUkQDOtxmUBlr5HC0G7bDInIJdOKNSwNIBqoLlVzoTi+JkXbGPKJN9nY/Mo0vYK
         6wRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H7HRMHL/+DTjLoiHGFta2cnT5jFeaabjVtDI5/tzLRM=;
        b=nYjLqLDjZXjI2yv4FiZP9nJCj6VKEw+GeECeIBUW7YEI/AcfdFmJcwQyTytdnRbF0g
         EZyOByQjCY4zTuSj4PHN6KAfYSIPT+00/TC17DkuybZgUkv9FiW9TmQPQ6GfhzOACuJl
         xMX0nR7mTyn8hbPcR6M221a9flTTbaORZuZrSx+cmTX5uyFXDBx9l9L4EAMQU2TNBOKL
         qdUoEDud3D0BEEK5y7/wJe+MJAChkoZn29MACCey8npmFoZ5+eCDaxqtmpYy0MS2er6P
         CWIORgyr993buBF+fzwasrI15gWK+iXyWDk/U82fPU80XgFzZl2fTU1cs0duNIncYZUR
         tL7Q==
X-Gm-Message-State: AOAM532V5lOdJblTJsr35a7nWuPWT9QN0CzRGXokoOmJ7BInkOOK5lnB
        ysQtvUD4czdncPRfFc82LMlGB0MFSOllJkd6db2ORQ==
X-Google-Smtp-Source: ABdhPJyUxDd/0eGg/6T5dIbyFaStHwrtmziggaD99Nd0s2L2YmqHvLcU6blNHwdwXA4pE8FTAwccPjm7kI15nm9HhdY=
X-Received: by 2002:a25:b88d:: with SMTP id w13mr14325767ybj.520.1593278258192;
 Sat, 27 Jun 2020 10:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200626175501.1459961-1-kafai@fb.com> <20200626175514.1460570-1-kafai@fb.com>
In-Reply-To: <20200626175514.1460570-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 27 Jun 2020 10:17:26 -0700
Message-ID: <CANn89iK50rqOVy=PmKO-Fe1D-HsHjp4zj-feevouQ2hc1GAQ9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/10] tcp: bpf: Parse BPF experimental header option
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 10:55 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds logic to parse experimental kind 254 with 16 bit magic
> 0xeB9F.  The latter patch will allow bpf prog to write and parse data
> under this experimental kind and magic.
>
> A one byte bpf_hdr_opt_off is added to tcp_skb_cb by using an existing
> 4 byte hole.  It is only used in rx.  It stores the offset to the
> bpf experimental option and will be made available to BPF prog
> in a latter patch.  This offset is also stored in the saved_syn.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/net/request_sock.h | 1 +
>  include/net/tcp.h          | 3 +++
>  net/ipv4/tcp_input.c       | 6 ++++++
>  net/ipv4/tcp_ipv4.c        | 1 +
>  net/ipv6/tcp_ipv6.c        | 1 +
>  5 files changed, 12 insertions(+)
>
> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> index d77237ec9fb4..55297286c066 100644
> --- a/include/net/request_sock.h
> +++ b/include/net/request_sock.h
> @@ -43,6 +43,7 @@ int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req);
>
>  struct saved_syn {
>         u32 network_hdrlen;
> +       u32 bpf_hdr_opt_off;
>         u8 data[];
>  };
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index eab1c7d0facb..07a9dfe35242 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -191,6 +191,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
>   */
>  #define TCPOPT_FASTOPEN_MAGIC  0xF989
>  #define TCPOPT_SMC_MAGIC       0xE2D4C3D9
> +#define TCPOPT_BPF_MAGIC       0xEB9F
>
>  /*
>   *     TCP option lengths
> @@ -204,6 +205,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
>  #define TCPOLEN_FASTOPEN_BASE  2
>  #define TCPOLEN_EXP_FASTOPEN_BASE  4
>  #define TCPOLEN_EXP_SMC_BASE   6
> +#define TCPOLEN_EXP_BPF_BASE   4
>
>  /* But this is what stacks really send out. */
>  #define TCPOLEN_TSTAMP_ALIGNED         12
> @@ -857,6 +859,7 @@ struct tcp_skb_cb {
>                         has_rxtstamp:1, /* SKB has a RX timestamp       */
>                         unused:5;
>         __u32           ack_seq;        /* Sequence number ACK'd        */
> +       __u8            bpf_hdr_opt_off;/* offset to bpf hdr option. rx only. */
>         union {
>                 struct {
>                         /* There is space for up to 24 bytes */
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index eb0e32b2def9..640408a80b3d 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3924,6 +3924,10 @@ void tcp_parse_options(const struct net *net,
>                                         tcp_parse_fastopen_option(opsize -
>                                                 TCPOLEN_EXP_FASTOPEN_BASE,
>                                                 ptr + 2, th->syn, foc, true);
> +                               else if (opsize >= TCPOLEN_EXP_BPF_BASE &&
> +                                        get_unaligned_be16(ptr) ==
> +                                        TCPOPT_BPF_MAGIC)
> +                                       TCP_SKB_CB(skb)->bpf_hdr_opt_off = (ptr - 2) - (unsigned char *)th;
>                                 else
>                                         smc_parse_options(th, opt_rx, ptr,
>                                                           opsize);
> @@ -6562,6 +6566,8 @@ static void tcp_reqsk_record_syn(const struct sock *sk,
>                 saved_syn = kmalloc(len + sizeof(*saved_syn), GFP_ATOMIC);
>                 if (saved_syn) {
>                         saved_syn->network_hdrlen = skb_network_header_len(skb);
> +                       saved_syn->bpf_hdr_opt_off =
> +                               TCP_SKB_CB(skb)->bpf_hdr_opt_off;
>                         memcpy(saved_syn->data, skb_network_header(skb), len);
>                         req->saved_syn = saved_syn;
>                 }
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index ea0df9fd7618..a3535b7fe002 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1864,6 +1864,7 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
>         TCP_SKB_CB(skb)->sacked  = 0;
>         TCP_SKB_CB(skb)->has_rxtstamp =
>                         skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
> +       TCP_SKB_CB(skb)->bpf_hdr_opt_off = 0;
>  }
>
>  /*
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index f67d45ff00b4..8356d0562279 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1545,6 +1545,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
>         TCP_SKB_CB(skb)->sacked = 0;
>         TCP_SKB_CB(skb)->has_rxtstamp =
>                         skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
> +       TCP_SKB_CB(skb)->bpf_hdr_opt_off = 0;
>  }
>
>  INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
> --
> 2.24.1
>

(Sorry for the prior empty reply, accidentally click the wrong area)

It seems strange that we want to add code in TCP stack only to cover a
limited use case (kind 254 and 0xEB9F magic)

For something like the work Petar Penkov did (to be able to generate
SYNCOOKIES from XDP), we do not go through tcp_parse_options() and BPF
program
would have to implement its own parsing (without having an SKB at
hand), probably calling a helper function, with no
TCP_SKB_CB(skb)->bpf_hdr_opt_off.

This patch is hard coding a specific option and will prevent anyone
using private option(s) from using this infrastructure in the future,
yet paying the extra overhead.

TCP_SKB_CB(skb) is tight, I would prefer keeping the space in it for
standard TCP stack features.

If an optional BPF program needs to re-parse the TCP options to find a
specific option, maybe the extra cost is noise (especially if this is
only for SYN & SYNACK packets) ?

Thanks
