Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4776A41AEE
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 06:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfFLEPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 00:15:02 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:57218
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbfFLEPC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 00:15:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSRtpL9/KnuzaCPU9Z9xLj8k97sWd8vPldD3lIyouEY=;
 b=Q90vM2pehXtPRKWBP4nMo/IQwuPyi+Blk+berG8JvRy+JIrPZx1quP1Jwd9ghWIXRr3+A0eOSSxTvx1lnUVla/ZSQtMagHPQTyo/n4wuHdsvDvlEa7iyKyx7drbj/NtD2Np0UOhtDzVKrLb4yTE048IwvFDPqYZi8vMTN3Xt8HU=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2446.eurprd04.prod.outlook.com (10.168.61.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Wed, 12 Jun 2019 04:14:58 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::3408:f7f9:7f82:c67c]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::3408:f7f9:7f82:c67c%7]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 04:14:58 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/6] ptp: add QorIQ PTP support for DPAA2
Thread-Topic: [PATCH 1/6] ptp: add QorIQ PTP support for DPAA2
Thread-Index: AQHVHztS7fz1CkTI/EyG9roH6EAQXaaU3AqAgAKPkpA=
Date:   Wed, 12 Jun 2019 04:14:58 +0000
Message-ID: <VI1PR0401MB2237247525AB5DB5B5F275A8F8EC0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190610032108.5791-1-yangbo.lu@nxp.com>
 <20190610032108.5791-2-yangbo.lu@nxp.com> <20190610130601.GD8247@lunn.ch>
In-Reply-To: <20190610130601.GD8247@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3258ed1c-8161-4b13-8407-08d6eeec8853
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2446;
x-ms-traffictypediagnostic: VI1PR0401MB2446:
x-microsoft-antispam-prvs: <VI1PR0401MB24465E28A14FA6373D662C33F8EC0@VI1PR0401MB2446.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(376002)(366004)(13464003)(189003)(199004)(3846002)(316002)(11346002)(476003)(6116002)(6916009)(4326008)(186003)(74316002)(102836004)(25786009)(26005)(71200400001)(446003)(86362001)(99286004)(7696005)(486006)(53546011)(71190400001)(256004)(76176011)(14444005)(6506007)(7736002)(66066001)(229853002)(66446008)(66556008)(64756008)(14454004)(66946007)(73956011)(76116006)(52536014)(33656002)(54906003)(6436002)(478600001)(305945005)(68736007)(2906002)(53936002)(55016002)(81166006)(6246003)(66476007)(9686003)(8936002)(8676002)(81156014)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2446;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gyyV1P+nzY+iHa+d1ujKEY3luoeIZ+ytHFHVjGknXq1BL97xyI7FwXNN3yN0GyQQMi9Qdx8ywR3+Ud6TJrxKDgia4o5LypDCJvOb/qhPniBRzo9zadocu57vQpmSz2CWmTHhqzRUstQauvOWHM+mV7SxviFPIoxKfOB6cvVNvpEbrFa7UX4wg68zScUlgRw32mc7KSCZ4PQYO4kV4BKd3aALra2F78062PFuDg1AxGICMX9MWIimWMphcROwYotp5wnMAlvi5ruyCnES87JVVCZCo5rrxZC/7NRIvfFChXAKaK8nL4NIUILhJlfe4S6Mu6cFA3NbzgloYaw0wGqhwpAUc/dFwlkp5fHf+a7V2fqXcE5easLx/Xb3awo7juRZisXf8jH6rhDRigt6Djtnl46oYWh+Eudaofg1OPBxtFQ=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3258ed1c-8161-4b13-8407-08d6eeec8853
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 04:14:58.5240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yangbo.lu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2446
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJl
dyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gU2VudDogMjAxOcTqNtTCMTDI1SAyMTowNg0KPiBU
bzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4gUmljaGFyZCBD
b2NocmFuIDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+OyBSb2IgSGVycmluZw0KPiA8cm9iaCtk
dEBrZXJuZWwub3JnPjsgU2hhd24gR3VvIDxzaGF3bmd1b0BrZXJuZWwub3JnPjsNCj4gZGV2aWNl
dHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxp
bnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IDEvNl0gcHRwOiBhZGQgUW9ySVEgUFRQIHN1cHBvcnQgZm9yIERQQUEyDQo+IA0KPiBPbiBNb24s
IEp1biAxMCwgMjAxOSBhdCAxMToyMTowM0FNICswODAwLCBZYW5nYm8gTHUgd3JvdGU6DQo+ID4g
VGhpcyBwYXRjaCBpcyB0byBhZGQgUW9ySVEgUFRQIHN1cHBvcnQgZm9yIERQQUEyLg0KPiA+IEFs
dGhvdWdoIGRwYWEyLXB0cC5jIGRyaXZlciBpcyBhIGZzbF9tY19kcml2ZXIgd2hpY2ggaXMgdXNp
bmcgTUMgQVBJcw0KPiA+IGZvciByZWdpc3RlciBhY2Nlc3NpbmcsIGl0J3Mgc2FtZSBJUCBibG9j
ayB3aXRoIGVUU0VDL0RQQUEvRU5FVEMgMTU4OA0KPiA+IHRpbWVyLiBXZSB3aWxsIGNvbnZlcnQg
dG8gcmV1c2UgcHRwX3FvcmlxIGRyaXZlciBieSB1c2luZyByZWdpc3Rlcg0KPiA+IGlvcmVtYXAg
YW5kIGRyb3BwaW5nIHJlbGF0ZWQgTUMgQVBJcy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlh
bmdibyBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvcHRwL0tj
b25maWcgfCAyICstDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcHRwL0tjb25maWcgYi9kcml2
ZXJzL3B0cC9LY29uZmlnIGluZGV4DQo+ID4gOWI4ZmVlNS4uYjFiNDU0ZiAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL3B0cC9LY29uZmlnDQo+ID4gKysrIGIvZHJpdmVycy9wdHAvS2NvbmZpZw0K
PiA+IEBAIC00NCw3ICs0NCw3IEBAIGNvbmZpZyBQVFBfMTU4OF9DTE9DS19EVEUNCj4gPg0KPiA+
ICBjb25maWcgUFRQXzE1ODhfQ0xPQ0tfUU9SSVENCj4gPiAgCXRyaXN0YXRlICJGcmVlc2NhbGUg
UW9ySVEgMTU4OCB0aW1lciBhcyBQVFAgY2xvY2siDQo+ID4gLQlkZXBlbmRzIG9uIEdJQU5GQVIg
fHwgRlNMX0RQQUFfRVRIIHx8IEZTTF9FTkVUQyB8fCBGU0xfRU5FVENfVkYNCj4gPiArCWRlcGVu
ZHMgb24gR0lBTkZBUiB8fCBGU0xfRFBBQV9FVEggfHwgRlNMX0RQQUEyX0VUSCB8fA0KPiBGU0xf
RU5FVEMgfHwNCj4gPiArRlNMX0VORVRDX1ZGDQo+ID4gIAlkZXBlbmRzIG9uIFBUUF8xNTg4X0NM
T0NLDQo+IA0KPiBIaSBZYW5nYm8NCj4gDQo+IENvdWxkIENPTVBJTEVfVEVTVCBhbHNvIGJlIGFk
ZGVkPw0KDQpbWS5iLiBMdV0gQ09NUElMRV9URVNUIGlzIHVzdWFsbHkgZm9yIG90aGVyIEFSQ0hz
IGJ1aWxkIGNvdmVyYWdlLg0KRG8geW91IHdhbnQgbWUgdG8gYXBwZW5kIGl0IGFmdGVyIHRoZXNl
IEV0aGVybmV0IGRyaXZlciBkZXBlbmRlbmNpZXM/DQoNClRoYW5rcy4NCg0KPiANCj4gVGhhbmtz
DQo+IAlBbmRyZXcNCg==
