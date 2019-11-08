Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB72F400D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfKHFkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:40:18 -0500
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:26087
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725794AbfKHFkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 00:40:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/Wvo7JEuIFKGmlF1tDhYp1F4Z1qI4xcKUSfeRp2OW6xBLCffSB4t7fP7I6ggSXl75frvLlFCVJJDRGzsYuFTUPhirFbaA+J/zNZlK1RmTW9SL5dbgVMi6STZ7s/qBN/HehKtYgIdbvgdDcXLxkY+kEw5G+/5yNCqM0tdm+/ilKFcqTDhLJCxtHJS9Z7N6yyiNTGy5acTcmRNq/hZoX+1gNxZ0lBrAPTX5pMdU4qxAwFPipOABs0QbKJZ2HUGTv+TA9LCiHf6t1x7HF+LrULaxJVHZA9kxZdC22Jx2bcl1CyJ+lKWMa7RFIl1N4Ti7KJoc4F3UXY43BcBFGTeJGFzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyulIfEZG1bmG/QoE/xHxG29FVNHBtNAn8XCm6/MepA=;
 b=i5DAYZHKehe31pcPrLde/lvRLqPSICXXWJuP+7U98H4TFOfYJLKev8vOgQgou/VQdxygoWiARufO9YmFixDHFiaJ4AKK3X2cZg1jBuGf+u/3iKBBaKFrsamHdth4X4Emw1xiUSIPC5PTmZ9SAVyKVEvleocankhQjS9Tr4/Acyjrj9uISnXUJtc59Ad5Llnr8ezoTG0fznP4/VbHD56lJTfL4x7Q8cAG/SX6GS1NbiL9L5qjhqYqGjmWSSDdwtpit/Xe6gQF/myhQs+6car8DmU7vlGRH/tU85gAHXFrb3GtqTfF+ztlEE/aFF/COleRWblP0BODJvakXkwMfSN71A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyulIfEZG1bmG/QoE/xHxG29FVNHBtNAn8XCm6/MepA=;
 b=nOrufya3i615pUq7g3RVmeO53MyiOX4FI7UGeLKMvNte5h9bMRxYFLv+Z9y6Kb83FUm90O9idG9QoZoO1QLutKv0K0g7Mr2SDsvOMtAuVYRerzf0nu3wau9A8IRW2o1IWy4ua93PofK7MvqeBKPuNUOncZildlWyTH2rwh0MsXI=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4283.eurprd04.prod.outlook.com (52.135.131.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 05:40:12 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 05:40:12 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V4 1/2] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH V4 1/2] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVfnlfcicpFKT7vkKHRAXdf1SEk6eA8NnA
Date:   Fri, 8 Nov 2019 05:40:12 +0000
Message-ID: <DB7PR04MB46183AF80BF91DC50522E6DAE67B0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191009080956.29128-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191009080956.29128-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f6505755-fc9f-4184-b3c9-08d7640e2016
x-ms-traffictypediagnostic: DB7PR04MB4283:|DB7PR04MB4283:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB428309F98E0C1A81FE72E25BE67B0@DB7PR04MB4283.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(13464003)(54534003)(199004)(189003)(66476007)(81166006)(8676002)(316002)(8936002)(110136005)(3846002)(26005)(81156014)(54906003)(2906002)(99286004)(478600001)(25786009)(14454004)(53546011)(2501003)(102836004)(33656002)(66066001)(6506007)(486006)(569044001)(6116002)(86362001)(256004)(186003)(76176011)(14444005)(5024004)(7696005)(71190400001)(74316002)(446003)(7736002)(11346002)(71200400001)(64756008)(66946007)(66446008)(55016002)(9686003)(5660300002)(4326008)(6436002)(305945005)(229853002)(476003)(66556008)(6246003)(52536014)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4283;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fD0DkekxZUDXMAgB0qKh56nUAnL3+KmfRZjCwXQhz4KfZUW5XbE1q+Jb3fTd49aFcbS+8XzO830mm024zKHt7/zLoHIh4+yohXqRqikhb8S5UamLSWPBZpGK6CoStE96EGuAN+U2c4NmJWg9VpY0QldRn31siXY6MKu/hgOS0oE3tL2E9rTHGDP2Xbu4V5HyMUNC5pQ0ydpE8xtfQ3iahoE3WATU+dfywyziQggF4pm647sy/usqRgsFb9GjKblPxlGI4aN1KLvrFBRYWQaa1tWwgJx+fZMJ6nX2UsO0odg/7qdHW9mo04ORlN3Ni4GLcH/W61J8hfaqBQMoCr2+ILAz1Pk9OLK8yRbUGnsN9uQxiB7aLrVW/DosMTSkNK8llJcgbrDJ+zHlokLSsjQ8MpHBukB14tOJlYqNs14gq+vjhuEF+q+2LUPkhkiBdh++
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6505755-fc9f-4184-b3c9-08d7640e2016
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 05:40:12.5014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DAlOTqiAuvrFEdTKJr4nUPXWxcMdTnJ7V68+2g0r5Fz2fbJT6dsmWpt+VQ5r/ciPp209B+D78/dOsLZxbxXcEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4283
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpLaW5kbHkgUGluZy4uLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPg0KPiBTZW50OiAyMDE5xOoxMNTCOcjVIDE2OjEzDQo+IFRvOiBta2xAcGVu
Z3V0cm9uaXguZGU7IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IHdnQGdyYW5kZWdn
ZXIuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBzZWFuQGdlYW5peC5jb207DQo+IGRsLWxp
bnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFu
Z0BueHAuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggVjQgMS8yXSBjYW46IGZsZXhjYW46IGZpeCBk
ZWFkbG9jayB3aGVuIHVzaW5nIHNlbGYgd2FrZXVwDQo+IA0KPiBBcyByZXByb3RlZCBieSBTZWFu
IE55ZWtqYWVyIGJlbG93Og0KPiBXaGVuIHN1c3BlbmRpbmcsIHdoZW4gdGhlcmUgaXMgc3RpbGwg
Y2FuIHRyYWZmaWMgb24gdGhlIGludGVyZmFjZXMgdGhlIGZsZXhjYW4NCj4gaW1tZWRpYXRlbHkg
d2FrZXMgdGhlIHBsYXRmb3JtIGFnYWluLiBBcyBpdCBzaG91bGQgOi0pLiBCdXQgaXQgdGhyb3dz
IHRoaXMgZXJyb3INCj4gbXNnOg0KPiBbIDMxNjkuMzc4NjYxXSBQTTogbm9pcnEgc3VzcGVuZCBv
ZiBkZXZpY2VzIGZhaWxlZA0KPiANCj4gT24gdGhlIHdheSBkb3duIHRvIHN1c3BlbmQgdGhlIGlu
dGVyZmFjZSB0aGF0IHRocm93cyB0aGUgZXJyb3IgbWVzc2FnZSBkb2VzDQo+IGNhbGwgZmxleGNh
bl9zdXNwZW5kIGJ1dCBmYWlscyB0byBjYWxsIGZsZXhjYW5fbm9pcnFfc3VzcGVuZC4gVGhhdCBt
ZWFucyB0aGUNCj4gZmxleGNhbl9lbnRlcl9zdG9wX21vZGUgaXMgY2FsbGVkLCBidXQgb24gdGhl
IHdheSBvdXQgb2Ygc3VzcGVuZCB0aGUgZHJpdmVyDQo+IG9ubHkgY2FsbHMgZmxleGNhbl9yZXN1
bWUgYW5kIHNraXBzIGZsZXhjYW5fbm9pcnFfcmVzdW1lLCB0aHVzIGl0IGRvZXNuJ3QgY2FsbA0K
PiBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlLiBUaGlzIGxlYXZlcyB0aGUgZmxleGNhbiBpbiBzdG9w
IG1vZGUsIGFuZCB3aXRoIHRoZQ0KPiBjdXJyZW50IGRyaXZlciBpdCBjYW4ndCByZWNvdmVyIGZy
b20gdGhpcyBldmVuIHdpdGggYSBzb2Z0IHJlYm9vdCwgaXQgcmVxdWlyZXMgYQ0KPiBoYXJkIHJl
Ym9vdC4NCj4gDQo+IFRoZSBiZXN0IHdheSB0byBleGl0IHN0b3AgbW9kZSBpcyBpbiBXYWtlIFVw
IGludGVycnVwdCBjb250ZXh0LCBhbmQgdGhlbg0KPiBzdXNwZW5kKCkgYW5kIHJlc3VtZSgpIGZ1
bmN0aW9ucyBjYW4gYmUgc3ltbWV0cmljLiBIb3dldmVyLCBzdG9wIG1vZGUNCj4gcmVxdWVzdCBh
bmQgYWNrIHdpbGwgYmUgY29udHJvbGxlZCBieSBTQ1UoU3lzdGVtIENvbnRyb2wgVW5pdCkNCj4g
ZmlybXdhcmUobWFuYWdlIGNsb2NrLHBvd2VyLHN0b3AgbW9kZSwgZXRjLiBieSBDb3J0ZXgtTTQg
Y29yZSkgaW4gY29taW5nDQo+IGkuTVg4KFFNL1FYUCkuIEFuZCBTQ1UgZmlybXdhcmUgaW50ZXJm
YWNlIGNhbid0IGJlIGF2YWlsYWJsZSBpbiBpbnRlcnJ1cHQNCj4gY29udGV4dC4NCj4gDQo+IEZv
ciBjb21wYXRpYmlsbGl0eSwgdGhlIHdha2UgdXAgbWVjaGFuaXNtIGNhbid0IGJlIHN5bW1ldHJp
Yywgc28gd2UgbmVlZA0KPiBpbl9zdG9wX21vZGUgaGFjay4NCj4gDQo+IEZpeGVzOiBkZTM1Nzhj
MTk4YzYgKCJjYW46IGZsZXhjYW46IGFkZCBzZWxmIHdha2V1cCBzdXBwb3J0IikNCj4gUmVwb3J0
ZWQtYnk6IFNlYW4gTnlla2phZXIgPHNlYW5AZ2Vhbml4LmNvbT4NCj4gVGVzdGVkLWJ5OiBTZWFu
IE55ZWtqYWVyIDxzZWFuQGdlYW5peC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFu
ZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IA0KPiBDaGFuZ2Vsb2c6DQo+IFYxLT5WMjoN
Cj4gCSogYWRkIFJlcG9ydGVkLWJ5IHRhZy4NCj4gCSogcmViYXNlIG9uIHBhdGNoOiBjYW46Zmxl
eGNhbjpmaXggc3RvcCBtb2RlIGFja25vd2xlZGdtZW50Lg0KPiBWMi0+VjM6DQo+IAkqIHJlYmFz
ZSBvbiBsaW51eC1jYW4vdGVzdGluZy4NCj4gCSogY2hhbmdlIGludG8gcGF0Y2ggc2V0Lg0KPiBW
My0+VjQ6DQo+IAkqIGFkZCBUZXN0ZWQtYnkgdGFnLg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2Nh
bi9mbGV4Y2FuLmMgfCAyMyArKysrKysrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDIzIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4v
ZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyBpbmRleA0KPiAxY2Q1MTc5Y2I4
NzYuLjI0Y2MzODZjNGJjZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4u
Yw0KPiArKysgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+IEBAIC0yODYsNiArMjg2LDcg
QEAgc3RydWN0IGZsZXhjYW5fcHJpdiB7DQo+ICAJY29uc3Qgc3RydWN0IGZsZXhjYW5fZGV2dHlw
ZV9kYXRhICpkZXZ0eXBlX2RhdGE7DQo+ICAJc3RydWN0IHJlZ3VsYXRvciAqcmVnX3hjZWl2ZXI7
DQo+ICAJc3RydWN0IGZsZXhjYW5fc3RvcF9tb2RlIHN0bTsNCj4gKwlib29sIGluX3N0b3BfbW9k
ZTsNCj4gDQo+ICAJLyogUmVhZCBhbmQgV3JpdGUgQVBJcyAqLw0KPiAgCXUzMiAoKnJlYWQpKHZv
aWQgX19pb21lbSAqYWRkcik7DQo+IEBAIC0xNjcwLDYgKzE2NzEsOCBAQCBzdGF0aWMgaW50IF9f
bWF5YmVfdW51c2VkIGZsZXhjYW5fc3VzcGVuZChzdHJ1Y3QNCj4gZGV2aWNlICpkZXZpY2UpDQo+
ICAJCQllcnIgPSBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZShwcml2KTsNCj4gIAkJCWlmIChlcnIp
DQo+ICAJCQkJcmV0dXJuIGVycjsNCj4gKw0KPiArCQkJcHJpdi0+aW5fc3RvcF9tb2RlID0gdHJ1
ZTsNCj4gIAkJfSBlbHNlIHsNCj4gIAkJCWVyciA9IGZsZXhjYW5fY2hpcF9kaXNhYmxlKHByaXYp
Ow0KPiAgCQkJaWYgKGVycikNCj4gQEAgLTE2OTYsNiArMTY5OSwxNSBAQCBzdGF0aWMgaW50IF9f
bWF5YmVfdW51c2VkIGZsZXhjYW5fcmVzdW1lKHN0cnVjdA0KPiBkZXZpY2UgKmRldmljZSkNCj4g
IAkJbmV0aWZfZGV2aWNlX2F0dGFjaChkZXYpOw0KPiAgCQluZXRpZl9zdGFydF9xdWV1ZShkZXYp
Ow0KPiAgCQlpZiAoZGV2aWNlX21heV93YWtldXAoZGV2aWNlKSkgew0KPiArCQkJaWYgKHByaXYt
PmluX3N0b3BfbW9kZSkgew0KPiArCQkJCWZsZXhjYW5fZW5hYmxlX3dha2V1cF9pcnEocHJpdiwg
ZmFsc2UpOw0KPiArCQkJCWVyciA9IGZsZXhjYW5fZXhpdF9zdG9wX21vZGUocHJpdik7DQo+ICsJ
CQkJaWYgKGVycikNCj4gKwkJCQkJcmV0dXJuIGVycjsNCj4gKw0KPiArCQkJCXByaXYtPmluX3N0
b3BfbW9kZSA9IGZhbHNlOw0KPiArCQkJfQ0KPiArDQo+ICAJCQlkaXNhYmxlX2lycV93YWtlKGRl
di0+aXJxKTsNCj4gIAkJfSBlbHNlIHsNCj4gIAkJCWVyciA9IHBtX3J1bnRpbWVfZm9yY2VfcmVz
dW1lKGRldmljZSk7IEBAIC0xNzMyLDYgKzE3NDQsMTENCj4gQEAgc3RhdGljIGludCBfX21heWJl
X3VudXNlZCBmbGV4Y2FuX25vaXJxX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2aWNlKQ0KPiAg
CXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBkZXZfZ2V0X2RydmRhdGEoZGV2aWNlKTsNCj4gIAlz
dHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gDQo+ICsJLyog
TmVlZCB0byBlbmFibGUgd2FrZXVwIGludGVycnVwdCBpbiBub2lycSBzdXNwZW5kIHN0YWdlLiBP
dGhlcndpc2UsDQo+ICsJICogaXQgd2lsbCB0cmlnZ2VyIGNvbnRpbnVvdXNseSB3YWtldXAgaW50
ZXJydXB0IGlmIHRoZSB3YWtldXAgZXZlbnQNCj4gKwkgKiBjb21lcyBiZWZvcmUgbm9pcnEgc3Vz
cGVuZCBzdGFnZSwgYW5kIHNpbXVsdGFuZW91c2x5IGl0IGhhcyBlbnRlcg0KPiArCSAqIHRoZSBz
dG9wIG1vZGUuDQo+ICsJICovDQo+ICAJaWYgKG5ldGlmX3J1bm5pbmcoZGV2KSAmJiBkZXZpY2Vf
bWF5X3dha2V1cChkZXZpY2UpKQ0KPiAgCQlmbGV4Y2FuX2VuYWJsZV93YWtldXBfaXJxKHByaXYs
IHRydWUpOw0KPiANCj4gQEAgLTE3NDQsMTEgKzE3NjEsMTcgQEAgc3RhdGljIGludCBfX21heWJl
X3VudXNlZA0KPiBmbGV4Y2FuX25vaXJxX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQo+
ICAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+ICAJaW50
IGVycjsNCj4gDQo+ICsJLyogTmVlZCB0byBleGl0IHN0b3AgbW9kZSBpbiBub2lycSByZXN1bWUg
c3RhZ2UuIE90aGVyd2lzZSwgaXQgd2lsbA0KPiArCSAqIHRyaWdnZXIgY29udGludW91c2x5IHdh
a2V1cCBpbnRlcnJ1cHQgaWYgdGhlIHdha2V1cCBldmVudCBjb21lcywNCj4gKwkgKiBhbmQgc2lt
dWx0YW5lb3VzbHkgaXQgaGFzIHN0aWxsIGluIHN0b3AgbW9kZS4NCj4gKwkgKi8NCj4gIAlpZiAo
bmV0aWZfcnVubmluZyhkZXYpICYmIGRldmljZV9tYXlfd2FrZXVwKGRldmljZSkpIHsNCj4gIAkJ
ZmxleGNhbl9lbmFibGVfd2FrZXVwX2lycShwcml2LCBmYWxzZSk7DQo+ICAJCWVyciA9IGZsZXhj
YW5fZXhpdF9zdG9wX21vZGUocHJpdik7DQo+ICAJCWlmIChlcnIpDQo+ICAJCQlyZXR1cm4gZXJy
Ow0KPiArDQo+ICsJCXByaXYtPmluX3N0b3BfbW9kZSA9IGZhbHNlOw0KPiAgCX0NCj4gDQo+ICAJ
cmV0dXJuIDA7DQo+IC0tDQo+IDIuMTcuMQ0KDQo=
