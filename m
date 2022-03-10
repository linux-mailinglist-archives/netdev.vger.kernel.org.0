Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3700E4D553A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344275AbiCJXXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbiCJXXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:23:09 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3E5177D21;
        Thu, 10 Mar 2022 15:22:07 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22AJagqO012089;
        Thu, 10 Mar 2022 15:21:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=q04m0uzIe6eXJ9tor2hg0X/duWLqSuBpTg99jvH4E64=;
 b=qFWnHvKJvLc6dqim0Txzi9GCYuY6Fwj76qS/Flx3Gpkvmc1wQ5gPVQJ/Q1CbeTdtuvM9
 +Za0yCmMMdpEdihiwvxO6uhPLWsdL2hwMck+k2Xpy8gI1d44psScrPjJjoKcEPoO9LMK
 sgK9ISvJ2dZK2R8L6S5Qy8m9orclzUfeuJc= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by m0089730.ppops.net (PPS) with ESMTPS id 3eqqn21f3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 15:21:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEUIGQV6mG8ysaqaBAqFGFMV031WJeDeswCk+vr4MLtJ08XVQdADGd9Evn09zcv7NqzNbVUXN3mH46cJ2aCQTEHHA2IsLCNgTBgysMJLKHkWtC87U7McdTrFAaCv8owRTowwEHydwuGDhUi4VylZs+hwN594/kjJPKM+KICrG6/38+szOj+J+0HFgXNCtenSX3MqX7g6liByNcqcXlsnYo0lHTbr6yaCDe02IxPtySwSIDBZabaJsYG4IdwMgskrgQD4j/4e6TCGiRR6wf+JmLDBtTXfvrsPk1h4S4hsmBbyH/ZkIQG/QfBH7WiXxjZejl4a2cGdo9dOiQ0uXK6QNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q04m0uzIe6eXJ9tor2hg0X/duWLqSuBpTg99jvH4E64=;
 b=lRWPT/z7PhZMtc6Mw5ijymM47tlC8BaixrWsqhivuhk0sV+xkR4oR6S3R4MRCmoxUL6Y13ZvhMyo0XzDmBJn9SMoK9MYo+nextnNRpfZdTVf9VToBreRseaH0OvbQ7HqYEksNF1F27xA9KQoMCFWM634RNuyYqDEq76yjjcdptnc1K61ET1d0gn7C71jWBkerFz6RjuAnnOxUhywxJpzjwq9Y6RRabi+qbk1HG0wr70vnhbuOkd2uTitexvPshMlLoz6as1TnRgZWdzXn6Pnu5l7U6F/xB1k2hkRl7JWvZTFy1+OdONUk6qSVFuZgPUmOlrsbf3gTt81ePeDm5w2Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3853.namprd15.prod.outlook.com (2603:10b6:806:84::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 10 Mar
 2022 23:21:21 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48%4]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 23:21:21 +0000
Message-ID: <da714be4-3d65-0df5-b60e-37882524ebeb@fb.com>
Date:   Thu, 10 Mar 2022 15:21:17 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH 2/2] bpf/selftests: Test skipping stacktrace
Content-Language: en-US
To:     Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eugene Loh <eugene.loh@oracle.com>, Hao Luo <haoluo@google.com>
References: <20220310082202.1229345-1-namhyung@kernel.org>
 <20220310082202.1229345-2-namhyung@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220310082202.1229345-2-namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b192e4c5-5b2c-43e5-65f9-08da02ecafc0
X-MS-TrafficTypeDiagnostic: SA0PR15MB3853:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB3853859C500B394059E2B4B1D30B9@SA0PR15MB3853.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnOMPgJyEof1VKRxnCPX7P/U0rysn/gNmDhAqJhNctAVo1qbzO8FTHNYDuzQ7X50001Yzugd5XfIulaAhKDJx4+7U6deizc/ts46C6LVyJa2MuycNDFlAL32YgRe2eCUOQohC6Q7GPYC0LXw4LWDIS+GzIAD+9XlNvqvVBEkHJzIGWaVgA6bu/rvG5Pfa4ZKdtfdpzZUsSMAePC3wiw3jidKtnTj6Vk6HYhYNCHt8haNsFvfjhl4yWNh1cLH1/0Wv1pWsaAIpcrf2NOi9AheX1sLJzN2YwZaTeNRF2uLOmrM4P2ubveFTq+VG7X0AtSHEGs33SxJJqug+Cfn3fCbojnPTKgG7pOFid1DbMXb6xBAlYfkfMkMxcQguCUk40URjkR7A+q8GxFa0OEX3ABouOW6oSkCGycNjzim7neNjsQ0dcR+SxQnMug+LMDBLfSvHh7ScqAtHnpPtk+y8BxuNEmpWPcSKkr3dASUZTosJenkRPVLjKhoIxn2VLe5twYut1EMt8aAv6iH6NAdkEml9gKx9hq46cnnQwvwe2LT5jGl1Qs5GY3FRbWcoIfNSMpOpKSDkzsjUCcw0fT+BAcYvziVJqAV+jsBAZc7Bhe9oCXA7H/nriq224c5OZFwbv8jtRlsyK0e9Gvig5WH38A1rAWVYP/SyMlLtl3fvWjFJrqmgYGz5lVgTwRLIyzKr2PNh8VVfEXaH5gMsYnSqOXDGrIhEVsJcDBgpiHxEgkzkgee44Fzxf/yKhnCpVGOVJ4C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(31696002)(4326008)(66556008)(508600001)(66946007)(8676002)(66476007)(6486002)(8936002)(5660300002)(6666004)(6506007)(53546011)(36756003)(31686004)(52116002)(86362001)(186003)(316002)(38100700002)(2906002)(6512007)(110136005)(2616005)(54906003)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1ZESWU0eHNyQW94dzVlb0dRcjYweWhPeUhjMmZrMmZUV1p0UHh5V01tdzFV?=
 =?utf-8?B?NU93cUF4YWRhMzc3RWlMVUN1OCtuTU1Wa1gwbnhEMlBFUFI5Y1Zkb3NTMStM?=
 =?utf-8?B?TFlpOGEzR2V4VS9Xbk9YWVh1ejhQYzJqeThTbE90bmdUMFhVMFh4VWZCbG4v?=
 =?utf-8?B?L2k2RTZZTHlzVWMyU0JZYVJKVlhTdFdmS3Q0SWlnRzFjRmphd0ZGUjdONXJi?=
 =?utf-8?B?M3FiRGQ2YktIenRFNjhnMHFKRUJKZlc5NFJpZm9nOGwyUVZBNjk2a3RhTlkx?=
 =?utf-8?B?Y2tNeFJ5bFd0OERDVlpiMG1QRStmanpNQ1pFSDN0cXBZZ3psV05weU5mNHRD?=
 =?utf-8?B?UEpHYnJROW5LVGNmTnNhVzNtS2g4Z1VEMHFrWGJWdWdtUG5CSzZzZGk5c1Mz?=
 =?utf-8?B?TjkvM2dzSUQwUDh4RlpnSUd5T3pwNGJKVFRSYUpuV2xYTGRXblFaYzBpdk1i?=
 =?utf-8?B?ZjFISlJibW80ZmNjRWdidXdKeHJlTHdmWWNXV2hpcUVSWnNwVjljTnBVTEg1?=
 =?utf-8?B?WGZqWk5QRytjVkxzY08xZVpKQ1FMclhtQjZURERKU1lDUHFsUmlNb3FmWkZr?=
 =?utf-8?B?dndqajA0WXMxTC9xZjdjUkhwczlCSEFaOXAxcVVuNk9jMk1jQTNTaU8rZ1Vl?=
 =?utf-8?B?QnhVanpoMkF4L05UYlJqeklpL0lvWGc1Z1Q3cGo5ZVNkbDM4U1ozNUZQVTJP?=
 =?utf-8?B?SnYxLzF4d3ZkRk8zQ0NsQ25Vd043YXdPTzMyUlZIc2pRanc0ekVyYU1pb1lX?=
 =?utf-8?B?cEswWEZ1bXl4Tkxhb0xZNEZrWXJZTlE3cVQ1TmN6NkhIZXA3cWtaWU05eks0?=
 =?utf-8?B?YzBJWjBNOTBKQzBjUmw0V0FpWW1SWHR6OXR2cjczSVM2dVRDKzBmVytJeTA5?=
 =?utf-8?B?djRkSGtPZEE1RW5tS1JrQldiczFKcmN0N2ord0tTWExNVThlTDVjUHN3S3lW?=
 =?utf-8?B?b3NOWElueHl2ZGp6Y1JnYmJXb0dFZ043OHV0dms3eWdEVmF5UXRHN1A0SitG?=
 =?utf-8?B?TEo5S3lISnZFSGd6N01NeWhkR3BBeEt5dWZnaEh1UHpyd0xWNERjRE8xd3hS?=
 =?utf-8?B?VEhvR2pwZWFETWhSZFdUV2FYVzF2RCt0bFdMeVhhVjU0dHZ3MmNib1NmUU1h?=
 =?utf-8?B?aVNoVGdiY0wzZm5URVhpWHE4V3J0QUgranZ3allscUI4RFZtQjNCOWJGOHA2?=
 =?utf-8?B?eG9oZ0U2dHI1UytvdTlmamlRNnY5WEQvSXhWcHZabDYwck9vZnZYNlJlZFVZ?=
 =?utf-8?B?c0hEcDFoNWlZY0dyZW14S3JycVFVWWZyOVVzeVZ2QUdNamlVdjR6eUY2Yml5?=
 =?utf-8?B?Y0dFNkJjTWthcm5BVHRST1gwYWZ0SUZOR1pkYjNZV0tDa0k2bjNRTkpPQi8x?=
 =?utf-8?B?dHlMbWRMYm1tVElwcldYbWVLRWx3TGMwd2V3NUsyVmc3UnA0K2NwaytBTkhs?=
 =?utf-8?B?ZTV5WURNbHM4TUxIMXNTTWo1UnZkS0xJZlY2UTdrdUUvUTZjdC9peEY4Ymhv?=
 =?utf-8?B?RjEwTVJnaE1EeFpwUng3Zk5hV0dwNVBlMkhHb2dnSHhJUnRuV09XcTF3cm1z?=
 =?utf-8?B?SzJQMjZYSkhKQ1R3Q1JYRG1iZVQ1V0FYK2taWjRsMVNudWZPcTNTMlRyR0Zl?=
 =?utf-8?B?dXVkM2paOFl2Mk0vL3Jrd3UvcGQrTWNGTmp5d1B3THhQOXdiaHpRSGFkOU1p?=
 =?utf-8?B?WFZLemx0OGlQc1dUL05PUzlFdFl5eHRFUFhaN0gxK09hS21FYS9ka004WFR2?=
 =?utf-8?B?K3RxVERZYzRXN3B5VllhWlNVVExWeTFaZk5BVW5kdEFPQ2lZUWhBalFGS3ZE?=
 =?utf-8?B?UmRMWnJpZWdydEp3TzNKNW03a1hveGpTV0p6N1FmMFBNcytISHFreG92N1JU?=
 =?utf-8?B?c3FuUVFBckVCV1BxZzRKVkdMV0k3TDc3V3pNLzNtZlRpd29KZjErck9wSnlo?=
 =?utf-8?B?TGVPWWFjTzEzbHhvVTA1L0hwNEFhTFQzOWJZclhUbnhBYzM5MkYwcXNNSFR2?=
 =?utf-8?B?ZG1VY2VMWjBBeXRwenQ1T1dYclRnMU1PYmpKM3NtdVFsaWVmV2cvM0pNdllr?=
 =?utf-8?B?M2VqUGlaWjlzNmV0dkpZTmpCMVErNmJaV0dWMDQwZTVsU0Fsa2JLRG5BS3ov?=
 =?utf-8?B?SW1teHl0aXUra0JjKzM1dHNjMFhtUm5CQXI4bTJ0M1IxazcxTnZkbGdsbTY0?=
 =?utf-8?B?d2c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b192e4c5-5b2c-43e5-65f9-08da02ecafc0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 23:21:21.2224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZzrUPkRECrUeZO2i3GACy4hupAjTxD2GPo/v8LQuiu0fKVEVXf63twqUbjJ0y+zI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3853
X-Proofpoint-GUID: HnQZFLGkkwCUBrd26_H3TIC2h_XFF5Mh
X-Proofpoint-ORIG-GUID: HnQZFLGkkwCUBrd26_H3TIC2h_XFF5Mh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_09,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/22 12:22 AM, Namhyung Kim wrote:
> Add a test case for stacktrace with skip > 0 using a small sized
> buffer.  It didn't support skipping entries greater than or equal to
> the size of buffer and filled the skipped part with 0.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   .../bpf/prog_tests/stacktrace_map_skip.c      | 72 ++++++++++++++++
>   .../selftests/bpf/progs/stacktrace_map_skip.c | 82 +++++++++++++++++++
>   2 files changed, 154 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
>   create mode 100644 tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
> new file mode 100644
> index 000000000000..bcb244aa3c78
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
> @@ -0,0 +1,72 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "stacktrace_map_skip.skel.h"
> +
> +#define TEST_STACK_DEPTH  2
> +
> +void test_stacktrace_map_skip(void)
> +{
> +	struct stacktrace_map_skip *skel;
> +	int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
> +	int err, stack_trace_len;
> +	__u32 key, val, duration = 0;
> +
> +	skel = stacktrace_map_skip__open_and_load();
> +	if (CHECK(!skel, "skel_open_and_load", "skeleton open failed\n"))
> +		return;

Please use ASSERT_* macros instead of CHECK* macros.
You can see other prog_tests/*.c files for examples.

> +
> +	/* find map fds */
> +	control_map_fd = bpf_map__fd(skel->maps.control_map);
> +	if (CHECK_FAIL(control_map_fd < 0))
> +		goto out;
> +
> +	stackid_hmap_fd = bpf_map__fd(skel->maps.stackid_hmap);
> +	if (CHECK_FAIL(stackid_hmap_fd < 0))
> +		goto out;
> +
> +	stackmap_fd = bpf_map__fd(skel->maps.stackmap);
> +	if (CHECK_FAIL(stackmap_fd < 0))
> +		goto out;
> +
> +	stack_amap_fd = bpf_map__fd(skel->maps.stack_amap);
> +	if (CHECK_FAIL(stack_amap_fd < 0))
> +		goto out;
> +
> +	err = stacktrace_map_skip__attach(skel);
> +	if (CHECK(err, "skel_attach", "skeleton attach failed\n"))
> +		goto out;
> +
> +	/* give some time for bpf program run */
> +	sleep(1);
> +
> +	/* disable stack trace collection */
> +	key = 0;
> +	val = 1;
> +	bpf_map_update_elem(control_map_fd, &key, &val, 0);
> +
> +	/* for every element in stackid_hmap, we can find a corresponding one
> +	 * in stackmap, and vise versa.
> +	 */
> +	err = compare_map_keys(stackid_hmap_fd, stackmap_fd);
> +	if (CHECK(err, "compare_map_keys stackid_hmap vs. stackmap",
> +		  "err %d errno %d\n", err, errno))
> +		goto out;
> +
> +	err = compare_map_keys(stackmap_fd, stackid_hmap_fd);
> +	if (CHECK(err, "compare_map_keys stackmap vs. stackid_hmap",
> +		  "err %d errno %d\n", err, errno))
> +		goto out;
> +
> +	stack_trace_len = TEST_STACK_DEPTH * sizeof(__u64);
> +	err = compare_stack_ips(stackmap_fd, stack_amap_fd, stack_trace_len);
> +	if (CHECK(err, "compare_stack_ips stackmap vs. stack_amap",
> +		  "err %d errno %d\n", err, errno))
> +		goto out;
> +
> +	if (CHECK(skel->bss->failed, "check skip",
> +		  "failed to skip some depth: %d", skel->bss->failed))
> +		goto out;
> +
> +out:
> +	stacktrace_map_skip__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
> new file mode 100644
> index 000000000000..323248b17ae4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define TEST_STACK_DEPTH         2
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__uint(max_entries, 1);
> +	__type(key, __u32);
> +	__type(value, __u32);
> +} control_map SEC(".maps");

You can use a global variable for this.
The global variable can be assigned a value (if needed, e.g., non-zero)
before skeleton open and load.

> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_HASH);
> +	__uint(max_entries, 16384);
> +	__type(key, __u32);
> +	__type(value, __u32);
> +} stackid_hmap SEC(".maps");
> +
> +typedef __u64 stack_trace_t[TEST_STACK_DEPTH];
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_STACK_TRACE);
> +	__uint(max_entries, 16384);
> +	__type(key, __u32);
> +	__type(value, stack_trace_t);
> +} stackmap SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__uint(max_entries, 16384);
> +	__type(key, __u32);
> +	__type(value, stack_trace_t);
> +} stack_amap SEC(".maps");
> +
> +/* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
> +struct sched_switch_args {
> +	unsigned long long pad;
> +	char prev_comm[TASK_COMM_LEN];
> +	int prev_pid;
> +	int prev_prio;
> +	long long prev_state;
> +	char next_comm[TASK_COMM_LEN];
> +	int next_pid;
> +	int next_prio;
> +};

You can use this structure in vmlinux.h instead of the above:
struct trace_event_raw_sched_switch {
         struct trace_entry ent;
         char prev_comm[16];
         pid_t prev_pid;
         int prev_prio;
         long int prev_state;
         char next_comm[16];
         pid_t next_pid;
         int next_prio;
         char __data[0];
};


> +
> +int failed = 0;
> +
> +SEC("tracepoint/sched/sched_switch")
> +int oncpu(struct sched_switch_args *ctx)
> +{
> +	__u32 max_len = TEST_STACK_DEPTH * sizeof(__u64);
> +	__u32 key = 0, val = 0, *value_p;
> +	__u64 *stack_p;
> +
> +	value_p = bpf_map_lookup_elem(&control_map, &key);
> +	if (value_p && *value_p)
> +		return 0; /* skip if non-zero *value_p */
> +
> +	/* it should allow skipping whole buffer size entries */
> +	key = bpf_get_stackid(ctx, &stackmap, TEST_STACK_DEPTH);
> +	if ((int)key >= 0) {
> +		/* The size of stackmap and stack_amap should be the same */
> +		bpf_map_update_elem(&stackid_hmap, &key, &val, 0);
> +		stack_p = bpf_map_lookup_elem(&stack_amap, &key);
> +		if (stack_p) {
> +			bpf_get_stack(ctx, stack_p, max_len, TEST_STACK_DEPTH);
> +			/* it wrongly skipped all the entries and filled zero */
> +			if (stack_p[0] == 0)
> +				failed = 1;
> +		}
> +	} else if ((int)key == -14/*EFAULT*/) {
> +		/* old kernel doesn't support skipping that many entries */
> +		failed = 2;

The selftest is supposed to run with the kernel in the same code base.
So it is okay to skip the above 'if' test and just set failed = 2.

> +	}
> +
> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
