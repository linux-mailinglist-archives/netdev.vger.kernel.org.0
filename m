Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B211946474D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbhLAGnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:43:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44054 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236929AbhLAGne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:43:34 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B16T6pM031660;
        Tue, 30 Nov 2021 22:39:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ak70E96CNwkp/7Pd3h1+JF4IiLUc+2KsxVD3iwN8fV0=;
 b=n25JyoqQ8/anY/MzfIgGzdzJv6xXooS8mYooPLUzXfDt9TGSf5MHpGUS/t7G38hI44yq
 Xz9p/M/6mZ5Mwu6/Wr+2mMrgljzG0QKmihlLNkgGSK5gylukWcYSUEeRzs8B7Om+Sv9I
 0p50FgH7AfMlW0edvtmzv39MCSmVKqsjEx8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cp3tk81gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Nov 2021 22:39:48 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 22:39:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biLX1Wlre8QqDwGJnbm7+/FRoZjy1+3iaAwN8g06PPO9xvn+LC9tZgceltdW9GzhSuNVrDT0iulv2cdZ458Mq5kN64FD70ooN/QZHmMmeWVDKDoZmx7Z1Ksfz/3TyH/1NVDrZZwDor8Cjv3dJK7ZCkuJkXiesBooMP8vM2TNnSfDHayAJruVlTNIVBBePCjErGZOZy/jtxLzq916ntCnyJlkk5viB2LtZUXjzMpLp1TeFJfqmTm2tUlRBKeGGyxTfdAXAQXfcVQ7CRnBsCN8+i+rTBnbixOZu1TfAwaV096uOnYlR8lRwduKr28PJKo4OfoMs9U06GpreR9GkELBsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4O31JoBqHVj80xmN+3tUyYLKOyNEdZeTQYJ6m8h4AHg=;
 b=UZ0RgY8hYGKqHeLxDvQhzTpizqXOpVlAF2lgyTyd8pQbqoXtQnUrLzq6mQjmAqFlRCFxW3m0oshyK1afqVYV+BSmPyI9vuS8aVLRs0w55DtFnUsVa/NZDO4FNuO0/8G+gephYm1Fk+8XMBYJl0FPy/LHjlpPgI51ubpGOIC5DasilqYJ7RIyAqadIF0wsq/qP7SbZI/Gk2/ldWJOXtKqrzWnjcJ2OAIMpX7Xlb0QOah6zhH8wYixkjGimZYYHT9MsQIOAFzMN73miJGpyCIoAFMUzwYIxAFBA4FgfWSfqTS6uSjnzB+VxCR1BmDngaBBymYmcRnSrNlZsnrSH8FVFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2254.namprd15.prod.outlook.com (2603:10b6:805:22::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Wed, 1 Dec
 2021 06:39:46 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a91b:fba1:b79c:812c%5]) with mapi id 15.20.4734.027; Wed, 1 Dec 2021
 06:39:45 +0000
Message-ID: <4f895364-a546-c7dd-b6d2-2a80628f2d9a@fb.com>
Date:   Tue, 30 Nov 2021 22:39:40 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH bpf-next 09/10] bpf: Add a helper to issue timestamp
 cookies in XDP
Content-Language: en-US
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>, Tariq Toukan <tariqt@nvidia.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-10-maximmi@nvidia.com>
 <CACAyw9_MT-+n_b1pLYrU+m6OicgRcndEBiOwb5Kc1w0CANd_9A@mail.gmail.com>
 <87y26nekoc.fsf@toke.dk> <1901a631-25c0-158d-b37f-df6d23d8e8ab@nvidia.com>
 <103c5154-cc29-a5ab-3c30-587fc0fbeae2@fb.com>
 <1b9b3c40-f933-59c3-09e6-aa6c3dda438f@nvidia.com>
 <68a63a77-f856-1690-cb60-327fc753b476@fb.com>
 <3e673e1a-2711-320b-f0be-2432cf4bbe9c@nvidia.com>
 <f08fa9aa-8b0d-8217-1823-2830b2b2587c@fb.com>
 <cbd2e655-8113-e719-4b9d-b3987c398b04@nvidia.com>
 <ce2d9407-b141-6647-939f-0f679157fdf7@fb.com>
 <0a958197-67ab-8773-3611-f8156ebdb9e0@nvidia.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <0a958197-67ab-8773-3611-f8156ebdb9e0@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MWHPR18CA0063.namprd18.prod.outlook.com
 (2603:10b6:300:39::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Received: from [IPV6:2620:10d:c085:21d6::13b7] (2620:10d:c090:400::5:286c) by MWHPR18CA0063.namprd18.prod.outlook.com (2603:10b6:300:39::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend Transport; Wed, 1 Dec 2021 06:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81b58101-5687-4279-7bc9-08d9b4955d40
X-MS-TrafficTypeDiagnostic: SN6PR15MB2254:
X-Microsoft-Antispam-PRVS: <SN6PR15MB22543D433928351A241D73EFD3689@SN6PR15MB2254.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4BZbdwWgUvpvcEYaJoZRkm63X6Op0/9FmkbH35tuvwqXtUenVbjWNeWYBth9Ga0bUpcpF93WcjPIit1blayfQb2652GY38slrPG5QTltoTJ8Pu7tX50GIFyVsmHEMW0CE/U3eDSyRq5gArzhNFjYygqnx308BUjrynju6loL3na/2jZf3H7+xOWAPj7eUA8jcpfG/XvpkT/7SdFpp/MsvF5zwx5bf8RAoLZISi8ze8CU0ORS8WSMuoYz7WkGUaSS2iSf72FXlcTt82AjoI2fnnaF3c9uCVAQk+1Esd3Szd/a1Qsz00wBAm1zvNgXZC9DceL/79uzlDONsGNAAMSQMS3OmqEbZGrWvWYfmUu+byVGqryW/Z4HXHvlu2LLgWP4lJZkQ2SNbvQ0hBPLLwGwDZfQj3DHFCQLWAHIxPud9V+Wvdzch1sXckhL4zEu7iRCMmb4IVWHlNITsTs33hrfQoW+Osmzp2miWwW9HSjtkbGieiX+hRu08WU9hDebxFTNb2YBaNHrZRAzMzVWmljGYoQAsMC5dKgT6hkud45oR2uPZlVXNPOQPxSsVhofT2+B5WyO3XIsR3XCXv63Dw+BrdXWucnfWcnHAdUfO+0f9R4KPIfKfsAkExiZS7UhdJGEXE9yDym6oB8FRCOZkRHE1uzoAYTJ9wSa+//yg3ZzKJIHztmNs0cmkrAV2JmVdfgoNS1Ec36Z71QSLc9rnblnZvMIxsWh2Dz8rUHMlDKUxfqTzyKaI1uEujxAWrZVYIPJSZeR5XNmH3nnR0ELghb8MoDEIBISD+5yp5YgisjKH+F4AbJoCiNT71kHvlYslaRc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(4001150100001)(66556008)(66476007)(508600001)(966005)(83380400001)(8936002)(54906003)(53546011)(38100700002)(66946007)(6486002)(6916009)(186003)(52116002)(316002)(36756003)(7416002)(66574015)(4326008)(5660300002)(31696002)(31686004)(2616005)(86362001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXhTNlNjc0hxeXViL2hRcGFnS2psdHdtTXBZNG5PVDV3bnI1SFNtWER2cWRn?=
 =?utf-8?B?R2UwRkozV3Vrd0liMDdSSmJ5U1d5VkxoQjNrR0R6NW1RUTFhN1NPeDExQWNU?=
 =?utf-8?B?dGlld1V1Zjk1Mk5paFkyWU14aldJYmgvdk5VM04yNWh0bjFBclJnaWJmWlRD?=
 =?utf-8?B?UkNjS1JUK0VFMHlUN0Eyd1Q0YmYxZXBpRmFHbGw5cWVMbUZxRU5nWVlJMnYz?=
 =?utf-8?B?dTBvaGJpY1JGWEpONlRraE1sOWRXWUV6aGpsY1hqYlBuL3pHNTVtQjU0SExk?=
 =?utf-8?B?NkgwUnlvSEs4N2RHMlQxblB0K01Yb1lBQVgxOUhvNGpFdENmbUdIOUcrTzI5?=
 =?utf-8?B?WTVxVkhpWFRtQzc0dGVPZDM4MU9YVGw2U3d2VFZYVXhRRStvZStuVk1NUlhv?=
 =?utf-8?B?ampHWTg3Q2Z1NFVRci9PNEpkSU5zMTl5d1NyRXpXM0tsYlpZTTZ6NnI5MGx5?=
 =?utf-8?B?R1BQNjBMN0I3NDYzd2wyT1M1RGNhMXdIRG5kRXBlaExieHFnTE9aU05zdy85?=
 =?utf-8?B?ck51OXpiUU5uNitWU0dGVkZUbUxvODdtU1FEa1ZJWnh3ZkQ5RzB4bWpoMER1?=
 =?utf-8?B?S000aUdaeTUvSnNvL2JxZHhTYkJ5SG9OR2JDemo4ZFd6UUFEdWRYaXgvcTd2?=
 =?utf-8?B?NlA3UWtoMXQvT3BuMDgzRzhMMVJUMDMzZDArcDVsSU1PaTd2MXhzS21rUzE0?=
 =?utf-8?B?UFBIaGhCNmdWT3RYc2FNRHhFc1RxTjdUR08wZGgzaFdlTVN6cVlIZjVBL0VY?=
 =?utf-8?B?Nnp0amtUTXUwVzB3WUhYMjNINmNyTHR0SHNKcWVwSzk0Umhvci9vWmU0VHd6?=
 =?utf-8?B?aDAydkZzVWhHbHM3ZWJRLy95VkhYc3A3ODN1VFQ4NmNobjliMlVDNXFRSTJL?=
 =?utf-8?B?QTF0MGVSM1J4a0Q4QmFWMWVEdG05NlJFNWFTQ0lMWFVkRGs4TFI2VWVQVlhC?=
 =?utf-8?B?SGpSei9rY1pZbXlDL21pTW9oRjU1ZE0vR2pKRXRtK213NTJIK3poNkd3d3Bj?=
 =?utf-8?B?K3RTbUxIYm1SZWROS3puQ3F0T2hxS1Y5KzMzeWdCNFB6SWNQL2M0M3FoSFZn?=
 =?utf-8?B?cjQwU2l3UTI5T3lvNFZadVBQd1MxQ2FKYmpmUEFnb29oZnd1QWovUHZKTjNm?=
 =?utf-8?B?Vnk3eXNNb3lhNEs4a09OMTZoNjNrWjVZL1VwWWZkdkxwc2RjbG5FNFA3TFlv?=
 =?utf-8?B?SWJEUjh2MXE3UVZVNGRzbzFMUzJPRkU5UEdtWTVRSjJtQnN6by96eHYzVEsx?=
 =?utf-8?B?T0Ztc0c2WjhjT3VvRGZ5elJ3YXpiWWhvVVpWZFFkQWZWYVRNTm5vTG1mN0xU?=
 =?utf-8?B?bEpla1dXdDNKWlYvN3FWWUMzTGdkL2V4N0pRR3pmQk5oanBPVHI2R21vWWk2?=
 =?utf-8?B?azR3RXNBSFFMbzhnUWhJK1ZIMjNNSm5MQmxJMzAwRDV4bitQQm93YnZYNVBu?=
 =?utf-8?B?ZC9abDFwaUg1SEQzaXNOeHNPYUJETVBoeThiZHZEa3VHRDRWTHVsdllyM2dv?=
 =?utf-8?B?ZmtNa3czVTMrSDdpcDQxdWRrM2JKMzRWcEtacGdCY2pIbUJtZ2VUeU5QeE9m?=
 =?utf-8?B?M3FJSXhhZEhhYzZ0ck9rdWNTRmpEMXIzZDE3TVlBVCtWMnk4RkJIR2hGQVdk?=
 =?utf-8?B?dGd0SW5FR3hiK0p2SXA1RzJ2M2pQYXpiNjB2ZFc0NE1yUTNIZXIyN1Y5UmxP?=
 =?utf-8?B?eHIvd1NvS3pYaHRwa1hqUXNhY3JiMlZJeTNuSHNpNVI1Vm41ODhxakRBekN3?=
 =?utf-8?B?QitOdCtSNWZJYzVqcHVWVkhQN05Fc2ZhelhrNjh2MkNKMFpWY1JnOXRYNjR4?=
 =?utf-8?B?TFpSS2pGUzBFU205MVJGMXNTRGZjTU5kbjF6MHRycE1uY2FWSkJlTHNqL1Jk?=
 =?utf-8?B?b2lmbHByQlUvOVpHTWc1cVlDZHpsMDJKQUxYYTdLSzU5b1hZNXRBUHJudklS?=
 =?utf-8?B?MC83blFmUytpSGZjdERMT3E2bVczQ2srOFVvTDh1VWdmc2JzSkwzUkxPVEpt?=
 =?utf-8?B?aUg2UlNab2dCbGdYc2p3RVJVT3M1a05WODJLUlpHbGd3TTR4UGNob1I1bXpW?=
 =?utf-8?B?WFpJQ3pNWXR4bmQrNzRTVDNlYXNBRDlrZXRHZmRFcFdvSkhUM3diNGNsZFZL?=
 =?utf-8?Q?57egOh6KFz2nXcANXdj5Alovr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b58101-5687-4279-7bc9-08d9b4955d40
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 06:39:45.8449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AL8PJz7C9UzhuBGyxhic/Zw5BV4oditB4wIZXPxoOyQUGe9G8KkfP01jWbmOONU8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2254
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Mwx9r6t30NvNvv5rLGfiDvX3HHRTTYC6
X-Proofpoint-GUID: Mwx9r6t30NvNvv5rLGfiDvX3HHRTTYC6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112010037
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/29/21 9:51 AM, Maxim Mikityanskiy wrote:
> On 2021-11-26 19:07, Yonghong Song wrote:
>>
>>
>> On 11/26/21 8:50 AM, Maxim Mikityanskiy wrote:
>>> On 2021-11-26 07:43, Yonghong Song wrote:
>>>>
>>>>
>>>> On 11/25/21 6:34 AM, Maxim Mikityanskiy wrote:
>>>>> On 2021-11-09 09:11, Yonghong Song wrote:
>>>>>>
>>>>>>
>>>>>> On 11/3/21 7:02 AM, Maxim Mikityanskiy wrote:
>>>>>>> On 2021-11-03 04:10, Yonghong Song wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 11/1/21 4:14 AM, Maxim Mikityanskiy wrote:
>>>>>>>>> On 2021-10-20 19:16, Toke Høiland-Jørgensen wrote:
>>>>>>>>>> Lorenz Bauer <lmb@cloudflare.com> writes:
>>>>>>>>>>
>>>>>>>>>>>> +bool cookie_init_timestamp_raw(struct tcphdr *th, __be32 
>>>>>>>>>>>> *tsval, __be32 *tsecr)
>>>>>>>>>>>
>>>>>>>>>>> I'm probably missing context, Is there something in this 
>>>>>>>>>>> function that
>>>>>>>>>>> means you can't implement it in BPF?
>>>>>>>>>>
>>>>>>>>>> I was about to reply with some other comments but upon closer 
>>>>>>>>>> inspection
>>>>>>>>>> I ended up at the same conclusion: this helper doesn't seem to 
>>>>>>>>>> be needed
>>>>>>>>>> at all?
>>>>>>>>>
>>>>>>>>> After trying to put this code into BPF (replacing the 
>>>>>>>>> underlying ktime_get_ns with ktime_get_mono_fast_ns), I 
>>>>>>>>> experienced issues with passing the verifier.
>>>>>>>>>
>>>>>>>>> In addition to comparing ptr to end, I had to add checks that 
>>>>>>>>> compare ptr to data_end, because the verifier can't deduce that 
>>>>>>>>> end <= data_end. More branches will add a certain slowdown (not 
>>>>>>>>> measured).
>>>>>>>>>
>>>>>>>>> A more serious issue is the overall program complexity. Even 
>>>>>>>>> though the loop over the TCP options has an upper bound, and 
>>>>>>>>> the pointer advances by at least one byte every iteration, I 
>>>>>>>>> had to limit the total number of iterations artificially. The 
>>>>>>>>> maximum number of iterations that makes the verifier happy is 
>>>>>>>>> 10. With more iterations, I have the following error:
>>>>>>>>>
>>>>>>>>> BPF program is too large. Processed 1000001 insn
>>>>>>>>>
>>>>>>>>>                         processed 1000001 insns (limit 1000000) 
>>>>>>>>> max_states_per_insn 29 total_states 35489 peak_states 596 
>>>>>>>>> mark_read 45
>>>>>>>>>
>>>>>>>>> I assume that BPF_COMPLEXITY_LIMIT_INSNS (1 million) is the 
>>>>>>>>> accumulated amount of instructions that the verifier can 
>>>>>>>>> process in all branches, is that right? It doesn't look 
>>>>>>>>> realistic that my program can run 1 million instructions in a 
>>>>>>>>> single run, but it might be that if you take all possible flows 
>>>>>>>>> and add up the instructions from these flows, it will exceed 1 
>>>>>>>>> million.
>>>>>>>>>
>>>>>>>>> The limitation of maximum 10 TCP options might be not enough, 
>>>>>>>>> given that valid packets are permitted to include more than 10 
>>>>>>>>> NOPs. An alternative of using bpf_load_hdr_opt and calling it 
>>>>>>>>> three times doesn't look good either, because it will be about 
>>>>>>>>> three times slower than going over the options once. So maybe 
>>>>>>>>> having a helper for that is better than trying to fit it into BPF?
>>>>>>>>>
>>>>>>>>> One more interesting fact is the time that it takes for the 
>>>>>>>>> verifier to check my program. If it's limited to 10 iterations, 
>>>>>>>>> it does it pretty fast, but if I try to increase the number to 
>>>>>>>>> 11 iterations, it takes several minutes for the verifier to 
>>>>>>>>> reach 1 million instructions and print the error then. I also 
>>>>>>>>> tried grouping the NOPs in an inner loop to count only 10 real 
>>>>>>>>> options, and the verifier has been running for a few hours 
>>>>>>>>> without any response. Is it normal? 
>>>>>>>>
>>>>>>>> Maxim, this may expose a verifier bug. Do you have a reproducer 
>>>>>>>> I can access? I would like to debug this to see what is the root 
>>>>>>>> case. Thanks!
>>>>>>>
>>>>>>> Thanks, I appreciate your help in debugging it. The reproducer is 
>>>>>>> based on the modified XDP program from patch 10 in this series. 
>>>>>>> You'll need to apply at least patches 6, 7, 8 from this series to 
>>>>>>> get new BPF helpers needed for the XDP program (tell me if that's 
>>>>>>> a problem, I can try to remove usage of new helpers, but it will 
>>>>>>> affect the program length and may produce different results in 
>>>>>>> the verifier).
>>>>>>>
>>>>>>> See the C code of the program that passes the verifier (compiled 
>>>>>>> with clang version 12.0.0-1ubuntu1) in the bottom of this email. 
>>>>>>> If you increase the loop boundary from 10 to at least 11 in 
>>>>>>> cookie_init_timestamp_raw(), it fails the verifier after a few 
>>>>>>> minutes. 
>>>>>>
>>>>>> I tried to reproduce with latest llvm (llvm-project repo),
>>>>>> loop boundary 10 is okay and 11 exceeds the 1M complexity limit. 
>>>>>> For 10,
>>>>>> the number of verified instructions is 563626 (more than 0.5M) so 
>>>>>> it is
>>>>>> totally possible that one more iteration just blows past the limit.
>>>>>
>>>>> So, does it mean that the verifying complexity grows exponentially 
>>>>> with increasing the number of loop iterations (options parsed)?
>>>>
>>>> Depending on verification time pruning results, it is possible 
>>>> slightly increase number of branches could result quite some (2x, 
>>>> 4x, etc.) of
>>>> to-be-verified dynamic instructions.
>>>
>>> Is it at least theoretically possible to make this coefficient below 
>>> 2x? I.e. write a loop, so that adding another iteration will not 
>>> double the number of verified instructions, but will have a smaller 
>>> increase?
>>>
>>> If that's not possible, then it looks like BPF can't have loops 
>>> bigger than ~19 iterations (2^20 > 1M), and this function is not 
>>> implementable in BPF.
>>
>> This is the worst case. As I mentioned pruning plays a huge role in 
>> verification. Effective pruning can add little increase of dynamic 
>> instructions say from 19 iterations to 20 iterations. But we have
>> to look at verifier log to find out whether pruning is less effective or
>> something else... Based on my experience, in most cases, pruning is
>> quite effective. But occasionally it is not... You can look at
>> verifier.c file to roughly understand how pruning work.
>>
>> Not sure whether in this case it is due to less effective pruning or 
>> inherently we just have to go through all these dynamic instructions 
>> for verification.
>>
>>>
>>>>>
>>>>> Is it a good enough reason to keep this code as a BPF helper, 
>>>>> rather than trying to fit it into the BPF program?
>>>>
>>>> Another option is to use global function, which is verified separately
>>>> from the main bpf program.
>>>
>>> Simply removing __always_inline didn't change anything. Do I need to 
>>> make any other changes? Will it make sense to call a global function 
>>> in a loop, i.e. will it increase chances to pass the verifier?
>>
>> global function cannot be static function. You can try
>> either global function inside the loop or global function
>> containing the loop. It probably more effective to put loops
>> inside the global function. You have to do some experiments
>> to see which one is better.
> 
> Sorry for a probably noob question, but how can I pass data_end to a 
> global function? I'm getting this error:
> 
> Validating cookie_init_timestamp_raw() func#1...
> arg#4 reference type('UNKNOWN ') size cannot be determined: -22
> processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 
> peak_states 0 mark_read 0
> 
> When I removed data_end, I got another one:
> 
> ; opcode = ptr[0];
> 969: (71) r8 = *(u8 *)(r0 +0)
>   R0=mem(id=0,ref_obj_id=0,off=20,imm=0) 
> R1=mem(id=0,ref_obj_id=0,off=0,umin_value=4,umax_value=60,var_off=(0x0; 
> 0x3f),s32_min_value=0,s32_max_value=63,u32_max_value=63)
>   R2=invP0 R3=invP0 R4=mem_or_null(id=6,ref_obj_id=0,off=0,imm=0) 
> R5=invP0 R6=mem_or_null(id=5,ref_obj_id=0,off=0,imm=0) 
> R7=mem(id=0,ref_obj_id=0,off=0,imm=0) R10=fp0 fp
> -8=00000000 fp-16=invP15
> invalid access to memory, mem_size=20 off=20 size=1
> R0 min value is outside of the allowed memory range
> processed 20 insns (limit 1000000) max_states_per_insn 0 total_states 2 
> peak_states 2 mark_read 1
> 
> It looks like pointers to the context aren't supported:
> 
> https://www.spinics.net/lists/bpf/msg34907.html 
> 
>  > test_global_func11 - check that CTX pointer cannot be passed
> 
> What is the standard way to pass packet data to a global function?

Since global function is separately verified, you need to pass the 'ctx' 
to the global function and do the 'data_end' check again in the global
function. This will incur some packet re-parsing overhead similar to
tail calls.

> 
> Thanks,
> Max
> 
>>>
>>>>>
>>>>>>
>>>>>>> If you apply this tiny change, it fails the verifier after about 
>>>>>>> 3 hours:
>>>>>>>
>>>> [...]
>>>
> 
