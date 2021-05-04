Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A416237302B
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhEDTC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:02:26 -0400
Received: from mx0a-000eb902.pphosted.com ([205.220.165.212]:29282 "EHLO
        mx0a-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231274AbhEDTCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:02:25 -0400
Received: from pps.filterd (m0220294.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144I96dW023239;
        Tue, 4 May 2021 13:23:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pps1;
 bh=Dn1EcMNWZGsvJjV6KjhfFTdFjIc9V485NuIEyRCC98A=;
 b=0MYctD2v+C2H/CpmoxP+07w18h1DMWdSVCugHLRnkvI+WHhSRkJIDXX3aUhU9k0UaPoU
 RFaFpDOOMU612onaB54po7CgDjQ0t3oXcxryokwLkDPAe8Y/XG59rTXC4ndo97X3VAnC
 a7uBAcr4nXL0CEb6o+r5J3W86PYW0rZZeB3KHgcUBxnbivawMkqCW5YW9WcNR+KzDEhh
 dZXq+SiYGDemAMwSjcGFXL2dGpwydBgx6sYEkHiFKUJrDjD+jTW3Ls/3h++YSq1w3ac/
 HMnnHSHrvrvYcaz6lTAJiDqw4CZx8DXBWjoDTG6QKXHCMWuOMg4Kjw91N/YMYEtWKpvC 5A== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0a-000eb902.pphosted.com with ESMTP id 38awtsha9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 13:23:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMkDr6hc1yAtsYloeFmcCliyy9VkIgi9Kdc617vEg4oqHHeV2uGPz9/qAm7KCQnDBV+TI2S43dNsDkdfC5Q9XHLMMK3vfqFXu9WKww+u4vN2sZYgi+an7xmn0s77bCBchowHexbB3XOX0AV0SoL97V/CsusoQ/2+aOJhZZgrEaqhttzq49oGVpbcHrX55aAEVrJIUt/ZZt7JzYZVJl6bh0f+75TZbRmCLfEygN5ojV3p4OyD5P9sdtzGxUyFrOkbkHt2wDbbSyKeyk/iGzQ447x0CzsZ5TWOiI7Jdw46/Iyaqk8j3RvLwfTV2ifIpbNxSVIqI1V/Ci+W1Uy9i5StqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dn1EcMNWZGsvJjV6KjhfFTdFjIc9V485NuIEyRCC98A=;
 b=L2ymwoUwPxsOpCmuA6ejMtU+Ojcdqd4O6JF2DnDL2CXqF9erLE4YPZ0bzo0TDOGmaMiBPUkapoEbyDF8sMbUxpzbhcGU7XVQZi5Oga4uEPoqyd6YbhJ7N8ajvb0FjZkK70xFghyRHzZoDaL0jHGWsUizO+dMkvehmbj7nppmmnujxP2zbwTu78GQ5K+nHIeSDiCnITMBW6cgROSgixuXavqILozXuEUEwwbO9IPtPqRGIFJ9fIBY2YIsdWfklniG+OOChLRkrw5gMXVb3S1p2lzSFeodqfRch9mrxqdzChUKK3ZLRVMJlaNvvRGG4pEQODdSI7NsR3IrELjMGuHK5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dn1EcMNWZGsvJjV6KjhfFTdFjIc9V485NuIEyRCC98A=;
 b=DnnkYM6WWDQ+Pcw+fOYu4ui1ru/5ctsUwnwJ4+QHgY8ZLIktY/xBK09PWBk1mhRQ2a8GZ4jr0wYznu9X472/ovTDx2n3gljqRQeaIqFS0K4kmQizcb/Y6kApyzGCnaGmJoVe/PmHqMhwXN+un4fz+0fOuBqUc20Gzby8y+1NVCHfJQg5nhJ1VH2eFef4TwWCpRpxs1f8sYz8+GucAOnwjLPtiIgZDhrjduA595GLvA7OeZXQptRWBLi3IWwqfVFF0HQ34rXkocEn0/Bfspx5EBOo6O2rVo73c49uia3Jt5ubFfNLj7mxbFde11YOt3yU05J3fQEvXe/RgnG4dfJnuQ==
Received: from DM5PR07CA0072.namprd07.prod.outlook.com (2603:10b6:4:ad::37) by
 BY5PR04MB6309.namprd04.prod.outlook.com (2603:10b6:a03:1e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.41; Tue, 4 May
 2021 18:23:24 +0000
Received: from DM6NAM10FT065.eop-nam10.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::66) by DM5PR07CA0072.outlook.office365.com
 (2603:10b6:4:ad::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Tue, 4 May 2021 18:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 DM6NAM10FT065.mail.protection.outlook.com (10.13.152.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 18:23:24 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge1.garmin.com (10.60.4.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 4 May 2021 13:21:40 -0500
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
Subject: [PATCH 1/6] bridge: Refactor br_mdb_notify
Date:   Tue, 4 May 2021 14:22:54 -0400
Message-ID: <20210504182259.5042-2-Joseph.Huang@garmin.com>
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
X-MS-Office365-Filtering-Correlation-Id: 68cb105f-8c3c-454d-c80b-08d90f29b470
X-MS-TrafficTypeDiagnostic: BY5PR04MB6309:
X-Microsoft-Antispam-PRVS: <BY5PR04MB63091971FB4CD74CA32B2E60FB5A9@BY5PR04MB6309.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8r2wKhXuq1N/s3iMjBeXb6FrJmGjvxz/rbsjSoFE3YgExitmWUjHjPVo/2nAC0g9qyTBP0FVL4GYg50TFOglKPoms7NjxvzYwWMGyBOvwmzV8cBdVBnCRhrjV4fJOt1sg1fB/fw39oK+pw99iqM3PhpTDq/4GUIINetAywPLj4LdIiL9VSFjF8wxCgc9VNKjMfsJdc+p2JNcugGqUQRb8RWqYQvtqXNiezvlt9G5jn2pKhYgfi0HVONz0sv0rVIMBvDeR5oHSwSJ1lDWeCeo2ZWAg3KbFCBz5+VuUBOAcz9GKvP90XJjJFAp4mekyEsD6Bbt+CMrbvyIKyP3aqD8PKJLKCHSJbU9SEz7r4EGhRPR816IyxEmiQ12nAxAXpMpSeB5eTqIBojyU7zE7GJFddD/hm7C2SK5SGq9FNSNQ1ks5uDoYldFn2IvhrDLeAc4blDY2dxD1tf6iUy3/7GG9GAG+n+cPWDjhQiSJyOTLHOgueUz8jTPo1whv2vQ7nG+kmZA09UcuSxtfJcHuhzfz7WOgg2Mj2Q7s/bNzxgTDsmyM+/4LTP7lrkLGXpHsdtyGGK//zB/5+dxM27JQjm4Uwdn4lromSfecIjBMqHM0VmLHv86vV1bih9hP8tbcN9ZA7gHwkQU23SSctU8PItV7/ANWp3ybJIMiBUNd3I6As=
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(136003)(36840700001)(46966006)(47076005)(70206006)(82740400003)(2616005)(82310400003)(107886003)(7696005)(8676002)(70586007)(6666004)(86362001)(8936002)(478600001)(26005)(356005)(83380400001)(4326008)(1076003)(36756003)(336012)(5660300002)(7636003)(426003)(186003)(36860700001)(316002)(110136005)(2906002);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 18:23:24.3792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68cb105f-8c3c-454d-c80b-08d90f29b470
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT065.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6309
X-Proofpoint-GUID: uUpYQPiGVCMDZjkhFKvzjiALfD_pik61
X-Proofpoint-ORIG-GUID: uUpYQPiGVCMDZjkhFKvzjiALfD_pik61
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_12:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate out switchdev notification to its own function in preparation
for the patch "bridge: Offload mrouter port forwarding to switchdev".

Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
---
 net/bridge/br_mdb.c     | 57 ++++++++++++++++++++++++-----------------
 net/bridge/br_private.h |  2 ++
 2 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 95fa4af0e8dd..e8684d798ec3 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -669,10 +669,9 @@ static void br_mdb_switchdev_host(struct net_device *dev,
 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
 }
 
-void br_mdb_notify(struct net_device *dev,
-		   struct net_bridge_mdb_entry *mp,
-		   struct net_bridge_port_group *pg,
-		   int type)
+void br_mdb_switchdev_port(struct net_bridge_mdb_entry *mp,
+			   struct net_bridge_port *p,
+			   int type)
 {
 	struct br_mdb_complete_info *complete_info;
 	struct switchdev_obj_port_mdb mdb = {
@@ -681,30 +680,42 @@ void br_mdb_notify(struct net_device *dev,
 			.flags = SWITCHDEV_F_DEFER,
 		},
 	};
+
+	if (!p)
+		return;
+
+	br_switchdev_mdb_populate(&mdb, mp);
+
+	mdb.obj.orig_dev = p->dev;
+	switch (type) {
+	case RTM_NEWMDB:
+		complete_info = kmalloc(sizeof(*complete_info), GFP_ATOMIC);
+		if (!complete_info)
+			break;
+		complete_info->port = p;
+		complete_info->ip = mp->addr;
+		mdb.obj.complete_priv = complete_info;
+		mdb.obj.complete = br_mdb_complete;
+		if (switchdev_port_obj_add(p->dev, &mdb.obj, NULL))
+			kfree(complete_info);
+		break;
+	case RTM_DELMDB:
+		switchdev_port_obj_del(p->dev, &mdb.obj);
+		break;
+	}
+}
+
+void br_mdb_notify(struct net_device *dev,
+		   struct net_bridge_mdb_entry *mp,
+		   struct net_bridge_port_group *pg,
+		   int type)
+{
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
 	if (pg) {
-		br_switchdev_mdb_populate(&mdb, mp);
-
-		mdb.obj.orig_dev = pg->key.port->dev;
-		switch (type) {
-		case RTM_NEWMDB:
-			complete_info = kmalloc(sizeof(*complete_info), GFP_ATOMIC);
-			if (!complete_info)
-				break;
-			complete_info->port = pg->key.port;
-			complete_info->ip = mp->addr;
-			mdb.obj.complete_priv = complete_info;
-			mdb.obj.complete = br_mdb_complete;
-			if (switchdev_port_obj_add(pg->key.port->dev, &mdb.obj, NULL))
-				kfree(complete_info);
-			break;
-		case RTM_DELMDB:
-			switchdev_port_obj_del(pg->key.port->dev, &mdb.obj);
-			break;
-		}
+		br_mdb_switchdev_port(mp, pg->key.port, type);
 	} else {
 		br_mdb_switchdev_host(dev, mp, type);
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7ce8a77cc6b6..5cba9d228b9c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -829,6 +829,8 @@ br_multicast_new_port_group(struct net_bridge_port *port, struct br_ip *group,
 			    u8 filter_mode, u8 rt_protocol);
 int br_mdb_hash_init(struct net_bridge *br);
 void br_mdb_hash_fini(struct net_bridge *br);
+void br_mdb_switchdev_port(struct net_bridge_mdb_entry *mp,
+			   struct net_bridge_port *p, int type);
 void br_mdb_notify(struct net_device *dev, struct net_bridge_mdb_entry *mp,
 		   struct net_bridge_port_group *pg, int type);
 void br_rtr_notify(struct net_device *dev, struct net_bridge_port *port,
-- 
2.17.1

