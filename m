Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF48172999
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgB0UmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:42:17 -0500
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:10739
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726758AbgB0UmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 15:42:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUtL9F27KRNoGLvGc5y1ws9F56maXKoGop2Nv5lkW+4PcZoVd2NnU++lBieCQr8rvBhFiPvkslJGCkb+DXQDMTTinYaGMF/pVaStBFH/UivWFZlbENS4yi0NSQXQN9nquwAInOGfIHy5AkccJLFebL5XlsjbvXV+32SG0tv8LBVmhT2cWp8rjiYXOeRfggicKJIdqI0ZJAveuWtNmF1oOIa8B0u4WxevdMlyPMEpvi4odaId4FJXUupnlri+MumE0sKlY41d1G2w9GcQKpxvE95W3lr5TRujE0w+3kv7wod3csGI9PSduiJqIImAYzfXQGecGZLZBLaKKhNovtyqIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcCGhaCCP15JztXLaXyPj0p59OdYRhFKy2xkM/Ntq4=;
 b=SCi7IrrHYopu8vGCcxJjCJWrnTKcFXHUlvN594vAlb66P8NGivFsmjqCO3aihDV/2Qwu9cdUxifIc1Hecgno1tlsvl0i1Z/vxgXblslUP/ng/E475d3H6xCkSvxhFEvAZO8e6Y2Yog3qBJR7ecMCdisRv8a0VBtHEHxKO9dF+v+0OJoyjk5oNvU2eBGY37CYuwc7GjJ6YQEG6d0GzJ/3phUl4vCw83pe79WdkhgphuBuj7xh5w5S6mBZW8UU/hNysWO3jhMZb70akfvsYg62kpQsfQwr7W5lAgpNIv2vVDWeqiSn9P2Jz4Nj1/pBcKdkg/8QtLB3W8/vQQ+sJ0il0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcCGhaCCP15JztXLaXyPj0p59OdYRhFKy2xkM/Ntq4=;
 b=hh3bBj3Cnd1MRAPapnh8doMUzGDNTgyOK9vY15zRlGmo60SsZ3oBTrHwhmZWyGGnknGKTmyyTlzbjZieOGHEjNImAaX46FxWzs7kdTqnRYw5AaFCYfW+WPk7zc15KuzR6nx0nVRu0dyiNLnoKJfLtnF9rh8lfcvmzftuyQsJ5ZM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4911.eurprd05.prod.outlook.com (20.177.51.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Thu, 27 Feb 2020 20:42:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Thu, 27 Feb 2020
 20:42:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
CC:     Michael Guralnik <michaelgur@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [PATCH mlx5-next 1/9] RDMA/mlx5: Move asynchronous mkey creation
 to mlx5_ib
Thread-Topic: [PATCH mlx5-next 1/9] RDMA/mlx5: Move asynchronous mkey creation
 to mlx5_ib
Thread-Index: AQHV7Wo9AdCXAh3AqUufhdprta9/PqgvcPOAgAAFcgCAAAuLgA==
Date:   Thu, 27 Feb 2020 20:42:13 +0000
Message-ID: <7b0e0f4b76330558d83163bc6c83fb6867dbdde1.camel@mellanox.com>
References: <20200227123400.97758-1-leon@kernel.org>
         <20200227123400.97758-2-leon@kernel.org>
         <952538abb4d035fb4c60db9ea136838641b741d5.camel@mellanox.com>
         <20200227200052.GR26318@mellanox.com>
In-Reply-To: <20200227200052.GR26318@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30bdd114-a91e-4280-01c9-08d7bbc5867d
x-ms-traffictypediagnostic: VI1PR05MB4911:|VI1PR05MB4911:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49118E856436FCB9E21685F2BEEB0@VI1PR05MB4911.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(366004)(346002)(396003)(376002)(189003)(199004)(71200400001)(6506007)(36756003)(2906002)(6512007)(6486002)(186003)(316002)(91956017)(66476007)(4326008)(5660300002)(66946007)(76116006)(64756008)(86362001)(8936002)(966005)(37006003)(81156014)(26005)(8676002)(2616005)(81166006)(54906003)(6862004)(66446008)(66556008)(478600001)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4911;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xUxPvjB+gLcutioXxV2JFCtyG7kZ91Ys9skdI/m2an6V0I4ZQSGFw2Axfpq+qJW4xilh9EM1ZF89D5LkYHjyp9b+Fz4q+DEE0wCcjucfZW5fBbSZ8uL0O1Q4t2X9GR8otf29PuzYGAe7fcbYJaWZ0XwH/aJ+Nms2/Pyh7wV9FIDtmKZPfRv+pPolqKvwOFI8iNpWFjQzExsyuJLP/b6wQ4Lfo11L/xgrT671X/jQdb8GTDr3KeuhiVgVN3tpxi1Pb2DCYOTfX591QE7zuiR0JgZhlqFQPXNmxCVU0MNHRPqgVBujCnPMz/M6qkWDyxVB5r0beR5B4dMVY59ZS854LZDZVheELJg/TqjxFWvjwy54IOeOaS7AWQSUKqgYmv3i1XbB+OOH1+MCxdBuDEdcMqRE4FxWwNmWbujdBt4Bl+R0AuvFdDtp9lQB6yezHEtTPvV9NbAztsW2l/ZmU5fVQ+zEYUGCQcrVsqIW4dLw9SbyeCiFyRvnaP6tGvt830sY/v5mTbGXGTVWi3unmh4aKA==
x-ms-exchange-antispam-messagedata: d/UJoFdo8Fnm1NF23uo2veoOjJ0+aKRLaic8sQlRrM5qkyKzR/y8spfcPYjrS7p8EqKba2PHXuNUJ9ELAyYT7eeoxLgOdoXyFmtuxuqHLBpV6UtZgjojS+dgZRkw7y8Zu7NnZryTohIFq7eV2URoRQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9ABF9B090A8E441AEAFEE51D6562A54@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30bdd114-a91e-4280-01c9-08d7bbc5867d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 20:42:13.4495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DCpdpbqJ3N7zAcITxhIEX8Mk2s3Xy6Zy1lxm32+olcVDYAT7v1wV0OolqtKr55bFnaxqZamQNOnNQLEqWeyfkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4911
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAyLTI3IGF0IDE2OjAwIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFRodSwgRmViIDI3LCAyMDIwIGF0IDA3OjQxOjI0UE0gKzAwMDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IE9uIFRodSwgMjAyMC0wMi0yNyBhdCAxNDozMyArMDIwMCwgTGVvbiBS
b21hbm92c2t5IHdyb3RlOg0KPiA+ID4gRnJvbTogTWljaGFlbCBHdXJhbG5payA8bWljaGFlbGd1
ckBtZWxsYW5veC5jb20+DQo+ID4gPiANCj4gPiA+IEFzIG1seDVfaWIgaXMgdGhlIG9ubHkgdXNl
ciBvZiB0aGUgbWx4NV9jb3JlX2NyZWF0ZV9ta2V5X2NiLCBtb3ZlDQo+ID4gPiB0aGUNCj4gPiA+
IGxvZ2ljIGluc2lkZSBtbHg1X2liIGFuZCBjbGVhbnVwIHRoZSBjb2RlIGluIG1seDVfY29yZS4N
Cj4gPiA+IA0KPiA+IA0KPiA+IEkgaGF2ZSBhIFdJUCBzZXJpZXMgdGhhdCBpcyBtb3ZpbmcgdGhl
IHdob2xlIG1yLmMgdG8gbWx4NV9pYi4NCj4gPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9zYWVlZC9saW51eC5naXQvbG9nLz9oPXRvcGljL21yLXJlbG9j
YXRlDQo+ID4gDQo+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIEd1cmFsbmlrIDxt
aWNoYWVsZ3VyQG1lbGxhbm94LmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IExlb24gUm9tYW5v
dnNreSA8bGVvbnJvQG1lbGxhbm94LmNvbT4NCj4gPiA+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcv
bWx4NS9tci5jICAgICAgICAgICAgICB8IDI1DQo+ID4gPiArKysrKysrKysrKysrKysrDQo+ID4g
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21yLmMgfCAyMiArKyst
LS0tLS0tLS0tLQ0KPiA+ID4gLS0tDQo+ID4gPiAgaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5o
ICAgICAgICAgICAgICAgICAgfCAgNiAtLS0tLQ0KPiA+ID4gIDMgZmlsZXMgY2hhbmdlZCwgMjQg
aW5zZXJ0aW9ucygrKSwgMjkgZGVsZXRpb25zKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tci5jDQo+ID4gPiBiL2RyaXZlcnMvaW5maW5p
YmFuZC9ody9tbHg1L21yLmMNCj4gPiA+IGluZGV4IDZmYTBhODNjMTlkZS4uZGVhMTQ0NzdhNjc2
IDEwMDY0NA0KPiA+ID4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbXIuYw0KPiA+
ID4gQEAgLTc5LDYgKzc5LDI1IEBAIHN0YXRpYyBib29sIHVzZV91bXJfbXR0X3VwZGF0ZShzdHJ1
Y3QNCj4gPiA+IG1seDVfaWJfbXINCj4gPiA+ICptciwgdTY0IHN0YXJ0LCB1NjQgbGVuZ3RoKQ0K
PiA+ID4gIAkJbGVuZ3RoICsgKHN0YXJ0ICYgKE1MWDVfQURBUFRFUl9QQUdFX1NJWkUgLSAxKSk7
DQo+ID4gPiAgfQ0KPiA+ID4gIA0KPiA+ID4gK3N0YXRpYyBpbnQgY3JlYXRlX21rZXlfY2Ioc3Ry
dWN0IG1seDVfY29yZV9kZXYgKmRldiwgc3RydWN0DQo+ID4gPiBtbHg1X2liX21yICptciwNCj4g
PiA+ICsJCQkgIHN0cnVjdCBtbHg1X2FzeW5jX2N0eCAqYXN5bmNfY3R4LCB1MzIgKmluLA0KPiA+
ID4gaW50IGlubGVuLA0KPiA+ID4gKwkJCSAgbWx4NV9hc3luY19jYmtfdCBjYWxsYmFjaykNCj4g
PiA+ICt7DQo+ID4gPiArCXZvaWQgKm1rYzsNCj4gPiA+ICsJdTgga2V5Ow0KPiA+ID4gKw0KPiA+
ID4gKwlzcGluX2xvY2tfaXJxKCZkZXYtPnByaXYubWtleV9sb2NrKTsNCj4gPiA+ICsJa2V5ID0g
ZGV2LT5wcml2Lm1rZXlfa2V5Kys7DQo+ID4gDQo+ID4geW91IGtub3cgaSBkb24ndCBsaWtlIG1s
eDVfaWIgc25pZmZpbmcgYXJvdW5kIG1seDVfY29yZS0+cHJpdiAuLiANCj4gPiANCj4gPiB0aGlz
IGlzIGhhbmRsZWQgY29ycmVjdGx5IGluIG15IHNlcmllcywgaSBjYW4gcmViYXNlIGl0IGFuZCBt
YWtlIGl0DQo+ID4gcmVhZHkgaW4gYSBjb3VwbGUgb2YgZGF5cy4uIGxldCBtZSBrbm93IGlmIHRo
aXMgd2lsbCBiZSBnb29kIGVub3VnaA0KPiA+IGZvcg0KPiA+IHlvdS4NCj4gDQo+IEhvdyBhYm91
dCBNaWNoYWVsIGp1c3QgdGFrZSB0aGUgdHdvIHJlbGV2YW50IHBhdGNoZXMgaW50byB0aGlzIHNl
cmllcw0KPiANCj4ge0lCLG5ldH0vbWx4NTogU2V0dXAgbWtleSB2YXJpYW50IGJlZm9yZSBtciBj
cmVhdGUgY29tbWFuZCBpbnZvY2F0aW9uDQo+IHtJQixuZXR9L21seDU6IEFzc2lnbiBta2V5IHZh
cmlhbnQgaW4gbWx4NV9pYiBvbmx5DQo+IA0KDQpBbHNvLCBJQi9tbHg1OiBSZXBsYWNlIHNwaW5s
b2NrIHByb3RlY3RlZCB3cml0ZSB3aXRoIGF0b21pYyB2YXINCg0KaXQgaXMgYSBnb29kIG9uZSA6
KQ0KDQo+IEFuZCB0aGlzIHBhcnRpYWxseSBtb3ZlcyB0b3dhcmQgeW91ciBzZXJpZXMuIEl0IHdp
bGwgYmUgbW9yZSB0aGFuIGENCj4gZmV3IGRheXMgdG8gcmViYXNlIGFuZCBjaGVjayBhbGwgdGhl
IHBhcnRzIG9mIHlvdXIgc2VyaWVzIEkgdGhpbmsuDQoNCk9rYXkuDQoNCi1TYWVlZC4NCg==
