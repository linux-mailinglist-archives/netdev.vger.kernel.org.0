Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754631E5258
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgE1Ard (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgE1Arc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 20:47:32 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C303C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 17:47:32 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id r10so2421756vsa.12
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 17:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wyCk+/pD1dl+DeKrDToIqqkALTxUwvpGnd2Ch1k0Z2Y=;
        b=ruG5bnR5cHx705uXEiARU5Wp2iRzlSn/QaI3HLW3I+Vu5xBe4wZJpxi1V4SbTUxagy
         3ydIfZUyszpMfSQiAFrfFG/jrfGkjNu8M5jlP4vL1hR1bbNChOpMefAXnSShhyPflG30
         uxJmoNHCn+egpQmuQcCtoyNhPl4dJwkezWJHR9UKjBYKTG02TlY/wqtS7s7UYtJXwllm
         rX0S69FBQZmVTB7wwag7c6QRcV7KGAtChup4h2zykERUvri+tiaOguYt0U1L5rNpZ9lW
         g2qoMxTdGmHAmqOIwtC92RPvFV9YgHHoDyrDaf+dB0Q5KA+l2YXuDcFDlyYCgyGUlii4
         vBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wyCk+/pD1dl+DeKrDToIqqkALTxUwvpGnd2Ch1k0Z2Y=;
        b=q8hNUtaKkn07MrJjCGLkxryWFSxpfIeQ0nqTvyTxDlWgsWve3437jKQkQePAlXtagP
         5oZn0TQvEgIvEJsNr660KO9l054J8Ol9SKN60/EWAD2TMLd5+gfLogkVQtRF0PQ7EKJi
         pjd9Z6YURCBRa2trLiK0NiexYlBGEpEU2oTrJNU+iDdNzPZ89IGnybbPYx2HP8FUycIK
         J0LJcc2HvY7H7Sb3fj8gQPWdbsZURRKUtap79EK3fhN7hMAD7jM42rueMA+fHvKj8Xvd
         JSMBJm3WFAV7ZqbgagIKKhGwiv9F7lEdVm6dFCFW//p37rMm44KFZNYUBY5gJH/Qjer5
         0Kvw==
X-Gm-Message-State: AOAM533z/XR6skPKbGDCAGC3RXMtvfjaRWxhfW3S0yPQ1BJnlV+YEoX5
        hIhDWACBnSTakewBl1TGRFyApkGxa4NW3OlPvGjJGA==
X-Google-Smtp-Source: ABdhPJxtKX3HL8K84I/BW16a0Na2XFIkMI5arLJbbzoxkOUhw0Dt2RBqfgv+02aS9aDKkwi+Kp2bQr6VfVeF1lfEWNI=
X-Received: by 2002:a05:6102:48:: with SMTP id k8mr337379vsp.134.1590626851388;
 Wed, 27 May 2020 17:47:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200528003458.90435-1-edumazet@google.com>
In-Reply-To: <20200528003458.90435-1-edumazet@google.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Wed, 27 May 2020 17:46:55 -0700
Message-ID: <CAK6E8=eSructRPz5+XtQU9anzrXCvedGiG7Sk8Vr=eR1c2kRLw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: ipv6: support RFC 6069 (TCP-LD)
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 5:35 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Make tcp_ld_RTO_revert() helper available to IPv6, and
> implement RFC 6069 :
>
> Quoting this RFC :
>
> 3. Connectivity Disruption Indication
>
>    For Internet Protocol version 6 (IPv6) [RFC2460], the counterpart of
>    the ICMP destination unreachable message of code 0 (net unreachable)
>    and of code 1 (host unreachable) is the ICMPv6 destination
>    unreachable message of code 0 (no route to destination) [RFC4443].
>    As with IPv4, a router should generate an ICMPv6 destination
>    unreachable message of code 0 in response to a packet that cannot be
>    delivered to its destination address because it lacks a matching
>    entry in its routing table.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
> ---
>  include/net/tcp.h   | 1 +
>  net/ipv4/tcp_ipv4.c | 3 ++-
>  net/ipv6/tcp_ipv6.c | 9 +++++++++
>  3 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index b681338a8320b55a32004b4d9d88c33ca28e8d29..66e4b8331850623515fade891a2e9feb79c49061 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -437,6 +437,7 @@ u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
>  void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb);
>  void tcp_v4_mtu_reduced(struct sock *sk);
>  void tcp_req_err(struct sock *sk, u32 seq, bool abort);
> +void tcp_ld_RTO_revert(struct sock *sk, u32 seq);
>  int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
>  struct sock *tcp_create_openreq_child(const struct sock *sk,
>                                       struct request_sock *req,
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 3a1e2becb1e8d1e0513e87bdfc0e1d5769ffc8e8..615de2d62d8b9b005a9a31b679d253fd2e5c12a8 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -404,7 +404,7 @@ void tcp_req_err(struct sock *sk, u32 seq, bool abort)
>  EXPORT_SYMBOL(tcp_req_err);
>
>  /* TCP-LD (RFC 6069) logic */
> -static void tcp_ld_RTO_revert(struct sock *sk, u32 seq)
> +void tcp_ld_RTO_revert(struct sock *sk, u32 seq)
>  {
>         struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
> @@ -441,6 +441,7 @@ static void tcp_ld_RTO_revert(struct sock *sk, u32 seq)
>                 tcp_retransmit_timer(sk);
>         }
>  }
> +EXPORT_SYMBOL(tcp_ld_RTO_revert);
>
>  /*
>   * This routine is called by the ICMP module when it gets some
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index c403e955fde1288fe781a3f5664de768642b0a7e..00f81817b378911aad3c905160218e964657e730 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -473,6 +473,15 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>                 } else
>                         sk->sk_err_soft = err;
>                 goto out;
> +       case TCP_LISTEN:
> +               break;
> +       default:
> +               /* check if this ICMP message allows revert of backoff.
> +                * (see RFC 6069)
> +                */
> +               if (!fastopen && type == ICMPV6_DEST_UNREACH &&
> +                   code == ICMPV6_NOROUTE)
> +                       tcp_ld_RTO_revert(sk, seq);
>         }
>
>         if (!sock_owned_by_user(sk) && np->recverr) {
> --
> 2.27.0.rc0.183.gde8f92d652-goog
>
