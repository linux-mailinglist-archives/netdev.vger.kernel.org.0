Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D411D952D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgESLWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:22:02 -0400
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:11360
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726505AbgESLWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 07:22:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBY+5P2SgUDQlgApZKXHL5/0wJep4VR4jW64DLq4zvm4e+XHBHJck/scuqgcJ7vXDTEvw2X99V10HSwgrNtEbLCLh4P6dXSx4IZ/2B/z+vn2YN69S04EmTloc+TLxdPAt4U1hX/pou8/3tvj3u6k65jnyJKSUlBZ5VxHOE8l1KFpzMschQIRKD6dJ/h14O5TDrA8x+OOcIGk8BKCvlvWDsQLezbxvknJ2wO8c0io05Dcr3WlypUhdBgU6Qw2PaF8qDX13QAo6SNifSns3InfasWo5i4Kowux5xRdHsnkBrela1UBjURctq7nULKsiGZ/6XXTOgyZWDKEvbF7K+Mb3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYM3DYWbPlCebgIwlVDnB7xei5xIuquAmSAj2fn0COI=;
 b=G/d04kFryywwdbYia5+AukQYvIP/9AhmL9dCmEdTRBN526nPfRRKzw9Te1mHYzQqaOObgGfiMiAFj6tT1Avr2x4kVbV6UUmNDRncPVqwmgUcIN9zE2bGvIeMyPPy61Cn5CGFbBP98Vb3UDq3AgekqwZEXOwkq6t3QetZrlTRhtDZYw9xBRLCNJyiIIZMIe087RogRxqeQMeEwVvWu0h0LSk6PvIs5Xsjr7mNNX2h7aH9IGff0uKpStRHDEYOAPyuHm+XIWOpC0Kd321V4/A7fzglOSP5mPgANEntUDOMwf1LTK1qoMkIe5WDmo2m3JKB0i6MoOMGA9kfw2LM05qPAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYM3DYWbPlCebgIwlVDnB7xei5xIuquAmSAj2fn0COI=;
 b=dLSq3nFJuFDa2d50OcfMoYLKIELPnc2EwBmdeCEYgFo1E/6PWGVVWqg6HCNEd1bmU43DTC+MkPEkfdjRoOPXz9itbv2XqoDAy8QQ0eTBlYe995SFjBBAAM0T3gCAeXQQDU1oJ12MdWxeR4tuqjOy+QDE4vEqEVN5XTCq1byz29g=
Received: from DB8PR04MB7052.eurprd04.prod.outlook.com (2603:10a6:10:12d::22)
 by DB8PR04MB5626.eurprd04.prod.outlook.com (2603:10a6:10:af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Tue, 19 May
 2020 11:21:57 +0000
Received: from DB8PR04MB7052.eurprd04.prod.outlook.com
 ([fe80::e9fc:448c:f940:4789]) by DB8PR04MB7052.eurprd04.prod.outlook.com
 ([fe80::e9fc:448c:f940:4789%7]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 11:21:57 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Michal Kubecek <mkubecek@suse.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>
Subject: RE: [PATCH net-next v1 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Thread-Topic: [PATCH net-next v1 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Thread-Index: AdYtzWd0jvhYXq3wTw6a1Ado5AQWdA==
Date:   Tue, 19 May 2020 11:21:57 +0000
Message-ID: <DB8PR04MB7052BBAFFA2F51ABB321099886B90@DB8PR04MB7052.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [77.6.207.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4cdc2fc0-88d5-49c1-6bc0-08d7fbe6d7bd
x-ms-traffictypediagnostic: DB8PR04MB5626:
x-microsoft-antispam-prvs: <DB8PR04MB5626B56EE5CDFC2DBE1AD11D86B90@DB8PR04MB5626.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 040866B734
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RBU4quKOeR/eX94pyvTMp4bcUu8wYheQoGI2yv0ag7CUwjYHQ0X5TuH4QbDelbYauHSA+l3bkE2NfCKcjBlO9DV+9v0V8WMuVpn88U95DkhcxFdq37fVrEzsoT0hiZwBJ9Dend//EFlg4sijBrUGWigWc6AV35wsWcSWbs7we7v5L1ctF1fALjI2EXKjf9iQYiNDuKT1ysQFyH+7jADxLyzu5RwUJhc/mia7kcMVf6RvZCXijLWsxK/t5uTSfLH6vjccdFr4toy36uG/nny0ZHPshiue+yqtdNv9qvauh6tBmXhgTMbjmJfXqRkM6fmhsPqkFJSZmjxP0KfF6Lb5Wg6N7WJjAOqW9MAAq8gZ1Pr3JiICJKQpbDcQA+d/8VK58IjVn/+T89S6IKlHDBmpiDks/LE3b7LqD2ZD2Vrklhlo75P1j02szwXSvLGqu8yb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB7052.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(55016002)(54906003)(316002)(478600001)(110136005)(7416002)(86362001)(5660300002)(9686003)(8936002)(66574014)(7696005)(33656002)(186003)(71200400001)(26005)(8676002)(6506007)(4326008)(76116006)(44832011)(2906002)(52536014)(66946007)(66446008)(64756008)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fIv+wGD3IktH4fAy//1yIhjWYP+kOL+KmGKUz/XRcIqV1yuRDeYzQuiXMbe9Qk75Ao01WZ8ISnWA2Io/WrykGEfMKKbchcTU6dVrvVKRl92V8Sj8ZdH+dJie84JsF2Sfyy6NX5CDUud/AUZ529sIKBTKn8Xv1bczZUbJbB53QxNSNMd2TDdxTGtcuZpWek7UQb+yu1cUZ0gOauXNjj5WyGMuJ1V2OgI5vUO/5OFCLTRgGaR4jCcy7t+cf6YdwuQ748GFJ2d52BV/zF8MtfYoZPjVofYEj73Jy+D/GKsTfBavAVkG+l6wwDE46IG7BbHEc2yekCm3YcrF4ya81s9PPDxIzRE0vHEM+LhQIvQH1fsAyTh/yuo4yCHAuCn/HPg0B/glE02o3Wyp++rx2fHP+MfbvTVbvL8gTchQrfEqDJpuO0ZPQMxyUGfdf48HFiAKS6j2g8Z70SPWTpNwKR0ud919Dk19Tjdd1svJ/lOL0Kw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cdc2fc0-88d5-49c1-6bc0-08d7fbe6d7bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2020 11:21:57.5395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4bDHO7MevfkxsjkC3H/pfEzqOTb8s7vQ9kjRNvkI+yslseF/larFmGVkuUWF1OOQNjBIXpY9ynkzVIivCTXIRtmeu0ci61URAMfwf+6BIto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5626
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBNYXkgMTksIDIwMjAgYXQgMTI6NTg6NTVQTSArMDIwMCwgT2xla3NpaiBSZW1wZWwg
d3JvdGU6DQo+IE9uIFR1ZSwgTWF5IDE5LCAyMDIwIGF0IDEwOjU1OjIwQU0gKzAyMDAsIE1pY2hh
bCBLdWJlY2VrIHdyb3RlOg0KPiA+IE9uIFR1ZSwgTWF5IDE5LCAyMDIwIGF0IDA5OjUxOjU5QU0g
KzAyMDAsIE9sZWtzaWogUmVtcGVsIHdyb3RlOg0KDQo+ID4gSSdtIGFsc28gYSBiaXQgd29ycmll
ZCBhYm91dCBoYXJkY29kaW5nIHRoZSAwLTcgdmFsdWUgcmFuZ2UuIFdoaWxlIEkNCj4gPiB1bmRl
cnN0YW5kIHRoYXQgaXQncyBkZWZpbmVkIGJ5IHN0YW5kYXJkIGZvciAxMDBiYXNlLVQxLCB3ZSBt
eSB3YW50IHRvDQo+ID4gcHJvdmlkZSBzdWNoIGluZm9ybWF0aW9uIGZvciBvdGhlciBkZXZpY2Vz
IGluIHRoZSBmdXR1cmUuIEkgdHJpZWQgdG8NCj4gPiBzZWFyY2ggaWYgdGhlcmUgaXMgc29tZXRo
aW5nIGxpa2UgdGhhdCBmb3IgMTAwMGJhc2UtVDEgYW5kIGZvdW5kIHRoaXM6DQo+ID4NCj4gPiBU
aGUgc2NyZWVuc2hvdCBvbiBwYWdlIDEwIHNob3dzICJTUUkgVmFsdWU6IDAwMDE1Ii4NCj4NCj4g
TmljZSwgc2NyZWVuc2hvdCBiYXNlZCByZXZlcnNlIGVuZ2luZWVyaW5nIDopDQo+DQo+ID4gSXQn
cyBwcm9iYWJseSBub3QNCj4gPiBzdGFuZGFyZGl6ZWQgKHlldD8pIGJ1dCBpdCBzZWVtcyB0byBp
bmRpY2F0ZSB3ZSBtYXkgZXhwZWN0IG90aGVyIGRldmljZXMNCj4gPiBwcm92aWRpbmcgU1FJIGlu
Zm9ybWF0aW9uIHdpdGggZGlmZmVyZW50IHZhbHVlIHJhbmdlLg0KPg0KPiB3aGF0IG1heGltYWwg
cmFuZ2UgZG8gd2Ugd29udCB0byBleHBvcnQ/IHU4LCB1MTYgb3IgdTMyPw0KPg0KPiA+IFdvdWxk
IGl0IG1ha2Ugc2Vuc2UgdG8gYWRkIEVUSFRPT0xfQV9MSU5LU1RBVEVfU1FJX01BWCBhdHRyaWJ1
dGUgdGVsbGluZw0KPiA+IHVzZXJzcGFjZSB3aGF0IHRoZSByYW5nZSBpcz8NCj4NCj4gc291bmRz
IHBsYXVzaWJsZS4NCg0KU1FJIGlzIG5vdCB5ZXQgc3RhbmRhcmRpemVkIGZvciAxMDAwQkFTRS1U
MSB0byBteSBrbm93bGVkZ2UuIEJ1dCBsb29raW5nIGF0IHRoZSBkZWZpbml0aW9uIG9mIFNRSSBy
ZWdpc3RlciBmb3IgMTAwQkFTRS1UMSBnaXZlcyBzb21lIGdvb2QgY2x1ZXMuDQpbMF0gcmVzZXJ2
ZWQNClszOjFdIGN1cnJlbnQgU1FJIHZhbHVlDQpbNF0gcmVzZXJ2ZWQNCls3OjVdIHdvcnN0IGNh
c2UgU1FJIHZhbHVlIHNpbmNlIGxhc3QgcmVhZA0KDQpTbywgdGhlIHJlZ2lzdGVycyBhcmUgaW1w
bGVtZW50ZWQgaW4gYSB3YXkgdGhhdCBhbm90aGVyIExTQiBjYW4gYmUgYWRkZWQuDQpUaGlzIHdv
dWxkIGluY3JlYXNlIHRoZSByZXNvbHV0aW9uIG9mIFNRSSBtZWFzdXJlbWVudCwgbm90IHRoZSBy
YW5nZS4NCkkuZS4gdGhlIHJlc3VsdGluZyB2YWx1ZSByYW5nZSBjb3VsZCBiZSBzZWVuIGFzIFsw
LCAwLjUsIDEsIC4uLiwgNy41XSBvciBbMCwgMSwgLi4uLCAxNV0uDQpGb3IgdGhlIHNjcmVlbnNo
b3QsIEkgd291bGRu4oCZdCBhc3N1bWUgdGhlIHJlc2VydmVkIGJpdCBpcyBpbXBsZW1lbnRlZCwg
aXQgY291bGQganVzdCBiZSB0aGF0IHRoZSBTUUkgdmFsdWUgd2FzIG5vdCBzaGlmdGVkLg0KDQpS
ZWdhcmRzLA0KDQpDaHJpc3RpYW4NCg==
