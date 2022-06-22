Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5B4554938
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347612AbiFVKWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 06:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346654AbiFVKWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 06:22:38 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD203B3D8
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:22:37 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id c30so18749194ljr.9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/3scupapn9W2y2IwLBRCTxOKFHLpEAemTlHO5CeKx/A=;
        b=JRkeP6hK/0SBN+umjfYDlNvt5CfTBBZdNZh9CMRBuXf5udkHnZYDwm9Qugs9BISi7a
         c1tNL3TYOLT5YejRanE5NvVB8WoJ/bywqf9w01eTlwm88B+z/bFWIxXVbBQK2dx/AkjW
         DADt2URp3m+poaK/sxloGFC9fCWx3suat4BDkxsm0iHWOy1HH6XnNecf3W5NfVPo+T88
         LWhj1Ss4d92YRytTOVjwmH7jgh+qJNIh2W43PHSGO8UZnBNHxEZ4/o6ibaJUTqo8ds6j
         dFBb1zhzAg8Bshcy1mIgJX2mGUXxyrQ6wv5dI/VvT6VNm2K595qzOhBO1k0cIESp+ZAz
         Ha+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/3scupapn9W2y2IwLBRCTxOKFHLpEAemTlHO5CeKx/A=;
        b=7FFpcq6kNb4CJGsE+E8/vPtoUM26OmVfljdk1CXtNx8ekJwYGdR4aF9PaWKa6J3PLJ
         PtPXLPBXOSaXkh+7bfsp7Q8bcczvul1cFq4xIcC0GcriAAhdJHo9aKksxYhMxEsS3iOY
         Jac47u1WcQSevZ5I83LeLmJQRJxefnBD5/Av6hKVRnYRSeCo68soO4cy1Pl+qQmV74LV
         5Qa1MOH3jxwX8OgmCX484P2arnsk+PaRKnYHKpLzo19YJ4Mb93RkZw38b77YL+zppBZI
         paMbGUSHDN0rV1IFgqT1Dx7wo0YdDooVenhF/7uDTVQAdcKplkxvauwsoBwKyfnOKCFF
         3phg==
X-Gm-Message-State: AJIora8NIUsBciqtWdz3DoZIN2l95YVKwZp/ZrTEZMaR9dDeNLbo59va
        uRoUUHEY56tMjULCLESKXN3XVm5wkpb17XL6fyiKcA==
X-Google-Smtp-Source: AGRyM1se2BoPLHvWhFpwxYBadNS6jT4kJliR5w7Cbw9fSZJg6SHpakhu5R0sF3cJYRLKc74VRpNrRHZevfSU0YtBG8k=
X-Received: by 2002:a2e:860e:0:b0:25a:6dbe:abb5 with SMTP id
 a14-20020a2e860e000000b0025a6dbeabb5mr1516302lji.474.1655893355719; Wed, 22
 Jun 2022 03:22:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch> <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
 <YrGpDgtm4rPkMwnl@lunn.ch> <YrGukfw4uiQz0NpW@smile.fi.intel.com>
 <CAPv3WKf_2QYh0F2LEr1DeErvnMeQqT0M5t40ROP2G6HSUwKpQQ@mail.gmail.com> <YrLft+BrP2jI5lwp@lunn.ch>
In-Reply-To: <YrLft+BrP2jI5lwp@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 22 Jun 2022 12:22:23 +0200
Message-ID: <CAPv3WKcAPb1Kc7=YpfmOWKa_kZYQvN8HyvjG91SiMK9c8yZa-Q@mail.gmail.com>
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA description
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 22 cze 2022 o 11:24 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> On Wed, Jun 22, 2022 at 11:08:13AM +0200, Marcin Wojtas wrote:
> > wt., 21 cze 2022 o 13:42 Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> napisa=C5=82(a):
> > >
> > > On Tue, Jun 21, 2022 at 01:18:38PM +0200, Andrew Lunn wrote:
> > > > On Tue, Jun 21, 2022 at 02:09:14PM +0300, Andy Shevchenko wrote:
> > > > > On Mon, Jun 20, 2022 at 09:47:31PM +0200, Andrew Lunn wrote:
> > >
> > > ...
> > >
> > > > > > > +        Name (_CRS, ResourceTemplate ()
> > > > > > > +        {
> > > > > > > +            Memory32Fixed (ReadWrite,
> > > > > > > +                0xf212a200,
> > > > > > > +                0x00000010,
> > > > > >
> > > > > > What do these magic numbers mean?
> > > > >
> > > > > Address + Length, it's all described in the ACPI specification.
> > > >
> > > > The address+plus length of what? This device is on an MDIO bus. As
> > > > such, there is no memory! It probably makes sense to somebody who
> > > > knows ACPI, but to me i have no idea what it means.
> > >
> > > I see what you mean. Honestly I dunno what the device this descriptio=
n is for.
> > > For the DSA that's behind MDIO bus? Then it's definitely makes no sen=
se and
> > > MDIOSerialBus() resources type is what would be good to have in ACPI
> > > specification.
> > >
> >
> > It's not device on MDIO bus, but the MDIO controller's register itself
>
> Ah. So this is equivalent to
>
>                 CP11X_LABEL(mdio): mdio@12a200 {
>                         #address-cells =3D <1>;
>                         #size-cells =3D <0>;
>                         compatible =3D "marvell,orion-mdio";
>                         reg =3D <0x12a200 0x10>;
>                         clocks =3D <&CP11X_LABEL(clk) 1 9>, <&CP11X_LABEL=
(clk) 1 5>,
>                                  <&CP11X_LABEL(clk) 1 6>, <&CP11X_LABEL(c=
lk) 1 18>;
>                         status =3D "disabled";
>                 };
>
> DT seems a lot more readable, "marvell,orion-mdio" is a good hint that
> device this is. But maybe it is more readable because that is what i'm
> used to.

No worries, this reaction is not uncommon (including myself), I agree
it becomes more readable, the longer you work with it :).

IMO the ACPI node of orion-mdio looks very similar. Please take a look:

        Device (SMI0)
        {
            Name (_HID, "MRVL0100")              // _HID: Hardware ID
            Name (_UID, 0x00)                          // _UID: Unique ID
            Method (_STA)                                 // _STA: Device s=
tatus
            {
                Return (0xF)
            }
            Name (_CRS, ResourceTemplate ()
            {
                Memory32Fixed (ReadWrite,
                    0xf212a200,                        // Address Base
                    0x00000010,                       // Address Length
                    )
            })
        }

You can "map" the objects/methods to what you know from DT farly easily:
_HID -> compatible string
_STA -> 'status' property
_CRS & Memory32Fixed  -> 'reg' property (_CRS can also comprise IRQs
and other kind of resources, you can check [1] for more details).

Clocks are configured by firmware, so they are not referenced in the
tables and touched by the orion-mdio driver.

>
> Please could you add a lot more comments. Given that nobody currently
> actually does networking via ACPI, we have to assume everybody trying
> to use it is a newbie, and more comments are better than less.

I can add more verbose description of the example and probably a
reference to https://www.kernel.org/doc/Documentation/firmware-guide/acpi/d=
sd/phy.rst
("DSDT entry for MDIO node").

[1] https://uefi.org/specs/ACPI/6.4/06_Device_Configuration/Device_Configur=
ation.html#crs-current-resource-settings

Best regards,
Marcin

>
> Thanks
>         Andrew
