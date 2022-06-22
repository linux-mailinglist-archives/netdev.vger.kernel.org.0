Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A4755467B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353254AbiFVMJe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Jun 2022 08:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbiFVMJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:09:31 -0400
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85AD3D480;
        Wed, 22 Jun 2022 05:09:30 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id w6so29824660ybl.4;
        Wed, 22 Jun 2022 05:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dT0mi19zMMxNKtjOrIz+OmwrK9KKDysxB4KYhjt4JCo=;
        b=NeSPt4p2GW7XBreOjfVwsEsitsvy8OQVoisj4yJ/FcmxXrDrqawkIYblzYCaqSzbSI
         dMjNKzXo0Vv/miYM0rgCSDlIyK/e3DSUZ0KgWLaEMYN+kn3fyvZSp4pAspZiTF/ZKXWt
         npwYo3ZZB6vz4NHMtDYbSmP6V5YQPu7Hldy/FuK75pfpGuT9JU/gFfg5FEq/qPtjCusN
         VpsHQMQF3Cfcb4iFdUje+Pin1XVMLvgRiKygtUYVM0i2EJ45gHeeidnz9Pop5xj8tK8s
         7EGqILgYK3TsXIlrljxgyGPcBc0hiraNgUTufIrwEa2qdEL3IrWgFje2elUBPch0yfNq
         0+HQ==
X-Gm-Message-State: AJIora/NbCFxr1jRQcfANmG/ldHx2pi6+0Z6jtPzMipeq52XZQsQZ/Rf
        F8YTIKwFtc0OmbbekQNMlaY+leRP8giId51c01g=
X-Google-Smtp-Source: AGRyM1s/+0siR5PbLDNwnOgSZJqoW3FxM4P4pF1kRs7yDiZXmB8ZsmdG8linO4Wuk8zjyg3ZZxszkszLVyOday0ZuWs=
X-Received: by 2002:a05:6902:1141:b0:669:3f2a:c6bb with SMTP id
 p1-20020a056902114100b006693f2ac6bbmr3391045ybu.365.1655899769914; Wed, 22
 Jun 2022 05:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-9-mw@semihalf.com>
 <YrC0BSeUJaBkhEop@smile.fi.intel.com> <CAPv3WKdiftkA4_D-z_j1GqyAVk9Rit2Rwf_z=OttMaAZ4f2oAQ@mail.gmail.com>
In-Reply-To: <CAPv3WKdiftkA4_D-z_j1GqyAVk9Rit2Rwf_z=OttMaAZ4f2oAQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 22 Jun 2022 14:09:19 +0200
Message-ID: <CAJZ5v0gzd_Tmvq27695o=PuGoneGUW=gd4f9_5nQPMHgMk+xwA@mail.gmail.com>
Subject: Re: [net-next: PATCH 08/12] ACPI: scan: prevent double enumeration of
 MDIO bus children
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 1:05 AM Marcin Wojtas <mw@semihalf.com> wrote:
>
> pon., 20 cze 2022 o 19:53 Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> napisał(a):
> >
> > On Mon, Jun 20, 2022 at 05:02:21PM +0200, Marcin Wojtas wrote:
> > > The MDIO bus is responsible for probing and registering its respective
> > > children, such as PHYs or other kind of devices.
> > >
> > > It is required that ACPI scan code should not enumerate such
> > > devices, leaving this task for the generic MDIO bus routines,
> > > which are initiated by the controller driver.
> > >
> > > This patch prevents unwanted enumeration of the devices by setting
> > > 'enumeration_by_parent' flag, depending on whether their parent
> > > device is a member of a known list of MDIO controllers. For now,
> > > the Marvell MDIO controllers' IDs are added.
> >
> > This flag is used for serial buses that are not self-discoverable. Not sure
> > about MDIO, but the current usage has a relation to the _CRS. Have you
> > considered to propose the MdioSerialBus() resource type to ACPI specification?
> >
>
> Indeed, one of the cases checked in the
> acpi_device_enumeration_by_parent() is checking _CRS (of the bus child
> device) for being of the serial bus type. Currently I see
> I2C/SPI/UARTSerialBus resource descriptors in the specification. Since
> MDIO doesn't seem to require any special description macros like the
> mentioned ones (for instance see I2CSerialBusV2 [1]), Based on
> example: dfda4492322ed ("ACPI / scan: Do not enumerate Indirect IO
> host children"), I thought of similar one perhaps being applicable.
>
> Maybe there is some different, more proper solution, I'd be happy to
> hear from the ACPI Maintainers.
>
> [1] https://uefi.org/specs/ACPI/6.4/19_ASL_Reference/ACPI_Source_Language_Reference.html?highlight=i2cserialbus#i2cserialbusterm

Well, the approach based on lists of device IDs is not scalable and
generally used as the last resort one.

It would be a lot better to have a way of representing connections to
the MDIO bus as resources in _CRS.
