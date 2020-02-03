Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710C6150313
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 10:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgBCJO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 04:14:26 -0500
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:6017
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726244AbgBCJO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 04:14:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgkWBI2sBamPV88W9iuHCt7vyZEVdT5gHZ5iiwr2ccoMUxQqKQK2ckHwJaxI3cqp8+J3rQ3r8Ws+cUpTZNKnJSsKzs2CPWSk9yJSUJkH7b5yAT3hIYAFQGLHlT+w/FINGGsIxfBEuIjBIfpQhnImmX5+jBSXGNio3n4rUPlcfVQD7AI4p6ZXtrL87YbD0qByVOwD4Fs9yIqrNfTFuNbau+WBXTStYbzvbgMrhKXI93RLWEvTODhxr5CH4mKu3IwNKLQtbilJmKbpvzLGi+WCJ9l26k2R43ABZPcMVgep62xJXHmITqvLwntrh95DLHA7/WVzf8gsNKJban/z9DHCmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5DtGSMdHoh9RbC6UibIQ3bTN5i+onI6/UQlQeccVI8=;
 b=AO56tLN2ldUhrpM0r7oINnuGWOiyXqo/guTTRYvRzCWaeiplA5uJaUMk221u0QVDkRIHb6ByR4epf5X0gUVEGCGyFnLlVDoLbWMXvemGFcQ9LfwECOWSfv8JTeb5XNhGErayjIdxtxDh5pjYCcHucNzy6fm6AeLw7ttx3Rs0n5cpujdKljKr83NJOYtWLIb5dQxuDikvk3aLB9O1YdMXV7dEl0XH+IKH2UU7DT4axddJEfs7xey43N0mJtOB4gJrlZxzPkhf1G3EShhZgVO1jPxXqP3IockE139d1Kn2BBH01I94A7B1JlUDDsQHeUg0UiTETIUzjfEjBU1F82R4lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5DtGSMdHoh9RbC6UibIQ3bTN5i+onI6/UQlQeccVI8=;
 b=RjgAr0yadfOayXcaVSnCbns7O4bzFoQ709Feuv0zzHSHr3ignSPkL0/PZwqcr9cm2l9fgeAsHqlCdst4kCfPf5us0zw4hKiOtP8+N7sFfI8AnbAgCxyBTB6d7tRQ9GOqFdTACmceme+n/RMxMf2uyUxTxyJ+5u+2vtfjFNS6SKk=
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (20.178.202.86) by
 AM0PR04MB6017.eurprd04.prod.outlook.com (20.179.33.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Mon, 3 Feb 2020 09:13:42 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07%7]) with mapi id 15.20.2686.028; Mon, 3 Feb 2020
 09:13:42 +0000
From:   "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC:     "linux.cj@gmail.com" <linux.cj@gmail.com>,
        Jon Nettleton <jon@solid-run.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Matteo Croce <mcroce@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH v1 4/7] device property: fwnode_get_phy_mode: Change API
 to solve int/unit warnings
Thread-Topic: [PATCH v1 4/7] device property: fwnode_get_phy_mode: Change API
 to solve int/unit warnings
Thread-Index: AQHV2nI6nPm6Kny3S0qrJenP9wKoOA==
Date:   Mon, 3 Feb 2020 09:13:42 +0000
Message-ID: <AM0PR04MB5636C44D0943B7E5F01218DF93000@AM0PR04MB5636.eurprd04.prod.outlook.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-5-calvin.johnson@nxp.com>
 <CAHp75Vdnz79NiHs5MfxAevzOuk-A6ESHR+Epoym+v3Qo4XPvLw@mail.gmail.com>
In-Reply-To: <CAHp75Vdnz79NiHs5MfxAevzOuk-A6ESHR+Epoym+v3Qo4XPvLw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4de3b39a-fbbf-418e-886d-08d7a8895d52
x-ms-traffictypediagnostic: AM0PR04MB6017:|AM0PR04MB6017:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6017F552AE81B65E5ED675D2D2000@AM0PR04MB6017.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(189003)(199004)(71200400001)(8676002)(52536014)(81166006)(81156014)(8936002)(7696005)(4744005)(478600001)(966005)(5660300002)(55016002)(54906003)(110136005)(9686003)(76116006)(316002)(7416002)(66446008)(64756008)(186003)(4326008)(53546011)(66556008)(66476007)(86362001)(6506007)(2906002)(26005)(66946007)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6017;H:AM0PR04MB5636.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aaaLWz/OsnT9DwxZ05eB8gYtGgPgM6qiuTFjSooNC6ND4U+VK3lBkiyOA0+aeMEAwOJCI0s7erwR3YIC2h3lXzIRP7OmsZTQoOskzJ8e9sSlkjX3k8FDBYz6bPIu1p+5h2dpJbrhMKepIuhkml2jE/qyhXRBhlJD0AUGhAnlYbEVpu0jtZzj44No77igg6ydJwuxpmGGcKskVkdTpB6ofR4xxc7dY0q3efyTKQr7K4l6XC5dJ7tTYd/s9uX9JCbtHKNobhH/wH063vrdnpR6zfdQAEu0TikDMIdoJ1HFlBFwTF6x/5zCNKHPiD1YrS3K4EqDSrQskWZMSP7tklWeOd6K4OuTNCJSo8z+ccqx9GK8kl8MRlDwlHsj1eTK4Ubo2g1rGDj8TnXlP8xy2Nh9GWVxawA0ljRLyFDNJh5lZkxN6OLhoUYvS6mMQ7CN+uq48Lpwz3fgNO+Pdqu9tEu+XLhF601eq+BhnYbc9Ggjq8KICIe/RTDccs+D/Q0lDM/jVtCn3leLCqE6LZ8xtuP3Xg==
x-ms-exchange-antispam-messagedata: MBUstTe65wfRlzaKfu/DazxDoqGd+A8hwmIASnqppfJi/gldRM42ek90wkfUzvbOsf15PCMwPvurOg25/ssj+IN0Fiowc8CkdAsMdHppCtc4LTexJvU1WPNZyBEAgiYEuRQEq/lM4UGtCiPs902SaA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de3b39a-fbbf-418e-886d-08d7a8895d52
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 09:13:42.5230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lIildBwFBVhdO+qdorIhq33UmwwglBTzPQhJUk+N+n2IUzRU1ej4DfEt2PjKWWtwqpzAjRMYR5rPkdrjAREDPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5keSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmR5IFNo
ZXZjaGVua28gPGFuZHkuc2hldmNoZW5rb0BnbWFpbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggdjEgNC83XSBkZXZpY2UgcHJvcGVydHk6IGZ3bm9kZV9nZXRfcGh5X21vZGU6DQo+IENoYW5n
ZSBBUEkgdG8gc29sdmUgaW50L3VuaXQgd2FybmluZ3MNCj4gDQo+IE9uIEZyaSwgSmFuIDMxLCAy
MDIwIGF0IDU6MzggUE0gQ2FsdmluIEpvaG5zb24gPGNhbHZpbi5qb2huc29uQG54cC5jb20+DQo+
IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogQ2FsdmluIEpvaG5zb24gPGNhbHZpbi5qb2huc29uQG9z
cy5ueHAuY29tPg0KPiA+DQo+ID4gQVBJIGZ3bm9kZV9nZXRfcGh5X21vZGUgaXMgbW9kaWZpZWQg
dG8gZm9sbG93IHRoZSBjaGFuZ2VzIG1hZGUgYnkNCj4gPiBDb21taXQgMGM2NWIyYjkwZDEzYzEg
KCJuZXQ6IG9mX2dldF9waHlfbW9kZTogQ2hhbmdlIEFQSSB0byBzb2x2ZQ0KPiA+IGludC91bml0
IHdhcm5pbmdzIikuDQo+IA0KPiBJIHRoaW5rIGl0IHdvdWxkIGJlIGdvb2QgdG8gYmFzZSB5b3Vy
IHNlcmllcyBvbiBEYW4ncyBmaXggcGF0Y2guDQoNClRoaXMgcGF0Y2ggaXMgYmFzZWQgb24gRGFu
J3MgZml4IHBhdGNoIGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL25ldGRldi9tc2c2MDY0
ODcuaHRtbCAuDQpDb21taXQgMGM2NWIyYjkwZDEzYzEgKCJuZXQ6IG9mX2dldF9waHlfbW9kZTog
Q2hhbmdlIEFQSSB0byBzb2x2ZSBpbnQvdW5pdCB3YXJuaW5ncyIpLg0KQ2FuIHlvdSBwbGVhc2Ug
Z2l2ZSBtb3JlIGNsYXJpdHkgb24gd2hhdCB5b3UgbWVhbnQ/IFBsZWFzZSBwb2ludCB0byBtZSwg
aWYgdGhlcmUgaXMgc29tZSANCnNwZWNpZmljIHBhdGNoIHRoYXQgeW91IGFyZSByZWZlcnJpbmcg
dG8uDQoNClRoYW5rcw0KQ2FsdmluDQo=
