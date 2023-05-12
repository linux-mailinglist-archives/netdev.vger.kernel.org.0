Return-Path: <netdev+bounces-2232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D93A7700D9B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4CA11C21294
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B604200BF;
	Fri, 12 May 2023 17:05:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850B8200AE
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:05:47 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8974CE61
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:05:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8WY3nRHBb/9Ssr3uR+cIsXBLLQ0BpPi/Pc05EV6OyiI0hNYp+jzBcFtBkjMn8Wqr1mQVBSgY3q/bnrkQrhHp2URz9xOzwWFI7c5WHoQYAO+U2iW6eBVoTJIOyK1WDsoQC+dM2ftYlcunKoMfdlaGxXiRUU2I7Cw8WDdlMIlCo/RlffpBhI2m9hQSx0PsudT5R7X2hU6pFhxY3ks6LxVfZYE40EmbhwRMD7EVaP2N9ebtjWcndnTLizHrvCYxwYGWFYuOKqiSIvTDrQdpSWWAjEuP9RnSLvCt4j6dOs1orDHimRcApElVew/JbPUjYkTC9a7bCUqy3az23tm72fQpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGz24H78XzNx2YDKR27TDHck9e1GEu39OixMCUp40fw=;
 b=Kkn5oR6h7QCztXuHFbpR6hx09VURnf9SH5z855cPw961XF0RFzFE1SMC2sBaPL9c+hU0uB7mylAyzyIKPuZIFsyNZJqxdKTq2c6X75iNe9Ax1SLFE1KZBV1H4nO9hwdup8nsMEy9rYEMla4nt9qlipBOykWiIe4F2HRkjG56IKHk8J2zegmxZhM2V+M3FRx4MvS53qXRj/R7GU3Te4OfZ1tTe7gF5fn67e7VtdAteylq3LjVZ0yW0iyd7ZL8Bi7y3aehPLorvBJ6lYMo37C545tRQa4f6hmPQPVfI5DpXcqIBHv+tCujo67DlPzZOJrSZxb5zZlDcVszStwaSZzT2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGz24H78XzNx2YDKR27TDHck9e1GEu39OixMCUp40fw=;
 b=cyo9MsIBySVquUFuWntvms7Y6nt2W238J5v0y8Ov2lAdY9XdHOzKvaC9skoEFOZZgH9M1enQ3RLvbO0uFdgz/A5sJ0nK4vwREPfmK++TcTM/mvu7nHG/m41JhgvUfckSoxHe6ABgFNWFxT6DwV0edmXFDEfepRPyG2GBsSGsGtM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6440.namprd13.prod.outlook.com (2603:10b6:610:19d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.7; Fri, 12 May
 2023 17:05:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 17:05:40 +0000
Date: Fri, 12 May 2023 19:05:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: m.chetan.kumar@linux.intel.com
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
	johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
	loic.poulain@linaro.org, linuxwwan@intel.com,
	m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com,
	Samuel Wein PhD <sam@samwein.com>
Subject: Re: [PATCH net] net: wwan: iosm: fix NULL pointer dereference when
 removing device
Message-ID: <ZF5x3OK2+Rm2njd6@corigine.com>
References: <a9b0a086a7fc9de0994fd00cedf6bbbda34805b5.1683798621.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9b0a086a7fc9de0994fd00cedf6bbbda34805b5.1683798621.git.m.chetan.kumar@linux.intel.com>
X-ClientProxiedBy: AM0PR07CA0018.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 8290b0a7-d7bf-46f4-869e-08db530b1ce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iSLYabUwknDsOAsUYwX2f5fLdYZsmydysrfAf6AjRhYETjUDL+1zHNyxiedVJk3bXLGYN5DvbtGkSHneX9hyF7WCBszcWC1DcyR3PCQ8w/mLGG2/JIzmn0AQV5DwJ+hXTVt9WI2uH0IlrO+ztOJivitCNzefc0Q84XlBgIzhM1PxqkCPs9VYkltYHZsoMntNhzjaThbsaRrJLerqfg1GVGyxOZHWlyaIhArHRy3URoSzN2HRMZLpnfI44l3hut2cJ/uXBD05XaLwnyOlVHUJh8v59SmEeVnB4qlLzshgwVqxzkneGknF78HZ50PfcbijVUeN0Gz9Soic1ZVIVuUCrKNhkPxiw76KOt0RGkWpz47dP7dNsrzFO5zOuA+5sbLFWEH4a7FnQBhj/QEEkPxO6b958oJjH8n6HH4iFPVALKb9wdajHODVvaun3u2EHouUucWuIyDDEt2YZ4Mv7Xa1Qqh51FkDf3TftV8VZu3ZVei1On6J8X4jg1brfqQJlZiu/uZ451MCtpeP2OhFBOk6MNaxLTakHL5cs+YkegGZ6hitVhLYeXSZDHUwgnLP++HdBKS5AUgC5xltfYVK21gDPxMG3tkHwcmIybvWjDrGK3E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(346002)(39840400004)(396003)(451199021)(2906002)(186003)(86362001)(2616005)(83380400001)(41300700001)(6666004)(6512007)(6506007)(44832011)(966005)(5660300002)(8936002)(8676002)(66556008)(6486002)(38100700002)(478600001)(4326008)(66476007)(36756003)(7416002)(316002)(66946007)(6916009)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vP1zd6DyD9dPwuzqUmHwGYD3GTGVfl7t6t5m7iO1hjmnDYpNnPA9gG+BqnFd?=
 =?us-ascii?Q?rLP3bGruIk0onaHiRAllIqwgJGQw76LbBvf6q5gq5/xG41m7fyo5Ltf8RxR7?=
 =?us-ascii?Q?sSopE3p45q6QXJ4VWa+nXABGOBKFyWinIIdZCqPrXEFngCGaepuPz4ydyeTd?=
 =?us-ascii?Q?vqN7/JOVk4rMjoYH/TJQAWOJQAFmzCtEVEeMMtYrF2Rmf4NESU280vjlQZ29?=
 =?us-ascii?Q?fxeinBvmgyBM/l2ba8qJJl0ApYyc3v/2wJ793IzoTB4Ci81vmTr/YOMQc/Ab?=
 =?us-ascii?Q?W5LSa+LbnSfBvEJuONvIMiTYCjBUhFrmnNbqyFY0E8AlSe4W7sdy8uZ5nG1B?=
 =?us-ascii?Q?Y60gFbLCrTulRNqvOMQODpYZwKQxNc99geKaoCi6CGH3a7U+MG76DvTNKWdl?=
 =?us-ascii?Q?Li22wtKUD4F4G+F3NLKZfp5ngEEK5eDd5SZBPNVr3noLPSM3xE0iAU8LP/8f?=
 =?us-ascii?Q?y+rtOXEYfPSO9TgYMSGs+49IS+iKHN7JJTLihkXpl+rxo73JreuWse3adF0Q?=
 =?us-ascii?Q?JUFBUgfp4iVd9GfjZAFP8DsuP/atsOdpbjtrjGM60CI+Yc/3OhjSmbThJ+W5?=
 =?us-ascii?Q?U2keUeLCUY7K4RyCwdQM6Ly/NPi5W8cIqYiedIKI8qrsgRIHrSXoK5seqR1o?=
 =?us-ascii?Q?rhHx+tMWTQkUldYuH1xN53OWDS5B8wn9kJMTuc9ISScijogMpNkHpyNUg9aK?=
 =?us-ascii?Q?9hU/SkCTg8zLlvKNdHx6WkOqHI6VwAuEtmgShZ9eHR+mdx9r9HAeDJYgpQEx?=
 =?us-ascii?Q?aff7J0Fhr3VPsRQNBMCUaIbzfms3G+tFTWa3RMvtRI27ZzvEaWWYR9SLn5YJ?=
 =?us-ascii?Q?DvSVzK2bwEm854zXJNDZwazHyyzIt36qQGbTi6rGhPf+TCgRTxNW33Fmeaoo?=
 =?us-ascii?Q?Nsn0elg2I1mEDP05Ux4IClwqgkKXnG4IKgVmPvWugQn2yPzAwG1Sqpz1KJn5?=
 =?us-ascii?Q?/8nQ3j8wi2inI2LjnixKZ6hwAb8gqwnW1WT5R3ICmc7PBXUpR1MoC6g1Ay8D?=
 =?us-ascii?Q?hLoA7JA6YjWUOZ5I1PC8UyHVfoTwMhGtP9yMqLzBNrh9L1vU3uXbzw8oEF63?=
 =?us-ascii?Q?4I6LkmZTP1SSc7+5KncROZiTXczNIwFoUyTb/qok1BeY0Q2vZhcGJGxOQMdg?=
 =?us-ascii?Q?3nVpesvdua/dtQF5GXQpgieAkBgM9NElsG/uMJR6xw2Lkf0LEfNdh3+KSvUY?=
 =?us-ascii?Q?hNdVGQoHOFsRpcTxGDd0uqjfWeelGT8GbfxxMSVNnZjc24vnsBi806ncGNrb?=
 =?us-ascii?Q?2ea5mHdWEJ3RHyrNW9BKlQRIvZhzihEvM8YCLDYvX3OEzTgGVtZpexK3dxbD?=
 =?us-ascii?Q?ESElyi5C61NVeA/ntfZnRWkltyRiulXsMvl9Ws0uJev3dC5Au531MECFlvUN?=
 =?us-ascii?Q?1BX2gugu6rGHIHjl1rRZw0jXcFzB+HXWFeFOcu/CVLfrW+NkkQJh0I8D9SnB?=
 =?us-ascii?Q?+JYc5r5KHucxkhnFjIB8szr3hrVKExpqqUlkiqickvEbWS3OULbQveMiF9e/?=
 =?us-ascii?Q?c7pEFyr/bDz6BUXjbjaM7ekfc3vE6duj5qRdAggW45HUh1HORrdIbz71kQtx?=
 =?us-ascii?Q?LJJfp7EMmYpfnfkq1ufYc0NgWc/PxoqDtCtvZrMfUIvyrxwOlo81efUdzOM3?=
 =?us-ascii?Q?+KQ5AJrFfwkDIId9CA1JkprRITuPGaKGKTdCW6oTmzMnQSDyU9vjXFmO35+s?=
 =?us-ascii?Q?ThoTRQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8290b0a7-d7bf-46f4-869e-08db530b1ce3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 17:05:39.9163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NjvjSVr+poSb2trjX8eB9l/Ii3vtGtvX/pTCz7lh3X0ooNyHPuGeom3+LiSQvlBEBRsnws98sA6DMRArvI83nH9XQ0qerPJxOfFWT5Yzpx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6440
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 03:34:44PM +0530, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> In suspend and resume cycle, the removal and rescan of device ends
> up in NULL pointer dereference.
> 
> During driver initialization, if the ipc_imem_wwan_channel_init()
> fails to get the valid device capabilities it returns an error and
> further no resource (wwan struct) will be allocated. Now in this
> situation if driver removal procedure is initiated it would result
> in NULL pointer exception since unallocated wwan struct is dereferenced
> inside ipc_wwan_deinit().
> 
> ipc_imem_run_state_worker() to handle the called functions return value
> and to release the resource in failure case. It also reports the link
> down event in failure cases. The user space application can handle this
> event to do a device reset for restoring the device communication.
> 
> Fixes: 3670970dd8c6 ("net: iosm: shared memory IPC interface")
> Reported-by: Samuel Wein PhD <sam@samwein.com>
> Closes: https://lore.kernel.org/netdev/20230427140819.1310f4bd@kernel.org/T/
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

...

> @@ -622,6 +630,15 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
>  
>  	/* Complete all memory stores after setting bit */
>  	smp_mb__after_atomic();
> +
> +	return;
> +
> +err_channel_init:
> +	ipc_mux_deinit(ipc_imem->mux);
> +err_mux_init:
> +err_cap_init:
> +err_cp_phase:
> +	ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY_LINK_DOWN);

Hi Chentan,

Thanks for your patch.
a nit from my side.

I think it is preferable for labels to be named after what they do
rather than where they are called from.

Something like:

err_mux_deinit:
	ipc_mux_deinit(ipc_imem->mux);
err_out:
	ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY_LINK_DOWN);

I also note that if ipc_mux_deinit() checked for a NULL (and did nothing),
then this could become:

err_out:
	ipc_mux_deinit(ipc_imem->mux);
	ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY_LINK_DOWN);

>  }
>  

...

