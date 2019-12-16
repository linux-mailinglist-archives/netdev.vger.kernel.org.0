Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D2D121109
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfLPRIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:08:23 -0500
Received: from mail-eopbgr690078.outbound.protection.outlook.com ([40.107.69.78]:42057
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727106AbfLPRG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDTqrQrSR0OmOlkjMdqr+z7ty0ZMQrF/j2XHFtheGGDGcFIK+ZRKFKCe8bUSVp0Jpu2mT1UymOy/hQ9hnGCXEZ6hUhNF3yhnh5bi+Ud2XWSRmpudPk0gY1RIprb2lDsYbg3m/OVJWUamXckHdqmgyyeU8aJsEu2To0T6ZjHfyfj4BGmLMROCzHiqdU1dfgEYsnvafXAjH8AoznI9Fo1zOk/LGeiVWggEZhReEBAcFc4IRNa7ry89i1h7Iy2YvJQzE3bD21qwyGEpcylyee+mvd6wF6DSoO3/XdPxsAplXaTerZrVYUubu5maXkEAxBx765VwKdzz9GCnqpP7cQNqOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Heol9oEc//L1+KRKm+U1W8kTflzxvpF+avWHq3bzfUk=;
 b=hW8WKx/NpHGpV3MB1p6ipaQ8LmShBC1Hlb1WKFnYe1ZuDfhyICnmfz14KCfKe/mdupw9SJocYqPw5NiO9QkoI6CuLUb0S9naiTpqCKm1dX0wu0giR4725+Wr7DVadEjqN9EQt57T8M8Pk2reCFYIQVdRhVfvaIo/R7OOiLRspQNEpSAnXO0SUimvxuXVGelVJXpQNN3BLSmS97Ox6s9b7ACAyyxWBAlERBiZ/ICk4OVxisWTx6hU2iQH65PKQEx+0cG5rYCuFjHBw98vr723ain77+GHff2XmpavMhgGCs4rP3MyckXP1Ot8PdbsAMM+5T6anTi22K6v9K+hVZhTcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Heol9oEc//L1+KRKm+U1W8kTflzxvpF+avWHq3bzfUk=;
 b=IVhXJmmAf678iY3JJm6Ssf+6jCQ/5GnfjZwSsGNQgi3wuvGCDYQ9zNlHDkIua/QSjUD/S4XCyNSm0izdu5dpIdohGJrRRMU6BXKuGlvQ5H+7c39PzFV9Zw+8EeWoStjNAlhi4UwXRUtNhAqGusvpHzMX0omeCHYr8xSYOu/oDm0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:46 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:46 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 45/55] staging: wfx: device already handle sleep mode during
 scan
Thread-Topic: [PATCH 45/55] staging: wfx: device already handle sleep mode
 during scan
Thread-Index: AQHVtDLNZFmcvjicTUihGPRgdvbXow==
Date:   Mon, 16 Dec 2019 17:03:56 +0000
Message-ID: <20191216170302.29543-46-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: ac1298c0-62de-4204-1282-08d7824a54ef
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB41420AEC7F4B727823E18FD693510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kX60kCGfIMdrAv36ZYtYjSVKZ4T2BupHLzs4dS4UhKB1ewCP1BxDal01sZbLTT5klBUBNp+qxTCp8yUMrHjDR3LUPPHmyMCb13Yla9YDJFa04iYscb2Rkyt1M5TrO+Skl27MQQan1l8lPoLk5NLkOSOPeqGITxoHkDNUh9gwofBA2XnxONcDOAqkMqkH3H+3bxy/V45zxpQyIjIxq3k9G0ZmDPTtTpsPIBA7RbBvWKr700TEk+cLR3tV4Id7+183UVYu4sRtLnun7PtD2ONa2R331MxfoCzHldxVp5Clkdd7958adKy0JNNGUkt/wzIbudCE5uV/zD1U6hkrmJgPnk+CWtUHecZCRVIrOQ4JOOLuXFSZ40CBRAbmSy5X4ECFPCXWeJ7B9kcNJKukGWddcEOBTA4Nd0QtcfVQSHWLfRbKS+0joPK3ium3LqbWUNvc
Content-Type: text/plain; charset="utf-8"
Content-ID: <4BA983C751098F40992E3AEF590CD255@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1298c0-62de-4204-1282-08d7824a54ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:56.5829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VlU3UZvu+i7Vn5hD0vumFzq3uJW1HHGZ7BWUI7gOXjIafyr9RSMLMggLX7yoTMH/2s1OUbJpXqsFUQDlu/K4LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGUgZGV2aWNlIGlzIG5vdCBhbGxvd2VkIHRvIGVudGVyIGluIHNsZWVwIG1vZGUgZHVyaW5nIHNj
YW4uIEhvd2V2ZXIsDQp0aGlzIGlzIGFscmVhZHkgaGFuZGxlZCBieSB0aGUgZGV2aWNlLiBTbyBk
cml2ZXIgZG9lcyBub3QgaGF2ZSB0byBjYXJlDQphYm91dCBpdC4NCg0KU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KLS0tDQogZHJp
dmVycy9zdGFnaW5nL3dmeC9iaC5jICAgfCAzICstLQ0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nh
bi5jIHwgMyAtLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oICB8IDEgLQ0KIDMgZmlsZXMg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMNCmluZGV4
IDI0MzJiYTk1YzJmNS4uOTgzYzQxZDFmZTdjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9iaC5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMNCkBAIC0yNzEsOCArMjcx
LDcgQEAgc3RhdGljIHZvaWQgYmhfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQogDQog
CWlmIChsYXN0X29wX2lzX3J4KQ0KIAkJYWNrX3NkaW9fZGF0YSh3ZGV2KTsNCi0JaWYgKCF3ZGV2
LT5oaWYudHhfYnVmZmVyc191c2VkICYmICF3b3JrX3BlbmRpbmcod29yaykgJiYNCi0JICAgICFh
dG9taWNfcmVhZCgmd2Rldi0+c2Nhbl9pbl9wcm9ncmVzcykpIHsNCisJaWYgKCF3ZGV2LT5oaWYu
dHhfYnVmZmVyc191c2VkICYmICF3b3JrX3BlbmRpbmcod29yaykpIHsNCiAJCWRldmljZV9yZWxl
YXNlKHdkZXYpOw0KIAkJcmVsZWFzZV9jaGlwID0gdHJ1ZTsNCiAJfQ0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMNCmlu
ZGV4IGNkY2NiNjdjYjMwZS4uMzk3ZmU1MTFkMzRhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zY2FuLmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jDQpAQCAtNDQs
NyArNDQsNiBAQCBzdGF0aWMgaW50IHdmeF9zY2FuX3N0YXJ0KHN0cnVjdCB3ZnhfdmlmICp3dmlm
LCBzdHJ1Y3Qgd2Z4X3NjYW5fcGFyYW1zICpzY2FuKQ0KIAl0bW8gKz0gc2Nhbi0+c2Nhbl9yZXEu
bnVtX29mX2NoYW5uZWxzICoNCiAJICAgICAgICgoMjAgKiAoc2Nhbi0+c2Nhbl9yZXEubWF4X2No
YW5uZWxfdGltZSkpICsgMTApOw0KIAlhdG9taWNfc2V0KCZ3dmlmLT5zY2FuLmluX3Byb2dyZXNz
LCAxKTsNCi0JYXRvbWljX3NldCgmd3ZpZi0+d2Rldi0+c2Nhbl9pbl9wcm9ncmVzcywgMSk7DQog
DQogCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmd3ZpZi0+c2Nhbi50aW1lb3V0LCBtc2Vjc190b19q
aWZmaWVzKHRtbykpOw0KIAloaWZfc2Nhbih3dmlmLCBzY2FuKTsNCkBAIC0yMzIsOCArMjMxLDYg
QEAgdm9pZCB3Znhfc2Nhbl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiBzdGF0aWMg
dm9pZCB3Znhfc2Nhbl9jb21wbGV0ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikNCiB7DQogCXVwKCZ3
dmlmLT5zY2FuLmxvY2spOw0KLQlhdG9taWNfc2V0KCZ3dmlmLT53ZGV2LT5zY2FuX2luX3Byb2dy
ZXNzLCAwKTsNCi0NCiAJd2Z4X3NjYW5fd29yaygmd3ZpZi0+c2Nhbi53b3JrKTsNCiB9DQogDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvd2Z4LmgNCmluZGV4IGYzOTZhNTAyMjgzZS4uOTczNzNkMDQ3ZjU4IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaA0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93Zngu
aA0KQEAgLTYwLDcgKzYwLDYgQEAgc3RydWN0IHdmeF9kZXYgew0KIAlzdHJ1Y3QgbXV0ZXgJCXJ4
X3N0YXRzX2xvY2s7DQogDQogCWludAkJCW91dHB1dF9wb3dlcjsNCi0JYXRvbWljX3QJCXNjYW5f
aW5fcHJvZ3Jlc3M7DQogfTsNCiANCiBzdHJ1Y3Qgd2Z4X3ZpZiB7DQotLSANCjIuMjAuMQ0K
