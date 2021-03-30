Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37E634E110
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 08:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhC3GNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 02:13:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229468AbhC3GMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 02:12:46 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12U69lDr016133;
        Mon, 29 Mar 2021 23:12:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ey1yZuncpQdxpyJlGW/zyyK2CG7pu1H5KS5610lYKeU=;
 b=oS/I/4ahffIBCiosEL4ZVkNhTya3FqTZojE5MzCM2iRgYzKVXF8Yb0X2oCwgPjBXXHNr
 KCgta7FdWqln2ywkoobb4cARUzhFAxikoB0i+9uHBoPS8+qRR2B82Xvz5WhJ96Dq8In5
 RW0+vZNerQ/UQUBL5fSzipGZesamYx+o7v4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 37kuvm0mtu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Mar 2021 23:12:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:12:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFlmTrd+DLy1onVx5O9SgSf4i6gzrx4CuoKQyY/qy3ZoPKzINNu4wVlVOKdbKJjHBOCpIl9qnt9hMBtufJgKvpQ+K4VsrcMm97rGIDAMgSlBmZXUQRBHQvaUBM85Vv3BnmG15gTLn/bqDcil6mqD+frcd5dmwE+rfKwtMYvW6Td1nKsZk8t5Kwu6Z8SzdJw+JGZ73z7UuyjT0wH2pH1awXeRvoHWNCydxqifCOLsNiDjo0oBmVvkPUjy5om1paYlXfvLsZ7GcTOVWcQLuQ8JDzkB6ft5xxMd6nm9hCQ5Tfgb6wMOOIDiH0fTuPjOzjYdlnnEMBaKVCsTwDqpllV9Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ey1yZuncpQdxpyJlGW/zyyK2CG7pu1H5KS5610lYKeU=;
 b=gXEFY4Td1g2hTk8ynd/ZxKP9DZO6AVBRUln6H07qwIatTbOa7wTpFHYmU+1+wvm+e0kg4i7I4uk3QBqPXGO7xzfqnukfR71qdvURsSJF9naaG6Gxxjvs71dM75o49b+BNImHWzxJw3UuCLUtiXFR5NxINPcG7huRfmG3L8A0kxAnGsf1he4LWq1cj2c42kjED/mpmC2EWGE4EmB6hFy8r7Glzv3Huc59sxC7F/pbIfvfTIvo9cLTdtwNxe3ocArHaYSgw4MVppbg7cM4WvvLLj8syq+LgoqreiGanegMCd3Onboozaztpq9xj79TA7Hcth8xbfpdqTInokjZWUEwkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (20.178.238.12) by
 SJ0PR15MB4392.namprd15.prod.outlook.com (13.101.76.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.29; Tue, 30 Mar 2021 06:12:30 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 30 Mar 2021
 06:12:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [RFC PATCH bpf-next 4/4] selftests/bpf: Test that module can't be
 unloaded with attached trampoline
Thread-Topic: [RFC PATCH bpf-next 4/4] selftests/bpf: Test that module can't
 be unloaded with attached trampoline
Thread-Index: AQHXI8VIiPF+jGZH7EqDNx8VLWF/F6qcD8aA
Date:   Tue, 30 Mar 2021 06:12:29 +0000
Message-ID: <2771EF17-3414-4E46-8072-EE265E31A391@fb.com>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-5-jolsa@kernel.org>
In-Reply-To: <20210328112629.339266-5-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:6e51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e91187a-9ca8-47d4-67ad-08d8f342cca4
x-ms-traffictypediagnostic: SJ0PR15MB4392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB43923F9DAE499F399F5F2B10B37D9@SJ0PR15MB4392.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JuGTG8s5Y2ia9e5kS5DP6sV4hON3W7ThX4efBY5hzD+hjqU5r8z8cs5hWFYMr/+2iyyvUS5oh38jIifIraO/Eoh80fqf9QBKHUs93iLgDu1+PqK3QQNVIO5j+GqJu7qgza4dyOSWbiGMlEGf9RU+e+n3dDcQGeCVXFdCbpU46IKQJ6voZMwYsCNmtIAlJ9vRdS3k7iZsVGHftyn17KSJD1SyS18PKLGhKz1+GAz8LbvrQ7uHfHZ3bw1oqaSZQD5g6kJKpAvuKUn5MNkZTRw/5z0qCDqvquFra/cvRNp37D6qaIC+fTN5WqPsUoED9hPASw8EdxAKXGiNTtlO9E3aQaa8vyJoaIJXlqVnswxxUY8yeXN9FYWDGYtWmp8Fd0d3x8GevGF7Phas5tWUn9e1Ghts74j4H7TPOSD893gY939R5ZeF1NjlFWgkjlDTp64/QCGDW7vSCI7hMd4fEuBQmAZu4K6wzhXX0r9/IIlVlk83o2Wv1hzj0jJ0SE8PjJInGH7z8b93XN1tlLMzdZIKdLBE80obIfF5xhXsUJ2pSA8kOqb0VLzTecsZMhLOjys/a3yiVarDgxoluNlS0aTbG5jy9XdcuPSzPzNeyHVu5jLJm+BlDPPUWcOAov9h4Rydt2L3whYNYnY7mXs4LiGNbzur/kW1+akBF9qtjjJ7nuVctovN5u5yvZp9TtufQmNB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39860400002)(376002)(396003)(6512007)(8676002)(71200400001)(36756003)(5660300002)(83380400001)(6486002)(33656002)(478600001)(86362001)(2906002)(66946007)(64756008)(558084003)(66446008)(4326008)(66556008)(2616005)(91956017)(76116006)(6506007)(53546011)(54906003)(38100700001)(8936002)(66476007)(186003)(316002)(6916009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?eowXAscGIfGyqWSQZHaGwrGTezwM3Rkc3kw69SiUilaHAkJhGez6BEjOOt?=
 =?iso-8859-1?Q?Aq9acGrMZczENeNS79zCC4bmXrWVwk0yfdJRzf1EmEBes318wJsGNM8E2z?=
 =?iso-8859-1?Q?d1mCBUxkbniqP02NEj/wLjzAldrWT+QA+1l2rRbqhTNMEWiJsAdxceoiXM?=
 =?iso-8859-1?Q?XQhA3ZglEKJeqefV2M/NiMKho/ZwXgNcEgLLrNQDvv2duU53GWT/0IhjsN?=
 =?iso-8859-1?Q?PKXjOnREP1jLkRkyFcGW2jWHLbQ7NQt0YRM9Mw8ozjbI8NAe1F1KZgjYMm?=
 =?iso-8859-1?Q?iodtE80mFJAf7coOIGi/RJo0LV224W2+G5RJsE1JK4JfR0Bgr9/yPa6La/?=
 =?iso-8859-1?Q?NlDURKWb5jSWZTU6Y+1UppkmZz76PGwFPN7ZGAJzNlzR4B2Vaehppy9Gda?=
 =?iso-8859-1?Q?v9mt4qK7LUjt+srqNhLm8HApdkKDwGUdh7Cwc25pukp4l9d5zeD4N7FWAu?=
 =?iso-8859-1?Q?QzBjngnGGB+pS9wINMHyuwL4gTsCMnT8Eko1BMqPWQOH6nfBnFZVhXPzWi?=
 =?iso-8859-1?Q?JNnG8BeGqDTXJ51Zh/FxpD2qUL2blSbWVF33TY/l0XwbBXOUlS4R/jVvLp?=
 =?iso-8859-1?Q?iIljzYE3vmpKdIyeFKI6FpfmwVqT2DGYHsBvKNeJ4vho2x5YiZPDbxoPzH?=
 =?iso-8859-1?Q?P+79cYgrwnJY2iyevqXUJPMFzDq7f5t++pAtZqv9WK399R14xIpOE1QFMr?=
 =?iso-8859-1?Q?9ONHaImOFgtBw6OKqLBvi9e/OMQDV+mjGC5tu/n33Gjw6RHWTGTZ33Bd5O?=
 =?iso-8859-1?Q?CQvCOGTTtWUhU2kse8QDaF2/wPNoZRt6u9aK9/B3gUQ3ZzlBqhxDB6AQbI?=
 =?iso-8859-1?Q?T1eWxrz66NUbjGEoPp/oudG5wUJGgeE8n5OEKk2MJLx9d3FpeFADsQNUn3?=
 =?iso-8859-1?Q?LNaILw+wzfefyxOPZ3Y3PXox/6bQTYe08u5xg1vJsGTZXyBh4V1rOR23pm?=
 =?iso-8859-1?Q?oIc458H6Vl/f7SwYhs4pWkFLp4Q0egam3oPrv8phwlsUjvT0EyorIqOMiz?=
 =?iso-8859-1?Q?O7ZAKHT7vpFuVPlYTdQcRFKHdBe1T9lKfO6gyI3xV3Y08GPtLZ7dKYQRFP?=
 =?iso-8859-1?Q?kkQvlI3g0k6gec/2+l+KrqDs0vNOnG7zmoiSYPWMdECZVWjyFs5swllZIZ?=
 =?iso-8859-1?Q?a6WoIRehZnxUwdCWuamdlRy7H+LEYlIrD7OLqv4bTGwjuNObfMKgDjDKub?=
 =?iso-8859-1?Q?A5yEym48hJwvPlKa4mGHaYMtRBEffHIgHwQqLy5xTacxQoxgGzCyCJcYmy?=
 =?iso-8859-1?Q?ygWzB78sMDXEJ9Jds8M0p4VgCYmHefOCuWEkiVNs64kZCjy7O2fBIYd4Ro?=
 =?iso-8859-1?Q?qxqcH7JKiGKdrYnZQG2jco+CQNv4D4bOjLrGlQRUmsYqJnFUw36/wwLva5?=
 =?iso-8859-1?Q?unZ+lzgx3MuZoWs6sMNbcl/Me37osALJlY8hZPlgZK4/urJHA+1IM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A360610920FEFB42BC690E42035457AC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e91187a-9ca8-47d4-67ad-08d8f342cca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 06:12:29.8223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J2KcQrNoYDdR5UjoJYEvsvfnIrDEaq9KF8reIePlDWST4c18uLNRSWBmmwjHT1RnVPe07Bl/++0mpuVEDW12VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4392
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: jKIATHB7KNC68NjQxt4yTEEP2s8yhZpz
X-Proofpoint-ORIG-GUID: jKIATHB7KNC68NjQxt4yTEEP2s8yhZpz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_01:2021-03-26,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=825
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 28, 2021, at 4:26 AM, Jiri Olsa <jolsa@kernel.org> wrote:
>=20
> Adding test to verify that once we attach module's trampoline,
> the module can't be unloaded.
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

[...]

