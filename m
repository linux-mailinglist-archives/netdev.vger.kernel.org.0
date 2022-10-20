Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CCA605C29
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiJTKWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiJTKVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:21:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B4B1DD89B
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqlOO1PZUHXYIsHx/5+Gqr/jFUuJYykeB+En6DhHf1YtxvcebrRxSHfPMhTSJ6tqeH9L0h17hrO0njGmXuSrF8PIkgku6F6o+IVgAJlPmLNr9ZLicW2q8zV2lOUNrq7QUUvypHyYJNGHoXys1/ZhW205QQrzcNJZZpRcUVVphk8QckYro51F3Ep6LTPiYo6H7JmN2q/o1G5Ol9NHD2/cr9t7Wbg3GzUviQHDyhFR90ogw/wfXfu+4ogVYwMjnCLVMvoz/cRKn8ewJ/yeRStfdrmmJdTPGdIV8h5Om1E6CTiWY1VlR0sZP2QXhAL5vczonEjCJLKTpcnXIr/Q1YBhuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVB4Zly9a82AwnKCaU6P4eFEAO5zTsj5IJIwexxOZqw=;
 b=m0j1XyIEhzriRD7ixw5YBiug9wOPOOFon0G5OpF57c5f4UDqNCO8fMXEH1nfIwEyMUCv1AuMfvfAZ/n40zcBfkNNGVRbee24gaxASRHNNjebWtiI6qJeLWH9tjV4dCwdsLWNaAMzP9VLCu733NHIfKP35wFpFLDPp1VfTFzgdW6/x3Zeh22mxLmK0VB9thsySPAp3Q/jISboWD+kRQvEf20P2E2FRpu+8MpAKCCAFtpwoPZsmejCQtBuy760L0NK5+gIya94WlMGi81/2gqJvwUruXU68OBVcCTB7cqk0Ku6u+ySxstJFf25iAt2QhxazySmxBCp45+Cvzp7qCXxcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVB4Zly9a82AwnKCaU6P4eFEAO5zTsj5IJIwexxOZqw=;
 b=Q6Ei0hjMhTvru5EHCWQMa8mzDOcW8lfwdygHtoeXsjVQ3QOJiBoD2Vf1oqz3W0H9p8gT/XG6wQK9qpgJCqkTcr3ETL0xrnyY59jfdRFR/dzOvO76VC2Prb1nsEpp/BhrmseTUnybSj0P1XG44Xtpb1Taz43ixd08nqBgHL/ru6rek9cZYsOQeqMSngTICbm20ujHxrsqlI3OZ8uMOPigpv6Ird65uscyxJycwe3NVb3tDh0isgTtzb8eY6RFpaH73oLEuL/q7O0Bqh/Bjv4Uho2i+YSfZ+KNcJzha5cgHvQXwMmipEQUM4YaaH4qDNoDYAI3EUc8yIXz8dvEamUCQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:20:38 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:20:38 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 19/23] net/mlx5e: NVMEoTCP, queue init/teardown
Date:   Thu, 20 Oct 2022 13:18:34 +0300
Message-Id: <20221020101838.2712846-20-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::6) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: de8348e3-0cd4-47ea-4860-08dab284bb8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TzKej2tpT56CZXYQoMfAcJK/CPXV/EARFUKt8aLlH1YzRypPh6XnpYiTGBRmDohk2mdbKMn8SVOGZBWF5B2kuqpq1BXGpMnDwd7eun/w7kxUcHRZvVvIDK8Nrx7daf9hpVPVwh6KpMUB+8QNGcugvXg8lBlpzwLfwS98NmCucJoFURw3+y/+W2Tl9Ysaca8DcSEVKl9qHPLDIMajDZIDtU23OGrnahGaIz6TToRIbmdUjBPQKvrs8pO34EBd0aWPJ/pkF2aA5mHsUoDYL1UMmErylUXo7yUfSiS6/eKvQdFqxgVdFC2qMNCz/1KH4DZJ7VjChah+zUF6jadPfVm+560SYAXih/twI8sPvPQPizLoGtpBhxzHecTavJYtOCzxKmDqB+CbHlvETCdiIPt5XyrAz7pslpkJuRth9ovCaiAGEuLPXYuzMlg6p7uWoeB/agVQvC7lRUi34UUQ+B7mQqJ2uup2uvo91enX98v8hUjXU2PjQhIB9bIiRvFr9dmUy/2uh4o/B6oBRAREMniIz76CSSthh4H31oyt3xU6i+kERxE1P1ZDWhLnCYtTSpAy7rWy3MtplRhc7tyVx8qm2o7CEM1hIWbqjPlm/zD3jPvvKCiosjYcOtKgI12OTAEAZG3j8rMKpBo3XwM90WEdXFvW7b8uaAeXQH8aX9KGlWYzLMwut6KbSk+mhNKecfQuJd0yr6fYxQNri+gE4N+fv4FgJwVEhbuQ4irVLp8QSng3DNx0fyFgb2Mkq8AgG5lqI3Z34sq09RQk3JEAS52aqXCgikAHK3cx0wXt5bUO4HM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(66899015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(30864003)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UA/Lf8D44CmGx4Cdb4l+qa3GE1t5Hdh+mR662+0aVARZDkVj3l5sYcTZ7JRT?=
 =?us-ascii?Q?3KoO/WOlGAhUkM+ZtwNF2jRh8iKLNWInpRsnp/XFwCqsrdUjOlahinRliVhv?=
 =?us-ascii?Q?uI5bimSfGBNu+D/d+/kBsphFCrlyTbdTf7U0t0MRvuROXrdKAViUMI7idOtc?=
 =?us-ascii?Q?c+kcje+rem5zlxcigt8ubKzeZHQIvC6zvT4T8po/mCjYh9RBsMkd+S5iP3KG?=
 =?us-ascii?Q?Fp+dARlvLDGFrK7pLrb/Ekc75Up+r4FYHBPB7PC8zx7JCHDM9dhj0ZPB/n1T?=
 =?us-ascii?Q?tx8hpU9VSUB9MBBtO3zLacQYshZUc1AVSU2iOtBwdU5/jS2TXH0l9OM7v4fg?=
 =?us-ascii?Q?K0W5Ek3ECWl+MmpLnfiBs+W/mj5lWPP179vRz7e3z+N9vBuoQ4zKh/PUtTps?=
 =?us-ascii?Q?WN93I9Ttw9HHhPVmDj+eNhTxdVJHUleRhtwCrsCsp7KjVPkzhSfG2SNotk/E?=
 =?us-ascii?Q?Td91IlXyoEzhRTUTXnmKreFA9bFEeJOiqUeWApmlFpw0OWytWiwYMQHRo8OF?=
 =?us-ascii?Q?xuwI20bMssR2GkwHWc1CozfLNfFLvvad4yQt+yJ4Z8AgJ5MMCxp3ztuuoCfI?=
 =?us-ascii?Q?YkXNVp5F7C5onTrEkmBkklwkuaw1kbDO0+kVzkyFGpz13xd1827sZ2BqIYA6?=
 =?us-ascii?Q?zSHIILv7MlJHAek4/K7/Fh9B+TJWQOpYwC3pahL4A+U9ddRnB/kc5wbXdVUC?=
 =?us-ascii?Q?Cw/zpD2+v/wyM0uttdLieH6uIDlBpRtUaMxwWTPxYt1PIEQBzRMWtOaqejDw?=
 =?us-ascii?Q?AoEYRVBCoE/lAIBQuCHaXXwBGkozzD0Q8bEBT7sIb9Oag36UP1VZnVfCTmHR?=
 =?us-ascii?Q?5dt5O5GpKoSGdLC8GyEUhkSr+AZ35oo1elG22vN1vzklyUwn4IaT7SLNQwZv?=
 =?us-ascii?Q?jRv6lC3JdwobpWpF7fgFE0MRz8EEb6ekc+OMYN+iwyz8jdILlOwGLwqhnhCi?=
 =?us-ascii?Q?Uye0mCVDSO7wa5xLyftef/NWcxtwnZciOlJgZJinasA8s4n05MxOuR4pTHGT?=
 =?us-ascii?Q?6GuHNLdUBRi5XZfeZ485lk2hZo5jqVF2QRO+CZKMPtqY9ivLxaOoN+aRidrw?=
 =?us-ascii?Q?MiMPAYK3NzjMq/nuQ3iFNff8hgeQ1KyI4R5dFoSLhgsBBC4fpHFFCgE4Dsxz?=
 =?us-ascii?Q?r74mCuyV2LX3iX1zpicgtb2GcnBUY3hrIg59iwfkLerYaMyvXSTc+1f1NZm4?=
 =?us-ascii?Q?bJsiiEAeusgUriDRYY7L+eileSjZagQXf8VMD+HxgiswVnKYcgIekPbmHQg+?=
 =?us-ascii?Q?RXkaSa1A1eYWbD24cHkCHSatx6W/WlU9ZxLrBrs1MnxM9pwlmaxQ8zxVh/p8?=
 =?us-ascii?Q?sXCawMl5iRzmqqOipM5Bdn5CTiCVtlcm1J0+z3cWCXEkE2Ps2sicud/tdzhl?=
 =?us-ascii?Q?mE3M2WBxIekhLiMGyYV1O5e5s3lBbWt2ak7+f7EzgrGNQoY6JoSlzJ5bsRYd?=
 =?us-ascii?Q?HywB8UIB/mXvo0OQZEcKnfoeVrE0T4rBGA9IT4yp3rnJylWd9q3IDmhymWnp?=
 =?us-ascii?Q?r5aYNMfY3Jls3SpJBb2JNotJ7OcAzUyqxSrENpCd+LdHWcG6RoBEgPiwR7QF?=
 =?us-ascii?Q?qmp5H4zC69odpuUEvgYmO25k+JmxyjP053nE2Zcu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de8348e3-0cd4-47ea-4860-08dab284bb8a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:20:38.0532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IC2IBYaAUBhcVbfpduhx59vEw/3TNEB9f6JlVzdXbAdXyHyCAlThwnGG1yllmOiHIom48oavynIkoqptMUCPDA==
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

From: Ben Ben-Ishay <benishay@nvidia.com>

Adds the ddp ops of sk_add, sk_del and offload limits.

When nvme-tcp establishes new queue/connection, the sk_add op is called.
We allocate a hardware context to offload operations for this queue:
- use a steering rule based on the connection 5-tuple to mark packets
  of this queue/connection with a flow-tag in their completion (cqe)
- use a dedicated TIR to identify the queue and maintain the HW context
- use a dedicated ICOSQ to maintain the HW context by UMR postings
- use a dedicated tag buffer for buffer registration
- maintain static and progress HW contexts by posting the proper WQEs.

When nvme-tcp teardowns a queue/connection, the sk_del op is called.
We teardown the queue and free the corresponding contexts.

The offload limits we advertise deal with the max SG supported.

[Re-enabled calling open/close icosq out of en_main.c]

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   4 +
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   |  28 +
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |   4 +
 .../net/ethernet/mellanox/mlx5/core/en/tir.c  |  15 +
 .../net/ethernet/mellanox/mlx5/core/en/tir.h  |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   6 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 563 +++++++++++++++++-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |   4 +
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  41 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  15 +-
 11 files changed, 680 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index e1d779ec4d8c..ef81ff08b88a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1051,6 +1051,10 @@ int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param);
 void mlx5e_destroy_rq(struct mlx5e_rq *rq);
 
 struct mlx5e_sq_param;
+int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
+		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq,
+		     work_func_t recover_work_func);
+void mlx5e_close_icosq(struct mlx5e_icosq *sq);
 int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		     struct mlx5e_sq_param *param, struct xsk_buff_pool *xsk_pool,
 		     struct mlx5e_xdpsq *sq, bool is_redirect);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index e1095bc36543..4a88b675a02c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -611,6 +611,34 @@ struct mlx5e_rss_params_hash mlx5e_rx_res_get_current_hash(struct mlx5e_rx_res *
 	return mlx5e_rss_get_hash(res->rss[0]);
 }
 
+int mlx5e_rx_res_nvmeotcp_tir_create(struct mlx5e_rx_res *res, unsigned int rxq, bool crc_rx,
+				     u32 tag_buf_id, struct mlx5e_tir *tir)
+{
+	bool inner_ft_support = res->features & MLX5E_RX_RES_FEATURE_INNER_FT;
+	struct mlx5e_tir_builder *builder;
+	u32 rqtn;
+	int err;
+
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
+		return -ENOMEM;
+
+	rqtn = mlx5e_rx_res_get_rqtn_direct(res, rxq);
+
+	mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn, rqtn,
+				    inner_ft_support);
+	mlx5e_tir_builder_build_direct(builder);
+	mlx5e_tir_builder_build_nvmeotcp(builder, crc_rx, tag_buf_id);
+	down_read(&res->pkt_merge_param_sem);
+	mlx5e_tir_builder_build_packet_merge(builder, &res->pkt_merge_param);
+	err = mlx5e_tir_init(tir, builder, res->mdev, false);
+	up_read(&res->pkt_merge_param_sem);
+
+	mlx5e_tir_builder_free(builder);
+
+	return err;
+}
+
 int mlx5e_rx_res_tls_tir_create(struct mlx5e_rx_res *res, unsigned int rxq,
 				struct mlx5e_tir *tir)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
index 5d5f64fab60f..59c22cac9ef4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -66,4 +66,8 @@ struct mlx5e_rss_params_hash mlx5e_rx_res_get_current_hash(struct mlx5e_rx_res *
 /* Accel TIRs */
 int mlx5e_rx_res_tls_tir_create(struct mlx5e_rx_res *res, unsigned int rxq,
 				struct mlx5e_tir *tir);
+
+int mlx5e_rx_res_nvmeotcp_tir_create(struct mlx5e_rx_res *res, unsigned int rxq, bool crc_rx,
+				     u32 tag_buf_id, struct mlx5e_tir *tir);
+
 #endif /* __MLX5_EN_RX_RES_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
index d4239e3b3c88..8bdf74cbd8cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
@@ -143,6 +143,21 @@ void mlx5e_tir_builder_build_direct(struct mlx5e_tir_builder *builder)
 	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
 }
 
+void mlx5e_tir_builder_build_nvmeotcp(struct mlx5e_tir_builder *builder, bool crc_rx,
+				      u32 tag_buf_id)
+{
+	void *tirc = mlx5e_tir_builder_get_tirc(builder);
+
+	WARN_ON(builder->modify);
+
+	MLX5_SET(tirc, tirc, nvmeotcp_zero_copy_en, 1);
+	MLX5_SET(tirc, tirc, nvmeotcp_tag_buffer_table_id, tag_buf_id);
+	MLX5_SET(tirc, tirc, nvmeotcp_crc_en, !!crc_rx);
+	MLX5_SET(tirc, tirc, self_lb_block,
+		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST |
+		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_MULTICAST);
+}
+
 void mlx5e_tir_builder_build_tls(struct mlx5e_tir_builder *builder)
 {
 	void *tirc = mlx5e_tir_builder_get_tirc(builder);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
index 857a84bcd53a..bdec6931444b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
@@ -35,6 +35,8 @@ void mlx5e_tir_builder_build_rss(struct mlx5e_tir_builder *builder,
 				 bool inner);
 void mlx5e_tir_builder_build_direct(struct mlx5e_tir_builder *builder);
 void mlx5e_tir_builder_build_tls(struct mlx5e_tir_builder *builder);
+void mlx5e_tir_builder_build_nvmeotcp(struct mlx5e_tir_builder *builder, bool crc_rx,
+				      u32 tag_buf_id);
 
 struct mlx5_core_dev;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 8e437d98565a..caab4cbf49f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -31,6 +31,7 @@ enum mlx5e_icosq_wqe_type {
 #endif
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 	MLX5E_ICOSQ_WQE_UMR_NVMEOTCP,
+	MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP,
 #endif
 };
 
@@ -179,6 +180,11 @@ struct mlx5e_icosq_wqe_info {
 		struct {
 			struct mlx5e_ktls_rx_resync_buf *buf;
 		} tls_get_params;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+		struct {
+			struct mlx5e_nvmeotcp_queue *queue;
+		} nvmeotcp_q;
 #endif
 	};
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 30c0a50f5dac..9c4bbbd00cab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -3,6 +3,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/idr.h>
+#include <linux/nvme-tcp.h>
 #include "en_accel/nvmeotcp.h"
 #include "en_accel/nvmeotcp_utils.h"
 #include "en_accel/fs_tcp.h"
@@ -11,6 +12,11 @@
 #define MAX_NUM_NVMEOTCP_QUEUES	(512)
 #define MIN_NUM_NVMEOTCP_QUEUES	(1)
 
+/* Max PDU data will be 512K */
+#define MLX5E_NVMEOTCP_MAX_SEGMENTS (128)
+#define MLX5E_NVMEOTCP_IO_THRESHOLD (32 * 1024)
+#define MLX5E_NVMEOTCP_FULL_CCID_RANGE (0)
+
 static const struct rhashtable_params rhash_queues = {
 	.key_len = sizeof(int),
 	.key_offset = offsetof(struct mlx5e_nvmeotcp_queue, id),
@@ -20,6 +26,93 @@ static const struct rhashtable_params rhash_queues = {
 	.max_size = MAX_NUM_NVMEOTCP_QUEUES,
 };
 
+static u32 mlx5e_get_max_sgl(struct mlx5_core_dev *mdev)
+{
+	return min_t(u32,
+		     MLX5E_NVMEOTCP_MAX_SEGMENTS,
+		     1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size));
+}
+
+static inline u32
+mlx5e_get_channel_ix_from_io_cpu(struct mlx5e_params *params, u32 io_cpu)
+{
+	int num_channels = params->num_channels;
+	u32 channel_ix = io_cpu;
+
+	if (channel_ix >= num_channels)
+		channel_ix = channel_ix % num_channels;
+
+	return channel_ix;
+}
+
+static
+int mlx5e_create_nvmeotcp_tag_buf_table(struct mlx5_core_dev *mdev,
+					struct mlx5e_nvmeotcp_queue *queue,
+					u8 log_table_size)
+{
+	u32 in[MLX5_ST_SZ_DW(create_nvmeotcp_tag_buf_table_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	u64 general_obj_types;
+	void *obj;
+	int err;
+
+	obj = MLX5_ADDR_OF(create_nvmeotcp_tag_buf_table_in, in,
+			   nvmeotcp_tag_buf_table_obj);
+
+	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
+	if (!(general_obj_types &
+	      MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE))
+		return -EINVAL;
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE);
+	MLX5_SET(nvmeotcp_tag_buf_table_obj, obj,
+		 log_tag_buffer_table_size, log_table_size);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		queue->tag_buf_table_id = MLX5_GET(general_obj_out_cmd_hdr,
+						   out, obj_id);
+	return err;
+}
+
+static
+void mlx5_destroy_nvmeotcp_tag_buf_table(struct mlx5_core_dev *mdev, u32 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, uid);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+static void
+fill_nvmeotcp_bsf_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe *wqe,
+			  u16 ccid, u32 klm_entries, u16 klm_offset)
+{
+	u32 lkey, i;
+
+	/* BSF_KLM_UMR is used to update the tag_buffer. To spare the need to update both mkc.length
+	 * and tag_buffer[i].len in two different UMRs we initialize the tag_buffer[*].len to the
+	 * maximum size of an entry so the HW check will pass and the validity of the MKEY len will
+	 * be checked against the updated mkey context field.
+	 */
+	for (i = 0; i < klm_entries; i++) {
+		lkey = queue->ccid_table[i + klm_offset].klm_mkey;
+
+		wqe->inline_klms[i].bcount = cpu_to_be32(U32_MAX);
+		wqe->inline_klms[i].key = cpu_to_be32(lkey);
+		wqe->inline_klms[i].va = 0;
+	}
+}
+
 static void
 fill_nvmeotcp_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe *wqe, u16 ccid,
 		      u32 klm_entries, u16 klm_offset)
@@ -73,18 +166,149 @@ build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe
 	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
 	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, MLX5_UMR_KLM_ALIGNMENT));
 	ucseg->xlt_offset = cpu_to_be16(klm_offset);
-	fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset);
+	if (klm_type == BSF_KLM_UMR)
+		fill_nvmeotcp_bsf_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset);
+	else
+		fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset);
+}
+
+static void
+fill_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
+			      struct mlx5_seg_nvmeotcp_progress_params *params,
+			      u32 seq)
+{
+	void *ctx = params->ctx;
+
+	params->tir_num = cpu_to_be32(mlx5e_tir_get_tirn(&queue->tir));
+
+	MLX5_SET(nvmeotcp_progress_params, ctx, next_pdu_tcp_sn, seq);
+	MLX5_SET(nvmeotcp_progress_params, ctx, pdu_tracker_state,
+		 MLX5E_NVMEOTCP_PROGRESS_PARAMS_PDU_TRACKER_STATE_START);
+}
+
+void
+build_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
+			       struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe,
+			       u32 seq)
+{
+	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
+	u32 sqn = queue->sq.sqn;
+	u16 pc = queue->sq.pc;
+	u8 opc_mod;
+
+	memset(wqe, 0, MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ);
+	opc_mod = MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_PROGRESS_PARAMS;
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_SET_PSV | (opc_mod << 24));
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+				   PROGRESS_PARAMS_DS_CNT);
+	fill_nvmeotcp_progress_params(queue, &wqe->params, seq);
 }
 
 static void
-mlx5e_nvmeotcp_fill_wi(struct mlx5e_icosq *sq, u32 wqebbs, u16 pi)
+fill_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
+			    struct mlx5_wqe_transport_static_params_seg *params,
+			    u32 resync_seq, bool ddgst_offload_en)
+{
+	void *ctx = params->ctx;
+
+	MLX5_SET(transport_static_params, ctx, const_1, 1);
+	MLX5_SET(transport_static_params, ctx, const_2, 2);
+	MLX5_SET(transport_static_params, ctx, acc_type,
+		 MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP);
+	MLX5_SET(transport_static_params, ctx, nvme_resync_tcp_sn, resync_seq);
+	MLX5_SET(transport_static_params, ctx, pda, queue->pda);
+	MLX5_SET(transport_static_params, ctx, ddgst_en,
+		 !!(queue->dgst & NVME_TCP_DATA_DIGEST_ENABLE));
+	MLX5_SET(transport_static_params, ctx, ddgst_offload_en, ddgst_offload_en);
+	MLX5_SET(transport_static_params, ctx, hddgst_en,
+		 !!(queue->dgst & NVME_TCP_HDR_DIGEST_ENABLE));
+	MLX5_SET(transport_static_params, ctx, hdgst_offload_en, 0);
+	MLX5_SET(transport_static_params, ctx, ti,
+		 MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR);
+	MLX5_SET(transport_static_params, ctx, const1, 1);
+	MLX5_SET(transport_static_params, ctx, zero_copy_en, 1);
+}
+
+void
+build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
+			     struct mlx5e_set_transport_static_params_wqe *wqe,
+			     u32 resync_seq, bool crc_rx)
+{
+	u8 opc_mod = MLX5_OPC_MOD_TRANSPORT_TIR_STATIC_PARAMS;
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg      *cseg = &wqe->ctrl;
+	u32 sqn = queue->sq.sqn;
+	u16 pc = queue->sq.pc;
+
+	memset(wqe, 0, MLX5E_TRANSPORT_STATIC_PARAMS_WQE_SZ);
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_UMR | (opc_mod) << 24);
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+				   MLX5E_TRANSPORT_STATIC_PARAMS_DS_CNT);
+	cseg->imm = cpu_to_be32(mlx5e_tir_get_tirn(&queue->tir)
+				<< MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
+
+	ucseg->flags = MLX5_UMR_INLINE;
+	ucseg->bsf_octowords = cpu_to_be16(MLX5E_TRANSPORT_STATIC_PARAMS_OCTWORD_SIZE);
+	fill_nvmeotcp_static_params(queue, &wqe->params, resync_seq, crc_rx);
+}
+
+static void
+mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
+		       struct mlx5e_icosq *sq, u32 wqebbs, u16 pi,
+		       enum wqe_type type)
 {
 	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
 
 	memset(wi, 0, sizeof(*wi));
 
 	wi->num_wqebbs = wqebbs;
-	wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVMEOTCP;
+	switch (type) {
+	case SET_PSV_UMR:
+		wi->wqe_type = MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP;
+		wi->nvmeotcp_q.queue = nvmeotcp_queue;
+		break;
+	default:
+		/* cases where no further action is required upon completion, such as ddp setup */
+		wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVMEOTCP;
+		break;
+	}
+}
+
+static void
+mlx5e_nvmeotcp_rx_post_static_params_wqe(struct mlx5e_nvmeotcp_queue *queue, u32 resync_seq)
+{
+	struct mlx5e_set_transport_static_params_wqe *wqe;
+	struct mlx5e_icosq *sq = &queue->sq;
+	u16 pi, wqebbs;
+
+	spin_lock_bh(&queue->sq_lock);
+	wqebbs = MLX5E_TRANSPORT_SET_STATIC_PARAMS_WQEBBS;
+	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
+	wqe = MLX5E_TRANSPORT_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqebbs, pi, BSF_UMR);
+	build_nvmeotcp_static_params(queue, wqe, resync_seq, queue->crc_rx);
+	sq->pc += wqebbs;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+	spin_unlock_bh(&queue->sq_lock);
+}
+
+static void
+mlx5e_nvmeotcp_rx_post_progress_params_wqe(struct mlx5e_nvmeotcp_queue *queue, u32 seq)
+{
+	struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe;
+	struct mlx5e_icosq *sq = &queue->sq;
+	u16 pi, wqebbs;
+
+	wqebbs = MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQEBBS;
+	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_PROGRESS_PARAMS_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, SET_PSV_UMR);
+	build_nvmeotcp_progress_params(queue, wqe, seq);
+	sq->pc += wqebbs;
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
 }
 
 static u32
@@ -104,7 +328,7 @@ post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	wqebbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
 	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(sq, wqebbs, pi);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, wqe_type);
 	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, klm_offset,
 			       klm_length, wqe_type);
 	sq->pc += wqebbs;
@@ -134,11 +358,239 @@ mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, enum wqe_type wq
 	spin_unlock_bh(&queue->sq_lock);
 }
 
+static int mlx5e_create_nvmeotcp_mkey(struct mlx5_core_dev *mdev, u8 access_mode,
+				      u32 translation_octword_size, u32 *mkey)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	void *mkc;
+	u32 *in;
+	int err;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, free, 1);
+	MLX5_SET(mkc, mkc, translations_octword_size, translation_octword_size);
+	MLX5_SET(mkc, mkc, umr_en, 1);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, lr, 1);
+	MLX5_SET(mkc, mkc, access_mode_1_0, access_mode);
+
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
+
+	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
+
+	kvfree(in);
+	return err;
+}
+
 static int
 mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
 			      struct ulp_ddp_limits *ulp_limits)
 {
+	struct nvme_tcp_ddp_limits *limits = (struct nvme_tcp_ddp_limits *)ulp_limits;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+
+	ulp_limits->offload_capabilities = ULP_DDP_C_NVME_TCP | ULP_DDP_C_NVME_TCP_DDGST_RX;
+
+	if (ulp_limits->type != ULP_DDP_NVME)
+		return -EOPNOTSUPP;
+
+	limits->lmt.max_ddp_sgl_len = mlx5e_get_max_sgl(mdev);
+	limits->lmt.io_threshold = MLX5E_NVMEOTCP_IO_THRESHOLD;
+	limits->full_ccid_range = MLX5E_NVMEOTCP_FULL_CCID_RANGE;
+	return 0;
+}
+
+static int mlx5e_nvmeotcp_queue_handler_poll(struct napi_struct *napi, int budget)
+{
+	struct mlx5e_nvmeotcp_queue_handler *qh;
+	int work_done;
+
+	qh = container_of(napi, struct mlx5e_nvmeotcp_queue_handler, napi);
+
+	work_done = mlx5e_poll_ico_cq(qh->cq, budget);
+
+	if (work_done == budget || !napi_complete_done(napi, work_done))
+		goto out;
+
+	mlx5e_cq_arm(qh->cq);
+
+out:
+	return work_done;
+}
+
+static void
+mlx5e_nvmeotcp_destroy_icosq(struct mlx5e_icosq *sq)
+{
+	mlx5e_close_icosq(sq);
+	mlx5e_close_cq(&sq->cq);
+}
+
+static void mlx5e_nvmeotcp_icosq_err_cqe_work(struct work_struct *recover_work)
+{
+	struct mlx5e_icosq *sq = container_of(recover_work, struct mlx5e_icosq, recover_work);
+
+	/* Not implemented yet. */
+
+	netdev_warn(sq->channel->netdev, "nvmeotcp icosq recovery is not implemented\n");
+}
+
+static int
+mlx5e_nvmeotcp_build_icosq(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_priv *priv, int io_cpu)
+{
+	u16 max_sgl, max_klm_per_wqe, max_umr_per_ccid, sgl_rest, wqebbs_rest;
+	struct mlx5e_channel *c = priv->channels.c[queue->channel_ix];
+	struct mlx5e_sq_param icosq_param = {};
+	struct mlx5e_create_cq_param ccp = {};
+	struct dim_cq_moder icocq_moder = {};
+	struct mlx5e_icosq *icosq;
+	int err = -ENOMEM;
+	u16 log_icosq_sz;
+	u32 max_wqebbs;
+
+	icosq = &queue->sq;
+	max_sgl = mlx5e_get_max_sgl(priv->mdev);
+	max_klm_per_wqe = queue->max_klms_per_wqe;
+	max_umr_per_ccid = max_sgl / max_klm_per_wqe;
+	sgl_rest = max_sgl % max_klm_per_wqe;
+	wqebbs_rest = sgl_rest ? MLX5E_KLM_UMR_WQEBBS(sgl_rest) : 0;
+	max_wqebbs = (MLX5E_KLM_UMR_WQEBBS(max_klm_per_wqe) *
+		     max_umr_per_ccid + wqebbs_rest) * queue->size;
+	log_icosq_sz = order_base_2(max_wqebbs);
+
+	mlx5e_build_icosq_param(priv->mdev, log_icosq_sz, &icosq_param);
+	ccp.napi = &queue->qh.napi;
+	ccp.ch_stats = &priv->channel_stats[queue->channel_ix]->ch;
+	ccp.node = cpu_to_node(io_cpu);
+	ccp.ix = queue->channel_ix;
+
+	err = mlx5e_open_cq(priv, icocq_moder, &icosq_param.cqp, &ccp, &icosq->cq);
+	if (err)
+		goto err_nvmeotcp_sq;
+	err = mlx5e_open_icosq(c, &priv->channels.params, &icosq_param, icosq,
+			       mlx5e_nvmeotcp_icosq_err_cqe_work);
+	if (err)
+		goto close_cq;
+
+	spin_lock_init(&queue->sq_lock);
 	return 0;
+
+close_cq:
+	mlx5e_close_cq(&icosq->cq);
+err_nvmeotcp_sq:
+	return err;
+}
+
+static void
+mlx5e_nvmeotcp_destroy_rx(struct mlx5e_priv *priv, struct mlx5e_nvmeotcp_queue *queue,
+			  struct mlx5_core_dev *mdev)
+{
+	int i;
+
+	mlx5e_accel_fs_del_sk(queue->fh);
+
+	for (i = 0; i < queue->size; i++)
+		mlx5_core_destroy_mkey(mdev, queue->ccid_table[i].klm_mkey);
+
+	mlx5e_tir_destroy(&queue->tir);
+	mlx5_destroy_nvmeotcp_tag_buf_table(mdev, queue->tag_buf_table_id);
+
+	mlx5e_deactivate_icosq(&queue->sq);
+	napi_disable(&queue->qh.napi);
+	mlx5e_nvmeotcp_destroy_icosq(&queue->sq);
+	netif_napi_del(&queue->qh.napi);
+}
+
+static int
+mlx5e_nvmeotcp_queue_rx_init(struct mlx5e_nvmeotcp_queue *queue,
+			     struct nvme_tcp_ddp_config *config,
+			     struct net_device *netdev)
+{
+	u8 log_queue_size = order_base_2(config->queue_size);
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct sock *sk = queue->sk;
+	int err, max_sgls, i;
+
+	if (config->queue_size >
+	    BIT(MLX5_CAP_DEV_NVMEOTCP(mdev, log_max_nvmeotcp_tag_buffer_size)))
+		return -EINVAL;
+
+	err = mlx5e_create_nvmeotcp_tag_buf_table(mdev, queue, log_queue_size);
+	if (err)
+		return err;
+
+	queue->qh.cq = &queue->sq.cq;
+	netif_napi_add(priv->netdev, &queue->qh.napi, mlx5e_nvmeotcp_queue_handler_poll);
+
+	mutex_lock(&priv->state_lock);
+	err = mlx5e_nvmeotcp_build_icosq(queue, priv, config->io_cpu);
+	mutex_unlock(&priv->state_lock);
+	if (err)
+		goto del_napi;
+
+	napi_enable(&queue->qh.napi);
+	mlx5e_activate_icosq(&queue->sq);
+
+	/* initializes queue->tir */
+	err = mlx5e_rx_res_nvmeotcp_tir_create(priv->rx_res, queue->channel_ix, queue->crc_rx,
+					       queue->tag_buf_table_id, &queue->tir);
+	if (err)
+		goto destroy_icosq;
+
+	mlx5e_nvmeotcp_rx_post_static_params_wqe(queue, 0);
+	mlx5e_nvmeotcp_rx_post_progress_params_wqe(queue, tcp_sk(sk)->copied_seq);
+
+	queue->ccid_table = kcalloc(queue->size, sizeof(struct mlx5e_nvmeotcp_queue_entry),
+				    GFP_KERNEL);
+	if (!queue->ccid_table) {
+		err = -ENOMEM;
+		goto destroy_tir;
+	}
+
+	max_sgls = mlx5e_get_max_sgl(mdev);
+	for (i = 0; i < queue->size; i++) {
+		err = mlx5e_create_nvmeotcp_mkey(mdev, MLX5_MKC_ACCESS_MODE_KLMS, max_sgls,
+						 &queue->ccid_table[i].klm_mkey);
+		if (err)
+			goto free_ccid_table;
+	}
+
+	mlx5e_nvmeotcp_post_klm_wqe(queue, BSF_KLM_UMR, 0, queue->size);
+
+	if (!(WARN_ON(!wait_for_completion_timeout(&queue->static_params_done,
+						   msecs_to_jiffies(3000)))))
+		queue->fh = mlx5e_accel_fs_add_sk(priv->fs, sk, mlx5e_tir_get_tirn(&queue->tir),
+						  queue->id);
+
+	if (IS_ERR_OR_NULL(queue->fh)) {
+		err = -EINVAL;
+		goto destroy_mkeys;
+	}
+
+	return 0;
+
+destroy_mkeys:
+	while ((i--))
+		mlx5_core_destroy_mkey(mdev, queue->ccid_table[i].klm_mkey);
+free_ccid_table:
+	kfree(queue->ccid_table);
+destroy_tir:
+	mlx5e_tir_destroy(&queue->tir);
+destroy_icosq:
+	mlx5e_deactivate_icosq(&queue->sq);
+	napi_disable(&queue->qh.napi);
+	mlx5e_nvmeotcp_destroy_icosq(&queue->sq);
+del_napi:
+	netif_napi_del(&queue->qh.napi);
+	mlx5_destroy_nvmeotcp_tag_buf_table(mdev, queue->tag_buf_table_id);
+
+	return err;
 }
 
 static int
@@ -146,13 +598,89 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 			  struct sock *sk,
 			  struct ulp_ddp_config *tconfig)
 {
+	struct nvme_tcp_ddp_config *config = (struct nvme_tcp_ddp_config *)tconfig;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_nvmeotcp_queue *queue;
+	int queue_id, err;
+
+	if (tconfig->type != ULP_DDP_NVME) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
+	if (!queue) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	queue_id = ida_simple_get(&priv->nvmeotcp->queue_ids,
+				  MIN_NUM_NVMEOTCP_QUEUES, MAX_NUM_NVMEOTCP_QUEUES,
+				  GFP_KERNEL);
+	if (queue_id < 0) {
+		err = -ENOSPC;
+		goto free_queue;
+	}
+
+	queue->crc_rx = !!(config->dgst & NVME_TCP_DATA_DIGEST_ENABLE);
+	queue->ulp_ddp_ctx.type = ULP_DDP_NVME;
+	queue->sk = sk;
+	queue->id = queue_id;
+	queue->dgst = config->dgst;
+	queue->pda = config->cpda;
+	queue->channel_ix = mlx5e_get_channel_ix_from_io_cpu(&priv->channels.params,
+							     config->io_cpu);
+	queue->size = config->queue_size;
+	queue->max_klms_per_wqe = MLX5E_MAX_KLM_PER_WQE(mdev);
+	queue->priv = priv;
+	init_completion(&queue->static_params_done);
+
+	err = mlx5e_nvmeotcp_queue_rx_init(queue, config, netdev);
+	if (err)
+		goto remove_queue_id;
+
+	err = rhashtable_insert_fast(&priv->nvmeotcp->queue_hash, &queue->hash,
+				     rhash_queues);
+	if (err)
+		goto destroy_rx;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	ulp_ddp_set_ctx(sk, queue);
+	write_unlock_bh(&sk->sk_callback_lock);
+	refcount_set(&queue->ref_count, 1);
 	return 0;
+
+destroy_rx:
+	mlx5e_nvmeotcp_destroy_rx(priv, queue, mdev);
+remove_queue_id:
+	ida_simple_remove(&priv->nvmeotcp->queue_ids, queue_id);
+free_queue:
+	kfree(queue);
+out:
+	return err;
 }
 
 static void
 mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 			      struct sock *sk)
 {
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_nvmeotcp_queue *queue;
+
+	queue = container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+
+	WARN_ON(refcount_read(&queue->ref_count) != 1);
+	mlx5e_nvmeotcp_destroy_rx(priv, queue, mdev);
+
+	rhashtable_remove_fast(&priv->nvmeotcp->queue_hash, &queue->hash,
+			       rhash_queues);
+	ida_simple_remove(&priv->nvmeotcp->queue_ids, queue->id);
+	write_lock_bh(&sk->sk_callback_lock);
+	ulp_ddp_set_ctx(sk, NULL);
+	write_unlock_bh(&sk->sk_callback_lock);
+	mlx5e_nvmeotcp_put_queue(queue);
 }
 
 static int
@@ -171,6 +699,13 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	return 0;
 }
 
+void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi)
+{
+	struct mlx5e_nvmeotcp_queue *queue = wi->nvmeotcp_q.queue;
+
+	complete(&queue->static_params_done);
+}
+
 static int
 mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 			    struct sock *sk,
@@ -195,6 +730,26 @@ static const struct ulp_ddp_dev_ops mlx5e_nvmeotcp_ops = {
 	.ulp_ddp_resync = mlx5e_nvmeotcp_ddp_resync,
 };
 
+struct mlx5e_nvmeotcp_queue *
+mlx5e_nvmeotcp_get_queue(struct mlx5e_nvmeotcp *nvmeotcp, int id)
+{
+	struct mlx5e_nvmeotcp_queue *queue;
+
+	queue = rhashtable_lookup_fast(&nvmeotcp->queue_hash,
+				       &id, rhash_queues);
+	if (!IS_ERR_OR_NULL(queue))
+		refcount_inc(&queue->ref_count);
+	return queue;
+}
+
+void mlx5e_nvmeotcp_put_queue(struct mlx5e_nvmeotcp_queue *queue)
+{
+	if (refcount_dec_and_test(&queue->ref_count)) {
+		kfree(queue->ccid_table);
+		kfree(queue);
+	}
+}
+
 int set_feature_nvme_tcp(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index ef24dbd7a1c8..02073624e0d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -105,6 +105,10 @@ void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv);
 int mlx5e_nvmeotcp_init(struct mlx5e_priv *priv);
 int set_feature_nvme_tcp(struct net_device *netdev, bool enable);
 void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv);
+struct mlx5e_nvmeotcp_queue *
+mlx5e_nvmeotcp_get_queue(struct mlx5e_nvmeotcp *nvmeotcp, int id);
+void mlx5e_nvmeotcp_put_queue(struct mlx5e_nvmeotcp_queue *queue);
+void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi);
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
 #else
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
index c7b176577167..0439de20b69d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -4,6 +4,35 @@
 #define __MLX5E_NVMEOTCP_UTILS_H__
 
 #include "en.h"
+#include "en_accel/nvmeotcp.h"
+#include "en_accel/common_utils.h"
+
+enum {
+	MLX5E_NVMEOTCP_PROGRESS_PARAMS_PDU_TRACKER_STATE_START     = 0,
+	MLX5E_NVMEOTCP_PROGRESS_PARAMS_PDU_TRACKER_STATE_TRACKING  = 1,
+	MLX5E_NVMEOTCP_PROGRESS_PARAMS_PDU_TRACKER_STATE_SEARCHING = 2,
+};
+
+struct mlx5_seg_nvmeotcp_progress_params {
+	__be32 tir_num;
+	u8     ctx[MLX5_ST_SZ_BYTES(nvmeotcp_progress_params)];
+};
+
+struct mlx5e_set_nvmeotcp_progress_params_wqe {
+	struct mlx5_wqe_ctrl_seg            ctrl;
+	struct mlx5_seg_nvmeotcp_progress_params params;
+};
+
+/* macros for wqe handling */
+#define MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ \
+	(sizeof(struct mlx5e_set_nvmeotcp_progress_params_wqe))
+
+#define MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQEBBS \
+	(DIV_ROUND_UP(MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ, MLX5_SEND_WQE_BB))
+
+#define MLX5E_NVMEOTCP_FETCH_PROGRESS_PARAMS_WQE(sq, pi) \
+	((struct mlx5e_set_nvmeotcp_progress_params_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_set_nvmeotcp_progress_params_wqe)))
 
 #define MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi) \
 	((struct mlx5e_umr_wqe *)\
@@ -14,6 +43,9 @@
 #define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_TIR_PARAMS 0x2
 #define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR 0x0
 
+#define PROGRESS_PARAMS_DS_CNT \
+	DIV_ROUND_UP(MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQE_SZ, MLX5_SEND_WQE_DS)
+
 enum wqe_type {
 	KLM_UMR,
 	BSF_KLM_UMR,
@@ -22,4 +54,13 @@ enum wqe_type {
 	KLM_INV_UMR,
 };
 
+void
+build_nvmeotcp_progress_params(struct mlx5e_nvmeotcp_queue *queue,
+			       struct mlx5e_set_nvmeotcp_progress_params_wqe *wqe, u32 seq);
+
+void
+build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
+			     struct mlx5e_set_transport_static_params_wqe *wqe,
+			     u32 resync_seq, bool crc_rx);
+
 #endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 971d13ffbc8d..e052606447cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1731,9 +1731,9 @@ void mlx5e_tx_err_cqe_work(struct work_struct *recover_work)
 	mlx5e_reporter_tx_err_cqe(sq);
 }
 
-static int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
-			    struct mlx5e_sq_param *param, struct mlx5e_icosq *sq,
-			    work_func_t recover_work_func)
+int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
+		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq,
+		     work_func_t recover_work_func)
 {
 	struct mlx5e_create_sq_param csp = {};
 	int err;
@@ -1777,7 +1777,7 @@ void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 	synchronize_net(); /* Sync with NAPI. */
 }
 
-static void mlx5e_close_icosq(struct mlx5e_icosq *sq)
+void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 {
 	if (sq->ktls_resync)
 		mlx5e_ktls_rx_resync_destroy_resp_list(sq->ktls_resync);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 039eeb3b3e45..f307dc793570 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -53,6 +53,7 @@
 #include "en_accel/macsec.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ktls_txrx.h"
+#include "en_accel/nvmeotcp.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/health.h"
@@ -817,16 +818,23 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
 		ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 		wi = &sq->db.wqe_info[ci];
 		sqcc += wi->num_wqebbs;
-#ifdef CONFIG_MLX5_EN_TLS
 		switch (wi->wqe_type) {
+#ifdef CONFIG_MLX5_EN_TLS
 		case MLX5E_ICOSQ_WQE_SET_PSV_TLS:
 			mlx5e_ktls_handle_ctx_completion(wi);
 			break;
 		case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
 			mlx5e_ktls_handle_get_psv_completion(wi, sq);
 			break;
-		}
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+		case MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP:
+			mlx5e_nvmeotcp_ctx_complete(wi);
+			break;
+#endif
+		default:
+			break;
+		}
 	}
 	sq->cc = sqcc;
 }
@@ -925,6 +933,9 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 			case MLX5E_ICOSQ_WQE_UMR_NVMEOTCP:
 				break;
+			case MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP:
+				mlx5e_nvmeotcp_ctx_complete(wi);
+				break;
 #endif
 			default:
 				netdev_WARN_ONCE(cq->netdev,
-- 
2.31.1

