Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF2A1BD8F7
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgD2KCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:02:51 -0400
Received: from mail-am6eur05on2117.outbound.protection.outlook.com ([40.107.22.117]:10560
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbgD2KCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 06:02:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJ3hzMo/kKBpRAgFmQNqsN7SWWMg611Cyy91Z/60ydL6Uva2rjowQcwt+Fnm+feYAcs/wAosEnShrPU91kImyAVbySKv3vtQyhG7RkymV6oKDgba40mWQY/MiK8LostRhmE+Yb1F1FDzM6Yoyh31utN8smP6RYSzWnq1/L6QDxfn2EhWRsGVuScZpxU/D1RvxyT+R4Dc4dueefoQk63CByHY87LoUAx4Y9eyRRkLD5TpHIbLwm7BYkp248CLRqTmDWvZykTFFbao0SbJzSXbWbOQxCbnwZqBg73vXaRB4TdvraPJu8g1Ida1fG6kFqjOoO5pTYYcZBTmBx/N93Jq6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfl8IrM0fiGI036uyIm3/TfCXvls1/EKXPp+ofgfIZA=;
 b=ATclvzVhozfcGBxH94oRzX7I3ZMRxo4MK9FI12MXp76ybK7q1m4e1NXTO79FGqFssG+Bs7B1O8PmdSwGNJEEgxw0kOqFsxUk7C2n9T88gGInfN6TdR2rZpjjpHv/j5Z9KJV/NQEv+CwHZCm4ht8zeWbmMGA5Jt71XcN3xT25iQiBShLhnhFfYW97oo+yh871A7D4x0ElKDs93gWnan4HptgLY8khOtbEyyGboSyk8cUCppv7wx1gA/zaiCOwRTOFoO69Qh7KK6jQ/lJyTJ8z8azk2xSfOq3FoJF6c2nLZtVoRi5eQo5rFnye8Ez4jBPs2lG3olD52L+QOcPFQi/NpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfl8IrM0fiGI036uyIm3/TfCXvls1/EKXPp+ofgfIZA=;
 b=KhweQQl7v9ZZJTA+IOXXxhk/8gYlBbPcYfqZIOFG5lIHI4b0RdrZVjawNRVKlL15QEU3g7m8rEY+jPkzBAX3TMBAqH0nZDHCUpPaa5gS3LHocrp2ek2fI6VsBAAHjV4ExdjG+0Yg0rbrRpA/mJcd5f+gx8aWyvMFrdfM4VwMJ5U=
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (2603:10a6:20b:a8::25)
 by AM6PR05MB6407.eurprd05.prod.outlook.com (2603:10a6:20b:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 10:02:46 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289%6]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 10:02:46 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "geert@linux-m68k.org" <geert@linux-m68k.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kazuya.mizuguchi.ks@renesas.com" <kazuya.mizuguchi.ks@renesas.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Thread-Topic: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Thread-Index: AQHWGHaxUA6NfMbeRU2VdAoOfe//rKiOsmkAgAAFQQCAAAgNgIABFHSAgAAVkQA=
Date:   Wed, 29 Apr 2020 10:02:46 +0000
Message-ID: <446fdadabfb852db3278553c5b6f8cbc003de5ea.camel@toradex.com>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
         <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
         <20200428154718.GA24923@lunn.ch>
         <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
         <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
In-Reply-To: <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=toradex.com;
x-originating-ip: [51.154.7.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58f55322-be3e-489d-615d-08d7ec2477b2
x-ms-traffictypediagnostic: AM6PR05MB6407:
x-microsoft-antispam-prvs: <AM6PR05MB6407E55FE63F85BE9DCE44A0F4AD0@AM6PR05MB6407.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6120.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39840400004)(54906003)(86362001)(316002)(5660300002)(4326008)(478600001)(6916009)(66556008)(66476007)(53546011)(186003)(71200400001)(44832011)(6486002)(8676002)(2616005)(66446008)(6512007)(36756003)(64756008)(91956017)(76116006)(2906002)(26005)(66946007)(6506007)(8936002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +F+WuFJJyTiaIiyPKNu2OAn90X+8MNRxcNCa79/t69YXgs/W3FxRLjK66D63prWnvHlYivoJLYBCWQQGd0Q+JGW969TdVOktG0nA7CUSI2A4uwTedJ8XWwHcE7iNTugDqXiby4xPuhlFxaCottPgz9ixFHhiqcIM/kbYOw4mRSXOiUwSj282MWBiXhumyE3PO1GeVXz/lMtdRekQAat3hchvaWc3GjrxHApvH/0eEdfOvDBrw3GIHiOnElpXWJiVv3blpdJ3GayIuRWdrXbOp2T1cPVKqbLzyy8eERldMSrAzRhS2wVRx5+pWHJRdg40yFFRI8URj/YaaiWM2RSstC/nojwTbf+Jma+0RsC9IIjbVhk7JJarJ4G4rZJ/BplTAjPNBvauCuh7wqyPRj8nVOYmUWcIMSaa9V3snmxqnzhJfJ3C27TYtgItmRZbPf/5
x-ms-exchange-antispam-messagedata: x9ktZoPxA6z9F74hOt1iBesRBromJlgESiYiwx825EfEJxzErIhR4z+6i8K3QomXtCHzfTyThTkh7O6ul+2uiDPKYtOQWZDoLMVKyk/Kg8CnuiJmfqCU27habtPYOtvqQMFAflqJcVOKeLKg86ls6Nn/QmYOxlD6Ie7/9Qindi8Uznoc8Fm2WPfYhVGybNxo3DAoMzmgiD53l92IwfAizFJ3iuH79IgJNAE6BAyVS0vlGjDAIsXXBgyq3WK8prlr+xEaS3wosv8nZbKAT0JKIEI25Xjws8TbNjFYe6pfMKv7QDeO0N6/wUToWMOk8M7UWk1LmnHYr2fPb1ZY2SapEeIRAAGGTcodFJz1byiNkIUtltT7J8N3XF7vHvvbnH/CU2+NX2DtwELBdWQjvsczz1PyO+lSPbI8A3fCLM0sxd0b3SfaONmOU3gKefOTIqsaLIZUJHsl0Kereig2SkG2+zGELjOieOkw1Mx3oB92a6Mc5VkklLycNy8hHxUFJ6QJd5SeZsbS9X9aDWtfDYcNWvEBeKht+qTLmFpMVN+BvFof+QCwNC5pot/nmPK509cJQjV7CHSBXM8NHMUCgxktelFgURNz3d5RGxRl6RSi3qZLD35Uom7oHc9otTTR2sAND+U+ioyhY1lbByTsYdR9t4rr3LQUnzKDcDNZ4g06OWA8IvMriD/mOOwtkIPUHswu5AYWk5rpPoXcOnPxjaqcRGfW8UWivETOJsvTkBUtS2kt4WL2XW0jGsN87bCyMs+zyp8rnXjFe65qbhoV2haIZznsr2kHuAQQ9CUf+SajMuk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FD72D694FE7C74BB3209B7C5C82FCA6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f55322-be3e-489d-615d-08d7ec2477b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 10:02:46.6232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /rqjwn3NYYmZf4RfitY3TVzWK+OpqiGhL2JIj8fuJs9kcxu52FsPIlcJQWo7kV8a7qjJTIhg1O5mG5VRjJIzpA11hz/PYa+b8yEBD2d7AhM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6407
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTI5IGF0IDEwOjQ1ICswMjAwLCBHZWVydCBVeXR0ZXJob2V2ZW4gd3Jv
dGU6DQo+IEhpIFBoaWxpcHBlLA0KPiANCj4gT24gVHVlLCBBcHIgMjgsIDIwMjAgYXQgNjoxNiBQ
TSBQaGlsaXBwZSBTY2hlbmtlcg0KPiA8cGhpbGlwcGUuc2NoZW5rZXJAdG9yYWRleC5jb20+IHdy
b3RlOg0KPiA+IE9uIFR1ZSwgMjAyMC0wNC0yOCBhdCAxNzo0NyArMDIwMCwgQW5kcmV3IEx1bm4g
d3JvdGU6DQo+ID4gPiBPbiBUdWUsIEFwciAyOCwgMjAyMCBhdCAwNToyODozMFBNICswMjAwLCBH
ZWVydCBVeXR0ZXJob2V2ZW4NCj4gPiA+IHdyb3RlOg0KPiA+ID4gPiBUaGlzIHRyaWdnZXJzIG9u
IFJlbmVzYXMgU2FsdmF0b3ItWChTKToNCj4gPiA+ID4gDQo+ID4gPiA+ICAgICBNaWNyZWwgS1Na
OTAzMSBHaWdhYml0IFBIWSBlNjgwMDAwMC5ldGhlcm5ldC1mZmZmZmZmZjowMDoNCj4gPiA+ID4g
Ki1za2V3LXBzIHZhbHVlcyBzaG91bGQgYmUgdXNlZCBvbmx5IHdpdGggcGh5LW1vZGUgPSAicmdt
aWkiDQo+ID4gPiA+IA0KPiA+ID4gPiB3aGljaCB1c2VzOg0KPiA+ID4gPiANCj4gPiA+ID4gICAg
ICAgICBwaHktbW9kZSA9ICJyZ21paS10eGlkIjsNCj4gPiA+ID4gDQo+ID4gPiA+IGFuZDoNCj4g
PiA+ID4gDQo+ID4gPiA+ICAgICAgICAgcnhjLXNrZXctcHMgPSA8MTUwMD47DQo+ID4gPiA+IA0K
PiA+ID4gPiBJZiBJIHVuZGVyc3RhbmQgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC9ldGhlcm5ldC0NCj4gPiA+ID4gY29udHJvbGxlci55YW1sDQo+ID4gPiA+IGNvcnJlY3Rs
eToNCj4gPiA+IA0KPiA+ID4gQ2hlY2tpbmcgZm9yIHNrZXdzIHdoaWNoIG1pZ2h0IGNvbnRyYWRp
Y3QgdGhlIFBIWS1tb2RlIGlzIG5ldy4gSQ0KPiA+ID4gdGhpbmsNCj4gPiA+IHRoaXMgaXMgdGhl
IGZpcnN0IFBIWSBkcml2ZXIgdG8gZG8gaXQuIFNvIGknbSBub3QgdG9vIHN1cnByaXNlZCBpdA0K
PiA+ID4gaGFzDQo+ID4gPiB0cmlnZ2VyZWQgYSB3YXJuaW5nLCBvciB0aGVyZSBpcyBjb250cmFk
aWN0b3J5IGRvY3VtZW50YXRpb24uDQo+ID4gPiANCj4gPiA+IFlvdXIgdXNlIGNhc2VzIGlzIHJl
YXNvbmFibGUuIEhhdmUgdGhlIG5vcm1hbCB0cmFuc21pdCBkZWxheSwgYW5kDQo+ID4gPiBhDQo+
ID4gPiBiaXQgc2hvcnRlZCByZWNlaXZlIGRlbGF5LiBTbyB3ZSBzaG91bGQgYWxsb3cgaXQuIEl0
IGp1c3QgbWFrZXMNCj4gPiA+IHRoZQ0KPiA+ID4gdmFsaWRhdGlvbiBjb2RlIG1vcmUgY29tcGxl
eCA6LSgNCj4gPiANCj4gPiBJIHJldmlld2VkIE9sZWtzaWoncyBwYXRjaCB0aGF0IGludHJvZHVj
ZWQgdGhpcyB3YXJuaW5nLiBJIGp1c3Qgd2FudA0KPiA+IHRvDQo+ID4gZXhwbGFpbiBvdXIgdGhp
bmtpbmcgd2h5IHRoaXMgaXMgYSBnb29kIHRoaW5nLCBidXQgeWVzIG1heWJlIHdlDQo+ID4gY2hh
bmdlDQo+ID4gdGhhdCB3YXJuaW5nIGEgbGl0dGxlIGJpdCB1bnRpbCBpdCBsYW5kcyBpbiBtYWlu
bGluZS4NCj4gPiANCj4gPiBUaGUgS1NaOTAzMSBkcml2ZXIgZGlkbid0IHN1cHBvcnQgZm9yIHBy
b3BlciBwaHktbW9kZXMgdW50aWwgbm93IGFzDQo+ID4gaXQNCj4gPiBkb24ndCBoYXZlIGRlZGlj
YXRlZCByZWdpc3RlcnMgdG8gY29udHJvbCB0eCBhbmQgcnggZGVsYXlzLiBXaXRoDQo+ID4gT2xl
a3NpaidzIHBhdGNoIHRoaXMgZGVsYXkgaXMgbm93IGRvbmUgYWNjb3JkaW5nbHkgaW4gc2tldyBy
ZWdpc3RlcnMNCj4gPiBhcw0KPiA+IGJlc3QgYXMgcG9zc2libGUuIElmIHlvdSBub3cgYWxzbyBz
ZXQgdGhlIHJ4Yy1za2V3LXBzIHJlZ2lzdGVycw0KPiA+IHRob3NlDQo+ID4gdmFsdWVzIHlvdSBw
cmV2aW91c2x5IHNldCB3aXRoIHJnbWlpLXR4aWQgb3IgcnhpZCBnZXQgb3ZlcndyaXR0ZW4uDQo+
ID4gDQo+ID4gV2UgY2hvc2UgdGhlIHdhcm5pbmcgdG8gb2NjdXIgb24gcGh5LW1vZGVzICdyZ21p
aS1pZCcsICdyZ21paS1yeGlkJw0KPiA+IGFuZA0KPiA+ICdyZ21paS10eGlkJyBhcyBvbiB0aG9z
ZSwgd2l0aCB0aGUgJ3J4Yy1za2V3LXBzJyB2YWx1ZSBwcmVzZW50LA0KPiA+IG92ZXJ3cml0aW5n
IHNrZXcgdmFsdWVzIGNvdWxkIG9jY3VyIGFuZCB5b3UgZW5kIHVwIHdpdGggdmFsdWVzIHlvdQ0K
PiA+IGRvDQo+ID4gbm90IHdhbnRlZC4gV2UgdGhvdWdodCwgdGhhdCBtb3N0IG9mIHRoZSBib2Fy
ZHMgaGF2ZSBqdXN0ICdyZ21paScNCj4gPiBzZXQgaW4NCj4gPiBwaHktbW9kZSB3aXRoIHNwZWNp
ZmljIHNrZXctdmFsdWVzIHByZXNlbnQuDQo+ID4gDQo+ID4gQEdlZXJ0IGlmIHlvdSBhY3R1YWxs
eSB3YW50IHRoZSBQSFkgdG8gYXBwbHkgUlhDIGFuZCBUWEMgZGVsYXlzIGp1c3QNCj4gPiBpbnNl
cnQgJ3JnbWlpLWlkJyBpbiB5b3VyIERUIGFuZCByZW1vdmUgdGhvc2UgKi1za2V3LXBzIHZhbHVl
cy4gSWYNCj4gPiB5b3UNCj4gDQo+IFRoYXQgc2VlbXMgdG8gd29yayBmb3IgbWUsIGJ1dCBvZiBj
b3Vyc2UgZG9lc24ndCB0YWtlIGludG8gYWNjb3VudCBQQ0INCj4gcm91dGluZy4NCj4gDQo+ID4g
bmVlZCBjdXN0b20gdGltaW5nIGR1ZSB0byBQQ0Igcm91dGluZyBpdCB3YXMgdGhvdWdodCBvdXQg
dG8gdXNlIHRoZQ0KPiA+IHBoeS0NCj4gPiBtb2RlICdyZ21paScgYW5kIGRvIHRoZSB3aG9sZSBy
ZXF1aXJlZCB0aW1pbmcgd2l0aCB0aGUgKi1za2V3LXBzDQo+ID4gdmFsdWVzLg0KPiANCj4gVGhh
dCBtZWFuIHdlIGRvIGhhdmUgdG8gcHJvdmlkZSBhbGwgdmFsdWVzIGFnYWluPw0KDQpJbiB0aGUg
Y2FzZSB0aGF0IHlvdSBoYXZlIG5vdCBsZW5ndGgtbWF0Y2hlZCByZ21paSBzaWduYWxzIG9uIHRo
ZSBQQ0IgSQ0Kd291bGQgYWR2aXNlIHlvdSB0byBjaGVjayB0aGUgc2tldyBzZXR0aW5ncyBjbG9z
ZWx5LiBPdGhlcndpc2UgeW91IG1pZ2h0DQplbmQgdXAgd2l0aCB2YWx1ZXMgdGhhdCB3b3JrIG9u
IHRoZSBib3JkZXIgYW5kIG1heSBmYWlsIG9uIHRoZSBmdWxsDQp0ZW1wZXJhdHVyZS1yYW5nZS4N
Cg0KSWYgdGhlIGxlbmd0aCBpcyBub3Qgb2ZmIGJ5IGh1Z2UgYW1vdW50cywgcmdtaWktaWQNCnNo
b3VsZCB3b3JrIGZpbmUuDQoNCj4gVXNpbmcgInJnbWlpIiB3aXRob3V0IGFueSBza2V3IHZhbHVl
cyBtYWtlcyBESENQIGZhaWwgb24gUi1DYXIgSDMNCj4gRVMyLjAsDQoNClRoYXQgc291bmRzIGxp
a2UgdGhlIFItQ2FyIEgzIEVTMi4wIGlzIG5vdCBwcm92aWRpbmcgYSBSWEMgZGVsYXkuDQoNCj4g
TTMtVyAoRVMxLjApLCBhbmQgTTMtTiAoRVMxLjApLiBJbnRlcmVzdGluZ2x5LCBESENQIHN0aWxs
IHdvcmtzIG9uIFItDQo+IENhcg0KPiBIMyBFUzEuMC4NCj4gDQo+IE5vdGUgdGhhdCBJJ20gbm90
IHRvby1mYW1pbGlhciB3aXRoIHRoZSBhY3R1YWwgc2tldyB2YWx1ZXMgbmVlZGVkDQo+IChDQyBN
aXp1Z3VjaGktc2FuKS4NCj4gDQo+IFJlbGF0ZWQgY29tbWl0czoNCj4gICAtIDBlNDVkYTFjNmVh
NmIxODYgKCJhcm02NDogZHRzOiByOGE3Nzk1OiBzYWx2YXRvci14OiBGaXgNCj4gRXRoZXJuZXRB
VkIgUEhZIHRpbWluZyIpDQo+ICAgLSBkZGEzODg3OTA3ZDc0MzM4ICgiYXJtNjQ6IGR0czogcjhh
Nzc5NTogVXNlIHJnbWlpLXR4aWQgcGh5LW1vZGUNCj4gZm9yIEV0aGVybmV0QVZCIikNCj4gICAt
IDdlZGExNGFmYjg4NDNhMGQgKCJhcm02NDogZHRzOiByZW5lc2FzOiByOGE3Nzk5MDogZWJpc3U6
IEZpeA0KPiBFdGhlcm5ldEFWQiBwaHkgbW9kZSB0byByZ21paSIpDQo+IA0KPiBUaGFua3MhDQo+
IA0KPiBHcntvZXRqZSxlZXRpbmd9cywNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIEdl
ZXJ0DQo+IA0KPiAtLQ0KPiBHZWVydCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3RzIG9mIExp
bnV4IGJleW9uZCBpYTMyIC0tIA0KPiBnZWVydEBsaW51eC1tNjhrLm9yZw0KPiANCj4gSW4gcGVy
c29uYWwgY29udmVyc2F0aW9ucyB3aXRoIHRlY2huaWNhbCBwZW9wbGUsIEkgY2FsbCBteXNlbGYg
YQ0KPiBoYWNrZXIuIEJ1dA0KPiB3aGVuIEknbSB0YWxraW5nIHRvIGpvdXJuYWxpc3RzIEkganVz
dCBzYXkgInByb2dyYW1tZXIiIG9yIHNvbWV0aGluZw0KPiBsaWtlIHRoYXQuDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgLS0gTGludXMgVG9ydmFsZHMNCg==
