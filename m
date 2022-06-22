Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADDE554EA2
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359016AbiFVPFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359001AbiFVPFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:05:53 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFE93A72E
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:05:43 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id c30so19707110ljr.9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kyUcdhzGFcDndqqzlq8u6bhrtYYzLp4ulxMjiB9uh5c=;
        b=C+EQKQ+Z8Vj1vQdoeE5hwXUYHEKkxl5yDsbmhz3+uTszsXb7+8IqY870rcQtZMmMve
         VpiNN0O7wAe+fRNcuPfvtOeJzsJzJJeFexeMUUihMgs5+xELfjcSKzNE6Tw7an2EuDlJ
         l9itCW1E7/zzF2iY0uuGzRjN7EfkxWbgFniQfI1ig9hJBuLAAU6YtgnvS2qsDDMjfPMq
         g9tozy1bAayaY2bUFb0o6GVxI9nZaG10jdXi963nV3FzTJdibHeg06H22231sObEoWSt
         qU605cKW93bqjsW9lI4NmMQdA3dHSz9bBOJoowWaneiVi6MI/l1Oj/TICYyYRzjq15JX
         bVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kyUcdhzGFcDndqqzlq8u6bhrtYYzLp4ulxMjiB9uh5c=;
        b=Arij9kcAgidSoSyFWz6kxScH+AYHNV+ZArsvFd37/dm90LLZbmxcbyQWPddMaXp6W+
         dFQ97z4Quos0AYiVzZS/9TqZ0minO97R/KCCovgnZHfW2ojYGQE9GmtqvKiia/J19MnQ
         /E2wCXYbbA68Q23PLP9i4qBv14mTbn6/nymflap1nKvQuBZOOmKXEuhRYpOwyOpb/0XY
         h2ZgZaD7EKB1wIwDZUJ3X013sEilMDVsZvSajkfcY4oXdNnlNiTNoOmTcUk2260hMKqI
         U77868iWtKyJNkSlIfDS5ZWtvkkXUyavqN3/I7ZRK4V+ryQEFMKeCluTLUDaFWk0ViEo
         wcLg==
X-Gm-Message-State: AJIora89VWrUDT2wYQJfobgRji3rq29hNi3Ym3KruvCvHu1hFnOyj1LJ
        coeV/p1yS9lg9aFjVBIRr3XuzlA9HhJuxmHAbohiQA==
X-Google-Smtp-Source: AGRyM1vi+zjahGXXcpbt0CqwKznHFVRgSDpwgZA5t5LpY6k47Bt24hhcLlYP11MJUxs1rAREcnH3d+ZuAGphRNygiSk=
X-Received: by 2002:a2e:90d6:0:b0:25a:86c8:93be with SMTP id
 o22-20020a2e90d6000000b0025a86c893bemr2094952ljg.107.1655910342131; Wed, 22
 Jun 2022 08:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-9-mw@semihalf.com>
 <YrC0BSeUJaBkhEop@smile.fi.intel.com> <CAPv3WKdiftkA4_D-z_j1GqyAVk9Rit2Rwf_z=OttMaAZ4f2oAQ@mail.gmail.com>
 <CAJZ5v0gzd_Tmvq27695o=PuGoneGUW=gd4f9_5nQPMHgMk+xwA@mail.gmail.com>
In-Reply-To: <CAJZ5v0gzd_Tmvq27695o=PuGoneGUW=gd4f9_5nQPMHgMk+xwA@mail.gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 22 Jun 2022 17:05:30 +0200
Message-ID: <CAPv3WKcpKYV2OQuy3KMKW6u09Rp2-d422WspB6uo6ta=mvhN8Q@mail.gmail.com>
Subject: Re: [net-next: PATCH 08/12] ACPI: scan: prevent double enumeration of
 MDIO bus children
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 22 cze 2022 o 14:09 Rafael J. Wysocki <rafael@kernel.org> napisa=
=C5=82(a):
>
> On Tue, Jun 21, 2022 at 1:05 AM Marcin Wojtas <mw@semihalf.com> wrote:
> >
> > pon., 20 cze 2022 o 19:53 Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> napisa=C5=82(a):
> > >
> > > On Mon, Jun 20, 2022 at 05:02:21PM +0200, Marcin Wojtas wrote:
> > > > The MDIO bus is responsible for probing and registering its respect=
ive
> > > > children, such as PHYs or other kind of devices.
> > > >
> > > > It is required that ACPI scan code should not enumerate such
> > > > devices, leaving this task for the generic MDIO bus routines,
> > > > which are initiated by the controller driver.
> > > >
> > > > This patch prevents unwanted enumeration of the devices by setting
> > > > 'enumeration_by_parent' flag, depending on whether their parent
> > > > device is a member of a known list of MDIO controllers. For now,
> > > > the Marvell MDIO controllers' IDs are added.
> > >
> > > This flag is used for serial buses that are not self-discoverable. No=
t sure
> > > about MDIO, but the current usage has a relation to the _CRS. Have yo=
u
> > > considered to propose the MdioSerialBus() resource type to ACPI speci=
fication?
> > >
> >
> > Indeed, one of the cases checked in the
> > acpi_device_enumeration_by_parent() is checking _CRS (of the bus child
> > device) for being of the serial bus type. Currently I see
> > I2C/SPI/UARTSerialBus resource descriptors in the specification. Since
> > MDIO doesn't seem to require any special description macros like the
> > mentioned ones (for instance see I2CSerialBusV2 [1]), Based on
> > example: dfda4492322ed ("ACPI / scan: Do not enumerate Indirect IO
> > host children"), I thought of similar one perhaps being applicable.
> >
> > Maybe there is some different, more proper solution, I'd be happy to
> > hear from the ACPI Maintainers.
> >
> > [1] https://uefi.org/specs/ACPI/6.4/19_ASL_Reference/ACPI_Source_Langua=
ge_Reference.html?highlight=3Di2cserialbus#i2cserialbusterm
>
> Well, the approach based on lists of device IDs is not scalable and
> generally used as the last resort one.
>
> It would be a lot better to have a way of representing connections to
> the MDIO bus as resources in _CRS.

Thank you for your input. I will submit a proposal for MDIOSerialBus
_CRS resource macro then.

Best regards,
Marcin
