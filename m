Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B910E1A4882
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 18:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDJQb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 12:31:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42584 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726145AbgDJQb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 12:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586536286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y8FEUZNJDefGZntwCUWNGecPQJCO9E0tu4hLm5+wQzY=;
        b=KdzHCyHAiNHh606PbEVvdvDCLAmh8Vf081TcRIJ/ARYoKzZQ+PonJZiC05HJUw8EchBZhF
        +6/AMPgnxtReVN7rDf092vuWyrD37qVhURjta1/d4xVKwpuJr3e0rkGpfOGZk4DtSrfgH5
        JKMLklw1cORk4eG9OScTZYFkztawxkM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443--VSv-lmrNdae3-vVih2b3A-1; Fri, 10 Apr 2020 12:31:25 -0400
X-MC-Unique: -VSv-lmrNdae3-vVih2b3A-1
Received: by mail-ed1-f71.google.com with SMTP id f11so2549454edc.4
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 09:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y8FEUZNJDefGZntwCUWNGecPQJCO9E0tu4hLm5+wQzY=;
        b=qRZE9A+iCR/l4RflKn10PbvzzYvcp1GWTtpE60mma3xEdiId2REw3BagfMpNLEWn+e
         eonI6z1bl0jf9u06vMJYPh8TQfywBTZHjDkidYDKELsFwvxMuIP1M8EYMuYvteHyNG1z
         YtwFcC72TzdmF0epxhmzZ0lYE6ktWDKAX1WkA4J+MmhK33j5VumFEjJ1BMu6W7o6CIft
         FyxOUHlQPfcuscSjmtuYf8FNwNlQa8shxiC8BH2nuVe43hDYeEQCXSropMkpZ9nyj1gn
         7Rcl9HcRP8stC3KDEAOwUCVWHNDDhFh2i0HWndcDXBs7EaFkwnDEEqKeCBNh2E81HBh0
         ow3A==
X-Gm-Message-State: AGi0PubZb202sQllmXx7cMcgSDj1jFfcd743mHY2N9qgmVq1x6hCb3Rp
        95ZRPMA2zIM017rW5kTkHILCsXPFY4S63dbDVpzNPHLaVTcgUFuVg4sZkHGzZYVVtcyCkAwGEbn
        iM72G5L/GBDBsTY7Hq0fSqELmp6FNKW7L
X-Received: by 2002:a17:907:262a:: with SMTP id aq10mr4400601ejc.377.1586536283965;
        Fri, 10 Apr 2020 09:31:23 -0700 (PDT)
X-Google-Smtp-Source: APiQypL7J79tMIQbnOA7JHQfrlvoJmibhKKTFEYYeJYtrKsVbqVNWokUPB5IWl4//dJTURWMEcNv1XerwMH6s/VGC3Q=
X-Received: by 2002:a17:907:262a:: with SMTP id aq10mr4400586ejc.377.1586536283723;
 Fri, 10 Apr 2020 09:31:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk> <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
 <20200410145034.GA25745@shell.armlinux.org.uk> <CAGnkfhwOCLSG=3v2jy6tTxiPyX0H+Azj7Ni5t8_nkRi=rUfnUQ@mail.gmail.com>
 <20200410151627.GB25745@shell.armlinux.org.uk> <CAGnkfhyE8q3iM6oW73R2ZUys+osd6YVYWcDDp6-YDsxmyzgKrg@mail.gmail.com>
 <20200410160409.GC25745@shell.armlinux.org.uk> <CAGnkfhxSjQcX=Di7XMdDCA=zCf7=Jtv2CFR=4keYeib6x=tbFA@mail.gmail.com>
 <20200410162313.GD25745@shell.armlinux.org.uk>
In-Reply-To: <20200410162313.GD25745@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 10 Apr 2020 18:30:48 +0200
Message-ID: <CAGnkfhwedGe4_JAy5Ok7bxYPi_C9bqVWh1fjV6eGy2Ss+-hSag@mail.gmail.com>
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

On Fri, Apr 10, 2020 at 6:23 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Apr 10, 2020 at 06:07:46PM +0200, Matteo Croce wrote:
> > On Fri, Apr 10, 2020 at 6:04 PM Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Fri, Apr 10, 2020 at 05:18:41PM +0200, Matteo Croce wrote:
> > > > On Fri, Apr 10, 2020 at 5:16 PM Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk> wrote:
> > > > >
> > > > > On Fri, Apr 10, 2020 at 04:59:44PM +0200, Matteo Croce wrote:
> > > > > > On Fri, Apr 10, 2020 at 4:50 PM Russell King - ARM Linux admin
> > > > > > <linux@armlinux.org.uk> wrote:
> > > > > > >
> > > > > > > On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> > > > > > # ./mii-diag eth0 -p 32769
> > > > > > Using the specified MII PHY index 32769.
> > > > > > Basic registers of MII PHY #32769:  2040 0082 002b 09ab 0071 009a c000 0009.
> > > > > >  Basic mode control register 0x2040: Auto-negotiation disabled, with
> > > > > >  Speed fixed at 100 mbps, half-duplex.
> > > > > >  Basic mode status register 0x0082 ... 0082.
> > > > > >    Link status: not established.
> > > > > >    *** Link Jabber! ***
> > > > > >  Your link partner is generating 100baseTx link beat  (no autonegotiation).
> > > > > >    End of basic transceiver information.
> > > > > >
> > > > > > root@macchiatobin:~# ip link show dev eth0
> > > > > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> > > > > > mode DEFAULT group default qlen 2048
> > > > > >     link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
> > > > > >
> > > > > > But no traffic in any direction
> > > > >
> > > > > So you have the same version PHY hardware as I do.
> > > > >
> > > > > So, we need further diagnosis, which isn't possible without a more
> > > > > advanced mii-diag tool - I'm sorting that out now, and will provide
> > > > > a link to a git repo later this afternoon.
> > > > >
> > > >
> > > > Ok, I'll wait for the tool
> > >
> > > Okay, please give this a go:
> > >
> > >         git://git.armlinux.org.uk/~rmk/mii-diag/
> > >
> > > Please send me the full output from:
> > >
> > > # ./mii-diag eth0 -v -p 32768
> > >
> >
> > Hi,
> >
> > here it is:
>
> Thanks.  It seems that the PHY is reporting that everything is fine,
> all the various blocks associated with the SFP+ cage are reporting
> that link is established, and link is established with the host.
>
> I wonder - can you tcpdump to see whether any traffic is being
> received at either end of the link, in case it's only one direction
> that is a problem?
>

Hi,

The problem is in both directions, I can't receive anything, and sent
can't be received from the other end.

# ip -s link show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
mode DEFAULT group default qlen 2048
    link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    0          0        0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    252        6        0       0       0       0

If it can help, I can provide you access to the box.

Regards,
-- 
Matteo Croce
per aspera ad upstream

