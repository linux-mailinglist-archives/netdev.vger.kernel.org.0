Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DBF2DC689
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgLPScT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:32:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20962 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730957AbgLPScS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:32:18 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BGIFW58027551;
        Wed, 16 Dec 2020 10:31:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wF09v+a+fcab9Sj5wcMYM7yhjzg9UyvOBkxX+jroEQU=;
 b=MaIl3FLsE7f7vyyg5AiqYfLv7EU0VpImyvpQvb3SgXL5KdphzMTnWroiRdJlSHedOTU/
 5Y/m9r+VV5IIbm5/8Q88voaWXSldugOFyLSUyjvr37q+52Aq96q4ZAEQnJTNPFhKQN3+
 T6srTjIThU1jY73GmmaP5WsHuo4Rf5ifesg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35f9ykbpgm-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 10:31:23 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 10:31:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIbEFHR4BXebxo11ZEN19evYX4xww8TiJXVF6M8fWsAa1edyam2btdXLWcyCXPRUAJ9HZYl6InOyT7S+l0sN2FegwMvY93PEzn4Y6xZ+5n8KSWUYk8h4xV/AIV1OA9zsM1tFYmAJXyvCNYQmufS0hzqvvgAYQfuKScleXQn9I15xkAD8Nv5pi4MKiSyJhEdEPL7kIfWMQ6JnLsVW9WLYU/Oky+Wcj1tajNss2eocd9PUVY7sYvsp9RVM5L946BlONtm16Qpqec4oAY231JFK6BOF6zHgHePJs6c6bFTtzQ0AYNN2X2J154xaMCzAxiXRNSR3TqO7JFIVxo/GVHoz/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wF09v+a+fcab9Sj5wcMYM7yhjzg9UyvOBkxX+jroEQU=;
 b=Oq1dOe7HhvL6aTJtFGZaRsWhAP3lVwWuOdWzVKOpcDMALGtpIJ9AXx16C/PfsQqGupc8SMOj74K/j8ZG763KyoOYpyyTytm5jHkulT1e2PpuhO+o738il+SLXLvhz4OWRwTe8I0dz/3OUsoUEvsJn/XEgQgAUKy19XEj03iDYJgSacGs6Lf+9x/0j58Ttl1I/cmmRX2b7Cg7lGfpOTdy4J0hnX8zeD+ElnAuKHVxF/JBcGV50JPvMWqmvRdU9IL+zt40asqgwL7ttum/bE3nyRsmypTh0iAMsDjbj+eHdrAMBIzybHEqY5SlXVwrz96lSexeyBy42HAIWUPtBOjo9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wF09v+a+fcab9Sj5wcMYM7yhjzg9UyvOBkxX+jroEQU=;
 b=JjmqLVd87bV7/KHVzo7Nv8M+2z0xVvWtrdMkCwNemq57VvxkvHUsTKAgPaWhDYPpgUARbqQ8/1QTWo1fSnP7P8PtI76DHhjx6UCzCAfghAOmrhawqSIhc2TkvTdh/IEhkxDxkvaYUjJL+3GoaL4Lk+Vwgvcbkgn86S8CZ7cWoDk=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Wed, 16 Dec
 2020 18:31:10 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 18:31:10 +0000
Subject: Re: [PATCH v2 bpf-next 0/4] introduce bpf_iter for task_vma
To:     Song Liu <songliubraving@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <7032f6a9-ec51-51b0-8981-bdfda1aad5b6@fb.com>
 <192C599B-7ED6-47A5-BF83-FA25655EAE88@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5c68adc8-6af6-718a-f75a-bcc46f63c086@fb.com>
Date:   Wed, 16 Dec 2020 10:31:07 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <192C599B-7ED6-47A5-BF83-FA25655EAE88@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4fea]
X-ClientProxiedBy: MWHPR1601CA0004.namprd16.prod.outlook.com
 (2603:10b6:300:da::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::12e6] (2620:10d:c090:400::5:4fea) by MWHPR1601CA0004.namprd16.prod.outlook.com (2603:10b6:300:da::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 18:31:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09cc8e3b-ecc4-453a-e53a-08d8a1f0c29f
X-MS-TrafficTypeDiagnostic: BYAPR15MB4119:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4119DEB3F2BE9EB73923533AD3C50@BYAPR15MB4119.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLvcj+qcjE2TW3TUHi6bw5mUzDoLBMW5d6lfrjBzd2b3Px7ssDkjGI76W45l2yLg1EKcUuChELPrXbg7r4PO9MiamNcjXi/6SkS5RaXcbFH+N7ExsSUPAR265vs0R5lBSKVmATgsys2vhLXrai6WWN687BpSoFsDAuI00JQUhSv4vnX3KQ0kdEylST2QaNFS08DPlfLYCyR8qYb1GQpCtrY3pTQscUxR+i0KQXnRa75b9zRBzSq2DfFuYJoYCspFT3cUr3OYLQ0l5CMQ7ltOSLV3GsTaCHNEHX6yT+5JXKRV99AcuzLFmwCBYXBJT03cqTra5EKM5ot2uQZTcibZmhXsU4Z2CRxoSsKDbCdK3ja/w7wnNauEsl+tN9WF62TgYbK3Lh9NIarC02pYFojh47QdbEIpGSi+ES6mbeUC8Yo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(366004)(396003)(31696002)(8936002)(66946007)(66556008)(2906002)(86362001)(36756003)(66476007)(478600001)(5660300002)(53546011)(54906003)(31686004)(16526019)(2616005)(4326008)(6636002)(316002)(52116002)(6862004)(8676002)(37006003)(186003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MVF3WC81OHE0NGNLR010NEtOd3hqZ1dReVhiak9ma2lqNWZnQTdscEpsbHl3?=
 =?utf-8?B?UnJrZU4zSWQ1N20xWXVvWENFRmZFdmdCVS9pYnZ6UTBGRzJCWTVXdjVpeDlX?=
 =?utf-8?B?WGM5eVFHMFJRT0toWXJ5NlB3K0Q2NmlabUV2N1k1aVMxSG9jRklvVldVM0t6?=
 =?utf-8?B?aEVKM2hWWDNVM3pSYjM2NWJ4Wi9xU25MQzdpUXhRRVYySnJhT0dxVk1CcUEw?=
 =?utf-8?B?cllqWmFNb3Q3MXJQSzFFbGQrOHBrSy9MVDZKU1Z4Z2VyVlRSN1h5b2VWazY5?=
 =?utf-8?B?L2ZDamIzQTcxS29GZFJWSjF6c3ZKZktCT2VhQ1FMcEF4dVBlRTA2em96ems0?=
 =?utf-8?B?QkIycHNFd2p1THl6RnY0dGJJb2UzN2IxQnEzcTZ2c2FXOG1FejQxU1FZOGZR?=
 =?utf-8?B?KzBVa3NiUEdjTk1RVkNxV2UxK2JhNVVGN2sxQktvMVhyZjNsU1FnNHJKNFY4?=
 =?utf-8?B?ME5pakd0Q1I2b21SQU9ydXczYzQ2U09IT011dUFvdjhSVVNPSUJ6d1o5WS8z?=
 =?utf-8?B?SmROdldkQlM0NzQ1RWpYNnVwUnZIeElyS0lGc3pqZVliOTIrdVhhSG91RXM1?=
 =?utf-8?B?UUcvUERCZmZlcXd0UEd0S01LVWxoem00RHcrYWxOejR4YkF0ejdvbVpWRm9M?=
 =?utf-8?B?VWl1RFBrRkNJazkvSnFWaU1YUUNDYjBZdW9Yamhaakl5a2VBOENySHJjdDVR?=
 =?utf-8?B?R08zUGdWT01oL0N6NGNvZktvQmZjVjlHZ0dXajk4dXZFY252eUlzaUFaeHFM?=
 =?utf-8?B?TEtiWVJ6WXNCWjBYTDM0THhaL3M2M0VzZkE3Nlo1SWU5TW1LLzZUbk1TVDkw?=
 =?utf-8?B?TVphM1N0NzhJbTJXb2h4OU5kWnVJRFAxcHd5WmNvekUyQWIyQStnNlFmQkZP?=
 =?utf-8?B?LzlPeWhhdk5Rb3ByWTRyNnZWR1JPTlg5MGlHSVFGUmQ1VnNYSTlTK0lmUFN0?=
 =?utf-8?B?Mk5qT1BhK05ubkFGWmw5TEN1YzRBajB5M0dkQnpmc3BSTEpxa2hKR3YwNzlY?=
 =?utf-8?B?TWNnbWxOZnE5UUg5TmYzalhXUUdLRm0yRXVHQ1Ezc2drOVhiWWtZUW5tbXQw?=
 =?utf-8?B?NWVDcE5mSkJRQW82T3ZxU291WEo0SjB1NlY4ZDhhUTFuamZkN09NQkZJY3ov?=
 =?utf-8?B?K2I4aWFoR2Q5anRYUmk5LzE0MkJDekxSVnpLVUtCYjJTUllSaGNJRERYSVJK?=
 =?utf-8?B?SWZHZnUrY01uRDNoaG1PdThMcnhhbVhNV3dWZUNxaFNtRnprbkljZ2ZRYytp?=
 =?utf-8?B?OC9DZUIyL3JyVGsyZ2tqSk5qQU5Eb3VETmNCMWc4TWJkN3dINzBtSkVmd3di?=
 =?utf-8?B?aWVpN01zSkVRMW1mRmFQNFJoMkZBQ2EweWlJM3UyOXZkWUtMeUxTeHkxQXpE?=
 =?utf-8?B?Vi9JdlREVEV2UlE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 18:31:10.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 09cc8e3b-ecc4-453a-e53a-08d8a1f0c29f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJmNorpDKLp+22/sq/KgaUaWD1VilNRCBOqy+TGdEmWAKrjFuFCI86UwfHIUY/zi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4119
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_07:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/20 9:35 AM, Song Liu wrote:
> 
> 
>> On Dec 16, 2020, at 9:00 AM, Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 12/15/20 3:36 PM, Song Liu wrote:
>>> This set introduces bpf_iter for task_vma, which can be used to generate
>>> information similar to /proc/pid/maps or /proc/pid/smaps. Patch 4/4 adds
>>
>> I did not see an example for /proc/pid/smaps. It would be good if you can cover smaps as well since it is used by a lot of people.
> 
> smaps is tricky, as it contains a lot of information, and some of these information
> require architecture and configuration specific logic, e.g., page table structure.
> To really mimic smaps, we will probably need a helper for smap_gather_stats().
> However, I don't think that's really necessary. I think task_vma iterator is most
> useful in gathering information that are not presented in smaps. For example, if a
> vma covers mixed 2MB pages and 4kB pages, smaps won't show which address ranges are
> backed by 2MB pages.

Let us remove "/proc/pid/smaps" from cover letter description then.
Could you add the above information to the patch #1 (and possibly cover 
letter as well) of the series? This can serve one of reasons why we
introduce task_vma iter. Maybe you want to extend bpf programs to
cover this use case.

> 
> I have a test BPF program that parses 4-level x86 page table for huge pages. Since
> we need bounded-loop to parse the page table, the program won't work well for too
> big vma. We can probably add this program to samples/bpf/, but I think it is not
> a good fit for selftests.

This can be done later.

> 
> Thanks,
> Song
> 
