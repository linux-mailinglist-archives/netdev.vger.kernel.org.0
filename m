Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E5346B05B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhLGCBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:01:49 -0500
Received: from mail-eopbgr130075.outbound.protection.outlook.com ([40.107.13.75]:48261
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229889AbhLGCBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 21:01:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtChW/PNZ0nyDuyH5vfAGDd2tnVGo0FErwKtHXLEkwz0VZrtBA1fZllulPYCzSZTfBGUUNHKDZnPNS6DS3Xz0iY8gWuQq13mgYfbA6vIBc0Dm2XQ82KjYAK/RGtlNelwOQ6yKCCy8RCXEeuxdMlp68Uk0RCz+Uj6LJWDMhrtMI8FtZxeZwn4ekFcE7RxeCOIkT3BsmUxPcXFgxNEZvYg9AhgzlXJIpmcUqUOg6SExHy4NyDUgslh0LpOihbZcS7UAV61ioGR9X0QKpBefngV5BF2GIVWWDNPs/B5xqPLQZlYsr8fkamPN8iEugVZWxTaqNVnEkokNRwvi4kFQZsYrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38aPKriuU1EpgRLS2k+X67w/bb6nOM+2qXakY2yfBjs=;
 b=KbFL1iyoh8jn7ZhaNjJEGqARrII8py5C/hLz+DwIAX3xs92G8Z4chSDaHftIL8TRgC1KOWVVQHkWbrWoqfHkjYOl1GKM5aPvwRRNeaviNIHaHQZDMA5ruhkOqtyHzLrdtskR/USQBvDjhDcn4kAWDCoTBp0OSdiP+zAX1aftfvj+c61QTx5BNKMrWiGfiEJ9+RtJazTtl8wd3JnEojbL+tCZiwSdBcBuXrohXhebSbegAGIPxvmUjr6kGd2t7Vj7mE5suLB23C/PUJd8pPGEAbn2NECdfEXHPw0rfTsLrowvekvxN0ffytPO8kOQ0JtUrRKFBtOC19GpzNHH8KVdZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38aPKriuU1EpgRLS2k+X67w/bb6nOM+2qXakY2yfBjs=;
 b=o3/W2c4LYjkd55DAfl1RAiuSKNbE3c4tvmWr8JsJ267ltwhoptr8d8BJTzeJbmFsV3KsX29P+331wl96rRhOdixsEVTvUE5uFQkxEhhZpZtr85GQCztM6b0f6p6fZFQLSVcqB3TpqflybDMj+OwXLS9khrJm7/SzS6vBSrSTegA=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5883.eurprd04.prod.outlook.com (2603:10a6:10:b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 01:58:16 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 01:58:16 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Philippe Schenker <philippe.schenker@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 0/2] Reset PHY in fec_resume if it got powered down
Thread-Topic: [RFC PATCH 0/2] Reset PHY in fec_resume if it got powered down
Thread-Index: AQHX6on6kCIjYJK8wUqawclorkW7F6wmQ96g
Date:   Tue, 7 Dec 2021 01:58:16 +0000
Message-ID: <DB8PR04MB679536F1DD900564B9A957C4E66E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211206101326.1022527-1-philippe.schenker@toradex.com>
In-Reply-To: <20211206101326.1022527-1-philippe.schenker@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd7e26a9-dbc7-4d6b-e5c0-08d9b92508e0
x-ms-traffictypediagnostic: DB8PR04MB5883:EE_
x-microsoft-antispam-prvs: <DB8PR04MB5883C240901C1596402E043EE66E9@DB8PR04MB5883.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hmkigarFI5BGLjPAJUxkXWHH6i6Emu8/WrFaCEzwh3D/sruzf9XKBME82VgQC6lhVGBs8IK4/6ZX4ZIcgzScnhvNh5kOv+HsQWo2dWzzA3YDRJRNhrLiqfvdc9lNegcSwKC5CeykUtCzH4WWrh9W/vu+3PeeUObScXa5mfw5BNSAYftlzKDPvjCT2GkLXsSKwm1v0qiOx/45FoiPprHw7JpWY8GNTo4FGdqvKpU0JDhs/QDPOWCNQNPRJtSqSABFn+w2icb7kBp3r1qu44TypyZUAvL5aucBW+dX0UaG302s5FoBAu7o56yYyQnc+0H8JfGU26W5FdAiGLIscCHMEk3Mps7LBKrUowRYgEA+yiBQRl2lhlfZ3EAEs8fcY72vraU6y9afXB6Fdu7wOVsVgmShaceSyNkjkC8CbQAL1t5vY4ZexxjwjEbBWWxVsy2cQYcezDUoBvvteNFb/YmhyBNgO2hy3NnopPHSppZ63lkCUbPySPw9TBnDdu/dBV1mjLBwGfhMvv3UOn8zYBkQ8LWxIIaiTk5n1hIAYvd0kSPJ2aWg600T9XJjcZ90T3q1RzrowdPk28v+03IPkgW4mlPFQaF9MgXHZPnA6yT84Jd2vSVQph1o8OlU+iwP8vnZ4Q2vkLVAiGEHy51nsFIbVZrmzczgOyauQm9oEGr2pmkPMu1Y0oT4tn8O+1FKkfrOB5op9B1cPJwO4j8OfIyqGzv0xc6ibsnvKBdvD/JCw2WkU43QcefraN8ZuXjXuEAheuramADQKy+AAHlmRpECPVLgW1dNRIMg4sM0Q+SBNXM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(316002)(33656002)(4326008)(55016003)(966005)(5660300002)(8936002)(8676002)(110136005)(71200400001)(86362001)(26005)(53546011)(83380400001)(122000001)(52536014)(7696005)(66946007)(508600001)(6506007)(2906002)(38070700005)(76116006)(66446008)(66476007)(186003)(64756008)(66556008)(38100700002)(45080400002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?QVBwVGF0MVlEdjd4d3FpdkxYYUtuQmVOdkx2OEo2UzNrbW5vSGR3WDQ5WTVK?=
 =?gb2312?B?V2VnRnBibU9QMGNWenNTUmZIMjc5S2pJZmdPTm9GZ3VkSU1ZcUVnWGF5UUNF?=
 =?gb2312?B?Uk5xdzgxVGJ4R0lxOHdoUFJTMnlnTlh1bnNxbDVzZi9pOUxVS29WVDM2K0lD?=
 =?gb2312?B?d2d0YzBzY3J3aTdBb0o1dzQzM1B2QWRNZWtEZ3VVd0lwWWo4U2ZPSWNtb2x4?=
 =?gb2312?B?SENvMURuRFp0WWtBTlVQRVVkdXJaRUdVS1RhQTMrZjZaQVBxbERvTmd0U290?=
 =?gb2312?B?YlRvYXVVUnBtMXluUHpKTFFNTE5hMVF6ZXRtR3Zqc2Vxc1B1OUwrQ3BxRXdv?=
 =?gb2312?B?MzF4NU4xcXNLa1lKdDNSeUczZmFwa0dEZUJadEkxc0Jyc3Z1bm1hSXpsVm5K?=
 =?gb2312?B?VjcyNW5ZZ2ZkR1A3SGJ3QSsxM21rNVJaREpHMVlvQXpnaE9EQ1VBdU9oYzg0?=
 =?gb2312?B?ZVRRN1A2RlVsM2VrTmlwZmlrRFd3dmJJRUZIYW9DZU9nMUpoN1pUclgweHRX?=
 =?gb2312?B?d2JLNjNkaDdhOVpaZmJPdGRKTDdROFk1bE9uNlRpd2ZmNGlSOVpUUExZQmtn?=
 =?gb2312?B?dDdVRG8xQzI1bE1CNXJVVm1GcTNtd0J5MzdxSW0xNEg1UmxjaTZLRTdicnNu?=
 =?gb2312?B?V1FWWU5lUlprT094dERRNkZpL3NhbjJPOGw1bnhXbVpjd09ockxyREdwMkdN?=
 =?gb2312?B?TklHbmhJQlJrRnJmZkpXVUQ1OGhIWlc4a1BGYUdKUHphK0tCdndSd3BXT0hR?=
 =?gb2312?B?aGJjOGU0Y2hiYUlQQ2NNV2t6OS9xc044WWQwM3B1cjVxTHB3VFlyMWkzcGx1?=
 =?gb2312?B?R3FrUUN5WEpGeWJ2Z21yS3ByS2lNNjBlYjBlb205K3pxS082cGp3V0FmSHRY?=
 =?gb2312?B?dzFXZHFIdzJTYU50T2tmdXhEQnBsT3BPTFFKZWxrWjlPSFJxeVJ4TkZiSldZ?=
 =?gb2312?B?eVJqQnlhYXA0M01qOWY5LzJtdlZjVGc1QTA1bEtlV1BjZFJBdlV3ZE1sbFc3?=
 =?gb2312?B?ZW02bHpRVzJNbXYzU09oWVFJS2lvSndyNFFQTno3eVM5Y2M0dFk1ZmdaYUVD?=
 =?gb2312?B?SHZkTnRHS3NvaEwrZFJDOUY2ZEVmTVowUFhQSTd3NXdGUFdSVlkxUm1ZcldG?=
 =?gb2312?B?Z3I2T3RoTUFmOU1iSVZ4K1NHQVh6QkpsU012MjBoMnJSaHU5S2ZoL3RWYjBr?=
 =?gb2312?B?c083WkNjQzJydHNZczF5a1o5czFXOHBKTldmSWorZm1WdTJlUkQwVE5zSnNZ?=
 =?gb2312?B?SFEyM0Y3ODhUVG02S293M1E3MUNVcWlwZVAxK1lYbVE0KzcrcEVsRDFJV3No?=
 =?gb2312?B?SmNDZWJqRTFEKzc4OExWMi9xVmhYVUlOUlN1akJaZkVweis5YVdBMmRoRWFq?=
 =?gb2312?B?L1VGVU9BL0JJblJaQjJKRU81TkowaHpNTHNzSEExMGZGeUYvd2tkSmdkZy9D?=
 =?gb2312?B?NU9TQnV0M3YzdjM5K1llbW00bElEMzlnT1Jwb1cyN3RvUXBsTTNKbnhoQUU2?=
 =?gb2312?B?dXVCUXg5SE5vamhlbzNyRFhlaU9LWlp1a21SSEdreUFoa0k5c1hRUGkrRUZt?=
 =?gb2312?B?bWtWN0ZLN05tenkrbFZiMkxDZXd5R05RbGlmV2JTVUVHY0hZRXgzcW1MdzVI?=
 =?gb2312?B?WlIrVkcrOW8vY284eHFjdTNvNjMzbXlpTGF0QzQ3ZXZQKzZ2QUw1eUJwTDZI?=
 =?gb2312?B?L3ZXTWw3TXpvT1hxcFBhK2loN0V5dUd0MXBIc0RycU5pUmFMbkY3NVNhMWhj?=
 =?gb2312?B?MDA2aFQ5UVg4SWFDRDFYOGwrL25GbkEvaXNKNDBleW1SaDJNSXZjYXI2UFlL?=
 =?gb2312?B?Nno0c1JXY2RsT1dGcXJZdXhzN0ZYb1hSbGk1bTJZSE92bVJKeVozZFBzc3RN?=
 =?gb2312?B?MGZQejUydjhTSzVTUTVWK2dEYkU3ZEEyVVUzTjI4V3EweEdrL3h6YmxzMndG?=
 =?gb2312?B?WHZVb1QyTHJWemRqa3h2a2xoelVmZ3FNNndBUXpYWFYzYjFQelZzNmduWGNE?=
 =?gb2312?B?ZXVIUDVRajNoOVVveTJDRElNUzBrVjRTakptRU5EZjZDWDhHdlIwY3NCMFdY?=
 =?gb2312?B?WEx6MnF0MzBmaFdVbU00R1pEUUEzb0RPZnlEd1oxWW4wTHhSZ0dvWHBpUVQx?=
 =?gb2312?B?cXJ2cmFlS3NNV3hRSFRtZmV3dnNBYzJFQ2NGT2tPRDdPcTZIUXZNdGZNZDBs?=
 =?gb2312?B?aUE9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7e26a9-dbc7-4d6b-e5c0-08d9b92508e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 01:58:16.2246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FAOWWBisP6cFxkezhYvyRUvyfCZZY4Yx/6JLApOiW2LkVD0e29HEIDn6FbU68PvIh+MKKrodHhdyDEh/qr/W1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5883
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBQaGlsaXBwZSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQ
aGlsaXBwZSBTY2hlbmtlciA8cGhpbGlwcGUuc2NoZW5rZXJAdG9yYWRleC5jb20+DQo+IFNlbnQ6
IDIwMjHE6jEy1MI2yNUgMTg6MTMNCj4gVG86IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IEpvYWtp
bSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+Ow0KPiBGYWJpbyBFc3RldmFtIDxmZXN0
ZXZhbUBnbWFpbC5jb20+OyBGdWdhbmcgRHVhbg0KPiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT47IERh
dmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBSdXNzZWxsDQo+IEtpbmcgPGxp
bnV4QGFybWxpbnV4Lm9yZy51az47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IEpha3Vi
DQo+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IENjOiBQaGlsaXBwZSBTY2hlbmtlciA8
cGhpbGlwcGUuc2NoZW5rZXJAdG9yYWRleC5jb20+Ow0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFtSRkMgUEFUQ0ggMC8yXSBSZXNldCBQSFkgaW4gZmVjX3Jlc3Vt
ZSBpZiBpdCBnb3QgcG93ZXJlZCBkb3duDQo+IA0KPiANCj4gSWYgYSBoYXJkd2FyZS1kZXNpZ24g
aXMgYWJsZSB0byBjb250cm9sIHBvd2VyIHRvIHRoZSBFdGhlcm5ldCBQSFkgYW5kIHJlbHlpbmcN
Cj4gb24gc29mdHdhcmUgdG8gZG8gYSByZXNldCwgdGhlIFBIWSBkb2VzIG5vIGxvbmdlciB3b3Jr
IGFmdGVyIHJlc3VtaW5nIGZyb20NCj4gc3VzcGVuZCwgZ2l2ZW4gdGhlIFBIWSBkb2VzIG5lZWQg
YSBoYXJkd2FyZS1yZXNldC4NCj4gVGhlIEZyZWVzY2FsZSBmZWMgZHJpdmVyIGRvZXMgY3VycmVu
dGx5IGNvbnRyb2wgdGhlIHJlc2V0LXNpZ25hbCBvZiBhIHBoeSBidXQNCj4gZG9lcyBub3QgaXNz
dWUgYSByZXNldCBvbiByZXN1bWUuDQo+IA0KPiBPbiBUb3JhZGV4IEFwYWxpcyBpTVg4IGJvYXJk
IHdlIGRvIGhhdmUgc3VjaCBhIGRlc2lnbiB3aGVyZSB3ZSBhbHNvIGRvbid0DQo+IHBsYWNlIHRo
ZSBSQyBjaXJjdWl0IHRvIGRlbGF5IHRoZSByZXNldC1saW5lIGJ5IGhhcmR3YXJlLiBIZW5jZSB3
ZSBmdWxseSByZWx5DQo+IG9uIHNvZnR3YXJlIHRvIGRvIHNvLg0KPiBTaW5jZSBJIGRpZG4ndCBt
YW5hZ2UgdG8gZ2V0IHRoZSBuZWVkZWQgcGFydHMgb2YgQXBhbGlzIGlNWDggd29ya2luZyB3aXRo
DQo+IG1haW5saW5lIHRoaXMgcGF0Y2hzZXQgd2FzIG9ubHkgdGVzdGVkIG9uIHRoZSBkb3duc3Ry
ZWFtIGtlcm5lbA0KPiB0b3JhZGV4XzUuNC0yLjMueC1pbXguIFsxXSBUaGlzIGtlcm5lbCBpcyBi
YXNlZCBvbiBOWFAncyByZWxlYXNlDQo+IGlteF81LjQuNzBfMi4zLjAuIFsyXSBUaGUgYWZmZWN0
ZWQgY29kZSBpcyBzdGlsbCB0aGUgc2FtZSBvbiBtYWlubGluZSBrZXJuZWwsDQo+IHdoaWNoIHdv
dWxkIGFjdHVhbGx5IG1ha2UgbWUgY29tZm9ydGFibGUgbWVyZ2luZyB0aGlzIHBhdGNoLCBidXQg
ZHVlIHRvDQo+IHRoaXMgZmFjdCBJJ20gc2VuZGluZyB0aGlzIGFzIFJGQyBtYXliZSBzb21lb25l
IGVsc2UgaXMgYWJsZSB0byB0ZXN0IHRoaXMgY29kZS4NCj4gDQo+IFRoaXMgcGF0Y2hzZXQgYWlt
cyB0byBjaGFuZ2UgdGhlIGJlaGF2aW9yIGJ5IHJlc2V0dGluZyB0aGUgZXRoZXJuZXQgUEhZIGlu
DQo+IGZlY19yZXN1bWUuIEEgc2hvcnQgZGVzY3JpcHRpb24gb2YgdGhlIHBhdGNoZXMgY2FuIGJl
IGZvdW5kIGJlbG93LCBwbGVhc2UNCj4gZmluZCBhIGRldGFpbGVkIGRlc2NyaXB0aW9uIGluIHRo
ZSBjb21taXQtbWVzc2FnZXMgb2YgdGhlIHJlc3BlY3RpdmUNCj4gcGF0Y2hlcy4NCj4gDQo+IFtQ
QVRDSCAyLzJdIG5ldDogZmVjOiByZXNldCBwaHkgaW4gcmVzdW1lIGlmIGl0IHdhcyBwb3dlcmVk
IGRvd24NCj4gDQo+IFRoaXMgcGF0Y2ggY2FsbHMgZmVjX3Jlc2V0X3BoeSBqdXN0IGFmdGVyIHJl
Z3VsYXRvciBlbmFibGUgaW4gZmVjX3Jlc3VtZSwNCj4gd2hlbiB0aGUgcGh5IGlzIHJlc3VtZWQN
Cj4gDQo+IFtQQVRDSCAxLzJdIG5ldDogZmVjOiBtYWtlIGZlY19yZXNldF9waHkgbm90IG9ubHkg
dXNhYmxlIG9uY2UNCj4gDQo+IFRoaXMgcGF0Y2ggcHJlcGFyZXMgdGhlIGZ1bmN0aW9uIGZlY19y
ZXNldF9waHkgdG8gYmUgY2FsbGVkIG11bHRpcGxlIHRpbWVzLiBJdA0KPiBzdG9yZXMgdGhlIGRh
dGEgYXJvdW5kIHRoZSByZXNldC1ncGlvIGluIGZlY19lbmV0X3ByaXZhdGUuDQo+IFRoaXMgcGF0
Y2ggYWltcyB0byBkbyBubyBmdW5jdGlvbmFsIGNoYW5nZXMuDQo+IA0KPiBbMV0NCj4gaHR0cHM6
Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHAlM0ElMkYl
MkZnaXQudG9yDQo+IGFkZXguY29tJTJGY2dpdCUyRmxpbnV4LXRvcmFkZXguZ2l0JTJGbG9nJTJG
JTNGaCUzRHRvcmFkZXhfNS40LTIuMy54DQo+IC1pbXgmYW1wO2RhdGE9MDQlN0MwMSU3Q3FpYW5n
cWluZy56aGFuZyU0MG54cC5jb20lN0NmM2MxMzhlZDkyMzINCj4gNGE4ZDc1ZTcwOGQ5YjhhMTFi
OWElN0M2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJQ0KPiA3QzYzNzc0
MzgyNDM2NDE5MzQyMyU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3DQo+
IE1EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAw
MCZhbXA7c2RhDQo+IHRhPUJ3JTJCWmRxaEFqUFhxS0pGWkNYcDBtdElkMXg5bWtYNmY2TVcya3k2
VTF3dyUzRCZhbXA7cmVzDQo+IGVydmVkPTANCj4gWzJdDQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxp
bmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRnNvdXJjDQo+IGUu
Y29kZWF1cm9yYS5vcmclMkZleHRlcm5hbCUyRmlteCUyRmxpbnV4LWlteCUyRmxvZyUyRiUzRmgl
M0RpbXhfDQo+IDUuNC43MF8yLjMuMCZhbXA7ZGF0YT0wNCU3QzAxJTdDcWlhbmdxaW5nLnpoYW5n
JTQwbnhwLmNvbSU3Q2YzYzEzDQo+IDhlZDkyMzI0YThkNzVlNzA4ZDliOGExMWI5YSU3QzY4NmVh
MWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDDQo+IDAlN0MwJTdDNjM3NzQzODI0MzY0MTkz
NDIzJTdDVW5rbm93biU3Q1RXRnBiR1pzYjNkOGV5SldJam9pTQ0KPiBDNHdMakF3TURBaUxDSlFJ
am9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTENKWFZDSTZNbjAlM0QlN0MzMDAwDQo+ICZhbXA7
c2RhdGE9b2Y5ejloZlZoSGFrVlNjTHhDZEVvJTJCWG1kMkI5QWQ5WDhScnk2R2pFWkU0JTNEJmEN
Cj4gbXA7cmVzZXJ2ZWQ9MA0KPiANCg0KSW4gZmVjIGRyaXZlciwgaXQgaGFzIHN1cHBvcnRlZCBo
YXJkd2FyZSByZXNldCBmb3IgUEhZIHdoZW4gTUFDIHJlc3VtZSBiYWNrLA0KDQpmZWNfcmVzdW1l
KCkgLT4gcGh5X2luaXRfaHcoKSAtPiBwaHlfZGV2aWNlX3Jlc2V0KCkgZGUtYXNzZXJ0IHRoZSBy
ZXNldCBzaWduYWwsIHlvdSBvbmx5IG5lZWQgaW1wbGVtZW50DQp0aGUgcHJvcGVydGllcyB3aGlj
aCBQSFkgY29yZSBwcm92aWRlZC4NCg0KSSB0aGluayB5b3Ugc2hvdWxkIG5vdCB1c2UgZGVwcmVj
YXRlZCByZXNldCBwcm9wZXJ0aWVzIHByb3ZpZGVkIGJ5IGZlYyBkcml2ZXIsIGluc3RlYWQgdGhl
IGNvbW1vbg0KcmVzZXQgcHJvcGVydGllcyBwcm92aWRlZCBieSBQSFkgY29yZS4NCg0KUGxlYXNl
IGNoZWNrIHRoZSBkdC1iaW5kaW5ncyBmb3IgbW9yZSBkZXRhaWxzOg0KRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2wsZmVjLnlhbWwNCkRvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvZXRoZXJuZXQtcGh5LnlhbWwNCg0KQmVzdCBSZWdhcmRzLA0KSm9h
a2ltIFpoYW5nDQo+IFBoaWxpcHBlIFNjaGVua2VyICgyKToNCj4gICBuZXQ6IGZlYzogbWFrZSBm
ZWNfcmVzZXRfcGh5IG5vdCBvbmx5IHVzYWJsZSBvbmNlDQo+ICAgbmV0OiBmZWM6IHJlc2V0IHBo
eSBpbiByZXN1bWUgaWYgaXQgd2FzIHBvd2VyZWQgZG93bg0KPiANCj4gIGRyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9mZWMuaCAgICAgIHwgIDYgKysNCj4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jIHwgOTggKysrKysrKysrKysrKysrKy0tLS0tLS0NCj4g
IDIgZmlsZXMgY2hhbmdlZCwgNzMgaW5zZXJ0aW9ucygrKSwgMzEgZGVsZXRpb25zKC0pDQo+IA0K
PiAtLQ0KPiAyLjM0LjANCg0K
