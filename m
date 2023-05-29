Return-Path: <netdev+bounces-6043-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF415714850
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:08:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 492B91C209C6
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8786AB9;
	Mon, 29 May 2023 11:07:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A54A6FAA;
	Mon, 29 May 2023 11:07:05 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9887CCD;
	Mon, 29 May 2023 04:07:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2rPOxKP/1zvy1Nqn6Mi0GCXMlxrrKbmSoWpg1SLqPiPUFi8/r0Z/cNFz8h2u0rhtjP5gfiLR2kdkh6gA2qLRQH2FwHUNt6h6ZEOcRyjOuYxnGRcpDm5RqFJ3RwIZ8+LD7qGDErXop1qsKLXzLwtLLUsWWrnK7bMukviQZ9kvFVbBkcW3yccjhq3AD2LQV77bcw9SV+KEFbfHqviJMJi7fOZ4vk7itVmrwp3kNMKLVVhf20gum2cf5uaR0+gfs12CBfzCmCm/vOzC3Qe6mSpMvyY47t+geEFRecBknAn5+XS+POcfw7/naTMb/sKAkwjjMe9MjY4KLyfQE4Njb8Hrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmR4uOOcYTjS2mseZe13g+DKAkcYDOI+Tz0W46e7FVo=;
 b=g+hkMtUMFejCcb0jwIUJtNkWWEvY0kvSoC8erDWcXMzdSVyer6IQcKwQxFT+CboywavEgRROygTHNhavLXJ0qz6XO94KdvFIlQm+FdmIrYdsKwO/LN6Wi1ZGG5BoV+MeY02hXJGqR2Fn0VVGp5wJ8ncqh/nPOrZJp3WVVQdYkkXyUaI1aB/+AwMs4kpHVrclu7CnAYb7CMxS0V91oCTKXpjh1z10TmsCr/4I6/yOnlNJDyCv28j7WCtH22vNRlq5QyQKcpYTIRysX7eb264w9nPuWy+DScJv/NscFL8zj0YlqFqnY9nyScsA7qcKUVv0jt7K+Z8BTW8oFBaluFL90A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmR4uOOcYTjS2mseZe13g+DKAkcYDOI+Tz0W46e7FVo=;
 b=REuEHllmysHLG/89trJ4QllhZr+Jttp4wEVHSB48EI3u5AXpY19pBk3v+LWKoDgC9Kh5s34SHrJV58l4DmkMzCxpBbXNYoSf+Z8tuAsVx7jQv0Hzq8OA/9xpoz/VTnvikTxkueQGfWjeIt9TuCXbU47+6iflcdGm2lwNeXlf9h1vFZnNeLWZi4frfmMvx49SEdAPgvmGtdqUVTj7rX+x4XgHTikHue+fxeXJcouCzApRmAh+vRFZiSSbapM+Mp8QLDXgfGw1UOMn+Blx3Yl02QJL49FRk9P+KdQLPKz20QqOJrtEsDLuB7FO5CtPANuJR6UF3nbe/u/H+c/9wakxLQ==
Received: from BYAPR21CA0007.namprd21.prod.outlook.com (2603:10b6:a03:114::17)
 by DS0PR12MB8573.namprd12.prod.outlook.com (2603:10b6:8:162::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 11:07:00 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:114:cafe::c) by BYAPR21CA0007.outlook.office365.com
 (2603:10b6:a03:114::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.5 via Frontend
 Transport; Mon, 29 May 2023 11:07:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.21 via Frontend Transport; Mon, 29 May 2023 11:07:00 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 04:06:46 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 29 May
 2023 04:06:45 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 29 May
 2023 04:06:42 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Alexei Starovoitov <ast@kernel.org>, John Fastabend
	<john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>
CC: Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer
	<hawk@kernel.org>, <bpf@vger.kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	<netdev@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH bpf-next 2/2] samples/bpf: fixup xdp_redirect_map tool to be able to support xdp multibuffer
Date: Mon, 29 May 2023 14:06:08 +0300
Message-ID: <20230529110608.597534-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230529110608.597534-1-tariqt@nvidia.com>
References: <20230529110608.597534-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT039:EE_|DS0PR12MB8573:EE_
X-MS-Office365-Filtering-Correlation-Id: cec20769-928f-4ce8-a73a-08db6034d351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4UlLwjZJqVDdKO6Bl7q9i50QpDn6tdXQhiBbE9G+J6NuBB3PEByWtIe2ptm/1I5/1SGMlsVrpplLe6+x/fcZSDSosLmmPHN5UTxTkq8MP+rPI0I6FCKNG8ZavKh96IUsi/kll+eeGPKY2sWGEqXwmawQZqRcS97FdPFbLb3BLnP/QiAFi8LVtQP8DCeuBhYdryh5Ulu8bn3D80xSl67/722rgOR39qvwFz7N9oTBNWiSXKyZ1FC0xETscsAaXmyibkQoo8VkS1VzOsf3hD7xmfNtzZvHzPIr2JT0kG6Rp5qFJPrIftQ8R2aIaaCHu+ljcpIF0PMy7u1nyImOsCuVWhdF6J9HMYaDZVb/bZK/uWB+VzDbz3RTAPSmr2Yqz+FGhuCrG2smKeiJSC6rwDh8lnSsqUrx9o4ppe6GMZk8TJyRyDl8CzHhcLchmhaqN1v7q6JHC8pCKzdjxJ5ApMrEPa1fuRpHqpAHA3jRGghmn4yKqSqJttvKw3bxpk/Wek9CZECEUm1g6FpemFlO1YQjy40Cts4os7CroxdG6HmIc92QXOArv7dsZfW7QR63HYqDndMsdxQSpHtMRqbP84M1Emz4qCVXbzfy2kdhB0JbvZlQyAf3/igNg8elwnWyoXWgKIT04W5od/MpVzTbiZcSzOycxM4ieGzLeh8tAdjOX0wRcDWaJxtzceizJXkdsZrQyN+8wfU7u/sYYx1SGgNWezbIQsVs+BrIwi0KJwcw9E0Hsnncw++5MOrvGcLs2R/r
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(46966006)(40470700004)(36840700001)(54906003)(478600001)(110136005)(40460700003)(8936002)(8676002)(5660300002)(36756003)(2906002)(86362001)(82310400005)(82740400003)(70206006)(70586007)(4326008)(316002)(7636003)(356005)(40480700001)(41300700001)(2616005)(426003)(336012)(107886003)(186003)(26005)(1076003)(47076005)(36860700001)(6666004)(7696005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 11:07:00.1560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cec20769-928f-4ce8-a73a-08db6034d351
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8573
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Nimrod Oren <noren@nvidia.com>

Expand the xdp multi-buffer support to xdp_redirect_map tool.
Similar to what's done in commit
772251742262 ("samples/bpf: fixup some tools to be able to support xdp multibuffer")
and its fix commit
7a698edf954c ("samples/bpf: Fix MAC address swapping in xdp2_kern").

Signed-off-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 samples/bpf/xdp_redirect_map.bpf.c | 31 ++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/samples/bpf/xdp_redirect_map.bpf.c b/samples/bpf/xdp_redirect_map.bpf.c
index 8557c278df77..dd034fdff1a9 100644
--- a/samples/bpf/xdp_redirect_map.bpf.c
+++ b/samples/bpf/xdp_redirect_map.bpf.c
@@ -35,15 +35,20 @@ struct {
 /* store egress interface mac address */
 const volatile __u8 tx_mac_addr[ETH_ALEN];
 
+#define XDPBUFSIZE	64
 static __always_inline int xdp_redirect_map(struct xdp_md *ctx, void *redirect_map)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	__u8 pkt[XDPBUFSIZE] = {};
+	void *data_end = &pkt[XDPBUFSIZE-1];
+	void *data = pkt;
 	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	struct datarec *rec;
 	u64 nh_off;
 
+	if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
+		return XDP_DROP;
+
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
 		return XDP_DROP;
@@ -53,30 +58,37 @@ static __always_inline int xdp_redirect_map(struct xdp_md *ctx, void *redirect_m
 		return XDP_PASS;
 	NO_TEAR_INC(rec->processed);
 	swap_src_dst_mac(data);
+	if (bpf_xdp_store_bytes(ctx, 0, pkt, sizeof(pkt)))
+		return XDP_DROP;
+
 	return bpf_redirect_map(redirect_map, 0, 0);
 }
 
-SEC("xdp")
+SEC("xdp.frags")
 int xdp_redirect_map_general(struct xdp_md *ctx)
 {
 	return xdp_redirect_map(ctx, &tx_port_general);
 }
 
-SEC("xdp")
+SEC("xdp.frags")
 int xdp_redirect_map_native(struct xdp_md *ctx)
 {
 	return xdp_redirect_map(ctx, &tx_port_native);
 }
 
-SEC("xdp/devmap")
+SEC("xdp.frags/devmap")
 int xdp_redirect_map_egress(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	__u8 pkt[XDPBUFSIZE] = {};
+	void *data_end = &pkt[XDPBUFSIZE-1];
+	void *data = pkt;
 	u8 *mac_addr = (u8 *) tx_mac_addr;
 	struct ethhdr *eth = data;
 	u64 nh_off;
 
+	if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
+		return XDP_DROP;
+
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
 		return XDP_DROP;
@@ -84,11 +96,14 @@ int xdp_redirect_map_egress(struct xdp_md *ctx)
 	barrier_var(mac_addr); /* prevent optimizing out memcpy */
 	__builtin_memcpy(eth->h_source, mac_addr, ETH_ALEN);
 
+	if (bpf_xdp_store_bytes(ctx, 0, pkt, sizeof(pkt)))
+		return XDP_DROP;
+
 	return XDP_PASS;
 }
 
 /* Redirect require an XDP bpf_prog loaded on the TX device */
-SEC("xdp")
+SEC("xdp.frags")
 int xdp_redirect_dummy_prog(struct xdp_md *ctx)
 {
 	return XDP_PASS;
-- 
2.34.1


