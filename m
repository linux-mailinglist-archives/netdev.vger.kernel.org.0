Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4261A7411
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 09:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406306AbgDNHES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 03:04:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406214AbgDNHEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 03:04:16 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03E72xcr016886;
        Tue, 14 Apr 2020 00:04:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=89UTe5Ou06shPEZEzJKsF4nWTi0liyKop3yxLZzNl68=;
 b=P9U2uFPveFD5qPaeDUG/us9ZshavWfRdc5RIqWsVmhe/Xc7IEL6o1LVLhEiu8ZdNfXO/
 U6DsAdvUq7TycdV45T2NdfY1Pz7WH9oxd6AnmrHZVzQPS12bJFlDzgWx8XVvAsaKwT/r
 bQP5O4AmCJKPGyi3Tkk7gEVyZS0hXehYr54= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30d8ekr06m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Apr 2020 00:04:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 14 Apr 2020 00:04:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSJdbpnEMN9lfoifFRwWKvgqy5SDXvOI0aquqOOj5VOTOM7/Nws/hBuQJOC/uzOmLXbjarqUm8eHuLzXM6yZ1jqksxxnDTNSxrJ9U4l9V6QI/mvkrPy2GhCM+mUvxfjGX4SmzD35pgDtUhEmXTQjGFdiJClMFQlt/h+TnqMWgXgK/FQROJSTEbJIrC2OEUne9aA9Z0dUyJleKQ3eIuyFMOLHJ9xLG5NKF7XSAiDGsu4JVNgIJ1CUo1Ja2hGPStMVttfQVT2E8gbYJYVS4tDZMT0my9EgzrNRiWwY2ioloiYAsfed6C8DRgTQ23IFDl9nxqxcbshHaOYONEL5m2c8RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89UTe5Ou06shPEZEzJKsF4nWTi0liyKop3yxLZzNl68=;
 b=SZPtbPhMi8Uwlr6ITk0p7ha6I3wf3Jt80x7LGn7d/OFyikBQaKqOIQmgZuoGmlH0wsFTzvNJhZK7RIhzJM9MVY0M65285puRiA/L6zZARmYuK4fepn1QTzy/dO2vZpxD3s9h3DrCtg1xdIvFyxaPmCJ3w/b9TW5bwZO69B/Veqi5N8QNU07CFz6X1lj44YsSGyMOVR/DMMeQM/LjxlNFpetUn4Nq4h0STuMYBR3dzaj/KLMs3xj96x0Q0/gBM61A/nD3avjxcxt07Hm9lnHimFYWILp82Sk7pgFVfaZD8th1JqiMUt2bdUDxIzeEmgF/FLEtjWNBCzcOIfuor0RNSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89UTe5Ou06shPEZEzJKsF4nWTi0liyKop3yxLZzNl68=;
 b=Do/3L12aEOZmtHLNoLcFgeD/o8f8ST9sJBz7qFXX66NLxabS4+aQyzBQ6EHsbpjinYyTr8WaAZnTG32oST2RZBzMuSxLZoaR0oZ9Ckkv0IB7Sw5Ohj5D/CZybRGjyJVMOGUOsEo1qbkeCa2D2nMfiZ5UAlCsPRPH5f3x2EM6tDU=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3222.namprd15.prod.outlook.com (2603:10b6:a03:10d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Tue, 14 Apr
 2020 07:04:00 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 07:04:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: always specify expected_attach_type
 on program load if supported
Thread-Topic: [PATCH v2 bpf-next] libbpf: always specify expected_attach_type
 on program load if supported
Thread-Index: AQHWEhkJS7kOYuB4pEWWsARZmp1+Nqh4MYuA
Date:   Tue, 14 Apr 2020 07:03:59 +0000
Message-ID: <6E178D01-CF89-4AEA-8705-9789E58B1D46@fb.com>
References: <20200414045613.2104756-1-andriin@fb.com>
In-Reply-To: <20200414045613.2104756-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:2730]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2eeb66fc-6f8e-49a6-f8ba-08d7e04201f3
x-ms-traffictypediagnostic: BYAPR15MB3222:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3222F8A0D6014CB4C1C4DE80B3DA0@BYAPR15MB3222.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(136003)(366004)(376002)(346002)(396003)(6506007)(6862004)(478600001)(37006003)(2906002)(86362001)(966005)(71200400001)(6486002)(4326008)(81156014)(8936002)(8676002)(53546011)(6512007)(5660300002)(186003)(36756003)(2616005)(54906003)(316002)(66476007)(33656002)(6636002)(76116006)(91956017)(64756008)(66556008)(66446008)(66946007);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Lr27zyrFcYlj0yok+z4U1Wbn9BRelqXMQYm/N4qmqt4MMgkIASbVF+aiYRIZ24Y/uRXEt/bIyU/DGqc3OmwdTuuriaJ7dEAZsIhDwMkwyc1jjcCZvFDOlzB0K31AFwRXl7JdeoHJqaPdDf/lFJ7rahF79ctjJPAMXyJfInNx/IRlBbM+GLokuxZAyBCBtNCiyoXfKvvPv4eoKm8EQWLEOvz3c8JD2nD84Jajsjnt+n3QAx0n4zZkjE9VceT6SW0ufmcfuyEYqrnjdsn2UlmEJALBes6NDevO1AkRfPJC0sjU3FWglfw3HJs+g2fOQLAv6R3A8+hIWo55k//HUM7trtIx7xo7YQW3tXWQa/rmLGlSiYLMEXhXZ1utDjVljXtt0XkfplLChtgj6SOUXecE2p62SWF0T8vhncxB0IgVxvoKoIbBCLUvc0DvVV5eQ5lNTU9HNsfMyJ89+CUk1nOtbV04IZ9c+1WEJ7xbu7dPfOj8PbQQhaHzAGvdbgmFAl+OZc9JHVfJB9kwpZKNfUDlg==
x-ms-exchange-antispam-messagedata: s0BWrJqTefTBmuGIGC6GINh/JjVAfpyT774KgLGaZFhh7xOEM8qLGXv3KXmg8lnGR+MnaKHr/oQsHhp4kiFE3IqLTPkmbSj1W6rIfMRZvleWh6R9ceIKmTmv1LARDROljNAWPsRCHKs0IvMiOY55+6/5INeLzBNmPvkV5vGYmOSV4IKVJv3/RoAfQPln1OjC
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BCEC663182007A4A9C42702AA133815E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eeb66fc-6f8e-49a6-f8ba-08d7e04201f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 07:03:59.9725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g1b69w7DtPUN6BMJ6/mNpu6N3xHMG4AlrlbhoCD3KGneTjlHa6O46wqPGXNwv2Kc2ir6wj4QibeRIM1B7LSk5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3222
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-14_02:2020-04-13,2020-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 clxscore=1011 malwarescore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 13, 2020, at 9:56 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> For some types of BPF programs that utilize expected_attach_type, libbpf =
won't
> set load_attr.expected_attach_type, even if expected_attach_type is known=
 from
> section definition. This was done to preserve backwards compatibility wit=
h old
> kernels that didn't recognize expected_attach_type attribute yet (which w=
as
> added in 5e43f899b03a ("bpf: Check attach type at prog load time"). But t=
his
> is problematic for some BPF programs that utilize never features that req=
uire
> kernel to know specific expected_attach_type (e.g., extended set of retur=
n
> codes for cgroup_skb/egress programs).
>=20
> This patch makes libbpf specify expected_attach_type by default, but also
> detect support for this field in kernel and not set it during program loa=
d.
> This allows to have a good metadata for bpf_program
> (e.g., bpf_program__get_extected_attach_type()), but still work with old
> kernels (for cases where it can work at all).
>=20
> Additionally, due to expected_attach_type being always set for recognized
> program types, bpf_program__attach_cgroup doesn't have to do extra checks=
 to
> determine correct attach type, so remove that additional logic.
>=20
> Also adjust section_names selftest to account for this change.
>=20
> More detailed discussion can be found in [0].
>=20
>  [0] https://lore.kernel.org/bpf/20200412003604.GA15986@rdna-mbp.dhcp.the=
facebook.com/
>=20
> Reported-by: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

With one nit below.=20

> ---
> v1->v2:
> - fixed prog_type/expected_attach_type combo (Andrey);
> - added comment explaining what we are doing in probe_exp_attach_type (An=
drey).
>=20
> tools/lib/bpf/libbpf.c                        | 127 ++++++++++++------
> .../selftests/bpf/prog_tests/section_names.c  |  42 +++---
> 2 files changed, 110 insertions(+), 59 deletions(-)
>=20
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ff9174282a8c..c7393182e2ae 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -178,6 +178,8 @@ struct bpf_capabilities {
> 	__u32 array_mmap:1;
> 	/* BTF_FUNC_GLOBAL is supported */
> 	__u32 btf_func_global:1;
> +	/* kernel support for expected_attach_type in BPF_PROG_LOAD */
> +	__u32 exp_attach_type:1;
> };

[...]

> -#define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, btf, aty=
pe) \
> -	{ string, sizeof(string) - 1, ptype, eatype, is_attachable, btf, atype =
}
> +#define BPF_PROG_SEC_IMPL(string, ptype, eatype, eatype_optional,	    \
> +			  attachable, attach_btf)			    \
> +	{								    \
> +		.sec =3D string,						    \
> +		.len =3D sizeof(string) - 1,				    \
> +		.prog_type =3D ptype,					    \
> +		.sec =3D string,						    \

Two lines of ".sec =3D string".=20

> +		.expected_attach_type =3D eatype,				    \
> +		.is_exp_attach_type_optional =3D eatype_optional,		    \
> +		.is_attachable =3D attachable,				    \
> +		.is_attach_btf =3D attach_btf,				    \
> +	}

