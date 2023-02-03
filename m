Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D0F6899BF
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbjBCNbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbjBCNbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:31:09 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124DB712D9
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:30:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSxhkoM353ZwIf3z0uxNi07TXMIiDoYavO1dsx9wgtNwIp/pXkMfblqf6/cO6/O6wg3/KA1hG5R13yKB3Exd40Z6/giPk/0fmvPp/JvlkjrGj8z1WEmK1DwyxyaR2yVyMcF1P0f+VDKM+4Ortv6s1jH4dXZ8NgKx/QsZ7O+qZYP5B0uHD+7XsqmoKH3rYzWt5iTzoFXV3oWT1mmSxIO+Rd2KxVT2DVkAeA+AjwNbYOTwyZfMWOGtOnSNljlDmJKV+hrKxgNHzaP6eZ1BfHDL88R9vGXHxPRpBMXbLH2TdljYF9TkToK0a9goWbBrXXoZ+b+ndlD4bfNKsfU/uAVCAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sgXDq5fVOrRTevlXaKXK2aN1JJJUv+K1awlIOA72yk=;
 b=UgWyp/Y6qh2dngOXr6l3PFE4E5SsDX7YxtY3rVEldGs3F3DRw3LzhEjVXzfj18Wm3wiUJdJFHzwxj5BiRhvQMjy/GXYHJZQG7nTrWJisia4XQa6bDzBnGpSukURGpgl/cog/wohT/uDS7FciH2kF6y1/0xGrAaCdi6XX1G8q1gbutO13u1J9pman1+vrk2okBFhc7sPG+B+OR5nJMo06eIHBUwxmOBFgwtms26azVcNVHwjHL2SR0IJjl8Fy+G/aLryJEFtGPJA3CHB2EOwjH7LmUSSb9dEuN+Inz+GvdOBhhfBibNie3O/E6HtibHWAHwtDQl2uVyPDiBAuwbIwww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sgXDq5fVOrRTevlXaKXK2aN1JJJUv+K1awlIOA72yk=;
 b=Py1BDAGC1Wyg+vK2fgvQd0z5Gzcmx9Z2ae0GlM8BaoRvr3Q2u6GV3Btl94gmeyuwf0KqEvECVreWugyuAgxRMVseu7d15BUUJyDnel+yD0lzX1FN3/piLxyJrG8Xy6ckcD/dLDomWaQzyEUOUBhUeg3MBcUFlrcGbdTkXiHzOL4higb7yzO+N3aj02t1wVw5Mmefan3BLm5cuDuBbbxfQl8UsniYZvbNm7v21uvpeQOPPP7orYgzIKAUUHdiFtnnOK0cQRtVS/VqYaIpEAnpXLBDROuYeYh0Gld2LfaRCxX+vdUzvMZfZwzBM87/3qmP8RMQVXq5+IIodDiDLecRGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 13:29:46 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:29:45 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 22/25] net/mlx5e: NVMEoTCP, ddp setup and resync
Date:   Fri,  3 Feb 2023 15:27:02 +0200
Message-Id: <20230203132705.627232-23-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0023.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::35) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: f7e9244c-27af-4e00-79e5-08db05eab72f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NtbigJfjYiy6xb6JAWauNmLnpQpWwAjqCXlB+VvlphhJdW9OB9n3e+7u+6ZFBpIIfKj7O8j69bhoYJ33BcNz2fFCdslwael1pVrllVDatXRUhBVUpkwAiA0AgqXfSEsQTdEZrCJ9QJXvuznFw/VJsYWhOoNEWf2w769vRW/WQ9RpP0LuaE91wUEPtdgAaNZ5nuyKakb7PtRbu2xEbaHalCsetQLlPoBZjKzsqm94TnTRT+Zwc6mOgNtjMn1GRYe4s/6YpgSixYp9MW60olchWBgStcz5spKk/jMX1CL8ZHyhUl6e3rbSf+Mtl+4BOjVRD0RMxOmgw/gmsu1qaRmPGBICUeU1PsyKRUK/AAX1H3p59sJjlCRcGVfsuAKJFF/YzSmu8OW6Yho11x0m/3qAVSeaGuIjUzq8G44d1I12jbrtYacd/qzWuvYKqYlBIDPrprYIf6pybz+0Pe6b8+MXySGWZjqPPEYA4WRq3c7fAiV+qxuCNFq1CBPamh7KRqN6czWeC9/T69IcqNqOhLL+RdyvJPx0JnUp1TGizMjZh3t+T5sRENV4ffXfZxatJkHiszaxc44y/9v/esDfvnFRneFWXTuJWloBdHOxvcZfonId/r0xYDBO2N6lkdPe8H3Y5UYF9T78lDtkWEEebVgh9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(2906002)(36756003)(83380400001)(2616005)(316002)(6666004)(107886003)(6486002)(186003)(478600001)(8936002)(8676002)(66556008)(66946007)(6506007)(66476007)(6512007)(26005)(5660300002)(41300700001)(7416002)(1076003)(86362001)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bYMuJTyeJ8DeUc4Z41gPLxRF2B+7+EFmmYw0fvfLFned10uS9D3RauUZmj+7?=
 =?us-ascii?Q?RDbHJCMa7MZwfOgbIDv0F4WyQCn1WSFxWSeappON1VjWTrm6dfDP0RvK/LIL?=
 =?us-ascii?Q?cu5CFF7EJsWyLP9Ql7Ziv86WhMFmLPicQCh5tOgtA6TPWGX8KGd2/Ml2pzes?=
 =?us-ascii?Q?txFGP3TJtv9RZo4aECatunZzsmorUUenFC+s0/0rJyhwwqqD4+5VxfTFwvKb?=
 =?us-ascii?Q?69aX8qkSKp8C/zuKpo2KWllfqBAvQsjlMBWH3JZvOhFcI0lqvoRPBLXMYV0P?=
 =?us-ascii?Q?Q+77nf5z/liOtr/ibPh8lCa4EtStvMa9CJXp9jgZnCHCInb50bojDQfgvZAt?=
 =?us-ascii?Q?EByqP2DAbn2LYDHTosORcATu369zbVC5MeAJaOvAz63RBYZHj0mxWkZDVOvx?=
 =?us-ascii?Q?4IvmVwGPOzIO6xpazDzZ8ZDArY9y4vXzLWjm6R+v2AaJSR2fJtP1LDtrMPq4?=
 =?us-ascii?Q?Z5J6xkS/0hSDqyvF3LWLa/psZSinFOb0i4NjcFBoLJDmbXOAmpIF991BF1Ab?=
 =?us-ascii?Q?FcQY84LA7ZXlMT3pWyyExI7APMQEnZBVELeC99K0qlgBLdaWiCPw+1vd8JqJ?=
 =?us-ascii?Q?AO65gVzJ92ArXCFell2ErRlOXuoubY7XKrmwCiAC+/XGpkcIf2brL3AmYC4W?=
 =?us-ascii?Q?JEMXmYDxEABhVIOuwZZxgZ7fcD+lSdIjWpskQ+O0YNk7MS7tGuQ23gLqWX0Z?=
 =?us-ascii?Q?lRcQ7PfjZ9Idr+qHJOkyLkkHMC6WAULDBvfUKiKynLatN3RKNy0Tmgcr1MHl?=
 =?us-ascii?Q?JDBWXvZicP1/QfXEp0FPpgvVZbxxJi7eA0fKricXtD1lO7bdidm6Z5oy+JY0?=
 =?us-ascii?Q?eALFFPRcx/YiodqWTVR65U6UrOu6zIgpDgSmyCALDxMtiGuEPwv5XszSGhgu?=
 =?us-ascii?Q?JlN5H1m+uPkWsRPQq1YaLnekfvQBk+CeC0XhU4YkozDeohfFUbsHjl2NuMTn?=
 =?us-ascii?Q?nwK6NKmZ5eD60zBe+gwc4o1dlacVla6tYlNYCyy44xFlW57se/hB2Ld2aADH?=
 =?us-ascii?Q?YFgXGCcbMRfUWJegBdCAZuYahGOmmmVH8jp1u4j4Jfuyqm9CjtEUZfUBoFuN?=
 =?us-ascii?Q?wW7+0/8S/OlGmbL2KF17Yo+E53hD4ATdUEiA5mNQFlkjqsEdD3kEReddq0ju?=
 =?us-ascii?Q?zkLqPMowV8MmjpVC2sieejS35LMrRm24NwIHBOD34bFD7m7kpPJEzs2EDngY?=
 =?us-ascii?Q?xce75VLhcPBWJY/X4zrXCKubcXXl54OzXXYIZZGZmlz2GtOQzFmMjUs7pTjg?=
 =?us-ascii?Q?j/lDPsJfGFTOCSjdHxmaVRCZlinFHGP9M3Prv/vgeg70tPuJCHaqsEHJCym/?=
 =?us-ascii?Q?VPqVztNPx78TN9Txfmo3BmI1+mUKTQWX6k7OoSYruBz0FIchDFUMT1TjkYNB?=
 =?us-ascii?Q?PwmK58Fhz06u0vnAv7sZa4oTTonPSjSMQbrGGS3GhSXpWRkLKc4hDi/U83hG?=
 =?us-ascii?Q?wW8Po5RHIN8tjXqfDfMhbJl02LgL2IjyPaxxfq6sNF0AfMf4byHNpYhfjk8F?=
 =?us-ascii?Q?/95dK2xjy9bQp32TvBEufJp32mN1IE8aw7ALh72DSHwPaDOiSyiAYg+kwtQJ?=
 =?us-ascii?Q?9VzgXdT4finwqOIlhXl0wtkr+NU8KgzqFdHTQAZx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e9244c-27af-4e00-79e5-08db05eab72f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:29:45.8134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ziA9O5PSo48ZC5Ktb/mYF5EssWbPchHbrPOLyaXKrFnEIoDYRwfeKm2NIj1b4FkNVPbVMVH/wigU2H6u4QyUpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 64e4b3d2936a..2b9d69254ead 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -682,19 +682,156 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
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
 
@@ -717,6 +854,11 @@ static void
 mlx5e_nvmeotcp_ddp_resync(struct net_device *netdev,
 			  struct sock *sk, u32 seq)
 {
+	struct mlx5e_nvmeotcp_queue *queue =
+		container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+
+	queue->after_resync_cqe = 1;
+	mlx5e_nvmeotcp_rx_post_static_params_wqe(queue, seq);
 }
 
 struct mlx5e_nvmeotcp_queue *
-- 
2.31.1

