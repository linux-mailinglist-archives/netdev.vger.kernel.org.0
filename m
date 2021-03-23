Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7050D34559B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 03:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCWCk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 22:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhCWCkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 22:40:31 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3AFC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 19:40:31 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y200so12729423pfb.5
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 19:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=41D7FocbNXduBAgsjZdDAvvQjJUeqlF2UMhKKrxUxr0=;
        b=C2YXnlaDgFbk6aZ/6THVYOrXQLhprm306FiEzDpTD6DitaAxSrmRKhCijbzDUrBIK/
         L7io4gHuSVHWj8qBOcf9aw5c0lGSVt6B/6X6z4e1KO6pQKR7YU+JeIyaqfJnS5T1KiIL
         E91P0tYkAuGLqusAH3eialeRyrIkVR8Fy6rENDzP8W/mX64tvZvrP554OHM3XS552IWX
         TxrMePvGam7WGQ449k6xJe02omwliYyU3TFxZhLHv2B9mIoqojF7CjFD4lRcPQ3DfaAj
         SJYZ8no2Lwo0Gvq+Z9Tq6ofI2pUtNrOXKGjn6yEau97SZeTm4imAPYLB+6ZtStSUKKu9
         +X9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=41D7FocbNXduBAgsjZdDAvvQjJUeqlF2UMhKKrxUxr0=;
        b=exLD7VtsEoMzGy1NSL5/mV7BVtMzqQ2B3oZYIS2FV0Y+Jo8w0I+5TyXQQ29tdfqxyh
         OP/uh953e186H/OuV8uV2+vYDDphnhZ1xGE5xI9IpTpCdfuRdKPPrRnzX2tQY0HRKyid
         tjTByQ83aot9oD1fEV7e3R50dSNKrDabtYP3e5mcxc4MNaRizvgD1377JS/+2grGugjk
         SCvkxQy0Lv+gzqaXpX9pAL4KRlI3jdWFYmXzga2Dd8lul63/OTstwD95Rt+tMMdcvkah
         TLITX99k2zOII0FwkjxbpUmA9bkxLbWOALtHIBG5dtpMcgcv8njirhB3mkDVep6UoVI9
         +mGQ==
X-Gm-Message-State: AOAM533rmZM4PWdsvaUq8C7NYt3XxBX3EY9xprsrFsEpzm9TJCowrorv
        H6kJRiWgzN/SvYgFkaCQhSP9vSovXiM=
X-Google-Smtp-Source: ABdhPJxrxyjzZ3utoUJGerptX8FFfwqsHvgmbKYlw8QvjqgE3UluXQlPECnvFo/OgkAt4mcv1CGERg==
X-Received: by 2002:a17:902:108:b029:e5:bcac:fa42 with SMTP id 8-20020a1709020108b02900e5bcacfa42mr2634271plb.49.1616467230510;
        Mon, 22 Mar 2021 19:40:30 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d24sm670968pjw.37.2021.03.22.19.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 19:40:30 -0700 (PDT)
Subject: Re: [PATCH v2 net 2/3] net: dsa: don't advertise 'rx-vlan-filter' if
 VLAN filtering not global
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210320225928.2481575-1-olteanv@gmail.com>
 <20210320225928.2481575-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d4bb95df-9395-168f-f6e8-33ae620fed8f@gmail.com>
Date:   Mon, 22 Mar 2021 19:40:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210320225928.2481575-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/20/2021 3:59 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The blamed patch has removed the driver's ability to return -EOPNOTSUPP
> in the .port_vlan_add method when called from .ndo_vlan_rx_add_vid
> (unmassaged by DSA, -EOPNOTSUPP is a hard error for vlan_vid_add).
> But we have not managed well enough the cases under which .port_vlan_add
> is called in the first place, as will be explained below. This was
> reported as a problem by Tobias because mv88e6xxx_port_vlan_prepare is
> stubborn and only accepts VLANs on bridged ports. That is understandably
> so, because standalone mv88e6xxx ports are VLAN-unaware, and VTU entries
> are said to be a scarce resource.
> 
> Otherwise said, the following fails lamentably on mv88e6xxx:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link set lan3 master br0
> ip link add link lan10 name lan10.1 type vlan id 1
> [485256.724147] mv88e6085 d0032004.mdio-mii:12: p10: hw VLAN 1 already used by port 3 in br0
> RTNETLINK answers: Operation not supported
> 
> We need to step back and explain that the dsa_slave_vlan_rx_add_vid and
> dsa_slave_vlan_rx_kill_vid methods exist for drivers that need the
> 'rx-vlan-filter: on' feature in ethtool -k, which can be due to any of
> the following reasons:
> 
> 1. vlan_filtering_is_global = true, and some ports are under a
>    VLAN-aware bridge while others are standalone, and the standalone
>    ports would otherwise drop VLAN-tagged traffic. This is described in
>    commit 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid
>    implementation").
> 
> 2. the ports that are under a VLAN-aware bridge should also set this
>    feature, for 8021q uppers having a VID not claimed by the bridge.
>    In this case, the driver will essentially not even know that the VID
>    is coming from the 8021q layer and not the bridge.
> 
> 3. Hellcreek. This driver needs it because in standalone mode, it uses
>    unique VLANs per port to ensure separation. For separation of untagged
>    traffic, it uses different PVIDs for each port, and for separation of
>    VLAN-tagged traffic, it never accepts 8021q uppers with the same vid
>    on two ports.
> 
> If a driver does not fall under any of the above 3 categories, there is
> no reason why it should advertise the 'rx-vlan-filter' feature, therefore
> no reason why it should offload the VLANs added through vlan_vid_add.
> 
> This commit fixes the problem by removing the 'rx-vlan-filter' feature
> from the slave devices when they operate in standalone mode, and when
> they offload a VLAN-unaware bridge. This gives the mv88e6xxx driver what
> it wants, since it keeps the 8021q VLANs away from the VTU until VLAN
> awareness is enabled (point at which the ports are no longer standalone,
> hence the check in mv88e6xxx_port_vlan_prepare passes). And since the
> issue predates the existence of the hellcreek driver, case 3 will be
> dealt with in a separate patch.
> 
> The commit also has the nice side effect that we no longer lie to the
> network stack about our VLAN filtering status.
> 
> Because the 'rx-vlan-filter' feature is now dynamically toggled, and our
> .ndo_vlan_rx_add_vid does not get called when 'rx-vlan-filter' is off,
> we need to avoid bugs such as the following by replaying the VLANs from
> 8021q uppers every time we enable VLAN filtering:
> 
> ip link add link lan0 name lan0.100 type vlan id 100
> ip addr add 192.168.100.1/24 dev lan0.100
> ping 192.168.100.2 # should work
> ip link add br0 type bridge vlan_filtering 0
> ip link set lan0 master br0
> ping 192.168.100.2 # should still work
> ip link set br0 type bridge vlan_filtering 1
> ping 192.168.100.2 # should still work but doesn't

That example seems to work well but see caveat below.

# ip link add link gphy name gphy.42 type vlan id 42
# ip addr add 192.168.42.1/24 dev gphy.42
# ping -c 1 192.168.42.254
PING 192.168.42.254 (192.168.42.254): 56 data bytes
64 bytes from 192.168.42.254: seq=0 ttl=64 time=1.473 ms

--- 192.168.42.254 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 1.473/1.473/1.473 ms
# ip link add br0 type bridge vlan_filtering 0
# ip link set br0 up
# ip addr flush dev gphy
# ip link set gphy master br0
[  102.184169] br0: port 1(gphy) entered blocking state
[  102.189533] br0: port 1(gphy) entered disabled state
[  102.196039] device gphy entered promiscuous mode
[  102.200831] device eth0 entered promiscuous mode
[  102.206781] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1,
filtering: 0
[  102.214684] brcm-sf2 8f00000.ethernet_switch: VID: 1, members:
0x0001, untag: 0x0001
[  102.228912] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1,
filtering: 0
[  102.236736] brcm-sf2 8f00000.ethernet_switch: VID: 1, members:
0x0101, untag: 0x0001
[  102.248062] br0: port 1(gphy) entered blocking state
[  102.253210] br0: port 1(gphy) entered forwarding state
# udhcpc -i br0
udhcpc: started, v1.32.0
udhcpc: sending discover
udhcpc: sending select for 192.168.1.10
udhcpc: lease of 192.168.1.10 obtained, lease time 600
deleting routers
adding dns 192.168.1.254
# ping 192.168.42.254
PING 192.168.42.254 (192.168.42.254): 56 data bytes
64 bytes from 192.168.42.254: seq=0 ttl=64 time=1.294 ms
64 bytes from 192.168.42.254: seq=1 ttl=64 time=0.884 ms
^C
--- 192.168.42.254 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.884/1.089/1.294 ms
# ip link set br0 type bridge vlan_filtering 1
[  116.072754] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1,
filtering: 1
[  116.080522] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1,
filtering: 0
[  116.088211] brcm-sf2 8f00000.ethernet_switch: VID: 42, members:
0x0001, untag: 0x0000
[  116.098696] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1,
filtering: 0
[  116.106474] brcm-sf2 8f00000.ethernet_switch: VID: 42, members:
0x0101, untag: 0x0000
# ping 192.168.42.254
PING 192.168.42.254 (192.168.42.254): 56 data bytes
64 bytes from 192.168.42.254: seq=0 ttl=64 time=0.751 ms
64 bytes from 192.168.42.254: seq=1 ttl=64 time=0.700 ms
^C
--- 192.168.42.254 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.700/0.725/0.751 ms
# ping 192.168.1.254
PING 192.168.1.254 (192.168.1.254): 56 data bytes
64 bytes from 192.168.1.254: seq=0 ttl=64 time=0.713 ms
64 bytes from 192.168.1.254: seq=1 ttl=64 time=0.916 ms
64 bytes from 192.168.1.254: seq=2 ttl=64 time=0.631 ms
^C
--- 192.168.1.254 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.631/0.753/0.916 ms

But you will notice that vlan filtering was not enabled at the switch
level for a reason I do not fully understand, or rather there were
multiple calls to port_vlan_filtering with vlan_filtering = 0 for the
same port.

Now if we have a nother port that is a member of a bridge that was
created with vlan_filtering=1 from the get go, the standalone ports are
not working if they are created before the bridge is:

# ip link add link gphy name gphy.42 type vlan id 42
# ip addr add 192.168.42.1/24 dev gphy.42
# ping -c 1 192.168.42.254
PING 192.168.42.254 (192.168.42.254): 56 data bytes
64 bytes from 192.168.42.254: seq=0 ttl=64 time=1.129 ms

--- 192.168.42.254 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 1.129/1.129/1.129 ms
# ip link add br0 type bridge vlan_filtering 1
# ip link set rgmii_1 master br0
[   86.835014] br0: port 1(rgmii_1) entered blocking state
[   86.840622] br0: port 1(rgmii_1) entered disabled state
[   86.848084] device rgmii_1 entered promiscuous mode
[   86.853153] device eth0 entered promiscuous mode
[   86.858308] brcm-sf2 8f00000.ethernet_switch: Port 1 VLAN enabled: 1,
filtering: 1
[   86.866157] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1,
filtering: 0
[   86.873985] brcm-sf2 8f00000.ethernet_switch: VID: 42, members:
0x0001, untag: 0x0000
[   86.884946] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1,
filtering: 0
[   86.892879] brcm-sf2 8f00000.ethernet_switch: VID: 42, members:
0x0101, untag: 0x0000
[   86.904274] brcm-sf2 8f00000.ethernet_switch: Port 1 VLAN enabled: 1,
filtering: 1
[   86.912097] brcm-sf2 8f00000.ethernet_switch: VID: 1, members:
0x0002, untag: 0x0002
[   86.925899] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1,
filtering: 1
[   86.933806] brcm-sf2 8f00000.ethernet_switch: VID: 1, members:
0x0102, untag: 0x0002
# ip link set br0 up
[   89.775094] br0: port 1(rgmii_1) entered blocking state
[   89.780694] br0: port 1(rgmii_1) entered forwarding state
# ip addr add 192.168.4.10/24 dev br0
# ping 192.168.4.254
PING 192.168.4.254 (192.168.4.254): 56 data bytes
64 bytes from 192.168.4.254: seq=0 ttl=64 time=1.693 ms
^C
--- 192.168.4.254 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 1.693/1.693/1.693 ms
# ping 192.168.42.254
PING 192.168.42.254 (192.168.42.254): 56 data bytes
^C
--- 192.168.42.254 ping statistics ---
2 packets transmitted, 0 packets received, 100% packet loss
# ping 192.168.1.254
PING 192.168.1.254 (192.168.1.254): 56 data bytes
^C
--- 192.168.1.254 ping statistics ---
1 packets transmitted, 0 packets received, 100% packet loss
#

Both scenarios work correctly as of net/master prior to this patch series.

> 
> Fixes: 9b236d2a69da ("net: dsa: Advertise the VLAN offload netdev ability only if switch supports it")
> Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/dsa_priv.h |  2 ++
>  net/dsa/port.c     | 37 +++++++++++++++++++++++++++--
>  net/dsa/slave.c    | 58 ++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 93 insertions(+), 4 deletions(-)
> 
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 4c43c5406834..d7dd9e07d168 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -269,6 +269,8 @@ int dsa_slave_register_notifier(void);
>  void dsa_slave_unregister_notifier(void);
>  void dsa_slave_setup_tagger(struct net_device *slave);
>  int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
> +int dsa_slave_manage_vlan_filtering(struct net_device *dev,
> +				    bool vlan_filtering);
>  
>  static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
>  {
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index c9c6d7ab3f47..902095f04e0a 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -363,6 +363,7 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
>  int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>  			    struct netlink_ext_ack *extack)
>  {
> +	bool old_vlan_filtering = dsa_port_is_vlan_filtering(dp);
>  	struct dsa_switch *ds = dp->ds;
>  	bool apply;
>  	int err;
> @@ -388,12 +389,44 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>  	if (err)
>  		return err;
>  
> -	if (ds->vlan_filtering_is_global)
> +	if (ds->vlan_filtering_is_global) {
> +		int port;
> +
> +		for (port = 0; port < ds->num_ports; port++) {
> +			struct net_device *slave;
> +
> +			if (!dsa_is_user_port(ds, port))
> +				continue;
> +
> +			/* We might be called in the unbind path, so not
> +			 * all slave devices might still be registered.
> +			 */
> +			slave = dsa_to_port(ds, port)->slave;
> +			if (!slave)
> +				continue;
> +
> +			err = dsa_slave_manage_vlan_filtering(slave,
> +							      vlan_filtering);
> +			if (err)
> +				goto restore;
> +		}
> +
>  		ds->vlan_filtering = vlan_filtering;
> -	else
> +	} else {
> +		err = dsa_slave_manage_vlan_filtering(dp->slave,
> +						      vlan_filtering);
> +		if (err)
> +			goto restore;
> +
>  		dp->vlan_filtering = vlan_filtering;
> +	}
>  
>  	return 0;
> +
> +restore:
> +	ds->ops->port_vlan_filtering(ds, dp->index, old_vlan_filtering, NULL);
> +
> +	return err;
>  }
>  
>  /* This enforces legacy behavior for switch drivers which assume they can't
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 992fcab4b552..6d06d13cdf3a 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1387,6 +1387,62 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>  	return 0;
>  }
>  
> +static int dsa_slave_restore_vlan(struct net_device *vdev, int vid, void *arg)
> +{
> +	__be16 proto = vdev ? vlan_dev_vlan_proto(vdev) : htons(ETH_P_8021Q);
> +
> +	return dsa_slave_vlan_rx_add_vid(arg, proto, vid);
> +}
> +
> +static int dsa_slave_clear_vlan(struct net_device *vdev, int vid, void *arg)
> +{
> +	__be16 proto = vdev ? vlan_dev_vlan_proto(vdev) : htons(ETH_P_8021Q);
> +
> +	return dsa_slave_vlan_rx_kill_vid(arg, proto, vid);
> +}
> +
> +/* Keep the VLAN RX filtering list in sync with the hardware only if VLAN
> + * filtering is enabled.
> + *
> + * - Standalone ports offload:
> + *   - no VLAN (any 8021q upper is a software VLAN) if
> + *     ds->vlan_filtering_is_global = false
> + *   - the 8021q upper VLANs if ds->vlan_filtering_is_global = true and there
> + *     are bridges spanning this switch chip which have vlan_filtering=1
> + *
> + * - Ports under a vlan_filtering=0 bridge offload:
> + *   - no VLAN if ds->configure_vlan_while_not_filtering = false (deprecated)
> + *   - the bridge VLANs if ds->configure_vlan_while_not_filtering = true
> + *
> + * - Ports under a vlan_filtering=1 bridge offload:
> + *   - the bridge VLANs
> + *   - the 8021q upper VLANs
> + */
> +int dsa_slave_manage_vlan_filtering(struct net_device *slave,
> +				    bool vlan_filtering)
> +{
> +	int err;
> +
> +	if (vlan_filtering) {
> +		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> +
> +		err = vlan_for_each(slave, dsa_slave_restore_vlan, slave);
> +		if (err) {
> +			vlan_for_each(slave, dsa_slave_clear_vlan, slave);
> +			slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
> +			return err;
> +		}
> +	} else {
> +		err = vlan_for_each(slave, dsa_slave_clear_vlan, slave);
> +		if (err)
> +			return err;
> +
> +		slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
> +	}
> +
> +	return 0;
> +}
> +
>  struct dsa_hw_port {
>  	struct list_head list;
>  	struct net_device *dev;
> @@ -1857,8 +1913,6 @@ int dsa_slave_create(struct dsa_port *port)
>  		return -ENOMEM;
>  
>  	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
> -	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
> -		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
>  	slave_dev->hw_features |= NETIF_F_HW_TC;
>  	slave_dev->features |= NETIF_F_LLTX;
>  	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
> 

-- 
Florian
