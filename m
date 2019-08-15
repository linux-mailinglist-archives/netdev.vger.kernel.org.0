Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623F08EA69
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 13:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbfHOLfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 07:35:43 -0400
Received: from mail-eopbgr130083.outbound.protection.outlook.com ([40.107.13.83]:36412
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfHOLfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 07:35:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1I05WasHn4Pj6zdZ+ptbPHk+SkvmftSW9PPeUTjWFWKx6gN/SFxzTmxQEKb6xAHLO9HfrgtKtG3kHuWxVnNVeYGHc/QwAftaIZoSdZW2fSmarkABQ5EclpxzmeB/UsBLvHsfYV5HQN7F37cJ2pj5MqMgMXfQ+2BCXifB5tppbQ/XoAizWrHtVwr3gUkr7WbDbtye7xQYpQ00pPN7bH/iSpvFbkrvXg7DoovzoyPsD5sCOYugBURHLYG5z21CY+wS99ZnSaJBNFftzE1h6D55sy6dolu+ipmS4/L6u7KfB/dTE4nVfopiRjQzcdfgnL103HotMZdb8DvN02iLxINUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2fVD0i+saHwdbRbMGLcqRI1ph0kXOJWWxdlVH0P4uo=;
 b=C7kB0QrzyfxoZ63gusdONoSfAec7UkUqZ63qmtd87d1M85sOv4GlqqyZMF7GiKvTb3gTzAngf0Di3GpUPki77CyQx5X3hg50/40Ay5TGqX72l8TsF+WjTR5mPbcV/hoF3GVvovuCqOcnuBLo215xkxsgzMtXsZyQi49p49ed0PxrKdh0tPvchnP+kmHRIZVmT+X/ZGjnfp68ApQLS6yGDR52fH4HaN+25CERcGpGKaknRRW7ieYFdUMbpFxEGjWRoaA/62sHSZiqLexT7s1q5uZ4fgxe9w2h9CVvbVaNZ1YDzbO687/dWq+/G8d1XZJlFjodHbRe0CizGEOr464nZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2fVD0i+saHwdbRbMGLcqRI1ph0kXOJWWxdlVH0P4uo=;
 b=nTGcFm7oKFeGpi+U3PTYEvI6av5cQkTJ6I6iQpxMGSe26rdIN3Onw9DbBF8/cZUFLmQFsosSM0HnfQ6ST8PpJHGOLIFuwU6W9Kave6mMNixsY/Qn0y++yZs/Bxsq4yUUSpOWS/sll/BXL2j223cNUsaCOlXiVTn+YdQrBykShSc=
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com (52.133.38.142) by
 AM0PR0502MB3922.eurprd05.prod.outlook.com (52.133.45.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Thu, 15 Aug 2019 11:35:36 +0000
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::9d51:ae68:d177:fc94]) by AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::9d51:ae68:d177:fc94%3]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 11:35:36 +0000
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
Subject: Re: [PATCH net-next, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Topic: [PATCH net-next, 5/6] net/mlx5: Add HV VHCA control agent
Thread-Index: AQHVUtO9zNHuFcCHaUyI5pmRtlX1Fqb7G7qAgAD5fwA=
Date:   Thu, 15 Aug 2019 11:35:36 +0000
Message-ID: <f5f65f2d-41cb-30a8-d20b-605093bc7c0d@mellanox.com>
References: <1565809632-39138-1-git-send-email-haiyangz@microsoft.com>
 <1565809632-39138-6-git-send-email-haiyangz@microsoft.com>
 <745f663e-0c56-84d0-a02b-106f788e3e8f@mellanox.com>
In-Reply-To: <745f663e-0c56-84d0-a02b-106f788e3e8f@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0001.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::14) To AM0PR0502MB4068.eurprd05.prod.outlook.com
 (2603:10a6:208:d::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=eranbe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 129948fa-eacb-4a90-f381-08d72174b116
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR0502MB3922;
x-ms-traffictypediagnostic: AM0PR0502MB3922:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB3922C9A217F0BCEC7C70B500BAAC0@AM0PR0502MB3922.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(199004)(189003)(478600001)(6246003)(486006)(53936002)(6512007)(31696002)(36756003)(31686004)(53546011)(81166006)(76176011)(6506007)(102836004)(25786009)(2501003)(386003)(316002)(52116002)(86362001)(476003)(7736002)(8676002)(66946007)(446003)(66476007)(66556008)(64756008)(66446008)(2616005)(305945005)(11346002)(14444005)(186003)(26005)(2906002)(71200400001)(81156014)(71190400001)(2201001)(54906003)(110136005)(4326008)(5660300002)(256004)(229853002)(8936002)(14454004)(6116002)(66066001)(7416002)(99286004)(6436002)(6486002)(1511001)(3846002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3922;H:AM0PR0502MB4068.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wj5jNaN0wxUhPzLRwfxELsbMZ2BJzVV/lwI9o1h+H14npXe81jDd5MsYHjS+0bGnPTYFu4OYBFghTLYZ60j53QfHF8I2Ob5VVfyHDjNH/Ua/9vJHMwyc2G0gxihzuWMHIrimUeNoZK048N7/u2Mle54YzXiIye2QNEXV/Hh4Mc7R5rRm0K5CGdHQs5XZ78ml6n4U6+bRCbIrk9VDR0/I4e/gf8tK34wkUK4+gWfbGt76q05cWU+GR9KC4/vF2sRGDnjOSs2RtgY0JHzzKkm0nMAXHZtuz1yESP6hEz5xm2Wfa3fDdj6jk9XoKGyj65NgRBzOIBpbgwmCx7fVySaDQ6Rol65tDQTZvbkVboI11PJIFd0/UiBnPXJhEqETiCN8O86LbiL1gpeGpOS9YSlcmb0W/oZw+Gzs+PEBXRWKPlQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC622825DD36E444A839998ADB7414EF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 129948fa-eacb-4a90-f381-08d72174b116
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 11:35:36.8657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FcDFhXv/70YKf9UVjewKT8tp8+QyxP7al+hbeMINfCa5+fONxPIo4gOvIqxFWgeNW9EmV+1tP6UUgoce6aC9ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3922
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTQvMjAxOSAxMTo0MSBQTSwgTWFyayBCbG9jaCB3cm90ZToNCj4gDQo+IA0KPiBP
biA4LzE0LzE5IDEyOjA5IFBNLCBIYWl5YW5nIFpoYW5nIHdyb3RlOg0KPj4gRnJvbTogRXJhbiBC
ZW4gRWxpc2hhIDxlcmFuYmVAbWVsbGFub3guY29tPg0KPj4NCj4+IENvbnRyb2wgYWdlbnQgaXMg
cmVzcG9uc2libGUgb3ZlciBvZiB0aGUgY29udHJvbCBibG9jayAoSUQgMCkuIEl0IHNob3VsZA0K
Pj4gdXBkYXRlIHRoZSBQRiB2aWEgdGhpcyBibG9jayBhYm91dCBldmVyeSBjYXBhYmlsaXR5IGNo
YW5nZS4gSW4gYWRkaXRpb24sDQo+PiB1cG9uIGJsb2NrIDAgaW52YWxpZGF0ZSwgaXQgc2hvdWxk
IGFjdGl2YXRlIGFsbCBvdGhlciBzdXBwb3J0ZWQgYWdlbnRzDQo+PiB3aXRoIGRhdGEgcmVxdWVz
dHMgZnJvbSB0aGUgUEYuDQo+Pg0KPj4gVXBvbiBhZ2VudCBjcmVhdGUvZGVzdHJveSwgdGhlIGlu
dmFsaWRhdGUgY2FsbGJhY2sgb2YgdGhlIGNvbnRyb2wgYWdlbnQNCj4+IGlzIGJlaW5nIGNhbGxl
ZCBpbiBvcmRlciB0byB1cGRhdGUgdGhlIFBGIGRyaXZlciBhYm91dCB0aGlzIGNoYW5nZS4NCj4+
DQo+PiBUaGUgY29udHJvbCBhZ2VudCBpcyBhbiBpbnRlZ3JhbCBwYXJ0IG9mIEhWIFZIQ0EgYW5k
IHdpbGwgYmUgY3JlYXRlZA0KPj4gYW5kIGRlc3Ryb3kgYXMgcGFydCBvZiB0aGUgSFYgVkhDQSBp
bml0L2NsZWFudXAgZmxvdy4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBFcmFuIEJlbiBFbGlzaGEg
PGVyYW5iZUBtZWxsYW5veC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8
c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4+IC0tLQ0KPj4gICAuLi4vbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9saWIvaHZfdmhjYS5jICB8IDEyMiArKysrKysrKysrKysrKysrKysrKy0N
Cj4+ICAgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2h2X3ZoY2EuaCAg
fCAgIDEgKw0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDEyMSBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvbGliL2h2X3ZoY2EuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9saWIvaHZfdmhjYS5jDQo+PiBpbmRleCBiMmVlYmRmLi4zYzdmZmZhIDEwMDY0
NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9o
dl92aGNhLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9saWIvaHZfdmhjYS5jDQo+PiBAQCAtMTEwLDIyICsxMTAsMTMxIEBAIHZvaWQgbWx4NV9odl92
aGNhX2ludmFsaWRhdGUodm9pZCAqY29udGV4dCwgdTY0IGJsb2NrX21hc2spDQo+PiAgIAlxdWV1
ZV93b3JrKGh2X3ZoY2EtPndvcmtfcXVldWUsICZ3b3JrLT5pbnZhbGlkYXRlX3dvcmspOw0KPj4g
ICB9DQo+PiAgIA0KPj4gKyNkZWZpbmUgQUdFTlRfTUFTSyh0eXBlKSAodHlwZSA/IEJJVCh0eXBl
IC0gMSkgOiAwIC8qIGNvbnRyb2wgKi8pDQo+PiArDQo+PiArc3RhdGljIHZvaWQgbWx4NV9odl92
aGNhX2FnZW50c19jb250cm9sKHN0cnVjdCBtbHg1X2h2X3ZoY2EgKmh2X3ZoY2EsDQo+PiArCQkJ
CQlzdHJ1Y3QgbWx4NV9odl92aGNhX2NvbnRyb2xfYmxvY2sgKmJsb2NrKQ0KPj4gK3sNCj4+ICsJ
aW50IGk7DQo+PiArDQo+PiArCWZvciAoaSA9IDA7IGkgPCBNTFg1X0hWX1ZIQ0FfQUdFTlRfTUFY
OyBpKyspIHsNCj4+ICsJCXN0cnVjdCBtbHg1X2h2X3ZoY2FfYWdlbnQgKmFnZW50ID0gaHZfdmhj
YS0+YWdlbnRzW2ldOw0KPj4gKw0KPj4gKwkJaWYgKCFhZ2VudCB8fCAhYWdlbnQtPmNvbnRyb2wp
DQo+PiArCQkJY29udGludWU7DQo+PiArDQo+PiArCQlpZiAoIShBR0VOVF9NQVNLKGFnZW50LT50
eXBlKSAmIGJsb2NrLT5jb250cm9sKSkNCj4+ICsJCQljb250aW51ZTsNCj4+ICsNCj4+ICsJCWFn
ZW50LT5jb250cm9sKGFnZW50LCBibG9jayk7DQo+PiArCX0NCj4+ICt9DQo+PiArDQo+PiArc3Rh
dGljIHZvaWQgbWx4NV9odl92aGNhX2NhcGFiaWxpdGllcyhzdHJ1Y3QgbWx4NV9odl92aGNhICpo
dl92aGNhLA0KPj4gKwkJCQkgICAgICB1MzIgKmNhcGFiaWxpdGllcykNCj4+ICt7DQo+PiArCWlu
dCBpOw0KPj4gKw0KPj4gKwlmb3IgKGkgPSAwOyBpIDwgTUxYNV9IVl9WSENBX0FHRU5UX01BWDsg
aSsrKSB7DQo+PiArCQlzdHJ1Y3QgbWx4NV9odl92aGNhX2FnZW50ICphZ2VudCA9IGh2X3ZoY2Et
PmFnZW50c1tpXTsNCj4+ICsNCj4+ICsJCWlmIChhZ2VudCkNCj4+ICsJCQkqY2FwYWJpbGl0aWVz
IHw9IEFHRU5UX01BU0soYWdlbnQtPnR5cGUpOw0KPj4gKwl9DQo+PiArfQ0KPj4gKw0KPj4gK3N0
YXRpYyB2b2lkDQo+PiArbWx4NV9odl92aGNhX2NvbnRyb2xfYWdlbnRfaW52YWxpZGF0ZShzdHJ1
Y3QgbWx4NV9odl92aGNhX2FnZW50ICphZ2VudCwNCj4+ICsJCQkJICAgICAgdTY0IGJsb2NrX21h
c2spDQo+PiArew0KPj4gKwlzdHJ1Y3QgbWx4NV9odl92aGNhICpodl92aGNhID0gYWdlbnQtPmh2
X3ZoY2E7DQo+PiArCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYgPSBodl92aGNhLT5kZXY7DQo+
PiArCXN0cnVjdCBtbHg1X2h2X3ZoY2FfY29udHJvbF9ibG9jayAqYmxvY2s7DQo+PiArCXUzMiBj
YXBhYmlsaXRpZXMgPSAwOw0KPj4gKwlpbnQgZXJyOw0KPj4gKw0KPj4gKwlibG9jayA9IGt6YWxs
b2Moc2l6ZW9mKCpibG9jayksIEdGUF9LRVJORUwpOw0KPj4gKwlpZiAoIWJsb2NrKQ0KPj4gKwkJ
cmV0dXJuOw0KPj4gKw0KPj4gKwllcnIgPSBtbHg1X2h2X3JlYWRfY29uZmlnKGRldiwgYmxvY2ss
IHNpemVvZigqYmxvY2spLCAwKTsNCj4+ICsJaWYgKGVycikNCj4+ICsJCWdvdG8gZnJlZV9ibG9j
azsNCj4+ICsNCj4+ICsJbWx4NV9odl92aGNhX2NhcGFiaWxpdGllcyhodl92aGNhLCAmY2FwYWJp
bGl0aWVzKTsNCj4+ICsNCj4+ICsJLyogSW4gY2FzZSBubyBjYXBhYmlsaXRpZXMsIHNlbmQgZW1w
dHkgYmxvY2sgaW4gcmV0dXJuICovDQo+PiArCWlmICghY2FwYWJpbGl0aWVzKSB7DQo+PiArCQlt
ZW1zZXQoYmxvY2ssIDAsIHNpemVvZigqYmxvY2spKTsNCj4+ICsJCWdvdG8gd3JpdGU7DQo+PiAr
CX0NCj4+ICsNCj4+ICsJaWYgKGJsb2NrLT5jYXBhYmlsaXRpZXMgIT0gY2FwYWJpbGl0aWVzKQ0K
Pj4gKwkJYmxvY2stPmNhcGFiaWxpdGllcyA9IGNhcGFiaWxpdGllczsNCj4+ICsNCj4+ICsJaWYg
KGJsb2NrLT5jb250cm9sICYgfmNhcGFiaWxpdGllcykNCj4+ICsJCWdvdG8gZnJlZV9ibG9jazsN
Cj4+ICsNCj4+ICsJbWx4NV9odl92aGNhX2FnZW50c19jb250cm9sKGh2X3ZoY2EsIGJsb2NrKTsN
Cj4+ICsJYmxvY2stPmNvbW1hbmRfYWNrID0gYmxvY2stPmNvbW1hbmQ7DQo+PiArDQo+PiArd3Jp
dGU6DQo+PiArCW1seDVfaHZfd3JpdGVfY29uZmlnKGRldiwgYmxvY2ssIHNpemVvZigqYmxvY2sp
LCAwKTsNCj4+ICsNCj4+ICtmcmVlX2Jsb2NrOg0KPj4gKwlrZnJlZShibG9jayk7DQo+PiArfQ0K
Pj4gKw0KPj4gK3N0YXRpYyBzdHJ1Y3QgbWx4NV9odl92aGNhX2FnZW50ICoNCj4+ICttbHg1X2h2
X3ZoY2FfY29udHJvbF9hZ2VudF9jcmVhdGUoc3RydWN0IG1seDVfaHZfdmhjYSAqaHZfdmhjYSkN
Cj4+ICt7DQo+PiArCXJldHVybiBtbHg1X2h2X3ZoY2FfYWdlbnRfY3JlYXRlKGh2X3ZoY2EsIE1M
WDVfSFZfVkhDQV9BR0VOVF9DT05UUk9MLA0KPj4gKwkJCQkJIE5VTEwsDQo+PiArCQkJCQkgbWx4
NV9odl92aGNhX2NvbnRyb2xfYWdlbnRfaW52YWxpZGF0ZSwNCj4+ICsJCQkJCSBOVUxMLCBOVUxM
KTsNCj4+ICt9DQo+PiArDQo+PiArc3RhdGljIHZvaWQgbWx4NV9odl92aGNhX2NvbnRyb2xfYWdl
bnRfZGVzdHJveShzdHJ1Y3QgbWx4NV9odl92aGNhX2FnZW50ICphZ2VudCkNCj4+ICt7DQo+PiAr
CW1seDVfaHZfdmhjYV9hZ2VudF9kZXN0cm95KGFnZW50KTsNCj4+ICt9DQo+PiArDQo+PiAgIGlu
dCBtbHg1X2h2X3ZoY2FfaW5pdChzdHJ1Y3QgbWx4NV9odl92aGNhICpodl92aGNhKQ0KPj4gICB7
DQo+PiArCXN0cnVjdCBtbHg1X2h2X3ZoY2FfYWdlbnQgKmFnZW50Ow0KPj4gKwlpbnQgZXJyOw0K
Pj4gKw0KPj4gICAJaWYgKElTX0VSUl9PUl9OVUxMKGh2X3ZoY2EpKQ0KPj4gICAJCXJldHVybiBJ
U19FUlJfT1JfTlVMTChodl92aGNhKTsNCj4+ICAgDQo+PiAtCXJldHVybiBtbHg1X2h2X3JlZ2lz
dGVyX2ludmFsaWRhdGUoaHZfdmhjYS0+ZGV2LCBodl92aGNhLA0KPj4gLQkJCQkJICAgbWx4NV9o
dl92aGNhX2ludmFsaWRhdGUpOw0KPj4gKwllcnIgPSBtbHg1X2h2X3JlZ2lzdGVyX2ludmFsaWRh
dGUoaHZfdmhjYS0+ZGV2LCBodl92aGNhLA0KPj4gKwkJCQkJICBtbHg1X2h2X3ZoY2FfaW52YWxp
ZGF0ZSk7DQo+PiArCWlmIChlcnIpDQo+PiArCQlyZXR1cm4gZXJyOw0KPj4gKw0KPj4gKwlhZ2Vu
dCA9IG1seDVfaHZfdmhjYV9jb250cm9sX2FnZW50X2NyZWF0ZShodl92aGNhKTsNCj4+ICsJaWYg
KElTX0VSUl9PUl9OVUxMKGFnZW50KSkgew0KPj4gKwkJbWx4NV9odl91bnJlZ2lzdGVyX2ludmFs
aWRhdGUoaHZfdmhjYS0+ZGV2KTsNCj4+ICsJCXJldHVybiBJU19FUlJfT1JfTlVMTChhZ2VudCk7
DQo+PiArCX0NCj4+ICsNCj4+ICsJaHZfdmhjYS0+YWdlbnRzW01MWDVfSFZfVkhDQV9BR0VOVF9D
T05UUk9MXSA9IGFnZW50Ow0KPj4gKw0KPj4gKwlyZXR1cm4gMDsNCj4+ICAgfQ0KPj4gICANCj4+
ICAgdm9pZCBtbHg1X2h2X3ZoY2FfY2xlYW51cChzdHJ1Y3QgbWx4NV9odl92aGNhICpodl92aGNh
KQ0KPj4gICB7DQo+PiArCXN0cnVjdCBtbHg1X2h2X3ZoY2FfYWdlbnQgKmFnZW50Ow0KPj4gICAJ
aW50IGk7DQo+PiAgIA0KPj4gICAJaWYgKElTX0VSUl9PUl9OVUxMKGh2X3ZoY2EpKQ0KPj4gICAJ
CXJldHVybjsNCj4+ICAgDQo+PiArCWFnZW50ID0gaHZfdmhjYS0+YWdlbnRzW01MWDVfSFZfVkhD
QV9BR0VOVF9DT05UUk9MXTsNCj4+ICsJaWYgKCFJU19FUlJfT1JfTlVMTChhZ2VudCkpDQo+PiAr
CQltbHg1X2h2X3ZoY2FfY29udHJvbF9hZ2VudF9kZXN0cm95KGFnZW50KTsNCj4gDQo+IENhbiB0
aGUgYWdlbnQgYmUgZXJyIHB0ciBoZXJlPw0KDQpPbmx5IE5VTEwsIHdpbGwgZml4Lg0KDQo+IA0K
Pj4gKw0KPj4gICAJbXV0ZXhfbG9jaygmaHZfdmhjYS0+YWdlbnRzX2xvY2spOw0KPj4gICAJZm9y
IChpID0gMDsgaSA8IE1MWDVfSFZfVkhDQV9BR0VOVF9NQVg7IGkrKykNCj4+ICAgCQlXQVJOX09O
KGh2X3ZoY2EtPmFnZW50c1tpXSk7DQo+IA0KPiBXaXRoIHRoZSBjb21tZW50IGFib3ZlIGluIG1p
bmQsIGhlcmUgeW91IGNoZWNrIG9ubHkgZm9yIG5vdCBudWxsDQoNCkNvbW1lbnQgYWJvdmUgd2Fz
IHJpZ2h0Li4uIGFmdGVyIGZpeGluZyBpdCwgYWxsIGlzIGFsaWduZWQgaGVyZS4NCg0KPiANCj4+
IEBAIC0xMzUsNiArMjQ0LDExIEBAIHZvaWQgbWx4NV9odl92aGNhX2NsZWFudXAoc3RydWN0IG1s
eDVfaHZfdmhjYSAqaHZfdmhjYSkNCj4+ICAgCW1seDVfaHZfdW5yZWdpc3Rlcl9pbnZhbGlkYXRl
KGh2X3ZoY2EtPmRldik7DQo+PiAgIH0NCj4+ICAgDQo+PiArc3RhdGljIHZvaWQgbWx4NV9odl92
aGNhX2FnZW50c191cGRhdGUoc3RydWN0IG1seDVfaHZfdmhjYSAqaHZfdmhjYSkNCj4+ICt7DQo+
PiArCW1seDVfaHZfdmhjYV9pbnZhbGlkYXRlKGh2X3ZoY2EsIEJJVChNTFg1X0hWX1ZIQ0FfQUdF
TlRfQ09OVFJPTCkpOw0KPj4gK30NCj4+ICsNCj4+ICAgc3RydWN0IG1seDVfaHZfdmhjYV9hZ2Vu
dCAqDQo+PiAgIG1seDVfaHZfdmhjYV9hZ2VudF9jcmVhdGUoc3RydWN0IG1seDVfaHZfdmhjYSAq
aHZfdmhjYSwNCj4+ICAgCQkJICBlbnVtIG1seDVfaHZfdmhjYV9hZ2VudF90eXBlIHR5cGUsDQo+
PiBAQCAtMTY4LDYgKzI4Miw4IEBAIHN0cnVjdCBtbHg1X2h2X3ZoY2FfYWdlbnQgKg0KPj4gICAJ
aHZfdmhjYS0+YWdlbnRzW3R5cGVdID0gYWdlbnQ7DQo+PiAgIAltdXRleF91bmxvY2soJmh2X3Zo
Y2EtPmFnZW50c19sb2NrKTsNCj4+ICAgDQo+PiArCW1seDVfaHZfdmhjYV9hZ2VudHNfdXBkYXRl
KGh2X3ZoY2EpOw0KPj4gKw0KPj4gICAJcmV0dXJuIGFnZW50Ow0KPj4gICB9DQo+PiAgIA0KPj4g
QEAgLTE4OSw2ICszMDUsOCBAQCB2b2lkIG1seDVfaHZfdmhjYV9hZ2VudF9kZXN0cm95KHN0cnVj
dCBtbHg1X2h2X3ZoY2FfYWdlbnQgKmFnZW50KQ0KPj4gICAJCWFnZW50LT5jbGVhbnVwKGFnZW50
KTsNCj4+ICAgDQo+PiAgIAlrZnJlZShhZ2VudCk7DQo+PiArDQo+PiArCW1seDVfaHZfdmhjYV9h
Z2VudHNfdXBkYXRlKGh2X3ZoY2EpOw0KPj4gICB9DQo+PiAgIA0KPj4gICBzdGF0aWMgaW50IG1s
eDVfaHZfdmhjYV9kYXRhX2Jsb2NrX3ByZXBhcmUoc3RydWN0IG1seDVfaHZfdmhjYV9hZ2VudCAq
YWdlbnQsDQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2xpYi9odl92aGNhLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvbGliL2h2X3ZoY2EuaA0KPj4gaW5kZXggZmE3ZWU4NS4uNmY0YmZiMSAxMDA2NDQNCj4+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvaHZfdmhj
YS5oDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGli
L2h2X3ZoY2EuaA0KPj4gQEAgLTEyLDYgKzEyLDcgQEANCj4+ICAgc3RydWN0IG1seDVfaHZfdmhj
YV9jb250cm9sX2Jsb2NrOw0KPj4gICANCj4+ICAgZW51bSBtbHg1X2h2X3ZoY2FfYWdlbnRfdHlw
ZSB7DQo+PiArCU1MWDVfSFZfVkhDQV9BR0VOVF9DT05UUk9MID0gMCwNCj4gDQo+IE5vIG5lZWQg
dG8gc3RhcnQgdmFsdWUNCg0KSSBmaW5kIGl0IG1vcmUgZWFzeSB0byByZWFkIHdoZW4gaGF2aW5n
IHRoZSB2YWx1ZSBleHBsaWNpdGx5Lg0KSWYgeW91IG9yIFNhZWVkIGhhcyBhIHN0cm9uZyBvcGlu
aW9uIGFnYWluc3QgaXQsIHRoaXMgY2FuIGJlIGVhc2lseSBmaXhlZC4NCg0KPiANCj4+ICAgCU1M
WDVfSFZfVkhDQV9BR0VOVF9NQVggPSAzMiwNCj4+ICAgfTsNCj4+ICAgDQo+Pg0KPiANCj4gTWFy
aw0KPiANCg==
