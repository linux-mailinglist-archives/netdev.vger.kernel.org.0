Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46277FD3F4
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfKOFKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:10:00 -0500
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:28741
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbfKOFKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 00:10:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6YfUHDV5GmIssTEETjBIjRKsEI4Dgpmr5yalIcAKcOlWc+3ErgRID4hAqDhbyIVXg5Dmc9bRcnroiA2480pdJAlgGfMZtCRdviU+cWjO3nWz1meEo5Bx7frBFCrioNS1pFMJPYPtxies9BYDmeF54IqwZXrokxapwz3ZaLIINiqdWGmUPWDTgxg93UfUJQir+rvOaTujDUqUw2JBZz8rJsB4okSmLaNig9XJeUY/ZsZk+QTCK72F8FB3QgM7q20bgd2OdyDLsH0WSGrVO3H2ggr00IngCdvEBp2cDTEN1VWDpVkdj7fLkkWAkkqtgY12IVCFX6wsgTw4PdewikUtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5fNGrVkOtzgua3y87Qa3uh8R4b9GCtX7y4M4Jjbi0g=;
 b=Es3Kwh/PDYZ8DJgB1oS428a+NbI+bM1fCheT4vDAlPdKUaDbjyG8+y1IOXe250XN4I+OtTISpyruOpT1rAVYlje10Sg7wQg+1FQ44NjVJkYxBlBtp6XqCKQRhYfULQ4kinqiLOqNrhMt4Y98mH0JXlJNf16S94O2z9faWvpqZO4Tje3rqBZhw3Tpdc+Qp5KWcfCP3YQpy0hHZh9TZO+vedo1x+Yf8AwL3nqjvmUGqutEsEufKDKDVm8j6dcRvwZA8ZrMRlgDD2D7sgHQ62fQr5Qll/qBUP3ykE9CxT9nL8ZGubCZye9Y39wl+BmaTBNxbmMIBvdiahgrq5tq3Jzvug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5fNGrVkOtzgua3y87Qa3uh8R4b9GCtX7y4M4Jjbi0g=;
 b=i5/QKoR8Q/vvcjB0ZMp2o5gVHZkA/zY19rk8KpkxG8wuJUMiyUD3lC2Su3vTsT8+9Szz5TtI1QPL8Pb/gnJuWKtayXPOubJaaEK3BZ6tdmFOV1v9SYrQc5knGz5eBGGBktOBLP6Q0ViMHLQW/+do4aUs2E+DW5LqZUPfC5yV4/s=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5355.eurprd04.prod.outlook.com (20.178.105.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Fri, 15 Nov 2019 05:09:53 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 05:09:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVm3IDm0rriooN3k2DjIsf/kbhcKeLrVbg
Date:   Fri, 15 Nov 2019 05:09:53 +0000
Message-ID: <DB7PR04MB4618335E8A90387EDAE17F21E6700@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b73127c1-82ea-4bb5-4d3c-08d7698a0cdc
x-ms-traffictypediagnostic: DB7PR04MB5355:|DB7PR04MB5355:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5355126361D4415BE72A6C61E6700@DB7PR04MB5355.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(199004)(189003)(13464003)(478600001)(66556008)(102836004)(66476007)(66946007)(64756008)(2906002)(14454004)(26005)(66446008)(6506007)(76176011)(53546011)(446003)(14444005)(256004)(11346002)(476003)(486006)(7736002)(6116002)(8676002)(3846002)(7696005)(186003)(305945005)(8936002)(9686003)(81166006)(55016002)(86362001)(6436002)(229853002)(2201001)(4326008)(81156014)(74316002)(66066001)(6246003)(76116006)(110136005)(52536014)(5660300002)(2501003)(316002)(33656002)(71190400001)(71200400001)(99286004)(54906003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5355;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P5UQ544nyEwNvs0ESIjfRp974a2MZDECpSBgeVjy06zbffk5Um129cwPXLZm6HuT6u2XwzJc+fsFrTJz+LJRcZNQtEzq/Oamr/czVIXeHq9jy/imp4Xoqz6WrN+tIhQxJZLAEfu/gx9JNYLQFY61oq8CbUDbpr1xM4eGa4BrNCcuqp5J3Vp/i2k7W0JGxQ8IGbPNTeKXHODunce7zOS8nHCRYk8g8euML9AjzxD+c47j74wRwY0uImJWIZeVo7imyeBoyee1HdEkLpIAEIhhS03cMqy6oM9K32TjNyE3MGOUShUIcJKNyR4uimZ9osNHKPvTh/WF8inJVSUFdGPLqO4NVMZcD1mLV2eMQXCEwVZ9hz5v7tRrIHLIEsyqM7fYamO+h4qm3AqSKbubS+98JPWWTlehYdiURA5fkRC+WUbtg5GP+T5kNERpTg0b2fXd
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b73127c1-82ea-4bb5-4d3c-08d7698a0cdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 05:09:53.7032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dkLF3rAGYxbm+o1R6DK+DKByiYl6RBcdv3BU/+20dJwwQ6ok8tuiybjtXzSzpYtJ0ffirpNjUI89GG6ZomoH5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5355
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBTZWFuLA0KDQpJIHJlbWVtYmVyIHRoYXQgeW91IGFyZSB0aGUgZmlyc3Qgb25lIHNlbmRp
bmcgb3V0IHRoZSBwYXRjaCB0byBmaXggdGhpcyBpc3N1ZSwgYW5kIEkgTkFDSyB0aGUgcGF0Y2gg
YmVmb3JlLg0KSSBhbSBzbyBzb3JyeSBmb3IgdGhhdCwgaXQgY2FuIHdvcmsgZmluZSBhZnRlciB0
ZXN0aW5nIGF0IG15IHNpZGUuIENvdWxkIHlvdSBoZWxwIGRvdWJsZSBjaGVjayBhdCB5b3VyIHNp
ZGUgZm9yDQp0aGlzIHBhdGNoPyBCb3RoIHdha2V1cCBmcm9tIHRvdGFsbHkgc3VzcGVuZCBhbmQg
d2FrZXVwIGZyb20gc3VzcGVuZGluZz8NCg0KV2l0aCB0aGlzIHBhdGNoLCB3ZSBjYW4gZml4IHR3
byBwcm9ibGVtczoNCjEpIGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNlbGYgd2FrZXVwDQoyKSBm
cmFtZXMgb3V0LW9mLW9yZGVyIGluIGZpcnN0IElSUSBoYW5kbGVyIHJ1biBhZnRlciB3YWtldXAN
Cg0KVGhhbmtzIGEgbG90IQ0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPg0KPiBTZW50OiAyMDE5xOoxMdTCMTXI1SAxMzowMw0KPiBUbzogbWtsQHBl
bmd1dHJvbml4LmRlOyBzZWFuQGdlYW5peC5jb207IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcN
Cj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBKb2FraW0gWmhhbmcNCj4gPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBTdWJq
ZWN0OiBbUEFUQ0ggMS8zXSBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNl
bGYgd2FrZXVwDQo+IA0KPiBGcm9tOiBTZWFuIE55ZWtqYWVyIDxzZWFuQGdlYW5peC5jb20+DQo+
IA0KPiBXaGVuIHN1c3BlbmRpbmcsIHdoZW4gdGhlcmUgaXMgc3RpbGwgY2FuIHRyYWZmaWMgb24g
dGhlIGludGVyZmFjZXMgdGhlIGZsZXhjYW4NCj4gaW1tZWRpYXRlbHkgd2FrZXMgdGhlIHBsYXRm
b3JtIGFnYWluLiBBcyBpdCBzaG91bGQgOi0pLiBCdXQgaXQgdGhyb3dzIHRoaXMgZXJyb3INCj4g
bXNnOg0KPiBbIDMxNjkuMzc4NjYxXSBQTTogbm9pcnEgc3VzcGVuZCBvZiBkZXZpY2VzIGZhaWxl
ZA0KPiANCj4gT24gdGhlIHdheSBkb3duIHRvIHN1c3BlbmQgdGhlIGludGVyZmFjZSB0aGF0IHRo
cm93cyB0aGUgZXJyb3IgbWVzc2FnZSBkb2VzDQo+IGNhbGwgZmxleGNhbl9zdXNwZW5kIGJ1dCBm
YWlscyB0byBjYWxsIGZsZXhjYW5fbm9pcnFfc3VzcGVuZC4gVGhhdCBtZWFucyB0aGUNCj4gZmxl
eGNhbl9lbnRlcl9zdG9wX21vZGUgaXMgY2FsbGVkLCBidXQgb24gdGhlIHdheSBvdXQgb2Ygc3Vz
cGVuZCB0aGUgZHJpdmVyDQo+IG9ubHkgY2FsbHMgZmxleGNhbl9yZXN1bWUgYW5kIHNraXBzIGZs
ZXhjYW5fbm9pcnFfcmVzdW1lLCB0aHVzIGl0IGRvZXNuJ3QgY2FsbA0KPiBmbGV4Y2FuX2V4aXRf
c3RvcF9tb2RlLiBUaGlzIGxlYXZlcyB0aGUgZmxleGNhbiBpbiBzdG9wIG1vZGUsIGFuZCB3aXRo
IHRoZQ0KPiBjdXJyZW50IGRyaXZlciBpdCBjYW4ndCByZWNvdmVyIGZyb20gdGhpcyBldmVuIHdp
dGggYSBzb2Z0IHJlYm9vdCwgaXQgcmVxdWlyZXMgYQ0KPiBoYXJkIHJlYm9vdC4NCj4gDQo+IFRo
aXMgcGF0Y2ggY2FuIGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNlbGYgd2FrZXVwLCBpdCBoYXBw
ZW5lcyB0byBiZSBhYmxlIHRvDQo+IGZpeCBhbm90aGVyIGlzc3VlIHRoYXQgZnJhbWVzIG91dC1v
Zi1vcmRlciBpbiBmaXJzdCBJUlEgaGFuZGxlciBydW4gYWZ0ZXIgd2FrZXVwLg0KPiANCj4gSW4g
d2FrZXVwIGNhc2UsIGFmdGVyIHN5c3RlbSByZXN1bWUsIGZyYW1lcyByZWNlaXZlZCBvdXQtb2Yt
b3JkZXIsdGhlDQo+IHByb2JsZW0gaXMgd2FrZXVwIGxhdGVuY3kgZnJvbSBmcmFtZSByZWNlcHRp
b24gdG8gSVJRIGhhbmRsZXIgaXMgbXVjaCBiaWdnZXINCj4gdGhhbiB0aGUgY291bnRlciBvdmVy
Zmxvdy4gVGhpcyBtZWFucyBpdCdzIGltcG9zc2libGUgdG8gc29ydCB0aGUgQ0FOIGZyYW1lcw0K
PiBieSB0aW1lc3RhbXAuIFRoZSByZWFzb24gaXMgdGhhdCBjb250cm9sbGVyIGV4aXRzIHN0b3Ag
bW9kZSBkdXJpbmcgbm9pcnENCj4gcmVzdW1lLCB0aGVuIGl0IGNhbiByZWNlaXZlIHRoZSBmcmFt
ZSBpbW1lZGlhdGVseS4gSWYgbm9pcnEgcmV1c21lIHN0YWdlDQo+IGNvbnN1bWVzIG11Y2ggdGlt
ZSwgaXQgd2lsbCBleHRlbmQgaW50ZXJydXB0IHJlc3BvbnNlIHRpbWUuDQo+IA0KPiBGaXhlczog
ZGUzNTc4YzE5OGM2ICgiY2FuOiBmbGV4Y2FuOiBhZGQgc2VsZiB3YWtldXAgc3VwcG9ydCIpDQo+
IFNpZ25lZC1vZmYtYnk6IFNlYW4gTnlla2phZXIgPHNlYW5AZ2Vhbml4LmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gLS0tDQo+
ICBkcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIHwgMTkgKysrKysrKysrKystLS0tLS0tLQ0KPiAg
MSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyBiL2RyaXZlcnMvbmV0L2Nhbi9m
bGV4Y2FuLmMgaW5kZXgNCj4gYTkyOWNkZGE5YWIyLi40M2ZkMTg3NzY4ZjEgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvY2FuL2Zs
ZXhjYW4uYw0KPiBAQCAtMTM0LDggKzEzNCw3IEBADQo+ICAJKEZMRVhDQU5fRVNSX0VSUl9CVVMg
fCBGTEVYQ0FOX0VTUl9FUlJfU1RBVEUpICAjZGVmaW5lDQo+IEZMRVhDQU5fRVNSX0FMTF9JTlQg
XA0KPiAgCShGTEVYQ0FOX0VTUl9UV1JOX0lOVCB8IEZMRVhDQU5fRVNSX1JXUk5fSU5UIHwgXA0K
PiAtCSBGTEVYQ0FOX0VTUl9CT0ZGX0lOVCB8IEZMRVhDQU5fRVNSX0VSUl9JTlQgfCBcDQo+IC0J
IEZMRVhDQU5fRVNSX1dBS19JTlQpDQo+ICsJIEZMRVhDQU5fRVNSX0JPRkZfSU5UIHwgRkxFWENB
Tl9FU1JfRVJSX0lOVCkNCj4gDQo+ICAvKiBGTEVYQ0FOIGludGVycnVwdCBmbGFnIHJlZ2lzdGVy
IChJRkxBRykgYml0cyAqLw0KPiAgLyogRXJyYXRhIEVSUjAwNTgyOSBzdGVwNzogUmVzZXJ2ZSBm
aXJzdCB2YWxpZCBNQiAqLyBAQCAtOTYwLDYgKzk1OSwxMg0KPiBAQCBzdGF0aWMgaXJxcmV0dXJu
X3QgZmxleGNhbl9pcnEoaW50IGlycSwgdm9pZCAqZGV2X2lkKQ0KPiANCj4gIAlyZWdfZXNyID0g
cHJpdi0+cmVhZCgmcmVncy0+ZXNyKTsNCj4gDQo+ICsJLyogQUNLIHdha2V1cCBpbnRlcnJ1cHQg
Ki8NCj4gKwlpZiAocmVnX2VzciAmIEZMRVhDQU5fRVNSX1dBS19JTlQpIHsNCj4gKwkJaGFuZGxl
ZCA9IElSUV9IQU5ETEVEOw0KPiArCQlwcml2LT53cml0ZShyZWdfZXNyICYgRkxFWENBTl9FU1Jf
V0FLX0lOVCwgJnJlZ3MtPmVzcik7DQo+ICsJfQ0KPiArDQo+ICAJLyogQUNLIGFsbCBidXMgZXJy
b3IgYW5kIHN0YXRlIGNoYW5nZSBJUlEgc291cmNlcyAqLw0KPiAgCWlmIChyZWdfZXNyICYgRkxF
WENBTl9FU1JfQUxMX0lOVCkgew0KPiAgCQloYW5kbGVkID0gSVJRX0hBTkRMRUQ7DQo+IEBAIC0x
NzIyLDYgKzE3MjcsOSBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkIGZsZXhjYW5fcmVzdW1l
KHN0cnVjdA0KPiBkZXZpY2UgKmRldmljZSkNCj4gIAkJbmV0aWZfc3RhcnRfcXVldWUoZGV2KTsN
Cj4gIAkJaWYgKGRldmljZV9tYXlfd2FrZXVwKGRldmljZSkpIHsNCj4gIAkJCWRpc2FibGVfaXJx
X3dha2UoZGV2LT5pcnEpOw0KPiArCQkJZXJyID0gZmxleGNhbl9leGl0X3N0b3BfbW9kZShwcml2
KTsNCj4gKwkJCWlmIChlcnIpDQo+ICsJCQkJcmV0dXJuIGVycjsNCj4gIAkJfSBlbHNlIHsNCj4g
IAkJCWVyciA9IHBtX3J1bnRpbWVfZm9yY2VfcmVzdW1lKGRldmljZSk7DQo+ICAJCQlpZiAoZXJy
KQ0KPiBAQCAtMTc2NywxNCArMTc3NSw5IEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQNCj4g
ZmxleGNhbl9ub2lycV9yZXN1bWUoc3RydWN0IGRldmljZSAqZGV2aWNlKSAgew0KPiAgCXN0cnVj
dCBuZXRfZGV2aWNlICpkZXYgPSBkZXZfZ2V0X2RydmRhdGEoZGV2aWNlKTsNCj4gIAlzdHJ1Y3Qg
ZmxleGNhbl9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gLQlpbnQgZXJyOw0KPiAN
Cj4gLQlpZiAobmV0aWZfcnVubmluZyhkZXYpICYmIGRldmljZV9tYXlfd2FrZXVwKGRldmljZSkp
IHsNCj4gKwlpZiAobmV0aWZfcnVubmluZyhkZXYpICYmIGRldmljZV9tYXlfd2FrZXVwKGRldmlj
ZSkpDQo+ICAJCWZsZXhjYW5fZW5hYmxlX3dha2V1cF9pcnEocHJpdiwgZmFsc2UpOw0KPiAtCQll
cnIgPSBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlKHByaXYpOw0KPiAtCQlpZiAoZXJyKQ0KPiAtCQkJ
cmV0dXJuIGVycjsNCj4gLQl9DQo+IA0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAtLQ0KPiAyLjE3
LjENCg0K
