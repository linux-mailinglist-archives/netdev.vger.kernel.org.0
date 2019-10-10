Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF16D2FF8
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfJJSGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:06:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46144 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726387AbfJJSGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 14:06:37 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9AI5Sll016151;
        Thu, 10 Oct 2019 11:06:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=P8pb0PnmXetGnE26UjnUlNrMzAGLTZFYAIbc5nmoma4=;
 b=gQV4t7qOoBgGpZ6L3CePvGiOP4T3G8uBAifULHIsMk+Bak4l/jIGYUnE4pznXBIi/3q2
 RD+0fNdHIMG2evLP9Jhj34kbaFT50Rv6jMmtFPzTCU7G0dUM3XFgvT1iKP+kqg+HJEMT
 MIv5um0bRJEZhROOaYmHB0dFaMo6FLs5r/E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vj65e9kex-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Oct 2019 11:06:16 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 10 Oct 2019 11:06:15 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 10 Oct 2019 11:06:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7qnNcPOiBNO8LUZjCqZpDItwNZlSW6QBvFJ/iVfcVeIqVmZeEhLYrV3XIZnuFnYxDbBtO+BiYI1fg4J6WUCaXPnDmaZtWfPsmGsOwLYWYzuY4xF6CYIjI65KhXtrhC88ADaM20H/P/hWGU1RiGu3O/uEFaFC4Tg9lavKLNNIoJUwVw6CPXIylrHQPkJNgEBSZ9Z66LFMJ4A3sQGhiViKJEZZL1l9H7rT+vHqcbdZ+ki7VZ22cCujBcMSfKJCPpttBmfw0F3LzC0jLrkgrAgAM56une0IF37P5i02nQI/lg2Znl+LWeyw2RUVGP/inTrCH0iWvumDiJY4kQNcexCFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8pb0PnmXetGnE26UjnUlNrMzAGLTZFYAIbc5nmoma4=;
 b=McG1YTx7OQC2khDZtzGmVKh5fw8Ve+fsvyU+S0qVI+sLHGA8DL7DOfZOZOlJxvZVN75nwO66OXgbXzQ9GWaZ6qR3dJ8SH6Ne7wOv90+JCO+jskPfabTxUQ4M7ySa0Wl/siwhfEKVj3eqbNGhDyhF84cQy+2c5EYP8j5OZIX5ubKVc0uuyFm/OVmwH0bPnCjWHXFnUyL79yZOArC30QmcJ/+9s4uYSkLpI9efFJ/qfww3d84h+kpbpPaU0RXMw+1iQqHFYL4X3n0/LhXA6V9IBAIH8Zu2QvBimdTGiomykhHAqn3F0fu4gWKgYh9nYA4i7GNJuSslMunZCgkAEwICwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8pb0PnmXetGnE26UjnUlNrMzAGLTZFYAIbc5nmoma4=;
 b=k5KBWfBYQW/koe19UYTeP3rhnsP62wdG4d5b3pBulh2xZ6gxDyJ8q/7VmnBzb8oRrEU+yIWD1DILGfdbHf8K9QjPJZWtb9rRlwHzdRqZ9bdUIIncuAz7gj8y0cCJyfh2KacsFCkh80x2qROTSKRr0qqpsGOARjck7YTPDBpOb2s=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2599.namprd15.prod.outlook.com (20.179.155.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 18:06:14 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Thu, 10 Oct 2019
 18:06:14 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] bpf/stackmap: fix A-A deadlock in
 bpf_get_stack()
Thread-Topic: [PATCH bpf-next 2/2] bpf/stackmap: fix A-A deadlock in
 bpf_get_stack()
Thread-Index: AQHVfzKswn/pkqmThEy7QwA/cvFN/adTfF0AgAAtfYCAAHz9AIAABY+A
Date:   Thu, 10 Oct 2019 18:06:14 +0000
Message-ID: <4865df4d-7d13-0655-f3b4-5d025aaa1edb@fb.com>
References: <20191010061916.198761-1-songliubraving@fb.com>
 <20191010061916.198761-3-songliubraving@fb.com>
 <20191010073608.GO2311@hirez.programming.kicks-ass.net>
 <a1d30b11-2759-0293-5612-48150db92775@fb.com>
 <20191010174618.GT2328@hirez.programming.kicks-ass.net>
In-Reply-To: <20191010174618.GT2328@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:301:60::38) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f66f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adf84d41-1053-40ae-9b86-08d74dac89ec
x-ms-traffictypediagnostic: BYAPR15MB2599:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25992546ED4BE9D5EE04BD07D7940@BYAPR15MB2599.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(39860400002)(396003)(346002)(189003)(199004)(6116002)(52116002)(476003)(36756003)(486006)(31696002)(86362001)(66946007)(66476007)(66556008)(64756008)(66446008)(31686004)(386003)(316002)(53546011)(71190400001)(71200400001)(25786009)(6506007)(99286004)(8936002)(2616005)(76176011)(11346002)(54906003)(446003)(5660300002)(46003)(14454004)(229853002)(102836004)(4326008)(6486002)(7736002)(305945005)(81166006)(81156014)(6512007)(2906002)(8676002)(14444005)(256004)(478600001)(6916009)(6246003)(6436002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2599;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N3OCNvp4cCDd+u34jqkLH8pHKNEQQMHZjL0gLwq/6MEvp1op2CFtZUYr0HEzcj9xW9atb6IbqJL9KHDzbhlS7tlQnXALP12Vta05WPfOGE/FSKLySE+QvbZ7zWmZ0h4cgmTJQX72sWmzwxcvuw4S8b+hB4i/bI4fCe8sA23FcE3O+Kc0HtH5DbRC3LPdnBqAJBZecp3x9WAwNpn04ZrKpGnFAcrfwkX2C6aHj4BrHp6OK1oNHhXjnmtNIKc/uFsFZ9pzyBUP4F0ywCf8jpkiVFkq97DVFevYIIIjZufucaYQoB/3vet+FsxAyvyM4Pi4dzB9TG8xHj/90MGX94ozDepSgCwgNwNiLyHWmQLpEQRqVRUg8zK3TzpX3Zs50PUSmgO3pP9vwQeclAN//lKIBwOgwWULywXQjA2nbrZxlm4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <604B013D06D7BB429ED4C96CC4986A58@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: adf84d41-1053-40ae-9b86-08d74dac89ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 18:06:14.2871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ccJNZSgpPk2mx/Ikqm3e7VA6IUO+nVQuRyoOQyPIlva1VRK2OJw9wHBgimt76qQd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2599
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_06:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTAvMTkgMTA6NDYgQU0sIFBldGVyIFppamxzdHJhIHdyb3RlOg0KPiBPbiBUaHUsIE9j
dCAxMCwgMjAxOSBhdCAwNToxOTowMVBNICswMDAwLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6
DQo+PiBPbiAxMC8xMC8xOSAxMjozNiBBTSwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+Pj4gT24g
V2VkLCBPY3QgMDksIDIwMTkgYXQgMTE6MTk6MTZQTSAtMDcwMCwgU29uZyBMaXUgd3JvdGU6DQo+
Pj4+IGJwZiBzdGFja21hcCB3aXRoIGJ1aWxkLWlkIGxvb2t1cCAoQlBGX0ZfU1RBQ0tfQlVJTERf
SUQpIGNhbiB0cmlnZ2VyIEEtQQ0KPj4+PiBkZWFkbG9jayBvbiBycV9sb2NrKCk6DQo+Pj4+DQo+
Pj4+IHJjdTogSU5GTzogcmN1X3NjaGVkIGRldGVjdGVkIHN0YWxscyBvbiBDUFVzL3Rhc2tzOg0K
Pj4+PiBbLi4uXQ0KPj4+PiBDYWxsIFRyYWNlOg0KPj4+PiAgICB0cnlfdG9fd2FrZV91cCsweDFh
ZC8weDU5MA0KPj4+PiAgICB3YWtlX3VwX3ErMHg1NC8weDgwDQo+Pj4+ICAgIHJ3c2VtX3dha2Ur
MHg4YS8weGIwDQo+Pj4+ICAgIGJwZl9nZXRfc3RhY2srMHgxM2MvMHgxNTANCj4+Pj4gICAgYnBm
X3Byb2dfZmJkYWY0MmVkZWQ5ZmU0Nl9vbl9ldmVudCsweDVlMy8weDEwMDANCj4+Pj4gICAgYnBm
X292ZXJmbG93X2hhbmRsZXIrMHg2MC8weDEwMA0KPj4+PiAgICBfX3BlcmZfZXZlbnRfb3ZlcmZs
b3crMHg0Zi8weGYwDQo+Pj4+ICAgIHBlcmZfc3dldmVudF9vdmVyZmxvdysweDk5LzB4YzANCj4+
Pj4gICAgX19fcGVyZl9zd19ldmVudCsweGU3LzB4MTIwDQo+Pj4+ICAgIF9fc2NoZWR1bGUrMHg0
N2QvMHg2MjANCj4+Pj4gICAgc2NoZWR1bGUrMHgyOS8weDkwDQo+Pj4+ICAgIGZ1dGV4X3dhaXRf
cXVldWVfbWUrMHhiOS8weDExMA0KPj4+PiAgICBmdXRleF93YWl0KzB4MTM5LzB4MjMwDQo+Pj4+
ICAgIGRvX2Z1dGV4KzB4MmFjLzB4YTUwDQo+Pj4+ICAgIF9feDY0X3N5c19mdXRleCsweDEzYy8w
eDE4MA0KPj4+PiAgICBkb19zeXNjYWxsXzY0KzB4NDIvMHgxMDANCj4+Pj4gICAgZW50cnlfU1lT
Q0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NDQvMHhhOQ0KPj4+Pg0KPj4+DQo+Pj4+IGRpZmYgLS1n
aXQgYS9rZXJuZWwvYnBmL3N0YWNrbWFwLmMgYi9rZXJuZWwvYnBmL3N0YWNrbWFwLmMNCj4+Pj4g
aW5kZXggMDUyNTgwYzMzZDI2Li4zYjI3OGY2YjBjM2UgMTAwNjQ0DQo+Pj4+IC0tLSBhL2tlcm5l
bC9icGYvc3RhY2ttYXAuYw0KPj4+PiArKysgYi9rZXJuZWwvYnBmL3N0YWNrbWFwLmMNCj4+Pj4g
QEAgLTI4Nyw3ICsyODcsNyBAQCBzdGF0aWMgdm9pZCBzdGFja19tYXBfZ2V0X2J1aWxkX2lkX29m
ZnNldChzdHJ1Y3QgYnBmX3N0YWNrX2J1aWxkX2lkICppZF9vZmZzLA0KPj4+PiAgICAJYm9vbCBp
cnFfd29ya19idXN5ID0gZmFsc2U7DQo+Pj4+ICAgIAlzdHJ1Y3Qgc3RhY2tfbWFwX2lycV93b3Jr
ICp3b3JrID0gTlVMTDsNCj4+Pj4NCj4+Pj4gLQlpZiAoaW5fbm1pKCkpIHsNCj4+Pj4gKwlpZiAo
aW5fbm1pKCkgfHwgdGhpc19ycV9pc19sb2NrZWQoKSkgew0KPj4+PiAgICAJCXdvcmsgPSB0aGlz
X2NwdV9wdHIoJnVwX3JlYWRfd29yayk7DQo+Pj4+ICAgIAkJaWYgKHdvcmstPmlycV93b3JrLmZs
YWdzICYgSVJRX1dPUktfQlVTWSkNCj4+Pj4gICAgCQkJLyogY2Fubm90IHF1ZXVlIG1vcmUgdXBf
cmVhZCwgZmFsbGJhY2sgKi8NCj4+Pg0KPj4+IFRoaXMgaXMgaG9ycmlmaWMgY3JhcC4gSnVzdCBz
YXkgbm8gdG8gdGhhdCBnZXRfYnVpbGRfaWRfb2Zmc2V0KCkNCj4+PiB0cmFpbndyZWNrLg0KPj4N
Cj4+IHRoaXMgaXMgbm90IGEgaGVscGZ1bCBjb21tZW50Lg0KPj4gV2hhdCBpc3N1ZXMgZG8geW91
IHNlZSB3aXRoIHRoaXMgYXBwcm9hY2g/DQo+IA0KPiBJdCB3aWxsIHN0aWxsIGdlbmVyYXRlIGRl
YWRsb2NrcyBpZiBJIHBsYWNlIGEgdHJhY2Vwb2ludCBpbnNpZGUgYSBsb2NrDQo+IHRoYXQgbmVz
dHMgaW5zaWRlIHJxLT5sb2NrLCBhbmQgaXQgd29uJ3QgZXZlciBiZSBhYmxlIHRvIGRldGVjdCB0
aGF0Lg0KPiBTYXkgZG8gdGhlIHZlcnkgc2FtZSB0aGluZyBvbiB0cmFjZV9ocnRpbWVyX3N0YXJ0
KCksIHdoaWNoIGlzIHVuZGVyDQo+IGNwdV9iYXNlLT5sb2NrLCB3aGljaCBuZXN0cyBpbnNpZGUg
cnEtPmxvY2suIFRoYXQgc2hvdWxkIGdpdmUgeW91IGFuDQo+IEFCLUJBLg0KPiANCj4gdHJhY2Vw
b2ludHMgLyBwZXJmLW92ZXJmbG93IHNob3VsZCBfbmV2ZXJfIHRha2UgbG9ja3MuDQo+IA0KPiBB
bGwgb2Ygc3RhY2tfbWFwX2dldF9idWlsZF9pZF9vZmZzZXQoKSBpcyBqdXN0IGRpc2d1aXN0aW5n
IGdhbWVzOyBJIGRpZA0KPiB0ZWxsIHlvdSBndXlzIGhvdyB0byBkbyBsb2NrbGVzcyB2bWEgbG9v
a3VwcyBhIGZldyB5ZWFycyBhZ28gLS0gYW5kIHllcywNCj4gdGhhdCBpcyBpbnZhc2l2ZSBjb3Jl
IG1tIHN1cmdlcnkuIEJ1dCB0aGlzIGlzIGp1c3QgZGlzZ3Vpc3RpbmcgaGFja3MgZm9yDQo+IG5v
dCB3YW50aW5nIHRvIGRvIGl0IHJpZ2h0Lg0KDQp5b3UgbWVhbiBzcGVjdWxhdGl2ZSBwYWdlIGZh
dWx0IHN0dWZmPw0KVGhhdCB3YXMgbXkgaG9wZSBhcyB3ZWxsIGFuZCBJIG9mZmVyZWQgTGF1cmVu
dCBhbGwgdGhlIGhlbHAgdG8gbGFuZCBpdC4NCllldCBhZnRlciBhIHllYXIgc2luY2Ugd2UndmUg
dGFsa2VkIHRoZSBwYXRjaGVzIGFyZSBub3QgYW55IGNsb3Nlcg0KdG8gbGFuZGluZy4NCkFueSBv
dGhlciAnaW52YXNpdmUgbW0gc3VyZ2VyeScgeW91IGhhdmUgaW4gbWluZD8NCg0KPiBCYXNpY2Fs
bHkgdGhlIG9ubHkgc2VtaS1zYW5lIHRoaW5nIHRvIGRvIHdpdGggdGhhdCB0cmFpbndyZWNrIGlz
DQo+IHMvaW5fbm1pKCkvdHJ1ZS8gYW5kIHByYXkuDQo+IA0KPiBPbiB0b3Agb2YgdGhhdCBJIGp1
c3QgaGF0ZSBidWlsZGlkcyBpbiBnZW5lcmFsLg0KDQpFbW90aW9ucyBhc2lkZS4uLiBidWlsZF9p
ZCBpcyB1c2VmdWwgYW5kIHVzZWQgaW4gcHJvZHVjdGlvbi4NCkl0J3MgdXNlZCB3aWRlbHkgYmVj
YXVzZSBpdCBzb2x2ZXMgcmVhbCBwcm9ibGVtcy4NClRoaXMgZGVhZCBsb2NrIGlzIGZyb20gcmVh
bCBzZXJ2ZXJzIGFuZCBub3QgZnJvbSBzb21lIHNhbml0aXplciB3YW5uYWJlLg0KSGVuY2Ugd2Ug
bmVlZCB0byBmaXggaXQgYXMgY2xlYW5seSBhcyBwb3NzaWJsZSBhbmQgcXVpY2tseS4NCnMvaW5f
bm1pL3RydWUvIGlzIGNlcnRhaW5seSBhbiBvcHRpb24uDQpJJ20gd29ycmllZCBhYm91dCBvdmVy
aGVhZCBvZiBkb2luZyBpcnFfd29ya19xdWV1ZSgpIGFsbCB0aGUgdGltZS4NCkJ1dCBJJ20gbm90
IGZhbWlsaWFyIHdpdGggbWVjaGFuaXNtIGVub3VnaCB0byBqdXN0aWZ5IHRoZSBjb25jZXJucy4N
CldvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8gZG8gcy9pbl9ubWkvaXJnc19kaXNhYmxlZC8gaW5zdGVh
ZD8NCg0K
