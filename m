Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894B7372FC1
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 20:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhEDSbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 14:31:13 -0400
Received: from mx0a-000eb902.pphosted.com ([205.220.165.212]:40272 "EHLO
        mx0a-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232183AbhEDSbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 14:31:10 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 14:31:10 EDT
Received: from pps.filterd (m0220294.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144I9h13023800;
        Tue, 4 May 2021 13:23:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pps1;
 bh=s+HR9JQYUp+nkFXI9Gvgl9YT5FYywAz7O3lXDrLaiW4=;
 b=YkOXwF5hEivWTNou1MWiJYjCLjERdMwVvsGE0GDe3g7ZrIqtpOS2ujLHsteNUKXoPmm8
 QphcZ9+xRXBsqoJVhh/6GYh8eTj6En5ciZAnaoa9In9En8Sgi6gGbu6OQEsGvRh/svP7
 oim/hWNbka6C4ZXmOU5zddhacH50hpPxDsktHZ7RfExgWt77DrXktB0RlE94FlPu5uLX
 76PIB9qIPpjsXkN7of0/u+gRQ/VlvXPy//avdjTbzICLrnIwROEqofM8rUM+TjYx2L0q
 0AGItmZLcn9VToUO+0zGULEpmyNbmgCCnnXOVMVGEvYm/QCVz3zj5vkfcrZYTZMrvXoJ Yw== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by mx0a-000eb902.pphosted.com with ESMTP id 38awtsha9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 13:23:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibg76+Y18BtrvXFRUEDdzWD8SWhE1yb9TNJPOBAkKqKgGPCA6IMgXDp/M6L01FOnh4ACbKfqeeyIfnEtbApRXwPG+MOi6ltyoq5CuLkceHpwoFSieeVvKxcBEENDjdnqoeXj6+NHB8nod6VmmdLexm+0eL1wcYAcsnWxkn9e3BfBLENwVOnCaPQMcoCuOACgfwnnT49Dc3ySxn1WCzHmhwUJtA89APLSaNJGzHnavArgLoMFvLvvJVVDj0JtN6mnRZCi22xzLCJoYD6eBT/6jPxoiYo1uNCzdusbhFzAGBtPara8wxZN9OeNgt/AhxSxbKOimSTx/kAiqOXtF5k1mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+HR9JQYUp+nkFXI9Gvgl9YT5FYywAz7O3lXDrLaiW4=;
 b=N2XCsfkmv9wpB3wxDSEpIEGoXfSQrdalU1VaSVmRQLwU4tR76PiQGosOE5rD4WLeIs+b1uh2xto0pbxsJjbVN6it0CYIU3U4eRs3ETyjAFrNzxtVnl3VlAXjqiPxJ2WyDgpTUbW1R744fW+RWkNvhThbrC1kq8imOrWBAjLN8OSa6IP92LFPA1PoGRR9MZXJxzhNar3TEJiXdBZ/hUgZsddyWzG4G0D07yXLsgDwh/49Jdz3i0dtXE2uIBJKDu7iQUg+xDnxlKXeHZPeOnjljJCPXTo5OB+Rp47J+O8iOBbtcqGXCYifEZGq+UDA5WN+hUYMhz2xDKBBea03gqdUng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+HR9JQYUp+nkFXI9Gvgl9YT5FYywAz7O3lXDrLaiW4=;
 b=g49CpVfLImxCyAS1317l0pX7EFpLEjsFQwJqZGvJ/DDLLngZ98HCRE9X6syHezoPBZ5i0HQReiMX+kJvSMcmUZ9jKJ+aUnO85/vF4NeZcE3f5z8qDbNmM/09M72MRcJEgdfF/te0MD4e2gQuKFY78A6NyLUvyynnftT65ldsTk5c7ZjY+Rbbwo3dyEgWEMunZQp/KEop8uOJU/0+cOh2cwTSkrGfGv7YFwexl0RUt1h6291iNGV8Ha7LNLvfERk+tC/GAwR88aueJVXlK0w99hsX654E5whKZFC30G4mPMUsfXTr9VL5VdrYDuwZKzt//OZBpz2UuytUi1iOe3TboQ==
Received: from DM5PR12CA0072.namprd12.prod.outlook.com (2603:10b6:3:103::34)
 by CO6PR04MB7747.namprd04.prod.outlook.com (2603:10b6:5:35b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.43; Tue, 4 May
 2021 18:23:27 +0000
Received: from DM6NAM10FT005.eop-nam10.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::ea) by DM5PR12CA0072.outlook.office365.com
 (2603:10b6:3:103::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Tue, 4 May 2021 18:23:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 DM6NAM10FT005.mail.protection.outlook.com (10.13.152.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.27 via Frontend Transport; Tue, 4 May 2021 18:23:26 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge1.garmin.com (10.60.4.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 4 May 2021 13:21:43 -0500
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
Subject: [PATCH 6/6] bridge: Always multicast_flood Reports
Date:   Tue, 4 May 2021 14:22:59 -0400
Message-ID: <20210504182259.5042-7-Joseph.Huang@garmin.com>
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
X-MS-Office365-Filtering-Correlation-Id: 55dd95ce-3845-4e18-4f60-08d90f29b5f6
X-MS-TrafficTypeDiagnostic: CO6PR04MB7747:
X-Microsoft-Antispam-PRVS: <CO6PR04MB7747EC623AD0F1651EA35A5CFB5A9@CO6PR04MB7747.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /J9bcrp1w7TI+xXe4b+VXEYX/i6pKdtqnRB83bQHHvdkNqW1Mskc3MstCZEZkbRc7RHvinlGmmUQwdENw2LRI3zApuczIUFqRYeBHwtszp9NiaLTsuN29eLFDiHPx5iIEDqXyDi4wY7gj0UI7h3qr2ioDugw7+86yTppLtEkZTNm8kGXJUMWJIUukCkL0jgeVqPJVjq10QBMNuBckg4RYx/a14p7vjPz9HzDaeb6YvKVvgHkJzgT2Aq1DLT9s68TnGT8jcDMe+WDpprSYvPl2fowwMoEKm9IOusRt6ahLgfAoUAJgih3CNTk+bmF2QolR/6IGTH5BFTDpN6jhZ6Ip3Q+tMJGlDiujrumQ6ErYYfz1lDab8zmldAhXMfI7TRuoX5gPr95+kT/4pO5XI/uSA9tqT6+PTBb4MlkrTro7msWnjRn+zW1NEizVjMd6uo7iGDRq8MFGfiRTCne53XfJ9WLJ2oyIjsdgcde0TndsvmjtKpJyr0NaZne5Eruz6kNS5KJPa8djLgOxvhCsYSltnTi2PIw+itcctHA6q+iA3Z1hrUcQrG1rbMHRkxQfg644nBEM0VDYk+LnCHrv8maN6Ema8r7jjG/I68/+qzVn+jhuoUgn15u9Ws/U9aH1mjuurkR8cd7fKhtnuDmQGsquVZPUzwNC8zheCXLwW3yxNY=
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(376002)(46966006)(36840700001)(36756003)(8676002)(2906002)(7696005)(7636003)(110136005)(107886003)(47076005)(5660300002)(70206006)(8936002)(4326008)(86362001)(83380400001)(356005)(478600001)(66574015)(336012)(36860700001)(82310400003)(26005)(82740400003)(2616005)(70586007)(316002)(1076003)(426003)(6666004)(186003);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 18:23:26.9390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55dd95ce-3845-4e18-4f60-08d90f29b5f6
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT005.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7747
X-Proofpoint-GUID: q5A2TvumHL--EkTtLClzzAkS-xBxjDEO
X-Proofpoint-ORIG-GUID: q5A2TvumHL--EkTtLClzzAkS-xBxjDEO
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

Modify the forwarding path so that IGMPv1/2/MLDv1 Reports are always
flooded by br_multicast_flood, regardless of the check done
by br_multicast_querier_exists.

This patch fixes the problems where after a system boots up, the first
couple of Reports are not handled properly in that:

1) the Report from the Host is being flooded (via br_flood) to all
   bridge ports, and
2) if the mrouter port's mcast_flood is disabled, the Reports received
   from other hosts will not be forwarded to the Querier.

Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
---
 net/bridge/br_device.c    | 5 +++--
 net/bridge/br_input.c     | 5 +++--
 net/bridge/br_multicast.c | 3 +++
 net/bridge/br_private.h   | 3 +++
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index e8b626cc6bfd..ff75ba242f38 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -88,8 +88,9 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		mdst = br_mdb_get(br, skb, vid);
-		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb), mdst))
+		if (((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) ||
+		    BR_INPUT_SKB_CB_FORCE_MC_FLOOD(skb))
 			br_multicast_flood(mdst, skb, false, true);
 		else
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 8875e953ac53..572d7f20477f 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -129,8 +129,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	switch (pkt_type) {
 	case BR_PKT_MULTICAST:
 		mdst = br_mdb_get(br, skb, vid);
-		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) {
+		if (((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) ||
+		    BR_INPUT_SKB_CB_FORCE_MC_FLOOD(skb)) {
 			if ((mdst && mdst->host_joined) ||
 			    br_multicast_is_router(br)) {
 				local_rcv = true;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b7d9c491abe0..dfdbe19f3e93 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3231,6 +3231,7 @@ static int br_multicast_ipv4_rcv(struct net_bridge *br,
 	case IGMP_HOST_MEMBERSHIP_REPORT:
 	case IGMPV2_HOST_MEMBERSHIP_REPORT:
 		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
+		BR_INPUT_SKB_CB(skb)->force_mc_flood = 1;
 		err = br_ip4_multicast_add_group(br, port, ih->group, vid, src,
 						 true);
 		break;
@@ -3294,6 +3295,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 	case ICMPV6_MGM_REPORT:
 		src = eth_hdr(skb)->h_source;
 		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
+		BR_INPUT_SKB_CB(skb)->force_mc_flood = 1;
 		err = br_ip6_multicast_add_group(br, port, &mld->mld_mca, vid,
 						 src, true);
 		break;
@@ -3325,6 +3327,7 @@ int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
 	BR_INPUT_SKB_CB(skb)->igmp = 0;
 	BR_INPUT_SKB_CB(skb)->mrouters_only = 0;
 	BR_INPUT_SKB_CB(skb)->force_flood = 0;
+	BR_INPUT_SKB_CB(skb)->force_mc_flood = 0;
 
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		return 0;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 59af599d48eb..6d4f20d7f482 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -492,6 +492,7 @@ struct br_input_skb_cb {
 	u8 igmp;
 	u8 mrouters_only:1;
 	u8 force_flood:1;
+	u8 force_mc_flood:1;
 #endif
 	u8 proxyarp_replied:1;
 	u8 src_port_isolated:1;
@@ -512,9 +513,11 @@ struct br_input_skb_cb {
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(BR_INPUT_SKB_CB(__skb)->mrouters_only)
 # define BR_INPUT_SKB_CB_FORCE_FLOOD(__skb)		(BR_INPUT_SKB_CB(__skb)->force_flood)
+# define BR_INPUT_SKB_CB_FORCE_MC_FLOOD(__skb)	(BR_INPUT_SKB_CB(__skb)->force_mc_flood)
 #else
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
 # define BR_INPUT_SKB_CB_FORCE_FLOOD(__skb)		(0)
+# define BR_INPUT_SKB_CB_FORCE_MC_FLOOD(__skb)	(0)
 #endif
 
 #define br_printk(level, br, format, args...)	\
-- 
2.17.1

