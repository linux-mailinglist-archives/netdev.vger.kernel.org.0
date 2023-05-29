Return-Path: <netdev+bounces-6041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 746E871484C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C37A280E01
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5618263A1;
	Mon, 29 May 2023 11:06:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B70110E2;
	Mon, 29 May 2023 11:06:58 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA01CD;
	Mon, 29 May 2023 04:06:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZTfBLyK/Y7Rq3DxcdxxWpg3YXbJtRyOxGSTLf/JSnj5Y049QQJ0Yz54PRWAVkpS7uERkHg5cdu3l0Zr9nu8CsnPOzXtR3qNctDRfTj7apTBLTVykP2oUSg04xfWSi/9SVeKcNxUfFMfw67wZu7vEamWtijA/SEXlGHchgiEMro+CkZS9Vz8wH1QK76efIOd7l3N9+qSx363+GDieVV+f9ucJNclUU4qoRcg0qLWN9Q65bMnseCITAVlM6nWk6rWgF8mN5bcv1JO+bGBJVeNqiu0AQK2ZBEhiCr3fdDm+jg63J1fRE1mSBTUlygdLimQUQzzszEg+MA1UNJXTnQ9Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7BNV9qpB5aslqlBal9nKzlP6gvFS5XHhdilASyECr8=;
 b=Ub58QWhxhqO+G+HfwCoUB151MdKfFvYksMlc0VlJ9H0Ue2n61AtjxIgIEEvzvgw/ns9dkfCq0yJmJN3N1qlNMGWtLF2q3cputelvS1CCdSlpml35QJ1Zsz80A5pFaTu706FvpUacnzwpFx2H2OiJJ+tpfEo2CojrzuYyfjsuHu6H9DolZTAdiG+0NoDx+kiD7UhsTrAKf3ujV/sv3ft1Szg8AIji1W36FwUFLUCMGbJMcFGJeB4qXts6Jnuj2zKT7nMs9c2ZEAWvCrAOqK1bhCdnqqMZDIJpmqS+Sh4XC6lkc78lGTT8gDwl0J7KMGHKrnU45D/LQh4vIUYhBil3qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7BNV9qpB5aslqlBal9nKzlP6gvFS5XHhdilASyECr8=;
 b=W2xsuzFBPBCPHF3zrEFlc/fe1JsNJxuZGZKUr+wGfMUUmpPDOiLryiRdDc5KnAkMtIdPdmUSXXBzdNuyp8jbkzG15pO1gq+TLR1BL8KU1mPTsFbZm4O1DXqQxU61gJNXNyWignyQxLhq+9Uz1B8SCVc904wew/cqwDmTKPj44J03RVAPQx9GS8EEeMNPO/V/6XXKITHxRHLELP+nH4OSN4v9Hzc8JCu5QJH6O5SQ4PV1IZkVqRgZ0iYjywQ1eXUQPgaZV0R6kq2Fsz008JEgISRy1tIZ75LhDwuNiPHBN/ctjulDCZV3oCVxFkBm91x8Qv7fPin3jVkek2GeMGk3Jw==
Received: from BN9PR03CA0966.namprd03.prod.outlook.com (2603:10b6:408:109::11)
 by DM4PR12MB8571.namprd12.prod.outlook.com (2603:10b6:8:187::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 11:06:54 +0000
Received: from BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::9) by BN9PR03CA0966.outlook.office365.com
 (2603:10b6:408:109::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Mon, 29 May 2023 11:06:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT102.mail.protection.outlook.com (10.13.177.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.20 via Frontend Transport; Mon, 29 May 2023 11:06:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 04:06:42 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 29 May
 2023 04:06:41 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 29 May
 2023 04:06:38 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Alexei Starovoitov <ast@kernel.org>, John Fastabend
	<john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>
CC: Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer
	<hawk@kernel.org>, <bpf@vger.kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	<netdev@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Nimrod Oren <noren@nvidia.com>
Subject: [PATCH bpf-next 1/2] samples/bpf: fixup xdp_redirect tool to be able to support xdp multibuffer
Date: Mon, 29 May 2023 14:06:07 +0300
Message-ID: <20230529110608.597534-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT102:EE_|DM4PR12MB8571:EE_
X-MS-Office365-Filtering-Correlation-Id: 3143f41b-50b4-423d-d5df-08db6034cf6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	snX12g5UL6d8OBNtkCcZSY1LH/LXcr9xvnN/l3nQEL6gpSqNw8yLrPHq6GEoqMgilEHJVwO3s1Lo/ExoPrsNBhmqMt64eNcXuxKDiypHAkq613XmEZ0PKxfNlJt/b6XxaPP2sZu4+WQD77eMOyOrJCk/mxV1Qq5395OMVuZB6p1A7TWtzG755NHJpl344P3aeVDUty5zVwiMGy1wfH8ggqbRGsBSzSBnBWYH3RtXFdqZrBAqbxVL9pWwEHKwV091cUe6lbfdLptizdBRVyL8osv0z/6M3u5B6Ni+9+nuJVGrI4GN2B8/Tu4fiTCraQdDr/cfsj5jaO5bfHqjTsIapLyvrBEryo/mkH1SPSo7bvnlTm4sApzX0GOGvUw7EMhYwO9g4EwYMlbkxLGiXzQ9TDsT/QMQpWLwko8/D5H3WBaIGDArWxBhk4dcdDpM7kUIXBL2GMDex9++A1L90xHOQ2KTx2+jFMnVBIUt7MRuqjDvSMtlZB9UIzBdk3G9I42VuTtpg/nx7bnDT1Jg8fQiad8Y0gP5EvlN6x2HQarHDuLOjnqMiLZksQkIy8VSGaRRkJJk8xUiLfCOHp6/GOdDm8eE2UlLrJA5z/FijiNIJCAsXD4/6ejqnIx2rhFQp8Rz2UAs3McJ/lUzwa5k2Q6CE1Wsgse8Nm+a4/o5mDTNnrxVgNNUPLc/c/6RU5aOZgnxFcj+kjIF2XlUvZwOirKOg+k3NTJO4j5VZoG8zpeBWmBJxQukMQhPnndqzaAZsEqL
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(376002)(346002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(36860700001)(40460700003)(83380400001)(47076005)(316002)(6666004)(5660300002)(70586007)(36756003)(70206006)(107886003)(4326008)(82310400005)(82740400003)(356005)(8676002)(7636003)(41300700001)(8936002)(7696005)(86362001)(40480700001)(110136005)(54906003)(2906002)(2616005)(186003)(336012)(426003)(478600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 11:06:53.5764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3143f41b-50b4-423d-d5df-08db6034cf6c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8571
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Expand the xdp multi-buffer support to xdp_redirect tool.
Similar to what's done in commit
772251742262 ("samples/bpf: fixup some tools to be able to support xdp multibuffer")
and its fix commit
7a698edf954c ("samples/bpf: Fix MAC address swapping in xdp2_kern").

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
---
 samples/bpf/xdp_redirect.bpf.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdp_redirect.bpf.c b/samples/bpf/xdp_redirect.bpf.c
index 7c02bacfe96b..620163eb7e19 100644
--- a/samples/bpf/xdp_redirect.bpf.c
+++ b/samples/bpf/xdp_redirect.bpf.c
@@ -16,16 +16,21 @@
 
 const volatile int ifindex_out;
 
-SEC("xdp")
+#define XDPBUFSIZE	64
+SEC("xdp.frags")
 int xdp_redirect_prog(struct xdp_md *ctx)
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
@@ -36,11 +41,14 @@ int xdp_redirect_prog(struct xdp_md *ctx)
 	NO_TEAR_INC(rec->processed);
 
 	swap_src_dst_mac(data);
+	if (bpf_xdp_store_bytes(ctx, 0, pkt, sizeof(pkt)))
+		return XDP_DROP;
+
 	return bpf_redirect(ifindex_out, 0);
 }
 
 /* Redirect require an XDP bpf_prog loaded on the TX device */
-SEC("xdp")
+SEC("xdp.frags")
 int xdp_redirect_dummy_prog(struct xdp_md *ctx)
 {
 	return XDP_PASS;
-- 
2.34.1


