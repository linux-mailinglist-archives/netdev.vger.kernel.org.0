Return-Path: <netdev+bounces-7028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E0A2719570
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:24:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1974B2816B0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FB212B68;
	Thu,  1 Jun 2023 08:24:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E12D5392
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:24:20 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F504E7;
	Thu,  1 Jun 2023 01:24:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKoY0S57tMp71VAVutufPQgxm0Clf9MjoSb1ei1/jAu04/DZXAMnickmh9jM77dYnBlIDkQtXvo/y72FlTpFUYR+p+RDdf9VJpUbxqTrwoaDfoIW6Wm4nxljgn3mpUSyiehEukm9pgEcbdOQ2VO0K/LRYecwzPhgtHFIh7o6/f0OGGC8W29+nslGo6eZbyl+SLR0KqqB7FTqAgXLgrUOc/jtgzTheAy2E8+NMWzHjDgKkSDUfQuxUmhOvrJ01dR/c1AW76urWmCC7nLYyj7Fsy25Gjb70wHxVKmm+EUhbJ8pvfGELmFrRmAOdAq/gwRoBX3d7K5EaDDbbtfaOGOs7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oNEXTnaQvu65kPZkPeU6aotTYMudEjf3WeyB0s1NLs=;
 b=Ap4MU3277IRdeiaixzEGX08b16N8/my4hkTpu0Vc325gj65r4gxrgIhL6xUk6LbQ30cb+Hq1QmEPVmt6kPJacPxz0ByGeoXgE4UBVbHeYaNqhTYzfCHG8WYWHEPxIogkCv/bcGrohvu2/X/hazGsEjMsg+fpCq1hQ6aaQuBaNikVMNEoyzaVX3lkG1HLg1jKNtr52wae7RNgV6Ox0oUGa6ZrEBSHw5rc6FBfq8b6kdrVCLaCl70VhTA5OyBWK59Qdm8K2FdllXXaZkMb7qzOjbaaC406RplUfqPjICSaCJOYpwvYkOMQFJwDM4BA0ujsrC3fT4T/D+9r1hxqIrxqiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oNEXTnaQvu65kPZkPeU6aotTYMudEjf3WeyB0s1NLs=;
 b=mDBQHQdOi5o4+YkrVbipq6bcbbaPRTZhFxUhvhMI1wfgQx0Tb+C5erfwBjSAeOxq9w+Nje/ClDxJKzmorAW74hPrLu2zF8sWeax80OfB8AYMSkyztuAynXNFblkmr/zbVf3bPOBsvA08hV8E0hCyZunFLd8kncm21BCvSeM6KRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 BN9PR12MB5273.namprd12.prod.outlook.com (2603:10b6:408:11e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 08:24:16 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::c80a:17d6:8308:838]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::c80a:17d6:8308:838%4]) with mapi id 15.20.6433.022; Thu, 1 Jun 2023
 08:24:16 +0000
Message-ID: <a849499f-ac42-aafd-f848-3166a8f26328@amd.com>
Date: Thu, 1 Jun 2023 09:24:10 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH net v2] net/sched: flower: fix possible OOB write in
 fl_set_geneve_opt()
To: Hangyu Hua <hbh25y@gmail.com>, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 simon.horman@corigine.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230531102805.27090-1-hbh25y@gmail.com>
Content-Language: en-US
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
In-Reply-To: <20230531102805.27090-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0289.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::12) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|BN9PR12MB5273:EE_
X-MS-Office365-Filtering-Correlation-Id: 03e45cae-1885-45b0-6e06-08db62799691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	t3Hgrpen+HL+dcF5AFZdVYPQ3ggTraqcipYJrSpNrkKyJbqUS79Ej9BbJjiROqI0KjF7JMwUtHav6gW4J00zV7mLJUiasoQ8rv6ivW6GF19u9ohgXskC5Rg3D1rsow3F3xGJYK17ImmF3fpU3/m9aeS0osfrnBXQaTw2O0DyweiqsEak6r6mme/p6bLvBPyf40sq2IXHWz04ixCNyKv1xn6NrsuAyurZ4WWWBd4LeObUR+zc4sjDQPYUE39bncafUfCr56BX8Jh5KxHuS8U+A5jxVfOcg6Apkiitn8CX9aYVj02D2Q4BbHoNcFASKQwUu2ua2mpOQdgMqhAp4wDBeJ87wZOOJzdIa1nRRvaJYm9WUFgHjz86BM8Nvg7U8uTz1xbeFZfJTd/7cNnzlO6l4cMoszDbJxWWBNFYFPmWIcxGFPRUWp2Izl9poW2R8ccVaLgjAInuLQysV6vK35S9iMoUgT7AwtkIQSSaowdNQh0zNUI7qdGH9bEHnsWJvGhjGlzOMuQH4UDix+o6CIJvvsIDqXXeTJSeK6OGXYwKCAUCBymNcAqsqgnCyCeXCf1Ziw2yi4k8cx1bmTBWstj68/aNwCJhfRVyAVEny3huQ/7GtZDgDP/Xp6OFUsYNZNoZGIRy7CB02Y7VjY3Q0gTHzA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199021)(36756003)(38100700002)(86362001)(31696002)(31686004)(8936002)(8676002)(41300700001)(7416002)(5660300002)(26005)(6512007)(53546011)(6506007)(4744005)(2906002)(186003)(2616005)(6666004)(316002)(66556008)(66476007)(66946007)(6486002)(478600001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjFJM2xmYWpOK0pDb0RhSVR2MFBXY0ZDelc5ZEgreC9xb3gzNHU0THQvT1Nw?=
 =?utf-8?B?ZU5ZWEFOemwvSEE2OFdhNXgzSXUrVGNCenlocDd0Rmdtc1VsUmFIUlhERkN4?=
 =?utf-8?B?Tnl4aENOZnAxZHNSTHRkSnY0ZUNYQ09nSUJBM2NRamZ4QXhZWnlndUZ2N0xl?=
 =?utf-8?B?cW5vbzNvcXhqazRrQkUzRGthZkVaVXdMeDBrN3BGeVVXQUdxd2xpWnZWb2g1?=
 =?utf-8?B?aVIwdmNJbzlKeUxYQVh1akcrVVpHQkx4NXI0b0RoL0NTdGJRY3BsNUhjVVBw?=
 =?utf-8?B?bkJCalFlWDZrSDNkeVF1WG1qYVQ1MVBsTWthQ1RQZVFwWWJGWnBQbGlIUzNJ?=
 =?utf-8?B?WTdlbnVDS3VtWXpVL0FXME9WektXcnpmY200WkhuNlZwY2lJbHhLKyt2UDJK?=
 =?utf-8?B?WmgySkNKbE95Qk9KU3QrU2VSTDA2WmRwam1YSHdQY1VCbGlEc1daNVRkODNj?=
 =?utf-8?B?YXR5bWJZQkVabGRXRCsrZ3U1K2dmbmF6NDVrMEYySEgyQ2I1dkVLbGlFN080?=
 =?utf-8?B?eFNiWE9BdW8zaTRvcmY2NzQ0SnhSWmxxeENOSXlNY0E0Yk1XNldzbTVEV0Jh?=
 =?utf-8?B?M3drZ3ZTUGdzT0txYXY5MWR5QlVVQTNyYllTQnRyZDA4Q2FhcWVaZjhHbllX?=
 =?utf-8?B?RHBMNzc4dElla0paTVd1dkJLTHFESnVSQ00wSlVwNmNlM0Iyb1ZRaXhpc0Qw?=
 =?utf-8?B?RndCN1kvZ3NkMFNDd1MydHAzMlVLYzhjVi9DakVEQVBnWllLMUZVVnVtT3A0?=
 =?utf-8?B?VHo2SDk0dTMzTEFmOVV1R0l2WDhjaXJrbjNjU2RKTzR3OTROL2lPK2NWLzBl?=
 =?utf-8?B?QmI1TFhNYUJHNWorSE9hNFJYTWpUeDBVT1JzR0pHczRvbk02S0dGMjltcWNt?=
 =?utf-8?B?Y2F6TDAwL2RoNjZKMFhiSzY0YzUrb2Vlb1VodzNGazRLZFVjZlhubmM0aTBZ?=
 =?utf-8?B?Vm9tajMvUWFpdzZYUjRMREVveVlUd2F0dUNUSXQ1SkxzUDlPK2hBNk42Rkdu?=
 =?utf-8?B?SXQ3ZjRQRXRSRTlSaTVGZ3BjQkVmUGU1R0NHa0pqSDNoSjFMMnAvRVZnbDlz?=
 =?utf-8?B?ZmQ4TUdhTlI3anhScEl0OUJRSWUxMjRYNkJHenVxWEtoUThEa29VdVNyaWZ0?=
 =?utf-8?B?VzZxUjM1TlgwZWgyUDNQSUkzNFBSZzMxM2xpRmdubDhTM2R4UTNPRXVJeVJl?=
 =?utf-8?B?MnY2R3kxWmptYzV6TXlGVUhlSWlBUmdtQU9Jb2dKelU1Mk9yWkwwVFlJRUIw?=
 =?utf-8?B?QUpIWUhkZlFTUEVVV1lEbG90WE5PcjdhMCtIemczNXl3QXh0YmxKVHlRa3k4?=
 =?utf-8?B?R0trRHp6WEFHeFdKdFpocENjbExqamJzSkpnU2NOWTVWeEFwb3J0S2F0NU51?=
 =?utf-8?B?NGVLRDVCZG8yVE9ORlVGbUg2NjhaNHZnSlNTcGFqV01jK204QjNWbjlhYXg4?=
 =?utf-8?B?bVpjd1dlODFvOTlHTFA5b0dUcWE4b1U0MlRCWjBoRFUrRDhmKzBCSHFmNjNJ?=
 =?utf-8?B?WW91Q1h3QXkvTzRRbWo5VTJWdk1udEtTWjhPa3crb0RLL2d5Qk1WRXp0c2Q0?=
 =?utf-8?B?blk4ZWtzc2g0MjRpV0pwMHNFTWMzVndGODFFRjM3TzdCUmMzZXZaYk82Z3lK?=
 =?utf-8?B?ZFNCelRhVUtLSVp0RXFZVW14SzVoeXBQdENVT2ovY2JSNUJQanlYbkFnbmt6?=
 =?utf-8?B?cHVqYWpMU2dvQzV0N0dPYS9uMnlZb3dydzVEWnJEdFl2NkljYllKVVloMXRB?=
 =?utf-8?B?dy90K2k2dkUzK3BscHZ5VFVOd3h1VVRqa1JhSlQ2RlI0ampuTjk4elpDbFNN?=
 =?utf-8?B?WTJkVFJIV04yV3pvc3ZDMXd3Y0gwOFZUT3J3OTRHK0Y5YVBpa1lHaDRzdldZ?=
 =?utf-8?B?TGhsbzNwVS93Wk5laGVYYTlhWW5aaHVvTTRiVVNIY29WVG83M2ZWTDVKVnJo?=
 =?utf-8?B?aUZiK1krTzZiMFU3RllzZmlNd2tDQllEaCt3ekV4SHlOYjI2Mlo3M05iY3Z5?=
 =?utf-8?B?NFp5TCtMRGx0Y0ROVTdvVDN4NkFYcVVOOEpuWXdMaU9XUlBCQ3pGdVRpTWt3?=
 =?utf-8?B?R29DTEpCMVpDUCtNeTJMMThLVWxCdHRDNjh0OWNsMTZ5SXJ1bjg0akFLZDIy?=
 =?utf-8?Q?9MtouMITwU5BvH0N/rtQyRYD0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e45cae-1885-45b0-6e06-08db62799691
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 08:24:16.2970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3iH0gXKEMDt899MnnFeojXp25I4KLRsAYONZ6uF/9oe5g2T/UxbJqAMfYHgqXDPx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5273
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 31/05/2023 11:28, Hangyu Hua wrote:
> If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
> size is 252 bytes(key->enc_opts.len = 252) then
> key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
> TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
> bypasses the next bounds check and results in an out-of-bounds.
> 
> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

