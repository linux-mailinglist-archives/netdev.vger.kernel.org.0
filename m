Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B124A118FAA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfLJSUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:20:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28328 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727374AbfLJSUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:20:31 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAIJq9v018857;
        Tue, 10 Dec 2019 10:20:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VfV+6EfnvN2QjQpNkNTR9bh9q5z+68hrlY1FCJnMQsc=;
 b=TgqEhO/ZwCt6RqeRfCQDRemiCJN+pCYATytv50MpLmXlyipkDwssTmN15TUeetZd7A8l
 EiyZ53MN6eeXL03TZIV2AO//kWuHrpiUi+BxsmuVWFH11UAPlBrLSaAS54YMlPxwydl6
 AvRVPP1AyTkWoJvwZ2yRP+lb0g0VCyM3V5A= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wt9vca1qk-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 10:20:15 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 10 Dec 2019 10:19:33 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Dec 2019 10:19:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6t2tiufCdQTTdpeBjsFugpPPwbU1zCq2vX5A/oQXKduAgN/Emf1DbNw5u5/LoIctiEBkEoGWQOZt7NKb1mIkzvPKmlqFVeR7UX6bL/z9Ikil+AoFhcEw522N77vNaGW4lZO5rU0duNl32Ci0FxXnVnOAP0U9DILrtrZ9JJujdZ94/F6xDszlrvHnq056cYcHjLI8FXPpr91vKZnEroPE7PsYsrgvtwV5gQpk8ja8VKh8HrHasn/CcyBAMrMatX78E91sKne4eSsfhI4r4DWoqeNOPRHiUs1o4VdJcfDZrrSf6SEscN33n8P7lEFxlfB74kvPXGyLNz5SUurdZinqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfV+6EfnvN2QjQpNkNTR9bh9q5z+68hrlY1FCJnMQsc=;
 b=cbp2Gs9ye4oeQX4kFSaW+Bh1uXoiH9fz9wJJr8qAA56Lg2uWkXAh44OPs/udisPNjnyGwtKgLWXvcK6NDRnC2NT5r8NgW8m3nSVrwDAe1b+bb390kB1Ir/qanl2E8MXs/DNdQqgLp8iexmFeWeM2KyRE3BYbrk79JICnaeLSUK1/WkQvPOR4PWtlIri5DTzOaFr9cE8hMWdueOZEyMmPFQO1zAkSEh1qM15nv2c9Bd5/Wf+l1WsWdzdskLwgfWb1DyJjQ+O0W9/PSm6jveXd+kHGmNwIKVFenqDv8MijCZS6/gh51TrRShLb3sZXnl6ZrCYwbq8/IBVWQ+XCZGOixQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfV+6EfnvN2QjQpNkNTR9bh9q5z+68hrlY1FCJnMQsc=;
 b=YZpSq48HHqF5rvHcevvpTgTrpINDqx/ZSEpawJb7iybSh9DbxLhbcXgmjG6jv+UJ9jbHAD4IBilRna2NFvsEcnXI1SuvQn1/WYK5nDr8MadqqdwEtePPGxauHr5ST/R4FnygRyqtBi7bJfCbs7fOEOr5fcBRgMPvg4FEYBky1KA=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2703.namprd15.prod.outlook.com (20.179.148.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 18:19:32 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 18:19:32 +0000
From:   Martin Lau <kafai@fb.com>
To:     Paul Chaignon <paul.chaignon@orange.com>
CC:     Paul Burton <paulburton@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        "paul.chaignon@gmail.com" <paul.chaignon@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf 0/2] Limit tail calls to 33 in all JIT compilers
Thread-Topic: [PATCH bpf 0/2] Limit tail calls to 33 in all JIT compilers
Thread-Index: AQHVrsHC45KQMgUrPkOrjfAD1N39MqezrzWA
Date:   Tue, 10 Dec 2019 18:19:32 +0000
Message-ID: <20191210181929.477nstc4vcccecyc@kafai-mbp>
References: <cover.1575916815.git.paul.chaignon@gmail.com>
In-Reply-To: <cover.1575916815.git.paul.chaignon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0042.namprd15.prod.outlook.com
 (2603:10b6:300:ad::28) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:85a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 435ed96e-f86e-4bd6-3c51-08d77d9d80f4
x-ms-traffictypediagnostic: MN2PR15MB2703:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2703E77DFFA24568EAFC57E3D55B0@MN2PR15MB2703.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(189003)(199004)(52116002)(1076003)(54906003)(8676002)(9686003)(4326008)(2906002)(6486002)(33716001)(498600001)(6512007)(66446008)(81156014)(81166006)(66476007)(86362001)(71200400001)(6506007)(66556008)(64756008)(66946007)(6916009)(5660300002)(4744005)(8936002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2703;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cYVWbjpQMyKAw/6Edx7N79iUUEX8gStlU4EMDO3UjlQaf/TEjyYyz8MPCGtzouJvPoPORN4tVdxOlJqGua9X61HcYHgBL8Vu/ISWtiXgIKsUnj3kRKGy9dtdIk5YR/gY454voS8+F+fgmoAmLtcZRbbrQb6z4eBYvY1Jg/0s51gZouBkfUSKxhAYj8GUv4X/itRqRHVDXkDlNpUK6IAO+YfiOIxgII2bKRZqt2761NoUN0Jq479P3x3wOWpBbGkueLEvrMUw7e+WjOgk4OQO+2dm+x3VKLpkMTlyFkhd8DC4gyp5OhyPs3A8DU0a2ljFgVgptYGnuJTrXmFOQSbhgHYRn1Z9hzG4jlpf0/DysU9/Wl6jCxOGZoo7W0slwU2/rpL1VMsS5xcm3Kphxfuc+DsVPlxt2JwiBoB4LSE7KfWU5SKNUu2Nq4nXeJ+gTKDt
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <D206D02E45A36E4E8988CC2D1418D2AD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 435ed96e-f86e-4bd6-3c51-08d77d9d80f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 18:19:32.5230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vJF3dCZGckj+LQViSf5Vd8LIryfzDyzAa7vymIPezMpR+Ka44EFciEolGkNL46p5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2703
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_05:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 adultscore=0 spamscore=0 clxscore=1011 mlxlogscore=577
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 07:51:52PM +0100, Paul Chaignon wrote:
> The BPF interpreter and all JIT compilers, except RISC-V's and MIPS',
> enforce a 33-tail calls limit at runtime.  Because of this discrepancy, a
> BPF program can have a different behavior and output depending on whether
> it is interpreted or JIT compiled, or depending on the underlying
> architecture.
>=20
> This patchset changes the RISC-V and MIPS JIT compilers to limit tail
> calls to 33 instead of 32.  I have checked other BPF JIT compilers for th=
e
> same discrepancy.
Acked-by: Martin KaFai Lau <kafai@fb.com>
