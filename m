Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4347B44B75
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbfFMS6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:58:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48808 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbfFMS6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 14:58:23 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DIqU1x006560;
        Thu, 13 Jun 2019 11:57:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HeAw5it0aOxF5BMUVVMnQlSdDNNGVy93NZdw9SHwVwg=;
 b=TFWpDUia+5IRxGev9mj0oxCEE8oXsRqPFdmzSuZ4tZ9tTzE3fwXMlagcg08TSH8zLgPd
 qa+lALFEJhXk4gTlntaz175t3ZFt0t6vfE+Zp3/+DhaiD7+chU1nBYcDRP8WOx3kHCxu
 kQhbPlIV5pVlyFkPasqUfHTgWcZxwlJPAqI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3uh085d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 13 Jun 2019 11:57:12 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 13 Jun 2019 11:57:11 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 13 Jun 2019 11:57:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeAw5it0aOxF5BMUVVMnQlSdDNNGVy93NZdw9SHwVwg=;
 b=Q7WKIZvXNFdiPTIpJUR+CfFRMjUjirh8s3s8WUilTP2plJfeVw60zXrvSRHCD8w69Igmvv1KE8Ve22HwYaMEG9o30VH5jVA67K3LSEnKr/MelZlBm3L6DO640ITlqvxQNs/kmN9BLiTv0qzeeOGhwI18TZYsSH01e38762i4j3Y=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1280.namprd15.prod.outlook.com (10.175.3.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 18:57:10 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 18:57:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
CC:     X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 3/9] x86/bpf: Move epilogue generation to a dedicated
 function
Thread-Topic: [PATCH 3/9] x86/bpf: Move epilogue generation to a dedicated
 function
Thread-Index: AQHVIetJH2PIYLgPMkGqoUjGE1cwL6aZ78IA
Date:   Thu, 13 Jun 2019 18:57:10 +0000
Message-ID: <A753FBC1-3781-4A47-B0AD-A4300C552F7B@fb.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <b091755f6053b4a3f66de9c168d4f73a751a5661.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <b091755f6053b4a3f66de9c168d4f73a751a5661.1560431531.git.jpoimboe@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::706c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a177af1-972c-4808-74f9-08d6f030f09d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1280;
x-ms-traffictypediagnostic: MWHPR15MB1280:
x-microsoft-antispam-prvs: <MWHPR15MB128062019E123A53D5F7A24CB3EF0@MWHPR15MB1280.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(346002)(396003)(376002)(199004)(189003)(71190400001)(81156014)(86362001)(8676002)(7736002)(53936002)(73956011)(66476007)(66556008)(64756008)(25786009)(305945005)(6916009)(478600001)(14454004)(57306001)(71200400001)(81166006)(4326008)(8936002)(50226002)(2906002)(66446008)(66946007)(6512007)(76176011)(76116006)(6246003)(476003)(14444005)(256004)(36756003)(5660300002)(6116002)(68736007)(99286004)(54906003)(6486002)(6436002)(2616005)(53546011)(486006)(102836004)(186003)(46003)(446003)(11346002)(229853002)(316002)(33656002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1280;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F83m0jWvu0XOoaxtls6lBU7Ag2wY2KO2Tgq4780YhW9QOqSo4a1JJnx4pj8zZrO7MQzgNEbTYz7astfopPNUlAS3/5xy1slfVEYXRGsXeIOBvR5ud/ab7tPrHnBUN3yiWMUZfrjVtrCiFN1R9XK9UW2YQ7sPqRB8XajdNegHRAeU3OJLagzktsRcgw37Vjh+OrX/dAWuaPRMl6vhHPTbImeL8b7xlgdkcrTThTO5cQcFGJezjpK+U+SWbfFkgLXjseGCPFN4LPMh5EZYZRqAzG1Gfh16TCF9Wy6YrjX5z/zCh8jhFeS2CwyOZAItlcMVBnVA8tutmLPjON6vILoPm1HGsbZzhA2OCyZlebfwOX5JwHBN3w6m0IX25mKxQQEOBCXOprv4DBUvcKkmPnCQKJtjXJkQlWfM/oM5qMxJ3ts=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9F07B44912F94D4A914F3DA869300164@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a177af1-972c-4808-74f9-08d6f030f09d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 18:57:10.2789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1280
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=748 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 13, 2019, at 6:21 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>=20
> Improve code readability by moving the BPF JIT function epilogue
> generation code to a dedicated emit_epilogue() function, analagous to
> the existing emit_prologue() function.
>=20
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
> arch/x86/net/bpf_jit_comp.c | 37 ++++++++++++++++++++++++-------------
> 1 file changed, 24 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 32bfab4e21eb..da8c988b0f0f 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -240,6 +240,28 @@ static void emit_prologue(u8 **pprog, u32 stack_dept=
h, bool ebpf_from_cbpf)
> 	*pprog =3D prog;
> }
>=20
> +static void emit_epilogue(u8 **pprog)
> +{
> +	u8 *prog =3D *pprog;
> +	int cnt =3D 0;
> +
> +	/* mov rbx, qword ptr [rbp+0] */
> +	EMIT4(0x48, 0x8B, 0x5D, 0);
> +	/* mov r13, qword ptr [rbp+8] */
> +	EMIT4(0x4C, 0x8B, 0x6D, 8);
> +	/* mov r14, qword ptr [rbp+16] */
> +	EMIT4(0x4C, 0x8B, 0x75, 16);
> +	/* mov r15, qword ptr [rbp+24] */
> +	EMIT4(0x4C, 0x8B, 0x7D, 24);

Shall we update these comments to AT&T syntax?=20

Thanks,
Song

> +
> +	/* add rbp, AUX_STACK_SPACE */
> +	EMIT4(0x48, 0x83, 0xC5, AUX_STACK_SPACE);
> +	EMIT1(0xC9); /* leave */
> +	EMIT1(0xC3); /* ret */
> +
> +	*pprog =3D prog;
> +}
> +
> /*
>  * Generate the following code:
>  *
> @@ -1036,19 +1058,8 @@ xadd:			if (is_imm8(insn->off))
> 			seen_exit =3D true;
> 			/* Update cleanup_addr */
> 			ctx->cleanup_addr =3D proglen;
> -			/* mov rbx, qword ptr [rbp+0] */
> -			EMIT4(0x48, 0x8B, 0x5D, 0);
> -			/* mov r13, qword ptr [rbp+8] */
> -			EMIT4(0x4C, 0x8B, 0x6D, 8);
> -			/* mov r14, qword ptr [rbp+16] */
> -			EMIT4(0x4C, 0x8B, 0x75, 16);
> -			/* mov r15, qword ptr [rbp+24] */
> -			EMIT4(0x4C, 0x8B, 0x7D, 24);
> -
> -			/* add rbp, AUX_STACK_SPACE */
> -			EMIT4(0x48, 0x83, 0xC5, AUX_STACK_SPACE);
> -			EMIT1(0xC9); /* leave */
> -			EMIT1(0xC3); /* ret */
> +
> +			emit_epilogue(&prog);
> 			break;
>=20
> 		default:
> --=20
> 2.20.1
>=20

