Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D907B4F6
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbfG3VZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:25:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387649AbfG3VZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:25:01 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6ULC8mF012176;
        Tue, 30 Jul 2019 14:24:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GYw7ghe01MGy0JBORr3c66RMfRPpbm5GAAEOb4zL7+I=;
 b=m/H66/ivrv8eKOTrtdx5tt3LFdU0nuupBCULBpwo2ebo+hQaqRyduSRDmJKkbm3cpfqG
 fIXzINLCQFHd3vcQu8ikCfYIK+1s6vuyhzK99KXjJE6GAgEMBu2sJUExWZyOHr4qvRnb
 FXj04YV69xQ0g0ZB5RsK/fwKwvM5gUO0kpo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u2uy0rcuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 30 Jul 2019 14:24:41 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 14:24:40 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 14:24:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMgc+pM8L7LLvQX3+QQ1R8xxc501NQ/C1qUJHZrE1Apv21hLA0b5lT8HO2s0esk8zbXSmvfdxaYC2v8QC+sKZQiBUSXzMu4INwoHSTgtzpBuymOFqKLK4gBU9rvNEtpw/foX67ylSqElqTHGMmje0GmfhXDjOmgc6kCsyJqvK+cjuLGBTKZ4SOZZ9cGZJgPcfhdppO5J2dhxeOu8+t9Nv5OuLyCx4I5nP79NqKj+vqG4CpAV6o4T7WxW95OHGbkvYVyFk+QbUGBWJBKD92Ir2dYy1AV8PODlwSriuD63Xjkwto210X1vKD9Rwr4b/1ZsQRdBQ1wn8uPJsnEynlfYfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYw7ghe01MGy0JBORr3c66RMfRPpbm5GAAEOb4zL7+I=;
 b=IxXw1xJ+2q5LiO2oqgn7W1UW2TVoSUd4OYfXT6lJF2DmS8jDdg5ptYXTDVceMZeYUdXce9ykBX5BfwOhGAIH+dXsNhN2TzWsyghYt+6fvUA94M9Z0SXgfhaLNaV8JEdeOLRTxU+oy/NuRFT60fq86a8XwG7T3ePRYKxj8gm0PShXbom4nhI82pxPiGUEKbFMC6okXQt4zi3owSLmRZmLf6fOUcoQCdmwMQzrgH0rgFGK6jPbkPPcYEFfnbx+l/pRF/yArvh0wVtOJMYCt9X0DUys6esxdUnOVZesufaoUwW8p9gnUDr5LM1WjlR9V1pQPwn7lgdfDmKKUKLbqVWzkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYw7ghe01MGy0JBORr3c66RMfRPpbm5GAAEOb4zL7+I=;
 b=G3gZmG54VeLAMhfVHw4Z2KHU2vCo3e2ztX/nZsz9A31QmQrze3NXEyvkpiHlAf6E1NHzeG6+pmmMNCObazGkUKYPsDANTcq1SAyn3uy/yZxtbF3Q1jAw/xKM7m6nKA1Bn0LDDEYTMq6XLqJ3xuekBh6Irq+2BifH1g8Wti3Nn7Q=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1197.namprd15.prod.outlook.com (10.175.7.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 30 Jul 2019 21:24:36 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 21:24:36 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 03/12] selftests/bpf: add BPF_CORE_READ
 relocatable read macro
Thread-Topic: [PATCH v2 bpf-next 03/12] selftests/bpf: add BPF_CORE_READ
 relocatable read macro
Thread-Index: AQHVRxC5ijGhYs8+0EOSm0twzvUWnKbjrD4A
Date:   Tue, 30 Jul 2019 21:24:36 +0000
Message-ID: <87422673-525B-461B-B487-EB16386CAB25@fb.com>
References: <20190730195408.670063-1-andriin@fb.com>
 <20190730195408.670063-4-andriin@fb.com>
In-Reply-To: <20190730195408.670063-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:5cb8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21732360-39f9-4af8-d964-08d7153452e5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1197;
x-ms-traffictypediagnostic: MWHPR15MB1197:
x-microsoft-antispam-prvs: <MWHPR15MB119740F7345760E08FD3F1B2B3DC0@MWHPR15MB1197.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(39860400002)(346002)(136003)(199004)(189003)(6486002)(68736007)(7736002)(25786009)(14444005)(256004)(305945005)(6436002)(229853002)(186003)(5660300002)(86362001)(8936002)(71190400001)(71200400001)(53546011)(8676002)(476003)(316002)(53936002)(57306001)(446003)(2616005)(99286004)(102836004)(76116006)(486006)(81156014)(81166006)(66556008)(66946007)(54906003)(6506007)(66476007)(91956017)(37006003)(66446008)(64756008)(50226002)(6512007)(11346002)(6116002)(478600001)(46003)(76176011)(2906002)(6636002)(14454004)(36756003)(4326008)(6246003)(33656002)(6862004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1197;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ih3PvXe48f894++pJiXd3kvR2RB5r204xGg7OhR7LVY/cBOgTj8oOMed6CDEHnb7JY+PPKjHKVdY7ZBorpPd70epQtpTUPayYuVPHzcW4mCnALIHyMICF9wi4/431dyIj6JqKdUSgcvswC5iiij/lBnXYxJ6+04hmBKlOonNcWIBTWBb+uFdx/e3vyrXWZF5P+UTrzwoTYa6osgYlCpLNVRw6Ql4DFO559b1/jUzprSH0+aUy5DTKOxyPRLCg118nVaOJJUa/mjhhxMG152niS/zusBacg/XCkWSe0tJldGTK1A6SMAydFYTJnRILfICO/jE9O3lDee8XGfyEP6WISrqFqnVR9aNiUCTpFTgJSyyHL+fYr+BWY9pfFM6kjxIqJQ6UuI+wAztAkmmchbdad/E4llJzJosJlXMiH3gUBk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9F06C2A3F194364EB0EA0DB88B6E73EB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 21732360-39f9-4af8-d964-08d7153452e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 21:24:36.6750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300212
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 30, 2019, at 12:53 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add BPF_CORE_READ macro used in tests to do bpf_core_read(), which
> automatically captures offset relocation.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> tools/testing/selftests/bpf/bpf_helpers.h | 19 +++++++++++++++++++
> 1 file changed, 19 insertions(+)
>=20
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/se=
lftests/bpf/bpf_helpers.h
> index f804f210244e..81bc51293d11 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -501,4 +501,23 @@ struct pt_regs;
> 				(void *)(PT_REGS_FP(ctx) + sizeof(ip))); })
> #endif
>=20
> +/*
> + * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offse=
t
> + * relocation for source address using __builtin_preserve_access_index()
> + * built-in, provided by Clang.
> + *
> + * __builtin_preserve_access_index() takes as an argument an expression =
of
> + * taking an address of a field within struct/union. It makes compiler e=
mit
> + * a relocation, which records BTF type ID describing root struct/union =
and an
> + * accessor string which describes exact embedded field that was used to=
 take
> + * an address. See detailed description of this relocation format and
> + * semantics in comments to struct bpf_offset_reloc in libbpf_internal.h=
.
> + *
> + * This relocation allows libbpf to adjust BPF instruction to use correc=
t
> + * actual field offset, based on target kernel BTF type that matches ori=
ginal
> + * (local) BTF, used to record relocation.
> + */
> +#define BPF_CORE_READ(dst, src) \
> +	bpf_probe_read(dst, sizeof(*src), __builtin_preserve_access_index(src))

We should use "sizeof(*(src))"

