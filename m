Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F1E11C2F8
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 03:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfLLCIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 21:08:35 -0500
Received: from mail-eopbgr700134.outbound.protection.outlook.com ([40.107.70.134]:33632
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbfLLCIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 21:08:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnCa0IwCKm0L1if1AHGFMp8TSdFK5gz/3E/1YZafDSWjXtfdlSfzOh9n7cVzIJwUTVItfomJBik4cagTwdxvHYuX0O1F4YGBFucAl0i5RvyUW0qocm2/Y56eOD9pWtViwoCx9XU007jikyWbe80+DwK1LO8KQ6DI1GF2wdTkkPxHbACsyxZ4vT3rHE6bsgq2hzUP2GzzP3OMHO1nbzntYVCwhwbzoCHnBs5PDYLxDvKlk5hsUZIhHquuXV36zM0q/W+j4OUiUsJ3ypD8mjLcjeRi/q7VyeTod0GBA+4F5nkRxpJBkxQI/2/i85LN1qEZH9O3B9GF0G/ig+zm+9DqLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v2eXSfOQhx0zlPwFdzUO+mmPI4Y811QrahK7QUrrgU=;
 b=Vr/+ALtm+f3tf7PPT/Pk6ueM194m8zr4UC98JglFFwOyW9GadPC0HS6DVLSREd5QVeyVdqwlM5ETEi1Ph3C/2qHaxo+szfWkJj3t0ex0zt2mY47ry2dVKcasVPz6gb1JXSyaUg7tBcfR+pn9iQ489yI8vYtBOeyKE3mV4YVQuIuyKeTKqtKgvwj60enyKaAhAwA+QCnNPSNqU6sGyi7d50RgkqvPkcN6/LgGigdFnVX6oCpVgS+NGfhW2b6QRBYAMpLOHxVodGAQdkWrmOUvYF0qSf7APQtm6n7O1Za/U4f5+t9mnHoHcYeo9VcY5teH9RkHuOY2fFAYPSKxXprIgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v2eXSfOQhx0zlPwFdzUO+mmPI4Y811QrahK7QUrrgU=;
 b=MeNc3TEZTlVdilvsnpQShQWw09eHTMgAK4Oj3rcaoBrbv8oJcp2eVHPndcxHhkB97KvnJk31OAZbxPzM5B8QX3wM5zusrXyT106BMobR6lDTiVRmVJzS+diGfc9w6W8qW8ndtkJ3rPhmgWD3BDtoM/YZjeKIa+4UIBBXkAkeWFI=
Received: from CY4PR06MB2342.namprd06.prod.outlook.com (10.169.185.149) by
 CY4PR06MB2744.namprd06.prod.outlook.com (10.173.43.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Thu, 12 Dec 2019 02:07:52 +0000
Received: from CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d]) by CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d%3]) with mapi id 15.20.2538.016; Thu, 12 Dec 2019
 02:07:52 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Soeren Moch <smoch@web.de>, Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>
CC:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/9] brcmfmac: fix rambase for 4359/9
Thread-Topic: [PATCH v2 3/9] brcmfmac: fix rambase for 4359/9
Thread-Index: AQHVsH4n+6PxY2w0LUCHnMkA6uGdW6e1wOcA
Date:   Thu, 12 Dec 2019 02:07:52 +0000
Message-ID: <cdb13e17-64b5-8b58-db66-6827b86dbf39@cypress.com>
References: <20191211235253.2539-1-smoch@web.de>
 <20191211235253.2539-4-smoch@web.de>
In-Reply-To: <20191211235253.2539-4-smoch@web.de>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: BYAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::23) To CY4PR06MB2342.namprd06.prod.outlook.com
 (2603:10b6:903:13::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1209edcc-b422-4b3f-e9c3-08d77ea817ef
x-ms-traffictypediagnostic: CY4PR06MB2744:|CY4PR06MB2744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR06MB274429DDADD63295C4A99045BB550@CY4PR06MB2744.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39860400002)(366004)(136003)(376002)(189003)(199004)(26005)(2906002)(31696002)(71200400001)(110136005)(186003)(66946007)(2616005)(86362001)(31686004)(316002)(3450700001)(52116002)(5660300002)(54906003)(8676002)(6512007)(478600001)(53546011)(6506007)(4326008)(6486002)(66446008)(66556008)(81156014)(36756003)(64756008)(81166006)(8936002)(66476007)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR06MB2744;H:CY4PR06MB2342.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mapK05taLiXxdvnoUHgjkzvAZVaIBGd+BokBMic+pLMYMvSPBAOH57bQH8q/NbGXdd8aXN+pjMt+u9itPAAi0q1K263b/cjCdK7Q4hEtmLLEIPyoFBZ4leX6pLNS0JkQjEcSmTz2G6J32y3hyK1x7bT5Q04s6UNn/3x3Q8wnRqRhGLpULMYs8GzmxuCu3BNLsdFItwgKOEa6RswzbIkTY6PUn+zXh5e9mRLulWGeuoNfu3zQ8Gfgpg2vs8BH6kNWIUMT3EfVjK/jAScnW2tnp0Mn5JK6tDUOBRlhFgAl0kwavP5wkbLnkijbJpa4EoWN3F0243Civyz79IKpcYq8T96b0pvyKTPigmoRaL9FsBC5g0la2E5JzeoaW3y0UW1buJzf/8iPCBACmVLUpQFgryHLamA3vM5xSADtCp/EUoae7db6uEawimaqjmsHp9eV
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C4EC26E46EA7949B54C07F878B62F7B@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1209edcc-b422-4b3f-e9c3-08d77ea817ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 02:07:52.1327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ol8CgijY4n+EtmltmOL5X8/UBbu6enaC00H1jjrQn9dvMTCnVarYM25HtnmgWabT20anLWcW9/ne+Yr9uLecPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR06MB2744
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEyLzIwMTkgNzo1MiwgU29lcmVuIE1vY2ggd3JvdGU6DQo+IE5ld2VyIDQzNTkg
Y2hpcCByZXZpc2lvbnMgbmVlZCBhIGRpZmZlcmVudCByYW1iYXNlIGFkZHJlc3MuDQo+IFRoaXMg
Zml4ZXMgZmlybXdhcmUgZG93bmxvYWQgb24gc3VjaCBkZXZpY2VzIHdoaWNoIGZhaWxzIG90aGVy
d2lzZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNvZXJlbiBNb2NoIDxzbW9jaEB3ZWIuZGU+DQpB
Y2tlZC1ieTogQ2hpLUhzaWVuIExpbiA8Y2hpLWhzaWVuLmxpbkBjeXByZXNzLmNvbT4NCg0KPiAt
LS0NCj4gY2hhbmdlcyBpbiB2Mjogbm9uZQ0KPiANCj4gQ2M6IEthbGxlIFZhbG8gPGt2YWxvQGNv
ZGVhdXJvcmEub3JnPg0KPiBDYzogSGVpa28gU3R1ZWJuZXIgPGhlaWtvQHNudGVjaC5kZT4NCj4g
Q2M6IEFyZW5kIHZhbiBTcHJpZWwgPGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20+DQo+IENj
OiBGcmFua3kgTGluIDxmcmFua3kubGluQGJyb2FkY29tLmNvbT4NCj4gQ2M6IEhhbnRlIE1ldWxl
bWFuIDxoYW50ZS5tZXVsZW1hbkBicm9hZGNvbS5jb20+DQo+IENjOiBDaGktSHNpZW4gTGluIDxj
aGktaHNpZW4ubGluQGN5cHJlc3MuY29tPg0KPiBDYzogV3JpZ2h0IEZlbmcgPHdyaWdodC5mZW5n
QGN5cHJlc3MuY29tPg0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+IENj
OiBicmNtODAyMTEtZGV2LWxpc3QucGRsQGJyb2FkY29tLmNvbQ0KPiBDYzogYnJjbTgwMjExLWRl
di1saXN0QGN5cHJlc3MuY29tDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBs
aW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gQ2M6IGxpbnV4LXJvY2tjaGlw
QGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcN
Cj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21m
bWFjL2NoaXAuYyB8IDMgKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jy
b2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jaGlwLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9i
cm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5jDQo+IGluZGV4IDBiNWZiZTVkODI3MC4u
YmFmNzJlMzk4NGZjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNv
bS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jaGlwLmMNCj4gQEAgLTcxMiw3ICs3MTIsNiBA
QCBzdGF0aWMgdTMyIGJyY21mX2NoaXBfdGNtX3JhbWJhc2Uoc3RydWN0IGJyY21mX2NoaXBfcHJp
diAqY2kpDQo+ICAgCWNhc2UgQlJDTV9DQ180MzU2OV9DSElQX0lEOg0KPiAgIAljYXNlIEJSQ01f
Q0NfNDM1NzBfQ0hJUF9JRDoNCj4gICAJY2FzZSBCUkNNX0NDXzQzNThfQ0hJUF9JRDoNCj4gLQlj
YXNlIEJSQ01fQ0NfNDM1OV9DSElQX0lEOg0KPiAgIAljYXNlIEJSQ01fQ0NfNDM2MDJfQ0hJUF9J
RDoNCj4gICAJY2FzZSBCUkNNX0NDXzQzNzFfQ0hJUF9JRDoNCj4gICAJCXJldHVybiAweDE4MDAw
MDsNCj4gQEAgLTcyMiw2ICs3MjEsOCBAQCBzdGF0aWMgdTMyIGJyY21mX2NoaXBfdGNtX3JhbWJh
c2Uoc3RydWN0IGJyY21mX2NoaXBfcHJpdiAqY2kpDQo+ICAgCWNhc2UgQlJDTV9DQ180MzY2X0NI
SVBfSUQ6DQo+ICAgCWNhc2UgQlJDTV9DQ180MzY2NF9DSElQX0lEOg0KPiAgIAkJcmV0dXJuIDB4
MjAwMDAwOw0KPiArCWNhc2UgQlJDTV9DQ180MzU5X0NISVBfSUQ6DQo+ICsJCXJldHVybiAoY2kt
PnB1Yi5jaGlwcmV2IDwgOSkgPyAweDE4MDAwMCA6IDB4MTYwMDAwOw0KPiAgIAljYXNlIENZX0ND
XzQzNzNfQ0hJUF9JRDoNCj4gICAJCXJldHVybiAweDE2MDAwMDsNCj4gICAJZGVmYXVsdDoNCj4g
LS0NCj4gMi4xNy4xDQo+IA0KPiAuDQo+IA0K
