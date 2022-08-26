Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD15A5A3216
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 00:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345005AbiHZWek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 18:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiHZWej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 18:34:39 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E58BC6B72;
        Fri, 26 Aug 2022 15:34:37 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QJpS70012207;
        Fri, 26 Aug 2022 15:34:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=zEH0C/0RAfWJ2+mFPkXXs+X7a/jwUZoCOELN6NgXac0=;
 b=Lhiqnq55syjMkTn26zIea6qjCUHRQjbj/2c2cdmz8ONLyNWtZO2r36REBTlXWGdnyLJw
 VAimFe4BS48X7GBJl26JZzoQ4/3LDeW7WgvRoPiDk8nBEycTWvFln2F8HVtIaMUO/o6v
 fpR1wXhgiV7UutZgP3auaTddUoAcY5jKyLE= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j74pn0wy2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 15:34:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCOZPj/FuReWViLI/vLUCxG3hk5oNYnyPIKHHKLs5fR5AcicDJjyd3pvF9mEToxXcdMwE6ThOWP1QTfityuVk4yk1mNkJfSX7TQ/sx+0xPdw8w3wsEl4sv3DosVcAQktv3PQwsADV1YZDV+/CWIdTfBdM4akcbBzrRnXVzVW3bIFan6O8wPd8BUTsn7nSw1GUWd/iEP1BTpRemKeHE/8+RghO4DlcSM4Ky83OUrHxSAGVZyGCE+7hCmIE9NT4eUPIhOPaMwlacTR1cqeWrnhVlhdxoFJu5EIGLxnDkNN1L3Qp+rFZhZuWwvvrGM1yfZD8uUM/Ocz+cpZfusb3g7c2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEH0C/0RAfWJ2+mFPkXXs+X7a/jwUZoCOELN6NgXac0=;
 b=DIXQL/dh9k/WMuUl99k6rixvZWf6pCPd8LZ8LKS/BeI0UBG2eG19w0mi9ZNqflE6BYzKdJ5+Vg0+gsc6V6ye9B0MrJIDRqk0Kw7CGoyQh8h2gKZHnrvDaws+IXGaZDcM2OMKBjoiMVW/ngIe7BuVm1KaCeqSFGhROuBPUbWIdK5brJ3yZ8nuSFZX/dTnzKj5zjdKps5n5B4jwD1VgntcG356fZ272E9qfuQBJrHzQLthwNSb6NZpDDRPEbSstYQnCeDrJDjb4RM3qsfEJ+nhPmitTUKV0Wbi/v6Y8febF5W0iZh70CWlATk8kBzB+ooRl4OWCcalbfOq4lhma/Yjww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4982.namprd15.prod.outlook.com (2603:10b6:806:1d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 26 Aug
 2022 22:34:34 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da%9]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 22:34:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Serge E. Hallyn" <serge@hallyn.com>
CC:     Paul Moore <paul@paul-moore.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
Thread-Index: AQHYsML1s5QOEDIN+UabdnIDmWJJf62yExMAgAEh2FOAAA7TgIAAQiRwgAAERYCAAAwHXoAAA3iAgAAEXA2AAReTgIAAEl8AgAGLNoCAAGuIgIAJPUDAgAARoYCAACyYgIABJECAgAAa2YCAAEMAgIAAGjsA
Date:   Fri, 26 Aug 2022 22:34:33 +0000
Message-ID: <56DF9AAB-CC68-4CF3-A9EC-FD8F8015CFF6@fb.com>
References: <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
 <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com>
 <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
 <0D14C118-E644-4D7B-84C0-CA7752DC0605@fb.com>
 <20220826152445.GB12466@mail.hallyn.com>
 <25C89E75-A900-42C7-A8E4-2800AA2E3387@fb.com>
 <20220826210039.GA15952@mail.hallyn.com>
In-Reply-To: <20220826210039.GA15952@mail.hallyn.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b8b747b-3ed6-45ad-b1e7-08da87b32653
x-ms-traffictypediagnostic: SA1PR15MB4982:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Td+a/YZXItYYVRzII8IZRIuhC/N4Ystfb0nfiInJkd+DAv4epDCh8FzqexMQQsSYZujyJb0+S8bsbPQjMd9KsDkfuQxvyKm8IS8SUNYE/yl/pk5q9XtGxGimcMbQ0Wt82Mg8xaTAHerPfykOjm4AfyVK9qmKGhfLKJpAa2Qva/PAG7jDlRItsxNDz2xyXP9wvcg197t7ZpU7BQiLNrB7eLgNKSI+ixAPeN2I69gWNQy3CqCpC5CStVkcd/8fIg5ypfb88l4AAp774hyZLMPXqg5s7aQ7uaWQKv6DhLCfCnyXX8H24QETZApd+2vjz16906kL3BpFrZohfx7hYftset5Omq3QJxF+uCKmAxVk0HDgLaLh5j0alUmKDZIfEkuArn55Dei/6o5PUzhVsZCLvJSjYmUWnZFGWKykmTJfIUs5FwjoGwKAXo33dPrA0IbokQU1CbyYTgBEa5Z9q34MPcRk30E32kFHjrqVaj7Svdr306PzkwjVdkB6PPAyruIq1ClbLvHWUK5+BbwHK1EmLNfu19nQ3i3p07BFf9dKD+ewQbHqVI56+dtmoFfrMz9EXLAg/KStIWvqZ0GoOzfYhvKsMWgHBUCIOR16XVrj6nyrRk3K8+DhDBngdxBJw9/ugy7NOUA1ZAkSCMV5k36yOAh9LnhllfE7Ib9WwdOS/wLdVmEsq8x2Y7lwtiFD+hU4dlQBFWjr5cIZkcjnwC64LSWSj7ddrRmvHVoacE5iKDhBTa38E4LWr3NUJgf08tOlN2eMC882CnEbOusxooSyaThGQ0dKimYAF7XaiIzwwnhpg4zFwPP0no7DpzZGEmNYYwWMq9JxnuYTCFqqVpa+MQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(7416002)(8936002)(5660300002)(2906002)(54906003)(6916009)(15650500001)(316002)(71200400001)(33656002)(478600001)(6512007)(53546011)(966005)(41300700001)(6486002)(6506007)(83380400001)(186003)(2616005)(64756008)(66446008)(4326008)(8676002)(91956017)(66476007)(36756003)(66556008)(76116006)(66946007)(38070700005)(122000001)(86362001)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?myelErf0K4dzwCop7yFBwbpVbwOzt7qB1jB2skDCwOUtGS+TBo9p+Oorq2F4?=
 =?us-ascii?Q?+GQfAXSEtz279WkMG8ayV4oHxmJPyT1+Pz2ktCb5yjAr2E0PG/MtmABjwb9w?=
 =?us-ascii?Q?mpJ5wjzG7SEZ3ifyoR76NUGfM575N0EzQDQPyhsU4G+v+0Xp5cJERLT9yxQs?=
 =?us-ascii?Q?ueB+6w0GVk5nZZjY6GwLhP2NQ/kmSBlU4toQarLAZBCm5sGgA/9wtjbCikK9?=
 =?us-ascii?Q?5idvZVSm61mTPoGl6Gtxw1XNWGcCKA4mnN5wFU2MHKEMtXL6feQ1uFjYi0yq?=
 =?us-ascii?Q?fMqWKvWxWkOXmu7QlU7NsCIHwNgPDDocG97MyyBQoI4ZxLcYLybaQ4Dx7v4d?=
 =?us-ascii?Q?WRDdpZYtZnPFki1O6ByBrS1WvvaK26e0xkhD+jCN32BmGU0htHy8dGlRfNEq?=
 =?us-ascii?Q?D9aV/Mlb/sPQ7RxUjyTCUBIhduPqb96GJDu2nU/z0BKHVe59J/i0Zq72GuZq?=
 =?us-ascii?Q?74LxU1YDliii9rzq31vcM1N2Y3M7Om2Ejxy0EC71fFyB8GH5dFa/0RqPlzfL?=
 =?us-ascii?Q?wNI0i4FQoY2oRb08osV0RKbLISC5JZHn+QlhhIcnHkgQ3kUI0R99OMa2VNv0?=
 =?us-ascii?Q?k1xLCTwSH6ycyaCqAJgTYvXNTj/aKWdFfNEzYxNOMoBHtv/udjCPmffRHdn+?=
 =?us-ascii?Q?WUJS9uOYcblTrexSPeS1Dlxebdlqzs0jkO5if847jDJVhaWIpkaaI3Uw5i5B?=
 =?us-ascii?Q?5T/45ZuXCglktA2/UogNnifEh25kRJ/hQ+5t3h39jx6cOw+sTG7edmwAYa3z?=
 =?us-ascii?Q?HWJkoe8CFvONX+DvIHjG26D3V10PvPxbKn0ElC+XloZFW6NGAoQekIiurj8M?=
 =?us-ascii?Q?Uo25vdqYZu6gVLZToFFfNEzU3cwmQBXM0RQaIcg7c1MTBmTeEQ2WHyHnalBy?=
 =?us-ascii?Q?5hojeKg6dC0PNZstewi/o5ettMRsxIbuu6NVaDFuuhESLpHlgUjtehDBLJSO?=
 =?us-ascii?Q?XEu7XkEwG1FeWJDNEkbYDD057fkaQrVA3tiMxIWnG1s/MLshR3mHBbOjnXPa?=
 =?us-ascii?Q?YRU3pbqRQfD5W6UNiOmwrQah7cPdFBwoDQieylGExCLrGrrJpQD7C5S1EUSK?=
 =?us-ascii?Q?LEhYBlQXl0b76KFOw1Z8AhjCv/3RL9fNIcosf0fIzxc3olz7FlBaE6sb7vS3?=
 =?us-ascii?Q?VkfOILMeRGwq0ijKu9yHnI6MEhIV4ZpELAB6wRDcHqceqxRy6PxNf64k8Mb+?=
 =?us-ascii?Q?l/d35sl2wPwPQ3/ckCO4OtbPSA1KUSzb10RWIplVlLv3ti5asyh7kOHPF5lx?=
 =?us-ascii?Q?+piqLux3JXyg4+8XPf4PKd1Enxo8SjgRECgTRlVuVZiQumUUnEpXvjW45KUo?=
 =?us-ascii?Q?YQGUDn1Kti70ETtZHzTEiJf553+lLE8q/So56Zgntk4OJuEclR07E/Z0XCBg?=
 =?us-ascii?Q?CzjJR2UFmpJB8qiMvjw6KS8EwGZM548jeNnxw78bYrZH9svGtxS+unSECkmi?=
 =?us-ascii?Q?bpAw7cU/Hy7Bywfa0IQpXfCORmygJBEtG9WBImh69dEpZcNGz7IQ344jl1vT?=
 =?us-ascii?Q?/Qv28mYTYhkWiCNMN7DGDKaGbQAzA6bFE3vHSVKP8yySuPsGs/iB4lIie6jd?=
 =?us-ascii?Q?8UMHgEzIVI1Iec6TX0PvZX4IbyupnCXSImwzzsimCZnqdUJBo1mxd2jUhltH?=
 =?us-ascii?Q?3FbhSEytIoY4kq9FWyxEZ6s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <88DFECEC9FE2F342BBC74E29D956AFF1@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b8b747b-3ed6-45ad-b1e7-08da87b32653
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 22:34:33.7636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yGcXV53ilq7kvd/5sN65SzI/ui/DNdAfe2seFYDH6SD0T11Z8h5ILd+s56Kib0bDTGFvfVDvPMZSaXbBMrjH5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4982
X-Proofpoint-ORIG-GUID: kLn5MbRFDChghZarT6f97gZHa_HeLCNi
X-Proofpoint-GUID: kLn5MbRFDChghZarT6f97gZHa_HeLCNi
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_12,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 26, 2022, at 2:00 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> 
> On Fri, Aug 26, 2022 at 05:00:51PM +0000, Song Liu wrote:
>> 
>> 
>>> On Aug 26, 2022, at 8:24 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
>>> 
>>> On Thu, Aug 25, 2022 at 09:58:46PM +0000, Song Liu wrote:
>>>> 
>>>> 
>>>>> On Aug 25, 2022, at 12:19 PM, Paul Moore <paul@paul-moore.com> wrote:
>>>>> 
>>>>> On Thu, Aug 25, 2022 at 2:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>>> Paul Moore <paul@paul-moore.com> writes:
>>>>>>> On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
>>>>>>>> I am hoping we can come up with
>>>>>>>> "something better" to address people's needs, make everyone happy, and
>>>>>>>> bring forth world peace.  Which would stack just fine with what's here
>>>>>>>> for defense in depth.
>>>>>>>> 
>>>>>>>> You may well not be interested in further work, and that's fine.  I need
>>>>>>>> to set aside a few days to think on this.
>>>>>>> 
>>>>>>> I'm happy to continue the discussion as long as it's constructive; I
>>>>>>> think we all are.  My gut feeling is that Frederick's approach falls
>>>>>>> closest to the sweet spot of "workable without being overly offensive"
>>>>>>> (*cough*), but if you've got an additional approach in mind, or an
>>>>>>> alternative approach that solves the same use case problems, I think
>>>>>>> we'd all love to hear about it.
>>>>>> 
>>>>>> I would love to actually hear the problems people are trying to solve so
>>>>>> that we can have a sensible conversation about the trade offs.
>>>>> 
>>>>> Here are several taken from the previous threads, it's surely not a
>>>>> complete list, but it should give you a good idea:
>>>>> 
>>>>> https://lore.kernel.org/linux-security-module/CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com/
>>>>> 
>>>>>> As best I can tell without more information people want to use
>>>>>> the creation of a user namespace as a signal that the code is
>>>>>> attempting an exploit.
>>>>> 
>>>>> Some use cases are like that, there are several other use cases that
>>>>> go beyond this; see all of our previous discussions on this
>>>>> topic/patchset.  As has been mentioned before, there are use cases
>>>>> that require improved observability, access control, or both.
>>>>> 
>>>>>> As such let me propose instead of returning an error code which will let
>>>>>> the exploit continue, have the security hook return a bool.  With true
>>>>>> meaning the code can continue and on false it will trigger using SIGSYS
>>>>>> to terminate the program like seccomp does.
>>>>> 
>>>>> Having the kernel forcibly exit the process isn't something that most
>>>>> LSMs would likely want.  I suppose we could modify the hook/caller so
>>>>> that *if* an LSM wanted to return SIGSYS the system would kill the
>>>>> process, but I would want that to be something in addition to
>>>>> returning an error code like LSMs normally do (e.g. EACCES).
>>>> 
>>>> I am new to user_namespace and security work, so please pardon me if
>>>> anything below is very wrong. 
>>>> 
>>>> IIUC, user_namespace is a tool that enables trusted userspace code to 
>>>> control the behavior of untrusted (or less trusted) userspace code. 
>>> 
>>> No.  user namespaces are not a way for more trusted code to control the
>>> behavior of less trusted code.
>> 
>> Hmm.. In this case, I think I really need to learn more. 
>> 
>> Thanks for pointing out my misunderstanding.
> 
> (I thought maybe Eric would chime in with a better explanation, but I'll
> fill it in for now :)
> 
> One of the main goals of user namespaces is to allow unprivileged users
> to do things like chroot and mount, which are very useful development
> tools, without needing admin privileges.  So it's almost the opposite
> of what you said: rather than to enable trusted userspace code to control
> the behavior of less trusted code, it's to allow less privileged code to
> do things which do not affect other users, without having to assume *more*
> privilege.

Thanks for the explanation! 

> 
> To be precise, the goals were:
> 
> 1. uid mapping - allow two users to both "use uid 500" without conflicting
> 2. provide (unprivileged) users privilege over their own resources
> 3. absolutely no extra privilege over other resources
> 4. be able to nest

Now I have better idea about "what". But I am not quite sure about how to do
it. I will do more homework, and probably come back with more questions. :)

> 
> While (3) was technically achieved, the problem we have is that
> (2) provides unprivileged users the ability to exercise kernel code
> which they previously could not.

Do you mean this one?

"""
I think the problem is that it seems
you can pretty reliably get a root shell at some point in the future
by creating a user namespace, leaving it open for a bit, and waiting
for a new announcement of the latest netfilter or whatever exploit
that requires root in a user namespace.  Then go back to your userns
shell and run the exploit.
"""

Please don't share how to do it yet. I want to use it as a test for my study. :)

Thanks again!

Song
