Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 066E512F4F6
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 08:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgACHhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 02:37:42 -0500
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:42048
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgACHhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 02:37:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZCx8B16+//RaicU7FN11zBsvjt4pruYL0NagB8q4BCPV8hEWdI/7+xPCacoqX8jVN8UnNm0uLiz9vfdMPwAwVystTdswzIrL6MH6QsQjVjPxNCDQ0sizVEbddbXpp88nWGG2OMugWRwC7c3YHZ02tlUn+fgpZlBJG3CIUdHyJzQawWBzGILv0GoVkXHk5qWgNM8WstRID2hWrIe0jX7PtrhQAdp4UVn82UlqcETaduJaLOtilKLfrmFbOc2TxpVX4iHrClwFoMkdoiAntPkAuBJySKLx/Avput1eaTA/YwVm0btohXpL/efcvzXnj7vWt6C2TLGkJMgXX0LSnDHvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Qweras4IazrK8R7pB1JLfhJxJMxX2Hl4o/1Hio5Rao=;
 b=clL5gjtT2dDKQXFdTD31Urt0uchHfXBUNtVAHzA7popL6sd0tMuYdIYr8dz7vs4ZfhP9NAOb0aRXOwZrxSjoJPxQU/AxPufptlv7E9St7VA4sneAGZ+4hAlgtRUh81AcNtBB8he5wm/eXsHBEXVEVKtR8ItiYw/9wkdxs70OdA+Yuyr1ZXc6fty1OJDIUZIHmcXyENgKfDQZ4DEWi7lQo3eEhnzVtG399OyC9dUwbn1mdoq9HneI0cwlM5iFZ0pmtnxiIBUunw3T1aaPT6HCfphxDyCqgFdCrt8R0eow51WNfprfDoDjiTzAPtpe59GnG3DIsWk2WNJG8via7aEq1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Qweras4IazrK8R7pB1JLfhJxJMxX2Hl4o/1Hio5Rao=;
 b=SyIzpB0g8GYq/RlwxzOcehAZ0y0aQr0/czi3HO7daP89jNzuUvKn1pxW5SyEoujGEO4c/J4lbprNGlvXKU72P3xDo9UP+82b4fPvujnTlOYqM6Q101s1H3CNxBV9+gM4u68NxoesSiKvP7j4kmgBUBRzScdwvB8JqQfh1GTgrH8=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4105.eurprd04.prod.outlook.com (52.135.130.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 3 Jan 2020 07:37:38 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::b40b:46af:9458:f2df]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::b40b:46af:9458:f2df%6]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 07:37:38 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 1/2] can: flexcan: disable runtime PM if register
 flexcandev failed
Thread-Topic: [PATCH V2 1/2] can: flexcan: disable runtime PM if register
 flexcandev failed
Thread-Index: AQHVrzg6EKh7HkIWdEajMXWfT23TG6e96VeggAIQLwCAAPjvwIAXuw5g
Date:   Fri, 3 Jan 2020 07:37:37 +0000
Message-ID: <DB7PR04MB461861DC1DBDB5C04998E4C6E6230@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
 <DB7PR04MB46181D2F1538A53B4F1892E2E6500@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <935f466b-a9c9-de73-be12-6ebb7b77e058@geanix.com>
 <VI1PR04MB46223042279D18D20C955881E6520@VI1PR04MB4622.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB46223042279D18D20C955881E6520@VI1PR04MB4622.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 63f15333-02ea-4b77-3584-08d7901fce9a
x-ms-traffictypediagnostic: DB7PR04MB4105:|DB7PR04MB4105:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4105439DD15F1B4858E8389EE6230@DB7PR04MB4105.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(54534003)(13464003)(189003)(199004)(9686003)(7696005)(54906003)(110136005)(53546011)(6506007)(71200400001)(8936002)(81156014)(8676002)(55016002)(81166006)(86362001)(33656002)(2906002)(52536014)(5660300002)(76116006)(4326008)(66946007)(478600001)(316002)(66476007)(64756008)(26005)(186003)(66446008)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4105;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OVdPeXkgfeeANBi72wDLmq/ZGb2Y9pBvJrMx7dUXyzTxgXNiU2TPA5wA3+7v5d1rOJgO2MYFOUEqM98GZjX6heP05iW9w4G3fHFk4jrr9MAyUD3Jc4xZWcfgAkR+VDCiZ41X8UZkmtC5EgbVHAXrmAPOGtOEH5He6Jl7u7A+UdmI7I3y6JA5BHxM3nQNc6UtO1TU3IeEl/zOLN16M0TcHjnIQ9ZRMStxYvuv0Ss8zjYDSGwhZotih8DHZ4bl4h7jxnC4kMy+6sh38RJcYj5rc6kstWH5EzlhXboDiJ/obSKtZ6sUIL7M2nOOYZVbdMR7Z5Tzal222RuxiDjzxDUdQCAyD18ZKUsC6iqCTcFMGNfVdFAOd8qgyeZlqMAq3tPr4P2+GPPqCPfzgr0f/Xm8wRcC/zUHPHoTvu6oBJd7mbwQ4mELwWRH/xEKY57mH1yPH7LhpT+snYMYktQD+wStjq3tL99gUX0/vSTXgYo2RLYBh8iMHoXDENfph8/Bzh0HR1IEOAOVnsWEPgSFXoEUPQ==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f15333-02ea-4b77-3584-08d7901fce9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 07:37:37.8824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CiWIUHKFiKPPu3RatqwiPHQHjohcSM/tgupVnqKuUas5PrZxQFCMYKom0NNHF4xprpmCUVmv3zG21uomZaLhJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMTnE6jEy1MIxOcjVIDEzOjAwDQo+IFRv
OiBTZWFuIE55ZWtqYWVyIDxzZWFuQGdlYW5peC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGU7DQo+
IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14
QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0gg
VjIgMS8yXSBjYW46IGZsZXhjYW46IGRpc2FibGUgcnVudGltZSBQTSBpZiByZWdpc3Rlcg0KPiBm
bGV4Y2FuZGV2IGZhaWxlZA0KPiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gPiBGcm9tOiBTZWFuIE55ZWtqYWVyIDxzZWFuQGdlYW5peC5jb20+DQo+ID4gU2VudDogMjAx
OcTqMTLUwjE4yNUgMjI6MDQNCj4gPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdA
bnhwLmNvbT47IG1rbEBwZW5ndXRyb25peC5kZTsNCj4gPiBsaW51eC1jYW5Admdlci5rZXJuZWwu
b3JnDQo+ID4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBWMiAxLzJdIGNhbjogZmxleGNh
bjogZGlzYWJsZSBydW50aW1lIFBNIGlmDQo+ID4gcmVnaXN0ZXIgZmxleGNhbmRldiBmYWlsZWQN
Cj4gPg0KPiA+DQo+ID4NCj4gPiBPbiAxNy8xMi8yMDE5IDA3LjM2LCBKb2FraW0gWmhhbmcgd3Jv
dGU6DQo+ID4gPg0KPiA+ID4gSGkgU2VhbiwNCj4gPiA+DQo+ID4gPiBIYXZlIHlvdSBmb3VuZCB0
aW1lIHRvIHRlc3QgdGhpcyBwYXRjaCBzZXQ/IFRoYW5rcyA6LSkNCj4gPiA+DQo+ID4gPiBCZXN0
IFJlZ2FyZHMsDQo+ID4gPiBKb2FraW0gWmhhbmcNCj4gPiA+DQo+ID4NCj4gPiBIaSBKb2FraW0N
Cj4gPg0KPiA+IFNvcnJ5IGZvciB0aGUgZGVsYXkgOikNCj4gPg0KPiA+IEkgaGF2ZSB0ZXN0ZWQg
dGhpcyBwYXRjaHNldCBhbmQgZm91bmQgbm8gaXNzdWVzLi4uDQo+IFRoYW5rcyBhIGxvdCBmb3Ig
eW91ciB0ZXN0LCBTZWFuIDotKQ0KPiANCj4gPiBKdXN0IGEgaGVhZHMgdXAgd2hlbiBhZGRpbmcg
IkNoYW5nZUxvZzoiIGRvIGl0IHVuZGVyIHRoZSAiLS0tIiBhbmQNCj4gPiBhYm92ZSB0aGUgZGlm
Zi4gVGhhdCB3YXkgdGhlIENoYW5nZUxvZyBkb2Vzbid0IGVuZCB1cCBpbiB0aGUgY29tbWl0IG1z
Zy4uLg0KPiBJIHdpbGwga2VlcCBpbiBtaW5kLCBwYXkgYXR0ZW50aW9uIHRvIGl0IG5leHQgdGlt
ZS4NCj4gDQo+IEJlc3QgUmVnYXJkcywNCj4gSm9ha2ltIFpoYW5nDQo+ID4gL1NlYW4NCj4gPg0K
DQpIaSBNYXJjLA0KDQpIb3cgYWJvdXQgdGhpcyBwYXRjaCBzZXQ/IFNlYW4gaGFzIGFscmVhZHkg
dGVzdCBpdC4NCg0KQW5kIHdoZW4geW91IHBsYW4gdG8gc2VuZCBGbGV4Y2FuIEZEIHJlbGF0ZWQg
cGF0Y2hlZCB0byBtYWlubGluZSwgc2luY2UgaXQgaXMgcGVuZGluZyBvbiBsaW51eC1jYW4tbmV4
dC9mbGV4Y2FuIGJyYW5jaCBmb3IgYSBsb25nIHRpbWUuIENvdWxkIGl0IGdvIGludG8gdjUuNiBr
ZXJuZWw/IFRoYW5rcyBhIGxvdCA6LSkNCg0KTWFyYywgU2VhbiwgeW91IGFyZSBhbGwgQ0FOIGV4
cGVydHMuIEEgcXVlc3Rpb24gY29uZnVzZWQgbWUgZm9yIGEgbG9uZyB0aW1lLCBpcyB0aGF0IHdo
eSBDQU4gbXVzdCBuZWVkIGEgdHJhbnNjZWl2ZXIgdG8gY29udmVydCBkaWdpdGFsIHNpZ25hbCB0
byBkaWZmZXJlbnRpYWwgc2lnbmFsPyBXaHkgQ0FOIGNhbm5vdCBjb21tdW5pY2F0ZSB3aXRoIGRp
Z2l0YWwgc2lnbmFsPw0KQ291bGQgeW91IGdpdmUgbWUgYSBzaW1wbGUgZXhwbGFuYXRpb24/IFRo
YW5rcy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo=
