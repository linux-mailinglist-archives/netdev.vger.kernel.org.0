Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C91E1E7A5A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgE2KRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:17:51 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40439 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2KRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 06:17:48 -0400
Received: by mail-ot1-f68.google.com with SMTP id d26so1517350otc.7;
        Fri, 29 May 2020 03:17:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9BmuzUr28lndKnWGaiy4syXkTAirc9FJ7D/uyoX+nc=;
        b=rqcqOfTwryeHHXY72Env8yrho+Q65A+BXv9NfPv3/Khjm2+avFSxx7nJiHDDLLCcc+
         W+hylBs8dDpayZXCbi5XFRNUWRGCcexcmnpdqNTxodAVd9+0FoFL5kz+6nKPFiyQcLaN
         wSF+FsO90K4rbLS/BPpak2MNdmf/7Y0/N2+hWFB8GjZTgMzqvhPI7RO3s8WGazpXedhq
         HmSU3HFkVPcc8QRBHC7Wa9gwbbsQJdPBz/OeSsz5xx2MPX6lwGGtGX9JxGNpvxV6eq1s
         vAk9uD1zftAMS6P7wIlEscUllxCkazSXGkw+7fq5BOs853tAtWYReDRpYCq5htBAKJX7
         8Ylg==
X-Gm-Message-State: AOAM530dhyk3GDIcQlCxyfyJCfAj3HWgjyJZ80oortn6gZJI3zM0QCBT
        6FmAjq0BdNh8ouKQ9S84O/vHR7ajF2eGGzXeATc=
X-Google-Smtp-Source: ABdhPJxYlXmYWJSTbTVK16+swo/L6kueAvtmF+PmbbiKpVdS/0VV2PW8/+MR+uaZBhrM33Nkn4EV4c1oiIvOxCpXzAs=
X-Received: by 2002:a05:6830:1151:: with SMTP id x17mr5562112otq.250.1590747467553;
 Fri, 29 May 2020 03:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
 <20200428154718.GA24923@lunn.ch> <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
 <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
 <20200429092616.7ug4kdgdltxowkcs@pengutronix.de> <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
 <20200527205221.GA818296@lunn.ch> <CAMuHMdU+MR-2tr3-pH55G0GqPG9HwH3XUd=8HZxprFDMGQeWUw@mail.gmail.com>
 <20200528160839.GE840827@lunn.ch>
In-Reply-To: <20200528160839.GE840827@lunn.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 29 May 2020 12:17:36 +0200
Message-ID: <CAMuHMdUXC8O8fqfDkbV+LzoPH5Jke0rZroGQiUihW31-yhGckg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, May 28, 2020 at 6:08 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, May 28, 2020 at 03:10:06PM +0200, Geert Uytterhoeven wrote:
> > On Wed, May 27, 2020 at 10:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > > You may wonder what's the difference between 3 and 4? It's not just the
> > > > PHY driver that looks at phy-mode!
> > > > drivers/net/ethernet/renesas/ravb_main.c:ravb_set_delay_mode() also
> > > > does, and configures an additional TX clock delay of 1.8 ns if TXID is
> > > > enabled.
> > >
> > > That sounds like a MAC bug. Either the MAC insert the delay, or the
> > > PHY does. If the MAC decides it is going to insert the delay, it
> > > should be masking what it passes to phylib so that the PHY does not
> > > add a second delay.
> >
> > And so I gave this a try, and modified the ravb driver to pass "rgmii"
> > to the PHY if it has inserted a delay.
> > That fixes the speed issue on R-Car M3-W!
> > And gets rid of the "*-skew-ps values should be used only with..."
> > message.
> >
> > I also tried if I can get rid of "rxc-skew-ps = <1500>". After dropping
> > the property, DHCP failed.  Compensating by changing the PHY mode in DT
> > from "rgmii-txid" to "rgmii-id" makes it work again.
>
> In general, i suggest that the PHY implements the delay, not the MAC.
> Most PHYs support it, where as most MACs don't. It keeps maintenance
> and understanding easier, if everything is the same. But there are
> cases where the PHY does not have the needed support, and the MAC does
> the delays.

I can confirm disabling the MAC delay ("phy-mode = "rgmii""), and adding
a PHY delay ("txc-skew-ps = <1500>") also fixes the slowness on
Salvator-X with R-Car M3-W ES1.0.

However, I would like to be a cit cautious here: on Ebisu with R-Car E3,
the hardware engineers advised to add "max-speed = <100>", as EtherAVB
on R-Car E3 does not support the MAC delay, and the KSZ9031 does not
allow sufficient delay, leading to unreliable communication.
Nevertheless, I never had problems without that limitation, and 1 Gbps
still seems to work after removing it, with and without "txc-skew-ps =
<1500>".

> > However, given Philippe's comment that the rgmi-*id apply to the PHY
> > only, I think we need new DT properties for enabling MAC internal delays.
>
> Do you actually need MAC internal delays?

Given the Ebisu issue, I think we do.
Note that the EtherAVB MAC TX delay, when enabled, is 2.0 ns, and
KSZ9031 supports 0..1860 ps, with 900 ps being the centerpoint, so AFAIU
that is -900..960 ps, i.e. much less than 2.0 ns.

> > To fix the issue, I came up with the following problem statement and
> > plan:
> >
> > A. Old behavior:
> >
> >   1. ravb acts upon "rgmii-*id" (on SoCs that support it[1]),
> >   2. ksz9031 ignored "rgmii-*id", using hardware defaults for skew
> >      values.
>
> So two bugs which cancelled each other out :-)
>
> > B. New behavior (broken):
> >
> >   1. ravb acts upon "rgmii-*id",
> >   2. ksz9031 acts upon "rgmii-*id".
> >
> > C. Quick fix for v5.8 (workaround, backwards-compatible with old DTB):
> >
> >   1. ravb acts upon "rgmii-*id", but passes "rgmii" to phy,
> >   2. ksz9031 acts upon "rgmi", using new "rgmii" skew values.
> >
> > D. Long-term fix:
>
> I don't know if it is possible, but i would prefer that ravb does
> nothing and the PHY does the delay. The question is, can you get to
> this state without more things breaking?

While that seems to work for me, the delay would be a bit too small to work
reliably, according to the hardware engineers.

Hence my proposal for C now, to fix the regressions, and D later.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
