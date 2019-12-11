Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3648211BD22
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLKTig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:38:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49108 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbfLKTif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:38:35 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBJYSOV019121;
        Wed, 11 Dec 2019 11:38:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aCLAKSjScmzpDh1ttzei3EpS9VOdq8M1dqgoTfO/E5Y=;
 b=V+mzbPqxiNcqrvEtoxc5IaS9N2xHFtJNUHMXJxYfqG1YD/JzNtQRYSpuEJziN5jhfvhi
 X7jJbuO4YhMcwod+jA0WLipRQMlRbmaqldqml2/J7adF+0UIRhUAhNpq4LSQDz2e94ax
 9sUZpN25jJ4MwIua8gU8Ii+bvlV+AC3pHxg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu2gf1cra-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 11:38:22 -0800
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 11:38:14 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 11:38:14 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Dec 2019 11:38:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdJPGHcLfu90lcOWY0z0eL2ExPOW0pwG1/cVAmM+adSZrmfltWi7DA/kNpVVSd3qm3PY/naB146kk1sDZ5ppP0L4v/YwR0CN9aibgG1iTZGvQ1PRKRc4gaGcVa/6HkiWIgLg1t9cL+QOYFsUE4JmzMSkbQPjRmABLVttwGPprVPfeZpDuYgIi7e5ZjYACnlyqVJl1DsAalrs7exCL9ZaAzDjEbDfOFE9z12Cig4w9yPSpMRdfZqyzPu6dfW3i6eI3Pd230Mlh2kYqPdLgHz6Cn8FbeS5RPxNxG98oyf0dcnhf/7oW9FDiQ+Wbw7Ew2sCiSmrqpIvNFNy3vOU6ILK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCLAKSjScmzpDh1ttzei3EpS9VOdq8M1dqgoTfO/E5Y=;
 b=n9epAj/qWQZvlzinyD/QEcmlS2IRHdiDjdWbPw2jwUIf3X2OY+P+Su4EF0wkUaQEghGj/FmkduY9ATdQxYM+uihXUrwKkUEWmXMepdWpcF5qGET25hlLNt7Y77B6Av+SuaUot/PzltZRUjEMzf+Obfw+SYBfUrHnINr9yrgFg05rwb5aDRjth5IUz1T1J5cllSL3vfU/vnrj9pEij9BM5X2n/Rtzf62qirv4TqSOEYfV2PUyxK1CORbqdGWDQWUkA2MqxAy8Qr4E1DAJM4CtCGqZyHTO3mMjoaDXkCB6ThImHsUeIXNngsi7c7nIZFtnzYWRuMH3h4482lLHq6rFDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCLAKSjScmzpDh1ttzei3EpS9VOdq8M1dqgoTfO/E5Y=;
 b=Bw8bthNccukiuQqbWf/8fktmcT4XIDrHsvY2r23VFVadnSL3qs9sSf17eLXTZ14bEsPumFPYAQq+MhOEplCW7y1+zJM3i2Yki6iE/e8+EE0WgsZpR/zw4BzgPXngMeBeEhMfCvFqwg9F/8V4S8+SFXyU5qI65z09SYbuNu8swBg=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3038.namprd15.prod.outlook.com (20.178.254.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 11 Dec 2019 19:38:11 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 19:38:11 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 06/15] libbpf: expose BPF
 program's function name
Thread-Topic: [Potential Spoof] [PATCH bpf-next 06/15] libbpf: expose BPF
 program's function name
Thread-Index: AQHVrvdZyZ4inVs3WEChnRyXP7K9U6e1VxeA
Date:   Wed, 11 Dec 2019 19:38:11 +0000
Message-ID: <20191211193807.raz42oiqmrm763tr@kafai-mbp>
References: <20191210011438.4182911-1-andriin@fb.com>
 <20191210011438.4182911-7-andriin@fb.com>
In-Reply-To: <20191210011438.4182911-7-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:300:4b::27) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ee78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 858ff44b-3256-47fe-e2d4-08d77e71a826
x-ms-traffictypediagnostic: MN2PR15MB3038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3038B5FA38C76A9A1EF8D95ED55A0@MN2PR15MB3038.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:586;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(366004)(39860400002)(136003)(376002)(346002)(189003)(199004)(86362001)(66556008)(66476007)(2906002)(6636002)(33716001)(66446008)(478600001)(1076003)(6486002)(316002)(64756008)(54906003)(81156014)(81166006)(6512007)(5660300002)(8676002)(6862004)(52116002)(186003)(4326008)(8936002)(6506007)(66946007)(71200400001)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3038;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jW/Qlpkr2CD8IbROld6oqzH2hkU+lvF8KlsQwX37hw29wHsCwQKMKzbiHl/QFbJWTxROsKKS7QonN5+/QykIXoqmNQmjaEYweRErZHTHpfh+vWKE+mKda1BZecVzD1qAE6st0+WnXpTGL926unv3QJ2drdmG2zaLmhdPZpzSpeEruJrAu840FF/zIaNP7BO0SSalwc/NGtBu3TJn66aNAJ9zWdmt3skxNwfq9fY6KOtW1Sn8boEQLu+YX/Ldt132eohZnjrNzV/BAnGIy2RRwj5+95WrRZDBP3Kn/40k0sjEsCm3TUP6Pq90w2WTzVLNdDlseiRYTjooLBm2gZbbtXPuSFdgBKgdkR5SPyfq0jrukJI2ZsdgCIuWOPMDziUoAaR5C99DEQZm3paTql+lEAvieqghaWXpjxvCV24nwdRYkdpSMW+tVus2uaDaH/lh
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E5BF7EAD3FF60A479738628BA602F1CA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 858ff44b-3256-47fe-e2d4-08d77e71a826
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 19:38:11.7357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7vbAsa0iiBlF/1ALwWK+v1p8xjwa8/yQHSMNUCX56A3fh8a5GWFCcIdCNWBOPEkK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3038
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_06:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912110162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 05:14:29PM -0800, Andrii Nakryiko wrote:
> Add APIs to get BPF program function name, as opposed to bpf_program__tit=
le(),
> which returns BPF program function's section name. Function name has a be=
nefit
> of being a valid C identifier and uniquely identifies a specific BPF prog=
ram,
> while section name can be duplicated across multiple independent BPF prog=
rams.
>=20
> Add also bpf_object__find_program_by_name(), similar to
> bpf_object__find_program_by_title(), to facilitate looking up BPF program=
s by
> their C function names.
>=20
> Convert one of selftests to new API for look up.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c                        | 28 +++++++++++++++----
>  tools/lib/bpf/libbpf.h                        |  9 ++++--
>  tools/lib/bpf/libbpf.map                      |  2 ++
>  .../selftests/bpf/prog_tests/rdonly_maps.c    | 11 +++-----
>  4 files changed, 36 insertions(+), 14 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index edfe1cf1e940..f13752c4d271 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -209,8 +209,8 @@ static const char * const libbpf_type_to_btf_name[] =
=3D {
>  };
> =20
>  struct bpf_map {
> -	int fd;
>  	char *name;
> +	int fd;
This change, and

>  	int sec_idx;
>  	size_t sec_offset;
>  	int map_ifindex;
> @@ -1384,7 +1384,7 @@ static int bpf_object__init_user_btf_maps(struct bp=
f_object *obj, bool strict,
>  }
> =20
>  static int bpf_object__init_maps(struct bpf_object *obj,
> -				 struct bpf_object_open_opts *opts)
> +				 const struct bpf_object_open_opts *opts)
here, and a few other const changes,

are all good changes.  If they are not in a separate patch, it will be usef=
ul
to the reviewer if there is commit messages mentioning there are some
unrelated cleanup changes.  I have been looking at where it may cause
compiler warning because of this change, or I missed something?

>  {
>  	const char *pin_root_path =3D OPTS_GET(opts, pin_root_path, NULL);
>  	bool strict =3D !OPTS_GET(opts, relaxed_maps, false);
> @@ -1748,6 +1748,19 @@ bpf_object__find_program_by_title(const struct bpf=
_object *obj,
>  	return NULL;
>  }
> =20
> +struct bpf_program *
> +bpf_object__find_program_by_name(const struct bpf_object *obj,
> +				 const char *name)
> +{
> +	struct bpf_program *prog;
> +
> +	bpf_object__for_each_program(prog, obj) {
> +		if (!strcmp(prog->name, name))
> +			return prog;
> +	}
> +	return NULL;
> +}
> +
>  static bool bpf_object__shndx_is_data(const struct bpf_object *obj,
>  				      int shndx)
>  {
> @@ -3893,7 +3906,7 @@ static int libbpf_find_attach_btf_id(const char *na=
me,
>  				     __u32 attach_prog_fd);
>  static struct bpf_object *
>  __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf=
_sz,
> -		   struct bpf_object_open_opts *opts)
> +		   const struct bpf_object_open_opts *opts)
>  {
>  	struct bpf_program *prog;
>  	struct bpf_object *obj;
> @@ -4002,7 +4015,7 @@ struct bpf_object *bpf_object__open(const char *pat=
h)
>  }
> =20
>  struct bpf_object *
> -bpf_object__open_file(const char *path, struct bpf_object_open_opts *opt=
s)
> +bpf_object__open_file(const char *path, const struct bpf_object_open_opt=
s *opts)
>  {
>  	if (!path)
>  		return ERR_PTR(-EINVAL);
> @@ -4014,7 +4027,7 @@ bpf_object__open_file(const char *path, struct bpf_=
object_open_opts *opts)
> =20
>  struct bpf_object *
>  bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
> -		     struct bpf_object_open_opts *opts)
> +		     const struct bpf_object_open_opts *opts)
>  {
>  	if (!obj_buf || obj_buf_sz =3D=3D 0)
>  		return ERR_PTR(-EINVAL);
> @@ -4819,6 +4832,11 @@ void bpf_program__set_ifindex(struct bpf_program *=
prog, __u32 ifindex)
>  	prog->prog_ifindex =3D ifindex;
>  }
> =20
> +const char *bpf_program__name(const struct bpf_program *prog)
> +{
> +	return prog->name;
> +}
> +
>  const char *bpf_program__title(const struct bpf_program *prog, bool need=
s_copy)
>  {
>  	const char *title;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index fa803dde1f46..7fa583ebe56f 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -114,10 +114,10 @@ struct bpf_object_open_opts {
> =20
>  LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>  LIBBPF_API struct bpf_object *
> -bpf_object__open_file(const char *path, struct bpf_object_open_opts *opt=
s);
> +bpf_object__open_file(const char *path, const struct bpf_object_open_opt=
s *opts);
>  LIBBPF_API struct bpf_object *
>  bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
> -		     struct bpf_object_open_opts *opts);
> +		     const struct bpf_object_open_opts *opts);
> =20
>  /* deprecated bpf_object__open variants */
>  LIBBPF_API struct bpf_object *
> @@ -156,6 +156,7 @@ struct bpf_object_load_attr {
>  LIBBPF_API int bpf_object__load(struct bpf_object *obj);
>  LIBBPF_API int bpf_object__load_xattr(struct bpf_object_load_attr *attr)=
;
>  LIBBPF_API int bpf_object__unload(struct bpf_object *obj);
> +
>  LIBBPF_API const char *bpf_object__name(const struct bpf_object *obj);
>  LIBBPF_API unsigned int bpf_object__kversion(const struct bpf_object *ob=
j);
> =20
> @@ -166,6 +167,9 @@ LIBBPF_API int bpf_object__btf_fd(const struct bpf_ob=
ject *obj);
>  LIBBPF_API struct bpf_program *
>  bpf_object__find_program_by_title(const struct bpf_object *obj,
>  				  const char *title);
> +LIBBPF_API struct bpf_program *
> +bpf_object__find_program_by_name(const struct bpf_object *obj,
> +				 const char *name);
> =20
>  LIBBPF_API struct bpf_object *bpf_object__next(struct bpf_object *prev);
>  #define bpf_object__for_each_safe(pos, tmp)			\
> @@ -209,6 +213,7 @@ LIBBPF_API void *bpf_program__priv(const struct bpf_p=
rogram *prog);
>  LIBBPF_API void bpf_program__set_ifindex(struct bpf_program *prog,
>  					 __u32 ifindex);
> =20
> +LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog)=
;
>  LIBBPF_API const char *bpf_program__title(const struct bpf_program *prog=
,
>  					  bool needs_copy);
> =20
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 757a88f64b5a..f2b2fa0f5c2a 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -211,5 +211,7 @@ LIBBPF_0.0.6 {
> =20
>  LIBBPF_0.0.7 {
>  	global:
> +		bpf_object__find_program_by_name;
>  		bpf_program__attach;
> +		bpf_program__name;
>  } LIBBPF_0.0.6;
> diff --git a/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c b/tools=
/testing/selftests/bpf/prog_tests/rdonly_maps.c
> index d90acc13d1ec..563e12120e77 100644
> --- a/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
> +++ b/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
> @@ -16,14 +16,11 @@ struct rdonly_map_subtest {
> =20
>  void test_rdonly_maps(void)
>  {
> -	const char *prog_name_skip_loop =3D "raw_tracepoint/sys_enter:skip_loop=
";
> -	const char *prog_name_part_loop =3D "raw_tracepoint/sys_enter:part_loop=
";
> -	const char *prog_name_full_loop =3D "raw_tracepoint/sys_enter:full_loop=
";
>  	const char *file =3D "test_rdonly_maps.o";
>  	struct rdonly_map_subtest subtests[] =3D {
> -		{ "skip loop", prog_name_skip_loop, 0, 0 },
> -		{ "part loop", prog_name_part_loop, 3, 2 + 3 + 4 },
> -		{ "full loop", prog_name_full_loop, 4, 2 + 3 + 4 + 5 },
> +		{ "skip loop", "skip_loop", 0, 0 },
> +		{ "part loop", "part_loop", 3, 2 + 3 + 4 },
> +		{ "full loop", "full_loop", 4, 2 + 3 + 4 + 5 },
>  	};
>  	int i, err, zero =3D 0, duration =3D 0;
>  	struct bpf_link *link =3D NULL;
> @@ -50,7 +47,7 @@ void test_rdonly_maps(void)
>  		if (!test__start_subtest(t->subtest_name))
>  			continue;
> =20
> -		prog =3D bpf_object__find_program_by_title(obj, t->prog_name);
> +		prog =3D bpf_object__find_program_by_name(obj, t->prog_name);
>  		if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
>  			  t->prog_name))
>  			goto cleanup;
> --=20
> 2.17.1
>=20
