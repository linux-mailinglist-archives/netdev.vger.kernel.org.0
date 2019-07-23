Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5292B721FD
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392302AbfGWWJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:09:37 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:13123
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731838AbfGWWJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 18:09:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Knxp4e2U65DX+PoIORIoEGrQ4cObKgNSwZFswRfLRJwgNL+Ryy2ozONSFK9N8BdwkBNQedzFM6R7/Jz4yfIM4kuO41JZFAWsmPDnxe1rtylxoI8yOEJB9MZ0dlbt/1YcKw8Kub3OI+1kTyiD/qy134wE8yzstHUe6Xk7Zp8me1BqHDR597W4hCMurkcnoEHB86AV+8Vmdqw5ERgc7FZSSdAKdPIIYtkGJmt1jU/CsavtKDNcBML7Uemm3z3VHEkY2ZRl37GEG/LVtLam8u7i3j+6hse1UTPCpiZM+dZuXNSAZT23Cic2dSLvluaeRR8MU23p3ldsOdnVr3whBhzT5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUgcURHfBDQDRmujLonKqDPZyQx0QFaUwC0jVuzPfko=;
 b=VzfHiYZmEZOUWci5zpHERpI324pLT2S6tYIgk++tPnvzbUffbfyYA1V7c4GVMSTce8Nb6QG+PdSG39TWFagso0xcQ9LmRlZPj+rQGvESumB82I8EkQH13V3/Z+Yx+24T+OEIMD7UBEF2sd7UDl3ygT/fWwbQUx5EQK8UOxR4toPWj3+/ldj8DJle5J4FLqUgUMnqTX2ZpaiLD+LM8CFJ7y6QGikDGJtwetLhHMHkcgfai7hD5XfgLONBU9ih8X+GhsFTtsriGpoHZHyhQisfKTyX71WDRQa6tJKGVDfPJKp9gPIvGrG4wd2p5Eiskgy5KCahWgZVxHdoF9qMXMIReQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUgcURHfBDQDRmujLonKqDPZyQx0QFaUwC0jVuzPfko=;
 b=l/Gfzq3K5TBD/Vy70wciTvxCG6wjO7S9VWu8/MSB6VGNVcruthFjG5FO4bWTHiF7ITZL0UlZ6QHkG7KwarZ9vH0hY/RJVUllzSpValjahEi8aKcGZEx5xxqk2IQYVjvlBzsQIZ5ZrRYWozrROTQyl81L9C1sd1s7k5XOlswZ4WQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 22:09:28 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 22:09:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "arnd@arndb.de" <arnd@arndb.de>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jackm@dev.mellanox.co.il" <jackm@dev.mellanox.co.il>,
        Erez Alfasi <ereza@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH net-next] [net-next] mlx4: avoid large stack usage in
 mlx4_init_hca()
Thread-Topic: [PATCH net-next] [net-next] mlx4: avoid large stack usage in
 mlx4_init_hca()
Thread-Index: AQHVQJ57thGXqeHaWUeyAhcQSxLAJKbYxVaA
Date:   Tue, 23 Jul 2019 22:09:27 +0000
Message-ID: <8a76a11a6a7ad2dae93f52b9e243aa79103279ae.camel@mellanox.com>
References: <20190722150204.1157315-1-arnd@arndb.de>
In-Reply-To: <20190722150204.1157315-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07297a12-0b6f-4d77-27ae-08d70fba6dfd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-microsoft-antispam-prvs: <DB6PR0501MB26807926B88F2F4E7B293920BEC70@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(189003)(199004)(14454004)(66476007)(66446008)(4326008)(8676002)(76116006)(66946007)(64756008)(66556008)(54906003)(110136005)(91956017)(76176011)(102836004)(68736007)(316002)(5660300002)(66066001)(86362001)(7736002)(486006)(6486002)(118296001)(478600001)(26005)(71190400001)(99286004)(8936002)(71200400001)(53936002)(2616005)(6512007)(476003)(305945005)(25786009)(446003)(2906002)(6246003)(81156014)(14444005)(256004)(36756003)(229853002)(6116002)(58126008)(2501003)(186003)(3846002)(81166006)(6506007)(11346002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4kna+UzpsHSKqlrFYANndPlg/i2Z4omXh4VRfZOsPGaxzhBaWTaGxnhmRHErYnoJPa4T99mCw53bMmFhNmrnSdg5PWvPPNlSkWlb5W4spZifgdPKfqf5Mv6ZQLJotMiafwBdj4imd1aWpWYV1KFH/6S1tyb1Dc660fgkkk0kIS3yp2+zEFhcqgdPTvX6uWmaH9bWhFVguzdpb6tr2l+GyF3woVc3d7pXBeOrx0l8slB9tXXen/ZE7K/w8NxESyeq/xIiIzkDBEAipfrdjMJA1menbKEGSwb/MHIwh1VpRQTfE39ruA+4eVrw82nQSEJihSqwCCBgMOIQal2XEQ3fl5YvO/LmB67xlY8MH4d7B82HJTfsUtAvHZnnC3unXJ3h32OMjlhYiBYiQ5TCFFqMqvicMYfdYYPAKVqVFQmSDjY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <088FEE3FCBC0FD40BE612FD7F24EE14C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07297a12-0b6f-4d77-27ae-08d70fba6dfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 22:09:27.8526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTIyIGF0IDE3OjAxICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBUaGUgbWx4NF9kZXZfY2FwIGFuZCBtbHg0X2luaXRfaGNhX3BhcmFtIGFyZSByZWFsbHkgdG9v
IGxhcmdlDQo+IHRvIGJlIHB1dCBvbiB0aGUga2VybmVsIHN0YWNrLCBhcyBzaG93biBieSB0aGlz
IGNsYW5nIHdhcm5pbmc6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0
L21haW4uYzozMzA0OjEyOiBlcnJvcjogc3RhY2sgZnJhbWUNCj4gc2l6ZSBvZiAxMDg4IGJ5dGVz
IGluIGZ1bmN0aW9uICdtbHg0X2xvYWRfb25lJyBbLVdlcnJvciwtV2ZyYW1lLQ0KPiBsYXJnZXIt
dGhhbj1dDQo+IA0KPiBXaXRoIGdjYywgdGhlIHByb2JsZW0gaXMgdGhlIHNhbWUsIGJ1dCBpdCBk
b2VzIG5vdCB3YXJuIGJlY2F1c2UNCj4gaXQgZG9lcyBub3QgaW5saW5lIHRoaXMgZnVuY3Rpb24s
IGFuZCB0aGVyZWZvcmUgc3RheXMganVzdCBiZWxvdw0KPiB0aGUgd2FybmluZyBsaW1pdCwgd2hp
bGUgY2xhbmcgaXMganVzdCBhYm92ZSBpdC4NCj4gDQo+IFVzZSBremFsbG9jIGZvciBkeW5hbWlj
IGFsbG9jYXRpb24gaW5zdGVhZCBvZiBwdXR0aW5nIHRoZW0NCj4gb24gc3RhY2suIFRoaXMgZ2V0
cyB0aGUgY29tYmluZWQgc3RhY2sgZnJhbWUgZG93biB0byA0MjQgYnl0ZXMuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KDQpSZXZpZXdlZC1ieTog
U2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQoNCj4gLS0tDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L21haW4uYyB8IDY2ICsrKysrKysrKysrKystLS0t
LS0NCj4gLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDM5IGluc2VydGlvbnMoKyksIDI3IGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDQvbWFpbi5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9tYWlu
LmMNCj4gaW5kZXggMWY2ZTE2ZDVlYTZiLi4wN2MyMDRiZDNmYzQgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvbWFpbi5jDQo+IEBAIC0yMjkyLDIzICsyMjkyLDMx
IEBAIHN0YXRpYyBpbnQgbWx4NF9pbml0X2Z3KHN0cnVjdCBtbHg0X2RldiAqZGV2KQ0KPiAgc3Rh
dGljIGludCBtbHg0X2luaXRfaGNhKHN0cnVjdCBtbHg0X2RldiAqZGV2KQ0KPiAgew0KPiAgCXN0
cnVjdCBtbHg0X3ByaXYJICAqcHJpdiA9IG1seDRfcHJpdihkZXYpOw0KPiArCXN0cnVjdCBtbHg0
X2luaXRfaGNhX3BhcmFtICppbml0X2hjYSA9IE5VTEw7DQo+ICsJc3RydWN0IG1seDRfZGV2X2Nh
cAkgICpkZXZfY2FwID0gTlVMTDsNCj4gIAlzdHJ1Y3QgbWx4NF9hZGFwdGVyCSAgIGFkYXB0ZXI7
DQo+IC0Jc3RydWN0IG1seDRfZGV2X2NhcAkgICBkZXZfY2FwOw0KPiAgCXN0cnVjdCBtbHg0X3By
b2ZpbGUJICAgcHJvZmlsZTsNCj4gLQlzdHJ1Y3QgbWx4NF9pbml0X2hjYV9wYXJhbSBpbml0X2hj
YTsNCj4gIAl1NjQgaWNtX3NpemU7DQo+ICAJc3RydWN0IG1seDRfY29uZmlnX2Rldl9wYXJhbXMg
cGFyYW1zOw0KPiAgCWludCBlcnI7DQo+ICANCj4gIAlpZiAoIW1seDRfaXNfc2xhdmUoZGV2KSkg
ew0KPiAtCQllcnIgPSBtbHg0X2Rldl9jYXAoZGV2LCAmZGV2X2NhcCk7DQo+ICsJCWRldl9jYXAg
PSBremFsbG9jKHNpemVvZigqZGV2X2NhcCksIEdGUF9LRVJORUwpOw0KPiArCQlpbml0X2hjYSA9
IGt6YWxsb2Moc2l6ZW9mKCppbml0X2hjYSksIEdGUF9LRVJORUwpOw0KPiArDQo+ICsJCWlmICgh
ZGV2X2NhcCB8fCAhaW5pdF9oY2EpIHsNCj4gKwkJCWVyciA9IC1FTk9NRU07DQo+ICsJCQlnb3Rv
IG91dF9mcmVlOw0KPiArCQl9DQo+ICsNCj4gKwkJZXJyID0gbWx4NF9kZXZfY2FwKGRldiwgZGV2
X2NhcCk7DQo+ICAJCWlmIChlcnIpIHsNCj4gIAkJCW1seDRfZXJyKGRldiwgIlFVRVJZX0RFVl9D
QVAgY29tbWFuZCBmYWlsZWQsDQo+IGFib3J0aW5nXG4iKTsNCj4gLQkJCXJldHVybiBlcnI7DQo+
ICsJCQlnb3RvIG91dF9mcmVlOw0KPiAgCQl9DQo+ICANCj4gLQkJY2hvb3NlX3N0ZWVyaW5nX21v
ZGUoZGV2LCAmZGV2X2NhcCk7DQo+IC0JCWNob29zZV90dW5uZWxfb2ZmbG9hZF9tb2RlKGRldiwg
JmRldl9jYXApOw0KPiArCQljaG9vc2Vfc3RlZXJpbmdfbW9kZShkZXYsIGRldl9jYXApOw0KPiAr
CQljaG9vc2VfdHVubmVsX29mZmxvYWRfbW9kZShkZXYsIGRldl9jYXApOw0KPiAgDQo+ICAJCWlm
IChkZXYtPmNhcHMuZG1mc19oaWdoX3N0ZWVyX21vZGUgPT0NCj4gTUxYNF9TVEVFUklOR19ETUZT
X0EwX1NUQVRJQyAmJg0KPiAgCQkgICAgbWx4NF9pc19tYXN0ZXIoZGV2KSkNCj4gQEAgLTIzMzEs
NDggKzIzMzksNDggQEAgc3RhdGljIGludCBtbHg0X2luaXRfaGNhKHN0cnVjdCBtbHg0X2Rldg0K
PiAqZGV2KQ0KPiAgCQkgICAgTUxYNF9TVEVFUklOR19NT0RFX0RFVklDRV9NQU5BR0VEKQ0KPiAg
CQkJcHJvZmlsZS5udW1fbWNnID0gTUxYNF9GU19OVU1fTUNHOw0KPiAgDQo+IC0JCWljbV9zaXpl
ID0gbWx4NF9tYWtlX3Byb2ZpbGUoZGV2LCAmcHJvZmlsZSwgJmRldl9jYXAsDQo+IC0JCQkJCSAg
ICAgJmluaXRfaGNhKTsNCj4gKwkJaWNtX3NpemUgPSBtbHg0X21ha2VfcHJvZmlsZShkZXYsICZw
cm9maWxlLCBkZXZfY2FwLA0KPiArCQkJCQkgICAgIGluaXRfaGNhKTsNCj4gIAkJaWYgKChsb25n
IGxvbmcpIGljbV9zaXplIDwgMCkgew0KPiAgCQkJZXJyID0gaWNtX3NpemU7DQo+IC0JCQlyZXR1
cm4gZXJyOw0KPiArCQkJZ290byBvdXRfZnJlZTsNCj4gIAkJfQ0KPiAgDQo+ICAJCWRldi0+Y2Fw
cy5tYXhfZm1yX21hcHMgPSAoMSA8PCAoMzIgLSBpbG9nMihkZXYtDQo+ID5jYXBzLm51bV9tcHRz
KSkpIC0gMTsNCj4gIA0KPiAgCQlpZiAoZW5hYmxlXzRrX3VhciB8fCAhZGV2LT5wZXJzaXN0LT5u
dW1fdmZzKSB7DQo+IC0JCQlpbml0X2hjYS5sb2dfdWFyX3N6ID0gaWxvZzIoZGV2LT5jYXBzLm51
bV91YXJzKSANCj4gKw0KPiArCQkJaW5pdF9oY2EtPmxvZ191YXJfc3ogPSBpbG9nMihkZXYtDQo+
ID5jYXBzLm51bV91YXJzKSArDQo+ICAJCQkJCQkgICAgUEFHRV9TSElGVCAtDQo+IERFRkFVTFRf
VUFSX1BBR0VfU0hJRlQ7DQo+IC0JCQlpbml0X2hjYS51YXJfcGFnZV9zeiA9IERFRkFVTFRfVUFS
X1BBR0VfU0hJRlQgLQ0KPiAxMjsNCj4gKwkJCWluaXRfaGNhLT51YXJfcGFnZV9zeiA9IERFRkFV
TFRfVUFSX1BBR0VfU0hJRlQNCj4gLSAxMjsNCj4gIAkJfSBlbHNlIHsNCj4gLQkJCWluaXRfaGNh
LmxvZ191YXJfc3ogPSBpbG9nMihkZXYtDQo+ID5jYXBzLm51bV91YXJzKTsNCj4gLQkJCWluaXRf
aGNhLnVhcl9wYWdlX3N6ID0gUEFHRV9TSElGVCAtIDEyOw0KPiArCQkJaW5pdF9oY2EtPmxvZ191
YXJfc3ogPSBpbG9nMihkZXYtDQo+ID5jYXBzLm51bV91YXJzKTsNCj4gKwkJCWluaXRfaGNhLT51
YXJfcGFnZV9zeiA9IFBBR0VfU0hJRlQgLSAxMjsNCj4gIAkJfQ0KPiAgDQo+IC0JCWluaXRfaGNh
Lm13X2VuYWJsZWQgPSAwOw0KPiArCQlpbml0X2hjYS0+bXdfZW5hYmxlZCA9IDA7DQo+ICAJCWlm
IChkZXYtPmNhcHMuZmxhZ3MgJiBNTFg0X0RFVl9DQVBfRkxBR19NRU1fV0lORE9XIHx8DQo+ICAJ
CSAgICBkZXYtPmNhcHMuYm1tZV9mbGFncyAmIE1MWDRfQk1NRV9GTEFHX1RZUEVfMl9XSU4pDQo+
IC0JCQlpbml0X2hjYS5td19lbmFibGVkID0gSU5JVF9IQ0FfVFBUX01XX0VOQUJMRTsNCj4gKwkJ
CWluaXRfaGNhLT5td19lbmFibGVkID0gSU5JVF9IQ0FfVFBUX01XX0VOQUJMRTsNCj4gIA0KPiAt
CQllcnIgPSBtbHg0X2luaXRfaWNtKGRldiwgJmRldl9jYXAsICZpbml0X2hjYSwNCj4gaWNtX3Np
emUpOw0KPiArCQllcnIgPSBtbHg0X2luaXRfaWNtKGRldiwgZGV2X2NhcCwgaW5pdF9oY2EsIGlj
bV9zaXplKTsNCj4gIAkJaWYgKGVycikNCj4gLQkJCXJldHVybiBlcnI7DQo+ICsJCQlnb3RvIG91
dF9mcmVlOw0KPiAgDQo+IC0JCWVyciA9IG1seDRfSU5JVF9IQ0EoZGV2LCAmaW5pdF9oY2EpOw0K
PiArCQllcnIgPSBtbHg0X0lOSVRfSENBKGRldiwgaW5pdF9oY2EpOw0KPiAgCQlpZiAoZXJyKSB7
DQo+ICAJCQltbHg0X2VycihkZXYsICJJTklUX0hDQSBjb21tYW5kIGZhaWxlZCwNCj4gYWJvcnRp
bmdcbiIpOw0KPiAgCQkJZ290byBlcnJfZnJlZV9pY207DQo+ICAJCX0NCj4gIA0KPiAtCQlpZiAo
ZGV2X2NhcC5mbGFnczIgJiBNTFg0X0RFVl9DQVBfRkxBRzJfU1lTX0VRUykgew0KPiAtCQkJZXJy
ID0gbWx4NF9xdWVyeV9mdW5jKGRldiwgJmRldl9jYXApOw0KPiArCQlpZiAoZGV2X2NhcC0+Zmxh
Z3MyICYgTUxYNF9ERVZfQ0FQX0ZMQUcyX1NZU19FUVMpIHsNCj4gKwkJCWVyciA9IG1seDRfcXVl
cnlfZnVuYyhkZXYsIGRldl9jYXApOw0KPiAgCQkJaWYgKGVyciA8IDApIHsNCj4gIAkJCQltbHg0
X2VycihkZXYsICJRVUVSWV9GVU5DIGNvbW1hbmQNCj4gZmFpbGVkLCBhYm9ydGluZy5cbiIpOw0K
PiAgCQkJCWdvdG8gZXJyX2Nsb3NlOw0KPiAgCQkJfSBlbHNlIGlmIChlcnIgJiBNTFg0X1FVRVJZ
X0ZVTkNfTlVNX1NZU19FUVMpIHsNCj4gLQkJCQlkZXYtPmNhcHMubnVtX2VxcyA9IGRldl9jYXAu
bWF4X2VxczsNCj4gLQkJCQlkZXYtPmNhcHMucmVzZXJ2ZWRfZXFzID0NCj4gZGV2X2NhcC5yZXNl
cnZlZF9lcXM7DQo+IC0JCQkJZGV2LT5jYXBzLnJlc2VydmVkX3VhcnMgPQ0KPiBkZXZfY2FwLnJl
c2VydmVkX3VhcnM7DQo+ICsJCQkJZGV2LT5jYXBzLm51bV9lcXMgPSBkZXZfY2FwLT5tYXhfZXFz
Ow0KPiArCQkJCWRldi0+Y2Fwcy5yZXNlcnZlZF9lcXMgPSBkZXZfY2FwLQ0KPiA+cmVzZXJ2ZWRf
ZXFzOw0KPiArCQkJCWRldi0+Y2Fwcy5yZXNlcnZlZF91YXJzID0gZGV2X2NhcC0NCj4gPnJlc2Vy
dmVkX3VhcnM7DQo+ICAJCQl9DQo+ICAJCX0NCj4gIA0KPiBAQCAtMjM4MSwxNCArMjM4OSwxMyBA
QCBzdGF0aWMgaW50IG1seDRfaW5pdF9oY2Eoc3RydWN0IG1seDRfZGV2DQo+ICpkZXYpDQo+ICAJ
CSAqIHJlYWQgSENBIGZyZXF1ZW5jeSBieSBRVUVSWV9IQ0EgY29tbWFuZA0KPiAgCQkgKi8NCj4g
IAkJaWYgKGRldi0+Y2Fwcy5mbGFnczIgJiBNTFg0X0RFVl9DQVBfRkxBRzJfVFMpIHsNCj4gLQkJ
CW1lbXNldCgmaW5pdF9oY2EsIDAsIHNpemVvZihpbml0X2hjYSkpOw0KPiAtCQkJZXJyID0gbWx4
NF9RVUVSWV9IQ0EoZGV2LCAmaW5pdF9oY2EpOw0KPiArCQkJZXJyID0gbWx4NF9RVUVSWV9IQ0Eo
ZGV2LCBpbml0X2hjYSk7DQo+ICAJCQlpZiAoZXJyKSB7DQo+ICAJCQkJbWx4NF9lcnIoZGV2LCAi
UVVFUllfSENBIGNvbW1hbmQNCj4gZmFpbGVkLCBkaXNhYmxlIHRpbWVzdGFtcFxuIik7DQo+ICAJ
CQkJZGV2LT5jYXBzLmZsYWdzMiAmPQ0KPiB+TUxYNF9ERVZfQ0FQX0ZMQUcyX1RTOw0KPiAgCQkJ
fSBlbHNlIHsNCj4gIAkJCQlkZXYtPmNhcHMuaGNhX2NvcmVfY2xvY2sgPQ0KPiAtCQkJCQlpbml0
X2hjYS5oY2FfY29yZV9jbG9jazsNCj4gKwkJCQkJaW5pdF9oY2EtPmhjYV9jb3JlX2Nsb2NrOw0K
PiAgCQkJfQ0KPiAgDQo+ICAJCQkvKiBJbiBjYXNlIHdlIGdvdCBIQ0EgZnJlcXVlbmN5IDAgLSBk
aXNhYmxlDQo+IHRpbWVzdGFtcGluZw0KPiBAQCAtMjQ2NCw3ICsyNDcxLDggQEAgc3RhdGljIGlu
dCBtbHg0X2luaXRfaGNhKHN0cnVjdCBtbHg0X2RldiAqZGV2KQ0KPiAgCXByaXYtPmVxX3RhYmxl
LmludGFfcGluID0gYWRhcHRlci5pbnRhX3BpbjsNCj4gIAltZW1jcHkoZGV2LT5ib2FyZF9pZCwg
YWRhcHRlci5ib2FyZF9pZCwgc2l6ZW9mKGRldi0+Ym9hcmRfaWQpKTsNCj4gIA0KPiAtCXJldHVy
biAwOw0KPiArCWVyciA9IDA7DQo+ICsJZ290byBvdXRfZnJlZTsNCj4gIA0KPiAgdW5tYXBfYmY6
DQo+ICAJdW5tYXBfaW50ZXJuYWxfY2xvY2soZGV2KTsNCj4gQEAgLTI0ODMsNiArMjQ5MSwxMCBA
QCBzdGF0aWMgaW50IG1seDRfaW5pdF9oY2Eoc3RydWN0IG1seDRfZGV2ICpkZXYpDQo+ICAJaWYg
KCFtbHg0X2lzX3NsYXZlKGRldikpDQo+ICAJCW1seDRfZnJlZV9pY21zKGRldik7DQo+ICANCj4g
K291dF9mcmVlOg0KPiArCWtmcmVlKGRldl9jYXApOw0KPiArCWtmcmVlKGluaXRfaGNhKTsNCj4g
Kw0KPiAgCXJldHVybiBlcnI7DQo+ICB9DQo+ICANCg==
