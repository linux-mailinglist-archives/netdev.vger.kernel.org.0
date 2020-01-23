Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A8B1462B6
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 08:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgAWHi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 02:38:29 -0500
Received: from mail-db8eur05on2055.outbound.protection.outlook.com ([40.107.20.55]:29792
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725777AbgAWHi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 02:38:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6TAKpF0DK+0F4gaDuh+Lb5UmlBCWpMRbVfI+MaThjlloEBAhDZ6OUSc7dHghk7gsa26yuL1itO0F9tmeFKPR4lV6FNoclIB99u+C2Cttiv5zLILGi07bB+Po8nF7ImOq1+at+B84if85scoBoOKwagqtW93UfLwj+xb60XhQAcLD5Zurkn2KjS/gtqxYFKp3tg+rIod8WVjY8Mxxpa4YXKl2Sr6uhUIxKiE37G6Fg5B4uhG3kT3/u5nA6wRoQq5tUGTAqr+u1DCWb1oy8rjvs6HUzIccEGDxPlG+wPNZuh7u6bjaPJZ3Hs85tJkREfxaegGMaHFEtnun1y1soh+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObkrL5AprZsMo48Gl7+u+9pCLEH3ONM8Zx4VyyYEP68=;
 b=Esit4V+QVJOp074iVlmK1SVWeVI9/mr6qmuyNM4SW1ElGc3zMIOe9ooUYvba8jEm9ibgOVxROV9Nui3o5cNJ5Ch7V65kV+8lxLyJ7jZAPi5/y7uiowmKW0ycwXqPm8sAlBmu+ZqeQg9YRHApR33QZ/uEFvRfsGhg+ZC/TBvWfpFrjr5KEak5KURw9bCbZAMTw5s36EZJ0axi//mqGFKrINx1GHo+godZ1UOH5fI4ozivi0ZlTzdwvjahRoWyMpGUK662OE4Prn6C4pegIZB/FkONRCuBDxnNH4e11oEsa3aKnVtapVomZDXI8bPeJbYcSTYlMEQcDD9pBP6Ab724/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObkrL5AprZsMo48Gl7+u+9pCLEH3ONM8Zx4VyyYEP68=;
 b=hEhCOaNavZE/MOtNjXkE9yXg4ocVVNhLYXIb/7X5rBa1fyFf6YnJjJZRsIt9pY/l9MVu1k2hkbJEJRA4YfLARU6ggnwAKxzTPsX+kwflRurbKS+fOnPxqjfU7b9Q1JqrxIsmveClqDHrrnZYWFUBw2HRlPoxGdBp4joDIf/Vv44=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB5610.eurprd04.prod.outlook.com (20.179.8.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.25; Thu, 23 Jan 2020 07:38:24 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2665.017; Thu, 23 Jan 2020
 07:38:24 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Subject: RE: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Topic: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Index: AQHV0Sw23V0HaV1F6UKjzaVeqBvXWaf2+L4AgADjpXA=
Date:   Thu, 23 Jan 2020 07:38:23 +0000
Message-ID: <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
In-Reply-To: <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4e632460-6b37-4040-fd87-08d79fd73a49
x-ms-traffictypediagnostic: DB8PR04MB5610:|DB8PR04MB5610:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB561074CFF5D493AC45EA6F8DAD0F0@DB8PR04MB5610.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(189003)(199004)(76116006)(33656002)(64756008)(71200400001)(66556008)(54906003)(66476007)(55016002)(2906002)(66946007)(52536014)(110136005)(316002)(186003)(26005)(5660300002)(6506007)(7696005)(8936002)(8676002)(478600001)(53546011)(4326008)(81156014)(81166006)(86362001)(66446008)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5610;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lFsftV6P/wumYLhGrStaHQHlPRysiZ8tgOHnh3EDyKiWy9cj4ijXVAh7MvqmtiXjL/ifnYFzC1iPOSFEYrPCSwkl6DQyaHljtUBE9MrbrAmeGV3l4xutiEjtFq/+OvEtd5h2/qBiZJy2r8m37Wwme8XJXc00GaFnLkqrjxfTYou5nIIV2uMRmnZ3+XF+huNQhU0TN5UQ6+/WfKylNgMKd5O9dW4ZR6v5za9YuIjBiCEO0A71QFi+IKQI9JquLk5l97Jqk66lFxdAyG4yX0orTEr5FrKlLoo/yX9uG/WLqcVO77mpY7/EpK38ohbbYeSkZEQRX3AkXLOiHnuPB4sJ1QK85/DzBgN1bF7E1ewDElfA9IzNBkew4NRfL3ZtfBHxq6ZxSfKVlWrpylM5EGbOhsl2be/3seNPvG1IM7CEP/4gma6pOqbHANTa6/B4Gw+0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e632460-6b37-4040-fd87-08d79fd73a49
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 07:38:24.0021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AYyvXe2/WLCdmaBtIfOHsU2Cn8cjk10hjqv8wx2aoPhd+UHIhPvJFkwFsUbDfLhfUrhYz3shNyeWiMLgB+hneg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5610
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBKYW51YXJ5IDIyLCAyMDIw
IDc6NTggUE0NCj4gVG86IE1hZGFsaW4gQnVjdXIgKE9TUykgPG1hZGFsaW4uYnVjdXJAb3NzLm54
cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0DQo+IENjOiBhbmRyZXdAbHVubi5jaDsgaGthbGx3
ZWl0MUBnbWFpbC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IHlrYXVrYWJAc3VzZS5k
ZQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvMl0gbmV0OiBwaHk6IGFxdWFudGlh
OiBhZGQgcmF0ZV9hZGFwdGF0aW9uDQo+IGluZGljYXRpb24NCj4gDQo+IE9uIDEvMjIvMjAgNTo1
OSBBTSwgTWFkYWxpbiBCdWN1ciB3cm90ZToNCj4gPiBUaGUgQVFSIFBIWXMgYXJlIGFibGUgdG8g
cGVyZm9ybSByYXRlIGFkYXB0YXRpb24gYmV0d2Vlbg0KPiA+IHRoZSBzeXN0ZW0gaW50ZXJmYWNl
IGFuZCB0aGUgbGluZSBpbnRlcmZhY2VzLiBXaGVuIHN1Y2gNCj4gPiBhIFBIWSBpcyBkZXBsb3ll
ZCwgdGhlIGV0aGVybmV0IGRyaXZlciBzaG91bGQgbm90IGxpbWl0DQo+ID4gdGhlIG1vZGVzIHN1
cHBvcnRlZCBvciBhZHZlcnRpc2VkIGJ5IHRoZSBQSFkuIFRoaXMgcGF0Y2gNCj4gPiBpbnRyb2R1
Y2VzIHRoZSBiaXQgdGhhdCBhbGxvd3MgY2hlY2tpbmcgZm9yIHRoaXMgZmVhdHVyZQ0KPiA+IGlu
IHRoZSBwaHlfZGV2aWNlIHN0cnVjdHVyZSBhbmQgaXRzIHVzZSBmb3IgdGhlIEFxdWFudGlhDQo+
ID4gUEhZcy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IE1hZGFsaW4gQnVjdXIgPG1hZGFsaW4u
YnVjdXJAb3NzLm54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L3BoeS9hcXVhbnRp
YV9tYWluLmMgfCAzICsrKw0KPiA+ICBpbmNsdWRlL2xpbnV4L3BoeS5oICAgICAgICAgICAgIHwg
MyArKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvYXF1YW50aWFfbWFpbi5jDQo+IGIvZHJpdmVycy9u
ZXQvcGh5L2FxdWFudGlhX21haW4uYw0KPiA+IGluZGV4IDk3NTc4OWQ5MzQ5ZC4uMzZmZGQ1MjNi
NzU4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9hcXVhbnRpYV9tYWluLmMNCj4g
PiArKysgYi9kcml2ZXJzL25ldC9waHkvYXF1YW50aWFfbWFpbi5jDQo+ID4gQEAgLTIwOSw2ICsy
MDksOSBAQCBzdGF0aWMgaW50IGFxcl9jb25maWdfYW5lZyhzdHJ1Y3QgcGh5X2RldmljZQ0KPiAq
cGh5ZGV2KQ0KPiA+ICAJdTE2IHJlZzsNCj4gPiAgCWludCByZXQ7DQo+ID4NCj4gPiArCS8qIGFk
ZCBoZXJlIGFzIHRoaXMgaXMgY2FsbGVkIGZvciBhbGwgZGV2aWNlcyAqLw0KPiA+ICsJcGh5ZGV2
LT5yYXRlX2FkYXB0YXRpb24gPSAxOw0KPiANCj4gSG93IGFib3V0IGludHJvZHVjaW5nIGEgbmV3
IFBIWV9TVVBQT1JUU19SQVRFX0FEQVBUQVRJT04gZmxhZyBhbmQgeW91DQo+IHNldCB0aGF0IGRp
cmVjdGx5IGZyb20gdGhlIHBoeV9kcml2ZXIgZW50cnk/IHVzaW5nIHRoZSAiZmxhZ3MiIGJpdG1h
c2sNCj4gaW5zdGVhZCBvZiBhZGRpbmcgYW5vdGhlciBzdHJ1Y3R1cmUgbWVtYmVyIHRvIHBoeV9k
ZXZpY2U/DQoNCkkndmUgbG9va2VkIGF0IHRoZSBwaHlkZXYtPmRldl9mbGFncyB1c2UsIGl0IHNl
ZW1lZCB0byBtZSB0aGF0IG1vc3RseSBpdA0KaXMgdXNlZCB0byBjb252ZXkgY29uZmlndXJhdGlv
biBvcHRpb25zIHRvd2FyZHMgdGhlIFBIWS4gQW5vdGhlciBwcm9ibGVtDQppcyB0aGF0IGl0J3Mg
bWVhbmluZyBzZWVtcyB0byBiZSBvcGFxdWUsICBQSFkgc3BlY2lmaWMuIEkgd2FudGVkIHRvIGF2
b2lkDQp0cmFtcGxpbmcgb24gYSBjZXJ0YWluIFBIWSBoYXJkY29kZWQgdmFsdWUgYW5kIEkgdHVy
bmVkIG15IGF0dGVudGlvbiB0bw0KdGhlIGJpdCBmaWVsZHMgaW4gdGhlIHBoeV9kZXZpY2UuIEkg
bm90aWNlZCB0aGF0IHRoZXJlIGFyZSBhbHJlYWR5IDEyIGJpdHMNCnNvIGR1ZSB0byBhbGlnbm1l
bnQsIHRoZSBhZGRlZCBiaXQgaXMgbm90IGFkZGluZyBleHRyYSBzaXplIHRvIHRoZSBzdHJ1Y3Qu
DQogDQo+ID4gKw0KPiA+ICAJaWYgKHBoeWRldi0+YXV0b25lZyA9PSBBVVRPTkVHX0RJU0FCTEUp
DQo+ID4gIAkJcmV0dXJuIGdlbnBoeV9jNDVfcG1hX3NldHVwX2ZvcmNlZChwaHlkZXYpOw0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGh5LmggYi9pbmNsdWRlL2xpbnV4L3Bo
eS5oDQo+ID4gaW5kZXggZGQ0YTkxZjFmZWFhLi4yYTVjMjAyMzMzZmMgMTAwNjQ0DQo+ID4gLS0t
IGEvaW5jbHVkZS9saW51eC9waHkuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvcGh5LmgNCj4g
PiBAQCAtMzg3LDYgKzM4Nyw5IEBAIHN0cnVjdCBwaHlfZGV2aWNlIHsNCj4gPiAgCS8qIEludGVy
cnVwdHMgYXJlIGVuYWJsZWQgKi8NCj4gPiAgCXVuc2lnbmVkIGludGVycnVwdHM6MTsNCj4gPg0K
PiA+ICsJLyogUmF0ZSBhZGFwdGF0aW9uIGluIHRoZSBQSFkgKi8NCj4gPiArCXVuc2lnbmVkIHJh
dGVfYWRhcHRhdGlvbjoxOw0KPiA+ICsNCj4gPiAgCWVudW0gcGh5X3N0YXRlIHN0YXRlOw0KPiA+
DQo+ID4gIAl1MzIgZGV2X2ZsYWdzOw0KPiA+DQo+IA0KPiANCj4gLS0NCj4gRmxvcmlhbg0K
