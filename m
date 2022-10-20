Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22EA605C2C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiJTKW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiJTKV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:21:26 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDBDFF8FE
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzUlv+D95SL0vrUOu9kjENK9qN4ZwvJrwdYe3EXYeOar+qAnX66xyc3QJ7MTsqtz+azOgcFmPbowbQ8iJZwTTzvn4t6Hw7lxvgBLpfPHSC81e9lOF9jJ9s37sNzVkbyqzIPX0RWINHqo12tyqtsUZ5bvW+9IXZZrJg/T4vlSpkPqR4OTQaDJTTMgNq0cETr1nHbbjJteeVBd1HSfwD7NgqI1Sgf7kX7MtddtTjMZyb39cvTnnFT5e8mtKq7H5gCZPcYnSeDO2+H6vtebVzAvAEuKkI6NeRQW+mlQDse+6lSHrSkyU6dN2xHczPIRhBbf26Y7Q7G9EiJENxpGHpj9jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3fYufg1e4otkY/vwpDVhJbX/0uMka7RYk5CSFAnS6c=;
 b=lHYk2AMF8bM2Joo8PkEkNqZVMhw47H2dxZw/QvU4vf3khnaIThLIYxyrHKjA4q8oKhCCLfE5xv/ZYo74x/cd5bFb5A00xS7guSPzoPAVPNSqoEOJNgnQpbBj/cpANBg6naPdtNpyHasLDoDlTk3rcl+PhlDyZcQoPaMsPssLyOkKQA57NRNJLPfQ65No4btNy9wkkA5FLmBRLTAmlBnhBXrmq2S6yDvHn3tCojAhGSFods00xoRpE+53RdsUDA2s0doBsqrOdmk+2HldRKgN5MDZzAst55meYmIseBfOkS1xcRxALqnB9i2Bk9gOEqQ3sITOWcCEKsE5jbouCMODCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3fYufg1e4otkY/vwpDVhJbX/0uMka7RYk5CSFAnS6c=;
 b=WyYS2FYIOZXhIkckPlmJjgqG2aYLmIaouPh8NbS0DCM6kGsz7U+ruT7waRa4DHqM2rbFVPgH6M1mMlODZKtZAg7AuWOf1WGtIp2HN+Jlf3WizgV1lHrXOG6wwJAGIfd0o3WZV7LqdwFXR8f2T1wnZpuYsOXRYTs0je3HG477QvN1dUSEatfMvdx5RLLJTmQBVwIlUgljLwSdl2N9iy+qcbrJdQyadVuNB9esARwUAgR7IfAgkuqcHf3mYpLdiWD2cQYuUnqQ8Kue0X9B46NVJqWc4icZAIrkDCd4R4HdeEpCTtpTY48bVkEYVouQ/M0ZUpOT+D0CW27dlfh/fccUVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by SA1PR12MB6946.namprd12.prod.outlook.com (2603:10b6:806:24d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 10:20:43 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:20:43 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 20/23] net/mlx5e: NVMEoTCP, ddp setup and resync
Date:   Thu, 20 Oct 2022 13:18:35 +0300
Message-Id: <20221020101838.2712846-21-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::15) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|SA1PR12MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 71450cbc-39ad-4401-b7e2-08dab284beb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ImHhr+dvdYWrWJIoP/sXbYZAwDTAfs7AiFNnHMDS6VagA3YJUuWojP5hrCnpccI/3RrSFU0bCf3r2KuRoqMAFiWb5AzCF7LHRreSey9zKd7+wk04O1Rg0JPhtyRYFraAycPocJ+gyIXOeaSsN8Ld+/EyPD5yGh18GJlI/rqrVBL+KAqqf3VyTM4JupoFlD7GvCunFZNG7RTpFiRimn6tF66A6SLJLuTaRdfM5MYOCBBHel8lLBgwBtrr4cWGukzSR/JwBYZNBOImWWnc3NzDeQRJOiPrdBH07IoF7mmZvnFKsJ+SkIkl/+JgZP55K+gbmaG88qJ1e1gMofpGZnLLlTLR59KwQcnqR8tc/tlQ7bE44tVVlJaHVUDwjyGv4aaMrSX5LCZhDrETRhNZUXR1UN1BZbh4jVUQPFtxIFw1SZfZUPjfUiggdotATYLYNjSyVR46gi9bG9NNoDaJrSyFgMIozOMqUzzlMMfIvgk3uGIB9OnekhjKfuZbxfYgrvFu/6laQqX0AIbQv+CYnZwX267N0BZBpKKyLO1+rogKmF341bWvjtvKl+CusjuRVGqxRHgpKwH2lMxm25uuiV11mUo0LV3gwgptr/6d07R4EZ4lxsIy2IAIFdVQsWxUPCRozpm/A/nJHkbCD8UCP1ZSmtu9PV4k1GHe9om+Tp0RqUIi0XY/KnRSKwibxAMWEXm3t3e9FAQmT1F/I0CmpjF5kn6iAU/LnMjbQzCZ8o+umRrS5ggPd8S+NAgWv3t+L7cC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(36756003)(83380400001)(186003)(86362001)(1076003)(2616005)(38100700002)(921005)(8936002)(6636002)(7416002)(66476007)(5660300002)(316002)(4326008)(8676002)(66946007)(41300700001)(6666004)(478600001)(66556008)(6512007)(26005)(6506007)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WGN3TMz1NpLLdA/hawIsIvcsZbNlOh46zHzLs8gfixnscabOhwRQUZDq8Xd/?=
 =?us-ascii?Q?NKy91r7kkYmiDnCXVyUq0vlCfKO/j09L0h8kTx3VPtFcM2i72e4NB4rysm5N?=
 =?us-ascii?Q?mNeyCg/a4EG86LvzIYXE9OtK8efjmHxA+KwFR4ZeBGEqNz53Je5xiPKHrcFm?=
 =?us-ascii?Q?TL8WGQI49gHRx2JaOHBKTUn22Ra1w0OP9w4lPsdckrJLLGmjEyvM8UdUvMDf?=
 =?us-ascii?Q?DlMRYbS1oDDrggc7b3u+S/LWxJEhZIcXbvYFSJ20nVvDbSn1iws+916f32Si?=
 =?us-ascii?Q?pn+F05tJL7Gq5hIQ727hDq6k5Hm705BRSnpw8M99ME/fXVHDXeDHzddIT11c?=
 =?us-ascii?Q?ne/6X6IYGqR+bTTu2py+TyxF7AsjL5n+Gr4RAYHYs8g4CK00+NLv8lvUeaEF?=
 =?us-ascii?Q?nVYSA39/V/W/j49ZkQx8yBJOyRJiM+X1gKiCORrXIUagbYB7GbH40rPXdEj1?=
 =?us-ascii?Q?P4+67vn9tg71lZ9bXNHQ81lc3HRDLkJU2STWXme73e9WkZvCVxQOjmCfrd7L?=
 =?us-ascii?Q?UtTylIVvVMv/o9oohISfHTAvSSZ6Fu0u5l3gy1JFrm6JPIVwVdyd65MhLHpw?=
 =?us-ascii?Q?tECw5IXoJouDNxPN5VOXF/frE3VsXzbIZ9DgRb3GwArIeh3//3pAlYW9s67T?=
 =?us-ascii?Q?51sCFCPtAXGGlVfUtGW+QtVitHu+qe9UQj4dqtUsKlFFNi6Bqfu7755z2JQx?=
 =?us-ascii?Q?XK8kq96t2/2V1vbAXi9yPQCvhRdf/X2SWc3dc6vI9JCR42hCHCFnWS59CobK?=
 =?us-ascii?Q?k9PqAmhNrBn9io6ThjO7v00ndU0InaJRZzE4tSHsY5+bLNpMIEhWT+Qk+E0t?=
 =?us-ascii?Q?JsNYn3ql9/yZdTYq9UULhZQAuORFbFAjD/KOynx9qPPmNLlN2JvPJSXg/uOb?=
 =?us-ascii?Q?jZk6KOA/5sB9HGYV3qKxx0q4hSWR/EGDEq3YxNWeExrH2+mhm09MVTTXSBqh?=
 =?us-ascii?Q?qgZGP9yRJtnio4mipxZfd0oE3YsVq1FP58UVv2lMYIruRRS96nKJwx9h4eF4?=
 =?us-ascii?Q?OjTy3zMj5SAJaCY6DrQMINHgYadMjV7Jk4JXfem+NpRFpyKom0H7VK2zwNnC?=
 =?us-ascii?Q?x1ytR3PX77Ax0xj/eFeG6OgXZhL7HRk/w8mdRzbP+FVC57i/JjnorrNpGE9u?=
 =?us-ascii?Q?je1N4GPPtxfWnc0ZuIUGxqq35JN528REyGsjJhfZoxrvihGeb+OZwelTwWwt?=
 =?us-ascii?Q?Uqwio9p8V8GU0vmYYjb+uyWcUvXPaJayAE1QLBUNkTGyJlXL/JkIxRPI9K7a?=
 =?us-ascii?Q?VD8WRH3OecyDQfEEocRrfy+Fbttz5gACVYtoeepXGFG+m++2eM3vhB4aJJzt?=
 =?us-ascii?Q?bcjNpV77D4gZ1ohJG2vaYf20rcrKrT0Zkvy8F7W5nLNrcJH8vxzu7x0nYxXS?=
 =?us-ascii?Q?6fVvaeBtS2lxRooc5jyJJb7WlMCboO+xHxyRVQ8e5B/t/LMElVN7CtAG3GFG?=
 =?us-ascii?Q?h5nwYBEBOznfn5WDlgOdxyM/zGtH7FGVz60+PO5SVZU5ZoYJe/a/WL5xygEA?=
 =?us-ascii?Q?2Xggyteh9RkjvT7ULNrTk7ikbOFEQtUw3SIayMiAQcgljI4E7fWnmeNaRAFz?=
 =?us-ascii?Q?/7ZiD10Im8zOH2m8H9sv4qjUfQQEjpHPXQUTNTk6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71450cbc-39ad-4401-b7e2-08dab284beb7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:20:43.2266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c65Z63B5mMo70A2yOK1GxNVp5DQzZmC7cp+yortH2pHLQwIaoT2qYDpBT8MZlkQ3n0Lh46UqEnKRTYansPhizg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6946
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload uses buffer registration for every NVME request to perform
direct data placement. This is achieved by creating a NIC HW mapping
between the CCID (command capsule ID) to the set of buffers that compose
the request. The registration is implemented via MKEY for which we do
fast/async mapping using KLM UMR WQE.

The buffer registration takes place when the ULP calls the ddp_setup op
which is done before they send their corresponding request to the other
side (e.g nvmf target). We don't wait for the completion of the
registration before returning back to the ulp. The reason being that
the HW mapping should be in place fast enough vs the RTT it would take
for the request to be responded. If this doesn't happen, some IO may not
be ddp-offloaded, but that doesn't stop the overall offloading session.

When the offloading HW gets out of sync with the protocol session, a
hardware/software handshake takes place to resync. The ddp_resync op is the
part of the handshake where the SW confirms to the HW that a indeed they
identified correctly a PDU header at a certain TCP sequence number. This
allows the HW to resume the offload.

The 1st part of the handshake is when the HW identifies such sequence
number in an arriving packet. A special mark is made on the completion
(cqe) and then the mlx5 driver invokes the ddp resync_request callback
advertised by the ULP in the ddp context - this is in downstream patch.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 146 +++++++++++++++++-
 1 file changed, 144 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 9c4bbbd00cab..156ca6219356 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -683,19 +683,156 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 	mlx5e_nvmeotcp_put_queue(queue);
 }
 
+static bool
+mlx5e_nvmeotcp_validate_small_sgl_suffix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int i, hole_size, hole_len, chunk_size = 0;
+
+	for (i = 1; i < sg_len; i++)
+		chunk_size += sg_dma_len(&sg[i]);
+
+	if (chunk_size >= mtu)
+		return true;
+
+	hole_size = mtu - chunk_size - 1;
+	hole_len = DIV_ROUND_UP(hole_size, PAGE_SIZE);
+
+	if (sg_len + hole_len > MAX_SKB_FRAGS)
+		return false;
+
+	return true;
+}
+
+static bool
+mlx5e_nvmeotcp_validate_big_sgl_suffix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int i, j, last_elem, window_idx, window_size = MAX_SKB_FRAGS - 1;
+	int chunk_size = 0;
+
+	last_elem = sg_len - window_size;
+	window_idx = window_size;
+
+	for (j = 1; j < window_size; j++)
+		chunk_size += sg_dma_len(&sg[j]);
+
+	for (i = 1; i <= last_elem; i++, window_idx++) {
+		chunk_size += sg_dma_len(&sg[window_idx]);
+		if (chunk_size < mtu - 1)
+			return false;
+
+		chunk_size -= sg_dma_len(&sg[i]);
+	}
+
+	return true;
+}
+
+/* This function makes sure that the middle/suffix of a PDU SGL meets the
+ * restriction of MAX_SKB_FRAGS. There are two cases here:
+ * 1. sg_len < MAX_SKB_FRAGS - the extreme case here is a packet that consists
+ * of one byte from the first SG element + the rest of the SGL and the remaining
+ * space of the packet will be scattered to the WQE and will be pointed by
+ * SKB frags.
+ * 2. sg_len => MAX_SKB_FRAGS - the extreme case here is a packet that consists
+ * of one byte from middle SG element + 15 continuous SG elements + one byte
+ * from a sequential SG element or the rest of the packet.
+ */
+static bool
+mlx5e_nvmeotcp_validate_sgl_suffix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int ret;
+
+	if (sg_len < MAX_SKB_FRAGS)
+		ret = mlx5e_nvmeotcp_validate_small_sgl_suffix(sg, sg_len, mtu);
+	else
+		ret = mlx5e_nvmeotcp_validate_big_sgl_suffix(sg, sg_len, mtu);
+
+	return ret;
+}
+
+static bool
+mlx5e_nvmeotcp_validate_sgl_prefix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int i, hole_size, hole_len, tmp_len, chunk_size = 0;
+
+	tmp_len = min_t(int, sg_len, MAX_SKB_FRAGS);
+
+	for (i = 0; i < tmp_len; i++)
+		chunk_size += sg_dma_len(&sg[i]);
+
+	if (chunk_size >= mtu)
+		return true;
+
+	hole_size = mtu - chunk_size;
+	hole_len = DIV_ROUND_UP(hole_size, PAGE_SIZE);
+
+	if (tmp_len + hole_len > MAX_SKB_FRAGS)
+		return false;
+
+	return true;
+}
+
+/* This function is responsible to ensure that a PDU could be offloaded.
+ * PDU is offloaded by building a non-linear SKB such that each SGL element is
+ * placed in frag, thus this function should ensure that all packets that
+ * represent part of the PDU won't exaggerate from MAX_SKB_FRAGS SGL.
+ * In addition NVMEoTCP offload has one PDU offload for packet restriction.
+ * Packet could start with a new PDU and then we should check that the prefix
+ * of the PDU meets the requirement or a packet can start in the middle of SG
+ * element and then we should check that the suffix of PDU meets the requirement.
+ */
+static bool
+mlx5e_nvmeotcp_validate_sgl(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int max_hole_frags;
+
+	max_hole_frags = DIV_ROUND_UP(mtu, PAGE_SIZE);
+	if (sg_len + max_hole_frags <= MAX_SKB_FRAGS)
+		return true;
+
+	if (!mlx5e_nvmeotcp_validate_sgl_prefix(sg, sg_len, mtu) ||
+	    !mlx5e_nvmeotcp_validate_sgl_suffix(sg, sg_len, mtu))
+		return false;
+
+	return true;
+}
+
 static int
 mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 			 struct sock *sk,
 			 struct ulp_ddp_io *ddp)
 {
+	struct scatterlist *sg = ddp->sg_table.sgl;
+	struct mlx5e_nvmeotcp_queue_entry *nvqt;
 	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5_core_dev *mdev;
+	int i, size = 0, count = 0;
 
 	queue = container_of(ulp_ddp_get_ctx(sk),
 			     struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+	mdev = queue->priv->mdev;
+	count = dma_map_sg(mdev->device, ddp->sg_table.sgl, ddp->nents,
+			   DMA_FROM_DEVICE);
+
+	if (count <= 0)
+		return -EINVAL;
 
-	/* Placeholder - map_sg and initializing the count */
+	if (WARN_ON(count > mlx5e_get_max_sgl(mdev)))
+		return -ENOSPC;
+
+	if (!mlx5e_nvmeotcp_validate_sgl(sg, count, READ_ONCE(netdev->mtu)))
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < count; i++)
+		size += sg_dma_len(&sg[i]);
+
+	nvqt = &queue->ccid_table[ddp->command_id];
+	nvqt->size = size;
+	nvqt->ddp = ddp;
+	nvqt->sgl = sg;
+	nvqt->ccid_gen++;
+	nvqt->sgl_length = count;
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, count);
 
-	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
 	return 0;
 }
 
@@ -719,6 +856,11 @@ static void
 mlx5e_nvmeotcp_ddp_resync(struct net_device *netdev,
 			  struct sock *sk, u32 seq)
 {
+	struct mlx5e_nvmeotcp_queue *queue =
+		container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+
+	queue->after_resync_cqe = 1;
+	mlx5e_nvmeotcp_rx_post_static_params_wqe(queue, seq);
 }
 
 static const struct ulp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
-- 
2.31.1

