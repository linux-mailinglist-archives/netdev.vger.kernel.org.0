Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C2235B5C5
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 17:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhDKPEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 11:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbhDKPEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 11:04:12 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6EEC061574;
        Sun, 11 Apr 2021 08:03:55 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id sd23so7412538ejb.12;
        Sun, 11 Apr 2021 08:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gpkgEVO/zDb4BQWWCSfcVeMDtwsSzKiUo/BR0+dqhGQ=;
        b=LB0kznnhRE4HdMxic0cno6S/pXZ9A2m6veo9ugsQYOn1RhXtQJ4Xt7Kceb4J6kFZDn
         8GHjlbjK2gCmm/ovmFlasvO4G5HAdtcbdWUKT/iHPKMeXbd6Tq265I54D76/+UW1P/13
         fIU2oIu50xNJdLkWB5u1fUTpuoOuJAMqew6th6PsJRBxRZxaGet7JWI5Iov65Bf/h4TU
         pOcS+kogcKs/4KUzbvHNNFCypqCTomzV0jKG/ZUVT+JBr3/oy7wRMFSojDqARGBePgAZ
         1HCRagX2zPQUCggV/mhFs6L0jr/nvv8cV/DpAdzYQDlVoASsSVqPCeUMOURV9GYXGy47
         Nq3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gpkgEVO/zDb4BQWWCSfcVeMDtwsSzKiUo/BR0+dqhGQ=;
        b=GgkkLJRnKxAeBPj1+t8bMiKLEoFb0IhaFFirgaLZHZ8BSWnzsT/3AUITc7QKzs0BKW
         jxxwvX6gpfjHDE/9xrIv5Sz2bRV/gjzdNyi4tIV72p3BFZr//72JOniveMES3cQlvp9D
         Z76BF1ufzXhENUchn+7jisinu5BTELVGU+NCHUFuasAhbPHVfW6SBliQypMhal0pjyUL
         vTrcbyuTGljUtwD+fMMrwMuOmU/J99iQN8N79CLudSuociJtRXddU0nIFepkEjFYFBwR
         TFq6T2HDqNM9cOAso5aAstw0ldsov54XL5VUVVsILiULisNpd2a89Ml+YgsqwANDmcxD
         H7jw==
X-Gm-Message-State: AOAM53179Mx8HmoAm2lrCilH+cplx/Gp3X34a5oxrEOHjWPiUiVJcVGZ
        hURrZbbGn7xLvAnTnPocHdsKNjhbkF8HvA==
X-Google-Smtp-Source: ABdhPJy+JvQ0166o8WqSp2IgLWfPP8SzMy2ibsTSzlxr+Q3Xdsj0eDJxPO+h0YbbYq7i3gOGeTfBxg==
X-Received: by 2002:a17:906:5855:: with SMTP id h21mr23953848ejs.522.1618153433944;
        Sun, 11 Apr 2021 08:03:53 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-95-239-254-7.retail.telecomitalia.it. [95.239.254.7])
        by smtp.googlemail.com with ESMTPSA id l15sm4736146edb.48.2021.04.11.08.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 08:03:53 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC net-next 1/3] net: dsa: allow for multiple CPU ports
Date:   Sat, 10 Apr 2021 15:34:47 +0200
Message-Id: <20210410133454.4768-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210410133454.4768-1-ansuelsmth@gmail.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow for multiple CPU ports in a DSA switch tree. By default the first
CPU port is assigned mimic the original assignement logic. A DSA driver
can define a function to declare a preferred CPU port based on the
provided port. If the function doesn't have a preferred port the CPU
port is assigned using a round-robin way starting from the last assigned
CPU port.
Examples:
There are two CPU port but no port_get_preferred_cpu is provided:
- The old logic is used. Every port is assigned to the first cpu port.
There are two CPU port but the port_get_preferred_cpu return -1:
- The port is assigned using a round-robin way since no preference is
  provided.
There are two CPU port and the port_get_preferred_cpu define only one
port and the rest with -1: (wan port with CPU1 and the rest no
preference)
  lan1 <-> eth0
  lan2 <-> eth1
  lan3 <-> eth0
  lan4 <-> eth1
  wan  <-> eth1
There are two CPU port and the port_get_preferred assign a preference
for every port: (wan port with CPU1 everything else CPU0)
  lan1 <-> eth0
  lan2 <-> eth0
  lan3 <-> eth0
  lan4 <-> eth0
  wan  <-> eth1

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/net/dsa.h |  7 +++++
 net/dsa/dsa2.c    | 66 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d71b1acd9c3e..3d3e936bda4c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -523,6 +523,13 @@ struct dsa_switch_ops {
 	void	(*teardown)(struct dsa_switch *ds);
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
 
+	/*
+	 * Get preferred CPU port for the provided port.
+	 * Return -1 if there isn't a preferred CPU port, a round-robin logic
+	 * is used to chose the CPU port to link to the provided port.
+	 */
+	int	(*port_get_preferred_cpu)(struct dsa_switch *ds, int port);
+
 	/*
 	 * Access to the switch's PHY registers.
 	 */
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index d142eb2b288b..d3b92499f006 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -315,10 +315,17 @@ static bool dsa_tree_setup_routing_table(struct dsa_switch_tree *dst)
 	return complete;
 }
 
-static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
+static struct dsa_port *dsa_tree_find_next_cpu_port(struct dsa_switch_tree *dst,
+						    struct dsa_port *cpu_dp)
 {
-	struct dsa_port *dp;
+	struct dsa_port *dp = cpu_dp;
+
+	if (dp)
+		list_for_each_entry_from(dp, &dst->ports, list)
+			if (dsa_port_is_cpu(dp))
+				return dp;
 
+	/* If another CPU port can't be found, try from the start */
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dsa_port_is_cpu(dp))
 			return dp;
@@ -326,25 +333,40 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 	return NULL;
 }
 
-static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
+static int dsa_tree_setup_default_cpus(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *cpu_dp, *dp;
+	struct dsa_port *dp, *cpu_dp = NULL, *first_cpu_dp;
+	int cpu_port;
 
-	cpu_dp = dsa_tree_find_first_cpu(dst);
-	if (!cpu_dp) {
+	first_cpu_dp = dsa_tree_find_next_cpu_port(dst, NULL);
+	if (!first_cpu_dp) {
 		pr_err("DSA: tree %d has no CPU port\n", dst->index);
 		return -EINVAL;
 	}
 
-	/* Assign the default CPU port to all ports of the fabric */
 	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
-			dp->cpu_dp = cpu_dp;
+		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp)) {
+			/* Check if the driver advice a CPU port for the current port */
+			if (dp->ds->ops->port_get_preferred_cpu) {
+				cpu_port = dp->ds->ops->port_get_preferred_cpu(dp->ds, dp->index);
+
+				/* If the driver doesn't have a preferred port,
+				 * assing in round-robin way.
+				 */
+				if (cpu_port < 0)
+					cpu_dp = dsa_tree_find_next_cpu_port(dst, cpu_dp);
+				else
+					cpu_dp = dsa_to_port(dp->ds, cpu_port);
+			}
+
+			/* If a cpu port is not chosen, assign the first one by default */
+			dp->cpu_dp = cpu_dp ? cpu_dp : first_cpu_dp;
+		}
 
 	return 0;
 }
 
-static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
+static void dsa_tree_teardown_default_cpus(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
@@ -822,7 +844,7 @@ static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
 		dsa_switch_teardown(dp->ds);
 }
 
-static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
+static int dsa_tree_setup_masters(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 	int err;
@@ -831,14 +853,20 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 		if (dsa_port_is_cpu(dp)) {
 			err = dsa_master_setup(dp->master, dp);
 			if (err)
-				return err;
+				goto teardown;
 		}
 	}
 
 	return 0;
+teardown:
+	list_for_each_entry_from_reverse(dp, &dst->ports, list)
+		if (dsa_port_is_cpu(dp))
+			dsa_master_teardown(dp->master);
+
+	return err;
 }
 
-static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
+static void dsa_tree_teardown_masters(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
@@ -888,7 +916,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (!complete)
 		return 0;
 
-	err = dsa_tree_setup_default_cpu(dst);
+	err = dsa_tree_setup_default_cpus(dst);
 	if (err)
 		return err;
 
@@ -896,7 +924,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (err)
 		goto teardown_default_cpu;
 
-	err = dsa_tree_setup_master(dst);
+	err = dsa_tree_setup_masters(dst);
 	if (err)
 		goto teardown_switches;
 
@@ -911,11 +939,11 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	return 0;
 
 teardown_master:
-	dsa_tree_teardown_master(dst);
+	dsa_tree_teardown_masters(dst);
 teardown_switches:
 	dsa_tree_teardown_switches(dst);
 teardown_default_cpu:
-	dsa_tree_teardown_default_cpu(dst);
+	dsa_tree_teardown_default_cpus(dst);
 
 	return err;
 }
@@ -929,11 +957,11 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_lags(dst);
 
-	dsa_tree_teardown_master(dst);
+	dsa_tree_teardown_masters(dst);
 
 	dsa_tree_teardown_switches(dst);
 
-	dsa_tree_teardown_default_cpu(dst);
+	dsa_tree_teardown_default_cpus(dst);
 
 	list_for_each_entry_safe(dl, next, &dst->rtable, list) {
 		list_del(&dl->list);
-- 
2.30.2

