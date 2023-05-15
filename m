Return-Path: <netdev+bounces-2503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2F470242E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A53D4281107
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D433B46B3;
	Mon, 15 May 2023 06:12:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CD93D82
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:12:21 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56732100
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 23:11:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ls5cziA1FECc2vXzPnQPRykSUmWYhgG1MEWNO6C3YIz49Zop/vDZr/ku4fmkw+K7HbvMlpAV6272n59x0U4rISPduovsd1jtUrPrLfDkSQzgPkVo12pWyIBQEny3wuxJQGfixV5sv6Xl5aBR8Rv/jYg2k00nyMd0gtvQrdg11p7MKpwPplza5UwWjCGSM+1WpntYtfT/LoLVWZX9JccELVz1ZbpJLxS+ujVj0Y9A2diwKqR5DSsOTzfmxcAAjJXfYFd38X9f2+wODDbWv04u6TDmKdcH4WhdI0yC1XKH96gKSIEQmA2Q+KGmQcLvlr7xOUxjaWQF/QJXluFEjhNRDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvqIQKyQXOBwb6GWlazz9gYDIdg8qTI2n9bh6dHin3A=;
 b=cLZMadow1JlTCDUDe2cjvIX9SnnXT5nlyu6m5mLA6isbGE67+Vz4wG9Ks6ngjkv+xv4alUywZkWpbUqbkkeO4QWbLdZVANhZ0XZW0q0/3L1PxNV06FHpXWmGTBQbiy1Q5m+LlTkGDPx/LX04Yvh+dvr2KOMOhOKYdASAp10IrENQtIriyEYAuYaG2vAM1DJQp0cR5dFXcIzHNo5EtPmexXWzUGpuE0JmV5UNtl2q3obcxhT6RRl2vwYwU+X+vHQA9AEKPZs433urxsaKLhUT9YKs0RgEL2XgKrdwGrCWi+oprM3m/VIqWM+0IqmN8C079F81+lKes68M8OD1fCP1Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvqIQKyQXOBwb6GWlazz9gYDIdg8qTI2n9bh6dHin3A=;
 b=nqmHE4L8dktM/rop2n1/gOwxURJOnbcToIYlrqp7uK1MQvahulxVvB4R4QZvtVGdQbkSFZEQeQgEoGBoIYQFQ5HO/rt+xoMw5xTVVMjJXouFCPwj7LUBw7Yu1lvSp+lK7PuEDHakD1Ftvybu+TfywhdA6YYcUUnB27906Hx7RCCRS8HFQ/7ysdAVNrB7E91aNve6qeP0rGCqI2rB8ZDu73Xf3AGUxV7eOh33ToioJYNpTyPtoy7FIMSijqbKry+M+ylEcw0YEq5o0rQ+8UoFYUdF+mizb369o4duepQaNKzolYm9Omn0j0VnjZtrhnUEE8wXilzvBVF+qrt8BVyQXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6018.namprd12.prod.outlook.com (2603:10b6:208:3d6::6)
 by PH8PR12MB7026.namprd12.prod.outlook.com (2603:10b6:510:1bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.27; Mon, 15 May
 2023 06:10:38 +0000
Received: from IA1PR12MB6018.namprd12.prod.outlook.com
 ([fe80::df02:1c55:a9c3:5750]) by IA1PR12MB6018.namprd12.prod.outlook.com
 ([fe80::df02:1c55:a9c3:5750%3]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 06:10:38 +0000
Message-ID: <43eebd30-cb23-ed90-200a-118f5726e2d4@nvidia.com>
Date: Mon, 15 May 2023 09:10:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net] net/mlx5e: do as little as possible in napi poll when
 budget is 0
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 saeedm@nvidia.com, leon@kernel.org, brouer@redhat.com, tariqt@mellanox.com,
 Tariq Toukan <tariqt@nvidia.com>
References: <20230512025740.1068965-1-kuba@kernel.org>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20230512025740.1068965-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0177.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::16) To IA1PR12MB6018.namprd12.prod.outlook.com
 (2603:10b6:208:3d6::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6018:EE_|PH8PR12MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: d5a7602e-03da-434a-aea4-08db550b1ab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Bs0Y51TQow41gPAE5pTRAwDf1+uUy81Yd78FAfpCRXVHI0fLdYc1U37td0rMUXaK2Ec03RZba0gnAmwbt5vMyZ8304UYxVDnOS1YhKaEYLfVPClGTn1chh3ehQwo7kgRKT/kF1W2nfXB63figFHDEfYk2Qu5yk/zKstMoPvo0i7AHs/JR0xHynkqAQ0P/J7xwkgR5P7nJjxIHlsw/u6aH/m4jH1CY6Anysi7UYBI5uld51fu6oQby+dcj8fvysdGOZuUGGLHS8AdXtea0l8RcW0qPYE3ugwhC2P3bIrREjhAyyMSAvG5yz1DJDZpPQIQUcCvyc9kCOoXzDq1NCqYgtTuRsa5eIZ9fJJ2SjSCbYy82QbowiEch/gMr9zJS/dCWxsRwE7i6baOmWyr2Kqfu58G/7ZlG8t9cpMYf+gB1T1kcY2/y387si8QWrdCyovbRRSHCExaNWSMHUSowChv/M3r22lNGWLZjR38nUKYAQ7s7EoXeDd9BMrxAy+UvnAQPF5eK/wedb2gtZKxIHNJq28GHMo+WZMtvsvUi7znGlEOl508KQ0dyMr6qTvQM4MpZrkkhky97vzP5aYe5u8fcfvskQ9MebZpjTpqguDfqQQ0e4hdV3Rt81Al1cHhUB8EUqpHg+5BsEU1x5bLimcPfQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6018.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199021)(6486002)(4326008)(86362001)(31696002)(316002)(36756003)(66476007)(66946007)(66556008)(478600001)(41300700001)(8936002)(8676002)(5660300002)(6666004)(2906002)(38100700002)(53546011)(2616005)(26005)(6506007)(6512007)(107886003)(83380400001)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXBzOElSbitCVnpMSkpiT3hSQSticzd5R1hwSTFUWWtRZGRxcXVRZUhFalYx?=
 =?utf-8?B?SXZsYjJkMUJ5WHhqVVNHckxGeFNTZm5zWE5xNTkvRTFpcXpsbUVyT0FXTUpX?=
 =?utf-8?B?d2czK1RVdk9WQUZaaWJLVXE5c0U2K1N3djdXWlh3VVBRVDJnbEdwY25lejNS?=
 =?utf-8?B?Q2ZIb3RHbjVoZUZ1Wm52d21CM3JJSjJDMlNmM2RtQ2ErcjFSYkdEeThHNTFv?=
 =?utf-8?B?OVF2Y1h4bnhwSzFjbXBFVnMyM2xwb1ZidU8xNWI0bEpMdTAydmZwYVBMVE1n?=
 =?utf-8?B?TC9oSDJreXlrWXNXMzliK0szMHY3Umx0djE0dGo0MlF3RnVzNUE2VHBSdkxs?=
 =?utf-8?B?SVVYSTl1NmRvWUo5bHlCVGdQZm5Md1NlNnprNVRlTC9RdUd4b3JxN21UaHpr?=
 =?utf-8?B?Uzk1SVl0Mnk1T09KZ1dzcDlQeEllaXhFenM4VkJYaTdpVHNacXdMcWpBMUlL?=
 =?utf-8?B?Q3g2d3NNSklSMFZ0aEVNV3lzOVF6MWowL2hsVytwdTllMUQ1aXlVemJuOGJl?=
 =?utf-8?B?d1NjR0JyMEVkdjJFaHg4RGlWSUN4WitDeXhLbU1FT0cyS1B5RlhpcGU3aDZj?=
 =?utf-8?B?aTBKajBoOXgvaEZMN0FtSVRxU1M0V0swelRBazRYNWR6VDZTM29aM1AzRlU2?=
 =?utf-8?B?eG5kNGZxQ2U0UFBhTzlWa29xcUVPNURLZUZDaUROdmdNU2l6TklhdWlwY3BB?=
 =?utf-8?B?OXFpYy85OERaTXRKSHBhLzlBbEtUTlJZK2tadXBIV0V6SE5JMkFid00zZllq?=
 =?utf-8?B?RXd1UkxURDVjYWU2Z1poVG1GN0ZOdEJJd1g4RkszeHN3U3BTVUhXUEZpaEdm?=
 =?utf-8?B?ZzVoWkgyRzhrUHpSQjczbjdhRFFPVGZaSFI3VG01TGZzMlJUUjl3Qy8xNUg0?=
 =?utf-8?B?ckQwRS9FNXdjR01KQ0hvUFdISXRoVFFGbTVwNG50Zkc5SnBUUmlkV3ZsVVJE?=
 =?utf-8?B?dENXb0JSUzhtSjVuaUMwY243NVl0UDlIekwvNjZ2WHEzOG5Lb0U5d0RKamEx?=
 =?utf-8?B?T1BPdVE4T2lqUFVsb1hhYVUzUUdWTjhWTkRLYnI3SHNLT3dzck85cm4vNVA4?=
 =?utf-8?B?T1A0NGF3Wm5PRjBlWGYydExMOHRGOU5kY082cEJDSjNnMmhwMFh2SmI2QS8x?=
 =?utf-8?B?VGlybEhzSVpLQkhYZ2VHMldLMUNSelJ0SzZEVXRJRFBVWTh2RzFlTUQ0TDdH?=
 =?utf-8?B?K1lvY0RJMmU0bGFuYXBtZTdBeFg2WEVsN2poMU5mRDhIRGVmMlA2Wjl2TTBt?=
 =?utf-8?B?S1FQQXRWQ1NPaXo0aTlvZm1id3g0Y0hIMzVsR0t0YnlvZU1pUlM3WGg0Y1Fo?=
 =?utf-8?B?anpjU3pHc2paUm9tZnhlT3pJR3hyWkhMNUhrS2ZDeldjYnJLVE1xOXYrdHpi?=
 =?utf-8?B?MVhmRUVqeU5sMzI0K01GaGxzRHU5TTd6S2ZmM0lWMVlLRlZ2bmRlOVNGbE1L?=
 =?utf-8?B?azlmK2tzeXV3YVNUUDk5K01vYWpDUi9Jc0ZtSVZoNlhNclc3aWNTQlJtaUlt?=
 =?utf-8?B?c1hqRDdCRDY1K1RKejlDZVlXdlNYd0k0MXdTVFIwV1YvWmwrN1hDVWlRQWlj?=
 =?utf-8?B?NmZFZDVjNklnaGNZVzhVNTgyQ1MxamZUMVZWa21SYkVLdU1tejhUNmwzMndW?=
 =?utf-8?B?MkdEV2N3MHg1bEFleVdFZUxpdTJyRVdyalJ6MG02TjNtclY3dHQvZVgxZXln?=
 =?utf-8?B?Y3BlcUtEOHRxUzR4VzFybUFLNll5andodlFYRG9EK2tsLzE0cEVUUFViTG5l?=
 =?utf-8?B?RlhXRFUxNVpzbFAvTG0yVzVoai9hSDVhMi8rZU5TVzFBWnl2d1htNUlaY0RU?=
 =?utf-8?B?T2prZythNzB3a20rdHJQTGdNWktyd3FWaXRDQWI0bTNJZkdkQmdwQytudEE5?=
 =?utf-8?B?U2s2RVZSUWd3SFVOeVVHTTluY0ZMbUtubmVaTFc1N0U2NTBKOWhmRjVENk40?=
 =?utf-8?B?VHpCS0JvbUlKTzAxdDNHRS92cFpFNHcvVHlBQWtwK0hDQkFqK1BIclBZSWZB?=
 =?utf-8?B?R1FBRjBDS1hMZVBGL0FTcHNKZEFkUzNoMkZjTDYvaHNKWWV0elJUa284c0pw?=
 =?utf-8?B?aGhCQUVhbnhvcWJldlJ0REtVZWMvQmtCY0ViazNmcWFrcUl4ZzMyaHJBSVZa?=
 =?utf-8?Q?AteUXZE6i4xgMVVmmZeWydTVJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a7602e-03da-434a-aea4-08db550b1ab4
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6018.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 06:10:38.6384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2M3wQhzoUb6XVkKDD9D7AnN1n0mPlG9OBWJa0WHgcbXBgKRFBXJ8BLHBOeXEPwqGummuE+QMoWOBxkkKQ5YxiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7026
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 12/05/2023 5:57, Jakub Kicinski wrote:
> NAPI gets called with budget of 0 from netpoll, which has interrupts
> disabled. We should try to free some space on Tx rings and nothing
> else.
> 
> Specifically do not try to handle XDP TX or try to refill Rx buffers -
> we can't use the page pool from IRQ context. Don't check if IRQs moved,
> either, that makes no sense in netpoll. Netpoll calls _all_ the rings
> from whatever CPU it happens to be invoked on.
> 
> In general do as little as possible, the work quickly adds up when
> there's tens of rings to poll.
> 
> The immediate stack trace I was seeing is:
> 
>      __do_softirq+0xd1/0x2c0
>      __local_bh_enable_ip+0xc7/0x120
>      </IRQ>
>      <TASK>
>      page_pool_put_defragged_page+0x267/0x320
>      mlx5e_free_xdpsq_desc+0x99/0xd0
>      mlx5e_poll_xdpsq_cq+0x138/0x3b0
>      mlx5e_napi_poll+0xc3/0x8b0
>      netpoll_poll_dev+0xce/0x150
> 
> AFAIU page pool takes a BH lock, releases it and since BH is now
> enabled tries to run softirqs.
> 
> Fixes: 60bbf7eeef10 ("mlx5: use page_pool for xdp_return_frame call")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> I'm pointing Fixes at where page_pool was added, although that's
> probably not 100% fair.
> 
> CC: saeedm@nvidia.com
> CC: leon@kernel.org
> CC: brouer@redhat.com
> CC: tariqt@mellanox.com
> ---

Thanks for your patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>


