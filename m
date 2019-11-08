Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3793AF4157
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 08:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbfKHH0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 02:26:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52856 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbfKHH0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 02:26:13 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA87PJqY026849;
        Thu, 7 Nov 2019 23:25:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1UVwszho5HVMGuLRfwtq1lTDHSk3EEU9in1/CljmVh8=;
 b=SarsM7Q1MIKEHpsZwGJfvHIollyLXg9PawnwPKh6zbVenhZDqZyzKazzDLrPhnlzxjkV
 Z50mDTDyVd7IoSQaHZ8BheRVeZ/nqKlRn20GiEfk6ueYjxPcPUgIDJ1ofVRJ4e19O72W
 XAlhXcnySDwUK2I/99Dq++2D2wYAeUpfqP8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ujhtek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 23:25:59 -0800
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 23:25:58 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 23:25:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxReXVCKXOqocZML5Uh/SZ3ueXtFgqBZAJy/5EcjuCFC1o6aRB3dlLvNFcCW340Ujkb+OaE6E6yFRnYX57+wG2p14HXGCWIfEzODNOww3SWSkulepEOZxfqISdXZ40qPfjj/ohnf3sDHBNgQ9as2QaYbRYO4XuLeLoYuORPsMSqu++Adpl5QM1MdWkVsX7xuGcxAx+iVNCEZYb6UbkWdz6FTm1h+t0ww3tMZ2qhnToy5jVOLIH5AcZVcOvoIdVRQseY+qnUAYRDSDHUqeVyoiN/KyXVjaNTEEtzYXEZP7EZQPzz72tWS3UQauCpV8KZU8ljkt2ZwZCuve35hy+3+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UVwszho5HVMGuLRfwtq1lTDHSk3EEU9in1/CljmVh8=;
 b=jtGcc8wEQtKmHAms5NDscWvmTJ0rr99SONEc4YaPX3ZXbZCutcphmbpskwQpCrWMOtiQgXzImoSxGJqLaCabIhm3OuQnegvLRvjC5+JuMhqZxpV899jl1isDWuexZjmYrjgqCkkptSbIARTYomJ5/0CXkssgdFrm1HgBThfPhgaUT2X+fORWFid7Bkcjku9L/c2bnTwraDqPW6Rb/PFKea0K79MtP+JEmqmWXBMubdq5b1e2jGEcEVjQ6ySI+q93Ed+n7mil5khwcjgDCvZUPEuWF8gOmEuYPdXBCpMHOkgKLQBzALqHxUn8CqoMVXS4W8WLa2cBqvXD0w6wSKc77w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UVwszho5HVMGuLRfwtq1lTDHSk3EEU9in1/CljmVh8=;
 b=eX2jLATxJfkKv8r/AgF9v/qJ0iIHj8l29LPI6LR/AyqvMTg5ahNE3qM6dZC8EmVLk/afoW48vgE9i2B7oGDt8/gzleOnNgzzHiK81av/Vm7ZvYOBGKyODuxcCwDMCubWULe67bU6iQfk/UMyr5tamyBRrMwr1cSezHs5+X0XJ90=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1598.namprd15.prod.outlook.com (10.173.234.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 07:25:43 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 07:25:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 12/18] bpf: Reserve space for BPF trampoline
 in BPF programs
Thread-Topic: [PATCH v3 bpf-next 12/18] bpf: Reserve space for BPF trampoline
 in BPF programs
Thread-Index: AQHVlf+GTb6tNQRHF0ydCjJmBNAi06eA33UA
Date:   Fri, 8 Nov 2019 07:25:42 +0000
Message-ID: <04BE1B28-327C-4843-8E73-0DCA3971C144@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-13-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-13-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d14e667e-f099-4cce-153f-08d7641cdd55
x-ms-traffictypediagnostic: MWHPR15MB1598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB15981FD232D6EAAA7AD738CFB37B0@MWHPR15MB1598.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(2906002)(316002)(14454004)(6436002)(71190400001)(486006)(6116002)(186003)(476003)(46003)(86362001)(229853002)(11346002)(4326008)(478600001)(66446008)(71200400001)(64756008)(446003)(53546011)(6506007)(36756003)(6512007)(25786009)(256004)(8936002)(50226002)(7736002)(2616005)(99286004)(102836004)(66946007)(33656002)(76176011)(76116006)(4744005)(66556008)(6246003)(8676002)(81156014)(66476007)(5660300002)(305945005)(6486002)(6916009)(54906003)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1598;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nNYOG3vmsy8prcoA9LneAEuNhufHEhUd6UfXdUBYCCeteYfu8zJzInFxl9YALx888p4+1Q+fiJdbHNNc4Tq60rBK/RdpI85vq0wHg79bY3AaYmCE6/PcUKQkTQRHql/8QshzBmmpQp4qM44Z7K8P1oQPzA3IAMv1aHqKgVP/6grB0MZfaUerXsJ4rSJDGVev/d4vEeaY4536yT5+KXaZ5IHXFmJ/ujaPKsOZ7V3ttMqyG0BXKOjmVuwcz0wnlMwZwgbA7awk3eS52QoaZ9bnCaoOUK+NndGdhlgTvZF0F4yrH4kqlkttZHD0VI2Gaj3eREB6nqhyO4k+qlWRAnFCFYCszl8jvQpukysLXdDZX2CGFRWHc1s51F1imN3B/Ll5iL38p5F+PcmLIKooxcY+6Q3I7tT3ZMVLAkBtrhYcvVz7WhLDRSbbCcgP1Rn8zGiY
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5611BCD5CEAB9844A3B165AA7867C1CA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d14e667e-f099-4cce-153f-08d7641cdd55
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 07:25:42.8728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FsmeaFJY+eR87hHm2anS5r0JYvFlUGYDtfQhK1xm6FrqL6zlCiYdJY0FIeGSZlm83dZ3LvHiSSSzIEF97Ttr2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1598
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 spamscore=0 mlxlogscore=565
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080073
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> BPF trampoline can be made to work with existing 5 bytes of BPF program
> prologue, but let's add 5 bytes of NOPs to the beginning of every JITed B=
PF
> program to make BPF trampoline job easier. They can be removed in the fut=
ure.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>


