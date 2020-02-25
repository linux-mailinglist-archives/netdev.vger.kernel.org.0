Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61816F2AB
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 23:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgBYWmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 17:42:02 -0500
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:33376
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727227AbgBYWmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 17:42:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrVp8Q8Sveqpmj5NN8j8blAy+JNx4T7sRReGXnueJyMSkJmwVGGRoWqN/HCbOcN8+f4i57Ne/qX8BPdcUiDfB2cqZ2TWeRPVMubLaAiL3Z6YUFiq4rYjDqzUTC7+Fpo8dpv9Qi/t8AAJ1kERxBpNmAXm8qBSGRt28cbtqw3NmYWel2OD+KwI0bNqVs7M9XnbezRaKQ0skS8wPFlLQSiCBnKcYOER05pNqoBFhhj7Ee6gmRKDPv0j8zZmy1Zjqwek50GxtVYEn3Z+IchFqhVmb1gc21OL6OMC/rWYucs6KYahZ6xEjcgCDccFqnzBMmIMQh7gucSkLGKLTzaIgh5gYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1s5X/vKpsmlVwTWHFLVc5WefRqkw/Uj7DF9M5s6mS88=;
 b=NeW/JLN3haXRbAvf4EgRM35TiGruKxYWC+0wGZt6koyodpaBD4HLfwkDVprKh/5F+YPhUgOnLF2NaAGraq4DSpq0SG7jya8xJu5/CdXIYfxbDM/FMNXw8tJgZi5WU7A9qXLI8Egb2fik3kKz4ONxdjRNcOKX83EJw2y+mcfuBu24RsLiWyLXe7mDt4mqy/yHMkv/y8iES4gZBginY7rhmtnEW9O6ntyjdXXDFzTOMI2BOLzyd3t2gvxFJ1Q6QN8Fd3xM7vfQ6G1GOfer8TiFSQaE2/99u4t6K9eylOMdeOUDiyRGbwgADuHi6X72S3HJiM0U9PaHb2mWjIBXdlgKGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1s5X/vKpsmlVwTWHFLVc5WefRqkw/Uj7DF9M5s6mS88=;
 b=SYPgRrMWBi51EDcnGQpAmnUnpM/dQSTbRwBls6xZL+YjWl0St8NiLeq5p2TROmR6LmbKchUcgO8c7J9h/pCsLQjyhya783bkK0RCjr0c0479JyFIbjMNLxWTM1yv1iSKSM5G4ReH6pCKFe08qrogeATsdwA96ahlHtr/OL2BH/4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4352.eurprd05.prod.outlook.com (52.133.12.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Tue, 25 Feb 2020 22:41:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 22:41:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Aya Levin <ayal@mellanox.com>, Ran Rozenstein <ranro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [patch net] mlx5: register lag notifier for init network
 namespace only
Thread-Topic: [patch net] mlx5: register lag notifier for init network
 namespace only
Thread-Index: AQHV672R36eYVZJZRUOn6dv9Q6lJk6gsPuEAgABDM4A=
Date:   Tue, 25 Feb 2020 22:41:57 +0000
Message-ID: <e776d9ee6999309d03c84076d3ed22daf6ec9a53.camel@mellanox.com>
References: <20200225092546.30710-1-jiri@resnulli.us>
         <20200225.104124.426697838382401029.davem@davemloft.net>
In-Reply-To: <20200225.104124.426697838382401029.davem@davemloft.net>
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
x-ms-office365-filtering-correlation-id: df5b3bb5-90b1-45b6-5282-08d7ba43ebea
x-ms-traffictypediagnostic: VI1PR05MB4352:|VI1PR05MB4352:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4352B0594E09E34759D31472BEED0@VI1PR05MB4352.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(199004)(189003)(71200400001)(8676002)(81156014)(81166006)(2616005)(316002)(478600001)(5660300002)(4326008)(4744005)(110136005)(8936002)(86362001)(54906003)(26005)(91956017)(6506007)(66476007)(2906002)(186003)(66556008)(6486002)(76116006)(64756008)(66446008)(66946007)(36756003)(6512007)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4352;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2934EFS5u9kD6islvwX7LsYyfFWqAyPXH90R8dgHoJq1H4OeBhr0jgENIv8HA2ZvyalsdS931nBJ4AI4LXY5+VmMahyh0iIVYn2B7Ex6tex/aPFWUxA5Q2eSgHyAoU2kOdnbFJLLX6qu8YQSiHO3e4UWcdMdA2n388tKarV9udK4jA2IMg0o6N5L6+volT6HQWZCAIFKIRW/NXNU0KunxNdW5VBwfcJgw1bLO2cjwod07TY4gUPhC51IBKzrmX+Ac932k3n5mUWvtiny5u1SmUmV2616wt4H2WxbrCFDi1uGUT8jLRTvUgb/KBCktQstYpfRjgLCq4jWNZzzlYMLF7+lx1LzbX5Rr6JL01t17y+cRQd0lEK0iLzPbF/gGWnOS+iU8NZweCfxBqCoPGPta16cn6+W4mfWLKwxP56jlnaBYsZlMuNK5mD7dUpBoGnU
x-ms-exchange-antispam-messagedata: gRofP/wG5O8FHW54YytWy9Mk7ZkkQCj3aHk62HFv1fPnm4HV9RXqs7seurqPf5BKvR5mjiw/WMOSB7HYxOlqPV9ENA6z6QGCiw3MqF/KvZ3tEqADkt2xJvGDVkHfFwFq5C9AQlhCr+W/g+h5t9n0yg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D8FD637944A8A4183BBE9D34617B480@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df5b3bb5-90b1-45b6-5282-08d7ba43ebea
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 22:41:57.8542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kxqm1Wc4ToL2jiPB53DE31Bvk5IrGlaYhGWNU1oR/kRk187b/HcFcAwwPPgTDG3OhyRp2gbApc5DzIUZUuZACA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4352
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAyLTI1IGF0IDEwOjQxIC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEppcmkgUGlya28gPGppcmlAcmVzbnVsbGkudXM+DQo+IERhdGU6IFR1ZSwgMjUgRmVi
IDIwMjAgMTA6MjU6NDYgKzAxMDANCj4gDQo+ID4gRnJvbTogSmlyaSBQaXJrbyA8amlyaUBtZWxs
YW5veC5jb20+DQo+ID4gDQo+ID4gVGhlIGN1cnJlbnQgY29kZSBjYXVzZXMgcHJvYmxlbXMgd2hl
biB0aGUgdW5yZWdpc3RlcmluZyBuZXRkZXZpY2UNCj4gY291bGQNCj4gPiBiZSBkaWZmZXJlbnQg
dGhlbiB0aGUgcmVnaXN0ZXJpbmcgb25lLg0KPiA+IA0KPiA+IFNpbmNlIHRoZSBjaGVjayBpbiBt
bHg1X2xhZ19uZXRkZXZfZXZlbnQoKSBkb2VzIG5vdCBhbGxvdyBhbnkgb3RoZXINCj4gPiBuZXR3
b3JrIG5hbWVzcGFjZSBhbnl3YXksIGZpeCB0aGlzIGJ5IHJlZ2lzdGVydGluZyB0aGUgbGFnIG5v
dGlmaWVyDQo+ID4gcGVyIGluaXQgbmV0d29yayBuYW1lc3BhY2Ugb25seS4NCj4gPiANCj4gPiBG
aXhlczogZDQ4ODM0ZjlkNGI0ICgibWx4NTogVXNlIGRldl9uZXQgbmV0ZGV2aWNlIG5vdGlmaWVy
DQo+IHJlZ2lzdHJhdGlvbnMiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEppcmkgUGlya28gPGppcmlA
bWVsbGFub3guY29tPg0KPiA+IFRlc3RlZC1ieTogQXlhIExldmluIDxheWFsQG1lbGxhbm94LmNv
bT4NCj4gDQo+IFNhZWVkLCBzaG91bGQgSSBhcHBseSB0aGlzIGRpcmVjdGx5Pw0KDQpZZXMgUGxl
YXNlLiBmb3IgbmV0IGkgZG9uJ3QgaGF2ZSBhIGh1Z2UgYW1vdW50IG9mIHRyYWZmaWMsIHNvIGl0
IGlzIG9rDQp0aGF0IHBhdGNoZXMgZ28gZGlyZWN0bHkgdG8gbmV0Lg0KDQpBY2tlZC1ieTogU2Fl
ZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQoNClRoYW5rcywNClNhZWVkLg0K
