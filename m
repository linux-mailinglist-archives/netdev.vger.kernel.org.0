Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD8B67512
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 20:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfGLSZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 14:25:14 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:26595
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726811AbfGLSZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 14:25:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDI+oc3WXAXN6RJYlexbHHoNgfLVT+UZp+o15rNBy/FYXYumxZ+Oy3To6h6OswTglHBTVxI7qgqWWFPNgdUhi7PTE16rOVR9L+zvEaTSHjCedBQPIGhTtPijomjTWg2bma+PkDV6fO4fmTq33M7I7x7TEXBygLxjxUbgXBRrCln2x1fMvqPO74zfMEt2bRMjKx5zSlGef2prEpXAv07WVv2U4ZyM/of7+sJeTyvLIU8jm/UoApRk5TFx8HTGNYTM3g9PS5kzRoF7U+Ame4n2XSjyeXS8EZhXUzEAdwgyW3V23EOJioz65bl4nF5EjOB4nUFL2NXg/UxxtU9rasxAdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1FXIgYrG+/28Ut1JLNGfGs5ngCX9D4vl0A3p32Ex4M=;
 b=eVOz3ISFYmDRefQnyUSI5YkvBtLE7XThPczaM/wry0Mt6kWxo+qgQZ7d0dC/DEyeKJsK0SclNYWoNxKuMzLEr2a8huoRDICJ+Sv8Ba1TRFkFlXaBl4A4AsJL+UHeoX4RKXcPeoGvYAup+3KlRWJnSxML4fKGCidnpR1MCeEuaCF51hDMUtcxwuxTEH53fSWsTah6n1M4TG3/grTM/ftr2hT05+l/stStJmpz0RV271+XYH/KNfcl/xVD7LdRjljdwP/KQ7fQExleRgKvZAab5Yp7x0LrgBo0BLtR5f5vC1Ni0s8wUDUxPyFpqFtiolSA7XSK0IaURphEdijOILmAlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1FXIgYrG+/28Ut1JLNGfGs5ngCX9D4vl0A3p32Ex4M=;
 b=P43tYdl5QTw1NAi8jBOZQXNn3V4NOVgif09vodyuLSCGQrgb3zZ/bEDt8UsSADu5gnpiAmUsmtWomzWewQrUE0YNb4gMejhbhzbL3vnqgbxZMT9Izmqfp+IjDQjPmQTQjJ4syz1WFG8ist1cSW8sVI8jjIQr69stm0pNU1Yu8Zw=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2408.eurprd05.prod.outlook.com (10.168.75.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 12 Jul 2019 18:25:10 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2073.012; Fri, 12 Jul 2019
 18:25:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "leon@kernel.org" <leon@kernel.org>
CC:     Aya Levin <ayal@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [net-next, netfilter] mlx5: avoid unused variable warning
Thread-Topic: [PATCH] [net-next, netfilter] mlx5: avoid unused variable
 warning
Thread-Index: AQHVOI/6yWETykCTR02hsTnrOR+rbabHTSIA
Date:   Fri, 12 Jul 2019 18:25:08 +0000
Message-ID: <1c3219ac5df2da7a3643b253c34b373287ec8ddf.camel@mellanox.com>
References: <20190712085823.4111911-1-arnd@arndb.de>
In-Reply-To: <20190712085823.4111911-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 494ddde3-f158-41d0-aa25-08d706f645c9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2408;
x-ms-traffictypediagnostic: DB6PR0501MB2408:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB2408C9393AC1BA0B9FC92F94BEF20@DB6PR0501MB2408.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(199004)(189003)(7736002)(86362001)(11346002)(2616005)(25786009)(305945005)(6246003)(476003)(118296001)(71200400001)(71190400001)(966005)(229853002)(2201001)(8676002)(486006)(6486002)(53936002)(6512007)(6116002)(68736007)(6436002)(5660300002)(478600001)(110136005)(58126008)(54906003)(6306002)(76176011)(36756003)(256004)(316002)(3846002)(99286004)(14454004)(66446008)(64756008)(66946007)(66556008)(66476007)(76116006)(91956017)(2906002)(102836004)(8936002)(4326008)(26005)(81166006)(446003)(186003)(14444005)(6506007)(66066001)(2501003)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2408;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X254KjU/D/8lwB4zXY3fPV5ZjaCNJUMnDo7rh7agUBJj17ofg96vb6wEC1kC7IUiYK8bfZwDFyKdSrsOh9lJAKAwVEiHTX8kf2ExIFJMRKZxmH9TSVnRq12t8DSo/rhDKSx4KskZYUCXMTXhov2UnM5cXT/gXQ8NBMeKhnkTM1ujLHWAUolbRrlGQt56LM1coD3nXIYq4JbRF9M84rlNKTZWID8m36+5hs05CYuT7Tq8RmfQ3a8WxnqrGaUgzo9a/oxsvC5VxBbef5JRfd7PXx8YNBfvnNJ3ARX1/fdVXfLgr6KjORFnxElAR45GrTGQVHCHbkhofofmnLKy7emNiUu7YbcbTUEfUDV4wvLeyfwENM0VXYfuKYOp70oboMriAmfgX1Cr5OBqCbHoyLJB4tUzinZ7wETjxxUGSd1Ldfc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06635BD4E74F8240B0A5387417CFEB3A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494ddde3-f158-41d0-aa25-08d706f645c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 18:25:08.5016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA3LTEyIGF0IDEwOjU3ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBXaXRob3V0IENPTkZJR19NTFg1X0VTV0lUQ0ggd2UgZ2V0IGEgaGFybWxlc3Mgd2FybmluZzoN
Cj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmM6
MzQ2NzoyMTogZXJyb3I6DQo+IHVudXNlZCB2YXJpYWJsZSAncHJpdicgWy1XZXJyb3IsLVd1bnVz
ZWQtdmFyaWFibGVdDQo+ICAgICAgICAgc3RydWN0IG1seDVlX3ByaXYgKnByaXYgPSBuZXRkZXZf
cHJpdihkZXYpOw0KPiANCg0KSGkgQXJuZCwNCg0KdGhhbmtzIGZvciB5b3VyIHBhdGNoLCBhIHNp
bWlsYXIgcGF0Y2ggdGhhdCBhZGRyZXNzZXMgdGhpcyBpc3N1ZSB3YXMNCmFscmVhZHkgc3VibWl0
dGVkIGFuZCBhcHBsaWVkIHRvIG5ldC1uZXh0IFsxXQ0KDQpbMV0gaHR0cHM6Ly93d3cuc3Bpbmlj
cy5uZXQvbGlzdHMvbmV0ZGV2L21zZzU4NTQzMy5odG1sDQoNCj4gSGlkZSB0aGUgZGVjbGFyYXRp
b24gaW4gdGhlIHNhbWUgI2lmZGVmIGFzIGl0cyB1c2FnZS4NCj4gDQo+IEZpeGVzOiA0ZTk1YmMy
NjhiOTEgKCJuZXQ6IGZsb3dfb2ZmbG9hZDogYWRkDQo+IGZsb3dfYmxvY2tfY2Jfc2V0dXBfc2lt
cGxlKCkiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0K
PiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWlu
LmMgfCAyICsrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4u
Yw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMN
Cj4gaW5kZXggNmQwYWU4N2M4ZGVkLi5iNTYyYmE5MDRlYTEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiBAQCAtMzQ2
NCw3ICszNDY0LDkgQEAgc3RhdGljIExJU1RfSEVBRChtbHg1ZV9ibG9ja19jYl9saXN0KTsNCj4g
IHN0YXRpYyBpbnQgbWx4NWVfc2V0dXBfdGMoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgZW51bSB0
Y19zZXR1cF90eXBlDQo+IHR5cGUsDQo+ICAJCQkgIHZvaWQgKnR5cGVfZGF0YSkNCj4gIHsNCj4g
KyNpZmRlZiBDT05GSUdfTUxYNV9FU1dJVENIDQo+ICAJc3RydWN0IG1seDVlX3ByaXYgKnByaXYg
PSBuZXRkZXZfcHJpdihkZXYpOw0KPiArI2VuZGlmDQo+ICANCj4gIAlzd2l0Y2ggKHR5cGUpIHsN
Cj4gICNpZmRlZiBDT05GSUdfTUxYNV9FU1dJVENIDQo=
