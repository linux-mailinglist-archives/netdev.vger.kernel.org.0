Return-Path: <netdev+bounces-9942-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C5572B35A
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 19:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27EAD281128
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44473FC16;
	Sun, 11 Jun 2023 17:58:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32687DDB0
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:58:45 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA66012D
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 10:58:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdS0r2w/c9xFy/51Z6mp/bElscCse2H6HoPve/JMldzscHktJfwMy21GdJa3dWhbCEFzrm5UzZsto9REw0IehAAiybtcwsBRLsVfuWowVK4uXb0wAcv3GoAo/VTJkNsfPIpk6O6Ze3FrwaMSC3wyq0l1jNgsl1rdpKGvg03l6QWsbSm1rQ5q6LleDRMet3Tet2+SStE1rpT6QXWJ+WnmbMsYZvjQpmHkaZxyHOReIXjxNa6Qw/BbbgrSyVG0KM+/moj3FNH/+emKF9iMkLRWGSBj632G1/9gsPQA0oIaG77QxQpcZiTAgwfRO42Wd8XxFggZBh+CBRdOXolPe4O1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLYkSDQwKYHZToKbb1FkE57lDX0qFjpJ10ThwtfvW+g=;
 b=areGYnZlWTWRyv+Bi+jUC8Rh16MZEmXdxUxA0/QeREMXFbIS/zJZN/UW/3oTbbrFwUZ3NjbVnxSorlYoJlECoTP4YpFwdo/J9MHIsbMxqH2sqCTF0TL+D/yTFE8PzwIpen36aL3pb4JxJnu72Rge10rp78soh37loE6eluO+x0Cmvg4nThzcQmirYFrpUJkwO9cGM9008/amPmGLvvAv4BT+K0v73V956Z69lM8BShSTAoi8z+IhUW56XPjVT2tdw0/4w6CYkRUDx/t8q0hTiGPTr/G6g4l342XzE7GExHG9ww6sBeaRMhpwk84XqPtqYUXS/GPiDoZLyfSmYHaMyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLYkSDQwKYHZToKbb1FkE57lDX0qFjpJ10ThwtfvW+g=;
 b=IsA9ZPXDsO//JMuL0ZsvchEEeFk+SN1NEaEfAUG5PFiPbBIDZUh3XFIvdwuD1aJ6gG7QF0JF6U7sl5oWkOabNHiM7JGJSd2RxIcmlXhtbVO/WksHrBBbG+7ihfOxssKgKBLxC7oijWabBx44HUIdlQdL6UTIGfzGxt+eTpQjHAQ/pPm4pTcMZKC5PKMpf7gSRcdI7q6aMNpssed14608JZK04Ot/C1m7J3Rfwe7BaUhFDvYLiCtzbnb2JGu2cSZFd5LJFG5Jk1E4Lf1ovT2U7sPv5gt3ZsSpOr4+MR79phSxRs+WkeDSpXh5JsR5rI46QlDsEGE7+vro4EHet52xYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Sun, 11 Jun 2023 17:58:40 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402%4]) with mapi id 15.20.6477.028; Sun, 11 Jun 2023
 17:58:40 +0000
Message-ID: <9b59a933-0457-b9f2-a0da-9b764223c250@nvidia.com>
Date: Sun, 11 Jun 2023 20:58:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to
 IFLA_VF_INFO
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
 Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
 Edwin Peer <edwin.peer@broadcom.com>, Edwin Peer <espeer@gmail.com>
References: <20230611105108.122586-1-gal@nvidia.com>
 <20230611080655.35702d7a@hermes.local>
Content-Language: en-US
From: Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230611080655.35702d7a@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VE1PR03CA0031.eurprd03.prod.outlook.com
 (2603:10a6:803:118::20) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DM4PR12MB5072:EE_
X-MS-Office365-Filtering-Correlation-Id: acae78bf-2899-41c0-aef3-08db6aa57d03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tAYLNexeAEIJYuEQPjhofNlt9y8kk327khE9MKTd/p/LSPviywTsX+LNdLf1s078wgXQZf/oSXOmzTKHa9csjparhjfWy6ZMr/rshU6qGIxr4tDcKJ7dAjiJttmehGEujykM2JxdWNX0LFNJgjH+zxpqYF9PNMlotPhaKY7Eax7t1Vj92I6QFxw/1WZHgg2xwo+J95dU0XZxQTDNXDkGIsd8AHybOdzIXMI+SXTrErh0Wk6x2EIacRrqgDqu8mVhHzsgfePWW3GxvSxqHOs+oPEOT5KvTPFyhJVisLf+uE8HWr3NBzsynC94VZ3ZX9iD5/eCi/vQIg6MTvR54MOejsUTmhZWVzoj5BnwXfpYN0NCyw9ZsbZSqGkX1kInHXcKnv669Xri+Yqg5vo2aaIgbGZpwL1KcyMRiW4Sx3QEzuAvb+SzyzGyScuIPFZOuO03slNdgcRxW3PzY3/6VZrnpjJTsbS7VzmG5ezyknjXfWzwdLY6PEtSOQ6XCcNRVTonq3VSdZj4Q/joYjp4Mn2Uv79ABdqQGnfAOdtUc+f2dUbg0WVXeBuetVkKzIhvXE2GNzfSW23L+ujA4Yx7G0IEsN+NEMbiPA4ZpST1H02Li2DWPiv1sSQGUuCTYJ75rcSL6lW04bIRZXFTBSJPDcJ0zA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199021)(83380400001)(66556008)(6916009)(26005)(6486002)(6666004)(6512007)(53546011)(6506007)(478600001)(54906003)(186003)(2616005)(2906002)(8936002)(8676002)(31696002)(66476007)(5660300002)(86362001)(36756003)(4326008)(41300700001)(38100700002)(316002)(66946007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STJoUElOd3ZHdUx0QjBLb01yTEZLN2I5cG9wVDFFbzA0c0JVaWdhTVB1dy9o?=
 =?utf-8?B?VEdlTjJ5TjZTY21wL3JyaERpZit1ZG9GRzkwRzR4Z2FvbnM1aU9jUDMzdXQr?=
 =?utf-8?B?NTVZSXZIUHpOWjJSYVI3MEhkdEpxeUh6ell0R1JzMGZoUUEzclI3VHZUOWhP?=
 =?utf-8?B?cmtjbXRtUGhjUzZRVUFQcENGdSt2bCtYK0dPNnpRN09Bcmw5UVU0c0RBMW5x?=
 =?utf-8?B?K1I3TFBMK3B5WVJwRVlXVWdxRXE0R3hnVTE3cTZoRHRsNTJuSWNyTmNXK0Fs?=
 =?utf-8?B?ZG1ENnRHemlLaEt3L0owTmhzY2VmV2RMb0xxVlc2bTVKZDI3VkZLVHJxYm1Y?=
 =?utf-8?B?ZEhJY0xKMWYyMXZMNUNYYnQ3bHFiamtwVUdNY2hVZGFBSGRYK25MV29DK0ht?=
 =?utf-8?B?dVpIaVorRzlWd0NPOFI5NXdtUGFKMCs1Mk9zWThTY29pRVlLMlJsRnJ6cmta?=
 =?utf-8?B?ajg5cDhTcVNER1JEc3pJZThVaUJzUWdFNUw2M1haa0QzZEpQcjNBOENQNmtw?=
 =?utf-8?B?TWEvVk42TGJLQlJSUThHaDNoK1FBZjhoVUFqSndqUVorem9uT0N3SkhyNWNa?=
 =?utf-8?B?ZndlSzViRHFsalBSangrdnA0Mk9OZ2RLVjFJZkdyVjVua1d5VGdtVzBMa3lL?=
 =?utf-8?B?Wm1tWEIrdkhZSTN4eFZqODYzbm5RQjBoOHNxaWNtODZzUnlud2hPNHhJOWVR?=
 =?utf-8?B?RFpiY2ppRmM1UFVDZ1dzbzNNU3lqOGk1WHNhaEhiNi85ck9laHF6elE5Q3Ir?=
 =?utf-8?B?aTk4WjNzV2d2eHA0VTN5azIxVm5ab0tBVmxEN3JTUHVJSFF0THl2VjQrYk9u?=
 =?utf-8?B?enJwSHZPTDZDL3RTUEJRVTZidzI4UXRQZVVMaUllZ3N0Mk1Fc09LQ1EwZWlx?=
 =?utf-8?B?Uk44UXhwM0VJT3gvQldrVWJxcWpOcU1GYVBiUmFleHoyTFNuRm5FMUdJczRS?=
 =?utf-8?B?SU41d0xvbE4rQTJkZmVsaGtJQU82TTB0TGRIQ05NRnRheU9SMENwL29NY3lr?=
 =?utf-8?B?VWpvWCtoMzh4RUd4b1p5bnRZdFgyeWV2RWd6WEJDbnNpKzREWDdHb3FGU1d3?=
 =?utf-8?B?M3NSWDMxR2pYZVU4QW92QldzeU85Umd6L1kybWxmVHU3SmhPRUdWeEwvS1c5?=
 =?utf-8?B?UmtpMXBxWWNTR2wzUFMxc0FMS3dSSXYrbVUvTmlrblNOT21QRytLN0Z3QTB2?=
 =?utf-8?B?SE1KVnNzcm9weGRPb3lHZkZoamJwY1lvRWt3cXIyQUJNV2NKQ1ZUa3IwNE14?=
 =?utf-8?B?QTJzaURxNk9LYmlyc0ZWaUhYblBUN0h3akRHZ3FneXNmOEdldjEvVFpZVlVN?=
 =?utf-8?B?TGhRMHhlSnJZMlJUTVJrUjNkRWV2REdQWUkxa2hucStsLzRyL2FOS283elR1?=
 =?utf-8?B?UHF1aTRmOUxoQ0UwK1JaWXFXYkttMVNYTkMvVUtYdVVkTVB3d2Q0c3JqZDV3?=
 =?utf-8?B?U0J6ZjZwbW4yNmpVaFVsaGR2b2lEQzNYL2k0ZWNzTmVyTTB6R0RKbzdOYVZ6?=
 =?utf-8?B?RlhEQU1MaU1FUVNYNmhYYkEwaWpEbkoxU1hYeVE2dy9DRFdHVWJ6SnBSNGl0?=
 =?utf-8?B?S1YyUFZhSnJjb2hzTDlQckNJMVdzQkJzMmNMR3VCTEMzaVhFd2xDRi85QnIw?=
 =?utf-8?B?MWFON3hMa01xK205dTlLZVBxTDVsZjl1UHkzVnhmMnVScmRBMnB1Z0NYN1VL?=
 =?utf-8?B?ZzN2d0xXRFc5M05hZXZaMnkzOHVkbnJ5Y3dWOVRrQ2NrQzUvbXoxMnBveEpY?=
 =?utf-8?B?aExBU2NWcmszZnpaaURjS1ZuRzVlaHMxRWlYYUVPNXZXNHFZTzNvcE9aMWZk?=
 =?utf-8?B?YXRuejA4c1BiVVRYdVhyczk5bEZCNFBoK2lJaTJQeEVRZzFMSjdhaFgzajFt?=
 =?utf-8?B?dXpYT2JzRndoREpBVU5TbEdhTkRQWm5qT0JoUGtvSWtSRU9FNzRmVUd6OGxX?=
 =?utf-8?B?VlZCK3ZLRFJmdGlCem9hYStGaERQanp4UklwditUU3doMUNOdzRCbnZ4THVm?=
 =?utf-8?B?Smw1Vk13bVljR0R0NGRTeStjajdRSlZyd1BhVVdncTFBUXVtV3Q5ME5seXMv?=
 =?utf-8?B?T3NkVFdJK1ZsWUhWZXl4bE82Z0tBLy9hazJmYlZIOFFpdUFvVisrRE1ocmwv?=
 =?utf-8?Q?b0RrQks8MgLhJ4UZI1Wj0B5mv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acae78bf-2899-41c0-aef3-08db6aa57d03
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 17:58:40.4997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8iuM/tCVV2palKHXcd/M6iqb1tzZ1Oy1PBz0bzT2q57r0gBbNgNkEP33VPdobaNI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5072
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11/06/2023 18:06, Stephen Hemminger wrote:
> On Sun, 11 Jun 2023 13:51:08 +0300
> Gal Pressman <gal@nvidia.com> wrote:
> 
>> From: Edwin Peer <edwin.peer@broadcom.com>
>>
>> This filter already exists for excluding IPv6 SNMP stats. Extend its
>> definition to also exclude IFLA_VF_INFO stats in RTM_GETLINK.
>>
>> This patch constitutes a partial fix for a netlink attribute nesting
>> overflow bug in IFLA_VFINFO_LIST. By excluding the stats when the
>> requester doesn't need them, the truncation of the VF list is avoided.
>>
>> While it was technically only the stats added in commit c5a9f6f0ab40
>> ("net/core: Add drop counters to VF statistics") breaking the camel's
>> back, the appreciable size of the stats data should never have been
>> included without due consideration for the maximum number of VFs
>> supported by PCI.
>>
>> Fixes: 3b766cd83232 ("net/core: Add reading VF statistics through the PF netdevice")
>> Fixes: c5a9f6f0ab40 ("net/core: Add drop counters to VF statistics")
>> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
>> Cc: Edwin Peer <espeer@gmail.com>
>> Signed-off-by: Gal Pressman <gal@nvidia.com>
>> ---
> 
> Better but it is still possible to create too many VF's that the response
> won't fit.

Correct, no argues here.
It allowed me to see around ~200 VFs instead of ~70, a step in the right
direction.

