Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A562D2183
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgLHDgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:36:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgLHDgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:36:22 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B83P7P5028468;
        Mon, 7 Dec 2020 19:35:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BhxjhvS8kR3b1S/qKCtNJxaJpTiyOeHxrOwnHkLa9eI=;
 b=HO5RjOqsHN9OKs/1CtTzecyq1xQBEr7+mrf2y2JZrt7OccE1bjJ2hG4h06drF6Sa0FIc
 6I++wIoTtSONFenR5opJVtgplKPy/g1yOAMkb9QLZx9oa7QPM0oXyRs8QrrvpkPm1rDZ
 0rGEg/T1rG6fZS7+g5K9WujfYEs8y0dtIes= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 358u4ukmnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Dec 2020 19:35:29 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 19:35:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFwnrBMF3mLNTFSSRuR8ku++BtKQoffqGEzmRN385uEqMKMNfdH4tlu4a+NllXqBQVk+3dWPOEiq/yntC00BGi2Nu5SglAwESNImMgmRBGFPeAxiUh8jc44bAb13AcSm+OrP7eNg7wHYhBqZ+tWizHYVCYlMomi1fEDkvmo9c6IDwIqft9G9U+0ya5ymd/y83gDsd1KszMu1azQhsgSjXOn6TkbpAFZ9DFfuGgGBtoPosNL6QYimqHzMmvQNEPYmh0SbYtu/wRrHXVtqqjEUrHnJskn1bHpMhxwjKbrlmbH9AfSxFmIxUVf4sIvRK8GcgxKAE/UnEndM+4jv2Qr4ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhxjhvS8kR3b1S/qKCtNJxaJpTiyOeHxrOwnHkLa9eI=;
 b=iJQBCO2zUNa0ZkCampT7Owt4+bT/WO7ziEHyrLItjyuyjB23VAtzVU2rfDA3XPkKPc3mkl8/6j6HoDItN/sFElRGOjPCHUeP8v6CdFG62cGL7fTpo1yufJHK011u7lj5aoNgQXJ+RPhF1ZBYzljcsXQuTrbq92gZhFQBS0YmQg4wk+OQL+ZY4hWZXzfEa8ocqV6VKuvpn9yHWHgZzkCUyzBCq/49iH7Hfp+9ImcQGW5ptfANVLWBlpmjuq8HnrjgUgnEdfFANHBB9r5TPIMocvvds/EIGn441sszMbA1M4QpTMeaLYXrs5sAbwm1JkwyTO/gLqcSI0uhH34C+hJmxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhxjhvS8kR3b1S/qKCtNJxaJpTiyOeHxrOwnHkLa9eI=;
 b=Obl+uDcGvv8gWi+e07FIT7n6ve3FPpBOUQHdhPgB05hpdawGAzUjGlEk7J34zpVXRPgDmAExPEZA7cJlVH7LRUAJpq/NbvGC4PbgEDfB4zOQi712WOp/oQoDvmj1wX8neAaO2mbSXmwCP/h+DtT+QjUQMn337qaosM3c31ZXCyw=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by SJ0PR15MB4201.namprd15.prod.outlook.com (2603:10b6:a03:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Tue, 8 Dec
 2020 03:35:26 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 03:35:26 +0000
Subject: Re: [PATCH bpf] tools/bpftool: fix PID fetching with a lot of results
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20201204232002.3589803-1-andrii@kernel.org>
 <ea2478fc-45c4-6480-bba5-a956abf54f13@fb.com>
 <CAEf4BzbE8ddJqj-uwJSJ19vWhgOpd-hbK34+JhdRo1PX-omY_w@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8f4f8464-2b90-c5f1-0a97-3ff5743ea4d4@fb.com>
Date:   Mon, 7 Dec 2020 19:35:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <CAEf4BzbE8ddJqj-uwJSJ19vWhgOpd-hbK34+JhdRo1PX-omY_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4c73]
X-ClientProxiedBy: MWHPR20CA0040.namprd20.prod.outlook.com
 (2603:10b6:300:ed::26) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::113f] (2620:10d:c090:400::5:4c73) by MWHPR20CA0040.namprd20.prod.outlook.com (2603:10b6:300:ed::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 03:35:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa87e080-129e-4e4d-e2cb-08d89b2a4d74
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4201:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4201B256266AF49ED300DD81D3CD0@SJ0PR15MB4201.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5w3A6sfVt8QWYjlaYEVyGHPrg3kH2a5PPZpm+l4+PCLj41V/35w65HP1hKi5ke7cMRYAGHxfcDw8ZMydtuzRpEbFrQauPJzb9wetatYLuyMF7duCl0ehv9o3Q2OWJNg4s1jBTtRbXlcCHVWfuZZq762NN4E+PAtz109tXVW9HSig30vraWHjF6wLwYH23G0KZYnOllqYkqMlOD9h3NHvq/yidAyfflPCryNR960f96hrEwwFB6IUx7gbSpubgVa9NIUacyyEvFpsAhq/ezjo6ry2PL5n53zURG89MM06M8zJ1UnBHvYt3setNC81Ecdka0/592ff3Hk6qxoTs4k/ldjarzidszkzNEYzs3XyVE++uMD9ERaCk2YQeGfpVGhT/6DoqZ4lW7xZfJfz8uttC9R4aYeP3Bm3ifWYGwN2Mi0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39860400002)(346002)(136003)(2616005)(16526019)(66946007)(52116002)(31686004)(6916009)(83380400001)(186003)(31696002)(478600001)(86362001)(316002)(53546011)(5660300002)(4326008)(8936002)(66476007)(66556008)(54906003)(36756003)(8676002)(6486002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S3BPWjVOdGdPOEgzY1pLbm9QL3VRTkRuUWFiRFZmZFpoZXRCTVhLeFV1UmQ1?=
 =?utf-8?B?V2FjaVN4ZkZtS0h0OXV4MmpnZEhSVFQ0ZG1QeTNDdndOd2hwZ2V6TFJXeGk2?=
 =?utf-8?B?ZmJpMVAyYmNzTzdMWE9KR2hzc3Q0WDRYUlN1Zy9iTHVXN0k5TTRPQmJENy9E?=
 =?utf-8?B?alE3TXIxUHpZSHIvSWZ5c0IrYkx6SVkwcnA4UGxNckMvTWpzNTlkbkQvckJ2?=
 =?utf-8?B?a0VZSDcrdDR3ZXhxeFJGNWphSWVzM285Z2Q5SFJvMXYxTEwxeW1WeGNwNFF1?=
 =?utf-8?B?SmFWZ3p1UFBwbXprYmM2Q1V4TGRmVkpDQkVZQ3BkbFhmL3JhWFhCRWU5Y2RH?=
 =?utf-8?B?c2thYWZncnZXdGpYT1RXWmRUTFprQlJlTUZhWkJRaDhxdzRITmZVenMvTHcz?=
 =?utf-8?B?QW1RU09UeEMzWk52R1kxWkN1dDFWZjlYd2hudlVwQzBENVE4bFJoeURNZ2cr?=
 =?utf-8?B?TEtxUGd2bGRiZ282WHVCWGRqVU9zN0E0M1EzaC9WR2MxcWM3Y2RyZzdkV0xs?=
 =?utf-8?B?SXFTVWZMcU91RDFZQVZrU3FodUkrT3NUcW1UdlpPUjMvc09ZZ0xOL3Y2YlZP?=
 =?utf-8?B?VkxjRUNOcE5mdmhZSmQ4ajI3NnJ3QjVFZGRGdEZURnp2RGdQY2VaNGRKUlZj?=
 =?utf-8?B?RmI2dXZFaFlJaVZ6WFUwZ2xibVU4M2FidzI2VDZnT29oVEhIVjJrR3BYajNx?=
 =?utf-8?B?RWNrY1QwKzk4MnhnOGtoQjRKNk9uZmpkTEU4Mnd0UnBPbTI2ZVVPMDBjNDJv?=
 =?utf-8?B?c3RTZzN3STcvZEVCQkFJcDdNZ0Nua0JJdTdlSmZLNkUvYXp3RUJNQ1JEZUZ0?=
 =?utf-8?B?TDcxQUlsa3lpM2l5RWJLSGtwRC9Xb2F1TW9sNWNRRExJdS9IZWNGaGZnR0ZS?=
 =?utf-8?B?dUZCR09Dc2Z4emwvb21PTytiL2JaTmRWSGRXQTVrdjdvUDYvdmVtaGI5UVky?=
 =?utf-8?B?Z0N0NDlGdXpJdHIrWXl1TXp4bHpnTXNQT1p5dFR4Wm5rak53c3NNTk1zUC9C?=
 =?utf-8?B?UTJYYUR1MXpFWjB4QjlpNDNOeHpUSnpWazFteFAvN1hyc2NNTnRPZU9USGl2?=
 =?utf-8?B?OTJPQnJ2Q3RCb1F2cDl0MlIxYkhjaEIrM3doNHFDVFYvekgvNDEzNUdGL2ow?=
 =?utf-8?B?cHpmZG9CNnZoSmpKckVvdU9FSm9zQ1JHYUJhRHlJVFJDdFg1SDhyeHN3dVlZ?=
 =?utf-8?B?UGVKSy9CY3poRDBSRTRhaXNEaFdEUEJUTGpWT1ZKT1lkOTk5dnc5Rlh2d21n?=
 =?utf-8?B?L1h0YUdyM1VMalJpQ2tXS01wOU5la2JIQjlJRmM3dHRVN1krRzZKalZ4cm1N?=
 =?utf-8?B?L3llblNIOWNCRHRkQTY0enc0YU1zdE1vWENkckQ1UmMxQTZVdFlBcUZSVHBt?=
 =?utf-8?B?Rk53UTFsaSt1c1E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 03:35:26.1883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: aa87e080-129e-4e4d-e2cb-08d89b2a4d74
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmB3iwB7DbKv2wC7WFw7SMP1uzCaa/U7n0juehMFyNGkedWAU9X8ZDLzsYabMb77
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4201
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_19:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012080020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/20 6:55 PM, Andrii Nakryiko wrote:
> On Sat, Dec 5, 2020 at 11:11 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 12/4/20 3:20 PM, Andrii Nakryiko wrote:
>>> In case of having so many PID results that they don't fit into a singe page
>>> (4096) bytes, bpftool will erroneously conclude that it got corrupted data due
>>> to 4096 not being a multiple of struct pid_iter_entry, so the last entry will
>>> be partially truncated. Fix this by sizing the buffer to fit exactly N entries
>>> with no truncation in the middle of record.
>>>
>>> Fixes: d53dee3fe013 ("tools/bpftool: Show info for processes holding BPF map/prog/link/btf FDs")
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>
>> Ack with one nit below.
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
>>
>>> ---
>>>    tools/bpf/bpftool/pids.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
>>> index df7d8ec76036..477e55d59c34 100644
>>> --- a/tools/bpf/bpftool/pids.c
>>> +++ b/tools/bpf/bpftool/pids.c
>>> @@ -89,9 +89,9 @@ libbpf_print_none(__maybe_unused enum libbpf_print_level level,
>>>
>>>    int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
>>>    {
>>> -     char buf[4096];
>>> -     struct pid_iter_bpf *skel;
>>>        struct pid_iter_entry *e;
>>> +     char buf[4096 / sizeof(*e) * sizeof(*e)];
>>> +     struct pid_iter_bpf *skel;
>>
>> No need to move "struct pid_iter_bpf *skel", right?
> 
> It's actually a move of `struct pid_iter_entry *e;` in from of char
> buf[], to be able to use sizeof(*e) instead of sizeof(struct
> pid_iter_bpf). It's just that diff tool didn't catch this properly :)

Indeed. Looking at the final code, no unnecessary code churn.

> 
>>
>>>        int err, ret, fd = -1, i;
>>>        libbpf_print_fn_t default_print;
>>>
>>>
