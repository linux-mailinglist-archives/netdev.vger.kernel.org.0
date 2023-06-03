Return-Path: <netdev+bounces-7639-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F657720E7B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 09:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D2E2281B6C
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD78ABA51;
	Sat,  3 Jun 2023 07:26:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD3B5C98
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:26:22 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2112.outbound.protection.outlook.com [40.107.92.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DF9180
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 00:26:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7Djsd+TmZCaXgi6C3m1q1LkhwezheaDWW4oJ0CLpZ+RBv/Xc9pyCkXf8vOEWZ4UQnnEmPrkoSvxUjgkUBlY5oeHm+5exES0+N/lX4JC4rnt/5QD2xk8Tg8CRz7yYKWxzZRwBV2vGP87K3E5xosSPejgL6nv2F1X7i4oXWVbHWs13dOLv1wAumfXu64Q1ROR91eVdsmC6X6+PoglzQgSuDpA4zbyk2Cp8p4/IdiW0lwzSMlibOX2Xpl5zQ8BCGburIj9ZUcLO2H/cTuShcNXL0JUf3avvbl6kJwMkfRM1Miy3YyPE8ULNhWRzcuYEGorKOGrp0L+d6gC5BmbUqB0aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldhMCEQP3VPjrVgot3CAA+deRYpQN0pHawyKflBTFQw=;
 b=iHwpzE0e89kwU8NQsIk+T8xXzRI6ZMJVawunKf6JvGyl4g3nywcFUp+El+neH027YNwtYdU8v6icApdlHBx8WdXDTyQ6AM0gfHYOFZwmoNrVpMRENSToTuS7nOeBXKQY6AU8mLZrpdcOGN01V/wqC57gaDu1+pWMtt6aPDwqcccvQ5TNcMQw+kiCKIQ6hqX0dNHsLaBuY5atWhwypmwIfWizykLScxsH9FQE7udDw1GhwnwRdGcZKBlaLw9bPUFfyOuYajzTCibesqDgBQgDLZXrnGzJaWhWpYSDFSQhxmfFepDY9NEXmDsOBPZPwmosS3F9qQlRZwUYKMQ3MnsXJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldhMCEQP3VPjrVgot3CAA+deRYpQN0pHawyKflBTFQw=;
 b=BxxWSxMbopKFA9vby6xh67+JcviF79Ax1vygehbSwzSLS4OjJZO59YgKlUFX6igSXP2ZbNZt2fxYxLrYEqWFxJVYRVhemA7w0w5XtIv0zdga2G/4K1iK8VnoB5kyY+yrTVhaTLFFxu17PGywOb4Pl4UWbpmVLLWXBuynFxR2E3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4644.namprd13.prod.outlook.com (2603:10b6:208:328::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 07:26:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 07:26:18 +0000
Date: Sat, 3 Jun 2023 09:26:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Saeed Mahameed <saeed@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net-next V2 00/14] mlx5 updates 2023-05-31
Message-ID: <ZHrrFEAfeJy2HbQz@corigine.com>
References: <20230602191301.47004-1-saeed@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602191301.47004-1-saeed@kernel.org>
X-ClientProxiedBy: AS4P189CA0025.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4644:EE_
X-MS-Office365-Filtering-Correlation-Id: ae976bb2-cf49-4dce-9232-08db6403d295
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fnpJo3ykouiW6lZ+T88t7lv69At/fvgNZNHN4pWw7Gt+B4x4ZAoSdTVZgiCzWmOnYfHXjHj9dnEcaMt9tZLcGUXrMdu+QRG2T+dE4R+p03xkgNfEwDOumJpso2ynKD2si/SY/3xEUpgLDIie1eR4U31xJqKIAIlo1aPb6jk/tWCzqb0gBwStGnjzRNrwe9xy/ydW55hnEXjBv52cyjt4vsuPrbha0dlrf4eapEDTwEcrXXHhrh7N0zWiG7ALUA1Cz1UkV9KQnQ0fsrfy3Fn8E7JRYc7fZBMb646GOSsb8jGm1yuofJqG4IWfZd52RKouALvY1Mp62tdv9I/IxFIb7Htx6corMKdnO4M2cmIwaH7RSoSI4thZL7XSlpm/8XP7GdEk7GhN7kdYY1dQGfOVqmuABeJCLgo5ftsnzwBAr6bNm4yzSmg0shJL413IejDguNJZoJNyWCDX0lMAgI9fcLaLmIWoRuvcBcscwZpdhl7LMmjguS+nYCWjiqkv1pt0lfICvz3Sp8+/1ErUw4prLqKJybdQ3/rOZXCEzeabX1s9+CY0Kk+isOgEGHjrzHdr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(376002)(346002)(136003)(451199021)(44832011)(8676002)(8936002)(5660300002)(316002)(41300700001)(2906002)(66556008)(4326008)(66946007)(66476007)(6916009)(54906003)(6486002)(6666004)(6506007)(6512007)(26005)(186003)(36756003)(2616005)(83380400001)(478600001)(38100700002)(558084003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mzdllSSzNc/eSc2r8+juraLQ//rSRttZqG1Ne3coGA7cgu4AkRIvf5B1a1ER?=
 =?us-ascii?Q?K565huyoX9Wn+yqOxt6jXv+XUPuuVrPV+KYyJ/sMeYBqNe84YrpWbdNAHMUi?=
 =?us-ascii?Q?37Ygqgxia1pL0DxYvLcZGgAPeiOsWZvpWY6a85YAqAxcB22gRA2+mOOEQECn?=
 =?us-ascii?Q?YlRC2LXgT7hgfZ5RmeghFBX/6Zje1o2AHI/jDKGzduGl9aht5Q1mO+65Upre?=
 =?us-ascii?Q?SdJ4EMyAko2vAVW8cTbWANV20jvEriU1kSR7pZHqPjSC/yFQI+ePISLiMpeg?=
 =?us-ascii?Q?WTCRiu6I3FMAOplyZejPjhAvvxg9xo3i6B/VpLiluPy4YPyuX/PYpGJIZ+0L?=
 =?us-ascii?Q?gtNyoP43gmhhPu8sFKpt+IRe+PI3foaE/98Ygf0gSMp8lTX9Tuol1wZibmkA?=
 =?us-ascii?Q?t9nEZdaK1fM3PzUqAq6tFFLEL+4RlD9LUvxTHX9q2GZHUVbRSMFFOu5xdjLC?=
 =?us-ascii?Q?7YeiwAYu3BsCFbJ0hGNpuIMAr9lkHvGdCgZ/23IJcKQmr7jbOTUAcgWUrQ0G?=
 =?us-ascii?Q?4WXzye6Mpmta9H5T6uPi9bgb+WVkgLqwlHwfOl17862Qo4qIyrlnIQU/xH62?=
 =?us-ascii?Q?gnwANw8te0FAqXHHTA40Yf5axTkfZEEUQmWJgdQNvxaUroW/2mIcYiaiFI6r?=
 =?us-ascii?Q?3V4pOK2RX5jCW5QgJOLWGeTicOdYKu/XZReaCd5WA8O3nrQOb2eGzN56M08a?=
 =?us-ascii?Q?sJf5D2bcCnw31AvfZ4Ewkbec8zjFcIQOqOYxB8LxU1PTeYmFjsumcqOhRBhn?=
 =?us-ascii?Q?4gUB25OR3uH34DgwyDmEGN1zxuHi4I0DR0sG9uzxym7ghnK7iMIbqa5WbTrA?=
 =?us-ascii?Q?jmPebVojqPBIr5BTP3xWrmdNcWD20gDR9FaXvtK+3oxm8scy8bj+V1L/ssOF?=
 =?us-ascii?Q?N8pN2uRbuITz9ishuvH5nKZhoFyeQt8w0hzkclyp0wsReKoNLPmaVnZCitiN?=
 =?us-ascii?Q?QNeTsxWbh3KZjp09S1W1FywtTQZEpScunvME2Tk6BEbWWOby7XMh8SiRAghq?=
 =?us-ascii?Q?DFb8GEtRKz2wBnbsvwXa6+StG3j3faNMOB8kXbrHgaF/qyahKUf0UH1XIQoh?=
 =?us-ascii?Q?OQoBlrCwcwBx2hluRidnGoeOfBK63DLQhhRuUarpBGAcxG4G6H47Ef4bSG7P?=
 =?us-ascii?Q?ngHH3nMePhwFYJCLm52uMB55QTDc91nFtZDCaFYiMZjfcwYsLgWB6koslve4?=
 =?us-ascii?Q?mGh/9fYdcb/yPWF0ASZ2PnJt7bDqr5vxZRuKuOWzoJpXIooqqUkwGvi/PEZ6?=
 =?us-ascii?Q?8B7FZbuMbJdDJHsJ4BbXauSkfP6cIXPindsbvAVErGyfryG5bq6dUQ5pKT8c?=
 =?us-ascii?Q?YrOa+9hLyQUuMoN4sRT/IDB5EOVt60Cjquioy8JCRwqoOLsa94zgQHW/kUnI?=
 =?us-ascii?Q?2hQ9xhAHc4rcdjzfHDiunqNkZreSyKNPjV56Xn4w3QBak2bf8X938RQMzgXU?=
 =?us-ascii?Q?dQR97XvFo1gdMy9XzmIo6rTwhHkIHykbnd6dpaLXvi1bVY830s4gDN7TXpMB?=
 =?us-ascii?Q?DiYlslRMWpCWpLs5hu2s0Ui9DW5YufgEwNXzstUyTZHz1hdXAeowfMyqBBUT?=
 =?us-ascii?Q?XLrC003XabT0c6n+4vKujTTOadBFeGAo6FOcwyS/xKpRzOB8sKwoJr6ZLKq4?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae976bb2-cf49-4dce-9232-08db6403d295
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 07:26:18.7231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KSdI6JSBWeJ+hI6DpZfvq3B6dQdSc5vbeoDCS/lOn0BHLYqZgOQgbThzCRuEBwoGMvJUSn2znVM2Oln2UI0UBkKRiYh10BChfRyrTFYk+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4644
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 12:12:47PM -0700, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> v1-v2:
>  - Fix error handling issue in patch #3, Simon Horman.

Thanks, I've confirmed this fix.

