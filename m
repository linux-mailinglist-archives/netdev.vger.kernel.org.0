Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38058DF14
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfHNUmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:42:25 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:50753
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726505AbfHNUmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 16:42:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNmSjqVE0sR//cT/cFVxYuCKp97BwVv04MeaVgQczENbrj9vCsW3MCPe4/3sq1qpYTyWf4tuqQJ2udsSFnTR96q2EkwCiscQTkM0IgwMf7vATaf6E2LIIRXAVhKcfsQKah/aiRam9Qj2li/asZlKVYMkf2OPZM7PT4GN6qNIDpqVL5IdI8UFB26JMx/AKnXepSpDE5ozasxpUeMv8p8/Iljm4p1P17axpFgS4O3PxdAc09mkj2BmehGVufPbNUYtdz7wWztIHDOaeI2up3Gpf9MHxNdl24IjN+5JW5/V6tTd6K2Rn7sbwRmyEOAeE7mxE1BLf12Gk0gCVFndztELsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGzR2SXPwNVGGpWgQ9zjS8EUSuhaTjiVs4UE/KOXtfc=;
 b=VQjFN/+0C2JMNFV30lZ4xRpEnsP7PUwbi5aiHbOHnh/8+PCK5FS+7pcnz4pK/9Nz4+dWAQI3+Yq4KqGBVvzleMXTql1oaUyLpFX8e7uKjPO6zGff5c0VCxKqPCReZOXkPhg/tSr/VfE9iRQZg4nXJd7JoVDlEFw93visnrRz+6+0lBvGrZJ+GagSOpSklcGpiniHYBb52tCG486KmtFUrobsAaMIBH7WsEMTUt5Ift00hVSNu2j1QiKHtC1Ay8XaXI/Cfg8x1zvz15scCXk97VYtRAr34jEUokrbrDe4t/vsrtrDe6hCitrIbtMbfRdzjFS7DUF9NRwEwLMNdRzT/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGzR2SXPwNVGGpWgQ9zjS8EUSuhaTjiVs4UE/KOXtfc=;
 b=hfFyAFzXB7ccpHtqlbHH+f/XfQpla5zylXO3PNn18kRbiUR1Rg1WrvoJF3crsiMvYz3aS0DvaVXM+ccLTB/m0RLfrFGrQdj9IXW4qASTKt+JDu1G0LKFdbsbrjM2YHgyQU+V+0XKICAir14NLOdeoazFkenG4R8IwGNHcqMCtnw=
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com (10.170.238.143) by
 VI1PR05MB5616.eurprd05.prod.outlook.com (20.177.203.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Wed, 14 Aug 2019 20:41:48 +0000
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::3195:8043:2057:2780]) by VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::3195:8043:2057:2780%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 20:41:48 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     haiyangz <haiyangz@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     kys <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Topic: [PATCH net-next, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Index: AQHVUtPKYcl91WlxIUe+WkiPBDYfFqb7G66A
Date:   Wed, 14 Aug 2019 20:41:47 +0000
Message-ID: <745f663e-0c56-84d0-a02b-106f788e3e8f@mellanox.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
 <1565809632-39138-6-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1565809632-39138-6-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0049.namprd04.prod.outlook.com
 (2603:10b6:300:6c::11) To VI1PR05MB3342.eurprd05.prod.outlook.com
 (2603:10a6:802:1d::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [208.186.24.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07bf0941-93e3-43c1-2e22-08d720f7d3af
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5616;
x-ms-traffictypediagnostic: VI1PR05MB5616:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5616399C0D9EF0C23026C4D0D2AD0@VI1PR05MB5616.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(199004)(189003)(6506007)(7416002)(110136005)(256004)(76176011)(14454004)(55236004)(25786009)(386003)(6116002)(54906003)(53546011)(2201001)(14444005)(4326008)(86362001)(52116002)(36756003)(6486002)(31686004)(186003)(229853002)(53936002)(6436002)(3846002)(81156014)(6246003)(66066001)(316002)(102836004)(31696002)(26005)(478600001)(81166006)(305945005)(8936002)(7736002)(11346002)(8676002)(486006)(2616005)(71190400001)(71200400001)(1511001)(64756008)(2906002)(2501003)(446003)(5660300002)(99286004)(66556008)(476003)(66476007)(66446008)(66946007)(6512007)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5616;H:VI1PR05MB3342.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cVNmo5Pe9R0t9Vulg0D4edjIZgRb9YoeN86Vtfnj5w7BR2c4NhdqUAQkfqYRi0D7TGsUsZSOTjP9/S5uoL2czGaxKuSDYgXIthtUBdABtWCkCJN83ZD+kekjopT4xqIkqjsaIdPyUokjzi4oltXNmTRGI2iLFNEVhZBLiYKjLHLLb90UyIhErl4cLsKNn+RpkxYqEnwoBPR2lVrHU1gnrREsFeSRuC+vfY6dL6qOch8wfanPpaQwB3b5GXJFXjK4N0QvLrrt+GN1lb7UcLGCGHL1/JP6PaHo+UUm99NOtgPzUiogzur+pMmOG/t+87yxVOpshqB53wWWNK43PU0ZHYpFxDlUoRwzFkv/jYdT9+V3EK1nWgfLHYtSDqyS5yA+VDQp9wukEg5iLCLhNb4RO6vWz1M9t7rU2YbKwmmyuuI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A5248BD66B1734BAD3564EB460A9703@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07bf0941-93e3-43c1-2e22-08d720f7d3af
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 20:41:47.8707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hbK4S4DWCFBv1d+JZzYIscoTCq7RfCQpmSqiRe4q9uTxdc5K9UOdj3iWNF00DlimyZfZgS9R/emxCZLSSfoPyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5616
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTQvMTkgMTI6MDkgUE0sIEhhaXlhbmcgWmhhbmcgd3JvdGU6DQo+IEZyb206IEVy
YW4gQmVuIEVsaXNoYSA8ZXJhbmJlQG1lbGxhbm94LmNvbT4NCj4gDQo+IENvbnRyb2wgYWdlbnQg
aXMgcmVzcG9uc2libGUgb3ZlciBvZiB0aGUgY29udHJvbCBibG9jayAoSUQgMCkuIEl0IHNob3Vs
ZA0KPiB1cGRhdGUgdGhlIFBGIHZpYSB0aGlzIGJsb2NrIGFib3V0IGV2ZXJ5IGNhcGFiaWxpdHkg
Y2hhbmdlLiBJbiBhZGRpdGlvbiwNCj4gdXBvbiBibG9jayAwIGludmFsaWRhdGUsIGl0IHNob3Vs
ZCBhY3RpdmF0ZSBhbGwgb3RoZXIgc3VwcG9ydGVkIGFnZW50cw0KPiB3aXRoIGRhdGEgcmVxdWVz
dHMgZnJvbSB0aGUgUEYuDQo+IA0KPiBVcG9uIGFnZW50IGNyZWF0ZS9kZXN0cm95LCB0aGUgaW52
YWxpZGF0ZSBjYWxsYmFjayBvZiB0aGUgY29udHJvbCBhZ2VudA0KPiBpcyBiZWluZyBjYWxsZWQg
aW4gb3JkZXIgdG8gdXBkYXRlIHRoZSBQRiBkcml2ZXIgYWJvdXQgdGhpcyBjaGFuZ2UuDQo+IA0K
PiBUaGUgY29udHJvbCBhZ2VudCBpcyBhbiBpbnRlZ3JhbCBwYXJ0IG9mIEhWIFZIQ0EgYW5kIHdp
bGwgYmUgY3JlYXRlZA0KPiBhbmQgZGVzdHJveSBhcyBwYXJ0IG9mIHRoZSBIViBWSENBIGluaXQv
Y2xlYW51cCBmbG93Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRXJhbiBCZW4gRWxpc2hhIDxlcmFu
YmVAbWVsbGFub3guY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRt
QG1lbGxhbm94LmNvbT4NCj4gLS0tDQo+ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9saWIvaHZfdmhjYS5jICB8IDEyMiArKysrKysrKysrKysrKysrKysrKy0NCj4gIC4uLi9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9odl92aGNhLmggIHwgICAxICsNCj4g
IDIgZmlsZXMgY2hhbmdlZCwgMTIxIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xp
Yi9odl92aGNhLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGli
L2h2X3ZoY2EuYw0KPiBpbmRleCBiMmVlYmRmLi4zYzdmZmZhIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2X3ZoY2EuYw0KPiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2X3ZoY2EuYw0K
PiBAQCAtMTEwLDIyICsxMTAsMTMxIEBAIHZvaWQgbWx4NV9odl92aGNhX2ludmFsaWRhdGUodm9p
ZCAqY29udGV4dCwgdTY0IGJsb2NrX21hc2spDQo+ICAJcXVldWVfd29yayhodl92aGNhLT53b3Jr
X3F1ZXVlLCAmd29yay0+aW52YWxpZGF0ZV93b3JrKTsNCj4gIH0NCj4gIA0KPiArI2RlZmluZSBB
R0VOVF9NQVNLKHR5cGUpICh0eXBlID8gQklUKHR5cGUgLSAxKSA6IDAgLyogY29udHJvbCAqLykN
Cj4gKw0KPiArc3RhdGljIHZvaWQgbWx4NV9odl92aGNhX2FnZW50c19jb250cm9sKHN0cnVjdCBt
bHg1X2h2X3ZoY2EgKmh2X3ZoY2EsDQo+ICsJCQkJCXN0cnVjdCBtbHg1X2h2X3ZoY2FfY29udHJv
bF9ibG9jayAqYmxvY2spDQo+ICt7DQo+ICsJaW50IGk7DQo+ICsNCj4gKwlmb3IgKGkgPSAwOyBp
IDwgTUxYNV9IVl9WSENBX0FHRU5UX01BWDsgaSsrKSB7DQo+ICsJCXN0cnVjdCBtbHg1X2h2X3Zo
Y2FfYWdlbnQgKmFnZW50ID0gaHZfdmhjYS0+YWdlbnRzW2ldOw0KPiArDQo+ICsJCWlmICghYWdl
bnQgfHwgIWFnZW50LT5jb250cm9sKQ0KPiArCQkJY29udGludWU7DQo+ICsNCj4gKwkJaWYgKCEo
QUdFTlRfTUFTSyhhZ2VudC0+dHlwZSkgJiBibG9jay0+Y29udHJvbCkpDQo+ICsJCQljb250aW51
ZTsNCj4gKw0KPiArCQlhZ2VudC0+Y29udHJvbChhZ2VudCwgYmxvY2spOw0KPiArCX0NCj4gK30N
Cj4gKw0KPiArc3RhdGljIHZvaWQgbWx4NV9odl92aGNhX2NhcGFiaWxpdGllcyhzdHJ1Y3QgbWx4
NV9odl92aGNhICpodl92aGNhLA0KPiArCQkJCSAgICAgIHUzMiAqY2FwYWJpbGl0aWVzKQ0KPiAr
ew0KPiArCWludCBpOw0KPiArDQo+ICsJZm9yIChpID0gMDsgaSA8IE1MWDVfSFZfVkhDQV9BR0VO
VF9NQVg7IGkrKykgew0KPiArCQlzdHJ1Y3QgbWx4NV9odl92aGNhX2FnZW50ICphZ2VudCA9IGh2
X3ZoY2EtPmFnZW50c1tpXTsNCj4gKw0KPiArCQlpZiAoYWdlbnQpDQo+ICsJCQkqY2FwYWJpbGl0
aWVzIHw9IEFHRU5UX01BU0soYWdlbnQtPnR5cGUpOw0KPiArCX0NCj4gK30NCj4gKw0KPiArc3Rh
dGljIHZvaWQNCj4gK21seDVfaHZfdmhjYV9jb250cm9sX2FnZW50X2ludmFsaWRhdGUoc3RydWN0
IG1seDVfaHZfdmhjYV9hZ2VudCAqYWdlbnQsDQo+ICsJCQkJICAgICAgdTY0IGJsb2NrX21hc2sp
DQo+ICt7DQo+ICsJc3RydWN0IG1seDVfaHZfdmhjYSAqaHZfdmhjYSA9IGFnZW50LT5odl92aGNh
Ow0KPiArCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYgPSBodl92aGNhLT5kZXY7DQo+ICsJc3Ry
dWN0IG1seDVfaHZfdmhjYV9jb250cm9sX2Jsb2NrICpibG9jazsNCj4gKwl1MzIgY2FwYWJpbGl0
aWVzID0gMDsNCj4gKwlpbnQgZXJyOw0KPiArDQo+ICsJYmxvY2sgPSBremFsbG9jKHNpemVvZigq
YmxvY2spLCBHRlBfS0VSTkVMKTsNCj4gKwlpZiAoIWJsb2NrKQ0KPiArCQlyZXR1cm47DQo+ICsN
Cj4gKwllcnIgPSBtbHg1X2h2X3JlYWRfY29uZmlnKGRldiwgYmxvY2ssIHNpemVvZigqYmxvY2sp
LCAwKTsNCj4gKwlpZiAoZXJyKQ0KPiArCQlnb3RvIGZyZWVfYmxvY2s7DQo+ICsNCj4gKwltbHg1
X2h2X3ZoY2FfY2FwYWJpbGl0aWVzKGh2X3ZoY2EsICZjYXBhYmlsaXRpZXMpOw0KPiArDQo+ICsJ
LyogSW4gY2FzZSBubyBjYXBhYmlsaXRpZXMsIHNlbmQgZW1wdHkgYmxvY2sgaW4gcmV0dXJuICov
DQo+ICsJaWYgKCFjYXBhYmlsaXRpZXMpIHsNCj4gKwkJbWVtc2V0KGJsb2NrLCAwLCBzaXplb2Yo
KmJsb2NrKSk7DQo+ICsJCWdvdG8gd3JpdGU7DQo+ICsJfQ0KPiArDQo+ICsJaWYgKGJsb2NrLT5j
YXBhYmlsaXRpZXMgIT0gY2FwYWJpbGl0aWVzKQ0KPiArCQlibG9jay0+Y2FwYWJpbGl0aWVzID0g
Y2FwYWJpbGl0aWVzOw0KPiArDQo+ICsJaWYgKGJsb2NrLT5jb250cm9sICYgfmNhcGFiaWxpdGll
cykNCj4gKwkJZ290byBmcmVlX2Jsb2NrOw0KPiArDQo+ICsJbWx4NV9odl92aGNhX2FnZW50c19j
b250cm9sKGh2X3ZoY2EsIGJsb2NrKTsNCj4gKwlibG9jay0+Y29tbWFuZF9hY2sgPSBibG9jay0+
Y29tbWFuZDsNCj4gKw0KPiArd3JpdGU6DQo+ICsJbWx4NV9odl93cml0ZV9jb25maWcoZGV2LCBi
bG9jaywgc2l6ZW9mKCpibG9jayksIDApOw0KPiArDQo+ICtmcmVlX2Jsb2NrOg0KPiArCWtmcmVl
KGJsb2NrKTsNCj4gK30NCj4gKw0KPiArc3RhdGljIHN0cnVjdCBtbHg1X2h2X3ZoY2FfYWdlbnQg
Kg0KPiArbWx4NV9odl92aGNhX2NvbnRyb2xfYWdlbnRfY3JlYXRlKHN0cnVjdCBtbHg1X2h2X3Zo
Y2EgKmh2X3ZoY2EpDQo+ICt7DQo+ICsJcmV0dXJuIG1seDVfaHZfdmhjYV9hZ2VudF9jcmVhdGUo
aHZfdmhjYSwgTUxYNV9IVl9WSENBX0FHRU5UX0NPTlRST0wsDQo+ICsJCQkJCSBOVUxMLA0KPiAr
CQkJCQkgbWx4NV9odl92aGNhX2NvbnRyb2xfYWdlbnRfaW52YWxpZGF0ZSwNCj4gKwkJCQkJIE5V
TEwsIE5VTEwpOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBtbHg1X2h2X3ZoY2FfY29udHJv
bF9hZ2VudF9kZXN0cm95KHN0cnVjdCBtbHg1X2h2X3ZoY2FfYWdlbnQgKmFnZW50KQ0KPiArew0K
PiArCW1seDVfaHZfdmhjYV9hZ2VudF9kZXN0cm95KGFnZW50KTsNCj4gK30NCj4gKw0KPiAgaW50
IG1seDVfaHZfdmhjYV9pbml0KHN0cnVjdCBtbHg1X2h2X3ZoY2EgKmh2X3ZoY2EpDQo+ICB7DQo+
ICsJc3RydWN0IG1seDVfaHZfdmhjYV9hZ2VudCAqYWdlbnQ7DQo+ICsJaW50IGVycjsNCj4gKw0K
PiAgCWlmIChJU19FUlJfT1JfTlVMTChodl92aGNhKSkNCj4gIAkJcmV0dXJuIElTX0VSUl9PUl9O
VUxMKGh2X3ZoY2EpOw0KPiAgDQo+IC0JcmV0dXJuIG1seDVfaHZfcmVnaXN0ZXJfaW52YWxpZGF0
ZShodl92aGNhLT5kZXYsIGh2X3ZoY2EsDQo+IC0JCQkJCSAgIG1seDVfaHZfdmhjYV9pbnZhbGlk
YXRlKTsNCj4gKwllcnIgPSBtbHg1X2h2X3JlZ2lzdGVyX2ludmFsaWRhdGUoaHZfdmhjYS0+ZGV2
LCBodl92aGNhLA0KPiArCQkJCQkgIG1seDVfaHZfdmhjYV9pbnZhbGlkYXRlKTsNCj4gKwlpZiAo
ZXJyKQ0KPiArCQlyZXR1cm4gZXJyOw0KPiArDQo+ICsJYWdlbnQgPSBtbHg1X2h2X3ZoY2FfY29u
dHJvbF9hZ2VudF9jcmVhdGUoaHZfdmhjYSk7DQo+ICsJaWYgKElTX0VSUl9PUl9OVUxMKGFnZW50
KSkgew0KPiArCQltbHg1X2h2X3VucmVnaXN0ZXJfaW52YWxpZGF0ZShodl92aGNhLT5kZXYpOw0K
PiArCQlyZXR1cm4gSVNfRVJSX09SX05VTEwoYWdlbnQpOw0KPiArCX0NCj4gKw0KPiArCWh2X3Zo
Y2EtPmFnZW50c1tNTFg1X0hWX1ZIQ0FfQUdFTlRfQ09OVFJPTF0gPSBhZ2VudDsNCj4gKw0KPiAr
CXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICB2b2lkIG1seDVfaHZfdmhjYV9jbGVhbnVwKHN0cnVj
dCBtbHg1X2h2X3ZoY2EgKmh2X3ZoY2EpDQo+ICB7DQo+ICsJc3RydWN0IG1seDVfaHZfdmhjYV9h
Z2VudCAqYWdlbnQ7DQo+ICAJaW50IGk7DQo+ICANCj4gIAlpZiAoSVNfRVJSX09SX05VTEwoaHZf
dmhjYSkpDQo+ICAJCXJldHVybjsNCj4gIA0KPiArCWFnZW50ID0gaHZfdmhjYS0+YWdlbnRzW01M
WDVfSFZfVkhDQV9BR0VOVF9DT05UUk9MXTsNCj4gKwlpZiAoIUlTX0VSUl9PUl9OVUxMKGFnZW50
KSkNCj4gKwkJbWx4NV9odl92aGNhX2NvbnRyb2xfYWdlbnRfZGVzdHJveShhZ2VudCk7DQoNCkNh
biB0aGUgYWdlbnQgYmUgZXJyIHB0ciBoZXJlPw0KDQo+ICsNCj4gIAltdXRleF9sb2NrKCZodl92
aGNhLT5hZ2VudHNfbG9jayk7DQo+ICAJZm9yIChpID0gMDsgaSA8IE1MWDVfSFZfVkhDQV9BR0VO
VF9NQVg7IGkrKykNCj4gIAkJV0FSTl9PTihodl92aGNhLT5hZ2VudHNbaV0pOw0KDQpXaXRoIHRo
ZSBjb21tZW50IGFib3ZlIGluIG1pbmQsIGhlcmUgeW91IGNoZWNrIG9ubHkgZm9yIG5vdCBudWxs
DQoNCj4gQEAgLTEzNSw2ICsyNDQsMTEgQEAgdm9pZCBtbHg1X2h2X3ZoY2FfY2xlYW51cChzdHJ1
Y3QgbWx4NV9odl92aGNhICpodl92aGNhKQ0KPiAgCW1seDVfaHZfdW5yZWdpc3Rlcl9pbnZhbGlk
YXRlKGh2X3ZoY2EtPmRldik7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyB2b2lkIG1seDVfaHZfdmhj
YV9hZ2VudHNfdXBkYXRlKHN0cnVjdCBtbHg1X2h2X3ZoY2EgKmh2X3ZoY2EpDQo+ICt7DQo+ICsJ
bWx4NV9odl92aGNhX2ludmFsaWRhdGUoaHZfdmhjYSwgQklUKE1MWDVfSFZfVkhDQV9BR0VOVF9D
T05UUk9MKSk7DQo+ICt9DQo+ICsNCj4gIHN0cnVjdCBtbHg1X2h2X3ZoY2FfYWdlbnQgKg0KPiAg
bWx4NV9odl92aGNhX2FnZW50X2NyZWF0ZShzdHJ1Y3QgbWx4NV9odl92aGNhICpodl92aGNhLA0K
PiAgCQkJICBlbnVtIG1seDVfaHZfdmhjYV9hZ2VudF90eXBlIHR5cGUsDQo+IEBAIC0xNjgsNiAr
MjgyLDggQEAgc3RydWN0IG1seDVfaHZfdmhjYV9hZ2VudCAqDQo+ICAJaHZfdmhjYS0+YWdlbnRz
W3R5cGVdID0gYWdlbnQ7DQo+ICAJbXV0ZXhfdW5sb2NrKCZodl92aGNhLT5hZ2VudHNfbG9jayk7
DQo+ICANCj4gKwltbHg1X2h2X3ZoY2FfYWdlbnRzX3VwZGF0ZShodl92aGNhKTsNCj4gKw0KPiAg
CXJldHVybiBhZ2VudDsNCj4gIH0NCj4gIA0KPiBAQCAtMTg5LDYgKzMwNSw4IEBAIHZvaWQgbWx4
NV9odl92aGNhX2FnZW50X2Rlc3Ryb3koc3RydWN0IG1seDVfaHZfdmhjYV9hZ2VudCAqYWdlbnQp
DQo+ICAJCWFnZW50LT5jbGVhbnVwKGFnZW50KTsNCj4gIA0KPiAgCWtmcmVlKGFnZW50KTsNCj4g
Kw0KPiArCW1seDVfaHZfdmhjYV9hZ2VudHNfdXBkYXRlKGh2X3ZoY2EpOw0KPiAgfQ0KPiAgDQo+
ICBzdGF0aWMgaW50IG1seDVfaHZfdmhjYV9kYXRhX2Jsb2NrX3ByZXBhcmUoc3RydWN0IG1seDVf
aHZfdmhjYV9hZ2VudCAqYWdlbnQsDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2X3ZoY2EuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9saWIvaHZfdmhjYS5oDQo+IGluZGV4IGZhN2VlODUuLjZmNGJm
YjEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9saWIvaHZfdmhjYS5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9saWIvaHZfdmhjYS5oDQo+IEBAIC0xMiw2ICsxMiw3IEBADQo+ICBzdHJ1Y3QgbWx4
NV9odl92aGNhX2NvbnRyb2xfYmxvY2s7DQo+ICANCj4gIGVudW0gbWx4NV9odl92aGNhX2FnZW50
X3R5cGUgew0KPiArCU1MWDVfSFZfVkhDQV9BR0VOVF9DT05UUk9MID0gMCwNCg0KTm8gbmVlZCB0
byBzdGFydCB2YWx1ZQ0KDQo+ICAJTUxYNV9IVl9WSENBX0FHRU5UX01BWCA9IDMyLA0KPiAgfTsN
Cj4gIA0KPiANCg0KTWFyaw0K
