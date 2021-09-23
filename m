Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF75A4165EE
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242912AbhIWTYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:24:37 -0400
Received: from mail-eopbgr1400112.outbound.protection.outlook.com ([40.107.140.112]:64432
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242796AbhIWTYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 15:24:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJTBPDkgW7TbW/RRjacOhVrBYjHJEUk5gmX4AUyghU/9kQm0x/m+cOeKLXCDEnaxkibFBiIr/bZiazp1tv59EBSGMHEZRiTyggTzw7nha2AY6DWhyVbpSNSHmt8HrJPAIb4oF+nELcARX9R6lJAdzcBR1aCn7/cy1FGl9LpeWNG17NUKphVj+6wzGvmT+UOmrbMwnosR9Ql00fRUbijCiLyzgnJHCtfYYTHwZiztVHE7+Cc/CKaygrmNYTjsvdYqUPWMm7bkdSoUQri02D+heN0+bfPpfWfHOOu9qD5a8epIoZfw548CohZoXlU7XaxxR+IrdHV8yDFh9syenavarQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5ErvoJQ//EZXW8hv9bnjI0mKGbmtFXIPVfkHBeUijK4=;
 b=UzZO4lG/w1SvpZIZYomBx6zanyY1/pZlvkju/fwBf/Fl4XElflGQ1qozv1kU8XD6SvAQVO/rtitB6pvGXJWk9dApS8ZBmfmJZKElyKbNmS3qE3VjUb3pSXsiQ8scTNSYc+ifSx+EX0xPSlpoQeWYZgEMzxtn0wHQUGQhSQBscD2ZNwWr2xQr+all/zvsRFnaEwUufWDfWXlRlaf2y4NA1/C4ivjfocSb+c55pvfbTym3vv1MJclrgyuAq5W8+rdXE9xwq6Q6WjPukIJfMRlpl7BNHmh6tX8MxntHNf2x3mtJdWn5Og5+UksKdmaeJA/IEj51R5IrCrOp2QR4+3xy/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ErvoJQ//EZXW8hv9bnjI0mKGbmtFXIPVfkHBeUijK4=;
 b=PU0n3Wbt9cecwGCcdbMsOT36x+0iQtyPFQeghJhhUVcUwtnGuYyBgC1zeomMWi13OKbhesQbvNOdEZtY5MjlqSWPoq58I9Uef7nQeLVS7hMRqVqT6jtM3Rw1MJhWo1OhejIdJIHVFYNCDme2IJBniz3RIhd/5dFlE4ZkijgT1tw=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5956.jpnprd01.prod.outlook.com (2603:1096:604:b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 19:22:59 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 19:22:59 +0000
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
Thread-Index: AQHXsIR809ll8TcGVk6ArGR8VNmdYaux+3GAgAAB9AA=
Date:   Thu, 23 Sep 2021 19:22:59 +0000
Message-ID: <OS0PR01MB592208B398BED9F36677B59B86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-4-biju.das.jz@bp.renesas.com>
 <183fd9d2-353d-1985-7145-145a03967f6e@omp.ru>
In-Reply-To: <183fd9d2-353d-1985-7145-145a03967f6e@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4ff28c8-4f02-48b4-10f3-08d97ec78e37
x-ms-traffictypediagnostic: OS0PR01MB5956:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB59564E55CB00704BEDD3254486A39@OS0PR01MB5956.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0CwmS2E2+6t41tIKGsrCKjWqklge2ruEunmB6O6jK1RVWGCZSJ4ob6bdmcBEyhi6HpK7UHEm8w7/js9ZKXqmDFF7qh5jTmWRxyiuO2rMdO062FC30iZUzl10VGFIMj3wqwKVJpmFDUOu9Nf9pMFabgvyNpHGviEtx7QhaTYP6EIs5dPJCrd6qQNVt8Ykbsc2gYZo66wzskk5XshGVz1Hvaz5MtKCVX8PuS6vK9Kelx2VfR4KWPGWHxuQHYMqbmV12S4gt74D8nS/oqKeVdt1PW/x84s2Fatc/nMKv9cVGWtZUq9ZXJrLzJc63TK3lDWeuk5hmW5gr1dEwqL40FsSStWP+Kmfd7dL3r2JRgUvREG4fvMuZ1/op3AWXU1b27Fx8XDAWEYWUNh6RKAVFATEn+222kwDTj7Ykr6X0VQAzIFyAIthQKTAugbHjHSWGh2C5iKYxg56kUZqwBlll3pLxEC4Gc/UwIHeGUWl1O4pzS/swqVf8kCt/OVETAt1iocZEHLFPzFQTidnQlY+2ri9V0br6Sm1GYzsJH+9SYUOLPzRtB8OVZG+95B0udPkaHnUfS1JZQGlBiNnPoAj1TSmUJAk5oWKK3qgrdix8QVaJfUkT1tUAXfD5PLXQQBhbLmUbaYYdkS4c4wgLAQDgJLx8sDV7E10fj4GjYiTlbHj92gr8rYY2uvw61GjHycMC2pUBxW3UUi8mqSAufcDFXeaUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(8936002)(76116006)(66946007)(110136005)(4326008)(8676002)(38070700005)(86362001)(71200400001)(6506007)(52536014)(66476007)(66556008)(66446008)(107886003)(316002)(64756008)(2906002)(54906003)(33656002)(186003)(508600001)(53546011)(55016002)(5660300002)(122000001)(7696005)(26005)(38100700002)(83380400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UStFUEg0MjFzSnFzMG1iT3ZYc1JOS1A1THpQaHZGNnJNekxRcmxTY25QQjlt?=
 =?utf-8?B?UlB0alpUOXUwMWJsL2pNenBoVm9yeDB3NGw4aXhoNUVDL21ia3laV3RST21M?=
 =?utf-8?B?RUtCeWZCb3J3MzVLVTBVY1JKMlZDeUU3TUVRZThBN1pLSWRmOEhwZ0NtZFVC?=
 =?utf-8?B?UjVnVVZuMTlBRHQySy9heWJzK0hCWGJzQWkvSmVqTGRZbi9ERXd2ZFhtNndt?=
 =?utf-8?B?eVROdklHUVpSU1dkMWtzeWxSVm42dzdaZ25zVkpsb1lTWXFMQlZ0SWkrTUVo?=
 =?utf-8?B?NEQrbzcvcjhkeU1CY1p5bUxKdzVMNm44VjVSWmdXVENuL0pkNGNpWGVJNTlF?=
 =?utf-8?B?Ym4vM2lIZy9YcFJaRjVDU1F3ZlR3N3k1N0FDd3lOZVNLcTJ0bVFTaTkyTWl1?=
 =?utf-8?B?M2RLTmNXdkh3Zk1jZkFwMGdXLytlNFJOYmtFZUFQZWtOdUJjWXYvWXZ6enZV?=
 =?utf-8?B?aUNuQ1pQRDltRjZRbDE3UUNNVWdVQmdmM1pSTFcvSlY0bnhpRkdyNEcwMnJ6?=
 =?utf-8?B?Q0RVa001MnIzQlVoV05WdE5Ibmx5YXQ4MWxUa3BGYURjekdSMFlVTXhldk5Q?=
 =?utf-8?B?LzRhS3BPdGtoWmQ0a2o3VjRwNm94Znh0WEFnQTIvaXRaQ2VicDhtUFQxZko0?=
 =?utf-8?B?LzdJOCtWWXNDUW5MM1FBWGlFOXVHcTZ0bnJ0b1A1VW9hdnA2TjVVckRZT1BJ?=
 =?utf-8?B?K0JmOGNvdHVLLzVnVkRjYzQrVWZ2UUJjcE9xb3dBdmgzWlhlMTFrUjhXZE5L?=
 =?utf-8?B?VXFQekVRSEd1VnIydnoyaGYwSVdVUXdmS3pXejFObkIwbnV0SnVlb2R3R2VW?=
 =?utf-8?B?bGU1cTV6dGVJU0FZYmZ0MzQvNFBUMzBzZ0Z4cWdOQzFyM0hQTmhFQVpoVEV4?=
 =?utf-8?B?dVZiSzlCTllucmJNM1o4c1lFMmRsemRWU1hPL05ZOTRuWCsydUQ1aFJJZ1RU?=
 =?utf-8?B?Rk9lMFZoY1grb1Ria080alB1YXRTK3Z6YXZrUDVqWHJTL05veEM5MDFvQ0lq?=
 =?utf-8?B?Z3ZRWmJXUFRtOGxkclhQUytTbXU5a0VUQ20xT2xHR204S3NnaFd3dnNTZU9P?=
 =?utf-8?B?UzFORFJmUUVJanpBTzNqdnpNaHh5UllWWm5ZMVlhcStJbFI0ZHQvY0dWMjhF?=
 =?utf-8?B?cXdhQ2dDbnNJNnpLcitBRDNVb2ovRkprdlRTd2NreVZIWGEzQlhid1pFWkVV?=
 =?utf-8?B?MnhoZmtzYnZRNkdyZVRHYlJ4TXlYdC9uNlhmNVBCemNHTWtXMmpBOUVxT1pZ?=
 =?utf-8?B?QmQwbitiV1dMWGZSWVZPNHR4ZWRvVU9hRGJlVGxVTXc3NU9keEUwTDF6K0xn?=
 =?utf-8?B?dVZPZklZOWtLcWdKV3Q0eWlkNy8rbVVzT3Blc2doNEwxbURIQnUvc1d0S1Rv?=
 =?utf-8?B?ekVBZENVNW1jS3REMFpxc2lEczIxaTNBU1g0bEhxYzJtSjlMeWRJVlpzNnhK?=
 =?utf-8?B?dHowUUZXZnhWdXJmWCt5dkhIRnRsVFIyOWNRZm9mUCt0QkFkZ3JseE1FM2x2?=
 =?utf-8?B?QloxVVAzeHFDWlc1UVpOTW1ta0FUQXlIVEVGZTYxU0x3eENrR3lPMS9Ebmho?=
 =?utf-8?B?LzB4R1FWTGhiTXcwV2trR1dKVG5qT1hXWmV1dk84YmNGcDQyQng0cm5tMnll?=
 =?utf-8?B?a21jeFBEV0grZTNqMHNiOTZYOTBHa3VmSUttUVE0ZTUyTVNGU3V4WTcxSlR2?=
 =?utf-8?B?SUJGZm9mV0ErcnBKTXZaS2ZyK1dZVXJaZzBKYW9NaDMzcmJlenZTaFA1Yk91?=
 =?utf-8?Q?347J16O4NbdGK1SRP2AKvjlGAj5s/YFBi1XONGc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ff28c8-4f02-48b4-10f3-08d97ec78e37
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 19:22:59.7807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 628E6npYul+LhFwrl1Gx0sCuTRaSjt2AlmvTRRrXr14Vqqv8zoKnOY0AG/ThTUjJm1lMrdhn/ElKjtpUBy6QXyJzJ59baMJgNv2d1mYdYSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SEkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDL1BBVENIIDAzLzE4XSByYXZiOiBJbml0
aWFsaXplIEdiRXRoZXJuZXQgZG1hYw0KPiANCj4gT24gOS8yMy8yMSA1OjA3IFBNLCBCaWp1IERh
cyB3cm90ZToNCj4gDQo+ID4gSW5pdGlhbGl6ZSBHYkV0aGVybmV0IGRtYWMgZm91bmQgb24gUlov
RzJMIFNvQy4NCj4gPiBUaGlzIHBhdGNoIGFsc28gcmVuYW1lcyByYXZiX3JjYXJfZG1hY19pbml0
IHRvIHJhdmJfZG1hY19pbml0X3JjYXIgdG8NCj4gPiBiZSBjb25zaXN0ZW50IHdpdGggdGhlIG5h
bWluZyBjb252ZW50aW9uIHVzZWQgaW4gc2hfZXRoIGRyaXZlci4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4g
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8ICA0ICsrDQo+ID4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCA4NA0KPiA+ICsrKysr
KysrKysrKysrKysrKysrKysrLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDg1IGluc2VydGlvbnMo
KyksIDMgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yi5oDQo+ID4gaW5kZXggMGNlMGMxM2VmOGNiLi5iZWUwNWU2ZmI4MTUgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IEBAIC04MSw2ICs4MSw3IEBAIGVu
dW0gcmF2Yl9yZWcgew0KPiA+ICAJUlFDMwk9IDB4MDBBMCwNCj4gPiAgCVJRQzQJPSAweDAwQTQs
DQo+ID4gIAlSUEMJPSAweDAwQjAsDQo+ID4gKwlSVEMJPSAweDAwQjQsCS8qIFJaL0cyTCBvbmx5
ICovDQo+IA0KPiAgICBNeSBnZW4zIG1hbnVhbCBzYXlzIHRoZSByZWdpdXN0ZXIgZXhpc3RzIHRo
ZXJlLi4uDQo+IA0KPiA+ICAJVUZDVwk9IDB4MDBCQywNCj4gPiAgCVVGQ1MJPSAweDAwQzAsDQo+
ID4gIAlVRkNWMAk9IDB4MDBDNCwNCj4gPiBAQCAtMTU2LDYgKzE1Nyw3IEBAIGVudW0gcmF2Yl9y
ZWcgew0KPiA+ICAJVElTCT0gMHgwMzdDLA0KPiA+ICAJSVNTCT0gMHgwMzgwLA0KPiA+ICAJQ0lF
CT0gMHgwMzg0LAkvKiBSLUNhciBHZW4zIG9ubHkgKi8NCj4gPiArCVJJQzMJPSAweDAzODgsCS8q
IFJaL0cyTCBvbmx5ICovDQo+IA0KPiAgICBBZ2FpbiwgdGhpcyByZWdpc3RlciAoYWxvbmcgd2l0
aCBSSVMzKSBleGlzdHMgb24gZ2VuMy4uLg0KPiANCj4gPiAgCUdDQ1IJPSAweDAzOTAsDQo+ID4g
IAlHTVRUCT0gMHgwMzk0LA0KPiA+ICAJR1BUQwk9IDB4MDM5OCwNCj4gPiBAQCAtOTU2LDYgKzk1
OCw4IEBAIGVudW0gUkFWQl9RVUVVRSB7DQo+ID4NCj4gPiAgI2RlZmluZSBSWF9CVUZfU1oJKDIw
NDggLSBFVEhfRkNTX0xFTiArIHNpemVvZihfX3N1bTE2KSkNCj4gPg0KPiA+ICsjZGVmaW5lIFJH
RVRIX1JYX0JVRkZfTUFYIDgxOTINCj4gPiArDQo+ID4gIHN0cnVjdCByYXZiX3RzdGFtcF9za2Ig
ew0KPiA+ICAJc3RydWN0IGxpc3RfaGVhZCBsaXN0Ow0KPiA+ICAJc3RydWN0IHNrX2J1ZmYgKnNr
YjsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21h
aW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+
IGluZGV4IDI0MjJlNzRkOWI0Zi4uNTRjNGQzMWE2OTUwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gQEAgLTgzLDYgKzgzLDExIEBAIHN0
YXRpYyBpbnQgcmF2Yl9jb25maWcoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQo+ID4gIAlyZXR1
cm4gZXJyb3I7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgdm9pZCByYXZiX3JnZXRoX3NldF9y
YXRlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KSB7DQo+ID4gKwkvKiBQbGFjZSBob2xkZXIgKi8N
Cj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIHZvaWQgcmF2Yl9zZXRfcmF0ZShzdHJ1Y3QgbmV0
X2RldmljZSAqbmRldikgIHsNCj4gPiAgCXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYgPSBuZXRk
ZXZfcHJpdihuZGV2KTsgQEAgLTIxNyw2ICsyMjIsMTEgQEANCj4gPiBzdGF0aWMgaW50IHJhdmJf
dHhfZnJlZShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEsIGJvb2wNCj4gZnJlZV90eGVk
X29ubHkpDQo+ID4gIAlyZXR1cm4gZnJlZV9udW07DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMg
dm9pZCByYXZiX3J4X3JpbmdfZnJlZV9yZ2V0aChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50
IHEpIHsNCj4gPiArCS8qIFBsYWNlIGhvbGRlciAqLw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0
aWMgdm9pZCByYXZiX3J4X3JpbmdfZnJlZShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEp
ICB7DQo+ID4gIAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7
IEBAIC0yODMsNiArMjkzLDExIEBADQo+ID4gc3RhdGljIHZvaWQgcmF2Yl9yaW5nX2ZyZWUoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKQ0KPiA+ICAJcHJpdi0+dHhfc2tiW3FdID0gTlVM
TDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkIHJhdmJfcnhfcmluZ19mb3JtYXRfcmdl
dGgoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBxKQ0KPiA+ICt7DQo+ID4gKwkvKiBQbGFj
ZSBob2xkZXIgKi8NCj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIHZvaWQgcmF2Yl9yeF9yaW5n
X2Zvcm1hdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEpICB7DQo+ID4gIAlzdHJ1Y3Qg
cmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7IEBAIC0zNTYsNiArMzcxLDEy
IEBADQo+ID4gc3RhdGljIHZvaWQgcmF2Yl9yaW5nX2Zvcm1hdChzdHJ1Y3QgbmV0X2RldmljZSAq
bmRldiwgaW50IHEpDQo+ID4gIAlkZXNjLT5kcHRyID0gY3B1X3RvX2xlMzIoKHUzMilwcml2LT50
eF9kZXNjX2RtYVtxXSk7DQo+ID4gIH0NCj4gPg0KPiA+ICtzdGF0aWMgdm9pZCAqcmF2Yl9yZ2V0
aF9hbGxvY19yeF9kZXNjKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSkNCj4gPiArew0K
PiA+ICsJLyogUGxhY2UgaG9sZGVyICovDQo+ID4gKwlyZXR1cm4gTlVMTDsNCj4gPiArfQ0KPiA+
ICsNCj4gPiAgc3RhdGljIHZvaWQgKnJhdmJfYWxsb2NfcnhfZGVzYyhzdHJ1Y3QgbmV0X2Rldmlj
ZSAqbmRldiwgaW50IHEpICB7DQo+ID4gIAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0
ZGV2X3ByaXYobmRldik7IEBAIC00MjYsNiArNDQ3LDExIEBADQo+ID4gc3RhdGljIGludCByYXZi
X3JpbmdfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHEpDQo+ID4gIAlyZXR1cm4g
LUVOT01FTTsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkIHJhdmJfcmdldGhfZW1hY19p
bml0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KSB7DQo+ID4gKwkvKiBQbGFjZSBob2xkZXIgKi8N
Cj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIHZvaWQgcmF2Yl9yY2FyX2VtYWNfaW5pdChzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldikgIHsNCj4gPiAgCS8qIFJlY2VpdmUgZnJhbWUgbGltaXQgc2V0
IHJlZ2lzdGVyICovIEBAIC00NjEsNyArNDg3LDMyIEBAIHN0YXRpYw0KPiA+IHZvaWQgcmF2Yl9l
bWFjX2luaXQoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQo+ID4gIAlpbmZvLT5lbWFjX2luaXQo
bmRldik7DQo+ID4gIH0NCj4gPg0KPiA+IC1zdGF0aWMgdm9pZCByYXZiX3JjYXJfZG1hY19pbml0
KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KPiA+ICtzdGF0aWMgdm9pZCByYXZiX2RtYWNfaW5p
dF9yZ2V0aChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikgew0KPiA+ICsJLyogU2V0IEFWQiBSWCAq
Lw0KPiA+ICsJcmF2Yl93cml0ZShuZGV2LCAweDYwMDAwMDAwLCBSQ1IpOw0KPiA+ICsNCj4gPiAr
CS8qIFNldCBNYXggRnJhbWUgTGVuZ3RoIChSVEMpICovDQo+ID4gKwlyYXZiX3dyaXRlKG5kZXYs
IDB4N2ZmYzAwMDAgfCBSR0VUSF9SWF9CVUZGX01BWCwgUlRDKTsNCj4gDQo+ICAgIFNob3VsZCBi
ZSBpbml0J2VkIG9uIGdlbjMgYXMgd2VsbD8NCg0KUmNhciBnZW4zIGhhcyBzZXBhcmF0ZSBpbml0
aWFsaXphdGlvbiByb3V0aW5lLCBUaGlzIHBhcnQgaXMgUlovRzJMIHNwZWNpZmljLCB0aGUgYnVm
ZmVyIHNpemUgaXMgZGlmZmVyZW50Lg0KDQo+IA0KPiA+ICsNCj4gPiArCS8qIFNldCBGSUZPIHNp
emUgKi8NCj4gPiArCXJhdmJfd3JpdGUobmRldiwgMHgwMDIyMjIwMCwgVEdDKTsNCj4gPiArDQo+
ID4gKwlyYXZiX3dyaXRlKG5kZXYsIDAsIFRDQ1IpOw0KPiA+ICsNCj4gPiArCS8qIEZyYW1lIHJl
Y2VpdmUgKi8NCj4gPiArCXJhdmJfd3JpdGUobmRldiwgUklDMF9GUkUwLCBSSUMwKTsNCj4gPiAr
CS8qIERpc2FibGUgRklGTyBmdWxsIHdhcm5pbmcgKi8NCj4gPiArCXJhdmJfd3JpdGUobmRldiwg
MHgwLCBSSUMxKTsNCj4gPiArCS8qIFJlY2VpdmUgRklGTyBmdWxsIGVycm9yLCBkZXNjcmlwdG9y
IGVtcHR5ICovDQo+ID4gKwlyYXZiX3dyaXRlKG5kZXYsIFJJQzJfUUZFMCB8IFJJQzJfUkZGRSwg
UklDMik7DQo+ID4gKw0KPiA+ICsJcmF2Yl93cml0ZShuZGV2LCAweDAsIFJJQzMpOw0KPiANCj4g
ICAgU2hvdWxkIGJlIGluaXQnZWQgb24gZ2VuMyBhcyB3ZWxsPyBNYXR0ZXIgb2YgYSBzZXBhcmF0
ZSBwYXRjaCwgSSBjYW4gZG8NCj4gaXQgcHJvbGx5Li4uDQoNCk9LLiBNYXkgYmUgYWZ0ZXIgY29t
cGxldGluZyBSWi9HMkwsIEkgY2FuIGludmVzdGlnYXRlIG9uIGdlbjMgc3R1ZmYgb3IgSWYgeW91
IGhhdmUgUi1DYXIgYm9hcmQgYW5kIGNvbmZpcm0gdGhpcyBjaGFuZ2UgDQpXb24ndCBicmVhayBh
bnl0aGluZyBvbiBSLUNhciBnZW4zLCB5b3UgY2FuIHN1Ym1pdCB0aGUgcGF0Y2guDQoNClJlZ2Fy
ZHMsDQpCaWp1DQoNCg0KPiANCj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
