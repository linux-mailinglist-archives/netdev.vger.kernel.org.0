Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF31524808
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351540AbiELIka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbiELIk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:40:27 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A131053CC
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 01:40:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNn0c+3takDrqq2kbEBWflm3V0kT2inEeNuAMWHn/XMY0DFXRy/x6PfbrnOLKFz+Lq2C1fl/JRcjrKsBEMI2Q74W9BhUdbd/3eH72KWP351iF+HMWj6yV76X8+xNynSI+0ViS6Cwkmtou7c2KRrbYY5RK+uQN7htA/6c0c3unmONcsxzzJSTh8NcgYG392vUbgVNO6vqeIAWqIuVUzaYF/oJvm/aS0jbbut3952UWdPEL9BGW2TbxdFMuNZdGK+9ND+jIDAzA8+qeBeSE2FmMzmcZzdAdsD7MnqKJUWZ2VWEc/wek1EipaZPemHr0qhUEdc2lGloj0eE7eATjPH1/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6y3pWFsog8XAEhmjpupfiPjVamaeJer0dsHBJrs2yHs=;
 b=IrgcvLBKS1HAjqAI1T7q1Wrc1L5llXEupLKDFAMf4klqKyhSR8SgRYQAUYOl3jSlTyG0sWE9ZHpfB7nc5rl+DuWtCvnep2CvzOljoU6KNOWvvTIufQVNX+0I7abwo7rnTZm5AJD3MzaMBGcRNOawypvg5nQeWO8pfQCny+OnQ2Ux56z1qJTnERPhpkjbez6XLNIuA6aS1ubSGx2mxPAW15Y4okgZAdbAO1Vy5+XhTVHybJ5u3ZpVeO2+55vAWDjkxCjNdTliMw5FAaxn8y7wTRLh1SHcc6dEQM8/c40y61lFM0o3c2OLjkbN4gbyWie1HTZjv7Vmx1nVmeQ6FAT4dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6y3pWFsog8XAEhmjpupfiPjVamaeJer0dsHBJrs2yHs=;
 b=GwS5yhyR66xM8PP/9X9nvEwToF8KTrzj7jteEJSWgaLXTb0CrQh+IFnT/0Y8LmBlw5SggAcBBellzj/8lZ2fseFC3RCC7J7Pf6LL6mGMKrzMjDT3ohQuuFrmZPSlAb5KLkkqpeblK9cK+RSHVbGayxTxShxnRJ2aZNQEPm10B8yu8IG1YPVXhMMIdfyLumU5unv5CEYvRtHNgiCiRfaW8E87iBVuAkPZ6jjc/yF2laHAmtT+MY6dfkPEJbH7+dcqgepeB9B7TsToSBoGAUMUBQj7EwefV2BcvobLvj6i11fcbpFmm4i848PSatzh8TCB4daOLDcBEdWkX17MZakKNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by SA1PR12MB5613.namprd12.prod.outlook.com (2603:10b6:806:23d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Thu, 12 May
 2022 08:40:25 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 08:40:24 +0000
Date:   Thu, 12 May 2022 01:40:23 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v6 net-next 13/13] mlx5: support BIG TCP packets
Message-ID: <20220512084023.tgjcecnu6vfuh7ry@LT-SAEEDM-5760.attlocal.net>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
 <20220510033219.2639364-14-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220510033219.2639364-14-eric.dumazet@gmail.com>
X-ClientProxiedBy: BY5PR17CA0052.namprd17.prod.outlook.com
 (2603:10b6:a03:167::29) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1688b859-799a-4d76-1aa7-08da33f30e7a
X-MS-TrafficTypeDiagnostic: SA1PR12MB5613:EE_
X-Microsoft-Antispam-PRVS: <SA1PR12MB561398308DA01EA059A1960AB3CB9@SA1PR12MB5613.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGpf3p593QvP06eV127aiJQCSHCCKutOrpoqi+0nGSXCfV1msFo+O7Ql0FHldvo4T/0ouukcY3YUpcn2WuIZbg3QNfxt9X/IRREiUnwrMB+YDloi/CkkIbWngId/EaQwsBj3gatepF7m/tjCIheKIaX0W54vl3i5tmVBzRUbXw/aPlsWtiLdSwNSE0SYLznQ7oqh+tHBxwICpJ+JFcn3N1J/BIzCyRGZbMThvVkBRLXcMxmcm3RBRSwPK7/P6P196fAHifSbk32aPkU6AW/ZurEKfZxcoDsLUCEF0cWkSVBX2XP5kgtDBufsOYNeOBVFeo3uOdR+zu54rwIdXYpgqkrSFhkYNsTmbs3NNTMLRGmu6ZlWET1wX4xQrPTMDwcW9QEng86AvECyW2qbjIz4dBLKGMy2t9UDBH4cvGb0bX5zIsFhfeqjMdUyx3VFy4FhWI87qvT5dwZ4kzFvCT0lAKcfc1xYwRo6hf6sV2vtnwcdirwnVLCwmCTe+ecAcdWrBbndEPoQxVE/lq8RTbwBNApsYFrbv1ilSLMMYvNbhzRaxwM1aWOaCfmGy0UvF+6Z89WTbRAUxlByS7vJr/3qt3FYbyPPIHgoqjSrOveRFnsQMp8/0Hkc+UFTvRCR4LOh+XeHD3/nFN90fsjVUihMAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(86362001)(5660300002)(6486002)(6916009)(508600001)(316002)(54906003)(2906002)(8936002)(38100700002)(186003)(6512007)(4326008)(1076003)(66556008)(8676002)(66946007)(83380400001)(66476007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lLgJ9GRcqZ9AhqWpyRkKGLuGX7ZLgWoYbAnaVv5kKPHuT3l5wQynHmZdBmWB?=
 =?us-ascii?Q?pekgz6bzn/xdV0AuBbGwy7FoFgLEe3IWuCXES4YOYBeKiwujN59SMBufZcy0?=
 =?us-ascii?Q?ySVNuqpiocOuXJLpuQIE6st5LiRKqgfLSRdCeQocMUK5wEDxk0A5bgq8TH1D?=
 =?us-ascii?Q?9ZAJOPak9jtub0Oa9J/LhEIUXLjN7KZOSU24ezZmhK1T0JEO/HFrMRlDeoXz?=
 =?us-ascii?Q?KIDxyyQWqODitwXgvDOSeB+fqv+2CW47ilrOX6oL4FrGfJwrpUbbgm2J6gT4?=
 =?us-ascii?Q?oNZr+J0/ixRwaT48+L1v0kD260lDy515rf8bMm3NtdVO1N/dSjT0D/kKx4CI?=
 =?us-ascii?Q?ILgCsOyllxMHfBPODkBeXJTdzlzxSPhJ+VbSQTcRygbfsHyqmj1NBWtoREG5?=
 =?us-ascii?Q?Nopd8XIAwgfuWe5IaB74BxZuEpgtEmj2O2TU3UTNwchRZZ8ylWpkHcPVoU0c?=
 =?us-ascii?Q?8TNzDwCJbTUzFqRvlNTyJOkIvomJVKmQpNSDqpu4Y+59fU0HDo2njFvInYxh?=
 =?us-ascii?Q?wveu2KMBhhe8SfjtlQYMnnNVgLeU3Ha2YE4ekpWtJW6G5lYnWerOXx2Bw22S?=
 =?us-ascii?Q?Nl+eOD1UPSKl2b6J0+20dSsz3ZTI/STynmklkwd/d5oErAeo0qzCxdXOfif0?=
 =?us-ascii?Q?a0RavKYyHc6RqJEvH90ToqH4w3VVQfhOX3KJXLhwEP2TCi2kz8a3zYkdgshb?=
 =?us-ascii?Q?CB/DY9ocY2nrPeWwxdFzw1GFP54ziN3szNF/ZVg3ClXvfImGR0MgyWQe3XqE?=
 =?us-ascii?Q?6B1Q2GHte/ZSULENtMDJg9DptASXTTzQKmNlwYYkjb2ZiT+id56+uBMEt262?=
 =?us-ascii?Q?CX5NbJgdEeSvfyOpkHA0sqizLHirWuytlYQFWuAIzy0yQIObghDV4P0p+9QW?=
 =?us-ascii?Q?xOTosWyZWd6IA4775G5bErJFVXIM7bqCVu2h05PnoAm1DmZsYIXRSgsHJrXI?=
 =?us-ascii?Q?vQvlk9rOQfXwxzzksG5eM4/Nrxg2yKEz3Bu4U/LZs6HzguupoXGHMb20qT/p?=
 =?us-ascii?Q?s4ripsbTXmh1xNfAs+fjt1Gw0grwLihXSNd1wF/EM56KNuuDP5MWcupbhej6?=
 =?us-ascii?Q?3Dluk91EW7pPGnOJD9nM1Tkc+nPfRc6Fj4fR+5D0zZ0MVH6uDk8ib+IMu6Ka?=
 =?us-ascii?Q?bVDXWqVQk46nLVHYhwR/N7JpUuE7ARUt7F44ZW8/35hoND6o1fl4bmS9G2v9?=
 =?us-ascii?Q?n8rpsSJb42B1dYzSHSAE6LiGHDpJ1MNiSnw51QkDm1UFmEDzFfxmeKvk+Bmi?=
 =?us-ascii?Q?ybmnax8SeX5c+S022OhU2rTIzUHbT7uLxE9cAIkk2+kw35YACjxt8TtvlvLV?=
 =?us-ascii?Q?en/zJ1SBVym0iuKMqEfCqeomRxwtyHaHYKaL+4GFUvVZHSjY8+BEQFYMwkE9?=
 =?us-ascii?Q?Ia6/F9M5ITdwSQ6dwUlyP3g7Nj1VZTe/pc8BU/eZ7oLHLDDmrm5Gfq9rue83?=
 =?us-ascii?Q?Ng5EbwnPhOBZFF32Yo7iCG7iqo4J6M7wXfmu5Jyh6/kzk22HgouzZfan4WSq?=
 =?us-ascii?Q?8BkGRk02NFxiZtMgExip7djagQ3AL9hA+NQn7wxF9NCuTmDi2i1Ko0hhI7JK?=
 =?us-ascii?Q?Rsi+GImaZWHAIOjyKxxEqAQ+4vx+x7beaQGNkykMeQ6D9apuLnWevVrepblw?=
 =?us-ascii?Q?nMfwPiarYAq4SGj/ZHYmHS5URXiIIhN6n/+dIN6ao1p0rtugG1OsSFyj/pRg?=
 =?us-ascii?Q?Iv+hQ4s74fMXpGRG38Qc6SZHMYiAqFIHIvHsKisex12C7Q19t4+OjJeyAMuF?=
 =?us-ascii?Q?0l921fajKzaTXDosYApOhv4wyYBekec=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1688b859-799a-4d76-1aa7-08da33f30e7a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 08:40:24.0861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWRNa051jBRWEvdTXCHsPn2kyg3kvJNPK8NoXSlxSalcpuYKe2WXEhISRkidJ8fwZaAF04GoYFoLrE3XczMWSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5613
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 May 20:32, Eric Dumazet wrote:
>From: Coco Li <lixiaoyan@google.com>
>
>mlx5 supports LSOv2.
>
>IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
>with JUMBO TLV for big packets.
>
>We need to ignore/skip this HBH header when populating TX descriptor.
>

Sorry i didn't go through all the documentations or previous discussions,
please bare with me, so why not clear HBH just before calling the
driver xmit ndo ? 

Or if HBH has to stick, why not provide some helpers to the driver, to make
it less intrusive to the driver. 

mlx5_xmit_skb() {
    skb_remove_hbh(skb);
    populate tx descriptor as usual;
    skb_restore_hbh(skb); //must be before doorbell
    ring doorbell
}

>Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
>layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.
>
>v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
>v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y
>
>Signed-off-by: Coco Li <lixiaoyan@google.com>
>Signed-off-by: Eric Dumazet <edumazet@google.com>
>Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>Cc: Saeed Mahameed <saeedm@nvidia.com>
>Cc: Leon Romanovsky <leon@kernel.org>
>---
> .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
> .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 84 +++++++++++++++----
> 2 files changed, 69 insertions(+), 16 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>index d27986869b8ba070d1a4f8bcdc7e14ab54ae984e..bf3bca79e160124abd128ac1e9910cb2f39a39ff 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>@@ -4920,6 +4920,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>
> 	netdev->priv_flags       |= IFF_UNICAST_FLT;
>
>+	netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
> 	mlx5e_set_netdev_dev_addr(netdev);
> 	mlx5e_ipsec_build_netdev(priv);
> 	mlx5e_ktls_build_netdev(priv);
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>index 2dc48406cd08d21ff94f665cd61ab9227f351215..b4fc45ba1b347fb9ad0f46b9c091cc45e4d3d84f 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>@@ -40,6 +40,7 @@
> #include "en_accel/en_accel.h"
> #include "en_accel/ipsec_rxtx.h"
> #include "en/ptp.h"
>+#include <net/ipv6.h>
>
> static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
> {
>@@ -130,23 +131,32 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> 		sq->stats->csum_none++;
> }
>
>+/* Returns the number of header bytes that we plan
>+ * to inline later in the transmit descriptor
>+ */
> static inline u16
>-mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
>+mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb, int *hopbyhop)
> {
> 	struct mlx5e_sq_stats *stats = sq->stats;
> 	u16 ihs;
>
>+	*hopbyhop = 0;
> 	if (skb->encapsulation) {
> 		ihs = skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
> 		stats->tso_inner_packets++;
> 		stats->tso_inner_bytes += skb->len - ihs;
> 	} else {
>-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
>+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
> 			ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
>-		else
>+		} else {
> 			ihs = skb_transport_offset(skb) + tcp_hdrlen(skb);
>+			if (ipv6_has_hopopt_jumbo(skb)) {
>+				*hopbyhop = sizeof(struct hop_jumbo_hdr);
>+				ihs -= sizeof(struct hop_jumbo_hdr);
>+			}
>+		}
> 		stats->tso_packets++;
>-		stats->tso_bytes += skb->len - ihs;
>+		stats->tso_bytes += skb->len - ihs - *hopbyhop;
> 	}
>
> 	return ihs;
>@@ -208,6 +218,7 @@ struct mlx5e_tx_attr {
> 	__be16 mss;
> 	u16 insz;
> 	u8 opcode;
>+	u8 hopbyhop;
> };
>
> struct mlx5e_tx_wqe_attr {
>@@ -244,14 +255,16 @@ static void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> 	struct mlx5e_sq_stats *stats = sq->stats;
>
> 	if (skb_is_gso(skb)) {
>-		u16 ihs = mlx5e_tx_get_gso_ihs(sq, skb);
>+		int hopbyhop;
>+		u16 ihs = mlx5e_tx_get_gso_ihs(sq, skb, &hopbyhop);
>
> 		*attr = (struct mlx5e_tx_attr) {
> 			.opcode    = MLX5_OPCODE_LSO,
> 			.mss       = cpu_to_be16(skb_shinfo(skb)->gso_size),
> 			.ihs       = ihs,
> 			.num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs,
>-			.headlen   = skb_headlen(skb) - ihs,
>+			.headlen   = skb_headlen(skb) - ihs - hopbyhop,
>+			.hopbyhop  = hopbyhop,
> 		};
>
> 		stats->packets += skb_shinfo(skb)->gso_segs;
>@@ -365,7 +378,8 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> 	struct mlx5_wqe_eth_seg  *eseg;
> 	struct mlx5_wqe_data_seg *dseg;
> 	struct mlx5e_tx_wqe_info *wi;
>-
>+	u16 ihs = attr->ihs;
>+	struct ipv6hdr *h6;
> 	struct mlx5e_sq_stats *stats = sq->stats;
> 	int num_dma;
>
>@@ -379,15 +393,36 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>
> 	eseg->mss = attr->mss;
>
>-	if (attr->ihs) {
>-		if (skb_vlan_tag_present(skb)) {
>-			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs + VLAN_HLEN);
>-			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
>+	if (ihs) {
>+		u8 *start = eseg->inline_hdr.start;
>+
>+		if (unlikely(attr->hopbyhop)) {
>+			/* remove the HBH header.
>+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
>+			 */
>+			if (skb_vlan_tag_present(skb)) {
>+				mlx5e_insert_vlan(start, skb, ETH_HLEN + sizeof(*h6));
>+				ihs += VLAN_HLEN;
>+				h6 = (struct ipv6hdr *)(start + sizeof(struct vlan_ethhdr));
>+			} else {
>+				memcpy(start, skb->data, ETH_HLEN + sizeof(*h6));
>+				h6 = (struct ipv6hdr *)(start + ETH_HLEN);
>+			}
>+			h6->nexthdr = IPPROTO_TCP;
>+			/* Copy the TCP header after the IPv6 one */
>+			memcpy(h6 + 1,
>+			       skb->data + ETH_HLEN + sizeof(*h6) +
>+					sizeof(struct hop_jumbo_hdr),
>+			       tcp_hdrlen(skb));
>+			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
>+		} else if (skb_vlan_tag_present(skb)) {
>+			mlx5e_insert_vlan(start, skb, ihs);
>+			ihs += VLAN_HLEN;
> 			stats->added_vlan_packets++;
> 		} else {
>-			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs);
>-			memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
>+			memcpy(start, skb->data, ihs);
> 		}
>+		eseg->inline_hdr.sz |= cpu_to_be16(ihs);
> 		dseg += wqe_attr->ds_cnt_inl;
> 	} else if (skb_vlan_tag_present(skb)) {
> 		eseg->insert.type = cpu_to_be16(MLX5_ETH_WQE_INSERT_VLAN);
>@@ -398,7 +433,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> 	}
>
> 	dseg += wqe_attr->ds_cnt_ids;
>-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs,
>+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs + attr->hopbyhop,
> 					  attr->headlen, dseg);
> 	if (unlikely(num_dma < 0))
> 		goto err_drop;
>@@ -918,12 +953,29 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> 	eseg->mss = attr.mss;
>
> 	if (attr.ihs) {
>-		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
>+		if (unlikely(attr.hopbyhop)) {
>+			struct ipv6hdr *h6;
>+
>+			/* remove the HBH header.
>+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
>+			 */
>+			memcpy(eseg->inline_hdr.start, skb->data, ETH_HLEN + sizeof(*h6));
>+			h6 = (struct ipv6hdr *)((char *)eseg->inline_hdr.start + ETH_HLEN);
>+			h6->nexthdr = IPPROTO_TCP;
>+			/* Copy the TCP header after the IPv6 one */
>+			memcpy(h6 + 1,
>+			       skb->data + ETH_HLEN + sizeof(*h6) +
>+					sizeof(struct hop_jumbo_hdr),
>+			       tcp_hdrlen(skb));
>+			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
>+		} else {
>+			memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
>+		}
> 		eseg->inline_hdr.sz = cpu_to_be16(attr.ihs);
> 		dseg += wqe_attr.ds_cnt_inl;
> 	}
>
>-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs,
>+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs + attr.hopbyhop,
> 					  attr.headlen, dseg);
> 	if (unlikely(num_dma < 0))
> 		goto err_drop;
>-- 
>2.36.0.512.ge40c2bad7a-goog
>
