Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB2820DF52
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389377AbgF2Ueb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731023AbgF2Ue3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:34:29 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63813C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:34:28 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e15so14171955edr.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UA2O9Gu26uLqdkjpfyX7N+neoscd68qxFb/U5lbfXJE=;
        b=Glb1lvG+wTQRg+L3DopPOFkMSzJtwhvyEQFXRX/Khu/crX751H7WHPChZQZzmEaqw9
         Af6oHvZp7kj5byIABZQBbU/kaZCAcqUq5tsNOV30qLpf/qOAyZZg402mm94p+vUVO21t
         aapve0JhMaMEdNPqe3kz9NC4slaZwiuTBC75330BS6MZYyy2L7KMix48AY8fVY3pNXtk
         iWR4Pg9r/mKaiwwhngnV04JI/TvluwE6LLyDkZvflXlTKJ7OK7MBbu7x74XjMCvy6X4j
         bxEL/xykn8wwJgp+wjGASohexewcDjwzvhffZzYzJStB1xhcM8U7A8UhtcBgSNcw09c1
         dhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UA2O9Gu26uLqdkjpfyX7N+neoscd68qxFb/U5lbfXJE=;
        b=aSlibXLRA5EdcOuvSVIQBp3v0r2ywJdRRn/eyEoQdKYUiTIBOOb1e/Xl0q1PElxyWf
         L+nurCmHyBT1a19oO7fp2RlmR3wYIDIig2bOddiZOX9fuCQcm6T6kWOF/i2GXK7fefpK
         xNqrsJCMPkqm7hrvQST8TqCSHt+B0Vz3U1bGT9LUrsMXvt/1T4MHpzxSqgnry1w9muat
         FOMlHro7Pczhl/E5OA/3LPQVXKyyLmx4jYpgzr3lR0p+nt8OvsXDLd8fZVu18TRF83gb
         kNlePf94E9Gfr6mqr4a66a7yzES2JaaRenfVYu2mgrToTabOhKPzHuT0XU72qXnoM6zk
         1TiA==
X-Gm-Message-State: AOAM531jI5YMx7AxfqMxiLHJB4BSCyDYDaBDstpk7Uo/+T5F9bdOsCEE
        H/AZXjrG5ocvaz/RkTNtrZZojQxclLOGzwI8i1OuEA==
X-Google-Smtp-Source: ABdhPJxPb+pEPUN8Oa1tJTO7HaAQLlp+dkkZqYuaodPKqCqgyuYt7MRHSEvvV6D1sgtUh6AMl7VfEOFBrGs+VlEnRjQ=
X-Received: by 2002:a50:934e:: with SMTP id n14mr19623218eda.88.1593462866885;
 Mon, 29 Jun 2020 13:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Mon, 29 Jun 2020 13:34:15 -0700
Message-ID: <CALx6S37-efe081ZF5G6_rc+48axkvGRR3CN4j7khuDhrmyJvMA@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 12:23 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> ICMP messages may include an extension structure after the original
> datagram. RFC 4884 standardized this behavior.
>
> It introduces an explicit original datagram length field in the ICMP
> header to delineate the original datagram from the extension struct.
>
> Return this field when reading an ICMP error from the error queue.
>
> ICMPv6 by default already returns the entire 32-bit part of the header
> that includes this field by default. For consistency, do the exact
> same for ICMP. So far it only returns mtu on ICMP_FRAG_NEEDED and gw
> on ICMP_PARAMETERPROB.
>
> For backwards compatibility, make this optional, set by setsockopt
> SOL_IP/IP_RECVERR_RFC4884. For API documentation and feature test, see
> https://github.com/wdebruij/kerneltools/blob/master/tests/recv_icmp.c
>
> Alternative implementation to reading from the skb in ip_icmp_error
> is to pass the field from icmp_unreach, again analogous to ICMPv6. But
> this would require changes to every $proto_err() callback, which for
> ICMP_FRAG_NEEDED pass the u32 info arg to a pmtu update function.
>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  include/net/inet_sock.h |  1 +
>  include/uapi/linux/in.h |  1 +
>  net/ipv4/ip_sockglue.c  | 12 ++++++++++++
>  3 files changed, 14 insertions(+)
>
> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> index a7ce00af6c44..a3702d1d4875 100644
> --- a/include/net/inet_sock.h
> +++ b/include/net/inet_sock.h
> @@ -225,6 +225,7 @@ struct inet_sock {
>                                 mc_all:1,
>                                 nodefrag:1;
>         __u8                    bind_address_no_port:1,
> +                               recverr_rfc4884:1,
>                                 defer_connect:1; /* Indicates that fastopen_connect is set
>                                                   * and cookie exists so we defer connect
>                                                   * until first data frame is written
> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> index 8533bf07450f..3d0d8231dc19 100644
> --- a/include/uapi/linux/in.h
> +++ b/include/uapi/linux/in.h
> @@ -123,6 +123,7 @@ struct in_addr {
>  #define IP_CHECKSUM    23
>  #define IP_BIND_ADDRESS_NO_PORT        24
>  #define IP_RECVFRAGSIZE        25
> +#define IP_RECVERR_RFC4884     26
>
>  /* IP_MTU_DISCOVER values */
>  #define IP_PMTUDISC_DONT               0       /* Never send DF frames */
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index 84ec3703c909..525140e3947c 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -398,6 +398,9 @@ void ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
>         if (!skb)
>                 return;
>
> +       if (inet_sk(sk)->recverr_rfc4884)
> +               info = ntohl(icmp_hdr(skb)->un.gateway);
> +
Willem,

Doesn't this assume that all received ICMP errors received on the
socket use the extended RFC4884 format once the option is set on the
socket?

I think what we might need to do this properly is to switch on the
ICMP Type/Code to determine if the format is RFC4884. If it is then,
we can figure out where the appropriate info for the ICMP error is.
Good example of this is draft-ietf-6man-icmp-limits-08 currently on
the RFC editor queue. A code for destination unreachable is added for
"aggregate header limit exceeded". An RFC4884 format is used to
contain an ICMP extension that includes a pointer to the offending
byte (unlike parameter problem, destination unreachable doesn't have
Pointer in ICMP header).  So in this case it makes sense that the
kernel returns the Pointer in extended ICMP as the info.

Tom


>         serr = SKB_EXT_ERR(skb);
>         serr->ee.ee_errno = err;
>         serr->ee.ee_origin = SO_EE_ORIGIN_ICMP;
> @@ -755,6 +758,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
>         case IP_RECVORIGDSTADDR:
>         case IP_CHECKSUM:
>         case IP_RECVFRAGSIZE:
> +       case IP_RECVERR_RFC4884:
>                 if (optlen >= sizeof(int)) {
>                         if (get_user(val, (int __user *) optval))
>                                 return -EFAULT;
> @@ -914,6 +918,11 @@ static int do_ip_setsockopt(struct sock *sk, int level,
>                 if (!val)
>                         skb_queue_purge(&sk->sk_error_queue);
>                 break;
> +       case IP_RECVERR_RFC4884:
> +               if (val != 0 && val != 1)
> +                       goto e_inval;
> +               inet->recverr_rfc4884 = val;
> +               break;
>         case IP_MULTICAST_TTL:
>                 if (sk->sk_type == SOCK_STREAM)
>                         goto e_inval;
> @@ -1588,6 +1597,9 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
>         case IP_RECVERR:
>                 val = inet->recverr;
>                 break;
> +       case IP_RECVERR_RFC4884:
> +               val = inet->recverr_rfc4884;
> +               break;
>         case IP_MULTICAST_TTL:
>                 val = inet->mc_ttl;
>                 break;
> --
> 2.27.0.212.ge8ba1cc988-goog
>
