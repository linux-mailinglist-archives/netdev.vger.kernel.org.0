Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02652A4C7E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgKCRQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:16:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57350 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727530AbgKCRQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:16:17 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3HFiIi021088;
        Tue, 3 Nov 2020 09:16:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+YDdL47IugvHH7Uqk7GROx67nXFM7UU6Z/TJsoL5FoU=;
 b=Sb/E5XPazVIU02VO7Dzm8Ty2ya//4sXmbb73EjuXre46o4yCSIqA/B2StUAe/UXct7v6
 ihradLYoiraZ0y0vH2QddmP/utrwjRw7UqR1oU5/0nClv2mykKbK18IgWm9WP9uDN8Vg
 rtDEJeCKiB1Rk+oFcsSWaHmSYrlt7n4YkaY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34jy1c3pfd-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 03 Nov 2020 09:16:01 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 3 Nov 2020 09:15:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuNfPTW4JIAdDwVBQlbZlq0ibPJo+5a5lDM5+cW78myPka64QnUwaEo1/sdwyaUdbwbRaXOKXVYtusa+XlhgpWnswkxt1L81POFsQoG4ykerU1H/M5aKwbkkFCcTJD4u0Vo/5xT2ZkiwbcVZGDuwmAiF3wjYWiCBiFYDjIvqbnEFTExduMIfOItsPPshUFYo/ySXJFqIjJYSu+PtdeNT0vCDw9foVbdMdgEk13+CfwD/eOolFuyGsow4UUWTcq04zEYdWsEdJGls1s4Tnhz5VGoFsZSaPjTY57G5Fcem28rIfkqP4qyj9FLJKB4l0LwJOQz5rzPJEcoZbagkNtijgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YDdL47IugvHH7Uqk7GROx67nXFM7UU6Z/TJsoL5FoU=;
 b=Gxo2vmqiILgs8ciz5uEp5tGFMJNOiyGCbxWLNaV3A41I5MpvvnP63ptSfel9Y8OAeSZjJAKMrdzzf8epzm4GWuzLFuJLhInk+Jvpa39xNK8+HzqyazDRlqbfo75uo3c4bx/SLpyoO/JAupn/I6iLAklbEJ9ZDSxNcvL9HsAon8FdVcLWZc1VRTs3mphH1el84CxA4UdDOkPjBbWjz0+5kGfM2nJ/ZUeaewxgQ+PNUVz8zlZEtZxKSusx09p+XGn0cGu8vVV9T6LWaFc4BzjSCMLl44eW90dFv1pof3XyETYyrMDU/9o4329kuw/aubdCpL5wsT0AhsA95izcT7R8rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YDdL47IugvHH7Uqk7GROx67nXFM7UU6Z/TJsoL5FoU=;
 b=XRcF8Cle2bo5HRY0+8MN7wkby2T0QmZpDLNOK3Gus9GcPVb8EtLhQdUsYACNf5NIb2s0qTRFw3Zuoq+Scz5B8tZ8GD2bflYttco8loalNaEyCBQNRg3iR1zreJpl6uk7DaYbH4K4FP6+y69rvQu77OsnC1HphvSdU1xNCopcjVo=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Tue, 3 Nov
 2020 17:15:54 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 17:15:54 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
Thread-Topic: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
Thread-Index: AQHWrY7ZXkKOliwbJ0Kq0MPekL/6Ham1vMIAgAArjoCAAAl7gIAACQIAgAC0DYA=
Date:   Tue, 3 Nov 2020 17:15:54 +0000
Message-ID: <E2960A61-279C-4B52-AB63-C8E87D2905A6@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-9-andrii@kernel.org>
 <4D4CB508-5358-40B3-878C-30D97BCA4192@fb.com>
 <CAEf4BzaxLMH-ZN+FEhg54J3quGTAHZVg143KWSsD0PFEM5E3yg@mail.gmail.com>
 <4EEF76DA-2E9F-4B09-BD31-817148CDC445@fb.com>
 <CAEf4BzaL51nf_rKF7-pUWHeCiWm37fuFGfku4Z0kmXxmdHRAVA@mail.gmail.com>
In-Reply-To: <CAEf4BzaL51nf_rKF7-pUWHeCiWm37fuFGfku4Z0kmXxmdHRAVA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:ca49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c76e4b08-7f2f-4878-258f-08d8801c1f51
x-ms-traffictypediagnostic: BYAPR15MB2566:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2566E185F9C0C9E5F72F0326B3110@BYAPR15MB2566.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6xXpPxPcZB+tS9QZC+H2pdxvqXtpwcy5P3vUTDvjx/grtWTREswZHVLOLEO7yeFMoLM7d+WuZWjlDf5Y07QybVyN1p6SpIz/mDCGJ1yUlprmFOYuywx4CfU9o0SCVEHztIUaAB9b6EGyN6uRM+8WB0BsCsM4yJLZHHpSYKi607WXGY9ypIeMp+k6ohzWSjc7mZPhsEOQLSUoQCTeVhLKdk6Fp9vkFANsfMflGlVxDBhylkWtUuZG+1S3uTkZtskOgfmR4F8G7RIFkJQfovvHnZsqGmtLKmiWvIB31KvA9AKjDRFD8OkW755jhKbwkYJ7JfrBEw56S4NN7BYfIck+Fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(346002)(136003)(64756008)(8676002)(6486002)(66446008)(66476007)(8936002)(66946007)(66556008)(186003)(36756003)(54906003)(83380400001)(2616005)(6512007)(76116006)(91956017)(6506007)(6916009)(53546011)(2906002)(71200400001)(478600001)(4326008)(86362001)(5660300002)(33656002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PgQT6/wedyWJkmX1QE8DEii0CnHbUPHRdTV3S8XSfVUonXGVtp/U1dGH2GOJ27gkaZkujjmVHFBP7VPYGZKO7DYYvhjENQ68bVeuLROsYX5Lyu0Ie23KvEqtdPQJynFm4BTh3/n1ffo9F6kRIs/Djdu18vdgsY0pTwVp+XZAOzmhBKOib6iD/8b21HnrKWTTMKz9SugcdaN6e0eugOwcsgaO/3EyV4+7PYVdSZAdoih+zkeYLIsRtewvCiryHpB5crV2h2a3d90sFpZW+rLU/ZUt/5lZ/66+7Zs0RnNIWe383XE1iHfkR9hD4bzf4akOvpGYybvlEznYlzSP0IJsFzxV6iGV9s287Oa5xJ1NRAVuJiCgCZ306faVUauTZKV+m13o3PgX0687D7fCAmUJ80xm8BUp2bqRQye4jp2x8f9ciWYaOmZqgYWBNmm05bTGd8mUHpW6UBD99KGCDapZaRBqAnwcRnY7ZSzMq43R5K0FjfSk2KIl38LxyyZS5UdNLemgjLgtIgf+p46ex3cLzG2ihr2deuJxQbBBiEQ1Z54IUmOuPp5VJdcsyB3xMgR3oa4lwp8Wwa8g4RmRa63K9Ojns9PDg1gOeBaLL89w+pzhKhKveFl3q6wwz8wMadpj4GWoYFFZ+SAzbkkeLrasslFbBx1yJ8tdnAPdor3We/9iysO4W1PT4XRYlTwo0Hlq
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9B17A8BC00923F4E8B9A8319C334D0A0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c76e4b08-7f2f-4878-258f-08d8801c1f51
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 17:15:54.3937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wwcfunv4sMUVWTJJkWrnL1E+V9QalPuy6XjujhlTrRpFk/3igyyQuN89ueRX7a3iZWZqp0fC5nhOvXMrDvJdrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_08:2020-11-03,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 2, 2020, at 10:31 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Mon, Nov 2, 2020 at 9:59 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Nov 2, 2020, at 9:25 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>>>=20
>>> On Mon, Nov 2, 2020 at 6:49 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrot=
e:
>>>>>=20
>>>>> Add support for deduplication split BTFs. When deduplicating split BT=
F, base
>>>>> BTF is considered to be immutable and can't be modified or adjusted. =
99% of
>>>>> BTF deduplication logic is left intact (module some type numbering ad=
justments).
>>>>> There are only two differences.
>>>>>=20
>>>>> First, each type in base BTF gets hashed (expect VAR and DATASEC, of =
course,
>>>>> those are always considered to be self-canonical instances) and added=
 into
>>>>> a table of canonical table candidates. Hashing is a shallow, fast ope=
ration,
>>>>> so mostly eliminates the overhead of having entire base BTF to be a p=
art of
>>>>> BTF dedup.
>>>>>=20
>>>>> Second difference is very critical and subtle. While deduplicating sp=
lit BTF
>>>>> types, it is possible to discover that one of immutable base BTF BTF_=
KIND_FWD
>>>>> types can and should be resolved to a full STRUCT/UNION type from the=
 split
>>>>> BTF part.  This is, obviously, can't happen because we can't modify t=
he base
>>>>> BTF types anymore. So because of that, any type in split BTF that dir=
ectly or
>>>>> indirectly references that newly-to-be-resolved FWD type can't be con=
sidered
>>>>> to be equivalent to the corresponding canonical types in base BTF, be=
cause
>>>>> that would result in a loss of type resolution information. So in suc=
h case,
>>>>> split BTF types will be deduplicated separately and will cause some
>>>>> duplication of type information, which is unavoidable.
>>>>>=20
>>>>> With those two changes, the rest of the algorithm manages to deduplic=
ate split
>>>>> BTF correctly, pointing all the duplicates to their canonical counter=
-parts in
>>>>> base BTF, but also is deduplicating whatever unique types are present=
 in split
>>>>> BTF on their own.
>>>>>=20
>>>>> Also, theoretically, split BTF after deduplication could end up with =
either
>>>>> empty type section or empty string section. This is handled by libbpf
>>>>> correctly in one of previous patches in the series.
>>>>>=20
>>>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>>>=20
>>>> Acked-by: Song Liu <songliubraving@fb.com>
>>>>=20
>>>> With some nits:
>>>>=20
>>>>> ---
>>>>=20
>>>> [...]
>>>>=20
>>>>>=20
>>>>>     /* remap string offsets */
>>>>>     err =3D btf_for_each_str_off(d, strs_dedup_remap_str_off, d);
>>>>> @@ -3553,6 +3582,63 @@ static bool btf_compat_fnproto(struct btf_type=
 *t1, struct btf_type *t2)
>>>>>     return true;
>>>>> }
>>>>>=20
>>>>=20
>>>> An overview comment about bpf_deup_prep() will be great.
>>>=20
>>> ok
>>>=20
>>>>=20
>>>>> +static int btf_dedup_prep(struct btf_dedup *d)
>>>>> +{
>>>>> +     struct btf_type *t;
>>>>> +     int type_id;
>>>>> +     long h;
>>>>> +
>>>>> +     if (!d->btf->base_btf)
>>>>> +             return 0;
>>>>> +
>>>>> +     for (type_id =3D 1; type_id < d->btf->start_id; type_id++)
>>>>> +     {
>>>>=20
>>>> Move "{" to previous line?
>>>=20
>>> yep, my bad
>>>=20
>>>>=20
>>>>> +             t =3D btf_type_by_id(d->btf, type_id);
>>>>> +
>>>>> +             /* all base BTF types are self-canonical by definition =
*/
>>>>> +             d->map[type_id] =3D type_id;
>>>>> +
>>>>> +             switch (btf_kind(t)) {
>>>>> +             case BTF_KIND_VAR:
>>>>> +             case BTF_KIND_DATASEC:
>>>>> +                     /* VAR and DATASEC are never hash/deduplicated =
*/
>>>>> +                     continue;
>>>>=20
>>>> [...]
>>>>=20
>>>>>     /* we are going to reuse hypot_map to store compaction remapping =
*/
>>>>>     d->hypot_map[0] =3D 0;
>>>>> -     for (i =3D 1; i <=3D d->btf->nr_types; i++)
>>>>> -             d->hypot_map[i] =3D BTF_UNPROCESSED_ID;
>>>>> +     /* base BTF types are not renumbered */
>>>>> +     for (id =3D 1; id < d->btf->start_id; id++)
>>>>> +             d->hypot_map[id] =3D id;
>>>>> +     for (i =3D 0, id =3D d->btf->start_id; i < d->btf->nr_types; i+=
+, id++)
>>>>> +             d->hypot_map[id] =3D BTF_UNPROCESSED_ID;
>>>>=20
>>>> We don't really need i in the loop, shall we just do
>>>>       for (id =3D d->btf->start_id; id < d->btf->start_id + d->btf->nr=
_types; id++)
>>>> ?
>>>>=20
>>>=20
>>> I prefer the loop with i iterating over the count of types, it seems
>>> more "obviously correct". For simple loop like this I could do
>>>=20
>>> for (i =3D 0; i < d->btf->nr_types; i++)
>>>   d->hypot_map[d->start_id + i] =3D ...;
>>>=20
>>> But for the more complicated one below I found that maintaining id as
>>> part of the for loop control block is a bit cleaner. So I just stuck
>>> to the consistent pattern across all of them.
>>=20
>> How about
>>=20
>>        for (i =3D 0; i < d->btf->nr_types; i++) {
>>                id =3D d->start_id + i;
>>                ...
>> ?
>=20
> this would be excessive for that single-line for loop. I'd really like
> to keep it consistent and confined within the for () block.
>=20
>>=20
>> I would expect for loop with two loop variable to do some tricks, like t=
wo
>> termination conditions, or another conditional id++ somewhere in the loo=
p.
>=20
> Libbpf already uses such two variable loops for things like iterating
> over btf_type's members, enums, func args, etc. So it's not an
> entirely alien construct. I really appreciate you trying to keep the
> code as simple and clean as possible, but I think it's pretty
> straightforward in this case and there's no need to simplify it
> further.

No problem. It was just a nitpick. The loop is totally fine as is.=20

Thanks,
Song=
