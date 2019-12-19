Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE21A126FCB
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfLSVix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:38:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53562 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727338AbfLSViv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:38:51 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBJLaGi6019656;
        Thu, 19 Dec 2019 13:37:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FVynSkTcKoqCMEbhWdJ/SlcXCqH7P5ot9qXh07Qgy4s=;
 b=otBDGEpXIfXxITVdq/nxwnVFzZHodQs0Ko/33j8ajvKSogsJMUarml1OBkFhPjic2AQf
 MQEU3tqnCKTofg0dvKCqQzQSIyAx7/q8WO9ow/Xv7I1On7FOVkX299N3UDpbTKbeeNQd
 o5aVkgNqYElcMD4QEqdwN5p1QTL2/PEsWuo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2x0as6jagm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Dec 2019 13:37:36 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 19 Dec 2019 13:37:36 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 19 Dec 2019 13:37:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYVh8smOlPf4+SAEVCqz9rPsybJPDJR/AO0ucBTObW9+MS6XSbk1i68nLl4Z78apP4Z5OuJ6PetHNufkdgGzY1Or/QSNCd1UNjwrjelfWYMmqwZJFtpJ1yt/TeiBFfiP4uz7cEjHRwqlblsF5L/8MX5aync3SW77HF5gRhMmaiybhDrGjkGdehuSlopcYDpan8lfWia97uOX0zQdH7LARIcXj/shP84HpvUb++0Q1Q5RcSZWgYqMHkR+IBalC7+Lopl4+O4fyQ9XHAIH0Xl49qu4NBsu7F3R6p1SXJ/jx5XpQ4UCvI2w38SW0q9VUth15f59S4URFH4zLdLr6F6ZRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVynSkTcKoqCMEbhWdJ/SlcXCqH7P5ot9qXh07Qgy4s=;
 b=cJLwNBJhiv++bQzaKkM3Of5J+q8rpbXMPYVtewrdwfjx1t2Qc97jgY2XxIqxfaIY5v2KBrQc0N5RYI6B+mGK0bBqekIV9A/Jf3TEccNMURRB/tJMY/DqpRo4MMMLj+utFmtFCoLzfq7WPEc0oSYHNnAW+7hhyQhUtXSCjZ1ekq5l02woUXAmwvwErZXKBPdAb99WTm4uBiJrZuzaHKEEoJ82ak2HCSnAk+q0UdPIhFl8gQ/Jwk5LRe/GW8Ria8cm2RkFWs/0m7jjbCwSWdirXKy02LfuaSFHbHkVeFRwWdlawvjwBdkR754ZwDNKOqNxkRdOFxvv2xd8tNh0CGS92w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVynSkTcKoqCMEbhWdJ/SlcXCqH7P5ot9qXh07Qgy4s=;
 b=AH+N5AmirivaqpldPHv0mlFloLpQcwaQxnpBe65MIk7u7dqzkhX63dtBKcs39weszbf2yiTxb9l8q7xanoZR1MSlNe/NnxQpjb2vovJ3vAUG3IRfh4AX2Pfq7Mm5oZ8wY0I3Ur1jdMgAFHsFjm3D9VbkuDrG93X2xMeKeRHwMo0=
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com (52.132.151.24) by
 MW2PR1501MB2122.namprd15.prod.outlook.com (52.132.150.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Thu, 19 Dec 2019 21:37:23 +0000
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::bc29:7a13:8423:1e00]) by MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::bc29:7a13:8423:1e00%5]) with mapi id 15.20.2559.012; Thu, 19 Dec 2019
 21:37:23 +0000
Received: from [IPv6:2620:10d:c082:1055:817:11ed:82a6:c24a] (2620:10d:c090:200::1:588f) by MWHPR2001CA0005.namprd20.prod.outlook.com (2603:10b6:301:15::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Thu, 19 Dec 2019 21:37:22 +0000
From:   Julia Kartseva <hex@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>
Subject: Re: libbpf distro packaging
Thread-Topic: libbpf distro packaging
Thread-Index: AQHVUUC6mSeRtrJxpEmiNjup7x1PAKcGJtMAgAJfWYCAAG7xgIAEG0SAgAIlyQCAAQdFgIA0IB+AgAnWI4CAAoD4AIAFJS2AgAeVF4CAZVeOgA==
Date:   Thu, 19 Dec 2019 21:37:23 +0000
Message-ID: <824912a1-048e-9e95-f6be-fd2b481a8cfc@fb.com>
References: <20190821210906.GA31031@krava> <20190823092253.GA20775@krava>
 <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com> <20190826064235.GA17554@krava>
 <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com> <20190828071237.GA31023@krava>
 <20190930111305.GE602@krava> <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com>
 <20191008073958.GA10009@krava> <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com>
 <20191016100145.GA15580@krava>
In-Reply-To: <20191016100145.GA15580@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0005.namprd20.prod.outlook.com
 (2603:10b6:301:15::15) To MW2PR1501MB2059.namprd15.prod.outlook.com
 (2603:10b6:302:e::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:588f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbefde8d-1e4c-44b7-a6ab-08d784cba237
x-ms-traffictypediagnostic: MW2PR1501MB2122:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB21227163A10C86506223FEAEC4520@MW2PR1501MB2122.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10001)(10019020)(376002)(346002)(39860400002)(366004)(396003)(136003)(189003)(199004)(6486002)(5660300002)(4744005)(7116003)(66946007)(186003)(316002)(16526019)(36756003)(86362001)(31696002)(66476007)(66556008)(66446008)(53546011)(2616005)(52116002)(478600001)(6916009)(81166006)(2906002)(4326008)(3480700005)(81156014)(8936002)(64756008)(8676002)(966005)(71200400001)(31686004)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2122;H:MW2PR1501MB2059.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sjsNqg7jXjThQKH8KoqPqJZ9yiFTrhF8Rn0xb2jkmnW0O6+xDaIXFxrXG9uus0A9N/GwuVbxClXCHT8bq0352weVX64shd1MC+t4a1ksX1fSw/F1yX+1CQJXS5NWV2Xpu0iwiLsX12hIuVjhaaGQApD73VFsNh1pCFc8FoO/rvQ6xNCucIZIXJjhlApFELeDpSEW/a/mneKE4BmMm5j7xpsWl4ABAgzJJRfiRRReM1RXXhLeaqoT4+lh45ezdYPO2iykUw9rdaDbFFXEBzVgLEKb60lNWbHm3kdwEwraujlKxRkrOQRN8AFKyHdP5mhWOCV3MDI0hHUB8dDc262Asq/SF5K0i5T5PDfGBtnCFPu9UL+OJfeWkwLGQqZW0jN0alZiCmoU9063WRaYncPJ/u/WI+6Ee9YAEbYrW3AdgtrhnM9csV6Q3m0lvULnb9hffEQWKq10x6np9xyB1Fo5cqrPE/B8SaUTId0bYXHLSdJISkaItOihaBLxh2N1nV6gtUEJBcLmPM6hpj5yZQ5zjI4wUyNjl1NIsR0lVfjW00k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C96E2CE58C7024AAA71CE6D87B333CF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bbefde8d-1e4c-44b7-a6ab-08d784cba237
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 21:37:23.3576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AVH5+Xxn+6RT6682YSyDWzT2puXYtjGOfM/E6HaQtgA7Pbgs5bEuFFj91WJXg9YM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2122
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_07:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=855
 adultscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmlyaSwNCg0KMS4gdi4gMC4wLjYgaXMgb3V0IFsxXSwgY291bGQgeW91IHBsZWFzZSBwYWNr
YWdlIGl0Pw0KMi4gd2UgbWlnaHQgbmVlZCBhIHNtYWxsIHNwZWMgdXBkYXRlIGR1ZSB0byB6bGli
IGlzIG1hZGUgYW4gZXhwbGljaXQNCmRlcGVuZGVuY3kgaW4gWzJdLiB6bGliIHNob3VsZCBiZSBs
aXN0ZWQgaW4gQnVpbGRSZXF1aXJlczogc2VjdGlvbiBvZiB0aGUNCnNwZWMgc28gaXQncyBjb25z
aXN0ZW50IHdpdGggbGliYnBmLnBjDQozLiBEbyB5b3UgcGxhbiB0byBhZGRyZXNzIHRoZSBidWcg
cmVwb3J0IFszXSBmb3IgQ2VudE9TPyBOYW1lbHkgcmVidWlsZGluZw0KRmVkb3JhJ3MgUlBNIGFu
ZCBwdWJsaXNoaW5nIHRvIEVQRUwgcmVwbz8NCg0KVGhhbmtzDQoNClsxXSBodHRwczovL2dpdGh1
Yi5jb20vbGliYnBmL2xpYmJwZi9yZWxlYXNlcy90YWcvdjAuMC42DQpbMl0gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvYnBmLzIwMTkxMjE2MTgzODMwLjM5NzI5NjQtMS1hbmRyaWluQGZiLmNvbS8N
ClszXSBodHRwczovL2J1Z3ppbGxhLnJlZGhhdC5jb20vc2hvd19idWcuY2dpP2lkPTE3NjIyMTkN
Cg0KT24gMTAvMTYvMTkgMzowMSBBTSwgSmlyaSBPbHNhIHdyb3RlOg0KPiBPbiBGcmksIE9jdCAx
MSwgMjAxOSBhdCAwOToxNDoxOVBNICswMDAwLCBKdWxpYSBLYXJ0c2V2YSB3cm90ZToNCj4+IEhp
IEppcmksDQo+Pg0KPj4gc3lzdGVtZCBmb2xrcyBwdWJsaXNoZWQgbGliYnBmIENlbnRPUyA3IHBh
Y2thZ2UgaW4gc3lzdGVtZCBjb3JwIHJlcG86IFsxXSwNCj4+IHNvIGd1ZXNzIHRoYXQgcHJvdmVz
IHRoYXQgZGVwcyBmcm9tIG90aGVyIHJlcG8gYXJlIGZpbmUuDQo+IA0KPiB5ZWEsIGFjdHVhbHkg
Z290IHJlcXVlc3QgZm9yIHRoYXQ6DQo+ICAgaHR0cHM6Ly9idWd6aWxsYS5yZWRoYXQuY29tL3No
b3dfYnVnLmNnaT9pZD0xNzYyMjE5DQo+IA0KPiBqaXJrYQ0KPiANCg==
