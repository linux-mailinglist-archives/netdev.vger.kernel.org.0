Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE91955E3
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 06:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfHTEXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 00:23:39 -0400
Received: from mail-eopbgr60045.outbound.protection.outlook.com ([40.107.6.45]:50311
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbfHTEXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 00:23:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bul4igfmjGGh7wuAyMAiTvaRLh/LoEwCs4EIMcIihEa2apnxrIcUX7RNmW4//Coa//cX66+M4UY6fA6OOGHn0W9kOC+7I0Qw4hfLAGu5avYtlm/v151KIKhpuqURq/ejEt3zgKUgrbOWwzgYlNPYT6bGYmMIxr3ZT+PMZk32+KUsFurh/EqqiQdu4HZRY4Vvv08gVbY7DUzh91yizVuLi5UUJqhTHbKmFu5rzKKESw6qDA5vdii6HlWasegvYXDi62OQAoF3Nxw5fH7NaqD6Pa9Uwe0oazkWnH673tABCDaIfWwq15ND3JQHtT40Xg2NkFHOy430AA9gCpy8W838wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxOkqTygBMizpOZui7/0ned7IPloNf+hfVd487wP3HM=;
 b=H1CZOp9EmAIFVjVHkdTP0lJ9qXmK+oe2xGSFqNFRYM6WEgg6BJPUhwDRQafWYty2vS+EPgBHLybiWQ1edJpIqmIsQbPTaH6ERZa+niSl4R7LfaGY6XKipval4UMDjz9PViIbmSFOO1GEuzEoHa4bjg1zEfOUEsW3xoehytUyoEQeV2gcvU4UvKY/DeaqyW1LOCvqqcSZl27s5ETwtDynoZHdnx8r8TQzB/nxGFn0zOlz7ivkmcW3qx8tIIwUXyeyVfpV2HlUqb8MiIg/JAAZMieHElEpRr0fTmWSkUBI4p0qL663mudGIqS9a9+NJSN7ui9/3IcCWOtG/vRWMUEC0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxOkqTygBMizpOZui7/0ned7IPloNf+hfVd487wP3HM=;
 b=NaVjWrNO6SANoBIPp9/mevlhvrSi0GO2zO/0Vk+gqnlhtpzrPyA3vZfc0WvKB1mro9zYsgEKQe2+GDF3M05t447JXP7N8w0956iRq/4wspTfabEHSpWFE4xzk0USSFB/R88RvRdDWY/rS3rGUdGcowq1RXzAKg7aWBBQNhTLoUQ=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2446.eurprd04.prod.outlook.com (10.168.61.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 04:23:34 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37%11]) with mapi id 15.20.2178.018; Tue, 20 Aug
 2019 04:23:34 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Allan W . Nielsen" <allan.nielsen@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [v2, 3/4] ocelot_ace: fix action of trap
Thread-Topic: [v2, 3/4] ocelot_ace: fix action of trap
Thread-Index: AQHVUYHAMgIQ7j68xkmdFszj+Iric6b4mmEAgAADugCACtwT4A==
Date:   Tue, 20 Aug 2019 04:23:34 +0000
Message-ID: <VI1PR0401MB2237F95DABF498497A58702BF8AB0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190813025214.18601-1-yangbo.lu@nxp.com>
 <20190813025214.18601-4-yangbo.lu@nxp.com>
 <20190813061651.7gtbum4wsaw5dahg@lx-anielsen.microsemi.net>
 <20190813063011.7pwlzm7mtzlqwwkx@lx-anielsen.microsemi.net>
In-Reply-To: <20190813063011.7pwlzm7mtzlqwwkx@lx-anielsen.microsemi.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1809fcb-3b31-4f0b-50f0-08d725262a6a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2446;
x-ms-traffictypediagnostic: VI1PR0401MB2446:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0401MB2446D193D15F85AAF4F4DD0DF8AB0@VI1PR0401MB2446.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(13464003)(54534003)(199004)(189003)(229853002)(74316002)(53936002)(81166006)(102836004)(55016002)(8936002)(4326008)(81156014)(186003)(6916009)(8676002)(25786009)(5660300002)(3846002)(256004)(316002)(6116002)(54906003)(2906002)(71200400001)(71190400001)(33656002)(6306002)(9686003)(6436002)(99286004)(6246003)(305945005)(6506007)(66946007)(7736002)(66446008)(86362001)(66476007)(66556008)(64756008)(53546011)(76116006)(52536014)(966005)(478600001)(446003)(14454004)(486006)(26005)(7696005)(11346002)(476003)(66066001)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2446;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9CARQ8Xqgf5lcXR1Zfl6N4PKxEXbDKiGXOcelO6VChx5UdDWRmkVYhHboE/53v9boMGlKQ4uL3g8RzqcaLboeVsGTqTCbPKeAP2QfHK9prgHocrgN6p3LKndEKLyAeu16qrRT3gR/YKCMqv52rjQkpvdoSng7HT/fRsmYnEnpmpb0uRfwa/9aCwJGWJHJ5QtXkdR8zZrWdfodQ2HbpajB7bEc3T1LEvAq0yX2vO2P3ZU0chuhN02+5JzoYfqmqc0NV4Aumw71SKR/NK6q8gN6tODf5q7Ngid6b8FNY4Hm8AqytTWH8Wl/emAmdyfayUQnVwD4ea0HHyyyZCddysnCwj5M/DEiQ2Ze8lJuX/zeJKaMdrocXwxVYG3EnHlgt0bxbGfg7tonhcyJEMJ+g8Ybru2e87gfFbN5EJ1DRVjpVE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1809fcb-3b31-4f0b-50f0-08d725262a6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 04:23:34.5730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uw1dJCLi+w/IJOu/ZV/W1tRjck+pEQ5ZbnoxuqUhxOBwcdGdyhbj5Q2Ph1HB0uege+yXlmAyUNixRB0LJ9J6Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2446
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbmV0ZGV2LW93bmVy
QHZnZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24NCj4gQmVo
YWxmIE9mIEFsbGFuIFcgLiBOaWVsc2VuDQo+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAxMywgMjAx
OSAyOjMwIFBNDQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
Ow0KPiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+OyBN
aWNyb2NoaXAgTGludXggRHJpdmVyDQo+IFN1cHBvcnQgPFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hp
cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbdjIsIDMvNF0gb2NlbG90X2FjZTogZml4IGFjdGlvbiBv
ZiB0cmFwDQo+IA0KPiBUaGUgMDgvMTMvMjAxOSAwODoxNiwgQWxsYW4gVyAuIE5pZWxzZW4gd3Jv
dGU6DQo+ID4gVGhlIDA4LzEzLzIwMTkgMTA6NTIsIFlhbmdibyBMdSB3cm90ZToNCj4gPiA+IFRo
ZSB0cmFwIGFjdGlvbiBzaG91bGQgYmUgY29weWluZyB0aGUgZnJhbWUgdG8gQ1BVIGFuZCBkcm9w
cGluZyBpdA0KPiA+ID4gZm9yIGZvcndhcmRpbmcsIGJ1dCBjdXJyZW50IHNldHRpbmcgd2FzIGp1
c3QgY29weWluZyBmcmFtZSB0byBDUFUuDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogWWFu
Z2JvIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gQ2hhbmdlcyBmb3Ig
djI6DQo+ID4gPiAJLSBOb25lLg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbXNjYy9vY2Vsb3RfYWNlLmMgfCA2ICsrKy0tLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAz
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2FjZS5jDQo+ID4gPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2FjZS5jDQo+ID4gPiBpbmRleCA5MTI1MGYzLi41OWFk
NTkwIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3Rf
YWNlLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2FjZS5j
DQo+ID4gPiBAQCAtMzE3LDkgKzMxNyw5IEBAIHN0YXRpYyB2b2lkIGlzMl9hY3Rpb25fc2V0KHN0
cnVjdCB2Y2FwX2RhdGEgKmRhdGEsDQo+ID4gPiAgCQlicmVhazsNCj4gPiA+ICAJY2FzZSBPQ0VM
T1RfQUNMX0FDVElPTl9UUkFQOg0KPiA+ID4gIAkJVkNBUF9BQ1RfU0VUKFBPUlRfTUFTSywgMHgw
KTsNCj4gPiA+IC0JCVZDQVBfQUNUX1NFVChNQVNLX01PREUsIDB4MCk7DQo+ID4gPiAtCQlWQ0FQ
X0FDVF9TRVQoUE9MSUNFX0VOQSwgMHgwKTsNCj4gPiA+IC0JCVZDQVBfQUNUX1NFVChQT0xJQ0Vf
SURYLCAweDApOw0KPiA+ID4gKwkJVkNBUF9BQ1RfU0VUKE1BU0tfTU9ERSwgMHgxKTsNCj4gPiA+
ICsJCVZDQVBfQUNUX1NFVChQT0xJQ0VfRU5BLCAweDEpOw0KPiA+ID4gKwkJVkNBUF9BQ1RfU0VU
KFBPTElDRV9JRFgsIE9DRUxPVF9QT0xJQ0VSX0RJU0NBUkQpOw0KPiA+ID4gIAkJVkNBUF9BQ1Rf
U0VUKENQVV9RVV9OVU0sIDB4MCk7DQo+ID4gPiAgCQlWQ0FQX0FDVF9TRVQoQ1BVX0NPUFlfRU5B
LCAweDEpOw0KPiA+ID4gIAkJYnJlYWs7DQo+ID4NCj4gPiBUaGlzIGlzIHN0aWxsIHdyb25nLCBw
bGVhc2Ugc2VlIHRoZSBjb21tZW50cyBwcm92aWRlZCB0aGUgZmlyc3QgdGltZQ0KPiA+IHlvdSBz
dWJtaXR0ZWQgdGhpcy4NCj4gPg0KPiA+IC9BbGxhbg0KPiANCj4gSSBiZWxpZXZlIHRoaXMgd2ls
bCBtYWtlIGl0IHdvcmsgLSBidXQgSSBoYXZlIG5vdCB0ZXN0ZWQgaXQ6DQo+IA0KPiAgCWNhc2Ug
T0NFTE9UX0FDTF9BQ1RJT05fVFJBUDoNCj4gIAkJVkNBUF9BQ1RfU0VUKFBPUlRfTUFTSywgMHgw
KTsNCj4gLQkJVkNBUF9BQ1RfU0VUKE1BU0tfTU9ERSwgMHgwKTsNCj4gKwkJVkNBUF9BQ1RfU0VU
KE1BU0tfTU9ERSwgMHgxKTsNCj4gIAkJVkNBUF9BQ1RfU0VUKENQVV9RVV9OVU0sIDB4MCk7DQo+
ICAJCVZDQVBfQUNUX1NFVChDUFVfQ09QWV9FTkEsIDB4MSk7DQo+ICAJCWJyZWFrOw0KPiANCg0K
W1kuYi4gTHVdIEl0IG1ha2VzIHNlbnNlLiBBbmQgaXQgd29ya2VkLg0KSSBoYXZlIHNlbnQgb3V0
IHYzIHdoaWNoIG9ubHkgaW5jbHVkZWQgdGhpcyBvbmUgcGF0Y2guIEknZCBsaWtlIHRvIHNlbmQg
dGhlIG90aGVyIHBhdGNoZXMgb25jZSBGZWxpeCBkcml2ZXIgaXMgYWNjZXB0ZWQsIGJ1dCBJJ2Qg
bGlrZSB0byBjb2xsZWN0IHRoZSBzdWdnZXN0aW9ucyA6KQ0KVGhhbmtzLg0KDQpTb3JyeSwgSSBt
aXNzZWQgdG8gYWRkIGNoYW5nZSBsb2dzIGZvciB2MyBwYXRjaC4uLg0KaHR0cHM6Ly9wYXRjaHdv
cmsub3psYWJzLm9yZy9wYXRjaC8xMTQ5NzcwLw0KDQoNCj4gLS0NCj4gL0FsbGFuDQo=
