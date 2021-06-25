Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F30F3B48FD
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFYS4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhFYS4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 14:56:00 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6091EC061766
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:38 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id q14so14731172eds.5
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QvCIHQKKDX8CZrS8dG3PyVrwdkerRVkHP04lq1nqeC0=;
        b=GjY4n1TTMfwsNzfbD2KPRLQzK1eIDrAnMLeOg7ZRIpmV38h6SDuiZXBO52WOMrb6hU
         W8a8TPHgqY3pT3rgeppSLqrmlueAv6GtUK83iDNG0xjKslEuAjBx9nfOa+c+U6H9knGZ
         ZeF+lKfR3xacxclz+IHiF3CuKtqF3KUYJuVI3lBQ4B2bBG+57a+xMw3quO0J6lVDylEq
         nXcz933WoFj6sOQLnxAuj3DXEJyWaE9NiEr8BbFKH+f/1zRvOsBK4FmiyVTBx74/OUM+
         jYtKYOaNWjr4B6U9JkyJNs/8iL7OFfOMTc4Bm/s6GXtYGlhDeLcu5+Zflj4u3RE67JAL
         /n+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QvCIHQKKDX8CZrS8dG3PyVrwdkerRVkHP04lq1nqeC0=;
        b=GZGFr/g3AO4RC/BaIaCitUPcKmhC0F1N0ycYelk6PXp7sLlKGbs++Fyczm9WvExn/D
         KrVrW7SBN0EjE13RpA6qxn87LrQbZjQTDhQsbhwHZuMckFCNyhTjokjjfBst2+o2AoOE
         yC+WK03OTGoQQTbV0ofcf8xunxpuWQ63iRe+2oO2igdTLovLhQAALyptF3ZFzUKFbGJG
         ibtyY1ZAViFsHJ59O69oXMn2I4U1oHGzcTj1lewhowBriAP9UPYH7mKru2fld65uvdH0
         /el2NwpDBzkAzCJj/0w4TrJE/jqD6FOkk3EX2uv1YRXqiKBQd/9W9canbVG/1t1GcU6R
         0g6Q==
X-Gm-Message-State: AOAM530OuJNuHXp/rp8Z8Ix1GwQT7Kf5EKZoHCJK2Qqt5R+68oIB779n
        Eqd+3bq+Ack46/jcSKjJqDQ=
X-Google-Smtp-Source: ABdhPJynRGrh3qN4gLcJtmh2XCl2xgiUPyMy1KyEFLtZH6FbbjwKGFEGkSfl4GUrQs3vxG4BNJeRkg==
X-Received: by 2002:a50:c344:: with SMTP id q4mr16723494edb.197.1624647216898;
        Fri, 25 Jun 2021 11:53:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id w2sm3094954ejn.118.2021.06.25.11.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 11:53:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/7] net: bridge: include the is_local bit in br_fdb_replay
Date:   Fri, 25 Jun 2021 21:53:15 +0300
Message-Id: <20210625185321.626325-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210625185321.626325-1-olteanv@gmail.com>
References: <20210625185321.626325-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since commit 2c4eca3ef716 ("net: bridge: switchdev: include local flag
in FDB notifications"), the bridge emits SWITCHDEV_FDB_ADD_TO_DEVICE
events with the is_local flag populated (but we ignore it nonetheless).

We would like DSA to start treating this bit, but it is still not
populated by the replay helper, so add it there too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 698b79747d32..b8d3ddfe5853 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -737,6 +737,7 @@ static int br_fdb_replay_one(struct notifier_block *nb,
 	item.vid = fdb->key.vlan_id;
 	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
 	item.info.dev = dev;
 
 	err = nb->notifier_call(nb, SWITCHDEV_FDB_ADD_TO_DEVICE, &item);
-- 
2.25.1

