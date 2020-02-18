Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F30162774
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 14:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgBRNy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 08:54:59 -0500
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:40001
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726672AbgBRNy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 08:54:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzKlotCc7hrycVHqEJtnBbOAdEE/YZcuW6d/lu/XsqLpag3DP8QhqKyun00JnJSbJEA451HUGsJfKeeO5jSEMF5PY8wZxjKeq8VVJZLxaqoPqLkfVUmogSCujZ1NZxWmujFUFA8lAGqOY/87+KOMNXuAfFaqrwLJEi6aA1b5VLoeQn99yM+RIQBscgwEYJfstvjFglsTYXS/+CpOnA+pdUGTwxS6KcbaIqkcbrUOHjqmNe5EKzPEAW36cWWdt8dXwvKRRm9cU+3apDDXnHMJlh6IJFF5rPiuP+xRwboPDDaSJMR3q5Z7GmaR3DIZQhOSb3wzvxjGoSDVSmBYdXyBSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeOkzhel1C7tOYX4FjtVvD1/FCshjaH+bQ5wHtbcCRU=;
 b=bNBezPslbZJujgRuUdFWAORJjJls2LeITAeaJqXr/pM6nFCcWpYItqKvun+nESGXjdZSIwdsDdXafOfU667Oh4AQyjD+NQ8dsSElwMWbNKaO7we9Fk+KrENfe9ysp4MWuVmN24kiEA6sGgyTE11lbFIhxYkHzxE4pHB/vXbz1UT65i7quRarg0D+F80FFEgygsPCbIS/SmqPBB0FaMizMw2QTpX3xMkh1uIUlTEjioMbFPKdCDDfyJdLXnnnAfu1u/OVIrjYUbU8oisC6ADsqjsy1+KiDeJERJ/6VVCIgK4IBPMV9DuStxU6CdjM8Bwwcgu9lRLw4Kk6VOwX3pOxbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeOkzhel1C7tOYX4FjtVvD1/FCshjaH+bQ5wHtbcCRU=;
 b=TtFiSeM5k+IgxlD3ERfYD1Ln5Nyfp/Te/c35qXPTKOe+rMAjN7tXhQBMqyqBkXQaFRDFaiGdY6bW3+gccyQhjWatSshKRC12cCqX+KjcDLS9ig7se3u4rsl5WdQib9GnU7BQ5agcGl14ZbV8Ahpjdz5xCuMFsoKKp0Vx97fZQ4g=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3488.eurprd04.prod.outlook.com (52.134.8.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Tue, 18 Feb 2020 13:54:52 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::18c:4d15:c3ab:afa6]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::18c:4d15:c3ab:afa6%7]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 13:54:52 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH net-next] net: fec: Use a proper ID allocation
 scheme
Thread-Topic: [EXT] Re: [PATCH net-next] net: fec: Use a proper ID allocation
 scheme
Thread-Index: AQHV5h8UIR0p36NlJkiaMX6HnulgEKgggl2AgABu8wCAAAe5cA==
Date:   Tue, 18 Feb 2020 13:54:52 +0000
Message-ID: <VI1PR0402MB3600B90E7775C368E81B533DFF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20200217223651.22688-1-festevam@gmail.com>
 <20200217.214840.486235315714211732.davem@davemloft.net>
 <VI1PR0402MB3600C163FEFD846B1D5869B4FF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAOMZO5CWX9dhcg_v3LgPvK97yESAi_kS72e0=vjiB+-15C5J1g@mail.gmail.com>
In-Reply-To: <CAOMZO5CWX9dhcg_v3LgPvK97yESAi_kS72e0=vjiB+-15C5J1g@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 73d63960-e468-4662-c87e-08d7b47a20d8
x-ms-traffictypediagnostic: VI1PR0402MB3488:
x-microsoft-antispam-prvs: <VI1PR0402MB3488B6106C6EC31E8FD842B3FF110@VI1PR0402MB3488.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(199004)(189003)(8936002)(66946007)(66446008)(8676002)(4326008)(66556008)(76116006)(66476007)(33656002)(64756008)(81166006)(5660300002)(81156014)(9686003)(316002)(71200400001)(7696005)(2906002)(54906003)(6916009)(86362001)(53546011)(6506007)(26005)(52536014)(478600001)(186003)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3488;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VoESfQgxP7fsnOevtq/BXlonacJblkcHm7rDDOCiV8VjGjWunKb4wieWMZfe3TpI3TSO6eGj5/IsbbijaRGyKik2jqklj6ziEkxcDTf8HsfvOcyX6EsmG/k3cfEvlXem/gN+jNTI1LyOSxdpH8Y+a4R2UywSROu/I24yv1OZRInfByMbcbX9aP/bbsAhORgmb0RE5NhCUgOO4bis9mjKWdHrfVd+8rJ5U3J8/9P7fucVCedX0tQXraIGS+V6KLqNjbrNXcHyU6YjNSM+nfNjz18U6ALRWMWs0+HBvLmitpnTMiqeC+GMxV3OlR5vM2d027uLzmYU0DBFB9nXXro5Ba+tMh1AhL6KiQIjuqTDd8WQWoKmvDGoBpoILv6RRwUyfoqsxZVDo9r49v6LwE/3cL29bEFfvNHlYF+5ROWkw2r1ZiS8W4xsHzCaGlgMqLQi
x-ms-exchange-antispam-messagedata: RFh++6leGiWDB3lFylV+lrnAu/EnnLXTH7kjt3qtY9rDt8h9XuNtl5lPaj/HToJ5ERWIUKS5Ng/lZh8pfYbCLzSLVvzW0u7dnvNYnAf3PaQmmzgXSqWs+VrYIDkEzsUlhoFeOFehG+hULb4PxPGFJQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d63960-e468-4662-c87e-08d7b47a20d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 13:54:52.5232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WbyDC6uDgOgpRIeLDtAjMLR7i9nKg2SmuEZxLyjsR2USH7wrvRL+23Uk6Ki7i+Uljb3yoRZHvmqKPG+S2s9B/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3488
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPiBTZW50OiBUdWVzZGF5LCBG
ZWJydWFyeSAxOCwgMjAyMCA5OjI1IFBNDQo+IEhpIEFuZHksDQo+IA0KPiBPbiBUdWUsIEZlYiAx
OCwgMjAyMCBhdCAzOjUxIEFNIEFuZHkgRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4gd3JvdGU6
DQo+IA0KPiA+ID4gV2hhdCBhYm91dDoNCj4gPiA+DQo+ID4gPiAxKSB1bmJpbmQgZmVjMA0KPiA+
ID4gMikgdW5iaW5kIGZlYzENCj4gPiA+IDMpIGJpbmQgZmVjMA0KPiA+ID4NCj4gPiA+IEl0IGRv
ZXNuJ3Qgd29yayBldmVuIHdpdGggdGhlIElEUiBzY2hlbWUuDQo+ID4NCj4gPiBOb3Qgb25seSBz
dWNoIGNhc2UsIGluc3RhbmNlI0EgKG1heWJlIGZlYzAgb3IgZmVjMSkgZGVwZW5kcyBvbg0KPiA+
IGluc3RhbmNlI0IgKG1heWJlIGZlYzEgb3IgZmVjMCksIFVuYmluZCBpbnN0YW5jZSNCIGZpcnN0
bHkgaGFzIHByb2JsZW0uDQo+ID4gQmluZCBpbnN0YW5jZSNBIGZpcnN0bHkgYWxzbyBoYXMgcHJv
YmxlbS4NCj4gDQo+IFllcywgSSBkbyBzZWUgdGhlIGVycm9yIG5vdyB3aXRoIHRoZSBzZXF1ZW5j
ZSBzdWdnZXN0ZWQgYnkgRGF2aWQuDQo+IA0KPiBJIGhhdmUgYWxzbyBub3RpY2VkIGluIHRoZSBm
ZWNfbWFpbi5jIGNvbW1lbnRzOg0KPiANCj4gLyoNCj4gKiBUaGUgaS5NWDI4IGR1YWwgZmVjIGlu
dGVyZmFjZXMgYXJlIG5vdCBlcXVhbC4NCj4gKiBIZXJlIGFyZSB0aGUgZGlmZmVyZW5jZXM6DQo+
ICoNCj4gKiAgLSBmZWMwIHN1cHBvcnRzIE1JSSAmIFJNSUkgbW9kZXMgd2hpbGUgZmVjMSBvbmx5
IHN1cHBvcnRzIFJNSUkNCj4gKiAgLSBmZWMwIGFjdHMgYXMgdGhlIDE1ODggdGltZSBtYXN0ZXIg
d2hpbGUgZmVjMSBpcyBzbGF2ZQ0KPiAqICAtIGV4dGVybmFsIHBoeXMgY2FuIG9ubHkgYmUgY29u
ZmlndXJlZCBieSBmZWMwDQo+ICoNCj4gKiBUaGF0IGlzIHRvIHNheSBmZWMxIGNhbiBub3Qgd29y
ayBpbmRlcGVuZGVudGx5LiBJdCBvbmx5IHdvcmtzDQo+ICogd2hlbiBmZWMwIGlzIHdvcmtpbmcu
IFRoZSByZWFzb24gYmVoaW5kIHRoaXMgZGVzaWduIGlzIHRoYXQgdGhlDQo+ICogc2Vjb25kIGlu
dGVyZmFjZSBpcyBhZGRlZCBwcmltYXJpbHkgZm9yIFN3aXRjaCBtb2RlLg0KPiAqDQo+ICogQmVj
YXVzZSBvZiB0aGUgbGFzdCBwb2ludCBhYm92ZSwgYm90aCBwaHlzIGFyZSBhdHRhY2hlZCBvbiBm
ZWMwDQo+ICogbWRpbyBpbnRlcmZhY2UgaW4gYm9hcmQgZGVzaWduLCBhbmQgbmVlZCB0byBiZSBj
b25maWd1cmVkIGJ5DQo+ICogZmVjMCBtaWlfYnVzLg0KPiAqLw0KPiANCj4gU2hvdWxkIHdlIHBy
ZXZlbnQgdW5iaW5kIG9wZXJhdGlvbiBmcm9tIHRoaXMgZHJpdmVyIGxpa2UgdGhpcz8NCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0K
PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+IGluZGV4IDQ0
MzJhNTk5MDRjNy4uMWQzNDhjNWQwNzk0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9m
cmVlc2NhbGUvZmVjX21haW4uYw0KPiBAQCAtMzc5Myw2ICszNzkzLDcgQEAgc3RhdGljIHN0cnVj
dCBwbGF0Zm9ybV9kcml2ZXIgZmVjX2RyaXZlciA9IHsNCj4gICAgICAgICAgICAgICAgIC5uYW1l
ICAgPSBEUklWRVJfTkFNRSwNCj4gICAgICAgICAgICAgICAgIC5wbSAgICAgPSAmZmVjX3BtX29w
cywNCj4gICAgICAgICAgICAgICAgIC5vZl9tYXRjaF90YWJsZSA9IGZlY19kdF9pZHMsDQo+ICsg
ICAgICAgICAgICAgICAuc3VwcHJlc3NfYmluZF9hdHRycyA9IHRydWUNCj4gICAgICAgICB9LA0K
PiAgICAgICAgIC5pZF90YWJsZSA9IGZlY19kZXZ0eXBlLA0KPiAgICAgICAgIC5wcm9iZSAgPSBm
ZWNfcHJvYmUsDQo+IA0KPiBQbGVhc2UgYWR2aXNlLg0KPiANCj4gVGhhbmtzDQoNCkZvciBpbXg2
c2wvaW14OG1wL2lteDhtbS9pbXg4bW4sIHNvYyBvbmx5IGhhcyBvbmUgaW5zdGFuY2UsIGJpbmQg
b3BlcmF0aW9uDQppcyBzdXBwb3J0ZWQgYW5kIGhhcyBubyBwcm9ibGVtLg0KDQpSZWdhcmRzLA0K
QW5keQ0K
