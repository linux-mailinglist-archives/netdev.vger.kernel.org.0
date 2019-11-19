Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEB910252A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfKSNGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:06:49 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32855 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfKSNGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:06:47 -0500
Received: by mail-wr1-f68.google.com with SMTP id w9so23773566wrr.0
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 05:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BXAjKFuZ2J5bEJ5Ci9XH9Iuw9uldXME0/nOmHAeBpPg=;
        b=FGH64pUv7L4k1wYLHnzXzfs9Trglnx1fxq7uOhVedhgNEZF6IswBdUCcl9I0o4E2ak
         MptlTWbWTJJk4hPPWVNmuBM3nEZfv/OofsYqV9nUxfOD51xV9PdU+er5zUSOcSOlsvn6
         pbpQy/fZ/EOMh5IX3LX18DUv0hh5TlOKMzYhEZOtz+rtId7Kxk9TwmKXtGMsE33dl3Yk
         BK59MGktwWdbYMgedMxUetHmULCALWW6qNwLapgN4DuF2NG1ike4PR/VGK9+b5I8iVln
         fgFltLIp2iQX3xb4xxzXHse/JMjUxZx6+IpNX4r3/am5/a1UB62m+asL6FPyQQ+x8SWx
         3bNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BXAjKFuZ2J5bEJ5Ci9XH9Iuw9uldXME0/nOmHAeBpPg=;
        b=gtvJhijiA2uX0ohzUWhjIL6csKLqqkj0Jl/S71LZbrqItwMUs0BQz8zI8TT/GiYoQN
         yKUzDDPIbDOu+9e3fvkP2TWDASIDQlG/kugxrOf/LFzHqASACSqn0/e39Cd4GYIbvgv4
         mNiVEvmySklVe2wRDbx0P1qKqFTFLgz8+3/7AV09sN+TmXTQrZvRDati+HfSC/fojduv
         MlR9i/876dt+rbYBB3XkaI0m9Dlfj6GiPIgO/SXLDnPl1qc7VhV/pI3enxeRmrTVNLsi
         gVpepFdyGU54fo91jGYWJBXC2H2cHxQO0+VWgikuINy569zo4mtMA62eOh62nBWKIgKi
         ibNA==
X-Gm-Message-State: APjAAAXtpZe3qJtV4mMUaEHfnb82IHLCJvTZDXrxERU9AsCLsHQLIi9N
        /UX86GKsPK1CzA2EzbTgKIcX0fHW6rj0ATs4FwhC0g==
X-Google-Smtp-Source: APXvYqw6YFAcVgME859vXzGYJJg3Rr77oImJu5osjLQZBrlRjH8P8cfixx/Atojd+9DYeySruan22SClckObv3Qcf3w=
X-Received: by 2002:a05:6000:18c:: with SMTP id p12mr9183399wrx.154.1574168803860;
 Tue, 19 Nov 2019 05:06:43 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005c08d10597a3a05d@google.com> <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
 <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de> <7934bc2b-597f-0bb3-be2d-32f3b07b4de9@hartkopp.net>
 <7f5c4546-0c1a-86ae-581e-0203b5fca446@pengutronix.de> <1f7d6ea7-152e-ff18-549c-b196d8b5e3a7@hartkopp.net>
 <CACT4Y+acOwzqwrJ1OSStRkvdxsmM4RY6mz4qDEFAUpMM2P-FiQ@mail.gmail.com>
In-Reply-To: <CACT4Y+acOwzqwrJ1OSStRkvdxsmM4RY6mz4qDEFAUpMM2P-FiQ@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Tue, 19 Nov 2019 14:06:31 +0100
Message-ID: <CAG_fn=VhSv0sgzn6f_rYUpF45cpc=LMw3qMYeZ06FCmMGURwsQ@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in can_receive
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 11:09 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Tue, Nov 19, 2019 at 8:36 AM Oliver Hartkopp <socketcan@hartkopp.net> =
wrote:
> > On 18/11/2019 22.15, Marc Kleine-Budde wrote:
> > > On 11/18/19 9:49 PM, Oliver Hartkopp wrote:
> > >>
> > >>
> > >> On 18/11/2019 21.29, Marc Kleine-Budde wrote:
> > >>> On 11/18/19 9:25 PM, Oliver Hartkopp wrote:
> > >>
> > >>>>> IMPORTANT: if you fix the bug, please add the following tag to th=
e commit:
> > >>>>> Reported-by: syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.co=
m
> > >>>>>
> > >>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > >>>>> BUG: KMSAN: uninit-value in can_receive+0x23c/0x5e0 net/can/af_ca=
n.c:649
> > >>>>> CPU: 1 PID: 3490 Comm: syz-executor.2 Not tainted 5.4.0-rc5+ #0
> > >>
> > >>>>
> > >>>> In line 649 of 5.4.0-rc5+ we can find a while() statement:
> > >>>>
> > >>>> while (!(can_skb_prv(skb)->skbcnt))
> > >>>>    can_skb_prv(skb)->skbcnt =3D atomic_inc_return(&skbcounter);
> > >>>>
> > >>>> In linux/include/linux/can/skb.h we see:
> > >>>>
> > >>>> static inline struct can_skb_priv *can_skb_prv(struct sk_buff *skb=
)
> > >>>> {
> > >>>>    return (struct can_skb_priv *)(skb->head);
> > >>>> }
> > >>>>
> > >>>> IMO accessing can_skb_prv(skb)->skbcnt at this point is a valid
> > >>>> operation which has no uninitialized value.
> > >>>>
> > >>>> Can this probably be a false positive of KMSAN?
> > >>>
> > >>> The packet is injected via the packet socket into the kernel. Where=
 does
> > >>> skb->head point to in this case? When the skb is a proper
> > >>> kernel-generated skb containing a CAN-2.0 or CAN-FD frame skb->head=
 is
> > >>> maybe properly initialized?
> > >>
> > >> The packet is either received via vcan or vxcan which checks via
> > >> can_dropped_invalid_skb() if we have a valid ETH_P_CAN type skb.
> > >
> > > According to the call stack it's injected into the kernel via a packe=
t
> > > socket and not via v(x)can.
> >
> > See ioctl$ifreq https://syzkaller.appspot.com/x/log.txt?x=3D14563416e00=
000
> >
> > 23:11:34 executing program 2:
> > r0 =3D socket(0x200000000000011, 0x3, 0x0)
> > ioctl$ifreq_SIOCGIFINDEX_vcan(r0, 0x8933,
> > &(0x7f0000000040)=3D{'vxcan1\x00', <r1=3D>0x0})
> > bind$packet(r0, &(0x7f0000000300)=3D{0x11, 0xc, r1}, 0x14)
> > sendmmsg(r0, &(0x7f0000000d00), 0x400004e, 0x0)
> >
> > We only can receive skbs from (v(x))can devices.
> > No matter if someone wrote to them via PF_CAN or PF_PACKET.
> > We check for ETH_P_CAN(FD) type and ARPHRD_CAN dev type at rx time.
> >
> > >> We additionally might think about introducing a check whether we hav=
e a
> > >> can_skb_reserve() created skbuff.
> > >>
> > >> But even if someone forged a skbuff without this reserved space the
> > >> access to can_skb_prv(skb)->skbcnt would point into some CAN frame
> > >> content - which is still no access to uninitialized content, right?
> >
> > So this question remains still valid whether we have a false positive
> > from KMSAN here.
>
> +Alex, please check re KMSAN false positive.
Unfortunately syzbot didn't give a repro for this bug. I've tried
replaying the log, but it didn't work (or maybe the bug is fixed
already).
> Oliver, Marc, where this skbcnt should have been initialized in this case=
?



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
