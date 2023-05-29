Return-Path: <netdev+bounces-6072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1409714A97
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01FE4280E0E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D697488;
	Mon, 29 May 2023 13:45:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EE06FDE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:45:24 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7742E129
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:45:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8YhTx+8ZTSmbBUauSZyFUSOYY4p7Foq5yHt5FE+oGsvjnrkFTfFhMmzSFMGpDntD/6+4w8+bLXds9gXPxGjIc1tNXdVHdzW3ccIyAgH4CT5UOnVhDfBtmKIizNQn6zGqQbWx1lJgmnQEAzvWUPQwLv1LQqTuypg4gFrViz52Q8m4q7SIqHgM/aJOYgBh0Rorka3dnXCStoZx0u/M4x23jwKuC765rl90COKnVJMAugkE5Dx8ub78KGoH+dR1XNW5cyxINK9hfjA7lEljsSqAh+4daq6wzIAMBbBluWyOwIau4yCH1XQL4VfDWC1utOILr43hai3ogFbt70kFWvq0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzIEx/cmLKuPl08spVJQ9hKNDePCJO6/9Bi/rNB3jFI=;
 b=A74XTksicxYIAf3VuhzeudNe7SG70KSdJ4+7307txkbjeIBki84hfaKTAtxfmMjHsHAzEnZoQ8j/tb85YCz0IhBBaDWXJOdTZASHs/6CSa7SOOHfJtD34AfSRCWxGZGwGF/zueUwvmjGeoKg+jnLx/VoQkg9RUc1x7ZMMXz8kx7znHaUV0jVUIQ7RgAwWo95IX3/ENjAFnbfCGPjZpaRSnktqog1x8AagdkKSBi+4nJLni0w+Qx2vbHI3axMhOkuPRRMPnLgAbmqYLsrL9TGe2NYuiHEsIt+W580LtFlOduSELRtC+11q3VbBpNG9fc3CGOjcbr2jGUv7qP9D6BSzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzIEx/cmLKuPl08spVJQ9hKNDePCJO6/9Bi/rNB3jFI=;
 b=BEWXUSuK5qdc01cszSosq2XezU2XlQTeZ79R16ZDGwf4igSneZVKQ3/EMzuKNBvOyJPgLe6B2CJGNuWdOKchwuz0WtX3tkQcLsQHLCJH9b02tbRy3elvaGBAEn2sWYF1GTZx3WJVVgV3ZB9e3WF75X6pGWDbSQzHopg+2E0JA90ys1zrZXmvUsjeCWxgRrUOUZXArqtigKWpGPwGj0Lz6uYw8f/rTulBnvj/hHcRyQUKt7YbQZ/w6y6Eu45Ltn29bIcgmihy87+u1gKJpjlvIsv60sFnybk0ZW6VMz6LBFvXVSXJPrq6PMrIZ4/RoDco6EsTIDP4p/Yix1Mba4RHXg==
Received: from DM6PR18CA0018.namprd18.prod.outlook.com (2603:10b6:5:15b::31)
 by PH8PR12MB6987.namprd12.prod.outlook.com (2603:10b6:510:1be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Mon, 29 May
 2023 13:45:01 +0000
Received: from DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::85) by DM6PR18CA0018.outlook.office365.com
 (2603:10b6:5:15b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Mon, 29 May 2023 13:45:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT085.mail.protection.outlook.com (10.13.172.236) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.20 via Frontend Transport; Mon, 29 May 2023 13:45:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 06:44:53 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 29 May 2023 06:44:52 -0700
From: Parav Pandit <parav@nvidia.com>
To: <edumazet@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <dsahern@kernel.org>, <netdev@vger.kernel.org>
CC: Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next] net: Make gro complete function to return void
Date: Mon, 29 May 2023 16:44:30 +0300
Message-ID: <20230529134430.492879-1-parav@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT085:EE_|PH8PR12MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a65b478-d722-4503-6358-08db604ae648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	24DZRNpg6feSXTRBRKMwCp2CeNTXg5ZR7GUeWrXJJhxfmgEJW6Tviu1/ytQckdy4H8gpvy9xQT+LfqZhzJSVdLFlx0FpRJXDkxvkTddVKhz6+RFdVBhxySzZSfyYqUehaC85Auf+KrD4966gbDRfMCERrSCvR103RDYpNfriIdmacLl6FDAAeuJR1MRW2AjLAdD6DLK/8UDvyuYYWdqFln9Nj2RWzVWK3QCzG5Fz7g3/AGkJbkvkgBGHvGkM6zY6/qxBkqcSJ9abwNrdULsUgscYMWcfryhfYAQWkN8ChYu7iPyn6Dcak7KP1v76BQghdRyRioyLQATgaxBeWDUTC/zQtN0E/+xHgUsvTUXeNS7+iDrjx0y0PcFWeIGRrVkvI1zzshefC5o172K8N+qFCjQbe49gXDHhq7/p5gWZOI1qOZVwYaZho4bwt/c1/jpa0voFio3ojF56sSgMpol1iBSMahlLnDg5qxaaEIupgRuAHL2YR1PbaE4ydaKff4Vfcf0tAfiLOEKsw/iN7IrWs3AdR6S0Gprp9/7i2BIVTHZRIv7XCTFpGr3HvWSmgsWcj6jrkVh8RRW8BU17TYIBwvc4H05QMziUKiQLq5jS/FAvIBM5YpRod4qqOqgSCxsPlUtjGAerbPEPBAmXwOhQXOI0/PJJQ6EwEVEcylSOys1K5MGmbGSQ8DrJ67e7VLFNDS+EtNaodpkYrWpADXm6/snY4uo9/aYiyyIv6o+NpwY=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(36756003)(110136005)(4326008)(316002)(70586007)(70206006)(478600001)(40480700001)(82310400005)(16526019)(2906002)(8936002)(8676002)(6666004)(7636003)(5660300002)(356005)(426003)(26005)(36860700001)(107886003)(2616005)(1076003)(47076005)(83380400001)(41300700001)(186003)(336012)(82740400003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 13:45:00.9001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a65b478-d722-4503-6358-08db604ae648
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6987
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tcp_gro_complete() function only updates the skb fields related to GRO
and it always returns zero. All the 3 drivers which are using it
do not check for the return value either.

Change it to return void instead which simplifies its callers as
error handing becomes unnecessary.

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 include/net/tcp.h        | 2 +-
 net/ipv4/tcp_offload.c   | 7 +++----
 net/ipv6/tcpv6_offload.c | 3 ++-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0b755988e20c..14fa716cac50 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2041,7 +2041,7 @@ INDIRECT_CALLABLE_DECLARE(int tcp4_gro_complete(struct sk_buff *skb, int thoff))
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *tcp4_gro_receive(struct list_head *head, struct sk_buff *skb));
 INDIRECT_CALLABLE_DECLARE(int tcp6_gro_complete(struct sk_buff *skb, int thoff));
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *tcp6_gro_receive(struct list_head *head, struct sk_buff *skb));
-int tcp_gro_complete(struct sk_buff *skb);
+void tcp_gro_complete(struct sk_buff *skb);
 
 void __tcp_v4_send_check(struct sk_buff *skb, __be32 saddr, __be32 daddr);
 
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 45dda7889387..88f9b0081ee7 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -296,7 +296,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 	return pp;
 }
 
-int tcp_gro_complete(struct sk_buff *skb)
+void tcp_gro_complete(struct sk_buff *skb)
 {
 	struct tcphdr *th = tcp_hdr(skb);
 
@@ -311,8 +311,6 @@ int tcp_gro_complete(struct sk_buff *skb)
 
 	if (skb->encapsulation)
 		skb->inner_transport_header = skb->transport_header;
-
-	return 0;
 }
 EXPORT_SYMBOL(tcp_gro_complete);
 
@@ -342,7 +340,8 @@ INDIRECT_CALLABLE_SCOPE int tcp4_gro_complete(struct sk_buff *skb, int thoff)
 	if (NAPI_GRO_CB(skb)->is_atomic)
 		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_FIXEDID;
 
-	return tcp_gro_complete(skb);
+	tcp_gro_complete(skb);
+	return 0;
 }
 
 static const struct net_offload tcpv4_offload = {
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 39db5a226855..bf0c957e4b5e 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -36,7 +36,8 @@ INDIRECT_CALLABLE_SCOPE int tcp6_gro_complete(struct sk_buff *skb, int thoff)
 				  &iph->daddr, 0);
 	skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
 
-	return tcp_gro_complete(skb);
+	tcp_gro_complete(skb);
+	return 0;
 }
 
 static struct sk_buff *tcp6_gso_segment(struct sk_buff *skb,
-- 
2.26.2


