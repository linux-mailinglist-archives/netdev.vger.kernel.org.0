Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 085FCD812F
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388151AbfJOUj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:39:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63226 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728710AbfJOUj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 16:39:57 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FKdavn018032;
        Tue, 15 Oct 2019 13:39:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cWn+6fux4mjkN1QciIcQQzw+sXoVf5cT0Q5WYxV7F6g=;
 b=nMPvWLXUHvYDe9xt1inlyqDE4QkND5psSPx1uNuiUOvEnhxT0rHJof4+9sb7uMZV+4Ya
 iYsk0fykGQ+VWJ44ExcioZtqlajAWFEFnO351q2+5eGneMC5V9B3SqjqnmxfwYkJe/Qk
 CjFsFHNfdUjSJcpHuKB+aj5c3hYJ1xwSC7E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vn1er52uw-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Oct 2019 13:39:40 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 13:39:37 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 15 Oct 2019 13:39:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCvbznnAK66Y22bayA7Jz4ANHG7HEBBVkexHeZMNVWl9R4ieVLbYtaR6Kg6Ejl6BfuW4J6wSuAQiRDpMoqMg6Svz0/T1xGaQsjlyabGNOJwpk2rzs+RSSZrVgLv6eE5lfzKh6KC337pPyG2fKbHywO/4jdD9eH6KQvlBGVh/7oOID//fZqh7UbomI/PUNXXIGAG8vfJg1pRMsElr9BfN4Mg3XfJ0b/J2nJuQC+P6lUzdlRt6jlmKoAQvr2oWSvl+BSBB71Qef9XlRId/v6CR1Df3St7kZ6ZwTxtOwJoz9P/fNV2TyTM5MqezFNOu7ypYuzk1vuD8mT91VUWhz3l2DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWn+6fux4mjkN1QciIcQQzw+sXoVf5cT0Q5WYxV7F6g=;
 b=Qb8Km0bVRq3y198Wguq1MB52pBALrvDu/HMuEIslx7pEkx9RkdBIGzyayHHkB0iIOBZEsw+R4MsOwYw56Xx9hnu6fXMBr8EgOtWJQSVZgr2/XD4RwVY7aFUzPulOtxZBIz2hiiKiyYRghD0zar7A6gR8fFOpBKL+zd6qTPglu5IH3gKH7sjQpzsbuWWhH120b+oaBoG0GDHQBXxdyMzP7uFLvtREJ/bRBpXpUOD+Yt8P9wUMKeoy+uvHmvxJP0inmG/YJ5+9xDG0fXm4wbgSbYDrbJzqhGWtTM2mFyKXml1z3JhsfJAdFKrKLfrhxqTytSqcuqb4+pf1xcSOiTDZ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWn+6fux4mjkN1QciIcQQzw+sXoVf5cT0Q5WYxV7F6g=;
 b=aSXXwSEn1tUOcMEPri1DSe4T7n6cRq234ZpNbNRU8fk8ZPw62ew4Ie8yf4mQ8jC75GbdQMn4lCcMXFbVJ8gKeIq2pyuiGMWpHsPgoTTVeuSw/50V/J7WjcvtpFPbSV0kWwpjxPmny76HyQuLmVWjdSAyYuGQcLGJpgY8KMTpgjA=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2800.namprd15.prod.outlook.com (20.179.148.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 20:39:36 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 20:39:36 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] selftests: bpf: add selftest for __sk_buff
 tstamp
Thread-Topic: [PATCH bpf-next 2/2] selftests: bpf: add selftest for __sk_buff
 tstamp
Thread-Index: AQHVg4bHANs99ikQ2Em5LUkXJgbNJadcKj+A
Date:   Tue, 15 Oct 2019 20:39:36 +0000
Message-ID: <20191015203933.fmq3miyehw64henn@kafai-mbp.dhcp.thefacebook.com>
References: <20191015183125.124413-1-sdf@google.com>
 <20191015183125.124413-2-sdf@google.com>
In-Reply-To: <20191015183125.124413-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0059.namprd17.prod.outlook.com
 (2603:10b6:300:93::21) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e6c4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41c133f0-27f4-4a21-bb6a-08d751afcb33
x-ms-traffictypediagnostic: MN2PR15MB2800:
x-microsoft-antispam-prvs: <MN2PR15MB28000D586414278F5704F49DD5930@MN2PR15MB2800.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(396003)(39860400002)(346002)(189003)(199004)(66556008)(64756008)(6506007)(476003)(9686003)(486006)(6512007)(478600001)(71190400001)(81156014)(81166006)(8676002)(6246003)(71200400001)(6436002)(229853002)(54906003)(316002)(102836004)(186003)(52116002)(66946007)(86362001)(6116002)(386003)(46003)(66476007)(6916009)(66446008)(305945005)(446003)(11346002)(76176011)(7736002)(256004)(2906002)(14454004)(99286004)(6486002)(4326008)(1076003)(25786009)(8936002)(558084003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2800;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pIhwQA9IPbq1axIExpqyc7m9xfTv2wpQt+O1GoaZ988dNdHwt10gL50ChVX0BQKpFB5KvrIqezeRLkWS9mZ0VFbhMHVLkYkIQ/ikCbEYX6n9IWo1w9QA4bPuwffEVV5wYqRofryBh3wglVwHVoInw7FQ6DnWcYJ7dmA9rsvFjzqSbVbKJlAJywwM1EbBcCGJNGuQg3ZSPbkm1Mblums5qKDmwKO5BSUEmSLZ3JuY/7pGQA19tBtErJnRqIrvZjscaRBWFLPGqWasHiC9LpPv0G+C44Wa+J3CphmAJE6J+VR8YTKA4uKBRgNPRtgxmRevyGh299rPyX68aEKGi+1FaAoBeEaIKvkW8NXKxRqCdMjc73FNl1e1yU7cPqu+AQefyYZJmPEnA4jK8i576o/u3/NKix0Hz9W/ttD3Epvk5dw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A1F88EBB908B8A458BB9957FB5DE59EF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c133f0-27f4-4a21-bb6a-08d751afcb33
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 20:39:36.8035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i6o+dM1+eLM7v9Zu8nZt4SZKoWH4F+1W1sFj/DmrcSnsBIrEAa3ukfc7U284Fj6h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2800
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_06:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=449 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910150177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 11:31:25AM -0700, Stanislav Fomichev wrote:
> Make sure BPF_PROG_TEST_RUN accepts tstamp and exports any
> modifications that BPF program does.
Acked-by: Martin KaFai Lau <kafai@fb.com>
