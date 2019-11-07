Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF75F3BF4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKGXHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:07:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38620 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfKGXHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:07:51 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7N54AZ021283;
        Thu, 7 Nov 2019 15:07:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0NCUfgTDFsbKL4A0K5f9RVnbM2Ss9mR2SRAiPRZSVok=;
 b=nLIdk7X2IvMGzkz8RZWb0ShxvxT7qeKEebgDsaUl3aO9TRrSnfzeCSf0OfuoCq88GbRP
 tq/yKWegcykub59y3TnPdZfH+QIfiSBM7rfMMuN/1v/4hkfPy8ndFUkh3jzM2Ur8kJb2
 sc+AxDwS0HkgkpB+HhUm4Ew0/tqs9PArjyE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u2r0fb-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 15:07:35 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 15:07:23 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 15:07:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgTPyJ/pc7gPVxptUCqS8hXi+pZmy+bNmyrX0pFXygmCEtQRDPSXxXn/MpVFa9blidWb3lSkTjXvK25rl+7NhCQmMmSAoCgSX894XMMl1+ikzRfB3CnnvRUvJcPPhNmVbbm1oU6Wx5fU9AJ3qvdUijh+GdmP//R20dafg6FpQWL0yBFmzEUbNiDvZre6nseJmnamDqz8dJH+d78/tMPj/g8XjO7sFAQaqPpN4RBxwmKSY23HXYRB8VILD8f0IY654f1U1EFuc4ZCszBlgtwpZcj48hE3koIYMrwISf220LJXPeMApBibN6kyOtbeCZZMpNVC+U6vtbPAfWaTda7Nug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NCUfgTDFsbKL4A0K5f9RVnbM2Ss9mR2SRAiPRZSVok=;
 b=imuynzF250ENveZp1TExXROiL8BLWMnaL1HLjusvSP/U3MpvXIwoHJNELsZGAg+BXRgQV0KNr9K7erN63o1gcVrFgY6o5A/aakUTu2TcslWBZl8thuuXIS/Gyrxir1fpyIzU16oVOhXjQGC8CUXTqtl3xQtz7unXh0bZf0Ami2u1aNKqpkdq/QvEGPqr4qpOhaUqnfsBYiLEu91uh6Vb2RWSNjl1f9mNHzAm+v2lX5r9I72g6qqc+Bd0sTaeNUfqrPonfw9FNySaNdxUlc0D1bSrFs5FZ/kOg6Wv/viBRgTaZ+z5aqxpc3eLnuyojzkI3HJPh4uOIFbuavOsFgx6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NCUfgTDFsbKL4A0K5f9RVnbM2Ss9mR2SRAiPRZSVok=;
 b=D9/PfoVQQcrViU9apeVq4bTPYIJrt7mcS4iJ2gyCzS3QN0EsXy0oMdQHGCH2+t1HdUzCiXQbXtXFGxj+B8sTPeToY9EEXtdcTsC6njhsapfbCvsZVh0gtTkAC1YQqLJ99EenVdFi99VxTQ1SwAq39s5gm9WZC8Z0LFCkDGNCgE4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1360.namprd15.prod.outlook.com (10.173.228.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 23:07:21 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 23:07:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Thread-Topic: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Thread-Index: AQHVlS7H2riFVn1w60W5YsSPSMrqRaeATXQAgAAFMwCAAAMxAA==
Date:   Thu, 7 Nov 2019 23:07:21 +0000
Message-ID: <FABEB3EB-2AC4-43F8-984B-EFD1DA621A3E@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-4-ast@kernel.org>
 <5967F93A-235B-447E-9B70-E7768998B718@fb.com>
 <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0aa876c-d81b-4fe5-373c-08d763d73e92
x-ms-traffictypediagnostic: MWHPR15MB1360:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB13605D175DC9F5742A41F78BB3780@MWHPR15MB1360.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(39860400002)(136003)(376002)(189003)(199004)(6916009)(64756008)(76116006)(66556008)(25786009)(4326008)(14454004)(8676002)(256004)(6436002)(46003)(7736002)(54906003)(99286004)(2616005)(305945005)(14444005)(66476007)(66946007)(6116002)(446003)(5660300002)(81156014)(66446008)(478600001)(102836004)(81166006)(11346002)(6512007)(486006)(476003)(316002)(2906002)(53546011)(229853002)(8936002)(76176011)(86362001)(6246003)(6506007)(186003)(33656002)(50226002)(6486002)(71190400001)(71200400001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1360;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +8KvJogsyX1OlzYScaVj3dv2P8O8Id0X+x5s4H/+AxKbkPytibuiipXg/usqGO5gKYx+mbo8yCumdUPy5ydQB+8D6aP0EsuXo8W4bJ24cZ36y1SkXzlsrR2UX0gXKqye/Q6TaBNGA084+1yyrVf6/JpIZ7ehJb2HyzdExd14I7LN0HYLlBy9GNWFpuiZd9XGyYFVvDiAmK2nTpOtS6+sEi7X9JAdBXPaBdzPgQibeBsxZpFXKwyFAQuN5M/U0Se9Z9Wj1PtizD01gw2TV7fy9EtmrWryOGakwjGUq5PdiI6RgjsnRjQuk3wq6VjpBzXOSi7IwaS/vRGRi5Aqa6Oa7Ltni8jc/HRoMxOk6CV/yOv0YZUBaOAi/3c0YxvQQ6s1WlAptcMcDd8EKOsyVcXNmXHnxaNakQWEFQbInOKo9JBTeNJzlV+nPHfAfGVCyWUj
Content-Type: text/plain; charset="us-ascii"
Content-ID: <516F8153127E4246A16801857BC1BC67@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e0aa876c-d81b-4fe5-373c-08d763d73e92
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 23:07:21.2693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SyqKP17B3br5GdawKxk8RuLGTSrqTc1CwWgkXR9hG8HinCXf8Phr7lJHQf9XiqvCjB4t4Jm8OxG7Ot8DBtFMjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1360
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070212
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 2:55 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Thu, Nov 07, 2019 at 10:37:19PM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>>>=20
>>=20
>> [...]
>>=20
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>> arch/x86/net/bpf_jit_comp.c | 227 ++++++++++++++++++++++++++++++--
>>> include/linux/bpf.h         |  98 ++++++++++++++
>>> include/uapi/linux/bpf.h    |   2 +
>>> kernel/bpf/Makefile         |   1 +
>>> kernel/bpf/btf.c            |  77 ++++++++++-
>>> kernel/bpf/core.c           |   1 +
>>> kernel/bpf/syscall.c        |  53 +++++++-
>>> kernel/bpf/trampoline.c     | 252 ++++++++++++++++++++++++++++++++++++
>>> kernel/bpf/verifier.c       |  39 ++++++
>>> 9 files changed, 732 insertions(+), 18 deletions(-)
>>> create mode 100644 kernel/bpf/trampoline.c
>>>=20
>>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>>> index 8631d3bd637f..44169e8bffc0 100644
>>> --- a/arch/x86/net/bpf_jit_comp.c
>>> +++ b/arch/x86/net/bpf_jit_comp.c
>>> @@ -98,6 +98,7 @@ static int bpf_size_to_x86_bytes(int bpf_size)
>>>=20
>>> /* Pick a register outside of BPF range for JIT internal work */
>>> #define AUX_REG (MAX_BPF_JIT_REG + 1)
>>> +#define X86_REG_R9 (MAX_BPF_JIT_REG + 2)
>>>=20
>>> /*
>>> * The following table maps BPF registers to x86-64 registers.
>>> @@ -123,6 +124,7 @@ static const int reg2hex[] =3D {
>>> 	[BPF_REG_FP] =3D 5, /* RBP readonly */
>>> 	[BPF_REG_AX] =3D 2, /* R10 temp register */
>>> 	[AUX_REG] =3D 3,    /* R11 temp register */
>>> +	[X86_REG_R9] =3D 1, /* R9 register, 6th function argument */
>>=20
>> We should update the comment above this:
>>=20
>> * Also x86-64 register R9 is unused. ...
>=20
> good point. fixed.
>=20
>>> +	/* One half of the page has active running trampoline.
>>> +	 * Another half is an area for next trampoline.
>>> +	 * Make sure the trampoline generation logic doesn't overflow.
>>> +	 */
>>> +	if (WARN_ON_ONCE(prog - (u8 *)image > PAGE_SIZE / 2 - BPF_INSN_SAFETY=
))
>>> +		return -EFAULT;
>>=20
>> Given max number of args, can we catch this error at compile time?=20
>=20
> I don't see how to do that. I was thinking about having fake __init funct=
ion
> that would call it with flags that can generate the longest trampoline, b=
ut
> it's not fool proof either.
> So I've added a test for it instead. See patch 10.
>=20
>>> +
>>> +static int bpf_trampoline_update(struct bpf_prog *prog)
>>=20
>> Seems argument "prog" is not used at all?=20
>=20
> like one below ? ;)
e... I was really dumb... sorry..

Maybe we should just pass the tr in?=20
>=20
>>> +{
>>> +	struct bpf_trampoline *tr =3D prog->aux->trampoline;
>>> +	void *old_image =3D tr->image + ((tr->selector + 1) & 1) * PAGE_SIZE/=
2;
>>> +	void *new_image =3D tr->image + (tr->selector & 1) * PAGE_SIZE/2;
>>> +	if (err)
>>> +		goto out;
>>> +	tr->selector++;
>>=20
>> Shall we do selector-- for unlink?
>=20
> It's a bit flip. I think it would be more confusing with --

Right.. Maybe should use int instead of u64 for selector?=20

