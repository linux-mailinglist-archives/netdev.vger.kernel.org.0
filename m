Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A8C49E32
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfFRKYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:24:54 -0400
Received: from mail-eopbgr150080.outbound.protection.outlook.com ([40.107.15.80]:39951
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbfFRKYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 06:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dv++fUQ/Dp5IFclZMTRaTiQva/Ub/IU7oHHIZxLlpjo=;
 b=C9jcB8k5NGzZTWJcxAU7ZM6puH6aDlY3yY2T6bgH8+/Y58LyOC8UrsHf0uc1onXX+lEfPJl8ZJgtWDU9+gzyxTZTDipTGLEA/vT72SoNhE+/w/ctLuZLOoJGMStkuHswCwNjyu4aViNJuh7Lb60BWfCewZMbgyLT1EfaOvlCM5Y=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4132.eurprd05.prod.outlook.com (52.134.126.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 18 Jun 2019 10:24:49 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 10:24:49 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: RE: [PATCH mlx5-next 12/15] net/mlx5: E-Switch, Enable vport metadata
 matching if firmware supports it
Thread-Topic: [PATCH mlx5-next 12/15] net/mlx5: E-Switch, Enable vport
 metadata matching if firmware supports it
Thread-Index: AQHVJUI8ZTP0CV1vxEetV/c8jOwcF6ahNWfg
Date:   Tue, 18 Jun 2019 10:24:49 +0000
Message-ID: <AM0PR05MB4866AA7738F3DE1D3CF47FFBD1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-13-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-13-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05ad5d18-dbe2-4ca5-c442-08d6f3d731c1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4132;
x-ms-traffictypediagnostic: AM0PR05MB4132:
x-microsoft-antispam-prvs: <AM0PR05MB413237DE7F4B2250DBCC4AA1D1EA0@AM0PR05MB4132.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39860400002)(346002)(396003)(136003)(13464003)(199004)(189003)(6506007)(26005)(52536014)(33656002)(229853002)(102836004)(66066001)(76176011)(71200400001)(71190400001)(68736007)(54906003)(186003)(7696005)(256004)(99286004)(78486014)(6636002)(55236004)(53546011)(66476007)(25786009)(64756008)(3846002)(66946007)(73956011)(316002)(66556008)(110136005)(66446008)(450100002)(14454004)(76116006)(6116002)(11346002)(4326008)(9686003)(53936002)(478600001)(107886003)(74316002)(8676002)(8936002)(55016002)(86362001)(81156014)(81166006)(486006)(6436002)(9456002)(476003)(7736002)(6246003)(5660300002)(2906002)(446003)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4132;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ak1xyrs8a26zcUGSH/KWXROSvGUR8R4PIGrbPkK4Sjw8t10k0v8pdh0frgto7wQTNopSpZZTdMO1fZa76kFePBnwvSlxPk5LdvpGBjF4tMD2PJpju86pCRWnYcmiZoYM0te+Bjlg1HDa/eeTA9jOqDRa4AVYC2I9fPl5Mp4a7ayFzA/ydjosq5h+5/62w67nhqbJRQc/3pOQTt9QqT8CSmB/YDGsq5hAhJM+nTE+bMOdgvO3X+vm6A/MoVmgZv7w4P/K+YPVxv7sYLSQC3oBR7ZVzL3JiTUGKYBk6uuVn96BjT22KMPf669xQZ8P/zceoiiJPoHflL/uNBlE6wwR+oOJ5oDqTd2kOYYiUn+5/i7J0nQeqEQ/Cu2ewbBKtaNqSSWElHSTlJfyhHUexu0if2ZiVi8LElxA36aUGSJDJW0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ad5d18-dbe2-4ca5-c442-08d6f3d731c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 10:24:49.5785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtcmRtYS1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LXJkbWEtDQo+IG93bmVyQHZnZXIua2VybmVsLm9yZz4g
T24gQmVoYWxmIE9mIFNhZWVkIE1haGFtZWVkDQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMTgsIDIw
MTkgMTI6NTQgQU0NCj4gVG86IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPjsg
TGVvbiBSb21hbm92c2t5DQo+IDxsZW9ucm9AbWVsbGFub3guY29tPg0KPiBDYzogbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgbGludXgtcmRtYUB2Z2VyLmtlcm5lbC5vcmc7IEppYW5ibyBMaXUNCj4g
PGppYW5ib2xAbWVsbGFub3guY29tPjsgUm9pIERheWFuIDxyb2lkQG1lbGxhbm94LmNvbT47IE1h
cmsgQmxvY2gNCj4gPG1hcmtiQG1lbGxhbm94LmNvbT4NCj4gU3ViamVjdDogW1BBVENIIG1seDUt
bmV4dCAxMi8xNV0gbmV0L21seDU6IEUtU3dpdGNoLCBFbmFibGUgdnBvcnQgbWV0YWRhdGENCj4g
bWF0Y2hpbmcgaWYgZmlybXdhcmUgc3VwcG9ydHMgaXQNCj4gDQo+IEZyb206IEppYW5ibyBMaXUg
PGppYW5ib2xAbWVsbGFub3guY29tPg0KPiANCj4gQXMgdGhlIGluZ3Jlc3MgQUNMIHJ1bGVzIHNh
dmUgdmhjYSBpZCBhbmQgdnBvcnQgbnVtYmVyIHRvIHBhY2tldCdzIG1ldGFkYXRhDQo+IFJFR19D
XzAsIGFuZCB0aGUgbWV0YWRhdGEgbWF0Y2hpbmcgZm9yIHRoZSBydWxlcyBpbiBib3RoIGZhc3Qg
cGF0aCBhbmQgc2xvdw0KPiBwYXRoIGFyZSBhbGwgYWRkZWQsIGVuYWJsZSB0aGlzIGZlYXR1cmUg
aWYgc3VwcG9ydGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSmlhbmJvIExpdSA8amlhbmJvbEBt
ZWxsYW5veC5jb20+DQo+IFJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29t
Pg0KPiBSZXZpZXdlZC1ieTogTWFyayBCbG9jaCA8bWFya2JAbWVsbGFub3guY29tPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gLS0tDQo+
ICAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYyAgfCAx
MyArKysrKysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
c3dpdGNoX29mZmxvYWRzLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jDQo+IGluZGV4IDM2MzUxN2UyOWQ0Yy4uNTEyNDIxOWEz
MWRlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZXN3aXRjaF9vZmZsb2Fkcy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCj4gQEAgLTE5MDYsMTIgKzE5MDYsMjUg
QEAgc3RhdGljIGludA0KPiBlc3dfdnBvcnRfaW5ncmVzc19jb21tb25fY29uZmlnKHN0cnVjdCBt
bHg1X2Vzd2l0Y2ggKmVzdywNCj4gIAlyZXR1cm4gZXJyOw0KPiAgfQ0KPiANCj4gK3N0YXRpYyBp
bnQgZXN3X2NoZWNrX3Zwb3J0X21hdGNoX21ldGFkYXRhX3N1cHBvcnRlZChzdHJ1Y3QgbWx4NV9l
c3dpdGNoDQo+ICsqZXN3KSB7DQo+ICsJcmV0dXJuIChNTFg1X0NBUF9FU1dfRkxPV1RBQkxFKGVz
dy0+ZGV2LA0KPiBmZGJfdG9fdnBvcnRfcmVnX2NfaWQpICYNCj4gKwkJTUxYNV9GREJfVE9fVlBP
UlRfUkVHX0NfMCkgJiYNCj4gKwkgICAgICAgTUxYNV9DQVBfRVNXX0ZMT1dUQUJMRShlc3ctPmRl
diwgZmxvd19zb3VyY2UpICYmDQo+ICsJICAgICAgIE1MWDVfQ0FQX0VTVyhlc3ctPmRldiwgZXN3
X3VwbGlua19pbmdyZXNzX2FjbCkgJiYNCj4gKwkgICAgICAgIW1seDVfY29yZV9pc19lY3BmX2Vz
d19tYW5hZ2VyKGVzdy0+ZGV2KSAmJg0KPiArCSAgICAgICAhbWx4NV9lY3BmX3Zwb3J0X2V4aXN0
cyhlc3ctPmRldik7DQo+ICt9DQo+ICsNCnN0cnVjdCBtbHg1X2Vzd2l0Y2gqIHNob3VsZCBiZSBj
b25zdC4NCnJldHVybiB0eXBlIHNob3VsZCBiZSBib29sLg0K
