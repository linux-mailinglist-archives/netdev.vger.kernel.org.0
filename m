Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89CDD2FF0
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfJJSFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:05:02 -0400
Received: from mail-eopbgr50128.outbound.protection.outlook.com ([40.107.5.128]:22039
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726323AbfJJSFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 14:05:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdVGLsefEHpwAjmLXjjgigsoGjcQluDqMWAdUYk3gJz1Nk51UX+EXjhZh1ehqRWdAZ9WbfO02MZpK+2hCc8JFdVn3qP+VMimDIvkgDjEg74mYWv+Zm6SenQ3ambk3pFZlldWn551K8r8DDrefq4ZyT9vs8LKf3N0e8w/kmw3Se1sNGeDpz1eOWq1lIUFzN7cnUTJU2D0P7oMpMl+cBIpLaycM15ZTEyKElPudade6DcRmuutog6j5KvC7KpueCWKIXJIrz2J62qilibY8DnKoUsGl05/tq7jwJ6lDBfINGoVI6gN0oZQZqxu/Lv3gnXmt6et2G5Olxuh9mituwjojg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REY8QB/bwJOpe87+xADxALRWUAqHZjVEwdvQCzmILCM=;
 b=LYfaAyUt5b91bfsO+zELIdsFnyZtwJpo5VsSD/VG4otev/eJTOHb6Al4++YVhXvMSu56TgLrmkuqlHw32M80leaMl0jPwUvUS0LzSjNoPs1IRJFGQJjw9dEn9LTIMGeJBFMDQLObyjD6QXXlZsQT7Ul4Wczix54oGf1LlFVBgE06bU0u2GVUjGdafrGJL93e3CX3/i8cClxEf0x+YSQhAW1f+AieDa4qHgQ8cApFOKEDxtKOr3HTaLuQHG7hT2NUK0pBU1Cmj0+Qxe5RB73ZFSgcHfFoQHy/tZvuphMpsVDag4gqKUv1RSChjxkabkuUtqkEXDpdhu+yTphiyF1xOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REY8QB/bwJOpe87+xADxALRWUAqHZjVEwdvQCzmILCM=;
 b=JeeuDKmRvTykcgWoKzPTsAt5oW3bmf3LXl9pOJaWRpF6SceSj/4i8yg1vEbIdct7KxusOIKHnHAXE96Hu26X8bxfIAa3nKApiwWbeGNcv0J8NxTSvpaakxuFwbOIT16d9UO3hrunZpL0jc8ectcDV22h/OyQ8W2/e/j8kRwRdxs=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2287.eurprd07.prod.outlook.com (10.169.130.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.10; Thu, 10 Oct 2019 18:04:45 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::49b7:a244:d3e4:396c]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::49b7:a244:d3e4:396c%9]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 18:04:45 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-can <linux-can@vger.kernel.org>
CC:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        =?utf-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <martin@geanix.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 24/29] can: ti_hecc: add fifo underflow error reporting
Thread-Topic: [PATCH 24/29] can: ti_hecc: add fifo underflow error reporting
Thread-Index: AQHVf2TP24N21wJ000K2CE4lhnqQG6dUBpaAgAAlAoA=
Date:   Thu, 10 Oct 2019 18:04:45 +0000
Message-ID: <4dee69d8-f8f7-080e-1a4f-7ed7f94a66a8@victronenergy.com>
References: <20191010121750.27237-1-mkl@pengutronix.de>
 <20191010121750.27237-25-mkl@pengutronix.de>
 <dfdbefb3-48c4-0830-9627-146da062a01a@pengutronix.de>
In-Reply-To: <dfdbefb3-48c4-0830-9627-146da062a01a@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-originating-ip: [2001:1c01:3bc5:4e00:963:dff1:1c4c:eaac]
x-clientproxiedby: AM0PR07CA0017.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::30) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f613b9d-dd4b-4421-65c4-08d74dac54c4
x-ms-traffictypediagnostic: VI1PR0701MB2287:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0701MB228755040D258C9AB60538DFC0940@VI1PR0701MB2287.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(346002)(396003)(136003)(376002)(366004)(189003)(199004)(52314003)(86362001)(229853002)(6116002)(446003)(476003)(36756003)(14454004)(2616005)(7736002)(2906002)(305945005)(486006)(966005)(71200400001)(99286004)(71190400001)(58126008)(316002)(6436002)(66446008)(64756008)(66556008)(66476007)(8936002)(186003)(4326008)(66946007)(54906003)(8676002)(81156014)(81166006)(11346002)(76176011)(6306002)(6512007)(102836004)(2501003)(386003)(52116002)(6506007)(31686004)(25786009)(53546011)(478600001)(31696002)(110136005)(65806001)(6246003)(46003)(65956001)(256004)(6486002)(14444005)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2287;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: azxkvDg4Yv2vQGldBXrGNMwxedD6C91/d1HZ6XrPpzF6k+u4s/vGi7Q+VggZoFKxFODCTBiEu5JkKAL/DmCjuW23qDSu5M8YLwxnu0tuVdMNVnfPI0sViWKqbBFUPNNNtLvjrlxV0vk0Y1SmEp/VFa2Z3arBu7cCSaWroL3ipPaUHjiUpJw7qujnArqTPGzfG+EQHvUACSn21ZtZSdXMyeFRv598FPEnDV00xJ4H1JQXcbeG7xuYV5nmtqM2YddlJwVu9EFusezblGedVDGjMM/5qgD0oV93yDL4Yo95BQJ49SSaDs7kBTP9ASwV7qA7v0Z7XvxOJE1HGKhr7OBDP50a/5jTq3QL9zoTspNYn2rqLdb0PLXM3PP/zOjHI7vadjPKwIorjTapQlZ+877GUqO2+/EaoiGiHRpYnxbDyREtv1+noByWCL4Dw5QEBQQkx0z2pz0gBt6t4HYcdCCiOA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9F329C653DF7040A4E5459E07074E38@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f613b9d-dd4b-4421-65c4-08d74dac54c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 18:04:45.0804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gxvnYwo11/OqeVQ/+fEP9WcSnLw13zHJySf4hR77d2ukHiFYXDUdg1stsMv4m1yYZzT02VdDEfoV7d2PE5E18jGOCO4NxSjnqpFWZL6jG+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2287
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXR0ZW1wdCAyLCBub3cgYXMgcGxhaW4gdGV4dC4uLiAodmdlciBkb2Vzbid0IGxpa2UgaHRtbCkN
Cg0KT24gMTAvMTAvMTkgNTo1MiBQTSwgTWFyYyBLbGVpbmUtQnVkZGUgd3JvdGU6DQo+IE9uIDEw
LzEwLzE5IDI6MTcgUE0sIE1hcmMgS2xlaW5lLUJ1ZGRlIHdyb3RlOg0KPj4gRnJvbTogSmVyb2Vu
IEhvZnN0ZWUgPGpob2ZzdGVlQHZpY3Ryb25lbmVyZ3kuY29tPg0KPj4NCj4+IFdoZW4gdGhlIHJ4
IGZpZm8gb3ZlcmZsb3dzIHRoZSB0aV9oZWNjIHdvdWxkIHNpbGVudGx5IGRyb3AgdGhlbSBzaW5j
ZQ0KPj4gdGhlIG92ZXJ3cml0ZSBwcm90ZWN0aW9uIGlzIGVuYWJsZWQgZm9yIGFsbCBtYWlsYm94
ZXMuIFNvIGRpc2FibGUgaXQNCj4+IGZvciB0aGUgbG93ZXN0IHByaW9yaXR5IG1haWxib3ggYW5k
IGluY3JlbWVudCB0aGUgcnhfZmlmb19lcnJvcnMgd2hlbg0KPj4gcmVjZWl2ZSBtZXNzYWdlIGxv
c3QgaXMgc2V0LiBEcm9wIHRoZSBtZXNzYWdlIGl0c2VsZiBpbiB0aGF0IGNhc2UsDQo+PiBzaW5j
ZSBpdCBtaWdodCBiZSBwYXJ0aWFsbHkgdXBkYXRlZC4NCj4gSXMgdGhhdCB5b3VyIG9ic2VydmF0
aW9uIG9yIGRvZXMgdGhlIGRhdGEgc2hlZXQgc2F5IGFueXRoaW5nIHRvIHRoaXMNCj4gc2l0dWF0
aW9uPw0KDQoNCkkgY291bGRuJ3QgZmluZCBpbiB0aGUgZGF0YSBzaGVldCwgc28gSSBzaW1wbHkg
dGVzdGVkIGl0LCBieSBhbGxvd2luZw0KdGhlIGhpZ2hlc3QgbWFpbGJveCB0byBiZSBvdmVyd3Jp
dHRlbiBhbmQgc2VuZCBhIHN0cmVhbSBhbHRlcm5hdGluZw0Kd2l0aCBtZXNzYWdlcyB3aWxsIGFs
bCBiaXRzIHNldCBhbmQgYWxsIGNsZWFyZWQuIFRoYXQgZG9lcyBlbmQgd2l0aA0KY2FuaWRzIGZy
b20gb25lIG1lc3NhZ2UgY29tYmluZWQgd2l0aCBkYXRhIGZyb20gYW5vdGhlci4NCg0KDQo+PiBT
aWduZWQtb2ZmLWJ5OiBKZXJvZW4gSG9mc3RlZSA8amhvZnN0ZWVAdmljdHJvbmVuZXJneS5jb20+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIEtsZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRl
Pg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L2Nhbi90aV9oZWNjLmMgfCAyMSArKysrKysrKysr
KysrKysrKy0tLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDQgZGVs
ZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi90aV9oZWNjLmMg
Yi9kcml2ZXJzL25ldC9jYW4vdGlfaGVjYy5jDQo+PiBpbmRleCA2ZWEyOTEyNmM2MGIuLmMyZDgz
YWRhMjAzYSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi90aV9oZWNjLmMNCj4+ICsr
KyBiL2RyaXZlcnMvbmV0L2Nhbi90aV9oZWNjLmMNCj4+IEBAIC04Miw3ICs4Miw3IEBAIE1PRFVM
RV9WRVJTSU9OKEhFQ0NfTU9EVUxFX1ZFUlNJT04pOw0KPj4gICAjZGVmaW5lIEhFQ0NfQ0FOVEEJ
CTB4MTAJLyogVHJhbnNtaXNzaW9uIGFja25vd2xlZGdlICovDQo+PiAgICNkZWZpbmUgSEVDQ19D
QU5BQQkJMHgxNAkvKiBBYm9ydCBhY2tub3dsZWRnZSAqLw0KPj4gICAjZGVmaW5lIEhFQ0NfQ0FO
Uk1QCQkweDE4CS8qIFJlY2VpdmUgbWVzc2FnZSBwZW5kaW5nICovDQo+PiAtI2RlZmluZSBIRUND
X0NBTlJNTAkJMHgxQwkvKiBSZW1vdGUgbWVzc2FnZSBsb3N0ICovDQo+PiArI2RlZmluZSBIRUND
X0NBTlJNTAkJMHgxQwkvKiBSZWNlaXZlIG1lc3NhZ2UgbG9zdCAqLw0KPj4gICAjZGVmaW5lIEhF
Q0NfQ0FOUkZQCQkweDIwCS8qIFJlbW90ZSBmcmFtZSBwZW5kaW5nICovDQo+PiAgICNkZWZpbmUg
SEVDQ19DQU5HQU0JCTB4MjQJLyogU0VDQyBvbmx5Okdsb2JhbCBhY2NlcHRhbmNlIG1hc2sgKi8N
Cj4+ICAgI2RlZmluZSBIRUNDX0NBTk1DCQkweDI4CS8qIE1hc3RlciBjb250cm9sICovDQo+PiBA
QCAtMzg1LDggKzM4NSwxNyBAQCBzdGF0aWMgdm9pZCB0aV9oZWNjX3N0YXJ0KHN0cnVjdCBuZXRf
ZGV2aWNlICpuZGV2KQ0KPj4gICAJLyogRW5hYmxlIHR4IGludGVycnVwdHMgKi8NCj4+ICAgCWhl
Y2Nfc2V0X2JpdChwcml2LCBIRUNDX0NBTk1JTSwgQklUKEhFQ0NfTUFYX1RYX01CT1gpIC0gMSk7
DQo+PiAgIA0KPj4gLQkvKiBQcmV2ZW50IG1lc3NhZ2Ugb3Zlci13cml0ZSAmIEVuYWJsZSBpbnRl
cnJ1cHRzICovDQo+PiAtCWhlY2Nfd3JpdGUocHJpdiwgSEVDQ19DQU5PUEMsIEhFQ0NfU0VUX1JF
Ryk7DQo+PiArCS8qIFByZXZlbnQgbWVzc2FnZSBvdmVyLXdyaXRlIHRvIGNyZWF0ZSBhIHJ4IGZp
Zm8sIGJ1dCBub3QgZm9yDQo+PiArCSAqIHRoZSBsb3dlc3QgcHJpb3JpdHkgbWFpbGJveCwgc2lu
Y2UgdGhhdCBhbGxvd3MgZGV0ZWN0aW5nDQo+PiArCSAqIG92ZXJmbG93cyBpbnN0ZWFkIG9mIHRo
ZSBoYXJkd2FyZSBzaWxlbnRseSBkcm9wcGluZyB0aGUNCj4+ICsJICogbWVzc2FnZXMuIFRoZSBs
b3dlc3QgcnggbWFpbGJveCBpcyBvbmUgYWJvdmUgdGhlIHR4IG9uZXMsDQo+PiArCSAqIGhlbmNl
IGl0cyBtYnhubyBpcyB0aGUgbnVtYmVyIG9mIHR4IG1haWxib3hlcy4NCj4+ICsJICovDQo+PiAr
CW1ieG5vID0gSEVDQ19NQVhfVFhfTUJPWDsNCj4+ICsJbWJ4X21hc2sgPSB+QklUKG1ieG5vKTsN
Cj4+ICsJaGVjY193cml0ZShwcml2LCBIRUNDX0NBTk9QQywgbWJ4X21hc2spOw0KPj4gKw0KPj4g
KwkvKiBFbmFibGUgaW50ZXJydXB0cyAqLw0KPj4gICAJaWYgKHByaXYtPnVzZV9oZWNjMWludCkg
ew0KPj4gICAJCWhlY2Nfd3JpdGUocHJpdiwgSEVDQ19DQU5NSUwsIEhFQ0NfU0VUX1JFRyk7DQo+
PiAgIAkJaGVjY193cml0ZShwcml2LCBIRUNDX0NBTkdJTSwgSEVDQ19DQU5HSU1fREVGX01BU0sg
fA0KPj4gQEAgLTUzMSw2ICs1NDAsNyBAQCBzdGF0aWMgdW5zaWduZWQgaW50IHRpX2hlY2NfbWFp
bGJveF9yZWFkKHN0cnVjdCBjYW5fcnhfb2ZmbG9hZCAqb2ZmbG9hZCwNCj4+ICAgew0KPj4gICAJ
c3RydWN0IHRpX2hlY2NfcHJpdiAqcHJpdiA9IHJ4X29mZmxvYWRfdG9fcHJpdihvZmZsb2FkKTsN
Cj4+ICAgCXUzMiBkYXRhLCBtYnhfbWFzazsNCj4+ICsJaW50IGxvc3Q7DQo+PiAgIA0KPj4gICAJ
bWJ4X21hc2sgPSBCSVQobWJ4bm8pOw0KPj4gICAJZGF0YSA9IGhlY2NfcmVhZF9tYngocHJpdiwg
bWJ4bm8sIEhFQ0NfQ0FOTUlEKTsNCj4+IEBAIC01NTIsOSArNTYyLDEyIEBAIHN0YXRpYyB1bnNp
Z25lZCBpbnQgdGlfaGVjY19tYWlsYm94X3JlYWQoc3RydWN0IGNhbl9yeF9vZmZsb2FkICpvZmZs
b2FkLA0KPj4gICAJfQ0KPj4gICANCj4+ICAgCSp0aW1lc3RhbXAgPSBoZWNjX3JlYWRfc3RhbXAo
cHJpdiwgbWJ4bm8pOw0KPj4gKwlsb3N0ID0gaGVjY19yZWFkKHByaXYsIEhFQ0NfQ0FOUk1MKSAm
IG1ieF9tYXNrOw0KPj4gKwlpZiAodW5saWtlbHkobG9zdCkpDQo+PiArCQlwcml2LT5vZmZsb2Fk
LmRldi0+c3RhdHMucnhfZmlmb19lcnJvcnMrKzsNCj4gSW4gdGhlIGZsZXhjYW4gYW5kIGF0OTFf
Y2FuIGRyaXZlciB3ZSdyZSBpbmNyZW1lbnRpbmcgdGhlIGZvbGxvd2luZyBlcnJvcnM6DQo+IAkJ
CWRldi0+c3RhdHMucnhfb3Zlcl9lcnJvcnMrKzsNCj4gCQkJZGV2LT5zdGF0cy5yeF9lcnJvcnMr
KzsNCg0KDQpJIHVuZGVyc3Rvb2QgaXQgYXMgZm9sbG93cywgc2VlWzFdIGUuZy46DQoNCnJ4X2Vy
cm9ycyAtPiBsaW5rIGxldmVsIGVycm9ycywgbm90IHJlYWxseSBhcHBsaWNhYmxlIHRvIENBTg0K
KHBlcmhhcHMgaW4gc2luZ2xlIHNob3QgbW9kZSBvciBpZiB5b3Ugd2FudCAoYW5kIGNhbikgcmVw
b3J0IA0KcmV0cmFuc21pc3Npb25zKQ0KDQpyeF9vdmVyX2Vycm9ycyAtPiB0aGUgaGFyZHdhcmUg
aXRzZWxmIGNhbm5vdCBrZWVwIHVwLg0KTm90IGFwcGxpY2FibGUgZm9yIENBTi4NCg0KcnhfZmlm
b19lcnJvcnMgLT4gdGhlIHNvZnR3YXJlIGRyaXZlciBjYW5ub3Qga2VlcCB1cC4NClNvIEkgcGlj
a2VkIHRoYXQgb25lLg0KDQpyeF9kcm9wcGVkIC0+IHNvZnR3YXJlIGlzIGRyb3BwaW5nIG9uIHB1
cnBvc2UgYmFzZWQgb24gbGltaXRzIGV0Yy4NCg0KQnV0IEkgbWlnaHQgYmUgd3JvbmcuDQoNCg0K
PiBZb3UgY2FuIHNhdmUgdGhlIHJlZ2lzdGVyIGFjY2VzcyBpZiB5b3Ugb25seSBjaGVjayBmb3Ig
b3ZlcmZsb3dzIGlmDQo+IHJlYWRpbmcgZnJvbSB0aGUgbG93ZXN0IHByaW8gbWFpbGJveC4NCj4N
Cj4gSWYgeW91J3JlIGRpc2NhcmRpbmcgdGhlIGRhdGEgaWYgdGhlIG1haWxib3ggaXMgbWFya2Vk
IGFzIG92ZXJmbG93DQo+IHRoZXJlJ3Mgbm8gbmVlZCB0byByZWFkIHRoZSBkYXRhIGluIHRoZSBm
aXJzdCBwbGFjZS4NCj4NCj4+ICAgCWhlY2Nfd3JpdGUocHJpdiwgSEVDQ19DQU5STVAsIG1ieF9t
YXNrKTsNCj4+ICAgDQo+PiAtCXJldHVybiAxOw0KPj4gKwlyZXR1cm4gIWxvc3Q7DQo+PiAgIH0N
Cj4+ICAgDQo+PiAgIHN0YXRpYyBpbnQgdGlfaGVjY19lcnJvcihzdHJ1Y3QgbmV0X2RldmljZSAq
bmRldiwgaW50IGludF9zdGF0dXMsDQo+Pg0KDQpNaW5kIGl0IHRoYXQgeW91IGRvbid0IGNhdXNl
IGEgcmFjZSEgVGhlIGJpdCBjYW4gYmVjb21lIHNldA0KZHVyaW5nIHJlYWRpbmcgb2YgdGhlIGRh
dGEsIGl0IHNob3VsZCBiZSBjaGVjayBfYWZ0ZXJfIHdlDQpoYXZlIGEgY29weSBvZiB0aGUgbWFp
bGJveC4gWW91IGNhbiBkbyBhIGRvdWJsZSBjaGVjaywgb25lDQpiZWZvcmUgb25lIGFmdGVyLCBi
dXQgc2luY2UgdGhlcmUgc2hvdWxkIGJlIG5vIGZpZm8gb3ZlcmZsb3cNCmFueXdheSwgdGhlcmUg
aXMgbm8gcmVhc29uIHRvIG9wdGltaXplIGZvciB0aGF0IHBhdGguIChAMjUwaw0KSSBjYW5ub3Qg
Z2V0IG1vcmUgdGhlbiAzIG1lc3NhZ2VzIGluIHRoZSBmaWZvLi4uKS4NCg0KUmVnYXJkcywNCg0K
SmVyb2VuDQoNClsxXSANCmh0dHBzOi8vY29tbXVuaXR5Lm1lbGxhbm94LmNvbS9zL2FydGljbGUv
Y291bnRlcnMtdHJvdWJsZXNob290aW5nLWZvci1saW51eC1kcml2ZXIgDQoNCg==
