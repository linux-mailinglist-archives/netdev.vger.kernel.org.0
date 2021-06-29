Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3202B3B73EA
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhF2OK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbhF2OKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:10:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A38BC061226
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:32 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id i5so31540005eds.1
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BOMzh8BvHskVBrXcwAoloE2yOIC+E69XRfT1jHkRC1Q=;
        b=fO/0/fnnnR63NQyNWELQzWLeqGg3F+vEXP6dbYjC8bNeQw7J3Bjmb4WxBhj3tjx/ns
         s2okUXZC6wkt2i96ClUKWd69J+f33i+V5l9LVv2nLe8JOUftGJVogTJTm/yD3rxp2Cn5
         ZDLL26CuapdYY9r2iLrozwTnVHdLYy2+/4fSuJbUyfiitKny6iCdiXhvaa7TWAkXIWYM
         z0qgN4O/f+mQA0xQoEdZpDeuoMtLicmD3kENRvCOefpqnb/Wjt/ewL+AhLGjpbDCuY0v
         bxkBsWzh1s84j/IQZaKo//A7+yM6sQxdx5DQKIMpGlzQRF6tiaeZ/BPjFUJni0X9D4IH
         mSiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BOMzh8BvHskVBrXcwAoloE2yOIC+E69XRfT1jHkRC1Q=;
        b=rL+2d7IopjVxIAVJysyRpBQYj5+ZM87O3qITJefFVSocb4PNOsg6XqLcFqhIptj//V
         LqpflAQRddZnk1BcPoC068PYm19NVMgyU7wb9a4pWjMNcwntkprUa3qEWzLoN/hZuQS6
         1FzGSTIgJne5rfNOPkKWXQrq7w8rEwzB2lMVOIopuOcgsIk+2gcFR0zk33Go13yjmtgI
         PawY5IZNvHry81hffxgp1zV0/0m6cQ/WPYDWP8I2U+kh/eycYaybh2Lk9SQcT2gfvJuL
         6SaIn3xvQQ0FNXZcA+jOwn/gcjRIO5ADNx9Ip1R2xMAoYBNcjWU1Zk2auR/W/kW59k4Y
         DLQQ==
X-Gm-Message-State: AOAM532jTsU2PbtczZlde894IFP8sjRgMF7xnkarCWg16CegRpijOS2m
        GsmWdmicZ8fuLI8RlfuS+09Y1m1RHwE=
X-Google-Smtp-Source: ABdhPJxodBWegIv9JxWdAxD3DDeD8A6DYVxOsxaHi9l21ZpnZLIkC/D/5eejp45sFGwnHFlrcqFvww==
X-Received: by 2002:aa7:d78b:: with SMTP id s11mr5813879edq.280.1624975651063;
        Tue, 29 Jun 2021 07:07:31 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:30 -0700 (PDT)
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
Subject: [PATCH v5 net-next 14/15] net: dsa: ensure during dsa_fdb_offload_notify that dev_hold and dev_put are on the same dev
Date:   Tue, 29 Jun 2021 17:06:57 +0300
Message-Id: <20210629140658.2510288-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When
(a) "dev" is a bridge port which the DSA switch tree offloads, but is
    otherwise not a dsa slave (such as a LAG netdev), or
(b) "dev" is the bridge net device itself

then strange things happen to the dev_hold/dev_put pair:
dsa_schedule_work() will still be called with a DSA port that offloads
that netdev, but dev_hold() will be called on the non-DSA netdev.
Then the "if" condition in dsa_slave_switchdev_event_work() does not
pass, because "dev" is not a DSA netdev, so dev_put() is not called.

This results in the simple fact that we have a reference counting
mismatch on the "dev" net device.

This can be seen when we add support for host addresses installed on the
bridge net device.

ip link add br1 type bridge
ip link set br1 address 00:01:02:03:04:05
ip link set swp0 master br1
ip link del br1
[  968.512278] unregister_netdevice: waiting for br1 to become free. Usage count = 5

It seems foolish to do penny pinching and not add the net_device pointer
in the dsa_switchdev_event_work structure, so let's finally do that.
As an added bonus, when we start offloading local entries pointing
towards the bridge, these will now properly appear as 'offloaded' in
'bridge fdb' (this was not possible before, because 'dev' was assumed to
only be a DSA net device):

00:01:02:03:04:05 dev br0 vlan 1 offload master br0 permanent
00:01:02:03:04:05 dev br0 offload master br0 permanent

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: none

 net/dsa/dsa_priv.h | 1 +
 net/dsa/slave.c    | 9 ++++-----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 36e667ea94db..f201c33980bf 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -116,6 +116,7 @@ struct dsa_notifier_mrp_ring_role_info {
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
+	struct net_device *dev;
 	struct work_struct work;
 	unsigned long event;
 	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a7b5d2a41472..ffbba1e71551 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2349,9 +2349,8 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	}
 	rtnl_unlock();
 
+	dev_put(switchdev_work->dev);
 	kfree(switchdev_work);
-	if (dsa_is_user_port(ds, dp->index))
-		dev_put(dp->slave);
 }
 
 static int dsa_lower_dev_walk(struct net_device *lower_dev,
@@ -2469,15 +2468,15 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		switchdev_work->ds = dp->ds;
 		switchdev_work->port = dp->index;
 		switchdev_work->event = event;
+		switchdev_work->dev = dev;
 
 		ether_addr_copy(switchdev_work->addr,
 				fdb_info->addr);
 		switchdev_work->vid = fdb_info->vid;
 		switchdev_work->host_addr = host_addr;
 
-		/* Hold a reference on the slave for dsa_fdb_offload_notify */
-		if (dsa_is_user_port(dp->ds, dp->index))
-			dev_hold(dev);
+		/* Hold a reference for dsa_fdb_offload_notify */
+		dev_hold(dev);
 		dsa_schedule_work(&switchdev_work->work);
 		break;
 	default:
-- 
2.25.1

