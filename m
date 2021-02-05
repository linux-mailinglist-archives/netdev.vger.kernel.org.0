Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89823310FE0
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhBEQpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbhBEQnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:43:45 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93589C061574;
        Fri,  5 Feb 2021 10:25:26 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y10so3996902plk.7;
        Fri, 05 Feb 2021 10:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hDtDmxYzgl4d3/qs8/uzGh/wEnBrhxdK4yPraq/NRyY=;
        b=t/YdSGFw8VqVoa1GNBxu66fezqmi5TUbADL4oVBPP0/IG+bTi9h+DonXXD74X7QVK5
         II/iIdPGSImQKVW0c0xTg+LpukBQkR3ZCwdgBBONudJ5sJ1CmSIZtK0fFW596jozgVfP
         jDxRTaesog5T9hs6HHcA05q67L2mtvNUCgnbTcvhePAkiB1gbBgexUo+16qYPESc35cS
         12YFYIz8AiLXqUaeA6GU0MdLL5T50YfvsHreaRKnTAL5VcciMUWT1OxjMi5lik8twYGl
         ZEaEPXqp50XtaKR1OyCyTUpzAxhFczg3p+5TRhO45kA/kIUAuzqXOMjyXssWzV7gOPjc
         etiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hDtDmxYzgl4d3/qs8/uzGh/wEnBrhxdK4yPraq/NRyY=;
        b=LWthXTU67G1g5KeSCdClGLDWBO0B5k0kCMSI0WXLH054gb/qjarwjGlMhsvWjJ31j0
         cFIglaaqnNqnQpoMvapGCXS3LE3SDJrq4UvMB1udptcHIzgPgJNZ7jVpM3Sb3hfW0GMb
         c1oykQghk9vRFXSR4gKn60AtTdg54IJQpLcUneR5i5BuMJl9cAvihfhEpfeyDjLcnYXm
         fqX0gGOYvSppUSfEQ5vk2qT/rEcdWcO4qAQLAbO9TxkKhowuSyh9WgqlemcT5+ekV7+z
         eO6wY+vA3vDgVEJwSTNGCibERPxEIwHZvH+T6nyonaP91tmyRpZaa3Clf112B7n5535d
         IvHw==
X-Gm-Message-State: AOAM533dqfsuIj3UXS5DMWlbCvy3zcMb+QPS9X36etqoK7zsnWnEb1PY
        DOe5sb61vGsQ9qKcY6iQ0n3LU13N6F21ByhR7Rw=
X-Google-Smtp-Source: ABdhPJxA5kH01hLnpC/G1J9D4X8lAY5LIygvAT+AFOof8c9R8sEDvANdrZQK4kJzaz+ZteiN5lyLdGNZskLCBBI8/P4=
X-Received: by 2002:a17:90a:1b23:: with SMTP id q32mr5408942pjq.181.1612549526116;
 Fri, 05 Feb 2021 10:25:26 -0800 (PST)
MIME-Version: 1.0
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-8-calvin.johnson@oss.nxp.com> <20210205172518.GA18214@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20210205172518.GA18214@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 5 Feb 2021 20:25:09 +0200
Message-ID: <CAHp75VdX2gZbt-eYp31wg0r+yih8omGxcTf6cMyhxjMZZYzFuQ@mail.gmail.com>
Subject: Re: [net-next PATCH v4 07/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 7:25 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Fri, Jan 22, 2021 at 09:12:52PM +0530, Calvin Johnson wrote:

...

> > +     rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
> With ACPI, I'm facing some problem with fwnode_property_match_string(). It is
> unable to detect the compatible string and returns -EPROTO.
>
> ACPI node for PHY4 is as below:
>
>  Device(PHY4) {
>     Name (_ADR, 0x4)
>     Name(_CRS, ResourceTemplate() {
>     Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
>     {
>       AQR_PHY4_IT
>     }
>     }) // end of _CRS for PHY4
>     Name (_DSD, Package () {
>       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>         Package () {
>           Package () {"compatible", "ethernet-phy-ieee802.3-c45"}
>        }
>     })
>   } // end of PHY4
>
>  What is see is that in acpi_data_get_property(),
> propvalue->type = 0x2(ACPI_TYPE_STRING) and type = 0x4(ACPI_TYPE_PACKAGE).
>
> Any help please?
>
> fwnode_property_match_string() works fine for DT.

Can you show the DT node which works and also input for the
)match_string() (i.o.w what exactly you are trying to match with)?

-- 
With Best Regards,
Andy Shevchenko
