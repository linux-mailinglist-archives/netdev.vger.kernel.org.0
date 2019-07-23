Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF21722A0
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389655AbfGWWvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:51:47 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:5014
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728777AbfGWWvr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 18:51:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSBhqxHjKj6hNmmKmfAQhERfLNQMArn4YkLM8TZ5NN7/mmbQ8ljEt7r3WPgUirCClhJenRo4RoV80McAHZ2doPalV49y93Wgq69gq7Z2fIlgVrnslv+wzg3eTprjnBAURP/SDGYllGeGD235r3NzCkGor+bXgSMQ3BWEdDGoKuZKfUpP9WnxtXVMl0FYipqOR8j7v0gtRGk30wsoPFdgZB5dTNf1bS45lSY3Pmzdwhp4fDFkNS/icQ2Gs4PfRPdu/fD2Ce7vYy19nCis2jmPK7jY8fzeubjVXz50HBT9q+Xn10oM5SGUr6IwdMqfoW0g9gPGHAr3HLKi//fKb+7R/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xp0f8Uld8w08C9Rd9WnPqx1cEQgpDaRCOuQAb4Fw1I=;
 b=UJx6uJNoEkZtWK0EA83JlSz1N41ri2p7z9bQ26O8mYJzEgQyaAcMCNIo05Esy8U3jgHHKLfEtRSiaib2ReUr9oPl8CAK+Qhxze1E0bBoQkiO+LxdbR/pzpBjEIsQO5+yfSFO+GutGiPSxMoh/fMb5FYhcB6sx3R4+9ZT7ENd90AA7kVgxxVTmwppaQQ2VpNNGAp0qLjKZqwD8Ns5MVtxL9zKLZ0EI575QG1VZe3HL+vGQxh/lwu3/CskXywXQ9KfNXKOWFR49qIjNOSD6YNnRpCq/avwE08jw35IMAz5S4nKJ2a3C1VMK6d2zVeiFkPtimBcjJ6afE0eShuLM3sNVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xp0f8Uld8w08C9Rd9WnPqx1cEQgpDaRCOuQAb4Fw1I=;
 b=FVeInKezT/4bpvsIBPvExJv027xitLxsYNrZxT8MufhyZ6qWEtpgrxhx4dlJibAQ44C+pwR8xYsAnPpp9XNZYMnj6WeNWkpc+8dhrvgrLMa+8RPmwXPwPxQUVgywzc5EEdmC+sdd8XHAg/X6OLFOhg+d0piY8dICxVEG+nFZXuY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2406.eurprd05.prod.outlook.com (10.168.75.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Tue, 23 Jul 2019 22:51:42 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 22:51:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "snelson@pensando.io" <snelson@pensando.io>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
Thread-Topic: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
Thread-Index: AQHVQNYh0hIXTEJm+k+NKGK2L/AMCqbYutkAgAAV3AA=
Date:   Tue, 23 Jul 2019 22:51:42 +0000
Message-ID: <0c405a3a694bb8f40ef1df7087a220ee01442037.camel@mellanox.com>
References: <20190722214023.9513-1-snelson@pensando.io>
         <20190722214023.9513-12-snelson@pensando.io>
         <20190723.143326.197667027838462669.davem@davemloft.net>
In-Reply-To: <20190723.143326.197667027838462669.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfd1b767-583a-44fa-1246-08d70fc054f2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2406;
x-ms-traffictypediagnostic: DB6PR0501MB2406:
x-microsoft-antispam-prvs: <DB6PR0501MB2406B10C2539C19AB15A9505BEC70@DB6PR0501MB2406.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(199004)(189003)(99286004)(8936002)(81166006)(81156014)(316002)(64756008)(66066001)(110136005)(14444005)(58126008)(102836004)(3846002)(66446008)(76176011)(6506007)(6116002)(2501003)(68736007)(36756003)(2906002)(118296001)(4326008)(86362001)(486006)(6486002)(6512007)(6436002)(6246003)(7736002)(305945005)(8676002)(53936002)(76116006)(25786009)(91956017)(11346002)(71200400001)(186003)(476003)(2616005)(66556008)(66946007)(66476007)(5660300002)(26005)(229853002)(71190400001)(14454004)(256004)(478600001)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2406;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BeR1Ajb2YaLl/H+Tb63Hg1gWAdTRXCo5iQUF18kDzBvFfy8QcZ423YtPuTuTx7xACtuaiaLyNPRxLfnZbtbb5x9xMdnGg59O2kEiMjbJ/FAcJL6tb0cxaStljqx8qDRMvmpp4qN1kaNy7BNedVPytCZLPOKIgysvSg0ZbCM+wiToPTdnmrzT910KTTU4lWsDzXg58VkeiSZzi39bM7kh1Iv+KCL6eWoQaKFc+RSHIItA0gyRceaeHQLl7sUeLNjHx2azM1TYZIXMWOj5RQLzVpSOl7r2S6542fHJF+0q35ZbOMM0YBuXjjvT4mJR1kUX54W3mUPlkkwIHIMFpvxOgn35+7f42GYe1H0gpSGQ2EWnEw3CNl4J4o2C3Y1XXI1j8UoMjGdLYc0H7/xU26RD1hMit2CPSCerGeNYh0gXXDw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <609374F5EB40F8429FFDE7CC322234EC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd1b767-583a-44fa-1246-08d70fc054f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 22:51:42.8522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2406
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDE0OjMzIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNoYW5ub24gTmVsc29uIDxzbmVsc29uQHBlbnNhbmRvLmlvPg0KPiBEYXRlOiBNb24s
IDIyIEp1bCAyMDE5IDE0OjQwOjE1IC0wNzAwDQo+IA0KPiA+ICsJaWYgKGluX2ludGVycnVwdCgp
KSB7DQo+ID4gKwkJd29yayA9IGt6YWxsb2Moc2l6ZW9mKCp3b3JrKSwgR0ZQX0FUT01JQyk7DQo+
ID4gKwkJaWYgKCF3b3JrKSB7DQo+ID4gKwkJCW5ldGRldl9lcnIobGlmLT5uZXRkZXYsICIlcyBP
T01cbiIsIF9fZnVuY19fKTsNCj4gPiArCQkJcmV0dXJuIC1FTk9NRU07DQo+ID4gKwkJfQ0KPiA+
ICsJCXdvcmstPnR5cGUgPSBhZGQgPyBEV19UWVBFX1JYX0FERFJfQUREIDoNCj4gPiBEV19UWVBF
X1JYX0FERFJfREVMOw0KPiA+ICsJCW1lbWNweSh3b3JrLT5hZGRyLCBhZGRyLCBFVEhfQUxFTik7
DQo+ID4gKwkJbmV0ZGV2X2RiZyhsaWYtPm5ldGRldiwgImRlZmVycmVkOiByeF9maWx0ZXIgJXMg
JXBNXG4iLA0KPiA+ICsJCQkgICBhZGQgPyAiYWRkIiA6ICJkZWwiLCBhZGRyKTsNCj4gPiArCQlp
b25pY19saWZfZGVmZXJyZWRfZW5xdWV1ZSgmbGlmLT5kZWZlcnJlZCwgd29yayk7DQo+ID4gKwl9
IGVsc2Ugew0KPiA+ICsJCW5ldGRldl9kYmcobGlmLT5uZXRkZXYsICJyeF9maWx0ZXIgJXMgJXBN
XG4iLA0KPiA+ICsJCQkgICBhZGQgPyAiYWRkIiA6ICJkZWwiLCBhZGRyKTsNCj4gPiArCQlpZiAo
YWRkKQ0KPiA+ICsJCQlyZXR1cm4gaW9uaWNfbGlmX2FkZHJfYWRkKGxpZiwgYWRkcik7DQo+ID4g
KwkJZWxzZQ0KPiA+ICsJCQlyZXR1cm4gaW9uaWNfbGlmX2FkZHJfZGVsKGxpZiwgYWRkcik7DQo+
ID4gKwl9DQo+IA0KPiBJIGRvbid0IGtub3cgYWJvdXQgdGhpcy4NCj4gDQo+IEdlbmVyYWxseSBp
bnRlcmZhY2UgYWRkcmVzcyBjaGFuZ2VzIGFyZSBleHBlY3RlZCB0byBiZSBzeW5jaHJvbm91cy4N
Cg0KV2VsbCwgZHJpdmVycyBjYW4ndCBzbGVlcCBvbiBzZXRfcnhfbW9kZSBuZG8sIGRldl9zZXRf
cnhfbW9kZSBpcw0KaG9sZGluZyBuZXRpZl9hZGRyX2xvY2tfYmguDQoNClNvbWUgZHJpdmVycyBu
ZWVkIHRvIHdhaXQgZm9yIGZpcm13YXJlL2RldmljZSBjb21wbGV0aW9uIHRvIHByb2dyYW0gdGhl
DQpuZXcgYWRkcmVzcyBhbmQgdGhleSBoYXZlIHRvIGRvIHRoaXMgYXN5bmNocm9ub3VzbHkgdG8g
YXZvaWQgYXRvbWljDQpjb250ZXh0LiBJIGFzc3VtZSB0aGlzIGRyaXZlciBpcyBoYXZpbmcgdGhl
IHNhbWUgaXNzdWUgZHVlIHRvDQoiaW9uaWNfYWRtaW5xX3Bvc3Rfd2FpdCgpIiAuLiANCg0K
