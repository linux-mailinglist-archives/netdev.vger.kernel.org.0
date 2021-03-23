Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8ED345D96
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhCWMDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhCWMD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 08:03:29 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E379C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 05:03:29 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u9so26652592ejj.7
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 05:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EmXyz8vJQeTADGHAF2rGvYF6klw8OyBVF+k96QzGos0=;
        b=t3RQqcFQOxArnESir7PAC9BawE9wvYAqUcQlital9KNKan+5SN94OrfHk5cIVH5+DM
         K62KOiAA68h9Av6tt+oC3enYiisotqB1rUvsLM5Artpow9CTv6GD2Z3EVzQEsyw9hxGi
         0Swe61IWmiy0VhKqV0rc0+DH/TpJrAhw02wkYiyeHSs1C6YPcFXF8JJnMinYRB6q9iuU
         aP5KO2ef9j2WKwXsXczHShJbLEl+Z7OuUcrrPq6SCn51hGrNqtp6ZvSPODbCHJ6uptuL
         QOJBCxRxlohMIbkQap6XSyQVyUrgzDjSb12zQZCRAA+sy8Zw6N73yyP7trpOZrsiujus
         uLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EmXyz8vJQeTADGHAF2rGvYF6klw8OyBVF+k96QzGos0=;
        b=OghC/xS2PGTlTvrAlVTBLY9NPBuZ8n07kbR7OBkZjigNKMfXwszi7GkduWiwXObZjS
         sK5xSuY6KizFhg0UZD/VEBqB+MhV4hfG38mJiFYADgmlHX6EjHpBaVLcd+TJSEzLbdSL
         dPnclGhugfpvofDIhXuT9aJZvzgHtcplbpoVMuVGfDH3lPE8wNfARIXEGz+OTHgSnXmq
         FB8yuAaHtdpEdXXvHQDf4zvnyd6fql1vtRY2gfVVUhStYMFWkxH2VyJ+hSkOSj7/kbSS
         UdfTiOhX1xd4+amd3zxiElqd0wFVzUynmUK8EQBPUDyUWBpooLnXHdIsNQARRtBftBGs
         eGXw==
X-Gm-Message-State: AOAM533+7wnXs3eRWpbqQgdbeDo3NsWiPvwpLYscgwY88x8o6/fOxUPb
        YHBZS6B6e60VSi3rtSC/S7Q=
X-Google-Smtp-Source: ABdhPJxlf4kvVTC0LsrXOOwCNCWkF8OsqWIl0dDLQsF2J1zg+Tq+tLbg6PcwctHPCX5ZqmxxyexOMQ==
X-Received: by 2002:a17:906:5646:: with SMTP id v6mr4793051ejr.126.1616501007353;
        Tue, 23 Mar 2021 05:03:27 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id m14sm12616356edd.63.2021.03.23.05.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 05:03:26 -0700 (PDT)
Date:   Tue, 23 Mar 2021 14:03:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 2/3] net: dsa: don't advertise 'rx-vlan-filter' if
 VLAN filtering not global
Message-ID: <20210323120325.5ghp43xfgg4hifpk@skbuf>
References: <20210320225928.2481575-1-olteanv@gmail.com>
 <20210320225928.2481575-3-olteanv@gmail.com>
 <d4bb95df-9395-168f-f6e8-33ae620fed8f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4bb95df-9395-168f-f6e8-33ae620fed8f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 07:40:27PM -0700, Florian Fainelli wrote:
> On 3/20/2021 3:59 PM, Vladimir Oltean wrote:
> > Because the 'rx-vlan-filter' feature is now dynamically toggled, and our
> > .ndo_vlan_rx_add_vid does not get called when 'rx-vlan-filter' is off,
> > we need to avoid bugs such as the following by replaying the VLANs from
> > 8021q uppers every time we enable VLAN filtering:
> > 
> > ip link add link lan0 name lan0.100 type vlan id 100
> > ip addr add 192.168.100.1/24 dev lan0.100
> > ping 192.168.100.2 # should work
> > ip link add br0 type bridge vlan_filtering 0
> > ip link set lan0 master br0
> > ping 192.168.100.2 # should still work
> > ip link set br0 type bridge vlan_filtering 1
> > ping 192.168.100.2 # should still work but doesn't
> 
> That example seems to work well but see caveat below.
> 
> # ip link add link gphy name gphy.42 type vlan id 42
> # ip addr add 192.168.42.1/24 dev gphy.42
> # ping -c 1 192.168.42.254
> PING 192.168.42.254 (192.168.42.254): 56 data bytes
> 64 bytes from 192.168.42.254: seq=0 ttl=64 time=1.473 ms
> 
> --- 192.168.42.254 ping statistics ---
> 1 packets transmitted, 1 packets received, 0% packet loss
> round-trip min/avg/max = 1.473/1.473/1.473 ms
> # ip link add br0 type bridge vlan_filtering 0
> # ip link set br0 up
> # ip addr flush dev gphy
> # ip link set gphy master br0
> [  102.184169] br0: port 1(gphy) entered blocking state
> [  102.189533] br0: port 1(gphy) entered disabled state
> [  102.196039] device gphy entered promiscuous mode
> [  102.200831] device eth0 entered promiscuous mode
> [  102.206781] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1, filtering: 0
> [  102.214684] brcm-sf2 8f00000.ethernet_switch: VID: 1, members: 0x0001, untag: 0x0001
> [  102.228912] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1, filtering: 0
> [  102.236736] brcm-sf2 8f00000.ethernet_switch: VID: 1, members: 0x0101, untag: 0x0001
> [  102.248062] br0: port 1(gphy) entered blocking state
> [  102.253210] br0: port 1(gphy) entered forwarding state

So far so good, the call path below triggers your print for the user
port and the CPU port:
dsa_switch_vlan_add
-> b53_vlan_add
   -> b53_vlan_prepare
      -> b53_enable_vlan
VLAN 42 is not installed in hardware.

> # udhcpc -i br0
> udhcpc: started, v1.32.0
> udhcpc: sending discover
> udhcpc: sending select for 192.168.1.10
> udhcpc: lease of 192.168.1.10 obtained, lease time 600
> deleting routers
> adding dns 192.168.1.254
> # ping 192.168.42.254
> PING 192.168.42.254 (192.168.42.254): 56 data bytes
> 64 bytes from 192.168.42.254: seq=0 ttl=64 time=1.294 ms
> 64 bytes from 192.168.42.254: seq=1 ttl=64 time=0.884 ms
> ^C
> --- 192.168.42.254 ping statistics ---
> 2 packets transmitted, 2 packets received, 0% packet loss
> round-trip min/avg/max = 0.884/1.089/1.294 ms
> # ip link set br0 type bridge vlan_filtering 1
> [  116.072754] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1, filtering: 1

Again, so far so good:
dsa_port_vlan_filtering
-> b53_vlan_filtering
   -> b53_enable_vlan(dev->vlan_enabled(was true), filtering(is true))

> [  116.080522] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1, filtering: 0

This is where it starts to go downhill. There is a time window inside
dsa_port_vlan_filtering, after we called ds->ops->port_vlan_filtering,
in which we have not yet committed ds->vlan_filtering, yet we still need
to call dsa_slave_manage_vlan_filtering, which may delete or restore
VLANs corresponding to 8021q uppers.

So this happens:
dsa_port_vlan_filtering
-> dsa_slave_manage_vlan_filtering
   -> dsa_slave_restore_vlan
      -> dsa_switch_vlan_add
         -> b53_vlan_add
            -> b53_vlan_prepare
               -> b53_enable_vlan(vlan_enabled(is true), ds->vlan_filtering(is false because it hasn't been committed yet))

I did not take into account the fact that someone might look in
ds->vlan_filtering in port_vlan_add.

> [  116.088211] brcm-sf2 8f00000.ethernet_switch: VID: 42, members: 0x0001, untag: 0x0000
> [  116.098696] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1, filtering: 0
> [  116.106474] brcm-sf2 8f00000.ethernet_switch: VID: 42, members: 0x0101, untag: 0x0000

The VLANs are at least restored as expected, it seems.

> # ping 192.168.42.254
> PING 192.168.42.254 (192.168.42.254): 56 data bytes
> 64 bytes from 192.168.42.254: seq=0 ttl=64 time=0.751 ms
> 64 bytes from 192.168.42.254: seq=1 ttl=64 time=0.700 ms
> ^C
> --- 192.168.42.254 ping statistics ---
> 2 packets transmitted, 2 packets received, 0% packet loss
> round-trip min/avg/max = 0.700/0.725/0.751 ms
> # ping 192.168.1.254
> PING 192.168.1.254 (192.168.1.254): 56 data bytes
> 64 bytes from 192.168.1.254: seq=0 ttl=64 time=0.713 ms
> 64 bytes from 192.168.1.254: seq=1 ttl=64 time=0.916 ms
> 64 bytes from 192.168.1.254: seq=2 ttl=64 time=0.631 ms
> ^C
> --- 192.168.1.254 ping statistics ---
> 3 packets transmitted, 3 packets received, 0% packet loss
> round-trip min/avg/max = 0.631/0.753/0.916 ms
> 
> But you will notice that vlan filtering was not enabled at the switch
> level for a reason I do not fully understand, or rather there were
> multiple calls to port_vlan_filtering with vlan_filtering = 0 for the
> same port.
> 
> Now if we have a nother port that is a member of a bridge that was
> created with vlan_filtering=1 from the get go, the standalone ports are
> not working if they are created before the bridge is:
> 
> # ip link add link gphy name gphy.42 type vlan id 42

VLAN filtering is not enabled, so the VLAN is not installed to hardware,
all ok.

> # ip addr add 192.168.42.1/24 dev gphy.42
> # ping -c 1 192.168.42.254
> PING 192.168.42.254 (192.168.42.254): 56 data bytes
> 64 bytes from 192.168.42.254: seq=0 ttl=64 time=1.129 ms
> 
> --- 192.168.42.254 ping statistics ---
> 1 packets transmitted, 1 packets received, 0% packet loss
> round-trip min/avg/max = 1.129/1.129/1.129 ms
> # ip link add br0 type bridge vlan_filtering 1
> # ip link set rgmii_1 master br0
> [   86.835014] br0: port 1(rgmii_1) entered blocking state
> [   86.840622] br0: port 1(rgmii_1) entered disabled state
> [   86.848084] device rgmii_1 entered promiscuous mode
> [   86.853153] device eth0 entered promiscuous mode
> [   86.858308] brcm-sf2 8f00000.ethernet_switch: Port 1 VLAN enabled: 1, filtering: 1

So far so good, we have this same code path again:

dsa_port_vlan_filtering
-> b53_vlan_filtering
   -> b53_enable_vlan(dev->vlan_enabled(was true), filtering(is true))

> [   86.866157] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1, filtering: 0
> [   86.873985] brcm-sf2 8f00000.ethernet_switch: VID: 42, members: 0x0001, untag: 0x0000
> [   86.884946] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1, filtering: 0
> [   86.892879] brcm-sf2 8f00000.ethernet_switch: VID: 42, members: 0x0101, untag: 0x0000

Again, we have the same code path that calls dsa_slave_manage_vlan_filtering
while ds->vlan_filtering is still uncommitted, and therefore false. The
b53 driver incorrectly saves this value.

> [   86.904274] brcm-sf2 8f00000.ethernet_switch: Port 1 VLAN enabled: 1, filtering: 1
> [   86.912097] brcm-sf2 8f00000.ethernet_switch: VID: 1, members: 0x0002, untag: 0x0002
> [   86.925899] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1, filtering: 1
> [   86.933806] brcm-sf2 8f00000.ethernet_switch: VID: 1, members: 0x0102, untag: 0x0002

And here we have the bridge pvid installed on the user port and the CPU
port. Since ds->vlan_filtering has been committed in the meantime,
b53_vlan_enable was called again and filtering is now enabled.

> # ip link set br0 up
> [   89.775094] br0: port 1(rgmii_1) entered blocking state
> [   89.780694] br0: port 1(rgmii_1) entered forwarding state
> # ip addr add 192.168.4.10/24 dev br0
> # ping 192.168.4.254
> PING 192.168.4.254 (192.168.4.254): 56 data bytes
> 64 bytes from 192.168.4.254: seq=0 ttl=64 time=1.693 ms
> ^C
> --- 192.168.4.254 ping statistics ---
> 1 packets transmitted, 1 packets received, 0% packet loss
> round-trip min/avg/max = 1.693/1.693/1.693 ms

Pinging through the VLAN-aware bridge, which uses VID 1, works, ok.

> # ping 192.168.42.254
> PING 192.168.42.254 (192.168.42.254): 56 data bytes
> ^C
> --- 192.168.42.254 ping statistics ---
> 2 packets transmitted, 0 packets received, 100% packet loss

Pinging through gphy.42 doesn't work, even though VID 42 was added both
to port 8 and to port 0. I don't understand why. I looked at the b53
driver and I don't see any logic that would skip installing a VLAN if
ds->vlan_filtering is false.

> # ping 192.168.1.254
> PING 192.168.1.254 (192.168.1.254): 56 data bytes
> ^C
> --- 192.168.1.254 ping statistics ---
> 1 packets transmitted, 0 packets received, 100% packet loss
> #

Wait a minute, what interface uses the 192.168.1.0/24 subnet in the
second case?

> 
> Both scenarios work correctly as of net/master prior to this patch series.

So I have no complete idea why it fails either. I do believe DSA does
the right things, for the most part.

Would you be so kind to try this fixup patch on top?

-----------------------------[ cut here ]-----------------------------
From ddca5c56fbf74764977df70c5eba88015bb9832f Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 23 Mar 2021 13:56:24 +0200
Subject: [PATCH] net: dsa: commit vlan_filtering before calling
 dsa_slave_manage_vlan_filtering

Some drivers such as b53 look at ds->vlan_filtering in .port_vlan_add.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 902095f04e0a..d291e0495084 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -392,6 +392,8 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 	if (ds->vlan_filtering_is_global) {
 		int port;
 
+		ds->vlan_filtering = vlan_filtering;
+
 		for (port = 0; port < ds->num_ports; port++) {
 			struct net_device *slave;
 
@@ -410,15 +412,13 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			if (err)
 				goto restore;
 		}
-
-		ds->vlan_filtering = vlan_filtering;
 	} else {
+		dp->vlan_filtering = vlan_filtering;
+
 		err = dsa_slave_manage_vlan_filtering(dp->slave,
 						      vlan_filtering);
 		if (err)
 			goto restore;
-
-		dp->vlan_filtering = vlan_filtering;
 	}
 
 	return 0;
@@ -426,6 +426,11 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 restore:
 	ds->ops->port_vlan_filtering(ds, dp->index, old_vlan_filtering, NULL);
 
+	if (ds->vlan_filtering_is_global)
+		ds->vlan_filtering = old_vlan_filtering;
+	else
+		dp->vlan_filtering = old_vlan_filtering;
+
 	return err;
 }
 
-----------------------------[ cut here ]-----------------------------

Although I am much less confident now about submitting this as a bugfix
patch to go to stable trees. But I also kind of dislike the idea that
Tobias' patch (which returns -EOPNOTSUPP in dsa_slave_vlan_rx_add_vid)
only masks the problem and makes issues harder to reproduce.

Tobias, how bad is your problem? Do you mind if we tackle it in net-next?
Also, again, any chance you could make mv88e6xxx not refuse the 8021q
VLAN IDs?
