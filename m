Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B7518DDAC
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 03:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgCUCnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 22:43:13 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:28574
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbgCUCnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 22:43:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXOGEFiFGgw1pkw0l8h+7GlxM1/kU9J8WffG8C1x4+XLIQPq7qD7MNiptvU1cRX0PPzq6kysA0785ZN0MscvGASBbqWnHVx1tgGY+D87oyVOQLMy2M4bmXDEhkqwjI7EZfiymeNY+iEdCuNXYkGvoS48Lfu9Wt8m/juWgxeKQzx5ud/XYGY+SsIiBPfwvQ27N9KWdDyBHpTBq2Ag6HyY6UYy1XvpjBW5rssYR7H26zeYCg/cm6PLZI8awR5Mvh1qz06Uo9zix+llqrDAftUsz00dHncbT4rufy3ILE9d/UR2wloGp+PZfa5XY41PUcvwB/IUQWqHP1GRXWSAM9qYLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9Oci65mX8dbAZYcfPn+IEcVRs91Tya83pR774n3NDk=;
 b=QuP96X1NpGIjlvNUEla9qVNf0vr8OIYNjzZL77V+3ldaKtGzboBD0S+nX1IQ5RxrIz6amDBUumX/o+Lbn94AOp/3/WXFDq10db/zgHrJ7uOfOpa1asSP3MGnys2trro8IjoylW42cTotKaaoCt+I3bWHyHZM1YJFADK0/Dg/Uz9diOmpv5MTAsd5Cw0vDycP88qRAZjJs4TcYmb9NNDgDK1Y81QGSXBb7xNN8tFXzCqZHAk/+O4SIZbcGEUH2o1FhfQInpEmqj3TACwi7Ao4+HuUROox7NI+k1P1GAaKzelXqPBIjEK0MTfXuL4x39JjEvlRMDYzJyUDdjjWubQ6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9Oci65mX8dbAZYcfPn+IEcVRs91Tya83pR774n3NDk=;
 b=X3whSSu3Kwr+o3vfBpCiAUmigAvWmihjqgZv5wYvxjmBrDCk7OnAJeZ2XOq4+nCmYSkfqMMBH7Lj/KncLYjl9iPhcd8yJQSPRtdOQScq2u9LCLcRwjtd9DqCydV7uWfIW+rh+B6+IJTLeqTwl+1FV9maRPkvC/CvLDpnLnE71oA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4686.eurprd05.prod.outlook.com (20.176.6.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Sat, 21 Mar 2020 02:43:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.017; Sat, 21 Mar 2020
 02:43:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        Paul Blakey <paulb@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Oz Shlomo <ozsh@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Fix actions_match_supported() return
Thread-Topic: [PATCH net-next] net/mlx5e: Fix actions_match_supported() return
Thread-Index: AQHV/rq5MW3PWZX7iEqM5qVlxAqfpahSV3AA
Date:   Sat, 21 Mar 2020 02:43:08 +0000
Message-ID: <35fcb57643c0522b051318e75b106100422fb1dc.camel@mellanox.com>
References: <20200320132305.GB95012@mwanda>
In-Reply-To: <20200320132305.GB95012@mwanda>
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
x-ms-office365-filtering-correlation-id: 009b4c9c-fbd5-401f-6b2a-08d7cd41974d
x-ms-traffictypediagnostic: VI1PR05MB4686:|VI1PR05MB4686:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4686C09CCC42BD7470341CEBBEF20@VI1PR05MB4686.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 034902F5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(199004)(110136005)(6512007)(6486002)(2616005)(86362001)(66946007)(71200400001)(54906003)(6636002)(2906002)(478600001)(4326008)(8676002)(81166006)(91956017)(81156014)(76116006)(66476007)(6506007)(36756003)(8936002)(66556008)(186003)(316002)(64756008)(26005)(66446008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4686;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: INNaLsGm88q9ARAn2pNbcX/QTCo7BHoPzBdVKE0ndLW3DuWo1IHbJ4KG8um6MTvbq/dGbRxMBYnFmu4SBOT/YcSfUUQPrGi+vVIGH9CvfHI8UzHHV/04uNE9N+XLrYvZVlxAIVmCyith4OdroVDzEjsQZJzBS5TcONTuVW9KBpODeKwY+q3yi5ZRtF/apZ6zXi+PES2SAhRUvrZiM05gxdwCSXwTtA31da4IRQA10ahOQLPmHGOEB5fWS+ADrjNK5RkYrGw04IFTQjG0hdM8dLJMS3Bn1cIuYJReDGpwqpZISDOlY2ZeUeDCnaGWSzavrHABiZ7vcqE/rCAEgMPA5Aj5i3Ro9H3AKmJ4QZl1SYHJTRfDnanSB1BvEA3JCIUKs3Tym9pBMVEgFV2o5UC8SfWArOxxFe9e3X/BfwhIuSXiGVbqzWwfcr58bilCr1os
x-ms-exchange-antispam-messagedata: j6bJ0yUh4RMXWcnZEeoPIsudep8o1Sm8A6C7vBw0giS0uCB0qUZsbX9F4UzJKSLFtXc3ud+jUU88IEvuWlHh4eL1QF9/KnxA7/2bknHlbuiQXf7+d5GU9cyiWqdzLpQ4ojwG/W4telgRNVdHZLy+Ag==
Content-Type: text/plain; charset="utf-8"
Content-ID: <308257BB33D7004D8CD4026684A924BA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009b4c9c-fbd5-401f-6b2a-08d7cd41974d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2020 02:43:08.9237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SSk1g5Wom7DKPz1p4rP2uBgZXMlbQM6d8vuyZtvCsL9l96FtsMXiAdsmuLLji6zb+WwjODWtGWWF8BLkE79QAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4686
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAzLTIwIGF0IDE2OjIzICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBUaGUgYWN0aW9uc19tYXRjaF9zdXBwb3J0ZWQoKSBmdW5jdGlvbiByZXR1cm5zIGEgYm9vbCwg
dHJ1ZSBmb3INCj4gc3VjY2Vzcw0KPiBhbmQgZmFsc2UgZm9yIGZhaWx1cmUuICBUaGlzIGVycm9y
IHBhdGggaXMgcmV0dXJuaW5nIGEgbmVnYXRpdmUgd2hpY2gNCj4gaXMgY2FzdCB0byB0cnVlIGJ1
dCBpdCBzaG91bGQgcmV0dXJuIGZhbHNlLg0KPiANCj4gRml4ZXM6IDRjMzg0NGQ5ZTk3ZSAoIm5l
dC9tbHg1ZTogQ1Q6IEludHJvZHVjZSBjb25uZWN0aW9uIHRyYWNraW5nIikNCj4gU2lnbmVkLW9m
Zi1ieTogRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPg0KPiAtLS0NCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jIHwgMiArLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3Rj
LmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0K
PiBpbmRleCAwNDQ4OTFhMDNiZTMuLmU1ZGU3ZDJiYWMyYiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gQEAgLTMwNTgsNyAr
MzA1OCw3IEBAIHN0YXRpYyBib29sIGFjdGlvbnNfbWF0Y2hfc3VwcG9ydGVkKHN0cnVjdA0KPiBt
bHg1ZV9wcml2ICpwcml2LA0KPiAgCQkJICovDQo+ICAJCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0
YWNrLA0KPiAgCQkJCQkgICAiQ2FuJ3Qgb2ZmbG9hZCBtaXJyb3JpbmcNCj4gd2l0aCBhY3Rpb24g
Y3QiKTsNCj4gLQkJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gKwkJCXJldHVybiBmYWxzZTsNCj4g
IAkJfQ0KPiAgCX0gZWxzZSB7DQo+ICAJCWFjdGlvbnMgPSBmbG93LT5uaWNfYXR0ci0+YWN0aW9u
Ow0KDQphcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUgDQoNClRoYW5rcywNClNhZWVkLg0K
