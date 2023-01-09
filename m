Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79937662737
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbjAINfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbjAINdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:33:50 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5552833D77
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:33:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXuwcw5XXfyMJU/UzReDfVZlEeqKX1TxBiv0gYfToy/UWOS4fC+6xDIMqklehJDkj2xF1exHWD22sIZhcmEJzFmS6HzCe3/Wy7TFco7LFmO8xEmVdJuACKrxPhUrKMuLdUJSweIRpWz4WRmLm1x9ypo5G1ezdOriYlzMlgS+3mfO5rbZtFzj//AoERA0X3As5ugo1LgpUi3RNMcVDuHIDNVEvmdr3S60YAxFbYce0l3dUrSVgxAwq233g9+hSj1I3GJDRu3m8YFzqZMdX1gM2G8LcVah98RHMGq+WyVAzQyeKDt3S6Il+79dY486gtoVjUfGWiiGDs+SulnQ+qPl0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIASu0DmBZunrbhxcWiuiGq+kkZKW0FeFEeDLAwkyXQ=;
 b=BsZlaS/o+kn/SwBonq6UL/+moDdM0YNRk1Y0jP6Rrt3v/QNHFVR76kA6TvZWLhalQTPiUbZW08fPrZ8orkairGE9S0I7MR7wuIV9X+8WEHrKxbarja3Y2awdUVFYL/i5Yhn+S+O+kGPrare/k3WuvS3W3cVAajM8fRhWD1nYEb3SNTCOASER8QV+PgqP2QhgVecq5AvI5vzKHzFpH+w6FY0BFat+LqbB1HiLn5MvZBsf8QuXYG+DtqibzWNbVAYgfJW3mja1p7ZWtWIm8xf3wWRVgnIbuOk7Sn3+hL1qBjN8ouMI/B3kbP/A9WUx4CU1PcP+FKFNSA1Zwj7CMYha3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIASu0DmBZunrbhxcWiuiGq+kkZKW0FeFEeDLAwkyXQ=;
 b=Oqs+e83h8jeS1ZLb1E6wZvXKqQeorXA+CIsKYK2bzuc2OcG45VIgPaTEfNiNqggmtWvx79i3iTsYhqqzswMiRsOnYYeNVWsXJmM9XNXS2V6hFhMHfZP4bPKe8MfIhVB1VLfXi8ducG8wKeA1rfwOJ/Ft9yZkTySw8lPPSBWJr8J9jydcO0JKU3TrA5ZIuaWe+xG4kbiChSaRa/+dQgpz8vaOtO1GOlRBARtxoK351MSP6ZHhXOxuCCMl2ttKstf0krrlD9V6l9m1Y1St7+nrlbP82AXXbRMIpO4HCHznWGY7XYlH+1spqwzi7eUI5MmexMoTKeWGY/eK1Od6WPePGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MN2PR12MB4285.namprd12.prod.outlook.com (2603:10b6:208:1d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:33:46 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:33:46 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 22/25] net/mlx5e: NVMEoTCP, ddp setup and resync
Date:   Mon,  9 Jan 2023 15:31:13 +0200
Message-Id: <20230109133116.20801-23-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::17) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MN2PR12MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 19c0742c-c128-4a20-2507-08daf2462251
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WkZL4w2HSajyzSAMT8PF2n1TOx/QNIWwrpQMiqrahLDGrcFGORnaaXq3vP8MBuZFpvjzeTIIrkdbzj3F+vs3sDaQF/8W+A5yOEnZosq1W0qB5oFk+T0Bppmi3vnkQlcbMqc4bA6SvFZVjEsJw5YCcA3Ycj25frwx5onXqOAw7tx8l0VXpEhsyV8fMWATjTRBoocwooAzFjeUJI1rc81jbh4LgeFuWx5xHW5fVWIo8idRuPwEgYgxWkVXEIfbbtbP2aXAxSgnMFYfNedmMP3NC6hh8R0ZOkyUI1OWR865xptoqkMPLkzCvJm7qi0ZlqRdi1fVXZ10VbFg18Io5x9/2nx2WWnCYxPcJU3qp0fTv5eoF6T8ZVNl5mbLk79pkhScxpkRVjPdb1A8l9HfGKL2KtAW3B7VZUXkB8kAJH2cxxMmTa81FXyZLiR6soBOn+czXbadZVqMVIHjEzJ7byjCFwFTZeuo1o6i6qrdbj+w5Cupd/dxZf/dHuQPYYFGgbJ1jJXLwldZpLNkxR51wZB73A9B767mya6oQmKQgQ/dO6tspk+YYXoE9lZ2cChkoiqDVqeBmy5W6byW2RXxU9GkXd5snMW5Zl1igwoD3OwlWdKnBRE+9M5KDqhs0eJKQV9TPF/93bl/R0yRBvV4+Ov3kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(7416002)(66476007)(66556008)(4326008)(8676002)(316002)(66946007)(54906003)(186003)(26005)(6512007)(2616005)(1076003)(38100700002)(83380400001)(86362001)(36756003)(107886003)(478600001)(6486002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2vlXFl+IM3TrGmPuzIJY+VeF/FP3zHbjf/uB/qkf2f6ZfGPyi/8RccakyNk0?=
 =?us-ascii?Q?gT+FNZV+0DAQKlSfecbgkBJ62/w8A271UYxban9eY0nmbqqxrdsTuqsFUWwX?=
 =?us-ascii?Q?JpuDRVbZt8poPHAvrCw6weQBxnDvRoeKRI39tvEriCsKL/XzKpsZpBvyXhC2?=
 =?us-ascii?Q?tk2ZO6Zj0O+3iIIrpo1e8jRuUFhf4rGcIxIIiKUGOESdo8i5chco0MIxoBhW?=
 =?us-ascii?Q?7DclWVObgPkspXSA9deT+lS/4kWJjy90dpx5fdxId3+EYw1APjyVQNQzYd2X?=
 =?us-ascii?Q?fwiKRqyYkPVDGMToBIDpFCG/5yIoQdiklZi72sFhMfR8KG6wyHngMEDK6x05?=
 =?us-ascii?Q?FtYfb+Zzyj47+qg3LpPVjeJkuitnF9GGLc5VkUVQIB0/yBRgV/ScGuLkX2LX?=
 =?us-ascii?Q?v9U/TpZDixZoeUl6jmF74BCrmVAHbCcMAGLsQcsycy7DWRLTdrld6lrqYqG6?=
 =?us-ascii?Q?DbSGVZfdarCq9eIOGtUg9X8QVVD7d1gFT1ueAL4fmYuWi7HdTfdJVNjFLE3x?=
 =?us-ascii?Q?Eb2CDu0vGQ3A5fOIgToRMq8IqRzsA727SvW9nCXTHep9+/rJ7xdDYpaEbATB?=
 =?us-ascii?Q?9E6TPACpKIY9h+dK8B3u+pkNaFMgPg8AlFtI/J87/KsyC9Yo3nlcts8rcmPY?=
 =?us-ascii?Q?/vieyWzeOtmoE9mLSD67h4SH24XQ+dM/XbBUQSyNmga9eYJ32tLS9c1OQ63X?=
 =?us-ascii?Q?HIZEXTB2rw1d+LBVHHPaMxBGqRfgTbLFzB37ozDHZUd3SFtVMH03rDpNY9DY?=
 =?us-ascii?Q?hVn4nYtYaRgDHI4YpUK53b/gu1BccV4dGbB+QvQ4wdcWdwhr6Ryyvlx63fNx?=
 =?us-ascii?Q?PWvoe8jdqkPfOXx+/On/mN3c9YET+kvcnRYE2qu25LnmUAhiOq8ClUc96Ddn?=
 =?us-ascii?Q?lZV6UQGpP4vZA+Zpvg4Zv+03YmkIiE5efW6K41oQQKLo61MXVOkitviJdebV?=
 =?us-ascii?Q?cnQfDQ2iNUharANW0SkGMVY9pUqH3ZVC9ENkdx5ou52DJMaP/hCTbyney6nk?=
 =?us-ascii?Q?Me5d9BMF3fVkBnn2aNzI7ZuzrOG8stRZJCfr3Q55dVyVfwwIn+M1f6MQZJo4?=
 =?us-ascii?Q?4FyOCDUi0mWJcjZlAlkv7M+EszPaiwHCt7tEowvrRpO8XM2Nx1GGiuXID67X?=
 =?us-ascii?Q?dVNe6xO3laI6JlJ+ZqKZeJ2feVywCMXEwErGZuuo9vE2ZZalX0IKiqnPe93B?=
 =?us-ascii?Q?cTPHfn4dvq5+aSkLf9CDDsFSVXlXSibfAjE+V+1i9Y5NoP2Mo6IOWedNeTiY?=
 =?us-ascii?Q?brHQbySMX4b9aVwNpIZKqTTOz1GjxYd6UrZ78yAwJYtK1vchk0zI5jHT9Nui?=
 =?us-ascii?Q?MEF9RLNJYxlaNrq09lITKjgSllhAEFXePZfNNCJ/R3jq4As97UXm4vYvQL4y?=
 =?us-ascii?Q?sk0mY3MwMb+nKXjwNAtPkoRsxy0ZdobCkT9eVye1Z4Uv/cJfJCLiidsechiT?=
 =?us-ascii?Q?zeZPC2z3YNiJ3i5ep1CE0uZXaLuFIwkBlM1jnst3aZRO7eyHUDTNCwQGB1K9?=
 =?us-ascii?Q?91W1+VFFKicukwOYLdXS2pKpvusto/8ysAm0ucWCTYgZxrwwl/VQIuXisji9?=
 =?us-ascii?Q?X4PyQhvhOf71nkdhVNs0H/bUHu4NYHTPql0cmi6S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c0742c-c128-4a20-2507-08daf2462251
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:33:46.4347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhwD07HTK38szA3Uv4oIGaNJdMponRoFtz4iqaSALGhQjTOqurfz7jcAMj8aSxu7KfDEXz2L///EJSMrapl0yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4285
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
index 0e0a261ec4e8..3f1c0e7682c3 100644
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
 
 const struct ulp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
-- 
2.31.1

