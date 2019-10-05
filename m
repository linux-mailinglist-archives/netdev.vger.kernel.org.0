Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE57CCB94
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbfJERK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 13:10:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8290 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387573AbfJERKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 13:10:55 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x95H9M3I022177;
        Sat, 5 Oct 2019 10:10:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=96SeZoE86tvuTnuojwMVXF+rUncqGODn3dSLAfE7lMo=;
 b=hvzNI/dVHVoBYj+kfV8Ya4QKXGVRM7h1GxsxFkQ9wQ4JNSFnnU00WhmiiKqi2m1p85HY
 ZCyeN+sIfubQYc/bnuGc/4N2naydX6P5bPJ+Dn/kahqnhEDfw5Bu/g50TT2eBWUvfDtY
 rpkoePDcaYf6xAuIKn9H525xUBp+StHoeg4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vepp1hnh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 05 Oct 2019 10:10:41 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 5 Oct 2019 10:10:40 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 5 Oct 2019 10:10:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1UoArMMi04wZUAQxu5LEo1H52mL8hYzpXPNWs8yrinUJYzmkQA4C9OGW282K3t4+saIkiyPn5wEZ0ZFGoG9VJwSVGiTuLEMjBWorHuz9xRdcqMiszf6H9CEMjo6rQP3yO3bRvNmEDwsoJXkxou7m+X9vfw5OzqFQCZvLrv+fGhQ4hY/nXwaEm7uYjXEga3qqvCgaGk9vWh6I8hLyasy3sk1Nz9qOMpuiLy+go/m2q3QnEfT5ecFOatf90yOFlz/H96EDI598HPmrt+XjqlmuszfF4xYs+wHIfs+lGy9VE2LtsKwlFeNuZjP4Xih+Xj3KFzRyMN9jrs6eulv1pNsRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96SeZoE86tvuTnuojwMVXF+rUncqGODn3dSLAfE7lMo=;
 b=LO6CsKdNEfXh44kV7OIjX/R55DhDPe5oZr4p4RRsm5vSKk1zxWNkSOquTUbWqC8TNRscW5h4TbsPNNYBP2X2aXs36FzSEwD83ePN0kXhH0KK3+v4r0YE7l/6Ob0zkpiDJYd3Xy+OaEvkNzthrCxgf6QxIx9B6RYPhcfcEG76vk0oPva+DUKnVweeWTcJ4+p8EV0fOyxOYO7L5J/Gqc1dK2x/GIy0/+RBqzNqLinHAhut7r+YA8uueemYPcLBJgSN4D5viNejAAcCDOhs6rY4tqd6vOHfY/6rcdK3k0Edr1EngvGRzBy8hibXdPXN7zS9aGxzFrjj97s7Qu4PNGpepw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96SeZoE86tvuTnuojwMVXF+rUncqGODn3dSLAfE7lMo=;
 b=eQRKtFWh2UmZfZZBtT6t5O7H9cSHingpmEkIdeKldxBJ6JktG0m6v1WhkahCPRHZJ4GiL2DPG8b+foieUMh7mOVs6qCb6AXVZwBeM9ityxaRnwYdk9OqD6EpgkSUvA5gyH+p3cvXYfDy++qTc1IMH6Gujqt53b4Cw518xfhKGBs=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3175.namprd15.prod.outlook.com (20.179.56.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Sat, 5 Oct 2019 17:10:39 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.023; Sat, 5 Oct 2019
 17:10:39 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: auto-generate list of BPF helper
 definitions
Thread-Topic: [PATCH bpf-next 3/3] libbpf: auto-generate list of BPF helper
 definitions
Thread-Index: AQHVe1Lc+C9eeTHkrEenNHp85oWdn6dMSPSA
Date:   Sat, 5 Oct 2019 17:10:38 +0000
Message-ID: <b0df96f6-dc41-8baf-baa3-e98da94c54b7@fb.com>
References: <20191005075921.3310139-1-andriin@fb.com>
 <20191005075921.3310139-4-andriin@fb.com>
In-Reply-To: <20191005075921.3310139-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0034.namprd21.prod.outlook.com
 (2603:10b6:300:129::20) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::2662]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a892096-68ba-4ee2-2d75-08d749b6f1d1
x-ms-traffictypediagnostic: BYAPR15MB3175:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB317526250F344CCC9A72956BD7990@BYAPR15MB3175.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:127;
x-forefront-prvs: 0181F4652A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(346002)(366004)(396003)(376002)(189003)(199004)(110136005)(6116002)(66556008)(66446008)(66476007)(66946007)(2906002)(64756008)(6436002)(81166006)(4326008)(305945005)(316002)(7736002)(81156014)(4744005)(8936002)(31686004)(6246003)(8676002)(229853002)(36756003)(102836004)(386003)(6506007)(53546011)(25786009)(14454004)(478600001)(186003)(52116002)(256004)(2501003)(76176011)(486006)(86362001)(54906003)(6512007)(71190400001)(71200400001)(2201001)(5660300002)(6486002)(11346002)(446003)(2616005)(476003)(31696002)(99286004)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3175;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uh+JQSCZ31qIDej+jradDzG3r182/ZLP8BOG28vaEohncpWuORA3X+iMbSQj/Fz/aN3nqDyf/lw18BAnE++yWkFO5x+AK6SO664l7DKoDHyoPIa+06xBWTOdlnemYxZTaljuQuGP5s2BHmmZqtXumeicOGvjBiKtbz1Hiu5Bt5T0mm7Lgu/WUBkgZslFH86QhN3e4uIm7M6aduL/0kkP8eZ2g/ZanHu4ucWNaR4uoXsE0YU/4EOinnvPTDROu7GGKsZSIKGPZn3qrddWqz/NS9ATUimX7CUzEe4pUFVTdRpuNz3tD7sOtw3O9+rJM87FW29Vk7ftN/oDKDdE1ZFkdQEtoO0HYuBwNbZiGuFPheh20XG8Qn/WlH1G3AZFGZU5A0Kj2kMuglDOTJDh9xgjJ3iOKXaglGX+A8q801ZMrvM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54B7EA27F48A4B419D3444C84CAB93D5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a892096-68ba-4ee2-2d75-08d749b6f1d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2019 17:10:38.9086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vsBvpNgrGCmqqL40sWIUL2/ydJ6hegIGkP/XE8XmNEUubBnsgUW35+RjNHQTwTsf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3175
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-05_10:2019-10-03,2019-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910050173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNS8xOSAxMjo1OSBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBHZXQgcmlkIG9m
IGxpc3Qgb2YgQlBGIGhlbHBlcnMgaW4gYnBmX2hlbHBlcnMuaCAoaXJvbnkuLi4pIGFuZA0KPiBh
dXRvLWdlbmVyYXRlIGl0IGludG8gYnBmX2hlbHBlcnNfZGVmcy5oLCB3aGljaCBpcyBub3cgaW5j
bHVkZWQgZnJvbQ0KPiBicGZfaGVscGVycy5oLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBBbGV4ZWkg
U3Rhcm92b2l0b3Y8YXN0QGZiLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtv
PGFuZHJpaW5AZmIuY29tPg0KPiAtLS0NCj4gICB0b29scy9saWIvYnBmL01ha2VmaWxlICAgICAg
ICAgICB8ICAgIDggKy0NCj4gICB0b29scy9saWIvYnBmL2JwZl9oZWxwZXJzLmggICAgICB8ICAy
NjQgKy0tDQo+ICAgdG9vbHMvbGliL2JwZi9icGZfaGVscGVyc19kZWZzLmggfCAyNjc3ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMjY4NSBpbnNl
cnRpb25zKCspLCAyNjQgZGVsZXRpb25zKC0pDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xz
L2xpYi9icGYvYnBmX2hlbHBlcnNfZGVmcy5oDQoNCkFwcHJvYWNoIGxvb2tzIGdvb2QgdG8gbWUu
DQppbW8gdGhhdCdzIGJldHRlciB0aGFuIG1lc3Npbmcgd2l0aCBtYWNyb3MuDQoNClVzaW5nIGJw
Zl9oZWxwZXJzX2RvYy5weSBhcyBwYXJ0IG9mIGJ1aWxkIHdpbGwgaGVscCBtYW4gcGFnZXMgdG9v
Lg0KSSB0aGluayB3ZSB3ZXJlIHNsb3BweSBkb2N1bWVudGluZyBoZWxwZXJzLCBzaW5jZSBvbmx5
IFF1ZW50aW4NCndhcyBydW5uaW5nIHRoYXQgc2NyaXB0IHJlZ3VsYXJseS4NCg0KT25seSBxdWVz
dGlvbiBpcyB3aGF0IGlzIHRoZSByZWFzb24gdG8gY29tbWl0IGdlbmVyYXRlZCAuaCBpbnRvIGdp
dD8NCg==
