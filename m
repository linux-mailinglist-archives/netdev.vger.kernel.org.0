Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9CC3410DA
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhCRXTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbhCRXSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:18:55 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BEFC06174A;
        Thu, 18 Mar 2021 16:18:54 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b16so8699882eds.7;
        Thu, 18 Mar 2021 16:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AJvI3GLtbyB3NENOYstHudltDDnCEpv9TEZkoJEx5R0=;
        b=eJVDAQ86FmqIF5YoKlCF9nwRHWAAsj4eYzBW3k3hcKeH4HyXJ9Fh/LLkt+ig6XGwjb
         fGUAY4eswPMhoYehHLg/ph1LKBgoKuL3+LsCgz0XQOaZpWz3drMX+VOz3tsiTjcNOd7B
         P3Ll29+g9RA4ELiVOX84+TF80Prh8SIrPA3SnM3hNq+aNW62y6yPhyoyqfRlM6Mx+F0B
         q0p9g03Ttom2f5OZBuF2oLmClOF56Jy56PYfwhuvZCdxLxAiuMKLeSl5D2zEBwk20v+J
         LQwFhyCT7OgACdH6FnNQQtkYgfl4Jo9dk23wl+yOKT4xs6I50JgOXfokbYAuofGLJt1l
         Rujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AJvI3GLtbyB3NENOYstHudltDDnCEpv9TEZkoJEx5R0=;
        b=tic+COLfymFyuvi37VvsOBt5NS7O6z2M/f6zFiDVmywunACtBocnSPEo4/0PUgwje/
         nYRQHYzX36TapjaamdGbD9OXQo2i9Fxvv30/kKz5ZaeZTPhI2zgMC7XwHumo/2IPCwES
         2rMD7Zx5f2tDJQZEyDaCHuxj4YzFhAiHWv7+3HCKm2Lm9G9McFJJTDwNtrcb4YLh8sV+
         5XTMaE4u0LFfAj9+KzC57gCpr/fz+lLbsjasCnMPgefUAuQB0o9Aq9h3pMK0NdlL8Dxs
         a9YR4cePq4qQqRnpzrmQ1YjN6HwpynBNUwQU+/R5mvQ63wL8IrJMfn1YWy6dyhbwSrTj
         OQXg==
X-Gm-Message-State: AOAM530Q4lAdc3y0jocITBSH0xYrnGhqE0yG5Np9Xz0029UPPOK7SZ7k
        EmQlXCu0QsNZlwehkL6mW8U=
X-Google-Smtp-Source: ABdhPJzDTzMO8Dcqvjz72FUCdZ2di8I/r/+1i7u/mIJ2+tsGZYwUHsTS3ul7ko5pDRxbzv73vN+dAA==
X-Received: by 2002:aa7:dc04:: with SMTP id b4mr6439110edu.221.1616109533710;
        Thu, 18 Mar 2021 16:18:53 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 07/16] net: dsa: sync ageing time when joining the bridge
Date:   Fri, 19 Mar 2021 01:18:20 +0200
Message-Id: <20210318231829.3892920-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME attribute is only emitted from:

sysfs/ioctl/netlink
-> br_set_ageing_time
   -> __set_ageing_time

therefore not at bridge port creation time, so:
(a) drivers had to hardcode the initial value for the address ageing time,
    because they didn't get any notification
(b) that hardcoded value can be out of sync, if the user changes the
    ageing time before enslaving the port to the bridge

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_stp.c       | 13 +++++++++++++
 net/dsa/port.c            | 10 ++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 920d3a02cc68..ebd16495459c 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -137,6 +137,7 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
+clock_t br_get_ageing_time(struct net_device *br_dev);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -160,6 +161,11 @@ static inline u8 br_port_get_stp_state(const struct net_device *dev)
 {
 	return BR_STATE_DISABLED;
 }
+
+static inline clock_t br_get_ageing_time(struct net_device *br_dev)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 86b5e05d3f21..3dafb6143cff 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -639,6 +639,19 @@ int br_set_ageing_time(struct net_bridge *br, clock_t ageing_time)
 	return 0;
 }
 
+clock_t br_get_ageing_time(struct net_device *br_dev)
+{
+	struct net_bridge *br;
+
+	if (!netif_is_bridge_master(br_dev))
+		return 0;
+
+	br = netdev_priv(br_dev);
+
+	return jiffies_to_clock_t(br->ageing_time);
+}
+EXPORT_SYMBOL_GPL(br_get_ageing_time);
+
 /* called under bridge lock */
 void __br_set_topology_change(struct net_bridge *br, unsigned char val)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 8380509ee47c..9fde2371e1bc 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -173,6 +173,7 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	struct net_device *br = dp->bridge_dev;
+	clock_t ageing_time;
 	u8 stp_state;
 	int err;
 
@@ -193,6 +194,11 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	ageing_time = br_get_ageing_time(br);
+	err = dsa_port_ageing_time(dp, ageing_time);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
@@ -222,6 +228,10 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
 	 * allow this in standalone mode too.
 	 */
 	dsa_port_mrouter(dp->cpu_dp, true, NULL);
+
+	/* Ageing time may be global to the switch chip, so don't change it
+	 * here because we have no good reason (or value) to change it to.
+	 */
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
-- 
2.25.1

