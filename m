Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2BD117E45
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 04:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfLJDix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 22:38:53 -0500
Received: from mail-eopbgr760134.outbound.protection.outlook.com ([40.107.76.134]:50702
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbfLJDiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 22:38:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsgCCYSAW5nCper7Lek6RAKMbXTXwgIBCuWpae3cuXlC2ZKTBtHfj46hfsNH6NV7QlbVcxazRMH3LfhiKZXAgrl6ZxVbT6fZVQGvlPB0SugZG1/ZS98a0nGggan4mpdDiU7aRA6vUKgxj8n/qXUS6zlcLXpWAgeDQIEYPm4oKjtOIrZ1EO9h629q32DA2BHH+ZLsJxf47+r88t4PFUhdHxpj7rAi3YBiKPl3MswPCgTUzvcO8YXHuvcu3zDImXL4xZyfW2ORSU6cMM28V2ad2M5/zVTJenEv4Qo68QTMUHCCunpu8olhiJgrmYYfHQZ3Czy6Zby1m8xNKukADAhg4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gseAeF8dkjh3XAnUpCusJ9Ao4ZSawpghEgEbPTUqGUo=;
 b=FBIZur2EjL9VtmUmKIL8iY6UeYFWtckhPPxiHROL7T+jMcgSx3ZzLHAtAt6DWRWSHrYEgQHNGOfS2jgGEw+o16GwOWW/BiFOyMNx0nb9NEyWMvm7mbpjzpPoZi3diCYO+8SizniJacOL5qFNvIVVpiWcfMyRQW0smiVQB9H4kf1KBUj5jDxncC8ghhCz0LPQ4G2UOja2aEwQZlQjlNvSg2CTrQSMbSayGywrjHZMokDuNCUUTyXapflJPlhcAiIUIieTCNczbnvudq/rWVo0EBCzPFcFbFkwK0kNlaH6+kTiGGQx93seKJACjl3LUQbSx3wWfi6s2zAhsLPUnbKl5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gseAeF8dkjh3XAnUpCusJ9Ao4ZSawpghEgEbPTUqGUo=;
 b=aI6CeI3hFN/E3OCSk++woIrsBWNzCeRv82OWBj5hf7vCVrIL7WPnBNmVa+f5SGu8HhvoSLSL+9AwI39vupRpW5STTltLP+pT0+qa+Wtuh10VY497DyvoZtePX+76dLEQVWifYK7VXfFuT4Kj74i9ZZXPbNhSfq0cI8IT2Di9fpA=
Received: from CY4PR06MB2342.namprd06.prod.outlook.com (10.169.185.149) by
 CY4PR06MB2646.namprd06.prod.outlook.com (10.173.39.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 03:38:50 +0000
Received: from CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d]) by CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d%3]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 03:38:50 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Soeren Moch <smoch@web.de>, Kalle Valo <kvalo@codeaurora.org>
CC:     Wright Feng <Wright.Feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] brcmfmac: not set mbss in vif if firmware does not
 support MBSS
Thread-Topic: [PATCH 7/8] brcmfmac: not set mbss in vif if firmware does not
 support MBSS
Thread-Index: AQHVruFnE5ZtPOnIokeEuM3r07JPBqeyuOOA
Date:   Tue, 10 Dec 2019 03:38:50 +0000
Message-ID: <89a80994-cfb8-f720-7d8e-c571ac65569b@cypress.com>
References: <20191209223822.27236-1-smoch@web.de>
 <20191209223822.27236-7-smoch@web.de>
In-Reply-To: <20191209223822.27236-7-smoch@web.de>
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
x-ms-office365-filtering-correlation-id: 0e9e149b-3d80-4063-6a7d-08d77d2278a3
x-ms-traffictypediagnostic: CY4PR06MB2646:|CY4PR06MB2646:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR06MB26464B25D6EDB79BD81B61EBBB5B0@CY4PR06MB2646.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(189003)(199004)(8936002)(36756003)(6512007)(316002)(2906002)(2616005)(3450700001)(305945005)(31696002)(81166006)(4326008)(81156014)(66446008)(186003)(31686004)(8676002)(64756008)(53546011)(66556008)(66476007)(66946007)(6506007)(478600001)(54906003)(52116002)(26005)(110136005)(229853002)(86362001)(6486002)(5660300002)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR06MB2646;H:CY4PR06MB2342.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8IMMxnaoHZqYEthViKHLKaT6Na3+M/3v5ficoudv2to2yqtd+UnI0zA4uLLuFrkMPOKR+9/P/zj00wLQqFNT8rJ4TjFaWoR8bZCELSM6suXFgIn2tr/XrPHcAa28lSUdEkE2oal2TGw/2eh2jVyxNB/PReM862VnYKmHdz7E9P45d5yrguDKMSyZmv7CT/z+Lp9PqdW4av7kAY8qLQPl2qzNUiiRXd8lKSPVbLmmq4pHadCTcQmp12Wb8FXSeeMGBpDl6H891JCVTPM/uP2t7y1ea0d5UgInR0/aPWiDVZpFnZcik56FSWMrjdDYQ3tmrG6p2jcq5+RtF3P/nk1DBAEEA3T3l+ADjBVHpTPPBGR/wk/t0Icn4m7Rc86eYwlm8MrByTzxgQHoRMt3D2joXx4lDGzzsXmfdv4u5aqeUj3K/SaKQIHAHmOFm9VuMMet
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8D54E20EE0D104F8E23C076C66578FD@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e9e149b-3d80-4063-6a7d-08d77d2278a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 03:38:50.6208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i4R9Cx1OGMp1QsE87y9WReabydISdXrE/+Rcnd7p/3HP6fSsmDqRsDgsfIvUO8KIspgASSRZyH/vBMQJ1valWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR06MB2646
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEwLzIwMTkgNjozOCwgU29lcmVuIE1vY2ggd3JvdGU6DQo+IEZyb206IFdyaWdo
dCBGZW5nIDx3cmlnaHQuZmVuZ0BjeXByZXNzLmNvbT4NCj4gDQo+IFdpdGggUlNEQiBtb2RlLCBG
TUFDIGFuZCBmaXJtd2FyZSBhcmUgYWJsZSB0byBjcmVhdGUgMiBvciBtb3JlIEFQLA0KPiBzbyB3
ZSBzaG91bGQgbm90IHNldCBtYnNzIGluIHZpZiBzdHJ1Y3R1cmUgaWYgZmlybXdhcmUgZG9lcyBu
b3QNCj4gc3VwcG9ydCBNQlNTIGZlYXR1cmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBXcmlnaHQg
RmVuZyA8d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+DQpSZXZpZXdlZC1ieTogQ2hpLUhzaWVuIExp
biA8Y2hpLWhzaWVuLmxpbkBjeXByZXNzLmNvbT4NCg0KPiAtLS0NCj4gQ2M6IEthbGxlIFZhbG8g
PGt2YWxvQGNvZGVhdXJvcmEub3JnPg0KPiBDYzogQXJlbmQgdmFuIFNwcmllbCA8YXJlbmQudmFu
c3ByaWVsQGJyb2FkY29tLmNvbT4NCj4gQ2M6IEZyYW5reSBMaW4gPGZyYW5reS5saW5AYnJvYWRj
b20uY29tPg0KPiBDYzogSGFudGUgTWV1bGVtYW4gPGhhbnRlLm1ldWxlbWFuQGJyb2FkY29tLmNv
bT4NCj4gQ2M6IENoaS1Ic2llbiBMaW4gPGNoaS1oc2llbi5saW5AY3lwcmVzcy5jb20+DQo+IENj
OiBXcmlnaHQgRmVuZyA8d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+DQo+IENjOiBsaW51eC13aXJl
bGVzc0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGJyY204MDIxMS1kZXYtbGlzdC5wZGxAYnJvYWRj
b20uY29tDQo+IENjOiBicmNtODAyMTEtZGV2LWxpc3RAY3lwcmVzcy5jb20NCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
LS0tDQo+ICAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFj
L2NmZzgwMjExLmMgfCA0ICsrKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYw0KPiBpbmRleCA5ZDlk
YzkxOTVlOWUuLjZlYjMwNjRjMzcyMSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMNCj4g
QEAgLTUzNjMsNiArNTM2Myw3IEBAIHN0cnVjdCBicmNtZl9jZmc4MDIxMV92aWYgKmJyY21mX2Fs
bG9jX3ZpZihzdHJ1Y3QgYnJjbWZfY2ZnODAyMTFfaW5mbyAqY2ZnLA0KPiAgIAlzdHJ1Y3QgYnJj
bWZfY2ZnODAyMTFfdmlmICp2aWZfd2FsazsNCj4gICAJc3RydWN0IGJyY21mX2NmZzgwMjExX3Zp
ZiAqdmlmOw0KPiAgIAlib29sIG1ic3M7DQo+ICsJc3RydWN0IGJyY21mX2lmICppZnAgPSBicmNt
Zl9nZXRfaWZwKGNmZy0+cHViLCAwKTsNCj4gDQo+ICAgCWJyY21mX2RiZyhUUkFDRSwgImFsbG9j
YXRpbmcgdmlydHVhbCBpbnRlcmZhY2UgKHNpemU9JXp1KVxuIiwNCj4gICAJCSAgc2l6ZW9mKCp2
aWYpKTsNCj4gQEAgLTUzNzUsNyArNTM3Niw4IEBAIHN0cnVjdCBicmNtZl9jZmc4MDIxMV92aWYg
KmJyY21mX2FsbG9jX3ZpZihzdHJ1Y3QgYnJjbWZfY2ZnODAyMTFfaW5mbyAqY2ZnLA0KPiANCj4g
ICAJYnJjbWZfaW5pdF9wcm9mKCZ2aWYtPnByb2ZpbGUpOw0KPiANCj4gLQlpZiAodHlwZSA9PSBO
TDgwMjExX0lGVFlQRV9BUCkgew0KPiArCWlmICh0eXBlID09IE5MODAyMTFfSUZUWVBFX0FQICYm
DQo+ICsJICAgIGJyY21mX2ZlYXRfaXNfZW5hYmxlZChpZnAsIEJSQ01GX0ZFQVRfTUJTUykpIHsN
Cj4gICAJCW1ic3MgPSBmYWxzZTsNCj4gICAJCWxpc3RfZm9yX2VhY2hfZW50cnkodmlmX3dhbGss
ICZjZmctPnZpZl9saXN0LCBsaXN0KSB7DQo+ICAgCQkJaWYgKHZpZl93YWxrLT53ZGV2LmlmdHlw
ZSA9PSBOTDgwMjExX0lGVFlQRV9BUCkgew0KPiAtLQ0KPiAyLjE3LjENCj4gDQo+IC4NCj4gDQo=
