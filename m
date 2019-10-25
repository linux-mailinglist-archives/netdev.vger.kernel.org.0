Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0A6E4837
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 12:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409036AbfJYKK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 06:10:28 -0400
Received: from mail-eopbgr50079.outbound.protection.outlook.com ([40.107.5.79]:48289
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409013AbfJYKK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 06:10:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcXuTjg3FwcW58324mbN1Kept4rj7vOmh+LVB/5h1lkzS4vePzgpk8hGSUZlm4mcXmznCBE571qC83c8EYBFiJujZOH8A9fwNtSYll+J/50Rbr9cuKSo5cpRQp/h8JlvSsNprj1upZaq+XDASytTv0J6912sqNi2Uzh6w0CK6Ibr0iajTtdqqdkDM+bQr9zazKrt5aXV78Rxw9oMrl9CIdNR/hAy4OaetRmkWz7qw3qnYaKzD77/7hP29Qrawmw0//7niPoCI1uWrPBein9ecC06cQMRqluAk+QQGEb5eHXVz2jw+jqd7qk5QXlETS9pvPzh6m6FTMj+0FBroW1T7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyulIfEZG1bmG/QoE/xHxG29FVNHBtNAn8XCm6/MepA=;
 b=Hp3YiAs90/U2HTshAsZhK5wIc3Mat36f7QcYR0DyLqBPz19nN+U0KbYsN1zt26sNWjIbzk+n2zFGJu42iShbLoGLXFicQ5DBeA2K6ZCcdusTJUN0d3aiK/Dn+y43rbDS4ctO0iozOx4O1E4wvmFxJzG0z9a2g7wC95DHv2nsWLcE/EwXanjZfM9WaxrfK/9N0/sK5EIT2hWSiTv1Md8DI09y75MyVNPfU+EA6mgcBjU1/uJj3P7OXda4ffe7pidp8YCUs/OYhNTncIXRVx4lyFk3l7RrCuDRaQftSPWAhAPN0o4X6dyJDREYiO8xb9Jn6/HEpqqb2GG8AxJ9ltMSoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyulIfEZG1bmG/QoE/xHxG29FVNHBtNAn8XCm6/MepA=;
 b=Jx0HRvOd+B6bx1oH9FuOw+dIK3/xCtN0m+biG+5556O1d++EHm33CYzq8QdynnptPGgCgitaR55izk+zoA2ANa427lnaKwyF3rWITzUXUhbYurZ79GSeO60mGNAG4Xifh8wYkrepgZqgr9ZUaeTSYpcmteLg4T+hH6rpH/wwKlA=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4969.eurprd04.prod.outlook.com (20.176.234.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Fri, 25 Oct 2019 10:10:22 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679%3]) with mapi id 15.20.2367.029; Fri, 25 Oct 2019
 10:10:22 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V4 1/2] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH V4 1/2] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVfnlfcicpFKT7vkKHRAXdf1SEk6drO7hg
Date:   Fri, 25 Oct 2019 10:10:22 +0000
Message-ID: <DB7PR04MB4618B68B92D802B62EFB2F40E6650@DB7PR04MB4618.eurprd04.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: ad9467c2-0106-49f5-22bb-08d759338be4
x-ms-traffictypediagnostic: DB7PR04MB4969:|DB7PR04MB4969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB49690685C717026C480F9F8EE6650@DB7PR04MB4969.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(54534003)(13464003)(66066001)(569044001)(486006)(54906003)(316002)(86362001)(55016002)(6436002)(229853002)(9686003)(5660300002)(81166006)(2501003)(11346002)(14454004)(71190400001)(81156014)(110136005)(8676002)(8936002)(478600001)(33656002)(476003)(446003)(6506007)(6116002)(3846002)(74316002)(99286004)(14444005)(305945005)(7736002)(256004)(25786009)(52536014)(71200400001)(5024004)(53546011)(7696005)(76176011)(64756008)(66556008)(76116006)(66476007)(66446008)(66946007)(26005)(6246003)(4326008)(186003)(2906002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4969;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 03nqUTRCCPgIWCAgVnUzkcVTtQlSTx64155GcIWKRCs6xvb1jHB04+Ien+UZtQQlqK2CAfVk9DjONd/+RX4/Aaa44PputqciQfnrXLeyu++g4SvyPJPDCL1WbqabiD+ROCc1MbWEgJmGtI/ES5i1i3nIGnRGKeuHbc+iH+n6FXNlfhC9MGp2fGxNzIv0jMeNuSpHWIGEUpgUuCF8CThR0AgSM4rTxAPCOUZ3oTSU1y4o+o25B6m6juYMMBHxUCnxOS4zZnnSNUfIsz9IFFoOHeJ754MDwSigUfd7x9HgvHiGu4aEiYBF7e8wMGg8pqpv46p9Zoa8cB388UtueYqgvlS/QlGpPOmazZLY4jA8imapSOSbWRaxf3OdjxrW55xwvRIKnVnmwDLCtVsG3NiV0QjHV0/By9XZhz7Ol6GetKQHZbIUxcb6m/aBosh8dwth
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9467c2-0106-49f5-22bb-08d759338be4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 10:10:22.0623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gviLlKOPb8GzhryFG0HFoFFumDH1fm3kpj8tzWiBEN8MOAYZPMuzStUJroEs1jzWJZ48qwrrADVKtLmc3cWYkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4969
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
