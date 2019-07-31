Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6357CCF3
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfGaTjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:39:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37642 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726232AbfGaTjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:39:31 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6VJaZno014676;
        Wed, 31 Jul 2019 12:39:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WsXkRRO80uINPHbX7uUIOu75OsubdZ75uRwoCrBDWdg=;
 b=gMFbK6j4A7q2AHU7whj/IWMebNPqS7Ta5vAGZXhoMr/6BZhaK4eICuyYGxly1pJ8j8xA
 4ScaAuYZ1XNiVo0l0KQ+Xlx7F6mAeQWj1i36hLkoDOneyXK/qUmVEeSIP8DcX5rheM5Z
 C01HWIysHrddlsen0XF7fLIMDvauwNwLcC0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2u3gdng6sx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Jul 2019 12:39:10 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 12:38:30 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 12:38:29 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 31 Jul 2019 12:38:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ovl3AFgrhns/NQqpWoEpt/d1ICSWY6az3Xy49nUVdHvpYQFFIWXNQ3jNpXoqHLuw3UPNx27DlrDIkzz8hCAs3jZUBm0PIMfR+x6vyqvWwm4yBBYjDF0VIsOmTY+7A0ScKr2gKyv+LdtmZfHFojjWAYVRnw8pK3vblCYbA4u8zrQIdkySKIMXOC9V8oI/nnZDkRZCDlyICquG522tfhI38BcmsVelBct/iqFo+XQh6UgeWDa/vgsyzr5yzqKbHcqoHZ2FRaBbrkIHLIB3ZGgcMFn4QnImzxsSC8lzXEfgTTAlAdv0pPrOp5ZYn7UQhavX4AA2H7ABvwo0GGS7IHKM2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsXkRRO80uINPHbX7uUIOu75OsubdZ75uRwoCrBDWdg=;
 b=KsCxUZQ8HgqwtXyca0TJmpCXZvjMe5BBbjfY7zc0wmbn7lJoHYear88f7S1xGH7nZsQmk+h1H1j/g1DfIPqW2JdAHGmGFKD41+pzLyspCh8zbcIKFO0qiu9KqcrZ72BwjcQz41gfivt4z0THyJV2vlDoBbe7K6X2/igh6m57i39XiZmU5wlLiNURkAiORaR33Y4FWwq/Vk0/1tIR2ONy00h2tLMwywJDShW0qKHJaeiuJNuHzbjc79VdcZVZbqa1WhZNrbsasj4gKSsFOXMCg2KMuHoKDscpGP9gV/MFQgwDhPjNfI8wjz1shyKZvquvpOL9qVue+M6xEZelwTvRCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsXkRRO80uINPHbX7uUIOu75OsubdZ75uRwoCrBDWdg=;
 b=XDjpXETChug0JNTOe25GJPQ9mxggkIogdpsTFUC6x/+/ee5f/FsD3dtCrQwZWL9XfG5hzyh0M716tiRlT3T9OR9rcVzSV4NiMp6jW8Lb3Weqha19PxSCJPfipirkuJyCfuQMh4YvG1rwB2W+jS1NtoeVHY7Nw1op6gwozyfRsOI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1917.namprd15.prod.outlook.com (10.174.98.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Wed, 31 Jul 2019 19:38:28 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 19:38:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: tests for jmp to 1st insn
Thread-Topic: [PATCH bpf 2/2] selftests/bpf: tests for jmp to 1st insn
Thread-Index: AQHVR0C4c/agEpFo+E2HqEI6vkbDc6blIIqA
Date:   Wed, 31 Jul 2019 19:38:28 +0000
Message-ID: <9C8E7EB2-1ECB-42D8-8D08-1841A9EE31A2@fb.com>
References: <20190731013827.2445262-1-ast@kernel.org>
 <20190731013827.2445262-3-ast@kernel.org>
In-Reply-To: <20190731013827.2445262-3-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:70cb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d87eb67-b180-4ee3-06b8-08d715eea96a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1917;
x-ms-traffictypediagnostic: MWHPR15MB1917:
x-microsoft-antispam-prvs: <MWHPR15MB191735A9192D228BEDA33185B3DF0@MWHPR15MB1917.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(2616005)(33656002)(486006)(476003)(46003)(229853002)(256004)(316002)(186003)(76176011)(6506007)(102836004)(53546011)(99286004)(54906003)(2906002)(57306001)(6486002)(6116002)(6246003)(68736007)(25786009)(4326008)(36756003)(64756008)(66446008)(66946007)(76116006)(71190400001)(71200400001)(66556008)(66476007)(53936002)(6436002)(6512007)(5660300002)(14454004)(50226002)(8936002)(478600001)(86362001)(8676002)(81166006)(81156014)(7736002)(6916009)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1917;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ntOwtFnAKQVZmIOsgrJ8PkFQdbS2ubY13QnYe8K1sAdI+EvO3+Kg+Wp1MPrM1UM/x/UnVmwLxLCkI4gVJdWP4mVnXEmAYG+1ndfQ+EUDcYJxADHnT7GrbIm1i18P5Sq+eGXRfcb8iHIVDb8oFkXyd2X4gBfWtlOGG59AVF7j8co4SKKoLuaK74d7Or8//1vg68kojP6i/GyLgypqMnrAf4Mep8T0tB5/9RVUB35mlPk1uubDX3glR22XDAqCFA5GB+ugCLi8OEnGcQsZAta7EfbtPyhBjdnkYuivjiuCAnCZ4hdNOAu1lVYkNsvzFS6IQkYp4VPCXQva1RL4AfSD86/qEnAIYznEhSS8TcU+QCdPG5d1FfutGle2jSXy/n1JKVW3EWjxsYXOGiZmTZVYwwky9Nt+RsO4n4FDvlfEweU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC04377655BCDD45B7F08CC9E3EA8A8C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d87eb67-b180-4ee3-06b8-08d715eea96a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 19:38:28.3381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1917
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310194
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2019, at 6:38 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add 2 tests that check JIT code generation to jumps to 1st insn.
> 1st test is similar to syzbot reproducer.
> The backwards branch is never taken at runtime.
> 2nd test has branch to 1st insn that executes.
> The test is written as two bpf functions, since it's not possible
> to construct valid single bpf program that jumps to 1st insn.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/testing/selftests/bpf/verifier/loops1.c | 28 +++++++++++++++++++
> 1 file changed, 28 insertions(+)
>=20
> diff --git a/tools/testing/selftests/bpf/verifier/loops1.c b/tools/testin=
g/selftests/bpf/verifier/loops1.c
> index 5e980a5ab69d..1fc4e61e9f9f 100644
> --- a/tools/testing/selftests/bpf/verifier/loops1.c
> +++ b/tools/testing/selftests/bpf/verifier/loops1.c
> @@ -159,3 +159,31 @@
> 	.errstr =3D "loop detected",
> 	.prog_type =3D BPF_PROG_TYPE_TRACEPOINT,
> },
> +{
> +	"not-taken loop with back jump to 1st insn",
> +	.insns =3D {
> +	BPF_MOV64_IMM(BPF_REG_0, 123),
> +	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 4, -2),
> +	BPF_EXIT_INSN(),
> +	},
> +	.result =3D ACCEPT,
> +	.prog_type =3D BPF_PROG_TYPE_XDP,
> +	.retval =3D 123,
> +},
> +{
> +	"taken loop with back jump to 1st insn",
> +	.insns =3D {
> +	BPF_MOV64_IMM(BPF_REG_1, 10),
> +	BPF_MOV64_IMM(BPF_REG_2, 0),
> +	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 1),
> +	BPF_EXIT_INSN(),
> +	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1),
> +	BPF_ALU64_IMM(BPF_SUB, BPF_REG_1, 1),
> +	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, -3),
> +	BPF_MOV64_REG(BPF_REG_0, BPF_REG_2),
> +	BPF_EXIT_INSN(),
> +	},
> +	.result =3D ACCEPT,
> +	.prog_type =3D BPF_PROG_TYPE_XDP,
> +	.retval =3D 55,
> +},
> --=20
> 2.20.0
>=20

