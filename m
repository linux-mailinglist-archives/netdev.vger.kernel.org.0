Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF8266E26F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjAQPjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbjAQPiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:38:17 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2071.outbound.protection.outlook.com [40.107.96.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2AE40BFE
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:37:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqztnjXHsaLavXqbxJ+vDf7dCHveQEkbk7r187W64yeMftnWZ/+yx+ndQND1He1Q1GT1avd+jvhwrUXoyxDhUMKCeGy8nvE2K9qxpHHW+9FDDC7LQLDudFkEaE6FKZxNfSyGXrlQpGVt1tVA68Fo+4afNNcik27+Z/OFVmQfD3tJiTXb5gh+ZDdILWy9Ac+OGbQEZwODc2aLt9mRHnNTlFDeEel0EG9EDy9ALTV1kIRaeYSHp6I0mA2aTNBQeIp8ZnLwdt/s1u3wQxdIQ2tLqtGyyr1j9cctBvyxeA6pvgImhqJxWORbKfgOUbk8NzaCyg2CJTTKITCAGhrMdfXhYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wmbxu9QzJMmmZBzKslA8lQz8oh0zDqhN+rGZ7BboM5s=;
 b=Uj0tiPFcl6wu+kF6fIkKQQyhQo5VdEbNRjkwPtBqyRYB5MTXkyRh19DeEs2+FDxhB4m9k1twRklgPbaE5ZargCnCFbLgMDFXfZqp6kMihroatvJIrd3F2pOVfvBg52Ygbd09X4fzaGpu5jHpFnTvMpMvNjB2fvO8AlrYdC0k1m46r4//cm5+pg5NGalg4ozmVeGoyd88EMVUlUHBZf1DN/FE9muLPlvRDfv7nf9LfhBZwS4gD2kPeC4smBVmFxcM5Ic6ZBiY4nY8FkAifBNXkb2ZCjro8EQP5D9Kvbt4RmKhXq5oh+iEsAijlRKsqwFCSxxA+6uF8+MuV4sa5pL4/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wmbxu9QzJMmmZBzKslA8lQz8oh0zDqhN+rGZ7BboM5s=;
 b=Ndswb+FnZuFkq9QjZdndfKb51HYQqFEPfX4KBj4qXnP0f+VdIBG74+4z+5vbXeYFQ19syg5uil9smg13+ZWHLb8ZaUe4F9Ukwai41RCnt9dZuIPlVFv82CEYC/Gvu0ZpoiqhUSbVZYDBOQqXO+PKaPWleYkrA0AB+rU0fau7IEp1ZuO/sCI+ciSio0CAOc5LxBicc/THmtBaMyz8GLJjK7LQzoJT8XTmkwFul5oImai7UyfDHo3S5scjh0Hd2fzHd5wgWPK9+ckZ4ro56S6ypO9wP72s3S88PcMa7KgSu8BSD/zAXJm/wsD/Cvsbt2rFL9Hk1uVpbtQu63YCNzudWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL0PR12MB4914.namprd12.prod.outlook.com (2603:10b6:208:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:37:30 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:37:30 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Or Gerlitz <ogerlitz@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, yorayz@nvidia.com,
        borisp@nvidia.com
Subject: [PATCH v9 14/25] net/mlx5e: Refactor ico sq polling to get budget
Date:   Tue, 17 Jan 2023 17:35:24 +0200
Message-Id: <20230117153535.1945554-15-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0491.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::16) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL0PR12MB4914:EE_
X-MS-Office365-Filtering-Correlation-Id: 6df8aaec-eb07-4b01-0d23-08daf8a0be3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nYOGaXR0oHx0EpsbNseYbIuNpHz+ShutVAPx5N8TOTFVpFtoUC1m4yTNze+M2wPjgFc5fZJUPE0z/ScPB6izDRxB4mAbqcFsdmgywKqir3n/lkITN3qgIBLY46HncYIJimdREruOsaZXHySnFXjasq/CaZEtF/iiKhmjc6v5X0DscuKs8Y0JkX0Z/JctwX+jpx7msL5gWAkh6PIoOH7f5k9JcXCwFcWCLdz7RUOPDGGrINx+nMBFa/UDSmpbEQFONKo83LwYDaRhYzOCyOGWf0+EhDcpGOeH9EglSOKTSmrMrMzfUGzGUJLrrs5TSRTYwWWnifgaXPodnQDn3jqMLCY4Cu4ZVjhf54tIaGqlWLktLNkKF9YAoeGY257/Ei2rPqEou9YVsormPkwVAUO007dPAOfwfkRrX0XD29rwuqllJBFTZUJGX2yTCMjsrslTi4+eNwmHtdxBPG7DM2G4zpvZ/MRsoVlv3m1Ob/cmort9aEpLR/qvyoSDalmKjBjBDDY6RreSiGxxX4d6ZBJDpYZUGiZEvT6nOPgoSEq8eyeMxOjmteQKT52Zriuir010SPgxKeobMQJeW4n0tKpuKoCyr5B041HDDisO6AUpXm+Vdh0bNZwQ9YNKb0Qe2k58ydUqDeLSFPJryVE2BTJx8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199015)(83380400001)(54906003)(6512007)(6486002)(36756003)(478600001)(186003)(38100700002)(2616005)(86362001)(1076003)(41300700001)(2906002)(107886003)(26005)(6506007)(6666004)(66556008)(8936002)(8676002)(66476007)(4326008)(66946007)(7416002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SdBJ9zP/5iriZXqWo3uB9Ojk3XU2GgAZlMh90iN1nJMfn0EGXcybJ/D3O6Xk?=
 =?us-ascii?Q?gv/6WEwIZ/pr9oZzlf9dB5PPokn1tziwekcth/X5jueaU9v9yj78D/2FJ5LS?=
 =?us-ascii?Q?ySnvkgw/VFy9OnNEnZqALLwHLp8Jccx8uAY6AzBSzAVu/KiHHstAHtaSgxPL?=
 =?us-ascii?Q?U02OAsbhGJhz2fJQduyvcCC+dhJ9CnYkoyJHFDyuwAriqLWK0rhfb3ZFJKm+?=
 =?us-ascii?Q?myKbZ0Y/J4VTE2OmeqaOFkV36iqqHjMx3L2l4vYY1PgpYB4YLud+x3nzUwg9?=
 =?us-ascii?Q?zTjOuH7cXYw5eZ66IHxDFazVzyJpjQIzz7O2qNA5/DHJKxy1QRdKRLU28MaB?=
 =?us-ascii?Q?2Lg+GI1UHfF1fAhKVUySxtuuJrdrSXzEnWFasZM+E4WwhyPPcW2mQf96WoEp?=
 =?us-ascii?Q?Rfep+2jNAPwSRH4hADI/MzMrkIXWpZeO9TI4rOR4OQlvpVLsJnXKwhyi3/yQ?=
 =?us-ascii?Q?MUCQMKygKFQUlQxnhG/u99sW9T+uGFJPpFuqWf3bY+MN423gHyDW9noV2ZOy?=
 =?us-ascii?Q?9nbDwUGvfcmsgT40r/gkwiuOAs2L4PQS5nJcbaLGIAjN+5hWKyst3ntRjcjK?=
 =?us-ascii?Q?JYbeoDcdFhxezJjwwS58ntS7kRYE+y392wWld49RAaRiKxpodtVWBuKOSbzP?=
 =?us-ascii?Q?sPujIhv1XDYUUUjU0Iwl6garqzggaFkKCWB4i02/bg5WFOtpSIf8YKlXzOq+?=
 =?us-ascii?Q?x9gjoibRdbMAOqGodWLlBrNQaAhO3yoxFPcOfpNAXPuqtvORfCJmOE98XI0D?=
 =?us-ascii?Q?Fo22nRmDEGi0djgsfBjONxX5IAkT1eruw3RouE1vsxqhwZ07BhIln833thXK?=
 =?us-ascii?Q?Pght8nk1K8R7bAxosKtnOMdszHPhnWzHOZGC4XpJk6Q03OGP1f2jO/XF9spM?=
 =?us-ascii?Q?HpDm7HYzHPDcuIkqj7JSAArlJ3MAFcSmPxEKfrULDDKnV+rriSlNxsiGnaPq?=
 =?us-ascii?Q?xrRgYJk6EuMeOC0kWeCTOms117FwUQSK9dZgOPWAgxHGzm0Cc2Lk420IEVyg?=
 =?us-ascii?Q?2UPb9z7IIzyP/+YPi8hDdb/W8L+sRiaEMroGZn1PXSrxj/T8o7urbEC6aGxw?=
 =?us-ascii?Q?qgWSGgNHpnf4UzggSnPGTtReLc4PjPZcVzbkQSEAI6eS/yR2TfKkHuXrNhZs?=
 =?us-ascii?Q?SVtvfn88uR+5f83TfTSvfGWuEQ8LZ8ejq92nxOKZRTkLAPUxC3P/hPw5FPl3?=
 =?us-ascii?Q?q2nMBkeXSJsRg09LYur3fbqjgiePaXrnlFqXPkVE3wfyN38AgVn72cbN4oPJ?=
 =?us-ascii?Q?RofJ7K7Ze0h8nPSfET0qAdW+Ngm++HaUnEBIpqK6brLBakjPsuIQ8EsBAbzL?=
 =?us-ascii?Q?w5DGhY/08PgEANS/fLPndalGzPjnta2qSb7wYWkXIuvzp+botiubF50eIul8?=
 =?us-ascii?Q?19so1T4cUloEkH3+brnrKKbGa4Ala9AX7AsfqfZtu207YpZFIAy2Tf8VWisb?=
 =?us-ascii?Q?wGVuB4BDdJtDJ1C+B4fP8pCuAzxqk4JFj4JG/z9QDsZ/H9HXia19hi2W6v2V?=
 =?us-ascii?Q?6+QSZ8BCfoAj7uyW0BHZZaSvaM6CCB3Ky7DyBqKGgd6+qGkgxnFjzfOR7752?=
 =?us-ascii?Q?9Qt7uYA+mpcn1avUIqi4F2NdjlssvcZ6LrmR6jVq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df8aaec-eb07-4b01-0d23-08daf8a0be3d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:37:29.8036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vT+BZcY+Qdos0UFw4ICTAV99pCfJwFFx6jfD4VOwFN+BiinkwvmYpVbDL//ckaiglyBj1e4sIGZzQ2huG84UQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4914
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@nvidia.com>

The mlx5e driver uses ICO SQs for internal control operations which
are not visible to the network stack, such as UMR mapping for striding
RQ (MPWQ) and etc more cases.

The upcoming nvmeotcp offload uses ico sq for umr mapping as part of the
offload. As a pre-step for nvmeotcp ico sqs which have their own napi and
need to comply with budget, add the budget as parameter to the polling of
cqs related to ico sqs.

The polling already stops after a limit is reached, so just have the
caller to provide this limit as the budget.

No functional change here.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 853f312cd757..a7799cee9918 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -62,7 +62,7 @@ void mlx5e_trigger_irq(struct mlx5e_icosq *sq);
 void mlx5e_completion_event(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe);
 void mlx5e_cq_error_event(struct mlx5_core_cq *mcq, enum mlx5_event event);
 int mlx5e_napi_poll(struct napi_struct *napi, int budget);
-int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget);
 
 /* RX */
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3df455f6b168..51167f000383 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -916,7 +916,7 @@ static void mlx5e_handle_shampo_hd_umr(struct mlx5e_shampo_umr umr,
 	shampo->ci = (shampo->ci + umr.len) & (shampo->hd_per_wq - 1);
 }
 
-int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
 {
 	struct mlx5e_icosq *sq = container_of(cq, struct mlx5e_icosq, cq);
 	struct mlx5_cqe64 *cqe;
@@ -991,7 +991,7 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 						 wi->wqe_type);
 			}
 		} while (!last_wqe);
-	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
+	} while ((++i < budget) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
 	sq->cc = sqcc;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 9a458a5d9853..9ddacb5e1bf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -176,8 +176,8 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		busy |= work_done == budget;
 	}
 
-	mlx5e_poll_ico_cq(&c->icosq.cq);
-	if (mlx5e_poll_ico_cq(&c->async_icosq.cq))
+	mlx5e_poll_ico_cq(&c->icosq.cq, MLX5E_TX_CQ_POLL_BUDGET);
+	if (mlx5e_poll_ico_cq(&c->async_icosq.cq, MLX5E_TX_CQ_POLL_BUDGET))
 		/* Don't clear the flag if nothing was polled to prevent
 		 * queueing more WQEs and overflowing the async ICOSQ.
 		 */
-- 
2.31.1

