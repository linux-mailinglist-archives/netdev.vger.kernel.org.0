Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BEE1A483D
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 18:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDJQIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 12:08:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55526 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726080AbgDJQIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 12:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586534932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=62gc6CIWOr62BfUWoEBugMgrkIOImUPIXu1KDOB3kRM=;
        b=Zj5zlP3yGfLTzvyxm2dWub0c+Y3YOlHKU+DSBR8SI2JDj6RfkO82UGA8SlKdq56/IQ71YU
        qmkUpJkqcuBlQBt5C+zt+Yggu349/V0ptGNNlhybCBx9dHZs+OY+DXJZK28oPiKSecUbXE
        m+71sUKoDBHrjtJ5zjG253jBzu++it4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-WnnLO2aGNQqoJZNYuo5xRg-1; Fri, 10 Apr 2020 12:08:24 -0400
X-MC-Unique: WnnLO2aGNQqoJZNYuo5xRg-1
Received: by mail-ed1-f70.google.com with SMTP id bm26so2475467edb.17
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 09:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=62gc6CIWOr62BfUWoEBugMgrkIOImUPIXu1KDOB3kRM=;
        b=UFr1ISrtMXZmFewAk0F+YYb3LBvGdKiB5FqvoEOMi3zmfQ05FE2RasoKgwEEcqaxCP
         ppTEC2tI9LkjGHXJGFbvZH5TH7AoV2XtmkHMhbB+2sjYnuH3zwqxRRy7Hg/EMK58pO15
         C2G6VGryOxLmEbChLsSyDKHIuz3ILJV+fZsVfRlJk817pbrowbAOyJ+Qw3WFoXdpYTQo
         /ma/n+JcDYLluwx10iFf8YgtWGzcye9oCkB4qPZ3CHEurbImJMwwqXigr6wSTQaIZ3sb
         1Ir3zt1xMjPM3lDfmYuzn3y+rPsII3A7RhXfAOC1XjYQE03x0shOtZd/6onhvo0g55uC
         7uQA==
X-Gm-Message-State: AGi0PuarQY0zfuhDPPPd3VYWRO68yU8rrWA7f54vVzAKpdZg1ZftAwgU
        WHXhb/c472pP0kedVjpes58l7V0HyTbcImlKBIddOBPpV7FY5DhR2IiJlP6S8XibB7I1h179Xsa
        wU4Xb0/FQe33+cuU/188BLPZLdz3aulLv
X-Received: by 2002:a17:906:1641:: with SMTP id n1mr4536388ejd.365.1586534903018;
        Fri, 10 Apr 2020 09:08:23 -0700 (PDT)
X-Google-Smtp-Source: APiQypLZgMbvAOgGpGRdvvE3KCAaPmfotPLIAW7QX6kKQoUgPuXvB/K4oGoPpMOKtx8n95a85UiGI6yI3nLUIySKJ7w=
X-Received: by 2002:a17:906:1641:: with SMTP id n1mr4536334ejd.365.1586534902394;
 Fri, 10 Apr 2020 09:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200303155347.GS25745@shell.armlinux.org.uk> <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
 <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk> <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
 <20200410145034.GA25745@shell.armlinux.org.uk> <CAGnkfhwOCLSG=3v2jy6tTxiPyX0H+Azj7Ni5t8_nkRi=rUfnUQ@mail.gmail.com>
 <20200410151627.GB25745@shell.armlinux.org.uk> <CAGnkfhyE8q3iM6oW73R2ZUys+osd6YVYWcDDp6-YDsxmyzgKrg@mail.gmail.com>
 <20200410160409.GC25745@shell.armlinux.org.uk>
In-Reply-To: <20200410160409.GC25745@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 10 Apr 2020 18:07:46 +0200
Message-ID: <CAGnkfhxSjQcX=Di7XMdDCA=zCf7=Jtv2CFR=4keYeib6x=tbFA@mail.gmail.com>
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

On Fri, Apr 10, 2020 at 6:04 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Apr 10, 2020 at 05:18:41PM +0200, Matteo Croce wrote:
> > On Fri, Apr 10, 2020 at 5:16 PM Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Fri, Apr 10, 2020 at 04:59:44PM +0200, Matteo Croce wrote:
> > > > On Fri, Apr 10, 2020 at 4:50 PM Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk> wrote:
> > > > >
> > > > > On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> > > > # ./mii-diag eth0 -p 32769
> > > > Using the specified MII PHY index 32769.
> > > > Basic registers of MII PHY #32769:  2040 0082 002b 09ab 0071 009a c000 0009.
> > > >  Basic mode control register 0x2040: Auto-negotiation disabled, with
> > > >  Speed fixed at 100 mbps, half-duplex.
> > > >  Basic mode status register 0x0082 ... 0082.
> > > >    Link status: not established.
> > > >    *** Link Jabber! ***
> > > >  Your link partner is generating 100baseTx link beat  (no autonegotiation).
> > > >    End of basic transceiver information.
> > > >
> > > > root@macchiatobin:~# ip link show dev eth0
> > > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> > > > mode DEFAULT group default qlen 2048
> > > >     link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
> > > >
> > > > But no traffic in any direction
> > >
> > > So you have the same version PHY hardware as I do.
> > >
> > > So, we need further diagnosis, which isn't possible without a more
> > > advanced mii-diag tool - I'm sorting that out now, and will provide
> > > a link to a git repo later this afternoon.
> > >
> >
> > Ok, I'll wait for the tool
>
> Okay, please give this a go:
>
>         git://git.armlinux.org.uk/~rmk/mii-diag/
>
> Please send me the full output from:
>
> # ./mii-diag eth0 -v -p 32768
>

Hi,

here it is:

# ./mii-diag eth0 -v -p 32768
mii-diag.c:v2.11 3/21/2005 Donald Becker (becker@scyld.com)
 http://www.scyld.com/diag/index.html
  Using the new SIOCGMIIPHY value on PHY 0 (BMCR 0x2040).
Using the specified MII PHY index 32768.
  No MII transceiver present!.
  Use '--force' to view the information anyway.
libmii.c:v2.11 2/28/2005  Donald Becker (becker@scyld.com)
 http://www.scyld.com/diag/index.html

 MII PHY #0:1 PMA/PMD transceiver registers:
   2040 0082 002b 09ab 0071 009a c000 0009
   9701 0000 0000 01a4 0000 0000 002b 09ab
   0000 0000 0000 0000 0000 0003 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:0a:c2:--:--:--, model 26 rev. 11.
   Vendor/Part: Marvell Semiconductor 88X3310.
 Control 1 register 2040: Speed determined by auto-negotiation.
 Status register 0082 ... 0082.
   Receive link status: not established.
   *Fault condition detected*
 Speed capability 0071: 10G, 10G/1G, 100M, 10M.
 Control 2 register 0009: Type determined by auto-negotiation.
 Status 2 register 9701 ... 9701
   Abilities: Local loopback, Transmit disable, Receive fault.
   *Receive fault reported*.
 Extended Ability register 01a4
   Abilities: 10GbaseT, 1000baseT, 100baseTX, 10baseT.
 2.5G/5G Extended Ability register 0003
   Abilities: 5GbaseT, 2.5GbaseT.

 MII PHY #0:3 PCS transceiver registers:
   2040 0082 002b 09ab 0001 009a c000 0003
   8c08 0000 0000 0000 0000 0000 002b 09ab
   0000 0000 0000 0000 000e 0003 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 3f00 0000 0000 0000 0000 0000 0000
   0000 0be3 0b83 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:0a:c2:--:--:--, model 26 rev. 11.
   Vendor/Part: Marvell Semiconductor 88X3310.
 Control 1 register 2040: Speed 10Gb/s.
 Status register 0082 ... 0082.
   Receive link status: not established.
   *Fault condition detected*
   Supports low-power mode.
 Speed capability 0001: 10G.
 Control 2 register 0003: Type 10GbaseT.
 Status 2 register 8c08 ... 8c08
   Abilities: 10GbaseT.
   *Transmit fault reported*.
   *Receive fault reported*.
 baseR or 10GbaseT status 0000 3f00.
 EEE control and capabilities 000e
   10GBASE-T, 1000BASE-T, 100BASE-TX.
 EEE wake error counter: 0000

 MII PHY #0:3 PCS Subdevice #2 transceiver registers:
   2040 0006 002b 09ab 0005 009e c000 0000
   8013 0000 0000 0000 0000 0000 002b 09ab
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   100d 8000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:0a:c2:--:--:--, model 26 rev. 11.
   Vendor/Part: Marvell Semiconductor 88X3310.
 Control 1 register 2040: Speed 10Gb/s.
 Status register 0006 ... 0006.
   Receive link status: established.
   Supports low-power mode.
 Speed capability 0005: 40G, 10G.
 Control 2 register 0000: Type 10GbaseR.
 Status 2 register 8013 ... 8013
   Abilities: 40GbaseR, 10GbaseR, 10GbaseX.
 baseR or 10GbaseT status 100d 8000
   PCS receive link up
   PRBS9 pattern testing
   PRBS31 pattern testing
   Block lock
   Block lock (latched).

 MII PHY #0:3 PCS Subdevice #3 transceiver registers:
   1140 0149 0141 0dab 0020 0000 0004 2001
   0000 0000 0000 0000 0000 0000 0000 8000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:50:43:--:--:--, model 26 rev. 11.
   Vendor/Part: Marvell Semiconductor 88X3310.
 Basic mode control register 1140: Auto-negotiation enabled.
 Basic mode status register 0149 ... 0149.
   With extended status register 8000.
   Link status: not established.
   Capable of 1000baseX-FD.
   Able to perform Auto-negotiation, negotiation not complete.
 I'm advertising 0020: 1000baseX-FD.

 MII PHY #0:4 PHY XS transceiver registers:
   2040 0082 0141 0dab 0001 001a 4000 0001
   8403 0000 0000 0000 0000 0000 0141 0dab
   0000 0000 0000 0000 0000 0000 0000 0000
   0c00 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:50:43:--:--:--, model 26 rev. 11.
   Vendor/Part: Marvell Semiconductor 88X3310.
 Control 1 register 2040: Speed 10Gb/s.
 Status register 0082 ... 0082.
   Transmit link status: not established.
   *Fault condition detected*
   Supports low-power mode.
 Speed capability 0001: 10G.
 Lane Status 0c00:
   pattern testing supported
   loopback support.

 MII PHY #0:4 PHY XS Subdevice #2 transceiver registers:
   2040 0006 002b 09ab 0005 009e c000 0000
   8013 0000 0000 0000 0000 0000 002b 09ab
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   100d 8000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:0a:c2:--:--:--, model 26 rev. 11.
   Vendor/Part: Marvell Semiconductor 88X3310.
 Control 1 register 2040: Speed 10Gb/s.
 Status register 0006 ... 0006.
   Transmit link status: established.
   Supports low-power mode.
 Speed capability 0005: 10G.
 Lane Status 0000.

 MII PHY #0:4 PHY XS Subdevice #3 transceiver registers:
   1140 0149 0141 0dab 0020 0000 0004 2001
   0000 0000 0000 0000 0000 0000 0000 8000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:50:43:--:--:--, model 26 rev. 11.
   Vendor/Part: Marvell Semiconductor 88X3310.
 Basic mode control register 1140: Auto-negotiation enabled.
 Basic mode status register 0149 ... 0149.
   With extended status register 8000.
   Link status: not established.
   Capable of 1000baseX-FD.
   Able to perform Auto-negotiation, negotiation not complete.
 SGMII advertisement 0020:  Link down, reserved bits are set.
 SGMII acknowledgement 0000: Unacknowledged.

 MII PHY #0:7 AN transceiver registers:
   3000 0008 002b 09ab 0000 009a c000 0000
   0000 0000 0000 0000 0000 0000 002b 09ab
   1de1 0000 0000 0081 0000 0000 2001 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   1081 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:0a:c2:--:--:--, model 26 rev. 11.
   Vendor/Part: Marvell Semiconductor 88X3310.
 Control 1 register 3000: Auto-negotiation enabled.
 Status register 0008 ... 0008.
   Link status: not established.
   Able to perform Auto-negotiation, negotiation not complete.
 I'm advertising 1de1 1081.
   10GbaseT 2.5GbaseT AsymPause Pause 100baseTx-FD 100baseTx 10baseT-FD 10baseT
   I'm part of a single-port device.
   10GbaseT LD loop timing.
   Advertising no additional info pages.
   IEEE 802.3 CSMA/CD protocol.
 Link partner advertisment is 0081.
   Advertising 100baseTx.
   Negotiation did not complete.
 10GbaseT status 0000
   Local PHY slave, Local RX not ok, Remote RX not ok.
 XNP advert is 2001: message page 1
 XNP link partner is 0000: unformatted code 000

 MII PHY #0:7 AN Subdevice #2 transceiver registers:
   0000 000c 0141 0d90 0000 009e c000 0000
   0000 0000 0000 0000 0000 0000 0141 0d90
   0001 008a 0000 0000 0000 0000 2001 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0009 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:50:43:--:--:--, model 25 rev. 0.
   Vendor/Part: Marvell Semiconductor (unknown type).
 Control 1 register 0000: Auto-negotiation disabled.
 Status register 000c ... 000c.
   Link status: established.
   Able to perform Auto-negotiation, negotiation not complete.
 I'm advertising 0000008a0001.
   Advertising 10GbaseKR.
   IEEE 802.3 CSMA/CD protocol.
 baseR Status 0009: 10GbaseKR.

 MII PHY #0:7 AN Subdevice #3 transceiver registers:
   0000 000c 0141 0d90 0000 009e c000 0000
   0000 0000 0000 0000 0000 0000 0141 0d90
   0001 0096 0000 0000 0000 0000 2001 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0009 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:50:43:--:--:--, model 25 rev. 0.
   Vendor/Part: Marvell Semiconductor (unknown type).
 Control 1 register 0000: Auto-negotiation disabled.
 Status register 000c ... 000c.
   Link status: established.
   Able to perform Auto-negotiation, negotiation not complete.
 I'm advertising 000000960001.
   Advertising 10GbaseKR.
   IEEE 802.3 CSMA/CD protocol.
 baseR Status 0009: 10GbaseKR.

 MII PHY #0:7 AN Subdevice #4 transceiver registers:
   3000 0008 0141 0c00 0000 008a 0000 0000
   0000 0000 0000 0000 0000 0000 0141 0c00
   1de1 0000 0000 0081 0000 0000 2801 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   1081 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:50:43:--:--:--, model 0 rev. 0.
   Vendor/Part: Marvell Semiconductor (unknown type).
 Control 1 register 3000: Auto-negotiation enabled.
 Status register 0008 ... 0008.
   Link status: not established.
   Able to perform Auto-negotiation, negotiation not complete.
 I'm advertising 1de1 1081.
   10GbaseT 2.5GbaseT AsymPause Pause 100baseTx-FD 100baseTx 10baseT-FD 10baseT
   I'm part of a single-port device.
   10GbaseT LD loop timing.
   Advertising no additional info pages.
   IEEE 802.3 CSMA/CD protocol.
 Link partner advertisment is 0081.
   Advertising 100baseTx.
   Negotiation did not complete.
 10GbaseT status 0000
   Local PHY slave, Local RX not ok, Remote RX not ok.
 XNP advert is 2801: message page 1
 XNP link partner is 0000: unformatted code 000

 Other registers
  8000: 0210 0000 7973 0000 0000 0000 fffe 8007
  8008: 0000 1000 0000 0000 0101 0000 0000 0077

  9000: 0010 014a 0000 0000 0000 0000 0000 0000
  9008: 0000 0000 0000 0002 0001 0000 0000 0000

  9800: 0010 014a 0000 0000 0000 0000 0000 0000
  9808: 0000 0000 0000 0002 0001 0000 0000 0000

  a000: 0210 0000 7973 0000 0404 0000 fffe 8007
  a008: 0000 1000 0000 0000 0101 0000 0100 0010
  a010: 0010 0000 0000 0000 0000 0000 0040 0000
  ...
  a020: a400 0000 0000 05a1 0300 0003 0000 0000
  a028: 0000 8317 0000 8000 1000 0000 0000 0000
  a030: e49f 00ff 0000 0000 0000 0000 0000 0000

 MII PHY #0:30 Vendor Specific 1 transceiver registers:
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.

 MII PHY #0:31 Vendor Specific 2 transceiver registers:
   fffe 0000 fffe 0000 fffe 0000 fffe 0000
   fffe 0000 fffe 0000 fffe 0000 fffe 0000
   fffe 0000 fffe 0000 fffe 0000 fffe 0000
   fffe 0000 fffe 0000 fffe 0000 fffe 0000
   fffe 0000 fffe 0000 fffe 0000 fffe 0000
   fffe 0000 fffe 0000 fffe 0000 fffe 0000
   fffe 0000 fffe 0000 fffe 0000 fffe 0000
   fffe 0000 fffe 0000 fffe 0000 fffe 0000.

-- 
Matteo Croce
per aspera ad upstream

