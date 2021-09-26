Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3A641890F
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 15:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhIZNju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 09:39:50 -0400
Received: from mail-eopbgr1400105.outbound.protection.outlook.com ([40.107.140.105]:19272
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231737AbhIZNjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 09:39:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cITZFNMlXxVRP88CY+SYWH59GYWJdY4IXH22uK2RpzOn/BXcts9VY9syDj6bApE+x8TRKlytIdu5NTBA9RYzP6tr++7MdlRT3zm/FQ59vdMUTOOP5LUBYPhAssT1d862ktV+8HThtnXG7AxL3Kx5f5+HGPFXYXXxlyLzWsG87o1QspvpRfK4TADNlMOk1sYnGpSv+SYZ0TqbO0PtiDsSxgWeK7O14PALtP3UlpEEhWvg2tBAUJFHd6r4Ebuz8mPVnbRWtQPQz6fGOA07FnbTNyzEQD244kZ/Abw1idMKQTs9weOdACeYvlIdKOFCEBEA1U/OR0omQ558oZuoWfK8Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=e1d8EB0V4skW9JAP1tvvpotD3cxNCP4rCIjpy433mxc=;
 b=jK0em2EnpxJLXnHfDYnUUV7rlZvV47s4Fwv62TXIGRan0mID9Y6SMxOhNtG9N/d+l+AI+hLFACuz6a9qIln3QvtIqv19n777gB1wrYjhrghQp9sty1XEjXuw9RJQ9ontDzPIsGlU0n/AdXgpo6sfBoRQY3QAlhfrk9Yq2/ttzn20C+U3xK6rp8reL0Kt5obWBKkGOQIpJ/UBBzuFE3E3/DoS2YCw07goxgmrWgr3YrzQq0Aj+9cALQzeWt4u8MIlHlsFRLUVtnUOdBexmqLs25xrl523mrSKh2riY2XdUplspANLogbxR4BLDjGQuUfNjSdlpGYErHp7jHc7Ya07lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1d8EB0V4skW9JAP1tvvpotD3cxNCP4rCIjpy433mxc=;
 b=XI/pFAolpk9i30T7GVZG0VjklKPlEOxO2SPHwI1cYJ+alxvqYutuBK5CKZj9l+ybmScdN6nG0Yw+nRYMzodXw7gq3GYG59PB5CvIklEFZpJg6XkSx6+ZMtgCboAJ8BF6pUr0m2UIIAli3ixmDzdXvXjWO8seBPpSS9eZHj6ZoxU=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB5154.jpnprd01.prod.outlook.com (2603:1096:604:65::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Sun, 26 Sep
 2021 13:38:09 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 13:38:09 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 03/18] ravb: Initialize GbEthernet dmac
Thread-Topic: [RFC/PATCH 03/18] ravb: Initialize GbEthernet dmac
Thread-Index: AQHXsIR809ll8TcGVk6ArGR8VNmdYaux+3GAgAAB9ACAAAMFoIAEVWRQ
Date:   Sun, 26 Sep 2021 13:38:09 +0000
Message-ID: <OS0PR01MB5922E6E21AD933CFFDDD871C86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-4-biju.das.jz@bp.renesas.com>
 <183fd9d2-353d-1985-7145-145a03967f6e@omp.ru>
 <OS0PR01MB592208B398BED9F36677B59B86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB59227181DCFC6A860B7063BC86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59227181DCFC6A860B7063BC86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d52b8b4c-82a1-4b3d-1aa7-08d980f2e101
x-ms-traffictypediagnostic: OSAPR01MB5154:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB5154EE46CF7797E7201C37D186A69@OSAPR01MB5154.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m1ItvAHWDu5L7q/vExNFfAlV6cizDioyxLq4QcQPFsmuK6Ffk+lgFQjO2lljcEgsDAsRGif+afqc6tqcULc4lUoYnUDPky/KRGh8a/U15tVZBFFkqfyYeByshvNjUd4QcCk8NDgC7aXYwae2RzgYbOoHKXWR1IHa8kzYuMOj2gF+8meE1YsL3f1rXARoBDeiY1cwfYWHIYyf1Vxp3dlqHazQSw9XGtyYQCyfRKehQLAn8O3YaJ3rVvPyOni4TCSNp8/g2QAtP3yvJWaT9HgCBbU8y2kGdGUYOB5yxFUO6klHBg5TKM7PB6F4FeVGXU45CTxlZaySJ8Fg7v3LA1Az7cesJ4po/ABrhYAX5LIY/yXSb9DHSy7MtRIXwMuLa46dO1YPNdfaHBFpCK39ZVCn2DOfypXvbv+3ngB8ctgBSxg0ZhHCRrdXY2+ikfAIYSS5b2PkY78CUK9MD4gbL/gnHFjBEcFm8LKixaFn8UIcxUs3pU1PpDsJgkzsugSlepTlNcey0hG7Cy6dTmGOVrPjhlNJVAkDXz9XDJFSJ3JrSGuy4+cFIs1PmydOujSYJL14Nz1Ok0mhv01+Bz1c2laqbBVopAn+GVo+mVwJO7rVEDN3dSYrk+Psf9J9gV6YSrpqoLZ26rAGibXXvZD523WjyNQkv0iWak87qpLYXtS/8n9YAl8sx6aVww95E2oD9jEaDooLRe9CmfpkZIdx/ogM2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(7696005)(316002)(71200400001)(53546011)(5660300002)(110136005)(52536014)(2906002)(4326008)(26005)(66946007)(9686003)(122000001)(8936002)(66476007)(6506007)(55016002)(86362001)(508600001)(38100700002)(186003)(38070700005)(66446008)(64756008)(66556008)(54906003)(83380400001)(8676002)(76116006)(107886003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTR6WjdZNE1IR3lkelM5bVNNZGFXcHZNM2xQdGlYeDlWT2ZpNTJ1VWRXLzEr?=
 =?utf-8?B?blFUbVAxOXplcHpuZXNNcEFCUDQ1QzZ0MTZUK0tJeSthVUNYWktJMFUrS1Yy?=
 =?utf-8?B?bDE1WGdoc2g4dmRWd0J0emcyYkJMRWdWMlRXNkI3VmRWNXVEUFZGUkU5Z0Qx?=
 =?utf-8?B?eG1NdmpMZ1FuRERJVHVjNUVleW15OEJwbUJiWWNxOXdNVS84Rk5WRjlaOEo2?=
 =?utf-8?B?YzVFcWd3N1dmUUxNVmZjcXhpNWlhUVJrMHhtT0FiK1lxQmxyMGVpZ3dNSmFT?=
 =?utf-8?B?bThBTW5kRlZoRWFSc1BCZStuU3g1OGtjZnl0Tkt2WmRQZDFIYkw3QmN5UGtm?=
 =?utf-8?B?ajBOdzhBVHN0TkhOWTVScHRSdlF0aUtIU2ZWU29sbEVUUnZHdjZLTFgzSDh6?=
 =?utf-8?B?aXoyTjFBQmowQVJ2ZkYwNWhNN1hERmpxTGlLeGkxUFB4SW1Gdm00ODBwNkdF?=
 =?utf-8?B?bitYWGpLYVdoTmcwTXFyYlhRaWIzNGZlZExkZnZWeUNtL2tiTys1SnhkN0JM?=
 =?utf-8?B?aUxmKzFUeHJOVGZOSzdRTXhwdU1GNmdVQWRVSElDZmYrUzZWQW5veWFHek1i?=
 =?utf-8?B?aVVoaTVoWTFLdmRsZWdEMU92bG9WUndnVjlyK0ZEcTdzTlJDSUlSVVduL3hx?=
 =?utf-8?B?bkFkSnlBQU5VbUZRajUxd3laRFZYL0psOVcvMjdVN3BpTTZDZ0p0MFByd0dF?=
 =?utf-8?B?U0loY1hjT290aUp5M2ZDZVdMWkNJSjg0Y3RWTENtZGVHSXlvTDBHRHJiVWx2?=
 =?utf-8?B?TzFrVFRMUXBlNHNMNm1lT0JSbnN6OGhndU14dUFlZW1rOFhlL0JzZERxR2dN?=
 =?utf-8?B?bjE2ZlZmTHh4anJxeFpHVW9PWlRxMnpqSlBNWjBKNmV0dCsybjZQd1BMbU5m?=
 =?utf-8?B?a0IyVC9wcFhXSjNlSnI2Ynlibk4ydTZUTW9rQVpEY3VVVjhqellLdEI3Z3FT?=
 =?utf-8?B?OFNLZUxMYUwxdFRvYlRycEpKRStpWjRmZ2tQZVRVdU9uVS9xTjRCWlNYc3BN?=
 =?utf-8?B?eXZqbkhlWnN3dGxGenlEam1UQzhjaG1tcGs4cjFpeDJJOHlhS0xKMExZVmRy?=
 =?utf-8?B?Ulc0bGhRSElPZUhlWmpqUWxteTc2d0d2OXMwd3Y5U0FXdFZ0dDQ2Q29zT3A5?=
 =?utf-8?B?REF5cE1TejdCTDFzdDErVkR0a1F4RCsrVnRWTU1GbzIzM1ByUnp1cnR1TTBH?=
 =?utf-8?B?ckxxUTBwdmpLMElmamkvNk5HQXd5TVc5ZG5EZVJQSGlIZEZDU3piQ1U1ZlJG?=
 =?utf-8?B?UWdKaUpsUXNNczFoQlQxbWpURzJzZW5Gc3h1b0c3c0ZjeGc5RHA3V1ZQZnI0?=
 =?utf-8?B?TWxGU0h3NjF1K3pxUkxTb0lxWmFpODQzM2VPNE1xemkwUTBNUTN6TmFNSW5V?=
 =?utf-8?B?YW0vNjdiSE4ya05KYlRQaUFKaDcyTG5oQ1lXK2drZ0VDUkpMTkl3SFMxbGJZ?=
 =?utf-8?B?dTFvdno0UjlYVndqeXU4eWJtVEVadHgvamliVjF6Ui9xMWw3Q3krb29GcVgv?=
 =?utf-8?B?SWtVby9DOGxWK1l6eldIQzNUa1V3VDB0NUM4eHh2c3lObUJKSVpybno0N3VD?=
 =?utf-8?B?ZVM2bWdTeGZFa3BuTEJsYzFCYi96Y0VLWFNtSkxOUWw1SFpZbzJ2U2ZnVTlM?=
 =?utf-8?B?NUdBN2p2OW02U0tUYm9Kd0hnM0ZXZjJjM3V5a1NvQVE3SUhxcFFuMXVxTTh5?=
 =?utf-8?B?QUFpK05NeDdYaVNWSGFTeUZ3QU9SVmdEQXlHNG43MGx4SHVCZ21rR3o3N0FL?=
 =?utf-8?Q?SAQM7IlSyiALgZ8uqvqRZA1LNg+R5m45yIgJYfw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52b8b4c-82a1-4b3d-1aa7-08d980f2e101
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 13:38:09.3479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L3DlXBH128ezi/rH0FLMRngyiMgzL8LTHhg34NRV0hqbd6/7YNp8V2AnjJ1IzS7gYhG4C4R/D3tywYqbT6wusKn+Bx8dEvx6pRKDWcBL7gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB5154
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJFOiBbUkZDL1BBVENIIDAzLzE4XSByYXZiOiBJbml0
aWFsaXplIEdiRXRoZXJuZXQgZG1hYw0KPiANCj4gSGkgU2VyZ2V5LA0KPiANCj4gPiBTdWJqZWN0
OiBSRTogW1JGQy9QQVRDSCAwMy8xOF0gcmF2YjogSW5pdGlhbGl6ZSBHYkV0aGVybmV0IGRtYWMN
Cj4gPg0KPiA+IEhJIFNlcmdlaSwNCj4gPg0KPiA+ID4gU3ViamVjdDogUmU6IFtSRkMvUEFUQ0gg
MDMvMThdIHJhdmI6IEluaXRpYWxpemUgR2JFdGhlcm5ldCBkbWFjDQo+ID4gPg0KPiA+ID4gT24g
OS8yMy8yMSA1OjA3IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gPiA+DQo+ID4gPiA+IEluaXRpYWxp
emUgR2JFdGhlcm5ldCBkbWFjIGZvdW5kIG9uIFJaL0cyTCBTb0MuDQo+ID4gPiA+IFRoaXMgcGF0
Y2ggYWxzbyByZW5hbWVzIHJhdmJfcmNhcl9kbWFjX2luaXQgdG8gcmF2Yl9kbWFjX2luaXRfcmNh
cg0KPiA+ID4gPiB0byBiZSBjb25zaXN0ZW50IHdpdGggdGhlIG5hbWluZyBjb252ZW50aW9uIHVz
ZWQgaW4gc2hfZXRoIGRyaXZlci4NCj4gPiA+ID4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogQmlq
dSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgNCArKw0KPiA+ID4g
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDg0DQo+ID4gPiA+
ICsrKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA4NSBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+ID4gYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ID4gPiBpbmRleCAwY2UwYzEzZWY4Y2Iu
LmJlZTA1ZTZmYjgxNSAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiLmgNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiLmgNCj4gPiA+ID4gQEAgLTgxLDYgKzgxLDcgQEAgZW51bSByYXZiX3JlZyB7DQo+ID4g
PiA+ICAJUlFDMwk9IDB4MDBBMCwNCj4gPiA+ID4gIAlSUUM0CT0gMHgwMEE0LA0KPiA+ID4gPiAg
CVJQQwk9IDB4MDBCMCwNCj4gPiA+ID4gKwlSVEMJPSAweDAwQjQsCS8qIFJaL0cyTCBvbmx5ICov
DQo+ID4gPg0KPiA+ID4gICAgTXkgZ2VuMyBtYW51YWwgc2F5cyB0aGUgcmVnaXVzdGVyIGV4aXN0
cyB0aGVyZS4uLg0KPiANCj4gVGhlIGV4aXN0aW5nIGRyaXZlciBpcyBub3QgdXNpbmcgaXQuIFNp
bmNlIG1hbnVhbCBzYXlzIHRoZXJlIGlzIFJUQywgSQ0KPiB3aWxsIGRvY3VtZW50IGZvciBHZW4z
IGFzIHdlbGwuDQo+IA0KPiA+ID4NCj4gPiA+ID4gIAlVRkNXCT0gMHgwMEJDLA0KPiA+ID4gPiAg
CVVGQ1MJPSAweDAwQzAsDQo+ID4gPiA+ICAJVUZDVjAJPSAweDAwQzQsDQo+ID4gPiA+IEBAIC0x
NTYsNiArMTU3LDcgQEAgZW51bSByYXZiX3JlZyB7DQo+ID4gPiA+ICAJVElTCT0gMHgwMzdDLA0K
PiA+ID4gPiAgCUlTUwk9IDB4MDM4MCwNCj4gPiA+ID4gIAlDSUUJPSAweDAzODQsCS8qIFItQ2Fy
IEdlbjMgb25seSAqLw0KPiA+ID4gPiArCVJJQzMJPSAweDAzODgsCS8qIFJaL0cyTCBvbmx5ICov
DQo+ID4gPg0KPiA+ID4gICAgQWdhaW4sIHRoaXMgcmVnaXN0ZXIgKGFsb25nIHdpdGggUklTMykg
ZXhpc3RzIG9uIGdlbjMuLi4NCj4gDQo+IFJJUzMgaXMgbm90IHVzZWQgYnkgUi1DYXIgb3IgUlov
RzJMIGhlbmNlIGl0IG5vdCBkb2N1bWVudGVkLg0KPiBCdXQgUklDMyBpcyB1c2VkIGJ5IFJaL0cy
TC4gQXMgcGVyIGdlbjMgaHcgbWFudWFsIGl0IGlzIHByZXNlbnQsIHNvIEkgd2lsbA0KPiB1cGRh
dGUgdGhlIGNvbW1lbnQuDQoNCkkgYW0gZHJvcHBpbmcgUklDMyBmb3IgUlovRzJMIGFzIGRlZmF1
bHQgdmFsdWUgIGlzIDAgYW5kIGNvZGUgaXMgaW5pdGlhbGl6aW5nIHdpdGggMA0KV2hpY2ggaXMg
bm90IG5lZWRlZC4NCg0KPiANCj4gPiA+DQo+ID4gPiA+ICAJR0NDUgk9IDB4MDM5MCwNCj4gPiA+
ID4gIAlHTVRUCT0gMHgwMzk0LA0KPiA+ID4gPiAgCUdQVEMJPSAweDAzOTgsDQo+ID4gPiA+IEBA
IC05NTYsNiArOTU4LDggQEAgZW51bSBSQVZCX1FVRVVFIHsNCj4gPiA+ID4NCj4gPiA+ID4gICNk
ZWZpbmUgUlhfQlVGX1NaCSgyMDQ4IC0gRVRIX0ZDU19MRU4gKyBzaXplb2YoX19zdW0xNikpDQo+
ID4gPiA+DQo+ID4gPiA+ICsjZGVmaW5lIFJHRVRIX1JYX0JVRkZfTUFYIDgxOTINCj4gPiA+ID4g
Kw0KPiA+ID4gPiAgc3RydWN0IHJhdmJfdHN0YW1wX3NrYiB7DQo+ID4gPiA+ICAJc3RydWN0IGxp
c3RfaGVhZCBsaXN0Ow0KPiA+ID4gPiAgCXN0cnVjdCBza19idWZmICpza2I7DQo+ID4gPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4g
PiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4gPiBp
bmRleCAyNDIyZTc0ZDliNGYuLjU0YzRkMzFhNjk1MCAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiA+IEBAIC04Myw2ICs4
MywxMSBAQCBzdGF0aWMgaW50IHJhdmJfY29uZmlnKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0K
PiA+ID4gPiAgCXJldHVybiBlcnJvcjsNCj4gPiA+ID4gIH0NCj4gPiA+ID4NCj4gPiA+ID4gK3N0
YXRpYyB2b2lkIHJhdmJfcmdldGhfc2V0X3JhdGUoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpIHsN
Cj4gPiA+ID4gKwkvKiBQbGFjZSBob2xkZXIgKi8NCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+
ID4gPiAgc3RhdGljIHZvaWQgcmF2Yl9zZXRfcmF0ZShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikg
IHsNCj4gPiA+ID4gIAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRl
dik7IEBAIC0yMTcsNg0KPiArMjIyLDExDQo+ID4gPiA+IEBAIHN0YXRpYyBpbnQgcmF2Yl90eF9m
cmVlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSwgYm9vbA0KPiA+ID4gZnJlZV90eGVk
X29ubHkpDQo+ID4gPiA+ICAJcmV0dXJuIGZyZWVfbnVtOw0KPiA+ID4gPiAgfQ0KPiA+ID4gPg0K
PiA+ID4gPiArc3RhdGljIHZvaWQgcmF2Yl9yeF9yaW5nX2ZyZWVfcmdldGgoc3RydWN0IG5ldF9k
ZXZpY2UgKm5kZXYsIGludCBxKQ0KPiB7DQo+ID4gPiA+ICsJLyogUGxhY2UgaG9sZGVyICovDQo+
ID4gPiA+ICt9DQo+ID4gPiA+ICsNCj4gPiA+ID4gIHN0YXRpYyB2b2lkIHJhdmJfcnhfcmluZ19m
cmVlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSkgIHsNCj4gPiA+ID4gIAlzdHJ1Y3Qg
cmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7IEBAIC0yODMsNg0KPiArMjkz
LDExDQo+ID4gPiA+IEBAIHN0YXRpYyB2b2lkIHJhdmJfcmluZ19mcmVlKHN0cnVjdCBuZXRfZGV2
aWNlICpuZGV2LCBpbnQgcSkNCj4gPiA+ID4gIAlwcml2LT50eF9za2JbcV0gPSBOVUxMOw0KPiA+
ID4gPiAgfQ0KPiA+ID4gPg0KPiA+ID4gPiArc3RhdGljIHZvaWQgcmF2Yl9yeF9yaW5nX2Zvcm1h
dF9yZ2V0aChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwNCj4gPiA+ID4gK2ludA0KPiA+ID4gPiAr
cSkgew0KPiA+ID4gPiArCS8qIFBsYWNlIGhvbGRlciAqLw0KPiA+ID4gPiArfQ0KPiA+ID4gPiAr
DQo+ID4gPiA+ICBzdGF0aWMgdm9pZCByYXZiX3J4X3JpbmdfZm9ybWF0KHN0cnVjdCBuZXRfZGV2
aWNlICpuZGV2LCBpbnQgcSkgIHsNCj4gPiA+ID4gIAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2
ID0gbmV0ZGV2X3ByaXYobmRldik7IEBAIC0zNTYsNg0KPiArMzcxLDEyDQo+ID4gPiA+IEBAIHN0
YXRpYyB2b2lkIHJhdmJfcmluZ19mb3JtYXQoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBx
KQ0KPiA+ID4gPiAgCWRlc2MtPmRwdHIgPSBjcHVfdG9fbGUzMigodTMyKXByaXYtPnR4X2Rlc2Nf
ZG1hW3FdKTsNCj4gPiA+ID4gIH0NCj4gPiA+ID4NCj4gPiA+ID4gK3N0YXRpYyB2b2lkICpyYXZi
X3JnZXRoX2FsbG9jX3J4X2Rlc2Moc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsDQo+ID4gPiA+ICtp
bnQNCj4gPiA+ID4gK3EpIHsNCj4gPiA+ID4gKwkvKiBQbGFjZSBob2xkZXIgKi8NCj4gPiA+ID4g
KwlyZXR1cm4gTlVMTDsNCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4gPiAgc3RhdGljIHZv
aWQgKnJhdmJfYWxsb2NfcnhfZGVzYyhzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEpICB7
DQo+ID4gPiA+ICAJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYp
OyBAQCAtNDI2LDYNCj4gKzQ0NywxMQ0KPiA+ID4gPiBAQCBzdGF0aWMgaW50IHJhdmJfcmluZ19p
bml0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSkNCj4gPiA+ID4gIAlyZXR1cm4gLUVO
T01FTTsNCj4gPiA+ID4gIH0NCj4gPiA+ID4NCj4gPiA+ID4gK3N0YXRpYyB2b2lkIHJhdmJfcmdl
dGhfZW1hY19pbml0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KSB7DQo+ID4gPiA+ICsJLyogUGxh
Y2UgaG9sZGVyICovDQo+ID4gPiA+ICt9DQo+ID4gPiA+ICsNCj4gPiA+ID4gIHN0YXRpYyB2b2lk
IHJhdmJfcmNhcl9lbWFjX2luaXQoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpICB7DQo+ID4gPiA+
ICAJLyogUmVjZWl2ZSBmcmFtZSBsaW1pdCBzZXQgcmVnaXN0ZXIgKi8gQEAgLTQ2MSw3ICs0ODcs
MzIgQEANCj4gPiA+ID4gc3RhdGljIHZvaWQgcmF2Yl9lbWFjX2luaXQoc3RydWN0IG5ldF9kZXZp
Y2UgKm5kZXYpDQo+ID4gPiA+ICAJaW5mby0+ZW1hY19pbml0KG5kZXYpOw0KPiA+ID4gPiAgfQ0K
PiA+ID4gPg0KPiA+ID4gPiAtc3RhdGljIHZvaWQgcmF2Yl9yY2FyX2RtYWNfaW5pdChzdHJ1Y3Qg
bmV0X2RldmljZSAqbmRldikNCj4gPiA+ID4gK3N0YXRpYyB2b2lkIHJhdmJfZG1hY19pbml0X3Jn
ZXRoKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KSB7DQo+ID4gPiA+ICsJLyogU2V0IEFWQiBSWCAq
Lw0KPiA+ID4gPiArCXJhdmJfd3JpdGUobmRldiwgMHg2MDAwMDAwMCwgUkNSKTsNCj4gPiA+ID4g
Kw0KPiA+ID4gPiArCS8qIFNldCBNYXggRnJhbWUgTGVuZ3RoIChSVEMpICovDQo+ID4gPiA+ICsJ
cmF2Yl93cml0ZShuZGV2LCAweDdmZmMwMDAwIHwgUkdFVEhfUlhfQlVGRl9NQVgsIFJUQyk7DQo+
ID4gPg0KPiA+ID4gICAgU2hvdWxkIGJlIGluaXQnZWQgb24gZ2VuMyBhcyB3ZWxsPw0KPiA+DQo+
ID4gUmNhciBnZW4zIGhhcyBzZXBhcmF0ZSBpbml0aWFsaXphdGlvbiByb3V0aW5lLCBUaGlzIHBh
cnQgaXMgUlovRzJMDQo+ID4gc3BlY2lmaWMsIHRoZSBidWZmZXIgc2l6ZSBpcyBkaWZmZXJlbnQu
DQo+ID4NCj4gPiA+DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwkvKiBTZXQgRklGTyBzaXplICovDQo+
ID4gPiA+ICsJcmF2Yl93cml0ZShuZGV2LCAweDAwMjIyMjAwLCBUR0MpOw0KPiA+ID4gPiArDQo+
ID4gPiA+ICsJcmF2Yl93cml0ZShuZGV2LCAwLCBUQ0NSKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiAr
CS8qIEZyYW1lIHJlY2VpdmUgKi8NCj4gPiA+ID4gKwlyYXZiX3dyaXRlKG5kZXYsIFJJQzBfRlJF
MCwgUklDMCk7DQo+ID4gPiA+ICsJLyogRGlzYWJsZSBGSUZPIGZ1bGwgd2FybmluZyAqLw0KPiA+
ID4gPiArCXJhdmJfd3JpdGUobmRldiwgMHgwLCBSSUMxKTsNCj4gPiA+ID4gKwkvKiBSZWNlaXZl
IEZJRk8gZnVsbCBlcnJvciwgZGVzY3JpcHRvciBlbXB0eSAqLw0KPiA+ID4gPiArCXJhdmJfd3Jp
dGUobmRldiwgUklDMl9RRkUwIHwgUklDMl9SRkZFLCBSSUMyKTsNCj4gPiA+ID4gKw0KPiA+ID4g
PiArCXJhdmJfd3JpdGUobmRldiwgMHgwLCBSSUMzKTsNCj4gPiA+DQo+ID4gPiAgICBTaG91bGQg
YmUgaW5pdCdlZCBvbiBnZW4zIGFzIHdlbGw/IE1hdHRlciBvZiBhIHNlcGFyYXRlIHBhdGNoLCBJ
DQo+ID4gPiBjYW4gZG8gaXQgcHJvbGx5Li4uDQo+ID4NCj4gPiBPSy4gTWF5IGJlIGFmdGVyIGNv
bXBsZXRpbmcgUlovRzJMLCBJIGNhbiBpbnZlc3RpZ2F0ZSBvbiBnZW4zIHN0dWZmIG9yDQo+ID4g
SWYgeW91IGhhdmUgUi1DYXIgYm9hcmQgYW5kIGNvbmZpcm0gdGhpcyBjaGFuZ2UgV29uJ3QgYnJl
YWsgYW55dGhpbmcNCj4gPiBvbiBSLUNhciBnZW4zLCB5b3UgY2FuIHN1Ym1pdCB0aGUgcGF0Y2gu
DQoNCkFzIG1lbnRpb25lZCBhYm92ZSBJIGFtIGRyb3BwaW5nIHRoaXMgaW5pdGlhbGl6YXRpb24g
Zm9yIFJJQzMsIGFzIHBlciBIL1cgbWFudWFsDQpSZXNldCB2YWx1ZSBvZiBSSUMzIGlzIDAuDQoN
ClJlZ2FyZHMsDQpCaWp1DQo=
