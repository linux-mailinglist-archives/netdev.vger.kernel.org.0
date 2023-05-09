Return-Path: <netdev+bounces-1285-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC806FD2ED
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 01:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E0F82812BA
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62331548F;
	Tue,  9 May 2023 23:02:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAF2F9DE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 23:02:53 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CE81BFE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 16:02:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqcwLvFC4OPxVPOnsG0PxFe+FzfIUJnWeT680L5Y+yd+qWyOTGOcgkTUSOWDXdr+k01cTUe49MPP8Uwy2nts+wmg0w/VZDHpAqD7dziMbGdQ7dThtoWklacOGsK5DI6QfIT4H8ou99wpzEN71Y2yZ7UbcZgxJduOJ2FbyZBYEzBmFm/pzsJSHQxTIgbCd03L8FURAOeWg413M/HN2JcyCui8EuUEOqpFt6dq9LWJNF46YU7OCzojePOWvglTeq7ccpsUFrX/Cv/w7tqkoxE9dBt0v6LTeHjLy3SVQfmvyUf72H9X/FsDrO1NGW7n4ujGQDJXsJvwfiAmpVo+bQvCig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fd1rMb9EVyePKyTILQL/UpZDOLu0zZwnf0UvPC2qsAk=;
 b=NlXzbjVoiCMV/eavMdGacX7UaKJzr4txmMkDG5lQcnpeUKJGWuGf9h3zJ+3Y5BNIEGPRaH0NbheXWbMV+D9WaVRwMHIIbNve6Su4wsizcx9yqFl211jPWyGu0udz8ZLcdwtERyjPBXhdo4zVJE8Q0/AAatDrkAlpEAkrboh9ZeefvQpcmeBfJf0rAw/q7w54JIeP/iiG4cbY7Lx3TtT/JH80vZq79LWAVXqK6R5+bfTow/rEynQRFIXjuf+pZBB4NnYN/qShIXUch5hOKLnDwL7SkWwK/kwe7vVMyGuyayEIMhAOk43g6TwiL/TPJvixZcNFnOH+rpgZHZy/+17hqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fd1rMb9EVyePKyTILQL/UpZDOLu0zZwnf0UvPC2qsAk=;
 b=tZR0SQHiXi5vaeOeAG3lPG3gsJhFhcCqMdcn89zqQ74s3uZnLLJKpGyJcgT4Bb9nfKLPuwAPCdoXlse1hgQOhz03cSwkzgRpmqNusrVNAUsLcLr1iu6iy8ObzaNDvcHBApa7TZXiuVtkpuh4h9yBLV4dzziPCwdadisGYOt0bDxYVi4OUmLFfemFvHm3PN2UI0vuBkt8/73EJbUpuNDJtqSY4/zn/Sly+4XG0WpxVoqenhUOCWIRDKIhLi9n9vON8i1FUVB9qIcYkWQ/QMDvAZv3X2USMsHsGe+zKVOrtVlGbdIRTjeAcUqw47GqFvdBJnLXEdJ2soogNsJC5yjDNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by DM4PR12MB6134.namprd12.prod.outlook.com (2603:10b6:8:ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Tue, 9 May
 2023 23:02:47 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::61c3:1cd:90b6:c307]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::61c3:1cd:90b6:c307%4]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 23:02:47 +0000
Message-ID: <5e603985-6ef1-879d-cc52-a093a1366795@nvidia.com>
Date: Wed, 10 May 2023 02:02:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 07/17] net/tls: handle MSG_EOR for tls_sw TX flow
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
 Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Chuck Lever <chuck.lever@oracle.com>, kernel-tls-handshake@lists.linux.dev,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230419065714.52076-1-hare@suse.de>
 <20230419065714.52076-8-hare@suse.de>
 <fb934ee3-879f-f33f-efeb-945ccc9dc9a3@nvidia.com>
 <f3fe3fc4-b885-d981-9685-4b1a377db639@suse.de>
 <20230509081308.4a531d4e@kernel.org>
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20230509081308.4a531d4e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0086.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::19) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|DM4PR12MB6134:EE_
X-MS-Office365-Filtering-Correlation-Id: f36b7875-9189-4f6d-195a-08db50e18197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aQEoMFbUM/3wLn11Eguvpo5nb+GqbkCl+cG+w7wiK4hIlvLymAFOkU2phUADyg7Tp50Icud7Qmnk9tqj735hs3LKAWuayQ9+mMfYeonV84/XN/EJZp2OcIe/oWU50CRveDYB6neI3oovf4YPvYkeZNXCjhdXoZHPB8NVuCc0HeoTVlJ+xAqucC/UmzgoVeOpwgX82vpYYy9pTsifQn0Bv1dLmaCDC145qsD9/FkLAcR+yydXn44hcpiwovHP0PIzx0NjxWvBzhDpW/WI8plOReOAB9QdufCDCqhZUa1imOHJL1VOGhKp9wVNLrxrA+n6ft7AnqNmo/SwL2CdB3X3610XAXdVW33UMlzQgSYXtfzqSHGUK+NMBghae6nNkENGUUe8T42RUmb3O3PJ1Whm/4M7zQZI96/2CYeV23OqUpAVJ7piZmjiYbWpPFc58FXth7IiFDFLTG9N7BuEYYiqO3fU/j+uroIRzOrN7lfUETmJiTSbJ1H4ctZLD1qS269Np7ybb2rxK9ksHBt+tcc3He4Bw1qLBQGmDkTkRBJcRtlps+qH0lvR0sciG2vwFJz/yyaWQjVXRnZt0b97RRAte/FBbhudous8GXxp/ayyP2I8V5u3WLO089ULlBG1Wiz6Hc99Ly8RkNfW9Lt0L+nNXA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(6666004)(2616005)(2906002)(4744005)(478600001)(186003)(36756003)(6486002)(26005)(41300700001)(6512007)(6506007)(53546011)(316002)(38100700002)(110136005)(54906003)(31686004)(4326008)(66556008)(66946007)(66476007)(31696002)(5660300002)(8676002)(86362001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2ZtTFMrUXJiK0NFN01sRUVxcTlTcEVEOURGWkRPajFJbVFoSmJTck1vL2NY?=
 =?utf-8?B?bHRDL0oxRjVyNTJaWVUxVEdCcEhRRjNmR2QyUjlYNWxPeGRiTVFuN0hjZXdI?=
 =?utf-8?B?NS9rTDc0TDhXdzNBdWw1MjhBZFdZYStVM3ZRQnNtdkRqdjVwMllTMTRsV0pO?=
 =?utf-8?B?NXNPTXZBNEhlUWJ4OTdWK2tmUG04OFdRd0JZV0VwQVoxRWJpZVMvLzJVZUg0?=
 =?utf-8?B?dkM0WTFFcThJSHVWUCtKZTdocmZ6cGwzU3kweldJeDhxcWxLUmxwTmI3dHEr?=
 =?utf-8?B?Sml5T3NxOHYrZW1BKzZuVzdTaXVlQ2ViR2hCWUNBWDltMVlxeDJ0NDJ6cFU4?=
 =?utf-8?B?OXVtMWtQVVpFa1gvMmdBRThlamdPbjFkUEVxeDAyTkwzZHNETjNDWm5XOUdJ?=
 =?utf-8?B?OS9BbzNoeVJJM0dmZDc0eXp1WWlIM2kwYisvbmt4cC9rbC9IeGZydWg0WUdV?=
 =?utf-8?B?Q2F3b3lQMGpMbDJyblNoallvMWNURTRRa2h4UUhEa2FGQ3YwZmQ4aXFTZkpq?=
 =?utf-8?B?ZGlNdDZkc2JneVVnaXpDczNPOFkraGtwbVFIRlFCTlplTGNXQVJKQlZCMzFP?=
 =?utf-8?B?dUU1ajRMZ05lcTdoVEwrWTRvazQvNXF5Z1g5aGJtdHFSTUIzQVFOZERvWjdu?=
 =?utf-8?B?N0FWS2J0cjIzLzhYQ1VKNFF5VldEOE1PeDVOMllYR0pKNGxLZ0V5YU43YXc3?=
 =?utf-8?B?WnhHU2Z6MEZ1cmJLU0JJSnZtZUtlZUtGbjA4cWl0aUZ0MDN0TFFuKzNKbHIv?=
 =?utf-8?B?cENEUGVSUll4SWZxUHlnNmM5Z0hSM0k2QlZsMDA1QkxTVnV0ZW43a1ZTcEN6?=
 =?utf-8?B?OFJWR1UzSG5scFluSDFHKzRRaVpPWkdTMSt6L3g5cjR2SmJnWHFuWHBFdDFq?=
 =?utf-8?B?Nk1vWmFrcUZwbEs0b1RkaEgrSDJ4Q3NuRm5OVng1d0p1Q1pJZUZwKzV3MVhN?=
 =?utf-8?B?clhlK1M0Nzd3VkhnT2ZwRGk1dlFJd3NkMXFia09lYmxua3ZOOWlQNlR0Vmlk?=
 =?utf-8?B?d3duTVZEVFNlVHBFUUxGMjZpTFpYbmZwQXJFMkhUUzdCVnY0YWpaVnMxZHdk?=
 =?utf-8?B?SUNYZnNJc3FSbjdIbHoyNDgrRCt3MW12dnhuUmtBdjBtZFY4WHZkY2trS2cv?=
 =?utf-8?B?V2NLc3dFUElnVUZ3TDF4MWtOUTl6VmZDRlQzL1NBTXBVcnUyK0ZGV3FwWVg3?=
 =?utf-8?B?aWlYd3NlWi9HR3RNYWwvQWg4N3VZR2YwclZTR1NQYitZbDY2b09IZ2gxRWhN?=
 =?utf-8?B?TWVlSU1PN3owcDcvSk9ld0RLczRONUtKMUVRMHBnaFFVNG9CWHVZaWZYTGkz?=
 =?utf-8?B?VlE3cVh0bHpqNnVVRmx0Nm1IcHZzZU0rV2VvOVhVOWpacVozSkVzQWZST0Vq?=
 =?utf-8?B?M21EZFhIQ20xOVl0QS9WVFlTakM4QVkzRE8xWTZJckZtU0ZzcXI0b1VhSzE3?=
 =?utf-8?B?RHVTbElVc1FiR09sT0tNREluM2wxaVptWVhnYkdSK3pTS2twS0ZNSzVVdUll?=
 =?utf-8?B?MExvcW0xdHdvTzViUUs0Uk8xdGFJZFRkSlNHT2YrSFVWRkhYZzQ2d3hSSjNy?=
 =?utf-8?B?ZldzTGZwYnBPOXpkVXJEQmlNdWJXUDdFNE9wR1pZTVNJamlKdDVvL0NsOUNq?=
 =?utf-8?B?dkd1QVRueXRJdzZWT01rZkd5ajVMRVRPUFJmUDc1ODBtVUFDNGN2clZ5bVpK?=
 =?utf-8?B?U3hqM200ZmpPdEprUTYzZ2VCV0YzZGQxa3drMk9sUkEyYTNJOXZ6cU83d0or?=
 =?utf-8?B?Z1NwOVplMVlrblltdXRmZFIxanhsT29PaUc2NTViNWVibkgrbHlGaUhRZFRu?=
 =?utf-8?B?NmZpRmxVUEF2ZlVKZ2hEWGppNVBxMDBORUtDTWlDTVZDc3NIdDAxaVB3dktk?=
 =?utf-8?B?Ni9WcGNIRmw0djNTWjk4Q3FxVUk0R0FIZU1ZVlllQzdaMXhjdDcwN0R3T3Vw?=
 =?utf-8?B?MjJETFV4NmMzR1JVbFExSy9MRWs1RkVJQXFaN3pXenorMjNPNTNMWWlBQU00?=
 =?utf-8?B?dUhZQzZSZ0lFa0R2REJsVUZMMVBWbUdzRG1SMUlPRTU4V0JBR3hDeGVJOFQ5?=
 =?utf-8?B?RWRRT3RuN2txU3I3ZzhmZk9PV0dyZHZuNkFQQnhUQ2FEQ2Ixak5BNXZvRTRu?=
 =?utf-8?B?MVVuMzQxVU1aYUllTE1yNXphaEVocnc4NGE0cTRiczdvVFBGUnpmaHRsdzZ0?=
 =?utf-8?B?NkE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36b7875-9189-4f6d-195a-08db50e18197
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 23:02:47.7466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fIjW3w8BNc5aEjAhSpVE2kkudv38YmCFQsosgtHfYgO5RI0yQOQTc0XzSg7VuAFiWZsB4Ch3p0Jt4ANnHvvUkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6134
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 09/05/2023 18:13, Jakub Kicinski wrote:
> On Tue, 9 May 2023 16:18:30 +0200 Hannes Reinecke wrote:
>>> This seems like a nice optimization but seems not mandatory for the
>>> acceptance of TLS support in nvme/tcp.
>>>
>>> I wonder if this can go to net/tls as a standalone patch ?
>>
>> Errm. Without this NVMe/TLS will not work as sendmsg/sendpage will
>> bail out.
>> So yes, surely it can be applied as a standalone patch, but that
>> only makes sense if it will be applied _before_ the rest of the
>> nvme/tls patches.

how come it will bail out only for NVMe/TLS and not for Other_user/TLS ?

>>
>> Not sure how best to coordinate this.
> 
> You should apply it on a branch based on -rc1 and then both us and
> $appropriate-nvme-maintainer can pull it in.

