Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D72AE091
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 21:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbgKJUPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 15:15:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgKJUPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 15:15:36 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AAKB0OB012451;
        Tue, 10 Nov 2020 12:15:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=l4+HGW6pv16Y4kVQ+odQkYi5Mk8cEYnSczftgc4O7/k=;
 b=mqI4aJ0yp9Bi2KLWpyo4cnkF32BRYDaAWRdaEr+HGC/YgMD9OozUgEwIx75W+BCsIGTn
 N5YWigibGHn5O06o7Mu9BvoynuzBn8Mp4DlftYg6SRxe1Sqx6vYJhU+tpPK392YEOtuS
 OjCCIpycSTfgZREKBhCuZ/EYzgccdD4CY6k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34pch9vs1b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 12:15:19 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 12:15:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzcqIkmJrvbO0NpNES56CvO9Z9FTeyPOJLdz8cZMqHvPuQgwqsL/eB2xT6zekSUtBl5SWJ+Bd7VS3I+2jG9tveUMWK1/83RABQnaSFnPsUycrCtImsEBpVKBvqX4nWnoQGWuHWHDya42VMdjT97Djbhxyy81sTaSpqjfPPGYNN8Lf+xD0C53ERy3UmSJUxZy3h+LZ+vT6awPCDkf83yBxjhmRgQMO23lfH6PRYikrH7rfo2o5DwKYbehhzMQOqS2LvOY6nPESctMlzSX0kV7NRtX73Y7f6zhGCrr96oLkIcdWyCLSmb21VivQuEKjDTUsZWU+3vsS3CTOt54JdRHgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4+HGW6pv16Y4kVQ+odQkYi5Mk8cEYnSczftgc4O7/k=;
 b=fKT3AnfXZBZXVkso0PdUxSuEIkgmfa43cu+2fiJ+2EaPaxCQFOTe7VL/Us7HztSBm8P3/D4oPHNRlgY2trF5t/jSRzeES1GWqaI4EM0+htGH0mCLMLEw6EZEjcY9waqQ9by7AqU7+L2rSvhq3HSiS4CzoEGkCi29e21ftw4LVi4579KbPuIsY9LREMcw2Ht5qO86lN6mkl10Ctfl+rk4Bvahwl9Ijl+kBINfS1nERxlg6tj96k4/RGauCklqXZWPmurnRyAxTNeB/c19J+tIMPADmvf5fVps+ja9Onm0MlpatP64u5/gejfiFuQn2Z/Lr5P6bbeHPaKqkRsv6Xd/Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4+HGW6pv16Y4kVQ+odQkYi5Mk8cEYnSczftgc4O7/k=;
 b=D0V5Jf/I6I9nUjRzYLmgbUtd6ZF4yYuYHlyI3qwqiNAQ/6+z3A5VhTQ2JSKGNX4SOjjpb78bs4YSZzqE4Tt24lTJVEjAA9bl/4B7DGB7OP3tqzTuZT7fnTFMnQHQwmWVfeXwA/2pglwt7xdHoLGLldo8C3W2zvXcbfi2IguQByc=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2824.namprd15.prod.outlook.com (2603:10b6:a03:158::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Tue, 10 Nov
 2020 20:14:54 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 20:14:54 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 bpf-next 1/5] bpf: add in-kernel split BTF support
Thread-Topic: [PATCH v4 bpf-next 1/5] bpf: add in-kernel split BTF support
Thread-Index: AQHWtwAHoXtpfdzO80ynz0OJjXLTl6nBpcmAgAALm4CAABzogA==
Date:   Tue, 10 Nov 2020 20:14:54 +0000
Message-ID: <E26C39E9-51C4-4E31-87AC-69CADE54A15F@fb.com>
References: <20201110011932.3201430-1-andrii@kernel.org>
 <20201110011932.3201430-2-andrii@kernel.org>
 <695E976D-DECA-4BE1-BFB0-771878B9CFCD@fb.com>
 <CAEf4BzYORuxNUvJDTe4cPvJ18HNhFDOuYGfLdUzuwHeddVLw6Q@mail.gmail.com>
In-Reply-To: <CAEf4BzYORuxNUvJDTe4cPvJ18HNhFDOuYGfLdUzuwHeddVLw6Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1f7d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a58e7411-a231-4a7d-5809-08d885b54983
x-ms-traffictypediagnostic: BYAPR15MB2824:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB28240C8C8DBDC61A0D153D02B3E90@BYAPR15MB2824.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kYyYfe3qPDuWjKT7Nd9klzc5fFPY4q/ylOtE5cSBL1U6htGU6jE4liwOfw1uhSeBaj2a5KhqyiyR05haUEsYUft1vZl0pnrqYQld8IoXQZSUjopZyCOw1N22WFsdbwMEgiANidb5SdqU7j5nXG5Iu2KHk8XOL++5lgStP8ZdmaYKWlof+wM5pxlib/GEeNRhUr5Y6uWM6KEaA5tQL8Zbsq5xjsUQbp5LWxlRkxQPBZJ2nD96NM2l8+9pRzMmLa4MOaGNUmRATK3a3kc5vBTPMhL94FtAhgTI9vz+WtGqi2Kk3S2VX+nPBmzUGWxei0WOPI+NaucS9OLZVUT3tiliKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(36756003)(8676002)(33656002)(2616005)(8936002)(6512007)(2906002)(478600001)(54906003)(86362001)(6916009)(316002)(6506007)(6486002)(186003)(83380400001)(53546011)(7416002)(5660300002)(66476007)(91956017)(66446008)(64756008)(66946007)(76116006)(66556008)(71200400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YSeInd7LqHPm6umxjiHvMhI46/WJxVKfmUvAbvpSYzpiSumqkkuHxFTzldwuvjU8n2EgP9gpZXezcS9FZpIRDGPyvooVhoaRbqhZAngBiFjXwYspby7Ube/AmnQxAlFe6npvuPSuZV1sJwoqd63uGVjcrfQLiclZ3ESDK0AzjBshzxB58PivRvNipuzQFj4QHIsNFgaHqtogAfmJRJjxbCYBBw9c9J9OysZaHGOIETUwQT6b4ifIY64w/FKOkdF18zua6yr+sIiX7lkjc3MxIWUjd6Oxq0k2hYuG0LTi6wtU3SQv1jh/VzAFhvkydv+CGeAX2igm8G5J6lBAExOwKuWzD0MSopmdC2JwZ97I4XxmvKk5B/g611RdIzpY9YJADaQ15FVh5LjaxNlgksYmEv7eGF7aiZMxbqCkrNC7nrUOgJwn25wJqv6XtqsX1r3EvYrpAki2+bDAi5qWnunWwgx+spnzLcJPsRbLmMgoPKD4Z0Pe13bNMtqumR7OEEiYXiF+3v5J690oJCgRKkhQfSqQycSC/nKIBQC2oCl8VH1FDC/tHyt11PIW5f+VY3DF8N5ANd/XVp15AqSmZOfz7j9LX7zGCbtX5qDh+ZT0SASDHonvOUJCn5mhb1g2cHXALBCG9DOOZZfhclq87/QgwtAKGheDnKnUkWGP32r8+6Q4yK4k6j6n4wsfsfQ1AvKNd8+A44D+8fiewb93y41ymee5BeAbB9pFQ5y7rPrVAuV++dpAcWg6pF75UrKa77baQxRFHDRBDVxs7VnB8H0tzcH7puBKlm28W57dC1mCNFIihyD6zPVwvjBdyJFpgJHKXZ1VQ2upEDldwtjMS/WyTARXPxtK6Tf3vXf5JRhAL65i0u4g4PTo7bFw94v3WDRAysaLB9ki0wK501XMASJlsTglMjaQWDa8ESF0S7aPZ3s=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15F7E46AD723EA4397CC868834F59A4D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a58e7411-a231-4a7d-5809-08d885b54983
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 20:14:54.1424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mn0a/BFmmCtu9cAVlJ5CF+jFI7uoTaFUFLAHnuG9M86Y/C+AAiVv88tr6TXOvukONkwur4OfC/XEfLdkcvImYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2824
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_07:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100137
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 10, 2020, at 10:31 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Tue, Nov 10, 2020 at 9:50 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>>>=20
>>> Adjust in-kernel BTF implementation to support a split BTF mode of oper=
ation.
>>> Changes are mostly mirroring libbpf split BTF changes, with the excepti=
on of
>>> start_id being 0 for in-kernel implementation due to simpler read-only =
mode.
>>>=20
>>> Otherwise, for split BTF logic, most of the logic of jumping to base BT=
F,
>>> where necessary, is encapsulated in few helper functions. Type numberin=
g and
>>> string offset in a split BTF are logically continuing where base BTF en=
ds, so
>>> most of the high-level logic is kept without changes.
>>>=20
>>> Type verification and size resolution is only doing an added resolution=
 of new
>>> split BTF types and relies on already cached size and type resolution r=
esults
>>> in the base BTF.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> ---
>>> kernel/bpf/btf.c | 171 +++++++++++++++++++++++++++++++++--------------
>>> 1 file changed, 119 insertions(+), 52 deletions(-)
>>>=20
>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>>> index 6324de8c59f7..727c1c27053f 100644
>>> --- a/kernel/bpf/btf.c
>>> +++ b/kernel/bpf/btf.c
>>> @@ -203,12 +203,17 @@ struct btf {
>>>      const char *strings;
>>>      void *nohdr_data;
>>>      struct btf_header hdr;
>>> -     u32 nr_types;
>>> +     u32 nr_types; /* includes VOID for base BTF */
>>>      u32 types_size;
>>>      u32 data_size;
>>>      refcount_t refcnt;
>>>      u32 id;
>>>      struct rcu_head rcu;
>>> +
>>> +     /* split BTF support */
>>> +     struct btf *base_btf;
>>> +     u32 start_id; /* first type ID in this BTF (0 for base BTF) */
>>> +     u32 start_str_off; /* first string offset (0 for base BTF) */
>>> };
>>>=20
>>> enum verifier_phase {
>>> @@ -449,14 +454,27 @@ static bool btf_type_is_datasec(const struct btf_=
type *t)
>>>      return BTF_INFO_KIND(t->info) =3D=3D BTF_KIND_DATASEC;
>>> }
>>>=20
>>> +static u32 btf_nr_types_total(const struct btf *btf)
>>> +{
>>> +     u32 total =3D 0;
>>> +
>>> +     while (btf) {
>>> +             total +=3D btf->nr_types;
>>> +             btf =3D btf->base_btf;
>>> +     }
>>> +
>>> +     return total;
>>> +}
>>> +
>>> s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 k=
ind)
>>> {
>>>      const struct btf_type *t;
>>>      const char *tname;
>>> -     u32 i;
>>> +     u32 i, total;
>>>=20
>>> -     for (i =3D 1; i <=3D btf->nr_types; i++) {
>>> -             t =3D btf->types[i];
>>> +     total =3D btf_nr_types_total(btf);
>>> +     for (i =3D 1; i < total; i++) {
>>> +             t =3D btf_type_by_id(btf, i);
>>>              if (BTF_INFO_KIND(t->info) !=3D kind)
>>>                      continue;
>>>=20
>>> @@ -599,8 +617,14 @@ static const struct btf_kind_operations *btf_type_=
ops(const struct btf_type *t)
>>>=20
>>> static bool btf_name_offset_valid(const struct btf *btf, u32 offset)
>>> {
>>> -     return BTF_STR_OFFSET_VALID(offset) &&
>>> -             offset < btf->hdr.str_len;
>>> +     if (!BTF_STR_OFFSET_VALID(offset))
>>> +             return false;
>>> +
>>> +     while (offset < btf->start_str_off)
>>> +             btf =3D btf->base_btf;
>>=20
>> Do we need "if (!btf) return false;" in the while loop? (and some other =
loops below)
>=20
> No, because for base btf start_str_off and start_type_id are always
> zero, so loop condition is always false.

Ah, I misread the code. Thanks for the explanation.=20

Acked-by: Song Liu <songliubraving@fb.com>=
