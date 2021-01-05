Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5042EB3AF
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731009AbhAETwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:52:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54982 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbhAETwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:52:07 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105JmLaN020148;
        Tue, 5 Jan 2021 11:51:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=W6GgQPY/rCfwnQU377ZIPnTrvP1K6RpAqESL6Bhk8EE=;
 b=aC8NzIPgBHIlXSgP1UqF1ZWnUY3dnePm6nTIaCAwikhfhR3YQBWMj4jVTOGre4plyHOt
 twMzg8D+VFPIGpGxy03gi0b+Gq755V3/U5FfVj2qTwHYqcVawctYi3+VBPjsImdnCBpd
 RNbKdkMO+UEE2oLHXZ8UmsWMWITW+a5vBVA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35u9rck79j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 Jan 2021 11:51:11 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 11:51:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xz3KKiHNQGqoVgq24mXDVHiyZxE8t4VYkZ3dnMntRAS5ppLBewP0HCVfcJrecA5+ruJTQE9uOwm4wIyUe98zF31FKV3TBC2dPOpxy3UbcFs0Skt5aCruAPyOHhfYnRAovohcUr6KEIMSH3uKt3tItriayK2IAbuK+Z0HyK0+kcjcatbvkvKgd7JduMARFr/0WIUmFbg/eWzJ2Zz3SIzEwP1W0/kO3pCzN4JCgKmiw2AO4gaHXnXdsBXCslUkRTbFjU0uRTnUeJwDqyErU0ZqNJp9iovrey634K8khsfFJ826UD+8TdAxJcAVOnW2zAHq8gjr5mDNYBJWCpULy1lldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6GgQPY/rCfwnQU377ZIPnTrvP1K6RpAqESL6Bhk8EE=;
 b=VbpZMtXf8e7f0nyrAjDSyx23Xf1Jx7vJoNjVTk5+R9+VV70lakLvE7Frzug7fRTw4ymwapkdbSGsNGmwOGIlakdWbQJdIg1iLEVn8mu4OsyBZjIS+OSYs/U/fl+jN3Ykc7UpKc16XUbQpwsQ4K76sgSK8Z70G/49t311BVGUPx9OCBHGxB8svGhH2S88A06ADxmKdLs8HIQ6LV2VfY9Cw67fbpu12drbTd3sHEvUoKzs5G38D8dwI3FthFw0i3KoQEWzp9SD1qO1bCzIh90Ifg+Ipny6DnIDh/fOUZHanpqcSgc/HFKFX5QEeWCERP92pBJQeNYAQCHlIpYOu8mggg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6GgQPY/rCfwnQU377ZIPnTrvP1K6RpAqESL6Bhk8EE=;
 b=ZoTUvcwbowYWcwmIFPJdQoP63bsrDYJ5ksXTvM7BL+4CGVdJMlMrhnhhiNS4zj4TAGVgSl9W5Ppa8tL92hPzxTa79hEHVpnBPwc/BJBnripeP5A+T+336ErX08eGiIfuox1zSpYQPbcnooXf49X2esdWCxiK79TiDN29s7RYSq4=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2838.namprd15.prod.outlook.com (2603:10b6:a03:b4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 5 Jan
 2021 19:51:07 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 19:51:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW0zs42cd9AcJBNEyi77fZmX7Jx6n7qAwAgAAzywCAAEpiAIAAIRcAgAAOLwCAALyEgIAADIEAgBtELICAAENfgIAAsrMAgAAMPQCAAASzgIAAJGyAgAACPgCAAAFjAA==
Date:   Tue, 5 Jan 2021 19:51:07 +0000
Message-ID: <5664BDD1-D1BB-4596-ADE9-5AC7ED531CD4@fb.com>
References: <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
 <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
 <231d0521-62a7-427b-5351-359092e73dde@fb.com>
 <09DA43B9-0F6F-45C1-A60D-12E61493C71F@fb.com>
 <20210105014625.krtz3uzqtfu4y7m5@ast-mbp>
 <6E122A14-0F77-46F9-8891-EDF4DB494E37@fb.com>
 <CAADnVQJ5eKCnkoUV-K-S80-0CGLNstNw50OX2tndLM+Or+CSHQ@mail.gmail.com>
 <EB23A240-8A1B-468B-86C8-CF372FE745C5@fb.com>
 <CAADnVQLg-kQ9Neva0DvUW8CMiuNhv0HTHdsV5fgV8+ra98wE5w@mail.gmail.com>
 <48243EAC-D280-4A89-BA72-68E529B6E6FD@fb.com>
 <20210105194608.nywfcrsxsk3n7y7q@ast-mbp>
In-Reply-To: <20210105194608.nywfcrsxsk3n7y7q@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:4dc5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e19d9f4-0124-49c3-3c71-08d8b1b33e23
x-ms-traffictypediagnostic: BYAPR15MB2838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2838C87FBCAA2A0D4661B300B3D10@BYAPR15MB2838.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FUoNouMuKMxrpYILW0b9mWQJc+JlSHF2/lhUCTKtSmdhmVdcQ5X1UZODvxRcEY2jilyrdyFVC1UbvBQrvzcr8u2NFNzjxE/Bxxx8AMTpz2gd+IIwAtZQrUOIgZ1r2fp5/dUKYI47AqoVD6zgQAeyO0ItUUtbHDCxDbHoQWC6ybUrGRl7W+hhyEMjYGX7j0U/jD26R3d1sB8MwPKQaaaICMgNsWRT0kAgLUcboWE1Fe0g1lYMF+yj1JbVadv8A6kAfvXeE3BFPoyOLLHmSEGf4T0yLU87jbzkXec8GmorbXXH5yPhgJwZL+BAD6BK5FATkcP5fYfzz9CwZEnafb8TwKVtRaH298YTrQQkzDoKh/m0xzDEBr3o14aFaQqIPHrrvWGRF+b3ij6ozyTWlw8bDNQB6pqnnt1u/elkgSscVDTFFVpGkTlSYrnN0+eBeqWY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(366004)(376002)(64756008)(66476007)(478600001)(76116006)(91956017)(66446008)(186003)(71200400001)(66946007)(66556008)(316002)(83380400001)(33656002)(86362001)(36756003)(6486002)(54906003)(53546011)(8936002)(2906002)(6506007)(4326008)(8676002)(5660300002)(2616005)(6916009)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yXQkW0EJTjh17bFcLx9F3kq0a4QGic0FrYHuAGmlS6darmtEArinsWQt7QhU?=
 =?us-ascii?Q?rO/V74obDLBj4SuxEQGGzPMPzmu723MtKb0VltmOYy2jUjh0mylbqRp+K4zy?=
 =?us-ascii?Q?UTjyW37MCJy5PqJWmiLFJj6bNGSCePLom3+u92IZp9Jp3BCR6LTvQx3oYMQn?=
 =?us-ascii?Q?JvntiFfxN2+KuFcFwHvLm6fek11yXpHok3sbNTCs9A03PJux64gtP8EoCyc1?=
 =?us-ascii?Q?TyBc9Wd9329iPYZlVJS+WOzgKufmiSRIXoiyjtWxk8hzKFboAdfIMuyEzoQM?=
 =?us-ascii?Q?13na3JE3+WdodioOmVnsbqtTtQ0iiHuP7NaEGxymg9WiTnSEX7tgwfUZr6S+?=
 =?us-ascii?Q?yElOXXRi8v6ihwCZ6FO04jeAsAuMPlWZr804OYl5H1Qc5rx0/+3efKog6Z9n?=
 =?us-ascii?Q?GeuIFQhgAVMYFgNV5/8qDmWe0Tysth5Q+No8annb0swG3j0L6vRo7ctK4ktk?=
 =?us-ascii?Q?mUIcQP7s/pOfSI61+Bo0DSCljhOqHGnudX0nbPUQ9C1IiLM4buwcPV1xIlM0?=
 =?us-ascii?Q?Q3eRJEQ7aKlBE7OdNnarLnhAd+Wicl4c1StlSxTve1/u3hm4iqtPAZ5q5zD8?=
 =?us-ascii?Q?Eezh/QxxaHs6ltr70rc8DAGVT6u5AdscBTD46Lu/Kusdt/Krj2Qx9teBPwUS?=
 =?us-ascii?Q?zcoEpj6/84cHbYumbagcwvYZ9qsSSQ+bcO04KVHxjZLRLzFUrhfkyEd/I7tx?=
 =?us-ascii?Q?DsHGfWjO3Uxu+xVwVW8kxrCCRPnp/6HQxuQISIHj0MKSuWBE54km7NAd01f3?=
 =?us-ascii?Q?FjPdpR6UNAX0rpEL0FEwnX5/p9f9VOmEbF05+6/C9a3Wve6E+lpAmUcLYP+i?=
 =?us-ascii?Q?cH3QMAAr58G1tXuuUMfFOQkrd/JzXDcO2s+UrUc89Havl1n2nBlkCUoWga1Y?=
 =?us-ascii?Q?tpuUmrDm+cKmDgpJWXvxe5jVf6j/9j0iY85DwR8Thu1UTdAFMVAvfVvPeRdE?=
 =?us-ascii?Q?xmZluUEGn9s3hn21Jys8tVv2QJ4e5HIX8VQvlrUNV0mG6CLGvfeYf5zS9qiw?=
 =?us-ascii?Q?XUzcKmld/H4SfjsgZUHXTy9m0KtBbsuC+cdRABbaFE+rHVM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E476B768DF66442B269877067D5B330@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e19d9f4-0124-49c3-3c71-08d8b1b33e23
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 19:51:07.1025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GO6y+znWs8vDDHsbzOLfkyorondErt/AmpIlpJOKmWX5sUE/DBuoWTi09ywxc21xpOTgkZ7eIy2gMNGh9Y9XTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_06:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=959 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 5, 2021, at 11:46 AM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Tue, Jan 05, 2021 at 07:38:08PM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Jan 5, 2021, at 9:27 AM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>>>=20
>>> On Tue, Jan 5, 2021 at 9:11 AM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Jan 5, 2021, at 8:27 AM, Alexei Starovoitov <alexei.starovoitov@gm=
ail.com> wrote:
>>>>>=20
>>>>> On Mon, Jan 4, 2021 at 9:47 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>>> On Jan 4, 2021, at 5:46 PM, Alexei Starovoitov <alexei.starovoitov@=
gmail.com> wrote:
>>>>>>>=20
>>>>>>> On Fri, Dec 18, 2020 at 05:23:25PM +0000, Song Liu wrote:
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>> On Dec 18, 2020, at 8:38 AM, Yonghong Song <yhs@fb.com> wrote:
>>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>>=20
>>>>>>>>> On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
>>>>>>>>>> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com>=
 wrote:
>>>>>>>>>>>>=20
>>>>>>>>>>>> ahh. I missed that. Makes sense.
>>>>>>>>>>>> vm_file needs to be accurate, but vm_area_struct should be acc=
essed as ptr_to_btf_id.
>>>>>>>>>>>=20
>>>>>>>>>>> Passing pointer of vm_area_struct into BPF will be tricky. For =
example, shall we
>>>>>>>>>>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id=
 the verifier will
>>>>>>>>>>> allow access of vma->vm_file as a valid pointer to struct file.=
 However, since the
>>>>>>>>>>> vma might be freed, vma->vm_file could point to random data.
>>>>>>>>>> I don't think so. The proposed patch will do get_file() on it.
>>>>>>>>>> There is actually no need to assign it into a different variable=
.
>>>>>>>>>> Accessing it via vma->vm_file is safe and cleaner.
>>>>>>>>>=20
>>>>>>>>> I did not check the code but do you have scenarios where vma is f=
reed but old vma->vm_file is not freed due to reference counting, but
>>>>>>>>> freed vma area is reused so vma->vm_file could be garbage?
>>>>>>>>=20
>>>>>>>> AFAIK, once we unlock mmap_sem, the vma could be freed and reused.=
 I guess ptr_to_btf_id
>>>>>>>> or probe_read would not help with this?
>>>>>>>=20
>>>>>>> Theoretically we can hack the verifier to treat some ptr_to_btf_id =
as "less
>>>>>>> valid" than the other ptr_to_btf_id, but the user experience will n=
ot be great.
>>>>>>> Reading such bpf prog will not be obvious. I think it's better to r=
un bpf prog
>>>>>>> in mmap_lock then and let it access vma->vm_file. After prog finish=
es the iter
>>>>>>> bit can do if (mmap_lock_is_contended()) before iterating. That wil=
l deliver
>>>>>>> better performance too. Instead of task_vma_seq_get_next() doing
>>>>>>> mmap_lock/unlock at every vma. No need for get_file() either. And n=
o
>>>>>>> __vm_area_struct exposure.
>>>>>>=20
>>>>>> I think there might be concern calling BPF program with mmap_lock, e=
specially that
>>>>>> the program is sleepable (for bpf_d_path). It shouldn't be a problem=
 for common
>>>>>> cases, but I am not 100% sure for corner cases (many instructions in=
 BPF + sleep).
>>>>>> Current version is designed to be very safe for the workload, which =
might be too
>>>>>> conservative.
>>>>>=20
>>>>> I know and I agree with all that, but how do you propose to fix the
>>>>> vm_file concern
>>>>> without holding the lock while prog is running? I couldn't come up wi=
th a way.
>>>>=20
>>>> I guess the gap here is that I don't see why __vm_area_struct exposure=
 is an issue.
>>>> It is similar to __sk_buff, and simpler (though we had more reasons to=
 introduce
>>>> __sk_buff back when there wasn't BTF).
>>>>=20
>>>> If we can accept __vm_area_struct, current version should work, as it =
doesn't have
>>>> problem with vm_file
>>>=20
>>> True. The problem with __vm_area_struct is that it is a hard coded
>>> uapi with little to none
>>> extensibility. In this form vma iterator is not really useful beyond
>>> the example in selftest.
>>=20
>> With __vm_area_struct, we can still probe_read the page table, so we can=
=20
>> cover more use cases than the selftest. But I agree that it is not as
>> extensible as feeding real vm_area_struct with BTF to the BPF program.=20
>=20
> Another confusing thing with __vm_area_struct is vm_flags field.
> It's copied directly. As __vm_area_struct->flags this field is uapi field=
,
> but its contents are kernel internal. We avoided such corner cases in the=
 past.
> When flags field is copied into uapi the kernel internal flags are encode=
d
> and exposed as separate uapi flags. That was the case with
> BPF_TCP_* flags. If we have to do this with vm_flags (VM_EXEC, etc) that
> might kill the patchset due to abi concerns.

This makes sense. It shouldn't be uapi without extra encoding.=20

Song

