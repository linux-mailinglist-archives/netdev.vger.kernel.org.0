Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847219A109
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388755AbfHVUUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:20:37 -0400
Received: from mail-eopbgr00060.outbound.protection.outlook.com ([40.107.0.60]:2192
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731370AbfHVUUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:20:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8YvSX5UI8xBOfz/HtyhE83pMrY7PYUVCPSE5x30LqQvchmzUF10DIR9gbFZZbuymzLi4XX5NZzv6TFPzyANcyprEn9F8yCZaS3HNOQzQST+evatNcVVaUrmY5cNs1Syw3l4euT3zRta/HEO78L/EkTRH4eJfgJkwM0BwO+hdieVLr8/ZG09tQ5cK4z9Z3A4nHioinb2/UGQ9o31Wb6zCEJh59nlzdhJ7ec+R/Q0BFQHh6V05cz/iGezPKffQBIhtYHgFVAoPrMHJasQgnc6rpVXP7nJlnnuBOr/6ozTE+CreUOcGcz0u8cLQ+bltV9Tw4giPupMWIosVws9L/4pmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqvUWTdE00vbvnzS2mva2GuoD3F3cV867WZNnqZf8+s=;
 b=RCjOpIIZsYv4r94V8K5Pi4MWfnFFgFtY3YGfvKSm5BiB5XGBwAFMSP98Fs4gvBNcSiqztNW1II+fIzJKzeMckkrJvd45q6hXaq3YBsdAHpPwshvFbAw+CXzP3bQQn8Y26Y2owXSqlc4cbA18MkGywod50o528wK8n0vsHf/T/iVh3uxnpX9Zz9+UBOn7VNmMYlsuRJHVBK1cUec9UHb4b3xdBLDN4y9oETq4a60+IdU0erYXZOND9qpcRjtaEUZPwpkhko3cOgVGzNGnYUusTCNm89rqW9cB82Agp+lfkxiy+sko00TMleLZTGhYplBP0BBIg01DwAkO9ran5A9Ryw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqvUWTdE00vbvnzS2mva2GuoD3F3cV867WZNnqZf8+s=;
 b=EZNB9vXY0Uza97R28WIJnbbobToHVzPbPx9WC79nux4/sE2CqcIPbmFgUV4ulBiCw3DxpZAet0ah+kfUnmOtCF6cIJST7DjW85/KtLdF35RQbrAu2nM2MjWciqG9mhhrUcySJlmmJxu7LkU/N1DiKTMM9m8g5TJhOHiKFTNzXk4=
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com (52.133.38.142) by
 AM0PR0502MB3682.eurprd05.prod.outlook.com (52.133.44.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 20:20:32 +0000
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::9d51:ae68:d177:fc94]) by AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::9d51:ae68:d177:fc94%3]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 20:20:32 +0000
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>,
        haiyangz <haiyangz@microsoft.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kys <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next,v4, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Topic: [PATCH net-next,v4, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Index: AQHVWKdOpe3IdJqUUE+4o3lhPb1ej6cHb2+AgAAs/QA=
Date:   Thu, 22 Aug 2019 20:20:31 +0000
Message-ID: <d2111df3-da28-3e90-a622-a3dd09f2cfae@mellanox.com>
References: <1566450236-36757-1-git-send-email-haiyangz@microsoft.com>
 <1566450236-36757-4-git-send-email-haiyangz@microsoft.com>
 <20190822173813.GM29433@mtr-leonro.mtl.com>
In-Reply-To: <20190822173813.GM29433@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0125.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::17) To AM0PR0502MB4068.eurprd05.prod.outlook.com
 (2603:10a6:208:d::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=eranbe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.126.5.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b0b7a67-2249-43ad-4096-08d7273e2e71
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR0502MB3682;
x-ms-traffictypediagnostic: AM0PR0502MB3682:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB36820436C269812E6EA7D30DBAA50@AM0PR0502MB3682.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(346002)(376002)(136003)(39850400004)(396003)(199004)(189003)(66476007)(7416002)(81166006)(81156014)(8676002)(99286004)(229853002)(1511001)(4326008)(6436002)(8936002)(305945005)(66066001)(6486002)(86362001)(110136005)(6512007)(7736002)(14454004)(316002)(478600001)(54906003)(256004)(6246003)(186003)(6116002)(11346002)(476003)(2616005)(31696002)(2906002)(53936002)(446003)(71200400001)(71190400001)(76176011)(25786009)(52116002)(102836004)(26005)(386003)(66946007)(5660300002)(53546011)(6506007)(3846002)(486006)(36756003)(64756008)(66556008)(66446008)(31686004)(142933001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3682;H:AM0PR0502MB4068.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: an3rb+mBzPLQM3jO57YlbG6yWkU+Yusz7tcRL6gB+tBDcfhuJJK4KHrX0BNz+HK3DGsUgwG8jvU43SBmjlb1pRVrxY02D/t4y/8JlY3u9/UzwRIp+8zkiz6/HKqTqTW7VfRGFKK6suiSe/RbpmfCEnVdRgQwose/HBBxHVp60/D1rekbyAh0/t4QE33ZJ4YKKcPiOUBHJ79oCe3r60i84ctWWOagr0P3Ct+vqlq4LeuHAXPvdelWww7nTCMKmctQ+mIFMXV5NFk2oAoT7QS4j4mjUC0yTAtd8Q4u2qMpLcvBNHT9Lz8v0MaCVvCSvasXYhLkDWtXvwjwJ0RK7j4d7UktJFmKZq7zR1n+EbQpIzK1YdWz+DVab1cx2DSOh3ymuee5EpOoJLOtwbIJ0jpYl/ByvUEdMMjMGBOOdbd6qsc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63300FB6AF714D499ABBCDEA917784CD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0b7a67-2249-43ad-4096-08d7273e2e71
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 20:20:31.8256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WEiwcy6AqSHdBiUJpIkQ9i+kT280HQUAl1wf1DhUX/E80XO+NdbKvledpL6VTXotipLN7z0TT96t+mHeI5v1jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3682
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMjIvMjAxOSA4OjM4IFBNLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6DQo+IE9uIFRo
dSwgQXVnIDIyLCAyMDE5IGF0IDA1OjA1OjQ3QU0gKzAwMDAsIEhhaXlhbmcgWmhhbmcgd3JvdGU6
DQo+PiBGcm9tOiBFcmFuIEJlbiBFbGlzaGEgPGVyYW5iZUBtZWxsYW5veC5jb20+DQo+Pg0KPj4g
QWRkIHdyYXBwZXIgZnVuY3Rpb25zIGZvciBIeXBlclYgUENJZSByZWFkIC8gd3JpdGUgLw0KPj4g
YmxvY2tfaW52YWxpZGF0ZV9yZWdpc3RlciBvcGVyYXRpb25zLiAgVGhpcyB3aWxsIGJlIHVzZWQg
YXMgYW4NCj4+IGluZnJhc3RydWN0dXJlIGluIHRoZSBkb3duc3RyZWFtIHBhdGNoIGZvciBzb2Z0
d2FyZSBjb21tdW5pY2F0aW9uLg0KPj4NCj4+IFRoaXMgd2lsbCBiZSBlbmFibGVkIGJ5IGRlZmF1
bHQgaWYgQ09ORklHX1BDSV9IWVBFUlZfSU5URVJGQUNFIGlzIHNldC4NCj4+DQo+PiBTaWduZWQt
b2ZmLWJ5OiBFcmFuIEJlbiBFbGlzaGEgPGVyYW5iZUBtZWxsYW5veC5jb20+DQo+PiBTaWduZWQt
b2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4+IFNpZ25lZC1v
ZmYtYnk6IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+DQo+PiAtLS0NCj4+
ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL01ha2VmaWxlIHwgIDEg
Kw0KPj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmMg
fCA2NCArKysrKysrKysrKysrKysrKysrKysrKysNCj4+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2xpYi9odi5oIHwgMjIgKysrKysrKysNCj4+ICAgMyBmaWxlcyBj
aGFuZ2VkLCA4NyBpbnNlcnRpb25zKCspDQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmMNCj4+ICAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvaHYu
aA0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvTWFrZWZpbGUgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
TWFrZWZpbGUNCj4+IGluZGV4IGJjZjM2NTUuLmZkMzJhNWIgMTAwNjQ0DQo+PiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvTWFrZWZpbGUNCj4+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9NYWtlZmlsZQ0KPj4gQEAgLTQ1
LDYgKzQ1LDcgQEAgbWx4NV9jb3JlLSQoQ09ORklHX01MWDVfRVNXSVRDSCkgICArPSBlc3dpdGNo
Lm8gZXN3aXRjaF9vZmZsb2Fkcy5vIGVzd2l0Y2hfb2ZmbG8NCj4+ICAgbWx4NV9jb3JlLSQoQ09O
RklHX01MWDVfTVBGUykgICAgICArPSBsaWIvbXBmcy5vDQo+PiAgIG1seDVfY29yZS0kKENPTkZJ
R19WWExBTikgICAgICAgICAgKz0gbGliL3Z4bGFuLm8NCj4+ICAgbWx4NV9jb3JlLSQoQ09ORklH
X1BUUF8xNTg4X0NMT0NLKSArPSBsaWIvY2xvY2subw0KPj4gK21seDVfY29yZS0kKENPTkZJR19Q
Q0lfSFlQRVJWX0lOVEVSRkFDRSkgKz0gbGliL2h2Lm8NCj4+DQo+PiAgICMNCj4+ICAgIyBJcG9p
YiBuZXRkZXYNCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvbGliL2h2LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvbGliL2h2LmMNCj4+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+PiBpbmRleCAwMDAwMDAwLi5j
ZjA4ZDAyDQo+PiAtLS0gL2Rldi9udWxsDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmMNCj4+IEBAIC0wLDAgKzEsNjQgQEANCj4+ICsvLyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCBPUiBMaW51eC1PcGVuSUINCj4+ICsvLyBD
b3B5cmlnaHQgKGMpIDIwMTggTWVsbGFub3ggVGVjaG5vbG9naWVzDQo+PiArDQo+PiArI2luY2x1
ZGUgPGxpbnV4L2h5cGVydi5oPg0KPj4gKyNpbmNsdWRlICJtbHg1X2NvcmUuaCINCj4+ICsjaW5j
bHVkZSAibGliL2h2LmgiDQo+PiArDQo+PiArc3RhdGljIGludCBtbHg1X2h2X2NvbmZpZ19jb21t
b24oc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgdm9pZCAqYnVmLCBpbnQgbGVuLA0KPj4gKwkJ
CQkgaW50IG9mZnNldCwgYm9vbCByZWFkKQ0KPj4gK3sNCj4+ICsJaW50IHJjID0gLUVPUE5PVFNV
UFA7DQo+PiArCWludCBieXRlc19yZXR1cm5lZDsNCj4+ICsJaW50IGJsb2NrX2lkOw0KPj4gKw0K
Pj4gKwlpZiAob2Zmc2V0ICUgSFZfQ09ORklHX0JMT0NLX1NJWkVfTUFYIHx8IGxlbiAlIEhWX0NP
TkZJR19CTE9DS19TSVpFX01BWCkNCj4+ICsJCXJldHVybiAtRUlOVkFMOw0KPj4gKw0KPj4gKwli
bG9ja19pZCA9IG9mZnNldCAvIEhWX0NPTkZJR19CTE9DS19TSVpFX01BWDsNCj4+ICsNCj4+ICsJ
cmMgPSByZWFkID8NCj4+ICsJICAgICBoeXBlcnZfcmVhZF9jZmdfYmxrKGRldi0+cGRldiwgYnVm
LA0KPj4gKwkJCQkgSFZfQ09ORklHX0JMT0NLX1NJWkVfTUFYLCBibG9ja19pZCwNCj4+ICsJCQkJ
ICZieXRlc19yZXR1cm5lZCkgOg0KPj4gKwkgICAgIGh5cGVydl93cml0ZV9jZmdfYmxrKGRldi0+
cGRldiwgYnVmLA0KPj4gKwkJCQkgIEhWX0NPTkZJR19CTE9DS19TSVpFX01BWCwgYmxvY2tfaWQp
Ow0KPj4gKw0KPj4gKwkvKiBNYWtlIHN1cmUgbGVuIGJ5dGVzIHdlcmUgcmVhZCBzdWNjZXNzZnVs
bHkgICovDQo+PiArCWlmIChyZWFkKQ0KPj4gKwkJcmMgfD0gIShsZW4gPT0gYnl0ZXNfcmV0dXJu
ZWQpOw0KPiANCj4gVW5jbGVhciB3aGF0IGRvIHlvdSB3YW50IHRvIGFjaGlldmUgaGVyZSwgZm9y
IHJlYWQgPT0gdHJ1ZSwgInJjIiB3aWxsDQo+IGhhdmUgcmVzdWx0IG9mIGh5cGVydl9yZWFkX2Nm
Z19ibGsoKSwgd2hpY2ggY2FuIGJlIGFuIGVycm9yIHRvby4NCj4gSXQgbWVhbnMgdGhhdCB5b3Vy
ICJyYyB8PSAuLiIgd2lsbCBnaXZlIGludGVyZXN0aW5nIHJlc3VsdHMuDQpXaWxsIGZpeC4NCj4g
DQo+PiArDQo+PiArCWlmIChyYykgew0KPj4gKwkJbWx4NV9jb3JlX2VycihkZXYsICJGYWlsZWQg
dG8gJXMgaHYgY29uZmlnLCBlcnIgPSAlZCwgbGVuID0gJWQsIG9mZnNldCA9ICVkXG4iLA0KPj4g
KwkJCSAgICAgIHJlYWQgPyAicmVhZCIgOiAid3JpdGUiLCByYywgbGVuLA0KPj4gKwkJCSAgICAg
IG9mZnNldCk7DQo+PiArCQlyZXR1cm4gcmM7DQo+PiArCX0NCj4+ICsNCj4+ICsJcmV0dXJuIDA7
DQo+PiArfQ0KPj4gKw0KPj4gK2ludCBtbHg1X2h2X3JlYWRfY29uZmlnKHN0cnVjdCBtbHg1X2Nv
cmVfZGV2ICpkZXYsIHZvaWQgKmJ1ZiwgaW50IGxlbiwNCj4+ICsJCQlpbnQgb2Zmc2V0KQ0KPj4g
K3sNCj4+ICsJcmV0dXJuIG1seDVfaHZfY29uZmlnX2NvbW1vbihkZXYsIGJ1ZiwgbGVuLCBvZmZz
ZXQsIHRydWUpOw0KPj4gK30NCj4+ICsNCj4+ICtpbnQgbWx4NV9odl93cml0ZV9jb25maWcoc3Ry
dWN0IG1seDVfY29yZV9kZXYgKmRldiwgdm9pZCAqYnVmLCBpbnQgbGVuLA0KPj4gKwkJCSBpbnQg
b2Zmc2V0KQ0KPj4gK3sNCj4+ICsJcmV0dXJuIG1seDVfaHZfY29uZmlnX2NvbW1vbihkZXYsIGJ1
ZiwgbGVuLCBvZmZzZXQsIGZhbHNlKTsNCj4+ICt9DQo+PiArDQo+PiAraW50IG1seDVfaHZfcmVn
aXN0ZXJfaW52YWxpZGF0ZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB2b2lkICpjb250ZXh0
LA0KPj4gKwkJCQl2b2lkICgqYmxvY2tfaW52YWxpZGF0ZSkodm9pZCAqY29udGV4dCwNCj4+ICsJ
CQkJCQkJIHU2NCBibG9ja19tYXNrKSkNCj4+ICt7DQo+PiArCXJldHVybiBoeXBlcnZfcmVnX2Js
b2NrX2ludmFsaWRhdGUoZGV2LT5wZGV2LCBjb250ZXh0LA0KPj4gKwkJCQkJICAgYmxvY2tfaW52
YWxpZGF0ZSk7DQo+PiArfQ0KPj4gKw0KPj4gK3ZvaWQgbWx4NV9odl91bnJlZ2lzdGVyX2ludmFs
aWRhdGUoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCj4+ICt7DQo+PiArCWh5cGVydl9yZWdf
YmxvY2tfaW52YWxpZGF0ZShkZXYtPnBkZXYsIE5VTEwsIE5VTEwpOw0KPj4gK30NCj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2Lmgg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmgNCj4+IG5l
dyBmaWxlIG1vZGUgMTAwNjQ0DQo+PiBpbmRleCAwMDAwMDAwLi5mOWE0NTU3DQo+PiAtLS0gL2Rl
di9udWxsDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
bGliL2h2LmgNCj4+IEBAIC0wLDAgKzEsMjIgQEANCj4+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogR1BMLTIuMCBPUiBMaW51eC1PcGVuSUIgKi8NCj4+ICsvKiBDb3B5cmlnaHQgKGMpIDIw
MTkgTWVsbGFub3ggVGVjaG5vbG9naWVzLiAqLw0KPj4gKw0KPj4gKyNpZm5kZWYgX19MSUJfSFZf
SF9fDQo+PiArI2RlZmluZSBfX0xJQl9IVl9IX18NCj4+ICsNCj4+ICsjaWYgSVNfRU5BQkxFRChD
T05GSUdfUENJX0hZUEVSVl9JTlRFUkZBQ0UpDQo+IA0KPiBUaGUgY29tbW9uIHdheSB0byB3cml0
ZSBpdCBpZihJU19FTkFCTEVEKENPTkZJR19GT08pKSBpbnNpZGUgdGhlIGNvZGUNCmFsbCBJU19F
TkFCTEVEIGluIG1seDUgYXJlIHdyaXR0ZW4gd2l0aG91dCBwYXJlbnRoZXNpcywgSSB3aWxsIHN0
YXkgDQphbGlnbmVkIHdpdGggaXQuDQo+IGFuZCAjaWZkZWYgQ09ORklHX0ZPTyBmb3IgaGVhZGVy
IGZpbGVzLg0KVGhpcyB3aWxsIG5vdCB3b3JrIGZvciBsb2FkYWJsZSBtb2R1bGVzIHN1Y2ggYXMg
UENJX0hZUEVSVl9JTlRFUkZBQ0UuIA0KTmVlZCB0cnVlIGhlcmUgYWxzbyBmb3IgPW0gaW4gaCBm
aWxlcyBhcyB3ZWxsLg0KDQo+IA0KPj4gKw0KPj4gKyNpbmNsdWRlIDxsaW51eC9oeXBlcnYuaD4N
Cj4+ICsjaW5jbHVkZSA8bGludXgvbWx4NS9kcml2ZXIuaD4NCj4+ICsNCj4+ICtpbnQgbWx4NV9o
dl9yZWFkX2NvbmZpZyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB2b2lkICpidWYsIGludCBs
ZW4sDQo+PiArCQkJaW50IG9mZnNldCk7DQo+PiAraW50IG1seDVfaHZfd3JpdGVfY29uZmlnKHN0
cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHZvaWQgKmJ1ZiwgaW50IGxlbiwNCj4+ICsJCQkgaW50
IG9mZnNldCk7DQo+PiAraW50IG1seDVfaHZfcmVnaXN0ZXJfaW52YWxpZGF0ZShzdHJ1Y3QgbWx4
NV9jb3JlX2RldiAqZGV2LCB2b2lkICpjb250ZXh0LA0KPj4gKwkJCQl2b2lkICgqYmxvY2tfaW52
YWxpZGF0ZSkodm9pZCAqY29udGV4dCwNCj4+ICsJCQkJCQkJIHU2NCBibG9ja19tYXNrKSk7DQo+
PiArdm9pZCBtbHg1X2h2X3VucmVnaXN0ZXJfaW52YWxpZGF0ZShzdHJ1Y3QgbWx4NV9jb3JlX2Rl
diAqZGV2KTsNCj4+ICsjZW5kaWYNCj4+ICsNCj4+ICsjZW5kaWYgLyogX19MSUJfSFZfSF9fICov
DQo+PiAtLQ0KPj4gMS44LjMuMQ0KPj4NCg==
