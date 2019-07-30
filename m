Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697E87AA5E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfG3N6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:58:41 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:36676 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbfG3N6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 09:58:41 -0400
Received: by mail-vs1-f67.google.com with SMTP id y16so43489586vsc.3;
        Tue, 30 Jul 2019 06:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2wlNZmUcgZRDidSciC7cz76BeVYG+FEQ83Cs9K4SOBA=;
        b=FVeBtdDES/SHbdFJWLmUniCv+rCwtOZUL4YRXj7VyvmKOq//WfcJeyfInMj9zBCDoD
         WMzpWqLNXzZgQsK4ns4FtLPl3HrWc+aoiDWa+gcN+Zw/rYsK6NZQm459qg+OPOagPjRv
         7oCvZAoRAGsxJ0YOP+VGZHhL3G3ERgjvzy4GAqIqpYnJpnugu78kXSURDYUgRC7olx7o
         nIv4HtmDcioFY16WmuHQXFmxswX2HFfh0WNWoI6x7nqosv74bfuGGY9ktCuXI7Hy5AaU
         rt8gzdpem/y9jtpgeH1T2Zv0zpwsTMhj5itHFjUJsIEW9c+DNuJFo6RpupZufSJK2S34
         +dwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2wlNZmUcgZRDidSciC7cz76BeVYG+FEQ83Cs9K4SOBA=;
        b=DuQyO0HW9UlY+9VTyQWPXdngdnVlH/Cz3SD1/eMRE5plg3qNIIwWRFGagKpvlTyxm5
         t4mADUI/S+KVnOr6NdGYv5Epj3OIsy8sR7pIcOPbAkYQKFZ4w3ezgYnhigUOoGBgyvqz
         +waP5CiN0BigofxZ32JNtOoMiTbd0/kdHRrXWDjjF5ceIhXKeaaIcH0o1c90xVSC17U4
         Ur1lnkvQWezaZWGAIkpSfS/CuTS7Cw5lvXuAmtWImlgulPb3uS+Tt1PpzGvEakO65jFQ
         7P24+g93EfCrtNzkxLUMcj5HhkDSIbu7LQmX7j6tmIMqFklV3Rr1SuEMKoHBA4P3d+sj
         i39A==
X-Gm-Message-State: APjAAAV8ojG4KgFpb+t5zTweX03+DY1KrAo8rU0hyjdIaWr5wGF82LWI
        BsOINsFeRTx+lreNT1B6fq37d7f8YR7Wgtz+YA==
X-Google-Smtp-Source: APXvYqyNweaqA9rqsZHNK6P/0G3KMoy4dWlSLU5p9XweSbuxi6+WsvoXQx+dz7RZqnixJysAG0iZf1LohCdH4A9+6ts=
X-Received: by 2002:a67:eb19:: with SMTP id a25mr71625097vso.109.1564495120210;
 Tue, 30 Jul 2019 06:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190730122534.30687-1-rdong.ge@gmail.com> <1dc87e69-628b-fd04-619a-8dbe5bdfa108@cumulusnetworks.com>
In-Reply-To: <1dc87e69-628b-fd04-619a-8dbe5bdfa108@cumulusnetworks.com>
From:   Rundong Ge <rdong.ge@gmail.com>
Date:   Tue, 30 Jul 2019 21:58:29 +0800
Message-ID: <CAN1Lvyr5UcBrNJ8RLMgjT77sDjic7aXNeRmRex=BvzB02He9aQ@mail.gmail.com>
Subject: Re: [PATCH] bridge:fragmented packets dropped by bridge
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes it is about the frag_size check in br_nf_ip_fragment(). As i said
without br_netfilter the packets forwarding is fine.
And I feel it is weird that br_nf_dev_queue_xmit() use out dev's mtu
to decide whether to do the fragmentation, but
then br_nf_ip_fragment() use bridge's mtu to do the actual fragmentation.

And in this case fragmented packets fit the out dev mtu but were
dropped, I think it is not right.

Nikolay Aleksandrov <nikolay@cumulusnetworks.com> =E4=BA=8E2019=E5=B9=B47=
=E6=9C=8830=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=888:41=E5=86=99=E9=
=81=93=EF=BC=9A
>
> On 30/07/2019 15:25, Rundong Ge wrote:
> > Given following setup:
> > -modprobe br_netfilter
> > -echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
> > -brctl addbr br0
> > -brctl addif br0 enp2s0
> > -brctl addif br0 enp3s0
> > -brctl addif br0 enp6s0
> > -ifconfig enp2s0 mtu 1300
> > -ifconfig enp3s0 mtu 1500
> > -ifconfig enp6s0 mtu 1500
> > -ifconfig br0 up
> >
> >                  multi-port
> > mtu1500 - mtu1500|bridge|1500 - mtu1500
> >   A                  |            B
> >                    mtu1300
> >
> > With netfilter defragmentation/conntrack enabled, fragmented
> > packets from A will be defragmented in prerouting, and refragmented
> > at postrouting.
> > But in this scenario the bridge found the frag_max_size(1500) is
> > larger than the dst mtu stored in the fake_rtable whitch is
> > always equal to the bridge's mtu 1300, then packets will be dopped.
> >
> > This modifies ip_skb_dst_mtu to use the out dev's mtu instead
> > of bridge's mtu in bridge refragment.
> >
> > Signed-off-by: Rundong Ge <rdong.ge@gmail.com>
> > ---
> >  include/net/ip.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/include/net/ip.h b/include/net/ip.h
> > index 29d89de..0512de3 100644
> > --- a/include/net/ip.h
> > +++ b/include/net/ip.h
> > @@ -450,6 +450,8 @@ static inline unsigned int ip_dst_mtu_maybe_forward=
(const struct dst_entry *dst,
> >  static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
> >                                         const struct sk_buff *skb)
> >  {
> > +     if ((skb_dst(skb)->flags & DST_FAKE_RTABLE) && skb->dev)
> > +             return min(skb->dev->mtu, IP_MAX_MTU);
> >       if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
> >               bool forwarding =3D IPCB(skb)->flags & IPSKB_FORWARDED;
> >
> >
>
> I don't think this is correct, there's a reason why the bridge chooses th=
e smallest
> possible MTU out of its members and this is simply a hack to circumvent i=
t.
> If you really like to do so just set the bridge MTU manually, we've added=
 support
> so it won't change automatically to the smallest, but then how do you pas=
s packets
> 1500 -> 1300 in this setup ?
>
> You're talking about the frag_size check in br_nf_ip_fragment(), right ?
>
