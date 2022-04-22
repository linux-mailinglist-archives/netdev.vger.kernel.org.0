Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45C150C3FD
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiDVXKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiDVXKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:10:06 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5901E6540E
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:45:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVf1GJvUSmkpg9uwMbWGbdToN5AjHq1tzBpoM4Mxrom1W9tcmVxMkCHJvPBVF4PbxrNNI22u4KDyG+Yj5cMQ5YrWlumb/7d2DzO1h0cICZ6gX1Do6MiTDG29XIFCtPOgz0vL6dPLImM8/FflkPHqNgwVxbbekwbVnUYPitya0M6Nw7PGgHGpR2xk7XUL5qtzbg6Wr4Hkiy62PaSbrH/9lZQ29hElC6tq9W6QRqwKfaJobQvjdzEjbhgLWZP2lw0CTWUbFORT5hzR9MthmQzVVHo992shz08o5+ZzIOCh6yh8d8HycTlNAk4BSPwuQjOtnBrpYJvDIr2iSLRgKX0I+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJw/paEJ6nzgGte+s8L7IvbB13il9NcGedBySWf8Hss=;
 b=UpD6X0CI9c3TuTZ3PshBkNXEs1emxsHEdTOMtgZbACtv5Li24u4BgnIwIsroQ/nmdANrEI19mNiwofaK0OiwcStDdTyZpLDKy2sFgQPKsfPlqCOxnuQIK0mBp37Mio8IOvw4JIyipDS4cuTBl/ZAxxWpillgv56hwFDRDG85l5IT5eE7HzDlcK66FqLeOmehqFRpU1J1OvamnG6vtJ4SsDtYPVo7jN+yFAXONSb3MVhF/5wuDMr1d4I8THdxye9/tyHWQHlZHQ9W2kxBhOhDsorybAUiKS7dUC1g7JJALZicM0yq2R8cMUFVQKC+pOr5OUBOW7FRESsp8JyLtmcjNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJw/paEJ6nzgGte+s8L7IvbB13il9NcGedBySWf8Hss=;
 b=Ta2a1aiGY2f2HH4AkCJHEYb7UbjIPuEDzHkngb3F5H/iYxvHQVdGqcSeEOncwqBNWVvAcoi0dfQ1RezNgmDNb9kJWCjWOutJcoO7afJcQlHzkdoxJsm9lh1unkAxX3r6GmEdnV5XNU5OfutidBYCWJ2MJNOUz8F1gLXjrCPEceg3nkYl9ceMLG5E0mKslf5hD84NeElizok420T5PYOmY+P2k7S8pGGkjQfV/o4+AHt1FOxBMhBEISeKGrOsG6OQj94y5b+N/MZuAr/aiutUtIqIZDJVj4ih8oPiiXCeBqhIrzAFCu9SfhkgJirFDaiXoQJsgdyZj/WUFNQvotExIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) by
 MN2PR12MB4304.namprd12.prod.outlook.com (2603:10b6:208:1d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 22:45:05 +0000
Received: from DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137]) by DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137%3]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 22:45:05 +0000
Date:   Fri, 22 Apr 2022 15:45:02 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 15/17] net/mlx5: Cleanup XFRM attributes
 struct
Message-ID: <20220422224502.jfvrffw73f4qq2k4@sx1>
References: <cover.1650363043.git.leonro@nvidia.com>
 <5910e1bca2a5d34b8669b8ddc6c62943435e566f.1650363043.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5910e1bca2a5d34b8669b8ddc6c62943435e566f.1650363043.git.leonro@nvidia.com>
X-ClientProxiedBy: BYAPR06CA0017.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::30) To DM6PR12MB4220.namprd12.prod.outlook.com
 (2603:10b6:5:21d::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60c1cb4d-8001-4804-53c9-08da24b1be4f
X-MS-TrafficTypeDiagnostic: MN2PR12MB4304:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4304E4443CFB5BA9C8E95C94B3F79@MN2PR12MB4304.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghZf0pO5FnvR58voCiHS9Ls9JmhgyZ+bZE0te/iYqHocDQcCMABCSQ9BbK3xFA/hjMkb0ekXB/ACmD20hWAMvI70LRJA9Kws1YCqXD8tbBWrOLNp3ncPWW9DDFehItzfAbJfY8IXP92rSXQAX2aBik7e2xGX4jDiziUQ3UZ1L6H8rTOsbJ/H3ILMSFVNtzYHIUpuuTMCia9JVBlzh8XCVWq/Fe75M52Dd/6EFYTNjHA0qrmyhEl5XGWbAlUWIN+9MFvZNqMnwHqCVWlru76DLCaBo80bDdqJQmpYOqp5BqUs7i+UxEJ+ldMpBeAvUkqNBDiAqqQN2EziU05v7sZywDF3DWLuQwxIyi7o24n8JQnGn0+PvsUO2GUvptSavVpc+22WulpM6VohorMQTjwGTy8RwamnI6S4eoEkEVbvLk1o/61aSyrsXMK+4Dh9KZCLgTJs/T0DQatRU0kqdMvMx9iuMi7iS4ZsPpGbCqEeF9Ao+4rnkEhQM2NCDS2NWKsfehKHSWd02pERJLCIL+dzfkRHxy9pljbEjirsYpT5AngWgku/6gr7KVZJj1cIYHucIPoxfffTyrjF4ChR8EGHdHarmJ7DnLP0hCOnDaK5vlqA38otC4638YxiN8HU8zxFTnEhUF9f3qoeh19xrsdZlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4220.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(107886003)(66476007)(186003)(86362001)(8676002)(1076003)(8936002)(6486002)(38100700002)(9686003)(6512007)(66556008)(4326008)(66946007)(508600001)(316002)(2906002)(83380400001)(54906003)(6666004)(5660300002)(6506007)(33716001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N/0OfeXKecV2oBUf8FtEKzPP+uNkfdKum8CEfbdeUI8Rhau+JULSziqop/Ye?=
 =?us-ascii?Q?uOYAWa49WtOAkjBhM9vLIU3iATQjJzyR3HMXz45v72vErjyxYWuSAHs92573?=
 =?us-ascii?Q?/TbxDkZJcnQM8wRbOF/kdF/1bB2S36a/xxMFPHwDeZzjNAq+55t3tdtOyxLY?=
 =?us-ascii?Q?QXKlufaU8QhCQ8Tx7NchKK1UQjz55qUNiH6mfE+dInFLx0OaurMu1i38yfkq?=
 =?us-ascii?Q?+HvhoNPgsaF7L61eyOYqoO9zxoVnQy1JssQ/NQOx8yTWwqra7vUtOgNodKIY?=
 =?us-ascii?Q?/K2dsgvH7ztcW7md1C1EQNeBbkt1oeqjtaV3QutHibcXvZu2oZlM2t+q0FEV?=
 =?us-ascii?Q?5meLugl3msFi08s1jV+uprGTFfAiLrEUFv0Q6Fc23oYWB4teqqcoMmLmb/0D?=
 =?us-ascii?Q?ZUHm8eZPmLm3OM5kOAZoXd+MQANhL4BLum54JAumLTzp3QOjpIm3g8Tj2Vvh?=
 =?us-ascii?Q?c03SYTrDmHN6zM9YLDpY9pNgMgINh7a9+8wQn0Z+aVV0tl2SS4hO9NZyBjdx?=
 =?us-ascii?Q?yBWBHo71xXp6Quh5UlknGJ4lLKaNMZIy0SxndtN22SDx2hGj0DppEjn6t67y?=
 =?us-ascii?Q?/v4POvAqMJzybEtbKxLII1sud6FqoBK0jmCcPDQ/XwLQQImi11SW9uRzQQz1?=
 =?us-ascii?Q?Pytbi0j5B97uryVk+dEbR8rvqSfasIsbKFl+qs0jE2PPk0B1neNtOe978vQO?=
 =?us-ascii?Q?5USpR7FOijwOor08fWKiq7tXpmp8XsMfo09DaTLqyZkXCbIPjP0FdY0TWJHx?=
 =?us-ascii?Q?n3/NMov2NRHbLH4wquxHl9lljBho3hTdiu6qVSxhvdydXaJUHmyIV66x+mCt?=
 =?us-ascii?Q?n1Nmfh5CkeLD2tzzvay2drwiAMCHyQBpLdX0jLP3hd37S3yT7IubN2ySR+v6?=
 =?us-ascii?Q?KC4hneEZypH6thyfHkaZ87j+TNGYzNFk2Ud7mXHqsJpAZMDbsDoorVhQNUt3?=
 =?us-ascii?Q?WUMRBX3I3Snpt+cpCjzloqBQpHXmGrvMw9yqVUdUEs9zELgmSDqWXKv36fTu?=
 =?us-ascii?Q?dY4fbPU3Pbr2bim8HnSIxx51giQhqaXFEoD6R4ofZZgpj6vQ1rG9hNv7nbQt?=
 =?us-ascii?Q?TXe0n2nmlbjCjnskW6fSX7E/yPlfs69+vbsjvq0hD0QW9DvirF6jiWweVQoH?=
 =?us-ascii?Q?QBR05eeHr0t7w7SUWMp9A1Xfdjfyb26tLzKze3fMtBQa70bPsvtaZ1KF1jUS?=
 =?us-ascii?Q?Wt+SD4ybY7TxjQuM96ue7KhGaRRrMmihZScTXRBe8T1iiP2wfEWk9u3pLby2?=
 =?us-ascii?Q?B4zZTAAbljHTuF6yt9owfVk4mV+BGqO6o1F5fHSt9D9/CUBGTy8dogbtpTGI?=
 =?us-ascii?Q?SocOQoc/BiTis84UGqPx3ulbL8LiycyorCHIAf2G2eCAeDvcYWB9kTEGuFu/?=
 =?us-ascii?Q?Wdy/pK2hOcr0eFDZ0JQfUvWNBk92MPgKd+O06e2cAxLvNpZkxZZ8svmfybEe?=
 =?us-ascii?Q?lOhrnkY+lSEHTeRdLi0nircuym06pIE/8AQgRjFHwSrZLRxMNL4ExYsw26Sc?=
 =?us-ascii?Q?THgG2SYUa43KqCI9D+3IxmChL8BQ/fc2usAy3FTEwceja/JQsA416Dv8BTHB?=
 =?us-ascii?Q?YD00nnzjVYFVwLK6eIFx9xXDmYIM9BAUNfZBtKck50D9ovaZZz+pkovtx/iR?=
 =?us-ascii?Q?DkKyoelx0tkJEg2AC5CeNL8HSCe8QBmkUCxpVeMRTbUXNaRT2pnAwOacmb8p?=
 =?us-ascii?Q?TSoj1NIHFnNIOcYK6ET7plNuAptSvgaI0USuQ1M4IHdnFH1DDdcXrwn6EiQU?=
 =?us-ascii?Q?xUEyZQ3jaLhq5nuiQ7okbyza7bBfVYQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c1cb4d-8001-4804-53c9-08da24b1be4f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4220.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 22:45:04.8915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yjMlpGbi+v8x2RhLOLp/evjyQT/sVQLpzo3UrXcQqQY/LumIOoZ4wf198Ns2WSkAdAmeyrNEANa3txIZRHCcIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4304
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 Apr 13:13, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Remove everything that is not used or from mlx5_accel_esp_xfrm_attrs,
>together with change type of spi to store proper type from the beginning.
>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
> .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 ++-------
> .../mellanox/mlx5/core/en_accel/ipsec.h       | 21 ++-----------------
> .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 ++--
> .../mlx5/core/en_accel/ipsec_offload.c        |  4 ++--
> 4 files changed, 8 insertions(+), 31 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>index be7650d2cfd3..35e2bb301c26 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>@@ -137,7 +137,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
> 				   struct mlx5_accel_esp_xfrm_attrs *attrs)
> {
> 	struct xfrm_state *x = sa_entry->x;
>-	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
>+	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
> 	struct aead_geniv_ctx *geniv_ctx;
> 	struct crypto_aead *aead;
> 	unsigned int crypto_data_len, key_len;
>@@ -171,12 +171,6 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
> 			attrs->flags |= MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP;
> 	}
>
>-	/* rx handle */
>-	attrs->sa_handle = sa_entry->handle;
>-
>-	/* algo type */
>-	attrs->keymat_type = MLX5_ACCEL_ESP_KEYMAT_AES_GCM;
>-
> 	/* action */
> 	attrs->action = (!(x->xso.flags & XFRM_OFFLOAD_INBOUND)) ?
> 			MLX5_ACCEL_ESP_ACTION_ENCRYPT :
>@@ -187,7 +181,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
> 			MLX5_ACCEL_ESP_FLAGS_TUNNEL;
>
> 	/* spi */
>-	attrs->spi = x->id.spi;
>+	attrs->spi = be32_to_cpu(x->id.spi);
>
> 	/* source , destination ips */
> 	memcpy(&attrs->saddr, x->props.saddr.a6, sizeof(attrs->saddr));
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>index 97c55620089d..16bcceec16c4 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>@@ -55,11 +55,6 @@ enum mlx5_accel_esp_action {
> 	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
> };
>
>-enum mlx5_accel_esp_keymats {
>-	MLX5_ACCEL_ESP_KEYMAT_AES_NONE,
>-	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
>-};
>-
> struct aes_gcm_keymat {
> 	u64   seq_iv;
>
>@@ -73,21 +68,9 @@ struct aes_gcm_keymat {
> struct mlx5_accel_esp_xfrm_attrs {
> 	enum mlx5_accel_esp_action action;
> 	u32   esn;
>-	__be32 spi;
>-	u32   seq;
>-	u32   tfc_pad;
>+	u32   spi;
> 	u32   flags;
>-	u32   sa_handle;
>-	union {
>-		struct {
>-			u32 size;
>-
>-		} bmp;
>-	} replay;
>-	enum mlx5_accel_esp_keymats keymat_type;
>-	union {
>-		struct aes_gcm_keymat aes_gcm;
>-	} keymat;

Why do we have so many unused fields ? are these leftovers from FPGA ipsec ? 

>+	struct aes_gcm_keymat aes_gcm;
>
> 	union {
> 		__be32 a4;
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
>index 9d95a0025fd6..8315e8f603d7 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
>@@ -356,8 +356,8 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
>
> 	/* SPI number */
> 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters.outer_esp_spi);
>-	MLX5_SET(fte_match_param, spec->match_value, misc_parameters.outer_esp_spi,
>-		 be32_to_cpu(attrs->spi));
>+	MLX5_SET(fte_match_param, spec->match_value,
>+		 misc_parameters.outer_esp_spi, attrs->spi);
>
> 	if (ip_version == 4) {
> 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>index 91ec8b8bf1ec..b13e152fe9fc 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>@@ -50,7 +50,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
> {
> 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
> 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
>-	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
>+	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
> 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
> 	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
> 	void *obj, *salt_p, *salt_iv_p;
>@@ -106,7 +106,7 @@ static void mlx5_destroy_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
>
> int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>-	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.keymat.aes_gcm;
>+	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.aes_gcm;
> 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
> 	int err;
>
>-- 
>2.35.1
>
