Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796053FB244
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 10:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbhH3INv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 04:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbhH3INu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 04:13:50 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57479C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 01:12:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t15so14950694wrg.7
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 01:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dYnI2gh4nOhoIOI0t1b+ysthv5drQUzE+EIShYXpAYk=;
        b=dGPpCkSN/LFk4uuHEpMN7MP7Fw++w4ehZzUoaDprB7oDBW6f/AoooV6hboYH1dgoAC
         F+Gh1L+yEduVYlg217PdhxcLONh+8Qnlc1ev8aODfWX/HV0IwUk8jRw85fXhWzCR4UQ1
         cAogm0QmpMslQYFHhK5MUSvfK8ZiKSMkRa75ea/npaiF1TeJ/0JhLXk3kI1ZOqn0GFSV
         qv3RKuTkKVz/zVjgAjCjEWh/LEsWxV29nBbhGwVDZpZRXqDIRYjiDBng7Oy6QcICMdx0
         bXGQkx1FggAE+4kaUtGsD9hsw2Ex79rLOdKXeakr1y8Z1CA8wAHEIFJdViiWJwRWUxwk
         r3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dYnI2gh4nOhoIOI0t1b+ysthv5drQUzE+EIShYXpAYk=;
        b=gVOsx9phdvlQ2J9E+6gErFifh8DLdz18dMUuxHO2FFE+LiqaX7mSsDhYEvPO2qhjXH
         KA9PqMGMbtMRNvcysclpA+l63Mge08WCEPWjG3AN0dQvNLbfYy0ODj/aaOJgDabkEuEQ
         GBmo01bwTPAZfKYWkXi9gITYmRBqMYAL0LISV8rtvclXODtY7L9qec+IUYrkPjH8g5tK
         7J7R4Ap4oLLSJl2+rqRMyee9JkV00mmTHkU6nnlgiKVRL+fYLymIwtevjqQo4ucHAUj2
         iuPCZVXMr1nv8SaCEfpgKkCQcDIkI+ApF4193l4yPFGf4Lq3Az/7NifQM1sQwStstHqz
         R/Hg==
X-Gm-Message-State: AOAM531eKZN7AkeeA3K1u3qsDS3oBUSQg//IvYqgPdtG5uxDPfPO4Vcd
        kiUh90Iw/F4WXVJx8CIFpk4=
X-Google-Smtp-Source: ABdhPJz7VFsvLcIH2rzft8IwetzHrh9MtoeJ228B2yanq00mTLcL5W68QcekOb9GAE4ATHUeUxC1fQ==
X-Received: by 2002:a05:6000:1244:: with SMTP id j4mr9622657wrx.335.1630311175876;
        Mon, 30 Aug 2021 01:12:55 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id q11sm19121026wmc.41.2021.08.30.01.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 01:12:55 -0700 (PDT)
Date:   Mon, 30 Aug 2021 11:12:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rtl8366rb: support bridge
 offloading
Message-ID: <20210830081254.osqvwld7w7jk7jap@skbuf>
References: <20210829002601.282521-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210829002601.282521-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 02:26:00AM +0200, Linus Walleij wrote:
> From: DENG Qingfang <dqfext@gmail.com>
> 
> Use port isolation registers to configure bridge offloading.
> 
> Tested on the D-Link DIR-685, switching between ports and
> sniffing ports to make sure no packets leak.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/net/dsa/rtl8366rb.c | 84 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 84 insertions(+)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index a89093bc6c6a..14939188c108 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -300,6 +300,12 @@
>  #define RTL8366RB_INTERRUPT_STATUS_REG	0x0442
>  #define RTL8366RB_NUM_INTERRUPT		14 /* 0..13 */
>  
> +/* Port isolation registers */
> +#define RTL8366RB_PORT_ISO_BASE		0x0F08
> +#define RTL8366RB_PORT_ISO(pnum)	(RTL8366RB_PORT_ISO_BASE + (pnum))
> +#define RTL8366RB_PORT_ISO_EN		BIT(0)
> +#define RTL8366RB_PORT_ISO_PORTS_MASK	GENMASK(7, 1)

If RTL8366RB_NUM_PORTS is 6, then why is RTL8366RB_PORT_ISO_PORTS_MASK a
7-bit field?

> +
>  /* bits 0..5 enable force when cleared */
>  #define RTL8366RB_MAC_FORCE_CTRL_REG	0x0F11
>  
> @@ -835,6 +841,21 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> +	/* Isolate all user ports so only the CPU port can access them */
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
> +				   RTL8366RB_PORT_ISO_EN |
> +				   BIT(RTL8366RB_PORT_NUM_CPU + 1));

The shifting due to RTL8366RB_PORT_ISO_EN looks weird, I can see it
being mishandled in the future, with code moved around, copied and
pasted between realtek drivers and such. How about making a macro

#define RTL8366RB_PORT_ISO_PORTS(x)	((x) << 1)

> +		if (ret)
> +			return ret;
> +	}
> +	/* CPU port can access all ports */

Except itself maybe? RTL8366RB_PORT_NUM_CPU is 5, so maybe use something
like

RTL8366RB_PORT_ISO_PORTS(dsa_user_ports(ds))

> +	ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(RTL8366RB_PORT_NUM_CPU),
> +			   RTL8366RB_PORT_ISO_PORTS_MASK |
> +			   RTL8366RB_PORT_ISO_EN);
> +	if (ret)
> +		return ret;
> +
>  	/* Set up the "green ethernet" feature */
>  	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
>  				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
> @@ -1127,6 +1148,67 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
>  	rb8366rb_set_port_led(smi, port, false);
>  }
>  
> +static int
> +rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
> +			   struct net_device *bridge)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	unsigned int port_bitmap = 0;
> +	int ret, i;
> +
> +	/* Loop over all other ports than this one */
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		/* Handled last */
> +		if (i == port)
> +			continue;
> +		/* Not on this bridge */
> +		if (dsa_to_port(ds, i)->bridge_dev != bridge)
> +			continue;
> +		/* Join this port to each other port on the bridge */
> +		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
> +					 BIT(port + 1), BIT(port + 1));
> +		if (ret)
> +			return ret;
> +
> +		port_bitmap |= BIT(i);
> +	}
> +
> +	/* Set the bits for the ports we can access */
> +	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
> +				  RTL8366RB_PORT_ISO_PORTS_MASK,
> +				  port_bitmap << 1);
> +}
> +
> +static void
> +rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
> +			    struct net_device *bridge)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	unsigned int port_bitmap = 0;
> +	int ret, i;
> +
> +	/* Loop over all other ports than this one */
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		/* Handled last */
> +		if (i == port)
> +			continue;
> +		/* Not on this bridge */
> +		if (dsa_to_port(ds, i)->bridge_dev != bridge)
> +			continue;
> +		/* Remove this port from any other port on the bridge */
> +		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
> +					 BIT(port + 1), 0);
> +		if (ret)
> +			return;
> +
> +		port_bitmap |= BIT(i);
> +	}
> +
> +	/* Clear the bits for the ports we can access */
> +	regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
> +			   port_bitmap << 1, 0);
> +}
> +
>  static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  {
>  	struct realtek_smi *smi = ds->priv;
> @@ -1510,6 +1592,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
>  	.get_strings = rtl8366_get_strings,
>  	.get_ethtool_stats = rtl8366_get_ethtool_stats,
>  	.get_sset_count = rtl8366_get_sset_count,
> +	.port_bridge_join = rtl8366rb_port_bridge_join,
> +	.port_bridge_leave = rtl8366rb_port_bridge_leave,
>  	.port_vlan_filtering = rtl8366_vlan_filtering,
>  	.port_vlan_add = rtl8366_vlan_add,
>  	.port_vlan_del = rtl8366_vlan_del,
> -- 
> 2.31.1
> 

Looks okay for the most part. It is to be expected for a new driver that
introduces bridging offload to also handle .port_pre_bridge_flags,
.port_bridge_flags and .port_fast_age, for two reasons:
(a) it is expected that a port which does not offload the bridge, and
    performs forwarding in software, to not perform address learning in
    hardware
(b) it is expected that the addresses learned while the port was under a
    bridge are not carried over into its life as a standalone port, when
    it leaves that bridge

Also, it would be nice if you could do some minimal isolation at the
level of the FDB lookup. Currently, if I am not mistaken, a port will
perform FDB lookup even if it is standalone, and it might find an FDB
entry for a given {MAC DA, VLAN ID} pair that belongs to a port outside
of its isolation mask, so forwarding will be blocked and that packet
will be dropped (instead of the expected behavior which is for that
packet to be forwarded to the CPU).

Normally the expectation is that this FDB-level isolation can be achieved
by configuring the VLANs of one bridge to use a filter ID that is
different from the VLANs of another bridge, and the port-based default
VLAN of standalone ports to use yet another filter ID. This is yet
another reason to disable learning on standalone ports, so that their
filter ID never contains any FDB entry, and packets are always flooded
to their only possible destination, the CPU port.

Currently in DSA we do not offer a streamlined way for you to determine
what filter ID to use for a certain VLAN belonging to a certain bridge,
but at the very least you can test FDB isolation between standalone
ports and bridged ports. The simplest way to do that, assuming you
already have a forwarding setup with 2 switch ports swp0 and swp1, is to
enable CONFIG_BONDING=y, and then:

ip link add br0 type bridge
ip link set bond0 master br0
ip link set swp1 master bond0
ip link set swp0 master br0

Then ping between station A attached to swp0 and station B attached to
swp1.

Because swp1 cannot offload bond0, it will fall back to software
forwarding and act as standalone, i.e. what you had up till now.
With hardware address learning enabled on swp0 (a port that offloads
br0), it will learn station A's source MAC address. Then when swp1 needs
to send a packet to station A's destination MAC address, it would be
tempted to look up the FDB, find that address, and forward to swp0. But
swp0 is isolated from swp1. If you use a filter ID for standalone ports
and another filter ID for bridged ports you will avoid that problem, and
you will also lay the groundwork for the full FDB isolation even between
bridges that will be coming during the next development cycle.

If you feel that the second part is too much for now, you can just add
the extra callbacks for address learning and flushing (although I do
have some genuine concerns about how reliable was the software forwarding
with this driver, seeing that right now it enables hardware learning
unconditionally). Is there something that isolates FDB lookups already?
