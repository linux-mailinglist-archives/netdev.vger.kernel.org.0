Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538D11933D8
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 23:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCYWpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 18:45:25 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34667 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgCYWpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 18:45:24 -0400
Received: by mail-ed1-f65.google.com with SMTP id i24so4730899eds.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 15:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=60Sj//brp0waebw4IaS2apA5OIFFLo+0sjfnOe82fnk=;
        b=lqPuZkjDNP9/jp9bukQMpUC/8T0CAJ1SSGneibhPjUWP6lxKW1wv/rZgohcda/2wn2
         4koBU4Y46FX/wqKpiqWgsFmSBgRPberYBFxG9MyPnRWaMm8P5dyns/YjhjJXrMkz8xKc
         vcJcio0GOO5tq0yLT611Cxa5exaf6Eibft8NOwWbCeke3X939CVOpDf+6zTmfIRNLCAN
         jQhEuUFc2amBBqEquy6HWwVP4Nvq190eM20KQtr9Syn3lWSCIuvNSavU9YUxO3qXaQvC
         Cx3/jOwb8M6PJA46Ngpj6uDxtUWiHA2vDYc0oFBnviF8yTw4PsohFlbD725KffC9fEDh
         jz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=60Sj//brp0waebw4IaS2apA5OIFFLo+0sjfnOe82fnk=;
        b=j5Cpj0CLiLcWQZnwnfaLeIs6pzuMI0j/nRO96fGJ6aZTUpd0YKcgLYMzyBVWscvKMG
         5vEUd2MZRbehmWms4/5JbPCkOYn1kPsQsPpkxjfFaSHg9UDpNsmBtTB8ZA3RpPVPaDCn
         f6qUZvkQ74IjPqbOTVjMT+N3vhybYQDBNGtm/cvSCAcZotfKSK0r/sEMcVf9SzCw3k26
         ABdy+4ojFmPDU2sYlRYtevExsCmqGHeRPq2lXQ9PAKSl5YO0BpY+mR6qmiszIR3eGe7A
         o2wBNf8K/M45kwQF+5He/dRMx/yoesTzdgwYkiuVaHxNz2faAzZ1WXraHgHzBpInw/ab
         BwFg==
X-Gm-Message-State: ANhLgQ3q1zgyeMEp7qIqImKSB6QcaVxs0yHdnAsKkiAu/iis9Dp+kEjH
        ySt03pgqhx0Pz4a0J++vWnA9byYjiXYhddI1cIw=
X-Google-Smtp-Source: ADFU+vtwjkv5g9ZJuP6o96t/0Wa3uW/OW37TEu8j75TsFPjlowMVe0zRQeUdcSWI/0dKMzUEnQ81+OnKB2y7I+dJ/oI=
X-Received: by 2002:a17:906:9359:: with SMTP id p25mr5370416ejw.184.1585176321504;
 Wed, 25 Mar 2020 15:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200325152209.3428-1-olteanv@gmail.com> <20200325152209.3428-3-olteanv@gmail.com>
 <ec070d0f-3712-8663-f39f-124b7f802450@gmail.com>
In-Reply-To: <ec070d0f-3712-8663-f39f-124b7f802450@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Mar 2020 00:45:10 +0200
Message-ID: <CA+h21hrJyxDX98dzY0TbySKqXvC1+jkNJb0z+17LPOSN8=WeqA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 02/10] net: phy: bcm7xx: Add jumbo frame
 configuration to PHY
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 at 17:44, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 25.03.2020 16:22, Vladimir Oltean wrote:
> > From: Murali Krishna Policharla <murali.policharla@broadcom.com>
> >
> > Add API to configure jumbo frame settings in PHY during initial PHY
> > configuration.
> >
> > Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
> > Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/phy/bcm-phy-lib.c | 28 ++++++++++++++++++++++++++++
> >  drivers/net/phy/bcm-phy-lib.h |  1 +
> >  drivers/net/phy/bcm7xxx.c     |  4 ++++
> >  include/linux/brcmphy.h       |  1 +
> >  4 files changed, 34 insertions(+)
> >
> > diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
> > index e0d3310957ff..a26c80e13b43 100644
> > --- a/drivers/net/phy/bcm-phy-lib.c
> > +++ b/drivers/net/phy/bcm-phy-lib.c
> > @@ -423,6 +423,34 @@ int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev)
> >  }
> >  EXPORT_SYMBOL_GPL(bcm_phy_28nm_a0b0_afe_config_init);
> >
> > +int bcm_phy_enable_jumbo(struct phy_device *phydev)
> > +{
> > +     int val = 0, ret = 0;
> > +
> > +     ret = phy_write(phydev, MII_BCM54XX_AUX_CTL,
> > +                     MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     val = phy_read(phydev, MII_BCM54XX_AUX_CTL);
> > +
> > +     /* Enable extended length packet reception */
> > +     val |= MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN;
> > +     ret = phy_write(phydev, MII_BCM54XX_AUX_CTL, val);
> > +
>
> There are different helpers already in bcm-phy-lib,
> e.g. bcm54xx_auxctl_read. Also bcm_phy_write_misc()
> has has quite something in common with your new function.
> It would be good if a helper could be used here.
>

Thanks Heiner.
I'm not quite sure the operation is performed correctly though? My
books are telling me that the "Receive Extended Packet Length" field
is accessible via the Auxiliary Control Register 0x18 when the shadow
value is 000, not 111 as this patch is doing. At least for BCM54xxx in
terms of which the macros are defined. Am I wrong?

> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     val = phy_read(phydev, MII_BCM54XX_ECR);
> > +
> > +     /* Enable 10K byte packet length reception */
> > +     val |= BIT(0);
> > +     ret =  phy_write(phydev, MII_BCM54XX_ECR, val);
> > +
>
> Why not use phy_set_bits() ?
>

Well, the reason is that I didn't write the patch. I'll simplify it.

> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(bcm_phy_enable_jumbo);
> > +
> >  MODULE_DESCRIPTION("Broadcom PHY Library");
> >  MODULE_LICENSE("GPL v2");
> >  MODULE_AUTHOR("Broadcom Corporation");
> > diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
> > index c86fb9d1240c..129df819be8c 100644
> > --- a/drivers/net/phy/bcm-phy-lib.h
> > +++ b/drivers/net/phy/bcm-phy-lib.h
> > @@ -65,5 +65,6 @@ void bcm_phy_get_stats(struct phy_device *phydev, u64 *shadow,
> >                      struct ethtool_stats *stats, u64 *data);
> >  void bcm_phy_r_rc_cal_reset(struct phy_device *phydev);
> >  int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev);
> > +int bcm_phy_enable_jumbo(struct phy_device *phydev);
> >
> >  #endif /* _LINUX_BCM_PHY_LIB_H */
> > diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
> > index af8eabe7a6d4..692048d86ab1 100644
> > --- a/drivers/net/phy/bcm7xxx.c
> > +++ b/drivers/net/phy/bcm7xxx.c
> > @@ -178,6 +178,10 @@ static int bcm7xxx_28nm_config_init(struct phy_device *phydev)
> >               break;
> >       }
> >
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret =  bcm_phy_enable_jumbo(phydev);
> >       if (ret)
> >               return ret;
> >
> > diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
> > index b475e7f20d28..19bd86019e93 100644
> > --- a/include/linux/brcmphy.h
> > +++ b/include/linux/brcmphy.h
> > @@ -119,6 +119,7 @@
> >  #define MII_BCM54XX_AUXCTL_SHDWSEL_AUXCTL    0x00
> >  #define MII_BCM54XX_AUXCTL_ACTL_TX_6DB               0x0400
> >  #define MII_BCM54XX_AUXCTL_ACTL_SMDSP_ENA    0x0800
> > +#define MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN  0x4000
> >
> >  #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC                      0x07
> >  #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN 0x0010
> >
>

Regards,
-Vladimir
