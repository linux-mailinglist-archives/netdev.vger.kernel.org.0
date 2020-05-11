Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCCA1CD3A7
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 10:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgEKITl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 04:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgEKITl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 04:19:41 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF221C061A0C;
        Mon, 11 May 2020 01:19:40 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l3so7158430edq.13;
        Mon, 11 May 2020 01:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=od2u5BNJcS+h2O2BE/eOiO0deB7ahR5tMprD43wG3iw=;
        b=rAWgP9fiDAv2HMbHqP9KKB6AN0eQpPm1jsQLEMPi5zhONstNR0G6qm0JfciHgRIV3S
         6dtahAJ0m0GVKFYGSRAUmIVvhcBZEf9fM3DU5v+TIUNW+cVpSxP+KZdE9c5phAP0hGyt
         fxvuqJHy5CHwQDUIniWMq/uwlaXtq08+TTaX5e3miciprbsAEQgLfJgM6wMdXq0dP4eT
         XtWBgYS+jaOniJ6ph1tmZkfliiH30+z4egJd1exykbo6/40GaGFLUjFh6+4jneubt/Ag
         EQuNdhcmBIZir4QjanLkCIOh/HkU2vxKFPP3zeURUfu11eUcWzYYbE+rfEG+bgAQxJ3P
         c02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=od2u5BNJcS+h2O2BE/eOiO0deB7ahR5tMprD43wG3iw=;
        b=Dffmu/OxjZ8pvKd7HwqH/y7f3gUltKANf+dee5GKitrDbx1ddMmdrYSevJmHbvuKGw
         xoZtadb0hJVacILfjsr1b3OuqpvoWEwi5qrrrn+EOmUX7G2tY5Bz5GxU5E/bX1BNUYHl
         baC9a7FzDPNVEcxDqMHpNDnajTbuBUxeBg+6GeUkjy6+Q8jDSmXZ+tXCM5Oc5+Sl/TMM
         ky4T9gpchyZBtapaqWnMLujEOob+WY7TKFlu/SjhY/dm+Ka5MlTUd7j9+txX1ctjFDF5
         QwpRcUUOc61HLZdu+Dw3PO/fLj7aUMEChC8sxMN1ed51Ogd0koMGf+kEAvxpx9fds1eM
         it5A==
X-Gm-Message-State: AGi0PubxMNi0HRB+M7io2b2zUKyXoY0vPIuSreAD5X0IVhcHhhCQcYWK
        M8ES6sCvEWHnoFDjcyBV0WTF6KPs8u6sEEtByHG6uW/B
X-Google-Smtp-Source: APiQypL6nTm4xu55/xj1Oegx1QDa5qVdF3vvoTastnXroj6tnYbI6V7vkg44BKu/NvpAdoSKyGZQ8uwLEvk6+D1WGOo=
X-Received: by 2002:a50:8dc2:: with SMTP id s2mr12853223edh.318.1589185179228;
 Mon, 11 May 2020 01:19:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com> <20200511054332.37690-2-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20200511054332.37690-2-xiaoliang.yang_1@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 11 May 2020 11:19:28 +0300
Message-ID: <CA+h21hpennftjgTr_CK85drFUErQUqZkcFA+zPe0L25VAbe=FA@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 1/3] net: dsa: felix: qos classified based on pcp
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Po Liu <po.liu@nxp.com>, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        linux-devel@linux.nxdi.nxp.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri, Jakub, Ido,

On Mon, 11 May 2020 at 08:50, Xiaoliang Yang <xiaoliang.yang_1@nxp.com> wrote:
>
> Set the default QoS Classification based on PCP and DEI of vlan tag,
> after that, frames can be Classified to different Qos based on PCP tag.
> If there is no vlan tag or vlan ignored, use port default Qos.
>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---

The new skbedit priority offload action looks interesting to me.
But it also raises the question of what to do in the default case
where such rules are not installed. I think it is ok to support a
1-to-1 VLAN PCP to TC mapping by default? This should also be needed
for features such as Priority Flow Control.

>  drivers/net/dsa/ocelot/felix.c         |  6 ++++++
>  drivers/net/dsa/ocelot/felix.h         |  1 +
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 23 +++++++++++++++++++++++
>  3 files changed, 30 insertions(+)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index a2dfd73f8a1a..0afdc6fc3f57 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -547,6 +547,12 @@ static int felix_setup(struct dsa_switch *ds)
>                         ocelot_configure_cpu(ocelot, port,
>                                              OCELOT_TAG_PREFIX_NONE,
>                                              OCELOT_TAG_PREFIX_LONG);
> +
> +               /* Set the default QoS Classification based on PCP and DEI
> +                * bits of vlan tag.
> +                */
> +               if (felix->info->port_qos_map_init)
> +                       felix->info->port_qos_map_init(ocelot, port);

Xiaoliang, just a small comment in case you need to resend.
The felix->info structure is intended to hold SoC-specific data that
is likely to differ between chips (like for example if vsc7511 support
ever appears in felix). But I see ANA:PORT:QOS_CFG and
ANA:PORT:QOS_PCP_DEI_MAP_CFG are common registers, so are there any
specific reasons why you put this in felix_vsc9959 and not in the
common ocelot code?

>         }
>
>         /* Include the CPU port module in the forwarding mask for unknown
> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
> index b94386fa8d63..0d4ec34309c7 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -35,6 +35,7 @@ struct felix_info {
>                                   struct phylink_link_state *state);
>         int     (*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
>                                         phy_interface_t phy_mode);
> +       void    (*port_qos_map_init)(struct ocelot *ocelot, int port);
>  };
>
>  extern struct felix_info               felix_info_vsc9959;
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 1c56568d5aca..5c931fb3e4cd 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -4,6 +4,7 @@
>   */
>  #include <linux/fsl/enetc_mdio.h>
>  #include <soc/mscc/ocelot_vcap.h>
> +#include <soc/mscc/ocelot_ana.h>
>  #include <soc/mscc/ocelot_sys.h>
>  #include <soc/mscc/ocelot.h>
>  #include <linux/iopoll.h>
> @@ -1209,6 +1210,27 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
>         mdiobus_unregister(felix->imdio);
>  }
>
> +static void vsc9959_port_qos_map_init(struct ocelot *ocelot, int port)
> +{
> +       int i;
> +
> +       ocelot_rmw_gix(ocelot,
> +                      ANA_PORT_QOS_CFG_QOS_PCP_ENA,
> +                      ANA_PORT_QOS_CFG_QOS_PCP_ENA,
> +                      ANA_PORT_QOS_CFG,
> +                      port);
> +
> +       for (i = 0; i < FELIX_NUM_TC * 2; i++) {
> +               ocelot_rmw_ix(ocelot,
> +                             (ANA_PORT_PCP_DEI_MAP_DP_PCP_DEI_VAL & i) |

ANA_PORT_PCP_DEI_MAP_DP_PCP_DEI_VAL is 1 bit. Are you sure this should
be % i and not % 2?

> +                             ANA_PORT_PCP_DEI_MAP_QOS_PCP_DEI_VAL(i),
> +                             ANA_PORT_PCP_DEI_MAP_DP_PCP_DEI_VAL |
> +                             ANA_PORT_PCP_DEI_MAP_QOS_PCP_DEI_VAL_M,
> +                             ANA_PORT_PCP_DEI_MAP,
> +                             port, i);
> +       }
> +}
> +
>  struct felix_info felix_info_vsc9959 = {
>         .target_io_res          = vsc9959_target_io_res,
>         .port_io_res            = vsc9959_port_io_res,
> @@ -1232,4 +1254,5 @@ struct felix_info felix_info_vsc9959 = {
>         .pcs_an_restart         = vsc9959_pcs_an_restart,
>         .pcs_link_state         = vsc9959_pcs_link_state,
>         .prevalidate_phy_mode   = vsc9959_prevalidate_phy_mode,
> +       .port_qos_map_init      = vsc9959_port_qos_map_init,
>  };
> --
> 2.17.1
>

Thanks,
-Vladimir
