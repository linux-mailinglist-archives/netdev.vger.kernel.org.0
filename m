Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B595248BB6
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfFQSPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:15:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42184 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbfFQSPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:15:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HI7pRj002264;
        Mon, 17 Jun 2019 11:15:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0GWoE6WjZjVNm0OVftWmUWXxyja9tV7qX7Wa0H9ea8I=;
 b=IweU/67BgHABPl5eMENrEY7TaUWChWuC+z+UZuXtSJLRiKVLoX3MFQwIZAsFX5KZUn78
 7Fh2EJ0yOJzWLDoRWOJvD5pTfvcZZ3mixaTAp4PGoHX69k2QQ6k6WC5E94jNspu/FmIV
 e/45Bmix34yVJsPey+dxLzMuhOdkG42tQX0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6f3rg718-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 17 Jun 2019 11:15:32 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Jun 2019 11:15:31 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Jun 2019 11:15:31 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Jun 2019 11:15:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GWoE6WjZjVNm0OVftWmUWXxyja9tV7qX7Wa0H9ea8I=;
 b=GNWJAZF3kpd3u9hCfAa8BgNZCMs9LffyYuZG2qRkOtbwddxETD2pVcSr4e+fS8XsfriWK6/gF4nQf7/NzdCEzlay9X0HUO96ulY+iwWS+XXy7HacETC/ze/fV1xbnS20/HMWBuNBMUeQzL2gTPRqbpqtsEtGY+pzvfTC72DziqY=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1853.namprd15.prod.outlook.com (10.174.255.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Mon, 17 Jun 2019 18:15:30 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 18:15:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 4/8] libbpf: identify maps by section index
 in addition to offset
Thread-Topic: [RFC PATCH bpf-next 4/8] libbpf: identify maps by section index
 in addition to offset
Thread-Index: AQHVIA8ZemQ31DJ4jkih2fb2Z6Oga6adPKyAgALx8oCAAAKNgA==
Date:   Mon, 17 Jun 2019 18:15:30 +0000
Message-ID: <4B62AA63-EA75-4C8B-B225-47930BC0812A@fb.com>
References: <20190611043505.14664-1-andriin@fb.com>
 <20190611043505.14664-5-andriin@fb.com>
 <CAPhsuW6iicoRN3Sk6Uv-ten4xjjmqG1qmfmXyKngqVSYC9qbEQ@mail.gmail.com>
 <CAEf4BzYKtA9Hk5oswZVD_pZ-VxjXXd_OV_bRs+42cfgf8dqodw@mail.gmail.com>
In-Reply-To: <CAEf4BzYKtA9Hk5oswZVD_pZ-VxjXXd_OV_bRs+42cfgf8dqodw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:da81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4018da19-9deb-4bbf-bca5-08d6f34fc80b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1853;
x-ms-traffictypediagnostic: MWHPR15MB1853:
x-microsoft-antispam-prvs: <MWHPR15MB1853858FE5A34087090F42A3B3EB0@MWHPR15MB1853.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(136003)(396003)(39860400002)(199004)(189003)(229853002)(476003)(99286004)(6512007)(53546011)(25786009)(33656002)(316002)(6506007)(256004)(14444005)(14454004)(4326008)(36756003)(76176011)(2616005)(66476007)(66556008)(66946007)(64756008)(66446008)(11346002)(73956011)(76116006)(486006)(305945005)(2906002)(8936002)(6916009)(50226002)(6486002)(71200400001)(53936002)(8676002)(6246003)(71190400001)(478600001)(86362001)(68736007)(446003)(7736002)(81166006)(81156014)(186003)(46003)(6436002)(54906003)(5660300002)(102836004)(57306001)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1853;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mB+tAkvf8LJI9NZwUeTZIJZxudzWDzag97/d5ClQEpMS30qE97x9m3OSJHHgc6QDtnvDEGqkmYdLOxGnhNsas59i8uUaXK42TbSMHsGA38JqEdcnZCfwPLChHChrBsSwdaDxFjJF73kYI6YY0ISoesECLAD8apNl3Kpt82EjYnpakQYEIjqHJFGrDQHouLpVqCmJSBsHVyRLHmUKVd0uSz2NVxyrD2ttwidtBOfe8H95mD5GHGipInDOm40Kwzm02PmoUUkY04yMaWCCusua4WhTjBAhjlMyy38XXzEDaxcuImjfaCro5Dx2YOjSQ6AxF49GGiFktC/3KN40EqYUrNF9fx1brTcE41HWrVzpNNoq9XDp9z5VXuviTRtYvmGssg2A0n3cdUIR6d3PNDXVpRBgAf64rmFTCysm81/KCYo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <86F29DAB6CAB854BA97DE9859E0C9DAE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4018da19-9deb-4bbf-bca5-08d6f34fc80b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 18:15:30.2401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1853
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 17, 2019, at 11:06 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Sat, Jun 15, 2019 at 2:08 PM Song Liu <liu.song.a23@gmail.com> wrote:
>>=20
>> On Mon, Jun 10, 2019 at 9:37 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> To support maps to be defined in multiple sections, it's important to
>>> identify map not just by offset within its section, but section index a=
s
>>> well. This patch adds tracking of section index.
>>>=20
>>> For global data, we record section index of corresponding
>>> .data/.bss/.rodata ELF section for uniformity, and thus don't need
>>> a special value of offset for those maps.
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>> tools/lib/bpf/libbpf.c | 42 ++++++++++++++++++++++++++----------------
>>> 1 file changed, 26 insertions(+), 16 deletions(-)
>>>=20
>=20
> <snip>
>=20
>>> @@ -3472,13 +3488,7 @@ bpf_object__find_map_fd_by_name(struct bpf_objec=
t *obj, const char *name)
>>> struct bpf_map *
>>> bpf_object__find_map_by_offset(struct bpf_object *obj, size_t offset)
>>> {
>>> -       int i;
>>> -
>>> -       for (i =3D 0; i < obj->nr_maps; i++) {
>>> -               if (obj->maps[i].offset =3D=3D offset)
>>> -                       return &obj->maps[i];
>>> -       }
>>> -       return ERR_PTR(-ENOENT);
>>> +       return ERR_PTR(-ENOTSUP);
>>=20
>> I probably missed some discussion. But is it OK to stop supporting
>> this function?
>=20
> This function was added long time ago for some perf (the tool)
> specific use case. But I haven't found any uses of that in kernel
> code, as well as anywhere on github/internal FB code base. It appears
> it's not used anywhere.
>=20
> Also, this function makes bad assumption that map can be identified by
> single offset, while we are going to support maps in two (or more, if
> necessary) different ELF sections, so offset is not unique anymore.
> It's not clear what's the intended use case for this API is, looking
> up by name should be the way to do this. Given it's not used, but we
> still need to preserve ABI, I switched it to return -ENOTSUP.

Good survey of the use cases! Yeah, I agree returning -ENOTSUP is the=20
best option here.=20

Acked-by: Song Liu <songliubraving@fb.com>=
