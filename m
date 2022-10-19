Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6156039C0
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiJSG1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJSG1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:27:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E8A5280B
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:27:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lb5YOulgOVrPYfYKvzearzhyuy1vT8ATAPlp9HoJRvqalUOMUpho3shBJBA74rig/TJrIOifj5gvRqG9vF+VRZQSajBtmyGdKtfQGre8uC4FwJXguKxOum90D/5wV55MUBxdS8U3vxyatyUVyocCmj2mOPkFKYb9NGvrJdn5VnUOVP+NfBsevt6Z6pqNvNwXKSPuQOoa93oDDzW/t2GIU34AujWXMSyaD+s26UtYnpWt9P6+4mosgCqANxjtdcDPj7zqCNT99+l1+xQmsU4Ixqcmz8dx7lmLxHcb7oZsNgISLk/1AptjCy06XPEYFsZGHXhZ27/v8wtohdN+Ca7I0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=caglWP2PngkpaLcjyGLh3Fc+dmqT38A7If6FQz5GE1U=;
 b=S2H04HtfMzKQOvOkz7pgT8/Jccp35iH5gEoU5darhqFtsk9Mjy4+uwQ2Xyol/Yi8lLgipkK4dINH6zudT0I6U/2Kf1fJQ6+3RagryYRSXEp7NwJULZJeKlmFRxXRH/u27pB+HonJfPb60jsh6AonF+w2WugPuP8U2XKv4GRpplNatlQr5K/g9owdp+FT6Ml1gCqcB3/RQ2IciBVNOk2Bv43/+0Vkv54ftlFYfkTz5nOKvo30wwZBWQyAkdeHBN+p0J2NI4DCR0P6zNryYqnrwnUt8YpCwNt9kDJGfcIriK+zR21TR8HK+IAIR+TAS4IO0RmHpVfaC2GhoaCsTOcgEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caglWP2PngkpaLcjyGLh3Fc+dmqT38A7If6FQz5GE1U=;
 b=ZelJc5QWnUs8Zv0XnFRWBwdBQaK0qevkJ+G3O8B0b7l4/p0FdVq1VSQfJKmBKXdEpN55i/ItqFuVIbvdv9CQQNCJvaEyT/HbWkbWA21IVativaVQybP+iG7Nk12LboKicUMRe0KkRR1c/ozCx34LR7pMmJugWH8CN5+hrGgqxUrheM2HMXI5KSxwILqU1Oea3GXA2LKaBZ64CWl5AUfR8+OfkuM5FisB781VoYdbkEjwVrsfR+YWVKB/gE1UPVhOYe/6lEtE5yZRrSZps86f3c88UM/2eShTgH7Fwl7oEJvqvMzyVSP8kJEz2B/borsme/uyeEhuaDxsduhAZLYyGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CH0PR12MB5315.namprd12.prod.outlook.com (2603:10b6:610:d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Wed, 19 Oct
 2022 06:27:14 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::70d0:8b83:7d82:b123]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::70d0:8b83:7d82:b123%3]) with mapi id 15.20.5723.034; Wed, 19 Oct 2022
 06:27:14 +0000
Date:   Tue, 18 Oct 2022 23:27:10 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH RESEND net] net/mlx5e: Cleanup MACsec uninitialization
 routine
Message-ID: <20221019062710.drfqigxhmh3uzxl7@sfedora>
References: <4bd5c6655c5970ac30adb254a1f09f4f5e992158.1666159448.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4bd5c6655c5970ac30adb254a1f09f4f5e992158.1666159448.git.leonro@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::27) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4209:EE_|CH0PR12MB5315:EE_
X-MS-Office365-Filtering-Correlation-Id: b8eba91e-9db2-4798-83f1-08dab19af4bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0CwH/uhemed6lci2L/EYXxch80+MuuGyXxUSmFd0/7ccYSaFdCzKUAnYsEWjNppI0FHgCc/Tn6AgvKSHWEDOeAfsry+tWcCFgmdZoriRRmjjqKS6icqYi86GY4d1quO57G9lYAkjzyySa4MaT/ZYQabg1GweRU86P72a46ZXph1llRrRYrTIW1q//HLBQkxgA1DgAC2tRLLoyZsz5VcurKujRI8Ohml233zPbUQMLgWv9KY5Zj4M6spzaPFXYYHYHNucTdkBsBg6zZxMT7vhqC3WLkjcTNIg8SZ85TTG/pm87g2pLE8osal3Lnu1T9j5BRuQSIt8qIWQ3lJ77Nki2Pd6d88BOgaFvMv9L6F3OvgS2L71FU6y5hWKRj/SFg9T+CHWlZmq4QwT76b+7qLVkWTkJ8r7pgcvW4UHTweQiu5jJOVIrrAA4ci2tIthfJdrHqgx0lzwoCni8VgxO41OkPiJmd4Ij8YlwIEoEzkJ0QFbvfma3vvfBH6FfFIE8vB4XkmrplmwAVSFwDYZhUAFzw6yK9OOqhuum4cqlyRbAIwrbFMUT54rNi5xv3kHQphJWPpnMD4AKPNuYPub7iWPmCczXi08ZtEYs+Cactm13qORS1GStDTLmabL6JgiCxxTI2RfogZoATPenvAyWiZpfwShgKvgegzPqZ/wotDvgxiDUhIgMfmAtFweWD24yHc2UihSQpIOI+hVTrw77rVr9HqtkmEtoXZ+LsEKX9AcCzNe97Xz9AV5odOP+/grOH7fy0C7SKkG8S7mV1pRvw9iGAQH+pQfkv1HM3KRC39B+eQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199015)(54906003)(1076003)(186003)(83380400001)(5660300002)(86362001)(2906002)(4326008)(8936002)(33716001)(107886003)(8676002)(966005)(26005)(6486002)(9686003)(41300700001)(6512007)(478600001)(6506007)(316002)(66476007)(66556008)(66946007)(6666004)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n8davh5OirNDyqLnLrLOxsw+5UzsTTP3THxJ1tU2LISelaMLMkJ49iK4ZYqg?=
 =?us-ascii?Q?9pntr4m+CoExg0VJlq0vUxZd1KM1bBPfQ/VfvhkxNLY0Os310XcA84QoYcgw?=
 =?us-ascii?Q?lzB/pM1OCTGd3Ppk/hZkbpZiZNlz8lc60P2x4qctSSshkQw8DrWgaQ0Rs+Kv?=
 =?us-ascii?Q?z6KlweSxfHNVDVXBPGhIdCMGgRQ7C4Ub/TSxuy7H7vjl5wzTxHTN9wy0x+L9?=
 =?us-ascii?Q?Ybz8QlWprRip576PWsosqD9CTUNfgT0jI2vc99oFLLalMS5B9DZr2K/dSsvF?=
 =?us-ascii?Q?HBYGlcbBoK7KFz6xnQBToXo4V60Cc43QNcOcpRqOPGwsN0rNvcFp3phZPcKd?=
 =?us-ascii?Q?EsnQNIOtmOiVLXF9x/w4r7AX6emsz1mCPeTOnT3HhJAF/RdSe7zqp1VnS3hU?=
 =?us-ascii?Q?VP8cPsYq3iEh/NgFqvkSUdMKkkff8tnR+LpsZ08aZ0L60XhEafs4nQPcmvdp?=
 =?us-ascii?Q?6t2kZqAhyN2rk0DmYlUyrMIG7TbzuUWqEPNjlg7g2HY6T77R/ezjxT0jMmHT?=
 =?us-ascii?Q?Ja4V/qOsBWo7wluUNbZNO0xWlwXFj6kMfmlmtX0lZXzkEwX9mY1q2tjiJAhy?=
 =?us-ascii?Q?R/zS5jUDUm3wkfb9vU5hXZrK/dzcMynxUY5TAK7vWxLpyQf/eQWhDURZNEtk?=
 =?us-ascii?Q?rRfBaQ6a0YKM9gDxZceIHDdWWN6u/mMJr5AfkFhqda16aXMXrNbFNa2yAoUa?=
 =?us-ascii?Q?D2Yrm2RcbwGfya2ShLqiQsEIorU8zYS8R4rjVf0Q4PLXRrY0vOWEIcEcIhiv?=
 =?us-ascii?Q?1aQvQKVJPFb9K9n9QA/IwxJkfHJQVCMfJjh0aCui3ntjO1GIoE2j0+nSQuAJ?=
 =?us-ascii?Q?f56maxfAr5yB6JLMTRUE6z58Wy1oasNwfHin6lgXio/s4EOAxVr9jpXXAx1Z?=
 =?us-ascii?Q?GpOeXG9KpogLYWNNGU/7fQ+8jTP7YowuWI1TWdzGwhYyD7lp9TuWBU8sRMiP?=
 =?us-ascii?Q?7nXAvDVjh2h6jdh2mjS1pm/M5L7Yjmbpty0xkJvT1HEyWbIYaH7Z+gYMmrlD?=
 =?us-ascii?Q?T0K/K2w6F+tDx/TloViDqAaUqNINUIHs8QDnWoVg4p526sgnF/feK7CWAQjg?=
 =?us-ascii?Q?LSSc4qKs70+I58SqtfJFpWAQiKcg1Oo+e0Ng17ML13eyrm7aJs0r565ju7Sx?=
 =?us-ascii?Q?0IWav9rwDZjmbQbEOkPG99eqj5Mun5P04w8ccWJ4E3TCww/25rkTjDF39HH+?=
 =?us-ascii?Q?IyPNxykZE6CPJNmWU79dfkbszBDerpeatSZW+ytI0/RkJz0yDOUVQC/Y3OCw?=
 =?us-ascii?Q?PWuxb+MN3ON69CD19KCo8ESiixYDsSDD7rEglS+9E4Oovx3Pd+ar+KW8Zk2H?=
 =?us-ascii?Q?7jZAkHPBML5V6Gna0kNYDqqycVwSttBSxNs7ILnA8Kb8RZvFuIKNru7jSdYA?=
 =?us-ascii?Q?h9ORLbx/L5iN2vRLfdcJ7P1TGLLefND9baJoxulHEDc2mV3NubnqY6fcepeB?=
 =?us-ascii?Q?nWZvb5+wT1g/rRG8OA9SHuzygOcZrfhzfNkItNu3IbZuDVz3GH+2dCc8cXI6?=
 =?us-ascii?Q?LZE6dZUdquM5cbpK+eoQ/7ddR1Kchgt8ZIqEE/9Hif3Edz1Bx93WGtKWp3hM?=
 =?us-ascii?Q?svX63QZTmBHrETE4OP98DpZAPTDjsgvlmMlofVyc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8eba91e-9db2-4798-83f1-08dab19af4bc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 06:27:13.9173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1u/TpwNBru6/XkIGOmieGJuuH1K4949PAu8mLfl+e2DmWeXjhC/5/Tlu+PWLn5VCff6cneNsJqhdnjbyZ+1MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5315
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 Oct 09:06, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>The mlx5e_macsec_cleanup() routine has pointer dereferencing if mlx5 device
>doesn't support MACsec (priv->macsec will be NULL) together with useless
>comment line, assignment and extra blank lines.
>
>Fix everything in one patch.
>
>Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
>Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
>Resend: https://lore.kernel.org/all/b43b1c5aadd5cfdcd2e385ce32693220331700ba.1665645548.git.leonro@nvidia.com
>---
> .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 11 +----------
> 1 file changed, 1 insertion(+), 10 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>index 41970067917b..4331235b21ee 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>@@ -1846,25 +1846,16 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
> void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
> {
> 	struct mlx5e_macsec *macsec = priv->macsec;
>-	struct mlx5_core_dev *mdev = macsec->mdev;
>+	struct mlx5_core_dev *mdev = priv->mdev;
>
> 	if (!macsec)
> 		return;
>
> 	mlx5_notifier_unregister(mdev, &macsec->nb);
>-
> 	mlx5e_macsec_fs_cleanup(macsec->macsec_fs);
>-
>-	/* Cleanup workqueue */
> 	destroy_workqueue(macsec->wq);
>-
> 	mlx5e_macsec_aso_cleanup(&macsec->aso, mdev);
>-
>-	priv->macsec = NULL;
>-

Tariq was right, we need this check, the same priv can be resurrected
after cleanup to be used in switchdev representor profile, where
capabilities are not guaranteed to be the same as NIC netdev, so you will
end up using a garbage macsec.

Also we don't submit cleanups to net to avoid porting unnecessary changes
and new bugs to -rc.

