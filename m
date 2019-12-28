Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E55C12BD8A
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 13:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfL1MRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 07:17:36 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38445 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfL1MRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 07:17:36 -0500
Received: by mail-ed1-f68.google.com with SMTP id i16so27746639edr.5
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 04:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+z3ltaCnkcdRr/ThZbQTav6ywsJv4k6Ty7dm7e4N7wc=;
        b=CvIKiJa/lNewsSG3OaauP9P2JUTdV5vKagSC2fYiXlFoWUGmO22erOBiKzRdJ4Jdjt
         BCdhJB/qoBFX9ia3/7sUFiCP2Mnr3bTO18eilvZCPk9ja2haOGxQpqiHQDvGJXhpSXVa
         6tm76gaKgsf6mGWpf90v4GMGx4UsDHhHmF9QRJuuofJk2OunxsnTybG19Jo/fuXBjqRd
         myU2V61pB+9qHTkdTO4/rRyq0SF4Af1xpQese2iPhiX/vhcGlESRJfR16g+bYz4HirbD
         a1EdPuqccpvWJgXXumZ92eneDtW6HPGbaeqvnpTT8Bhcuz9EoGx3TCiCD9AoP9l8qQjS
         s+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+z3ltaCnkcdRr/ThZbQTav6ywsJv4k6Ty7dm7e4N7wc=;
        b=MuP+U2Bxacjl4FPsZETthVMt6OUsnjoZJ3LEO3s+RGhETPKveteHWptMxXsDtECXnC
         BHPIIvZyJfnJQJBr/UhypHs0BKOqlDhGd9Jwa+t+oiu0FY6+IHsZQYaLzfvagJiU9DO1
         tibAPRF6nnWDccsBzrFr1bRQ5Qbgj4jqXZoMXRvYa81oJ7dM9g6HPWXL4X+vHDQu6iwv
         A4v3JN7QmlEPZjyvKCrt1R+1g7LTi7TFC62TC4S6sQ5PuxlDKET6YOrQknZ2AMbthLzh
         kSo4GxL2FKL+OXKLUHXU6EmoDYwwXfoBKHkcxnA4dsCP+wxYVoOnVnirM/j537y1Apiy
         PIJA==
X-Gm-Message-State: APjAAAWs1QNQZs8TtsAL38FqbIVwli5IeROKNQGB+GS2HWIqljWclAXh
        j3jdOeKaos3X5xh1JD6vh8HqYFi1lm5OPmyBrSY=
X-Google-Smtp-Source: APXvYqxcsooLHnpIqhHTGe/O0PrmFsukGCtXKjTJI70VDD0JWRMLrMwTgIWI26BnGqORvRII3QVDCsQ+3iaSkGXi9C8=
X-Received: by 2002:a05:6402:1d08:: with SMTP id dg8mr59084866edb.117.1577535454105;
 Sat, 28 Dec 2019 04:17:34 -0800 (PST)
MIME-Version: 1.0
References: <20191227213626.4404-1-olteanv@gmail.com> <20191227213626.4404-6-olteanv@gmail.com>
In-Reply-To: <20191227213626.4404-6-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 28 Dec 2019 14:17:23 +0200
Message-ID: <CA+h21ho4D2Aj9GkWwNdc19i1KUL0tYGmtxX6b0QZ3Wzv9q2Bvg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 05/11] net: phy: Add a property for
 controlling in-band auto-negotiation
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Dec 2019 at 23:36, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This patch aims to solve a simple problem: for SerDes interfaces, the
> MAC has a PCS layer which serializes the data before passing it to the
> link partner (typically a PHY with its own PCS, but not necessarily, it
> can also be a remote PHY).
>
> Some of these SerDes protocols have a configuration word that is
> transmitted in-band, to establish the link parameters. Some SerDes
> implementations strictly require this handshake (in-band AN) to complete
> before passing data, while on others it may be bypassed.
>
> From a user perspective, the top-most entity of this in-band AN
> relationship is the MAC PCS, driven by an Ethernet driver.
> When the MAC PCS operates as PHY-less, there is little that can be done
> from our side to prevent a settings mismatch, since the link partner may
> be remote and outside our control.
> When the MAC PCS is connected to a PHY driven by the PHY library, that
> is when we want to ensure the in-band AN settings are in sync and can be
> fulfilled by both parties.
>
> This setting is ternary and requested by the MAC PCS driver. For
> compatibility with existing code, we introduce a IN_BAND_AN_DEFAULT
> state equal to 0, which means that the MAC driver, caller of the PHY
> library, has no opinion about in-band AN settings. It is assumed that
> somebody else has taken care of this setting and nothing should be done.
>
> When the PHYLIB caller requests an explicit setting (IN_BAND_AN_ENABLED
> or IN_BAND_AN_DISABLED), the PHY driver must veto this operation in its
> .config_init callback if it can't do as requested. As mentioned, this is
> to avoid mismatches, which will be taken to result in failure to pass
> data between MAC and PHY.
>
> As for the caller of PHYLIB, it shouldn't hardcode any particular value
> for phydev->in_band_autoneg, but rather take this information from a
> board description file such as device tree. This gives the caller a
> chance to veto the setting as well, if it doesn't support it, and it
> leaves the choice at the level of individual MAC-PHY instances instead
> of drivers. A more-or-less standard device tree binding that can be used
> to gather this information is:
>         managed = "in-band-status";
> which PHYLINK already uses.
>
> Make PHYLINK the first user of this scheme, by parsing the DT binding
> mentioned above and passing it to the PHY library.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v3:
> - Patch is new.
>
>  drivers/net/phy/phylink.c |  2 ++
>  include/linux/phy.h       | 18 ++++++++++++++++++
>  2 files changed, 20 insertions(+)
>
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 73a01ea5fc55..af574d5a8426 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -878,6 +878,8 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
>         if (!phy_dev)
>                 return -ENODEV;
>
> +       phy_dev->in_band_autoneg = (pl->cfg_link_an_mode == MLO_AN_INBAND);
> +

Oops, I sent an intermediary version of this patch, from when
in_band_autoneg was binary and not ternary.
So this should read:
        if (pl->cfg_link_an_mode == MLO_AN_INBAND)
                phy_dev->in_band_autoneg = IN_BAND_AN_ENABLED;
        else
                phy_dev->in_band_autoneg = IN_BAND_AN_DISABLED;

Will correct when I accumulate enough feedback for v4.

>         ret = phy_attach_direct(pl->netdev, phy_dev, flags,
>                                 pl->link_interface);
>         if (ret)
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 30e599c454db..090e4ba303e2 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -318,6 +318,22 @@ enum phy_state {
>         PHY_NOLINK,
>  };
>
> +/* Settings for system-side PHY auto-negotiation:
> + * - IN_BAND_AN_DEFAULT: the PHY is left in the default configuration, be it
> + *   out-of-reset, preconfigured by boot firmware, etc. In-band AN can be
> + *   disabled, enabled or even unsupported when this setting is on.
> + * - IN_BAND_AN_ENABLED: the PHY must enable system-side auto-negotiation with
> + *   the attached MAC, or veto this setting if it can't.
> + * - IN_BAND_AN_DISABLED: the PHY must disable or bypass system-side
> + *   auto-negotiation with the attached MAC (and force the link settings if
> + *   applicable), or veto this setting if it can't.
> + */
> +enum phy_in_band_autoneg {
> +       IN_BAND_AN_DEFAULT = 0,
> +       IN_BAND_AN_ENABLED,
> +       IN_BAND_AN_DISABLED,
> +};
> +
>  /**
>   * struct phy_c45_device_ids - 802.3-c45 Device Identifiers
>   * @devices_in_package: Bit vector of devices present.
> @@ -388,6 +404,8 @@ struct phy_device {
>         /* Interrupts are enabled */
>         unsigned interrupts:1;
>
> +       enum phy_in_band_autoneg in_band_autoneg;
> +
>         enum phy_state state;
>
>         u32 dev_flags;
> --
> 2.17.1
>

Thanks,
-Vladimir
