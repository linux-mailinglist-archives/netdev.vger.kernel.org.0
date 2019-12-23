Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B091298F0
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 17:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfLWQx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 11:53:27 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45141 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfLWQx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 11:53:26 -0500
Received: by mail-ed1-f66.google.com with SMTP id v28so15806974edw.12
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 08:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nz4jMxdehn1hXObQYPAUs8WzAXN+J02ZTVMfdZ7hqcs=;
        b=G8BFYIB1kd5L0+4P5aKPATMBElhd6H42qUL5X8tYV34CtDU18m2jIPOghgYcOTVOSj
         myWWe4yu1PFe8rfJ8i3j4qhmJA2rbl17Y7StNQq3GTIHMnCnaU8QebtjkvfYEzzknhBO
         E4hWxIhA1bCaxYrsTgv2XaDAQ6tvyWWQHrK4Pp1i7mMRhaPn6tTg/ESHqTxGgudyTRkb
         VoDyM4vJJp7ltJgKPdLgwXf2XUD6KYZJHrdL/w048VwOToy4QRjVIY2M7fgcL46qcU6g
         rJyQhrcqFxH/dt7k4ZOSZKNDjHVl93shE+pMm+8fSnsvA0JcxU/r1kp+/l52WDwiPMYA
         SAuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nz4jMxdehn1hXObQYPAUs8WzAXN+J02ZTVMfdZ7hqcs=;
        b=i+SMI6zU9MT5KcBJ2HJ7iMR9RMfRcLoCkcsqUEC2r7JnH8v1WBQIxWUf3Rz+ckvCr5
         5dmpwMzH7LdQb3KkBR8fdLgygP6pVfgTmqr1PFOFMzM7QFvZGj7JnkBEGIR37zAPcpAH
         Xf/YzGHnRbTqh99jJ6SC0fbqJvScHAR2heL6PHa2+K1lo0OLfNwBp7ezsdA/YXiLSwpM
         QHnAEO3cKUYs7twVz/9lB+s5isM8gOE0SoGTMww0SLwbw+X2PPwus/PRIs5mgMCecop0
         GebRq2pbqpGPxRo2SYVzHAJIxUujfF64L8L9qhB8Rkp4UTV2AKGPnErx9eJyib6S8tCe
         Qtjw==
X-Gm-Message-State: APjAAAWR3jE084Wcdf/GbCNUerQtvNledbNL3Af8Hsnopj8/Bb6Ze1cP
        CzmXPC5EMIF5aUNTpnTgBzrqHPBBctYbwzRP5VFhjRcKfMU=
X-Google-Smtp-Source: APXvYqzJnx2LYLAGAeNJmnLZtgH6gVt8Ji8VciMC177Jv8gicN9V99UpGGSLxGAyhyWKWcZGcenPKyyyS0XhvP6LPKM=
X-Received: by 2002:a17:906:2e53:: with SMTP id r19mr32725295eji.306.1577120004977;
 Mon, 23 Dec 2019 08:53:24 -0800 (PST)
MIME-Version: 1.0
References: <1576885124-14576-1-git-send-email-tom@herbertland.com>
 <1576885124-14576-2-git-send-email-tom@herbertland.com> <CA+FuTSfSFtSZjstCCp4ZdwPMCiHXaskgTqQH0EJYzV4-08t2Eg@mail.gmail.com>
In-Reply-To: <CA+FuTSfSFtSZjstCCp4ZdwPMCiHXaskgTqQH0EJYzV4-08t2Eg@mail.gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Mon, 23 Dec 2019 08:53:13 -0800
Message-ID: <CALx6S35o==mvEJ+GOx_tQfi56HVxKFySd+bjNakzwgiuvHnS7Q@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 1/9] ipeh: Fix destopts and hopopts counters
 on drop
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 22, 2019 at 8:21 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Dec 20, 2019 at 6:39 PM Tom Herbert <tom@herbertland.com> wrote:
> >
> > From: Tom Herbert <tom@quantonium.net>
> >
> > For destopts, bump IPSTATS_MIB_INHDRERRORS when limit of length
> > of extension header is exceeded.
> >
> > For hop-by-hop options, bump IPSTATS_MIB_INHDRERRORS in same
> > situations as for when destopts are dropped.
> >
> > Signed-off-by: Tom Herbert <tom@herbertland.com>
> > ---
> >  net/ipv6/exthdrs.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> > index ab5add0..f605e4e 100644
> > --- a/net/ipv6/exthdrs.c
> > +++ b/net/ipv6/exthdrs.c
> > @@ -288,9 +288,9 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
> >         if (!pskb_may_pull(skb, skb_transport_offset(skb) + 8) ||
> >             !pskb_may_pull(skb, (skb_transport_offset(skb) +
> >                                  ((skb_transport_header(skb)[1] + 1) << 3)))) {
> > +fail_and_free:
> >                 __IP6_INC_STATS(dev_net(dst->dev), idev,
> >                                 IPSTATS_MIB_INHDRERRORS);
> > -fail_and_free:
> >                 kfree_skb(skb);
> >                 return -1;
> >         }
> > @@ -820,8 +820,10 @@ static const struct tlvtype_proc tlvprochopopt_lst[] = {
> >
> >  int ipv6_parse_hopopts(struct sk_buff *skb)
> >  {
> > +       struct inet6_dev *idev = __in6_dev_get(skb->dev);
> >         struct inet6_skb_parm *opt = IP6CB(skb);
> >         struct net *net = dev_net(skb->dev);
> > +       struct dst_entry *dst = skb_dst(skb);
> >         int extlen;
> >
> >         /*
> > @@ -834,6 +836,8 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
> >             !pskb_may_pull(skb, (sizeof(struct ipv6hdr) +
> >                                  ((skb_transport_header(skb)[1] + 1) << 3)))) {
> >  fail_and_free:
> > +               __IP6_INC_STATS(dev_net(dst->dev), idev,
> > +                               IPSTATS_MIB_INHDRERRORS);
>
> ip6_rcv_core, the only caller of ipv6_parse_hopopts, checks
> skb_valid_dst(skb) before deref. Does this need the same?

Hi Willem,

Actually, it looks like ipv6_parse_hopopts is doing things the right
way. __IP6_INC_STATS is called from ip6_rcv_core if ipv6_parse_hopopts
and the net is always taken from skb->dev (not dst) in HBH path. I'll
fix destopts to do the same.

Tom
