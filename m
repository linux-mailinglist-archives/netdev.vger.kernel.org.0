Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA45237300C
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 20:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhEDS5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 14:57:19 -0400
Received: from mx0b-000eb902.pphosted.com ([205.220.177.212]:59526 "EHLO
        mx0b-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230402AbhEDS5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 14:57:19 -0400
Received: from pps.filterd (m0220297.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144IBfwD032360;
        Tue, 4 May 2021 13:23:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pps1;
 bh=oWwVRod8b8WrHwDkrhClUSAxTighTRz6rsTbak1W1Pc=;
 b=VKO5sFkNqFEeWrkvCvAw+TQcRIet3UVfaGZMw1S+hbGaOnUpV1RVOG1dz+bW6s/8PkWu
 Hnd0DBxn+eKyb+jrJBEHVIdP5xfJZ2n0QcSef5ZAKZKgaNc506ZZjUPmem7267Tx4dkJ
 QqV33kgZY/qKlHueaQFomj9Agq6WZWnnS0Ud84R5p1YYE8Ae7GrAD0tOCwP+xOJOO/pr
 Yd8VEBfb6Ra0+u6kvE8DaiKyyu8OwCpWqPqHaUsMk3AuBCBiJrHWYoqF03cjzaMpMvwP
 inSsYS51gtz6LRHcp1kntQ5D/P2LkAQP3ZYOzn85iONP8V8VedpBNfJh0UQhtwoU9cfG Kw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-000eb902.pphosted.com with ESMTP id 38afvgah4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 13:23:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuckEKxZO7OKT05d/FukZgM7xZx0XJTroG3PQIUJLE2aEJXiOka5/IWN31CzoO2689SwbRt4YsFvshQfUGJ7Ry9rAgqCKQTAig5TLd7dsoTVFZvWBlcTiIclgE0wVnTuCb48PVBeiaQvhXHA84KeYQ+hm4ZXUWs0twHtXcPq1zYmCLZXHKRRBA6Vuyha8bNwSusHH6f+IJ5wyU4MBnRAKHtzD9BThtB1bWU1YBjFLDaygoQAaxN5VIfT8rgRZTWkC1hPZ14GjSSzBDeopO7cn+9SW6/kmgiTvv3CzL6C5CEC9Z5sFsXl3F5nLkj1hNIpCqUwgz9eQH8ZCMg1r0JOUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWwVRod8b8WrHwDkrhClUSAxTighTRz6rsTbak1W1Pc=;
 b=FaWUq2qEEvrSG+MAW7uyQ/pYMI75VXSkNkZmBoTq4bRa1a11jrAlsYPEGyzESe0Ru7nQY7f/z+l8sfHa9hUSKUSoTnXU9OdtKeqTC/fWhF88HnyfNcYTpAW/LqEK126fiXFlO4azBA5HKBTxNO5pc7TAtAwQlgvAWzBTvWwMnuxWuSPcAsgYAz30SJmG5DzPQ5ofEUz7xZeTyYl/A+QN3IiF+C5wx39Odb/DJhwzAWyHXqTlA3/MCTK+JKJBQfyzUBUDv9Jocf4HsLku/mXQz7BJ3JFyuhFxguIOSOytEgvsOzTZ/eassOn70bIH8eB104Yb0LEPNo4Zlag7L5Z8/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWwVRod8b8WrHwDkrhClUSAxTighTRz6rsTbak1W1Pc=;
 b=OO+gYD6qXmh/tLUDmgrLjU8InyFriy1rvlRqfvZ45EBYYHfZgf9zJSYu9LAHWVdilLLhBb8ajhe6m0rIpR48DDlXKmKfIRQ2rMCmmYEcpJT/Un5NeJqDI5IGRtNYeIJLSECoH5+2eGBOnhgToFyRHV7ULvYkybthgNCS+ZyUuvWisGlFEoSzZLXPkzCxh8hAKXDG8s8qsNlYPoBhhMBc7dYAE64y8TdrudMOe/vxgdiIsIdDVva03V2raWGm6pJ3+wS+eVPsrOmXkxNJPiH2sxIRHLHN1RNNnBHTTAXXmrEA2fDJ+gIVOhqfGnKloyl4hlVEScaj+K5XTquFPZNRhw==
Received: from MW3PR06CA0012.namprd06.prod.outlook.com (2603:10b6:303:2a::17)
 by DM5PR04MB3771.namprd04.prod.outlook.com (2603:10b6:3:fa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.26; Tue, 4 May 2021 18:23:26 +0000
Received: from MW2NAM10FT064.eop-nam10.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::f4) by MW3PR06CA0012.outlook.office365.com
 (2603:10b6:303:2a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Tue, 4 May 2021 18:23:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT064.mail.protection.outlook.com (10.13.154.101) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 18:23:25 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge4.garmin.com (10.60.4.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 4 May 2021 13:23:20 -0500
Received: from huangjoseph-vm1.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Tue, 4 May 2021 13:23:24 -0500
From:   Joseph Huang <Joseph.Huang@garmin.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Joseph Huang <Joseph.Huang@garmin.com>
Subject: [PATCH 3/6] bridge: Avoid traffic disruption when Querier state changes
Date:   Tue, 4 May 2021 14:22:56 -0400
Message-ID: <20210504182259.5042-4-Joseph.Huang@garmin.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210504182259.5042-1-Joseph.Huang@garmin.com>
References: <20210504182259.5042-1-Joseph.Huang@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) To
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1c233cf-3d5a-4bcb-0b4e-08d90f29b535
X-MS-TrafficTypeDiagnostic: DM5PR04MB3771:
X-Microsoft-Antispam-PRVS: <DM5PR04MB37710E637757D58A32AC119BFB5A9@DM5PR04MB3771.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HDxspoqUt8zXe+c8ajWk5KNbwzWfOBVeII9IigpqImk1b9mQW313j8sLYyhfLmrPRdsl7Tm0XxWRKqArW3WsxCGUBx2PN77a6BJUs1nPK4Pfax2ZIEQ9d12pJo/1L6eASxyXJEgiiUc2ur9198Fr6oWRagiYZGPxH65FGNXSCEnXuULpwymrb87LpnMQnXfToS5hMwmUo85BYpla2qpZZwl0OA8DTBHSETPSbZG+1OEfwRMOrA7P3ua0DNbPcIV0dR1DTHMWinJAbh2eJvGduu5+H/V8OlYIb6UnkVNUe9ttJ80imEZ+aQipQJn0hB+px7NoxhVd6vTnKU55Zekc1r7REUeC3hqPEEDb8zoRZorABarsN8v6bmGAf8qJJW2BPHUBGCqwx7jzXzEd1kcKAKoWO+FvcQWlhAbCDEeUt9sVbLpF7eTbIVbLpGDGrNGtps4YAoi/dOcqKZr6dv8sugtIxedQBNv4L9poqODPE3wTAvhsfr3c6uCuaLTuEDNhhYeOOkKX3HVyieSPk1auDh+8NkAOBYkPbK14DMwfLsMeMHCheL5n/PbcZLPYp17LsRsOOd1AIjfdgGcHU68tn081y/RN0oznDRSIw2iUNHsDfj9pzvbv9Flpm54X3PvnvHv5ZSoEGXmZ6igjYfympw==
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(376002)(46966006)(36840700001)(426003)(336012)(110136005)(36860700001)(316002)(82740400003)(86362001)(6666004)(8676002)(7636003)(356005)(82310400003)(186003)(2616005)(8936002)(70586007)(26005)(2906002)(83380400001)(4326008)(7696005)(70206006)(36756003)(1076003)(66574015)(5660300002)(478600001)(47076005)(107886003);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 18:23:25.6484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c233cf-3d5a-4bcb-0b4e-08d90f29b535
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM10FT064.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB3771
X-Proofpoint-ORIG-GUID: IYnXQ2Sh7AxBWGPmTgcZMgHBIMbsG466
X-Proofpoint-GUID: IYnXQ2Sh7AxBWGPmTgcZMgHBIMbsG466
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_12:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 clxscore=1015 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify br_mdb_notify so that switchdev mdb purge events are never sent
for mrouter ports, and when a non-mrouter port turns into an mrouter
port, all port groups associated with that port are deleted immediately.

Consider the following scenario:

                 +--------------------+
                 |                    |
+-----------+    |      Snooping   +--|    +------------+
| MC Source |----|      Bridge 1   |P1|----| Listener 1 |
+-----------|    |        +--+     +--|    +------------+
                 |        |P2|        |
                 +--------------------+
                           |
                           |
                 +--------------------+
                 |        |P3|        |
                 |        +--+     +--|    +---------------+
                 |      Snooping   |P4|----| Listener 2    |
                 |      Bridge 2   +--|    | Joins Group A |
                 |                    |    +---------------+
                 +--------------------+

Assuming initially Snooping Bridge 1 is the Querier, and Snooping Bridge
2 is a Non-Querier. After some Query/Report exchange, Snooping Bridge 1
would create an mdb group A and add P2 to the group, and starts a timer
on the port group A/P2.

Let's say Snooping Bridge 2 becomes the Querier for some reason (e.g.,
Snooping Bridge 2 rebooted) before the port group A/P2 expires. With
the patch 'bridge: Offload mrouter port forwarding to switchdev',
Snooping Bridge 1 detects that P2 has now become an mrouter port, and
will add it to the address database on the hardware switch chip (even
though it's already there when the port group A/P2 was added). This is
all fine until the timer on port group A/P2 expires, and then Snooping
Bridge 1 will purge P2 from the address database on the switch chip.
Now Listener 2 will not be able to receive multicast traffic from MC
Source anymore.

With this patch, immediately after a bridge port turns into an mrouter
port, the port's membership information is removed from the bridge' mdb,
but remains programmed in the address database on the hardware chip,
just to be consistent with the database/programming state as before
the Querier role change.  The hardware programming will be cleaned up
when the group expires (via br_multicast_group_change).

Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
---
 net/bridge/br_mdb.c       | 17 +++++----
 net/bridge/br_multicast.c | 78 ++++++++++++++++++++++++++++++++-------
 net/bridge/br_private.h   |  3 +-
 3 files changed, 75 insertions(+), 23 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index e8684d798ec3..c121b780450b 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -708,16 +708,17 @@ void br_mdb_switchdev_port(struct net_bridge_mdb_entry *mp,
 void br_mdb_notify(struct net_device *dev,
 		   struct net_bridge_mdb_entry *mp,
 		   struct net_bridge_port_group *pg,
-		   int type)
+		   int type, bool swdev_notify)
 {
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	if (pg) {
-		br_mdb_switchdev_port(mp, pg->key.port, type);
-	} else {
-		br_mdb_switchdev_host(dev, mp, type);
+	if (swdev_notify) {
+		if (pg)
+			br_mdb_switchdev_port(mp, pg->key.port, type);
+		else
+			br_mdb_switchdev_host(dev, mp, type);
 	}
 
 	skb = nlmsg_new(rtnl_mdb_nlmsg_size(pg), GFP_ATOMIC);
@@ -1011,7 +1012,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 		}
 
 		br_multicast_host_join(mp, false);
-		br_mdb_notify(br->dev, mp, NULL, RTM_NEWMDB);
+		br_mdb_notify(br->dev, mp, NULL, RTM_NEWMDB, true);
 
 		return 0;
 	}
@@ -1042,7 +1043,7 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	rcu_assign_pointer(*pp, p);
 	if (entry->state == MDB_TEMPORARY)
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
-	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
+	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB, true);
 	/* if we are adding a new EXCLUDE port group (*,G) it needs to be also
 	 * added to all S,G entries for proper replication, if we are adding
 	 * a new INCLUDE port (S,G) then all of *,G EXCLUDE ports need to be
@@ -1176,7 +1177,7 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry,
 	if (entry->ifindex == mp->br->dev->ifindex && mp->host_joined) {
 		br_multicast_host_leave(mp, false);
 		err = 0;
-		br_mdb_notify(br->dev, mp, NULL, RTM_DELMDB);
+		br_mdb_notify(br->dev, mp, NULL, RTM_DELMDB, true);
 		if (!mp->ports && netif_running(br->dev))
 			mod_timer(&mp->timer, jiffies);
 		goto unlock;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 5ed0d5efef09..d7fbe1f3af18 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -506,7 +506,7 @@ static void br_multicast_fwd_src_handle(struct net_bridge_group_src *src)
 		sg_mp = br_mdb_ip_get(src->br, &sg_key.addr);
 		if (!sg_mp)
 			return;
-		br_mdb_notify(src->br->dev, sg_mp, sg, RTM_NEWMDB);
+		br_mdb_notify(src->br->dev, sg_mp, sg, RTM_NEWMDB, true);
 	}
 }
 
@@ -617,7 +617,12 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	br_multicast_eht_clean_sets(pg);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		br_multicast_del_group_src(ent, false);
-	br_mdb_notify(br->dev, mp, pg, RTM_DELMDB);
+	/* don't notify switchdev if mrouter port
+	 * switchdev will be notified when group expires via
+	 * br_multicast_group_change
+	 */
+	br_mdb_notify(br->dev, mp, pg, RTM_DELMDB,
+		      hlist_unhashed(&pg->key.port->rlist));
 	if (!br_multicast_is_star_g(&mp->addr)) {
 		rhashtable_remove_fast(&br->sg_port_tbl, &pg->rhnode,
 				       br_sg_port_rht_params);
@@ -688,7 +693,7 @@ static void br_multicast_port_group_expired(struct timer_list *t)
 
 		if (WARN_ON(!mp))
 			goto out;
-		br_mdb_notify(br->dev, mp, pg, RTM_NEWMDB);
+		br_mdb_notify(br->dev, mp, pg, RTM_NEWMDB, true);
 	}
 out:
 	spin_unlock(&br->multicast_lock);
@@ -1228,7 +1233,7 @@ void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
 		if (br_multicast_is_star_g(&mp->addr))
 			br_multicast_star_g_host_state(mp);
 		if (notify)
-			br_mdb_notify(mp->br->dev, mp, NULL, RTM_NEWMDB);
+			br_mdb_notify(mp->br->dev, mp, NULL, RTM_NEWMDB, true);
 	}
 
 	if (br_group_is_l2(&mp->addr))
@@ -1246,7 +1251,7 @@ void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
 	if (br_multicast_is_star_g(&mp->addr))
 		br_multicast_star_g_host_state(mp);
 	if (notify)
-		br_mdb_notify(mp->br->dev, mp, NULL, RTM_DELMDB);
+		br_mdb_notify(mp->br->dev, mp, NULL, RTM_DELMDB, true);
 }
 
 static struct net_bridge_port_group *
@@ -1294,7 +1299,7 @@ __br_multicast_add_group(struct net_bridge *br,
 	rcu_assign_pointer(*pp, p);
 	if (blocked)
 		p->flags |= MDB_PG_FLAGS_BLOCKED;
-	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
+	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB, true);
 
 found:
 	if (igmpv2_mldv1)
@@ -2436,7 +2441,7 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 			break;
 		}
 		if (changed)
-			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
+			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB, true);
 unlock_continue:
 		spin_unlock_bh(&br->multicast_lock);
 	}
@@ -2575,7 +2580,7 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 			break;
 		}
 		if (changed)
-			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
+			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB, true);
 unlock_continue:
 		spin_unlock_bh(&br->multicast_lock);
 	}
@@ -2660,26 +2665,71 @@ br_multicast_update_query_timer(struct net_bridge *br,
 	mod_timer(&query->timer, jiffies + br->multicast_querier_interval);
 }
 
-static void br_port_mc_router_state_change(struct net_bridge_port *p,
+static void br_port_mc_router_state_change(struct net_bridge_port *port,
 					   bool is_mc_router)
 {
 	struct switchdev_attr attr = {
-		.orig_dev = p->dev,
+		.orig_dev = port->dev,
 		.id = SWITCHDEV_ATTR_ID_PORT_MROUTER,
 		.flags = SWITCHDEV_F_DEFER,
 		.u.mrouter = is_mc_router,
 	};
 	struct net_bridge_mdb_entry *mp;
+	struct net_bridge *br = port->br;
 	struct hlist_node *n;
 
-	switchdev_port_attr_set(p->dev, &attr, NULL);
+	switchdev_port_attr_set(port->dev, &attr, NULL);
 
 	/* Add/delete the router port to/from all multicast group
 	 * called whle br->multicast_lock is held
 	 */
-	hlist_for_each_entry_safe(mp, n, &p->br->mdb_list, mdb_node) {
-		br_mdb_switchdev_port(mp, p, is_mc_router ?
-				      RTM_NEWMDB : RTM_DELMDB);
+	hlist_for_each_entry_safe(mp, n, &br->mdb_list, mdb_node) {
+		struct net_bridge_port_group __rcu **pp;
+		struct net_bridge_port_group *p;
+		int port_group_exists = 0;
+
+		if (is_mc_router) {
+			for (pp = &mp->ports;
+				(p = mlock_dereference(*pp, br)) != NULL;
+				pp = &p->next) {
+				if (p->key.port == port) {
+					port_group_exists = 1;
+					if (!(p->flags & MDB_PG_FLAGS_PERMANENT))
+						br_multicast_del_pg(mp, p, pp);
+				}
+
+				if ((unsigned long)p->key.port < (unsigned long)port)
+					break;
+			}
+
+			if (port_group_exists)
+				continue;
+
+			br_mdb_switchdev_port(mp, port, RTM_NEWMDB);
+		} else {
+			for (pp = &mp->ports;
+				(p = mlock_dereference(*pp, br)) != NULL;
+				pp = &p->next) {
+				if (p->key.port == port) {
+					port_group_exists = 1;
+					break;
+				}
+
+				if ((unsigned long)p->key.port < (unsigned long)port)
+					break;
+			}
+
+			if (port_group_exists)
+				continue;
+
+			p = br_multicast_new_port_group(port, &mp->addr, *pp, 0,
+							NULL, MCAST_EXCLUDE, RTPROT_KERNEL);
+			if (unlikely(!p))
+				continue;
+			rcu_assign_pointer(*pp, p);
+			br_mdb_notify(br->dev, mp, p, RTM_NEWMDB, false);
+			mod_timer(&p->timer, jiffies + br->multicast_membership_interval);
+		}
 	}
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 5cba9d228b9c..9aa51508ba83 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -832,7 +832,8 @@ void br_mdb_hash_fini(struct net_bridge *br);
 void br_mdb_switchdev_port(struct net_bridge_mdb_entry *mp,
 			   struct net_bridge_port *p, int type);
 void br_mdb_notify(struct net_device *dev, struct net_bridge_mdb_entry *mp,
-		   struct net_bridge_port_group *pg, int type);
+		   struct net_bridge_port_group *pg, int type,
+		   bool swdev_notify);
 void br_rtr_notify(struct net_device *dev, struct net_bridge_port *port,
 		   int type);
 void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
-- 
2.17.1

