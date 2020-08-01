Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8CF235387
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 19:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgHAQ7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:59:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55568 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgHAQ7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 12:59:30 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 071Guek1027785;
        Sat, 1 Aug 2020 09:59:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=H2d+78OzCYClx7y0SN6NzdFkmPS1ehTSmsuCfOjLhyY=;
 b=PopKwG2jj77oRcx5TDBDfqjDMYCTMwOfWJ7e9QQw9DQqOoqmZtMrtFsGATIvmZFVbUvJ
 lk6GIxZL09cyTZj6uBf0Q72hrPSCtLUPFOwPGr8A+3vESDcf21b6ah3tS/rNaW5EwY9E
 k2rfW3JP5TpTqFOBqlYlsGRbKOZsstZcmx8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32n7sb0p48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 01 Aug 2020 09:59:11 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 1 Aug 2020 09:59:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfkyTXihE50u7i8vrqAW9JjKv2xYKQCkYIeKoK6fmy6zuFH3ssJk0dkWfVAikVOE2rCVxCdEd/vWVzFvsFJgZQgoIJDgNfGcIIMgHciN4JW+eg8nAKERyWIEfqiZGUw6KpB1Xw0S2yNp8mHqF2Vz7iQS95AXVnXJd7I5uC7YCuV+SvYbt+mv5YxWdxfWHKex5Klb+hwnf10MLXl/kTaDJ7waSU37bv0oGc0quLxYIPsHGpaq58u+Sv/kf3tHGvQKS7CwvQaZRXnBODTWWeN9DlN+y1PNsm2M37JomeQvU1ljS8FuLnr659atKx00+azxwqxnQzvXPdKVBKrBmk+GFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2d+78OzCYClx7y0SN6NzdFkmPS1ehTSmsuCfOjLhyY=;
 b=bLfYQ45OYEqVD0URoNXcemSrxGcZjA/wgVv4RnFQgKWJmebLLmeqsp/9sZOWldw6HhfpKX2PAv4nL2v4ILtgGPpiCOeeMLTPG03bJq/H/3PV1z/FCkpt1/dv/zH9M93/ue1IRsLhQL+QQz4wA5xJ5VicyYgZ3sNbXE2WrIiEbm9/k0quhK/gdmPZMrEWdfyyTsrXaVXTm2lweFfb/dep1fCEUcAl/Fb6TqqmHMXpR/i933VGWC/A6Q7maFA+sMe2hLYa3xnjL11IDafSwd2U2PLpVw7VWUNgL6zXfLK1obO1ezIptVqXEQotrz1ZpvMfKkb/nqsfSSvPYexeL8HF7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2d+78OzCYClx7y0SN6NzdFkmPS1ehTSmsuCfOjLhyY=;
 b=KgPNHbgdxFX5L/n+rvAfCwqIeAi6HlOpJJGdSQZ2wyPNbRGY3pee9Hj32Sr472gF0kL2NKf6zqGK7y7DAM/HmxcpLjabYTJPl7PaqiMlI4/5mXfxred/U2DD6lS1ShDuzl88fJF682prT6pra0uyRff18R3XTCb+gN7MXjEuR4A=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2328.namprd15.prod.outlook.com (2603:10b6:a02:8b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Sat, 1 Aug
 2020 16:58:55 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3239.021; Sat, 1 Aug 2020
 16:58:55 +0000
Subject: Re: [PATCH bpf-next] bpf: make __htab_lookup_and_delete_batch faster
 when map is almost empty
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Luigi Rizzo <lrizzo@google.com>
References: <20200801045722.877331-1-brianvv@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4cd10805-b056-21a7-fdc2-d3f66e94dcf6@fb.com>
Date:   Sat, 1 Aug 2020 09:58:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200801045722.877331-1-brianvv@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:74::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1041] (2620:10d:c090:400::5:c6a0) by BYAPR05CA0041.namprd05.prod.outlook.com (2603:10b6:a03:74::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.13 via Frontend Transport; Sat, 1 Aug 2020 16:58:54 +0000
X-Originating-IP: [2620:10d:c090:400::5:c6a0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d822043-2d0e-4e80-62ab-08d8363c2c92
X-MS-TrafficTypeDiagnostic: BYAPR15MB2328:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2328DDDA1A1BE55D84D6FE37D34F0@BYAPR15MB2328.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U6eCTKyhA3DF00CDmb6vvW8IzkjS6CDpjJhZh+SyPxGRbvrNuddGZzR3egQO1eUqZkgnOTZXpYwupPWARZo3Ur/aE2N/0iVQq4kVFRyQFYwEuX+Z2dCM+Kcez4Bo+1lVC09M8w+VpMboyLpQkPKrwYwT3c3EsSDRFrVr/gi2UgALqrmjtn1GTwBbQgGwGGrWUeMx5CzfCTbMRFmxNotDhotFwGUlOvZs9Eu2bLhKcX/G3Q4+1NX+6JLzeo48UrNHiVMQhxXQ8g2e6Xrh7Kvzm25EaSNxuG1Ep7Xmj47x740TL5awjbZzu6/w2UaR2PTMtswAO3BBKsrLlto8KXH/a/w7FB1gmO8oAPugTevICRsGx+juBnpY/NmPEggUdLi5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(346002)(366004)(136003)(396003)(478600001)(66946007)(2616005)(83380400001)(66476007)(66556008)(19627235002)(36756003)(86362001)(31696002)(2906002)(316002)(31686004)(52116002)(4326008)(53546011)(8676002)(8936002)(110136005)(186003)(16526019)(5660300002)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lbex/R9rUjCkZsaxVgNsdk/uUubqXKlF9/haZODFr9lUWXQq5W/Juk3cIeuPSlw60eUchueywtBO1cZHmdyoRcCXYfkpfsVIjXVAq0VaGKySC6NslT1zRcqFZJdgmdfUc8IYx4XjNlcadwYhe75SFlGZutao4QCXjszRZs/O6JS+ObPMa9V7MMqO71tgZxdilNt8r+i/Lk+UANuaCyy2IloXE7LvCE3kXcIBrMJNdIQbgKxZwf+E5WQ5k3KTM0/lRlAR+5XAiblSyLmodCtl0jUI8KXkgPfYSEocosv54JW2OhVhRaijeo/JZklbnLqbei+Yps8sf+CpdT++geLvzOlvXz9pYQm1PDX5rgUFMw/8I2s6vzGlcwdf7P1Eo5EGESt8Jep7DjKtvxF69wIb/12EYhtkb5q9xAj8GopWnT9SrQWgPjkgOtbp+Gtox/bFxU0/PdxWgBnxq8fJq3hd/hzywO6V/MZJ0/clsbBbnJeMDkZzo8vJCQCWA87BqeFUskwlJSclr2FoW4McwcuCzTgXJZLaMgPoZIvINlImXGhqbLyMOpsl+kicJ7YxjX/0NfAea3celG7FGr8ROgbotUl2wfBExfZM0iFB7isrr/kj7MBsjl6bK5SbsyVTj+QYaOuko7ldllz3P1LaqRJMY/KPQL7vEO7BI0SZN7SAxpw=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d822043-2d0e-4e80-62ab-08d8363c2c92
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2020 16:58:55.2850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3aeNneL9qXOo1o8njUH2cLQHiONyu1Eac/fFPZVdheiU3inb+l3RwnaeaCQOuREJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-01_13:2020-07-31,2020-08-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0 spamscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 phishscore=0 mlxlogscore=953
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008010132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/31/20 9:57 PM, Brian Vazquez wrote:
> While running some experiments it was observed that map_lookup_batch was much
> slower than get_next_key + lookup when the syscall overhead is minimal.
> This was because the map_lookup_batch implementation was more expensive
> traversing empty buckets, this can be really costly when the pre-allocated
> map is too big.
> 
> This patch optimizes the case when the bucket is empty so we can move quickly
> to next bucket.
> 
> The benchmark to exercise this is as follows:
> 
> -The map was populate with a single entry to make sure that the syscall overhead
> is not helping the map_batch_lookup.
> -The size of the preallocated map was increased to show the effect of
> traversing empty buckets.
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

I think "BM_DumpHashMap/1/64k" means the program "BM_DumpHashMap",
the map having only "1" entry, and the map preallocated size is "64k"?
What is the "Iteration" here? The number of runs with the same dump?
The CPU(ns) is the system cpu consumption, right? The Time/CPU is for
all iterations, not just one, right? It would be good
if the above results can be described better, so people can
understand the results better.

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
> Suggested-by: Luigi Rizzo <lrizzo@google.com>
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>   kernel/bpf/hashtab.c | 23 ++++++++---------------
>   1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 2137e2200d95..150015ea6737 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -1351,7 +1351,6 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>   	struct hlist_nulls_head *head;
>   	struct hlist_nulls_node *n;
>   	unsigned long flags = 0;
> -	bool locked = false;
>   	struct htab_elem *l;
>   	struct bucket *b;
>   	int ret = 0;
> @@ -1410,19 +1409,19 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
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
> +
> +	flags = htab_lock_bucket(htab, b);
[...]
