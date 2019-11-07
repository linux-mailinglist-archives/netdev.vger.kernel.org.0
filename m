Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D00BF359B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbfKGRUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:20:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61262 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727606AbfKGRUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:20:45 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7HAi31015632;
        Thu, 7 Nov 2019 09:20:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nv1t9pyjC1Vg/rux5w0Zdq6YsFoBVA8UYeJ3lF5d1zo=;
 b=W+hviCCXikfkpzv7HFS3mgDNCoN/8khlR16VQgkKaFHQN6r55wdg862sAch71HDBP3Fr
 /oRflq4qb/yPqvdkDzD4Xr+xQVg/vODUbaB5KqaeDv5bpSxIKpqZPP0RKVJhT2H9yNpN
 Pn6rwXl2W4s9dfI17B6rKHnmabKYPF8MH/k= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ue68wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 09:20:29 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 09:20:28 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 09:20:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7Wci+M743fwlBRtrKcafhkj5Syg/re1o0xgXsuUWxqPUghv0eBooie7myimuUzM+uRkpNsrjCW87f02g9o9MLt/B7N62GmHpxjylQHRf+WUFArgz/cHj445WIuH43qQAhdzdxqkteCuKoXhZtA+DqAXoZDD6fOncd7utkRqv/BSktScK0hDe2fq0Gi4Wm4AzaSt91etq2swGbcNSFrcPY6CJ9G4hzJr2QZRbnAHUik6K15sjcHX3LQlLx0nZCZCETssa5aOr+04siovemlT19fmuGRg004Axr7wbuY59I9yhajqjY1j3DVkQm3nL+ELt1zVXt6eSW9jYZOBqzB7QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nv1t9pyjC1Vg/rux5w0Zdq6YsFoBVA8UYeJ3lF5d1zo=;
 b=c+ryh0d99HyopTdXVc8tuV172PlFLfIvL85xgvPOOEdhjWUPp68VAV4MyYDAr3DAUyfrIfRdKCPSoHOFxaM2b2Aaeb4MPVUnC7X4cmEhj90gnWnatyf77m3tAHhajtkMwF4aMIeD4+u508Ck4blohdve+qykJLf+qCwctDIPRi+MxmYRklv3MbiyQLMvaNqNuJsECNBG8bMwi7efmnZxD7TyGcrsuwpVR4phoI9WKDVmcYliL52l/Fmq0lo7n62WsBilofjWwd7Xo1XYQuSLnfj6/qeLMcWpponlrNcIvr1gix1/vuHB8ZIxJA7bxKJBgSiI1xKJVoz7xIaX0y2e8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nv1t9pyjC1Vg/rux5w0Zdq6YsFoBVA8UYeJ3lF5d1zo=;
 b=FVIITobTaZXGo6xp0bn1Chqec2DuTC3vEE/A+pM86XJia/7zBsy/3roGbVBypSBdJEiIhAEe4TCPF7NEKxLmkOJ3hgaMO04iuL6Iqez1QFV54IxBrF52wOnrWqdNwS+ijApG6vN3OLb3T6IMSEvSNZBtIItSQJN1Z829iGf/udY=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1808.namprd15.prod.outlook.com (10.174.96.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 17:20:27 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 17:20:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 02/17] bpf: Add bpf_arch_text_poke() helper
Thread-Topic: [PATCH v2 bpf-next 02/17] bpf: Add bpf_arch_text_poke() helper
Thread-Index: AQHVlS7DiyLTZMsKz0OSS+G7WREPWKd/9O2A
Date:   Thu, 7 Nov 2019 17:20:27 +0000
Message-ID: <EE50EB7D-8FB0-4D37-A3F1-3439981A6141@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-3-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-3-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62ea4831-a5de-4108-f7f8-08d763a6c87e
x-ms-traffictypediagnostic: MWHPR15MB1808:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB180807A8633AC3D0A34597D4B3780@MWHPR15MB1808.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(39860400002)(346002)(396003)(136003)(189003)(199004)(8676002)(11346002)(486006)(446003)(5660300002)(46003)(476003)(6916009)(2616005)(50226002)(8936002)(81156014)(14444005)(2906002)(71200400001)(36756003)(25786009)(81166006)(71190400001)(54906003)(33656002)(229853002)(4326008)(316002)(76176011)(256004)(6436002)(86362001)(14454004)(102836004)(6506007)(6246003)(53546011)(6486002)(6116002)(478600001)(99286004)(66946007)(7736002)(76116006)(66556008)(186003)(64756008)(66476007)(305945005)(6512007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1808;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zciUVnjolWCz+lSlMSRyaLiWfPX+ad0AgfB6AQGMgjs/9l3GtQ/WEnkXqxw0CrczNHrauaJR9+bmqgAG8pr1F4/LfsUyFwj17ZTTcSBa0dkkF/vpYMj3OcgY48e/sxFGk7RE2fft5UWwYmEl5BJjjmEix+ultiFDeqDSvgKjQYcUi8HDhrlUDOHX21FvfCBJfNCzogw05vjFKlSWKB7/1YhuC9JVYLlRj8voH/4QKMq9jJJPODYpMrqzX92qDcaK7G7Z1dQCu9j0NM+DL3rMQklNc3GM39RSSUUXyFIY9sg/sLdNTfSprwkqBDBNC7YOL1/ebuSRWH5d3zQGbO64yPFy0LFmUEKgTfILyW7q9rtLEmjnVCuUq6iJF4SAP/oGN+JKWAWwmuD6TnaKSw3/L6Ko1l3iEbHgsspuF4ME9SKu203e8+mezo+/+sLqPbV2
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C255816B36FA1A4399AEC7F50F1D468A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ea4831-a5de-4108-f7f8-08d763a6c87e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 17:20:27.4530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eln14gJzr3bdhGHoXqNm184d17nYHnxDy4CLXT++GE8r0MzrGzAZlsVMpEBUXF5HMiZMKgQnzF6zQHW2YvOhUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1808
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to p=
atch
> nops/calls in kernel text into calls into BPF trampoline and to patch
> calls/nops inside BPF programs too.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> arch/x86/net/bpf_jit_comp.c | 51 +++++++++++++++++++++++++++++++++++++
> include/linux/bpf.h         |  8 ++++++
> kernel/bpf/core.c           |  6 +++++
> 3 files changed, 65 insertions(+)
>=20
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 0399b1f83c23..8631d3bd637f 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -9,9 +9,11 @@
> #include <linux/filter.h>
> #include <linux/if_vlan.h>
> #include <linux/bpf.h>
> +#include <linux/memory.h>
> #include <asm/extable.h>
> #include <asm/set_memory.h>
> #include <asm/nospec-branch.h>
> +#include <asm/text-patching.h>
>=20
> static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
> {
> @@ -487,6 +489,55 @@ static int emit_call(u8 **pprog, void *func, void *i=
p)
> 	return 0;
> }
>=20
> +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> +		       void *old_addr, void *new_addr)
> +{
> +	u8 old_insn[NOP_ATOMIC5] =3D {};
> +	u8 new_insn[NOP_ATOMIC5] =3D {};
> +	u8 *prog;
> +	int ret;
> +
> +	if (!is_kernel_text((long)ip))
> +		/* BPF trampoline in modules is not supported */
> +		return -EINVAL;
> +
> +	if (old_addr) {
> +		prog =3D old_insn;
> +		ret =3D emit_call(&prog, old_addr, (void *)ip);
> +		if (ret)
> +			return ret;
> +	}
> +	if (old_addr) {
		^ should be new_addr?
> +		prog =3D new_insn;
> +		ret =3D emit_call(&prog, old_addr, (void *)ip);
					^^^ and here?=20
> +		if (ret)
> +			return ret;
> +	}
> +	ret =3D -EBUSY;
> +	mutex_lock(&text_mutex);
> +	switch (t) {
> +	case BPF_MOD_NOP_TO_CALL:
> +		if (memcmp(ip, ideal_nops, 5))

Maybe use X86_CALL_SIZE instead of 5? And the five more "5" below?

> +			goto out;
> +		text_poke(ip, new_insn, 5);
> +		break;
> +	case BPF_MOD_CALL_TO_CALL:
> +		if (memcmp(ip, old_insn, 5))
> +			goto out;
> +		text_poke(ip, new_insn, 5);
> +		break;
> +	case BPF_MOD_CALL_TO_NOP:
> +		if (memcmp(ip, old_insn, 5))
> +			goto out;
> +		text_poke(ip, ideal_nops, 5);
> +		break;
> +	}
> +	ret =3D 0;
> +out:
> +	mutex_unlock(&text_mutex);
> +	return ret;
> +}
> +
> static bool ex_handler_bpf(const struct exception_table_entry *x,
> 			   struct pt_regs *regs, int trapnr,
> 			   unsigned long error_code, unsigned long fault_addr)
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 7c7f518811a6..8b90db25348a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1157,4 +1157,12 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(=
enum bpf_access_type type,
> }
> #endif /* CONFIG_INET */
>=20
> +enum bpf_text_poke_type {
> +	BPF_MOD_NOP_TO_CALL,
> +	BPF_MOD_CALL_TO_CALL,
> +	BPF_MOD_CALL_TO_NOP,
> +};
> +int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> +		       void *addr1, void *addr2);
> +
> #endif /* _LINUX_BPF_H */
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 97e37d82a1cc..856564e97943 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2140,6 +2140,12 @@ int __weak skb_copy_bits(const struct sk_buff *skb=
, int offset, void *to,
> 	return -EFAULT;
> }
>=20
> +int __weak bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> +			      void *addr1, void *addr2)
> +{
> +	return -ENOTSUPP;
> +}
> +
> DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
> EXPORT_SYMBOL(bpf_stats_enabled_key);
>=20
> --=20
> 2.23.0
>=20

