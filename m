Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495362F8A44
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbhAPBN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:13:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbhAPBNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:13:55 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10G1BFdA006772;
        Fri, 15 Jan 2021 17:12:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cQj+7OBkOirDiIdGicf9AkWNp5R6HJ5Gh4QaolFFgBM=;
 b=JjRyTozsfxD5hr03GWAvVKtsqHZCt+8dkrIb/6MdSTClf76GZG631otJFABmsA82wJHU
 hkvxDKrswiuPjiqAd0IYk6FvRAqmCdynxK3kWlvdT/Qgc88MuvmWFn8FS8k2zfHiN8yh
 vTrHt3+mPD0Kx2a0626s/uXmurWGOmxIwqc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 362tcc7j0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Jan 2021 17:12:50 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 17:12:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljWCYGfztf4a0ehV9352JflKdsRPiOM1VinvGyhXGjfj/Fa5qJPkP1bfABR1v0D92pFsAJWkyUQYGv0ETH+X5ONJszSg467fBMU2DDBNn/HU35NGFrEXmiXcO6E0ZdC6vxKiGMY8iHpUv5UjzjAtnR9vrQ4Mz8Dh1nmAD+WK1t9Yo1ofsOTtrpsqe+w97Km9JXIr7jP/ZrWBI9CB/+o+7dR4ELDmNwY7OGvQNuVqD7ZuxZM1H9TFlaDXQz4CYUTLO1dqsczwzNDLE4/7bqOmmew4SLRJ0xXCpsehLYesg0rW2LfeGSi9UagUhp05tjm7jgpU9DtnZB4tX0h+SCRaOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQj+7OBkOirDiIdGicf9AkWNp5R6HJ5Gh4QaolFFgBM=;
 b=NpMstlyX4sRb+C+YGjFSrMdoOP8qTp0ce27NSb6om23W0r6NhiNBoD8BtU8DbU2TGXokEWkla5Qbbnr0x6PgEDJ4vOsgbVut/Tpc70IGB38CZW/wcVwirQHrc0Z8zxxm616wWdnT8AgXxAsUld+ftq4KBmu783EgZjaJ/CaL0djzLcDxfb4SF+OzsFkHYoCBhabmkWktkLSunOIZBd8O8eeIE1NiweUiX3rdsxbb+tIFgj3iQUrp7wrTTQd8OcGRFFCu698cxWZ41S5o5E3XZoLG7NVBGO6mHmy2lBF4HKcNTnOCuCn887h5aawDSchq1ed3s/H2T72fWPXjIX30Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQj+7OBkOirDiIdGicf9AkWNp5R6HJ5Gh4QaolFFgBM=;
 b=NSqZOvHcKTUi/szgBk/6fYVfyTFCTrZ5ABzlsfm4+P5Cy6xt61ghKznPDopW551kBxLcllmx4IUxv8JxukcFHCFxpkCp9Hz9y9hwtYnxDh6ltE7Rw+0ZFaADpM2ky49MTHydgkU9XNGLdbZzKlfB/zMlu7ifuFK1eWGPct6DOwk=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4201.namprd15.prod.outlook.com (2603:10b6:a03:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Sat, 16 Jan
 2021 01:12:48 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.010; Sat, 16 Jan 2021
 01:12:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     KP Singh <kpsingh@kernel.org>, Martin Lau <kafai@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
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
Thread-Index: AQHW5hbxN1bu8adE10+5MJhm5YS4VaoiytsAgAAsZICAAAZZAIAAHdAAgAEZZgCAAAXQAIAFJyaAgAAWvQCAAAS3gA==
Date:   Sat, 16 Jan 2021 01:12:48 +0000
Message-ID: <75A2A254-4D51-41F0-9B01-ED2AFA745E03@fb.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
 <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
 <CACYkzJ4mQrx1=owwrgBtu1Nvy9t0W4qP4=dthEutKpWPHxHrBw@mail.gmail.com>
 <20210111215820.t4z4g4cv66j7piio@kafai-mbp.dhcp.thefacebook.com>
 <9FF8CA8D-2D52-4120-99A5-86A68704BF4C@fb.com>
 <e4002f5c-6c2c-0945-9324-a8dc51125018@fb.com>
 <CACYkzJ64h53iZq9EpL01NukB6Rh+rQ0fupdn+shn-dTQ8NWH=A@mail.gmail.com>
 <A0F77AB9-5C1D-4657-96C9-33B5FDF6DF00@fb.com>
 <72a52715-dcfc-dc0b-ac5b-e14b7540fd31@fb.com>
In-Reply-To: <72a52715-dcfc-dc0b-ac5b-e14b7540fd31@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
x-originating-ip: [2620:10d:c090:400::5:1591]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 035a95ed-8bd3-4df7-8bad-08d8b9bbd6d3
x-ms-traffictypediagnostic: SJ0PR15MB4201:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB420150918DFDF781B01DD8A3B3A60@SJ0PR15MB4201.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3msPo/YCTKggtX4Ngn8O4xu1uZEkfkGWMpIWmMHzHSRin7xkDj4+FenWWIKAvI2J9ENwlaFeKQi5jrIIjjMAYsOYxbBwf++Nv94DD+fS1iC2lA8FGylauBsf0JJR7lFlLH5LW69BvKHzSzDomJ0oC6H/V/Z70kdUawOjfLbGgf34wSFVR48UJ7cbVao/MWMyg0DRLKVLIW0tZcVqoqXxISnYpqn670AWJeGFwLbyNe8fWj+Dyg5/Vrv20ZZ/i12LyvEwVxN+li6K3rCIfQO1go4EbrV/g1VIhKi+0y72J2AgYRnQzJhBsX54UXdL7rnKW3lfKLG0Fhr72l7U5qkJVL+qVZ/9KQYn58Do8LNpGyMIZAZFVb5bwKTvpB1DDIpjSli+V6dFl7LJ8e8HJFbqSeYAwmrlcLI11M/G4hSj/OBmauy6+KfuSWDrDdag04F2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(396003)(376002)(39860400002)(2616005)(36756003)(37006003)(86362001)(83380400001)(5660300002)(53546011)(54906003)(6486002)(7416002)(478600001)(64756008)(91956017)(76116006)(71200400001)(2906002)(66556008)(66946007)(66446008)(6512007)(66476007)(6862004)(8936002)(6506007)(186003)(4326008)(316002)(6636002)(8676002)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aJl6Wns3VoLwbhOWgfeIKf6+8agTzeMuPTi9BY5CrNhJ6WTk2Y6fxcfBwtBL?=
 =?us-ascii?Q?qZtMQa7vhVp2SilIX/pXmg4bDEsyt1F7tNhABB/boja+OeiiHf6hUO6QlsYn?=
 =?us-ascii?Q?JTVn3YK25WVb0oY6iGb4l7PYtBHVOlDIKDLzTf6eIWhXdwc2FqPifPtrwGrD?=
 =?us-ascii?Q?KWVNllna5O1GNyxtu2OQ5x+2xfl/7APRMKW4RlRJIZTIpHExkISeJpQi9Mg9?=
 =?us-ascii?Q?Lyj9qwDRPSolw9CbpHkCpmMKPVkt343cx14Q5SUujOh19UAuIsdVmKH5KZFt?=
 =?us-ascii?Q?rWVqlMjIwrv4rMSQVg9E8T1JmvN5pa7UY0BFdtQ5v55gfe2ByZwzMFzIOpgE?=
 =?us-ascii?Q?pYe7qX7It+fmNsNBta+r6sl/PnGP6AFKvxJa7zKbhvwohd916/UNOiW/jhJ7?=
 =?us-ascii?Q?PS0QRTCaXiHnZ92TjWnayiBEtyMTl8TPHIQPeaxu5/2PaIRk7MAv5PvJNgfb?=
 =?us-ascii?Q?rzHdsTkHTVhI2rgZ9PtIzN0JcSiM2Rl/M8lByyYAfqhoLM+327RHlnlPKEVB?=
 =?us-ascii?Q?WvV4jmTnd72/1o0srIq8ArPCLCloSBkZlLP/pEoRYRgarArsaFTcdX6k0acW?=
 =?us-ascii?Q?VMGWwEXaOsrt+rMQ2EABDE7XharDKZyvI+g0xXbFoI5KjBF42EMuMSU1sfky?=
 =?us-ascii?Q?wmnKOCZhwsl+FlA4VgtuopBDiRso3PtGy8Vb2zniE92pKRL7CHlgycpMHbiZ?=
 =?us-ascii?Q?0MuAHXlzdjmwlktq2c0BblPNIK2o4OMUMmhsgGQqm5xZwhK44nu8bwfnvTOj?=
 =?us-ascii?Q?Ho3NbtZkUCETJv329jvH3xZbNOGhW+BGL9I/aI25zEc8pY4cu+y9R+yFht+D?=
 =?us-ascii?Q?VZKfwY2WyqJsiICBBYX4uMiJ8c/U6szlTg03JMiwb6b7IHiK4qrh5fgq83zE?=
 =?us-ascii?Q?EaPjlUTfUQZiwTL0VKux8v/qN3uxGv1SQnUpe8UXjUCja3TembPoxGRJDTXC?=
 =?us-ascii?Q?01z0cgsoK9hOZsfnQ1Kb/Gcm8+hmEBn00DuJ7c5PDYZUVQAbaGF72Y108Ow8?=
 =?us-ascii?Q?gMDkiw9oCfruXh/qg1o1elPsk1+PS0gSQNJneXQZPltYjdY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6577A71127B8014BB0BB27E577F5BB31@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 035a95ed-8bd3-4df7-8bad-08d8b9bbd6d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2021 01:12:48.5577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /psgwcpTjnyz1gCGr1O0gxVFsKSTbhfe/5PGYzhk/itPkxD5UlPkmp0/C4WsnD7YlXAVCa3HVodGwk0u9KWAag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4201
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_15:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101160007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 15, 2021, at 4:55 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 1/15/21 3:34 PM, Song Liu wrote:
>>> On Jan 12, 2021, at 8:53 AM, KP Singh <kpsingh@kernel.org> wrote:
>>>=20
>>> On Tue, Jan 12, 2021 at 5:32 PM Yonghong Song <yhs@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>> On 1/11/21 3:45 PM, Song Liu wrote:
>>>>>=20
>>>>>=20
>>>>>> On Jan 11, 2021, at 1:58 PM, Martin Lau <kafai@fb.com> wrote:
>>>>>>=20
>>>>>> On Mon, Jan 11, 2021 at 10:35:43PM +0100, KP Singh wrote:
>>>>>>> On Mon, Jan 11, 2021 at 7:57 PM Martin KaFai Lau <kafai@fb.com> wro=
te:
>>>>>>>>=20
>>>>>>>> On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
>>>>>>>>=20
>>>>>>>> [ ... ]
>>>>>>>>=20
>>>>>>>>> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_loca=
l_storage.c
>>>>>>>>> index dd5aedee99e73..9bd47ad2b26f1 100644
>>>>>>>>> --- a/kernel/bpf/bpf_local_storage.c
>>>>>>>>> +++ b/kernel/bpf/bpf_local_storage.c
>>>=20
>>> [...]
>>>=20
>>>>>>>>> +#include <linux/bpf.h>
>>>>>>>>>=20
>>>>>>>>> #include <asm/pgalloc.h>
>>>>>>>>> #include <linux/uaccess.h>
>>>>>>>>> @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *ts=
k)
>>>>>>>>>      cgroup_free(tsk);
>>>>>>>>>      task_numa_free(tsk, true);
>>>>>>>>>      security_task_free(tsk);
>>>>>>>>> +     bpf_task_storage_free(tsk);
>>>>>>>>>      exit_creds(tsk);
>>>>>>>> If exit_creds() is traced by a bpf and this bpf is doing
>>>>>>>> bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
>>>>>>>> new task storage will be created after bpf_task_storage_free().
>>>>>>>>=20
>>>>>>>> I recalled there was an earlier discussion with KP and KP mentione=
d
>>>>>>>> BPF_LSM will not be called with a task that is going away.
>>>>>>>> It seems enabling bpf task storage in bpf tracing will break
>>>>>>>> this assumption and needs to be addressed?
>>>>>>>=20
>>>>>>> For tracing programs, I think we will need an allow list where
>>>>>>> task local storage can be used.
>>>>>> Instead of whitelist, can refcount_inc_not_zero(&tsk->usage) be used=
?
>>>>>=20
>>>>> I think we can put refcount_inc_not_zero() in bpf_task_storage_get, l=
ike:
>>>>>=20
>>>>> diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_stor=
age.c
>>>>> index f654b56907b69..93d01b0a010e6 100644
>>>>> --- i/kernel/bpf/bpf_task_storage.c
>>>>> +++ w/kernel/bpf/bpf_task_storage.c
>>>>> @@ -216,6 +216,9 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *=
, map, struct task_struct *,
>>>>>          * by an RCU read-side critical section.
>>>>>          */
>>>>>         if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
>>>>> +               if (!refcount_inc_not_zero(&task->usage))
>>>>> +                       return -EBUSY;
>>>>> +
>>>>>                 sdata =3D bpf_local_storage_update(
>>>>>                         task, (struct bpf_local_storage_map *)map, va=
lue,
>>>>>                         BPF_NOEXIST);
>>>>>=20
>>>>> But where shall we add the refcount_dec()? IIUC, we cannot add it to
>>>>> __put_task_struct().
>>>>=20
>>>> Maybe put_task_struct()?
>>>=20
>>> Yeah, something like, or if you find a more elegant alternative :)
>>>=20
>>> --- a/include/linux/sched/task.h
>>> +++ b/include/linux/sched/task.h
>>> @@ -107,13 +107,20 @@ extern void __put_task_struct(struct task_struct =
*t);
>>>=20
>>> static inline void put_task_struct(struct task_struct *t)
>>> {
>>> -       if (refcount_dec_and_test(&t->usage))
>>> +
>>> +       if (rcu_access_pointer(t->bpf_storage)) {
>>> +               if (refcount_sub_and_test(2, &t->usage))
>>> +                       __put_task_struct(t);
>>> +       } else if (refcount_dec_and_test(&t->usage))
>>>                __put_task_struct(t);
>>> }
>>>=20
>>> static inline void put_task_struct_many(struct task_struct *t, int nr)
>>> {
>>> -       if (refcount_sub_and_test(nr, &t->usage))
>>> +       if (rcu_access_pointer(t->bpf_storage)) {
>>> +               if (refcount_sub_and_test(nr + 1, &t->usage))
>>> +                       __put_task_struct(t);
>>> +       } else if (refcount_sub_and_test(nr, &t->usage))
>>>                __put_task_struct(t);
>>> }
>> It is not ideal to leak bpf_storage here. How about we only add the
>> following:
>> diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storage=
.c
>> index f654b56907b69..2811b9fc47233 100644
>> --- i/kernel/bpf/bpf_task_storage.c
>> +++ w/kernel/bpf/bpf_task_storage.c
>> @@ -216,6 +216,10 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, =
map, struct task_struct *,
>>          * by an RCU read-side critical section.
>>          */
>>         if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
>> +               /* the task_struct is being freed, fail over*/
>> +               if (!refcount_read(&task->usage))
>> +                       return -EBUSY;
>=20
> This may not work? Even we check here and task->usage is not 0, it could =
still become 0 immediately after the above refcount_read, right?

We call bpf_task_storage_get() with "task" that has valid BTF, so "task"
should not go away during the BPF program? Whatever mechanism that=20
triggers the BPF program should either hold a reference to task (usage > 0)
or be the only one owning it (usage =3D=3D 0, in __put_task_struct). Did I =
miss
anything?

Thanks,
Song

>=20
>> +
>>                 sdata =3D bpf_local_storage_update(
>>                         task, (struct bpf_local_storage_map *)map, value=
,
>>                         BPF_NOEXIST);
>>>=20
>>>=20
>>> I may be missing something but shouldn't bpf_storage be an __rcu
>>> member like we have for sk_bpf_storage?
>> Good catch! I will fix this in v2.
>> Thanks,
>> Song

