Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3235233D2F4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhCPLZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhCPLYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:40 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58320C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:39 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y6so20992010eds.1
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eg9THuLsg7vrGGYOXORia/rek6lJG57hpLgitqjmlMs=;
        b=QNpaNVeJdIHrKEcpog8kl9gRt0oCzq72F03ueRayfHXL+u/8GerU2WIrZbDS8tT4RC
         ARTWl0QDoYb4wDkD7tXdG+pruGVv+X9r2VvQm74k3GBP4b/taGcX/TQZlWBVSWFstU9a
         3D+Iud3etqlIjfXaN70Wea3aFScTOjfUVg3XBbiTxElNLq7qNr+eVX6gO1EOdmZjW33q
         FvIpNXSbYFe6fz2h48fik2Pwgx8qf+FQtSgzxRMOuJNPZwKHTYgUQBOe2PNU9wCmQ4yu
         cDBJksZP7nN2c4DCQkR6SPMYM555Jf+GCfpdeR9YDfunAKbksqEVW4ovuryiW++cTDqt
         y24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eg9THuLsg7vrGGYOXORia/rek6lJG57hpLgitqjmlMs=;
        b=hqBSwEffp6zASXueDXrq+fkfC+f006dUgQOHgBrK2+16GmfuCQzTyhqnlpZGuCxKxu
         D6fCUwM8vJSREpeFLAwFlNVp8I0V7nSXr9JXaaKbKVOQtGMR7fZzUoyAkCR0llWN3Msq
         2RnKUe0YRGAtNW7BAkCuwYKXUtdoRgyRTRAGNwrEPdZUKFiF/li6Q5jc2J4iyGOwXnyd
         xSb2ESq0L63UR0pEzVeVxk6RWxuzaz87UXfJ3WFklzAY07sO2B5CXsOS9XbzoQThzG6N
         4jtfpGS84p7DC3QZzHUjJV/qaA81Jp/7yOgFKUDJszlWoxwabG+rl8JDCRH46OFudXnp
         Wy8Q==
X-Gm-Message-State: AOAM530FoK/lRKLrYtsnwYKfQwOR2hugQvcilQzd4RzW2pyGVvxyo/Af
        YjsvkDsAPNInXozeR+qEaL1275Q19g4=
X-Google-Smtp-Source: ABdhPJx6RfP+k8p1rxC3su7sV03apRM9lGDJgCeFDILs4TN8ahhO5o0egUCSzgf17el48a83Kbw6MA==
X-Received: by 2002:a05:6402:51cd:: with SMTP id r13mr35752100edd.116.1615893877735;
        Tue, 16 Mar 2021 04:24:37 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 11/12] Documentation: networking: switchdev: clarify device driver behavior
Date:   Tue, 16 Mar 2021 13:24:18 +0200
Message-Id: <20210316112419.1304230-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

This patch provides details on the expected behavior of switchdev
enabled network devices when operating in a "stand alone" mode, as well
as when being bridge members. This clarifies a number of things that
recently came up during a bug fixing session on the b53 DSA switch
driver.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/switchdev.rst | 152 +++++++++++++++++++++++++
 1 file changed, 152 insertions(+)

diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
index ddc3f35775dc..016531a3d471 100644
--- a/Documentation/networking/switchdev.rst
+++ b/Documentation/networking/switchdev.rst
@@ -385,3 +385,155 @@ The driver can monitor for updates to arp_tbl using the netevent notifier
 NETEVENT_NEIGH_UPDATE.  The device can be programmed with resolved nexthops
 for the routes as arp_tbl updates.  The driver implements ndo_neigh_destroy
 to know when arp_tbl neighbor entries are purged from the port.
+
+Device driver expected behavior
+-------------------------------
+
+Below is a set of defined behavior that switchdev enabled network devices must
+adhere to.
+
+Configuration-less state
+^^^^^^^^^^^^^^^^^^^^^^^^
+
+Upon driver bring up, the network devices must be fully operational, and the
+backing driver must configure the network device such that it is possible to
+send and receive traffic to this network device and it is properly separated
+from other network devices/ports (e.g.: as is frequent with a switch ASIC). How
+this is achieved is heavily hardware dependent, but a simple solution can be to
+use per-port VLAN identifiers unless a better mechanism is available
+(proprietary metadata for each network port for instance).
+
+The network device must be capable of running a full IP protocol stack
+including multicast, DHCP, IPv4/6, etc. If necessary, it should program the
+appropriate filters for VLAN, multicast, unicast etc. The underlying device
+driver must effectively be configured in a similar fashion to what it would do
+when IGMP snooping is enabled for IP multicast over these switchdev network
+devices and unsolicited multicast must be filtered as early as possible in
+the hardware.
+
+When configuring VLANs on top of the network device, all VLANs must be working,
+irrespective of the state of other network devices (e.g.: other ports being part
+of a VLAN-aware bridge doing ingress VID checking). See below for details.
+
+If the device implements e.g.: VLAN filtering, putting the interface in
+promiscuous mode should allow the reception of all VLAN tags (including those
+not present in the filter(s)).
+
+Bridged switch ports
+^^^^^^^^^^^^^^^^^^^^
+
+When a switchdev enabled network device is added as a bridge member, it should
+not disrupt any functionality of non-bridged network devices and they
+should continue to behave as normal network devices. Depending on the bridge
+configuration knobs below, the expected behavior is documented.
+
+Bridge VLAN filtering
+^^^^^^^^^^^^^^^^^^^^^
+
+The Linux bridge allows the configuration of a VLAN filtering mode (statically,
+at device creation time, and dynamically, during run time) which must be
+observed by the underlying switchdev network device/hardware:
+
+- with VLAN filtering turned off: the bridge is strictly VLAN unaware and its
+  data path will process all Ethernet frames as if they are VLAN-untagged.
+  The bridge VLAN database can still be modified, but the modifications should
+  have no effect while VLAN filtering is turned off. Frames ingressing the
+  device with a VID that is not programmed into the bridge/switch's VLAN table
+  must be forwarded and may be processed using a VLAN device (see below).
+
+- with VLAN filtering turned on: the bridge is VLAN-aware and frames ingressing
+  the device with a VID that is not programmed into the bridges/switch's VLAN
+  table must be dropped (strict VID checking).
+
+When there is a VLAN device (e.g: sw0p1.100) configured on top of a switchdev
+network device which is a bridge port member, the behavior of the software
+network stack must be preserved, or the configuration must be refused if that
+is not possible.
+
+- with VLAN filtering turned off, the bridge will process all ingress traffic
+  for the port, except for the traffic tagged with a VLAN ID destined for a
+  VLAN upper. The VLAN upper interface (which consumes the VLAN tag) can even
+  be added to a second bridge, which includes other switch ports or software
+  interfaces. Some approaches to ensure that the forwarding domain for traffic
+  belonging to the VLAN upper interfaces are managed properly:
+    * If forwarding destinations can be managed per VLAN, the hardware could be
+      configured to map all traffic, except the packets tagged with a VID
+      belonging to a VLAN upper interface, to an internal VID corresponding to
+      untagged packets. This internal VID spans all ports of the VLAN-unaware
+      bridge. The VID corresponding to the VLAN upper interface spans the
+      physical port of that VLAN interface, as well as the other ports that
+      might be bridged with it.
+    * Treat bridge ports with VLAN upper interfaces as standalone, and let
+      forwarding be handled in the software data path.
+
+- with VLAN filtering turned on, these VLAN devices can be created as long as
+  the bridge does not have an existing VLAN entry with the same VID on any
+  bridge port. These VLAN devices cannot be enslaved into the bridge since they
+  duplicate functionality/use case with the bridge's VLAN data path processing.
+
+Non-bridged network ports of the same switch fabric must not be disturbed in any
+way by the enabling of VLAN filtering on the bridge device(s). If the VLAN
+filtering setting is global to the entire chip, then the standalone ports
+should indicate to the network stack that VLAN filtering is required by setting
+'rx-vlan-filter: on [fixed]' in the ethtool features.
+
+Because VLAN filtering can be turned on/off at runtime, the switchdev driver
+must be able to reconfigure the underlying hardware on the fly to honor the
+toggling of that option and behave appropriately. If that is not possible, the
+switchdev driver can also refuse to support dynamic toggling of the VLAN
+filtering knob at runtime and require a destruction of the bridge device(s) and
+creation of new bridge device(s) with a different VLAN filtering value to
+ensure VLAN awareness is pushed down to the hardware.
+
+Even when VLAN filtering in the bridge is turned off, the underlying switch
+hardware and driver may still configure itself in a VLAN-aware mode provided
+that the behavior described above is observed.
+
+The VLAN protocol of the bridge plays a role in deciding whether a packet is
+treated as tagged or not: a bridge using the 802.1ad protocol must treat both
+VLAN-untagged packets, as well as packets tagged with 802.1Q headers, as
+untagged.
+
+The 802.1p (VID 0) tagged packets must be treated in the same way by the device
+as untagged packets, since the bridge device does not allow the manipulation of
+VID 0 in its database.
+
+When the bridge has VLAN filtering enabled and a PVID is not configured on the
+ingress port, untagged 802.1p tagged packets must be dropped. When the bridge
+has VLAN filtering enabled and a PVID exists on the ingress port, untagged and
+priority-tagged packets must be accepted and forwarded according to the
+bridge's port membership of the PVID VLAN. When the bridge has VLAN filtering
+disabled, the presence/lack of a PVID should not influence the packet
+forwarding decision.
+
+Bridge IGMP snooping
+^^^^^^^^^^^^^^^^^^^^
+
+The Linux bridge allows the configuration of IGMP snooping (statically, at
+interface creation time, or dynamically, during runtime) which must be observed
+by the underlying switchdev network device/hardware in the following way:
+
+- when IGMP snooping is turned off, multicast traffic must be flooded to all
+  ports within the same bridge that have mcast_flood=true. The CPU/management
+  port should ideally not be flooded (unless the ingress interface has
+  IFF_ALLMULTI or IFF_PROMISC) and continue to learn multicast traffic through
+  the network stack notifications. If the hardware is not capable of doing that
+  then the CPU/management port must also be flooded and multicast filtering
+  happens in software.
+
+- when IGMP snooping is turned on, multicast traffic must selectively flow
+  to the appropriate network ports (including CPU/management port). Flooding of
+  unknown multicast should be only towards the ports connected to a multicast
+  router (the local device may also act as a multicast router).
+
+The switch must adhere to RFC 4541 and flood multicast traffic accordingly
+since that is what the Linux bridge implementation does.
+
+Because IGMP snooping can be turned on/off at runtime, the switchdev driver
+must be able to reconfigure the underlying hardware on the fly to honor the
+toggling of that option and behave appropriately.
+
+A switchdev driver can also refuse to support dynamic toggling of the multicast
+snooping knob at runtime and require the destruction of the bridge device(s)
+and creation of a new bridge device(s) with a different multicast snooping
+value.
-- 
2.25.1

