Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C8914C8A4
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgA2KPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:15:31 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43479 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgA2KPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 05:15:31 -0500
Received: by mail-ed1-f65.google.com with SMTP id dc19so17988516edb.10
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 02:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oBgsd5SqZM1sApQaNN0ISGRtZQIErBKFo4qEvD7PuB8=;
        b=aRJyGTi4pZzZ/pt4oEEPcCEacx62V5HU4p38G0O6jF5l/MwV4whjEd5Hs5nKZ7sS9b
         uEffCpN2QBu54RP2E3bclah5UYpexgjQwsUzI5aaQkSZuoxGbIYyg+zk05w+YDfG0hDT
         nkW59PhHez1JCo9cMLIJdf6vHbScgqfoYmLrQAR4vZHxY/EJf4OuV+v8S84AD85+ai6x
         2cLVuQXK2BvvzwNhtQdCVOfUIPZJNSg7pwdZlPMVVDCT0V+/ZhWMcYXwpsVxDq3lmQxl
         wPq2V/+0ehLxVcdrxvWWnuRMDHC8yf5qKRl8l2gocXRBF80U9AEoTTYl0NnQHwviqUAI
         d3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oBgsd5SqZM1sApQaNN0ISGRtZQIErBKFo4qEvD7PuB8=;
        b=PZpMPQqHVT6Sjr40Gtsqe97lQb3y43mkFXjij7Dx5ymqmYGPu80MrV4Qw1iGOlzaj/
         dV/2aw8IPL4MZrQ1oOf/Qh8+7xL7FoMWRqh9p758bkxQNuoDZHL6CTs9nthHZ/ukdGOj
         sMNZvk0i64a2iqLmZwDT3IBYIecplslYQYMj32LxgER2VSxM42kAbzIxnJhz+kqt9GNu
         rXga6zo4mULouqQOoX37Ccl2ZOgMs6EpsRprLDYbCQUelG0cNig+mHqx2AYk8z/kWBD3
         6c71JEdfGmj6bfWcwhVZ2bivdjmokP41uJ+eKqpYhebRMJlAwJbLUl4anfTpxyGKiYE+
         wXvA==
X-Gm-Message-State: APjAAAX6zaDW8OV8qJsuBuw0dYBRNNhLNT/cCNCL834tAa+klBgdXSKl
        IjBrcYe2OS/Dn2QC4P1J1SxV0OpsoxwZUS5e6uQ=
X-Google-Smtp-Source: APXvYqwd9myYlqnup59cHHT4rpN7ot5ZyFUR0qPpfut8T7bpiCIPFDD9jFizcvVVZQz9Qj/n3EgNJxbZp3dHGBH91+Y=
X-Received: by 2002:a17:906:4c50:: with SMTP id d16mr6670590ejw.176.1580292928852;
 Wed, 29 Jan 2020 02:15:28 -0800 (PST)
MIME-Version: 1.0
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com> <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com> <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
 <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 29 Jan 2020 12:15:17 +0200
Message-ID: <CA+h21hpSpgQsQ0kRmSaC2qfmFj=0KadDjwEK2Bvkz72g+iGxBQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation indication
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madalin,

On Wed, 29 Jan 2020 at 11:38, Madalin Bucur (OSS)
<madalin.bucur@oss.nxp.com> wrote:
>
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Tuesday, January 28, 2020 5:55 PM
> > To: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; davem@davemloft.net;
> > andrew@lunn.ch; hkallweit1@gmail.com; netdev@vger.kernel.org;
> > ykaukab@suse.de
> > Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
> > indication
> >
> > Hi Florian,
> >
> > On Mon, 27 Jan 2020 at 19:44, Florian Fainelli <f.fainelli@gmail.com>
> > wrote:
> > >
> > > On 1/22/20 11:38 PM, Madalin Bucur (OSS) wrote:
> > > >> -----Original Message-----
> > > >> From: Florian Fainelli <f.fainelli@gmail.com>
> > > >> Sent: Wednesday, January 22, 2020 7:58 PM
> > > >> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> > davem@davemloft.net
> > > >> Cc: andrew@lunn.ch; hkallweit1@gmail.com; netdev@vger.kernel.org;
> > > >> ykaukab@suse.de
> > > >> Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add
> > rate_adaptation
> > > >> indication
> > > >>
> > > >> On 1/22/20 5:59 AM, Madalin Bucur wrote:
> > > >>> The AQR PHYs are able to perform rate adaptation between
> > > >>> the system interface and the line interfaces. When such
> > > >>> a PHY is deployed, the ethernet driver should not limit
> > > >>> the modes supported or advertised by the PHY. This patch
> > > >>> introduces the bit that allows checking for this feature
> > > >>> in the phy_device structure and its use for the Aquantia
> > > >>> PHYs.
> > > >>>
> > > >>> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > >>> ---
> > > >>>  drivers/net/phy/aquantia_main.c | 3 +++
> > > >>>  include/linux/phy.h             | 3 +++
> > > >>>  2 files changed, 6 insertions(+)
> > > >>>
> > > >>> diff --git a/drivers/net/phy/aquantia_main.c
> > > >> b/drivers/net/phy/aquantia_main.c
> > > >>> index 975789d9349d..36fdd523b758 100644
> > > >>> --- a/drivers/net/phy/aquantia_main.c
> > > >>> +++ b/drivers/net/phy/aquantia_main.c
> > > >>> @@ -209,6 +209,9 @@ static int aqr_config_aneg(struct phy_device
> > > >> *phydev)
> > > >>>     u16 reg;
> > > >>>     int ret;
> > > >>>
> > > >>> +   /* add here as this is called for all devices */
> > > >>> +   phydev->rate_adaptation = 1;
> > > >>
> > > >> How about introducing a new PHY_SUPPORTS_RATE_ADAPTATION flag and
> > you
> > > >> set that directly from the phy_driver entry? using the "flags"
> > bitmask
> > > >> instead of adding another structure member to phy_device?
> > > >
> > > > I've looked at the phydev->dev_flags use, it seemed to me that mostly
> > it
> > > > is used to convey configuration options towards the PHY.
> > >
> > > You read me incorrectly, I am suggesting using the phy_driver::flags
> > > member, not the phy_device::dev_flags entry, please re-consider your
> > > position.
> > >
> >
> > Whether the PHY performs rate adaptation is a dynamic property.
> > It will perform it at wire speeds lower than 2500Mbps (1000/100) when
> > system side is 2500Base-X, but not at wire speed 2500 & 2500Base-X,
> > and not at wire speed 1000 & USXGMII.
> > You can't really encode that in phydev->flags.
>
> Vladimir, the patch adds a bit that indicates the PHY ability to perform
> rate adaptation, not whether it is actually in use in a certain combination
> of system interface and line interface modes. Please review the submission

As far as I understand, for Aquantia devices this is a 3-way switch for:
- No rate adaptation
- USX rate adaptation
- Pause rate adaptation.
So what does your "phydev->rate_adaptation = 1" assignment mean?

From context and datasheet I deduced that you mean "the PHY is
configured to send PAUSE frames for 10GBase-R and 2500Base-X modes",
which are probably the modes in which you're using it.

But how do you _know_ that the PHY has this switch set correctly? It
is either set by firmware or by MDIO, but I don't see any of that
being checked for.

> again, I understand you have something slightly different in mind, but this
> is just addressing a basic need of knowing whether there is a chance the
> line side could work at other speeds than the system interface and allow it
> to do so.

I do understand this works, when it works, _for your board_, but is it
generic enough that other systems can work with this simple setting?
What if somebody else reads "phydev->rate_adaptation" to mean "USX
adaptation"?

>
> > I was actually searching for a way to encode some more PHY capabilities:
> > - Does it work with in-band autoneg enabled?
> > - Does it work with in-band autoneg bypassed?
> > - Does it emit pause frames? <- Madalin got ahead of me on this one.
> >
> > For the first 2, I want a mechanism for the PHY library to figure out
> > whether the MAC and the PHY should use in-band autoneg or not. If both
> > support in-band autoneg, that would be preferred. Otherwise,
> > out-of-band (MDIO) is preferred, and in-band autoneg is explicitly
> > disabled in both, if that is claimed to be supported. Otherwise,
> > report error to user. Yes, this deprecates "managed =
> > 'in-band-status'" in the device tree, and that's for (what I think is)
> > the better. We can make "managed = 'in-band-status'" to just clear the
> > MAC's ability to support the "in-band autoneg bypassed" mode.
> >
> > So I thought a function pointer in the phy driver would be better, and
> > more extensible.
> > Thoughts?
>
> This is where you get when you try to implement anti-stupid devices, it gets
> complicated fast and, most often, it gets in the way. Should someone change
> a setting (pause settings) and experience adverse effects (excessive frame
> loss), we should rely on his analytical abilities to connect the dots, imho.
>

So you think that having a PHY firmware with rate adaptation disabled
is "stupid user"?
What if the rate adaptation feature is not enabled in firmware, but is
being enabled by U-Boot, but the user had the generic PHY driver
instead of the Aquantia one, or used a different or old bootloader?
"Stupid user"?
The PHY and the Ethernet driver are strongly decoupled, so they need
to agree on an operating mode that will work for both of them.
Ideally the PHY would really know how it's configured, not just
hardcode "yeah, I can do rate adaptation, try me".
The fact that you can build sanity checks on top (like in this case
not allowing the user to disable pause frames in the Ethernet driver
on RX), that don't stand in the way, is just proof that the system is
well designed. If you can't build sanity checks, or if they stand in
the way, it isn't.

If anything, why haven't you considered the opposite logic here:
- Ethernet driver (dpaa_eth) supports all speeds 10G and below.
- PHY driver (or PHY core) removes the supported and advertised speeds
for anything other than 2.5G and 10G if it can't do this rate
adaptation thing, and its system side isn't USXGMII. It's not like
this is dpaa_eth specific in any way.

> Madalin
>
>
> > > --
> > > Florian
> >
> > Regards,
> > -Vladimir

-Vladimir
