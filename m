Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9C938BA6B
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhETXgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:36:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234076AbhETXgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 19:36:37 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KNTWUD025163;
        Thu, 20 May 2021 16:34:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1QQzZhM+n6Cet4327dMUy/DwT/NWyy/WdIJ8Et3+kcc=;
 b=HCGN9vFVC212AGNSQq7lGoFzCVKMqvls7dD3NxZVwNmmC7kV7736n3ddr7ysCl06Jy+V
 EwWvOnMzHBkuZuViPcTV8XbA30yBUMB+9bbbUofCm0CobYpiAQ4eyKVCpoTjKT26EDE5
 OKcYuus65feJZvgSUxoYa4E8zQuRuhS4oVA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38n6p31e98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 16:34:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 16:34:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoEITGKk0upPEfQ2YsUK4RE21jtHLa6T5WESsYyAFzVdWxeGV1qPGV3ms7U7xvWjt+Gb0BMD2uF4b4C1vZWpJxX2rGgriuWUc+Jut9U2wy9NopGadIsK7jZAqzY860Hs2sioxZOZWU+Gt0O0Orb8ywm/eZ9wLhgqAhKU2ttx+fgVuggVoc/gKO0cqJyoPS5QHgdReLCSGWqv3l9TXyLJxTS9kQSGA0k1wWWqsjioJnKnJ0Nx2jTP0aQXFl8XD9jfkEpWe8/9lPYTLyldApK5zHUq0V+r0Hd4yz1oulq7qWd1CSrB7lJyilGH39xJTucme+qtXpJC7HhW+IioEHckMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QQzZhM+n6Cet4327dMUy/DwT/NWyy/WdIJ8Et3+kcc=;
 b=oSfUH9NRZX5VBwMS2n5iFGLaqzyWALN/S4neao2rqyhhga4adBAUMnuE9pfWo8HuiuAODN5dFg4SKbkCfEZx1ftyZ7o4E0KkclCO9W4aV8CtMxoMNKnBbYfrS6NgyD2Ul3Esu9lU1LGgNJ8MWfd5RZI8D98zDcmmyoZdm54Za+3M7ACalbXsUDthkkGBeg3cgQqRV1QhEfaMhc/OLx91quJXRqUeTlA4LQBwYqNI72B+YmuLa1JQiD0ON/c+cvQtbtm6JG13j+A7CZbeJzV5jVmBdGEQL6Yn85POV6TWIz/ufebylEQCVkyeATJFV3Kg43XnYNw7gJhOUJZT/tB52w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2727.namprd15.prod.outlook.com (2603:10b6:a03:15b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 23:34:47 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 23:34:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: Re: [PATCH 12/23] bpf: add IOURING program type
Thread-Topic: [PATCH 12/23] bpf: add IOURING program type
Thread-Index: AQHXTLk7OfFP8xaRkUu1T84OwY8azqrtB/uA
Date:   Thu, 20 May 2021 23:34:47 +0000
Message-ID: <5F31E9DE-9DB5-4FEB-AFAD-685F71093105@fb.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <3883680d4638504e3dcf79bf1c15d548a9cb7f3e.1621424513.git.asml.silence@gmail.com>
In-Reply-To: <3883680d4638504e3dcf79bf1c15d548a9cb7f3e.1621424513.git.asml.silence@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 506d6bb5-5ca8-4bd6-f986-08d91be7db34
x-ms-traffictypediagnostic: BYAPR15MB2727:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2727F133F5229433DE845CB6B32A9@BYAPR15MB2727.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DXY4ytkeJpxOuMFoY2aTEF0TT3SElPjF0uJdmdwsia5sQy2vxpoidKvPHbh2Q7k0kAwtkhLWolGBXTCPsLf7r3INOXbriYpQeLVB0b01lMRRPQNe4p5NSHj6DN+vxuksQAzh2XlNhXJdg5pOhiwgPrs8O3pocSqq1nnLFSX4oktoQ1HIYbVUqdh71MMxE4JpbvWI+QXNWp6IHc6xBaMcpCUndfQr4e+eBdSX/+cbj0sz0XDxjLZuJidE/n4hQvk4zaS73m08vsz5C92d3XfO8ez9/uPU4M5UKOcm2suapkl6n4VNBb5A+ZguOxfCvsPHDGvcj+iAbCewt+fxG6vQu0VvnZWBKuw53Nm1yAXBt9WjFs6Kud/3iCo+UVOAgOhgVduR7D4kBuvOW1nmPe2ezT7hWXVEWniY+tEtzOK3YS/W7Ph5NIj1skZR6DqBVP1T4QC7X/IHjay6eh/fRGh2HcWNejhaIgVIIuYE00weY/XRLKRdI2yT8Oy2Eu/9nEfbu7AU5HFDqr1Gb5/4DDud/phrRdK4EVyNx3/iONHQwl/egYdr/2QgGRWpvwYE8zYpi0ymwmsCMPmfCeoK8+4lkXESBojgf6NpsUEcWnZm+2UYnjIttenn5d2gHbWdoyuH+eWjfauLII7lp/BO2VjvubPDq69XlnB74JCCv8AmpIw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(316002)(6512007)(76116006)(91956017)(5660300002)(83380400001)(71200400001)(2616005)(186003)(478600001)(66556008)(86362001)(7416002)(54906003)(122000001)(38100700002)(6506007)(53546011)(36756003)(66946007)(33656002)(2906002)(6916009)(66476007)(4326008)(8676002)(64756008)(66446008)(8936002)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UHVr2CRy5VwNfrQ4BNODacz4ytnZnFhCNQihHKhDKTT89yAoIzvIua8zNLOY?=
 =?us-ascii?Q?wnEqkaYh7r+FetzDD/qyef1OoufCeO7MqKyQJAc3tO0/68CDnosyV/qgfcsy?=
 =?us-ascii?Q?JBvRLYuCNk2GYGnjXAhECDUoC60GGqg6c0n67F7Yyka+FEIj39D7xP+irjMT?=
 =?us-ascii?Q?upOmPgHwfspWmg1Tnb8ZgXcZrz4uvigerjgUjkbbrr4dJNQDUunxCjyaeQP7?=
 =?us-ascii?Q?YhAsPUJVQOzEJHh3IQousVXkXT954m2AwO/PN/ZvqeOyh9T3NBED6XEHPLEK?=
 =?us-ascii?Q?IgWE6kxScpkV1VqFn0oB7X5KTtZcZW/bL60vGJFiHhoX/90MYoP1E4A1p4Ek?=
 =?us-ascii?Q?P7O0e/JVeS1rluThDhD5hlLooAp0QWRunE6+hWDpU5V/pRXfn4tndqx/dZ7w?=
 =?us-ascii?Q?qU+hxQ5bSxTcmjk5je3YowOVJ/O48WIRSv/DI1TT3ZKyUN5KSnWmnEzBZ3i8?=
 =?us-ascii?Q?7yZKEfI7r41i0IX9QzJmnQF3Pw5HnVQ6Z8s0ID238MpsZDchldNqwXNoLAMS?=
 =?us-ascii?Q?GTgegwlrdBy/wl2CSqjb/PMY/yh9JF+704+/LZSg4SnnNP9uVXAxQr/bmbmA?=
 =?us-ascii?Q?CYotsl2hJAUoRU+q/Yq4OD9E5pLLQbLQxR/aewvXpMos+PBD9ttpCaGhBMrG?=
 =?us-ascii?Q?jWnOVKMLY2BfAG9NOnIqLZIFpjGHMOLMsl61HjywAdQsu+vOKFseyya3L8H2?=
 =?us-ascii?Q?UBgV2zFSsQ5z9yFiB78ca51shpg3PjMbKc4aCYX7nPKBj5JHdGg5KbEDxGNX?=
 =?us-ascii?Q?27QYYh2srJAEQ42UV58UiLB9VtYBS52Ndc6izfIScHW4ZKPWAM1LKppxzLwM?=
 =?us-ascii?Q?+5jkHilUYRnqX8wxEq6THXbFPe57sJUV1OyJ7qmpOPHuTmzltdU/P4Q9nm8C?=
 =?us-ascii?Q?MaLzipQfeh6JQO/V0dogLmC1QfXkxeV8XfX4mAPONCTLNrWfFrocVRmxxFVA?=
 =?us-ascii?Q?PLLzeeVxVAZoS5cOpldc5ysCZHWyZCEFWFpLRuvP3SVsUKbc8xfaPFmF0yBg?=
 =?us-ascii?Q?fALoCQdxJWqLT8UlUvVGdB50KVwWjKAUEp53qvtYoxmK7TQdA4vW8ok3dyk2?=
 =?us-ascii?Q?gsGxH62gkzwEQmlr70T/+Zdvr2l9UafMaHuVW25hkhZLsFw9YcbmNm7OikM/?=
 =?us-ascii?Q?1JKRbubkDvvfM0CR9ErvanbTedwVuPGoAFWfyLvfT2rkErWgAibcNlIAxstj?=
 =?us-ascii?Q?ZWoFWORKBmhhrmfaQPfUZh5glhPuCSRHm9N9u4tDyBD6pgikc0yUx3RNiDpj?=
 =?us-ascii?Q?AHpQ9A3VIdCCc66677PuW4RWOTvjnLuEq/CIA9HFpt3uy7cU6qWHyYrosEN9?=
 =?us-ascii?Q?ohPNeQJZTRzyl4ssuLEOF1BnG5noIrvSpwqgV+FasI35TmoJCrRQamvEKhmD?=
 =?us-ascii?Q?3KwYPJM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19EF86D8FE51084DB877AF232177FA95@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 506d6bb5-5ca8-4bd6-f986-08d91be7db34
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 23:34:47.7054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j2T2rL9d13TdMQJxrZe8+zcp9pcJ0WlaDd+RsjYqjTJ6mids8MQkuCocqj/ojVR5zG8JKKwgQ+2OuPvIe0r9NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: -cSKgsBX2XDQ5aL2_K04bXuqA5q0miyl
X-Proofpoint-GUID: -cSKgsBX2XDQ5aL2_K04bXuqA5q0miyl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_07:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 suspectscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105200152
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 19, 2021, at 7:13 AM, Pavel Begunkov <asml.silence@gmail.com> wrot=
e:
>=20
> Draft a new program type BPF_PROG_TYPE_IOURING, which will be used by
> io_uring to execute BPF-based requests.
>=20
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> fs/io_uring.c             | 21 +++++++++++++++++++++
> include/linux/bpf_types.h |  2 ++
> include/uapi/linux/bpf.h  |  1 +
> kernel/bpf/syscall.c      |  1 +
> kernel/bpf/verifier.c     |  5 ++++-
> 5 files changed, 29 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 1a4c9e513ac9..882b16b5e5eb 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -10201,6 +10201,27 @@ static int __io_uring_register(struct io_ring_ct=
x *ctx, unsigned opcode,
> 	return ret;
> }
>=20
> +static const struct bpf_func_proto *
> +io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +	return bpf_base_func_proto(func_id);
> +}
> +
> +static bool io_bpf_is_valid_access(int off, int size,
> +				   enum bpf_access_type type,
> +				   const struct bpf_prog *prog,
> +				   struct bpf_insn_access_aux *info)
> +{
> +	return false;
> +}
> +
> +const struct bpf_prog_ops bpf_io_uring_prog_ops =3D {};
> +
> +const struct bpf_verifier_ops bpf_io_uring_verifier_ops =3D {
> +	.get_func_proto		=3D io_bpf_func_proto,
> +	.is_valid_access	=3D io_bpf_is_valid_access,
> +};
> +
> SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode=
,
> 		void __user *, arg, unsigned int, nr_args)
> {
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 99f7fd657d87..d0b7954887bd 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -77,6 +77,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
> 	       void *, void *)
> #endif /* CONFIG_BPF_LSM */
> #endif
> +BPF_PROG_TYPE(BPF_PROG_TYPE_IOURING, bpf_io_uring,
> +	      void *, void *)
>=20
> BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
> BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4ba4ef0ff63a..de544f0fbeef 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -206,6 +206,7 @@ enum bpf_prog_type {
> 	BPF_PROG_TYPE_EXT,
> 	BPF_PROG_TYPE_LSM,
> 	BPF_PROG_TYPE_SK_LOOKUP,
> +	BPF_PROG_TYPE_IOURING,
> };
>=20
> enum bpf_attach_type {
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 250503482cda..6ef7a26f4dc3 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2041,6 +2041,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_ty=
pe prog_type)
> 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
> 	case BPF_PROG_TYPE_SOCK_OPS:
> +	case BPF_PROG_TYPE_IOURING:
> 	case BPF_PROG_TYPE_EXT: /* extends any prog */
> 		return true;
> 	case BPF_PROG_TYPE_CGROUP_SKB:
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 0399ac092b36..2a53f44618a7 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -8558,6 +8558,9 @@ static int check_return_code(struct bpf_verifier_en=
v *env)
> 	case BPF_PROG_TYPE_SK_LOOKUP:
> 		range =3D tnum_range(SK_DROP, SK_PASS);
> 		break;
> +	case BPF_PROG_TYPE_IOURING:
> +		range =3D tnum_const(0);
> +		break;
> 	case BPF_PROG_TYPE_EXT:
> 		/* freplace program can return anything as its return value
> 		 * depends on the to-be-replaced kernel func or bpf program.
> @@ -12560,7 +12563,7 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
> 	u64 key;
>=20
> 	if (prog->aux->sleepable && prog->type !=3D BPF_PROG_TYPE_TRACING &&
> -	    prog->type !=3D BPF_PROG_TYPE_LSM) {
> +	    prog->type !=3D BPF_PROG_TYPE_LSM && prog->type !=3D BPF_PROG_TYPE_=
IOURING) {

Is IOURING program sleepable? If so, please highlight that in the commit lo=
g=20
and update the warning below.=20

> 		verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepa=
ble\n");
> 		return -EINVAL;
> 	}
> --=20
> 2.31.1
>=20

