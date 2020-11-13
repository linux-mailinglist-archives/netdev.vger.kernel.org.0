Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAA02B269F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgKMV1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:27:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgKMV1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:27:12 -0500
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B382225B
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 21:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605302830;
        bh=s/oeWYvPmHATvY/vGGAagkTnjnJDbywL4bEC5h7jHok=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fMsSH+b/ZKyWB2CqBAr2jwxzCPszHZLPm8Ixtl9Nb+xXnthyKLpipIHcR8gGZuEYX
         OfCQIKf+00SEV/Y6rTX+Bc6TtbiH35K5NerhjtUMaah3WbxRZk4/LjXodNLRr6byZX
         MpCVPrUWxoje0s17CRCXdtTjS2onfukbmXY+Y1hU=
Received: by mail-oi1-f178.google.com with SMTP id w145so11931080oie.9
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:27:10 -0800 (PST)
X-Gm-Message-State: AOAM531HDggOLAnMqTJcHdRRyelVHtt9kQ1xDyUo5gmzlVv0aV7TmK6I
        kIU8DnW0pL5H+pgYJDRn7gJDU3d2ALjxJ3Hkmik=
X-Google-Smtp-Source: ABdhPJwWV/RyT5Vw3MzbCA3tB39LiWpiHpGpfR617g27Ul8VJy4aWcHITt2ES5BIDwzuIqVf1bmjvUgB3msLzj5xDb4=
X-Received: by 2002:aca:3c54:: with SMTP id j81mr2886427oia.11.1605302830170;
 Fri, 13 Nov 2020 13:27:10 -0800 (PST)
MIME-Version: 1.0
References: <20201017230226.GV456889@lunn.ch> <20201029143934.GO878328@lunn.ch>
 <20201029144644.GA70799@apalos.home> <2697795.ZkNf1YqPoC@kista>
 <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
 <20201113144401.GM1456319@lunn.ch> <CAK8P3a2iwwneb+FPuUQRm1JD8Pk54HCPnux4935Ok43WDPRaYQ@mail.gmail.com>
 <20201113165625.GN1456319@lunn.ch>
In-Reply-To: <20201113165625.GN1456319@lunn.ch>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 13 Nov 2020 22:26:53 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3ABKRYg_wyjz_zUPd+gE1=f3PsVs5Ac-y1jpa0+Kt1fA@mail.gmail.com>
Message-ID: <CAK8P3a3ABKRYg_wyjz_zUPd+gE1=f3PsVs5Ac-y1jpa0+Kt1fA@mail.gmail.com>
Subject: Re: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 5:57 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > Hi Arnd
> > >
> > > This PHY driver bug hiding DT bug is always hard to handle. We have
> > > been though it once before with the Atheros PHY. All the buggy DT
> > > files were fixed in about one cycle.
> >
> > Do you have a link to the problem for the Atheros PHY?
>
> commit cd28d1d6e52e740130745429b3ff0af7cbba7b2c
> Author: Vinod Koul <vkoul@kernel.org>
> Date:   Mon Jan 21 14:43:17 2019 +0530
>
>     net: phy: at803x: Disable phy delay for RGMII mode
>
>     For RGMII mode, phy delay should be disabled. Add this case along
>     with disable delay routines.
>
>     Signed-off-by: Vinod Koul <vkoul@kernel.org>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>
> and
>
> commit 6d4cd041f0af5b4c8fc742b4a68eac22e420e28c
> Author: Vinod Koul <vkoul@kernel.org>
> Date:   Thu Feb 21 15:53:15 2019 +0530
>
>     net: phy: at803x: disable delay only for RGMII mode
>
>     Per "Documentation/devicetree/bindings/net/ethernet.txt" RGMII mode
>     should not have delay in PHY whereas RGMII_ID and RGMII_RXID/RGMII_TXID
>     can have delay in PHY.
>
>     So disable the delay only for RGMII mode and enable for other modes.
>     Also treat the default case as disabled delays.
>
>     Fixes: cd28d1d6e52e: ("net: phy: at803x: Disable phy delay for RGMII mode")
>
> Looking at the git history, it seems like it also took two attempts to
> get it working correctly, but the time between the two patches was
> much shorted for the atheros PHY.

ok, thanks.

> > I agree this makes the problem harder, but I have still hope that
> > we can come up with a code solution that can deal with this
> > one board that needs to have the correct settings applied as well
> > as the others on which we have traditionally ignored them.
> >
> > As I understand it so far, the reason this board needs a different
> > setting is that the strapping pins are wired incorrectly, while all
> > other boards set them right and work correctly by default. I would
> > much prefer a way to identify this behavior in dts and have the phy
> > driver just warn when it finds a mismatch between the internal
> > delay setting in DT and the strapping pins but keep using the
> > setting from the strapping pins when there is a conflict.
>
> So what you are suggesting is that the pine board, and any other board
> which comes along in the future using this PHY which really wants
> RGMII, needs a boolean DT property:
>
> "realtek,IRealyDoWantRGMII_IAmNotBroken"
>
> in the PHY node?
>
> And if it is missing, we ignore when the MAC asks for RGMII and
> actually do RGMII_ID?

Something of that sort. I also see a similar patch in KSZ9031
now, see 7dd8f0ba88fc ("arm: dts: imx6qdl-udoo: fix rgmii phy-mode
for ksz9031 phy")

As this exact mismatch between rgmii and rgmii-id mode is apparently
a more widespread problem, the best workaround I can think of
is that we redefine the phy-mode="rgmii" property to actually mean
"use rgmii mode and let the phy driver decide the delay configuration",
with a new string to mean specifically rgmii mode with no delay.

That way, the existing behavior of all phy drivers would become
conformant, and we could change the one board that needs to
disable the internal delay to use the new property.

If we have three drivers that confused the meaning of
phy-mode="rgmii", there may still be others.

> We might also need to talk to the FreeBSD folks.
>
> https://reviews.freebsd.org/D13591
>
> Do we need to ask them to be bug compatible to Linux? Are the same DT
> file being used?

We are moving towards sharing the dts files better, yes.
In a lot of cases this does mean bug compatibility, the same
way that the DT support on Linux still has some quirks that
go back to bugs in MacOS or AIX on PowerPC.

> That still leaves ACPI systems. Do we want to stuff this DT property
> into an ACPI table? That seems to go against what ACPI people say
> saying, ACPI is not DT with an extra wrapper around it.

As far as I know, the only affected ACPI system has the same
issue and it should be handled the same way, also not requiring
a firmware update.

      Arnd
