Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2734A92539
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfHSNhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 09:37:52 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37698 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfHSNhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 09:37:52 -0400
Received: by mail-ed1-f66.google.com with SMTP id f22so1697933edt.4;
        Mon, 19 Aug 2019 06:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1t0RW3112O766MI4PtQuF8XjhRp95awZjAFSPxZK5U4=;
        b=fxBlB0gVR48U15aLKAGAMWBf5OYgsHyHcnGGlqQT/WteMfGJWG3wzf3MXHgg1Cxeb3
         BahWeFccRIFj4OuaNX7lEyVC3ZW1MKgBqdTFPR0gY2F45B4Z8bf4GH2VYLuQcy0wjhdl
         lkYsEmPpdZ3ZgD6V0rc4QHQXZl561Gm6rSNk0n4D1bskz9ok4qIuL0pnQPFcS3jm8jop
         8RVsL7eA0Y4nj8g/6EXf9dhbfr+8hfpYT/x+lKRH+rjmEVqsvifQk65ENC+YtqKTBWe1
         R6zCG1o0eSYdIxtKcMzE23pXFUIykxAZ83UWR3236YAU7MJX6GTi6hbd/mgYHTTcX5Kd
         JnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1t0RW3112O766MI4PtQuF8XjhRp95awZjAFSPxZK5U4=;
        b=UCw25bkePXbVvgP481QpmjBmPyreZVGolkZ/efsGeb+j8ijBjO8khpsrMrt8/NHrFg
         gOy/6dPkEFegAMW/3MDbecP2OMWM2KSLBfzy5iKEP43OdRX6ALCOlhTZeb2nxZ0NgSdu
         8xUHhKjoXrWxWQLJQnlRfMmFb8H2nYDNI2Iy2GPrExNbIWs73WKVAv1lrK+hS1P4uGwI
         5wDyp3QIwohXYlEL0uMcdgIGUVXpto4AlkNX2Pq0KB5Xd3VZ6Ud1/lz13sm3teUqkyjF
         T6DzDTrEiFyNLHNksx6/iy1NPRO2Pg90Q21qtg5yvWa7EfukWOgU3Y8VJQXiV0i6R8oH
         RvuQ==
X-Gm-Message-State: APjAAAWLyHrkaYEDZiggSmRsPyoR67eagACeOsJgzdGpmxtJFGCmuHK3
        t3MVoPciyEz4d0rrjUXHUxNCEGGgYiIHpdy2bFE=
X-Google-Smtp-Source: APXvYqx4ptzqWTl8hUGbmhPWSa6oNxLyznd2fubW3iUO39N/+CSonkODPN+weBayL1n6SR9m2/n5gzkI8OfhFjmwo/0=
X-Received: by 2002:a17:906:d298:: with SMTP id ay24mr21550954ejb.230.1566221869980;
 Mon, 19 Aug 2019 06:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190816163157.25314-1-h.feurstein@gmail.com> <20190816163157.25314-2-h.feurstein@gmail.com>
 <20190819131736.GD8981@lunn.ch> <CA+h21hou0v0gPURO3VHe2Ur1-heXnuueN5F92iDLffArB+1d5w@mail.gmail.com>
In-Reply-To: <CA+h21hou0v0gPURO3VHe2Ur1-heXnuueN5F92iDLffArB+1d5w@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 19 Aug 2019 16:37:39 +0300
Message-ID: <CA+h21hpe1JRBAGX5GwAZopuG9D2oe-+G+7Y026vBLPhhX--YNQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: mdio: add support for passing a PTP
 system timestamp to the mii_bus driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 at 16:34, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Andrew,
>
> On Mon, 19 Aug 2019 at 16:17, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Fri, Aug 16, 2019 at 06:31:55PM +0200, Hubert Feurstein wrote:
> > > In order to improve the synchronisation precision of phc2sys (from
> > > the linuxptp project) for devices like switches which are attached
> > > to the MDIO bus, it is necessary the get the system timestamps as
> > > close as possible to the access which causes the PTP timestamp
> > > register to be snapshotted in the switch hardware. Usually this is
> > > triggered by an MDIO write access, the snapshotted timestamp is then
> > > transferred by several MDIO reads.
> > >
> > > This patch adds the required infrastructure to solve the problem described
> > > above.
> > >
> > > Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
> > > ---
> > >  drivers/net/phy/mdio_bus.c | 105 +++++++++++++++++++++++++++++++++++++
> > >  include/linux/mdio.h       |   7 +++
> > >  include/linux/phy.h        |  25 +++++++++
> > >  3 files changed, 137 insertions(+)
> > >
> > > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > > index bd04fe762056..167a21f267fa 100644
> > > --- a/drivers/net/phy/mdio_bus.c
> > > +++ b/drivers/net/phy/mdio_bus.c
> > > @@ -34,6 +34,7 @@
> > >  #include <linux/phy.h>
> > >  #include <linux/io.h>
> > >  #include <linux/uaccess.h>
> > > +#include <linux/ptp_clock_kernel.h>
> > >
> > >  #define CREATE_TRACE_POINTS
> > >  #include <trace/events/mdio.h>
> > > @@ -697,6 +698,110 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
> > >  }
> > >  EXPORT_SYMBOL(mdiobus_write);
> > >
> > > +/**
> > > + * __mdiobus_write_sts - Unlocked version of the mdiobus_write_sts function
> > > + * @bus: the mii_bus struct
> > > + * @addr: the phy address
> > > + * @regnum: register number to write
> > > + * @val: value to write to @regnum
> > > + * @sts: the ptp system timestamp
> > > + *
> > > + * Write a MDIO bus register and request the MDIO bus driver to take the
> > > + * system timestamps when sts-pointer is valid. When the bus driver doesn't
> > > + * support this, the timestamps are taken in this function instead.
> > > + *
> > > + * In order to improve the synchronisation precision of phc2sys (from
> > > + * the linuxptp project) for devices like switches which are attached
> > > + * to the MDIO bus, it is necessary the get the system timestamps as
> > > + * close as possible to the access which causes the PTP timestamp
> > > + * register to be snapshotted in the switch hardware. Usually this is
> > > + * triggered by an MDIO write access, the snapshotted timestamp is then
> > > + * transferred by several MDIO reads.
> > > + *
> > > + * Caller must hold the mdio bus lock.
> > > + *
> > > + * NOTE: MUST NOT be called from interrupt context.
> > > + */
> > > +int __mdiobus_write_sts(struct mii_bus *bus, int addr, u32 regnum, u16 val,
> > > +                     struct ptp_system_timestamp *sts)
> > > +{
> > > +     int retval;
> > > +
> > > +     WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
> > > +
> > > +     if (!bus->ptp_sts_supported)
> > > +             ptp_read_system_prets(sts);
> >
> > How expensive is ptp_read_system_prets()? My original suggestion was
> > to unconditionally call it here, and then let the driver overwrite it
> > if it supports finer grained time stamping. MDIO is slow, so as long
> > as ptp_read_system_prets() is not too expensive, i prefer KISS.
> >
> >    Andrew
>
> While that works for the pre_ts, it doesn't work for the post_ts (the
> MDIO bus core will unconditionally overwrite the system timestamp from
> the driver).
> Unless you're suggesting to keep the pre_ts unconditional and the
> post_ts under the "if" condition, which is a bit odd.
> According to my tests with a scope (measuring the width between SPI
> transfers with and without the ptp_read_system_*ts calls), two calls
> to ktime_get_real_ts64 amount to around 750 ns on a 1200 MHz Cortex A7
> core, or around 90 clock cycles.

900 clock cycles, my bad.

>
> Regards,
> -Vladimir
