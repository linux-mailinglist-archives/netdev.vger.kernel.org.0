Return-Path: <netdev+bounces-9468-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6FA72956E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:37:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60516281884
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A159F12B8F;
	Fri,  9 Jun 2023 09:37:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4B512B87
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:37:00 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2117.outbound.protection.outlook.com [40.107.237.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA34A30FD
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:36:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CAbciuavA4RKJROdOFAIWG9b6FrV8XceBEWRC8Z6TJdy9++p7vF2Hs2u1kOip5Xb5c1bgrcg1kyqoIcowRk9L2uVYPQG1s3FJwqPjhtszfozumqlobwc9WiabqVxx+yHBNtyJps+clZkGmOiIZIiYnKWkVMrAWPsMCRp8AglI+rE0OSFIkkWajmBXUhrxLEYvpEozjH4MTAreTapYbRH1f0mDR2iLeLhYQk0L+IR7SE+DckpHSU4eKemq0WLd4Pz1BnqHiPU32VUOftALp3vbhLXKJam3tB3GL6idCzc2fPjp5r3u+sZcLj1wrRE4Lc9YooFHemIwjAGFUYqIB7KCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POS/xSasnYiRk5VKRE2KgiNcJM34EdWcO2BRa8T2e3E=;
 b=LO12AXLMoxnK4YMqE2u+0x8gK9W4vH4mPo0FRv6LOhWJcL+Rzx/BSNWD+yDW7y1AXS0FsWht2Dz9iCPGxV/G99q7Pp/J19Mpvu82mgE6F+uPf/JzR86biHXAKcZav88XKZmtWejzdxtJ9rNL9Gf/erNaG9/BQXk4veffGyxWIYmr8T6pyIVww9TkEIgarV4+hWFR8OQWvNXHGemZrfMNUQUom6EZmN3XCKuxj+bO/dJmAvMsF8aHV1lzr7hNKlJwjC1AZaAcUpJ2LgrQGKm4iy5MYSTB2kovL4J/MtbmPAwKDrH8hJY0eda8SHI5m50hUwEMCfVry25/fjVYsXYs7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POS/xSasnYiRk5VKRE2KgiNcJM34EdWcO2BRa8T2e3E=;
 b=VV5PyYKFpbgPWnNowLp0zTgeB+PIWUhofmKoVMlsEIzIv1Ry32bvECUyD+EVmtUnPJgDlRk8toOqZvBjNWloisw6P78eASwS8us78SE4fPlU5oTy7LegA1BdtEvlP8ixQYzHiZWWpT+WkRAH3TiJ8zU72ovFZrlKLYwL9FaHVWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5078.namprd13.prod.outlook.com (2603:10b6:8:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 09:35:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 09:35:37 +0000
Date: Fri, 9 Jun 2023 11:35:29 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH v2 net-next 3/6] sfc: add function to atomically update a
 rule in the MAE
Message-ID: <ZILyYQBbaxEVKqty@corigine.com>
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
 <d72046e44328bab1fcfb8c7154a9e7cfcc30b209.1686240142.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d72046e44328bab1fcfb8c7154a9e7cfcc30b209.1686240142.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM0PR03CA0045.eurprd03.prod.outlook.com (2603:10a6:208::22)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: 17a8fe77-6990-460f-ef7c-08db68cce16f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Zztg/i2mm19vkYcneW2bffZHj/hyeFMuyKtDJfU6nzNDaxIblEinl0aObcuiMdiDV/Cw+2GKl9TExsuiL2U+SylQre6LVSXPUOUYSRYYqfzFEPc/NzUJyF25qA51gRkpbQsGyYKHjLJwuvktK5iovBH6WvIyOh3ZphQHtljFdInfxObwgPJhVibgr8MuAiz4CKup0gnkryeNPVJ/wK9aurQmu0n/QFokO/gGbdZKL4ue4OgAu+R0TDLjobqDRzLdwcIFqJsTyVDf+F+bcGvmhAGp4Ivr8niDtzGy8HXHUIT7vMeCR4pXXmzo+L8kECJrlOuvG0lbu+QwbofZdAowuFitUFbX44QciUpMxpnGETTZvteG5aHYSpmaKekSlOAwdvc1qRbyu88ZUb/VfucY0KfOeTY6tv2qUcPCidYnh/wdZot3n7X28G+Nra22u+ki1rDhHPzPT7kFe9YBKfKWhaYkjK8haVuLt5AGa5V3wVjv7rJd1K4nLkwCuP9yjzKSe55dvM6V8Op8I7FwK20CXvHzYQtgeWaVCzWGEfq57JIpwAJySaVW6/D89vt+91h5CCBSTWJOr7dM2cT4SevysobKO/TsZP0Uhk12bJCFYY0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(376002)(396003)(366004)(346002)(451199021)(8936002)(8676002)(7416002)(44832011)(5660300002)(6666004)(4326008)(66476007)(66556008)(66946007)(38100700002)(6916009)(316002)(6486002)(36756003)(41300700001)(83380400001)(86362001)(478600001)(54906003)(2616005)(186003)(4744005)(6506007)(6512007)(15650500001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7BMsthfi4+vU5gdQ96qjgPfOcj8x+piJaFkNCIZB5Q64DbcterZpaclLQBKa?=
 =?us-ascii?Q?l6WCNDEXAOw2FRqBnCw4sI7psyrDluaby8BHQ9cwYqrCdtPJJfX4+63/k14n?=
 =?us-ascii?Q?sF/iFa213Q5EdDXMNH7GQnOvod+7KdbvKvHR2gd4LpZHU+Pbc/cX6Ok8fNEg?=
 =?us-ascii?Q?IqrK5TN4TWoFJPbcOTnf077NXKO6BYRdMRg3YA1ITNU5XEIodQSwq2EPGbj0?=
 =?us-ascii?Q?qLyRwxfBJXzPsNXyM8w/RUJE8m9sRHZ5MkmU3Bm3MmxVCQeQlVLUnh99QFXK?=
 =?us-ascii?Q?6QBjuVW+q+iQEeLvldBuhpAql8xhEkwBhGA4AchD5P0M3FuELoJZFiklkxCB?=
 =?us-ascii?Q?YxixvLMWwGHt+29S7t1H0n41dAtCYaNoYiedZ8Kz78xvwxgoyOzRKy+oBgTK?=
 =?us-ascii?Q?Zr+GR2ezECDu2PnZBDjEL4WP+1brW278DuOG03M8L9WxGfxNO8GRO2n076N3?=
 =?us-ascii?Q?928iLMNoQAxIEB5b28DkQyGQFUz2du3uf44e5kKvVYYn2BfTPK4qeJIpvDEJ?=
 =?us-ascii?Q?RxvUVgwAP59WePwklLSCO47qD2+D7yIt/dx9qMtnPd/YnGas0s9QuQDR0f6S?=
 =?us-ascii?Q?UyWcxBF9b1NXUl6pDRAJhGV2e/9XNa03DMYEXRHfUVwsiDDS2ZCn9y2P4Ans?=
 =?us-ascii?Q?BfE49vIiCpHe3aiWexEWE+MVxaaT5UEXzitknemTgjEnU5vZDa8R1Fl7AGq7?=
 =?us-ascii?Q?Wslc+0sKgHvRIaZTkfIeaTsMXmDz77IQdgV9xLDn8SxoPeP+Ro5+11+t+kqL?=
 =?us-ascii?Q?/6w26crL1m5SBVILGwF/hiTdcUhlNPOGt05RhYog/tDUdhy++QgMnl4FM4wz?=
 =?us-ascii?Q?q2uSlTBVV9v5XNe38CEcC2H5R5KPaOLuKCzE2AWaDD8QGH9JFnnWQIxNsBzP?=
 =?us-ascii?Q?HMLWO0Htvm0AgHNdM8tyrR6/nWvsBaQTkOxdg817FNINuBqG36ZKGFRQ5/92?=
 =?us-ascii?Q?bm0jFWxa5aMdlhwM6gVZNJhTXCSb1aAvteHvE8jtqembckS7HFKO2QIKdemM?=
 =?us-ascii?Q?Kl+t3TV+rbCdLu+ccdlZXZncZKRcFQBDoe7Oz6G0LgGAsoLdTy0hQdathk+T?=
 =?us-ascii?Q?fOcTmNdTHgAH3bDXun0Z942ig1yQP0XNiFzlr365RlYYjmVp8Pbe0LBR9Els?=
 =?us-ascii?Q?0C4aQyyFRdnC+2zBvpzS/hPlYCIAejc0pURYtioaSoYo3uTw626pPDmOZ/WT?=
 =?us-ascii?Q?CQiTHKI2GeuDDiPiKffMYbepmADTJyjqu1vRl1RXpc9PO2d59Vp53jtMTPO6?=
 =?us-ascii?Q?UZzHfn82pPJlT+nCh2HxdmSUPLNATsln38o4wFomf5+GFu3Q6x1y8v5k47L4?=
 =?us-ascii?Q?WRAxsg8keItiY69PE3LiUTgF3NycAYzk9sCgWs1HaA9zYhtiXamyjpyErFyB?=
 =?us-ascii?Q?JhDRHXR34C0sVgTvZznUlHIr3+fYbcn03t14AtVvpAUl2vEYhwRosDpOvWQn?=
 =?us-ascii?Q?KJwFvBxwuoBZSzUFPFywUgM2j+jl168aj6aqksTtXdQu0EPTKZ4/m5W7syqr?=
 =?us-ascii?Q?/go/F94ozTgVWoMBvKN8aBxRrN+6xccb81kZx1Zv6I+8HCACJKHAfE+fxE54?=
 =?us-ascii?Q?W8mLJYHIQtPPO4iTJ6dZ9W+BnpdnvGflwm1yEb/9FD3qtJJRPXccXff3JKil?=
 =?us-ascii?Q?sG5gxjlzoMoDt5B0FtvDhu2JcJLOBNNIAHjOEPBx5h7uI4Gihlm0Y7KJ5NJs?=
 =?us-ascii?Q?G65zCw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a8fe77-6990-460f-ef7c-08db68cce16f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 09:35:36.9874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3YTeGXLzNVrplMQYmIbIsnY1bQNYwfXlEftsWENSPbYRKEcG2AtIVDKNgngE5owcbwgb6VWNh/feGAu83aajoIIXuKJ9aumI6GI1caO+XQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5078
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 05:42:32PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> efx_mae_update_rule() changes the action-set-list attached to an MAE
>  flow rule in the Action Rule Table.
> We will use this when neighbouring updates change encap actions.
> 
> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


