Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD01117E42
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 04:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfLJDio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 22:38:44 -0500
Received: from mail-eopbgr760115.outbound.protection.outlook.com ([40.107.76.115]:40966
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbfLJDin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 22:38:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ia9Vjru2MehjcNqJsVhXjFw8M3NNGNiLHxSb9wtTaiLW+t+SlG+GaZSbMx6yUpmwJUG64Fa3JKpMapCs+CVtxsMYp0ULQDWRgL57X4yBc7iGeTj9PGDEgYKbiso2Q3UAdVbHC08YFLFXX/KTtvPnr0DWUssQgAhOmZTbncDW0VYVdaVoAb3SCdcHVMOqsW5kwAUROkhHCWfPDXYVCCR0Fu0GXSNv7XqAY3ElHhiPl4+MDQ3Nn715RYaOM9nxgEPbSjk6/JCvzHE0yImydQIeehPiWtFtdaCr4HERbJPqMoNRi7bcNkUgoUWPW/RqgMd3GXwUc23lAzJrNjvkGSYAtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Ezkfy2lpwI66fBED0xopOw+EDjxkDvg3uc95OQSLl0=;
 b=R3CIeASIm+lltvmA20e3VUj4o9bDTh/pdSjdfF1LOAzeuIihkmoJW6PodeAediNza6ZG4gwHy43QvZOEmncackxklyUPZFLKFDmuITDHTL4z3cRnjg/xMe5v+dhbpzX9+cRzA0HCl8Xi1OYPgLh9RAqjEU3BejbxEqPD2l+OG+S8Dah9PQuTy1L6rWJHDRR6C438/omZkLMYjNCNF/4ZRRuwfXA57wJm6FLBrk/q9xJhEx0JJCXQfdo0GVhqIXFZWCydMYahgGm9bRF8b66lYQxheVDC3Tfjd6twM5Te5F9dSBqYLthznPRGcu6wleKzFCKqN9jSjQCsxNtYMy26eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Ezkfy2lpwI66fBED0xopOw+EDjxkDvg3uc95OQSLl0=;
 b=NXaGlEUSepzOQJkcgkD8I4UMW3hNn0CPrd5nW9m1lZDJLUVBICchg7KezfT1tuoEveBljGNTT4QEXeyJU6N2R0Ypbfz7j0KDJcsSvF0fRw+9YLqc1M1wM9yygkN64JG8ZJ12r+bANudiHifJsjAIeL8NoMhYml56ePHlDazOqeE=
Received: from CY4PR06MB2342.namprd06.prod.outlook.com (10.169.185.149) by
 CY4PR06MB2646.namprd06.prod.outlook.com (10.173.39.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 03:38:41 +0000
Received: from CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d]) by CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d%3]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 03:38:41 +0000
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
Subject: Re: [PATCH 6/8] brcmfmac: add RSDB condition when setting interface
 combinations
Thread-Topic: [PATCH 6/8] brcmfmac: add RSDB condition when setting interface
 combinations
Thread-Index: AQHVruFmnQ3yMcJqCEOYhNG7Jr5b+aeyuNgA
Date:   Tue, 10 Dec 2019 03:38:41 +0000
Message-ID: <b55e037f-80f5-3f65-5f76-e0ba2cdf9a29@cypress.com>
References: <20191209223822.27236-1-smoch@web.de>
 <20191209223822.27236-6-smoch@web.de>
In-Reply-To: <20191209223822.27236-6-smoch@web.de>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: BYAPR07CA0104.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::45) To CY4PR06MB2342.namprd06.prod.outlook.com
 (2603:10b6:903:13::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 716546fd-dba1-45c4-fb08-08d77d227306
x-ms-traffictypediagnostic: CY4PR06MB2646:|CY4PR06MB2646:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR06MB2646C9292B180FE31C7D865ABB5B0@CY4PR06MB2646.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:296;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(189003)(199004)(8936002)(36756003)(6512007)(316002)(2906002)(2616005)(3450700001)(305945005)(31696002)(81166006)(4326008)(81156014)(66446008)(186003)(31686004)(8676002)(64756008)(53546011)(66556008)(66476007)(66946007)(6506007)(478600001)(54906003)(52116002)(26005)(110136005)(229853002)(86362001)(6486002)(5660300002)(71200400001)(71190400001)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR06MB2646;H:CY4PR06MB2342.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r4Na5OgpIgIotbO79Zlnn1M0YzceMZHJBPeuv6uE5fLeJ5IMLjuWWWGOhG5piKIVE4bM7wNsuY3y640EiRWyvDohUOeCNbQzw3okxnk2Ms2Rnp9e1g0j1zw8DB30cxmIivkfiv20c+YC60f+CXv88BRzh6YvFciNu9Qp5ByaYiOEl/2nH4oB3gycXKtEpZDzpI5y1FWdUOSRN/qcElqKVvO8mbRAjr2jhFVtE6Stqr4rs1Cv5Ch/wRbcA0Pys8Nf8UCmQ3tV/4jXJ5NG/JK5x8VbFuGoFZEc+LGr7OUU8EU/+s3JjdwzjrSEYo+4MohnKp3EEAQ7K9FVxCS21uZHLze5/2GBEe8BHJHtKdVC/SXd/UCbZxROzSUHp5rtamiFqpaqw2LDM+hVdmYgNEZ12NpQC2BM15pac8hzkoGdy8vxVg61Tinqu5NVLgrwLA2bdaSgHpXALMnW5DRGiEie20quShS1A+0HDyTQy7OciooMcmr4njErSVF3qEbOv/bK
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9F530A594BD7946A2C7C5BB6C967D80@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716546fd-dba1-45c4-fb08-08d77d227306
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 03:38:41.1910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ad+1yJyq43iMbJTSiL++srfLMPL/jETLhgmTN0F3fUomlCjIKimVw6Oz2GlHPgOzKfhYkDV+N4D0visuu6qdHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR06MB2646
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEwLzIwMTkgNjozOCwgU29lcmVuIE1vY2ggd3JvdGU6DQo+IEZyb206IFdyaWdo
dCBGZW5nIDx3cmlnaHQuZmVuZ0BjeXByZXNzLmNvbT4NCj4gDQo+IFdpdGggZmlybXdhcmUgUlNE
QiBmZWF0dXJlDQo+IDEuIFRoZSBtYXhpbXVtIHN1cHBvcnQgaW50ZXJmYWNlIGlzIGZvdXIuDQo+
IDIuIFRoZSBtYXhpbXVtIGRpZmZlcmVuY2UgY2hhbm5lbCBpcyB0d28uDQo+IDMuIFRoZSBtYXhp
bXVtIGludGVyZmFjZXMgb2Yge3N0YXRpb24vcDJwIGNsaWVudC9BUH0gYXJlIHR3by4NCj4gNC4g
VGhlIG1heGltdW0gaW50ZXJmYWNlIG9mIHAycCBkZXZpY2UgaXMgb25lLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogV3JpZ2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0KUmV2aWV3ZWQt
Ynk6IENoaS1Ic2llbiBMaW4gPGNoaS1oc2llbi5saW5AY3lwcmVzcy5jb20+DQoNCj4gLS0tDQo+
IENjOiBLYWxsZSBWYWxvIDxrdmFsb0Bjb2RlYXVyb3JhLm9yZz4NCj4gQ2M6IEFyZW5kIHZhbiBT
cHJpZWwgPGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20+DQo+IENjOiBGcmFua3kgTGluIDxm
cmFua3kubGluQGJyb2FkY29tLmNvbT4NCj4gQ2M6IEhhbnRlIE1ldWxlbWFuIDxoYW50ZS5tZXVs
ZW1hbkBicm9hZGNvbS5jb20+DQo+IENjOiBDaGktSHNpZW4gTGluIDxjaGktaHNpZW4ubGluQGN5
cHJlc3MuY29tPg0KPiBDYzogV3JpZ2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0K
PiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+IENjOiBicmNtODAyMTEtZGV2
LWxpc3QucGRsQGJyb2FkY29tLmNvbQ0KPiBDYzogYnJjbTgwMjExLWRldi1saXN0QGN5cHJlc3Mu
Y29tDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnDQo+IC0tLQ0KPiAgIC4uLi9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMv
Y2ZnODAyMTEuYyAgICB8IDU0ICsrKysrKysrKysrKysrKystLS0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgNDYgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEu
YyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jZmc4
MDIxMS5jDQo+IGluZGV4IDBjZjEzY2VhMWRiZS4uOWQ5ZGM5MTk1ZTllIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAy
MTEuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJj
bWZtYWMvY2ZnODAyMTEuYw0KPiBAQCAtNjUyMCw2ICs2NTIwLDkgQEAgYnJjbWZfdHhyeF9zdHlw
ZXNbTlVNX05MODAyMTFfSUZUWVBFU10gPSB7DQo+ICAgICoJI1NUQSA8PSAxLCAjQVAgPD0gMSwg
Y2hhbm5lbHMgPSAxLCAyIHRvdGFsDQo+ICAgICoJI0FQIDw9IDQsIG1hdGNoaW5nIEJJLCBjaGFu
bmVscyA9IDEsIDQgdG90YWwNCj4gICAgKg0KPiArICogbm8gcDJwIGFuZCByc2RiOg0KPiArICoJ
I1NUQSA8PSAyLCAjQVAgPD0gMiwgY2hhbm5lbHMgPSAyLCA0IHRvdGFsDQo+ICsgKg0KPiAgICAq
IHAycCwgbm8gbWNoYW4sIGFuZCBtYnNzOg0KPiAgICAqDQo+ICAgICoJI1NUQSA8PSAxLCAjUDJQ
LURFViA8PSAxLCAje1AyUC1DTCwgUDJQLUdPfSA8PSAxLCBjaGFubmVscyA9IDEsIDMgdG90YWwN
Cj4gQEAgLTY1MzEsNiArNjUzNCwxMCBAQCBicmNtZl90eHJ4X3N0eXBlc1tOVU1fTkw4MDIxMV9J
RlRZUEVTXSA9IHsNCj4gICAgKgkjU1RBIDw9IDEsICNQMlAtREVWIDw9IDEsICN7UDJQLUNMLCBQ
MlAtR099IDw9IDEsIGNoYW5uZWxzID0gMiwgMyB0b3RhbA0KPiAgICAqCSNTVEEgPD0gMSwgI1Ay
UC1ERVYgPD0gMSwgI0FQIDw9IDEsICNQMlAtQ0wgPD0gMSwgY2hhbm5lbHMgPSAxLCA0IHRvdGFs
DQo+ICAgICoJI0FQIDw9IDQsIG1hdGNoaW5nIEJJLCBjaGFubmVscyA9IDEsIDQgdG90YWwNCj4g
KyAqDQo+ICsgKiBwMnAsIHJzZGIsIGFuZCBubyBtYnNzOg0KPiArICoJI1NUQSA8PSAyLCAjUDJQ
LURFViA8PSAxLCAje1AyUC1DTCwgUDJQLUdPfSA8PSAyLCBBUCA8PSAyLA0KPiArICoJIGNoYW5u
ZWxzID0gMiwgNCB0b3RhbA0KPiAgICAqLw0KPiAgIHN0YXRpYyBpbnQgYnJjbWZfc2V0dXBfaWZt
b2RlcyhzdHJ1Y3Qgd2lwaHkgKndpcGh5LCBzdHJ1Y3QgYnJjbWZfaWYgKmlmcCkNCj4gICB7DQo+
IEBAIC02NTM4LDEzICs2NTQ1LDE0IEBAIHN0YXRpYyBpbnQgYnJjbWZfc2V0dXBfaWZtb2Rlcyhz
dHJ1Y3Qgd2lwaHkgKndpcGh5LCBzdHJ1Y3QgYnJjbWZfaWYgKmlmcCkNCj4gICAJc3RydWN0IGll
ZWU4MDIxMV9pZmFjZV9saW1pdCAqYzBfbGltaXRzID0gTlVMTDsNCj4gICAJc3RydWN0IGllZWU4
MDIxMV9pZmFjZV9saW1pdCAqcDJwX2xpbWl0cyA9IE5VTEw7DQo+ICAgCXN0cnVjdCBpZWVlODAy
MTFfaWZhY2VfbGltaXQgKm1ic3NfbGltaXRzID0gTlVMTDsNCj4gLQlib29sIG1ic3MsIHAycDsN
Cj4gKwlib29sIG1ic3MsIHAycCwgcnNkYjsNCj4gICAJaW50IGksIGMsIG5fY29tYm9zOw0KPiAN
Cj4gICAJbWJzcyA9IGJyY21mX2ZlYXRfaXNfZW5hYmxlZChpZnAsIEJSQ01GX0ZFQVRfTUJTUyk7
DQo+ICAgCXAycCA9IGJyY21mX2ZlYXRfaXNfZW5hYmxlZChpZnAsIEJSQ01GX0ZFQVRfUDJQKTsN
Cj4gKwlyc2RiID0gYnJjbWZfZmVhdF9pc19lbmFibGVkKGlmcCwgQlJDTUZfRkVBVF9SU0RCKTsN
Cj4gDQo+IC0Jbl9jb21ib3MgPSAxICsgISFwMnAgKyAhIW1ic3M7DQo+ICsJbl9jb21ib3MgPSAx
ICsgISEocDJwICYmICFyc2RiKSArICEhbWJzczsNCj4gICAJY29tYm8gPSBrY2FsbG9jKG5fY29t
Ym9zLCBzaXplb2YoKmNvbWJvKSwgR0ZQX0tFUk5FTCk7DQo+ICAgCWlmICghY29tYm8pDQo+ICAg
CQlnb3RvIGVycjsNCj4gQEAgLTY1NTUsMTYgKzY1NjMsMzYgQEAgc3RhdGljIGludCBicmNtZl9z
ZXR1cF9pZm1vZGVzKHN0cnVjdCB3aXBoeSAqd2lwaHksIHN0cnVjdCBicmNtZl9pZiAqaWZwKQ0K
PiANCj4gICAJYyA9IDA7DQo+ICAgCWkgPSAwOw0KPiAtCWMwX2xpbWl0cyA9IGtjYWxsb2MocDJw
ID8gMyA6IDIsIHNpemVvZigqYzBfbGltaXRzKSwgR0ZQX0tFUk5FTCk7DQo+ICsJaWYgKHAycCAm
JiByc2RiKQ0KPiArCQljMF9saW1pdHMgPSBrY2FsbG9jKDQsIHNpemVvZigqYzBfbGltaXRzKSwg
R0ZQX0tFUk5FTCk7DQo+ICsJZWxzZSBpZiAocDJwKQ0KPiArCQljMF9saW1pdHMgPSBrY2FsbG9j
KDMsIHNpemVvZigqYzBfbGltaXRzKSwgR0ZQX0tFUk5FTCk7DQo+ICsJZWxzZQ0KPiArCQljMF9s
aW1pdHMgPSBrY2FsbG9jKDIsIHNpemVvZigqYzBfbGltaXRzKSwgR0ZQX0tFUk5FTCk7DQo+ICAg
CWlmICghYzBfbGltaXRzKQ0KPiAgIAkJZ290byBlcnI7DQo+IC0JYzBfbGltaXRzW2ldLm1heCA9
IDE7DQo+IC0JYzBfbGltaXRzW2krK10udHlwZXMgPSBCSVQoTkw4MDIxMV9JRlRZUEVfU1RBVElP
Tik7DQo+IC0JaWYgKHAycCkgew0KPiArCWlmIChwMnAgJiYgcnNkYikgew0KPiArCQljb21ib1tj
XS5udW1fZGlmZmVyZW50X2NoYW5uZWxzID0gMjsNCj4gKwkJd2lwaHktPmludGVyZmFjZV9tb2Rl
cyB8PSBCSVQoTkw4MDIxMV9JRlRZUEVfUDJQX0NMSUVOVCkgfA0KPiArCQkJCQkgIEJJVChOTDgw
MjExX0lGVFlQRV9QMlBfR08pIHwNCj4gKwkJCQkJICBCSVQoTkw4MDIxMV9JRlRZUEVfUDJQX0RF
VklDRSk7DQo+ICsJCWMwX2xpbWl0c1tpXS5tYXggPSAyOw0KPiArCQljMF9saW1pdHNbaSsrXS50
eXBlcyA9IEJJVChOTDgwMjExX0lGVFlQRV9TVEFUSU9OKTsNCj4gKwkJYzBfbGltaXRzW2ldLm1h
eCA9IDE7DQo+ICsJCWMwX2xpbWl0c1tpKytdLnR5cGVzID0gQklUKE5MODAyMTFfSUZUWVBFX1Ay
UF9ERVZJQ0UpOw0KPiArCQljMF9saW1pdHNbaV0ubWF4ID0gMjsNCj4gKwkJYzBfbGltaXRzW2kr
K10udHlwZXMgPSBCSVQoTkw4MDIxMV9JRlRZUEVfUDJQX0NMSUVOVCkgfA0KPiArCQkJCSAgICAg
ICBCSVQoTkw4MDIxMV9JRlRZUEVfUDJQX0dPKTsNCj4gKwkJYzBfbGltaXRzW2ldLm1heCA9IDI7
DQo+ICsJCWMwX2xpbWl0c1tpKytdLnR5cGVzID0gQklUKE5MODAyMTFfSUZUWVBFX0FQKTsNCj4g
KwkJY29tYm9bY10ubWF4X2ludGVyZmFjZXMgPSA1Ow0KPiArCX0gZWxzZSBpZiAocDJwKSB7DQo+
ICAgCQlpZiAoYnJjbWZfZmVhdF9pc19lbmFibGVkKGlmcCwgQlJDTUZfRkVBVF9NQ0hBTikpDQo+
ICAgCQkJY29tYm9bY10ubnVtX2RpZmZlcmVudF9jaGFubmVscyA9IDI7DQo+ICAgCQllbHNlDQo+
ICAgCQkJY29tYm9bY10ubnVtX2RpZmZlcmVudF9jaGFubmVscyA9IDE7DQo+ICsJCWMwX2xpbWl0
c1tpXS5tYXggPSAxOw0KPiArCQljMF9saW1pdHNbaSsrXS50eXBlcyA9IEJJVChOTDgwMjExX0lG
VFlQRV9TVEFUSU9OKTsNCj4gICAJCXdpcGh5LT5pbnRlcmZhY2VfbW9kZXMgfD0gQklUKE5MODAy
MTFfSUZUWVBFX1AyUF9DTElFTlQpIHwNCj4gICAJCQkJCSAgQklUKE5MODAyMTFfSUZUWVBFX1Ay
UF9HTykgfA0KPiAgIAkJCQkJICBCSVQoTkw4MDIxMV9JRlRZUEVfUDJQX0RFVklDRSk7DQo+IEBA
IC02NTczLDE2ICs2NjAxLDI2IEBAIHN0YXRpYyBpbnQgYnJjbWZfc2V0dXBfaWZtb2RlcyhzdHJ1
Y3Qgd2lwaHkgKndpcGh5LCBzdHJ1Y3QgYnJjbWZfaWYgKmlmcCkNCj4gICAJCWMwX2xpbWl0c1tp
XS5tYXggPSAxOw0KPiAgIAkJYzBfbGltaXRzW2krK10udHlwZXMgPSBCSVQoTkw4MDIxMV9JRlRZ
UEVfUDJQX0NMSUVOVCkgfA0KPiAgIAkJCQkgICAgICAgQklUKE5MODAyMTFfSUZUWVBFX1AyUF9H
Tyk7DQo+ICsJCWNvbWJvW2NdLm1heF9pbnRlcmZhY2VzID0gaTsNCj4gKwl9IGVsc2UgaWYgKHJz
ZGIpIHsNCj4gKwkJY29tYm9bY10ubnVtX2RpZmZlcmVudF9jaGFubmVscyA9IDI7DQo+ICsJCWMw
X2xpbWl0c1tpXS5tYXggPSAyOw0KPiArCQljMF9saW1pdHNbaSsrXS50eXBlcyA9IEJJVChOTDgw
MjExX0lGVFlQRV9TVEFUSU9OKTsNCj4gKwkJYzBfbGltaXRzW2ldLm1heCA9IDI7DQo+ICsJCWMw
X2xpbWl0c1tpKytdLnR5cGVzID0gQklUKE5MODAyMTFfSUZUWVBFX0FQKTsNCj4gKwkJY29tYm9b
Y10ubWF4X2ludGVyZmFjZXMgPSAzOw0KPiAgIAl9IGVsc2Ugew0KPiAgIAkJY29tYm9bY10ubnVt
X2RpZmZlcmVudF9jaGFubmVscyA9IDE7DQo+ICAgCQljMF9saW1pdHNbaV0ubWF4ID0gMTsNCj4g
KwkJYzBfbGltaXRzW2krK10udHlwZXMgPSBCSVQoTkw4MDIxMV9JRlRZUEVfU1RBVElPTik7DQo+
ICsJCWMwX2xpbWl0c1tpXS5tYXggPSAxOw0KPiAgIAkJYzBfbGltaXRzW2krK10udHlwZXMgPSBC
SVQoTkw4MDIxMV9JRlRZUEVfQVApOw0KPiArCQljb21ib1tjXS5tYXhfaW50ZXJmYWNlcyA9IGk7
DQo+ICAgCX0NCj4gLQljb21ib1tjXS5tYXhfaW50ZXJmYWNlcyA9IGk7DQo+ICAgCWNvbWJvW2Nd
Lm5fbGltaXRzID0gaTsNCj4gICAJY29tYm9bY10ubGltaXRzID0gYzBfbGltaXRzOw0KPiANCj4g
LQlpZiAocDJwKSB7DQo+ICsJaWYgKHAycCAmJiAhcnNkYikgew0KPiAgIAkJYysrOw0KPiAgIAkJ
aSA9IDA7DQo+ICAgCQlwMnBfbGltaXRzID0ga2NhbGxvYyg0LCBzaXplb2YoKnAycF9saW1pdHMp
LCBHRlBfS0VSTkVMKTsNCj4gLS0NCj4gMi4xNy4xDQo+IA0KPiAuDQo+IA0K
