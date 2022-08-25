Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01985A1C9A
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243659AbiHYWmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiHYWmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:42:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A438FC4825;
        Thu, 25 Aug 2022 15:42:34 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PM4GPZ009571;
        Thu, 25 Aug 2022 15:42:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=oqlT40XjR7dX7Ic5vyHeWbGfBti+GJw4OXYYil+wWfk=;
 b=bzc5MQHtMXfD7/wyMQI/1p/f+ugL1Ip5qC0fpsRcZKJ4pcPdpcFONOVt7WexmsQNPTH2
 eemqjuI/t8iIppsDiMES+QSYgTFKZlaJXt4dRlnJbWnhM+gi/nn4f4fP54s63kDfBrjr
 Mdqrg1a0b3OOFpCy6ihi02Y2Bi2D3IqVhVA= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j5nfckf3s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 15:42:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAjrZr7nwOlstb45KAbP6gZlCqdJmg/gz5vequt03LiTGQpSPXNgpAf82JOwP9ojTg+2GH/oobtggsqeGlVbbzoyrW3WhLEh6DKcQpIIRzJK5arnsqg9/hy5asodwa0E3BOH5D7QwnQoLqls0SoFrvJylB6uxb/ptBF9jZO2Vs6oDW1tmzHUGsTPX4H0cZ/63yrDcYSLtqF4r85nJ7hB1GFAvOPkCcKJuAA0yeSw6IGcSTVkHWm/F7/aRtRWftzCUaOfKdy4viLQ6SyfzOwdqOUidudaNr44yKYPnv+ytnB6ruruXA0a1gphrYW3I386MddwRDb7sceRYFbZFXbMdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqlT40XjR7dX7Ic5vyHeWbGfBti+GJw4OXYYil+wWfk=;
 b=muN6rnpO+tgLLFW547nK3J3UG8aZqjeOEp/CY2KmefJtnLHS2sFCA6qsgNi2wEFt30XY8CA4QF3HXGLbEbiXAAQrEvFoilqAJou9OjHmFmMlHKyq4kmNNQBSAgmYTX1xpAaZRfM1VP3Ecv4kbg6wWjIVcjB6LD6AQWNkrWS8hnzvFxBghfhXgW2HOhhbuvGu/JFtNzVZv2tNfUlv/gGG9b8OPPHcwD7J7CyArq12psvox03PJba+HE7DJIGwzu+DmPHIOFXEedUc5QBg1YVUScy22z5Ll3cK3laeFHs4oQgFBJmUmDGE0DRyMAIZ3yjomAxGrAzCk/Q+krXqeHYa/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN6PR15MB1139.namprd15.prod.outlook.com (2603:10b6:404:eb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 22:42:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da%9]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 22:42:30 +0000
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
Thread-Index: AQHYsML1s5QOEDIN+UabdnIDmWJJf62yExMAgAEh2FOAAA7TgIAAQiRwgAAERYCAAAwHXoAAA3iAgAAEXA2AAReTgIAAEl8AgAGLNoCAAGuIgIAJPUDAgAARoYCAACyYgIAAA2MAgAAI1YA=
Date:   Thu, 25 Aug 2022 22:42:30 +0000
Message-ID: <ABA58A31-E4BE-445A-B98C-F462D2ED7679@fb.com>
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
In-Reply-To: <CAHC9VhS4ROEY6uBwJPaTKX_bLiDRCyFJ9_+_08gFP0VWF_s-bQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 176b274c-e8d4-47aa-2ca0-08da86eb182f
x-ms-traffictypediagnostic: BN6PR15MB1139:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L4BoAUgtGE2fRfjKERItPE5pWEa6q35PP7Bg7hYUNj94XBi+/puLzb9F3ZgsA5h4vBHLxXm/WjnWYxgLn82vLvQoHNyJktyQOvzIh9uLbYRs9FyJ7usFcsasOHos8EM7bx835Si/Cy24suyHTob6wWFCNipqDkbMWymKGFklcy5KdiuRdhsBEWOvlO1YxT3t9pemKI8w46qtgNmKRavaDRLJhBYVV5A+tL0ZL+7vOuBuD6Y+l4V2pwKLIRs7v+zOSGVpCVAOWVaXwU9Z+z+V+YuiAcBpg6jwv/XM6Q4EwjjejoaYEWBOUEO97ZVQ+zNOf5Kohj1pbQOUUP7FaajTBlaBsS637gVNEcs4OR2t44G/kO1yXFTyNsjBxgHb1IcQKfX3t4/lamg7RMWvwGgrcuraIVyFbDg5eI9frVNzfDa6ryJ6L5nHkr0V/Er4jqzxjhxpwn7Z1nz3Lw4xb5PURUwrVjwU/RZcnmr/SOFQASRr74cyjA/sJKWTUOuPkxePHnwZUNTbX4qMNstVMrGd/j1jlRx8dxe8aXZq0EbSRp1iQHHWiDnBeLM9mxRkd7RxL1dy7I2sSOuP+cepTJTTmfZj9xGJr6ymq/NO3piBsoQiXpeMU1aFS6WA1LZVdt0iQ/zEbES3Rs4siKY+iP6MT0bmHbY81cPIFy7REnteXHRiGPUAacqptQX5fP//SLzI3cmKIIy4hSY7v3KcJ7/5hyjU2sKIcAFRn6YByX2RWz0jV3UtfHlC6/VG64SfEA+O/9WqGwnvyEsqzZg6M7EtjB131miuft5kaLwzoKnyc029pGgvoJnloGVHKNKswJJ6ZiFO9oNj09fcOI76Qao0hw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(186003)(86362001)(33656002)(38070700005)(2906002)(53546011)(2616005)(6512007)(122000001)(38100700002)(83380400001)(66946007)(7416002)(5660300002)(6916009)(8936002)(41300700001)(316002)(71200400001)(478600001)(36756003)(66556008)(15650500001)(54906003)(6506007)(966005)(6486002)(64756008)(66446008)(76116006)(8676002)(66476007)(4326008)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MYG/RwG6ZOBd5FOT6MuKapxs0aI/tP8AxLtUAa8dLcnVZaAX0tgs/hcdBqDN?=
 =?us-ascii?Q?+ANjVPn6c7ssUgGhi/0LsJbLM+oPI9gmSM5jcLPlBwNYfB3PvEbNkg5HXJLp?=
 =?us-ascii?Q?icLgRVz9c/wNQbHg8k4rnjAXEQ7f+/RELRsp/l2IomloR9FC8Vo2sqDXBdWb?=
 =?us-ascii?Q?ZfiP757PSSbPjaIeQzPMZjuCTcVd7RiJUsu2rlQwbbuFxEH4auHpysGiAkaC?=
 =?us-ascii?Q?Clg4PNRwXJ4gaIzoaiOkbZHIoVF9kuo7N57wxuL+ajTbFFW+B8KKDmhOIZPQ?=
 =?us-ascii?Q?9MFJdF/mZazsWwxvHATTXk54VqlX7ort852JYW584a5IB13UbiIKztqTn+x7?=
 =?us-ascii?Q?AtFYO3KS9ybmk6iDbBbAhS4X49Oje3edbypk23ncq0C+fWFoEDrxl+8EKNPo?=
 =?us-ascii?Q?//RkrME5aMO2kq6LpQMK254rvz/3FniYZwEj8BhAi5V0tSxjwvCywj9XsTkr?=
 =?us-ascii?Q?GRTevBXpLlqpFWV1+Dr1oLW1OLd1/lQOsx7BJ7/DXNSsEafEHUpokRSl/wcP?=
 =?us-ascii?Q?PI2IZZZku7xgixOFAC0MY9qcFSq97D2Smqr8l94snNLh4Tp5Ie6jbQIU/Kxq?=
 =?us-ascii?Q?SaBuf0lRApS0hSitQkXZ9W+MCFbQU6jM3HVZqaFpGXscbyTyy8ioYU3g/QO8?=
 =?us-ascii?Q?P/WJs9rYZ5UoLC1EhfxRyecHf9XC3AcDq8hit7HyjtYx5oAMWVDC3ETcCmhN?=
 =?us-ascii?Q?tVk7wzzN5feqD5f3GtanRzkt9U/CoA4+DBtkcJGmRUPw3CK78utxo+q8tBIZ?=
 =?us-ascii?Q?YsYGZ/TPOnMbzJhhBwGFTEH8b0+6wkMq6YzxQBL0rvnpty6XZp9p0SSk6SCm?=
 =?us-ascii?Q?jKMQB3Z5jX1m0IcSggZTc+4FsiU4i1DekXxGbXiWlRDdPIO2l0Qb8jwX5ck/?=
 =?us-ascii?Q?R0t6wpP7i084CeV0/V0VHd6m9LJ82q6S/Po8YNErxePzZIJRwKfYebU3Jzmc?=
 =?us-ascii?Q?KqTdhYkQKs1isi+WqpYKHbFYI+vRFL3pKRqS/h3X2PY15/4OocaGMGEpy+Oa?=
 =?us-ascii?Q?gQie33TqkjhJXIdKZbtFAprvFlvqhqfIrW3Tk8ILc9CsqxNIUcH9lr22+Qdz?=
 =?us-ascii?Q?E78/0FCdQ7w9G3quG9QmuZCzbqMw2GM9/JNhWxerxs5PuY5vKAoJWgkUZEU8?=
 =?us-ascii?Q?3LPYdd1uxT0jKFQ9siQMdT2gEEpR44/IuG6LW/fYgd8r1fLQ04bkOv86qCNX?=
 =?us-ascii?Q?M2wsGRpINF7YE7UKf2o9eZWmpAbBjFA3Op68VBYT7AL6/MsL25b7bsWnJ8lF?=
 =?us-ascii?Q?Kx2Xw3RIQY4CILytoRE5GftuYeoUdUvLhsnnIfjhz7l2F+R2Eppe44uvxW+v?=
 =?us-ascii?Q?7PbDLgOrrpmXrd0SaNibiKQiY1HfIfGwnrY9l3rqq8lChuddMBvPbe9Khew2?=
 =?us-ascii?Q?4NSq3eDzeExM7GyWLBvoApj9HX7OiPIJSqbEoKwnxxJQiyzJ7w/mx/2ItvzX?=
 =?us-ascii?Q?gM0ZeV+uQKyHVu5lRJmjgPx+x8BHFInYur93dzhrRwsXifgYV1+CVK8DKfRT?=
 =?us-ascii?Q?fpVhk8IPe63HWc1v5n4DD5lT4ogXOxDFONA58hELPa+nau2U/7bYq+VRiEV7?=
 =?us-ascii?Q?CXKfeEr7DpOg7bvX6JXzKkCizr/YwSAmXDWF9ZF+IW/0A3+DTWaqaree9NUP?=
 =?us-ascii?Q?y56SxwK0/QgoPtxE9cPA9Yo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <119DEE46B937A441AEC8BD1948617A98@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 176b274c-e8d4-47aa-2ca0-08da86eb182f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 22:42:30.6902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j6RD9dPvfkKrHmCgWT5zaEU+PlDf2a+MG1HcE6vjJ7gP5BgVpt+x57J2u2hV3rJKHb2/LlODkfwXI7KTHH4zrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1139
X-Proofpoint-GUID: zF7MC9V6OGkkiVuAsFonah_Scsk7ww7p
X-Proofpoint-ORIG-GUID: zF7MC9V6OGkkiVuAsFonah_Scsk7ww7p
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



> On Aug 25, 2022, at 3:10 PM, Paul Moore <paul@paul-moore.com> wrote:
> 
> On Thu, Aug 25, 2022 at 5:58 PM Song Liu <songliubraving@fb.com> wrote:
>>> On Aug 25, 2022, at 12:19 PM, Paul Moore <paul@paul-moore.com> wrote:
>>> 
>>> On Thu, Aug 25, 2022 at 2:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>> Paul Moore <paul@paul-moore.com> writes:
>>>>> On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
>>>>>> I am hoping we can come up with
>>>>>> "something better" to address people's needs, make everyone happy, and
>>>>>> bring forth world peace.  Which would stack just fine with what's here
>>>>>> for defense in depth.
>>>>>> 
>>>>>> You may well not be interested in further work, and that's fine.  I need
>>>>>> to set aside a few days to think on this.
>>>>> 
>>>>> I'm happy to continue the discussion as long as it's constructive; I
>>>>> think we all are.  My gut feeling is that Frederick's approach falls
>>>>> closest to the sweet spot of "workable without being overly offensive"
>>>>> (*cough*), but if you've got an additional approach in mind, or an
>>>>> alternative approach that solves the same use case problems, I think
>>>>> we'd all love to hear about it.
>>>> 
>>>> I would love to actually hear the problems people are trying to solve so
>>>> that we can have a sensible conversation about the trade offs.
>>> 
>>> Here are several taken from the previous threads, it's surely not a
>>> complete list, but it should give you a good idea:
>>> 
>>> https://lore.kernel.org/linux-security-module/CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com/
>>> 
>>>> As best I can tell without more information people want to use
>>>> the creation of a user namespace as a signal that the code is
>>>> attempting an exploit.
>>> 
>>> Some use cases are like that, there are several other use cases that
>>> go beyond this; see all of our previous discussions on this
>>> topic/patchset.  As has been mentioned before, there are use cases
>>> that require improved observability, access control, or both.
>>> 
>>>> As such let me propose instead of returning an error code which will let
>>>> the exploit continue, have the security hook return a bool.  With true
>>>> meaning the code can continue and on false it will trigger using SIGSYS
>>>> to terminate the program like seccomp does.
>>> 
>>> Having the kernel forcibly exit the process isn't something that most
>>> LSMs would likely want.  I suppose we could modify the hook/caller so
>>> that *if* an LSM wanted to return SIGSYS the system would kill the
>>> process, but I would want that to be something in addition to
>>> returning an error code like LSMs normally do (e.g. EACCES).
>> 
>> I am new to user_namespace and security work, so please pardon me if
>> anything below is very wrong.
>> 
>> IIUC, user_namespace is a tool that enables trusted userspace code to
>> control the behavior of untrusted (or less trusted) userspace code.
>> Failing create_user_ns() doesn't make the system more reliable.
>> Specifically, we call create_user_ns() via two paths: fork/clone and
>> unshare. For both paths, we need the userspace to use user_namespace,
>> and to honor failed create_user_ns().
>> 
>> On the other hand, I would echo that killing the process is not
>> practical in some use cases. Specifically, allowing the application to
>> run in a less secure environment for a short period of time might be
>> much better than killing it and taking down the whole service. Of
>> course, there are other cases that security is more important, and
>> taking down the whole service is the better choice.
>> 
>> I guess the ultimate solution is a way to enforce using user_namespace
>> in the kernel (if it ever makes sense...).
> 
> The LSM framework, and the BPF and SELinux LSM implementations in this
> patchset, provide a mechanism to do just that: kernel enforced access
> controls using flexible security policies which can be tailored by the
> distro, solution provider, or end user to meet the specific needs of
> their use case.

In this case, I wouldn't call the kernel is enforcing access control. 
(I might be wrong). There are 3 components here: kernel, LSM, and 
trusted userspace (whoever calls unshare). AFAICT, kernel simply passes
the decision made by LSM (BPF or SELinux) to the trusted userspace. It 
is up to the trusted userspace to honor the return value of unshare(). 
If the userspace simply ignores unshare failures, or does not call
unshare(CLONE_NEWUSER), kernel and LSM cannot do much about it, right?

This might still be useful in some cases. (I am far from an expert on
these). I just feel this is not the typical solution to enforce 
something.

Thanks,
Song

PS: If I said something very stupid, I would not feel offended if someone
pointed it out loud. :)
