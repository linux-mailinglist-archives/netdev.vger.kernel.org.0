Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5976FB4B
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 10:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfGVI2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 04:28:11 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:22288
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbfGVI2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 04:28:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJJtCOqRJ0QbJ6C36JOdTTvuO8f30EPUM9uHP9up50Db9zITOjEmcrjMXHG930w3dK4616gzpdM4/x+znhyoqZngOhIrcO7fBD5V6PM4nGK5iM5iNdxkTHBtEJyxgKqIYpvITATD/u2Z2S7LTrTRib2qWzzQ1AOMD/4/8mdQscoNNXuZo6VQgqDp1Ub4pDI4hfTfOdyyGKNKnfnbP9LY9Yfwb9yr3+aTnimls5P5hUtq3W4qQ30LDxhEu1nswU4BCTi54myyHc8kpi58ZDuDS5NEDUW5cjLQf5ihh/D/4mOzRfxqck+Vf+nh4oModX2HlYO27s8YAa+BceCZsesIWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m85sQBkX8k/yJOvzoSSnqFk6mp1zagAyuvth+BbLkyI=;
 b=hX2dh9za6gM932NV+UeouKQ5vfIWBQr7M2WdFBC/CAc7+LZQGtBgTEjB/OKzD5fYRpNyHfY86XaQcwm3Qvk2OXRBOwtlWPKlG+im9nyhnviqUQdQjVvNDx9E0uyzTtYgVuubtewskPem3Xgdm1J42c0QsIs3FH0uTyIURB8avIbJLOGq+X6GUnEFt6sSpqGBtIMWzbsKYOCfZ8lWrnhGRoqDVBfl0x15/ZUg84WRp0nT5nuxKWmcu1iXAoHZrQtMqKZVtbUgKR2s2t/vjTjj7gb77fPMfWHu1JljfWfy+Y8dBMx2tzUjQLd7qG4UZy7eWali80SHgT9R+QRDySlUJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m85sQBkX8k/yJOvzoSSnqFk6mp1zagAyuvth+BbLkyI=;
 b=d49VeqyHQ0gNikSivkgrEKlsTHfNCBk2PDDTiEfSi7qAFAfpgduBnpBLH16MioYsdPw19Dx9BNDbf/fv0LLUF0G/g3mF1CB59ZQ1GH6KbuD6BOyXUnDwSpowwnnpd3eqQBDq7C7a+twhkKrIxqxkPzipfs9rnvd9O/Sn2prK5jg=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4299.eurprd04.prod.outlook.com (52.135.129.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Mon, 22 Jul 2019 08:28:03 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 08:28:03 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V4] can: flexcan: fix stop mode acknowledgment
Thread-Topic: [PATCH V4] can: flexcan: fix stop mode acknowledgment
Thread-Index: AQHVMHfaCqKrzVTOS0G/H4Ie2l5GYKbWbbRg
Date:   Mon, 22 Jul 2019 08:28:03 +0000
Message-ID: <DB7PR04MB4618CDE67D0A781CD5844581E6C40@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190702014316.26444-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190702014316.26444-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba07103a-8694-4f0e-af5c-08d70e7e83cd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4299;
x-ms-traffictypediagnostic: DB7PR04MB4299:
x-microsoft-antispam-prvs: <DB7PR04MB429974E1C6FF08D13CF92F82E6C40@DB7PR04MB4299.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(189003)(199004)(54534003)(13464003)(2906002)(7696005)(71190400001)(71200400001)(476003)(55016002)(33656002)(26005)(99286004)(53936002)(68736007)(569044001)(102836004)(74316002)(446003)(7736002)(11346002)(76176011)(25786009)(53546011)(6506007)(229853002)(305945005)(9686003)(54906003)(186003)(486006)(81166006)(81156014)(3846002)(14444005)(256004)(6116002)(478600001)(76116006)(66946007)(64756008)(66446008)(66476007)(66556008)(110136005)(8936002)(6436002)(316002)(5660300002)(52536014)(66066001)(8676002)(86362001)(2501003)(4326008)(6246003)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4299;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4ZwzAstBrcMdBJ5KTkcYkPYeRqinUD3QDx09g+D9W5PLjMzjiPwyScrXI6I6Yx45o+/V6A6sJ/+2fKqfHBekx5RyTy1tgog98J4tHRldPPA+bQHDirld+CxXJP+OfegeciXHoIcbmoOg+liSVBpkMqBBT/28OrHGGIulINFdYPwrGvZRTBKjClGJvRdt/lEgtnGAR+MTzLOFDqBs5TlVl6AxHUChZ8sn+JniZ4bh0eY6CbBna8IzIUYYYtfLT6gydadrhaos1onIir/S3G+v4styAZYx1t8TwHybsMXXPLLcSEw0HDY+DMJUKzL2xmZr3t5OXA2SSjilpMjCyJr9GpJkabFTs0o983EaivIXYKAFqlLAW69n0LIgDqTMctoUJ2JG3LkihCl5zPa4Uld3XdKmaMLD33XF+v0k/gX53hI=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba07103a-8694-4f0e-af5c-08d70e7e83cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 08:28:03.5038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4299
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpLaW5kbHkgUGluZy4uLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FraW0gWmhhbmcNCj4gU2VudDogMjAx
OcTqN9TCMsjVIDk6NDYNCj4gVG86IG1rbEBwZW5ndXRyb25peC5kZTsgbGludXgtY2FuQHZnZXIu
a2VybmVsLm9yZw0KPiBDYzogd2dAZ3JhbmRlZ2dlci5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+OyBKb2FraW0gWmhhbmcgPHFp
YW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggVjRdIGNhbjogZmxleGNh
bjogZml4IHN0b3AgbW9kZSBhY2tub3dsZWRnbWVudA0KPiANCj4gVG8gZW50ZXIgc3RvcCBtb2Rl
LCB0aGUgQ1BVIHNob3VsZCBtYW51YWxseSBhc3NlcnQgYSBnbG9iYWwgU3RvcCBNb2RlDQo+IHJl
cXVlc3QgYW5kIGNoZWNrIHRoZSBhY2tub3dsZWRnbWVudCBhc3NlcnRlZCBieSBGbGV4Q0FOLiBU
aGUgQ1BVIG11c3QNCj4gb25seSBjb25zaWRlciB0aGUgRmxleENBTiBpbiBzdG9wIG1vZGUgd2hl
biBib3RoIHJlcXVlc3QgYW5kDQo+IGFja25vd2xlZGdtZW50IGNvbmRpdGlvbnMgYXJlIHNhdGlz
ZmllZC4NCj4gDQo+IEZpeGVzOiBkZTM1NzhjMTk4YzYgKCJjYW46IGZsZXhjYW46IGFkZCBzZWxm
IHdha2V1cCBzdXBwb3J0IikNCj4gUmVwb3J0ZWQtYnk6IE1hcmMgS2xlaW5lLUJ1ZGRlIDxta2xA
cGVuZ3V0cm9uaXguZGU+DQo+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5n
LnpoYW5nQG54cC5jb20+DQo+IA0KPiBDaGFuZ2VMb2c6DQo+IFYxLT5WMjoNCj4gCSogcmVnbWFw
X3JlYWQoKS0tPnJlZ21hcF9yZWFkX3BvbGxfdGltZW91dCgpDQo+IFYyLT5WMzoNCj4gCSogY2hh
bmdlIHRoZSB3YXkgb2YgZXJyb3IgcmV0dXJuLCBpdCB3aWxsIG1ha2UgZWFzeSBmb3IgZnVuY3Rp
b24NCj4gCWV4dGVuc2lvbi4NCj4gVjMtPlY0Og0KPiAJKiByZWJhc2UgdG8gbGludXgtbmV4dC9t
YXN0ZXIsIGFzIHRoaXMgaXMgYSBmaXguDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhj
YW4uYyB8IDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCAyNyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIGlu
ZGV4DQo+IDFjNjZmYjJhZDc2Yi4uYmYxYmQ2ZjVkYmIxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9jYW4vZmxleGNhbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4g
QEAgLTQwMCw5ICs0MDAsMTAgQEAgc3RhdGljIHZvaWQgZmxleGNhbl9lbmFibGVfd2FrZXVwX2ly
cShzdHJ1Y3QNCj4gZmxleGNhbl9wcml2ICpwcml2LCBib29sIGVuYWJsZSkNCj4gIAlwcml2LT53
cml0ZShyZWdfbWNyLCAmcmVncy0+bWNyKTsNCj4gIH0NCj4gDQo+IC1zdGF0aWMgaW5saW5lIHZv
aWQgZmxleGNhbl9lbnRlcl9zdG9wX21vZGUoc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdikNCj4g
K3N0YXRpYyBpbmxpbmUgaW50IGZsZXhjYW5fZW50ZXJfc3RvcF9tb2RlKHN0cnVjdCBmbGV4Y2Fu
X3ByaXYgKnByaXYpDQo+ICB7DQo+ICAJc3RydWN0IGZsZXhjYW5fcmVncyBfX2lvbWVtICpyZWdz
ID0gcHJpdi0+cmVnczsNCj4gKwl1bnNpZ25lZCBpbnQgYWNrdmFsOw0KPiAgCXUzMiByZWdfbWNy
Ow0KPiANCj4gIAlyZWdfbWNyID0gcHJpdi0+cmVhZCgmcmVncy0+bWNyKTsNCj4gQEAgLTQxMiwy
MCArNDEzLDM3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZShz
dHJ1Y3QNCj4gZmxleGNhbl9wcml2ICpwcml2KQ0KPiAgCS8qIGVuYWJsZSBzdG9wIHJlcXVlc3Qg
Ki8NCj4gIAlyZWdtYXBfdXBkYXRlX2JpdHMocHJpdi0+c3RtLmdwciwgcHJpdi0+c3RtLnJlcV9n
cHIsDQo+ICAJCQkgICAxIDw8IHByaXYtPnN0bS5yZXFfYml0LCAxIDw8IHByaXYtPnN0bS5yZXFf
Yml0KTsNCj4gKw0KPiArCS8qIGdldCBzdG9wIGFja25vd2xlZGdtZW50ICovDQo+ICsJaWYgKHJl
Z21hcF9yZWFkX3BvbGxfdGltZW91dChwcml2LT5zdG0uZ3ByLCBwcml2LT5zdG0uYWNrX2dwciwN
Cj4gKwkJCQkgICAgIGFja3ZhbCwgYWNrdmFsICYgKDEgPDwgcHJpdi0+c3RtLmFja19iaXQpLA0K
PiArCQkJCSAgICAgMCwgRkxFWENBTl9USU1FT1VUX1VTKSkNCj4gKwkJcmV0dXJuIC1FVElNRURP
VVQ7DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gIH0NCj4gDQo+IC1zdGF0aWMgaW5saW5lIHZvaWQg
ZmxleGNhbl9leGl0X3N0b3BfbW9kZShzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2KQ0KPiArc3Rh
dGljIGlubGluZSBpbnQgZmxleGNhbl9leGl0X3N0b3BfbW9kZShzdHJ1Y3QgZmxleGNhbl9wcml2
ICpwcml2KQ0KPiAgew0KPiAgCXN0cnVjdCBmbGV4Y2FuX3JlZ3MgX19pb21lbSAqcmVncyA9IHBy
aXYtPnJlZ3M7DQo+ICsJdW5zaWduZWQgaW50IGFja3ZhbDsNCj4gIAl1MzIgcmVnX21jcjsNCj4g
DQo+ICAJLyogcmVtb3ZlIHN0b3AgcmVxdWVzdCAqLw0KPiAgCXJlZ21hcF91cGRhdGVfYml0cyhw
cml2LT5zdG0uZ3ByLCBwcml2LT5zdG0ucmVxX2dwciwNCj4gIAkJCSAgIDEgPDwgcHJpdi0+c3Rt
LnJlcV9iaXQsIDApOw0KPiANCj4gKwkvKiBnZXQgc3RvcCBhY2tub3dsZWRnbWVudCAqLw0KPiAr
CWlmIChyZWdtYXBfcmVhZF9wb2xsX3RpbWVvdXQocHJpdi0+c3RtLmdwciwgcHJpdi0+c3RtLmFj
a19ncHIsDQo+ICsJCQkJICAgICBhY2t2YWwsICEoYWNrdmFsICYgKDEgPDwgcHJpdi0+c3RtLmFj
a19iaXQpKSwNCj4gKwkJCQkgICAgIDAsIEZMRVhDQU5fVElNRU9VVF9VUykpDQo+ICsJCXJldHVy
biAtRVRJTUVET1VUOw0KPiArDQo+ICAJcmVnX21jciA9IHByaXYtPnJlYWQoJnJlZ3MtPm1jcik7
DQo+ICAJcmVnX21jciAmPSB+RkxFWENBTl9NQ1JfU0xGX1dBSzsNCj4gIAlwcml2LT53cml0ZShy
ZWdfbWNyLCAmcmVncy0+bWNyKTsNCj4gKw0KPiArCXJldHVybiAwOw0KPiAgfQ0KPiANCj4gIHN0
YXRpYyBpbmxpbmUgdm9pZCBmbGV4Y2FuX2Vycm9yX2lycV9lbmFibGUoY29uc3Qgc3RydWN0IGZs
ZXhjYW5fcHJpdiAqcHJpdikNCj4gQEAgLTE2MTUsNyArMTYzMyw5IEBAIHN0YXRpYyBpbnQgX19t
YXliZV91bnVzZWQgZmxleGNhbl9zdXNwZW5kKHN0cnVjdA0KPiBkZXZpY2UgKmRldmljZSkNCj4g
IAkJICovDQo+ICAJCWlmIChkZXZpY2VfbWF5X3dha2V1cChkZXZpY2UpKSB7DQo+ICAJCQllbmFi
bGVfaXJxX3dha2UoZGV2LT5pcnEpOw0KPiAtCQkJZmxleGNhbl9lbnRlcl9zdG9wX21vZGUocHJp
dik7DQo+ICsJCQllcnIgPSBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZShwcml2KTsNCj4gKwkJCWlm
IChlcnIpDQo+ICsJCQkJcmV0dXJuIGVycjsNCj4gIAkJfSBlbHNlIHsNCj4gIAkJCWVyciA9IGZs
ZXhjYW5fY2hpcF9kaXNhYmxlKHByaXYpOw0KPiAgCQkJaWYgKGVycikNCj4gQEAgLTE2NjUsMTAg
KzE2ODUsMTMgQEAgc3RhdGljIGludCBfX21heWJlX3VudXNlZA0KPiBmbGV4Y2FuX25vaXJxX3Jl
c3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpICB7DQo+ICAJc3RydWN0IG5ldF9kZXZpY2UgKmRl
diA9IGRldl9nZXRfZHJ2ZGF0YShkZXZpY2UpOw0KPiAgCXN0cnVjdCBmbGV4Y2FuX3ByaXYgKnBy
aXYgPSBuZXRkZXZfcHJpdihkZXYpOw0KPiArCWludCBlcnI7DQo+IA0KPiAgCWlmIChuZXRpZl9y
dW5uaW5nKGRldikgJiYgZGV2aWNlX21heV93YWtldXAoZGV2aWNlKSkgew0KPiAgCQlmbGV4Y2Fu
X2VuYWJsZV93YWtldXBfaXJxKHByaXYsIGZhbHNlKTsNCj4gLQkJZmxleGNhbl9leGl0X3N0b3Bf
bW9kZShwcml2KTsNCj4gKwkJZXJyID0gZmxleGNhbl9leGl0X3N0b3BfbW9kZShwcml2KTsNCj4g
KwkJaWYgKGVycikNCj4gKwkJCXJldHVybiBlcnI7DQo+ICAJfQ0KPiANCj4gIAlyZXR1cm4gMDsN
Cj4gLS0NCj4gMi4xNy4xDQoNCg==
