Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0DC1AD670
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 08:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgDQGsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 02:48:51 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:25599
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgDQGsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 02:48:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UC2aA9Ssib7DmAhjrsDpy3ttneQO+0n7Q9SiRG6jmxDXRCx+w1NDOnxj6iMCL/QbE+8z03awwfMSKPvxCIVOCxHDBkW0DGTdruiSN6OTbTIzjwoqvfYotTuLIbuhdOtNx3PX01C0MUzCxuXST9BkUR9YWLtsY903q7ClwPLwVLInWnXRtUBu9iujDsNLicFOwWP52FPnUcTffCEo89WPysTPhOUBgRHP1MO3mLbVUSS6iwmPrKUxIzdTHaCVyw77vi3UuoYXEYhZN0v2FMQ2latyGc2OD6lca8ZSQqkF2O14lmoXp3I26oXlwc3qEwT68VxnCY7O1MPuuNkEQ6rgZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDh2zLtgd9lJf5TJHLCsd+uEiZ/h0qj9hnQUoJT4jQA=;
 b=dUfhGV8zfhALJbrFv3AQB0o/oG16+7x7dftICcQFGbJaabj95bc2q87i8LzrhXIea8e5ySFIgIcQj/flSlsb29/Gk4i7y/HEC6paddUn3rYoh9ROqd2GYVz3sV4C67rkX1EeyItXo3C7rj/6b4Kq9h0ZbOF81aUe7AWtadWurC93qunzG5TJlf45rrn4InkF5OMedtRGrmj7LtdB5OxzakdL7NrJ23qycjUnfnMI8YD3wdx9r0hXg3BLWK0Ywc/lgkV6OmwoUSaPd50ux5FlXChbQWW34e9xJsE0e0toJ9ytNRpKH0CUqHcl4cWxDnS4ETis6xw1ToMdDJxnASujnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDh2zLtgd9lJf5TJHLCsd+uEiZ/h0qj9hnQUoJT4jQA=;
 b=fMC4I2Hna2ylVj0FJpymarJ0ZBdHwpRr695pQPYNt7xIZhMrcOZEEAgaAObmpqnuB431DQG0sxtDsrqXNDF6gfS8Y7b6yLzYTbXYwL7YCBrXnBy3jIC3Ex67gfRHfFvUveBUWonBqmJxjIu+OQHJd55fynBLNBoq4gSlsnJVUBQ=
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13)
 by AM0PR04MB5362.eurprd04.prod.outlook.com (2603:10a6:208:119::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Fri, 17 Apr
 2020 06:48:46 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00%9]) with mapi id 15.20.2921.027; Fri, 17 Apr 2020
 06:48:46 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
Subject: RE: [EXT] Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Thread-Topic: [EXT] Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Thread-Index: AQHWE/XQEc+ri0+56kaZa7/sUqWIQqh6LhYAgAKxMdA=
Date:   Fri, 17 Apr 2020 06:48:46 +0000
Message-ID: <AM0PR04MB70413A15B7BBE8D17FEA363C86D90@AM0PR04MB7041.eurprd04.prod.outlook.com>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415131104.GA657811@lunn.ch>
 <20200415133728.urvsdolwhaa4eknm@pengutronix.de>
In-Reply-To: <20200415133728.urvsdolwhaa4eknm@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [77.3.27.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8b44ba52-9c02-4b14-61f0-08d7e29b6076
x-ms-traffictypediagnostic: AM0PR04MB5362:
x-microsoft-antispam-prvs: <AM0PR04MB536216030845F361D6936B2A86D90@AM0PR04MB5362.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB7041.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(316002)(8676002)(6506007)(4326008)(2906002)(110136005)(54906003)(33656002)(52536014)(5660300002)(8936002)(7696005)(186003)(26005)(86362001)(71200400001)(4744005)(55016002)(9686003)(66446008)(81156014)(76116006)(66946007)(64756008)(66556008)(66476007)(44832011)(478600001)(7416002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DnnH0T/vRCXFXW1SSRHZFNkGTp5W7QBFV3qB9ovw+46Q+4iVWuhnK2LjzN6gMXZ+SKhxUMplWwVNiIr3propye1f8RaKI2cJ/d3JgbHT5VssS36K2UT83qsU5JdX+3nWoaOmlmlXs2Y+A1S4nMOQux5G+Bd0KiVAadojugztuqvekcyXIWZ1G31vbdVckRrTj/RsonlS7ILssHsesUbMR8/isdFBEZXXwQmPvmPY/GrC3sol/KrB7Txh4a+v892uqHPEATvxoPHPlGgSKAqE1//7z9Oqcr7gbXX4rvvFXl/kk5W4rMY4+EMMr6L9spkl0Nz4UtR/rbHXIcnEHj0b4mQgQTCMhdxtVgphSKij5qZyxnoGZqMqyjP3mW8nsAOmwQDx1XhE1ljvfG//OFXogAganr3tVlIuqhgnV2G8PMLgaGlurYq8bGj9/6G0NwSa
x-ms-exchange-antispam-messagedata: RRiSKeMcmNno8JMc3oPinsDzJNuBy8vvjS6uTcEOiqzGQNysSIzaR9Y1FZDlDt1LC8yQZpAi7n5EReM4Bpas2KkuTg4ZfbVpJP3qzg1O2d7i8UMqPAPo2bdwn7bgIOZTH4mfGhuf69BFlThQ3eEOqA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b44ba52-9c02-4b14-61f0-08d7e29b6076
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 06:48:46.1448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSM0xJpS6bYMS7aEN7ptkzh9kAFmcCnZUmAhqsWoFFXajnJQs22Vf2D0EFeftgmiiCpN1lxYNgAW4EInoDKOIrqVURyf50LfDEuxWkjIBkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5362
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KPklmIHdlIHdpbGwgZm9sbG93IHN0cmljdGx5IHRvIHRoZSBJRUVFIDgw
Mi4zIHNwZWMsIGl0IHNob3VsZCBiZSBuYW1lZDoNCj4NCj4jZGVmaW5lIFBPUlRfTU9ERV9VTktO
T1dOICAgICAgIDB4MDANCj4vKiB0aGlzIHR3byBvcHRpb25zIHdpbGwgbm90IGZvcmNlIHNvbWUg
c3BlY2lmaWMgbW9kZSwgb25seSBpbmZsdWVuY2UNCj4gKiB0aGUgY2hhbmNlIHRvIGdldCBpdCAq
Lw0KPiNkZWZpbmUgUE9SVF9UWVBFX01VTFRJX1BPUlQgICAgMHgwMQ0KPiNkZWZpbmUgUE9SVF9U
WVBFX1NJTkdMRV9QT1JUICAgMHgwMg0KPi8qIHRoaXMgdHdvIG9wdGlvbnMgd2lsbCBmb3JjZSBt
YXN0ZXIgb3Igc2xhdmUgbW9kZSAqLw0KPiNkZWZpbmUgUE9SVF9NT0RFX01BU1RFUiAgICAgICAg
MHgwMw0KPiNkZWZpbmUgUE9SVF9NT0RFX1NMQVZFICAgICAgICAgMHgwNA0KPg0KPlBsZWFzZSB0
ZWxsLCBpZiB5b3UgaGF2ZSBiZXR0ZXIgaWRlYXMuDQoNClRoaXMgd291bGQgYmUgcXVpdGUgaW4g
dGhlIHNwaXJpdCBvZiA4MDIuMy4gTXkgYXNzdW1wdGlvbiBpcyBtdWx0aXBvcnQgZGV2aWNlcyBw
cmVmZXJhYmx5IG9wZXJhdGUgYXMgbWFzdGVyIHRvIHJlZHVjZSB0aGUgYW1vdW50IG9mIGNsb2Nr
IGRvbWFpbiBjcm9zc2luZyBvbiB0aGUgbXVsdGlwb3J0IGRldmljZS4gT2YgY291cnNlLCBpdCBp
cyBhIGJpdCB1c2UgY2FzZSBkcml2ZW4gYW5kIHlvdSBjb3VsZCBjb25maWd1cmUgYSBwcmVmZXJl
bmNlIGZvciBtYXN0ZXIgbW9kZSBhbHNvIG9uIGEgc2luZ2xlIHBvcnQgZGV2aWNlLiBGb3Igc3Vj
aCB1c2UgY2FzZXMgdGhlIG5hbWUgaXMgY29uZnVzaW5nLiBIZXJlLA0KDQo+I2RlZmluZSBQT1JU
X01PREVfTUFTVEVSX1BSRUZFUlJFRCAgIDB4MDENCj4jZGVmaW5lIFBPUlRfTU9ERV9TTEFWRV9Q
UkVGRVJSRUQgICAgICAgMHgwMg0KDQptaWdodCBiZSBiZXR0ZXIuDQoNCkNocmlzdGlhbg0K
