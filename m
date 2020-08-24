Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A443024F718
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 11:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgHXJIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 05:08:13 -0400
Received: from us-smtp-delivery-148.mimecast.com ([63.128.21.148]:55544 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728106AbgHXJHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 05:07:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1598260052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ac5btwFnOYCVsJKKKiyEdONLhz/TBDM9fKZTzFYZ0C8=;
        b=SRH2LMsZxguTA6ZqrkYCiQEW/x/Q9Ct+qDhAY5j3i3ylw4+a0KHNB2N8UAG3FPg8ZpZt0F
        1nflF3Mp4pRkOg4KDzs+pwD/F3lGxwIn9374BbSm/b5yg71l/u+08yi8OSfRW/TThpucIY
        e6clxKOEuyCWPNluFPr0cgDOYAqiMEA=
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-9hZigf4hNpCbjA4MRfBlaQ-1; Mon, 24 Aug 2020 05:07:28 -0400
X-MC-Unique: 9hZigf4hNpCbjA4MRfBlaQ-1
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 (2603:10b6:910:8a::27) by CY1PR04MB2139.namprd04.prod.outlook.com
 (2a01:111:e400:c617::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Mon, 24 Aug
 2020 09:07:26 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::e563:74ca:b05f:e468]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::e563:74ca:b05f:e468%7]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 09:07:26 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Sabrina Dubroca <sd@queasysnail.net>,
        Scott Dial <scott@scottdial.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ryan Cox <ryan_cox@byu.edu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "ebiggers@google.com" <ebiggers@google.com>
Subject: RE: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
Thread-Topic: Severe performance regression in "net: macsec: preserve ingress
 frame ordering"
Thread-Index: AQHWbxswXQv6N8/0LkqF3KAyUpB/cqkxgxcAgAK+soCAAAOeEIAAKFWAgBKXA/A=
Date:   Mon, 24 Aug 2020 09:07:26 +0000
Message-ID: <CY4PR0401MB365240B04FC43F7F8AAE6A0CC3560@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
 <a335c8eb-0450-1274-d1bf-3908dcd9b251@scottdial.com>
 <20200810133427.GB1128331@bistromath.localdomain>
 <7663cbb1-7a55-6986-7d5d-8fab55887a80@scottdial.com>
 <20200812100443.GF1128331@bistromath.localdomain>
 <CY4PR0401MB36524B348358B23A8DFB741AC3420@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20200812124201.GF2154440@lunn.ch>
In-Reply-To: <20200812124201.GF2154440@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [159.100.118.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08d882c1-791d-4dfb-2595-08d8480d1f1b
x-ms-traffictypediagnostic: CY1PR04MB2139:
x-microsoft-antispam-prvs: <CY1PR04MB2139D22FAAE88F20A1552CFDC3560@CY1PR04MB2139.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZOw4jah6X/4AvVnnPjeijbZ+7+KQtbdrgqwqmHjfowPVsT77/u18LvIEySy04VtUsCpOOaYsuXAlfOLVSK2tj5yNPphIR/9Gjc3Gn2nvR9RYnJybTD8NvEBdMc4DeHC5m3EEuDu+6vbux7LuAyjr9YDanktygaXlDkDSkvT3AMtUHO0deaFOtaaoOld4Oq6Rs6jE1Q+d3IVdjzECk4tSA+Fq4ODyrkWS3b+oZaO7ExK77k3x/XCrEKTso03V8E05bqIxUaoCAnrs8vbOYCdCpjL0+0vw+psb0ZlLVxmLK1epF/ODJI+R5LjD2JyLSWB2zNGaBGphdbkJOKrhpPpAMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR0401MB3652.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(136003)(39850400004)(66946007)(66556008)(7696005)(66446008)(71200400001)(478600001)(9686003)(52536014)(66476007)(33656002)(76116006)(55016002)(316002)(4326008)(5660300002)(64756008)(86362001)(83380400001)(8676002)(54906003)(8936002)(2906002)(26005)(6506007)(186003)(6916009)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vQ5ickXARVZDZ9Hbuu0eeKJkaJrPG+gWEGkeR7asbC/BtM1aZtWqMgIvUxug7lrvCx/zBDlhfe8LnI6oEAwhUc5vekUjofLA8Cz/mSA9YhCyMaauYDrQb0Ny4PNz60Rda4rJLfnWKmlC9n6+hT5MQdVQVYKsEJkFpBz4rETsR2WcnTPSLM7Haoh8udfWfoLjTUbIoVLnv/QFPR4nlzXf37LvBY1UNqDEJxAYfaXq0AYCxYBuziEJAruniYY5ZtkMMrnHyPjp0KRR4h0/DvZhOqgN3CX2luyhfWCF+ZNc+MOnpTzy+5Bei6ZIBqmFihMr1bUnhI3IsarW7rtOxkEmqMuuMBVewzG1etFHMVyLtlUDIHqAGRosjJC7oXoEtYLF4rva4n5WsZObWbylWcRZFa2qkIEPziCjjyr6+FcOCodTdjDFLIJFP7tSakYqFnoZOMXwHV9KqCBqVUcvRTCGyjYWsPj/I1RjOI8knLROlKbLWqghjGvvTDjDGLG93OtGvgJVxkKQ4WJ7s6wb7xp/igZLSBDiVYHaVebAN+uQcnrmdl6LQzkowGXJa6YzLFX0sKx/rxeVchpmxhr5fyiDFJLsbACoPvKbzV9gxLavczDm2N7nubpBJem3p27lDEF1xc0F9H+jjmgw9dx+AcJ5HQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR0401MB3652.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d882c1-791d-4dfb-2595-08d8480d1f1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 09:07:26.5483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YrGD8uz1zuV7ug0PQoaCbg6jrjQUNxszSAoOk3Oj62ys8L1rkKKdpMBAI2G5zWSPHv7YMiPrTBwySNM4YtLNKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR04MB2139
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA48A24 smtp.mailfrom=pvanleeuwen@rambus.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jcnlwdG8tb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBC
ZWhhbGYgT2YgQW5kcmV3IEx1bm4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgMTIsIDIwMjAg
Mjo0MiBQTQ0KPiBUbzogVmFuIExlZXV3ZW4sIFBhc2NhbCA8cHZhbmxlZXV3ZW5AcmFtYnVzLmNv
bT4NCj4gQ2M6IFNhYnJpbmEgRHVicm9jYSA8c2RAcXVlYXN5c25haWwubmV0PjsgU2NvdHQgRGlh
bCA8c2NvdHRAc2NvdHRkaWFsLmNvbT47IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IFJ5
YW4gQ294DQo+IDxyeWFuX2NveEBieXUuZWR1PjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsgQW50b2luZSBUZW5hcnQgPGFudG9pbmUudGVuYXJ0QGJvb3RsaW4u
Y29tPjsNCj4gZWJpZ2dlcnNAZ29vZ2xlLmNvbQ0KPiBTdWJqZWN0OiBSZTogU2V2ZXJlIHBlcmZv
cm1hbmNlIHJlZ3Jlc3Npb24gaW4gIm5ldDogbWFjc2VjOiBwcmVzZXJ2ZSBpbmdyZXNzIGZyYW1l
IG9yZGVyaW5nIg0KPg0KPiA8PDwgRXh0ZXJuYWwgRW1haWwgPj4+DQo+ID4gV2l0aCBuZXR3b3Jr
aW5nIHByb3RvY29scyB5b3Ugb2Z0ZW4gYWxzbyBoYXZlIGEgcmVxdWlyZW1lbnQgdG8gbWluaW1p
emUNCj4gPiBwYWNrZXQgcmVvcmRlcmluZywgc28gSSB1bmRlcnN0YW5kIGl0J3MgYSBjYXJlZnVs
IGJhbGFuY2UuIEJ1dCBpdCBpcyBwb3NzaWJsZQ0KPiA+IHRvIHNlcmlhbGl6ZSB0aGUgaW1wb3J0
YW50IHN0dWZmIGFuZCBzdGlsbCBkbyB0aGUgY3J5cHRvIG91dC1vZi1vcmRlciwgd2hpY2gNCj4g
PiB3b3VsZCBiZSByZWFsbHkgYmVuZWZpY2lhbCBvbiBfc29tZV8gcGxhdGZvcm1zICh3aGljaCBo
YXZlIEhXIGNyeXB0bw0KPiA+IGFjY2VsZXJhdGlvbiBidXQgbm8gc3VjaCBDUFUgZXh0ZW5zaW9u
cykgYXQgbGVhc3QuDQo+DQo+IE1hbnkgRXRoZXJuZXQgUEhZcyBhcmUgYWxzbyBjYXBhYmxlIG9m
IGRvaW5nIE1BQ1NlQyBhcyB0aGV5DQo+IHNlbmQvcmVjZWl2ZSBmcmFtZXMuIERvaW5nIGl0IGlu
IGhhcmR3YXJlIGluIHRoZSBQSFkgYXZvaWRzIGFsbCB0aGVzZQ0KPiBvdXQtb2Ytb3JkZXIgYW5k
IGxhdGVuY3kgaXNzdWVzLiBVbmZvcnR1bmF0ZWx5LCB3ZSBhcmUgc3RpbGwgYXQgdGhlDQo+IGVh
cmx5IGRheXMgZm9yIFBIWSBkcml2ZXJzIGFjdHVhbGx5IGltcGxlbWVudGluZyBNQUNTZUMgb2Zm
bG9hZC4gQXQNCj4gdGhlIG1vbWVudCBvbmx5IHRoZSBNaWNyb3NlbWkgUEhZIGFuZCBBcXVhbnRp
YSBQSFkgdmlhIGZpcm13YXJlIGluIHRoZQ0KPiBBdGxhbnRpYyBOSUMgc3VwcG9ydCB0aGlzLg0K
Pg0KTm8gbmVlZCB0byBwb2ludCB0aGlzIG91dCB0byBtZSBhcyB3ZSdyZSB0aGUgbnVtYmVyIG9u
ZSBzdXBwbGllciBvZiBpbmxpbmUgTUFDc2VjIElQIDotKQ0KSW4gZmFjdCwgdGhlIE1pY3Jvc2Vt
aSBQSFkgc29sdXRpb24geW91IG1lbnRpb24gaXMgb3VycywgbWFqb3IgcGFydHMgb2YgdGhhdCBk
ZXNpZ24gd2VyZQ0KZXZlbiBjcmVhdGVkIGJ5IHRoZXNlIDIgaGFuZHMgaGVyZS4gIEZ1bGwgcHJv
dG9jb2wgb2ZmbG9hZCBpcyBvYnZpb3VzbHkgdGhlIGhvbHkgZ3JhaWwgb2YgSFcNCmFjY2VsZXJh
dGlvbiwgYW5kIHdoYXQgd2UgdGVuZCB0byBzdHJpdmUgZm9yLiBUaGUgcHJvYmxlbSBpcyBhbHdh
eXMgd2l0aCB0aGUgc29mdHdhcmUNCmludGVncmF0aW9uLCBzbyBJJ20gaGFwcHkgdG8gc2VlIGEg
ZnJhbWV3b3JrIGZvciBpbmxpbmUgTUFDc2VjIGFjY2VsZXJhdGlvbiBiZWluZyBhZGRlZCB0bw0K
dGhlIGtlcm5lbC4NCg0KV2l0aG91dCBzdWNoIGEgcHJvdG9jb2wgYWNjZWxlcmF0aW9uIGZyYW1l
d29yayAod2hpY2ggQUZBSUsgZG9lc24ndCBleGlzdCBmb3IgSVBzZWMgeWV0LA0KYXQgbGVhc3Qg
bm90IGluIGEgZ2VuZXJpYyBmb3JtIHN1cHBvcnRpbmcgYWxsIG1vZGVzIGFuZCBjaXBoZXJzdWl0
ZXMpLCBob3dldmVyLCB5b3UgZmFsbA0KYmFjayB0byBiYXNpYyBoYXNoLWVuY3J5cHQvQUVBRCBv
ZmZsb2FkIGFzIHRoZSAiYmVzdCB5b3UgY2FuIGRvIi4gIEFuZCBzb21lIGxvdy1jb3N0DQpkZXZp
Y2VzIG1heSBzdGlsbCBkbyBpdCBvbiB0aGUgQ1BVIHRvIG1pbmltaXplIHNpbGljb24gY29zdC4g
U28gaXQgaXMgc3RpbGwgdmVyeSB1c2VmdWwgZm9yIHRoZQ0KY3J5cHRvIEFQSSBwYXRoIHRvIGJl
IGFzIGVmZmljaWVudCBhcyBwb3NzaWJsZSwgYXQgbGVhc3QgZm9yIHRoZSB0aW1lIGJlaW5nLg0K
DQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2VuDQpTaWxpY29uIElQIEFyY2hpdGVjdCBNdWx0
aS1Qcm90b2NvbCBFbmdpbmVzLCBSYW1idXMgU2VjdXJpdHkNClJhbWJ1cyBST1RXIEhvbGRpbmcg
QlYNCiszMS03MyA2NTgxOTUzDQoNCk5vdGU6IFRoZSBJbnNpZGUgU2VjdXJlL1ZlcmltYXRyaXgg
U2lsaWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRseSBhY3F1aXJlZCBieSBSYW1idXMuDQpQbGVhc2Ug
YmUgc28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1haWwgYWRkcmVzcyBib29rIHdpdGggbXkgbmV3
IGUtbWFpbCBhZGRyZXNzLg0KDQoNCioqIFRoaXMgbWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnRz
IGFyZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQocykuIEl0IG1h
eSBjb250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMgY29uZmlkZW50aWFsIGFuZCBwcml2aWxlZ2Vk
LiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IG9mIHRoaXMgbWVzc2FnZSwg
eW91IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRpbmcsIGNvcHlpbmcsIGZvcndhcmRpbmcgb3Ig
c2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBtZXNzYWdlIGFuZCBhdHRhY2htZW50cyBhbmQg
bm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkuICoqDQoNClJhbWJ1cyBJbmMuPGh0dHA6Ly93
d3cucmFtYnVzLmNvbT4NCg==

