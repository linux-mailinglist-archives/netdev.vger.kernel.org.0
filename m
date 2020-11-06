Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1032AA09C
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 00:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgKFXA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 18:00:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60580 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728624AbgKFXAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 18:00:25 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6MQNeZ017203;
        Fri, 6 Nov 2020 15:00:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VxjCo13uGt+1hj1Tqq1bG8LosDfXObGqbpfckypFhLg=;
 b=rnUSBKK6QGlJSlalhqradlkXqy9el7ma5cGtoVfWZZtiVgh7oXTyrjonNkZQzKoH24Ps
 kmZznfznqTxtj2vqx68k/dlNnsuvO4BtX1ASMMYZhqJfkjb7YHwbdzZfk8QSNtyTM0lT
 GfE4gzA7KPInMtQy01RXBMYHYdmlIU74zpo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34mx9pd3s8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 15:00:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 14:59:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8/30l1gkAcgawVZZYY7HlnjOll4rLp8tpGoN/IGRdconjS+vnb/3yd/0ppUHA8qfCEwR+mp7kbMjNe7/8M9aItN46d4Ffnq9SXGSC0qckmJXfpsvMBWd1mraSx6kw29gQKPasXr4tRIZlhIiPgcs2pvPY4m0ZzJ/pXy3RJ8vVU/p+SpmtZZh09w/FKCOPW3ewlZa+VifdjmalSobfQ34Db3/f27wr91T1B7dowJVZXKIhTVn94shniS17xHrIW6NJXQ2UeiafUbNM/67oF5mSMRSLyZhikdUnqU0Ho2g5LUhwQS/atIRvarPQAdFAaUIXaovIj6U/WObtxMkojm1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxjCo13uGt+1hj1Tqq1bG8LosDfXObGqbpfckypFhLg=;
 b=H6A7lQAnqAPSqzn/IFzg6v7HyTxU8D41E5Ziy6WiUZMiDhUE53DxE5Y6Ce3NnwcIDWgpFR9CAy0Ygk9P2N52/DGNYYgznUHsYaoMHBxJTYxC4pjXM6kFlkvqFXoP5DT+muGSXyOs/jhLtBI8wUaD6hWFtlu85QyvSExu9+TlvBk4njou0etRpYmQv8gozNw1+leRgjzlWmm8FNkGsva8EAZhby0FRPgzlWw3n3+sepj64MhAsIdwSYaTJhzBlrFcwp8xdMOF9ylf2+F9j/Fd0r04lcYG9kZXy+pdIuhfWZ62uU50Pc0/b3QNYq9n5+u5tqa0O7qoOqVcWUj8W0cDwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxjCo13uGt+1hj1Tqq1bG8LosDfXObGqbpfckypFhLg=;
 b=SNBBFzoqXAkNp50IkleMXQfklOxPizWXLuue5eYzZ8s2L0/NFfSTIo/HH/8nfqsDfQnwI9yJYZt36IUetE2qYe+lSXw8E2PfqglM8mFh+SIISYfbNXnZbTUSJc1uqath5ymo/afjSlfMgad1Y4dl46T7oCmnbPN3ydsaN2a+rB8=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3366.namprd15.prod.outlook.com (2603:10b6:a03:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 6 Nov
 2020 22:59:14 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Fri, 6 Nov 2020
 22:59:14 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Thread-Topic: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Thread-Index: AQHWtIlRNBRBFFP0rUOaRcDTIizKBKm7t9EA
Date:   Fri, 6 Nov 2020 22:59:14 +0000
Message-ID: <8FA16B3B-DC01-4FAB-B5F6-1871C5151D67@fb.com>
References: <20201106220750.3949423-1-kafai@fb.com>
 <20201106220803.3950648-1-kafai@fb.com>
In-Reply-To: <20201106220803.3950648-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:ca49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb2b5219-0d46-4799-2c4f-08d882a79538
x-ms-traffictypediagnostic: BYAPR15MB3366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3366964AF1A8E5D3FECB98DFB3ED0@BYAPR15MB3366.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zn7LdmAavthASJLhqe6o7p4rW+1Qn98CE6rbjx42gUJnB/YK/VfifjwkivaA5jSWgNLBSSCpptvYlbxnbL3K24YnDqCLwVUscreMQxKH+IzihO52g3dCPgDrwipEtXGoQK9JWcu/wbQmEYYVxpBMUDjZqjda6bs76d/eg2ZQayfours5hS94TsN3pTwuu1YygSUL6BbmgGfileZQKSEVU1U9wNLuRgFt6tWdfFd5DwfDxQMoUEC+rxJTrcwdYYmdXIf0FsRc2tbxnAaz9k09x6XqBqYnTyHhdf+fDWpGPn3PhQpZGivYuTpy/3flYhM6OArVnHe2iGQ1qLfGT9038A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(136003)(39860400002)(5660300002)(6862004)(33656002)(54906003)(6506007)(71200400001)(66946007)(37006003)(6512007)(4326008)(53546011)(8676002)(6486002)(478600001)(186003)(36756003)(83380400001)(76116006)(6636002)(64756008)(2906002)(66556008)(2616005)(66446008)(66476007)(316002)(91956017)(86362001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Vhb+lqtV2swWaxDb1K5z/dwbeoLVvmbT0tP3WJCA/AUX4H/snqjIr/DkxrQ4qwMwiMBfIRiQ38hQjzkSLxJvyzD0yrI5rd15wZJ3Oo20UaMQArsPdziYuAayyvJq83rjn9kDnYhGFdE1f5uo331W1/FHqOkEWqXQrwAMlBKhIDWwm+M8+rKKT4VGumNXLVzFMJbxTzV+XrjtVhFdYrmeH66PuD4f66fTeG7ESQQI6tEsO2sDhqUza+TQZyk00EVQwTgd83vpe98b/xGFhYpLFMeyl+4kL3fjr9yNghVvqijovHFcr4cTHhktEzaRyQmGm79Vmo+yVx4PkRCqyfjBZF9oWuxTmMuh+4yqkhJs6NdIO+5HhpIMEYMnF5jMVSZrT60jr5piVNV4wZJTNIioQBMS0wekAz7p1mP5q+jlmZoBCCEbPA/2fighIWOFelZmOLJ1ZasA9CoHxhu114ZHJOhGxQM7QbB/tWNI3WXkH/Cj+8K4J7W4GH87LnFPmtjZtf9o6iaPsa8Pb3Ps74toN7BB1z/VaQDlMTQvJRU65+asFf5itnMHYAMqfbPqpueqBYUE7jCPYEKVKuN5Ocu/YEplNlaUOIYLNWavQFrOUxXOYOakMBSCRHigy+O6gELwf059hxSuGeEnpFWKX7GIyntWjJwHWkhnpqepfdGKwSXwtduTSOeQ+DSWLTz1cRRY
Content-Type: text/plain; charset="us-ascii"
Content-ID: <494159FF784B3C4396368D995D218501@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb2b5219-0d46-4799-2c4f-08d882a79538
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2020 22:59:14.5842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nBJZFWr+LT3dnQnBM9NpelcoRyrGNZtSYfWZrxMq9QVoc4Qb5t26caw/a9SPtafR0eDk38OeyjguaSA7wQmMsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011060153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2020, at 2:08 PM, Martin KaFai Lau <kafai@fb.com> wrote:
>=20
> This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> the bpf_sk_storage_(get|delete) helper, so those tracing programs
> can access the sk's bpf_local_storage and the later selftest
> will show some examples.
>=20
> The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> cg sockops...etc which is running either in softirq or
> task context.
>=20
> This patch adds bpf_sk_storage_get_tracing_proto and
> bpf_sk_storage_delete_tracing_proto.  They will check
> in runtime that the helpers can only be called when serving
> softirq or running in a task context.  That should enable
> most common tracing use cases on sk.
>=20
> During the load time, the new tracing_allowed() function
> will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> helper is not tracing any *sk_storage*() function itself.
> The sk is passed as "void *" when calling into bpf_local_storage.
>=20
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
> include/net/bpf_sk_storage.h |  2 +
> kernel/trace/bpf_trace.c     |  5 +++
> net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> 3 files changed, 80 insertions(+)
>=20
> diff --git a/include/net/bpf_sk_storage.h b/include/net/bpf_sk_storage.h
> index 3c516dd07caf..0e85713f56df 100644
> --- a/include/net/bpf_sk_storage.h
> +++ b/include/net/bpf_sk_storage.h
> @@ -20,6 +20,8 @@ void bpf_sk_storage_free(struct sock *sk);
>=20
> extern const struct bpf_func_proto bpf_sk_storage_get_proto;
> extern const struct bpf_func_proto bpf_sk_storage_delete_proto;
> +extern const struct bpf_func_proto bpf_sk_storage_get_tracing_proto;
> +extern const struct bpf_func_proto bpf_sk_storage_delete_tracing_proto;
>=20
> struct bpf_local_storage_elem;
> struct bpf_sk_storage_diag;
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index e4515b0f62a8..cfce60ad1cb5 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -16,6 +16,7 @@
> #include <linux/syscalls.h>
> #include <linux/error-injection.h>
> #include <linux/btf_ids.h>
> +#include <net/bpf_sk_storage.h>
>=20
> #include <uapi/linux/bpf.h>
> #include <uapi/linux/btf.h>
> @@ -1735,6 +1736,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, =
const struct bpf_prog *prog)
> 		return &bpf_skc_to_tcp_request_sock_proto;
> 	case BPF_FUNC_skc_to_udp6_sock:
> 		return &bpf_skc_to_udp6_sock_proto;
> +	case BPF_FUNC_sk_storage_get:
> +		return &bpf_sk_storage_get_tracing_proto;
> +	case BPF_FUNC_sk_storage_delete:
> +		return &bpf_sk_storage_delete_tracing_proto;
> #endif
> 	case BPF_FUNC_seq_printf:
> 		return prog->expected_attach_type =3D=3D BPF_TRACE_ITER ?
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index 001eac65e40f..1a41c917e08d 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -6,6 +6,7 @@
> #include <linux/types.h>
> #include <linux/spinlock.h>
> #include <linux/bpf.h>
> +#include <linux/btf.h>
> #include <linux/btf_ids.h>
> #include <linux/bpf_local_storage.h>
> #include <net/bpf_sk_storage.h>
> @@ -378,6 +379,78 @@ const struct bpf_func_proto bpf_sk_storage_delete_pr=
oto =3D {
> 	.arg2_type	=3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
> };
>=20
> +static bool bpf_sk_storage_tracing_allowed(const struct bpf_prog *prog)
> +{
> +	const struct btf *btf_vmlinux;
> +	const struct btf_type *t;
> +	const char *tname;
> +	u32 btf_id;
> +
> +	if (prog->aux->dst_prog)
> +		return false;
> +
> +	/* Ensure the tracing program is not tracing
> +	 * any *sk_storage*() function and also
> +	 * use the bpf_sk_storage_(get|delete) helper.
> +	 */
> +	switch (prog->expected_attach_type) {
> +	case BPF_TRACE_RAW_TP:
> +		/* bpf_sk_storage has no trace point */
> +		return true;
> +	case BPF_TRACE_FENTRY:
> +	case BPF_TRACE_FEXIT:
> +		btf_vmlinux =3D bpf_get_btf_vmlinux();
> +		btf_id =3D prog->aux->attach_btf_id;
> +		t =3D btf_type_by_id(btf_vmlinux, btf_id);

What happens to fentry/fexit attach to other BPF programs? I guess
we should check for t =3D=3D NULL?

Thanks,
Song

> +		tname =3D btf_name_by_offset(btf_vmlinux, t->name_off);
> +		return !strstr(tname, "sk_storage");
> +	default:
> +		return false;
> +	}
> +
> +	return false;
> +}

[...]


