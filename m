Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFABA1A48CD
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 19:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgDJRLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 13:11:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30358 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726142AbgDJRLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 13:11:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586538698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Px4NACsSvePOwS21PPwJlVFj7u6BshYXRDpIBeuIV3g=;
        b=B7IAiqVadj7bbP899lodU0m8IK1tUerq2lvo/ecXrMES/qF9vBenoPCvyddJduzMJYyZ0W
        Nle5wiRs4Hrq2ooHDqxaaIv0fiBBgKMMZvwz9HUs2S1ctNr3LHoLC/W298J0HLBMV/x+rW
        QcpwX9NQFuGibZEilcpq3JDL2lbPzNY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-AJVkrMzRNnSstxF5VYaQ2Q-1; Fri, 10 Apr 2020 13:11:35 -0400
X-MC-Unique: AJVkrMzRNnSstxF5VYaQ2Q-1
Received: by mail-ed1-f71.google.com with SMTP id b9so2797612edj.10
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 10:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Px4NACsSvePOwS21PPwJlVFj7u6BshYXRDpIBeuIV3g=;
        b=GCEo3X6fGDXj9TNy7uRzOnsU/Mg87VyT5QixwSw+lSdU5PZ5UcL1D1NNVYhG8hdUV8
         eiWzq+U+X7M8tSZgMgVCC9MoYTXfJdwkwnFJ0JYUz9VQzN+TEuELr5L46TWSdXCw7I1H
         L7lB44K4qChJvpTPANGOF33Jtegrbe2RNqYagoOzqKuL9b2W4TVLSfnbxA8aprIWBvz9
         e1Nkt0zzc5PWtKzLCv9sz7nWQg1BReseCQwL8uU+JNTuolUkmVmFiKTuKrZ9Jdrqtvrs
         uon2yymaT8q7oU9isp79B0Z5kQJwuruycU4Yu7BzxKo2C/liVhIh7USPtE3aciY/tkH7
         RDuw==
X-Gm-Message-State: AGi0PuYPJ88NW9oMOjvPDWjC3MHadYmb+J2GITIICabgQItwdloQVb0K
        UOh1zxUqC2yraiMGTjPWPVLipCaTlR7F5Lm9+A5o2wnpLUMIo6RLMBAQYZmCNlYL0f9KnraOVSt
        3v2VisQwQ4z6WsumCYEzwGx/cuUYDg7c2
X-Received: by 2002:a05:6402:504:: with SMTP id m4mr5834421edv.367.1586538694508;
        Fri, 10 Apr 2020 10:11:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypJXybslqyTGbOrQ0So5YU0IjqTQQagLxL4hxsmngozL5YlfEAAIglBdZ5W8rd9Fk2VaEwzDqCFQCvf57ecnPfw=
X-Received: by 2002:a05:6402:504:: with SMTP id m4mr5834397edv.367.1586538694272;
 Fri, 10 Apr 2020 10:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk> <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
 <20200410145034.GA25745@shell.armlinux.org.uk> <CAGnkfhwOCLSG=3v2jy6tTxiPyX0H+Azj7Ni5t8_nkRi=rUfnUQ@mail.gmail.com>
 <20200410151627.GB25745@shell.armlinux.org.uk> <CAGnkfhyE8q3iM6oW73R2ZUys+osd6YVYWcDDp6-YDsxmyzgKrg@mail.gmail.com>
 <20200410160409.GC25745@shell.armlinux.org.uk> <CAGnkfhxSjQcX=Di7XMdDCA=zCf7=Jtv2CFR=4keYeib6x=tbFA@mail.gmail.com>
 <20200410162313.GD25745@shell.armlinux.org.uk> <CAGnkfhwedGe4_JAy5Ok7bxYPi_C9bqVWh1fjV6eGy2Ss+-hSag@mail.gmail.com>
In-Reply-To: <CAGnkfhwedGe4_JAy5Ok7bxYPi_C9bqVWh1fjV6eGy2Ss+-hSag@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 10 Apr 2020 19:10:58 +0200
Message-ID: <CAGnkfhz_nq1TPpRdU7rdFpKJZRxpxvpm1-KtR4df3xWV+6AT8Q@mail.gmail.com>
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

On Fri, Apr 10, 2020 at 6:30 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Fri, Apr 10, 2020 at 6:23 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Fri, Apr 10, 2020 at 06:07:46PM +0200, Matteo Croce wrote:
> > > On Fri, Apr 10, 2020 at 6:04 PM Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > On Fri, Apr 10, 2020 at 05:18:41PM +0200, Matteo Croce wrote:
> > > > > On Fri, Apr 10, 2020 at 5:16 PM Russell King - ARM Linux admin
> > > > > <linux@armlinux.org.uk> wrote:
> > > > > >
> > > > > > On Fri, Apr 10, 2020 at 04:59:44PM +0200, Matteo Croce wrote:
> > > > > > > On Fri, Apr 10, 2020 at 4:50 PM Russell King - ARM Linux admin
> > > > > > > <linux@armlinux.org.uk> wrote:
> > > > > > > >
> > > > > > > > On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> > > > > > > # ./mii-diag eth0 -p 32769
> > > > > > > Using the specified MII PHY index 32769.
> > > > > > > Basic registers of MII PHY #32769:  2040 0082 002b 09ab 0071 009a c000 0009.
> > > > > > >  Basic mode control register 0x2040: Auto-negotiation disabled, with
> > > > > > >  Speed fixed at 100 mbps, half-duplex.
> > > > > > >  Basic mode status register 0x0082 ... 0082.
> > > > > > >    Link status: not established.
> > > > > > >    *** Link Jabber! ***
> > > > > > >  Your link partner is generating 100baseTx link beat  (no autonegotiation).
> > > > > > >    End of basic transceiver information.
> > > > > > >
> > > > > > > root@macchiatobin:~# ip link show dev eth0
> > > > > > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> > > > > > > mode DEFAULT group default qlen 2048
> > > > > > >     link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
> > > > > > >
> > > > > > > But no traffic in any direction
> > > > > >
> > > > > > So you have the same version PHY hardware as I do.
> > > > > >
> > > > > > So, we need further diagnosis, which isn't possible without a more
> > > > > > advanced mii-diag tool - I'm sorting that out now, and will provide
> > > > > > a link to a git repo later this afternoon.
> > > > > >
> > > > >
> > > > > Ok, I'll wait for the tool
> > > >
> > > > Okay, please give this a go:
> > > >
> > > >         git://git.armlinux.org.uk/~rmk/mii-diag/
> > > >
> > > > Please send me the full output from:
> > > >
> > > > # ./mii-diag eth0 -v -p 32768
> > > >
> > >
> > > Hi,
> > >
> > > here it is:
> >
> > Thanks.  It seems that the PHY is reporting that everything is fine,
> > all the various blocks associated with the SFP+ cage are reporting
> > that link is established, and link is established with the host.
> >
> > I wonder - can you tcpdump to see whether any traffic is being
> > received at either end of the link, in case it's only one direction
> > that is a problem?
> >
>
> Hi,
>
> The problem is in both directions, I can't receive anything, and sent
> can't be received from the other end.
>
> # ip -s link show dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> mode DEFAULT group default qlen 2048
>     link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped overrun mcast
>     0          0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     252        6        0       0       0       0
>
> If it can help, I can provide you access to the box.
>
> Regards,
> --
> Matteo Croce
> per aspera ad upstream

Hi,

I noticed this: booting once an old kernel will fix the following
net-next boots too as long as I don't unplug the power to the board.

-- 
Matteo Croce
per aspera ad upstream

