Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0763AE350
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhFUGkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:40:36 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:12257
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229576AbhFUGkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 02:40:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KT5IlcrBryK6ZqDVn06PGj2H0BUGJxc5VXqYow9A9Txsr3MGOlOIUC0rJl5cFl0qHRa0KOUxn0rAV15nXRM3FGAHQPSKhtmwsJwGm1TsSzDSK9e/5m0zJTBRkcX6AksfE1NRAx9zp1XBEBflxq2CotnZJl8gS3QnnGnndHLjVLkPzOWTnaI17FruPGzpy0mju4CqYwqNiX2qzrkDckiodUNjPEgnzZt9dRsQ6VAfDFABr5khxzjxeb2Tnj4iezmQ+T3k2kI0igMIV7M4mJtTOJgITGff44d+uP0B4s0ZWAlve47JCFzxtAWIG2S8K87PRPrFF/0TrI/wcafUQE05Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMMc66HhkXpdjbSKAJBP8FV7L6sHyQDGSvaWQHS79SQ=;
 b=GcrZKUZFyCPz8kxuSmG7p+pb9QKeR+JGCtA7nSjvu4Wb8kxAOCbPnc8iF77PWa1MqvVrprhzbcYWLCLJq/JCdt6GAoQ8ISvnAKvqyn9d4FyRBins53LRJ/dH/5my/zz9b0hsh38Tlz7iMNc7vZI8aNTL9St7UZo5rPCRT/QdFr902/k3WzJCPZ9aLJoA9b4e0yeLXed5faLDi4n9PTziukNnXEaA2dxo3wDm87SwjXjaUr9kgpU19akX8ovCNzS60BXt3VBpQykT9PTLp1hB/79hUufgfQU+UnWzLa2uvxHKJ5mMpy6AYW1X+s9vwkVQ09P7Ug4b8XOFXXsq9DGssw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMMc66HhkXpdjbSKAJBP8FV7L6sHyQDGSvaWQHS79SQ=;
 b=sAMAatdkoTaLwfWSXyXyixy3si7E3OoEY5oykOGodSXJIq4AWw2ltUGhASOrhssoJRttl/8c86/zcngRJzcV2itm7tV+tcBewJcI5hlP1tjekjuGxU+1nwoZhi5wCIP89BLkHPJp9dzQT+X/R6oH7du5aScYFcNWmYud8iYnbT8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5882.eurprd04.prod.outlook.com (2603:10a6:10:ae::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Mon, 21 Jun
 2021 06:38:18 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e%8]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 06:38:18 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V3 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Topic: [PATCH V3 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Index: AQHXZmaywcb6U2LegEus7RRO1D6RnaseAgsw
Date:   Mon, 21 Jun 2021 06:38:18 +0000
Message-ID: <DB8PR04MB6795E4B551230139EDD4B76DE60A9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210621062737.16896-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210621062737.16896-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a7c10c6-6142-4621-4e34-08d9347f27ef
x-ms-traffictypediagnostic: DB8PR04MB5882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5882375BECC6ABA662DF12DBE60A9@DB8PR04MB5882.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xx5ybscGOtzY8sFIt+BSGQhFXkeRp/jHdTwx4ML+mDbHmp4PaHBadM6nua4cFLlzKbQHnk3TRDTiTxr9A01ku+9QlMo5wPSVyQTjlkNvaCRfkIC2Dv5ZI7oGbCv7tlHn9UyCnDxA9XLKLBAYBovYVcYQVx7UkaHtPITehsVBgsvVIf5dI8HietimZzZY3I/hEILNFOtgRqDWCpWrn6srXWqVbnMu7YiDsVV/C1Igfkh+jbYKQWLE6Ghl5qN6sXJMdYBNYXo17+0b6vcmwn1JJ+VbukyejD3uW23ZLFzXi7xKf4595ocJhkWKirExT3O42BHWaNEmVYna85e8wYZCodkAEnJ04NDBfN/ZtvrltDGlDr6KR8m3MQOmwNdBA8RTlrCPlkS7mgENv8iQv4Av9C81IQhZ/q/vdERVk1BTyu9FuztwltAeUn/ILzGhdPQ9fTwgxaXfC83XBXGqZHqHhuu9ovdW1syQQEl2csyRfE6gvqILD0ic4gMRcayv4HQ/XD4Rv9IJvWucZsC6vheWave1OB631B8k57pbJAuVHNKvm2IHB5LvWcj4AZIFVaZi3bTrCgwxIv/pS+bTkYl71ygBb0aLA/JWn0zHw6K01TToL7/a+tYN8g2qNudCotoz3m30A1siI+bK9WQcEh3LwgPGivSXSIlraBBtrrhQP5I7MqtWmSZsa9QU7YZjRpQNBD3V9MjAOzdxGVRgkSl6AvwdMunyR1u9blSUNhesGzg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(83380400001)(4326008)(86362001)(9686003)(2906002)(76116006)(110136005)(316002)(7696005)(38100700002)(54906003)(5660300002)(55016002)(33656002)(122000001)(8676002)(66556008)(53546011)(478600001)(6506007)(64756008)(66476007)(52536014)(186003)(966005)(8936002)(66446008)(66946007)(26005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?cUhtU0N1TlRPcXVqWHlET3A0NkU0a3ZDOFZlSlY0cWsxOXl4ZGZUZC95SWtF?=
 =?gb2312?B?VW94a0hrT2t0NDBuelVDamVxb1NhcFRmd3cyOTJpbTl1Zmg2ZjY0YjFPcFZY?=
 =?gb2312?B?UlpXSUpYeXN4M3I2SjlqL3ZabUZnRWU0MUFRcUdKdk1VblBtdEh5Mi9DeFB5?=
 =?gb2312?B?Mmo4YUYrcVJGcXVjSWN4dkNqV2JvaXZURzdyMkpnYlRxTzhNTDhwRnptTDFH?=
 =?gb2312?B?aTNXUU96UlFLMWNodm1OWWx1ek1uN0pIWDBNK005OHpCK1hiQVBBdWJ2Smoz?=
 =?gb2312?B?UnBIYWlwM2VJOFVhZmxhdmZnOHUrdkZGOUZScThvd0JQUWE3Y29nTjkzQnZB?=
 =?gb2312?B?VERnZ2lidTZpN0ZFaDhYVFZXbDZEVTNqMnBBSXBUczBLQ2pESUtPNmJvT0sx?=
 =?gb2312?B?SXdzSnlobDllM0RqUnNqcXJ4THZCMzkrUXlLWnRpZDNRdGhoZ3Y4ZGtNWFg3?=
 =?gb2312?B?TlpkbjlxbXhUQmlSME9SZ0htdVFjRHFhdjAyTWsyZEtzazJCVFhTOC9HMy9v?=
 =?gb2312?B?RUNNbitTQmJWOG5ZQ1pqejM2UncrT3F3S0pRV3h4ZEU1SEl6eEVDeUxBakl0?=
 =?gb2312?B?VWdKM3RrNERxV0NCckhzNGNRdzRIdHhRWVdRZkthR0JZRVE2L252QTdZUVQ5?=
 =?gb2312?B?N1Yvc3I2Y1BXalROcDQxdyt2MFM0a0JVOTFkMFpoTGJCQUF3a3E2dmJxUnBN?=
 =?gb2312?B?R1psd01IVkZkaHhTVHVoZHR5N0VqN2EyM1hxam9YZVFnRGFTZ2ZZRTNKWFlU?=
 =?gb2312?B?aTFpY0J3Mnpna0dMcWk3Si9vc2JKeURPMzdZYXNkRWxUMmtTMDZOUFM2RDBC?=
 =?gb2312?B?ZDhFK2xxV1AzOThkeTJHLzVCbHpsNTMybHIwdEJvalcrTWhJWkJUNUNZT1l3?=
 =?gb2312?B?MDdWUnVzOXdsdnpnTWZGSXZjTVg2aGZ4ejlHdkZjQWU2dmVJVGROd3lWOXp2?=
 =?gb2312?B?QlZZa0NkQngvWDdpc2NtdUx6Rjlkc2tTeFk2NlE0WXI3Q1V4WWdYQmpGTVNi?=
 =?gb2312?B?SDhsSFpiRzJSUE84OEtSRWpMMTZCYWNQVHZ4Ymk1Ymp4TjE0WVQ0emRROFVa?=
 =?gb2312?B?Zm5XckNSNFRuRmZlTkhJSnFhcmdwYjAybE9DbDFIdWx6OGNQTWlvZHovQWF0?=
 =?gb2312?B?bFpueWtyTitXU1BMdkdsaU1BTi84Q3FFSTdkcElVVlhZT1Y1UlRIUTBEeC9y?=
 =?gb2312?B?OVAzWFRaNG9Jek1zSjA3ZkI0ZU51RzN1UGpGYVRpeFlXYkdQSkNCcWJxWWJw?=
 =?gb2312?B?VndHNUVFWUVOdUVEbWlkTWkxQjVmNWFJK2RpN3JHb1BrY012SUtYWm5ZNG1B?=
 =?gb2312?B?eDJLNy93WlJyTks4TXdVMytwSjVCb1ZuM29ESUQxV1NpNGljWFJnRUhEWC9w?=
 =?gb2312?B?OU5FWTluNi9XNFgyYXdCUk1kU0g0MWNWWWRwenJ1Y3Y3elI1d2J2ZG4yNTcv?=
 =?gb2312?B?K0tNYW1QTTZ6ajE1ZEFleU9HZDdrY004dEpNUEs1Q084eXJGbE9pc3EyUXZS?=
 =?gb2312?B?aDdiZndGMmRYVXN3VWFiYS8ra1ltTGwwRnFoNHZuaThDdHpMNE5wTkk2K3hq?=
 =?gb2312?B?c1o1TU4zaFNubFhja1ZFdEZvc3ltY2VCK0N1OW5FQTFiWkFEQUpBeXJZeWE1?=
 =?gb2312?B?dldpYWNlNEF3VllyTU1rWTh4WDhPaVY4WXNRS1ZNRTdrd295RHdGT3Q0b1V6?=
 =?gb2312?B?d2hKWXBCa3RVOHhvTjRsbks2Mk5Lalh5d3V1YVM5a0tKSEJ0TDMrcHcxUWkr?=
 =?gb2312?Q?xff8mXP5Csy+6QFKkQ=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7c10c6-6142-4621-4e34-08d9347f27ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 06:38:18.3936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y7Mm00NPDod8nA300Yo7DcVw7yXmfbeFRXBv62/9rwfIuEOx3qhDeQ1O9NJMEc6CsbmgjHWfgladzsrToHH6vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5882
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMjHE6jbUwjIxyNUgMTQ6MjgNCj4gVG86
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgZnJpZWRlci5zY2hyZW1wZkBr
b250cm9uLmRlOw0KPiBhbmRyZXdAbHVubi5jaA0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14DQo+IDxsaW51eC1p
bXhAbnhwLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIFYzIG5ldC1uZXh0IDAvMl0gbmV0OiBmZWM6
IGZpeCBUWCBiYW5kd2lkdGggZmx1Y3R1YXRpb25zDQo+IA0KPiBUaGlzIHBhdGNoIHNldCBpbnRl
bmRzIHRvIGZpeCBUWCBiYW5kd2lkdGggZmx1Y3R1YXRpb25zLCBhbnkgZmVlZGJhY2sgd291bGQg
YmUNCj4gYXBwcmVjaWF0ZWQuDQo+IA0KPiAtLS0NCj4gQ2hhbmdlTG9nczoNCj4gCVYxOiByZW1v
dmUgUkZDIHRhZywgUkZDIGRpc2N1c3Npb25zIHBsZWFzZSB0dXJuIHRvIGJlbG93Og0KPiAJICAg
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvWUswQ2U1WXhSMldZYnJBb0BsdW5uLmNoL1Qv
DQo+IAlWMjogY2hhbmdlIGZ1bmN0aW9ucyB0byBiZSBzdGF0aWMgaW4gdGhpcyBwYXRjaCBzZXQu
IEFuZCBhZGQgdGhlDQo+IAl0LWIgdGFnLg0KPiAJVjM6IGZpeCBzcGFyc2Ugd2FyaW5pbmc6IG50
b2hzKCktPmh0b25zKCkNCg0KSG9wZSB0aGlzIHNwYXJzZSBpc3N1ZSBoYXMgYmVlbiBmaXhlZCwg
c2luY2UgSSBjYW4ndCB2ZXJpZmllZCBpdCBhdCBteSBzaWRlLg0KSSBmb2xsb3cgdGhlIHJlcHJv
ZHVjZSBzdGVwcyBwcm92aWRlZCBieSBrZXJuZWwgdGVzdCByb2JvdCwgYnV0IGZhaWxlZCB0byBy
ZXByb2R1Y2UsIHRoZXJlIGFyZSBtYW55IGVycm9ycyBjYXVzZWQgYnVpbGQgZmFpbHVyZSBhdCB0
aGUgYmVnaW5uaW5nLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gDQo+IEZ1Z2Fu
ZyBEdWFuICgxKToNCj4gICBuZXQ6IGZlYzogYWRkIG5kb19zZWxlY3RfcXVldWUgdG8gZml4IFRY
IGJhbmR3aWR0aCBmbHVjdHVhdGlvbnMNCj4gDQo+IEpvYWtpbSBaaGFuZyAoMSk6DQo+ICAgbmV0
OiBmZWM6IGFkZCBGRUNfUVVJUktfSEFTX01VTFRJX1FVRVVFUyByZXByZXNlbnRzIGkuTVg2U1gg
RU5FVCBJUA0KPiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWMuaCAgICAg
IHwgIDUgKysrDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYyB8
IDQzICsrKysrKysrKysrKysrKysrKysrLS0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDQzIGluc2Vy
dGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjE3LjENCg0K
