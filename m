Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC1E2CFE12
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgLETMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:12:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59668 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725949AbgLETMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 14:12:30 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B5J5eJo014684;
        Sat, 5 Dec 2020 11:11:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6ZWe10QKpSjloTY91ubWMy8VqcxnW9w+d6Z2zEyOBpI=;
 b=ePx00GDBeYt+LRz7CIpEJ7TTaK39F3DEKJ0Q05sArhVzWh5g/Shcy6z+Gxq8C3Ct6TzB
 0egHxQKm1T1uAB/PQFr/N0xqSj16s2bdSEdWcVwCBuag2I8b5UqmzbFSMF7MeJOIoYCo
 aFovhjlnXBGKf3va8CpsUyeXmWkd85WFLQw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3588wns7ud-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 05 Dec 2020 11:11:36 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 5 Dec 2020 11:11:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ny8PXlb3UpUMX4YtsHkQJyIIiFK7Ju91AEuCBJdMcC2JPvAwRvtQo+b8Je8ye9RcZvU1I/CNsQY7OzTjp2UegPTvxvRT6P3YAIZJDk3ZPRBjjT9h9ny1PwMJ6CodxRnLT5IxgvK/KCvzAw1ujXQbELAbwdSJSK2XtWpAV8rLOU74oRPsJAXyi11bTHLHizZZ9TjMkuz8MUADGcl7JSFlN48HwDpLRRrPRjko+i62uB0lGGht9K1zoDgLAC1X7rDW2dAWzgK0ZpNeQwQiC8QZCKf/NfZXnwqozfJqEd7v4ZaH6oBpGOvXCpM3bYHo9qTVI6LeJE9o3tzHhaqUW19Cbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZWe10QKpSjloTY91ubWMy8VqcxnW9w+d6Z2zEyOBpI=;
 b=b5h7BhRwC7gEil1nz7VFuCb3TZ1L4wmKsLKdRVGBqME+6wyZruIw5GwAZYbl5aJgb+hK1BLu3ldR3Pbd+V2xRfdPVbqzpToOf+sulkgesQfDo9bre75alR0UALLTnqI9LaTxz8Rp/uL4XZbzZv2vAidMnKILuX2PH8T606C5s/D9wySFTsARtpx3VXPNOUoAro3XyoPJ1sY+K38wiNvniWgOF9dV6jNsHgkj6EPaWy6UxHAfUcYRusU+MVMYDURZbIje0uWBclTapu9CvsIIuVddH9VR4qNil7YSr68L3nHJLum2b6UgG8smC5GO6rNwZ/TOadVLr3mzWJkbvRJqjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZWe10QKpSjloTY91ubWMy8VqcxnW9w+d6Z2zEyOBpI=;
 b=Qm8wdj9sULm1YnZPprgG4H/yK2r9MBY2szCgN40o3CdMksyrkm/zK/p4pWW5U1QipIZX7wVUak00+BfshVd0EVZSBYKBj5lSQqL8OK74AHASF7benH5I4tTnsNPJZB2Cv9AKiJSmGF+HRFct8p1GD0tG0DKN4Ryj4uHJ+7Ymz+k=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2328.namprd15.prod.outlook.com (2603:10b6:a02:8b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Sat, 5 Dec
 2020 19:11:28 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:11:28 +0000
Subject: Re: [PATCH bpf] tools/bpftool: fix PID fetching with a lot of results
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20201204232002.3589803-1-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ea2478fc-45c4-6480-bba5-a956abf54f13@fb.com>
Date:   Sat, 5 Dec 2020 11:11:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201204232002.3589803-1-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:d155]
X-ClientProxiedBy: CO1PR15CA0088.namprd15.prod.outlook.com
 (2603:10b6:101:20::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1033] (2620:10d:c090:400::5:d155) by CO1PR15CA0088.namprd15.prod.outlook.com (2603:10b6:101:20::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 19:11:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0a47f11-37e6-4fa1-a648-08d89951917f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2328A4F4FC1A084A6B4CFF6BD3F00@BYAPR15MB2328.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o9h21lRVd2NZ4YeR6GiOtLVcqy3xxubMUFa6J9W58rMJ8xXv8rrhCPUTHjmiM6j493rRDOvttxiFo33+PKCYpsAThN6Jh44OVDn8Cr3FxKVsBwbexPO2W4ApqZrcKk8Bdu1FsjMLJEd8/A1sLPDT46Celm9kbdBlCMcEKbl9yJjvttGDswqWcWZsdzXkJMOBSdFDfYdc1PY8DcddZOWtoLGaB3prlUe+OohoRoraulWWk4bidPh3OIUxm8EwPZkWsEq7rb4fMwo6Itwkn9fUKvhNCybvvkc8CZZu+SVWMByMg5VWiwY75g4qHB4lLZOw3v7rjU0lfVx9bLAorD4OJ+NB2TWJf9YghTHPK4mBH9Z/MX84nkt2wAqyO+U/c7KMCNizlAnSawxzlKT5clls9tGjH1G5yd7FxRpX6NOPrNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(366004)(39860400002)(2906002)(66946007)(31696002)(83380400001)(6486002)(4326008)(16526019)(8936002)(66476007)(66556008)(186003)(31686004)(5660300002)(36756003)(53546011)(316002)(8676002)(2616005)(478600001)(52116002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M0ZLUG12L0J0MWFGMk5FTEIyY2haVGxCZFJCakRlMUQvamxBZXVDRVpna1hw?=
 =?utf-8?B?bmNPdWRVZG5mTmhWamIycmt4bzRZSmZOeDI5eWpwdTgzMDRiaEFaUDA2cVQz?=
 =?utf-8?B?L2lpclRCY09aYVlYY2FpcHM0YmhKNWpaYkV4Q2JLRWdXZjRtMURRVWNtVy9Q?=
 =?utf-8?B?d252UGdLNU5uMDM2S3FIM3VpUmUyYWRxa0NRWmNaSnJiQVJtN0NZZkk1bGNQ?=
 =?utf-8?B?Szk5TXVMREFtZmVjOWhyeEV0azY3U2lhV2tiVlNibHpZMG1ZazBzWm1WOFo5?=
 =?utf-8?B?MkR4dDNYNHJ2elRKeFE1ajBjRTZFSEtHOUdoR3VGYmY0Ri9Hdkd4bGNkclVX?=
 =?utf-8?B?N1ZFN3FqVjZaQkxZNGNMdS9ENHdrYk1FWFFRYjFMNFh4b3pkUWJUMnJyb09s?=
 =?utf-8?B?MFcxczdyS3lYbFdaNnVSNmtGSlBCd1phT2JFVSsxZEY0RWh6UmltZjZBS05B?=
 =?utf-8?B?ZUlYRHNBN1I1UW5DaWdVL25pMHV5V3l3TG5obFBLK2FheXhiR24waFBrWThj?=
 =?utf-8?B?SjNSS2IvY0NqeEFkWGYxeStpYjZFMDM3WkJHMityMzRJTVlyNnN4QkNQaDE2?=
 =?utf-8?B?SXlDTVpwOFh6VGQ5Uy85U1JpOEtMcXJPRWdCMWlnYndHYUxNM0ZZQS9TV2xo?=
 =?utf-8?B?d21ZeklSeVJSOU5qSllQeWZsZVlqN0NtM0Z4c3pYMmI5aXhIVkdGYzZnQWd3?=
 =?utf-8?B?NFRTOHE5OVhVWHRrWDEvUlNwenRKMmpwM2tQNHJzZXpyc0dlZHlmVTV3aE0r?=
 =?utf-8?B?UzlmbjRYcDlzelVyUkNZcHVTTE4xYTRESDZtQTE5VkQzNExHZE82S1NReVY5?=
 =?utf-8?B?YUV2TEd6WUZ0N0I1VThWMVk3Rkc1d1FVQU9xTUdIeHNTdDNQNmp4RDdrQkRX?=
 =?utf-8?B?M3BRY1R0K3h3QW1yeGpTYUM0RmZqUk5rMCt3YUhZdXR0aDNSVDRGV0RXOE9p?=
 =?utf-8?B?TU4wOVJuOWlWb2FTQmp4ZmJDRWZWOU1YUDBBWU9KQlZtYXcxYmp6VmFwQld0?=
 =?utf-8?B?YWIvTERGaTNwb3FzVFl2ZVlLQmw0blhIcWlPMjE5UWhaeFR6cmU1RTJuZGt2?=
 =?utf-8?B?WFQ5bHcxaTdKVUVHdVh4UmFLQ2cwMXhPVTJjSjR6bTZJNlRwN3FRL3hDZTk0?=
 =?utf-8?B?RzMxVW1KMXRnSmJqMmZuR0xMNUtwc01BenhLZ3ZqMEtWSWNqdnJXaG1vUklt?=
 =?utf-8?B?WkdWOVUzNVQ5VFBtR0hZcGZCTVJ0RUVSbjdhNTdPQlRkN3d2b0NvNFcrbHhn?=
 =?utf-8?B?MXRWWUw2Qk4rY2V0eHpNNE4xUnhKT2NrekZhWkZCUlMwaEljQXhIQU1VMzlG?=
 =?utf-8?B?Ris1V1F3eVNkazM4dmZOTzRlQ0FYUUJidWROelppaXpLRVVKalRhQlhBRU14?=
 =?utf-8?B?NFJ0ZTYrUEJoZUE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:11:28.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a47f11-37e6-4fa1-a648-08d89951917f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jU+6LtHapugWKGpkjhq0hm/ty82LrOBuudB8w4QnrB55fY4eZq1j3YpUAJv8Wquv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-05_15:2020-12-04,2020-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012050127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/20 3:20 PM, Andrii Nakryiko wrote:
> In case of having so many PID results that they don't fit into a singe page
> (4096) bytes, bpftool will erroneously conclude that it got corrupted data due
> to 4096 not being a multiple of struct pid_iter_entry, so the last entry will
> be partially truncated. Fix this by sizing the buffer to fit exactly N entries
> with no truncation in the middle of record.
> 
> Fixes: d53dee3fe013 ("tools/bpftool: Show info for processes holding BPF map/prog/link/btf FDs")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with one nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/bpf/bpftool/pids.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
> index df7d8ec76036..477e55d59c34 100644
> --- a/tools/bpf/bpftool/pids.c
> +++ b/tools/bpf/bpftool/pids.c
> @@ -89,9 +89,9 @@ libbpf_print_none(__maybe_unused enum libbpf_print_level level,
>   
>   int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
>   {
> -	char buf[4096];
> -	struct pid_iter_bpf *skel;
>   	struct pid_iter_entry *e;
> +	char buf[4096 / sizeof(*e) * sizeof(*e)];
> +	struct pid_iter_bpf *skel;

No need to move "struct pid_iter_bpf *skel", right?

>   	int err, ret, fd = -1, i;
>   	libbpf_print_fn_t default_print;
>   
> 
