Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3297140EDE1
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 01:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbhIPXhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 19:37:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41392 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234396AbhIPXhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 19:37:31 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GFgvLM028973;
        Thu, 16 Sep 2021 16:35:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RKKU8Ag9Li586DVnhS6AsrJeuAacgmp8ctHzgOqyruk=;
 b=CUIM3D3KXL4foI0sztEbf6c67bSUATwZ6EynWgsr5rCqFF2+N9xDvicsr5MebQaHhAx5
 s9m9gV070t06hf9jT/tx9FH3ikxNWeuH4qsrt1ALGLJlImVohzIDUCgNRQasue0Vk08D
 8alwkpEh37pP/7mIMsLIIZoO+87jSPwZ/1Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b3qg1925h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Sep 2021 16:35:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 16 Sep 2021 16:35:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNDpBiIc0T+eYXMJn52+fCdPGDnxFqfzPWk0c177l5+5F6z7MNKdvFOJhI9JsSI66e8YcS9zIxsQBvaTeOP26e0B1LPHoo7sDAUpm76+gWwHfb2x6+Mn2rxURJ0BFx6A5HTClNPSBcnKMwtU8eJ+31kab6wyhhcdM+vsxTIaHMTFONmfxqPNH5//VykSB3oC0q3O9kwT8jtVo6tiny2jj9R+RDLBm4Des9q3UAhjUARAV3/tAkDXp+0yuWehsgzJn+OIlSBC0+KqeY89mSXAyhTj7KqzUlCY4qpaRAn5jc1cKb+SxMfnN4f4YQ7sE9sdgbTXGwJTheOqu2tXyTSudw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RKKU8Ag9Li586DVnhS6AsrJeuAacgmp8ctHzgOqyruk=;
 b=Q3DnEJSCQrQ9Aa/S7CVcrLBCr338uFIv7xEpcSUNpOQlpjww8mWkjmAaVv2EsSpw0HHn6dwAaT5uXL0YuSfUhLPLcZeJoOjP1I5aGkDhT+Zzb+qBvxLnphQFjuiCe563fnOC8qOHw/tK9gmwNfzElTzhSipdifV8rfk3+F7m+iiR3qpBsym7st0bwbIYqXMqEcGYO7RgxqJpg1oQy/l1lod0hBa/rf5fLFadr621jtbqdPaS2wXWDeSmH2KM88tDsUxcuyQHn6J0sv1d5be3oUsp0quJBhRHnjFRZLSU7rwJPBfFdeBCgnlL6yHFXbGo0+/Sfx8M/fMzuSDcMgAKgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 23:35:49 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 23:35:49 +0000
Subject: Re: [PATCH 2/3] libbpf: support detecting and attaching of writable
 tracepoint program
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210916135511.3787194-1-houtao1@huawei.com>
 <20210916135511.3787194-3-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e91eeff7-e091-3445-f27f-a30646cc5440@fb.com>
Date:   Thu, 16 Sep 2021 16:35:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210916135511.3787194-3-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::15) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPv6:2620:10d:c085:21e8::1426] (2620:10d:c090:400::5:fd5b) by SJ0PR03CA0130.namprd03.prod.outlook.com (2603:10b6:a03:33c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 23:35:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92cac98f-8e7a-4f9f-c352-08d9796ab6da
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB491911B5627496C67D836FAFD3DC9@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xdlqOD9pziw82/rO4QIap2XxADXduwpUGpBaiishSlzKq3gR6O1xBV1rSHXDOnHtydkG4hNXrx3w0740aBmCnHMB1/Ohub01ySnLZ5r32Wf1yWnN/etgfGR53kO9OLRM3yKEglGcqBMHPSngabPpkoXRrlf3lnDoR1JgFHf7abUEtsxJKCphmvMgn+X8pvkZJFG1hBErvQwFIeRjdJO9a9o3Na6p1fVOkYRAeOnkCtO2GRuYJkIEELdF7FBxM/EM2bvtNw3Ez9OkK57dkx4N7Pz34wePja7FH8KcCZNBKQ7h8jEoXx25uyVmkMvldJi3cuFA8AVUHGQwToorsn5LcIhxdAoB+83nvCPfznkII07lUPuIMcIG0uftzacN6svdmiZpjtesiyMlDV8wHWgE7KZ6WXXaFJHCj4Cg4qBWuNTNBt9BSn0wYcAF4xJEccEj2yY9s6lu3cgrkuPJItmdsBx3qYIWaDf/ajBkJ/uZmjztgVtg+b/rfwMs7vGVCoL+1GhTbf5/BAJK5N8lx4ajYT7BaoOJBvwG7kZwBFZU5sI7hiGcLljftB5braKzKvSqC3PY/enral0Nmn9YL6KNga+KE5LY7/sicb0HvsBJ+HlUSgC+P/YeRGT25uCMzUJezuiHr2l34lIoTADIXXKbDJqgxFALxAVQtGy0F4sodlg/hfJFPCn74JAntZ5QukoipEtTyqjohvr1NovGfSbqvQqsZ46V14UKANkpKfCY43bqaTT/RtapAAen1YF6NnR9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(316002)(8676002)(53546011)(54906003)(31696002)(6486002)(66476007)(66946007)(110136005)(2906002)(5660300002)(2616005)(38100700002)(508600001)(8936002)(31686004)(36756003)(186003)(4326008)(52116002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUxxZWtnZy9EWDRwRis4NktUdnY4Rkt3NmExZTNQandFaHJORXBURk9xTms0?=
 =?utf-8?B?NWUzeW1oYXdlKzFFWGlDTzAzK1BLYzMvNGJ1dVRUOWpid01QZlF4aHc5Mk05?=
 =?utf-8?B?R0tyNzhGL005b1g5MUtiQU5WYml0V3BFQXhzWmRNZjVWbnNwQnZYamhIQWpW?=
 =?utf-8?B?cVA3TjZWNWJvYjJmaXM5R2RWdTFLZjJYR1Z6WXU5L3AvQzBjb2h6RHRjTGp0?=
 =?utf-8?B?anZtdXUzSGRZczdXQjdqcmQwQko1T1draW1JQ25weGlmVk03a0NrZFBuZWJO?=
 =?utf-8?B?L09pR0hhQnR1eWNEN2QxZFdzdU0rRlVuUnhXT1lZbFEzNnptbUpGRnZHTGZm?=
 =?utf-8?B?ZE9uc0xBMklDZzNrRmlKbktuS25kNVA1NURvVW1RS3hPWFhaZlhNR3U5MjU5?=
 =?utf-8?B?TGxCU09UbFZuOVZhQzNyR0lzdzNlYlJtRWpWYXBrNlo5T1YvQ3ZORHpRTzNF?=
 =?utf-8?B?S2hBZzRnVkZEZmxORnJmTDhzNUMyVGg3MDlPRDcyaU5xK0tRUDRzWXVFSVhD?=
 =?utf-8?B?UEM0ZVZ2dVJ1Rkhjem1hb1FxK0J2SnZkdDZLTG1yTEk4VktodkZpSkZvMEl0?=
 =?utf-8?B?S3hheTdrR2R6ZzhkU2J0NHBGOWVaNDAwMkdva0k2MlB3bUxDVW9xL2UwdzZE?=
 =?utf-8?B?K3FvV2JuRmhnbnFsb2h1YjJuK1RiY2lBa0xuVE1TT1p4Qy9RWmJHei9WRm4v?=
 =?utf-8?B?Vmp5dXNzSE1LU0xSNFZyVTFuK3p6L25TSlYrczRsVHRDL0RuU2oyQldNcUhk?=
 =?utf-8?B?bTAzMmh3V2g1VTlyU0pIQUQyMlEvcFB5MmwzWW8vSGl6L2hqamZxTWMybVFG?=
 =?utf-8?B?dG45cHl2aWpsOUQxZEpDQzFmaElvV0JpSzVDbG1hTkIvdDczUEFmMlpFSElq?=
 =?utf-8?B?WS9iWCsyWmNyenREZ1l4VkUvV2s2eVlJSUFqQ3hZNzJKd3FMa2JHeDBqdWl0?=
 =?utf-8?B?amVLREczWmFxNTlscllLWHJ1clZtN3BlZ09BQlBaODNCTTZWN3pDSWFkcHlu?=
 =?utf-8?B?MnRzVWp2T0RyZkxnZERMSkRHUGF1M21uQjFGVWI1UEQ3Y3VOT212UzFKM1Vv?=
 =?utf-8?B?Y2NaSWNkSk9Wcm9zUzBhTXQzK1FRNWxKRTBxbTdiYlEwN3VFQkp3aTNxMU85?=
 =?utf-8?B?V3ZKSEtYZ0xYYWNuMTlwcFNIN0cxN1gySERHTGU5cHR3bEFTUS9SUnhtQnJ0?=
 =?utf-8?B?eDhERmJOZzlyY1cxN2N4bHErWUlhL2NpcEFUdzc3WDBKQlhhMFJjU0UzSVgz?=
 =?utf-8?B?bGpZWnp4UmlTVEtJdzZRMVpraFRZYUMvbFBHcmdhL3oxalJTdEtOMjBMaFJ4?=
 =?utf-8?B?VGFnWXNWZDZkYTRJVE93T2szNmovRnF3RjBTMC80Z3BtcCtVMWZTS0w2bGc1?=
 =?utf-8?B?ME5XaG9VYy91Ujg1TURJRE4yYkNaNlpuVlY3dEJJejFHZzZPSGQ4TmRIMyta?=
 =?utf-8?B?ejBlOUNJY2MxZ2UxY3lXc0ZYT01mbXZOemliNWprRTFRLzl0a2ZwNVRPNWVQ?=
 =?utf-8?B?M1RtMVVTdjVyclQwNlF4d2NUVDA2a3RqVlh6aVRwZCtaNFRjS1dmYUNoVTY4?=
 =?utf-8?B?WnIzdmJCVktzY0ZEdVprQWY3M2JCcW5qcGFGWUhSOXRHKzE1QUhrQWxyMVZI?=
 =?utf-8?B?UzQ3R0thZGRjY0NaVDdTMXR1M09zcUt0b1dSMktjMWZJZDNHeHNXQmE1YUda?=
 =?utf-8?B?Nkk3K0RQRkxCQjJpSTJ0ekxlc3loZGlLd2ttWm1oTVk3NkdBVzRKcC84Zm1h?=
 =?utf-8?B?dlkzK3EyTitCSUxaTTQ5Z0l3L0IrRU5INFJxdFczbXFUb2tvNE9LWG5ORWE1?=
 =?utf-8?Q?H8J5tIO9yacyI1G4vMl6aj9h/8ndctg8qY6i4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92cac98f-8e7a-4f9f-c352-08d9796ab6da
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 23:35:49.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuIcyEBi9KoZkhw84lPG6XlkVPRl3P7Xjwi+A4rg5sECBbVAvI+undwqarEQzufu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Rzpe8XxIs8DBZpq2A7vHr3Npa858WTNW
X-Proofpoint-GUID: Rzpe8XxIs8DBZpq2A7vHr3Npa858WTNW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-16_07,2021-09-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/16/21 6:55 AM, Hou Tao wrote:
> Program on writable tracepoint is BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
> but its attachment is the same as BPF_PROG_TYPE_RAW_TRACEPOINT.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>   tools/lib/bpf/libbpf.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 88d8825fc6f6..e6a1d552040c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7942,6 +7942,10 @@ static const struct bpf_sec_def section_defs[] = {
>   		.attach_fn = attach_raw_tp),
>   	SEC_DEF("raw_tp/", RAW_TRACEPOINT,
>   		.attach_fn = attach_raw_tp),
> +	SEC_DEF("raw_tracepoint_writable/", RAW_TRACEPOINT_WRITABLE,
> +		.attach_fn = attach_raw_tp),
> +	SEC_DEF("raw_tp_writable/", RAW_TRACEPOINT_WRITABLE,
> +		.attach_fn = attach_raw_tp),

Looks like initially ([1]) we don't have C bpf program test case for 
RAW_TRACEPOINT_WRITABLE, so the above sec definition is missing.

  [1] e950e843367d7 selftests: bpf: test writable buffers in raw tps

>   	SEC_DEF("tp_btf/", TRACING,
>   		.expected_attach_type = BPF_TRACE_RAW_TP,
>   		.is_attach_btf = true,
> 
