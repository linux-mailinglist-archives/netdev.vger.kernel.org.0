Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8004205C46
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgFWT5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:57:07 -0400
Received: from mail-eopbgr50042.outbound.protection.outlook.com ([40.107.5.42]:21735
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733305AbgFWT5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:57:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krA/nd1jeWZLwmekW5ZInM3qqX+Rmy1DWJPJP069kLkoUYwEJX7OXntst7B5u9jqr5BEb9jEn7otLHPxYauuBOfvSB2RmuW0H6AtNjECBfoj0GBTrN511lYbE2RNo0y/hwX2M1Lvoogz7Wu6Moo6sAMO0Ezu4dhNzaKFlRrEovsZ9e+3oY/Piy0XAsqyHf08GlwJJN6V4f/+eH41TXoHBlKodZ/vXD93bikxWx7GzO/8Yf3vJrGTZdwpgCi6anoYpinXQriJqF7yuL8NN2FyPZkOZ6raV+JbFFQr5A6Le4jS6Kv6YVRHbXvZ0fdY5ML1BtbFerdUYbi8Vkt6P220sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yd1j6lkhaUmoqss90W/NH78VjTsj/JF6Bwiq5KoxEFg=;
 b=GLtzpqtBsYIyep63/sRffOIQLu3yUmrxcxtQrc648IexcWkG+RX27bNfcsXQlSOoXiN1C3V54bZzwj60t05CJGQ43WRQFavDM9hSGLFHTWkR6j2b4gN5ZMSP0gnyHS0HYTHJGFfbxtGs8ZpqrTmzxgOBckEqYBY1LDjSInluuxJ6FdDlJvJr5gf4OtDkFQLpOW+ePByaiPnbbF1NXVVvMx/SR7nySsptJX9Cx6uGXfjVGQG4v5FkzbrtbYIEU09FxczwA0Hsz0QK0iN/s8+/y6i1XtU4d78X38gWk0pSkfJTlsRUJpU7tewQO6cWrrTsu1C1FeDQyybLpoELerZxEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yd1j6lkhaUmoqss90W/NH78VjTsj/JF6Bwiq5KoxEFg=;
 b=qiKx+bTtgvESHnPYpqL2IWPj0H320MssCTLFkRk6P03QbOz2+YLtSBwQuW4PMCOJiYv00lx+8S+4H0AtT3x4yYvN3KFI3P8kEFDRURjz95GpqBEU9zaG2TwRqidJjbbw/QBLsmMmiFl8s+w2H0iw2I7nYKKd1YACCbYyfYEn2gk=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB6101.eurprd05.prod.outlook.com (2603:10a6:20b:ad::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:57:02 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:57:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jarod@redhat.com" <jarod@redhat.com>
CC:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/4] mlx5: become aware of when running as a
 bonding slave
Thread-Topic: [PATCH net-next v2 3/4] mlx5: become aware of when running as a
 bonding slave
Thread-Index: AQHWP1lNthEWdpqZ4kekL+uaCFqBK6jT9jgAgA+fMICAAxymAA==
Date:   Tue, 23 Jun 2020 19:57:02 +0000
Message-ID: <bb655544aca2305e31876c9f5230a358813d42d3.camel@mellanox.com>
References: <20200608210058.37352-1-jarod@redhat.com>
         <20200610185910.48668-1-jarod@redhat.com>
         <20200610185910.48668-4-jarod@redhat.com>
         <68f2ff6ee06bf4520485121b15c0d8c10cad60d2.camel@mellanox.com>
         <CAKfmpSeM4zf_rY_oLJJcE=vqjS43qKE8C+vAQb2NohXe3Zxxew@mail.gmail.com>
In-Reply-To: <CAKfmpSeM4zf_rY_oLJJcE=vqjS43qKE8C+vAQb2NohXe3Zxxew@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 785b8ff5-175d-496f-4269-08d817af9908
x-ms-traffictypediagnostic: AM6PR05MB6101:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6101050A2E0A4DA39F2EC62CBE940@AM6PR05MB6101.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2lOHejJWaMpserwReW+f87juXdmsvy9oj1MCxCxEHQ13Gro8/VwNyPDKAPl56qMywAZWwi1KDhZZZJ6e+LVfdCgRNtTLdntX9kXIi2ExkZm4St2GnJ3EZVoVWMuVBhtwxRmTykbt7WlZAYToK8gncX52Mj6uHoGXmz9+huT65+Kfy2y+8DoFGbUxYpC/yP9FiaCpCOYg0J8X4A8U8kPY+nNi0fU5sjEh/Srl8YU8+0HqcDiRe2OEIg1cRov1/mQkcLwYWJejabxwCNhS98JhkBXRPlhwB/gSoL1dNAk5AAhnAJn07DgXT3hQKFdu8fiulZrsfoRWPWVfpfxFy/uYtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(316002)(2616005)(4326008)(6506007)(53546011)(186003)(54906003)(6486002)(66946007)(91956017)(76116006)(66476007)(66446008)(64756008)(7416002)(36756003)(6916009)(66556008)(8676002)(8936002)(86362001)(71200400001)(83380400001)(2906002)(6512007)(26005)(5660300002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 51zkVKGyj4UmvrJ5asrDG0V+/Hu6FQtMtMWBcRHoRLew5H9JkgDAoYT6nS5modwHO4nhXjmpMHVqJUit94afU07kWcxi4EgI5p2QudEu/E9RBA8MqNfQzkbM/P8k68LnL6iNgtsXmoRrDF4xC+EMEPXGiV7msy6ogRPHQxZ3WcqIZtPJLt3lTq+Lk89tvo5MoeKp3mJQ4sVKoJRG0dtfZDCxGVur7CKr/mK1gbzVzuPbSWDm4F2SOUci7oWh22S1AyHGFaR+wJiGxvZh/5LxST9IBSicS/dmLAgU135RlilmZHwDzsSIbBfEMTE+Xa3L+30AakMg3NaGvPsRoGcWhx4YjUJCv0yslapNfQGqYcdD0bI6bSHleSsqxxpiQfA3YnP3Uf4IGjk35dgA3vIH5zFo9WN0glqyLJ+ehsAKwAAHf0UT5UjUe0zPWBGhwFZqccqU61QH3EPwsDsGFnPgXtugLCv2jahCa3VSQkqrkOo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4247437BF032224BBA26C11C4F19DC86@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 785b8ff5-175d-496f-4269-08d817af9908
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 19:57:02.6056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QbSY8tSXX0ugeTO1p4lC4Dfy0QinTcLq09cdhqrX4deOL5u4M8oq2ALabNUysVll4gBWhjwESBnQVcuC4kUvjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA2LTIxIGF0IDE2OjI1IC0wNDAwLCBKYXJvZCBXaWxzb24gd3JvdGU6DQo+
IE9uIFRodSwgSnVuIDExLCAyMDIwIGF0IDU6NTEgUE0gU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBt
ZWxsYW5veC5jb20+DQo+IHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAyMC0wNi0xMCBhdCAxNDo1OSAt
MDQwMCwgSmFyb2QgV2lsc29uIHdyb3RlOg0KPiA+ID4gSSd2ZSBiZWVuIHVuYWJsZSB0byBnZXQg
bXkgaGFuZHMgb24gc3VpdGFibGUgc3VwcG9ydGVkIGhhcmR3YXJlDQo+ID4gPiB0bw0KPiA+ID4g
ZGF0ZSwNCj4gPiA+IGJ1dCBJIGJlbGlldmUgdGhpcyBvdWdodCB0byBiZSBhbGwgdGhhdCBpcyBu
ZWVkZWQgdG8gZW5hYmxlIHRoZQ0KPiA+ID4gbWx4NQ0KPiA+ID4gZHJpdmVyIHRvIGFsc28gd29y
ayB3aXRoIGJvbmRpbmcgYWN0aXZlLWJhY2t1cCBjcnlwdG8gb2ZmbG9hZA0KPiA+ID4gcGFzc3Ro
cnUuDQo+ID4gPiANCj4gPiA+IENDOiBCb3JpcyBQaXNtZW5ueSA8Ym9yaXNwQG1lbGxhbm94LmNv
bT4NCj4gPiA+IENDOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gPiA+
IENDOiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4NCj4gPiA+IENDOiBKYXkgVm9z
YnVyZ2ggPGoudm9zYnVyZ2hAZ21haWwuY29tPg0KPiA+ID4gQ0M6IFZlYWNlc2xhdiBGYWxpY28g
PHZmYWxpY29AZ21haWwuY29tPg0KPiA+ID4gQ0M6IEFuZHkgR29zcG9kYXJlayA8YW5keUBncmV5
aG91c2UubmV0Pg0KPiA+ID4gQ0M6ICJEYXZpZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQu
bmV0Pg0KPiA+ID4gQ0M6IEplZmYgS2lyc2hlciA8amVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29t
Pg0KPiA+ID4gQ0M6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+ID4gPiBDQzog
U3RlZmZlbiBLbGFzc2VydCA8c3RlZmZlbi5rbGFzc2VydEBzZWN1bmV0LmNvbT4NCj4gPiA+IEND
OiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+ID4gPiBDQzogbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU2lnbmVkLW9mZi1ieTogSmFyb2QgV2lsc29uIDxq
YXJvZEByZWRoYXQuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2lwc2VjLmMgfCA2DQo+ID4gPiArKysrKysNCj4g
PiA+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+ID4gPiANCj4gPiA+IGRpZmYg
LS1naXQNCj4gPiA+IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
X2FjY2VsL2lwc2VjLmMNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX2FjY2VsL2lwc2VjLmMNCj4gPiA+IGluZGV4IDkyZWIzYmFkNGFjZC4uNzJhZDY2
NjRiZDczIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX2FjY2VsL2lwc2VjLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9pcHNlYy5jDQo+ID4gPiBAQCAtMjEwLDYg
KzIxMCw5IEBAIHN0YXRpYyBpbmxpbmUgaW50DQo+ID4gPiBtbHg1ZV94ZnJtX3ZhbGlkYXRlX3N0
YXRlKHN0cnVjdCB4ZnJtX3N0YXRlICp4KQ0KPiA+ID4gICAgICAgc3RydWN0IG5ldF9kZXZpY2Ug
Km5ldGRldiA9IHgtPnhzby5kZXY7DQo+ID4gPiAgICAgICBzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJp
djsNCj4gPiA+IA0KPiA+ID4gKyAgICAgaWYgKHgtPnhzby5zbGF2ZV9kZXYpDQo+ID4gPiArICAg
ICAgICAgICAgIG5ldGRldiA9IHgtPnhzby5zbGF2ZV9kZXY7DQo+ID4gPiArDQo+ID4gDQo+ID4g
RG8gd2UgcmVhbGx5IG5lZWQgdG8gcmVwZWF0IHRoaXMgcGVyIGRyaXZlciA/DQo+ID4gd2h5IG5v
dCBqdXN0IHNldHVwIHhzby5yZWFsX2RldiwgaW4geGZybSBsYXllciBvbmNlIGFuZCBmb3IgYWxs
DQo+ID4gYmVmb3JlDQo+ID4gY2FsbGluZyBkZXZpY2UgZHJpdmVycyA/DQo+ID4gDQo+ID4gRGV2
aWNlIGRyaXZlcnMgd2lsbCB1c2UgeHNvLnJlYWxfZGV2IGJsaW5kbHkuDQo+ID4gDQo+ID4gV2ls
bCBiZSB1c2VmdWwgaW4gdGhlIGZ1dHVyZSB3aGVuIHlvdSBhZGQgdmxhbiBzdXBwb3J0LCBldGMu
Lg0KPiANCj4gQXBvbG9naWVzLCBJIGRpZG4ndCBjYXRjaCB5b3VyIHJlcGx5IHVudGlsIGp1c3Qg
cmVjZW50bHkuIFllYWgsIHRoYXQNCj4gc291bmRzIGxpa2UgYSBiZXR0ZXIgYXBwcm9hY2gsIGlm
IEkgY2FuIHdvcmsgaXQgb3V0IGNsZWFubHkuIFdlIGp1c3QNCj4gaW5pdCB4c28ucmVhbF9kZXYg
dG8gdGhlIHNhbWUgdGhpbmcgYXMgeHNvLmRldiwgdGhlbiBvdmVyd3JpdGUgaXQgaW4NCj4gdGhl
IHVwcGVyIGxheWVyIGRyaXZlcnMgKGJvbmRpbmcsIHZsYW4sIGV0YyksIHdoaWxlIGRldmljZSBk
cml2ZXJzDQo+IGp1c3QgYWx3YXlzIHVzZSB4c28ucmVhbF9kZXYsIGlmIEknbSB1bmRlcnN0YW5k
aW5nIHlvdXIgc3VnZ2VzdGlvbi4NCj4gSSdsbCBzZWUgd2hhdCBJIGNhbiBjb21lIHVwIHdpdGgu
DQo+IA0KPiANCg0KWWVzLCBleGFjdGx5IHdoYXQgaSBtZWFudCwgVGhhbmtzICENCg0KDQoNCg0K
