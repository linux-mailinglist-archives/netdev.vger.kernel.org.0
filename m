Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4623B73E8
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhF2OKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbhF2OKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:10:05 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB8BC06124A
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:31 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c17so10674531ejk.13
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ExBxfgEAQTeIcUqZy35cgliNZw5pKEc8pvrekt89wDM=;
        b=hHj7Fs0zMwlg1N14gH3jx9xGdI7XkmEm8PzB+RALPqNc0IAHNCDd8bKAMlUz6P1qcn
         VeOEL0jG778JVmkwvSzYVwoFtDk3uxfZlA9jGl6l33juRtkWsQgimncnk6niKur2IMGR
         EqOaqnB1vS5augQiQzsagOD7DmOKigoiQCDDycoTT7MB9qX95qbReK2m5dY4kac8s1EY
         NoIplKBlUIO9gv3yXmto1o5Us714Vjk1xb6WQD8WuP2iVJK8fFRwNrl/bZV2jj5aC203
         v/ffQ58zYbpRJcoUVPDmgzemgkOtRcEnDrm7cbnsRNw09xqK+V5FAfg5HykFmHQO39xY
         o+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ExBxfgEAQTeIcUqZy35cgliNZw5pKEc8pvrekt89wDM=;
        b=oCrgPNSiL5YYtdYXUSPjtO6uGGdMg7jk5nFpBzIFi9P7Sd0BaoIgs4etorUoK0IM5E
         OlqsI+jveONUYif3KxGEVYq56d65TURsSonQjm+heclyo7FUz5damzIwas2U8TuJRhew
         cgd5suEH1t5dh4XWRI2uIuccNrXWJjgNqCaXd6kt+6z0UJ2Sl5kXmm6g4jWAKtQo5qOk
         bJVRfn+9founrwUc7hV5fH2lPOKNxZLtmRAQIBj3K1ND+UsqrOocLiz85MZGpd+lWAmm
         6dhpEZi//tTssqxZhvRGUqYjP7fAaabnxM/cPtQnA7K4xGPv4KNKTUFrTakuAUZgy8RQ
         5cnQ==
X-Gm-Message-State: AOAM533s8IuwEs7qR9T6QE1kMKfI4areKV2e90zN1WugdeSkXg8rjGY2
        uZNdG5JFrnBvUTePFSilI6+vvpuLfWU=
X-Google-Smtp-Source: ABdhPJxw+4Vh4LKmPVGz1+DrfVaZQj1VAwygr4y0s2bilcCRg80ecnuUO67N2CiixpuLs8kMrt8axA==
X-Received: by 2002:a17:906:52d6:: with SMTP id w22mr30364861ejn.512.1624975650027;
        Tue, 29 Jun 2021 07:07:30 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 13/15] net: dsa: include fdb entries pointing to bridge in the host fdb list
Date:   Tue, 29 Jun 2021 17:06:56 +0300
Message-Id: <20210629140658.2510288-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The bridge supports a legacy way of adding local (non-forwarded) FDB
entries, which works on an individual port basis:

bridge fdb add dev swp0 00:01:02:03:04:05 master local

As well as a new way, added by Roopa Prabhu in commit 3741873b4f73
("bridge: allow adding of fdb entries pointing to the bridge device"):

bridge fdb add dev br0 00:01:02:03:04:05 self local

The two commands are functionally equivalent, except that the first one
produces an entry with fdb->dst == swp0, and the other an entry with
fdb->dst == NULL. The confusing part, though, is that even if fdb->dst
is swp0 for the 'local on port' entry, that destination is not used.

Nonetheless, the idea is that the bridge has reference counting for
local entries, and local entries pointing towards the bridge are still
'as local' as local entries for a port.

The bridge adds the MAC addresses of the interfaces automatically as
FDB entries with is_local=1. For the MAC address of the ports, fdb->dst
will be equal to the port, and for the MAC address of the bridge,
fdb->dst will point towards the bridge (i.e. be NULL). Therefore, if the
MAC address of the bridge is not inherited from either of the physical
ports, then we must explicitly catch local FDB entries emitted towards
the br0, otherwise we'll miss the MAC address of the bridge (and, of
course, any entry with 'bridge add dev br0 ... self local').

Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: none

 net/dsa/slave.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d006bd04f84a..a7b5d2a41472 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2415,7 +2415,11 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			struct net_device *br_dev;
 			struct dsa_slave_priv *p;
 
-			br_dev = netdev_master_upper_dev_get_rcu(dev);
+			if (netif_is_bridge_master(dev))
+				br_dev = dev;
+			else
+				br_dev = netdev_master_upper_dev_get_rcu(dev);
+
 			if (!br_dev)
 				return NOTIFY_DONE;
 
@@ -2443,8 +2447,13 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			 * LAG we don't want to send traffic to the CPU, the
 			 * other ports bridged with the LAG should be able to
 			 * autonomously forward towards it.
+			 * On the other hand, if the address is local
+			 * (therefore not learned) then we want to trap it to
+			 * the CPU regardless of whether the interface it
+			 * belongs to is offloaded or not.
 			 */
-			if (dsa_tree_offloads_bridge_port(dp->ds->dst, dev))
+			if (dsa_tree_offloads_bridge_port(dp->ds->dst, dev) &&
+			    !fdb_info->is_local)
 				return NOTIFY_DONE;
 		}
 
-- 
2.25.1

