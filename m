Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFD85297A9
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 05:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiEQDJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 23:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiEQDJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 23:09:54 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BA535249;
        Mon, 16 May 2022 20:09:53 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIXHZ6020588;
        Mon, 16 May 2022 20:09:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jwHaxW5E9zcBfzNJGNWtCehw9cAFdOQiIPY9Y3KbQWU=;
 b=US0KaJO5O31OsbJmOdvpaFKcgW+3G1fE9y6uXaCBYp/lwB2r9yj+XqzLiR0HT1rjJM8D
 nmduSmINrpBorRLznC1NqJBNsLob7W/Vn5OpHTEXpV5urPd3J63gDOq1KWHxvbPmxjYH
 09ymci/A6+P18llU5fLzWtp9GeB52XRJXWY= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g29xxp7dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 20:09:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJRKK856/W059NbpT1FrRV5HjkQHve2a5H6jcR792MI2HaMGA2NfodKi27e9/AqyCnvj6fSznG5ZDlehIsR91RLW1s7jGf4kNaGAnCqpKqKRiPv+qFYFY8yu5ywmnGf1odVyEIze8zoa6LLbppPfSnTPkQduNdy1cRrBRXMbaVblVucAORSf+S6z20rvJp9wfCSQbm/A4rGP5QIzzU+qJGpkccYUpSQINEHmKnuhAnnkxxijIEqdqfgrg7cQdVgLXoVMIDjCtQua7+mYCt4DivihiVSYY8f9/WLQ8sUjnR/Qr0w/PUgXMHVwAI0a4X35sPxMedrrtA4wK4nbpVNo3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwHaxW5E9zcBfzNJGNWtCehw9cAFdOQiIPY9Y3KbQWU=;
 b=BhtmXMqFSDFbBGWuthMi6lsMVXHsoHbaZyIi9exVa9CDstiwZqFBZwnKvtxzychJsDP+WNJxgoEFkrNe0+VOIo0JjY1nghqS3lDWGdZsB+hTiCLs0M7pt6r/VfVyBdfqTvVqdKqSAblVK92CHx0/UK/W6bvY8WHOMpttj/5iexGV8bTdgcnM0K0SEn6071DCEZ14Ing6dfsImZqYzonoq3hEvM4aFMXFNCpUxbCpHwgNeS/xL5iUiBN61fs0t0d9B05gNWGV/5f1bKU9kI1wt0fq9zqroi9j7V0q8vfBHdKzWVB0JVYLN4yWg1g23+flcYg+CEHhNXAo2SpZNQQ/ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB2963.namprd15.prod.outlook.com (2603:10b6:408:82::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 03:09:30 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 03:09:29 +0000
Message-ID: <80ab09cf-6072-a75a-082d-2721f6f907ef@fb.com>
Date:   Mon, 16 May 2022 20:09:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next] selftests/bpf: fix some bugs in
 map_lookup_percpu_elem testcase
Content-Language: en-US
To:     Feng zhou <zhoufeng.zf@bytedance.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        jolsa@kernel.org, davemarchevsky@fb.com, joannekoong@fb.com,
        geliang.tang@suse.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        yosryahmed@google.com
References: <20220516022453.68420-1-zhoufeng.zf@bytedance.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220516022453.68420-1-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:40::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44259e22-b7df-4787-31b9-08da37b2a88a
X-MS-TrafficTypeDiagnostic: BN8PR15MB2963:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB2963C67D042323C6C83A7E05D3CE9@BN8PR15MB2963.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vw0ZtctqFDvZ4ixVP/toA+t/afSh1YE71+MQ0uwO1sABZcStuU2gVZpDLEwX23Mhz5IN+eCKzxvBujRnKKYFDD6dq3pyJWPyn2nLe2cuzFDVbgbCguLsO7+0wSGiF0Lbe3oYJtxJq3WSWQzbCuMiJM47ZdRazODCuuwGdmGXmQvkybKEDLCM4llyt3hY4MGDX946M7bH3YbLNJMz1obUYX5lvptJO+GIUklrQi6vIf1C+GHQWVLwUs19bwrfrcfjSpI49mWC9D/Mt2pYLdn9XRy6Vuov3sShVjoCD95rMocoUaABkPvR+sxkHlbOKeV8rPkc+xDHIw6/jAG77d/CdAk++Ni9XcQrkT7yJ7/Hrc6jX87ArTZL5JDnonG+JvkGlKxA2cfB75nI7Nnt6h3cMqDZ2/N9T35auCHmC4T2TXzh+zRwtwBUnIW9HiSaV2E19NCavzRJ3TtEp6p+7TIutRI8dlXGroPNybg7/HAvTyfJKY5kNwJQiFeAHQtKx1MhNqab2panARSP2GFaQXRtJSfpr56lXOYkPMQheL9vztYMccI7ysR8nxI3AVkGigtoSl2bb5TJWJl0Bpm697E6xIgyjG8qxL3kKDYC+Sb1gLIl8DwOxycH29jvNDGIuSpDed195EbARj5LW44ZPhC379RGKPJahAxU860cJkych3LGZeOH+aa/nZPhL5Ib7SCPxcjUqSsT9B13O4sRdBChx4bqlIs3bjskTuc9PwwnR2hMr9obCR1NOe+ZSyvxE+cJuPFKfNXFtyomret8UjHsYNA2rYjqO4k7r07n+L1wB40BIYD4lLThU7QE3AfXDilX3Jw7N07LdApFVlI9nijDvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(7416002)(5660300002)(66946007)(8936002)(4326008)(8676002)(66476007)(66556008)(86362001)(31696002)(966005)(6486002)(186003)(6506007)(53546011)(36756003)(2616005)(2906002)(921005)(6666004)(38100700002)(52116002)(6512007)(83380400001)(31686004)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFc0cnZhYkd6NTdaT0Y0ZlpleW1wcEtjc1ZScnFWclRNaXZxU2N6NGozdGk3?=
 =?utf-8?B?a1ZUTWU5ZWJmZ0pEUStGYnhXaGtaeVpqYmwrVjlJTS9BdDcvdkVLUE9yWTRp?=
 =?utf-8?B?MFU2dTlTRk5YN3pYY1lGNzJuQ25ka3IxMG9WaUJCOUtZbXFvVE5oZU1Mc0lH?=
 =?utf-8?B?WjJoYUN0T1FvOFRpaDZYNUJacVR5UXdMaGUzeTJ2Y0x6Ry94OW0zQ0ptelFS?=
 =?utf-8?B?K0VxampDY2luQm8zN1doMGZSb2dvVzRIY2c1ZkpiSXNZSWtYQVMreVlFOXIr?=
 =?utf-8?B?dDlHOHorL1lscGZrWUlCZm5ZVW5jV1RWa0Rvc0l1WTQzeVlvcGFUNDRDR2NX?=
 =?utf-8?B?dG52bk16YTJ5OVBMTTMrTnlXZk5YeDZOUzh4N1FJY3JreTJQOTU3Qjk4SlFM?=
 =?utf-8?B?eHVUT0phTkVtd1dvUldFenhUd21mTTZaZzlKRnM4eUVtN01GdnFSa2wzaGhm?=
 =?utf-8?B?ekpqQUsvbUdZRGRaYitlMm4zMmg0MEM2NzZkVC9tNjNqUGtMZlNWMTgrb2Y3?=
 =?utf-8?B?VFlWSXZIWUc0VytSaVB5MWNYTnhoQVBBMWRVY3lHcXhGTE9HaEx3UTkwMTNP?=
 =?utf-8?B?QWtIT29kMnNVSXh4S3ZHa2s5QVRybUYvdVZYUTl0Y2tuZmFXTFdlcEJjc1Bz?=
 =?utf-8?B?aGZrYzBVVTBPODljRmNnWStuOXhzTW5MSCtleXh2NVlwUnNGQXlhYW50Z1p3?=
 =?utf-8?B?aDlTa3JOWjlkN2NwR3dyOWdEVFZUdVo3Vy8wTzdLU2RCS25KamRnYVZ5eGVv?=
 =?utf-8?B?VnBXMGVJWVpicmNaY0llaGg2a21kZmVNeUxNWTRBMm1GSjJ4ME5vS2FMMUJB?=
 =?utf-8?B?L1pTTnNvSjR5Y1BEbFd4cDBLcDVORkN6T1lBbnZtYVUraU9pV0IxbEZXdlIz?=
 =?utf-8?B?dld1WTlKYzV1MjVVcEl4UlhpQ2pkNXVKaTRUTEhVOEx1MU9LZGRUcEVyclBs?=
 =?utf-8?B?NG5Ib2lMR1YxbmZGc1oyT3V6VE9FWitwem9yVHJHN0dhSDI0bUthazU2Wlha?=
 =?utf-8?B?MldLREdiQ0Nvd0lqZHlXdGwrUmUxMS9RbTB5VnRBc3c1WkZkNmhiOHI2QkhB?=
 =?utf-8?B?VGkybXRCWVgzTVRWS3BMUk40Z1RqNmJPbHRFSmYrSGxLdDVLR0szUGlIbW12?=
 =?utf-8?B?SGFPNHhPWG5ydjRWNUtFZ3lMTzlMUnNnTnJqSjNYRHBWREdhaXNBczNRaEVG?=
 =?utf-8?B?bXhqYmQzZXl4U1Vuam1UZWlLeVlxODZxbEhSWmNiWDc1YlZFMGlHdW1ucytC?=
 =?utf-8?B?cThkWG5lNy9FQzVCSzNpbE5pQ2J3eXJkeHZ1cDFIVHFlZHpCWE4wVmNkMkZ3?=
 =?utf-8?B?N0FLYXhtdnBVUXc0U1BaWFFqem4rQUQ1VDMyRjNnUGJqcjNad250SllqdVMv?=
 =?utf-8?B?RVV4QVpvbGxOL09ST0daY1VOMzlHMThpdERWYi9kTWtmdUlDQjlJRjRxY2E4?=
 =?utf-8?B?b0MwTU1JSmY0L1dGYjVlSjd4ZXQrWmJVQ0c0aEt3WGxXOEVrR1phME4xbmpz?=
 =?utf-8?B?MlU1OU5ObU92UGpCcmJQTThnTy80WU8wVmxzaGJMYkJJckVIdzVHazVQaTQy?=
 =?utf-8?B?UFhPSVMxTE5PVHlaOEwrMzFSTmVrWjFjOWVMcC9iUGhCc1UzY3NENTkyekZ6?=
 =?utf-8?B?Zk0vOFdmRCswazkyZnROUXhMSWlOWU94UVpPUFQ3ODExcVF4UjFFZG8xaDdr?=
 =?utf-8?B?NEVVTFFRclBlbUV2cDVIVG02VC9kc0dGRDFieXFjcEpCalBycER1cDRKSm1w?=
 =?utf-8?B?c0RHbS81N21ZbENJRnRLek0zVnR5K2JHbGhRZnllN01SMm9FRjJGK2NaQXVO?=
 =?utf-8?B?RnpaS3dnN28vN3RlY3dXTlZNaitsMGtXbnptNTk0RnYrZGw0UUF6c3dLckUv?=
 =?utf-8?B?THJOaStkNTl1cE9jOHZnQUFveXJ0L0twaUsvdU5pK2t6Y2JNYUJlaS9EL0pz?=
 =?utf-8?B?YmxnK05VVE82Yk9QZDl2WkQ2L2tCZVNqbHVoclRHd0EzR3pEY0hnYjdLb3dI?=
 =?utf-8?B?R1RFUUF5UnFkRDZOZGhQRE40Q1ZKcTI1TmxQbGJ1ZHE2WFZDZnhmeWd1Ni9o?=
 =?utf-8?B?cUVVa0o3NGxyNjExblNGOC96bVBvcEpSZ1FLT0VMZWtrR3A2Wnh1T3p6WEpY?=
 =?utf-8?B?L25Nc1dhMVNheXdvSU9TbUlmbU9PVkNXRk1Qd1lLa1NTWHhqenZ6TndLaVlU?=
 =?utf-8?B?bVgrUUpldVdwV2FQaUdtZmFOZEc0OU1sZnFwVDArQ2FjRXNaY2lWQ2RlS1Q2?=
 =?utf-8?B?dzdwc3h5ekJNWTl6N285emNwK0tqZEQ1bzByQ1d5N2NYZmpGRGs1MFJVY0wv?=
 =?utf-8?B?M0ZUUUF2ako2cUswQTJJdDBHbDV4NmdoMkc5ZXlCeFFwOHkyeFJRTkNTRFEr?=
 =?utf-8?Q?OPtz0HDcrKbnEiFM=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44259e22-b7df-4787-31b9-08da37b2a88a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 03:09:29.9244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjDAWh8TZ1rgw6xMc5Kl87uNaFe9McnLCmO5T5jp97eAKQ64HLfLUPgXDsLNo75I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2963
X-Proofpoint-GUID: Hu1Ag3lNQQCs8JVzq4Ju12jFOrUwFZPk
X-Proofpoint-ORIG-GUID: Hu1Ag3lNQQCs8JVzq4Ju12jFOrUwFZPk
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_01,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/22 7:24 PM, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> comments from Andrii Nakryiko, details in here:
> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/
> 
> use /* */ instead of //
> use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
> use 8 bytes for value size
> fix memory leak
> use ASSERT_EQ instead of ASSERT_OK
> add bpf_loop to fetch values on each possible CPU
> 
> Fixes: ed7c13776e20c74486b0939a3c1de984c5efb6aa ("selftests/bpf: add test case for bpf_map_lookup_percpu_elem")
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>

LGTM with a few nits below.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../bpf/prog_tests/map_lookup_percpu_elem.c   | 49 +++++++++------
>   .../bpf/progs/test_map_lookup_percpu_elem.c   | 61 ++++++++++++-------
>   2 files changed, 70 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> index 58b24c2112b0..89ca170f1c25 100644
> --- a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> +++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
> @@ -1,30 +1,39 @@
> -// SPDX-License-Identifier: GPL-2.0
> -// Copyright (c) 2022 Bytedance
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2022 Bytedance */
>   
>   #include <test_progs.h>
>   

The above empty line is unnecessary.

>   #include "test_map_lookup_percpu_elem.skel.h"
>   
> -#define TEST_VALUE  1
> -
>   void test_map_lookup_percpu_elem(void)
>   {
>   	struct test_map_lookup_percpu_elem *skel;
> -	int key = 0, ret;
> -	int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> -	int *buf;
> +	__u64 key = 0, sum;
> +	int ret, i;
> +	int nr_cpus = libbpf_num_possible_cpus();
> +	__u64 *buf;
>   
> -	buf = (int *)malloc(nr_cpus*sizeof(int));
> +	buf = (__u64 *)malloc(nr_cpus*sizeof(__u64));
>   	if (!ASSERT_OK_PTR(buf, "malloc"))
>   		return;
> -	memset(buf, 0, nr_cpus*sizeof(int));
> -	buf[0] = TEST_VALUE;
>   
> -	skel = test_map_lookup_percpu_elem__open_and_load();
> -	if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open_and_load"))
> -		return;
> +	for (i=0; i<nr_cpus; i++)
> +		buf[i] = i;
> +	sum = (nr_cpus-1)*nr_cpus/2;
> +
> +	skel = test_map_lookup_percpu_elem__open();
> +	if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open"))
> +		goto exit;
> +
> +	skel->rodata->nr_cpus = nr_cpus;
> +
> +	ret = test_map_lookup_percpu_elem__load(skel);
> +	if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__load"))
> +		goto cleanup;
> +
>   	ret = test_map_lookup_percpu_elem__attach(skel);
> -	ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
> +	if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach"))
> +		goto cleanup;
>   
>   	ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_array_map), &key, buf, 0);
>   	ASSERT_OK(ret, "percpu_array_map update");
> @@ -37,10 +46,14 @@ void test_map_lookup_percpu_elem(void)
>   
>   	syscall(__NR_getuid);
>   
> -	ret = skel->bss->percpu_array_elem_val == TEST_VALUE &&
> -	      skel->bss->percpu_hash_elem_val == TEST_VALUE &&
> -	      skel->bss->percpu_lru_hash_elem_val == TEST_VALUE;
> -	ASSERT_OK(!ret, "bpf_map_lookup_percpu_elem success");
> +	test_map_lookup_percpu_elem__detach(skel);
> +
> +	ASSERT_EQ(skel->bss->percpu_array_elem_sum, sum, "percpu_array lookup percpu elem");
> +	ASSERT_EQ(skel->bss->percpu_hash_elem_sum, sum, "percpu_hash lookup percpu elem");
> +	ASSERT_EQ(skel->bss->percpu_lru_hash_elem_sum, sum, "percpu_lru_hash lookup percpu elem");
>   
> +cleanup:
>   	test_map_lookup_percpu_elem__destroy(skel);
> +exit:
> +	free(buf);
>   }
[...]
> +struct read_percpu_elem_ctx {
> +	void *map;
> +	__u64 sum;
> +};
> +
> +static int read_percpu_elem_callback(__u32 index, struct read_percpu_elem_ctx *ctx)
> +{
> +	__u64 key = 0;
> +	__u64 *value;

Please add an empty line here.

> +	value = bpf_map_lookup_percpu_elem(ctx->map, &key, index);
> +	if (value)
> +		ctx->sum += *value;
> +	return 0;
> +}
> +
[...]
