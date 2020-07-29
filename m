Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7500A2319AA
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgG2Gl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:41:27 -0400
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:1123
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726290AbgG2Gl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 02:41:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HABKtZxHR3JuP3sIvgTw94u8FcHkOmh6HZ9FfR8GwMjEfVlU0I/NpGIL3K2B8NlZNNzbB/tU61d5c1kGtFuYaoWF0gRF5ebswkx4yMUlLFm2hXFTIxPrmOcbjVMqGOYwVWjCkRl9q9Hhfml+ZGYRR7eJ0jsvKLaLMBOlZ22ZDcQEHcIig3aHikxNMPOvQyoyxzRAGCbPNErNyfkFyvKFSQCGk0NvoPUdpOwz82tEHPgOOIwiX3o2KRhofAQgiKTPCwHUxjtWypcyaW57GvOXfeYeIi7GyvMbDVIrDn0mE5y8v2FUmfkABwsVI+qBeSslw43lKSnzxYiXEGXHuI6H/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZysjA0+5Gh92w0uwwUYDiwO6dsy1XPT6jB+7sOgaKbg=;
 b=H0hU9r2DKNEYD6/l7QKW4YBDHFFuSyfsi2EOS8hwgaw4gu0dAZda5bgHQyWNItUXftZe6KWl6c5HarhpPLjdTVZ9UhI1Joi1MradNFODeRh4iPSa7t8f4O2TewfOWub7z2730Y9kLcvK7xcdGzrPiKk4EsISqcUSncK/60UFeCFVOPpxt5c2CzhklSPL95gdqXIzSrLdTMbzGVjvrgJMc9590DwaINI3IbLCZjFaPrnEtgYxye5ddDQhkSk7YcPg1vlCXMto4xHUirtdy45Rs2dzoHK1eM1CDKqiczcpo6skZhDeiyrUW8Cp0E7dTEXi7uagxKoMYtoAgJxyk2ld0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZysjA0+5Gh92w0uwwUYDiwO6dsy1XPT6jB+7sOgaKbg=;
 b=cyHu8yI5sreQ1v9W2PxrVvOUULQLdq4TGhgT6SkvFm4F8FG674ZaIe3s81uK98QPuipXzkKqXK2/VFM/OK4qcMw9XYCKCO7utH1q258wAiSJVzgtVX8y0DqowajwSAyuA3G/d+Jy7B8FQzU1PWGXi6YKzclYo4qD2r/KMEFKnkk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2590.eurprd05.prod.outlook.com (2603:10a6:800:6b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.26; Wed, 29 Jul
 2020 06:41:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 06:41:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 0/2] udp_tunnel: convert mlx5 to the new
 udp_tunnel infrastructure
Thread-Topic: [PATCH net-next v2 0/2] udp_tunnel: convert mlx5 to the new
 udp_tunnel infrastructure
Thread-Index: AQHWZSiIXpIxJcYvj0G4cZWI5zTYTqkeHDgA
Date:   Wed, 29 Jul 2020 06:41:22 +0000
Message-ID: <4565008e504799c2fb5a008d27a7ac427db9813e.camel@mellanox.com>
References: <20200728214606.303058-1-kuba@kernel.org>
In-Reply-To: <20200728214606.303058-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4 (3.36.4-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e16f4c6d-30b9-497f-e7b8-08d8338a68db
x-ms-traffictypediagnostic: VI1PR0501MB2590:
x-microsoft-antispam-prvs: <VI1PR0501MB2590C866B65504F9BC76C631BE700@VI1PR0501MB2590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lNvzJZ0WzMYWWRndKer8u8aTyfmsEwi/sG8vD/WJO5w7hUmK8D+dAysPiSQmNnIL8/Wgcc2UrDRDCXMrfQRDyM5zzN4VM3x88s0lIg1TkJLrvhf4mCeC/7cyv9OterNaLy6Nyxv9WSj7/6CeCE2fnXL3d4lSt4gucf4hwiMTKrRSOkS+kxuMPKAsiHfEEvnkBBV7PTxVsrdosb3sqUt4PA+ScElomM1mToIoADVBMwb5sw58gCVFp5boC5BTj9ieRjzV92+4IsMB9H3LEPmRUClz4hZVLQggaWPRdLwg9i6LbtXxG94vCdClIEkLOfUr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(5660300002)(4326008)(36756003)(2616005)(83380400001)(6506007)(478600001)(316002)(71200400001)(6486002)(8936002)(91956017)(8676002)(64756008)(66556008)(2906002)(86362001)(6512007)(6916009)(26005)(66946007)(66476007)(76116006)(66446008)(54906003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: S7dvtL3Iuxq7cgMOpI6PVhB9SK9p9JWUYb6GNs+GHzV5GYBgvsZWoqPWFoFFNCazagwkfK0EtzPFE3ejzBzrJkYM+yyOeb5kRgbP0mcIddI4tZIpJ/SojGVf9PKR5UTdqJQur2cWsuPTXodaN870A99gRyMwosgWUQYbubgOP4JREu/U0pTwkGZmYpzLqUbwDbSihcKGIRtxQQJ1EP+hbk/wog9hRaQccWEo+WOCLdlcsX65ZJrcNfme3OTrIhUfDZhHfk09zhuL7OacIzz4SFp14JHmU3QQAf2HjLBU1ID2wmCUCKy1ESj8mIRKYInZcIO2xvChyEkUeYLEcdkLBEj2ndsMXJmuPlQr7Nl9bTBAI9SDbxB+mIY+RZWtGUsjazFJBNyrcpt21/fWY3G0nA8av5BWykm7RsWDJMlhnChbhIvVmvXF4FfgCtcs6fitE49XefW9k1YRyM2IUQIH6LHZiwoqkBGoBFNZNIta7pY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <177DC828CCFD4C429EC4ACCC724DDA42@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16f4c6d-30b9-497f-e7b8-08d8338a68db
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 06:41:22.9742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KwpvCv7t5Ppk/V/fZHaGYUtJcF+z/MGe4tiH57BMdO6+Ur5rKKO5i1PTODE+cShZP5MDUVzl7V0/U1RcHoBfkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTI4IGF0IDE0OjQ2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gVGhpcyBzZXQgY29udmVydHMgbWx4NSB0byB0aGUgbmV3IGluZnJhc3RydWN0dXJlLg0KPiAN
Cj4gV2UgbmVlZCBhIHNtYWxsIGFtb3VudCBvZiBzcGVjaWFsIGhhbmRsaW5nIGFzIG1seDUgZXhw
ZWN0cyBJQU5BIFZYTEFODQo+IHBvcnQgdG8gYWx3YXlzIGJlIHByb2dyYW1tZWQgaW50byB0aGUg
ZGV2aWNlLiBldGh0b29sIHdpbGwgc2hvdyBzdWNoDQo+IHBvcnRzIGluIGEgc2VwYXJhdGUsIHR5
cGUtbGVzcywgZmFrZSB0YWJsZSwgYXQgdGhlIGVuZDoNCj4gDQo+IFR1bm5lbCBpbmZvcm1hdGlv
biBmb3IgZXRoMDoNCj4gICBVRFAgcG9ydCB0YWJsZSAwOiANCj4gICAgIFNpemU6IDcNCj4gICAg
IFR5cGVzOiB2eGxhbg0KPiAgICAgTm8gZW50cmllcw0KPiAgIFVEUCBwb3J0IHRhYmxlIDE6IA0K
PiAgICAgU2l6ZTogMQ0KPiAgICAgVHlwZXM6IG5vbmUgKHN0YXRpYyBlbnRyaWVzKQ0KPiAgICAg
RW50cmllcyAoMSk6DQo+ICAgICAgICAgcG9ydCA0Nzg5LCB2eGxhbg0KPiANCj4gU2FlZWQgLSB0
aGlzIHNob3VsZCBhcHBseSBvbiB0b3Agb2YgbmV0LW5leHQsIGluZGVwZW5kZW50bHkgb2YNCj4g
dGhlIEludGVsIHBhdGNoZXMsIHdvdWxkIHlvdSBtaW5kIHRha2luZyB0aGlzIGluIGZvciB0ZXN0
aW5nDQo+IGFuZCByZXZpZXc/IEknbGwgcG9zdCB0aGUgbmV0ZGV2c2ltICYgdGVzdCBvbmNlIElu
dGVsIHBhdGNoZXMNCj4gcmUtZW1lcmdlLg0KPiANCg0KU3RhcnRlZCB0ZXN0aW5nLCB3aWxsIGhh
dmUgcmVzdWx0cyBpbiB0aGUgbW9ybmluZy4NCg0KPiB2MjogLSBkb24ndCBkaXNhYmxlIHRoZSBv
ZmZsb2FkIG9uIHJlcHJzIGluIHBhdGNoICMyLg0KPiANCj4gSmFrdWIgS2ljaW5za2kgKDIpOg0K
PiAgIHVkcF90dW5uZWw6IGFkZCB0aGUgYWJpbGl0eSB0byBoYXJkLWNvZGUgSUFOQSBWWExBTg0K
PiAgIG1seDU6IGNvbnZlcnQgdG8gbmV3IHVkcF90dW5uZWwgaW5mcmFzdHJ1Y3R1cmUNCj4gDQo+
ICBEb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZXRodG9vbC1uZXRsaW5rLnJzdCAgfCAgMyArDQo+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaCAgfCAgMiAtDQo+
ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgfCA4OCArKy0t
LS0tLS0tLS0tLS0tLQ0KPiAtLQ0KPiAgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fcmVwLmMgIHwgIDYgKy0NCj4gIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
bGliL3Z4bGFuLmMgICB8IDg3ICsrKysrKysrKy0tLS0tLQ0KPiAtLS0NCj4gIC4uLi9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL3Z4bGFuLmggICB8ICA2ICstDQo+ICBpbmNsdWRlL25l
dC91ZHBfdHVubmVsLmggICAgICAgICAgICAgICAgICAgICAgfCAgNSArKw0KPiAgbmV0L2V0aHRv
b2wvdHVubmVscy5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgNjkgKysrKysrKysrKysrKy0t
DQo+ICBuZXQvaXB2NC91ZHBfdHVubmVsX25pYy5jICAgICAgICAgICAgICAgICAgICAgfCAgNyAr
Kw0KPiAgOSBmaWxlcyBjaGFuZ2VkLCAxMzAgaW5zZXJ0aW9ucygrKSwgMTQzIGRlbGV0aW9ucygt
KQ0KPiANCg==
