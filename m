Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C675767B6
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiGOTtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiGOTtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:49:07 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8D41EEF6;
        Fri, 15 Jul 2022 12:49:04 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FGGurj016483;
        Fri, 15 Jul 2022 12:49:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=a3bxzL9hXJL79M95AgwHOIMUXiIdFYlAuL8r4/6SMW8=;
 b=h1Wac6h/0wLQXEXakVxCh1nBq2VBXw/OmDkWaTMT74L88P/UCc1ytlCbMvXoBaHKg4Su
 odj7cikJBUTAb0EXy366xtkRpv/YSuzlgm37nzhMlmBvyAIqELVcyHcc/tsvTwokTDzj
 hkG9BlL9MUmeS64wlU34YPh4rzhvQe2naXM= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hb8md2mes-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 12:49:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiD9loQ23A1P7MDVbO9vwm3NldtgxKGV8SGKEF1k8T7mDijAxstI4O9ID0sYGnGEVA60e+VZTSBxukhyZqQFrU7nr2pjiiaq027bfv2DuKi8KVsfFh7yl46/fbi1ETIr+y0MP4is5x1AuxrvwECHbbB8QRN2/XmOreq76pmAh8TCQAkOpt3JomlggycBsKOLavCkSDkstSKqPuCR/kM+NbtS/BllfjlsYUBs/3RVdwrGQA2FW/pzX48LYAixI7kOMyZx76J0B/liQ+AFkgtP++K2KiK6tK5z+zrvow4BwMZNLn7LZZK5Qyear2AGwDvluEIgBTze3NdnUCvI1xYRmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3bxzL9hXJL79M95AgwHOIMUXiIdFYlAuL8r4/6SMW8=;
 b=cKyP+THOnYWNJA4lt8/U5oweu6J2vBzbMtsNK2O9zhX9uqIfuw6c9P3Yod18lhHI4WgsXFMbrNubPe/lZAIMoN+qbVqGtnSkLgrJI1uq2iK6ltwfeBuMtprpRKaVopkfoC6NrNYyDug7oZSibIfd3l2GFJFW5rOfgmm43LXRqbeP7Hg1sgxZO3+51xZEzVbjFQGD3kXr4CJqq0AHS+roPveMd5kDge7QfLyQd6SKX3xs1cjEx69k4r19p37pZVBUJVPTrZZ9w7SkMOH277rRBaWVAAd9tviATr3TcWs6ZAKOJLPcXuCsaSvjh+zPZ/vJUOte5+4c/dLXTbRjV5HULQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BY3PR15MB4835.namprd15.prod.outlook.com (2603:10b6:a03:3b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 15 Jul
 2022 19:49:01 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 19:49:00 +0000
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
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrjyXTiiEgEgK0K1BTZfHuJgSq19RUuAgAGMyICAAAmfgIAAFU+AgAALzACAAADvgIAA+XEAgAAY+YCAAApDAA==
Date:   Fri, 15 Jul 2022 19:49:00 +0000
Message-ID: <0EB34157-8BCA-47FC-B78F-AA8FE45A1707@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-4-song@kernel.org>
 <20220713203343.4997eb71@rorschach.local.home>
 <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
 <20220714204817.2889e280@rorschach.local.home>
 <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
 <20220714224646.62d49e36@rorschach.local.home>
 <170BE89A-101C-4B25-A664-5E47A902DB83@fb.com>
 <0CE9BF90-B8CE-40F6-A431-459936157B78@fb.com>
 <20220715151217.141dc98f@gandalf.local.home>
In-Reply-To: <20220715151217.141dc98f@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f71ee93c-632f-4f7e-f8b9-08da669b107d
x-ms-traffictypediagnostic: BY3PR15MB4835:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M5CN9iZnu1jnJDFFtDgzRA+jXy1eitMiQWKIOjr+JckD7kNUNH3M+gjWIwlAIipR9H3zf9THcZxQD0DBzB3SxLtARWJI+Df5ld63q+BIO7Kcghf6bBrECVkJQsVLQq+KZ7yRAZqtldYYq2bnjRvpyCWSezNMDkj+UhG25PS6g6mGWGn8sMD4PDpeqO5kINZJ9AROxkYYwfeeeGiGv2plakk2GGr2UEZUJuj2zcUOJl/WTgNYK+Gs2ra1X1jyJDOF4TmbnBtCk8JjZroBjHWfBwW8z6Ocaab7OkAHF12RKRK0tItu2d8+nQpG65QVjqEYDF3SqOjU81VIYd4hN/1RSaE5Eby5vyZPqNzDC3vyh4f0Q/HxGXQbA1m6WiN/p6yqqiodrfHD2d5PxgJ8z5iVTmSXphDnN+oT+hTH0ozi0Ayc3nCqnxWaY0d/KRI1t/XTkRP0M6yOiGBFjXimBNNmv420AcOCEIHDaMaUAZUGVzLqIOu2ff+0UetD4AyvrA9B4b3b9csSMc5TQGuVh00wmnzsXS6hFPiaxMkZOtzK6UeCUr8pfLCueWbQaKnq2Iom8TOisW6+S80hhlcb52DxW/L9pj/WZwNw/BVRsI5tC8dlAZRwfJS1yUGYkPzfZ9GAk6n9QRJg4nf1wJhHTfrSPPnHcbjw2Gx86X3lgwuHSAh7ysjqnK1HIzNPySJL2wAwOTmh5diSL16Od5KOyJyWp6PxY0OPEhaXX6ncCMcJSwNuYbfuf5VjLZywv0uwdLhMUkpEbeTHbmsI7IWblsxCvpPXoXXcPxNoIqEjM1ChW8g4bDmSd14PUfc+JgQEXpuOSkjMCJBEgKU01NI7wM5eiDbnhAr+MyNA3y/INLtlNwI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(478600001)(38100700002)(6512007)(41300700001)(2616005)(53546011)(122000001)(2906002)(33656002)(83380400001)(7416002)(6506007)(36756003)(91956017)(66946007)(66446008)(76116006)(66556008)(8936002)(66476007)(5660300002)(71200400001)(54906003)(6916009)(38070700005)(4326008)(86362001)(186003)(8676002)(316002)(6486002)(64756008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wcKEGZ8GG/QATwH/FX5jvhG5PFEOvTT5AGHJDda1862Qx4jMnZqw0bg6dhUV?=
 =?us-ascii?Q?RrhHrAI7CXRs6mpfG4oKv7SUqcxiL4fV8ZkSQFywJY09mfpaL3Z3e+D5o15j?=
 =?us-ascii?Q?NMIC5IgeoisWBmdxJsCml2ivu9nuomdx4MPEeLCA7W6PtC6uYVXruWRkXk3/?=
 =?us-ascii?Q?1fzixYL+/+6dP9TeXS9is9Hw4RkVcomMSOo69IFonoVNIgvw5XVphOvJis6I?=
 =?us-ascii?Q?Q+0sfEc+NozrUrOz4MXaJmimPrpMA2Mudo6C8e6ayFuXOgLhfYUdkTS2vTTo?=
 =?us-ascii?Q?49tDQSTgEvR9ah4adgCkZhvDOPRsv2gm1fGQH8kuWNMV1qLFAM/ZyI6gVoBK?=
 =?us-ascii?Q?OkhgkfhrKzQ+KAdbjgB122TMj/gj5TRD6OI5nSIDQ2db0mE02M8MXhWM372J?=
 =?us-ascii?Q?ZR31usKqlpkq07km2bKQVYlays949usr2WIFOfl2QMKcOKe1VCZO3ZlC+sj4?=
 =?us-ascii?Q?UBkgMG0BGm7PUIFO1I0bPrc7N1Y5SWxdX+an6Eovhayenrtx13cjCvfccO21?=
 =?us-ascii?Q?Evg4oX8r5PKIEgUBltI2YxJ8x4OtnLs7ITkb9hK4BY9qEIvA2FcZrEsetl6L?=
 =?us-ascii?Q?xkB0f+HYzQMtRhfdNP1dK4wE5dbbM+Dntgp8e9rPMNcFSpfI66IiaBfEP8Zu?=
 =?us-ascii?Q?4pGBkfSoL1W/b0ruP15kdcSzacbyokUEhGom3PrCVwkF061tBJFKB6zmz6RR?=
 =?us-ascii?Q?nvvcyyQ74vSpnwkG1Ye4gUQEjjFZUuFT2KZG6VQkUC/cWACn6fIwSABFqlkh?=
 =?us-ascii?Q?Ps6lNUjjCSdXbFwf57lOZ6ZTFw7KkDYRipxP6rsp/9yb328oRuaHlxkoU9GE?=
 =?us-ascii?Q?b9WyekuUE3zI/lfWdwGmhBuA55MJ29Bykmeez5drJRebkS/f4lTk0Vwhrbln?=
 =?us-ascii?Q?hdgHZVyyz1BeY1iwBJqV2Tevq3G4jUqYNQXmH/cK9WOlfNG5zWdVzZcoWuPN?=
 =?us-ascii?Q?tVJu6kKcFKWDE7gXAOddLuY9rZyFo1x81Rc9qDFb6mItqIPqBwVrfkFyFjw2?=
 =?us-ascii?Q?1X/E25UGuR8WBvGk33fYb6jYCF1Vn5fL7B7k0Iz75GOYyZmxLpUI/P6OaJwl?=
 =?us-ascii?Q?3Nd8Iq6rYqjqwkFVRkJLYOeWcrfjnt4Rtxiues2/+mZ1aU5t/2iHgLNsJdU0?=
 =?us-ascii?Q?slcygmc+1mzk4PFBDBa+VPMup0hyY5Loh7yZUX973HJOwEoU6ipzyRj2fT8F?=
 =?us-ascii?Q?+5V2+mD/kXqkhbGytotyDXagrZpuO+0UzoLb9b5jaxVz39gTi52L4ZWsBuqn?=
 =?us-ascii?Q?zuqcHmf7ZTRb2TH3ox1FtSuMcIkIqHKibUkNX0m9sZi+RWvasG6sgD3acPVt?=
 =?us-ascii?Q?C3kVOHzz1Wh/UlIPOpid9rxVWu0uRyUaTBbnlKRPDqlfw31jQL6+OhU+tUgf?=
 =?us-ascii?Q?WjdPXolc3lB2vyd3wB3Iq1uGSrtth1ef/HCmnAcZeaelTekJmN9VPJYOKH6p?=
 =?us-ascii?Q?pvJDGby1rndQmEEjhn+yWOZ9lPAA6t0FoJX4P2EP252l4VhvNN63uTPFgSSE?=
 =?us-ascii?Q?UcVJr3MQtDr9AovqW5A5lOsBULlbYQC4VG3NfOjC7mJfXfMjna7AZLa//aHD?=
 =?us-ascii?Q?4yEjteCA7amaqITYQV0YfDP77/zlmjBlzuUPD7+0IGVANZhepg/kUTM1OVj9?=
 =?us-ascii?Q?PykQUU4xZfb3aj7RnBmj1Is=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <359A9C26BFEA054799E522BF7D7B427B@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f71ee93c-632f-4f7e-f8b9-08da669b107d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 19:49:00.8845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vnvz37SH1LzBdBK57+aYtwknYSdFj+JIVJYCenYkW65pCkW74M9jt+BZwmzMqPRZHYVxY0u8w09URXh9e1SDKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4835
X-Proofpoint-ORIG-GUID: 9guEJhtX4X9hlH3oFfh8wCanAI8dGN4b
X-Proofpoint-GUID: 9guEJhtX4X9hlH3oFfh8wCanAI8dGN4b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_10,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2022, at 12:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Fri, 15 Jul 2022 17:42:55 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
> 
>> A quick update and ask for feedback/clarification.
>> 
>> Based on my understanding, you recommended calling ops_func() from 
>> __ftrace_hash_update_ipmodify() and in ops_func() the direct trampoline
>> may make changes to the trampoline. Did I get this right?
>> 
>> 
>> I am going towards this direction, but hit some issue. Specifically, in 
>> __ftrace_hash_update_ipmodify(), ftrace_lock is already locked, so the 
>> direct trampoline cannot easily make changes with 
>> modify_ftrace_direct_multi(), which locks both direct_mutex and 
>> ftrace_mutex. 
>> 
>> One solution would be have no-lock version of all the functions called
>> by modify_ftrace_direct_multi(), but that's a lot of functions and the
>> code will be pretty ugly. The alternative would be the logic in v2: 
>> __ftrace_hash_update_ipmodify() returns -EAGAIN, and we make changes to 
>> the direct trampoline in other places: 
>> 
>> 1) if DIRECT ops attached first, the trampoline is updated in 
>>   prepare_direct_functions_for_ipmodify(), see 3/5 of v2;
>> 
>> 2) if IPMODIFY ops attached first, the trampoline is updated in
>>   bpf_trampoline_update(), see "goto again" path in 5/5 of v2. 
>> 
>> Overall, I think this way is still cleaner. What do you think about this?
> 
> What about if we release the lock when doing the callback?

We can probably unlock ftrace_lock here. But we may break locking order 
with direct mutex (see below).

> 
> Then we just need to make sure things are the same after reacquiring the
> lock, and if they are different, we release the lock again and do the
> callback with the new update. Wash, rinse, repeat, until the state is the
> same before and after the callback with locks acquired?

Personally, I would like to avoid wash-rinse-repeat here.

> 
> This is a common way to handle callbacks that need to do something that
> takes the lock held before doing a callback.
> 
> The reason I say this, is because the more we can keep the accounting
> inside of ftrace the better.
> 
> Wouldn't this need to be done anyway if BPF was first and live kernel
> patching needed the update? An -EAGAIN would not suffice.

prepare_direct_functions_for_ipmodify handles BPF-first-livepatch-later
case. The benefit of prepare_direct_functions_for_ipmodify() is that it 
holds direct_mutex before ftrace_lock, and keeps holding it if necessary. 
This is enough to make sure we don't need the wash-rinse-repeat. 

OTOH, if we wait until __ftrace_hash_update_ipmodify(), we already hold
ftrace_lock, but not direct_mutex. To make changes to bpf trampoline, we
have to unlock ftrace_lock and lock direct_mutex to avoid deadlock. 
However, this means we will need the wash-rinse-repeat. 


For livepatch-first-BPF-later case, we can probably handle this in 
__ftrace_hash_update_ipmodify(), since we hold both direct_mutex and 
ftrace_lock. We can unlock ftrace_lock and update the BPF trampoline. 
It is safe against changes to direct ops, because we are still holding 
direct_mutex. But, is this safe against another IPMODIFY ops? I am not 
sure yet... Also, this is pretty weird because, we are updating a 
direct trampoline before we finish registering it for the first time. 
IOW, we are calling modify_ftrace_direct_multi_nolock for the same 
trampoline before register_ftrace_direct_multi() returns.

The approach in v2 propagates the -EAGAIN to BPF side, so these are two
independent calls of register_ftrace_direct_multi(). This does require
some protocol between ftrace core and its user, but I still think this 
is a cleaner approach. 

Does this make sense?

Thanks,
Song

