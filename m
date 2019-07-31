Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B77CCB0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbfGaTXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:23:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49078 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730413AbfGaTXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:23:14 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VJI65m015559;
        Wed, 31 Jul 2019 12:22:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zcRHMcwtAd0MByunR+REkWCZAYEoh9NeB13KZNjNRn0=;
 b=JgHSh0mAMSA+wJcuNhWi64hDUf0okoZo0xFMssrc2jGhLsGCyV4SEv4CJ1gFZFkQFJso
 Xx5WP636ahnw7CvVL9BQYkbKYg27yiBmeWcNsEggA0REt7FwAnhFJrWplq4EsmHCQ3JG
 1y4DvfKJ2NT6l8Frwuy2MGVqd2ZYBFPgmNI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u3c8bsb2e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Jul 2019 12:22:54 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 12:22:30 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 31 Jul 2019 12:22:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EV5M5Og7K0/Mp5EQ3R/RMm9l0tbGLkIHqptZYLcdSzwXdj023gr+UvSX9sMf2VdW+GZkdvEtjXZAi/OMnI6X84Qtn9y3yLXZPH4v1d/BgzHOuXcscgUsMxeFd3M33aCSV4lO4cxpYdbJaNNOelwAkYVRaaAcs8/11ymt5BEsjiLMtTVLlKPPhttP7n3VZl2h5LJWVZOLtwgib44gKhjlhUhQMXrk2oEEUIWElO+W3PAbBMOxdcz+CUFBdo609QH2zE8DMkZ44viygDce25g28UG6S3wViKf3K1akQ0QhA1D8Qw+KsUcUno0YiVlH2r0vJCgzuju7sYvMqiTAsExzHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcRHMcwtAd0MByunR+REkWCZAYEoh9NeB13KZNjNRn0=;
 b=aOenFm9oqHaDW0yIunka3f+i02io357/g9rzR9quPlsFo6t5Mt315jnHwo6EzpAuSQMGc51iqsrryelJQDGhmdcnJ3daeMXKH7/i0o9h4/nsXmDd6p+Ok6vTTrImq4dLo1BKS5aSrtetptouk214YPgEZW5jPNWqPv71cBeHfDpAz0mVv1nn5sTg3+iwTHfcWn9dAP2+rJK2gIS1TcxvhGdpfy2YWQDlqQnsefmj2XJ12VVNOGsGoFy43A6spdsAFBWezMwmvavabITBvdKRe8tYu6xcHtfc8Z24OtSWQ4ieuV+iYCmtNCDZIw+mwiNgTzF7+R4AXZ2UoOoEDYZl2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcRHMcwtAd0MByunR+REkWCZAYEoh9NeB13KZNjNRn0=;
 b=e3TZamwCVXVmYBzdwUkTYGMPFJIxoI4sMbya7PO55OGKlLQpwxcxB6vfouxTLRX/AIw5bo4glIgTUGDJM5EAkDOJAdUd/NhtbvUhe/icQC/eoNvR5lIYIeAoCk9awU2l7JUoCYJ9QRj0FycOup8fck+QswwKKalANAuagKLkQGw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1678.namprd15.prod.outlook.com (10.175.137.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.15; Wed, 31 Jul 2019 17:46:59 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 17:46:59 +0000
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
Thread-Index: AQHVRxC6gG08pF4S5U2u3sEqys7j0abj4qsAgAAF+YCAAEgvAIAAGhqAgAAbNICAAJPSgIAAB9EA
Date:   Wed, 31 Jul 2019 17:46:59 +0000
Message-ID: <989ABCA7-D84C-43A8-853B-4C9E25FF133E@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
 <20190730195408.670063-3-andriin@fb.com>
 <4AB53FC1-5390-4BC7-83B4-7DDBAFD78ABC@fb.com>
 <CAEf4BzYE9xnyFjmN3+-LgkkOomt383OPNXVhSCO4PncAu20wgw@mail.gmail.com>
 <AA9B5489-425E-4FAE-BE01-F0F65679DF00@fb.com>
 <CAEf4Bza3cAoZJE+24_MBiv-8yYtAaTkAez5xq1v12cLW1-RGcw@mail.gmail.com>
 <4D2E1082-5013-4A50-B75D-AB88FDCAAC52@fb.com>
 <CAEf4Bzb6swYtf7J_m1bZo6o+aT1AcCXZX5ZBw7Uja=Tne2LCuw@mail.gmail.com>
In-Reply-To: <CAEf4Bzb6swYtf7J_m1bZo6o+aT1AcCXZX5ZBw7Uja=Tne2LCuw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:70cb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 615e37fa-4ada-4007-854a-08d715df168f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1678;
x-ms-traffictypediagnostic: MWHPR15MB1678:
x-microsoft-antispam-prvs: <MWHPR15MB16784C6BDDA4B80B71210371B3DF0@MWHPR15MB1678.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(39860400002)(346002)(136003)(199004)(189003)(99286004)(6116002)(14454004)(6916009)(305945005)(7736002)(50226002)(81166006)(68736007)(81156014)(8676002)(478600001)(36756003)(86362001)(25786009)(5660300002)(8936002)(71200400001)(71190400001)(4326008)(256004)(2906002)(11346002)(76176011)(316002)(186003)(6246003)(6512007)(46003)(76116006)(53546011)(66476007)(6506007)(102836004)(66946007)(66446008)(446003)(66556008)(64756008)(53936002)(486006)(33656002)(476003)(2616005)(57306001)(6486002)(6436002)(229853002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1678;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OxcCmDWnzMwvysviMDP48OuMFXX+2slsw8JSaaMcjyRTJbnWvTrQUCT7NxJR2PUz0myHVN2XBN03Ytb0dYH8skm1kRJph6WJF4/4I+UXqgpjpy8LGy9MKqIpav2dzXnoK5D3bjB7LNLEm7k5Q17htFdTbowcbaepq7kdzxZz49hjzxawvve2zePfZzhQQnsk6uvp58rwFRKZhxC+EF2j/JqO3nAJOPuk8odJM/ymwK/D45Qs4PFAx0fNXoTpkuTPNARocLvUWuNiyTj0ELny47fhPDytFG8IS2x9dO03MY/FLNHZZ0ZvYn9tqMl0nY7bDLV0lZpT+y+MMtwsWUdi+kGaik1pbhNUWo1hU62eDW/9CeW1u6mpBaSgyziYh2qTTnzWxiWj1xbXt9Dx4GfhrD4lZdFwcMG2hOTw3qxwJ9A=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2E3AF88DBE0D6E408ADFD2F48E4D2F6F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 615e37fa-4ada-4007-854a-08d715df168f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 17:46:59.4737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1678
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310191
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 31, 2019, at 10:18 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Wed, Jul 31, 2019 at 1:30 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 30, 2019, at 11:52 PM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
>>>=20
>>> On Tue, Jul 30, 2019 at 10:19 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Jul 30, 2019, at 6:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.c=
om> wrote:
>>>>>=20
>>>>> On Tue, Jul 30, 2019 at 5:39 PM Song Liu <songliubraving@fb.com> wrot=
e:
>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>>> On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrot=
e:
>>>>>>>=20
>>>>>>> This patch implements the core logic for BPF CO-RE offsets relocati=
ons.
>>>>>>> Every instruction that needs to be relocated has corresponding
>>>>>>> bpf_offset_reloc as part of BTF.ext. Relocations are performed by t=
rying
>>>>>>> to match recorded "local" relocation spec against potentially many
>>>>>>> compatible "target" types, creating corresponding spec. Details of =
the
>>>>>>> algorithm are noted in corresponding comments in the code.
>>>>>>>=20
>>>>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>=20
>> [...]
>>=20
>>>>>>=20
>>>>>=20
>>>>> I just picked the most succinct and non-repetitive form. It's
>>>>> immediately apparent which type it's implicitly converted to, so I
>>>>> felt there is no need to repeat it. Also, just (void *) is much
>>>>> shorter. :)
>>>>=20
>>>> _All_ other code in btf.c converts the pointer to the target type.
>>>=20
>>> Most in libbpf.c doesn't, though. Also, I try to preserve pointer
>>> constness for uses that don't modify BTF types (pretty much all of
>>> them in libbpf), so it becomes really verbose, despite extremely short
>>> variable names:
>>>=20
>>> const struct btf_member *m =3D (const struct btf_member *)(t + 1);
>>=20
>> I don't think being verbose is a big problem here. Overusing
>=20
> Problem is too big and strong word to describe this :). It hurts
> readability and will often quite artificially force either wrapping
> the line or unnecessarily splitting declaration and assignment. Void *
> on the other hand is short and usually is in the same line as target
> type declaration, if not, you'll have to find local variable
> declaration to double-check type, if you are unsure.
>=20
> Using (void *) + implicit cast to target pointer type is not
> unprecedented in libbpf:
>=20
> $ rg ' =3D \((const )?struct \w+ \*\)' tools/lib/bpf/ | wc -l
> 52
> $ rg ' =3D \((const )?void \*\)' tools/lib/bpf/  | wc -l
> 35
>=20
> 52 vs 35 is majority overall, but not by a landslide.
>=20
>> (void *) feels like a bigger problem.
>=20
> Why do you feel it's a problem? void * conveys that we have a piece of
> memory that we will need to reinterpret as some concrete pointer type.
> That's what we are doing, skipping btf_type and then interpreting
> memory after common btf_type prefix is some other type, depending on
> actual BTF kind. I don't think void * is misleading in any way.

(void *) hides some problem. For example:

	struct type_a *ptr_a =3D NULL;
	struct type_b *ptr_b =3D NULL;

	/* we want this */
	ptr_a =3D (struct type_a *)data;
	ptr_b =3D (struct type_b *)(data + offset);

	/* typo, should be ptr_b, compiler will complain */
	ptr_a =3D (struct type_b *)(data + offset);

	/* typo, should be ptr_b, compiler will ignore */
	ptr_a =3D (void *)(data + offset);

Such typo is not very rare. And it may be really painful to debug.=20

That being said, I think we have spent too much time on this. I will=20
let you make the final call. Either way:

Acked-by: Song Liu <songliubraving@fb.com>=
