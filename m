Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E945727850C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 12:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgIYKZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 06:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgIYKZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 06:25:55 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED2FC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 03:25:55 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y15so2712222wmi.0
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 03:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/bSXHNtdU+eEhzycYVit0PPbYq40mXuagPAzmTwFhXc=;
        b=uAHSdiWaP3q78YXDSbkvEyYy9k/VwxAC2Z9ITTrMvZ9VOj4FEjwkgcprsNBzLSC9ae
         N7tp9gnZSzunQ+kmGYqGNgGOTcNgDT42pYAocl0crhCbhEqhX03kWeIoudh5b2Cq4hYN
         1e6RROvVfDvfijmhyfTtRlpHENORCIH/u8Gvnj+5+reepo+J8sBPhdtXDxAPE9HPvOTc
         UnpWNGCzdPdjYtFQWuJvo0JcWsesui7JTZ9uMb6CPam5YNDHi7iR2e5g523g3EIbBYo9
         20wpaBe2nmuUoOxwJL48aM5+xfat5r/BnpyrxPnFfg3y45FPOUQkmjqAVxxwpWVQWTHL
         ypAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/bSXHNtdU+eEhzycYVit0PPbYq40mXuagPAzmTwFhXc=;
        b=h72EGAy9eRzef42/lEh4UbDdk/COdAAJ4x4nSbb0HmJpFlwrqBtaQ6/qi96qd/Tlix
         h0c9Kr1c03/IM7+kNLa9MQZPNpTMDZ6Cugwih0mjEDedDwGS1LDKhbC+0SCg1R+oHZVh
         Cg7GFdT/UcET4AKH81UlV49zLmdVJdPgGJJcvfp87fSsFcGavrHhuqpg7wPKGPtcU8gm
         A9ixFDt2OivZhg2fTZfvSjFJJ6raQAtJ8PXIi0g/j96cPKd8sLZVCqBnYmOnoIK01tAI
         kv+B1gP/SIXd70vp+g1YjD63cc2ftV3hJHWSQHCtiVmryHo2WCyKI3VqhN6UlbMByUhS
         tVIA==
X-Gm-Message-State: AOAM530BdGWKfM0cK7JKLHfduGXiQm1b4YhrNRYXo/daNrMdpP4cSfIA
        stlzj8LLrJaYs+iYYAFzIIglZHi9Y/tWgLdjSgs=
X-Google-Smtp-Source: ABdhPJwYkAg6wiYQE/kiFTwGRHyIiOS5zag+H4OguIXfa0N+21fcrPr3n3Pr11DlnHUNcTu6o4O+pA==
X-Received: by 2002:a05:600c:210c:: with SMTP id u12mr2523261wml.185.1601029553549;
        Fri, 25 Sep 2020 03:25:53 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f14sm2543557wrt.53.2020.09.25.03.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 03:25:52 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next] net: bridge: mcast: remove only S,G port groups from sg_port hash
Date:   Fri, 25 Sep 2020 13:25:49 +0300
Message-Id: <20200925102549.1704905-1-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We should remove a group from the sg_port hash only if it's an S,G
entry. This makes it correct and more symmetric with group add. Also
since *,G groups are not added to that hash we can hide a bug.

Fixes: 085b53c8beab ("net: bridge: mcast: add sg_port rhashtable")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 66eb62ded192..eae898c3cff7 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -590,17 +590,18 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	struct net_bridge_group_src *ent;
 	struct hlist_node *tmp;
 
-	rhashtable_remove_fast(&br->sg_port_tbl, &pg->rhnode,
-			       br_sg_port_rht_params);
 	rcu_assign_pointer(*pp, pg->next);
 	hlist_del_init(&pg->mglist);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		br_multicast_del_group_src(ent);
 	br_mdb_notify(br->dev, mp, pg, RTM_DELMDB);
-	if (!br_multicast_is_star_g(&mp->addr))
+	if (!br_multicast_is_star_g(&mp->addr)) {
+		rhashtable_remove_fast(&br->sg_port_tbl, &pg->rhnode,
+				       br_sg_port_rht_params);
 		br_multicast_sg_del_exclude_ports(mp);
-	else
+	} else {
 		br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
+	}
 	hlist_add_head(&pg->mcast_gc.gc_node, &br->mcast_gc_list);
 	queue_work(system_long_wq, &br->mcast_gc_work);
 
-- 
2.25.4

