Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7253D5ABE
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhGZNLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhGZNLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:11:05 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E371AC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 06:51:33 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id o5so16620914ejy.2
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 06:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mvCky3e8NHpgTWMjzM+jK7UgaTya/gALJMwqfDD9NbY=;
        b=DpODU9GHzXzxV0G0vEz/5t2nBNd+l1DoR0ZWDBEN6Q9M7rzYG2rWTnyUT1Nlb4mb3x
         9Y63t54YbnTOHukJlET9JNnr7VMlB/ATPl9Fhw61oz/tVA3DpcBiHiCGOOf05phIAi8r
         KrrUpj6a869BJz9ysWkGK0Y7xaka28pnomZYF1gWnx+y+4huVuDlsZI1Cn+6zZy3OHFS
         Ba8/mwClvvhP8St6R9bNYdSYe+chNavv/Fiwvb/xXwxLmpFXh/ty3rVs+YCUt3oOGFuf
         3la+ZtARhH44fNqcfVdfWlcsXSszwW4Cf+MFm21W5qJQsGuZnhCfykVKxoA6YJgkELea
         cBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvCky3e8NHpgTWMjzM+jK7UgaTya/gALJMwqfDD9NbY=;
        b=nlu05IXGORjuIHKoIjA2tRy4zipadBeUltiQZ9plxzQrpFrZ+AdBHuFAXMyyV12nj5
         X9nes7fUyjAgS4T0q4Xf2HEgReaGRyavBDfMiLT1VpnIco0G2ae3XBW5v9YxzFT4H5UD
         aGxwHu7W89VR86B4yGXSGxwVisqjDV9wS9ZMPNXQ5yN4ZZmHrhBoXWds8O7Asn4tT78V
         jG95GVJcx8VqX+Cqu6qU6Oai7Ti3MWr9T/1TWMZoFybmdO1h5EB6lpmCbujrZDsAazrZ
         qUofsxYJHzsqE7g2FJtNdJ7qc77icr9zXvoeeWmnfoOTB6Mgx7iQ+y/Rz6hRq1brgrSn
         A4aQ==
X-Gm-Message-State: AOAM532bu+cbbVXtckSJwrridoswCAL7CVb3bQdWubP1pilnEhp8fC5j
        363omdCFZ6gj4Mcgx5Ik2O2fl4STaucz+GoPfTu5Ww==
X-Google-Smtp-Source: ABdhPJzIvWE8f5rgIyDka0L2O8GQ2bxYmaKqiSsU8d9banea79Muv6fpwhaOc1/Q/UCmasyxNSwVckTfccilUJ3fSfw=
X-Received: by 2002:a17:907:94c6:: with SMTP id dn6mr6398817ejc.287.1627307492258;
 Mon, 26 Jul 2021 06:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com> <20210721162403.1988814-6-vladimir.oltean@nxp.com>
In-Reply-To: <20210721162403.1988814-6-vladimir.oltean@nxp.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 26 Jul 2021 19:21:20 +0530
Message-ID: <CA+G9fYtaM=hexrmMvDXzeHZKuLCp53kRYyyvbBXZzveQzgDSyA@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 5/7] net: bridge: switchdev: let drivers
 inform which bridge ports are offloaded
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 at 21:56, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On reception of an skb, the bridge checks if it was marked as 'already
> forwarded in hardware' (checks if skb->offload_fwd_mark == 1), and if it
> is, it assigns the source hardware domain of that skb based on the
> hardware domain of the ingress port. Then during forwarding, it enforces
> that the egress port must have a different hardware domain than the
> ingress one (this is done in nbp_switchdev_allowed_egress).
>
> Non-switchdev drivers don't report any physical switch id (neither
> through devlink nor .ndo_get_port_parent_id), therefore the bridge
> assigns them a hardware domain of 0, and packets coming from them will
> always have skb->offload_fwd_mark = 0. So there aren't any restrictions.
>
> Problems appear due to the fact that DSA would like to perform software
> fallback for bonding and team interfaces that the physical switch cannot
> offload.
>
>        +-- br0 ---+
>       / /   |      \
>      / /    |       \
>     /  |    |      bond0
>    /   |    |     /    \
>  swp0 swp1 swp2 swp3 swp4
>
> There, it is desirable that the presence of swp3 and swp4 under a
> non-offloaded LAG does not preclude us from doing hardware bridging
> beteen swp0, swp1 and swp2. The bandwidth of the CPU is often times high
> enough that software bridging between {swp0,swp1,swp2} and bond0 is not
> impractical.
>
> But this creates an impossible paradox given the current way in which
> port hardware domains are assigned. When the driver receives a packet
> from swp0 (say, due to flooding), it must set skb->offload_fwd_mark to
> something.
>
> - If we set it to 0, then the bridge will forward it towards swp1, swp2
>   and bond0. But the switch has already forwarded it towards swp1 and
>   swp2 (not to bond0, remember, that isn't offloaded, so as far as the
>   switch is concerned, ports swp3 and swp4 are not looking up the FDB,
>   and the entire bond0 is a destination that is strictly behind the
>   CPU). But we don't want duplicated traffic towards swp1 and swp2, so
>   it's not ok to set skb->offload_fwd_mark = 0.
>
> - If we set it to 1, then the bridge will not forward the skb towards
>   the ports with the same switchdev mark, i.e. not to swp1, swp2 and
>   bond0. Towards swp1 and swp2 that's ok, but towards bond0? It should
>   have forwarded the skb there.
>
> So the real issue is that bond0 will be assigned the same hardware
> domain as {swp0,swp1,swp2}, because the function that assigns hardware
> domains to bridge ports, nbp_switchdev_add(), recurses through bond0's
> lower interfaces until it finds something that implements devlink (calls
> dev_get_port_parent_id with bool recurse = true). This is a problem
> because the fact that bond0 can be offloaded by swp3 and swp4 in our
> example is merely an assumption.
>
> A solution is to give the bridge explicit hints as to what hardware
> domain it should use for each port.
>
> Currently, the bridging offload is very 'silent': a driver registers a
> netdevice notifier, which is put on the netns's notifier chain, and
> which sniffs around for NETDEV_CHANGEUPPER events where the upper is a
> bridge, and the lower is an interface it knows about (one registered by
> this driver, normally). Then, from within that notifier, it does a bunch
> of stuff behind the bridge's back, without the bridge necessarily
> knowing that there's somebody offloading that port. It looks like this:
>
>      ip link set swp0 master br0
>                   |
>                   v
>  br_add_if() calls netdev_master_upper_dev_link()
>                   |
>                   v
>         call_netdevice_notifiers
>                   |
>                   v
>        dsa_slave_netdevice_event
>                   |
>                   v
>         oh, hey! it's for me!
>                   |
>                   v
>            .port_bridge_join
>
> What we do to solve the conundrum is to be less silent, and change the
> switchdev drivers to present themselves to the bridge. Something like this:
>
>      ip link set swp0 master br0
>                   |
>                   v
>  br_add_if() calls netdev_master_upper_dev_link()
>                   |
>                   v                    bridge: Aye! I'll use this
>         call_netdevice_notifiers           ^  ppid as the
>                   |                        |  hardware domain for
>                   v                        |  this port, and zero
>        dsa_slave_netdevice_event           |  if I got nothing.
>                   |                        |
>                   v                        |
>         oh, hey! it's for me!              |
>                   |                        |
>                   v                        |
>            .port_bridge_join               |
>                   |                        |
>                   +------------------------+
>              switchdev_bridge_port_offload(swp0, swp0)
>
> Then stacked interfaces (like bond0 on top of swp3/swp4) would be
> treated differently in DSA, depending on whether we can or cannot
> offload them.
>
> The offload case:
>
>     ip link set bond0 master br0
>                   |
>                   v
>  br_add_if() calls netdev_master_upper_dev_link()
>                   |
>                   v                    bridge: Aye! I'll use this
>         call_netdevice_notifiers           ^  ppid as the
>                   |                        |  switchdev mark for
>                   v                        |        bond0.
>        dsa_slave_netdevice_event           | Coincidentally (or not),
>                   |                        | bond0 and swp0, swp1, swp2
>                   v                        | all have the same switchdev
>         hmm, it's not quite for me,        | mark now, since the ASIC
>          but my driver has already         | is able to forward towards
>            called .port_lag_join           | all these ports in hw.
>           for it, because I have           |
>       a port with dp->lag_dev == bond0.    |
>                   |                        |
>                   v                        |
>            .port_bridge_join               |
>            for swp3 and swp4               |
>                   |                        |
>                   +------------------------+
>             switchdev_bridge_port_offload(bond0, swp3)
>             switchdev_bridge_port_offload(bond0, swp4)
>
> And the non-offload case:
>
>     ip link set bond0 master br0
>                   |
>                   v
>  br_add_if() calls netdev_master_upper_dev_link()
>                   |
>                   v                    bridge waiting:
>         call_netdevice_notifiers           ^  huh, switchdev_bridge_port_offload
>                   |                        |  wasn't called, okay, I'll use a
>                   v                        |  hwdom of zero for this one.
>        dsa_slave_netdevice_event           :  Then packets received on swp0 will
>                   |                        :  not be software-forwarded towards
>                   v                        :  swp1, but they will towards bond0.
>          it's not for me, but
>        bond0 is an upper of swp3
>       and swp4, but their dp->lag_dev
>        is NULL because they couldn't
>             offload it.
>
> Basically we can draw the conclusion that the lowers of a bridge port
> can come and go, so depending on the configuration of lowers for a
> bridge port, it can dynamically toggle between offloaded and unoffloaded.
> Therefore, we need an equivalent switchdev_bridge_port_unoffload too.
>
> This patch changes the way any switchdev driver interacts with the
> bridge. From now on, everybody needs to call switchdev_bridge_port_offload
> and switchdev_bridge_port_unoffload, otherwise the bridge will treat the
> port as non-offloaded and allow software flooding to other ports from
> the same ASIC.
>
> Note that these functions lay the ground for a more complex handshake
> between switchdev drivers and the bridge in the future.
>
> For drivers that will request a replay of the switchdev objects when
> they offload and unoffload a bridge port (DSA, dpaa2-switch, ocelot), we
> place the call to switchdev_bridge_port_unoffload() strategically inside
> the NETDEV_PRECHANGEUPPER notifier's code path, and not inside
> NETDEV_CHANGEUPPER. This is because the switchdev object replay helpers
> need the netdev adjacency lists to be valid, and that is only true in
> NETDEV_PRECHANGEUPPER.
>
> Cc: Vadym Kochan <vkochan@marvell.com>
> Cc: Taras Chornyi <tchornyi@marvell.com>
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
> Cc: Lars Povlsen <lars.povlsen@microchip.com>
> Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
> Cc: UNGLinuxDriver@microchip.com
> Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com> # dpaa2-switch: regression
> Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com> # dpaa2-switch
> Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com> # ocelot-switch
> ---
> v2->v3: patch is new
> v3->v4: added mlxsw_sp_port_pre_lag_leave() and mlxsw_sp_port_pre_vlan_leave()
> v4->v5: use for the comparison in nbp_switchdev_hwdom_set() the
>         nbp->ppid provided by switchdev_bridge_port_offload() instead of
>         recursing through the lower interfaces of the nbp->dev
> v5->v6:
> - add error handling to dpaa2-switch
> - drop useless arguments from switchdev_bridge_port_unoffload(): dev,
>   extack, and make it return void
> - stop reworking as deeply the drivers where no replays will be
>   requested for now, and just call the offload/unoffload helpers where
>   it is most convenient.
>
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 13 +++
>  .../ethernet/marvell/prestera/prestera_main.c |  3 +-
>  .../marvell/prestera/prestera_switchdev.c     | 11 ++-
>  .../marvell/prestera/prestera_switchdev.h     |  3 +-
>  .../mellanox/mlxsw/spectrum_switchdev.c       | 24 ++++--
>  .../microchip/sparx5/sparx5_switchdev.c       | 23 +++++-
>  drivers/net/ethernet/mscc/ocelot_net.c        | 71 ++++++++++++++++
>  drivers/net/ethernet/rocker/rocker.h          |  3 +-
>  drivers/net/ethernet/rocker/rocker_main.c     |  9 +-
>  drivers/net/ethernet/rocker/rocker_ofdpa.c    | 18 +++-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 17 +++-
>  drivers/net/ethernet/ti/cpsw_new.c            | 15 +++-
>  include/linux/if_bridge.h                     | 21 +++++
>  net/bridge/br_if.c                            | 13 +--
>  net/bridge/br_private.h                       | 13 +--
>  net/bridge/br_switchdev.c                     | 82 ++++++++++++++++---
>  net/dsa/port.c                                | 16 +++-
>  17 files changed, 298 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
> index 23798feb40b2..9b090da3e460 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
> @@ -1930,8 +1930,13 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
>         if (err)
>                 goto err_egress_flood;
>
> +       err = switchdev_bridge_port_offload(netdev, netdev, extack);
> +       if (err)
> +               goto err_switchdev_offload;
> +
>         return 0;
>
> +err_switchdev_offload:
>  err_egress_flood:
>         dpaa2_switch_port_set_fdb(port_priv, NULL);
>         return err;
> @@ -1957,6 +1962,11 @@ static int dpaa2_switch_port_restore_rxvlan(struct net_device *vdev, int vid, vo
>         return dpaa2_switch_port_vlan_add(arg, vlan_proto, vid);
>  }
>
> +static void dpaa2_switch_port_pre_bridge_leave(struct net_device *netdev)
> +{
> +       switchdev_bridge_port_unoffload(netdev);
> +}
> +
>  static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
>  {
>         struct ethsw_port_priv *port_priv = netdev_priv(netdev);
> @@ -2078,6 +2088,9 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
>                 if (err)
>                         goto out;
>
> +               if (!info->linking)
> +                       dpaa2_switch_port_pre_bridge_leave(netdev);
> +
>                 break;
>         case NETDEV_CHANGEUPPER:
>                 upper_dev = info->upper_dev;
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index 226f4ff29f6e..7c569c1abefc 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -746,7 +746,8 @@ static int prestera_netdev_port_event(struct net_device *lower,
>         case NETDEV_CHANGEUPPER:
>                 if (netif_is_bridge_master(upper)) {
>                         if (info->linking)
> -                               return prestera_bridge_port_join(upper, port);
> +                               return prestera_bridge_port_join(upper, port,
> +                                                                extack);
>                         else
>                                 prestera_bridge_port_leave(upper, port);
>                 } else if (netif_is_lag_master(upper)) {
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> index 0b3e8f2db294..8cf3fe3b7e58 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> @@ -480,7 +480,8 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
>  }
>
>  int prestera_bridge_port_join(struct net_device *br_dev,
> -                             struct prestera_port *port)
> +                             struct prestera_port *port,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct prestera_switchdev *swdev = port->sw->swdev;
>         struct prestera_bridge_port *br_port;
> @@ -500,6 +501,10 @@ int prestera_bridge_port_join(struct net_device *br_dev,
>                 goto err_brport_create;
>         }
>
> +       err = switchdev_bridge_port_offload(br_port->dev, port->dev, extack);
> +       if (err)
> +               goto err_switchdev_offload;
> +
>         if (bridge->vlan_enabled)
>                 return 0;
>
> @@ -510,6 +515,8 @@ int prestera_bridge_port_join(struct net_device *br_dev,
>         return 0;
>
>  err_port_join:
> +       switchdev_bridge_port_unoffload(br_port->dev);
> +err_switchdev_offload:
>         prestera_bridge_port_put(br_port);
>  err_brport_create:
>         prestera_bridge_put(bridge);
> @@ -584,6 +591,8 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
>         else
>                 prestera_bridge_1d_port_leave(br_port);
>
> +       switchdev_bridge_port_unoffload(br_port->dev);
> +
>         prestera_hw_port_learning_set(port, false);
>         prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD, 0);
>         prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
> index a91bc35d235f..0e93fda3d9a5 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
> @@ -8,7 +8,8 @@ int prestera_switchdev_init(struct prestera_switch *sw);
>  void prestera_switchdev_fini(struct prestera_switch *sw);
>
>  int prestera_bridge_port_join(struct net_device *br_dev,
> -                             struct prestera_port *port);
> +                             struct prestera_port *port,
> +                             struct netlink_ext_ack *extack);
>
>  void prestera_bridge_port_leave(struct net_device *br_dev,
>                                 struct prestera_port *port);
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
> index 61911fed6aeb..c52317de1f35 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
> @@ -335,14 +335,16 @@ mlxsw_sp_bridge_port_find(struct mlxsw_sp_bridge *bridge,
>
>  static struct mlxsw_sp_bridge_port *
>  mlxsw_sp_bridge_port_create(struct mlxsw_sp_bridge_device *bridge_device,
> -                           struct net_device *brport_dev)
> +                           struct net_device *brport_dev,
> +                           struct netlink_ext_ack *extack)
>  {
>         struct mlxsw_sp_bridge_port *bridge_port;
>         struct mlxsw_sp_port *mlxsw_sp_port;
> +       int err;
>
>         bridge_port = kzalloc(sizeof(*bridge_port), GFP_KERNEL);
>         if (!bridge_port)
> -               return NULL;
> +               return ERR_PTR(-ENOMEM);
>
>         mlxsw_sp_port = mlxsw_sp_port_dev_lower_find(brport_dev);
>         bridge_port->lagged = mlxsw_sp_port->lagged;
> @@ -359,12 +361,23 @@ mlxsw_sp_bridge_port_create(struct mlxsw_sp_bridge_device *bridge_device,
>         list_add(&bridge_port->list, &bridge_device->ports_list);
>         bridge_port->ref_count = 1;
>
> +       err = switchdev_bridge_port_offload(brport_dev, mlxsw_sp_port->dev,
> +                                           extack);
> +       if (err)
> +               goto err_switchdev_offload;
> +
>         return bridge_port;
> +
> +err_switchdev_offload:
> +       list_del(&bridge_port->list);
> +       kfree(bridge_port);
> +       return ERR_PTR(err);
>  }
>
>  static void
>  mlxsw_sp_bridge_port_destroy(struct mlxsw_sp_bridge_port *bridge_port)
>  {
> +       switchdev_bridge_port_unoffload(bridge_port->dev);
>         list_del(&bridge_port->list);
>         WARN_ON(!list_empty(&bridge_port->vlans_list));
>         kfree(bridge_port);
> @@ -390,9 +403,10 @@ mlxsw_sp_bridge_port_get(struct mlxsw_sp_bridge *bridge,
>         if (IS_ERR(bridge_device))
>                 return ERR_CAST(bridge_device);
>
> -       bridge_port = mlxsw_sp_bridge_port_create(bridge_device, brport_dev);
> -       if (!bridge_port) {
> -               err = -ENOMEM;
> +       bridge_port = mlxsw_sp_bridge_port_create(bridge_device, brport_dev,
> +                                                 extack);
> +       if (IS_ERR(bridge_port)) {
> +               err = PTR_ERR(bridge_port);
>                 goto err_bridge_port_create;
>         }
>
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> index a72e3b3b596e..e4fb573563d0 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
> @@ -93,9 +93,12 @@ static int sparx5_port_attr_set(struct net_device *dev, const void *ctx,
>  }
>
>  static int sparx5_port_bridge_join(struct sparx5_port *port,
> -                                  struct net_device *bridge)
> +                                  struct net_device *bridge,
> +                                  struct netlink_ext_ack *extack)
>  {
>         struct sparx5 *sparx5 = port->sparx5;
> +       struct net_device *ndev = port->ndev;
> +       int err;
>
>         if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
>                 /* First bridged port */
> @@ -109,12 +112,20 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
>
>         set_bit(port->portno, sparx5->bridge_mask);
>
> +       err = switchdev_bridge_port_offload(ndev, ndev, extack);
> +       if (err)
> +               goto err_switchdev_offload;
> +
>         /* Port enters in bridge mode therefor don't need to copy to CPU
>          * frames for multicast in case the bridge is not requesting them
>          */
> -       __dev_mc_unsync(port->ndev, sparx5_mc_unsync);
> +       __dev_mc_unsync(ndev, sparx5_mc_unsync);
>
>         return 0;
> +
> +err_switchdev_offload:
> +       clear_bit(port->portno, sparx5->bridge_mask);
> +       return err;
>  }
>
>  static void sparx5_port_bridge_leave(struct sparx5_port *port,
> @@ -122,6 +133,8 @@ static void sparx5_port_bridge_leave(struct sparx5_port *port,
>  {
>         struct sparx5 *sparx5 = port->sparx5;
>
> +       switchdev_bridge_port_unoffload(port->ndev);
> +
>         clear_bit(port->portno, sparx5->bridge_mask);
>         if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
>                 sparx5->hw_bridge_dev = NULL;
> @@ -139,11 +152,15 @@ static int sparx5_port_changeupper(struct net_device *dev,
>                                    struct netdev_notifier_changeupper_info *info)
>  {
>         struct sparx5_port *port = netdev_priv(dev);
> +       struct netlink_ext_ack *extack;
>         int err = 0;
>
> +       extack = netdev_notifier_info_to_extack(&info->info);
> +
>         if (netif_is_bridge_master(info->upper_dev)) {
>                 if (info->linking)
> -                       err = sparx5_port_bridge_join(port, info->upper_dev);
> +                       err = sparx5_port_bridge_join(port, info->upper_dev,
> +                                                     extack);
>                 else
>                         sparx5_port_bridge_leave(port, info->upper_dev);
>
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index e9d260d84bf3..76b7b9536bf7 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1216,6 +1216,10 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
>
>         ocelot_port_bridge_join(ocelot, port, bridge);
>
> +       err = switchdev_bridge_port_offload(brport_dev, dev, extack);
> +       if (err)
> +               goto err_switchdev_offload;
> +
>         err = ocelot_switchdev_sync(ocelot, port, brport_dev, bridge, extack);
>         if (err)
>                 goto err_switchdev_sync;
> @@ -1223,10 +1227,17 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
>         return 0;
>
>  err_switchdev_sync:
> +       switchdev_bridge_port_unoffload(brport_dev);
> +err_switchdev_offload:
>         ocelot_port_bridge_leave(ocelot, port, bridge);
>         return err;
>  }
>
> +static void ocelot_netdevice_pre_bridge_leave(struct net_device *brport_dev)
> +{
> +       switchdev_bridge_port_unoffload(brport_dev);
> +}
> +
>  static int ocelot_netdevice_bridge_leave(struct net_device *dev,
>                                          struct net_device *brport_dev,
>                                          struct net_device *bridge)
> @@ -1279,6 +1290,18 @@ static int ocelot_netdevice_lag_join(struct net_device *dev,
>         return err;
>  }
>
> +static void ocelot_netdevice_pre_lag_leave(struct net_device *dev,
> +                                          struct net_device *bond)
> +{
> +       struct net_device *bridge_dev;
> +
> +       bridge_dev = netdev_master_upper_dev_get(bond);
> +       if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
> +               return;
> +
> +       ocelot_netdevice_pre_bridge_leave(bond);
> +}
> +
>  static int ocelot_netdevice_lag_leave(struct net_device *dev,
>                                       struct net_device *bond)
>  {
> @@ -1355,6 +1378,43 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
>         return NOTIFY_DONE;
>  }
>
> +static int
> +ocelot_netdevice_prechangeupper(struct net_device *dev,
> +                               struct net_device *brport_dev,
> +                               struct netdev_notifier_changeupper_info *info)
> +{
> +       if (netif_is_bridge_master(info->upper_dev) && !info->linking)
> +               ocelot_netdevice_pre_bridge_leave(brport_dev);
> +
> +       if (netif_is_lag_master(info->upper_dev) && !info->linking)
> +               ocelot_netdevice_pre_lag_leave(dev, info->upper_dev);
> +
> +       return NOTIFY_DONE;
> +}
> +
> +static int
> +ocelot_netdevice_lag_prechangeupper(struct net_device *dev,
> +                                   struct netdev_notifier_changeupper_info *info)
> +{
> +       struct net_device *lower;
> +       struct list_head *iter;
> +       int err = NOTIFY_DONE;
> +
> +       netdev_for_each_lower_dev(dev, lower, iter) {
> +               struct ocelot_port_private *priv = netdev_priv(lower);
> +               struct ocelot_port *ocelot_port = &priv->port;
> +
> +               if (ocelot_port->bond != dev)
> +                       return NOTIFY_OK;
> +
> +               err = ocelot_netdevice_prechangeupper(dev, lower, info);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return NOTIFY_DONE;
> +}
> +
>  static int
>  ocelot_netdevice_changelowerstate(struct net_device *dev,
>                                   struct netdev_lag_lower_state_info *info)
> @@ -1382,6 +1442,17 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
>         struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>
>         switch (event) {
> +       case NETDEV_PRECHANGEUPPER: {
> +               struct netdev_notifier_changeupper_info *info = ptr;
> +
> +               if (ocelot_netdevice_dev_check(dev))
> +                       return ocelot_netdevice_prechangeupper(dev, dev, info);
> +
> +               if (netif_is_lag_master(dev))
> +                       return ocelot_netdevice_lag_prechangeupper(dev, info);
> +
> +               break;
> +       }
>         case NETDEV_CHANGEUPPER: {
>                 struct netdev_notifier_changeupper_info *info = ptr;
>
> diff --git a/drivers/net/ethernet/rocker/rocker.h b/drivers/net/ethernet/rocker/rocker.h
> index 315a6e5c0f59..e75814a4654f 100644
> --- a/drivers/net/ethernet/rocker/rocker.h
> +++ b/drivers/net/ethernet/rocker/rocker.h
> @@ -119,7 +119,8 @@ struct rocker_world_ops {
>         int (*port_obj_fdb_del)(struct rocker_port *rocker_port,
>                                 u16 vid, const unsigned char *addr);
>         int (*port_master_linked)(struct rocker_port *rocker_port,
> -                                 struct net_device *master);
> +                                 struct net_device *master,
> +                                 struct netlink_ext_ack *extack);
>         int (*port_master_unlinked)(struct rocker_port *rocker_port,
>                                     struct net_device *master);
>         int (*port_neigh_update)(struct rocker_port *rocker_port,
> diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
> index a46633606cae..53d407a5dbf7 100644
> --- a/drivers/net/ethernet/rocker/rocker_main.c
> +++ b/drivers/net/ethernet/rocker/rocker_main.c
> @@ -1670,13 +1670,14 @@ rocker_world_port_fdb_del(struct rocker_port *rocker_port,
>  }
>
>  static int rocker_world_port_master_linked(struct rocker_port *rocker_port,
> -                                          struct net_device *master)
> +                                          struct net_device *master,
> +                                          struct netlink_ext_ack *extack)
>  {
>         struct rocker_world_ops *wops = rocker_port->rocker->wops;
>
>         if (!wops->port_master_linked)
>                 return -EOPNOTSUPP;
> -       return wops->port_master_linked(rocker_port, master);
> +       return wops->port_master_linked(rocker_port, master, extack);
>  }
>
>  static int rocker_world_port_master_unlinked(struct rocker_port *rocker_port,
> @@ -3107,6 +3108,7 @@ struct rocker_port *rocker_port_dev_lower_find(struct net_device *dev,
>  static int rocker_netdevice_event(struct notifier_block *unused,
>                                   unsigned long event, void *ptr)
>  {
> +       struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
>         struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>         struct netdev_notifier_changeupper_info *info;
>         struct rocker_port *rocker_port;
> @@ -3123,7 +3125,8 @@ static int rocker_netdevice_event(struct notifier_block *unused,
>                 rocker_port = netdev_priv(dev);
>                 if (info->linking) {
>                         err = rocker_world_port_master_linked(rocker_port,
> -                                                             info->upper_dev);
> +                                                             info->upper_dev,
> +                                                             extack);
>                         if (err)
>                                 netdev_warn(dev, "failed to reflect master linked (err %d)\n",
>                                             err);
> diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> index 967a634ee9ac..84dcaf8687a0 100644
> --- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
> +++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
> @@ -2571,8 +2571,10 @@ static int ofdpa_port_obj_fdb_del(struct rocker_port *rocker_port,
>  }
>
>  static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
> -                                 struct net_device *bridge)
> +                                 struct net_device *bridge,
> +                                 struct netlink_ext_ack *extack)
>  {
> +       struct net_device *dev = ofdpa_port->dev;
>         int err;
>
>         /* Port is joining bridge, so the internal VLAN for the
> @@ -2592,13 +2594,20 @@ static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
>
>         ofdpa_port->bridge_dev = bridge;
>
> -       return ofdpa_port_vlan_add(ofdpa_port, OFDPA_UNTAGGED_VID, 0);
> +       err = ofdpa_port_vlan_add(ofdpa_port, OFDPA_UNTAGGED_VID, 0);
> +       if (err)
> +               return err;
> +
> +       return switchdev_bridge_port_offload(dev, dev, extack);
>  }
>
>  static int ofdpa_port_bridge_leave(struct ofdpa_port *ofdpa_port)
>  {
> +       struct net_device *dev = ofdpa_port->dev;
>         int err;
>
> +       switchdev_bridge_port_unoffload(dev);
> +
>         err = ofdpa_port_vlan_del(ofdpa_port, OFDPA_UNTAGGED_VID, 0);
>         if (err)
>                 return err;
> @@ -2637,13 +2646,14 @@ static int ofdpa_port_ovs_changed(struct ofdpa_port *ofdpa_port,
>  }
>
>  static int ofdpa_port_master_linked(struct rocker_port *rocker_port,
> -                                   struct net_device *master)
> +                                   struct net_device *master,
> +                                   struct netlink_ext_ack *extack)
>  {
>         struct ofdpa_port *ofdpa_port = rocker_port->wpriv;
>         int err = 0;
>
>         if (netif_is_bridge_master(master))
> -               err = ofdpa_port_bridge_join(ofdpa_port, master);
> +               err = ofdpa_port_bridge_join(ofdpa_port, master, extack);
>         else if (netif_is_ovs_master(master))
>                 err = ofdpa_port_ovs_changed(ofdpa_port, master);
>         return err;
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 718539cdd2f2..8b9596eb808e 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -7,6 +7,7 @@
>
>  #include <linux/clk.h>
>  #include <linux/etherdevice.h>
> +#include <linux/if_bridge.h>
>  #include <linux/if_vlan.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
> @@ -2077,10 +2078,13 @@ bool am65_cpsw_port_dev_check(const struct net_device *ndev)
>         return false;
>  }
>
> -static int am65_cpsw_netdevice_port_link(struct net_device *ndev, struct net_device *br_ndev)
> +static int am65_cpsw_netdevice_port_link(struct net_device *ndev,
> +                                        struct net_device *br_ndev,
> +                                        struct netlink_ext_ack *extack)
>  {
>         struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
>         struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
> +       int err;
>
>         if (!common->br_members) {
>                 common->hw_bridge_dev = br_ndev;
> @@ -2092,6 +2096,10 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev, struct net_dev
>                         return -EOPNOTSUPP;
>         }
>
> +       err = switchdev_bridge_port_offload(ndev, ndev, extack);
> +       if (err)
> +               return err;
> +
>         common->br_members |= BIT(priv->port->port_id);
>
>         am65_cpsw_port_offload_fwd_mark_update(common);
> @@ -2104,6 +2112,8 @@ static void am65_cpsw_netdevice_port_unlink(struct net_device *ndev)
>         struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
>         struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
>
> +       switchdev_bridge_port_unoffload(ndev);
> +
>         common->br_members &= ~BIT(priv->port->port_id);
>
>         am65_cpsw_port_offload_fwd_mark_update(common);
> @@ -2116,6 +2126,7 @@ static void am65_cpsw_netdevice_port_unlink(struct net_device *ndev)
>  static int am65_cpsw_netdevice_event(struct notifier_block *unused,
>                                      unsigned long event, void *ptr)
>  {
> +       struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
>         struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
>         struct netdev_notifier_changeupper_info *info;
>         int ret = NOTIFY_DONE;
> @@ -2129,7 +2140,9 @@ static int am65_cpsw_netdevice_event(struct notifier_block *unused,
>
>                 if (netif_is_bridge_master(info->upper_dev)) {
>                         if (info->linking)
> -                               ret = am65_cpsw_netdevice_port_link(ndev, info->upper_dev);
> +                               ret = am65_cpsw_netdevice_port_link(ndev,
> +                                                                   info->upper_dev,
> +                                                                   extack);
>                         else
>                                 am65_cpsw_netdevice_port_unlink(ndev);
>                 }
> diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
> index 57d279fdcc9f..bf9cadfb11b5 100644
> --- a/drivers/net/ethernet/ti/cpsw_new.c
> +++ b/drivers/net/ethernet/ti/cpsw_new.c
> @@ -11,6 +11,7 @@
>  #include <linux/module.h>
>  #include <linux/irqreturn.h>
>  #include <linux/interrupt.h>
> +#include <linux/if_bridge.h>
>  #include <linux/if_ether.h>
>  #include <linux/etherdevice.h>
>  #include <linux/net_tstamp.h>
> @@ -1499,10 +1500,12 @@ static void cpsw_port_offload_fwd_mark_update(struct cpsw_common *cpsw)
>  }
>
>  static int cpsw_netdevice_port_link(struct net_device *ndev,
> -                                   struct net_device *br_ndev)
> +                                   struct net_device *br_ndev,
> +                                   struct netlink_ext_ack *extack)
>  {
>         struct cpsw_priv *priv = netdev_priv(ndev);
>         struct cpsw_common *cpsw = priv->cpsw;
> +       int err;
>
>         if (!cpsw->br_members) {
>                 cpsw->hw_bridge_dev = br_ndev;
> @@ -1514,6 +1517,10 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
>                         return -EOPNOTSUPP;
>         }
>
> +       err = switchdev_bridge_port_offload(ndev, ndev, extack);
> +       if (err)
> +               return err;
> +
>         cpsw->br_members |= BIT(priv->emac_port);
>
>         cpsw_port_offload_fwd_mark_update(cpsw);
> @@ -1526,6 +1533,8 @@ static void cpsw_netdevice_port_unlink(struct net_device *ndev)
>         struct cpsw_priv *priv = netdev_priv(ndev);
>         struct cpsw_common *cpsw = priv->cpsw;
>
> +       switchdev_bridge_port_unoffload(ndev);
> +
>         cpsw->br_members &= ~BIT(priv->emac_port);
>
>         cpsw_port_offload_fwd_mark_update(cpsw);
> @@ -1538,6 +1547,7 @@ static void cpsw_netdevice_port_unlink(struct net_device *ndev)
>  static int cpsw_netdevice_event(struct notifier_block *unused,
>                                 unsigned long event, void *ptr)
>  {
> +       struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
>         struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
>         struct netdev_notifier_changeupper_info *info;
>         int ret = NOTIFY_DONE;
> @@ -1552,7 +1562,8 @@ static int cpsw_netdevice_event(struct notifier_block *unused,
>                 if (netif_is_bridge_master(info->upper_dev)) {
>                         if (info->linking)
>                                 ret = cpsw_netdevice_port_link(ndev,
> -                                                              info->upper_dev);
> +                                                              info->upper_dev,
> +                                                              extack);
>                         else
>                                 cpsw_netdevice_port_unlink(ndev);
>                 }
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index b651c5e32a28..ce413eca527e 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -206,4 +206,25 @@ static inline int br_fdb_replay(const struct net_device *br_dev,
>  }
>  #endif
>
> +#if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_NET_SWITCHDEV)
> +
> +int switchdev_bridge_port_offload(struct net_device *brport_dev,
> +                                 struct net_device *dev,
> +                                 struct netlink_ext_ack *extack);
> +void switchdev_bridge_port_unoffload(struct net_device *brport_dev);
> +
> +#else
> +
> +static inline int switchdev_bridge_port_offload(struct net_device *brport_dev,
> +                                               struct net_device *dev,
> +                                               struct netlink_ext_ack *extack)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline void switchdev_bridge_port_unoffload(struct net_device *brport_dev)
> +{
> +}
> +#endif
> +
>  #endif
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index c0df50e4abbb..86f6d7e93ea8 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -349,7 +349,6 @@ static void del_nbp(struct net_bridge_port *p)
>         nbp_backup_clear(p);
>
>         nbp_update_port_count(br);
> -       nbp_switchdev_del(p);
>
>         netdev_upper_dev_unlink(dev, br->dev);
>
> @@ -644,10 +643,6 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>         if (err)
>                 goto err5;
>
> -       err = nbp_switchdev_add(p);
> -       if (err)
> -               goto err6;
> -
>         dev_disable_lro(dev);
>
>         list_add_rcu(&p->list, &br->port_list);
> @@ -685,13 +680,13 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>                  */
>                 err = dev_pre_changeaddr_notify(br->dev, dev->dev_addr, extack);
>                 if (err)
> -                       goto err7;
> +                       goto err6;
>         }
>
>         err = nbp_vlan_init(p, extack);
>         if (err) {
>                 netdev_err(dev, "failed to initialize vlan filtering on this port\n");
> -               goto err7;
> +               goto err6;
>         }
>
>         spin_lock_bh(&br->lock);
> @@ -714,14 +709,12 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>
>         return 0;
>
> -err7:
> +err6:
>         if (fdb_synced)
>                 br_fdb_unsync_static(br, p);
>         list_del_rcu(&p->list);
>         br_fdb_delete_by_port(br, p, 0, 1);
>         nbp_update_port_count(br);
> -       nbp_switchdev_del(p);
> -err6:
>         netdev_upper_dev_unlink(dev, br->dev);
>  err5:
>         dev->priv_flags &= ~IFF_BRIDGE_PORT;
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 1c1732d7212a..8d2e4d807808 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -392,6 +392,8 @@ struct net_bridge_port {
>          * hardware domain.
>          */
>         int                             hwdom;
> +       int                             offload_count;
> +       struct netdev_phys_item_id      ppid;
>  #endif
>         u16                             group_fwd_mask;
>         u16                             backup_redirected_cnt;
> @@ -1856,8 +1858,6 @@ void br_switchdev_fdb_notify(struct net_bridge *br,
>  int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
>                                struct netlink_ext_ack *extack);
>  int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
> -int nbp_switchdev_add(struct net_bridge_port *p);
> -void nbp_switchdev_del(struct net_bridge_port *p);
>  void br_switchdev_init(struct net_bridge *br);
>
>  static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
> @@ -1906,15 +1906,6 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
>  {
>  }
>
> -static inline int nbp_switchdev_add(struct net_bridge_port *p)
> -{
> -       return 0;
> -}
> -
> -static inline void nbp_switchdev_del(struct net_bridge_port *p)
> -{
> -}
> -
>  static inline void br_switchdev_init(struct net_bridge *br)
>  {
>  }
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index f3120f13c293..39f0787fde01 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -133,7 +133,7 @@ static int nbp_switchdev_hwdom_set(struct net_bridge_port *joining)
>
>         /* joining is yet to be added to the port list. */
>         list_for_each_entry(p, &br->port_list, list) {
> -               if (netdev_port_same_parent_id(joining->dev, p->dev)) {
> +               if (netdev_phys_item_id_same(&joining->ppid, &p->ppid)) {
>                         joining->hwdom = p->hwdom;
>                         return 0;
>                 }
> @@ -162,27 +162,85 @@ static void nbp_switchdev_hwdom_put(struct net_bridge_port *leaving)
>         clear_bit(leaving->hwdom, &br->busy_hwdoms);
>  }
>
> -int nbp_switchdev_add(struct net_bridge_port *p)
> +static int nbp_switchdev_add(struct net_bridge_port *p,
> +                            struct netdev_phys_item_id ppid,
> +                            struct netlink_ext_ack *extack)
>  {
> -       struct netdev_phys_item_id ppid = { };
> -       int err;
> +       if (p->offload_count) {
> +               /* Prevent unsupported configurations such as a bridge port
> +                * which is a bonding interface, and the member ports are from
> +                * different hardware switches.
> +                */
> +               if (!netdev_phys_item_id_same(&p->ppid, &ppid)) {
> +                       NL_SET_ERR_MSG_MOD(extack,
> +                                          "Same bridge port cannot be offloaded by two physical switches");
> +                       return -EBUSY;
> +               }
>
> -       ASSERT_RTNL();
> +               /* Tolerate drivers that call switchdev_bridge_port_offload()
> +                * more than once for the same bridge port, such as when the
> +                * bridge port is an offloaded bonding/team interface.
> +                */
> +               p->offload_count++;
>
> -       err = dev_get_port_parent_id(p->dev, &ppid, true);
> -       if (err) {
> -               if (err == -EOPNOTSUPP)
> -                       return 0;
> -               return err;
> +               return 0;
>         }
>
> +       p->ppid = ppid;
> +       p->offload_count = 1;
> +
>         return nbp_switchdev_hwdom_set(p);
>  }
>
> -void nbp_switchdev_del(struct net_bridge_port *p)
> +static void nbp_switchdev_del(struct net_bridge_port *p)
>  {
> -       ASSERT_RTNL();
> +       if (WARN_ON(!p->offload_count))
> +               return;
> +
> +       p->offload_count--;
> +
> +       if (p->offload_count)
> +               return;
>
>         if (p->hwdom)
>                 nbp_switchdev_hwdom_put(p);
>  }
> +
> +/* Let the bridge know that this port is offloaded, so that it can assign a
> + * switchdev hardware domain to it.
> + */
> +int switchdev_bridge_port_offload(struct net_device *brport_dev,
> +                                 struct net_device *dev,
> +                                 struct netlink_ext_ack *extack)
> +{
> +       struct netdev_phys_item_id ppid;
> +       struct net_bridge_port *p;
> +       int err;
> +
> +       ASSERT_RTNL();
> +
> +       p = br_port_get_rtnl(brport_dev);
> +       if (!p)
> +               return -ENODEV;
> +
> +       err = dev_get_port_parent_id(dev, &ppid, false);
> +       if (err)
> +               return err;
> +
> +       return nbp_switchdev_add(p, ppid, extack);
> +}
> +EXPORT_SYMBOL_GPL(switchdev_bridge_port_offload);
> +
> +void switchdev_bridge_port_unoffload(struct net_device *brport_dev)
> +{
> +       struct net_bridge_port *p;
> +
> +       ASSERT_RTNL();
> +
> +       p = br_port_get_rtnl(brport_dev);
> +       if (!p)
> +               return;
> +
> +       nbp_switchdev_del(p);
> +}
> +EXPORT_SYMBOL_GPL(switchdev_bridge_port_unoffload);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 982e18771d76..7accda066149 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -292,6 +292,8 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>                 .port = dp->index,
>                 .br = br,
>         };
> +       struct net_device *dev = dp->slave;
> +       struct net_device *brport_dev;
>         int err;
>
>         /* Here the interface is already bridged. Reflect the current
> @@ -299,16 +301,24 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>          */
>         dp->bridge_dev = br;
>
> +       brport_dev = dsa_port_to_bridge_port(dp);
> +
>         err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
>         if (err)
>                 goto out_rollback;
>
> -       err = dsa_port_switchdev_sync(dp, extack);
> +       err = switchdev_bridge_port_offload(brport_dev, dev, extack);
>         if (err)
>                 goto out_rollback_unbridge;
>
> +       err = dsa_port_switchdev_sync(dp, extack);
> +       if (err)
> +               goto out_rollback_unoffload;
> +
>         return 0;
>
> +out_rollback_unoffload:
> +       switchdev_bridge_port_unoffload(brport_dev);
>  out_rollback_unbridge:
>         dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
>  out_rollback:
> @@ -319,6 +329,10 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>  int dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br,
>                               struct netlink_ext_ack *extack)
>  {
> +       struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
> +
> +       switchdev_bridge_port_unoffload(brport_dev);
> +
>         return dsa_port_switchdev_unsync_objs(dp, br, extack);
>  }


[Please ignore if it is already reported]

Following build error noticed on Linux next 20210723 tag
with omap2plus_defconfig on arm architecture.

arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.o: in
function `cpsw_netdevice_event':
drivers/net/ethernet/ti/cpsw_new.c:1520: undefined reference to
`switchdev_bridge_port_offload'
arm-linux-gnueabihf-ld: drivers/net/ethernet/ti/cpsw_new.c:1537:
undefined reference to `switchdev_bridge_port_unoffload'

ref:
https://builds.tuxbuild.com/1vhy42tGxtLJWBZXR3PjnNGrzf7/
https://builds.tuxbuild.com/1vhy42tGxtLJWBZXR3PjnNGrzf7/config

Steps to reproduce:
--------------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.

tuxmake --runtime podman --target-arch arm --toolchain gcc-10
--kconfig omap2plus_defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
