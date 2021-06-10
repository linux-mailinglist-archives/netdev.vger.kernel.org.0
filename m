Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD38A3A2ECB
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhFJO7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:59:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11398 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231528AbhFJO7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:59:03 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AErsb1026635;
        Thu, 10 Jun 2021 07:56:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KTlJKPvJMh8Y//qVmmm1Zzv1Yk8WRLUGfSYVsI6RbaU=;
 b=nZnDbMsKV19EgnbmutxJnbGrT1p2cXhKbGxfPXguigwjRJhisLCptQB917H3IFcVzvY8
 1j098TpGpOq7ZAbfH9afBG1yD5wW9JfKXRtqvi/FBtjCOH8hXna7memWZWFOwdx879A2
 +7/G/EiRIqPaBZK40tH9U8YbQzhnojgNfN4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 392wj38467-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Jun 2021 07:56:52 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 07:56:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMRYvZI4sROvlWlUo71UVip3b0YCCVDUam27w6YqoK83tRZOTIVR2kqM9DeZ342j0B/ttEBvVtp754kLf9NOQmPf9xV5I3DOrE++OHwqCF62AbCU1jWd9IyXoG530uqKrTHs3zCv0Shc/o8MZpeFJdzDTSirSLGAOrpM2pu2WchCDrihehEZdR0HX14LruJHWSJyPhzD/mNTLgUeDZDWc99bAksMXjO+eXFlQn2Tw98RVUYcl1rRFV6DGX5M6Cqwf2+cvd8Avo8l2Cs6XPizk2Yl3qIDkJkncztys38+cH9nef9casAsDDBieJlVmHXl+8Wjpanj+sgdYz3SniUA3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTlJKPvJMh8Y//qVmmm1Zzv1Yk8WRLUGfSYVsI6RbaU=;
 b=HmdtJ7Hp9gDRGmk8bd6F2bZngrpn1SmY44XuAkLqcUUL8nRQYZXNav7LQil/obCrNjhoq9z1yTmhTzjrG9orUOT8eUCBUwy52YkPT2KOb4FIi0md8PdHPmtr/SvahkI0M1v1YujJ05tCC5/KGCmDbdTklI5QE56Bsx4z8yxq50VxG9iaTfRgA4vG3MvkXgEqD1XhSP9tzPevOsNmkWAoYFJrXPVg7RWz6dr0u2+z6wmN7oIJIhrfOn2jLR0gStJVDMS1JchW/4v+ECY/AEwb+97Qi/jOXalIUZnfpfrwtAETRY0tWAeolSjsxo+TMoMSva5S9v6osuf1a1CMRh9MgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2256.namprd15.prod.outlook.com (2603:10b6:805:1b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 14:56:50 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 14:56:50 +0000
Subject: Re: [PATCH bpf-next v1 00/10] bpfilter
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <davem@davemloft.net>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>, <rdna@fb.com>
References: <20210603101425.560384-1-me@ubique.spb.ru>
 <4dd3feeb-8b4a-0bdb-683e-c5c5643b1195@fb.com>
 <20210610133655.d25say2ialzhtdhq@amnesia>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c72bac57-84a0-ac4c-8bd8-08758715118e@fb.com>
Date:   Thu, 10 Jun 2021 07:56:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210610133655.d25say2ialzhtdhq@amnesia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:dbe5]
X-ClientProxiedBy: SJ0PR05CA0181.namprd05.prod.outlook.com
 (2603:10b6:a03:330::6) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:dbe5) by SJ0PR05CA0181.namprd05.prod.outlook.com (2603:10b6:a03:330::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 14:56:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f33fcb13-e75d-410c-a00d-08d92c1ff9f3
X-MS-TrafficTypeDiagnostic: SN6PR15MB2256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB22568B6862707C7086670407D3359@SN6PR15MB2256.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTLh4p+BBZMvUb4Wx0aEJ8rQRrP3kjLu0mlfu97y7lWP/HHJKLd9qmVru+Nv6lAECMjzf3XFK+BTcn4+N8smYsWKqCk9ImaSb1/vLv1hq+tPCzq9+brkRa/lx+b5vUzz0a1cIdQxfUKFuTclJstYsUeL8o8BFs9N7NCcmRtvTjv6w+egBpja0SipP94tn1a/6ZLHaYo4pFF4EA+jtrN9S3l3LdjhxlFge5gsXc5hs6/enXW4BeJ6zxeXuOu6tA1TaxTVMKXYwt4nCQ6aIdRuC8mRhAfR+v/7Zkx4fKsQ35KkW9Nj7dngilSSb7x2++NbrI/V0Dj55FWw7aEwvy+MHCb1yg+jPBLuc0Q8ugDr9H3aYQKjXLoE7Q9rRulDPK7UdKPbNPoNmwaXQL7UISUnNfaoKr9CcJqbw+i+8rFbH6O7pjyk9IGFMrVQXbxQFt/O4FJyO6LeXPSJ/TN8drAwIO92isGKhKMcivThyKpB0UlhQXJSlC3QiXi40XENMCnvAxJMWW+GHQcHI9PtuhSDfI2grWsHInXgpSGl/g10ziSNy0c5Dt36GE5CvRAQyzdrEqWXiY6qr+qA798QxLXeV7AhZcY68c+mvQ4eko/VXjKbV+0zjOwYQli3qmW/Eo+6V9LJlvgAQRd/10NShO2yPchubRCyjA2UU1p4ZJHIVtka3p+ODE8qxW5E5NOxUYmj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(36756003)(66476007)(66946007)(66556008)(83380400001)(31686004)(316002)(6916009)(2616005)(8676002)(186003)(6486002)(86362001)(16526019)(53546011)(4326008)(478600001)(31696002)(5660300002)(52116002)(38100700002)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3NJZjV0VFlld29tWlhmRUVLZUx5a2tRWGxhQ1dtaEE0NVFxMXNlbTFrVDhP?=
 =?utf-8?B?UkpnSHZoNGlZMnZqSDkxaEMxd2x3cmpRTmVsdWQ1MGplMkc0RzlFYzlnYXEw?=
 =?utf-8?B?ZW9sYUNHQkZDem5mTjJKWUZnZVRyMWhyaW5OUkpySk52RTRxbmZoMHVtVVhz?=
 =?utf-8?B?ZDF6ZnQ2Z0xwSytnRlBUUFFueUVtT0M2YUQ4NUZYM1BTSXY5MzJVR3JlSERP?=
 =?utf-8?B?QW80MjBJZUhTS1RmbjUxL0hSVE8wTGZpTEtVZkVzOEY1TWpreGVkOXRKTDhv?=
 =?utf-8?B?dU9HbjJlZnJRYTJJcWVieXFwRktWR2ozTHUxckRhYWFBRUJCaDh0M2ZSaFhi?=
 =?utf-8?B?ZEY4RzgwUTVZbUkrTnZXVCtPOStjdzZtdmgyTU4wOGV1SFJaWXVOamhQRHl3?=
 =?utf-8?B?V3Z3aHFnZ0hlQjNvZDcxY3paQXJwajNhSk9PL0ZIQ0w5QitVYXBqbGo2SGlz?=
 =?utf-8?B?NjMwNkJFODRMeWdZSStrMEZvQllPNExhMG5PczM4MjdhTUU0czBIY1JjQmJn?=
 =?utf-8?B?S05TZFdQSXV4M1NiblRzeXo2Y1IraGtobkNFUzlFSXB6bDdiNmJMRE8yNzNZ?=
 =?utf-8?B?TzNxRDZZQm5MMUJBSlR4Uk8zTFVQMXBiWTNzTmxQUTI1Q0h2ZHBnNzZvSGdR?=
 =?utf-8?B?SlJwYUw0TnJVeGJkdnp5aFhxdXg5Y0FOWHpQckRXOFQzMzZSMlRwZ20zZGEx?=
 =?utf-8?B?TFFJb0FFRDRtMWp0ZU9sQkwyMzJyRi84VHV3cWVGSWhHSHdoellJdHNLQ2Rp?=
 =?utf-8?B?RUNLb0NPTkJjdFBHMC92MnFvdmhWVjBMeHdCMkw1bUhKV21uMG1xUk11akVz?=
 =?utf-8?B?REtDeVhPekg3Z3dFanBtNm9FemVGUFVHT1Y4ZjU2WmVSMVVZTlhXeDdPZ3RT?=
 =?utf-8?B?MVprTGh6elR3bG9PQVhlQkJWNi9BQTR1d3B1eDVGNTZPSThyWWx4OTY4OFZQ?=
 =?utf-8?B?YjVsM1o3WTAxWUNVemtnY0VZc21YbFZiYVg2M28zQ0c1TjNZSjVuLzd4WW1h?=
 =?utf-8?B?NWRnSUtLbDRRR1V3NytJa1prZUp2WkNLZktzQVhBYVV4VkNxTXBXMTF3NXRu?=
 =?utf-8?B?YnEwaXVCRmhjSGR3VmFKQWREcHlTUEdlOVUrRTRNYmNZd0tUZklVcnlGRlV4?=
 =?utf-8?B?aXdSOE1qSHdwL3BGUGpjSlp0L214U25ubzcvODNGMW1UL092aHo4eVdjU1VQ?=
 =?utf-8?B?ZCsxdHFIK0FZbURmWkhrZFJrdlpvYzRTUVkxSm80QUxWQ01YUkRvYnRaYlZV?=
 =?utf-8?B?SVM2WEVST1pKWEQwL3MvV04wWTZJemVCdE5OM09QemVFQy9SMHV0d3ZRaUMy?=
 =?utf-8?B?MmQ1cjRjMXRyaXVwbDRCQmFyYTQ4OUhDc2ttRnNsd1o4RCtRZDRSWWVNSmpy?=
 =?utf-8?B?NUxJY0dXSnJwbmpIc1lXRUM1aTdPV29jdDJIcVRDalpqekEwTmlJay95OUtq?=
 =?utf-8?B?T0g1R1RDc2hQbUViR0M1QjJqeUg0OFRiWjFnN0JxZVJiNTMrTENyR1Zob05W?=
 =?utf-8?B?R3haOHdUWmZhV1FwTUNJaU9PczBsQk1OZnJEOXdkWDlMUHovSUZiTG1COC8w?=
 =?utf-8?B?RzJzWUhuc01nSjQyM2tIQ0Q5NmRXWUVlR0hOVlpuQWdpOUxrYjZQMW0vOHJ4?=
 =?utf-8?B?N2JWa21EZ2lCZ2t3TTU2cUhwamJYMWphSXBGVjA5YUZBaHEwbEVkZVJjaUVh?=
 =?utf-8?B?K1M0dDNvN0JITnBnUWtSTmplRlFVS1hvaW9ORzZoTjBxMlVtd1FEYzRmUlJ4?=
 =?utf-8?B?MDFXd1JsWk02MzA3b202WEc2Z25zQStST214YkdCQUFVbDJTWnhVdFpkT0hT?=
 =?utf-8?Q?CfK00w/1407BVM3UUdoG/YFxKuka+htnnyY4U=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f33fcb13-e75d-410c-a00d-08d92c1ff9f3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 14:56:50.0296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjU9t1hhhs3hjtkgmPSGdtMPOI/+s9fSzl+8nzo+nYuwhVssMfB3KujC1a1RVHsJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2256
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: PVKkt-_xnEE8Cbcb5xGE3H57iKO4qcvi
X-Proofpoint-ORIG-GUID: PVKkt-_xnEE8Cbcb5xGE3H57iKO4qcvi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_10:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106100096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/21 6:36 AM, Dmitrii Banshchikov wrote:
> On Wed, Jun 09, 2021 at 05:50:13PM -0700, Yonghong Song wrote:
>>
>>
>> On 6/3/21 3:14 AM, Dmitrii Banshchikov wrote:
>>> The patchset is based on the patches from David S. Miller [1] and
>>> Daniel Borkmann [2].
>>>
>>> The main goal of the patchset is to prepare bpfilter for
>>> iptables' configuration blob parsing and code generation.
>>>
>>> The patchset introduces data structures and code for matches,
>>> targets, rules and tables.
>>>
>>> The current version misses handling of counters. Postpone its
>>> implementation until the code generation phase as it's not clear
>>> yet how to better handle them.
>>>
>>> Beside that there is no support of net namespaces at all.
>>>
>>> In the next iteration basic code generation shall be introduced.
>>>
>>> The rough plan for the code generation.
>>>
>>> It seems reasonable to assume that the first rules should cover
>>> most of the packet flow.  This is why they are critical from the
>>> performance point of view.  At the same time number of user
>>> defined rules might be pretty large. Also there is a limit on
>>> size and complexity of a BPF program introduced by the verifier.
>>>
>>> There are two approaches how to handle iptables' rules in
>>> generated BPF programs.
>>>
>>> The first approach is to generate a BPF program that is an
>>> equivalent to a set of rules on a rule by rule basis. This
>>> approach should give the best performance. The drawback is the
>>> limitation from the verifier on size and complexity of BPF
>>> program.
>>>
>>> The second approach is to use an internal representation of rules
>>> stored in a BPF map and use bpf_for_each_map_elem() helper to
>>> iterate over them. In this case the helper's callback is a BPF
>>> function that is able to process any valid rule.
>>>
>>> Combination of the two approaches should give most of the
>>> benefits - a heuristic should help to select a small subset of
>>> the rules for code generation on a rule by rule basis. All other
>>> rules are cold and it should be possible to store them in an
>>> internal form in a BPF map. The rules will be handled by
>>> bpf_for_each_map_elem().  This should remove the limit on the
>>> number of supported rules.
>>
>> Agree. A bpf program inlines some hot rule handling and put
>> the rest in for_each_map_elem() sounds reasonable to me.
>>
>>>
>>> During development it was useful to use statically linked
>>> sanitizers in bpfilter usermode helper. Also it is possible to
>>> use fuzzers but it's not clear if it is worth adding them to the
>>> test infrastructure - because there are no other fuzzers under
>>> tools/testing/selftests currently.
>>>
>>> Patch 1 adds definitions of the used types.
>>> Patch 2 adds logging to bpfilter.
>>> Patch 3 adds bpfilter header to tools
>>> Patch 4 adds an associative map.
>>> Patches 5/6/7/8 add code for matches, targets, rules and table.
>>> Patch 9 handles hooked setsockopt(2) calls.
>>> Patch 10 uses prepared code in main().
>>>
>>> Here is an example:
>>> % dmesg  | tail -n 2
>>> [   23.636102] bpfilter: Loaded bpfilter_umh pid 181
>>> [   23.658529] bpfilter: started
>>> % /usr/sbin/iptables-legacy -L -n
>>
>> So this /usr/sbin/iptables-legacy is your iptables variant to
>> translate iptable command lines to BPFILTER_IPT_SO_*,
>> right? It could be good to provide a pointer to the source
>> or binary so people can give a try.
>>
>> I am not an expert in iptables. Reading codes, I kind of
>> can grasp the high-level ideas of the patch, but probably
>> Alexei or Daniel can review some details whether the
>> design is sufficient to be an iptable replacement.
>>
> 
> The goal of a complete iptables replacement is too ambigious for
> the moment - because existings hooks and helpers don't cover all
> required functionality.
> 
> A more achievable goal is to have something simple that could
> replace a significant part of use cases for filter table.
> 
> Having something simple that would work as a stateless firewall
> and provide some performance benefits is a good start. For more
> complex scenarios there is a safe fallback to the existing
> implementation.

Thanks for explanation. It would be good to put the above
into cover letter so reviewers/users can get a realistic
expectation.

> 
> 
>>
>>> Chain INPUT (policy ACCEPT)
>>> target     prot opt source               destination
>>>
>>> Chain FORWARD (policy ACCEPT)
>>> target     prot opt source               destination
>>>
>> [...]
> 
