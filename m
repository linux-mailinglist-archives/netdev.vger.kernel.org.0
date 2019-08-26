Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0D79D7F0
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfHZVML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:12:11 -0400
Received: from mail-eopbgr50042.outbound.protection.outlook.com ([40.107.5.42]:46822
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfHZVMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 17:12:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FahFE8VoIDo71FE9HCo1geq6f4fNZMC5WSmCfmKFuVn4wB5oiDrtM/7cfEoZO4RzzaOOtUym0uM0l+mAr5n8QiS5VbYNLwFG8FFrP1VM+hxt7l8Q9WMWJlErjMf+nZ7ncnDBuZNJySgvBF7lsr/PW2IzV0l1HYbmOaZefP4JuQXnaNj7Up0Wo9BioR+zZJ02ZvcHnigSfHdzAUC4g2iGIxLoqd3I98bF3gpb2KwGNa4wwjN22CZ/nT4jgEUgBHVuvLdFZ58FH37XxKIOM0GjndcQ/VZts/CEcAHmpqCy6IfVLdsgRGKKOJaRFZVJ20LGhHovMewNV/VJDdFn7tvmYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDH54/dliJJyDp7x85rdGUPOH6Nq7iC+HywRYxVJkGI=;
 b=XqiUd/W8G0EcHHZqptIQ7J/cIRLw1NKauXqMiSogRbGuiM/dKzNjC6jkbvH/LYMoTQNqw1E7slaZpN+4CXeLKdU8t+7XKHuGHWrqjw319ZRHKKnr7HXciA+wTrsoL5weaSmJ1nXh2ZKMFtrYk9vSKkn+/Xz7j2g9mKkVC1GBn6ouNnRz+y98tN2MoDdUjxAtRhc+MJnjJnNW4SHhENl23asloA844c+ybZusoUaz1pD8zZLANK0JbwvU5PZHZiMff9zy+HWrUTxSSIm05je8oMlZjkAziONiQ5glNmmqsnfUCiI7cGJZpKGgPANQF6GmLJFyRY68ub5JpNXDNhoH9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDH54/dliJJyDp7x85rdGUPOH6Nq7iC+HywRYxVJkGI=;
 b=p3zfMUXOdsjjqaBjhtCqTa8yu5biBJzBeIEyzo8mSE9nlmcQbXQ4ky87WxlB4gd9u1S9gkGXyOUrzojju2zcGw6b9iqmA6pBzuWpkWNnKrYZJfaZ02DbRzz6uNq/mktzX6qgFRo2cHEjlRxYd+EA1JrVaszzM8w5kkttdSlifJk=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2766.eurprd05.prod.outlook.com (10.172.11.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 26 Aug 2019 21:11:25 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Mon, 26 Aug 2019
 21:11:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "cai@lca.pw" <cai@lca.pw>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH] net/mlx5: fix a -Wstringop-truncation warning
Thread-Topic: [PATCH] net/mlx5: fix a -Wstringop-truncation warning
Thread-Index: AQHVWezn79S9mYXS9UOCwXmOlPmrCacN8cMA
Date:   Mon, 26 Aug 2019 21:11:24 +0000
Message-ID: <21994e7e141ee5453c6814de025e083eeb651127.camel@mellanox.com>
References: <1566590183-9898-1-git-send-email-cai@lca.pw>
In-Reply-To: <1566590183-9898-1-git-send-email-cai@lca.pw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b1cd9aa-65aa-4429-329f-08d72a69f40e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2766;
x-ms-traffictypediagnostic: VI1PR0501MB2766:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB27666D3C8F9789C81C7A603ABEA10@VI1PR0501MB2766.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(189003)(199004)(53936002)(5660300002)(76116006)(66946007)(966005)(11346002)(476003)(81166006)(1730700003)(8676002)(81156014)(6306002)(66476007)(6512007)(229853002)(71190400001)(91956017)(6916009)(71200400001)(8936002)(14454004)(256004)(36756003)(6506007)(446003)(99286004)(486006)(478600001)(2616005)(58126008)(2906002)(6116002)(3846002)(26005)(54906003)(186003)(86362001)(316002)(118296001)(66556008)(14444005)(76176011)(5640700003)(6486002)(2351001)(6436002)(25786009)(6246003)(66446008)(64756008)(305945005)(66066001)(7736002)(4326008)(102836004)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2766;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iqBOOaBip6D7zKviawXFZLPCu4iY+wBapNftTLZHZJMGzXK5yJ26qnYgWBlGmMudW6IgZbFsnhK2yjU05mtfOOmyrBqE1d6lCoJkr70OWObrTF5BLwp3bj13SZWIuUyhSl3rlTnwOEIS6/837jnHBbyPqBzxvO3cxpRtgJB8i75LYaesIUppuo/eLvt2x/TmYDHpiO+Kz/T5jtvYxIdlMNIgTbuTph7celueE3AMSKwctlhqJSKj2XcTSSkQl+Qxn17S0Zw/rl3syNYupzLnC6oHQCPVS4BLGmB9BzBfS1T1Yvw12ylH+/ZiBuECTZ0RpZQFYyqYrhZ+UvCOEFopBFpVJoaU83YSQNKuGhbC37qJ7OdUrrQWYx2sG2uaxvAzZmUI/8nT+tDk7+HxbLIl0CfC4O3c4vvf5OoDt7DQEHU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <426715EE5BD52241B36A6B512139AC49@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b1cd9aa-65aa-4429-329f-08d72a69f40e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 21:11:24.8429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4DmOtkyYh41xqKrmi6YnH3ow7mijTVaLmvjYQ1KOwrl0HLolN65jy5eJQ/bwU/KJakKZRRM6Hsx4UFWL/USNqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2766
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTIzIGF0IDE1OjU2IC0wNDAwLCBRaWFuIENhaSB3cm90ZToNCj4gSW4g
ZmlsZSBpbmNsdWRlZCBmcm9tIC4vYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL3BhY2EuaDoxNSwN
Cj4gICAgICAgICAgICAgICAgICBmcm9tIC4vYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2N1cnJl
bnQuaDoxMywNCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC90aHJlYWRf
aW5mby5oOjIxLA0KPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2FzbS1nZW5lcmlj
L3ByZWVtcHQuaDo1LA0KPiAgICAgICAgICAgICAgICAgIGZyb20NCj4gLi9hcmNoL3Bvd2VycGMv
aW5jbHVkZS9nZW5lcmF0ZWQvYXNtL3ByZWVtcHQuaDoxLA0KPiAgICAgICAgICAgICAgICAgIGZy
b20gLi9pbmNsdWRlL2xpbnV4L3ByZWVtcHQuaDo3OCwNCj4gICAgICAgICAgICAgICAgICBmcm9t
IC4vaW5jbHVkZS9saW51eC9zcGlubG9jay5oOjUxLA0KPiAgICAgICAgICAgICAgICAgIGZyb20g
Li9pbmNsdWRlL2xpbnV4L3dhaXQuaDo5LA0KPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNs
dWRlL2xpbnV4L2NvbXBsZXRpb24uaDoxMiwNCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5j
bHVkZS9saW51eC9tbHg1L2RyaXZlci5oOjM3LA0KPiAgICAgICAgICAgICAgICAgIGZyb20NCj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9lcS5oOjYsDQo+ICAg
ICAgICAgICAgICAgICAgZnJvbQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZGlhZy9md190cmFjZXIuYzozMzoNCj4gSW4gZnVuY3Rpb24gJ3N0cm5jcHknLA0KPiAg
ICAgaW5saW5lZCBmcm9tICdtbHg1X2Z3X3RyYWNlcl9zYXZlX3RyYWNlJyBhdA0KPiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9md190cmFjZXIuYzo1NDk6MiwN
Cj4gICAgIGlubGluZWQgZnJvbSAnbWx4NV90cmFjZXJfcHJpbnRfdHJhY2UnIGF0DQo+IGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kaWFnL2Z3X3RyYWNlci5jOjU3NDoy
Og0KPiAuL2luY2x1ZGUvbGludXgvc3RyaW5nLmg6MzA1Ojk6IHdhcm5pbmc6ICdfX2J1aWx0aW5f
c3RybmNweScgb3V0cHV0DQo+IG1heQ0KPiBiZSB0cnVuY2F0ZWQgY29weWluZyAyNTYgYnl0ZXMg
ZnJvbSBhIHN0cmluZyBvZiBsZW5ndGggNTExDQo+IFstV3N0cmluZ29wLXRydW5jYXRpb25dDQo+
ICAgcmV0dXJuIF9fYnVpbHRpbl9zdHJuY3B5KHAsIHEsIHNpemUpOw0KPiAgICAgICAgICBefn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiANCj4gRml4IGl0IGJ5IHVzaW5nIHRoZSBuZXcg
c3Ryc2NweV9wYWQoKSBzaW5jZSB0aGUgY29tbWl0IDQ1OGEzYmY4MmRmNA0KPiAoImxpYi9zdHJp
bmc6IEFkZCBzdHJzY3B5X3BhZCgpIGZ1bmN0aW9uIikgd2hpY2ggd2lsbCBhbHdheXMNCj4gTlVM
LXRlcm1pbmF0ZSB0aGUgc3RyaW5nLCBhbmQgYXZvaWQgcG9zc2libHkgbGVhayBkYXRhIHRocm91
Z2ggdGhlDQo+IHJpbmcNCj4gYnVmZmVyIHdoZXJlIG5vbi1hZG1pbiBhY2NvdW50IG1pZ2h0IGVu
YWJsZSB0aGVzZSBldmVudHMgdGhyb3VnaA0KPiBwZXJmLg0KPiANCj4gRml4ZXM6IGZkMTQ4M2Zl
MWY5ZiAoIm5ldC9tbHg1OiBBZGQgc3VwcG9ydCBmb3IgRlcgcmVwb3J0ZXIgZHVtcCIpDQo+IFNp
Z25lZC1vZmYtYnk6IFFpYW4gQ2FpIDxjYWlAbGNhLnB3Pg0KDQoNCkhpIFFpYW4gYW5kIHRoYW5r
cyBmb3IgeW91ciBwYXRjaCwNCg0KV2UgYWxyZWFkeSBoYXZlIGEgcGF0Y2ggdGhhdCBoYW5kbGVz
IHRoaXMgaXNzdWUsIHBsZWFzZSBjaGVjayBpdCBvdXQ6DQpodHRwczovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zYWVlZC9saW51eC5naXQvY29tbWl0Lz9oPW5ldC1u
ZXh0LW1seDUNCg0KDQoNCg==
