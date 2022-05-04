Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7676D51972C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344819AbiEDGHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344824AbiEDGHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:07:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569001D309
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrP6nlo+Q08Jr//BYobCYPN2sdUrLKIcUz2mDiZ3eYLcdUXLX8eqhNEnjp9JaWNc139lt0TD8tOqPHoCRkeKcO5JLO+Q9mJ5lAJf8LdAFXKgU4wTjCD8jscG8J5rZG4QCBF7EZPmhscXzFePZTrUlG/3GyhhwjNu9t6ub1bemx2CWm4CXgbEv2GefnF8eltG29YG6dnTyltrETZGAkyOicQ7qNFtNZUU37g4RCeTyU/zqYqPZv1EuqLB26wgxnrAQF5LcMOXbTNEvr6orhGW6vWoZH4kjTZwYRMlVyIBKJaRVYL/bawKEFpkpiC7+z4HgkHVDTL73HX1e7xbrzcczg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00f95beHBKceekYJbdvflBRc2kn/9pvdAt0tezYr4NY=;
 b=bVNj/zJ1uVEYho0Wrb/jURcu6UzvEzDueuXLoS3l0ayWWbEY73WsvOLGEXl4rStgxuSX9Ih6g6fsLah9ZYJ3I5XckPX1AV6bCmq95dvLYqRYvhr4KltZyKX2rENwU0NcgYtdUURIfIeAaYOoMOaSKIfvUkGEv1BJCQuw/zFg1R7rOGdGTi2D4ZqhSx+fhbSztME0IN9+3NgnMW6ob65DO41PDe3006Pdso4+1mVK2s9FZ7qVQxQzi+Uru05YT45ojhkAbonR78fbCnSIDCYfK4l+Zpj0mEnOS+2eZEBQTPqcPnDK+LQTdBGX0PiM7Q9uw3Y6DPiwGKFVM5bDKpb8mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00f95beHBKceekYJbdvflBRc2kn/9pvdAt0tezYr4NY=;
 b=VXGzVyrEL+Ww5633ch73FjFadkFxTaQn3X1TrKO2YGexBS0hntrUj5KaUFKfX8NeQHGUZZBAJ9SpcSwmgJH30Ye4bTiWSDDoXLWLV4Y/73Uj2/rqkz5p1ty33u2A8pNYDQJIDianZYKFmXxU6zOxrhI4J52FPoqXGdM6UtDPWl0vuT5m2Ki1GM6MhYVJsZawY3Fc6pKETj6MWdLJO2Usq/G9LJOb2G4jfnpjlCVEhlEoOfY3TZaAol33nABGnxCBiUwmVLdoGatMNXgTVnVKUQjKrgqd/VAZ4us1iqAFFQi8mCyzh4YltDdM95rqs0w/qgMz+enhMabDqCc866JxbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:13 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:13 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/17] net/mlx5: Remove not-supported ICV length
Date:   Tue,  3 May 2022 23:02:28 -0700
Message-Id: <20220504060231.668674-15-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0019.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::32) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06d1e63b-57b2-4f6e-6ebe-08da2d93c641
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0006B5B7C63DA158D0A117BFB3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mWP92d1sAfHZqo1Z9nOKG3xefnXSetRlG6BWQ+meVQ8j/fsBRTABXXw9rsNXjYkmKdHgM6UhwFvJITilKp6mqe2rQaqN/aN5qxTFtVVFxqZpuQ0Zpm1hMqlrfN4D/47yUhh9aWC254xUqJd0OjiXHxFj3p9LwVCW99t+JktnFdic/yJaukWrLK5461yb9dAQHxuz3K9KDnwe7RyFHeErZzbuphaakYS21IYI2Vz7AOYtDHPS9g3JMo4DUMBd5fuXjoIlYwgLzCSiYPXt8cnu8wUhFAnVYUbAChUwqZjzYAKm0OWH0Gjs0wWeZkxRSO0annmYk9fSxZ1ZJUPw3AgM0l2FD/Q0jt1DC/mcaRjnQmAm+ijBCaSOlwb9prCdvSemQX2Ks+7t/aIN8nGXWIY8ve5kKLLPY7XDVH4JFNRszael6lEvPpUQB629s1PJwlrSYj94yKUMdTDvMJtcyeJ7MU3tA0JHDD7ivNZm2IqJP5br3QtnvAK2bDvhWurCJXyTHSJK2hQKwxKmh38ME69fhxBCQi1jYSpx0vsLB8Wy1NIvyxPvjBMp5CLMVLcYppsTanHPq9YERONElHbUCemVSYyTt0uMCblMrDZPi9I0kZbibbb3KORUTqfpomJoqFZ82qaE6kYVNcMG7hOHCtYbSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hrYsvavGoZGI127nAPEpuAzBU8ucSJUTPZBu7UOn4uaiUlG06iLhumjdjSnJ?=
 =?us-ascii?Q?PldNuaSmAM0LTmG7N0nXtRxzLEmNO/NSVaoZaOkQWKHUHkfu14cKPlvdHqe7?=
 =?us-ascii?Q?NssvAoViAjJTBsF2fJOaPNqsH0RBW8neC+32xn3IdrWTC3aC7HDhSGN2cSYT?=
 =?us-ascii?Q?/1NwqcCvpuewqxru6b8iaGgZSbyDSeaq8SXVWgrNUc42MpSSwXc9Usfcz9rM?=
 =?us-ascii?Q?w4YVdDrpauFrl0wVU9SWTYpRTi2fl92OG6nvtD5vbKahBlZYbdy31/NoEtsD?=
 =?us-ascii?Q?tzh7ytcgbmC6XoKbpa+PlDB8qHcA2C7JI/De5Ievj3cQHAn1R8y4Ar5fp0Zw?=
 =?us-ascii?Q?l3M4pMLF63HYl8F30XbM8zVtcQIXss0cRNU54zenX/Om+quh6UBAuoOwrLjQ?=
 =?us-ascii?Q?2bA7h1O4Lf9tYMWzYp9sQGaXaD3OyYiZSLCS/YtYnOqCltIB86A8WhcYu4er?=
 =?us-ascii?Q?3O6VVhFWbRMSRZ4zkcXykkgSOe87/vvOyi9GNjnqCRdpshVwkY4smbNqRBuf?=
 =?us-ascii?Q?fsP2EtJXtexq308Aiw45LN82OtEseko2rnkMedh/VFg8eoPxsXzZ+i/NaqpS?=
 =?us-ascii?Q?0v1g6DKCwthrcDmKQTm60DtMWxdZebqvO86vKwycjLhmYWd3bG9noKQCpUOv?=
 =?us-ascii?Q?fz8gkFrexoLnJ70y69PdZd7+FyWDBdjL6GyIRW6Tp/SagzNUIG+Rt4AFIhBr?=
 =?us-ascii?Q?rYkCDtfrlxN6yVmgS5YN9BIM8+Cv6Eku7Ih7bdfsVvxM5y/uQ7phrH7nMdH3?=
 =?us-ascii?Q?lS1xbo3CMuod+pRzaYluu9/idvqyqT/iINyb6Ns9Kx1qQAVUeN0nx8u89K1S?=
 =?us-ascii?Q?YMHLb5VCeDUnDyTQj51+RYtdNC8Nvslywz9o5XT748pVhnN7prbrqmMJQP+L?=
 =?us-ascii?Q?A+5N7szIhSPEFFR0vmS6bEehYpkcgbgV5bLzpq71azeL209b8v/k0iYhx80o?=
 =?us-ascii?Q?JnwDHYbml0Sb/uWvRKpcjAqchw7yF+sfEKNXgYc8zXF1b6Auk5/JI+/jftBn?=
 =?us-ascii?Q?24O960iPWprYXWgcNS5u/H16Cl9VfMDrEhM59Kuh2TNhP2u3OYJ8U1ikpU4f?=
 =?us-ascii?Q?shtBbA/aysWVy19IMWnV0c5MrvwfsaG6Vj8mUpGQg8xUYPZYSBLC4AVZZfOj?=
 =?us-ascii?Q?QpZ17XCcg5BsAvUA4jfC1p/g2kfIzMw2kJg0IgAIlewr5oDywyaWGxuQTqzI?=
 =?us-ascii?Q?pJyW3mG7Lz9WNEc4q0GSwXF6X/cNMySBnDZVoql+Tpa4veTxhYAvHjMYDHR+?=
 =?us-ascii?Q?RJMmSbXYQsgv3CEfwR3hbNo8IIc7UbEKlVVauu3v6+mkfyT+aquZLooZ9PNa?=
 =?us-ascii?Q?5uZqSQyFChw44PWH0lI+k5Gvenyuh0Jy8+siB1Gc0aZty2TIEoppZ0MhP8uQ?=
 =?us-ascii?Q?oNzypVBQ+Cohqz0tGrsm6Y8uSPmCLZRvqSfkRxXqoOLmyayl17qcLgNsoDjE?=
 =?us-ascii?Q?0B+R+5rM9lxcy0TXjDMXgFH2cI8Vy/25cxwZXCSeIWYMtDQMSE5CIlxS5fsB?=
 =?us-ascii?Q?1+eh2LLOlXGS0dV1NoWaTquHsASH4CMU4kg3Uxi06nLtLVGjd3GFphZ6RnYr?=
 =?us-ascii?Q?loAUwQNao+9OhbglkAW7yvx1IuM3AkhArOC1sgHuWpRBb2QAhgmUW6QV/1Vj?=
 =?us-ascii?Q?x0ssznoZfFiEUKXa/LGIVsnNIC+L4hrv37VRALTVv2AlQmQBHN7zcbf/pyXH?=
 =?us-ascii?Q?bqPJq2rCL3w0OIz4FvJVjzPA2GXQhr49JDg0boZ4YADX6tYKlpBq8lBojQQE?=
 =?us-ascii?Q?wMg0+oEs8rVqupRUHXgcNzyfcoy/V1AqtbCypBce5ybYM3mVpRKu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d1e63b-57b2-4f6e-6ebe-08da2d93c641
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:13.7215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t9l/TErqu6/xsbAdjyJJ9CFS+oE5iHqh0/NGcCRFa48c7f0RTlTBNdVZyi0ioS+Y/ZSjOWPQ8SsHPf1aDqZgEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

mlx5 doesn't allow to configure any AEAD ICV length other than 128,
so remove the logic that configures other unsupported values.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c | 17 +----------------
 include/linux/mlx5/mlx5_ifc.h                   |  2 --
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index b44bce3f4ef1..91ec8b8bf1ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -62,22 +62,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 	salt_p = MLX5_ADDR_OF(ipsec_obj, obj, salt);
 	memcpy(salt_p, &aes_gcm->salt, sizeof(aes_gcm->salt));
 
-	switch (aes_gcm->icv_len) {
-	case 64:
-		MLX5_SET(ipsec_obj, obj, icv_length,
-			 MLX5_IPSEC_OBJECT_ICV_LEN_8B);
-		break;
-	case 96:
-		MLX5_SET(ipsec_obj, obj, icv_length,
-			 MLX5_IPSEC_OBJECT_ICV_LEN_12B);
-		break;
-	case 128:
-		MLX5_SET(ipsec_obj, obj, icv_length,
-			 MLX5_IPSEC_OBJECT_ICV_LEN_16B);
-		break;
-	default:
-		return -EINVAL;
-	}
+	MLX5_SET(ipsec_obj, obj, icv_length, MLX5_IPSEC_OBJECT_ICV_LEN_16B);
 	salt_iv_p = MLX5_ADDR_OF(ipsec_obj, obj, implicit_iv);
 	memcpy(salt_iv_p, &aes_gcm->seq_iv, sizeof(aes_gcm->seq_iv));
 	/* esn */
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 7f4ec9faa180..7bab3e51c61e 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11379,8 +11379,6 @@ enum {
 
 enum {
 	MLX5_IPSEC_OBJECT_ICV_LEN_16B,
-	MLX5_IPSEC_OBJECT_ICV_LEN_12B,
-	MLX5_IPSEC_OBJECT_ICV_LEN_8B,
 };
 
 struct mlx5_ifc_ipsec_obj_bits {
-- 
2.35.1

