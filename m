Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ED920BCE2
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgFZWqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24322 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgFZWqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:46:01 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05QMjMTK014708;
        Fri, 26 Jun 2020 15:45:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=H+bnfQBBWFjSY2Vx7UTjeinaNzpXdPhUkj7ltmAyu3M=;
 b=C78rmZxt1nAZMZnrA/zAnsoAV5U0R+vgzNDdXufnD5TRjH4jaXUKL1ocx64g5z4BTs4S
 REWqiQDXlF2N90Kdann5BEqVbAjULfvYdBvJipUNMQCZEeLy60vKuJAh4kG06LHAeoOY
 5jJn2I5y6O6P95LdgkQnoy/pzOpWyfbg+Ok= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 31ux0nysen-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 15:45:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 15:45:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnqsIiLIX9eEeeWfTO5R2z2aAtyfgctw09VjMqTaXgU1+mur0WpTcLg1AMpRdLkQkPGDXgpr+EKckZRd2Du1v5MS7vXThm9EQ+DNPJI2FIzcSsxQ/W+4wtnGMC9swlaTyczT83KLhdOe+eFxyNvhHkJkjBhwh/whXLydMRlgiLRFA4iccYP5alhzRsxKmbN/8ZRWtzi1f6dx1VDzWF30pcS342hBhw89VFB7cq920aWPds0gxxw8y1idGWfukEOTF3GE05gd6eVcBsmd3tZFt70LU72g7x8UMQdxLTyej5NTSmXE5Qxq1exQa1BgZCOyNkjyOvQX9IcF38vbuP1sgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+bnfQBBWFjSY2Vx7UTjeinaNzpXdPhUkj7ltmAyu3M=;
 b=RvvaF+JgyXiX3mJ6ARSd2NAueI5HXnbC1mpBAcbbYtyQbfnXsqfZhxycc5dgzuqJIkVDpIaE5PRHdJ18qqz8F2F03cbLoV8G2kud9MTzLjx/9C6nINYjQjtPjLbBOb+/UH3xwQ761DBa29l2N8BlSyinqZQTAs+ufylU2lffddn2+a+r44le+d5j076sCcNmQxap1YHIcOoy4KHO+EN77gutabM6gl0jPjalPbAmSyLohid6JFvfwXPrJEJekeZOx0NtzAeHEth3xKCaz2D7y2BelQwau3hL2vK8qHMfMiPtHK80dIjoFuAVWfDvh5kd/LFU8O1Qa932zUFTjVBAcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+bnfQBBWFjSY2Vx7UTjeinaNzpXdPhUkj7ltmAyu3M=;
 b=Xocw/294mFdWor41zxoDXANNqgb167y1A5br5gDuz6qbB+4FQTRf6obCNNyYzykRubaYNqY2oaFIcranTiW6cztA4md6nOUAjE7RrU0tXnlIH/K5rMBGHDPEkg0RqLYKyWr2uJyfbWTOG/7K8irxSOA11zrSbB1584LCtI62pkY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3366.namprd15.prod.outlook.com (2603:10b6:a03:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Fri, 26 Jun
 2020 22:45:39 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Fri, 26 Jun 2020
 22:45:39 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: introduce helper bpf_get_task_stak()
Thread-Topic: [PATCH v2 bpf-next 2/4] bpf: introduce helper
 bpf_get_task_stak()
Thread-Index: AQHWS06r1sTuO7iWZUmEIP/wOjIJvqjrVxKAgAApV4A=
Date:   Fri, 26 Jun 2020 22:45:39 +0000
Message-ID: <C3B6DD3E-1B69-4D0C-8A55-4EB81C21C619@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-3-songliubraving@fb.com>
 <CAEf4BzZ6-s-vqp+bLiCAVgS2kmp09a1WdaSvaL_jJySx7s7inA@mail.gmail.com>
In-Reply-To: <CAEf4BzZ6-s-vqp+bLiCAVgS2kmp09a1WdaSvaL_jJySx7s7inA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1a00]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f890e48-7a57-48f8-ab79-08d81a22a68b
x-ms-traffictypediagnostic: BYAPR15MB3366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33667AEDA5D6B0A5D937BC8BB3930@BYAPR15MB3366.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S0+SKyxgDYq29OPT8cxR7iMbyS681TmJWk8zqZbGLOli5GxZzpEZtJCks+yzdDpu2ZLo/XQTu4IClTf0Ug8SfNypdvfXHkh+TI0cQXGVn1BhqxsOvWZIcXTuTdU/WMdCPC3XrVHDRXmVHYXbh65ZdpOVVn18BvfJuEifVKKnMeOg0fGH0wd6HL6Kavg2sjwIciQY45B4/e2bDgidK0mhMXpv7pOO5wMSQOvbApHPFB+cV6HCfrfkWJOjKUoqObZSJ3VgbQ+Oj3eRkG1JvNGq1gFiojduzB3PiDpaVMuMiJHeaSQiJ1g8lPjKXK2+8pgoPvO5eSV0AE5sSQc+4vYGNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(136003)(39860400002)(376002)(396003)(6512007)(54906003)(6506007)(316002)(478600001)(36756003)(2906002)(53546011)(86362001)(4326008)(2616005)(33656002)(83380400001)(186003)(71200400001)(66476007)(66446008)(66946007)(66556008)(8936002)(6486002)(6916009)(8676002)(5660300002)(76116006)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MGoqaKip1zptm5y6IImPtHkh9HR+cIH6uCn2iNl6/R/g9dp4AuKuwrCUccs2nGCYyKrCyH1ttXX0J/s3zUrfid3lnmRFrtNkvaFcCW9M2bOdONn7+4uyvBpxcIzdhC4Zx8qLQkSEeirf9dWqVCTruBVZX3SICxCyPJ0Vne8nCO0U+zEmUnUL9K11oslbBNysNs6xdIVy0JEbpCxVQiGYFs7GWvm2gibd8f+doGqm3KhNrx6DqSWStz7Qp+UAzoIUDW0f0BJf5+zBj1lM2fhiNEEGNYAWXk4ZaSIf9KRQiJZRuZtGfWv2mB24XJ7XJR2GFDW54NMl30ME0VXo1JJUjK3miR9Y0Hpl88IkqHO1i5QXpJX5MmpqN3ZcxG4zkJSrwdt/FXWG2y2cN/VYYCmdGfZpT7UNGavC4tvdJbApugYqSzbfr+pBBNFrxTWGsFMzOnRdL15xB/qbcBv++ZPSomkDqvCfcRMocJzd8aSkJxtPZ1CiaCPN5EGLE8iLFsrd8baocC/trqRGfNRPoOuBcQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DDD403D82D86084CACDB808E9059641A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f890e48-7a57-48f8-ab79-08d81a22a68b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 22:45:39.7047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nm0O3qPoHcbn88kx0dexvNdPw0Z0utEcKHgdwzreUnup3DaXGQcmlfiSt3Ac75q5hkWZK1FB34w1rEjA54gkyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 cotscore=-2147483648 spamscore=0 suspectscore=0
 adultscore=0 impostorscore=0 mlxlogscore=854 priorityscore=1501
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2020, at 1:17 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Thu, Jun 25, 2020 at 5:14 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Introduce helper bpf_get_task_stack(), which dumps stack trace of given
>> task. This is different to bpf_get_stack(), which gets stack track of
>> current task. One potential use case of bpf_get_task_stack() is to call
>> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
>>=20
>> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
>> get_perf_callchain() for kernel stack. The benefit of this choice is tha=
t
>> stack_trace_save_tsk() doesn't require changes in arch/. The downside of
>> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
>> stack trace to unsigned long array. For 32-bit systems, we need to
>> translate it to u64 array.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>=20
> Looks great, I just think that there are cases where user doesn't
> necessarily has valid task_struct pointer, just pid, so would be nice
> to not artificially restrict such cases by having extra helper.
>=20
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Thanks!

>=20
>> include/linux/bpf.h            |  1 +
>> include/uapi/linux/bpf.h       | 35 ++++++++++++++-
>> kernel/bpf/stackmap.c          | 79 ++++++++++++++++++++++++++++++++--
>> kernel/trace/bpf_trace.c       |  2 +
>> scripts/bpf_helpers_doc.py     |  2 +
>> tools/include/uapi/linux/bpf.h | 35 ++++++++++++++-
>> 6 files changed, 149 insertions(+), 5 deletions(-)
>>=20
>=20
> [...]
>=20
>> +       /* stack_trace_save_tsk() works on unsigned long array, while
>> +        * perf_callchain_entry uses u64 array. For 32-bit systems, it i=
s
>> +        * necessary to fix this mismatch.
>> +        */
>> +       if (__BITS_PER_LONG !=3D 64) {
>> +               unsigned long *from =3D (unsigned long *) entry->ip;
>> +               u64 *to =3D entry->ip;
>> +               int i;
>> +
>> +               /* copy data from the end to avoid using extra buffer */
>> +               for (i =3D entry->nr - 1; i >=3D (int)init_nr; i--)
>> +                       to[i] =3D (u64)(from[i]);
>=20
> doing this forward would be just fine as well, no? First iteration
> will cast and overwrite low 32-bits, all the subsequent iterations
> won't even overlap.

I think first iteration will write zeros to higher 32 bits, no?

>=20
>> +       }
>> +
>> +exit_put:
>> +       put_callchain_entry(rctx);
>> +
>> +       return entry;
>> +}
>> +
>=20
> [...]
>=20
>> +BPF_CALL_4(bpf_get_task_stack, struct task_struct *, task, void *, buf,
>> +          u32, size, u64, flags)
>> +{
>> +       struct pt_regs *regs =3D task_pt_regs(task);
>> +
>> +       return __bpf_get_stack(regs, task, buf, size, flags);
>> +}
>=20
>=20
> So this takes advantage of BTF and having a direct task_struct
> pointer. But for kprobes/tracepoint I think it would also be extremely
> helpful to be able to request stack trace by PID. How about one more
> helper which will wrap this one with get/put task by PID, e.g.,
> bpf_get_pid_stack(int pid, void *buf, u32 size, u64 flags)? Would that
> be a problem?

That should work. Let me add that in a follow up patch.=20

