Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED5F2EFBB2
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 00:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbhAHXby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 18:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbhAHXby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 18:31:54 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C9AC061574
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 15:31:13 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id h16so12838849edt.7
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 15:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9tt/+49ZDniNyVD+cDVt4FBU84r5+dkoZQPa+VZpXmM=;
        b=ZhmM+pKFQAOp/igVZfi4YfEFvZi4z4/0lDq56ZxTbcs4kYvSEC+tqI8URk29jqR/g9
         2FDm3yP1A/qoZariKNlDIHsUIclNFcMMk6PgyHQI0TLXJ4jKZIue4iRcg/Qr5LE4CHZy
         xJbrtQB7BVcgtpTHnRbuMQ56Uwoet7ICVs/J7P6A4K1QlK8kJ7zEY/50VWP7LXVUDdLB
         a9hvnu3VJDiJAwPomNEQU2cy1WgMPqm37yjtnYXFNHuNeNjkWGfhnTJ3BzxhCyULiCSP
         wZ8g4ic3/LJrXQfHBj/dl2dIglMjbC7KCBKZbijU4qpehzvluUJEKuj3RJSp3zVbGBDA
         Zwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9tt/+49ZDniNyVD+cDVt4FBU84r5+dkoZQPa+VZpXmM=;
        b=JNGWD+OhXCZGbZ0to+cR4y1uN2KIEa8ZmOVSvy232QKFeitgl1tknS/wONBdFoy3+V
         LjHvOYffYBwiAFPjekHVbNahfaBihG/kf7T6AFi7ZTvqQfso01gPxxGXf8iESHdSSVl8
         Y6uECaQMjrWbWQAEYafi2x/l1S/wiVkeg9HJa588l4es0/b6oM3yNuMwVGqWQbUQuma9
         uFtr4D+22lem2Igy9VQqeEfR+xpMKjtEyJWktkdu1XFTnaxa3x80iJ7sVO+pjy+YxBBM
         ZgvUAW2hbK1OQ9fXv/kA3TI1Sunot0TyXWAyPYjzYK/kKhVB/GerKvQgPLFMxyxlkjaY
         pyVw==
X-Gm-Message-State: AOAM530lTd/bOP04KHP8lP8f6VpApKD2eK+blY2Nc4/nDQr9w2adH2LJ
        s2ccTCufTgu1XWNLIs5s2zY=
X-Google-Smtp-Source: ABdhPJzDV6e6EO2lVJGPRNU2zTbyRarJlgubNCQ7jBnQGr6XrYhyQGqytBqXBzNn3g5Tp7V7agFW5w==
X-Received: by 2002:a50:d685:: with SMTP id r5mr7061363edi.248.1610148672338;
        Fri, 08 Jan 2021 15:31:12 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id gl23sm4001577ejb.87.2021.01.08.15.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 15:31:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: dsa_legacy_fdb_{add,del} can be static
Date:   Sat,  9 Jan 2021 01:30:54 +0200
Message-Id: <20210108233054.1222278-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Introduced in commit 37b8da1a3c68 ("net: dsa: Move FDB add/del
implementation inside DSA") in net/dsa/legacy.c, these functions were
moved again to slave.c as part of commit 2a93c1a3651f ("net: dsa: Allow
compiling out legacy support"), before actually deleting net/dsa/slave.c
in 93e86b3bc842 ("net: dsa: Remove legacy probing support"). Along with
that movement there should have been a deletion of the prototypes from
dsa_priv.h, they are not useful.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  9 ---------
 net/dsa/slave.c    | 16 ++++++++--------
 2 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 4f1bbaab72f2..3822520eeeae 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -110,15 +110,6 @@ void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
-int dsa_legacy_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
-		       struct net_device *dev,
-		       const unsigned char *addr, u16 vid,
-		       u16 flags,
-		       struct netlink_ext_ack *extack);
-int dsa_legacy_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
-		       struct net_device *dev,
-		       const unsigned char *addr, u16 vid);
-
 /* master.c */
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
 void dsa_master_teardown(struct net_device *dev);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c8b842ac2600..f8b6a69b6873 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1575,20 +1575,20 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 };
 
 /* legacy way, bypassing the bridge *****************************************/
-int dsa_legacy_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
-		       struct net_device *dev,
-		       const unsigned char *addr, u16 vid,
-		       u16 flags,
-		       struct netlink_ext_ack *extack)
+static int dsa_legacy_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
+			      struct net_device *dev,
+			      const unsigned char *addr, u16 vid,
+			      u16 flags,
+			      struct netlink_ext_ack *extack)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
 	return dsa_port_fdb_add(dp, addr, vid);
 }
 
-int dsa_legacy_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
-		       struct net_device *dev,
-		       const unsigned char *addr, u16 vid)
+static int dsa_legacy_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
+			      struct net_device *dev,
+			      const unsigned char *addr, u16 vid)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
-- 
2.25.1

