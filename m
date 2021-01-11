Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4084B2F24F6
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391705AbhALAZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61888 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403983AbhAKXRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:17:54 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BN90TH028183;
        Mon, 11 Jan 2021 15:16:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=38e8TzrZOagziBVxcHeZI1RooeO+UChuauir9ogqh58=;
 b=cnzE7GFyFS6QNljBOoyqVaqj5lmiwRdiJ46T2LrSzrBqnauWOx5UPRkSkY40cTIT+/Yh
 f5eNKuIVMH9NwlLfUfLUN0WrnleLIbxNI5zdUcAfLYgivNZ++MwvHLsE5dEK1fqoEnrU
 0KlQ8oFbKfWuqQcikQa31uFWD3hiLjrEFho= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35ywdbqpf9-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 15:16:51 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 15:16:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXikBx7TAIbnZAH/S5F2Ql7RoPz23cjvrH1iPUKEI7Z3Mx+bvBQIumK6M81/6h+xtP0mnIymsegphXEhSU303v+e+UbSNxvUITbdwod/3892NRtc/cmmuMuw26oVR8iPuhoSIPvTY3ZaT8KNPJL/7Tex13L3Ci3O0OkGGC9F5pDQImcnRFOsrKywxAFpLQHyXRJ2/uMH/td4j4Oqyy4JN1KCaLhKAMFiMexGGv5IFiQKe0Hw2/Ui3FLdh4KKGdKbVOvBw1FUrkxAfu/1aJYQ45Qw5l56050SJIZlMcD+y57HBki0ea1w/3ViUZgiP37n5kUzMT9y/8aWpuhQWYLEkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38e8TzrZOagziBVxcHeZI1RooeO+UChuauir9ogqh58=;
 b=ECuAP+43Veyw6aBL4zzjVkCcfejupFD4xqJ/JE8ql8QKlnreyele31ITS2qsRijkgGvw7VuF3YHPWRhxvNBv2V3nuvpjgUJKo2CRMDrO/wOAFltXjeBGEPIy9+xao2xxZ2eLwZOrAyiSCR1UuUXZV+wlRpRT8ZyXMi2hCR8Orh+2UIlSvCHzmgHdwnLcp3RULdcODYFR6tz42r9iXPgAo4CsXT88ullW9iQKJdjpKAVMnhqHp3VOjW5HCS9MJavcLR3RfBhVOy8ftf5GBrZjqGcBwLjm3/nbu7wB19E6y9TIjoPeRVoenpbLk/WTFIBtun752sy/5Q333nV+HcEZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38e8TzrZOagziBVxcHeZI1RooeO+UChuauir9ogqh58=;
 b=Y7YsKc93h3HsOqyC+37lY0u7TSmiRHGCFFrfp5nrVuqMfJio1r9UkCk+f0pkMcE2J3OtSu56ToM41NWafNWWVrmuW9yLx9pKkZHryvitvf7PPBmb53e1VNLVyxQl3JuEo5b5PosEM7hXBtm/+4C5XM6uqoyXnYpD6uk2CTeFmEs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3191.namprd15.prod.outlook.com (2603:10b6:a03:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 23:16:48 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 23:16:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     KP Singh <kpsingh@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        "Hao Luo" <haoluo@google.com>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
Thread-Topic: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
Thread-Index: AQHW5hbxN1bu8adE10+5MJhm5YS4VaoiOPkAgADahAA=
Date:   Mon, 11 Jan 2021 23:16:48 +0000
Message-ID: <CAA56F7D-0F98-4E36-9684-AE466351C353@fb.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
 <CACYkzJ6BT8F+75GW=7hLwjMwFccYBqPb3FXV5dVk0SkeNFpurg@mail.gmail.com>
In-Reply-To: <CACYkzJ6BT8F+75GW=7hLwjMwFccYBqPb3FXV5dVk0SkeNFpurg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:f14a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e3914a9-af27-4fc4-a458-08d8b686f8b9
x-ms-traffictypediagnostic: BYAPR15MB3191:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3191C1E613162890910B1484B3AB0@BYAPR15MB3191.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xMrpp/1PKyZYvM9BW55d7u4tN/4xnG5XaQDo8wGsCKZyFtkm8RWT41SNo/TNfRcMmWj9hvxBmpQ8ECpS6I8XzyXByrVC8+biphaF3U9hE1Z6+c6eBAClmEB8VAeUfj0tissAHvbxaOEq6FAX0LEO88xzV2IKfA6YY/yv95+QqHTdowxhPGg6BmvWjGqnfNgkLc4IwCwmCBWO3zKJO3CjdFtfITp5DHjcxrQE+ivXgDHYX+VqAcqIJLAzqlz5ES/vK8KS6ftCsqmRQJKmiJCM0bIW+elZ0y8bFDfDZOirpKuVn4J0yIJzTXVePCxW85u2X2ezntvdSqRgARFc01TmuB32omHMBqcU7t0rVHjwzqw9m0Rz1HbMuhyTTPvGEdlNFC3FtiS3QSS8A55UjbsJdZc0YT7jZygW8bBtMZrOKDrdvb81Z6XFphmzoXI1mk2c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(2906002)(6506007)(66946007)(91956017)(316002)(36756003)(76116006)(66476007)(83380400001)(8676002)(7416002)(6486002)(53546011)(33656002)(186003)(2616005)(66556008)(5660300002)(71200400001)(4326008)(54906003)(66446008)(64756008)(6512007)(8936002)(478600001)(6916009)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GROeEDOvacLJ6VOEdI8cY7Zfu6UR4Ai0QPbk2UeeKLwP3OQDyTwR008NJfFj?=
 =?us-ascii?Q?SSGG2sH+NnHI/VYP7AiunQsnGpeq/uHMTnbTb1R9ceMauUQUdtxPz9LiFu+l?=
 =?us-ascii?Q?cARMKpIx0RR59gwzrmvY3SoET27sxjxu6KTkUVivBZAujoOaVtmGt8mPyHy2?=
 =?us-ascii?Q?+dpw+BihKXzk0DpJGiw8NQphzuCzMhl16OXIb3d2KzinajiDp9nmzZYPa5JZ?=
 =?us-ascii?Q?D1CJoTLvBvR3Se34cyLKQIOZroId7UhpApJTNAudX4PHrH278Vd+hBDmX7hd?=
 =?us-ascii?Q?oUPFRnDjmqfBxnLguVc1AUy91kPCN0m6TvabbbujXBXEC6RkfHAzbdvxgJYd?=
 =?us-ascii?Q?Kjp0vkY+AOp6N0H26w8LVzUUYfoK6AR7oJRwB3KeEAxOXiwx7HmZ2Vi1M8Dd?=
 =?us-ascii?Q?WWdvWeOWRKA3pkJi1L/FBImsT4N9lad6xJeQCrsqHBdRa7UyOF05QwAkqJJA?=
 =?us-ascii?Q?Scwwv2uVIccd8W1EjNrwfL5W996eaSR/7S8uRWCKFLlv4ZpEjn1lSt3sEbVR?=
 =?us-ascii?Q?hkBwG+qi/k2Au0z63ESH5Fv5uqhcsHaeWcIHy+SRhgN+MKWHmGZMnqzbJjhw?=
 =?us-ascii?Q?ZLR2CMKQqtlu2jN+bJwdfWTsYDbwglN/l66xoGavNozijMO1xF61JiZiRnWZ?=
 =?us-ascii?Q?3QCWgL1wZW/PqObCoHrklcIuQR3K7soDoQ2uHh6QxgdoTm8VgwInuaVUztIm?=
 =?us-ascii?Q?+I2dNLWhdyH9WZeuOiTf+EYVXjTfOXV35OgC5OXhbJaXbpFvqFbaekckjhi+?=
 =?us-ascii?Q?a9yrS2fnxjMydtVcH0Z6ofiJFBCvG+ef3dFOLLpRUUa0ueLsfMtxr1jBE6IP?=
 =?us-ascii?Q?uFc0QblAmvKS0SIJO8pJaVj+hAtcaixGJCSnHg7UQSnzEHwE/Fkddaxt0fJ3?=
 =?us-ascii?Q?tJU1JXjBvILnnlA/2YIKpRg2ITo1E7ckHWdy5xqmvrhuYtH+IdtCpwUmUff3?=
 =?us-ascii?Q?w4vsyFmuV5PMo1p5Bmj7te1WZ5B1TBYEnMIwjlWZiSBAilftUD1oPprLRFLF?=
 =?us-ascii?Q?wvSXGnU7nJXjzgWp88VyxUBftfNsBvnIFw7qpPqQxA/ndIM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A620777959112145B01FBA1354B58F19@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e3914a9-af27-4fc4-a458-08d8b686f8b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 23:16:48.6704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w4phvqaV46YKzR4XzljP+NP78Uc55ry8BX9bXRrIAZnkBaXxwkG7VfStiHpZlwUvW45IPpOWtHQAfNWUkuAJ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 11, 2021, at 2:14 AM, KP Singh <kpsingh@kernel.org> wrote:
>=20
> On Sat, Jan 9, 2021 at 12:35 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> To access per-task data, BPF program typically creates a hash table with
>> pid as the key. This is not ideal because:
>> 1. The use need to estimate requires size of the hash table, with may be
>>    inaccurate;
>> 2. Big hash tables are slow;
>> 3. To clean up the data properly during task terminations, the user need
>>    to write code.
>>=20
>> Task local storage overcomes these issues and becomes a better option fo=
r
>> these per-task data. Task local storage is only available to BPF_LSM. No=
w
>> enable it for tracing programs.
>=20
> Also mention here that you change the pointer from being a security blob =
to a
> dedicated member in the task struct. I assume this is because you want to
> use it without CONFIG_BPF_LSM?

Yes, exactly. I will add this to the commit log.=20

>=20
>>=20
>=20
> Can you also mention the reasons for changing the
> raw_spin_lock_bh to raw_spin_lock_irqsave in the commit log?

This is because we will use these in irq context. I will add this to the=20
commit log.=20

Thanks,
Song

