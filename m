Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEF9F53C2
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfKHSti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:49:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726394AbfKHSti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:49:38 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA8IlDeL026290;
        Fri, 8 Nov 2019 10:49:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XlxgpKVwfC/bBnESO8xUDp214dj6udleEpjV/O9uUAk=;
 b=qBnUVy4Gc8/3w7bBs+AsOffjof3aV6L/vp9TSSxFTxrudKkRGzll07MEJDAWJGLPFAZR
 YGaHkcxWUDYdoW+Kw1/TsJXwO5HrBymUUSv2YDHN2u35UG1uOZTJTGtt8BxK8syOxZhI
 Oa46iWwgi9jss89Fr8M/xvP7YQVgMRCa0Xg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2w4tyjnk3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 10:49:23 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 10:49:23 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 10:49:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCnG9Ss1Wn2NLcduNjsm/09Dhtyyk0v9eLU/NYMRjRjWVGaINVjC8Lt9f8/60iBkWAfH7TYEboN6uyo2HYeq2PDwpQYWQ6FyPFXYUgrgPpOtJdwOo/iYLnBYM2Wpsw5qMAw4L0Yf71kD+48wAFjWbgCmuQ5jmiGzu/xUyw7QQHXtjoj3S28w2BAJHwPPEszRvzFLaK6xRHDadIuNU8vS47m6noXD0CN7SjRkxpGaLSNXDE1CCJ1N8ihnP/TWTMjc8hRCAjX7Cv25mNQMK2Bw4CA5WNsBJxWG4WKEn2v3pwUtI8tQX0n0+MGBItMBaUU2oQOXvYD8l5onLZdWPfSQ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlxgpKVwfC/bBnESO8xUDp214dj6udleEpjV/O9uUAk=;
 b=ns5w4EQp6nc4Pq4T5b65iKC0H07PJgeUzmW30ODmL00Oa8rQZ8HX0NExAQBDCzUGcTcpplYxk4BTDhnGIAK6JKdiL2WMPz+Xsk9w5r1282Y5z79XkEgayku2Uldzbz/PO0/fJhe2Axy5k6kSqkiPGYjy9wA2jk3K2RSjB6uIzKINMT4BVHUaXxT3or0BZtPv6dj4rjBRHtmBr6U8C+48KoyfD0NICi3symZoT9pfG64u0cDB3fEVqgUKAAyCbKUrn2cf1fkWCqn+eHnh6VJlYPJUZIBwW0ndHpw4dgQwYZ3bwj9AZQnuql1vcDOVnFqgNIGkYl4Wu/qDHJg0FjEcIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlxgpKVwfC/bBnESO8xUDp214dj6udleEpjV/O9uUAk=;
 b=kc4Ml266/URJQ3Uak4ICzny1D9qyAp3qHIPkOIMDLpCI+ygFkj9AoGGX6IDXwkAKChsvMrCzRw5RlCCN18wxgvu+p03+pHIZpGxJMt6TQ1rYde5x98/pp/+xiaeRiJwU0ntpv93e5J57r7UkS0Cu6JC1huNNRG6UDrYl8+1ZqoY=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1502.namprd15.prod.outlook.com (10.173.235.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 18:49:21 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:49:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
Thread-Topic: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
Thread-Index: AQHVlf+n/eymXCvK30qK5HT+xWqFAaeBnneA
Date:   Fri, 8 Nov 2019 18:49:21 +0000
Message-ID: <34A3894D-C928-4332-BD82-9B7C1459A8D1@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-16-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-16-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25acdbef-0255-4bfc-23f2-08d7647c5e51
x-ms-traffictypediagnostic: MWHPR15MB1502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB150271BEE58D4C30D99A83DCB37B0@MWHPR15MB1502.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(396003)(366004)(136003)(376002)(199004)(189003)(71200400001)(8676002)(6436002)(486006)(476003)(8936002)(66946007)(6506007)(6512007)(14444005)(54906003)(6486002)(2616005)(11346002)(71190400001)(256004)(5660300002)(446003)(46003)(6246003)(316002)(66476007)(66556008)(64756008)(66446008)(6116002)(478600001)(86362001)(4326008)(99286004)(5024004)(186003)(25786009)(2906002)(76116006)(6916009)(33656002)(36756003)(14454004)(102836004)(53546011)(229853002)(76176011)(305945005)(81156014)(81166006)(50226002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1502;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TZ/WGgcuCXJ4XIWMhoufNUA3UrNaiJJaM/NTL9+upQroMTC96+aYfLCm3rrwTyA5kPWDxbPh320bht5gpnnBXOmhfggaVrQklrAhpP9+/EvmII3EDcxXSgmZAIrYs9nh4ENuh/Oalmw1L0bjKsaLWdmj2S6A2EvbZX28LAIYAIz+aDl0w5K8V6VySVeNNcclHyr6rdB81m7u6gV3ny8gJhjFJ692Y4zorXhzJ4mriVXovE6ECkb8IdGvc8xz1P+UbkScRqQUTCILORcxwq1FrcJWO7182MekWxayLRc0MDdn+iRnHCMk9yJdbLPu6VzurkTwkcF7DJnJZJz74/wMdfsJ6C39ecpWLUmsGtBxYKHrHVEiWai8WvMI7sJq6y/vD2SSz9V0hnyLVzmYbO13qZWExSbNWIklkKiOVA7Qn3bZDjf3L2WvgqInxaujyHXe
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F34DBF236471643A9D70A860CB0828A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 25acdbef-0255-4bfc-23f2-08d7647c5e51
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:49:21.5473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pyJfHr1wCaap6NiJOrzx+dPE5J3BcSUC8cn/UJdClE8q7sFnz/bffnoBpole9eYJXmIAWFaxsMTobPS3holfuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1502
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=655 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080184
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Allow FENTRY/FEXIT BPF programs to attach to other BPF programs of any ty=
pe
> including their subprograms. This feature allows snooping on input and ou=
tput
> packets in XDP, TC programs including their return values. In order to do=
 that
> the verifier needs to track types not only of vmlinux, but types of other=
 BPF
> programs as well. The verifier also needs to translate uapi/linux/bpf.h t=
ypes
> used by networking programs into kernel internal BTF types used by FENTRY=
/FEXIT
> BPF programs. In some cases LLVM optimizations can remove arguments from =
BPF
> subprograms without adjusting BTF info that LLVM backend knows. When BTF =
info
> disagrees with actual types that the verifiers sees the BPF trampoline ha=
s to
> fallback to conservative and treat all arguments as u64. The FENTRY/FEXIT
> program can still attach to such subprograms, but won't be able to recogn=
ize
> pointer types like 'struct sk_buff *' into won't be able to pass them to
					^^^^^ these few words are confusing
> bpf_skb_output() for dumping to user space.
>=20
> The BPF_PROG_LOAD command is extended with attach_prog_fd field. When it'=
s set
> to zero the attach_btf_id is one vmlinux BTF type ids. When attach_prog_f=
d
> points to previously loaded BPF program the attach_btf_id is BTF type id =
of
> main function or one of its subprograms.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>=20

[...]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index cd9a9395c4b5..f385c4043594 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9390,13 +9390,17 @@ static void print_verification_stats(struct bpf_v=
erifier_env *env)
> static int check_attach_btf_id(struct bpf_verifier_env *env)
> {
> 	struct bpf_prog *prog =3D env->prog;
> +	struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
> 	u32 btf_id =3D prog->aux->attach_btf_id;
> 	const char prefix[] =3D "btf_trace_";
> 	struct bpf_trampoline *tr;
> 	const struct btf_type *t;
> +	int ret, subprog =3D -1, i;
> +	bool conservative =3D true;
> 	const char *tname;
> +	struct btf *btf;
> 	long addr;
> -	int ret;
> +	u64 key;
>=20
> 	if (prog->type !=3D BPF_PROG_TYPE_TRACING)
> 		return 0;
> @@ -9405,19 +9409,42 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
> 		verbose(env, "Tracing programs must provide btf_id\n");
> 		return -EINVAL;
> 	}
> -	t =3D btf_type_by_id(btf_vmlinux, btf_id);
> +	btf =3D bpf_prog_get_target_btf(prog);

btf could be NULL here, so we need to check it?


[...]=
