Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C97D20EA3D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgF3Aao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbgF3Aao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:30:44 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A20C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:30:43 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lx13so34592ejb.4
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2onw63quNWPlTBpmIY2TaMnra+SdcFkbBSjGIq93Mwk=;
        b=AC62lrwtBqd3cpytRyb8eoFlY9y6PNwH61TDcwpNAZcN9bbJhCsn54Yj/Apiej8tdl
         8rKZ86m3bogbQJrG/tdY/HkRHOZYbJ6Cp6M6W4DLvfF+ArAt28NVPWjDhlA7tZa30SA2
         Lcm4r3RQ/Xg0yCRx4MIeG79kFofrxQzsmo4nppv5mGgGoymhxUxrhFwZiJhJLEQwvQVy
         SpPbCH/rNFsDHJJ/3YJvwHRPlw5gJi4+kZwBHfMm9EfSWYrA165N53R1vXO67wMYRoZ3
         yyaCOf6m9It2QSAlE51px/DEBkKc2r3bZG2BWOX5ZeG5CVMibghgssm1JnAPqAHoc5De
         M07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2onw63quNWPlTBpmIY2TaMnra+SdcFkbBSjGIq93Mwk=;
        b=NHMT8FooTs2zOpX3ChvUZ0AAuobRUVhrpAlRob/D3Zx5qoC09nPxtB7PA6Nk8ekwSK
         V0DFH3UFxavv/MJZmCRIv9lv8PSUUofloAiGBKJ0qM1xUBItG+uGd2BOYQD6FHYbTy2j
         JVsuzjWzhy50srxWvhJgeMOKw3vBQpPk0Bw9XNcbnSbCPu2przMhHnzktOEvbtv4QCLt
         FPDqVC8Au5a0izNWktYeQTkx0GcuUnLidG3gUXIh+sRU3yRGM6cj3yeybWqGsKV25elB
         Fm7a3I5y2+5Pua3dKEoPqIUgNh+IPTD6P4gOxTDBH49s/MffoBqTS9JndlkMifwuQKQ6
         BvSg==
X-Gm-Message-State: AOAM5319VawfH6S4d+PS0vSF4m/gOyUX33f+Kxmpm9RWP5FCFUdEEaLR
        wXzhG4/V+fAiXpRPPBpQkYb/tGSr2ZoYmj4SLRlmog==
X-Google-Smtp-Source: ABdhPJxn73Wtx/pB3BbihN/bJyDvfK2e6NbKhwUigWPgIHR6hVFNjqQNDd8BViqIfUA/0wMyHwzuu6fvN/HBMIBmAaQ=
X-Received: by 2002:a17:907:6fc:: with SMTP id yh28mr16010692ejb.267.1593477042058;
 Mon, 29 Jun 2020 17:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com> <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com>
In-Reply-To: <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Mon, 29 Jun 2020 17:30:31 -0700
Message-ID: <CALx6S34EFEEOiWh49LNUB1g=Kh5ctVzj8C_Zmm3ZV-bc85tUzw@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 2:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 6/29/20 9:57 AM, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > ICMP messages may include an extension structure after the original
> > datagram. RFC 4884 standardized this behavior.
> >
> > It introduces an explicit original datagram length field in the ICMP
> > header to delineate the original datagram from the extension struct.
> >
> > Return this field when reading an ICMP error from the error queue.
>
> RFC mentions a 'length' field of 8 bits, your patch chose to export the whole
> second word of icmp header.
>
> Why is this field mapped to a prior one (icmp_hdr(skb)->un.gateway) ?
>
> Should we add an element in the union to make this a little bit more explicit/readable ?
>
Yes, that makes sense. We should also define the structure for the
ICMP extension header, the structure for the ICMP Extension Objects,
and then each particular object can define its own structure. Also, a
function to get a pointer to the extension header (at offset 8*length
from the start of the packet data). Sorry, Willem, this is probably
more than you bargained for in posting the patch ;-)

Tom


> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> index 5589eeb791ca580bb182e1dc38c05eab1c75adb9..427ed5a6765316a4c1e2fa06f3b6618447c01564 100644
> --- a/include/uapi/linux/icmp.h
> +++ b/include/uapi/linux/icmp.h
> @@ -76,6 +76,7 @@ struct icmphdr {
>                 __be16  sequence;
>         } echo;
>         __be32  gateway;
> +       __be32  second_word; /* RFC 4884 4.[123] : <unused:8>,<length:8>,<mtu:16> */
>         struct {
>                 __be16  __unused;
>                 __be16  mtu;
>
>
>
> >
> > ICMPv6 by default already returns the entire 32-bit part of the header
> > that includes this field by default. For consistency, do the exact
> > same for ICMP. So far it only returns mtu on ICMP_FRAG_NEEDED and gw
> > on ICMP_PARAMETERPROB.
> >
> > For backwards compatibility, make this optional, set by setsockopt
> > SOL_IP/IP_RECVERR_RFC4884. For API documentation and feature test, see
> > https://github.com/wdebruij/kerneltools/blob/master/tests/recv_icmp.c
> >
> > Alternative implementation to reading from the skb in ip_icmp_error
> > is to pass the field from icmp_unreach, again analogous to ICMPv6. But
> > this would require changes to every $proto_err() callback, which for
> > ICMP_FRAG_NEEDED pass the u32 info arg to a pmtu update function.
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  include/net/inet_sock.h |  1 +
> >  include/uapi/linux/in.h |  1 +
> >  net/ipv4/ip_sockglue.c  | 12 ++++++++++++
> >  3 files changed, 14 insertions(+)
> >
> > diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> > index a7ce00af6c44..a3702d1d4875 100644
> > --- a/include/net/inet_sock.h
> > +++ b/include/net/inet_sock.h
> > @@ -225,6 +225,7 @@ struct inet_sock {
> >                               mc_all:1,
> >                               nodefrag:1;
> >       __u8                    bind_address_no_port:1,
> > +                             recverr_rfc4884:1,
> >                               defer_connect:1; /* Indicates that fastopen_connect is set
> >                                                 * and cookie exists so we defer connect
> >                                                 * until first data frame is written
> > diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> > index 8533bf07450f..3d0d8231dc19 100644
> > --- a/include/uapi/linux/in.h
> > +++ b/include/uapi/linux/in.h
> > @@ -123,6 +123,7 @@ struct in_addr {
> >  #define IP_CHECKSUM  23
> >  #define IP_BIND_ADDRESS_NO_PORT      24
> >  #define IP_RECVFRAGSIZE      25
> > +#define IP_RECVERR_RFC4884   26
> >
> >  /* IP_MTU_DISCOVER values */
> >  #define IP_PMTUDISC_DONT             0       /* Never send DF frames */
> > diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> > index 84ec3703c909..525140e3947c 100644
> > --- a/net/ipv4/ip_sockglue.c
> > +++ b/net/ipv4/ip_sockglue.c
> > @@ -398,6 +398,9 @@ void ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
> >       if (!skb)
> >               return;
> >
> > +     if (inet_sk(sk)->recverr_rfc4884)
> > +             info = ntohl(icmp_hdr(skb)->un.gateway);
>
> ntohl(icmp_hdr(skb)->un.second_word);
>
> > +
> >       serr = SKB_EXT_ERR(skb);
> >       serr->ee.ee_errno = err;
> >       serr->ee.ee_origin = SO_EE_ORIGIN_ICMP;
> > @@ -755,6 +758,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
> >       case IP_RECVORIGDSTADDR:
> >       case IP_CHECKSUM:
> >       case IP_RECVFRAGSIZE:
> > +     case IP_RECVERR_RFC4884:
> >               if (optlen >= sizeof(int)) {
> >                       if (get_user(val, (int __user *) optval))
> >                               return -EFAULT;
> > @@ -914,6 +918,11 @@ static int do_ip_setsockopt(struct sock *sk, int level,
> >               if (!val)
> >                       skb_queue_purge(&sk->sk_error_queue);
> >               break;
> > +     case IP_RECVERR_RFC4884:
> > +             if (val != 0 && val != 1)
> > +                     goto e_inval;
> > +             inet->recverr_rfc4884 = val;
> > +             break;
> >       case IP_MULTICAST_TTL:
> >               if (sk->sk_type == SOCK_STREAM)
> >                       goto e_inval;
> > @@ -1588,6 +1597,9 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
> >       case IP_RECVERR:
> >               val = inet->recverr;
> >               break;
> > +     case IP_RECVERR_RFC4884:
> > +             val = inet->recverr_rfc4884;
> > +             break;
> >       case IP_MULTICAST_TTL:
> >               val = inet->mc_ttl;
> >               break;
> >
