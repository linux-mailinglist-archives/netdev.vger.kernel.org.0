Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C72120299B
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgFUI0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:26:31 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35542 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbgFUI0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 04:26:30 -0400
Received: by mail-ot1-f66.google.com with SMTP id d4so10685273otk.2;
        Sun, 21 Jun 2020 01:26:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8jIlyp2B7ykXOcWiVp62uD7ENm39Ed6/smtH5dOsm2M=;
        b=WlDdisQ7AxF7BZksZ2zU7pDDaEabHMYizdGgm+qMZjrB0v0MhMU8C9Xsrk6dekQrZO
         p8iRNx6xLZQ6NxogJ6JRjmq84hYR+7cFU5UViUAKl++jnSjsG21KMOWNIP7xzTuS/Eob
         JkVtnjQTV7TrbtNh5ugHKJAiRq3Xe0bTDmKl1rlkp1trOFg70UjS/x4dQd0aRRuFe+Dh
         pVsscF0FiBhU7H8nkT6hMBcjrsTg8nm9I1w8W1c7pttuV+xWdaaz+ahwcwVkoFLqSFnq
         qIfNUz69fxsF5mYifqk0GY2DUGW2HcEXm2NWQ6os04GPQDNg+HNPT93w9EJZhaW/b0Ve
         XV+A==
X-Gm-Message-State: AOAM5322Dz8rtEpPRC9bUDG9R+vpkMx44/9Ys6kgKfcSkZ9fssbwUYlG
        h0PBmehRIIiMrwY8+zY769YDRnz2Lg1XuX/L3m4=
X-Google-Smtp-Source: ABdhPJygY7oFa/A9Kf3E95G6PnoadxKwUQtLuqblMJ2djDeLg7T6KT5IExuVAgpURBzJN2ZmWSIgPmN+Kt1YEheJgXg=
X-Received: by 2002:a9d:c29:: with SMTP id 38mr9054714otr.107.1592727988626;
 Sun, 21 Jun 2020 01:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200619191554.24942-1-geert+renesas@glider.be>
 <20200619191554.24942-2-geert+renesas@glider.be> <75d3e6c2-9dbd-eec0-12e6-55eaef7c745a@cogentembedded.com>
In-Reply-To: <75d3e6c2-9dbd-eec0-12e6-55eaef7c745a@cogentembedded.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 21 Jun 2020 10:26:17 +0200
Message-ID: <CAMuHMdWQ6kGZyUNfcNwrbQhnREA=U8TVpHD0cXPY9dWqFxvjhQ@mail.gmail.com>
Subject: Re: [PATCH/RFC 1/5] dt-bindings: net: renesas,ravb: Document internal
 clock delay properties
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
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

Hi Sergei,

On Sat, Jun 20, 2020 at 8:16 PM Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> On 06/19/2020 10:15 PM, Geert Uytterhoeven wrote:
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
> > @@ -64,6 +64,18 @@ Optional properties:
> >                        AVB_LINK signal.
> >  - renesas,ether-link-active-low: boolean, specify when the AVB_LINK signal is
> >                                active-low instead of normal active-high.
> > +- renesas,rxc-delay-ps: Internal RX clock delay.
> > +                     This property is mandatory and valid only on R-Car Gen3
> > +                     and RZ/G2 SoCs.
> > +                     Valid values are 0 and 1800.
> > +                     A non-zero value is allowed only if phy-mode = "rgmii".
> > +                     Zero is not supported on R-Car D3.
>
>    Hm, where did you see about the D3 limitation?

R-Car Gen3 Hardware User's Manual, Section 50.2.7 ("AVB-DMAC Product
Specific Register (APSR)"), "RDM" bit:

    For R-Car D3, delayed mode is only available

> > +- renesas,txc-delay-ps: Internal TX clock delay.
> > +                     This property is mandatory and valid only on R-Car H3,
> > +                     M3-W, M3-W+, M3-N, V3M, and V3H, and RZ/G2M and RZ/G2N.
> > +                     Valid values are 0 and 2000.
> > +                     A non-zero value is allowed only if phy-mode = "rgmii".
> > +                     Zero is not supported on R-Car V3H.
>
>   Same question about V3H here...

Same section, "TDM" bit:

    For R-Car V3H, delayed mode is only available.

> > @@ -105,8 +117,10 @@ Example:
> >                                 "ch24";
> >               clocks = <&cpg CPG_MOD 812>;
> >               power-domains = <&cpg>;
> > -             phy-mode = "rgmii-id";
> > +             phy-mode = "rgmii";
> >               phy-handle = <&phy0>;
> > +             renesas,rxc-delay-ps = <0>;
>
>    Mhm, zero RX delay in RGMII-ID mode?

Please ignore the actual contents of the old example.  It was based on a
very old DTS, which has received several fixes in the mean time.

Should have written:

    Update the (bogus) example accordingly.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
