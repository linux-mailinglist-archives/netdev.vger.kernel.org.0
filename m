Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C26744CE
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 07:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390539AbfGYFVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 01:21:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50942 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387743AbfGYFVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 01:21:06 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6P5H8JQ022716;
        Wed, 24 Jul 2019 22:20:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dXUg+kmjxfKrnSKffgzxyQUZvpkd5Tu//GAVYU5BGgE=;
 b=TtgSBXr9wIbRDtilQxUuS6FWJ5qvaIIkkgGEaeDnXmzU+mgJBOQ9Jw+CfOv70jvDhSQ+
 2+3ZAsOB/NU0vHMRWmJ3BEBOxcbI1cbVYQ7Ss6OFDIynediorC3ZC6hzVZM53wKF4cNy
 Ff3yyH5+YQ+t1sS78znwQUvIL3Ea1rCUIM4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2txu1ujeaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 24 Jul 2019 22:20:47 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 24 Jul 2019 22:20:46 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 24 Jul 2019 22:20:45 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 24 Jul 2019 22:20:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSnWYJePUdoLVMytgdwFM8GEZ0QUrpuD1j4LG6jR0yWqhcDfOzyo3ajO5iEeAO3JLe/KjmfDxzx0qYp9AWQKaR3UYuj8dckT0llCgMbLKUIsYY9yyk5vsW4AHDDcVOBSHR1X1RFy8k+q+uot9zLD+U0y/D1FlWi5OntpiysavcYBKAC7wtTUk4ct4CvX2mD7c26guBKt/2S6Rvph8K+EBc+DNc5Zq+y/ihCWfafhLVugR0cErlylska/z2rjfDcLfGob3t1Bz1yInig9vAqe3M/G05fPmWEUk5LqtTwk9SMrPKrIJ9ekuDInHZ4nTeNftUNd5efgloijKYtepcmXIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXUg+kmjxfKrnSKffgzxyQUZvpkd5Tu//GAVYU5BGgE=;
 b=cD/MNDNsBc6aNolTmzOPuARXtr7Zm3/3s4AoVvprCL/cGuwclM0GbrKda9Ydn/1qeHvNNA002ZJwA9dKmHK2tERz3COJOYBxWjF8hedlGqm9UJvYr1xPEHeAPBn3lJmjkp/mgiTY0jsLI7587rQx9BZS31K/WE8NBhzAX63p57iEgXqAEyeL7i3CRv5DApVpditfix02mU9CnKXVsv+04NrF+2gnLKLQA/B/FgNgkLFgur4XguvO4VeSvw9juzW8ab0TMWaDjVZ7pLWc8p1TV6ynzdTTV1LJixKrc6R204lFvM40ry20iVOkufV1SY6Qc1x+hUu+FGvZlw/TU8q+ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXUg+kmjxfKrnSKffgzxyQUZvpkd5Tu//GAVYU5BGgE=;
 b=aMoVRJ6TMKjsZlMGQODm0tnd6oGcci1WErqDH1cVtJFrXp4CDgotV1b8DS92C2UjD52cxmo6BRC2eR+OkdMeaC29fvtCFSHSEAh6GffrB91xOkrvIfrBwGlnCbiMTdPeutXIJ0wCLMBip2PjZucQyD1Q0l8oblakbhtDlFoSbzc=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1439.namprd15.prod.outlook.com (10.173.235.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 05:20:44 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 05:20:44 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 01/10] libbpf: add .BTF.ext offset relocation
 section loading
Thread-Topic: [PATCH bpf-next 01/10] libbpf: add .BTF.ext offset relocation
 section loading
Thread-Index: AQHVQlYK69qsehsdP0Kkd9QeaocpJKbacyeAgAAKZACAAE8ygA==
Date:   Thu, 25 Jul 2019 05:20:43 +0000
Message-ID: <B01B98E5-CDFB-4E3A-BD58-DBA3113C3C3F@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-2-andriin@fb.com>
 <B5E772A5-C0D9-4697-ADE2-2A94C4AD37B5@fb.com>
 <CAEf4BzZsU8qXa08neQ=nrFFTXpSWsxrZuZz=kVjS2BXNUoofUw@mail.gmail.com>
In-Reply-To: <CAEf4BzZsU8qXa08neQ=nrFFTXpSWsxrZuZz=kVjS2BXNUoofUw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:7bbf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b452b5d7-fbb0-4b3b-b807-08d710bfd7b9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1439;
x-ms-traffictypediagnostic: MWHPR15MB1439:
x-microsoft-antispam-prvs: <MWHPR15MB143920C3995C50EC0E5D43DAB3C10@MWHPR15MB1439.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(136003)(376002)(396003)(346002)(189003)(199004)(50226002)(229853002)(86362001)(186003)(33656002)(81166006)(2906002)(476003)(66476007)(446003)(8676002)(11346002)(6506007)(2616005)(6512007)(102836004)(53546011)(76116006)(5660300002)(316002)(53936002)(54906003)(81156014)(36756003)(486006)(8936002)(57306001)(99286004)(14454004)(256004)(46003)(6916009)(7736002)(6436002)(6486002)(66446008)(66556008)(25786009)(6116002)(4326008)(6246003)(71200400001)(71190400001)(68736007)(305945005)(66946007)(478600001)(76176011)(64756008)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1439;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FLi+e8mgigv3K91UssFksjeDiSkm5LNsg9bE6vE4sKOdpqMCXyo3XDybUl6MFEc2EdBsmIs9s4AOod1jyHTIggAZNtjp+K0V4KYN2YgAiKicOHHj6eJm++5PbfNv9JREdtuBk3gj2f0yoWB2DATs2VktBaiR5EkgWwe96T0R5gI4GxDSKvAxB9syyji7wsV2wKXiXFU77fQExYcBfsBS8As+nYNsiNmTEfMMdp0DahAqvqf9tGUDvTjH9BeHbatlLQ2t9ObH35ZFnflWrb9VC/5vKs5OkU7NbPQdtbfcWT14OkU9iDbtP1/hRRI2bxyAZF8/G9PLL2SxflYiJFJBSFfsp8MhuEMQ396nQMICRvMFEUP0B0BGV5eBI3IzfW/IdrDJJ7pqUOC2fuk50zIre3fKJux4Q1yiHCbKrBkKkWU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1926CAE9DF055B409FC16029DD1F202C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b452b5d7-fbb0-4b3b-b807-08d710bfd7b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 05:20:43.6772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1439
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-25_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907250063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 24, 2019, at 5:37 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Wed, Jul 24, 2019 at 5:00 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> Add support for BPF CO-RE offset relocations. Add section/record
>>> iteration macros for .BTF.ext. These macro are useful for iterating ove=
r
>>> each .BTF.ext record, either for dumping out contents or later for BPF
>>> CO-RE relocation handling.
>>>=20
>>> To enable other parts of libbpf to work with .BTF.ext contents, moved
>>> a bunch of type definitions into libbpf_internal.h.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>> tools/lib/bpf/btf.c             | 64 +++++++++--------------
>>> tools/lib/bpf/btf.h             |  4 ++
>>> tools/lib/bpf/libbpf_internal.h | 91 +++++++++++++++++++++++++++++++++
>>> 3 files changed, 118 insertions(+), 41 deletions(-)
>>>=20
>=20
> [...]
>=20
>>> +
>>> static int btf_ext_parse_hdr(__u8 *data, __u32 data_size)
>>> {
>>>      const struct btf_ext_header *hdr =3D (struct btf_ext_header *)data=
;
>>> @@ -1004,6 +979,13 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 si=
ze)
>>>      if (err)
>>>              goto done;
>>>=20
>>> +     /* check if there is offset_reloc_off/offset_reloc_len fields */
>>> +     if (btf_ext->hdr->hdr_len < sizeof(struct btf_ext_header))
>>=20
>> This check will break when we add more optional sections to btf_ext_head=
er.
>> Maybe use offsetof() instead?
>=20
> I didn't do it, because there are no fields after offset_reloc_len.
> But now I though that maybe it would be ok to add zero-sized marker
> field, kind of like marking off various versions of btf_ext header?
>=20
> Alternatively, I can add offsetofend() macro somewhere in libbpf_internal=
.h.
>=20
> Do you have any preference?

We only need a stable number to compare against. offsetofend() works.=20
Or we can simply have something like

    if (btf_ext->hdr->hdr_len <=3D offsetof(struct btf_ext_header, offset_r=
eloc_off))
          goto done;
or=20
    if (btf_ext->hdr->hdr_len < offsetof(struct btf_ext_header, offset_relo=
c_len))
          goto done;

Does this make sense?

Thanks,
Song=
