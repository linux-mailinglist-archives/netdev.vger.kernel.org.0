Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88362CF654
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgLDVki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:40:38 -0500
Received: from mx0a-000eb902.pphosted.com ([205.220.165.212]:64792 "EHLO
        mx0a-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbgLDVki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 16:40:38 -0500
Received: from pps.filterd (m0220295.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B4LZKGx031219;
        Fri, 4 Dec 2020 15:39:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pps1;
 bh=LVZhJaGi2PENiNxum3D8EIr7/2VbOJTnFsHDSTUb4ws=;
 b=QxdnNmbAxnHUF2bnz5Ml1Utel7LE/PHlIH3sqSx1ydY6GavQ4ILpE0wyus24eyjq3W85
 bnbgpgm1RJHopTqiPsfE/JZzi5RKS/oVnsLCjYJPrTx88WK5PyLO2NRVzrQCIrXVnKfQ
 VLBpzt6fbJdvWi8lfD43/pLSC16cxjBfQQDVOpFQOU/ETcxVr7fcHIYmhGquS+ai99S1
 tNrcacTpn5EdHTGQTU4E/8RZ5vQdQC26NERoMrQWUI8lI19lR26dibPic6dD49QxDq6i
 4n5CM26bKQpAZJyyI+8hzMe6vlLhJAWkPlNcVjFz+4N96VGYhEstWC18Y1go+ezVzN0p yA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-000eb902.pphosted.com with ESMTP id 355wbyn015-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 15:39:47 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0+s/h8cFtMK4hiWa9pkFLKgZ4E0vbF0zEN1zKwOA0P2SkUFDAWLYbtprflgq1u0zTZeShFyfEESM0+XLx7bi3s5T7XZdSaMrdz4BSNBDGeVxrvGK9SMAeaPEBX5kamCgB/kOX3dAnh8JBjDmn+pxBWj80GiwV95iUMi6UpslecII14xXWxx94bnQP6LTl2EJyBnlz3dTpfec616vnWtMroPAyIQ7VDHry+VoN5g3FpqwVQQ2oRJVeRpHOZGlFF0GKhQX6ox8/FpltUHYrHurx5gNtfvQX/PBl3/cyRMwKs6lCM/xeP7rMXNW8RS6ayzceCczyGFEIM20Zcc3lFSkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVZhJaGi2PENiNxum3D8EIr7/2VbOJTnFsHDSTUb4ws=;
 b=au/XdhR0XoSN6qlIkJ59s9Rou5Cg5Q5yRlN5KrOTagAONd36qox31z8fWVBdxng8zAyCp0rb+WxhR1Nhv9yV1E0slshu34lUh8KXFhadO8Ij8gu9m2v3XuVn2L9Ujre7bi9cU0qt1Dpuu8J2yWkX5EJzBxAMCL0tiN/t/TCDd7WxzAAsipNM5NHZrYqivPcq3CDGBplATL5iKH2FDkw3eJv5qp3DEfL/8/s0YSF3QUbI7Iu7PpfkiCSNfRqgcmUTujTOpy77uzaypmAj/wkxqn575eQd2SN5+6R4zCKaOOqnUkdaJKVgY1+ysQt1szJL5QenHpdIamHkpSNCxzElBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVZhJaGi2PENiNxum3D8EIr7/2VbOJTnFsHDSTUb4ws=;
 b=rRAoZXq5RXOJZolDhZ9Wus8/xswQLL76EFbmXhULFOxXWwnYW9ZrCaVjEcUbib3os+kNt8QrqrADhzXCa+tkN53HzuF+X/W2mJk8mFCjAH+OBX71yPl0VbADVit8mb0/4IeyNGxBOSXvC+9Kl6g89qBlaRC6zKXGqYRNYetZTnbZlVoDzPIZgEJFdPZP9MBMHT7lDGeLtnVGwtljhu0f/fg9KXK1FSAgtLnNxeSrjzgqPl4RpCFxaBWWuXdrE17Tj/6XS+vpt7XGoPuXISWkFZT63LXjxsaTWqiB6xmkqGTL0+ptRrd8Ji+sohjzkbXF5+dmGZLFv0B0ITMRX1bGtQ==
Received: from MWHPR1401CA0003.namprd14.prod.outlook.com
 (2603:10b6:301:4b::13) by BY5PR04MB6659.namprd04.prod.outlook.com
 (2603:10b6:a03:21a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 21:39:46 +0000
Received: from MW2NAM10FT010.eop-nam10.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::42) by MWHPR1401CA0003.outlook.office365.com
 (2603:10b6:301:4b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend
 Transport; Fri, 4 Dec 2020 21:39:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT010.mail.protection.outlook.com (10.13.155.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.20 via Frontend Transport; Fri, 4 Dec 2020 21:39:45 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge2.garmin.com (10.60.4.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Fri, 4 Dec 2020 15:39:40 -0600
Received: from huangjoseph-vm1.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Fri, 4 Dec 2020 15:39:44 -0600
From:   Joseph Huang <Joseph.Huang@garmin.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Joseph Huang <Joseph.Huang@garmin.com>
Subject: [PATCH v2] bridge: Fix a deadlock when enabling multicast snooping
Date:   Fri, 4 Dec 2020 16:39:00 -0500
Message-ID: <20201204213900.234913-1-Joseph.Huang@garmin.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201214047.128948-1-Joseph.Huang@garmin.com>
References: <20201201214047.128948-1-Joseph.Huang@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) To
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25)
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c87b28d-6862-4316-1f50-08d8989d1e3b
X-MS-TrafficTypeDiagnostic: BY5PR04MB6659:
X-Microsoft-Antispam-PRVS: <BY5PR04MB66599A08DA087B8F1137DED7FBF10@BY5PR04MB6659.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1KtnmXJ3wfsBKQyzfLVethrZt0w0YbCPqXYeGzHUSrw4+V2dkbIHKpM9L3Q/SLYTncYnSBfHxGNSGDFL5YYkjCv4WdO2GF5Lz2+YJzH4Cf8Vj28w5pna7ThE/nOfu+T3YhQ8v38EKPzQCFcBt3XOTP73EwUoLjafnt70+/zBjg5Ss4PzIqgH1p3Hhyp7yuzRNTc/11k8QY+oxxhkxYzaSbMVWZ8NRsLfy0Phh06ZTlckJ1+feSneTvg2L9qikTWoF1yUojHVOhBhudeHNggf73sJOiqKDQWq7LeNLzOBSHiDshND0MQ1NPTXxtK5WjxARwLN6TNPWWqBEdkP3/5h6Y6upvoZ/6h1ZuNNFHTgkJeDdBx9FVLy9oySkeH0j9ycdqm3pYoPSwsv8HejnpN4lapLzjw5Rp1jX8ZvR532TaE=
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(376002)(396003)(136003)(346002)(39860400002)(46966005)(82740400003)(186003)(336012)(478600001)(83380400001)(82310400003)(36756003)(107886003)(8936002)(110136005)(7696005)(86362001)(316002)(426003)(70586007)(8676002)(70206006)(1076003)(47076004)(2616005)(7636003)(356005)(26005)(5660300002)(4326008)(2906002)(6666004)(309714004);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 21:39:45.5974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c87b28d-6862-4316-1f50-08d8989d1e3b
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM10FT010.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6659
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_12:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When enabling multicast snooping, bridge module deadlocks on multicast_lock
if 1) IPv6 is enabled, and 2) there is an existing querier on the same L2
network.

The deadlock was caused by the following sequence: While holding the lock,
br_multicast_open calls br_multicast_join_snoopers, which eventually causes
IP stack to (attempt to) send out a Listener Report (in igmp6_join_group).
Since the destination Ethernet address is a multicast address, br_dev_xmit
feeds the packet back to the bridge via br_multicast_rcv, which in turn
calls br_multicast_add_group, which then deadlocks on multicast_lock.

The fix is to move the call br_multicast_join_snoopers outside of the
critical section. This works since br_multicast_join_snoopers only deals
with IP and does not modify any multicast data structures of the bridge,
so there's no need to hold the lock.

Steps to reproduce:
1. sysctl net.ipv6.conf.all.force_mld_version=1
2. have another querier
3. ip link set dev bridge type bridge mcast_snooping 0 && \
   ip link set dev bridge type bridge mcast_snooping 1 < deadlock >

A typical call trace looks like the following:

[  936.251495]  _raw_spin_lock+0x5c/0x68
[  936.255221]  br_multicast_add_group+0x40/0x170 [bridge]
[  936.260491]  br_multicast_rcv+0x7ac/0xe30 [bridge]
[  936.265322]  br_dev_xmit+0x140/0x368 [bridge]
[  936.269689]  dev_hard_start_xmit+0x94/0x158
[  936.273876]  __dev_queue_xmit+0x5ac/0x7f8
[  936.277890]  dev_queue_xmit+0x10/0x18
[  936.281563]  neigh_resolve_output+0xec/0x198
[  936.285845]  ip6_finish_output2+0x240/0x710
[  936.290039]  __ip6_finish_output+0x130/0x170
[  936.294318]  ip6_output+0x6c/0x1c8
[  936.297731]  NF_HOOK.constprop.0+0xd8/0xe8
[  936.301834]  igmp6_send+0x358/0x558
[  936.305326]  igmp6_join_group.part.0+0x30/0xf0
[  936.309774]  igmp6_group_added+0xfc/0x110
[  936.313787]  __ipv6_dev_mc_inc+0x1a4/0x290
[  936.317885]  ipv6_dev_mc_inc+0x10/0x18
[  936.321677]  br_multicast_open+0xbc/0x110 [bridge]
[  936.326506]  br_multicast_toggle+0xec/0x140 [bridge]

Fixes: 4effd28c1245 ("bridge: join all-snoopers multicast address")
Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
---
 net/bridge/br_device.c    |  6 ++++++
 net/bridge/br_multicast.c | 33 ++++++++++++++++++++++++---------
 net/bridge/br_private.h   | 10 ++++++++++
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 7730c8f3cb53..d3ea9d0779fb 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -177,6 +177,9 @@ static int br_dev_open(struct net_device *dev)
 	br_stp_enable_bridge(br);
 	br_multicast_open(br);
 
+	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		br_multicast_join_snoopers(br);
+
 	return 0;
 }
 
@@ -197,6 +200,9 @@ static int br_dev_stop(struct net_device *dev)
 	br_stp_disable_bridge(br);
 	br_multicast_stop(br);
 
+	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		br_multicast_leave_snoopers(br);
+
 	netif_stop_queue(dev);
 
 	return 0;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index eae898c3cff7..426fe00db708 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3286,7 +3286,7 @@ static inline void br_ip6_multicast_join_snoopers(struct net_bridge *br)
 }
 #endif
 
-static void br_multicast_join_snoopers(struct net_bridge *br)
+void br_multicast_join_snoopers(struct net_bridge *br)
 {
 	br_ip4_multicast_join_snoopers(br);
 	br_ip6_multicast_join_snoopers(br);
@@ -3317,7 +3317,7 @@ static inline void br_ip6_multicast_leave_snoopers(struct net_bridge *br)
 }
 #endif
 
-static void br_multicast_leave_snoopers(struct net_bridge *br)
+void br_multicast_leave_snoopers(struct net_bridge *br)
 {
 	br_ip4_multicast_leave_snoopers(br);
 	br_ip6_multicast_leave_snoopers(br);
@@ -3336,9 +3336,6 @@ static void __br_multicast_open(struct net_bridge *br,
 
 void br_multicast_open(struct net_bridge *br)
 {
-	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
-		br_multicast_join_snoopers(br);
-
 	__br_multicast_open(br, &br->ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
 	__br_multicast_open(br, &br->ip6_own_query);
@@ -3354,9 +3351,6 @@ void br_multicast_stop(struct net_bridge *br)
 	del_timer_sync(&br->ip6_other_query.timer);
 	del_timer_sync(&br->ip6_own_query.timer);
 #endif
-
-	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
-		br_multicast_leave_snoopers(br);
 }
 
 void br_multicast_dev_del(struct net_bridge *br)
@@ -3487,6 +3481,8 @@ static void br_multicast_start_querier(struct net_bridge *br,
 int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 {
 	struct net_bridge_port *port;
+	bool join_snoopers = false;
+	bool leave_snoopers = false;
 
 	spin_lock_bh(&br->multicast_lock);
 	if (!!br_opt_get(br, BROPT_MULTICAST_ENABLED) == !!val)
@@ -3495,7 +3491,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 	br_mc_disabled_update(br->dev, val);
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
-		br_multicast_leave_snoopers(br);
+		leave_snoopers = true;
 		goto unlock;
 	}
 
@@ -3506,9 +3502,28 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 	list_for_each_entry(port, &br->port_list, list)
 		__br_multicast_enable_port(port);
 
+	join_snoopers = true;
+
 unlock:
 	spin_unlock_bh(&br->multicast_lock);
 
+	/* br_multicast_join_snoopers has the potential to cause
+	 * an MLD Report/Leave to be delivered to br_multicast_rcv,
+	 * which would in turn call br_multicast_add_group, which would
+	 * attempt to acquire multicast_lock. This function should be
+	 * called after the lock has been released to avoid deadlocks on
+	 * multicast_lock.
+	 *
+	 * br_multicast_leave_snoopers does not have the problem since
+	 * br_multicast_rcv first checks BROPT_MULTICAST_ENABLED, and
+	 * returns without calling br_multicast_ipv4/6_rcv if it's not
+	 * enabled. Moved both functions out just for symmetry.
+	 */
+	if (join_snoopers)
+		br_multicast_join_snoopers(br);
+	else if (leave_snoopers)
+		br_multicast_leave_snoopers(br);
+
 	return 0;
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 345118e35c42..8424464186a6 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -792,6 +792,8 @@ void br_multicast_del_port(struct net_bridge_port *port);
 void br_multicast_enable_port(struct net_bridge_port *port);
 void br_multicast_disable_port(struct net_bridge_port *port);
 void br_multicast_init(struct net_bridge *br);
+void br_multicast_join_snoopers(struct net_bridge *br);
+void br_multicast_leave_snoopers(struct net_bridge *br);
 void br_multicast_open(struct net_bridge *br);
 void br_multicast_stop(struct net_bridge *br);
 void br_multicast_dev_del(struct net_bridge *br);
@@ -969,6 +971,14 @@ static inline void br_multicast_init(struct net_bridge *br)
 {
 }
 
+static inline void br_multicast_join_snoopers(struct net_bridge *br)
+{
+}
+
+static inline void br_multicast_leave_snoopers(struct net_bridge *br)
+{
+}
+
 static inline void br_multicast_open(struct net_bridge *br)
 {
 }
-- 
2.29.2

