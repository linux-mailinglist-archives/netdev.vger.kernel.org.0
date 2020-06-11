Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A2F1F6FAA
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 23:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgFKV6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 17:58:46 -0400
Received: from mail-eopbgr00048.outbound.protection.outlook.com ([40.107.0.48]:6499
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbgFKV6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 17:58:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzcBbT8lraTPBtvOb7nLBJKLUsOVjHL3sQNO46JLg7xZHdFzIBxwwEcSOOIo/VQkWgUzx/8X9IqHYq4dDOoKHc2nXu29lYjJRttCmGtnXB9uHtZQuFWLQaFHh3x7FaOLinu5qYxn63Vj+5iFDYyuzaFTEj2KVZQTLO+QzOiwbuOX9mwwSJfI9Zh/2n5Fwrv60L7TSvH27Xl1+f7HZ3z5bIBHauBk8rc3O000rut8FYd7lF14e9QdKz0cx/TULZJ31nizxYuPgfu5zzvVWMSlJ7JOUoxw3NTcZFIbwJGs9BMBf7HBQBOyI6oYIw49qwqvGX4zgIeAw8DbDmYL+NpzUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArkoSBXEc+rMrUvykXW859ZUFbAnZ3aNVjM/8HqUDaw=;
 b=EnhFeh/mRkuYqOUsFyq3gtyPkmlwwfIZzFnG6MCDPjXAEnqSQyBRi38RT6SEw01VbPMRqjQGfDzA8HWsmahGCs6RkxDwhx+e4JQn6QR4KiqE3egEmU2A3GZJyRptEVbpVm1/4XOZFTp6vX7DAAEzN37ZK+5M1NKqihCnOvUoqso+uyaz5LcrSw0FlpGcPap2fG6VURhk1N/ia8BlTvDMVaDY1YapL04t1c91WKDpuwyqjQ7CiitCJkQE0z0bOzw5qMGJNAheH4R2a8HpSTyc7eAF/h1Hg2hxWLt/vKSGIVQ0EuazOpHxlTpeKafnQ7SdTZQRCU8T0nzAPu5pnEc7Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArkoSBXEc+rMrUvykXW859ZUFbAnZ3aNVjM/8HqUDaw=;
 b=YVznpXl8Cb7xsV18700noe1jo1uJ100CHaBOfCdQJ2a9wpBwq1zPuMgYcOniW90dMi/LYS1yQxWO4w/sGUni5cCvYQkiE59edgYM2OPqf3XzrQMeb0blXm9SlQbXRe0bxcpGYAvQ47iQTPLwQlBzxqpF6iPL21i0bT6xlmfDqBw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5119.eurprd05.prod.outlook.com (2603:10a6:803:a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 21:58:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 21:58:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "natechancellor@gmail.com" <natechancellor@gmail.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net] net/mlx5: Don't fail driver on failure to create
 debugfs
Thread-Topic: [PATCH net] net/mlx5: Don't fail driver on failure to create
 debugfs
Thread-Index: AQHWONlf0HczwSm0LU6J7Vve55nvl6jFtfwAgAGDlACAAKpCAIAHYF+AgATBCAA=
Date:   Thu, 11 Jun 2020 21:58:40 +0000
Message-ID: <a18dab795ca7dc85744dc5b45bb6e48caa148f51.camel@mellanox.com>
References: <20200602122837.161519-1-leon@kernel.org>
         <20200602192724.GA672@Ryzen-9-3900X.localdomain>
         <20200603183436.GA2565136@ubuntu-n2-xlarge-x86>
         <cf22654ba1e726c3f3d1acf7eff2bc167de810c7.camel@mellanox.com>
         <20200608212243.GA2072362@ubuntu-n2-xlarge-x86>
In-Reply-To: <20200608212243.GA2072362@ubuntu-n2-xlarge-x86>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7665898f-29e0-4198-5419-08d80e5299f9
x-ms-traffictypediagnostic: VI1PR05MB5119:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB51194957E816C8E99ADC8998BE800@VI1PR05MB5119.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q6+7/Ro7Hfjp5Kz/NuTspVpJdhBtyoWKF9GJT+7ccwSxLTaKKt2qaupS7rvbgBVzgPifgbOQlK3CnKar2UOixyMHN9MlgRYVR/k87ime6FNah8kkX5m04GNUJZVVGwR1IO2U74FlQ0oWF9iIaKhBFdDeqglGiAphuZf/Lqzp6mO//HgOUXKJz4IMdpGSxgnmd+5OeoI87gurtjM6iGnzMFK8bQ00yx4/jVmrX68rWekdHw4NYN8O15+H7cU05lEvOSiBYAKGOF0dTInq/xMduW5KK1qMvH2LAw2cTguVgz7EExRXfj/spLS7+bP2OgdvAaN+3xmfe+jG5jKWALhAZcKqpqaQnfwF8akG4AAcC2yF5LJo1qdB+NY47ylRvd+/40utL6rCSiuT7cYy+KMFZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(2616005)(6916009)(186003)(54906003)(36756003)(2906002)(66446008)(64756008)(478600001)(66946007)(966005)(66476007)(76116006)(71200400001)(316002)(91956017)(66556008)(6506007)(5660300002)(8676002)(86362001)(6486002)(83380400001)(6512007)(26005)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cdotI/LHDqgPBxaaKMv18eE42MqWeXEheUv4yURjK3P7ADBci9ZZg25CnyUMsjTPPI8QJ8iFETS9PugOcSllNcT4Iy/31RJQRBlfKXIaB0+mPow+bQyQBGvb/hsVOMLjFgIjOnhV/50qAq999iB4K2g3A/04HRFi0Osl2sl5gzQzIFJTyosnwlx6ly17W67VfO+N5tjI91OAbi2964K2dzO0rBWd6ctlrRN/PWLsVLI1b2qb2CuehpQwNq33oGKQIZd0LH6vo0UaRamDW0z7ApC74SyS2fzJOTKIPl6z/D/bBEssCebSzP1aCDptTIc41MN30/I/3IW6cf71/iwUWWSbwineBbzXoafgAjuFpcrccl6iKkEfRbCpVtvN6jJRvE6ErbCIp96KiReN/R+nJOjxTf/i0Jo+ts9a3CMuQnea85pzx6TwhAM6RgKsQinPGe9c5o47udXglbbA6CR9T3ih+2//kLgPNSxPSWAMg5M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4284D72C812BC8448096C90AA1DA7D0A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7665898f-29e0-4198-5419-08d80e5299f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 21:58:40.4347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TlCfMvRg/gAoN61xkPXTcsGjNCZqjT32p+ff6O+qrTmdSVspi8VbhoaQzWkUwUUkmlpJ5zw1REuW4w8Qzm0rNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA2LTA4IGF0IDE0OjIyIC0wNzAwLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90
ZToNCj4gT24gVGh1LCBKdW4gMDQsIDIwMjAgYXQgMDQ6NDQ6MDBBTSArMDAwMCwgU2FlZWQgTWFo
YW1lZWQgd3JvdGU6DQo+ID4gT24gV2VkLCAyMDIwLTA2LTAzIGF0IDExOjM0IC0wNzAwLCBOYXRo
YW4gQ2hhbmNlbGxvciB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgSnVuIDAyLCAyMDIwIGF0IDEyOjI3
OjI0UE0gLTA3MDAsIE5hdGhhbiBDaGFuY2VsbG9yDQo+ID4gPiB3cm90ZToNCj4gPiA+ID4gT24g
VHVlLCBKdW4gMDIsIDIwMjAgYXQgMDM6Mjg6MzdQTSArMDMwMCwgTGVvbiBSb21hbm92c2t5DQo+
ID4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+IEZyb206IExlb24gUm9tYW5vdnNreSA8bGVvbnJvQG1l
bGxhbm94LmNvbT4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBDbGFuZyB3YXJuczoNCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFp
bi5jOjEyNzg6NjoNCj4gPiA+ID4gPiB3YXJuaW5nOg0KPiA+ID4gPiA+IHZhcmlhYmxlDQo+ID4g
PiA+ID4gJ2VycicgaXMgdXNlZCB1bmluaXRpYWxpemVkIHdoZW5ldmVyICdpZicgY29uZGl0aW9u
IGlzIHRydWUNCj4gPiA+ID4gPiBbLVdzb21ldGltZXMtdW5pbml0aWFsaXplZF0NCj4gPiA+ID4g
PiAgICAgICAgIGlmICghcHJpdi0+ZGJnX3Jvb3QpIHsNCj4gPiA+ID4gPiAgICAgICAgICAgICBe
fn5+fn5+fn5+fn5+fn4NCj4gPiA+ID4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvbWFpbi5jOjEzMDM6OTogbm90ZToNCj4gPiA+ID4gPiB1bmluaXRpYWxpemVkIHVz
ZSBvY2N1cnMgaGVyZQ0KPiA+ID4gPiA+ICAgICAgICAgcmV0dXJuIGVycjsNCj4gPiA+ID4gPiAg
ICAgICAgICAgICAgICBefn4NCj4gPiA+ID4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvbWFpbi5jOjEyNzg6Mjogbm90ZToNCj4gPiA+ID4gPiByZW1vdmUgdGhlDQo+
ID4gPiA+ID4gJ2lmJyBpZiBpdHMgY29uZGl0aW9uIGlzIGFsd2F5cyBmYWxzZQ0KPiA+ID4gPiA+
ICAgICAgICAgaWYgKCFwcml2LT5kYmdfcm9vdCkgew0KPiA+ID4gPiA+ICAgICAgICAgXn5+fn5+
fn5+fn5+fn5+fn5+fn5+fg0KPiA+ID4gPiA+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9tYWluLmM6MTI1OTo5OiBub3RlOg0KPiA+ID4gPiA+IGluaXRpYWxpemUNCj4g
PiA+ID4gPiB0aGUgdmFyaWFibGUgJ2VycicgdG8gc2lsZW5jZSB0aGlzIHdhcm5pbmcNCj4gPiA+
ID4gPiAgICAgICAgIGludCBlcnI7DQo+ID4gPiA+ID4gICAgICAgICAgICAgICAgXg0KPiA+ID4g
PiA+ICAgICAgICAgICAgICAgICA9IDANCj4gPiA+ID4gPiAxIHdhcm5pbmcgZ2VuZXJhdGVkLg0K
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IFRoZSBjaGVjayBvZiByZXR1cm5lZCB2YWx1ZSBvZiBkZWJ1
Z2ZzX2NyZWF0ZV9kaXIoKSBpcyB3cm9uZw0KPiA+ID4gPiA+IGJlY2F1c2UNCj4gPiA+ID4gPiBi
eSB0aGUgZGVzaWduIGRlYnVnZnMgZmFpbHVyZXMgc2hvdWxkIG5ldmVyIGZhaWwgdGhlIGRyaXZl
cg0KPiA+ID4gPiA+IGFuZA0KPiA+ID4gPiA+IHRoZQ0KPiA+ID4gPiA+IGNoZWNrIGl0c2VsZiB3
YXMgd3JvbmcgdG9vLiBUaGUga2VybmVsIGNvbXBpbGVkIHdpdGhvdXQNCj4gPiA+ID4gPiBDT05G
SUdfREVCVUdfRlMNCj4gPiA+ID4gPiB3aWxsIHJldHVybiBFUlJfUFRSKC1FTk9ERVYpIGFuZCBu
b3QgTlVMTCBhcyBleHBlY3RlZC4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBGaXhlczogMTFmM2I4
NGQ3MDY4ICgibmV0L21seDU6IFNwbGl0IG1kZXYgaW5pdCBhbmQgcGNpDQo+ID4gPiA+ID4gaW5p
dCIpDQo+ID4gPiA+ID4gTGluazogaHR0cHM6Ly9naXRodWIuY29tL0NsYW5nQnVpbHRMaW51eC9s
aW51eC9pc3N1ZXMvMTA0Mg0KPiA+ID4gPiA+IFJlcG9ydGVkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxv
ciA8bmF0ZWNoYW5jZWxsb3JAZ21haWwuY29tPg0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IExl
b24gUm9tYW5vdnNreSA8bGVvbnJvQG1lbGxhbm94LmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IFRo
YW5rcyEgVGhhdCdzIHdoYXQgSSBmaWd1cmVkIGl0IHNob3VsZCBiZS4NCj4gPiA+ID4gDQo+ID4g
PiA+IFJldmlld2VkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0ZWNoYW5jZWxsb3JAZ21haWwu
Y29tPg0KPiA+ID4gPiANCj4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiBPcmlnaW5hbCBkaXNjdXNz
aW9uOg0KPiA+ID4gPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMDA1MzAwNTU0
NDcuMTAyODAwNC0xLW5hdGVjaGFuY2VsbG9yQGdtYWlsLmNvbQ0KPiA+ID4gPiA+IC0tLQ0KPiA+
ID4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jIHwg
NSAtLS0tLQ0KPiA+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgNSBkZWxldGlvbnMoLSkNCj4gPiA+
ID4gPiANCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL21haW4uYw0KPiA+ID4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL21haW4uYw0KPiA+ID4gPiA+IGluZGV4IGRmNDZiMWZjZTNhNy4uMTEw
ZThkMjc3ZDE1IDEwMDY0NA0KPiA+ID4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9tYWluLmMNCj4gPiA+ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQo+ID4gPiA+ID4gQEAgLTEyNzUsMTEgKzEy
NzUsNiBAQCBzdGF0aWMgaW50IG1seDVfbWRldl9pbml0KHN0cnVjdA0KPiA+ID4gPiA+IG1seDVf
Y29yZV9kZXYgKmRldiwgaW50IHByb2ZpbGVfaWR4KQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ICAJ
cHJpdi0+ZGJnX3Jvb3QgPSBkZWJ1Z2ZzX2NyZWF0ZV9kaXIoZGV2X25hbWUoZGV2LQ0KPiA+ID4g
PiA+ID5kZXZpY2UpLA0KPiA+ID4gPiA+ICAJCQkJCSAgICBtbHg1X2RlYnVnZnNfcm9vdCk7DQo+
ID4gPiA+ID4gLQlpZiAoIXByaXYtPmRiZ19yb290KSB7DQo+ID4gPiA+ID4gLQkJZGV2X2Vycihk
ZXYtPmRldmljZSwgIm1seDVfY29yZTogZXJyb3IsIENhbm5vdA0KPiA+ID4gPiA+IGNyZWF0ZQ0K
PiA+ID4gPiA+IGRlYnVnZnMgZGlyLCBhYm9ydGluZ1xuIik7DQo+ID4gPiA+ID4gLQkJZ290byBl
cnJfZGJnX3Jvb3Q7DQo+ID4gPiANCj4gPiA+IEFjdHVhbGx5LCB0aGlzIHJlbW92ZXMgdGhlIG9u
bHkgdXNlIG9mIGVycl9kYmdfcm9vdCwgc28gdGhhdA0KPiA+ID4gc2hvdWxkDQo+ID4gPiBiZQ0K
PiA+ID4gcmVtb3ZlZCBhdCB0aGUgc2FtZSB0aW1lLg0KPiA+ID4gDQo+ID4gDQo+ID4gRml4ZWQg
dGhpcyB1cCBhbmQgYXBwbGllZCB0byBuZXQtbmV4dC1tbHg1LCANCj4gPiBUaGFua3MhDQo+ID4g
DQo+IA0KPiBIaSBTYWVlZCwNCj4gDQo+IEkgc2VlIHRoaXMgd2FybmluZyBpbiBtYWlubGluZSBu
b3csIGlzIHRoaXMgc29tZXRoaW5nIHlvdSB3ZXJlDQo+IHBsYW5uaW5nDQo+IHRvIGhhdmUgbWVy
Z2VkIHRoaXMgY3ljbGUgb3IgbmV4dD8gSSBzZWUgaXQgaW4gc2V2ZXJhbCBjb25maWdzIHNvIGl0
DQo+IHdvdWxkIGJlIG5pY2UgaWYgaXQgY291bGQgYmUgcmVzb2x2ZWQgdGhpcyBvbmUsIHNpbmNl
IGl0IHdhcw0KPiBpbnRyb2R1Y2VkDQo+IGJ5IGEgcGF0Y2ggaW4gdGhpcyBjeWNsZSBldmVuIHRo
b3VnaCB0aGUgY29yZSBpc3N1ZSBoYXMgYmVlbiBhcm91bmQNCj4gZm9yDQo+IGEgZmV3IG1vbnRo
cy4NCj4gDQoNCkhpIE5hdGhhbiwgDQoNCkkganVzdCBwdWxsZWQgdGhpcyBwYXRjaCBpbnRvIG5l
dC1tbHg1LCBhbmQgd2lsbCBzZW5kIGl0IG91dCBpbiBteSBuZXQNClBSIHRvZGF5Lg0KDQoNClRo
YW5rcywNClNhZWVkLg0KDQoNCj4gQ2hlZXJzLA0KPiBOYXRoYW4NCg==
