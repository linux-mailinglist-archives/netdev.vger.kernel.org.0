Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FF0125183
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfLRTLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:11:08 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38148 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727255AbfLRTLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 14:11:07 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIJAmnI001350;
        Wed, 18 Dec 2019 11:10:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CfxV14fwiJyvhGGViO0czMb/UNoLP62lAaFQ7+j7Mgw=;
 b=UrAwc4ZtZcKhdJ6daFgQk03XUjgs8yFb+RYr3ykM1dcbfciqnzBGKd4ut7+3mowOVfFi
 gaaYpHKR2nBw+osPd15JR5bxPS/HN0pgJ29rRAUKAy+3GZentZr4Vttri6MYOI0eTDD6
 q1da2NSXRDLOd27+yumqnF6BFies0KHsvxI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2wykmqj191-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Dec 2019 11:10:50 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 18 Dec 2019 11:10:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XECYtBEGH6aOet7+Yh0HyXlNu4NmqeTgHogqvSWXpPha01ruup5qufEy3qy770qbm+7GtycvEcZxCF4h8kVBmKgKwbb8nQR30jBZ5XmGHYypqZRk5VP7/JEYCFB47G0MNJPGTdrbw05lThIfK6dtO+gXtwPeWG1Gn1UK/56h2dzt+OvRHUs4Il0IjEypKXQUQpeYdJBzx99gM6H9ANvcosF27kkLoTmQ5XDTOfcEiPY4t4io5OwNlH8RtU6id2Lm96pmXvcLcoyjD8bIOOfif04I2UgpukqowID9e4+RgNg8Ts1LLtOMXYZbKdE6LNTr0k7epqLMsX4aDS8yq40OmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfxV14fwiJyvhGGViO0czMb/UNoLP62lAaFQ7+j7Mgw=;
 b=DbXO79JvmDcKkv6CA3VyshhO+3Az8WOMGXBAjPev/3lUcJvss3vGIYIW+BxQVwq+AMO3WmlNmc3+HC8mFuSrudxBdhwahVUD/wyg75vRpZWyu6UFyKiOnd24ViiJfX5jqNw/D+P7VNslIMNwotAaMT6rBfbSah73K4wwOJZtL5gjMUYV2xwbfi9qhcWd/rrCfG2jcMOBxm4yaXV6CROp8enqCuO+dbA5ixcFWuh4qOXS7FUKhNuR8ia3hgtCss3aA5kc7QK9y7enI7k/Z/XC+MCC52RfCXVwN4bD74T0z4lWPgVv67s56zfkVS94Gpa7sfwoNVy59N5Vf1lpco9B/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfxV14fwiJyvhGGViO0czMb/UNoLP62lAaFQ7+j7Mgw=;
 b=AZnuW2t0mzx3vXGJUJaMvr7MOHCG9poW0rhaufAO5Cy7HvX1tJMv40XINuznThGL4ynPFkE6JRUr4+fc3HnNG7mhGjCdJ9eG8A0rRE9rV8TxrqvurNi9leU7UC/+7iNgqxSHaSjTc6M3qnL38orqnEmG7An23COVsr67X6Ol7GA=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5SPR00MB240.namprd15.prod.outlook.com (10.168.120.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.13; Wed, 18 Dec 2019 19:10:38 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 19:10:38 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Paul Chaignon <paul.chaignon@orange.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "paul.chaignon@gmail.com" <paul.chaignon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Single-cpu updates for per-cpu maps
Thread-Topic: [PATCH bpf-next 1/3] bpf: Single-cpu updates for per-cpu maps
Thread-Index: AQHVta6s4kEt3EZ1W0yWylX1vI1cXqfAQkgA
Date:   Wed, 18 Dec 2019 19:10:38 +0000
Message-ID: <377d5ad0-cf4f-4c8b-c23d-ed37dce4ad9f@fb.com>
References: <cover.1576673841.git.paul.chaignon@orange.com>
 <ec8fd77bb20881e7149f7444e731c510790191ce.1576673842.git.paul.chaignon@orange.com>
In-Reply-To: <ec8fd77bb20881e7149f7444e731c510790191ce.1576673842.git.paul.chaignon@orange.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:300:117::31) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::d3f4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e5a4059-cf3a-4115-a2f4-08d783edf7e0
x-ms-traffictypediagnostic: DM5SPR00MB240:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5SPR00MB2405A1C5B0E50E4AF708E9BD3530@DM5SPR00MB240.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(366004)(136003)(39860400002)(189003)(199004)(71200400001)(316002)(6486002)(6512007)(15650500001)(4326008)(66946007)(64756008)(66556008)(478600001)(8676002)(2906002)(66476007)(36756003)(66446008)(31686004)(52116002)(186003)(81156014)(81166006)(54906003)(110136005)(8936002)(31696002)(53546011)(2616005)(6506007)(86362001)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5SPR00MB240;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jFw73mI4Nj4VeVLXBVDddg6YvEte/4UL24aex/hbmkQ5E/SBJ58C+3/pE1CmrdNqlgdLynBXE2Y3y2Ze6w9mGbC42kYGk9p6xdjg4QU98NwkJi5LGVnA1h8BWjx/0E3ISbtw7J5bhsMA6G5Bi9FoxHE/LCsOWnxUCzs6SUmjprdrcxhQOhv1ix8UWSJ+J3fR9aMyKGTi8WkteXSOHPBrnOE4K6Fu5+O0qpaNY8sIx4Uib/C3ac+Bx/JrPmn/Z09w93Hzgpwm1T8eJGLbt26HavO0V6ihNw0EGgREJ4vEAxwOZvWlCzQwRHwpdK7upNqnV8Zs5tIEYsICsJ2RjrgWZFtoVfJjC21/x1QWpatIURwzoF/IU27B8P6GUMhiuOcNAI8vLjdhc31MZp0DGeuJp1tA4DVKiMpvHUQBPfOngB/vh2rF9xMTE/pNi75X68pX
Content-Type: text/plain; charset="utf-8"
Content-ID: <1470524EF3DA134B939D6A8D753A37D9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e5a4059-cf3a-4115-a2f4-08d783edf7e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 19:10:38.7215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbkB0UzQj3otdKL+E7FPe2cCeAvSPwqnd+AyuABRdE+CoTk7aGD9BI52IEE7mjRi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5SPR00MB240
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_06:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE4LzE5IDY6MjMgQU0sIFBhdWwgQ2hhaWdub24gd3JvdGU6DQo+IEN1cnJlbnRs
eSwgdXNlcnNwYWNlIHByb2dyYW1zIGhhdmUgdG8gdXBkYXRlIHRoZSB2YWx1ZXMgb2YgYWxsIENQ
VXMgYXQNCj4gb25jZSB3aGVuIHVwZGF0aW5nIHBlci1jcHUgbWFwcy4gIFRoaXMgbGltaXRhdGlv
biBwcmV2ZW50cyB0aGUgdXBkYXRlIG9mDQo+IGEgc2luZ2xlIENQVSdzIHZhbHVlIHdpdGhvdXQg
dGhlIHJpc2sgb2YgbWlzc2luZyBjb25jdXJyZW50IHVwZGF0ZXMgb24NCj4gb3RoZXIgQ1BVJ3Mg
dmFsdWVzLg0KPiANCj4gVGhpcyBwYXRjaCBhbGxvd3MgdXNlcnNwYWNlIHRvIHVwZGF0ZSB0aGUg
dmFsdWUgb2YgYSBzcGVjaWZpYyBDUFUgaW4NCj4gcGVyLWNwdSBtYXBzLiAgVGhlIENQVSB3aG9z
ZSB2YWx1ZSBzaG91bGQgYmUgdXBkYXRlZCBpcyBlbmNvZGVkIGluIHRoZQ0KPiAzMiB1cHBlci1i
aXRzIG9mIHRoZSBmbGFncyBhcmd1bWVudCwgYXMgZm9sbG93cy4gIFRoZSBuZXcgQlBGX0NQVSBm
bGFnDQo+IGNhbiBiZSBjb21iaW5lZCB3aXRoIGV4aXN0aW5nIGZsYWdzLg0KPiANCj4gICAgYnBm
X21hcF91cGRhdGVfZWxlbSguLi4sIGNwdWlkIDw8IDMyIHwgQlBGX0NQVSkNCg0KU29tZSBhZGRp
dGlvbmFsIGNvbW1lbnRzIGJleW9uZCBBbGV4ZWkncyBvbmUuDQoNCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFBhdWwgQ2hhaWdub24gPHBhdWwuY2hhaWdub25Ab3JhbmdlLmNvbT4NCj4gLS0tDQo+ICAg
aW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAgIHwgIDQgKysrDQo+ICAga2VybmVsL2JwZi9h
cnJheW1hcC5jICAgICAgICAgIHwgMTkgKysrKysrKystLS0tLQ0KPiAgIGtlcm5lbC9icGYvaGFz
aHRhYi5jICAgICAgICAgICB8IDQ5ICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0N
Cj4gICBrZXJuZWwvYnBmL2xvY2FsX3N0b3JhZ2UuYyAgICAgfCAxNiArKysrKysrLS0tLQ0KPiAg
IGtlcm5lbC9icGYvc3lzY2FsbC5jICAgICAgICAgICB8IDE3ICsrKysrKysrKy0tLQ0KPiAgIHRv
b2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8ICA0ICsrKw0KPiAgIDYgZmlsZXMgY2hhbmdl
ZCwgNzQgaW5zZXJ0aW9ucygrKSwgMzUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IGlu
ZGV4IGRiYmNmMGIwMjk3MC4uMmVmYjE3ZDJjNzdhIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3Vh
cGkvbGludXgvYnBmLmgNCj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IEBAIC0z
MTYsNiArMzE2LDEwIEBAIGVudW0gYnBmX2F0dGFjaF90eXBlIHsNCj4gICAjZGVmaW5lIEJQRl9O
T0VYSVNUCTEgLyogY3JlYXRlIG5ldyBlbGVtZW50IGlmIGl0IGRpZG4ndCBleGlzdCAqLw0KPiAg
ICNkZWZpbmUgQlBGX0VYSVNUCTIgLyogdXBkYXRlIGV4aXN0aW5nIGVsZW1lbnQgKi8NCj4gICAj
ZGVmaW5lIEJQRl9GX0xPQ0sJNCAvKiBzcGluX2xvY2stZWQgbWFwX2xvb2t1cC9tYXBfdXBkYXRl
ICovDQo+ICsjZGVmaW5lIEJQRl9DUFUJCTggLyogc2luZ2xlLWNwdSB1cGRhdGUgZm9yIHBlci1j
cHUgbWFwcyAqLw0KPiArDQo+ICsvKiBDUFUgbWFzayBmb3Igc2luZ2xlLWNwdSB1cGRhdGVzICov
DQo+ICsjZGVmaW5lIEJQRl9DUFVfTUFTSwkweEZGRkZGRkZGMDAwMDAwMDBVTEwNCkJQRl9GX0NQ
VV9NQVNLPw0KDQo+ICAgDQo+ICAgLyogZmxhZ3MgZm9yIEJQRl9NQVBfQ1JFQVRFIGNvbW1hbmQg
Ki8NCj4gICAjZGVmaW5lIEJQRl9GX05PX1BSRUFMTE9DCSgxVSA8PCAwKQ0KPiBkaWZmIC0tZ2l0
IGEva2VybmVsL2JwZi9hcnJheW1hcC5jIGIva2VybmVsL2JwZi9hcnJheW1hcC5jDQo+IGluZGV4
IGYwZDE5YmJiOTIxMS4uYTk2ZTk0Njk2ODE5IDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL2Fy
cmF5bWFwLmMNCj4gKysrIGIva2VybmVsL2JwZi9hcnJheW1hcC5jDQo+IEBAIC0zMDIsNyArMzAy
LDggQEAgc3RhdGljIGludCBhcnJheV9tYXBfdXBkYXRlX2VsZW0oc3RydWN0IGJwZl9tYXAgKm1h
cCwgdm9pZCAqa2V5LCB2b2lkICp2YWx1ZSwNCj4gICAJdTMyIGluZGV4ID0gKih1MzIgKilrZXk7
DQo+ICAgCWNoYXIgKnZhbDsNCj4gICANCj4gLQlpZiAodW5saWtlbHkoKG1hcF9mbGFncyAmIH5C
UEZfRl9MT0NLKSA+IEJQRl9FWElTVCkpDQo+ICsJaWYgKHVubGlrZWx5KChtYXBfZmxhZ3MgJiB+
QlBGX0NQVV9NQVNLICYgfkJQRl9GX0xPQ0sgJg0KPiArCQkJCSAgfkJQRl9DUFUpID4gQlBGX0VY
SVNUKSkNCg0KTWF5YmUgY3JlYXRlIGEgbWFjcm8gQVJSQVlfVVBEQVRFX0ZMQUdfTUFTSyBzaW1p
bGFyIHRvIGV4aXN0aW5nDQpBUlJBWV9DUkVBVEVfRkxBR19NQVNLPyBUaGlzIHdpbGwgbWFrZSBh
IGxpdHRsZSBlYXNpZXIgdG8gZm9sbG93LA0KZXNwLiB3ZSBnb3QgdGhyZWUgaW5kaXZpZHVhbCBm
bGFncyBoZXJlLg0KVGhlcmUgYXJlIHBvc3NpYmx5IHNvbWUgb3RoZXIgcGxhY2VzIGFzIHdlbGwg
YmVsb3cgY2FuIGJlIGRvbmUNCmluIGEgc2ltaWxhciB3YXkuDQoNCj4gICAJCS8qIHVua25vd24g
ZmxhZ3MgKi8NCj4gICAJCXJldHVybiAtRUlOVkFMOw0KPiAgIA0KPiBAQCAtMzQxLDcgKzM0Miw3
IEBAIGludCBicGZfcGVyY3B1X2FycmF5X3VwZGF0ZShzdHJ1Y3QgYnBmX21hcCAqbWFwLCB2b2lk
ICprZXksIHZvaWQgKnZhbHVlLA0KPiAgIAlpbnQgY3B1LCBvZmYgPSAwOw0KPiAgIAl1MzIgc2l6
ZTsNCj4gICANCj4gLQlpZiAodW5saWtlbHkobWFwX2ZsYWdzID4gQlBGX0VYSVNUKSkNCj4gKwlp
ZiAodW5saWtlbHkoKG1hcF9mbGFncyAmIH5CUEZfQ1BVX01BU0sgJiB+QlBGX0NQVSkgPiBCUEZf
RVhJU1QpKQ0KDQp+KEJQRl9GX0NQVV9NQVNLIHwgQlBGX0ZfQ1BVKSBvciBjcmVhdGUgYSBtYWNy
byBmb3IgbGlrZSANCkFSUkFZX1VQREFURV9DUFVfTUFTSyBmb3IgKEJQRl9GX0NQVV9NQVNLIHwg
QlBGX0ZfQ1BVKT8NCg0KPiAgIAkJLyogdW5rbm93biBmbGFncyAqLw0KPiAgIAkJcmV0dXJuIC1F
SU5WQUw7DQo+ICAgDQo+IEBAIC0zNDksNyArMzUwLDcgQEAgaW50IGJwZl9wZXJjcHVfYXJyYXlf
dXBkYXRlKHN0cnVjdCBicGZfbWFwICptYXAsIHZvaWQgKmtleSwgdm9pZCAqdmFsdWUsDQo+ICAg
CQkvKiBhbGwgZWxlbWVudHMgd2VyZSBwcmUtYWxsb2NhdGVkLCBjYW5ub3QgaW5zZXJ0IGEgbmV3
IG9uZSAqLw0KPiAgIAkJcmV0dXJuIC1FMkJJRzsNCj4gICANCj4gLQlpZiAodW5saWtlbHkobWFw
X2ZsYWdzID09IEJQRl9OT0VYSVNUKSkNCj4gKwlpZiAodW5saWtlbHkobWFwX2ZsYWdzICYgQlBG
X05PRVhJU1QpKQ0KPiAgIAkJLyogYWxsIGVsZW1lbnRzIGFscmVhZHkgZXhpc3QgKi8NCj4gICAJ
CXJldHVybiAtRUVYSVNUOw0KPiAgIA0KPiBAQCAtMzYyLDkgKzM2MywxNSBAQCBpbnQgYnBmX3Bl
cmNwdV9hcnJheV91cGRhdGUoc3RydWN0IGJwZl9tYXAgKm1hcCwgdm9pZCAqa2V5LCB2b2lkICp2
YWx1ZSwNCj4gICAJc2l6ZSA9IHJvdW5kX3VwKG1hcC0+dmFsdWVfc2l6ZSwgOCk7DQo+ICAgCXJj
dV9yZWFkX2xvY2soKTsNCj4gICAJcHB0ciA9IGFycmF5LT5wcHRyc1tpbmRleCAmIGFycmF5LT5p
bmRleF9tYXNrXTsNCj4gLQlmb3JfZWFjaF9wb3NzaWJsZV9jcHUoY3B1KSB7DQo+IC0JCWJwZl9s
b25nX21lbWNweShwZXJfY3B1X3B0cihwcHRyLCBjcHUpLCB2YWx1ZSArIG9mZiwgc2l6ZSk7DQo+
IC0JCW9mZiArPSBzaXplOw0KPiArCWlmIChtYXBfZmxhZ3MgJiBCUEZfQ1BVKSB7DQo+ICsJCWJw
Zl9sb25nX21lbWNweShwZXJfY3B1X3B0cihwcHRyLCBtYXBfZmxhZ3MgPj4gMzIpLCB2YWx1ZSwN
Cj4gKwkJCQlzaXplKTsNCj4gKwl9IGVsc2Ugew0KPiArCQlmb3JfZWFjaF9wb3NzaWJsZV9jcHUo
Y3B1KSB7DQo+ICsJCQlicGZfbG9uZ19tZW1jcHkocGVyX2NwdV9wdHIocHB0ciwgY3B1KSwgdmFs
dWUgKyBvZmYsDQo+ICsJCQkJCXNpemUpOw0KPiArCQkJb2ZmICs9IHNpemU7DQo+ICsJCX0NCj4g
ICAJfQ0KPiAgIAlyY3VfcmVhZF91bmxvY2soKTsNCj4gICAJcmV0dXJuIDA7DQo+IGRpZmYgLS1n
aXQgYS9rZXJuZWwvYnBmL2hhc2h0YWIuYyBiL2tlcm5lbC9icGYvaGFzaHRhYi5jDQo+IGluZGV4
IDIyMDY2YTYyYzhjOS4uYmU0NWM3YzQ1MDlmIDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL2hh
c2h0YWIuYw0KPiArKysgYi9rZXJuZWwvYnBmL2hhc2h0YWIuYw0KPiBAQCAtNjk1LDEyICs2OTUs
MTIgQEAgc3RhdGljIHZvaWQgZnJlZV9odGFiX2VsZW0oc3RydWN0IGJwZl9odGFiICpodGFiLCBz
dHJ1Y3QgaHRhYl9lbGVtICpsKQ0KPiAgIH0NCj4gICANCj4gICBzdGF0aWMgdm9pZCBwY3B1X2Nv
cHlfdmFsdWUoc3RydWN0IGJwZl9odGFiICpodGFiLCB2b2lkIF9fcGVyY3B1ICpwcHRyLA0KPiAt
CQkJICAgIHZvaWQgKnZhbHVlLCBib29sIG9uYWxsY3B1cykNCj4gKwkJCSAgICB2b2lkICp2YWx1
ZSwgaW50IGNwdWlkKQ0KPiAgIHsNCj4gLQlpZiAoIW9uYWxsY3B1cykgew0KPiArCWlmIChjcHVp
ZCA9PSAtMSkgew0KDQpNYWdpYyBudW1iZXIgLTEgYW5kIC0yIHNob3VsZCBiZSBtYWNyb3M/DQoN
Cj4gICAJCS8qIGNvcHkgdHJ1ZSB2YWx1ZV9zaXplIGJ5dGVzICovDQo+ICAgCQltZW1jcHkodGhp
c19jcHVfcHRyKHBwdHIpLCB2YWx1ZSwgaHRhYi0+bWFwLnZhbHVlX3NpemUpOw0KPiAtCX0gZWxz
ZSB7DQo+ICsJfSBlbHNlIGlmIChjcHVpZCA9PSAtMikgew0KPiAgIAkJdTMyIHNpemUgPSByb3Vu
ZF91cChodGFiLT5tYXAudmFsdWVfc2l6ZSwgOCk7DQo+ICAgCQlpbnQgb2ZmID0gMCwgY3B1Ow0K
PiAgIA0KPiBAQCAtNzA5LDYgKzcwOSwxMCBAQCBzdGF0aWMgdm9pZCBwY3B1X2NvcHlfdmFsdWUo
c3RydWN0IGJwZl9odGFiICpodGFiLCB2b2lkIF9fcGVyY3B1ICpwcHRyLA0KWy4uLl0NCg==
