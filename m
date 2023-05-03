Return-Path: <netdev+bounces-88-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDFE6F50F5
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:14:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 650691C20AB3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C99187A;
	Wed,  3 May 2023 07:14:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E428EEA3
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:14:35 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2126.outbound.protection.outlook.com [40.107.92.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A299C469A
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 00:14:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6z8RXWnnaP/lyV8P35vzFjl3LR+XWhcYQYIfZc46a9svHAZq0RIGJq2atim1um5v7iiKS6AzQNrpWIkVGJ8kqChszp1c1QYSji00rHM62pBsgEBe0gnIRdxgciG0rJXP2EgUjavg/CeE88ejMYnlmt450+/iDnmqWIoM6fyG3BMj7sY+GiC//RVf8Y3z540m/mNQ8koz6rJkGTJxKJO1El2jIl2sNPt0CkPFKVJGsiBjdZUgoPDnGSHD23PSUZ9IAsueR7WDO3WgF6OBSk3piszx/nzoZZU7NCkQKSYdu6Dr9IoO58umx/+rh0r8Cu/zNcbM3Z08T0dozGgjujs5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2NIdNtpM5jktwDg7A9sfDjYRT9cwVJKzzlbP8vnUz8c=;
 b=UMEEe7gE7TEALxr1a76D+Q56CIoBGmHQHkOB/V2Udax9x/U5KQn406m4Y/YAH0AvSFrmOZJM/zFDMSSRjs5WzaxdMMEOdzD3M7M88twm81vfHNG7QY7M/+mNXTSu9JZJp00IirzDwNsdcibldWLsOBFLb/yJBErJ9qVDKiGzSSz+x3BdR9gfwIXZk6+FiayzbjCGiTWZDbENwOlS+5+6jS/XFNY4Nlowmnc7YkcfoleilOMzSs+gdOk550Xo4lV78EcVjgkB6mBvr5/4Q1nAAtiZwjP2aDcf3RH9dYLQ20bUcdRgvzio9TIkm4d8GNdYzFyuMjePpZwX4fE+AZnwMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NIdNtpM5jktwDg7A9sfDjYRT9cwVJKzzlbP8vnUz8c=;
 b=EN9U9w5C9DJhtBv4S/C5diw6xLnkrgZBc8BKnFyIm/Xy5VMRdZHPnObmyGrVVg7IMCmtLaxxjxWH16ye/4WwsNJjTLwo0W74SkLXjd3J4adYaIbxmyTWXUSaNC1MmMpDez6ksz87bpysTLs2XR927iT8nOiF0xsyZXhOpt2V3uk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3725.namprd13.prod.outlook.com (2603:10b6:208:1e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Wed, 3 May
 2023 07:13:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 07:13:23 +0000
Date: Wed, 3 May 2023 09:13:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
	drivers@pensando.io, Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH net] pds_core: add AUXILIARY_BUS and NET_DEVLINK to
 Kconfig
Message-ID: <ZFIJjd/fCfhCGwme@corigine.com>
References: <20230502204032.13721-1-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502204032.13721-1-shannon.nelson@amd.com>
X-ClientProxiedBy: AS4P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3725:EE_
X-MS-Office365-Filtering-Correlation-Id: 942588ff-3f56-4112-17e5-08db4ba5e1ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	to2Ca5jpyX9msJhTitkoXlRTo5JkKVWQWdQorCbbj6XYkMHDdfR46qxEt33M+1aFPk6qvvd8CNNfJJK+sgIzkW34FCINVzjU27PD2kRQsxaHHIk55fCbHZ0T7VkdAEIOxuKduAd9waMMac76kjemMZCwmxazXZjqaTftOfX7TBiEqM/C4lKnMn24UeXLa2XE3Rjk8N8C3nqh2y7HaFdEDX+CNbUVx8NwPPbNpWgbGChjSSSjjohpnE3qwDP7WL8DzGYSz5wXjiSQh9PkRIQjMoy2tq7uM+f9xyJXk3jyWQ1/5CZBjDeo0QVdXqAk8eFSDg4SCeJ6ebLuzPB6foiEnbLfllyUfQp3eroe2h26rJp1hEiJ6UBb665DXQYX9w7NaKLDQAbYRmSWVrtq09bWWH8yieto79dtVgX32n7b2GwoMTbdi+9xV354/KhdcsaXGdjd9Fuq+1CuOtiT+7uaANdBjzLwT0NIxiEiA0onvkIoEq91jbdzZghsRw5Xxl8gxsNz+bSyX4klm/R4jhKdhpgdymK98Y1Dp5yzidQ2tK0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(396003)(376002)(346002)(136003)(451199021)(2906002)(66556008)(66946007)(4744005)(66476007)(2616005)(86362001)(44832011)(5660300002)(41300700001)(478600001)(8676002)(8936002)(966005)(6916009)(36756003)(4326008)(6486002)(6666004)(316002)(6506007)(6512007)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YSw62D9kbf4uQJAwcYrW3Dtu5sATA1Q3f6hvop1/oyG0A0uGP2zlmIiqta+p?=
 =?us-ascii?Q?PAQ/sUjGHsw6M6thkntpgcnVS/dk8fHSoAYvheGsJDANigijT5IOImHkrcyv?=
 =?us-ascii?Q?05WXxkWZrORpg8fgzBKYvWiXiim1bNuHOtqhoT2t8lsMsYmDBlS2ksM9FahB?=
 =?us-ascii?Q?ZcOAuV5QFmDMu2RIOyfvxI2/CknmPak+wh5NGMNu+qK1By39e8MOytdyCOEG?=
 =?us-ascii?Q?j4C8Fnp8O5kL26FiobGLw7aFPf7T2oLMauf18wMVJn8PTyr00Qe20gsV4DWY?=
 =?us-ascii?Q?3Jq79NdtkGccFzt7Vq9Fd6ac6dgMBpjRWmZydKkTi0IPHAoRp8jhkaJjEYDN?=
 =?us-ascii?Q?24GEWF1RfxHdYvcDw8f3LUuCITYUoYEpl6EujoPWF4l7PyhFk0y7nDTDn/v3?=
 =?us-ascii?Q?Ob/hmPx8T3PrkIOTViYo8bnuoR7EYawGnQKeAHQDxxwetd6iDOHEmHGMA+y5?=
 =?us-ascii?Q?QYoTqYlZY++N+P0IWVjJtwEjBUEotZZs5Am4Fhf/AHLj6uLNQ4rZ9jy6wu8J?=
 =?us-ascii?Q?I+Ihaq5aodyMxA9acQkBC98lkmrHPNNl1xnwT+/ef0IKmOka+HoyFACnzvLy?=
 =?us-ascii?Q?ZbDghJF5vmxJIYDfD7hQ9jLENi0yiE7YMsXf2lP2rzzx+ZS8tdqs3/G0obmk?=
 =?us-ascii?Q?WlVpgnkfDwfdfHkTZygzL3VTtLghmhs+M1yZMuWM1F+ss4FonQEjRgAlHdRW?=
 =?us-ascii?Q?bPiRlySOUIFqGMbu6kkzoL2WBe0a8JtgQFdqDz2F0TwAT7zvicu1o9vuesGO?=
 =?us-ascii?Q?wpzziOQDhaADirDqaFqftWWPTV93DljprhaFItu01yTKKx/U+0NzzP2BPWSJ?=
 =?us-ascii?Q?YSfyA7BuPZ5paG5pvKPF8wtcTaM9BVwG+wKj6Spm96gnYldUvicACqF3i5dt?=
 =?us-ascii?Q?lA2hzGx/Crt8TcsdlSE92u+VltnTMwc+pjXb5yS6TVYwr5Mw5B+gZ9aPM2y3?=
 =?us-ascii?Q?5awD1zbWgGTbqYEMszbvl3kjhajSs/Eh/zOnI+cw3m9k9w4u+gfIKEqJaTHv?=
 =?us-ascii?Q?xnDawz1m7BcRVfoBqP4k3SVLsbjfhvjNRufSGisW2Pos7oS9SE1QIGh1ylvV?=
 =?us-ascii?Q?1BHXHDCJM8+f0n79yAOvpwd7Xa2nund1P/B4kZn3OsHeiXovn63FmMN083WP?=
 =?us-ascii?Q?bIF1HCPrZ9MvdQkJK9cXh31NVmDw+/PgZl9B0XweEFUOwQG5lS+vxRfWvjI9?=
 =?us-ascii?Q?kqyEvVkM/K6JSsOTnECArr1SZO8w+so+A/msQfWl8RFMD9w0MB+6UIiqBOiD?=
 =?us-ascii?Q?++R+mArULrLOCsX3Yi4/TAcAQR4DfCCxs7e5MwD9HghB2X1Ijqdgk4MmtN8N?=
 =?us-ascii?Q?p0uh3uv4ytddOmzoTIUrmzh4isGmwrJ+N9WMznltEQd3rXwfQvqS2ztO1cHF?=
 =?us-ascii?Q?LSe5WFpYGhOuLwa4cNgaUZW1KIuO5E1n0pful/5vO/IJF3zWiYeWUPE3Uu+3?=
 =?us-ascii?Q?WtcMibSr3BhaIH28T98yNerk+JwepX4z3GBrpk9qLTEVeKZ6w2PPWwK9gFGB?=
 =?us-ascii?Q?ye2t8gBMoPjsKgxrCZgVTRZZXLe3BMxCKhnCcsjMj/XueKOX7sLf6xHKN3d6?=
 =?us-ascii?Q?25enzd8VcvhCu1xvDnx6fsQlgp1trgPjMIqbbWecRVcKOF+VVpB1XFSd3c00?=
 =?us-ascii?Q?VZLRltRmUBm7MyaKgM6WA/HYw5PUPSmk5e/jAzKMJu2BPIHnGyDnVqZ0+X7V?=
 =?us-ascii?Q?RuwaPA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 942588ff-3f56-4112-17e5-08db4ba5e1ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 07:13:23.2280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4JuktfK43MERX++bfpZ7JY3exsYjzLciwhvqGYbOYI8KcDdPRo+5h7nDiI81G6RHWXNLoJGqow927ZPrpQbvEB6nBSVEGOiZb0l6nMnAig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3725
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+Arnd

On Tue, May 02, 2023 at 01:40:32PM -0700, Shannon Nelson wrote:
> Add selecting of AUXILIARY_BUS and NET_DEVLINK to the pds_core
> Kconfig.
> 
> Link: https://lore.kernel.org/netdev/ZE%2FduNH3lBLreNkJ@corigine.com/
> Fixes: ddbcb22055d1 ("pds_core: Kconfig and pds_core.rst")
> Suggested-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Thanks Shannon,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

FWWIW, I did exercise this locally, before making the suggestion on the ML
a few days ago.

