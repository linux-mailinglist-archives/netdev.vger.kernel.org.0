Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1202650D1BF
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 14:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiDXNA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 09:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiDXNA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 09:00:28 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8087712A9F2
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 05:57:28 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id n63so2262167ybn.11
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 05:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qmtIFptWMRA8qS+AOTNBa5g5ggHQNo6aqpELlxy2Zrk=;
        b=ggVWQHuUWBjHGTIKOf05ByEQgMsv7iDyLiC8l6mQJyn43YlKC94o/DF3w28TBzQIgt
         A284htmVI1eZbBAgXnwmPIK4TUqgYe1WG+zlOtg1BjXkEcXrxmYs31rIpbIq47Z3Scbo
         INa3EbTidTGr4aH4Q0k+Ch3/5W/VCIUHix3wNmp+uBSy3UjHPHJoTyJ+O7KYnLR0rumy
         j4fXiB0P1TtO2V2opE6Pd+pkO944HncEqegzrlBkS8ji46IhW2BaEFK4X/759vYB5EOd
         T7/axqTuFRULG1X7h5cKAPuJFGk1LGxwSozTmcsNmYEJ9UgEZ9cO4OOyoJWTFVfii4bN
         ra0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qmtIFptWMRA8qS+AOTNBa5g5ggHQNo6aqpELlxy2Zrk=;
        b=F1aAGO8wwjW9Es8IGzqbstHHAUTwXDLp60p8ZYCaBvcPemRmaUrC/WKjdZuyLBh7qw
         Lw2ELUdYo4EPuKN62Zg/zDjjF89RkwKBYcwoetrfddu/HHI2YEmvLOeoQpUAyVNiKd+n
         3qdR/AMlqBeT64pT0zgskA+dEXrIpjeUvtcGWl3TipZzSa650/V6drsP6MbqB4pQsFUl
         cVPcqXGitfGitg4IWoUrYwsbLQSMULeeb9YpN8YEoNIil/DayqRXHf2EV27j06q/3ehD
         qfX6CcAusY1snuEEWgeYC1SZqpVE/stMlX8h5dsuIn6pmA//kh59fJc2UMItKusLzObA
         EnxQ==
X-Gm-Message-State: AOAM532bURRR3EmY8plCRcnq692xVYEl6/lA8wDa/6JNRXtlcZBZnwHT
        BDmt8Ag1NnGJLfvw1XotXaU67eb1mCqs1t0EIlJk+w==
X-Google-Smtp-Source: ABdhPJwp8MuffFE7HDcpRdAlmZwbiXW/QePc52LnrKt9GZc2to7TLMs7f47PgFbXh+3zNyzfjO18t51geXtiy5/03kA=
X-Received: by 2002:a25:e056:0:b0:645:d68d:8474 with SMTP id
 x83-20020a25e056000000b00645d68d8474mr9396114ybg.294.1650805047571; Sun, 24
 Apr 2022 05:57:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220423131427.237160-1-nathan@nathanrossi.com>
 <20220423131427.237160-2-nathan@nathanrossi.com> <YmQIHWL4iTS5qVIz@lunn.ch>
 <CA+aJhH3EtAxAKy8orC-SU8UnagBCibF3dHXrp78zfjuAzj4vUg@mail.gmail.com> <YmQeIL4XYdTFTNm7@lunn.ch>
In-Reply-To: <YmQeIL4XYdTFTNm7@lunn.ch>
From:   Nathan Rossi <nathan@nathanrossi.com>
Date:   Sun, 24 Apr 2022 22:57:16 +1000
Message-ID: <CA+aJhH1qDBEi18oz1NiWB3L7fjOT+Z9EdD5PfO7uZQ9K9u5wPQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: Handle single-chip-address OF property
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022 at 01:41, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Apr 24, 2022 at 12:41:22AM +1000, Nathan Rossi wrote:
> > On Sun, 24 Apr 2022 at 00:07, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Sat, Apr 23, 2022 at 01:14:27PM +0000, Nathan Rossi wrote:
> > > > Handle the parsing and use of single chip addressing when the switch has
> > > > the single-chip-address property defined. This allows for specifying the
> > > > switch as using single chip addressing even when mdio address 0 is used
> > > > by another device on the bus. This is a feature of some switches (e.g.
> > > > the MV88E6341/MV88E6141) where the switch shares the bus only responding
> > > > to the higher 16 addresses.
> > >
> > > Hi Nathan
> > >
> > > I think i'm missing something in this explanation:
> > >
> > > smi.c says:
> > >
> > > /* The switch ADDR[4:1] configuration pins define the chip SMI device address
> > >  * (ADDR[0] is always zero, thus only even SMI addresses can be strapped).
> > >  *
> > >  * When ADDR is all zero, the chip uses Single-chip Addressing Mode, assuming it
> > >  * is the only device connected to the SMI master. In this mode it responds to
> > >  * all 32 possible SMI addresses, and thus maps directly the internal devices.
> > >  *
> > >  * When ADDR is non-zero, the chip uses Multi-chip Addressing Mode, allowing
> > >  * multiple devices to share the SMI interface. In this mode it responds to only
> > >  * 2 registers, used to indirectly access the internal SMI devices.
> > >  *
> > >  * Some chips use a different scheme: Only the ADDR4 pin is used for
> > >  * configuration, and the device responds to 16 of the 32 SMI
> > >  * addresses, allowing two to coexist on the same SMI interface.
> > >  */
> > >
> > > So if ADDR = 0, it takes up the whole bus. And in this case reg = 0.
> > > If ADDR != 0, it is in multi chip mode, and DT reg = ADDR.
> > >
> > > int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
> > >                        struct mii_bus *bus, int sw_addr)
> > > {
> > >         if (chip->info->dual_chip)
> > >                 chip->smi_ops = &mv88e6xxx_smi_dual_direct_ops;
> > >         else if (sw_addr == 0)
> > >                 chip->smi_ops = &mv88e6xxx_smi_direct_ops;
> > >         else if (chip->info->multi_chip)
> > >                 chip->smi_ops = &mv88e6xxx_smi_indirect_ops;
> > >         else
> > >                 return -EINVAL;
> > >
> > > This seems to implement what is above. smi_direct_ops == whole bus,
> > > smi_indirect_ops == multi-chip mode.
> > >
> > > In what situation do you see this not working? What device are you
> > > using, what does you DT look like, and what at the ADDR value?
> >
> > The device I am using is the MV88E6141, it follows the second scheme
> > such that it only responds to the upper 16 of the 32 SMI addresses in
> > single chip addressing mode. I am able to define the switch at address
> > 0, and everything works. However in the device I am using (Netgate
> > SG-3100) the ethernet phys for the non switch ethernet interfaces are
> > also on the same mdio bus as the switch. One of those phys is
> > configured with address 0. Defining both the ethernet-phy and switch
> > as address 0 does not work.
> >
> > The device tree I have looks like:
> >
> > &mdio {
> >     status = "okay";
> >     pinctrl-0 = <&mdio_pins>;
> >     pinctrl-names = "default";
> >
> >     phy0: ethernet-phy@0 {
> >         status = "okay";
> >         reg = <0>;
> >     };
> >
> >     phy1: ethernet-phy@1 {
> >         status = "okay";
> >         reg = <1>;
> >     };
>
> So normally, we would have
>
>
>     switch0: switch0@16 {
>         compatible = "marvell,mv88e6141", "marvell,mv88e6085";
>         single-chip-address;
>         reg = <0>;
>         dsa,member = <0 0>;
>         status = "okay";
>
> and then i guess you are seeing mdiobus_register_device() returning
> -EBUSY because the PHY is also at address 0?

Correct, that is the issue I am trying to solve here.

>
> This is what is missing from your explanation. It is always better to
> have more than less in the commit message.
>
> So the chip is using addresses 0x10-0x1f, but in order to probe, you
> need to put reg = 0, taking up slot 0, clashing with the PHY. Ideally
> we want to take up one of the slots in the range 0x10-0x1f. reg=16 on
> its own indicates multi-chip mode and the device is using address 16.
>
> O.K, a bit more digging into the datasheet:
>
> For multi-chip mode, for the 6341 family,
>
> The SMI address that is used is determined by the ADDR[3:0]
> configuration pins. ADDR[4] must be zero to select the device.
>
> So it can only take the address range 0-f, since ADDR[4] == 0.  So 16
> is not even a valid multi-chip address. But it is valid for some other
> chips.
>
> So your DT property is says, ignore reg, i really am in single chip
> mode.
>
> This appears to be a general problem for any device with
> .port_base_addr = 0x10.

I had initially thought of using the port_base_addr along with setting
up an of_match for the 6141 to provide compat_info which smi init
could use.

>
> I'm wondering if a better solution to this is special case
> reg=16. First try mv88e6xxx_detect() in single chip mode. That will
> read register 3. A read should be safe. If we get back a valid ID for
> a switch, keep with single chip mode. Otherwise swap to multi-chip
> mode. A multi-chip mv88e6xxx_detect() is more dangerous, because that
> involves writes.

I tested this idea and have sent out a patch for it
(https://lore.kernel.org/netdev/20220424125451.295435-1-nathan@nathanrossi.com/).
It works correctly for the single chip detection case and safely falls
through on other multi-chip addresses. It would be great if you could
test this on the armada 370 rd board with reg=16.

However just a side note, I had to move the reset gpio setup to occur
before the smi init. Interestingly I am not sure if there was a reason
for the reset to be unconfigured before setting up smi, it seems that
might cause issues with the multi-chip smi init ops?

Thanks,
Nathan



>
> Looking at the existing DTs, there are only two using multi-chip mode
> with reg=16:
>
> arm/boot/dts/armada-370-rd.dts-         reg = <0x10>;
> arm/boot/dts/kirkwood-linksys-viper.dts-                reg = <16>;
>
> And i happen to have an armada-370-rd :-)
>
>     Andrew
