Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70988CA04
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 06:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfHNED0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 00:03:26 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:15493
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725262AbfHNED0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 00:03:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqmCRIVEaZSuzTWZC0nbN4i2efibSftr60UDM9zNuHaHKWGdKVbYx6AUsRkKllJdhoFVWjJHAjLcyyRvih9Al2vjKz+YR870epPROu37Zh6gVkNvES4NxNtwSzR1FlrV5/JenXF75QypmFcWs4bSwlEnraEiPJRQsZugOpbm+Dgx0Ej8r1m878vweQjJUpZdIU9uMNyKBD1q7EdWV7xAxku9vSvotGD6joU2No6LAEXMV2VqaVw20ExBlsHkFSuEQhAIpUHM1zy2/7+POzNucxtapXcg2pO2qti1Vwd8qemZPSnSzFamWjxRBOiv+wqlbSEhq+KDa3qNZgpzEfhiIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVITQtm6WKkEFX8rhsoVnKgRjTOviG8j7FbFlV0HFYc=;
 b=LlJNFLGiWKxdcz90o+5mAFSPrQ2bZQct54vd+Uadskw3tQh2DxwJOzhimflvrTzb+sOOI5yYvBuEk2OEuT7wcD00zr7SI9jGYTweuP3ePVoAtviqxq8dReDkaQiQBiSnENME5NeM20rbu9fUHFp6tym5/MFhFPVnQ8NQa1VYqy3RlhNxSCUGhyT/uW/lSTiihjFOLNB0Duyl3fBrI00d0Ls+Vwa8Oys1qFNgBYr4InXj9Eib91ZEkdrXkceWzhpL4tIY29rImoG7gsMrYV3rum/k7aHRLM74nXUrGdEtlk5AumA4/ndg8nuBwTnrME1iu4dSNJYyYSjmpetzItM+Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVITQtm6WKkEFX8rhsoVnKgRjTOviG8j7FbFlV0HFYc=;
 b=pWYUx9quJCpIgThbK/OoVd5x0bcSDLf6BHlR8uFmHTDoGooW7Oo5nEtAaDFSpIRKOfGecZN7R+SawS0p3JsfYsvS9Mr4V2DO5FbPZqA0nZBDqJ1mJ6+mcTRLdZENbh4zQFOkKIzbWW6UFFSQ8Fi/sdeB25txQpxCUiVjK0wj/k4=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2461.eurprd04.prod.outlook.com (10.168.64.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 14 Aug 2019 04:03:20 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37%11]) with mapi id 15.20.2157.022; Wed, 14 Aug
 2019 04:03:20 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 3/3] ocelot_ace: fix action of trap
Thread-Topic: [PATCH 3/3] ocelot_ace: fix action of trap
Thread-Index: AQHVUPsbgCvvMJE2AE2KMlSf5gLebab3cdsAgADjDBCAAEZOAIABbBaA
Date:   Wed, 14 Aug 2019 04:03:20 +0000
Message-ID: <VI1PR0401MB223711A1DB199D1C3CCFD9CCF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
 <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190813061603.7ippfny5ce6iee2z@lx-anielsen.microsemi.net>
In-Reply-To: <20190813061603.7ippfny5ce6iee2z@lx-anielsen.microsemi.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce46919c-4502-4904-60f7-08d7206c587f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2461;
x-ms-traffictypediagnostic: VI1PR0401MB2461:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0401MB246162EC5202EE86656FB38DF8AD0@VI1PR0401MB2461.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(199004)(13464003)(53754006)(189003)(33656002)(66446008)(4326008)(66556008)(5660300002)(66476007)(256004)(9686003)(6246003)(66946007)(64756008)(76116006)(229853002)(8676002)(54906003)(3846002)(11346002)(446003)(6116002)(476003)(486006)(966005)(81156014)(2906002)(6436002)(6306002)(55016002)(81166006)(53936002)(25786009)(6506007)(53546011)(316002)(74316002)(86362001)(14454004)(45080400002)(305945005)(7696005)(66066001)(52536014)(478600001)(6916009)(99286004)(7736002)(186003)(76176011)(102836004)(71200400001)(26005)(8936002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2461;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GE/QkLezMyunMXXTyIkYgSEBcNotK3A5ug36PIq2bZfiFajOOHGomCl/Dp942D4TyytAF8HM25Z5fEGTkPcQW2LkE7CcKm9efpTeOj8Sb8A8NdAQgzKL1UL8Gw1aXLACM3eYP2XYWhxTERUwEqCsRJiwCymmWdRgnixEEjV9rdFqp5otr7DSNoTYeLBakvA9FyM76Ytj9AnAzaSWlzs3GnK5cbBpYDtzOFiBacBpiSa43duArXEBwbB3azBylKtyWqWa8D5p2Apg25HOBnQcbcXVtoz2XBge4EqXWXJnFNHwr6Hr85EPPzzfFsMP2rM1q/nmm0WYj0MPkjv1QMgEcGkoaogA011+TiQuomWt/cD4XFfcdIsTW83//biS1/4PI7F+D3x3VsOwccmn6UzqJCIqdH2Fu7g5Y856V8FQbys=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce46919c-4502-4904-60f7-08d7206c587f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 04:03:20.7575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0VuI3RNKjSG7OIDTr4YPt0uBGUkik2VYVlcAp0K1H9W8Mn3YKPReQdVmklwCwYGj+wJRlGgi85erB8kXkZMnWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2461
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsYW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxsYW4g
Vy4gTmllbHNlbiA8YWxsYW4ubmllbHNlbkBtaWNyb2NoaXAuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBBdWd1c3QgMTMsIDIwMTkgMjoxNiBQTQ0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5j
b20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZl
bUBkYXZlbWxvZnQubmV0PjsNCj4gQWxleGFuZHJlIEJlbGxvbmkgPGFsZXhhbmRyZS5iZWxsb25p
QGJvb3RsaW4uY29tPjsgTWljcm9jaGlwIExpbnV4IERyaXZlcg0KPiBTdXBwb3J0IDxVTkdMaW51
eERyaXZlckBtaWNyb2NoaXAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDMvM10gb2NlbG90
X2FjZTogZml4IGFjdGlvbiBvZiB0cmFwDQo+IA0KPiBUaGUgMDgvMTMvMjAxOSAwMjoxMiwgWS5i
LiBMdSB3cm90ZToNCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9t
OiBBbGxhbiBXLiBOaWVsc2VuIDxhbGxhbi5uaWVsc2VuQG1pY3JvY2hpcC5jb20+DQo+ID4gPiBT
ZW50OiBNb25kYXksIEF1Z3VzdCAxMiwgMjAxOSA4OjMyIFBNDQo+ID4gPiBUbzogWS5iLiBMdSA8
eWFuZ2JvLmx1QG54cC5jb20+DQo+ID4gPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgRGF2
aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+ID4gPiBBbGV4YW5kcmUgQmVs
bG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+OyBNaWNyb2NoaXAgTGludXgNCj4g
PiA+IERyaXZlciBTdXBwb3J0IDxVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tPg0KPiA+ID4g
U3ViamVjdDogUmU6IFtQQVRDSCAzLzNdIG9jZWxvdF9hY2U6IGZpeCBhY3Rpb24gb2YgdHJhcA0K
PiA+ID4NCj4gPiA+IFRoZSAwOC8xMi8yMDE5IDE4OjQ4LCBZYW5nYm8gTHUgd3JvdGU6DQo+ID4g
PiA+IFRoZSB0cmFwIGFjdGlvbiBzaG91bGQgYmUgY29weWluZyB0aGUgZnJhbWUgdG8gQ1BVIGFu
ZCBkcm9wcGluZyBpdA0KPiA+ID4gPiBmb3IgZm9yd2FyZGluZywgYnV0IGN1cnJlbnQgc2V0dGlu
ZyB3YXMganVzdCBjb3B5aW5nIGZyYW1lIHRvIENQVS4NCj4gPiA+DQo+ID4gPiBBcmUgdGhlcmUg
YW55IGFjdGlvbnMgd2hpY2ggZG8gYSAiY29weS10by1jcHUiIGFuZCBzdGlsbCBmb3J3YXJkIHRo
ZQ0KPiA+ID4gZnJhbWUgaW4gSFc/DQo+ID4NCj4gPiBbWS5iLiBMdV0gV2UncmUgdXNpbmcgRmVs
aXggc3dpdGNoIHdob3NlIGNvZGUgaGFkbid0IGJlZW4gYWNjZXB0ZWQgYnkNCj4gdXBzdHJlYW0u
DQo+ID4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJs
PWh0dHBzJTNBJTJGJTJGcGF0Yw0KPiA+DQo+IGh3b3JrLm96bGFicy5vcmclMkZwcm9qZWN0JTJG
bmV0ZGV2JTJGbGlzdCUyRiUzRnNlcmllcyUzRDExNTM5OSUyNnMNCj4gdGF0DQo+ID4NCj4gZSUz
RComYW1wO2RhdGE9MDIlN0MwMSU3Q3lhbmdiby5sdSU0MG54cC5jb20lN0M0MmNkMjAyY2IxN2I0
NQ0KPiA2OTgyMTcwOGQNCj4gPg0KPiA3MWZiNWM1ZGUlN0M2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5
OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjM3MDEyNw0KPiAzNzg5OTkxMA0KPiA+DQo+IDczNiZhbXA7
c2RhdGE9UW5zRGFXUEhLOXJiMFhXZyUyQmR1WUVoYTZmdVlTbHY0WVpkc3U1ZjRrYmZjJTNEDQo+
ICZhbXA7cmVzDQo+ID4gZXJ2ZWQ9MA0KPiA+DQo+ID4gSSdkIGxpa2UgdG8gdHJhcCBhbGwgSUVF
RSAxNTg4IFBUUCBFdGhlcm5ldCBmcmFtZXMgdG8gQ1BVIHRocm91Z2ggZXR5cGUNCj4gMHg4OGY3
Lg0KPiA+IFdoZW4gSSB1c2VkIGN1cnJlbnQgVFJBUCBvcHRpb24sIEkgZm91bmQgdGhlIGZyYW1l
cyB3ZXJlIG5vdCBvbmx5IGNvcGllZCB0bw0KPiBDUFUsIGJ1dCBhbHNvIGZvcndhcmRlZCB0byBv
dGhlciBwb3J0cy4NCj4gPiBTbyBJIGp1c3QgbWFkZSB0aGUgVFJBUCBvcHRpb24gc2FtZSB3aXRo
IERST1Agb3B0aW9uIGV4Y2VwdCBlbmFibGluZw0KPiBDUFVfQ09QWV9FTkEgaW4gdGhlIHBhdGNo
Lg0KPiBUaGlzIGlzIHN0aWxsIHdyb25nIHRvIGRvIC0gYW5kIGl0IHdpbGwgbm90IHdvcmsgZm9y
IE9jZWxvdCAoYW5kIEkgZG91YnQgaXQgd2lsbA0KPiB3b3JrIGZvciB5b3VyIEZlbGl4IHRhcmdl
dCkuDQo+IA0KPiBUaGUgcG9saWNlciBzZXR0aW5nIGluIHRoZSBkcm9wIGFjdGlvbiBlbnN1cmUg
dGhhdCB0aGUgZnJhbWUgaXMgZHJvcHBlZCBldmVuIGlmDQo+IG90aGVyIHBpcGUtbGluZSBzdGVw
cyBpbiB0aGUgc3dpdGNoIGhhcyBzZXQgdGhlIGNvcHktdG8tY3B1IGZsYWcuDQo+IA0KPiBJIHRo
aW5rIHlvdSBjYW4gZml4IHRoaXMgcGF0Y2ggbXkganVzdCBjbGVhcmluZyB0aGUgcG9ydCBtYXNr
LCBhbmQgbm90IHNldCB0aGUNCj4gcG9saWNlci4NCg0KW1kuYi4gTHVdIFNvcnJ5LiBJIG1pc3Nl
ZCB5b3VyIHByZXZpb3VzIGNvbW1lbnRzIG9uIHRoZSBUUkFQIGFjdGlvbi4NCldpdGggbXkgY29u
ZmlndXJhdGlvbiBpbiB0aGUgcGF0Y2gsIGl0IGluZGVlZCB3b3JrZWQuIE1heWJlIGl0IHdhcyBi
ZWNhdXNlICJ0aGUgQ1BVIHBvcnQgaXMgbm90IHRvdWNoZWQgYnkgTUFTS19NT0RFIiB3aGljaCBJ
IHNhdyBpbiBSTS4NCg0KSSB3aWxsIHRyeSB5b3VyIHN1Z2dlc3Rpb24gdG9vLiBJdCBzb3VuZCBt
b3JlIHByb3Blci4NClRoYW5rcy4NCg0KPiANCj4gL0FsbGFuDQoNCg==
