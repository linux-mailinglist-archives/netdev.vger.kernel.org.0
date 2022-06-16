Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF854E96E
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbiFPSdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiFPSdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:33:16 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5C124F0D
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 11:33:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KehWiKjhxV2b2PFsFhRHr9nUtqF/KBzd5nl8CDOHKXrF54kJ3e5r9haCrdO+dsvyfIB4xJQucYAiybKKSd67eKW8gPN+7ToLAz9Kdt3PYH/NSNSO4qZd4sTPBmjDnLwGBbODhnXemv9AHgDqK6V9nHSuXQ9A8TIE86jwIYDynI40agVMHDZxLH8tuTnwHcUzgptACc9s19Nw83knYNKrCqN4GBTvr4uV9RopJuc9F+VbuJnWv0/hHqonYVo4LmXjlqJcwvNTu6p/nNLjwdaUwE0EFbJAy3CI/quQ2BURJAQc8xrqKOaqQH8sB6JBaJKORMBrZBvE6Srjqph77zpaqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAI0K5LZgECu/j73VVhSENIVJVALxScr5bpCMMjRp9k=;
 b=N4AX8GgN227hA/DJLIzxRf+rJxee1U5OtadpygibPBTiyoSMfUVIKb8+nyNa9jR3uGsW6xt9IFtv6jsQUcogOOj+wZLYwBU8zcIiqkagkxR8VmrWPAg3IThAHBknNYfC3jsx2JAL8/8+lzQP3qNv8NukqTjDhehnQ4dOuJtLMu8dweuS8jb8xV0Q8bvwcqKVP+h9bfSvf6bTa8s2t6kh6gpFzi0sdO8IW/JJPjdaKiK32ZbqkW+Kplxw1l21gnv1ksumXkdCQU0qx6muNe+3NYlbvqwaR/3tAMl+NOLCwoWKinIjyJYujQ4P1Vi6FmDZUy46rF+WoP02BlxTcNI9Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAI0K5LZgECu/j73VVhSENIVJVALxScr5bpCMMjRp9k=;
 b=LGsGO5wB54AaZY/HuBj0KU9aPaZpPd+lU5thgKagIPNys340cFoqgAD6Fu40l/qlshpQqof+5Wgx3PleW5OOdx2UPyBL8SpZtML7fT2wOdwQX6+tlhusG/n9hH42uLQakrp/MqUbxgJbY/7o9hxSjs9+6fnqwqCJdskO1KlsGEgdMrGWm6WfeuvlEx08qU0xsv0KKVQzlJ/vMw+KxXFHuPGPV7ATkjDltpIqC3UPq+LHRYI4R3F/+8+b4YuorL48mKHXPwhCW39QblRgoqcxERx2cAu7fy56fMcCSqGvOxOCJocK3gzO9LyPESnV80616nFO1kCnV91Kn2F8k4ElzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3127.namprd12.prod.outlook.com (2603:10b6:a03:d8::33)
 by BY5PR12MB5528.namprd12.prod.outlook.com (2603:10b6:a03:1c4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 18:33:13 +0000
Received: from BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::302b:ad67:78c0:64e4]) by BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::302b:ad67:78c0:64e4%7]) with mapi id 15.20.5332.022; Thu, 16 Jun 2022
 18:33:13 +0000
Message-ID: <1e6d685a-66c3-3443-3b35-d7b0d0753a20@nvidia.com>
Date:   Thu, 16 Jun 2022 11:33:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: neighbour netlink notifications delivered in wrong order
Content-Language: en-US
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
 <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com>
 <20220606201910.2da95056@hermes.local>
 <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com>
 <20220607103218.532ff62c@hermes.local>
 <CA+HUmGjmq4bMOEg50nQYHN_R49aEJSofxUhpLbY+LG7vK2fUdw@mail.gmail.com>
 <78825e0b-d157-5b26-4263-8fd367d2fb2c@nvidia.com>
 <CA+HUmGhPbcY0Jr9vh5F2Mov4jbAbeLb50ugTpGNuLcDzLTqfDA@mail.gmail.com>
 <CA+HUmGhy1gqH8MjiOqfsq7-sbGnWDzosC334SPR9dQYJZrMY9Q@mail.gmail.com>
From:   Andy Roulin <aroulin@nvidia.com>
In-Reply-To: <CA+HUmGhy1gqH8MjiOqfsq7-sbGnWDzosC334SPR9dQYJZrMY9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::13) To BYAPR12MB3127.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f82501e8-c9a2-4387-8c55-08da4fc6abae
X-MS-TrafficTypeDiagnostic: BY5PR12MB5528:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB55288EF88C3A6963A19AA6E5CAAC9@BY5PR12MB5528.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vWqRivLZv++heRJgH5h59U0rPueO1H+xHUoXkfjtCRaJpQn4e0pStJXoZafh+xJnHQW3Wy18GOPKSq4RCTslYsD8fAcvRoAuvxaDv55YMtvSSRzmI0tPHAam929MxKRP0QVYxK1HuLK59G1w7a19sXF2HLRdsNBtmGFMk0UewzGyapGH8MFW8eEbcHUFA2dpSVKw0hSHPpxJSA5L3Vvtu1+GBvxov3cbUcEiSpk9RG6+O1AVkK22hqm3QS+up9NLPZFc86MCsWBXqlpaaSTx7GizCCy8Gtx6Ohv5ytAQVlWSRBgFIxdAvHgTwBpA2Zu1lG8vng48XQ4BnrgKf0D9G7y5eiM0a//vQ01zuvlSkYdv97sLESpx01+3NDH9TzUD8NhoM3RxPGh4e75qrq6qRaq+JcAX6yTVAiOzOfnDtvKWKSiTHf7O/1TQeNHgaubxK8HJ65Zq3fkAnx9rOsiUXvMNeJ9uaQP/5xlNOTFeFuaK9Wof1TwZ4ogLHnCkNcom9nUKyLXU0180YgNA07VuZynF1J6h4AR5/8x5SZ5jNus5mCrYoaRbGqnMJg+fqft4V5NQcPGF/qip7mBJCLUjZIlX3p/ZM4x4H0cP6cL61xEbQRVRz0vVQhkDP2BzSbQRU/F3wMbvtB9gRBsGqgiMterVkRrOvs1SIlpnCfBFbNseGxVoeWEbjJV8GUmXHhAdjYBCd0UEgPSTItSGj4xq55gr4GCqAgAypPFppv2bkfM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3127.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(5660300002)(6512007)(6486002)(508600001)(15650500001)(186003)(8936002)(38100700002)(31696002)(36756003)(53546011)(83380400001)(2616005)(86362001)(66946007)(8676002)(26005)(66556008)(66476007)(4326008)(2906002)(316002)(6506007)(6916009)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3VlajV5U2VzRkh2YkJ6d0xIUWZETUhjRlRFMHQ5NDNYL1Y1cnNXditZVHJ2?=
 =?utf-8?B?UnZkNDNOT2IzSncrb0M3VDB1OW9vQUdTQzg5WnI2eWVobDdnVVlBekFXbGxs?=
 =?utf-8?B?V0oyTm9yVmRubjNoamtRUnVjaDdnOXNhSkdMTVA1YjBNSnlhSXUwYUZZSGdh?=
 =?utf-8?B?ODVMZHdkT1dnakowcUxacXFMcVVIUFRzakdncVl6MTlLS2MwajRyaUNqNFhU?=
 =?utf-8?B?SitJcVluVmEwNlVFMUhPeml0SEtiUzhyMGZDN3VXb1lWSFAxajl4WXcyS3Y1?=
 =?utf-8?B?RXlmY2JmcFdGZkJuZjg2MDlEdEtkc1FvSExrWUdmdDdvQWxuZCtUZnlwZXhp?=
 =?utf-8?B?NzZWU1E4c0owMnhsOHIzTkFqd3JwNHFQSEk3QXdPOXRYbDZoY1Iwc3dqWG0x?=
 =?utf-8?B?VHJBQnRMZm1PVkZiY0MyYmxTbnRFVVJNU0RQR1M3MUZZa25qVzU4d2xsM21h?=
 =?utf-8?B?d09GeFU2Mll0MS9qdWJvQ0lhWDJxYk0rMzJmdjBDb09nQU1JT2YxV0lhM3pE?=
 =?utf-8?B?NktQdUhXRm5JSWNXRWtvVmxSVUgwYjBXRW8yWkRlU1BTbExMRWpMNG5ISHZQ?=
 =?utf-8?B?RFNPdDJhU3lCTk9GRXRra1pRVHZ4K2hSRnRkaHMwL0dzeFR3ckQ5Rm0yMEk5?=
 =?utf-8?B?L3Qzelc1Z0NWamRPaDFkZWUrb0hrWWNFZUE5L3BYek11UzRGTW42c2Z3eVM0?=
 =?utf-8?B?cUJ6RjVPSGxGMnBBcnVkajM0TTFwTWdTUU1sU29UTTZNS09KcmNSczIwOEs0?=
 =?utf-8?B?UG5MbEcwNzc4RWFUUHpIMllzWThUVUxlMVJyUWUvNkN3RVNoTStTOEJoeWVp?=
 =?utf-8?B?ay9DQWppSk9YYUZtSFFOWjhsVmNzdDFEVzkzRlgxb25oVkNUOVVRMWJuOXF1?=
 =?utf-8?B?eHZLcVF3ZUFWWHdLS24xWVBJclJwc1VaYVhGVkZJNnY3VnBGb0hwRkd5RjEx?=
 =?utf-8?B?aWQzdDgzbDJWMW5BRDlUb3UxRGk0cEZIMW1MdEE4VWoyMGFJckltVEttbCta?=
 =?utf-8?B?d3B4cGlPNHFSbXl0aFo0Y3EvQ0ZqTWhjZUUvL21Ya01pNVdJL2hJWUFZcEpj?=
 =?utf-8?B?UXhRTnMwOThnNjBvSjMwOUZSYkFVTzg4QmM0QzlxeHExb0hQUUNxZk1mZXlz?=
 =?utf-8?B?TWVqaitvcHc4R3NqZWgyWDBUQnFhZzVvMGlzdWtCNWY4T2tzY0NPR2hxd25y?=
 =?utf-8?B?R1RlaWlNUThDcnJYZHY5UHF5bzVsTkd5ZzZ4U05wM2tZOTRRMlNER3hLM2x6?=
 =?utf-8?B?REtVdHJhdzhSZ3RzNlhGK3JxZTBTTnRReldPT0dnSHF2OGwxVDdoZmQwSVcw?=
 =?utf-8?B?T1VHRG5qcTVFMjQzUHlJMUFFbXZxNHF5VEQxWHQwNkpuKzBrcGRjaDIxcjlL?=
 =?utf-8?B?NUtFeUZQZUNYWU91K2FLVER0dFdrUXJMK3NNVjNpRzhQVWZIR0lRL1Ivd0ZD?=
 =?utf-8?B?dVpOaVE0aTBodlVReU1DZXp2QkRBT3VwTTZHTDRCcG1FZEU5eVpHbWtNMERo?=
 =?utf-8?B?TGplNXNHS1ZFckhleUwzNW0vaVNlajVKVFFIdlQxRUV4T3hCWWtxd1gxeFgw?=
 =?utf-8?B?NDBzajBiRVR4WEdZWklsSERrWU8yV0NTTGRJTzdJYkxML2RTNWZOSnFYVm5O?=
 =?utf-8?B?TzQyeDh2eG16b295M25hUDJ4T3g0VWJhZktiLyszVEZPMDlmZCt6dTBCS0FU?=
 =?utf-8?B?YWdrQkh3TE9TMmQvOU1UOUtTYlE2b3JaWmVoUFNDZC9EVTFwQ1I4S0dKN0dF?=
 =?utf-8?B?VWF2ZUVDTkVqWHdjTXdZUjNyZ3pQdmtuaWhYT2hBbkorSHBXSDJlOTZJc3ov?=
 =?utf-8?B?OUcvSUoyTTJBQzdaTGt4ZUFlRGFhTnR6ellMNjhndGE3Y3RUd1N2M08wTmFt?=
 =?utf-8?B?YjlHTE0zNCs4bzFzN3B2UE5vSmFibVpGVEtjaEhzaFJCZHN2dk1UWXFKTmp2?=
 =?utf-8?B?VXplTU4zNDhVeFRXRmUyT3g1Q3BVcVoyRklBOGNXR0cwRDlmR1ZzZk5aK2tK?=
 =?utf-8?B?L3FwTnlXVTJrTjRXdElkQUZOVkZ6TG9SMUcyY2FHMEY0R0xaa2tXWmpiQjJo?=
 =?utf-8?B?bE1wbG5IVzN6cjV5aUQ0ZlVlaEhHVHpzV3dBbnlLVTFGUkwzc28xNXhJeFlh?=
 =?utf-8?B?U05jNTFxUENTTy9rbXEzbURRTWYxdjZKbkhzRUo5RXAyNjZpK3NBQkdYWHhC?=
 =?utf-8?B?d0NzOTlQTDlORlVjZzVmUEdtaG44RVkyYWZwa3J1SFkvTDVUVExGRDJIWnVC?=
 =?utf-8?B?UnZjK25NMkxwZjN4QU5VblVDYnRnSkV6WEdjRmNrVWFXZ3JQMngyTDA5ZUJT?=
 =?utf-8?B?OHZWRkFVY2RtdDJxRFBVVWhrRGJjSUF0dXJoUFNJaXQ1N3RKVGhaQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f82501e8-c9a2-4387-8c55-08da4fc6abae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3127.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 18:33:13.0527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwzghD6ykMhKXujnTCybNDrrSfNz3L+Qfj1ZnZWcwWrW/+1PDV/UU+36SG+cM++f+6BXKYPCkBHjlyyreSjD0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5528
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 9:18 AM, Francesco Ruggeri wrote:
> On Thu, Jun 9, 2022 at 9:40 AM Francesco Ruggeri <fruggeri@arista.com> wrote:
>>
>> On Mon, Jun 6, 2022 at 7:07 PM Andy Roulin <aroulin@nvidia.com> wrote:
>>>
>>> Below is the patch I have been using and it has worked for me. I didn't
>>> get a chance yet to test all cases or with net-next but I am planning to
>>> send upstream.
>>
>> Thanks Andy, the patch fixes the reordering that I was seeing in my
>> failure scenario.
> 
> I think that with this patch there may still be a narrower race
> condition, though probably not as bad.
> The patch guarantees that the notification is for the latest state change,
> but not necessarily the change that initiated the notification.
> In this scenario:
> 
> n->nud_state = STALE
> write_unlock_bh(n->lock)
>                         n->nud_state = REACHABLE
>                         write_unlock_bh(n->lock)
>                         neigh_notify
> neigh_notify
> 
> wouldn't both notifications be for REACHABLE?

Yes that's right, in this case it will consolidate both notifications to 
be the same, i.e., last state.
