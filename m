Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DFA137604
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgAJS3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:29:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726346AbgAJS3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:29:54 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00AIMYeU030982;
        Fri, 10 Jan 2020 10:29:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VYgIXaoE1ZbpLzFtNCf2kMgepRA1dTohr/zxApfrkD0=;
 b=bLj6rOTULgOy6ZqC/hQZpmA+YF3v7karjdn4sMclRUxLpiCsfgGNUzlmmcTqO/Aevie2
 otXlmHB4th6V5wmq86hHYQLYFLFMirDsVWEBooyJxQVrqi2TSAp8QEdmvPhUE1xMFpg+
 y9+0j+sY08OqlXXjLHloaWdxsWjZVyg/aWk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xev8f91vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Jan 2020 10:29:41 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 10 Jan 2020 10:29:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZ9zru6PLDdbaOLhsWY3n4isR/61h50WaAc5jFuPvDC+nKW5KDarBCKp99A/lXKDpV4hn/XW+EHsle/IhWz/wfcCkx6422jq7o7OHkhtoo8a4yJEqau/1y2glORAHO7LAbaU6wWN6PrXZIBOJU0CrF3iCx15ia3eETuavMvr+FoZxotbGblpFBpazx3AVGHz935W330iGTstgUA0KC/LXsknIqE5ZZokRjmkRs6i+nuXHILW/aIhYbb8Rp+34ke+AfbeD2ni7r3G1SAQUyjdZSo5Y0dNnvN7BsgpRMmHvYnCqsSSfMCgeo06a3PiWppYdgQgNam7xKZ4eiV9Thn97w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYgIXaoE1ZbpLzFtNCf2kMgepRA1dTohr/zxApfrkD0=;
 b=UGaA+xeghJGdCYJMbU91y3JL6qCyARUe57YGItwNI3oxcUc6ewtBhhXmBvMj9YNQhYrSC6ligcyeJ0gzFHwkk77HCxKHJjyUhSy9CYRrw7hxaZtNAH8LjFgeaZlM7qH7s8XpfBIHSIaCOgXysT0OE8f/LOPZfeDKO5l4mFdd83D4rhZotXI+p/leuH2yTuhpYIX0DXGkIoBmGppNokME/HgJDlsvzmsUiJ1g8n+6jTrMItttDJZ37yHAA0s2DgF8V6qfNeB6o4u4fIKsCkLXqf0IMWmXj7o81Tpwe/w4e2zzSKP4bKpl5LZglN9d+sMPNzo7zu/0d64R6bfrtB2EPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYgIXaoE1ZbpLzFtNCf2kMgepRA1dTohr/zxApfrkD0=;
 b=BYi3mYC8niiMdIAiBzjs7pF4w+ICAWmLt3zBSk+OdcywDDp9vAht7oBbOpG/MIbxxcplAtjUMrsznkjn+/zX39udgzYAO7PfWfNZm/sMOPnSuKW9l6EJIClZZ2HgfBYJcdU029UfT1SSKbHH66wZXdJxzvm55kuuETVJGuDiEPI=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2863.namprd15.prod.outlook.com (20.178.251.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 18:29:39 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.011; Fri, 10 Jan 2020
 18:29:39 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::3:1c91) by MWHPR19CA0005.namprd19.prod.outlook.com (2603:10b6:300:d4::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend Transport; Fri, 10 Jan 2020 18:29:38 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] libbpf: poison kernel-only
 integer types
Thread-Topic: [Potential Spoof] [PATCH bpf-next] libbpf: poison kernel-only
 integer types
Thread-Index: AQHVx+KEkj7HNflnQki8BYExfs3BD6fkOAyA
Date:   Fri, 10 Jan 2020 18:29:39 +0000
Message-ID: <20200110182935.5qpo45dnzcrboqu5@kafai-mbp.dhcp.thefacebook.com>
References: <20200110181916.271446-1-andriin@fb.com>
In-Reply-To: <20200110181916.271446-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0005.namprd19.prod.outlook.com
 (2603:10b6:300:d4::15) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:1c91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9253885b-2453-4002-a368-08d795fb0d4b
x-ms-traffictypediagnostic: MN2PR15MB2863:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB28637EE954C0DE101784745CD5380@MN2PR15MB2863.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:113;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(346002)(39860400002)(366004)(189003)(199004)(186003)(16526019)(81166006)(316002)(1076003)(66556008)(6636002)(66946007)(64756008)(66446008)(55016002)(2906002)(66476007)(9686003)(6506007)(86362001)(71200400001)(81156014)(54906003)(8936002)(5660300002)(4326008)(8676002)(478600001)(52116002)(6862004)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2863;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wmK/M01vhpHSR6cEfhfMcdbCwozevwBwBpl69OY6drqveWtPUFC/t6kgVr1Pdt0ZINJH0tkzV+SOWpvjeVH+0I9gthlmGF3rtdsCHlg7lB0nme0unq6htt73vxALTb6lB82zUNPNq5IWgvT7dl314Lom5bNaWq0h7/0DVfK6yDXNSX0qvkhpO4lQFk8ejngp/v96vEfqq9iy6uSbU3wbFBkWlGF5JVu2zmn5xvo0wLRm/QFMNKPbPrClPXIomNj6W0hOlREGfGsxjck83r85T+eiaQgK8N/Aom2fU6R8m7uBRX6zBzLNJIpSongbv6a9tVSqA0dOgeAn8mmhGfFlGa19JZYZcml4XrCEYcZoKzn9a+n1ql46Yw6yRE9ImY8/GrmLxoz2tQZmByf5zfJcBREHJnzfRNEKuqzE4iJtM9xqCFFV0PfF3zHaYkSGnU7G
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28F2120E4C3C5E448EEE36FE944C6183@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9253885b-2453-4002-a368-08d795fb0d4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 18:29:39.1034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C9Ljnm8RLOJGlPRhjSWAs/4qyAhVTIch42mPIX3S51hZzC+jMz3KCFmcutdDU7I3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2863
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 clxscore=1015 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 10:19:16AM -0800, Andrii Nakryiko wrote:
> It's been a recurring issue with types like u32 slipping into libbpf sour=
ce
> code accidentally. This is not detected during builds inside kernel sourc=
e
> tree, but becomes a compilation error in libbpf's Github repo. Libbpf is
> supposed to use only __{s,u}{8,16,32,64} typedefs, so poison {s,u}{8,16,3=
2,64}
> explicitly in every .c file. Doing that in a bit more centralized way, e.=
g.,
> inside libbpf_internal.h breaks selftests, which are both using kernel u3=
2 and
> libbpf_internal.h.
>=20
> This patch also fixes a new u32 occurence in libbpf.c, added recently.
>=20
> Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/bpf.c            | 3 +++
>  tools/lib/bpf/bpf_prog_linfo.c | 3 +++
>  tools/lib/bpf/btf.c            | 3 +++
>  tools/lib/bpf/btf_dump.c       | 3 +++
>  tools/lib/bpf/hashmap.c        | 3 +++
>  tools/lib/bpf/libbpf.c         | 5 ++++-
>  tools/lib/bpf/libbpf_errno.c   | 3 +++
>  tools/lib/bpf/libbpf_probes.c  | 3 +++
>  tools/lib/bpf/netlink.c        | 3 +++
>  tools/lib/bpf/nlattr.c         | 3 +++
>  tools/lib/bpf/str_error.c      | 3 +++
>  tools/lib/bpf/xsk.c            | 3 +++
>  12 files changed, 37 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index b0ecbe9ef2d4..500afe478e94 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -32,6 +32,9 @@
>  #include "libbpf.h"
>  #include "libbpf_internal.h"
> =20
> +/* make sure libbpf doesn't use kernel-only integer typedefs */
> +#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
> +
>  /*
>   * When building perf, unistd.h is overridden. __NR_bpf is
>   * required to be defined explicitly.
> diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linf=
o.c
> index 3ed1a27b5f7c..bafca49cb1e6 100644
> --- a/tools/lib/bpf/bpf_prog_linfo.c
> +++ b/tools/lib/bpf/bpf_prog_linfo.c
> @@ -8,6 +8,9 @@
>  #include "libbpf.h"
>  #include "libbpf_internal.h"
> =20
> +/* make sure libbpf doesn't use kernel-only integer typedefs */
> +#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
> +
>  struct bpf_prog_linfo {
>  	void *raw_linfo;
>  	void *raw_jited_linfo;
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 5f04f56e1eb6..cfeb6a44480b 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -17,6 +17,9 @@
>  #include "libbpf_internal.h"
>  #include "hashmap.h"
> =20
> +/* make sure libbpf doesn't use kernel-only integer typedefs */
> +#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
> +
>  #define BTF_MAX_NR_TYPES 0x7fffffff
>  #define BTF_MAX_STR_OFFSET 0x7fffffff
> =20
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index e95f7710f210..885acebd4396 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c
> @@ -18,6 +18,9 @@
>  #include "libbpf.h"
>  #include "libbpf_internal.h"
> =20
> +/* make sure libbpf doesn't use kernel-only integer typedefs */
> +#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
> +
>  static const char PREFIXES[] =3D "\t\t\t\t\t\t\t\t\t\t\t\t\t";
>  static const size_t PREFIX_CNT =3D sizeof(PREFIXES) - 1;
> =20
> diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
> index 6122272943e6..54c30c802070 100644
> --- a/tools/lib/bpf/hashmap.c
> +++ b/tools/lib/bpf/hashmap.c
> @@ -12,6 +12,9 @@
>  #include <linux/err.h>
>  #include "hashmap.h"
> =20
> +/* make sure libbpf doesn't use kernel-only integer typedefs */
> +#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
> +
>  /* start with 4 buckets */
>  #define HASHMAP_MIN_CAP_BITS 2
> =20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3afd780b0f06..0c229f00a67e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -55,6 +55,9 @@
>  #include "libbpf_internal.h"
>  #include "hashmap.h"
> =20
> +/* make sure libbpf doesn't use kernel-only integer typedefs */
> +#pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
> +
>  #ifndef EM_BPF
>  #define EM_BPF 247
>  #endif
> @@ -6475,7 +6478,7 @@ static int bpf_object__collect_struct_ops_map_reloc=
(struct bpf_object *obj,
>  	Elf_Data *symbols;
>  	unsigned int moff;
>  	const char *name;
> -	u32 member_idx;
> +	__u32 member_idx;
Acked-by: Martin KaFai Lau <kafai@fb.com>
