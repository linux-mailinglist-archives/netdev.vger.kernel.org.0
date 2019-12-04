Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5DF112164
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 03:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfLDCZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 21:25:36 -0500
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:25766
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726189AbfLDCZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 21:25:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DobrDPcf3DEnViUpH5WeuCIPY9uReD9mNpqU9pGDUM7y0okj4KRVgdAVyPPZzrN+TcTy2nQqC1vOtISTALPs8fnGmBklilb5x5znvkbMm1ABqanTTw1Dlird7IMnaTucsOD6Cdd+A2GpMGhapYk0xQMPNLQWlbcu/eFczpXCxs6DrzzSa/vK2DPgbzqbs3okCI2PhJZQd/dw2JbYB9AL5kzAZILyjcQQ5wLaULMzlmyj+npdWisy3+Oq3G/O5QnliA5NEorrTULF0J9JFm4+lu5gtl4LLunHpQb5UHrlTTyTimG/zGHCYtlSzUp8qDbhhAnLvq0cCO8/zyPh43W8Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIuCisTHaitMPtRPaZT9bnTp0N6PiObRlwyW5aJVuis=;
 b=MQbTQO80qg9zqrOHdpX6V8sOUwqnU0uniReYlY3p1F+D8mORBZQUDdbYeidmPGTonYOT3MXKyAkTWBfNMX2QBtZCC4qGr7LpScsa7cx67lJsOuplhHLYS33lSrqLmxvUDGvd3MawOl2F/9OYsvtP4LptcfRko96drUt0WokakIi2ldS7TQMIkLb8Ha3oaqgx6ix/rCrV+V6JPC5fyK4Gq6tN/mJ389aJEVmNt3x3XzYgneN8WubB35lklQHyos0mtBKvbFRFJ1j6NCLMb9irV9QoAoAdiiT8FclBsJGg5p2TaxRUauhRbeae5dFOO1zfQNmA1Nbl9eccLSNmuyKqcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIuCisTHaitMPtRPaZT9bnTp0N6PiObRlwyW5aJVuis=;
 b=Czns4egdQcD+ToZ9xZ3M5LJFl9PWv5vZspyIPZIfxUgDNKgeDHJl9WCRAy8ww/+r6kUSwnkvZTswrFA5mYo8VrwDwhf0t89gNvK4xAN6Fp1lm3bRwLh+NtCBRi1ZUq+ndVE0RUS+i1YE5Bs4EFwgGq9GXhRDjnW/JOItHfAlrh4=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4156.eurprd04.prod.outlook.com (52.134.110.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 02:25:30 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 02:25:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Topic: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Index: AQHVpOd3D9txXS3dtUSMzmH9fMhQMaepSgMg
Date:   Wed, 4 Dec 2019 02:25:30 +0000
Message-ID: <DB7PR04MB46186030E16AE49DB8503246E65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-5-qiangqing.zhang@nxp.com>
In-Reply-To: <20191127055334.1476-5-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 446628a3-5e30-4449-b736-08d778613b8d
x-ms-traffictypediagnostic: DB7PR04MB4156:|DB7PR04MB4156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB415612EF2B468EACA8C0F7DBE65D0@DB7PR04MB4156.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(199004)(54534003)(13464003)(189003)(71200400001)(71190400001)(6246003)(99286004)(33656002)(316002)(4326008)(14454004)(2501003)(478600001)(256004)(14444005)(25786009)(110136005)(76176011)(26005)(186003)(229853002)(6506007)(74316002)(53546011)(7696005)(305945005)(11346002)(7736002)(102836004)(6436002)(2201001)(446003)(52536014)(5660300002)(3846002)(9686003)(54906003)(6116002)(55016002)(86362001)(76116006)(64756008)(66556008)(66446008)(66476007)(81166006)(8676002)(66946007)(81156014)(8936002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4156;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G/mSWD8yzSlGOk85UEwbH7X2+xL1MVK9XNbwZsgeW2sUJcAlH/umZGBrsNLuGjgFqDnHUVk4um9q1RsvffCZDw5PcdEHvkM8a2EOiJSp+CRDay3Dt7jNdE9CJm2I55Jg9hF3TW+Jw41GQ4hi3oYkxFYDG3S5myrx4Lt+mwjWeh3ln1Bqh0SIAF9jmSZ7GHm1AUHco+Cx0uEyW1i+bYuRHxeLvEVj9BgViOhDQeTwNlRyiyMyqgNfCBGYy1j6+IjN0xgFmKAGxJ0DDKyXSvcfxrd8ykuuE4WxaXhRXpVAGhCTiJn/BXXP7BCyeiM4R9+NBdxSCptbTzj5ZX+QSv6NmhAI4M4X1aeb+KnUVDHP8dtJqrkuM9TVzXeCGDkWyWglSPsJn8EzX3HWP8O4vA+F4PXDOpW1dSdnUVT17bqXlzKfnmMREA2azJBSZNTBfeuHrrQmUfwTMcHUs9GUab7O9nUFgDWX0ZzKFDo18s1aOKbycLi3eX1vzEI0ntRGpgp5f+8Hf5G+dS5zTxMjG2r7gg==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 446628a3-5e30-4449-b736-08d778613b8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 02:25:30.2268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1idmB/A5auvP8B4mvm+svhBO7kauO9edmdsSAE20VPjjOD1P0uw9qegg8qUQGG2EXSvrDICxTJpM6didSHC0Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQpZb3UgbWF5IGhhdmUgbWlzc2VkIHRoaXMgcGF0Y2gsIGFueSBjb21tZW50
cyBhYm91dCBpdD8NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQoNCj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdA
bnhwLmNvbT4NCj4gU2VudDogMjAxOcTqMTHUwjI3yNUgMTM6NTcNCj4gVG86IG1rbEBwZW5ndXRy
b25peC5kZTsgc2VhbkBnZWFuaXguY29tOyBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENj
OiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgSm9ha2ltIFpoYW5nDQo+IDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gU3ViamVjdDog
W1BBVENIIFYyIDQvNF0gY2FuOiBmbGV4Y2FuOiBhZGQgTFBTUiBtb2RlIHN1cHBvcnQNCj4gDQo+
IEZvciBpLk1YN0QgTFBTUiBtb2RlLCB0aGUgY29udHJvbGxlciB3aWxsIGxvc3QgcG93ZXIgYW5k
IGdvdCB0aGUgY29uZmlndXJhdGlvbg0KPiBzdGF0ZSBsb3N0IGFmdGVyIHN5c3RlbSByZXN1bWUg
YmFjay4gKGNvbWluZyBpLk1YOFFNL1FYUCB3aWxsIGFsc28NCj4gY29tcGxldGVseSBwb3dlciBv
ZmYgdGhlIGRvbWFpbiwgdGhlIGNvbnRyb2xsZXIgc3RhdGUgd2lsbCBiZSBsb3N0IGFuZCBuZWVk
cw0KPiByZXN0b3JlKS4NCj4gU28gd2UgbmVlZCB0byBzZXQgcGluY3RybCBzdGF0ZSBhZ2FpbiBh
bmQgcmUtc3RhcnQgY2hpcCB0byBkbyByZS1jb25maWd1cmF0aW9uDQo+IGFmdGVyIHJlc3VtZS4N
Cj4gDQo+IEZvciB3YWtldXAgY2FzZSwgaXQgc2hvdWxkIG5vdCBzZXQgcGluY3RybCB0byBzbGVl
cCBzdGF0ZSBieQ0KPiBwaW5jdHJsX3BtX3NlbGVjdF9zbGVlcF9zdGF0ZS4NCj4gRm9yIGludGVy
ZmFjZSBpcyBub3QgdXAgYmVmb3JlIHN1c3BlbmQgY2FzZSwgd2UgZG9uJ3QgbmVlZCByZS1jb25m
aWd1cmUgYXMgaXQNCj4gd2lsbCBiZSBjb25maWd1cmVkIGJ5IHVzZXIgbGF0ZXIgYnkgaW50ZXJm
YWNlIHVwLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fpbmcuemhh
bmdAbnhwLmNvbT4NCj4gLS0tLS0tDQo+IENoYW5nZUxvZzoNCj4gCVYxLT5WMjogbm8gY2hhbmdl
Lg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCAyMSArKysrKysrKysrKysr
Ky0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2
ZXJzL25ldC9jYW4vZmxleGNhbi5jIGluZGV4DQo+IGQxNzgxNDZiM2RhNS4uZDE1MDljZmZkZDI0
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gQEAgLTI2LDYgKzI2LDcgQEANCj4gICNpbmNsdWRlIDxs
aW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9wbV9ydW50aW1lLmg+
DQo+ICAjaW5jbHVkZSA8bGludXgvcmVndWxhdG9yL2NvbnN1bWVyLmg+DQo+ICsjaW5jbHVkZSA8
bGludXgvcGluY3RybC9jb25zdW1lci5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3JlZ21hcC5oPg0K
PiANCj4gICNkZWZpbmUgRFJWX05BTUUJCQkiZmxleGNhbiINCj4gQEAgLTE3MDcsNyArMTcwOCw3
IEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxleGNhbl9zdXNwZW5kKHN0cnVjdA0KPiBk
ZXZpY2UgKmRldmljZSkgIHsNCj4gIAlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gZGV2X2dldF9k
cnZkYXRhKGRldmljZSk7DQo+ICAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9w
cml2KGRldik7DQo+IC0JaW50IGVyciA9IDA7DQo+ICsJaW50IGVycjsNCj4gDQo+ICAJaWYgKG5l
dGlmX3J1bm5pbmcoZGV2KSkgew0KPiAgCQkvKiBpZiB3YWtldXAgaXMgZW5hYmxlZCwgZW50ZXIg
c3RvcCBtb2RlIEBAIC0xNzE5LDI1ICsxNzIwLDI3DQo+IEBAIHN0YXRpYyBpbnQgX19tYXliZV91
bnVzZWQgZmxleGNhbl9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCj4gIAkJCWlmIChl
cnIpDQo+ICAJCQkJcmV0dXJuIGVycjsNCj4gIAkJfSBlbHNlIHsNCj4gLQkJCWVyciA9IGZsZXhj
YW5fY2hpcF9kaXNhYmxlKHByaXYpOw0KPiArCQkJZmxleGNhbl9jaGlwX3N0b3AoZGV2KTsNCj4g
Kw0KPiArCQkJZXJyID0gcG1fcnVudGltZV9mb3JjZV9zdXNwZW5kKGRldmljZSk7DQo+ICAJCQlp
ZiAoZXJyKQ0KPiAgCQkJCXJldHVybiBlcnI7DQo+IA0KPiAtCQkJZXJyID0gcG1fcnVudGltZV9m
b3JjZV9zdXNwZW5kKGRldmljZSk7DQo+ICsJCQlwaW5jdHJsX3BtX3NlbGVjdF9zbGVlcF9zdGF0
ZShkZXZpY2UpOw0KPiAgCQl9DQo+ICAJCW5ldGlmX3N0b3BfcXVldWUoZGV2KTsNCj4gIAkJbmV0
aWZfZGV2aWNlX2RldGFjaChkZXYpOw0KPiAgCX0NCj4gIAlwcml2LT5jYW4uc3RhdGUgPSBDQU5f
U1RBVEVfU0xFRVBJTkc7DQo+IA0KPiAtCXJldHVybiBlcnI7DQo+ICsJcmV0dXJuIDA7DQo+ICB9
DQo+IA0KPiAgc3RhdGljIGludCBfX21heWJlX3VudXNlZCBmbGV4Y2FuX3Jlc3VtZShzdHJ1Y3Qg
ZGV2aWNlICpkZXZpY2UpICB7DQo+ICAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IGRldl9nZXRf
ZHJ2ZGF0YShkZXZpY2UpOw0KPiAgCXN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYgPSBuZXRkZXZf
cHJpdihkZXYpOw0KPiAtCWludCBlcnIgPSAwOw0KPiArCWludCBlcnI7DQo+IA0KPiAgCXByaXYt
PmNhbi5zdGF0ZSA9IENBTl9TVEFURV9FUlJPUl9BQ1RJVkU7DQo+ICAJaWYgKG5ldGlmX3J1bm5p
bmcoZGV2KSkgew0KPiBAQCAtMTc0OSwxNSArMTc1MiwxOSBAQCBzdGF0aWMgaW50IF9fbWF5YmVf
dW51c2VkDQo+IGZsZXhjYW5fcmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCj4gIAkJCWlm
IChlcnIpDQo+ICAJCQkJcmV0dXJuIGVycjsNCj4gIAkJfSBlbHNlIHsNCj4gKwkJCXBpbmN0cmxf
cG1fc2VsZWN0X2RlZmF1bHRfc3RhdGUoZGV2aWNlKTsNCj4gKw0KPiAgCQkJZXJyID0gcG1fcnVu
dGltZV9mb3JjZV9yZXN1bWUoZGV2aWNlKTsNCj4gIAkJCWlmIChlcnIpDQo+ICAJCQkJcmV0dXJu
IGVycjsNCj4gDQo+IC0JCQllcnIgPSBmbGV4Y2FuX2NoaXBfZW5hYmxlKHByaXYpOw0KPiArCQkJ
ZXJyID0gZmxleGNhbl9jaGlwX3N0YXJ0KGRldik7DQo+ICsJCQlpZiAoZXJyKQ0KPiArCQkJCXJl
dHVybiBlcnI7DQo+ICAJCX0NCj4gIAl9DQo+IA0KPiAtCXJldHVybiBlcnI7DQo+ICsJcmV0dXJu
IDA7DQo+ICB9DQo+IA0KPiAgc3RhdGljIGludCBfX21heWJlX3VudXNlZCBmbGV4Y2FuX3J1bnRp
bWVfc3VzcGVuZChzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQo+IC0tDQo+IDIuMTcuMQ0KDQo=
