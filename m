Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE67020E507
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390815AbgF2Vbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390997AbgF2Vbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:31:36 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13C1C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:31:36 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id r22so16681892qke.13
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nWE+TNE6F1yNQQeNoGPvqASJQY9T5zVirRn69LubCcQ=;
        b=g0w/Rs3Lx/oMweDy+BP/tBfLZQJGCLiqT790cG+SBfjb7DISQOPiy4TW6AcNdKHpU7
         PCC3ZbxAlSPGV0ubEaEDTJp0d7pXyLMOIvwGeRFoxkmCvDCbHfjVnxOsNMAlytF3Wk93
         tQYZsTJWZqktSizeUNU5GscGWcoeVkw7hf827T5snBCckXMmybj49JhFCai8GXX5gtwQ
         JFHgUXlC50Q5RUZPxMIhYFzMNkgBoxoTSmtQf2iPgH4ZT9JtuzcvYD3ksV6Z7krXpSG2
         KBW6RAkO1anTj83DOI0bMZs2jnxcECM/B4j7QjmMxDvWNjaVw90/MQ8NZm/u5GPyM1KP
         esSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nWE+TNE6F1yNQQeNoGPvqASJQY9T5zVirRn69LubCcQ=;
        b=DZbjYtbz8nrNjSw/dv/rLp3y5os1lgQhBFD1Ne6XcNIZCvcCQ55C4V1vq4E8v/em4d
         RRpc7stJYV+hvWkqGJo2HbxwNMosdxiDr+xH0z0wVeU09u2QR+r9kLvmcikEBFlxmVRf
         CZYd+c5k87Hn39+J00EgHBhGMDFx0Hc4WxWUxiz8eipelbLDLuKSowBxMFr1TIrgmzVE
         siNVyKANYLUsPP53ZXOPCX4lOXJw2HVQza85Wwsxqf3MMuWx0qSeO5e0dXrICcaHT1Y9
         tmu8HMn5cMOq/hLE3ddzE8BY5xmX3npTIAcvBRAxpGb4+JqGpWm9ClSZja235FJA7H0/
         jA+Q==
X-Gm-Message-State: AOAM532dSENIbLrSeCrSQoA+6oi1uljvuoxq2jHQGK+APJBnSS9DwBd/
        zqDKhsyVfclDKYs8KgP53FgRHcn0
X-Google-Smtp-Source: ABdhPJz0c7l6dGhN09l66jw8c9pcUXP+3Ia6WNqF/bu7OxhL896bCtHkSAwbBv+Op+WB2BiXHfYm6w==
X-Received: by 2002:ae9:ef04:: with SMTP id d4mr16812037qkg.41.1593466294667;
        Mon, 29 Jun 2020 14:31:34 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id g1sm1354505qko.70.2020.06.29.14.31.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 14:31:33 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id 187so9079018ybq.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:31:33 -0700 (PDT)
X-Received: by 2002:a25:df81:: with SMTP id w123mr26901318ybg.428.1593466293047;
 Mon, 29 Jun 2020 14:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com> <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com>
In-Reply-To: <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Jun 2020 17:30:55 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
Message-ID: <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 5:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
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

Okay. How about a variant of the existing struct frag?

@@ -80,6 +80,11 @@ struct icmphdr {
                __be16  __unused;
                __be16  mtu;
        } frag;
+       struct {
+               __u8    __unused;
+               __u8    length;
+               __be16  mtu;
+       } rfc_4884;
        __u8    reserved[4];
   } un;

 };

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
