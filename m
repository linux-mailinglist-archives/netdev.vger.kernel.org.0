Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E587BBB4
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbfGaIaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:30:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbfGaIaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:30:21 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V8PY2U021645;
        Wed, 31 Jul 2019 01:30:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rPk5MvDEm3aK1sSXSTCTJivIXyNm/mNFMFE3HBIMORw=;
 b=Oy/QeVmQQ1zT58lqy9b6xI/SNmVqbbVUXo11Vtj245FBVQvlSkTPrl/Q+8uozPUzJkm0
 D60c0EsrcJ2l6XULXY+lxzOUJKVzlxvaFjCBWVu6Cy6xcvFkvoO8EXnpWSb8nN6yCKjL
 tg2gXytnD7xw8x21W7CT4yLNBpjwksUjo80= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2wkksr4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Jul 2019 01:29:59 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 01:29:58 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 01:29:58 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 31 Jul 2019 01:29:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E70y9A8NUS14v2tNaDKDdB/8POBwzSZm+4P9o8/8VNfBM1tM/XFYp2A1WqAUDnSUxGYHqpvodrROt7PUomA2STxOfUSaJIIbK8MP/8Q9Y6QhNG1HJLMe2j7bcZNUztTqRp3p+PwWDKHY15Gzk6eckhdsxHu9LoCefHm+aSgEuarGifD0NjuNCd1QHfhVq/06ckLU0FnhE40tB14D3Py7hEmt6aiqj3TcPqBKN8zLd9SbrW6Xn0wTq6MKoIYpcIUr5VhOcP68pTGjJZl4fOCXeGS8RAmUkMSWyfirnkDD6/GIzeauG9XP5bLfrWns3+VuN7tS+MxURscmXIJBaAlVXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPk5MvDEm3aK1sSXSTCTJivIXyNm/mNFMFE3HBIMORw=;
 b=k7Jo3mGF+keLlttsX5g1abnvujxPaIhlV1ID0HfOeiLJn1hUXipIZGWWLZ6hLy7/1gtXc/xrbfY9JXW5gy7Q6Us9mbD3fd90qx8TYmvSpf22O1CzTOsMrGz+LpeTOIpx9vudX9MOSccMZyw/gHoX89WjHxjxiyt7BpUgin9E4Ddp/31xk4chdcQFfGk733KZ7FaKGZ6c9sSdAgzhg28oEDW7WbInvEXhLVBRm9fW8oUdOluL2bnWXrXXbDZSdP/cMt8fOJH5Kbqa70uz3QZ/LHHqHu9ZEMVXvvLDl1GbclTeqmwQnxjjXEp4C5Q6jFJS1H1yKdIceGlDxTevx4eS8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPk5MvDEm3aK1sSXSTCTJivIXyNm/mNFMFE3HBIMORw=;
 b=GGjN91haoCjsEEWXMqT7wg4XUxBXpKirkoUUcuIoYtx8cjMuhj3BjdYMrQv2L835MIt0nRQt7NHYVbwuKjYEGCc6VRhQSgH6GRg+lzoVFVeicDR70WNB6EPhUQUskMKszOWG7rILtyvCk80jyNl82BX/bFRREtubM0jeGgefe2g=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1118.namprd15.prod.outlook.com (10.175.2.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 08:29:56 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 08:29:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Topic: [PATCH v2 bpf-next 02/12] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Index: AQHVRxC6gG08pF4S5U2u3sEqys7j0abj4qsAgAAF+YCAAEgvAIAAGhqAgAAbNIA=
Date:   Wed, 31 Jul 2019 08:29:56 +0000
Message-ID: <4D2E1082-5013-4A50-B75D-AB88FDCAAC52@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
 <20190730195408.670063-3-andriin@fb.com>
 <4AB53FC1-5390-4BC7-83B4-7DDBAFD78ABC@fb.com>
 <CAEf4BzYE9xnyFjmN3+-LgkkOomt383OPNXVhSCO4PncAu20wgw@mail.gmail.com>
 <AA9B5489-425E-4FAE-BE01-F0F65679DF00@fb.com>
 <CAEf4Bza3cAoZJE+24_MBiv-8yYtAaTkAez5xq1v12cLW1-RGcw@mail.gmail.com>
In-Reply-To: <CAEf4Bza3cAoZJE+24_MBiv-8yYtAaTkAez5xq1v12cLW1-RGcw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6d8b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49d32298-329d-4521-103b-08d71591450d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1118;
x-ms-traffictypediagnostic: MWHPR15MB1118:
x-microsoft-antispam-prvs: <MWHPR15MB1118C334BBC1F6F6F48CBE32B3DF0@MWHPR15MB1118.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(396003)(376002)(136003)(189003)(199004)(6436002)(11346002)(71200400001)(36756003)(76176011)(66946007)(7736002)(57306001)(102836004)(81156014)(6916009)(6512007)(6246003)(66556008)(33656002)(64756008)(6116002)(186003)(316002)(76116006)(66446008)(305945005)(81166006)(478600001)(68736007)(66476007)(71190400001)(8676002)(2906002)(229853002)(6506007)(54906003)(50226002)(99286004)(8936002)(446003)(46003)(86362001)(476003)(53936002)(486006)(2616005)(14454004)(25786009)(5660300002)(4326008)(256004)(53546011)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1118;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /ozIvu7VPgsB6UVg3fRtXHh9RfoheXeNhMnmCXbGY0RMkRTYSYl4dQR2KV3jqjaEjwXAKzTIVvPZovdf7z8nLF+hBHXqlKfZFO52X6LGgJ17Lgg+F5C/9bE2lZUz86t0C1rRgNs9z7KIpNyO0CuEGHdfODbbaHC06K6ovu6LCp0Lwu9Nqz/8Lx3hMjZrZtyHqOuXQBx85xJYlosZvkVVD1EoaTMrcaET58oaLMBrToJ7oZoR6R8uhGWu/isORDbb7WC9W8idqZeQf7GVh076ZVJ0goao8vHiDQxeJgvRhOmJZttiFfcKPaIg0MPnlp9KCaDFT3qU3oMvArbOjN8/dDqsGDuFtg5/1BqN8bQJ6ArKhxx69Tl8EOIdePslOjiBUP+DamOkr9CeAIzgOo7SffLkzQHfA27Tb7SW1QsbeQw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F2980172E8ACE948A5432783DEB38CCC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d32298-329d-4521-103b-08d71591450d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 08:29:56.7048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1118
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=962 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310091
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2019, at 11:52 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Tue, Jul 30, 2019 at 10:19 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 30, 2019, at 6:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
>>>=20
>>> On Tue, Jul 30, 2019 at 5:39 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>>>=20
>>>>> This patch implements the core logic for BPF CO-RE offsets relocation=
s.
>>>>> Every instruction that needs to be relocated has corresponding
>>>>> bpf_offset_reloc as part of BTF.ext. Relocations are performed by try=
ing
>>>>> to match recorded "local" relocation spec against potentially many
>>>>> compatible "target" types, creating corresponding spec. Details of th=
e
>>>>> algorithm are noted in corresponding comments in the code.
>>>>>=20
>>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

[...]

>>>>=20
>>>=20
>>> I just picked the most succinct and non-repetitive form. It's
>>> immediately apparent which type it's implicitly converted to, so I
>>> felt there is no need to repeat it. Also, just (void *) is much
>>> shorter. :)
>>=20
>> _All_ other code in btf.c converts the pointer to the target type.
>=20
> Most in libbpf.c doesn't, though. Also, I try to preserve pointer
> constness for uses that don't modify BTF types (pretty much all of
> them in libbpf), so it becomes really verbose, despite extremely short
> variable names:
>=20
> const struct btf_member *m =3D (const struct btf_member *)(t + 1);

I don't think being verbose is a big problem here. Overusing=20
(void *) feels like a bigger problem.=20

>=20
> Add one or two levels of nestedness and you are wrapping this line.
>=20
>> In some cases, it is not apparent which type it is converted to,
>> for example:
>>=20
>> +       m =3D (void *)(targ_type + 1);
>>=20
>> I would suggest we do implicit conversion whenever possible.
>=20
> Implicit conversion (`m =3D targ_type + 1;`) is a compilation error,
> that won't work.

I misused "implicit" here. I actually meant to say

	m =3D ((const struct btf_member *)(t + 1);



