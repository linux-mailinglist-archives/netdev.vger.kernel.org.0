Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319462765F4
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgIXBkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:40:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725208AbgIXBkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:40:36 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08O1Kvot026154;
        Wed, 23 Sep 2020 18:21:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uVSTDStb6yWsOlOE0thMhgBQUUDFL9wesKbZW9R7w3s=;
 b=FwMH+YYVMIFIMVYlFdg3DUlE6kcgOj3hcrxqlMFtgtkHVJnC/ZbNdlcX4K2xaIncyBrf
 te6icX5HsFOmIOLjCcPigvqWMoGH9iWUFt36g49AN/UFOIrDm3MrSpXJ64f2mzn/uthN
 7Qe1PRHKjyfXajFVtDg0uxzSkI3oUq2dVzU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33qsp4y2cc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 18:21:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 18:20:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvxBswYCFVc3a7skGtOlegiDRWmeMnZXu/bf277yYeHEZ6XRccEXA3YFTcuK6OZ3xKqNdB36KAc/JWgJ6MDe8wTFXvYATwvCdnDcUnDKyOdvPIjU2oyFdCpmKnheU+doTujqxQO2SXdHNPa5pDb6Yiiz4Y7TXKc92LrfgaxaPvCwPWHk8GfkfW+JQPZBBxYB96U0eb1IAmPsxyrhshjDtGbXpDjbS8BMrZgjcVVQsBh1Y0nsScq0B9DERfW0Z3wvS16wfUvTb9Wjxh1NYF3vU64F+LeSKckhpUsWdNTdOECcM6OTRiW8Sywf/ep0FYOGGwrO+RGUp8Wl/Brrb7i/7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVSTDStb6yWsOlOE0thMhgBQUUDFL9wesKbZW9R7w3s=;
 b=aHcIswZwKCc3fdY9Vz5wTqplIiIcn3jXyhp0nMfJf55W+BxQdY43/cLEgARUepSxLNdOp2/EvtGSuBnUU/pU9ufj6jCfshtjlCuuZEj5C+Cmf9M53w/cJEx605Rb8vqNwit1jW3AMXq6pM6Xz5M8vjkszOY2wYdo2heOC826H1N6ylPZban6pDM4mwdFttBBIc9sBpKj8flbi29E8WV5hl8Si1yhfFeBF80Rq9pPkOiqce4CgahleE3L1zMKJp8OQFp5J7srVd2EFqTnV9faxKjOiSGuw3RqlhZVmynOUQMY6Eu7c8WpnjZN8VHlJLEe2UVAsBA4zgQeT7P9cxh6Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVSTDStb6yWsOlOE0thMhgBQUUDFL9wesKbZW9R7w3s=;
 b=VTm2UJmjfVR6vHViUm3Vgq5BC2fQ8tOJS9PBfmNXdwDIQYHAkmZPUDMg2PwvWSpdwyl2Z6TlfQIgXKlpJWvXBaQum6qOXveqxi/w3QB3L+GCC628R7P10ajmYHDjd5Qw+kCuH636F4Ifl6/1hsc2DbckM3qyP2W7cfvfI+gsuFw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3366.namprd15.prod.outlook.com (2603:10b6:a03:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Thu, 24 Sep
 2020 01:20:57 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Thu, 24 Sep 2020
 01:20:57 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: introduce
 bpf_prog_test_run_xattr_opts
Thread-Topic: [PATCH v2 bpf-next 2/3] libbpf: introduce
 bpf_prog_test_run_xattr_opts
Thread-Index: AQHWkco0dkq2Yhl5xU64KxjjZzD8DKl2nMkAgABJOwCAABWWAIAAArkA
Date:   Thu, 24 Sep 2020 01:20:56 +0000
Message-ID: <DD0ABBCE-A24E-4058-B79F-62EEDE558A15@fb.com>
References: <20200923165401.2284447-1-songliubraving@fb.com>
 <20200923165401.2284447-3-songliubraving@fb.com>
 <CAEf4BzZ-qPNjDEvviJKHfLD7t7YJ97PdGixGQ_f70AJEg5oVEg@mail.gmail.com>
 <540DD049-B544-4967-8300-E743940FD6FC@fb.com>
 <CAEf4BzYDsBMmBBtgauqdR9HYDeRG-GbMMTG6FUDbpWgOuU_Ljg@mail.gmail.com>
In-Reply-To: <CAEf4BzYDsBMmBBtgauqdR9HYDeRG-GbMMTG6FUDbpWgOuU_Ljg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebbd6531-6057-4ccf-a899-08d8602816dd
x-ms-traffictypediagnostic: BYAPR15MB3366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33664EC5ABAE704BBB3CDE2BB3390@BYAPR15MB3366.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mtc8qe77J5nU8dAJwgF3LCSPsEO6TTn2ZtM7RKxm28eixUlsHf6zWj9nxhaQ5AxaPzA+6Ej58UU+nRG6PrXyUPoTnF5q/L0p/5E3lnRzWOOYxyRyAnn8EuxyIxxIuudVOUNbx8h24aEPRo9YLyzha16vmct0gXniE6RFF8FgwOmf9fw6XHGaVlCzWFAJ5G1CNh52bUzSeBeaJwfd5vz3x411KhatlruSWa3ZFP7yaQr1Po14Qm63i8Jgv0uGr7F5Q/T+hNaeqxkJYe1Dyj03etyUPp7fdbtEtEdLAb2nCfopfeS1eHujsQrq0WeCACzrBvGSr7n1VH8vGUrgXi9NtKZNP6G6EVGkRp+dA5/fn0Hotaj6qcCS2h7cx5K8zfbEYrVWUnthb4+01jKK8lSlsP4xwrTueloZK1d4KH1geFk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(346002)(366004)(2616005)(66446008)(478600001)(91956017)(2906002)(8936002)(64756008)(66946007)(316002)(186003)(8676002)(6506007)(53546011)(66476007)(6512007)(36756003)(66556008)(71200400001)(33656002)(54906003)(76116006)(5660300002)(86362001)(6486002)(4326008)(83380400001)(6916009)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bLz+naaHlPsz2JXKVbN4odpDL418kDeyB45yuX3ibFeCZq1FjgGrWlh/a7pXuMju6Fre5XAmDzKwumIprc6qY57CO1phhdVqJsdSZUQT5PfOIwfL98HTvNcQJ880zbdGGmTtZKIywLl9i1Tw+RE8pUEeGf2OvVt3tCTYo1aaZdMmjCaltjiAbePo/omiyPS5VhIIfRBZHvaT4cDg0icqrA/tgrpbqU3UIO0ST0npRigfbeB33Itjk/DITU+uVkBzIa2GDW4sOO2aXD/i056oh+28658Aw/ON+jLbHhgJM14Xabe4zmDsGK2ZmCKro7gLlJWQ8E4WLe0dJHR0aBrJ0zuQ2fYhIlv2g2GbTww+Birq3cup9EnwOiJHNm02P0Y/xPE9Vj9OdnFwSyFgKUR3YbGqqxf+btUp3VF4cFF/nVo6vGpwio7zYBzysLNtwUpG3w3dQ1FRlKc9xeR3QnTOHfnc54GETcLeTczzjYJ+GT5uYlzdML4mrzAVUCflUsj5EfwaUbycO6pCcaoTUZasWCvNYwU7+v9qQvMPR8aV71szKBPm0jcqgw0LVJP5lZwfVV24MVemqqAPiMN69NF5X4wmYQKT4z2ARP0XP0GSx/YMvCllO/y/XFyu4QG7b+NJCmQKP4ZM6BV10Cm03MZZmQSY0l6pIupUxR3hOo5NfrABUAX5lmSIT5kHVqewEQJl
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9B1931026DA0CC4B9F66150500676C3E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbd6531-6057-4ccf-a899-08d8602816dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 01:20:56.9280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DfIJAaePLW7XIHjG6Tne9gunQxHMlB5lFjh56ZuN0eMZaF4iNWTXST31TBNBbq5lePamyCCRY+TILW+Wlk/aHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_19:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009240007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 23, 2020, at 6:11 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Wed, Sep 23, 2020 at 4:54 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Sep 23, 2020, at 12:31 PM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
>>>=20
>>> On Wed, Sep 23, 2020 at 9:55 AM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> This API supports new field cpu_plus in bpf_attr.test.
>>>>=20
>>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>> ---
>>>> tools/lib/bpf/bpf.c      | 13 ++++++++++++-
>>>> tools/lib/bpf/bpf.h      | 11 +++++++++++
>>>> tools/lib/bpf/libbpf.map |  1 +
>>>> 3 files changed, 24 insertions(+), 1 deletion(-)
>>>>=20
>>>> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>>>> index 2baa1308737c8..3228dd60fa32f 100644
>>>> --- a/tools/lib/bpf/bpf.c
>>>> +++ b/tools/lib/bpf/bpf.c
>>>> @@ -684,7 +684,8 @@ int bpf_prog_test_run(int prog_fd, int repeat, voi=
d *data, __u32 size,
>>>>       return ret;
>>>> }
>>>>=20
>>>> -int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
>>>> +int bpf_prog_test_run_xattr_opts(struct bpf_prog_test_run_attr *test_=
attr,
>>>> +                                const struct bpf_prog_test_run_opts *=
opts)
>>>=20
>>> opts are replacement for test_attr, not an addition to it. We chose to
>>> use _xattr suffix for low-level APIs previously, but it's already
>>> "taken". So I'd suggest to go with just  bpf_prog_test_run_ops and
>>> have prog_fd as a first argument and then put all the rest of
>>> test_run_attr into opts.
>>=20
>> One question on this: from the code, most (if not all) of these xxx_opts
>> are used as input only. For example:
>>=20
>> LIBBPF_API int bpf_prog_bind_map(int prog_fd, int map_fd,
>>                                 const struct bpf_prog_bind_opts *opts);
>>=20
>> However, bpf_prog_test_run_attr contains both input and output. Do you
>> have any concern we use bpf_prog_test_run_opts for both input and output=
?
>>=20
>=20
> I think it should be ok. opts are about passing optional things in a
> way that would be backward/forward compatible. Whether it's input
> only, output only, or input/output is secondary. We haven't had a need
> for output params yet, so this will be the first, but I think it fits
> here just fine. Just document it in the struct definition clearly and
> that's it. As for the mechanics, we might want to do OPTS_SET() macro,
> that will set some fields only if the user provided enough memory to
> fir that output parameter. That should work here pretty cleanly,
> right?

Yep, just sent v4 with OPTS_SET(). ;)

Thanks,
Song

