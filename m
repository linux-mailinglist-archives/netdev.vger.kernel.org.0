Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15C1235592
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 07:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgHBFYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 01:24:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39544 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbgHBFYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 01:24:40 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0725M3LS008138;
        Sat, 1 Aug 2020 22:24:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YeTDdXdz4m/3vQ71PdFMLj4WfQNoYTpdntWqiIwau0U=;
 b=Qio4vPx60lHVvY/T5SImefGiNQQKU03Gioc/l89qmSDz9IoW0MZQCqqNUOllRtBbP21o
 QUQd4XpccJtgIhKRb+CIjtN/HeEuasyU3m1ajSs+ViVa6VBiADcprHgz0z2rQMBRyYU5
 crRO5U8hXMxWEwZdMLYP3DIOKlbu0vJjV8Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32n7sbj7wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 01 Aug 2020 22:24:18 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 1 Aug 2020 22:24:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlFzVUDrZ48o+Mv/Z95yciPu8V6EPvwKTNZvyIRDg0dSmTvnTjh6xTDeFq0h8qxW5DqIWNPvzr1tQFOxiibK2Gu3wy3eTNmxx5XTjDbVYYTNjrYw4N27ibPsQvSdd3O8tw9BcAO2uSEYAyXStKmoEXmEnqQGUikOn8Fudcln7uNK8KtgUxramR/B9NThZcKmzkTIRE6alkwY3qxAu4LBd45NVFZwvxLj3Q4iOtzPf5YveRRKTK39PxmMhplBYJJpDbvJ7zGrjMEJCCCCNCShZQTmCF0RJ2d0AvTF7jh3At/mtBPSGPURzC4aY1m1OJlcc0G9Nero4DfT0thMOs9b5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeTDdXdz4m/3vQ71PdFMLj4WfQNoYTpdntWqiIwau0U=;
 b=mkd0OlYVVcVFyDGQkQFS5HUiy0OuP64D6/Kr89Ww6sd66RbTSC3vBJKjqi5/F5BoqaJwWWG1nZDu38fDOYUgPnGPLevxje5lSczHWsCtxG6QtiGWprmSK10rAQPG+vyuipiMC+inblgFPRdflYbIGeimfoR0sRc9u1aToVY/a0OFmoXSeIE+GdsC3rYJHUD16Sd8Le+vzm9y6O5RJ5pi53mvAfYg18nxI+c4bvSXvaYDPn35q85GA6bXkMU4tkG2ZBZSS/9zbipaZjc7pQSxwBxxMlIyp1gEs/DyFx4/8TGwWvWMk76j4Q9V7ZnlFmcjb6V7QE0QAUOTuc8MuPoGVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeTDdXdz4m/3vQ71PdFMLj4WfQNoYTpdntWqiIwau0U=;
 b=ITTPKY7ZhWRdS2aRpUOXAuH7Q2/UduD+Oz5v10zIDyMnw2bKa+pLYBPrPEwpJ6yLm/pTwsQezEzYaah8xxuxCr2OspADTCxkHk9AGlgZTFECY0gDsAf7tEEqYXm95u8C6YiwFfZ6P+oDWgTEi9ypcj0rIhCu7618f7hrZdJRkvY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2822.namprd15.prod.outlook.com (2603:10b6:a03:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Sun, 2 Aug
 2020 05:23:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3239.021; Sun, 2 Aug 2020
 05:23:59 +0000
Subject: Re: [PATCH V2 bpf-next] bpf: make __htab_lookup_and_delete_batch
 faster when map is almost empty
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Luigi Rizzo <lrizzo@google.com>
References: <20200801180927.1003340-1-brianvv@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e0caa616-ea4e-82b9-6fae-6f7318f88ab3@fb.com>
Date:   Sat, 1 Aug 2020 22:23:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200801180927.1003340-1-brianvv@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0038.namprd08.prod.outlook.com
 (2603:10b6:a03:117::15) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1041] (2620:10d:c090:400::5:e090) by BYAPR08CA0038.namprd08.prod.outlook.com (2603:10b6:a03:117::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Sun, 2 Aug 2020 05:23:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:e090]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdf58c51-5943-4fde-3392-08d836a44269
X-MS-TrafficTypeDiagnostic: BYAPR15MB2822:
X-Microsoft-Antispam-PRVS: <BYAPR15MB282295B1ED2F3686FB7591DDD34C0@BYAPR15MB2822.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y+CtN5y18vErfR0Qx88qEjU75dFi1ogSEibf2CwTLioNiYyFJcoWxmAOjBL5RsTpTlISJ8JIGHX6fH6ubm0+Gk1kfOG1sO6z3FOtX84imvn6x5GBnxAcKPhADwlluOw3poM7Whg4xj6c16qgM+pvhC+ZzH6oiVR6WZQjF/vKdtlIRSQfm35vzfc5J/SVL03t8t+4acj0JkjeHj9mr/X6vW/BQ30GG+iuiyIaGMFCM2EwbDrjWvoJVN3d2xVtcH0QQpCl27/HlzjE0S1q8Fye/XdnAH87DUSwViFI15AA1fr2vT6AUpsU7dnXh5updDopNWDOhLMhexey5Jh8tsBKPO1vjBVijKR5NdTPomGNJnv4UN/3LDHG4fPZ7sMyeqmnfd1sjZyRJMC+hJnHDw1WvJjp2VMQV3x8QlpLdz0swz8jyExNBlJ6YB+ktfCaTJuEFk9l/whCV5s+Zk+Qio6LgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(346002)(376002)(366004)(136003)(316002)(6486002)(110136005)(16526019)(53546011)(2906002)(52116002)(966005)(186003)(4326008)(8936002)(8676002)(478600001)(19627235002)(66946007)(5660300002)(2616005)(31686004)(36756003)(31696002)(86362001)(66556008)(83380400001)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: OTCvg9/lv10SRnDJyOnvWk0nwHu8xoFyZiBPUnNB1baZYvW0ScK9fMLlnXZX+mqmzKznxSyYAqOfidZj7jFmHuXVh0LIt6h+a9Z/zs4G49uEMHwmR3VHdox12yti6MSXlBfAOoSxeJzb/fxX07FVIuqeoRi1vU0L+biDzJbuc0LJKq/Mnb/zB1xMfjGOx+QrHlV+4dOSY6nzPDQOUhuvahKQaf5X3vO9lgaFx71fyLncq3WMZODVpPnv5j2VcZNclOq7m5SyEht9zOvEMJTouDqjf3h3vUe8VVFfL3/+/oe8DALgQXR1qUAvG6zDzRS97G8OwTaB3OHppAuJC8ePHuAxdESKzlshw/ZcEBzcS49Uffy1rPGr/TrokjKJi7JPU5iPkX8QWHsSJZ2bVj/KgZXk28pykiVdVu0q1wnLPrLd5XH/XjcbqdnhJlmiHMQSlYQvA64ntaRHEduqt0iGM0uc7cQZtvdOJbbn5MI7P6YNC2FtblZkYhs5IwVQehmwZR7x3tOp2fLXslrz8piGsqXlMM9/tQHm7jCssvc5/YHXzetuJpAmIh1+1tnIzpQhX0ENVMha9i2zc0VhQVBzdVUmjjkkb5ecPkneL7nVZPOekyfjF7D0Q2e7haSK+zxHC4MN64xMddftAvbfGxOjYXn0S0DvrVYpbFfFKLL9cQU+Fg/HqsrWq0SsSfGmF4pA
X-MS-Exchange-CrossTenant-Network-Message-Id: cdf58c51-5943-4fde-3392-08d836a44269
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2020 05:23:59.1301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqok/4hojtnTgeSaWiWR2e+asSNeudQe7uxqEzEXsenq8FkgnuZTpeMtlupMUsR0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2822
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-02_04:2020-07-31,2020-08-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008020042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/20 11:09 AM, Brian Vazquez wrote:
> While running some experiments it was observed that map_lookup_batch was 2x
> slower than get_next_key + lookup when the syscall overhead is minimal.
> This was because the map_lookup_batch implementation was more expensive
> traversing empty buckets, this can be really costly when the pre-allocated
> map is too big.
> 
> This patch optimizes the case when the bucket is empty so we can move
> quickly to next bucket.
> 
> The Benchmark was generated using the google/benchmark library[1]. When
> the benckmark is executed the number of iterations is governed by the
> amount of time the benckmarks takes, the number of iterations is at
> least 1 and not more than 1e9, until CPU time(of the entire binary, not
> just the part to measure), is greater than 0.5s. Time and CPU reported
> are the average of a single iteration over the iteration runs.
> 
> The experiments to exercise the empty buckets are as follows:
> 
> -The map was populated with a single entry to make sure that the syscall
> overhead is not helping the map_batch_lookup.
> -The size of the preallocated map was increased to show the effect of
> traversing empty buckets.
> 
> To interpret the results, Benchmark is the name of the experiment where
> the first number correspond to the number of elements in the map, and
> the next one correspond to the size of the pre-allocated map. Time and
> CPU are average and correspond to the time elapsed per iteration and the
> system time consumtion per iteration.

thanks for explanation!

> 
> Results:
> 
>    Using get_next_key + lookup:
> 
>    Benchmark                Time(ns)        CPU(ns)     Iteration
>    ---------------------------------------------------------------
>    BM_DumpHashMap/1/1k          3593           3586         192680
>    BM_DumpHashMap/1/4k          6004           5972         100000
>    BM_DumpHashMap/1/16k        15755          15710          44341
>    BM_DumpHashMap/1/64k        59525          59376          10000
> 
>    Using htab_lookup_batch before this patch:
>    Benchmark                Time(ns)        CPU(ns)     Iterations
>    ---------------------------------------------------------------
>    BM_DumpHashMap/1/1k          3933           3927         177978
>    BM_DumpHashMap/1/4k          9192           9177          73951
>    BM_DumpHashMap/1/16k        42011          41970          16789
>    BM_DumpHashMap/1/64k       117895         117661           6135
> 
>    Using htab_lookup_batch with this patch:
>    Benchmark                Time(ns)        CPU(ns)     Iterations
>    ---------------------------------------------------------------
>    BM_DumpHashMap/1/1k          2809           2803         249212
>    BM_DumpHashMap/1/4k          5318           5316         100000
>    BM_DumpHashMap/1/16k        14925          14895          47448
>    BM_DumpHashMap/1/64k        58870          58674          10000
> 
> [1] https://github.com/google/benchmark.git
> 
> Changelog:
> 
> v1 -> v2:
>   - Add more information about how to interpret the results
> 
> Suggested-by: Luigi Rizzo <lrizzo@google.com>
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>   kernel/bpf/hashtab.c | 23 ++++++++---------------
>   1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 024276787055..b6d28bd6345b 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -1349,7 +1349,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>   	struct hlist_nulls_head *head;
>   	struct hlist_nulls_node *n;
>   	unsigned long flags = 0;
> -	bool locked = false;
>   	struct htab_elem *l;
>   	struct bucket *b;
>   	int ret = 0;
> @@ -1408,19 +1407,19 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>   	dst_val = values;
>   	b = &htab->buckets[batch];
>   	head = &b->head;
> -	/* do not grab the lock unless need it (bucket_cnt > 0). */
> -	if (locked)
> -		flags = htab_lock_bucket(htab, b);
>   
> +	l = hlist_nulls_entry_safe(rcu_dereference_raw(hlist_nulls_first_rcu(head)),
> +					struct htab_elem, hash_node);
> +	if (!l && (batch + 1 < htab->n_buckets)) {
> +		batch++;
> +		goto again_nocopy;
> +	}

In this case, if batch + 1 == htab->n_buckets, we still go through
htab_lock_bucket/htab_unlock_bucket which is really not needed.

So since we are trying to optimize for performance, let us handle
the above case as well. We can do
	if (!l) {
		if (batch + 1 < htab->n_buckets) {
			batch++;
			goto again_nocopy;
		}
		bucket_cnt = 0;
		goto done_bucket;
	}

...
done_bucket:
	rcu_read_unlock();
	bpf_enable_instrumentation();
	...

what do you think?

> +
> +	flags = htab_lock_bucket(htab, b);
>   	bucket_cnt = 0;
>   	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
>   		bucket_cnt++;
>   
> -	if (bucket_cnt && !locked) {
> -		locked = true;
> -		goto again_nocopy;
> -	}
> -
>   	if (bucket_cnt > (max_count - total)) {
>   		if (total == 0)
>   			ret = -ENOSPC;
> @@ -1446,10 +1445,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>   		goto alloc;
>   	}
>   
> -	/* Next block is only safe to run if you have grabbed the lock */
> -	if (!locked)
> -		goto next_batch;
> -
>   	hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
>   		memcpy(dst_key, l->key, key_size);
>   
> @@ -1492,7 +1487,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>   	}
>   
>   	htab_unlock_bucket(htab, b, flags);
> -	locked = false;
>   
>   	while (node_to_free) {
>   		l = node_to_free;
> @@ -1500,7 +1494,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>   		bpf_lru_push_free(&htab->lru, &l->lru_node);
>   	}
>   
> -next_batch:
>   	/* If we are not copying data, we can go to next bucket and avoid
>   	 * unlocking the rcu.
>   	 */
> 
