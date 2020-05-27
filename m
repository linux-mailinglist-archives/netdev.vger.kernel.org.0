Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA921E4DE9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgE0TLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:11:37 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42573 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgE0TLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 15:11:36 -0400
Received: by mail-ot1-f65.google.com with SMTP id z3so432194otp.9;
        Wed, 27 May 2020 12:11:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4UwtHfFWMV3qXkAccsrvoTcDY714sRSlKD/SKxmCGLI=;
        b=orHWAhzFEq2xuFBRzFpSWV3D3/l5vA0oRh+e+8RJwsNA1bi8cpHpAwuom2OkV1yxNA
         WI8+eDGTFxef0fu297EH00FLjaHeXgpAEiMFLoBBwWaORchMH1qqlojDcP5ydGXnDJvc
         4tGJyFt/Ypo/eV8LEU40LrdJwvTgC+wea8lqtL0Cu95pp0cVN9+8W7CYwZAjJj4oUFb6
         S+Oe0HwNpzBPTWO6kNXj6xw+iBA+ZDE7fTxxycMJwIQO2c/1Gw2Pcvv7RRb8bFXwO1Bt
         qPK3kq7/pU3kGFxT99i4InspNAo16NHfC5uCd+DRSeQeMOhsV6szH+1m6ZWvoRO/dRPU
         cSIw==
X-Gm-Message-State: AOAM532T35zjsoISHaAOSU4+iTmDMro7M8LcgRlBC4ywk/mV8GGTvdKZ
        kbMH8hyM79fq4TE1bCBdqPHGU53Z6NK1/DRGZwCaTl6D
X-Google-Smtp-Source: ABdhPJyaTY5wjUliK9I6+q6c1jUR+OXiSOkM1Fh8CT5hi9v2ptJfVs6ZM+h9VJBPlQ5EQfM4ZGhEnLDpf9oAtnvb47c=
X-Received: by 2002:a05:6830:18d9:: with SMTP id v25mr5412441ote.107.1590606693392;
 Wed, 27 May 2020 12:11:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
 <20200428154718.GA24923@lunn.ch> <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
 <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com> <20200429092616.7ug4kdgdltxowkcs@pengutronix.de>
In-Reply-To: <20200429092616.7ug4kdgdltxowkcs@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 27 May 2020 21:11:21 +0200
Message-ID: <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
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

Hi Oleksij,

On Wed, Apr 29, 2020 at 11:26 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> On Wed, Apr 29, 2020 at 10:45:35AM +0200, Geert Uytterhoeven wrote:
> > On Tue, Apr 28, 2020 at 6:16 PM Philippe Schenker
> > <philippe.schenker@toradex.com> wrote:
> > > On Tue, 2020-04-28 at 17:47 +0200, Andrew Lunn wrote:
> > > > On Tue, Apr 28, 2020 at 05:28:30PM +0200, Geert Uytterhoeven wrote:
> > > > > This triggers on Renesas Salvator-X(S):
> > > > >
> > > > >     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00:
> > > > > *-skew-ps values should be used only with phy-mode = "rgmii"
> > > > >
> > > > > which uses:
> > > > >
> > > > >         phy-mode = "rgmii-txid";
> > > > >
> > > > > and:
> > > > >
> > > > >         rxc-skew-ps = <1500>;
> > > > >
> > > > > If I understand Documentation/devicetree/bindings/net/ethernet-
> > > > > controller.yaml
> > > > > correctly:
> > > >
> > > > Checking for skews which might contradict the PHY-mode is new. I think
> > > > this is the first PHY driver to do it. So i'm not too surprised it has
> > > > triggered a warning, or there is contradictory documentation.
> > > >
> > > > Your use cases is reasonable. Have the normal transmit delay, and a
> > > > bit shorted receive delay. So we should allow it. It just makes the
> > > > validation code more complex :-(
> > >
> > > I reviewed Oleksij's patch that introduced this warning. I just want to
> > > explain our thinking why this is a good thing, but yes maybe we change
> > > that warning a little bit until it lands in mainline.
> > >
> > > The KSZ9031 driver didn't support for proper phy-modes until now as it
> > > don't have dedicated registers to control tx and rx delays. With
> > > Oleksij's patch this delay is now done accordingly in skew registers as
> > > best as possible. If you now also set the rxc-skew-ps registers those
> > > values you previously set with rgmii-txid or rxid get overwritten.

While I don't claim that the new implementation is incorrect, my biggest
gripe is that this change breaks existing setups (cfr. Grygorii's report,
plus see below).  People fine-tuned the parameters in their DTS files
according to the old driver behavior, and now have to update their DTBs,
which violates DTB backwards-compatibility rules.
I know it's ugly, but I'm afraid the only backwards-compatible solution
is to add a new DT property to indicate if the new rules apply.

> > > We chose the warning to occur on phy-modes 'rgmii-id', 'rgmii-rxid' and
> > > 'rgmii-txid' as on those, with the 'rxc-skew-ps' value present,
> > > overwriting skew values could occur and you end up with values you do
> > > not wanted. We thought, that most of the boards have just 'rgmii' set in
> > > phy-mode with specific skew-values present.
> > >
> > > @Geert if you actually want the PHY to apply RXC and TXC delays just
> > > insert 'rgmii-id' in your DT and remove those *-skew-ps values. If you
> >
> > That seems to work for me, but of course doesn't take into account PCB
> > routing.

Of course I talked too soon.  Both with the existing DTS that triggers
the warning, and after changing the mode to "rgmii-id", and dropping the
*-skew-ps values, Ethernet became flaky on R-Car M3-W ES1.0.  While the
system still boots, it boots very slow.
Using nuttcp, I discovered TX performance dropped from ca. 400 Mbps to
0.1-0.3 Mbps, while RX performance looks unaffected.

So I did some more testing:
  1. Plain "rgmii-txid" and "rgmii" break the network completely, on all
     R-Car Gen3 platforms,
  2. "rgmii-id" and "rgmii-rxid" work, but cause slowness on R-Car M3-W,
  3. "rgmii" with *-skew-ps values that match the old values (default
     420 for everything, but default 900 for txc-skew-ps, and the 1500
     override for rxc-skew-ps), behaves exactly the same as "rgmii-id",
  4. "rgmii-txid" with *-skew-ps values that match the old values does
work, i.e.
     adding to arch/arm64/boot/dts/renesas/salvator-common.dtsi:
     +               rxd0-skew-ps = <420>;
     +               rxd1-skew-ps = <420>;
     +               rxd2-skew-ps = <420>;
     +               rxd3-skew-ps = <420>;
     +               rxdv-skew-ps = <420>;
     +               txc-skew-ps = <900>;
     +               txd0-skew-ps = <420>;
     +               txd1-skew-ps = <420>;
     +               txd2-skew-ps = <420>;
     +               txd3-skew-ps = <420>;
     +               txen-skew-ps = <420>;

You may wonder what's the difference between 3 and 4? It's not just the
PHY driver that looks at phy-mode!
drivers/net/ethernet/renesas/ravb_main.c:ravb_set_delay_mode() also
does, and configures an additional TX clock delay of 1.8 ns if TXID is
enabled.  Doing so fixes R-Car M3-W, but doesn't seem to be needed,
or harm, on R-Car H3 ES2.0 and R-Car M3-N.

> > Using "rgmii" without any skew values makes DHCP fail on R-Car H3 ES2.0,
> > M3-W (ES1.0), and M3-N (ES1.0). Interestingly, DHCP still works on R-Car
> > H3 ES1.0.

FTR, the reason R-Car H3 ES1.0 is not affected is that the driver limits
its maximum speed to 100 Mbps, due to a hardware erratum.

So, how to proceed?
Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
