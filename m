Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1B079790
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391147AbfG2UBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:01:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39846 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391142AbfG2UBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:01:05 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6TJdufC003061;
        Mon, 29 Jul 2019 13:00:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TYQnic/O9NNKmRoSOLgUow9o7JuTVj9pOLc0Ix/qZlo=;
 b=e/4i1NsjY151Pjwkq+UMQ4mt47zZhIPgUTDsJJQxGqs6zFEqSYCqJ77LChES95DfbZ21
 w6xll4R6Zrkoh1aDbeKCEcq/HohDTuBu9ktOCuduCILaVekeeIA+tVATTlxnOwshp2eS
 C5ngX23f5onWNtFsu67hWsxVeINhwGoSdA8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u203rtayr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jul 2019 13:00:44 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jul 2019 13:00:43 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jul 2019 13:00:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nouG/3uef/yBDJJzII5k+AxqeJOF3lzhUFWSKb6+v81ASToMF7PXCad0ct5rnqtF1RF3CCFJNI8+ggK5+1Aamhf+GPCrQ3nnz8oIi8bXa9xSqAJtFFT/Jq8sfBNWzP1ucRBb/9SM/oSaGAJE6woz2CJXBKkEDFT80pAjDa16xF3/P6bMs/jkf+uBEMlsYbce0mxwwZWdngc5KJTKF74sHCwzPjJRaJT5XhbbxL0yuBZwfwv4mmUSAMvwxXA+qC69kwJMCs0jlzQ5M4MmroFSwS1EA2/tJj/O3TN+GfR56lhMr9/9qctCt2vSPx4azcEJx6lbgYqII4AQET5qy6nSHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYQnic/O9NNKmRoSOLgUow9o7JuTVj9pOLc0Ix/qZlo=;
 b=AeXHpOr2dHrGX+acwez+s4xb/O3P4jMujKqgcVpWUGIben4gmMttXYu4gCJsVSoFYPXz4jz8o6rZ3GRxziQrNW5GIHROTPJFKrBQEXHuYfxsb8VnZUppa+Mn2fOnF2VknuZSEaa25Dcbhe4tb9k78oDeiyC1Gin+zRkonbuD26yyAhL2l1vhnVI/ySeXB7p0uKjhLX+tKCSD1EQkTYEgFw1kBSJS9C7HRoFMaYKwxMV/JNuAiMzocCE2OMFu3ewttL0CN3FJ5LXJSxN2AIK1wBiQ81Nw7Z6fVuqVzxdEpgcZxAKKfKbePP2l8RW7JAGn6j55zVIbe7GOajD10IwOvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYQnic/O9NNKmRoSOLgUow9o7JuTVj9pOLc0Ix/qZlo=;
 b=IL7P2YBiwep8yQYqgqDdyHUNqtc8gg8OdR2nwrmPwfxNLFfZnjDcskwiD3pX1xxftLRD3jRzpdoIawVuEo5LaVSUgZuqD+5rMPP7WOE+jdWtfTXeFkvef6ZWrR4mnCdHyxfyU1A4wi+zL1tzdJrXzkEZV6HDVjLGr7WgpSTw1oc=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1918.namprd15.prod.outlook.com (10.174.101.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 20:00:42 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 20:00:42 +0000
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
Thread-Index: AQHVQlYK69qsehsdP0Kkd9QeaocpJKbacyeAgAAKZACAAE8ygIADIgEAgAQdLoA=
Date:   Mon, 29 Jul 2019 20:00:41 +0000
Message-ID: <A98A432B-1A26-461F-BC9B-3B72FCF8EE2B@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-2-andriin@fb.com>
 <B5E772A5-C0D9-4697-ADE2-2A94C4AD37B5@fb.com>
 <CAEf4BzZsU8qXa08neQ=nrFFTXpSWsxrZuZz=kVjS2BXNUoofUw@mail.gmail.com>
 <B01B98E5-CDFB-4E3A-BD58-DBA3113C3C3F@fb.com>
 <CAEf4BzYgyAiPt0wVESrWSJ_tLheq0BRWLgrqMfLZsnp11+F77Q@mail.gmail.com>
In-Reply-To: <CAEf4BzYgyAiPt0wVESrWSJ_tLheq0BRWLgrqMfLZsnp11+F77Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2:d148]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6a95d7b-a138-45da-907a-08d7145f6f79
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1918;
x-ms-traffictypediagnostic: MWHPR15MB1918:
x-microsoft-antispam-prvs: <MWHPR15MB19184ED172C1A52707310A2EB3DD0@MWHPR15MB1918.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(366004)(39860400002)(396003)(189003)(199004)(6512007)(14454004)(6916009)(11346002)(6436002)(57306001)(305945005)(36756003)(446003)(229853002)(256004)(54906003)(6116002)(2906002)(86362001)(6486002)(476003)(2616005)(486006)(71190400001)(53936002)(71200400001)(46003)(33656002)(316002)(478600001)(50226002)(25786009)(8676002)(81156014)(186003)(81166006)(102836004)(6506007)(53546011)(76176011)(5660300002)(7736002)(4326008)(6246003)(99286004)(76116006)(68736007)(66476007)(66946007)(64756008)(66446008)(66556008)(8936002)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1918;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iEpERHNYIp2m5aYAemd/y9C10dGKV3Lpu6eRik4adAg/nrbDjlO9rdogFQTSNlAYdr5zOSHOXyNmcBu260rIoCvDnOiaMeivmKFnQMvgvf5ym0mzRSJv8Lv5TEwPqchsgNz7ZaiwwytedW2Lj6iqkh0SDEGkO8AMtnmXucTWteq+ds3uqkIdYOOUtzRi94koaqL0oOrfp7nUgcqE0rr+AsUNg9vjKExE0uPPy7FtCIf40O50dV9TqJzpNG5BMfjqJdT59qFgnovlgJcyXPgUC1M5KYLjwEl4VhzGOXnkE53jIMn4mrlWZzETbpfLzx9DzOXQWpQtf3pGpG06aKdakz8nSGfp9WHpNJrPRraSWWWN6e8CzxAKkelD7vxyKjtsZNqoQYchoDmeJbBcSnx4A/L+6IxjO5M6YTZnV5znbSY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B360E16EEBE193408BC004E812200CD3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a95d7b-a138-45da-907a-08d7145f6f79
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 20:00:41.8939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1918
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-29_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907290215
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 26, 2019, at 10:11 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Wed, Jul 24, 2019 at 10:20 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 24, 2019, at 5:37 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
>>>=20
>>> On Wed, Jul 24, 2019 at 5:00 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Jul 24, 2019, at 12:27 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>>>=20
>>>>> Add support for BPF CO-RE offset relocations. Add section/record
>>>>> iteration macros for .BTF.ext. These macro are useful for iterating o=
ver
>>>>> each .BTF.ext record, either for dumping out contents or later for BP=
F
>>>>> CO-RE relocation handling.
>>>>>=20
>>>>> To enable other parts of libbpf to work with .BTF.ext contents, moved
>>>>> a bunch of type definitions into libbpf_internal.h.
>>>>>=20
>>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>>> ---
>>>>> tools/lib/bpf/btf.c             | 64 +++++++++--------------
>>>>> tools/lib/bpf/btf.h             |  4 ++
>>>>> tools/lib/bpf/libbpf_internal.h | 91 ++++++++++++++++++++++++++++++++=
+
>>>>> 3 files changed, 118 insertions(+), 41 deletions(-)
>>>>>=20
>>>=20
>>> [...]
>>>=20
>>>>> +
>>>>> static int btf_ext_parse_hdr(__u8 *data, __u32 data_size)
>>>>> {
>>>>>     const struct btf_ext_header *hdr =3D (struct btf_ext_header *)dat=
a;
>>>>> @@ -1004,6 +979,13 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 =
size)
>>>>>     if (err)
>>>>>             goto done;
>>>>>=20
>>>>> +     /* check if there is offset_reloc_off/offset_reloc_len fields *=
/
>>>>> +     if (btf_ext->hdr->hdr_len < sizeof(struct btf_ext_header))
>>>>=20
>>>> This check will break when we add more optional sections to btf_ext_he=
ader.
>>>> Maybe use offsetof() instead?
>>>=20
>>> I didn't do it, because there are no fields after offset_reloc_len.
>>> But now I though that maybe it would be ok to add zero-sized marker
>>> field, kind of like marking off various versions of btf_ext header?
>>>=20
>>> Alternatively, I can add offsetofend() macro somewhere in libbpf_intern=
al.h.
>>>=20
>>> Do you have any preference?
>>=20
>> We only need a stable number to compare against. offsetofend() works.
>> Or we can simply have something like
>>=20
>>    if (btf_ext->hdr->hdr_len <=3D offsetof(struct btf_ext_header, offset=
_reloc_off))
>>          goto done;
>> or
>>    if (btf_ext->hdr->hdr_len < offsetof(struct btf_ext_header, offset_re=
loc_len))
>>          goto done;
>>=20
>> Does this make sense?
>=20
> I think offsetofend() is the cleanest solution, I'll do just that.

Agreed that offsetofend() is the best.=20

Song

