Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FF33D50C7
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 02:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhGYX5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 19:57:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1806 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbhGYX5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 19:57:06 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16Q0V4Bv002673;
        Sun, 25 Jul 2021 17:37:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Y3BouGWAcaI/JZekMPEKjVqacPAquGq17Brx2YgM78U=;
 b=FVLENMWDuRQ9Fb4yTa2PgH64+KXyW9558bxssKri0T/r1AQhFBFX3MXbJmgrpsN5DvT2
 hdk9C6mXHQYXQ5RCJFhVWO7/h3/F93ewpOExSKb86RnL6DiTs+ohU78ZFkKAWxztPtgr
 cZ0vNyyKEShRgCTzV0ZLy4b5luqCZICps0E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a0gcxxm56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 25 Jul 2021 17:37:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 25 Jul 2021 17:37:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZouuBnxNGi2T+LA18IPRdkLUqhUmfgdX1XYt83ANh5raWcXM2CIiI6T+dQe0tKThT5ohiIe7fxY4utJ+eLhCXklV2GC1mDZ6qYUaYtTqc4GV9PE+n5cWX4QnatTGMYSOq1VNw7QPyGGRWR6P1OxgbAJIvValJcJnsCx7cs4xBKDtm9NUYbhmFTpd4LvoHHzYuaMhTeUE+WN26Ykcnyqmn50Fhp44TehB21FICQMDsXJUe0JLN5R9iF+B4q0ffJLpDI5Y4YMKupfpe+NaihTTIfXeCLKSbHQd8othEwn95P5UR+1o6kN6BBVqbMzWwbzrhEiExSYs0GAJQWftGXuTUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3BouGWAcaI/JZekMPEKjVqacPAquGq17Brx2YgM78U=;
 b=VoqzhBVZmh5obAdCz/1gnc5SFZGmEusaI7zATXy0bfc6KqXRdUfw7xq8qX1vMlxYF4Alu2KiF3VUvGr50eY6VjGa3ZDMOrVONPzaQzIgqRBhWucApfsG4HBvyyW3UQMxj+w5Svxtk5GrdKS1YTBZoJ9ZWHrKO2qg3Rzy2nrJTXN+kZYRAj3RAEJSr8HBw85LFhaYdegG45GLg7Eov+ZW1/cLtaBeZ1gIoNlp267c1pAqXByFF9wJSjzRHjjKqBbrjgEt+qfqGjZHdF02VCo7sBDQYTtSmwmh+AMuWzsTpaI7tkLjDIEOJvqK7VftvCB6K91ShZj51YSmbZvrl+/wNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB5031.namprd15.prod.outlook.com (2603:10b6:806:1da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Mon, 26 Jul
 2021 00:37:13 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 00:37:13 +0000
Subject: Re: [PATCH bpf-next v2] bpf: increase supported cgroup storage value
 size
To:     Stanislav Fomichev <sdf@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
References: <20210723235429.339744-1-sdf@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c9e87cd8-ced7-a411-62a1-ecd980b82dc5@fb.com>
Date:   Sun, 25 Jul 2021 17:37:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210723235429.339744-1-sdf@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0047.namprd17.prod.outlook.com
 (2603:10b6:a03:167::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::10b9] (2620:10d:c090:400::5:cf4) by BY5PR17CA0047.namprd17.prod.outlook.com (2603:10b6:a03:167::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 00:37:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7fbd144-f8ef-463a-219a-08d94fcd82ec
X-MS-TrafficTypeDiagnostic: SA1PR15MB5031:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB503199691827BE6DDBA9A452D3E89@SA1PR15MB5031.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q2f7dEv8XBzCL8shpZ8MTYkyQCqTAaEm7Inv+YTWzTVwQKcPxI7rVcI+i+vueV8sIY/XuL+zU5wPDIbc0yaI2TTRutY83B7IkVoaG0huSjYfqjOcNGDJHXWVMLWt4yHspTEV8zDlYlljtp4OkrA2qaL0Ekod4v+IeWSH8iBTsFQ7o7mM87HxDH5Jveh3KO27xbmKqM3ikrUCy8ym8+Gtl/aZnkk/TwhgvQqPQoKw/PhMr9rwJE3iqdOl268HfUcV0LmCRPST1g0jrmQS/Qc639v5bqP3r4ykyoqLg5lok+OeWlASTBh9LaQ96jGzgiKVRwSWKAyuC/tZ0bWHC7ZlTB1r0l+tzyYKhao/Vfnj/U7tU86BzTs8PR15SG/gWeX3/KagQ2j1Y7QFr/MdCkqPrwK5T3fUOAbe+2uHlkspM/asQWu2tS4ExwBgxXIiC9PKHUc96NoffcQsAsCAY0izcvSEf28w4ALlmnPgpkFvqXw+SkJkXpx9VoWeIA7ImR4AnIa+fisyp9zuuv8gH4nufNQvczZOnkVX7emosbUmdN9l0Pe+1YE2T+FxwCaXGqFSP1U3RzKOVDD5LD+ytQV07+5IzNGURtNUfqNCoJ5kcvLvje8KX7ZNc5KjLgz8PF88RKUOFeAlO0y3/aVdK9qupT8LTkpmuak0gdMym/S4Y0Nln8ohx40ztqnaly464ZOuF8ccHBTki333ZyZGIJIubHQ3TmgeD6m7Kd2eF0bcULf/Z3xmyvxZaiYkYN9q47nW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(5660300002)(478600001)(316002)(8936002)(6486002)(52116002)(38100700002)(36756003)(8676002)(186003)(2616005)(53546011)(4326008)(2906002)(31686004)(66946007)(66476007)(66556008)(83380400001)(86362001)(31696002)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1JFSUF1aGx5YVh4UUc4SmRRQlBPS3JCaWt4RmF6bHBzQ0tYVkdhdVdJQXVS?=
 =?utf-8?B?K29abldyMnVleExWRkY1TWJCNi94QWM4aW9uTmxuTlFSVEFDNHpKRWJQR0Fy?=
 =?utf-8?B?Nm1ZcnEyKzZUcmRDa0E4LzhybjV3dTA4dkU2MDhMU1lSQUhLcXJheExYRE9E?=
 =?utf-8?B?UVRveHlKWnQrR0Yya29nL1BJK2Q2Z1dYc1JLYUovbTVxRlhic3AzU1prMjYv?=
 =?utf-8?B?S21uZUhjdk1YN1dJbVhEaVNnTkhEWE1tMStiTEJBMkhPREJwUEJwTzllaEFQ?=
 =?utf-8?B?N2NrZFYzWG0xbTlkTk14byt2eEhxcG1IY3V5UFFneGhLSlRxNlM1bHZUaWM5?=
 =?utf-8?B?bkwrTkZ2SjlEeHkvZEgvc1JpY0RTYno4ZTBya2lNeklDQkE5NjFzSzRQWUN4?=
 =?utf-8?B?V05KQWxsU1BCbDdPbzVVK2dpVUorZXlGTVZTM010c1ZsVkZvMmljdXFlT1FF?=
 =?utf-8?B?RFZ5NkNiSU1CWVZoNWhCak9WQjd4dVlKb1FYZjNvT3c0UjFnVEo0TzRSajA1?=
 =?utf-8?B?ekx0SVlIZGV6ZkZ1TmlVUFMyOWxDQVpteG1hMXVUb0VHdnhzWDN2b2x5UzNZ?=
 =?utf-8?B?bDlTaklIRFlLcmJ0ZExYWEZlZnJEZ2lCZTlLeGpnZUVpZUhlQ2lxdnRzTU0v?=
 =?utf-8?B?cDJXWitwMnl6cG9vN1E0b2tLd3AyaUxJZVVwbE5EU0RyQldSbGIrNE5adnFm?=
 =?utf-8?B?cVkveGFnM1BCNEFhWXVPcXI0a05lOEd0dXdUbTY0Ykw2VFdqQWZuMnZPQlAw?=
 =?utf-8?B?dXRtR2J1K2cvd2k5Vm10YkZ4VHNHZmxQb1dIWEpybXpKb2RaZWlmZjRJU0k0?=
 =?utf-8?B?RGJRTE0wLzVZZ0FQckN2SlNra0lhbjQrQ1RLOGcxa0RuNUY0V1duRTZ4SUp4?=
 =?utf-8?B?MWd1d25iSGN1cUFONzRQY2hSMEFEaHJBTDk5T2pkMUJjUURGWHhPMml3RmhL?=
 =?utf-8?B?MWZEVkltanhvYlNOMU5VU3FxNVpjRGx6bHp5VWQzNTRDLzg3c0VvNHJkdGl2?=
 =?utf-8?B?K1E5VHJRQXJjeS9lK1NBRmtZa3o1YUltOS9UL09Xc05lWDJFNDBaalpaSnlG?=
 =?utf-8?B?cEh0V3NTY29lL0xhdVFxUDFwNCs0bks4Qk1GaEswTU5vUnhVbEtOMndEeERv?=
 =?utf-8?B?dEk2eS9iZlFsNEtyMVBTUDF3V3RWb1ZGWC9lZmltdHJycVArZmppQ2xiR2V5?=
 =?utf-8?B?L1N5NmIwdktrdGwyK1JKaHFOUzR5M3BZM2YwRDlEQUxMOHNsQXY0VDBYdGdV?=
 =?utf-8?B?bDNWbUxZM0NPbUU1dzQ4U3VqRmN6VWg1ZTJSczYzY1ppSXY3NFZTaDcxK2Yv?=
 =?utf-8?B?bFVFSzZ3L1Vhdll6WUF5ekovUkRSRGNhRWFzNEVLMG5VOUJ1QzdaSmEyVjRU?=
 =?utf-8?B?ZnRtWlhXSnNHMGo0eHQ0UHdjc3A4Qk1PaWcvakVsVS9nRGxpYlR5eUZ0R1NO?=
 =?utf-8?B?OTJRTGo2UjJaL2RWem1wWGh0WmpHcTBrWFkxc3hidWNtT1dUbzlMSU95ZGdQ?=
 =?utf-8?B?Tzh4eWxnZ2tIbTdsem5lbm9wbG9KUllsRDlROTlnS2Z1UEtlcllraTF1YXpz?=
 =?utf-8?B?ZVQ1QXpmeTBvcjM5YVQxSERFb0xZMXV0dHNTT3lHbnFjRVliN1YzYUxOK0V3?=
 =?utf-8?B?WUlBSGFuSU15S280bmMydW1CU2R0YmdiWVA3NE1Rc0xrVjFaakNjZXlvYU9m?=
 =?utf-8?B?UHhoSE1YYVd0TUl3ZTJweXFZaFlqUVY5cnl1a2FLQjNyWFl6dEJJNWlDZE1R?=
 =?utf-8?B?M0J4MXEzRE9uVFdBbVN3S2ZtbUJxcmduN1YzWnZxUFdzMnFmMkdaaGxyUzV5?=
 =?utf-8?B?emFFQnJ2K2YzOXZsUlprQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7fbd144-f8ef-463a-219a-08d94fcd82ec
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 00:37:13.4168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1d+pEZghzYc4Ihl/4bnJ+JuCb/cs/kL4tfpVzaFu8LorKhz+9cO2b5MIhPud+bg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5031
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: bTghcOnpeO6bKrHNdmfaCkN_8MJIZgwx
X-Proofpoint-ORIG-GUID: bTghcOnpeO6bKrHNdmfaCkN_8MJIZgwx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-25_08:2021-07-23,2021-07-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 priorityscore=1501 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107260001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/21 4:54 PM, Stanislav Fomichev wrote:
> Current max cgroup storage value size is 4k (PAGE_SIZE). The other local
> storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's align
> max cgroup value size with the other storages.
> 
> For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
> allocator is not happy about larger values.
> 
> netcnt test is extended to exercise those maximum values
> (non-percpu max size is close to, but not real max).
> 
> v2:
> * cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)
> 
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   kernel/bpf/local_storage.c                    | 11 +++++-
>   tools/testing/selftests/bpf/netcnt_common.h   | 38 +++++++++++++++----
>   .../testing/selftests/bpf/progs/netcnt_prog.c | 29 +++++++-------
>   tools/testing/selftests/bpf/test_netcnt.c     | 25 +++++++-----
>   4 files changed, 72 insertions(+), 31 deletions(-)
> 
> diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
> index 7ed2a14dc0de..035e9e3a7132 100644
> --- a/kernel/bpf/local_storage.c
> +++ b/kernel/bpf/local_storage.c
> @@ -1,6 +1,7 @@
>   //SPDX-License-Identifier: GPL-2.0
>   #include <linux/bpf-cgroup.h>
>   #include <linux/bpf.h>
> +#include <linux/bpf_local_storage.h>
>   #include <linux/btf.h>
>   #include <linux/bug.h>
>   #include <linux/filter.h>
> @@ -283,9 +284,17 @@ static int cgroup_storage_get_next_key(struct bpf_map *_map, void *key,
>   
>   static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
>   {
> +	__u32 max_value_size = BPF_LOCAL_STORAGE_MAX_VALUE_SIZE;
>   	int numa_node = bpf_map_attr_numa_node(attr);
>   	struct bpf_cgroup_storage_map *map;
>   
> +	/* percpu is bound by PCPU_MIN_UNIT_SIZE, non-percu
> +	 * is the same as other local storages.
> +	 */
> +	if (attr->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
> +		max_value_size = min_t(__u32, max_value_size,
> +				       PCPU_MIN_UNIT_SIZE);
> +
>   	if (attr->key_size != sizeof(struct bpf_cgroup_storage_key) &&
>   	    attr->key_size != sizeof(__u64))
>   		return ERR_PTR(-EINVAL);
> @@ -293,7 +302,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
>   	if (attr->value_size == 0)
>   		return ERR_PTR(-EINVAL);
>   
> -	if (attr->value_size > PAGE_SIZE)
> +	if (attr->value_size > max_value_size)
>   		return ERR_PTR(-E2BIG);
>   
>   	if (attr->map_flags & ~LOCAL_STORAGE_CREATE_FLAG_MASK ||
> diff --git a/tools/testing/selftests/bpf/netcnt_common.h b/tools/testing/selftests/bpf/netcnt_common.h
> index 81084c1c2c23..dfcf184ff713 100644
> --- a/tools/testing/selftests/bpf/netcnt_common.h
> +++ b/tools/testing/selftests/bpf/netcnt_common.h
> @@ -6,19 +6,43 @@
>   
>   #define MAX_PERCPU_PACKETS 32
>   
> +/* sizeof(struct bpf_local_storage_elem):
> + *
> + * It really is about 128 bytes, but allocate more to account for possible

Maybe more specific to be 128 bytes on x86_64? As suggested below, 32bit
architecture may have smaller size.

Looks like that the size of struct bpf_local_storage_elem won't change
anytime soon, so it is probably okay to mention 128 bytes here.

> + * layout changes, different architectures, etc.
> + * It will wrap up to PAGE_SIZE internally anyway.

What will be wrap up to PAGE_SIZE? More explanations?

> + */
> +#define SIZEOF_BPF_LOCAL_STORAGE_ELEM		256
> +
> +/* Try to estimate kernel's BPF_LOCAL_STORAGE_MAX_VALUE_SIZE: */
> +#define BPF_LOCAL_STORAGE_MAX_VALUE_SIZE	(0xFFFF - \
> +						 SIZEOF_BPF_LOCAL_STORAGE_ELEM)
> +
> +#define PCPU_MIN_UNIT_SIZE			32768
> +
>   struct percpu_net_cnt {
> -	__u64 packets;
> -	__u64 bytes;
> +	union {
> +		struct {
> +			__u64 packets;
> +			__u64 bytes;
>   
> -	__u64 prev_ts;
> +			__u64 prev_ts;
>   
> -	__u64 prev_packets;
> -	__u64 prev_bytes;
> +			__u64 prev_packets;
> +			__u64 prev_bytes;
> +		} val;

You don't need 'val' here. This way the code churn can be reduced.

> +		__u8 data[PCPU_MIN_UNIT_SIZE];
> +	};
>   };
>   
>   struct net_cnt {
> -	__u64 packets;
> -	__u64 bytes;
> +	union {
> +		struct {
> +			__u64 packets;
> +			__u64 bytes;
> +		} val;

The same here. 'val' is not needed.

> +		__u8 data[BPF_LOCAL_STORAGE_MAX_VALUE_SIZE];
> +	};
>   };
>   
>   #endif
> diff --git a/tools/testing/selftests/bpf/progs/netcnt_prog.c b/tools/testing/selftests/bpf/progs/netcnt_prog.c
> index d071adf178bd..4b0884239892 100644
> --- a/tools/testing/selftests/bpf/progs/netcnt_prog.c
> +++ b/tools/testing/selftests/bpf/progs/netcnt_prog.c
> @@ -34,34 +34,35 @@ int bpf_nextcnt(struct __sk_buff *skb)
>   	cnt = bpf_get_local_storage(&netcnt, 0);
>   	percpu_cnt = bpf_get_local_storage(&percpu_netcnt, 0);
>   
> -	percpu_cnt->packets++;
> -	percpu_cnt->bytes += skb->len;
> +	percpu_cnt->val.packets++;
> +	percpu_cnt->val.bytes += skb->len;
>   
> -	if (percpu_cnt->packets > MAX_PERCPU_PACKETS) {
> -		__sync_fetch_and_add(&cnt->packets,
> -				     percpu_cnt->packets);
> -		percpu_cnt->packets = 0;
> +	if (percpu_cnt->val.packets > MAX_PERCPU_PACKETS) {
> +		__sync_fetch_and_add(&cnt->val.packets,
> +				     percpu_cnt->val.packets);
> +		percpu_cnt->val.packets = 0;
>   
> -		__sync_fetch_and_add(&cnt->bytes,
> -				     percpu_cnt->bytes);
> -		percpu_cnt->bytes = 0;
> +		__sync_fetch_and_add(&cnt->val.bytes,
> +				     percpu_cnt->val.bytes);
> +		percpu_cnt->val.bytes = 0;
>   	}
>   
>   	ts = bpf_ktime_get_ns();
> -	dt = ts - percpu_cnt->prev_ts;
> +	dt = ts - percpu_cnt->val.prev_ts;
>   
>   	dt *= MAX_BPS;
>   	dt /= NS_PER_SEC;
>   
> -	if (cnt->bytes + percpu_cnt->bytes - percpu_cnt->prev_bytes < dt)
> +	if (cnt->val.bytes + percpu_cnt->val.bytes -
> +	    percpu_cnt->val.prev_bytes < dt)
>   		ret = 1;
>   	else
>   		ret = 0;
>   
>   	if (dt > REFRESH_TIME_NS) {
> -		percpu_cnt->prev_ts = ts;
> -		percpu_cnt->prev_packets = cnt->packets;
> -		percpu_cnt->prev_bytes = cnt->bytes;
> +		percpu_cnt->val.prev_ts = ts;
> +		percpu_cnt->val.prev_packets = cnt->val.packets;
> +		percpu_cnt->val.prev_bytes = cnt->val.bytes;
>   	}
>   
>   	return !!ret;
> diff --git a/tools/testing/selftests/bpf/test_netcnt.c b/tools/testing/selftests/bpf/test_netcnt.c
> index a7b9a69f4fd5..1138765406a5 100644
> --- a/tools/testing/selftests/bpf/test_netcnt.c
> +++ b/tools/testing/selftests/bpf/test_netcnt.c
> @@ -33,11 +33,11 @@ static int bpf_find_map(const char *test, struct bpf_object *obj,
>   
>   int main(int argc, char **argv)
>   {
> -	struct percpu_net_cnt *percpu_netcnt;
> +	struct percpu_net_cnt *percpu_netcnt = NULL;

Assigning NULL is not needed, right?

>   	struct bpf_cgroup_storage_key key;
> +	struct net_cnt *netcnt = NULL;
>   	int map_fd, percpu_map_fd;
>   	int error = EXIT_FAILURE;
> -	struct net_cnt netcnt;
>   	struct bpf_object *obj;
>   	int prog_fd, cgroup_fd;
>   	unsigned long packets;
> @@ -52,6 +52,12 @@ int main(int argc, char **argv)
>   		goto err;
>   	}
>   
> +	netcnt = malloc(sizeof(*netcnt));
> +	if (!netcnt) {
> +		printf("Not enough memory for non-per-cpu area\n");
> +		goto err;
> +	}
> +
>   	if (bpf_prog_load(BPF_PROG, BPF_PROG_TYPE_CGROUP_SKB,
>   			  &obj, &prog_fd)) {
>   		printf("Failed to load bpf program\n");
> @@ -96,7 +102,7 @@ int main(int argc, char **argv)
>   		goto err;
>   	}
>   
> -	if (bpf_map_lookup_elem(map_fd, &key, &netcnt)) {
> +	if (bpf_map_lookup_elem(map_fd, &key, netcnt)) {
>   		printf("Failed to lookup cgroup storage\n");
>   		goto err;
>   	}
> @@ -109,17 +115,17 @@ int main(int argc, char **argv)
>   	/* Some packets can be still in per-cpu cache, but not more than
>   	 * MAX_PERCPU_PACKETS.
>   	 */
> -	packets = netcnt.packets;
> -	bytes = netcnt.bytes;
> +	packets = netcnt->val.packets;
> +	bytes = netcnt->val.bytes;
>   	for (cpu = 0; cpu < nproc; cpu++) {
> -		if (percpu_netcnt[cpu].packets > MAX_PERCPU_PACKETS) {
> +		if (percpu_netcnt[cpu].val.packets > MAX_PERCPU_PACKETS) {
>   			printf("Unexpected percpu value: %llu\n",
> -			       percpu_netcnt[cpu].packets);
> +			       percpu_netcnt[cpu].val.packets);
>   			goto err;
>   		}
>   
> -		packets += percpu_netcnt[cpu].packets;
> -		bytes += percpu_netcnt[cpu].bytes;
> +		packets += percpu_netcnt[cpu].val.packets;
> +		bytes += percpu_netcnt[cpu].val.bytes;
>   	}
>   
>   	/* No packets should be lost */
> @@ -142,6 +148,7 @@ int main(int argc, char **argv)
>   err:
>   	cleanup_cgroup_environment();
>   	free(percpu_netcnt);
> +	free(netcnt);

Let us do
	free(netcnt);
	free(percpu_netcnt);
to follow the allocation order in a reverse way.

>   
>   out:
>   	return error;
> 
