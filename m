Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0373E1A2A9E
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgDHUr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:47:27 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:5760
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbgDHUr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 16:47:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLJnWv7YBGOzbcEiZ3US+9pNKWA9v5oc+afMp4IRDfpmX0YbuzwMFRUvuoVrZaB/jIFVpGySmEPghW897cAavCV+uR/kD96BjuUaZKcvtK8HIKANnT/b2IatQZtGGJGPDYH3oe4cL3P4a2+DKaJR1GJgrgATPgsqSvTo6vsWd/f8bLRZ9bQSJZHBb2G9AaQoN+r0Sq9OfJO7MA1dxc4x/NvgcU7EfbkO9nCVFAB3U0g056qHLeCQceiYOKp1kp93L5kqNthqwbnKcbnZb44de4djxZR7oe8UUDv4l3x4EJI5U6h1hFguSp+V21/Wsn2V7WogIQGR4AC/IKiOVxJnbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5C2yrNFG1WpZbEBstEvGGHWPgYE4xOPefqieHv/qqI=;
 b=FiDasvSyk755xMxOj94hEACjLoeqa/gfk/pn73YGszr6AlBVM7pPrqy7Wrmx0ibEPOvBEp7YKdtY8XSzy5W7zduAFOLGGXqjzFCWDEwPSlQliLGonCWZAnk+KsL33eT3oAS7fAWfzfFOJGMIQFtrm+ibK+7QjoRlcQ6iHSnZ2uLnMW6hOry74nvWBZniAeHzV7M5Iswxnwnc6Me6/rkOb1FgQY5MtoDPbSG6+oYdHtSLGjalySjJ0/UsXWMvfUZDs+DLWOTRkwvPBTZOTZCQyRcUOXjPNPmtTjkbcnJpa7T1duSGBGj+KFdIB/c4PKTqOvvjRYReXu7l8mxVNOtbjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5C2yrNFG1WpZbEBstEvGGHWPgYE4xOPefqieHv/qqI=;
 b=fvZT/yIXivexpIdFxNjT+lYbKJ+w215zk/0PAzxghqri7jyhCI/UJCFnVP5olHdYswtxJ3U5NC/fEodGAxSgpaq6jdZ/q8bJJ1QXUl2XnoQBqmwmrvt3tJJ/h4wwBVzuhNI6w2EpXYmXcFSr11Elwkmws+roa9o9FCiwf3XoOeE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4829.eurprd05.prod.outlook.com (2603:10a6:803:54::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 8 Apr
 2020 20:46:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 20:46:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "nico@fluxnic.net" <nico@fluxnic.net>,
        "arnd@arndb.de" <arnd@arndb.de>
CC:     "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
Thread-Topic: [RFC 0/6] Regressions for "imply" behavior change
Thread-Index: AQHWDeQiJzc7TgrcN0yUMWAEU5j98qhvr4mAgAACMYA=
Date:   Wed, 8 Apr 2020 20:46:42 +0000
Message-ID: <79428caffc83f8ba3c13caf628ae6f207f88286a.camel@mellanox.com>
References: <20200408202711.1198966-1-arnd@arndb.de>
         <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
In-Reply-To: <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0c20c379-dbc1-4ff4-cc3f-08d7dbfdf1ae
x-ms-traffictypediagnostic: VI1PR05MB4829:
x-microsoft-antispam-prvs: <VI1PR05MB48294E62909A79321DEB36BBBEC00@VI1PR05MB4829.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(396003)(376002)(366004)(39850400004)(346002)(6486002)(478600001)(54906003)(316002)(110136005)(2906002)(36756003)(81166007)(71200400001)(7416002)(76116006)(66946007)(26005)(66476007)(186003)(66556008)(86362001)(6506007)(8676002)(64756008)(66446008)(8936002)(91956017)(81156014)(6512007)(2616005)(5660300002)(4326008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C3OxCh9PzqF3nbMk6II8OXXgDlGAq2501afsEgNr/Asnf7ENsi332tMgPuFvRETQUDgp06rGC6YXct3vio+AUvJhi55CHEHxc3gPL5J0+CpATwXfhm/W/SwrZAW7NYTxioVokxY+hlX1OokIowEwXqc3Zi7Bg8mwO9aQtIMBVM/TazsG4PlK9pWweG1rLbKE4NQpTPA6j4SwbqD0mHY7w4GJLNwVs3qTL3reuynK8vCkKL7+SwZE5BZBDuEwsUCFsZ/dAw43SzNOKPZ2+BnMUw8NjPsGdWpr+QPgkFRAVw64HtvJeh9jsbXlOnOjc7s76qdu3JaFJN+GQNhgFrzrSp19SDxzfwV5nj2MmumciC/EYDRwD2lXYaeZuVXcbr7TrEr06I6D3D4cLsMOosHJoIsF6Byjphjenoq7WfGR81RaWBVrr0oT19tmQxNU6YNw
x-ms-exchange-antispam-messagedata: UOTu1HCc3sT3i8reD5vJWzI19IJqLLaUI4ppva5vSLUnxJ08XkQh7b53tpIYaBruTs3ugJtIg9ostoc6N72TQu0flAIpF/Ag9WnXokSOXaPnteM53ymsqwu7MQO+UqdBq6+9GNT0yEzJIcFUbnqtkQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9250023C58FAD442A0D72B84739931B2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c20c379-dbc1-4ff4-cc3f-08d7dbfdf1ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 20:46:42.2748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gddj1rWCHyfxyo9YMTU0DL9Zg8ZYngW0vpmaCBi+iABJrAqVa7/dCBp/FVZJ/u8TxNqDG0fNuIAf3vSbD5KZ9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4829
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTA4IGF0IDE2OjM4IC0wNDAwLCBOaWNvbGFzIFBpdHJlIHdyb3RlOg0K
PiBPbiBXZWQsIDggQXByIDIwMjAsIEFybmQgQmVyZ21hbm4gd3JvdGU6DQo+IA0KPiA+IEhpIGV2
ZXJ5b25lLA0KPiA+IA0KPiA+IEkndmUganVzdCByZXN0YXJ0ZWQgZG9pbmcgcmFuZGNvbmZpZyBi
dWlsZHMgb24gdG9wIG9mIG1haW5saW5lDQo+ID4gTGludXggYW5kDQo+ID4gZm91bmQgYSBjb3Vw
bGUgb2YgcmVncmVzc2lvbnMgd2l0aCBtaXNzaW5nIGRlcGVuZGVuY3kgZnJvbSB0aGUNCj4gPiBy
ZWNlbnQNCj4gPiBjaGFuZ2UgaW4gdGhlICJpbXBseSIga2V5d29yZCBpbiBLY29uZmlnLCBwcmVz
dW1hYmx5IHRoZXNlIHR3bw0KPiA+IHBhdGNoZXM6DQo+ID4gDQo+ID4gM2E5ZGQzZWNiMjA3IGtj
b25maWc6IG1ha2UgJ2ltcGx5JyBvYmV5IHRoZSBkaXJlY3QgZGVwZW5kZW5jeQ0KPiA+IGRlZjJm
YmZmZTYyYyBrY29uZmlnOiBhbGxvdyBzeW1ib2xzIGltcGxpZWQgYnkgeSB0byBiZWNvbWUgbQ0K
PiA+IA0KPiA+IEkgaGF2ZSBjcmVhdGVkIHdvcmthcm91bmRzIGZvciB0aGUgS2NvbmZpZyBmaWxl
cywgd2hpY2ggbm93IHN0b3ANCj4gPiB1c2luZw0KPiA+IGltcGx5IGFuZCBkbyBzb21ldGhpbmcg
ZWxzZSBpbiBlYWNoIGNhc2UuIEkgZG9uJ3Qga25vdyB3aGV0aGVyDQo+ID4gdGhlcmUgd2FzDQo+
ID4gYSBidWcgaW4gdGhlIGtjb25maWcgY2hhbmdlcyB0aGF0IGhhcyBsZWQgdG8gYWxsb3dpbmcN
Cj4gPiBjb25maWd1cmF0aW9ucyB0aGF0DQo+ID4gd2VyZSBub3QgbWVhbnQgdG8gYmUgbGVnYWwg
ZXZlbiB3aXRoIHRoZSBuZXcgc2VtYW50aWNzLCBvciBpZiB0aGUNCj4gPiBLY29uZmlnDQo+ID4g
ZmlsZXMgaGF2ZSBzaW1wbHkgYmVjb21lIGluY29ycmVjdCBub3cgYW5kIHRoZSB0b29sIHdvcmtz
IGFzDQo+ID4gZXhwZWN0ZWQuDQo+IA0KPiBJbiBtb3N0IGNhc2VzIGl0IGlzIHRoZSBjb2RlIHRo
YXQgaGFzIHRvIGJlIGZpeGVkLiBJdCB0eXBpY2FsbHkgZG9lczoNCj4gDQo+IAlpZiAoSVNfRU5B
QkxFRChDT05GSUdfRk9PKSkNCj4gCQlmb29faW5pdCgpOw0KPiANCj4gV2hlcmUgaXQgc2hvdWxk
IHJhdGhlciBkbzoNCj4gDQo+IAlpZiAoSVNfUkVBQ0hBQkxFKENPTkZJR19GT08pKQ0KPiAJCWZv
b19pbml0KCk7DQo+IA0KPiBBIGNvdXBsZSBvZiBzdWNoIHBhdGNoZXMgaGF2ZSBiZWVuIHByb2R1
Y2VkIGFuZCBxdWV1ZWQgaW4gdGhlaXIgDQo+IHJlc3BlY3RpdmUgdHJlZXMgYWxyZWFkeS4NCj4g
DQo+IA0KDQpZZXMgaSBoYXZlIGEgcGF0Y2ggaW4gbWx4NS1uZXQgYnJhbmNoIGNvbnZlcnRpbmcg
SVNfRU5BQkxFRCB0bw0KSVNfUkVBQ0hBQkxFIGluIG1seDUsIGkgd2lsbCBwb3N0IGl0IHRvZGF5
Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg0K
