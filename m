Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A8F42DF62
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhJNQqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:46:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230488AbhJNQqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:46:30 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19EFq4dW027916;
        Thu, 14 Oct 2021 09:44:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BY5YbCRPVh/ZQj/jl1VqfC3yU8sS6Dj3JCxZuftJltc=;
 b=J/XiYKxqqs6pFpaBV+HohG+Ymre5Hz2W48lFMM64YQtwNS8PZyIfEKNv5F6Tl8a5oth5
 uZxnXxNxrIspR4UTpa3zbBAGgKArVvUnf1BMGNZMSHUQna9Fi+RwnrtdIaV147QEGtki
 83ll/ENC2Uucd4shpxSBDAPiuH3cgTFsK2k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3bpqjggf5d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Oct 2021 09:44:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 14 Oct 2021 09:44:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhL34uJR1KORgxjH7VhUj0X2Q8E3vc5AM/P3yQR1tIPKgsqCY2URXrquQ1286D6sqXIl9bdn4r1eTYk5jBrGYvMayBz46789A7nu3QirVMwFzZ3T5ZmCpqSrF5wDYwYjkkIRN/Ekde13s2jMmMPvaGbYPyEIbElH0Sq/fXnyuWvXQXgx6uwbf0rBBLleD9c/JGA3ORtK43ZbSUMsao1xNcwG/U424u5a+eTWUV6nwrcyosORutyxVzHi1QI//9OkMrlZEkaCAMZb7Ls1IctOMutL73JJriqRhdnt9ubpUriEBTtWvf2j/C4uyRugOXMLnlUqYwSHEKg+AUTyxxKqVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BY5YbCRPVh/ZQj/jl1VqfC3yU8sS6Dj3JCxZuftJltc=;
 b=fL9gIjiTDyK9DF5xpI5Iyz+RoL8/B++2DPZilgVFD8Eb+rWL9RCqEHTznPVz40VZbMYdYGNfnspZ/I+ym1GHTAq+6m/FKaoVuiy7MXQC3Xe/n8XbzwtZdwqhVSNhGx4OyeD6dF6nzyNit/9Zf0pl3JbBkLnDq8L8sFiJ0pJyv4eKio7BuxN/gs6Ii1D34Zm3lFXYfMTuk2IiwNf22N+brEkg/ybG5JKAYDNPc/3Lwkf50CKniNNxFRxBWB+zkk8eQGEvGEc5TkGCrebB/KMBhtROqykrYlI6Nck+JI72zj+YbdG5+mMKbOzAKFKIxamhZTD4UPfVymEF0cxqLrWELA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5162.namprd15.prod.outlook.com (2603:10b6:806:235::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 14 Oct
 2021 16:44:21 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 16:44:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/8] libbpf: Add weak ksym support to
 gen_loader
Thread-Topic: [PATCH bpf-next v2 3/8] libbpf: Add weak ksym support to
 gen_loader
Thread-Index: AQHXwASzENcXh1FfzUyK5YXKxQf8aKvStW4A
Date:   Thu, 14 Oct 2021 16:44:21 +0000
Message-ID: <03DE7252-51BD-4393-9F84-2B6C69ADA048@fb.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
 <20211013073348.1611155-4-memxor@gmail.com>
In-Reply-To: <20211013073348.1611155-4-memxor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f021a67-066a-480f-e9a2-08d98f31df55
x-ms-traffictypediagnostic: SA1PR15MB5162:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB5162FF1709C0252641606793B3B89@SA1PR15MB5162.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hs1WntIK/rItQrcMQMksy689TQuSnioRRWEkanACBG8iAExGzQQdHT2zqs5BDSglRK2W1CDcYVNSIkrNuWM9LFkREeTmA31gBCBu/N7/c56b6wy8/vi2QspTVol+KWgOYMzD+LJj01ueP/fFAzp8ldNYoDMe0G2vdEB9VyOrcqmE8SKk1cAsfFh1ORYXYfSTs+Ryv6WgQFNbebyF+xuWImKf8ZVpQMq3bdvKzKFBsAI6hBNpzzkCe1p3EDJYyc2spkctDAnpMfFpMzDOj0cI+bp6+aekstIhPxCHUOAOmzto6p/4Skei9q4b4R40maIUl6DktdivG7so4Ri8B5ZUxwxRdfhhZvxvQo0oZFs9XiPsj88qbvRwR/O9DMw47WJe7fQ+GD1A5XWqL41FlN/QSshm6IokmvPcJI9rZxJoBnEMw3o5ia3T1ScGxnhidMSBPun7m25PavwTgxOZrNuKrFzMwk+W5dra47Vh3AiwAKEtseEmLEypQ4p2nQydkb3QB1xPSotIaZQPj+ycjqkvmmg37zIWQEAVE7XXisXkuQB+FlroOgpR29bXzNc9hB2Fi59XrK6gi5E/BOfoX3ZprSFjWsWelS3Y6A+4vHebFXpitfgDfmAmzloeFFX9SG7xjeTiaguV5jfDhHzU7yJlehcTNwTKkuvJBNeBqaYPm+HxGFl+qko4gfA9JRtWVaiLcP4/oFVzCMlw16QKuVwgUYNE2htWCVn5tpEV0fvoZSormwsKeD1YGRncIWv9mRFU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(66446008)(5660300002)(38100700002)(33656002)(4326008)(38070700005)(64756008)(6916009)(316002)(2616005)(36756003)(122000001)(91956017)(76116006)(6506007)(508600001)(71200400001)(86362001)(8676002)(8936002)(6486002)(2906002)(66556008)(6512007)(66476007)(54906003)(186003)(83380400001)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?12YzvI9xw14vsynduz0HJ3NSFpd64mA6EeNBBBm757Crc9NXOz2lvC93dp?=
 =?iso-8859-1?Q?fiZeEjfUsxgwoQX8bly23vNdfFrx+ejl85qEa8hpdIs7BAAyHSFetIiDYW?=
 =?iso-8859-1?Q?+jtg9jJmeFpibYhoDFqSmm8fHvtbFYfhswEHMoRfL/rjLTkDfI8KjfcJXO?=
 =?iso-8859-1?Q?YhvY4lV5ZKaYkHF0+kmzNjN1tdL6W0J3Y6gvSE314RKOKaJ9D0ijDklMJP?=
 =?iso-8859-1?Q?GBTdx5puq4i4IPMX6uWOXO3paMsI/cGEBFk+SNuXZbdeWq2mDqawVJ1VdQ?=
 =?iso-8859-1?Q?tOlG6lsj5AFZCEordx0Y8w4fKA70MtBfP/CaWCRT6zIPkuAb3PySLED7Hd?=
 =?iso-8859-1?Q?QVYjsjFX6HaI43HFor4NuCGLE4JSuHtO5npu0hbpVs7UJy16EMhag/R1+h?=
 =?iso-8859-1?Q?gtlynQeJX0/b61NoNSqBehCCROaxhfh8Rh+Hozxrehs8yIGibaFOM7dWv7?=
 =?iso-8859-1?Q?yCH2XKImDvGKGycLGa8XIhlo6823OC6klOyOZmImUbSsDxnswvVwkqzhlv?=
 =?iso-8859-1?Q?q4PalX2NWs2IXuNqFxbDTdUrYO5gJSrAeQfbbu5bqAxAlAOPRS2meqcIMK?=
 =?iso-8859-1?Q?q30BEsQtKjPNmNBHmXEpYXqwOF1VdHkKY8EkMHqss0BbHreAu70eVlKAYd?=
 =?iso-8859-1?Q?O/g9cyWZhi4QHkU+maaGvb2hxDkYVplm8PFYSRM4aM8Es6Pz2O/2cQHM1o?=
 =?iso-8859-1?Q?K4ExuAJjiXyRLynliNN2ZfjM40jVsNk0AQcbE54MCvXIQLivR9aKbZF76N?=
 =?iso-8859-1?Q?sV5gezpAnqz9M1YUJYKWsANuWejn3l25ziXfPdaJRaAJwy4hfOM1G1+44Y?=
 =?iso-8859-1?Q?XW6p/ZZy6lna7T6KfHJ5QtrZy9kDOxjwGQKmq5PDzOPxT9UrwtvU+6sjob?=
 =?iso-8859-1?Q?Yh2perf9uDyfKSZZayaRkLJUJ6YUp+QD/wZ/epOxkHjW9xYpaEHHXmsOpj?=
 =?iso-8859-1?Q?wkEC3OhbLta+/vZ7simZjcaVktv4jh/R1UtzT6DunNraxFtOgaBZIahvHm?=
 =?iso-8859-1?Q?1bwy84P/G8d15UoVmL4nGFlo0P5I81WKFk1GSa1NjdrudTcL5kByd02DOM?=
 =?iso-8859-1?Q?nOLueBAInFAP4EEiTwnc8WrLD2kcAMwaNILu60+T5PWY/aJWR+xjQUw4VF?=
 =?iso-8859-1?Q?avfsetxmroBX0sQFybT/tpl+Uj57DjquZqjpm9zfsbQQSGUWQQtV49ePK6?=
 =?iso-8859-1?Q?uAoZg/6loOozuLOjnUZTcKOvRN71lxPu1T9OXKLunrykATcaadfwds8PoO?=
 =?iso-8859-1?Q?byZLepM/D/YKAwc/tIHDqT508O1lvL/6/22YJubmBTU36oiKEraWw7vNba?=
 =?iso-8859-1?Q?0ZirYxEx0LMkb5eTC38ViclBm8DX9LRx7JLyTtSO28fKX6s4+dHwCLkXEK?=
 =?iso-8859-1?Q?ZM4nR99IRS1swEhKGzN8WiRQXHTi3fWuin3av7F9qzaq+ACdm4vHo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F01BCF7BC8BD764CBC8667FC0B01C907@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f021a67-066a-480f-e9a2-08d98f31df55
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 16:44:21.0957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: noHDGZVY4SZWxA2eJRKLyUyFrqrUevC2KOTM9PqXqNtI7dzdNcAfbNT9wxqLyrYmoXbnMkE59dzDOmTIhU3yOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5162
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: DUSRjUcmUN78vAslQ-DsJ2BdA_KRKQRk
X-Proofpoint-ORIG-GUID: DUSRjUcmUN78vAslQ-DsJ2BdA_KRKQRk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_09,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=983
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 13, 2021, at 12:33 AM, Kumar Kartikeya Dwivedi <memxor@gmail.com> =
wrote:
>=20
> This extends existing ksym relocation code to also support relocating
> weak ksyms. Care needs to be taken to zero out the src_reg (currently
> BPF_PSEUOD_BTF_ID, always set for gen_loader by bpf_object__relocate_data=
)
> when the BTF ID lookup fails at runtime.  This is not a problem for
> libbpf as it only sets ext->is_set when BTF ID lookup succeeds (and only
> proceeds in case of failure if ext->is_weak, leading to src_reg
> remaining as 0 for weak unresolved ksym).

[...]

> 	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
> 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7,
> 			      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
> -log:
> +	emit(gen, BPF_JMP_IMM(BPF_JSGE, BPF_REG_7, 0, 3));
> +clear_src_reg:
> +	/* clear bpf_object__relocate_data's src_reg assignment, otherwise we g=
et a verifier failure */
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +	reg_mask =3D 0x0f; /* src_reg,dst_reg,... */
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +	reg_mask =3D 0xf0; /* dst_reg,src_reg,... */
> +#else
> +#error "Unsupported bit endianness, cannot proceed"
> +#endif

nit: Please put the "if defined" block in an inline helper.=20

> +	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct b=
pf_insn, code)));
> +	emit(gen, BPF_ALU32_IMM(BPF_AND, BPF_REG_9, reg_mask));
> +	emit(gen, BPF_STX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, offsetofend(struct b=
pf_insn, code)));
> +
> 	if (!gen->log_level)
> 		return;
> 	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,

