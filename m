Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302B642300E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhJESeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJESeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 14:34:01 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1967FC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 11:32:10 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id i4so90994126lfv.4
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 11:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=7XY3ZCmyMoNjOk0UnKBCtqMMgVAAxcFZltfWINCfqLw=;
        b=GPWwwBqteHlEPwplsp1J8XNhQRj6V8ZkAb28fqMYYj8m3+iNOl3CYyIJE4aUioBtAW
         i1DN15aFqP2qiI4sZT8pvb2qBZIAGxtQNnQ6OBQjFaio+u3wd1ZjH5/85p9IzdGCoTHR
         L4FDWRRapDy/pdjaa7fnc6oVm10fYu4XedOg+Q8OCfVltHIXJH7fLINr6CjaxzC+kRZC
         YvVyyqT8Ik7xrv+F0DADxpnv8wjf4MGkLx03scAvG4F6xacwO8OqBqwnhm6t/LriVOoD
         Vy2O10djs+CdO+loZIdjPnHRYeC2ZsmePHBNJGlrufP5j2VecZ32nragVDPO6F3X9J2L
         SygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7XY3ZCmyMoNjOk0UnKBCtqMMgVAAxcFZltfWINCfqLw=;
        b=YkBiIqL8C7Z4H5XfO4E9FpgBGp+pZY+UzCQrMbVcMVXH1wtM4IQFcyL4pcMupI9Aub
         x949ervyYkRrmKESDerx7Ib4OGKjxtBddP7JWbmyDbMttAjriJcOL94CmM/UakJLHGv4
         hJE8fq3AJrz88fOivsUVVq3ytGyOskxf7GwodDsnt7JXqzzVtZzbPK7QFjL4rf0y0Vx1
         eavvHWTXVl277u6jsMDz7PEkL7NkTLRBkK2OekcDIBkLzoMOxWVa+OQcn2rKs+nWBkon
         GE40YCGdWswNbvEhKT2+TuQTdosJm9vlYdYbPilb7vxe030Y0cru1jB7hAY2yUtIv9pW
         kQEQ==
X-Gm-Message-State: AOAM5338X1YOiEjeMk9KrOCGtvvM9zBlvhMXnus1RV3c7aEcPTZhCgOZ
        C7dIfpuNt/94HT0zs6S+hgMkFKxKRQEtgw==
X-Google-Smtp-Source: ABdhPJxh5wqUKgMUbj2acqpYKrYZnlIsCTZB6Ux08GtPZQFI5a/5MtpcIEQizMxziHC2rzN2jVUE4Q==
X-Received: by 2002:a2e:9243:: with SMTP id v3mr23843166ljg.47.1633458728156;
        Tue, 05 Oct 2021 11:32:08 -0700 (PDT)
Received: from wkz-x280 (h-155-4-51-145.A259.priv.bahnhof.se. [155.4.51.145])
        by smtp.gmail.com with ESMTPSA id d11sm645938lfm.308.2021.10.05.11.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 11:32:07 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v2 net 4/4] net: dsa: mv88e6xxx: isolate the ATU
 databases of standalone and bridged ports
In-Reply-To: <20211005001414.1234318-5-vladimir.oltean@nxp.com>
References: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
 <20211005001414.1234318-5-vladimir.oltean@nxp.com>
Date:   Tue, 05 Oct 2021 20:32:06 +0200
Message-ID: <874k9vb9w9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 03:14, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> Similar to commit 6087175b7991 ("net: dsa: mt7530: use independent VLAN
> learning on VLAN-unaware bridges"), software forwarding between an
> unoffloaded LAG port (a bonding interface with an unsupported policy)
> and a mv88e6xxx user port directly under a bridge is broken.
>
> We adopt the same strategy, which is to make the standalone ports not
> find any ATU entry learned on a bridge port.
>
> Theory: the mv88e6xxx ATU is looked up by FID and MAC address. There are
> as many FIDs as VIDs (4096). The FID is derived from the VID when
> possible (the VTU maps a VID to a FID), with a fallback to the port
> based default FID value when not (802.1Q Mode is disabled on the port,
> or the classified VID isn't present in the VTU).
>
> The mv88e6xxx driver makes the following use of FIDs and VIDs:
>
> - the port's DefaultVID (to which untagged & pvid-tagged packets get
>   classified) is absent from the VTU, so this kind of packets is
>   processed in FID 0, the default FID assigned by mv88e6xxx_setup_port.
>
> - every time a bridge VLAN is created, mv88e6xxx_port_vlan_join() ->
>   mv88e6xxx_atu_new() associates a FID with that VID which increases
>   linearly starting from 1. Like this:
>
>   bridge vlan add dev lan0 vid 100 # FID 1
>   bridge vlan add dev lan1 vid 100 # still FID 1
>   bridge vlan add dev lan2 vid 1024 # FID 2
>
> The FID allocation made by the driver is sub-optimal for the following
> reasons:
>
> (a) A standalone port has a DefaultPVID of 0 and a default FID of 0 too.
>     A VLAN-unaware bridged port has a DefaultPVID of 0 and a default FID
>     of 0 too. The difference is that the bridged ports may learn ATU
>     entries, while the standalone port may not, and must not find them
>     either. Standalone ports must not use the same FID as ports
>     belonging to a bridge. They can use the same FID between each other,
>     since the ATU will never have an entry in that FID.
>
> (b) Multiple VLAN-unaware bridges will all use a DefaultPVID of 0 and a
>     default FID of 0 on all their ports. The FDBs will not be isolated
>     between these bridges. Every VLAN-unaware bridge must use the same
>     FID on all its ports, different from the FID of other bridge ports.
>
> (c) Each bridge VLAN uses a unique FID which is useful for Independent
>     VLAN Learning, but the same VLAN ID on multiple VLAN-aware bridges
>     will result in the same FID being used by mv88e6xxx_atu_new().
>     The correct behavior is for VLAN 1 in br0 to have a different FID
>     compared to VLAN 1 in br1.
>
> This patch cannot fix all the above. Traditionally the DSA framework did
> not care about this, and the reality is that DSA core involvement is
> needed for the aforementioned issues to be solved. The only thing we can
> solve here is an issue which does not require API changes, and that is
> issue (a).
>
> The first step is deciding what VID and FID to use for standalone ports,
> and what VID and FID for bridged ports. The 0/0 pair for standalone
> ports is what they used up till now, let's keep using that. For bridged
> ports, there are 2 cases:
>
> - VLAN-unaware ports will end up using the port default FID, because we
>   leave their DefaultVID (pvid) at zero (just as in the case of
>   standalone ports), a VID which is absent from the VTU.

I believe this patch gets aaaalmost everything right. But I think we
need to set the port's PVID to 4095 when it is attached to a
VLAN-unaware bridge. Unfortunately I won't be able to prove it until I
get back to the office tomorrow (need physical access to move some
cables around), but I will go out on a limb and present the theory now
anyway :)

Basically, it has to do with the same issue that you have identified in
the CPU tx path. On user-port ingress, setting the port's default FID is
enough to make it select the correct database -- on a single chip
system. Once you're going over a DSA port though, you need to carry that
information in the tag, just like when sending from the CPU. So in this
scenario:

  CPU
   |    .----.
.--0--. | .--0--.
| sw0 | | | sw1 |
'-1-2-' | '-1-2-'
    '---'

Say that sw0p1 and sw1p1 are members of a VLAN-unaware bridge and sw1p2
is in standalone mode. Packets from both sw1p1 and sw1p2 will ingress on
sw0p2 with VID 0 - the port can only have one default FID - yet it has
to map one flow to FID 1 and one to FID 0.

Setting the PVID of sw1p1 should provide that missing piece of
information.

> - VLAN-aware ports will never end up using the port default FID, because
>   packets will always be classified to a VID in the VTU or dropped
>   otherwise. The FID is the one associated with the VID in the VTU.
>
> Having that said, any value will do for the FID of VLAN-unaware bridge
> ports, but we choose 1 because it comes after 0.
>
> So on ingress from user ports that are under a VLAN-unaware bridge,
> tag_dsa.c will see a packet with VID 0 and FID 1. So for the xmit to
> look up the same ATU database, we need to xmit in FID 1 as well.
>
> Because CPU and DSA ports are shared ports, we need to be smarter about
> the way in which we classify a packet to FID 1, we can't just rely on
> the port default FID. The only way in which that appears possible is by
> enabling the 802.1Q Mode on the shared ports (currently it is disabled),
> so as to let the switch derive the VID from the skb, and then the FID
> from the VID. We choose the least strict 802.1Q mode, Fallback, which:
>
> - if the ingress frame's VID isn't in the VTU
>   -> doesn't drop it
>   -> forwards it according to the ingress port's forwarding matrix
>   -> classifies it to the DefaultVID (=> port default FID)
>
> -> if the ingress frame's VID is in the VTU
>   -> forwards it according to the ingress port's forwarding matrix AND
>      the mask of ports that are members of that VID
>   -> classifies it to that VID (=> its associated FID in the VTU)
>
> But to get the desired effect of classifying some packets to FID 1 on
> xmit, we need to install a VID in the ATU which maps to that FID. We
> choose VID 4095, because the bridge cannot install a VID with that value
> so nobody will notice. We install VID 4095 to the VTU in
> mv88e6xxx_setup_port(), with the mention that mv88e6xxx_vtu_setup()
> which was located right below that call was flushing the VTU so those
> entries wouldn't be preserved. So we need to relocate the VTU flushing
> prior to the port initialization during ->setup(). Also note that this
> is why it is safe to assume that VID 4095 will get associated with FID 1:
> the user ports haven't been created, so there is no avenue for the user
> to create a bridge VLAN which could otherwise race with the creation of
> another FID which would otherwise use up the non-reserved FID value of 1.
> Currently mv88e6xxx_port_vlan_join() doesn't have the option of
> specifying a preferred FID, it always calls mv88e6xxx_atu_new().
>
> mv88e6xxx_port_db_load_purge() is the function to access the ATU for
> FDB/MDB entries, and it used to determine the FID to use for
> VLAN-unaware FDB entries (VID=0) using mv88e6xxx_port_get_fid().
> But the driver only called mv88e6xxx_port_set_fid() once, during probe,
> so no surprises, the port FID was always 0. As much as I would have
> wanted to not touch that code, the logic is broken when we add a new
> FID which is not the port-based default. Sure, FID 1 is the default FID
> for bridged ports, but the host-filtered FDB entries which are installed
> by DSA on the shared (DSA and CPU) ports should be installed in FID 1,
> not in FID 0, but FID 1 is not the port default FID on the shared ports.
> So we need to recognize that is more correct to simply hardcode FID 1 in
> mv88e6xxx_port_db_load_purge() and revisit when we have FDB isolation in
> the DSA API.
>
> Lastly, the tagger needs to check, when it is transmitting a VLAN
> untagged skb, whether it is sending it towards a bridged or a standalone
> port. When we see it is bridged we assume the bridge is VLAN-unaware.
> Not because it cannot be VLAN-aware but:
>
> - if we are transmitting from a VLAN-aware bridge we are likely doing so
>   using TX forwarding offload. That code path guarantees that skbs have
>   a vlan hwaccel tag in them, so we would not enter the "else" branch
>   of the "if (skb->protocol == htons(ETH_P_8021Q))" condition.
>
> - if we are transmitting on behalf of a VLAN-aware bridge but with no TX
>   forwarding offload (no PVT support, out of space in the PVT, whatever),
>   we would indeed be transmitting with VLAN 4095 instead of the bridge
>   device's pvid. However we would be injecting a "From CPU" frame, and
>   the switch won't learn from that - it only learns from "Forward" frames.
>   So it is inconsequential for address learning. And VLAN 4095 is
>   absolutely enough for the frame to exit the switch, since we never
>   remove that VLAN from any port.
>
> Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
> Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: patch is new
>
>  MAINTAINERS                      |  1 +
>  drivers/net/dsa/mv88e6xxx/chip.c | 59 +++++++++++++++++++++++++-------
>  drivers/net/dsa/mv88e6xxx/chip.h |  3 ++
>  include/linux/dsa/mv88e6xxx.h    | 13 +++++++
>  net/dsa/tag_dsa.c                | 12 +++++--
>  5 files changed, 73 insertions(+), 15 deletions(-)
>  create mode 100644 include/linux/dsa/mv88e6xxx.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6fbedd4784a3..632580791d2d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11147,6 +11147,7 @@ S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/marvell.txt
>  F:	Documentation/networking/devlink/mv88e6xxx.rst
>  F:	drivers/net/dsa/mv88e6xxx/
> +F:	include/linux/dsa/mv88e6xxx.h
>  F:	include/linux/platform_data/mv88e6xxx.h
>  
>  MARVELL ARMADA 3700 PHY DRIVERS
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index d672112afffd..0aa7e4394aab 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/delay.h>
> +#include <linux/dsa/mv88e6xxx.h>
>  #include <linux/etherdevice.h>
>  #include <linux/ethtool.h>
>  #include <linux/if_bridge.h>
> @@ -1754,11 +1755,15 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
>  	u16 fid;
>  	int err;
>  
> -	/* Null VLAN ID corresponds to the port private database */
> +	/* Ports have two private address databases: one for when the port is
> +	 * standalone and one for when the port is under a bridge and the
> +	 * 802.1Q mode is disabled. When the port is standalone, DSA wants its
> +	 * address database to remain 100% empty, so we never load an ATU entry
> +	 * into a standalone port's database. Therefore, translate the null
> +	 * VLAN ID into the port's database used for VLAN-unaware bridging.
> +	 */
>  	if (vid == 0) {
> -		err = mv88e6xxx_port_get_fid(chip, port, &fid);
> -		if (err)
> -			return err;
> +		fid = MV88E6XXX_FID_BRIDGED;
>  	} else {
>  		err = mv88e6xxx_vtu_get(chip, vid, &vlan);
>  		if (err)
> @@ -2434,7 +2439,16 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
>  	int err;
>  
>  	mv88e6xxx_reg_lock(chip);
> +
>  	err = mv88e6xxx_bridge_map(chip, br);
> +	if (err)
> +		goto unlock;
> +
> +	err = mv88e6xxx_port_set_fid(chip, port, MV88E6XXX_FID_BRIDGED);
> +	if (err)
> +		goto unlock;
> +
> +unlock:
>  	mv88e6xxx_reg_unlock(chip);
>  
>  	return err;
> @@ -2446,9 +2460,14 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  
>  	mv88e6xxx_reg_lock(chip);
> +
>  	if (mv88e6xxx_bridge_map(chip, br) ||
>  	    mv88e6xxx_port_vlan_map(chip, port))
>  		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
> +
> +	if (mv88e6xxx_port_set_fid(chip, port, MV88E6XXX_FID_STANDALONE))
> +		dev_err(ds->dev, "failed to restore port default FID\n");
> +
>  	mv88e6xxx_reg_unlock(chip);
>  }
>  
> @@ -2823,8 +2842,8 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
>  static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  {
>  	struct dsa_switch *ds = chip->ds;
> +	u16 reg, mode, member;
>  	int err;
> -	u16 reg;
>  
>  	chip->ports[port].chip = chip;
>  	chip->ports[port].port = port;
> @@ -2889,8 +2908,24 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  	if (err)
>  		return err;
>  
> -	err = mv88e6xxx_port_set_8021q_mode(chip, port,
> -				MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED);
> +	if (dsa_is_user_port(ds, port)) {
> +		mode = MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED;
> +		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED;
> +	} else {
> +		mode = MV88E6XXX_PORT_CTL2_8021Q_MODE_FALLBACK;
> +		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED;
> +	}
> +
> +	err = mv88e6xxx_port_set_8021q_mode(chip, port, mode);
> +	if (err)
> +		return err;
> +
> +	/* Associate MV88E6XXX_VID_BRIDGED with MV88E6XXX_FID_BRIDGED in the
> +	 * ATU by virtue of the fact that mv88e6xxx_atu_new() will pick it as
> +	 * the first free FID after MV88E6XXX_FID_STANDALONE.
> +	 */
> +	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_BRIDGED,
> +				       member, false);
>  	if (err)
>  		return err;
>  
> @@ -2966,7 +3001,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  	 * database, and allow bidirectional communication between the
>  	 * CPU and DSA port(s), and the other ports.
>  	 */
> -	err = mv88e6xxx_port_set_fid(chip, port, 0);
> +	err = mv88e6xxx_port_set_fid(chip, port, MV88E6XXX_FID_STANDALONE);
>  	if (err)
>  		return err;
>  
> @@ -3156,6 +3191,10 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  		}
>  	}
>  
> +	err = mv88e6xxx_vtu_setup(chip);
> +	if (err)
> +		goto unlock;
> +
>  	/* Setup Switch Port Registers */
>  	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
>  		if (dsa_is_unused_port(ds, i))
> @@ -3185,10 +3224,6 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  	if (err)
>  		goto unlock;
>  
> -	err = mv88e6xxx_vtu_setup(chip);
> -	if (err)
> -		goto unlock;
> -
>  	err = mv88e6xxx_pvt_setup(chip);
>  	if (err)
>  		goto unlock;
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 33d067e8396d..8271b8aa7b71 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -21,6 +21,9 @@
>  #define EDSA_HLEN		8
>  #define MV88E6XXX_N_FID		4096
>  
> +#define MV88E6XXX_FID_STANDALONE	0
> +#define MV88E6XXX_FID_BRIDGED		1
> +
>  /* PVT limits for 4-bit port and 5-bit switch */
>  #define MV88E6XXX_MAX_PVT_SWITCHES	32
>  #define MV88E6XXX_MAX_PVT_PORTS		16
> diff --git a/include/linux/dsa/mv88e6xxx.h b/include/linux/dsa/mv88e6xxx.h
> new file mode 100644
> index 000000000000..8c3d45eca46b
> --- /dev/null
> +++ b/include/linux/dsa/mv88e6xxx.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + * Copyright 2021 NXP
> + */
> +
> +#ifndef _NET_DSA_TAG_MV88E6XXX_H
> +#define _NET_DSA_TAG_MV88E6XXX_H
> +
> +#include <linux/if_vlan.h>
> +
> +#define MV88E6XXX_VID_STANDALONE	0
> +#define MV88E6XXX_VID_BRIDGED		(VLAN_N_VID - 1)
> +
> +#endif
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index 68d5ddc3ef35..b3da4b2ea11c 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -45,6 +45,7 @@
>   *   6    6       2        2      4    2       N
>   */
>  
> +#include <linux/dsa/mv88e6xxx.h>
>  #include <linux/etherdevice.h>
>  #include <linux/list.h>
>  #include <linux/slab.h>
> @@ -164,16 +165,21 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  			dsa_header[2] &= ~0x10;
>  		}
>  	} else {
> +		struct net_device *br = dp->bridge_dev;
> +		u16 vid;
> +
> +		vid = br ? MV88E6XXX_VID_BRIDGED : MV88E6XXX_VID_STANDALONE;
> +
>  		skb_push(skb, DSA_HLEN + extra);
>  		dsa_alloc_etype_header(skb, DSA_HLEN + extra);
>  
> -		/* Construct untagged DSA tag. */
> +		/* Construct DSA header from untagged frame. */
>  		dsa_header = dsa_etype_header_pos_tx(skb) + extra;
>  
>  		dsa_header[0] = (cmd << 6) | tag_dev;
>  		dsa_header[1] = tag_port << 3;
> -		dsa_header[2] = 0;
> -		dsa_header[3] = 0;
> +		dsa_header[2] = vid >> 8;
> +		dsa_header[3] = vid & 0xff;
>  	}
>  
>  	return skb;
> -- 
> 2.25.1
