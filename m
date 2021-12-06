Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C4C46AB2F
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 23:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353125AbhLFWHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 17:07:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232710AbhLFWHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 17:07:49 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6HvS8v031338;
        Mon, 6 Dec 2021 14:04:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CzAdrTJ0KJ4KVS1l+lMM2ndFG1NlHRoGlfBDkNOdibE=;
 b=bVsrGjn6JzrE0u/ZZIOKzhnCSNDDKB2uPSZp3RWuPXpsJgBEXjpQC5xN9d7DpO2V+Hgk
 1Ch35kcLxOLWb5U4Nxf+6MI42SqaEbFHRaqUdXYd/hn0QeRwYLv3+72sqE7w+NcjqsES
 6WSIpKt5MbHVgZBEEqHJz14LkDTYnki45ck= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3csc985tem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 06 Dec 2021 14:04:00 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 14:03:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7wQp8aVgXTLGtD4H9wOKjcIsMe1WsFNYwEPYN97OdVmg2U0f9QdQb3rKCmCV+o58JNEcSvBJ23X/U9W0rj+OiI0TcdoQ/DfPVuKCAm2cfgx8cOsnWrumU3wpIaXate1Z3c4IDLxa83cSzGPjn9ZJJOBfO5qiifee+blID+y4J5xQxdrixMvlaAePwZ8wbIrGzs2nI9ceOZ55qwClGsNMtEB3zswv1RThOHh6mAVnJjsRfbAU3rKxSNfpMRFpLApwdWDileTrRcfJX8qEKuoIAfzyDxrmdy7avGuJWv+De1uoQJOUCW1TlT3oDn/3k6zbAdPh1JlytRsXSjsuwWNpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzAdrTJ0KJ4KVS1l+lMM2ndFG1NlHRoGlfBDkNOdibE=;
 b=JHpDjBOEfeMxY3MFk/3uG4H0+oimuP+aSdASZLZ8lLRc9JGg8Nl0dv+JKD3iuhTSpuVaRJUZcrQC6LEk/25CWwa/2FeCcksfHvCPTYAlk6XDgEg78nr7ZylUyKMjeZNMEJ6aZAAmNXjsr1ktpKXb4AM3sikFP1Bjq8y/g9l8Jg1ZJzg/ptX/PbcgOMZWfluqihGaPq70i+TzgA9bODOx6V/fCmR4K3DMbV3qguM7OhShGxgiOSKd5R4b6r+63IYxNW+sx9g4MtKLVBFj8i/EmVwV512GWm4ez7Zh00k4EHc67MWCCPBGQCa0Khuc+po+PJFhqb7Kqz6TDwfjDB8o0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23)
 by MW3PR15MB3995.namprd15.prod.outlook.com (2603:10b6:303:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 22:03:57 +0000
Received: from MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::cdcf:702a:58e9:b0a6]) by MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::cdcf:702a:58e9:b0a6%8]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 22:03:57 +0000
Message-ID: <7df54ca3-1bae-4d54-e30f-c2474c48ede0@fb.com>
Date:   Mon, 6 Dec 2021 14:03:54 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add tests for
 get_func_[arg|ret|arg_cnt] helpers
Content-Language: en-US
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, <andrii@kernel.org>
References: <20211204140700.396138-1-jolsa@kernel.org>
 <20211204140700.396138-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andriin@fb.com>
In-Reply-To: <20211204140700.396138-4-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR08CA0038.namprd08.prod.outlook.com
 (2603:10b6:300:c0::12) To MW3PR15MB3980.namprd15.prod.outlook.com
 (2603:10b6:303:48::23)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:2103:b2:4e6a:72dd:1ddf] (2620:10d:c090:400::5:1d85) by MWHPR08CA0038.namprd08.prod.outlook.com (2603:10b6:300:c0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Mon, 6 Dec 2021 22:03:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfdde200-f52e-40a3-4f86-08d9b9044d05
X-MS-TrafficTypeDiagnostic: MW3PR15MB3995:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB399593EE5D213F3C4911BAEAC66D9@MW3PR15MB3995.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:40;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ktdi9XYSrWc/K+ZhFQBahLVkYwgl6Ia3wgO0P0V8OmuhE9UL3/WbT01j7gCuyyIxqoIpUOzSB5/yNZLVTcDKleGiKOAgkWAuPjpxU2/yIwRjnnpLzuXjzCdEIDs+2FONd5n73Z2d9kBcnZiZO2GZM9Y+oWrMpl9B/8sQ6g/3gbQWLcNUQI8XY8Ww4sz7ciaA8XWrymsc7osla/Q1l08zjwD4fbGUMfgLu59pASU9Eb2XcPYYG3vY8aaV6aKoIpQvuJqJhNMGL+dcS3iEpwDvnIHyDBjKbwEIkFBIxYKtEQtnMdpQKOt6MWWQtgN9NGpIx8foIj5gmWt8dZtM5i+98ZGh1TKGWg/ZX2XemqyO0tGBzy3jCxOTX4Zfp3H+YCP5WJWxhxi41Tt1GXq2mc25WPcNDNZrJkFmblZjQ9RNKsFiB/1tgHehb/FnTaHpcjDwtB3eZoRIRLWfVQjDayx968kIh22fh7UPVH3+CS0Kbvlctz6cgSjKHi/6p5dgGwAikgF9nYQYDoxUCJjgkMgnIJwy/E2uqhLMfdwx+dD6nlrDG4zFPsvqnYsyZ47oRYkeDCoXqhv7P11DpV/LI5jPzc/QVy8VAjPbpi9PqUBpFcfXe5htlB9GS/NJMykk9cvPmKzguskI8kFhTuAQ2AuX+8UdzSmeWary23+VzeD4rlPRyrwUvyDvLNQ7OPvb0yAnlTu/96Xa7Q/HieFRcvq53n+Ff3EsisjWrYh2s3iHw9Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3980.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(186003)(2616005)(38100700002)(6486002)(5660300002)(4326008)(54906003)(31696002)(31686004)(2906002)(36756003)(508600001)(86362001)(110136005)(8676002)(8936002)(66946007)(66476007)(66556008)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUVzd3RNZ0s5SlVMZEllUEdReWIvSjV2ZzZISTRIaXJaRnhkUmpKdGtmR1lI?=
 =?utf-8?B?bGdOdEg1blZLYlFxYmR1aEVHSWdQWFMvamxRTytrZmVvV05NM25QNVJ4Nlho?=
 =?utf-8?B?YU92U2k0bk5RWnBoNUk2VFBmMFhOU3pUZUhWTFpqN0JONXVMRldzek40T1ZI?=
 =?utf-8?B?VXVtMU8vd0JwSjNrTkNJQno2TkpnQ1J4UW1PU3QvVzJJWnpRV2hwUk02R2ta?=
 =?utf-8?B?bldta2I0NEl0M093UlRwQVVqc2VyZVhQNE5GL084clA4a0d3STQxM2pPNDFM?=
 =?utf-8?B?RWZsSSt1MFArZ2QrdWlLaFBFQlhkR1FSN084cHhaU1dOVzFLZDEwN0hINFdL?=
 =?utf-8?B?TkNHVml2MnVQbzdRaXBBbDYyMXY3WjFBZE03SUlEREthTC9LUkI4MEVpeGo5?=
 =?utf-8?B?d25DaHdaZDB1UWlldkd6Wmkwck5ZTE1QSmVKeWZ6cnY1eEowQTM1VEl5RGdl?=
 =?utf-8?B?QmxMYTkwT0c4dTZZaVJ6MWYxU2RKclNDenRWcDFqVlhaL2owWjdjajduSWNw?=
 =?utf-8?B?QlNtMlRVSnZPMCtuaDBNT003YWJMVVU3ODVIOTRkWUI1bmc5YWsvZ1pCOUlY?=
 =?utf-8?B?MmlyZEJYdU5rcVlta2oxdTFJcUtVRjAzTi9KQnliVEpGd1Y2ajNkZ0VWNVUw?=
 =?utf-8?B?bm03Zkc1SlZjYk1NWUtDQWRtVE8wRzJ2YTJxRGs5RG9tcnFtS2U0TFVvam9E?=
 =?utf-8?B?bHNQZXZZYkJqN3k5WEMrRHNhVXFoYStSaDZTZ2VCT2NCaERsN0dob3ZHVm1x?=
 =?utf-8?B?a29RNUppOWxxbitNT21Gdkl5MnJDREt4Ylk3RDdzYWxSWmFYUDROWnlIYm5q?=
 =?utf-8?B?K043OStLK0xxRWxSM2FSRXdkbXpNYzVqUUhZaWNpRG92Vm5vMFpXMGdiNm1I?=
 =?utf-8?B?YVFVL1I0N05mOGVlNVducXZzMlBBN0ppS3dvaVdKNi9ET0JyZ1pSVU42RkRa?=
 =?utf-8?B?LzE3Wm5hUWI4ajFtMkdBVHhlVGNPTm5pc3BSeEwxY1JicWdwV3dCWkRFSmps?=
 =?utf-8?B?VG1INU9wOWRXSGx4OVVSclNtc2ovajFKSnVmcW1jSjNMYnhYUkJkeWxoajZx?=
 =?utf-8?B?R0NlQ1ZDQ29SWWFSSWVnOHNoT2hwT204V2hNdjVac2c4UnRkSnMwamM5eWlL?=
 =?utf-8?B?c01pbmhxRFJrMEYxcUxEakZjN25wY0JSa1pYZkpqb2UwaVBhUWRONERZVjhN?=
 =?utf-8?B?MkVOQ3drRGJXVExmUXA1YXg0dWhySTZkaWlTcnZheWxDVFZVRzNWVjRvT1BS?=
 =?utf-8?B?VjVJUlAvdUdTemFacXp1bmlFRlJLK1FDaDk2RlJCQ1lCdm5MUHVFZHpZcS93?=
 =?utf-8?B?TW9xWmJjanhYdmN6NnlsdStEV2JETS84TDBxM0E2K3FvUjdEVmlXeE92UGFC?=
 =?utf-8?B?cGt1Tnp6WDFQekVyc1JTaUtYNStBa2xvbE56ZUl3TmcwM1ZiZ1J4bEowRmpv?=
 =?utf-8?B?SEp5UitRdWUxbkxMVTRjVUJTbVhYTFJIaFBwUmQwRVMrbmM5YU1RQU1LSkha?=
 =?utf-8?B?SWNhaFNnRmZ1VnZ6VW1QRUZudkNnVklHMkFNcG91Wjh0SjRMQ0NjbWJEVy9z?=
 =?utf-8?B?clZEV2o3a3plSk50YkFURnpDUGJSM1dJcGwrcjI1WkliaUlxaUx3Mjh0cDYz?=
 =?utf-8?B?Z2txWmJZbTRWZUF1VzVNNGc3eW9YU3VTZklMb2NWMWw4ZFQ0UXVVTDRVOHlt?=
 =?utf-8?B?T3NVRzlRK2N4a0xkdzBCd25nN2ladWExbDNnTitOcGNXcUo5aXNPZWtHSXdL?=
 =?utf-8?B?eHlldEFJeVpHc1FaUzBVZWt4M1RtMVFFb0dsM2VrZTNlSjIwb0N3S2twZWpH?=
 =?utf-8?B?cEZWRE16dm5TdlJiZnNWSk1SWFJaK1k0ZVpCdTd6c3I1RWdLQ0JteUhBcXc1?=
 =?utf-8?B?Rmpzd2FrSlV3VVgzSlBGQ1BYaVR0am1KTkUzRG16UXUraGZqaE1LTS8xeklZ?=
 =?utf-8?B?alNCRStYTE5JcEFLeDl0L2VTZ0FtVm04cmxsZGdtSUpSWENkeGRMU1BJUVVw?=
 =?utf-8?B?Qk0waDdGaGFob3BEZnMxN1RISmsweXBmL3g3UGE1WDZ3UlpwTVNPTU1MaWNO?=
 =?utf-8?B?b2JkTTZJS3pFK0NOUUtYR2gzNXNQWU5aa0lFL2xQOXIxTHc3UGtwRGRtdkxF?=
 =?utf-8?Q?RGr3EQLqcAAmZfQ3KV6syxfdG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bfdde200-f52e-40a3-4f86-08d9b9044d05
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3980.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 22:03:57.4191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fa0nBMTtUi1zfbTm5P/SkF/GFsKhQIDn9aYruv5LzjIg0rnfE6ieDVBSXlInyuHw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3995
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: lovM-TKEL_cIKhNtfcynVZgeZjBhYzJy
X-Proofpoint-ORIG-GUID: lovM-TKEL_cIKhNtfcynVZgeZjBhYzJy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-06_07,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 clxscore=1011
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112060135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/4/21 6:07 AM, Jiri Olsa wrote:
> Adding tests for get_func_[arg|ret|arg_cnt] helpers.
> Using these helpers in fentry/fexit/fmod_ret programs.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   .../bpf/prog_tests/get_func_args_test.c       |  38 ++++++
>   .../selftests/bpf/progs/get_func_args_test.c  | 112 ++++++++++++++++++
>   2 files changed, 150 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
>   create mode 100644 tools/testing/selftests/bpf/progs/get_func_args_test.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
> new file mode 100644
> index 000000000000..c24807ae4361
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "get_func_args_test.skel.h"
> +
> +void test_get_func_args_test(void)
> +{
> +	struct get_func_args_test *skel = NULL;
> +	__u32 duration = 0, retval;
> +	int err, prog_fd;
> +
> +	skel = get_func_args_test__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "get_func_args_test__open_and_load"))
> +		return;
> +
> +	err = get_func_args_test__attach(skel);
> +	if (!ASSERT_OK(err, "get_func_args_test__attach"))
> +		goto cleanup;
> +
> +	prog_fd = bpf_program__fd(skel->progs.test1);
> +	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> +				NULL, NULL, &retval, &duration);
> +	ASSERT_OK(err, "test_run");
> +	ASSERT_EQ(retval, 0, "test_run");
> +
> +	prog_fd = bpf_program__fd(skel->progs.fmod_ret_test);
> +	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> +				NULL, NULL, &retval, &duration);
> +	ASSERT_OK(err, "test_run");
> +	ASSERT_EQ(retval, 1234, "test_run");


are the other two programs executed implicitly during one of those test 
runs? Can you please leave a small comment somewhere here if that's true?


> +
> +	ASSERT_EQ(skel->bss->test1_result, 1, "test1_result");
> +	ASSERT_EQ(skel->bss->test2_result, 1, "test2_result");
> +	ASSERT_EQ(skel->bss->test3_result, 1, "test3_result");
> +	ASSERT_EQ(skel->bss->test4_result, 1, "test4_result");
> +
> +cleanup:
> +	get_func_args_test__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/get_func_args_test.c b/tools/testing/selftests/bpf/progs/get_func_args_test.c
> new file mode 100644
> index 000000000000..0d0a67c849ae
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/get_func_args_test.c
> @@ -0,0 +1,112 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <errno.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +__u64 test1_result = 0;
> +SEC("fentry/bpf_fentry_test1")
> +int BPF_PROG(test1)
> +{
> +	__u64 cnt = bpf_get_func_arg_cnt(ctx);
> +	__u64 a = 0, z = 0, ret = 0;
> +	__s64 err;
> +
> +	test1_result = cnt == 1;
> +
> +	/* valid arguments */
> +	err = bpf_get_func_arg(ctx, 0, &a);
> +	test1_result &= err == 0 && (int) a == 1;


int cast unnecessary? but some ()'s wouldn't hurt...


> +
> +	/* not valid argument */
> +	err = bpf_get_func_arg(ctx, 1, &z);
> +	test1_result &= err == -EINVAL;
> +
> +	/* return value fails in fentry */
> +	err = bpf_get_func_ret(ctx, &ret);
> +	test1_result &= err == -EINVAL;
> +	return 0;
> +}
> +
> +__u64 test2_result = 0;
> +SEC("fexit/bpf_fentry_test2")
> +int BPF_PROG(test2)
> +{
> +	__u64 cnt = bpf_get_func_arg_cnt(ctx);
> +	__u64 a = 0, b = 0, z = 0, ret = 0;
> +	__s64 err;
> +
> +	test2_result = cnt == 2;
> +
> +	/* valid arguments */
> +	err = bpf_get_func_arg(ctx, 0, &a);
> +	test2_result &= err == 0 && (int) a == 2;
> +
> +	err = bpf_get_func_arg(ctx, 1, &b);
> +	test2_result &= err == 0 && b == 3;
> +
> +	/* not valid argument */
> +	err = bpf_get_func_arg(ctx, 2, &z);
> +	test2_result &= err == -EINVAL;
> +
> +	/* return value */
> +	err = bpf_get_func_ret(ctx, &ret);
> +	test2_result &= err == 0 && ret == 5;
> +	return 0;
> +}
> +
> +__u64 test3_result = 0;
> +SEC("fmod_ret/bpf_modify_return_test")
> +int BPF_PROG(fmod_ret_test, int _a, int *_b, int _ret)
> +{
> +	__u64 cnt = bpf_get_func_arg_cnt(ctx);
> +	__u64 a = 0, b = 0, z = 0, ret = 0;
> +	__s64 err;
> +
> +	test3_result = cnt == 2;
> +
> +	/* valid arguments */
> +	err = bpf_get_func_arg(ctx, 0, &a);
> +	test3_result &= err == 0 && (int) a == 1;
> +
> +	err = bpf_get_func_arg(ctx, 1, &b);
> +	test3_result &= err == 0;


why no checking of b value here?


> +
> +	/* not valid argument */
> +	err = bpf_get_func_arg(ctx, 2, &z);
> +	test3_result &= err == -EINVAL;
> +
> +	/* return value */
> +	err = bpf_get_func_ret(ctx, &ret);
> +	test3_result &= err == 0 && ret == 0;
> +	return 1234;
> +}
> +
> +__u64 test4_result = 0;
> +SEC("fexit/bpf_modify_return_test")
> +int BPF_PROG(fexit_test, int _a, __u64 _b, int _ret)
> +{
> +	__u64 cnt = bpf_get_func_arg_cnt(ctx);
> +	__u64 a = 0, b = 0, z = 0, ret = 0;
> +	__s64 err;
> +
> +	test4_result = cnt == 2;
> +
> +	/* valid arguments */
> +	err = bpf_get_func_arg(ctx, 0, &a);
> +	test4_result &= err == 0 && (int) a == 1;
> +
> +	err = bpf_get_func_arg(ctx, 1, &b);
> +	test4_result &= err == 0;


same, for consistency, b should have been checked, no?


> +
> +	/* not valid argument */
> +	err = bpf_get_func_arg(ctx, 2, &z);
> +	test4_result &= err == -EINVAL;
> +
> +	/* return value */
> +	err = bpf_get_func_ret(ctx, &ret);
> +	test4_result &= err == 0 && ret == 1234;
> +	return 0;
> +}
