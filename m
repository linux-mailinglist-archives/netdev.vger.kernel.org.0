Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F34125A61
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 06:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbfLSFAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 00:00:04 -0500
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:24993
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbfLSFAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 00:00:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ez8xA7yDLNBtWPazRSSifFDIbQETHfCKvjzjmf2Kd5/LzOI5vlonWP0dfNMYonCmGn3uSxNTkrn7a59zHoksiZddw5yhYfJ0TvocS9jdU/1OVUYFZ+tXvfdz41I4O8GETEXZLPSG/I3IZoR17/A1Cjf12LkfdiwFfZSnGWScod+j08Pi0HXmsaxQRbmnbenM1tLjPLGtlsT2R1NTU/VGAjgcXxGQBzVnHFxX1IggZrsxK5Ez3TR9Nx7NDXkT5OyOrddo+4gpLOxAQDSw5HnhnjudfaMHWbaqV19GlV7/1YGsLW+wHkYrlqhjum2Fmpw389OMBSxLhSxIZdJnUgZ6gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHPSgPhoMd4JMK4DIN89LNBupdrMh3qPvWniSoQJqyQ=;
 b=LripyXeIRkZKPQdLPYcWK0QqPcsjOW/UO/2bQgKWiBQwMZ8XANYRrnz6+Kp///XnZV4TqNC2tRXdQB6vVUJVdz0tGD8y91et2cL+XvSlHPXisTsIUUCz6f9Y8rFV44n3aVpuKLE4ckDJraSZytb0WTC3SOyKyvIpm1PxPaH/OQ3IvMbncGoO5OhKXIJZoMkv+0rEqClhtsAcift6zjFnnkhhiojwmx6FyozuTkuuKoo+NWBcHwXTkmlTE/8lsQYeGHo6CQP1COB69vs4IUCiJFpCcp2CvDeOjTSspe0K47H+TWOl5Xnn/5+ym7jtLXvih3IW7brOim9SvIioN/W/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHPSgPhoMd4JMK4DIN89LNBupdrMh3qPvWniSoQJqyQ=;
 b=nxxpIx6jljno4iV+vGAsgVHh1texMEhk6oHeolX5I28uckQpp4I6sCLC+AtSg0pLM2tnHjFh8KeHxnfSlhP/uUNM/XZobF6p2PTJo6jWQG69j05fzTj4lQYb9+kjkTrjdUOV2CP/O8Oepsl8hydFdVrZwKxI6cwURvJAMF/F9iE=
Received: from VI1PR04MB4622.eurprd04.prod.outlook.com (20.177.57.151) by
 VI1PR04MB5693.eurprd04.prod.outlook.com (20.178.126.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 19 Dec 2019 04:59:58 +0000
Received: from VI1PR04MB4622.eurprd04.prod.outlook.com
 ([fe80::11b5:1af6:ef87:d0a]) by VI1PR04MB4622.eurprd04.prod.outlook.com
 ([fe80::11b5:1af6:ef87:d0a%7]) with mapi id 15.20.2559.012; Thu, 19 Dec 2019
 04:59:58 +0000
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
Thread-Index: AQHVrzg6EKh7HkIWdEajMXWfT23TG6e96VeggAIQLwCAAPjvwA==
Date:   Thu, 19 Dec 2019 04:59:58 +0000
Message-ID: <VI1PR04MB46223042279D18D20C955881E6520@VI1PR04MB4622.eurprd04.prod.outlook.com>
References: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
 <DB7PR04MB46181D2F1538A53B4F1892E2E6500@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <935f466b-a9c9-de73-be12-6ebb7b77e058@geanix.com>
In-Reply-To: <935f466b-a9c9-de73-be12-6ebb7b77e058@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9e5b9d74-eb77-4a4c-dc8f-08d784404c02
x-ms-traffictypediagnostic: VI1PR04MB5693:|VI1PR04MB5693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5693014CC31D9A981711A9DDE6520@VI1PR04MB5693.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(54534003)(13464003)(189003)(199004)(66946007)(186003)(478600001)(4326008)(66476007)(66556008)(66446008)(64756008)(76116006)(316002)(9686003)(2906002)(4744005)(86362001)(71200400001)(55016002)(110136005)(54906003)(7696005)(53546011)(52536014)(81166006)(8676002)(5660300002)(6506007)(81156014)(33656002)(26005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5693;H:VI1PR04MB4622.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CROA7eRm+aAnjICG8x4F+8fkQzHSkmtFdvNIDTANHQJfzHTAycBzByS5Bv663r3RmjQVR8jQDAwCOCidc2CT5p07ErQBYMvZLD0519zKdFrP8T2Lt6/Hf43a0nqurq3iPImz0mJcDSDnLWVyJ2RDQUeOpBCFuHkrJby6CCuDHpBoHbwsMTpEivJWnA4F47/7TE41I9X6hST2TKkwST+b5zPsS63jTyubG9WLvk3gX2L1TEhInqVTqozxERUj5M+zZKxbvpI1aU0xkPcpMN3e0MfNAT/TK5Ehdhdg6c72h/2ROPAw46TiexnT4GqwuTt3pKNebaPDIUWE+/5h9zWYLOxO5fLXcO/f2T9Fn82QVnUIWsXPplDouaCpy9zVyGcRB+FEbgqblF96cfqoE+UBK4UWGylzOhpXfFqY/YeuzpaPzk2QM/XksUMlq7I2RzHfBTlDBDmN7+bWCRGr5ZC0q8Mb0+fOI7EVK+w9eVHcGrHTQDyvtWnOTTugbsyMcBuVH2ngg6bkTKmxEUv1NhasBw==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5b9d74-eb77-4a4c-dc8f-08d784404c02
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 04:59:58.3674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qRAWCW8IppQuf2htiO5Xmxrbmv6P1iJP0kn3eNStGY3Q1ZQeOv6n3CHFdsB1SCyR9618bTYSl/EYrfMheCoAIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOcTqMTLUwjE4yNUgMjI6MDQNCj4gVG86IEpvYWtp
bSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGU7DQo+
IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14
QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
VjIgMS8yXSBjYW46IGZsZXhjYW46IGRpc2FibGUgcnVudGltZSBQTSBpZiByZWdpc3Rlcg0KPiBm
bGV4Y2FuZGV2IGZhaWxlZA0KPiANCj4gDQo+IA0KPiBPbiAxNy8xMi8yMDE5IDA3LjM2LCBKb2Fr
aW0gWmhhbmcgd3JvdGU6DQo+ID4NCj4gPiBIaSBTZWFuLA0KPiA+DQo+ID4gSGF2ZSB5b3UgZm91
bmQgdGltZSB0byB0ZXN0IHRoaXMgcGF0Y2ggc2V0PyBUaGFua3MgOi0pDQo+ID4NCj4gPiBCZXN0
IFJlZ2FyZHMsDQo+ID4gSm9ha2ltIFpoYW5nDQo+ID4NCj4gDQo+IEhpIEpvYWtpbQ0KPiANCj4g
U29ycnkgZm9yIHRoZSBkZWxheSA6KQ0KPiANCj4gSSBoYXZlIHRlc3RlZCB0aGlzIHBhdGNoc2V0
IGFuZCBmb3VuZCBubyBpc3N1ZXMuLi4NClRoYW5rcyBhIGxvdCBmb3IgeW91ciB0ZXN0LCBTZWFu
IDotKQ0KDQo+IEp1c3QgYSBoZWFkcyB1cCB3aGVuIGFkZGluZyAiQ2hhbmdlTG9nOiIgZG8gaXQg
dW5kZXIgdGhlICItLS0iIGFuZCBhYm92ZSB0aGUNCj4gZGlmZi4gVGhhdCB3YXkgdGhlIENoYW5n
ZUxvZyBkb2Vzbid0IGVuZCB1cCBpbiB0aGUgY29tbWl0IG1zZy4uLg0KSSB3aWxsIGtlZXAgaW4g
bWluZCwgcGF5IGF0dGVudGlvbiB0byBpdCBuZXh0IHRpbWUuDQoNCkJlc3QgUmVnYXJkcywNCkpv
YWtpbSBaaGFuZw0KPiAvU2Vhbg0KPiANCg0K
