Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F90B2337A2
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgG3RZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbgG3RZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:25:57 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D3EC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:25:56 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t18so23170181ilh.2
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ebPOcVHpkOqaBWt9fMlhdgoZIlxRoBkkoAXDquEghQg=;
        b=nO708ndbZDaK45Fg/4BPKv1XSVKeg7yvDaoD3ccTmrC6a6IEl+Sn2hgGYDaba56nhG
         3R8wRFX/NqWxfZRNbv5NRpe+BznxhTg+1lb3uCmonwfDKpQ5MSOieuu9vY3B2FiIODZc
         biH5ztWt6h6Anp2C+oA9MKnp3i4P6eNCbtEtaWNoFqT6M2KIwRGtyaAWALBJgAQ0ubpb
         mQJrjWPd1urnL24gtfT4cprxe9d/5o4BhUzzf0tWBLrWQR93LQRDd8O9JS83aTkOrmNi
         0U1eOnRRVBEqxHB4iVmZ4SAYea654m0KRKWc3ti9HC1Xjevr8/zFRDigJMMuxhv+JwYR
         LiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ebPOcVHpkOqaBWt9fMlhdgoZIlxRoBkkoAXDquEghQg=;
        b=irZ/ksqk38+zhqp2HkJY8PvVq0uLaoTRAokHxLITUd9aujYqkyPfo9GEpeKfbGlUM3
         JImzPu7Nt/wbUhf4HaOcCdgnBPNnG91c1NlsVT8p20AUNttgfnSpE/hAu1wM6yVs/Trj
         LXlJ523o4E620v/SZRnNgvdwsM2Nh0fJ5iM4dwh36osGZFMIfNzugSsD9JcQep/s9sfp
         If268o7Sf92CkKqEQlAiT9GSgZ/Y2YbxsuJEedumGFr1c0AFwPTJvRjF/5RFrh8LHvly
         uEyWwhKULCXl0UHoUdyU5LqXPs0fgwgXfHjFNwdVh+6ZPQx6jg36fWH09gsCBcLeIhAC
         yLQg==
X-Gm-Message-State: AOAM5322hQjP6U3kqgwShTs0EE5e/xmutMtVM+Xl7avY04kSkPUEyI3u
        becnCToFk+lmMqQRLDjbN0JQJnkn8+QMTKQd1TVH8WmQ
X-Google-Smtp-Source: ABdhPJyq1Px6Hgod9TcMrkzJGvyLhYPnebqx46WqdTu9tTrf4xI/7Qj/9DBprs24BKOBcDPJQlXClBDIZgBsM4M8TL0=
X-Received: by 2002:a92:b508:: with SMTP id f8mr24974924ile.68.1596129954573;
 Thu, 30 Jul 2020 10:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200730171529.22582-1-fw@strlen.de> <20200730171529.22582-2-fw@strlen.de>
In-Reply-To: <20200730171529.22582-2-fw@strlen.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Jul 2020 10:25:43 -0700
Message-ID: <CANn89i+EqkFQx60MWyHkfXd41gpyMiuBBe3YYnyZ2eXCm_DbhQ@mail.gmail.com>
Subject: Re: [PATCH net-next 01/10] tcp: remove cookie_ts bit from request_sock
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        mathew.j.martineau@linux.intel.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 10:15 AM Florian Westphal <fw@strlen.de> wrote:
>
> No need for this anymore; nowadays output function has a 'synack_type'
> argument that tells us when the syn/ack is emitted via syncookies.
>
> The request already tells us when timestamps are supported, so check
> both to detect special timestamp for tcp option encoding is needed.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  drivers/crypto/chelsio/chtls/chtls_cm.c | 1 -
>  include/net/request_sock.h              | 3 +--
>  net/ipv4/tcp_input.c                    | 2 --
>  net/ipv4/tcp_output.c                   | 2 +-
>  4 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
> index f924c335a195..030f20148007 100644
> --- a/drivers/crypto/chelsio/chtls/chtls_cm.c
> +++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
> @@ -1348,7 +1348,6 @@ static void chtls_pass_accept_request(struct sock *sk,
>
>         oreq->rsk_rcv_wnd = 0;
>         oreq->rsk_window_clamp = 0;
> -       oreq->cookie_ts = 0;
>         oreq->mss = 0;
>         oreq->ts_recent = 0;
>
> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> index cf8b33213bbc..2f717d4dafc5 100644
> --- a/include/net/request_sock.h
> +++ b/include/net/request_sock.h
> @@ -54,8 +54,7 @@ struct request_sock {
>         struct request_sock             *dl_next;
>         u16                             mss;
>         u8                              num_retrans; /* number of retransmits */
> -       u8                              cookie_ts:1; /* syncookie: encode tcpopts in timestamp */
> -       u8                              num_timeout:7; /* number of timeouts */
> +       u8                              num_timeout; /* number of timeouts */
>         u32                             ts_recent;
>         struct timer_list               rsk_timer;
>         const struct request_sock_ops   *rsk_ops;
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index a018bafd7bdf..fcca58476678 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6519,7 +6519,6 @@ static void tcp_openreq_init(struct request_sock *req,
>         struct inet_request_sock *ireq = inet_rsk(req);
>
>         req->rsk_rcv_wnd = 0;           /* So that tcp_send_synack() knows! */
> -       req->cookie_ts = 0;
>         tcp_rsk(req)->rcv_isn = TCP_SKB_CB(skb)->seq;
>         tcp_rsk(req)->rcv_nxt = TCP_SKB_CB(skb)->seq + 1;
>         tcp_rsk(req)->snt_synack = 0;
> @@ -6739,7 +6738,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
>
>         if (want_cookie) {
>                 isn = cookie_init_sequence(af_ops, sk, skb, &req->mss);
> -               req->cookie_ts = tmp_opt.tstamp_ok;
>                 if (!tmp_opt.tstamp_ok)
>                         inet_rsk(req)->ecn_ok = 0;
>         }
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index d8f16f6a9b02..bd0e5a7cd072 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3393,7 +3393,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
>         memset(&opts, 0, sizeof(opts));
>         now = tcp_clock_ns();
>  #ifdef CONFIG_SYN_COOKIES
> -       if (unlikely(req->cookie_ts))
> +       if (unlikely(synack_type == TCP_SYNACK_COOKIE && inet_rsk(req)->tstamp_ok))

     ireq->tstamp_ok


>                 skb->skb_mstamp_ns = cookie_init_timestamp(req, now);
>         else
>  #endif
> --
> 2.26.2
>
