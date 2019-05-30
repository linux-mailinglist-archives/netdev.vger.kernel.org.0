Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D0830115
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfE3Rae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:30:34 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44642 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Rad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:30:33 -0400
Received: by mail-qk1-f193.google.com with SMTP id w187so4361569qkb.11
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pfVPiNXY8ivYIf9ydI8gxrNopcmG7baFrjkCuROxpf4=;
        b=I0QIoNPADPbpXbFdTWE7TO+xpCdCiDtuX2/Q3uTezaT/UgpqhNvvP7uf2dEGfhYY4M
         mQIcOI7E3etTGBhFmpCwQI5KXNHXDAmPdzCbRbx9EVmiEaVcQ/yKLoFrjgzLvOBWJiSc
         wbkQbzHQTmTIZoE5oOHf1dCDZBbJVvsFcIpkiiHoDPbaq2dzyRlPgYA1ozR/YOrGtPl3
         FzhtTvBN7TgJ67IpyPHZrRnXaecgIlFTdXg6HD+ojjod2X2MNaoE8HI92UmLpGxNxx1M
         v68TdtTFU36eQKXb6cMUVNpW6ZdqyUp3BYtBATIS8CKEwG2+2Y8QrXDlx1QSKiLoBgIk
         Eavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pfVPiNXY8ivYIf9ydI8gxrNopcmG7baFrjkCuROxpf4=;
        b=foczetH0uqNkgpD3Dnw4Y5spjWxylUGp0Eo7AJVvfHB4dywrwJ8RAf3+1KwY4lFR2T
         l9kCczHcnLdpGLjXZgwxvFq9EPS3YnHcHU1ekBZHmoEPT3Nq0OpIosp5Vdp0roqsT7V8
         ygYv0ljBpQ6kav9LII7ePwS8u+xfOBoGgeqkMYQ+hn8KGKbNaM8t0icVbUWi1fPm2omf
         Vj0kMMe5QSaW1lqhcP2GgOWYoAE6hVZeTcjRtrxsjm3j3W5HQk6QEMkbCHw4nHEqHdaX
         xMUNuUv9NBcnq3echC2GWMBhHxVbpUhZa5wtTdySa7SUcKXmFlhwqF5bogkUGGLaZxd6
         2uEg==
X-Gm-Message-State: APjAAAV8UQBAprDfrLFWkmuNfyIVavgRMnf0s7LJ664rRSlVcMYHNHG5
        ta28nsorMnSR8POkEn7dvjBUUb3vV9MMPnunI74=
X-Google-Smtp-Source: APXvYqzKpiTf+5XEZ65jntFSwLb6pKXblpKGYdqMStkkKwo1ydT5ZJ2Pkhr+aYIQf4GlgvRu9Pg0eQ0KwjLWNyybHR8=
X-Received: by 2002:a37:670e:: with SMTP id b14mr4224284qkc.216.1559237432621;
 Thu, 30 May 2019 10:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <1559235580-31747-1-git-send-email-u9012063@gmail.com> <c96c083d-61be-ee68-0304-bfbdf78ca444@gmail.com>
In-Reply-To: <c96c083d-61be-ee68-0304-bfbdf78ca444@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 30 May 2019 10:29:53 -0700
Message-ID: <CALDO+SZU6Nw3e_2OPhzvjr0d4jgm5x9s9gaDYrU92hq7htqdYw@mail.gmail.com>
Subject: Re: [PATCHv2 net] net: ip6_gre: access skb data after skb_cow_head()
To:     Gregory Rose <gvrose8192@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this patch and allow me to investigate more.

On Thu, May 30, 2019 at 10:23 AM Gregory Rose <gvrose8192@gmail.com> wrote:
>
>
> On 5/30/2019 9:59 AM, William Tu wrote:
> > When increases the headroom, skb's data pointer might get re-allocated.
> > As a result, the skb->data before the skb_cow_head becomes a dangling p=
ointer,
> > and dereferences to daddr causes general protection fault at the follow=
ing
> > line in __gre6_xmit():
> >
> >    if (dev->header_ops && dev->type =3D=3D ARPHRD_IP6GRE)
> >        fl6->daddr =3D ((struct ipv6hdr *)skb->data)->daddr;
> >

Look again Dave's comment that
The fl6->daddr assignments are object copies, not pointer assignments.
So this shouldn't cause any problem after skb_cow_head.

I will work on the right fix.
Thanks,
William

> > general protection fault: 0000 [#1] SMP PTI
> > OE 4.15.0-43-generic #146-Ubuntu
> > Hardware name: VMware, Inc. VMware Virtual Platform 440BX Desktop Refer=
ence
> > Platform, BIOS 6.00 07/03/2018
> > RIP: 0010: __gre6_xmit+0x11f/0x2c0 [openvswitch]
> > RSP: 0018:ffffb8d5c44df6a8 EFLAGS: 00010286
> > RAX: 00000000ffffffea RBX: ffff8b1528a0000 RCX: 0000000000000036
> > RDX: ffff000000000000 RSI: 0000000000000000 RDI: ffff8db267829200
> > RBP: ffffb8d5c44df 700 R08: 0000000000005865 R=C3=989: ffffb8d5c44df724
> > R10: 0000000000000002 R11: 0000000000000000 R12: ffff8db267829200
> > R13: 0000000000000000 R14: ffffb8d5c44df 728 R15: 00000000ffffffff
> > FS: 00007f8744df 2700(0000) GS:ffff8db27fc0000000000) knlGS:00000000000=
00000
> > CS: 0910 DS: 0000 ES: 9000 CRO: 0000000080050033
> > CR2: 00007f893ef92148 CR3: 0000000400462003 CR4: 00000000001626f8
> > Call Trace:
> > ip6gre_tunnel_xmit+0x1cc/0x530 [openvswitch]
> > ? skb_clone+0x58/0xc0
> > __ip6gre_tunnel_xmit+0x12/0x20 [openvswitch]
> > ovs_vport_send +0xd4/0x170 [openvswitch]
> > do_output+0x53/0x160 [openvswitch]
> > do_execute_actions+0x9a1/0x1880 [openvswitch]
> >
> > Fix it by moving skb_cow_head before accessing the skb->data pointer.
> >
> > Fixes: 01b8d064d58b4 ("net: ip6_gre: Request headroom in __gre6_xmit()"=
)
> > Reported-by: Haichao Ma <haichaom@vmware.com>
> > Signed-off-by: William Tu <u9012063@gmail.com>
> > ---
> > v1-v2: add more details in commit message.
> > ---
> >   net/ipv6/ip6_gre.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> > index 655e46b227f9..90b2b129b105 100644
> > --- a/net/ipv6/ip6_gre.c
> > +++ b/net/ipv6/ip6_gre.c
> > @@ -714,6 +714,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
> >       struct ip6_tnl *tunnel =3D netdev_priv(dev);
> >       __be16 protocol;
> >
> > +     if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
> > +             return -ENOMEM;
> > +
> >       if (dev->type =3D=3D ARPHRD_ETHER)
> >               IPCB(skb)->flags =3D 0;
> >
> > @@ -722,9 +725,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
> >       else
> >               fl6->daddr =3D tunnel->parms.raddr;
> >
> > -     if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
> > -             return -ENOMEM;
> > -
> >       /* Push GRE header. */
> >       protocol =3D (dev->type =3D=3D ARPHRD_ETHER) ? htons(ETH_P_TEB) :=
 proto;
> >
>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> Reviewed-by: Greg Rose <gvrose8192@gmail.com>
>
