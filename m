Return-Path: <netdev+bounces-178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D836D6F5A87
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 17:00:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADC041C20F5E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19FBC1079A;
	Wed,  3 May 2023 15:00:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082F24A11
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 15:00:34 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BE149F9;
	Wed,  3 May 2023 08:00:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NggceEvxQhh1xRFs3nfuVSxvUkFvBvv3pOTWL8RBZMlb5RlVqExKdyEBDhGf1a5hIbwt2mabqb/OZ7cOHHofZdNs2HYXvz+IzNZl+9x6LSZp5bsAzfGfkaKYNZ3gsinQluBOFZBGh5rb7eAKk22goSu6DAc6enexWZGMZeZbm8xfJV2kRQZVZmu1575ryTORmfd9xjQYC5ZlSpJvzCBjh+9yEqyaKH6ioES4dUWkwZ8wfiIwUJadGHkiWGZhuA5IcbIwjo3xuj5kQYtsxTxuN0Hdk6mHkby+eIJGPt4AFjrQ7LIhL5lQ+1gCxDaoVFb8oxtk3eYhJEGetcvsuFhZVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9nXqdqYMcYrK/yplpC6fNvvdxium6IdSAbnQ1QFWjA=;
 b=JPKY3BF2xnlS/EpXi4BngNhenO2rlGeIB925jkmwEcUlCxVL/uown5LKde9FhCh3WSmK3GqkRM1W+zzHS6CtHC06fb+HSanbfP3Yc/a98Uf8Q8BE3zLMQd+Zfw5pzZAljvTvySjlVFbiKOktxU8+HsdWVyXcGhATnI+OmIlYA7FZZrzAOc4RV5xXtQjoCsiiyS8xINqkhojf8ZtVkeZw2qCiBpASLeqQpuqGXrxnrRVTRD6NjT9vg5QhsyFXP0OZde4euDlpZLwnxDaV5syxy5sR/CUxifRaEN7nER/vfJbJackJeTvQt+bn6md0lu4xeOVlzXzevpKM1cHA6L7YCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9nXqdqYMcYrK/yplpC6fNvvdxium6IdSAbnQ1QFWjA=;
 b=UDkh79F278dO6oCdbJadnpOU8CZBBH69y2miRonTCDNSZx2foMWTWb6mXrjwl7VCvuXSFmtiaJwLiysQWsLTS4AUA42Oas1baFy1y/qIZxiPMu47UlKEXbihvvYoCU3mavmu5zQypgKc1pbW0jZw2EUAvdBUDmbOVLrtJUaBj76xMkwH8rxwOrLV/CISkbEaztL06btArZ13+fVVCloNLDX5zhNBysY186OFQ5WMMXBqv19MYcjj1s+tMUqZ1hw+OY9n2czNIwV6VYOL9KMieISjF6gL+THKo05qyD58l7p/bIjjPRcBQL2p8BBpNXb7DS4o/VSZLHKdP2JppjNWOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16)
 by MW3PR12MB4538.namprd12.prod.outlook.com (2603:10b6:303:55::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 15:00:30 +0000
Received: from CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136]) by CY5PR12MB6201.namprd12.prod.outlook.com
 ([fe80::a7a3:1d9d:1fa:5136%6]) with mapi id 15.20.6363.020; Wed, 3 May 2023
 15:00:30 +0000
Message-ID: <482f00d4-d3f0-da85-93e3-a4a2e5597e12@nvidia.com>
Date: Wed, 3 May 2023 11:00:25 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net v3] virtio_net: Fix error unwinding of XDP
 initialization
To: Parav Pandit <parav@nvidia.com>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Cc: Jason Wang <jasowang@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Simon Horman <simon.horman@corigine.com>, Bodong Wang <bodong@nvidia.com>,
 William Tu <witu@nvidia.com>
References: <20230503003525.48590-1-feliu@nvidia.com>
 <PH0PR12MB54816403B23CE6D0AF2FD035DC6C9@PH0PR12MB5481.namprd12.prod.outlook.com>
From: Feng Liu <feliu@nvidia.com>
In-Reply-To: <PH0PR12MB54816403B23CE6D0AF2FD035DC6C9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0222.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::17) To CY5PR12MB6201.namprd12.prod.outlook.com
 (2603:10b6:930:26::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6201:EE_|MW3PR12MB4538:EE_
X-MS-Office365-Filtering-Correlation-Id: 388416ab-4002-4626-7f60-08db4be72309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Vn46b0+jRY4njEtlkvp4NBucaHJW/Aw3eASiM9Pf6eNwEtOiHIRTdwIW1a4fZTy5JUtrZJRVcVHvX8D82RcVPmkLZe+YEstSYxkHq7GX7jjXmgJ1bpeLbRnmrkfCoJl9aj9MGFNEe5USDDn+2jFi5z67lIUBaLKdaLFdPIZHEWxO/2jz8EOtZ5sQEEh4fis59wJwA0ES8k/I0O+ludj0zRn2Ri9GfDGdrSAFW7VnfdASV1zcc5mKtPymCFHhUhna9pb6p9CTzB75LXLjrP/O5s0twkQ1WyR62tGjLUKcm6AzsviaLxpq+bsvqED+MYXu3yDUOa/GWDMj9QgzAvZ1qDu0jMnERc1tjrz4+5ZSbjEuVkA4lIOV3cL1PToJ3l4vPywgr0WCmJIep2DnP55FkwmYwAwL2Ru+tcDR+stAjF22tgqVtjZHo+OAqDGC/Pt7lDzXv1WU3wRzTjiaNvWT2BA2DtIoZeEqwaimlgJnMMtOdc/9B4+N+2eCOINAB8wsYIDwK9Wr6sG5TgkuR/nrDkw2+4CnsAOEb+0xBPMphETkckLMcCLsNtAq2kI6uGsO/3NkTsgmaanCgd70JXt07/6vaTp/zzF7pxHfG2VlF9S31QCfcttkdkNFY8CUMU3OQKLzRUcGsvXXkugZvT1jmw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6201.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199021)(31686004)(5660300002)(41300700001)(4744005)(2906002)(2616005)(8676002)(8936002)(316002)(6666004)(6486002)(38100700002)(66556008)(66476007)(4326008)(31696002)(86362001)(54906003)(478600001)(110136005)(36756003)(26005)(186003)(6512007)(66946007)(6506007)(107886003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TExQeFJILzhtYk5rSWNubnk2djV1ZFFqb1dtTVZtUUVCVU5aS3ZzM2dHaC92?=
 =?utf-8?B?UlY2ek00VGdoZUNIODNaYjBFSkZsWGJYUWU5Nm14MVg0UW5FTTJIQWo0K2Ex?=
 =?utf-8?B?MFR6VFg0VDMwN3RyOFM4VFcvaEo4bldBTjkzbENHM3hOTFZZbmpSWGt5Rkxu?=
 =?utf-8?B?UkJpRzM1RzcvSDRjeHl1ZTVCVmZubkNreTEwQ3FQUk1HanIraUpCT09XRlhy?=
 =?utf-8?B?WTUxbU04ZWkySC9xZ2NrNXNMQjJBZVg5MmUxa2hteDFNRXFPYVQza2VIbTU4?=
 =?utf-8?B?YjJQS0s4emE4aUdJV0hrQnltNHZJeGxqZ2FGcDRYeURseVdwTHYrUTZyMjJp?=
 =?utf-8?B?TTVuSFpZR3lHYUF3M3ZXNFliUUxrQnpodGkwSWFuM0NlUy9xZWFkQ2RzbTFV?=
 =?utf-8?B?S1ZVb2hxVk5BMnhPdWQxcncvR1B3a0UyY2ZHMmJXeEc1cVdpTVNySDd3dVFa?=
 =?utf-8?B?ejRqb1RIa2FGYXI4SHpuMzMvcFRzanlMZU1McFlDS1dUaGlBRFg4R094UkdZ?=
 =?utf-8?B?UlFsVmw3MlI1YytTTWdVZmp5Vmd1cWdYd0sveEtTZnFtMlRmK3lVcWd3QWw2?=
 =?utf-8?B?L2djKzJld25TVW9EQmVZcUNHc1JHVnMzcklnNDh0Tkx0Q0ZmSzZnZzFETnpt?=
 =?utf-8?B?VTFNbWE0dUpJYU5qSmJBaU1rVmNQaUEyQkdQUnN0Q0V3a1RZblpzRlY3cnFO?=
 =?utf-8?B?N2RuZEZ4c2dscy9xdVZLWHo1TDk4UW5WaWgrSGdHeCthYnVkZW9xaGExUmFj?=
 =?utf-8?B?RCtGK1Y4U3RGeG95RUtuSGRXYVE0L3A2VG4vZzF4WXJwT09PRmppK2NKMWE1?=
 =?utf-8?B?ZFAySytDeGRjeXpDRFZhWUIvVkF4MnlVM1k4K08vY2J4WUZhQzNyTkpldHFF?=
 =?utf-8?B?NGZ6TTN6dGZoSzdDVFkxeXlDRXZGNE1jWjNwY1VpNkNUR3lOeUtwWTg1eGJ1?=
 =?utf-8?B?UnNCR01oN2dhMEk0cUNtb3dHM3VCVE9YRGtFd0VaMVNwdFJuTFpMalQzdFo3?=
 =?utf-8?B?Ympma1hJMHgra3p3NzVyUENISWM3SmQ2QjJQOGJ1eTM4cUZpclFRNGVpWFQ0?=
 =?utf-8?B?OTNreU5uUVBtY3VyS1hyd1NvdENFbFF0UnpQc3BTZDZDTWNNbXhWVkE2YUg0?=
 =?utf-8?B?OFluaE4wSkRFNmRtY0JLeXpEbThsUFU5N3pqT2YrZzE3NDNQWUt6amRBMVk3?=
 =?utf-8?B?OUhCQm1EYlVoRTVGR0pqeEc3ekNiMk80WjZVbXYvemp1Z0hDb1RzRlYwd3ZS?=
 =?utf-8?B?VVNQd0NDVEVqcXNRZFllZ2JteXdxYVBMUTZLQ21ndkFqN3h6UjRTV1M4NGdH?=
 =?utf-8?B?YXlJRWNPRXpENEJJTytnUzA5eDBQMmRzNTlrc2JWdTdvbG5BVVBQTzJ0NDVU?=
 =?utf-8?B?c0JBVWh1eHpEeFFmUnprbmI0L2hVdENCcGR3SWFJTi9sZ0ZsSitNN0tuVHd2?=
 =?utf-8?B?eHN0YUNGQW5ROXN3U2VZK3A4MGdhaVc4b1J4NmE2YkFMU28vdHI2Y2ltQm5B?=
 =?utf-8?B?d1V5Z2lHUkhaZERPZUsrVEg2S3NYc25SeDc5bFQxanFOS2g1ajhVU3NVTitB?=
 =?utf-8?B?RlE3ZXAvL1V5NFVsdWtLeTFWcXpYMVh3dnVHNzhEVHJpdEo4cGJZR21DVk43?=
 =?utf-8?B?N25yWHRrKytCbHVyeDBwM1k1NHo2WUpDVWtHTWxVVWZ6M2hBVjFXZU9nUlZz?=
 =?utf-8?B?K3E3TGdNWkJXNGRoTlRLVkw1RllPS09YelRyQ3NWUnk0TFJJeVB4Y3orLy8v?=
 =?utf-8?B?a3B6QmlOMWRaY3l6SjRwTzJwbkJjdmkyYXB6SENkYTlJMENHSUV4aXVHQ3cx?=
 =?utf-8?B?NlFxNkhBYWl0SWVsUUpoR052OExXSWs3c0tRUGRVb2pWQTBxcnJzcTN1SlNa?=
 =?utf-8?B?YUhxbUtCeXduQiswOUc1bkh1a0sxZkRqeFRaMFlwZGV2cnVVUS94UGhMeVlC?=
 =?utf-8?B?clhyaW9OTGViUzkwK09FZ2tucjE0dkdzSzd6WU1CNndhTnYzN0RkZ09WcGJ0?=
 =?utf-8?B?cXpENE5WNk1WdVh3ZWNqdUhlaTEzc0ZGaWhReEdRQ2F3ZExaYXNubTFtR0pz?=
 =?utf-8?B?eGJhSmFwSlJNVnVOWFloSGNyeCtCZ1hENmtFMmNKaGxFNkF5UXdsV1plUmEv?=
 =?utf-8?Q?+JW3mQayz9gDILXH4A6pvX1bo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 388416ab-4002-4626-7f60-08db4be72309
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6201.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 15:00:30.1887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mor5W2bqxhBZ+EYVCE28fzU8hQYuQqJHRxdHbW/heAK+BCeSqxeGix7+GG09//fG6t1OId+MsRonUatYxwOgFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4538
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023-05-02 p.m.11:14, Parav Pandit wrote:
> 
>> From: Feng Liu <feliu@nvidia.com>
>> Sent: Tuesday, May 2, 2023 8:35 PM
> 
>> Issue: 3383038
> Remove this internal garbage.
> 
>> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
>> Signed-off-by: Feng Liu <feliu@nvidia.com>
>> Reviewed-by: William Tu <witu@nvidia.com>
>> Reviewed-by: Parav Pandit <parav@nvidia.com>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
>> Change-Id: Ib4c6a97cb7b837cfa484c593dd43a435c47ea68f
> Remove this internal garbage.
> Please run a local script not to forward the above garbage in upstream patches.
> 
> You are missing the changelog from v0->v1->v2->v3.
> Please add and resend with above things removed and with changelog.
ok

