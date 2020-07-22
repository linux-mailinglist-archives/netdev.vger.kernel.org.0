Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B5D22A2B6
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733073AbgGVWxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733066AbgGVWxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:53:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1EBC0619E1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:53:14 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s10so3363699wrw.12
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3COe3fqUA0Qp4qhRII0q+bugU0clbZMGqTHVe3gsNXE=;
        b=gnj2AsbUi4lmaYePvvBtgrE4t4HY9TeYsFQhpe5F7WMqXOt/TmXWBn/qtz/0Oqg1cP
         EV9axB2Lw/F0lSEVy1oWxLOWTVhmMpuDaIH8T3d0RV/qz8HmrXi4pD8B7q/a0C/THX9N
         DQP8TDn+sOU8uotjN2Dt9M0uUcYlPxeZmGRLavXICpkS+5qCn7FJLZMci6UCksIBdjof
         SLMWVB1f8oN6FF+yI7Wy2Cr0YtY/oaRvBzh1W5ccMEm/qhXAxe1PLkyDUJxmtLHshbCn
         aqEG4b3YvxDQLfrnlxfoHjXXaZCGRWtLdpTgCTF1PL5NHnN1QLU8kalsbwPQddYlQDvw
         787Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3COe3fqUA0Qp4qhRII0q+bugU0clbZMGqTHVe3gsNXE=;
        b=l0OPGwFqfqMDrsM5SlfTcqJzLc4B7xJpVhiOYxXaFJQD4iZ+puN+takixMCkcrpoWq
         hACoiapzXeJzmkF9SX4Yb8dLlvQemCcowXrTXOhnAboKsQaX/l6DPsEfzW5rrWsXN40O
         Yv57k7yU4Hz5VOHGf4N3KeVYp24GVY+3hViXTUr8ZZqHJky+NS2y2qMdmF0TS77eCxNy
         S0kG36AIR6ITPRBRZ62v3XinzKAKKmd9d+tLuL7yN+X1Dcjj35sikGroR7IYOQHVdXoJ
         P1Paq2vwMoaCuVuqkS+qXf0NSj3kgS+tzJQLdCLKYZ5Uun8f/Jkf5zrKLaUJByFvleGL
         gEwA==
X-Gm-Message-State: AOAM533EoHC6lV0DyX6YjZtX+xdtgPIwRSIwS6XfIzqj6KWsHeKN2fra
        Hmo0Lk8BkqZN0sb4w/SAYN8dOmCW
X-Google-Smtp-Source: ABdhPJz4hPiH0k0xSR9jAkOeoW0/r4ZuyBW0PfPMcTaaeMwZ0CpcZjrSDD8su5ATbmNtkZDfLBo8Rw==
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr1327807wrr.323.1595458392467;
        Wed, 22 Jul 2020 15:53:12 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b139sm1289028wmd.19.2020.07.22.15.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 15:53:11 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        andrew@lunn.ch, vivien.didelot@gmail.com, cphealy@gmail.com,
        idosch@mellanox.com, jiri@mellanox.com,
        bridge@lists.linux-foundation.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, rdunlap@infradead.org,
        ilias.apalodimas@linaro.org, ivan.khoronzhuk@linaro.org,
        olteanv@gmail.com, kuba@kernel.org
Subject: [PATCH net-next] Documentation: networking: Clarify switchdev devices behavior
Date:   Wed, 22 Jul 2020 15:52:53 -0700
Message-Id: <20200722225253.28848-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides details on the expected behavior of switchdev
enabled network devices when operating in a "stand alone" mode, as well
as when being bridge members. This clarifies a number of things that
recently came up during a bug fixing session on the b53 DSA switch
driver.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Since this has been submitted in a while, removing the patch numbering,
but previous patches and discussions can be found here:

http://patchwork.ozlabs.org/project/netdev/patch/20190103224702.21541-1-f.fainelli@gmail.com/
http://patchwork.ozlabs.org/project/netdev/patch/20190109043930.8534-1-f.fainelli@gmail.com/
http://patchwork.ozlabs.org/project/netdev/patch/20190110193206.9872-1-f.fainelli@gmail.com/

David, I would like to hear from Vladimir and Ido specifically to make
sure that the documentation is up to date with expectations or desired
behavior so we can move forward with Vladimir's DSA rx filtering patch
series. So don't apply this just yet ;)

Thanks!

 Documentation/networking/switchdev.rst | 118 +++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
index ddc3f35775dc..2e4f50e6c63c 100644
--- a/Documentation/networking/switchdev.rst
+++ b/Documentation/networking/switchdev.rst
@@ -385,3 +385,121 @@ The driver can monitor for updates to arp_tbl using the netevent notifier
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
+Configuration less state
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
+of a VLAN aware bridge doing ingress VID checking). See below for details.
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
+The Linux bridge allows the configuration of a VLAN filtering mode (compile and
+run time) which must be observed by the underlying switchdev network
+device/hardware:
+
+- with VLAN filtering turned off: the bridge is strictly VLAN unaware and its
+  data path will only process untagged Ethernet frames. Frames ingressing the
+  device with a VID that is not programmed into the bridge/switch's VLAN table
+  must be forwarded and may be processed using a VLAN device (see below).
+
+- with VLAN filtering turned on: the bridge is VLAN aware and frames ingressing
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
+  because they duplicate functionality/use case with the bridge's VLAN data path
+  processing.
+
+Because VLAN filtering can be turned on/off at runtime, the switchdev driver
+must be able to re-configure the underlying hardware on the fly to honor the
+toggling of that option and behave appropriately.
+
+A switchdev driver can also refuse to support dynamic toggling of the VLAN
+filtering knob at runtime and require a destruction of the bridge device(s) and
+creation of new bridge device(s) with a different VLAN filtering value to
+ensure VLAN awareness is pushed down to the HW.
+
+Finally, even when VLAN filtering in the bridge is turned off, the underlying
+switch hardware and driver may still configured itself in a VLAN aware mode
+provided that the behavior described above is observed.
+
+Bridge IGMP snooping
+^^^^^^^^^^^^^^^^^^^^
+
+The Linux bridge allows the configuration of IGMP snooping (compile and run
+time) which must be observed by the underlying switchdev network device/hardware
+in the following way:
+
+- when IGMP snooping is turned off, multicast traffic must be flooded to all
+  switch ports within the same broadcast domain. The CPU/management port
+  should ideally not be flooded and continue to learn multicast traffic through
+  the network stack notifications. If the hardware is not capable of doing that
+  then the CPU/management port must also be flooded and multicast filtering
+  happens in software.
+
+- when IGMP snooping is turned on, multicast traffic must selectively flow
+  to the appropriate network ports (including CPU/management port) and not be
+  unnecessarily flooding.
+
+The switch must adhere to RFC 4541 and flood multicast traffic accordingly
+since that is what the Linux bridge implementation does.
+
+Because IGMP snooping can be turned on/off at runtime, the switchdev driver
+must be able to re-configure the underlying hardware on the fly to honor the
+toggling of that option and behave appropriately.
+
+A switchdev driver can also refuse to support dynamic toggling of the multicast
+snooping knob at runtime and require the destruction of the bridge device(s)
+and creation of a new bridge device(s) with a different multicast snooping
+value.
-- 
2.17.1

