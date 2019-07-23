Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA6871D91
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbfGWRWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:22:52 -0400
Received: from mail-eopbgr130075.outbound.protection.outlook.com ([40.107.13.75]:43729
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732675AbfGWRWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 13:22:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeFid85EmVjSvxkmTrxjWUcdJInpyYBLwVC20usUYA0crpiLCkTPWjF7qZx96ailzT5r8/AHhYSSBY+dWTLPS3m3vsN+vCyNNfQAbZrYsYeh/09ZOPnfVa8feYxpknhBZVT2BEculW8weH6Nv1raFP7Ql59pZ9Ai7GNoD5xz9Kq9fmDFqofwVyCFtkTzWM6gWN417Zaqj1PiDRnrPm3QP/uPgveA8uoEaH2fEsts13O1AbU/s/mu4sArSVxDY38pekvA4+39IVxInUSs3vk015VP2d1Sje6xOVbqkp3zOWH/ONvmolzY+KV4JHSkgONawmjVrCdy4+Sogy3+0bLiyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkYFqoZJiENcuMFJ7XJQcOrl9QiM0FvL69NRmwI1Xdk=;
 b=TfgnBgJ5yP2NYn8gxrp9+tWfbw9kAne5JjR8vN5N5uZICFzr8zfhy9Q4m/xtiM5clAAjZxkrSMvtYyZ12dG29AJQMGKWo6bf7+e5jJPzwWqSWfYF8S2U2ou55Eyzq3fRzCBEObw+BidrEz/mxESO9XwZ4LW4+Lq5JMqL7zZP/F79Qnv2ZNlLKbHgvMeUjSq7pZn6Fa83tLdczY/dwhiNSQnxirWcD/9e0kHZmT+gP7tSZVKvgTO7jqGfcfnjm1/bNNcoSvLRUvu/nbXT5BGV3nRvR9Y+sDWkqqWvn/bNdR/26gQ6ofYIWhcHgVNXTZMBpKdcv5bWUjvkEVPuFW5TuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkYFqoZJiENcuMFJ7XJQcOrl9QiM0FvL69NRmwI1Xdk=;
 b=FpGpUQJocglr+K1gzrdn6r4+VW8yURhcJ2OPUrhoxNpA3rR8Al1nsViBNoQkQMVvgSCeEerfFE8z5LY2T1RN2ggMWJsq/sPp95JkORYnMVcMUfcQ4UvEEi6jlvqAIstf+6w8Ogpn0J941MppNM0MdTZLYYd3RUKgN5bSDI+C0f0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2168.eurprd05.prod.outlook.com (10.168.56.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 17:22:44 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 17:22:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] linux/dim: Fix overflow in dim calculation
Thread-Topic: [PATCH net 1/2] linux/dim: Fix overflow in dim calculation
Thread-Index: AQHVQSd1xyfwKTSJE0eMAkgCZ+vqN6bYdCeA
Date:   Tue, 23 Jul 2019 17:22:43 +0000
Message-ID: <4f4bc2958dc1512087f19db64e8e43f1247cf2dd.camel@mellanox.com>
References: <20190723072248.6844-1-leon@kernel.org>
         <20190723072248.6844-2-leon@kernel.org>
In-Reply-To: <20190723072248.6844-2-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 257e52d2-8e95-48f0-1357-08d70f925fc4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2168;
x-ms-traffictypediagnostic: DB6PR0501MB2168:
x-microsoft-antispam-prvs: <DB6PR0501MB216895304A79A4D1EC562C41BEC70@DB6PR0501MB2168.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(199004)(189003)(99286004)(66556008)(76116006)(14444005)(66446008)(256004)(66946007)(64756008)(91956017)(66476007)(316002)(54906003)(3846002)(6116002)(110136005)(8936002)(71190400001)(486006)(71200400001)(2906002)(81166006)(81156014)(58126008)(2501003)(478600001)(2616005)(7736002)(6512007)(186003)(446003)(5660300002)(25786009)(36756003)(53936002)(11346002)(6246003)(118296001)(305945005)(8676002)(26005)(476003)(66066001)(102836004)(229853002)(6506007)(4326008)(76176011)(68736007)(6436002)(6486002)(86362001)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2168;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ovr0VKN+M4SWhy4M5q6tOUSjJjAuYzG+tMcUV1rZm5V7YyHvt882IAb/+dGuW7QccuylUUCleVpQRi7EapP6JF2g8cgdz0eAWqTLxh3FwyfpArxq1n+6xPOOVuaVIULgKQEQsLQ6/QZ0EY32aiaUIlkqSogZul/Y6ay1G/gQ+JzBGlv52dsJT0uObi/H6bfbV5/KoE3X8sf2briW52oQzUeCw2CJqvW5rUhF1fEJmCd77TfsZBJ22O7D9aHvxHzUiN5G58H5c3zdaxKRUsnekvEQfvVOWZap+TmJpIxt+hBdzsK3rQ8qSIeNm7SRArTFAjpuPruPw93OTF1kdFSFpd15jU3zJvyjUo7p6FMmZhcMnukYzflT17Yqpue5P+vzwSdpQsa1kWqPpID/sNLB/XlY00GhWiloV/QjcoRK23Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8D1B5A5EC82964E8F9BDD0D3AF7C13B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 257e52d2-8e95-48f0-1357-08d70f925fc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 17:22:44.0482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2168
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDEwOjIyICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IEZyb206IFlhbWluIEZyaWVkbWFuIDx5YW1pbmZAbWVsbGFub3guY29tPg0KPiANCj4gV2hp
bGUgdXNpbmcgbmV0X2RpbSwgYSBkaW1fc2FtcGxlIHdhcyB1c2VkIHdpdGhvdXQgZXZlciBpbml0
aWFsaXppbmcNCj4gdGhlDQo+IGNvbXBzIHZhbHVlLiBBZGRlZCB1c2Ugb2YgRElWX1JPVU5EX0RP
V05fVUxMKCkgdG8gcHJldmVudCBwb3RlbnRpYWwNCj4gb3ZlcmZsb3csIGl0IHNob3VsZCBub3Qg
YmUgYSBwcm9ibGVtIHRvIHNhdmUgdGhlIGZpbmFsIHJlc3VsdCBpbiBhbg0KPiBpbnQNCj4gYmVj
YXVzZSBhZnRlciB0aGUgZGl2aXNpb24gYnkgZXBtcyB0aGUgdmFsdWUgc2hvdWxkIG5vdCBiZSBs
YXJnZXINCj4gdGhhbiBhDQo+IGZldyB0aG91c2FuZC4NCj4gDQo+IFsgMTA0MC4xMjcxMjRdIFVC
U0FOOiBVbmRlZmluZWQgYmVoYXZpb3VyIGluIGxpYi9kaW0vZGltLmM6Nzg6MjMNCj4gWyAxMDQw
LjEzMDExOF0gc2lnbmVkIGludGVnZXIgb3ZlcmZsb3c6DQo+IFsgMTA0MC4xMzE2NDNdIDEzNDcx
ODcxNCAqIDEwMCBjYW5ub3QgYmUgcmVwcmVzZW50ZWQgaW4gdHlwZSAnaW50Jw0KPiANCj4gRml4
ZXM6IDM5OGMyYjA1YmJlZSAoImxpbnV4L2RpbTogQWRkIGNvbXBsZXRpb25zIGNvdW50IHRvDQo+
IGRpbV9zYW1wbGUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBZYW1pbiBGcmllZG1hbiA8eWFtaW5mQG1l
bGxhbm94LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbWVs
bGFub3guY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JjbXN5
c3BvcnQuYyAgICAgICAgfCAyICstDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9i
bnh0L2JueHQuYyAgICAgICAgIHwgMiArLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRj
b20vZ2VuZXQvYmNtZ2VuZXQuYyAgICB8IDIgKy0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl90eHJ4LmMgfCA0ICsrLS0NCj4gIGxpYi9kaW0vZGltLmMgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCA0ICsrLS0NCj4gIDUgZmlsZXMgY2hh
bmdlZCwgNyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JjbXN5c3BvcnQuYw0KPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2Jyb2FkY29tL2JjbXN5c3BvcnQuYw0KPiBpbmRleCBiOWM1Y2VhOGRiMTYu
Ljk0ODM1NTNjZTQ0NCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRj
b20vYmNtc3lzcG9ydC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2Jj
bXN5c3BvcnQuYw0KPiBAQCAtOTkyLDcgKzk5Miw3IEBAIHN0YXRpYyBpbnQgYmNtX3N5c3BvcnRf
cG9sbChzdHJ1Y3QgbmFwaV9zdHJ1Y3QNCj4gKm5hcGksIGludCBidWRnZXQpDQo+ICB7DQo+ICAJ
c3RydWN0IGJjbV9zeXNwb3J0X3ByaXYgKnByaXYgPQ0KPiAgCQljb250YWluZXJfb2YobmFwaSwg
c3RydWN0IGJjbV9zeXNwb3J0X3ByaXYsIG5hcGkpOw0KPiAtCXN0cnVjdCBkaW1fc2FtcGxlIGRp
bV9zYW1wbGU7DQo+ICsJc3RydWN0IGRpbV9zYW1wbGUgZGltX3NhbXBsZSA9IHt9Ow0KDQpuZXRf
ZGltIGltcGxlbWVudGF0aW9uIGRvZXNuJ3QgY2FyZSBhYm91dCBzYW1wbGUtPmNvbXBfY3RyLCBz
byB0aGlzIGlzDQp1bm5lY2Vzc2FyeSBmb3IgdGhlIHNha2Ugb2YgZml4aW5nIHRoZSByZG1hIG92
ZXJmbG93IGlzc3VlLCBidXQgaXQNCmRvZW5zJ3QgaHVydCBhbnlvbmUgdG8gaGF2ZSB0aGlzIGNo
YW5nZSBpbiB0aGlzIHBhdGNoLCBhbHRob3VnaCBUYXJpcQ0KYWxyZWFkeSBzZW50IG1lIGEgZml4
IHRoYXQgaSBhcHBsaWVkIHRvIG15IGludGVybmFsIHF1ZXVlcy4NCg0KPiAgCXVuc2lnbmVkIGlu
dCB3b3JrX2RvbmUgPSAwOw0KPiANCj4gIAl3b3JrX2RvbmUgPSBiY21fc3lzcG9ydF9kZXNjX3J4
KHByaXYsIGJ1ZGdldCk7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9h
ZGNvbS9ibnh0L2JueHQuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueHQv
Ym54dC5jDQo+IGluZGV4IDcxMzRkMmMzZWIxYy4uNzA3MDM0OTkxNWJjIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibnh0L2JueHQuYw0KPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibnh0L2JueHQuYw0KPiBAQCAtMjEzNiw3ICsyMTM2
LDcgQEAgc3RhdGljIGludCBibnh0X3BvbGwoc3RydWN0IG5hcGlfc3RydWN0ICpuYXBpLA0KPiBp
bnQgYnVkZ2V0KQ0KPiAgCQl9DQo+ICAJfQ0KPiAgCWlmIChicC0+ZmxhZ3MgJiBCTlhUX0ZMQUdf
RElNKSB7DQo+IC0JCXN0cnVjdCBkaW1fc2FtcGxlIGRpbV9zYW1wbGU7DQo+ICsJCXN0cnVjdCBk
aW1fc2FtcGxlIGRpbV9zYW1wbGUgPSB7fTsNCj4gDQo+ICAJCWRpbV91cGRhdGVfc2FtcGxlKGNw
ci0+ZXZlbnRfY3RyLA0KPiAgCQkJCSAgY3ByLT5yeF9wYWNrZXRzLA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNtZ2VuZXQuYw0KPiBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2dlbmV0L2JjbWdlbmV0LmMNCj4gaW5kZXggYTJiNTc4
MDc0NTNiLi5kM2EwYjYxNGRiZmEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2Jyb2FkY29tL2dlbmV0L2JjbWdlbmV0LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
YnJvYWRjb20vZ2VuZXQvYmNtZ2VuZXQuYw0KPiBAQCAtMTg5NSw3ICsxODk1LDcgQEAgc3RhdGlj
IGludCBiY21nZW5ldF9yeF9wb2xsKHN0cnVjdCBuYXBpX3N0cnVjdA0KPiAqbmFwaSwgaW50IGJ1
ZGdldCkNCj4gIHsNCj4gIAlzdHJ1Y3QgYmNtZ2VuZXRfcnhfcmluZyAqcmluZyA9IGNvbnRhaW5l
cl9vZihuYXBpLA0KPiAgCQkJc3RydWN0IGJjbWdlbmV0X3J4X3JpbmcsIG5hcGkpOw0KPiAtCXN0
cnVjdCBkaW1fc2FtcGxlIGRpbV9zYW1wbGU7DQo+ICsJc3RydWN0IGRpbV9zYW1wbGUgZGltX3Nh
bXBsZSA9IHt9Ow0KPiAgCXVuc2lnbmVkIGludCB3b3JrX2RvbmU7DQo+IA0KPiAgCXdvcmtfZG9u
ZSA9IGJjbWdlbmV0X2Rlc2NfcngocmluZywgYnVkZ2V0KTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eHJ4LmMNCj4gYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdHhyeC5jDQo+IGluZGV4IGM1MGI2
ZjA3NjljOC4uNDliMDZiMjU2YzkyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdHhyeC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eHJ4LmMNCj4gQEAgLTQ5LDcgKzQ5LDcgQEAgc3Rh
dGljIGlubGluZSBib29sDQo+IG1seDVlX2NoYW5uZWxfbm9fYWZmaW5pdHlfY2hhbmdlKHN0cnVj
dCBtbHg1ZV9jaGFubmVsICpjKQ0KPiAgc3RhdGljIHZvaWQgbWx4NWVfaGFuZGxlX3R4X2RpbShz
dHJ1Y3QgbWx4NWVfdHhxc3EgKnNxKQ0KPiAgew0KPiAgCXN0cnVjdCBtbHg1ZV9zcV9zdGF0cyAq
c3RhdHMgPSBzcS0+c3RhdHM7DQo+IC0Jc3RydWN0IGRpbV9zYW1wbGUgZGltX3NhbXBsZTsNCj4g
KwlzdHJ1Y3QgZGltX3NhbXBsZSBkaW1fc2FtcGxlID0ge307DQo+IA0KPiAgCWlmICh1bmxpa2Vs
eSghdGVzdF9iaXQoTUxYNUVfU1FfU1RBVEVfQU0sICZzcS0+c3RhdGUpKSkNCj4gIAkJcmV0dXJu
Ow0KPiBAQCAtNjEsNyArNjEsNyBAQCBzdGF0aWMgdm9pZCBtbHg1ZV9oYW5kbGVfdHhfZGltKHN0
cnVjdCBtbHg1ZV90eHFzcQ0KPiAqc3EpDQo+ICBzdGF0aWMgdm9pZCBtbHg1ZV9oYW5kbGVfcnhf
ZGltKHN0cnVjdCBtbHg1ZV9ycSAqcnEpDQo+ICB7DQo+ICAJc3RydWN0IG1seDVlX3JxX3N0YXRz
ICpzdGF0cyA9IHJxLT5zdGF0czsNCj4gLQlzdHJ1Y3QgZGltX3NhbXBsZSBkaW1fc2FtcGxlOw0K
PiArCXN0cnVjdCBkaW1fc2FtcGxlIGRpbV9zYW1wbGUgPSB7fTsNCj4gDQo+ICAJaWYgKHVubGlr
ZWx5KCF0ZXN0X2JpdChNTFg1RV9SUV9TVEFURV9BTSwgJnJxLT5zdGF0ZSkpKQ0KPiAgCQlyZXR1
cm47DQo+IGRpZmYgLS1naXQgYS9saWIvZGltL2RpbS5jIGIvbGliL2RpbS9kaW0uYw0KPiBpbmRl
eCA0MzlkNjQxZWM3OTYuLjM4MDQ1ZDZkMDUzOCAxMDA2NDQNCj4gLS0tIGEvbGliL2RpbS9kaW0u
Yw0KPiArKysgYi9saWIvZGltL2RpbS5jDQo+IEBAIC03NCw4ICs3NCw4IEBAIHZvaWQgZGltX2Nh
bGNfc3RhdHMoc3RydWN0IGRpbV9zYW1wbGUgKnN0YXJ0LA0KPiBzdHJ1Y3QgZGltX3NhbXBsZSAq
ZW5kLA0KPiAgCQkJCQlkZWx0YV91cyk7DQo+ICAJY3Vycl9zdGF0cy0+Y3BtcyA9IERJVl9ST1VO
RF9VUChuY29tcHMgKiBVU0VDX1BFUl9NU0VDLA0KPiBkZWx0YV91cyk7DQo+ICAJaWYgKGN1cnJf
c3RhdHMtPmVwbXMgIT0gMCkNCg0KQlRXIHVucmVsYXRlZCB0byB0aGlzIGNoYW5nZWQgYnV0IGN1
cnJfc3RhdHMtPmVwbXMgIGNhbiBuZXZlciBiZSAwIGR1ZQ0KdG8gRElWX1JPVU5EX1VQLiB3ZSBj
YW4gc2F2ZSBhIGNvbmRpdGlvbiBoZXJlLg0KDQo+IC0JCWN1cnJfc3RhdHMtPmNwZV9yYXRpbyA9
DQo+IC0JCQkJKGN1cnJfc3RhdHMtPmNwbXMgKiAxMDApIC8gY3Vycl9zdGF0cy0NCj4gPmVwbXM7
DQo+ICsJCWN1cnJfc3RhdHMtPmNwZV9yYXRpbyA9IERJVl9ST1VORF9ET1dOX1VMTCgNCj4gKwkJ
CWN1cnJfc3RhdHMtPmNwbXMgKiAxMDAsIGN1cnJfc3RhdHMtPmVwbXMpOw0KPiAgCWVsc2UNCj4g
IAkJY3Vycl9zdGF0cy0+Y3BlX3JhdGlvID0gMDsNCj4gDQoNCkxHVE0sDQoNCkFja2VkLWJ5OiBT
YWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCg0KPiAtLQ0KPiAyLjIwLjENCj4g
DQo=
