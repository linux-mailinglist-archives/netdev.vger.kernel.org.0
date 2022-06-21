Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B252C55301C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 12:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiFUKql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 06:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347832AbiFUKqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 06:46:25 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB472935C
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 03:46:23 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id e4so14949526ljl.1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 03:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Vh0naLXKfGaI/wz1sI7ad1anZ++dFGVS52fTgaAz/6E=;
        b=HT2UAEe9XjNzlZC0Jge5wXtsGk3r7Ou0lNZHdRCJxt1CKHh0xNbVVZ2sCb/OMbCZnO
         AhTyHfgX2ho38pqkyWYeDIozfGnxQId49Wy1P0/cwrWKuPkCasw4gf3hGwzffILNw0eg
         4VrVBAQYEQdhGtv/WOYkndEJnIYWVrfnAHdyA8YdmtLoaCyPAGtKNoLhNBi1p45UU55h
         3EWLdSLEauCoBx9KtoCqhjdTb+q8niKB+Fo6ZsklKdz/MYMgxY+QR05xK2GVNbmd/m1y
         lL2IqN5ibfu4txDaMWxbybmRAbT5h8pcxgLjfHdLLMzqf1IXWq9fZZJFhm/bymYWUlMg
         /cyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Vh0naLXKfGaI/wz1sI7ad1anZ++dFGVS52fTgaAz/6E=;
        b=hB3KtpJo5VIYF4PjOl06CEKx5DIwmzU7rZWqIK4mQAZQtRbWLP80utw/t7JWQlXLbS
         YbJ1E2+fdYnpVTd+9Z51vUMQAjiJy+rGFtzhQRD7VZJ/VxPUqQlbCw08U+F63u6oul1q
         H1M9AX3ZwQ1Q/ymNcm2NjzLaPn2ww2+fNDYEJkiacqW09GYKSgUnZhVFsDs0s5Jfj0Oa
         ZyC435J2oE85C/eiYR2sA8Eh5q6FjJIyTT3o6VNC9RRmUij5GFjRPM3BAZWY7ywrl6oQ
         1Dn59AdSx4YrqFEUwxP35gwKRPLuFvQAvS535c+a5PgSki5SSgERf8tLI2AN4GVJ6oqr
         0LDw==
X-Gm-Message-State: AJIora/N6AXpXZ5dHffvzsqsM+OoJZBUhllkGjhGKSnF0ADq3zXEyQfa
        BDZ2ZQNqCQf+smvrpQBHVMXVRLywWYIgaDU8tSDkug==
X-Google-Smtp-Source: AGRyM1u4pNhKRXPU7turpV43qj5j4SCI7wxYPpigMhjEiOUNKwaSVRP7sTkjHuF9/qLr0cqmYlLNjnQSFP2vzpnThbY=
X-Received: by 2002:a2e:a58d:0:b0:25a:6348:9595 with SMTP id
 m13-20020a2ea58d000000b0025a63489595mr7729873ljp.72.1655808381943; Tue, 21
 Jun 2022 03:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <YrC0oKdDSjQTgUtM@lunn.ch>
 <YrC3ZKsMQK3PYKkR@smile.fi.intel.com> <YrDAMcGg1uF9m/L+@lunn.ch>
In-Reply-To: <YrDAMcGg1uF9m/L+@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 21 Jun 2022 12:46:12 +0200
Message-ID: <CAPv3WKeeZwNAs06thrYvgXaTPA9KP-9dQZNZsYWx3UXS8LStAQ@mail.gmail.com>
Subject: Re: [net-next: PATCH 00/12] ACPI support for DSA
To:     Andrew Lunn <andrew@lunn.ch>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, vivien.didelot@gmail.com,
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
        upstream@semihalf.com, Jon Nettleton <jon@solid-run.com>
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

pon., 20 cze 2022 o 20:45 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> > You beat me up to this. I also was about to mention that the problem wi=
th such
> > conversions (like this series does) is not in the code. It's simplest p=
art. The
> > problem is bindings and how you get them to be a standard (at least de =
facto).
>
> De facto is easy. Get it merged. After that, i will simply refuse
> anything else, the same way i and other Maintainers would refuse a
> different DT binding.
>
> If the ACPI committee approve and publish a binding, we will naturally
> accept that as well. So in the end we might have two bindings. But so
> far in this whole ACPI for networking story, i've not heard anybody
> say they are going to submit anything for standardisation. So this
> might be a mute point.
>

I understand your concern and of course it's better to be on a safe
side from the beginning. Based on the hitherto discussion under this
patchset, I would split the question about standardization to 2
orthogonal topics:

1. Relation to the bus and enumeration:
  * As pointed out in another patch some switches can be attached to
    SPI or I2C. In such a case this is simple - SPISerialBus /
I2CSerialBus structures
    in _CRS are included in the ACPI Spec. They allow to comprise more
bus specific
    information and the code in acpi/scan.c marks those child devices
as to be enumerated
    by parent bus.
  * MDIO bus doesn't have its own _CRS macro in the Spec, on the other
hand the _ADR
    seems to be the only object required for proper operation - this
was my base for
    proposed solution in patch 06/12.

2. The device description (unrelated to which bus it is attached)
  * In Linux and other OS's there is a great amount of devices
conforming the guidelines
    and using only the standard device identification/configuration
objects as per [1].
  * Above do not contain custom items and entire information can be obtaine=
d by
    existing, generic ACPI accessors - those devices (e.g. NICs,
SD/MMC controllers and
    many others) are not explicitly mentioned in official standards.
  * The question, also related to this DSA case - is the ACPI device()
hierarchical
    structure of this kind a subject for standardization for including
in official ACPI specification?
  * In case not, where to document it? Is Linux' Documentation enough?
    I agree that in the moment of merge it becomes de facto standard ABI an=
d
    it's worth to sort it out.

Rafael, Len, any other ACPI expert - I would appreciate your inputs
and clarification
of the above. Your recommendation would be extremely helpful.

Best regards,
Marcin
