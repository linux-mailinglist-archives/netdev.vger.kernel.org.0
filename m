Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BCCF4116
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 08:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfKHHO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 02:14:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59628 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726987AbfKHHO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 02:14:57 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA87DH0V021200;
        Thu, 7 Nov 2019 23:14:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8+70FxFAfUItDwur5Ep1gSPGf7K1D2wx+quR4ciLl4I=;
 b=knH9Efnp3Hex2+mDan/oBHARth+//D6VxADq1ULT+jOqMZzje3Mf4Ch6Y+0FhzK+FQPb
 0+kK3sXbOSBzd/Arrh+u/4yzRuGYL3qX6LwWX0H/Ax6uie3MXGJhS1FYdCDZW65r3KB4
 t7a++Er8g6R1gxazesA23OgU6yc0gtX0WOU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vy20j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 23:14:44 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 23:14:43 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 23:14:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHPRPVQJRnHdMfrRmPSoP00clUrvo+HNJj8bjOsEseWP8S7/KSiLOrGx+WHujzg1er4llBvf8fYunaoYWlmUsTsorOCiuFG5X92KmfjQf/fpwgHiWHHM7e2soTxfzA1SUDX6Oo5MqNZdn+w7R7d0pXxy5agrdDZvZphqgM+4VWL5ZTThMKYutyq1ikx/2ARf3GdFtnqyKmf/JJGyixvpehoFR1GKL/6wgFtPxAoxZbifeY+qkdBiHL9HZKLRUEAX48oID5Jmm1l9OWimO1H8ODPZJIG084a97H+/2eZSs+LdsXrFkqgcCcaS+Ye3DzRFew86k8ORTX4XkSqN9zdKjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+70FxFAfUItDwur5Ep1gSPGf7K1D2wx+quR4ciLl4I=;
 b=AKSKrXpS9N5yTVA1N9lA+gnvXAVO7hCTJ0VImN3WI/pgQh5hEED8x2zsyAWzJ8fiU1h9xzg72nq5DiB1v5XgmpX9CqkhQA1gz0I5xyssAR+XQZ1wC9vnbhcl2bg3LFKby2KXzq741m56d4bTBrFCzERdfg5zS8sYWA3Emf0zXlkYwOsFYlY+9qcr+BP8KKN5+wydLbXhiYA5v0nV76QZ7iUHtpQiHYQEUD0UnDLF7ddntcgv5Mr3yQykWTh/3diaQv2IlI8X1RfWCghzLnOQwt2kZbB3k+7vnO0pZh3ArTgfLbAv7K4qT5aNEAAbt0+iCz8arqhDA8a2SqEnLpfJEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+70FxFAfUItDwur5Ep1gSPGf7K1D2wx+quR4ciLl4I=;
 b=FHcw2sJMM8lJWMfE2aPPYO7WTvaGzcWMlE82xMYolqsh5g9yiG5EUdErePZcZao3eZGzsHZn5N/mYQnNS5w/SUF1tU//2VNh+NJwTrSuMOy+FBI2uaTboasydomghsJWABwdTb/04Y0wAxBpt00YmCcOP/EHHENzoQg7oli6CPM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1870.namprd15.prod.outlook.com (10.174.96.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 07:14:42 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 07:14:42 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 10/18] selftests/bpf: Add combined
 fentry/fexit test
Thread-Topic: [PATCH v3 bpf-next 10/18] selftests/bpf: Add combined
 fentry/fexit test
Thread-Index: AQHVlf+D9MZZCL0fPE6bannQA6KGRqeA3GGA
Date:   Fri, 8 Nov 2019 07:14:41 +0000
Message-ID: <812FADD8-040F-471E-9010-9973C31CCCE9@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-11-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-11-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ddd7049-63fb-4845-3a81-08d7641b5351
x-ms-traffictypediagnostic: MWHPR15MB1870:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB187039E65C710FA261E2EA81B37B0@MWHPR15MB1870.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(366004)(396003)(39860400002)(189003)(199004)(81156014)(4326008)(478600001)(316002)(66476007)(64756008)(14454004)(5660300002)(54906003)(66556008)(66946007)(76116006)(66446008)(6246003)(33656002)(36756003)(86362001)(256004)(99286004)(305945005)(186003)(46003)(2906002)(11346002)(446003)(558084003)(25786009)(486006)(6916009)(6486002)(53546011)(6506007)(6436002)(76176011)(6116002)(229853002)(6512007)(71190400001)(8936002)(81166006)(71200400001)(102836004)(50226002)(7736002)(476003)(2616005)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1870;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y58+mZ9OmjzagMMredY+T4eWUIzKAHtUgjbnDIJnsiOwD17j0tprsEDRbuAMR8BFQj3xMUw4Djk3WItxdGWC22oZTJtIAGgkVedq1nRO+CYrSyxcodU9+66wvb+QMaB9Cl16vd5KFZaEOIMFfTYx2akFEgS8UlHWcFcIchA/p102XjjsEj+bDPps4HUAzIBUJ+wZTtFK+mhLEHrNUSWD/PRoe/yCWuUKUsiahf+gOYpAUbUbJzxN3x0eJtXE7MenHkuqzCqUjZdBxJ6vIfUkKpRy9b1oXGI3tzy9c8y+YED5FW8SWyJq/i/pKuYDulWRHdyHUPEAWZR0K/laDcLUnUcX8Z/ERnZJfaj6RZoktIUKSwd/9BuWgKlL1p5Jzz5pv0i2BJf4hodO9JwtC2Frc+/P7QZV1flxquUZRxwjEm0pjO1mPG/qHoiBOL5jS3RT
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C07C4C49DC3A504DA6F5AA7B9FF1EABC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ddd7049-63fb-4845-3a81-08d7641b5351
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 07:14:41.9302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: flSwoXdl4+bpFEwk1HfiS41nzborz2sXqO9LpB/hYGG7qvEjEdMI3gHCpAFO7KRTqzLy+Ve1dNWPk+A3dN5iWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1870
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=744
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080071
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add a combined fentry/fexit test.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

