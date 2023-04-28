Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02536F1CAF
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346235AbjD1Qct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjD1Qcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:32:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7CD2D67;
        Fri, 28 Apr 2023 09:32:47 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33SA7Fxg013109;
        Fri, 28 Apr 2023 09:32:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=6qIGhxrzn4oy3Z9XU9tfCy+Br+vwd7yqIn2B3SSPfxQ=;
 b=KEMr9GwN9kcOhtjliTqJelhflDtlwhhXLKIfkcAmyL+b1ZnZowEZ4JSeH1wh93gP7wW9
 wUzA51Dh2SUFA/04XNoh5njc5CXDtmbwVxk0qHHFLxm+tlIyAodryTES4VgUYBICnutK
 XOhaxLVpZ4ysYTzWs+bbtjg6QcAF0LIe//0CtdhqB5Fn/X/amMAv3WTFbe8/hgBNhtnm
 SMavJGN24ilsolJ5a+TRS7PZkAegPW64tZTI060Lxp2Il50DiDjWHsB4CQxq6OaVfgl5
 k1GrieRky0mJCFUZWohMMZ6MEiLNzzhoRk17U8N/O6MiozD2hmf0pchaArVguP4OXuIA qg== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3q8452d52q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 09:32:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8p+lsBFdNVodhWrgJ/nJfGcdFEIt0YbMp54Uv3e6a9WEHSS/99V9vsvsi06gImvwCtBCEhhdnHjBllgEj58ECL8SXEPX8Ejrh5VhkqelRIZQ6BzDOu1EOyxGw7+YYdlv+qj7tP13zB5bNfcF7isGvE3x4lLkfoa8KEVNVgVKtTkPTnSUG3OalKVd2CgkmDIr3YwaOgYx+IvL/JCBv6nKZbiGyStkmEtBUJGICe9OXSMAcrHSupFQGMMmX3IctY+dEJ0W5XnQ8qED27YGFhSmcAcF8QmJM7AQV41wKoaoH7vYyi2ZtnsCL1OKPA8x8BAi1iJSrABXsJmp/ZstdTodQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qIGhxrzn4oy3Z9XU9tfCy+Br+vwd7yqIn2B3SSPfxQ=;
 b=CUSMWxfieldISv/XZPZvdLGFq13IvbZnH1QweSikvFEN9w1fbE0SZUhQ8+34GT9OphHW7rfytr3bYMgj+UAXRVykOjUW9qU9sZN0YssLlVkFZAjdlzJpUv5mQS1b1dis+QUBQTYuMrFDYLNVwEwOFysGK7Umw8WB7jPI22fW+6pRlsZnNkoA36MNpNYOpBx3Vd15toRNOy++JIUDahGPPWpBUFlcq8S3yFD3qHsCqtPBzKQuptwz+FpwsFa2Yf7CiyyzCOTpgjovmNVDeVY3Of5ZvwJ1EUVspSdewhp6ANNlP1VKeD8a2FUZaVUnu10ptD6ZP9ia8X6xnQEMwKJ7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by IA1PR15MB5418.namprd15.prod.outlook.com (2603:10b6:208:3a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 16:32:05 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 16:32:04 +0000
Message-ID: <218660da-f73d-d698-eb5e-f513379945bd@meta.com>
Date:   Fri, 28 Apr 2023 09:32:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH bpf-next v4 2/2] selftests/bpf: Add testcase for
 bpf_task_under_cgroup
Content-Language: en-US
To:     Feng zhou <zhoufeng.zf@bytedance.com>, martin.lau@linux.dev,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
References: <20230428071737.43849-1-zhoufeng.zf@bytedance.com>
 <20230428071737.43849-3-zhoufeng.zf@bytedance.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20230428071737.43849-3-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|IA1PR15MB5418:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cfa5530-89f1-45a9-1c36-08db48061a00
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 41Ekap60WvWGWIzw6M6yjntf01RXqe7ckdInH1LEdAVoD1hj0FruRCjaCxzmmOxUlB0XoutBMlQdG3etjMG3WlZduZlxdI6FMWd17a9OYoFzpCqLlLr3tdoS1B1C7GAoWcL/rkU7IrTu15TtUxqgW2UnUqtDLHQsCo5TrM5In7Nw9cOTYoK0MHjjMtmplyszjXFYCuotm7zSfxA0PLJjbsSvbkuajM51BJl2YPcD8FkozfyD2prU1U36u3eJqeDNXrE6QT5bUfJxcJh7JwOeGByY0uifv8Y9mS5CKjvUWxCurm603M9cJz5Okg9YZjP7dEKz+yQz0GxIJUBFnj+iYVvYsY3hZRkGgFseoDMGQOrLPC4HUatPIlPYrnh+N+lz7tMesFsXJBdzkZuw/J6LDQVdePY1/zvVyO0lpEtO8Req2GGCM+3su8BV8KKml11o/YYzsn8A/9vPT2c0y9DbYhed/E43P1xljO2qKK4g0ZFxqs7hfI/dHaGi7uAm/+6adeEDBy/Ov0vmSfMj6O737ukzSX1lcbheCb7QN56ArCpBnY1vcR4HrQ71hFYPuR1a8An76PCtPb9tsG79zR1PvYRqXvm8TAo7K4gZQ/YWVr/Vspofh4x6tov4Hiakws9raGqu+Mc6RPUZBO/tlba41PH8sN2vSlKB+dvT4hrvdcs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(86362001)(2906002)(31696002)(36756003)(31686004)(6486002)(6666004)(2616005)(83380400001)(53546011)(186003)(6512007)(6506007)(66556008)(66476007)(921005)(66946007)(478600001)(41300700001)(38100700002)(5660300002)(4326008)(8676002)(7416002)(8936002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTB1aXhRRWFyMURVS0FFSTByZ0VPbEl6c3RwS2RKUWtDVzlISUwwTTZJK2Nt?=
 =?utf-8?B?N1A3YjcrajZ5eUFkbnFvZlBtcVpjOFhCY1dFNWhrdXhrQkdEemtnemUvVjll?=
 =?utf-8?B?c25Nd0tYTFY5dU56WVJqUUh0VlJHV0ljUzUvRVNjTkhIWkc2VmV2ei9xZ3FX?=
 =?utf-8?B?YlJ6Y0Z1QWpaWGFhTkkveHF2eGYzUUlWaWJxeldzRUs3c2txZVVyem1mWUlN?=
 =?utf-8?B?UGk2Ymt0SEVDTzkxa0h6RFhUKzl4MFR6Z2tBVXVLckhQOTBkWk9jcHl2RExp?=
 =?utf-8?B?MlpPQmV4UVA2SStyWDdNbThOQWJ4R21wQnZsVzdOSE8yZVJHT2hvbVFONEpp?=
 =?utf-8?B?ZEdWREFROENYWGFMWktsWUYrRy9rbElQU2QwaUxwTUM3bzlJdFlFL1IxNnE3?=
 =?utf-8?B?UmtkZG40RnBRbnhtVUdzR2djamNsRkdvRnlQd3VFSDNsbFhyL1pvblJXdWhx?=
 =?utf-8?B?QitEOUNaa2VHRkp1WGs0Y2daK1lESHN4T0RrUjJkVGJjMVl4aG05YjhjeVRF?=
 =?utf-8?B?dCtJVjlrUm9sMG9yTGh5RkNTQ2RuQlN0ZXRwVVRJNGEyQld0eEYwS05LSGds?=
 =?utf-8?B?VG5BMFhtTm8wTys5OGU0VHRKZFp4djVPTFY4cEhWU3IrR25vR0JiNTZvdHUy?=
 =?utf-8?B?NTYwb1J4dTMyckFOQjE2b1VWVFViTFA5bVhWNGh2anFKUnVWZDlJRUZzTEQz?=
 =?utf-8?B?cXR3R203YVJyNGIvSDVvYlhZNnNoNStoKzJXUFE2NldwMlRaSXl2cU9KMTZW?=
 =?utf-8?B?bC9GRXQvMmF4RDJLaEMzSmJTRC9vUVBvRWc5TVUrVGlUelFGS3NXMDRPNUVE?=
 =?utf-8?B?c1Z1Z1BUVGpPNGtTU2x4Y3U0dlJKNDZvZFJicEhFWS91UzY4OER1Y1lKV0d2?=
 =?utf-8?B?bWpueFpNdE5tbUkxVGpFQjZ5S0hwRWlrOGhtZmFSMjYyVmpBWk9uM0JxekhV?=
 =?utf-8?B?ZVB2d3VZS1dyU3RTZTA1K3h4aTN6VXJLTmc3Zkt1dWo5WVFvbEFFdlV4NUd2?=
 =?utf-8?B?eGs3Y0RjUVRHYmVlcDB3NHc5WGVzcDV2dHEwWm5ENWwvM3J2SEFkdnhXY1ht?=
 =?utf-8?B?S3RRZnUzdUxuNmZTV0ZLTjNrSTlxSWQyMElTYTlnTnh0ZGYxL0g5dktxRjZX?=
 =?utf-8?B?bVJWUU12bnh4bVNIN0E4dDV5K2M1WGsxelRaY3dnWlNrdm0veTAzZXdkOGoz?=
 =?utf-8?B?OXA1RjRLSDlaaGI1Yk5EWVR3c3FuUS96YzU4TU1BTEk1V2pTd3BFaks3eHBk?=
 =?utf-8?B?RHhLN0NlVXVrVjNEMkNjalQwVTFTVkR1TlJVREpHcWNTT1ZFZmE4Q0txSWha?=
 =?utf-8?B?YStiMkU5M0prUTRVM3F0T1hHWk1waVhSbWptNGw4Y0ZXbG5SZm0xcGIxWCtE?=
 =?utf-8?B?Mm1KNlk4Q1diVUlhYTY4Y1ltdnJLSC94eDNFejd4aFNudDZVT1IzQ1EyaGZh?=
 =?utf-8?B?UnAvRDd6VGxaN3ltaEd6K2NSR1FHWWF1MkhQdk5KaEhmMTlxZUNtNEdsQTNT?=
 =?utf-8?B?bld1S0xYOFBKOHNobm1xZ2VFZ3dyMG1WeDRhWElaWXNscDhteXQvenBVRW9S?=
 =?utf-8?B?VUpkeDNOZkpjanlTdkRKa3hNaC9leU0wZ1hFbFBpQUNJVDNtbkxYM0JYQnEy?=
 =?utf-8?B?QTdMZ3B1dXlOdzVycUJJdk5DbUo2OC82cEZyM1d3MURlczRjUGVGZ09IeTYz?=
 =?utf-8?B?eW5YU1FEb3FWdDZmcHVBdFZuR01hb2pTazlXZEJOLy9pQU1CVjBkYll1NVgx?=
 =?utf-8?B?b2hLV1cxSDA1ZmZxZTVBSVhjRnNvVHNhTklxLy9Ib05xNXhmRndqSC95bDY5?=
 =?utf-8?B?TE0yclBleXRqeksxMm5uWFgzNHk0T01WWEhmaEpsS1ZJUW5tWVkxVXdwUlFP?=
 =?utf-8?B?YnNyZGV4MHd1SWFQa2szbFVlclMvT2YvanlNSUg2WEdPWVRPQXI5NFJVcTM0?=
 =?utf-8?B?alJCaWpDRlF5T1lyS1c5ZHk5NlJCWHo1dDBETDR6K2NyTEYxaHhDWTkwSGdZ?=
 =?utf-8?B?WnZvRC8xejkrbEdBZDhadWxDSHR6dDZxZlNPZkh1YWo5RXBzLzdvUHpyMStF?=
 =?utf-8?B?VWt3TnltTXdQRmloVzg2cGRBWVZmZ2VYdUtjQ0J4K1FnMTdLd1NjdWgyalFq?=
 =?utf-8?B?bE9hcmZveHdsb25MZzBaTGlvdkMyMkNXWjF1RXFkQk9QYmxuNzRUY1VHeHFQ?=
 =?utf-8?B?Y3c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cfa5530-89f1-45a9-1c36-08db48061a00
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 16:32:04.8229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHCJ5xft+lzYv5PJfr6dABtcDa47S+2bkiQwJdWm78RFKsGq//Zi6LkRixsnG50Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB5418
X-Proofpoint-GUID: ItCQENiLhfEAvbiXrrgHshzmK6RE33yU
X-Proofpoint-ORIG-GUID: ItCQENiLhfEAvbiXrrgHshzmK6RE33yU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_04,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/23 12:17 AM, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> test_progs:
> Tests new kfunc bpf_task_under_cgroup().
> 
> The bpf program saves the new task's pid within a given cgroup to
> the remote_pid, which is convenient for the user-mode program to
> verify the test correctness.
> 
> The user-mode program creates its own mount namespace, and mounts the
> cgroupsv2 hierarchy in there, call the fork syscall, then check if
> remote_pid and local_pid are unequal.
> 
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>

Ack with a few nits below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/testing/selftests/bpf/DENYLIST.s390x    |  1 +
>   .../bpf/prog_tests/task_under_cgroup.c        | 55 +++++++++++++++++++
>   .../bpf/progs/test_task_under_cgroup.c        | 51 +++++++++++++++++
>   3 files changed, 107 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> 
> diff --git a/tools/testing/selftests/bpf/DENYLIST.s390x b/tools/testing/selftests/bpf/DENYLIST.s390x
> index c7463f3ec3c0..5061d9e24c16 100644
> --- a/tools/testing/selftests/bpf/DENYLIST.s390x
> +++ b/tools/testing/selftests/bpf/DENYLIST.s390x
> @@ -26,3 +26,4 @@ user_ringbuf                             # failed to find kernel BTF type ID of
>   verif_stats                              # trace_vprintk__open_and_load unexpected error: -9                           (?)
>   xdp_bonding                              # failed to auto-attach program 'trace_on_entry': -524                        (trampoline)
>   xdp_metadata                             # JIT does not support calling kernel function                                (kfunc)
> +test_task_under_cgroup                   # JIT does not support calling kernel function                                (kfunc)
> diff --git a/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
> new file mode 100644
> index 000000000000..5e79dff86dec
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
> @@ -0,0 +1,55 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2023 Bytedance */
> +
> +#include <sys/syscall.h>
> +#include <test_progs.h>
> +#include <cgroup_helpers.h>
> +#include "test_task_under_cgroup.skel.h"
> +
> +#define FOO	"/foo"
> +
> +void test_task_under_cgroup(void)
> +{
> +	struct test_task_under_cgroup *skel;
> +	int ret, foo = -1;
> +	pid_t pid;
> +
> +	foo = test__join_cgroup(FOO);
> +	if (!ASSERT_OK(foo < 0, "cgroup_join_foo"))
> +		return;
> +
> +	skel = test_task_under_cgroup__open();
> +	if (!ASSERT_OK_PTR(skel, "test_task_under_cgroup__open"))
> +		goto cleanup;
> +
> +	skel->rodata->local_pid = getpid();
> +	skel->bss->remote_pid = getpid();
> +	skel->rodata->cgid = get_cgroup_id(FOO);
> +
> +	ret = test_task_under_cgroup__load(skel);
> +	if (!ASSERT_OK(ret, "test_task_under_cgroup__load"))
> +		goto cleanup;
> +
> +	ret = test_task_under_cgroup__attach(skel);
> +	if (!ASSERT_OK(ret, "test_task_under_cgroup__attach"))
> +		goto cleanup;
> +
> +	pid = fork();
> +	if (pid == 0)
> +		exit(0);
> +	else if (pid == -1)
> +		printf("Couldn't fork process!\n");

ASSERT_* is preferred compared to 'printf'. Maybe ASSERT_TRUE(0, 
"Couldn't fork process")?

> +
> +	wait(NULL);
> +
> +	test_task_under_cgroup__detach(skel);
> +
> +	ASSERT_NEQ(skel->bss->remote_pid, skel->rodata->local_pid,
> +		   "test task_under_cgroup");
> +
> +cleanup:
> +	if (foo >= 0)

"if (foo >= 0)" is not needed. 'foo' is guaranteed ">= 0" as this point.

> +		close(foo);
> +
> +	test_task_under_cgroup__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> new file mode 100644
> index 000000000000..5bcb726d6d0a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2023 Bytedance */
> +
> +#include <vmlinux.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#include "bpf_misc.h"
> +
> +struct cgroup *bpf_cgroup_from_id(u64 cgid) __ksym;
> +long bpf_task_under_cgroup(struct task_struct *task, struct cgroup *ancestor) __ksym;
> +void bpf_cgroup_release(struct cgroup *p) __ksym;
> +struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym;
> +void bpf_task_release(struct task_struct *p) __ksym;
> +
> +const volatile int local_pid;
> +const volatile long cgid;

cgid cannot be a negative number. So let us do
const volatile __u64 cgid;

> +int remote_pid;
> +
> +SEC("tp_btf/task_newtask")
> +int BPF_PROG(handle__task_newtask, struct task_struct *task, u64 clone_flags)
> +{
> +	struct cgroup *cgrp = NULL;
> +	struct task_struct *acquired = NULL;

"acquired = NULL" is not needed. Just do "struct task_struct *acquired;".

> +
> +	if (local_pid != (bpf_get_current_pid_tgid() >> 32))
> +		return 0;
> +
> +	acquired = bpf_task_acquire(task);
> +	if (!acquired)
> +		return 0;
> +
> +	if (local_pid == acquired->tgid)
> +		goto out;
> +
> +	cgrp = bpf_cgroup_from_id(cgid);
> +	if (!cgrp)
> +		goto out;
> +
> +	if (bpf_task_under_cgroup(acquired, cgrp))
> +		remote_pid = acquired->tgid;
> +
> +out:
> +	if (acquired)
> +		bpf_task_release(acquired);
> +	if (cgrp)
> +		bpf_cgroup_release(cgrp);
> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
