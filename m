Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8D92F47B2
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 10:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbhAMJhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 04:37:20 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:54994 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbhAMJhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 04:37:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0ULc.cMI_1610530588;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULc.cMI_1610530588)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Jan 2021 17:36:32 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     roopa@nvidia.com
Cc:     nikolay@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] net/bridge: Fix inconsistent format argument types
Date:   Wed, 13 Jan 2021 17:36:24 +0800
Message-Id: <1610530584-48554-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following warnings:

net/bridge/br_sysfs_br.c(833): warning: %u in format string (no. 1)
requires 'unsigned int' but the argument type is 'signed int'.
net/bridge/br_sysfs_br.c(817): warning: %u in format string (no. 1)
requires 'unsigned int' but the argument type is 'signed int'.
net/bridge/br_sysfs_br.c(261): warning: %ld in format string (no. 1)
requires 'long' but the argument type is 'unsigned long'.
net/bridge/br_sysfs_br.c(253): warning: %ld in format string (no. 1)
requires 'long' but the argument type is 'unsigned long'.
net/bridge/br_sysfs_br.c(244): warning: %ld in format string (no. 1)
requires 'long' but the argument type is 'unsigned long'.
net/bridge/br_sysfs_br.c(236): warning: %ld in format string (no. 1)
requires 'long' but the argument type is 'unsigned long'.

Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot<abaci@linux.alibaba.com>
---
 net/bridge/br_sysfs_br.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 7db06e3..7512921 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -233,7 +233,7 @@ static ssize_t hello_timer_show(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%ld\n", br_timer_value(&br->hello_timer));
+	return sprintf(buf, "%lu\n", br_timer_value(&br->hello_timer));
 }
 static DEVICE_ATTR_RO(hello_timer);
 
@@ -241,7 +241,7 @@ static ssize_t tcn_timer_show(struct device *d, struct device_attribute *attr,
 			      char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%ld\n", br_timer_value(&br->tcn_timer));
+	return sprintf(buf, "%lu\n", br_timer_value(&br->tcn_timer));
 }
 static DEVICE_ATTR_RO(tcn_timer);
 
@@ -250,7 +250,7 @@ static ssize_t topology_change_timer_show(struct device *d,
 					  char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%ld\n", br_timer_value(&br->topology_change_timer));
+	return sprintf(buf, "%lu\n", br_timer_value(&br->topology_change_timer));
 }
 static DEVICE_ATTR_RO(topology_change_timer);
 
@@ -258,7 +258,7 @@ static ssize_t gc_timer_show(struct device *d, struct device_attribute *attr,
 			     char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%ld\n", br_timer_value(&br->gc_work.timer));
+	return sprintf(buf, "%lu\n", br_timer_value(&br->gc_work.timer));
 }
 static DEVICE_ATTR_RO(gc_timer);
 
@@ -814,7 +814,7 @@ static ssize_t vlan_stats_enabled_show(struct device *d,
 				       char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_VLAN_STATS_ENABLED));
+	return sprintf(buf, "%d\n", br_opt_get(br, BROPT_VLAN_STATS_ENABLED));
 }
 
 static ssize_t vlan_stats_enabled_store(struct device *d,
@@ -830,7 +830,7 @@ static ssize_t vlan_stats_per_port_show(struct device *d,
 					char *buf)
 {
 	struct net_bridge *br = to_bridge(d);
-	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_VLAN_STATS_PER_PORT));
+	return sprintf(buf, "%d\n", br_opt_get(br, BROPT_VLAN_STATS_PER_PORT));
 }
 
 static ssize_t vlan_stats_per_port_store(struct device *d,
-- 
1.8.3.1

