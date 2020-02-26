Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17AD21707C1
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 19:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgBZSc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 13:32:59 -0500
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:23544
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726789AbgBZSc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 13:32:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHYbyzo9CbqJ70o39u/oK2iDC1b3rzLLg0lX6P4Ib1SyXTdAAnlmjZX4667w2vxInhOBH++tPvQCzcNR1VyqUzZ6OBhl+5Hy+v+Qun3BdItdt+X7w2t7SgVhthzA0q0SEJvzkvRiIWZxLuzyABN+ijP8xyM7UNfkDHdVJtKYHS2Bun43/ahoCn0wkfX+AytV4Gel7wvyJ3Ao2AchXRXH/tqFyd8ByA+QCR74zsPfEQEa8OOVlR1Hxnyj+qtXG/TkaYLq8x4AJLUDFV1RlKrmCz7aflVlAyYiWaM7HJ9JSP9idqibawoeztfXBw7GZ8a6IF3h0ke80v2RTOnfIU+VKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOZbHd8rb11IWwTmLIPwcGQSygILwk2WEQIOs0sYfk8=;
 b=T69WxntVRv3fxbEpaqCK9MyKDUV2hsEBdWyohb+tzHNllZSsPCuvuVt4qsfYJWVwcztG6dG5K4oD+ThK58N0SEVpe41o55GUGx527ld0CbcgkxqwSdTsnkNVlkxaNFEeTlScOMzZQkhe2idt93XCgCLnRS2eDyxBOQfpRgy6O2XDru/jkVfb4T/Uuc7Bc6qbVel9p3QJQFKITN1BE08r3FP9uz87R0/BIAeaXPF+dQE8JT7ZWYQcpbyim9sfWylSvKiUYU8Zd66PP7sCLYNWeVQXj697hjQu9Zgq37+HoxtG4u1GajHYvpKHwrH0HHl8xs/42OwmKgAF50MppyurpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOZbHd8rb11IWwTmLIPwcGQSygILwk2WEQIOs0sYfk8=;
 b=XZbg6qS8iW0pzesgXdipzht+Ffmwk9P04mM5quuLbxZDKNm+Xj9iZzG8mEIcii8O1HKoLf2onPiTfkznlTmUThl6air5fEhh7xRlJliqZINgvALtv2kpDAFN7XnnSsHU9vYhcdpq477yM3Zups39slSxc9li/2YSKtOQrBN+aUo=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB6972.eurprd04.prod.outlook.com (52.133.242.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Wed, 26 Feb 2020 18:32:55 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697%6]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 18:32:55 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>
Subject: RE: [PATCH net-next v2 1/8] net: phylink: propagate resolved link
 config via mac_link_up()
Thread-Topic: [PATCH net-next v2 1/8] net: phylink: propagate resolved link
 config via mac_link_up()
Thread-Index: AQHV7I7foN/8WjpxZUC/+bNDIQ+7u6gtUF0AgAAN5ICAABITAIAACfwAgABPyICAAAA+gIAAAVTw
Date:   Wed, 26 Feb 2020 18:32:55 +0000
Message-ID: <DB8PR04MB682837B8182CFC3359B71112E0EA0@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200226102312.GX25745@shell.armlinux.org.uk>
 <E1j6tqv-0003G6-BO@rmk-PC.armlinux.org.uk>
 <CA+h21hrR1Xkx9gwAT2FHqcH38L=xjWiPxmF2Er7-4fHFTrA8pQ@mail.gmail.com>
 <20200226115549.GZ25745@shell.armlinux.org.uk>
 <CA+h21hqjMBjgQDee8t=Csy5DXVUk9f=PP0hHSDfkuA746ZKzSQ@mail.gmail.com>
 <20200226133614.GA25745@shell.armlinux.org.uk>
 <CA+h21hqHfC0joRDhCQP6MntFdVaApFiC51xk=tUf3+y-C7sX_Q@mail.gmail.com>
 <CA+h21hpzCY=+0U4JgFbqGLS=Sh6SjkSt=4J9e0AGVHKJPOHq1A@mail.gmail.com>
In-Reply-To: <CA+h21hpzCY=+0U4JgFbqGLS=Sh6SjkSt=4J9e0AGVHKJPOHq1A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 78582035-7dfe-4969-9922-08d7baea4c2d
x-ms-traffictypediagnostic: DB8PR04MB6972:|DB8PR04MB6972:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB697259685DB74C669270AD5CE0EA0@DB8PR04MB6972.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(199004)(189003)(110136005)(186003)(316002)(81166006)(81156014)(5660300002)(478600001)(8676002)(26005)(7416002)(8936002)(7696005)(86362001)(2906002)(44832011)(33656002)(6506007)(64756008)(66556008)(66476007)(66446008)(9686003)(76116006)(54906003)(52536014)(71200400001)(55016002)(4326008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6972;H:DB8PR04MB6828.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lk1EnDL2BQJAw6fjFRszpl81GnNK0ZmzPgltBGuI20Z1oyAOd7DqLRE9nrrXkzNUjr0oQCCzvPtB9Z6q55S52uSQxuCx66g1mzzK9VoxW5zCvxG9kyytS0vBxuauHTL6pbrSQ6RebcI5id1OedlkU/uyr8xLYzcq6x2F+jGHXGU6cYDBjV8dlvZWhYixLeNge2Jzd65uHVI1WhNni5PkOxzHdYE5e2mMiwx4lwP7+jADcmUfki/7c2tv47/QfnnIuaVtpx4v1AAQO9Cp1D1FfGc9XzZHWjmKwPMOtNyIxhmFtmFSSnv9tiRQtBfKnsoaXv5HGAPmHFjsKFdKHCcXnwL1G91ARNPMQU8C5nqB+7jAw0aSor+zLOzFN1wtaxCdws0BSA60G6G9Lq30oDbRZQ84OUnAdwWftistIVofdOLllujeIwC8VaeSX5JxC9kP
x-ms-exchange-antispam-messagedata: aG9fEw0NIOt5qbiNd8POUHSzXc1m3jSw7VVJlfUjFipOT88pqB1OhLLXPYfj70mSCAz50BSe9VIVS7b/W4MkmUIGGqyRbXh+LdrSzsIktux1jHQu+LppAEdS0Ba/NshjQI9tlsugCFIXrbK4ylN+Mw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78582035-7dfe-4969-9922-08d7baea4c2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2020 18:32:55.8747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8c/Cu6JNceOwLaCX2P1Y+qEJ2Lo+P1DYen/5VBZjZrdvyARe3SHFBjg2VcX9qY8T63+RoHz+QjpZuW6axY2RmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6972
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYyIDEvOF0gbmV0OiBwaHlsaW5rOiBwcm9w
YWdhdGUgcmVzb2x2ZWQgbGluayBjb25maWcNCj4gdmlhIG1hY19saW5rX3VwKCkNCj4gDQo+IE9u
IFdlZCwgMjYgRmViIDIwMjAgYXQgMjA6MjEsIFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFp
bC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gT24gV2VkLCAyNiBGZWIgMjAyMCBhdCAxNTozNiwgUnVz
c2VsbCBLaW5nIC0gQVJNIExpbnV4IGFkbWluDQo+ID4gPGxpbnV4QGFybWxpbnV4Lm9yZy51az4g
d3JvdGU6DQo+ID4gPg0KPiA+ID4NCj4gPiA+IGRwYWEyIGlzIGNvbXBsaWNhdGVkIGJ5IHRoZSBm
aXJtd2FyZSwgYW5kIHRoYXQgd2UgY2FuJ3Qgc3dpdGNoIHRoZQ0KPiA+ID4gaW50ZXJmYWNlIG1v
ZGUgYmV0d2VlbiAoU0dNSUksMTAwMGJhc2UtWCkgYW5kIDEwRy4NCj4gPiA+DQo+ID4gPiBJZiB0
aGUgZmlybXdhcmUgaXMgaW4gIkRQTUFDX0xJTktfVFlQRV9QSFkiIG1vZGUsIGl0IGV4cGVjdHMg
dG8gYmUNCj4gPiA+IHRvbGQgdGhlIGN1cnJlbnQgbGluayBwYXJhbWV0ZXJzIHZpYSB0aGUgZHBt
YWNfc2V0X2xpbmtfc3RhdGUoKSBjYWxsDQo+ID4gPiAtIGl0IGlzbid0IGNsZWFyIHdoZXRoZXIg
dGhhdCBuZWVkcyB0byBiZSBjYWxsZWQgZm9yIG90aGVyIG1vZGVzDQo+ID4gPiB3aXRoIHRoZSB1
cC9kb3duIHN0YXRlIChmaXJtd2FyZSBBUEkgZG9jdW1lbnRhdGlvbiBpcyBwb29yLikNCj4gPiA+
DQo+ID4NCj4gPiBXaXRoIFBDUyBjb250cm9sIGluIExpbnV4LCBJIGFtIHByZXR0eSBzdXJlIHRo
YXQgeW91IGRvbid0IHdhbnQNCj4gPiBhbnl0aGluZyBvdGhlciB0aGFuIERQTUFDX0xJTktfVFlQ
RV9QSFkgYW55d2F5Lg0KPiA+IEJhc2ljYWxseSBpbiBEUE1BQ19MSU5LX1RZUEVfRklYRUQsIHRo
ZSBNQyBmaXJtd2FyZSBpcyBpbiBjb250cm9sIG9mDQo+ID4gdGhlIFBDUyBhbmQgcG9sbHMgaXRz
IGxpbmsgc3RhdGUgdG8gZW1pdCBsaW5rIG5vdGlmaWNhdGlvbnMgdG8gb2JqZWN0cw0KPiA+IGNv
bm5lY3RlZCB0byB0aGUgRFBNQUMuIFNvIExpbnV4IGNvbnRyb2wgb2YgUENTIHdvdWxkIGNsYXNz
IHdpdGgNCj4gDQo+IHMvY2xhc3MvY2xhc2gvDQo+IA0KPiA+IGZpcm13YXJlIGNvbnRyb2wgb2Yg
dGhlIFBDUywgbGVhZGluZyB0byB1bmRlc2lyYWJsZSBzaWRlLWVmZmVjdHMgdG8NCj4gPiBzYXkg
dGhlIGxlYXN0Lg0KDQoNCklmIHRoZSBEUE1BQyBvYmplY3QgaXMgaW4gRFBNQUNfTElOS19UWVBF
X0ZJWEVELCB0aGUgZHBhYTItZXRoIGluIGZhY3QNCmRvZXMgbm90IGV2ZW4gY29ubmVjdCB0byBh
IHBoeSBzbyBhbGwgdGhlIHBoeWxpbmsgaW50ZXJhY3Rpb24gaXMgbm90IGhhcHBlbmluZy4NCkFz
IFZsYWRpbWlyIHNhaWQsIGluIHRoaXMgY2FzZSBpdCdzIHRoZSBNQyBmaXJtd2FyZSdzIGpvYiB0
byBwb2xsIHRoZSBQQ1MgYW5kDQpub3RpZnkgYW55IGNvbm5lY3RlZCBvYmplY3RzIG9mIGEgbGlu
ayBjaGFuZ2UuDQoNCj4gPg0KPiA+IFJlZ2FyZHMsDQo+ID4gLVZsYWRpbWlyDQo=
