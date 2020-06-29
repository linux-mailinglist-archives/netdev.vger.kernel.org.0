Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE53920E17E
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgF2U41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731284AbgF2U4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:56:24 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EA5C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:56:23 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 145so14135336qke.9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WFTfwahjL6M/BMfdmoNAC4ZI9pYs95htNH+KmmPwP78=;
        b=GlGQ5Xw0sRdaKgZsmx12FDYNvtMcdDTQzMo9AwE7Pa0OFBOjmE9ErZo05c04ASqAyd
         IVpIpHdiDmkc69Ga4qLfZR74Q8ZqWAfWCby5LJUtHTaf9j+UD/2lwliiyAp4zMBnosTJ
         o+FRHnLkZshTaxC6stt3xpV2gwvUd5eBBPj2bpWQ929Xicig4/E9hoHY5cPddYYQaQJT
         Ttjax0Shodn5+uHUPygcpcPHD7SKa1aCE8+fK3nGxeSasforXKowZbkktSMiHN1erUtR
         qp80OwtB3yu5Z946ni3Ap7DyFIg1Gc1TXZhuM/8l7MhJH0EiVHPclDR1YBf2jhUeO2/g
         l+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WFTfwahjL6M/BMfdmoNAC4ZI9pYs95htNH+KmmPwP78=;
        b=P3Hpg4lmbQuRDEgXLULqp606wqfwWcxTdf1gbWdRW80HOocTpa2Vrpvp27hWBW0zS1
         UME/sGWk3Gd1bhq6eUYdYkamMP6sH3Yz3PdIIC2C8pv7F1VI5LDnPbfoQ307CBhxxTMe
         ly6iPhsxbW5Z3tU4AxSXWXdFPVfindghLfH7AXU1/C3jm8rA8f0WxaFblJ667GKd//oY
         3WpDjBZEPUMdcXzh/Mp/71e786O+nRSUSTJK1Pia4OEqBRsICTGtr20HQJKEBKHZD/MI
         0VnlN22MIZn5wWohmU/qrvI6ncMUrGetSnBSxyVqsvAoG2iMjxUFhLku4Ass5+7ukJ+g
         qHLQ==
X-Gm-Message-State: AOAM532XD3ayGIoKnbdUQEWuSS2RSLGvLl+t+OU5FSjtOQdN2NXbipyY
        5rTCkpqX2ydEtd7RQkpWZJlKQakF
X-Google-Smtp-Source: ABdhPJzOri5f3xBBRRiczzwWXZc7yxGigihkZbZm0/Awd9kB+ku47f/5wUiy+2Vaos9nZus1TLQ1Ig==
X-Received: by 2002:a37:a20d:: with SMTP id l13mr17508147qke.296.1593464182041;
        Mon, 29 Jun 2020 13:56:22 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id d135sm945039qkg.117.2020.06.29.13.56.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 13:56:21 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id k18so9005637ybm.13
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:56:21 -0700 (PDT)
X-Received: by 2002:a25:cf82:: with SMTP id f124mr29287919ybg.441.1593464180352;
 Mon, 29 Jun 2020 13:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com> <CALx6S37-efe081ZF5G6_rc+48axkvGRR3CN4j7khuDhrmyJvMA@mail.gmail.com>
In-Reply-To: <CALx6S37-efe081ZF5G6_rc+48axkvGRR3CN4j7khuDhrmyJvMA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Jun 2020 16:55:42 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdd7BN-DHud5ZpyYce1r9dXvaGq-T2eXABhF1YL5u4h5Q@mail.gmail.com>
Message-ID: <CA+FuTSdd7BN-DHud5ZpyYce1r9dXvaGq-T2eXABhF1YL5u4h5Q@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Tom Herbert <tom@herbertland.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 4:34 PM Tom Herbert <tom@herbertland.com> wrote:
>
> On Mon, Jun 29, 2020 at 12:23 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > From: Willem de Bruijn <willemb@google.com>
> >
> > ICMP messages may include an extension structure after the original
> > datagram. RFC 4884 standardized this behavior.
> >
> > It introduces an explicit original datagram length field in the ICMP
> > header to delineate the original datagram from the extension struct.
> >
> > Return this field when reading an ICMP error from the error queue.
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
> >                                 mc_all:1,
> >                                 nodefrag:1;
> >         __u8                    bind_address_no_port:1,
> > +                               recverr_rfc4884:1,
> >                                 defer_connect:1; /* Indicates that fastopen_connect is set
> >                                                   * and cookie exists so we defer connect
> >                                                   * until first data frame is written
> > diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> > index 8533bf07450f..3d0d8231dc19 100644
> > --- a/include/uapi/linux/in.h
> > +++ b/include/uapi/linux/in.h
> > @@ -123,6 +123,7 @@ struct in_addr {
> >  #define IP_CHECKSUM    23
> >  #define IP_BIND_ADDRESS_NO_PORT        24
> >  #define IP_RECVFRAGSIZE        25
> > +#define IP_RECVERR_RFC4884     26
> >
> >  /* IP_MTU_DISCOVER values */
> >  #define IP_PMTUDISC_DONT               0       /* Never send DF frames */
> > diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> > index 84ec3703c909..525140e3947c 100644
> > --- a/net/ipv4/ip_sockglue.c
> > +++ b/net/ipv4/ip_sockglue.c
> > @@ -398,6 +398,9 @@ void ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
> >         if (!skb)
> >                 return;
> >
> > +       if (inet_sk(sk)->recverr_rfc4884)
> > +               info = ntohl(icmp_hdr(skb)->un.gateway);
> > +
> Willem,
>
> Doesn't this assume that all received ICMP errors received on the
> socket use the extended RFC4884 format once the option is set on the
> socket?
>
> I think what we might need to do this properly is to switch on the
> ICMP Type/Code to determine if the format is RFC4884. If it is then,
> we can figure out where the appropriate info for the ICMP error is.
> Good example of this is draft-ietf-6man-icmp-limits-08 currently on
> the RFC editor queue. A code for destination unreachable is added for
> "aggregate header limit exceeded". An RFC4884 format is used to
> contain an ICMP extension that includes a pointer to the offending
> byte (unlike parameter problem, destination unreachable doesn't have
> Pointer in ICMP header).  So in this case it makes sense that the
> kernel returns the Pointer in extended ICMP as the info.

This implementation matches the existing behavior of ICMPv6.

You're right that the RFC 4884 length field is relevant only for a
selection of ICMP types. For other types most of the bits are
reserved. I don't see any issue with exposing those. Anything
more fine grained will have to be extended for each
additional feature such as the one you mention. I prefer to just make
this information available once and for all. It really helped that it
was already available on v6, for instance.




> Tom
>
>
> >         serr = SKB_EXT_ERR(skb);
> >         serr->ee.ee_errno = err;
> >         serr->ee.ee_origin = SO_EE_ORIGIN_ICMP;
> > @@ -755,6 +758,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
> >         case IP_RECVORIGDSTADDR:
> >         case IP_CHECKSUM:
> >         case IP_RECVFRAGSIZE:
> > +       case IP_RECVERR_RFC4884:
> >                 if (optlen >= sizeof(int)) {
> >                         if (get_user(val, (int __user *) optval))
> >                                 return -EFAULT;
> > @@ -914,6 +918,11 @@ static int do_ip_setsockopt(struct sock *sk, int level,
> >                 if (!val)
> >                         skb_queue_purge(&sk->sk_error_queue);
> >                 break;
> > +       case IP_RECVERR_RFC4884:
> > +               if (val != 0 && val != 1)
> > +                       goto e_inval;
> > +               inet->recverr_rfc4884 = val;
> > +               break;
> >         case IP_MULTICAST_TTL:
> >                 if (sk->sk_type == SOCK_STREAM)
> >                         goto e_inval;
> > @@ -1588,6 +1597,9 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
> >         case IP_RECVERR:
> >                 val = inet->recverr;
> >                 break;
> > +       case IP_RECVERR_RFC4884:
> > +               val = inet->recverr_rfc4884;
> > +               break;
> >         case IP_MULTICAST_TTL:
> >                 val = inet->mc_ttl;
> >                 break;
> > --
> > 2.27.0.212.ge8ba1cc988-goog
> >
