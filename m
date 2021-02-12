Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3345231A16D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhBLPRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbhBLPQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:16:56 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203D4C061788;
        Fri, 12 Feb 2021 07:16:16 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id f14so16221791ejc.8;
        Fri, 12 Feb 2021 07:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3txk3xzuaJ+luXWZVWBUlXIhxgR9+690DPw6ux/lwb4=;
        b=SAmMq4yYxfpPC2vCJkMrc9KnpLTTPktTIn/W2GRELoK84+vCpMSng2nd/0KJ872EgL
         DUigC7Ex19jWXuHQdlrCjYQnqqXaTn32p4CEPo90PTz3oYOr23Hf8/H2yazHJ917p1OK
         PPiWvl3eIENuZhkpVXXlg0XEeQgXLERZvUOIndxSdnV0EdeDIXECxiTU4/v82bSwaE4N
         jUxaJnSiqa6VTnFZpZzSIjMx47xy+ZcAa3FdTpXyEVhuvWZCiKqAJLxBW82hmoiTqIai
         FRbSr2PeALPvhsuHbfUWzFNByVyQ9K5vjaaYxtRo1LjwwBBjq+ae+3kgXwaaQCtPwSGk
         Dmyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3txk3xzuaJ+luXWZVWBUlXIhxgR9+690DPw6ux/lwb4=;
        b=Mf9VMkDC7UoIoXfTVuEB4MtdVOJDda8Bvh3rU9ojuPWwLtQwCVgOE2g1nq6DFw8drc
         ueSxhEtSyyriF98iySgoRawLgCWD+6MCtMb5zAKiieAkrj1zzwNzEb+L1OTfV+DOvuoZ
         B6WyCMK8gr8/JjB1Owj/8dxz/tgIz75yp8i7PxAkwbDEe7mhDGTk8pmOcFEAOAdC+m75
         MNr53N5gu7S4er/wNmvY593AJ6zaJMLa73f9Ay3qPlAOnjKP6BN3xjBMYcMbSvCgDdgv
         sUtYqAfJiTphePkQy728EtC4lav2IiOt4mBlG3+kefVTHOLKOl5gMf//P6Tjg/5G7tfU
         uqJQ==
X-Gm-Message-State: AOAM530vNkRBXOKDr2LJ3pav2/pNA9PPQ3ms4rENbHibP8nky1vA2zf0
        hGXhrqMjnzf/HKP68btAOQg=
X-Google-Smtp-Source: ABdhPJzkVczuOmaW3fpNoup+Al6snwdDJs3c7fOUYtx5bEaFBiZ4R5Q/CAwAKIcewHJ9t9fXp1huAA==
X-Received: by 2002:a17:906:86cf:: with SMTP id j15mr3454069ejy.194.1613142974845;
        Fri, 12 Feb 2021 07:16:14 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z19sm6515456edr.69.2021.02.12.07.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:16:14 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v5 net-next 04/10] net: dsa: configure better brport flags when ports leave the bridge
Date:   Fri, 12 Feb 2021 17:15:54 +0200
Message-Id: <20210212151600.3357121-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212151600.3357121-1-olteanv@gmail.com>
References: <20210212151600.3357121-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For a DSA switch port operating in standalone mode, address learning
doesn't make much sense since that is a bridge function. In fact,
address learning even breaks setups such as this one:

   +---------------------------------------------+
   |                                             |
   | +-------------------+                       |
   | |        br0        |    send      receive  |
   | +--------+-+--------+ +--------+ +--------+ |
   | |        | |        | |        | |        | |
   | |  swp0  | |  swp1  | |  swp2  | |  swp3  | |
   | |        | |        | |        | |        | |
   +-+--------+-+--------+-+--------+-+--------+-+
          |         ^           |          ^
          |         |           |          |
          |         +-----------+          |
          |                                |
          +--------------------------------+

because if the switch has a single FDB (can offload a single bridge)
then source address learning on swp3 can "steal" the source MAC address
of swp2 from br0's FDB, because learning frames coming from swp2 will be
done twice: first on the swp1 ingress port, second on the swp3 ingress
port. So the hardware FDB will become out of sync with the software
bridge, and when swp2 tries to send one more packet towards swp1, the
ASIC will attempt to short-circuit the forwarding path and send it
directly to swp3 (since that's the last port it learned that address on),
which it obviously can't, because swp3 operates in standalone mode.

So DSA drivers operating in standalone mode should still configure a
list of bridge port flags even when they are standalone. Currently DSA
attempts to call dsa_port_bridge_flags with 0, which disables egress
flooding of unknown unicast and multicast, something which doesn't make
much sense. For the switches that implement .port_egress_floods - b53
and mv88e6xxx, it probably doesn't matter too much either, since they
can possibly inject traffic from the CPU into a standalone port,
regardless of MAC DA, even if egress flooding is turned off for that
port, but certainly not all DSA switches can do that - sja1105, for
example, can't. So it makes sense to use a better common default there,
such as "flood everything".

It should also be noted that what DSA calls "dsa_port_bridge_flags()"
is a degenerate name for just calling .port_egress_floods(), since
nothing else is implemented - not learning, in particular. But disabling
address learning, something that this driver is also coding up for, will
be supported by individual drivers once .port_egress_floods is replaced
with a more generic .port_bridge_flags.

Previous attempts to code up this logic have been in the common bridge
layer, but as pointed out by Ido Schimmel, there are corner cases that
are missed when doing that:
https://patchwork.kernel.org/project/netdevbpf/patch/20210209151936.97382-5-olteanv@gmail.com/

So, at least for now, let's leave DSA in charge of setting port flags
before and after the bridge join and leave.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
Patch is new, logically it was moved from the bridge layer to the DSA
layer.

 net/dsa/port.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index b93bda463026..1f877bf21bb4 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -122,6 +122,27 @@ void dsa_port_disable(struct dsa_port *dp)
 	rtnl_unlock();
 }
 
+static void dsa_port_change_brport_flags(struct dsa_port *dp,
+					 bool bridge_offload)
+{
+	unsigned long mask, flags;
+	int flag, err;
+
+	mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
+	if (bridge_offload)
+		flags = mask;
+	else
+		flags = mask & ~BR_LEARNING;
+
+	for_each_set_bit(flag, &mask, 32) {
+		err = dsa_port_pre_bridge_flags(dp, BIT(flag));
+		if (err)
+			continue;
+
+		dsa_port_bridge_flags(dp, flags & BIT(flag));
+	}
+}
+
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 {
 	struct dsa_notifier_bridge_info info = {
@@ -132,10 +153,10 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 	};
 	int err;
 
-	/* Set the flooding mode before joining the port in the switch */
-	err = dsa_port_bridge_flags(dp, BR_FLOOD | BR_MCAST_FLOOD);
-	if (err)
-		return err;
+	/* Notify the port driver to set its configurable flags in a way that
+	 * matches the initial settings of a bridge port.
+	 */
+	dsa_port_change_brport_flags(dp, true);
 
 	/* Here the interface is already bridged. Reflect the current
 	 * configuration so that drivers can program their chips accordingly.
@@ -146,7 +167,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 
 	/* The bridging is rolled back on error */
 	if (err) {
-		dsa_port_bridge_flags(dp, 0);
+		dsa_port_change_brport_flags(dp, false);
 		dp->bridge_dev = NULL;
 	}
 
@@ -172,8 +193,18 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
-	/* Port is leaving the bridge, disable flooding */
-	dsa_port_bridge_flags(dp, 0);
+	/* Configure the port for standalone mode (no address learning,
+	 * flood everything).
+	 * The bridge only emits SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS events
+	 * when the user requests it through netlink or sysfs, but not
+	 * automatically at port join or leave, so we need to handle resetting
+	 * the brport flags ourselves. But we even prefer it that way, because
+	 * otherwise, some setups might never get the notification they need,
+	 * for example, when a port leaves a LAG that offloads the bridge,
+	 * it becomes standalone, but as far as the bridge is concerned, no
+	 * port ever left.
+	 */
+	dsa_port_change_brport_flags(dp, false);
 
 	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
-- 
2.25.1

