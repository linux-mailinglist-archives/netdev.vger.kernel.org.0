Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635AB1210F6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLPRHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:07:38 -0500
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:54496
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727959AbfLPRHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:07:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfmYL7KkexCY/AHcJZ5B4lxu8cxKIr+vD34Lx8z4/LlEqDlf3UHS0pnBne0qLhaLbFMvf1vdhgqKzVn82vDn1x2Q4TLUr/Zr/i644+8dmJh0jH13EpaTf0wr+OVMMhRvoXPvlGJRjih6pT/vdvdYNJRT0hKrH2UsegQKXaZrhHIT/UVD1qBs9beOYxTBkM4+DU3bwKiF929PBxBomnYIVEWy669QAzL7c7qoQJGfU+l496GVqfUzjAaMnvw/2oqGjznnky+egMPdSkIx52nkZUO40+6dy9HLSmQj2nX7f8yV5WHqvmZMvxFHhIvlR+IDoPgrOGD056/3W1hJlZWv6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oNwcJ6JFnVAYIDsKxMxxqqBxKgUqaAbaPTJtjiXRf0=;
 b=J4Kphgdd5totQifgtwPIHYkjzHVhBFz/8GK4Bt1nzjuIC8bKkhsM1woYEGmH8+12ZeZ/zbEnVGe7LCEurj60YPl9WBeHRBG8E+6xBKMeotYEDVcidQhW21uFiYsghVoeUFt8xMRB2t2kvSkl8yxnc/i7+ZOpFh9zrz/J52i8pQvQfp/UXSsDu8orX8k/4ZvmbRQBe3qE0pVroceiSSg9mbThXlq9o8xxqINsrnfPytgi8qWZhhWw9Im8MNzn1BYwcHVgBmZF8Lrh36DbJoLMP77ut3aOMdsJ1BA74FZgbbUTnRpTHr9Xm30ZN9al673R65lgZjCak5GkIacuxmd1YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oNwcJ6JFnVAYIDsKxMxxqqBxKgUqaAbaPTJtjiXRf0=;
 b=gWmfX8O9HKHjHUSUpuHkkYXH8vG6XShP+AxzRVhPfDIgULBXPdy8dIiP7VzmoWT5Ww65gsYx3aTRDdabkFLbAN36/lS2k2V5lpOLcp+3YnY0CHItPV/pxvLMYfC+OzkYerOKH5YROkbApM4WOMGgpeaE4Hn++7bSQwWFIFow+Lk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4445.namprd11.prod.outlook.com (52.135.37.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 17:06:51 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:51 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 54/55] staging: wfx: implement cancel_hw_scan()
Thread-Topic: [PATCH 54/55] staging: wfx: implement cancel_hw_scan()
Thread-Index: AQHVtDLPXPNhCC/3cESry3OJ0NQnAA==
Date:   Mon, 16 Dec 2019 17:04:00 +0000
Message-ID: <20191216170302.29543-55-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 709a1898-24fc-46bb-b084-08d7824a57ed
x-ms-traffictypediagnostic: MN2PR11MB4445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4445E58CC58AB486D8C39D3093510@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:372;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(189003)(199004)(110136005)(6486002)(107886003)(36756003)(186003)(316002)(66946007)(54906003)(5660300002)(66574012)(66446008)(66556008)(85182001)(66476007)(76116006)(91956017)(64756008)(2616005)(6506007)(85202003)(2906002)(26005)(71200400001)(6512007)(4326008)(8936002)(81166006)(1076003)(478600001)(86362001)(81156014)(6666004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4445;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FEjuY9ilqLEyBH7voW+J3zvGlaztWDGFX4RXeTBlA4bFIJAjsfMDbn3Ltr9JlL4ijQoW827BRtat/FkTGaanbvrbOVtaRE/rAkdeiq81kRBJKsFuLvS1QhBC28aXEEtttm9GySSMHywODE0byDlbS7tqvXX8ooB7+2Oai7k+UoXZ9TCHDPxdj4ezUAu6ASdvaux70YlfFKhy34wYyScEWQpCCTD+G/eTTkyd37+0HUahVIiLuWdzp8dw6Evuv8tEsgXtkc5oJUp+qW9Zm/ZWqxIQqg7473yO4/sE0QaRYS7aeyjks9EBIBbl36PGcdpLUa8nWB6MrGriBC5kvNKHm0q+i3l304CI2oPoo/dpTn3shXinFoAEZ38BdepzAGaBgCEX/bmMj/gdKG3J8DdW9hD8UKegYptKvPEipn3HqZXkyBhcWxsRM50TMR1Oo1qz
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0327AC41E2D1A4293B3F31A719DDA9F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709a1898-24fc-46bb-b084-08d7824a57ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:04:00.6466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RSDaDw8EpTPbJYV4r+XYFF0zcU3Cvixm9VieUvk7qRvny98MB1SDcun3JeeYChuQ5dkHNuFj8Kk2ZobRJsweIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGUgZGV2aWNlIHByb3ZpZGVzIGFuIEFQSSB0byBhYm9ydCBhIHNjYW4gcmVxdWVzdC4gRXhwb3Nl
IHRoaXMgZmVhdHVyZQ0KdG8gbWFjODAyMTEuDQoNClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvbWFpbi5jIHwgIDEgKw0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIHwgMTMgKysr
KysrKysrKysrKw0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5oIHwgIDEgKw0KIGRyaXZlcnMv
c3RhZ2luZy93Zngvd2Z4LmggIHwgIDEgKw0KIDQgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9u
cygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L21haW4uYw0KaW5kZXggY2Y0YmNiMTRhMTJkLi40NWM5OTM5YjdlNjIgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYw0KKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9tYWluLmMNCkBAIC0xMzUsNiArMTM1LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBp
ZWVlODAyMTFfb3BzIHdmeF9vcHMgPSB7DQogCS50eAkJCT0gd2Z4X3R4LA0KIAkuY29uZl90eAkJ
PSB3ZnhfY29uZl90eCwNCiAJLmh3X3NjYW4JCT0gd2Z4X2h3X3NjYW4sDQorCS5jYW5jZWxfaHdf
c2NhbgkJPSB3ZnhfY2FuY2VsX2h3X3NjYW4sDQogCS5zdGFfYWRkCQk9IHdmeF9zdGFfYWRkLA0K
IAkuc3RhX3JlbW92ZQkJPSB3Znhfc3RhX3JlbW92ZSwNCiAJLnN0YV9ub3RpZnkJCT0gd2Z4X3N0
YV9ub3RpZnksDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYw0KaW5kZXggZGRlMmY4ODY4MTQ3Li4yNDA2MWQwOWM0MDQg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYw0KKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zY2FuLmMNCkBAIC01NCw2ICs1NCw3IEBAIHN0YXRpYyBpbnQgc2VuZF9zY2Fu
X3JlcShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwNCiAJCQlicmVhazsNCiAJfQ0KIAl3ZnhfdHhfbG9j
a19mbHVzaCh3dmlmLT53ZGV2KTsNCisJd3ZpZi0+c2Nhbl9hYm9ydCA9IGZhbHNlOw0KIAlyZWlu
aXRfY29tcGxldGlvbigmd3ZpZi0+c2Nhbl9jb21wbGV0ZSk7DQogCXJldCA9IGhpZl9zY2FuKHd2
aWYsIHJlcSwgc3RhcnRfaWR4LCBpIC0gc3RhcnRfaWR4KTsNCiAJaWYgKHJldCA8IDApDQpAQCAt
NjgsNiArNjksMTAgQEAgc3RhdGljIGludCBzZW5kX3NjYW5fcmVxKHN0cnVjdCB3ZnhfdmlmICp3
dmlmLA0KIAkJaGlmX3N0b3Bfc2Nhbih3dmlmKTsNCiAJCXJldHVybiAtRVRJTUVET1VUOw0KIAl9
DQorCWlmICh3dmlmLT5zY2FuX2Fib3J0KSB7DQorCQlkZXZfbm90aWNlKHd2aWYtPndkZXYtPmRl
diwgInNjYW4gYWJvcnRcbiIpOw0KKwkJcmV0dXJuIC1FQ09OTkFCT1JURUQ7DQorCX0NCiAJcmV0
dXJuIGkgLSBzdGFydF9pZHg7DQogfQ0KIA0KQEAgLTExNSw2ICsxMjAsMTQgQEAgaW50IHdmeF9o
d19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlm
LA0KIAlyZXR1cm4gMDsNCiB9DQogDQordm9pZCB3ZnhfY2FuY2VsX2h3X3NjYW4oc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpDQorew0KKwlzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+ZHJ2X3ByaXY7DQorDQorCXd2
aWYtPnNjYW5fYWJvcnQgPSB0cnVlOw0KKwloaWZfc3RvcF9zY2FuKHd2aWYpOw0KK30NCisNCiB2
b2lkIHdmeF9zY2FuX2NvbXBsZXRlKHN0cnVjdCB3ZnhfdmlmICp3dmlmLA0KIAkJICAgICAgIGNv
bnN0IHN0cnVjdCBoaWZfaW5kX3NjYW5fY21wbCAqYXJnKQ0KIHsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5oDQppbmRl
eCBiNTQ3ZjE5MjdkNzIuLmJiYTlmMTVhOWZmNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvc2Nhbi5oDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaA0KQEAgLTE4LDYg
KzE4LDcgQEAgc3RydWN0IHdmeF92aWY7DQogdm9pZCB3ZnhfaHdfc2Nhbl93b3JrKHN0cnVjdCB3
b3JrX3N0cnVjdCAqd29yayk7DQogaW50IHdmeF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcg
Kmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLA0KIAkJc3RydWN0IGllZWU4MDIxMV9zY2Fu
X3JlcXVlc3QgKnJlcSk7DQordm9pZCB3ZnhfY2FuY2VsX2h3X3NjYW4oc3RydWN0IGllZWU4MDIx
MV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpOw0KIHZvaWQgd2Z4X3NjYW5fY29t
cGxldGUoc3RydWN0IHdmeF92aWYgKnd2aWYsDQogCQkgICAgICAgY29uc3Qgc3RydWN0IGhpZl9p
bmRfc2Nhbl9jbXBsICppbmQpOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
d2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oDQppbmRleCBkYjQzM2JlZTg3YWYuLjBh
M2RmMzgyYWYwMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgNCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgNCkBAIC0xMjcsNiArMTI3LDcgQEAgc3RydWN0IHdm
eF92aWYgew0KIAlzdHJ1Y3QgbXV0ZXgJCXNjYW5fbG9jazsNCiAJc3RydWN0IHdvcmtfc3RydWN0
CXNjYW5fd29yazsNCiAJc3RydWN0IGNvbXBsZXRpb24Jc2Nhbl9jb21wbGV0ZTsNCisJYm9vbAkJ
CXNjYW5fYWJvcnQ7DQogCXN0cnVjdCBpZWVlODAyMTFfc2Nhbl9yZXF1ZXN0ICpzY2FuX3JlcTsN
CiANCiAJc3RydWN0IGNvbXBsZXRpb24Jc2V0X3BtX21vZGVfY29tcGxldGU7DQotLSANCjIuMjAu
MQ0K
