Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389372F24EB
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405333AbhALAZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7574 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390846AbhAKWz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:55:59 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BMpPQL015148;
        Mon, 11 Jan 2021 14:54:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YnIhzp6+wm02H0iUziAwyuZcGsHa5WZD+UycDMxr9Ik=;
 b=CVYYsN/n40QTJw8tBuGgyCiSB7irW8QgDZ45Zuh/oSik4wQHv2eoTy1udCEu/FYQjvSn
 Rb9zHNaDiWtnfRpb7luMLR5CpRHYV+mntgd6TXg4goJSwoPWwMZ+MYgSdeVLz2kXHoJJ
 tRvaqk3+W5xjF1joLR2sVK7WfgbXtPaTXSc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw1pfm0m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 14:54:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 14:54:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWRv6gDdXVsWP2MygL7jxFetCkHAxXDmQc2jA97aMro6upic5KhM8skNYSklik/cNTx3les0dfvwJ4CI2G0PuiQ3r4isFSxQckuyp8yrktqOAHdxHq3SezHN/vFoMiGHvLopBRSc/SC+fcNcjWhgUKYwn2i2H8jRIc89ZcyGnTxsKx7K39bYVSCVxLGEuVF01z/+WjbA8+SHEFQ4u34Lb77Of7KIz0RqoP1PeTYJH5pOcGr6wRvI2VqbDEW8hP8YwqPlo+K+DKZqe9VXVYuez/lMpwYToGxt4YCa1bR3qbcdHxX5ICUMIr6QCftOSQDDTa7MHohDxvOo8qcq2gqCEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnIhzp6+wm02H0iUziAwyuZcGsHa5WZD+UycDMxr9Ik=;
 b=gxMnTyxHCbFvprBXRK5CDvnCyPRwf4Z7bktnadSqfbWQ7JBaZuUQhAcyed7cfhqtItI8O/WH6be/xxSPCAdOC6tnab+pG+yczo+lycQTm19wapHqzm5RL1A06mrgNo4uBLcgw00Q1rNPFoxucen6RRE9EUPj2UyUHFBAdavbjPeewRF9cZ7Et5dOF23gXp7qeNbDxfzcMM+JPAtBzvbZActc2n2kF2KdQN9oCzjJvodjaL5dzYF8++kA6cbVlPCF2MUmGAqXAxzuzkTQDqJslT/4w5q2X4JFwv5Gv2RAKy3jdZKigyaGfgs4upRRSo/uOAFdhCS4JNw7qKJL9xZiFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnIhzp6+wm02H0iUziAwyuZcGsHa5WZD+UycDMxr9Ik=;
 b=dKEpgK/mUdi/51ZRS4C3OnVDZ+gOYSTO+hEQiwYUMjO42zd76Wr0rhI5yrj8wfAaoq2Q1WDxVTd0seeZzeDp2ZxQTehpPBou4Q7XAar1/wgsiHXEBfNtr14XeWo6+g97+s9BR8gBUdvQEbFYkuCptUWu8edv/uedXeMcBPxo2yI=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3254.namprd15.prod.outlook.com (2603:10b6:a03:110::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.10; Mon, 11 Jan
 2021 22:54:50 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 22:54:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>,
        "haoluo@google.com" <haoluo@google.com>
Subject: Re: [PATCH bpf-next 4/4] bpf: runqslower: use task local storage
Thread-Topic: [PATCH bpf-next 4/4] bpf: runqslower: use task local storage
Thread-Index: AQHW5hZGTzByk5itW0+Ehl6CErtdN6oiuAcAgABVVAA=
Date:   Mon, 11 Jan 2021 22:54:50 +0000
Message-ID: <352FED72-11B3-44F0-9B1C-92552AEB4AE8@fb.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-5-songliubraving@fb.com>
 <ad40d69d-9c0f-8205-26df-c5a755778f9e@fb.com>
In-Reply-To: <ad40d69d-9c0f-8205-26df-c5a755778f9e@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
x-originating-ip: [2620:10d:c090:400::5:f14a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c0ff542-4795-41f4-710e-08d8b683e741
x-ms-traffictypediagnostic: BYAPR15MB3254:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB325423FE91E69115BBCCAB65B3AB0@BYAPR15MB3254.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fjFX4M6J/1/kJriFb4qrDkflIPBjWlvYIdjduvRZ5TYVX163thmlEyEUi4Nrvi/Q4EJUFNF9S/55dMyiR0oGmRK0/PgHKEvCseThvKk0Xlka7AM1gyveiEZ8c7kKUlhxYKeJws/KbIisQgp4dHoUWXLN/Z3hrsWKSkFWQyhLXC6p5b410zAYJ2rkywzwl9D3qskQNHdWJ2Skt+rwl5CeTW3OVzM47w1wtpl1Tl8sCKRWL/uymAVjdQKjUvmn+xeuDT92jKOdf1zBdVEUjA6LnWE4Ju+M5U/DySnQr5SqzQNPoHmTr7364oZT3By1k8e6RbykMywQNko9ubVJ6giEkUr3Rgz43YXjOtZDrkUcRGhaL4QGWADBrmDgmBbfdOO5W5ol1braEEJY33zA3WPS2M/mcuti6QeQ7YmQ9ZizbhErfDTj6flp9TPL+u8GwE4x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(376002)(346002)(396003)(6636002)(66446008)(8936002)(2616005)(64756008)(83380400001)(66476007)(36756003)(5660300002)(66556008)(2906002)(54906003)(53546011)(8676002)(91956017)(76116006)(86362001)(316002)(66946007)(7416002)(37006003)(6506007)(6512007)(186003)(71200400001)(6486002)(6862004)(33656002)(4326008)(478600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7fT4/4nk/Pr6StutZABkFwM6d76eKSoHA+Q4coBpu/hVBHOvBRH91+ZRfW4s?=
 =?us-ascii?Q?0WBQWbpgA43EDViHAP5XbyOHRS4Alb1FkjvBSki9gRn7aDwJamFmGn5O7f1W?=
 =?us-ascii?Q?mdva+oU7L947MxYf7vFr+BHLIFIiiYYQzizTrWUjT7dJ//zxpdHYE+NHjcjg?=
 =?us-ascii?Q?wOJx8Fb3+dLc3iyAFIwiWoiqIGszsELYTaWfeY18NVJM4kneeCLWOzfJmOCD?=
 =?us-ascii?Q?LQgBRfNUfOSZS8jy5NzXlXH9oz8Iya3JzOqeAyfFQSzmDbRC0LS55wim090Y?=
 =?us-ascii?Q?Uf9RTtGFadT+N0NlE4DqwKHFhTCy9BkABgPrN4t80aT138FoEHlIG4afTU49?=
 =?us-ascii?Q?wnG1LUmMCbTIJelnL7cvwNHqrQZN4tI+7oi78ZjnrnjWWP+l1jeL0mTLk5G5?=
 =?us-ascii?Q?mzd78Qza55OOe4xo6IejZq9Av8ZSfSGyMNx0PVcBA3/sMIhTSocgfTKcET6+?=
 =?us-ascii?Q?zHSrbh2c0/4Uac4VA1MzSA5PqQCNoFjAGaeMnFYPrlvcXik0SwL1jQDHpMZY?=
 =?us-ascii?Q?VgWzqcVRJHepPyQzGVadfnpPXEN+5MesK04xlJwpNfjFn7LFlgokc2z9KbYx?=
 =?us-ascii?Q?YpPycCseKr8X8c+5L8tX0vLBLm/SAqfsOwxOeUxxipAWxcLrCEOz01EHsXAw?=
 =?us-ascii?Q?Q0Qe4uywFAvtdEUW1j5VVK50oQV+0F0l0edkaaxP4vQTN62aMwtpch1uVYWe?=
 =?us-ascii?Q?aptq9jhyBnk0zDK2j6EDv6c2ha3nzEj2BrAORjvH0fG40BDyWkbcA6fIgOQb?=
 =?us-ascii?Q?h3w27+lTTkqoXn3Q9Gr6Hd6slht986KJcanajPogLgQNI/B+HcCqKDUWXUMh?=
 =?us-ascii?Q?Nl9O5DQJuVAhA8uVmY8msr8o5G4XCyxoQn9NuoZP80M/RKL2hen0rUdkFrJa?=
 =?us-ascii?Q?NN2t1anc+wBlFon7Xs08p6zVZNkSAe+9cfep0Y+1UH4gl6qbtqA6df+dSEZX?=
 =?us-ascii?Q?TiH7y5+TNkr1hQ2OjaFaqAYWML6PAxfycrzG1sAziHtxjHtlBTDR/T38YrJc?=
 =?us-ascii?Q?xwZpyB/4ZkAqg21qJhLL2yNS2+KId9oTNtddSe9QAtbcUhE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6E8F0EF4B8011048BAC4757AA7352B30@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0ff542-4795-41f4-710e-08d8b683e741
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 22:54:50.8322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WtUO086K0Egy/N1U9erZzy+khvCYHwl2oH5354G+oZ06cKL9ty/g6hzo3K7Yd8hioKBybHyJPrvHwAJbPmvTYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110129
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 11, 2021, at 9:49 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 1/8/21 3:19 PM, Song Liu wrote:
>> Replace hashtab with task local storage in runqslower. This improves the
>> performance of these BPF programs. The following table summarizes averag=
e
>> runtime of these programs, in nanoseconds:
>>                           task-local   hash-prealloc   hash-no-prealloc
>> handle__sched_wakeup             125             340               3124
>> handle__sched_wakeup_new        2812            1510               2998
>> handle__sched_switch             151             208                991
>> Note that, task local storage gives better performance than hashtab for
>> handle__sched_wakeup and handle__sched_switch. On the other hand, for
>> handle__sched_wakeup_new, task local storage is slower than hashtab with
>> prealloc. This is because handle__sched_wakeup_new accesses the data for
>> the first time, so it has to allocate the data for task local storage.
>> Once the initial allocation is done, subsequent accesses, as those in
>> handle__sched_wakeup, are much faster with task local storage. If we
>> disable hashtab prealloc, task local storage is much faster for all 3
>> functions.
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  tools/bpf/runqslower/runqslower.bpf.c | 26 +++++++++++++++-----------
>>  1 file changed, 15 insertions(+), 11 deletions(-)
>> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslowe=
r/runqslower.bpf.c
>> index 1f18a409f0443..c4de4179a0a17 100644
>> --- a/tools/bpf/runqslower/runqslower.bpf.c
>> +++ b/tools/bpf/runqslower/runqslower.bpf.c
>> @@ -11,9 +11,9 @@ const volatile __u64 min_us =3D 0;
>>  const volatile pid_t targ_pid =3D 0;
>>    struct {
>> -	__uint(type, BPF_MAP_TYPE_HASH);
>> -	__uint(max_entries, 10240);
>> -	__type(key, u32);
>> +	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
>> +	__uint(map_flags, BPF_F_NO_PREALLOC);
>> +	__type(key, int);
>>  	__type(value, u64);
>>  } start SEC(".maps");
>>  @@ -25,15 +25,19 @@ struct {
>>    /* record enqueue timestamp */
>>  __always_inline
>> -static int trace_enqueue(u32 tgid, u32 pid)
>> +static int trace_enqueue(struct task_struct *t)
>>  {
>> -	u64 ts;
>> +	u32 pid =3D t->pid;
>> +	u64 ts, *ptr;
>>    	if (!pid || (targ_pid && targ_pid !=3D pid))
>>  		return 0;
>>    	ts =3D bpf_ktime_get_ns();
>> -	bpf_map_update_elem(&start, &pid, &ts, 0);
>> +	ptr =3D bpf_task_storage_get(&start, t, 0,
>> +				   BPF_LOCAL_STORAGE_GET_F_CREATE);
>> +	if (ptr)
>> +		*ptr =3D ts;
>>  	return 0;
>>  }
>>  @@ -43,7 +47,7 @@ int handle__sched_wakeup(u64 *ctx)
>>  	/* TP_PROTO(struct task_struct *p) */
>>  	struct task_struct *p =3D (void *)ctx[0];
>>  -	return trace_enqueue(p->tgid, p->pid);
>> +	return trace_enqueue(p);
>>  }
>>    SEC("tp_btf/sched_wakeup_new")
>> @@ -52,7 +56,7 @@ int handle__sched_wakeup_new(u64 *ctx)
>>  	/* TP_PROTO(struct task_struct *p) */
>>  	struct task_struct *p =3D (void *)ctx[0];
>>  -	return trace_enqueue(p->tgid, p->pid);
>> +	return trace_enqueue(p);
>>  }
>>    SEC("tp_btf/sched_switch")
>> @@ -70,12 +74,12 @@ int handle__sched_switch(u64 *ctx)
>>    	/* ivcsw: treat like an enqueue event and store timestamp */
>>  	if (prev->state =3D=3D TASK_RUNNING)
>> -		trace_enqueue(prev->tgid, prev->pid);
>> +		trace_enqueue(prev);
>>    	pid =3D next->pid;
>>    	/* fetch timestamp and calculate delta */
>> -	tsp =3D bpf_map_lookup_elem(&start, &pid);
>> +	tsp =3D bpf_task_storage_get(&start, next, 0, 0);
>>  	if (!tsp)
>>  		return 0;   /* missed enqueue */
>=20
> Previously, hash table may overflow so we may have missed enqueue.
> Here with task local storage, is it possible to add additional pid
> filtering in the beginning of handle__sched_switch such that
> missed enqueue here can be treated as an error?

IIUC, hashtab overflow is not the only reason of missed enqueue. If the
wakeup (which calls trace_enqueue) happens before runqslower starts, we
may still get missed enqueue in sched_switch, no?

Thanks,
Song=
