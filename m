Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BD21323C4
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 11:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgAGKgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 05:36:50 -0500
Received: from mail-eopbgr1300088.outbound.protection.outlook.com ([40.107.130.88]:24357
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727177AbgAGKgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 05:36:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNgWMNmOV48RY33i0Rz+f7NJePhYWBDbLUWlMr0f9Xr8mhJoljzMUu3nwHnfCGY/VVqmRCpvgGXRHks0hDyug0wiwxnupcy+7/NsqclgiNut0T90x0b8CMiKq0VAkt2TaAVv214OUpQuI4Ao8kYJhvG7ykykq639Pwl4T5ey6RPJyUXXrY6qzOFdbi7yYvARztgSQPXDjgcPM6dcQQV9W++sxGp2xMczVhjxtgRW0x61VQYXk6BIt2gXYOp8YQemmxjYvlg8Xp4eqF5ujNQD2xGeTXcCCcWlrdiTUWcjpdA2PhhW2JQdSPl30R353zDDIdsYDg3OYjzopARszgJSzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0c5/WYGz9G8ArXu0vMPKixciEGA9knY2xxArGqom5E=;
 b=Su+pXmax4yugu2xH7ZUdkTn8iyIy7LhM9u67CENq6XOZ3hxc+enVGyNITGbYUGBaKuLuPw3ARtG+FcAPNETMG47hon2Tc/Ssvm+10jlwWijzHkpPZN1qCbz6LmxueOvEYmCLmktRiX/HBRMo11qrdOVk01z0OQMvXdd3sZofZdcYi7EYy8KRYDco9TuGKkGQtnwf1GV6m27UDAyNmMBKeCcWHBj5yLUALqI4DtED7V9Q5bmI7XiUv/VeGBJ/NTQf5VgWE2gsWQhdifhOT6fgF6qMuukOJgvxWHX+t+iKZRM2JoubYppJZHPd3WKo06j/WPc/F7uI/NpB/asnzK7Dhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=moxa.com; dmarc=pass action=none header.from=moxa.com;
 dkim=pass header.d=moxa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Moxa.onmicrosoft.com;
 s=selector2-Moxa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0c5/WYGz9G8ArXu0vMPKixciEGA9knY2xxArGqom5E=;
 b=P+hMrKfIGzHM2bl0sipXnob7fuoTpAzpEdMok9aK0nE6eYgpE/UpH6WDLIAPks/NpZz/urgiRrZH+a2BmHhztdqW5D01dj6siWjum0XRbGHecRXLCFRzipTPVcC80vSp6dSUFwa5gmUhYcLHeheTU05D+bdgDhmXUl1Y30w259Y=
Received: from HK0PR01MB3521.apcprd01.prod.exchangelabs.com (52.132.237.22) by
 HK0PR01MB2961.apcprd01.prod.exchangelabs.com (20.177.161.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Tue, 7 Jan 2020 10:36:32 +0000
Received: from HK0PR01MB3521.apcprd01.prod.exchangelabs.com
 ([fe80::3433:35cd:2be4:d042]) by HK0PR01MB3521.apcprd01.prod.exchangelabs.com
 ([fe80::3433:35cd:2be4:d042%6]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 10:36:32 +0000
From:   =?utf-8?B?Sm9obnNvbiBDSCBDaGVuICjpmbPmmK3li7Mp?= 
        <JohnsonCH.Chen@moxa.com>
To:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     =?utf-8?B?Sm9obnNvbiBDSCBDaGVuICjpmbPmmK3li7Mp?= 
        <JohnsonCH.Chen@moxa.com>,
        "zero19850401@gmail.com" <zero19850401@gmail.com>
Subject: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
Thread-Topic: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
Thread-Index: AdXFRAcg+ooT8TPrTsG92JEuKMTbqw==
Date:   Tue, 7 Jan 2020 10:36:32 +0000
Message-ID: <HK0PR01MB3521C806FE109E04FA72858CFA3F0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=JohnsonCH.Chen@moxa.com; 
x-originating-ip: [122.146.92.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a8d7325-7540-4fcc-ddc1-08d7935d76a8
x-ms-traffictypediagnostic: HK0PR01MB2961:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HK0PR01MB2961FE148405062FFEA66227FA3F0@HK0PR01MB2961.apcprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(366004)(39850400004)(189003)(199004)(2906002)(85182001)(478600001)(33656002)(9686003)(186003)(55016002)(7696005)(6506007)(66946007)(66556008)(66446008)(26005)(66476007)(76116006)(64756008)(4326008)(316002)(54906003)(110136005)(81166006)(8676002)(8936002)(52536014)(71200400001)(81156014)(5660300002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:HK0PR01MB2961;H:HK0PR01MB3521.apcprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: moxa.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: spfxqYrnaT5I1oISQPnXR7/aI2xgkRezDd864+PvYIwsOJPlC8i/wsUV3zYRdRBSZUR7YfpvpWc7Tz8Sr7vHdeDct0H4ae0ZthMNhf5XEfBUV59ReT8R5ym3O7ogP2gmzP25BxfAS+SzYZWreu75ZPqeQsbaUd9GhF9wZacgGZYZoIdY3xS/l4U23tQTWJgfU2lAfcXizEXrdZGIHRxs0/d4syTG1kLEKpe1IJQb/TEfCWCDh/Ap6CPjCXi0yVwaEkOhukVgesd/zyQdHW0K82q/M3Wb+ldUVm/eclUNb3QiNVVsgq4be/OVWcuN2XS8d9edD/uLAcZHcr+3RqqgPNDUTskT3QHhOyeU7KgbUKl0cYqCfjx0h6Lea+0r+hyDh9gf/3xfBu+PIMZJDPtNkIoX5kT6l4viF026gXN4ZIT3h6qahWAGSUwVaG+8YXVM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: moxa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8d7325-7540-4fcc-ddc1-08d7935d76a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 10:36:32.7125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5571c7d4-286b-47f6-9dd5-0aa688773c8e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sd4RddkRX8+7OxEMb8Ty5ZKVRQJBiAxDgX/QWDzRDa5BbgPseExZ4YGhp1mAXpBk29+lnZ/BvUdp2JlzctqcYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR01MB2961
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkIGRtYV9lbmRpYW5fbGUgdG8gc29sdmUgZXRoZXJuZXQgVFgvUlggcHJvYmxlbXMgZm9yIGZy
ZWVzY2FsZSBsczEwMjFhLiBXaXRob3V0IHRoaXMsIGl0IHdpbGwgcmVzdWx0IGluIA0KcngtYnVz
eS1lcnJvcnMgYnkgZXRodG9vbCwgYW5kIHRyYW5zbWl0IHF1ZXVlIHRpbWVvdXQgaW4gbHMxMDIx
YSdzIHBsYXRmb3Jtcy4NCg0KU2lnbmVkLW9mZi1ieTogSm9obnNvbiBDaGVuIDxqb2huc29uY2gu
Y2hlbkBtb3hhLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9naWFu
ZmFyLmMgfCAzICsrKw0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9naWFuZmFyLmgg
fCA0ICsrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuYyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9naWFuZmFyLmMNCmluZGV4IDcyODY4YTI4YjYyMS4uYWI0ZTQ1
MTk5ZGY5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5m
YXIuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuYw0KQEAg
LTgzMyw2ICs4MzMsNyBAQCBzdGF0aWMgaW50IGdmYXJfb2ZfaW5pdChzdHJ1Y3QgcGxhdGZvcm1f
ZGV2aWNlICpvZmRldiwgc3RydWN0IG5ldF9kZXZpY2UgKipwZGV2KQ0KIA0KIAkvKiBGaW5kIHRo
ZSBUQkkgUEhZLiAgSWYgaXQncyBub3QgdGhlcmUsIHdlIGRvbid0IHN1cHBvcnQgU0dNSUkgKi8N
CiAJcHJpdi0+dGJpX25vZGUgPSBvZl9wYXJzZV9waGFuZGxlKG5wLCAidGJpLWhhbmRsZSIsIDAp
Ow0KKwlwcml2LT5kbWFfZW5kaWFuX2xlID0gb2ZfcHJvcGVydHlfcmVhZF9ib29sKG5wLCAiZnNs
LGRtYS1lbmRpYW4tbGUiKTsNCiANCiAJcmV0dXJuIDA7DQogDQpAQCAtMTIwOSw2ICsxMjEwLDgg
QEAgc3RhdGljIHZvaWQgZ2Zhcl9zdGFydChzdHJ1Y3QgZ2Zhcl9wcml2YXRlICpwcml2KQ0KIAkv
KiBJbml0aWFsaXplIERNQUNUUkwgdG8gaGF2ZSBXV1IgYW5kIFdPUCAqLw0KIAl0ZW1wdmFsID0g
Z2Zhcl9yZWFkKCZyZWdzLT5kbWFjdHJsKTsNCiAJdGVtcHZhbCB8PSBETUFDVFJMX0lOSVRfU0VU
VElOR1M7DQorCWlmIChwcml2LT5kbWFfZW5kaWFuX2xlKQ0KKwkJdGVtcHZhbCB8PSBETUFDVFJM
X0xFOw0KIAlnZmFyX3dyaXRlKCZyZWdzLT5kbWFjdHJsLCB0ZW1wdmFsKTsNCiANCiAJLyogTWFr
ZSBzdXJlIHdlIGFyZW4ndCBzdG9wcGVkICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9naWFuZmFyLmgNCmluZGV4IDQzMmM2YTgxOGFlNS4uYWFlMDdkYjUyMDZiIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuaA0KKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuaA0KQEAgLTIxNSw2ICsyMTUsNyBAQCBl
eHRlcm4gY29uc3QgY2hhciBnZmFyX2RyaXZlcl92ZXJzaW9uW107DQogI2RlZmluZSBETUFDVFJM
X0lOSVRfU0VUVElOR1MgICAweDAwMDAwMGMzDQogI2RlZmluZSBETUFDVFJMX0dSUyAgICAgICAg
ICAgICAweDAwMDAwMDEwDQogI2RlZmluZSBETUFDVFJMX0dUUyAgICAgICAgICAgICAweDAwMDAw
MDA4DQorI2RlZmluZSBETUFDVFJMX0xFCQkweDAwMDA4MDAwDQogDQogI2RlZmluZSBUU1RBVF9D
TEVBUl9USEFMVF9BTEwJMHhGRjAwMDAwMA0KICNkZWZpbmUgVFNUQVRfQ0xFQVJfVEhBTFQJMHg4
MDAwMDAwMA0KQEAgLTExNDAsNiArMTE0MSw5IEBAIHN0cnVjdCBnZmFyX3ByaXZhdGUgew0KIAkJ
dHhfcGF1c2VfZW46MSwNCiAJCXJ4X3BhdXNlX2VuOjE7DQogDQorCS8qIGxpdHRsZSBlbmRpYW4g
ZG1hIGJ1ZmZlciBhbmQgZGVzY3JpcHRvciBob3N0IGludGVyZmFjZSAqLw0KKwl1bnNpZ25lZCBp
bnQgZG1hX2VuZGlhbl9sZTsNCisNCiAJLyogVGhlIHRvdGFsIHR4IGFuZCByeCByaW5nIHNpemUg
Zm9yIHRoZSBlbmFibGVkIHF1ZXVlcyAqLw0KIAl1bnNpZ25lZCBpbnQgdG90YWxfdHhfcmluZ19z
aXplOw0KIAl1bnNpZ25lZCBpbnQgdG90YWxfcnhfcmluZ19zaXplOw0KLS0gDQoyLjExLjANCg0K
QmVzdCByZWdhcmRzLA0KSm9obnNvbg0K
