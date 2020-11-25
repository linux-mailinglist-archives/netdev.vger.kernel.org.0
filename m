Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FAE2C36C9
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 03:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgKYC2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 21:28:31 -0500
Received: from mail-eopbgr60055.outbound.protection.outlook.com ([40.107.6.55]:12266
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726771AbgKYC2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 21:28:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0pOtjtJPB7EERxZHLjrUcZ/+Nqp1VraOTvKulRu35FNbyke35ODDtiMmGTnq4wxN3H81Es6klPADjeAALXJv9KZmdembV3Y2wKU+u4fb6x7L6JsbZv0MKUhR+IYu1agGKVEs16GtKEvXwiFCisegxhm2OE3Hk/UMaUEfnFZ0vW/gTflf/w/2ZY2KeCzi06DlgZOqDNqjwua93jOkIakehu+xAJ6ZJwg/DbUwbgfIzwHLJA9h4qSXtxsju2/mJVpg17p7bKV69COSsgIKWXD/2wxhbAGkL4lQRrgGQzMd7UmDA3Yuwt90ag3dq+89BG7mVGFGrXkDzNz0YItGraQ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx4v+I5ObWsFWSAeWmunsa4cZxQyE2Rf8ouHJWEpFL0=;
 b=Ou0etaF/OpmKy7r/tmCynVgXj5NtFfGL+jpeZY7XvhtwRaVo1PovgfSrpgjiwAutRwEegrgmcMSR2ZeA7gATKU/nJ5TI2m9+uoU8b8W41PYdHwd1IjBT7waNcUGYb8wSs2DPN63vCjG6olNxlw++XgIz+T3IUEZXq2Lxc9gr5Zz0HEgrQHWeo8O1RmyD9Fhkn80pDqBwDvPsDLPN/QiXmLc6D/K+W3tJV3oY/WIqf4MwNoPwt9zOEV6cRfVYzBP5+YznP+ZxpBKMPTqDzw1h6ZYzx6pz8S2drfAfs4bX72h7NXl00pXoGG19AHzO4ewwLvwa9h5mDSg54ACVy9xnlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx4v+I5ObWsFWSAeWmunsa4cZxQyE2Rf8ouHJWEpFL0=;
 b=MxvjigCW8YIccarMSkUgoYd9uMv3QRsQRsu3sG4TaRmhCTV3bFX06YBOp5bXcgF3I3NduqRq6Y3KZNIiF3t+LuSJbxcN5klUqv02ebIM1y4FXnaivHImhZzjoQs8QicGwKZGVqKcNNrD6jBabeSlYFYo7kcc5dK+0LQmCUwNXvU=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VI1PR0401MB2560.eurprd04.prod.outlook.com (2603:10a6:800:58::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Wed, 25 Nov
 2020 02:28:27 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::9052:40b0:3cba:97ea]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::9052:40b0:3cba:97ea%6]) with mapi id 15.20.3589.025; Wed, 25 Nov 2020
 02:28:27 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: RE: [PATCH v3 net] enetc: Let the hardware auto-advance the taprio
 base-time of 0
Thread-Topic: [PATCH v3 net] enetc: Let the hardware auto-advance the taprio
 base-time of 0
Thread-Index: AQHWwq2ZQxX6V/iGLUOFSGIW3mqr8anYH4gw
Date:   Wed, 25 Nov 2020 02:28:27 +0000
Message-ID: <VE1PR04MB6496784CA12CA642867F372A92FA0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20201124220259.3027991-1-vladimir.oltean@nxp.com>
In-Reply-To: <20201124220259.3027991-1-vladimir.oltean@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 095cc3df-dc61-4308-9b38-08d890e9cabb
x-ms-traffictypediagnostic: VI1PR0401MB2560:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB25606475BFC831B621AC622A92FA0@VI1PR0401MB2560.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J2d7z1IaO5fuwEiEIEcR/zsc7ryUvdYzTB3lYWEfQYAsXPyFJE7FiMdi67RoiYFm+i8yBWVyLGFRuI3oglo95q62UWI8CnoVf5IGl8SQjbjmtehhsYJr2ZMuh8c3dj+Mxp0daHMw2uDztsaS39/mm6GPfTUC14Gv4yTBC+vKTpBWLvCibL4/MJXCu03Djbyfc0VgFF/kTCj7CFnLhLtvqoZE4C6J0tWeiEcnVncCjXjTnATjHwheNJbdFZgsYnCEfTBdoQQc4zixPbv1JudZ9RgCBRZRVRy5JZgZpB9Rj5RlCZo8lngZOON/yH5ymZfj0ye93VqMmS28/lC/JC7loA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(110136005)(71200400001)(86362001)(8676002)(478600001)(7696005)(8936002)(66556008)(26005)(55016002)(83380400001)(33656002)(316002)(6636002)(5660300002)(76116006)(6506007)(52536014)(66446008)(44832011)(66476007)(186003)(9686003)(4326008)(2906002)(53546011)(64756008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?VzRCc1l0Z3pXV3lvc2pWeWRWQTVSTUJ5K2RlMmlnZnkxZm1TdjFsQndTWHBy?=
 =?gb2312?B?NDZuRFlXU0x2b0FCNlYycmpoanhSUFFUYlZuNlNROEpmS3NhVXBHRVg2b1FL?=
 =?gb2312?B?Qm5COWV5NTFvc2VNMTdDWUo0aGhBYzhMUHdmaXZidnVOWEZ4bTloeUhlNmpT?=
 =?gb2312?B?RlN5ejhhdGJmS0lCUnJoVGV1eGdrTTVUNm1aQ2VLR2prMHFJRkdHMHU3YlRx?=
 =?gb2312?B?SHI2eERONEVoejU4amx0SktRU0lhR1ZhcEhqdXdjODVvckhqY0hUdFFtYWFl?=
 =?gb2312?B?NUVyTEdEakt6b296RytlUW5ieFhzN1FjRzc4RnE0bGl5cm45Y3VJc1RSMi9E?=
 =?gb2312?B?aGFaZE1ZbkFKR3lDOWQ4anRRdDlVdEFvMnJSR0ZpVXp3MGtVaHlkcVNqeTJ4?=
 =?gb2312?B?cFUrSmVrZ2NpRytIMGpQamszVUxpbVBWbHlucm44eThoaFlFVUsxQnpFSXk4?=
 =?gb2312?B?YVp5dEFLSCs1Zmk0RW5rK3VnVzRwZGFidDk2WnZ4SmdBUForZ2lUeDhnQThU?=
 =?gb2312?B?K25sMGlFL3NQSForN3ozNUZrcXNuZDFVM1AwTFZQazhQVGlMaGtNRUpjcjY3?=
 =?gb2312?B?ckZiRnlXNzQxRWJ0QXZ6c3MzejZKY2d0cDdlcUowN2VTb0ZPTDBUalcxcEo3?=
 =?gb2312?B?NG1Bd3Q3cDZtV3dTNDl4VnB4dk5kK0xRQkhZSDFJb2VFbHc4L0F3ZGdrVmVK?=
 =?gb2312?B?Mm1jQ3QzbzRkRUF6OGpIMVR3RGozcGFDZ2Q0VzBrK2g1M0M5SktHN1pUSXAv?=
 =?gb2312?B?Z29ZMlQwNDF4OUNvWUdYSW9VQXh6NTRiS3hsZERHdmtrblZ5SFFmZ1dVR3Ew?=
 =?gb2312?B?cjhvS29CaEdONkhuN0Z2WG0zdDFKOTlLTXNBK01CQytobW5GS3pSM05MeHlO?=
 =?gb2312?B?Q01wRGpWdHh5M3JoUWN6blRXU1NZZ2VOUFFCYnBrTEFNOXFTOGYzT21IWllL?=
 =?gb2312?B?Zmhqc0srbmJDNTVpVVEzczduWGt1VnY2cFRIOHRuU0N1SFp4Z0RkUUpwM3l1?=
 =?gb2312?B?Y3BOSVVtZ01FYktxQTlwL0RHMWpnUHhxZXM5MW9ITmNGZzNWeXZHSXhRckNZ?=
 =?gb2312?B?bmNYdVZLTjA2MlBQMnB4YzVjMFRGcUloQUVVVXNFMHhham5sc3ZSbEFTZGNG?=
 =?gb2312?B?RlJ2VVFacGpWU2NTUHowaEZtck56Y09mZVJRTWh5ZUFuR1hrOHY2OUFRNXA2?=
 =?gb2312?B?ZkVoa1lzSWpCbXhxRFhYeTlmYWhQSWpFMTU4UTBWZnB2U1dCRitjWFJFMUFZ?=
 =?gb2312?B?TytGb3ByangzR2dmRTdrNUx1Q0EzSE9tWE81bXlaY0JqS3N6c2RFZXZNSjho?=
 =?gb2312?Q?VaEZ5zXofA6p8=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6496.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 095cc3df-dc61-4308-9b38-08d890e9cabb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 02:28:27.4968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eJ44pqFutFXfx9QgsTZKrGfxzq2odn2zMMP8SIzQUDg/pIRcSM7XLwk/eRuBKgKK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2560
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SXQgbWFrZXMgc2Vuc2UgdG8gbWUgZm9yIHRoaXMgcGF0Y2guIFRoYW5rcyENCg0KPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9s
dGVhbkBueHAuY29tPg0KPiBTZW50OiAyMDIwxOoxMdTCMjXI1SA2OjAzDQo+IFRvOiBKYWt1YiBL
aWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgUG8gTGl1
DQo+IDxwby5saXVAbnhwLmNvbT47IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAu
Y29tPg0KPiBDYzogVmluaWNpdXMgQ29zdGEgR29tZXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNv
bT4NCj4gU3ViamVjdDogW1BBVENIIHYzIG5ldF0gZW5ldGM6IExldCB0aGUgaGFyZHdhcmUgYXV0
by1hZHZhbmNlIHRoZSB0YXByaW8NCj4gYmFzZS10aW1lIG9mIDANCj4gDQo+IFRoZSB0Yy10YXBy
aW8gYmFzZSB0aW1lIGluZGljYXRlcyB0aGUgYmVnaW5uaW5nIG9mIHRoZSB0Yy10YXByaW8gc2No
ZWR1bGUsDQo+IHdoaWNoIGlzIGN5Y2xpYyBieSBkZWZpbml0aW9uICh3aGVyZSB0aGUgbGVuZ3Ro
IG9mIHRoZSBjeWNsZSBpbiBuYW5vc2Vjb25kcw0KPiBpcyBjYWxsZWQgdGhlIGN5Y2xlIHRpbWUp
LiBUaGUgYmFzZSB0aW1lIGlzIGEgNjQtYml0IFBUUCB0aW1lIGluIHRoZSBUQUkNCj4gZG9tYWlu
Lg0KPiANCj4gTG9naWNhbGx5LCB0aGUgYmFzZS10aW1lIHNob3VsZCBiZSBhIGZ1dHVyZSB0aW1l
LiBCdXQgdGhhdCBpbXBvc2VzIHNvbWUNCj4gcmVzdHJpY3Rpb25zIHRvIHVzZXIgc3BhY2UsIHdo
aWNoIGhhcyB0byByZXRyaWV2ZSB0aGUgY3VycmVudCBQVFAgdGltZSBmcm9tDQo+IHRoZSBOSUMg
Zmlyc3QsIHRoZW4gY2FsY3VsYXRlIGEgYmFzZSB0aW1lIHRoYXQgd2lsbCBzdGlsbCBiZSBsYXJn
ZXIgdGhhbiB0aGUNCj4gYmFzZSB0aW1lIGJ5IHRoZSB0aW1lIHRoZSBrZXJuZWwgZHJpdmVyIHBy
b2dyYW1zIHRoaXMgdmFsdWUgaW50byB0aGUNCj4gaGFyZHdhcmUuIEFjdHVhbGx5IGVuc3VyaW5n
IHRoYXQgdGhlIHByb2dyYW1tZWQgYmFzZSB0aW1lIGlzIGluIHRoZQ0KPiBmdXR1cmUgaXMgc3Rp
bGwgYSBwcm9ibGVtIGV2ZW4gaWYgdGhlIGtlcm5lbCBhbG9uZSBkZWFscyB3aXRoIHRoaXMuDQo+
IA0KPiBMdWNraWx5LCB0aGUgZW5ldGMgaGFyZHdhcmUgYWxyZWFkeSBhZHZhbmNlcyBhIGJhc2Ut
dGltZSB0aGF0IGlzIGluIHRoZQ0KPiBwYXN0IGludG8gYSBjb25ncnVlbnQgdGltZSBpbiB0aGUg
aW1tZWRpYXRlIGZ1dHVyZSwgYWNjb3JkaW5nIHRvIHRoZSBzYW1lDQo+IGZvcm11bGEgdGhhdCBj
YW4gYmUgZm91bmQgaW4gdGhlIHNvZnR3YXJlIGltcGxlbWVudGF0aW9uIG9mIHRhcHJpbyAoaW4N
Cj4gdGFwcmlvX2dldF9zdGFydF90aW1lKToNCj4gDQo+IAkvKiBTY2hlZHVsZSB0aGUgc3RhcnQg
dGltZSBmb3IgdGhlIGJlZ2lubmluZyBvZiB0aGUgbmV4dA0KPiAJICogY3ljbGUuDQo+IAkgKi8N
Cj4gCW4gPSBkaXY2NF9zNjQoa3RpbWVfc3ViX25zKG5vdywgYmFzZSksIGN5Y2xlKTsNCj4gCSpz
dGFydCA9IGt0aW1lX2FkZF9ucyhiYXNlLCAobiArIDEpICogY3ljbGUpOw0KPiANCj4gVGhlcmUn
cyBvbmx5IG9uZSBwcm9ibGVtOiB0aGUgZHJpdmVyIGRvZXNuJ3QgbGV0IHRoZSBoYXJkd2FyZSBk
byB0aGF0Lg0KPiBJdCBpbnRlcmZlcmVzIHdpdGggdGhlIGJhc2UtdGltZSBwYXNzZWQgZnJvbSB1
c2VyIHNwYWNlLCBieSBzcGVjaWFsLWNhc2luZw0KPiB0aGUgc2l0dWF0aW9uIHdoZW4gdGhlIGJh
c2UtdGltZSBpcyB6ZXJvLCBhbmQgcmVwbGFjZXMgdGhhdCB3aXRoIHRoZQ0KPiBjdXJyZW50IFBU
UCB0aW1lLiBUaGlzIGNoYW5nZXMgdGhlIGludGVuZGVkIGVmZmVjdGl2ZSBiYXNlLXRpbWUgb2Yg
dGhlDQo+IHNjaGVkdWxlLCB3aGljaCB3aWxsIGluIHRoZSBlbmQgaGF2ZSBhIGRpZmZlcmVudCBw
aGFzZSBvZmZzZXQgdGhhbiBpZiB0aGUNCj4gYmFzZS10aW1lIG9mIDAuMDAwMDAwMDAwIHdhcyB0
byBiZSBhZHZhbmNlZCBieSBhbiBpbnRlZ2VyIG11bHRpcGxlIG9mDQo+IHRoZSBjeWNsZS10aW1l
Lg0KPiANCj4gRml4ZXM6IDM0YzZhZGYxOTc3YiAoImVuZXRjOiBDb25maWd1cmUgdGhlIFRpbWUt
QXdhcmUgU2NoZWR1bGVyIHZpYSB0Yy0NCj4gdGFwcmlvIG9mZmxvYWQiKQ0KPiBTaWduZWQtb2Zm
LWJ5OiBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPg0KPiAtLS0NCj4g
Q2hhbmdlcyBpbiB2MzoNCj4gLSBSZW1vdmVkIGFuIG9ic29sZXRlIHBocmFzZSBmcm9tIGNvbW1p
dCBtZXNzYWdlLg0KPiANCj4gQ2hhbmdlcyBpbiB2MjoNCj4gLSBOb3cgbGV0dGluZyB0aGUgaGFy
ZHdhcmUgY29tcGxldGVseSBkZWFsIHdpdGggYWR2YW5jaW5nIGJhc2UgdGltZXMgaW4NCj4gICB0
aGUgcGFzdC4NCj4gDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5l
dGNfcW9zLmMgfCAxNCArKy0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3Fvcy5jDQo+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3Fvcy5jDQo+IGluZGV4IGFlYjIxZGM0ODA5OS4u
YTlhZWUyMTlmYjU4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2Nh
bGUvZW5ldGMvZW5ldGNfcW9zLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNj
YWxlL2VuZXRjL2VuZXRjX3Fvcy5jDQo+IEBAIC05MiwxOCArOTIsOCBAQCBzdGF0aWMgaW50IGVu
ZXRjX3NldHVwX3RhcHJpbyhzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqbmRldiwNCj4gIAlnY2xfY29u
ZmlnLT5hdGMgPSAweGZmOw0KPiAgCWdjbF9jb25maWctPmFjbF9sZW4gPSBjcHVfdG9fbGUxNihn
Y2xfbGVuKTsNCj4gDQo+IC0JaWYgKCFhZG1pbl9jb25mLT5iYXNlX3RpbWUpIHsNCj4gLQkJZ2Ns
X2RhdGEtPmJ0bCA9DQo+IC0JCQljcHVfdG9fbGUzMihlbmV0Y19yZCgmcHJpdi0+c2ktPmh3LA0K
PiBFTkVUQ19TSUNUUjApKTsNCj4gLQkJZ2NsX2RhdGEtPmJ0aCA9DQo+IC0JCQljcHVfdG9fbGUz
MihlbmV0Y19yZCgmcHJpdi0+c2ktPmh3LA0KPiBFTkVUQ19TSUNUUjEpKTsNCj4gLQl9IGVsc2Ug
ew0KPiAtCQlnY2xfZGF0YS0+YnRsID0NCj4gLQkJCWNwdV90b19sZTMyKGxvd2VyXzMyX2JpdHMo
YWRtaW5fY29uZi0NCj4gPmJhc2VfdGltZSkpOw0KPiAtCQlnY2xfZGF0YS0+YnRoID0NCj4gLQkJ
CWNwdV90b19sZTMyKHVwcGVyXzMyX2JpdHMoYWRtaW5fY29uZi0NCj4gPmJhc2VfdGltZSkpOw0K
PiAtCX0NCj4gLQ0KPiArCWdjbF9kYXRhLT5idGwgPSBjcHVfdG9fbGUzMihsb3dlcl8zMl9iaXRz
KGFkbWluX2NvbmYtDQo+ID5iYXNlX3RpbWUpKTsNCj4gKwlnY2xfZGF0YS0+YnRoID0gY3B1X3Rv
X2xlMzIodXBwZXJfMzJfYml0cyhhZG1pbl9jb25mLQ0KPiA+YmFzZV90aW1lKSk7DQo+ICAJZ2Ns
X2RhdGEtPmN0ID0gY3B1X3RvX2xlMzIoYWRtaW5fY29uZi0+Y3ljbGVfdGltZSk7DQo+ICAJZ2Ns
X2RhdGEtPmN0ZSA9IGNwdV90b19sZTMyKGFkbWluX2NvbmYtPmN5Y2xlX3RpbWVfZXh0ZW5zaW9u
KTsNCj4gDQo+IC0tDQo+IDIuMjUuMQ0KDQo=
