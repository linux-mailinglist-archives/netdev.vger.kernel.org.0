Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAFF1E6783
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405047AbgE1QgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405021AbgE1QgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 12:36:11 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B57C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 09:36:10 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id y13so688278eju.2
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 09:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8kyIIZUNOskPOpwDELH6x1qbZGwUsjevZc+PK3ZMnQ=;
        b=K4U3MVfnSHCQ7ylmpf/eTMWVECMl9OZHaguleVT8ltvuc0HWhkF+ciY6J8vwbtOI0v
         mIVK4x/J4VODdcoyylcjOztWzGd5Ha8wku0t47D2tqinTbud/xdRecZf1groHzvWbp9+
         wIbBW8MrNXeDeiZL5VzkZF5bBd4tpfAWksioHYSJNJVJTBD84RzJkZeJa51TA5NUEsug
         6J9M/9if22MEq943SNxMSWuEZJ5RJz+MZXgEkJDrWt88Ou9AkDc7EWaIAStWC6hJ0DMN
         4VzyqYtZYTeZHc6/M00U01ceEknq8WNcjDgH8L0ln55pPIKkOHr8FIn4bqyecXwkQRV2
         94+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8kyIIZUNOskPOpwDELH6x1qbZGwUsjevZc+PK3ZMnQ=;
        b=PKG3nUsge5u/Z5PS33/NFNX76ubQ3SaKvFYbEWk5BPTDd8eAGITTWYuh4W92sjBWC+
         z4KDeYmZLCiLcA+/sKdIfFyC2LrHWrhiftWhkgK+R02WFkrlCPJ4YYGT0xSIC2bQOeuk
         69gujyuP9X44UalV8Zmkh4LsUcBdbvl3Bq54/Lm0nmsjmmyjttUmcKAvaQsE2YGRnSFc
         yMFgEEuVaTKfkh8lfM0sB+4aspx/LX71SxXkbcHCuUmq1OPEKpex3T0ShgCcQrKVzjYa
         3GkdJmkxER6ufbJOQfWln2xHwYyKJCDV8V2DUeiC5WZFhuQIP1LfYnCJgtuA+SEFZp1T
         gBNg==
X-Gm-Message-State: AOAM533JxjlrFQqH/cA9E52iX6oNsPL+69pxG3fhj4ohKulQM9bAUwAL
        ZXlMaLFdaexOETJYFoKhUhO+KhGHS/nTuIXxksw=
X-Google-Smtp-Source: ABdhPJz4ng1/ohrOhw31awdf1ftPJ7f8YajEAjahOycGPEIK22p2gQ8+kA0KRoZqiEdyNIL2x+GU3HjehnzGontX0vY=
X-Received: by 2002:a17:906:a0c2:: with SMTP id bh2mr3726141ejb.406.1590683769525;
 Thu, 28 May 2020 09:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200527234113.2491988-1-olteanv@gmail.com> <20200527234113.2491988-3-olteanv@gmail.com>
 <20200528092112.6892e6b5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200528092112.6892e6b5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 28 May 2020 19:35:58 +0300
Message-ID: <CA+h21hqKUj-MgFVvm1VPajZz60iWUj3Xe2GdHwnQrT9Su+YfVQ@mail.gmail.com>
Subject: Re: [PATCH net-next 02/11] net: mscc: ocelot: unexport ocelot_probe_port
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 at 19:21, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 28 May 2020 02:41:04 +0300 Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > This is not being used by any other module except ocelot (i.e. felix
> > does not use it). So remove the EXPORT_SYMBOL.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > index e621c4c3ee86..ff875c2f1d46 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -2152,7 +2152,6 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
> >
> >       return err;
> >  }
> > -EXPORT_SYMBOL(ocelot_probe_port);
> >
> >  /* Configure and enable the CPU port module, which is a set of queues.
> >   * If @npi contains a valid port index, the CPU port module is connected
>
> Strangely I get an error after this patch:
>
> ERROR: modpost: "ocelot_probe_port"
> [drivers/net/ethernet/mscc/ocelot_board.ko] undefined! make[2]: ***
> [__modpost] Error 1 make[1]: *** [modules] Error 2
> make: *** [sub-make] Error 2
>
> Maybe a build system error, could you double check?

Oh, I keep forgetting that CONFIG_MSCC_OCELOT_SWITCH and
CONFIG_MSCC_OCELOT_SWITCH_OCELOT are different modules....
Ok, so moving ocelot_probe_port to ocelot_board.c needs a bit more
work, I guess I'll just skip this patch for now.
