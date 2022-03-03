Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9014A4CB69B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 06:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiCCF5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 00:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiCCF47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 00:56:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D6211E3E2;
        Wed,  2 Mar 2022 21:56:13 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2233GOuf028932;
        Thu, 3 Mar 2022 05:55:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/CpbvVCjXdFLefCjaVVcG7fy2kSHmwjFDPEImNWAy9o=;
 b=yMs1LT8AT0kYoaK+Xo4RvKRvZZnEBFHwV7tzCFbDnar10j9nfoRjxav0jY1KVxS22KM1
 IJGbHULnjNLDgyuHUhZ285b5NrCjNxktZ9PXNvrmfVauGCsIC3jHfCDfiWKIfySui26i
 yJEHHQWbXFBLA2VY+rD3wvrOxVwczM1lA+N47pef3czm8FcYM5JDy9Fltl/uQrNGZsh+
 FI7GlWAFd0S1XK+PtU0Ve5lbemZZWwwK2IccYQ9lEn2DHYuTv0FMYEmLMOyI13BPmQFj
 8qvATpD6HjdDpXmGdfVvwEcAOi49QTJwzlQz4LAIV3gBt1s0qF9cdGix9+jLGPl+Cgxr xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14byvaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Mar 2022 05:55:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2235fTvL176716;
        Thu, 3 Mar 2022 05:55:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 3efa8he6t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Mar 2022 05:55:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BT0SIZe3fjdX+4fIGQEAs3hLac0AZViGLb5LcEhyddCtQknOGFL2tzX33PTlMuBG9/JhvC76H48GQfM1jH4PAQfbUeayehlUxbqZbrH5/YbbJpGDWyh2+WgaUrk2AA+ZmHzf6k4w2mU/c8Js5bf6RfneRF5htf9GprTMQpcgVIHgkL7LkxA3iYw9vxD+NOG2KRaMovsrCo3tV/it6mmHjtm85yKR7mG02JkRnahfcZktkz6BsCwj9aefNshrHhF98M5wleBBQFUWxN+CF8+TXmYprcAZ1HXfmMaRtl52GbRvn5svzw765Y3jyrCgLhEKOtnS0uAjZzyNURGT1r7yFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CpbvVCjXdFLefCjaVVcG7fy2kSHmwjFDPEImNWAy9o=;
 b=nUkTvrZD8yombitsLK57TUIU/VhS3M3Qae3z7XvqhNPmeISq/usut1WE6WA3HwSkkDFm3P8KwDoiNOmHPk++9A2+vFlat4TmioYbABqc/UL1v5KRKc/DSq6Q7XY6G/7CW0VY44TnJxlsbDVHDeM2CVGdjK0pX2QTj42qFMKoFCEr4y/GbGOYgoQAhu6+9gSmeuIEoWopBpmD/1aG33LMtqNiX2iWnt9/lcT38fAH3YJuadAagXsnQWB/Eu5a5KPNW7z+Em9c7KBWVkzt1IHXWgOjwnV0fgYkUKQKReU7X2o/8fWoakRzrYg62/kEFh7JT8C2nNyDzKuTy27gjrYklw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CpbvVCjXdFLefCjaVVcG7fy2kSHmwjFDPEImNWAy9o=;
 b=iUSYr9b17Hym8cNvTLbA9gtr2MrHf+xx7T68PQEs2ZTp/vw92KmIc5zGN9Dw32gtsT1OvIS4SiOV1YK/3FLDds+ukItvMY64u42WoaKqzPaXKLNviUNFfP6qtZKJa8FOYy3ScOob1OSWioEdH7bVkXTC3C+7YMI7AxNc7saVxuU=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MWHPR1001MB2144.namprd10.prod.outlook.com (2603:10b6:301:2b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 3 Mar
 2022 05:55:15 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 05:55:15 +0000
Subject: Re: [PATCH net-next v4 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-5-dongli.zhang@oracle.com>
 <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <ca81687c-4943-6d58-34f9-fb0a858f6887@oracle.com>
 <20220302111731.00746020@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <e3bc5ac4-e1db-584c-7219-54a09192a001@oracle.com>
 <20220302212122.7863b690@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <8daa7abc-c78f-3895-996f-6bb5ead5049a@oracle.com>
Date:   Wed, 2 Mar 2022 21:55:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220302212122.7863b690@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0048.namprd02.prod.outlook.com
 (2603:10b6:803:2e::34) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9158837e-03e2-4af4-7f35-08d9fcda6356
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2144:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2144C4CF030003378E1A8A6EF0049@MWHPR1001MB2144.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5kQburEvTusd2twPY8SSBBgQ60pRQedUgvvZEyNIDgXUtvxX0f43x9mnD39TR7pIlAMFM+Ruqwqe2KdkhAcf+W+E/NgsksXprbpRZ7ZbS6ZcIWugQ0Z03xXt5HeliBqAFpXDu3wcXfMuWku/0wCln6LMhewPPwHSvKci7Aw9COI76AgUgxWFrkVDU6vlH94y5pEks3GpvWip8inkNQ8nysIZGU3J8DsUoD4fOGxKvFaDCI+TrbpWNuXDz173dTjeO+/luf8QtDH03R/7lwHfUfregCYhcYLfNdd2+4MgWGZkizwGP8IfEgvBFXeYAtyyv4rcxkV3ZbDShIfDZeXiwtx3nGd17AoYHzcH3DTDMEvUI8GD4jWu5quekjZOpEo4TNOfv7BUON0yJPvk3wt7rBkr+/WBSKr2NSmbuwpDIIA4CHx+B7hCDUSZFEmbZJInaGn1KbDDvfktTfOJIBTgkUlQatJl2WUjxRqnSGW7aQhGuR56ij9CHVVcfCRzkxCszP/BtnUcewwHnwfYx9Yq/2IoQKGSceaP36/rV/KV+ywliL7wQB7ia3/Sn25gKdGuM0WYLUj0nVcCuJxELu4f1Ym5WyZN+UTAtYQwfJRLjlkZXxlgAmkf4XbAFAO+TSDAm1r+3RMhSW5M99Rkmpo+cILIW+E3Ti/n4tSvdCi6RWZmlPYXrtSiY31BNgQKX6ti3uDkt+7ONOfYBJYDvhaF6Zhh1qumeb66jrY6WX2UAY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66556008)(36756003)(31686004)(4744005)(2906002)(44832011)(5660300002)(38100700002)(86362001)(6486002)(508600001)(31696002)(8936002)(316002)(6916009)(7416002)(186003)(6666004)(6506007)(6512007)(2616005)(53546011)(66946007)(4326008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmtBNE92ZFNoc0UzUEw3K2g1b2xPemh6b2NDVW5MN0ZDOCtITjgwUE9WaUlQ?=
 =?utf-8?B?R21lQjhPMWlRVVN6UjJNS2Fwc3VEeU1PL09HUXYvM2V2aVFvTnE3b1I1SE42?=
 =?utf-8?B?YmVZZEFQN29zUmgyWjI5OXMyQ1lBNGZldFRUdE1qVFpEdUJJNXhwb0oyQ1Ey?=
 =?utf-8?B?ekpVdnNySkpiWFMwUXdtamNnUEx6dXJKWlZnMWdXdjlVbzE3S1RvSkdxYS94?=
 =?utf-8?B?RVE3aUhwWjZsNjZVWjhUZWhTVVpwTk9uUXRSWXd4Zm9tMWRQcTNKbnRvZHU5?=
 =?utf-8?B?SFVvTllWUnlKd3dmRDJtdGNlV2hmeG5vTVcwaDlWY0V2K1l3di9rU2w2MFhj?=
 =?utf-8?B?dWVQVjFVQzRuZ2Z5elE3cHl0QkRNK1FCSEoyMmh1YU5HZ2J4N21kK3JZSVY5?=
 =?utf-8?B?NURLVFJNSWxhci8walMySm1DN3J2WmtuWm1oclRrb2hZRVUwdnA5eFJ6Vkhz?=
 =?utf-8?B?b2NlYllNSG5zV29NVVVPbmxvTjdaNU1CeEhmWVNKSHJVd2N5cWJ3NTZuTWlL?=
 =?utf-8?B?QUtDdVJFUVlIaXlIZmFtZHN2aVBDVmdZdHRDSnliMGxiUkpJblMzZmhZNWYw?=
 =?utf-8?B?WitFL3ZNTWJ4cUdXVUlDZ0JXYU1PMlpDcWVHTVFhTkVERUlvSGwrQldiMHMx?=
 =?utf-8?B?UU1BckhoYi9kMEhZTW9oZUhnU256UkZJRUtNN0sxcG1vVndxaGtWNjRPL3Rl?=
 =?utf-8?B?eWRtMytJTGhnQmdUbkptYkNBdXpwM3l1a0VDQkluT3BtNW9oVmdVekFCZzZK?=
 =?utf-8?B?cGRiSUs2WlQ0WG9MRElWaWIxeXEybFIyWkxlbldvSWNGYjlJT29GSmNjM2gv?=
 =?utf-8?B?NXcyZ0hqdEtlaW5iRWdFYjU1a3VQTjJOU3VYR0Fjb3ZIbTNyWFZmUVRDdWdY?=
 =?utf-8?B?UGp4bWJ0WHAvWWhyR251dzZqZTVWaHNHRGlqQ1ZoSWxOdjNPM0dqUWxFR2Ux?=
 =?utf-8?B?OVlyY3BITzB1ZlJkSmVmckduYmFPMjBTYkN6MVlFVGJIUnozTmJYMUhZSmlw?=
 =?utf-8?B?VmdNaWhpeFgzT0orU1pqRmZiYWtGdTN0WTNNVDRadjVFZGVBZFpuM2xIK1g1?=
 =?utf-8?B?SVVJZDlxS2hqZEZRRHAveVc5MjhKWnF4RTZHVUF4Ym9UUUVmT21VTVhqVmFU?=
 =?utf-8?B?cU45RVFxSElmbEpEQkd1V04vQkpRbCtnSjhTcGk2K2JJdWowVUhaWnVrenJY?=
 =?utf-8?B?YjNnUzY4VVd6R3Z2NGRXZmV5Nk1TODhJSU1nWXBTUUtEcGptdWg4cndBQVpx?=
 =?utf-8?B?dFZsVXdpVXBKdVdYWjdIangxNEFPSkllRS9KdTdOOHZETGphb0ZNTThraXIr?=
 =?utf-8?B?V0Y3KzI0bmVwdXZjUHFvalo0bmVNWVU2bkJkUjlmYjlVclVkSjlwQVNKK2Rs?=
 =?utf-8?B?VzIxaHB5UWZTWXEzNks5b0lVRmZYRmZMUXdpRWd5dm9oazY3RXpXZ09ERE9V?=
 =?utf-8?B?cmwza0FUZThuMWxZczErdUJ3TFE5dzVlZXZCaVA0cUxYODZPWndWWTg0aWhn?=
 =?utf-8?B?MEsvaHl4THZkRzN4M1dRRVBHejlGb0hxdVY1VXBQekJMeU5Mdi9KSHRpUlB5?=
 =?utf-8?B?VStGT1BsT3JZUzFXUXh5ZGYyam5VOGZLZ0xhQUZidmw5aEMxVTgzQk04eVMx?=
 =?utf-8?B?UFZpTEhnaGFNeWlvNW8zNzFlQVZJL0FxMnNSaG1jaXVVaENEdllteGV4R29N?=
 =?utf-8?B?MEticWpKSkxBN3lxeUVMWWNldDFEU1d5SDJ2bDEyRGFJS2F4ZkxwdkZnNDVt?=
 =?utf-8?B?NHJNaDIwWE5UbXVvVFppZ3gySGZxSnRNY0lvbExOUy9LTFdxRzM3SWc2eHJ4?=
 =?utf-8?B?SWR3dU1tVi9NbEoxOXRNblNJTTdvYjZ6N2gzVHI1ajRSYlRnNkFvZjY4TXpk?=
 =?utf-8?B?a0FCdCsySG5meEl3L25hZW0yZGk1c1plMC91WUxUUVF3MXcrMW9ZbWhkSUhz?=
 =?utf-8?B?eFh2TytSWWVPMkpBY0MyN05qa1U3MDlmcFlDSWNMYkZyT2FldWFHM0FHZXln?=
 =?utf-8?B?bnM3eXRsV0owTTY0T1FVSlZGTmV5VldxMnd4SlF5clA2TVVzK1MrU1JHMGFm?=
 =?utf-8?B?dTFMVzV4eFlPT0dIb1BKU05DWEp6NytIQS9WcGRQR1BDSXdEekY4bzFlMGhI?=
 =?utf-8?B?TU4rcGNnb0RhY0JVQVAycmR4cml4dUdPQlc1dVUzcjdvalpTY04xWWE2azl0?=
 =?utf-8?Q?wzAwbSd0NdVc+fmQ0HjihkcD9BYn6+F2RXg+CSC8ORte?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9158837e-03e2-4af4-7f35-08d9fcda6356
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 05:55:15.1818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VHiezOTDoZN43zu1mtddYr+99fzh1EZR9eI7gHkFgb24fAcdiYfg2z8QZWEjYzrAnWrw2rXFVm4UDgjNh+pF5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2144
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203030028
X-Proofpoint-GUID: m48DiFQBzOS86xzGJcpqt3c8SvQmxREx
X-Proofpoint-ORIG-GUID: m48DiFQBzOS86xzGJcpqt3c8SvQmxREx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 3/2/22 9:21 PM, Jakub Kicinski wrote:
> On Wed, 2 Mar 2022 14:21:31 -0800 Dongli Zhang wrote:
>>> because of OOM" is what should be reported. What we were trying to
>>> allocate is not very relevant (and can be gotten from the stack trace 
>>> if needed).  
>>
>> I think OOM is not enough. Although it may not be the case in this patchset,
>> sometimes the allocation is failed because we are allocating a large chunk of
>> physically continuous pages (kmalloc vs. vmalloc) while there is still plenty of
>> memory pages available.
>>
>> As a kernel developer, it is very significant for me to identify the specific
>> line/function and specific data structure that cause the error. E.g, the bug
>> filer may be chasing which line is making trouble.
>>
>> It is less likely to SKB_TRIM more than once in a driver function, compared to
>> ENOMEM.
> 
> Nack, trim is meaningless.
> 

I will use SKB_DROP_REASON_NOMEM.

Thank you very much!

Dongli Zhang
