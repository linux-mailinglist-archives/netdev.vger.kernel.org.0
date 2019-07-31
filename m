Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C147CCE4
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbfGaTgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:36:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7800 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbfGaTgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:36:17 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VJXPnn008526;
        Wed, 31 Jul 2019 12:35:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iwtDi2PbwhW5l3XDhc3gpv+PCYTd543yalxiAesyMpA=;
 b=bxEpVVrTU+dr12OAh28yX7VTOSopThXCrrqWNs1bKo7tRh/6+NRIaVYhYQzkKuS4fjEL
 Ezljdb+tgg6QHQxEVA5GYEW9oBvTmyEawhP/0Bauknqj9l/q2B0WNLJaX45kAvO2gjZ0
 nwFntJvQkp3uRjWfYFZqT7w94IXUj9P9TpM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u369etcub-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Jul 2019 12:35:54 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 12:35:29 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 31 Jul 2019 12:35:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1BIQY+QwsHZEIeG1lyVYVYqhhEX7LW6qhZ1sZVFf2+TO1H7xrHlVIx5rw/BVkmateFLrvupJ6kNoIsPYWSP4Qroykr6+ymf6hL4AYxxWvrmN2/hmd0VTSPhnNJIisUpSKmQwxuxR9sPvRykAoxd/XnGx2DLz00WI8u8F1+HXpG0cYe9V2yNysVZXJ4AXaflC8CKJuFAQAg1cUwuSTTDSDrLEWAriYfGPDakCLdOc53z9nySLowo+MEG3UPMzyic9cRjnHvQPZkeIxzw1rZ1D8PZEv3BEzLJgxASLSvthDTnWCelky3z6PirDAtgGQEf9eWNrGAlWl/jZH2xn37Qbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwtDi2PbwhW5l3XDhc3gpv+PCYTd543yalxiAesyMpA=;
 b=dXgDhP5lHc8hM3nwtalijNUr+gVJTb2enxhcj68e7J34fwbRy7NKyPlMr3hjHWFs4EsEPZqiZbkW37wGuu/c+Vp1wqr5U8PR/QChbn6f3WSNFNO8e45F9XEX1Fnz4umbdnzN8nhaGhvb1GpGQAKgpWQiLv1EIldOHIq8XrGgSju5J4wYdDb9fYuKNLqkBi6WlunsgOaQttwcJO2Coi3pYH3X0ZOHJFsDLLqK5QMzVzv1D5s/oH/s1YjEgzmZ5cD7FStRp1Cd0D2dChEvqTxWrC863FHYPF8uJFwL1TK5GZxlaEmcuS39jVucdF0OFHuFh1N9jvLXZP2beAs/2sdgDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwtDi2PbwhW5l3XDhc3gpv+PCYTd543yalxiAesyMpA=;
 b=Ep9k8JCedSgtKZvfBVC97GF170TX4r4CYQcGttUsVXkIMlR8kYBMaCAb+rPLTg73Nh4gnw2BqaTH/Z7psAoetcHD510Zu+iYSzD7ZlmrzXUQRL6JQAOfNMkovPAOg1Fr08/XW2XERtiwbpMrPNqDE01x5QKcO4E9/7wZI/KApRU=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1549.namprd15.prod.outlook.com (10.173.235.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 19:35:28 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 19:35:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf 1/2] bpf: fix x64 JIT code generation for jmp to 1st
 insn
Thread-Topic: [PATCH bpf 1/2] bpf: fix x64 JIT code generation for jmp to 1st
 insn
Thread-Index: AQHVR0CwM2HycHsaw0iOFid8ET66yKblH7SA
Date:   Wed, 31 Jul 2019 19:35:27 +0000
Message-ID: <B6B907F5-E6CA-4C0B-92F3-0411CA4F4D95@fb.com>
References: <20190731013827.2445262-1-ast@kernel.org>
 <20190731013827.2445262-2-ast@kernel.org>
In-Reply-To: <20190731013827.2445262-2-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:70cb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7830229-717c-463a-ac38-08d715ee3e09
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1549;
x-ms-traffictypediagnostic: MWHPR15MB1549:
x-microsoft-antispam-prvs: <MWHPR15MB154946FDA4BA6ED36C8ADEE0B3DF0@MWHPR15MB1549.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(346002)(396003)(366004)(376002)(199004)(189003)(6436002)(66446008)(305945005)(66556008)(81166006)(57306001)(8936002)(50226002)(54906003)(4326008)(71200400001)(8676002)(2906002)(316002)(99286004)(66946007)(81156014)(86362001)(68736007)(6246003)(71190400001)(6916009)(7736002)(25786009)(256004)(53936002)(5660300002)(186003)(33656002)(76176011)(6512007)(36756003)(64756008)(486006)(46003)(53546011)(6506007)(102836004)(2616005)(446003)(11346002)(478600001)(476003)(14454004)(229853002)(66476007)(6486002)(6116002)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1549;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zFpXcOfoAd7sox/fLmTXaPC91JSOIa8ppeKKby8OF65FOnG6tdkr33wrk7lEbhnJI00HSGy/lrjGI2XL6bJo0yjYw3LrdT8V8fU4pe94/ZB2+d9XqX3kcCPozkEEaMdaUEbVxpJelSbYyuEKz8Y1c3mjd9U3rRmIptYYWCC23nfUvY039rSDTG3TdNAkxC5k0ArFl2mjTQ4+YxCDQTkX1DXmrKZm+E3H1cNeFircCeKxQwGxj4PigL1a+1rKh4rIpF82uRBbZ2T1VO2rKpfHHuHzGY1bSJzQHU8mNNLbjO4QpUguEaJJIHTPNOA6r2K8ZftD8l0u5u7D7F4ECLNsz9w7iqvzNTtdM91GwJkMUqiirQ3m2yJn3cHIKl5+8sbN2HlSXmShBakh6hqNMAicxzLZvaLsVHX3WYHQOYk7iDA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F7E426CDE596904C833A83ECD1E68E35@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f7830229-717c-463a-ac38-08d715ee3e09
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 19:35:27.9792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1549
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
> Introduction of bounded loops exposed old bug in x64 JIT.
> JIT maintains the array of offsets to the end of all instructions to
> compute jmp offsets.
> addrs[0] - offset of the end of the 1st insn (that includes prologue).
> addrs[1] - offset of the end of the 2nd insn.
> JIT didn't keep the offset of the beginning of the 1st insn,
> since classic BPF didn't have backward jumps and valid extended BPF
> couldn't have a branch to 1st insn, because it didn't allow loops.
> With bounded loops it's possible to construct a valid program that
> jumps backwards to the 1st insn.
> Fix JIT by computing:
> addrs[0] - offset of the end of prologue =3D=3D start of the 1st insn.
> addrs[1] - offset of the end of 1st insn.
>=20
> Reported-by: syzbot+35101610ff3e83119b1b@syzkaller.appspotmail.com
> Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
> Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

Do we need similar fix for x86_32?=20

Thanks,
Song

> ---
> arch/x86/net/bpf_jit_comp.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index eaaed5bfc4a4..a56c95805732 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -390,8 +390,9 @@ static int do_jit(struct bpf_prog *bpf_prog, int *add=
rs, u8 *image,
>=20
> 	emit_prologue(&prog, bpf_prog->aux->stack_depth,
> 		      bpf_prog_was_classic(bpf_prog));
> +	addrs[0] =3D prog - temp;
>=20
> -	for (i =3D 0; i < insn_cnt; i++, insn++) {
> +	for (i =3D 1; i <=3D insn_cnt; i++, insn++) {
> 		const s32 imm32 =3D insn->imm;
> 		u32 dst_reg =3D insn->dst_reg;
> 		u32 src_reg =3D insn->src_reg;
> @@ -1105,7 +1106,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_pro=
g *prog)
> 		extra_pass =3D true;
> 		goto skip_init_addrs;
> 	}
> -	addrs =3D kmalloc_array(prog->len, sizeof(*addrs), GFP_KERNEL);
> +	addrs =3D kmalloc_array(prog->len + 1, sizeof(*addrs), GFP_KERNEL);
> 	if (!addrs) {
> 		prog =3D orig_prog;
> 		goto out_addrs;
> @@ -1115,7 +1116,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_pro=
g *prog)
> 	 * Before first pass, make a rough estimation of addrs[]
> 	 * each BPF instruction is translated to less than 64 bytes
> 	 */
> -	for (proglen =3D 0, i =3D 0; i < prog->len; i++) {
> +	for (proglen =3D 0, i =3D 0; i <=3D prog->len; i++) {
> 		proglen +=3D 64;
> 		addrs[i] =3D proglen;
> 	}
> --=20
> 2.20.0
>=20

