Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB0B426F5F
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbhJHRLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 13:11:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39124 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229606AbhJHRLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 13:11:15 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 198F0QIb026854;
        Fri, 8 Oct 2021 10:09:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=lQ3Jhk7uJEHcs1Cr9alTGhTGhHNX+r3LVwyyqhaNUlM=;
 b=Ai1JbyRxSFBmzqfNv5xzeSVOXdJ2v3Kt1nOiQnDxrtgbUBqa/8KUK1GuEsJJrJaDfjxO
 8n8jG7mfeqj6lIEskpEDabUhGMl0qjLS298VyA+gU1ef226+MT5HddVhb0rl/6pIMUUj
 2KQ1y81/iOjn4re/48XwqT+w3Q2IopxUP3c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3bjr8hs1vy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Oct 2021 10:09:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 8 Oct 2021 10:08:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRWKYS7GkDRvJ+UAsBi2zfE4oE+TkN8DEID0HigHK9ZaC7ti3gUJWdMJ7is+j2/8nA4igzjW3ieS3KBqHPnpIhjkzUs8Vp5u9V/yehEbaLHCfCbNpuiEbgvw6MPkJBuVfnB8fKjAA810OfLDuo2bB25KFQEPIzastJ06UMnXfFQbBmZUNpiRwO+j5ePO589JjNvsw2uXK3UjTv2TQ5hTWH9zH/gMmv6sEbOqqwTRI+ReiCa9Lue64FDApOx5qdB76iPuSiTnsps2/nX9E3lANKXr+4n7nDncRqYkaH1SaSdQZoBLYaqnbCt8eO56Ftpnko/Vs8oBuPF4teXwhSjTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQ3Jhk7uJEHcs1Cr9alTGhTGhHNX+r3LVwyyqhaNUlM=;
 b=J/W0H5l0eaA6bz2Jy4ao3iVrv1JvURGa1X+mIZc5v2JFQRrLVD2ovN+z7u78oJLoCN+xHHswlwWZvcWXmKME/GORTsxzNcP+i3V3zEzbRdLaaF/bdSsOar4dVxZVGCAXll4JNrc0yXqSUOMleUEldy+9ledUhnz6QSTZxxJrBfUhtMZOYlR/txF3mGBgeZzjMreMbBCNdKOtCLUjcj4tutQWFlQX3E8rB4Kr9lqdyY65fX04Zt9fUfkWWXFHxuoBCtHorOzXJ/tuffPG7hfSQXS4MRAXCXFUVd0WkJA3v40U70cIgbGkNlMuUbEvtzAMBK53lA0ga+8pT44ctarQsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5259.namprd15.prod.outlook.com (2603:10b6:806:238::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 17:08:42 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 17:08:42 +0000
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
Thread-Index: AQHXtMWNyKWclBi4s0iJww6HNTXDJ6u6n6yAgABLWQCAAAXKgIAAJheAgAAVeoCAAAoigIAAOogAgA0QG4CAACUTgIAADc8AgACwtQA=
Date:   Fri, 8 Oct 2021 17:08:42 +0000
Message-ID: <1EB93A74-804B-4EE2-AECB-38580D40C80D@fb.com>
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
In-Reply-To: <d46d96ff-02a3-5ea7-a273-2945f4ef17a5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bd10103-54a8-4a99-d48c-08d98a7e4814
x-ms-traffictypediagnostic: SA1PR15MB5259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5259D45E302CBCE3856CFF33B3B29@SA1PR15MB5259.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DwZedMI3VRZTIzLknHshXV2lG9bjraXpg9LL7hUl9HgHZ+01x3CO4x1QCqS7ymOOz7Hq7EDpmClThOxfze38RhgepH04Wgv77Tz8iqp2SHIf/g/IrJvBSYfpskDIaik8xINWorYNv9qzRYPO5pWDmYp4QlBd8xEln8RAccHFAU8dZzT8RLSwNHMGxqc6ouk942jEOhIJFVOACiA2TRcNL0tcWgM+kG1mlbIGmE2wQh6Co9GPvhJGAxXsaf9DDHEOsssWAUdYGcKGntilbBUXPtsauYgPn/0fy99uuTafN22nMy2o+B8KH/GkmVLkuRon6n7ly6cM0lHyTinAGb2QNQt2GWblF4WcmFM49HduIFqG1RsnF9irHOmho8mkbuPlzzld8CXNHuQZDpde53bIHVDHmfDArDjgr8W7uZ0s94P0XWj+imMhljY7e90jfqzgXp9CYyRhkut8Uph7vTXAfZTO3h/banqxs/VFnvo0mieZJpCshtAvuRSkM+pSvd5ARzTaw3WNdVGkz4sjCQbeNc+3/bnWjIXQxX8wqJ8kNMD8ORQubSNYEk7x4Xpj5nZts7xumWmlOtqWxNEin7BFC85zBAOt3wEpZXy1vj6eVrKrjOV2AAqtyFs70ViWLFWm5VNFX1sXs7ixBPXirnZSJ2Y3QcTMA3wASSPhaiFml8YAYOPIcCbT1X9MRV1lNYDXZIUYkHOfk6DH3gc2gykrb3Ix04FHdTz6kNv08HNIrXQ1lj+hlEWKtbrto/bTlk27yij4sxbgw3Ok4wnOFVirnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6512007)(5660300002)(186003)(53546011)(6506007)(2616005)(2906002)(38100700002)(122000001)(4326008)(38070700005)(316002)(54906003)(64756008)(66556008)(8936002)(66446008)(36756003)(66946007)(6916009)(8676002)(83380400001)(66476007)(76116006)(71200400001)(91956017)(86362001)(6486002)(33656002)(21314003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lWE7o6hmECZBJiwYNQoj3Q5Mn2Urflsshrgf5fCN3LVqBXVOD8sXsr7jHTJu?=
 =?us-ascii?Q?Yh4tniFT+nCk3uWT3r2bkB0K+Z10gbtO0ApBQ47wWxzkABVItfuWlkFypmYF?=
 =?us-ascii?Q?7AoDeCiuBaMWZksMBSnvOPpPkpsRnCFu/bojIsG+TnpftFAH3XHBp6S3vaS8?=
 =?us-ascii?Q?tSa98QanhG7e4+DGvYj8DkQBH2kaeyFgzyqk+Jbqp2nNwNwxuhd6UPObHEtT?=
 =?us-ascii?Q?YdIA3RIL/yaPsKFLtcLgLflt0YWCgniODZif2Guf8Yo+H5+zkTie6fKSnciP?=
 =?us-ascii?Q?DDeU88RbUB01HKxZsOychrgobc0kYP2hHJu65CTkYRf6FCWcUGnpffqSqfnK?=
 =?us-ascii?Q?Oe2CGd3KlpfP1Fy9pYe5Cr/UvTqKJBZKqlTMWr9MkSsTSLHyNIFcXlldLHG4?=
 =?us-ascii?Q?KKPSDhehMXRCgdLMudd5GjDLLwTdR9l7piWcUnCIaeX9hsn9BDOsu2HRQMqC?=
 =?us-ascii?Q?ruPdYw0Ip4fwv5TyV2l7pzQTdcuTmG5ON578i6q+U9xpqlwt+V81nGwyLKms?=
 =?us-ascii?Q?IlMr1aMsCLsunlhb1hyRjq9Fa+D+RFnqdfCHX+wo/OPw+z/3lWXawfQoqi7k?=
 =?us-ascii?Q?Vf/cPWX+T3CVTBjOBdxshspyiuqM0T8HG/bVwnNF6kAvnnMCYqNZvzn22gPa?=
 =?us-ascii?Q?Mg/aqgEA2De+D00jFaqa4vTcZfKBV/FDs9GSauIu5LmUbM0NOIj4OWXg1wDx?=
 =?us-ascii?Q?ntGysLLn2iaD3oG/KucC0iVqWCrP5LHWoGn7lEQ4ELFBoqUofvG6jCyPgQJG?=
 =?us-ascii?Q?ZVBwp7FaknMe8y43ca6nPgl8JraWeZWbW3ivexZKiLNRRXl41n8WF4jo1q75?=
 =?us-ascii?Q?2ntsNRZyGiGg2GSzJfJp+ArV5nnL58sCrvbLk8pdrrrTw200fIbObdWRINKp?=
 =?us-ascii?Q?aTLDWSHFEd8jefbss2a/RDbPtGlBOfRUUacqUbwcRPBAUjCjfAp2mmsEuPv5?=
 =?us-ascii?Q?quFiR+/pj5VPXvILn1ZruLPoy1Pd1l+fB2bplos6uyT/HPEt3HGp8QjPSRgj?=
 =?us-ascii?Q?rpk7pwEjoQjt7gvjF+vNQ7V9FxScZgMB3Nx9v+Ly8kWB3dULRKwp/NO00TCD?=
 =?us-ascii?Q?mW1bvlS0HLzC2R7F0IQYkdr7/fzjMojaNZTX9va/6217ONSgl6Y078+60FkH?=
 =?us-ascii?Q?J+azhgyHi0hO69O4wkOjS0YCvDAgvEMOaU5OpJUheJxvMneQe7z1gvUO3rYy?=
 =?us-ascii?Q?0lYGp9WqGA//8PrXHVQjVO+D8mnjScOnK1OCx0FiWaNWbT9QHPGQOHIRmWWH?=
 =?us-ascii?Q?QMITedWMiE+bcVUjQsv6ozkvmXBimmn1KVlxcqJf92s5pjY2aWXGrpGmrnn+?=
 =?us-ascii?Q?gQNGl//8Tti0Edilzl4kkWhxBs/p+jCE0heDHRueIuUAvEs9YG8G1HQZ3vy4?=
 =?us-ascii?Q?5tbU27w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15CAEDAD45221447AD3AA359CCC73F8A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd10103-54a8-4a99-d48c-08d98a7e4814
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 17:08:42.8367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4q2sBUEYHCjJIAi86wyjvxaUeEcteIo937uVLQ6CnS5AVbZt0Qa7oMIIC7TLIjjv4nqUdPCHhYWINmAD4g7xLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5259
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Yh01g8gPnLu4xknUUSvWgGUtCzdIhIO2
X-Proofpoint-ORIG-GUID: Yh01g8gPnLu4xknUUSvWgGUtCzdIhIO2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_05,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 7, 2021, at 11:36 PM, Like Xu <like.xu.linux@gmail.com> wrote:
> 
> On 8/10/2021 1:46 pm, Song Liu wrote:
>>> On Oct 7, 2021, at 8:34 PM, Like Xu <like.xu.linux@gmail.com> wrote:
>>> 
>>> On 30/9/2021 4:05 am, Song Liu wrote:
>>>> Hi Kan,
>>>>> On Sep 29, 2021, at 9:35 AM, Liang, Kan <kan.liang@intel.com> wrote:
>>>>> 
>>>>>>>> - get confirmation that clearing GLOBAL_CTRL is suffient to supress
>>>>>>>>  PEBS, in which case we can simply remove the PEBS_ENABLE clear.
>>>>>>> 
>>>>>>> How should we confirm this? Can we run some tests for this? Or do we
>>>>>>> need hardware experts' input for this?
>>>>>> 
>>>>>> I'll put it on the list to ask the hardware people when I talk to them next. But
>>>>>> maybe Kan or Andi know without asking.
>>>>> 
>>>>> If the GLOBAL_CTRL is explicitly disabled, the counters do not count anymore.
>>>>> It doesn't matter if PEBS is enabled or not.
>>>>> 
>>>>> See 6c1c07b33eb0 ("perf/x86/intel: Avoid unnecessary PEBS_ENABLE MSR
>>>>> access in PMI "). We optimized the PMU handler base on it.
>>>> Thanks for these information!
>>>> IIUC, all we need is the following on top of bpf-next/master:
>>>> diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
>>>> index 1248fc1937f82..d0d357e7d6f21 100644
>>>> --- i/arch/x86/events/intel/core.c
>>>> +++ w/arch/x86/events/intel/core.c
>>>> @@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
>>>>         /* must not have branches... */
>>>>         local_irq_save(flags);
>>>>         __intel_pmu_disable_all(false); /* we don't care about BTS */
>>> 
>>> If the value passed in is true, does it affect your use case?
>>> 
>>>> -       __intel_pmu_pebs_disable_all();
>>> 
>>> In that case, we can reuse "static __always_inline void intel_pmu_disable_all(void)"
>>> regardless of whether PEBS is supported or enabled inside the guest and the host ?
>>> 
>>>>         __intel_pmu_lbr_disable();
>>> 
>>> How about using intel_pmu_lbr_disable_all() to cover Arch LBR?
>> We are using LBR without PMI, so there isn't any hardware mechanism to
>> stop the LBR, we have to stop it in software. There is always a delay
>> between the event triggers and the LBR is stopped. In this window,
> 
> Do you use counters for snapshot branch stack?
> 
> Can the assumption of "without PMI" be broken sine Intel does have
> the hardware mechanism like "freeze LBR on counter overflow
> (aka, DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)" ?

We are capturing LBR on software events. For example, when a complex syscall,
such as sys_bpf() and sys_perf_event_open(), returns -EINVAL, it is not obvious
what wen wrong. The branch stack at the return (on a kretprobe or fexit) could 
give us additional information. 

> 
>> the LBR is still running and old entries are being replaced by new entries.
>> We actually need the old entries before the triggering event, so the key
>> design goal here is to minimize the number of branch instructions between
>> the event triggers and the LBR is stopped.
> 
> Yes, it makes sense.
> 
>> Here, both __intel_pmu_disable_all(false) and __intel_pmu_lbr_disable()
>> are used to optimize for this goal: the fewer branch instructions the
>> better.
> 
> Is it possible that we have another LBR in-kernel user in addition to the current
> BPF-LBR snapshot user, such as another BPF-LBR snapshot user or a LBR perf user ?

I think it is OK to have another user. We just need to capture the LBR entries. 
In fact, we simply enable LBR by opening a perf_event on each CPU. So from the 
kernel's point of view, the LBR is owned used by "another user". 

> 
> In the intel_pmu_snapshot_[arch]_branch_stack(), what if there is a PMI or NMI handler
> to be called before __intel_pmu_lbr_disable(), which means more branch instructions
> (assuming we don't use the FREEZE_LBRS_ON_xxx capability)?

If we are unlucky and hit an NMI, we may get garbage data. The user will run the 
test again. 

> How about try to disable LBR at the earliest possible time, before __intel_pmu_disable_all(false) ?

I am not sure which solution is the best here. On bare metal, current version works
fine (available in bpf-next tree). 

> 
>> After removing __intel_pmu_pebs_disable_all() from
>> intel_pmu_snapshot_branch_stack(), we found quite a few LBR entries in
>> extable related code. With these entries, snapshot branch stack is not
> 
> Are you saying that you still need to call
> __intel_pmu_pebs_disable_all() to maintain precision ?

I think we don't need pebs_disable_all. In the VM, pebs_disable_all will trigger
"unchecked MSR access error" warning. After removing it, the warning message is 
gone. However, after we remove pebs_disable_all, we still see too many LBR entries
are flushed before LBR is stopped. Most of these new entries are in extable code. 
I guess this is because the VM access these MSR differently. 

Thanks,
Song
