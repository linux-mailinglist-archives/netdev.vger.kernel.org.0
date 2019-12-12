Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFB511C11C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfLLAJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:09:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23896 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727096AbfLLAJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:09:18 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBNub14023806;
        Wed, 11 Dec 2019 16:09:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Vt/p3321CvjLfF9AKufno8wFgUEPm0KmxxK0893/r10=;
 b=JiQPnBSqh1BLod7hCwGCTCkJnvaXNQv7Lv7mUnthiyGeb2DgU8bu6NAB9T9E6rj8DXsH
 N48+8h4qi544r9icUvUnuT5BbgXEkYulMMcSizFV/gw9b3x+tFjbcTvQBGVy+ZHASLur
 GL9933LTNq7XTkFGvzu9/bQu0SGYlforPHc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu2gf2dmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 16:09:05 -0800
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 16:09:04 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 16:09:03 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Dec 2019 16:09:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJz5CuEjBesTBDDNfGwVnF/7UcOOj0nJCd05yKwyIIxnFoZIEFlH9pAcPortf5zSndk/2ogGc8mgbI1MU5CfuT6Jira1ZMEJXjBjeRIQ8enTKog1fYOm3Y5Q/De5RKPFj88Mvk8BxM8T2nxCFFqf4Sx33AxImOYwDHMVVwkU+/sOGGDp9Ti2N/iywhEr5tRy25bfJq9p5N/KDW3xN/4j7w/EdU7nERsyivSdWZVwnOgrXGFZXV5v9TGYW91XfgwpWnluOJOGFqX0bk5+A8D0hdhay86+AvGX/RXZ8DQ0AZV4u1Cg+GZSM8VaGL82NtR42q2rgnIwTgyrsM+v12J3Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vt/p3321CvjLfF9AKufno8wFgUEPm0KmxxK0893/r10=;
 b=bEDItMDVWp0WC4K9WXb/kjPsPytaTJaDG90xUfaeRXwnOXP0B1L8Q+cCwHxPO1J4+X9pemAUslW6/UcAm5WjZLoPe3dC29z8pRniiUZY1cEz/dbEODXYDd3rXkKiJ0dVKtLnQ8FdHKIeDCuTgocQvl6wwJFZPC9kOFYq2bkTmaB4CNmS0NcXSGAM0GTAe5jbK6oGeWTB64esacPQcyAnyjqUZGgCZw5n+Qb0HAZXA76RoJ1osYKSb5pjSHlGrrA3V4KADQxfHHlicpy9Lz0SjMPlZpmk+QkhpjVPyNPysd9hcMBBsJg2wVD80hUrQP32hCAaxLPxSmkhOhtqq2IWcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vt/p3321CvjLfF9AKufno8wFgUEPm0KmxxK0893/r10=;
 b=aOfjaiF4uLUEGkePSWzaJiKyg9gLPypcKFJlTyWp49i6IsUziMYZvc2i6Rdv3pBN2p6mkvy4GlC7bMUyzlRUsCK5gWJmHkuKIqWFFEBYE9M/x1ZGP6kesKUCt+x7kimm7GVkQkANa+5++mGDbeGWxc+ZM02aj8XBY+bL46XCkFg=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3502.namprd15.prod.outlook.com (20.178.255.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Thu, 12 Dec 2019 00:09:01 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Thu, 12 Dec 2019
 00:09:01 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: fix printf compilation warnings on
 ppc64le arch
Thread-Topic: [PATCH bpf-next] libbpf: fix printf compilation warnings on
 ppc64le arch
Thread-Index: AQHVsFjq43awz/31CE+XVXysci8Bdae1oAEA
Date:   Thu, 12 Dec 2019 00:09:01 +0000
Message-ID: <20191212000858.mhymtk5f4mhwgh2x@kafai-mbp>
References: <20191211192634.402675-1-andriin@fb.com>
In-Reply-To: <20191211192634.402675-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0008.namprd17.prod.outlook.com
 (2603:10b6:301:14::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ee78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd70d00d-7af7-45bb-679f-08d77e977df0
x-ms-traffictypediagnostic: MN2PR15MB3502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3502CC9DA3EBED5C8DBBF7CAD5550@MN2PR15MB3502.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:185;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(376002)(136003)(39860400002)(346002)(396003)(366004)(189003)(199004)(5660300002)(6486002)(52116002)(81156014)(54906003)(81166006)(478600001)(186003)(8936002)(316002)(8676002)(71200400001)(9686003)(6506007)(1076003)(86362001)(6512007)(6862004)(33716001)(66556008)(4326008)(66946007)(6636002)(2906002)(66446008)(66476007)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3502;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uftgTZc3yNhYw3bubwGgU1QH/LpCu2i0AVEa3q8iZIEgRGzwSNytsuSzmIKCIYYiLiZZ9s+gqC5x7yPApkjAFHiePblSCZTW1u5elt4Cid0azAv4orE/xuw1DhwrDhhggi6AfVF/gaabYqMM2BRJwOxxhk94puHqk/RIUlw3qoKp3SIEMSaahKWycQc5S0ITzBsy6ifsN2/JFQNIH8a/RZZdJf7aVxiGrlIFkS0XHB8TQRqj5W08dnskgjSJj8ziYwgDqXkX3hYrF+ePC7SfmEawlyh+cur8vUD2+HI8+SVCGqxb+mrHgdMsrHbk4XjaT3Q/y6os/lo038lLZPvE5CIjjgRYWQrIApNGCngPJ1LvW4G9VXsRuNCyXq1xZrT4Vl18nukRLHxIyyhlcYhzo198hXlbY/Ab/2t23lMheloM/ZpYoPrmq3h9Exa/axUE
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7770C4415F1DFA4291A473DDB8391DFA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd70d00d-7af7-45bb-679f-08d77e977df0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 00:09:01.6152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G5E6dSoWDh3Ft0gdbX8K//4pHYPgQs64Ju7t7sVmVUnuMzVbbBD06+yQhhKtOFRm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3502
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912110185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 11:26:34AM -0800, Andrii Nakryiko wrote:
> On ppc64le __u64 and __s64 are defined as long int and unsigned long int,
> respectively. This causes compiler to emit warning when %lld/%llu are use=
d to
> printf 64-bit numbers. Fix this by casting directly to unsigned long long
> (through shorter typedef). In few cases casting error code to int explici=
tly
> is cleaner, so that's what's done instead.
>=20
> Fixes: 1f8e2bcb2cd5 ("libbpf: Refactor relocation handling")
> Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF"=
)
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3f09772192f1..5ee54f9355a4 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -128,6 +128,8 @@ void libbpf_print(enum libbpf_print_level level, cons=
t char *format, ...)
>  # define LIBBPF_ELF_C_READ_MMAP ELF_C_READ
>  #endif
> =20
> +typedef unsigned long long __pu64;
> +
>  static inline __u64 ptr_to_u64(const void *ptr)
>  {
>  	return (__u64) (unsigned long) ptr;
> @@ -1242,15 +1244,15 @@ static int bpf_object__init_user_btf_map(struct b=
pf_object *obj,
>  			}
>  			sz =3D btf__resolve_size(obj->btf, t->type);
>  			if (sz < 0) {
> -				pr_warn("map '%s': can't determine key size for type [%u]: %lld.\n",
> -					map_name, t->type, sz);
> +				pr_warn("map '%s': can't determine key size for type [%u]: %d.\n",
> +					map_name, t->type, (int)sz);
>  				return sz;
>  			}
> -			pr_debug("map '%s': found key [%u], sz =3D %lld.\n",
> -				 map_name, t->type, sz);
> +			pr_debug("map '%s': found key [%u], sz =3D %d.\n",
> +				 map_name, t->type, (int)sz);
>  			if (map->def.key_size && map->def.key_size !=3D sz) {
> -				pr_warn("map '%s': conflicting key size %u !=3D %lld.\n",
> -					map_name, map->def.key_size, sz);
> +				pr_warn("map '%s': conflicting key size %u !=3D %d.\n",
> +					map_name, map->def.key_size, (int)sz);
>  				return -EINVAL;
>  			}
>  			map->def.key_size =3D sz;
> @@ -1285,15 +1287,15 @@ static int bpf_object__init_user_btf_map(struct b=
pf_object *obj,
>  			}
>  			sz =3D btf__resolve_size(obj->btf, t->type);
>  			if (sz < 0) {
> -				pr_warn("map '%s': can't determine value size for type [%u]: %lld.\n=
",
> -					map_name, t->type, sz);
> +				pr_warn("map '%s': can't determine value size for type [%u]: %d.\n",
> +					map_name, t->type, (int)sz);
>  				return sz;
>  			}
> -			pr_debug("map '%s': found value [%u], sz =3D %lld.\n",
> -				 map_name, t->type, sz);
> +			pr_debug("map '%s': found value [%u], sz =3D %d.\n",
> +				 map_name, t->type, (int)sz);
>  			if (map->def.value_size && map->def.value_size !=3D sz) {
> -				pr_warn("map '%s': conflicting value size %u !=3D %lld.\n",
> -					map_name, map->def.value_size, sz);
> +				pr_warn("map '%s': conflicting value size %u !=3D %d.\n",
> +					map_name, map->def.value_size, (int)sz);
It is not an error case (i.e. not sz < 0) here.
Same for the above pr_debug().
