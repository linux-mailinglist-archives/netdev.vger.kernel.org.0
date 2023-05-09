Return-Path: <netdev+bounces-1069-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E182A6FC114
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EFA628127B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A125117AB4;
	Tue,  9 May 2023 08:00:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EAB171C1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:00:37 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::70c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA7E100E8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUEUwEWbtzs8O9QbjpeeyKH/ERIVBc0goxwVK+sFruvF8LDe4n58GRnniaROrIB3zJlQSLmimRIDvSg1WVEEqMBFInSwKhgJPcBTGrNqAJBlxmzuR+LvNtlw4ctvg1OqXobShfmYUxP6BOSYD30tV5cKH+pBhG0rdZE86l/XN/7w7d7DfLUO/VIVcUMPAg1fMA17LjSyjChSZXYCTQbXEp3ehdUup1a9X0s05xNtdkHRYScHy7GV/ohoDI0yEWMd6g7aniPY8i6svzTJOjLWBNzupGfpyex249S41TUNczmoBjJrUMexkod0tPHnOAZawLy+ZeowHtNzc+koqbGX7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mcnWv98A7Ah/yOzuDpjPmiAraeu8/vIanQUSctNTP/0=;
 b=Ao9Ia2UeVB6d/xNED9wDf6Z0j+1Z1EUn1rKv1jgPCDkpFFB0+kUKl5R/FoOiuHUlOhSlaHvzOiwugdEuuYhkPYA5LzDgAPm5l1qIWPCLlK9S+uQKyHWs6tKLdfYs85HwTVtRyzohmzLjT1mLe9LIKUzTIjNPMsF2xPrdkm6uJTgl/4A/Ygk44AkRYkVi9ayFf2HywlG9pGjSYEX//YjvgZblSFWehebdClVFgiMfZBMxKiuN/bvasMlizxCoUGMePBJ1pOGqckLB5uCk9Plk1nLst6LqNkyWrPrYowASSHlujPCxUIDpPzMo/ck304iUjD+vVjgDz4CshgijeEtJqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcnWv98A7Ah/yOzuDpjPmiAraeu8/vIanQUSctNTP/0=;
 b=Bb/8+hne/lyrvjKWbGzkVTjgJ5+776mVSsC3VKuDlvsZ0guRJlcYLVqbhb+Gcru/Jr2lEPKa8pqWBvi8Ub4HUkqee+H64BKzjxeRLQmOYZRE3zBwWndrLUOgmudaSk3p4CJZu5ZAO6jbCnYqDTCEPvSYyVQHmC+6nI/CpRYag9k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 PH7PR13MB5526.namprd13.prod.outlook.com (2603:10b6:510:130::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31; Tue, 9 May
 2023 07:58:39 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e%7]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 07:58:39 +0000
From: Louis Peens <louis.peens@corigine.com>
To: David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net-next] nfp: improve link modes reading process
Date: Tue,  9 May 2023 09:58:17 +0200
Message-Id: <20230509075817.10566-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNXP275CA0030.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::18)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|PH7PR13MB5526:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cc4cbad-b1ab-4499-1f28-08db506332ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	baBP9f9CT1EkG7ErN0tzNHf07JT1CRry5M/ddS2pfBL+iGeBgIL4BxLX1zabKmMjQmPmC5mVY5PzE0rMyuKcyShuUdL/pLa5s8ljD2FSuFvNgUdYRMXtgR8JAFLxjoBpFSul/QNc+GmgvRqVuDiRK7FiwzGytDtLDpIUrMNmAYk72hkMV1vTBtuTFyegoZpXczu+bs6I4P+ZbuH9xj0JmfeyKEfLMP67b3zn66nq+TWPtGXe61mTydQ32ss8VSuDqfQ1ts+08st3MmV/nTVPLU1s9kTKMBH6UDiluBoqPpP3BvetFffGUMXbho1u6c8pHG9txSy+SolAtCgyiEKZOziqzDye1dNCMhmsBbmZ9BFuWDMK9zTUiAwpO78TGYq8un8r+uPjckeiUdVvUJBwmFLJbJBZDuEo3D7Mgnhkp2ij3f4bm1XhhYTylZM/H39nPpuf26Dd705Ok5NXMeOCwP6m5YbKROFY+7fYVJw3gCm8m5veO8/Bl+iZze21eur/jkg1l85x0ngWTsi8XGBUrEG223Ccm3EEbiExZ6LrCoxPw1nXI3/OAOyR3Ycwv3RtPaoA92XQ+FCFUUEyi3PlBdYgQMRG7OJQdkytW+YZsMY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(366004)(39840400004)(396003)(451199021)(86362001)(36756003)(52116002)(966005)(316002)(6666004)(110136005)(66946007)(66556008)(4326008)(478600001)(66476007)(6486002)(2906002)(5660300002)(8676002)(44832011)(41300700001)(8936002)(186003)(38350700002)(38100700002)(6506007)(1076003)(6512007)(55236004)(26005)(83380400001)(107886003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C2rn1ncgDVbRO3rSdQhDSqSjGGzAa8VCW262hUbvVZSjo/l/Fzy5yidaef2T?=
 =?us-ascii?Q?U06nJ7Ld1Y94iDgPpEPEpZyeA14aciAFiALJJsaMNnJdQRvzSlJQQn+n1hkD?=
 =?us-ascii?Q?udrhP1PsoempVjHKL/GounjN76iewhbxmx3Ns6gZFv275T8J9+mzFcsDK2qh?=
 =?us-ascii?Q?+Pa36nFygqWAfeI0sRKTQCaVb87lrrA0jE0NuWO9ZH/vK3T3gE5dJTipZILa?=
 =?us-ascii?Q?q01N+n3j0EX9drLndOgzMPvhFQKVegzBVl4dhsN3SzvHpHnlLmjC9gpBTpV8?=
 =?us-ascii?Q?Dfss+GCkv1hhk+cfiIgzPAnFWOn03X7MfYkV5SGGasbnrcLaJqeEpt7J5Nbw?=
 =?us-ascii?Q?b6sYTSaAXFqPtomSexDfJo3SrZEk7hIymWEJpb+/ERttPZ6mf0j6QU8PGDMe?=
 =?us-ascii?Q?mUyEerWR7hb/6AiCr/X1mvangmdgHPBkG6ixRE2Ekt2jiH1CGGn8RBnqoNJZ?=
 =?us-ascii?Q?z8Jp6EoewjIRWdJroEd6oUZyhqyg2UNC1uXyEM+VNcSbIYQzntXqF7wiycCl?=
 =?us-ascii?Q?9SXI4hzuQP4wqlqztBmYcO68FUr7PPD3J+BOxJBHgUQcgi4a1t4syU84QcFt?=
 =?us-ascii?Q?dCZNTHQMpdhoHDX4tkBsp8XTScZI29wIclkF7MHwpREdHc+NNaGZg19EqgkN?=
 =?us-ascii?Q?B2iAx5cwcxFBhn7r0KgBnwTCjJ3oNgC1m3NaK+lv6ziJqA+jZ119kHa2LpYW?=
 =?us-ascii?Q?gnZGLktZ5PN3/lZaD70OJGZ54NiR7loYuDJB8dvkH175sG9hBzflk+xNNUID?=
 =?us-ascii?Q?5+Ia503ZmtpGAVWni8FKplWkg6kX8Cf/KfrkcxrRRmPdycPD0drcX2buECN/?=
 =?us-ascii?Q?HkADqxeoA18oTxB+UTKmD6SzOFV4ZjQjLsmTOjgrRO1Ie4hTBMrqCyN/SKuS?=
 =?us-ascii?Q?jVt30Z3YkM1m1noGqLDQjNNb8QiS5Z7vO7SXzdVrvcfYKv0APvf8aq42jRId?=
 =?us-ascii?Q?z6Vbdwi7iLd0TgKhO+0eycfIr7s1GWJkG2vB2L88Py70nuQVpKdqLSq95dJ2?=
 =?us-ascii?Q?HitxKKlDEzQ8WN7iMBM+KvtNpSJPEBM3Zm9rgR3N/+abaNP1eSbeuQ5ue68g?=
 =?us-ascii?Q?ovUg5OkSYGZd0Cy6y7g2EBRVCXOsWsoIESon8FKc2HPReFikoOfOHacNlF9E?=
 =?us-ascii?Q?SljLybkZvIHkkv0gY7qex2mHHxwbOTeQOk/kju6dzZdjbpj3l6AA+O6l1QPp?=
 =?us-ascii?Q?EK3NzXNQ9OI1ReiKINqk7vF78dxWw/t2vCgxVQ/ySglM9amnPqEp5jprqV/m?=
 =?us-ascii?Q?eAxgTX0Q99cCaXqMFJ++77jkyA+eb8IbQMIIiWfvzO9+jAfPKuvGHgDT+J9b?=
 =?us-ascii?Q?P805rOvGBP2B2naj5p+Py0GIKZ/Ck7g5Jylc3f+A6nCpv1QYpO80i4tq6TpY?=
 =?us-ascii?Q?YUKseP1IrrhYN6EG0QYMVpZJc+YPsOGtbE6/HhPDSZqlsvzULuqE4H6lQOoS?=
 =?us-ascii?Q?o3gWoRTO+M5zHv8ln5NfGlQTjeccnE1vQKj4yfDz2ZBgzawEBpeKdIPKPesF?=
 =?us-ascii?Q?vwMI6ENJsY3vfzLMixeHoQym4GZsJKe0/6bNXwAQt0aUfV9nMaY7TvMjy/4+?=
 =?us-ascii?Q?EtC4wW0j4mzud64aFfDU1KVO31LEMCM6IP2q6CGsBf8DApcu44Tbs/JX73xI?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc4cbad-b1ab-4499-1f28-08db506332ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 07:58:39.2008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtiUHR41wqzSOoyYNFJPKcgcnZfZk1F1YvrbLRQOk+S4E5h8z8vGE384nKtfDG2WK2Ksrn2Zbf1ae0cuB6TLcgTpcqfI+TvxrFkwrpEFX9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5526
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Avoid reading link modes from management firmware every time when
`ethtool_get_link_ksettings` is called, only communicate with
management firmware when necessary like we do for eth_table info.

This change can ease the situation that when large number of vlan
sub-interfaces are created and their information is requested by
some monitoring process like PCP [1] through ethool ioctl frequently.

[1] https://pcp.io

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 32 +++++------
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  |  7 ++-
 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 54 +++++++++----------
 3 files changed, 45 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index dfedb52b7e70..e75cbb287625 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -436,49 +436,41 @@ static void nfp_add_media_link_mode(struct nfp_port *port,
 				    struct nfp_eth_table_port *eth_port,
 				    struct ethtool_link_ksettings *cmd)
 {
-	u64 supported_modes[2], advertised_modes[2];
-	struct nfp_eth_media_buf ethm = {
-		.eth_index = eth_port->eth_index,
-	};
-	struct nfp_cpp *cpp = port->app->cpp;
-
-	if (nfp_eth_read_media(cpp, &ethm)) {
-		bitmap_fill(port->speed_bitmap, NFP_SUP_SPEED_NUMBER);
-		return;
-	}
-
 	bitmap_zero(port->speed_bitmap, NFP_SUP_SPEED_NUMBER);
 
-	for (u32 i = 0; i < 2; i++) {
-		supported_modes[i] = le64_to_cpu(ethm.supported_modes[i]);
-		advertised_modes[i] = le64_to_cpu(ethm.advertised_modes[i]);
-	}
-
 	for (u32 i = 0; i < NFP_MEDIA_LINK_MODES_NUMBER; i++) {
 		if (i < 64) {
-			if (supported_modes[0] & BIT_ULL(i)) {
+			if (eth_port->link_modes_supp[0] & BIT_ULL(i)) {
 				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.supported);
 				__set_bit(nfp_eth_media_table[i].speed,
 					  port->speed_bitmap);
 			}
 
-			if (advertised_modes[0] & BIT_ULL(i))
+			if (eth_port->link_modes_ad[0] & BIT_ULL(i))
 				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.advertising);
 		} else {
-			if (supported_modes[1] & BIT_ULL(i - 64)) {
+			if (eth_port->link_modes_supp[1] & BIT_ULL(i - 64)) {
 				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.supported);
 				__set_bit(nfp_eth_media_table[i].speed,
 					  port->speed_bitmap);
 			}
 
-			if (advertised_modes[1] & BIT_ULL(i - 64))
+			if (eth_port->link_modes_ad[1] & BIT_ULL(i - 64))
 				__set_bit(nfp_eth_media_table[i].ethtool_link_mode,
 					  cmd->link_modes.advertising);
 		}
 	}
+
+	/* We take all speeds as supported when it fails to read
+	 * link modes due to old management firmware that doesn't
+	 * support link modes reading or error occurring, so that
+	 * speed change of this port is allowed.
+	 */
+	if (bitmap_empty(port->speed_bitmap, NFP_SUP_SPEED_NUMBER))
+		bitmap_fill(port->speed_bitmap, NFP_SUP_SPEED_NUMBER);
 }
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 781edc451bd4..6e044ac04917 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -196,6 +196,9 @@ enum nfp_ethtool_link_mode_list {
  *			subports)
  * @ports.is_split:	is interface part of a split port
  * @ports.fec_modes_supported:	bitmap of FEC modes supported
+ *
+ * @ports.link_modes_supp:	bitmap of link modes supported
+ * @ports.link_modes_ad:	bitmap of link modes advertised
  */
 struct nfp_eth_table {
 	unsigned int count;
@@ -235,6 +238,9 @@ struct nfp_eth_table {
 		bool is_split;
 
 		unsigned int fec_modes_supported;
+
+		u64 link_modes_supp[2];
+		u64 link_modes_ad[2];
 	} ports[];
 };
 
@@ -313,7 +319,6 @@ struct nfp_eth_media_buf {
 };
 
 int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size);
-int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm);
 
 #define NFP_NSP_VERSION_BUFSZ	1024 /* reasonable size, not in the ABI */
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index 570ac1bb2122..9d62085d772a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -227,6 +227,30 @@ nfp_eth_calc_port_type(struct nfp_cpp *cpp, struct nfp_eth_table_port *entry)
 		entry->port_type = PORT_DA;
 }
 
+static void
+nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_nsp *nsp, struct nfp_eth_table_port *entry)
+{
+	struct nfp_eth_media_buf ethm = {
+		.eth_index = entry->eth_index,
+	};
+	unsigned int i;
+	int ret;
+
+	if (!nfp_nsp_has_read_media(nsp))
+		return;
+
+	ret = nfp_nsp_read_media(nsp, &ethm, sizeof(ethm));
+	if (ret) {
+		nfp_err(cpp, "Reading media link modes failed: %d\n", ret);
+		return;
+	}
+
+	for (i = 0; i < 2; i++) {
+		entry->link_modes_supp[i] = le64_to_cpu(ethm.supported_modes[i]);
+		entry->link_modes_ad[i] = le64_to_cpu(ethm.advertised_modes[i]);
+	}
+}
+
 /**
  * nfp_eth_read_ports() - retrieve port information
  * @cpp:	NFP CPP handle
@@ -293,8 +317,10 @@ __nfp_eth_read_ports(struct nfp_cpp *cpp, struct nfp_nsp *nsp)
 					       &table->ports[j++]);
 
 	nfp_eth_calc_port_geometry(cpp, table);
-	for (i = 0; i < table->count; i++)
+	for (i = 0; i < table->count; i++) {
 		nfp_eth_calc_port_type(cpp, &table->ports[i]);
+		nfp_eth_read_media(cpp, nsp, &table->ports[i]);
+	}
 
 	kfree(entries);
 
@@ -647,29 +673,3 @@ int __nfp_eth_set_split(struct nfp_nsp *nsp, unsigned int lanes)
 	return NFP_ETH_SET_BIT_CONFIG(nsp, NSP_ETH_RAW_PORT, NSP_ETH_PORT_LANES,
 				      lanes, NSP_ETH_CTRL_SET_LANES);
 }
-
-int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm)
-{
-	struct nfp_nsp *nsp;
-	int ret;
-
-	nsp = nfp_nsp_open(cpp);
-	if (IS_ERR(nsp)) {
-		nfp_err(cpp, "Failed to access the NSP: %pe\n", nsp);
-		return PTR_ERR(nsp);
-	}
-
-	if (!nfp_nsp_has_read_media(nsp)) {
-		nfp_warn(cpp, "Reading media link modes not supported. Please update flash\n");
-		ret = -EOPNOTSUPP;
-		goto exit_close_nsp;
-	}
-
-	ret = nfp_nsp_read_media(nsp, ethm, sizeof(*ethm));
-	if (ret)
-		nfp_err(cpp, "Reading media link modes failed: %pe\n", ERR_PTR(ret));
-
-exit_close_nsp:
-	nfp_nsp_close(nsp);
-	return ret;
-}
-- 
2.34.1


