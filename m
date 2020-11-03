Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BB02A3C53
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgKCF7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:59:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59750 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725953AbgKCF7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:59:34 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A35st56022623;
        Mon, 2 Nov 2020 21:59:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9SL4TvffZnD7EWYyVItbue7DGjAGueLQUZWbqkgOqog=;
 b=Zr0BNBAjjR60Iog/1M/Ws4h8SLTnHnSPQCRmYcyRYXOvEaFlujaVuaVNMqq4ztnBC1gK
 X5wF+8CsPo7uie3ohxG9GVpWXwiDqeSZgKRhsJpqqnDicGvcgIbPG2UNNtLuJaVi8fDu
 60/tdbsjieMR7g0T/0Tikw/F/31lvTt31ZU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34jexxdqxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 21:59:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 21:59:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlMvDC+IE92QJhO3wZxV4tOzWyNal7F2NjT4BTw5QLvsWB0FXs3tunWeRAZXgKhh8tTM84X7yZNCDJUJ301ehp4QnfWRXz/Eaf8b9nf3HO8n2QsZEVqANLkMeYaX3/oUDaVpEbgv+ML9akYP4sSchNCvRpeyHnxXgjFyVY9sTaw1nMYq8qGtIa1Ynfr8tWbb3vWQor/M1MwymRPbWJO0FvRG1NoxxSLFBaK0okuoUZfUlsoXM7X8LDWsnbhzeZIdL4mxXYUS5g9KprQbuPPQ9rSEZ/vrW82XHzK3UNzqaHUeh9OIjpSIPTHTofG9+/eW0J40eCoD9FnLWM4dLXU/NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SL4TvffZnD7EWYyVItbue7DGjAGueLQUZWbqkgOqog=;
 b=Q3w+6eu0oT7KC/66fZl/ce5piFkvwQxYd02KHnWCKO/2ztZW46b4ToCJ+lWKJwnT+ccU6uIoeBu+B1GCKclH/UEO/Mn62mNddwjZQEvVtU+D6lBFakDyA9wAa37RWDZ1zn4QdoORujscm2FotuwuYogHoalmAMFrwEN9UKdRtbBOWNM2PxX1jAaBNGZSGFgZb3na0Fj5+8kOOrnJVk0PLMaP2aPdQpOmIDJTDQviZvEkpXiNBInDwyA1Yv9bOvrPixqFgNyf55rAGx046iAT23uiVcmnB2/B8nA1+B/hy1wt86zqfNcoeqr27Nv+HZ3EoQ3F/I7BQjW1YIVZA8y/fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SL4TvffZnD7EWYyVItbue7DGjAGueLQUZWbqkgOqog=;
 b=D0cLPKhoOihV5MI282tWWq9L0O9yBtkT64Mb1U/T2lVZvxfTsqn2UPdAcHGWiS1wZ/aKqLTh1d4B6jmTA4CKV2GoqQfPKAlRaFolqGzknioPOw5WKO137JCLBRRnhotKK8OmVBktx+cj/jX2ZXQ3CmJjsZoMJ8Hn+fHhqO3crxI=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 05:59:13 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 05:59:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
Thread-Topic: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
Thread-Index: AQHWrY7ZXkKOliwbJ0Kq0MPekL/6Ham1vMIAgAArjoCAAAl7gA==
Date:   Tue, 3 Nov 2020 05:59:13 +0000
Message-ID: <4EEF76DA-2E9F-4B09-BD31-817148CDC445@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-9-andrii@kernel.org>
 <4D4CB508-5358-40B3-878C-30D97BCA4192@fb.com>
 <CAEf4BzaxLMH-ZN+FEhg54J3quGTAHZVg143KWSsD0PFEM5E3yg@mail.gmail.com>
In-Reply-To: <CAEf4BzaxLMH-ZN+FEhg54J3quGTAHZVg143KWSsD0PFEM5E3yg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a091cf64-f8c7-44e5-7f69-08d87fbd9759
x-ms-traffictypediagnostic: BYAPR15MB2999:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB29998A2BAD725B6728EF0113B3110@BYAPR15MB2999.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qLRQZnV+GK5UG/adbx0jQVDUTcq/pk2VLM/x74qz7BS1uj8DiYjcB8lrHk+AEGhakdct352AsPVgeSlsFDu1VpsvhcVNBEjmBE7wODZBFvfdi1OY8HBdNegPOBvifLj7H8rtW+J7x9514Rw/qnixWi/geXBXITm46480xve/mSu/R2ZVCWPv4cHad/zZOlJERcPJxG474LHKgfhz+YVQ2qvnhNeiGB9NifV3Ma+2xePwXoe4Mh1bo6WpsrayYCYWnMypJocYcitzTndTmQnfMK/NreatgFwZU4/i7OYQNt9FKk0rOiTLxYO1PkxrslJRh49rai7g/J0QbYm1aia31w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(346002)(136003)(86362001)(2616005)(83380400001)(6512007)(36756003)(33656002)(6506007)(71200400001)(316002)(53546011)(2906002)(478600001)(186003)(6486002)(5660300002)(66946007)(8676002)(66446008)(54906003)(66476007)(76116006)(6916009)(64756008)(66556008)(8936002)(91956017)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /SOj/Iv6ggzJNQ/fAKjXMT8GCpys/8oRXVAuWMDWyNQBlKtRXGPlddkNR/+w6bsV9+Dl3S0GKy+L1sAFgCHnG2qplC/ynii+c0GrnrOr9wqUI1venzu6fTZPCIHrtEHamIqgZIdvvX3WcBdeESWJwOypPnNwQ+pYrR+AJeI3HAS4saiPauCBqwEh4hZ4k38/1ES+r0CXlfrG43A6tAfHbTgnrL7NH9jp/1GmxdK4i3lSWUDYR5BtN4tTSYbiW+8p57dW3zrJOQXvXZgLzzSLUfYGmC2j+WRsexFlQrfdjYaJMRu61l8MaD+ebANt7GMYLwv+8yzOrkOI9WAKrbNX8ArJd8R3BKBlrRNayDpo5kYbCCgUrkj+POB+274k6ij5S9oPWxjBPaQcR7Bj3mhZgUZiNU7OhKtS+kt5razAc0+xERUpW2i9EFPgXtJZxj2G2l/TzsiFcC6CFcIDvqSAY+Cd2x4+uSlmu0Qxs2qZ3Pjmcnx8bdn9ovsWNYBmhD5N7duxEUmWF6RuMqOg9ZzRKP5cyGX431+y/aMQTCeKl29QQ0Ji5T9+IBr8X9V9geHrxSwU2dhvtxCLiKXTmNvgWlKXDRFzZoqb6gd0l4hAJeHDjeiWQuH0LrKzDGXF9OZ1COdDOnH9PLjZsqEh7kR6G55TB48gHN5buwZlqLMm+2zlqD/QqI2CeQom1dnin4UH
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F07C33AE12EA8F4FAC4BDA1CE73F71B5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a091cf64-f8c7-44e5-7f69-08d87fbd9759
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 05:59:13.6187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e+T2t6b4SIdySI8FsVVdlKudPRmKwgIibr+GGA1jcfEkikDpVkun6ikfSkvREEC476HZpRgSbn21FUNt7/iy1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2999
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 2, 2020, at 9:25 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Mon, Nov 2, 2020 at 6:49 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>>>=20
>>> Add support for deduplication split BTFs. When deduplicating split BTF,=
 base
>>> BTF is considered to be immutable and can't be modified or adjusted. 99=
% of
>>> BTF deduplication logic is left intact (module some type numbering adju=
stments).
>>> There are only two differences.
>>>=20
>>> First, each type in base BTF gets hashed (expect VAR and DATASEC, of co=
urse,
>>> those are always considered to be self-canonical instances) and added i=
nto
>>> a table of canonical table candidates. Hashing is a shallow, fast opera=
tion,
>>> so mostly eliminates the overhead of having entire base BTF to be a par=
t of
>>> BTF dedup.
>>>=20
>>> Second difference is very critical and subtle. While deduplicating spli=
t BTF
>>> types, it is possible to discover that one of immutable base BTF BTF_KI=
ND_FWD
>>> types can and should be resolved to a full STRUCT/UNION type from the s=
plit
>>> BTF part.  This is, obviously, can't happen because we can't modify the=
 base
>>> BTF types anymore. So because of that, any type in split BTF that direc=
tly or
>>> indirectly references that newly-to-be-resolved FWD type can't be consi=
dered
>>> to be equivalent to the corresponding canonical types in base BTF, beca=
use
>>> that would result in a loss of type resolution information. So in such =
case,
>>> split BTF types will be deduplicated separately and will cause some
>>> duplication of type information, which is unavoidable.
>>>=20
>>> With those two changes, the rest of the algorithm manages to deduplicat=
e split
>>> BTF correctly, pointing all the duplicates to their canonical counter-p=
arts in
>>> base BTF, but also is deduplicating whatever unique types are present i=
n split
>>> BTF on their own.
>>>=20
>>> Also, theoretically, split BTF after deduplication could end up with ei=
ther
>>> empty type section or empty string section. This is handled by libbpf
>>> correctly in one of previous patches in the series.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>=20
>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>> With some nits:
>>=20
>>> ---
>>=20
>> [...]
>>=20
>>>=20
>>>      /* remap string offsets */
>>>      err =3D btf_for_each_str_off(d, strs_dedup_remap_str_off, d);
>>> @@ -3553,6 +3582,63 @@ static bool btf_compat_fnproto(struct btf_type *=
t1, struct btf_type *t2)
>>>      return true;
>>> }
>>>=20
>>=20
>> An overview comment about bpf_deup_prep() will be great.
>=20
> ok
>=20
>>=20
>>> +static int btf_dedup_prep(struct btf_dedup *d)
>>> +{
>>> +     struct btf_type *t;
>>> +     int type_id;
>>> +     long h;
>>> +
>>> +     if (!d->btf->base_btf)
>>> +             return 0;
>>> +
>>> +     for (type_id =3D 1; type_id < d->btf->start_id; type_id++)
>>> +     {
>>=20
>> Move "{" to previous line?
>=20
> yep, my bad
>=20
>>=20
>>> +             t =3D btf_type_by_id(d->btf, type_id);
>>> +
>>> +             /* all base BTF types are self-canonical by definition */
>>> +             d->map[type_id] =3D type_id;
>>> +
>>> +             switch (btf_kind(t)) {
>>> +             case BTF_KIND_VAR:
>>> +             case BTF_KIND_DATASEC:
>>> +                     /* VAR and DATASEC are never hash/deduplicated */
>>> +                     continue;
>>=20
>> [...]
>>=20
>>>      /* we are going to reuse hypot_map to store compaction remapping *=
/
>>>      d->hypot_map[0] =3D 0;
>>> -     for (i =3D 1; i <=3D d->btf->nr_types; i++)
>>> -             d->hypot_map[i] =3D BTF_UNPROCESSED_ID;
>>> +     /* base BTF types are not renumbered */
>>> +     for (id =3D 1; id < d->btf->start_id; id++)
>>> +             d->hypot_map[id] =3D id;
>>> +     for (i =3D 0, id =3D d->btf->start_id; i < d->btf->nr_types; i++,=
 id++)
>>> +             d->hypot_map[id] =3D BTF_UNPROCESSED_ID;
>>=20
>> We don't really need i in the loop, shall we just do
>>        for (id =3D d->btf->start_id; id < d->btf->start_id + d->btf->nr_=
types; id++)
>> ?
>>=20
>=20
> I prefer the loop with i iterating over the count of types, it seems
> more "obviously correct". For simple loop like this I could do
>=20
> for (i =3D 0; i < d->btf->nr_types; i++)
>    d->hypot_map[d->start_id + i] =3D ...;
>=20
> But for the more complicated one below I found that maintaining id as
> part of the for loop control block is a bit cleaner. So I just stuck
> to the consistent pattern across all of them.

How about=20

	for (i =3D 0; i < d->btf->nr_types; i++) {
		id =3D d->start_id + i;
		...
?

I would expect for loop with two loop variable to do some tricks, like two=
=20
termination conditions, or another conditional id++ somewhere in the loop.=
=20

Thanks,
Song

