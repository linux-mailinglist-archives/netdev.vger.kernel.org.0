Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE4B43ACB3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 09:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhJZHMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 03:12:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233289AbhJZHMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 03:12:23 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PMiY3A011958;
        Tue, 26 Oct 2021 00:09:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=B6WQwC61hyrOJxabc87387SQLSfbnJfv1MOOC17u5KA=;
 b=ms/wcKWrja0Qa7D6ZpgfUOuX3COvdP4e51zao228OpinBjLZ6gFowkSCwkEqUrAVy1ff
 e5wSf99S5iRGjGCJXUQfMmXsgaFy847vdDxkZaPx0dpDLqZGY7zuRhHZ/mKkZMomyY4D
 vuOljeocKzwIVcxk/nq8UsLk4vYoVa3ya8A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bx4e7tv1g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Oct 2021 00:09:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 26 Oct 2021 00:09:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDIMKdESfZmaJuPqgjrYZpDaIuN/8WGhYgocvoUlWBn8dAhayb3NN6dz/OxPPHlDfeadhb21zLYm7Lqg6tvhmAj6TBRM2l1fErXXMnehbPvoMWKC+Jt4d3fzL+kOEpJeNh+wk9GqH+clVSS4TukwuiZGbQSnWnSvJgy105eSPa5sxIqf1HMEaxxPto/skuQbqHYn88o4jBMI3JAbqK0uPNaokKoHbMpbpzBwlYIIBTMlWJwiY8F+8aGv+6w+99qa5erQzEF1dUZvY4Es3YJmljQLk+MQayOmNf2ve0ZL4HsQpSbf/9keqQ3ooOYvuaxrnazyOpWsveNu+OIyf84gLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6WQwC61hyrOJxabc87387SQLSfbnJfv1MOOC17u5KA=;
 b=Fk+WWz3+FBSVK58i3Co7Bz/0ZVrOGgJeFpwC+SxQsDnGLt4J/akX6gkVnJIqn3R8wlF5iCO/zsWO4cv5SdbQtvxHnbDwW8F8qdatia4QJAf540v4pAlPYL9UJVRhZO4xp4P08IboLCgNDO88EPuD7AdgNkCE7E7Xos1ivMYI6A4u1ryKYVga+1XQneFwg3LGIn9juPn9XXB/Tx893H0ReD/qbQyyKaiXuD0Sds6gwxUs6Pkjjcj7+V7Tu5Chx7bMlcKYH5tFhc1Z7UXQuUersjtoMY4OepMIkxEzV8xeZOYLTHBgxGahuf6ETT4WGZ4FBJ6vOEC8hT8mzQaFtDq8WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5186.namprd15.prod.outlook.com (2603:10b6:806:236::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 07:09:51 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%7]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 07:09:51 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Thread-Topic: bpf_get_branch_snapshot on qemu-kvm
Thread-Index: AQHXtMWNyKWclBi4s0iJww6HNTXDJ6u6n6yAgABLWQCAAAXKgIAAJheAgAAVeoCAAAoigIAAOogAgA0QG4CAACUTgIAADc8AgACwtQCAAQraAIAal6uA
Date:   Tue, 26 Oct 2021 07:09:51 +0000
Message-ID: <A4E23F44-CB25-4B5B-BC65-902E943C63E5@fb.com>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
 <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
 <C6DF009D-161A-4B17-88AE-3982DD6F22A2@fb.com>
 <YVSNV/1tFRGWIa6c@hirez.programming.kicks-ass.net>
 <SJ0PR11MB4814BBE6651FB9F8F05868FBE8A99@SJ0PR11MB4814.namprd11.prod.outlook.com>
 <0676194C-3ADF-4FF9-8655-2B15D54E72BE@fb.com>
 <ee2a1209-8572-a147-fdac-1a3d83862022@gmail.com>
 <7B80A399-1F96-4375-A306-A4142B44FFBF@fb.com>
 <d46d96ff-02a3-5ea7-a273-2945f4ef17a5@gmail.com>
 <1EB93A74-804B-4EE2-AECB-38580D40C80D@fb.com>
 <0fe14e54-4ab3-75da-4bdc-561fe1461071@gmail.com>
In-Reply-To: <0fe14e54-4ab3-75da-4bdc-561fe1461071@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff5ae7d7-5345-4e1a-064c-08d9984f9ab7
x-ms-traffictypediagnostic: SA1PR15MB5186:
x-microsoft-antispam-prvs: <SA1PR15MB5186F6A4F12121E9FEAD92A5B3849@SA1PR15MB5186.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JocqOZDLqeThkaK55W6R5FYfJqOjtpJYmj2Fsd1ZV95qiSdo31BOk6adk18WIjcghpJ9Nw9WBKKrdXPFpvFn65rHINr+vD0VgvGiJ+x6GgQC6SK40vAl/it2QgAjrQvtbTIBNc5g8pCRjdfnb7Zl00kyXUYXWZUzv8oRmBUq7FM7/8zCdx4dKskjXSXB9HZsZGkrT2jzZ+sI6LRhr1G96uUlPFkqBoJ4ugQ1+ya/p59pU6mqzoT5lq+T5sDgJZ19OEVwZlhqzUPSA6hdb7GvkMCZBl8nwN2DcthjWszLEXNAzm+02thd/s8oKOaqP2Nd9Cy/rqkFyNqUHa4FbdQnT/kqWj9dRcxxzf4cxLHIQWjBjQ44oHmrrp1Qcuo5HN1/bVXBLapwsWFaowHSzcp6TjDMG5tmXqR9K8eBOOUZweJ2h1KyfxOH9xspcOuspA3isALhZEuXYpgFPFjeiVwUwGsT1ZGslHIyZy/NPSrFGNp3I3+zzDE2CK/o/FuuC1mYqW39x2g9bmy3FKw31pQaE10iCQ+hipoVdjaEB5yC7LrFaM4UB+Ls/qvM/WGOHm94MwJN8lIG2DCyHrgx53c5vzdATg4GiHlxjhmes/Oc4fF0R4kzN7S/yyTJL5+JXtt4E4ZLfwTxzPAk7bLDibmXm/mfcBt9qus9EQ89UENnsmQHUd7owDpmHAZRRR4EFverqd+Ngzovse6tb5Znnjx0hn5LsnYNs9npMVGOQXtg7ulGG8m+/JJtbGRFKf6MWI8XiMOSWMS6BxNpYtPa1QNmuJParQLdwtQ7LqkDe5OQmsu+3Y6SVYRm8rGe6mHcgs+O5FhFgY8DpcheKxiHjHiMDqmGljNUtCY2ii0RioabWV8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66446008)(966005)(8936002)(71200400001)(6486002)(66556008)(6506007)(53546011)(83380400001)(4326008)(2906002)(2616005)(64756008)(6916009)(91956017)(86362001)(38070700005)(33656002)(76116006)(36756003)(38100700002)(508600001)(6512007)(5660300002)(316002)(186003)(122000001)(54906003)(66476007)(8676002)(21314003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LzATbGbL1P6DTria0oYB3+OfIRUXTYpGKPRaPLL1OcLDPaHP9OgyErXb7GXo?=
 =?us-ascii?Q?jzgxDTvN3zr+krvadEax1ygcHgEmr3GZNkG553KwDS6jW3fmty5IeHt2Q6jN?=
 =?us-ascii?Q?ChRJuNIl/Kxmzx2/LoXg9Kyb47BAnlfU3Yi7vwfxpIgu3KXQkxSAjBw/cYIh?=
 =?us-ascii?Q?q5HNZ2jfP/i4YleFyMz4i0PeVCWky3iyDKHeWfZ2i24MqG/yTYnk/2MMqYs2?=
 =?us-ascii?Q?reB8C9VHtneSeRlu0OjZ8hm42vjHWHJdBjfnLEhP1memiIuSkZCFu59RS9K1?=
 =?us-ascii?Q?no/bFEbFvNQjrE+xuEVuSwxS7/hknnN/PTr5F9DNhawNcblynj7Ao/EIlEeU?=
 =?us-ascii?Q?RYJvlZl9o0o0HQ4CITl28cpPYjhSmhXgXs4QMhHhbCqVNHERwWiaNa34Wooc?=
 =?us-ascii?Q?A0G0jP5fqHWKIBNBnN74zU9YYXZ/YNTwotRgedNJMz5VGMDxj4MaQx3M8Xhf?=
 =?us-ascii?Q?cojxnSFj8hHheKe2/WwnXcUVfc1SxxOglz/QYbzKRIQmiY/EuXMdl2dyNlz3?=
 =?us-ascii?Q?CAbYpXwjNjl0oJArX+pvP69oROLHj79lndk51SXunwbUK6LIjsXghUPQlCIM?=
 =?us-ascii?Q?2cFX4wjmQLH1UKPs8GkwOMUxoxoL1fLhX5z8dhPkBJx5YUfCK4uBOTPFXyfC?=
 =?us-ascii?Q?dm0NNhztHKSwrQXwVtsqdcF17/Yv/G3tig3OJryv2IOaNa/Qs4Y2LTWCmmby?=
 =?us-ascii?Q?n38X+8QsgtT/RqgOIMVnt8I/cycXe1MskMgEV6dlE57C63vg75WkA+rxBTUQ?=
 =?us-ascii?Q?AeGtm37psCKvk4IqmsXkvTYUnhA6OuKmSY9o3Qs1e2hv1kMtdM0iEfnbYGX8?=
 =?us-ascii?Q?9HPevW1bSkLfGGnVwUBW1G7NzxuGwPbw3bMXmdIdMYJ+FxQHKGeaRgcd+9p1?=
 =?us-ascii?Q?j8c0UqBW1IR+DF95zMnpvih8nevx+l3DYsr1NrPJrcVAGvLVhbzaO5RMYB5D?=
 =?us-ascii?Q?tXSI6e/3VFI+BQ7DUcNJkpS09cUJADHmha5izti5v+bYuYagGCwWAwodW3OM?=
 =?us-ascii?Q?4gfPs+momeBshAfVhgpX9KeoA5h+CAWSSNwcNODWX55YIXDkTQd2i/c2pyaS?=
 =?us-ascii?Q?tcBpcoos2xNHFu+co3e25eTgE18Ih4mVBNsxJgpwHiHWoIENY2+wFZ+hh99j?=
 =?us-ascii?Q?Wk5x/5JYdAU6ARW1tqfOyhCfZdsJA/iS8HB88P/cir/Qc2xGl9Doxv+GdG6B?=
 =?us-ascii?Q?Hw3pXh1UU3CogPUYzYFpOrY5FOKMPp1zpU0q4Bkym69C58WsXxmGOLAmjUDx?=
 =?us-ascii?Q?fsrwjNdTm0vtoGKc5yoZYbeIP17yoBfTMXachROOhIvMGsikiiVJhifmN0Ib?=
 =?us-ascii?Q?3MojzLR2G5GqziIOVn01Qc49RC2KFJKW2baaUg7KjEc9QfmhXFNBaFRWvzhn?=
 =?us-ascii?Q?FsXMkLROkypKkm7QnvRdEuUObauYw3Ch3KQaCZS1zflzAHZpkkxvOAbYRwo9?=
 =?us-ascii?Q?S2zrzt3U7FUh1Yf7+lIsn9ecs6uXd1TTyzWndcB0A3ogRaufhv7bpfCSer90?=
 =?us-ascii?Q?xe8xznvE7tFf62ADSPZB5llq6YtjLYFgHGg2b3AOnl/7MChwgMtCEY9R7iYC?=
 =?us-ascii?Q?fS8TdnVbB6fGdpZXV/yYNdIRGPkbC1Lxzbno7vnbo0TK5IoanBXX1JaeKNW+?=
 =?us-ascii?Q?t739i/JQXewPEPUn+L+cBn8cX1pjRUz93JCP+ArO6gWuFpcntdAc7cllYk9Q?=
 =?us-ascii?Q?1Nua5Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <41B3FD3549CE254E98343FB50BF92D17@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5ae7d7-5345-4e1a-064c-08d9984f9ab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 07:09:51.3577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jf8UErRlpzKPxLYSpljyqwK89DQJC9rbeX8H280OdYXiesIODSi5qEbNyWkBVI11lFb+zhFvLV1z30oCEqSXRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5186
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: iLuPX5vCniCEhOzvrWxSIcZAigRpen4c
X-Proofpoint-GUID: iLuPX5vCniCEhOzvrWxSIcZAigRpen4c
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_08,2021-10-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 9, 2021, at 2:03 AM, Like Xu <like.xu.linux@gmail.com> wrote:
> 
> On 9/10/2021 1:08 am, Song Liu wrote:
>>> On Oct 7, 2021, at 11:36 PM, Like Xu <like.xu.linux@gmail.com> wrote:
>>> 
>>> On 8/10/2021 1:46 pm, Song Liu wrote:
>>>>> On Oct 7, 2021, at 8:34 PM, Like Xu <like.xu.linux@gmail.com> wrote:
>>>>> 
>>>>> On 30/9/2021 4:05 am, Song Liu wrote:
>>>>>> Hi Kan,
>>>>>>> On Sep 29, 2021, at 9:35 AM, Liang, Kan <kan.liang@intel.com> wrote:
>>>>>>> 
>>>>>>>>>> - get confirmation that clearing GLOBAL_CTRL is suffient to supress
>>>>>>>>>>  PEBS, in which case we can simply remove the PEBS_ENABLE clear.
>>>>>>>>> 
>>>>>>>>> How should we confirm this? Can we run some tests for this? Or do we
>>>>>>>>> need hardware experts' input for this?
>>>>>>>> 
>>>>>>>> I'll put it on the list to ask the hardware people when I talk to them next. But
>>>>>>>> maybe Kan or Andi know without asking.
>>>>>>> 
>>>>>>> If the GLOBAL_CTRL is explicitly disabled, the counters do not count anymore.
>>>>>>> It doesn't matter if PEBS is enabled or not.
>>>>>>> 
>>>>>>> See 6c1c07b33eb0 ("perf/x86/intel: Avoid unnecessary PEBS_ENABLE MSR
>>>>>>> access in PMI "). We optimized the PMU handler base on it.
>>>>>> Thanks for these information!
>>>>>> IIUC, all we need is the following on top of bpf-next/master:
>>>>>> diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
>>>>>> index 1248fc1937f82..d0d357e7d6f21 100644
>>>>>> --- i/arch/x86/events/intel/core.c
>>>>>> +++ w/arch/x86/events/intel/core.c
>>>>>> @@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
>>>>>>         /* must not have branches... */
>>>>>>         local_irq_save(flags);
>>>>>>         __intel_pmu_disable_all(false); /* we don't care about BTS */
>>>>> 
>>>>> If the value passed in is true, does it affect your use case?
>>>>> 
>>>>>> -       __intel_pmu_pebs_disable_all();
>>>>> 
>>>>> In that case, we can reuse "static __always_inline void intel_pmu_disable_all(void)"
>>>>> regardless of whether PEBS is supported or enabled inside the guest and the host ?
>>>>> 
>>>>>>         __intel_pmu_lbr_disable();
>>>>> 
>>>>> How about using intel_pmu_lbr_disable_all() to cover Arch LBR?
>>>> We are using LBR without PMI, so there isn't any hardware mechanism to
>>>> stop the LBR, we have to stop it in software. There is always a delay
>>>> between the event triggers and the LBR is stopped. In this window,
>>> 
>>> Do you use counters for snapshot branch stack?
>>> 
>>> Can the assumption of "without PMI" be broken sine Intel does have
>>> the hardware mechanism like "freeze LBR on counter overflow
>>> (aka, DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)" ?
>> We are capturing LBR on software events. For example, when a complex syscall,
>> such as sys_bpf() and sys_perf_event_open(), returns -EINVAL, it is not obvious
>> what wen wrong. The branch stack at the return (on a kretprobe or fexit) could
>> give us additional information.
>>> 
>>>> the LBR is still running and old entries are being replaced by new entries.
>>>> We actually need the old entries before the triggering event, so the key
>>>> design goal here is to minimize the number of branch instructions between
>>>> the event triggers and the LBR is stopped.
>>> 
>>> Yes, it makes sense.
>>> 
>>>> Here, both __intel_pmu_disable_all(false) and __intel_pmu_lbr_disable()
>>>> are used to optimize for this goal: the fewer branch instructions the
>>>> better.
>>> 
>>> Is it possible that we have another LBR in-kernel user in addition to the current
>>> BPF-LBR snapshot user, such as another BPF-LBR snapshot user or a LBR perf user ?
>> I think it is OK to have another user. We just need to capture the LBR entries.
>> In fact, we simply enable LBR by opening a perf_event on each CPU. So from the
>> kernel's point of view, the LBR is owned used by "another user".
>>> 
>>> In the intel_pmu_snapshot_[arch]_branch_stack(), what if there is a PMI or NMI handler
>>> to be called before __intel_pmu_lbr_disable(), which means more branch instructions
>>> (assuming we don't use the FREEZE_LBRS_ON_xxx capability)?
>> If we are unlucky and hit an NMI, we may get garbage data. The user will run the
>> test again.
>>> How about try to disable LBR at the earliest possible time, before __intel_pmu_disable_all(false) ?
>> I am not sure which solution is the best here. On bare metal, current version works
>> fine (available in bpf-next tree).
>>> 
>>>> After removing __intel_pmu_pebs_disable_all() from
>>>> intel_pmu_snapshot_branch_stack(), we found quite a few LBR entries in
>>>> extable related code. With these entries, snapshot branch stack is not
>>> 
>>> Are you saying that you still need to call
>>> __intel_pmu_pebs_disable_all() to maintain precision ?
>> I think we don't need pebs_disable_all. In the VM, pebs_disable_all will trigger
>> "unchecked MSR access error" warning. After removing it, the warning message is
>> gone. However, after we remove pebs_disable_all, we still see too many LBR entries
>> are flushed before LBR is stopped. Most of these new entries are in extable code.
>> I guess this is because the VM access these MSR differently.
> 
> Hi Song,
> 
> Thanks for your detailed input. I saw your workaround "if (is_hypervisor())" on the tree.
> 
> Even when the guest supports PEBS, this use case fails and the root cause is still
> playing hide-and-seek with me. Just check with you to see if you get similar results
> when the guest LBR behavior makes the test case fail like this:
> 
> serial_test_get_branch_snapshot:FAIL:find_looptest_in_lbr unexpected find_looptest_in_lbr: actual 0 <= expected 6
> serial_test_get_branch_snapshot:FAIL:check_wasted_entries unexpected check_wasted_entries: actual 32 >= expected 10
> #52 get_branch_snapshot:FAIL
> 
> Also, do you know or rough guess about how extable code relates to the test case ?

Sorry for the delayed response. I finally got some time to look into 
this again. After disabling most debug configs, I managed to get it 
work in the VM with a simple change as 

diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
index 1248fc1937f82..3887b579297d7 100644
--- i/arch/x86/events/intel/core.c
+++ w/arch/x86/events/intel/core.c
@@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
        /* must not have branches... */
        local_irq_save(flags);
        __intel_pmu_disable_all(false); /* we don't care about BTS */
-       __intel_pmu_pebs_disable_all();
        __intel_pmu_lbr_disable();
        /*            ... until here */
        return __intel_pmu_snapshot_branch_stack(entries, cnt, flags);


(of course we also need to remove the is_hypervisor() check.). 

But I am not sure whether this is the best fix. 

I pushed all the change and debug code I used to 

https://git.kernel.org/pub/scm/linux/kernel/git/song/linux.git/log/?h=get_branch_snapshot_in_vm

Could you please take a look at it and share your feedback on this?
Specifically, can we fix intel_pmu_snapshot_branch_stack in vm with the
change above?

Thanks,
Song




