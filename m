Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802887B6A0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 02:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfGaAQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 20:16:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28732 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728344AbfGaAQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 20:16:27 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V0ApQ9026625;
        Tue, 30 Jul 2019 17:16:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=D4Q7DNHo6A7EkRj0pTJsarvmrKAGbG8G9SHDrIom414=;
 b=h6F3OsTsfCGFNBS1gK7v1bfMBQN9EQd5wsL9t07MWdMR5bMyZPgbPEZDCcTANdveoarw
 7+MdutWjMTkJdo70FgpyqcuFp8sYUZ1pA0W4BldvM57Sh+BgHR6yfwYz/jOlVaoD2m+e
 0ox26IQZXX03aWM7152ouM6Tow0COJ4svME= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2uxa0yea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jul 2019 17:16:06 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 17:16:04 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 17:16:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CE/EDAjoosSWngomRDgDh7eQMKlcAv0bAlD93vw0/BIemihENgZOEW0aZsLckJkKYyX4tepf5DqcaU10rxJ8lxlaDVMUdlOlK+mtozg5kYuwfHuL9ek0/f0niLUUf8auUNOtU47Wsr9UQAVpOamXH4X9Mhd+Z7q/owblXdD+75Ai/FuY7FOCUEz/vGSAmceTzCer4s0Zam52VdcAY3NUpfEKllW4SGejyHPEiKpbKC+41lLB6I7j6y7GWNCdVTVmdR/gH6nYu5lu12X6fnm+onCXy7zf9aRfGc3cD+skUxI/02N2S2LrCbALM6AbEZ2Y7OZY6C7lYsAfmcgZ1UnqlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4Q7DNHo6A7EkRj0pTJsarvmrKAGbG8G9SHDrIom414=;
 b=NFjm4OwCPEEjWa2EGERfTSrThp8DHa1+ie/i9jHNN0KDBCxKwCcw9GMG8fWYLAjGmdN0n/e8pxLPwTMIU3LLFh2R/Tg2n9Lli9+9Cj7U+zZ2faxkdeB2/TR3YlNHYu5xmyEHrRZ527T9rx0uL5h/2lsrikveJNrpVdEdCxHePLuDql3E3yMy2CY8tIBg5iPcyimotywRNruSvSmwn1KsVZsqoNUT6yfINFqEjGRzXFRo0NveMSyhbYRxG069UK3TU48MutkRmuKmzz4ydKFzV7uTNKSICHvBB09aqMKmAX0KJdTc1n6FeCHMzsez/vWSMNIusb9w2SR0l8w/LB+JwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4Q7DNHo6A7EkRj0pTJsarvmrKAGbG8G9SHDrIom414=;
 b=bGw3ozLgGznSyhUUWGb0G0caS4RzvcKjYw8sHyw8GZJqJUVY18jROkBttPJIv2MkateR2gdB8e0oP6rLqpFKfRzthR+BNbdMluedEKN/96BFocL6nlWsmV1TjMx9U96adQzNeo0E+Jle8LCbzV7RokSyL/7HyBFJ6lhdml5qjxc=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1246.namprd15.prod.outlook.com (10.175.3.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 00:16:03 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 00:16:03 +0000
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
Thread-Index: AQHVRxC6gG08pF4S5U2u3sEqys7j0abj0y2AgAADSACAAAWvAA==
Date:   Wed, 31 Jul 2019 00:16:03 +0000
Message-ID: <F03F3D79-0FD3-423F-9905-8A093AE2D9AF@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
 <20190730195408.670063-3-andriin@fb.com>
 <9C1CFF6F-F661-46F4-B6EB-B42D7F4204F0@fb.com>
 <CAEf4BzZpcP1aBwrz8DbToQ=nVUukPwiG-PBCFGZNb2wXg_msnA@mail.gmail.com>
In-Reply-To: <CAEf4BzZpcP1aBwrz8DbToQ=nVUukPwiG-PBCFGZNb2wXg_msnA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:5cb8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0937043-33d0-41b8-19c8-08d7154c461a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1246;
x-ms-traffictypediagnostic: MWHPR15MB1246:
x-microsoft-antispam-prvs: <MWHPR15MB1246152DB4D6DA1D23BA3A53B3DF0@MWHPR15MB1246.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(396003)(39860400002)(366004)(199004)(189003)(6506007)(186003)(25786009)(53936002)(102836004)(33656002)(99286004)(50226002)(476003)(8936002)(8676002)(6246003)(256004)(53546011)(81156014)(4326008)(76176011)(6116002)(446003)(68736007)(486006)(2616005)(11346002)(316002)(36756003)(6916009)(66476007)(54906003)(229853002)(6512007)(86362001)(6436002)(81166006)(305945005)(46003)(66946007)(76116006)(57306001)(5660300002)(66556008)(71190400001)(71200400001)(7736002)(478600001)(14454004)(6486002)(2906002)(66446008)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1246;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W23IRC0ETuMh1g0joWyXcs9x+OCVytQ8oxFkRYwV24RLWD9QHybD0PaX0E+38fBPNMxnbF/SDfrD00lw4cWsrUF1Uh9ayGpVPKRAxiix2214zDPwhPu0yoNdC1UhKFrdrgGFLXq0eRnkmzutPt3HhBcWU6HqcO47Rf0sIyDKJa0lFrVcxcBc9m7hsMOhLWMOu0+BgBKIt4X9PULdXvBk5nhOYRW7N0KLiNwHeq+9Q5bTsXUCT4aXNooxfz+Tey6wXdXOO/AhoLrSIAPrY3GlNI0CTOOfTOoc4SamqX2uyiGvb2SStV6j7ZFbhOlQE2zJIyop7F65SOVk5VZaB/9KHPelnN+9W95+HH/K4HOt+BbUM0/20xBm6k49ue8p7bmOCDpKVQja+YuDMZJBscW6Jm3HcuqjlREnVJPvamJLabc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C7DEEE6057B6564C86C212E183F962B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d0937043-33d0-41b8-19c8-08d7154c461a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 00:16:03.2186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2019, at 4:55 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Tue, Jul 30, 2019 at 4:44 PM Song Liu <songliubraving@fb.com> wrote:
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
>>> index ead915aec349..75da90928257 100644
>>> --- a/tools/lib/bpf/libbpf.c
>>> +++ b/tools/lib/bpf/libbpf.c
>>> @@ -38,6 +38,7 @@
>=20
> [...]
>=20
>>>=20
>>> -static const struct btf_type *skip_mods_and_typedefs(const struct btf =
*btf,
>>> -                                                  __u32 id)
>>> +static const struct btf_type *
>>> +skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
>>> {
>>>      const struct btf_type *t =3D btf__type_by_id(btf, id);
>>>=20
>>> +     if (res_id)
>>> +             *res_id =3D id;
>>> +
>>>      while (true) {
>>>              switch (BTF_INFO_KIND(t->info)) {
>>>              case BTF_KIND_VOLATILE:
>>>              case BTF_KIND_CONST:
>>>              case BTF_KIND_RESTRICT:
>>>              case BTF_KIND_TYPEDEF:
>>> +                     if (res_id)
>>> +                             *res_id =3D t->type;
>>>                      t =3D btf__type_by_id(btf, t->type);
>>=20
>> So btf->types[*res_id] =3D=3D retval, right? Then with retval and btf, w=
e can
>> calculate *res_id without this change?
>=20
> Unless I'm missing something very clever here, no. btf->types is array
> of pointers (it's an index into a variable-sized types). This function
> returns `struct btf_type *`, which is one of the **values** stored in
> that array. You are claiming that by having value of one of array
> elements you can easily find element's index? If it was possible to do
> in O(1), we wouldn't have so many algorithms and data structures for
> search and indexing. You can do that only with linear search, not some
> clever pointer arithmetic or at least binary search. So I'm not sure
> what you are proposing here...

oops.. Clearly, I made some silly mistake. Sorry for the noise.=20

Song

>=20
> The way BTF is defined, struct btf_type doesn't know its own type ID,
> which is often inconvenient and requires to keep track of that ID, if
> it's necessary, but that's how it is.
>=20
> But then again, what are we trying to achieve here? Eliminate
> returning id and pointer? I could always return id and easily look up
> pointer, but having both is super convenient and makes code simpler
> and shorter, so I'd like to keep it.
>=20
>>=20
>>>                      break;
>>>              default:
>>> @@ -1044,7 +1051,7 @@ static const struct btf_type *skip_mods_and_typed=
efs(const struct btf *btf,
>>> static bool get_map_field_int(const char *map_name, const struct btf *b=
tf,
>>>                            const struct btf_type *def,
>>>                            const struct btf_member *m, __u32 *res) {
>=20
> [...]

