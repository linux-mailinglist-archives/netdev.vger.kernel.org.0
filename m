Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1226988100
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 19:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436774AbfHIROz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 13:14:55 -0400
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:35462
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406904AbfHIROy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 13:14:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuYkKKn3/G9Mdvfks5GU72MTEz2fHoThiFA9LnzrbfDZS2pRbIxXiBNGqJQt7l9LNtqpaMthmM2vjYBNJPSUKaAnJIRm3x+HqwgXoFGioHjMhpQ3Vi2DiD3YYEGOGSkLZXnV5IYauqb5vZ5zQaW6E/TNAZ6ajYuDBobPyajfxjFkbk3nJNONNfExo9xhnHRoK8WBJRb3/Kum3rq1OCBc2X64Yl6mmLqtMn5rweTYzDx/yhlpGuMe1gtNE1hUgidRWoElOdDSvVfLXdRwcnRD76zakUvJ5w2qlqFkLzpjs5RZK1LHhmXD6Crqs0S8Qu6PXZohHyP67QJUocZyluZN/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmvml0c9+t/9pRXzRhT2f2pueCksgH6icgKnBfFmmwQ=;
 b=HMUzbTmiZKVTkZzmKY64FMq/YdheM3YOB6uXB1ogJlFou3UwmXybW8E0u6Y2r5rge24lOMszmEdv3jjEdvQ9F7cppuvBCEjlkYrvCanEi7R/b23hZSkqI0zv1azzm5HTAh3sYnzWR9yzxXnQL0SFXPK7CZOeHLiaEexs6H1RxSEHgOtSu5yYt5gM5krhfI4+dgH6rrRd00zqQNr8f4pMtxvzAVLR4AlsfMpWjRhLObZE2wzmPL0HBnO04GAscULISJb3e0OpefoNaxdEXkVx3vAxC31Fb1tpZsoseS/F2oGbafZ+12Izue+HF+J4d8WbeaXc3qpAfiFhB9PM6OonJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmvml0c9+t/9pRXzRhT2f2pueCksgH6icgKnBfFmmwQ=;
 b=c2rqqT9Bl+kvrhmAhoYu0OGBuNLaoAbtcc5hlzme5Ku0tA9Zm7cjW07n9Rz5eQe8MJV0LpxEIqaAL+/aYxHEbUaAYKeYyteufKMZWTcHoScYyK4S6aAlCHjLRkLylKixGCoubGUpL8onwXqsFhhFH+DJbE1VVexEnESuFF2T78M=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.176.215.215) by
 AM0PR04MB6226.eurprd04.prod.outlook.com (20.179.36.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 17:14:50 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::41a7:61ce:8705:d82d]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::41a7:61ce:8705:d82d%2]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 17:14:50 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     Edward Cree <ecree@solarflare.com>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-net-drivers@solarflare.com" <linux-net-drivers@solarflare.com>
Subject: RE: [PATCH v3 net-next 0/3] net: batched receive in GRO path
Thread-Topic: [PATCH v3 net-next 0/3] net: batched receive in GRO path
Thread-Index: AQHVTF4qlNUmbVhe8E+hjl7kqsPKZ6bzEZTw
Date:   Fri, 9 Aug 2019 17:14:50 +0000
Message-ID: <AM0PR04MB4994C1A8F32FB6C9A7EE057E94D60@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
In-Reply-To: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa80b777-97cf-405e-7830-08d71ced1664
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB6226;
x-ms-traffictypediagnostic: AM0PR04MB6226:
x-microsoft-antispam-prvs: <AM0PR04MB622696BB819F0828014BDC8894D60@AM0PR04MB6226.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(13464003)(199004)(189003)(305945005)(74316002)(55016002)(6436002)(71200400001)(71190400001)(229853002)(3846002)(6116002)(33656002)(110136005)(54906003)(486006)(26005)(11346002)(76116006)(186003)(52536014)(7696005)(66476007)(66556008)(64756008)(66446008)(446003)(81166006)(81156014)(76176011)(66946007)(476003)(102836004)(53546011)(6506007)(316002)(5660300002)(8676002)(8936002)(99286004)(14454004)(2906002)(14444005)(7736002)(86362001)(256004)(25786009)(9686003)(478600001)(53936002)(4326008)(66066001)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6226;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: USQrz7+lxBV5dO1UTm8GHzhb98yp8TLydQ0NvQayLFQAXvO8PwcIdnPJIC6jbtlcpKsh+Hgo7ODQ8ZMdO/co8qDEU+YhXKp3FY+aAJ6SoRB9hmIGyEdhGBIxHjyhBSgeVAsdax5QWfvKSP/bl33TmoP0MRAYeXAREuxHyx1pjcsIKSrn0m6k61AJ7TlCfljPI4z5kHOxLZkEWwXoAaGb8FNdATv/Wpfbpr21dqBlHeVFmJGKLLnas3dKHsZ+Vf690WxOqGeV3HmYKIcCzH9efvPPnLHDcPixPHg6hw9A7PdAvb87MLpItBZrOoEUP0s6x+mTZ6MNRdSuRZXV8zzgvRTdrfjXSNoA5n4KWCbFQOVk4Ik+1jW2dM1EiUnbVjBjKkBI4aZhyEFNdbc9oDIqwAXBurpgEZmIiQwv68RXvG0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa80b777-97cf-405e-7830-08d71ced1664
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 17:14:50.3595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gfdhoUlg5cwWVHuXro0uztz1KGSn1JeFETddHQewyX2asPD6J9uOXhx17c63GXLRUyF2V4UF5LhCwvvnbTerarpwHLm0vT9ElZXrJRHhctg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6226
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBuZXRkZXYtb3duZXJAdmdlci5r
ZXJuZWwub3JnIDxuZXRkZXYtb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbg0KPiBCZWhhbGYgT2Yg
RWR3YXJkIENyZWUNCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDYsIDIwMTkgNDo1MiBQTQ0KPiBU
bzogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBDYzogbmV0ZGV2IDxuZXRk
ZXZAdmdlci5rZXJuZWwub3JnPjsgRXJpYyBEdW1hemV0DQo+IDxlcmljLmR1bWF6ZXRAZ21haWwu
Y29tPjsgbGludXgtbmV0LWRyaXZlcnNAc29sYXJmbGFyZS5jb20NCj4gU3ViamVjdDogW1BBVENI
IHYzIG5ldC1uZXh0IDAvM10gbmV0OiBiYXRjaGVkIHJlY2VpdmUgaW4gR1JPIHBhdGgNCj4gDQo+
IFRoaXMgc2VyaWVzIGxpc3RpZmllcyBwYXJ0IG9mIEdSTyBwcm9jZXNzaW5nLCBpbiBhIG1hbm5l
ciB3aGljaCBhbGxvd3MgdGhvc2UNCj4gIHBhY2tldHMgd2hpY2ggYXJlIG5vdCBHUk9lZCAoaS5l
LiBmb3Igd2hpY2ggZGV2X2dyb19yZWNlaXZlIHJldHVybnMNCj4gIEdST19OT1JNQUwpIHRvIGJl
IHBhc3NlZCBvbiB0byB0aGUgbGlzdGlmaWVkIHJlZ3VsYXIgcmVjZWl2ZSBwYXRoLg0KPiBkZXZf
Z3JvX3JlY2VpdmUoKSBpdHNlbGYgaXMgbm90IGxpc3RpZmllZCwgbm9yIHRoZSBwZXItcHJvdG9j
b2wgR1JPDQo+ICBjYWxsYmFjaywgc2luY2UgR1JPJ3MgbmVlZCB0byBob2xkIHBhY2tldHMgb24g
bGlzdHMgdW5kZXIgbmFwaS0+Z3JvX2hhc2gNCj4gIG1ha2VzIGtlZXBpbmcgdGhlIHBhY2tldHMg
b24gb3RoZXIgbGlzdHMgYXdrd2FyZCwgYW5kIHNpbmNlIHRoZSBHUk8gY29udHJvbA0KPiAgYmxv
Y2sgc3RhdGUgb2YgaGVsZCBza2JzIGNhbiByZWZlciBvbmx5IHRvIG9uZSAnbmV3JyBza2IgYXQg
YSB0aW1lLg0KPiBJbnN0ZWFkLCB3aGVuIG5hcGlfZnJhZ3NfZmluaXNoKCkgaGFuZGxlcyBhIEdS
T19OT1JNQUwgcmVzdWx0LCBzdGFzaCB0aGUgc2tiDQo+ICBvbnRvIGEgbGlzdCBpbiB0aGUgbmFw
aSBzdHJ1Y3QsIHdoaWNoIGlzIHJlY2VpdmVkIGF0IHRoZSBlbmQgb2YgdGhlIG5hcGkNCj4gIHBv
bGwgb3Igd2hlbiBpdHMgbGVuZ3RoIGV4Y2VlZHMgdGhlIChuZXcpIHN5c2N0bCBuZXQuY29yZS5n
cm9fbm9ybWFsX2JhdGNoLg0KDQpIaSBFZHdhcmQsDQoNCkknbSBwcm9iYWJseSBtaXNzaW5nIGEg
bG90IG9mIGNvbnRleHQgaGVyZSwgYnV0IGlzIHRoZXJlIGEgcmVhc29uDQp0aGlzIGNoYW5nZSB0
YXJnZXRzIG9ubHkgdGhlIG5hcGlfZ3JvX2ZyYWdzKCkgcGF0aCBhbmQgbm90IHRoZQ0KbmFwaV9n
cm9fcmVjZWl2ZSgpIG9uZT8NCg0KSSdtIHRyeWluZyB0byB1bmRlcnN0YW5kIHdoYXQgZHJpdmVy
cyB0aGF0IGRvbid0IGNhbGwgbmFwaV9ncm9fZnJhZ3MoKQ0Kc2hvdWxkIGRvIGluIG9yZGVyIHRv
IGJlbmVmaXQgZnJvbSB0aGlzIGJhdGNoaW5nIGZlYXR1cmUuDQoNClRoYW5rcywNCklvYW5hDQo=
