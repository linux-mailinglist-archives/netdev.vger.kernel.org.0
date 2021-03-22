Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0536E34534A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhCVXwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhCVXwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:05 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE077C061574;
        Mon, 22 Mar 2021 16:52:04 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id jy13so24098737ejc.2;
        Mon, 22 Mar 2021 16:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M9VtCMHjMqidFWejIfAw/dLhfjAfoFArbamAgjqVgRk=;
        b=m3UolH3ty2cUCEdnj1dEmGcRrOwe/EqNyV8MzCbuacAJ20aUSCVJFqOd3FRkM2wYed
         weGqi4atZ7ZemcwKoFSBpUdAu1p17VsW4w7KIvlzENsZNOdmMuJlrw3rtF490vbk4HBL
         mojg4z98weoMRSnL9VfxSUdReyeIR1YETtPUPV9YkmqhhbGGqRyVbFdzy+0nsjVZ7NQc
         zAPZkxD2Hl1sRdbsptHqNUKLKuK4QN7sXcNeJze4DTLrRK0mumNt5yEheA/4bIDmdMau
         bSUBVopxW1wBwMWCRB05Cr6oT0pyr9uecKsKUjeK2CorgvHb+lDDr/89QoX7aEs61T2x
         rXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M9VtCMHjMqidFWejIfAw/dLhfjAfoFArbamAgjqVgRk=;
        b=mAYtlNT87R6zp6GbZJ/usS/X+uDPIlw+3uOCPjzy9hP7CP3+cyTuxWb88XimyYk6Uv
         BdEUchmpunSEAn4wjrRP3i4ucV9b5WrarKVa8vZEuylIVXy10tsNnFLgxy1Oy2gWZLMA
         RcPpOwRTHwvDmX6z/s/SoyfspVMO7gXgDxA+K8NzdnwBKL6FbUfZiFyNyxJN6LHctzE7
         GwuK2CMFuffxSpo/y4L2xlo89rS7cFM/RnKYEjFVf6LPMk/jXGf2uyfF+RkcnvPhST0N
         72xjmDVAgJkEDJnYslEobUWmOyo8tSoftQ4NhYb1Y1UhGh/S/as+EKUBsc2y7rpuPfaJ
         CFcQ==
X-Gm-Message-State: AOAM53198jpMhBCGACXbRBLNbyFwMmFy7pjAKFw4Ep6/WMoK+OB4L9X2
        IawDqQER0OxkghyBX47CZvo=
X-Google-Smtp-Source: ABdhPJzP7L0v60H16t3CsrXuPrni7YlMX3LqeuPibQaDWYuBwG14+H1uBhPAdImeVpubykwEBzznpg==
X-Received: by 2002:a17:906:489:: with SMTP id f9mr2106844eja.428.1616457123736;
        Mon, 22 Mar 2021 16:52:03 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 02/11] net: bridge: add helper to retrieve the current ageing time
Date:   Tue, 23 Mar 2021 01:51:43 +0200
Message-Id: <20210322235152.268695-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
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
(a) switchdev drivers have to hardcode the initial value for the address
    ageing time, because they didn't get any notification
(b) that hardcoded value can be out of sync, if the user changes the
    ageing time before enslaving the port to the bridge

We need a helper in the bridge, such that switchdev drivers can query
the current value of the bridge ageing time when they start offloading
it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_stp.c       | 13 +++++++++++++
 2 files changed, 19 insertions(+)

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
-- 
2.25.1

