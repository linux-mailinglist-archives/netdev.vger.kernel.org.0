Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619CE2CF7BD
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgLDX5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 18:57:30 -0500
Received: from mx0b-000eb902.pphosted.com ([205.220.177.212]:63164 "EHLO
        mx0b-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725847AbgLDX5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 18:57:30 -0500
Received: from pps.filterd (m0220299.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B4Nuf3t012888;
        Fri, 4 Dec 2020 17:56:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pps1;
 bh=zqXsF6l9tXT+qxlWWgAJIfKFp4LyuDX1RGy/o/fvOMg=;
 b=ktaH0k1UEQ6j14uKw25s21izTnlUoVrSTbcO/DmsDxDgCb+4ZI9RZz2cVNwdy9jpTnMA
 qAhor/CzGFTW8XAlbvDqo1SxcDl3lW6yYewZNBo3edx5Co/UhxM8gelCj3if2uqaqIGm
 hpyFhTg3j8of5SYvOMgq7uE+x5pnaHCXEA5RoGHQRpXC0p4jB6N1IF/mL4iPpgf5dX4S
 qYVKDySU7EMAssnsIUA2BDhmFhuu61RD50rKpQlRulUtwOXutmOv2+MXp6OmFeYIB0uA
 ZDZjBSpcCrAV0yLcSy1Tyw1zMxjH9DF/ps7c+HtgqWumi0Nmrzrrm9axPyMVL8wFBtt1 lg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-000eb902.pphosted.com with ESMTP id 355wbrd41b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 17:56:40 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0euvbcs9q684E2X1Bo8ZoH2AP6yqdVk/d/gIwIKWr+PgR60EKA4Q+cjoFIvr/VV49lSSAc/Q0pJIMR0g1sTh7u6yjs4kMHmIkjA9xs8nhTa0838doh9RVX5953ppX2xjWAEOwmMPJ+XCnLVXzWg6ttMclesCza1pNA6J97Bz08frydGi5ojFzWpisQ27Yn/8x8yJil6YI/Vz5Gc1fulifEhwgwFW7HwgQ2g8Jyaj5l/5JvLh8YVKRU5wff4fXBuBA5Y8p9Wqm2FQ7go1FqoPdVHxVSBLyRWyTR65RLZqd3t3b4IyRcIcgSj5yk0x3eYky8iuMoZ2inrP6geYIHe8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqXsF6l9tXT+qxlWWgAJIfKFp4LyuDX1RGy/o/fvOMg=;
 b=L0nIC5Nj51iXSt2uuzpBYXIHLIF8ulUogg3oFg3Av4Vy/V4kjzE7hM8dGiWLrLBxkcoezLNNrjciqnfaolilcFWGDV2e8ABqcrZziFNoNac93DKUhMyoxS4rhNuIUWUJ7tyfaVWQW6Ceu8pcrBQegR+Tx+/Ph1z0WM++CGcZoFWa7b7e4IV5sPLPOnHivW8hDH+lzk8eRWYTQ+ftBzqRCcCcZ/JWO8riVPTtC/4Mgwq8/vkD9O+tOY19A/v0GiQajxQeVGODGeg2QeZFA/AfUbsEniL/h9pe8/qP+AxPFppBnd/dAYVIsP1Pjz9Ax2fNenfjmVOLI7E3k9Bb7ar/nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqXsF6l9tXT+qxlWWgAJIfKFp4LyuDX1RGy/o/fvOMg=;
 b=b1S6kqiWPvQ9WtP6YgJsuwnEcmr1A0r7vPZ07k6B8dD051n39bjf+Osh8UOarJw9rahaD+nrN9xWcCUGyl9y33oEb6eW6y3FyB09coYlh/+kPXjF3ilUFLty5dRPm9wl4LWCjozmfAqUMR7pFsPF0Fed81K48sUPTh0eC24jgcDK6cJSlOejn1ZjiiYDW/522FH9eRW7cFrLpW+Xcyy2ZZVQbVSxPDP06AulOuv4Xk5W5M+ckSNE1kvoMtjas4CQyj159BQAFRByjJdqJFp4RVNjDd3VAbpXYrvbjOpy9EMxHsVd7xW3ltN9I0XaS6hgRCqDHqaQcpT5iaxVFZckvw==
Received: from DM5PR11CA0016.namprd11.prod.outlook.com (2603:10b6:3:115::26)
 by BYAPR04MB5015.namprd04.prod.outlook.com (2603:10b6:a03:47::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 23:56:37 +0000
Received: from DM6NAM10FT018.eop-nam10.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::62) by DM5PR11CA0016.outlook.office365.com
 (2603:10b6:3:115::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend
 Transport; Fri, 4 Dec 2020 23:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 DM6NAM10FT018.mail.protection.outlook.com (10.13.153.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.20 via Frontend Transport; Fri, 4 Dec 2020 23:56:37 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge3.garmin.com (10.60.4.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Fri, 4 Dec 2020 17:56:35 -0600
Received: from huangjoseph-vm1.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Fri, 4 Dec 2020 17:56:35 -0600
From:   Joseph Huang <Joseph.Huang@garmin.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Joseph Huang <Joseph.Huang@garmin.com>
Subject: [PATCH v3] bridge: Fix a deadlock when enabling multicast snooping
Date:   Fri, 4 Dec 2020 18:56:28 -0500
Message-ID: <20201204235628.50653-1-Joseph.Huang@garmin.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201214047.128948-1-Joseph.Huang@garmin.com>
References: <20201201214047.128948-1-Joseph.Huang@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB1.ad.garmin.com (10.5.144.23) To
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25)
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bd85882-bba1-402e-51c3-08d898b03cc3
X-MS-TrafficTypeDiagnostic: BYAPR04MB5015:
X-Microsoft-Antispam-PRVS: <BYAPR04MB5015689B967F08D49DD89CF0FBF10@BYAPR04MB5015.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y++goESoAC39gZfAk2cU1tMMtuqyTAN+/m8HG8m1TQQOMnh0MjMHIV6+sLYNlgjm4szkjJn6gpmvK8S2J4yOP/ETSuk0NEgRAasf6Mi9ThoQrDpmlbFy1kTrV5SmCJt4eO01g0dVf16K7797/pnsd4KT+1wMq79GVcz8kCbYXi5IrZSu6u8S2AYmPjvAgnt60hn8YXevswGOcjCQRPJrZPBVEfAWWQj1iAxnO4z4XICxOKMqUWHgw9nhno/6YCpp4i4mLHHKepumbr+j6nRRQr3QGIFqMwuRWYkJ8G8RFRIWbLouGlbkkoILEPEH4NvaR1uvhxC3+HjbaeTLAVzz+qeFbi2Iszo1C7kA6SV02DdAcRLm2qrFO4FfRuKkXgBKNgFNmOwx9CG1iuGi2UW2w4tHA9NcMgt4ze+oQ0P/j/k=
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(346002)(46966005)(26005)(47076004)(36756003)(426003)(4326008)(336012)(2616005)(70586007)(82740400003)(110136005)(83380400001)(316002)(1076003)(5660300002)(70206006)(478600001)(356005)(7636003)(8676002)(82310400003)(86362001)(2906002)(7696005)(6666004)(186003)(107886003)(8936002)(309714004);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 23:56:37.2545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd85882-bba1-402e-51c3-08d898b03cc3
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT018.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5015
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_13:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040137
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
 net/bridge/br_multicast.c | 34 +++++++++++++++++++++++++---------
 net/bridge/br_private.h   | 10 ++++++++++
 3 files changed, 41 insertions(+), 9 deletions(-)

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
index eae898c3cff7..54cb82a69056 100644
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
@@ -3487,6 +3481,7 @@ static void br_multicast_start_querier(struct net_bridge *br,
 int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 {
 	struct net_bridge_port *port;
+	bool change_snoopers = false;
 
 	spin_lock_bh(&br->multicast_lock);
 	if (!!br_opt_get(br, BROPT_MULTICAST_ENABLED) == !!val)
@@ -3495,7 +3490,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 	br_mc_disabled_update(br->dev, val);
 	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
-		br_multicast_leave_snoopers(br);
+		change_snoopers = true;
 		goto unlock;
 	}
 
@@ -3506,9 +3501,30 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 	list_for_each_entry(port, &br->port_list, list)
 		__br_multicast_enable_port(port);
 
+	change_snoopers = true;
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
+	if (change_snoopers) {
+		if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
+			br_multicast_join_snoopers(br);
+		else
+			br_multicast_leave_snoopers(br);
+	}
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

