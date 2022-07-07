Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455965697CF
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 04:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiGGCLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 22:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiGGCLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 22:11:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3322F381;
        Wed,  6 Jul 2022 19:11:51 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266L6jnD018361;
        Wed, 6 Jul 2022 19:11:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=yO5Pv5Gmpjcw6aWZJt0vMzRmiz904Y5SlN4AL8kDvBk=;
 b=PS83kkJCIx4e7g89Wu8QcsB6CW9adHevLGw6Brr8rEMhQd0PyqfzlrQ4Ew+Ub3LR81ef
 V38MUlIdN1pZv95+BNTojDY0PlPbtHZqq06KBu71dtBeu8CDCYDKWQz8CEvuFQGo352K
 LhxKiNBoy/qH/Zy5EgmtbXC+fugstgs+duE= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h4uaqjk49-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 19:11:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3JoDN/fjctnLrhw4eBeOR1TmkbfWmKehJQW4iyHWhUFtnbiPDksARJ9gxX2xmz59IGEXbI5reKEyGRNoALP9U7Hp95JuC5CkhkWDMJZKYWuDwwjhWTSXEmChx+h9phccg2cKNqwcGJXm3mgn64yx5MLCG03N1W2e4fobxF3OrH93hNlnUlneDVyc5vfb9eayxiNoml6fGiIIdaPGXleilNBfddCepkBYQ/h/3ZwMV27CZU7zy/jKL1VRSNjs/Qb04iLwkWmdx00hqHQjEv7dtJWYuHlYWVDOg3EdA1EQ+fd3r/mRuHNmrsa2WEF4kjKUs8hrVgFLWXiNGl3JziL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yO5Pv5Gmpjcw6aWZJt0vMzRmiz904Y5SlN4AL8kDvBk=;
 b=HsKc3cwetw1awfq/ZpQyWavq8vjWIjHuibQPPcBi1uYh86C+Pj7p+Smh4JSmZghsNywlcrl2WBtPfuIXpjEtjJRiIv1DVf42TZTeJiDL64Xx7rWkFHJIMKk+bXK7/AQNM5g+hXL4xfq5gxekHBTcOfrkMuFJE1d9YLKgLHEGDtYC2uWxtIPnQ/K1QUI7WR6iqFmT0ssizouO3ryYMvYAs4j/F9m7IsKThqBIQLxEAoAVhpyub+62G79UUqx2r3X3qL3/B+ZEJoq53bQsU74w0F2us+CbsVbeIEeO1SsmU5pnCmtsxkaHZAYr9d37winvY8Jxa9IiJkWcCYoZIjsM/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR15MB1131.namprd15.prod.outlook.com (2603:10b6:3:b9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22; Thu, 7 Jul
 2022 02:11:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 02:11:46 +0000
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
Thread-Index: AQHYdrj21zA3ifq/PEC7Yw0zyJbSw61x8o6AgAAhSYCAAADUgIAACcQAgAAD14CAAB6eAIAAELoAgAAOwQA=
Date:   Thu, 7 Jul 2022 02:11:46 +0000
Message-ID: <6B42E0CB-6BDB-485A-A5F0-AFEA148204AB@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-6-song@kernel.org>
 <20220706153843.37584b5b@gandalf.local.home>
 <DC04E081-8320-4A39-A058-D0E33F202625@fb.com>
 <20220706174049.6c60250f@gandalf.local.home>
 <ECD336F1-A130-47BA-8FBB-E3573445380F@fb.com>
 <20220706182931.06cb0e20@gandalf.local.home>
 <9E7BD8AD-483A-4960-B4C6-223CC715D2AF@fb.com>
 <20220706211858.67f9254d@rorschach.local.home>
In-Reply-To: <20220706211858.67f9254d@rorschach.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 688a4717-9d58-4e5e-d6c3-08da5fbe0b8b
x-ms-traffictypediagnostic: DM5PR15MB1131:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: us8iT+N2GGEVvv4R+SSTSnxmGD4C1ZKUh09CUmgWTMOTvcEh4yxoF6Q/mjMjOfbQqNTL5XZ53MoMMgtGq/44waH58EP+J/NkP+V244hO//HhbtpO2tnrZuQHisyNUc42fax3Xi2p+1JSDbP1kUMQ/o8vQbb4TmuXn3Wap/OKMQH3RASb4NcqA3/Gh4FHlU2NWyAuc3GmreLvc5C4mca5b6X+oZzX7oAhArIilSOiqcK0+hlNTfZofWE1rzumfT82u+bZ6BahisTOWAC/O6wk81R75LKdS7SCkcaInwbdFxrIMQbhThtnbfTMHW9cSyJEVWgIPuUw048F8sPSqlktubLapVWKI892LrLJwdjDmQ1qVWNs+G6hxvh0PR+DlcisB7JdgdfoC0IdHnzrOIgR5qQ3QCKxGBqYrMpsa7Omh/DmyaPa9B+x97AlY9iw93h6Silt74A+Ej42qZ+n16sZqRhYHzam5phKC936scxGWnUmcozZxq860t9RyoMARjSucbaeDDsQnIF4Flm9wjR4GeqXZuR+I0VHJGg09CijyohcbHthVqf80HakxRxwLk3tEmczb7CU8palXKqP/jE8hssQdjasnenoX1M5MdnQWefszqHDAXjh+ILHvQtCm4Kks2hh6B8Y/MlMqOqp/dg5DXdq6UEIMso8NeDnIWM+Ei59ESVWuk+sFj0yWkhvnSoeMg8PXUMbt4mw18fZhsF/2SBJ0GW+FTsT9H9Mh7ay6rqyYna8neqaAYJ1l/WYRnvqnPBKg4yLC7GFPj/GOBiX6JnJ/zCwkkg27dDMyebtbDhrTJKCMiVIGqCJ9wk2ufsVxnp1hZUWSeX+vz8TAxBx1ZMRGgSpgo0Z5CuDsOnrRO4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(6916009)(6486002)(4326008)(54906003)(86362001)(38070700005)(5660300002)(7416002)(8936002)(122000001)(76116006)(66446008)(64756008)(316002)(38100700002)(66556008)(8676002)(66946007)(91956017)(2906002)(66476007)(6506007)(36756003)(83380400001)(53546011)(33656002)(41300700001)(6512007)(2616005)(478600001)(71200400001)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8PRYGOm20volpsd71RkfUd0K/Wi1hdqMOB3416hyG+oUe+aci7A92/ShL7Rr?=
 =?us-ascii?Q?pP/+cg81kjAAyXFOc6hHWbq4rdnvP/qAnRlArCkrL+BiHMFHlmPLBSY4wfbo?=
 =?us-ascii?Q?/A5mm1pVltH3NY6pFwCDevVJnNTcWh67PyMBW/Km5zlqpg06RWIxnt9e8D7P?=
 =?us-ascii?Q?p1ThOPRtbKh3XGRFD9vjqO1QEEgKzVdqta9OB1xpDLUHROGOmyd3ze86yXYf?=
 =?us-ascii?Q?QF/Jxb36Je1I72VZmsSkW+Ibj5HSa6veK7JRiV1+s6ohnTZGt1eLhEi+svqZ?=
 =?us-ascii?Q?pvAzKE1pB/WrgR4X/v9DgaWtr8TlRvU67vONcrak8IonSlggQRUnfwbovray?=
 =?us-ascii?Q?xcWGevSjTSoPrHKNkxWz7weIIxp0vAz44I4CkO/eG4lS4+gc5215Ps5ib+aV?=
 =?us-ascii?Q?5Dh8qcHGqk2o0kEeLFZd4ZzCS4YDxqACXXPqkXGJiJiQ5imWPyH1T5Qxl7+6?=
 =?us-ascii?Q?qmC6yDc9Vy0fkFpkcsOc/OLc15XdS9TdHZblo/zky637wttbJrmceP6yS5JP?=
 =?us-ascii?Q?WWihAGRyMmZp/8P2xlzZMysS+zPWYKtithJnu/gNsvId2ixXbc/mTt1srvC+?=
 =?us-ascii?Q?f+q76jAJOaY3KKv48W+81aODH+XKikCrmbZ+gdhrQ02yxWks9oyk2YO18c2o?=
 =?us-ascii?Q?3GC8i3Z2ZOtYfO0VektAVLPP8aZRZW/kIpbdzoQ0khQW3+Igp+kgX+6Mz0wK?=
 =?us-ascii?Q?+DNyRzQBcWy3kuStOpDUSWASqj1URqZUOETGspY3kCetTZkSq3p9pl/CvTs7?=
 =?us-ascii?Q?CX079y07uTUwYH6vX1k2hZPMRSK5Pym989GMg83cxghmEixfIClnm4P4xoqB?=
 =?us-ascii?Q?LRuNl7jXw9jwLySjuExqmkInLQNwip7LCrk+CKFv1W4W6hjejGmLLGZjonM7?=
 =?us-ascii?Q?W8uW6jdoBz2dUKKBHn9QFrfNxz7Iju8lmAoFumrP9iQlY/XG0EFYZNjuYbIe?=
 =?us-ascii?Q?vSj3c8GiEHsuD2a4flyUbWEgct1LglkJU55YigakaBCTG+1jK6Kizr0TsN0+?=
 =?us-ascii?Q?ZWD3a3zpgYXUyAI7/GoTajqCtE7dQIaG83RelMdYetH82DshENk61zv6dJxq?=
 =?us-ascii?Q?3+lMN0LOAjQRVvzQZgxdh3PXjHr/2/ymGy9tmJPdgP0iD6MiJHgQ8z3o7PLs?=
 =?us-ascii?Q?sQKuqWphIdnsnHWym+QiK3eEVnrRrpJItRimiSoC1K+H5tVktGsoEb3r8MpV?=
 =?us-ascii?Q?F98YdAxl8amXmZI6+j2RuFITyKCPTAGrWvfvf3T1HtWBFqCXGTbbmSnUGrsv?=
 =?us-ascii?Q?5nR+O4rUhh4kE8jbfIOhg3f6Jx5ldGhYMXZiiW89Ml64oD5xjthVoV4gbSyP?=
 =?us-ascii?Q?39Z/eNVEwsHxahVYkRIPlVN/6h5wuJy29hI8Xu96HmRmQsUsSMMz67McMcmS?=
 =?us-ascii?Q?vbI1Jd+lkKdd03PHenStNT4xqTZXYg9m/8eqXR6lhC4ZdhEYR+Pbagy3LSMn?=
 =?us-ascii?Q?le1VeuU2jccls+3PrjkcCKNEqbHg9MiN+B3Y4Nsfp/BNTZtFK9vNpUtaP4p3?=
 =?us-ascii?Q?HKUZWTEccg6XBJt3iWPLG9Cj4PyzBbogz+2VdY3eaxp+tRB8aj56yjvn3k1/?=
 =?us-ascii?Q?DpStKgIsCS+gKooIV3O+QDXLfhP5KmtKlfdLvyWkwEy/4B2UAhsIY9gxazWe?=
 =?us-ascii?Q?wAA1RGa0Cf4y+jFEVcocS50=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0ECFB332E938384189CBD4509CDFD55B@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688a4717-9d58-4e5e-d6c3-08da5fbe0b8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 02:11:46.8329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: osW5ouwj+JVUGxs5japuOCt4ictsQEjE+e18z9NdMeoZEbeYmamuLp7SD3nPsMpw/wtlEiq1fnGDev6v9b9nOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1131
X-Proofpoint-GUID: NIwxl8cxdP4LxBO_hwcaUoQl2xSLNsL3
X-Proofpoint-ORIG-GUID: NIwxl8cxdP4LxBO_hwcaUoQl2xSLNsL3
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



> On Jul 6, 2022, at 6:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Thu, 7 Jul 2022 00:19:07 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>>> In this specific race condition, register_bpf() will succeed, as it already
>>>> got tr->mutex. But the IPMODIFY (livepatch) side will fail and retry.   
>>> 
>>> What else takes the tr->mutex ?  
>> 
>> tr->mutex is the local mutex for a single BPF trampoline, we only need to take
>> it when we make changes to the trampoline (add/remove fentry/fexit programs). 
>> 
>>> 
>>> If it preempts anything else taking that mutex, when this runs, then it
>>> needs to be careful.
>>> 
>>> You said this can happen when the live patch came first. This isn't racing
>>> against live patch, it's racing against anything that takes the tr->mutex
>>> and then adds a bpf trampoline to a location that has a live patch.  
>> 
>> There are a few scenarios here:
>> 1. Live patch is already applied, then a BPF trampoline is being registered 
>> to the same function. In bpf_trampoline_update(), register_fentry returns
>> -EAGAIN, and this will be resolved. 
> 
> Where will it be resolved?

bpf_trampoline_update() will set tr->indirect_call and goto again. Then the 
trampoline is re-prepared to be able to share with the IPMODIFY functions 
and register_fentry will succeed. 

> 
>> 
>> 2. BPF trampoline is already registered, then a live patch is being applied 
>> to the same function. The live patch code need to ask the bpf trampoline to
>> prepare the trampoline before live patch. This is done by calling 
>> bpf_tramp_ftrace_ops_func. 
>> 
>> 2.1 If nothing else is modifying the trampoline at the same time, 
>> bpf_tramp_ftrace_ops_func will succeed. 
>> 
>> 2.2 In rare cases, if something else is holding tr->mutex to make changes to 
>> the trampoline (add/remove fentry functions, etc.), mutex_trylock in 
>> bpf_tramp_ftrace_ops_func will fail, and live patch will fail. However, the 
>> change to BPF trampoline will still succeed. It is common for live patch to
>> retry, so we just need to try live patch again when no one is making changes 
>> to the BPF trampoline in parallel. 
> 
> If the live patch is going to try again, and the task doing the live
> patch is SCHED_FIFO, and the task holding the tr->mutex is SCHED_OTHER
> (or just a lower priority), then there is a chance that the live patch
> task preempted the tr->mutex owner, and let's say the tr->mutex owner
> is pinned to the CPU (by the user or whatever), then because the live
> patch task is in a loop trying to take that mutex, it will never let
> the owner continue.

Yeah, I got this scenario. I just don't think we should run live patch
with high priority. Well, maybe we shouldn't make such assumptions.  

> 
> Yes, this is a real scenario with trylock on mutexes. We hit it all the
> time in RT.
> 
>> 
>>> 
>>>> 
>>>> Since both livepatch and bpf trampoline changes are rare operations, I think 
>>>> the chance of the race condition is low enough. 
> 
> 
> A low race condition in a world that does this a billion times a day,
> ends up being not so rare.
> 
> I like to say, "I live in a world where the unlikely is very much likely!"
> 
> 
>>>> 
>>>> Does this make sense?
>>>> 
>>> 
>>> It's low, and if it is also a privileged operation then there's less to be
>>> concern about.  
>> 
>> Both live patch and BPF trampoline are privileged operations. 
> 
> This makes the issue less of an issue, but if there's an application
> that does this with setuid or something, there's a chance that it can
> be used by an attacker as well.
> 
>> 
>>> As if it is not, then we could have a way to deadlock the
>>> system. I'm more concerned that this will lead to a CVE than it just
>>> happening randomly. In other words, it only takes something that can run at
>>> a real-time priority to connect to a live patch location, and something
>>> that runs at a low priority to take a tr->mutex. If an attacker has both,
>>> then it can pin both to a CPU and then cause the deadlock to the system.
>>> 
>>> One hack to fix this is to add a msleep(1) in the failed case of the
>>> trylock. This will at least give the owner of the lock a millisecond to
>>> release it. This was what the RT patch use to do with spin_trylock() that
>>> was converted to a mutex (and we worked hard to remove all of them).  
>> 
>> The fix is really simple. But I still think we don't need it. We only hit
>> the trylock case for something with IPMODIFY. The non-privileged user 
>> should not be able to do that, right?
> 
> For now, perhaps. But what useful applications are there going to be in
> the future that performs these privileged operations on behalf of a
> non-privileged user?
> 
> In other words, if we can fix it now, we should, and avoid debugging
> this issue 5 years from now where it may take months to figure out.

Fair enough.. I guess we will just add the msleep(1) in the -EAGAIN
path. If this sounds good, I will send v3 with this change and more
comments. 

Thanks,
Song

