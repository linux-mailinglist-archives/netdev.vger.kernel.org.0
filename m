Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BDD2DE6C0
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 16:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgLRPhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 10:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgLRPhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 10:37:38 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59273C0617B0;
        Fri, 18 Dec 2020 07:36:58 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id v2so1740505pfm.9;
        Fri, 18 Dec 2020 07:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+KLSZTU5ExRpj/cZNjbTv8MS71w3sCFIMI4H99ieEKo=;
        b=D3L/yJ8R/OunwhSbKyc2rz9lb4mfdgQquJr33FFTlqhVg6z/JACxfrmS720bcqh/Ib
         Pw6mECItEwlQUWPQ4EJ+EJJ2tyRVYW25NC0zrIoyhgMW+8C+iFOSkenV50hekAvn7Z6y
         BJRQumM4mlXxzFNbWqLA3Wqzx8JdX08m7T0zc6Q/jAilDAIrPXlUSuImzXGGTDyhn3S7
         XfXgPr0sZSFXBQH0Sm7I8Zq8Dwh20lkzfCHSGuzEu6Vly96TvmUxV75SfHSbEidDQnlk
         SHqQVtoSbC1tMVCZniDtNjymplJpvdwZEvSzq1wxQmbYSrUiDsOIU9LuCaxQ/5w13OEK
         7qLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+KLSZTU5ExRpj/cZNjbTv8MS71w3sCFIMI4H99ieEKo=;
        b=rUfZCmCxMtlT86M+ccMiICo7SnOsqhJRpGW+dNN4I5LUZYdqpnkUFc2lw3U9+C5of8
         uinsbfk6oIp8fVXpPYUHnJjesgH77zM5uT3DOPpv/1b30eOhtVCecRa2tx2XGir3egR8
         ya3eqTc/Yg5ipR6Mw+de9UQu1ouWZIcR2heZcxmk2HjtSIMGiOrJkzXMjmB06gJQcV/y
         as+lAmnI5O+EJP3ySnw8xyhRIt56hEZnX9EdZMk8Z2Jo8fQZBH2QAkr4uGzstaZzTHvM
         ZCFfPeyRtqave7ROU4dUcEUIdPxpppKLSkHpMqV+vtgE9RlDJthIesBcc5VU8cokbrvR
         Xd1Q==
X-Gm-Message-State: AOAM531lAqqvLFrL9mdCyC1aU+cOYhdKys1jYT0w1c2UOeLMNAfRmZEX
        gFtjWZg+JQ9q11pkF/fQnNVX//ZQK2AE/NajiC8=
X-Google-Smtp-Source: ABdhPJyhQWu/LkN+fP3nOWDXs/TSnn33BgzHb1Co9HMOBy4XiN4f0exFG/8nxg1+9UOhOdoEd6TyXUQIQCRxNmCW63I=
X-Received: by 2002:a63:74b:: with SMTP id 72mr4681349pgh.4.1608305817763;
 Fri, 18 Dec 2020 07:36:57 -0800 (PST)
MIME-Version: 1.0
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
 <20201215164315.3666-9-calvin.johnson@oss.nxp.com> <CAHp75Vf69NuxqcJntQi+CT1QN4cpdr2LYNzo6=t-pBWcWgufPA@mail.gmail.com>
 <20201218054044.GB14594@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20201218054044.GB14594@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 18 Dec 2020 17:36:41 +0200
Message-ID: <CAHp75Vd4+b9asXXVGnFAH8nuDgyzR+ocaKaf7ibdt88gpMMT9w@mail.gmail.com>
Subject: Re: [net-next PATCH v2 08/14] net: mdiobus: Introduce fwnode_mdiobus_register()
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
        Jon <jon@solid-run.com>, "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 7:40 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Tue, Dec 15, 2020 at 07:53:26PM +0200, Andy Shevchenko wrote:
> > On Tue, Dec 15, 2020 at 6:44 PM Calvin Johnson
> > <calvin.johnson@oss.nxp.com> wrote:

...

> > I would rather see this as simple as
> >
> >      if (is_of_node(fwnode))
> >                return of_mdiobus_register(mdio, to_of_node(fwnode));
> >      if (is_acpi_node(fwnode))
> >                return acpi_mdiobus_register(mdio, fwnode);
> >
> > where the latter one is defined somewhere in drivers/acpi/.
> Makes sense. I'll do it. But I think it will be better to place
> acpi_mdiobus_register() here itself in the network subsystem, maybe
> /drivers/net/mdio/acpi_mdio.c.

Even better, thanks!

-- 
With Best Regards,
Andy Shevchenko
