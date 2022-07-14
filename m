Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985005743F6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 06:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbiGNEx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 00:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236010AbiGNExE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 00:53:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F87D3DBC9;
        Wed, 13 Jul 2022 21:37:47 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26DICfdO028844;
        Wed, 13 Jul 2022 21:37:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=FTmTOIvyMW0+AdVGK7NYyTPGgImrnf3ZUw9hzsxgXWI=;
 b=ktJ2Az/QkX19GNvBrfbmhGP2dWSLG5r3PUr8uOqm1U2rCX3KMyYYFIsPLmqL9Zo+WByl
 EDIaAJdki7j+fGUggk1j0yNa/r+cSMrGQyVQPTcRQ4SvIWFwhBxh8pZR8WpwHpUImjTE
 DG1GDzN2swuUCq09tEPv0b5QTqOlTIOCKHI= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by m0089730.ppops.net (PPS) with ESMTPS id 3h9h5f0ucv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 21:37:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2xn9q1Bai1tbwL9mKg8FuVhkU+Ke/eINwqcZlC+u1rjiamAX+BG7CnqxXDmdlG7QD+9lRmEfzhXpWZcz0DZSAzxJ+g3CUrWRBg0WRV4WWtW/5C+RG3TN62zSfe+n0DYdPy6Z/J5zqLEJVF6h2t45ouLDM90oWUzaHuDYjZdnFUSaxc+TvqQv0hZ7hw8hAmN33Zpp7ge2wZ30B/GdYDonhjOEwOuGSJZpt28gLjFHKe8jcuEu0nAl1Q0DqBJVHFkgPPA3/GYyYB27yKKDDo4ikQEBvHpt1LqbSXIBcT14pPQPHPkXS1Gn7MdIVqqiaOYv2qyb50Hdw3PkSUzwSkCZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTmTOIvyMW0+AdVGK7NYyTPGgImrnf3ZUw9hzsxgXWI=;
 b=M69MlMgOQMoAOWlYwHdkSk+lN5vG75a6bGih3Y7Fz3I4fmRSZCgYi1DJ4M5TvM0HtK825vmscioif/hiB43EE0GytTR/+2qRlD89NVH3+JxUmTgPagEwmblnHX5ZYx42emfhumc29sZ1J6nqv4rWgMt7tyorLvL13ISVBcCisnbSpnFE+yJewjSjcBX6lL4QQQ16/RAgVb+Z+LkB0We4p3WG+wvbOkqTNgB20LLws3pfUeE9EBTo0xg0p39TYaOO5fWtdFTneNATVCQAVRN6gxOkPW9aucwO1Sfw3AN+TSUgkm6pMTz+dbGq6nMYpJGijenhkIWZ8wNZfEmBE6iyJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CO1PR15MB4970.namprd15.prod.outlook.com (2603:10b6:303:e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 04:37:43 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.012; Thu, 14 Jul 2022
 04:37:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Thread-Topic: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Thread-Index: AQHYdriN/yOd0MaY7kCCLNeAHt/+qa19MFsAgAAO2fGAAAd7gIAAEfYAgAAULoCAABykAA==
Date:   Thu, 14 Jul 2022 04:37:43 +0000
Message-ID: <BDED3B27-B42F-44AD-904E-010752462A67@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-2-song@kernel.org>
 <20220713191846.18b05b43@gandalf.local.home>
 <0029EF24-6508-4011-B365-3E2175F9FEAB@fb.com>
 <20220713203841.76d66245@rorschach.local.home>
 <C2FCCC9B-5F7D-4BBF-8410-67EA79166909@fb.com>
 <20220713225511.70d03fc6@gandalf.local.home>
In-Reply-To: <20220713225511.70d03fc6@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 342222e5-053c-4034-82cd-08da6552978f
x-ms-traffictypediagnostic: CO1PR15MB4970:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fLFSrYuhg1K4TQ8bKdIuW8+uVdTWsGFLSAOp5tK8WXeEvZpAlsXXff865aoQOg4QBeylTg+gyVZf/QWXcVUQ7ARFret/zwsieisAJPGyZj9owkdKxxUGQwJNVuko+0ssqe1q536MbRHN7l9kzDOwPx2ZVHrzlQAMTp8hFv+HvYsM7D45BaSWiwkTsYgzGPlhl3DZvR6Lfqn/YksZYqYLrUnfrclUp8OrCe8RKVFY6nQ8KYX9R/mWpiWLmph3jbxTGd6d7IN+gyu//pBuAoXwi0Xsd6MsVt2eD83rlo9oMwPBgeZl7OioVBYONLku8KP0zlvqwOjntCrEr9c0NI5OWtuhV93TzSteWtdF3InzUaVu3J02C1i/dOdoFzDWHwFd/zw+C3ec9ZVy18/4TQkIVjz2o7IlpmAObG6ALWl+ULRxYbcigu1jc57a9LGGuIz0GY6ZWBqlRdPfFTQVkse0cqmPYubuBOiJiVby+oxPrCVe76rUXE5P9uRrvFXKafoGqJjfnXTyagCinnv5HlsqRtYHNniPfC+8wL66/uNFOoaGEsHp1AQwmOYBSqV9RQ4T+qYaTxVZewa2oHhWrh3QaulI2d5Cz2doYMEkiJzMEs7RmDyc6QKV9rrMT+dsoKYKRHTbGICmLqSqvSiFhufJeTs6mzFo0M514MaocdbCu14cGTozFuMhycqKptRIiZL07HaxJNON+Pa6gs87RZ1uZ9GsJuhxDo1gW79OahbPyJgQ9w+zsnJ3q+0VPaLrRPqon4o3ettebTQ2N4nIGjnP5WB/dacetfXYwvz5JY9jkTfP5raRoTwM1TTu82vCU/LlTe2C75cTU0HpOU45vxW4OQC9b7pwVTIFlJPfKiqfrI4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(122000001)(71200400001)(66556008)(54906003)(316002)(33656002)(76116006)(6916009)(38070700005)(8676002)(66946007)(91956017)(4326008)(38100700002)(86362001)(6512007)(478600001)(64756008)(66476007)(6486002)(66446008)(7416002)(2616005)(53546011)(5660300002)(2906002)(41300700001)(186003)(6506007)(36756003)(83380400001)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jFGq9DG9CcB4R+HUUShYkML11VOh7cKhZ2F7/kGWUH27izgYgCiB7LQJehlC?=
 =?us-ascii?Q?d4sLhFYSo3q6s1Mvlyceaz52nJEYpxAiycYNVcJbu+jSpmmYRQgscKU2ubCZ?=
 =?us-ascii?Q?cK6RY5PzXnrW9vUpUrrwXv0kwO7fjxqDnX/WbAAfGdbiQMls+IF9tcHkKDSm?=
 =?us-ascii?Q?hka5o2NgCEr0iwFVRG4SsuRfH7u7MsjgvqiEI03XcGLTe6fJ66x4CwLcPLIg?=
 =?us-ascii?Q?lSlpxunP49WDb6oBk8U4PkAZVXb1+Uea8RqvjC5VD454IDmglRA9zvtIRdfo?=
 =?us-ascii?Q?pmDpFFUMr9+LtEYtglZJJJqaSmKQpAF5nmR12LpSiagzPzbNo8tvTU/mzeTs?=
 =?us-ascii?Q?Q83tSIhd3ICwyf4q794s29xr7T5mLdOfPZgNp1PUOdexeE6It2o8oTLlrtse?=
 =?us-ascii?Q?9atshsxZduP9lrsjRv5A8fFteF1tzNDwLQXvtNHJl8sCQhX7PYJRdk9vyVli?=
 =?us-ascii?Q?3Ydu/pox/Kp2qb5eZXn+meEer6I0y8y1Y5naYRN6JA7Vlcxp1rq5wyhmiXcC?=
 =?us-ascii?Q?Yt/CfgpGtPHj/3SQiCDb/0rb8f4gsa/TTSVkqhuyIzheZDnbo0AsUiWHuMdu?=
 =?us-ascii?Q?o/sHF/ZBfXsv5BMS7ePidxOoZMC7sTZJNxkPWwJuAAofhauaofUOxzu3O05z?=
 =?us-ascii?Q?o0s3kvbWeeRB3MJvK2BQe5xZqvWCTSP9U53fy/GxCp3zTA2Pr1DY+1p5RG3/?=
 =?us-ascii?Q?j6PbNjsq7ogCXrUJ/ntMiSvFwNYDpMSAtsR8Nkprok5zTDkDXtSBX9aAxkUs?=
 =?us-ascii?Q?gFYMH8NK9dTYShMI7KvPbDrj6TLGGcUWu0N5k2bjo8KdgMjBKrtTPEFwXzls?=
 =?us-ascii?Q?FVlVyIQCPROzXYe/cxFqaduBFwbreg3sichH78jMZt+mLwUEpWhMLdA+PgVH?=
 =?us-ascii?Q?6T5ipKBbBuRgpAlftD+uKBfjlAgudrgHop8Q+VJ4UQCuhpNILvkKqEVTkM6U?=
 =?us-ascii?Q?IuqqqoSNShadZj4NjhAvBTKzMUzQmknUhgzvKubnH9I/JfzMMR7zxbUxwTwY?=
 =?us-ascii?Q?Ov6pjCronSdGzmdxtG1q3Av7zeEsDlk1/jk6DYNn/23/I4wailyliavSPN+2?=
 =?us-ascii?Q?TZG9+aJUpv61es/Dw1cvX4/GpSvSUR4SNzAyA+uQMCLlhSnd9AYhe7x/U9X1?=
 =?us-ascii?Q?YSNIIYuYiT8OUcSqV7YsjyPVSu6P3+SOmMzXJ2SeEQL5HNS2IX/b8T52tbSS?=
 =?us-ascii?Q?4SkjnyKZsjykC1vZGo30dkhiUaZIvkwavk93Xy6j8RqvGu98AXKk2h33dETX?=
 =?us-ascii?Q?M+xcJMk4CfG5fM2TvEAU3hjbOfV4wrkyKaUXl6neCpUSkE8PfsPsL8cj9FUo?=
 =?us-ascii?Q?ilg7MY+PQ13U4IkUM2Snh/opScbgPy5B/qnp8mJL17yE7QMx6Xw92s+fF7kJ?=
 =?us-ascii?Q?xR7V0Uob6Uj9V9xcAmuEMJkaV+YrTFhrygow0pPqgDedI6NlamR1RvmXciBm?=
 =?us-ascii?Q?UY7XWio807YkvVsdgfL9GKM5iwnGHeenMH0hhjcfKG2J4eigfzBFcVagSHTz?=
 =?us-ascii?Q?9PCH0TujFgJOzZP0G2D2dSDNiFmyWc7Q2lbdhC7brJBxme7CECJP7SVXKWot?=
 =?us-ascii?Q?4J5Mz5MEGCkmBV/RV5eilp1hOFhEBk8cxgSlEE2+EA6nEmiwOARL9QjIC0K2?=
 =?us-ascii?Q?byk9l8l8i876c96ZY+hjoU8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DAF9E52BE7CB744B9A4D3BE7ACA05CC5@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342222e5-053c-4034-82cd-08da6552978f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 04:37:43.0678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6HAL4hKTaVTXygfIiOHaHXcOUsNtL0zQB+W1w3c4oU9L9FFrf5bUOxd6Pj6z4PqCvn5/FH8t4nRSWWdw87Qetw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4970
X-Proofpoint-ORIG-GUID: nhMK5XlqoKDS2q0Bigz4QZK8TXBlqJnM
X-Proofpoint-GUID: nhMK5XlqoKDS2q0Bigz4QZK8TXBlqJnM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_02,2022-07-13_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 13, 2022, at 7:55 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Thu, 14 Jul 2022 01:42:59 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>> As I replied to patch 3, here's my thoughts.
>>> 
>>> DIRECT is treated as though it changes the IP. If you register it to a
>>> function that has an IPMODIFY already set to it, it will call the
>>> ops->ops_func() asking if the ops can use SHARED_IPMODIFY (which means
>>> a DIRECT can be shared with IPMODIFY). If it can, then it returns true,
>>> and the SHARED_IPMODIFY is set *by ftrace*. The user of the ftrace APIs
>>> should not have to manage this. It should be managed by the ftrace
>>> infrastructure.  
>> 
>> Hmm... I don't think this gonna work. 
>> 
>> First, two IPMODIFY ftrace ops cannot work together on the same kernel 
>> function. So there won't be a ops with both IPMODIFY and SHARE_IPMODIFY. 
> 
> I'm not saying that.
> 
> I'm saying that ftrace does not have any clue (nor cares) about what a
> DIRECT ops does. It might modify the IP or it might not. It doesn't know.
> 
> But ftrace has control over the callbacks it does control.
> 
> A DIRECT ops knows if it can work with another ops that has IPMODIFY set.
> If the DIRECT ops does not work with IPMODIFY (perhaps it wants to modify
> the IP), then it will tell ftrace that it can't and ftrace will not allow
> it.
> 
> That is, ftrace doesn't care if the DIRECT ops modifies the IP or not. It
> can only ask (through the ops->ops_func()) if the direct trampoline can
> honor the IP that is modified. If it can, then it reports back that it can,
> and then ftrace will set that ops to SHARED_MODIFY, and the direct function
> can switch the ops->func() to one that uses SHARED_MODIFY.
> 
>> 
>> non-direct ops without IPMODIFY can already share with IPMODIFY ops.
> 
> It can? ftrace sets IPMODIFY for all DIRECT callers to prevent that. Except
> for this patch that removes that restriction (which I believe is broken).

I mean "non-direct" ftrace ops, not direct ftrace ops. 

> 
>> Only direct ops need SHARE_IPMODIFY flag, and it means "I can share with 
>> another ops with IPMODIFY". So there will be different flavors of 
>> direct ops:
> 
> I agree that only DIRECT ops can have SHARED_IPMODIFY set. That's what I'm
> saying. But I'm saying it gets set by ftrace.
> 
>> 
>>  1. w/ IPMODIFY, w/o SHARE_IPMODIFY;
>>  2. w/o IPMODIFY, w/o SHARE_IPMODIFY;
>>  3. w/o IPMODIFY, w/ SHARE_IPMODIFY. 
>> 
>> #1 can never work on the same function with another IPMODIFY ops, and 
>> we don't plan to make it work. #2 does not work with another IPMODIFY 
>> ops. And #3 works with another IPMODIFY ops.
> 
> Lets look at this differently. What I'm proposing is that registering a
> direct ops does not need to tell ftrace if it modifies the IP or not.
> That's because ftrace doesn't care. Once ftrace calls the direct trampoline
> it loses all control. With the ftrace ops callbacks, it is the one
> responsible for setting up the modified IP. That's not the case with the
> direct trampolines.
> 
> I'm saying that ftrace doesn't care what the DIRECT ops does. But it will
> not, by default, allow an IPMODIFY to happen when a DIRECT ops is on the
> same function, or vice versa.
> 
> What I'm suggesting is when a IPMODIFY tries to attach to a function that
> also has a DIRECT ops, or a DIRECT tries to attach to a function that
> already has an IPMODIFY ops on it, that ftrace calls the direct
> ops->ops_func() asking if it is safe to use with an IPMODIFY function.
> 
> If the direct ops modifies the IP itself, it will return a "no", and ftrace
> will reject the attachment. If the direct ops can, it returns a "yes" and
> then ftrace will set the SHARED_IPMODIFY flag to that ops and continue.
> 
> The fact that the ops->ops_func was called will let the caller (bpf) know
> that it needs to use the stack to return to the function, or to call it if
> it is also tracing the return.
> 
> If the IPMODIFY ops is removed, then ftrace will call the ops->ops_func()
> telling it it no longer has the IPMODIFY set, and will clear the
> SHARED_IPMODIFY flag, and then the owner of the direct ops can go back to
> doing whatever it did before (the calling the function directly, or
> whatever).
> 
>> 
>> The owner of the direct trampoline uses these flags to tell ftrace 
>> infrastructure the property of this trampoline. 
> 
> I disagree. The owner shouldn't have to care about the flags. Let ftrace
> handle it. This will make things so much more simple for both BPF and
> ftrace.
> 
>> 
>> BPF trampolines with only fentry calls are #3 direct ops. BPF 
>> trampolines with fexit or fmod_ret calls will be #2 trampoline by 
>> default, but it is also possible to generate #3 trampoline for it.
> 
> And ftrace doesn't care about this. But bpf needs to care if the IP is
> being modified or not. Which can be done by the ops->ops_func() that you
> added.
> 
>> 
>> BPF side will try to register #2 trampoline, If ftrace detects another 
>> IPMODIFY ops on the same function, it will let BPF trampoline know 
>> with -EAGAIN from register_ftrace_direct_multi(). Then, BPF side will 
>> regenerate a #3 trampoline and register it again. 
> 
> This is too complex. You are missing the simple way.
> 
>> 
>> I know this somehow changes the policy with direct ops, but it is the
>> only way this can work, AFAICT. 
> 
> I disagree. There's a much better way that this can work.
> 
>> 
>> Does this make sense? Did I miss something?
> 
> 
> Let me start from the beginning.

I got your point now. We replace the flag on direct trampoline with a 
callback check. So yes, this works. 

> 
> 1. Live kernel patching patches function foo.
> 
> 2. lkp has an ops->flags | IPMODIFY set when it registers.
> 
> 3. bpf registers a direct trampoline to function foo.
> 
> 4. bpf has an ops->flags | DIRECT set when it registers
> 
> 5. ftrace sees that the function already has an ops->flag = IPMODIFY on it,
> so it calls bpf ops->ops_func(SHARE_WITH_IPMODIFY)
> 
> 6. bpf can and does the following
> 
>  a. if it's the simple #1 trampoline (just traces the start of a function)
>     it doesn't need to do anything special returns "yes".
> 
>  b. if it's the #2 trampoline, it will change the trampoline to use the
>     stack to find what to call, and returns "yes".
> 
> 7. ftrace gets "yes" and sets the *ipmodify* ops with SHARED_IPMODIFY
>   (there's a reason for setting this flag for the ipmodify ops and not the
>    direct ops).
> 
> 
> 8. LKP is removed from the function foo.
> 
> 9. ftrace sees the lkp IPMODIFY ops has SHARED_IPMODIFY on it, and knows
>   that there's a direct call here too. It removes the IPMODIFY ops, and
>   then calls the direct ops->ops_func(STOP_SHARE_WITH_IPMODIFY) to let the
>   direct code know that it is no longer sharing with an IPMODIFY such that
>   it can change to call the function directly and not use the stack.

I wonder whether we still need this flag. Alternatively, we can always
find direct calls on the function and calls ops_func(STOP_SHARE_WITH_IPMODIFY). 

What do you think about this? 

Thanks,
Song

