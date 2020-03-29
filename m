Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBF7196CDD
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgC2LKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:10:51 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38109 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727875AbgC2LKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:10:50 -0400
Received: by mail-ed1-f65.google.com with SMTP id e5so17343091edq.5;
        Sun, 29 Mar 2020 04:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q/yD6c2PKgnHnFk14kJeOz5sQTjlHMyFhj12xzI5L0o=;
        b=nCv/zjYj0AUp65ssXNemevbr+jeDmSSwzv4oAtnNOcoHqkNMcQzwvIuXHE6fYpivQb
         GSrWblRItvs7fcqn4bukBOyHksiwt9kRibYK263UxHKRrX6TTCpeF6UC6jFnrqEjmW33
         Sw+YFWhYjz6I2Rpi2HOjejms1jXVnCyLWHZalL31bvPmH94hQBVkbKfZFdyH6/sK21Wh
         swl0rYIuWAnvQJ8/+Gfmo77cnhZqDKGYDR6HBL4J0+tm0P0xORA91IwDrPfifNar55HZ
         yXFUoCXxglhXpVmbhccVFJ6QJKrWdBsVzRvYMyeBw/QD2Gt1NCttjnzBJDlDF7ZKsq8f
         YVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q/yD6c2PKgnHnFk14kJeOz5sQTjlHMyFhj12xzI5L0o=;
        b=LOn3I3r5IH99U1ilmptpbHybRNHOrcSWSJE+1Hbn3VtEZ23qoLG3omznw95lMhQY1I
         7hyQZ3754OhYC14HaTN16FXp8wwe8ztjT/Dqeny6GG3KfWBzYTjF/1k5PAv5DFCgU1iN
         0re68VkB+uO0X/eFp3f5ve2zhP6VpTUaXfG1XODxA5DPpaBzBNbU6XbMf9i6x7iYdhJY
         Nrt8sIHAyKhHNFbeEWMPAx2Lhr9uq9HURQOa+fVYLymSvw+c6I/sLF1pfWYNDjEsPF7b
         XViEPw+fzsEVQ8TxiROYeZGp5YR7rwHQZqVSkBojt9YJxodNekNBoFBJvjIne4SX5tsa
         VMng==
X-Gm-Message-State: ANhLgQ07hjKO3rut040H/rxZsGz7jgTRDPYJg20GixAAK9g+DgKceGVe
        Un+iO+VqL2jpcFkMLgiaUg5ShI+JpQUhwH8v03s=
X-Google-Smtp-Source: ADFU+vsDm9GauYwVXKaXdiyRF3Jkg1Et1z1n1m9pmfXiLZIsRJTvcvT5vO2BBXUETEC4Y9NJbEsQCvdM+qBdJT7ljro=
X-Received: by 2002:a17:906:449:: with SMTP id e9mr6493292eja.239.1585480248014;
 Sun, 29 Mar 2020 04:10:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200329005202.17926-1-olteanv@gmail.com> <20200329005202.17926-5-olteanv@gmail.com>
In-Reply-To: <20200329005202.17926-5-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 29 Mar 2020 14:10:36 +0300
Message-ID: <CA+h21hrBnn5t9ckiyPxeVbkhypCPX4d-pqRm6Gk=1sTm-NdORQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] net: dsa: felix: add port policers
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Mar 2020 at 02:53, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This patch is a trivial passthrough towards the ocelot library, which
> support port policers since commit 2c1d029a017f ("net: mscc: ocelot:
> Implement port policers via tc command").
>
> Some data structure conversion between the DSA core and the Ocelot
> library is necessary, for policer parameters.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix.c            | 24 +++++++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_police.c |  3 +++
>  drivers/net/ethernet/mscc/ocelot_police.h | 10 ----------
>  drivers/net/ethernet/mscc/ocelot_tc.c     |  2 +-
>  include/soc/mscc/ocelot.h                 |  8 ++++++++
>  5 files changed, 36 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index eef9fa812a3c..7f7dd6736051 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -14,6 +14,7 @@
>  #include <linux/of_net.h>
>  #include <linux/pci.h>
>  #include <linux/of.h>
> +#include <net/pkt_sched.h>
>  #include <net/dsa.h>
>  #include "felix.h"
>
> @@ -651,6 +652,27 @@ static int felix_cls_flower_stats(struct dsa_switch *ds, int port,
>         return ocelot_cls_flower_stats(ocelot, port, cls, ingress);
>  }
>
> +static int felix_port_policer_add(struct dsa_switch *ds, int port,
> +                                 struct dsa_mall_policer_tc_entry *policer)
> +{
> +       struct ocelot *ocelot = ds->priv;
> +       struct ocelot_policer pol = {
> +               .rate = div_u64(policer->rate_bytes_per_sec, 1000) * 8,
> +               .burst = div_u64(policer->rate_bytes_per_sec *
> +                                PSCHED_NS2TICKS(policer->burst),
> +                                PSCHED_TICKS_PER_SEC),
> +       };
> +
> +       return ocelot_port_policer_add(ocelot, port, &pol);
> +}
> +
> +static void felix_port_policer_del(struct dsa_switch *ds, int port)
> +{
> +       struct ocelot *ocelot = ds->priv;
> +
> +       ocelot_port_policer_del(ocelot, port);
> +}
> +
>  static const struct dsa_switch_ops felix_switch_ops = {
>         .get_tag_protocol       = felix_get_tag_protocol,
>         .setup                  = felix_setup,
> @@ -684,6 +706,8 @@ static const struct dsa_switch_ops felix_switch_ops = {
>         .port_txtstamp          = felix_txtstamp,
>         .port_change_mtu        = felix_change_mtu,
>         .port_max_mtu           = felix_get_max_mtu,
> +       .port_policer_add       = felix_port_policer_add,
> +       .port_policer_del       = felix_port_policer_del,
>         .cls_flower_add         = felix_cls_flower_add,
>         .cls_flower_del         = felix_cls_flower_del,
>         .cls_flower_stats       = felix_cls_flower_stats,
> diff --git a/drivers/net/ethernet/mscc/ocelot_police.c b/drivers/net/ethernet/mscc/ocelot_police.c
> index 8d25b2706ff0..2e1d8e187332 100644
> --- a/drivers/net/ethernet/mscc/ocelot_police.c
> +++ b/drivers/net/ethernet/mscc/ocelot_police.c
> @@ -4,6 +4,7 @@
>   * Copyright (c) 2019 Microsemi Corporation
>   */
>
> +#include <soc/mscc/ocelot.h>
>  #include "ocelot_police.h"
>
>  enum mscc_qos_rate_mode {
> @@ -203,6 +204,7 @@ int ocelot_port_policer_add(struct ocelot *ocelot, int port,
>
>         return 0;
>  }
> +EXPORT_SYMBOL(ocelot_port_policer_add);
>
>  int ocelot_port_policer_del(struct ocelot *ocelot, int port)
>  {
> @@ -225,6 +227,7 @@ int ocelot_port_policer_del(struct ocelot *ocelot, int port)
>
>         return 0;
>  }
> +EXPORT_SYMBOL(ocelot_port_policer_del);
>
>  int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
>                            struct ocelot_policer *pol)
> diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
> index 22025cce0a6a..792abd28010a 100644
> --- a/drivers/net/ethernet/mscc/ocelot_police.h
> +++ b/drivers/net/ethernet/mscc/ocelot_police.h
> @@ -9,16 +9,6 @@
>
>  #include "ocelot.h"
>
> -struct ocelot_policer {
> -       u32 rate; /* kilobit per second */
> -       u32 burst; /* bytes */
> -};
> -
> -int ocelot_port_policer_add(struct ocelot *ocelot, int port,
> -                           struct ocelot_policer *pol);
> -
> -int ocelot_port_policer_del(struct ocelot *ocelot, int port);
> -
>  int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
>                            struct ocelot_policer *pol);
>
> diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
> index 3ff5ef41eccf..d326e231f0ad 100644
> --- a/drivers/net/ethernet/mscc/ocelot_tc.c
> +++ b/drivers/net/ethernet/mscc/ocelot_tc.c
> @@ -4,8 +4,8 @@
>   * Copyright (c) 2019 Microsemi Corporation
>   */
>
> +#include <soc/mscc/ocelot.h>
>  #include "ocelot_tc.h"
> -#include "ocelot_police.h"
>  #include "ocelot_ace.h"
>  #include <net/pkt_cls.h>
>
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 3db66638a3b2..ca49f7a114de 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -555,6 +555,11 @@ struct ocelot {
>         struct ptp_pin_desc             ptp_pins[OCELOT_PTP_PINS_NUM];
>  };
>

Oops, it looks like I had Yangbo's patch in my tree, and the ptp_pins
are messing with this patch's context, causing it to fail to apply
cleanly:
https://patchwork.ozlabs.org/patch/1258827/
I think I need to send a v2 for this. Sorry.

> +struct ocelot_policer {
> +       u32 rate; /* kilobit per second */
> +       u32 burst; /* bytes */
> +};
> +
>  #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
>  #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
>  #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
> @@ -624,6 +629,9 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
>  void ocelot_get_txtstamp(struct ocelot *ocelot);
>  void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu);
>  int ocelot_get_max_mtu(struct ocelot *ocelot, int port);
> +int ocelot_port_policer_add(struct ocelot *ocelot, int port,
> +                           struct ocelot_policer *pol);
> +int ocelot_port_policer_del(struct ocelot *ocelot, int port);
>  int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
>                               struct flow_cls_offload *f, bool ingress);
>  int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
> --
> 2.17.1
>

Thanks,
-Vladimir
