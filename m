Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD67B792FD
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387694AbfG2SZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:25:30 -0400
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:40270
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387396AbfG2SZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 14:25:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/N4TfsTGMV+gvVle2DhVlvwQP31ul+zRQ8WATpfQHMvU7V3rMDzGFbm7kN3L2Jvw02oiFhS5j6ogzOQjQU1Yg+/+XQDXctXq7VIOspAx9po2VoRTuPYQREX3rKb+D/2C6jug8XCNC4O19hqVsCQ14kYszAzcny+DmmEHJx6CToVHShOoC5UAUHGtxC8uaiHkQ/pyIsThZaUo8etWTJQ/JgNSenurw8P8tmApV/02VNiW87TJgKSPVVsqWL2RMcyZxk3oW/viBWwpgijmmNHdqeNxHEbQhM+MkruwVtha7D/np9Q7O2Bg4fGOIwS2vCONtIqyeEI7mTK0XxJi6IvpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lCT6KOZxv4bGEVxl/nHhMajtQHOXRsp1yrMdlQ0zK8=;
 b=PbJULS9caxVFYRGUb+FLBMtX3TcnLbL8Xm5BhsVF1AFO65lnaKoasLHjB6tJE9EIZB8BXb3RMvSNdbuEkp5Emmz29Nf+JHGTt4YNs+XpMTKVwrUogGHa8gI7AHNGwq7RpIyCSkMTTJPUx/IRltcQWYCgZB4/Agtn/WiTw/NvcM4aA3yk35ZLD6C4yU9ANc6KMOarWNoQopSmxLfn4RxaLhiSm0IBkSBxMPKVkGwrU1hqJ1aI5KHpjY+eJq9+EIE2XlVuAMFRm7zVuJ0zlAZJiQZN+9rWlGJOwdVcQh0D97Ux2xO0sH2i7miiTI+npbLt873whEJCi5TThG4NvSvUKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lCT6KOZxv4bGEVxl/nHhMajtQHOXRsp1yrMdlQ0zK8=;
 b=e9Mxrf50qoYA6I+sAHZY67JwMycnqSZpVPTNLzxeGEtHkC52IEOLKwEajdIMOVlw/EXynXSPuS7f7MsDbVQ4XnEcVHjlkrndaXmkjpfctGsIE6nD58B2v9AURqVJ3RMlN2QeP9WdtHr12U35eWlcJpTe2uiq1S3oBevMCni3w8M=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2439.eurprd05.prod.outlook.com (10.168.73.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 29 Jul 2019 18:25:26 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 18:25:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net] net/mlx5e: Fix unnecessary flow_block_cb_is_busy call
Thread-Topic: [PATCH net] net/mlx5e: Fix unnecessary flow_block_cb_is_busy
 call
Thread-Index: AQHVRIv9dw+qrtg/K0GKuF3q83fzRKbh7OEA
Date:   Mon, 29 Jul 2019 18:25:26 +0000
Message-ID: <b7a5de0ae2464df31ed39fee71020ba063a7a90f.camel@mellanox.com>
References: <1564239595-23786-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1564239595-23786-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0fd39059-bc28-4144-dfad-08d7145220b0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2439;
x-ms-traffictypediagnostic: DB6PR0501MB2439:
x-microsoft-antispam-prvs: <DB6PR0501MB243990ACBB08D3C2C756E32ABEDD0@DB6PR0501MB2439.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(189003)(199004)(6436002)(486006)(68736007)(305945005)(2906002)(6486002)(25786009)(446003)(11346002)(2616005)(476003)(36756003)(256004)(478600001)(66066001)(2201001)(6116002)(99286004)(229853002)(14454004)(2501003)(81156014)(6246003)(53936002)(7736002)(6512007)(3846002)(71190400001)(71200400001)(5660300002)(186003)(76176011)(81166006)(76116006)(66946007)(91956017)(86362001)(102836004)(66556008)(110136005)(64756008)(66446008)(66476007)(26005)(8676002)(8936002)(58126008)(316002)(118296001)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2439;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xUqDdpkVEFUVR8P55WDNzZUhqczi2W5DlLTsRRJqEo5+QI94+XgFuhS5ON9yFg6RU8FK3p4G5SpKdBnpleTkr8Ld3y90Yf4q2AuHNUZbwrTtl3OAWD8ee9emH7ukjzOBihXRlg0TyP/0mv3GyYzCy0nUodb+theDXv4OhCH0S3h8bpFHzRH4ueMm2UOBomnn5HzDxNmQf+cgypny8hkbssb9QUN24Jj8YnKbPNyQzdZLsp2Rhht2Rom/GMmoLCtOU9qUnEitjN5+fp+cr+jRejX9j7H4S+1VaqkRWMcX9k+DURfjYuumodVhJh8/7Obkk7pafe6GKCdCn9VkTb05mzuDo5uX2Ont8WXboQ4eEMyvLCQ+5jx0O/BA/jObLMoDmNDLEvfiMbEjJBqQPe4LdhbSAQ1iT1AOmQ33f1zuZzs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D8E80C8F2885743A3EB5D8A29C3951C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd39059-bc28-4144-dfad-08d7145220b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 18:25:26.3361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2439
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDE5LTA3LTI3IGF0IDIyOjU5ICswODAwLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6
DQo+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IA0KPiBXaGVuIGNhbGwgZmxvd19i
bG9ja19jYl9pc19idXN5LiBUaGUgaW5kcl9wcml2IGlzIGd1YXJhbnRlZWQgdG8NCj4gTlVMTCBw
dHIuIFNvIHRoZXJlIGlzIG5vIG5lZWQgdG8gY2FsbCBmbG93X2JvY2tfY2JfaXNfYnVzeS4NCj4g
DQo+IEZpeGVzOiAwZDRmZDAyZTcxOTkgKCJuZXQ6IGZsb3dfb2ZmbG9hZDogYWRkIGZsb3dfYmxv
Y2tfY2JfaXNfYnVzeSgpDQo+IGFuZCB1c2UgaXQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiB3ZW54dSA8
d2VueHVAdWNsb3VkLmNuPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9yZXAuYyB8IDQgLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX3JlcC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX3JlcC5jDQo+IGluZGV4IDdmNzQ3Y2IuLjQ5NmQzMDMgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4gQEAg
LTcyMiwxMCArNzIyLDYgQEAgc3RhdGljIHZvaWQgbWx4NWVfcmVwX2luZHJfdGNfYmxvY2tfdW5i
aW5kKHZvaWQNCj4gKmNiX3ByaXYpDQo+ICAJCWlmIChpbmRyX3ByaXYpDQo+ICAJCQlyZXR1cm4g
LUVFWElTVDsNCj4gIA0KPiAtCQlpZg0KPiAoZmxvd19ibG9ja19jYl9pc19idXN5KG1seDVlX3Jl
cF9pbmRyX3NldHVwX2Jsb2NrX2NiLA0KPiAtCQkJCQkgIGluZHJfcHJpdiwNCj4gJm1seDVlX2Js
b2NrX2NiX2xpc3QpKQ0KPiAtCQkJcmV0dXJuIC1FQlVTWTsNCj4gLQ0KPiAgCQlpbmRyX3ByaXYg
PSBrbWFsbG9jKHNpemVvZigqaW5kcl9wcml2KSwgR0ZQX0tFUk5FTCk7DQo+ICAJCWlmICghaW5k
cl9wcml2KQ0KPiAgCQkJcmV0dXJuIC1FTk9NRU07DQoNCkluZGVlZCBmbG93X2Jsb2NrX2NiX2lz
X2J1c3kgaXMgcmVkdW5kYW50IGFuZCB3aWxsIGFsd2F5cyByZXR1cm4gZmFsc2UNCmluIHRoaXMg
cGF0aC4NCg0KVGhpcyBpcyBuZXQtbmV4dCBtYXRlcmlhbC4NCg0KRGF2ZSBsZXQgbWUga25vdyBp
ZiB5b3Ugd2FudCBtZSB0byB0YWtlIGl0IHRvIG15IGJyYW5jaC4NCg0KQWNrZWQtYnk6IFNhZWVk
IE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0K
