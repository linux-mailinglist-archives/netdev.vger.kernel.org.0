Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73877209C73
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 12:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403840AbgFYKFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 06:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390531AbgFYKFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 06:05:13 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C13C061573
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 03:05:13 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id z17so3724130edr.9
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 03:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCphmsOq1AQyq21gdLQPuoUmwnF56gbi9ywIWcmIqMg=;
        b=HiKZqXLoBFKlaKqAzczw9pV77lg/G1Pt/+c+6bKbiTSeNA6fLDiNjLsk/eiuFvU1cQ
         G5E5ZWMdsPOulrnwpgdDfzyDByEi8cWXjSanmHmj5tnRvWlxJ88/CEWIoaXSZ6ZqKy4J
         UTV37vgYVt1rcW4oNp9koGa7ymRPhRkPdhzo0iQmL0qD/ovJiPOtrmilhIEnqdwERqZW
         hipkrx9urUGNHTZglBpqe+Eyk3bDycxaK23GHoa/9RQuesyZO+jLEpEaIzOjDZ4NYGwl
         WsjzwbNLoV7y8iIz9MPBrbg7ASkuFP0xbi77UDqfeCHyTXxGbqvigVIkUz+OT5UQ5Ce0
         +9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCphmsOq1AQyq21gdLQPuoUmwnF56gbi9ywIWcmIqMg=;
        b=X05rxQlmnSWAW3FSl5+scOfQO43hNMaR8CUB8nM2YLR3d9w+gpWQJ2Pevj/tOkmZ7B
         n2OUfCHbNZDLrA/+P3wScK16gVvuaq8rI726mqBgb9+KR6r1F6ptitLIDTDR+L9fkD3Y
         QATylbKHCsdA9w5OCbJ2+zAVyZowbCcwEyX2McfKIGLQpX8ZpH+E6rLmeAqSNtptThV+
         IQI1cvuPNuMkTiBFuBm/6xp5dJ7iSEjGoqGVNA8B//lF5rrLBanLYNe/hEfgOoNCvDW2
         eTB0eNYS6uVZMe2nGdGyAxLNgC5Z82J9tRkR7b7NGRUC7ntjFkoso9XpPE9hprzpldXu
         f1OQ==
X-Gm-Message-State: AOAM533cmBolrlTKDwwTQcbQmNQ/atcaOkMoWF+19M/6AXw86CNVGCtp
        cCGcXqxXFyga41u/BIg6MV+xlVILacT2Clz66Y5/LA==
X-Google-Smtp-Source: ABdhPJw+3uusMTxY6V/9dFP4GNXQV4OJZUmzhdffi45hnblqUzV/wKDekk0MCDQoMsKLnF0NJMRhY5q0NMt4jFfTu6A=
X-Received: by 2002:a50:ab53:: with SMTP id t19mr17335925edc.179.1593079512081;
 Thu, 25 Jun 2020 03:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200624155926.3379373-1-olteanv@gmail.com>
In-Reply-To: <20200624155926.3379373-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 25 Jun 2020 13:05:00 +0300
Message-ID: <CA+h21hrY8AP6XShm9m+N88qGKe2N53r_RxokG37CJpkoc5-42Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: felix: support half-duplex link modes
To:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 at 18:59, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Ping tested:
>
>   [   11.808455] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow control rx/tx
>   [   11.816497] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready
>
>   [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x4
>   [   18.844591] mscc_felix 0000:00:00.5 swp0: Link is Down
>   [   22.048337] mscc_felix 0000:00:00.5 swp0: Link is Up - 100Mbps/Half - flow control off
>
>   [root@LS1028ARDB ~] # ip addr add 192.168.1.1/24 dev swp0
>
>   [root@LS1028ARDB ~] # ping 192.168.1.2
>   PING 192.168.1.2 (192.168.1.2): 56 data bytes
>   (...)
>   ^C--- 192.168.1.2 ping statistics ---
>   3 packets transmitted, 3 packets received, 0% packet loss
>   round-trip min/avg/max = 0.383/0.611/1.051 ms
>
>   [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x10
>   [  355.637747] mscc_felix 0000:00:00.5 swp0: Link is Down
>   [  358.788034] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Half - flow control off
>
>   [root@LS1028ARDB ~] # ping 192.168.1.2
>   PING 192.168.1.2 (192.168.1.2): 56 data bytes
>   (...)
>   ^C
>   --- 192.168.1.2 ping statistics ---
>   16 packets transmitted, 16 packets received, 0% packet loss
>   round-trip min/avg/max = 0.301/0.384/1.138 ms
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> This is a resend (no changes) of:
> https://patchwork.ozlabs.org/project/netdev/patch/20200531122640.1375715-12-olteanv@gmail.com/
> (which in itself was a resend, link to original in that link)
>
> It was extracted out of that series since that's now entangled with
> other development, but this could be applied separately.
>
>  drivers/net/dsa/ocelot/felix.c         |  4 +++-
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 13 ++++++++-----
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 25046777c993..55b4129a1f9d 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -194,14 +194,16 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
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
> index 2067776773f7..f5e8df584073 100644
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

Please don't merge this patch. I need to make some changes to it.

Thanks,
-Vladimir
