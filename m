Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF6247C77C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241812AbhLUTcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:32:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40818 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233313AbhLUTcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:32:35 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BLIvra8005844;
        Tue, 21 Dec 2021 11:32:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=IqzL0GUiJvHr2utaft6v8au5pMRH3QHgH3odTE0Jfxg=;
 b=UOrUHNqCdMHTGEmylpju/S/KsYGOLjSZrXnHCfDQE9SftdNSaSC65k3zERdk1O7CHSna
 BRGTMCdP/kj4zScdLKV7r7P8VUBZl1yVIUKupLq3hfiNUY2jin70ImxvWewiTD7l2LZ3
 BDUcMsML+z2bKOuoqFuI/UQnrCKfZDjjeqA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d37efnp3m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Dec 2021 11:32:12 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 11:32:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llF/Tl7d4YW1OGMgwVRTDv1mj2Lav8hwsr80P9wYKugaRub/va8uXpTETFL3O5d860YPM++c8s7kupHvZtRqSVlaCXvO7OEUOa/+9KOXOgLg/oLOfDjoCga24k0ZZ01sl7nMnLx5cy/zIu+U21sYv1DzC7UhZqOz/7cNiJVWG/ZThIpYV9t/TmNy4hoo2ciIR1ZZqKRic8uzm52aE6Juyg1mawJmoBem+FqLGTBJMzRmmhVizLgO3A3MntyKdB8srQpEvXgM4nrBf11JnhVJ9N9gQGm2P+nKCfLzRNAFJ1UeZfD7ktjcQ3uvIuLiJb2xHhB4h1gxfgdDuR0atwCp7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqzL0GUiJvHr2utaft6v8au5pMRH3QHgH3odTE0Jfxg=;
 b=R/dNGqaONHPfDk2saPI2vuNxrmXH/mveZqlvkLYtffsrm6SQXH78RqrIwCUXgiXW8TuTeN0QIi/poj50E+A1rP4Tbb24hLHPwk8KgvNyf4HpJ8HVZIFSsmEM1fp38W8Wzl8GNcIQRALI0uTE6cVNyrlmn8ukR0vDmkvrQC05DflcRmAc4wRKQxsRpQ7WigU7OXPkGyMPRNOnp3RFGzl46qAmBCi9kzvS3cLL0BTOlW938MHE7fuab05UACHkVPuEoufkIitnmfvEwNCLvTqP/v/Xps5O7M9E5FExn93dS6gxEIGncnS0f5R3syNRrwu+M3HIcKtmTc3WM67UTVqHag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3789.namprd15.prod.outlook.com (2603:10b6:806:8e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Tue, 21 Dec
 2021 19:32:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26%5]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 19:32:09 +0000
Message-ID: <712081fd-2709-f028-d481-84ad0e89ea77@fb.com>
Date:   Tue, 21 Dec 2021 11:32:05 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [RFC PATCH bpf-next 1/3] bpf: factor out helpers for htab bucket
 and element lookup
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yunbo.xufeng@linux.alibaba.com>
References: <20211219052245.791605-1-houtao1@huawei.com>
 <20211219052245.791605-2-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211219052245.791605-2-houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1601CA0016.namprd16.prod.outlook.com
 (2603:10b6:300:da::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ef3d2e5-a733-403f-1e5c-08d9c4b8943d
X-MS-TrafficTypeDiagnostic: SA0PR15MB3789:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB3789A47D3E21F7AAD1C5F718D37C9@SA0PR15MB3789.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TYuK3AQRDywhEU7CcZMC721L1gT2mhTpcfb8qiTPjoqwB3O7Ix/ncnYZNFULEyH1O22AX0jV5wCd1DUYdUjJu4Zjx2CRCAirRKzJFsnyW8Cf8+8H5aofxWwFUqJzzmpBTgMSeBuhWlOw6KwGcZ6lHaQzcCGFhIP6lN9flvFESdqJSlY8yMJ8uSqHCzdvmEIHhLNgfgdoejrzSaaqmJioDNUbecQczTqD3XDIvbedTdbKULhxGnbuP/JcZbZxB8c6bdFz81la67mbFq6m6Cu6pbmSY4vpw7E8jsfnRLjwi2IoSCV9BtwMEXihphu3ZlGLLtmQ1qSUcUNJwXGdUgYst6UcJuaxRa9T31WcPYRhlmnmO4tDtpkPkvk3B2M3300/nIPfR0lL3j1+F1iy5t5W3YFC0jxsgszvp0wrtzK7Kz14YYagh1S4GPb08046R/+kUVelfqVPOFJ3H6858vSfLFb8UmIyJO+n9ZAA2wdGL+DuMgiVmIhB7RzMNNYqYH/YiT0lGhYrFb4NGn7k86hn8ut23KG34bsx3Eg7pvSR4FdPxb/P5XzjfCK4+boGjtv4db/t0U2C2HwZhJcptlI45SZq/tFDKRu5VKKxqiDzcZ/d4ZM7/werYM45nUaqKd/lgOCUynEGgU5b+anecQ8stEeIhMlWSt9T2wIMUSXRnRvAlIbx+Znun5Ba6BvpRyBfAvwseyvZFd9oZnf2lR5nUYwv6P4gyGSfetsH7l8azxs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(6512007)(8676002)(186003)(110136005)(31696002)(6486002)(54906003)(52116002)(66946007)(8936002)(4326008)(6506007)(2616005)(53546011)(38100700002)(6666004)(83380400001)(36756003)(316002)(31686004)(508600001)(5660300002)(86362001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFdFTkY2MUQyODFOTkkvbGlkbjZDeVFUZyt3bFdQdDFLaE15Z0g4bVNTWnRR?=
 =?utf-8?B?SnNmTzdnckQ0elFTSzhha0hrQ2VlMURIeEhocjhmNUthRnk0UWYxYzlVQUVG?=
 =?utf-8?B?aEIyY3daYW5ubEV2YlhjUUhESGZRWlpjNXBiU2pxTWg4c0Jrc2J4QjRkNjlW?=
 =?utf-8?B?ZUpkellhdktpZzEwRXFpQ3B6UW5ZcWJQL3VXSTRIVlY4bVJZdVo1MWc4Tnht?=
 =?utf-8?B?VUFHUjBCWm5MWjVKQ1k0aStOdGNSTjB6aWhXK1dXaUxMUzl0MGhkbnQ0aGkr?=
 =?utf-8?B?OURvYVpXYkhKa3R4dmhNUnBEQnd4bkw5aTdvVklCbFpBR3RQTG9iaFR6eU9P?=
 =?utf-8?B?VG5kR3prcmRzTFFCTW1xbmxybmluU2RweC9hQS95eFlkOW1KUDlyUWVMSDJV?=
 =?utf-8?B?NFNuWHhXZG5sVWpWR1BWbGEzTCsyZ2ZuMG82d3NhbzQrOS83dTk3Z3JlUjA3?=
 =?utf-8?B?YUgvNGNHNmEvSDdKT3NJSjk0Uno3ejFERm1uS0Y1VEswTVlkbGxwMDdLNG01?=
 =?utf-8?B?cWMzY1JsbzNXRFRiMkw2Zi9pcGQvTmtzclJBaUF3U212bWJHUU9STXVLUnR0?=
 =?utf-8?B?S1NxQUh0ZGZiZ09XQ2tJY0VLcGpTWVpOTVZGdWZLUEJ4a2lkZGdtaVNnWW91?=
 =?utf-8?B?QXpmYlRjR3RpNi8rb3RoNitFMGc3T3FESlB0czExTHgySmt3b1R0KzNqelZa?=
 =?utf-8?B?RS9uNGxWRUNBOEdONDg1TGV5dGh5MVR0S0ZnVkl0emNFQ0hrZFVrYTA5cCs1?=
 =?utf-8?B?SDRmL0RmZUhkNTNHNXYwOUhncUcyTkF0djcwZWkwMHBNVjN5Y3lMRnFlLy9B?=
 =?utf-8?B?bUw3M1FlTjBndzdaYXZ6ZVl0U0lkRlpjY3NFVjFxZWNhWk45dlJvai9oNFJY?=
 =?utf-8?B?YVk0SEtRWmR2T1FTcmlJL2MrWm44WjdzTHh3SlpZWXlJR01Cd2V3VkhpY3Jl?=
 =?utf-8?B?VlZHV0VKMjM3TEM2aE83SEo5VDBYNXlwZEdreUlTZ1dNbE9Icm5XNDJ2Q1dY?=
 =?utf-8?B?RTZ0OHoyOWJpWDliQlpqZHhUUCtBVFRQM3hUT0dvOGQxcTlUQ1ZLSzJJVmUx?=
 =?utf-8?B?YmVXVkVoa0hnYzlJdDZWV3J6cm8zVVdmZ2tJTlFZZFNvTmVlUlMxZTRjcnJT?=
 =?utf-8?B?WFZVbTk5UjdFTnNvWjR0enNyeDVpNGd5Z3dEZWw0VjRldDJQM3JYZU9BZkl5?=
 =?utf-8?B?enE3cTl6MlJzc2VwMURQck5QMG8zS3V5Y0ZQQ2xjbnZtOGwxVEJPSURFa3Bm?=
 =?utf-8?B?Si9lRWhQZXQzL0Zoam9WQjBnSnQ1eVJ6VVFxV0JIS1VGNzlCT1BNK1lqWmEz?=
 =?utf-8?B?V2xoRjlJbU9UZzNLRnpaS25JTWwxWEpGMXI0clhXYkNybmV5UEpUZUtVWmY5?=
 =?utf-8?B?TFppZkk4ajArd3VrUmZlY0xreExrWnNEUzZjMlREaS9TQlNqMHg4bFBTSC9V?=
 =?utf-8?B?MmMyWTNuWUk1MmZOR2wwZXREUHh4VVJnc3RicCtueU55bzUrVmg3RnhXSndM?=
 =?utf-8?B?UDRtOExvT09PdUMwZW9KcnB2WFhabnI1VXdtYnRLYWxWNFQ5eHlla0JhTkVS?=
 =?utf-8?B?eWJ2R1ROR2lvbmF3TGJPeVhub2M2R0NNYU82c0kwUGpDbkRYaVdJTysvcjhD?=
 =?utf-8?B?QWx4UjhZdUFYcDJYNWpHbGFoQ1kzQ1k4VWlGNWdDOXd5eGlabVYzcW9vNGwz?=
 =?utf-8?B?ZW1wZXhqV1RqZkRnTFdyc0RBUCthYXFWWDZVWERVemdSdFJNZWRZdDdLVUIr?=
 =?utf-8?B?VUNaSjRjQTdwQ3FPWkRSRENRS3pSY2x0NGR0OW1XYUNyR0VPd3pSMlBxWHQ0?=
 =?utf-8?B?cTJVQnVqRmd3WFZhMkdMUjh6VDV0T1ZDSU1QN2JQMmFNakhNcDhKWGduaWhP?=
 =?utf-8?B?Vk5hTWpvZm5GdUFJNlZmVDAvdlArZ1ZtcFBoR2Y5aWNkZ0czNXZrM0dQWitI?=
 =?utf-8?B?dnZzM3RXeVgzYkJXallTbmcvaENwdFVYUm5UODZYMGJPRmdoQ0RWRTgwRU1s?=
 =?utf-8?B?NmRCMmJ5WE8wbTJXVWgya25JdHpvVmpiaS9TTFZpQmRsTTVJOEdRZmxKa24v?=
 =?utf-8?B?K0czekFmVmJqdVVQVTlYR2gzZ0ZkOWt4dzZlZEYvanNOWXZ3MjM1elNPWVhr?=
 =?utf-8?Q?GNxjsKdVmvD3RlFlyCCM0jZPi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef3d2e5-a733-403f-1e5c-08d9c4b8943d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 19:32:09.1414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GugT7pYzw70zWP53bwIFy5E2vk7NWrY8G0KTJ/pym+OyXKLFnuou/DgC/X80JSTJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3789
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: PYMYY2aPYxaMlR6NBqGzH-oNePM0LcIg
X-Proofpoint-ORIG-GUID: PYMYY2aPYxaMlR6NBqGzH-oNePM0LcIg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_05,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=660 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/21 9:22 PM, Hou Tao wrote:
> Call to htab_map_hash() and element lookup (e.g. lookup_elem_raw())
> are scattered all over the place. In order to make the change of hash
> algorithm and element comparison logic easy, factor out three helpers
> correspondinging to three lookup patterns in htab imlementation:
> 
> 1) lookup element locklessly by key (e.g. htab_map_lookup_elem)
> nolock_lookup_elem()
> 2) lookup element with bucket locked (e.g. htab_map_delete_elem)
> lock_lookup_elem()
> 3) lookup bucket and lock it later (e.g. htab_map_update_elem)
> lookup_bucket()
> 
> For performance reason, mark these three helpers as always_inline.
> 
> Also factor out two helpers: next_elem() and first_elem() to
> make the iteration of element list more concise.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>   kernel/bpf/hashtab.c | 350 ++++++++++++++++++++++---------------------
>   1 file changed, 183 insertions(+), 167 deletions(-)
> 
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index d29af9988f37..e21e27162e08 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -127,6 +127,23 @@ struct htab_elem {
>   	char key[] __aligned(8);
>   };
>   
> +struct nolock_lookup_elem_result {
> +	struct htab_elem *elem;
> +	u32 hash;
> +};
> +
> +struct lock_lookup_elem_result {
> +	struct bucket *bucket;
> +	unsigned long flags;
> +	struct htab_elem *elem;
> +	u32 hash;
> +};
> +
> +struct lookup_bucket_result {
> +	struct bucket *bucket;
> +	u32 hash;
> +};
> +
>   static inline bool htab_is_prealloc(const struct bpf_htab *htab)
>   {
>   	return !(htab->map.map_flags & BPF_F_NO_PREALLOC);
> @@ -233,6 +250,22 @@ static bool htab_has_extra_elems(struct bpf_htab *htab)
>   	return !htab_is_percpu(htab) && !htab_is_lru(htab);
>   }
>   
> +static inline struct htab_elem *next_elem(const struct htab_elem *e)
> +{
> +	struct hlist_nulls_node *n =
> +		rcu_dereference_raw(hlist_nulls_next_rcu(&e->hash_node));
> +
> +	return hlist_nulls_entry_safe(n, struct htab_elem, hash_node);
> +}
> +
> +static inline struct htab_elem *first_elem(const struct hlist_nulls_head *head)
> +{
> +	struct hlist_nulls_node *n =
> +		rcu_dereference_raw(hlist_nulls_first_rcu(head));
> +
> +	return hlist_nulls_entry_safe(n, struct htab_elem, hash_node);
> +}
> +
>   static void htab_free_prealloced_timers(struct bpf_htab *htab)
>   {
>   	u32 num_entries = htab->map.max_entries;
> @@ -614,6 +647,59 @@ static struct htab_elem *lookup_nulls_elem_raw(struct hlist_nulls_head *head,
>   	return NULL;
>   }
>   
> +static __always_inline void
> +nolock_lookup_elem(struct bpf_htab *htab, void *key,
> +		   struct nolock_lookup_elem_result *e)

There is no need to mark such (non-trivial) functions as 
__always_inline. Let compiler decide whether inlining
should be done or not.


> +{
> +	struct hlist_nulls_head *head;
> +	u32 key_size, hash;
> +
> +	key_size = htab->map.key_size;
> +	hash = htab_map_hash(key, key_size, htab->hashrnd);
> +	head = select_bucket(htab, hash);
> +
> +	e->elem = lookup_nulls_elem_raw(head, hash, key, key_size,
> +					htab->n_buckets);
> +	e->hash = hash;
> +}
> +
> +static __always_inline void
> +lock_lookup_elem(struct bpf_htab *htab, void *key,
> +		 struct lock_lookup_elem_result *e)
[...]
