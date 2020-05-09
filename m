Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9311CC26A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 17:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgEIPcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 11:32:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28151 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727812AbgEIPcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 11:32:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589038333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/9k5BNMmUns9N4aHfKaKHFFWzY7YhzMz20SuR2GCOTs=;
        b=ix+nhEVm8OpR7UTPBEb2SeHF7bKtlH0oM5/8IRGPlBlvBsoVDhnV+pYPcJ0IKDUtFlgeJZ
        riKhmU4ngXGC2NvvICexcwwMl4b6JCe97+FwdBsDUmxQXirhxV3/Tmzuft2sh/rxyih86e
        pexcFs/aPdc9/qX/lrff2+1VoV6QIl4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-JagjvC0FNiCvEUPquY5ukQ-1; Sat, 09 May 2020 11:32:06 -0400
X-MC-Unique: JagjvC0FNiCvEUPquY5ukQ-1
Received: by mail-ed1-f70.google.com with SMTP id cf15so1780581edb.20
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 08:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/9k5BNMmUns9N4aHfKaKHFFWzY7YhzMz20SuR2GCOTs=;
        b=r6K1cASCHlPD+ZkAzwbnWquZ3OebX4qzPzORTakGVpNolfTRu+Zk1VK/3YGFf4jwRl
         nBPZcXywPtgpwzyunYm0uD+5m8vtuzT1Es4rBPTG1t9JYwE5aVvbi55rNIZgDKhqwopJ
         p/cp0BujWssotZVWrXB0KGMsiC8fIMnI2kx9v0eKGLpUS5yyU4e/tY6whYZytifoeTVE
         dU/EZnUS34FYcsgmxYwM3pxGCf5Q2tyijet2Svt703ooXDLw2AiUpEmVtZ5TyZr8eeVA
         uauUNbuE+MVkc3/P+Sb0FUoahi1rVYoigcDe4FDmmcZblZxoUMaCkz4FHUW+PO7IxHX2
         yP3g==
X-Gm-Message-State: AGi0PuYuSlc0yZujyrblMq4hOb5JntmX2oE9HvjkaxxLDxCIEz0SVgkN
        ZPFp1I9fFnPJ9t8CGqkr3eAbK2a6HLMUrWXNcHpZMg85E9CD7s+HtYcn69DtMqOxSwwOUGGRfsp
        qvGJFgUCbAIr1fBEktOncuJ/qjlwwzp0s
X-Received: by 2002:aa7:d513:: with SMTP id y19mr6798477edq.367.1589038325050;
        Sat, 09 May 2020 08:32:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypLHmxaulq4sibtabPh8vK4g9kwOFYxg+ENWK4nYZBXaiR+LlFbajDS9tno2sZp90fS9GhFC02fMGlNUNZrza+s=
X-Received: by 2002:aa7:d513:: with SMTP id y19mr6798455edq.367.1589038324809;
 Sat, 09 May 2020 08:32:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com> <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk> <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
 <20200509114518.GB1551@shell.armlinux.org.uk> <CAGnkfhx8fEZCoLPzGxSzQnj1ZWcQtBMn+g_jO1Jxc4zF7pQwjQ@mail.gmail.com>
 <20200509135105.GE1551@shell.armlinux.org.uk> <20200509144845.GF1551@shell.armlinux.org.uk>
In-Reply-To: <20200509144845.GF1551@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 9 May 2020 17:31:29 +0200
Message-ID: <CAGnkfhwfMTRm_WrdddDfKez1MbYqGtQOywZ56jy9rKFzQfjmZg@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 4:49 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Sat, May 09, 2020 at 02:51:05PM +0100, Russell King - ARM Linux admin wrote:
> > On Sat, May 09, 2020 at 03:14:05PM +0200, Matteo Croce wrote:
> > > On Sat, May 9, 2020 at 1:45 PM Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > On Sat, May 09, 2020 at 11:15:58AM +0000, Stefan Chulski wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Matteo Croce <mcroce@redhat.com>
> > > > > > Sent: Saturday, May 9, 2020 3:13 AM
> > > > > > To: David S . Miller <davem@davemloft.net>
> > > > > > Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>; netdev
> > > > > > <netdev@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; Antoine
> > > > > > Tenart <antoine.tenart@bootlin.com>; Thomas Petazzoni
> > > > > > <thomas.petazzoni@bootlin.com>; gregory.clement@bootlin.com;
> > > > > > miquel.raynal@bootlin.com; Nadav Haklai <nadavh@marvell.com>; Stefan
> > > > > > Chulski <stefanc@marvell.com>; Marcin Wojtas <mw@semihalf.com>; Linux
> > > > > > ARM <linux-arm-kernel@lists.infradead.org>; Russell King - ARM Linux admin
> > > > > > <linux@armlinux.org.uk>
> > > > > > Subject: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to
> > > > > > handle RSS tables
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > What do you think about temporarily disabling it like this?
> > > > > >
> > > > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > > > @@ -5775,7 +5775,8 @@ static int mvpp2_port_probe(struct platform_device
> > > > > > *pdev,
> > > > > >                             NETIF_F_HW_VLAN_CTAG_FILTER;
> > > > > >
> > > > > >         if (mvpp22_rss_is_supported()) {
> > > > > > -               dev->hw_features |= NETIF_F_RXHASH;
> > > > > > +               if (port->phy_interface != PHY_INTERFACE_MODE_SGMII)
> > > > > > +                       dev->hw_features |= NETIF_F_RXHASH;
> > > > > >                 dev->features |= NETIF_F_NTUPLE;
> > > > > >         }
> > > > > >
> > > > > >
> > > > > > David, is this "workaround" too bad to get accepted?
> > > > >
> > > > > Not sure that RSS related to physical interface(SGMII), better just remove NETIF_F_RXHASH as "workaround".
> > > >
> > > > Hmm, I'm not sure this is the right way forward.  This patch has the
> > > > effect of disabling:
> > > >
> > > > d33ec4525007 ("net: mvpp2: add an RSS classification step for each flow")
> > > >
> > > > but the commit you're pointing at which caused the regression is:
> > > >
> > > > 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
> > > >
> > > >
> > >
> > > Hi,
> > >
> > > When git bisect pointed to 895586d5dc32 ("net: mvpp2: cls: Use RSS
> > > contexts to handle RSS tables"), which was merged
> > > almost an year after d33ec4525007 ("net: mvpp2: add an RSS
> > > classification step for each flow"), so I assume that between these
> > > two commits either the feature was working or it was disable and we
> > > didn't notice
> > >
> > > Without knowing what was happening, which commit should my Fixes tag point to?
> >
> > Let me make sure that I get this clear:
> >
> > - Prior to 895586d5dc32, you can turn on and off rxhash without issue
> >   on any port.
> > - After 895586d5dc32, turning rxhash on eth2 prevents reception.
> >
> > Prior to 895586d5dc32, with rxhash on, it looks like hashing using
> > CRC32 is supported but only one context.  So, if it's possible to
> > enable rxhash on any port on the mcbin without 895586d5dc32, and the
> > port continues to work, I'd say the bug was introduced by
> > 895586d5dc32.
> >
> > Of course, that would be reinforced if there was a measurable
> > difference in performance due to rxhash on each port.
>
> I've just run this test, but I can detect no difference in performance
> with or without 895586d5dc32 on eth0 or eth2 on the mcbin (apart from
> eth2 stopping working with 895586d5dc32 applied.)  I tested this by
> reverting almost all changes to the mvpp2 driver between 5.6 and that
> commit.
>
> That's not too surprising; I'm using my cex7 platform with the Mellanox
> card in for one end of the 10G link, and that platform doesn't seem to
> be able to saturdate a 10G link - it only seems to manage around 4Gbps.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
>

Well it depends on the traffic type. I used to generate 5k flows with
T-Rex and an Intel X710 card.
This way t-rex changes the UDP port of every packet:

root@macchiatobin:~# tcpdump -tnni eth0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
IP 16.0.0.18.9874 > 48.0.0.81.2001: UDP, length 18
IP 16.0.0.248.56289 > 48.0.192.56.2001: UDP, length 18
IP 16.0.0.154.44965 > 48.0.128.26.2001: UDP, length 18
IP 16.0.0.23.31363 > 48.0.0.86.2001: UDP, length 18
IP 16.0.0.192.1674 > 48.0.192.63.2001: UDP, length 18
IP 16.0.0.155.62370 > 48.0.128.27.2001: UDP, length 18
IP 16.0.0.30.22126 > 48.0.0.93.2001: UDP, length 18
IP 16.0.0.195.51329 > 48.0.192.66.2001: UDP, length 18
IP 16.0.0.160.18323 > 48.0.128.32.2001: UDP, length 18
IP 16.0.0.199.55413 > 48.0.192.70.2001: UDP, length 18

And here RX hash gives a huge performance gain.

root@macchiatobin:~# utraf eth0
tx: 0 bps 0 pps rx: 425.5 Mbps 886.5 Kpps
tx: 0 bps 0 pps rx: 426.0 Mbps 887.6 Kpps
tx: 0 bps 0 pps rx: 425.3 Mbps 886.1 Kpps
tx: 0 bps 0 pps rx: 425.2 Mbps 885.8 Kpps
root@macchiatobin:~# ethtool -K eth0 rxhash on
root@macchiatobin:~# utraf eth0
tx: 0 bps 0 pps rx: 1595 Mbps 3323 Kpps
tx: 0 bps 0 pps rx: 1593 Mbps 3319 Kpps
tx: 0 bps 0 pps rx: 1595 Mbps 3323 Kpps
tx: 0 bps 0 pps rx: 1594 Mbps 3320 Kpps

utraf is just a tool which reads netlink statistics, packets are
dropped with a tc rule.

Regards,
-- 
Matteo Croce
per aspera ad upstream

