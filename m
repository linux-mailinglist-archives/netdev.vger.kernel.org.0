Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8D414BD53
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 16:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgA1PzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 10:55:15 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42978 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgA1PzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 10:55:14 -0500
Received: by mail-ed1-f67.google.com with SMTP id e10so15175548edv.9
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 07:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qGIiUOZMSbrb8tNprTBeC0Xhk7ckctuqIPEBHtJ/gS4=;
        b=IAvcA1nxD9r2YlM5AggkOFRDDxiQO7b0aeoOW8xIiuymMAgL5ex5Yje4BKXDUysORS
         OnOfa1yEoP7Kd0WCRSQcLYjlTQLKHJfWecwBOk/EwKEbak3Uv1ZjZkVatJBFAIpGeiZF
         pEIDTe/L2Eagc4JF907i3Ym/VMmdhtyL9PbTSUhOfg5vvcUsWLAuRw+w4R6lRHWO4ytg
         5fgro/ck7yE6hZl/q+TUwOiLKLFuX1LHXVfOhyttIho+hiCOneiXXkwZTmUb4b8F/hhq
         6HfpjKtb2tfVj0nujMDqolZaxNscTmyVfsi/nbGx9ic/jRzbGSlQftnaEsCLiG5UckUa
         j1Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qGIiUOZMSbrb8tNprTBeC0Xhk7ckctuqIPEBHtJ/gS4=;
        b=g67qOMxSo7VIHZcYaiTQvo9l0eunrnWf7KbnVhuJ/mkvgfKwi/OWTc+x1bCHEimTSM
         JQHS2BjXmVaS8WzQZwIza1P5l+MvG/bJSgzTCJvIefgONdwF23UvLY1YF2mtMHsa8RDi
         U/pXGZ8zoQc0XwvmWn4lsUDjV4rupRBZf4Bq7wrYgHDisUJQUIxwa+ZRt17cHo3I88DQ
         i1ckRhUzN0ObdsDfUL3IRK1um6iwCf+sP68ck0YpWHd2VyA31vVOkEC4CUGiFLFSIwP+
         VxjiX0ku6O+wd5m7PFsh2cSasXSbEfLWG3xDI99n63IQVdpz+3t9gCrzpLO3oUenHeuH
         YwwQ==
X-Gm-Message-State: APjAAAUGbEFeau0S7u9ASrBWLhwrLeJiUm50dN97xPcQCOBoMgZuo28Q
        Nkui0EkAp5+5QQt1EbXm9visOHfRfKuhKPGZ9R8=
X-Google-Smtp-Source: APXvYqzFqkxjF3+J/NZT2FKqJby7MYq4ZjS0CewYPMea7Lx00COuh/a6c+9uWNG8/74tx1+i9A1v1qqomaoXojFNc5I=
X-Received: by 2002:a17:906:f49:: with SMTP id h9mr3869783ejj.6.1580226912729;
 Tue, 28 Jan 2020 07:55:12 -0800 (PST)
MIME-Version: 1.0
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com> <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
In-Reply-To: <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 28 Jan 2020 17:55:01 +0200
Message-ID: <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation indication
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, 27 Jan 2020 at 19:44, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 1/22/20 11:38 PM, Madalin Bucur (OSS) wrote:
> >> -----Original Message-----
> >> From: Florian Fainelli <f.fainelli@gmail.com>
> >> Sent: Wednesday, January 22, 2020 7:58 PM
> >> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; davem@davemloft.net
> >> Cc: andrew@lunn.ch; hkallweit1@gmail.com; netdev@vger.kernel.org;
> >> ykaukab@suse.de
> >> Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
> >> indication
> >>
> >> On 1/22/20 5:59 AM, Madalin Bucur wrote:
> >>> The AQR PHYs are able to perform rate adaptation between
> >>> the system interface and the line interfaces. When such
> >>> a PHY is deployed, the ethernet driver should not limit
> >>> the modes supported or advertised by the PHY. This patch
> >>> introduces the bit that allows checking for this feature
> >>> in the phy_device structure and its use for the Aquantia
> >>> PHYs.
> >>>
> >>> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> >>> ---
> >>>  drivers/net/phy/aquantia_main.c | 3 +++
> >>>  include/linux/phy.h             | 3 +++
> >>>  2 files changed, 6 insertions(+)
> >>>
> >>> diff --git a/drivers/net/phy/aquantia_main.c
> >> b/drivers/net/phy/aquantia_main.c
> >>> index 975789d9349d..36fdd523b758 100644
> >>> --- a/drivers/net/phy/aquantia_main.c
> >>> +++ b/drivers/net/phy/aquantia_main.c
> >>> @@ -209,6 +209,9 @@ static int aqr_config_aneg(struct phy_device
> >> *phydev)
> >>>     u16 reg;
> >>>     int ret;
> >>>
> >>> +   /* add here as this is called for all devices */
> >>> +   phydev->rate_adaptation = 1;
> >>
> >> How about introducing a new PHY_SUPPORTS_RATE_ADAPTATION flag and you
> >> set that directly from the phy_driver entry? using the "flags" bitmask
> >> instead of adding another structure member to phy_device?
> >
> > I've looked at the phydev->dev_flags use, it seemed to me that mostly it
> > is used to convey configuration options towards the PHY.
>
> You read me incorrectly, I am suggesting using the phy_driver::flags
> member, not the phy_device::dev_flags entry, please re-consider your
> position.
>

Whether the PHY performs rate adaptation is a dynamic property.
It will perform it at wire speeds lower than 2500Mbps (1000/100) when
system side is 2500Base-X, but not at wire speed 2500 & 2500Base-X,
and not at wire speed 1000 & USXGMII.
You can't really encode that in phydev->flags.

I was actually searching for a way to encode some more PHY capabilities:
- Does it work with in-band autoneg enabled?
- Does it work with in-band autoneg bypassed?
- Does it emit pause frames? <- Madalin got ahead of me on this one.

For the first 2, I want a mechanism for the PHY library to figure out
whether the MAC and the PHY should use in-band autoneg or not. If both
support in-band autoneg, that would be preferred. Otherwise,
out-of-band (MDIO) is preferred, and in-band autoneg is explicitly
disabled in both, if that is claimed to be supported. Otherwise,
report error to user. Yes, this deprecates "managed =
'in-band-status'" in the device tree, and that's for (what I think is)
the better. We can make "managed = 'in-band-status'" to just clear the
MAC's ability to support the "in-band autoneg bypassed" mode.

So I thought a function pointer in the phy driver would be better, and
more extensible.
Thoughts?

> --
> Florian

Regards,
-Vladimir
