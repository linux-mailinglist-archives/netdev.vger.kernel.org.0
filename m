Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AC32EBBE7
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 10:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbhAFJww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 04:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbhAFJwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 04:52:49 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA0AC061358;
        Wed,  6 Jan 2021 01:52:08 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r5so3772610eda.12;
        Wed, 06 Jan 2021 01:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=16gvd7BfAcfkRnjtzWfjSCGdsSy14Us38+FznvZBJ7k=;
        b=PxNd/HwEcNRSVMr99MKoK3FzawQD6GjQmrNvZWYlyPKEozceeJEV7Feiql1pcoI7Rb
         wg9Zt1LmDZR/Etlg/TPais3DvwGsK0kA52gXrvdz3x5V7arW4lg0meHUobfoFNutshdR
         akA0NLol+kdv0LD0cnBx+X86WYao9mr97lZvRBN8UarkgQ6jGGLg41oqfkxAYRGlgq83
         xjqgJv1WgXdxqNTWGb/Wtmt+UsDmvfAHhBBjbAdPm6MY9i+jwiHvcnvunQqgV0sxSyh0
         EoghLxnZiY4BA9dIxr00RSdF0YWbcama5fTUCt6cnwd3n4r0u9PUIiq2H5TDULTe20Ck
         s88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=16gvd7BfAcfkRnjtzWfjSCGdsSy14Us38+FznvZBJ7k=;
        b=OHckbzX7QDrtBpoM0j4en5N8o5339ads/CCHe54OKMLDQlmUFUvt2I0Xo0jvLgGe8U
         7Vq0WlfCNHq2dTzeMkhZ6PKLvOunxw/fqWvK1jjXvTPnufB6NsiqV5u4FfR3jP32iAyq
         aZVwymiSSxorI0SJhXgHymF/d+asRDeA4OtFa8k71mx0VTSgRGRIh16+8EeVSI96PCQs
         RY6KKc7MsdfH9w92BIi2GWJUlcs9Xfbp6Zf7jbE7dW+zOiBtqQSWDck3LtUAGUPAwz9j
         gaN6rvxhx2h1tExW6eS56+jEvqMbHXHNAdZstLNJwVAaihtENhWc1xbIS0/3wDqgmQNd
         5FFw==
X-Gm-Message-State: AOAM532zgucgKUNW81NgmhOYlGxrH8YhuQD0IPmAqHhOvA0RYzEh3jtX
        9RGFT6vjgFxCtDPojbcJh8U=
X-Google-Smtp-Source: ABdhPJxktxJJg1wSJT44rdSR3ZWY7rdryDbFA1fGYDagD8Dp2gOqmN4tYEBT3tL4kBc/+HG/SGWznQ==
X-Received: by 2002:aa7:c886:: with SMTP id p6mr3566884eds.352.1609926727634;
        Wed, 06 Jan 2021 01:52:07 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n8sm1019587eju.33.2021.01.06.01.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 01:52:07 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 1/7] net: bridge: notify switchdev of disappearance of old FDB entry upon migration
Date:   Wed,  6 Jan 2021 11:51:30 +0200
Message-Id: <20210106095136.224739-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106095136.224739-1-olteanv@gmail.com>
References: <20210106095136.224739-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently the bridge emits atomic switchdev notifications for
dynamically learnt FDB entries. Monitoring these notifications works
wonders for switchdev drivers that want to keep their hardware FDB in
sync with the bridge's FDB.

For example station A wants to talk to station B in the diagram below,
and we are concerned with the behavior of the bridge on the DUT device:

                   DUT
 +-------------------------------------+
 |                 br0                 |
 | +------+ +------+ +------+ +------+ |
 | |      | |      | |      | |      | |
 | | swp0 | | swp1 | | swp2 | | eth0 | |
 +-------------------------------------+
      |        |                  |
  Station A    |                  |
               |                  |
         +--+------+--+    +--+------+--+
         |  |      |  |    |  |      |  |
         |  | swp0 |  |    |  | swp0 |  |
 Another |  +------+  |    |  +------+  | Another
  switch |     br0    |    |     br0    | switch
         |  +------+  |    |  +------+  |
         |  |      |  |    |  |      |  |
         |  | swp1 |  |    |  | swp1 |  |
         +--+------+--+    +--+------+--+
                                  |
                              Station B

Interfaces swp0, swp1, swp2 are handled by a switchdev driver that has
the following property: frames injected from its control interface bypass
the internal address analyzer logic, and therefore, this hardware does
not learn from the source address of packets transmitted by the network
stack through it. So, since bridging between eth0 (where Station B is
attached) and swp0 (where Station A is attached) is done in software,
the switchdev hardware will never learn the source address of Station B.
So the traffic towards that destination will be treated as unknown, i.e.
flooded.

This is where the bridge notifications come in handy. When br0 on the
DUT sees frames with Station B's MAC address on eth0, the switchdev
driver gets these notifications and can install a rule to send frames
towards Station B's address that are incoming from swp0, swp1, swp2,
only towards the control interface. This is all switchdev driver private
business, which the notification makes possible.

All is fine until someone unplugs Station B's cable and moves it to the
other switch:

                   DUT
 +-------------------------------------+
 |                 br0                 |
 | +------+ +------+ +------+ +------+ |
 | |      | |      | |      | |      | |
 | | swp0 | | swp1 | | swp2 | | eth0 | |
 +-------------------------------------+
      |        |                  |
  Station A    |                  |
               |                  |
         +--+------+--+    +--+------+--+
         |  |      |  |    |  |      |  |
         |  | swp0 |  |    |  | swp0 |  |
 Another |  +------+  |    |  +------+  | Another
  switch |     br0    |    |     br0    | switch
         |  +------+  |    |  +------+  |
         |  |      |  |    |  |      |  |
         |  | swp1 |  |    |  | swp1 |  |
         +--+------+--+    +--+------+--+
               |
           Station B

Luckily for the use cases we care about, Station B is noisy enough that
the DUT hears it (on swp1 this time). swp1 receives the frames and
delivers them to the bridge, who enters the unlikely path in br_fdb_update
of updating an existing entry. It moves the entry in the software bridge
to swp1 and emits an addition notification towards that.

As far as the switchdev driver is concerned, all that it needs to ensure
is that traffic between Station A and Station B is not forever broken.
If it does nothing, then the stale rule to send frames for Station B
towards the control interface remains in place. But Station B is no
longer reachable via the control interface, but via a port that can
offload the bridge port learning attribute. It's just that the port is
prevented from learning this address, since the rule overrides FDB
updates. So the rule needs to go. The question is via what mechanism.

It sure would be possible for this switchdev driver to keep track of all
addresses which are sent to the control interface, and then also listen
for bridge notifier events on its own ports, searching for the ones that
have a MAC address which was previously sent to the control interface.
But this is cumbersome and inefficient. Instead, with one small change,
the bridge could notify of the address deletion from the old port, in a
symmetrical manner with how it did for the insertion. Then the switchdev
driver would not be required to monitor learn/forget events for its own
ports. It could just delete the rule towards the control interface upon
bridge entry migration. This would make hardware address learning be
possible again. Then it would take a few more packets until the hardware
and software FDB would be in sync again.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 net/bridge/br_fdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 32ac8343b0ba..b7490237f3fc 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -602,6 +602,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			/* fastpath: update of existing entry */
 			if (unlikely(source != fdb->dst &&
 				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
+				br_switchdev_fdb_notify(fdb, RTM_DELNEIGH);
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
-- 
2.25.1

