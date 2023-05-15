Return-Path: <netdev+bounces-2674-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3967A702F98
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 718F328122E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64056D537;
	Mon, 15 May 2023 14:23:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472D3C8CE;
	Mon, 15 May 2023 14:23:16 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2131.outbound.protection.outlook.com [40.107.95.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42105271D;
	Mon, 15 May 2023 07:23:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbBtG989FG0YWP6SxqTi1xEx4h6icpeYvFIep29LsaWTN/qcl17nTuqj2zDUd98S5/SakDCfJEETycbPFbjfmOJgkxtSbP9JjnHFHq3nSMjUwIIgexfASB2wYQauERzwmQvDbu7Ox36cJaSs4NGJ+Qf4GwHWKkKb3jq3LR42qQYoJhgGOoCaxOVMbG5OJ4LcFU+Tn7qIjBLiiUl6VLo6aWOTVXgN4M8G8TrXEbs+206D+aiwSynBwMJhCPTxs4kye6ocEPauQx+1Xl8GYPu77/j6cJroROCvBSuyz6gYNEJwARsFpS2Wgt+kEndNXre0Bov+ts93LRcJf8y2WCW6Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKJwfBa8UquEGkEA3cHoTJ7KwJuBAqaMI1MvGAUjTag=;
 b=YijQjwwv578/dZiaOIiH4XmV5VNxO3cxVz9F2PW7d4z2MS+E6NuGH8Uh5h1WI2Uboj4jyu5j3eiNjLWez+9tDWUfdue/AmDV1zVMILMiZbqgVtsq5mBugyREBCcba/Nft1Sf78Kp1xw3fm5zCR7llnp8XXoUPXL5vA1x+F/KFkxw0mSqpnApdKX8vwCTK98oOjkyI0uPQl2pgu1igJQHwOecND0vehcSMGuIKQMqF1/20J+GSd/G37lnQPRNbJsGJpoX9bsP8b/qvBngHSWip25HZu4ksAKjkTKpnKglp5WG/+sW+IqE3/j2LZe7Gvk9LzqxyhJNM2EqW8xSVMkYZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKJwfBa8UquEGkEA3cHoTJ7KwJuBAqaMI1MvGAUjTag=;
 b=PxRV6tcmewNoS5KDcEQGa/BLSyOxVn9ynOLYPMtZvqWgJqEGK6EzSJCKdFTqdtAbzsavIQiNccukj8K8elGPbEJVeeslM+DKCFpHuJ9aRB/A6D5F38vqFzQzNAajLIJit6yaOEwmCN6jcYr5oboms+nCb/xcUkjqR/yxhVZvMHY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3696.namprd13.prod.outlook.com (2603:10b6:208:1e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 14:23:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 14:23:08 +0000
Date: Mon, 15 May 2023 16:22:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	bpf@vger.kernel.org, anthony.l.nguyen@intel.com,
	magnus.karlsson@intel.com
Subject: Re: [PATCH iwl-net v2] ice: recycle/free all of the fragments from
 multi-buffer frame
Message-ID: <ZGJANam1Dcf1y/zs@corigine.com>
References: <20230515135247.142105-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515135247.142105-1-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: AM0PR03CA0025.eurprd03.prod.outlook.com
 (2603:10a6:208:14::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3696:EE_
X-MS-Office365-Filtering-Correlation-Id: a9b3cf5b-26b7-47d8-b500-08db554fe7ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7PgXDbh+gTblsj6ZdMyypVLUYUAdm6NlSDvn4emrGPRivrQ4eOT5C9wXczVGu5sBioh+e5FkyhOvfyrkOV8O4RSL831QufIUjk9jEtNJbzIrq5DYD6sQwMUHnx00KpmK7/TdfWCfqAyRnPAbJiET/VGblR3zn/TevUR8x2hQPquFPpoPotCcGotNXEcm8zRE6fqJ7Jd2HeuOWYR0+M7k4qV3tV4UlQSlh4m0gzGosSAPI65PppLvY2FNvcsyElyZZdVmIjmR2/5yp3T473RKpy7WZBLOEaJ3P3kdq5tScOPhZseyozUh+dlV/wwi+PkXZvRgu7mESxa36V/7jdbHkXCKwJbtUG4wIFYLKaZsQvP315B+p+NkAAHUKWjAB5d2MkdKDfL+nWuVPGvCR6CFJ8g2n+FLsHMnWYvwxz/5+tIYSirBpYmSq0a7pYq2CEsffKVav2AYpzclYNafmeIWGlor0DXBukzmV/6b8k0uZluDJ7WDBwOBDAgkzM5Sj/ACLgzeaDdgJISjJvzBjy3cXQzp7UTh+2lJTvbFcWkAs7X/AS831+5xKsWlCxj0h9ex
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(366004)(396003)(346002)(136003)(451199021)(478600001)(66556008)(66946007)(66476007)(6666004)(36756003)(6486002)(316002)(4326008)(86362001)(6916009)(186003)(2616005)(5660300002)(38100700002)(44832011)(41300700001)(6512007)(2906002)(6506007)(8676002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FmRg0qE7+hnyaS+W2zozr3GxUZEP6jmmX3Lai0M//U0lm8X6c6xEodjs2EOv?=
 =?us-ascii?Q?hB9PxM/PIdhioJo8rfNHIVAQNZ5htjwIUIhwh+SNinysSjn/EhFbz0E+9Nf6?=
 =?us-ascii?Q?oi0wiZvJ3E3RmVxD/yQ378457BK4uTx+CF2e094gSDBV7Il0/KPF+oAoebnT?=
 =?us-ascii?Q?tYxmsSxvYlqNH5/jrxuTT+DtcqpnmySsr7UazP2XDmctkTTDrHblA9sonAvX?=
 =?us-ascii?Q?IU55SF2tGSgLLR8sRMTcSxGpEKPS5Dv5aAc0ykeER4TNH0GR3DTx9R2DGu9O?=
 =?us-ascii?Q?TiJqJE2vrU1OLxabqtJURqg2xG+AbBA2mPjHUVNjZDfukzaus7+OQfoXhGBQ?=
 =?us-ascii?Q?YvEja8T0NdfQ5kCaVNgEJEoZgd4QdsSJVtp1uanKUJ8n4sS4/p6MxoWulzU2?=
 =?us-ascii?Q?Yw9i+0JMI/4vn7v9HmxE8sLSbawwi78TV8gImuB7/6FTKAlP8k2NydPikxPB?=
 =?us-ascii?Q?mySTKJYZdd5P0nYQKMqm8+rgpX/+3lhU/RujA7paUII62zZv620ipLk1Z2eI?=
 =?us-ascii?Q?5rmyEYe/iJANJQS4ONTcv7jsmbL0sXxUkIAmrFG1WXt1OJrHy31LqQZnBdKu?=
 =?us-ascii?Q?8qr8UG7lCFdHZYdOZI81k5rGpTNNquq1fqeixXb8xmbebsTNEHn6xw99KTne?=
 =?us-ascii?Q?XN9lo/TFPyz27qIM5CayU3rnS+yrx/YpZpPKfVTXk6uKC63ecTnKEBzOsm1d?=
 =?us-ascii?Q?vEyMPdrz3Fgbn2y+PMGUsFvAhG9Lfs9rFnaFnA/SddiSuzFxSHpkLej9eXC/?=
 =?us-ascii?Q?QJ7BZ0x9ovVxSSCKUOn/ULR1L/lIklJ2ETqQGheWpllAfig+NxqAAfKGz8+p?=
 =?us-ascii?Q?j4uVIhk6TEOI/Ixj0FbaCjldy2W/GHAj3al34JphMn2R/z0BmjrO+DARrjv5?=
 =?us-ascii?Q?g5ZrPly7gcl8db4UFR2U/9aU3o2N3F453M/NO68XzsPGjvvwM7fmKJllkfg5?=
 =?us-ascii?Q?kuzdH7fa8Xt6/u49gqxjtEWGb2okTSPDfmglKYReS9AKhepULYafJ/6RLAcC?=
 =?us-ascii?Q?vTNKwqIHgHejFaOU/rXZTF8LS9gdpfGwJOOV3j1dP9ulKTPXQCas09CW44sw?=
 =?us-ascii?Q?cl7wvobuR6JPVDJsAbZBEn5OVU2aCWeKXWbZ1ENuqjUD/9GPS+d1nmK09Wd8?=
 =?us-ascii?Q?46sXCp4/M/QYNH1wt5gDUZk2gkY1LmWgq4M58ZuclUsEQDuGbGBH8XztdqVZ?=
 =?us-ascii?Q?SJ/VM/5OJUtjy1KA4o6+/+/LAWwScRji/Yd5Mxpt/XfSOFPTQI1ZBZEnZwVR?=
 =?us-ascii?Q?NXvRfIjS8OoQ6R/PF5mQXR00Ls7x4rjwIhvfVF9yyFvSuC9Icgcuh3YzlccB?=
 =?us-ascii?Q?XJWPB3UXgPBmRgO7zmX3cftBr0cqh/B6792fEkKYZ+9l8gR4raYEy2Jk5MA/?=
 =?us-ascii?Q?vCv2dAyzUH6Gtu2R0fJ0ONj3fr/Cck1VZIstXHTe6IWVVor0EqOlBocrKGM3?=
 =?us-ascii?Q?UALTxe/5Op4yTnHzPporxrbMqQnO6uIzcyxhgGp3lnq3CbW1o4GLM8oGa1Pd?=
 =?us-ascii?Q?uRkIDBET5H+I7sF+xuit2Ti3QMFgMYDOts2h7h4fGN6W4aShbYkROxrOHwlS?=
 =?us-ascii?Q?tyXPzVEQSCbpQjJM/5ykzV0UQvimu+lIdLQ383ktMNBaoQ1yobB4g2eQcZY4?=
 =?us-ascii?Q?ZA+Vh+8H6LaYJEnpLbkIyOiCGM2/AdXBLE2kICvGist0iH5tNwsOo2XeU32n?=
 =?us-ascii?Q?RCn0oA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b3cf5b-26b7-47d8-b500-08db554fe7ae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 14:23:08.2361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TXwZNK0t7NqKh+zt/8tNp2F1YP2l86xUVesOa1GfmJ73hh/VYzicpjuyjkHcAEVYI8rpuDVlwhfTtVPXVW4+YmbzyGr+6sYgovX+u31N6u0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3696
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 03:52:47PM +0200, Maciej Fijalkowski wrote:
> The ice driver caches next_to_clean value at the beginning of
> ice_clean_rx_irq() in order to remember the first buffer that has to be
> freed/recycled after main Rx processing loop. The end boundary is
> indicated by first descriptor of frame that Rx processing loop has ended
> its duties. Note that if mentioned loop ended in the middle of gathering
> multi-buffer frame, next_to_clean would be pointing to the descriptor in
> the middle of the frame BUT freeing/recycling stage will stop at the
> first descriptor. This means that next iteration of ice_clean_rx_irq()
> will miss the (first_desc, next_to_clean - 1) entries.
> 
>  When running various 9K MTU workloads, such splats were observed:
> 
> [  540.780716] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  540.787787] #PF: supervisor read access in kernel mode
> [  540.793002] #PF: error_code(0x0000) - not-present page
> [  540.798218] PGD 0 P4D 0
> [  540.800801] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  540.805231] CPU: 18 PID: 3984 Comm: xskxceiver Tainted: G        W          6.3.0-rc7+ #96
> [  540.813619] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
> [  540.824209] RIP: 0010:ice_clean_rx_irq+0x2b6/0xf00 [ice]
> [  540.829678] Code: 74 24 10 e9 aa 00 00 00 8b 55 78 41 31 57 10 41 09 c4 4d 85 ff 0f 84 83 00 00 00 49 8b 57 08 41 8b 4f 1c 65 8b 35 1a fa 4b 3f <48> 8b 02 48 c1 e8 3a 39 c6 0f 85 a2 00 00 00 f6 42 08 02 0f 85 98
> [  540.848717] RSP: 0018:ffffc9000f42fc50 EFLAGS: 00010282
> [  540.854029] RAX: 0000000000000004 RBX: 0000000000000002 RCX: 000000000000fffe
> [  540.861272] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000ffffffff
> [  540.868519] RBP: ffff88984a05ac00 R08: 0000000000000000 R09: dead000000000100
> [  540.875760] R10: ffff88983fffcd00 R11: 000000000010f2b8 R12: 0000000000000004
> [  540.883008] R13: 0000000000000003 R14: 0000000000000800 R15: ffff889847a10040
> [  540.890253] FS:  00007f6ddf7fe640(0000) GS:ffff88afdf800000(0000) knlGS:0000000000000000
> [  540.898465] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  540.904299] CR2: 0000000000000000 CR3: 000000010d3da001 CR4: 00000000007706e0
> [  540.911542] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  540.918789] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  540.926032] PKRU: 55555554
> [  540.928790] Call Trace:
> [  540.931276]  <TASK>
> [  540.933418]  ice_napi_poll+0x4ca/0x6d0 [ice]
> [  540.937804]  ? __pfx_ice_napi_poll+0x10/0x10 [ice]
> [  540.942716]  napi_busy_loop+0xd7/0x320
> [  540.946537]  xsk_recvmsg+0x143/0x170
> [  540.950178]  sock_recvmsg+0x99/0xa0
> [  540.953729]  __sys_recvfrom+0xa8/0x120
> [  540.957543]  ? do_futex+0xbd/0x1d0
> [  540.961008]  ? __x64_sys_futex+0x73/0x1d0
> [  540.965083]  __x64_sys_recvfrom+0x20/0x30
> [  540.969155]  do_syscall_64+0x38/0x90
> [  540.972796]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  540.977934] RIP: 0033:0x7f6de5f27934
> 
> To fix this, set cached_ntc to first_desc so that at the end, when
> freeing/recycling buffers, descriptors from first to ntc are not missed.
> 
> Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
> v2: set cached_ntc directly to first_desc [Simon]

Thanks.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


