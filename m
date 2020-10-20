Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5A2293DCD
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407652AbgJTNwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:52:49 -0400
Received: from mail-am6eur05on2068.outbound.protection.outlook.com ([40.107.22.68]:55553
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407628AbgJTNws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 09:52:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gbkcrl8tmyQRZ3x08hUSQauK+bxUDeYtgX07FhvIVQacKiqOwzaZtx7m/8PSNYwnwcYjsvTWQbKF4AgDHsszlqPJgq2u9qJlArGqtMDG6j2NBsmS+WscRslrxe1LqRIIra319h08W8lz0jmrXQ8f7EJhPd8l/CEGXlks1q9TDDrearZDTWc9uVleIeFinIK7BxaznqMQUqCCac5LUy+RlVoBpQ3EDlGcYyP24JuDG7pU+I0WS/Ij3oDkUGVp9LWjKz8V4Bs5cZpRMUs//K2+vneOMnExZ5LS8y/F9ZvpzCy6X61+TCvgdmQMXXgyyU6WFbpG0Vi4KnIwnIXUNdh6AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tI80Bvde7p7dm5r405ce2dTyL2qWylvLEH7wJsg+wfE=;
 b=QbXydb3MIq9+7Ap5C/F2xhXESsvqbBpAB/bTIUljn88f2Vrt3BV63g+IeNtF6TopAqFU990MozfuD2HOl9qJBMsxkEN9DN9igr7uNsREYGXc3BcHogqFI5xY1/C7XXyrn8OtlZwk5CFi/qZvBXEe7NbMClD58ohuvfZZKtc6kvtsNgRjGU9iRCQzOiUReBacoN2/mKIt2qARSgyxaHVV7/rmha5YO6sW2b1Gf+fHxWQYOfTbofYowuaznlww2sJJN7Ngui/fRJNJQKOtYM5u2sv5kUJnxRD7OXlWpSfb8rKAijIIRbrgbsAT2KxR2FE6dtYEFPwvO4L21Q2s9pPbqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tI80Bvde7p7dm5r405ce2dTyL2qWylvLEH7wJsg+wfE=;
 b=l1lcoyYsJ0hHZZd7gSgdelOIgy1BZJaVF0kQMtNJ25HGJwi5j5r07KkLUE59rM4HbjDEve49HytYq7v8oBTkaGnX709JttkvGs8262jk5X5ZhFZYttKt/j+wQs5iPZt+YXNqQnVIz4fJZStUNBFgycH3H2PwzBjAjvKGQRmUUx0=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM0PR04MB4897.eurprd04.prod.outlook.com (2603:10a6:208:c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 20 Oct
 2020 13:52:45 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 13:52:45 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chris Healy <cphealy@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Greg Ungerer <gerg@linux-m68k.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Topic: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Index: AQHWpoauv6yGoz1SREmyP2rAbcRdI6mfx44AgAAFGyCAAKn6AIAACnOQ
Date:   Tue, 20 Oct 2020 13:52:44 +0000
Message-ID: <AM8PR04MB7315470E5A26BB757F503025FF1F0@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
 <AM8PR04MB73150BDBA6E79ABE662B6762FF1F0@AM8PR04MB7315.eurprd04.prod.outlook.com>
 <CAFXsbZopA5esZzdNkFAxUpfwK6zmtRKn07TUfa2ShR4Y-qXBNw@mail.gmail.com>
In-Reply-To: <CAFXsbZopA5esZzdNkFAxUpfwK6zmtRKn07TUfa2ShR4Y-qXBNw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [101.86.122.105]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 56f7b5aa-cd57-4fb0-31cd-08d874ff6c05
x-ms-traffictypediagnostic: AM0PR04MB4897:
x-microsoft-antispam-prvs: <AM0PR04MB48974B1122572220975EF35FFF1F0@AM0PR04MB4897.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9eMv6uodKOX9z3bFZCzDJqUFJQV4Auf56+PzcBK3ZlqzPq+SfP9sLGuJmIw0G/xB+w22WLB3iC1ONf0yGi25x0YQiygmZZrQfe5T6UUpslvaLkef2SDWnAtF65k6LATkZp4aFNeM0bl5NFqYXgdiqESmnFRp9/iIaFDXSPM2G0ZJmgly8M1fAEM+bvadRxk6u3Y1Gedq6gCBtYoxAIu8GSikraJ6S/1QPAgKqb78I8CfKsXK5CLfCJr6ArHj4hzJFAV+aTjIlHMHvlmqwwXiBIRYNLGyHf0BgHwKpnRe/0kGsX86DFaQhROTKERFf/xrtgGpK7Jg4veeLopdlz2yxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(346002)(136003)(376002)(366004)(52536014)(66556008)(86362001)(33656002)(66476007)(186003)(66946007)(8936002)(66446008)(76116006)(6916009)(55016002)(5660300002)(26005)(53546011)(316002)(6506007)(64756008)(8676002)(478600001)(4326008)(71200400001)(54906003)(9686003)(7696005)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: D4X14+AihEH+HbA28/tXtbDaO1vOKtLxXIO5AFpRMAGazqlpkOiKwq2o2f1FfQuFFMtm/aF6fWbyzGEN2HaRViKwJ6W/o81YUfEKWH8p94mcEmiTRLhyBhatiNoBe9nIJblzHgVuHnXdiHVVFoVakCjlkATMxCt73O7BS96uw1qKD74nx0qnQ949PSqlh6QIcOowbz1ssuFp9FrC46/wj24slu/Fw4TtaEyLpoKuCqxWbPViZflutzjDzb+BBayI96GbQ9K8RoJV89p6pCmnbHugtV9Je+Lc6zNls+naSgzYszKGORbcWXz3f9bjb68Bx3KzyPrjIFtW0Kypm0AWYn0jv5k4UTcMIXWRotJDcZNSxhaWGOhPSx0+0CFD4JeJCBegeVxd2ZzGA/avu9GIomqHsrLOV7uq6X6PlX+Vb9rtlBs2G2skj24I1S3BE9lEHhRMA6qBijYc4Lm0aS1JEOfC1Hmpnf45zIKJrOA2Rluaw7oVy5KqRdjMwu4hN1G1MD+yecRdTiQTXPi9YSXAfGraO9JZL4BV7/9IX/Isa4LQW9iwhPpd6WoLcxmQ30lK4lCo9JJyGcW0grzyJyuy002r57TS03TgCKsuAU/mXz7gZlOviGzTblpHNoyaGTeSvggEvhc9FhcAOwMMIXb6kw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f7b5aa-cd57-4fb0-31cd-08d874ff6c05
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 13:52:44.9686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b3WU+qvsm9lW01Xi5gB44oXjamO4PefDy25fn4T1XHp+uq6b15LqDfUyUZV+CnalItnrAaMweCBD4algIGmKjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4897
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgSGVhbHkgPGNwaGVhbHlAZ21haWwuY29tPiBTZW50OiBUdWVzZGF5LCBPY3Rv
YmVyIDIwLCAyMDIwIDk6MDcgUE0NCj4gT24gTW9uLCBPY3QgMTksIDIwMjAgYXQgODowMiBQTSBB
bmR5IER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVyIDIwLCAyMDIw
DQo+ID4gMTA6NDAgQU0NCj4gPiA+IE9uIFR1ZSwgT2N0IDIwLCAyMDIwIGF0IDEyOjE0OjA0UE0g
KzEwMDAsIEdyZWcgVW5nZXJlciB3cm90ZToNCj4gPiA+ID4gSGkgQW5kcmV3LA0KPiA+ID4gPg0K
PiA+ID4gPiBDb21taXQgZjE2NmY4OTBjOGYwICgiW1BBVENIXSBuZXQ6IGV0aGVybmV0OiBmZWM6
IFJlcGxhY2UNCj4gPiA+ID4gaW50ZXJydXB0IGRyaXZlbiBNRElPIHdpdGggcG9sbGVkIElPIikg
YnJlYWtzIHRoZSBGRUMgZHJpdmVyIG9uIGF0DQo+ID4gPiA+IGxlYXN0IG9uZSBvZiB0aGUgQ29s
ZEZpcmUgcGxhdGZvcm1zICh0aGUgNTIwOCkuIE1heWJlIG90aGVycywgdGhhdA0KPiA+ID4gPiBp
cyBhbGwgSSBoYXZlIHRlc3RlZCBvbiBzbyBmYXIuDQo+ID4gPiA+DQo+ID4gPiA+IFNwZWNpZmlj
YWxseSB0aGUgZHJpdmVyIG5vIGxvbmdlciBmaW5kcyBhbnkgUEhZIGRldmljZXMgd2hlbiBpdA0K
PiA+ID4gPiBwcm9iZXMgdGhlIE1ESU8gYnVzIGF0IGtlcm5lbCBzdGFydCB0aW1lLg0KPiA+ID4g
Pg0KPiA+ID4gPiBJIGhhdmUgcGlubmVkIHRoZSBwcm9ibGVtIGRvd24gdG8gdGhpcyBvbmUgc3Bl
Y2lmaWMgY2hhbmdlIGluIHRoaXMgY29tbWl0Og0KPiA+ID4gPg0KPiA+ID4gPiA+IEBAIC0yMTQz
LDggKzIxNDIsMjEgQEAgc3RhdGljIGludCBmZWNfZW5ldF9taWlfaW5pdChzdHJ1Y3QNCj4gPiA+
IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gPiA+ID4gPiAgICAgaWYgKHN1cHByZXNzX3ByZWFt
YmxlKQ0KPiA+ID4gPiA+ICAgICAgICAgICAgIGZlcC0+cGh5X3NwZWVkIHw9IEJJVCg3KTsNCj4g
PiA+ID4gPiArICAgLyogQ2xlYXIgTU1GUiB0byBhdm9pZCB0byBnZW5lcmF0ZSBNSUkgZXZlbnQg
Ynkgd3JpdGluZyBNU0NSLg0KPiA+ID4gPiA+ICsgICAgKiBNSUkgZXZlbnQgZ2VuZXJhdGlvbiBj
b25kaXRpb246DQo+ID4gPiA+ID4gKyAgICAqIC0gd3JpdGluZyBNU0NSOg0KPiA+ID4gPiA+ICsg
ICAgKiAgICAgIC0gbW1mclszMTowXV9ub3RfemVybyAmIG1zY3JbNzowXV9pc196ZXJvICYNCj4g
PiA+ID4gPiArICAgICogICAgICAgIG1zY3JfcmVnX2RhdGFfaW5bNzowXSAhPSAwDQo+ID4gPiA+
ID4gKyAgICAqIC0gd3JpdGluZyBNTUZSOg0KPiA+ID4gPiA+ICsgICAgKiAgICAgIC0gbXNjcls3
OjBdX25vdF96ZXJvDQo+ID4gPiA+ID4gKyAgICAqLw0KPiA+ID4gPiA+ICsgICB3cml0ZWwoMCwg
ZmVwLT5od3AgKyBGRUNfTUlJX0RBVEEpOw0KPiA+ID4gPg0KPiA+ID4gPiBBdCBsZWFzdCBieSBy
ZW1vdmluZyB0aGlzIEkgZ2V0IHRoZSBvbGQgYmVoYXZpb3IgYmFjayBhbmQNCj4gPiA+ID4gZXZl
cnl0aGluZyB3b3JrcyBhcyBpdCBkaWQgYmVmb3JlLg0KPiA+ID4gPg0KPiA+ID4gPiBXaXRoIHRo
YXQgd3JpdGUgb2YgdGhlIEZFQ19NSUlfREFUQSByZWdpc3RlciBpbiBwbGFjZSBpdCBzZWVtcw0K
PiA+ID4gPiB0aGF0IHN1YnNlcXVlbnQgTURJTyBvcGVyYXRpb25zIHJldHVybiBpbW1lZGlhdGVs
eSAodGhhdCBpcw0KPiA+ID4gPiBGRUNfSUVWRU5UIGlzDQo+ID4gPiA+IHNldCkgLSBldmVuIHRo
b3VnaCBpdCBpcyBvYnZpb3VzIHRoZSBNRElPIHRyYW5zYWN0aW9uIGhhcyBub3QgY29tcGxldGVk
DQo+IHlldC4NCj4gPiA+ID4NCj4gPiA+ID4gQW55IGlkZWFzPw0KPiA+ID4NCj4gPiA+IEhpIEdy
ZWcNCj4gPiA+DQo+ID4gPiBUaGlzIGhhcyBjb21lIHVwIGJlZm9yZSwgYnV0IHRoZSBkaXNjdXNz
aW9uIGZpenpsZWQgb3V0IHdpdGhvdXQgYQ0KPiA+ID4gZmluYWwgcGF0Y2ggZml4aW5nIHRoZSBp
c3N1ZS4gTlhQIHN1Z2dlc3RlZCB0aGlzDQo+ID4gPg0KPiA+ID4gd3JpdGVsKDAsIGZlcC0+aHdw
ICsgRkVDX01JSV9EQVRBKTsNCj4gPiA+DQo+ID4gPiBXaXRob3V0IGl0LCBzb21lIG90aGVyIEZF
QyB2YXJpYW50cyBicmVhayBiZWNhdXNlIHRoZXkgZG8gZ2VuZXJhdGUNCj4gPiA+IGFuIGludGVy
cnVwdCBhdCB0aGUgd3JvbmcgdGltZSBjYXVzaW5nIGFsbCBmb2xsb3dpbmcgTURJTyB0cmFuc2Fj
dGlvbnMgdG8NCj4gZmFpbC4NCj4gPiA+DQo+ID4gPiBBdCB0aGUgbW9tZW50LCB3ZSBkb24ndCBz
ZWVtIHRvIGhhdmUgYSBjbGVhciB1bmRlcnN0YW5kaW5nIG9mIHRoZQ0KPiA+ID4gZGlmZmVyZW50
IEZFQyB2ZXJzaW9ucywgYW5kIGhvdyB0aGVpciBNRElPIGltcGxlbWVudGF0aW9ucyB2YXJ5Lg0K
PiA+ID4NCj4gPiA+ICAgICAgICAgICBBbmRyZXcNCj4gPg0KPiA+IEFuZHJldywgZGlmZmVyZW50
IHZhcmFudHMgaGFzIGxpdHRsZSBkaWZmZXJlbnQgYmVoYXZpb3IsIHNvIHRoZSBsaW5lDQo+ID4g
aXMgcmVxdWlyZWQgZm9yDQo+ID4gSW14Ni83LzcgcGxhdGZvcm1zIGJ1dCBzaG91bGQgYmUgcmVt
b3ZlZCBpbiBpbXg1IGFuZCBDb2xkRmlyZS4NCj4gDQo+IERvIHdlIGtub3cgd2hpY2ggdmFyaWFu
dHMgb2YgaS5NWDYgYW5kIGkuTVg3IGRvIGFuZCBkb24ndCBuZWVkIHRoaXM/DQo+IEknbSBzdWNj
ZXNzZnVsbHkgcnVubmluZyB3aXRoIHBvbGxpbmcgbW9kZSB1c2luZyB0aGUgaS5NWDZxLCBpLk1Y
NnFwLCBpLk1YN2QsDQo+IGFuZCBWeWJyaWQsIGFsbCBvZiB3aGljaCBiZW5lZml0IGZyb20gdGhl
IGNvbnNpZGVyYWJseSBoaWdoZXIgdGhyb3VnaHB1dA0KPiBhY2hpZXZlZCB3aXRoIHBvbGxpbmcu
ICAoSW4gYWxsIG15IHVzZSBjYXNlcyBJJ20gd29ya2luZyB3aXRoIGFuIEV0aGVybmV0IFN3aXRj
aA0KPiBhdHRhY2hlZCB2aWEgTURJTy4pDQo+IA0KSSB0aGluayB0aGUgb2xkIHZlcnNpb24gbGlr
ZSBpbXg1MyBhbmQgQ29sZEZpcmUgZG9uJ3QgbmVlZCB0aGlzLg0KT3RoZXJzIGxpa2UgaW14Ni83
Lzggc2VyaWVzIHJlcXVpcmVkIHRoaXMuDQoNCj4gPg0KPiA+IEFzIHdlIGRpc2N1c3Mgb25lIHNv
bHV0aW9uIHRvIHJlc29sdmUgdGhlIGlzc3VlLCBidXQgaXQgYnJpbmcgMzBtcyBsYXRlbmN5IGZv
cg0KPiBrZXJuZWwgYm9vdC4NCj4gPg0KPiA+IE5vdywgSSB3YW50IHRvIHJldmVydCB0aGUgcG9s
bGluZyBtb2RlIHRvIG9yaWdpbmFsIGludGVycnVwdCBtb2RlLCBkbyB5b3UNCj4gYWdyZWUgPw0K
PiA+DQo+ID4gQW5keQ0K
