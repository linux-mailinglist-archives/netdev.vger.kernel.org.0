Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB22D314DB
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfEaSlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:41:09 -0400
Received: from mail-eopbgr10073.outbound.protection.outlook.com ([40.107.1.73]:9617
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727005AbfEaSlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 14:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXX00jixJC3ZGUkrwdttqpgKlTVJNbATOjUNBBZ38nY=;
 b=Hfpt2IBlsW79rRWDa/fyar0a8xE06SnFS9vx4IlUMIP0iYqEMkJGvslU2uo4zTLn48fFnT6Pg7XBQcc7tnPRxp+d9AvbcaCaZwRMUYsr6FLYbqdk//RMRZBpbX5ZeDmbYnP6BrkPWcKkASF/OnZBIPHb6hNk763NDUQHhgthpsc=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB5470.eurprd05.prod.outlook.com (20.177.201.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 31 May 2019 18:41:05 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 18:41:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net-next 3/3] net/mlx5e: use indirect calls wrapper for
 the rx packet handler
Thread-Topic: [PATCH net-next 3/3] net/mlx5e: use indirect calls wrapper for
 the rx packet handler
Thread-Index: AQHVF6/4VAYmWlhnRkKw8SyQ069a9KaFkWsA
Date:   Fri, 31 May 2019 18:41:04 +0000
Message-ID: <1b740c86d3917640657934961b40fe4b288c2a40.camel@mellanox.com>
References: <cover.1559304330.git.pabeni@redhat.com>
         <74fb497974fe8267c2c5f0a1422a418363f0c50f.1559304330.git.pabeni@redhat.com>
In-Reply-To: <74fb497974fe8267c2c5f0a1422a418363f0c50f.1559304330.git.pabeni@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30a873fd-0cd6-44ad-9f45-08d6e5f789d2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5470;
x-ms-traffictypediagnostic: VI1PR05MB5470:
x-microsoft-antispam-prvs: <VI1PR05MB54706F5F5517D4161313E9CFBE190@VI1PR05MB5470.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(39860400002)(346002)(136003)(366004)(199004)(189003)(64756008)(6512007)(66556008)(91956017)(110136005)(36756003)(6506007)(81156014)(6486002)(58126008)(81166006)(66476007)(73956011)(8676002)(66946007)(76116006)(8936002)(54906003)(186003)(508600001)(66446008)(256004)(6436002)(14454004)(229853002)(26005)(14444005)(71190400001)(102836004)(305945005)(71200400001)(25786009)(7736002)(4326008)(6246003)(486006)(316002)(76176011)(53936002)(99286004)(2906002)(5660300002)(6116002)(3846002)(118296001)(2501003)(11346002)(66066001)(476003)(446003)(86362001)(2616005)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5470;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: v2/xi37ljD1tvmJC+UUFrxRa+Oz7xLJ3y48ey2AMt2B0MeZemwQvaEEGJEZqnOLla9BbB6bH19c1Pf5FG8q74Fpn0YEl84QNiywfps34RolJs8NgBAbvxLwTJhBWD1wkDqE02apG7HkcBxNTI35ibn0j73HvCFmgu7FDkgIFSNcxFxhIYbR8hYSviyu91sR9ABTzz0tGRDJnlfsMUKVb1C6CZpHC7DVHsQU9jOLMI+wLHrrsrBU0AiLkiZzkFrUJ/kLtKeaASL/YkvThdAA5jJeUtGaxgR9//WjCa8V1c9drsVgj706pB7MXVTPmP8oMbsG9mk/ZkmaWe1rjXB5kOfU8HGG4qv1yeZcJw9pWB6LMvLPuJtbcSd6gejh5dM4BDpd9he2SnTesvKpPS+nI/e2HDw8t2LN4DjI+y9MiNl0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8F332E8C1458641939329F18AEE2546@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a873fd-0cd6-44ad-9f45-08d6e5f789d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 18:41:04.9799
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5470
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA1LTMxIGF0IDE0OjUzICswMjAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
V2UgY2FuIGF2b2lkIGFub3RoZXIgaW5kaXJlY3QgY2FsbCBwZXIgcGFja2V0IHdyYXBwaW5nIHRo
ZSByeA0KPiBoYW5kbGVyIGNhbGwgd2l0aCB0aGUgcHJvcGVyIGhlbHBlci4NCj4gDQo+IFRvIGVu
c3VyZSB0aGF0IGV2ZW4gdGhlIGxhc3QgbGlzdGVkIGRpcmVjdCBjYWxsIGV4cGVyaWVuY2UNCj4g
bWVhc3VyYWJsZSBnYWluLCBkZXNwaXRlIHRoZSBhZGRpdGlvbmFsIGNvbmRpdGlvbmFscyB3ZSBt
dXN0DQo+IHRyYXZlcnNlIGJlZm9yZSByZWFjaGluZyBpdCwgSSB0ZXN0ZWQgcmV2ZXJzaW5nIHRo
ZSBvcmRlciBvZiB0aGUNCj4gbGlzdGVkIG9wdGlvbnMsIHdpdGggcGVyZm9ybWFuY2UgZGlmZmVy
ZW5jZXMgYmVsb3cgbm9pc2UgbGV2ZWwuDQo+IA0KPiBUb2dldGhlciB3aXRoIHRoZSBwcmV2aW91
cyBpbmRpcmVjdCBjYWxsIHBhdGNoLCB0aGlzIGdpdmVzDQo+IH42JSBwZXJmb3JtYW5jZSBpbXBy
b3ZlbWVudCBpbiByYXcgVURQIHRwdXQuDQo+IA0KDQpOaWNlICEgSSBsaWtlIGl0Lg0KDQo+IFNp
Z25lZC1vZmYtYnk6IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4NCj4gLS0tDQo+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYyB8IDQgKysrLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9y
eC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMN
Cj4gaW5kZXggMGZlNWYxM2QwN2NjLi5jMzc1MmRiZTAwYzggMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yeC5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yeC5jDQo+IEBAIC0xMzMzLDcg
KzEzMzMsOSBAQCBpbnQgbWx4NWVfcG9sbF9yeF9jcShzdHJ1Y3QgbWx4NWVfY3EgKmNxLCBpbnQN
Cj4gYnVkZ2V0KQ0KPiAgDQo+ICAJCW1seDVfY3F3cV9wb3AoY3F3cSk7DQo+ICANCj4gLQkJcnEt
PmhhbmRsZV9yeF9jcWUocnEsIGNxZSk7DQo+ICsJCUlORElSRUNUX0NBTExfNChycS0+aGFuZGxl
X3J4X2NxZSwNCj4gbWx4NWVfaGFuZGxlX3J4X2NxZV9tcHdycSwNCj4gKwkJCQltbHg1ZV9oYW5k
bGVfcnhfY3FlLA0KPiBtbHg1ZV9oYW5kbGVfcnhfY3FlX3JlcCwNCj4gKwkJCQltbHg1ZV9pcHNl
Y19oYW5kbGVfcnhfY3FlLCBycSwgY3FlKTsNCg0KeW91IG1pc3NlZCBtbHg1aV9oYW5kbGVfcnhf
Y3FlLCBhbnl3YXkgZG9uJ3QgYWRkIElORElSRUNUX0NBTExfNSA6RA0KDQpqdXN0IHJlcGxhY2Ug
bWx4NWVfaGFuZGxlX3J4X2NxZV9yZXAgd2l0aCBtbHg1aV9oYW5kbGVfcnhfY3FlLCANCm1seDVl
X2hhbmRsZV9yeF9jcWVfcmVwIGlzIGFjdHVhbGx5IGEgc2xvdyBwYXRoIG9mIHN3aXRjaGRldiBt
b2RlLg0KDQpNYXliZSBkZWZpbmUgdGhlIGxpc3Qgc29tZXdoZXJlIGluIGVuLmggd2hlcmUgaXQg
aXMgdmlzaWJsZSBmb3IgZXZlcnkNCm9uZToNCg0KI2RlZmluZSBNTFg1X1JYX0lORElSRUNUX0NB
TExfTElTVCBcDQptbHg1ZV9oYW5kbGVfcnhfY3FlX21wd3JxLCBtbHg1ZV9oYW5kbGVfcnhfY3Fl
LCBtbHg1aV9oYW5kbGVfcnhfY3FlLA0KbWx4NWVfaXBzZWNfaGFuZGxlX3J4X2NxZQ0KDQphbmQg
aGVyZToNCklORElSRUNUX0NBTExfNChycS0+aGFuZGxlX3J4X2NxZSwgTUxYNV9SWF9JTkRJUkVD
VF9DQUxMX0xJU1QsIHJxLA0KY3FlKTsNCg0KPiAgCX0gd2hpbGUgKCgrK3dvcmtfZG9uZSA8IGJ1
ZGdldCkgJiYgKGNxZSA9DQo+IG1seDVfY3F3cV9nZXRfY3FlKGNxd3EpKSk7DQo+ICANCj4gIG91
dDoNCg==
