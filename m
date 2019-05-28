Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE012BFC0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 08:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfE1GxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 02:53:12 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:16036
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727443AbfE1GxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 02:53:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TT5fcjOMtXOP0iUUexEmhQZ3dg4Zj2xyUdFYJkXhYCM=;
 b=YH8IotdpTTWyZvmsykmLz3ZOhyIFAS724Nl5RJlr6cH+1lJik7DdNu3cfXeg0fXnkUz6j+SwprDNYNswuwOLFnr3IKXoB0JB0F5rtRNN0w3YRzsQqd1Z+uquqnUIdVSFYrfk1J972WtPoKgRCthZYKC80DwW2USaubE84Z60CJY=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3343.eurprd04.prod.outlook.com (52.134.8.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Tue, 28 May 2019 06:53:08 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1922.019; Tue, 28 May 2019
 06:53:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH 01/11] net: phy: Add phy_sysfs_create_links helper
 function
Thread-Topic: [PATCH 01/11] net: phy: Add phy_sysfs_create_links helper
 function
Thread-Index: AQHVFNJa0qNishXoh0KRuv8+X0YdQ6Z/nz0AgAB6x5A=
Date:   Tue, 28 May 2019 06:53:08 +0000
Message-ID: <VI1PR0402MB2800AB70BDD96BCFE3564D8FE01E0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
 <1558992127-26008-2-git-send-email-ioana.ciornei@nxp.com>
 <CAOMZO5CKTJT5fOYsw4XuQdKGRiFSQQqum5nci79wSuNOnyhrWw@mail.gmail.com>
In-Reply-To: <CAOMZO5CKTJT5fOYsw4XuQdKGRiFSQQqum5nci79wSuNOnyhrWw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99b6bcdd-8d62-4f3b-e83f-08d6e33924c3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3343;
x-ms-traffictypediagnostic: VI1PR0402MB3343:
x-microsoft-antispam-prvs: <VI1PR0402MB3343487312F2B73F591704B5E01E0@VI1PR0402MB3343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(366004)(396003)(376002)(346002)(189003)(199004)(1411001)(55016002)(76176011)(9686003)(7696005)(99286004)(316002)(14454004)(74316002)(476003)(44832011)(76116006)(486006)(8936002)(6506007)(11346002)(53546011)(102836004)(54906003)(256004)(5024004)(7736002)(33656002)(73956011)(68736007)(6116002)(3846002)(4326008)(446003)(305945005)(25786009)(81156014)(71190400001)(8676002)(66066001)(5660300002)(6246003)(66946007)(66556008)(2906002)(6916009)(52536014)(66476007)(229853002)(66446008)(64756008)(4744005)(53936002)(26005)(81166006)(6436002)(71200400001)(478600001)(186003)(86362001)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3343;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YvwJepEmMOJ6vZPOOSddbIGOwNmS81L5K+uktLA7adp6lzrWbBbRMeXEmV0C1Q0LUb5XtM1ivn4XuWPTIZzrJ9vazPtCoTs8LceZAG6ZmLEspyLP/bfSWjH7SqKv3TVxHA1Es2vQW2A3MnSKVungrkaOAR5/9k1lw10dCZr6+pAi9mpgTIvV5Wwp4dAJEccu0kmE9PumM5/sgfUCn9o5BB2iN00fDbStFF6J2jW7yhseVLCid9WF1UZIIbpMDCkZ9WTfwU/FnKi5e+F+11TWJ30DO9B2CElAS0RO68JOIz+dAvb5dPh4vPIyn9uQWm+x1bQWwW3TZ1m4BPEdUDtdOuAHdOPzgClRCtsx6y5yU1ypmaaTxsH5GNgHEO7S2TQfQQZTkBfGupvmv3ZE11dkZtye6ohroG9DYPnqhckfWQo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b6bcdd-8d62-4f3b-e83f-08d6e33924c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 06:53:08.8393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMDEvMTFdIG5ldDogcGh5OiBBZGQgcGh5X3N5c2ZzX2Ny
ZWF0ZV9saW5rcyBoZWxwZXIgZnVuY3Rpb24NCj4gDQo+IEhpIElvYW5hLA0KPiANCj4gT24gTW9u
LCBNYXkgMjcsIDIwMTkgYXQgNjo0NyBQTSBJb2FuYSBDaW9ybmVpIDxpb2FuYS5jaW9ybmVpQG54
cC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52
QGdtYWlsLmNvbT4NCj4gPg0KPiA+IFRoaXMgaXMgYSBjb3NtZXRpYyBwYXRjaCB0aGF0IHdyYXBz
IHRoZSBvcGVyYXRpb24gb2YgY3JlYXRpbmcgc3lzZnMNCj4gPiBsaW5rcyBiZXR3ZWVuIHRoZSBu
ZXRkZXYtPnBoeWRldiBhbmQgdGhlIHBoeWRldi0+YXR0YWNoZWRfZGV2Lg0KPiA+DQo+ID4gVGhp
cyBpcyBuZWVkZWQgdG8ga2VlcCB0aGUgaW5kZW50YXRpb24gbGV2ZWwgaW4gY2hlY2sgaW4gYSBm
b2xsb3ctdXANCj4gPiBwYXRjaCB3aGVyZSB0aGlzIGZ1bmN0aW9uIHdpbGwgYmUgZ3VhcmRlZCBh
Z2FpbnN0IHRoZSBleGlzdGVuY2Ugb2YgYQ0KPiA+IHBoeWRldi0+YXR0YWNoZWRfZGV2Lg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4N
Cj4gPiBSZXZpZXdlZC1ieTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+
DQo+IA0KPiBBcyB5b3UgYXJlIHRyYW5zbWl0dGluZyB0aGUgcGF0Y2ggYXV0aG9yZWQgYnkgb3Ro
ZXIgcGVyc29uLCB5b3UgbmVlZCB0byBwcm92aWRlDQo+IHlvdXIgU2lnbmVkLW9mZi1ieSB0YWcu
DQoNClNvcnJ5IGZvciB0aGUgbWlzaGFwLiBJIGZvcmdvdCB0byBhZGQgaXQgdG8gdGhpcyBwYXRj
aC4gVGhhbmtzIGZvciBwb2ludGluZyBpdCBvdXQuDQoNCi0tDQpJb2FuYQ0K
