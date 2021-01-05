Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64A22EA505
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 06:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbhAEFsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 00:48:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30364 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725766AbhAEFsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 00:48:37 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1055ev6v015555;
        Mon, 4 Jan 2021 21:47:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yLk0GexK0V0FQxZdUTnIFAmr0rIG5UcSsYqOwP0pgGw=;
 b=Qm1q4KPVDV2ruw7BNiTazsQxqiiOa4nu8Xws2dT3r9PLRQBs6bzYhwFaYeKOUDWYXKan
 QBJ4SAn0OEDSxxrU5WN4k46vERGssERWTOrPCMXhEU5VQ7JFmsCHwCc+hkgKQwMIThSP
 SctyaHYVs8QDbxN9DCHvirjthAtfvRUmiSo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35u9cp7mgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 04 Jan 2021 21:47:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 4 Jan 2021 21:47:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Akz/TnHyWCmyS6IdukpTpvdS9Q45fjSDQ2Rc1sXZZHFIp2Yl2DizfmgF13kmlArQaz1Z0b1e6G2oE0aNdiorVn3fI3YPDoSJgBSKuQFUyHsPHKndLnZ+RDHZydfAz1ZaS0WPuXEnIfYy4facniGbXLqdRycIq0MAC2JQP98NAf69EFS1dCeGzRlKVY5JKYIdEtzoSk5lvzrAH1SWufs1bb+zVQkOXq7OnGL3FHAvmXLtObh0weocLqgjwvvltNmovVLOkwors0rwLbk4mkazojoS5QB/9yPHi1CXOJkmsRZHZknSMQkrBpZWgrC5hOfqkyql5wsg0FqPMjmqTkZhWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLk0GexK0V0FQxZdUTnIFAmr0rIG5UcSsYqOwP0pgGw=;
 b=kSlm41epeS++XYNgWkivTurDsXr0UD246h0M+1swdinjBIYRr8Q/o/a0ber0UPy9BVWeCmShshWCA2WkhdiCYrZTEt7yQNoBAv8pnJFu5FYlV0avTRfE+iKQB+8Cqa5TutBnjHTkpNlVjSaALwDquGyBywrYqqf64jtUq3Cnp3xuYPFXxSRAwQ63xSC0LN6U9vlgEgi6GtHNXc/qM6zIrHcRA1ZEUzMGNSmn6rkeZiZL6v9GnoFOk7pn+uFliI1E0OqJGbSekp877faBUXc/vQqJ35ocoDA72+3FiPkbBIW0pkCnyNKMs04t1hKNMW7iCZGJP/1L8EJgh5QrcbwpaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLk0GexK0V0FQxZdUTnIFAmr0rIG5UcSsYqOwP0pgGw=;
 b=dxXjrtptF1g2k9PJLdjsA1jiZWmagy44nc0YtWTT5xAbFjYBGofuBVqli1RQREWGRWvfMSXWKJFqSQ9uKwoHDOMbjsEZFm6ZVjlCQSDWnXcfnINg3xG9pWIv4rPnbY855rYRcptCBHok7DsMBWr213DhXedWbBWYDvFqB+URXtE=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2246.namprd15.prod.outlook.com (2603:10b6:a02:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Tue, 5 Jan
 2021 05:47:34 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 05:47:34 +0000
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
Thread-Index: AQHW0zs42cd9AcJBNEyi77fZmX7Jx6n7qAwAgAAzywCAAEpiAIAAIRcAgAAOLwCAALyEgIAADIEAgBtELICAAENfgA==
Date:   Tue, 5 Jan 2021 05:47:34 +0000
Message-ID: <6E122A14-0F77-46F9-8891-EDF4DB494E37@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
 <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
 <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
 <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
 <231d0521-62a7-427b-5351-359092e73dde@fb.com>
 <09DA43B9-0F6F-45C1-A60D-12E61493C71F@fb.com>
 <20210105014625.krtz3uzqtfu4y7m5@ast-mbp>
In-Reply-To: <20210105014625.krtz3uzqtfu4y7m5@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:4dc5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a4d6cbb-3dc0-43bf-daf6-08d8b13d66a0
x-ms-traffictypediagnostic: BYAPR15MB2246:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB224659FE73DD8C257E2C275BB3D10@BYAPR15MB2246.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6mC96y+MzWFUQj5JyGEdzLHBHKa69rYRtoZWd5lGraWukEJQ8QYo394D/8l7aOOVvt7G0YVotvWmzxVaUwjuSz85Rb2nHJ8lhunx3UOemW3sb6mjIeMEL2mmIBW/erCn961UVKoQMv3/Oxh6h6RC01izP4NSx0ifmB9UkKWaf9Zun8ABhAmsZJpnks/Nq8mv0PoiCKSzUqKZiASYN0dFcHeeAAyuLLOIS0ay7VojatBXdDRoQIHxaeGNETTjT8nhWUqAlPooX66C+rxF6KFD/wU0nBlJxQ81CIgjC3DC6v9bJA1VDZ0rMloBoSxbyuMb43KnM53wmYSH7iZiZr7o7z+nbvW7mPOTsHE44WU12Izi28JrA5v14CE7pcW+VEtNLJNyz5Bqy52ZDjPxb8543eYSa8eT35oqxPlRq75vUNrQCvSENeWHHHR+3/JbhHcK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(186003)(53546011)(478600001)(54906003)(33656002)(6512007)(71200400001)(86362001)(4326008)(6506007)(66556008)(66446008)(64756008)(2906002)(316002)(66946007)(91956017)(66476007)(36756003)(8676002)(6916009)(2616005)(5660300002)(83380400001)(6486002)(76116006)(8936002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Aqo8Bk5QgAFB++jCo9vkVFAHhtIbTtBbTcyvEB8ks3t1yoL8uCIM0uP8ksFZ?=
 =?us-ascii?Q?dnvPaKBZJfCuAjErc3qChS8z2LrAk+DvZ5j7oPdEWGIcgNxMp4OJP+ewWLes?=
 =?us-ascii?Q?YvSDSxyKU/4leoLpx2Zd1aJWmHH5mcCY9fhMAwIeK/GMEcneuZI8qnn+Hnic?=
 =?us-ascii?Q?k/lxupVR+sw73PsheyFQDVKXI3I7ByuYh2XWOgxrglngM9gkhF5kwWnvrZXM?=
 =?us-ascii?Q?8e4B2hUxaXXTmNY7oeIUJ6n16gYP/bkS4FtZspYuohBkeavNCbT+As4h684+?=
 =?us-ascii?Q?6si1qxMneEaTPb/oFhSXX8iFG6e+lRkPefDaob6M38lM8oREVCNG5fIBA/bb?=
 =?us-ascii?Q?Ny755qN1SP/dN+3YhaRpjo23hrKllkFrvw3IgMl+cm9KPXnyta50o6LBe2VB?=
 =?us-ascii?Q?8TpKExL6aaslARBCJbMzxfHL9Ta02fHHe5ybLsprz7g7q99XmmZHfQXAtjBv?=
 =?us-ascii?Q?YnsAgrNazNWE3FGaOJjLtoNax5Rga7hnQ1gndlKUcnxjje1doUv+moINzo0D?=
 =?us-ascii?Q?E+HgT0eP10DygVVJosie7jNZXC9gNbzb6ZD1zjkosKb4TOWwy9QdeznnOom7?=
 =?us-ascii?Q?+BJC2FbQSdHmz/fBHBY5Q3pM3mwj5YI9+3uRjqex2Y2LN21o48kYAshVDf2D?=
 =?us-ascii?Q?a91zAo5G7/pwlb+svCFgmCRpZeind19gTfaOY4CDkXB6amuY5IRLf7+uHxcu?=
 =?us-ascii?Q?qdCmsNIVROirr2F5m0qml0JYI3rUsgRdBDvhQaaA09pPO/3e0I38CIcYa+v4?=
 =?us-ascii?Q?1KnFmaRqM7cQRV/waJJXi5kK5h+La3G/0+vP4A/r9M2CpzuV1RStzeM/CW0h?=
 =?us-ascii?Q?JVsxJEdpS64dkwDws0/T0+DFLW7cf5JUxbO2Bgf2QJv+YTq0Qukp7Hkhn3Vs?=
 =?us-ascii?Q?xvwpWaqO/GLkDyUYVFjvgeg+R3ndZsSB9yZeQXNlZYkRnG+Il5zkyaOOmxTP?=
 =?us-ascii?Q?1DQhXqJDMJ+DnkWt1CI9EgmVI2YxpGEGbz7ZcLsGb1v6G79J2NupRCkd9WSF?=
 =?us-ascii?Q?yLSjjUg/xkq2EbVPqvEpbz3u8ID8u8ct8fIr3IY/oNAxsWw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25AE158875720849B0808DE9FC997B5A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a4d6cbb-3dc0-43bf-daf6-08d8b13d66a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 05:47:34.4025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GoxcWlC3BlK/7R1aViGy0R3UTXBDZlvzF+Suxz0U60FTX9jeM0VPzsEQh1wkpvwc7dCgkBl8NU5bSAyIloxv3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_01:2021-01-04,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050035
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 4, 2021, at 5:46 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Fri, Dec 18, 2020 at 05:23:25PM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Dec 18, 2020, at 8:38 AM, Yonghong Song <yhs@fb.com> wrote:
>>>=20
>>>=20
>>>=20
>>> On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
>>>> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>>>=20
>>>>>> ahh. I missed that. Makes sense.
>>>>>> vm_file needs to be accurate, but vm_area_struct should be accessed =
as ptr_to_btf_id.
>>>>>=20
>>>>> Passing pointer of vm_area_struct into BPF will be tricky. For exampl=
e, shall we
>>>>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the v=
erifier will
>>>>> allow access of vma->vm_file as a valid pointer to struct file. Howev=
er, since the
>>>>> vma might be freed, vma->vm_file could point to random data.
>>>> I don't think so. The proposed patch will do get_file() on it.
>>>> There is actually no need to assign it into a different variable.
>>>> Accessing it via vma->vm_file is safe and cleaner.
>>>=20
>>> I did not check the code but do you have scenarios where vma is freed b=
ut old vma->vm_file is not freed due to reference counting, but
>>> freed vma area is reused so vma->vm_file could be garbage?
>>=20
>> AFAIK, once we unlock mmap_sem, the vma could be freed and reused. I gue=
ss ptr_to_btf_id
>> or probe_read would not help with this?
>=20
> Theoretically we can hack the verifier to treat some ptr_to_btf_id as "le=
ss
> valid" than the other ptr_to_btf_id, but the user experience will not be =
great.
> Reading such bpf prog will not be obvious. I think it's better to run bpf=
 prog
> in mmap_lock then and let it access vma->vm_file. After prog finishes the=
 iter
> bit can do if (mmap_lock_is_contended()) before iterating. That will deli=
ver
> better performance too. Instead of task_vma_seq_get_next() doing
> mmap_lock/unlock at every vma. No need for get_file() either. And no
> __vm_area_struct exposure.

I think there might be concern calling BPF program with mmap_lock, especial=
ly that=20
the program is sleepable (for bpf_d_path). It shouldn't be a problem for co=
mmon=20
cases, but I am not 100% sure for corner cases (many instructions in BPF + =
sleep).=20
Current version is designed to be very safe for the workload, which might b=
e too
conservative.=20

Thanks,
Song

