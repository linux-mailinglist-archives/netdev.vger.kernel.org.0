Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E038C35AB14
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 07:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhDJFZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 01:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhDJFZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 01:25:57 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CB6C061762
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 22:25:42 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id o16so8886573ljp.3
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 22:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rN8uPmHgYp+HYktaVED9qkx5irVyPn+XQ+GV3auP+g0=;
        b=Q7A+mvW5T7Io1MJ0BNeghz8UFKw+G2eDgEO0DQhPkizFVHaXWm68NB+sOLkZdA1NsP
         7L0XF9gJADvwK3xMf5I+VSfA15B3kVTHejwHyvDGl2KQZolff7le3Pn6JFCXXQsP4Tmb
         XM9cxzqhSihbNOa9zyQpLNGEgsTykAVkWzpeFaweN1zmvKSfHBs2rNWesOOqwdvxP5me
         IlzNOAJVI+GWA4z4wVkZr4TxGBIUcIhbcGLgI7N+nqCHo81OUoenBXtNnYbnfc/lfpMf
         vywRyAijQrBN3JjGrcCoN7A1QjlsrbLtyrHdufaCeEbMdqGDVejBnUcbx/wBom6QKPqH
         hKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rN8uPmHgYp+HYktaVED9qkx5irVyPn+XQ+GV3auP+g0=;
        b=XOeNVPmWMLftbYrBewlN/PcuFrCZEWzvETCD9xsWAiBjazvU8+DBBsPJvTA4Cw2BJP
         Uw7dXuu0GmcTrZdzbF8efK3H/SXVZnNyC+SgOCh2rZV0bXg8sQD5pH/Rb/pj/FghIGnH
         aYkcqMGYd+dlS4yxk7HZbIcW/7sppC1KlN3KRNSFxuOuNTprxlE83faIMEwQ6icgz5+w
         EZdAxZeY2HuulsZ4gbtM00RCcuHhUpvWR/zvAptmvXphYbRIoytT3cUwdUQbgvmTTKD2
         YVqLm/cZ7uF7XcSmIpWnhpir4eBP4z5maWA5HQWlBYf7Tl9WKfUcs75H4m8IgFPBjyqK
         ZYyg==
X-Gm-Message-State: AOAM530S3VCeM/eCb9WChi7TaGbeffMy8e83/b8tOw/MkuWp6HdHDFHy
        h07IY2RXWcwdVTfqoBTQPJH0aQZAux2P99HGlSI=
X-Google-Smtp-Source: ABdhPJyo+Hn11Im3Z2Ay5kJFufoe86GK/lQJ5Sg7VNdeD8K27/RKfqnL99XhKbdssnvHeaERQBUBG5gRDeMgBc/nPyw=
X-Received: by 2002:a2e:8eda:: with SMTP id e26mr10833172ljl.457.1618032341292;
 Fri, 09 Apr 2021 22:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210409225346.432312-1-opensource@vdorst.com>
In-Reply-To: <20210409225346.432312-1-opensource@vdorst.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Sat, 10 Apr 2021 13:25:31 +0800
Message-ID: <CALW65jZRs4DBOpWiY+CxWZmX9wXhSP1cM-qeftC=xY2=Tr+HoA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: Add support for EEE features
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ren=C3=A9,

On Sat, Apr 10, 2021 at 6:54 AM Ren=C3=A9 van Dorst <opensource@vdorst.com>=
 wrote:
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2568,6 +2568,11 @@ static void mt753x_phylink_mac_link_up(struct dsa_=
switch *ds, int port,
>                         mcr |=3D PMCR_TX_FC_EN;
>                 if (rx_pause)
>                         mcr |=3D PMCR_RX_FC_EN;
> +
> +               if (mode =3D=3D MLO_AN_PHY && phydev &&
> +                   !(priv->eee_disabled & BIT(port)) &&
> +                   phy_init_eee(phydev, 0) >=3D 0)
> +                       mcr |=3D PMCR_FORCE_EEE1G | PMCR_FORCE_EEE100;

You should adjust this according to e->advertised.

>         }
>
>         mt7530_set(priv, MT7530_PMCR_P(port), mcr);
> @@ -2800,6 +2805,49 @@ mt753x_phy_write(struct dsa_switch *ds, int port, =
int regnum, u16 val)
>         return priv->info->phy_write(ds, port, regnum, val);
>  }
>
> +static int mt753x_get_mac_eee(struct dsa_switch *ds, int port,
> +                             struct ethtool_eee *e)
> +{
> +       struct mt7530_priv *priv =3D ds->priv;
> +       u32 eeecr, pmsr;
> +
> +       e->eee_enabled =3D !(priv->eee_disabled & BIT(port));
> +
> +       if (e->eee_enabled) {
> +               eeecr =3D mt7530_read(priv, MT7530_PMEEECR_P(port));
> +               e->tx_lpi_enabled =3D !(eeecr & LPI_MODE_EN);
> +               e->tx_lpi_timer =3D GET_LPI_THRESH(eeecr);
> +               pmsr =3D mt7530_read(priv, MT7530_PMSR_P(port));
> +               e->eee_active =3D e->eee_enabled && !!(pmsr & PMSR_EEE1G)=
;

eee_enabled and eee_active will be set in phy_ethtool_get_eee, no need
to set them here.

> +       }
> +
> +       return 0;
> +}
> +
> +static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
> +                             struct ethtool_eee *e)
> +{
> +       struct mt7530_priv *priv =3D ds->priv;
> +       u32 eeecr;
> +
> +       if (e->eee_enabled) {
> +               if (e->tx_lpi_timer > 0xFFF)
> +                       return -EINVAL;
> +               priv->eee_disabled &=3D ~BIT(port);
> +               eeecr =3D mt7530_read(priv, MT7530_PMEEECR_P(port));
> +               eeecr &=3D ~(LPI_THRESH_MASK | LPI_MODE_EN);
> +               if (!e->tx_lpi_enabled)
> +                       /* Force LPI Mode without a delay */
> +                       eeecr |=3D LPI_MODE_EN;
> +               eeecr |=3D SET_LPI_THRESH(e->tx_lpi_timer);
> +               mt7530_write(priv, MT7530_PMEEECR_P(port), eeecr);
> +       } else {
> +               priv->eee_disabled |=3D BIT(port);
> +       }
> +
> +       return 0;
> +}
