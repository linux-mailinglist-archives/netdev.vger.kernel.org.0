Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DCA3E3F45
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 07:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhHIFLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 01:11:54 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:61536
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231996AbhHIFLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 01:11:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuPnq5QtKFFlqjb1r8xNHk+G2hDmVQBMoaiqAfpvAgnH1QV0aqRhJcAfpt6YFknZGuPM5NiPAWpN9wLmyez1xps80dkNCT6NGLGTPxmZ/qg86cGLFbRNPyLF3QrgKowsBwoS7kCtKK+Eim6vyIvRVdziAun5LsRiPicxfpevU4SKBURJ6f2AoUfh1EVd/Y3ipJRGIXbOSGTZ9YixC0hUaYvxAiY3GTPRjihWPuxITCyJazBK2+ScE/5274Xd6xKVDDeJjfaY0KlWCaX/5zFpeWOQTNmWulCfhgQKdxUMc215vgfzL3OkcyAfVAjOd4k1E/4YPWb+Fpba6dn9HxQWSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtspRq5npEh87AC+Arr/P6boAe+7nWyNF1Zan7b/oRw=;
 b=NGzyfz35NNODRkRIsjD/wsDs0UtyLN8zcjfgo2K+lTAoPZ4Niub1R+MvZ8M4NyrveZrFNFdttiTxLvEpf2rqfSooc1gd/OAP9eitxrhBy2mjpMDYW0/y/QvlYgsr8xt9tcFCzFxP0CrC/wWxkC6+JXPoPvZzeAb/bh8PXNimGzbenwEvQAOUyKA2QBVPeEJIEud0I/yhHACwBfhq1yzBtlsHjCm5I/96uKYh1GlYayO9/D/B3XRimkQV76oj6j010eIurSTCH/i7aV8K8ckQW3MZERMYMjRBO0TisWO0/zNr5p7dsT2pa7fKYCwjo361ojWJiT0nLbmz+asY94kdSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtspRq5npEh87AC+Arr/P6boAe+7nWyNF1Zan7b/oRw=;
 b=mBMctz27vlJsTWDR7y/4+U30cu1izciReG+eqnoSXuDKxj7G9iRxRX6R4ZcVdWYeURI6Co4ypC68WZYeFUKj5eKVfE1yYn5zOWP5WeoIZ1SNCDgsIaMHwult4SaFJtMZDH/AwcBVUSJSWo8uecInHb5KOZVQ5GgBSJ9A0ZO/Mtc=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8430.eurprd04.prod.outlook.com (2603:10a6:10:24f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Mon, 9 Aug
 2021 05:11:31 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d%6]) with mapi id 15.20.4394.022; Mon, 9 Aug 2021
 05:11:31 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 4/5] net: fec: add eee mode tx lpi support
Thread-Topic: [PATCH V1 4/5] net: fec: add eee mode tx lpi support
Thread-Index: AQHXdJeZXIVAjgPwdk68s5rhZYjv2KtqlfKAgAA6T0A=
Date:   Mon, 9 Aug 2021 05:11:31 +0000
Message-ID: <DB8PR04MB67956C9894A1F77FF537A731E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
 <20210709075355.27218-5-qiangqing.zhang@nxp.com>
 <20210809014043.GA3712165@roeck-us.net>
In-Reply-To: <20210809014043.GA3712165@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 489a85aa-6c17-4478-28cd-08d95af4267a
x-ms-traffictypediagnostic: DB9PR04MB8430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB84309813772A6489EDB62ADCE6F69@DB9PR04MB8430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HT/o75Ib9ujTJCyvLueNYEECfCxOxyawLkIt+zxBB3QXzm4Kiqp9fue9e5wJIG8EFlhejBjm4hZOodv5HqDAQLAi//8gNRHXxuxEKwN+2zZudXwVqS0ugfLd1i3NbCzdqN56aJIV161E6DgRxlhQkHRmZNjkOlpCjQm3dLtrPKYZzwWTYsLQ4/elmI3OruCh3Oa2yWN0lr36+OCup921lpN+OIldN5MKt/a3rH6wSbokQUthY+nGi2/vvSRYsWPZTnx7xWLwPfBs3RPC0fzU01xMVDKSlaWCC5kWcrJZ3ZEGYDzN+Prr8OPB4gPC6J4Wb73wJ0tGHvu+JH9+rp/M7LXpFy2KA9hFQ/riJNkUqD5WHRgLN2O3ZCAC/+g/9NB30tPBDdLoQD5qOj59yKONQkH6DZeAJprTOo0IeMXKG9PfjXsTjAXeulpynMaaJpRqBSv7MBogZUWBO3Xh1rTQA0ZDna1JzxKEFVeTfXaVN+SSS5jJI/qdcQFiqKLCKJ7GUIFoNRhtR9sudlyodHVGbr54V7twXyHLpynNCyRkXB6JWNk7whdXqzgT40ODY6yZ3qf77Bv6QwRSvmZcXKdaBwn/+/oSt5ZSUYWqqoLO+4bi3b4x1X+4cMRPnvzET/wVDV+Tf4aGHLVC3+Dc4GeGTIBi8IqpLOt5iw+ZfGvFbBjbssHcEg/URPdNT5uaEsAtauK2gtIUPxZyhxSFTCooJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(186003)(26005)(52536014)(6916009)(83380400001)(86362001)(66946007)(66556008)(76116006)(64756008)(66446008)(66476007)(55016002)(71200400001)(2906002)(9686003)(54906003)(8936002)(122000001)(4326008)(38100700002)(38070700005)(33656002)(316002)(6506007)(8676002)(53546011)(7696005)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bkhMcTgxS0RmbEdRL054NmVEY3F0dzBLQlNaaXczOHJLbkNDZlRocEw2OXFR?=
 =?gb2312?B?N0FkektsL0ppYXFGZUZWS3FHalRIdlAyUVpxQmJ2ZUZWclpsS0o0VE1NQkxy?=
 =?gb2312?B?N3hLMFJ5LzZhVjlKc0R1SExPMndRUlZUamhJd2Jva2w2VVFPY3RBRXZ2Mmo1?=
 =?gb2312?B?V1JFRkVIdU1uTm42bm9tT25pTmU1Vnl6M2QxenFVc2UwSEQ2ZlMrVkNxdzJQ?=
 =?gb2312?B?RElmb29VRTNOSlpDUGtkcFFvQlkvOTBITmd4bFQrb3p5cTJXYnllRkJrejFv?=
 =?gb2312?B?Ty9xVjdKRmwzVUUzRHZ4ZWIwV3pPUnMxWDQ0N3NRTHB4M0hMNjlrYTByUlF1?=
 =?gb2312?B?dC9pdk9meU5OYTNpeTdzRkRaZS9ocUMrNUNsLzZQS1ROZ2Jyay9rWmRnSHpK?=
 =?gb2312?B?S1lBM3RQUkpnQ2lwTHVZOVo1YlhWTmRZRjJ2RjBTMTIwcjNVT00razY0LzMr?=
 =?gb2312?B?TXpLR0xHandZWWgrTW9kY2VkSXJ4VVRwQnlpb1dGTUFzUlJDY01wTHN3VUk1?=
 =?gb2312?B?NXlYMXcvZ2kvcjRCVGJad1VyeGNnOFQ0cmdpYjZWekFBYXNaY29jZTA1M3k0?=
 =?gb2312?B?S2pOUkIyQWN6c3RYdml4Skd5L2FkWS9RbWJaYVBGUVQ1U3Z3SFErOFVMQ200?=
 =?gb2312?B?V2xSWFlyeGlNYmt3SnZpV3ZEWlZoMzk0T0I2aHp1TWJmRE5VcVlwM1ExSGN6?=
 =?gb2312?B?ZWNlcVpxbWk1eTYvNUo3THFCNytJYXVxLzVLOE5zVGZTbUJWQlJ3Q0NFRW1t?=
 =?gb2312?B?NGpKY3BWNTZ3KzdqL1JwR3VxNEg0cmZpWnhxcGRZbDIwdmlSSzFOUVA3YTBN?=
 =?gb2312?B?UUo4anQxYnpUS0kyRkxwMHdReXNld2dWNTR2OVZvR0ZxcUhSM2ozT1B1eWl3?=
 =?gb2312?B?cmM2WUc3NHNjaEpDby80MWs2d2EvbDBQanZlT0Fsc2FPUUtINEVHVUdvY0JE?=
 =?gb2312?B?QXQ0ZnQ2OHVqN3JiczBhclBpUWI2d1ZBL3VFK05NcVQ1Vk1aK2xPeEE0NjZH?=
 =?gb2312?B?L2dRd0g1TTQ3Q0xvSGRFeHhJOER4d0UxRTA5ZHVjaHZxRmZxTGNXVFZicWRj?=
 =?gb2312?B?YWVtUW94WFpUTXk1TTdkY1B3UUs1ZWxBMjI1cldUanhVQmUwdld6SVFLK21N?=
 =?gb2312?B?Ym1oQTU2SEk5UmphNVhKM3ZEbmJ3dkVTdGdTVTBrOS9HTVlJVzVyRkdYR2F5?=
 =?gb2312?B?bnRsWFYxOGxNWFc4eXptMHVUWGlvYzJkOURsMnduYVRxdDg0N0tqekdQdCtR?=
 =?gb2312?B?alErR3QzNW93ZDRkM0dHRkNwMGtzeGJCd1k1MzhvSXhndDZYSURiMVZIaWJr?=
 =?gb2312?B?akJVNnJqTDRGaVMwR3crTlRFK2lyVjREWm9WY1greGxHTVJyeW11SXBnaEJE?=
 =?gb2312?B?Q2FIaENadnJySVJUVDhpV2d5UkF5QVJ6TytDZUMrSTFCSU9ackpQUUU3eDBI?=
 =?gb2312?B?WXB1VFRSeEF2RXp0L0dRaU9CaUxpYnVBNHBuMXk5UHFYT0hMSFhwV1poNEZw?=
 =?gb2312?B?eG5RU2pMQXRlNm92eWZqZ2tkQnpCSERsS3Y1NTVZZnM3WG9vWmtJcWRRNmVx?=
 =?gb2312?B?OVloQVNMV3NWZHI0NWFxbzVtZG1LL1F0NG4ybU04TERLdDBjR291eDhIdDM4?=
 =?gb2312?B?Tlk0dnpDRVNiUGtVVGs2a3YzM0dZNm9wc3lybEpHdGlRT25DRkpQQXFXaGNI?=
 =?gb2312?B?NVJ3QmJEWGJaME5aRi9UbGNQa3NFUTBpVUc4NXo0ZTFIQTJ1UEIybXhRQXp4?=
 =?gb2312?Q?Co5PP5Gj7DFugZjyls=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 489a85aa-6c17-4478-28cd-08d95af4267a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2021 05:11:31.3287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m+bsweSXRGk+bLP5h5ycF9TkC+LMuICCz22HIzV5FvHdOpBZhZmJyzO1t57F1Xh4qKDeRwHS8sDJKBvN2jRRaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBHdWVudGVyLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEd1
ZW50ZXIgUm9lY2sgPGdyb2VjazdAZ21haWwuY29tPiBPbiBCZWhhbGYgT2YgR3VlbnRlciBSb2Vj
aw0KPiBTZW50OiAyMDIxxOo41MI5yNUgOTo0MQ0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fp
bmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVs
Lm9yZzsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBhbmRyZXdAbHVubi5jaDsgbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggVjEgNC81XSBuZXQ6IGZlYzogYWRkIGVlZSBtb2RlIHR4IGxwaSBzdXBw
b3J0DQo+IA0KPiBPbiBGcmksIEp1bCAwOSwgMjAyMSBhdCAwMzo1Mzo1NFBNICswODAwLCBKb2Fr
aW0gWmhhbmcgd3JvdGU6DQo+ID4gRnJvbTogRnVnYW5nIER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5j
b20+DQo+ID4NCj4gPiBUaGUgaS5NWDhNUSBFTkVUIHZlcnNpb24gc3VwcG9ydCBJRUVFODAyLjNh
eiBlZWUgbW9kZSwgYWRkIGVlZSBtb2RlIHR4DQo+ID4gbHBpIGVuYWJsZSB0byBzdXBwb3J0IGV0
aHRvb2wgaW50ZXJmYWNlLg0KPiA+DQo+ID4gdXNhZ2U6DQo+ID4gMS4gc2V0IHNsZWVwIGFuZCB3
YWtlIHRpbWVyIHRvIDVtczoNCj4gPiBldGh0b29sIC0tc2V0LWVlZSBldGgwIGVlZSBvbiB0eC1s
cGkgb24gdHgtdGltZXIgNTAwMCAyLiBjaGVjayB0aGUgZWVlDQo+ID4gbW9kZToNCj4gPiB+IyBl
dGh0b29sIC0tc2hvdy1lZWUgZXRoMA0KPiA+IEVFRSBTZXR0aW5ncyBmb3IgZXRoMDoNCj4gPiAg
ICAgICAgIEVFRSBzdGF0dXM6IGVuYWJsZWQgLSBhY3RpdmUNCj4gPiAgICAgICAgIFR4IExQSTog
NTAwMCAodXMpDQo+ID4gICAgICAgICBTdXBwb3J0ZWQgRUVFIGxpbmsgbW9kZXM6ICAxMDBiYXNl
VC9GdWxsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxMDAwYmFzZVQv
RnVsbA0KPiA+ICAgICAgICAgQWR2ZXJ0aXNlZCBFRUUgbGluayBtb2RlczogIDEwMGJhc2VUL0Z1
bGwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxMDAwYmFzZVQvRnVs
bA0KPiA+ICAgICAgICAgTGluayBwYXJ0bmVyIGFkdmVydGlzZWQgRUVFIGxpbmsgbW9kZXM6ICAx
MDBiYXNlVC9GdWxsDQo+ID4NCj4gPiBOb3RlOiBGb3IgcmVhbHRpbWUgY2FzZSBhbmQgSUVFRTE1
ODggcHRwIGNhc2UsIGl0IHNob3VsZCBkaXNhYmxlIEVFRQ0KPiA+IG1vZGUuDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBGdWdhbmcgRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiANCj4g
VGhpcyBwYXRjaCByZXN1bHRzIGluOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNj
YWxlL2ZlY19tYWluLmM6IEluIGZ1bmN0aW9uDQo+ICdmZWNfZW5ldF9lZWVfbW9kZV9zZXQnOg0K
PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYzoyODAxOjQwOiBlcnJv
cjogJ0ZFQ19MUElfU0xFRVAnDQo+IHVuZGVjbGFyZWQNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQv
ZnJlZXNjYWxlL2ZlY19tYWluLmM6MjgwMjozOTogZXJyb3I6ICdGRUNfTFBJX1dBS0UnDQo+IHVu
ZGVjbGFyZWQNCj4gDQo+IHdoZW4gYnVpbGRpbmcgbTY4azptNTI3MmMzX2RlZmNvbmZpZy4NCg0K
SSBqdXN0IHNlbnQgdG8gcGF0Y2ggdG8gZml4IHRoaXMgYnVpbGQgaXNzdWUsIHNvcnJ5IGZvciB0
aGlzIGluY29udmVuaWVuY2UuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBHdWVu
dGVyDQo=
