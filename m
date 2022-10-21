Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D3E6079A6
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiJUOdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJUOdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:33:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8547327E2D4;
        Fri, 21 Oct 2022 07:33:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1Rm5NsWokqLuoXt57q7XfOBjshEk6qfp3k8/MBhkEGV51SZjbHZ+nY9Zvm7eIDd3DOyllharJKgbjtoSZDuHjxjMw+3vYm7+LTD7pC2OVR88pk8+V9sYYwwi2SY5AYCz03BkB/YYowpr6h7p2ooO/tqoRD39J9Rr1DkpKzcaIDXML0ReozYeFUkG+vvLOituC5LBWhnfUMastyTzcAhuF7o9e37RjSXdoOv+MGBns87Hh2lmOxkucQ1gDE+rb++Df3Lh2oy9SwnRwDY8RhG3+L3bmE+KCEYGnscewzuybVMevqJqCHLtgGqbjcfr+2UcOSirh9RAnF3E1kcRVHmGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqjOJCoq3I/R0tyEULIRNmbOD+4BOsBc4Mm6h3zPncA=;
 b=YyePI5Ww6PSHIpTgFK96xCCy1ihKhoiQyiNmQRn7PoYvdAOxVlu8WcAMXgyBCxoPiC/dpnJAeH0Qkp/pGJvB6Wwn0xqsB0pHffSd+Pbvlm2yVUSA9U2XTI2HEp8VS3am5+pIYtn2KgnVexsfXJkO9mGnHLImuPNpwYv4BmyC8XwPgasoIMzUpHrjDpUIH0cLqYSaWlnNNxdmT0i7pnZ0WApK3v/k9vtwAWdq5faQ12GYgj2zCvB+whyGuxf287dW5cyYW3N2f52wvonBA2FGqdg1FvBPT8rlY7f+ZCW3NoL7AIh8FIhpMx+Z21GvoJo+qag/Mi7b70qOEYkGtMKXgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL0PR01MB4434.prod.exchangelabs.com (2603:10b6:208:81::17) by
 CO1PR01MB7388.prod.exchangelabs.com (2603:10b6:303:15b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.26; Fri, 21 Oct 2022 14:33:42 +0000
Received: from BL0PR01MB4434.prod.exchangelabs.com
 ([fe80::28a9:57b1:9a6:c5d4]) by BL0PR01MB4434.prod.exchangelabs.com
 ([fe80::28a9:57b1:9a6:c5d4%7]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 14:33:42 +0000
Message-ID: <9af99f89-8f1d-b83f-6e77-4e411223f412@talpey.com>
Date:   Fri, 21 Oct 2022 10:33:44 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
To:     Long Li <longli@microsoft.com>,
        Bernard Metzler <BMT@zurich.ibm.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
 <1666218252-32191-13-git-send-email-longli@linuxonhyperv.com>
 <SA0PR15MB39198F9538CBDC8A88D63DF0992A9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0081.namprd03.prod.outlook.com
 (2603:10b6:208:329::26) To BL0PR01MB4434.prod.exchangelabs.com
 (2603:10b6:208:81::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR01MB4434:EE_|CO1PR01MB7388:EE_
X-MS-Office365-Filtering-Correlation-Id: 40c4e225-909b-45ab-c851-08dab3714072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZQbFZEButsUep7zGRMdmlHT8TgODxdUoMDjIIeHNeWw7qUNbRqXC4eml3lzV8S4x5feBaz2jU8Y8VkpEp6CMtwrLjWSOog3+dOlOqJmzjXLXJ7w3cXmj88Ubp7a0mTCE8DnrLOW5UR15Uasu9bg4OlPZ1DIfLWAfgrHmFAIps4s76N3q9gPR1ecpgsZJhf29dUN2hD6JLBI7HO2N39No6cLSGhcXaPdF6pyzU7M6cmYzQyMNdoaZIUEvU8xXX9sFQ+yY8O1g6flgKrspK4pgUsuajrZleJCj9yrUD+rRehnj6dPf3jPmPWLvKlc0Q1AG9Xyg2EmEJ+jbVN7TKPsUUSqu6kLRVjgBp3RVkP964ffbPBKg4Ntq2mL0uFII+MGhBRXr6UFfZcKvqnABzNxe5wAQfnnaJZuwbBBx1rmrZZK4/u9I4Crk9GinQVcg7HfY6vssLWTheY0kg3fJRoyvf5BV9Iz9FQE+eQz4nMrYEiKIXzP7eG4x8ay4vfue65lm/mnx5EbOnr2LCUCKn3G+WoswXPVPL1t5AYOQgf2CRCsGtcg25yFSr4zaV1pGkd3TWo648sC2wgJvnoj9j5JljdneVeQPSRvygultkGXZmEwou2WVh8+DkjLt5zEp3rbD7CpyRZrTx5le8qVQZsVmnQJl5+lKIzj5zk7TtcHHjRBNiUQfKh32WzlqyZtgl630rqSLYqPwqBzkenv/0781+Ud81e/sXE1i9ZyiXEYOH54eLI4w+QzhYzWSIz2Pk84t0IGzvtWRO5JsgDiFbU5ZaA5peGZI7Oa78DPwOE4mc5EItf5SBxDKXi6xu2HLIBBk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR01MB4434.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39830400003)(136003)(346002)(47530400004)(451199015)(8676002)(8936002)(54906003)(26005)(2616005)(110136005)(4744005)(66946007)(4326008)(66476007)(66556008)(36756003)(86362001)(6512007)(31696002)(52230400001)(6506007)(41300700001)(52116002)(5660300002)(7416002)(316002)(53546011)(38100700002)(31686004)(38350700002)(186003)(2906002)(6486002)(478600001)(45080400002)(921005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzNpR1RQUTlLcHFueUFRN1dkRUVvTU1RcEY5WlpaL3k4N0tzY1B3SGJkQmg2?=
 =?utf-8?B?Ulg2OUFCMmYvZlRTczVwRE0rUVVhR2NLajh5bnY3MGpCNjNnNEpmSFljV201?=
 =?utf-8?B?NC9wdURPMkpVb3oydVpQc0t3aFFGdHlFTWtQUThYQlArejNmeTBvYUwvSVlP?=
 =?utf-8?B?OXI0RGJ3UVpaZThjeXFjZ0hvYXVVUDZSR2oyY2ROSVhTUHdRWTBVaXR3bHY4?=
 =?utf-8?B?cytwMDIyUnhBbGNwL3pwUFNXTERsRzg4c3Q2NjJKYzNIMTdpNlZFQm4rUTBY?=
 =?utf-8?B?bTMxWm5qREVlSGhoMm1ERkJBWFdmZGxhbXRud3U1TWROUVM4VUtxSU5tdUNK?=
 =?utf-8?B?eWthQlRMZU5mT0NOZWxwcGh3QlhOeDdON2p2S0xFTGFNZGlyTHVvWWJBTWN5?=
 =?utf-8?B?RXI4Q0t0V3piWGR4bEI5S1BNQUhUaUpWUFBINmVmSWZEandmWStMcDArUlhM?=
 =?utf-8?B?TXhOYjA0QmZRUW90cDBpSWU4amNGNFlveDJZVElTUC83ckVQclVzdVFGUmkx?=
 =?utf-8?B?YTJqdGxnczNZMWwxK0lVaTVYTDRjK0JCazFOS2M0UXlzS2R6RFBJUTZ5akti?=
 =?utf-8?B?YmswMklhdjRvWWg0K2h0aUo4M1doVmkyOTNoZmRIelV1d0lzTEk5T21Fd2ha?=
 =?utf-8?B?a2hZcGNTT1NzZXpXVllwcXZieVk2ODZxNnlRWktpL1Y5TVFobHpoN0J5R21Z?=
 =?utf-8?B?ZDdNdk1LNUFPM0FtNS9BWlpLTkJNd2Z2R2xIMmpVS29QYXBUS2V1Rk1EaHJW?=
 =?utf-8?B?WkRNWm1yOGFtenZGUlZ3M3VOQlNBYmtDWTlwU29DakhNdjY4WkxrUXc3WHJI?=
 =?utf-8?B?WGxSSllnR0FuVjJTck9wYkxqZy9FOEVMVDcrV05aWGsrZXpYaCtIZExKQWhr?=
 =?utf-8?B?S2VrRVdJVGo1bE81TGUyTFdCT0tXZHkyNmxjdVJ6OXpZNDFRczFiamY3eVJS?=
 =?utf-8?B?Y3plMDY1cGNwLzE1L1lyODJrY3ZYUGcrVk1PN0VvM3d6REtjNGZ6NUltVUYz?=
 =?utf-8?B?bXEwNmZWdERzcnhQam5ZVUg5aFRDR08yTnJ2b0gwbTVwQ0R2bDBPQ3RBQndO?=
 =?utf-8?B?d2tjQXFqWnFsUjlHbFVJUXo1b0FiMEhHUTlNdzRGeTllbXhLTXM0MFlQNktM?=
 =?utf-8?B?dzhtTHZxS1FKTGxVWG5GNzZzcU0zMEhoYXhWaWpHWkd3TXpabHlKQzV6YTMr?=
 =?utf-8?B?aTRUTFJzcDcxK21FL2Q0TjljYWVWQXcrUHhmVGR4emFBcldXOU9uR3lKTXRD?=
 =?utf-8?B?R2d0d2l2ZFBVZUV0VWhiOUs4eHhObGx3Szh5ZHJtUUFmREx3Z3YxK1JTTE1i?=
 =?utf-8?B?dzgzVzIrNU9EZmlDR0tGdU9mMEkvZkVNY1JMOEZ5a0xPcHU0eXlZN054eHZz?=
 =?utf-8?B?Wm9BcS91K1kxcC9JUWlPZW5iSVZXL0RuV3IzcXN6Y0szWitjWDA3aXkwOEQz?=
 =?utf-8?B?a2VnT2ViQWZiaFNLQjZ3cnBNOGZSVzk2amVodGJXQlRNamFXWDBoSHRwWTNr?=
 =?utf-8?B?MUxWSmxUcURwZm9xY29Ealc3NFI2Lzc4RkNoeFQvb3ZHRnNOZEV6MytDQ3lq?=
 =?utf-8?B?VGhyZXd5ZHFnM3gxOUoyaW5LbEc5aTJ6eVZvSzk5RllKZ1VvVzdCR3ZlOWs5?=
 =?utf-8?B?WkluYktBN2l6R0ZiWG52Uys0WUtNYXV4aFUrOTl1ekJUaHJIdENMZWtoNS9Q?=
 =?utf-8?B?Zkc1dS8xOFZCWWN2TEtlOXdHN3ljWkdaNUhIaUl1a1B6Szc3RzFiQitKTStk?=
 =?utf-8?B?bXRzbkZNOEpGdkFFTXBjcWlsWHQzem1WYm5aQURBd3Znd0t4bTMwNjdWNlVJ?=
 =?utf-8?B?UU5zeHY5SlJvUzl0YUdrVGkySUtMSTJlbmw4Z2g1Wnd6dmVPNzlWWXQ2NUVJ?=
 =?utf-8?B?aXUxTkdvZEVKSG9CWi96amZCc3JKUXU1amZmTzF2TE1vaThTZi9IekZDQVM3?=
 =?utf-8?B?K2ZzOGg0b0JWVTdpcy9xak5TMGd3TkszRjJ3cHZSREdXWUlRTE1WMG1qQU5h?=
 =?utf-8?B?WWhTdUtVS0w2L0hKVEs0NEpiNjV4Z0hFQU5rTE9oa0hxVTFuclp5WHI5Zi9V?=
 =?utf-8?B?UVVROHR5TW02ZkppTTV5UDJ3U3Y1R1JZblQzOEVYVDdraFZlVFAyT2p4NkFy?=
 =?utf-8?Q?mY9QlrP1tOxsg4i9JIjnYVn/d?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c4e225-909b-45ab-c851-08dab3714072
X-MS-Exchange-CrossTenant-AuthSource: BL0PR01MB4434.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 14:33:42.2161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z64pgyWXcH857rt3QVkv/iWg8BhJL39Xe6alPgyZCkF9EcLf5rOibtg8kbv9hSb3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB7388
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/2022 4:42 PM, Long Li wrote:
>> [Bernard wrote...]

>>> +	props->max_qp_wr = MAX_SEND_BUFFERS_PER_QUEUE;
>>> +
>>> +	/*
>>> +	 * max_cqe could be potentially much bigger.
>>> +	 * As this version of driver only support RAW QP, set it to the same
>>> +	 * value as max_qp_wr
>>> +	 */
>>> +	props->max_cqe = MAX_SEND_BUFFERS_PER_QUEUE;
>>> +
>>> +	props->max_mr_size = MANA_IB_MAX_MR_SIZE;
>>> +	props->max_mr = INT_MAX;
>>
>> How the 24 bit wide MR keys can handle INT_MAX unique
>> MR's?
> 
> Not sure if I understand this correctly, lkey and rkey are u32 in ib_mr.

The upper 8 bits of an ib_mr remote token are reserved for use as a
rotating key, this allows a consumer to more safely reuse an ib_mr
without having to overallocate large region pools.

Tom.
