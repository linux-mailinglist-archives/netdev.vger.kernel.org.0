Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85D95696D0
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiGGATP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiGGATN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:19:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE0E24BD0;
        Wed,  6 Jul 2022 17:19:12 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266L6qFA010719;
        Wed, 6 Jul 2022 17:19:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=JteG4iqaT42utwhciawekfcw5RZ+hWVIDwbSWCf5JaI=;
 b=rhIfQL14BToQO4jJYexcocr6ZKwksRNQcktI1QSVU4Tr0e3s90oDleipUyrgK2IKC2bI
 ecHMKEtpBCUnIMEppo3DFQG2C6HJQTw3v2NG1NvNrK4av2r3sLhMbbPiKVPE2OMB4AgZ
 Df2i+i8Qhc5vD5XY2AJuX7NQEIPTP80be3Q= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h4ubv2h5h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 17:19:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDbn3znj78pyJIyHmo5FvPU5MtNQaW/NtSvcerazgyWb0cJGzFhF4Kl2Hq1/jkNGE515UxH251NjAt42d2n33lppxggaDlKEfQFrIb1oJwD2vWVxBsByRlFu/ewoiohlm7t5Idr1MnWVvxuebbAsh6w6xfojgMnh1JUur/2LNu2C5Lc7yBYp8QnpxD9+QxyBzA/Q1r6gz5QeLxXGCp/JxNgRSDAnH5uLKhP1G16gKsbJg1CLU2/HIL/A70GDuayha5mvxAFnwd1Bp0s1Rqv0N4vnfiVSprH/2HKmGWjKQWDg+aKvJaFwN+gD7ljX1tC4u8VCCVNu5SPX1XkC8LMf7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JteG4iqaT42utwhciawekfcw5RZ+hWVIDwbSWCf5JaI=;
 b=S8iMwvsP49zERkRfugtXnX6FC97Vfi+XH091Yq4PnX+1w2slDrgxQxWMVkkM6upK/1rB3LpsXuVjzn0rlvJhby+W734MXRKqLhwcC7CooERUhZd/gfljrWbLv239oAE2XMlv2vYx5/NtEpAsQZSUm/FbUlnypqy7jN1RF7u6kI3PiKVZt2fKcyiIt1kplSJRSV2i+Fwf3d8N/I2rf7O2ua4olbsh751ZCOmKOqUJPS/CDHad5x/IIwYm3ppvUekecqeu5ArODhlDmcdI+8SCNZ/B6JzuYo86SGzVzt5W+auSXXFzng3fTiMVtNGHaA3Y1kP9le7+WERAX+9++FemLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5080.namprd15.prod.outlook.com (2603:10b6:806:1df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22; Thu, 7 Jul
 2022 00:19:07 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 00:19:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrj21zA3ifq/PEC7Yw0zyJbSw61x8o6AgAAhSYCAAADUgIAACcQAgAAD14CAAB6eAA==
Date:   Thu, 7 Jul 2022 00:19:07 +0000
Message-ID: <9E7BD8AD-483A-4960-B4C6-223CC715D2AF@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-6-song@kernel.org>
 <20220706153843.37584b5b@gandalf.local.home>
 <DC04E081-8320-4A39-A058-D0E33F202625@fb.com>
 <20220706174049.6c60250f@gandalf.local.home>
 <ECD336F1-A130-47BA-8FBB-E3573445380F@fb.com>
 <20220706182931.06cb0e20@gandalf.local.home>
In-Reply-To: <20220706182931.06cb0e20@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99f20b9b-6c76-4cf6-17df-08da5fae4e9b
x-ms-traffictypediagnostic: SA1PR15MB5080:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cCiGTlrlnC1fTFeGUzlMq9iHt/QhR4NZ0VMKoko7TpiVhCrMuVOUPsstfVLgQAFtcFyxlTX620CoDemWiU3eJr25tIkhjaXK3xbAu0O2mDxagHOnTuJ2ABgvgPw9yoE5b740pSjxvZuMHmdFr+/VrBedJRyrjNnctWLmhkhc98nDuJiyaBGKXKIhEHeGbj6dvgJWio42H1MDSGblmqNAzKyxJBKVd8QZZ1B3/Pns//tJ/YBWhCwsMYr8bmrLHotzxAiLKQffYa+A76QFxjOhDj7VVz6VYvdsFgjUSbyCfRoKwq1C6ck0L61MKwHPEafVmmXFcpHuMaiNo/yE6x1M3+4NmHi/9ALZGMc2wJhAGBQQNnVHmdk8lvXBLkTUodTJtcARaLKNi3y2AIJq48BYZxedZlFyvfIQjac7t4u9MrRmxvAuXArtmSawc/xy7IaHBx1bBzOwrvVMp+To+3Tig6iwem50yG8pxk9bt+mkYGgAD634Vn07hZN7CEiUhyXE18OOX/gt+ZMNN3EAZ96nWhoPDowtR0CJoQMJQt+96bOsEcU61Q8MPKxxpHl/jGWcUD/gP5fDELyA6X60hwbxZxOcvk/51Eej5BUE2fJV724ZhaXMGwKcnEhLdd9TySKZ3Ei0dBj09mxQI1E7P8fHoWc0FXx4HzgGGr78vxGAjzJZtsk6shVfutHd1mGWVmQ2SZY8TuIhmtZUuqFdvXoNrq6pkZ0Fw4iunLj6jFL8zaGhcHzHmOII/4v/lapqMV9yeBvyUor2uGOHQeAA+uHtstMgdqCkGGeCGwIS55p16zve5vXLis0RifTxdVgenLnVVnjwh5o+BwI/kQEv28Yc3uUq0mZ89r9SaLEiFthXJXc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(86362001)(122000001)(6486002)(4326008)(54906003)(6916009)(7416002)(38070700005)(8936002)(5660300002)(64756008)(66476007)(76116006)(316002)(66556008)(38100700002)(2906002)(91956017)(66446008)(8676002)(66946007)(6506007)(36756003)(83380400001)(53546011)(33656002)(41300700001)(6512007)(186003)(2616005)(71200400001)(478600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eAqol4gwM0nuwM4PhW/LCaFL2D35xkBJ2bHh/adgcj0J6ZNVgB4YpABfyECS?=
 =?us-ascii?Q?Qtx5lRg+tk5f0zRvqA8uvKyQE+wJ5P85wuCad/JJcx0d/Txgieascjp+5p+o?=
 =?us-ascii?Q?xKnBFz5wMqMEOWqQNckKzE4trl77/g3CX8OXqYP17HLE+wwaCUaa2KkbPd+9?=
 =?us-ascii?Q?lgHGfSRLjiZDhxE99wxHenrwtrMqNihN1MAglBQJATmr5oWvO8Y8AsLgS+TK?=
 =?us-ascii?Q?jEqtJqHq7UCn9L8+3VMLBfra4jnBzvVODuDAR0/ESO40xwvs8qe7RjoOGFcZ?=
 =?us-ascii?Q?he/VoB81xmemg3lqH7AxmJvlWRX7ev0wmtxIugQmwpTSjT1XJ5Zp+aBl7uQn?=
 =?us-ascii?Q?OptYXzCzMHUTbzWFKjdFMe098VnVtnIU1H6EYA/pxaK0NPnPlizOAQeuR+w7?=
 =?us-ascii?Q?SeBjZKfbNBB78hK/v++v+HBuooVooOlO3OGT47AtQiO8c6HqEICZARrGMwvs?=
 =?us-ascii?Q?u9Uf3hogjfah6QfWIchl3Ff/Ny6o2y6yOSstFjd/m2gEcgPXhaOtv2NojZsf?=
 =?us-ascii?Q?p5UoDH/7iphi87psTKzD2f1zhbG+s+Qvj5L8rFC2tXuvcRXH/ORGMbTzdRUf?=
 =?us-ascii?Q?cOPE3c0ns5Jj00LhTWzeFC0FHZSXez9IhGRXyLTEJkf0EARp0le6ed7m7ZkT?=
 =?us-ascii?Q?PWjWAb6z9oBbZ/oJQ6bIZpYeGnJzPxRENJxpR5kv2Gns81slg2zHa56VVxEp?=
 =?us-ascii?Q?RaiqS7wF8rRuloReOuu48Y3GS+HSHTeaSBHpkKpx+N+vWSykGFnHJUApWuno?=
 =?us-ascii?Q?5Jg1dqA74OAV7ZGGMxGAO696O4zEisw1nnKTBYQwGiwozVnLSY0KjJRj1tqB?=
 =?us-ascii?Q?awKdBwkkuX4ENFwZbbg2Orv78vnxJwBHx4NT/GJPOSL3rlQt3HhlCnbBFy+0?=
 =?us-ascii?Q?Fzsc6M7PODENHeDBL2yN33oeuAFJ/k8ON1Gt+Kk/R+RRstRRfYmNtH5Hx8wz?=
 =?us-ascii?Q?0+YAos5YvxfQDEEkQ44R3biSm/lT8BJqVr3AuQQFaRE4ZvefJZ8rhxZLCRWF?=
 =?us-ascii?Q?QWLRH1O8L2K059HZtzBPnJuCe+utaLJoxeHWjA7F0yvPm1/vCDiS7sCeBmTN?=
 =?us-ascii?Q?xBsNgXf68M7aM/5bfxhwTEFNxMz/4GMuCayOglzz+7xoSzalNeBM27w/HOod?=
 =?us-ascii?Q?hpiiAtKlD8UIdsRuRKrxFMf2ufZqlKIIpwYQkDI8oXlUtRFzxstVN9mJCeAP?=
 =?us-ascii?Q?Zij79PopTJcQ88DP34Y3+9FoswMZ9tPjk8HBY7uexvZbDgiumsSl7xAKMlVZ?=
 =?us-ascii?Q?xbrpLX3lbEcxUMhdHXkDjMO7CeuVkPspYbhhCjj+2aQ7ZiPOtZuNu8J8CUgA?=
 =?us-ascii?Q?F/btx75lbwAcIqqzCl7NQHbd2+mGVzWSDZm8W9OXlE9MKnofmOr1CZQVeqNt?=
 =?us-ascii?Q?rcis2XgkxACI9nw+xBVTfGvLLM8G3zWOwt27MvcEb30ncNJGDPyojlKAV91O?=
 =?us-ascii?Q?2c7H1DV5crOk1s7IzDiwHmzTf7oZm3K8sOc77ZZTFUSfkDKjuH1eqaR4QBoD?=
 =?us-ascii?Q?jg6eS6duJhCAxwPPDYqLATSXhN8F73WTsWNoSIG03WEIAnOwOB/It3hhDKoH?=
 =?us-ascii?Q?WIAcxbqw9bqxrbx0G0nSjx9EKlaHMycrgdZbDR7TPWtXCmzNRnZ/pa8HiPrU?=
 =?us-ascii?Q?RsR85dUteLDqCyWKfrwVo04=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F240261C912EB4E88E6FECF07D11553@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f20b9b-6c76-4cf6-17df-08da5fae4e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 00:19:07.3768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qC5v9fnf4v/ZKur9udjg2O5HZPkzO11OOa4Wn67YPV3BkdxYYavZUqAXz/38qNbLd5OcQ3RpXlaMadB/gipSPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5080
X-Proofpoint-ORIG-GUID: hugLijs_WOVjo6hZgX19TmyBYyal-LEL
X-Proofpoint-GUID: hugLijs_WOVjo6hZgX19TmyBYyal-LEL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_14,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 6, 2022, at 3:29 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Wed, 6 Jul 2022 22:15:47 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>> On Jul 6, 2022, at 2:40 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> 
>>> On Wed, 6 Jul 2022 21:37:52 +0000
>>> Song Liu <songliubraving@fb.com> wrote:
>>> 
>>>>> Can you comment here that returning -EAGAIN will not cause this to repeat.
>>>>> That it will change things where the next try will not return -EGAIN?    
>>>> 
>>>> Hmm.. this is not the guarantee here. This conflict is a real race condition 
>>>> that an IPMODIFY function (i.e. livepatch) is being registered at the same time 
>>>> when something else, for example bpftrace, is updating the BPF trampoline. 
>>>> 
>>>> This EAGAIN will propagate to the user of the IPMODIFY function (i.e. livepatch),
>>>> and we need to retry there. In the case of livepatch, the retry is initiated 
>>>> from user space.   
>>> 
>>> We need to be careful here then. If there's a userspace application that
>>> runs at real-time and does a:
>>> 
>>> 	do {
>>> 		errno = 0;
>>> 		regsiter_bpf();
>>> 	} while (errno != -EAGAIN);  
>> 
>> Actually, do you mean:
>> 
>> 	do {
>> 		errno = 0;
>> 		regsiter_bpf();
>> 	} while (errno == -EAGAIN);
>> 
>> (== -EAGAIN) here?
> 
> Yeah, of course.
> 
>> 
>> In this specific race condition, register_bpf() will succeed, as it already
>> got tr->mutex. But the IPMODIFY (livepatch) side will fail and retry. 
> 
> What else takes the tr->mutex ?

tr->mutex is the local mutex for a single BPF trampoline, we only need to take
it when we make changes to the trampoline (add/remove fentry/fexit programs). 

> 
> If it preempts anything else taking that mutex, when this runs, then it
> needs to be careful.
> 
> You said this can happen when the live patch came first. This isn't racing
> against live patch, it's racing against anything that takes the tr->mutex
> and then adds a bpf trampoline to a location that has a live patch.

There are a few scenarios here:
1. Live patch is already applied, then a BPF trampoline is being registered 
to the same function. In bpf_trampoline_update(), register_fentry returns
-EAGAIN, and this will be resolved. 

2. BPF trampoline is already registered, then a live patch is being applied 
to the same function. The live patch code need to ask the bpf trampoline to
prepare the trampoline before live patch. This is done by calling 
bpf_tramp_ftrace_ops_func. 

2.1 If nothing else is modifying the trampoline at the same time, 
bpf_tramp_ftrace_ops_func will succeed. 

2.2 In rare cases, if something else is holding tr->mutex to make changes to 
the trampoline (add/remove fentry functions, etc.), mutex_trylock in 
bpf_tramp_ftrace_ops_func will fail, and live patch will fail. However, the 
change to BPF trampoline will still succeed. It is common for live patch to
retry, so we just need to try live patch again when no one is making changes 
to the BPF trampoline in parallel. 

> 
>> 
>> Since both livepatch and bpf trampoline changes are rare operations, I think 
>> the chance of the race condition is low enough. 
>> 
>> Does this make sense?
>> 
> 
> It's low, and if it is also a privileged operation then there's less to be
> concern about.

Both live patch and BPF trampoline are privileged operations. 

> As if it is not, then we could have a way to deadlock the
> system. I'm more concerned that this will lead to a CVE than it just
> happening randomly. In other words, it only takes something that can run at
> a real-time priority to connect to a live patch location, and something
> that runs at a low priority to take a tr->mutex. If an attacker has both,
> then it can pin both to a CPU and then cause the deadlock to the system.
> 
> One hack to fix this is to add a msleep(1) in the failed case of the
> trylock. This will at least give the owner of the lock a millisecond to
> release it. This was what the RT patch use to do with spin_trylock() that
> was converted to a mutex (and we worked hard to remove all of them).

The fix is really simple. But I still think we don't need it. We only hit
the trylock case for something with IPMODIFY. The non-privileged user 
should not be able to do that, right?

Thanks,
Song 

