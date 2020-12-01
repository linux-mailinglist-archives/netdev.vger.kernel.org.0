Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABF62CAF38
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgLAV6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:58:05 -0500
Received: from mx0a-000eb902.pphosted.com ([205.220.165.212]:35854 "EHLO
        mx0a-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbgLAV6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:58:04 -0500
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2020 16:58:02 EST
Received: from pps.filterd (m0220296.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B1LT62S031011;
        Tue, 1 Dec 2020 15:41:13 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pps1; bh=sgWCCi2xvV7fzi41aFxypPrNSj2F+DZVhWOB0ye5l7I=;
 b=JmDj2TyMK8ewSYXRv7gkhjjlHAkwJxMCQO+qtjwIEfGIEe2IoRkfH2eeKq/vN7d1OLaO
 oq79RSv5Q9Qchnk746ug4ycwOccja+iqdV70PujXmzfFwoRFuIhTnzVovRg9FGIniLd2
 tQB6+1jI3TYJPpLreNZQ7VpHnhXn6S9Hr7rRyyXGfYyIBXNaCLy7YWpE9ySGxFacTTCC
 npdQLerCmLpUPH92GdIoKWm+J99BbnM+bsYGaEREsUlvQj6/k/HIMd24fyyc8T4jITm1
 GCJwJgrV3jJ/dd3vDKI7NnhF5PQ4uhOIwXvQbuwMoqZVeG/fHv6BdQSVjaby53ZeRq1f Ww== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-000eb902.pphosted.com with ESMTP id 355wbu8226-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 15:41:13 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/qiLuJ6by3zVbh1AJn2q4hctI6dpG/OWD93nTlE7vNgRXlbBhfaclv5XVd1XVh3BcrMXwl3Pe2rhh6XhGlVRojym4i/CC8yQwydF6q4Yfd/uelsC8NPL+q3dI0W/WZznXGwUBXbM7htCC08PkkbDYnje99IRMK5dsTXFFaMObWLOcg96ehcMo9cw2q8cqI97QKEGlaHj6mrbAgUXXx4jfZ0S6bGpCs1+TffRL1No48ko1ssEaakmHvG/tlatGaB2jcI17IXsE47Qu0vaTQ7aU6OhOoImltf2eFawB9oixgMjjm1WAkAkrN8TMc/yUDTf1+5Vi6lUgL5BDeQV8UPqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgWCCi2xvV7fzi41aFxypPrNSj2F+DZVhWOB0ye5l7I=;
 b=ll8890csgKn9uSfAeU2dYhzWvO1oy8aqC+74GYC5HQc3q8vGA8ZqsRW2Tmywul6ejz/jOLb6X2HpIzMklaDLzBidSqH0BMDaUmah9iaFHG4fcorpnyQW+hScNFHAm06e6VRQTUkMn4iqX2KKuD4BxhAUcXwPvPgecsvLHdX1JLiYIaRWF+NkXKxDfQ3X5/J7ZmU9wv2HCh0Kr8r/FyQJKZf4Xkaqwq6BU7SVru2bdrFFkQU1L7W0pZiFqK6R0z0ea1NPo1TVAqkS3ScJ4g4xdmTshCwgH4JQw6/1IeAhs/DQgaZ/X26xYy/EHkiXm5GU6J3njKu7BTmZxiBAgayO0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgWCCi2xvV7fzi41aFxypPrNSj2F+DZVhWOB0ye5l7I=;
 b=DW9uZ0+bMFqEe0QYFMPm2DC5akOYCbQ08tC4MnnZsN0ptc+Q94QdGdMgoUTl/JwpYwvt7dkn+dBRZBH/UlDla9tslnjhiGnCt9fwb/2cuDYa2a9nSmHx1QoLRndfBdcljqYVWA7ekBJS6ge82H8FQb+I5G5FWFxRbIx1IeXfdORfYP1yMlaazS10yVXxp3UG2NK+EhmNDXLVIGxMOny8kfcmQE3C9QEbFVGCCvil4ACDA35wsBE27cLCdb4HYMexMDWnDm1XkMtBaA9aPReb3jQysrDjRiIgvzMvpB5F9IYGEYh9IxIXr6WT3Ft/H9iSTRRyyAT0yq8l8/fW5/VYkQ==
Received: from BN6PR19CA0093.namprd19.prod.outlook.com (2603:10b6:404:133::31)
 by BYAPR04MB3784.namprd04.prod.outlook.com (2603:10b6:a02:b2::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Tue, 1 Dec
 2020 21:41:12 +0000
Received: from BN7NAM10FT050.eop-nam10.prod.protection.outlook.com
 (2603:10b6:404:133:cafe::b8) by BN6PR19CA0093.outlook.office365.com
 (2603:10b6:404:133::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend
 Transport; Tue, 1 Dec 2020 21:41:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 BN7NAM10FT050.mail.protection.outlook.com (10.13.157.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.25 via Frontend Transport; Tue, 1 Dec 2020 21:41:11 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge3.garmin.com (10.60.4.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 1 Dec 2020 15:41:08 -0600
Received: from huangjoseph-vm1.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 1 Dec 2020 15:41:09 -0600
From:   Joseph Huang <Joseph.Huang@garmin.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Joseph Huang <Joseph.Huang@garmin.com>
Subject: [PATCH] bridge: Fix a deadlock when enabling multicast snooping
Date:   Tue, 1 Dec 2020 16:40:47 -0500
Message-ID: <20201201214047.128948-1-Joseph.Huang@garmin.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) To
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25)
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f6863f8-ce1f-4ef7-7850-08d89641d21d
X-MS-TrafficTypeDiagnostic: BYAPR04MB3784:
X-Microsoft-Antispam-PRVS: <BYAPR04MB3784506095119000F45246EFFBF40@BYAPR04MB3784.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYGpeRrZi5vi6hYQAFCZf4oa0qv79Pl0vVpnSbTFzYe67yNoFmZL9/341wNm0J6iUob48kNsOzH23OkXOBPk7wCOn4dGKkUbom7xwBaiXWjcdYYvg9zndlKxXyexHZEufkuXnr0aAelWwBxWKnXKDPtd9cwRXx8CnBiQkzKJCUe+Z+mPGXMsIy0n5+dkOysCpVIWdPYXxphXydwRzOVLrQf2z6BMawf551YyeU2LeB9GHmjUcEzow7PvvNSiEQ1zP9V6bhc5rB8niggQpFHkN4T7xF5XEsjw43nTj/XTEvHgPwbQA/qzO+IqbLq0nm3qWIVhyrWERgVhrzvWMomqhVs5GKNFrUuEdmQlzo84VjPO1TRhMG4pEP2Am9Fv677vKmJtBr/2s+ZcRklieUcAaA==
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(136003)(39850400004)(346002)(396003)(376002)(46966005)(7636003)(26005)(316002)(70586007)(426003)(110136005)(70206006)(8936002)(107886003)(336012)(5660300002)(83380400001)(2616005)(86362001)(8676002)(1076003)(4326008)(7696005)(186003)(36756003)(478600001)(47076004)(82740400003)(6666004)(356005)(82310400003)(2906002);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 21:41:11.3933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f6863f8-ce1f-4ef7-7850-08d89641d21d
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: BN7NAM10FT050.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3784
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxlogscore=982
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
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

Fixes: 4effd28c1245 ("bridge: join all-snoopers multicast address")

Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
---
 net/bridge/br_device.c    | 3 +++
 net/bridge/br_multicast.c | 8 ++++----
 net/bridge/br_private.h   | 5 +++++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 7730c8f3cb53..8d3ec29d3875 100644
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
 
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index eae898c3cff7..6c8d6b2eed91 100644
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
@@ -3336,9 +3336,6 @@ static void __br_multicast_open(struct net_bridge *br,
 
 void br_multicast_open(struct net_bridge *br)
 {
-	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
-		br_multicast_join_snoopers(br);
-
 	__br_multicast_open(br, &br->ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
 	__br_multicast_open(br, &br->ip6_own_query);
@@ -3509,6 +3506,9 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
 unlock:
 	spin_unlock_bh(&br->multicast_lock);
 
+	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		br_multicast_join_snoopers(br);
+
 	return 0;
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 345118e35c42..7085dd747130 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -792,6 +792,7 @@ void br_multicast_del_port(struct net_bridge_port *port);
 void br_multicast_enable_port(struct net_bridge_port *port);
 void br_multicast_disable_port(struct net_bridge_port *port);
 void br_multicast_init(struct net_bridge *br);
+void br_multicast_join_snoopers(struct net_bridge *br);
 void br_multicast_open(struct net_bridge *br);
 void br_multicast_stop(struct net_bridge *br);
 void br_multicast_dev_del(struct net_bridge *br);
@@ -969,6 +970,10 @@ static inline void br_multicast_init(struct net_bridge *br)
 {
 }
 
+static inline void br_multicast_join_snoopers(struct net_bridge *br)
+{
+}
+
 static inline void br_multicast_open(struct net_bridge *br)
 {
 }
-- 
2.29.2

