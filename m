Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F2C1A47B9
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgDJPAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 11:00:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50927 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbgDJPAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 11:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586530824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XHpaqKqflG0D5ozqlyOJXOSjYQEVyfsWYPU6Yfe2s3U=;
        b=OkRlnm8Mcck2urZc4u1ZcJ4CwMjqjf/yEP5Gvm6nkezVVNEcmx2FKW04JWLqEsA9JE1KyA
        /qPWi0cyWC0kmMzstlHCWpmHTdIex973nmyvUbJV1X2MSkjE3o4/ai+nwBTBcklfwxWKLg
        vdJVkiEySwImmGCxW5aCU+4B2FQSVqM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-orih3eM2NQWayLJYP3-voA-1; Fri, 10 Apr 2020 11:00:22 -0400
X-MC-Unique: orih3eM2NQWayLJYP3-voA-1
Received: by mail-ed1-f69.google.com with SMTP id j10so2327202edy.21
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 08:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XHpaqKqflG0D5ozqlyOJXOSjYQEVyfsWYPU6Yfe2s3U=;
        b=Q6FRcBeCmQwA/Y0UxbvIpBgD/hcvDJoZkZEuw2BnahL/s7ySbHhRVvQapuLRGVuQD6
         Z8axVlQd5k+TTUdYwyVWiih4NXljcd9t88WBMSm2ZWqtZIPM4IL6hPbje3qGScdWk2aG
         Yx56iBlTLtGJeZ6AYLjvZXwnuYq6/ggBx21/qPM2inhlS+tnepsI9G6J0D9OnvH7U2Dn
         b0F9FRWnTqsfpoGtIGZs5JGMdGBhrtzqS05e4oDXf5nb+66DaqSjLRqlO0CCNbRO+R5A
         pCHD30+72V1Op1j1cuUOP+m5L799C2HjT7ZyyjcgcpzWvtDLsUFv02cWFt06GKMJ3VRn
         e9Cw==
X-Gm-Message-State: AGi0PubAuwZswpRADiP1mPxzc7XW6uZ6+0zv71NpE7D4iws8y3Cci1LJ
        NZN7bsvkhJwTQwC+088FVY9JCfuFWgj/wEqL9gS+sy7brWr6qpn/07CnMJZUtTTuFR15sA1Dmkj
        U4gX5MShakHenVuTmSA3KVVWK/XDKTBv3
X-Received: by 2002:a17:907:262a:: with SMTP id aq10mr4025565ejc.377.1586530821032;
        Fri, 10 Apr 2020 08:00:21 -0700 (PDT)
X-Google-Smtp-Source: APiQypJTfUdl6CDawg5lg0i32CSjRrKMex6X/jYReahA7ofHumSF46PY3juUhzwU0HMf4nczQhrcOv/6w0OM6sVGD8c=
X-Received: by 2002:a17:907:262a:: with SMTP id aq10mr4025527ejc.377.1586530820733;
 Fri, 10 Apr 2020 08:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200303155347.GS25745@shell.armlinux.org.uk> <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
 <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk> <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com> <20200410145034.GA25745@shell.armlinux.org.uk>
In-Reply-To: <20200410145034.GA25745@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 10 Apr 2020 16:59:44 +0200
Message-ID: <CAGnkfhwOCLSG=3v2jy6tTxiPyX0H+Azj7Ni5t8_nkRi=rUfnUQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 4:50 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> > On Fri, Apr 10, 2020 at 4:37 PM Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Fri, Apr 10, 2020 at 03:19:14PM +0100, Russell King - ARM Linux admin wrote:
> > > > On Fri, Apr 10, 2020 at 03:48:34PM +0200, Matteo Croce wrote:
> > > > > On Fri, Apr 10, 2020 at 3:24 PM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > > > > >
> > > > > > Place the 88x3310 into powersaving mode when probing, which saves 600mW
> > > > > > per PHY. For both PHYs on the Macchiatobin double-shot, this saves
> > > > > > about 10% of the board idle power.
> > > > > >
> > > > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > >
> > > > > Hi,
> > > > >
> > > > > I have a Macchiatobin double shot, and my 10G ports stop working after
> > > > > this change.
> > > > > I reverted this commit on top of latest net-next and now the ports work again.
> > > >
> > > > Please describe the problem in more detail.
> > > >
> > > > Do you have the interface up?  Does the PHY link with the partner?
> > > > Is the problem just that traffic isn't passed?
> > >
> > > I've just retested on my Macchiatobin double shot, and it works fine.
> > > What revision PHYs do you have?  Unfortunately, you can't read the
> > > PHY ID except using mii-diag:
> > >
> > > # mii-diag eth0 -p 32769
> > >
> > > or
> > >
> > > # mii-diag eth1 -p 33025
> > >
> > > Looking at word 3 and 4, it will be either:
> > >
> > > 002b 09aa
> > > 002b 09ab
> > >
> > > Thanks.
> > >
> > > --
> > > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
> > >
> >
> >
> > Hi Russel,
> >
> > I have the interface up connected via a DAC Cable to an i40e card.
> > When I set the link up I detect the carrier:
> >
> > mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:00] driver
> > [mv88x3310] (irq=POLL)
> > mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r link mode
> > mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full - flow control off
> >
> > No traffic is received or can be sent.
>
> I've just tried with a DAC cable ("Molex Inc. 74752-9542")... works for
> me:
>
> root@mcbin-ds:~# ip li set dev eth0 down
> mvpp2 f2000000.ethernet eth0: Link is Down
> root@mcbin-ds:~# ip li set dev eth0 up
> mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:00] driver [mv88x3310] (irq=POLL)
> mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r link mode
> root@mcbin-ds:~# mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full - flow control off
> IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>
> root@mcbin-ds:~# ping6 -I eth0 fe80::202:c9ff:fe54:d70a
> ping6: Warning: source address might be selected on device other than eth0.
> PING fe80::202:c9ff:fe54:d70a(fe80::202:c9ff:fe54:d70a) from :: eth0: 56 data bytes
> 64 bytes from fe80::202:c9ff:fe54:d70a%eth0: icmp_seq=1 ttl=64 time=0.344 ms
> 64 bytes from fe80::202:c9ff:fe54:d70a%eth0: icmp_seq=2 ttl=64 time=0.129 ms
> 64 bytes from fe80::202:c9ff:fe54:d70a%eth0: icmp_seq=3 ttl=64 time=0.118 ms
> ^C
> --- fe80::202:c9ff:fe54:d70a ping statistics ---
> 3 packets transmitted, 3 received, 0% packet loss, time 54ms
> rtt min/avg/max/mdev = 0.118/0.197/0.344/0.104 ms
>
> where fe80::202:c9ff:fe54:d70a is the IPv6 link local address on a
> Mellanox card in a different machine at the other end of the DAC
> cable.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
>

Hi Russel,

that's it:

# ./mii-diag eth0 -p 32769
Using the specified MII PHY index 32769.
Basic registers of MII PHY #32769:  2040 0082 002b 09ab 0071 009a c000 0009.
 Basic mode control register 0x2040: Auto-negotiation disabled, with
 Speed fixed at 100 mbps, half-duplex.
 Basic mode status register 0x0082 ... 0082.
   Link status: not established.
   *** Link Jabber! ***
 Your link partner is generating 100baseTx link beat  (no autonegotiation).
   End of basic transceiver information.

root@macchiatobin:~# ip link show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
mode DEFAULT group default qlen 2048
    link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff

But no traffic in any direction

Thanks,
-- 
Matteo Croce
per aspera ad upstream

