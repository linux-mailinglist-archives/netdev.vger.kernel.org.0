Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9BE66E275
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjAQPkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbjAQPkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:40:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CEF4392E
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:38:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YD9unuRT67wTIL1sbG0tfs6MZgMJpibdHW6JwxH+bVztAwF24SEC4YSeMAYKKVAjEqFdhV6gQ8BYjFTurIQYPBbECLbSBiq5A1gximdMjUThKlAYVbzZBwVfVGmD6+6uWeVQDLotSROBGEzGO8aDyG0gMbm8PeGW9hAiTMVMqFhQwLyb9WgGHbiEwnszUaJaOQsSIU8MjSm2XxIp9/cNNo/v5eo3jScFnX6TonE2+3aPCOognkPTbfCSnFMOHo200StXz/hbYiucZrt75QrnUqR7/LlHkv+pTv6nktIBF/R8PnxGE9PlqMiSf97lpCKAyBwvJmbUqSBfMSJJopPdqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frZ8+7cWKtArgmDeA3M3gyIsxjFNZwS0sSpJ1ht1F0k=;
 b=QffsnVMvHDSFz/wB8aMQnAzEkExhSKzTH6yLaCsc7X5eqEcPnPj4kpEbb3az/jyzO4ovmC6Nq9J0/O2on6oulYZmZL5/CuYDMlP47Jpo3W8auo3CES49/81mi1vu0rtVUiAyemOg8oKuFezpnH8LSyMmYtATP/YoEdB85VWEemkcn6CMlmPdLbgyFq0fUEEUKFav44V46q2OJls6/u2qfH2xJEhHcFFC2BWx18WqN+ljuORZXNFHMooPK+oItIK5qgnhXfotQwE+l+uLRwv80v+MS/wvZ4IooIdTJaNPFNC3HgDezpT2YdnrQshvZYC1PUbo4DabCwY3YNkbIcB4Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frZ8+7cWKtArgmDeA3M3gyIsxjFNZwS0sSpJ1ht1F0k=;
 b=GoGr7wyZA1D8PIt3etbl8n0oWBLZbmc2ebPXrxDxZyv6F5WUx/Nyzz0+S3IwQ/48qk59rX0r42OgEBLp4F1zAu2BJ7oZqYrmI3MIst1XCjE8R1qftvEJmhY2GimntHR32G2WpET35esf95GO3CbrjO0rRWI4ENALdNzm8stUlZqSAfS6QXJL3GxMrDIH2YTeoTJEjWkJouYzoa1B7NHzeEYH/xVGuyOVxW9pA5qEKhi+Ne5kHAbK2xzvljdZJ6gAu22rbcxQOYYkAbAcC44VNmFdyqWJaXO05KEJwt9FLPQxFBhEWQmbpxPdDXAkaQ3/4ATgt5uPUOLyFRDpEHRiqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:37:59 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:37:59 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: [PATCH v9 19/25] net/mlx5e: TCP flow steering for nvme-tcp acceleration
Date:   Tue, 17 Jan 2023 17:35:29 +0200
Message-Id: <20230117153535.1945554-20-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0125.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: c7acd9bc-1609-4f34-4c36-08daf8a0cfa2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EY8WBuYmdhjqlq73vRHGI+gNKQb1HUY/hSwPz7WlfbsnsZVppAvwqlNA3mEOj9MNePCW2Ci3b1Za/U+JJh1RPfmCc1bD9O5O+NXytGWNtQBcQEkAWZHB/T6/EXb9iaa3+ekz7+lNDaIsoQYVbxCR6ReU4yPnzaKpgDR424cHLOBB8L/mumfo5stmynBV0Tyfr2KI7pOosRXJEvvUyXazFOZK5QRJBtMe2PEpNxjLQVUhJsgd2F4cMJlRPna6CviyMvJwoJFoxf/9EynsteQ1E9eJA0O/Pkms7GP9HgV2Qj3rZ2KD4QnCBrQLElfYN2BbbNgtKpr8AM1tTl+UnMYn75zikcD3nHej7GWQYxCuv0aXyZYiFlDLnAimXLxWm7n4VE3N9IiVRUNpXcYi62B4rWUNpdAK3qrZNX+xwIhKq137NF1pDFbAMhhwWvlJkGIXaA3+6kSSPYCt1SiTj/7zqegLQJ2zv08fmQRHW9hktTjzmCRQEGrdq+azyeR5eFv8rdd5ZEhk+UVJiS0j8IIDzNVe9fUDCXPn2mkTQn+PQY6IcK+JLkbD69rRF4C4Hph3CIPZANRVFdIgVF/CtNiL16z/NPgTtbWTIVdv4rVR5LBMojs8/bY9akmobxJzhOOCcjLq+lx5Sjdn6BLYlv6cKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(1076003)(186003)(6512007)(26005)(2906002)(86362001)(8676002)(66946007)(66476007)(8936002)(6486002)(66556008)(6506007)(38100700002)(6666004)(478600001)(36756003)(107886003)(5660300002)(54906003)(316002)(2616005)(41300700001)(4326008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zx8O3tFHQtVQqzeq81XtQPoBe3vh0iBNP3O3jLOra7Low4BM36+WBhJoKpMT?=
 =?us-ascii?Q?shOH841fVkI6Vdyxt3Aex2+vq6J6DZ7YPO3XD1o7nClE8XtfIKgr2zmh2jzt?=
 =?us-ascii?Q?DMFEWWRDN//24jtMGeuX0ZR+uM8dSAJ9tr1nFzGAmEl4nwyqG6CN1VOGiGzn?=
 =?us-ascii?Q?b6jCuh6MSX+HmHHQuRTXtz/wka2RdFstD4YMigBFvnbzsJ0oanjWILZ+O5xZ?=
 =?us-ascii?Q?Z8OtyQbYqZ6/vIMtoL23Mj6a3wWo80wWzcrRCq0T4vlzgFZrrb0SwMIfXXTE?=
 =?us-ascii?Q?8twz2ZB7FdhAmhxyozycpHxtt4qjkhJ9QD45rF125QWKCJ/zUTUeYGa5xwu1?=
 =?us-ascii?Q?sjAST4Wk630k5orBOek+u44PMsiTBh1vwoZPX19ZCBSfN251CTzP9N6euKYt?=
 =?us-ascii?Q?QJh0787lvQxyYVGoKMzc6JtmZ2lWOcMronOYW3/NsEP1Oxsc/CAkhNAcjd+X?=
 =?us-ascii?Q?s0Yd9iTWXPV3Jr3p+/m8quTjPFjlpp0sxFOl5KNnn9CunfW0D5sp7LiMLxII?=
 =?us-ascii?Q?BTZpspftM9P+TL62Q6ZSpG6TT7IA8dmL1wWd88Ol96VasgM1Kbb8zofnPrFf?=
 =?us-ascii?Q?ZUnaSewx1cm2BBZYMYUNY0lVd6IzaG9fhIj9mhp09Oo/PlszPsnwqayLBMuQ?=
 =?us-ascii?Q?NH+c0Co3ZibkbE9u5ind5C3mOwXVrbIT/pHNGmX4yGaFZfmn6fN8jrGs/k/q?=
 =?us-ascii?Q?d5wC9wXsDVuA0HH93HGr8PMsWo4094620WQ1AoLEriCkYxGy6O3Gtpg4y0Qq?=
 =?us-ascii?Q?a3bV8wDKsQ/5zlyzrO/dlIsdAWyT6Rmi/a5UQXx4728fV/4p39wGMcUraGrC?=
 =?us-ascii?Q?IA9QvE+GZ2/8bZ1E6mxzxvTVammKCx0CIP2eOImGgKyKQ56JeLY0XsK0hVvz?=
 =?us-ascii?Q?3iit2Jb71AdJqT+P07Ktq8DNx7cHXVO4EslYOS96TfR4a+4MnD4CVUjEzBbH?=
 =?us-ascii?Q?NqTuG9jBE1ZgWEQUKrIRjbfq1DL7r8nmEsfFoipY30hYTzzj16fDGWw8EedY?=
 =?us-ascii?Q?6JO409Ykteow1sDTjPr4niw/mT3sSw7ipbui0EttbRYqe+p853V5osEnJcCD?=
 =?us-ascii?Q?VjaBTW+AU3iHG72UOJGlFI93wHOD52CdDFjHeFwyYLK0SjsVRcF68Ak+u5m2?=
 =?us-ascii?Q?g6OaUcLgrl47JYkB2xAf1VFR1weXlFLWGIyaGu0lLh4H8gt2sVbAUSoXorF3?=
 =?us-ascii?Q?IZRIPMl63fPLxHquFig1nW4t26/7R3txa9UDI/RcosRgWH7zpM+wDO1kfnts?=
 =?us-ascii?Q?2ccxBCYPHHZtV8UMzBhpBspXJnBe3btCpQrs0qPbiFP87qvkX3bDK/rmKNAT?=
 =?us-ascii?Q?mNApTC2Go6ztSWIOG1wFCF6VsYAzWFEvx3/P5YPFSlY35yUJMM4QZ3HVTJX0?=
 =?us-ascii?Q?gws+E8y8Xxs/MO16ArXm0Kzp5+1dJLLT/9B1DKBvso6z1Hh9fbmv92eGRWTq?=
 =?us-ascii?Q?oF5R2XUDQqCIah5qGfeDr2zfKyxVCHSkalrNwZ6thD29w1Vggoob0HCPVJat?=
 =?us-ascii?Q?wPvoKYeEBx6l1YNMxzkBRY/qbk7gf2FHDoIlnLqmAxjXNs+zF7tTr3OS3ne4?=
 =?us-ascii?Q?ZLeOenCV1jew+gPWkBoyBO67pfOprunvpLBIgi0w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7acd9bc-1609-4f34-4c36-08daf8a0cfa2
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:37:59.0040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J1zGjcL3uTjNzlSkyxTNBRexRl8ve1Do1IfeU5PK6U4bUWRZy5z6JCORJrzXh/pKdF+nFl/9DBM/Vz8djmhWNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8177
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@nvidia.com>

Both nvme-tcp and tls acceleration require tcp flow steering.
Add reference counter to share TCP flow steering structure.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c    | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 88a5aed9d678..29152d6e80d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -14,6 +14,7 @@ enum accel_fs_tcp_type {
 struct mlx5e_accel_fs_tcp {
 	struct mlx5e_flow_table tables[ACCEL_FS_TCP_NUM_TYPES];
 	struct mlx5_flow_handle *default_rules[ACCEL_FS_TCP_NUM_TYPES];
+	refcount_t user_count;
 };
 
 static enum mlx5_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
@@ -360,6 +361,9 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 	if (!accel_tcp)
 		return;
 
+	if (!refcount_dec_and_test(&accel_tcp->user_count))
+		return;
+
 	accel_fs_tcp_disable(fs);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
@@ -371,12 +375,17 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 
 int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_accel_fs_tcp *accel_tcp;
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(fs);
 	int i, err;
 
 	if (!MLX5_CAP_FLOWTABLE_NIC_RX(mlx5e_fs_get_mdev(fs), ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
+	if (accel_tcp) {
+		refcount_inc(&accel_tcp->user_count);
+		return 0;
+	}
+
 	accel_tcp = kzalloc(sizeof(*accel_tcp), GFP_KERNEL);
 	if (!accel_tcp)
 		return -ENOMEM;
@@ -392,6 +401,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 	if (err)
 		goto err_destroy_tables;
 
+	refcount_set(&accel_tcp->user_count, 1);
 	return 0;
 
 err_destroy_tables:
-- 
2.31.1

