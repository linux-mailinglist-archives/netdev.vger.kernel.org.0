Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1287137303F
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhEDTES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:04:18 -0400
Received: from mx0a-000eb902.pphosted.com ([205.220.165.212]:34018 "EHLO
        mx0a-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231274AbhEDTER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:04:17 -0400
Received: from pps.filterd (m0220295.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144IAPMQ028781;
        Tue, 4 May 2021 13:23:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pps1;
 bh=eGB4vdoqn/KudE2r/6GyvU8YVGKeGDDX+aBr9Ms9O88=;
 b=heWUE/Eyu7rg6O4+O5OyFfHOOi5Tb/Ggco6nuv+glqjaFk0F6jKGnVyhSsEnM0TI5Plk
 +7629hQ2/INPWo4LnVjizunq8/HcqliU4//DaCx0i93RFguJehjUw89gKjgMQvV0pOS4
 9RfgPtFibhbskj2hYcup+tkyKjlfNqFsXgmZFDYMDQNB+c3T5/REBKMLykQnqw9oHHnl
 Hz+O3it9H2DPQuszdCsqXLe7m5YRvtE7c55DdAkAltp/G+zgDiwpAWMeGgigbAch2RvE
 1MLLFU0+XCCB8nFmlfMzhDL7KAlR0+FUsGOy+xempYcRP1tVjmNOSkH6Lz/bRB3jgscs cQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0a-000eb902.pphosted.com with ESMTP id 38am0m231b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 13:23:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pu5MWdsfs2qBHTF5VSyxB5vPSLjaJybrcyk0AmKw06ntK/sKAShoLjHXRm01hIsj4bx0awGF1ZBBCQiVecN6eIaXALpDZW5CAWF+Tvxr6+RhOwlbS+ywHyEoWD9TsDtkjfbM5DRwW2pEM+fjeTIRym2fGfv5K4j47PhGK71MRo3A9r3ZC2TqlfrG4O2Sv6/00pENRgbIe+jeBXvS4fwDOHhZJPBxYrx/jouK6tcgjo10nUFrvWLk9oe1iaMyNqyLipuAjaDd24vkN17gTOOhpkkD25zjz42pADwRv9tF8+vU8t/F0T87tzeooMR66jI6ik+pJ8UbpK6e110+jE39hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGB4vdoqn/KudE2r/6GyvU8YVGKeGDDX+aBr9Ms9O88=;
 b=hP5ygy7S3gagzeVlp2eYmqaGkNXgoIHKTYUQYPFDOylhW6dJ+PYODxqLM2ndO6GuVYYekoXB2hIuzWvV+XswR+d/vcaXFsaOJ7Uxul8djKlC4U24OpW+6zoTwPKFTsZdF2CbfBx0HhQUP15Hp7RZ3HGFknH57AKM7bTa3rLEBXXIlcpfC/byNYTfyEh7UhZRZtReeI18ydDbjPnEPpcWzjl22n1oD0ARMvGSADufKLBki9vb48R6qvuiovXhI60b0cneiKK3tPbZYUVwQpsUqDl3Ok/wKkXofy3QlZuqVGscoBLyOT398suH2YNpIuEMYQUaf/T/5RQwdrF78RvV6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGB4vdoqn/KudE2r/6GyvU8YVGKeGDDX+aBr9Ms9O88=;
 b=Q7OLogtpLy9t6HYXi44dtp8fAht4NfP9+UKYNknUu09kHDVPnqavCVAMUVfJxDxGQK7Rzkga2iMXQI2NZvHauRHr+MwiQ3ab3wchoW83ifAIadBMtZpSgaFHZt2L0/Sh0Yy7/all0hvH4e9DRjqet4bk5WAQ1GO4ElbMBU4s3Fx02wZE9fp/Rdw//FqnpXrSo4WlNfGV/t9PysiFC2/LgzeWgVLSz+cYcXgzOEc9YG9pt+hnyy5f/i6Jtlo/6aqCskrQanO1Ms4Lk5FpyHOLB9dKNqIVB0Wkn7wjUHc5Dmw+VegMaVsAcp2McPtaJAeGJAAgQF8KJpSVZQNxfxyM5A==
Received: from MW4PR04CA0171.namprd04.prod.outlook.com (2603:10b6:303:85::26)
 by MWHPR04MB3775.namprd04.prod.outlook.com (2603:10b6:300:fc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.44; Tue, 4 May
 2021 18:23:25 +0000
Received: from MW2NAM10FT029.eop-nam10.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::b1) by MW4PR04CA0171.outlook.office365.com
 (2603:10b6:303:85::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Tue, 4 May 2021 18:23:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT029.mail.protection.outlook.com (10.13.154.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 18:23:25 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge5.garmin.com (10.60.4.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 4 May 2021 13:23:19 -0500
Received: from huangjoseph-vm1.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Tue, 4 May 2021 13:23:23 -0500
From:   Joseph Huang <Joseph.Huang@garmin.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Joseph Huang <Joseph.Huang@garmin.com>
Subject: [PATCH 2/6] bridge: Offload mrouter port forwarding to switchdev
Date:   Tue, 4 May 2021 14:22:55 -0400
Message-ID: <20210504182259.5042-3-Joseph.Huang@garmin.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7ce3b0fb-0087-444e-0990-08d90f29b4e6
X-MS-TrafficTypeDiagnostic: MWHPR04MB3775:
X-Microsoft-Antispam-PRVS: <MWHPR04MB377587C8079C00FDDFA96ACCFB5A9@MWHPR04MB3775.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qm93Mcz6JuxpMnpRenZ7n3TP5kcloY3q/Pwe7oBytdGRnlvNMu1alorRT3Wjn89QY+Xraz4LcqC6Pz05bzkXzaClW598QeL7yXs2X7kx+hSqEQvLZPCWyle/+SdRKIDx/aYX2ZdhZSPfUe1HmkV2KBdSZWr810zanKHh/APTIF/ZelPDViwH1sa0TYqu+Wwj4Q+UW1FtNVfwZ4QNH5AccaxPP+taiLjyJgXFlKWM0qH5toi2Ho5laGBae446Z8d4Qsrcah8DQUcIShRH054mRFgLiVX60rzzDWO84OU1vDGskdg5uNdl2eOzoy0m+EGae4PAHQgR+Jed8C4JNBDZkcgVSe68Q12rXFXJNVtrCF5Tbl7IrzNuz2htK3ANAqKMRIRILuR/Vig6/PY92s4wMdRjUSI8SCfcyuFEspcoKqljaAJw5KpM+/U4a5U/stlTjlfykpoSkfWXLC/Mt3Vr0OBEYh1OiCp8W++1m4Qssmw7VMFSRkxf+wphqMVd69UHLRV7x5E12EXfBGSDjNDaYj5nYiiKI745KFOm1kS6GcYSU2pU1ReSPrURAzkMlrejXwEFx2jCtha445WzUiLWH0KmVPLvh0scQEABUiy+yhvNb/3mdOddlBmVyriIb/oOuFrDyjymqmjPd6anMltkbswCXFVljYzY/4LIE0R2Zg=
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(346002)(39860400002)(396003)(376002)(136003)(36840700001)(46966006)(7696005)(4326008)(36756003)(82310400003)(316002)(70586007)(70206006)(107886003)(356005)(2906002)(86362001)(110136005)(8676002)(7636003)(1076003)(336012)(2616005)(66574015)(47076005)(36860700001)(186003)(478600001)(82740400003)(5660300002)(83380400001)(6666004)(426003)(8936002)(26005);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 18:23:25.1297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce3b0fb-0087-444e-0990-08d90f29b4e6
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM10FT029.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB3775
X-Proofpoint-GUID: u3lN4rORjaBHU6kG3rvO2LwYXR-tSnkJ
X-Proofpoint-ORIG-GUID: u3lN4rORjaBHU6kG3rvO2LwYXR-tSnkJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_12:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offload the mrouter port forwarding to switchdev also.

Currently multicast snooping fails to forward traffic in some cases
where there're multiple hardware-offloading bridges involved.

Consider the following scenario:

                 +--------------------+
                 |                    |
                 |      Snooping   +--|    +------------+
                 |      Bridge 1   |P1|----| Listener 1 |
                 |     (Querier)   +--|    +------------+
                 |                    |
                 +--------------------+
                           |
                           |
                 +--------------------+
                 |    | mrouter |     |
+-----------+    |    +---------+  +--|    +------------+
| MC Source |----|      Snooping   |P2|----| Listener 2 |
+-----------|    |      Bridge 2   +--|    +------------+
                 |    (Non-Querier)   |
                 +--------------------+

In this scenario, Listener 2 is able to receive multicast traffic
from MC Source while Listener 1 is not. The reason is that, on
Snooping Bridge 2, when the (soft) bridge attempts to forward
a packet to the mrouter port via br_multicast_flood, the effort
is blocked by nbp_switchdev_allowed_egress, since offload_fwd_mark
indicates that the packet should have been handled by the hardware
already. Listener 2 would receive the packets without any problem
since P2 is programmed into the hardware as a member of the group;
however the mrouter port would not since the mrouter port would
normally not be a member of any group, and thus will not be added
to the address database on the hardware switch chip.

This patch takes a simplistic approach: when an mrouter port is added/
deleted, it's added/deleted to all mdb groups; and similarly, when
an mdb group is added/deleted, all mrouter ports are added/deleted
to/from it.

Before this patch, switchdev programming matches exactly with mdb:
 +-----+
 | mdb |
 +-----+
    |
 +----------------------------------------------+
 |  |        +--------------------------------+ |
 |  |        | both in mdb and switchdev      | |
 |  |        | +------+   +------+   +------+ | |
 |  +--------|-| port |---| port |---| port | | |
 |           | +------+   +------+   +------+ | |
 | switchdev +--------------------------------+ |
 +----------------------------------------------+

After this patch, some entries will only exist in switchdev and not
in mdb:
 +-----+
 | mdb |
 +-----+
    |
 +---------------------------------------------------------------------+
 |  |        +--------------------------------++---------------------+ |
 |  |        |  both in mdb and switchdev     ||  only in switchdev  | |
 |  |        | +------+   +------+   +------+ || +------+   +------+ | |
 |  +--------|-| port |---| port |---| port | || |  mr  |---|  mr  | | |
 |           | +------+   +------+   +------+ || +------+   +------+ | |
 | switchdev +--------------------------------++---------------------+ |
 +---------------------------------------------------------------------+

Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
---
 net/bridge/br_multicast.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 226bb05c3b42..5ed0d5efef09 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -522,10 +522,26 @@ static void br_multicast_destroy_mdb_entry(struct net_bridge_mcast_gc *gc)
 	kfree_rcu(mp, rcu);
 }
 
+/* Add/delete all mrouter ports to/from a group
+ * called while br->multicast_lock is held
+ */
+static void br_multicast_group_change(struct net_bridge_mdb_entry *mp,
+				      bool is_group_added)
+{
+	struct net_bridge_port *p;
+	struct hlist_node *n;
+
+	hlist_for_each_entry_safe(p, n, &mp->br->router_list, rlist)
+		br_mdb_switchdev_port(mp, p, is_group_added ?
+				      RTM_NEWMDB : RTM_DELMDB);
+}
+
 static void br_multicast_del_mdb_entry(struct net_bridge_mdb_entry *mp)
 {
 	struct net_bridge *br = mp->br;
 
+	br_multicast_group_change(mp, false);
+
 	rhashtable_remove_fast(&br->mdb_hash_tbl, &mp->rhnode,
 			       br_mdb_rht_params);
 	hlist_del_init_rcu(&mp->mdb_node);
@@ -1068,6 +1084,8 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 		hlist_add_head_rcu(&mp->mdb_node, &br->mdb_list);
 	}
 
+	br_multicast_group_change(mp, true);
+
 	return mp;
 }
 
@@ -2651,8 +2669,18 @@ static void br_port_mc_router_state_change(struct net_bridge_port *p,
 		.flags = SWITCHDEV_F_DEFER,
 		.u.mrouter = is_mc_router,
 	};
+	struct net_bridge_mdb_entry *mp;
+	struct hlist_node *n;
 
 	switchdev_port_attr_set(p->dev, &attr, NULL);
+
+	/* Add/delete the router port to/from all multicast group
+	 * called whle br->multicast_lock is held
+	 */
+	hlist_for_each_entry_safe(mp, n, &p->br->mdb_list, mdb_node) {
+		br_mdb_switchdev_port(mp, p, is_mc_router ?
+				      RTM_NEWMDB : RTM_DELMDB);
+	}
 }
 
 /*
-- 
2.17.1

