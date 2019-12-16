Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BA81210E5
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfLPRHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:07:04 -0500
Received: from mail-eopbgr690050.outbound.protection.outlook.com ([40.107.69.50]:60371
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727950AbfLPRHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:07:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSYjrWWQ9MIBVAgP6w40QmPXeGXA7RRvQy42vDV9Qhn0Qa0yomshIKWHYPEbnezrLdhpKL07OF1YDvvaBDrX2e8koTFVlrLOaP3XCqnl64ZU6hzIIAUUpsW8lR+J0SxlFbWLfYgXep6Hy602igMX0LxfNgR2PyvzlPRuw3zSY0RYK79vKRfNPZHavMvPJZ2DJTBzAPht2vKneT2J6F7z6MyWjJX80ZN6F76mwRSN1kNeFGjDCyZjsbuNdzkHBz6yDXbRgL2lcvJComaBQXhlaA+x+Hfx9rER1aT4hT6ComHMyjwfTwsy7hfpjboz0M7ODAHfANa+UgAKOMmXEBAX6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=so5SnU6Iyxo02ShpQyiAgAyv7tQEZbXh6voMT2xWEeo=;
 b=OF7i72qWzhbg2mWg8aWuZBgDFSBIEGjtWlx37RuMZYASQrKmjtoylvYeR1iogopNlj0dOhsBV/Dl7drQcT4jT2RYY9MAqkT5nEdBgjU85ZyvIro8z3W513nthPSLUDpTqyXLg4zec9pKi4l09xz+lcMXOwL0hKqOXunqDwTlX3DZaPapLoFEZMdjhElH0fVRB0W8JDh/TlF6zais/4MzD8uONIjthrPXM773eCPYW/CrIZSJsVMlaCAnxd1lpU8hRmSYnLs5NWkrBWXyvMOB4Jg0ifQCYZG12udeaRNUlc0syZ0qAzNswJPsf+tdGw0wU+zR6TsEARp0XzTWrJmFUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=so5SnU6Iyxo02ShpQyiAgAyv7tQEZbXh6voMT2xWEeo=;
 b=EBp2YzKa72X5FiLXxXL4zEVymQMGz1WPBhyWJoq2R7l9xSCjwCpL+bem5BJGb7YjNCLXIlm9Zd1nmtPUdXkqN3WwEJmv2VetyfW+evlFhM7osSMUbn34hrdianJSGlZxnqIvdMkqfd0fUG8Y322HHTLdEd3tHChIjCpLeXOt/Uw=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:48 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:48 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 49/55] staging: wfx: simplify hif_set_template_frame() usage
Thread-Topic: [PATCH 49/55] staging: wfx: simplify hif_set_template_frame()
 usage
Thread-Index: AQHVtDLOYb/UslY1dEe3AM5ifbzjdQ==
Date:   Mon, 16 Dec 2019 17:03:58 +0000
Message-ID: <20191216170302.29543-50-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e75c2c6-24f3-47e2-a462-08d7824a5636
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4142DAC3F773BF851DE3EA7893510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MqE3iOKEuS8GbvrkVjoPA3LETINozMwzReqeuQIH0KhDPWrpv0SahCShRxcJiSLNNNJdn3wVomIio8/kq29W+f+Fhnymw5CaTutik31OhFPPhqBcrVx/RAILJIoX+5tLR7tcSwEsaD4XnN9mxuh6QXtkGjiX4M4EnPhypqf8RhDuc0Rb1J4UvHDXa5WDffqRUjPf+/GIr86gWamvJ0/oxzSw6YeSjn445aCxemZeYxT9yTHZBroNcvZGPABd4NGbW7Mco7MWsB8gx15HKruxdDRttxfH54apEcR2adC2935NG9xEeFFQTgZC4QaBrt2BORTL3pqjN1DigfKxaO283sPitMi4zrkIk6eD+P87v7NPGwAbDqZ/VQK4CyyUfRcn9oP6D8JkWEa5AloUU79x6Mg8H7VHjiVcFONkZ2fB7f41yoVXkrK+VkN8Yed43pzY
Content-Type: text/plain; charset="utf-8"
Content-ID: <C03F8931E7027248A0F65AA4C07E994A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e75c2c6-24f3-47e2-a462-08d7824a5636
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:58.5098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2sR10ecwL4SlZvbeyufXLdjIMlhcLvkhxol6WRCXGA25EjPOnOeD/SIswH0lRjVp8I5H8+VglFIc+TSHZb1FhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGUgc3RydWN0dXJlIGhpZl9taWJfdGVtcGxhdGVfZnJhbWUgY29tZSBmcm9tIGhhcmR3YXJlIEFQ
SS4gSXQgaXMgbm90DQppbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBlciBsYXllcnMg
b2YgdGhlIGRyaXZlci4NCg0KSW4gYWRkLCB0aGUgY3VycmVudCBjb2RlIGZvciBoaWZfc2V0X3Rl
bXBsYXRlX2ZyYW1lKCkgaXMgZHVtYi4gQWxsIHRoZQ0KZGlmZmljdWx0IHRhc2sgaXMgbGVmdCB0
byB0aGUgY2FsbGVyLiBTbywgdGhlcmUgaXMgY29kZSB0byBmYWN0b3JpemUNCmhlcmUuDQoNClNp
Z25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIHwgMTEgKysrKysrKysr
Ky0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgICAgICB8ICA3ICstLS0tLS0NCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICB8IDI5ICsrKysrKystLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQogMyBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAyOSBkZWxldGlvbnMo
LSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgNCmluZGV4IGQ3Nzc2NWY3NWYxMC4uYjFlZWRh
MmEzYWIzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgNCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oDQpAQCAtMTMwLDggKzEzMCwxNyBA
QCBzdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X29wZXJhdGlvbmFsX21vZGUoc3RydWN0IHdmeF9k
ZXYgKndkZXYsDQogfQ0KIA0KIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfdGVtcGxhdGVfZnJh
bWUoc3RydWN0IHdmeF92aWYgKnd2aWYsDQotCQkJCQkgc3RydWN0IGhpZl9taWJfdGVtcGxhdGVf
ZnJhbWUgKmFyZykNCisJCQkJCSBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KKwkJCQkJIHU4IGZyYW1l
X3R5cGUsIGludCBpbml0X3JhdGUpDQogew0KKwlzdHJ1Y3QgaGlmX21pYl90ZW1wbGF0ZV9mcmFt
ZSAqYXJnOw0KKw0KKwlza2JfcHVzaChza2IsIDQpOw0KKwlhcmcgPSAoc3RydWN0IGhpZl9taWJf
dGVtcGxhdGVfZnJhbWUgKilza2ItPmRhdGE7DQorCXNrYl9wdWxsKHNrYiwgNCk7DQorCWFyZy0+
aW5pdF9yYXRlID0gaW5pdF9yYXRlOw0KKwlhcmctPmZyYW1lX3R5cGUgPSBmcmFtZV90eXBlOw0K
KwlhcmctPmZyYW1lX2xlbmd0aCA9IGNwdV90b19sZTE2KHNrYi0+bGVuKTsNCiAJcmV0dXJuIGhp
Zl93cml0ZV9taWIod3ZpZi0+d2Rldiwgd3ZpZi0+aWQsIEhJRl9NSUJfSURfVEVNUExBVEVfRlJB
TUUsDQogCQkJICAgICBhcmcsIHNpemVvZigqYXJnKSk7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMNCmluZGV4
IDhiMTg0ZWZhZDBjZi4uYzgyYzA0ZmY1ZDA2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9zY2FuLmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jDQpAQCAtNTIsNyAr
NTIsNiBAQCBzdGF0aWMgaW50IHdmeF9zY2FuX3N0YXJ0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLA0K
IHN0YXRpYyBpbnQgdXBkYXRlX3Byb2JlX3RtcGwoc3RydWN0IHdmeF92aWYgKnd2aWYsDQogCQkJ
ICAgICBzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0ICpyZXEpDQogew0KLQlzdHJ1Y3QgaGlm
X21pYl90ZW1wbGF0ZV9mcmFtZSAqdG1wbDsNCiAJc3RydWN0IHNrX2J1ZmYgKnNrYjsNCiANCiAJ
c2tiID0gaWVlZTgwMjExX3Byb2JlcmVxX2dldCh3dmlmLT53ZGV2LT5odywgd3ZpZi0+dmlmLT5h
ZGRyLA0KQEAgLTYxLDExICs2MCw3IEBAIHN0YXRpYyBpbnQgdXBkYXRlX3Byb2JlX3RtcGwoc3Ry
dWN0IHdmeF92aWYgKnd2aWYsDQogCQlyZXR1cm4gLUVOT01FTTsNCiANCiAJc2tiX3B1dF9kYXRh
KHNrYiwgcmVxLT5pZSwgcmVxLT5pZV9sZW4pOw0KLQlza2JfcHVzaChza2IsIDQpOw0KLQl0bXBs
ID0gKHN0cnVjdCBoaWZfbWliX3RlbXBsYXRlX2ZyYW1lICopc2tiLT5kYXRhOw0KLQl0bXBsLT5m
cmFtZV90eXBlID0gSElGX1RNUExUX1BSQlJFUTsNCi0JdG1wbC0+ZnJhbWVfbGVuZ3RoID0gY3B1
X3RvX2xlMTYoc2tiLT5sZW4gLSA0KTsNCi0JaGlmX3NldF90ZW1wbGF0ZV9mcmFtZSh3dmlmLCB0
bXBsKTsNCisJaGlmX3NldF90ZW1wbGF0ZV9mcmFtZSh3dmlmLCBza2IsIEhJRl9UTVBMVF9QUkJS
RVEsIDApOw0KIAlkZXZfa2ZyZWVfc2tiKHNrYik7DQogCXJldHVybiAwOw0KIH0NCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
Yw0KaW5kZXggMTljYTEzNTQzYTI1Li5iYTNlODFmZDQ3N2IgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQpAQCAt
ODMxLDMyICs4MzEsMjAgQEAgc3RhdGljIGludCB3ZnhfdXBkYXRlX2JlYWNvbmluZyhzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZikNCiANCiBzdGF0aWMgaW50IHdmeF91cGxvYWRfYmVhY29uKHN0cnVjdCB3
ZnhfdmlmICp3dmlmKQ0KIHsNCi0JaW50IHJldCA9IDA7DQotCXN0cnVjdCBza19idWZmICpza2Ig
PSBOVUxMOw0KKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KIAlzdHJ1Y3QgaWVlZTgwMjExX21nbXQg
Km1nbXQ7DQotCXN0cnVjdCBoaWZfbWliX3RlbXBsYXRlX2ZyYW1lICpwOw0KIA0KIAlpZiAod3Zp
Zi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04gfHwNCiAJICAgIHd2aWYtPnZp
Zi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9NT05JVE9SIHx8DQogCSAgICB3dmlmLT52aWYtPnR5
cGUgPT0gTkw4MDIxMV9JRlRZUEVfVU5TUEVDSUZJRUQpDQotCQlnb3RvIGRvbmU7DQorCQlyZXR1
cm4gMDsNCiANCiAJc2tiID0gaWVlZTgwMjExX2JlYWNvbl9nZXQod3ZpZi0+d2Rldi0+aHcsIHd2
aWYtPnZpZik7DQotDQogCWlmICghc2tiKQ0KIAkJcmV0dXJuIC1FTk9NRU07DQorCWhpZl9zZXRf
dGVtcGxhdGVfZnJhbWUod3ZpZiwgc2tiLCBISUZfVE1QTFRfQkNOLA0KKwkJCSAgICAgICBBUElf
UkFURV9JTkRFWF9CXzFNQlBTKTsNCiANCi0JcCA9IChzdHJ1Y3QgaGlmX21pYl90ZW1wbGF0ZV9m
cmFtZSAqKSBza2JfcHVzaChza2IsIDQpOw0KLQlwLT5mcmFtZV90eXBlID0gSElGX1RNUExUX0JD
TjsNCi0JcC0+aW5pdF9yYXRlID0gQVBJX1JBVEVfSU5ERVhfQl8xTUJQUzsgLyogMU1icHMgRFNT
UyAqLw0KLQlwLT5mcmFtZV9sZW5ndGggPSBjcHVfdG9fbGUxNihza2ItPmxlbiAtIDQpOw0KLQ0K
LQlyZXQgPSBoaWZfc2V0X3RlbXBsYXRlX2ZyYW1lKHd2aWYsIHApOw0KLQ0KLQlza2JfcHVsbChz
a2IsIDQpOw0KLQ0KLQlpZiAocmV0KQ0KLQkJZ290byBkb25lOw0KIAkvKiBUT0RPOiBEaXN0aWxs
IHByb2JlIHJlc3A7IHJlbW92ZSBUSU0gYW5kIGFueSBvdGhlciBiZWFjb24tc3BlY2lmaWMNCiAJ
ICogSUVzDQogCSAqLw0KQEAgLTg2NCwxNCArODUyLDExIEBAIHN0YXRpYyBpbnQgd2Z4X3VwbG9h
ZF9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYpDQogCW1nbXQtPmZyYW1lX2NvbnRyb2wgPQ0K
IAkJY3B1X3RvX2xlMTYoSUVFRTgwMjExX0ZUWVBFX01HTVQgfCBJRUVFODAyMTFfU1RZUEVfUFJP
QkVfUkVTUCk7DQogDQotCXAtPmZyYW1lX3R5cGUgPSBISUZfVE1QTFRfUFJCUkVTOw0KLQ0KLQly
ZXQgPSBoaWZfc2V0X3RlbXBsYXRlX2ZyYW1lKHd2aWYsIHApOw0KKwloaWZfc2V0X3RlbXBsYXRl
X2ZyYW1lKHd2aWYsIHNrYiwgSElGX1RNUExUX1BSQlJFUywNCisJCQkgICAgICAgQVBJX1JBVEVf
SU5ERVhfQl8xTUJQUyk7DQogCXdmeF9md2RfcHJvYmVfcmVxKHd2aWYsIGZhbHNlKTsNCi0NCi1k
b25lOg0KIAlkZXZfa2ZyZWVfc2tiKHNrYik7DQotCXJldHVybiByZXQ7DQorCXJldHVybiAwOw0K
IH0NCiANCiBzdGF0aWMgaW50IHdmeF9pc19odChjb25zdCBzdHJ1Y3Qgd2Z4X2h0X2luZm8gKmh0
X2luZm8pDQotLSANCjIuMjAuMQ0K
