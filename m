Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 989D3F40CB
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKHG4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 01:56:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbfKHG4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:56:25 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA86sR8v005861;
        Thu, 7 Nov 2019 22:56:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DIIv6R8TBPz7ajbhc2bCK3VyB9cIeLzK4UBrU5uOlPw=;
 b=PUtqPAijDRKs5aER3ZrAn8KM/sR8+WfIDKCX8Vu8fmkjze1v2wwn5uW5PQoaqxz/XZPy
 cFlWy7E3zPcBqqDvwNkFRW6lPu71EI5oTkR4bRiyBYYkfOBhY/vEi+jsOuyGSxGkOtYA
 g9ZXKIdTI2Ra0d/HMLalV248S+xkLJmn7Mc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w4ujfa2se-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 22:56:10 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 22:56:09 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 22:56:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJURgngGi4I33Xm7U+c87WUtWgo/8o17gP+OMLjilpyk9PE0hPmtlCkF+yF2tJ1DcwuSWY+4F9Ek445X4z2LcLopjTHhYyyz9DWPsUDLu7bDcruxY+1aW9k45bHv712vekr7ez8pKUidF+OJ15BThB+3PkJyHlzfE/CNIo1WEO/JNcede41kRH5cQbjzqXQxoxesFQmUK9apr15OFcEi0virie6YzkXbP3kFV13+2perZUC1vese7th/YWLuJH4qKLpmiZ0GIPMY+3HlIu4UtUSO6S/dMoHSTy60JwaKI0PhlQzmmuF4+pM4Ah5yzLje9iPrgM1JFEygQATOum702Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIIv6R8TBPz7ajbhc2bCK3VyB9cIeLzK4UBrU5uOlPw=;
 b=dH+8uEhUJxy7BuzFe3HRzEvPIvWaLPkBqEPuflVn/XLf++kFp3gaeAs1GxShSvBTwV4m4TD3/D6KFkg4+2nAifPsizvHCkkaHEopiIYgJfc4QgtSbnzpayas2ItSYBEXVM8jtv+RiloVb9uBb3P1aDhTzzf+NSIXhZ7yVK3M07oAO/sO3OJFYBCyemvxk9xfSTjbk1FPxLwUZIKtFmF6qxrWk+mSsn4zD/IPZqt3ZTqNdbLflYM2Vm9cn6dQ/kV2M7QFowKbmUy3czNijY7TGrFsnk1GGxrrk9D2v3P3xOmIRWsePnyKi14urd0W5HOa4LWutZA0MLnnn0HCyFfT+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIIv6R8TBPz7ajbhc2bCK3VyB9cIeLzK4UBrU5uOlPw=;
 b=Bk33YAeI/mK3XdDge67JfN/NrJjiT5qKLWrsTmksX+9FbtgLkalDGPlk+yMmMspKgzApRjiZXuGwhS0WpSKZ6N7oEZl9vRH19utQB3QxStCKvr3jFUyxyIUevLhFNUrv5tl19gQjnyw1ctFY1/QZomJSlC3wnNVj5FvtiWnOfP8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1503.namprd15.prod.outlook.com (10.173.234.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 06:56:07 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 06:56:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Thread-Topic: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Thread-Index: AQHVlf98N1QW0kBnUUGjttfnnSDRSKeA1zGA
Date:   Fri, 8 Nov 2019 06:56:07 +0000
Message-ID: <201D1F23-B4D5-4EB4-8450-128C6E2C1971@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-3-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-3-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9de68d86-9945-42a2-f84b-08d76418bb19
x-ms-traffictypediagnostic: MWHPR15MB1503:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB150305E253F64D737789841CB37B0@MWHPR15MB1503.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(39860400002)(396003)(376002)(199004)(189003)(66476007)(66556008)(7736002)(11346002)(478600001)(36756003)(6436002)(99286004)(229853002)(8936002)(6916009)(256004)(186003)(6116002)(4326008)(46003)(2906002)(14444005)(316002)(54906003)(81156014)(305945005)(76116006)(50226002)(81166006)(86362001)(76176011)(6486002)(33656002)(53546011)(66946007)(66446008)(14454004)(25786009)(446003)(5660300002)(102836004)(6246003)(71190400001)(6512007)(64756008)(486006)(2616005)(476003)(8676002)(71200400001)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1503;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0qzwwOHwNo6Pv6LkCTI2zrX4XOG7srvlqUZtTd8LkKWrBY8qZpa1xAGHrwjdtJm6XxURPTcNiJfPcjkloR5R6RPZ1Rqx76q5UmxYyNiwXGXl/u9sxJsFy9wUcguGrjn2miyHuhjUAkgCvuS7r+cPQCvo31I1NSrX7GRVidtfcHuGIdGbBpzrS9w3pPGsH1ckCcwaJ3qcqMUj5YbiN4w7nQ2/edsW82SGscRVh2vzIyYMKVd+tNDoBMcUPk+q/47euCO29+OOSb9SLQNSlH/2atOD2Eeg+x0rs3o1lK8/OY5pYVCHzp/DmBD9LO/Pvni1bV6A+HRQV48c8YNPVdjdL9i6T31Q8xlRtUb3bj+iEFYih3ilWJNqyF1+ga+d54OMODlD4CDPD9CmIE7DOvKAs+po9l1n90igWwvU5nmKP1zW78IENDh1HVDG3mBRshIC
Content-Type: text/plain; charset="us-ascii"
Content-ID: <62FF096D0C3E5844B258E4E169259FFA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de68d86-9945-42a2-f84b-08d76418bb19
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 06:56:07.4409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rxP5I0vcjnfClNX/29i04kkxqtJcDTRN5XdS3efLk8Qjhaq3ovYoG4ssx8fe77HPWSogcHbNSWrlIOUZk6KwLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1503
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to p=
atch
> nops/calls in kernel text into calls into BPF trampoline and to patch
> calls/nops inside BPF programs too.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
> arch/x86/net/bpf_jit_comp.c | 51 +++++++++++++++++++++++++++++++++++++
> include/linux/bpf.h         |  8 ++++++
> kernel/bpf/core.c           |  6 +++++
> 3 files changed, 65 insertions(+)
>=20
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 0399b1f83c23..bb8467fd6715 100644
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
> +	u8 old_insn[X86_CALL_SIZE] =3D {};
> +	u8 new_insn[X86_CALL_SIZE] =3D {};
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
> +	if (new_addr) {
> +		prog =3D new_insn;
> +		ret =3D emit_call(&prog, new_addr, (void *)ip);
> +		if (ret)
> +			return ret;
> +	}
> +	ret =3D -EBUSY;
> +	mutex_lock(&text_mutex);
> +	switch (t) {
> +	case BPF_MOD_NOP_TO_CALL:
> +		if (memcmp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE))
> +			goto out;
> +		text_poke(ip, new_insn, X86_CALL_SIZE);
> +		break;
> +	case BPF_MOD_CALL_TO_CALL:
> +		if (memcmp(ip, old_insn, X86_CALL_SIZE))
> +			goto out;
> +		text_poke(ip, new_insn, X86_CALL_SIZE);
> +		break;
> +	case BPF_MOD_CALL_TO_NOP:
> +		if (memcmp(ip, old_insn, X86_CALL_SIZE))
> +			goto out;
> +		text_poke(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE);
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
> index c1fde0303280..c4bcec1014a9 100644
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

