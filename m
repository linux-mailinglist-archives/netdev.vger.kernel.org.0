Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579ED6125A
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 19:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfGFRYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 13:24:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44970 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726915AbfGFRYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 13:24:39 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x66HJe4w021781;
        Sat, 6 Jul 2019 10:24:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ldte9sXV6mtCtLQ+o7ONf3LStBbbHU2ezaoiX3M6f80=;
 b=D2wUijhSsp/TgQbfq834Lj8OdpQMtHU+gSYQyGQ6zbTb061ymhrRwgf7zlnx1Ic9bjMz
 bPGUU7zTvYkVEPs7hyMVa1AV2kxSdTFWxEkAz4wqb87VrLJ0uZiVQxm2iYeWKGw76GP+
 C7ehnhNtwm0H9j+/r03xhkDow8jWHrSjwws= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tjpy7hae7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Jul 2019 10:24:19 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 6 Jul 2019 10:24:19 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 6 Jul 2019 10:24:18 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 6 Jul 2019 10:24:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ldte9sXV6mtCtLQ+o7ONf3LStBbbHU2ezaoiX3M6f80=;
 b=VIJu4OZzn9fpBX6mbkMzq5+JQckgcqKwOVq4bNFDuBqE9N11H9cNS4VMVrb1IzCu4QW7JZDLtAZziD8zmBKiiNsxGeSsQP1PCUloSa0mW5cmpAaOVYDMvFZZv4nSD31GfOSu4uLCjzLG76uzhd7ekgo6P1rCaGziA7mrW9G+9Sc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2392.namprd15.prod.outlook.com (52.135.198.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Sat, 6 Jul 2019 17:24:17 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.019; Sat, 6 Jul 2019
 17:24:17 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v6 bpf-next 0/5] libbpf: add perf buffer abstraction and
 API
Thread-Topic: [PATCH v6 bpf-next 0/5] libbpf: add perf buffer abstraction and
 API
Thread-Index: AQHVM8BniIv3Up8LBE+vvAUcvPhlbqa918GA
Date:   Sat, 6 Jul 2019 17:24:16 +0000
Message-ID: <9a79b554-d0fb-5b27-4af3-23ba33d96bdd@fb.com>
References: <20190706060220.1801632-1-andriin@fb.com>
In-Reply-To: <20190706060220.1801632-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:300:117::28) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:c7d4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d4a1216-cba6-47cf-4964-08d70236c5db
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2392;
x-ms-traffictypediagnostic: BYAPR15MB2392:
x-microsoft-antispam-prvs: <BYAPR15MB239259C67063F3B6C3C61FBFD3F40@BYAPR15MB2392.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:425;
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(136003)(366004)(39860400002)(199004)(189003)(46003)(11346002)(476003)(446003)(486006)(186003)(316002)(102836004)(2906002)(66476007)(6506007)(36756003)(5660300002)(66556008)(64756008)(81156014)(73956011)(66446008)(110136005)(99286004)(6116002)(66946007)(478600001)(76176011)(52116002)(14454004)(2616005)(53546011)(386003)(86362001)(6246003)(256004)(25786009)(31696002)(7736002)(2501003)(31686004)(2201001)(6636002)(6512007)(81166006)(229853002)(53936002)(71190400001)(6436002)(71200400001)(8676002)(305945005)(68736007)(8936002)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2392;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PchGA4X2Obp0KPgvyRENvU0LRefXt9YM7q3HqKjO+kq4tbzsOwFzVMZg9us8gQMO3DZrd9vEAXGMMV8CCvmD9a+iN746yRjtwa60WT/JE9EbP6+M4jmdinYLJQjE5X7cOhk2YThsNEXSweQ59FkYrEiTTn3XJYAergKRvrjVWMT6mJlZxdyW13fAKNrlNvH376W7uiptEIoRLg9V122CfvLyfAr8d/TFQ3Rcyn+mkBuCDv+AvU4Bgl89vI44xe1FcuCDNsa/4DaHYfQhXTt5rp/aOlE3kzMhBxIv6mz2Z3BOMU6RImljy3sHe0cB9lx6mNpt9ezL8Nbn4y3dk75UabUQ/MfM27ie8lXJgd+AtlY0TszuEGbGKM5a98ZXxZyYV6kdoTPKCLKYuu1JZLkfCv0NJpnKwOHgOtTzpNqGolE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5004B6BE92DB294AB6162C2BC688D726@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d4a1216-cba6-47cf-4964-08d70236c5db
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2019 17:24:16.8975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2392
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060230
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvNS8xOSAxMTowMiBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBUaGlzIHBh
dGNoc2V0IGFkZHMgYSBoaWdoLWxldmVsIEFQSSBmb3Igc2V0dGluZyB1cCBhbmQgcG9sbGluZyBw
ZXJmIGJ1ZmZlcnMNCj4gYXNzb2NpYXRlZCB3aXRoIEJQRl9NQVBfVFlQRV9QRVJGX0VWRU5UX0FS
UkFZIG1hcC4gRGV0YWlscyBvZiBBUElzIGFyZQ0KPiBkZXNjcmliZWQgaW4gY29ycmVzcG9uZGlu
ZyBjb21taXQuDQo+IA0KPiBQYXRjaCAjMSBhZGRzIGEgc2V0IG9mIEFQSXMgdG8gc2V0IHVwIGFu
ZCB3b3JrIHdpdGggcGVyZiBidWZmZXIuDQo+IFBhdGNoICMyIGVuaGFuY2VzIGxpYmJwZiB0byBz
dXBwb3J0IGF1dG8tc2V0dGluZyBQRVJGX0VWRU5UX0FSUkFZIG1hcCBzaXplLg0KPiBQYXRjaCAj
MyBhZGRzIHRlc3QuDQo+IFBhdGNoICM0IGNvbnZlcnRzIGJwZnRvb2wgbWFwIGV2ZW50X3BpcGUg
dG8gbmV3IEFQSS4NCj4gUGF0Y2ggIzUgdXBkYXRlcyBSRUFETUUgdG8gbWVudGlvbiBwZXJmX2J1
ZmZlcl8gcHJlZml4Lg0KPiANCj4gdjUtPnY2Og0KPiAtIGZpeCBDOTkgZm9yIGxvb3AgdmFyaWFi
bGUgaW5pdGlhbGl6YXRpb24gdXNhZ2UgKFlvbmdob25nKTsNCj4gdjQtPnY1Og0KPiAtIGluaXRp
YWxpemUgcGVyZl9idWZmZXJfcmF3X29wdHMgaW4gYnBmdG9vbCBtYXAgZXZlbnRfcGlwZSAoSmFr
dWIpOw0KPiAtIGFkZCBwZXJmX2J1ZmZlcl8gdG8gUkVBRE1FOw0KPiB2My0+djQ6DQo+IC0gZml4
ZWQgYnBmdG9vbCBldmVudF9waXBlIGNtZCBlcnJvciBoYW5kbGluZyAoSmFrdWIpOw0KPiB2Mi0+
djM6DQo+IC0gYWRkZWQgcGVyZl9idWZmZXJfX25ld19yYXcgZm9yIG1vcmUgbG93LWxldmVsIGNv
bnRyb2w7DQo+IC0gY29udmVydGVkIGJwZnRvb2wgbWFwIGV2ZW50X3BpcGUgdG8gbmV3IEFQSSAo
RGFuaWVsKTsNCj4gLSBmaXhlZCBidWcgd2l0aCBlcnJvciBoYW5kbGluZyBpbiBjcmVhdGVfbWFw
cyAoU29uZyk7DQo+IHYxLT52MjoNCj4gLSBhZGQgYXV0by1zaXppbmcgb2YgUEVSRl9FVkVOVF9B
UlJBWSBtYXBzOw0KPiANCj4gQW5kcmlpIE5ha3J5aWtvICg1KToNCj4gICAgbGliYnBmOiBhZGQg
cGVyZiBidWZmZXIgQVBJDQo+ICAgIGxpYmJwZjogYXV0by1zZXQgUEVSRl9FVkVOVF9BUlJBWSBz
aXplIHRvIG51bWJlciBvZiBDUFVzDQo+ICAgIHNlbGZ0ZXN0cy9icGY6IHRlc3QgcGVyZiBidWZm
ZXIgQVBJDQo+ICAgIHRvb2xzL2JwZnRvb2w6IHN3aXRjaCBtYXAgZXZlbnRfcGlwZSB0byBsaWJi
cGYncyBwZXJmX2J1ZmZlcg0KPiAgICBsaWJicGY6IGFkZCBwZXJmX2J1ZmZlcl8gcHJlZml4IHRv
IFJFQURNRQ0KPiANCj4gICB0b29scy9icGYvYnBmdG9vbC9tYXBfcGVyZl9yaW5nLmMgICAgICAg
ICAgICAgfCAyMDEgKysrLS0tLS0tDQo+ICAgdG9vbHMvbGliL2JwZi9SRUFETUUucnN0ICAgICAg
ICAgICAgICAgICAgICAgIHwgICAzICstDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyAgICAg
ICAgICAgICAgICAgICAgICAgIHwgMzk3ICsrKysrKysrKysrKysrKysrLQ0KPiAgIHRvb2xzL2xp
Yi9icGYvbGliYnBmLmggICAgICAgICAgICAgICAgICAgICAgICB8ICA0OSArKysNCj4gICB0b29s
cy9saWIvYnBmL2xpYmJwZi5tYXAgICAgICAgICAgICAgICAgICAgICAgfCAgIDQgKw0KPiAgIC4u
Li9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvcGVyZl9idWZmZXIuYyAgICB8ICA5NCArKysrKw0K
PiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfcGVyZl9idWZmZXIuYyAgICB8ICAyNSAr
Kw0KPiAgIDcgZmlsZXMgY2hhbmdlZCwgNjI4IGluc2VydGlvbnMoKyksIDE0NSBkZWxldGlvbnMo
LSkNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3By
b2dfdGVzdHMvcGVyZl9idWZmZXIuYw0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9wZXJmX2J1ZmZlci5jDQoNCldpdGggYSBtaW5v
ciBjb21tZW50IG9uIHBhdGNoIDMvNSBpbiBhIGRpZmZlcmVudCB0aHJlYWQsDQpMR1RNLiBBY2sg
Zm9yIHRoZSB3aG9sZSBzZXJpZXMuDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNv
bT4NCg0K
