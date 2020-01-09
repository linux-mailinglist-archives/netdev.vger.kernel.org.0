Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E811135FFC
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 19:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388411AbgAISJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 13:09:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9220 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728653AbgAISJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 13:09:58 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 009I9fg9026657;
        Thu, 9 Jan 2020 10:09:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=x2ocn6toyw87uXf7LZGL2A6O8oO9dWZ+0wfkwomDkJo=;
 b=LNgSgcgHGGHCOYAl/st8WVlPkFWCfjhRFb3J4tkvBUZLaO00W37qijResFqdMV/B7AsG
 lq3aVpRNnKsGUNrlehDhRGtUHZFrgxgoiKGA1Ui8nv1wEEEZQHQHNDrlusP5az4HAucT
 X1Dmn6ZP4Wz6qg+7qKfFt4ZMoO6ixKqxn7A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xe2exta27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Jan 2020 10:09:41 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 Jan 2020 10:09:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3JpGLLDoW3otAYu7gNyCGWK6z5++722QX9ulq7oTEbu+XcRe7BqSOkLByg1BOG5rvf5WeFxvu38nACrWaDmEVlE/xyqkc+xnVzXyyKpYBZ8AKa6j7tn583eo44WT2T4rHYfkC/dWQaO0LqzfRRIKQmlQltdnosdHEruuTlFn/v909TDHhOQKHA3xmRDTU4qanBngY3GHBEjh+xiyQV/4h8+InbZ//YZl/2lJ4r3m7hf6EuEeEGR+b4acEvQrTXPE+L3FfumGKUGNpa2R/oDiYA1Smh5zxkOoMcYQgWeS4F2FLBzu1V5BR9vxky27ZQUIO53+k7wTEPIKUEKTePZDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2ocn6toyw87uXf7LZGL2A6O8oO9dWZ+0wfkwomDkJo=;
 b=Nc5dItn1y23bOMwHxkt/PK6EWJeLUZ3htODe2WpbQ/5jz4GGNtIj4ci1S1U1T9mLwC8qiqormKvCA3tyowomcmw2IlQOiTxW5mAksTaRKSiX031ee3mbhJIaSk/qYgRumNfB/Zy2mgSqL7EfE9YCtnhiLIiVWvlcwmiMMosiO+ECQSxO24cEOL4/cSbJnGkpHorMwvcC+mvdafwGD3/OvmfrdAL8OLuM4PSUKMaBcG3ucTFjLyNW9Q1ByDQq87O9J+GdWqre8e09nSyU63rwJ032Xv4RCbadEuuwy2w+HaEgzRKZGoqfoK86AWc41Keo11sEnGCAKECOFBMMOBGAhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2ocn6toyw87uXf7LZGL2A6O8oO9dWZ+0wfkwomDkJo=;
 b=Z+uykXygawIqEwbS6Xh27tfUqLFzvB6PS43idsV5g0Gnz/91AYOKNGQ73FXGEifcVpzV+YC9YY6yYbm8nVZh2svlqfNOaepJP7d9ZnW7LTmYdaqNEuOcVf308j0GDWcfxEOkmTxjvObokbyMg11tVTyHwykdwfEKhApr9BGCd4I=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB3461.namprd15.prod.outlook.com (20.179.57.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.8; Thu, 9 Jan 2020 18:09:08 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Thu, 9 Jan 2020
 18:09:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/7] bpf: Introduce function-by-function
 verification
Thread-Topic: [PATCH v2 bpf-next 3/7] bpf: Introduce function-by-function
 verification
Thread-Index: AQHVxrdeNOx9FMXwt0uTmbe0Gk8rjqfiolYA
Date:   Thu, 9 Jan 2020 18:09:08 +0000
Message-ID: <B7A2A8DD-B070-4F80-A9A0-6570260D4346@fb.com>
References: <20200109063745.3154913-1-ast@kernel.org>
 <20200109063745.3154913-4-ast@kernel.org>
In-Reply-To: <20200109063745.3154913-4-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:200::455d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2c6a583-b64e-474d-2dfc-08d7952f05b1
x-ms-traffictypediagnostic: BYAPR15MB3461:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB34616CE501C4565B542C3109B3390@BYAPR15MB3461.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(396003)(346002)(376002)(189003)(199004)(53546011)(6506007)(186003)(6486002)(2906002)(5660300002)(54906003)(81166006)(6916009)(8936002)(15650500001)(8676002)(81156014)(71200400001)(2616005)(6512007)(4326008)(86362001)(66556008)(66946007)(66476007)(478600001)(66446008)(316002)(64756008)(76116006)(36756003)(33656002)(91956017);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3461;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B8doMEOIdPMepTfoNmJodOUl6/5MdxoX3eSUIfWJg3gJ+0MNKcjvPmHoe7CGNX64JfDC//2XXP6OYVmyXcojKATzD/s40utYhxG3NfCqqyA3QnTN6qr7SFzJM74DopkBCQKV8EU56zPubnSvh+odyZRkCbYTjavknwqr1cbyW3eXhSMoGO/zxhW02sXJA9itCrteyI13FDpJ8q61NZcBRjO+4ASVXyv8v/5LeSAj1zpnhrdTKlfGR9+e1YPqf1U0r7yz/GZ7PKCbt2UQHdmzpMLMvv8e3ERjBZepUrKTA83UU4sDK8uGRYuMC44yeh1MxFQVyCcgXKSM3IPTBHED+Y01Y2Jgl5+c1qCeGfIEDY/XVDo7VZAMShZntlsG3s4IGDkHmHoFYqIev2jou1NDuKTNaZtDsuiaskZfiNz6b03Av7XkDIuvnlBUf7/pjU6N
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32FBEBA2318D274DB30CDF6D9DBC69FD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c6a583-b64e-474d-2dfc-08d7952f05b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 18:09:08.6514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gZCDQV1vDooZGZsARp8Vw8xX0lUdQN9nnzyogSjf5diX4MNvwJHAjiPKXGWjjQKxz01/sxwyTtmw4ORnmPtd6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_03:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=604 mlxscore=0 clxscore=1015 adultscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001090150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 8, 2020, at 10:37 PM, Alexei Starovoitov <ast@kernel.org> wrote:

[...]

>=20
> Note that the stack limit of 512 still applies to the call chain regardle=
ss whether
> functions were static or global. The nested level of 8 also still applies=
. The
> same recursion prevention checks are in place as well.
>=20
> The type information and static/global kind is preserved after the verifi=
cation
> hence in the above example global function f2() and f3() can be replaced =
later
> by equivalent functions with the same types that are loaded and verified =
later
> without affecting safety of this main() program. Such replacement (re-lin=
king)
> of global functions is a subject of future patches.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

With one nit below.=20

[...]

> +
> +static int do_check_common(struct bpf_verifier_env *env, int subprog)
> +{
> +	struct bpf_verifier_state *state;
> +	struct bpf_reg_state *regs;
> +	int ret, i;
> +
> +	env->prev_linfo =3D NULL;
> +	env->pass_cnt++;
> +
> +	state =3D kzalloc(sizeof(struct bpf_verifier_state), GFP_KERNEL);
> +	if (!state)
> +		return -ENOMEM;
> +	state->curframe =3D 0;
> +	state->speculative =3D false;
> +	state->branches =3D 1;
> +	state->frame[0] =3D kzalloc(sizeof(struct bpf_func_state), GFP_KERNEL);
> +	if (!state->frame[0]) {
> +		kfree(state);
> +		return -ENOMEM;
> +	}
> +	env->cur_state =3D state;
> +	init_func_state(env, state->frame[0],
> +			BPF_MAIN_FUNC /* callsite */,
> +			0 /* frameno */,
> +			subprog);
> +
> +	regs =3D state->frame[state->curframe]->regs;
> +	if (subprog) {
> +		ret =3D btf_prepare_func_args(env, subprog, regs);
> +		if (ret)
> +			goto out;
> +		for (i =3D BPF_REG_1; i <=3D BPF_REG_5; i++) {
> +			if (regs[i].type =3D=3D PTR_TO_CTX)
> +				mark_reg_known_zero(env, regs, i);
> +			else if (regs[i].type =3D=3D SCALAR_VALUE)
> +				mark_reg_unknown(env, regs, i);
> +		}
> +	} else {
> +		/* 1st arg to a function */
> +		regs[BPF_REG_1].type =3D PTR_TO_CTX;
> +		mark_reg_known_zero(env, regs, BPF_REG_1);
> +		ret =3D btf_check_func_arg_match(env, subprog, regs);
> +		if (ret =3D=3D -EFAULT)
> +			/* unlikely verifier bug. abort.
> +			 * ret =3D=3D 0 and ret < 0 are sadly acceptable for
> +			 * main() function due to backward compatibility.
> +			 * Like socket filter program may be written as:
> +			 * int bpf_prog(struct pt_regs *ctx)
> +			 * and never dereference that ctx in the program.
> +			 * 'struct pt_regs' is a type mismatch for socket
> +			 * filter that should be using 'struct __sk_buff'.
> +			 */
> +			goto out;
> +	}
> +
> +	ret =3D do_check(env);
> +out:
> +	if (env->cur_state) {

I think env->cur_state will never be NULL here. This check is necessary=20
before this patch (when we allocate cur_state in do_check()).=20

Thanks,
Song

