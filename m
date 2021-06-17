Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711DD3AB49B
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 15:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhFQNZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 09:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhFQNZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 09:25:09 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7452AC061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 06:23:00 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d9so4621278qtp.11
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 06:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EpWxRaSsnLYws7nyDWlyhtmN0+4jL+XRdMFxoBZFNjc=;
        b=qYJWuKoW9PtFH0BaBavdHQXZ9+p0C7xQmq3feta+NIidPdHSI9MFKCdyx1kNqtfOpg
         KqwrVyubAH3gQTpeI6o9jbhjf4e5bXent62688TD1VTSRlQz8I1y6Wu1eJ8zsHK6RDpG
         OYnLDI1J97EFHEm02dAZwqH5IvVSemWWk5jhCh4l+8HyeKmcq+ZHCCsoCz+Pk65nNT0H
         WrZuO4B/+OyZvmn2W37oZqCq+dr/LuSiONs+3EUOEZUWN5Av3gB5GWbRLGvM+h6RTTEE
         mExSWQN0MrhdsqePYH2dsvR54j+OhJal4GdCpmXTTJArxMLZufCpWk8KxVW/WZ7Sj83W
         4qzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EpWxRaSsnLYws7nyDWlyhtmN0+4jL+XRdMFxoBZFNjc=;
        b=Tjubtu65C7HlO0pdvCniO0UoEu/+x6cQp6cDarMNQXuzT6UE1oGzwXy5cp4O+iddJE
         5DA1JJWFovfyijbmTSegCY8yrDFZF2wilnznvXbDkmRzNk+Nu/PSq8rdKRWQen/lOHAR
         jznF3EFUStQpPuhxwKffYRoe0BMh1DipZ9Q67S2sr5tT9ZpzO9HXuTg5+veukBLzzv7q
         DbKN6buIYDw+MN5oHf5wH9JPsShgS4RhFqRRuMyMNf7oc5ns1M0HzaHyANkM5HJUqdJq
         jRozd9aXvNmdjmYYsrl9h/S9UfTG0sGFsyNlzVKcnvCcYKhmO2enIBbCFyikfqg69ENa
         8AeA==
X-Gm-Message-State: AOAM531bpYDl6pv0koMLqvAg6U4BoHhG2pxkzM7mrHySimJ9WV6VFpZj
        ZPQf0PYVaJaY92aBmQlavlLpZeFdSbQBAx3mnoXc1g==
X-Google-Smtp-Source: ABdhPJxAO2nFYDYfih/PNHQokbVY+LbN/ZwPSGQzc6cgf+MSSXMDBX0GH72V1GWtMo2c7X3wq8BASCM2xClh5j32XZg=
X-Received: by 2002:a05:622a:81:: with SMTP id o1mr5046038qtw.16.1623936179469;
 Thu, 17 Jun 2021 06:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210616190759.2832033-1-mw@semihalf.com> <20210616190759.2832033-4-mw@semihalf.com>
 <YMpShczKt1TNAqsV@lunn.ch> <CAPv3WKde+LCmxxr6UuA7X=XShF6d4io49baxsjw1kMqR=T7XrA@mail.gmail.com>
 <YMs/xztdc0xhYbDr@lunn.ch>
In-Reply-To: <YMs/xztdc0xhYbDr@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 17 Jun 2021 15:22:48 +0200
Message-ID: <CAPv3WKdPiwxsHKHoa1SK7xUu4fCPYsGhyXLr6ZGUWo4tvdOvkw@mail.gmail.com>
Subject: Re: [net-next: PATCH v2 3/7] net/fsl: switch to fwnode_mdiobus_register
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>, rjw@rjwysocki.net,
        lenb@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 17 cze 2021 o 14:28 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> On Thu, Jun 17, 2021 at 01:39:40AM +0200, Marcin Wojtas wrote:
> > =C5=9Br., 16 cze 2021 o 21:35 Andrew Lunn <andrew@lunn.ch> napisa=C5=82=
(a):
> > >
> > > On Wed, Jun 16, 2021 at 09:07:55PM +0200, Marcin Wojtas wrote:
> > > > Utilize the newly added helper routine
> > > > for registering the MDIO bus via fwnode_
> > > > interface.
> > >
> > > You need to add depends on FWNODE_MDIO
> > >
> >
> > Do you mean something like this?
> >
> > --- a/drivers/net/ethernet/freescale/Kconfig
> > +++ b/drivers/net/ethernet/freescale/Kconfig
> > @@ -68,8 +68,8 @@ config FSL_PQ_MDIO
> >  config FSL_XGMAC_MDIO
> >         tristate "Freescale XGMAC MDIO"
> >         select PHYLIB
> > -       depends on OF
> > -       select OF_MDIO
> > +       depends on ACPI || OF
> > +       select FWNODE_MDIO
> >         help
>
> You should not need depends on ACPI || OF. FWNODE_MDIO implies
> that. And there are no direct calls to of_ functions, so you can drop
> the depends on OF.
>

Ok, I'll leave:
depends on FWNODE_MDIO
only.

Thanks,
Marcin
