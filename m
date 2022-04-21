Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427FE509546
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 05:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383884AbiDUDSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 23:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383885AbiDUDS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 23:18:29 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E109012630
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 20:15:41 -0700 (PDT)
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6F6073F1BA
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 03:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650510940;
        bh=+0+ClhRdXLW2hubvbQ5IqxsH3L1dNDpzr8HWzYvayno=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=I6/S6sLrGdLntsqqVn1WgCXaADtkzgmV0ywhCAj36bYNpr746m6cUNhf7TxMM4MJm
         fh1IxE62saQ3dTYr+H/aHWlX+XMCZf3+RPMeETJERoSIDirWKBtrTeZsMigHeaTQMi
         d4OU3A6mR8ne+NARa60uMN3TNrvO+PFzVPk0t0wcJ7L+WAWqHNpJd6+eff1LVl+2Os
         4JDSfSEydsM8hK0vfI9vzNnX/wNb591/YEzSuIf/tqYLY5s0ZmefxoMDipEcZCZ5vV
         AY65ynfHE87NaqCaZNAN6WQaRCuhDxlynP1t5uv/Dgg4qDX6kQOsb/2HW6PuDwDv8c
         Q/UkjF58KGOVw==
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-e5bae51cefso1615151fac.2
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 20:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+0+ClhRdXLW2hubvbQ5IqxsH3L1dNDpzr8HWzYvayno=;
        b=nqFQsueqP8+JYp69pHLglXDZLZtk72jY+LEFWaL75p+uHsnYgukEn5btbqdTGDWHeO
         Y7S/WIUhbbuzm9Nkf9h3f0T0a6JTyiyQ3J689FJ5IiTWsuVPlVeuzvabmnKf2pjz/dxL
         rwYqw3Kb2UCIrUlurEdmnC4bUxC+1B7gy+r1rMKFAkeec2Hp9s5cKHxS4J+rr58R1kVp
         noT1wjwGmQOOriTtcFik+Af3tXUmOjPfP+GGgMh2bmw3ZAju+S7n/M60odHhp4ndf4rL
         6QWJibuo6gj34QwesW7hmluqGxfiHb84EkaTaJgHCqiBO+qID4yzf8/u0gqTJ5eqcHZU
         YFHQ==
X-Gm-Message-State: AOAM533gxlbL/fRth0KC9JwGU7HFzeG0Y8St4ZPxyThYrAEK4rp5VBHl
        LSOPFw43i3EQoQFubLfR40gSl8YpRkwCBnjPw00XEYYWm4D0nGFqeWVn8dECSM5P5ddfFPPDRin
        duoJGoS476eRjCpnQoFEqBe0azPvjAktGWfbIgosLE8Uu28Qsag==
X-Received: by 2002:a05:6808:150f:b0:322:b58e:25df with SMTP id u15-20020a056808150f00b00322b58e25dfmr3077830oiw.198.1650510928634;
        Wed, 20 Apr 2022 20:15:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhg3+9T4s/rWh8JvLvAFuz/WcHkgn1DBqBbpYUDx/b04IET96QLHj9ebsB+xczCwrVG2jEeAd05jataomGc78=
X-Received: by 2002:a05:6808:150f:b0:322:b58e:25df with SMTP id
 u15-20020a056808150f00b00322b58e25dfmr3077818oiw.198.1650510928399; Wed, 20
 Apr 2022 20:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-3-kai.heng.feng@canonical.com> <YmAEDbJJU1hLNSY1@lunn.ch>
In-Reply-To: <YmAEDbJJU1hLNSY1@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Thu, 21 Apr 2022 11:15:16 +0800
Message-ID: <CAAd53p5XC1BF2Tp7C9-BKdHTz68S0ZcsMgR4bRTzaptGoO0T0Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] net: mdio: Add "use-firmware-led" firmware property
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 9:01 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Apr 20, 2022 at 08:40:49PM +0800, Kai-Heng Feng wrote:
> > Some system may prefer preset PHY LED setting instead of the one
> > hardcoded in the PHY driver, so adding a new firmware
> > property, "use-firmware-led", to cope with that.
> >
> > On ACPI based system the ASL looks like this:
> >
> >     Scope (_SB.PC00.OTN0)
> >     {
> >         Device (PHY0)
> >         {
> >             Name (_ADR, One)  // _ADR: Address
> >             Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
> >             {
> >                 ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */,
> >                 Package (0x01)
> >                 {
> >                     Package (0x02)
> >                     {
> >                         "use-firmware-led",
> >                         One
> >                     }
> >                 }
> >             })
> >         }
> >
> >         Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
> >         {
> >             ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */,
> >             Package (0x01)
> >             {
> >                 Package (0x02)
> >                 {
> >                     "phy-handle",
> >                     PHY0
> >                 }
> >             }
> >         })
> >     }
> >
> > Basically use the "phy-handle" reference to read the "use-firmware-led"
> > boolean.
>
> Please update Documentation/firmware-guide/acpi/dsd/phy.rst
>
> Please also Cc: the ACPI list. I have no idea what the naming
> convention is for ACPI properties.
>
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> >  drivers/net/mdio/fwnode_mdio.c | 4 ++++
> >  include/linux/phy.h            | 1 +
> >  2 files changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> > index 1c1584fca6327..bfca67b42164b 100644
> > --- a/drivers/net/mdio/fwnode_mdio.c
> > +++ b/drivers/net/mdio/fwnode_mdio.c
> > @@ -144,6 +144,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> >        */
> >       if (mii_ts)
> >               phy->mii_ts = mii_ts;
> > +
> > +     phy->use_firmware_led =
> > +             fwnode_property_read_bool(child, "use-firmware-led");
> > +
>
> This is an ACPI only property. It is not valid in DT. It does not
> fulfil the DT naming requirement etc. So please move this up inside
> the if (is_acpi_node(child)) clause.
>
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 36ca2b5c22533..53e693b3430ec 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -656,6 +656,7 @@ struct phy_device {
> >       /* Energy efficient ethernet modes which should be prohibited */
> >       u32 eee_broken_modes;
> >
> > +     bool use_firmware_led;
>
> There is probably a two byte hole after mdix_ctrl. So please consider
> adding it there. Also, don't forget to update the documentation.

OK, will do once other concerns are ironed out.

Kai-Heng

>
>        Andrew
