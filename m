Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E13A65246
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 09:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfGKHMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 03:12:50 -0400
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:29262
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728104AbfGKHMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 03:12:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvHmKEP7w/WCc4y4RgwZCRFzHcvTYmItVDHTLwZaV2S64jmyUZdPPlmJzrjvC6IrVNzAsEzL3sPv7f2WRv9TIh7gtAm8gm2VyKj04xERT7koX+Rq3KWABv5/8BfnEmVTufunuGyD81qZIkKLQ3Xsml61/C+jr6Frut6Lyg09MSpfr+Czkdt8GfVnYYDavs00py29U7j+pKOO/0CcNGjgopPqHcQdxeN3fen29A6Fr8voj/2Km5+59Dxn8G+lThLzS6yIDvTjH/eA13RKybK9+1uR4/jj3yrAMKZ4xzoz1fAY/D+8MHhEw1mVZqMap2dpj9Xxl0equDwrE9k9qZ0dxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YasObF89JerDgH2i5dvOlCGop63pvcLANgM1YG/EdTU=;
 b=RypKbsk0JWVw6WXLerSJP7iHoumoliGwxW4IVKg4ruFzQWFARLVFfw5JpMw+pb0lDoZ58EHWgyQxz8POKNia5QmyOwHVlAAilbpGSSoFZFoVtzcXVsd2hk2QvccTccsCw/11oXv9u1gazwhNR9OHOIvf6z+PkENOH7pqL4PlZnv5S6/uXFgfW36Coj9iakoavTUZ6B4OvvvaRzcVnsyJcMeQf/IZ9ntI+6c0oBMSotsy8gVDeTGRcjY6beoZ3LugGXcgXebZm8BuK2S0pEMB7qjJNbooOsY7xjrElHLdM6nFGdry3FZM10YdlkTc9Gy1xtZGBUL8zGGeNEWLUbb4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YasObF89JerDgH2i5dvOlCGop63pvcLANgM1YG/EdTU=;
 b=Ko/xKvQ6Fp5pwlnvyXeE4DI448GZ+JMQa7K2Ad2ReRXujemVxQUqkxjZCJ8oazPt7LprgrxGnF8/K+vh30Zknn7yMZ+gMuQoj6hHZO0UyRL3bM1VM+2dyT2x7ipZcLghpixJN9H0VWmUJzTJsjuk8+KRoNldHj6GJY6ih2Ho2sg=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3489.eurprd05.prod.outlook.com (10.170.126.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 07:12:44 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7%4]) with mapi id 15.20.2052.020; Thu, 11 Jul 2019
 07:12:44 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "aconole@redhat.com" <aconole@redhat.com>,
        "wangzhike@jd.com" <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        "john.hurley@netronome.com" <john.hurley@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jpettit@ovn.org" <jpettit@ovn.org>
Subject: Re: [PATCH net-next v6 0/4] net/sched: Introduce tc connection
 tracking
Thread-Topic: [PATCH net-next v6 0/4] net/sched: Introduce tc connection
 tracking
Thread-Index: AQHVNihZ3WVFDU3cD0iXRvHShzrKDqbCqJ4AgAJbH4A=
Date:   Thu, 11 Jul 2019 07:12:44 +0000
Message-ID: <67d3c788-c79b-d923-3bc5-9e1ee067e324@mellanox.com>
References: <1562657451-20819-1-git-send-email-paulb@mellanox.com>
 <20190709.121402.1804664264408465946.davem@davemloft.net>
In-Reply-To: <20190709.121402.1804664264408465946.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0076.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::17) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7877b5fd-f8d3-4805-fe70-08d705cf2b74
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3489;
x-ms-traffictypediagnostic: AM4PR05MB3489:
x-microsoft-antispam-prvs: <AM4PR05MB3489BE53865EFFB08492D002CFF30@AM4PR05MB3489.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(189003)(199004)(66066001)(102836004)(71190400001)(71200400001)(186003)(53936002)(6512007)(76176011)(36756003)(229853002)(8676002)(256004)(6436002)(14454004)(52116002)(25786009)(99286004)(81156014)(6486002)(81166006)(31686004)(26005)(6246003)(305945005)(2906002)(2616005)(476003)(5660300002)(86362001)(31696002)(68736007)(11346002)(7736002)(54906003)(8936002)(316002)(3846002)(6116002)(53546011)(6506007)(386003)(6916009)(478600001)(4744005)(446003)(486006)(4326008)(66476007)(66946007)(66446008)(64756008)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3489;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Rta9xXsTHp5dzVsDxpsjI6C4OQn+CM+dDzWKqkswcZAUoW6sztkR7f6MaTyzRYNVIn/j4KXczDKalAp1GFuAzMLtsKD/4HcGt/IJQNCPQzgjPefCiTuFjYtekLg9EajKzKHZInqqk4nCa8amBeu1Dz5h1f0Yg6VfBYnqouVZxbtj153Vs6NB3L6bRsCuHyGnivBIioFwe1zq3U0aCUk+41SbS4WvuM/LIQ20iz75QtTsfVJBuFZrW4bsWu1Vgy+L72FPYrygdC/Z8Ovm2tgQt55Pkmdw1EXomxASUnO40ZsNbigK1LwtVz0Vdew0ZCeP2K2H8SGkhdxEzftn8KyXizoodL4TrFi5ajqs+W0SXvLvP74QhIpZx5zcYg9SlOXtBy3pCCQNFpT/10IQrCWnGnn2T2XZAKaAUtfTudt7F9Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28BD6AD7350BD94D98D38EAAA59653D0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7877b5fd-f8d3-4805-fe70-08d705cf2b74
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 07:12:44.4509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3489
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA3LzkvMjAxOSAxMDoxNCBQTSwgRGF2aWQgTWlsbGVyIHdyb3RlOg0KPiBGcm9tOiBQYXVs
IEJsYWtleSA8cGF1bGJAbWVsbGFub3guY29tPg0KPiBEYXRlOiBUdWUsICA5IEp1bCAyMDE5IDEw
OjMwOjQ3ICswMzAwDQo+DQo+PiBUaGlzIHBhdGNoIHNlcmllcyBhZGQgY29ubmVjdGlvbiB0cmFj
a2luZyBjYXBhYmlsaXRpZXMgaW4gdGMgc3cgZGF0YXBhdGguDQo+PiBJdCBkb2VzIHNvIHZpYSBh
IG5ldyB0YyBhY3Rpb24sIGNhbGxlZCBhY3RfY3QsIGFuZCBuZXcgdGMgZmxvd2VyIGNsYXNzaWZp
ZXIgbWF0Y2hpbmcNCj4+IG9uIGNvbm50cmFjayBzdGF0ZSwgbWFyayBhbmQgbGFiZWwuDQo+ICAg
Li4uDQo+DQo+IE9rLCBJIGFwcGxpZWQgdGhpcywgYnV0IHR3byB0aGluZ3M6DQo+DQo+IDEpIFlv
dSBvd2UgQ29uZyBXYW5nIGFuIGV4cGxhbmF0aW9uLCBhIHJlYWwgZGV0YWlsZWQgb25lLCBhYm91
dCB0aGUgTDINCj4gICAgIHZzIEwzIGRlc2lnbiBvZiB0aGlzIGZlYXR1cmUuICBJIGRpZCBub3Qg
c2VlIHlvdSBhZGRyZXNzIGhpcyBmZWVkYmFjaywNCj4gICAgIGJ1dCBpZiB5b3UgZGlkIEkgYXBv
bG9naXplLg0KPg0KPiAyKSBCZWNhdXNlIHRoZSBNUExTIGNoYW5nZXMgd2VudCBpbiBmaXJzdCwg
VENBX0lEX0NUIGVuZGVkIHVwIGluIGENCj4gICAgIGRpZmZlcmVudCBzcG90IGluIHRoZSBlbnVt
ZXJhdGlvbiBhbmQgdGhlcmVmb3JlIHRoZSB2YWx1ZSBpcw0KPiAgICAgZGlmZmVyZW50Lg0KPg0K
PiBUaGFua3MuDQoNCg0KDQpUaGFua3MhDQoNClJlIDEsIEkgcHJvdmlkZWQgb25lIGluICJSZTog
W1BBVENIIG5ldC1uZXh0IHYyIDAvNF0gbmV0L3NjaGVkOiANCkludHJvZHVjZSB0YyBjb25uZWN0
aW9uIHRyYWNraW5nIiwgaG9wZSB0aGF0J3MgZW5vdWdoLg0KDQo=
