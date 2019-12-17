Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBCD1224BB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfLQGgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:36:05 -0500
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:4371
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725812AbfLQGgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 01:36:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHFPuz2Zpkx1v9fnEvf+Fj/GU4vt3ubtDn5WTB7xtiQIwEZGplHOJ4KNqJZdyKurJqJPx4uORc5dRMbc/bLlpA/vBwcYIEoXvDF7HpixRoNZJKx9QuuIlZDQtjNfj3W8qVgUDuNCQHImajpCMbQzs547yg6nPjk33jUpPrNEkUJ+zBdI7XHnDCyQ9Q+JBuC+cJhti7R4j1ievVPZNcxUt0EjDhWyL2BP08AUnF+3QPv3vyMdaFoerlkf/Mk6PTZ9GhyLBEe8dY4DFp2/dRDCeSThaKMcTixL72xhS8dyQDShjAXP6lu84Z3O8N6aVFwSuIdBh3tTwIaE5Mn7WnLmYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDZZ5Z5JC7wPLiw3F8JwmraFbVxSFKA54f50Zzrubc0=;
 b=OvV1K5oCACATr4x6j0RH/bDoSEktosSoM0tRUaDjUwdVxrNU0eJJEmjnMqgGnr62s4p59E+0EG7pGg6hLu49hw7AMkT7y+gOFr2Ypuhro2csTDYuiCfNe7QJyO7EnZW/PUSbClx8at2ixGduJoAP6GbZwnnLyVcq+ve/i3YTJ6PY+AC61wrnj/tJC40+rpLxzRanDevqOrFxm0Gz5b2w0rtxE6a6WGvgBBkTZtJfQAhgSPCO9+1nVs5nuqLczS57wSw/qSeF4xsgZvhK5OtfEI6d1tt5IKpr3MBM7miHVCE8hVo2ktLRrrkv6K9/F8EA0/vT/4Oj97osMa+rxa8MXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDZZ5Z5JC7wPLiw3F8JwmraFbVxSFKA54f50Zzrubc0=;
 b=G0HavQXL1ktbOLSu72wA6N1NOVC6vNajGTeAP25nxheXS92XREAxUYznMZ1o30puRJIfsYvpxsfvhGPaQAz9l5UoXV89b9awBCMiBI9PUsjqDoKBkJmjUUSPxCBJYiyMk/8A9acXhXg1VfPPz4RbHLE/072mU63/jyQmgft11/c=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4716.eurprd04.prod.outlook.com (20.176.234.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 06:36:01 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::b40b:46af:9458:f2df]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::b40b:46af:9458:f2df%6]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 06:36:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 1/2] can: flexcan: disable runtime PM if register
 flexcandev failed
Thread-Topic: [PATCH V2 1/2] can: flexcan: disable runtime PM if register
 flexcandev failed
Thread-Index: AQHVrzg6EKh7HkIWdEajMXWfT23TG6e96Veg
Date:   Tue, 17 Dec 2019 06:36:00 +0000
Message-ID: <DB7PR04MB46181D2F1538A53B4F1892E2E6500@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191210085721.9853-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d0a2bb5c-41ba-4619-cb95-08d782bb61e9
x-ms-traffictypediagnostic: DB7PR04MB4716:|DB7PR04MB4716:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4716193B2EBA1BBAC2220774E6500@DB7PR04MB4716.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:651;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(13464003)(54534003)(189003)(199004)(52536014)(110136005)(54906003)(478600001)(55016002)(81166006)(2906002)(81156014)(9686003)(26005)(33656002)(8676002)(86362001)(76116006)(5660300002)(186003)(66446008)(64756008)(71200400001)(8936002)(66476007)(4326008)(7696005)(66556008)(53546011)(6506007)(66946007)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4716;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e7rS0iv91VqhUv2n3VxbH59OdRohsN/gwsW4m8G2R7EutrhFuXO/TeCdoD8wLXAp3GJupNKwf5Sv6G4KVheQ4OpDE28L5xqn6dm7qk6/9zvK1KwBqsf3A3+Zjr8VQXEFYoBGhtB2ISdoIsDb1vVlEdEAbNZ8/H80rD56VJ3bEtSnGYo88/86maxe+o1b5g2ZgEDWeifAr6diZLVn/p6Sb0nazkKiYKdArfo4S7WTtQQzjw5HQKbEy96jTja5mtS9gPN834EhpBG0bZt0xAcwPOIQIZK6vdjpJ77avZmX1TPlfDpGvBclE53LLiNPA44mYFj+3mIGzWRr9A7GPCPc7mdkzsFjy60Zu+Dd3NFvOF41VGw7jJIND61lKKwMxNvj2+kky3Nono75mrvues/Pff/hpt/kdhhAnHmVHMTBTR7WNHdHgXdcodfJxrQL+RBfdStKiIUtMOofFo574yDhyD0zyI98dWQBKkXi6ZuUwgVOyU9VK07HXSTbS4I1WBHrtHBsNSRgZr+ik/5tS1kGQg==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a2bb5c-41ba-4619-cb95-08d782bb61e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 06:36:00.8602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X+nR/1AU0Ja2fIs+urXl0ydgV1L/N/NpOo/6G0TvbwsblJ+eYkaUCXLUA7o8gnU2yH8eVYryz/9KeEM7Coku0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBTZWFuLA0KDQpIYXZlIHlvdSBmb3VuZCB0aW1lIHRvIHRlc3QgdGhpcyBwYXRjaCBzZXQ/
IFRoYW5rcyA6LSkNCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQoNCj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdA
bnhwLmNvbT4NCj4gU2VudDogMjAxOcTqMTLUwjEwyNUgMTc6MDANCj4gVG86IG1rbEBwZW5ndXRy
b25peC5kZTsgc2VhbkBnZWFuaXguY29tOyBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENj
OiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgSm9ha2ltIFpoYW5nDQo+IDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gU3ViamVjdDog
W1BBVENIIFYyIDEvMl0gY2FuOiBmbGV4Y2FuOiBkaXNhYmxlIHJ1bnRpbWUgUE0gaWYgcmVnaXN0
ZXIgZmxleGNhbmRldg0KPiBmYWlsZWQNCj4gDQo+IEhhZCBiZXR0ZXIgZGlzYWJsZSBydW50aW1l
IFBNIGlmIHJlZ2lzdGVyIGZsZXhjYW5kZXYgZmFpbGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Sm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gLS0tLS0tDQo+IENoYW5n
ZUxvZzoNCj4gCVYxLT5WMjogKm5vIGNoYW5nZS4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9jYW4v
ZmxleGNhbi5jIHwgMiArKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2ZXJzL25ldC9j
YW4vZmxleGNhbi5jIGluZGV4DQo+IDNhNzU0MzU1ZWJlNi4uNmMxY2NmOWY2YzA4IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2Nh
bi9mbGV4Y2FuLmMNCj4gQEAgLTE2ODEsNiArMTY4MSw4IEBAIHN0YXRpYyBpbnQgZmxleGNhbl9w
cm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlDQo+ICpwZGV2KQ0KPiAgCXJldHVybiAwOw0KPiAN
Cj4gICBmYWlsZWRfcmVnaXN0ZXI6DQo+ICsJcG1fcnVudGltZV9wdXRfbm9pZGxlKCZwZGV2LT5k
ZXYpOw0KPiArCXBtX3J1bnRpbWVfZGlzYWJsZSgmcGRldi0+ZGV2KTsNCj4gIAlmcmVlX2NhbmRl
dihkZXYpOw0KPiAgCXJldHVybiBlcnI7DQo+ICB9DQo+IC0tDQo+IDIuMTcuMQ0KDQo=
