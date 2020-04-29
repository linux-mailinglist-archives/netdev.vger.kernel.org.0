Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0775B1BD77E
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 10:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2Ips (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 04:45:48 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35189 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgD2Ips (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 04:45:48 -0400
Received: by mail-ot1-f68.google.com with SMTP id e26so1055714otr.2;
        Wed, 29 Apr 2020 01:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nZsuyZk+W3ZQ3D4T7ElXnkZvkP0cegNtGGjskMJOrWs=;
        b=mqq2Pg3HtS6DAgt1Zvas+71GJAk4oZLDN9sDO21dQ0qQ9jmlW2bJfPaYpdRu7nRHad
         MiJ4wyzdWnhM7J7HPJU/cEXVBqWA0VQCBJKPt8w0vBNdRx7fqUTGpKmDhosPwYP0lqoX
         PGXO0p42Rq6h91bYMgTmrLS7OuV8gFGqE2kYjCUnIKCnZVB3LeSdDiA+DWbpqArXDVVd
         /DZ4ZCfaJ7RHwcNIoeA9hcoRV6Uop5ED1BZVpci8pQtxPjt4KAuSVkwFR0BkmQtlv0Tv
         tWsQvABSInE8SnoHPyhKiZ9xevKMQrL1VOxnQ8SDf4pxITiA+l5l35zIqpu2V4EGhACF
         o0Uw==
X-Gm-Message-State: AGi0PuZNqnL+JOT6oYqjWqan4s85tOwHfMBBbOU480T0UsVBzXKAJOcM
        mNCs6LuamEs03lFaf2Rdazjn4nO9cQI689XeWbzs7Q==
X-Google-Smtp-Source: APiQypISoD3rKWZ6uVLPAZhyrACde80GeD/rrdp9qI+e6ZrUlQ2zKUSmtpFRopMPzmvn/lB4sCDboFc8p/Zu0MR6gWQ=
X-Received: by 2002:a9d:564:: with SMTP id 91mr25765762otw.250.1588149947154;
 Wed, 29 Apr 2020 01:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
 <20200428154718.GA24923@lunn.ch> <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
In-Reply-To: <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 29 Apr 2020 10:45:35 +0200
Message-ID: <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Philippe,

On Tue, Apr 28, 2020 at 6:16 PM Philippe Schenker
<philippe.schenker@toradex.com> wrote:
> On Tue, 2020-04-28 at 17:47 +0200, Andrew Lunn wrote:
> > On Tue, Apr 28, 2020 at 05:28:30PM +0200, Geert Uytterhoeven wrote:
> > > This triggers on Renesas Salvator-X(S):
> > >
> > >     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00:
> > > *-skew-ps values should be used only with phy-mode = "rgmii"
> > >
> > > which uses:
> > >
> > >         phy-mode = "rgmii-txid";
> > >
> > > and:
> > >
> > >         rxc-skew-ps = <1500>;
> > >
> > > If I understand Documentation/devicetree/bindings/net/ethernet-
> > > controller.yaml
> > > correctly:
> >
> > Checking for skews which might contradict the PHY-mode is new. I think
> > this is the first PHY driver to do it. So i'm not too surprised it has
> > triggered a warning, or there is contradictory documentation.
> >
> > Your use cases is reasonable. Have the normal transmit delay, and a
> > bit shorted receive delay. So we should allow it. It just makes the
> > validation code more complex :-(
>
> I reviewed Oleksij's patch that introduced this warning. I just want to
> explain our thinking why this is a good thing, but yes maybe we change
> that warning a little bit until it lands in mainline.
>
> The KSZ9031 driver didn't support for proper phy-modes until now as it
> don't have dedicated registers to control tx and rx delays. With
> Oleksij's patch this delay is now done accordingly in skew registers as
> best as possible. If you now also set the rxc-skew-ps registers those
> values you previously set with rgmii-txid or rxid get overwritten.
>
> We chose the warning to occur on phy-modes 'rgmii-id', 'rgmii-rxid' and
> 'rgmii-txid' as on those, with the 'rxc-skew-ps' value present,
> overwriting skew values could occur and you end up with values you do
> not wanted. We thought, that most of the boards have just 'rgmii' set in
> phy-mode with specific skew-values present.
>
> @Geert if you actually want the PHY to apply RXC and TXC delays just
> insert 'rgmii-id' in your DT and remove those *-skew-ps values. If you

That seems to work for me, but of course doesn't take into account PCB
routing.

> need custom timing due to PCB routing it was thought out to use the phy-
> mode 'rgmii' and do the whole required timing with the *-skew-ps values.

That mean we do have to provide all values again?
Using "rgmii" without any skew values makes DHCP fail on R-Car H3 ES2.0,
M3-W (ES1.0), and M3-N (ES1.0). Interestingly, DHCP still works on R-Car
H3 ES1.0.

Note that I'm not too-familiar with the actual skew values needed
(CC Mizuguchi-san).

Related commits:
  - 0e45da1c6ea6b186 ("arm64: dts: r8a7795: salvator-x: Fix
EthernetAVB PHY timing")
  - dda3887907d74338 ("arm64: dts: r8a7795: Use rgmii-txid phy-mode
for EthernetAVB")
  - 7eda14afb8843a0d ("arm64: dts: renesas: r8a77990: ebisu: Fix
EthernetAVB phy mode to rgmii")

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
