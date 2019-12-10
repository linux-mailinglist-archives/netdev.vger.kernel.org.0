Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7EF7118083
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 07:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfLJGeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 01:34:04 -0500
Received: from mail-bn7nam10on2127.outbound.protection.outlook.com ([40.107.92.127]:42849
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726819AbfLJGeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 01:34:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9krGrtgoPzrfRlhuAki0T9sWKhKqi1sLc6Cr7p/tmva3UUdvA4EvUvjkhpq/QIVY2OY6z1fMXlzOyAcpYa8lhh0veNbjcyrHPg/vVzog+KK8VeHATvIaswh1/vukyKrDLyfE21Kfq/dJp89V72Lt9sxfJkzsxOgg1zFcN8S4RRdkVET3YKMrFHKEQXEuud7mJE2ZGcAkmjCWz+tLshpuKHS890WKlxV+E/EDkUYXoG6MFXMoQvsiHwRWWAgO4mFo4SfzZkyDZvjj61wUUo6cD1neubqf0jp3pfKEbpgvsjmKnCu6lYzNj4bwkg6tiI3fI8d3lORhwlaaioTpsh/aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8u/UBYDXUn+KsHSwbG9OWvB2oyltIvci925bX2Z30sQ=;
 b=WNby/WbN4SK4ebkXATtZdEvV13idcl3wVt217MyyzXbJVvfWdeD1TqSWF4S1YSUnUcUBNOfoFbBZgd0a7/ZOpcYJ96+ZfYlGIV09gk5uVEAB3gRP+acZcn8TPGfWnwCnKK5vrn52nNlSm9ghUdWKFppfsV4lkcAbdS7UXtl+IJh1Vhc0lDUqh12BvzzVYHNZ60bKa36i5j7Kx5mNMjFADxgT+5ou049txVUq+tbffWkAAl69KB7BZ0toG/YhoUfvFH3E5670hTmubZO4KLnObYBCWqIAKH82y6Lr5w/1ggol0TkOnCFprX78siNNOLuPwbHWYpG2zZew6sxQWZ+l5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8u/UBYDXUn+KsHSwbG9OWvB2oyltIvci925bX2Z30sQ=;
 b=OR5n+BXHFCWvzADxlv1OqQ/B+ydcxnPE+UTiw2iTyzmDc+2vzsvyDrbY/jdQjbzunXnwWP2EFcKePRfjYU9BVTk1dCzAelhYo0I9zxc5dkHE6JyIQw6B15DpjI7JNFzn0SyCJwdAo6JMgrGyZ5jhFoO1oHu7t4TnRPY8jYUNYBo=
Received: from CY4PR06MB2342.namprd06.prod.outlook.com (10.169.185.149) by
 CY4PR06MB2615.namprd06.prod.outlook.com (10.173.39.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 06:32:20 +0000
Received: from CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d]) by CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d%3]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 06:32:20 +0000
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
Thread-Index: AQHVruFlfkvBDeTkE0yi8xRbnm7fIaeyuL+AgAAwmgA=
Date:   Tue, 10 Dec 2019 06:32:20 +0000
Message-ID: <1910862f-2564-6252-535c-8916e6c5e150@cypress.com>
References: <20191209223822.27236-1-smoch@web.de>
 <20191209223822.27236-5-smoch@web.de>
 <ea33f5b2-0748-1837-ee59-5b00177f7f4e@cypress.com>
In-Reply-To: <ea33f5b2-0748-1837-ee59-5b00177f7f4e@cypress.com>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: BYAPR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:a03:40::44) To CY4PR06MB2342.namprd06.prod.outlook.com
 (2603:10b6:903:13::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ffa0587-7e60-48e7-c705-08d77d3ab53e
x-ms-traffictypediagnostic: CY4PR06MB2615:|CY4PR06MB2615:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR06MB261569E295E4B74DC9AFA8D3BB5B0@CY4PR06MB2615.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(39860400002)(396003)(376002)(189003)(199004)(66946007)(81166006)(6506007)(64756008)(110136005)(316002)(54906003)(52116002)(66556008)(305945005)(66476007)(478600001)(2906002)(36756003)(4326008)(6512007)(31696002)(8936002)(26005)(31686004)(86362001)(6486002)(186003)(53546011)(81156014)(5660300002)(3450700001)(229853002)(8676002)(2616005)(71190400001)(66446008)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR06MB2615;H:CY4PR06MB2342.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1yvJDlPQhyz6Ph/ehtYjybycRKG713zcVMO6VzzIGC4dgccFPYAeK0W225xnlnN3Sb9izFzajLfFegqD4Gql/qjqn0Bhf2oSEbRM/PzUE8TM8LU2CJhKomPihEuEoZ1DpHDpOrk++zrcHJlzjAHP8wRrCNEFyESfp79YTPAaeO0X+m+XoW2DeIVdKJjQhLxsgT23JjiGKcHjI2HosaLpSIoeYjsX3Js+0YgrBSJOxltBqM9sz1sVeLAdpwr17TwIZvxRGCc7OY5Lpi8pqw/FYehG6X4h4M0Iz92q6MGXh+X5I3+VIcNJDuIzz1mz6pi+z+n5FCCfWYRr/jerD78jG24fb1Spj+K8BlVhP1+x4Mn+3r7l2PVGW1pvMlULczFM7G8D0YNo4imo2pfhN9glSNQlF69wR3JedVgy99WXR3udLRWFzOavaxrUFJ8GwdkG
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D430A696CA03B4385319B5EC59E73D7@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ffa0587-7e60-48e7-c705-08d77d3ab53e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 06:32:20.3247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mo+7qGIXnlt2Ot8+R7qbT3x0FonmfETH6e+b0AFTNGmGk01UNQDNuVJLmvM+26sY2eef88IErGDxqzmQnt/QnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR06MB2615
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEwLzIwMTkgMTE6MzgsIENoaS1Ic2llbiBMaW4gd3JvdGU6DQo+IA0KPiANCj4g
T24gMTIvMTAvMjAxOSA2OjM4LCBTb2VyZW4gTW9jaCB3cm90ZToNCj4+IEJDTTQzNTkgaXMgYSAy
eDIgODAyLjExIGFiZ24rYWMgRHVhbC1CYW5kIEhUODAgY29tYm8gY2hpcCBhbmQgaXQNCj4+IHN1
cHBvcnRzIFJlYWwgU2ltdWx0YW5lb3VzIER1YWwgQmFuZCBmZWF0dXJlLg0KPj4NCj4+IEJhc2Vk
IG9uIGEgc2ltaWxhciBwYXRjaCBieTogV3JpZ2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJlc3Mu
Y29tPg0KPiANCj4gSGkgU29lcmVuLA0KPiANCj4gSXMgaXQgcG9zc2libGUgdG8gYWxzbyBrZWVw
IHRoZSBJRCBpbiB0aGUgb3JpZ2luYWwgcGF0Y2ggZnJvbSBXcmlnaHQ/DQo+IFlvdSBjYW4gdXNl
IGJlbG93IElEcyBhbmQgYWxsb3cgYm90aCB0byBiZSBzdXBwb3J0ZWQ6DQo+IA0KPiAjZGVmaW5l
IFNESU9fREVWSUNFX0lEX0JST0FEQ09NXzQzNTkJCTB4NDM1OQ0KPiAjZGVmaW5lIFNESU9fREVW
SUNFX0lEX0NZXzg5MzU5CQkJMHg0MzU1DQoNCkZpeCBhIHR5cG8uIFRoZSBJRCBzaG91bGQgYmUN
Cg0KI2RlZmluZSBTRElPX0RFVklDRV9JRF9DWVBSRVNTXzg5MzU5CQkJMHg0MzU1DQoNCk5vdGUg
dGhhdCBicmNtZl9zZG1tY19pZHNbXSBhbHNvIG5lZWRzIGFuIGVudHJ5IGZvciB0aGUgYWJvdmUg
SUQuIFRoZSANCmNoaXBpZCByZWZlcmVuY2VzIGNhbiByZW1haW4gdW5jaGFuZ2VkLg0KDQpDaGkt
aHNpZW4gTGluDQoNCj4gDQo+IA0KPiBDaGktaHNpZW4gTGluDQo+IA0KPiANCj4+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBTb2VyZW4gTW9jaCA8c21vY2hAd2ViLmRlPg0KPj4gLS0tDQo+PiBDYzogS2Fs
bGUgVmFsbyA8a3ZhbG9AY29kZWF1cm9yYS5vcmc+DQo+PiBDYzogQXJlbmQgdmFuIFNwcmllbCA8
YXJlbmQudmFuc3ByaWVsQGJyb2FkY29tLmNvbT4NCj4+IENjOiBGcmFua3kgTGluIDxmcmFua3ku
bGluQGJyb2FkY29tLmNvbT4NCj4+IENjOiBIYW50ZSBNZXVsZW1hbiA8aGFudGUubWV1bGVtYW5A
YnJvYWRjb20uY29tPg0KPj4gQ2M6IENoaS1Ic2llbiBMaW4gPGNoaS1oc2llbi5saW5AY3lwcmVz
cy5jb20+DQo+PiBDYzogV3JpZ2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0KPj4g
Q2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZw0KPj4gQ2M6IGJyY204MDIxMS1kZXYt
bGlzdC5wZGxAYnJvYWRjb20uY29tDQo+PiBDYzogYnJjbTgwMjExLWRldi1saXN0QGN5cHJlc3Mu
Y29tDQo+PiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPj4gQ2M6IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmcNCj4+IC0tLQ0KPj4gICAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRj
b20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jIHwgMSArDQo+PiAgICBkcml2ZXJzL25ldC93
aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5jICAgfCAxICsNCj4+ICAg
IGRyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9zZGlvLmMg
ICB8IDIgKysNCj4+ICAgIGluY2x1ZGUvbGludXgvbW1jL3NkaW9faWRzLmggICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8IDEgKw0KPj4gICAgNCBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20v
YnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRj
b20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jDQo+PiBpbmRleCA2OGJhZjAxODkzMDUuLjVi
NTdkMzdjYWYxNyAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29t
L2JyY204MDIxMS9icmNtZm1hYy9iY21zZGguYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2JjbXNkaC5jDQo+PiBAQCAtOTczLDYgKzk3
Myw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc2Rpb19kZXZpY2VfaWQgYnJjbWZfc2RtbWNfaWRz
W10gPSB7DQo+PiAgICAJQlJDTUZfU0RJT19ERVZJQ0UoU0RJT19ERVZJQ0VfSURfQlJPQURDT01f
NDM0NTUpLA0KPj4gICAgCUJSQ01GX1NESU9fREVWSUNFKFNESU9fREVWSUNFX0lEX0JST0FEQ09N
XzQzNTQpLA0KPj4gICAgCUJSQ01GX1NESU9fREVWSUNFKFNESU9fREVWSUNFX0lEX0JST0FEQ09N
XzQzNTYpLA0KPj4gKwlCUkNNRl9TRElPX0RFVklDRShTRElPX0RFVklDRV9JRF9CUk9BRENPTV80
MzU5KSwNCj4+ICAgIAlCUkNNRl9TRElPX0RFVklDRShTRElPX0RFVklDRV9JRF9DWVBSRVNTXzQz
NzMpLA0KPj4gICAgCUJSQ01GX1NESU9fREVWSUNFKFNESU9fREVWSUNFX0lEX0NZUFJFU1NfNDMw
MTIpLA0KPj4gICAgCXsgLyogZW5kOiBhbGwgemVyb2VzICovIH0NCj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NoaXAuYw0K
Pj4gaW5kZXggYmFmNzJlMzk4NGZjLi4yODJkMGJjMTRlOGUgMTAwNjQ0DQo+PiAtLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5jDQo+PiAr
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hp
cC5jDQo+PiBAQCAtMTQwOCw2ICsxNDA4LDcgQEAgYm9vbCBicmNtZl9jaGlwX3NyX2NhcGFibGUo
c3RydWN0IGJyY21mX2NoaXAgKnB1YikNCj4+ICAgIAkJYWRkciA9IENPUkVfQ0NfUkVHKGJhc2Us
IHNyX2NvbnRyb2wwKTsNCj4+ICAgIAkJcmVnID0gY2hpcC0+b3BzLT5yZWFkMzIoY2hpcC0+Y3R4
LCBhZGRyKTsNCj4+ICAgIAkJcmV0dXJuIChyZWcgJiBDQ19TUl9DVEwwX0VOQUJMRV9NQVNLKSAh
PSAwOw0KPj4gKwljYXNlIEJSQ01fQ0NfNDM1OV9DSElQX0lEOg0KPj4gICAgCWNhc2UgQ1lfQ0Nf
NDMwMTJfQ0hJUF9JRDoNCj4+ICAgIAkJYWRkciA9IENPUkVfQ0NfUkVHKHBtdS0+YmFzZSwgcmV0
ZW50aW9uX2N0bCk7DQo+PiAgICAJCXJlZyA9IGNoaXAtPm9wcy0+cmVhZDMyKGNoaXAtPmN0eCwg
YWRkcik7DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJj
bTgwMjExL2JyY21mbWFjL3NkaW8uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2Jy
Y204MDIxMS9icmNtZm1hYy9zZGlvLmMNCj4+IGluZGV4IDIxZTUzNTA3MmYzZi4uYzQwMTJlZDU4
YjljIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgw
MjExL2JyY21mbWFjL3NkaW8uYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRj
b20vYnJjbTgwMjExL2JyY21mbWFjL3NkaW8uYw0KPj4gQEAgLTYxNiw2ICs2MTYsNyBAQCBCUkNN
Rl9GV19ERUYoNDM0NTUsICJicmNtZm1hYzQzNDU1LXNkaW8iKTsNCj4+ICAgIEJSQ01GX0ZXX0RF
Rig0MzQ1NiwgImJyY21mbWFjNDM0NTYtc2RpbyIpOw0KPj4gICAgQlJDTUZfRldfREVGKDQzNTQs
ICJicmNtZm1hYzQzNTQtc2RpbyIpOw0KPj4gICAgQlJDTUZfRldfREVGKDQzNTYsICJicmNtZm1h
YzQzNTYtc2RpbyIpOw0KPj4gK0JSQ01GX0ZXX0RFRig0MzU5LCAiYnJjbWZtYWM0MzU5LXNkaW8i
KTsNCj4+ICAgIEJSQ01GX0ZXX0RFRig0MzczLCAiYnJjbWZtYWM0MzczLXNkaW8iKTsNCj4+ICAg
IEJSQ01GX0ZXX0RFRig0MzAxMiwgImJyY21mbWFjNDMwMTItc2RpbyIpOw0KPj4NCj4+IEBAIC02
MzgsNiArNjM5LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBicmNtZl9maXJtd2FyZV9tYXBwaW5n
IGJyY21mX3NkaW9fZnduYW1lc1tdID0gew0KPj4gICAgCUJSQ01GX0ZXX0VOVFJZKEJSQ01fQ0Nf
NDM0NV9DSElQX0lELCAweEZGRkZGREMwLCA0MzQ1NSksDQo+PiAgICAJQlJDTUZfRldfRU5UUlko
QlJDTV9DQ180MzU0X0NISVBfSUQsIDB4RkZGRkZGRkYsIDQzNTQpLA0KPj4gICAgCUJSQ01GX0ZX
X0VOVFJZKEJSQ01fQ0NfNDM1Nl9DSElQX0lELCAweEZGRkZGRkZGLCA0MzU2KSwNCj4+ICsJQlJD
TUZfRldfRU5UUlkoQlJDTV9DQ180MzU5X0NISVBfSUQsIDB4RkZGRkZGRkYsIDQzNTkpLA0KPj4g
ICAgCUJSQ01GX0ZXX0VOVFJZKENZX0NDXzQzNzNfQ0hJUF9JRCwgMHhGRkZGRkZGRiwgNDM3Myks
DQo+PiAgICAJQlJDTUZfRldfRU5UUlkoQ1lfQ0NfNDMwMTJfQ0hJUF9JRCwgMHhGRkZGRkZGRiwg
NDMwMTIpDQo+PiAgICB9Ow0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW1jL3NkaW9f
aWRzLmggYi9pbmNsdWRlL2xpbnV4L21tYy9zZGlvX2lkcy5oDQo+PiBpbmRleCAwOGIyNWMwMmI1
YTEuLjkzMGVmMmQ4MjY0YSAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbGludXgvbW1jL3NkaW9f
aWRzLmgNCj4+ICsrKyBiL2luY2x1ZGUvbGludXgvbW1jL3NkaW9faWRzLmgNCj4+IEBAIC00MSw2
ICs0MSw3IEBADQo+PiAgICAjZGVmaW5lIFNESU9fREVWSUNFX0lEX0JST0FEQ09NXzQzNDU1CQkw
eGE5YmYNCj4+ICAgICNkZWZpbmUgU0RJT19ERVZJQ0VfSURfQlJPQURDT01fNDM1NAkJMHg0MzU0
DQo+PiAgICAjZGVmaW5lIFNESU9fREVWSUNFX0lEX0JST0FEQ09NXzQzNTYJCTB4NDM1Ng0KPj4g
KyNkZWZpbmUgU0RJT19ERVZJQ0VfSURfQlJPQURDT01fNDM1OQkJMHg0MzU5DQo+PiAgICAjZGVm
aW5lIFNESU9fREVWSUNFX0lEX0NZUFJFU1NfNDM3MwkJMHg0MzczDQo+PiAgICAjZGVmaW5lIFNE
SU9fREVWSUNFX0lEX0NZUFJFU1NfNDMwMTIJCTQzMDEyDQo+Pg0KPj4gLS0NCj4+IDIuMTcuMQ0K
Pj4NCj4+IC4NCj4+DQo=
