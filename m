Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB55950C4E2
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiDVXPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiDVXPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:15:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC846B9F07
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:47:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbfYeefNKZpuWXBcirrquaweKvjRIUuCmFCBcsZYwqydtnfBY0u6y9JK+QA4XFgeNAdXpucGLCXQscNW7LlANm2ADzdDot/UUy/HG1xtvxi/eWwk5a5qx8rGO+BQ8JB+Zz9pFvfWGPb/dFbXnS5tp/dA/TUr1cOo7+fyW5nQUm2EMxyjBMeqdtTSIVsK3KGnpZ685CXaNYkNA1QiNW+6QaASM6S5Kf5hmiuPzW0Gla4dWLgvXH+R0iUz2u+dAmgnstZA6SktKx45soED+ByseHPli1HeiNmIaXa6bQ3O4bdQBV46j68MHxU3LtCBvqWD1eVE10dvKmVp6x4ttX7t1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZUn1tEE1oFhriQrt1a3qf4SWocm9J5fR8gkQgCLGFa8=;
 b=XBZL2FWPDzFlojvSJMUl4ao+boLaygVPjWXLTPwDTFERac4HZMR1bFHiSiYfy04hLJnlqIJEyVf7uzLiQYCOUGljc5ATv3KT3JoYCjI/LhS3YtufIQFKvnhZTblulVQrADKsrOznD//8UBTKwoJK0WRA/wHDgkaePBV5ikH+iDF6yNhIf0pZX8rR1Lu+F88rRL8MF6+i6O++AEjn5XqWFdNSoKzgJ3BO3Cp386v/3LYkT3kbYCXI3d5T2bVE7pPYqymLkJMr5HtdJQp+3wT2hwo6FO33xama1iOU8hWWMTFta4vohvEj81oBdO5JJ0QdLD8LFsoD8ctJZ8Wgw26u6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUn1tEE1oFhriQrt1a3qf4SWocm9J5fR8gkQgCLGFa8=;
 b=bt1Yx16HlHAtoxL8Ii2LMv003Oo8nH1zhTCADtNWhrPu7UaBW5pMgAaxELc4eiE2IzuooKPb0bETPTrh+Wj9l+KAfAjB3Y2yBgZNTtbvQekqykEsBHBXpVv/SXxa8DGpJ0unS2IiGdiB1uARpztG89JsuMo/93AhdA6F7PpQGbIqpOLlvi0mT+5cX1V6dAbLBBUkYLRxud2mD5QuSfclpQVJDQRjMjNmdzc4UmVXJzGIT0yU5zo6kXaW56TrxiN+pEPXiQvLa2il1uaJqUV0XsPziP31ODBYlDuVSAN7UWlAcI5s1H1cUe68ACQ1ng1LZXLzUUlueGwzt2iyO2Q86Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) by
 DM5PR12MB2421.namprd12.prod.outlook.com (2603:10b6:4:b4::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Fri, 22 Apr 2022 22:46:57 +0000
Received: from DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137]) by DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137%3]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 22:46:57 +0000
Date:   Fri, 22 Apr 2022 15:46:55 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 16/17] net/mlx5: Allow future addition of
 IPsec object modifiers
Message-ID: <20220422224655.bgzztciz3gwadzha@sx1>
References: <cover.1650363043.git.leonro@nvidia.com>
 <42e816e8fbd9cc0fff772c726c546acf92fc60f9.1650363043.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <42e816e8fbd9cc0fff772c726c546acf92fc60f9.1650363043.git.leonro@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0361.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::6) To DM6PR12MB4220.namprd12.prod.outlook.com
 (2603:10b6:5:21d::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82a44d5d-1d54-4de8-7273-08da24b2011f
X-MS-TrafficTypeDiagnostic: DM5PR12MB2421:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB242130B70AF5B4FEBBEF4204B3F79@DM5PR12MB2421.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0TAPI467UtWqjq3F3emZV/P+WOiAnr6Mhzt9aTkqD82L1FuyPO7ZkUFSaJkzbkSlm80Sd1W6JxLNaNxY4WQCuPXZanSipzB8Jj7QV52XI0jgvG9dr1h+H2mXA8qkD7PczEzr6fHQvHUuCVHHDTI04oXD87HYoTPbbdwbdG1THiTl74Qs/tkyN/Bpog6q76cMuZEod5+z+d6zcK3aVb2NGNHxPfXUPfTQ6xsLiyegX9+d7XPWVlD98jAfn6SOqYPRiZCgV2A0RmIpA4tvTIOvgy+Mo022F9oroN/eKkhftqpHPZQXlJw4dMwJXP2/WW20g08O4boYcTJBsINyhWBRHcMNHzJp7nGzaYjwH4OrffjuGUpCHhKOKjhWMhHCRROwZFkibaG0zBrBdWOQEKzpzsJrsy8R8v9k5+xCKRnMy2CcDt8La9eTKVkJUjBtMuQkL3MLqly/6jcszc8uPZG4aEOy1YYMPuanLmJZw9fcgAWwNx2wsSkBf1O2yCiLFXddWo0+SmfnACH4mhs0/qtehYwcky9i++p/3G5xzlMnEjtbIY5ZWkperLhd08T8dLSvw/jZZfeqYrREm1aERmbebOva8ZTLOAXbuJgTMUp8S4JYMtQc70A6+jzo/drjSeFkofeOpSbOPmSoMmGPngbQKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4220.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(4326008)(186003)(5660300002)(6486002)(8676002)(66556008)(66476007)(66946007)(83380400001)(86362001)(38100700002)(8936002)(1076003)(107886003)(6916009)(54906003)(2906002)(508600001)(6512007)(9686003)(6506007)(33716001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y2g4jE+K7BDg8gDSbjMaIiUJDZ+C/jtsnIIdjG7uZQoHRwtxVRgwu5Y24f23?=
 =?us-ascii?Q?aIN8wYyxPlqPvzNL1cnMOCiGOl3JpesqO8WAazrDLehp7kjUcWgiokXi8wNm?=
 =?us-ascii?Q?7n35XqUzNcMXhBdIIOX35aCEGgcfGHAkg+SrMmB2cEZm/Lxkc223pvgwGFYZ?=
 =?us-ascii?Q?zSckC4XnLU0Rscqv6P/czI/G8EXZHrCg9CtDwtArPjZfiHJVXtOWKVcgaMKN?=
 =?us-ascii?Q?jKuAMudLNd+jZiDLYK2ArMtUTFkS4jDC6DmAz3Rzn4ZpLHtsSCuP/DcvBiqi?=
 =?us-ascii?Q?qF9BOvz+D89KXt/7JucIkxAuluTTVOoBnJU/ewgcKIaPNrcSUpMMdQ9DNOK3?=
 =?us-ascii?Q?GYj1y3NuDJKleO0TyHBjIKEI+EA40/rVUnkWiT0UmLhq5QozuwbhoYS+nD2N?=
 =?us-ascii?Q?vafjE28jmeFqe+3F2fDFwWLxRC4Qz5usPod3zH4g4YjTwva/yN6U/UJaJM2L?=
 =?us-ascii?Q?1NcovzP0r5lHlRdDg3vSNoFch7Icsj4VozsU680tvLLaddZKIuMN2ddMYVgV?=
 =?us-ascii?Q?+17R/lyD08a7rhQTOBAERYt3cTdv5uxPEiDiWc+lLA/7VAFSpzULBfHKv3Bb?=
 =?us-ascii?Q?knONt07Msj/C40m10WEYutykqagFXSxJJNGTYlyrVp9n6EUy6Zv7avQ6fZPq?=
 =?us-ascii?Q?Vp5BafJG0V0Akfysdi5oBD+PhyjOngwaZLPRCpHQL4glchtMLDeK5xKsThCc?=
 =?us-ascii?Q?H/qyIFxhj/oLLCwf654Qf0+5It3+CmuTxeWqzZpo+Ag8w/T/uNSX6dWxvQh7?=
 =?us-ascii?Q?TMN7IccK2sVytc+Nn1y7aZ9Cckufbdk7djhdmFXTKHofTCYC9HtNXxHeEGYb?=
 =?us-ascii?Q?4IVr11/iIL4e8Ch2rJkuoOkRLhblMaq0hNhDtILleoVk3X3C3zfn1UtMRdIg?=
 =?us-ascii?Q?P9FlNlCOwkG6PVxl5y+kg9g4Fwcn0l9wAlL0FY8oKlqeJecfoxbfNo3oqVEY?=
 =?us-ascii?Q?ouwy21xNkrc46Q3t3/+X6rqJcT9Lo9hvEPLo3pp5rejEDTuDpOln0tZllWOn?=
 =?us-ascii?Q?ntg22zRIuLfEeowzJNCyWMVZ4Rlpz4N1Nd7F1dU3WG98iGnDx4+YzzZ/qFtY?=
 =?us-ascii?Q?nC6YNOUCM+JKHie+tp4Z2LY4xs8f3NmTQBH6EV/g4688LsO7WamQacX5uqaR?=
 =?us-ascii?Q?7qHxvCi+9ORq7VZfA2K+JvAujlRYX1Ae5ehMozA/3Efyu3r/enQGslZhHjpp?=
 =?us-ascii?Q?/fyGl9vXZw5K1sr0PxPLAGqKxtr1LeL5eGmXMkz+r2USxJ5II32TbcsT5TTS?=
 =?us-ascii?Q?YL/cM+HysZ0ST+9TLc3go00BoKAHLZhynx4ZAX2zyycP/0jLDMFRMfA6OfgP?=
 =?us-ascii?Q?h96/fUCABF1yHHGNmjOErSRh3acabwNwEqhA2a1ACcr8jdNn4QWTgJkMDpCc?=
 =?us-ascii?Q?GQJ5J3sw3rmaKBAnBqTM68WasxOcww9sZ/SYoxFvWzas0UhSa2vWGTCNoCiV?=
 =?us-ascii?Q?q3wDYRQJSWqF/ui/VXc9fM9gdaFz8gRpEkgnLxZ3DkUzCEsQfdnx99Ljtisy?=
 =?us-ascii?Q?eIg5ni1phWW+FIH7THokXVSdnLPibf8S1lYYEW/uRPRvbsbLAdG6FpXuvDx/?=
 =?us-ascii?Q?j1UzdpMz/ImeKTMR8SX7Q3Xc/yEA7oyRfDBZxnvy769pB+ky69uvgk47KW0h?=
 =?us-ascii?Q?QEigupSAS7XU+mdF2I/03dmnDHPHfTDiGbeD/h8PkX301Lr9EI8dfG1d87kc?=
 =?us-ascii?Q?Np52eWrznnH98M7YGCxfrvrCViqWsFUnb/K9VfKgXmCjaAfcjUyJ4h3pumDJ?=
 =?us-ascii?Q?O+VVv+iLgteQXSergmHvUrEiSWbZlmQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a44d5d-1d54-4de8-7273-08da24b2011f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4220.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 22:46:56.9837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0CTF8rL/3MXC6eOOxs0LqmdrRmbqpAd3EdiqCiNKP7PV/5DQafd/GbZU3mka8LDVclh3VeZ60WsBtNVTGDVfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2421
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 Apr 13:13, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Currently, all released FW versions support only two IPsec object
>modifiers, and modify_field_select get and set same value with
>proper bits.
>
>However, it is not future compatible, as new FW can have more
>modifiers and "default" will cause to overwrite not-changed fields.
>
>Fix it by setting explicitly fields that need to be overwritten.
>
>Fixes: 7ed92f97a1ad ("net/mlx5e: IPsec: Add Connect-X IPsec ESN update offload support")

Will apply this to net-mlx5 and send this to net.

>Signed-off-by: Huy Nguyen <huyn@nvidia.com>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
> .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c   | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>index b13e152fe9fc..792724ce7336 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>@@ -179,6 +179,9 @@ static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
> 		return -EOPNOTSUPP;
>
> 	obj = MLX5_ADDR_OF(modify_ipsec_obj_in, in, ipsec_object);
>+	MLX5_SET64(ipsec_obj, obj, modify_field_select,
>+		   MLX5_MODIFY_IPSEC_BITMASK_ESN_OVERLAP |
>+			   MLX5_MODIFY_IPSEC_BITMASK_ESN_MSB);
> 	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
> 	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
> 		MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
>-- 
>2.35.1
>
