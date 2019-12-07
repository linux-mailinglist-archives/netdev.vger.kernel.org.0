Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1606A115AE3
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 04:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfLGDxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 22:53:25 -0500
Received: from mail-eopbgr150059.outbound.protection.outlook.com ([40.107.15.59]:60386
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726388AbfLGDxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 22:53:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kd6B8GAxOGkAu56t/uf8FHu3FMHrYAmo6D3IKoN3qn7q0OwCSS/jdeG7M/vpX+BVFeq4uaDfn1A2X6U68lHXsPwezONwCqZlLpZOPQxUVx7Ucgx+T2HeubIZOkOQMThhN0UlijdgwqPHsZyfltfvQC7QrmTwiUMTLDm8Vijipk1q0vqZrUsAm21jCOSRthW7klPjn3PMLxBisHqGom3Rq2ypnY2pCyKphpmM3otx4+Dhjup94HQOXl1IcuiFgoFz5jqfhASiu2gNk2EgbcKv7CJdK39pMN6EnhymDLZhguaXjaJ3ImPp2M1ycdIKJ3BilQHPXB/PinJ6HK3Kd8j1mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKjJu+r+euB/DMeFcViV7mFtXESmeHyeY7zSenez3p0=;
 b=AFvvl7/31jsBHb4SOtEpMZ9EhROvlfD6imhl+sDtyDfgRbAD5U8HBrkM/iR/BPBDM9ptipNeU0b+XIBQflfQ/d5Q3G6wD5gru3x4+fZ2XkPX/l25v9y8FucCYIgFQMssZ/vKnN441ELPJSX7jYVn7ejYXzA4rRnuQpgAY4sBBOfbjyI2N5wdUu+waHDb7Y3EFHGPJ8BXj/GpR/hK98hd4802qw90lCJiGFgvfvM0tbeyej+UEDzODFOtjg8RuMGxSXypGSLEaeGMbHJ68Py86n78TwCNr8CewoFSBKXNHFpZEG6MQVwCH89UDY5BLFoP4V9WIL9jps2zjlkkqptptQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKjJu+r+euB/DMeFcViV7mFtXESmeHyeY7zSenez3p0=;
 b=I+hpCl2kj3DFIRHmBME280OWf3KMtZX8FCr2x71eXNISy93NhwKXXIvegj+lIY5hMnQ/NXi3ypST15H/I3lFQ5MUHFi80UdAAo4sS+e01+L+Pwr+nam3uoFU1WHmkNGTJDx60XOQ0opRy9X9rLhK1uIzeUi+x5TBCv6nHitVGu8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5069.eurprd05.prod.outlook.com (20.177.50.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Sat, 7 Dec 2019 03:52:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2516.017; Sat, 7 Dec 2019
 03:52:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Topic: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Index: AQHVrBgioGDhH/MP9UuNcNvu7zNf3aeuC1gA
Date:   Sat, 7 Dec 2019 03:52:41 +0000
Message-ID: <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f3f61f98-b5c0-4409-9d68-08d77ac8e8fa
x-ms-traffictypediagnostic: VI1PR05MB5069:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB5069869BA92FE51F2A0A9F48BE5E0@VI1PR05MB5069.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-forefront-prvs: 0244637DEA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(189003)(199004)(102836004)(6506007)(76176011)(99286004)(26005)(478600001)(76116006)(66476007)(66556008)(66946007)(305945005)(5660300002)(186003)(6512007)(64756008)(91956017)(66446008)(8936002)(229853002)(81166006)(81156014)(8676002)(2616005)(6486002)(118296001)(58126008)(110136005)(2906002)(86362001)(36756003)(316002)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5069;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Tz8g5ZOzWYadbs2eYVbp3dcyuak+aB0m8S4vsAxbcd9dfsQ5XjJptMJRqGuGddWO8WUBY1BMHnMqsUwTcTXGMn+ZovHzwuwbkjWLz/16GnZG2VTNh+cFt7mHcr/Vq/UWp6CsszT+Bq7doWEw2avayZzBc1Amr4Pbr46zmNe86z3dmP2GsaaD8hW2m+UiPJlB4vWSvtaDxkGXhRHoxJF7atag9NnsgDmjY7uVp5/gG9y0lyg50bqvzLQ7QIgLdWQ2guHCmun7erCywC2BznkyEiM0jL7rhdx/IAHetxNTqUjIOOUa6FwR7nZW1LvwtptC7NLSoxQRbvUr4Fx5K416IyGP4xKZrT5rPhN0iLCRWyrtS2ia24Vgnz0wXciIYY+ekyhBKFdtoxHTLe52kkm4oRqdjbE0QfLV+1n7ZeSCmj8cPnV+X8Z64rQ+mgTCjUb
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <56E3FA04C41434459BCA7A2A8764B6BA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f61f98-b5c0-4409-9d68-08d77ac8e8fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2019 03:52:41.4335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7WAo1GpnMM6cR2KrAG4qN1LL6O50GIrjCQalU9QU5rgKfs+KjG+ZBULSRQNvu+b/Gtga9noQpXGG0FfiULdAcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEyLTA2IGF0IDE3OjMyICswODAwLCBMaSBSb25nUWluZyB3cm90ZToNCj4g
c29tZSBkcml2ZXJzIHVzZXMgcGFnZSBwb29sLCBidXQgbm90IHJlcXVpcmUgdG8gYWxsb2NhdGUN
Cj4gcGFnZXMgZnJvbSBib3VuZCBub2RlLCBvciBzaW1wbHkgYXNzaWduIHBvb2wucC5uaWQgdG8N
Cj4gTlVNQV9OT19OT0RFLCBhbmQgdGhlIGNvbW1pdCBkNTM5NDYxMGIxYmEgKCJwYWdlX3Bvb2w6
DQo+IERvbid0IHJlY3ljbGUgbm9uLXJldXNhYmxlIHBhZ2VzIikgd2lsbCBibG9jayB0aGlzIGtp
bmQNCj4gb2YgZHJpdmVyIHRvIHJlY3ljbGUNCj4gDQo+IHNvIHRha2UgcGFnZSBhcyByZXVzYWJs
ZSB3aGVuIHBhZ2UgYmVsb25ncyB0byBjdXJyZW50DQo+IG1lbW9yeSBub2RlIGlmIG5pZCBpcyBO
VU1BX05PX05PREUNCj4gDQo+IHYxLS0+djI6IGFkZCBjaGVjayB3aXRoIG51bWFfbWVtX2lkIGZy
b20gWXVuc2hlbmcNCj4gDQo+IEZpeGVzOiBkNTM5NDYxMGIxYmEgKCJwYWdlX3Bvb2w6IERvbid0
IHJlY3ljbGUgbm9uLXJldXNhYmxlIHBhZ2VzIikNCj4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1Fp
bmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiBTdWdnZXN0ZWQtYnk6IFl1bnNoZW5nIExpbiA8
bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4NCj4gQ2M6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVs
bGFub3guY29tPg0KPiAtLS0NCj4gIG5ldC9jb3JlL3BhZ2VfcG9vbC5jIHwgNyArKysrKystDQo+
ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvbmV0L2NvcmUvcGFnZV9wb29sLmMgYi9uZXQvY29yZS9wYWdlX3Bvb2wuYw0K
PiBpbmRleCBhNmFlZmU5ODkwNDMuLjNjOGI1MWNjZDFjMSAxMDA2NDQNCj4gLS0tIGEvbmV0L2Nv
cmUvcGFnZV9wb29sLmMNCj4gKysrIGIvbmV0L2NvcmUvcGFnZV9wb29sLmMNCj4gQEAgLTMxMiwx
MiArMzEyLDE3IEBAIHN0YXRpYyBib29sIF9fcGFnZV9wb29sX3JlY3ljbGVfZGlyZWN0KHN0cnVj
dA0KPiBwYWdlICpwYWdlLA0KPiAgLyogcGFnZSBpcyBOT1QgcmV1c2FibGUgd2hlbjoNCj4gICAq
IDEpIGFsbG9jYXRlZCB3aGVuIHN5c3RlbSBpcyB1bmRlciBzb21lIHByZXNzdXJlLg0KPiAocGFn
ZV9pc19wZm1lbWFsbG9jKQ0KPiAgICogMikgYmVsb25ncyB0byBhIGRpZmZlcmVudCBOVU1BIG5v
ZGUgdGhhbiBwb29sLT5wLm5pZC4NCj4gKyAqIDMpIGJlbG9uZ3MgdG8gYSBkaWZmZXJlbnQgbWVt
b3J5IG5vZGUgdGhhbiBjdXJyZW50IGNvbnRleHQNCj4gKyAqIGlmIHBvb2wtPnAubmlkIGlzIE5V
TUFfTk9fTk9ERQ0KPiAgICoNCj4gICAqIFRvIHVwZGF0ZSBwb29sLT5wLm5pZCB1c2VycyBtdXN0
IGNhbGwgcGFnZV9wb29sX3VwZGF0ZV9uaWQuDQo+ICAgKi8NCj4gIHN0YXRpYyBib29sIHBvb2xf
cGFnZV9yZXVzYWJsZShzdHJ1Y3QgcGFnZV9wb29sICpwb29sLCBzdHJ1Y3QgcGFnZQ0KPiAqcGFn
ZSkNCj4gIHsNCj4gLQlyZXR1cm4gIXBhZ2VfaXNfcGZtZW1hbGxvYyhwYWdlKSAmJiBwYWdlX3Rv
X25pZChwYWdlKSA9PSBwb29sLQ0KPiA+cC5uaWQ7DQo+ICsJcmV0dXJuICFwYWdlX2lzX3BmbWVt
YWxsb2MocGFnZSkgJiYNCj4gKwkJKHBhZ2VfdG9fbmlkKHBhZ2UpID09IHBvb2wtPnAubmlkIHx8
DQo+ICsJCShwb29sLT5wLm5pZCA9PSBOVU1BX05PX05PREUgJiYNCj4gKwkJcGFnZV90b19uaWQo
cGFnZSkgPT0gbnVtYV9tZW1faWQoKSkpOw0KPiAgfQ0KPiAgDQoNCkNjJ2VkIEplc3BlciwgSWxp
YXMgJiBKb25hdGhhbi4NCg0KSSBkb24ndCB0aGluayBpdCBpcyBjb3JyZWN0IHRvIGNoZWNrIHRo
YXQgdGhlIHBhZ2UgbmlkIGlzIHNhbWUgYXMNCm51bWFfbWVtX2lkKCkgaWYgcG9vbCBpcyBOVU1B
X05PX05PREUuIEluIHN1Y2ggY2FzZSB3ZSBzaG91bGQgYWxsb3cgYWxsDQpwYWdlcyB0byByZWN5
Y2xlLCBiZWNhdXNlIHlvdSBjYW4ndCBhc3N1bWUgd2hlcmUgcGFnZXMgYXJlIGFsbG9jYXRlZA0K
ZnJvbSBhbmQgd2hlcmUgdGhleSBhcmUgYmVpbmcgaGFuZGxlZC4NCg0KSSBzdWdnZXN0IHRoZSBm
b2xsb3dpbmc6DQoNCnJldHVybiAhcGFnZV9wZm1lbWFsbG9jKCkgJiYgDQooIHBhZ2VfdG9fbmlk
KHBhZ2UpID09IHBvb2wtPnAubmlkIHx8IHBvb2wtPnAubmlkID09IE5VTUFfTk9fTk9ERSApOw0K
DQoxKSBuZXZlciByZWN5Y2xlIGVtZXJnZW5jeSBwYWdlcywgcmVnYXJkbGVzcyBvZiBwb29sIG5p
ZC4NCjIpIGFsd2F5cyByZWN5Y2xlIGlmIHBvb2wgaXMgTlVNQV9OT19OT0RFLg0KDQp0aGUgYWJv
dmUgY2hhbmdlIHNob3VsZCBub3QgYWRkIGFueSBvdmVyaGVhZCwgYSBtb2Rlc3QgYnJhbmNoIHBy
ZWRpY3Rvcg0Kd2lsbCBoYW5kbGUgdGhpcyB3aXRoIG5vIGVmZm9ydC4NCg0KSmVzcGVyIGV0IGFs
LiB3aGF0IGRvIHlvdSB0aGluaz8NCg0KLVNhZWVkLg0K
