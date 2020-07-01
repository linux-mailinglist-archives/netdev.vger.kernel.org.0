Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2042109B3
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 12:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbgGAKwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 06:52:42 -0400
Received: from mail-eopbgr10085.outbound.protection.outlook.com ([40.107.1.85]:59639
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729892AbgGAKwl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 06:52:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NW1LES3bko6TdZThp8edZUlUr8sJ7GLs9fd1weXSNT2Oay+QJdzug3T6cL9Oo+Oj/Vu2xG9BpqDAAepYWdMM1cGqA8QeJOcrYwaEIXMZebD5a4LXkQJz9/XD8dztfaRGPHwKyre4lKs0lU+TjuTiBtgwKWpT2e7Ul3rmoo5meNiAEeR4vdNBJYxEJKWJt+7Z4j2NWyFQIVb36uIuR1msRTwqguv/KbxOV457RXOMf/tVIx2DvV3r5rvGwdrHHQ92eYPDOAWxISc0BAU5K0bV+ND/QaavvI0PFAoT2fp13I15EB94mxSE9W3bOWiENMhnyq70Yhup7L7qdYUJc0DV2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvRDwUxgmC1R3FW+6zkHtWM8y0KBsSqMTj52ckanlrI=;
 b=fDuJpNZcjpDE+EL4HsuYGnnH/qyqiWsK/tH45pYLen9QnU9XQazd8ww5nCIQ/eKPPZsPPy19p6oLHFhZHuzDfFNBApolEVv/Aldoxz6DYg+NOC2r7OIxbcu+6Q492GtT7U1Bkk8Aj8LmoAxOoWGGgXE1dIkDfq5OiNp3QizbbtDHzHxNqt8vbCZP6oomYMAb6WA/Fvj5gr67K+7OFr7HEYSqGZNE6vXNSD0uPY4P7qATL0uJr8U4lNTvXkr59VEEQJ6Cns9Y7CZLn1pGpxY85/t2mEKVOHwgOFf0HLEakp6lb7uUuAMoydOS2Sv/Uh0YLHSVRn92Yo2AQVC+CIRpRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvRDwUxgmC1R3FW+6zkHtWM8y0KBsSqMTj52ckanlrI=;
 b=fAelNiPQTlr4ekna9fqM8BrbcjxtDptAiGJmGT6bd2jhQvDuwgFs0d76UJKVtE9gQanAw9MOo1O7xJ5JNwI99B7/5mNaVpcwMpy3rwB5u7wOaanHpraU2UblfJ6FdyFQfEAfx0byYDmBaNhaWghYAasd0lvF1nHhmgVIE0BY3bE=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4575.eurprd04.prod.outlook.com
 (2603:10a6:803:6b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Wed, 1 Jul
 2020 10:52:37 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3131.028; Wed, 1 Jul 2020
 10:52:37 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH RFC net-next 13/13] net: phylink: add interface to
 configure clause 22 PCS PHY
Thread-Topic: [PATCH RFC net-next 13/13] net: phylink: add interface to
 configure clause 22 PCS PHY
Thread-Index: AQHWTurl2oCy8tTUCkWxykUjCsBK9ajyjSRg
Date:   Wed, 1 Jul 2020 10:52:37 +0000
Message-ID: <VI1PR0402MB3871E5BCC2C7473BF67539E0E06C0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHGT-0006Qb-Ld@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1jqHGT-0006Qb-Ld@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.124.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f4caa694-0314-4a78-d16a-08d81dacde3a
x-ms-traffictypediagnostic: VI1PR04MB4575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4575D2229395310220F38621E06C0@VI1PR04MB4575.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Du8U9ni+PR/6sx6XrBUWjsfpp669trquEWfuol5BaLhmopUsyAuAjwuYkvmXDnZZlI4lZJW2nYh9QutbOZYvmUnXRbes7KTd/X89gddAUAgjNheCXBbNokyWbRP1ol31r4AIz0NyfSAMrM46c59ya0+lfyQ8vzehFeT2Up2Yy+S5acxXA8LezdVIzNlz4lsug+7Lk7W0AKamB2Kqjxw7YtTofmmXmZE9bXH2Rgojg0F63tQzuNYJLRBtY4SND++RDIW69uamuDtSUXw9NR8WkP1FUwvmA5pPXwYpoZ04vYHlr8XDx4G+b581eSXkH6oEyeeNFeb0Sm3aL7++jhoRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(83380400001)(6506007)(5660300002)(55016002)(8676002)(9686003)(2906002)(64756008)(7696005)(66446008)(54906003)(110136005)(52536014)(76116006)(26005)(4326008)(71200400001)(33656002)(66556008)(316002)(66476007)(8936002)(66946007)(186003)(478600001)(44832011)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YO2zktGX/001oCwaqk8dLk7xFhs/Jr6PdxLQJq9QZUsMHgiw9LkKD3jYxy1P6qpK+DPPHvHaie1rein5A9orhDR1qRJEs4J6zYN2bgN6WxtRBDjSr9K29h84MsYAGLULabJfTYsnw+WVThfaMY5nJgNvQHokj3bCOZA70cQvajh070Nzxh34+N4MVC6jstrXGcmp8Isw0oIKS9EGpUyJZSYpj1T5klpwKGGPeHZlXUiubLiD9bJkWiE2fD/9tsUgAeqb7mAQjOFaZAQyv3KG8hMbvDouG4m78sHm10b3jKPw4ElGM2BTGumd6gnIO8nGmBrLydc0x/iOpZ93av2t+8yprrtqEPOPXs4wBmlZukI64H5SmrqV02njtn+wdVxfRBK7/8/j9vtJWe+zKVRekc/8YxarcmxDPLHQZVL3+RTd5ElDMkN880bGjFOsJNQJGH630h/8KlpgEj5PYdUomFaDE3f/PaxNr46jQywjrNg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4caa694-0314-4a78-d16a-08d81dacde3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 10:52:37.1553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zgmzqoIdjyeh8VYZltg5UfVvg/QPsI6Byg45u8RC3c9ZSNvMW9onAhEiKuLyXaXBLuaFA32rWVf/I94hjvfgHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4575
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0ggUkZDIG5ldC1uZXh0IDEzLzEzXSBuZXQ6IHBoeWxpbms6IGFkZCBp
bnRlcmZhY2UgdG8gY29uZmlndXJlDQo+IGNsYXVzZSAyMiBQQ1MgUEhZDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBSdXNzZWxsIEtpbmcgPHJtaytrZXJuZWxAYXJtbGludXgub3JnLnVrPg0KPiAtLS0N
Cg0KUmV2aWV3ZWQtYnk6IElvYW5hIENpb3JuZWkgPGlvYW5hLmNpb3JuZWlAbnhwLmNvbT4NCg0K
DQo+ICBkcml2ZXJzL25ldC9waHkvcGh5bGluay5jIHwgMzcgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiAgaW5jbHVkZS9saW51eC9waHlsaW5rLmggICB8ICAzICsrKw0K
PiAgMiBmaWxlcyBjaGFuZ2VkLCA0MCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvcGh5L3BoeWxpbmsuYyBiL2RyaXZlcnMvbmV0L3BoeS9waHlsaW5rLmMgaW5k
ZXgNCj4gZmJjODU5MWI0NzRiLi5kNmM1ZTkwMGEyZjEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L3BoeS9waHlsaW5rLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvcGh5L3BoeWxpbmsuYw0KPiBA
QCAtMjQzNSw2ICsyNDM1LDQzIEBAIGludCBwaHlsaW5rX21paV9jMjJfcGNzX3NldF9hZHZlcnRp
c2VtZW50KHN0cnVjdA0KPiBtZGlvX2RldmljZSAqcGNzLCAgfQ0KPiBFWFBPUlRfU1lNQk9MX0dQ
TChwaHlsaW5rX21paV9jMjJfcGNzX3NldF9hZHZlcnRpc2VtZW50KTsNCj4gDQo+ICsvKioNCj4g
KyAqIHBoeWxpbmtfbWlpX2MyMl9wY3NfY29uZmlnKCkgLSBjb25maWd1cmUgY2xhdXNlIDIyIFBD
Uw0KPiArICogQHBjczogYSBwb2ludGVyIHRvIGEgJnN0cnVjdCBtZGlvX2RldmljZS4NCj4gKyAq
IEBtb2RlOiBsaW5rIGF1dG9uZWdvdGlhdGlvbiBtb2RlDQo+ICsgKiBAaW50ZXJmYWNlOiB0aGUg
UEhZIGludGVyZmFjZSBtb2RlIGJlaW5nIGNvbmZpZ3VyZWQNCj4gKyAqIEBhZHZlcnRpc2luZzog
dGhlIGV0aHRvb2wgYWR2ZXJ0aXNlbWVudCBtYXNrDQo+ICsgKg0KPiArICogQ29uZmlndXJlIGEg
Q2xhdXNlIDIyIFBDUyBQSFkgd2l0aCB0aGUgYXBwcm9wcmlhdGUgbmVnb3RpYXRpb24NCj4gKyAq
IHBhcmFtZXRlcnMgZm9yIHRoZSBAbW9kZSwgQGludGVyZmFjZSBhbmQgQGFkdmVydGlzaW5nIHBh
cmFtZXRlcnMuDQo+ICsgKiBSZXR1cm5zIG5lZ2F0aXZlIGVycm9yIG51bWJlciBvbiBmYWlsdXJl
LCB6ZXJvIGlmIHRoZSBhZHZlcnRpc2VtZW50DQo+ICsgKiBoYXMgbm90IGNoYW5nZWQsIG9yIHBv
c2l0aXZlIGlmIHRoZXJlIGlzIGEgY2hhbmdlLg0KPiArICovDQo+ICtpbnQgcGh5bGlua19taWlf
YzIyX3Bjc19jb25maWcoc3RydWN0IG1kaW9fZGV2aWNlICpwY3MsIHVuc2lnbmVkIGludCBtb2Rl
LA0KPiArCQkJICAgICAgIHBoeV9pbnRlcmZhY2VfdCBpbnRlcmZhY2UsDQo+ICsJCQkgICAgICAg
Y29uc3QgdW5zaWduZWQgbG9uZyAqYWR2ZXJ0aXNpbmcpIHsNCj4gKwlib29sIGNoYW5nZWQ7DQo+
ICsJdTE2IGJtY3I7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCXJldCA9IHBoeWxpbmtfbWlpX2My
Ml9wY3Nfc2V0X2FkdmVydGlzZW1lbnQocGNzLCBpbnRlcmZhY2UsDQo+ICsJCQkJCQkgICAgYWR2
ZXJ0aXNpbmcpOw0KPiArCWlmIChyZXQgPCAwKQ0KPiArCQlyZXR1cm4gcmV0Ow0KPiArDQo+ICsJ
Y2hhbmdlZCA9IHJldCA+IDA7DQo+ICsNCj4gKwlibWNyID0gbW9kZSA9PSBNTE9fQU5fSU5CQU5E
ID8gQk1DUl9BTkVOQUJMRSA6IDA7DQo+ICsJcmV0ID0gbWRpb2J1c19tb2RpZnkocGNzLT5idXMs
IHBjcy0+YWRkciwgTUlJX0JNQ1IsDQo+ICsJCQkgICAgIEJNQ1JfQU5FTkFCTEUsIGJtY3IpOw0K
PiArCWlmIChyZXQgPCAwKQ0KPiArCQlyZXR1cm4gcmV0Ow0KPiArDQo+ICsJcmV0dXJuIGNoYW5n
ZWQgPyAxIDogMDsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0xfR1BMKHBoeWxpbmtfbWlpX2MyMl9w
Y3NfY29uZmlnKTsNCj4gKw0KPiAgLyoqDQo+ICAgKiBwaHlsaW5rX21paV9jMjJfcGNzX2FuX3Jl
c3RhcnQoKSAtIHJlc3RhcnQgODAyLjN6IGF1dG9uZWdvdGlhdGlvbg0KPiAgICogQHBjczogYSBw
b2ludGVyIHRvIGEgJnN0cnVjdCBtZGlvX2RldmljZS4NCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvcGh5bGluay5oIGIvaW5jbHVkZS9saW51eC9waHlsaW5rLmggaW5kZXgNCj4gMDU3Zjc4
MjYzYTQ2Li4xYWFkMmFlYTQ2MTAgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvcGh5bGlu
ay5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvcGh5bGluay5oDQo+IEBAIC00NzgsNiArNDc4LDkg
QEAgdm9pZCBwaHlsaW5rX21paV9jMjJfcGNzX2dldF9zdGF0ZShzdHJ1Y3QgbWRpb19kZXZpY2UN
Cj4gKnBjcywgIGludCBwaHlsaW5rX21paV9jMjJfcGNzX3NldF9hZHZlcnRpc2VtZW50KHN0cnVj
dCBtZGlvX2RldmljZSAqcGNzLA0KPiAgCQkJCQkgIHBoeV9pbnRlcmZhY2VfdCBpbnRlcmZhY2Us
DQo+ICAJCQkJCSAgY29uc3QgdW5zaWduZWQgbG9uZyAqYWR2ZXJ0aXNpbmcpOw0KPiAraW50IHBo
eWxpbmtfbWlpX2MyMl9wY3NfY29uZmlnKHN0cnVjdCBtZGlvX2RldmljZSAqcGNzLCB1bnNpZ25l
ZCBpbnQgbW9kZSwNCj4gKwkJCSAgICAgICBwaHlfaW50ZXJmYWNlX3QgaW50ZXJmYWNlLA0KPiAr
CQkJICAgICAgIGNvbnN0IHVuc2lnbmVkIGxvbmcgKmFkdmVydGlzaW5nKTsNCj4gIHZvaWQgcGh5
bGlua19taWlfYzIyX3Bjc19hbl9yZXN0YXJ0KHN0cnVjdCBtZGlvX2RldmljZSAqcGNzKTsNCj4g
DQo+ICB2b2lkIHBoeWxpbmtfbWlpX2M0NV9wY3NfZ2V0X3N0YXRlKHN0cnVjdCBtZGlvX2Rldmlj
ZSAqcGNzLA0KPiAtLQ0KPiAyLjIwLjENCg0K
