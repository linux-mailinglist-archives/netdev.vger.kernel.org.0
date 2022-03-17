Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0274DC737
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiCQNGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiCQNGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:06:49 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD98154723
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 06:05:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r23so6548404edb.0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 06:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5nUzBKU2M/FabLNmfTQFOBvFeurdU27+QhGQEVfU4Nk=;
        b=UntbKeqyVJniV50YPTXqQ3kK/lgOX+egQbyhPcAsTZFe1Uwyc4IZyJs7TFV3tCUoGf
         CbCxLUZm8oRkGtwXsjbD6oJwrE7eyPVXKIA07eA7x51nLKy/+FzdNTWiir96qoKHGZOg
         7VfPSkBxF9SsnsWtdc2f5goq8oaviRWeQsujWHd64cmhf2wTC/EbagKx/oon6de90Q+6
         oACAXnFv8QhL3NVUbSfgkPeo2hmLj+D5Smw6aF0fsuOSPdvWbdBKG6dk/W6Ydd94VWCm
         wUXdUBO5iY1A7iJ2MrE71XVbrx/wfdeSOjZ8mEzcDzb1Hjsb04PEKT0R4tRH6jopmYuH
         PrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5nUzBKU2M/FabLNmfTQFOBvFeurdU27+QhGQEVfU4Nk=;
        b=VI+Y8ki2Hf8WZWJoRLba0LmwUueiOzTkRHPrObFreNAjyQbu8V3b2J9epuF8b7sUE+
         /0T4qDKdT8sKD/WXDKSJcDkWEicQhOW3yr9k+HIjkNoaTY/ohfACRAS3Ec1J8NdDscU0
         EgHhz30zelhrIJWSfkVsWldpJXKARG32fWDqFzN6il+EhlscFQKs8sV2uniKnH+Bg0Wu
         E9Jtghez0upqCoLZ9AXqp1KEDzMSl3m3MFA6PAwiwtg8vU4Tau/3Ywh5n+Gm7anczNd2
         f/UNghNcwGLrZ7fktU91Wbc/UwSSVdnmtM5LvBNEGGNWMXmlW72AoGXBktq01rp2izty
         DKhQ==
X-Gm-Message-State: AOAM531iNB1VAzLKPvMNMrBwZrre3/a8z8IoKHwU3S7yfikqApc/aznE
        n4T62fV6r5DDqpikc+2slF0=
X-Google-Smtp-Source: ABdhPJxXNmMhEPNwsC41orzt3wgp40LnEDg+OK8r36XAG0I4YeYJ/rgVUKjFGgDrQGZDvcHwRKrPzQ==
X-Received: by 2002:aa7:db94:0:b0:410:f0e8:c39e with SMTP id u20-20020aa7db94000000b00410f0e8c39emr4351952edt.14.1647522330076;
        Thu, 17 Mar 2022 06:05:30 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id ne42-20020a1709077baa00b006d76251f4e7sm2495560ejc.109.2022.03.17.06.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 06:05:29 -0700 (PDT)
Date:   Thu, 17 Mar 2022 15:05:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 4/5] mv88e6xxx: Offload the flood flag
Message-ID: <20220317130527.h3smbzyqoti3t4ka@skbuf>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-5-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317065031.3830481-5-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 07:50:30AM +0100, Mattias Forsblad wrote:
> Use the port vlan table to restrict ingressing traffic to the
> CPU port if the flood flags are cleared.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---

There is a grave mismatch between what this patch says it does and what
it really does. (=> NACK)

Doing some interpolation from previous commit descriptions, the
intention is to disable flooding from a given port towards the CPU
(which, I mean, is fair enough as a goal).

But:
(a) mv88e6xxx_port_vlan() disables _forwarding_ from port A to port B.
    So this affects not only unknown traffic (the one which is flooded),
    but all traffic
(b) even if br_flood_enabled() is false (meaning that the bridge device
    doesn't want to locally process flooded packets), there is no
    equality sign between this and disabling flooding on the CPU port.
    If the DSA switch is bridged with a foreign (non-DSA) interface, be
    it a tap, a Wi-Fi AP, or a plain Ethernet port, then from the
    switch's perspective, this is no different from a local termination
    flow (packets need to be forwarded to the CPU). Yet from the
    bridge's perspective, it is a forwarding and not a termination flow.
    So you can't _just_ disable CPU flooding/forwarding when the bridge
    doesn't want to locally terminate traffic.

Regarding (b), I've CC'ed Allan Nielsen who held this presentation a few
years ago, and some ideas were able to be materialized in the meantime:
https://www.youtube.com/watch?v=B1HhxEcU7Jg

Regarding (a), have you seen the new dsa_port_manage_cpu_flood() from
the DSA unicast filtering patch series?
https://patchwork.kernel.org/project/netdevbpf/patch/20220302191417.1288145-6-vladimir.oltean@nxp.com/
It is incomplete work in the sense that

(1) it disables CPU flooding only if there isn't any port with IFF_PROMISC,
    but the bridge puts all ports in promiscuous mode. I think we can
    win that battle here, and convince bridge/switchdev maintainers to
    not put offloaded bridge ports (those that call switchdev_bridge_port_offload)
    in promiscuous mode, since it serves no purpose and that actively
    bothers us. At least the way DSA sees this is that unicast filtering
    and promiscuous mode deal with standalone mode. The forwarding plane
    is effectively a different address database and there is no direct
    equivalent to promiscuity there.

(2) Right now DSA calls ->port_bridge_flags() from dsa_port_manage_cpu_flood(),
    i.e. it treats CPU flooding as a purely per-port-egress setting.
    But once I manage to straighten some kinks in DSA's unicast
    filtering support for switches with ds->vlan_filtering_is_global (in
    other words, make sja1105 eligible for unicast filtering), I pretty
    much plan to change this by making DSA ask the driver to manage CPU
    flooding per user port - leaving this code path as just a fallback.

As baroque as I consider the sja1105 hardware to be, I'm surprised it
has a feature which mv88e6xxx doesn't seem to - which is having flood
controls per {ingress port, egress port} pair. So we'll have to
improvise here.

Could you tell me - ok, you remove the CPU port from the port VLAN map -
but if you install host FDB entries as ACL entries (so as to make the
switch generate a TO_CPU packet instead of a FORWARD packet), doesn't
the switch in fact send packets to the CPU even in lack of the CPU
port's membership in the port VLAN table for the bridge port?

If I'm right and it does, then I do see a path forward for this, with
zero user space additions, and working by default. We make the bridge
stop uselessly making offloaded DSA bridge ports promiscuous, then we
make DSA manage CPU flooding by itself - taking promiscuity into account
but also foreign interfaces joining/leaving. Then we make host addresses
be delivered by mv88e6xxx to the CPU as trapped and not forwarded, then
from new the DSA ->port_set_cpu_flood() callback we remove the CPU port
from the port VLAN table.

What do you think?

>  drivers/net/dsa/mv88e6xxx/chip.c | 45 ++++++++++++++++++++++++++++++--
>  1 file changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 84b90fc36c58..39347a05c3a5 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1384,6 +1384,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>  	struct dsa_switch *ds = chip->ds;
>  	struct dsa_switch_tree *dst = ds->dst;
>  	struct dsa_port *dp, *other_dp;
> +	bool flood = true;
>  	bool found = false;
>  	u16 pvlan;
>  
> @@ -1425,6 +1426,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>  
>  	pvlan = 0;
>  
> +	if (dp->bridge)
> +		flood = br_flood_enabled(dp->bridge->dev);
> +
>  	/* Frames from standalone user ports can only egress on the
>  	 * upstream port.
>  	 */
> @@ -1433,10 +1437,11 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>  
>  	/* Frames from bridged user ports can egress any local DSA
>  	 * links and CPU ports, as well as any local member of their
> -	 * bridge group.
> +	 * as well as any local member of their bridge group. However, CPU ports
> +	 * are omitted if flood is cleared.
>  	 */
>  	dsa_switch_for_each_port(other_dp, ds)
> -		if (other_dp->type == DSA_PORT_TYPE_CPU ||
> +		if ((other_dp->type == DSA_PORT_TYPE_CPU && flood) ||
>  		    other_dp->type == DSA_PORT_TYPE_DSA ||
>  		    dsa_port_bridge_same(dp, other_dp))
>  			pvlan |= BIT(other_dp->index);
> @@ -2718,6 +2723,41 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
>  	mv88e6xxx_reg_unlock(chip);
>  }
>  
> +static int mv88e6xxx_set_flood(struct dsa_switch *ds, int port, struct net_device *br,
> +			       unsigned long mask, unsigned long val)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct dsa_bridge *bridge;
> +	struct dsa_port *dp;
> +	bool found = false;
> +	int err;
> +
> +	if (!netif_is_bridge_master(br))
> +		return 0;
> +
> +	list_for_each_entry(dp, &ds->dst->ports, list) {
> +		if (dp->ds == ds && dp->index == port) {
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	if (!found)
> +		return 0;
> +
> +	bridge = dp->bridge;
> +	if (!bridge)
> +		return 0;
> +
> +	mv88e6xxx_reg_lock(chip);
> +
> +	err = mv88e6xxx_bridge_map(chip, *bridge);
> +
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
>  static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
>  {
>  	if (chip->info->ops->reset)
> @@ -6478,6 +6518,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
>  	.set_eeprom		= mv88e6xxx_set_eeprom,
>  	.get_regs_len		= mv88e6xxx_get_regs_len,
>  	.get_regs		= mv88e6xxx_get_regs,
> +	.set_flood		= mv88e6xxx_set_flood,
>  	.get_rxnfc		= mv88e6xxx_get_rxnfc,
>  	.set_rxnfc		= mv88e6xxx_set_rxnfc,
>  	.set_ageing_time	= mv88e6xxx_set_ageing_time,
> -- 
> 2.25.1
> 
