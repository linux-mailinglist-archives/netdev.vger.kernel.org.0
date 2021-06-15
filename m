Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D643A89CF
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFOTzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhFOTzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 15:55:42 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9231C061574;
        Tue, 15 Jun 2021 12:53:36 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h1so9041207plt.1;
        Tue, 15 Jun 2021 12:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JmFlIo66Q2lUAdQOijgfx+2lkEDDRndTtQcJnANFGSk=;
        b=R4YUsAxVEZ4iVuuCvLgtnCa2Na/bh6EHsqr3NTycSarjMnvA8R9KpAo/rQDM5uHEOc
         Vfhydd01uRyhpth/bq1ho8e0JsYp7BQskrgIdpm/aUeCc3MiUh4AoT77liV7977Oer5D
         6S/lcmOK1OLhxj/LPYdiul8xFmkynJ2O9ieAMKMDRckxI22oDwCepY6OZMhqpcpUOwrt
         NzvzwPzG1kggKhzd3bp0BcndhBZDuqGP0lZXe3/OayWwHV5q0vi7Vgfr+BhEoUVDBPpJ
         1OXdzJaDQX5XNhBRPgbxJD4Vg2dEbfbS463bPhsGenCSMfxR8SIF9jVh2n4A09T+G5WO
         gl8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JmFlIo66Q2lUAdQOijgfx+2lkEDDRndTtQcJnANFGSk=;
        b=L3wrGQ+Za36pfmSzDCWSKeULfVvK0wHHXH3QzRG8JB7QW4OcnL4+1N9PHnBcIGEwV9
         ELFQrTswSnSrxmoxl7nf+SzKCFX+5mhELUD5qVhMgYGvFGncEL0vioMdg46zFvuw7Q4+
         bvLJitV2MA+o86/HZ3yP1jnINJrEXHeFi29+KcyLap1PDPEum4k2Tocpw+PtKnHmBiUp
         /3CNvaZMK/JygK9Zjh6KYXefyNNl4ZBYQ0lOVceERzuO0ezRHedBcalVinBMkg3g7yqF
         Pc3E2ewh2Jnu0DumMinvPv1L3sNbhoFKmQkXOyYOLhi2ZpZl7KISmP6ye1xvmQXwCBZL
         OmUQ==
X-Gm-Message-State: AOAM530Cpr7tzolABbaRwEPPqrnONRC+Rku6ZLkAX3eDyvgk9xzn9Ll/
        sbrzgctwvmsTuXIbeKXfuYh5zL9qRTBpvDo0bJY=
X-Google-Smtp-Source: ABdhPJwu1vVMH/LXScU1FSrTIj+ro1yE2Xq/DJzaKFPNXfXSkOEx3fWGn0gl6xZOyrN0YK9VjszGoVIG1U3KQDBMOQg=
X-Received: by 2002:a17:90a:bc89:: with SMTP id x9mr932526pjr.228.1623786816332;
 Tue, 15 Jun 2021 12:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210613183520.2247415-1-mw@semihalf.com> <20210613183520.2247415-2-mw@semihalf.com>
 <YMZaZx3oZ7tYCEPH@lunn.ch> <CAPv3WKefzp=F8UtWNYP+DNiyuBA9X0TzyONUuRVeMT8xKRbGEg@mail.gmail.com>
In-Reply-To: <CAPv3WKefzp=F8UtWNYP+DNiyuBA9X0TzyONUuRVeMT8xKRbGEg@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 15 Jun 2021 22:53:19 +0300
Message-ID: <CAHp75Vcx8obKAf4NMd_v8yOzoTvM4qHOytpVXyRCy+24Rr5GBw@mail.gmail.com>
Subject: Re: [net-next: PATCH 1/3] net: mvmdio: add ACPI support
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 6:14 PM Marcin Wojtas <mw@semihalf.com> wrote:
> Hi,
> niedz., 13 cze 2021 o 21:20 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
> >
> > > -     ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
> > > +     if (pdev->dev.of_node)
> > > +             ret =3D of_mdiobus_register(bus, pdev->dev.of_node);
> > > +     else if (is_acpi_node(pdev->dev.fwnode))
> > > +             ret =3D acpi_mdiobus_register(bus, pdev->dev.fwnode);
> > > +     else
> > > +             ret =3D -EINVAL;
> >
> >
> > This seems like something which could be put into fwnode_mdio.c.
> >
>
> Agree - I'll create a simple fwnode_mdiobus_register() helper there.

Please, also convert the users that we will not have again some
open-coded examples here and there
https://lore.kernel.org/netdev/162344280835.13501.16334655818490594799.git-=
patchwork-notify@kernel.org/T/#mff706861dea5d3be037d1546fa9c362b27d5839b

(Btw, note the is_of_node() usage there, so should
fwnode_mdiobus_register() have)

--=20
With Best Regards,
Andy Shevchenko
