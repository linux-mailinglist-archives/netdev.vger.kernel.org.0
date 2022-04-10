Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFD34FAF0A
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 18:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbiDJQsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 12:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236433AbiDJQsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 12:48:36 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2065.outbound.protection.outlook.com [40.107.212.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826763F333;
        Sun, 10 Apr 2022 09:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3Fby5RksF2Y88dUXWe77hasEOHr1m4sy4i4OynHxYUSn7BGVQM9pnOcc54QptbGEqL1i+ELLJryALfNWsnR4aSdgL/Y++mIKWFjZmvknrP1LcFWMYLaWsjNLC48vTuj/lUdsXU4SG72JRVUQEy/6uY4fRZVYD878RyEIA19JvCuxqyR46uirSpEa+5SNnncevp541BWU5nvz5f7GYWfQQH+ndUyMPTRFuuD+VElqSE+K4Ij2s6ITP0Ej6FCR0jsli2cm6w2QeBZjkUApKzKHm8J5/GFR9vI/9jA9UYKn/jqKnr2lo4YufIXiDNALYbXaTwQS2/bgV0N0MDDtxQccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jncKGiO6ciPn9hjUidyeOVgRXxPjCVQPyeECTKHyZII=;
 b=gzMRPK8Iv14doM96JfcGDwCYdvKMz0QnC0IweutwMO71J+iggP0nUrhIOx34gdo1Ci2vfn1gp7jiW/Cpv4oBNntZA250SDPyvvT32PxR9w9V2ocDYBcJjndd5YKq4fobZy6lSf9VHoHhWVoheiB/+71OIU7zokpqvIZELZI/OE7L7pdGF1sHmRgFTUDG3PooJCw3oJv1PJrQWngjRiXR/LmR1gr7KngXDtoee5r11+mfM3F5GKk0WX76APROIhTDbjNALPei+IhDjGaAQKy4oqAicwyuKF7fJ54p92Yj5cHoSA/S0Ew/AWOAUpapnK5xZ1G6zHnuUoM1bVwfj2u/GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jncKGiO6ciPn9hjUidyeOVgRXxPjCVQPyeECTKHyZII=;
 b=XOqD9n3E53NNHrU8SWivNLJkR75xYiX1axLSeFyMb08Zw9gIiJDYHnU4FW+ySX+WHP0TtKOw6DbqIaE6xhLIyhZLRN8hi7CKtikluK/ZhQMZaYrlHq7kdBRrdcyYB/SxvAzr6ZmnOF4tVF78CwRx6FfwSAZASL19zova53UFoMmmnZyQ/ONliZdDzyj32oLDyMRaZuTJ6MAAi90g6Vg0OjgiFC4SdIMUNE5MY7K9ETwK4o6teWrjulLpsPe3Gux/2atlxiV7CIFt1tR7hxY6aCU0x53NgR+JwMpupSeZsTj3JVhwDN9tvtze6oY37DJUUslX2QOVh1wQFsaBt7T2VA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by SJ0PR12MB5662.namprd12.prod.outlook.com (2603:10b6:a03:429::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Sun, 10 Apr
 2022 16:46:23 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::f811:b003:4bd2:4602]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::f811:b003:4bd2:4602%6]) with mapi id 15.20.5144.029; Sun, 10 Apr 2022
 16:46:22 +0000
Date:   Sun, 10 Apr 2022 09:46:20 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH mlx5-next 01/17] net/mlx5: Simplify IPsec flow steering
 init/cleanup functions
Message-ID: <20220410164620.2dfzhx6qt4cg6b6o@sx1>
References: <cover.1649578827.git.leonro@nvidia.com>
 <3f7001272e4dc51fcef031bf896a7e01a2b4b7f6.1649578827.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3f7001272e4dc51fcef031bf896a7e01a2b4b7f6.1649578827.git.leonro@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::35) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c5f7140-9cdb-46a8-4ac2-08da1b11a52c
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5662:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB566283B8F0CA3FC0FE0452C2B3EB9@SJ0PR12MB5662.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a33HmcF2xrtrXFyLbb71DVfWmvoEq/aVzm/TOEpGEvBaBLW3raSsbulvmjYzEsEmWQr1BeCm4yqdeaCn8Qpdwo6yJTOVBIwAglHyvfo3WnC8Xky0XCbvDpYFGcittrA7YuR0/BVRh9eHgZllYlTXJxig1apl6dR1G6wX2o0akrOyUjHjvV1AZ1eTM0YPa0wFQHyCAglgtSdio8/Z2alMu5NUKwjxz3xI8tupYi5qqbidZAo4xd0DB+cC1SCQA/drQAovswTZ4Qr6u4Ge1IOQHxrU3tr5CmGf7xcOssLURKOyYB2ALn2zNJnaQ2egt9TKMoi3nLGA1nE0u7OJuUACstcy4rjc8h/Al6j/stGAYBrfnkFILSpOH4eRH2iCuXSvWFVbYqStuar4sQlSUyGaBMzG8eo/9E2Deg6iVMSrTslrjCICOlj8vs0Z3/au3NKmych1+eNssQcEjK0Jg8mP8zd0rnVOb/QrovSzOlzMRZvl6QKU71hTnM4atkhAKh9kg4VThXKcfma5PIb5jmDOuwsmqpOre1QCk2IuP9crS+8N+z8onzByBWz9c1eFX2fC9W+Kgqf1iKAM4fvjQW9II/cwSS0srIC8D5Jgp46Vuqwt8MW3qQ25G8+AYV7ElyJF04U8fPdptO3VBR5Dy81RAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66556008)(2906002)(66476007)(66946007)(4326008)(8676002)(6486002)(316002)(33716001)(5660300002)(8936002)(6916009)(54906003)(86362001)(186003)(1076003)(107886003)(508600001)(38100700002)(6506007)(83380400001)(9686003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iZgugCB7es2Qs62oTEeJeXifcU95zxZ1LndsABUQd9plYjENLO1I0lldfo0l?=
 =?us-ascii?Q?/qGAaQQ9kE3Jc+Dta1VODs45PkkqvH4swT+yVrLjVzr4LeQc6sAGJjJCqUya?=
 =?us-ascii?Q?bKKjR2+gIL8/n9+SlOsWBUIm8pvoFJAXTn8eay1ryNaTEcVZZwZ0n3hraoF7?=
 =?us-ascii?Q?sisJo6QNkshnMx+mFo7PpmL/b6bxeBORXeyKsNKIJJyCVP7vnMQSXSr6Z8To?=
 =?us-ascii?Q?LAkdy00xZ/7hKRIYQ19K2yFTAi2/0NMM6NXswqulR2iLicRoE75QwftqfK/u?=
 =?us-ascii?Q?MCSXkF0BDpr3UEbaYYY528tDzgEQn75jc088hgsyMMzQ2Ed/TcFyYnW5otl5?=
 =?us-ascii?Q?9EUg+CzMV4o98d1SXv7pLkYIyXLWoLcjSjCcxq58MkFU9oUt0cn05bPVJ/QZ?=
 =?us-ascii?Q?9UnyXLxQ8K94lTULbfmC48fdk5pl7PEZFUJf6U73KamQ+TNw9DHNa02aiC3X?=
 =?us-ascii?Q?QDdAdwf/pxTohoCDgbxEjnHYKsVqfiqWSdtZnvVgMU1ogUgItMrGOMlMQ0e0?=
 =?us-ascii?Q?SLx7Q0swoCgWsNOd37ar/I+O007qBMvTCKPch21khXGTzvZ8yP+Q8NDIJa0P?=
 =?us-ascii?Q?b200zO24fK1L+ukIdUcLkbWNbw+JFZxwoaipmYi08eCb/gqfIpm03IVPwsO4?=
 =?us-ascii?Q?uArLeu6Qwo6gNSAxopPibDsWONytr3aI3OiwUiDR2+IqesKIPLsf0Dy1Mucp?=
 =?us-ascii?Q?Rvh7rjQavg75l8SnRBuC0tJXAp+FIqhQTIEZXfq3XDIimiM770f5DEGM7eOR?=
 =?us-ascii?Q?OmwJ6x3G3tOzcrYojpIJ7x0hr7EKRoMp/PtjvzulS0R08BTcB3Vq9/wFwIh0?=
 =?us-ascii?Q?XmEcZqbVUC0+NoVEnRsUf0P50aMwT4lDMrAqitDzSIDsV29PjHrCxoviECh2?=
 =?us-ascii?Q?LUfddQsH7mgbS0nI3T3noq3Bh3aEwK/05yqROHVE0RwbY43NYJVXTQkJ2OxI?=
 =?us-ascii?Q?WPVzLhJnNxkEwqgj5lDyTfLNWzJtuB+dTH6qaZv02qD62lQlULf3O82T4VmZ?=
 =?us-ascii?Q?A3Ht8I67QuBq8Iy/CW2X5gQ6sMeSLMtTL71o5KslyTVAfHs3ClvdiNdfsino?=
 =?us-ascii?Q?9AiRQeXx62pLBID87emi/PzsYUYwRJBaWvYoFJys25pYmSGodsWTnU1CgZCb?=
 =?us-ascii?Q?3neBeNWwRFex8lSGKwPTdUg0i1yNsy9R68vHbEyIXS8Ogwo9WYjvH9vVVkh3?=
 =?us-ascii?Q?kd1B6OJ6dnSBQvqqpdjnAfMOzWrWSQdZZR27w8XT9a2wk9x7z8HmMB7syae/?=
 =?us-ascii?Q?sDJOzdTRCJ7vHeZGrfvFskG1eau6TT/w1lelis7tlW6T+QEXDtHrAIS3ELu8?=
 =?us-ascii?Q?qmv34TZjkeFZI4KuP8M2lEPxEgZuTIXu890kwUJfuJqqy65v2H2dXlhE3Rzw?=
 =?us-ascii?Q?sHEXN0+kOwKYA/ecD+PCPxrjutnAkEVvAagu/8EKGuHtsMyqUci+aDKYPJK/?=
 =?us-ascii?Q?C8qpOEzJUmCVwyTyRANxykq09h+3se8c0cWqv1Vdnof0VHBqazi0KOPcNhVv?=
 =?us-ascii?Q?57vQNIK+0gzJBF3524iXUQzhHf0/epeN/EHeFGXcQn1xrJmR6O5WnXvPu4cw?=
 =?us-ascii?Q?qa+qi4yGX1Tf3f7KZC/UT/8mHg6nG4Rq/ep7IBo2/cUF71ByUoPzH+563n8M?=
 =?us-ascii?Q?atmOrf5JRv5Off+NW0f/T+2JbplOO2azYf5qnNC/cYhB945ywZTdng6v40Gv?=
 =?us-ascii?Q?CVT4FXEH8+THtbzOJuj6orrcigGQSWzvdD2hylBsZRfX7UfrgcIgxrGTJs0e?=
 =?us-ascii?Q?9pD3gFZ1VSSia6SOkp0I9TSJ/xOaE9I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5f7140-9cdb-46a8-4ac2-08da1b11a52c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2022 16:46:22.8071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7HwcwV8haZIyWo5kOws0s6HLz6VGJuNzA9WyHoYt0cvfJqA52eMyNQ4Xc5IvD4B8ANLTdwUsazlNdONhj0aBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5662
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Apr 11:28, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Cleanup IPsec FS initialization and cleanup functions.

Can you be more clear about what are you cleaning up ?

unfolding/joining static functions shouldn't be considered as cleanup.

Also i don't agree these patches should go to mlx5-next, we need to avoid
bloating  mlx5-next.
Many of these patches are purely ipsec, yes i understand you are heavily
modifying include/linux/mlx5/accel.h but from what I can tell, it's not
affecting rdma.

Please give me a chance to review the whole series until next week as i am
out of office this week.

>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
> .../mellanox/mlx5/core/en_accel/ipsec.c       |  4 +-
> .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 73 ++++++-------------
> .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |  4 +-
> 3 files changed, 27 insertions(+), 54 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>index c280a18ff002..5a10755dd4f1 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>@@ -424,7 +424,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
> 	}
>
> 	priv->ipsec = ipsec;
>-	mlx5e_accel_ipsec_fs_init(priv);
>+	mlx5e_ipsec_fs_init(ipsec);
> 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
> 	return 0;
> }
>@@ -436,7 +436,7 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
> 	if (!ipsec)
> 		return;
>
>-	mlx5e_accel_ipsec_fs_cleanup(priv);
>+	mlx5e_ipsec_fs_cleanup(ipsec);
> 	destroy_workqueue(ipsec->wq);
>
> 	kfree(ipsec);
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
>index 66b529e36ea1..869b5692e9b9 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
>@@ -632,81 +632,54 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
> 		tx_del_rule(priv, ipsec_rule);
> }
>
>-static void fs_cleanup_tx(struct mlx5e_priv *priv)
>-{
>-	mutex_destroy(&priv->ipsec->tx_fs->mutex);
>-	WARN_ON(priv->ipsec->tx_fs->refcnt);
>-	kfree(priv->ipsec->tx_fs);
>-	priv->ipsec->tx_fs = NULL;
>-}
>-
>-static void fs_cleanup_rx(struct mlx5e_priv *priv)
>+void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
> {
> 	struct mlx5e_accel_fs_esp_prot *fs_prot;
> 	struct mlx5e_accel_fs_esp *accel_esp;
> 	enum accel_fs_esp_type i;
>
>-	accel_esp = priv->ipsec->rx_fs;
>+	if (!ipsec->rx_fs)
>+		return;
>+
>+	mutex_destroy(&ipsec->tx_fs->mutex);
>+	WARN_ON(ipsec->tx_fs->refcnt);
>+	kfree(ipsec->tx_fs);
>+
>+	accel_esp = ipsec->rx_fs;
> 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
> 		fs_prot = &accel_esp->fs_prot[i];
> 		mutex_destroy(&fs_prot->prot_mutex);
> 		WARN_ON(fs_prot->refcnt);
> 	}
>-	kfree(priv->ipsec->rx_fs);
>-	priv->ipsec->rx_fs = NULL;
>-}
>-
>-static int fs_init_tx(struct mlx5e_priv *priv)
>-{
>-	priv->ipsec->tx_fs =
>-		kzalloc(sizeof(struct mlx5e_ipsec_tx), GFP_KERNEL);
>-	if (!priv->ipsec->tx_fs)
>-		return -ENOMEM;
>-
>-	mutex_init(&priv->ipsec->tx_fs->mutex);
>-	return 0;
>+	kfree(ipsec->rx_fs);
> }
>
>-static int fs_init_rx(struct mlx5e_priv *priv)
>+int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
> {
> 	struct mlx5e_accel_fs_esp_prot *fs_prot;
> 	struct mlx5e_accel_fs_esp *accel_esp;
> 	enum accel_fs_esp_type i;
>+	int err = -ENOMEM;
>
>-	priv->ipsec->rx_fs =
>-		kzalloc(sizeof(struct mlx5e_accel_fs_esp), GFP_KERNEL);
>-	if (!priv->ipsec->rx_fs)
>+	ipsec->tx_fs = kzalloc(sizeof(*ipsec->tx_fs), GFP_KERNEL);
>+	if (!ipsec->tx_fs)
> 		return -ENOMEM;
>
>-	accel_esp = priv->ipsec->rx_fs;
>+	ipsec->rx_fs = kzalloc(sizeof(*ipsec->rx_fs), GFP_KERNEL);
>+	if (!ipsec->rx_fs)
>+		goto err_rx;
>+
>+	mutex_init(&ipsec->tx_fs->mutex);
>+
>+	accel_esp = ipsec->rx_fs;
> 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
> 		fs_prot = &accel_esp->fs_prot[i];
> 		mutex_init(&fs_prot->prot_mutex);
> 	}
>
> 	return 0;
>-}
>-
>-void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv)
>-{
>-	if (!priv->ipsec->rx_fs)
>-		return;
>-
>-	fs_cleanup_tx(priv);
>-	fs_cleanup_rx(priv);
>-}
>-
>-int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv)
>-{
>-	int err;
>-
>-	err = fs_init_tx(priv);
>-	if (err)
>-		return err;
>-
>-	err = fs_init_rx(priv);
>-	if (err)
>-		fs_cleanup_tx(priv);
>
>+err_rx:
>+	kfree(ipsec->tx_fs);
> 	return err;
> }
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
>index b70953979709..8e0e829ab58f 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
>@@ -9,8 +9,8 @@
> #include "ipsec_offload.h"
> #include "en/fs.h"
>
>-void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv);
>-int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv);
>+void mlx5e_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
>+int mlx5e_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
> int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
> 				  struct mlx5_accel_esp_xfrm_attrs *attrs,
> 				  u32 ipsec_obj_id,
>-- 
>2.35.1
>
