Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990EA343042
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 00:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCTXFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 19:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTXEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 19:04:53 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1C3C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 16:04:53 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w18so15050179edc.0
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 16:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m8fzCuh8q7SVAj53Ldb4oVbrnvdIWrUYRcolJ2Heh10=;
        b=VDP72NLx2owLLeCYmR5V9M/SoyogUEJMNnqTpSMel2CddTwO4pOF2e9w7NV+oXv9wd
         5sJuMDGlaOAllW1w+7lYzCNSYjMXAiL9HtHW8+Mx/X+neQdj7ZlMryfFtY5E4xWHb4d9
         KGOLtrPPykGZ/neCyli7s3vTRrYP3U9L3XLwhb7A5hODILq9AFlG/wLeefmt9429Dskn
         iwUEegwSfbZf7wa3Sm7ocP7Mjo7VzeO7TFumsngPr92Quia2vinKEw2zodHhMcAe+iLZ
         pHseBPhEmfhLo+//tTKrY7oBz2PfzTni7z/cmD+LvRS1AgTImZ0OUc6X8JDxHxWdkEX7
         jNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m8fzCuh8q7SVAj53Ldb4oVbrnvdIWrUYRcolJ2Heh10=;
        b=AkO3J1fy0UOMSlKsraF+4u0hynyhpc4oN1mVSqhTpoykmFpBKiArXQQ7VOEoDEIfyX
         ELB8ZUsBHdbRNjshNCs6yjBuhfrJTArhW0SsaarIvib6y5/lGWOVyVgGFB0zNH8TLqhy
         G2NXjC3KY6x7tswlBHFTc/zTOkQff/s/7bzwyGOOY3S92aIeoj7njcbPLrMNgI4xCPRC
         0rcyGyl3AQxDZQ/kh/473oQAXAxrOtB0SFldI997Gx698JUtDKOmlPUDxP1LQCf+mojp
         hhI+perwagXA2M8qGDYmC60SZ8zkQR97bKNA5/8zt+Bo6/fLW0vKjdRmqwEkeiVExd/z
         BJAQ==
X-Gm-Message-State: AOAM531K5dLXFdjhCE7HCuaCgjj/KEG4Jx0OJTp0kGPR63KIHaP+euXX
        JgIBv0t40Fl7c5qC+mZV7jw=
X-Google-Smtp-Source: ABdhPJzpbBcloB5190gBltaxkDey2mZARzKuTAP9OcPm5mL4JLyspAyq8JEGlxaloYvyGHqwCuo2Ug==
X-Received: by 2002:a50:e882:: with SMTP id f2mr17800436edn.184.1616281492124;
        Sat, 20 Mar 2021 16:04:52 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v25sm6805129edr.18.2021.03.20.16.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 16:04:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] Revert "net: dsa: sja1105: Clear VLAN filtering offload netdev feature"
Date:   Sun, 21 Mar 2021 01:04:45 +0200
Message-Id: <20210320230445.2484150-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit e9bf96943b408e6c99dd13fb01cb907335787c61.

The topic of the reverted patch is the support for switches with global
VLAN filtering, added by commit 061f6a505ac3 ("net: dsa: Add
ndo_vlan_rx_{add, kill}_vid implementation"). Be there a switch with 4
ports swp0 -> swp3, and the following setup:

ip link add br0 type bridge vlan_filtering 1
ip link set swp0 master br0
ip link set swp1 master br0

What would happen with VLAN-tagged traffic received on standalone ports
swp2 and swp3? Well, it would get dropped, were it not for the
.ndo_vlan_rx_add_vid and .ndo_vlan_rx_kill_vid implementations (called
from vlan_vid_add and vlan_vid_del respectively). Basically, for DSA
switches where VLAN filtering is a global attribute, we enforce the
standalone ports to have 'rx-vlan-filter: off [fixed]' in their ethtool
features, which lets the user know that all VLAN-tagged packets that are
not explicitly added in the RX filtering list are dropped.

As for the sja1105 driver, at the time of the reverted patch, it was
operating in a pretty handicapped mode when it had ports under a bridge
with vlan_filtering=1. Specifically, it was unable to terminate traffic
through the CPU port (for further explanation see "Traffic support" in
Documentation/networking/dsa/sja1105.rst).

However, since then, the sja1105 driver has made considerable progress,
and that limitation is no longer as severe now. Specifically, since
commit 2cafa72e516f ("net: dsa: sja1105: add a new
best_effort_vlan_filtering devlink parameter"), the driver is able to
perform CPU termination even when some ports are under bridges with
vlan_filtering=1. Then, since commit 8841f6e63f2c ("net: dsa: sja1105:
make devlink property best_effort_vlan_filtering true by default"), this
even became the default operating mode.

So we can now take advantage of the logic in the DSA core.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 51ea104c63bb..d9c198ca0197 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3049,21 +3049,6 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	}
 }
 
-static int sja1105_port_enable(struct dsa_switch *ds, int port,
-			       struct phy_device *phy)
-{
-	struct net_device *slave;
-
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
-	slave = dsa_to_port(ds, port)->slave;
-
-	slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-
-	return 0;
-}
-
 static void sja1105_port_disable(struct dsa_switch *ds, int port)
 {
 	struct sja1105_private *priv = ds->priv;
@@ -3491,7 +3476,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
 	.get_ts_info		= sja1105_get_ts_info,
-	.port_enable		= sja1105_port_enable,
 	.port_disable		= sja1105_port_disable,
 	.port_fdb_dump		= sja1105_fdb_dump,
 	.port_fdb_add		= sja1105_fdb_add,
-- 
2.25.1

