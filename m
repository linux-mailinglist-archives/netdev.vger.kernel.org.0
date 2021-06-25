Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50833B4630
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 16:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhFYPAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:00:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50162 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhFYPAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 11:00:23 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PErGOv027773;
        Fri, 25 Jun 2021 07:57:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xpYzx6pNWKH3LvjggyKPg4upXjzJYenzK2IgcvWFtTM=;
 b=n8huoBjrK+6iorUQSUfF4GHSqqepeprSgXZ9tlz+1UZountGiHN5eG8hGa5Ke8lk+oSq
 RF6QgxuPoocaylhgQsn84bmYJllOqLSZ8mrkSZ5rNr2U2S7BIOhCwcE7ah1LTEtvvfok
 BoEb13LgcNHA9UvwKxDV7iGAcwjx5bwn+2w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39d23kcmvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Jun 2021 07:57:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 07:57:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fA2gKtV37N3q2ZCWO+Ei4oB59xFcIfW7jtPs2rivHzJJYVXQN1pZTBmn176lJfQ2ZiqaefQqzhiw0ZZsF47757c7pgiUsh/DbHldz5bdyuFQd87XK3dJt7f87T0FArmw5da15DLSe//BlpXoYXIc5ShqVfCgPBJGvWF7/3jzhILE/GaLjSF6k8KbY2troMuHt5KJycWYhUs6RksWjST9wkVUzh/guU1j8yl33daNWE+CYKQorexdESgy8ea3OmyxdK7oPHzOA4J2oYl/BkhB7sdioTRQ1lZ75U0Xx75N2OZYwevDZmappFJiJ7ayle9bBx9pRS6Uitx9e5BA2fxPLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpYzx6pNWKH3LvjggyKPg4upXjzJYenzK2IgcvWFtTM=;
 b=AO3nfxH2FTTI2B63S+XIHeW4cGwDHFBTEP7AZ9oo0pn242jG+19h7D/XKg3LlJWrW9WhafCrEU5fzdc6fP064LUJAYFw1TsrL+XToc5VuG+uAJmGVJVwgIQFQCLb5mdR3DA8bGS6lLf/aICtQkeZd9+DIT5KqkbrNmDr3aXSNvZZUA/TKGsYgsuw7SaFe8OVkgYFSKyocMvnObFd5JYePNoBVq5tb7WZ+HH1Rb6cO7AY2XGIsEHBi8elVJNVxS2JUka+hVlAeMk0kph4QWedpQRsp9hnT/wFBAdPkNBkMAlVrRObSObB4Y1yJ+hLhELfNb6Ht/8V9ggkEi/VdmXBIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN8PR15MB2788.namprd15.prod.outlook.com (2603:10b6:408:c2::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Fri, 25 Jun
 2021 14:57:42 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::812c:1b55:c7a7:e15e]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::812c:1b55:c7a7:e15e%3]) with mapi id 15.20.4242.025; Fri, 25 Jun 2021
 14:57:42 +0000
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
To:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
 <4bf664bc-aad0-ef80-c745-af01fed8757a@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <de1204cc-8c20-0e09-8880-e39c9ee6d889@fb.com>
Date:   Fri, 25 Jun 2021 07:57:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <4bf664bc-aad0-ef80-c745-af01fed8757a@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:d59d]
X-ClientProxiedBy: SJ0PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::8) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:1cd9:6b47:1f14:bc19] (2620:10d:c090:400::5:d59d) by SJ0PR05CA0033.namprd05.prod.outlook.com (2603:10b6:a03:33f::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.13 via Frontend Transport; Fri, 25 Jun 2021 14:57:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8597b3c-327c-4fd5-5d89-08d937e99516
X-MS-TrafficTypeDiagnostic: BN8PR15MB2788:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR15MB2788956247823D01832BC17ED7069@BN8PR15MB2788.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5DHzRUSIGT1LFguyYu77PFeDJeMsi/C8Eq/H5d0G1Y1g3AW66Dw2hcWkZPMd2lCUwTOMbYauhK0E09Q/ssbr6QZu3EblVzaj05ARNd9dS3dlk58QHf9VXMmylwqgn+ZHYJsvIH3jf6IXikTiB4aCRd/WpIXhsEWKkNEvkHTIGsJGiCbqhqfl2a/Hdxkhd32WwVC1N46/6x+reaVGhrqSB9lKbjuwaL6yuq3yzt4Lu/mJWMHyWPnNX9IyXmH387a+TD9frjVa5YCXSD3pj1o4mUQjBFhgGYpYx841yjhLQcqyq4waWOVkSCG3+TE3cKdd+EFdxHTbTnZ9jSV0tXPwhHPSqvoWk5N9WVxKn0E5VqpJwW/f6LzrSZ3k37kOEyBxEwIWHdSUxUXERoS/cLdbeklGC5Q1l9y17eh0DOQT9yCqZitHf2PXiJPrnoZeiaULfakuyEOZ4l/h49f0KkDAh859YIgn6VmedjNIa4kpsqjz0MZbJ8G1hpwjc2hXfXXMPzN+NrW91/KwB+QKZSTgVddJqrCNdQ1U5KMDYt1md0lP7CVaqXujhrY4/+/gvq+aJ6eiviru/1n5qhxiEOGYYsqZ9Jo73vKkHokeMTRtHVYU/w/rqfrRIs8b0uz4luCW02cCyHUJ7ucoIxPISPwsW4E+1R95cWGA4BdsoGhIsdkHx4/C0D+k43GF3QZpxHGsUwgr/a/naKytcL860kH/VYElcL2/CKs3JdSo83Zhp1z6RxurTMnPHppiuCMUGgaQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(66476007)(66556008)(53546011)(31686004)(2616005)(36756003)(186003)(52116002)(16526019)(66946007)(38100700002)(316002)(478600001)(6486002)(4326008)(8936002)(6666004)(31696002)(86362001)(5660300002)(8676002)(2906002)(83380400001)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2laTk15dGlsSlNCcVFmWEY4VytkaXMrM0xTbVpYWUNqNkhUOVNKVHFxNHBS?=
 =?utf-8?B?TUZkbFNwSHp5SGZZUlJhbkl3MjdKTVBUcExmN2FrWUVJTStpV1NBenoxaUpT?=
 =?utf-8?B?MVkzS2kvSjZvUmZGSisxL1gyRE1FNXpJREdFcWp3QjViblZKeUFrYU1abDVS?=
 =?utf-8?B?OGdIOXQyR3R2TUtwK2w5Y3pUQlFBeGxtN01qN1ZVQ0hMdU91VEY5SnNidXBR?=
 =?utf-8?B?SklabTZrdmI0bnVWaXo4LzR3SWRBTVZ3dzhUNjRtc1pDcmI3Z0tObDVqaW04?=
 =?utf-8?B?czh6YlErSTBnc1BUd2VuR0tQcmNZTXdtdkYxUkFjc0lXZTMxem5XUFUxa084?=
 =?utf-8?B?M2hRZ09tSkNqeUlxelM5N1Z2SEI5TmVPRnVHeWtFeE40bFgyb3Bldy9qNG5V?=
 =?utf-8?B?bjhSQXpsTHJmQ0RvcXBHOUxKbWlISU9CM2ZhbXJUdGxjSWp0R0xmYnhLM0Mw?=
 =?utf-8?B?aktmWG9QdDc5RmdDcWhabVN2RjczcnVNVVRrbnVOU1BBdHVrRFQwQjNpUVYz?=
 =?utf-8?B?Ui8xRTFBTUZHWGdlSnRaWktTa1hvRnE4eUVTVGpoQjhtZUptU0JmNkNhM3hD?=
 =?utf-8?B?Rm5tVDNXbWx0WUdpdGRoS1dTd0M4T2VuWW81Q0c3Yk1TZEhpWkJ1T0hJY09I?=
 =?utf-8?B?bFRVNFpScVZPMzlETi95eUJzR1k1eFl1aXhMZlZScFNoTU5QNjduckFKSXlD?=
 =?utf-8?B?aVdvT3Q1OUtseGRqMTF0bENxR1Rqai9OY0xYYTc3RUhDem0yMnNJd3R5OHNz?=
 =?utf-8?B?WUlzNDJzR0QzdStVUXJVT1NzN240Z1lwN1pTdVRvMmowMmRFbzRNeHRrM1Rm?=
 =?utf-8?B?MmkwTHlvQ0p3bkV2OGN1ai8weXJVdFVTY25raGwxaDVyYjlNWFRMSkFVTFBz?=
 =?utf-8?B?VnAxZlJTQmRPeENrY1RyV2sxRWZLTnVoOWdEeGVxaUx1R2x5RlFDanlJMk43?=
 =?utf-8?B?aWl6ZUpvOGlUbHlWSU5mMFNneWhDQ2g5UWwwRnAyblVUNEpLRmhVN3ptVmtK?=
 =?utf-8?B?eldZcU1xZ3YyTFhjWVlMYTJJUmpxMUo1emNDYkE4anhaVzFEWVNhVXVVMlJR?=
 =?utf-8?B?cTBiRlY0U2czUVZ2dm9RMW5teHh4NkdyWHNKMkNCZ2tQTEh4Mmtzd0xqN3NM?=
 =?utf-8?B?VXVqRFNJVlVyNWh2NGJseDNGMTlXMWZ4S2wwcHhJZkIxeEdOaGNBYzZaS2s0?=
 =?utf-8?B?SDQ5S2tyT0RkQzNTRVVTeFUzNDlhYVA4ZlRVVVoyeVlJSUtDajdnQlFYTHpj?=
 =?utf-8?B?dFo3NjJrR3dYM1NaZmlZSVdicE9ybEZoTEZGTXNNUFYxN3lqUE1UV1RiR3Zr?=
 =?utf-8?B?MmVDbVVUeitYaStiQWJkSThDQ2FWZjdJK1BUNDBiaXQzNG1yY1RKd2FGT0tV?=
 =?utf-8?B?c2dRUTFkTWk3eGt3VTNEaElBU1dlUHJPbmRKUnZua2I0czRnamVZb3Z6N1Vh?=
 =?utf-8?B?cVd0UDNEWUV2blFDbk9ZN1JvSzh3WGErQlRjTGtoakk0a2pkYVdkSjlsVHJh?=
 =?utf-8?B?NEE4RHZtRkFPQklRZWVTeVBPV0c2c0dWTjJjQ2RGRHR0cnhaeGdxdEpsQXdQ?=
 =?utf-8?B?QmhWTS9iclU5VDJFOG5Yd2pBT1FnU1MvL1N5U0I2U2RucnBFdGVqb2hMWHIx?=
 =?utf-8?B?VUVqeUE1VXVRbVJjVnliME5JbFRZbzdJNEpxWmhHd25TSldFNGY4ZTdjL1ZP?=
 =?utf-8?B?T2pjZ0txbHZZbDVmWnhORjZGSnFwVU9sdjJucktkUTJwL3NRZURhdkd1cnBG?=
 =?utf-8?B?Y29HSXQrWkJSS0QzeVdqdVpKSnFmQW1FdVlkMlNmZlpRK0ErdEhOSUFobXZn?=
 =?utf-8?Q?nEY1//7Dw5sQ+ExAXxzGKE65TvJAKNbQ82QEU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8597b3c-327c-4fd5-5d89-08d937e99516
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 14:57:42.2032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5JesB3NHhAqYUxtDyGBfYU4Lup6p6H2gZtIn8ujddErq1ziJh2NRJ74STGpgbl1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2788
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: uThFnqcQps3bA8PjHIivEk4z3AZ-EN-A
X-Proofpoint-ORIG-GUID: uThFnqcQps3bA8PjHIivEk4z3AZ-EN-A
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_05:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1011 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106250086
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/21 11:25 PM, Yonghong Song wrote:
> 
>> +
>> +    ____bpf_spin_lock(&timer->lock);
> 
> I think we may still have some issues.
> Case 1:
>    1. one bpf program is running in process context,
>       bpf_timer_start() is called and timer->lock is taken
>    2. timer softirq is triggered and this callback is called

___bpf_spin_lock is actually irqsave version of spin_lock.
So this race is not possible.

> Case 2:
>    1. this callback is called, timer->lock is taken
>    2. a nmi happens and some bpf program is called (kprobe, tracepoint,
>       fentry/fexit or perf_event, etc.) and that program calls
>       bpf_timer_start()
> 
> So we could have deadlock in both above cases?

Shouldn't be possible either because bpf timers are not allowed
in nmi-bpf-progs. I'll double check that it's the case.
Pretty much the same restrictions are with bpf_spin_lock.

> 
>> +    /* callback_fn and prog need to match. They're updated together
>> +     * and have to be read under lock.
>> +     */
>> +    prog = t->prog;
>> +    callback_fn = t->callback_fn;
>> +
>> +    /* wrap bpf subprog invocation with prog->refcnt++ and -- to make
>> +     * sure that refcnt doesn't become zero when subprog is executing.
>> +     * Do it under lock to make sure that bpf_timer_start doesn't drop
>> +     * prev prog refcnt to zero before timer_cb has a chance to bump it.
>> +     */
>> +    bpf_prog_inc(prog);
>> +    ____bpf_spin_unlock(&timer->lock);
>> +
>> +    /* bpf_timer_cb() runs in hrtimer_run_softirq. It doesn't migrate 
>> and
>> +     * cannot be preempted by another bpf_timer_cb() on the same cpu.
>> +     * Remember the timer this callback is servicing to prevent
>> +     * deadlock if callback_fn() calls bpf_timer_cancel() on the same 
>> timer.
>> +     */
>> +    this_cpu_write(hrtimer_running, t);
> 
> This is not protected by spinlock, in bpf_timer_cancel() and
> bpf_timer_cancel_and_free(), we have spinlock protected read, so
> there is potential race conditions if callback function and 
> helper/bpf_timer_cancel_and_free run in different context?

what kind of race do you see?
This is per-cpu var and bpf_timer_cb is in softirq
while timer_cancel/cancel_and_free are calling it under
spin_lock_irqsave... so they cannot race because softirq
and bpf_timer_cb will run after start/canel/cancel_free
will do unlock_irqrestore.

>> +    prev = t->prog;
>> +    if (prev != prog) {
>> +        if (prev)
>> +            /* Drop pref prog refcnt when swapping with new prog */
> 
> pref -> prev
> 
>> +            bpf_prog_put(prev);
> 
> Maybe we want to put the above two lines with {}?

you mean add {} because there is a comment ?
I don't think the kernel coding style considers comment as a statement.

>> +    if (this_cpu_read(hrtimer_running) != t)
>> +        hrtimer_cancel(&t->timer);
> 
> We could still have race conditions here when 
> bpf_timer_cancel_and_free() runs in process context and callback in
> softirq context. I guess we might be okay.

No, since this check is under spin_lock_irsave.

> But if bpf_timer_cancel_and_free() in nmi context, not 100% sure
> whether we have issues or not.

timers shouldn't be available to nmi-bpf progs.
There will be all sorts of issues.
The underlying hrtimer implementation cannot deal with nmi either.
