Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F57D11BEAB
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 21:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLKU5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 15:57:23 -0500
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:44046
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbfLKU5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 15:57:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DK+R3VQck3l2n0KkIxux1a82D0clqzl4Yc1yPfZh7FmKWJ/J++X5xRFF6MexNGheGo+/pIWZgn5fii9zxHQZsgsEW377YNI2A7aGOBYEnrHjoyFETpMYByeV2gXOPFekSa/N9guBYUW7jKLosI7pUA9xGPMWK8Jg+1NCp63uvrrsM1lj8Jb2+VjyOrVj8vBMAKT+cAn9nt3a8BasLVkXvHKdOk4gOGuD5cy+wtpE6w0rr6yFp8+lgl51+/Emfg9njUtCmObg5x5SzNlRjxq10XBbXhS0UtjjX1/SxdkqCHa8yq+JeIAav3GePD5vnf3zwd34WXKWCZkG+j5Cd2UtGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ln77k4f2/20SxOf4qKodKuMNCuQE1HICgc8qfytHAN4=;
 b=eNAeuHWmdWn7xg8FGqdmUXsDWRa/uA9FssWnQ5mddYVEAZbuyt8eUjBnHiMw+3DevHctxY87T69sekoLVzBqJsZhr2wqnCe0X19E3UlS22PQPqbNhtwrKWrCbodGtfV+q5Jq6wxjDMmViNviL2CuUuHES1PnWY4RfqPLsWB5Bt3C5sN1QqwmVczPHyMpkONFKheqW/K6xwak+ZM1bLp3bX0e2f43LeWVirzOdiWB6Gh77JvjVNljQXcMfzOAsFMsqHtkw42XzrBS2A0NVIvv9FP6Dolent6O+9eOHmzXGQ9USiGsxjnAjL0VNw1VnN0AE2E9JtT3guZhHwT6ggA2ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ln77k4f2/20SxOf4qKodKuMNCuQE1HICgc8qfytHAN4=;
 b=KHHrmn2Jfw+VBmPPXNeRyGMrr4s/8Yx/jpfksGUXfMz49x24PDYW5hHPdFOGFLWGVs9jrYK1StkzWWRNd5Rj+P6GjtGMrozGbE1FUDyND66xRsHh4ooTDO5ZPz5hBYFstReLRhWTtTqZXFz43/9STPKK7QdvdE/xQV3C16rjZmQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4638.eurprd05.prod.outlook.com (20.176.7.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Wed, 11 Dec 2019 20:57:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2516.019; Wed, 11 Dec 2019
 20:57:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Topic: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Index: AQHVrBgioGDhH/MP9UuNcNvu7zNf3aeuC1gAgAOw0QCAAL3ugIAAIMwAgAExqICAAHnFgIABLJcA
Date:   Wed, 11 Dec 2019 20:57:16 +0000
Message-ID: <a6c43e98662b24574cb1e996fcccad196b9e2bcd.camel@mellanox.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
         <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
         <20191209131416.238d4ae4@carbon>
         <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
         <e9855bd9-dddd-e12c-c889-b872702f80d1@huawei.com>
         <585eda1ebe8788959b31bca5bb6943908c08c909.camel@mellanox.com>
         <910156da-0b43-0a86-67a0-f4e7e6547373@huawei.com>
In-Reply-To: <910156da-0b43-0a86-67a0-f4e7e6547373@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 25e0635a-95cf-4ade-0400-08d77e7cb481
x-ms-traffictypediagnostic: VI1PR05MB4638:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB4638FE43A2D098A55E720753BE5A0@VI1PR05MB4638.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(199004)(189003)(6512007)(71200400001)(8676002)(8936002)(81156014)(81166006)(478600001)(2616005)(6486002)(2906002)(76116006)(36756003)(5660300002)(54906003)(26005)(316002)(6506007)(4001150100001)(53546011)(110136005)(66556008)(186003)(66476007)(86362001)(4326008)(64756008)(66446008)(91956017)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4638;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FA0u+1/RrKj8P7W9j4vQNhhjaEcEJjaCY1zJUV56uLTZQntckzuDbwtZMrMbK7g3VX97A8uvodQthJRNEZu48tiO5lo5Ca0r4yjyW1KMbtD7wwOQlEFgg2M7lkoEiPEfkYoaqos3GaIPqidq6c7jAOBFxwNxvOO+tLTB4PH86A/x08CGVI/mSqQbfd0kfifURnCLmbJePZJQJhz9FV97KdhfPX90YU0DETj0UYlvZcOXwot68w1WYCgYSaxa+Ee6dE9fc0qVZ4j9pU9thM8LCkikzGvzAI5VpMGMIGn/0VKQr3ASKIEEi1AUxfqTE0LTnzZaqdErft5fRplv9YgJ775zwcck3S4MJhTNqQQtFLkccWaJM6XrfT9Zu9TvJwX/MDCTgkowdq3ktq9YQy/NtociO5DPw+nUIpehoxD+shLIM9rhMw6/5PqYs597+GvZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4ED713FFFD94D4DB953CB12D172CF54@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e0635a-95cf-4ade-0400-08d77e7cb481
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 20:57:16.4854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LrpPcKjSH7vOYxO+4f6Ust9dNYuGQ29sZPEUcy0YJlcFkhV1C2M6rh0yhOVewCSRU/nZMPE/le0fT3YoB1gJaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTExIGF0IDExOjAxICswODAwLCBZdW5zaGVuZyBMaW4gd3JvdGU6DQo+
IE9uIDIwMTkvMTIvMTEgMzo0NSwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+ID4gPiA+IG1heWJl
IGFzc3VtZSB0aGF0IF9fcGFnZV9wb29sX3JlY3ljbGVfZGlyZWN0KCkgaXMgYWx3YXlzIGNhbGxl
ZA0KPiA+ID4gPiBmcm9tDQo+ID4gPiA+IHRoZSByaWdodCBub2RlIGFuZCBjaGFuZ2UgdGhlIGN1
cnJlbnQgYm9ndXMgY2hlY2s6DQo+ID4gPiA+IA0KPiA+ID4gPiBmcm9tOg0KPiA+ID4gPiBwYWdl
X3RvX25pZChwYWdlKSA9PSBwb29sLT5wLm5pZCANCj4gPiA+ID4gDQo+ID4gPiA+IHRvOg0KPiA+
ID4gPiBwYWdlX3RvX25pZChwYWdlKSA9PSBudW1hX21lbV9pZCgpDQo+ID4gPiA+IA0KPiA+ID4g
PiBUaGlzIHdpbGwgYWxsb3cgcmVjeWNsaW5nIG9ubHkgaWYgaGFuZGxpbmcgbm9kZSBpcyB0aGUg
c2FtZSBhcw0KPiA+ID4gPiB3aGVyZQ0KPiA+ID4gPiB0aGUgcGFnZSB3YXMgYWxsb2NhdGVkLCBy
ZWdhcmRsZXNzIG9mIHBvb2wtPnAubmlkLg0KPiA+ID4gPiANCj4gPiA+ID4gc28gc2VtYW50aWNz
IGFyZToNCj4gPiA+ID4gDQo+ID4gPiA+IDEpIGFsbG9jYXRlIGZyb206IHBvb2wtPnAubmlkLCBh
cyBjaG9zZW4gYnkgdXNlci4NCj4gPiA+ID4gMikgcmVjeWNsZSB3aGVuOiBwYWdlX3RvX25pZChw
YWdlKSA9PSBudW1hX21lbV9pZCgpLg0KPiA+ID4gPiAzKSBwb29sIHVzZXIgbXVzdCBndWFyYW50
ZWUgdGhhdCB0aGUgaGFuZGxlciB3aWxsIHJ1biBvbiB0aGUNCj4gPiA+ID4gcmlnaHQNCj4gPiA+
ID4gbm9kZS4gd2hpY2ggc2hvdWxkIGFsd2F5cyBiZSB0aGUgY2FzZS4gb3RoZXJ3aXNlIHJlY3lj
bGluZyB3aWxsDQo+ID4gPiA+IGJlDQo+ID4gPiA+IHNraXBwZWQgKG5vIGNyb3NzIG51bWEgcmVj
eWNsaW5nKS4NCj4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBhKSBpZiB0aGUgcG9vbCBtaWdy
YXRlcywgd2Ugd2lsbCBzdG9wIHJlY3ljbGluZyB1bnRpbCB0aGUgcG9vbA0KPiA+ID4gPiBtb3Zl
cw0KPiA+ID4gPiBiYWNrIHRvIG9yaWdpbmFsIG5vZGUsIG9yIHVzZXIgY2FsbHMgcG9vbF91cGRh
dGVfbmlkKCkgYXMgd2UgZG8NCj4gPiA+ID4gaW4NCj4gPiA+ID4gbWx4NS4NCj4gPiA+ID4gYikg
aWYgcG9vbCBpcyBOVU1BX05PX05PREUsIHRoZW4gYWxsb2NhdGlvbiBhbmQgaGFuZGxpbmcgd2ls
bA0KPiA+ID4gPiBiZQ0KPiA+ID4gPiBkb25lDQo+ID4gPiA+IG9uIG51bWFfbWVtX2lkKCksIHdo
aWNoIG1lYW5zIHRoZSBhYm92ZSBjaGVjayB3aWxsIHdvcmsuDQo+ID4gPiANCj4gPiA+IE9ubHkg
Y2hlY2tpbmcgcGFnZV90b19uaWQocGFnZSkgPT0gbnVtYV9tZW1faWQoKSBtYXkgbm90IHdvcmsg
Zm9yDQo+ID4gPiB0aGUNCj4gPiA+IGJlbG93DQo+ID4gPiBjYXNlIGluIG12bmV0YS5jOg0KPiA+
ID4gDQo+ID4gPiBzdGF0aWMgaW50IG12bmV0YV9jcmVhdGVfcGFnZV9wb29sKHN0cnVjdCBtdm5l
dGFfcG9ydCAqcHAsDQo+ID4gPiAJCQkJICAgc3RydWN0IG12bmV0YV9yeF9xdWV1ZSAqcnhxLCBp
bnQNCj4gPiA+IHNpemUpDQo+ID4gPiB7DQo+ID4gPiAJc3RydWN0IGJwZl9wcm9nICp4ZHBfcHJv
ZyA9IFJFQURfT05DRShwcC0+eGRwX3Byb2cpOw0KPiA+ID4gCXN0cnVjdCBwYWdlX3Bvb2xfcGFy
YW1zIHBwX3BhcmFtcyA9IHsNCj4gPiA+IAkJLm9yZGVyID0gMCwNCj4gPiA+IAkJLmZsYWdzID0g
UFBfRkxBR19ETUFfTUFQIHwgUFBfRkxBR19ETUFfU1lOQ19ERVYsDQo+ID4gPiAJCS5wb29sX3Np
emUgPSBzaXplLA0KPiA+ID4gCQkubmlkID0gY3B1X3RvX25vZGUoMCksDQo+ID4gPiAJCS5kZXYg
PSBwcC0+ZGV2LT5kZXYucGFyZW50LA0KPiA+ID4gCQkuZG1hX2RpciA9IHhkcF9wcm9nID8gRE1B
X0JJRElSRUNUSU9OQUwgOg0KPiA+ID4gRE1BX0ZST01fREVWSUNFLA0KPiA+ID4gCQkub2Zmc2V0
ID0gcHAtPnJ4X29mZnNldF9jb3JyZWN0aW9uLA0KPiA+ID4gCQkubWF4X2xlbiA9IE1WTkVUQV9N
QVhfUlhfQlVGX1NJWkUsDQo+ID4gPiAJfTsNCj4gPiA+IA0KPiA+ID4gdGhlIHBvb2wtPnAubmlk
IGlzIG5vdCBOVU1BX05PX05PREUsIHRoZW4gdGhlIG5vZGUgb2YgcGFnZQ0KPiA+ID4gYWxsb2Nh
dGVkDQo+ID4gPiBmb3IgcngNCj4gPiA+IG1heSBub3QgYmUgbnVtYV9tZW1faWQoKSB3aGVuIHJ1
bm5pbmcgaW4gdGhlIE5BUEkgcG9sbGluZywNCj4gPiA+IGJlY2F1c2UNCj4gPiA+IHBvb2wtPnAu
bmlkDQo+ID4gPiBpcyBub3QgdGhlIHNhbWUgYXMgdGhlIG5vZGUgb2YgY3B1IHJ1bm5pbmcgaW4g
dGhlIE5BUEkgcG9sbGluZy4NCj4gPiA+IA0KPiA+ID4gRG9lcyB0aGUgcGFnZSBwb29sIHN1cHBv
cnQgcmVjeWNsaW5nIGZvciBhYm92ZSBjYXNlPw0KPiA+ID4gDQo+ID4gDQo+ID4gSSBkb24ndCB0
aGluayB5b3Ugd2FudCB0byBhbGxvdyBjcm9zcyBudW1hIHJlY3ljbGluZy4NCj4gDQo+IENyb3Nz
IG51bWEgcmVjeWNsaW5nIGlzIG5vdCB3aGF0IEkgd2FudC4NCj4gDQo+ID4gPiBPciB3ZSAiZml4
JyB0aGUgYWJvdmUgY2FzZSBieSBzZXR0aW5nIHBvb2wtPnAubmlkIHRvDQo+ID4gPiBOVU1BX05P
X05PREUvZGV2X3RvX25vZGUoKSwNCj4gPiA+IG9yIGJ5IGNhbGxpbmcgcG9vbF91cGRhdGVfbmlk
KCkgaW4gTkFQSSBwb2xsaW5nIGFzIG1seDUgZG9lcz8NCj4gPiA+IA0KPiA+IA0KPiA+IFllcyBq
dXN0IHVwZGF0ZV9uaWQgd2hlbiBuZWVkZWQsIGFuZCBtYWtlIHN1cmUgdGhlIE5BUEkgcG9sbGlu
Zw0KPiA+IHJ1bnMgb24NCj4gPiBhIGNvbnNpc3RlbnQgY29yZSBhbmQgZXZlbnR1YWxseSBhbGxv
Yy9yZWN5Y2xpbmcgd2lsbCBoYXBwZW4gb24gdGhlDQo+ID4gc2FtZSBjb3JlLg0KPiANCj4gVG8g
bWUsIHBhc3NpbmcgTlVNQV9OT19OT0RFL2Rldl90b19ub2RlKCkgc2VlbXMgdG8gYWx3YXlzIHdv
cmsuDQo+IENhbGxpbmcgcG9vbF91cGRhdGVfbmlkKCkgaW4gTkFQSSBwb2xsaW5nIGlzIGFub3Ro
ZXIgd2F5IG9mIHBhc3NpbmcNCj4gTlVNQV9OT19OT0RFIHRvIHBhZ2VfcG9vbF9pbml0KCkuDQo+
IA0KPiBBbmQgaXQgc2VlbXMgaXQgaXMgYSBjb3B5ICYgcGFzdGUgcHJvYmxlbSBmb3IgbXZuZXRh
IGFuZCBuZXRzZWMNCj4gZHJpdmVyIHRoYXQgdXNlcyBjcHVfdG9fbm9kZSgwKSBhcyBwb29sLT5w
Lm5pZCBidXQgZG9lcyBub3QgY2FsbA0KPiBwYWdlX3Bvb2xfbmlkX2NoYW5nZWQoKSBpbiB0aGUg
TkFQSSBwb2xsaW5nIGFzIG1seDUgZG9lcy4NCj4gDQo+IFNvIEkgc3VnZ2VzdCB0byByZW1vdmUg
cGFnZV9wb29sX25pZF9jaGFuZ2VkKCkgYW5kIGFsd2F5cyB1c2UNCj4gTlVNQV9OT19OT0RFL2Rl
dl90b19ub2RlKCkgYXMgcG9vbC0+cC5uaWQgb3IgbWFrZSBpdCBjbGVhciAoDQo+IGJ5IGNvbW1l
bnQgb3Igd2FybmluZz8pdGhhdCBwYWdlX3Bvb2xfbmlkX2NoYW5nZWQoKSBzaG91bGQgYmUNCj4g
Y2FsbGVkIHdoZW4gcG9vbC0+cC5uaWQgaXMgTlVNQV9OT19OT0RFL2Rldl90b19ub2RlKCkuDQo+
IA0KDQpub3QgYW4gb3B0aW9uLg0KDQpyeCByaW5ncyBzaG91bGQgYWx3YXlzIGFsbG9jYXRlIGRh
dGEgYnVmZmVycyBhY2NvcmRpbmcgdG8gdGhlaXIgY3B1DQphZmZpbml0eSBhbmQgbm90IGRldl9u
b2RlIG9yIGRlZmF1bHQgdG8gTlVNQV9OT19OT0RFLg0KDQo+IEkgcHJlZmVyIHRvIHJlbW92ZSBw
YWdlX3Bvb2xfbmlkX2NoYW5nZWQoKSBpZiB3ZSBkbyBub3QgYWxsb3cNCj4gY3Jvc3MgbnVtYSBy
ZWN5Y2xpbmcuDQo+IA0KDQpUaGlzIGlzIG5vdCBmb3IgY3Jvc3MgbnVtYSByZWN5Y2xpbmcuIA0K
U2luY2UgcnggcmluZ3MgY2FuIG1pZ3JhZ3RlIGJldHdlZW4gY29yZXMsIChtc2l4IGFmZmluaXR5
L0lSUSBiYWxhbmNlcikNCndlIG5lZWQgcGFnZV9wb29sX25pZF9jaGFuZ2VkKCkgZm9yIHNlYW1s
ZXNzIG1pZ3JhdGlvbiBhbmQgZm9yDQpyZWN5Y2xpbmcgYW5kIGFsbG9jYXRpb24gdG8gbWlncmF0
ZSB3aXRoIHRoZSByaW5nLg0KDQo+IA0KPiA+ID4gPiBUaGFua3MsDQo+ID4gPiA+IFNhZWVkLg0K
PiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+
IA0KPiA+ID4gPiANCg==
