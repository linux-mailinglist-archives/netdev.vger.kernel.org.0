Return-Path: <netdev+bounces-9907-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8985872B242
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 16:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDC332812EB
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 14:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12A3AD56;
	Sun, 11 Jun 2023 14:09:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B4610E6
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 14:09:32 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5885310D3
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 07:09:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kg/uVeq9vf8cr30wN8/7ejqsZLKnO6YPejNTbYkx4ApHYrNhVHI8VH1T+6iDj5DfHqM6pftlPYOLrCHv86djmH59/ktI1mu+gp72CNHJ3HbUwocaosxTkiZ29kFWnIwKY8BQ8uTfh9LEwX7oZJ7TREQzi6iwUGcemPWzdqyKlwo3Z+5YPyCucbCeSqzSjQgF1eB4VSxX5GoH2E5QDahKxX567VXWDjWyDezRqRedlSp2ApfWhHg8QE7aF8fVrqjeZjI/idVv6Bj21pl88easc/Wet1soF48dbzfEw4wwCyQf+PXIXtwm6QFjNmJCXvqv7YwY2etR0a/KGQTqz55nGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Z2eyy7mFUcEGoRqmH4mo2DzH436ChJxlfnJhsiX81s=;
 b=lQIEMuIKyThTjWT6BxHC6xg6Xk0AfdVhPHNWpQXHgQD+vK+haQ55bhC/YTrc3GlM4GtugXbSWBAzazk5X/MZznmvhtagbrMgl6s7JElbvJJM7gkq9HNhirnNN2OtRifnIaIHpvSs6TZtEUCXpTXJZtSBacza1QL4/mph8mXNYiDZUJ2rMOtox99F0vvu27MFYaj2S5ymjDSptNNUpRglraUxKAtZjtDjvvv0PLsi8wAm8XntTpg7DRVMCJeoZpaoITQfx0mH7VawbEYwMm8nJkj9aJr2hqqDSXEs/CYljc/6qv28BmW6dyLlj6C8swtGKSDlQ1mHWizCaUDmb0YJIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=broadcom.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Z2eyy7mFUcEGoRqmH4mo2DzH436ChJxlfnJhsiX81s=;
 b=nPyyUk/Kf44DeckdfMg6B13pJgCDEifNGTKjr4UkM9bZx6dgf98+ZZRaA/Ad4gm0ChzcDhKS/8q4v9nZo2Mk32OtoqxfUG7amNmJpVi6MlgRqYJmftqktqetatPk4ixtXu8FintPd8xwRUfB+5SMfukVIw02RDupsEVInG7u6xRuOT7o8kqTSVyVyHwfnrvGkrgGhnWiCcVTl9S7Yy1MtrNi/YLHgia1I7GWd84DhqFBoNJGDx7KxlrSRrI6PUMvMOjeQijj/a9B2oBviYYZbcYLjuMVsiRTT0Uu94JC2evLR3lo88oHnufNX+jM4LES95nlr3O2Vqb7Xq9Z3Z727w==
Received: from MW4P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::15)
 by CH2PR12MB4891.namprd12.prod.outlook.com (2603:10b6:610:36::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Sun, 11 Jun
 2023 14:08:25 +0000
Received: from MWH0EPF000971E4.namprd02.prod.outlook.com
 (2603:10b6:303:115:cafe::4d) by MW4P220CA0010.outlook.office365.com
 (2603:10b6:303:115::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Sun, 11 Jun 2023 14:08:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E4.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.21 via Frontend Transport; Sun, 11 Jun 2023 14:08:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 11 Jun 2023
 07:08:10 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 11 Jun 2023 07:08:09 -0700
From: Parav Pandit <parav@nvidia.com>
To: <michael.chan@broadcom.com>, <aelior@marvell.com>, <skalluru@marvell.com>,
	<manishc@marvell.com>, <netdev@vger.kernel.org>
CC: <edumazet@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <dsahern@kernel.org>, Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next] tcp: Make GRO completion function inline
Date: Sun, 11 Jun 2023 17:07:56 +0300
Message-ID: <20230611140756.1203607-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E4:EE_|CH2PR12MB4891:EE_
X-MS-Office365-Filtering-Correlation-Id: 98420e48-4600-48d6-0111-08db6a85522a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	F3A7RCjC9gTiza9DD/NJitnBmDBNokfNfMQ89R3yKNpNFgUWcyNLfXTmhc0FGUFALhT3ZeitJss5slZ0Tmh19pwsxkTxvkhkvtqxdMD/tz4MwjewAZ+VB2Bi4hi5aTqnniT742IKYpBueCOa9efD+a5jXGhRskFYcasi2oPATWBD5cfAMX9OE0hfoKmgmERPVxqa7TmnkVuAWmF3qf43/QFS2Dp70OxgFaAUw2P0yTuF9oE5rGEc2XzhEukD0f0Sval99fvX3bFP1km6oQpc7+ktEC2FREn7yxHHh3ITcydKxsz+DZKBuw6K+mLYgW0BVidOVkT2vPGAKGGfg2GDdNKsdGfx4yAien/SNHu15qSupMxHpjX+LHGo2UwyFOoKmWVvIdipt7P0yTg/Du0VOWKqkgbVX9pYOoAlJlANb1eykQT2/Y62GKa5cKNhywGffMMRiu1JwerIN42kRcjLCCzshh5ZWQBamhBRWrZqsW5GlyPRk97huHnZGk+6E4D3CFwn9BsOLTi4ZcgDi/kK6cJcngLYdzMFapvPdmFQS+8KXsyjfmygmwJb7Mt2JvCFDcFB6rwcNlzmawmAQsyuxmxC8Aqi0NgA89EEAY0PRmeh/ir7aWKs47sk887aR0zEbHaBXj7CsPVzRcvfInU7jjTXMzS5CvQDJnBQjJ5sGJ/oy67hvwUsTl1rDSdsbETTvZRX+x8akiR23hNn8mGpEa4verKO5jv2JqJB/829YAQ=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39850400004)(451199021)(40470700004)(46966006)(36840700001)(36756003)(86362001)(54906003)(110136005)(478600001)(4326008)(70586007)(70206006)(316002)(6666004)(107886003)(40480700001)(8676002)(8936002)(41300700001)(5660300002)(2906002)(7416002)(82310400005)(7636003)(356005)(82740400003)(2616005)(426003)(336012)(1076003)(26005)(16526019)(186003)(83380400001)(36860700001)(47076005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 14:08:24.3329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98420e48-4600-48d6-0111-08db6a85522a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4891
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

At 100G link speed, with 1500 MTU, at 8.2 mpps, if device does GRO for
64K message size, currently it results in ~190k calls to
tcp_gro_complete() in data path.

Inline this small routine to avoid above number of function calls.

Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Parav Pandit <parav@nvidia.com>

---
This patch is untested as I do not have the any of the 3 hw devices
calling this routine.

qede, bnxt and bnx2x maintainers,

Can you please verify it with your devices if it reduces cpu
utilization marginally or it stays same or has some side effects?

---
 include/net/tcp.h      | 19 ++++++++++++++++++-
 net/ipv4/tcp_offload.c | 18 ------------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 49611af31bb7..e6e0a7125618 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -40,6 +40,7 @@
 #include <net/inet_ecn.h>
 #include <net/dst.h>
 #include <net/mptcp.h>
+#include <net/gro.h>
 
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
@@ -2043,7 +2044,23 @@ INDIRECT_CALLABLE_DECLARE(int tcp4_gro_complete(struct sk_buff *skb, int thoff))
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *tcp4_gro_receive(struct list_head *head, struct sk_buff *skb));
 INDIRECT_CALLABLE_DECLARE(int tcp6_gro_complete(struct sk_buff *skb, int thoff));
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *tcp6_gro_receive(struct list_head *head, struct sk_buff *skb));
-void tcp_gro_complete(struct sk_buff *skb);
+
+static inline void tcp_gro_complete(struct sk_buff *skb)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+
+	skb->csum_start = (unsigned char *)th - skb->head;
+	skb->csum_offset = offsetof(struct tcphdr, check);
+	skb->ip_summed = CHECKSUM_PARTIAL;
+
+	skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
+
+	if (th->cwr)
+		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
+
+	if (skb->encapsulation)
+		skb->inner_transport_header = skb->transport_header;
+}
 
 void __tcp_v4_send_check(struct sk_buff *skb, __be32 saddr, __be32 daddr);
 
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 8311c38267b5..5628d6007d43 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -296,24 +296,6 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 	return pp;
 }
 
-void tcp_gro_complete(struct sk_buff *skb)
-{
-	struct tcphdr *th = tcp_hdr(skb);
-
-	skb->csum_start = (unsigned char *)th - skb->head;
-	skb->csum_offset = offsetof(struct tcphdr, check);
-	skb->ip_summed = CHECKSUM_PARTIAL;
-
-	skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
-
-	if (th->cwr)
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
-
-	if (skb->encapsulation)
-		skb->inner_transport_header = skb->transport_header;
-}
-EXPORT_SYMBOL(tcp_gro_complete);
-
 INDIRECT_CALLABLE_SCOPE
 struct sk_buff *tcp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 {
-- 
2.26.2


