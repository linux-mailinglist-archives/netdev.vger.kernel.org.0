Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67531128B4
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 10:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfLDJ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 04:58:16 -0500
Received: from mail-eopbgr10066.outbound.protection.outlook.com ([40.107.1.66]:15071
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726679AbfLDJ6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 04:58:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEtfuL20Qfr9UIqr1Tgux81fLHxx/Euzz7F4L1bY7E8p0pbWmo5QY5vVmUAEdWCkvCUGEg1ublvzqycKFmABVt/1QiQ1Cu9h/WGLCJBMHDRDlQ/XyULrvI8dj3UjNChcctoUcg/9IBZUFIfETWkOPsMrOejU//4WfPqvkV9srLMVbCksqLN1fZIAbehmv8evLyP0/KMXG5gzE2RICW73mkNTCc1Ur2a8eC5/V+vf438FH4T0rCSFJ2vZFVhO+I6/ypp3XwtZgBAncIXh8357AyNleTede6cbl+IsXxXmPHvwHwXcJ31keomX+v704lNfT9FBHL+XhTr5bMU4d82xsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5DxB9nT6IfYPtmwqauk/bZKhSHe1k1MU6Rqxrh80UQ=;
 b=Zu6aMMPkAwfqHhxmsyBeLZV3+yh+abJffpjr5kTFV2ciA+PXllittyCmKdoMwA2vyk258IzSB9tThe01KOkOxnUGViGbilwPQ7IB22qpe7F4DatszQCT6IYh5vdjkiOHqP1yJbs4S4ODsXTWCq9MwQUI8Ir57nH+zdDyQ1DQypapKfclQqHX9cyKdVhVSiuLCOgh90h2sqTvR9H5TpX1UeeTrnI6USsWnuC+D4k+/ECeoYcME/I/hv4fFUTwKDLU34RQBobyFF5T5bKEP29+RWwSL6Mu5yyZ77m9KteOs1m3Kt4LAWUnJPHxqFMfm0nHLNhYmZkYSP8U9efJn5n53g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5DxB9nT6IfYPtmwqauk/bZKhSHe1k1MU6Rqxrh80UQ=;
 b=a+efm1gobTCVKexuw/oZTF0Eg/kqn9xx5E6AZXH7cwfgdxroFnoWNXHXS348Qn1GBdOiPNPtL0Zr61rBbvsg8AjCAYb3f8x2iidLZNfMq9t6JeJQGwpVguIlWbdL8iMAu5+eX9KKaq/RnTzZlLTSPj+rBAlLjtB8QlmtE//yMXM=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5036.eurprd04.prod.outlook.com (20.176.234.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Wed, 4 Dec 2019 09:58:10 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 09:58:10 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Topic: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Index: AQHVpOd0/zAyRBOEIkuRK6cuc/m3PqeowUOAgACCKzCAAHEBAIAAA66A
Date:   Wed, 4 Dec 2019 09:58:09 +0000
Message-ID: <DB7PR04MB46188AAE07C0B032301FE474E65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-3-qiangqing.zhang@nxp.com>
 <ad7e7b15-26f3-daa1-02d2-782ff548756d@pengutronix.de>
 <DB7PR04MB46180C5F1EAC7C4A69A45E0CE65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <d68b2b79-34ec-eb4c-cf4b-047b5157d5e3@pengutronix.de>
In-Reply-To: <d68b2b79-34ec-eb4c-cf4b-047b5157d5e3@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d5c13411-5583-4db1-aa21-08d778a07824
x-ms-traffictypediagnostic: DB7PR04MB5036:|DB7PR04MB5036:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB50363E4D4268DDF9BD4E9576E65D0@DB7PR04MB5036.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(199004)(189003)(13464003)(76176011)(86362001)(66476007)(66556008)(99286004)(66446008)(7696005)(9686003)(305945005)(2201001)(55016002)(5660300002)(6306002)(14444005)(256004)(229853002)(25786009)(52536014)(7736002)(76116006)(64756008)(66946007)(6436002)(33656002)(4326008)(966005)(14454004)(478600001)(102836004)(2501003)(316002)(446003)(110136005)(6116002)(8936002)(11346002)(6506007)(3846002)(6246003)(81156014)(71190400001)(2906002)(74316002)(71200400001)(8676002)(81166006)(26005)(53546011)(186003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5036;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8XP1FgSDiCHM/MyrtUv89Nee+/lW6DtDZFtJu0Gr6Vt0L9IX+Y3k6D+M6sikHCstlssFba+7/GxCTFTz7kYbj4ZZ4+MUgMg2dySA6rUvMHxx3h8PJwavdNbKSXRJPJgVIQcB6KE1EHN5llAywcw9RwVHWmR8xlHkaTjP4zCFq4Nc/eMFjaJTQw5CP3pDbnqcOBQI4lW5MUmEthCbJr5/vHuVIosYyiKRg83m32zyNDzwKUBwmxzuX3lwkRESGAiCvn+nBkcS/LEZiGSGYSTMHUCrSSFnH9aMyZxinrRreILu69d9pipTBHRJy1BBukWjASiBkeY2f2AcxTEOVCDCWzEKMe+VO8xmSVsSf3i9jjsMsSopgslCdyuXYoTi2EG3UdiRDC9gPiMhkuRUuo7hUqHbJn3ZZuiCbP5L0x9yP7tugB8bke8ict3YklLyNs2u5IRNfYKBB/T+hpvIfKN6oj/0bQOoH5GXJm4FPxTDDSvHIHnbhftbVzHsSSY55uL/+bfG4p+VxfKDLiDsNePDUXlhn1DQk3ol1Q35YcUKSy8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c13411-5583-4db1-aa21-08d778a07824
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 09:58:10.0064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zJNE0yKb6pLReIU6bfq8JuaLioBdG9coRQSL//4YelL675/SD9kkd7z/q3Q0OFjpQjbC4hbFM+16MVB9k917ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5036
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQxMuaciDTml6UgMTY6NDUNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBzZWFuQGdlYW5peC5j
b207DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggVjIgMi80XSBjYW46IGZsZXhjYW46IHRyeSB0byBleGl0IHN0b3AgbW9kZSBkdXJpbmcg
cHJvYmUNCj4gc3RhZ2UNCj4gDQo+IE9uIDEyLzQvMTkgMzoyMiBBTSwgSm9ha2ltIFpoYW5nIHdy
b3RlOg0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IE1h
cmMgS2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+ID4+IFNlbnQ6IDIwMTnlubQx
MuaciDTml6UgMjoxNQ0KPiA+PiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhw
LmNvbT47IHNlYW5AZ2Vhbml4LmNvbTsNCj4gPj4gbGludXgtY2FuQHZnZXIua2VybmVsLm9yZw0K
PiA+PiBDYzogZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcNCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMiAyLzRdIGNhbjogZmxleGNhbjog
dHJ5IHRvIGV4aXQgc3RvcCBtb2RlDQo+ID4+IGR1cmluZyBwcm9iZSBzdGFnZQ0KPiA+Pg0KPiA+
PiBPbiAxMS8yNy8xOSA2OjU2IEFNLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4+PiBDQU4gY29u
dHJvbGxlciBjb3VsZCBiZSBzdHVja2VkIGluIHN0b3AgbW9kZSBvbmNlIGl0IGVudGVycyBzdG9w
DQo+ID4+PiBtb2RlDQo+ID4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgXl5eXl5eXiBzdHVj
aw0KPiA+Pj4gd2hlbiBzdXNwZW5kLCBhbmQgdGhlbiBpdCBmYWlscyB0byBleGl0IHN0b3AgbW9k
ZSB3aGVuIHJlc3VtZS4NCj4gPj4NCj4gPj4gSG93IGNhbiB0aGlzIGhhcHBlbj8NCj4gPg0KPiA+
IEkgYW0gYWxzbyBjb25mdXNlZCBob3cgY2FuIHRoaXMgaGFwcGVuLCBhcyBJIGFza2VkIFNlYW4s
IG9ubHkgQ0FODQo+ID4gZW50ZXIgc3RvcCBtb2RlIHdoZW4gc3VzcGVuZCwgdGhlbiBzeXN0ZW0g
aGFuZywNCj4gSG93IGRvIHlvdSByZWNvdmVyIHRoZSBzeXN0ZW0gd2hlbiBzdXNwZW5kZWQ/DQpS
VEMgd2FrZXVwIG9yIFRUWSB3YWtldXAuDQoNCj4gPiBpdCBjb3VsZCBsZXQgQ0FODQo+ID4gc3R1
Y2sgaW4gc3RvcCBtb2RlLiBIb3dldmVyLCBTZWFuIHNhaWQgdGhpcyBpbmRlZWQgaGFwcGVuIGF0
IGhpcyBzaWRlLA0KPiA+IEBzZWFuQGdlYW5peC5jb20sIGNvdWxkIHlvdSBleHBsYWluIGhvdyB0
aGlzIGhhcHBlbiBpbiBkZXRhaWxzPw0KPiBUaGF0IHdvdWxkIGJlIGdvb2QuDQo+DQo+ID4+PiBP
bmx5IGNvZGUgcmVzZXQgY2FuIGdldCBDQU4gb3V0IG9mIHN0b3AgbW9kZSwNCj4gPj4NCj4gPj4g
V2hhdCBpcyAiY29kZSByZXNldCI/DQo+ID4NCj4gPiBBcyBJIGtub3csICJjb2RlIHJlc2V0IiBp
cyB0byBwcmVzcyB0aGUgUE9XRVIgS0VZIGZyb20gdGhlIGJvYXJkLiBBdA0KPiA+IG15IHNpZGUs
IHJlYm9vdCBjb21tYW5kIGZyb20gT1MgYWxzbyBjYW4gZ2V0IENBTiBvdXQgb2Ygc3RvcCBtb2Rl
Lg0KPiBEbyB5b3UgbWVhbiAiY29sZCByZXNldCIsIGFsc28ga25vd24gYXMgUG93ZXItT24tUmVz
ZXQsIFBPUiBvciBwb3dlcg0KPiBjeWNsZT8NClNob3VsZCBiZSBQb3dlci1Pbi1SZXNldC4NCg0K
PiBXaGF0IGRvZXMgcHJlc3NpbmcgdGhlIFBPV0VSIEtFWSBkbz8gQSBwb3dlciBjeWNsZSBvZiB0
aGUgc3lzdGVtIG9yDQo+IHRvZ2dsaW5nIHRoZSByZXNldCBsaW5lIG9mIHRoZSBpbXg/DQpJIHRo
aW5rIGl0IHRvZ2dsZXMgdGhlIHJlc2V0IGxpbmUgb2YgaW14LiBJIGFtIHNvIHNvcnJ5IHRoYXQg
SSBhbSBub3QgZmFtaWxpYXIgd2l0aCBzeXN0ZW0gcmVzZXQgOiguDQogDQo+IFdlIG5lZWQgdG8g
ZGVzY3JpYmUgaW4gZGV0YWlsLCBhcyBub3QgZXZlcnlvbmUgaGFzIHRoZSBzYW1lIGJvYXJkIGFz
IHlvdSwgYW5kDQo+IHRoZXNlIGJvYXJkcyBtaWdodCBub3QgZXZlbiBoYXZlIGEgcG93ZXIga2V5
IDopDQpZZXMuDQoNCj4gPiBCZWxvdyBpcyBleHBlcmltZW50IEkgZGlkOg0KPiA+IAlGaXJzdGx5
LCBkbyBhIGhhY2tpbmcgdG8gbGV0IENBTiBzdHVjayBpbnRvIHN0b3AgbW9kZSwgdGhlbjoNCj4g
DQo+IFlvdSBtZWFuIHlvdSBwdXQgdGhlIENBTiBpbnRvIHN0b3AgbW9kZSB3aXRob3V0IGtlZXBp
bmcgdHJhY2sgaW4gdGhlIENBTg0KPiBkcml2ZXIgdGhhdCB0aGUgQ0FOLUlQIGlzIGluIHN0b3Ag
bW9kZSwgZS5nLiBieSBoYWNraW5nIHRoZSBkcml2ZXIuDQpZZXMsIHlvdSBjYW4gYWRkIGZsZXhj
YW5fZW50ZXJfc3RvcF9tb2RlKCkgYXQgdGhlIGxhc3Qgb2YgZHJpdmVyIHByb2JlLiBBZnRlciBw
cm9iZSwgQ0FOIGhhcyBiZWVuIHN0dWNrIGluIHN0b3AgbW9kZS4NCk9yIHlvdSBjYW4gZW5hYmxl
IENBTiB3YWtldXAsIHRoZW4gY29tbWVudCBvdXQgZmxleGNhbl9leGl0X3N0b3BfbW9kZSgpIGlu
IGZsZXhjYW5fcmVzdW1lKCksIGRvIHN1c3BlbmQgdGhlbiB3YWtldXAgc3lzdGVtLCBDQU4gaGFz
IGJlZW4gc3R1Y2sgaW4gc3RvcCBtb2RlLg0KDQo+IFRoZW4geW91IHRyeSBzZXZlcmFsIG1ldGhv
ZHMgdG8gcmVjb3ZlcjoNCj4gDQo+ID4gCSgxKSBwcmVzcyBwb3dlciBvbi9vZmYga2V5LCBnZXQg
Q0FOIG91dCBvZiBzdG9wIG1vZGU7DQo+ID4gCSgyKSByZWJvb3QgY29tbWFuZCBmcm9tIGNvbnNv
bGUsIGdldCBDQU4gb3V0IG9mIHN0b3AgbW9kZTsNCj4gPiAJKDMpIHVuYmluZC9iaW5kIGRyaXZl
ciwgY2Fubm90IGdldCBDQU4gb3V0IG9mIHN0b3AgbW9kZTsNCj4gPiAJKDQpIHJlbW9kL2luc21v
ZCBtb2R1bGUsIGNhbm5vdCBnZXQgQ0FOIG91dCBvZiBzdG9wIG1vZGU7DQo+IA0KPiAoMikgcmVz
ZXRzIHRoZSBjb21wbGV0ZSBpbXgsIGluY2x1ZGluZyB0aGUgQ0FOLUlQIGNvcmUsICgxKSBwcm9i
YWJseSwgdG9vLg0KWWVzLCBzaW5jZSBzdG9wIG1vZGUgZW50ZXIvZXhpdCByZXF1ZXN0IGF0IGEg
Y2hpcCBsZXZlbCwgbmVlZCByZXNldCBjb21wbGV0ZWx5LCBzdWNoIGFzIGEgImNvZGUgcmVzZXQi
LCB3b3VsZCBnZXQgQ0FOIG91dCBzdG9wIG1vZGUuDQoiU29mdCByZXNldCIgY2Fubm90IGdldCBD
QU4gb3V0IG9mIHN0b3AgbW9kZS4NCg0KPiAoMykgYW5kICg0KSBmYWlsIHRvIHJlY292ZXIgdGhl
IENBTiBjb3JlLCBhcyB0aGUgSVAgY29yZSBpcyBzdGlsbCBwb3dlcmVkIG9mZiBieQ0KPiBzb21l
IHVwc3RyZWFtIGNvbXBvbmVudC4gU28gdGhlIHF1ZXN0aW9uIHdoeSB0aGlzIGhhcHBlbnMgaW4g
dGhlIGZpcnN0IHBsYWNlDQo+IGlzIElNSE8gYXMgaW1wb3J0YW50IGFzIHRyeWluZyB0byB3YWtl
IHVwIHRoZSBjb3JlLiBJIHRoaW5rIGlmIHdlIGRpc2NvdmVyIHRoaXMNCj4gc2l0dWF0aW9uIChD
QU4gQ29yZSBpcyBpbiBzdG9wLW1vZGUgaW4gcHJvYmUpIHdlIHNob3VsZCBwcmludCBhIHdhcm5p
bmcNCj4gbWVzc2FnZSwgYnV0IHRyeSB0byByZWNvdmVyLg0KV2UgcmVhbGx5IG5lZWQgZmlndXJl
IG91dCB3aHkgQ0FOIGNvdWxkIGJlIHN0dWNrIGluIHN0b3AgbW9kZS4gQXMgSSBrbm93LCBlbnRl
ciBzdG9wIG1vZGUgaW4gZmxleGNhbl9zdXNwZW5kKCksIGFuZCB0aGVuIGV4aXQgc3RvcCBtb2Rl
IGluIGZsZXhjYW5fcmVzdW1lKCksIGl0IGNvdWxkIGJlIGltcG9zc2libGUuDQpIb3BlIFNlYW4g
Y2FuIGV4cGxhaW4gaXQgaW4gZGV0YWlscywgdGhlbiB3ZSBjYW4gZGlzY3VzcyBob3cgdG8gZml4
IGl0IG1vcmUgcmVhc29uYWJsZS4NCg0KVGhhbmtzIE1hcmMuDQoNCkJlc3QgUmVnYXJkcywNCkpv
YWtpbSBaaGFuZw0KPiA+Pj4gc28gYWRkIHN0b3AgbW9kZSByZW1vdmUgcmVxdWVzdCBkdXJpbmcg
cHJvYmUgc3RhZ2UgZm9yIG90aGVyDQo+ID4+PiBtZXRob2RzKHNvZnQgcmVzZXQgZnJvbSBjaGlw
IGxldmVsLCB1bmJpbmQvYmluZCBkcml2ZXIsIGV0YykgdG8gbGV0DQo+ID4+ICAgICAgICAgXl5e
IHBsZWFzZSBhZGQgYSBzcGFjZQ0KPiA+Pj4gQ0FOIGFjdGl2ZSBhZ2Fpbi4NCj4gPj4NCj4gPj4g
Q2FuIHlvdSByZXBocmFzZSB0aGUgc2VudGVuY2UgYWZ0ZXIgInNvIGFkZCBzdG9wIG1vZGUgcmVt
b3ZlIHJlcXVlc3QNCj4gPj4gZHVyaW5nIHByb2JlIHN0YWdlIi4gSSdtIG5vdCBjb21wbGV0ZWx5
IHN1cmUgd2hhdCB5b3Ugd2FudCB0byB0ZWxsLg0KPiA+DQo+ID4gU3VyZS4NCj4gDQo+IHRueCwN
Cj4gTWFyYw0KPiANCj4gLS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAgICAgfCBN
YXJjIEtsZWluZS1CdWRkZSAgICAgICAgICAgfA0KPiBFbWJlZGRlZCBMaW51eCAgICAgICAgICAg
ICAgICAgICB8IGh0dHBzOi8vd3d3LnBlbmd1dHJvbml4LmRlICB8DQo+IFZlcnRyZXR1bmcgV2Vz
dC9Eb3J0bXVuZCAgICAgICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgyNi05MjQgICAgIHwNCj4gQW10
c2dlcmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1
NTUgfA0KDQo=
