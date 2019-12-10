Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7154E117E3E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 04:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfLJDif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 22:38:35 -0500
Received: from mail-eopbgr680121.outbound.protection.outlook.com ([40.107.68.121]:24310
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726949AbfLJDid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 22:38:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBX0KkSxtkGUhGeavQdDdvkCdxAKxogOkgaWuNmL+UsfrFiURGtEQzbu1avdC56F+YpK0eE927vYk9KbQ2ujsKEgEY8MSI0ZVietat4HI9j7HZn1dbjr5wcy04/QVpo1rd4hWIA3/5bHwK3p0ZnmMv+fWIA+JCeFysY9LCvtq6sWQKP86Ek3BqPGaWlwifBq4dLnwAtFY50epkkqysz00ClYZUEYVTHxqWKu/Np/vOVxsJhrVkJKimKk2x9nnkUYhpY3nu6MsdIzU9DT9BKrcqiAfMDemyytqB68meFak4a3SuZoZFkjSEg/KoKoFVBDCXKHR0Ts4RrUwjuOiN8IKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAYXZAjtjhHewz5J6ruqtHfAyK/Y5SieaR2VZsjsnE0=;
 b=FTHAo1DY1Iq6bKRYw19Z7h7k0t16y3QWEIUhGRcAsnO3g9ZjjBoI/HvuskwP0GbhijpZ8zjJkVM40+D+JYrYOLvNt9KE83V9GaZtCE+svk63mFw25p+zT2ARgift0YfA1gD2KOlfNGpHINogDSbXwNhkBddxUbfdgUjtJtgVFK8E/7IqxJV5bCXnh4A6aiQBN71zoOUvkypSwdiACr6qt1aIQ/M7Y+BXnz+hfSrOaIoa88iJq9K7x55/Q2fCJVusS/oug+0Mrf0Ux07TgkMcZtk9xclso3UfZOIiC3bSDwtdNMNcjy4jN4NvfYtJbshyWF5Mz5xpSf1SxftD0I0u0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAYXZAjtjhHewz5J6ruqtHfAyK/Y5SieaR2VZsjsnE0=;
 b=jW1GvijoeGHxue16eCp3mBJuFl5g+2Nz0vJFm5Wn3UDdA3Ea3z73EQs48Stq4LfEdWmb10kdBTOX2S2P17exaJknup+7ZO4YVpjO1ktdxEcgm2h65CRGWFsPhe1lc7Wx4M43x/dpPZOixYGAxue/sm46sv/0ZfHsO7yBy8BwPTc=
Received: from CY4PR06MB2342.namprd06.prod.outlook.com (10.169.185.149) by
 CY4PR06MB2646.namprd06.prod.outlook.com (10.173.39.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 03:38:21 +0000
Received: from CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d]) by CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d%3]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 03:38:21 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Soeren Moch <smoch@web.de>, Kalle Valo <kvalo@codeaurora.org>
CC:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] brcmfmac: add support for BCM4359 SDIO chipset
Thread-Topic: [PATCH 5/8] brcmfmac: add support for BCM4359 SDIO chipset
Thread-Index: AQHVruFlfkvBDeTkE0yi8xRbnm7fIaeyuL+A
Date:   Tue, 10 Dec 2019 03:38:21 +0000
Message-ID: <ea33f5b2-0748-1837-ee59-5b00177f7f4e@cypress.com>
References: <20191209223822.27236-1-smoch@web.de>
 <20191209223822.27236-5-smoch@web.de>
In-Reply-To: <20191209223822.27236-5-smoch@web.de>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: BYAPR07CA0106.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::47) To CY4PR06MB2342.namprd06.prod.outlook.com
 (2603:10b6:903:13::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4cc91af1-1ea7-442b-6c75-08d77d22671c
x-ms-traffictypediagnostic: CY4PR06MB2646:|CY4PR06MB2646:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR06MB2646222BA693787550534FF1BB5B0@CY4PR06MB2646.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(189003)(199004)(8936002)(36756003)(6512007)(316002)(2906002)(2616005)(3450700001)(305945005)(31696002)(81166006)(4326008)(81156014)(66446008)(186003)(31686004)(8676002)(64756008)(53546011)(66556008)(66476007)(66946007)(6506007)(478600001)(54906003)(52116002)(26005)(110136005)(229853002)(86362001)(6486002)(5660300002)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR06MB2646;H:CY4PR06MB2342.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nRS8lq5OPUSGLPtdpMVzWpWUnpqm3rXl8uYthv1D3y72nt02jghQNOiuE+MmnfsZ46iKkIiVHZINnx5v2PR/n/0IhXGixT1mEqZG0pbWoUHYOwRMyWgY0Y5QjbIueGkLugdI3L0s8TufslB60+muhE8QtwC3+hKCwfGgZxldrPc3tsBRN9xyCoH0XloFWuM30zTqOCyT1SkpkmBUEx3IWMuzPN7/MYYuVNC7X4CdX319VGKbYrcW/M5W+wU7YY/soAwTBNJBrlHd/T6qOyVTk51qKTBFJ2NTz2GSUuMK8PJSKKEy2Y7Z3QDqX34lLlVO01kVEtR/DOUIbQT4Pd1GQO3YZGuVnjhH//1M9RfsipdWFvP8NqQuDfrW+9yH0L2hXgECoEIG3PmiR7mXAvDWvzc3dpK/feutcIRW14DgqOVABADwFhe7j0zeHECAT3v3
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B2535AB00606441AF7D5F8DDAEF0453@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cc91af1-1ea7-442b-6c75-08d77d22671c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 03:38:21.1839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ulc0axgKsUDfwT14g0C4zx4A6NLGDW1Uzk+k6sXinG0BdNF9EcUgTmnoO2zDjDEpvDMBvmYsm8A0NdsG+XKjIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR06MB2646
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEwLzIwMTkgNjozOCwgU29lcmVuIE1vY2ggd3JvdGU6DQo+IEJDTTQzNTkgaXMg
YSAyeDIgODAyLjExIGFiZ24rYWMgRHVhbC1CYW5kIEhUODAgY29tYm8gY2hpcCBhbmQgaXQNCj4g
c3VwcG9ydHMgUmVhbCBTaW11bHRhbmVvdXMgRHVhbCBCYW5kIGZlYXR1cmUuDQo+IA0KPiBCYXNl
ZCBvbiBhIHNpbWlsYXIgcGF0Y2ggYnk6IFdyaWdodCBGZW5nIDx3cmlnaHQuZmVuZ0BjeXByZXNz
LmNvbT4NCg0KSGkgU29lcmVuLA0KDQpJcyBpdCBwb3NzaWJsZSB0byBhbHNvIGtlZXAgdGhlIElE
IGluIHRoZSBvcmlnaW5hbCBwYXRjaCBmcm9tIFdyaWdodD8gDQpZb3UgY2FuIHVzZSBiZWxvdyBJ
RHMgYW5kIGFsbG93IGJvdGggdG8gYmUgc3VwcG9ydGVkOg0KDQojZGVmaW5lIFNESU9fREVWSUNF
X0lEX0JST0FEQ09NXzQzNTkJCTB4NDM1OQ0KI2RlZmluZSBTRElPX0RFVklDRV9JRF9DWV84OTM1
OQkJCTB4NDM1NQ0KDQoNCkNoaS1oc2llbiBMaW4NCg0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBT
b2VyZW4gTW9jaCA8c21vY2hAd2ViLmRlPg0KPiAtLS0NCj4gQ2M6IEthbGxlIFZhbG8gPGt2YWxv
QGNvZGVhdXJvcmEub3JnPg0KPiBDYzogQXJlbmQgdmFuIFNwcmllbCA8YXJlbmQudmFuc3ByaWVs
QGJyb2FkY29tLmNvbT4NCj4gQ2M6IEZyYW5reSBMaW4gPGZyYW5reS5saW5AYnJvYWRjb20uY29t
Pg0KPiBDYzogSGFudGUgTWV1bGVtYW4gPGhhbnRlLm1ldWxlbWFuQGJyb2FkY29tLmNvbT4NCj4g
Q2M6IENoaS1Ic2llbiBMaW4gPGNoaS1oc2llbi5saW5AY3lwcmVzcy5jb20+DQo+IENjOiBXcmln
aHQgRmVuZyA8d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+DQo+IENjOiBsaW51eC13aXJlbGVzc0B2
Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGJyY204MDIxMS1kZXYtbGlzdC5wZGxAYnJvYWRjb20uY29t
DQo+IENjOiBicmNtODAyMTEtZGV2LWxpc3RAY3lwcmVzcy5jb20NCj4gQ2M6IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+
ICAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNk
aC5jIHwgMSArDQo+ICAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2Jy
Y21mbWFjL2NoaXAuYyAgIHwgMSArDQo+ICAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20v
YnJjbTgwMjExL2JyY21mbWFjL3NkaW8uYyAgIHwgMiArKw0KPiAgIGluY2x1ZGUvbGludXgvbW1j
L3NkaW9faWRzLmggICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDEgKw0KPiAgIDQgZmls
ZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jDQo+IGlu
ZGV4IDY4YmFmMDE4OTMwNS4uNWI1N2QzN2NhZjE3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMNCj4gKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5j
DQo+IEBAIC05NzMsNiArOTczLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBzZGlvX2RldmljZV9p
ZCBicmNtZl9zZG1tY19pZHNbXSA9IHsNCj4gICAJQlJDTUZfU0RJT19ERVZJQ0UoU0RJT19ERVZJ
Q0VfSURfQlJPQURDT01fNDM0NTUpLA0KPiAgIAlCUkNNRl9TRElPX0RFVklDRShTRElPX0RFVklD
RV9JRF9CUk9BRENPTV80MzU0KSwNCj4gICAJQlJDTUZfU0RJT19ERVZJQ0UoU0RJT19ERVZJQ0Vf
SURfQlJPQURDT01fNDM1NiksDQo+ICsJQlJDTUZfU0RJT19ERVZJQ0UoU0RJT19ERVZJQ0VfSURf
QlJPQURDT01fNDM1OSksDQo+ICAgCUJSQ01GX1NESU9fREVWSUNFKFNESU9fREVWSUNFX0lEX0NZ
UFJFU1NfNDM3MyksDQo+ICAgCUJSQ01GX1NESU9fREVWSUNFKFNESU9fREVWSUNFX0lEX0NZUFJF
U1NfNDMwMTIpLA0KPiAgIAl7IC8qIGVuZDogYWxsIHplcm9lcyAqLyB9DQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NoaXAu
Yw0KPiBpbmRleCBiYWY3MmUzOTg0ZmMuLjI4MmQwYmMxNGU4ZSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NoaXAuYw0KPiAr
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hp
cC5jDQo+IEBAIC0xNDA4LDYgKzE0MDgsNyBAQCBib29sIGJyY21mX2NoaXBfc3JfY2FwYWJsZShz
dHJ1Y3QgYnJjbWZfY2hpcCAqcHViKQ0KPiAgIAkJYWRkciA9IENPUkVfQ0NfUkVHKGJhc2UsIHNy
X2NvbnRyb2wwKTsNCj4gICAJCXJlZyA9IGNoaXAtPm9wcy0+cmVhZDMyKGNoaXAtPmN0eCwgYWRk
cik7DQo+ICAgCQlyZXR1cm4gKHJlZyAmIENDX1NSX0NUTDBfRU5BQkxFX01BU0spICE9IDA7DQo+
ICsJY2FzZSBCUkNNX0NDXzQzNTlfQ0hJUF9JRDoNCj4gICAJY2FzZSBDWV9DQ180MzAxMl9DSElQ
X0lEOg0KPiAgIAkJYWRkciA9IENPUkVfQ0NfUkVHKHBtdS0+YmFzZSwgcmV0ZW50aW9uX2N0bCk7
DQo+ICAgCQlyZWcgPSBjaGlwLT5vcHMtPnJlYWQzMihjaGlwLT5jdHgsIGFkZHIpOw0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFj
L3NkaW8uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1h
Yy9zZGlvLmMNCj4gaW5kZXggMjFlNTM1MDcyZjNmLi5jNDAxMmVkNThiOWMgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9zZGlv
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21m
bWFjL3NkaW8uYw0KPiBAQCAtNjE2LDYgKzYxNiw3IEBAIEJSQ01GX0ZXX0RFRig0MzQ1NSwgImJy
Y21mbWFjNDM0NTUtc2RpbyIpOw0KPiAgIEJSQ01GX0ZXX0RFRig0MzQ1NiwgImJyY21mbWFjNDM0
NTYtc2RpbyIpOw0KPiAgIEJSQ01GX0ZXX0RFRig0MzU0LCAiYnJjbWZtYWM0MzU0LXNkaW8iKTsN
Cj4gICBCUkNNRl9GV19ERUYoNDM1NiwgImJyY21mbWFjNDM1Ni1zZGlvIik7DQo+ICtCUkNNRl9G
V19ERUYoNDM1OSwgImJyY21mbWFjNDM1OS1zZGlvIik7DQo+ICAgQlJDTUZfRldfREVGKDQzNzMs
ICJicmNtZm1hYzQzNzMtc2RpbyIpOw0KPiAgIEJSQ01GX0ZXX0RFRig0MzAxMiwgImJyY21mbWFj
NDMwMTItc2RpbyIpOw0KPiANCj4gQEAgLTYzOCw2ICs2MzksNyBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IGJyY21mX2Zpcm13YXJlX21hcHBpbmcgYnJjbWZfc2Rpb19md25hbWVzW10gPSB7DQo+ICAg
CUJSQ01GX0ZXX0VOVFJZKEJSQ01fQ0NfNDM0NV9DSElQX0lELCAweEZGRkZGREMwLCA0MzQ1NSks
DQo+ICAgCUJSQ01GX0ZXX0VOVFJZKEJSQ01fQ0NfNDM1NF9DSElQX0lELCAweEZGRkZGRkZGLCA0
MzU0KSwNCj4gICAJQlJDTUZfRldfRU5UUlkoQlJDTV9DQ180MzU2X0NISVBfSUQsIDB4RkZGRkZG
RkYsIDQzNTYpLA0KPiArCUJSQ01GX0ZXX0VOVFJZKEJSQ01fQ0NfNDM1OV9DSElQX0lELCAweEZG
RkZGRkZGLCA0MzU5KSwNCj4gICAJQlJDTUZfRldfRU5UUlkoQ1lfQ0NfNDM3M19DSElQX0lELCAw
eEZGRkZGRkZGLCA0MzczKSwNCj4gICAJQlJDTUZfRldfRU5UUlkoQ1lfQ0NfNDMwMTJfQ0hJUF9J
RCwgMHhGRkZGRkZGRiwgNDMwMTIpDQo+ICAgfTsNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGlu
dXgvbW1jL3NkaW9faWRzLmggYi9pbmNsdWRlL2xpbnV4L21tYy9zZGlvX2lkcy5oDQo+IGluZGV4
IDA4YjI1YzAyYjVhMS4uOTMwZWYyZDgyNjRhIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4
L21tYy9zZGlvX2lkcy5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvbW1jL3NkaW9faWRzLmgNCj4g
QEAgLTQxLDYgKzQxLDcgQEANCj4gICAjZGVmaW5lIFNESU9fREVWSUNFX0lEX0JST0FEQ09NXzQz
NDU1CQkweGE5YmYNCj4gICAjZGVmaW5lIFNESU9fREVWSUNFX0lEX0JST0FEQ09NXzQzNTQJCTB4
NDM1NA0KPiAgICNkZWZpbmUgU0RJT19ERVZJQ0VfSURfQlJPQURDT01fNDM1NgkJMHg0MzU2DQo+
ICsjZGVmaW5lIFNESU9fREVWSUNFX0lEX0JST0FEQ09NXzQzNTkJCTB4NDM1OQ0KPiAgICNkZWZp
bmUgU0RJT19ERVZJQ0VfSURfQ1lQUkVTU180MzczCQkweDQzNzMNCj4gICAjZGVmaW5lIFNESU9f
REVWSUNFX0lEX0NZUFJFU1NfNDMwMTIJCTQzMDEyDQo+IA0KPiAtLQ0KPiAyLjE3LjENCj4gDQo+
IC4NCj4gDQo=
