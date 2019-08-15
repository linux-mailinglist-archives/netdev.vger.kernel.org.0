Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 740088EA5F
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 13:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731497AbfHOLem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 07:34:42 -0400
Received: from mail-eopbgr50081.outbound.protection.outlook.com ([40.107.5.81]:58227
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfHOLem (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 07:34:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRRkv7cv9yJkAGr7RSGhowSIYnJ7B6kaX47XjrwscUTR6NrQxbRRge3EVz4lU1M5X7HQiF2sYom7DM17vrsUEPJEd+eDAFEioRdlpCQebn+sNyjb2LDApwAYWeajGOtlkiqLMqqCbLFUlnbQTo4dOsXk6ss3jTKqSVAHgxiAZfqfMTyQClZ4KMKcs8kQXp1ABf+pyft2Rz7b3SYUC+32fquCe90zzJeQBntk1wraEcN2MgO7VWGLkkJEewcWW3UwEKlPd8OtTPef2q1jKD93pxJLQKyaAwMLilqMgLfO/kZvpj1dXqhJsbNEkE9u3LSoNIewoMy4vWuGomgBwrkYwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHVfnL2wS+ad6bQzmKx/FHNtefPa/ogoB6/ZuK0/BB0=;
 b=IJ2xtjwNVw26/CcWWsc3Vjz9+BnB732J1y4/ktA+bNHqmupObyNqQspYaqPsinu2clTLIi//FSjAxdSfOenwBSU+wYnsS2vQ/G0aBId8fsnbqPWMPGfXCdlRQKrx48D1k4m/4LsJjUQ+8gHz7lUlTJIphZxrQsCXmFzreREqo9f2UFd/eRLnZT0rOjPlMzL6fas3aIdH3gURAavDVwEv2RMfPe72pQBtpY4x/lJpLG2fIVoI83M+Y5nVgec3Ze9GsrlDDMEm0ophTD6J20XG0e2eHsibTVt95Fz635pIQ6mrriqll1TUIR53zVhnUAkQgCGoO085X3FpLuel/HfQrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHVfnL2wS+ad6bQzmKx/FHNtefPa/ogoB6/ZuK0/BB0=;
 b=ZHUJSKwN2hnX/XM8yUF0ai7sN3ZJm7GRxkuxyDfJAjoxXV481t5jTGpA6b1qw/xTED497njl50sYgbxsEfKKGM70ck9jG60ahRl58ML9zzI4vs74OFOSyhcHce/NybzdN3oKWfFvQuZP6895y0agCiWSj0qBejVv0l8w8M/n9X8=
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com (52.133.38.142) by
 AM0PR0502MB3633.eurprd05.prod.outlook.com (52.133.43.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 15 Aug 2019 11:34:36 +0000
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::9d51:ae68:d177:fc94]) by AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::9d51:ae68:d177:fc94%3]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 11:34:36 +0000
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     Mark Bloch <markb@mellanox.com>, haiyangz <haiyangz@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     kys <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Topic: [PATCH net-next, 3/6] net/mlx5: Add wrappers for HyperV PCIe
 operations
Thread-Index: AQHVUtO7jZEMFZVmWUye6uAXmnR0Gab7G4QAgAD5bQA=
Date:   Thu, 15 Aug 2019 11:34:36 +0000
Message-ID: <f81d2a27-cedc-40ca-daf6-8f3053cc2d38@mellanox.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
 <1565809632-39138-4-git-send-email-haiyangz@microsoft.com>
 <e2a38f24-5a63-ef89-9d69-6a0f2770a9e4@mellanox.com>
In-Reply-To: <e2a38f24-5a63-ef89-9d69-6a0f2770a9e4@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0022.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::34)
 To AM0PR0502MB4068.eurprd05.prod.outlook.com (2603:10a6:208:d::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=eranbe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19776057-28c1-4089-b29d-08d721748d3e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR0502MB3633;
x-ms-traffictypediagnostic: AM0PR0502MB3633:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB36339D9720A2A7D1680DE77EBAAC0@AM0PR0502MB3633.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(6116002)(6246003)(229853002)(8936002)(81166006)(256004)(6436002)(81156014)(8676002)(3846002)(36756003)(6486002)(305945005)(71190400001)(71200400001)(31686004)(7736002)(2906002)(4326008)(110136005)(54906003)(2501003)(66446008)(64756008)(53936002)(66476007)(66946007)(66556008)(52116002)(316002)(99286004)(102836004)(25786009)(6506007)(53546011)(386003)(7416002)(86362001)(76176011)(6512007)(446003)(486006)(26005)(478600001)(31696002)(186003)(11346002)(1511001)(476003)(2201001)(2616005)(14454004)(66066001)(5660300002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3633;H:AM0PR0502MB4068.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BH9HnS2XpCeMUtEc88DvdU0fZPp7odyp4tUknwGDCmI/AJbfSOZ/bYenTf5o2FQm4usiO8qoF0OoRu7gbwt4hVoZeTbclGAYFS+TmDxlTUTRCou3hwafj+6hdhVLtP87LjDKA0U7U3vKk5jDs6kBESkYucFzaIRx4CHePoYoGI74CBtPhGdrYjIts2oTuVKcJpXnwiccwt79PRvuWypzEGNckQCBD73euf+S98J4w4HjeMAu9dxX9r+DLUsmXw/jWw0XbTElNyUoSgAN93p1RqpGPQBjOZ80/YfByScA5/uMU28TzINx/ZK0lE/+YYQnTjs+RTapfUKEfAo5QPAEDU5HmbUnnIrcVqq3rM/b+u3/D/pHMIqIXBoo0FFnemJwEHoEpe3pyOGojcxACYdVXj4NYSd1DvnSJQsWDb5UbSo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <645EE4B897F2C54F9DEF282E1791BF53@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19776057-28c1-4089-b29d-08d721748d3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 11:34:36.7772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OFgAkWZkuTT2qSGsME3MEVhokNiKkB48m3NZ9voAsKpw0xhrldX71UNpgpGE9JaTqnqveNMeaNbd5F8E29KFXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3633
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTQvMjAxOSAxMTo0MSBQTSwgTWFyayBCbG9jaCB3cm90ZToNCj4gDQo+IA0KPiBP
biA4LzE0LzE5IDEyOjA4IFBNLCBIYWl5YW5nIFpoYW5nIHdyb3RlOg0KPj4gRnJvbTogRXJhbiBC
ZW4gRWxpc2hhIDxlcmFuYmVAbWVsbGFub3guY29tPg0KPj4NCj4+IEFkZCB3cmFwcGVyIGZ1bmN0
aW9ucyBmb3IgSHlwZXJWIFBDSWUgcmVhZCAvIHdyaXRlIC8NCj4+IGJsb2NrX2ludmFsaWRhdGVf
cmVnaXN0ZXIgb3BlcmF0aW9ucy4gIFRoaXMgd2lsbCBiZSB1c2VkIGFzIGFuDQo+PiBpbmZyYXN0
cnVjdHVyZSBpbiB0aGUgZG93bnN0cmVhbSBwYXRjaCBmb3Igc29mdHdhcmUgY29tbXVuaWNhdGlv
bi4NCj4+DQo+PiBUaGlzIHdpbGwgYmUgZW5hYmxlZCBieSBkZWZhdWx0IGlmIENPTkZJR19QQ0lf
SFlQRVJWX01JTkkgaXMgc2V0Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEVyYW4gQmVuIEVsaXNo
YSA8ZXJhbmJlQG1lbGxhbm94LmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVk
IDxzYWVlZG1AbWVsbGFub3guY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9NYWtlZmlsZSB8ICAxICsNCj4+ICAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9odi5jIHwgNjQgKysrKysrKysrKysrKysrKysr
KysrKysrDQo+PiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIv
aHYuaCB8IDIyICsrKysrKysrDQo+PiAgIDMgZmlsZXMgY2hhbmdlZCwgODcgaW5zZXJ0aW9ucygr
KQ0KPj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2xpYi9odi5jDQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmgNCj4+DQo+PiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL01ha2VmaWxlIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL01ha2VmaWxlDQo+PiBpbmRleCA4Yjdl
ZGFhLi5hODk1MGIxIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL01ha2VmaWxlDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvTWFrZWZpbGUNCj4+IEBAIC00NSw2ICs0NSw3IEBAIG1seDVfY29yZS0k
KENPTkZJR19NTFg1X0VTV0lUQ0gpICAgKz0gZXN3aXRjaC5vIGVzd2l0Y2hfb2ZmbG9hZHMubyBl
c3dpdGNoX29mZmxvDQo+PiAgIG1seDVfY29yZS0kKENPTkZJR19NTFg1X01QRlMpICAgICAgKz0g
bGliL21wZnMubw0KPj4gICBtbHg1X2NvcmUtJChDT05GSUdfVlhMQU4pICAgICAgICAgICs9IGxp
Yi92eGxhbi5vDQo+PiAgIG1seDVfY29yZS0kKENPTkZJR19QVFBfMTU4OF9DTE9DSykgKz0gbGli
L2Nsb2NrLm8NCj4+ICttbHg1X2NvcmUtJChDT05GSUdfUENJX0hZUEVSVl9NSU5JKSAgICAgKz0g
bGliL2h2Lm8NCj4+ICAgDQo+PiAgICMNCj4+ICAgIyBJcG9pYiBuZXRkZXYNCj4+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmMgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmMNCj4+IG5ldyBm
aWxlIG1vZGUgMTAwNjQ0DQo+PiBpbmRleCAwMDAwMDAwLi5jZjA4ZDAyDQo+PiAtLS0gL2Rldi9u
dWxsDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGli
L2h2LmMNCj4+IEBAIC0wLDAgKzEsNjQgQEANCj4+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmll
cjogR1BMLTIuMCBPUiBMaW51eC1PcGVuSUINCj4+ICsvLyBDb3B5cmlnaHQgKGMpIDIwMTggTWVs
bGFub3ggVGVjaG5vbG9naWVzDQo+PiArDQo+PiArI2luY2x1ZGUgPGxpbnV4L2h5cGVydi5oPg0K
Pj4gKyNpbmNsdWRlICJtbHg1X2NvcmUuaCINCj4+ICsjaW5jbHVkZSAibGliL2h2LmgiDQo+PiAr
DQo+PiArc3RhdGljIGludCBtbHg1X2h2X2NvbmZpZ19jb21tb24oc3RydWN0IG1seDVfY29yZV9k
ZXYgKmRldiwgdm9pZCAqYnVmLCBpbnQgbGVuLA0KPj4gKwkJCQkgaW50IG9mZnNldCwgYm9vbCBy
ZWFkKQ0KPj4gK3sNCj4+ICsJaW50IHJjID0gLUVPUE5PVFNVUFA7DQo+PiArCWludCBieXRlc19y
ZXR1cm5lZDsNCj4+ICsJaW50IGJsb2NrX2lkOw0KPj4gKw0KPj4gKwlpZiAob2Zmc2V0ICUgSFZf
Q09ORklHX0JMT0NLX1NJWkVfTUFYIHx8IGxlbiAlIEhWX0NPTkZJR19CTE9DS19TSVpFX01BWCkN
Cj4+ICsJCXJldHVybiAtRUlOVkFMOw0KPj4gKw0KPj4gKwlibG9ja19pZCA9IG9mZnNldCAvIEhW
X0NPTkZJR19CTE9DS19TSVpFX01BWDsNCj4+ICsNCj4+ICsJcmMgPSByZWFkID8NCj4+ICsJICAg
ICBoeXBlcnZfcmVhZF9jZmdfYmxrKGRldi0+cGRldiwgYnVmLA0KPj4gKwkJCQkgSFZfQ09ORklH
X0JMT0NLX1NJWkVfTUFYLCBibG9ja19pZCwNCj4+ICsJCQkJICZieXRlc19yZXR1cm5lZCkgOg0K
Pj4gKwkgICAgIGh5cGVydl93cml0ZV9jZmdfYmxrKGRldi0+cGRldiwgYnVmLA0KPj4gKwkJCQkg
IEhWX0NPTkZJR19CTE9DS19TSVpFX01BWCwgYmxvY2tfaWQpOw0KPj4gKw0KPj4gKwkvKiBNYWtl
IHN1cmUgbGVuIGJ5dGVzIHdlcmUgcmVhZCBzdWNjZXNzZnVsbHkgICovDQo+PiArCWlmIChyZWFk
KQ0KPj4gKwkJcmMgfD0gIShsZW4gPT0gYnl0ZXNfcmV0dXJuZWQpOw0KPj4gKw0KPj4gKwlpZiAo
cmMpIHsNCj4+ICsJCW1seDVfY29yZV9lcnIoZGV2LCAiRmFpbGVkIHRvICVzIGh2IGNvbmZpZywg
ZXJyID0gJWQsIGxlbiA9ICVkLCBvZmZzZXQgPSAlZFxuIiwNCj4+ICsJCQkgICAgICByZWFkID8g
InJlYWQiIDogIndyaXRlIiwgcmMsIGxlbiwNCj4+ICsJCQkgICAgICBvZmZzZXQpOw0KPj4gKwkJ
cmV0dXJuIHJjOw0KPj4gKwl9DQo+PiArDQo+PiArCXJldHVybiAwOw0KPj4gK30NCj4gDQo+IFRo
aXMgc2VlbXMgb3V0IG9mIHBsYWNlIHdoeSBub3QgZXhwb3NlIHRoaXMgZnVuY3Rpb24gYXMgcGFy
dCBvZiBoeXBlcnYgYW5kIG1seDUNCj4gd2lsbCBqdXN0IHBhc3MgdGhlIHBkZXYuDQo+IA0KVGhl
IEhWIGRyaXZlciB3b3JrcyB3aXRoIGJsb2NrIGNodW5rcy4gSSBmb3VuZCBpdCBsZXNzIGNvbnZl
bmllbmNlIHRvIGRvIA0Kc28gZGlyZWN0bHksIHNvIEkgYWRkIGEgc21hbGwgd3JhcHBlciBmb3Ig
bWx4NSBjb3JlLg0KDQpIYWl5YW5neiwNCkRvIHlvdSBzZWUgYSByZWFzb24gdG8gZXhwb3J0IHRo
aXMgY2FsbGJhY2sgc3R5bGUgZnJvbSB0aGUgSFlQRVJWIGxldmVsIA0KaW5zdGVhZD8NCg0KPj4g
Kw0KPj4gK2ludCBtbHg1X2h2X3JlYWRfY29uZmlnKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYs
IHZvaWQgKmJ1ZiwgaW50IGxlbiwNCj4+ICsJCQlpbnQgb2Zmc2V0KQ0KPj4gK3sNCj4+ICsJcmV0
dXJuIG1seDVfaHZfY29uZmlnX2NvbW1vbihkZXYsIGJ1ZiwgbGVuLCBvZmZzZXQsIHRydWUpOw0K
Pj4gK30NCj4+ICsNCj4+ICtpbnQgbWx4NV9odl93cml0ZV9jb25maWcoc3RydWN0IG1seDVfY29y
ZV9kZXYgKmRldiwgdm9pZCAqYnVmLCBpbnQgbGVuLA0KPj4gKwkJCSBpbnQgb2Zmc2V0KQ0KPj4g
K3sNCj4+ICsJcmV0dXJuIG1seDVfaHZfY29uZmlnX2NvbW1vbihkZXYsIGJ1ZiwgbGVuLCBvZmZz
ZXQsIGZhbHNlKTsNCj4+ICt9DQo+PiArDQo+PiAraW50IG1seDVfaHZfcmVnaXN0ZXJfaW52YWxp
ZGF0ZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB2b2lkICpjb250ZXh0LA0KPj4gKwkJCQl2
b2lkICgqYmxvY2tfaW52YWxpZGF0ZSkodm9pZCAqY29udGV4dCwNCj4+ICsJCQkJCQkJIHU2NCBi
bG9ja19tYXNrKSkNCj4+ICt7DQo+PiArCXJldHVybiBoeXBlcnZfcmVnX2Jsb2NrX2ludmFsaWRh
dGUoZGV2LT5wZGV2LCBjb250ZXh0LA0KPj4gKwkJCQkJICAgYmxvY2tfaW52YWxpZGF0ZSk7DQo+
PiArfQ0KPj4gKw0KPj4gK3ZvaWQgbWx4NV9odl91bnJlZ2lzdGVyX2ludmFsaWRhdGUoc3RydWN0
IG1seDVfY29yZV9kZXYgKmRldikNCj4+ICt7DQo+PiArCWh5cGVydl9yZWdfYmxvY2tfaW52YWxp
ZGF0ZShkZXYtPnBkZXYsIE5VTEwsIE5VTEwpOw0KPj4gK30NCj4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmggYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmgNCj4+IG5ldyBmaWxlIG1vZGUg
MTAwNjQ0DQo+PiBpbmRleCAwMDAwMDAwLi43ZjY5NzcxDQo+PiAtLS0gL2Rldi9udWxsDQo+PiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2LmgNCj4+
IEBAIC0wLDAgKzEsMjIgQEANCj4+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MCBPUiBMaW51eC1PcGVuSUIgKi8NCj4+ICsvKiBDb3B5cmlnaHQgKGMpIDIwMTkgTWVsbGFub3gg
VGVjaG5vbG9naWVzLiAqLw0KPj4gKw0KPj4gKyNpZm5kZWYgX19MSUJfSFZfSF9fDQo+PiArI2Rl
ZmluZSBfX0xJQl9IVl9IX18NCj4+ICsNCj4+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfUENJX0hZ
UEVSVl9NSU5JKQ0KPj4gKw0KPj4gKyNpbmNsdWRlIDxsaW51eC9oeXBlcnYuaD4NCj4+ICsjaW5j
bHVkZSA8bGludXgvbWx4NS9kcml2ZXIuaD4NCj4+ICsNCj4+ICtpbnQgbWx4NV9odl9yZWFkX2Nv
bmZpZyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB2b2lkICpidWYsIGludCBsZW4sDQo+PiAr
CQkJaW50IG9mZnNldCk7DQo+PiAraW50IG1seDVfaHZfd3JpdGVfY29uZmlnKHN0cnVjdCBtbHg1
X2NvcmVfZGV2ICpkZXYsIHZvaWQgKmJ1ZiwgaW50IGxlbiwNCj4+ICsJCQkgaW50IG9mZnNldCk7
DQo+PiAraW50IG1seDVfaHZfcmVnaXN0ZXJfaW52YWxpZGF0ZShzdHJ1Y3QgbWx4NV9jb3JlX2Rl
diAqZGV2LCB2b2lkICpjb250ZXh0LA0KPj4gKwkJCQl2b2lkICgqYmxvY2tfaW52YWxpZGF0ZSko
dm9pZCAqY29udGV4dCwNCj4+ICsJCQkJCQkJIHU2NCBibG9ja19tYXNrKSk7DQo+PiArdm9pZCBt
bHg1X2h2X3VucmVnaXN0ZXJfaW52YWxpZGF0ZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KTsN
Cj4+ICsjZW5kaWYNCj4+ICsNCj4+ICsjZW5kaWYgLyogX19MSUJfSFZfSF9fICovDQo+Pg0KPiAN
Cj4gTWFyaw0KPiANCg==
