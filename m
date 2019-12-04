Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD06E1128C0
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 10:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLDJ76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 04:59:58 -0500
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:25862
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726893AbfLDJ75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 04:59:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnKXrgLtBporKc0Del1YoBSmT2S2Vb1+CSyKA1m7t/i0XToRUX+VDJ40J/6LE0OTQle2/Z68tSvC3nm8Is74eXXiDYIclXWcfNAcHSQXQSpQlreMg1nGIUYd3K6uaiCChU9dScw2PMD/fsojx/bWKvLYf83kzK2kXqrqftOeGw531vrQcpNkqINF8ZvvgHJJdSodtCY3UglvBRUjPQ1wIbNRfqxJ0UDd02n86Wg0JzH9chhu8EtbmPa3V2Gnbhf8wVjeFpUa/Xlj+GD/JslQvpMYu8q+nd1YlcAz2FluG4gB0+HDdBICXQlLKUwLGm1X2cz7db2tU3T6yYdLffJFog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvVFlD2WKs+lkgIWsMz/VPSEFdxvsatRYBMcs+Lmsds=;
 b=D1+HxIHDfufpI6g5IPobJ/ko2ZjnFiB8aBVBd4cMbrgFUzHiUH89l4MT6+2kc6eGB8pF6DHoBDsMREj98uJ/ZVtcNEv/5mgYO1eZrC9WCaCDQ/eOGqmhjOP7F/eVOjNwS7Q+nvxT6ngau90Gg2v1bGh9YeFdCjkv4k82IDWQ1ukb1AZsa4ZMwEtwNuuQdi/Ps+BuLbAxzmFBX6u4CmbCkz3gGgdfwln7SpuGh2PHWlDqB0rpg5kWDctK8BjzKV/5YeWyYd3s9S6Y8D+xe3srhjp3sTEwcSvfUOfebYr5IwrWPFpztpzn7f+BUl39KJz837fNTOFA9LOP6lh3NQcEtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvVFlD2WKs+lkgIWsMz/VPSEFdxvsatRYBMcs+Lmsds=;
 b=q9fwuIvb5fgNSmkXQb/uyoDgdhEMj1wCbLg8wCSmAbXq6ps0MEYEUrNREHX8g7DojSPym/cLYFzKhA1sQLVN00aZab7gtGlcB1VohO0c+2vBfnzW3ap6JHQuUOWqFAIMEaHK7f/H1QKlTZcmG4tNUtWJz961tulCl2H70hzUJ3s=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4411.eurprd04.prod.outlook.com (52.135.136.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Wed, 4 Dec 2019 09:59:51 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 09:59:51 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Topic: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Index: AQHVpOd3D9txXS3dtUSMzmH9fMhQMaepvmsAgAAKqsA=
Date:   Wed, 4 Dec 2019 09:59:51 +0000
Message-ID: <DB7PR04MB46184177F22A1D958FA2B2FDE65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-5-qiangqing.zhang@nxp.com>
 <31323458-7807-3e7c-7689-19cb38a23647@pengutronix.de>
In-Reply-To: <31323458-7807-3e7c-7689-19cb38a23647@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3bf5eb95-0841-4d50-6e93-08d778a0b484
x-ms-traffictypediagnostic: DB7PR04MB4411:|DB7PR04MB4411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4411835FC9FDC59A839DCBAAE65D0@DB7PR04MB4411.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(189003)(199004)(54534003)(13464003)(53546011)(256004)(102836004)(11346002)(7736002)(446003)(6506007)(71190400001)(26005)(305945005)(7696005)(316002)(6246003)(186003)(76176011)(71200400001)(54906003)(9686003)(966005)(4326008)(478600001)(33656002)(99286004)(14444005)(2906002)(2501003)(52536014)(74316002)(14454004)(66476007)(64756008)(66446008)(25786009)(8676002)(66946007)(66556008)(3846002)(110136005)(8936002)(76116006)(81156014)(5660300002)(6306002)(6116002)(81166006)(86362001)(229853002)(2201001)(6436002)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4411;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1gzO1oRsyVfVZkpJw31SpK6Gf7PewrI3cHAe/EPcQJHOEshUmgOMKUp/jVEXUmh8z5D6P+mJUkMoA2TebKuq4CmAAqnGjNe1S0mLgdL3ErbFLM6xLMEaipYfNo6GtWbGn6yTRB2Cf/hvfQ7FjAorYvdhZ+W3kz+OMAnKrFjlYkwH+SKa1hwm/H+fw7ToKOm3dfuiyCTj9jkCdMfaExZax6HzAOKQPKlZv6UHnGuPg8D/TQY6kpO8vtaBns1B0IVCPRlIvuVYVUCapErbs0GCcpbl9vO9M5l2orOecimCirBUNbcjOe8qzz9OezOSZLxc4PvkBRf7WCLxf/eJEN1x8hQjI+mNG+oK0ureugiJkiw2+byEwqJh8ythrD4rVBJwMsI9JaQMWtTAeThfSAsFd8aCuBB6Obt+Ig+EvEc5rGfb+Pu+/m3+kvGDkgebv0801WcEu2dTZNMkNpECo4VIFFHG4CLLnR41dtqSfuXdo2u3QYF18+BzZYIn9FzyJsMcH2Jqovfbsa/bQ6xW/Yz+V8C77ETgY84g0FPlJ2zzJVJdmTvzjrGvprGcJUT5buSQ
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf5eb95-0841-4d50-6e93-08d778a0b484
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 09:59:51.3813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NxE6nyi5sbbyWmxq/3uQuOiNL4N8lAFmwxE6eZlHWK/uhz4BChoYq/ElXGiedESggrZoN4BOj5ojpkVZ99a2cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQxMuaciDTml6UgMTc6MjENCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBzZWFuQGdlYW5peC5j
b207DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggVjIgNC80XSBjYW46IGZsZXhjYW46IGFkZCBMUFNSIG1vZGUgc3VwcG9ydA0KPiANCj4g
T24gMTEvMjcvMTkgNjo1NiBBTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IEZvciBpLk1YN0Qg
TFBTUiBtb2RlLCB0aGUgY29udHJvbGxlciB3aWxsIGxvc3QgcG93ZXIgYW5kIGdvdCB0aGUNCj4g
PiBjb25maWd1cmF0aW9uIHN0YXRlIGxvc3QgYWZ0ZXIgc3lzdGVtIHJlc3VtZSBiYWNrLiAoY29t
aW5nIGkuTVg4UU0vUVhQDQo+ID4gd2lsbCBhbHNvIGNvbXBsZXRlbHkgcG93ZXIgb2ZmIHRoZSBk
b21haW4sIHRoZSBjb250cm9sbGVyIHN0YXRlIHdpbGwNCj4gPiBiZSBsb3N0IGFuZCBuZWVkcyBy
ZXN0b3JlKS4NCj4gPiBTbyB3ZSBuZWVkIHRvIHNldCBwaW5jdHJsIHN0YXRlIGFnYWluIGFuZCBy
ZS1zdGFydCBjaGlwIHRvIGRvDQo+ID4gcmUtY29uZmlndXJhdGlvbiBhZnRlciByZXN1bWUuDQo+
ID4NCj4gPiBGb3Igd2FrZXVwIGNhc2UsIGl0IHNob3VsZCBub3Qgc2V0IHBpbmN0cmwgdG8gc2xl
ZXAgc3RhdGUgYnkNCj4gPiBwaW5jdHJsX3BtX3NlbGVjdF9zbGVlcF9zdGF0ZS4NCj4gPiBGb3Ig
aW50ZXJmYWNlIGlzIG5vdCB1cCBiZWZvcmUgc3VzcGVuZCBjYXNlLCB3ZSBkb24ndCBuZWVkDQo+
ID4gcmUtY29uZmlndXJlIGFzIGl0IHdpbGwgYmUgY29uZmlndXJlZCBieSB1c2VyIGxhdGVyIGJ5
IGludGVyZmFjZSB1cC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4gLS0tLS0tDQo+ID4gQ2hhbmdlTG9nOg0KPiA+IAlW
MS0+VjI6IG5vIGNoYW5nZS4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4u
YyB8IDIxICsrKysrKysrKysrKysrLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTQgaW5z
ZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiA+IGluZGV4
IGQxNzgxNDZiM2RhNS4uZDE1MDljZmZkZDI0IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0
L2Nhbi9mbGV4Y2FuLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ID4g
QEAgLTI2LDYgKzI2LDcgQEANCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5o
Pg0KPiA+ICAjaW5jbHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGlu
dXgvcmVndWxhdG9yL2NvbnN1bWVyLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9waW5jdHJsL2Nv
bnN1bWVyLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9yZWdtYXAuaD4NCj4gPg0KPiA+ICAjZGVm
aW5lIERSVl9OQU1FCQkJImZsZXhjYW4iDQo+ID4gQEAgLTE3MDcsNyArMTcwOCw3IEBAIHN0YXRp
YyBpbnQgX19tYXliZV91bnVzZWQNCj4gZmxleGNhbl9zdXNwZW5kKHN0cnVjdA0KPiA+IGRldmlj
ZSAqZGV2aWNlKSAgew0KPiA+ICAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IGRldl9nZXRfZHJ2
ZGF0YShkZXZpY2UpOw0KPiA+ICAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9w
cml2KGRldik7DQo+ID4gLQlpbnQgZXJyID0gMDsNCj4gPiArCWludCBlcnI7DQo+ID4NCj4gPiAg
CWlmIChuZXRpZl9ydW5uaW5nKGRldikpIHsNCj4gPiAgCQkvKiBpZiB3YWtldXAgaXMgZW5hYmxl
ZCwgZW50ZXIgc3RvcCBtb2RlIEBAIC0xNzE5LDI1ICsxNzIwLDI3DQo+IEBADQo+ID4gc3RhdGlj
IGludCBfX21heWJlX3VudXNlZCBmbGV4Y2FuX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2aWNl
KQ0KPiA+ICAJCQlpZiAoZXJyKQ0KPiA+ICAJCQkJcmV0dXJuIGVycjsNCj4gPiAgCQl9IGVsc2Ug
ew0KPiA+IC0JCQllcnIgPSBmbGV4Y2FuX2NoaXBfZGlzYWJsZShwcml2KTsNCj4gPiArCQkJZmxl
eGNhbl9jaGlwX3N0b3AoZGV2KTsNCj4gDQo+IGNoaXBfc3RvcCBjYWxscyBjaGlwX2Rpc2FibGUs
IGJ1dCBkb2Vzbid0IHByb3BhZ2F0ZSB0aGUgZXJyb3IgdmFsdWUuDQo+IFBsZWFzZSBjcmVhdGUg
YSBzZXBlcmF0ZSBwYXRjaCB0byBwcm9wYWdhdGUgdGhlIGVycm9yIHZhbHVlIG9mIGNoaXBfc3Rv
cCgpLg0KDQpPa2F5LCBJIHdpbGwgZG8gaXQuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFu
Zw0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAgICAgICB8
IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVtYmVkZGVkIExpbnV4ICAgICAgICAg
ICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwNCj4gVmVydHJldHVuZyBX
ZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBB
bXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDogICArNDktNTEyMS0yMDY5MTct
NTU1NSB8DQoNCg==
