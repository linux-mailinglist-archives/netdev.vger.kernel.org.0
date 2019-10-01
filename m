Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59165C4286
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfJAVTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:19:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50744 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726681AbfJAVTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:19:35 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x91L81F9012167;
        Tue, 1 Oct 2019 14:19:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xo59RSMNsK+k99VaOAfL5qXDPPneN+HhEeF+rlDAGHE=;
 b=aOSQWniIz4gZl5qKiGzpZn6cvu1WP5AZ5N2ypy/lg8MOBue7Y5PFm34YtRDVv/90pkCA
 wfrPrHqjy0o++//tQl08pTB2kkCBY8pX27sjLXwSEzEZPWdtBtG/olQ8HQkx2VuDB46W
 NNTtk87IvIz7RThZpyialJjl4XCrM/PmvqA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vcddngc7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Oct 2019 14:19:21 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 1 Oct 2019 14:19:20 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Oct 2019 14:19:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Czp6BT9GTF9eUcEU1EA3X9+tTm3jMvc1S+mN6755LvjapWuJF/HmpviOUkBOKZPial+mjaIsmHhkn3CwdvC+OqXGOIPFVgkgL8cKQuje7rCeAJmc1y4getCZtQHQYiAwf1Rj3Z4VdDYXwkXYFCLwrzjjScm7T9YMDQ/MLMoxn8ey4r/EU4y1Jy0/fOHcP6IpZnV0catvSAAz5b302K6GD+tRlwgBkOmhd4v1GmVnnq94n9ZpO9zVUQoqWnm0LN4ik6/R4IIgOV94CNBjjQ/dJQ1h/PcMO69QGSnm7T/Ey/HP8RhJ5/XZ0xb9jXbU9qN1JgVq2vYR5zw7q69TRFSiGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xo59RSMNsK+k99VaOAfL5qXDPPneN+HhEeF+rlDAGHE=;
 b=PvyHWbflcdhrXhIc9DhKWzPoUGYaWKBnQytKaOgL39tCHAbKww55XJLQisR2ZMTtoolyfCU+xIt8n+mZwePLZdYlHuQxFuc3kx+IzZoYyeEKGBxXuoAcMrJvPUl8UJvV2cq6V27X/hPyUdouC5+30blv701GG2TnYuAqTp5/Ismb3xiYaVGze5ZwFV1BnXVZ0Vf859EU1s9aW4Jlt7YSpDqD9QXXCFmWxELcvH9c3jiQ4Ra+vMbeBtKb3XyFo19gMGOzcenrRbe3k07WvGDi0MRGFjUYWjr80TvaXpQTTajRbPMOeSrqs6F+pHHoNxBW2n6Kq/u6P6i+HoBGXjmAmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xo59RSMNsK+k99VaOAfL5qXDPPneN+HhEeF+rlDAGHE=;
 b=U55is5BqaBACOBH83s7wjGU15VzJdT4oZmY/MYvrHQIKBQ4/C1w4WmxEQspo2sYyIGRsbsx/EtLwxoHoO9uG0rPuvcgC4OmlrvV+T/iPXh2O/hY/h2vd1zy9LI6DvvbVD922ctAXuFDe+9I8Mm17hyJjtsJqGUC6kO6brFQyJp8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1200.namprd15.prod.outlook.com (10.175.3.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Tue, 1 Oct 2019 21:19:19 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Tue, 1 Oct 2019
 21:19:19 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Topic: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Index: AQHVd8Ew888g3vk8vkOHuZyXroWL6adGTEIA
Date:   Tue, 1 Oct 2019 21:19:19 +0000
Message-ID: <E0A2B793-7660-481B-9ADB-6B544518865A@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-3-andriin@fb.com>
In-Reply-To: <20190930185855.4115372-3-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:7bc9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7fd8fb1-b144-4607-8ed9-08d746b50596
x-ms-traffictypediagnostic: MWHPR15MB1200:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB120035D040045FDFA9C2317CB39D0@MWHPR15MB1200.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(346002)(366004)(39860400002)(199004)(189003)(6636002)(37006003)(8936002)(2906002)(25786009)(4326008)(6116002)(86362001)(50226002)(36756003)(7736002)(5660300002)(186003)(305945005)(81166006)(8676002)(81156014)(46003)(33656002)(316002)(11346002)(66476007)(6486002)(229853002)(446003)(91956017)(76116006)(66446008)(6246003)(6862004)(478600001)(66946007)(2616005)(66556008)(64756008)(476003)(6506007)(14444005)(53546011)(102836004)(99286004)(6512007)(71200400001)(71190400001)(6436002)(14454004)(76176011)(54906003)(256004)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1200;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2VfPX/40I0L7fmsGeq+zvsHmZBPOEX62+BTDQOXWlgLinN5pePAycDwUCU0u3JNu27sZFMANM8tzKBbYUWVmLGZooG88jkJYQ7sqHpYCJ6bPBElHIzTQ9ZK7sPmoVhOD/LzRLPZAgtBLlseM/0LlxiaOCSUfBQ1ctl/16Ia02boZq1g6NqU7S+4Uj1ezN4R97BhSZzqXjt0c8h16mH1X702CGjP9Fk6gQEjVTRb/p2O6bo8yzBDFaERn/tev/rd3rnL2fFPwjFbzOCteL99smG846mCJSEi0GJPw9ECE1XSFydUbvOWMSqmjbXIM13loEDwAxM0RqsZb744T725NbwNTI/0sgNsvo8lgf67+ARA+mnQ6frvZf9YqHhx1Yjjv+UWDgZqpyCNe2XIREYMZUQu04dgsMJcULqeN4mMlSrk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F37313AA7BA4C74E941C0EEC0358F5D9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a7fd8fb1-b144-4607-8ed9-08d746b50596
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 21:19:19.1942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CJRwNSnmAKnjXCJUu30QaVsW7jv1THrbnW+5ONekHxV4YGwWzHcR13zj/UjaHCTagYF6bgTmx8wVrFzQ/s0HnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_09:2019-10-01,2019-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910010176
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> are installed along the other libbpf headers.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/lib/bpf/Makefile      |   4 +-
> tools/lib/bpf/bpf_endian.h  |  72 +++++
> tools/lib/bpf/bpf_helpers.h | 527 ++++++++++++++++++++++++++++++++++++
> 3 files changed, 602 insertions(+), 1 deletion(-)
> create mode 100644 tools/lib/bpf/bpf_endian.h
> create mode 100644 tools/lib/bpf/bpf_helpers.h
>=20
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index c6f94cffe06e..2ff345981803 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -240,7 +240,9 @@ install_headers:
> 		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
> 		$(call do_install,btf.h,$(prefix)/include/bpf,644); \
> 		$(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
> -		$(call do_install,xsk.h,$(prefix)/include/bpf,644);
> +		$(call do_install,xsk.h,$(prefix)/include/bpf,644); \
> +		$(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
> +		$(call do_install,bpf_endian.h,$(prefix)/include/bpf,644);
>=20
> install_pkgconfig: $(PC_FILE)
> 	$(call QUIET_INSTALL, $(PC_FILE)) \
> diff --git a/tools/lib/bpf/bpf_endian.h b/tools/lib/bpf/bpf_endian.h
> new file mode 100644
> index 000000000000..fbe28008450f
> --- /dev/null
> +++ b/tools/lib/bpf/bpf_endian.h
> @@ -0,0 +1,72 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +#ifndef __BPF_ENDIAN__
> +#define __BPF_ENDIAN__
> +
> +#include <linux/stddef.h>
> +#include <linux/swab.h>
> +
> +/* LLVM's BPF target selects the endianness of the CPU
> + * it compiles on, or the user specifies (bpfel/bpfeb),
> + * respectively. The used __BYTE_ORDER__ is defined by
> + * the compiler, we cannot rely on __BYTE_ORDER from
> + * libc headers, since it doesn't reflect the actual
> + * requested byte order.
> + *
> + * Note, LLVM's BPF target has different __builtin_bswapX()
> + * semantics. It does map to BPF_ALU | BPF_END | BPF_TO_BE
> + * in bpfel and bpfeb case, which means below, that we map
> + * to cpu_to_be16(). We could use it unconditionally in BPF
> + * case, but better not rely on it, so that this header here
> + * can be used from application and BPF program side, which
> + * use different targets.
> + */
> +#if __BYTE_ORDER__ =3D=3D __ORDER_LITTLE_ENDIAN__
> +# define __bpf_ntohs(x)			__builtin_bswap16(x)
> +# define __bpf_htons(x)			__builtin_bswap16(x)
> +# define __bpf_constant_ntohs(x)	___constant_swab16(x)
> +# define __bpf_constant_htons(x)	___constant_swab16(x)
> +# define __bpf_ntohl(x)			__builtin_bswap32(x)
> +# define __bpf_htonl(x)			__builtin_bswap32(x)
> +# define __bpf_constant_ntohl(x)	___constant_swab32(x)
> +# define __bpf_constant_htonl(x)	___constant_swab32(x)
> +# define __bpf_be64_to_cpu(x)		__builtin_bswap64(x)
> +# define __bpf_cpu_to_be64(x)		__builtin_bswap64(x)
> +# define __bpf_constant_be64_to_cpu(x)	___constant_swab64(x)
> +# define __bpf_constant_cpu_to_be64(x)	___constant_swab64(x)
> +#elif __BYTE_ORDER__ =3D=3D __ORDER_BIG_ENDIAN__
> +# define __bpf_ntohs(x)			(x)
> +# define __bpf_htons(x)			(x)
> +# define __bpf_constant_ntohs(x)	(x)
> +# define __bpf_constant_htons(x)	(x)
> +# define __bpf_ntohl(x)			(x)
> +# define __bpf_htonl(x)			(x)
> +# define __bpf_constant_ntohl(x)	(x)
> +# define __bpf_constant_htonl(x)	(x)
> +# define __bpf_be64_to_cpu(x)		(x)
> +# define __bpf_cpu_to_be64(x)		(x)
> +# define __bpf_constant_be64_to_cpu(x)  (x)
> +# define __bpf_constant_cpu_to_be64(x)  (x)
> +#else
> +# error "Fix your compiler's __BYTE_ORDER__?!"
> +#endif
> +
> +#define bpf_htons(x)				\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_htons(x) : __bpf_htons(x))
> +#define bpf_ntohs(x)				\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_ntohs(x) : __bpf_ntohs(x))
> +#define bpf_htonl(x)				\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_htonl(x) : __bpf_htonl(x))
> +#define bpf_ntohl(x)				\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_ntohl(x) : __bpf_ntohl(x))
> +#define bpf_cpu_to_be64(x)			\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_cpu_to_be64(x) : __bpf_cpu_to_be64(x))
> +#define bpf_be64_to_cpu(x)			\
> +	(__builtin_constant_p(x) ?		\
> +	 __bpf_constant_be64_to_cpu(x) : __bpf_be64_to_cpu(x))
> +
> +#endif /* __BPF_ENDIAN__ */
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> new file mode 100644
> index 000000000000..a1d9b97b8e15
> --- /dev/null
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -0,0 +1,527 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +#ifndef __BPF_HELPERS__
> +#define __BPF_HELPERS__
> +
> +#define __uint(name, val) int (*name)[val]
> +#define __type(name, val) val *name

Similar to the concern with 4/6, maybe we should rename/prefix/postfix
these two macros?

Thanks,
Song

