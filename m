Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDB0320E03
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhBUVh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbhBUVfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:35:40 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE08C061356
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:17 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id lu16so26020980ejb.9
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VWyBnLjrxcoYNbEyrrXUmFWK/GjiLBF50AfbKv+uTK0=;
        b=fHb52hYFaOIc83RrPndwuf/AcWh31gNxbOqrWbsx7cYI1VnF+2hXSQmfyT92Cb69lx
         5GwJU847cJPvPCKksN3Y0iPbJPB0HpRQYqvnG875G2ViXZMSnGZxAOKzeWuXxOVev0Ur
         ZBPYHa5XzHlJHjb9WEMiQYs5zYDtPsIV680XG/r9YZZCQf5+6oL647Kpqm7SuA+IQVNS
         63fquyN2qm4xy0a0hQ0nMUp2DX1aZpWvzgmxbndAt3pZKdQsdGFjZpDvGduMDfCpW97P
         JzR5+SjydXVqUjD3KOLj+zx14oUJ4zDHF5+1x0TVGM0WdVkQON8XBf/x5GsBZn2NoJUm
         +KSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VWyBnLjrxcoYNbEyrrXUmFWK/GjiLBF50AfbKv+uTK0=;
        b=gFxW8vsr9vN3llX0GQauL02qZ+mbw9b+bMqZQp9vHExXhRGg3G89h2XZh8cPe2C+C6
         TL8xP10LMfcCIzW/gX1uOEnk7po8MnsD1wyydIG6hBDAN2NGY5EvZFNX2+elIyDOzoj0
         rKyOLblPgvRZPGbGEn1N9+UVdrDBJWOsTRis28IRfc9866NpJ71gOzBNKfrvwi15ZnU0
         lFzg+Xm2lMsciW6JH+8QqlQjrFO4hOc5WbD9L0IEUOGElT9RFTz8yIpCsqyVZmCN31gw
         YZE0OUiY5Usk74DLTZrKf7Sk6NPVpHsqnFPwLq7OjJtvHM4vY/1jzVihLMakIoD3+bdX
         STtg==
X-Gm-Message-State: AOAM5320+dbYbYtbg1Au62nTtpzTXhB/awVYbq/nA+u72ak0DB+cO7Vn
        cFLnHGo03CHQ5DyFGqi5BrR7sGoDJXo=
X-Google-Smtp-Source: ABdhPJzbGOzi0g1g+TcnTgwBNz9BLfTO9Vkh06o29KtMXFT2gBUWbLB//o3S/nB/3VJr2YUpN6d2+w==
X-Received: by 2002:a17:907:925:: with SMTP id au5mr6204465ejc.467.1613943256130;
        Sun, 21 Feb 2021 13:34:16 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 11/12] Documentation: networking: switchdev: clarify device driver behavior
Date:   Sun, 21 Feb 2021 23:33:54 +0200
Message-Id: <20210221213355.1241450-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
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
---
 Documentation/networking/switchdev.rst | 120 +++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
index ddc3f35775dc..9fb3e0fd39dc 100644
--- a/Documentation/networking/switchdev.rst
+++ b/Documentation/networking/switchdev.rst
@@ -385,3 +385,123 @@ The driver can monitor for updates to arp_tbl using the netevent notifier
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
+devices and unsolicited multicast must be filtered as early as possible into
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
+  data path will only process untagged Ethernet frames. Frames ingressing the
+  device with a VID that is not programmed into the bridge/switch's VLAN table
+  must be forwarded and may be processed using a VLAN device (see below).
+
+- with VLAN filtering turned on: the bridge is VLAN-aware and frames ingressing
+  the device with a VID that is not programmed into the bridges/switch's VLAN
+  table must be dropped (strict VID checking).
+
+Non-bridged network ports of the same switch fabric must not be disturbed in any
+way by the enabling of VLAN filtering on the bridge device(s).
+
+VLAN devices configured on top of a switchdev network device (e.g: sw0p1.100)
+which is a bridge port member must also observe the following behavior:
+
+- with VLAN filtering turned off, enslaving VLAN devices into the bridge might
+  be allowed provided that there is sufficient separation using e.g.: a
+  reserved VLAN ID (4095 for instance) for untagged traffic. The VLAN data path
+  is used to pop/push the VLAN tag such that the bridge's data path only
+  processes untagged traffic.
+
+- with VLAN filtering turned on, these VLAN devices can be created as long as
+  there is not an existing VLAN entry into the bridge with an identical VID and
+  port membership. These VLAN devices cannot be enslaved into the bridge since
+  they duplicate functionality/use case with the bridge's VLAN data path
+  processing.
+
+Because VLAN filtering can be turned on/off at runtime, the switchdev driver
+must be able to reconfigure the underlying hardware on the fly to honor the
+toggling of that option and behave appropriately.
+
+A switchdev driver can also refuse to support dynamic toggling of the VLAN
+filtering knob at runtime and require a destruction of the bridge device(s) and
+creation of new bridge device(s) with a different VLAN filtering value to
+ensure VLAN awareness is pushed down to the hardware.
+
+Finally, even when VLAN filtering in the bridge is turned off, the underlying
+switch hardware and driver may still configured itself in a VLAN-aware mode
+provided that the behavior described above is observed.
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

