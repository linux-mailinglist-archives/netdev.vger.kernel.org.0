Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41AD118299
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfLJIld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:41:33 -0500
Received: from mail-eopbgr10082.outbound.protection.outlook.com ([40.107.1.82]:54944
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726847AbfLJIld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 03:41:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIcPB33ztiLcZLgeWOnLgpXHaUxAi1hTmXmL75CvMAxNWsktWgK/TZ0dAnRJfpBY9iBEtSHtfmsEkxr6t+dHpyJFJBYFXIgkcFrAoLTvYGGDOH5b4K3NfgDo0BFAR8W7PUNk33/PZzqqkOeM+KMJa4v5SyDlG4mVfq6BRpknXZfx65NdggZGvy39Yy/yrHMPmzLomh//ni2W1mY3D9frBqOT3GSLy3p6xBGg/+g08YYori2ZZGF3wu0xtygJz+BTqk0Dbqpd1nJ0UNVKr6kgDIxQVJROSgBD130snY0UDd/arBlM+3DvGzXZiosrCXmgR1fZEnrafMNR65uQvGUcQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8frb4hpyvmjeSBbKaQpj6VcyTWH0wITp6FShWXHu1IU=;
 b=MBJ7UAeS5hrdFa5/ZrmriVAlpa1NDQpCJ5+6M+ZLbpPLfIRTz0aDZUzf2rlRtTHJLRk96sYTmx1fj2slxAJX37JDN5r4RE/NCTWnXwwqjq3XfhC6ZmfUcikDvMbDvImESdN/5IzkGMKY/x2axfVWauAUhwuUo/Vf3Zg+cTq5VZaHPMgKGizO4g9uqHievpVpRC9T2Gx2H5ufcj4BqKqvH4ITl/s98uIqSiGTWmmYL7Hrk7EMIfwc1g3kFPHXzL3YSRg8B5ZVg9zkAc+FRd+cC5+WFHPZyarI6lBj+3Lv5LOMtX/MhCynXTkdKKKJjeIY3t+eLndya9l9v2++gt9UGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8frb4hpyvmjeSBbKaQpj6VcyTWH0wITp6FShWXHu1IU=;
 b=hA7FRJq+fmClxUzShvvQatgrSoDhzUNMp4YXJIuLNj88Y7o+oIdzVBMfruO7xFXwbvAYV4h1N2dJjq0w2ACEeEblpcoWcUSML2+ZUZRiX9ZHMnL4CbutVpe7ZjCtAXCWNIA7SetBUqt84lXAroH6ITm+tQ1T86eL91umhk4RVYo=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5561.eurprd04.prod.outlook.com (20.178.104.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 08:41:29 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 08:41:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/2] can: flexcan: disable clocks during stop mode
Thread-Topic: [PATCH 2/2] can: flexcan: disable clocks during stop mode
Thread-Index: AQHVrymtB+TSUJwNhE6xk7ucZQ3eC6ezCjKAgAACe9A=
Date:   Tue, 10 Dec 2019 08:41:29 +0000
Message-ID: <DB7PR04MB4618045D0E1135A514329AFFE65B0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191210071252.26165-1-qiangqing.zhang@nxp.com>
 <20191210071252.26165-2-qiangqing.zhang@nxp.com>
 <3ccfc7ac-b860-8254-ad39-66e2f50a5f3c@pengutronix.de>
In-Reply-To: <3ccfc7ac-b860-8254-ad39-66e2f50a5f3c@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 39440161-e906-43b5-a1e3-08d77d4cc05f
x-ms-traffictypediagnostic: DB7PR04MB5561:|DB7PR04MB5561:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5561C6B4D7E9E9A2F4D04E95E65B0@DB7PR04MB5561.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(189003)(199004)(13464003)(66446008)(76116006)(64756008)(53546011)(33656002)(186003)(26005)(8676002)(6506007)(66556008)(71190400001)(7696005)(66476007)(966005)(478600001)(86362001)(110136005)(66946007)(54906003)(316002)(2906002)(52536014)(55016002)(305945005)(9686003)(8936002)(229853002)(71200400001)(5660300002)(4326008)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5561;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjIw0qJjxQjnKApzRf67qFOO4Y6pyqVghHTUAGNiRBUYrSn2ROQUA9r03pAIl7R/v4Q2EYE6aGWy+ie56JoNcc2zPwkqR4ZEgKDZjJq0hzuFiZ3i6fO/HH1NnYiCmf5WXf8gYUcRZwLsAJCjr5JdVM4QVNR4fDbZY+Zykpaiz3QhKrN607ybrHiPXi8PYv7B1gRj7BZabaY8a1TxfO3mbEIte8X1kU0VAVTjCJL5xq7fuzL7l16LlkQMogxwTCpbogVCpO3wP9VcNWdINj6Wgn/Qz+/5yhbq/sEvf6vcMjXdkOvNlr1onKqKFgyY/hAr7aPGYLCKoWhMObCYfowfVUToiyvPDrCyKKhB/dAsklv6Uu/wBNvWRaMUrG8S+gECH/ZIM1tphkFaw1ftUfvLTIkv7hXGBKvl2V4OYUyhRBUsbLfP+4Dw5HKH7IbYDRdXJ44lPi3DqYgCXpMHfZBzKHZ+EW8Zc1oYfje2vCx9vhtGA8IrORHTIgehD3w6C2xZ1yOoMTvQH13L7eNuS95dYK1C0pipMu3zQsomTauhULI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39440161-e906-43b5-a1e3-08d77d4cc05f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 08:41:29.4184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aXwoTT7q0ITOxwnDeiAT+LbgXwr/CAy1xIIarIOgo0t7DhDo0wCxayBtj2qFIu0a/yyG//Xcma9c41z2C93GxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5561
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQxMuaciDEw5pelIDE2OjMyDQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgc2VhbkBnZWFuaXgu
Y29tOw0KPiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxp
bnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIDIvMl0gY2FuOiBmbGV4Y2FuOiBkaXNhYmxlIGNsb2NrcyBkdXJpbmcgc3RvcCBtb2Rl
DQo+IA0KPiBPbiAxMi8xMC8xOSA4OjE2IEFNLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4gRGlz
YWJsZSBjbG9ja3MgZHVyaW5nIENBTiBpbiBzdG9wIG1vZGUuDQo+ID4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiA+IC0tLQ0KPiA+
ICBkcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIHwgMTMgKysrKysrKysrKysrLQ0KPiA+ICAxIGZp
bGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2ZXJzL25ldC9jYW4vZmxl
eGNhbi5jDQo+ID4gaW5kZXggNmMxY2NmOWY2YzA4Li5kNzY3Zjg1YzgwZDMgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2Nh
bi9mbGV4Y2FuLmMNCj4gPiBAQCAtMTc4NiwxMCArMTc4NiwxNiBAQCBzdGF0aWMgaW50IF9fbWF5
YmVfdW51c2VkDQo+ID4gZmxleGNhbl9ub2lycV9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldmlj
ZSkgIHsNCj4gPiAgCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBkZXZfZ2V0X2RydmRhdGEoZGV2
aWNlKTsNCj4gPiAgCXN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihkZXYp
Ow0KPiA+ICsJaW50IGVycjsNCj4gPg0KPiA+IC0JaWYgKG5ldGlmX3J1bm5pbmcoZGV2KSAmJiBk
ZXZpY2VfbWF5X3dha2V1cChkZXZpY2UpKQ0KPiA+ICsJaWYgKG5ldGlmX3J1bm5pbmcoZGV2KSAm
JiBkZXZpY2VfbWF5X3dha2V1cChkZXZpY2UpKSB7DQo+ID4gIAkJZmxleGNhbl9lbmFibGVfd2Fr
ZXVwX2lycShwcml2LCB0cnVlKTsNCj4gPg0KPiA+ICsJCWVyciA9IHBtX3J1bnRpbWVfZm9yY2Vf
c3VzcGVuZChkZXZpY2UpOw0KPiA+ICsJCWlmIChlcnIpDQo+ID4gKwkJCXJldHVybiBlcnI7DQo+
ID4gKwl9DQo+IA0KPiBXaGF0IGFib3V0IG1vdmluZyB0aGUgcG1fcnVudGltZV9mb3JjZV9zdXNw
ZW5kKCkgY2FsbCBmb3IgYm90aCBjYXNlcw0KPiAiZGV2aWNlX21heV93YWtldXAoKSIgYW5kICIh
ZGV2aWNlX21heV93YWtldXAoKSIgaW50byB0aGUNCj4gZmxleGNhbl9ub2lycV9zdXNwZW5kKCkg
aGFuZGxlcj8NCg0KU291bmRzIGdyZWF0ISBJIHdpbGwgZG8gaXQgaW4gVjIuDQoNCkJlc3QgUmVn
YXJkcywNCkpvYWtpbSBaaGFuZw0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksu
ICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVtYmVk
ZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUg
IHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0y
ODI2LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDog
ICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==
