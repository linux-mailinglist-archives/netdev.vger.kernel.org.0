Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E61A207F3F
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388521AbgFXWUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbgFXWUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 18:20:30 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A50C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 15:20:28 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id m16so1762387ybf.4
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 15:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G0qZ3dxpUitxlhzTm3VthsEgQ1njwpXgNZJ2OSKK5TU=;
        b=VIObG0eKwsL9KtUUkbtVkplm8WgvYIHJNBHEpHMaWAWc60MSCLxU0nhRk5pvDXFJJv
         XmG9mHiS2RzBBCHg57J081HZ3seVFhdf31aGMCdM5h6v4wM7CX4cT4tW0+HeoxHaWYL7
         ivxMlPyaTHi+KRlT++6F58Zq1oCcJjY4EcmlX7xtnRMw/4uOaEoQjOrlH0qkgEWXn+/F
         D8ZUdAqxg+TaSsEV1KqumKiXYPyUO0DdLM0IZTrqRPcuaB80BqPYQXrMATDicKio51Eg
         8Hf5HtiWDbMhVDswZc5HUfVpsmSOmpkGosWw53U7/c74LGQI5yxevP/0NAU3F3N0nI51
         0uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G0qZ3dxpUitxlhzTm3VthsEgQ1njwpXgNZJ2OSKK5TU=;
        b=teRzR5SCAAxegphC5bQtG1rP3fbm42pyo0NqAq9jGnZce1TqwUS3GaSoQrfsRqvWoh
         B6LFb6JIXVj40EoMXASNr7l/GS+UEmcU7+hO024ahKN0OkTJfU5pFZQYpcPG6iehCL7B
         fmqnUW+8OmRQbSX7okbvVjgkX/55rN4n9V4sducXuPZGinhEWGDxKyGXG2NMyOc/OXla
         ebI8HZgfdqwzQ0uMZbl3qXg8H8dsIdqfXFPWr9Zf9+B6tvg1/ZJIFG0ffc5nXmCaIWSk
         g7Wazd8LtVONH3SoZuoE6fVCQ8DrolD1XJhbNip2oMW9UwJSrtd/lsPZ9oMNJM59n7Ck
         fEUg==
X-Gm-Message-State: AOAM533szKFNs8NZeOdoraw58SqbYx/RNVHXOS/XO4rLM6kXMaWE+mid
        b0JnNBTqUrKGENuO7+CD6nLBzUvVleQOTi5O694=
X-Google-Smtp-Source: ABdhPJzw9zj94xmE17/EGmBT0eLB2Fd+aJfbIdHBH4yNVgsd96LO8qyVVTCLXzujCZ2sd8wEbgx4Jad86s2wvKzdshg=
X-Received: by 2002:a25:bd8e:: with SMTP id f14mr48956449ybh.165.1593037227844;
 Wed, 24 Jun 2020 15:20:27 -0700 (PDT)
MIME-Version: 1.0
References: <E1jo2Iw-0005N1-3b@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1jo2Iw-0005N1-3b@rmk-PC.armlinux.org.uk>
From:   =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Date:   Thu, 25 Jun 2020 00:20:16 +0200
Message-ID: <CABwr4_sNP-aPNv5GrUyipYpVztzp0jFOzmaq23LrGKtqpZMANw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: phylink: add phylink_speed_(up|down) interface
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell.
I've tested my WoL patch reworked with the phylink_speed_(up|down)
functions on a LS421DE device and it works quite fine.

I'll sent another patch when this one got merged.

Thank you.
Daniel

El mi=C3=A9., 24 jun. 2020 a las 12:06, Russell King
(<rmk+kernel@armlinux.org.uk>) escribi=C3=B3:
>
> Add an interface for the phy_speed_(up|down) functions when a driver
> makes use of phylink. These pass the call through to phylib when we
> have a normal PHY attached (i.o.w., not a PHY on a SFP module.)
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> This is to support the work by Daniel Gonz=C3=A1lez Cabanelas for mvneta =
WoL,
> but at the present time, this has no users (hence no patch 2). I hope
> mvneta WoL support can be revived soon with the aid of this patch.
> (Resent with Daniel's name fixed.)
>
>  drivers/net/phy/phylink.c | 48 +++++++++++++++++++++++++++++++++++++++
>  include/linux/phylink.h   |  2 ++
>  2 files changed, 50 insertions(+)
>
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 7ce787c227b3..7cda1646bbf7 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1826,6 +1826,54 @@ int phylink_mii_ioctl(struct phylink *pl, struct i=
freq *ifr, int cmd)
>  }
>  EXPORT_SYMBOL_GPL(phylink_mii_ioctl);
>
> +/**
> + * phylink_speed_down() - set the non-SFP PHY to lowest speed supported =
by both
> + *   link partners
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + * @sync: perform action synchronously
> + *
> + * If we have a PHY that is not part of a SFP module, then set the speed
> + * as described in the phy_speed_down() function. Please see this functi=
on
> + * for a description of the @sync parameter.
> + *
> + * Returns zero if there is no PHY, otherwise as per phy_speed_down().
> + */
> +int phylink_speed_down(struct phylink *pl, bool sync)
> +{
> +       int ret =3D 0;
> +
> +       ASSERT_RTNL();
> +
> +       if (!pl->sfp_bus && pl->phydev)
> +               ret =3D phy_speed_down(pl->phydev, sync);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(phylink_speed_down);
> +
> +/**
> + * phylink_speed_up() - restore the advertised speeds prior to the call =
to
> + *   phylink_speed_down()
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * If we have a PHY that is not part of a SFP module, then restore the
> + * PHY speeds as per phy_speed_up().
> + *
> + * Returns zero if there is no PHY, otherwise as per phy_speed_up().
> + */
> +int phylink_speed_up(struct phylink *pl)
> +{
> +       int ret =3D 0;
> +
> +       ASSERT_RTNL();
> +
> +       if (!pl->sfp_bus && pl->phydev)
> +               ret =3D phy_speed_up(pl->phydev);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(phylink_speed_up);
> +
>  static void phylink_sfp_attach(void *upstream, struct sfp_bus *bus)
>  {
>         struct phylink *pl =3D upstream;
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index cc5b452a184e..b32b8b45421b 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -392,6 +392,8 @@ int phylink_init_eee(struct phylink *, bool);
>  int phylink_ethtool_get_eee(struct phylink *, struct ethtool_eee *);
>  int phylink_ethtool_set_eee(struct phylink *, struct ethtool_eee *);
>  int phylink_mii_ioctl(struct phylink *, struct ifreq *, int);
> +int phylink_speed_down(struct phylink *pl, bool sync);
> +int phylink_speed_up(struct phylink *pl);
>
>  #define phylink_zero(bm) \
>         bitmap_zero(bm, __ETHTOOL_LINK_MODE_MASK_NBITS)
> --
> 2.20.1
>
