Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB9273DD4
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391147AbfGXTqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:46:51 -0400
Received: from mail-eopbgr40087.outbound.protection.outlook.com ([40.107.4.87]:38214
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391140AbfGXTqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 15:46:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLT16O9q/3e40J41VahKDncfkM4AdHQscOBJKz3KEJxOFYbQzF71GnwhKsqdMS2qBdt5qNWWXQzDMhazFdfRrMb4n9FPue61fXO2CSLbvYtHEIdcTWXLsbppnR+lPi+hqnlwmFogzBz4TdHVOHxudyg5M7PgREVHleGbgifPxLP5j8rTprs6y28FtbrVi0BOrWMCPUCH6IrjxZRDL3Il95xA9w5Wv14tygGe0RyJsFqCPdzaw1VdKlq/TVOFb8ZqBgerkMmV/M0u+351pcFhHOanvKJDoqzhQYY0vKt2UcHdZbPQijB2s3G23vmVJCon3FihHUwrHxjkTfFBVBxcpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNx2i5pcvH3aziJMHgWvHv6xGl85BzDYQN5G2r9Uzpc=;
 b=BL+/EZBVNPUmdjmn+/GyA4Yq7B0pqyvWyZ5lvTFPxE7L6VpVQkqUp/ZV4QFoGTR/xNhAY7DUf8N9jdgZkn42BrpmDtLsGxuP2cKk+zLrEt32/3qN7iZvftcMe4QAQg2jMo9sV7VxjcqTXmWRrf+MnagdbV9O8ZlcWB8omY9kyY7IdVfiJfWif5P/2h2cGzdmk5uNhxdyYtpt5Q7nsvGqZN5zc5MLRVzgkjkqIDgHg+0UxtM9S65OV2HYhXmi6xjzycjZnlsIBrv8I6W3c352dF5cKS5jKv25S55c2kDfTCR28jfo1q4kEe4klO6+mUdvCE9ZRc8pqepaMuv3QAzRyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNx2i5pcvH3aziJMHgWvHv6xGl85BzDYQN5G2r9Uzpc=;
 b=KidWAxScORetCOoc+xc8BkkRA2AByobi0hZcBzw93Tc6qSsDaFi/q6Y23sS5OkKl1qC26kr8o7OzgaUsUIufx7EbuSY1NsH50xAdkvmfXPx/eh+nqZfYqS5CPzD7JgamCjM1lE4Ph1rlF1Bi6aVOJOHjwq8ZkmZ1H/U9c5R18GQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2165.eurprd05.prod.outlook.com (10.168.55.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 19:46:46 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 19:46:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "peter_hong@fintek.com.tw" <peter_hong@fintek.com.tw>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "hpeter@gmail.com" <hpeter@gmail.com>
CC:     "hpeter+linux_kernel@gmail.com" <hpeter+linux_kernel@gmail.com>,
        "f.suligoi@asem.it" <f.suligoi@asem.it>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH V2 1/1] can: sja1000: f81601: add Fintek F81601 support
Thread-Topic: [PATCH V2 1/1] can: sja1000: f81601: add Fintek F81601 support
Thread-Index: AQHVQFXSPZ8Kh66+kkKJ1rNLgBa/e6bYvVkAgACAvICAAPJKAA==
Date:   Wed, 24 Jul 2019 19:46:45 +0000
Message-ID: <bbe907bf7fa1ebe1adfd6bdc9887e4c41ff624bd.camel@mellanox.com>
References: <1563776521-28317-1-git-send-email-hpeter+linux_kernel@gmail.com>
         <bb38703fa94f19578ac67f763bb1a0ad34196757.camel@mellanox.com>
         <37a8be8d-3ce7-e983-93da-35413cfb5da1@gmail.com>
In-Reply-To: <37a8be8d-3ce7-e983-93da-35413cfb5da1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ae5a4cf-b173-41e7-3b6e-08d7106fa923
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2165;
x-ms-traffictypediagnostic: DB6PR0501MB2165:
x-microsoft-antispam-prvs: <DB6PR0501MB21652FACF9AAC8A9040F0446BEC60@DB6PR0501MB2165.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(54534003)(51914003)(189003)(199004)(66946007)(2201001)(66066001)(66556008)(76176011)(81166006)(66476007)(66446008)(81156014)(446003)(76116006)(91956017)(64756008)(8936002)(4326008)(25786009)(7416002)(86362001)(14444005)(256004)(14454004)(54906003)(316002)(58126008)(478600001)(36756003)(110136005)(486006)(99286004)(53936002)(5660300002)(2906002)(6246003)(305945005)(476003)(6436002)(26005)(229853002)(6486002)(6506007)(102836004)(186003)(71200400001)(2501003)(68736007)(118296001)(6512007)(2616005)(3846002)(7736002)(6116002)(11346002)(8676002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2165;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /80DZ7n80xaMlcvA21GS2cn8WSzL67z6PGMGV9AfJSIIFk5m3AciS1QuQaCnUYUB14wEDdD+yY15yk5Y3caGes4dgvexbblFps8aXHFGg53wlCswI9LdIdF/mm3gE4vNU/wP9u5rEunEn2kXB59nk+XniC6PUYaFiHrrkCc9JoJ03eZhrvSULCqwuNzPBCteNURlCCkZLGvTk27MmwfgAw40zT67GtYZ/yQThWF23VyeabncGvinuIg9JzTxUrOeo8KmLAuwGpaTX1DxW+Pq7Sn2nZQKVGn4ypGLAD6XVDPItCad3xlZMqnca5mVu+B9XOPu9TPNH0uBZ/PJPrrq6pO/gal0BQnNw+NUyt3oY3hPBViuFH8le/JoFE9xz2/L5694tjRUmr0EQX81hu6XditScQUNEQ0zpJ7I2SoyDoI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18B299C888EC964D8E66BC19C63FE5D5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae5a4cf-b173-41e7-3b6e-08d7106fa923
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 19:46:46.0077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTI0IGF0IDEzOjE5ICswODAwLCBKaS1aZSBIb25nIChQZXRlciBIb25n
KSB3cm90ZToNCj4gSGksDQo+IA0KPiBTYWVlZCBNYWhhbWVlZCDmlrwgMjAxOS83LzI0IOS4iuWN
iCAwNTozOCDlr6vpgZM6DQo+ID4gT24gTW9uLCAyMDE5LTA3LTIyIGF0IDE0OjIyICswODAwLCBK
aS1aZSBIb25nIChQZXRlciBIb25nKSB3cm90ZToNCj4gPiA+IFRoaXMgcGF0Y2ggYWRkIHN1cHBv
cnQgZm9yIEZpbnRlayBQQ0lFIHRvIDIgQ0FOIGNvbnRyb2xsZXINCj4gPiA+IHN1cHBvcnQNCj4g
PiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogSmktWmUgSG9uZyAoUGV0ZXIgSG9uZykgPA0KPiA+
ID4gaHBldGVyK2xpbnV4X2tlcm5lbEBnbWFpbC5jb20NCj4gPiA+IC0tLQ0KPiA+ID4gQ2hhbmdl
bG9nOg0KPiA+ID4gdjI6DQo+ID4gPiAJMTogRml4IGNvbW1lbnQgb24gdGhlIHNwaW5sb2NrIHdp
dGggd3JpdGUgYWNjZXNzLg0KPiA+ID4gCTI6IFVzZSBBUlJBWV9TSVpFIGluc3RlYWQgb2YgRjgx
NjAxX1BDSV9NQVhfQ0hBTi4NCj4gPiA+IAkzOiBDaGVjayB0aGUgc3RyYXAgcGluIG91dHNpZGUg
dGhlIGxvb3AuDQo+ID4gPiAJNDogRml4IHRoZSBjbGVhbnVwIGlzc3VlIGluIGY4MTYwMV9wY2lf
YWRkX2NhcmQoKS4NCj4gPiA+IAk1OiBSZW1vdmUgdW51c2VkICJjaGFubmVscyIgaW4gc3RydWN0
IGY4MTYwMV9wY2lfY2FyZC4NCj4gPiA+IA0KPiA+ID4gICBkcml2ZXJzL25ldC9jYW4vc2phMTAw
MC9LY29uZmlnICB8ICAgOCArKw0KPiA+ID4gICBkcml2ZXJzL25ldC9jYW4vc2phMTAwMC9NYWtl
ZmlsZSB8ICAgMSArDQo+ID4gPiAgIGRyaXZlcnMvbmV0L2Nhbi9zamExMDAwL2Y4MTYwMS5jIHwg
MjE1DQo+ID4gPiANCg0KWy4uLl0gDQoNCj4gPiA+IA0KPiA+ID4gKwkvKiBEZXRlY3QgYXZhaWxh
YmxlIGNoYW5uZWxzICovDQo+ID4gPiArCWZvciAoaSA9IDA7IGkgPCBjb3VudDsgaSsrKSB7DQo+
ID4gPiArCQlkZXYgPSBhbGxvY19zamExMDAwZGV2KDApOw0KPiA+ID4gKwkJaWYgKCFkZXYpIHsN
Cj4gPiA+ICsJCQllcnIgPSAtRU5PTUVNOw0KPiA+ID4gKwkJCWdvdG8gZmFpbHVyZV9jbGVhbnVw
Ow0KPiA+ID4gKwkJfQ0KPiA+ID4gKw0KPiA+IA0KPiA+IGRvbid0IHlvdSBuZWVkIHRvIHJvbGxi
YWNrIGFuZCBjbGVhbnVwL3VucmVnaXN0ZXIgcHJldmlvdXNseQ0KPiA+IGFsbG9jYXRlZA0KPiA+
IGRldnMgPw0KPiA+IA0KPiANCj4gSSdsbCBkbyBjbGVhbnVwIHdoZW4gZXJyb3JzIGp1bXAgdG8g
ZmFpbHVyZV9jbGVhbnVwIGxhYmVsIGFuZCBkbw0KPiBmODE2MDFfcGNpX2RlbF9jYXJkKCkuDQo+
IA0KDQpSaWdodCAhLCB0aGFua3MgZm9yIHRoZSBjbGFyaWZpY2F0aW9uLiANCg==
