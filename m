Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED9B3B7735
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhF2RaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:30:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19950 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232513AbhF2RaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 13:30:05 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15THNaOt000860;
        Tue, 29 Jun 2021 10:27:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9tjIG6mtF9Cgm2/i7Z4VOJVsiwTo9rMYMLHFJHJcuBk=;
 b=RRsnfXvmtdWKpE/QqsXVUN4b10cupud1RNc39FRexqaz9Y2qVqGVGilLMAs+CDzas+NN
 tolFs/mBb8mtDe5bnyNVrfM+GPeNzEc5mFxfbKPjfOqTHiwGXIIZ1ZxanHyguHiQynPp
 8bNhzdcpGZ4HkhFaKg5s7ueU4fRI5nCelR0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39fgj7gdrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Jun 2021 10:27:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 10:27:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2mOVMKRqJvzbkEzBkYjkgLxJnbzUOtJ6PIj0aV7Xsg6exzZVMrTd8H4N9+6SIdrIWqNXxB1vBxZ0DamEoVW11hoxI8/kyN3yuohLjaL3Mu976KoOHSCTuACzTxTXxbxqzH5tGs9UI5A+P74UpFbrMw3BskY/kxizl9w7Bcyu8xBLTRpWlObpHHN1MNRxIJ1l1rG2rI2vXkKRJH6jKUVf89YgRJZ1Hyd/Cwuh+UHR5LqqGO2QO67k6FQOb6BV77Vhn209zYEqRBVi8OuWCcPACSAVIyZHqrkJjXZ3hEE6H+a5r0m2fhtVzhKIw7yNU6/ungRPNmuVzKLutdn367MFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tjIG6mtF9Cgm2/i7Z4VOJVsiwTo9rMYMLHFJHJcuBk=;
 b=bQBL6336aZnCO7pnicAEwNEIJeaoUqdxzibmJilhHokFM6zWy/2hDi2FykCCKRkPxBZkgYaholiBivudeSFjOfSpkdwpjRKzKaRdWcMaE3CH8d76mQ7zCzznvICB0koj3N5USG9syEAkIHP4xAvHJ994lcrgNHcrLiKvG7M8jN0OH8sxtIQSQPGZTL7iWsVEsocVZAv29pq36sMI7d88gIlw5OCH0TDq9mLecoDlwDUmwI/RzajBPXHxl6WUaFBYeBsXPiZ+01Fg7uAifgfSoFtjuXsdZno9ZTES8l/qWoK8rcK41PrE5N90Y+pTAjz/61VkE6i2wMhlmQ4y3EdW5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4449.namprd15.prod.outlook.com (2603:10b6:806:194::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 17:27:19 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 17:27:19 +0000
Subject: Re: [PATCH bpf-next 6/8] bpf: tcp: bpf iter batching and lock_sock
To:     Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <20210625200446.723230-1-kafai@fb.com>
 <20210625200523.726854-1-kafai@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6be60772-4d2a-30b0-5ebb-f857db31c037@fb.com>
Date:   Tue, 29 Jun 2021 10:27:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210625200523.726854-1-kafai@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6625]
X-ClientProxiedBy: SJ0PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1a57] (2620:10d:c090:400::5:6625) by SJ0PR13CA0077.namprd13.prod.outlook.com (2603:10b6:a03:2c4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Tue, 29 Jun 2021 17:27:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd0fa811-7892-4622-a069-08d93b2325ad
X-MS-TrafficTypeDiagnostic: SA1PR15MB4449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB444979A9AC7825686172F60BD3029@SA1PR15MB4449.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i1O6qZHN6rm0wTUgNOTNqinK8AlsRJXPV52wGVavM2Vh2M5ShPmwwatvo34aDzfTgp8X1SGM1zmEe2a9cSgh0J2Mw8S4sqPrzX/O+wQZICeU3Qr0VIhSIWx/6vXaP0Ft3aQpQi1icVaTuMJcmmGps1sFN3YYfTJAW5EmiQYmJVxTn84S28+DTAfJMwLztTryMen+FciQw3m2HDl+OWcbd9Z5M6JZGo1+KjUsTwC2NjnTjbNFI+TWwwRI2CFiQgBAV11NbEjT3Rd+8iyQZw3OWCIkBu8DXXI1t4WGU2kmUOyPOQ4Z6Gmjegw/c/Yso2psCJmE3VGb7XvFSN5ciNdLL2TM6J2r/vHkmIciOv52SuW1FvyQsSdQbk8pWmw+Odz4M+ljTQrwcXcQFQW0SQDxy1RBFGFXcxXBNvk2tSbsP5VwkbJXEjri7pV5fYQX/9dIWmqlYIWnsM/+5KH2BqG3bVIBDLKqGDIXU7wICYStJ8LLqYeBdNoUNrSRw8/TaLKOpcIiIvO98nZBHo6XMe9tg8pCtoWzI1z8Xi1t3QU7Z8a2t5zJoYSM1QcOGRjDwWQ6gIjV+/FGlhqYlwZsPlaGSlHqa2zA2e5kjOl5U1d/lB0LlejoAwst53zbKpoYEG/Q5Hxtom0DhoapQR7QpruQqHvb68FAAZ6eXn5b8AraFNcboobtC/Ux4jkdNWiippEazhIfnZgjDFrKg8sPBSAi2/ujq8/rHiGGUQyEVIC8fjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(31686004)(83380400001)(2906002)(6486002)(478600001)(31696002)(4326008)(16526019)(316002)(66476007)(8936002)(38100700002)(186003)(2616005)(36756003)(8676002)(5660300002)(66946007)(54906003)(86362001)(53546011)(66556008)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEhNNmFnT2pTUWRKcy83QWgwVFVLenl5enE5Nk9yQzFGYlhwcWN1NDFiS3RH?=
 =?utf-8?B?TDFldDVjeU9rZnJ3Wk5JaWh2bml2amZaNzFJZ3dNYXVIQUpOS0FId2tQdFZT?=
 =?utf-8?B?WlFXZ0ZXUTFjR3B4dk1IMTlUREkzSWF6YWlrSWFOVmw3d0Z3YjVYVEE5dUYv?=
 =?utf-8?B?ZC9HRHNWcjFHc0wyWm83cHhoY1dmV3dnTUFzZ0RFL3BGVG92YU5jS1NOYlVs?=
 =?utf-8?B?K0dGWUtMTm1oekhJSmNrQWdCSWVpTno1bE44TU5IbCtMeEVRQjd0bDliYWR2?=
 =?utf-8?B?Sm1qTlp3WXF4MENIK0lPMit1WEFieWI0eXQ0ZUYwU2hIUTFaMU5rZm1KS2lH?=
 =?utf-8?B?Vkh5M284K1RQbUpJNkJlcEVkQUtVcXF1TEdEMmxTNGNPWFhhZnBJL0dHSkJi?=
 =?utf-8?B?MmFvUk0zTjJERmw4QWxYTjlKR1FMQXVTQTVTN2hlUExHRU55TklYY2hMUXZW?=
 =?utf-8?B?QTFtYVk2YzRNVlQ1WGp2WkhFMHNxRDc2NzVnN3hXMHNBM2Q5S1hLUVo1L2xD?=
 =?utf-8?B?R28xVW5ZaVIwRU5pWEtnWmN1YS80a2sySmFKdWhkclhsTWRXWTFJMFdZRndq?=
 =?utf-8?B?ZjlJRjVMcVhLb2ZLTEZBZHNEYWNIYUcramNIUHhjd05EMUtaM3hXOGYyU0dK?=
 =?utf-8?B?K2c4UkRWTDc5SWVHUG5QT3lEY3hRVUp6Z1RCQ3JZZVJZVjFyRUlXVmhGMTFR?=
 =?utf-8?B?NHNYbVlhc2dUczV2TUlaRFVwc3dEVE8zR2pmUkcxbDB0Tzg1c2Q0bjEvWklH?=
 =?utf-8?B?d0QvTUJ6KytpWmJxWlVjTzBrUjVJZzRncmZvS21YUHpOY1RJVDRyU1hlSUVF?=
 =?utf-8?B?a2VDOFNoVzNJdEYvQ29zMVBhM1hHKzVvaldVb0JmdWQ1MGtZaTdXTWE1Z2pQ?=
 =?utf-8?B?ZG1ybWZzR2srQXQrdVh4OEJJZ3UyYXZpVWw4Qkp2bHh0U09aY3BQQmt5cGE3?=
 =?utf-8?B?b00vZ0FKYVF6N0dZQlBudUxhMlRtelFiSGQ4UXNlSDByRzhYRkFLSmo3bFZI?=
 =?utf-8?B?Y1ZMZkNQK2c0QXpoUm5GU3gyYlVtVW9iQ2tnT2xFdHVBUGhFVWpNVnBXQklx?=
 =?utf-8?B?ZVV2bUhxY01ROGF5Ujg2dS94QVNwTnArWm5lTWROMDJyMERnZFRLUUNqOGd2?=
 =?utf-8?B?a1U4UFcrSnJIUUJ4akVvbXk3R2hrcnlWZDhyamsybFJPME51dWlLaGxOMWdS?=
 =?utf-8?B?VzN1anRHOStqOFRsREJMS1JVSHVaYktqWDlMNEt5QlJHUC92K0g0ZVh3Y2lC?=
 =?utf-8?B?eWZWeCtBVzhaNm16WW1UNW4rVnBsSW1MS1dsN0lZU2tVb2twaTdQWVBFL2xs?=
 =?utf-8?B?Q2wxQStiaXozbVV3TWFGbUtDRUxmc25NbExjZFQwa3JSdTc1VUNsdmxXaGJl?=
 =?utf-8?B?dEM0SWZDdmxySTJlajVBZ2RUR3ZVR3VYRlppVDZLNTQ1QkpWTjRWSUl5alpo?=
 =?utf-8?B?NlJVelFpczJPSnBPNDFEUXA0cE5hcHVsb3NrNzlHWmlzT01ocjV2ZzloRG5r?=
 =?utf-8?B?U0NKNjZBemJYY0pkQnk4TUwybDZKMlNSdEZXRm1LR0tWRUdlcW1WMlh1eTQr?=
 =?utf-8?B?SXg5b1IxRmZWVXF3NzdIU3Mrcm41bExCMXU3cmZkdkpGZk5WSThBQjZJZVpn?=
 =?utf-8?B?TnVBNTdvZ1BXWTVkWFdOWUZTSDNSdTloNEdSRmVkWE1hRklNTnBBQmY0MnR2?=
 =?utf-8?B?K2hmMVMrUk5zWVIxd2JqVk5ZRFZabnF4bm92Y3g5NlBua2oyb1h3Z244Y3kr?=
 =?utf-8?B?Z3h4Z1o0WUF0a3NqUWdwUlRZQThFZmNwZ0EydzBZRi93eWhCQ0dSeXhFY0xR?=
 =?utf-8?B?bDcvNzZOZmF6dlhYcTlEZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0fa811-7892-4622-a069-08d93b2325ad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 17:27:19.2775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1lmfw3snd17ODGI86KEozrsd+alLpTESF/RCcKAqEy5Ag6anInP+M342izJ7zKD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4449
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Jwi4bv6dxpaGPqrFZWvFwriGNFNJl2dp
X-Proofpoint-ORIG-GUID: Jwi4bv6dxpaGPqrFZWvFwriGNFNJl2dp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_10:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 bulkscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/21 1:05 PM, Martin KaFai Lau wrote:
> This patch does batching and lock_sock for the bpf tcp iter.
> It does not affect the proc fs iteration.
> 
> With bpf-tcp-cc, new algo rollout happens more often.  Instead of
> restarting the application to pick up the new tcp-cc, the next patch
> will allow bpf iter with CAP_NET_ADMIN to do setsockopt(TCP_CONGESTION).
> This requires locking the sock.
> 
> Also, unlike the proc iteration (cat /proc/net/tcp[6]), the bpf iter
> can inspect all fields of a tcp_sock.  It will be useful to have a
> consistent view on some of the fields (e.g. the ones reported in
> tcp_get_info() that also acquires the sock lock).
> 
> Double lock: locking the bucket first and then locking the sock could
> lead to deadlock.  This patch takes a batching approach similar to
> inet_diag.  While holding the bucket lock, it batch a number of sockets
> into an array first and then unlock the bucket.  Before doing show(),
> it then calls lock_sock_fast().
> 
> In a machine with ~400k connections, the maximum number of
> sk in a bucket of the established hashtable is 7.  0.02% of
> the established connections fall into this bucket size.
> 
> For listen hash (port+addr lhash2), the bucket is usually very
> small also except for the SO_REUSEPORT use case which the
> userspace could have one SO_REUSEPORT socket per thread.
> 
> While batching is used, it can also minimize the chance of missing
> sock in the setsockopt use case if the whole bucket is batched.
> This patch will start with a batch array with INIT_BATCH_SZ (16)
> which will be enough for the most common cases.  bpf_iter_tcp_batch()
> will try to realloc to a larger array to handle exception case (e.g.
> the SO_REUSEPORT case in the lhash2).
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>   net/ipv4/tcp_ipv4.c | 236 ++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 230 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 0d851289a89e..856144d33f52 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2687,6 +2687,15 @@ static int tcp4_seq_show(struct seq_file *seq, void *v)
>   }
>   
>   #ifdef CONFIG_BPF_SYSCALL
> +struct bpf_tcp_iter_state {
> +	struct tcp_iter_state state;
> +	unsigned int cur_sk;
> +	unsigned int end_sk;
> +	unsigned int max_sk;
> +	struct sock **batch;
> +	bool st_bucket_done;
> +};
> +
>   struct bpf_iter__tcp {
>   	__bpf_md_ptr(struct bpf_iter_meta *, meta);
>   	__bpf_md_ptr(struct sock_common *, sk_common);
> @@ -2705,16 +2714,203 @@ static int tcp_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
>   	return bpf_iter_run_prog(prog, &ctx);
>   }
>   
> +static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
> +{
> +	while (iter->cur_sk < iter->end_sk)
> +		sock_put(iter->batch[iter->cur_sk++]);
> +}
> +
> +static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
> +				      unsigned int new_batch_sz)
> +{
> +	struct sock **new_batch;
> +
> +	new_batch = kvmalloc(sizeof(*new_batch) * new_batch_sz, GFP_USER);

Since we return -ENOMEM below, should we have __GFP_NOWARN in kvmalloc 
flags?

> +	if (!new_batch)
> +		return -ENOMEM;
> +
> +	bpf_iter_tcp_put_batch(iter);
> +	kvfree(iter->batch);
> +	iter->batch = new_batch;
> +	iter->max_sk = new_batch_sz;
> +
> +	return 0;
> +}
> +
[...]
> +
>   static int bpf_iter_tcp_seq_show(struct seq_file *seq, void *v)
>   {
>   	struct bpf_iter_meta meta;
>   	struct bpf_prog *prog;
>   	struct sock *sk = v;
> +	bool slow;
>   	uid_t uid;
> +	int ret;
>   
>   	if (v == SEQ_START_TOKEN)
>   		return 0;
>   
> +	if (sk_fullsock(sk))
> +		slow = lock_sock_fast(sk);
> +
> +	if (unlikely(sk_unhashed(sk))) {
> +		ret = SEQ_SKIP;
> +		goto unlock;
> +	}

I am not a tcp expert. Maybe a dummy question.
Is it possible to do setsockopt() for listening socket?
What will happen if the listening sock is unhashed after the
above check?

> +
>   	if (sk->sk_state == TCP_TIME_WAIT) {
>   		uid = 0;
>   	} else if (sk->sk_state == TCP_NEW_SYN_RECV) {
> @@ -2728,11 +2924,18 @@ static int bpf_iter_tcp_seq_show(struct seq_file *seq, void *v)
>   
>   	meta.seq = seq;
>   	prog = bpf_iter_get_info(&meta, false);
> -	return tcp_prog_seq_show(prog, &meta, v, uid);
> +	ret = tcp_prog_seq_show(prog, &meta, v, uid);
> +
> +unlock:
> +	if (sk_fullsock(sk))
> +		unlock_sock_fast(sk, slow);
> +	return ret;
> +
>   }
>   
>   static void bpf_iter_tcp_seq_stop(struct seq_file *seq, void *v)
>   {
> +	struct bpf_tcp_iter_state *iter = seq->private;
>   	struct bpf_iter_meta meta;
>   	struct bpf_prog *prog;
>   
> @@ -2743,13 +2946,16 @@ static void bpf_iter_tcp_seq_stop(struct seq_file *seq, void *v)
>   			(void)tcp_prog_seq_show(prog, &meta, v, 0);
>   	}
>   
> -	tcp_seq_stop(seq, v);
> +	if (iter->cur_sk < iter->end_sk) {
> +		bpf_iter_tcp_put_batch(iter);
> +		iter->st_bucket_done = false;
> +	}
>   }
>   
[...]
