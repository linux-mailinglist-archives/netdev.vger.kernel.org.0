Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E173471058
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345694AbhLKCGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345710AbhLKCF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:05:57 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C6EC061746;
        Fri, 10 Dec 2021 18:02:21 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x10so17834775edd.5;
        Fri, 10 Dec 2021 18:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bt2e9cpzmKNi/ZkvQlAApQrFQuwVRyt+mcfwXyAkA5w=;
        b=Kpb0e18Uzc2SI9ztXe2c9wj2DRYGcRxaLyvpHHVMLGLm1qgnwZO5uUul4mk6xUk1dA
         rWArBU7Y5Xrnmc4YPMMVecseQCmQ4oYLwhuo9rwGqiwUmRI9+d6QIWA4A8Ia587vCXmw
         a/JSZYqvsBCN319Giwq1+AoM/VVPlrqGxOn1goDiH/jgLczIXFQzlfE6lyWOIgLRaCW1
         wmOirV8I1bWWGKumaQBVN43Pv5WOOjRQVjo+M8MZdzEdL0X8N5wwFfa/49OKf+m7pN5U
         WqYI77NMwMc3I+jx+miO0/2pDAxmLq6df0DviijGqBgH6MtjY45mYeZ+jTSsj9Jz4VwR
         qmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bt2e9cpzmKNi/ZkvQlAApQrFQuwVRyt+mcfwXyAkA5w=;
        b=t2U8+fJo5EgScGkJjDkoANH5x9Wuqa9I1SBJ0wP20rpPTcce6vKitQzFoLeJFGDthp
         4NmrrW+fwU3OzLlR6jvDZKKk8pB68/jGuF/4yoscZBObMnGJDfx7Le9ke/snHHgYEcGc
         uwDVfqmiXvKU1vrWvM2dQdsGq+EmmwyBcx+LKVKYDCGwCiUAwblfxYfkB6rLoFYXEhRT
         0EMQp93kEZKV9EYeBHQEWWo7SX6KJujqaNmMDQJCakvvr6XsfBmuItNHYzd1m7bOULZZ
         E4BHBWnr3d5mNy9SOi+Qw03WEpMvi2P8NJEcZ2FkdxNw9CNr7WOinOzkLHjdFBdZH1CV
         00yA==
X-Gm-Message-State: AOAM530e6WlBCX8OIfS/2f/aMA5jMzB83OcLobizKlr7DFxus/IGQKYq
        ic6Q7usHew3Dhewb/uxful0=
X-Google-Smtp-Source: ABdhPJzgr/HHQYL45p2ThoOiXEqbYqYMYLopVCCUC21FVGgUQpx5HrYwLDwmQfnZ2vu22nCj3Ov/zg==
X-Received: by 2002:a17:906:974a:: with SMTP id o10mr28510027ejy.226.1639188140083;
        Fri, 10 Dec 2021 18:02:20 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:19 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v3 03/15] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
Date:   Sat, 11 Dec 2021 03:01:35 +0100
Message-Id: <20211211020155.10114-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA needs to simulate master tracking events when a binding is first
with a DSA master established and torn down, in order to give drivers
the simplifying guarantee that ->master_state_change calls are made
only when the master's readiness state to pass traffic changes.
master_state_change() provide a operational bool that DSA driver can use
to understand if DSA master is operational or not.
To avoid races, we need to block the reception of
NETDEV_UP/NETDEV_CHANGE/NETDEV_GOING_DOWN events in the netdev notifier
chain while we are changing the master's dev->dsa_ptr (this changes what
netdev_uses_dsa(dev) reports).

The dsa_master_setup() and dsa_master_teardown() functions optionally
require the rtnl_mutex to be held, if the tagger needs the master to be
promiscuous, these functions call dev_set_promiscuity(). Move the
rtnl_lock() from that function and make it top-level.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/dsa2.c   | 8 ++++++++
 net/dsa/master.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 86b1e2f11469..90e29dd42d3d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1030,6 +1030,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 	struct dsa_port *dp;
 	int err;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
 			err = dsa_master_setup(dp->master, dp);
@@ -1038,6 +1040,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 		}
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -1045,9 +1049,13 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dsa_port_is_cpu(dp))
 			dsa_master_teardown(dp->master);
+
+	rtnl_unlock();
 }
 
 static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index f4efb244f91d..2199104ca7df 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -267,9 +267,9 @@ static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
 	if (!ops->promisc_on_master)
 		return;
 
-	rtnl_lock();
+	ASSERT_RTNL();
+
 	dev_set_promiscuity(dev, inc);
-	rtnl_unlock();
 }
 
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
-- 
2.32.0

