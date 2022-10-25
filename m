Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5397760CE5B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiJYOGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiJYOF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:05:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF8323156
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7XKbAxbAWRejTuBd0qteSv5dQLHi45LzV/CvQYt56PPqkgaajarFUltseSkisYZZF0ZEsBOZa6BGlPiFL+I5qHanJMcgWHt/SNGOlb2g3nJquRhHClvJ9iQ/30XMR+0v3S3W2dFHVGDVJJfKd90tzjuuwB6GoO8s+UMxjj4cT4e62EFErAbqViSl066MY/+Vs47IrDf+h/dV6+pHPtvZar/k9sU1eRtHLA1yi8NaLScLMlIdOm2aW4tyhprsI3WVBP0ralpwUpauLX25gGHOjdHG1Vq+iHOlGdgGSY0dfJHoP7kUKrolWy1uAjfXhO3zZZfwIxWKUnHHf0Y1OOJGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9aKLqD+875N+B8RxBZD9DaogKVah+xUMwbb3flTPkQ=;
 b=FgDwu/Q476uWevl+KZ/qlAv3UpXBu4re4m985JzAsMXDufx5U8qoBBii/BQ16Dq8CPVI6rmPVereNN/uYWfJwaNj61rvZhXEiVMSKcReAlAVJdgr8bf5hxCfHt6HYfJnUiGh8PMVllYW6+2LHJq7j1dKuhfYrrDCI0ZmOysBzRLXBGwliDb8c+LEn/ExoTZbFlFsHX7a2kmLtunFaNJrzvQV68D1JARSwzg06uohnL7raq8s1zQIdSPnS4JFAjnXF+C3w/OVxpHu4qe2MGF+vnC9FNZDjXnqaf3bSi5zZx5UMnzd2qNKRqWoKiJUzUa7oXa80R1Vjpd5uS0/Bs4fcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9aKLqD+875N+B8RxBZD9DaogKVah+xUMwbb3flTPkQ=;
 b=YGxE3vo/po3D0Rh7wZ6hPAmmGZ+dPZVQ5VZ1LaiMsxT9nj/3JZNMV2OWODYlhJ98FcOd8Bipre+bti2vJ46trUm3wR7HJi/NXkN+g/8cWDFy+tymmXRND9SpEjPgi29ldJZD9huj15mPSJpMFgiN7dv+em0v2WbB450DFZjBeZU0nQOJn8gVxPNndLO6QXo0wrKNm3WPBv1yFmqXebhc3GzgDJGqfhK3N1f25wdLpVAHI7J+GNtDAmnloOlgWe1Xmj71MQILPYJiyIRUn98xBOCXBuGo0gKSChL6MD1d/QKCqxvx4k5QZSFoBx+qnbh78CQ4ruT5j6+zQO3oG/qP1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MW3PR12MB4588.namprd12.prod.outlook.com (2603:10b6:303:2e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 14:02:05 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:02:05 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 20/23] net/mlx5e: NVMEoTCP, ddp setup and resync
Date:   Tue, 25 Oct 2022 16:59:55 +0300
Message-Id: <20221025135958.6242-21-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR01CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::30) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MW3PR12MB4588:EE_
X-MS-Office365-Filtering-Correlation-Id: dac6972c-707e-4a71-7431-08dab6917f86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S68tam/KfRda9nSlVat37Lp5qUMfI+0nSeZgH6N/8zFpVhasWgQqbsPWY2sdXYPHbtvFomvJKAFrNWNI5VfSzlqxu+bztIo/uNtNIJiSlU/I0eIMOtGJofuCdsHbTD6oH/I8qnfQcXiR7IREMPUcaqDXC8FXRHHcwT/K3vhS0QcbENXH1zpywuG16oQblh6SrElUq4xAQN1SyxSge07WeeKJOpt707NX8LVEuIq+LNjvPhSh3kAsKlqH97oDlC77fybFnp/lerBP/9DetGiGKTRTD7N4YaHV7VGzZTUSWHTYFfSr1x5nLwOLmtsqMd2Z67D5Mojd+HTBvxBNpI/VOZe6BO/nNaETYG5r+ywtw6tGZIPWA9Zz0uUP5lWGGGosbf1+nbifBd0lrNZ+TV+R9Bud8eeVWkafVXpzw8eVbuNijj53cFKg8M2ck6UYOZoKpMJ+O9hm5w8ajH8LqNaP6fEBDo88w8GSmKxaqhC6nlQzII1lmsQlzhIw8vHX4+LLoPyT7dZn1Zt7BtJ6U5DBBG6AlOQgnRoDjLc90lgqqpfgEnhanu/vsguiAdh+w/aRLt2cYimc5FtO+2p414xuphT00PIBmXCD7S+r6Y9sV+mLCbLdim/nyiPeUuWR/JKelkEuPZVTyz9F09CNZZzwyyk/HrjZBHEomOFw6WOe87w3/+xuVDoSQ0eN7LMzDraocRtnJhTskhrZ54XBuzvtm7LTtXId7jF9d2NDrjME2mo+IZKQgNO8R3Y5lEanDJzO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199015)(8936002)(83380400001)(38100700002)(6486002)(86362001)(4326008)(41300700001)(6506007)(6512007)(66556008)(5660300002)(6636002)(316002)(478600001)(8676002)(26005)(66946007)(1076003)(921005)(186003)(66476007)(7416002)(2616005)(6666004)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c7ofmezS22xTga+ZTIN2bIP5rZKECbzDBDs7Gozx0jXo7Zan4/QmQPzoNeOC?=
 =?us-ascii?Q?P9QpQ3dEeeunjvRt/nBSk37XwFh0yUVsnn3n7ewwIo/ezxmNTkRz8BSHYjhP?=
 =?us-ascii?Q?hg4Vj+eyY8e6ucAfJ89WfeTG7vuDKNb3smgu0K+dCwJNudPXd6dlshABMd0o?=
 =?us-ascii?Q?CvQpTwGMS7LskFPAz/ArBtSEwYKKhn5ue+bTDAl9eBoRcyN3B+rRsPF00IIh?=
 =?us-ascii?Q?uHacUO6AcTsHqZyq5nlJeBDYwqliPAILO9ZxpjWGH8knE1wkkEQCcz8eqeMy?=
 =?us-ascii?Q?j0WSm13Tmc+kvxtJ+SG/hDdcW3o3iavsRG+0PYxxtNsBW7HGIEl0TmCKSxVm?=
 =?us-ascii?Q?9/vaS0vt2bDMrO/dPTMML2sHZhBLccPMjzx31LqnGheJHHNQFUEa8I3FngEZ?=
 =?us-ascii?Q?YE7m4kXsIWU+8uyGrwY4Db5nhxUGpKMOnRh51KIohRjf+pWBSQT0HqYnpfQk?=
 =?us-ascii?Q?NBLwWMRc6bdCMMNa2P3edIStpfG4Jpv/4FBF1i0ptwk09/e10qV3O0KyekTs?=
 =?us-ascii?Q?0Htpe1H1t6Ppb+indS013PoQ7eoucLx+L3T7hw3VHyIR1C18zbA6vHADBBGM?=
 =?us-ascii?Q?Kn9bXBCJaVI6tmZovDjNcVckd9DgU25TBz5jpJNEB3I9XacL6LtZIb/yJbyj?=
 =?us-ascii?Q?fyCH6C+beNCT7ZXR5ITizd9Xva+DSOe3J7zBxe01HsGrRsA4EFHq1QjWXreH?=
 =?us-ascii?Q?5EnZ8t3IcqEnOaK2Ry/gyefvrDnZydbYA0pYS9HdZsJmR5cbn/uc5fnTFzgP?=
 =?us-ascii?Q?YkSnyO58bbgHvqckmBCDfV11mmFHRVWtR9YqZvqDJqrFtoNAm+LGP1xQj8+4?=
 =?us-ascii?Q?8AJrB7WJBueQlAtAa9gIg29Ec8bI3opA/3ZOEjg9rrLZ1nVFs07H7IPjzaWX?=
 =?us-ascii?Q?cuccfKR7zmugjZzPCxT2q6UKbFS/D4HqObN5TDjvfhl74cS6GN4+h8UQJEIN?=
 =?us-ascii?Q?M4s/sRcL43KtrMvzPB5Tj7k0J1c5qOnz0Br7TitCWADmv42wBUsgKmBl0XRH?=
 =?us-ascii?Q?mimGQnC0SBB8vkq/FOOg58ArIr1P6MvmMGSi2YILAUVHW9YSi+owDD9AhmX8?=
 =?us-ascii?Q?dapvsPnjCTF14BXIhTdqN9s66xTtU0wu1Bthy9GjcEEfd4/Vs+ZGfz79ZVZx?=
 =?us-ascii?Q?lKrDbUf71mRawaxxQ38pGotBscwXd1GXmIJmPHH8H2ILWmMuMBaLbwEuLchp?=
 =?us-ascii?Q?F9ou10SsLWyy0E2IZrzM8r9jJWTxWn+xrO/O2OcDRISwgLJ+9j2PBlflF6hd?=
 =?us-ascii?Q?D6oPH9xcHIpNowxetXf4hkz9jsuYkIut3msu3mpKT4XO5xnvXd/Igp2rzsLK?=
 =?us-ascii?Q?7oxrxI4lOcpzXbddATnlv0BN5D0YFeIF65h8cy/TNsHlOrtsmiJ0J4bfSknA?=
 =?us-ascii?Q?6FeCow/wwHbF3WcJ1+LR0gknrQm7Qf8Za7J+XSCzW6wZh4YBuzZqCUmxFwV8?=
 =?us-ascii?Q?7p5HU4MNmrhMrjNAlLDXdM1WVtSlZn74bFxq7L0wHQJFo0YoAynrreoMzofS?=
 =?us-ascii?Q?0NNUcwaUqko0uNtN8QpHQyOetUI+bt8nifGir9J8KwoFAHWZYl8RuExq2YaD?=
 =?us-ascii?Q?asDYJ9QR/F1sv18xDezcilkH22HmL4hUo1gM3VYU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac6972c-707e-4a71-7431-08dab6917f86
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:02:05.3471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xwCBU5eVM6fozPsCaZ49CIu6I/L6cplqgrvyH6bC/BzC9m0ZqggHl/OsAeAcSsf+l/AeVdPJBknimz2GrgsvJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4588
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 4df761beebe6..79d0c7e9dc64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -685,19 +685,156 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
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
 
@@ -721,6 +858,11 @@ static void
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

