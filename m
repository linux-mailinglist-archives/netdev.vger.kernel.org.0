Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69D91E8C34
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgE2Xku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbgE2Xkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:40:46 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C694C08C5C9
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:40:46 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id mb16so3712557ejb.4
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+aWXRGYQpDOJ3W4NcIIodVGJ+TjF06M7cO+AZG7kS9g=;
        b=cRs2RQ7TrRocV6NsORLNYPMqV+v9cT1XYsAh5SBgqJuJjZWlsQBkv3cXpHnW+c16cm
         O28UK+PsXdUMrUQ5E/5G6R1/yeBcHrj9FtrJwQPp1Krj+/DOJ6QQWpKXYAf3arCqshEq
         MLpd31FZvEIAp7sC6p16rCIIeVIyDY8qNpudYUeAlbPtF8Il4wCtFetyioO4HVnoMxkV
         mL488a9PC7pr2YX1x3VnziOAw8DbVm6r+Z2lyw0tNSNSzkqdeJ5nx43mkHGijdnYsSc+
         X7ukWtALWIto8ZUGkxK6DrrMTTzyi+qwhq+UteCTzXkF748htNt7I0iwayP8O0SNEGUI
         hhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+aWXRGYQpDOJ3W4NcIIodVGJ+TjF06M7cO+AZG7kS9g=;
        b=lQLyN5PWT01UZCH2O1DjLmLGz1SGHveEclcq3DtipDoyB/CYcDSh6IA8NSfqhgBScM
         5m4SNotxMTxS6n5+ggcPkRg8Scn0eETS+8gXpGayPvB0bDKYMy4ohFi3wIBdPsF/NMTQ
         ePOV6fzeAcsyVMPZz/aIkRJNKgwN0LzsYIMdKgOKtbjhA8H/DEbZYme7pgJFinO30T1q
         HfXtqmWC9XriAvpSOIt/LturWGl/jDuC+/L2azFIDlLU7zaWoaHu/Q5R8K3/Hksgv5hN
         pv/2oSaB0RbHRrVda/fXG68VGqw0UUvU+tGrmQ7DscToNfb2Z7qzUo0X3+6sUF/NNTJT
         sZdQ==
X-Gm-Message-State: AOAM530E4MZcSuGAozUQQwskw/cghxbk/UZq/plI8jPIN/BQNlL3mt/H
        LPyLGPtWqxXS6FMWn0tNO6Urhfv0R1dCj99yET4=
X-Google-Smtp-Source: ABdhPJxxcP0MyILNcgYd/m1t1x8Q+Ul+zCbwypM5vhlrmcYuLbn+67OM+vx64RiCNbih/pz+BSnd0EM8AEUtBcF9BJA=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr9640502eji.305.1590795644882;
 Fri, 29 May 2020 16:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200528094410.2658306-1-olteanv@gmail.com>
In-Reply-To: <20200528094410.2658306-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 30 May 2020 02:40:33 +0300
Message-ID: <CA+h21hoKX7pTEWML+dXTtdkwue=XiqCZ_On8U=o1g7NO2Oebmg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: felix: support half-duplex link modes
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 at 12:44, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Ping tested:
>
> [   11.808455] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow control rx/tx
> [   11.816497] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready
>
> [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x4
> [   18.844591] mscc_felix 0000:00:00.5 swp0: Link is Down
> [   22.048337] mscc_felix 0000:00:00.5 swp0: Link is Up - 100Mbps/Half - flow control off
>
> [root@LS1028ARDB ~] # ip addr add 192.168.1.1/24 dev swp0
>
> [root@LS1028ARDB ~] # ping 192.168.1.2
> PING 192.168.1.2 (192.168.1.2): 56 data bytes
> (...)
> ^C--- 192.168.1.2 ping statistics ---
> 3 packets transmitted, 3 packets received, 0% packet loss
> round-trip min/avg/max = 0.383/0.611/1.051 ms
>
> [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x10
> [  355.637747] mscc_felix 0000:00:00.5 swp0: Link is Down
> [  358.788034] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Half - flow control off
>
> [root@LS1028ARDB ~] # ping 192.168.1.2
> PING 192.168.1.2 (192.168.1.2): 56 data bytes
> (...)
> ^C
> --- 192.168.1.2 ping statistics ---
> 16 packets transmitted, 16 packets received, 0% packet loss
> round-trip min/avg/max = 0.301/0.384/1.138 ms
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

The commit message of this patch is trimmed when downloading from
patchwork due to the "---" output from ping. I'll resend.

>  drivers/net/dsa/ocelot/felix.c         |  4 +++-
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 13 ++++++++-----
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 66648986e6e3..e5ec1bf90eb0 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -171,14 +171,16 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
>                 return;
>         }
>
> -       /* No half-duplex. */
>         phylink_set_port_modes(mask);
>         phylink_set(mask, Autoneg);
>         phylink_set(mask, Pause);
>         phylink_set(mask, Asym_Pause);
>         phylink_set(mask, 10baseT_Full);
> +       phylink_set(mask, 10baseT_Half);
>         phylink_set(mask, 100baseT_Full);
> +       phylink_set(mask, 100baseT_Half);
>         phylink_set(mask, 1000baseT_Full);
> +       phylink_set(mask, 1000baseT_Half);
>
>         if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
>             state->interface == PHY_INTERFACE_MODE_2500BASEX ||
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 1dd9e348152d..e706677bcb01 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -817,12 +817,12 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
>
>                 phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
>         } else {
> +               u16 duplex = 0;
>                 int speed;
>
> -               if (state->duplex == DUPLEX_HALF) {
> -                       phydev_err(pcs, "Half duplex not supported\n");
> -                       return;
> -               }
> +               if (state->duplex == DUPLEX_FULL)
> +                       duplex = BMCR_FULLDPLX;
> +
>                 switch (state->speed) {
>                 case SPEED_1000:
>                         speed = ENETC_PCS_SPEED_1000;
> @@ -848,7 +848,7 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
>                 /* Yes, not a mistake: speed is given by IF_MODE. */
>                 phy_write(pcs, MII_BMCR, BMCR_RESET |
>                                          BMCR_SPEED1000 |
> -                                        BMCR_FULLDPLX);
> +                                        duplex);
>         }
>  }
>
> @@ -925,8 +925,11 @@ static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
>                                ARRAY_SIZE(phy_basic_ports_array),
>                                pcs->supported);
>         linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, pcs->supported);
> +       linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, pcs->supported);
>         linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, pcs->supported);
> +       linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, pcs->supported);
>         linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, pcs->supported);
> +       linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, pcs->supported);
>         if (pcs->interface == PHY_INTERFACE_MODE_2500BASEX ||
>             pcs->interface == PHY_INTERFACE_MODE_USXGMII)
>                 linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
> --
> 2.25.1
>
