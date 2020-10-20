Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974EB293927
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393155AbgJTK3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:29:39 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:61505
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388927AbgJTK3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 06:29:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMwMdlvapABDBWR2DypLggv8hj6NhFYhVY57M2WsnyJxl4cEba5FpFonYfx4yN6v2E9qknvxYw8fpFL0MJ0rOPZGYXBNFLEXDGJDn1zqesg7brWIWv80Lx8tFGgS6L0HnOPppUZPcFbUVaqzwK3xkw0x5ANfkqBlVpudIGjpZgKv4mXMQbamAzsr4bZruCsf/Wc2j//f17mMkcPP6XZwgsvAbEZ/QLhEvdAvwToFzfxYKiYpzNbTR5sNyu0wynjdsAWn46tI9WrDbA0BfSUbv57mXW1Uf2CuJvEulkD0G4UjibzvZ5jeeefJqM1qWZLXZGw01BxE5Q1rAcMUV5z4Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsLRvOO1wBfVjmyGo/NdKwM2xLKfgp6XxBNCxYat+CA=;
 b=aq8Ufl0TOdY+xgJZe4V2TW81/Px2+6MUi8Tb6OvByhlJVZINnk3IoFM/keu0cyQd3PJytdf34M0t5Veue/1ugCB5tUhNE5Owv84qJZ5IxPklrOy60A4M8cuCpDcBa8H8T4Q0GjqFd/inSRQJIzabOT+QYXNvoUDqhNJDraE8VF0r9P2ss6lVvgXMGujkTfHZBVwIHfT0iD7fqecOv5EguzdGFJ9mDYbtW9HbN3VjsPmBFztUqfFNcgaUcaMlAeyajAZ98viGjhccvuHdLvAGNLtU/OqedUr7EGJxHcRIYe8JNALIZQBVzCXnfuav6J0iBQUqq93IF3bMb9W1fPM+Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsLRvOO1wBfVjmyGo/NdKwM2xLKfgp6XxBNCxYat+CA=;
 b=MObm/IfW8cJ2CcthGezQlCumGgWuZ+EttwzlkJd0P9AjrvqpRwNLthsOWaPwF1owBlnZZ35heGOuP5vRJIVC4I0YjMfxxn5+8JwLM3zqEfqGyufq2zSNesZc7Rfv5c5VIhxkC5FkhH/mc9t1PtSpGHF441BqZ3uWGLdtvhVFtkU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3206.eurprd04.prod.outlook.com (2603:10a6:6:d::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.25; Tue, 20 Oct 2020 10:29:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 10:29:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3 06/10] can: flexcan: disable wakeup in flexcan_remove()
Thread-Topic: [PATCH V3 06/10] can: flexcan: disable wakeup in
 flexcan_remove()
Thread-Index: AQHWprY9cR7f3d0oi0qrc1aRv609RamgOhcAgAAPDeA=
Date:   Tue, 20 Oct 2020 10:29:35 +0000
Message-ID: <DB8PR04MB6795126625F3AE3B9BFBC9EBE61F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
 <20201020155402.30318-7-qiangqing.zhang@nxp.com>
 <c5a5a84a-1ed0-5413-d909-074d8ad6b102@pengutronix.de>
In-Reply-To: <c5a5a84a-1ed0-5413-d909-074d8ad6b102@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2d4a4cba-5a61-4b02-4ddd-08d874e30a43
x-ms-traffictypediagnostic: DB6PR04MB3206:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB32061264B7E6A3F4C3FFBC01E61F0@DB6PR04MB3206.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u31VOfavoqIeNJRYnJfWAfCZqhVXWVeJGUN1YfFkX0+qDMBHBoXXglb4BrYhQrulXZuea80HIoQTlB4sqHT/SQR4+NVKQkJYPyrPYqWogLfIUKMViuFTCfIUBFWM8GS+YTm2e6EnUe250XCiSrBe4zTkSVr1LeqmdUBv6zN1t9QWaO7U361xd1UuvV5V0jHQxuuVH28C+lNHzw5bEeuwi2+6zKwt5lhxzL8Eblr4DZx/IvWcZ6MPmZd+IDwx+KKq6JcbIXT4ZaAT3Q5JMRMhfLO26XnCkXLd7RhvD9ov/MJ18DkfPFR75UJVVeA4Ha7K1c3MZzf1S+55usSy/+pDDf8GH+lP378yP4rQY0m5rqEqu/e68XR/7b9cydqDdnUa1uGQ31moUbF/HWZ3Wr/+xQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(64756008)(66946007)(66446008)(5660300002)(33656002)(966005)(4326008)(26005)(186003)(6506007)(2906002)(478600001)(53546011)(8936002)(110136005)(76116006)(66556008)(66476007)(86362001)(9686003)(8676002)(83380400001)(54906003)(7696005)(52536014)(316002)(71200400001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9Htmgr4tosjm9MduUaxEiMFFmONA6qmNB2mwq+/eCaeZhjqeVN0Wyabw48IxMfmhUoQyPxDmpqCi5SvJMFEui/f07nIiETZ9Mf+8eCgCNPBILElyjXiaDInsS0llGnI17TL0e8za9TbrxrOa3dGvoS45G1CbQhMrZWhlRIypihUVxVpI2i5OSbZWlEtk+P13iStErRCButoNbaYtZMWBT5VRgL+rQnkCHVhkjw3Prsi4v+fclyqnzhDlm9dTQZAq5p93mA6wS3v7DL3+pgSn5+OS5ryVQu41KBQErbMAambBSMl9ZqNcj9lDVZuBkGyqXgqJQF5VESDqZHJDW3wWlUNzMlwI6v2hV3qiVtFU7rfv/vzXFAFUmdkMa6Sm1hF9sj7WCafR+fArGga4nULriHBR6MdtYR/oA8L45HOR4G75iU8/RwWkn36q2S8MvFIVrcXvT35zEwaYnjyvUn1xXrKxIULB0RZimYpuk6fqVfnNwNmTpG3iL177fYW3kb3wztVuGq7hZjRUu1a/BcsGnlGpb6CzvWz6UUmspOmENASg7UwmYcnTeqWBTONEWTOR1uIZW4XP83OHUczNt/dJgXN1QIXQu49SuCEzo2wYPxPztgGIWdh3RYkCZietTvq/KPwXYW/ugHaJWISdxSVqPg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4a4cba-5a61-4b02-4ddd-08d874e30a43
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 10:29:35.0271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ResRJMYNajAqP8p/HAYYu8GBk7Ic1WPHlPmLhRa/iCF4S/8F9h+H8ae08J/PI0xqYe62Be+7jeYe8KWH/T4ijg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMg
S2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQxMOaciDIw
5pelIDE3OjMxDQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsg
cm9iaCtkdEBrZXJuZWwub3JnOw0KPiBzaGF3bmd1b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1
dHJvbml4LmRlDQo+IENjOiBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBZaW5nIExpdQ0KPiA8dmljdG9yLmxpdUBueHAuY29tPjsgbGludXgt
Y2FuQHZnZXIua2VybmVsLm9yZzsgUGFua2FqIEJhbnNhbA0KPiA8cGFua2FqLmJhbnNhbEBueHAu
Y29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYzIDA2LzEwXSBjYW46IGZsZXhjYW46IGRpc2Fi
bGUgd2FrZXVwIGluIGZsZXhjYW5fcmVtb3ZlKCkNCj4gDQo+IE9uIDEwLzIwLzIwIDU6NTMgUE0s
IEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBEaXNhYmxlIHdha2V1cCBpbiBmbGV4Y2FuX3JlbW92
ZSgpLg0KPiANCj4gVGhlIHBhdGNoIGxvb2tzIGdvb2QsIHBsZWFzZSBleHBsYWluIHdoeSB0aGlz
IGlzIG5lZWRlZC4NCg0KT2theSwgQ2FuIEkgcmVzZW5kIHRoaXMgcGF0Y2ggaW5kaXZpZHVhbGx5
Pw0KDQpKb2FraW0NCj4gTWFyYw0KPiANCj4gPg0KPiA+IEZpeGVzOiBkZTM1NzhjMTk4YzYgKCJj
YW46IGZsZXhjYW46IGFkZCBzZWxmIHdha2V1cCBzdXBwb3J0IikNCj4gPiBGaXhlczogOTE1Zjk2
NjY0MjFjICgiY2FuOiBmbGV4Y2FuOiBhZGQgc3VwcG9ydCBmb3IgRFQgcHJvcGVydHkNCj4gPiAn
d2FrZXVwLXNvdXJjZSciKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdx
aW5nLnpoYW5nQG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2Fu
LmMgfCAyICsrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2Fu
L2ZsZXhjYW4uYw0KPiA+IGluZGV4IDA2Zjk0YjZmMGViZS4uODgxNzk5YmQ5YzVlIDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gPiArKysgYi9kcml2ZXJzL25l
dC9jYW4vZmxleGNhbi5jDQo+ID4gQEAgLTIwNjIsNiArMjA2Miw4IEBAIHN0YXRpYyBpbnQgZmxl
eGNhbl9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiA+ICpwZGV2KSAgew0KPiA+ICAJ
c3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOw0KPiA+
DQo+ID4gKwlkZXZpY2Vfc2V0X3dha2V1cF9lbmFibGUoJnBkZXYtPmRldiwgZmFsc2UpOw0KPiA+
ICsJZGV2aWNlX3NldF93YWtldXBfY2FwYWJsZSgmcGRldi0+ZGV2LCBmYWxzZSk7DQo+ID4gIAl1
bnJlZ2lzdGVyX2ZsZXhjYW5kZXYoZGV2KTsNCj4gPiAgCXBtX3J1bnRpbWVfZGlzYWJsZSgmcGRl
di0+ZGV2KTsNCj4gPiAgCWZyZWVfY2FuZGV2KGRldik7DQo+ID4NCj4gDQo+IA0KPiAtLQ0KPiBQ
ZW5ndXRyb25peCBlLksuICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAg
ICAgICB8DQo+IEVtYmVkZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cu
cGVuZ3V0cm9uaXguZGUgIHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQ
aG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBI
UkEgMjY4NiB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==
