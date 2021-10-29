Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D85A4401B7
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 20:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhJ2SML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 14:12:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42374 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhJ2SMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 14:12:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19THwcNn029699;
        Fri, 29 Oct 2021 11:09:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=tEx6gHhKuW9BgWNoIf2s3sulVoEP4GxCZ0OCO8fBHao=;
 b=nZPtur9SzAL1ITmKeeHFSbDe9VyN8X+2F30Vc2+KY65SUc9CK1LxgmHbNnzdrt0y7Cd6
 nHpvk0sBm+z7ErbUBNDnbR1jBvpMOSZ/CIReZdFd3myiHs9avYCQgXaYjIcUskBoFzfd
 II1CeGR2x8KHf5c5QOI8mZhS5htdBZJJzgw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c03hk84e9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 29 Oct 2021 11:09:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 29 Oct 2021 11:09:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdAvwAJmzqnecRhLqYRZg4xooZUJrmTJk4tcMhnYpfvzgPDl3zDZ6RXsLTnKrzX6Vklwz+rtR3XWwOYj0dJ6spSfz6k8fh2C78Hq0sp9qLbm8db55euwZikz3UXSy10rhJl3hCUZ26b9RCFbA9C05bVjPf5vzZqMTC2GAGx3ct2E4orJGISBp7PmAc6ZbNjulTJ8+8XBm3PFBc562psEW6vQPsFFF2MwhfbdEfpDDCLDMSaeNY2Bi0CRjUC2bN8D+kQ8ux33U3/5Na85D7pyvjEkZ7TndHHS8zhollsjBuDm4txzb+kH/EJp5tSrNZg+NPxBVSYuRKeiAIXrWKogvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEx6gHhKuW9BgWNoIf2s3sulVoEP4GxCZ0OCO8fBHao=;
 b=S0fgGLUC6JsBNeiC9Ov+CvzAR1gzocf/JGb+1H5WmdiGfsmwgDzYny+I9cUY66jdF1ElRHVxuSEfhHAbObT/384nydaHNcghUHiCikQZf+oxa+2lED5/zXwd8AWEHzWG5MdnlkpT52xRv3IPpvmlpYjEgcNs/Nd+PPgFBEHtJ65mqtSdwnGdTGEl/pvnZJVKW1Hg0o8X0NjXQ1i+dexqRjgWLBi0AzFtIhQNrAP6paQvgo2zH5UncpSg7F+1c7lruLOtHBZ9JifKdF7mJ+kGYsIJ1evdjms6BhXqD25pmAnnVRG5UcDRF995aDKl203MvTd9NYgo0E3jWsCrfU8pHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5187.namprd15.prod.outlook.com (2603:10b6:806:237::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 18:09:29 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%7]) with mapi id 15.20.4628.020; Fri, 29 Oct 2021
 18:09:29 +0000
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
Thread-Index: AQHXtMWNyKWclBi4s0iJww6HNTXDJ6u6n6yAgABLWQCAAAXKgIAAJheAgAAVeoCAAAoigIAAOogAgA0QG4CAACUTgIAADc8AgACwtQCAAQraAIAal6uAgALhm4CAAo3SAA==
Date:   Fri, 29 Oct 2021 18:09:29 +0000
Message-ID: <2DD37016-2C6C-4F38-8785-697ABC850D83@fb.com>
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
 <A4E23F44-CB25-4B5B-BC65-902E943C63E5@fb.com>
 <150a7ade-8727-f7c1-cc3a-5ce8cb70804a@gmail.com>
In-Reply-To: <150a7ade-8727-f7c1-cc3a-5ce8cb70804a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46768b3d-f883-4bd5-9eb0-08d99b074045
x-ms-traffictypediagnostic: SA1PR15MB5187:
x-microsoft-antispam-prvs: <SA1PR15MB51872251C9D2B36CB327CC76B3879@SA1PR15MB5187.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F7eyoze42sgN5ves9XA/BDjLxsVpScryIMDBvpwdiYyemEtG6/HS/4bzfuzehZj/xbxhxodGNhoslVrR0rB6A4ngw0+KrN8Z+lQ2V8HEJrc6Q+8XHSH/DNN3+gCwtpeVZdHVvi6ykzyBxHqjdJ9tsdFS1aSNKitqIvr5ZZeiV952g0MAjPu31oeEb9Yq3zIRoOvrLDHZWl2c0DlHsmXk3U2hd6KAq9+2Cl7jHzrJtx/Z8BNf/X6l6EQApywf8z7ilGw5ZPjBC7yPIWVQKid6q71EWd8N+LbnIvpcgPfTin1SPr6tf5fRGUpEAz3VV0jreXtR5vpccPXopzhSWkG7GJsA2fXDHf8odmj4RsRXhCzirBofEcIipCfBDKdib+7Lf0wdrO4qwKFTnCiupsTLacqNHE6H8di4zYr/khiWAu6QFuQCVjJwECyO7Ke/DGawlw+sSXwKB+OnzStRV3tcja5S6cEY/662BAZ8tFA6e3fpGDRzTuFq0cpeUxJ4BVT3LzZHRcd7QWUArRTRgq1hS+viUh2jseofpdxXx/pwI32jJGXzAeX6XN7lNKI5//a6ZAamvJbDh6DKiZQIHAUXAMi4tfiAyHMwFCWv2amgd/8y04njIc3UrMtBui3gjFvSsnR07EvBHmOMwkfQkPP3IKxnKd8PCHnRjHX23qmnCEa/Y2wQcEDs9MoDWcFpz2sBOJoO2KQB3WPcqiddRDOih8SQUToTBskKFPCFnM/12IJZpE26Zjztkp0Le3V9Sfzdv8NzI/jCOwaf2V3q4WAyzH1uL6OAsXmKDTi5CPI2vWO8qD14f+6WhqybTv/ijdwD3mAG9w6zm9vqUUtcxS6xzRjlNhen05hejv8k8sprf8w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(316002)(54906003)(508600001)(6486002)(71200400001)(2906002)(66946007)(66446008)(64756008)(6512007)(966005)(76116006)(6916009)(6506007)(53546011)(91956017)(66476007)(36756003)(33656002)(66556008)(5660300002)(122000001)(8676002)(4326008)(2616005)(38100700002)(8936002)(83380400001)(86362001)(186003)(21314003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?km7ZCi5+rlMnY6STma61HLg2VED8nPHpwulJlPr9qgVYhvd7Hj5QVLAdbopR?=
 =?us-ascii?Q?gvAlzmzT5wMpD41r6mtxUZetEjiId0x5zf2R4bTWuX1+qNNUfw2juBBtw6Ow?=
 =?us-ascii?Q?AgORjHlaYy74UZOrg3zZLASyUbPop/vfyWrBbRGtQejCWrhiKGa8vcePJ0+m?=
 =?us-ascii?Q?SSXd97YmnbMKDCsUWXH8aTXyizgDBxO0k9LSkL3aadYibRpnXgsyM+RuiBfK?=
 =?us-ascii?Q?/5obqe/utcFA8rATaAECy/vtOZgSzO3/YWqiONzwLTZycoRO1to7wreisgX4?=
 =?us-ascii?Q?/JJsucwWI4silJX9SLbIw+DAvdtiyb4uTb2hhY6br5z0nDPnd6hRtwTd4Qtf?=
 =?us-ascii?Q?kRpsrLUlYoMgOrAyEkr0p2tTJJrhWFFdNMucXHl6z5D3gOY1Wr4cRsOOgEPF?=
 =?us-ascii?Q?LpBZKndVB2OUoOQms7KzK5iGYqXGS//7P90gNyhslRLNqMsTPVXjhudtzTkL?=
 =?us-ascii?Q?fanDcSf8LO1YMDzdZRJFIIOkw0xPDWralS2wNkWJyAq2eg3m8HvRAUKnWo1U?=
 =?us-ascii?Q?FobBM9NRFc2EliO4b4XY95fRomMDB3eYgvaHtdSdTEQTb4V5VVK06bYAZtsC?=
 =?us-ascii?Q?NbbQYZQiPlH4ZPHQxbXh2eo97nSuZQ5GO4TRupO52WCf6mVP1jVtd3sN4BCF?=
 =?us-ascii?Q?ooVHFRBtEC88pc61g8bTeTzn3koGdfDyKgKFp9Tbg2l69JHS03baFTjYAHoP?=
 =?us-ascii?Q?d7FYmef7sVHaIgiTR3jsdLqVIwBroGIJz1ZE+WHRtVPL+NOGdFbr2bbMbqkV?=
 =?us-ascii?Q?MX6VDg5/9bgeL7doiuk6BgVFEJoZAf49T8GXgeAovmVdgrjXZlsVFjSOgkwL?=
 =?us-ascii?Q?oNwUx+WqE2d+Tx2a/YpkbOw6OTsttRfL8WFuvSy+4Mjg7suelM1e4SFxXWpi?=
 =?us-ascii?Q?xbRSUg0sWpZK3K+phWQFHKcSuJaXdGFSd7P2ZCBoDBwBue3isAwW65vCumdJ?=
 =?us-ascii?Q?PNPPan26zfAV9WUntBl8wdYb/TotFOJnxaxbJq6ID/R8RJ11nlgFahN3ZE+k?=
 =?us-ascii?Q?cZ2sTUNpXEA+SVqnmBi37bcM7Nqhqe+AHcMFbVG/eMUaD245s2Lfp7+DJZDl?=
 =?us-ascii?Q?TzXhuykL264iSaS08zEsVeNdLP5h+SfsKUnax/VkKZCYoHm8Utf8Pe9scSop?=
 =?us-ascii?Q?m4Sv7t1vYcBtIfxv8/InLAijxr/0YlfxuzDJmYfifx85TvVUAsAsTBONzEIP?=
 =?us-ascii?Q?eAlFY2H9cl7vW1myvSFqfMMs4j3sJ37Z0nj2ZfM7MlEDAp8ctjtV28+pnIYo?=
 =?us-ascii?Q?K8ywVlXcYMYWO8KnjdElMh98J1hjODVB8G/pJZLdyqrwz4aP+PDVXUGRX6JM?=
 =?us-ascii?Q?RD5W46VprhanOLNvBR9QnMe5Sk7I+FJuznsYDZsDOvUxclPauBrAQzHARoBD?=
 =?us-ascii?Q?MkYcfLrHwS8JF6q3gSgVGnQ4YuFPcH6yPx168eIw3LSyn2vkRrqP3goeuQGe?=
 =?us-ascii?Q?6bdxpCFjCmHFfw6t7BRkBMWWgRREHtgS3Pw7znkG+Jmvbin03MjaXIxWrazL?=
 =?us-ascii?Q?O/56qxxBzbZ+vVBzRuMUQr9BglE/sH1PAun3m41uZyNe6fyNJyPTW+rhEWaZ?=
 =?us-ascii?Q?cKGFYl59iZKap36sg2PgSSnNrylbBavGeCrjSA2OIoHCl1KoVr1t7d+g3DDJ?=
 =?us-ascii?Q?8e2qIJa9aZE/v7OSAYPbkVJZHCtUloo9FHA/0OL3aJDJIq8NGPHEncg+Lmou?=
 =?us-ascii?Q?S19Lfw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <82DB46BB0E658E459C5D3AB28B0F8906@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46768b3d-f883-4bd5-9eb0-08d99b074045
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 18:09:29.4399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EPOs9E/2j3sWK8sWL5p8jxXlaNq02nDRjqNMUv1BsDRPztF/GugphOtivQQgHGj4eVRthjprmXNgStMpTP2u6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5187
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: VS8UXESMjagU-1J5WDjkWSUNzyxpNI47
X-Proofpoint-GUID: VS8UXESMjagU-1J5WDjkWSUNzyxpNI47
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_04,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110290099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 27, 2021, at 8:09 PM, Like Xu <like.xu.linux@gmail.com> wrote:
> 
> On 26/10/2021 3:09 pm, Song Liu wrote:
>>> On Oct 9, 2021, at 2:03 AM, Like Xu <like.xu.linux@gmail.com> wrote:
>>> 
>>> On 9/10/2021 1:08 am, Song Liu wrote:
>>>>> On Oct 7, 2021, at 11:36 PM, Like Xu <like.xu.linux@gmail.com> wrote:
>>>>> 
>>>>> On 8/10/2021 1:46 pm, Song Liu wrote:
>>>>>>> On Oct 7, 2021, at 8:34 PM, Like Xu <like.xu.linux@gmail.com> wrote:
>>>>>>> 
>>>>>>> On 30/9/2021 4:05 am, Song Liu wrote:
>>>>>>>> Hi Kan,
>>>>>>>>> On Sep 29, 2021, at 9:35 AM, Liang, Kan <kan.liang@intel.com> wrote:
>>>>>>>>> 
>>>>>>>>>>>> - get confirmation that clearing GLOBAL_CTRL is suffient to supress
>>>>>>>>>>>>  PEBS, in which case we can simply remove the PEBS_ENABLE clear.
>>>>>>>>>>> 
>>>>>>>>>>> How should we confirm this? Can we run some tests for this? Or do we
>>>>>>>>>>> need hardware experts' input for this?
>>>>>>>>>> 
>>>>>>>>>> I'll put it on the list to ask the hardware people when I talk to them next. But
>>>>>>>>>> maybe Kan or Andi know without asking.
>>>>>>>>> 
>>>>>>>>> If the GLOBAL_CTRL is explicitly disabled, the counters do not count anymore.
>>>>>>>>> It doesn't matter if PEBS is enabled or not.
>>>>>>>>> 
>>>>>>>>> See 6c1c07b33eb0 ("perf/x86/intel: Avoid unnecessary PEBS_ENABLE MSR
>>>>>>>>> access in PMI "). We optimized the PMU handler base on it.
>>>>>>>> Thanks for these information!
>>>>>>>> IIUC, all we need is the following on top of bpf-next/master:
>>>>>>>> diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
>>>>>>>> index 1248fc1937f82..d0d357e7d6f21 100644
>>>>>>>> --- i/arch/x86/events/intel/core.c
>>>>>>>> +++ w/arch/x86/events/intel/core.c
>>>>>>>> @@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
>>>>>>>>         /* must not have branches... */
>>>>>>>>         local_irq_save(flags);
>>>>>>>>         __intel_pmu_disable_all(false); /* we don't care about BTS */
>>>>>>> 
>>>>>>> If the value passed in is true, does it affect your use case?
>>>>>>> 
>>>>>>>> -       __intel_pmu_pebs_disable_all();
>>>>>>> 
>>>>>>> In that case, we can reuse "static __always_inline void intel_pmu_disable_all(void)"
>>>>>>> regardless of whether PEBS is supported or enabled inside the guest and the host ?
>>>>>>> 
>>>>>>>>         __intel_pmu_lbr_disable();
>>>>>>> 
>>>>>>> How about using intel_pmu_lbr_disable_all() to cover Arch LBR?
>>>>>> We are using LBR without PMI, so there isn't any hardware mechanism to
>>>>>> stop the LBR, we have to stop it in software. There is always a delay
>>>>>> between the event triggers and the LBR is stopped. In this window,
>>>>> 
>>>>> Do you use counters for snapshot branch stack?
>>>>> 
>>>>> Can the assumption of "without PMI" be broken sine Intel does have
>>>>> the hardware mechanism like "freeze LBR on counter overflow
>>>>> (aka, DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)" ?
>>>> We are capturing LBR on software events. For example, when a complex syscall,
>>>> such as sys_bpf() and sys_perf_event_open(), returns -EINVAL, it is not obvious
>>>> what wen wrong. The branch stack at the return (on a kretprobe or fexit) could
>>>> give us additional information.
>>>>> 
>>>>>> the LBR is still running and old entries are being replaced by new entries.
>>>>>> We actually need the old entries before the triggering event, so the key
>>>>>> design goal here is to minimize the number of branch instructions between
>>>>>> the event triggers and the LBR is stopped.
>>>>> 
>>>>> Yes, it makes sense.
>>>>> 
>>>>>> Here, both __intel_pmu_disable_all(false) and __intel_pmu_lbr_disable()
>>>>>> are used to optimize for this goal: the fewer branch instructions the
>>>>>> better.
>>>>> 
>>>>> Is it possible that we have another LBR in-kernel user in addition to the current
>>>>> BPF-LBR snapshot user, such as another BPF-LBR snapshot user or a LBR perf user ?
>>>> I think it is OK to have another user. We just need to capture the LBR entries.
>>>> In fact, we simply enable LBR by opening a perf_event on each CPU. So from the
>>>> kernel's point of view, the LBR is owned used by "another user".
>>>>> 
>>>>> In the intel_pmu_snapshot_[arch]_branch_stack(), what if there is a PMI or NMI handler
>>>>> to be called before __intel_pmu_lbr_disable(), which means more branch instructions
>>>>> (assuming we don't use the FREEZE_LBRS_ON_xxx capability)?
>>>> If we are unlucky and hit an NMI, we may get garbage data. The user will run the
>>>> test again.
>>>>> How about try to disable LBR at the earliest possible time, before __intel_pmu_disable_all(false) ?
>>>> I am not sure which solution is the best here. On bare metal, current version works
>>>> fine (available in bpf-next tree).
>>>>> 
>>>>>> After removing __intel_pmu_pebs_disable_all() from
>>>>>> intel_pmu_snapshot_branch_stack(), we found quite a few LBR entries in
>>>>>> extable related code. With these entries, snapshot branch stack is not
>>>>> 
>>>>> Are you saying that you still need to call
>>>>> __intel_pmu_pebs_disable_all() to maintain precision ?
>>>> I think we don't need pebs_disable_all. In the VM, pebs_disable_all will trigger
>>>> "unchecked MSR access error" warning. After removing it, the warning message is
>>>> gone. However, after we remove pebs_disable_all, we still see too many LBR entries
>>>> are flushed before LBR is stopped. Most of these new entries are in extable code.
>>>> I guess this is because the VM access these MSR differently.
>>> 
>>> Hi Song,
>>> 
>>> Thanks for your detailed input. I saw your workaround "if (is_hypervisor())" on the tree.
>>> 
>>> Even when the guest supports PEBS, this use case fails and the root cause is still
>>> playing hide-and-seek with me. Just check with you to see if you get similar results
>>> when the guest LBR behavior makes the test case fail like this:
>>> 
>>> serial_test_get_branch_snapshot:FAIL:find_looptest_in_lbr unexpected find_looptest_in_lbr: actual 0 <= expected 6
>>> serial_test_get_branch_snapshot:FAIL:check_wasted_entries unexpected check_wasted_entries: actual 32 >= expected 10
>>> #52 get_branch_snapshot:FAIL
>>> 
>>> Also, do you know or rough guess about how extable code relates to the test case ?
>> Sorry for the delayed response. I finally got some time to look into
>> this again. After disabling most debug configs, I managed to get it
>> work in the VM with a simple change as
> 
> Yes, most of the contaminated lbr records come from these guest symbols:
> 
> intel_pmu_snapshot_branch_stack
> native_write_msr
> trace_hardirqs_off
> lockdep_hardirqs_off
> __lock_acquire
> mark_lock
> migrate_disable
> rcu_is_watching
> bpf_get_branch_snapshot
> __bpf_prog_enter
> 
> I think we're fine with the current guest LBR emulation, right?

Yes, current result looks good to me. But it does rely on the .config.  

> 
>> diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
>> index 1248fc1937f82..3887b579297d7 100644
>> --- i/arch/x86/events/intel/core.c
>> +++ w/arch/x86/events/intel/core.c
>> @@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
>>         /* must not have branches... */
>>         local_irq_save(flags);
>>         __intel_pmu_disable_all(false); /* we don't care about BTS */
>> -       __intel_pmu_pebs_disable_all();
>>         __intel_pmu_lbr_disable();
>>         /*            ... until here */
>>         return __intel_pmu_snapshot_branch_stack(entries, cnt, flags);
> 
> LGTM.
> 
>> (of course we also need to remove the is_hypervisor() check.).
>> But I am not sure whether this is the best fix.
>> I pushed all the change and debug code I used to
>> https://git.kernel.org/pub/scm/linux/kernel/git/song/linux.git/log/?h=get_branch_snapshot_in_vm
>> Could you please take a look at it and share your feedback on this?
> 
> How do we inform the user of bpf_get_branch_snapshot in a reasonable way
> that the lbr data will be inaccurate when using the debug kernel?
> 
> Is it better to check for mutual exclusion in code or to use the user documentation
> to specify this part of the restriction? It affects the user experience.

In uapi/linux/bpf.h, we have 

 * long bpf_get_branch_snapshot(void *entries, u32 size, u64 flags)
 *      Description
 *              Get branch trace from hardware engines like Intel LBR. The
 *              hardware engine is stopped shortly after the helper is
 *              called. Therefore, the user need to filter branch entries
 *              based on the actual use case. To capture branch trace
 *              before the trigger point of the BPF program, the helper
 *              should be called at the beginning of the BPF program.

I guess this is enough. 

> 
>> Specifically, can we fix intel_pmu_snapshot_branch_stack in vm with the
>> change above?
> 
> At least it's a valid fix and we can start from this change.

Thanks! I will send the fix. 

Song

