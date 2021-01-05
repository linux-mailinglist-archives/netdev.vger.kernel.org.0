Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C002EB390
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbhAETjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:39:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33948 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbhAETjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:39:20 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105JXZd8009840;
        Tue, 5 Jan 2021 11:38:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jU/uixX7AQQTiZ/+ECq/uM8mx50WP2/yOJsG6FntYm4=;
 b=RDcdCtf5LQXRuHbjslYwIPgtS95GH+PRBVN5Da4wYGOEMZOtyabZASJ/Cu95aHkVRl3i
 KvpekWdZ/Bup9Tdyu/rwF1fCnNXNsQP1B7oHx+yDPLKV/9fxt3HwuzvxGO8vXvkjrpDa
 9SWQSnnfjP0vwxLOAPKNGQ1VCNeTqqkS6jg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35vpmktkag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 Jan 2021 11:38:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 11:38:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Op2vyxiUi7CbaWg9oVJQGT7rwL/PCa2yYB0eFJjfh1+cogFxbNkFPT8ebiClcjmN1KjAT6HsQYtCU9Vztf0LDNSD3NdWPS4aQ+BblP13ieO2AZsd+NTeVxHfa0djCcJhgmFFq/1drbGgm+aIJ/rkoHNRz81CAjYW5nAA8IUcMwb4IWJ2Eu12/RC6Rz9OygNKXH9AiHmX25l7O5N5YO65Mx/PKorCfSQ8DOWG8o6tc3nSRBkzQsRRzBjRcU+k5AZ8l1xX3G+S0QtVbABTIAqGP+pN5Bqum99NVt/9rpn5J9lJXSDf83aPYlYbKjvyW2G8jybYyPu9VKdU4JB8dlL/Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU/uixX7AQQTiZ/+ECq/uM8mx50WP2/yOJsG6FntYm4=;
 b=UzEBeFPoW6m9JdlOg7EewcoJI7+l5cao/7RI3ooNQ02vVNrr90YUiz3jneYqt5nRzcSo0iALmaO9k6w0b2WYDU/96+xn+FmxgCUNAX0OYgMNC52z/C/17H6rSusBPl7BjZdt89fz2rRfFKm29E1Kmdt29JVke5gQ2WM+OYBnkGGQ3eGT3SAykeBSzQRFCglQQIhRT4+9Bauiq+E9sp/e9iVz3mUb0VHcQ8PLEBSp473nB3zN0LfkRrY6S1AhEmQJpKra+3kLPyd6notgW8eagb5i2aWwwVZ2vxQtvKYC+eqEvdSUDPIb/0VLBjyqe/LsVgYliT1PG5gMPlw3jfrDpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU/uixX7AQQTiZ/+ECq/uM8mx50WP2/yOJsG6FntYm4=;
 b=lMSxm/e0kP7cxetc+C4SNVuDpX4MgL15NTCBRZPlf2CRS6cf/1677AKsZaLFzCsuYj6T1XR4/dnPeCLj5tTXJqwljB+vn/YV9rNBZ4s4XzZ6/Mqm3fdejFzO7zfhvn+LME7yx6Uru0hwKVX0DRkn/sg0mMsoY4z9HWUkBpiEAoE=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2199.namprd15.prod.outlook.com (2603:10b6:a02:83::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Tue, 5 Jan
 2021 19:38:08 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 19:38:08 +0000
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
Thread-Index: AQHW0zs42cd9AcJBNEyi77fZmX7Jx6n7qAwAgAAzywCAAEpiAIAAIRcAgAAOLwCAALyEgIAADIEAgBtELICAAENfgIAAsrMAgAAMPQCAAASzgIAAJGyA
Date:   Tue, 5 Jan 2021 19:38:08 +0000
Message-ID: <48243EAC-D280-4A89-BA72-68E529B6E6FD@fb.com>
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
 <6E122A14-0F77-46F9-8891-EDF4DB494E37@fb.com>
 <CAADnVQJ5eKCnkoUV-K-S80-0CGLNstNw50OX2tndLM+Or+CSHQ@mail.gmail.com>
 <EB23A240-8A1B-468B-86C8-CF372FE745C5@fb.com>
 <CAADnVQLg-kQ9Neva0DvUW8CMiuNhv0HTHdsV5fgV8+ra98wE5w@mail.gmail.com>
In-Reply-To: <CAADnVQLg-kQ9Neva0DvUW8CMiuNhv0HTHdsV5fgV8+ra98wE5w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:4dc5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 702d748e-0d88-4d6d-cf03-08d8b1b16dc0
x-ms-traffictypediagnostic: BYAPR15MB2199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB219974B3945EA856D9D2C7CDB3D10@BYAPR15MB2199.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tRG6vOYuY7/nOt3Zu18+SwFSYQrJmNOjVeruJ+Y1tZEvJLEvuSG5OOFquBsjW6SR9U+xxxeSPPLD2V/btFkURHXiqOCkgz3AKho5m5XigrrYyt8IsWyElUvluqd6UI6Wtgdb9DViqMhXkl73DvpU3SeYeXCg0o/v/gC3bwUraWMnuXCd3bo8my5FsTJowYQm0MC0QT33ck9a7O2s26xhWt0ttPs2n9K0io3kDLlhH2EG7uXmgnj91reyl+huugHiHshbxHBIkL841FI5tmjDlL7ROWPspxEOI9LYX71ivszltqOGiRtA7MGxWLiFcYv+mwdFHAVBxnwbdPy7l5VdSnuzCgemuKwMYrGgUc09Mlt7Lyngj70pu4XyfHEEWVQex80aEiU3urh6JSex8vLh30IFCGFH2QJw3qSVBmogeK9K8NjJbqfvYrvm+ue9As9u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(136003)(366004)(376002)(6512007)(36756003)(71200400001)(66946007)(6916009)(2616005)(316002)(54906003)(86362001)(91956017)(83380400001)(5660300002)(76116006)(4326008)(8936002)(478600001)(2906002)(33656002)(64756008)(66446008)(66476007)(66556008)(53546011)(8676002)(6506007)(6486002)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?P7RyHkevc3iWhSB48X7inJJvMuHusSLLLpIm7a2B8SKdMBIb2DlrJgs7JxXg?=
 =?us-ascii?Q?5yWzWYU2lHs1nJ4nZDLXTl7bET9TmQLZ7oSXa/V4bhPfOSGea4SRPqnZFcIz?=
 =?us-ascii?Q?xXfL0Ciw47etdJSns+0JYaBN9ZnrXSKJCkKqv5xOlM0J6OI7GUsDYxdRbKgy?=
 =?us-ascii?Q?74fFMo/2fSzAZTVUCLb/Y3XVinL5UQyiZ1i1H8bUkgwwW84NYCu1OGPsy9+U?=
 =?us-ascii?Q?y93ZXEI/GeINIlEFpYyu28p9xT/rO6gqpHPCJyaqdplISoFgTvWGJBfnOIIx?=
 =?us-ascii?Q?DXf7wp2rlaw2tVksvExZbzJUxXYk242cWZ9gB3C4gWecDM4YsB2GmUNcWrXV?=
 =?us-ascii?Q?6TS5Fk43GZ8JSJfu80r/7XIIHDyjsd6kQYT0QxFMvnUbcQZxJ/a7xM31+xse?=
 =?us-ascii?Q?ilk0FwrlWGOClGzTWqlVGBQMWZ9p15Dm7Iq++6zpiDveicfMS8rpqjbzuDBI?=
 =?us-ascii?Q?mSHDVSPl6Cu+HUhyChaqqWdOTqqqsCpyLt2xGOQGVz/wvmUtgXcp6O5PIQgp?=
 =?us-ascii?Q?xBQx2y99e7PDdHq2nIT9vpN5kWMLM4rtCofJsg1mlK+yLpDeoorxerJtExQE?=
 =?us-ascii?Q?vFe4Y21rpeQUtSAgCYYEgYQ+NXVkpq8u+3I8hWlvNp6fFHftftjvpYziHDGz?=
 =?us-ascii?Q?I06pDCLEFCXC/sdk6O3MrQAGCCtMB6a7Hy5VamMCwcwp83PyNYfoafRpPDkM?=
 =?us-ascii?Q?i5D1uICA3XeDG6oVEs/EA6fpTjrG8X9TF2Q5PzTPb4r2qXmE0CQSlSMz2fDH?=
 =?us-ascii?Q?ivwJo13Um2AMf/CPfW6OtX7onhrOUPkrcX9D5TetBaiNv1njAek5F6t/nlCx?=
 =?us-ascii?Q?tD+/h9xa8UPyc4yQfZ1ad8XP6NM9IJVNKIilXKtls1zZ3qYwolkR/KsDsJ64?=
 =?us-ascii?Q?g07bxoLE+kU5r9uc4LPg8tPLtySp8eywHOjyuM821IJmsQIbeJ0qL1RYIyA/?=
 =?us-ascii?Q?E2hMjlj2Y6tBXFO7gk8EMlqqRa/JsfcfyFqK7Jh3sbcpYnfa2Y/QLOlOgWum?=
 =?us-ascii?Q?b2TcG6x4c29Hggoh1K8WFLsKCu6dFJtSZTP0SF0D6me4NCA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9367EF9E80D0A447AA47792C96240626@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702d748e-0d88-4d6d-cf03-08d8b1b16dc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 19:38:08.0126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z3jEWeN5N27934+RUpF/OdNxJVrxS5CctDNjHT55jP66zrD/8O6Wa0zqLJFvzrHqyL5hoXijKiWazm5eTiotXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2199
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_06:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 5, 2021, at 9:27 AM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Tue, Jan 5, 2021 at 9:11 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jan 5, 2021, at 8:27 AM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>>>=20
>>> On Mon, Jan 4, 2021 at 9:47 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Jan 4, 2021, at 5:46 PM, Alexei Starovoitov <alexei.starovoitov@gm=
ail.com> wrote:
>>>>>=20
>>>>> On Fri, Dec 18, 2020 at 05:23:25PM +0000, Song Liu wrote:
>>>>>>=20
>>>>>>=20
>>>>>>> On Dec 18, 2020, at 8:38 AM, Yonghong Song <yhs@fb.com> wrote:
>>>>>>>=20
>>>>>>>=20
>>>>>>>=20
>>>>>>> On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
>>>>>>>> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> w=
rote:
>>>>>>>>>>=20
>>>>>>>>>> ahh. I missed that. Makes sense.
>>>>>>>>>> vm_file needs to be accurate, but vm_area_struct should be acces=
sed as ptr_to_btf_id.
>>>>>>>>>=20
>>>>>>>>> Passing pointer of vm_area_struct into BPF will be tricky. For ex=
ample, shall we
>>>>>>>>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id t=
he verifier will
>>>>>>>>> allow access of vma->vm_file as a valid pointer to struct file. H=
owever, since the
>>>>>>>>> vma might be freed, vma->vm_file could point to random data.
>>>>>>>> I don't think so. The proposed patch will do get_file() on it.
>>>>>>>> There is actually no need to assign it into a different variable.
>>>>>>>> Accessing it via vma->vm_file is safe and cleaner.
>>>>>>>=20
>>>>>>> I did not check the code but do you have scenarios where vma is fre=
ed but old vma->vm_file is not freed due to reference counting, but
>>>>>>> freed vma area is reused so vma->vm_file could be garbage?
>>>>>>=20
>>>>>> AFAIK, once we unlock mmap_sem, the vma could be freed and reused. I=
 guess ptr_to_btf_id
>>>>>> or probe_read would not help with this?
>>>>>=20
>>>>> Theoretically we can hack the verifier to treat some ptr_to_btf_id as=
 "less
>>>>> valid" than the other ptr_to_btf_id, but the user experience will not=
 be great.
>>>>> Reading such bpf prog will not be obvious. I think it's better to run=
 bpf prog
>>>>> in mmap_lock then and let it access vma->vm_file. After prog finishes=
 the iter
>>>>> bit can do if (mmap_lock_is_contended()) before iterating. That will =
deliver
>>>>> better performance too. Instead of task_vma_seq_get_next() doing
>>>>> mmap_lock/unlock at every vma. No need for get_file() either. And no
>>>>> __vm_area_struct exposure.
>>>>=20
>>>> I think there might be concern calling BPF program with mmap_lock, esp=
ecially that
>>>> the program is sleepable (for bpf_d_path). It shouldn't be a problem f=
or common
>>>> cases, but I am not 100% sure for corner cases (many instructions in B=
PF + sleep).
>>>> Current version is designed to be very safe for the workload, which mi=
ght be too
>>>> conservative.
>>>=20
>>> I know and I agree with all that, but how do you propose to fix the
>>> vm_file concern
>>> without holding the lock while prog is running? I couldn't come up with=
 a way.
>>=20
>> I guess the gap here is that I don't see why __vm_area_struct exposure i=
s an issue.
>> It is similar to __sk_buff, and simpler (though we had more reasons to i=
ntroduce
>> __sk_buff back when there wasn't BTF).
>>=20
>> If we can accept __vm_area_struct, current version should work, as it do=
esn't have
>> problem with vm_file
>=20
> True. The problem with __vm_area_struct is that it is a hard coded
> uapi with little to none
> extensibility. In this form vma iterator is not really useful beyond
> the example in selftest.

With __vm_area_struct, we can still probe_read the page table, so we can=20
cover more use cases than the selftest. But I agree that it is not as
extensible as feeding real vm_area_struct with BTF to the BPF program.=20
Let me try calling BPF program with mmap_lock.=20

Thanks,
Song=20

