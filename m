Return-Path: <netdev+bounces-11129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B94731A35
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4058A1C20E7C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B42015AF9;
	Thu, 15 Jun 2023 13:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DA6156DA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:40:23 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2108.outbound.protection.outlook.com [40.107.223.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AC72954;
	Thu, 15 Jun 2023 06:40:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyiR1/tdHbh3DJ1r1DtSGIA48Sw79Q60WUsaUXwgedguPsozZA7/Y0haUC7FbRc1j8Q/xxT+A0OvdGH+mtQ5bzFeDMggX+3Dbp5lFpeMuKOyL62CHiK0VfuB7Za+WV8hAn2eBF9TDKNT5Kzhf5fPTWu2pxLLbit+NUVMo2nS/M67m6UpjDcWuadXV8AzsFpMpznXrSgmnT30yRyzFJNKUB1Xp/Y00uMaWBH8SqJVvD/fUjzUgjzq/ASzGuWmMdpAhSxdsQFldk50Rm0E3AYRsNbv/Lk5z7RoV+rDTYwCpxRbkjbGeS/p3KLo+m6qti+I9GUZRh4aOe1NtFIN9XhMcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfxIArYinMjtkMUMvXqndtaWULriwqfrY390ftMlokw=;
 b=lul8HodIHIosn/97pjMDQ1Hp+Av0Nrn5QLR4J9L6TyKL0OWv1f3N0Ah4S81iVIEq+exic9zm6ips62Fi3fEmCJIj5ErwVFx0Gn9YYNO/DMF9k4s7f3O0xytun6p/yEEckeMMCUM9xliBOl8lA9fZL7P6RlGpCqwUPFpmHHSFsucH5QIumPS9vNIPXNVL2Qg+9BBziBtbtDMUNc6ae7oY4AYgqi87gr7x9u2wgidKsMPsIP2e7Lpn+RSwSU3ykQ7u4yGrDRMvvEzOKmrz64BPXHw3OOCkwvloJntLWhV80PrI+YbsUwCTwKZzaCnAmUO+31OMWx8hUqIXC3NQ+1c6zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfxIArYinMjtkMUMvXqndtaWULriwqfrY390ftMlokw=;
 b=nhC/zvtw9hBbqy3I86d2ICThUVB/cZOZ+YkPWNnYo0JaPFBpgYItbfrPi67BqXJzbtdVHERAHArpiK8BlrsH/uBGVJzxoxgtLuhH+mkamvVsdKswjcNd5rEhPY43Atx84MEb0ZfegylcPwPFS7hb7kZrHjLHY8+usoudPxRcWG0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB6030.namprd13.prod.outlook.com (2603:10b6:303:14a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Thu, 15 Jun
 2023 13:40:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 13:40:18 +0000
Date: Thu, 15 Jun 2023 15:40:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wang Ming <machel@vivo.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH v1] drivers:net:ethernet:Remove unneeded code
Message-ID: <ZIsUu4pUVyGRacHe@corigine.com>
References: <20230615084110.7225-1-machel@vivo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615084110.7225-1-machel@vivo.com>
X-ClientProxiedBy: AM3PR07CA0055.eurprd07.prod.outlook.com
 (2603:10a6:207:4::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB6030:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b6e0493-58c7-4f3e-b666-08db6da60ebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	df3R5xCrLqrYF9txViR34D7TOoe2T6P5wXCpl13NJi7BBwYzkAfsO6SC0q+wSdiU6/YVp8DOR6UUkP9+cqhMvhVqCmvhpujJvmX98ApBCHnzLIZ1bppxB9S0me46K7vBFzQGwpA78u6oGglHEAblf+zFKK7MZH4+eRtv+tro7yAIC/nlOygvfulVby8vjbiCfDh31Xum/M8vTAFsUA4kYcC+Mw88+T9MC3+17l+StiUZNZxrW5Mn/WjWgzVls8BJh74RcYYun7KRWzOV1XlgDOmZPNGBfG5tUWGG45i8yC5LORHc5mMQpf/XBC43hgpsx4b29gcBUfkiFSG4WPmpc+F0lBv4sJ8wCOcSZnFnat5ggCQrUEGnDCz8mm1txx6kkrumu5eEJDGqgNHvmei6qYzFuppURieqsxv+tQVSg5DmqvdtdBY5qtxZzj/kaIS0Cpof5i4uAkYw10AFqHAbGh9g9TYFW98r8d7R8Kd3VWFf8479PeMEPqMwoP6BJIokJcFyIlkHD3/8QH7s1OGDfgdcmuDWVlcZ2fnlwcq3SCBvVlnuzujr03GxbyZxmnZVxZZdMKkbI1OZ2eukES/55ViWQ8cPQ6gHJirXNCLRmpg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(396003)(346002)(39840400004)(451199021)(2906002)(6512007)(186003)(83380400001)(2616005)(6916009)(66946007)(66476007)(66556008)(4326008)(41300700001)(8936002)(8676002)(6486002)(316002)(6666004)(54906003)(86362001)(36756003)(38100700002)(478600001)(44832011)(7416002)(6506007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XIrrQwUm3EespvKblzwYfNoKIg+ajRKWuUEbjEuFSPfQS70Ts0GDuOqLQEZu?=
 =?us-ascii?Q?eDopZd2g64wypG4zLBrXXlQlxcig+wj6m+Iu08zsDEx0Om8A3Uf6gx5XhRlo?=
 =?us-ascii?Q?SWmSxpkI/j8ceCQTM39jt3THEFuPbu0o3fihonNEnH0tz7Ve3Gu3CczGlnWU?=
 =?us-ascii?Q?XWyfu9o7LG3vV2B37W34qHjOp2k2GRxo6lF1U4BpbAv0I8mH+BWoFVnVLhXL?=
 =?us-ascii?Q?Bqw4e5oGzMg8NYBk7ftX814/aiKWk18P6W8YWqtf8IW6ma9Tc4SuPEqrrn/D?=
 =?us-ascii?Q?cvxt51sqFHPBF6zBoh/lOuJxz7Ds+YeCEnO9O7U+/VOMbUkgeiEeFfTFShAI?=
 =?us-ascii?Q?I7h2KnXxJgEgpZFBpeVLHsV91pUr7uvFIKbUFR7ypOQ2X4xG+faFFT2u2uQW?=
 =?us-ascii?Q?mhVaJ1y9tU9dCQaqVh9VqosOeScDvGJ6SsmLLQ/7y/MrIl1zD0XkUN7SjDR1?=
 =?us-ascii?Q?r98kdWOvJfZIwn/pxmMKkRuDYsHwU6+cSnpfCKtJkV3LHlLlHYG11MNyaayf?=
 =?us-ascii?Q?kWoxDi1Az3KFaR8nxL7Gqm8LL6+v1i2oD+ZVRWvljEfqX2aRmaBL/L1tnZoo?=
 =?us-ascii?Q?nw/y6eIefpwa9L0oFIVEYfvU9ljnhy0EBx2b4tFlCt4+xX5cY2yFVv/Ma/iE?=
 =?us-ascii?Q?6QQPaFLzQfuuIWaNPq+4hJHh8zvLQbKEdkI9ybKA/EJek3HGQNq/BpyEv8n/?=
 =?us-ascii?Q?d6CtCEXIWDEKpZIbHmRV1BfH3/6bokLlEi/J/L8T/xb2fiXZchXHNN3pHQBB?=
 =?us-ascii?Q?sda5/IrHkdFAOKgZtd/1MkXbXyOrKvkkihaNxVHsBtC/ZQWLeO27vq4A6X+1?=
 =?us-ascii?Q?czRQ3m9zovh70KO23mZk/XptJEr7/Zwyks3ddWTNwx59+LkpkIcA8yRGhD41?=
 =?us-ascii?Q?BbpjnwIqzMogtPZrQSXF3DQaRuxJ70krSRGsladMujw8g2xR2EIERl9wJgj3?=
 =?us-ascii?Q?p1pRiWTqI/bxada/IDwRIFnf5wWyrs1IbLj3QIns91bwHpoHAl0D2CK6g1a5?=
 =?us-ascii?Q?UkSSVWYJCLQIezuARo0OMl6Ra+Sv7ypOZofpfUnQ8R2YzFM8uUyZ0avhsSBH?=
 =?us-ascii?Q?nPmUllLtvOeOkzntx3b5lzqSE/dr8YlOm1d1xezrdQHhTA0HNwY9QRjvhv5S?=
 =?us-ascii?Q?9HheydutZumBKh81919skO7Zk9nUKV8EMDhqdIsUvAbdsjBjkoQ+cenWFgcr?=
 =?us-ascii?Q?nOkCH2ywnDML09SnipgsmHSmX8nDOrJMb40TIwZg04gi/sHx9eLEjqVtwE/S?=
 =?us-ascii?Q?O0AalbQ4i1Ef492vS5qOB9LHD6oI9saKSqEnqkXnZ5Ry52Peb+ztZbEyqJGR?=
 =?us-ascii?Q?I4aWeaVy7jb5SZfXl0giM+ZWwGECLavr+nQVr5C7MWY12V+6+pecyRl6lFga?=
 =?us-ascii?Q?kUZykGBL+Yrkosj2/inQqMpCe3SVH6ui9NqR3FsSv5y7Wgkb/9ALy/hMt2nA?=
 =?us-ascii?Q?GDDJdGkPeKFwJVDcuzNVCFos181rQEgrBnCVCF5bwXnxXB8dwvKOOrw/FxHm?=
 =?us-ascii?Q?B+NdMAfNI7FiNovq4xIYtm/WagZ5FmPMoC9fGfCYN28C2tRbgvxHIGGKOGVa?=
 =?us-ascii?Q?g3xhnpn0N7vqOaW+3z6OeyhFsNZ3vs1P0X2G069nvnQMQPlEX9se3SuC6IW6?=
 =?us-ascii?Q?Ex96b6ZPQ68wcL8pHr61K0ngY0R8Xvk1OYJ48sv5m5G4ijYSq3reMa6wxI4F?=
 =?us-ascii?Q?aZGJkg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6e0493-58c7-4f3e-b666-08db6da60ebb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 13:40:18.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNHt8FGWWldH65Uh7DsQyJJ/vaiFPHi+QGYlcV/Vk1tWUrQAxwPJyCuAQ4lVFru7YWnDtR876H1+WgzQtq9PCNFg4iNiGQo0zLSI6EKUP5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB6030
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 04:40:56PM +0800, Wang Ming wrote:
> Remove unused helper code.
> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:808:34-35:
> WARNING: unneeded memset.
> 
> Signed-off-by: Wang Ming <machel@vivo.com>

Hi Wang Ming,

unfortunately your patch has been whitespace mangled - tabs have been
converted into 8 spaces. Possibly this was done by your mail client
or mail server. In any case the result is that the patch doesn't apply.
And unfortunately that breaks our processes.

Also, assuming that as this patch is a not a bug fix, it is targeted at the
"net-next", as opposed to "net", tree. This should be noted in the subject.

        Subject: [PATCH net-next v2] ...

Looking at the git history of eswitch.c, I think that
a better prefix for the patch is "mlx5/core: E-Switch, "

        Subject: [PATCH net-next v2] mlx5/core: E-Switch, ...

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index 31956cd9d..ae0939488 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -805,7 +805,6 @@ static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *
>         hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
>         vport->info.roce_enabled = MLX5_GET(cmd_hca_cap, hca_caps, roce);
> 
> -       memset(query_ctx, 0, query_out_sz);

I'm not saying this change is wrong.
But I am saying that it's not immediately obvious to me why
it is correct. And in any case, I think the patch description
needs to describe why it is correct.

Likewise, "Remove unneeded code" seems rather terse.

Also, FWIIW, I don't see this when using coccicheck.
But perhaps that's just me. I'm using:

 make C=2 CHECK=scripts/coccicheck drivers/net/ethernet/mellanox/mlx5/core/eswitch.o

>         err = mlx5_vport_get_other_func_cap(esw->dev, vport->vport, query_ctx,
>                                             MLX5_CAP_GENERAL_2);
>         if (err)

Please consider waiting for further review, and as appropriate,
addressing the problems above and reposting your patch.

-- 
pw-bot: cr


