Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7BA11C143
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfLLAXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:23:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727128AbfLLAXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:23:52 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBC0K2qV012573;
        Wed, 11 Dec 2019 16:23:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ZRSn0dLOn9DB7wMz07nOw3l/8YWRlPjohFVwhRt36ic=;
 b=mRCFFLs+InogqwzDWzi2P9VRWG3u1WdgN2Wja0sHL05pVrewcY762RXfjrfakEznzy13
 uX/lu1zt0Je4rGmsLLh3xp8t2Jb6p0ssYfeBnRr4Q9rtjhI0URZ8vpGQGrfiDJZXQ0+a
 th0HbeUQC70JGb91y15EVCV8NW8N/KsV0rw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu404a09x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 16:23:39 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 16:23:38 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Dec 2019 16:23:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKh4tKVZ3TYEr/SuoFnLs6AvtaKP8ytgP3GJwuP6O9RvOT52v5Y3Doai+iH32HY4eA443fdlBWYYgEXw7bQ/j2IfNArfb/2Rc6S66etx4ylb+ZdmkzuGduFb7VifMkw7kdSXII/sfYzkz7UkltYHMh1XxvKH1oju0I9KRi6NCO3ZcPbNQ+tA5nJYBVQsod42ELpLV1E22JVr7merr1w/6wMcMG2u2RYG//L5qYC/CCRFMcOdaeDPL3zZxuOzXC8Vlc4CyBpZEIqA/NH8Y8ZD5VlBok1+Muj+g36cpqUQFc30SJHvZJnaB5F9LNNUvHcKqYkDKDMF4RJI5FkG3NPQ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRSn0dLOn9DB7wMz07nOw3l/8YWRlPjohFVwhRt36ic=;
 b=CDhUrH+y9r/siJuHHxlFc4pGt/fmKCHWzB9ng74VGw4EJzUEmC6EY5xgXonHUGRDHsv0PbylQZOa2vh/8cH5iZAALn/5pVgygV5FsWqmbHrsiRa46MfTk94PGfQACbSTRCVCksMYh3uT36XfaDMhHsLbvomKtO6E9SP+QNW/qeMtKfeBv1OVxQpoB3+b0+44U9aYkvwLX04OD6Pb+38laCcPU+mE0roBqlh/yzm3INGUuKHhxT8NWoPXeGjMdo0qXidZHFw/gyEaN9IG0sAxQMrM9b3Ownhg18jaiABYqCS2Vxl52VxFsVeJD3jWMGhOK2ERfO3q89OG06eZT/knLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRSn0dLOn9DB7wMz07nOw3l/8YWRlPjohFVwhRt36ic=;
 b=e7FmYryraCxXvUkDdy4r5PMXgKYrcuPy+NeA2SBUm0atLmjLdiMfdUo+qzdNGw3uFW4/qLPzsOhc5PcBJ9vpxIrXx29t5zaiiHFXTIz726CiHgnUNrKaAlGk3gy9Xjl8at/ztXH5nqZgYd+fpZEZd3cgGMJQNzodK6lWiwSIcG0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2526.namprd15.prod.outlook.com (20.179.146.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Thu, 12 Dec 2019 00:23:37 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Thu, 12 Dec 2019
 00:23:37 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: fix printf compilation warnings on
 ppc64le arch
Thread-Topic: [PATCH bpf-next] libbpf: fix printf compilation warnings on
 ppc64le arch
Thread-Index: AQHVsFjq43awz/31CE+XVXysci8Bdae1oAEAgAAAwQCAAANMAA==
Date:   Thu, 12 Dec 2019 00:23:36 +0000
Message-ID: <20191212002328.m2eenwfbnbb7ngcm@kafai-mbp>
References: <20191211192634.402675-1-andriin@fb.com>
 <20191212000858.mhymtk5f4mhwgh2x@kafai-mbp>
 <CAEf4BzZhe0yJrrz3Q+eZLs_pDqpr7gFuMEvLm=EyJhBaS0W3Eg@mail.gmail.com>
In-Reply-To: <CAEf4BzZhe0yJrrz3Q+eZLs_pDqpr7gFuMEvLm=EyJhBaS0W3Eg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0098.namprd04.prod.outlook.com
 (2603:10b6:104:6::24) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ee78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eab59242-23fe-4469-0464-08d77e9987ae
x-ms-traffictypediagnostic: MN2PR15MB2526:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2526975499DA0C9B9E5845E9D5550@MN2PR15MB2526.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:356;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(376002)(366004)(346002)(39860400002)(396003)(136003)(189003)(199004)(6506007)(53546011)(81166006)(8676002)(8936002)(81156014)(6486002)(52116002)(66476007)(66946007)(64756008)(66446008)(66556008)(71200400001)(4326008)(6512007)(9686003)(5660300002)(1076003)(186003)(478600001)(86362001)(54906003)(6916009)(2906002)(316002)(33716001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2526;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vCkuwsnPcRYN/AiqnGCy7NyqajaF0oqlSgfSv04/GYhuNreKSfWDkLzAIiGk0f2JH3oy4VPbOjpqGtt2vkaOZ+5kgEX9FQ9NJSgQ5jBeUfRtIheB/olv/eB9dO7pCZ2viuoW0/c8/BypK2+vNss7N0EjXKMVn8FC2Ay0sw24oi3oognS+ZP1AhmgTq0ZfMaHd0j0I1Sn5zg5q6E/llVr6K85PETEmXg7feMWb9fruCHeUitXZWMO/7Vsr6ZDyjt/k5XRkY9abnNwB7K4lYGK3Jh4EjF+eshiHfUsOuUuO3BIfnILj9S5ckv0JyMDBUHFcqCo/V5PGoea8xc/4eD3Nb9RamAccU1n7vrP9latk2LpgIYMpFAOFLFvmdCnw6XX5pp+wRisgraCe7zVuxaf9WaW3LUsk5TQYt24bwtqKS1U9pXtBBlv8kSAL5iz+JYY
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94046CFA44F2554C97F56E70667F5CD1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eab59242-23fe-4469-0464-08d77e9987ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 00:23:36.8968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xzls3Do1LCc0XYW8sO1f6bv4+y0kRmQE12hWdIOb+0aq9mcSnRYINSSmPYAkpJgV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2526
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912120000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 04:11:40PM -0800, Andrii Nakryiko wrote:
> On Wed, Dec 11, 2019 at 4:09 PM Martin Lau <kafai@fb.com> wrote:
> >
> > On Wed, Dec 11, 2019 at 11:26:34AM -0800, Andrii Nakryiko wrote:
> > > On ppc64le __u64 and __s64 are defined as long int and unsigned long =
int,
> > > respectively. This causes compiler to emit warning when %lld/%llu are=
 used to
> > > printf 64-bit numbers. Fix this by casting directly to unsigned long =
long
> > > (through shorter typedef). In few cases casting error code to int exp=
licitly
> > > is cleaner, so that's what's done instead.
> > >
> > > Fixes: 1f8e2bcb2cd5 ("libbpf: Refactor relocation handling")
> > > Fixes: abd29c931459 ("libbpf: allow specifying map definitions using =
BTF")
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 34 ++++++++++++++++++----------------
> > >  1 file changed, 18 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 3f09772192f1..5ee54f9355a4 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -128,6 +128,8 @@ void libbpf_print(enum libbpf_print_level level, =
const char *format, ...)
> > >  # define LIBBPF_ELF_C_READ_MMAP ELF_C_READ
> > >  #endif
> > >
> > > +typedef unsigned long long __pu64;
> > > +
> > >  static inline __u64 ptr_to_u64(const void *ptr)
> > >  {
> > >       return (__u64) (unsigned long) ptr;
> > > @@ -1242,15 +1244,15 @@ static int bpf_object__init_user_btf_map(stru=
ct bpf_object *obj,
> > >                       }
> > >                       sz =3D btf__resolve_size(obj->btf, t->type);
> > >                       if (sz < 0) {
> > > -                             pr_warn("map '%s': can't determine key =
size for type [%u]: %lld.\n",
> > > -                                     map_name, t->type, sz);
> > > +                             pr_warn("map '%s': can't determine key =
size for type [%u]: %d.\n",
> > > +                                     map_name, t->type, (int)sz);
> > >                               return sz;
> > >                       }
> > > -                     pr_debug("map '%s': found key [%u], sz =3D %lld=
.\n",
> > > -                              map_name, t->type, sz);
> > > +                     pr_debug("map '%s': found key [%u], sz =3D %d.\=
n",
> > > +                              map_name, t->type, (int)sz);
> > >                       if (map->def.key_size && map->def.key_size !=3D=
 sz) {
> > > -                             pr_warn("map '%s': conflicting key size=
 %u !=3D %lld.\n",
> > > -                                     map_name, map->def.key_size, sz=
);
> > > +                             pr_warn("map '%s': conflicting key size=
 %u !=3D %d.\n",
> > > +                                     map_name, map->def.key_size, (i=
nt)sz);
> > >                               return -EINVAL;
> > >                       }
> > >                       map->def.key_size =3D sz;
> > > @@ -1285,15 +1287,15 @@ static int bpf_object__init_user_btf_map(stru=
ct bpf_object *obj,
> > >                       }
> > >                       sz =3D btf__resolve_size(obj->btf, t->type);
> > >                       if (sz < 0) {
> > > -                             pr_warn("map '%s': can't determine valu=
e size for type [%u]: %lld.\n",
> > > -                                     map_name, t->type, sz);
> > > +                             pr_warn("map '%s': can't determine valu=
e size for type [%u]: %d.\n",
> > > +                                     map_name, t->type, (int)sz);
> > >                               return sz;
> > >                       }
> > > -                     pr_debug("map '%s': found value [%u], sz =3D %l=
ld.\n",
> > > -                              map_name, t->type, sz);
> > > +                     pr_debug("map '%s': found value [%u], sz =3D %d=
.\n",
> > > +                              map_name, t->type, (int)sz);
> > >                       if (map->def.value_size && map->def.value_size =
!=3D sz) {
> > > -                             pr_warn("map '%s': conflicting value si=
ze %u !=3D %lld.\n",
> > > -                                     map_name, map->def.value_size, =
sz);
> > > +                             pr_warn("map '%s': conflicting value si=
ze %u !=3D %d.\n",
> > > +                                     map_name, map->def.value_size, =
(int)sz);
> > It is not an error case (i.e. not sz < 0) here.
> > Same for the above pr_debug().
>=20
> You are right, not sure if it matters in practice, though. Highly
> unlikely values will be bigger than 2GB, but even if they, they still
> fit in 4 bytes, we'll just report them as negative values. I can do
Then may be everything to int without adding __pu64?

> similar __ps64 conversion, as for __pu64, though, it we are afraid
> it's going to be a problem.
