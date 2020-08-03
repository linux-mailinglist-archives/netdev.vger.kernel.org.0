Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED4223A3D7
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 14:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHCMIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 08:08:30 -0400
Received: from mail-eopbgr1300071.outbound.protection.outlook.com ([40.107.130.71]:58621
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726394AbgHCMI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 08:08:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7YMo+MNxhMoTnGnHpZK6+xWmCtsTbvEiiAEsXQJIXIEHEqzEjuoIEe3Pc9IMjgdhHi0K7w+okmPjPyJnucYWPo1ABMuuLlUgMaPm/V1WOu7yXklCBhGCHZ+Gwx7wM9ahm1owMi1Omrt7+l6HgKmFy8FK0OcjL5fSHMXLiKHG39LzXxZzLRQ/4yYep9uJ0z1ldXQkubSeMFtK+XGiFDsr8aTi2TipRz1DmRR8jjugUKVsR3B1MX8WhKMYBWoVBv/Rge7a3iiDSJ7js6RVmoSf7JH0zinSPOSfFJOuAccB6Ed8Ysern15NbTpncTyd09Di/KgBx2Vp6e7NR2TcyVyvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBKjMMFoDYcaDh7IJhACMLh0mKnzfj7+BrO/NMKGarY=;
 b=bOAHnwz3hd3UMDKZWTpw3B4UY0tvBDgf00BLEN6wY8yzzzZ4iQJ86gEGl1WAwGkdAptK3BOKy0BdhU3E2iYfP+2VeIOwQbqRNqdz4x5IAwMUKNKsVUkToahYln39DgsqN2HugjFPRN6oi3OyN0GGvOidIO5DdC0pDdKpr0WY5QEd+1atyU41Hm13Pr+gvy4rePnxDvisrOJtIiUttzhvQbHzFag4PcTMMOhG6+1dpngvKfMGD18/InBlV3xvxytV3lY5AG2UZ51sVmSe8dv0g+wYkBPZwWLuL/lYATidwSBaH4CZrVmzE6V+ubrWeRyormfaG2qejG27FG9OoCWUnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quectel.com; dmarc=pass action=none header.from=quectel.com;
 dkim=pass header.d=quectel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quectel.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBKjMMFoDYcaDh7IJhACMLh0mKnzfj7+BrO/NMKGarY=;
 b=aAwZkqMv1ZuciveeRfMAIG6fIt3AnhI3dqDAfg3eMD19XoitXNT/vbrTX327AwxFmxwYobRNLAcPgKwtZ3W2oFv3ZdoR5XQ73wV6rAOe6nFjBIJ3XELE0BdCJF27Kd3+wQfnQpI65TVmpcuMtQatTFjLahvYWnTcaoScJrLhTMc=
Received: from HK2PR06MB3507.apcprd06.prod.outlook.com (2603:1096:202:3e::14)
 by HK2PR06MB3300.apcprd06.prod.outlook.com (2603:1096:202:34::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 12:08:24 +0000
Received: from HK2PR06MB3507.apcprd06.prod.outlook.com
 ([fe80::4ff:f478:119f:2b80]) by HK2PR06MB3507.apcprd06.prod.outlook.com
 ([fe80::4ff:f478:119f:2b80%4]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 12:08:24 +0000
From:   =?utf-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>
To:     =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Daniele Palmas <dnlplm@gmail.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "yzc666@netease.com" <yzc666@netease.com>,
        David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIHFtaV93d2FuOiBzdXBwb3J0IG1vZGlmeSB1c2Ju?=
 =?utf-8?B?ZXQncyByeF91cmJfc2l6ZQ==?=
Thread-Topic: [PATCH] qmi_wwan: support modify usbnet's rx_urb_size
Thread-Index: AQHWaYGZA5jXQ0Vbi0OPJRG5PwjhvakmQTNA
Date:   Mon, 3 Aug 2020 12:08:24 +0000
Message-ID: <HK2PR06MB3507C4CD349BBD29C68F3FCE864D0@HK2PR06MB3507.apcprd06.prod.outlook.com>
References: <2a2ddc57522e8fb2512e02feacbc2886@sslemail.net>
 <87r1so9fzl.fsf@miraculix.mork.no>
In-Reply-To: <87r1so9fzl.fsf@miraculix.mork.no>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mork.no; dkim=none (message not signed)
 header.d=none;mork.no; dmarc=none action=none header.from=quectel.com;
x-originating-ip: [210.73.58.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9599a7b9-130a-4216-bdd9-08d837a5ec20
x-ms-traffictypediagnostic: HK2PR06MB3300:
x-microsoft-antispam-prvs: <HK2PR06MB3300FD50CE3653EBB791A426864D0@HK2PR06MB3300.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +qio3Oj1MUG2PF43LwkIJzz2nTdteT/Z6JHdyvx9NR4Ajptr/lzLZoUSVaECVw9HzO+XX3HIXKLY6V5gtZrIHXwT2QTLf9LBc52hTtOwJ0XioFlmU7bMNH0pYzYUdsei2+++zx+op+SxsGYpJZye4WQQuBH9Kbu2C2vCuXsOZxjYZ5Wcl2746rkoZJDt4YsnNmNR60gUpQ6V/Ia1Be6OlmcDbXxoAVBAITOitfwRI5lvHH+QVfsS4umdKEMy4FzZd5WMCyB1GG2m8lJT82LGPHWtoXlG5gB997oEn8CVYob4+9EnS0zUzBN8c1+peeWStAJrwybTQdSO0rhD9a6QYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3507.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(346002)(39860400002)(396003)(366004)(66946007)(7696005)(33656002)(66476007)(66556008)(6506007)(86362001)(8936002)(83380400001)(85182001)(66574015)(64756008)(66446008)(110136005)(54906003)(5660300002)(4326008)(55016002)(9686003)(224303003)(52536014)(316002)(186003)(2906002)(71200400001)(26005)(76116006)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 665k6CFwWKAk8MoUPD/OqEJUdT1o+ZnWrYkjT4wSAi70Tl32+GKM6s2UuTponkVArwQOX+6Z8tzQ0OGFXweNDXFQNBkp+Gp95O06+YttW3I1JBxPos+dkXulxNlvRidrHLrckwCoYKVeIFYu2RKVrQHXxkHHXThwgt1huo6CVre4KSCKBYnn8b67OOuikNGuVLajUcgXZ3PbTm80+OAEoSAkpVVrvDExbqSoXvVuv36cxIoywWeZo07IZ/tzLsymDVrr8hHR1IIr3/zmwn/bRSEgjtfxuvXWfDvgN/RRF3RHgQaYb6VyHXKPnra5S1uZsONjRoCqCp/lrgM4nZeQnrLi7HFVpTyySgMOHhf2FkW+rOpWQQqs+gub2DLRSAwFike6m137H9MzccdWfud8FmzkXkcVenNN6pmMP/5t1DEWyz761K/5ICLL2qHFduWP1gcIlNV0d8gOG2AO81wK2sCLDqts5wl7PGr+djkWIoxZI43V9EaSgWxpZOEz74aLirV7lASQd6X+/g4rrbUKC5Dn9qayCmadBoLih7y5jLblsyyUjP2xF79MHBGcLORKODMLvGnVZrkEmoh8TBxIiQZQ6rNOViFGs4VDSWXpUY3ImKzUW0Tv5d+KYHjbPIxc1SgOrXyxo8Qnmn74b6nXng==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quectel.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3507.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9599a7b9-130a-4216-bdd9-08d837a5ec20
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 12:08:24.3055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7730d043-e129-480c-b1ba-e5b6a9f476aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6xM4LkFgziPlYSb8PGq0ih0gPzic78ARrFpOlkrQQm8ejJct2P1lye2Xc2lseiCQRu13yXYhPsrMxKgwhoHztw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR06MB3300
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ympvcm5AbW9yay5ubyB3cml0ZXM6DQo+IERhbmllbGUgUGFsbWFzIDxkbmxwbG1AZ21haWwuY29t
PiB3cml0ZXM6DQo+ID4gSWwgZ2lvcm5vIGx1biAzIGFnbyAyMDIwIGFsbGUgb3JlIDEwOjE4IEdy
ZWcgS0gNCj4gPiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IGhhIHNjcml0dG86DQo+ID4N
Cj4gPj4gQWN0dWFsbHksIG5vLCB0aGlzIGFsbCBzaG91bGQgYmUgZG9uZSAiYXV0b21hdGljYWxs
eSIsIGRvIG5vdCBjaGFuZ2UNCj4gPj4gdGhlIHVyYiBzaXplIG9uIHRoZSBmbHkuICBDaGFuZ2Ug
aXQgYXQgcHJvYmUgdGltZSBiYXNlZCBvbiB0aGUgZGV2aWNlDQo+ID4+IHlvdSBhcmUgdXNpbmcs
IGRvIG5vdCBmb3JjZSB1c2Vyc3BhY2UgdG8gImtub3ciIHdoYXQgdG8gZG8gaGVyZSwgYXMNCj4g
Pj4gaXQgd2lsbCBub3Qga25vdyB0aGF0IGF0IGFsbC4NCj4gPj4NCj4gPg0KPiA+IHRoZSBwcm9i
bGVtIHdpdGggZG9pbmcgYXQgcHJvYmUgdGltZSBpcyB0aGF0IHJ4X3VyYl9zaXplIGlzIG5vdCBm
aXhlZCwNCj4gPiBidXQgZGVwZW5kcyBvbiB0aGUgY29uZmlndXJhdGlvbiBkb25lIGF0IHRoZSB1
c2Vyc3BhY2UgbGV2ZWwgd2l0aA0KPiA+IFFNSV9XREFfU0VUX0RBVEFfRk9STUFULCBzbyB0aGUg
dXNlcnNwYWNlIGtub3dzIHRoYXQuDQo+IA0KPiBZZXMsIGJ1dCB0aGUgZHJpdmVyICJ3aWxsIGtu
b3ciIChvciAibWF5IGFzc3VtZSIpIHRoaXMgYmFzZWQgb24gdGhlDQo+IFFNSV9XV0FOX0ZMQUdf
TVVYIGZsYWcsIGFzIGxvbmcgYXMgd2UgYXJlIHVzaW5nIHRoZSBkcml2ZXIgaW50ZXJuYWwNCj4g
KGRlKW11eGluZy4gIFdlIHNob3VsZCBiZSBhYmxlIHRvIGF1dG9tYXRpY2FsbHkgc2V0IGEgc2Fu
ZSByeF91cmJfc2l6ZSB2YWx1ZQ0KPiBiYXNlZCBvbiB0aGlzPw0KPiANCj4gTm90IHN1cmUgaWYg
dGhlIHJtbmV0IGRyaXZlciBjdXJyZW50bHkgY2FuIGJlIHVzZWQgb24gdG9wIG9mIHFtaV93d2Fu
Pw0KPiBUaGF0IHdpbGwgb2J2aW91c2x5IG5lZWQgc29tZSBvdGhlciB3b3JrYXJvdW5kLg0KPiAN
Cj4gPiBDdXJyZW50bHkgdGhlcmUncyBhIHdvcmthcm91bmQgZm9yIHNldHRpbmcgcnhfdXJiX3Np
emUgaS5lLiBjaGFuZ2luZw0KPiA+IHRoZSBuZXR3b3JrIGludGVyZmFjZSBNVFU6IHRoaXMgaXMg
ZmluZSBmb3IgbW9zdCB1c2VzIHdpdGggcW1hcCwgYnV0DQo+ID4gdGhlcmUncyB0aGUgbGltaXRh
dGlvbiB0aGF0IGNlcnRhaW4gdmFsdWVzIChtdWx0aXBsZSBvZiB0aGUgZW5kcG9pbnQNCj4gPiBz
aXplKSBhcmUgbm90IGFsbG93ZWQuDQo+IA0KPiBBbmQgdGhpcyBhbHNvIHJlcXVpcmVzIGFuIGFk
ZGl0aW9uYWwgc2V0dXAgc3RlcCBmb3IgdXNlci91c2Vyc3BhY2UsIHdoaWNoIHdlDQo+IHNob3Vs
ZCB0cnkgdG8gYXZvaWQgaWYgcG9zc2libGUuDQo+IA0KPiBJJ20gYWxsIGZvciBhIGZ1bGx5IGF1
dG9tYXRpYyBzb2x1dGlvbi4gIEkgZG9uJ3QgdGhpbmsgcnhfdXJiX3NpemUgc2hvdWxkIGJlIGRp
cmVjdGx5DQo+IGNvbmZpZ3VyYWJsZS4gQW5kIGl0IGl0IHdlcmUsIHRoZW4gaXQgc2hvdWxkIGJl
IGltcGxlbWVudGVkIGluIHRoZSB1c2JuZXQNCj4gZnJhbWV3b3JrLiBJdCBpcyBub3QgYSBxbWlf
d3dhbiBzcGVjaWZpYyBhdHRyaWJ1dGUuDQoNCkhpIEJqw7hybiwgDQoJWW91IGNhbiBjaGVjayBj
ZGNfbmNtLmMuDQoJY2RjIG5jbSBkcml2ZXIgc2V0ICdyeF91cmJfc2l6ZScgb24gZHJpdmVyIHBy
b2JlIHRpbWUsIGFuZCB0aGUgdmFsdWUgcmVhZCBmcm9tJyBjZGNfbmNtX2JpbmRfY29tbW9uKCkg
J3MgVVNCX0NEQ19HRVRfTlRCX0ZPUk1BVCAnLg0KCWFuZCBhbHNvIGFsbG93IHRoZSB1c2Vyc3Bh
Y2UgdG8gbW9kaWZ5ICdyeF91cmJfc2l6ZScgYnkgJyAvc3lzL2NsYXNzL25ldC93d2FuMC9jZGNf
bmNtL3J4X21heCcuDQoNCj4gDQo+IA0KPiBCasO4cm4NCg==
