Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080F74457F8
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhKDRKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:10:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8294 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232124AbhKDRKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:10:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1A4GBhBR004857;
        Thu, 4 Nov 2021 10:07:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Y6g25JuOZPWUB9O/Bn7/pKp0Xwxa4zNltIHur0D4NVQ=;
 b=T4F/+jCttMRuNESXJsDyyjwBj1JB9M+Pj+/vzRPhCK3huXILC3rIf9uyrf3N5R4waKvr
 Zsnl7SgsKDSOq53Z4Gks9noo6lpIsos4LvWD7phybH0eViQbSTbTO0JqoSdhB/HsmziW
 OrZKinRLwXszc/5ehKwREYA8icMDHLowOIw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3c45wqdrx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 10:07:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 10:07:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfH5wUjOqhZ2MxEYkKLg1BdTp4Lmv7WwxqhPKl9+sv41kTtEotEVFiNoqMBfBX/Pd+16y5gbS+tfmHdu6dQP8jD2XfInwJ3CY/GytFm4i141fcZuzBE6no7avqItgbD9pj//ftg28Mys8JZmhZMQTGN50oUoNCe48ZyNMnf+7e53/u59Ycuu07dAiuWyvSAKsi30JnZhHlynzEY7vwCHWA9E+eJSg6veMKZXoVRcmaBBgkQtB1mCdejQov6axrJwEvLaMZl+pVA2gVijy+4g+RQoBThM4Qh5zajflTw7/OpITQcvcqQdr3pDij4mF9rrr1Dgr6f6bvIxeTQo+YhEFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6g25JuOZPWUB9O/Bn7/pKp0Xwxa4zNltIHur0D4NVQ=;
 b=fAmHwZiqXZ3r+o3kxqmjtlrdcV/vQTy2zV+i8JxkU7QNinceJr5Z1frF1vu3VvkG54DgqgAhCDkcfNSxZ/Pm7in77dUv3FO78ve1ZG9RooVR25TVRu+29OA/IQEr5ZLv3zbaAI+3s4N1DJFFBDqg3jbQ5SWdewF9xDsfX5MgdbWnysS6Img1VL14uxTvuw5YzY9czkOUDClj/2bNlRIkzlZznidijJ7gLcbr9JM/eYg7iA+IhTzxGpQQZHCB7M+YcBhAb8ja2j6RYsY8U8cUNPClEMIsLKBH+OsxM6AcGMi5yZL9e1xIgDjg+DyQbBDCr1trbhkEc0iku3uL2CViEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4451.namprd15.prod.outlook.com (2603:10b6:806:196::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 4 Nov
 2021 17:07:21 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 17:07:21 +0000
Message-ID: <21d8587f-4a27-2966-167b-fa20b68c1fec@fb.com>
Date:   Thu, 4 Nov 2021 10:07:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add tests for bpf_find_vma
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>
References: <20211104070016.2463668-1-songliubraving@fb.com>
 <20211104070016.2463668-3-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211104070016.2463668-3-songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR2201CA0050.namprd22.prod.outlook.com
 (2603:10b6:301:16::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::1253] (2620:10d:c090:400::5:e407) by MWHPR2201CA0050.namprd22.prod.outlook.com (2603:10b6:301:16::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 17:07:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c0c4d9b-8b33-44d0-3234-08d99fb59051
X-MS-TrafficTypeDiagnostic: SA1PR15MB4451:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4451DB9C7079428A93AD1D8DD38D9@SA1PR15MB4451.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NpO0S4KEA2HE9HoUD8BB8nx7RZfe59CcmhLCPyKXKVggbpSDhNpQcUW/iZrDi2aPmC1JRS4Bf1PtAfOWmH6SbYcJ388vLnAOcRgX7N+Cbh0CLpO7PzLwLnKO2vZxJ4xS2I0jdmWD29mhLy0prNFENDHVbY6Bm9CvHt1g7ghgJHND6tjSG4G5lGdqYZ5mYxL9b72MVpmsP14G8F5abpXVZXTXYpMWh1nN498ZvfZXBQKMtgFOnur05lE41NrxPpJhZrvkFSIYLKHAozRA4mo2cp9UwlqXdj8STLBeD9BAgvmgXNzH4EqNN9Jvvj2FfLnKK6uh9oJjh17zHYNUesmxBjXONvXpuPJ48OEx+Nh/sbUDtfV+RM6P+/4KFX3x23rZkBQ4g7egC4jalP5b5shFPD4hUWZZVkSB3EbuSsQ8NogsoAjjPEpduXuT+joEhXfw04V1LhZnePW10TQR9v/JaqlBYupiTlsFp3rKSJgo0qu/7fC7bTtU3mT0CYMak5u0Woq0x1EUT/YHI5fWHiL+HAFKBYHTgMIV7qNxsVXzPjqaQ8M48nJtC8XUcu7pWJhQ7qHZ7M9ctg0fika1uWFj7o4naRv4PprwveFpZVn846Jhi5/FxrmlgGQm8az1sLunJDlDd5+YgazPvlmB6ajdhoio3kr5u9Tw1eFuUY05Lqt6Gmpg0RhzsemMKc3RIOk8cU2M8KEd2Xyo8CmX/wO/zqZQ3HxazTmgMQhfmrNX3cxsN/vd5smC+Ykg21iwEgYSzGaXycCV4hlFCzucrRgRrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(2906002)(6486002)(6666004)(316002)(86362001)(2616005)(8676002)(52116002)(8936002)(53546011)(4326008)(186003)(83380400001)(31696002)(5660300002)(38100700002)(36756003)(508600001)(31686004)(60764002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djRoR2NzWFBjczZhby93MGlyZXp5UlYzeUhkaVhYR1VnNGIxcGVRcGEycGpv?=
 =?utf-8?B?ZFhhQXl1MzVma3puck9ESDJqVGREY0tlajlIL0lFN1JsV0hQL1FEOU11S1Z6?=
 =?utf-8?B?MmJjdDR4b2JlanZnM2llcGJ5TnBGaTlZTEpKWHI3Y3k2bFJSTHZxRkxMZmxa?=
 =?utf-8?B?c0ladUpUclV0VkQ4WTFSZ2F4WG5wc0xMbnM2djFYQW1ubmErdEwvQTVTVlRn?=
 =?utf-8?B?S1FZMlgxTlFwOExwTWh0VCs5ZjJacUVrL25CdU1LN1RzMExJYnpZKzFtczF0?=
 =?utf-8?B?Z1lRQUthZlMwcmFxWDBXeVJSMjRZdzNTcGdXZTNWNWxGcUdnQlM1Tk10SUFw?=
 =?utf-8?B?N1NacXVwdnVZdm1zQ3BDSnBIMDVxZFNLSGtsUmJVWDd5Ukw5TmlJSGNqVVBW?=
 =?utf-8?B?Q1U3MmJCMHBQeHNTQmgvRXEzZm5CbVY1L1pQUHViUFgzUTlHb2NkcHl4c3N5?=
 =?utf-8?B?YmMzVGNOK2k0N3BKc3VjNzdVWVIyRE1zSUpyeWdCWEdSTDN5QUVJYkdrcGhV?=
 =?utf-8?B?UmFQem16TWRrTjBsZzhPVUM4YzNSS2FRSW5iTFc0blprYVlwTWZydTNid3dy?=
 =?utf-8?B?TG10OTlyQXoyUUQ5cXNzaGc4ZmY1eFVCZGlFQWFkU1A2RXdTa3o4TWV2WGl5?=
 =?utf-8?B?VXRjdnpBZGV3cGJYSVUvcWtKY1dnU2xrQURaVGJ3LzZPd0s4c0VtQktOMUNi?=
 =?utf-8?B?UWhCRmllbWNHaU5JRG8wTUFpOWd6ZEdoV2lrMWVCa1h0Q2h6NTFhUGE4eVA5?=
 =?utf-8?B?OXhRYjRxeElqZ1VYbkhaaktjYitDdWR0OUhXUXJDVDdCVEIyRE9MSjIxMDVE?=
 =?utf-8?B?N0JmUWVaeFl5dlJqSWdRMGQvVjZaSUVvak5pUXhvUVBZbU5sZmpLQUJEYWdN?=
 =?utf-8?B?Ynl0eDgxS2IwT2hiYUgyelBucGhnUmVacHZMTkhmUkNYOVVyRjBkaktZTVAr?=
 =?utf-8?B?RCtlNHJ6Yk9RTlJwL21xMWFTeEk5dXNLVkIxUUp6V0ZxNGJxcHZMQVNRTG1F?=
 =?utf-8?B?WFVtYUVxUzNxQ0w0N3p1b3AzbWF3d3I2UFdFeXVzQ1JJaTZsQjJ2c2VDc0pS?=
 =?utf-8?B?cnBHVTV6L1NPblZNVFZjakNXdExqU29NYTZ5aEptNTZWaldUV1kxLzY0d2FD?=
 =?utf-8?B?OStjc3BYTjhTckluWG52VSs3MEtYZUxBRmxXMkRCZk04SzUzQXIrRHFCWGNQ?=
 =?utf-8?B?NnlxRi9UaEVGTmZnemE4UGhpcXBSVGNBRGVNYVYzem9EQ0VJMWhNNEtkK0RP?=
 =?utf-8?B?bTdMMUNndUpoTHhrUnYxNnlOZGlsYjJienRpWCttaTcxVnVUM250SHEweUFG?=
 =?utf-8?B?YVBRUHp1aDFDTEFjMnVveGtnMHhJaVJCcGJBL081dGg2TGhKN1hCQ21ERXUy?=
 =?utf-8?B?SlhuRnRHUUNxN1Q0czY5ZWorMitod2kyeFlhRjVSQnRMU2N1b05kc0d0Ym1w?=
 =?utf-8?B?KzNLd3ArRnJhV2gxNVltOS82dzVvUFNscmVlOXBXUWF5aFZJdUFkVEJlRDVO?=
 =?utf-8?B?dVB6KzZsT3hZWm9DSUtjRWxyOGRUdFQyVDJTNGxERW9Xd0N3T2JmZ205TGRv?=
 =?utf-8?B?SWlsUmJ5RE0vOGNrQ2RjSFZDWmdWalAzZ1BVNUNraExrNWZZRHMrOHkzeStW?=
 =?utf-8?B?TlUvRlNBV0g1L21WT1lvUkNYdFpZRTR4NCtXUHNZRW5EOWp6UnJPaXFmSTFV?=
 =?utf-8?B?VDRwVjlLOSsxUVE5cVREMDhlWXlNMlBIWXN0MjhseFRySThrNlltZW1oK3Yw?=
 =?utf-8?B?TDJvWU1vNlZKNjFDaWlJNEdlVzFiMEt4cnhRY3FONVN4K1RHdzVrN010VE5R?=
 =?utf-8?B?dnN1OE5TNTFjREhYbng2UDhxTksreDNiU1ZsdlVqOXBYUGlHeU1zbGFJT2x5?=
 =?utf-8?B?ZFAyTkZhTTM5L1UxT3prbVExejBmMzd2RjVnSVBsdEVPS1FtMDJ6dHpUMzI1?=
 =?utf-8?B?aWh6OXNLUHZzWnNIV3ZRRExPMmJ0MVNJTHRFN09BQlJqQ3FxTmZyRjNwWG5E?=
 =?utf-8?B?ZDFkbjRzWnBQQ1E5NDJwUEF5TzRsUEpIaE5qd2I5ZGlBMktTZlVrN253MGIv?=
 =?utf-8?B?Rldnb053TGR5a1V1TjJHZEpGc2Ridmg5c0crWTNBL2NTMFNRazM2TjJVSnd6?=
 =?utf-8?B?S1JRYVRtM042UHJNSXNnQmROYXVzd1JxWHhvemhselFsYXgzSnROYnRZUnhi?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0c4d9b-8b33-44d0-3234-08d99fb59051
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 17:07:21.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBTIUugXkUNydAOLrus0C10LBjb9fl5e5Z/gGr9Ui1en4rwZj4PEd/EKNNth/Z4b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4451
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: JXcN2u9Kuy2RsPlqz9l87aO69aq61U0T
X-Proofpoint-ORIG-GUID: JXcN2u9Kuy2RsPlqz9l87aO69aq61U0T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_05,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040065
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 12:00 AM, Song Liu wrote:
> Add tests for bpf_find_vma in perf_event program and kprobe program. The
> perf_event program is triggered from NMI context, so the second call of
> bpf_find_vma() will return -EBUSY (irq_work busy). The kprobe program,
> on the other hand, does not have this constraint.
> 
> Also add test for illegal writes to task or vma from the callback
> function. The verifier should reject both cases.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../selftests/bpf/prog_tests/find_vma.c       | 115 ++++++++++++++++++
>   tools/testing/selftests/bpf/progs/find_vma.c  |  70 +++++++++++
>   .../selftests/bpf/progs/find_vma_fail1.c      |  30 +++++
>   .../selftests/bpf/progs/find_vma_fail2.c      |  30 +++++
>   4 files changed, 245 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
>   create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c
>   create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail1.c
>   create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail2.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/find_vma.c b/tools/testing/selftests/bpf/prog_tests/find_vma.c
> new file mode 100644
> index 0000000000000..3955a92d4c152
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/find_vma.c
> @@ -0,0 +1,115 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include <test_progs.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include "find_vma.skel.h"
> +#include "find_vma_fail1.skel.h"
> +#include "find_vma_fail2.skel.h"
> +
> +static void test_and_reset_skel(struct find_vma *skel, int expected_find_zero_ret)
> +{
> +	ASSERT_EQ(skel->bss->found_vm_exec, 1, "found_vm_exec");
> +	ASSERT_EQ(skel->data->find_addr_ret, 0, "find_addr_ret");
> +	ASSERT_EQ(skel->data->find_zero_ret, expected_find_zero_ret, "find_zero_ret");
> +	ASSERT_OK_PTR(strstr(skel->bss->d_iname, "test_progs"), "find_test_progs");
> +
> +	skel->bss->found_vm_exec = 0;
> +	skel->data->find_addr_ret = -1;
> +	skel->data->find_zero_ret = -1;
> +	skel->bss->d_iname[0] = 0;
> +}
> +
> +static int open_pe(void)
> +{
> +	struct perf_event_attr attr = {0};
> +	int pfd;
> +
> +	/* create perf event */
> +	attr.size = sizeof(attr);
> +	attr.type = PERF_TYPE_HARDWARE;
> +	attr.config = PERF_COUNT_HW_CPU_CYCLES;
> +	attr.freq = 1;
> +	attr.sample_freq = 4000;
> +	pfd = syscall(__NR_perf_event_open, &attr, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
> +
> +	return pfd >= 0 ? pfd : -errno;
> +}
> +
> +static void test_find_vma_pe(struct find_vma *skel)
> +{
> +	struct bpf_link *link = NULL;
> +	volatile int j = 0;
> +	int pfd = -1, i;
> +
> +	pfd = open_pe();
> +	if (pfd < 0) {
> +		if (pfd == -ENOENT || pfd == -EOPNOTSUPP) {
> +			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
> +			test__skip();
> +		}
> +		if (!ASSERT_GE(pfd, 0, "perf_event_open"))
> +			goto cleanup;
> +	}
> +
> +	link = bpf_program__attach_perf_event(skel->progs.handle_pe, pfd);
> +	if (!ASSERT_OK_PTR(link, "attach_perf_event"))
> +		goto cleanup;
> +
> +	for (i = 0; i < 1000000; ++i)
> +		++j;

Does this really work? Compiler could do
   j += 1000000;

> +
> +	test_and_reset_skel(skel, -EBUSY /* in nmi, irq_work is busy */);
> +cleanup:
> +	bpf_link__destroy(link);
> +	close(pfd);
> +	/* caller will clean up skel */

Above comment is not needed. It should be clear from the code.

> +}
> +
> +static void test_find_vma_kprobe(struct find_vma *skel)
> +{
> +	int err;
> +
> +	err = find_vma__attach(skel);
> +	if (!ASSERT_OK(err, "get_branch_snapshot__attach"))
> +		return;  /* caller will cleanup skel */
> +
> +	getpgid(skel->bss->target_pid);
> +	test_and_reset_skel(skel, -ENOENT /* could not find vma for ptr 0 */);
> +}
> +
> +static void test_illegal_write_vma(void)
> +{
> +	struct find_vma_fail1 *skel;
> +
> +	skel = find_vma_fail1__open_and_load();
> +	ASSERT_ERR_PTR(skel, "find_vma_fail1__open_and_load");
> +}
> +
> +static void test_illegal_write_task(void)
> +{
> +	struct find_vma_fail2 *skel;
> +
> +	skel = find_vma_fail2__open_and_load();
> +	ASSERT_ERR_PTR(skel, "find_vma_fail2__open_and_load");
> +}
> +
> +void serial_test_find_vma(void)
> +{
> +	struct find_vma *skel;
> +
> +	skel = find_vma__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "find_vma__open_and_load"))
> +		return;
> +
> +	skel->bss->target_pid = getpid();
> +	skel->bss->addr = (__u64)test_find_vma_pe;
> +
> +	test_find_vma_pe(skel);
> +	usleep(100000); /* allow the irq_work to finish */
> +	test_find_vma_kprobe(skel);
> +
> +	find_vma__destroy(skel);
> +	test_illegal_write_vma();
> +	test_illegal_write_task();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/find_vma.c b/tools/testing/selftests/bpf/progs/find_vma.c
> new file mode 100644
> index 0000000000000..2776718a54e29
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/find_vma.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct callback_ctx {
> +	int dummy;
> +};
> +
> +#define VM_EXEC		0x00000004
> +#define DNAME_INLINE_LEN 32
> +
> +pid_t target_pid = 0;
> +char d_iname[DNAME_INLINE_LEN] = {0};
> +__u32 found_vm_exec = 0;
> +__u64 addr = 0;
> +int find_zero_ret = -1;
> +int find_addr_ret = -1;
> +
> +static __u64

Let us 'long' instead of '__u64' to match uapi bpf.h.

> +check_vma(struct task_struct *task, struct vm_area_struct *vma,
> +	  struct callback_ctx *data)
> +{
> +	if (vma->vm_file)
> +		bpf_probe_read_kernel_str(d_iname, DNAME_INLINE_LEN - 1,
> +					  vma->vm_file->f_path.dentry->d_iname);
> +
> +	/* check for VM_EXEC */
> +	if (vma->vm_flags & VM_EXEC)
> +		found_vm_exec = 1;
> +
> +	return 0;
> +}
> +
> +SEC("kprobe/__x64_sys_getpgid")

The test will fail for non x86_64 architecture.
I had some tweaks in test_probe_user.c. Please take a look.
We can refactor to make tweaks in test_probe_user.c reusable
by other files.

> +int handle_getpid(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	if (task->pid != target_pid)
> +		return 0;
> +
> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
> +
> +	/* this should return -ENOENT */
> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
> +	return 0;
> +}
> +
> +SEC("perf_event")
> +int handle_pe(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	if (task->pid != target_pid)
> +		return 0;

This is tricky. How do we guarantee task->pid == target_pid hit?
This probably mostly okay in serial running mode. But it may
become more challenging if test_progs is running in parallel mode?

> +
> +	find_addr_ret = bpf_find_vma(task, addr, check_vma, &data, 0);
> +
> +	/* In NMI, this should return -EBUSY, as the previous call is using
> +	 * the irq_work.
> +	 */
> +	find_zero_ret = bpf_find_vma(task, 0, check_vma, &data, 0);
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail1.c b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
> new file mode 100644
> index 0000000000000..d17bdcdf76f07
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct callback_ctx {
> +	int dummy;
> +};
> +
> +static __u64

__u64 => long

> +write_vma(struct task_struct *task, struct vm_area_struct *vma,
> +	  struct callback_ctx *data)
> +{
> +	/* writing to vma, which is illegal */
> +	vma->vm_flags |= 0x55;
> +
> +	return 0;
> +}
> +
> +SEC("kprobe/__x64_sys_getpgid")
> +int handle_getpid(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	bpf_find_vma(task, 0, write_vma, &data, 0);
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail2.c b/tools/testing/selftests/bpf/progs/find_vma_fail2.c
> new file mode 100644
> index 0000000000000..079c4594c095d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/find_vma_fail2.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct callback_ctx {
> +	int dummy;
> +};
> +
> +static __u64

__u64 => long

> +write_task(struct task_struct *task, struct vm_area_struct *vma,
> +	   struct callback_ctx *data)
> +{
> +	/* writing to task, which is illegal */
> +	task->mm = NULL;
> +
> +	return 0;
> +}
> +
> +SEC("kprobe/__x64_sys_getpgid")
> +int handle_getpid(void)
> +{
> +	struct task_struct *task = bpf_get_current_task_btf();
> +	struct callback_ctx data = {0};
> +
> +	bpf_find_vma(task, 0, write_task, &data, 0);
> +	return 0;
> +}
> 
