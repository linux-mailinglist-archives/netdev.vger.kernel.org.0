Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A764E20BD35
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgFZXr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:47:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57454 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726256AbgFZXr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:47:59 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05QNgvoI012236;
        Fri, 26 Jun 2020 16:47:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XnuvNpQDXBjxDajbDqhYtKxaAEzGgjnHEtaxgLty0+I=;
 b=b3qbQolJ/HNblUKM2fDBgv08z94YfnaK4c1YC1jZz+CpGw4eZEScvI77St7T1lvRc1GQ
 J+0w/XyQuFcwShExAutOQZAHFMR/XDWOdtes/xHPG5OMDAw7CT756EyOjC8KE4Q8SCX6
 p1PXF/pq48O+yTmvuU3lGLK3LMBca2mwmM8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31ux1gr3ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 16:47:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 16:47:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtXtxgrho96v3xnOd0DHvGDdAWHeDBT/uLT8beOtjWUUcAW/1qtz1E0cVEaC+2A625XAyn0In1KENN17PEpcOd3M8Aw4Fg6frsnXSpGd+jROO7PU/SJvG/oNRWK79anr5cjs1A4VNAmJeqWGoMJF7PbQzS40VPP9NTLon8Cfa9KkKnGTe0iAN0Rgt72tfmRSBGIruKo/khmTn6VmcLnh7jQ7VPcm80cuOfqpnVVl+iP1HvCMCwVLRubrHQJsa25yNN0POHfqHrbX36i4ZvR45aUWbL6r2YmZBnaF3xQIjg3cJQY5Kb2p0mhapwlh4pphDoNQL6y4lILQ1F8WUK0YPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnuvNpQDXBjxDajbDqhYtKxaAEzGgjnHEtaxgLty0+I=;
 b=ZIK3Vagb7jDkivmNHdtyH04f4CatHrQKm2gKnJw8ft2kh0pwQLhlMz2sOneZ7+BTtfLoLaIvRXbOfmLyJ4uYlPFWOA2P+VqAHyWm7NF66VPAzq4kCnSTuov0aMTYFfy6Pb+wx9h1g6spdNmG10ek6Y4weQtVgjqW5Tcy6AEa1L2b9vN3OCdhxHkZENZkT9lY5HXUvenzSJjcPbDMA3WfDF0LjofDPrp4NsJnG+OEmxJoGNMnOUs6Yk9NhONH1UZkHTQ4hRnzRtPrrFIGSXjqqv+w6YqDhpZN7Dnj56/ULcCZVgApD5qi50gqOuXkdv0p1ljwGFToxTuxV855pC5ZHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnuvNpQDXBjxDajbDqhYtKxaAEzGgjnHEtaxgLty0+I=;
 b=M1xACxGusJvgxfoggPtWK1CMAV8LXBpTol2fMWU2Wgge+tXKgGjgiZMVBp0+W+avN61uubbbipnG2am1fEgVLNEGTcsw8w2Jx4tBXPEhkzMoshV+OZ/iOU59R2hAv7t7owcBD0nuJsSDPueBwlpSO0LxsT+o36g9pxwtoXkWJOs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3304.namprd15.prod.outlook.com (2603:10b6:a03:10a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Fri, 26 Jun
 2020 23:47:37 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Fri, 26 Jun 2020
 23:47:37 +0000
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
Thread-Index: AQHWS06r1sTuO7iWZUmEIP/wOjIJvqjrVxKAgAApV4CAAAGJAIAAD8iA
Date:   Fri, 26 Jun 2020 23:47:37 +0000
Message-ID: <AD7AE0B3-94F9-4430-990C-85B9CF431EC7@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-3-songliubraving@fb.com>
 <CAEf4BzZ6-s-vqp+bLiCAVgS2kmp09a1WdaSvaL_jJySx7s7inA@mail.gmail.com>
 <C3B6DD3E-1B69-4D0C-8A55-4EB81C21C619@fb.com>
 <CAEf4BzaC1Dqn3PXBJmczPRaUmjKc7pcg6_mjyKymBek-sDKv7Q@mail.gmail.com>
In-Reply-To: <CAEf4BzaC1Dqn3PXBJmczPRaUmjKc7pcg6_mjyKymBek-sDKv7Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1a00]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31502bc7-72ac-4db0-1e13-08d81a2b4ea1
x-ms-traffictypediagnostic: BYAPR15MB3304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB330452D761DAB37EA30DB7C2B3930@BYAPR15MB3304.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CBeEIfNU4xeFVLj95EzLGX8wvnp352dg8ZFz4nZVM7IiH/pAzxcIvW1kGroinLVKy60tVVg+dWGuXxbHJX6yg0Q8Sj0rws1b/V/7yPIWdogB3UI04mmvBBb/18P67gs8OfsZmr+/CHy5PDOmYSZaI7aQD16Z/wm6+fFpOQIMIaXoYg/x9n3pX+cKbRICN7Tp/IhO7tF1Ibyiywxl3/S22+t53c5LGjej8CQfMJ2EvmbUTfub5RixynY3aGNZzak2mK5RjK+Mj/P9IZYRDXngMzyLMt4BTNFS4MGVWXlhs5vQiD0Ebi7HfMYsE5gfuvQ+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(53546011)(36756003)(6506007)(66446008)(66556008)(66476007)(6916009)(64756008)(76116006)(86362001)(8676002)(2906002)(5660300002)(83380400001)(4326008)(66946007)(186003)(6486002)(8936002)(54906003)(316002)(2616005)(6512007)(71200400001)(33656002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DyOUVIoYPLMCDvvhIi80gAivjAg6i9zij2DfnvKyjYxKLXy/Yyy8J0/tH+hIy8QyAg5wtgv298IDhUt9vz4h6ofiSLsOgFgXwS9tX7PgoLIUkfBab3qWnb8xQKSz+0hLKlrfdWI2fkynl7eh5/OsS0nKMdf8LnrmNARsiJ0Dt2z+G4odVQORJIxHwDnct6V0wULixoVBGidxD+jhvZ4FjgOWqAJp0dkbv63poGDd9q3TEi4EDApPs3mtVcMOnxmK32CY98thKBxrydF4DuQuf5tN/W66bwdeymorphYjNl78sADkpXT/3tyQD4ehotP3ee+2GT7DrGJRRUxeEMirPAdlkTnNteVwdxkhsn06PlS1QLwGC1X5mwZXFJyNp4OZ9Dz+KVNggZfRp/iJhYyWgxE7gXTp9bYfMyYyTn3s0XpLeUvT1Pe9z3yEGFl9PUDUUjkOdNJ4rNO7Doe2GHrU9ZrcphJyLWU77F53gWbG7xh7Z9gk4EYApLO8FwBjvhLdKyd/r1WP+wYZNfM2MOvNoQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <49BB2D9DD69C93498B2FD28B00AC4E14@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31502bc7-72ac-4db0-1e13-08d81a2b4ea1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 23:47:37.6783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /h4plxw4k4TgHeS/ieimYLp3X2J3g8k8ct6Q/seE5CipAz/TKwBQSVtRwQQtHOEAg8X0GOHQ0uabcNBpKSCX2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3304
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2020, at 3:51 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Fri, Jun 26, 2020 at 3:45 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jun 26, 2020, at 1:17 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
>>>=20
>>> On Thu, Jun 25, 2020 at 5:14 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> Introduce helper bpf_get_task_stack(), which dumps stack trace of give=
n
>>>> task. This is different to bpf_get_stack(), which gets stack track of
>>>> current task. One potential use case of bpf_get_task_stack() is to cal=
l
>>>> it from bpf_iter__task and dump all /proc/<pid>/stack to a seq_file.
>>>>=20
>>>> bpf_get_task_stack() uses stack_trace_save_tsk() instead of
>>>> get_perf_callchain() for kernel stack. The benefit of this choice is t=
hat
>>>> stack_trace_save_tsk() doesn't require changes in arch/. The downside =
of
>>>> using stack_trace_save_tsk() is that stack_trace_save_tsk() dumps the
>>>> stack trace to unsigned long array. For 32-bit systems, we need to
>>>> translate it to u64 array.
>>>>=20
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>=20
>>> Looks great, I just think that there are cases where user doesn't
>>> necessarily has valid task_struct pointer, just pid, so would be nice
>>> to not artificially restrict such cases by having extra helper.
>>>=20
>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>=20
>> Thanks!
>>=20
>>>=20
>>>> include/linux/bpf.h            |  1 +
>>>> include/uapi/linux/bpf.h       | 35 ++++++++++++++-
>>>> kernel/bpf/stackmap.c          | 79 ++++++++++++++++++++++++++++++++--
>>>> kernel/trace/bpf_trace.c       |  2 +
>>>> scripts/bpf_helpers_doc.py     |  2 +
>>>> tools/include/uapi/linux/bpf.h | 35 ++++++++++++++-
>>>> 6 files changed, 149 insertions(+), 5 deletions(-)
>>>>=20
>>>=20
>>> [...]
>>>=20
>>>> +       /* stack_trace_save_tsk() works on unsigned long array, while
>>>> +        * perf_callchain_entry uses u64 array. For 32-bit systems, it=
 is
>>>> +        * necessary to fix this mismatch.
>>>> +        */
>>>> +       if (__BITS_PER_LONG !=3D 64) {
>>>> +               unsigned long *from =3D (unsigned long *) entry->ip;
>>>> +               u64 *to =3D entry->ip;
>>>> +               int i;
>>>> +
>>>> +               /* copy data from the end to avoid using extra buffer =
*/
>>>> +               for (i =3D entry->nr - 1; i >=3D (int)init_nr; i--)
>>>> +                       to[i] =3D (u64)(from[i]);
>>>=20
>>> doing this forward would be just fine as well, no? First iteration
>>> will cast and overwrite low 32-bits, all the subsequent iterations
>>> won't even overlap.
>>=20
>> I think first iteration will write zeros to higher 32 bits, no?
>=20
> Oh, wait, I completely misread what this is doing. It up-converts from
> 32-bit to 64-bit, sorry. Yeah, ignore me on this :)
>=20
> But then I have another question. How do you know that entry->ip has
> enough space to keep the same number of 2x bigger entries?

The buffer is sized for sysctl_perf_event_max_stack u64 numbers.=20
stack_trace_save_tsk() will put at most stack_trace_save_tsk unsigned=20
long in it (init_nr =3D=3D 0). So the buffer is big enough.=20

Thanks,
Song=
