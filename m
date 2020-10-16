Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7302628FE83
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 08:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392031AbgJPGtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 02:49:52 -0400
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:56385
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732446AbgJPGtw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 02:49:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AT6ukXBnhwke2NOprQRN9crMA8nUoinneNRSm/lUvi+hJ7HNTwZz5rLTCh2cby8hPwzpSnJKqoWccO7MOWsxSb5wqx6Raps5bWLhP+CmDwEw7fBarp+gGlkyq/VflpXYSHNIREZ0ZzGP3HGdGC9klccAiN+xdmxjbE769xWDnaKBAe/sauFNoHm2dK77cLa6RzdaiYQjfgy0lYZvLDtwPbDfAwWYtHM5EEeFG5jXzXaP7Tz6RmzvidaoTUZ3oR7JtbZvODgdyo+31+0HWAzwnqUljdN4S0kGnWAOqTnBWHD7bqLam1xIB2PrtOHxA826GS4Tr55RWwJzV3jLXIHuYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxGLqUuTvCUYpAe+2rCtBm7BONTkC3hHq1VbPxkxyKo=;
 b=WGqPDWRCWBB+D4jTmia7PClnkjblbiVVWYFKVmejhWFILV9kGo3OIzUo8xGkgZYfy8nd2DnpbFWYEk6/jeNPWBcaKaYbCk6x4/Lb+/ITn7mPXRTxlvZXCWgZ0dAuULcUAq9UoFHSAymKQW92Kyeqznc/aviz59MKBs+Ci4CsZURLd0mbmF2rqmyWaDT1yzH+O8zCqNp65DXeC1Xj1ZxG/FTTnYCCmmHF8qhfunopnPU6rg+I3iCKJ7Fc8yrAd5rP8ggPHituUUR8EHUPn+kBggBdeib1mMZD8TreGb8JduD6eJXyjFC8/CTxPlUpGgY7nrXJo25zoHQA6dXkXDAc2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxGLqUuTvCUYpAe+2rCtBm7BONTkC3hHq1VbPxkxyKo=;
 b=RPNazc0SYxMsOKHp0mlkQt4D3qQJvGuTK+V2eOcu+Qo4HFCtqpMlJsG5vAFMcOClCC1+dqSQNjiekM98Tw1zfeYbmi+GbaeZIIIXL8sQddTpKIHlKR89XCo2CH5O24Nfm1uskxEfJLA3hT7ugHr6nYK5v9L75ilLPQcKAU5GSeo=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2725.eurprd04.prod.outlook.com (2603:10a6:4:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 06:49:42 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 06:49:42 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 6/6] can: flexcan: fix ECC function on LS1021A/LX2160A
Thread-Topic: [PATCH 6/6] can: flexcan: fix ECC function on LS1021A/LX2160A
Thread-Index: AQHWo39DUYQntMreCkyBIBnNfeboTKmZvYUAgAAJDPA=
Date:   Fri, 16 Oct 2020 06:49:42 +0000
Message-ID: <DB8PR04MB67952876A98761963BBB84F2E6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
 <20201016134320.20321-7-qiangqing.zhang@nxp.com>
 <17678245-34fb-face-92ed-f32cd7423053@pengutronix.de>
In-Reply-To: <17678245-34fb-face-92ed-f32cd7423053@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c5d6ff96-80fb-4b87-ea00-08d8719fa91e
x-ms-traffictypediagnostic: DB6PR0402MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB27258E6389FD90F3530B492FE6030@DB6PR0402MB2725.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mH3JP2uAchZmPMVrBH/UT3cQeaGsZKaFKwCfTSnz5Gye/Ra66fPnF32S5B7Ao3UpqSaP4Zgr6xTd9iIO9YVKjd4debp+RwdAj+3oiZzIg8Pp2dj+ZHm50+cA1OZ7MFRI9peMhzSmgDDd4RQ+Tru0/T/IBxesbd3Otnl5jWjTd+o1pssc/9zPMQDe35YlZXFy+82Iw6NI2hbxHUIbKRL+bGC+4clrugdYKIjd4XcG6ajobJepJqkuOL8lb9m2fEZJMFx2G2zuA7Us87qCCWCpeeFDiftz6Q9h3IHCsVa37sB6kxlAntL0c1xXZkkvhx6ep1YOY4lNIdXRw4J/AXRW+539QPRxicLWi4hfSbJVAGqu9L6BKEncG6h+i+4EBplilgOATL8Yg7mfdFDZ7TLgYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(76116006)(8936002)(71200400001)(966005)(66446008)(478600001)(64756008)(33656002)(7696005)(54906003)(2906002)(110136005)(66556008)(4326008)(5660300002)(66946007)(66476007)(6506007)(316002)(53546011)(9686003)(52536014)(26005)(55016002)(186003)(86362001)(8676002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: L7k7ikpD0ZWvBNZjuVVe9VRLVvSKdCEFL/zTtO57Z0ZhaTcOBm0eOFvw7+Bb5FtNvZE9RcYvUng8L1k+B/TW8XsbG1FLxJSLfuyF3Rntd5V+hcw7OjdF6AIy/9qQwRb3QV9Baug5t4ONSFRUjxzPP+mo0nfVScYcVYTO36LCZwjeSyYMQOK/hUNxJnr85EFH9Yp6bXnxUjl/5hhJGXqGzLgMiLlyR4belVeShTA68vB89AJWltLtpikFTV8PY13un3JL2hEnAObqzuN3yVkLQYMAFo6BEUXWypXonVB+vJrmiydWwH974L7ouCN7XR90hRGlciLsNZEItPYwu75xBCAyFX/1jsx4H/Bmytn+DcuwWzV+yed9Gdc8NbOXXor4M+CbQCVuY43NEl69zlnBojn+GdiPdsQ9EMrv6YUF0FJQTn4NLIggACPfnhp1+BivIHZcBuTPBX9Kr6v0i2nrl3iTlZaXIfMNCDl0fQZmZ9rMCyEF/IcWW/nVk7dqhYezYGMTzNftl5VnRnqoCOX6lZF0ZFQZHy7OT34Mw+HzqhevO4o6ue/WlWrNWm5c0lzI2nu5cZECs+7L5LfCDDLww4ge7xS8u1g4189kpuAvs7bwNePPRwQhtWDiGxm8zrlvAe3TZBwVSG8IcmLuWHXlaA==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d6ff96-80fb-4b87-ea00-08d8719fa91e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 06:49:42.3252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zm5mOxE3JPCJ0sE5+JrDYXS61oIDDlWmk2iB/CkJix8gQ4OzQBodfekVWmB8vJbl6wIjnRVZCtq1c25mus26ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIEts
ZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiAyMDIwxOoxMNTCMTbI1SAx
NDowNQ0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IHJvYmgr
ZHRAa2VybmVsLm9yZzsNCj4gc2hhd25ndW9Aa2VybmVsLm9yZzsgcy5oYXVlckBwZW5ndXRyb25p
eC5kZQ0KPiBDYzoga2VybmVsQHBlbmd1dHJvbml4LmRlOyBkbC1saW51eC1pbXggPGxpbnV4LWlt
eEBueHAuY29tPjsgWWluZyBMaXUNCj4gPHZpY3Rvci5saXVAbnhwLmNvbT47IFBlbmcgRmFuIDxw
ZW5nLmZhbkBueHAuY29tPjsNCj4gbGludXgtY2FuQHZnZXIua2VybmVsLm9yZzsgUGFua2FqIEJh
bnNhbCA8cGFua2FqLmJhbnNhbEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
ZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCA2LzZdIGNhbjogZmxleGNhbjogZml4IEVDQyBmdW5j
dGlvbiBvbiBMUzEwMjFBL0xYMjE2MEENCj4gDQo+IE9uIDEwLzE2LzIwIDM6NDMgUE0sIEpvYWtp
bSBaaGFuZyB3cm90ZToNCj4gPiBBZnRlciBkb3VibGUgY2hlY2sgd2l0aCBMYXllcnNjYXBlIENB
TiBvd25lciAoUGFua2FqIEJhbnNhbCksIGNvbmZpcm0NCj4gPiB0aGF0IExTMTAyMUEgZG9lc24n
dCBzdXBwb3J0IEVDQywgYW5kIExYMjE2MEEgaW5kZWVkIHN1cHBvcnRzIEVDQy4NCj4gPg0KPiA+
IEZvciBTb0NzIHdpdGggRUNDIHN1cHBvcnRlZCwgZXZlbiB1c2UgRkxFWENBTl9RVUlSS19ESVNB
QkxFX01FQ1INCj4gcXVpcmsNCj4gPiB0byBkaXNhYmxlIG5vbi1jb3JyZWN0YWJsZSBlcnJvcnMg
aW50ZXJydXB0IGFuZCBmcmVlemUgbW9kZSwgaGFkDQo+ID4gYmV0dGVyIHVzZSBGTEVYQ0FOX1FV
SVJLX1NVUFBPUlRfRUNDIHF1aXJrIHRvIGluaXRpYWxpemUgYWxsIG1lbW9yeS4NCj4gPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+
ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCAxMCArKysrKy0tLS0tDQo+
ID4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyBiL2RyaXZlcnMvbmV0
L2Nhbi9mbGV4Y2FuLmMNCj4gPiBpbmRleCBhNTVlYThmMjdmN2MuLjdiMGViNjA4ZmM5ZCAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ID4gKysrIGIvZHJpdmVy
cy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiA+IEBAIC0yMTksNyArMjE5LDcgQEANCj4gPiAgICogICBN
WDhNUCBGbGV4Q0FOMyAgMDMuMDAuMTcuMDEgICAgeWVzICAgICAgIHllcyAgICAgICAgbm8NCj4g
eWVzICAgICAgIHllcyAgICAgICAgICB5ZXMNCj4gPiAgICogICBWRjYxMCBGbGV4Q0FOMyAgPyAg
ICAgICAgICAgICAgIG5vICAgICAgIHllcyAgICAgICAgbm8NCj4geWVzICAgICAgIHllcz8gICAg
ICAgICAgbm8NCj4gPiAgICogTFMxMDIxQSBGbGV4Q0FOMiAgMDMuMDAuMDQuMDAgICAgIG5vICAg
ICAgIHllcyAgICAgICAgbm8NCj4gbm8gICAgICAgeWVzICAgICAgICAgICBubw0KPiA+IC0gKiBM
WDIxNjBBIEZsZXhDQU4zICAwMy4wMC4yMy4wMCAgICAgbm8gICAgICAgeWVzICAgICAgICBubw0K
PiBubyAgICAgICB5ZXMgICAgICAgICAgeWVzDQo+ID4gKyAqIExYMjE2MEEgRmxleENBTjMgIDAz
LjAwLjIzLjAwICAgICBubyAgICAgICB5ZXMgICAgICAgIG5vDQo+IHllcyAgICAgICB5ZXMgICAg
ICAgICAgeWVzDQo+ID4gICAqDQo+ID4gICAqIFNvbWUgU09DcyBkbyBub3QgaGF2ZSB0aGUgUlhf
V0FSTiAmIFRYX1dBUk4gaW50ZXJydXB0IGxpbmUNCj4gY29ubmVjdGVkLg0KPiA+ICAgKi8NCj4g
PiBAQCAtNDA4LDE5ICs0MDgsMTkgQEAgc3RhdGljIHN0cnVjdCBmbGV4Y2FuX2RldnR5cGVfZGF0
YQ0KPiA+IGZzbF9pbXg4bXBfZGV2dHlwZV9kYXRhID0geyAgc3RhdGljIGNvbnN0IHN0cnVjdCBm
bGV4Y2FuX2RldnR5cGVfZGF0YQ0KPiBmc2xfdmY2MTBfZGV2dHlwZV9kYXRhID0gew0KPiA+ICAJ
LnF1aXJrcyA9IEZMRVhDQU5fUVVJUktfRElTQUJMRV9SWEZHIHwNCj4gRkxFWENBTl9RVUlSS19F
TkFCTEVfRUFDRU5fUlJTIHwNCj4gPiAgCQlGTEVYQ0FOX1FVSVJLX0RJU0FCTEVfTUVDUiB8DQo+
IEZMRVhDQU5fUVVJUktfVVNFX09GRl9USU1FU1RBTVAgfA0KPiA+IC0JCUZMRVhDQU5fUVVJUktf
QlJPS0VOX1BFUlJfU1RBVEUsDQo+ID4gKwkJRkxFWENBTl9RVUlSS19CUk9LRU5fUEVSUl9TVEFU
RSB8DQo+IEZMRVhDQU5fUVVJUktfU1VQUE9SVF9FQ0MsDQo+IA0KPiBZb3UgYWRkIHRoZSBtaXNz
aW5nIEVDQyBpbml0IGZvciB2ZjYxMCwgYnV0IGRvbid0IG1lbnRpb24gaXQgaW4gdGhlIHBhdGNo
IHN1YmplY3QNCj4gbm9yIGRlc2NyaXB0aW9uLiBQbGVhc2UgbWFrZSB0aGlzIGEgc2VwZXJhdGUg
cGF0Y2ggYW5kIGFkZCBhIEZpeGVzOiBsaW5lLg0KT0suDQoNCj4gPiAgfTsNCj4gPg0KPiA+ICBz
dGF0aWMgY29uc3Qgc3RydWN0IGZsZXhjYW5fZGV2dHlwZV9kYXRhIGZzbF9sczEwMjFhX3IyX2Rl
dnR5cGVfZGF0YSA9IHsNCj4gPiAgCS5xdWlya3MgPSBGTEVYQ0FOX1FVSVJLX0RJU0FCTEVfUlhG
RyB8DQo+IEZMRVhDQU5fUVVJUktfRU5BQkxFX0VBQ0VOX1JSUyB8DQo+ID4gLQkJRkxFWENBTl9R
VUlSS19ESVNBQkxFX01FQ1IgfA0KPiBGTEVYQ0FOX1FVSVJLX0JST0tFTl9QRVJSX1NUQVRFIHwN
Cj4gPiAtCQlGTEVYQ0FOX1FVSVJLX1VTRV9PRkZfVElNRVNUQU1QLA0KPiA+ICsJCUZMRVhDQU5f
UVVJUktfQlJPS0VOX1BFUlJfU1RBVEUgfA0KPiBGTEVYQ0FOX1FVSVJLX1VTRV9PRkZfVElNRVNU
QU1QLA0KPiA+ICB9Ow0KPiANCj4gUGxlYXNlIG1ha2UgdGhpcyBhIHNlcGVyYXRlIHBhdGNoLCB0
b28sIGFsb25nIHdpdGggdGhlIEZpeGVzIGxpbmUuDQpPSy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9h
a2ltIFpoYW5nDQo+ID4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmxleGNhbl9kZXZ0eXBlX2RhdGEg
ZnNsX2x4MjE2MGFfcjFfZGV2dHlwZV9kYXRhID0gew0KPiA+ICAJLnF1aXJrcyA9IEZMRVhDQU5f
UVVJUktfRElTQUJMRV9SWEZHIHwNCj4gRkxFWENBTl9RVUlSS19FTkFCTEVfRUFDRU5fUlJTIHwN
Cj4gPiAgCQlGTEVYQ0FOX1FVSVJLX0RJU0FCTEVfTUVDUiB8DQo+IEZMRVhDQU5fUVVJUktfQlJP
S0VOX1BFUlJfU1RBVEUgfA0KPiA+IC0JCUZMRVhDQU5fUVVJUktfVVNFX09GRl9USU1FU1RBTVAg
fA0KPiBGTEVYQ0FOX1FVSVJLX1NVUFBPUlRfRkQsDQo+ID4gKwkJRkxFWENBTl9RVUlSS19VU0Vf
T0ZGX1RJTUVTVEFNUCB8DQo+IEZMRVhDQU5fUVVJUktfU1VQUE9SVF9GRCB8DQo+ID4gKwkJRkxF
WENBTl9RVUlSS19TVVBQT1JUX0VDQywNCj4gPiAgfTsNCj4gPg0KPiA+ICBzdGF0aWMgY29uc3Qg
c3RydWN0IGNhbl9iaXR0aW1pbmdfY29uc3QgZmxleGNhbl9iaXR0aW1pbmdfY29uc3QgPSB7DQo+
ID4NCj4gDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAgICAgICB8IE1h
cmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVtYmVkZGVkIExpbnV4ICAgICAgICAgICAg
ICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwNCj4gVmVydHJldHVuZyBXZXN0
L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBBbXRz
Z2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1
NSB8DQoNCg==
