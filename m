Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E9759714C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbiHQOcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiHQOce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:32:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600CD90C4F;
        Wed, 17 Aug 2022 07:32:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTPSTr7q7cw157Nfy0bvux7SYWG9fk4c2OQCTxPhEvuckIH59xuA1DNM3Cdnlxi/fu1hXfI5yKJlgzOSIvM3VdoBuqvmZCRDhgNXIqWQOh/P8QOkCE24JHqWKMAxd+mSpQxvfRZ8H/xbkGAdCuNeBRxYTRT4JL/v5c9imfXdudzu16cyVq6ErXj7XhCwjJBpirhtjGMztzvJiPYHM76kMfp/fM1AT0JsbjgXzcXxtMGnyVLF+V+hoG69nw/KrKtDz5D/V+I4bb3Z9XOA0QaCMWHVP0RIJ0QEV2XJ5NoklsOb7uaoP49NOmqH9MOfhvTIIb4TnC+iQrOrr93F+X+Ilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TG34qLKBrux2KYHsMPFJoH45Yj+fqC5EJhaY4KYt4gc=;
 b=jcSFcU7i3DfBmmcwn3lqjx+D53P/A9Y8QJZRtkCvqq4GrFe60UKq6QNp8ic5YmiHYzcQ60VLd3M+3dx2jDWE1qXk2u1/2qzW7QvmNm0OPHKOCIHu23OcfBvoub+oDAqU7wTjcgyrYvhxFijLKJ/AQdRdHSCA2E6l/VoZqkwkXPtxZ2Tk4BzGKgnoeM6ru6SGuHmoV2bjV1Z9Wm7n6v2SkkrckvN4RvV866XsdBMKwCUtKd7rxNkDhMf1S8w8TiHo7pekNbN14NyRjdTWxGjGEMETK8waR4D0DBjYV+8yhWShBv+Ztk8ndGWfCe1FTfpC0veFnYxcKnAWKQGO2Ru6qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TG34qLKBrux2KYHsMPFJoH45Yj+fqC5EJhaY4KYt4gc=;
 b=I0o+Wh+otYLtLc1GjMv9o4ubRka/AzrhXxxHc5kD2Ppu5PJL6gFLT4mh/AWJhKioMt6GWusWCpRQ23Td6RqX9nIYsvmlO5KHOZZq6aB1ocqtV6w0b7FHQ4+M4XlysmbhQKrmkhmxuWbGVxe0wxCAtXGMYS2q2siSAV+9+NhkU43SDizJeCiasfwyMVqGaApkl4Y727FOOq/rYH2YgCgyW5W/j/3g2FBc7v3nVwd/LM14FY3Ny0RokyAUD006gjCGPgDHMqeiFnBeu4Md1VFVuVYVT84qpFA8dx7mOwsiodHwiuejqH5oA/It7kdrhELhEUAhA9RBsHz0GAhMZsO9EQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM6PR12MB5534.namprd12.prod.outlook.com (2603:10b6:5:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 14:32:31 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 14:32:31 +0000
Date:   Wed, 17 Aug 2022 17:32:25 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org, vadimp@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vadimp@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v3 1/2] Revert "mlxsw: core: Use different get_trend()
 callbacks for different thermal zones"
Message-ID: <Yvz7+RUsmVco3Xpj@shredder>
References: <20220817130227.2268127-1-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817130227.2268127-1-daniel.lezcano@linaro.org>
X-ClientProxiedBy: VI1PR06CA0197.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::18) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af64892d-4a50-440b-c0ca-08da805d5165
X-MS-TrafficTypeDiagnostic: DM6PR12MB5534:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vj5RzHBHxy85AYF/efd2La+eqd9q5hx1vVCN5y2nbO2CvgubStG3HN5WAxgNVSKONzZguN7xH0bqm+qLDpyBrP0Nq2bqfoxKHA5PZf8ThUcwpMjDlY0MmgOPdknrzNhva5eDj0Q8cniUjOShtBgauj0Tk1kZ3mhiVN/qkgXCpqAWOmi9+gnUnKO+SsMcwNfMi2NIKAnjzL4oggVyjDDidM78m8Ezu9GjBz9l5GRHBfiG2IiTciSe77yH9x/kO2368ltsiGP5bsa7Z8SJldYPkZz8Rxg0tLxGiHo+iZohb9JFWAMSFcZu0Fg522WrSJuP6h4cAfgBLbZYujaDTpvmSlDHKJg7j5GV11hIKSTBm5GIr6S7exqFBK/5MoFKotuViBP+UBt3l3bCNRLz8adn1udkA7jCpFkfV3XZGB/1R760TkFb1s7UmjCU1t/g+QBeLxLga3Jiac05fJXifYNVcS7TjFT75KtVKNVC9jJkw+Fo/MKdQe6iUPNQjS+oJ3bLzASilYZVz4WsyUMNTHiavcyyI9yD290H8ZTUtuu1Z9jvm+gin7DnLmwmbWjvsj4rinXweC5nNFZP8e1Rv2Fi0lNoN87d2x2j5/7iK5zaY5GwK2wzDOJ++ydtPvtwx/T7jVNQRuNL115jV52fP2Qwe/rW0y73O+pihntFvfI2WDTHKj6gsXbwpfnoAgweimWwE53P5LY41cdTecLV5Q2TofE+1Ywrm9yYaDh2ww1jfJiUf6y3OsbXS3v5Z7uUhmy69Ny6YtojxZf9llDvMYQanHE4Fm/FWMmU+A1sZ/kUSeKFsHu/w6fcKwORHxIe1/s9rg3wr44gAi/prgdEOOHFsjozXaj5KbsGIRTU9zaxek+9VC2J+7qewcxiJB3bVDp6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(39860400002)(346002)(136003)(366004)(396003)(966005)(9686003)(38100700002)(26005)(5660300002)(6506007)(6512007)(6486002)(478600001)(86362001)(8936002)(66476007)(6666004)(41300700001)(83380400001)(4326008)(2906002)(66946007)(8676002)(6916009)(66556008)(316002)(186003)(33716001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?igrjcZd9kvA8w9ices4dJTIDgilplO12nwWrYCdfgcQp6MpXYFL14WVqDVcB?=
 =?us-ascii?Q?hP/ClEaJEdJ2/DUoGXHcJsxAGEw+EFZRaSEzrak5tyZWYBo22YD69t/XDf/L?=
 =?us-ascii?Q?T9cTFYdPrAEgLJ4cxuJE1NPegQ1UsBh8oHpHkpfcc39iMF7Jhkka0YwES7Y+?=
 =?us-ascii?Q?dl6lVXwIMz1/UMMczY0bmDjYQ0Pqlg6sVt3ssPzl/0QDXlZzr8ilQodnuIob?=
 =?us-ascii?Q?BM/1oaeZ2j4oSRZ7GBH/pC5ubTaNnjNhUM3cFgT3P5ibPROxmUEhtb2LCJ3i?=
 =?us-ascii?Q?0Fk4kHGUUL4edQ3S8KFb9E2vAsWaJ6hcKJQdZOan3LvBW2YudSBIN1apBnT9?=
 =?us-ascii?Q?GL0StNuSNkXEAx4WJa9qTOSDw3RvNjdT61zEtHuMgr66sbX8zIwYvh4WzB+0?=
 =?us-ascii?Q?zCtGFIm8peiiWnLn1JQqIf7Cx0PLK7PpGtXZOcwilQykFoovdUY+k4QNZrfj?=
 =?us-ascii?Q?1RshoQXvCua6xtYPeeQRtvHTYOY0vuG/7d1KzNvktbHWwfTiruW+MbO7q46l?=
 =?us-ascii?Q?OH5xsCh/SbJpJK3aVvBIdfN+LUQvDaDIjJfEGCiuiCi9bXsIu4I2TgbqWxer?=
 =?us-ascii?Q?a37ab65iVlqC5nLn6mQ47K90C3Yx5t0y8PaCnqMcqYWHuRlnS7Xk01WDXaRt?=
 =?us-ascii?Q?t2HXOmpZutpKrXf8ljDG0T6gk85x5Wppv/QUCueFEa+NY/omgo10cR20A8M+?=
 =?us-ascii?Q?8J6jbYxmaymC5lL1Agm05z6wj78dW2OMnqZ13XQwWKnescA5jjrLVQYWaZm6?=
 =?us-ascii?Q?CBYyqoUfl5zyOj0iCIPCT9NlZa8k+jcJQlvf1psFSzaB3HX2aA2UtZvVFvgQ?=
 =?us-ascii?Q?rj/HPQdQpvc1GgxnczzCyJyQwjo7RkWqbsucB1acugChLQA5ytFkvn3JyIwc?=
 =?us-ascii?Q?KYBcJSD5gWtc0sR4oW2bB7g5a70qj5xS9LHzuPnBdHDql3O2XjWwK/ZE8gAl?=
 =?us-ascii?Q?zU/jKPZDDqxKJN7wHFS4s1bJOMwILMUUjzHPpiEkscmG8pZgE6MDEjNSqCYF?=
 =?us-ascii?Q?GxM1wx8AhzeaJLlDeZg0QDXpTG0SHiA+LbhiiXF64D9JyqGM2lXC/364JGQK?=
 =?us-ascii?Q?YHHMo9n0T+zcXPw6+rjhJGTKRAkXFtcRimgC49NkZAbqnkWivDZH9qR/7y9J?=
 =?us-ascii?Q?HCcaocTQvYjENAhyoNT2ofIIRPROLzWAO/BM3nGE/rcsjTXQLkaLsf9vjnWW?=
 =?us-ascii?Q?ERwXxj48WHDSa77zLiOBn6rfMnO5EKFIr/pVQBRYJMWNKK9+qMhpF6OeEnu+?=
 =?us-ascii?Q?fdSDh8bYPyrpJeWKlhiNdhr+FlFmVIy9b8rcDPKqDK/VSI0NLsG9v33AJ47o?=
 =?us-ascii?Q?pPo5qUPaPz8UdOa4fe5X3D7de7Rp1I5C8uldoSZcQYntitV759ST75juSCVL?=
 =?us-ascii?Q?Q9UDwp9EOKUDjAYsXJ+4lxxzP01CchtmhIiigwHP46wcAVhTrN+ns9eJXD8y?=
 =?us-ascii?Q?MFOAnp4jQ5w5R50e+ByNJHC8//eZm3Lfe9U/5lHlMagrkjAaRTq4LbTDhP0Y?=
 =?us-ascii?Q?eyPSmOqdudwwxZuIQtsPCarYa395DV/Hk42b03viMu8ndhXBg2DfEp6MjFH6?=
 =?us-ascii?Q?wFNOfnCaCraf5IiMTzGBztd4LWbAqMX91j5Q+0ZK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af64892d-4a50-440b-c0ca-08da805d5165
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 14:32:31.3846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jA8vyTRINGtiOEQLDqMUfDrsNqId2CGFpjM9qmXaEUvJN9MO6H+Vl97kjnNzeOTpxN7Scjq5pxLPVC7a4UZOjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5534
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 03:02:26PM +0200, Daniel Lezcano wrote:
> This reverts commit 2dc2f760052da4925482ecdcdc5c94d4a599153c.
> 
> As discussed in the thread:
> 
> https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org/
> 
> the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
> actually already handled by the thermal framework via the cooling
> device state aggregation, thus all this code is pointless.
> 
> No conflict happened when reverting the patch.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Tested-by: Vadim Pasternak <vadimp@nvidia.com>
> ---
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 23 ++++---------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index 3548fe1df7c8..0eb52665b994 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -352,7 +352,8 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
>  static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
>  				   int trip, enum thermal_trend *trend)
>  {
> -	struct mlxsw_thermal *thermal = tzdev->devdata;
> +	struct mlxsw_thermal_module *tz = tzdev->devdata;
> +	struct mlxsw_thermal *thermal = tz->parent;

The reverted commit is a fix, so only reverting it is a problem. It
makes the get_trend() callback assume the wrong type of
'tsdev->devdata'. Patch #2 completely removes these callbacks, so I
suggest squashing both patches.

>  
>  	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
>  		return -EINVAL;
> @@ -546,22 +547,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
>  	return 0;
>  }
