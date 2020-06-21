Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7CC202995
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgFUIXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:23:34 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45034 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbgFUIXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 04:23:33 -0400
Received: by mail-ot1-f67.google.com with SMTP id e5so10640442ote.11;
        Sun, 21 Jun 2020 01:23:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f/kB5/LF7NNLl7k0mRVPW29dPix+BPuhFaQSmA6xWOA=;
        b=lc05jH9a2BKY6C6gatuIVjXVpLESU9kj1N+rB+BWNCB/NishjuyMZ8yBaVKMsCFbiS
         4lFMePs+11yzWSX8evYu6tevOxQ9om6+lo8xeESi9lGnd3kv16LYMxkyqx/cdzBbrgty
         hUV6yAs7iyYzXgEDtxgcP0QYUubrg3OCn+xww/NSFtZ5p4qfFvPfhe0ZKLCwKauUZNyG
         FqSNjgy96DEdVEBpYWmD/wA+lPGwu2117pMeoU+j+Ni9IX1cc4+ctzIj6E5uOnzpkKtZ
         HRLgAGsenu11mGF+NrPDNLWLjDtmv7JweQ6LqwH7RsWCZXYwUFnlv2MluNPLZRBkbKMR
         kQaQ==
X-Gm-Message-State: AOAM533J75prkn7uNfsDZ7k3nLCdPTIr2dM20Ksr1JDpsPf1YP6wEHX3
        CYocze4Efmkmq7llNsLJZV7PB0u73p/F+cQesy8KJCun
X-Google-Smtp-Source: ABdhPJxnrBI3Za7j7Qw4MtU9IVf31ymKxJ/yLGGSPsCdFiRxrP8l6kk2AYb2dZMzOIiojzJQWy/XoAxoxklOcL26B1w=
X-Received: by 2002:a9d:62c2:: with SMTP id z2mr9389469otk.145.1592727812671;
 Sun, 21 Jun 2020 01:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200619191554.24942-1-geert+renesas@glider.be>
 <20200619191554.24942-2-geert+renesas@glider.be> <e6d0bfc5-9d75-2dc9-2bfa-671c32cb0b7c@rempel-privat.de>
In-Reply-To: <e6d0bfc5-9d75-2dc9-2bfa-671c32cb0b7c@rempel-privat.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 21 Jun 2020 10:23:00 +0200
Message-ID: <CAMuHMdWFA9YoeMgHGbhvW7Mqv6tBgcpqyYvWdNc1Vdn23KebLg@mail.gmail.com>
Subject: Re: [PATCH/RFC 1/5] dt-bindings: net: renesas,ravb: Document internal
 clock delay properties
To:     Oleksij Rempel <linux@rempel-privat.de>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Sat, Jun 20, 2020 at 7:47 AM Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 19.06.20 um 21:15 schrieb Geert Uytterhoeven:
> > Some EtherAVB variants support internal clock delay configuration, which
> > can add larger delays than the delays that are typically supported by
> > the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
> > properties).
> >
> > Add properties for configuring the internal MAC delays.
> > These properties are mandatory, even when specified as zero, to
> > distinguish between old and new DTBs.
> >
> > Update the example accordingly.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

> > --- a/Documentation/devicetree/bindings/net/renesas,ravb.txt
> > +++ b/Documentation/devicetree/bindings/net/renesas,ravb.txt

> > +                     This property is mandatory and valid only on R-Car Gen3
> > +                     and RZ/G2 SoCs.
> > +                     Valid values are 0 and 1800.
> > +                     A non-zero value is allowed only if phy-mode = "rgmii".
> > +                     Zero is not supported on R-Car D3.
> > +- renesas,txc-delay-ps: Internal TX clock delay.
> > +                     This property is mandatory and valid only on R-Car H3,
> > +                     M3-W, M3-W+, M3-N, V3M, and V3H, and RZ/G2M and RZ/G2N.
> > +                     Valid values are 0 and 2000.
>
> In the driver i didn't found sanity check for valid values.

As EtherAVB supports only zero and a single non-zero value, I didn't
bother validating the actual non-zero value in the driver.

However, I did implement full validation in the json-schema version of
the DT bindings, cfr. "[PATCH/RFC] dt-bindings: net: renesas,etheravb:
Convert to json-schema"
(https://lore.kernel.org/r/20200621081710.10245-1-geert+renesas@glider.be)
(In hindsight, I should not have postponed posting that patch)

> > @@ -105,8 +117,10 @@ Example:
> >                                 "ch24";
> >               clocks = <&cpg CPG_MOD 812>;
> >               power-domains = <&cpg>;
> > -             phy-mode = "rgmii-id";
> > +             phy-mode = "rgmii";
> >               phy-handle = <&phy0>;
> > +             renesas,rxc-delay-ps = <0>;
> > +             renesas,txc-delay-ps = <2000>;
> >
> >               pinctrl-0 = <&ether_pins>;
> >               pinctrl-names = "default";
> > @@ -115,18 +129,7 @@ Example:
> >               #size-cells = <0>;
> >
> >               phy0: ethernet-phy@0 {
> > -                     rxc-skew-ps = <900>;
> > -                     rxdv-skew-ps = <0>;
> > -                     rxd0-skew-ps = <0>;
> > -                     rxd1-skew-ps = <0>;
> > -                     rxd2-skew-ps = <0>;
> > -                     rxd3-skew-ps = <0>;
> > -                     txc-skew-ps = <900>;
> > -                     txen-skew-ps = <0>;
> > -                     txd0-skew-ps = <0>;
> > -                     txd1-skew-ps = <0>;
> > -                     txd2-skew-ps = <0>;
> > -                     txd3-skew-ps = <0>;
> > +                     rxc-skew-ps = <1500>;
>
>
> I'm curios, how this numbers ware taken?
> Old configurations was:
> TX delay:
> (txd*-skew-ps = 0) == -420ns
> (txc-skew-ps = 900) == 0ns
> resulting delays 0.420ns

Please ignore the actual contents of the old example.  It was based on a
very old DTS, which has received several fixes in the mean time.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
