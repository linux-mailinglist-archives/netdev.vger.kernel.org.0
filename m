Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF0C555114
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358374AbiFVQPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355693AbiFVQPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:15:31 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4A731203;
        Wed, 22 Jun 2022 09:15:30 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id fd6so21836828edb.5;
        Wed, 22 Jun 2022 09:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DSUF0Z6t3P5aw01VlWaFHORMHJ/6zM1aeGUz9joqhm0=;
        b=XiNfzk3th87p0A34Gi/ZxxC5jsmtSS/oXmK+DUvuWisaY6is9s1IOvLBEVi6W7L6hF
         Ngba9AnDj2OrsYtI7rv3vpIV6jDr1dKVncX1HW0NFYOB2QN9JqeM/1VN5BxBNnxQgJkx
         p24UBcrxF5ShLw8edDs+BZ5afLauerd0ElRUdcsx1ZCmjJvCSq0/HBafwFExXpNerkoD
         zR8srdymn0if7NvprLm5x1NNtZgr2wxhLMUTtuD64GYqExktWd02o2PgEzt82uA80WgK
         gZ6awwKw3RJQAEXfsLy6MvktxKf0hnjH8k5NEaf5pltirimTqTUZDOZ9jKWTptDazj2l
         V+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DSUF0Z6t3P5aw01VlWaFHORMHJ/6zM1aeGUz9joqhm0=;
        b=t1yajpc4QwcoUKo8HlFD5rQSErBvhhxlYdr/dboqBHU7akJw0DeR9L7WcdcI3Xco3A
         IZfbi57IEpqdP7ENqxh5kx22MUy3Fg69MNzSb1DrYJN8t/Krm7se2U5VjhmDJji00ww2
         eY1VSCEEzz7GK2CV7DcblgzaIELcG/PK7FaVTas8H6yROV6FGImWE1cVbZhr+S4VC6HN
         yze2mOPAXsVznK3eMLSCUziUKAsmq79JGOo7j1Gf11jwwThGAWQxyzM15lmbp8YQnzk/
         uK5wUWAPqiyEfseYTLqku4McQjCro1R1Fagy3Yg+dm8+9zTBrVl5zO4B9Jr+oEba7v3i
         ndHA==
X-Gm-Message-State: AJIora9irJapvNxGwOiXiMNiGSeaGggOzGEdN2gGSB2U+fjALnswILKp
        yFrvdvR2Aj1UkKZQ+5sApuD7BFz/RtIjWFeDzi0=
X-Google-Smtp-Source: AGRyM1t42CP/tNJ0qgRF60DE5Ky7HpNN1sxeYXNMD1uMoBw8TOWf3heQWfg6TF9pUI0rUIibFtQWU/3WMBUx+ZfWNwk=
X-Received: by 2002:a05:6402:f8d:b0:435:6df2:68a with SMTP id
 eh13-20020a0564020f8d00b004356df2068amr5075901edb.209.1655914529131; Wed, 22
 Jun 2022 09:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <YrC0oKdDSjQTgUtM@lunn.ch>
 <YrC3ZKsMQK3PYKkR@smile.fi.intel.com> <YrDAMcGg1uF9m/L+@lunn.ch>
 <CAPv3WKeeZwNAs06thrYvgXaTPA9KP-9dQZNZsYWx3UXS8LStAQ@mail.gmail.com> <CAPv3WKeYBE=ybXQw_3Hn2NoLVzO0da1ecged73=frzQKhGh6OQ@mail.gmail.com>
In-Reply-To: <CAPv3WKeYBE=ybXQw_3Hn2NoLVzO0da1ecged73=frzQKhGh6OQ@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 22 Jun 2022 18:14:52 +0200
Message-ID: <CAHp75VeyeXpXLX4wG1ghozbujk3=riJ9O-PCpnD14q8hh5SiLw@mail.gmail.com>
Subject: Re: [net-next: PATCH 00/12] ACPI support for DSA
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
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
        upstream@semihalf.com, Jon Nettleton <jon@solid-run.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 5:44 PM Marcin Wojtas <mw@semihalf.com> wrote:
>
> Hi,
>
> wt., 21 cze 2022 o 12:46 Marcin Wojtas <mw@semihalf.com> napisa=C5=82(a):
> >
> > pon., 20 cze 2022 o 20:45 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
> > >
> > > > You beat me up to this. I also was about to mention that the proble=
m with such
> > > > conversions (like this series does) is not in the code. It's simple=
st part. The
> > > > problem is bindings and how you get them to be a standard (at least=
 de facto).
> > >
> > > De facto is easy. Get it merged. After that, i will simply refuse
> > > anything else, the same way i and other Maintainers would refuse a
> > > different DT binding.
> > >
> > > If the ACPI committee approve and publish a binding, we will naturall=
y
> > > accept that as well. So in the end we might have two bindings. But so
> > > far in this whole ACPI for networking story, i've not heard anybody
> > > say they are going to submit anything for standardisation. So this
> > > might be a mute point.
> > >
> >
> > I understand your concern and of course it's better to be on a safe
> > side from the beginning. Based on the hitherto discussion under this
> > patchset, I would split the question about standardization to 2
> > orthogonal topics:
> >
> > 1. Relation to the bus and enumeration:
> >   * As pointed out in another patch some switches can be attached to
> >     SPI or I2C. In such a case this is simple - SPISerialBus /
> > I2CSerialBus structures
> >     in _CRS are included in the ACPI Spec. They allow to comprise more
> > bus specific
> >     information and the code in acpi/scan.c marks those child devices
> > as to be enumerated
> >     by parent bus.
> >   * MDIO bus doesn't have its own _CRS macro in the Spec, on the other
> > hand the _ADR
> >     seems to be the only object required for proper operation - this
> > was my base for
> >     proposed solution in patch 06/12.
> >
> > 2. The device description (unrelated to which bus it is attached)
> >   * In Linux and other OS's there is a great amount of devices
> > conforming the guidelines
> >     and using only the standard device identification/configuration
> > objects as per [1].
> >   * Above do not contain custom items and entire information can be obt=
ained by
> >     existing, generic ACPI accessors - those devices (e.g. NICs,
> > SD/MMC controllers and
> >     many others) are not explicitly mentioned in official standards.
> >   * The question, also related to this DSA case - is the ACPI device()
> > hierarchical
> >     structure of this kind a subject for standardization for including
> > in official ACPI specification?
> >   * In case not, where to document it? Is Linux' Documentation enough?
> >     I agree that in the moment of merge it becomes de facto standard AB=
I and
> >     it's worth to sort it out.
> >
> > Rafael, Len, any other ACPI expert - I would appreciate your inputs
> > and clarification
> > of the above. Your recommendation would be extremely helpful.
> >
>
> Thank you all for vivid discussions. As it may take some time for the
> MDIOSerialBus _CRS macro review and approval, for now I plan to submit
> v2 of_ -> fwnode_/device_ migration (patches 1-7,11/12) and skip
> ACPI-specific additions until it is unblocked by spec extension.

Sounds good to me (as from fwnode perspective).

--=20
With Best Regards,
Andy Shevchenko
