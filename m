Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B7521F15
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfEQUbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:31:02 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:33925
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726578AbfEQUbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjLKp38oW4Ns4RMEanm9FSW53LHW3Le3kZceoodbFig=;
 b=A7QZEbBedLW/+f2AZK5nhmYWI0Mheil4JIZj6z+GUfi+n+NwjjUL8lb3f8KjmIKAPNl/QMTNxaj09GAr4s4iBgVnanloXtwKtmfXjGD8cTVQHeXZfoilB5CNFKs/3gxAqPM03r158DNuwGUtQGKCkutmDYfOuyQLCkSxPy1H6ZU=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5932.eurprd05.prod.outlook.com (20.179.9.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 17 May 2019 20:30:59 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:30:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Gavi Teitz <gavi@mellanox.com>,
        "wenxu@ucloud.cn" <wenxu@ucloud.cn>, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: restrict the real_dev of vlan device is the
 same as uplink device
Thread-Topic: [PATCH] net/mlx5e: restrict the real_dev of vlan device is the
 same as uplink device
Thread-Index: AQHVCwCZ1GHvPCVNAk+Rb9K0gcDQ16ZvyNyA
Date:   Fri, 17 May 2019 20:30:59 +0000
Message-ID: <32affe9e97f26ff1c7b5993255a6783533fe6bff.camel@mellanox.com>
References: <1557912345-14649-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1557912345-14649-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 408ee649-11eb-43f0-333c-08d6db06927c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5932;
x-ms-traffictypediagnostic: DB8PR05MB5932:
x-microsoft-antispam-prvs: <DB8PR05MB5932DEE5D4FE0778DA12BE4FBE0B0@DB8PR05MB5932.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(39860400002)(346002)(136003)(189003)(199004)(8676002)(4326008)(110136005)(36756003)(6436002)(71190400001)(3846002)(6116002)(2906002)(6486002)(53936002)(76116006)(71200400001)(229853002)(316002)(14454004)(99286004)(66066001)(5660300002)(6506007)(6636002)(6246003)(81156014)(6512007)(91956017)(81166006)(76176011)(102836004)(66556008)(64756008)(476003)(2616005)(66446008)(25786009)(486006)(66946007)(2501003)(73956011)(256004)(11346002)(118296001)(305945005)(446003)(26005)(8936002)(58126008)(7736002)(86362001)(14444005)(478600001)(68736007)(186003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5932;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fWvjQm8dO9Q9uzqustsn7+PCg24GyYhSyAg5VmIcj0PBUSFqUpRdyFeBdUVSkBOqzPDQK14q4H+QYjlgjtqISJ261qKDCmUAZqXeJMV/zee18i5IBgyc7jTIWAIQ0stbEkQjzdZZIzjCpePjOEQuQShgH5qJXGWsygroLzNRLd8KKiiGS5gLEDEQzrgIqKKlwv+SHxlJChhCZcTuIUUBuEzIwOL7KPJZ/xSP5eEtX4RtTtFvNsg1RGdlofTxURM695TlVed0iS/B+rY7wPhkqypbbMclED+7R7ABAtlHC7+Gwgtsj1hFLijeV9G20jo3ALoiXzgQizSJMn6edYPgrG1xUDsah51Ktlr1FTHflFjOo6RDEqDz5/KiLv4YbEsPRcCGaSjeodt1DZYZ7/wjxRjVc/YKrjoig9z8Q1lqTZs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96F071AF6B2F31419AEC7A34145E284F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408ee649-11eb-43f0-333c-08d6db06927c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:30:59.2334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5932
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTE1IGF0IDE3OjI1ICswODAwLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6
DQo+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IA0KPiBXaGVuIHJlZ2lzdGVyIGlu
ZHIgYmxvY2sgZm9yIHZsYW4gZGV2aWNlLCBpdCBzaG91bGQgY2hlY2sgdGhlDQo+IHJlYWxfZGV2
DQo+IG9mIHZsYW4gZGV2aWNlIGlzIHNhbWUgYXMgdXBsaW5rIGRldmljZS4gT3IgaXQgd2lsbCBz
ZXQgb2ZmbG9hZCBydWxlDQo+IHRvIG1seDVlIHdoaWNoIHdpbGwgbmV2ZXIgaGl0Lg0KPiANCg0K
SSB3b3VsZCBpbXByb3ZlIHRoZSBjb21taXQgbWVzc2FnZSwgaXQgaXMgbm90IHJlYWxseSBjbGVh
ciB0byBtZSB3aGF0DQppcyBnb2luZyBvbiBoZXJlLg0KDQpBbnl3YXkgUm9pIGFuZCB0ZWFtLCBj
YW4geW91IHBsZWFzZSBwcm92aWRlIGZlZWRiYWNrIC4uDQoNCj4gU2lnbmVkLW9mZi1ieTogd2Vu
eHUgPHdlbnh1QHVjbG91ZC5jbj4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fcmVwLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4gaW5kZXggOTFlMjRmMS4uYTM5ZmRh
YyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX3JlcC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9yZXAuYw0KPiBAQCAtNzk2LDcgKzc5Niw3IEBAIHN0YXRpYyBpbnQgbWx4NWVfbmljX3Jl
cF9uZXRkZXZpY2VfZXZlbnQoc3RydWN0DQo+IG5vdGlmaWVyX2Jsb2NrICpuYiwNCj4gIAlzdHJ1
Y3QgbmV0X2RldmljZSAqbmV0ZGV2ID0gbmV0ZGV2X25vdGlmaWVyX2luZm9fdG9fZGV2KHB0cik7
DQo+ICANCj4gIAlpZiAoIW1seDVlX3RjX3R1bl9kZXZpY2VfdG9fb2ZmbG9hZChwcml2LCBuZXRk
ZXYpICYmDQo+IC0JICAgICFpc192bGFuX2RldihuZXRkZXYpKQ0KPiArCSAgICAhKGlzX3ZsYW5f
ZGV2KG5ldGRldikgJiYgdmxhbl9kZXZfcmVhbF9kZXYobmV0ZGV2KSA9PQ0KPiBycHJpdi0+bmV0
ZGV2KSkNCj4gIAkJcmV0dXJuIE5PVElGWV9PSzsNCj4gIA0KPiAgCXN3aXRjaCAoZXZlbnQpIHsN
Cg==
