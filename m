Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3DE2A3C10
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgKCFlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:41:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42210 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725953AbgKCFls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:41:48 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A35fXFK004558;
        Mon, 2 Nov 2020 21:41:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4nG9M3Hvery8JerT08XiIcgR6n9rB5w9EkOZBQczOQ8=;
 b=XreoJ+BmP+gD9JqbB0odqS+RJmLYYtQ4MoB1aa63sZpNlY9qWv/anz5HpL+/xRukuyHA
 bF7zd3SUg573rP4qmhJnWeLeB+WTcn8G2/6D7GrfV9A8wWRnjnh9Vfdvt1LwGCa796ew
 6JROLOS58YpvNczwPmtrfXf5JXkqH9hYJHI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34jy1c0juw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 21:41:35 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 21:41:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhyVhUbyHbnwB99+AHy28TT2vfTD1g9AcOPjjFfH52F3CazGej9xs96i6tg6Fc0mHvHQreAMXb92Es4cMVpQ5o3bg3RtVVLpkZO1UBpxGx/HZemjH/0zHJaXDD6RE6VmPDXN9QP6si9fCBcRSMo2oxIcak1wr+IVTo0Du9wRzzl1afNKO9gxRFOndPdGyoYpy9mZ0oYl3X9RFASr6cHsBR1qixJjJqT6wzPfV/auRnebsmKmJWB58j/Woywi4ZLod2Pb5nXhZahuM7H59LyReyV5RTXMPY4eLENUvPMDb/rwXsIXoAb8iwD6hiyPso9cZxFmkOABDM1p7dvW13/Efg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nG9M3Hvery8JerT08XiIcgR6n9rB5w9EkOZBQczOQ8=;
 b=T5csX7DgTHRXEFakuJB4id4uz5oCfsHTHxLN+9x6NOHn77CUTMvUWTJQXKfC+0mJftKoJR93MAE2QmKBXK0n47wD+NwhXwqFP8o2qeFEPnN4uBtbce/9Sv6EgHM9sl3i3sXTDJ5KvS6c+Q0ib/fJVAzps3BB1NJyOrDQvtn98KpH8t9Y9ipyPAVI4Pp3Ty2TSOyb2akHtekzuJvmXn7g5LNYpZNgPmOoGRqyfkGqdY7mOtJTkx8mKry/5fhiGScVjyJnmCfmpJEjuryoCldXxl4NEkpOAsStaS/GdrBX9aUuD8V7x4NvcNfEb3mZBomF2NOKbk+CavVpDAQVal3noA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nG9M3Hvery8JerT08XiIcgR6n9rB5w9EkOZBQczOQ8=;
 b=VyxH99Xtosw+lxpJR79VZnLTtFjRlHl2r1gkx0Z+4bui0O5AxZRLKL74wWvgrB775soWRYjfMspm3FGtWog3fMSUZP+H/1qXXv0PYp4xsx8FBBDXXGdPtRB4zjoFZG4SfRkuMhg3CEPcN5LjJbCDKdXqykOBdKQd/cRsF6JxuIM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 05:41:32 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 05:41:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 04/11] libbpf: implement basic split BTF support
Thread-Topic: [PATCH bpf-next 04/11] libbpf: implement basic split BTF support
Thread-Index: AQHWrY7LDkOlZjem1EymWH+wL8m9Xqm1g0+AgABerQCAAArcAA==
Date:   Tue, 3 Nov 2020 05:41:32 +0000
Message-ID: <80AB5729-CBCA-4306-9048-8E8114EB0A66@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-5-andrii@kernel.org>
 <DE5FDF1D-0E5B-409B-80DF-EDA5349FE3A6@fb.com>
 <CAEf4BzanQsEopXA7cGQi51hf_Q0hNb7NUTvtnkD8xg9AHoU9Ng@mail.gmail.com>
In-Reply-To: <CAEf4BzanQsEopXA7cGQi51hf_Q0hNb7NUTvtnkD8xg9AHoU9Ng@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62572fb9-8924-4063-90c0-08d87fbb1e9f
x-ms-traffictypediagnostic: BYAPR15MB2407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2407F84F9AA0323D89DB108AB3110@BYAPR15MB2407.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c7SuDDfsiPicOSojrPliAA7Pvx2InLsiM2MqWkfoSMla/btxWiHk/wadisQBxNwTO88m9MrNWAWFjIwYSZ2wgvqzQBd1OWXyQr9UXXRpECwjKSQAiNCayRep4x5esMGPQiFwFq/Rk0gsVCqjxNpoRHFd0RRBPVjpOAWAHC6yIlw6zJThLLB40bOS37vRx3ZiGRwP7aIXJaOQnWL7qBhlZBY/4uGsoG7svr2Ca4eJb1bFYAO+U7k9EzOkla2RAKcAmdkb98jsr/FQmK0ldSMrEX4pkXRjGFSv6XSQ0SuVBgatqZqS0FsE2Yr5Khm3WBzPKkO0i6EcS8j3aU9WSVTSoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(6512007)(33656002)(6486002)(8936002)(6506007)(53546011)(2616005)(36756003)(8676002)(186003)(6916009)(5660300002)(83380400001)(66556008)(66946007)(86362001)(2906002)(71200400001)(316002)(54906003)(66476007)(64756008)(478600001)(4326008)(76116006)(91956017)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EsI0ZaHXD4F2SQZI8dJYKuqCo2j2bqct2gfgozqWgTkO9Po2vMsPoMRFO+dr7wB2okCP1zYhetACL1YnmNMPw2w2HEvmASm397YoHW/yATUWqs7mIpvyr4Gw7/Di2WEULF8nI6o1y1L/upcePtQdF4/PXI+oCgWjRIWuGLIGNa0mb3XlxhHXSz3vypb3ByP8eqg/h8/GQhJr2DQO0SomS7HhpeRpTGJIgfhOY44L5C0YZ/DbXzpPrJtIfeheIqey91URsBu5V8TSCnwbCjFdFpPuZVvDJJAic2+26OZ8pv7sRAWfPy+Is2iP8M9e8fxdMybPeddqJMszZpn/3nNIXeBUFdjvpGwmJRV/3SGdBhUoVkqpFZzQn2yuNxSb1JnUNQxyofLxC7jfO2ch6F6g2vYf2CqFxHTxtaaugP2VVgjj0pWFzOmNAn5E6nYRxTW9fFQ5L6ffs/mXBtfbDsEFyQtlJes3/meCKQrjLP3OkVmbN2x1nirV86V18Ms2B81UGsYF/Mz/VSAEQWuV0D4bfZI5jjQ6o4eDjWWjCU4osFRjFXzERx0PUjIeGBv9e1v59M3Fbwnu+v2G3TQA66nQVzKL7h7XzkhC0dxOeBRLPHJagDN+Rfg4RDLt3GaL/ChyF/TP6I68jMXiurSdFFGGoERCTsdGHvZKFriHtqroOPtsGD24IFPRPVFtZ9VcaaAp
Content-Type: text/plain; charset="us-ascii"
Content-ID: <49F90D92E241E445A93F6CC538C44B59@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62572fb9-8924-4063-90c0-08d87fbb1e9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 05:41:32.0461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OTregXkoHg+EY9jZBr5s1xKHBH4y+MU6shhtxJh1ccMRlMM/lstD02VKnF/uJBkqyXaGidgTr5ZAhtE3y25kiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 2, 2020, at 9:02 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Mon, Nov 2, 2020 at 3:24 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>>>=20
>>=20
>> [...]
>>=20
>>>=20
>>> BTF deduplication is not yet supported for split BTF and support for it=
 will
>>> be added in separate patch.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>=20
>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>> With a couple nits:
>>=20
>>> ---
>>> tools/lib/bpf/btf.c      | 205 ++++++++++++++++++++++++++++++---------
>>> tools/lib/bpf/btf.h      |   8 ++
>>> tools/lib/bpf/libbpf.map |   9 ++
>>> 3 files changed, 175 insertions(+), 47 deletions(-)
>>>=20
>>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>>> index db9331fea672..20c64a8441a8 100644
>>> --- a/tools/lib/bpf/btf.c
>>> +++ b/tools/lib/bpf/btf.c
>>> @@ -78,10 +78,32 @@ struct btf {
>>>      void *types_data;
>>>      size_t types_data_cap; /* used size stored in hdr->type_len */
>>>=20
>>> -     /* type ID to `struct btf_type *` lookup index */
>>> +     /* type ID to `struct btf_type *` lookup index
>>> +      * type_offs[0] corresponds to the first non-VOID type:
>>> +      *   - for base BTF it's type [1];
>>> +      *   - for split BTF it's the first non-base BTF type.
>>> +      */
>>>      __u32 *type_offs;
>>>      size_t type_offs_cap;
>>> +     /* number of types in this BTF instance:
>>> +      *   - doesn't include special [0] void type;
>>> +      *   - for split BTF counts number of types added on top of base =
BTF.
>>> +      */
>>>      __u32 nr_types;
>>=20
>> This is a little confusing. Maybe add a void type for every split BTF?
>=20
> Agree about being a bit confusing. But I don't want VOID in every BTF,
> that seems sloppy (there's no continuity). I'm currently doing similar
> changes on kernel side, and so far everything also works cleanly with
> start_id =3D=3D 0 && nr_types including VOID (for base BTF), and start_id
> =3D=3D base_btf->nr_type && nr_types has all the added types (for split
> BTF). That seems a bit more straightforward, so I'll probably do that
> here as well (unless I'm missing something, I'll double check).

That sounds good.=20

>=20
>>=20
>>> +     /* if not NULL, points to the base BTF on top of which the curren=
t
>>> +      * split BTF is based
>>> +      */
>>=20
>> [...]
>>=20
>>>=20
>>> @@ -252,12 +274,20 @@ static int btf_parse_str_sec(struct btf *btf)
>>>      const char *start =3D btf->strs_data;
>>>      const char *end =3D start + btf->hdr->str_len;
>>>=20
>>> -     if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET ||
>>> -         start[0] || end[-1]) {
>>> -             pr_debug("Invalid BTF string section\n");
>>> -             return -EINVAL;
>>> +     if (btf->base_btf) {
>>> +             if (hdr->str_len =3D=3D 0)
>>> +                     return 0;
>>> +             if (hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1]) {
>>> +                     pr_debug("Invalid BTF string section\n");
>>> +                     return -EINVAL;
>>> +             }
>>> +     } else {
>>> +             if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSE=
T ||
>>> +                 start[0] || end[-1]) {
>>> +                     pr_debug("Invalid BTF string section\n");
>>> +                     return -EINVAL;
>>> +             }
>>>      }
>>> -
>>>      return 0;
>>=20
>> I found this function a little difficult to follow. Maybe rearrange it a=
s
>>=20
>>        /* too long, or not \0 terminated */
>>        if (hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1])
>>                goto err_out;
>=20
> this won't work, if str_len =3D=3D 0. Both str_len - 1 will underflow, an=
d
> end[-1] will be reading garbage
>=20
> How about this:
>=20
> if (btf->base_btf && hdr->str_len =3D=3D 0)
>    return 0;
>=20
> if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1])
>    return -EINVAL;
>=20
> if (!btf->base_btf && start[0])
>    return -EINVAL;
>=20
> return 0;
>=20
> This seems more straightforward, right?

Yeah, I like this version. BTW, short comment for each condition will be
helpful.


