Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E562F8971
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbhAOXfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:35:48 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38072 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbhAOXfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 18:35:46 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10FNUl7k014776;
        Fri, 15 Jan 2021 15:34:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7zwkgLfG+Ua7+u5cbBr7ECDabuZpRzZnreWlagwgg+c=;
 b=rHZUqxS/ussCjRY6rOj+6JZ6ZqNTvuHErO80GxY543sePQ3gDR3miCBOXpY/i2Dvjlau
 Twyoq8Ak4w8VRI1K+OwWanU/6HvqsiwqvShxtO6Su2Cn6BGIWyPuUX8lSeIanhLGYJs5
 iJ9EDyJJIHKHkeWxPxaPD5b9dSyo87ej+M0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 363g1gsg2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 15 Jan 2021 15:34:39 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 15:34:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFs7VXRuMO/YjzNMrn7R/KjktxUMVZjZ5Hgwv1Uu8nNps/tSHBo/9UzZ1EUH3gjH+y5SkWTDpZIXMuZKu4HOioBGRGhKq6i4Uu7ZGwgOtN8EHl9/SU25mBfxlVG0+vBC1ayuq0uAd9fkBtsXM6pyEOvPOoJ0dMHjrE2Zsqp9SeTgRNO61uuF90WgPM6im9ibcc/zGw0lFm3VUqDboM1VX8Y3PLxUYNhPXgmNKhW7dYniln/LxtWjaCZ19rk2ekG208bOhkZAyJgcyFQDFZyeahijVfEjqZLmmhSucBavUzoSuYA27wAO0kuIRM9Vrm45PQXCnIjNP4VPJESt2ca42Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zwkgLfG+Ua7+u5cbBr7ECDabuZpRzZnreWlagwgg+c=;
 b=PZrBCqCktwvjP+Rwgs9VJpe1iK0EXaXTcrvjHuMLXDxygaWMpgqKfpA+gYxO75VuJH1MHyOIevNHOVAPJh29WlGOLkNb8bHdaRgHKHKfCAZgj3/VillS2u/TTQc9XE9O3Qny0h2UJ/zpXDs4vvDctVySkZjDILKVu16vAblLUp+BV1dkKI2uxZqGgnqcq/RNAOKDcI3C7Op22R9ZzTkjmH9i8QUNnyFFrrU/Wnx8Lofy+K8fHAxLY93ve+Ey/h7OQWmlI3dsbaxFSI93Bae60eHBQhgxNpF55RSUQk8P4EwjBiu+V+nFJNmXVbhYQSNxgn/xD22KUZJP/Fy8AckS6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zwkgLfG+Ua7+u5cbBr7ECDabuZpRzZnreWlagwgg+c=;
 b=bMR0015HYfm3PnN43bp2OiyvH5rJ5BHTAteMVleRA4DAUqC0toRR6YP9S45mvJtQHcAgLr7XJ0C03HQIc13gGV0k/GmsxRseuJfthNYa4gdPRZ/lazxzSmLCKjwCL8w8MqmdGyPxVNBdp8UOuizm5gAaGQfl0xvTjmwSmsYAXl8=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3192.namprd15.prod.outlook.com (2603:10b6:a03:10f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 23:34:34 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.010; Fri, 15 Jan 2021
 23:34:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     KP Singh <kpsingh@kernel.org>
CC:     Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>,
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
Thread-Index: AQHW5hbxN1bu8adE10+5MJhm5YS4VaoiytsAgAAsZICAAAZZAIAAHdAAgAEZZgCAAAXQAIAFJyaA
Date:   Fri, 15 Jan 2021 23:34:33 +0000
Message-ID: <A0F77AB9-5C1D-4657-96C9-33B5FDF6DF00@fb.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
 <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
 <CACYkzJ4mQrx1=owwrgBtu1Nvy9t0W4qP4=dthEutKpWPHxHrBw@mail.gmail.com>
 <20210111215820.t4z4g4cv66j7piio@kafai-mbp.dhcp.thefacebook.com>
 <9FF8CA8D-2D52-4120-99A5-86A68704BF4C@fb.com>
 <e4002f5c-6c2c-0945-9324-a8dc51125018@fb.com>
 <CACYkzJ64h53iZq9EpL01NukB6Rh+rQ0fupdn+shn-dTQ8NWH=A@mail.gmail.com>
In-Reply-To: <CACYkzJ64h53iZq9EpL01NukB6Rh+rQ0fupdn+shn-dTQ8NWH=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1591]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7076adfd-d700-44ba-cb9f-08d8b9ae1d77
x-ms-traffictypediagnostic: BYAPR15MB3192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB31926F685E8D0E533F2A1839B3A70@BYAPR15MB3192.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a7ZcMMOSRX5r7H/8Zyw9Lz1nlgomKXYF4PR9dkSERmr4r40dyMRuK3oXFiL+81HhbdjNeCho+rYGSb4G3n92Z1brspc9Q6tu3buNvyl88vWDkWalGDLdpl3g4bs936Sp9OZbMli7D6KlrWYndWZLrnpQAqAEuG7tVeHytrRNBD8Q7DcsnBfjsi+UFp5VagQI3xxzYKdzdc3h3T2W6ow9cjjM/regNxLfhqKKeC2OawpBMbtm+YbNBFXNOrPy5YFFG1UMA2eBE3Ehpqkf4grHGP6iBdg700QP5XbiDFPfqFLu74fzZI9YYzqzuZUKtHkHbSnkavhODbzSIjhf5LrBmix2fgpctM6RjPXpoJF24kD66KZe8ZLqkYqyb7Pr3nKHIIjqG172HGLgSvnHbqW+/ob8t+6fBOSEejTH4yQ3u1HcSUXgDaft462khwLggEmk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(39860400002)(136003)(396003)(83380400001)(36756003)(6916009)(5660300002)(54906003)(2906002)(2616005)(66446008)(4326008)(316002)(66556008)(7416002)(86362001)(6486002)(8936002)(66946007)(76116006)(53546011)(6512007)(6506007)(33656002)(71200400001)(8676002)(91956017)(186003)(64756008)(66476007)(478600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9SPfXpTcgXMfsxom/EAdAH8ks9XsZV3k0AMQqzcsDC3JSnkCejtUpBRVUtCQ?=
 =?us-ascii?Q?wkqpr7E4x5HtgZaGfIn4oqw6K4oJsQNSIq/AZ2cw9tfnHAirf6Gzrn2cGHZH?=
 =?us-ascii?Q?k/q8z4JBd7DQkMipfbzMjy4JSQcPRyAPv3c4xwGwQqlKwqdwbMp2zOV9tjT0?=
 =?us-ascii?Q?tVQgK7/XaKJnGqcqzkEn20L23Nq2ZnQNiG4uVynwybErjHi7vE085fCvSaxt?=
 =?us-ascii?Q?RfDeiPaFojAosGlfWONYVp6vyyV3Z0iqGpN2AnvX0qJ3lqrWroEL4nA8irtt?=
 =?us-ascii?Q?LQtJfZPZIEJblOMSyDcxJdszhpifUcGcL37wZe7IZoGtQA0Qdv6vcMClMC83?=
 =?us-ascii?Q?TGjDq7rR3wWdnpGQvEagR/Cr7Fc35NPTLGnrJwYq5LPeLQzqbg1J8cPxmvCX?=
 =?us-ascii?Q?n78TkxsJSfR+tGTzat758HbwG/MYZtsFEkrnKBdvRVKmHqC8NLqk1WkLVtkB?=
 =?us-ascii?Q?HpsaB27NZCmBLwk+0F9sRqDRByEQqMlE2wZy7FUmfI01FEqt3bzMZ1ARZAOe?=
 =?us-ascii?Q?hZs4DNpyL736fhs2oGY4CvnEliaZ+T4Pivd+yIZ6Fkys75lvPlAkt1XFi5Ux?=
 =?us-ascii?Q?mA0/l0Y2WloOQelcsAt5izYJt+j3LWtzefiQ46VKrSZ5dTBjmFFcIioHqwWF?=
 =?us-ascii?Q?5oZGYh3nn5o93hPuKcudG9MBiWsBM1jJ7yOAAot7jODA2NolL10WneG4C3uJ?=
 =?us-ascii?Q?TfbInFUUDQtFHxexbdkhsxMLPR9bmZdhLYwwChLPEOstYoyWHpbcXuR+mKHc?=
 =?us-ascii?Q?A2Uh/AIAWr86e7M5SEdlc2e+ePxo9dWGIO3KZjTxgC/zcnwQet8qH9ZhiYYO?=
 =?us-ascii?Q?YXzttSpCJU/BUgz4HwtgpxheF4yoYjWoKCJiFaZwQkur3UCuT/N6N6Jv5iuu?=
 =?us-ascii?Q?pVTcTATh8O/lor1X9397W4bMYkAvsTzssXfFwWjHB0tNDlySqHJWcgY4MAgF?=
 =?us-ascii?Q?A0KHU+Zxeb9qZbUR9Uww5Y+3IDvnQLFYyDf34JDTbdv2klH8SUiGrRefhnpB?=
 =?us-ascii?Q?yXIJZmz36zwVXH50P5g0reHVqRTAmJgGOa8Xb+AQyr4mGfw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9B2FE0A24EAE0441BFE96B83A6BDB581@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7076adfd-d700-44ba-cb9f-08d8b9ae1d77
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 23:34:34.1364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rvUhDnNXS9Ofzl4+AtuMPFd9T5Iyub+1iMM/K7ins83VbLv/ufg54aLzNsw4iOTQ5/MqDPJBwwIyphI+2wmMMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_15:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 impostorscore=0 clxscore=1015 phishscore=0
 suspectscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 12, 2021, at 8:53 AM, KP Singh <kpsingh@kernel.org> wrote:
>=20
> On Tue, Jan 12, 2021 at 5:32 PM Yonghong Song <yhs@fb.com> wrote:
>>=20
>>=20
>>=20
>> On 1/11/21 3:45 PM, Song Liu wrote:
>>>=20
>>>=20
>>>> On Jan 11, 2021, at 1:58 PM, Martin Lau <kafai@fb.com> wrote:
>>>>=20
>>>> On Mon, Jan 11, 2021 at 10:35:43PM +0100, KP Singh wrote:
>>>>> On Mon, Jan 11, 2021 at 7:57 PM Martin KaFai Lau <kafai@fb.com> wrote=
:
>>>>>>=20
>>>>>> On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
>>>>>>=20
>>>>>> [ ... ]
>>>>>>=20
>>>>>>> diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_=
storage.c
>>>>>>> index dd5aedee99e73..9bd47ad2b26f1 100644
>>>>>>> --- a/kernel/bpf/bpf_local_storage.c
>>>>>>> +++ b/kernel/bpf/bpf_local_storage.c
>=20
> [...]
>=20
>>>>>>> +#include <linux/bpf.h>
>>>>>>>=20
>>>>>>> #include <asm/pgalloc.h>
>>>>>>> #include <linux/uaccess.h>
>>>>>>> @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
>>>>>>>      cgroup_free(tsk);
>>>>>>>      task_numa_free(tsk, true);
>>>>>>>      security_task_free(tsk);
>>>>>>> +     bpf_task_storage_free(tsk);
>>>>>>>      exit_creds(tsk);
>>>>>> If exit_creds() is traced by a bpf and this bpf is doing
>>>>>> bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
>>>>>> new task storage will be created after bpf_task_storage_free().
>>>>>>=20
>>>>>> I recalled there was an earlier discussion with KP and KP mentioned
>>>>>> BPF_LSM will not be called with a task that is going away.
>>>>>> It seems enabling bpf task storage in bpf tracing will break
>>>>>> this assumption and needs to be addressed?
>>>>>=20
>>>>> For tracing programs, I think we will need an allow list where
>>>>> task local storage can be used.
>>>> Instead of whitelist, can refcount_inc_not_zero(&tsk->usage) be used?
>>>=20
>>> I think we can put refcount_inc_not_zero() in bpf_task_storage_get, lik=
e:
>>>=20
>>> diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storag=
e.c
>>> index f654b56907b69..93d01b0a010e6 100644
>>> --- i/kernel/bpf/bpf_task_storage.c
>>> +++ w/kernel/bpf/bpf_task_storage.c
>>> @@ -216,6 +216,9 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, =
map, struct task_struct *,
>>>          * by an RCU read-side critical section.
>>>          */
>>>         if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
>>> +               if (!refcount_inc_not_zero(&task->usage))
>>> +                       return -EBUSY;
>>> +
>>>                 sdata =3D bpf_local_storage_update(
>>>                         task, (struct bpf_local_storage_map *)map, valu=
e,
>>>                         BPF_NOEXIST);
>>>=20
>>> But where shall we add the refcount_dec()? IIUC, we cannot add it to
>>> __put_task_struct().
>>=20
>> Maybe put_task_struct()?
>=20
> Yeah, something like, or if you find a more elegant alternative :)
>=20
> --- a/include/linux/sched/task.h
> +++ b/include/linux/sched/task.h
> @@ -107,13 +107,20 @@ extern void __put_task_struct(struct task_struct *t=
);
>=20
> static inline void put_task_struct(struct task_struct *t)
> {
> -       if (refcount_dec_and_test(&t->usage))
> +
> +       if (rcu_access_pointer(t->bpf_storage)) {
> +               if (refcount_sub_and_test(2, &t->usage))
> +                       __put_task_struct(t);
> +       } else if (refcount_dec_and_test(&t->usage))
>                __put_task_struct(t);
> }
>=20
> static inline void put_task_struct_many(struct task_struct *t, int nr)
> {
> -       if (refcount_sub_and_test(nr, &t->usage))
> +       if (rcu_access_pointer(t->bpf_storage)) {
> +               if (refcount_sub_and_test(nr + 1, &t->usage))
> +                       __put_task_struct(t);
> +       } else if (refcount_sub_and_test(nr, &t->usage))
>                __put_task_struct(t);
> }

It is not ideal to leak bpf_storage here. How about we only add the
following:

diff --git i/kernel/bpf/bpf_task_storage.c w/kernel/bpf/bpf_task_storage.c
index f654b56907b69..2811b9fc47233 100644
--- i/kernel/bpf/bpf_task_storage.c
+++ w/kernel/bpf/bpf_task_storage.c
@@ -216,6 +216,10 @@ BPF_CALL_4(bpf_task_storage_get, struct bpf_map *, map=
, struct task_struct *,
         * by an RCU read-side critical section.
         */
        if (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) {
+               /* the task_struct is being freed, fail over*/
+               if (!refcount_read(&task->usage))
+                       return -EBUSY;
+
                sdata =3D bpf_local_storage_update(
                        task, (struct bpf_local_storage_map *)map, value,
                        BPF_NOEXIST);

>=20
>=20
> I may be missing something but shouldn't bpf_storage be an __rcu
> member like we have for sk_bpf_storage?

Good catch! I will fix this in v2.=20

Thanks,
Song=
