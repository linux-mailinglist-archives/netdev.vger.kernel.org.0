Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7891AD4FC
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 05:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgDQDz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 23:55:27 -0400
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:34286
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgDQDz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 23:55:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vx5XstHVv5dz7H4cKq4ujEMacofNpgTOxaFlbtqUCE8+uCNngxvrPBmq73Gg0CxjGGB6UoulPAoWrLxCZZvxpMCNo4uilW5Wd/RK4TswZhG5/GwW/Iy7HPDXhWeWGlwRB1vTSDGoioOOSVKwG05KfAA2YAbxGENBR+dTYxA3JZgbMlT1+pH+QotogptBCbQJhzIwzXGkRcWmIXeVAWnMzXX4SpjEEGWmhDf+QnNEIQ9hEL6bQ935prXdoSmqYWNaYrRRmp7yYRYSF1fA+jvAlobjKZLrU9j/my/lBnvba7c6z8bIs8lC0ghAGYniHIk1J+d/r42sSLaGcvgO1jr1Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiDkRUk4FjDhGGRxAnNR/aU0lHYxHhapk0qw6yXAOmE=;
 b=S57JRPNRHSnNhKtWDP6cGj04PKejY9lqgyRfxFa3JJ/iNAaHwyvqbHDJPy6QT7aRvUVyjrJWNHlf+UeyFtHGYSi5dJeB9iS0GG61mdXm/gsmxkJAawTNsZBqCqX3EHkj/q83VEpG5op0nxy9xs23R5qPXtHQL+PYKi+Ldc0f/iC+2tNicWb1RGwhBjdiJFjeD/3scN7ICCJlDV+V3pVxoVuXG83tt8LHmdDCULEys8Gk+cdDsZEsUK53axB5o6QdJs2mNioaD9hgBlUTXiPjC6oP7EF/Ld6/gx8sIudL5kli1uHszE57gUak2H3zYsxjhy476dhVKmNlS+qIDn+elQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiDkRUk4FjDhGGRxAnNR/aU0lHYxHhapk0qw6yXAOmE=;
 b=FmfqIcM/hqczoud0tTIBEeKJrfMFOUcy+Plu9zvdHUk8uIGKhUOELdhrOi85PmnqcxiYebTf9wQkyqsA6iqQgNgWLc/P8ZzQqTgIQnCc4mW708aCHaCu7hok7a28Ixrvurh2GtHl5qUi61GmslJIFEM8j12Z7rtUnK5XvMQmdd8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5967.eurprd05.prod.outlook.com (2603:10a6:803:e5::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Fri, 17 Apr
 2020 03:55:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 03:55:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "willemb@google.com" <willemb@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net-next] net/mlx4_en: avoid indirect call in TX
 completion
Thread-Topic: [PATCH net-next] net/mlx4_en: avoid indirect call in TX
 completion
Thread-Index: AQHWFBIDv40ebB4u9EyyQ97YK5VRKah8r+GA
Date:   Fri, 17 Apr 2020 03:55:22 +0000
Message-ID: <761fa4422e5576b087c8e6d26a9046126f5dff2f.camel@mellanox.com>
References: <20200415164652.68245-1-edumazet@google.com>
In-Reply-To: <20200415164652.68245-1-edumazet@google.com>
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
x-ms-office365-filtering-correlation-id: 6cdfdfe5-64dd-46b2-3b34-08d7e28327a2
x-ms-traffictypediagnostic: VI1PR05MB5967:|VI1PR05MB5967:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB59675AA85F12E0782C58492FBED90@VI1PR05MB5967.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(66476007)(66556008)(186003)(66946007)(6506007)(478600001)(91956017)(76116006)(64756008)(66446008)(5660300002)(26005)(86362001)(36756003)(2616005)(81156014)(8936002)(8676002)(107886003)(71200400001)(4326008)(6512007)(2906002)(110136005)(54906003)(6486002)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vZw9lW6ebe5hZYW3tFGM7/sWTWv5Wskow2zlAkKoR/odgQxfQm/4yg9oyOvo78S6ttsAwu9vqQQ8qZjIWWh16EahhCc/v4e4MhJZYEXwB6pg8ntBO/GquGJbsAcoeMV5EiVB9JZwnqHEwvYq3JMj24b6GPSMkzi2HqnBtUHQjin8hLXnTSOH+lZHBlYt7X8Jq3B7CALuA9bJuOQZKJSb3nZ7wTfTYygAPqYWF0uhvGWfnkItt+gVXDYtGfzxzOD8tVw7Kivcy8DEhXBZir4COGrkSjHdF/POAOvqK/xpzN76XGdFDorS2xrq7y1qL7dPXVkkyg5exOeTXawG3Mt30K6w39D937owAp6G9iquIZ2dct/1ncObXugvBA0O1uiMUZMNO4BuDW/U0HmJppA0gSCFjZePcrSinucwyXDfKFEloM+H59P5DVaeaWraeGv4
x-ms-exchange-antispam-messagedata: cBo/55E+/vACJbi8XlbxCjtMo/hst57Lo7iPvd5XTgMN2Tw1X0iZKRAtDMzbhGnIw0UnsantrzG/qUayzE0nAYs8jTzSuXtlMCB9kuOsIV+3zO72H325VfUwqJxT3WRiKiw9IBn2Xxfxu9OiL9QsoA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB01D2509A9FA14A966EB338D0C36BE5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cdfdfe5-64dd-46b2-3b34-08d7e28327a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 03:55:22.7932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6lRUXWpmfp7T8ya6PRoKRS/qaECjDXtHArrZJSBfclQL+tAhUxMwc+jIoV4nesrvkKyqhLnGVG0W9yHYXnQjKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5967
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTE1IGF0IDA5OjQ2IC0wNzAwLCBFcmljIER1bWF6ZXQgd3JvdGU6DQo+
IENvbW1pdCA5ZWNjMmQ4NjE3MWEgKCJuZXQvbWx4NF9lbjogYWRkIHhkcCBmb3J3YXJkaW5nIGFu
ZCBkYXRhIHdyaXRlDQo+IHN1cHBvcnQiKQ0KPiBicm91Z2h0IGFub3RoZXIgaW5kaXJlY3QgY2Fs
bCBpbiBmYXN0IHBhdGguDQo+IA0KPiBVc2UgSU5ESVJFQ1RfQ0FMTF8yKCkgaGVscGVyIHRvIGF2
b2lkIHRoZSBjb3N0IG9mIHRoZSBpbmRpcmVjdCBjYWxsDQo+IHdoZW4vaWYgQ09ORklHX1JFVFBP
TElORT15DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2ds
ZS5jb20+DQo+IENjOiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQo+IENjOiBX
aWxsZW0gZGUgQnJ1aWpuIDx3aWxsZW1iQGdvb2dsZS5jb20+DQo+IC0tLQ0KDQpIaSBFcmljLCBJ
IGJlbGlldmUgbmV0LW5leHQgaXMgc3RpbGwgY2xvc2VkLg0KDQpCdXQgRldJVywgDQoNClJldmll
d2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCg0KDQo+ICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX3R4LmMgfCAxNCArKysrKysrKysrKysr
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX3R4
LmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX3R4LmMNCj4gaW5k
ZXgNCj4gNGQ1Y2EzMDJjMDY3MTI2Yjg2MjdjYjQ4MDk0ODViNDVjMTBlMjQ2MC4uYTMwZWRiNDM2
ZjRhZjExNTI2ZTA0YzA5NjIzDQo+IDg0MDI4OGViZTRhMjkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fdHguYw0KPiArKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX3R4LmMNCj4gQEAgLTQzLDYgKzQzLDcgQEANCj4g
ICNpbmNsdWRlIDxsaW51eC9pcC5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L2lwdjYuaD4NCj4gICNp
bmNsdWRlIDxsaW51eC9tb2R1bGVwYXJhbS5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L2luZGlyZWN0
X2NhbGxfd3JhcHBlci5oPg0KPiAgDQo+ICAjaW5jbHVkZSAibWx4NF9lbi5oIg0KPiAgDQo+IEBA
IC0yNjEsNiArMjYyLDEwIEBAIHN0YXRpYyB2b2lkIG1seDRfZW5fc3RhbXBfd3FlKHN0cnVjdA0K
PiBtbHg0X2VuX3ByaXYgKnByaXYsDQo+ICAJfQ0KPiAgfQ0KPiAgDQo+ICtJTkRJUkVDVF9DQUxM
QUJMRV9ERUNMQVJFKHUzMiBtbHg0X2VuX2ZyZWVfdHhfZGVzYyhzdHJ1Y3QNCj4gbWx4NF9lbl9w
cml2ICpwcml2LA0KPiArCQkJCQkJICAgc3RydWN0DQo+IG1seDRfZW5fdHhfcmluZyAqcmluZywN
Cj4gKwkJCQkJCSAgIGludCBpbmRleCwgdTY0DQo+IHRpbWVzdGFtcCwNCj4gKwkJCQkJCSAgIGlu
dCBuYXBpX21vZGUpKTsNCj4gIA0KPiAgdTMyIG1seDRfZW5fZnJlZV90eF9kZXNjKHN0cnVjdCBt
bHg0X2VuX3ByaXYgKnByaXYsDQo+ICAJCQkgc3RydWN0IG1seDRfZW5fdHhfcmluZyAqcmluZywN
Cj4gQEAgLTMyOSw2ICszMzQsMTEgQEAgdTMyIG1seDRfZW5fZnJlZV90eF9kZXNjKHN0cnVjdCBt
bHg0X2VuX3ByaXYNCj4gKnByaXYsDQo+ICAJcmV0dXJuIHR4X2luZm8tPm5yX3R4YmI7DQo+ICB9
DQo+ICANCj4gK0lORElSRUNUX0NBTExBQkxFX0RFQ0xBUkUodTMyIG1seDRfZW5fcmVjeWNsZV90
eF9kZXNjKHN0cnVjdA0KPiBtbHg0X2VuX3ByaXYgKnByaXYsDQo+ICsJCQkJCQkgICAgICBzdHJ1
Y3QNCj4gbWx4NF9lbl90eF9yaW5nICpyaW5nLA0KPiArCQkJCQkJICAgICAgaW50IGluZGV4LCB1
NjQNCj4gdGltZXN0YW1wLA0KPiArCQkJCQkJICAgICAgaW50IG5hcGlfbW9kZSkpOw0KPiArDQo+
ICB1MzIgbWx4NF9lbl9yZWN5Y2xlX3R4X2Rlc2Moc3RydWN0IG1seDRfZW5fcHJpdiAqcHJpdiwN
Cj4gIAkJCSAgICBzdHJ1Y3QgbWx4NF9lbl90eF9yaW5nICpyaW5nLA0KPiAgCQkJICAgIGludCBp
bmRleCwgdTY0IHRpbWVzdGFtcCwNCj4gQEAgLTQ0OSw3ICs0NTksOSBAQCBib29sIG1seDRfZW5f
cHJvY2Vzc190eF9jcShzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqZGV2LA0KPiAgCQkJCXRpbWVzdGFt
cCA9IG1seDRfZW5fZ2V0X2NxZV90cyhjcWUpOw0KPiAgDQo+ICAJCQkvKiBmcmVlIG5leHQgZGVz
Y3JpcHRvciAqLw0KPiAtCQkJbGFzdF9ucl90eGJiID0gcmluZy0+ZnJlZV90eF9kZXNjKA0KPiAr
CQkJbGFzdF9ucl90eGJiID0gSU5ESVJFQ1RfQ0FMTF8yKHJpbmctDQo+ID5mcmVlX3R4X2Rlc2Ms
DQo+ICsJCQkJCQkgICAgICAgbWx4NF9lbl9mcmVlX3R4Xw0KPiBkZXNjLA0KPiArCQkJCQkJICAg
ICAgIG1seDRfZW5fcmVjeWNsZV8NCj4gdHhfZGVzYywNCj4gIAkJCQkJcHJpdiwgcmluZywgcmlu
Z19pbmRleCwNCj4gIAkJCQkJdGltZXN0YW1wLCBuYXBpX2J1ZGdldCk7DQo+ICANCg==
