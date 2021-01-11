Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491F82F2441
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405460AbhALAZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34252 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404194AbhAKXqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:46:18 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10BNb3FD011617;
        Mon, 11 Jan 2021 15:45:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=92MmxKBpPYyiL7HP9pD3bc6NhWT8Y+mEjh2HAjQVgS4=;
 b=HOP8L0ZRrW1JUjG0nhgOi1QPl14569wLdweet50+YWae7Gx2MMc+Up958uUpcQPo2RPA
 hI3PHkVUWUF7910aQ6R4yJs4ChUKX7KQyk6x0x/3gGgu/6KQg9SzZBPnR5tJ0/He8jAK
 0lthTaWjewfyUO1UObdGysFgoDaHYVN9X+0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35y91rtr1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 15:45:13 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 15:45:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnOYWz31Cu4PFN+Lh8mnKRu/oWykqa4hUAvytdxmSQd9YEBumta4u41o9ELQ7QM00C5khHzrO/BVv48MWgjH5wC71HtXV1FPlLldtL9DhhtOZIgM9jf1ELggwI1zq1cinSb/IpwJ5GbDJ21jY4VYB2dPhhqmQRF2Ve4QPKDv3MDh9ZqzVt6eQx4sz/g4Lg58Hix5gVIuyFtFKgw3IfpFiSaGnTYTyq1Y9ikOxOjCV6jFxgb0uk7fL7l21nHuDR819cgVpO33Y0O/Zi3jdFV9RZaYFVwurpyV7UtY2MVexXVr8MzfaZz20Aud9kwKIK6TcSAMafgUcPPbZJZBSnCnWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92MmxKBpPYyiL7HP9pD3bc6NhWT8Y+mEjh2HAjQVgS4=;
 b=eQoRctKMyVGqOJybI5Mo/r4HB/NNeHf6rmmmMo3UhuSTAHarWOy9LDQ8w2FTInWyOKvPdrUUZdVjJM3K/Ax0vA3r/2Uri4qC5TTBt4OoyQB83H/ibDIMUPDPBe2gqIXnGZU7+7TuJCviqS9Vz9luUR4wQ1n1It7pk7dfX93i7wEJ0jwwIwnq+adl0vH7fg8ZQYMyOlrpB2CBk8qXNRk99O2BQ5DlKMVC9E0mtyI+UAVvLhOJKXV7lTbSFb2dqcRqPL9GYSSp0vAKwR7cLVXJeSqSkel1warUZoqh1P3uq5MU3OWmIAy0Yjux516YoPLJZTjxm26oBTK0hP/SDK4NiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92MmxKBpPYyiL7HP9pD3bc6NhWT8Y+mEjh2HAjQVgS4=;
 b=hMpcACyG/S7rjC+0GwcpcoCRW4F/iSP/0ZnFY9z2Sy7HXYoQ68lrBz30+Ceobwyt1Sz3q5r/R4DUQ3GANnBZuM0I6IFBTOkcbTO54S6dsc++uYjTeh2F5zr0EF0wEQbleSxhjwwHNBEmVDYM4N+1R8MLouaVXdSuWLyY2CGRwZ0=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2840.namprd15.prod.outlook.com (2603:10b6:a03:b2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 23:45:08 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 23:45:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <Kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
Thread-Topic: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
Thread-Index: AQHW5hbxN1bu8adE10+5MJhm5YS4VaoiytsAgAAsZICAAAZZAIAAHdAA
Date:   Mon, 11 Jan 2021 23:45:08 +0000
Message-ID: <9FF8CA8D-2D52-4120-99A5-86A68704BF4C@fb.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
 <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
 <CACYkzJ4mQrx1=owwrgBtu1Nvy9t0W4qP4=dthEutKpWPHxHrBw@mail.gmail.com>
 <20210111215820.t4z4g4cv66j7piio@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210111215820.t4z4g4cv66j7piio@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
x-originating-ip: [2620:10d:c090:400::5:f14a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27fe9898-8847-47f0-d063-08d8b68aee10
x-ms-traffictypediagnostic: BYAPR15MB2840:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB28404DD0251812356B2A5E8DB3AB0@BYAPR15MB2840.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AB5au2YQ4XdrG8ONG/8BF5hQkA4bXhRQXU5dLp1KaPl5RvSWDcAKIOlx7H06b4nx5sxTOsZE36mF1APzTuQXOh/md0Qn37EiRYnS570nTc33GMSsyXzt1rsCOUPX4/vbsK6eTCWKXrXAkMuXXJjlXMkrGUH8fRTpHY9z4fwRsZ40ayG9XvAbeiTpMLTr1d2dPB1/9zFd7890WfaWuAQybqHElx4ZUBXvIjYgYCfWh3F8Fq3SC5MGUAep9mSmQRCvNGV2e4gCIy1jmhSag6Cq64xhsttV4cNt4AewUsQTESRGJ9RXC9DBR3AdQMB3dtjKZHrkoJiidMtOtbH8nfgJZXThHomT8gFvBnfoT2gmqjV/f9PcGgBIIBYRj4jT0O4Xd4/iYoPwoww5mUMFl17fjKMx48Hl9wPEncGJU96bbZZoxWTQ+tS+NQdiDnVzhcFc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(366004)(346002)(396003)(83380400001)(478600001)(91956017)(6862004)(76116006)(186003)(6636002)(86362001)(6506007)(2906002)(66946007)(53546011)(64756008)(2616005)(8676002)(37006003)(6512007)(8936002)(66446008)(33656002)(6486002)(71200400001)(36756003)(54906003)(66476007)(7416002)(5660300002)(316002)(66556008)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yXLYh3/cDVwY10f7Wv+I8mEkb98YJQ9cP9AsOWyV9MTEgC1nFtS/dlxlJSyx?=
 =?us-ascii?Q?gMEXCaV74PAySgar3adMSxAQDbGjmDv9syh6l8e1o/+P6VsXscXqOxuNl64p?=
 =?us-ascii?Q?U4inO5DoFWuFW2dL3cnx+9Ld6cnNVdbSLLA7FXNNKoWHv7IFjFaec1O/6e8Q?=
 =?us-ascii?Q?T22d6j2G0G76/CMVD21JPWq2mVYCSjKVXZxeKrKDPy8oQ/cBcayg9A9nnsYt?=
 =?us-ascii?Q?CPDzyA6f0amlbjnAxFs2D+JjMHcBGDBsOzHPw3V2pag1TF2WYNUZEVFTDS2i?=
 =?us-ascii?Q?ljCAhpaYuod5Pt8qryQKUhDrlp8BYijQQHI/tMsUU/MA1/tf/rH7kp6mMAWU?=
 =?us-ascii?Q?Gz3N+iWlpAm6EUBhnLaHkq+mYw8yHNJfLCEak6EzoYSyH4NGrlmEcUTTPmaJ?=
 =?us-ascii?Q?L7UBcGxJXHbSAzQCSZ7PWSSOUmA0sDKr7tNgyU8g00oBIpFj9JxaAiSE98Pn?=
 =?us-ascii?Q?CSqBWlf1L2HjFsS4/JVFTcuwJncYhIJmiWpc2w4HdSuo8VorpJwx5kS4u1+F?=
 =?us-ascii?Q?NYjw+AeFlA0zasUr6PpxjhJ0LYmPDwURxoDqKJhebEyVEUF8j/ZmiwPmTg1K?=
 =?us-ascii?Q?pNrE39LUbZ7T7p30OajQ8wK1/JRhsxI3NVF92VFZyl06GYUmIAmdPkaTiEyj?=
 =?us-ascii?Q?3JOCY9s5eXiTaYQyxyMeWl7C0Q8Wlh4ZTnNJn3dmBt/iywyjg2VRSFEg7Eu4?=
 =?us-ascii?Q?DIgv5gZ+1rdiLRUOVJ++BlYdR0sVKrcZLD+XRuS85eWo1QRHLl9jjI5SJwe0?=
 =?us-ascii?Q?pQgcTU4neh/C4DpXNU9i/hdkVn7furclvV9o09yN7RpThi1p/uHjrqOxT/eW?=
 =?us-ascii?Q?g1BJcgSzkSXEQflT1ec2SDOvzSetEKkirmFQWSg+OAc5uD5Pcdf5bkNPynOr?=
 =?us-ascii?Q?jYiIOVhzE+vfE0nJHA6FhS7wC9KF1jxhgW6xqQinjF/Ixm/jXlFs5k7FZdyx?=
 =?us-ascii?Q?KJu/OA2Uyb/tG+jq+txZ4KXoZyb3OSTtrIPD/NTT1bqUcbm0UWuZkkDOZpKf?=
 =?us-ascii?Q?X1YUePi5yqZ5KouCr9B1yPWGg/wcqsMTo5pTtTdHqUeAP4k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BFA576BA74F20F4F95BA05FE88566B3C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27fe9898-8847-47f0-d063-08d8b68aee10
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 23:45:08.7637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G/kO6LdDpE5oyuUObwXHW7neFgltSPNnYkvDoAQDUEf/68gfBTj8aB4bzPHvnVNoeywHPtdscWE6r6Zvn4kZIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 11, 2021, at 1:58 PM, Martin Lau <kafai@fb.com> wrote:
>=20
> On Mon, Jan 11, 2021 at 10:35:43PM +0100, KP Singh wrote:
>> On Mon, Jan 11, 2021 at 7:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>>=20
>>> On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
>>>=20
>>> [ ... ]
>>>=20
>>>> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_sto=
rage.c
>>>> index dd5aedee99e73..9bd47ad2b26f1 100644
>>>> --- a/kernel/bpf/bpf_local_storage.c
>>>> +++ b/kernel/bpf/bpf_local_storage.c
>>>> @@ -140,17 +140,18 @@ static void __bpf_selem_unlink_storage(struct bp=
f_local_storage_elem *selem)
>>>> {
>>>>      struct bpf_local_storage *local_storage;
>>>>      bool free_local_storage =3D false;
>>>> +     unsigned long flags;
>>>>=20
>>>>      if (unlikely(!selem_linked_to_storage(selem)))
>>>>              /* selem has already been unlinked from sk */
>>>>              return;
>>>>=20
>>>>      local_storage =3D rcu_dereference(selem->local_storage);
>>>> -     raw_spin_lock_bh(&local_storage->lock);
>>>> +     raw_spin_lock_irqsave(&local_storage->lock, flags);
>>> It will be useful to have a few words in commit message on this change
>>> for future reference purpose.
>>>=20
>>> Please also remove the in_irq() check from bpf_sk_storage.c
>>> to avoid confusion in the future.  It probably should
>>> be in a separate patch.
>>>=20
>>> [ ... ]
>>>=20
>>>> diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_stora=
ge.c
>>>> index 4ef1959a78f27..f654b56907b69 100644
>>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>>> index 7425b3224891d..3d65c8ebfd594 100644
>>> [ ... ]
>>>=20
>>>> --- a/kernel/fork.c
>>>> +++ b/kernel/fork.c
>>>> @@ -96,6 +96,7 @@
>>>> #include <linux/kasan.h>
>>>> #include <linux/scs.h>
>>>> #include <linux/io_uring.h>
>>>> +#include <linux/bpf.h>
>>>>=20
>>>> #include <asm/pgalloc.h>
>>>> #include <linux/uaccess.h>
>>>> @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
>>>>      cgroup_free(tsk);
>>>>      task_numa_free(tsk, true);
>>>>      security_task_free(tsk);
>>>> +     bpf_task_storage_free(tsk);
>>>>      exit_creds(tsk);
>>> If exit_creds() is traced by a bpf and this bpf is doing
>>> bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
>>> new task storage will be created after bpf_task_storage_free().
>>>=20
>>> I recalled there was an earlier discussion with KP and KP mentioned
>>> BPF_LSM will not be called with a task that is going away.
>>> It seems enabling bpf task storage in bpf tracing will break
>>> this assumption and needs to be addressed?
>>=20
>> For tracing programs, I think we will need an allow list where
>> task local storage can be used.
> Instead of whitelist, can refcount_inc_not_zero(&tsk->usage) be used?

I think we can put refcount_inc_not_zero() in bpf_task_storage_get, like:

diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storage.c
index f654b56907b69..93d01b0a010e6 100644
--- i/kernel/bpf/bpf_task_storage.c
+++ w/kernel/bpf/bpf_task_storage.c
@@ -216,6 +216,9 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, map,=
 struct task_struct *,
         * by an RCU read-side critical section.
         */
        if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
+               if (!refcount_inc_not_zero(&task->usage))
+                       return -EBUSY;
+
                sdata =3D bpf_local_storage_update(
                        task, (struct bpf_local_storage_map *)map, value,
                        BPF_NOEXIST);

But where shall we add the refcount_dec()? IIUC, we cannot add it to=20
__put_task_struct().=20

Thanks,
Song=
