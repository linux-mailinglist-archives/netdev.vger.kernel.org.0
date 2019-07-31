Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C07B7B902
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 07:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfGaFTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 01:19:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35650 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbfGaFTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 01:19:34 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V5JEhL019692;
        Tue, 30 Jul 2019 22:19:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xlU7JFI/JDWlM9BDW6ZsbE44dqkvT96+eqbTU6/i0gs=;
 b=bZilkhAjX49UBkqnJbLUPsIyKLd8USwwpsbFT9xA0ht/t1ejb6qdgaUUEAOT+A73RPkA
 4iLwBF0+u1o7Vd8hDjJkB83dI5u7jYjBZRyJWFkXW9iGKuGo8nQXDy11Ar5XuwTTUBlS
 dLpahIhmyqDURslBf+d9ZV+QwxRR0sLQngo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2wufs6t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jul 2019 22:19:14 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 22:19:10 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 22:19:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNjI4/+HrtWyfjMoVudyzbZUf/nhqjX6ap8fYh/P89TGkq9hm2q2kr2/CZVPinbDmPKIJwdPdDU8vWKWRfkM1abp93o2SjOkWSN1Kw7wR5bp+KfOIIRAG/BA+1xO9uY9rj84a15rI5Pv2h7G5LG1WuK5SKI3Bkh0f0KMieAfVnSLGnv84Egt3HR0ldvjFci/nQp6vrbhZm0raaiiw3hVqEWkbZfaj1vt1u9ccy7/HOoh1OdZCm0wk5U5T1BRkzCxUIWuxJ7nl4tmKYpYTifEBNi/UppVeg7ggVeDK+TW6ejh87E41lC1PhDGRklAy6vjf/Xr4hc1/etOZvNnKEQ9oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlU7JFI/JDWlM9BDW6ZsbE44dqkvT96+eqbTU6/i0gs=;
 b=HkcKJUUHjWjVYr1OiYWIWfSS8zhNHRPAiFnU8+aZoGggNBoIw0SCAscY3NgUJwA+6AC1JfYs3A7MOvoaIxfmVuD3PawaJ7Rv5PnkslrAlKDz0OrBkA6YtawtNCE9kiZDTELMTujHeAhaer0Qwx/w1pwaJDs7c73fR+wcQqizeq1ZjBDoadiJOMJSg5qj1y1gSM8zDBtP93pzl4tCp+UQi1QWn1EH/vlXEQE7AugEYRBNU1vGA7yraJU5IAaq48wvKZv1Qa8xg8BgOD6ptoFPSffkhCQQrpQhUnoFWzOwhGr4NRxGDD5QpsMHLSsxQXV7EGk1W+VP0NEZ+nzJim/v8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlU7JFI/JDWlM9BDW6ZsbE44dqkvT96+eqbTU6/i0gs=;
 b=dDYimvLkOQODFKcqztGa8rehLQ0vkGwCnZ8dC89YDuglxxlcu4Z5OWs8NixYhAEg694KZ0XcTnGM2G5UJlw3BZYWe+p2Fn4JZgpQrratgTOxiz8eQ93RaSzI1OSkz3wWY69wNmRfQO5PG/+e9qYNrvQDIkznAGCwoyafgVmXyC8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1406.namprd15.prod.outlook.com (10.173.234.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 05:19:09 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 05:19:09 +0000
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
Thread-Index: AQHVRxC6gG08pF4S5U2u3sEqys7j0abj4qsAgAAF+YCAAEgvAA==
Date:   Wed, 31 Jul 2019 05:19:09 +0000
Message-ID: <AA9B5489-425E-4FAE-BE01-F0F65679DF00@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
 <20190730195408.670063-3-andriin@fb.com>
 <4AB53FC1-5390-4BC7-83B4-7DDBAFD78ABC@fb.com>
 <CAEf4BzYE9xnyFjmN3+-LgkkOomt383OPNXVhSCO4PncAu20wgw@mail.gmail.com>
In-Reply-To: <CAEf4BzYE9xnyFjmN3+-LgkkOomt383OPNXVhSCO4PncAu20wgw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6d8b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 912828b0-f403-4ea0-1571-08d715769dc5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1406;
x-ms-traffictypediagnostic: MWHPR15MB1406:
x-microsoft-antispam-prvs: <MWHPR15MB14067BE87616AE1FC7A2227CB3DF0@MWHPR15MB1406.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(366004)(346002)(39860400002)(189003)(199004)(57306001)(68736007)(76176011)(99286004)(2906002)(6506007)(53546011)(6116002)(33656002)(186003)(5660300002)(66946007)(66476007)(66446008)(7736002)(64756008)(8676002)(66556008)(8936002)(81166006)(76116006)(81156014)(50226002)(36756003)(4326008)(229853002)(25786009)(6916009)(46003)(6512007)(486006)(14454004)(305945005)(2616005)(476003)(54906003)(316002)(11346002)(446003)(478600001)(6436002)(256004)(6486002)(102836004)(6246003)(14444005)(71190400001)(71200400001)(53936002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1406;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EHFqdpfT25BM18D177lrqqqcpOg8x7u4FBT4DQkwpF7e3Ri+FMpsM2oZQZUtWM/bGb/L44k93IcuLZ5Ks8vmxPmHDPRFYxasANZbB1brEsd9V90wCtg1/1gAyOVW+MQPvtKBONApeg7J34RHNAAAYzqJRcSI3z6x02YUPuxmk+b2hhxDsD903s7VTbym/MCd1AsGFxLze63RzaHz1jGksrX5Ja0B5GdZoHEJQqtY1EDa4nMC9+8CIF21L0E03z4Tp/viblEkYF17VcY0b62Fu5rCJp89iCjpkZXev8s0Svhw07+El/ebVI4T2ZDcVNSOMD730pH9nPu78Y9O6KgrzCVWELXzTVPSOUQn7/g34XxEapRHeFDiReXHcXkNARdmNBGpjHxWTIIt2jPMCBsFXRUNN6vpSzLHm2Bljfm6drU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <304262A47B1BBB4A89D600A0BD2EEB6E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 912828b0-f403-4ea0-1571-08d715769dc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 05:19:09.2136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1406
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2019, at 6:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Tue, Jul 30, 2019 at 5:39 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> This patch implements the core logic for BPF CO-RE offsets relocations.
>>> Every instruction that needs to be relocated has corresponding
>>> bpf_offset_reloc as part of BTF.ext. Relocations are performed by tryin=
g
>>> to match recorded "local" relocation spec against potentially many
>>> compatible "target" types, creating corresponding spec. Details of the
>>> algorithm are noted in corresponding comments in the code.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>> tools/lib/bpf/libbpf.c | 915 ++++++++++++++++++++++++++++++++++++++++-
>>> tools/lib/bpf/libbpf.h |   1 +
>>> 2 files changed, 909 insertions(+), 7 deletions(-)
>>>=20
>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>=20
> [...]
>=20
> Please trim irrelevant parts. It doesn't matter with desktop Gmail,
> but pretty much everywhere else is very hard to work with.

This won't be a problem if the patch is shorter. ;)=20

>=20
>>> +
>>> +     for (i =3D 1; i < spec->raw_len; i++) {
>>> +             t =3D skip_mods_and_typedefs(btf, id, &id);
>>> +             if (!t)
>>> +                     return -EINVAL;
>>> +
>>> +             access_idx =3D spec->raw_spec[i];
>>> +
>>> +             if (btf_is_composite(t)) {
>>> +                     const struct btf_member *m =3D (void *)(t + 1);
>>=20
>> Why (void *) instead of (const struct btf_member *)? There are a few mor=
e
>> in the rest of the patch.
>>=20
>=20
> I just picked the most succinct and non-repetitive form. It's
> immediately apparent which type it's implicitly converted to, so I
> felt there is no need to repeat it. Also, just (void *) is much
> shorter. :)

_All_ other code in btf.c converts the pointer to the target type.=20
In some cases, it is not apparent which type it is converted to,=20
for example:

+	m =3D (void *)(targ_type + 1);

I would suggest we do implicit conversion whenever possible.=20

Thanks,
Song=
