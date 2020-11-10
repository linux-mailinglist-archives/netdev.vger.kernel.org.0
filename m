Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F742ADEBF
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbgKJSul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731309AbgKJSuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 13:50:37 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CF8C0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 10:50:37 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id m16so7660705vsl.8
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 10:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z1MyxP0Km6Zy1ESXM9YxE2rbmVw2X+wkPKihjiRYITY=;
        b=Noi9TFlQ3rEhpispl1llPzVuEcluCRBDohbXmSFCunpTcOkfFoRfz9/vA8AAcuS3Fz
         AjL7dgCjFdIkkfMVeQPZUNC/tUTGvskOMTLLeUdDIZmcIvISiqEsy8gZP7TIQHU6TkCA
         0Dp6KdVfP+InfjZV9x1fEFV058NzO5XUHCa6uuCbOyUxbUU99CWfeULR4yVTzJ7f/fgC
         35sHKxFbvu+DGcRf5eefwLMfRRYzetHwfYBpXjuNtSsJsGRO4xTDpcQox2LyUUIR1Z43
         SVuc3ybroJhRUEoK0Iuh/tydvu+R3WSy6H/aCgdt7eeSRs5S5NFPR+b4J4pIHqX36SX/
         D2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z1MyxP0Km6Zy1ESXM9YxE2rbmVw2X+wkPKihjiRYITY=;
        b=W6jLNeFmL8R2IvmOCH/7pJQVVV0pfw658wJfIr577H4ZhGsg79p0AKa1OkbAy76j8/
         LPFRJBIeEzv0VcumqmQYyvVKq+QhI0FtxqcRLmZx1DbC+rOBncvEg3OdK6hPmQ0N1nuU
         8z3RDU+6HqGZbKAT95GihlMU0YGTHr4chq77NOYukuwnLjNTcbItsAkMEV/NHXyVXJWM
         GJmvuRuFVq5b/bNqGB4tbVoNoAZLzs5Juaq+W+eJjVKIasYyp4cTG6ph9D3AVtG28AxH
         WUru1EXEygiUETKwADcjR6End3voVkgGiTRBPAHAgJnXexHk37jClgKMPdjJxqDd9u5P
         Pd4g==
X-Gm-Message-State: AOAM5303Pjwc6uX8LknD6FTRAqT4rgyR97PRTUTlrpISdFUG3dhnQbiL
        Rp9zGKfhehwxl4Km4/Qf18qm8sFcqEA=
X-Google-Smtp-Source: ABdhPJw0uzEcOdgcb9RaZO/RoTcCY+LXJSj0sGSggMKwZt0/Xs2xYAVfg25Grqgjs/9jNH4Q4w7zUw==
X-Received: by 2002:a67:fc4f:: with SMTP id p15mr13395839vsq.3.1605034235983;
        Tue, 10 Nov 2020 10:50:35 -0800 (PST)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id a8sm1637912vsp.4.2020.11.10.10.50.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 10:50:35 -0800 (PST)
Received: by mail-vs1-f41.google.com with SMTP id b67so1135246vsc.3
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 10:50:34 -0800 (PST)
X-Received: by 2002:a67:ce0e:: with SMTP id s14mr12918161vsl.13.1605034233710;
 Tue, 10 Nov 2020 10:50:33 -0800 (PST)
MIME-Version: 1.0
References: <bEm19mEHLokLGc5HrEiEKEUgpZfmDYPoFtoLAAEnIUE@cp3-web-033.plabs.ch>
In-Reply-To: <bEm19mEHLokLGc5HrEiEKEUgpZfmDYPoFtoLAAEnIUE@cp3-web-033.plabs.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 10 Nov 2020 13:49:56 -0500
X-Gmail-Original-Message-ID: <CA+FuTScriNKLu=q+xmBGjtBB06SbErZK26M+FPiJBRN-c8gVLw@mail.gmail.com>
Message-ID: <CA+FuTScriNKLu=q+xmBGjtBB06SbErZK26M+FPiJBRN-c8gVLw@mail.gmail.com>
Subject: Re: [PATCH v4 net] net: udp: fix Fast/frag0 UDP GRO
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 7:29 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> From: Alexander Lobakin <alobakin@pm.me>
> Date: Tue, 10 Nov 2020 00:17:18 +0000
>
> > While testing UDP GSO fraglists forwarding through driver that uses
> > Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
> > iperf packets:
> >
> > [ ID] Interval           Transfer     Bitrate         Jitter
> > [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
> >
> > Simple switch to napi_gro_receive() or any other method without frag0
> > shortcut completely resolved them.
> >
> > I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
> > callback. While it's probably OK for non-frag0 paths (when all
> > headers or even the entire frame are already in skb->data), this
> > inline points to junk when using Fast GRO (napi_gro_frags() or
> > napi_gro_receive() with only Ethernet header in skb->data and all
> > the rest in shinfo->frags) and breaks GRO packet compilation and
> > the packet flow itself.
> > To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
> > are typically used. UDP even has an inline helper that makes use of
> > them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
> > to get rid of the out-of-order delivers.
> >
> > Present since the introduction of plain UDP GRO in 5.0-rc1.
> >
> > Since v3 [1]:
> >  - restore the original {,__}udp{4,6}_lib_lookup_skb() and use
> >    private versions of them inside GRO code (Willem).
>
> Note: this doesn't cover a support for nested tunnels as it's out of
> the subject and requires more invasive changes. It will be handled
> separately in net-next series.

Thanks for looking into that.

In that case, should the p->data + off change be deferred to that,
too? It adds some risk unrelated to the bug fix.

> > Since v2 [2]:
> >  - dropped redundant check introduced in v2 as it's performed right
> >    before (thanks to Eric);
> >  - udp_hdr() switched to data + off for skbs from list (also Eric);
> >  - fixed possible malfunction of {,__}udp{4,6}_lib_lookup_skb() with
> >    Fast/frag0 due to ip{,v6}_hdr() usage (Willem).
> >
> > Since v1 [3]:
> >  - added a NULL pointer check for "uh" as suggested by Willem.
> >
> > [1] https://lore.kernel.org/netdev/MgZce9htmEtCtHg7pmWxXXfdhmQ6AHrnltXC41zOoo@cp7-web-042.plabs.ch
> > [2] https://lore.kernel.org/netdev/0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch
> > [3] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYvJI@cp4-web-034.plabs.ch
> >
> > Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  net/ipv4/udp_offload.c | 23 +++++++++++++++++++----
> >  net/ipv6/udp_offload.c | 14 +++++++++++++-
> >  2 files changed, 32 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index e67a66fbf27b..6064efe17cdb 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -366,11 +366,11 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
> >  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
> >                                              struct sk_buff *skb)
> >  {
> > -     struct udphdr *uh = udp_hdr(skb);
> > +     struct udphdr *uh = udp_gro_udphdr(skb);
> >       struct sk_buff *pp = NULL;
> >       struct udphdr *uh2;
> >       struct sk_buff *p;
> > -     unsigned int ulen;
> > +     u32 ulen, off;

a specific reason for changing type here?

> >       int ret = 0;
> >
> >       /* requires non zero csum, for symmetry with GSO */
> > @@ -385,6 +385,9 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
> >               NAPI_GRO_CB(skb)->flush = 1;
> >               return NULL;
> >       }
> > +
> > +     off = skb_gro_offset(skb);
> > +
> >       /* pull encapsulating udp header */
> >       skb_gro_pull(skb, sizeof(struct udphdr));
> >
> > @@ -392,7 +395,7 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
> >               if (!NAPI_GRO_CB(p)->same_flow)
> >                       continue;
> >
> > -             uh2 = udp_hdr(p);
> > +             uh2 = (void *)p->data + off;
> >
> >               /* Match ports only, as csum is always non zero */
> >               if ((*(u32 *)&uh->source != *(u32 *)&uh2->source)) {
> > @@ -500,6 +503,16 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> >  }
> >  EXPORT_SYMBOL(udp_gro_receive);
> >
> > +static struct sock *udp4_gro_lookup_skb(struct sk_buff *skb, __be16 sport,
> > +                                     __be16 dport)
> > +{
> > +     const struct iphdr *iph = skb_gro_network_header(skb);
> > +
> > +     return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
> > +                              iph->daddr, dport, inet_iif(skb),
> > +                              inet_sdif(skb), &udp_table, NULL);
> > +}
> > +
> >  INDIRECT_CALLABLE_SCOPE
> >  struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
> >  {
> > @@ -523,7 +536,9 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
> >  skip:
> >       NAPI_GRO_CB(skb)->is_ipv6 = 0;
> >       rcu_read_lock();
> > -     sk = static_branch_unlikely(&udp_encap_needed_key) ? udp4_lib_lookup_skb(skb, uh->source, uh->dest) : NULL;
> > +     sk = static_branch_unlikely(&udp_encap_needed_key) ?
> > +          udp4_gro_lookup_skb(skb, uh->source, uh->dest) :
> > +          NULL;

Does this indentation pass checkpatch?

Else, the line limit is no longer strict,a and this only shortens the
line, so a single line is fine.
