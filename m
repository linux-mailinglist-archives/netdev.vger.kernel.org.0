Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703EB5A1BC8
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244056AbiHYV6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237064AbiHYV6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:58:51 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038FD79A5C;
        Thu, 25 Aug 2022 14:58:49 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27PLuZkL002009;
        Thu, 25 Aug 2022 14:58:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=z5VJjbcMNMPdHpvPIq5bQvKQdi0JxDVIZ7mGlQXOzeo=;
 b=bqzydM+uHr9Eg0CimqR19vDdQL3dlit8gNMll4qk/671EJT4eK0w0jZ6rzPzrm0KP0Yu
 O+NBRouJBpeaUYT3vdUZcoOjjJ0oY996B0uMEA/+jOsbbSIHhy3Fb/FF7hEDOwY2b1FI
 QfT+uOANvlOIY61fFlm1sTgTYM7u9G7S2rc= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by m0001303.ppops.net (PPS) with ESMTPS id 3j66cm51qk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 14:58:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYkmGyraVRJEE0B/w0C3ohKB5yGq48iWKwJUrXEwNKT12tdsqm/jYigiRhyoyNLA+1RIFRwVRcQBDIxWfMMYyO30ehX2oZT21afhEDdNl2uBslXf1WArw2Jrb0QhcAdEZwReByE2ccGORFNfbav0FPFejSBnIdequjf7ZPnsmVjEz+kjLh0usaCpedcO7lHzcBUgDbJZsM5x25rwjpvULe/MXrpCK+1pRPifjInPXP+Z19sRyxkH4XDUNayHJRAu7cIYwOXUw90NxVpQ4FQKchfy0mu2oNZ8nFlWzZ/3InUkpnI51v+HhTLHbKvClnkOPWEuAXzLnifrrGfqlARi4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5VJjbcMNMPdHpvPIq5bQvKQdi0JxDVIZ7mGlQXOzeo=;
 b=Z0UVb4L+w/3cfdxw1o1gERQuxVvhfiLl2xDLhdvXkwPuqaK6whwue/AJ32IlfY6eO0QllhOsYZn6PlfSQZW9HmZXHP6LHll6A7mcJzs8SK3FJEIjRgkg0sCiPaQQl/ajMQKgVaD6K2FHT2IfBtdaO89aT3PHF1R/T330WPjhWJeR3KpBdF8oWQGYiDfoJqVTsw7PUzsvKjZQ1s55oGAhkucZc86PnL7fJxJZEHzXJ6k2GXoEk4QxFGuq60ZwLl/52LoheD5CLbBtirAnbG8Bsu8tJaTPWygNxQoD02ZaoIWOkrEkNpTsJ954tveX2vmS+kHHRtiQLbi8nySRzljNsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN6PR15MB1554.namprd15.prod.outlook.com (2603:10b6:404:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 21:58:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da%9]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 21:58:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Paul Moore <paul@paul-moore.com>
CC:     "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>,
        KP Singh <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "jackmanb@chromium.org" <jackmanb@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "stephen.smalley.work@gmail.com" <stephen.smalley.work@gmail.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        Shuah Khan <shuah@kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        bpf <bpf@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        "cgzones@googlemail.com" <cgzones@googlemail.com>,
        "karl@bigbadwolfsecurity.com" <karl@bigbadwolfsecurity.com>,
        "tixxdz@gmail.com" <tixxdz@gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
Thread-Topic: [PATCH v5 0/4] Introduce security_create_user_ns()
Thread-Index: AQHYsML1s5QOEDIN+UabdnIDmWJJf62yExMAgAEh2FOAAA7TgIAAQiRwgAAERYCAAAwHXoAAA3iAgAAEXA2AAReTgIAAEl8AgAGLNoCAAGuIgIAJPUDAgAARoYCAACyYgA==
Date:   Thu, 25 Aug 2022 21:58:46 +0000
Message-ID: <0D14C118-E644-4D7B-84C0-CA7752DC0605@fb.com>
References: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
 <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com>
 <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
In-Reply-To: <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1eec6756-04e4-4079-8f5f-08da86e4fbe6
x-ms-traffictypediagnostic: BN6PR15MB1554:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Rcvo3UrdX+hHaM2ob6QNQYTvE1b1qSO88QlQfpeYtplM+GG49MRtF4JFgWxiywFAPR4OQZm3isfLKWvAxI1sTOwZszU2ehBRCZ6ZlKk4Xn8lQML1wimMZXKrP8ytHPa92ONH4rHsc6jWdavSyiVt/XxQ4J9WNrwjUlYOuYK2cUu+EK0k3XYCtuOPOVrsoOGOihnH3+PQ542V7/gEZk9R1q0qt6kZ/FnhZYAcR+yc60XVti11qvg0qrSbmzetNsGcL43O+1oLcULuqg1pPSxGPzZIa/TTSxThxKin52H6J5pGqisrQXonzmb6bdzT6DKzMLcrJVueOCfN49zVfzN8dFM3DEL8KmsD0RLeFSH+UOAPZK95ElwEJRvX+zJc8fRXF4KylIau3BqLwPiBT91ebtyrqfjLG2ELaQcaFMBDlI+jTMPxf84xn/xYVdxJQpZYu9QAQzGMqaN9QnwDWzi+yUKveUx9Qn6XYtBJQuM9IxNTrZDLIx9gh1pAl+1cTii/Wbz5lww65wKfFzmS0ZdJSfCCgWHa5OmM7GSXJDi8sMfHBTZ6qAcZ5cLARDKlXoeFznLSRzhUWTOc1FZAuy7FrwZO6S2WsEAJ6mS8VSQJdSCk3grCk2Y+GCK4O/actsk5WWwUcByYF/lvTiqtBdZMsSF/2836wqeQmnIkrHJOqTzRSi2Vb195CDXqR3WYeuniddxg/ogGBLIFYJjqFaH/Z2uk2BtYMCEPvJc1POthlZM+DjB6Ebi1ltLCLrYV0HEAlumQ4PYZGNfdgIr/iLwNXqbNP5vMUId/1Kr7vLPRMh6xn6mvK6s/bSGJaWL4okKAFYmvO5dD4gGwtmbhx9Bag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(966005)(5660300002)(38100700002)(4326008)(38070700005)(86362001)(91956017)(64756008)(66476007)(66946007)(71200400001)(66556008)(66446008)(7416002)(76116006)(8676002)(8936002)(54906003)(6916009)(316002)(186003)(2616005)(36756003)(83380400001)(6486002)(33656002)(6506007)(53546011)(2906002)(41300700001)(478600001)(122000001)(15650500001)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VT5fB39cdm3ABs9EVutXDUUHpIW1rQW+8qoCVJRZOsWMUjPe03CEL/BApv5s?=
 =?us-ascii?Q?A+8SDa8M2l/KtG36T+QZy2xJ6ZzUXgkJuvIQopowJOREc1S7RYSZcNvO2OH+?=
 =?us-ascii?Q?A2fIeCZ9XZ0gpRld/0zPnxn0JQhLYrB31VCJmUi/KvnsEfQcfN61Ihko3mJf?=
 =?us-ascii?Q?mcMzvLKqMc2owGe2PmGSfD0O6xwiJcGZPwUsEgslSwEi7TtkFz3qwQ5qMSnl?=
 =?us-ascii?Q?abIUJGmyLnTJNCKUIF2HjSR9eGdzEtUF9V3Ak54ESnJZMhQLbdskqAxpOhI5?=
 =?us-ascii?Q?h0W9PEU3DaM2ABGSG2dLt3WvdcuHbBwR7YMTVwUHi82ZFyDz47YkiTMMSyoM?=
 =?us-ascii?Q?V5Lm6jut0/04gnSuTEMRso3Tnt8y2UM7tFvpfVmIKPypwyW6lIyjV2SyW2eD?=
 =?us-ascii?Q?xgTDitUOcuKNjSYz2Zm25OdNI7cI74ENCviZzYgPnrr38k5D2EcpTq+RH6hT?=
 =?us-ascii?Q?241R6tmuTLWX3UyPxCi/ZOMowEjWfrgH28unZJmjxsZTxaJkgFzulzBNTAxh?=
 =?us-ascii?Q?zuPlEo4ZCtRJT4hFHjtcIMGEN5jCuzfNF1JopUNqUKG9QjP/IOrRcXCCr2Cm?=
 =?us-ascii?Q?ohl9dyEIqZz/qwHSRdVyIOWs1w2lZnBTz+X7ZkCb+eGmcKhtAUrR7/NaHnt0?=
 =?us-ascii?Q?xzSRXE6Mapv98jk9W9SuIKTT3XSgr2FpBW2HOblM3p2GkLMdEjDFzS2sebbX?=
 =?us-ascii?Q?vapPqZRP8sTIccGen5CsRfxdi1qSYb+u2spJpFjVQcALJANvQCvmpo8grq8f?=
 =?us-ascii?Q?eqqBq57f2M1ib+hCyGvAbiAYkBENxPHQysEpfML6NyY0g4Kkyr/v0pEpvUq+?=
 =?us-ascii?Q?FLTpoMj5ZnQLxaztHcQ56bVT53yrCJvwFqexltdgC2N+Tmfd6qqWacfYqI+P?=
 =?us-ascii?Q?X2yFW+jfwyLktEZ2Bgg2d7Q1iYPxKRHxZZQriC8rsYeAUfIIaRDu7Up+LpC3?=
 =?us-ascii?Q?0PSc2ZdN+10fgY/Xv4PGQYQTtlNNqgszN4vEC8VmqiqAkvXzxqAkt3DRTFOQ?=
 =?us-ascii?Q?4eDDvCSGbf7v2sZc/vaPY3bZP/Z83kalFRAEUVW73Cxed4Kbs1wzF4KV4uax?=
 =?us-ascii?Q?3/kftkMgBY6wLF1A+UQjd6frhoS0btUrGAgesJ4cOYcd7z0qz1y5Rq47+nJg?=
 =?us-ascii?Q?eXJG2UqVX/lVQea9pr35RjnEr3zXdcCNGSHs4epiSVXyR1kQZTY/SLXpleOS?=
 =?us-ascii?Q?r+mm8cHcBmy+x9mQDreMxb0iD7nyYjX6ZLWac5A6/MQNo9reObM3UrZoOZ2E?=
 =?us-ascii?Q?dmHlfoYz9RkXT0uRCvFrL80qVJ1UByYXluYoGFgmPwc5pzl+ebG3jNDs/j+3?=
 =?us-ascii?Q?rK/dOQwFtGhRS5qqMV23xtRKw5F8SN3z4BBBibkf+NsAspIZz0uEjEQuK9Gw?=
 =?us-ascii?Q?HnS0zO5vnRohmVbhKzd2xdrh5NvcO0a+Y7DuNBnUT1U0UHLp3DMDZ+mfKYKc?=
 =?us-ascii?Q?6LLtHrTKlacc0yLH+tp+P9BBxjcu/fOXuwcqsY/8DjQqbUPW8aIVsZonx4Al?=
 =?us-ascii?Q?CAVn/B1CUQuh2P8dCtdf5CU9CDoxakiYqzHSr+pIWc10aBWyrQkq7TW3bryV?=
 =?us-ascii?Q?Dtc32YrOMH6UeVd7m292GydUrG4z95/IuFuSphzNJh2ph1eGTSfD9m0qoA5q?=
 =?us-ascii?Q?0wgf1Z2BmGYYg8HmKkSUpeE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5B83BBCBA9F474681C6216383A4D616@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eec6756-04e4-4079-8f5f-08da86e4fbe6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 21:58:46.2578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +uO2Mmy1nyJ8J+rxMvR5quggl6UEexbTrSyptOUulr9YDS3Zv5dIywNNvm0YRDV/lh38aN99x1hUOtNl5wPtQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1554
X-Proofpoint-ORIG-GUID: jP0CDRr3ShLQ9y8iATENRvA4_xZgIUde
X-Proofpoint-GUID: jP0CDRr3ShLQ9y8iATENRvA4_xZgIUde
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_10,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 25, 2022, at 12:19 PM, Paul Moore <paul@paul-moore.com> wrote:
> 
> On Thu, Aug 25, 2022 at 2:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Paul Moore <paul@paul-moore.com> writes:
>>> On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
>>>> I am hoping we can come up with
>>>> "something better" to address people's needs, make everyone happy, and
>>>> bring forth world peace.  Which would stack just fine with what's here
>>>> for defense in depth.
>>>> 
>>>> You may well not be interested in further work, and that's fine.  I need
>>>> to set aside a few days to think on this.
>>> 
>>> I'm happy to continue the discussion as long as it's constructive; I
>>> think we all are.  My gut feeling is that Frederick's approach falls
>>> closest to the sweet spot of "workable without being overly offensive"
>>> (*cough*), but if you've got an additional approach in mind, or an
>>> alternative approach that solves the same use case problems, I think
>>> we'd all love to hear about it.
>> 
>> I would love to actually hear the problems people are trying to solve so
>> that we can have a sensible conversation about the trade offs.
> 
> Here are several taken from the previous threads, it's surely not a
> complete list, but it should give you a good idea:
> 
> https://lore.kernel.org/linux-security-module/CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com/
> 
>> As best I can tell without more information people want to use
>> the creation of a user namespace as a signal that the code is
>> attempting an exploit.
> 
> Some use cases are like that, there are several other use cases that
> go beyond this; see all of our previous discussions on this
> topic/patchset.  As has been mentioned before, there are use cases
> that require improved observability, access control, or both.
> 
>> As such let me propose instead of returning an error code which will let
>> the exploit continue, have the security hook return a bool.  With true
>> meaning the code can continue and on false it will trigger using SIGSYS
>> to terminate the program like seccomp does.
> 
> Having the kernel forcibly exit the process isn't something that most
> LSMs would likely want.  I suppose we could modify the hook/caller so
> that *if* an LSM wanted to return SIGSYS the system would kill the
> process, but I would want that to be something in addition to
> returning an error code like LSMs normally do (e.g. EACCES).

I am new to user_namespace and security work, so please pardon me if
anything below is very wrong. 

IIUC, user_namespace is a tool that enables trusted userspace code to 
control the behavior of untrusted (or less trusted) userspace code. 
Failing create_user_ns() doesn't make the system more reliable. 
Specifically, we call create_user_ns() via two paths: fork/clone and 
unshare. For both paths, we need the userspace to use user_namespace, 
and to honor failed create_user_ns(). 

On the other hand, I would echo that killing the process is not 
practical in some use cases. Specifically, allowing the application to 
run in a less secure environment for a short period of time might be 
much better than killing it and taking down the whole service. Of 
course, there are other cases that security is more important, and 
taking down the whole service is the better choice. 

I guess the ultimate solution is a way to enforce using user_namespace
in the kernel (if it ever makes sense...). But I don't know how that
gonna work. Before we have such solution, maybe we only need an 
void hook for observability (or just a tracepoint, coming from BPF
background). 

Thanks,
Song

