Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4EA11C2FF
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 03:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfLLCJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 21:09:33 -0500
Received: from mail-bn8nam11on2104.outbound.protection.outlook.com ([40.107.236.104]:35009
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727544AbfLLCJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 21:09:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzM0fO89vWLiIWqMOoPZCGnpsvcxwQMB8ZBAe0+PrwJ9twVjFcvz85BH36MiFeZu1uCCdk+RjXSg4vGjjYL9/Ep98o4S9fwVu/9eXj7DQtu+GBhxY/cQO8NvwHtqM/IcDO8soXKukIpYUvxYCjb1OdC3UoiWhSWojeC6i9u9eEtfg2nstGN3hi5J6PaQ+PvsnYLKpxZsRjRNxb5w9MFu0xpTw40BJm5+qKC+VEsSe9X8YhzgX59J2CtO+UYzWHnYaICDWgzjliQROUOgZQvgQPty0rnohS5vE6HzFEcRlrIBwYN25hKNWE/LdzYyrKn8xC/CPvv5g/zFoutJl48XGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHiZTNeI65E0iLQsAvO4Q3wcixqFRMxhZPw05gDywOk=;
 b=M1EqJDZKpB3otTSUsr1WrhM1zzNVwoj2RGl/Dd7r9NSRK/kaO5OSvgJ0+LMzxbvtrV1/sRJDR0Hshi+ingrkqkopoHDnFTO2z4XFZfMqUphAjLolskM1O9HUGvqb2ATOrR0SAc9oMAzxTjVwxkBqz/BsTexr2qP384QKKNxCsHcZ5Da299fb8tYipH0upzZ6GcAU3QSv84zLf6yFks6w52xeMuvRJwDt85V/QkTaBjXomx42Q/V7FvHJP1GmEVYyDI2R4KdY+SYBtD15MGJwvAsogYQKhnEsEzcUn8DaH2+NlWoGTk5N6MdBda2WV6+tYSgdM7amYaEem5IXdW33Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHiZTNeI65E0iLQsAvO4Q3wcixqFRMxhZPw05gDywOk=;
 b=g6zUDcH74zh+uGBD22yaSWixydQtCTPzLrUVkgDgqMDRkiBkm8XKt9eQhS06UMlgTQetU3HlOe23py/LMQWFuWd76v0wquNsNpx/AqLNLAw+1+i5PmD/3Iz4rqZ2sCgaA9+KD26yw5P17W/jEQ9YRi0HXbxHr1D6Bgp2nK4jGkw=
Received: from CY4PR06MB2342.namprd06.prod.outlook.com (10.169.185.149) by
 CY4PR06MB2744.namprd06.prod.outlook.com (10.173.43.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Thu, 12 Dec 2019 02:09:29 +0000
Received: from CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d]) by CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d%3]) with mapi id 15.20.2538.016; Thu, 12 Dec 2019
 02:09:28 +0000
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
Subject: Re: [PATCH v2 5/9] brcmfmac: add support for BCM4359 SDIO chipset
Thread-Topic: [PATCH v2 5/9] brcmfmac: add support for BCM4359 SDIO chipset
Thread-Index: AQHVsH4pHxrVVVvksEaPoTtqwTa5Cae1wVuA
Date:   Thu, 12 Dec 2019 02:09:28 +0000
Message-ID: <2e831af2-ed4a-7512-bdbd-c2582630db42@cypress.com>
References: <20191211235253.2539-1-smoch@web.de>
 <20191211235253.2539-6-smoch@web.de>
In-Reply-To: <20191211235253.2539-6-smoch@web.de>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: BY5PR20CA0004.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::17) To CY4PR06MB2342.namprd06.prod.outlook.com
 (2603:10b6:903:13::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cefe8352-d833-4c7f-9314-08d77ea8517d
x-ms-traffictypediagnostic: CY4PR06MB2744:|CY4PR06MB2744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR06MB27443601EFB67FD0B47C9FF9BB550@CY4PR06MB2744.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39860400002)(366004)(136003)(376002)(189003)(199004)(26005)(2906002)(31696002)(71200400001)(110136005)(186003)(66946007)(2616005)(86362001)(31686004)(316002)(3450700001)(52116002)(5660300002)(54906003)(8676002)(6512007)(478600001)(53546011)(6506007)(4326008)(6486002)(66446008)(66556008)(81156014)(36756003)(64756008)(81166006)(8936002)(66476007)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR06MB2744;H:CY4PR06MB2342.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tg1Vi/eQNYbNAiQxzPAMZPTQXWtpKbqqX5c4sYQGMvqhbmAz2rtOyEgtwgSo7d6ItbH7RfoyGEgELHT4lwmYg/X0yLTn073elv7QNqayPjt+SBHL8HPZLltpS5YTFOjc1la7u4ErYuWQUY64449JyBIcCoHmZ1UtHgaakJjyKZmgJM1nt9FymFpaAEwgaH1jedxy5FBUdCzPTMFWHoCT6ZGYJH65InKNPnSgLY+lP3LyvQP5K+R4sMeRkXdQr/gTg0KyTuk0Zo88v2wUSXDY4yj7l6yE8yFAF6NxLmX2afkBDS/9XZO2OvqIi+Os407mg3EsXs7XSE0AFHhgHZFqGIOZd42rnKaQ21e9h8fU7AkUbLr2lqUNUPCw+z6iLJFApOjd1pdM/KzXW5cK/0nvnKl4sp9EKmXQTVxqIeoLbVFGx+wzz5Gt7c+C2EE/0EdX
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A8FAA12A2CEB649A47F36332995AD74@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cefe8352-d833-4c7f-9314-08d77ea8517d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 02:09:28.8001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pV0iHjls9inNyg7fhyw+r9wVq9dx7dlMkzNNUm5oo1SA88iCj3vODW+c2kpWc0QnOGvMbX6sAF+ZozR0/t0cLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR06MB2744
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEyLzIwMTkgNzo1MiwgU29lcmVuIE1vY2ggd3JvdGU6DQo+IEJDTTQzNTkgaXMg
YSAyeDIgODAyLjExIGFiZ24rYWMgRHVhbC1CYW5kIEhUODAgY29tYm8gY2hpcCBhbmQgaXQNCj4g
c3VwcG9ydHMgUmVhbCBTaW11bHRhbmVvdXMgRHVhbCBCYW5kIGZlYXR1cmUuDQo+IA0KPiBCYXNl
ZCBvbiBhIHNpbWlsYXIgcGF0Y2ggYnk6IFdyaWdodCBGZW5nIDx3cmlnaHQuZmVuZ0BjeXByZXNz
LmNvbT4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNvZXJlbiBNb2NoIDxzbW9jaEB3ZWIuZGU+DQpB
Y2tlZC1ieTogQ2hpLUhzaWVuIExpbiA8Y2hpLWhzaWVuLmxpbkBjeXByZXNzLmNvbT4NCg0KPiAt
LS0NCj4gY2hhbmdlcyBpbiB2MjoNCj4gLSBhZGQgU0RJT19ERVZJQ0VfSURfQ1lQUkVTU184OTM1
OSBhcyByZXF1ZXN0ZWQNCj4gICAgYnkgQ2hpLUhzaWVuIExpbiA8Y2hpLWhzaWVuLmxpbkBjeXBy
ZXNzLmNvbT4NCj4gDQo+IENjOiBLYWxsZSBWYWxvIDxrdmFsb0Bjb2RlYXVyb3JhLm9yZz4NCj4g
Q2M6IEhlaWtvIFN0dWVibmVyIDxoZWlrb0BzbnRlY2guZGU+DQo+IENjOiBBcmVuZCB2YW4gU3By
aWVsIDxhcmVuZC52YW5zcHJpZWxAYnJvYWRjb20uY29tPg0KPiBDYzogRnJhbmt5IExpbiA8ZnJh
bmt5LmxpbkBicm9hZGNvbS5jb20+DQo+IENjOiBIYW50ZSBNZXVsZW1hbiA8aGFudGUubWV1bGVt
YW5AYnJvYWRjb20uY29tPg0KPiBDYzogQ2hpLUhzaWVuIExpbiA8Y2hpLWhzaWVuLmxpbkBjeXBy
ZXNzLmNvbT4NCj4gQ2M6IFdyaWdodCBGZW5nIDx3cmlnaHQuZmVuZ0BjeXByZXNzLmNvbT4NCj4g
Q2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPiBDYzogYnJjbTgwMjExLWRldi1s
aXN0LnBkbEBicm9hZGNvbS5jb20NCj4gQ2M6IGJyY204MDIxMS1kZXYtbGlzdEBjeXByZXNzLmNv
bQ0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogbGludXgtYXJtLWtlcm5lbEBs
aXN0cy5pbmZyYWRlYWQub3JnDQo+IENjOiBsaW51eC1yb2NrY2hpcEBsaXN0cy5pbmZyYWRlYWQu
b3JnDQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IC0tLQ0KPiAgIGRyaXZl
cnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9iY21zZGguYyB8IDIg
KysNCj4gICBkcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMv
Y2hpcC5jICAgfCAxICsNCj4gICBkcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAy
MTEvYnJjbWZtYWMvc2Rpby5jICAgfCAyICsrDQo+ICAgaW5jbHVkZS9saW51eC9tbWMvc2Rpb19p
ZHMuaCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMiArKw0KPiAgIDQgZmlsZXMgY2hh
bmdlZCwgNyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jDQo+IGluZGV4IDY4
YmFmMDE4OTMwNS4uZjRjNTNhYjQ2MDU4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvYmNtc2RoLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jDQo+IEBA
IC05NzMsOCArOTczLDEwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc2Rpb19kZXZpY2VfaWQgYnJj
bWZfc2RtbWNfaWRzW10gPSB7DQo+ICAgCUJSQ01GX1NESU9fREVWSUNFKFNESU9fREVWSUNFX0lE
X0JST0FEQ09NXzQzNDU1KSwNCj4gICAJQlJDTUZfU0RJT19ERVZJQ0UoU0RJT19ERVZJQ0VfSURf
QlJPQURDT01fNDM1NCksDQo+ICAgCUJSQ01GX1NESU9fREVWSUNFKFNESU9fREVWSUNFX0lEX0JS
T0FEQ09NXzQzNTYpLA0KPiArCUJSQ01GX1NESU9fREVWSUNFKFNESU9fREVWSUNFX0lEX0JST0FE
Q09NXzQzNTkpLA0KPiAgIAlCUkNNRl9TRElPX0RFVklDRShTRElPX0RFVklDRV9JRF9DWVBSRVNT
XzQzNzMpLA0KPiAgIAlCUkNNRl9TRElPX0RFVklDRShTRElPX0RFVklDRV9JRF9DWVBSRVNTXzQz
MDEyKSwNCj4gKwlCUkNNRl9TRElPX0RFVklDRShTRElPX0RFVklDRV9JRF9DWVBSRVNTXzg5MzU5
KSwNCj4gICAJeyAvKiBlbmQ6IGFsbCB6ZXJvZXMgKi8gfQ0KPiAgIH07DQo+ICAgTU9EVUxFX0RF
VklDRV9UQUJMRShzZGlvLCBicmNtZl9zZG1tY19pZHMpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NoaXAuYyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jaGlwLmMNCj4gaW5k
ZXggYmFmNzJlMzk4NGZjLi4yODJkMGJjMTRlOGUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jaGlwLmMNCj4gKysrIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NoaXAuYw0KPiBA
QCAtMTQwOCw2ICsxNDA4LDcgQEAgYm9vbCBicmNtZl9jaGlwX3NyX2NhcGFibGUoc3RydWN0IGJy
Y21mX2NoaXAgKnB1YikNCj4gICAJCWFkZHIgPSBDT1JFX0NDX1JFRyhiYXNlLCBzcl9jb250cm9s
MCk7DQo+ICAgCQlyZWcgPSBjaGlwLT5vcHMtPnJlYWQzMihjaGlwLT5jdHgsIGFkZHIpOw0KPiAg
IAkJcmV0dXJuIChyZWcgJiBDQ19TUl9DVEwwX0VOQUJMRV9NQVNLKSAhPSAwOw0KPiArCWNhc2Ug
QlJDTV9DQ180MzU5X0NISVBfSUQ6DQo+ICAgCWNhc2UgQ1lfQ0NfNDMwMTJfQ0hJUF9JRDoNCj4g
ICAJCWFkZHIgPSBDT1JFX0NDX1JFRyhwbXUtPmJhc2UsIHJldGVudGlvbl9jdGwpOw0KPiAgIAkJ
cmVnID0gY2hpcC0+b3BzLT5yZWFkMzIoY2hpcC0+Y3R4LCBhZGRyKTsNCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9zZGlvLmMg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvc2Rpby5j
DQo+IGluZGV4IDIxZTUzNTA3MmYzZi4uYzQwMTJlZDU4YjljIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvc2Rpby5jDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9zZGlv
LmMNCj4gQEAgLTYxNiw2ICs2MTYsNyBAQCBCUkNNRl9GV19ERUYoNDM0NTUsICJicmNtZm1hYzQz
NDU1LXNkaW8iKTsNCj4gICBCUkNNRl9GV19ERUYoNDM0NTYsICJicmNtZm1hYzQzNDU2LXNkaW8i
KTsNCj4gICBCUkNNRl9GV19ERUYoNDM1NCwgImJyY21mbWFjNDM1NC1zZGlvIik7DQo+ICAgQlJD
TUZfRldfREVGKDQzNTYsICJicmNtZm1hYzQzNTYtc2RpbyIpOw0KPiArQlJDTUZfRldfREVGKDQz
NTksICJicmNtZm1hYzQzNTktc2RpbyIpOw0KPiAgIEJSQ01GX0ZXX0RFRig0MzczLCAiYnJjbWZt
YWM0MzczLXNkaW8iKTsNCj4gICBCUkNNRl9GV19ERUYoNDMwMTIsICJicmNtZm1hYzQzMDEyLXNk
aW8iKTsNCj4gDQo+IEBAIC02MzgsNiArNjM5LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBicmNt
Zl9maXJtd2FyZV9tYXBwaW5nIGJyY21mX3NkaW9fZnduYW1lc1tdID0gew0KPiAgIAlCUkNNRl9G
V19FTlRSWShCUkNNX0NDXzQzNDVfQ0hJUF9JRCwgMHhGRkZGRkRDMCwgNDM0NTUpLA0KPiAgIAlC
UkNNRl9GV19FTlRSWShCUkNNX0NDXzQzNTRfQ0hJUF9JRCwgMHhGRkZGRkZGRiwgNDM1NCksDQo+
ICAgCUJSQ01GX0ZXX0VOVFJZKEJSQ01fQ0NfNDM1Nl9DSElQX0lELCAweEZGRkZGRkZGLCA0MzU2
KSwNCj4gKwlCUkNNRl9GV19FTlRSWShCUkNNX0NDXzQzNTlfQ0hJUF9JRCwgMHhGRkZGRkZGRiwg
NDM1OSksDQo+ICAgCUJSQ01GX0ZXX0VOVFJZKENZX0NDXzQzNzNfQ0hJUF9JRCwgMHhGRkZGRkZG
RiwgNDM3MyksDQo+ICAgCUJSQ01GX0ZXX0VOVFJZKENZX0NDXzQzMDEyX0NISVBfSUQsIDB4RkZG
RkZGRkYsIDQzMDEyKQ0KPiAgIH07DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21tYy9z
ZGlvX2lkcy5oIGIvaW5jbHVkZS9saW51eC9tbWMvc2Rpb19pZHMuaA0KPiBpbmRleCAwOGIyNWMw
MmI1YTEuLjJlOWE2ZTQ2MzRlYiAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9tbWMvc2Rp
b19pZHMuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L21tYy9zZGlvX2lkcy5oDQo+IEBAIC00MSw4
ICs0MSwxMCBAQA0KPiAgICNkZWZpbmUgU0RJT19ERVZJQ0VfSURfQlJPQURDT01fNDM0NTUJCTB4
YTliZg0KPiAgICNkZWZpbmUgU0RJT19ERVZJQ0VfSURfQlJPQURDT01fNDM1NAkJMHg0MzU0DQo+
ICAgI2RlZmluZSBTRElPX0RFVklDRV9JRF9CUk9BRENPTV80MzU2CQkweDQzNTYNCj4gKyNkZWZp
bmUgU0RJT19ERVZJQ0VfSURfQlJPQURDT01fNDM1OQkJMHg0MzU5DQo+ICAgI2RlZmluZSBTRElP
X0RFVklDRV9JRF9DWVBSRVNTXzQzNzMJCTB4NDM3Mw0KPiAgICNkZWZpbmUgU0RJT19ERVZJQ0Vf
SURfQ1lQUkVTU180MzAxMgkJNDMwMTINCj4gKyNkZWZpbmUgU0RJT19ERVZJQ0VfSURfQ1lQUkVT
U184OTM1OQkJMHg0MzU1DQo+IA0KPiAgICNkZWZpbmUgU0RJT19WRU5ET1JfSURfSU5URUwJCQkw
eDAwODkNCj4gICAjZGVmaW5lIFNESU9fREVWSUNFX0lEX0lOVEVMX0lXTUMzMjAwV0lNQVgJMHgx
NDAyDQo+IC0tDQo+IDIuMTcuMQ0KPiANCj4gLg0KPiANCg==
