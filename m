Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE17F323B75
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhBXLsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbhBXLqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:46:23 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63A6C061356
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:15 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id d8so2531348ejc.4
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nu59qIPS2kqMtAot2Qj7Ys6cl5ZPPoFdF2Sho0eLISM=;
        b=Q8ZLhkK1/nGDy61hKoaVp0XrOuKPuybvza0HWYGFuELg8lkPOZFghSLkDCDX3S0pek
         LJZehVEFN3TEvWWfzgN1X9FnygQFDRx/DFvF2XYKTRpsi2wQpQnGlmqv7I4/vqmPDqgT
         HdJe56tAwCA9EiFE0ygWraWmK3VCYhCe89APQ4+sqhIE+hR/TJrw2eLyPLHdmDT8RSyN
         5giNKS1t6Qj9CPBSqjYnXyXBwUEbvA+49MXWMO2HbTsZShlUEDJ00+orbH0DM/o5L3Np
         ahgvom2AnBmd8GkKLCEZ0LZOVbTGN7XtA/ViFGx9gCRV3re43pMo7Im1rkdt+gqouiJO
         AXlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nu59qIPS2kqMtAot2Qj7Ys6cl5ZPPoFdF2Sho0eLISM=;
        b=nmvTgmbTDo67qCru4+9zww01ngqpT31GNfXlkWeHvzUW9hCPDXkf9GL9DJ+kWhgYQf
         3UirCloHMa1mtARW1k2i2kuQVRpYhzm082N5vSpE7DeAqIsVvcsMqnVtcKl8DlulS90q
         /9YbaMJfclqQO0tqpzGJP2ybOaspET56IQt3kwZA9P+YZCN4pApInFsyEU7RX21LEPGK
         EpGpQEG7oY0l/81KdXOPRDkFolZrip2ywHZw+hx0bdvHHXKLFMqYLSm/9aYt7gabyoOe
         vWXhKdv6mxVSlhZIE6Ml9IPY4u5MLv9a0/AAmJp98eN1NAa+RZt5CLQgO6LSkmXaKOw2
         fvuQ==
X-Gm-Message-State: AOAM533gOlGZCnOiFS1OUVRkvnxSiDm8vicH3vXP4uHCd+Oy6QURz16z
        wF8wJIyxrzRqoJnWopTPwwNfFE8B9no=
X-Google-Smtp-Source: ABdhPJxAtViWOh8RrNs2tJ0PghNzT+TtxcGwTiCAeks/GyS9UmxB2i99gCNBq8k3f3iyZa7GWPzKTw==
X-Received: by 2002:a17:906:25c4:: with SMTP id n4mr30795367ejb.359.1614167054379;
        Wed, 24 Feb 2021 03:44:14 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:14 -0800 (PST)
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
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 12/17] net: dsa: sync static FDB entries on foreign interfaces to hardware
Date:   Wed, 24 Feb 2021 13:43:45 +0200
Message-Id: <20210224114350.2791260-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Reuse the "assisted_learning_on_cpu_port" functionality to always add
entries for user-configured entries on foreign interfaces, even if
assisted_learning_on_cpu_port is not enabled. E.g. in this situation:

   br0
   / \
swp0 dummy0

$ bridge fdb add 02:00:de:ad:00:01 dev dummy0 vlan 1 master static

Results in DSA adding an entry in the hardware FDB, pointing this
address towards the CPU port.

The same is true for entries added to the bridge itself, e.g:

$ bridge fdb add 02:00:de:ad:00:01 dev br0 vlan 1 self local

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 425b3223b7d1..a32875d3dc5f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2556,9 +2556,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			else if (!fdb_info->added_by_user)
 				return NOTIFY_OK;
 		} else {
-			/* Snoop addresses learnt on foreign interfaces
-			 * bridged with us, for switches that don't
-			 * automatically learn SA from CPU-injected traffic
+			/* Snoop addresses added to foreign interfaces
+			 * bridged with us, or the bridge
+			 * itself. Dynamically learned addresses can
+			 * also be added for switches that don't
+			 * automatically learn SA from CPU-injected
+			 * traffic.
 			 */
 			struct net_device *br_dev;
 			struct dsa_slave_priv *p;
@@ -2581,7 +2584,8 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			dp = p->dp;
 			host_addr = true;
 
-			if (!dp->ds->assisted_learning_on_cpu_port)
+			if (!fdb_info->added_by_user &&
+			    !dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
 
 			/* When the bridge learns an address on an offloaded
-- 
2.25.1

