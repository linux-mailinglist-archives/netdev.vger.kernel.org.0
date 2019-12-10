Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94E3119F70
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 00:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfLJXfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 18:35:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14270 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726683AbfLJXfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 18:35:04 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBANYaFC025418;
        Tue, 10 Dec 2019 15:34:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=EhCDKHC4gUCM3jUceATSEfV87aYQrW7uNQzeE7yd1nU=;
 b=K6/ejvNqr+uwCM7HPk4EGM2Y2CSiyrjq+Q435LLE/Jv6tDIIOUDIqEWG4k5WMCg6sJG/
 VSKJir9uF6CdVr0YlW60Cp6JtNTSOSjCiHKJ2uWFiSHZbe++K6iy2GJWMIhn44t5ab/g
 lCmWxznW520AAIaq1af5vEScd3UlmD5ApNQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wtddktx9g-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 15:34:39 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 10 Dec 2019 15:34:26 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Dec 2019 15:34:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VW67uXw+3CL2Gb7hJ6SLwcfz3aLJsGczie93NTZ0roEGcw3J2E4dnuBxIaVe5JPNvqgBHkldk6/zG79l/qAG0/yIvLglhksILYXE0esJL+imZf0900PhGgPPgeqfghJPqdChtiY6Q/VX49x7nxXM9yuwVsk1GFLu97g1recgybg2NHwK68iWcYe9XrbIGlA9d0/Z+S1je+lA+QrCz9Ukd+hGwK+6ORzi/TJQt2VHPCYIfRSZ/elnCMYDc/6UZH8g65mFEcm1HWppIMD4eu3xvuJPLOq9R/zmxe23efxeFIBA2Jyyist0gIaVHzMOeRaGl3BzujQFFzv8TvFAL0e1Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhCDKHC4gUCM3jUceATSEfV87aYQrW7uNQzeE7yd1nU=;
 b=VLAzolLcy0en038iK/TYksAjLFNpGdzifLGDmsjVnxez5kcDR7RywjKS6I2yz80KssMAfp9SRAFIfYvzDO289UIrqnqSbTB4w6l0W9zIRgl9mYua5zP+ELTV0OhYex4jsLOIgVfUo4ytF9oOK3A4pAVJuMOF97mTNf88xMIdlLE5EENtdsAUdYRuT/s3r07Xx0hd/8/WGm87gBDJ1EZkLrB9xij8cxwth4lwfr5ksrd7NZag9jhZR9TMMCf7Z37b9f4Ewdai44yPyQwmbi2p0T76FEpbq2qI+l6on7QojN1gRAOdr0Kaf7GEX1JN38PDCzpxKnyi36S1JUSaTit4+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhCDKHC4gUCM3jUceATSEfV87aYQrW7uNQzeE7yd1nU=;
 b=dMHQCBp/5MaILHU9QfsR/D3EKiwJjI1Iftav4tSqBbixbBB8Pt0aAad7tHujrJQUBqINHXuH7ZlSlnmru5kdR1kyqhKoIGUQYr5udR/Zeh39ovM35aMKJ98ZQ94E1FJMoXVU2dxsCwU7q2pilRKfVq9MaKiszfveZtWYd/tIKBM=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2671.namprd15.prod.outlook.com (20.179.146.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 23:34:25 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 23:34:25 +0000
From:   Martin Lau <kafai@fb.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: Fix build in minimal configurations, again
Thread-Topic: [PATCH] bpf: Fix build in minimal configurations, again
Thread-Index: AQHVr5luvUr1OsnMX0ud4dyRR00tDqe0BX+A
Date:   Tue, 10 Dec 2019 23:34:24 +0000
Message-ID: <20191210233421.vnybkzc6noskmsjt@kafai-mbp>
References: <20191210203553.2941035-1-arnd@arndb.de>
In-Reply-To: <20191210203553.2941035-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0165.namprd04.prod.outlook.com
 (2603:10b6:104:4::19) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:4349]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff918764-f22a-41b4-5192-08d77dc97db4
x-ms-traffictypediagnostic: MN2PR15MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2671B33B27C6936873981E63D55B0@MN2PR15MB2671.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(199004)(189003)(8936002)(66946007)(5660300002)(2906002)(6512007)(4326008)(9686003)(86362001)(64756008)(66446008)(8676002)(71200400001)(186003)(81156014)(81166006)(66556008)(1076003)(498600001)(6916009)(33716001)(6486002)(54906003)(6506007)(52116002)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2671;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nsyTa9/nsnm9a/tt0ofDQomnmdyzNxHFaHuUDoOx58/i3V/WgQw3As9cI8va2goGt2+wATTAiId8JkPtFAiGnDC+WdK+CWzqTEtcF9vu9sdsDtchBr0k2t2RlvZt48KQQAn941O2chpgQZKJL2fhoa25DENP8mB/RcOze2mrCLMtSZu3dJgQbL5nGzy+MjIbuzaaLA6NgxhXBivamnZ9SeQp2G1PxZDAqWojqeXlud4uLDLsRGhxnM//qtY2emOQTkxyDFAwsi+sNzh+5mHEGiZnQesoORg121ZoDoh+LuGOnUgCBtLTHN05+EzFZsIGi200IMq8IiCA3qmvvS00vUcrYAsIu6vhh7iM2zGUDOBaV4ku8d983+jY4yrylc9GFGgGUDYCeyVYvwVFPHsFdz018O3TQu1IpzwH3N6ByWnM+fQcycGo196Kc5nT4zW1
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B0045B965EC74644BA81F88070FB9A2B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ff918764-f22a-41b4-5192-08d77dc97db4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 23:34:24.9620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pZko3wOSBAcUta7IV2OH/HgOYboc9YmSfrFWOoGvmuaRnI5HsH6OYJRLGX0SGlbG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2671
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_07:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 malwarescore=0 phishscore=0
 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxlogscore=865 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912100193
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 09:35:46PM +0100, Arnd Bergmann wrote:
> Building with -Werror showed another failure:
>=20
> kernel/bpf/btf.c: In function 'btf_get_prog_ctx_type.isra.31':
> kernel/bpf/btf.c:3508:63: error: array subscript 0 is above array bounds =
of 'u8[0]' {aka 'unsigned char[0]'} [-Werror=3Darray-bounds]
>   ctx_type =3D btf_type_member(conv_struct) + bpf_ctx_convert_map[prog_ty=
pe] * 2;
>=20
> I don't actually understand why the array is empty, but a similar
> fix has addressed a related problem, so I suppose we can do the
> same thing here.
>=20
> Fixes: ce27709b8162 ("bpf: Fix build in minimal configurations")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  kernel/bpf/btf.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 7d40da240891..ed2075884724 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3470,6 +3470,7 @@ static u8 bpf_ctx_convert_map[] =3D {
>  	[_id] =3D __ctx_convert##_id,
>  #include <linux/bpf_types.h>
>  #undef BPF_PROG_TYPE
> +	0, /* avoid empty array */
If bpf_types.h is empty, the prog should have already failed
earlier in find_prog_type() in syscall.c, so 0 here should
be fine.

Acked-by: Martin KaFai Lau <kafai@fb.com>
