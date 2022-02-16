Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0904C4B90BE
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbiBPSw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:52:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbiBPSw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:52:58 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD8215FCA9;
        Wed, 16 Feb 2022 10:52:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vl864MLFNjQ4wEQcLnNl1IfDDwUyewufAOWdsp02o90i8qLLkvFRAPLr7c1f5TtdD0YUMSsIotYg8a7QbGqTz6SYUcS9jy1A1GA/ahD0OuM1yprzO91VjdTy/EJkb3B1X8C1l79B714k+1YuQyDfUVkMOuqFjg29ZrSTIseqTS6QzpZE08uqbVKv0RXm2w5fNpicMXZSjyZoCB7MWCpdedRngexMS95yML4+o4aqHnLrC7kbpV1uk7MCwThxAK0eKAWu99mmsQ4QWFJSM/UzKToOWR/QaY5M2T2CRak8mR1t5f4Ap6amKKZD4uNCpe8Z9oyAkTUGFiZUN14QcmOdCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gw/weOJ4v4CNvyLVdfISiWt2suXJ4Xktf6ltfC0gdZs=;
 b=X0e7FPT3s/HZMDfGYsnAZEOka4lgbfFg+ewi99kE8vkMSwJ8dfO72+4EBbcPlDRDgY/bfIuuJR+LKToLUqRqeP9uGrAi5fkWZ5g810Qf7aK8QWukAbuyhP9FL7lhKSs5f0XxptV155Hym/x2XhO6BY1A2Am2wVqG31NVDf4hLkWgGbSTzEfgmQ7TsSkqxQ5IGYkYXc0R7GEdoTWQmXhVGQ41qlwA8VfYwMqmBmXX8v4Y4hV2SCGgktNCVBkf7IfLsVKc3z/3cGjsdr9vOXEuSQ/QWu0jcAJravtilJy5+GKWq46pL142LQ2RFGBugdymzqYrLq2XBnSs2cDidGqzkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gw/weOJ4v4CNvyLVdfISiWt2suXJ4Xktf6ltfC0gdZs=;
 b=qJkiwNN4VRalBOrg3kP85mJSeg9qXgM17JI0IfVwAHlL+N9lONhH5BhJdYYSVk9otJ4k0sMRH42MnYE9E7WPFq+DfOc8poRpjl7UnVCFaoZpK14YSqyu/Xf1Qp2QvUReEOMfa0gqBjjZEUDKYknozEAmPhBAbkZd291u8VU6oGzHxiT3Ts1GGYAuro9SjOUI/ZOOri7lXjl4lJ5IRhc48wIJbaFwTef+IVm7RnUvwnLrL/kKDbUgdXSijHtqMcs/2Y/6OM7q8GzXm7slWgvOV5T26yV4u/2s0BefqAdT1nqWvObeqAdTkKhgOi5JKvuH+9ebrdrGQUA3uVzqWG7aFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by LV2PR12MB6015.namprd12.prod.outlook.com (2603:10b6:408:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 18:52:41 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::fc78:7d1a:5b16:4b27]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::fc78:7d1a:5b16:4b27%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 18:52:41 +0000
Message-ID: <3abe91c7-6558-4f1d-5e6b-e74e71c6c23b@nvidia.com>
Date:   Wed, 16 Feb 2022 20:52:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 01/14] netfilter: conntrack: mark UDP zero
 checksum as CHECKSUM_UNNECESSARY
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, kevmitch@arista.com
References: <20220209133616.165104-1-pablo@netfilter.org>
 <20220209133616.165104-2-pablo@netfilter.org>
 <7eed8111-42d7-63e1-d289-346a596fc933@nvidia.com>
 <20220216152842.GA20500@breakpoint.cc> <Yg0gmE8y4mweUNj1@salvia>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <Yg0gmE8y4mweUNj1@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0120.eurprd06.prod.outlook.com
 (2603:10a6:20b:465::18) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3aea4314-9e5a-48e1-94b4-08d9f17d82a1
X-MS-TrafficTypeDiagnostic: LV2PR12MB6015:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB6015AD4BDEC4E8D7DC5B4264C2359@LV2PR12MB6015.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFJpre0UD4cp9T2H3CKzMQFQ1JekSbz3TKrcoHrnsVoRTDBh63+shxdX/5ApCBYFtnXU6dkhcXgvXvhqxiwTgCp5K4XWpoaG527OUnVswp4LP3So5cBGy3yeP/wjpxcYZBYta8d/AShiIChFeUQS2Kvza4M3Wd/xm1Ig1gWBLF//GOw73lOMo1PCBSBFvqc/L3C5wZNLzEnhUNRXauwWtAav4oOiwDB6CMLVQL4bXwWNkfO/DrCE5n0GIYiuNBFOgzFDHE19bh5giZzEscz5Pxh2E+lawUAO2smxrxNMadLrpqe9AdH5INMbW+G0h6byeROK3pBrdA2NvN7/0yKD7EtLWKf/vcgOat/dj2wT7f3JEbLy//e33E9IN6wD0kZlijTvTjZJ/nzOzc4TgGJ6q1DQCJ93GUFjdjK/S3E01vodpnZtl8ED6wWu8aTJZLGTKaVAWEYZboJ1fZMh/B7MTQ5b/mIFVQT/t1K0J3vwYcg3AlUwXQ37QVli/lv3j60BiCp0jMFkuQszjkHDuQaeo0wMztxT9iWlGBjgiBfE2IMhSxI3qNCCvKtzSCYosqcwD/UcPZRNZi027OTT5xOw390sFA5nYUs9JCeXI+Jen3Nt5ZfWMkrfrjc6ZUJQQZZx8reTkAD/1yDOLzZ9foNaUvjAmP+vBM6Isb5UC1GFd4WdYndcElLfJLYMnq4j1ZSupVE5ENXFskLmIj8Z9gOk8orfHnn8nR07yW3uXmRXvj8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(36756003)(6486002)(66556008)(66946007)(66476007)(8676002)(86362001)(38100700002)(4326008)(5660300002)(31696002)(83380400001)(31686004)(2616005)(186003)(26005)(508600001)(6666004)(6512007)(6506007)(110136005)(316002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OSsrYkZpY3NMNmE1a25Gam45NVFleGxQSkZOZlNIK3BwY1VaWUc0UXhkWjhm?=
 =?utf-8?B?eU5DMG9JVEx0eGpHT3V2OE0zQWRPQ2xGa1RWODJQTmRuRFlXdlJtRExZQ09O?=
 =?utf-8?B?YithSWFjUGdRdjkweDI1ajQrbEhxYkdFa1k2OStqRkVkYVhLUnEvVURPQ1g5?=
 =?utf-8?B?Y0pDOG1taDBDWUM2Nk5NQXl4QTc3VDhIUis2Tm4xaHN5cnQvUDUwRENnelF4?=
 =?utf-8?B?UTVNUEZ0L1EyQ2hBUUJ0YjFBeXNKU0ZVdUlNV1JlRjErOUErWHZsWEJENG1B?=
 =?utf-8?B?TFU5ZlNua3Q1TkxoS1FxQkpGcm1JVGcyUWFHVmlQbnE5dTdUSmFheWJacnNC?=
 =?utf-8?B?aTY0M1pINFdycTRxR0duaTZzQ005dDZhOFdmZERSc1R3OElxMVNEM1FseVFY?=
 =?utf-8?B?bEI1Rk5reDVWQzhJVmNzaVNPUll6YmVtU2NaL0pGNldvWEQ4Y3ZaTGhKRXBa?=
 =?utf-8?B?RE15dFJkZHJaSnI1REJrdHpLUm4rWXlsZ3E5VFNXSUNLa0dwdWpTRHpuTlVE?=
 =?utf-8?B?RGxJckhGMGJaWGJVS3VzVW9xZExINWlQTEZYY1VTYUNodWpqREZCNEcxWlA2?=
 =?utf-8?B?VjBEWVY4a0w4UFBaYzBhUk9WdjBXTW45NmRzMXB0TGNwNTNGZ2Y2NVpwYkdO?=
 =?utf-8?B?OGR0TlZZTlMzRmd4VGJlOGVzOVhuNXZicllSaU1RTmUwTjZaVDNwek15V2dI?=
 =?utf-8?B?SEFCK04yU2hVVWFXZjVacFlYaVFod2svUlQ2eFgzZ0lab2JyclhlZzVvQTIz?=
 =?utf-8?B?Ui93UXJmUittMGVTR3ROTzJwRXhmY2g2ZHJMcWV6OWcxVEdMNTczeVJ4bk9L?=
 =?utf-8?B?dXJ0c2llUU9HSE04eWRQZktEd1AzMTI1UzBnbVhuMGhuODdwaFlVNEV0NDdR?=
 =?utf-8?B?b2NMY0tRZUxSR2NNZmJzdjc0ZWV1K2V2S0syNExRaU5ac2VCK2lJY0FGcWhq?=
 =?utf-8?B?Zy9BZlhBV05sdkRZbkQ3RXo4MXdqVGJpcERnak51SXVjekZ3V1JNSWdYb0Iw?=
 =?utf-8?B?WkZiUGpWcDdWWmhRWnhydWlGUVNvM3NFYWJIVDRTRmNsWGtVd1ZDZTY1UUdY?=
 =?utf-8?B?TCt5TVJmbXJJNXV3b05xOXZRay9QdjNQNDlTV3hGUmVibG1GN2V6M00zenBj?=
 =?utf-8?B?UGZidWJTckFoK3BuM1NwNXJQbHhGSkErYWs3UURpMlNtanVnN0xYemVUd095?=
 =?utf-8?B?dEd6ZE1kMXlxUkpZUFRDTEUvTmVIRlgxazNIcGpORnhiakxzUkJudVIwNHlE?=
 =?utf-8?B?eUl4ZVlpSzJUZ0tUaStOUWp4MzFuZ3o1aVNEeTlYck1LRE1oZjRjaTk3S3pT?=
 =?utf-8?B?NDVKMUVteWRsWHJmemdOU01GdlpTUWIyMTBoa0l5Q1p0TXdUSlZOOFJyWDRa?=
 =?utf-8?B?cFBHbm1ENHZDRGpDZStwUi9UcmQxTFoyUFdRZy9HbC8vRkR3dzZCeGJHQXNZ?=
 =?utf-8?B?TzJ5dHlSYU9Kc3VobThUT1BsdTd2UnRNV1lZNnp6dmp6dGkxWjFURnV1SWlZ?=
 =?utf-8?B?dzR1ZG52dVZ5MTcwaDVyRWh6bHN3cmdtSk00MmtRS2p3c0lOU21sTkRSc2l4?=
 =?utf-8?B?Z0xVNzJEVm5EWjlwWXUyRjRQOTkvbjV2ZUZQTytla2hqekRDcCtQcW1sUk5v?=
 =?utf-8?B?d0ZvZlZkY3h3TmdQSDZSZ0NNV2pobEVHeHU1Q2QvSDNRSjFnK3ZwdHJtd2Nh?=
 =?utf-8?B?dXpLcXpkL2VYVk55UDl5M1JTLzdSc0kycWtJcU9CVTArL0FERW5QekdNbnRa?=
 =?utf-8?B?U0gwdEtXRjJYakhRdmFzMmxaSGxNM0tjc1NRbEZGcXJyNmNjaDJjSXBRNjJy?=
 =?utf-8?B?UE9ROTl2eWoyNWVkSmpiM2V6aE91U0o2QlF0WU9SR1lnVEJSbXRFcW4zSEpz?=
 =?utf-8?B?c1F4RDhTRTJVaGtMQzA5REh1Qnh3U0lIWTY0M3VwQmR2TWZlTzlqZ2VaNTUr?=
 =?utf-8?B?VzcwVkcrYWJzcFBZNE1FSXZveEdMNkQ4MHoveExTeTFpV3pVSURnaHlLTmdN?=
 =?utf-8?B?UlFIZmY2ZHFMbGF3WmVCQnpEbkJjeVk2TmlTVWZTQzhPUGp0RVRueVBRb2Q1?=
 =?utf-8?B?V0pNVVRRUFJtR2NhcjVBSVErMDRmS0h0TUdTQlhKSU54VVNiR0NVYmd0dDgx?=
 =?utf-8?Q?qWm8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aea4314-9e5a-48e1-94b4-08d9f17d82a1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 18:52:41.7749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HM4dk863/57XcyZpddDWmPAHE8q3uLZyiubw6aQakTph6YCsNkiX4qM/iZrXHMnC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6015
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2022 18:04, Pablo Neira Ayuso wrote:
> On Wed, Feb 16, 2022 at 04:28:42PM +0100, Florian Westphal wrote:
>> Gal Pressman <gal@nvidia.com> wrote:
>>
>> [ CC patch author ]
>>
>>>> The udp_error function verifies the checksum of incoming UDP packets if
>>>> one is set. This has the desirable side effect of setting skb->ip_summed
>>>> to CHECKSUM_COMPLETE, signalling that this verification need not be
>>>> repeated further up the stack.
>>>>
>>>> Conversely, when the UDP checksum is empty, which is perfectly legal (at least
>>>> inside IPv4), udp_error previously left no trace that the checksum had been
>>>> deemed acceptable.
>>>>
>>>> This was a problem in particular for nf_reject_ipv4, which verifies the
>>>> checksum in nf_send_unreach() before sending ICMP_DEST_UNREACH. It makes
>>>> no accommodation for zero UDP checksums unless they are already marked
>>>> as CHECKSUM_UNNECESSARY.
>>>>
>>>> This commit ensures packets with empty UDP checksum are marked as
>>>> CHECKSUM_UNNECESSARY, which is explicitly recommended in skbuff.h.
>>>>
>>>> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
>>>> Acked-by: Florian Westphal <fw@strlen.de>
>>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>>> ---
>>>>  net/netfilter/nf_conntrack_proto_udp.c | 4 +++-
>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
>>>> index 3b516cffc779..12f793d8fe0c 100644
>>>> --- a/net/netfilter/nf_conntrack_proto_udp.c
>>>> +++ b/net/netfilter/nf_conntrack_proto_udp.c
>>>> @@ -63,8 +63,10 @@ static bool udp_error(struct sk_buff *skb,
>>>>  	}
>>>>  
>>>>  	/* Packet with no checksum */
>>>> -	if (!hdr->check)
>>>> +	if (!hdr->check) {
>>>> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
>>>>  		return false;
>>>> +	}
>>>>  
>>>>  	/* Checksum invalid? Ignore.
>>>>  	 * We skip checking packets on the outgoing path
>>> Hey,
>>>
>>> I think this patch broke geneve tunnels, or possibly all udp tunnels?
>>>
>>> A simple test that creates two geneve tunnels and runs tcp iperf fails
>>> and results in checksum errors (TcpInCsumErrors).
>>>
>>> Any idea how to solve that? Maybe 'skb->csum_level' needs some adjustments?
>> Probably better to revert and patch nf_reject instead to
>> handle 0 udp csum?
> Agreed.

Thanks, should I submit a revert?
