Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854BC605C21
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiJTKVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiJTKU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:20:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF92106E16
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhPF5yJt6qVx7/Ppv62gNTWSxdDsM3CDa8CEu4MUE/M4k5+bY3L8xQhUX2upBA0O4rcG/GaRmqB7DkdHDYajJsh+zGwf82IaQ6NMzWf6gvWqMDhsa+hGPIkkDJP2htDSM2y6oQtMcW52QxSfGG06GtNvVSG/D8dPkPNsjuJhc24bhTt52kpZy2VhFRpVXjL43L0YGkXS1QFCL1K9k9zGwJCGFhzL65h/Bl8ZrOFny65ZbDiyhZ1VyWapYQBwGfstPet16zglTLOjFcmDDHC+oZRziTWq/aQGcC4RVyCv+2XRaHsVjW8CTMWizxkUACHlpLxg9s5N6NTVudD2T+CdLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uzi5joSDMAOMVKgUjEhcUpTyHX6iFpGB6ntvygeSvCY=;
 b=HRIW23Q/12aFOW+hMwZ5GPFXSzvCLDSYKmFsIureKV4MTHk5twMezwH0FF7g7m/ZDVngP83e8NvdCg33OAYUBfXmj5g5n2fhWeeYongv8OlQDeXZCZceVm5QhDR3Ja6jHckzdvGQJ5Cfjhpel0O177BXvX4bM/VmmPD+IV11inA5LBTF9SeCkpM5UAsnm3rYo7Dv+Fx2DRz7XoVM57yj7rg85UCIIH006XVUMsvjZy7ndxkkBVL7cWxDEoQGH5rdBbNCSw0K7QWPUTOUSEDISbMi3gr1+/Ead8HBkwLvaj4heXwxeoq6BOico8CXX7QsnFxKC31EJuNMclo8kMRVlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uzi5joSDMAOMVKgUjEhcUpTyHX6iFpGB6ntvygeSvCY=;
 b=YtOhGDtYIwb54kTJuGzbHEeEBQ3ejnJVgmAIqa388m2hNBAvazmBKbSi4MMk7xQmSVyRd951t7xbs4z8dCOm7hRdLwBchdx+w05OzLqnWmru2FJmnL8dy7KEz+lZZnsPv/hl7k0crPljICoufvEOapOVhbfzWg+6lmSOiqJ6Jp2EC/Z1wBv35+uOJ4iLsRKASe3gOIF1EiXihoafw6mtuw/ONlu4qL5HnkBAbEw26u6thH6hrOj1e1Nl0J2907r6U2CvgP6vhcs5CmFTqRfsJCszZ+pBi3J4wxr5C9ILRxi562nXi6jy62jGBZ1+ZIJaodX/W7siLHUKRqV5yclUBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:19:55 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:19:55 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 12/23] net/mlx5e: Refactor ico sq polling to get budget
Date:   Thu, 20 Oct 2022 13:18:27 +0300
Message-Id: <20221020101838.2712846-13-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0250.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::12) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: ad454adc-7d8e-41da-0b67-08dab284a26c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j5p8nAhVnx7zOfjow/7oZL8YU61xjmX1T0yfMncNma33Djww0dCGjmjObhqfwsXexv5etzDKD7WW8qKyWJg3OnZe5PwChkUl7i3y/3qEXtv0YtmrMpJV7f9Sh21hsyuDFf/4oyI/TV58nSHhomsFoCPxV/VPaEBDr3p7esxRzIQjJhBFQlp3y9blM0z+Cj8jSJFTPuV/oYH2PvH04rVogiH35CvuAqi7NfO8Wb2yBEJtFIQX0G5Em+yFQnAa+jKlGHPdbY8jCeHGBc4D3QAYm5HUBxy9ts2pudXcR7x1b2jlTwA7ypnTvXPrDrvOykNtI6OfpIB0X7vHRumId1gLD4iRWva3Zv4kjlAz7UZqWI57iMWNllKU2rr588515Pl3ce+JencfwI+x0PUijZ1sBtj0toC5PmaDDzI279auugII46fr0Vl1GAudhCg6odcYI9HJJMchc2rNIBX2AQbuPVWVgvtmJTDunFr0Klg+vxuYeArY7K9IQUugGYNN7VkblN8rqg2OLRCRNa8ujie5ZMUFfosUcJf3/NhxkMAA5MhV5DUvFJwPgfRF4fDcYa+kSLLIWsOW5GHCv160BC2KfcpXjU/ptXa6747Sl5f1mn4ResiiTaWx0fyS1G9ONEE/ZcPOoSPaiov2hyn7R1zgJpWiQTQEZ7owjJFY3u9iWBq4eyb2xeitty2SlS2RRerRM7vEJ56xolmpvfn4/YdgzsRn8rfV3nshmbwCtDv+m/tlsAUdNnEl7zN412Zm2OTv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?19QHlmqcjViogRqlz5v16yIhSubtFXKQqelaUbhX9Sj3KQwfSDb2dFvVX0Yq?=
 =?us-ascii?Q?NCLB7fCo0vaMvYsOYKb4N4zl2guY461fAg3IFl0cmFOANHg7dck1+d2pwEau?=
 =?us-ascii?Q?YpvlPCUcZhD/PiMksU05xyjBrrJ/AdcDMUw0E8bsf73qSVSlDUfUJB6yw87p?=
 =?us-ascii?Q?X35yy4CS300LSjqpWDMBXOagM+wMYpfXD4x0z38HYsvOOBu15PSiJ92thQew?=
 =?us-ascii?Q?0u/cVrj1IegZ545pqhNyDfnUDdtQhoHDuLHqmt5O4ANbCB8addDQc3eKDtsC?=
 =?us-ascii?Q?6v6z2f55CAP/QdQnrgCF10Tun2YpcHzFERutTQSdgcrxvcn5JRphhRjYXvha?=
 =?us-ascii?Q?EUzttmTPnjRUc8sc7N2u9AIhE/ixFgL2KQ8P0fcc10ZAdvfHhhYlMtC7oGDu?=
 =?us-ascii?Q?Nol5P5ZDSXU6dhIR78JmmvLcVgTZMC3xMoqz0vQMQqSCzst9TbWFP9MYC+Xf?=
 =?us-ascii?Q?VOK30Sc6f9iL7uoi+joUHwDTocXUq5JC5TNJYb8atsDVVSPzpkGLwvpSfLqz?=
 =?us-ascii?Q?xj2tFlQ4xKc84HaoaqG/uijQA1FUboaOWhSXnUEx89uMMhGHLPmm+ar1+86W?=
 =?us-ascii?Q?+NHDeF2iqQEIgk8cxVyE0ixXoHqATgNL+i+7/nxDR+jOUyqiXGuEkNW7SAGJ?=
 =?us-ascii?Q?4i7FY4n1wpTolMOySzosIBSsKjUusHjVOXMmJ/KPMsTHn59aTYVRy7KWHhGw?=
 =?us-ascii?Q?O0QWjoAlXUlC+qzR0vy9yZNGNfTSA2pVB7RWtfE41MtazL1kyq+F5DKdCeUh?=
 =?us-ascii?Q?gSir3UV7G5zJaB1R3bhtP0YPH+aE/6Y8+tqTU4tNVUQcI0QAGlSF01atJmNF?=
 =?us-ascii?Q?3tk0vaLAF85vzWvt5OJ2xt5bq2DKP29Agaq22uFqZN4/O9Mdvobs1jDFl43x?=
 =?us-ascii?Q?YsSdIVNykPTjsm9QOZmit0RuULnbJ9oBGEL2Zn00hZ+eaPsDf3B4v15KeJAV?=
 =?us-ascii?Q?0E99iJqMPUZbFcUjN2Q0hb+ovr4caWkgWWwlFQlGNykdZOr1pLPxl/reA2cI?=
 =?us-ascii?Q?ka0jX1JefobaWuy31ofT9iK5qKI7j/e6kNzmaQeI8RO7oc+mZcTZSOX5DLQz?=
 =?us-ascii?Q?zlOERT8J5CGzM4jyl7J50J8Zw31b2YEVV5wjZNZO1s4W+EfcINzL5BVNz53m?=
 =?us-ascii?Q?kwDHt8dVQpfW8sfVqacyZlsLOtXNdrMsClThu/GZZ03GLed8o8akAzL5qH3u?=
 =?us-ascii?Q?xerxwcyFIwQoT+qqJeNwxh1nolduGGtJMsPM3cNnJLjabqPMOvVnPT3UeRWX?=
 =?us-ascii?Q?KWaxNon6CwNE2cSf7Pk36IqYkLrxldEb09mJ/aXTLWcxw2nf+pWE7XBIueNi?=
 =?us-ascii?Q?Awc2IqxhX63ASA6l3UH1IHSE+5ZZgvic8YBPtdv/ldU+wNjTig8GxfswRPVo?=
 =?us-ascii?Q?Td2+1kBrUoIR5jN954wwVrzdai11WLFfXFciPP14rClyMoGgNekx+pttctQi?=
 =?us-ascii?Q?jFQpy7DyKEGWAOgHQM7UH7/DwqTMn1QKr6+AfZQTIpNnF9m5VMGpbFja8Mbj?=
 =?us-ascii?Q?mBcDDUnXrebm6IAWlbdrd7e+pBfBrbN5MC9nu4+gblqeK8ESMupxrQYzA46c?=
 =?us-ascii?Q?I0rhCeiteMhwjt51ZsE18RnoEYsiEBpPPckh9PEF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad454adc-7d8e-41da-0b67-08dab284a26c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:19:55.7388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iR9mMvwaddwge1NSp++uujwJA1pBkojDhrFBTD/1PJFAgqC/taTZG0xh2QQYg2syaHVUrFeISF3vjdtRIdjl2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
index 4456ad5cedf1..30c456bfc1c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -41,7 +41,7 @@ void mlx5e_trigger_irq(struct mlx5e_icosq *sq);
 void mlx5e_completion_event(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe);
 void mlx5e_cq_error_event(struct mlx5_core_cq *mcq, enum mlx5_event event);
 int mlx5e_napi_poll(struct napi_struct *napi, int budget);
-int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget);
 
 /* RX */
 void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct page *page);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 58084650151f..261802579791 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -853,7 +853,7 @@ static void mlx5e_handle_shampo_hd_umr(struct mlx5e_shampo_umr umr,
 	shampo->ci = (shampo->ci + umr.len) & (shampo->hd_per_wq - 1);
 }
 
-int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
 {
 	struct mlx5e_icosq *sq = container_of(cq, struct mlx5e_icosq, cq);
 	struct mlx5_cqe64 *cqe;
@@ -928,7 +928,7 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
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

