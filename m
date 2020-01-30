Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6142614DE23
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 16:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgA3PoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 10:44:15 -0500
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:36325
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726948AbgA3PoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 10:44:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImKYPbfBFad4tzEzj7sInmhSy5OhzNDWUNIumdqvZnUsLKZ2cRn5NjfV91jltiOUcxAZGekFaT4F7I0YwqamryWBGDTHZMT5XXQsHuBkLjRgh2pXfUA6X13xFLDHtp0KIiFXOOdvzbg57oUnMTt/3H4OwZ2tXdSm3IM37axzRfPQFfuaui3Rv9R7eCsf5ckXdh2BKeNhcKtJ86rvzArm8J8pr5W0nuj9GVzojc0Ee4nH1JqOukhOk61SB456p87Bubh7eRO8sTJYJb/f8jwATjTJ2r//vHYrmjbqqP5rix7T6K+gR9jnYWdrdsk4TDBn+C/QPvqO1nzDCQkg+DjIow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crYz/cw4KC9rVt0R7/b7DyMku/ixwoFLlGjV2wdxpD8=;
 b=exUQ8zAtt+o5rlIORp89S7OI4rMn/THn5I3sJMukIKiQGw/L3nyNxO1mmuEu0L83OOd8wN0V9Bmfiwhu/GOjEgJCglUD5ZRrSiDT5sil9w01LSEEvtDfX1mvhI5ARW/DtwKw131+YzQ5/YEvoN764LkyyjNIBUhikBQLM+gDSg/rBy081no4avoR9Im7s1zlqIAGRA+STs+u2NgAAO9F7KbOJMGBvjlWWURbwXLdeZxOIMcQPZ3SJH7IqJ3HAOcrO8ikSPV/Bd9oQNmPmpGZzr0HBiOKttlkmfVR7oV6mf5P9AOlaoTslxWEztOoekDLPoZ14+BYVlVXIFJXPmJb/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crYz/cw4KC9rVt0R7/b7DyMku/ixwoFLlGjV2wdxpD8=;
 b=rVCAN9R58f5wZZqRIsHKS7o7uaTFJRu9j2jc3I9BmHmnkxWdkY1Hn0/NgwB94tKzbX/vN/vyJZ3vl9TYZuHmaPtQYKPo/nu9DJKr3PgD5v0JJBHitbnz36gBMy9/8IoLcz1k+fbdd1AygX7VeUFAZa3+A7FOwvWP0XpigjYheOk=
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (20.178.117.153) by
 AM0PR05MB4979.eurprd05.prod.outlook.com (52.134.89.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.24; Thu, 30 Jan 2020 15:44:08 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::a556:1de2:ef6c:9192%4]) with mapi id 15.20.2665.027; Thu, 30 Jan 2020
 15:44:08 +0000
Received: from [10.80.3.21] (193.47.165.251) by AM0PR04CA0024.eurprd04.prod.outlook.com (2603:10a6:208:122::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Thu, 30 Jan 2020 15:44:06 +0000
From:   Maor Gottlieb <maorg@mellanox.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH 4/4] bonding: Implement ndo_xmit_slave_get
Thread-Topic: [RFC PATCH 4/4] bonding: Implement ndo_xmit_slave_get
Thread-Index: AQHV1EuMDA1gOXlCPECtAaJEAUUTvagA6YmAgAJ2FIA=
Date:   Thu, 30 Jan 2020 15:44:08 +0000
Message-ID: <f72ddebe-9546-823e-001d-25dfd4ffbd2b@mellanox.com>
References: <20200126132126.9981-1-maorg@mellanox.com>
 <20200126132126.9981-5-maorg@mellanox.com> <709.1580263737@famine>
In-Reply-To: <709.1580263737@famine>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM0PR04CA0024.eurprd04.prod.outlook.com
 (2603:10a6:208:122::37) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 305e1216-27a6-4a2d-1f4f-08d7a59b3e55
x-ms-traffictypediagnostic: AM0PR05MB4979:|AM0PR05MB4979:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4979D75EDA488519DC020D7CD3040@AM0PR05MB4979.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(189003)(199004)(26005)(16526019)(8936002)(53546011)(186003)(71200400001)(31696002)(956004)(478600001)(6916009)(2616005)(2906002)(31686004)(4326008)(6486002)(36756003)(52116002)(66556008)(66446008)(54906003)(316002)(64756008)(66946007)(16576012)(81156014)(5660300002)(81166006)(86362001)(66476007)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4979;H:AM0PR05MB5873.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zSTyXb5FW2oR/Y07izjR4OEshsmoUyuaa4uMb9wyg6tyucy5D1/S2+0fnQYeQZhKI40osZkLwQlT9ZVHuD+00Fny9FbtUIn4lIrn6e1KGtxP9vKSAkCIX7Z1YouwXZy2iaU1NbILZhFx0no/Rf514LXaWxWyB3CduAZRE7kF+HEZ7KqsbmMSIk5JHAxgFRfiS9Kbp6RVyvylUEW0SY1utpZxNIF0zTbptHEwoOFrwsP+OsQdrIERje1iFcCsCV5fA4GLUK8H0iByanzAGhCnRrqtOkEKMcJOP8HplnFD4GYetCm2jRAb15X/qiAtu2YwrC5Bh3hDNpHRVDHU17xN6SF7qZWDSG0eZAzmt9U6hnf4eI3RZD4dS+YRxEpHXh1IV+bHUw0VFRn4ZTmxX3aNOhSdz0P/Tql+SQ0VOgfF0HMARUnkLAP5LXdDCHDLOq1f
x-ms-exchange-antispam-messagedata: RG/0MnVTL+ZEqSRPL381F/c1ITDpRBsS/Jpmd7HnU9W64o/Myv4wJdr8LyOjiOduAW84orcIzb6kWIA7fD/F1rNylW7oWZn6HWD/SD8afnGj8rvHsbq0TdI4h8pm0gz0EFukDBNL+3o3cBP3akeBGA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <17D4478552FDFD4C9E23E696EFCF9BEF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 305e1216-27a6-4a2d-1f4f-08d7a59b3e55
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 15:44:08.2263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyd8Wp0eej5JmHnY8lDFag7eKBIaGYBLMFfJsNuaKtlvJ/5u814wCElL/5lmZecW/d1Grf9Qs5XWWie1YFlEfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4979
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzI5LzIwMjAgNDowOCBBTSwgSmF5IFZvc2J1cmdoIHdyb3RlOg0KPiBNYW9yIEdvdHRs
aWViIDxtYW9yZ0BtZWxsYW5veC5jb20+IHdyb3RlOg0KPg0KPj4gQWRkIGltcGxlbWVudGF0aW9u
IG9mIG5kb194bWl0X3NsYXZlX2dldC4NCj4+IFdoZW4gdXNlciBzZXQgdGhlIExBR19GTEFHU19I
QVNIX0FMTF9TTEFWRVMgYml0IGFuZCB0aGUgeG1pdCBzbGF2ZQ0KPj4gcmVzdWx0IGlzIGJhc2Vk
IG9uIHRoZSBoYXNoLCB0aGVuIHRoZSBzbGF2ZSB3aWxsIGJlIHNlbGVjdGVkIGZyb20gdGhlDQo+
PiBhcnJheSBvZiBhbGwgdGhlIHNsYXZlcy4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBNYW9yIEdv
dHRsaWViIDxtYW9yZ0BtZWxsYW5veC5jb20+DQo+PiAtLS0NCj4+IGRyaXZlcnMvbmV0L2JvbmRp
bmcvYm9uZF9tYWluLmMgfCA2MyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0NCj4+
IGluY2x1ZGUvbmV0L2JvbmRpbmcuaCAgICAgICAgICAgfCAgMSArDQo+PiAyIGZpbGVzIGNoYW5n
ZWQsIDYwIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMgYi9kcml2ZXJzL25ldC9ib25kaW5nL2Jv
bmRfbWFpbi5jDQo+PiBpbmRleCBhZGFiMWUzNTQ5ZmYuLmM4ZjQ0MGQxYjYyNCAxMDA2NDQNCj4+
IC0tLSBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMNCj4+ICsrKyBiL2RyaXZlcnMv
bmV0L2JvbmRpbmcvYm9uZF9tYWluLmMNCj4+IEBAIC00MDk4LDcgKzQwOTgsOCBAQCBzdGF0aWMg
dm9pZCBib25kX3NraXBfc2xhdmUoc3RydWN0IGJvbmRfdXBfc2xhdmUgKnNsYXZlcywNCj4+ICAg
Ki8NCj4+IGludCBib25kX3VwZGF0ZV9zbGF2ZV9hcnIoc3RydWN0IGJvbmRpbmcgKmJvbmQsIHN0
cnVjdCBzbGF2ZSAqc2tpcHNsYXZlKQ0KPj4gew0KPj4gLQlzdHJ1Y3QgYm9uZF91cF9zbGF2ZSAq
YWN0aXZlX3NsYXZlcywgKm9sZF9hY3RpdmVfc2xhdmVzOw0KPj4gKwlzdHJ1Y3QgYm9uZF91cF9z
bGF2ZSAqYWN0aXZlX3NsYXZlcyA9IE5VTEwsICphbGxfc2xhdmVzID0gTlVMTDsNCj4+ICsJc3Ry
dWN0IGJvbmRfdXBfc2xhdmUgKm9sZF9hY3RpdmVfc2xhdmVzLCAqb2xkX2FsbF9zbGF2ZXM7DQo+
PiAJc3RydWN0IHNsYXZlICpzbGF2ZTsNCj4+IAlzdHJ1Y3QgbGlzdF9oZWFkICppdGVyOw0KPj4g
CWludCBhZ2dfaWQgPSAwOw0KPj4gQEAgLTQxMTAsNyArNDExMSw5IEBAIGludCBib25kX3VwZGF0
ZV9zbGF2ZV9hcnIoc3RydWN0IGJvbmRpbmcgKmJvbmQsIHN0cnVjdCBzbGF2ZSAqc2tpcHNsYXZl
KQ0KPj4NCj4+IAlhY3RpdmVfc2xhdmVzID0ga3phbGxvYyhzdHJ1Y3Rfc2l6ZShhY3RpdmVfc2xh
dmVzLCBhcnIsDQo+PiAJCQkJCSAgICBib25kLT5zbGF2ZV9jbnQpLCBHRlBfS0VSTkVMKTsNCj4+
IC0JaWYgKCFhY3RpdmVfc2xhdmVzKSB7DQo+PiArCWFsbF9zbGF2ZXMgPSBremFsbG9jKHN0cnVj
dF9zaXplKGFsbF9zbGF2ZXMsIGFyciwNCj4+ICsJCQkJCSBib25kLT5zbGF2ZV9jbnQpLCBHRlBf
S0VSTkVMKTsNCj4+ICsJaWYgKCFhY3RpdmVfc2xhdmVzIHx8ICFhbGxfc2xhdmVzKSB7DQo+PiAJ
CXJldCA9IC1FTk9NRU07DQo+PiAJCXByX2VycigiRmFpbGVkIHRvIGJ1aWxkIHNsYXZlLWFycmF5
LlxuIik7DQo+PiAJCWdvdG8gb3V0Ow0KPj4gQEAgLTQxNDEsMTQgKzQxNDQsMTcgQEAgaW50IGJv
bmRfdXBkYXRlX3NsYXZlX2FycihzdHJ1Y3QgYm9uZGluZyAqYm9uZCwgc3RydWN0IHNsYXZlICpz
a2lwc2xhdmUpDQo+PiAJCQlpZiAoIWFnZyB8fCBhZ2ctPmFnZ3JlZ2F0b3JfaWRlbnRpZmllciAh
PSBhZ2dfaWQpDQo+PiAJCQkJY29udGludWU7DQo+PiAJCX0NCj4+IC0JCWlmICghYm9uZF9zbGF2
ZV9jYW5fdHgoc2xhdmUpKQ0KPj4gKwkJaWYgKCFib25kX3NsYXZlX2Nhbl90eChzbGF2ZSkpIHsN
Cj4+ICsJCQlhbGxfc2xhdmVzLT5hcnJbYWxsX3NsYXZlcy0+Y291bnQrK10gPSBzbGF2ZTsNCj4+
IAkJCWNvbnRpbnVlOw0KPj4gKwkJfQ0KPj4gCQlpZiAoc2tpcHNsYXZlID09IHNsYXZlKQ0KPj4g
CQkJY29udGludWU7DQo+Pg0KPj4gCQlzbGF2ZV9kYmcoYm9uZC0+ZGV2LCBzbGF2ZS0+ZGV2LCAi
QWRkaW5nIHNsYXZlIHRvIHR4IGhhc2ggYXJyYXlbJWRdXG4iLA0KPj4gCQkJICBhY3RpdmVfc2xh
dmVzLT5jb3VudCk7DQo+Pg0KPj4gKwkJYWxsX3NsYXZlcy0+YXJyW2FsbF9zbGF2ZXMtPmNvdW50
KytdID0gc2xhdmU7DQo+PiAJCWFjdGl2ZV9zbGF2ZXMtPmFyclthY3RpdmVfc2xhdmVzLT5jb3Vu
dCsrXSA9IHNsYXZlOw0KPj4gCX0NCj4+DQo+PiBAQCAtNDE1NiwxMCArNDE2MiwxOCBAQCBpbnQg
Ym9uZF91cGRhdGVfc2xhdmVfYXJyKHN0cnVjdCBib25kaW5nICpib25kLCBzdHJ1Y3Qgc2xhdmUg
KnNraXBzbGF2ZSkNCj4+IAlyY3VfYXNzaWduX3BvaW50ZXIoYm9uZC0+YWN0aXZlX3NsYXZlcywg
YWN0aXZlX3NsYXZlcyk7DQo+PiAJaWYgKG9sZF9hY3RpdmVfc2xhdmVzKQ0KPj4gCQlrZnJlZV9y
Y3Uob2xkX2FjdGl2ZV9zbGF2ZXMsIHJjdSk7DQo+PiArDQo+PiArCW9sZF9hbGxfc2xhdmVzID0g
cnRubF9kZXJlZmVyZW5jZShib25kLT5hbGxfc2xhdmVzKTsNCj4+ICsJcmN1X2Fzc2lnbl9wb2lu
dGVyKGJvbmQtPmFsbF9zbGF2ZXMsIGFsbF9zbGF2ZXMpOw0KPj4gKwlpZiAob2xkX2FsbF9zbGF2
ZXMpDQo+PiArCQlrZnJlZV9yY3Uob2xkX2FsbF9zbGF2ZXMsIHJjdSk7DQo+PiBvdXQ6DQo+PiAt
CWlmIChyZXQgIT0gMCAmJiBza2lwc2xhdmUpDQo+PiArCWlmIChyZXQgIT0gMCAmJiBza2lwc2xh
dmUpIHsNCj4+IAkJYm9uZF9za2lwX3NsYXZlKHJ0bmxfZGVyZWZlcmVuY2UoYm9uZC0+YWN0aXZl
X3NsYXZlcyksDQo+PiAJCQkJc2tpcHNsYXZlKTsNCj4+ICsJCWtmcmVlKGFsbF9zbGF2ZXMpOw0K
Pj4gKwkJa2ZyZWUoYWN0aXZlX3NsYXZlcyk7DQo+PiArCX0NCj4gCUknbSBzdGlsbCBnb2luZyB0
aHJvdWdoIHRoZSBwYXRjaCBzZXQsIGJ1dCBub3RpY2VkIHRoaXMgcmlnaHQNCj4gYXdheTogdGhl
IGFib3ZlIHdpbGwgbGVhayBtZW1vcnkgaWYgIXNraXBzbGF2ZSBhbmQgdGhlIGFsbG9jYXRpb24g
Zm9yDQo+IGFjdGl2ZV9zbGF2ZXMgc3VjY2VlZHMsIGJ1dCB0aGUgYWxsb2NhdGlvbiBmb3IgYWxs
X3NsYXZlcyBmYWlscy4NCj4+IAlyZXR1cm4gcmV0Ow0KPj4gfQ0KPj4gQEAgLTQyNjUsNiArNDI3
OSw0NiBAQCBzdGF0aWMgdTE2IGJvbmRfc2VsZWN0X3F1ZXVlKHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYsIHN0cnVjdCBza19idWZmICpza2IsDQo+PiAJcmV0dXJuIHR4cTsNCj4+IH0NCj4+DQo+PiAr
c3RhdGljIHN0cnVjdCBuZXRfZGV2aWNlICpib25kX3htaXRfc2xhdmVfZ2V0KHN0cnVjdCBuZXRf
ZGV2aWNlICptYXN0ZXJfZGV2LA0KPj4gKwkJCQkJICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYiwN
Cj4+ICsJCQkJCSAgICAgIGludCBmbGFncykNCj4+ICt7DQo+PiArCXN0cnVjdCBib25kaW5nICpi
b25kID0gbmV0ZGV2X3ByaXYobWFzdGVyX2Rldik7DQo+PiArCXN0cnVjdCBib25kX3VwX3NsYXZl
ICpzbGF2ZXM7DQo+PiArCXN0cnVjdCBzbGF2ZSAqc2xhdmU7DQo+PiArDQo+PiArCXN3aXRjaCAo
Qk9ORF9NT0RFKGJvbmQpKSB7DQo+PiArCWNhc2UgQk9ORF9NT0RFX1JPVU5EUk9CSU46DQo+PiAr
CQlzbGF2ZSA9IGJvbmRfeG1pdF9yb3VuZHJvYmluX3NsYXZlX2dldChib25kLCBza2IpOw0KPj4g
KwkJYnJlYWs7DQo+PiArCWNhc2UgQk9ORF9NT0RFX0FDVElWRUJBQ0tVUDoNCj4+ICsJCXNsYXZl
ID0gYm9uZF94bWl0X2FjdGl2ZWJhY2t1cF9zbGF2ZV9nZXQoYm9uZCwgc2tiKTsNCj4+ICsJCWJy
ZWFrOw0KPj4gKwljYXNlIEJPTkRfTU9ERV84MDIzQUQ6DQo+PiArCWNhc2UgQk9ORF9NT0RFX1hP
UjoNCj4+ICsJCWlmIChmbGFncyAmIExBR19GTEFHU19IQVNIX0FMTF9TTEFWRVMpDQo+PiArCQkJ
c2xhdmVzID0gcmN1X2RlcmVmZXJlbmNlKGJvbmQtPmFsbF9zbGF2ZXMpOw0KPj4gKwkJZWxzZQ0K
Pj4gKwkJCXNsYXZlcyA9IHJjdV9kZXJlZmVyZW5jZShib25kLT5hY3RpdmVfc2xhdmVzKTsNCj4+
ICsJCXNsYXZlID0gYm9uZF94bWl0XzNhZF94b3Jfc2xhdmVfZ2V0KGJvbmQsIHNrYiwgc2xhdmVz
KTsNCj4+ICsJCWJyZWFrOw0KPj4gKwljYXNlIEJPTkRfTU9ERV9CUk9BRENBU1Q6DQo+PiArCQly
ZXR1cm4gRVJSX1BUUigtRU9QTk9UU1VQUCk7DQo+PiArCWNhc2UgQk9ORF9NT0RFX0FMQjoNCj4+
ICsJCXNsYXZlID0gYm9uZF94bWl0X2FsYl9zbGF2ZV9nZXQoYm9uZCwgc2tiKTsNCj4+ICsJCWJy
ZWFrOw0KPj4gKwljYXNlIEJPTkRfTU9ERV9UTEI6DQo+PiArCQlzbGF2ZSA9IGJvbmRfeG1pdF90
bGJfc2xhdmVfZ2V0KGJvbmQsIHNrYik7DQo+PiArCQlicmVhazsNCj4+ICsJZGVmYXVsdDoNCj4+
ICsJCXJldHVybiBOVUxMOw0KPiAJSSB3b3VsZCBhcmd1ZSB0aGlzIHNob3VsZCAoYSkgcmV0dXJu
IGFuIGVycm9yIChub3QgTlVMTCksIGFuZCwNCj4gKGIpIGlkZWFsbHkgaXNzdWUgYSBuZXRkZXZf
ZXJyIGZvciB0aGlzIGltcG9zc2libGUgc2l0dWF0aW9uLCBzaW1pbGFyIHRvDQo+IHRoZSBvdGhl
ciBzd2l0Y2ggc3RhdGVtZW50cyBpbiBib25kaW5nLg0KPg0KPiAJLUoNCj4gCQ0KPj4gKwl9DQo+
PiArDQo+PiArCWlmIChzbGF2ZSkNCj4+ICsJCXJldHVybiBzbGF2ZS0+ZGV2Ow0KPj4gKwlyZXR1
cm4gTlVMTDsNCj4+ICt9DQo+PiArDQo+PiBzdGF0aWMgbmV0ZGV2X3R4X3QgX19ib25kX3N0YXJ0
X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4+IHsN
Cj4+IAlzdHJ1Y3QgYm9uZGluZyAqYm9uZCA9IG5ldGRldl9wcml2KGRldik7DQo+PiBAQCAtNDM4
Nyw2ICs0NDQxLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlX29wcyBib25kX25l
dGRldl9vcHMgPSB7DQo+PiAJLm5kb19kZWxfc2xhdmUJCT0gYm9uZF9yZWxlYXNlLA0KPj4gCS5u
ZG9fZml4X2ZlYXR1cmVzCT0gYm9uZF9maXhfZmVhdHVyZXMsDQo+PiAJLm5kb19mZWF0dXJlc19j
aGVjawk9IHBhc3N0aHJ1X2ZlYXR1cmVzX2NoZWNrLA0KPj4gKwkubmRvX3htaXRfc2xhdmVfZ2V0
CT0gYm9uZF94bWl0X3NsYXZlX2dldCwNCj4+IH07DQo+Pg0KPj4gc3RhdGljIGNvbnN0IHN0cnVj
dCBkZXZpY2VfdHlwZSBib25kX3R5cGUgPSB7DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQv
Ym9uZGluZy5oIGIvaW5jbHVkZS9uZXQvYm9uZGluZy5oDQo+PiBpbmRleCBiNzdkYWZmYzFiNTIu
LjZkZDk3MGViOWQzZiAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbmV0L2JvbmRpbmcuaA0KPj4g
KysrIGIvaW5jbHVkZS9uZXQvYm9uZGluZy5oDQo+PiBAQCAtMjAxLDYgKzIwMSw3IEBAIHN0cnVj
dCBib25kaW5nIHsNCj4+IAlzdHJ1Y3QgICBzbGF2ZSBfX3JjdSAqY3VycmVudF9hcnBfc2xhdmU7
DQo+PiAJc3RydWN0ICAgc2xhdmUgX19yY3UgKnByaW1hcnlfc2xhdmU7DQo+PiAJc3RydWN0ICAg
Ym9uZF91cF9zbGF2ZSBfX3JjdSAqYWN0aXZlX3NsYXZlczsgLyogQXJyYXkgb2YgdXNhYmxlIHNs
YXZlcyAqLw0KPj4gKwlzdHJ1Y3QgICBib25kX3VwX3NsYXZlIF9fcmN1ICphbGxfc2xhdmVzOyAv
KiBBcnJheSBvZiBhbGwgc2xhdmVzICovDQo+PiAJYm9vbCAgICAgZm9yY2VfcHJpbWFyeTsNCj4+
IAlzMzIgICAgICBzbGF2ZV9jbnQ7IC8qIG5ldmVyIGNoYW5nZSB0aGlzIHZhbHVlIG91dHNpZGUg
dGhlIGF0dGFjaC9kZXRhY2ggd3JhcHBlcnMgKi8NCj4+IAlpbnQgICAgICgqcmVjdl9wcm9iZSko
Y29uc3Qgc3RydWN0IHNrX2J1ZmYgKiwgc3RydWN0IGJvbmRpbmcgKiwNCj4+IC0tIA0KPj4gMi4x
Ny4yDQo+Pg0KPiAtLS0NCj4gCS1KYXkgVm9zYnVyZ2gsIGpheS52b3NidXJnaEBjYW5vbmljYWwu
Y29tDQoNClRoYW5rcyBKYXksDQpJIHdpbGwgYWRkcmVzcyB0aGUgY29tbWVudHMgYW5kIHN1Ym1p
dCB0aGlzIHBhdGNoIHNldCBhbG9uZyB3aXRoIHRoZSANClJvQ0UgcGF0Y2hlcy4NCg0K
