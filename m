Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489BD29E5A3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgJ2ICh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:02:37 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:47249
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbgJ2IBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 04:01:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNt0I8IWM93591QirYm4epKIt+nn3eDOhCmIH1vlImLmblg/QuVvwDd5hqw+rdU0M15KoAVPnabOUSaVbHcfgLiAnUpCOYpG5NsP5DAZKJPJNRgWhS6c2NDoRmrPEWHiy9zocO0FrCJUIf8x6O7RdpSRjySdjdpxV+S7dSOvM67CpWLETZ4+855DeeL90xGKfMVHlY+Feh3tN0qZpWa2doEgAxI32qhchoqX+Hwbl4gUrnqHvGzFkDYIZx0VxDqEpzWnrlYc2++rTiYCZGlKa1eFBioqiEpDEhN4RK21Y4s3XkZXuhFR4R8UwE2+JoBj69NSwbPMpfyB1fstKahigg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMjbAvf2/a0wePsQJiTDVWjZ7+XWwjwjJh9FrVQckTw=;
 b=AQH02RXsLmHpoOjBhbReIYesiqI71mqBcFybAHYgz0twlqz0szB1f0vPXh5u0wGgu53lKYlKVvT9w9RjKl/X1zod2qZ5WApyl+gVZLjDm/4aibtQo8senqeXixRDa5AAH6hC6PWfJtVycmnRCpY6vp95SFqv21/xJccXx5cXtoo55eQ4hoJ5mQhbYQoikxSKxl93/sabeatt7u9DKPeUuQwXhoGXInr68/1vYeC8v8aKXcEo/Owo73FOUtRXQUnb+ymnp15ZbL/UjBR49p1GNL9HB22dZw/GU2iLktdoDBJiJFob0PA6vk92DINTx3BPTVSCKdU8pESWtz9ZHtZiGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMjbAvf2/a0wePsQJiTDVWjZ7+XWwjwjJh9FrVQckTw=;
 b=XV9ZCc2Y5SK3dQPALidOXZ7Z3dCDgOaLgsFLrTgrwFsJTDIYx+BgMbuppnhE9zWUrMT0JaDIkxTXe3MuntbkSShYr/nkJ9dWKL4/UFUkSzvUaO95L/bITe0o4MiM1AifRbsNibbYSlYeD4OKXwwUxOdHtSvKwWPctnBGAQcTKWA=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Thu, 29 Oct
 2020 03:27:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%8]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 03:27:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 0/6] can: flexcan: add stop mode support for i.MX8QM
Thread-Topic: [PATCH V4 0/6] can: flexcan: add stop mode support for i.MX8QM
Thread-Index: AQHWp2pf20/YUdBzdkWpWOmwjarHMamhhkvQgAxxAyA=
Date:   Thu, 29 Oct 2020 03:27:45 +0000
Message-ID: <DB8PR04MB6795CA4DF4BD1D0F4A678AC9E6140@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
 <DB8PR04MB6795A27E2E3D66186A8720DCE61C0@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795A27E2E3D66186A8720DCE61C0@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: shawnguo@kernel.org
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 878cfabc-cdd2-4e8d-04cc-08d87bba9a73
x-ms-traffictypediagnostic: DB8PR04MB6971:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB697182A1F285703AF589BB74E6140@DB8PR04MB6971.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rZkLWd+BVPdVPPWUCIvTsodpdN211ac7PC6Q6Oi6HI2CqHTkdcNo/MNm5DOMJ16pMAwZj1W8mmGjFkRS0Np2/ocifYGnL7SUsgkFMxdFDZvNat62yhUuuHA0p8l9lLWmrAKB1o72Y5w9I3KwGJ/fE+QZQpDt/BbUDJszkqtlUYWXF/8wG27v1jdfsM7uQjJV3B0waT+pZqwqHu65y+0XBWu+IjOJxU7UmehhCpEQynyYmFPQtqruSFIIC2PaZkc4zRSBWaKBkUoPwfRyj9UMd+MiFgrnzw5Zz4uVuI6alIpbwUCY4O6lc/d1P2fOtxyu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(83380400001)(2906002)(186003)(7696005)(33656002)(4326008)(53546011)(26005)(9686003)(6506007)(55016002)(478600001)(5660300002)(86362001)(64756008)(76116006)(66946007)(66476007)(66446008)(66556008)(71200400001)(8676002)(316002)(8936002)(52536014)(54906003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: x9WuqQNwI65nTFVlGb0focmYtHoyAjiWdg3X1lsnaFH3a5lbia0jhMS6ezHl3cQB8r/qIo0CTHsjYI0/a3Az15QcddPa0Yq8/pKAcNyNb/HwJ6Xj503ztOVZIx9mPP7t+XRO7rGrELG6ouPJ/89UGk7K6PKh1ONvsI4NcLuyYbhyqhYcMCpWGyCeKhRemQJzFEN9ahRndJHgz/RYb//mbP/J4IjfyXfPINARcy+tFLHpHWkU01bWJuQ1Emh9RS7aomlqNJYFPTGyjzrhyTWeJT+gu1B+nyk5Zb0phXt6H/Qy1Zlc6Z6wwLTppesJjBBm1I3Cz01CFNqWEL2i0OKyHDeSOZzz0QfRYSjHClfqpg3F2R9sDIusb4x7ZnLc/TWimgMihAds05Xk4kwqK4DmQQavBAepFmAImK48Bb/zuk5+UsBQDxW0MsDfrRyY82CTpOAu12TRWVg9gaLQzVxuOvFtzcVzAgndi+jtscH2OOnvX9hCPk3XsiOGCAbMDx/DMP8YcyG0rfYqz71xv+vN1Ahn+G8nTK0MH/o/BioCRmkmu5/mrT3PwfcegLkcCNbAWR6Mi/rQcZNglvyL0aKbwwmSbHXg88wLcX3AQyOtomKVVRze6X2rvc+BKh6qdK9MVOsBwAfZR1segjddzP0Q/A==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878cfabc-cdd2-4e8d-04cc-08d87bba9a73
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2020 03:27:45.7381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oR0+a+QUOHUe9FLDPhS/myud5AZKOHfHygVpJubBWFyyTxKKE282p9nuHPpCntWezW7Fab0NMEKokRQFeVhdNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpHZW50bGUgUGluZy4uLg0KDQpAc2hhd25ndW9Aa2VybmVsLm9yZywgQ291bGQgeW91IHBsZWFz
ZSBoZWxwIHJldmlldyBwYXRjaCAxLzYgYW5kIDUvNiBpbiB0aGlzIHBhdGNoIHNldD8NCg0KQmVz
dCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gRnJvbTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gU2VudDog
MjAyMMTqMTDUwjIxyNUgMTM6MzMNCj4gVG86IG1rbEBwZW5ndXRyb25peC5kZTsgcm9iaCtkdEBr
ZXJuZWwub3JnOyBzaGF3bmd1b0BrZXJuZWwub3JnOw0KPiBzLmhhdWVyQHBlbmd1dHJvbml4LmRl
DQo+IENjOiBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54
cC5jb20+OyBZaW5nIExpdQ0KPiA8dmljdG9yLmxpdUBueHAuY29tPjsgbGludXgtY2FuQHZnZXIu
a2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSRTogW1BBVENIIFY0IDAvNl0gY2FuOiBmbGV4Y2FuOiBh
ZGQgc3RvcCBtb2RlIHN1cHBvcnQgZm9yIGkuTVg4UU0NCj4gDQo+IA0KPiA+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdA
bnhwLmNvbT4NCj4gPiBTZW50OiAyMDIwxOoxMNTCMjHI1SAxMzoyNQ0KPiA+IFRvOiBta2xAcGVu
Z3V0cm9uaXguZGU7IHJvYmgrZHRAa2VybmVsLm9yZzsgc2hhd25ndW9Aa2VybmVsLm9yZzsNCj4g
PiBzLmhhdWVyQHBlbmd1dHJvbml4LmRlDQo+ID4gQ2M6IGtlcm5lbEBwZW5ndXRyb25peC5kZTsg
ZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IFlpbmcgTGl1DQo+ID4gPHZpY3Rvci5s
aXVAbnhwLmNvbT47IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiA+IFN1YmplY3Q6IFtQ
QVRDSCBWNCAwLzZdIGNhbjogZmxleGNhbjogYWRkIHN0b3AgbW9kZSBzdXBwb3J0IGZvcg0KPiA+
IGkuTVg4UU0NCj4gPg0KPiA+IFRoZSBmaXJzdCBwYXRjaCBmcm9tIExpdSBZaW5nIGFpbXMgdG8g
ZXhwb3J0IFNDVSBzeW1ib2xzIGZvciBTb0NzIHcvd28NCj4gPiBTQ1UsIHNvIHRoYXQgbm8gbmVl
ZCB0byBjaGVjayBDT05GSUdfSU1YX1NDVSBpbiB0aGUgc3BlY2lmaWMgZHJpdmVyLg0KPiA+DQo+
ID4gVGhlIGZvbGxvd2luZyBwYXRjaGVzIGFyZSBmbGV4Y2FuIGZpeGVzIGFuZCBhZGQgc3RvcCBt
b2RlIHN1cHBvcnQgZm9yDQo+ID4gaS5NWDhRTS4NCj4gDQo+IEhpIFNoYXduZ3VvLA0KPiANCj4g
Q291bGQgeW91IHBsZWFzZSBoZWxwIHJldmlldyBwYXRjaCAxLzYgYW5kIDUvNj8gU2luY2UgZmxl
eGNhbiBkcml2ZXIgZGVwZW5kcw0KPiBvbiB0aGVzZS4gVGhhbmtzLg0KPiANCj4gRm9yIHBhdGNo
IDEvNiwgaXQgd2lsbCBiZW5lZml0IG90aGVyIGRyaXZlcnMgd2hpY2ggY292ZXIgU29DcyB3L3dv
IFNDVSwgc3VjaCBhcw0KPiBpLk1YIEV0aGVybmV0IENvbnRyb2xsZXIgZHJpdmVyIChkcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYykuDQo+IA0KPiBCZXN0IFJlZ2FyZHMs
DQo+IEpvYWtpbSBaaGFuZw0KDQo=
