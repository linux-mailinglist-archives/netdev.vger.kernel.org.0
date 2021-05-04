Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF83373043
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhEDTE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:04:56 -0400
Received: from mx0b-000eb902.pphosted.com ([205.220.177.212]:29104 "EHLO
        mx0b-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231478AbhEDTEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:04:53 -0400
Received: from pps.filterd (m0220299.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144I8d7P025980;
        Tue, 4 May 2021 13:23:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pps1;
 bh=Fj46d+TFO6oS9m9H9NaMKRavcBycZmgywtCruQcLscg=;
 b=OJhdxKx6hEgp7j7TT6nzISmkxKLf7sQ/jhSNPZG1ZfoOMIhhw4bBUxVZLzF/ZrBnuRMQ
 /rSUiFaQ4nW5lrQXQ+6lXK0FYi88qGl9Gr4eUWkz16giinH+zu8ElL+aSgtI1BTpqI9c
 aoCZdN1UdT85iRxvDgtqZ1jx+QltAQoYbiBn90mfVLcLT8QITlijNAphZI1FeWHZXYcc
 +T/MBkqD3thxpq6ZA/7w/65QXt4I+rNZS60eS8iUVZnslw/Om8dy1LZH33Kp+tlJJ+4X
 WraZXZPdETnMaWj7bkXI/ueXR043GjMvSBWNr2NCfTIKBHd08dKHbQQCX9TNsGxC+zcQ TA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-000eb902.pphosted.com with ESMTP id 38ajpd2753-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 13:23:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8+rarTButp6VAgGtJUc8MruzwqjAStbrhredVgeGT0uO1wnsYTFvuH9E64WSQmUKOzDiCO7OV9BldeQafvuFwafTqDLsIwtXAG5/Ua7V9+1FTu5GTqHBb0cP+NIcvTO4gcROgAUPw7FhO4YjQQvNjc2mD4Kcy+FdYS5y/4lscvSzAdSX8Z4ptHxmxMZOc5VOeunVMD4WUaaTfDbNtiuCpIe2AgCn80vr0qCkXNfPaDhrxkV12AX20suOJ+DipWFkm8EKAiliYPhVAvppjSLxWmr6gGpD6iT2RoxZL22Jfggb/VEHYeno9zWmTAei6bv+rpwnAcYrzzyfJ3csOF1Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fj46d+TFO6oS9m9H9NaMKRavcBycZmgywtCruQcLscg=;
 b=LUdn0hEi35e2gjpjY7rS55tdYlnam9Qlo/2akaG0QOr2GYp8sDbOAzZCKf1O80tI8fRZHeEPrORvwdoD+HHW7e5P/S5QQaDEkIarmdYHRs+li5crIBWmGwH+kME1lA+bvGVd2WFYYJF/ldAf8wI6JBwY3WLy6weR7ytT7+C/8LeDiJhcmQgJ4HrFZOS8JgDdEFS/02TSr+zgLcpoOJzVz1sVdkgX0AL9Q3LJaWBR/ff5irU1OVImCeq8tIXOy/GEFCbE7l4eZztaYfPKEGPMuqFCFQyOVqxcu5VeDntjnbJEu8D+M/VZcmJgeYOVYYdLUBIbNWFzYS3hFiMhdin7SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fj46d+TFO6oS9m9H9NaMKRavcBycZmgywtCruQcLscg=;
 b=GLYwZ3cgydMX0maQcdUxqt0CBhxPUSmMqOTP7mTOYDnoERjmHYFJ8GLmnVv3UHYR3oRiA5wu/aVG1uc78caRgNXm51Af3PSgpas7dVaT7lCjcThfxecR7xQfGWMXoO2IttmvukKISyZFYZGtnNCBmZ5s4jKW2nudHSFQW298utp9BfhfF2qeECeiAamItpewN3x1upfyjCwge3GfYvET/GrRgwSx63fUbrZJdM92aR3gaudb5PxXvgAL80yZxKAC+oKubly+0Knuqz4sJBBYSxD6Uq3EZtar32vHTedM0cN4uRrQRjzAy3XWiut3z5A2x/MGjCHm4zz7wEXd3ucs0A==
Received: from BN9PR03CA0340.namprd03.prod.outlook.com (2603:10b6:408:f6::15)
 by DM5PR04MB0589.namprd04.prod.outlook.com (2603:10b6:3:9d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.27; Tue, 4 May
 2021 18:23:26 +0000
Received: from BN7NAM10FT057.eop-nam10.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::55) by BN9PR03CA0340.outlook.office365.com
 (2603:10b6:408:f6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Tue, 4 May 2021 18:23:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 BN7NAM10FT057.mail.protection.outlook.com (10.13.157.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 18:23:26 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge2.garmin.com (10.60.4.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 4 May 2021 13:23:21 -0500
Received: from huangjoseph-vm1.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Tue, 4 May 2021 13:23:25 -0500
From:   Joseph Huang <Joseph.Huang@garmin.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Joseph Huang <Joseph.Huang@garmin.com>
Subject: [PATCH 5/6] bridge: Flood Queries even when mcast_flood is disabled
Date:   Tue, 4 May 2021 14:22:58 -0400
Message-ID: <20210504182259.5042-6-Joseph.Huang@garmin.com>
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
X-MS-Office365-Filtering-Correlation-Id: e72eb858-ca08-400e-4b5e-08d90f29b5a2
X-MS-TrafficTypeDiagnostic: DM5PR04MB0589:
X-Microsoft-Antispam-PRVS: <DM5PR04MB0589D596739A62BAB1CB3561FB5A9@DM5PR04MB0589.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tOXjbgfvlUhzBTBSvi3pl1fo8JSI6ckSYQ0CgGnS5DyvRqaD8ygizSbqyovnGCOa82xgJbxz0sAslZOW2/A1sGNhC8lzIkknnSVdPC85JXB1sWfJ7d7AVzIX+8ZJs8At2GHH4khql2b2dEkcJyWJIo+pDipgwxBDKJbuD62ikGLAYM2iaj+zA4ldJIBR6kdjdnGnspG8xWP74gnrtna5JrJkx9zX16DsgRkKSJDTWZtqbTf2V0xBbU80QzLoqOzO0l/5WHe/ydPeUQitt3FoFdW4g/GVwTQA1L5+3Dk50ntXzkaqv3uxzkD4ZCgiiruP4x9gvYrKPFAFc+9T9UVf7/9ptAPYNPzxk2sgN36qQE77eiqyS5S+GVdLwkWaQjL7dZzhbbiuwy25dqnF5hv38GQXnYYxI4Qiz9WxCSemkjcLkRuumkEsR3ebN0MGpwZd36xckD8JgTgorRsG3wEWJ6fZmFLw13gGjb6Y2z26EeX5t+YnQnZdzHLGsQ2jcsMurqb7Zxt43sS8Gcn0YcWUzHSM7OG9ZUZUfrVFHUHX0ir9jaarroMqtdM0DRRM4QsoY0sd2lJBU6qZzJ6TECg7X71uk5VvsjrVZHBzLgrSP5Rizx5oj2sHEbJS55t6kFgtju5bpss+qXvCgpae1Kq5S1Kvb75nvHwGLqYiY5C+ldA=
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(136003)(46966006)(36840700001)(107886003)(7636003)(316002)(1076003)(478600001)(2616005)(70586007)(5660300002)(6666004)(70206006)(186003)(83380400001)(8936002)(110136005)(86362001)(26005)(36756003)(82740400003)(4326008)(426003)(2906002)(7696005)(82310400003)(8676002)(36860700001)(47076005)(336012)(356005);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 18:23:26.3994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e72eb858-ca08-400e-4b5e-08d90f29b5a2
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: BN7NAM10FT057.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0589
X-Proofpoint-ORIG-GUID: MV7wwsIDto4SV8aemqFPnkHtS5spJa4M
X-Proofpoint-GUID: MV7wwsIDto4SV8aemqFPnkHtS5spJa4M
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_12:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the forwarding path so that received Queries are always flooded
even when mcast_flood is disabled on a bridge port.

In current implementation, when mcast_flood is disabled on a bridge
port, Queries received from other Querier will not be forwarded out of
that bridge port. This unfortunately broke multicast snooping.

Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
---
 net/bridge/br_forward.c   | 3 ++-
 net/bridge/br_multicast.c | 3 +++
 net/bridge/br_private.h   | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 6e9b049ae521..2fb9b4a78881 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -203,7 +203,8 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
 				continue;
 			break;
 		case BR_PKT_MULTICAST:
-			if (!(p->flags & BR_MCAST_FLOOD) && skb->dev != br->dev)
+			if (!(p->flags & BR_MCAST_FLOOD) && skb->dev != br->dev &&
+			    !BR_INPUT_SKB_CB_FORCE_FLOOD(skb))
 				continue;
 			break;
 		case BR_PKT_BROADCAST:
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 719ded3204a0..b7d9c491abe0 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3238,6 +3238,7 @@ static int br_multicast_ipv4_rcv(struct net_bridge *br,
 		err = br_ip4_multicast_igmp3_report(br, port, skb, vid);
 		break;
 	case IGMP_HOST_MEMBERSHIP_QUERY:
+		BR_INPUT_SKB_CB(skb)->force_flood = 1;
 		br_ip4_multicast_query(br, port, skb, vid);
 		break;
 	case IGMP_HOST_LEAVE_MESSAGE:
@@ -3300,6 +3301,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 		err = br_ip6_multicast_mld2_report(br, port, skb, vid);
 		break;
 	case ICMPV6_MGM_QUERY:
+		BR_INPUT_SKB_CB(skb)->force_flood = 1;
 		err = br_ip6_multicast_query(br, port, skb, vid);
 		break;
 	case ICMPV6_MGM_REDUCTION:
@@ -3322,6 +3324,7 @@ int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
 
 	BR_INPUT_SKB_CB(skb)->igmp = 0;
 	BR_INPUT_SKB_CB(skb)->mrouters_only = 0;
+	BR_INPUT_SKB_CB(skb)->force_flood = 0;
 
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		return 0;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 9aa51508ba83..59af599d48eb 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -491,6 +491,7 @@ struct br_input_skb_cb {
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	u8 igmp;
 	u8 mrouters_only:1;
+	u8 force_flood:1;
 #endif
 	u8 proxyarp_replied:1;
 	u8 src_port_isolated:1;
@@ -510,8 +511,10 @@ struct br_input_skb_cb {
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(BR_INPUT_SKB_CB(__skb)->mrouters_only)
+# define BR_INPUT_SKB_CB_FORCE_FLOOD(__skb)		(BR_INPUT_SKB_CB(__skb)->force_flood)
 #else
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
+# define BR_INPUT_SKB_CB_FORCE_FLOOD(__skb)		(0)
 #endif
 
 #define br_printk(level, br, format, args...)	\
-- 
2.17.1

