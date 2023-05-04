Return-Path: <netdev+bounces-287-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CDFB6F6DF5
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2904280D4F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 14:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980FD79D2;
	Thu,  4 May 2023 14:47:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8349B79D0
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 14:47:23 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAC61A8;
	Thu,  4 May 2023 07:47:21 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 344CQ3ES013210;
	Thu, 4 May 2023 07:46:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=3eOdXs7Fq33Z5QZNR2BQDcHSXudPVjPdqZey3eiuf+w=;
 b=RHcmmfF/VA+6uyW34rYXm+Nz0/WwsP5LI2qdHTwBsPiyWX6BevCYAVXFXSv3GvUuJUFT
 fwa5vSx/xw4ltAflvj+cToqR3QQomiw8/624h5065fF/wYPedt9v3qh/IBUSGgiPPH4x
 MrCTkcwLyG3HOBehzm1+OQVmlr27JJNPCCH9rxa9xpUHwcY3shCVMHm14AF4ontob6f7
 VCSVNh4AGXtx5W7se+S9jJgA/tzSlrbK3crweKYHq4x6GJhl5+QSD/Sjopq0WZnI1TLy
 pYb3mhOYNiy5jM8W7PVamGTPTvDAKrmvuQBLVouxeCNl7GQg9BH1gHETmHLwLPaBwc0C NA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2045.outbound.protection.outlook.com [104.47.57.45])
	by m0089730.ppops.net (PPS) with ESMTPS id 3qccq00vn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 May 2023 07:46:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNxczRSdr7tNsZJakZdChGvNwtZJiRQqmmI9Rc0icZ1JPs9i1y3rt6g0KAwCEjo6xOvx5yPRoSxPy5cINaVCNVozzp/JgCB4pxRSyB2QxQmYQ3qmsGCfhrG7xBaATNI/BrPwwMdrVAJGcdINQ26Ano1AMfziD5MIhVVPmOCz8gNRDfKZxseoxBTkFuLi08jUar+erSy1PkNOrzupOhHntuNET1O1NRaquhivmxkWHZ9GNVG0U/S6F7bhoSU6KajfWiXoj4tcQwoFh0Lsb+kGqQm4esf776qlMi7q3lWaX62jJA3hrqXAnoSxJm8l0Rox9gXBkg9f+D2gac8j9tu5QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3eOdXs7Fq33Z5QZNR2BQDcHSXudPVjPdqZey3eiuf+w=;
 b=GP7VTLhKZNQl0N75HBu3GFnlzDBd57MiDoJpeDK9LhfcLmMGrJEFS8W9OsM2X1yTJ6ee4yUIwdsFX0LyUt1nZvrNFvHUYaDvAMe0YgJcFrIc9CEONm+QTlwTrRX9k0JPTuuLuEi92uWNGKQldMCNjS+wGdSPlfVh7OQH3PF0mAtss+ZjXNcoIBU4z0WDPP9JxDx8IISyeTq1kvZtg/l/0ypISikpV3mBqNPB0McjwzKVcnaMllCIXeyEGb81BsBn0KYMpnqWRU3PgX2klKbGbx8eQYDMQgUsYXfa+OOuWdWmdlWVLbMk40DDvoNp2tJxIfLF6LdD2FqN6jJuiosxlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BY1PR15MB5957.namprd15.prod.outlook.com (2603:10b6:a03:52b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Thu, 4 May
 2023 14:46:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 14:46:43 +0000
Message-ID: <63138022-e28f-a63c-6f4c-61b61e585641@meta.com>
Date: Thu, 4 May 2023 07:46:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH bpf-next v5 2/2] selftests/bpf: Add testcase for
 bpf_task_under_cgroup
Content-Language: en-US
To: Feng zhou <zhoufeng.zf@bytedance.com>, martin.lau@linux.dev,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
        wangdongdong.6@bytedance.com
References: <20230504031513.13749-1-zhoufeng.zf@bytedance.com>
 <20230504031513.13749-3-zhoufeng.zf@bytedance.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230504031513.13749-3-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0164.namprd05.prod.outlook.com
 (2603:10b6:a03:339::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BY1PR15MB5957:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b987b0a-7c68-4ff3-b65c-08db4cae6077
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hGX6mkWS6kxlzgLZOmEXBoE+V3AyLz3FKPmt5lduq0o6XWKXMF3LAiTIbIe/XL0RvuFvlVa+k8qZMBEXLnjwrungiqtCu4qXVNAQJJn/zaE0xbVhsEDDd65lASJ3WLs+Gd1eWat0bmjbkw8mVFaU9RCbAmXfdjDGJR0QG79dyy67wRU/qU/IjWKZOMLLg+tfQO73XoFeXUqmr0Q9g8d10izP8kq3ZMBzBWCX3FuVSUtmBUMcIM6kpX9v09d3gsanN8SG6qZnWSlwU9q95DbFKOHzzLxXBdU85z7aEx6LGYz46z/O30iYHNqM+VMNuA8G8M5PMj6eA6yU8SRQcSO8GmjRRSt1fG72TwFI3kINioGWm2tUO0WDrOMaCws7jnotOGqHYmakE6lyjcg9iYrpOKxmFhfw2PX+jbK9ESFWyv4eowE+ATVePNy/mrm815riWDE40Df1fZc08wCWaKjxhZSFioM+Vz1310+j9qp1XZ+4Aic7N9jAYCXQQCfpV2dpgjnj1aPpyvYu6Rl5HGaL0+zgUubRSUKRYEBtIGEpjaD/1xpQQQVTJJN6MR3KdicMfvUKyXfe5tVtjm2WeSNVox9jLyLpV2veQNdRbUfuL0R2KDSfpoT1TXyKk5gicV5Y38DbWA/tTqEt8m/1kDKEkKqY3qlWUnKmXO406zKF2Kk=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(921005)(8676002)(5660300002)(41300700001)(8936002)(38100700002)(66946007)(66556008)(66476007)(316002)(2906002)(7416002)(4326008)(86362001)(31696002)(6506007)(53546011)(6512007)(186003)(6486002)(83380400001)(6666004)(36756003)(31686004)(2616005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eUpvb3FFNkVHeklSMDBFUG04WCtSM2xYaU1Iek5yZmJscmVQOFluYVhEMFBk?=
 =?utf-8?B?ME9oOWkzL0k5NEtEWVhpL2syWDdBWGdScTc2ZFlna2tGenhTOWZ4WGpBbkFP?=
 =?utf-8?B?TlFHOE42N0E0cWxWd0FwcjJPRVprK0drYWkyWllVMGNnTVpPRGRid1MreCtN?=
 =?utf-8?B?ZFdWd2FWdUxKem9XYm9aWmhJbjZnRngvY0o1Uzdld1M3WnEwM0tPWmg1ZTVI?=
 =?utf-8?B?Tmt3UmRvNGtFVlhZVC9GN3cwaHNLMUlOY1pvT1N4cmc3Q3NBMzRqL29oR1U1?=
 =?utf-8?B?QlJMS3FDZmJvbW5lOC9lcjRNRW0ybXhnekZjUWRsVlhCVnA5VXVNK2RaV05s?=
 =?utf-8?B?REhPSXB1cmZPLzkyTmxYSEtpdHAwUVdiTWorMGluNVYxOEszSkt2OGNtbVFr?=
 =?utf-8?B?UmVFZUg1ZEJIY2JhMFlUS1FJdmpqY2NWY1k5WXJRODBsVzM5S3RaQkQ5aHA1?=
 =?utf-8?B?ZWZUNEdQVkhoTWtyTFNJSHhUWE05SklETUxyM2RIb1dCcExyVG9iTVltL05i?=
 =?utf-8?B?azY5OERvTjgya3ZMTGZOeStuV0RUSzYzRWZ1WlZiT2JiblZLOEQwd0dkQkUv?=
 =?utf-8?B?TUxPZVVyQUZjbGYwZVdjYmJuZWR6d3JneW9pZ052ZkFVdGpUbEhmdVRuYWEw?=
 =?utf-8?B?WnNIRlZHcFNCNVQwNERBOCtxL2xsWEd5NGpqdlJYZHoyVWp4ZVBTd1lIeFpo?=
 =?utf-8?B?c2NUSXVDZGszamNuNWo1SzcwSi9xNk9pRWdJTjdvUTVMVkRBbXl0bVZodTcz?=
 =?utf-8?B?K1Q3NGpFa29PTU8vNUxDOTB2NENQVjcwc0tBRmJvcFhrV1h5enY0c3ZLQWkx?=
 =?utf-8?B?dGR4NTIzQ0Fzem80ak4wNEwvOHJHTzFOaUh2Qk9XN0MrenRXZjBIQWM1aGVl?=
 =?utf-8?B?VExPekpKNnJmdFJyYXRvbWwyRkdGaU1XZ1d2Z3RBYjduQnNlS2lKNktsNzc4?=
 =?utf-8?B?VTB5a3lWZjZDTTdmYklmK25Od2JqS1owTk5Yak1NeFl2YytwTlN2T0tGdm5Q?=
 =?utf-8?B?YjFIZzNNWDUvL2JnRmdrczhHeWhzdFZieVFlaGxod0UyT1JyMzVNRkFXek5T?=
 =?utf-8?B?QTFhK04vMUtDQU93TU5nNS9ocXdkajhLYzlobHVKUTBiOGVvUFFwTENrZEhB?=
 =?utf-8?B?cXczazliZGpvTUROSE1vQzNLSFEwalFoL0RKeWdtVHZTcVBwVHFORkZNbTho?=
 =?utf-8?B?SDkxVlBkdERDTVpNb3QzMXJEU1NJZWY5ZFYvODFCeHl2QXEwWXl1V1o1c2Zs?=
 =?utf-8?B?RXMwZVBoSmN0MFVmcXoyTEM5Y3VnNVVMWWk2cllkWWc4N0ZXYWdXUFlrYUts?=
 =?utf-8?B?WXY1NUlhTmdlaG1PV09BVU5tTFdXNUY2UWU1M3NOZWVFMk44b2lJb0YyOE9r?=
 =?utf-8?B?U2RyNHZ6N3QvQlp1MURyRk1ZMnZnWEJmNmVxc3ROMzVVNGljMzl4TnlhbG9N?=
 =?utf-8?B?Zm9UTThpRTh6REFNWFNJTXlBVk9pWFhnb1NTcFRsSU5pTTdSYzN1a05INm5C?=
 =?utf-8?B?SW92K1pZZDZ6UEhycFBsV2hsSXhsajN6TmNXMHNnWVlLcUNidkFtSkZiV3pO?=
 =?utf-8?B?SVg2STVpREpVVDhmejR6Smxxam5PSjJkMVhHY3lNWFIzeGoyUWdrdjhlbHBS?=
 =?utf-8?B?S29ZRlIya2pLZFhIUTcvMWcweWRUNkJFdDNZd0FJdGlsZ3dXS3VuQUJZTUVM?=
 =?utf-8?B?RGJ5bDdaZWpLQXZkQkxFMVBNTEZpU3pjZGVZcllBUmRyQ3lUK3E1K0VscENn?=
 =?utf-8?B?b1oyUnljR1BvbzlPclQrVWRwQ3hrcE1aSUVGMWlDVnowOGNUTEJ2dHRTbC9T?=
 =?utf-8?B?RVh1V3RHakFHVDA1enlGV0ZEZUN0TnFZMS9PZEpUVzJMcGMvdmlib2E3WDF3?=
 =?utf-8?B?MWtXeEFUTzNzWnUzWWlyamsrTHorM1NtYzVHOCs5M3ZuWnFSN2dhV2ljRzZH?=
 =?utf-8?B?ZEtFK28rNHZzT0orNVdRNDEySlEvYzBMMHI4OTFFQU9zaGhZMXBJRlZHZVBk?=
 =?utf-8?B?bkI3MWRrc3N5N0VENlJwdFFaZ3VyR0w5NmpmTzNMdEZWT2lzOENEWm5pMWZ3?=
 =?utf-8?B?Z0dONW54NGdPWEkzY0dYbk1jdVNSbklma0ZKNzB5OUQvbktTY08ydHUrRGph?=
 =?utf-8?B?OVBtaVFmTDJEL01EeGZuZVEya0RDcVRTVlVwYnJET2ZpM3ZPSWdxc3ROczN3?=
 =?utf-8?B?a2c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b987b0a-7c68-4ff3-b65c-08db4cae6077
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 14:46:43.1425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SbznlvFwJS51eesUAlivwHdDiHA16kmewgEkk5K8zdanv7/mK+mVbk6XzyqnVcTT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR15MB5957
X-Proofpoint-ORIG-GUID: p2xkc6CMyYyaRM1qRyVsDkxHnt78Qsn8
X-Proofpoint-GUID: p2xkc6CMyYyaRM1qRyVsDkxHnt78Qsn8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_10,2023-05-04_01,2023-02-09_01
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/3/23 8:15 PM, Feng zhou wrote:
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

Ack with a few nits below. You can carry my Ack in the
next revision.

Acked-by: Yonghong Song <yhs@fb.com>


> ---
>   tools/testing/selftests/bpf/DENYLIST.s390x    |  1 +
>   .../bpf/prog_tests/task_under_cgroup.c        | 54 +++++++++++++++++++
>   .../bpf/progs/test_task_under_cgroup.c        | 51 ++++++++++++++++++
>   3 files changed, 106 insertions(+)
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
> index 000000000000..fa3a98eae5ef
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
> @@ -0,0 +1,54 @@
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

You do not need to initialize 'foo' here.

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
> +
> +	ret = (pid == -1);
> +	if (ASSERT_OK(ret, "fork process"))
> +		wait(NULL);
> +
> +	test_task_under_cgroup__detach(skel);
> +
> +	ASSERT_NEQ(skel->bss->remote_pid, skel->rodata->local_pid,
> +		   "test task_under_cgroup");
> +
> +cleanup:
> +	close(foo);
> +
> +	test_task_under_cgroup__destroy(skel);

Let us just do:
cleanup:
	test_task_under_cgroup__destroy(skel);
	close(foo);

This is the reverse order of test__join_cgroup() and 
test_task_under_cgroup__open().

> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> new file mode 100644
> index 000000000000..79d98e65c7eb
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
> +const volatile __u64 cgid;
> +int remote_pid;
> +
> +SEC("tp_btf/task_newtask")
> +int BPF_PROG(handle__task_newtask, struct task_struct *task, u64 clone_flags)
> +{
> +	struct cgroup *cgrp = NULL;
> +	struct task_struct *acquired;
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

Let us do:
out:
	if (cgrp)
		bpf_cgroup_release(cgrp);
	bpf_task_release(acquired);

> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";

