Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A8C5A2CF1
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbiHZQ5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiHZQ5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:57:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7C3B7294;
        Fri, 26 Aug 2022 09:57:23 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QFNnd6005325;
        Fri, 26 Aug 2022 09:57:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=pA1PRmZp4ZzqwIlze3LerbsCW3Y2ail6VzvP+zEu7l4=;
 b=E0V+4xuJYCvnL7SW/7ZaHjZq2SJESkh4N3OMeZ0iQqprIAyM7BwZ65wiftuCLjeqEnLn
 t83/VbbjZUWzs0Wi/jIrCj7Z1EHNTLHmMENUTeR0JTRNGE1Y1rANJKlRHDIsE88plqBX
 EH24yEuMvCEg98Bw06oBIpMCL/nFDx2G4CE= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j70s9rnu9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 09:57:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1X0/cJQgk49eZbkZ2u2FNQqVHGwG/ZKn0lSgdVW8CBbS2LA/6djp4R4+xzaINdawnPyoZIcxCE/SwnvfO0/Jk4hBlV8jE5bb7IFly8RvQK1VfGByLWvBcyP3VGGgJfuvGLqqjQD0/oJ8c4WimfFuOBrSNxm892vR8JCEnWHC7F0fRKGOiy8J/zX7ZcZp7srg1tgEy/WdLFfhUyss9IvYVUAvh6NBEufa5UImy+Ir5KQmZs/Vg8a1zAbQ8jKuITS3VltujIczxcH3riue8kaOZFbaBO1L6gbOsyDmMjVs48O0cpnLEUHyK5Ozcq0XuBqDQcB3eaUokYsvnRAgMZc7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pA1PRmZp4ZzqwIlze3LerbsCW3Y2ail6VzvP+zEu7l4=;
 b=ee/t+JX3Mli21p3Rce5lU1c4lanNKXlPRj7Pb09vhbKqg/0PuQc2d9jTJNZ9fe9QYel+TAsqDnrPEvVXP2spfKeNtuEk/C/jmKrd99gg3HCdcSxVmaMx33OlNlxO1+evbNWvewUWtvt9sC3GWPniQABkLj+edFfgsDIb8nQIDbNCBF275NSGEtWfgHNfPL9GZzUR+SXoPr3D4a1ziL4pczNyGE+M54C/2AUM1rhH4UbFtj99Z5aITtk2ZVyAIZ320zejwIwJwbWARwNp6+d+RyruqRLZXZxO7qT7BIp2L5zivV4qYnf+jGOPBUbKaZgV8UR8GvljIysmG4tIRysO3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB3749.namprd15.prod.outlook.com (2603:10b6:5:2b9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 26 Aug
 2022 16:57:20 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da%9]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 16:57:20 +0000
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
Thread-Index: AQHYsML1s5QOEDIN+UabdnIDmWJJf62yExMAgAEh2FOAAA7TgIAAQiRwgAAERYCAAAwHXoAAA3iAgAAEXA2AAReTgIAAEl8AgAGLNoCAAGuIgIAJPUDAgAARoYCAACyYgIAAA2MAgAAI1YCAARGwgIAAIDWA
Date:   Fri, 26 Aug 2022 16:57:19 +0000
Message-ID: <7F90B59E-6AC3-4B82-8467-637945E181FB@fb.com>
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
 <0D14C118-E644-4D7B-84C0-CA7752DC0605@fb.com>
 <CAHC9VhS4ROEY6uBwJPaTKX_bLiDRCyFJ9_+_08gFP0VWF_s-bQ@mail.gmail.com>
 <ABA58A31-E4BE-445A-B98C-F462D2ED7679@fb.com>
 <CAHC9VhRU-b8LC3722tBHAzd6atrgiSAaGm16sRf_M7hywWFOOA@mail.gmail.com>
In-Reply-To: <CAHC9VhRU-b8LC3722tBHAzd6atrgiSAaGm16sRf_M7hywWFOOA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90895645-1304-4775-8f2b-08da87840a04
x-ms-traffictypediagnostic: DM6PR15MB3749:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WAiLpFfHncrBh2bFbq9VKLWqYg40seeDoka/oFkbtwlgrlKJMwUvNvl8Dc8boDRVB1rzC8RH8K6DrVPgXFa0JmQMugwZI6L8XA+8KICVGSSrESvad006S82en0F9t/QSI3PJEohtP5G/wyWkJKZzhmjdVCjZnPi49VdF5CUBBr+uwujBEIvmyWGDyUu4sxZzpgjFv+wnP9lyzQRbtO6vCbsoBTRR58CanYMQ/AL9fb1hy7WqilOV+qSWBO8uUqHbLzyUdi/LfihZIBGlTPXd0bulf9Y7hUy+rUroeSqolKmfxKrd7C12O//5S9FP6HZ1xfKZEAA9Yo5hTh8hRF7b69xxJqVqXWO+6dkLRGNk0AbqnunAwTOr3AQ84LYBFD5gBctFd1nHKA32HKuGX44Ci6mEGUAeO0BV2OOBFit+f1E6Wy036ewW0rR/VWDX5Ly8Dt59w6QsHn4kUtjhUZBkKNfQtPk6fuDjQplzQmvs1FmVtskBxS8qNAi5YkC4ec26mvWv2MtPPxZ71MAkoJPe6h38ryQmvGWdOrLBDZo7d8lIW0DvJHOpeYN4xILJJ+JSbAM/6QrtAlM4AH/Q7gIef1q95pw/cSkPg1i7Ula8eFIBuUM1dhF7B/+GsbhoQ1uwab53jnGPUrUOoP/voDHMOPgklTjk+andi4xTxGgaGikkFwMIWT9oNLrD4MQBEQ0q2/BhSVqjRJ9g3uvNJj7/x5ocdw3k9wtvFlNyjgaqBn/u1yj5tkdi1gm0ndHgoYbv1ZwHYEK8KyGW4NWYZ2ONUFgE3VqnjFacfSMGU9O4uFE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(71200400001)(76116006)(91956017)(41300700001)(54906003)(64756008)(5660300002)(316002)(122000001)(4326008)(6486002)(8676002)(36756003)(478600001)(66476007)(66556008)(66946007)(66446008)(7416002)(6916009)(8936002)(53546011)(2616005)(2906002)(6506007)(33656002)(186003)(83380400001)(15650500001)(6512007)(38070700005)(86362001)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XdvXdyX098kVy1yjRaqSoFy5AzvIdsYMu6mj3iGf6PlskEMCrPNkzlyTimml?=
 =?us-ascii?Q?c/iO9Hh9ZQnafrU0WeRVdAS0AyFOIuPQNvFQRnstPhpRGnAnLivDI76rOgVn?=
 =?us-ascii?Q?0K39eqChBP9Z9cNvpwbR35H4fL+rV+HOElIUuf48DLNEI6diecsBVUcOvh4w?=
 =?us-ascii?Q?nhIjOuNMhXmsLCsx/L2jDk4O9ZQAA3baW1JDIaEdgmrmA0jhW975oPvimlec?=
 =?us-ascii?Q?m7qJB+e3XvamvrcUPyzjMbHhz0NjOjk6OklYyjwqLCi7tEWVWsbzZBQ4id4z?=
 =?us-ascii?Q?/hmPxCq6QygD6S98LFvzLeTKLdjfnfU2ItCEx/iRJDu2YN/NkIe0GoVFZTHl?=
 =?us-ascii?Q?q0O8DPZ6D15Pl8G4E3OpfQIhVti1dQ50OiUimPa7GRZ1LHPdpZ21OkX92pjU?=
 =?us-ascii?Q?nLom3iocEvA1MLYKeyIyojfjm91v2ahPEFBO04gc5HwC+8XNeiQQkv0mVZQT?=
 =?us-ascii?Q?o54gXS++fKGbWn11c0P42iZLyQ91UOXfC66VZCZ2DIYvdaOec4BHs7BqNSqJ?=
 =?us-ascii?Q?ut61hnrUcHtea8nE2XaaQfm4r1g2XOM6u4jOBNq2qtFHQM0Pd6QeH5XHD89p?=
 =?us-ascii?Q?2jJcOpG9PJxKAZU/k9nJYZY8iRzHq1VZJjEThFNg6C5PdYAfOMOs/gXxEHpy?=
 =?us-ascii?Q?Q1sWO9HszPMNXCJ+W+yKTLARLcSZMocp7Uyo9H93LonwTBDSJO7GkJBAjp37?=
 =?us-ascii?Q?HZeEEch5tadQVX9+b8uCmObl3MlwsL38bk0tQz2Qq6J0bcchXIVbOTPAo8ne?=
 =?us-ascii?Q?t151jdtiGz4QgABIAktKwAdVOMDIwhNIJB4DdtgBZaYtiKMEWXv+2l7NUOOv?=
 =?us-ascii?Q?fBUNImd2Xb/FQojysf1ebSSiiw/dGGKXYW+WkRz5Z8D/H9Tv+F4J6fVkLHcj?=
 =?us-ascii?Q?jwDwPagSVUQpiDyQg0cczOqv6hmxoI5o9XZKSiyOzYBCApBzB2N7ZfuEqv8A?=
 =?us-ascii?Q?ZSeAOdjW05eYdHbWDXGpi5xvjnOJk8E5FqpwtiBk9w93z8NQeCul96YsMxz/?=
 =?us-ascii?Q?Gg9Am0BTwpLw9KSDNWV64TmAf7cg9sAIovYg/9+V3ppAuQ3954JRbCI5iDP5?=
 =?us-ascii?Q?J85wWKsM0c9huJ0YRzSfaC7TX0rPJ0SZ/rlv/N+Kojg1f9+r4+TpyBDJyEz1?=
 =?us-ascii?Q?y9ycYEJRkNxnhUdFTz/939v/1wpSTOd+3gRAxm5twm7Ahb5IgUtxjHC8UMGU?=
 =?us-ascii?Q?XPy8lYQ/vLmiYJ30cRGnSIaYwiDpwey7z7K4GWYT+ofY402lu49KbJh9fHIr?=
 =?us-ascii?Q?J2Hr+2NlMZWCK7cGWbpTaLcDHsjHFBwHZpdq881P0bAxmTdBI1OKXG0MwGqT?=
 =?us-ascii?Q?onZxuzwLP3kEX0REfDYlFdpKB9HCMC4nrLVUf/IrXhhmZjblWg5Sb3N2Q1iV?=
 =?us-ascii?Q?tqyaAwHGEgqG4rK6wXb+HCvE9dvHGcCNnKXo+qkcb4QyUlZZkNl4g0ecxgPg?=
 =?us-ascii?Q?g6A+/6+CgmePtcMKm0mHoJ6eHI9nw3LpL4QocOmSMzOOE2Ucr+lY8AooD3I6?=
 =?us-ascii?Q?u60jtXeO8R5j8uqK5G2FksR81ZuEwC1ivjdXzObClfQQ4PSM6G9Zo9WJy7Ex?=
 =?us-ascii?Q?syY46eLRgoH7VXD7ZUcwksM3KNpXJCfHk6r3VdqfAvNjpCPmf54LW5Sj+xMl?=
 =?us-ascii?Q?cD1xqf7YN64xOdIj/Dg1YJs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <443A331CCF194741BAB57C53D0711B48@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90895645-1304-4775-8f2b-08da87840a04
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 16:57:19.9694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SsSYaYOUrr1N2qMO5YOydvN0R2+M2NwU39ICbKeHTHE3S6SIcv1ewelAF/o/s3x44PhS7JdDCj8q/bno1Ve7Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3749
X-Proofpoint-GUID: gAUNh8dV1cldht3aO5CTxXI_N30H0H_i
X-Proofpoint-ORIG-GUID: gAUNh8dV1cldht3aO5CTxXI_N30H0H_i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_08,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 26, 2022, at 8:02 AM, Paul Moore <paul@paul-moore.com> wrote:
> 
> On Thu, Aug 25, 2022 at 6:42 PM Song Liu <songliubraving@fb.com> wrote:
>>> On Aug 25, 2022, at 3:10 PM, Paul Moore <paul@paul-moore.com> wrote:
>>> On Thu, Aug 25, 2022 at 5:58 PM Song Liu <songliubraving@fb.com> wrote:
> 
> ...
> 
>>>> I am new to user_namespace and security work, so please pardon me if
>>>> anything below is very wrong.
>>>> 
>>>> IIUC, user_namespace is a tool that enables trusted userspace code to
>>>> control the behavior of untrusted (or less trusted) userspace code.
>>>> Failing create_user_ns() doesn't make the system more reliable.
>>>> Specifically, we call create_user_ns() via two paths: fork/clone and
>>>> unshare. For both paths, we need the userspace to use user_namespace,
>>>> and to honor failed create_user_ns().
>>>> 
>>>> On the other hand, I would echo that killing the process is not
>>>> practical in some use cases. Specifically, allowing the application to
>>>> run in a less secure environment for a short period of time might be
>>>> much better than killing it and taking down the whole service. Of
>>>> course, there are other cases that security is more important, and
>>>> taking down the whole service is the better choice.
>>>> 
>>>> I guess the ultimate solution is a way to enforce using user_namespace
>>>> in the kernel (if it ever makes sense...).
>>> 
>>> The LSM framework, and the BPF and SELinux LSM implementations in this
>>> patchset, provide a mechanism to do just that: kernel enforced access
>>> controls using flexible security policies which can be tailored by the
>>> distro, solution provider, or end user to meet the specific needs of
>>> their use case.
>> 
>> In this case, I wouldn't call the kernel is enforcing access control.
>> (I might be wrong). There are 3 components here: kernel, LSM, and
>> trusted userspace (whoever calls unshare).
> 
> The LSM layer, and the LSMs themselves are part of the kernel; look at
> the changes in this patchset to see the LSM, BPF LSM, and SELinux
> kernel changes.  Explaining how the different LSMs work is quite a bit
> beyond the scope of this discussion, but there is plenty of
> information available online that should be able to serve as an
> introduction, not to mention the kernel source itself.  However, in
> very broad terms you can think of the individual LSMs as somewhat
> analogous to filesystem drivers, e.g. ext4, and the LSM itself as the
> VFS layer.

Thanks for the explanation. This matches my understanding with LSM. 

> 
>> AFAICT, kernel simply passes
>> the decision made by LSM (BPF or SELinux) to the trusted userspace. It
>> is up to the trusted userspace to honor the return value of unshare().
> 
> With a LSM enabled and enforcing a security policy on user namespace
> creation, which appears to be the case of most concern, the kernel
> would make a decision on the namespace creation based on various
> factors (e.g. for SELinux this would be the calling process' security
> domain and the domain's permission set as determined by the configured
> security policy) and if the operation was rejected an error code would
> be returned to userspace and the operation rejected.  It is the exact
> same thing as what would happen if the calling process is chrooted or
> doesn't have a proper UID/GID mapping.  Don't forget that the
> create_user_ns() function already enforces a security policy and
> returns errors to userspace; this patchset doesn't add anything new in
> that regard, it just allows for a richer and more flexible security
> policy to be built on top of the existing constraints.

I believe I don't understand user namespace enough to agree or disagree
here. I guess I should read more. 

Thanks,
Song

> 
>> If the userspace simply ignores unshare failures, or does not call
>> unshare(CLONE_NEWUSER), kernel and LSM cannot do much about it, right?
> 
> The process is still subject to any security policies that are active
> and being enforced by the kernel.  A malicious or misconfigured
> application can still be constrained by the kernel using both the
> kernel's legacy Discretionary Access Controls (DAC) as well as the
> more comprehensive Mandatory Access Controls (MAC) provided by many of
> the LSMs.
> 
> -- 
> paul-moore.com

