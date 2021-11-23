Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E8045A072
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 11:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhKWKnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 05:43:07 -0500
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:18787
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229924AbhKWKnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 05:43:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ox9KuQ+8su9kV8qBmL6HkJeaX4ZQb2dys1qkIWsB8HOCeQBh9ERWSFcBYp+tQci8JnQNg9hg7pbvuApmltwzNS/ku5jv2KjUnwaRpHgclNJSzQwqYGHX+1LkIDc37BpaweQYWRIVxqIzegQqCcWa5CSuNo3JO4oabqtyelCbVr2eYbK+lW8LEMy4L9IOo2Vbn2ehOcBKGDm2ZF9oxV7JchFmo0b2W8+Pp7lX4xaYTdbAa7LkweEjP42HP5dnUjB6RRB4LkoKlfXvBMeahUdwrmB+uRnOlXbA6YC1e7CDa465/vNpnMay/3/RQF+15g7bJ6+uDU2nBZRWpIFjvjvMJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pj/KV9yU8GiMSB4KGmYeNe53yc/oOeh1jYnGEYIVYUk=;
 b=WIG1e1i7rnQskRPQjZ88XSeYR9caCNidWLlM2zJyOBAUcqy0JjZH1kKIya8dj6ggTwyk6u4YDnliIDn/tI7zymwzYiR7BkGSMqb0COf1OKF3hpwYtMi1GxQLAXggJ9nDsSscVJUujiU1jSHpgGvJGRz5OIUpVql+nqo9/Siq2y2VoMfL1gxbHRQQ7kGEHI6gfS/bLxcO8DvHgk6vNw/kvn8As5bv9QRTpqUdQ7ccq//YgKKt5ng3VfSMOqXHwnIzpSh/pMXJ3PgO4sN4CrNR/DdXzXrDw0cuWOLv+wkj0iI9d58cFS9bRQgUZgCmtZUGtGnxW8pQCQv3dWkIpDYl8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pj/KV9yU8GiMSB4KGmYeNe53yc/oOeh1jYnGEYIVYUk=;
 b=OjdKZXo54TpUB7jWX1VyRiICa/uNuJfGY2JP3Idl0ftUL7gOZukTWFDQCmjTdjblcEpVChaCk8F+8+aYajgyy6g+9xMVVnL3D1XDOOaee4tKQ5TsSVbcOQ7xbG6VjtyE/a8oHtSWhK4tM4Z4Mowqpxriqc079WpNRtQjdqmxViA=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6970.eurprd04.prod.outlook.com (2603:10a6:10:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 10:39:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 10:39:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Peng Fan <peng.fan@nxp.com>,
        "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/4] dt-bindings: net: fec: simplify yaml
Thread-Topic: [PATCH 1/4] dt-bindings: net: fec: simplify yaml
Thread-Index: AQHX3gYPxfkSynkPv0KAVqfC2LReCawOxhvQgAIXDwCAAApJQA==
Date:   Tue, 23 Nov 2021 10:39:52 +0000
Message-ID: <DB8PR04MB6795F9F553D1B89E45998A4FE6609@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
 <20211120115825.851798-2-peng.fan@oss.nxp.com>
 <DB8PR04MB6795E60F4D2CED35569CBFA7E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DU0PR04MB9417842B67DE3FC3C28B120788609@DU0PR04MB9417.eurprd04.prod.outlook.com>
In-Reply-To: <DU0PR04MB9417842B67DE3FC3C28B120788609@DU0PR04MB9417.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63a55800-a1eb-4fa1-6d83-08d9ae6d9543
x-ms-traffictypediagnostic: DB8PR04MB6970:
x-microsoft-antispam-prvs: <DB8PR04MB69700B180104F127928FF93DE6609@DB8PR04MB6970.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDcs7lj9YgE2LcE/fqG5vwZPYi0MbX0tlNkZgUM8gpo9qc2NKUf9quW07BD+X1MTnK9lvHfXncfwsTGMJLG18Kh3me4Yp7P6SA5wcMBjrnG93+5BnstuXXn57ApzgEd8lOykhnwesioLfJMrV3QpEnIZSYdT4r9swntA8qyp2aW7Pt/4h1GhBSl+a13SKk5vUJ4pxhUZlHhYo0QkyBvNe4y5EX7Clu/rd/bS/44pULNfedPkc3URjPeC7twRZIIwPIgEQ1TmdxfHtkMmqqNoJJOFIABXn+JuO6TddeVAwqnKdEK3UwEICf0ZB3psJZe0PlQnTu8HjQOdjk/fx1mVXxBjsZDrzXg/J4keZNr4ynmKrNUGlUmNOMuNEFujVyDuYbfS/7JpGxuia0abW4C1H2vo9XRWezaY1Xqr/B8LQkbpuDJJmueYdHDvIv/MXlMN00XojFhP3Dr2o1NRYVXNo9H1A5NBLkvvvIzPeNZeCzNtFGKXOGvlIyf0MllxXl7laKvJDBUUk7q1v0DX0EJwcgWr7Bkpju1d5CZpZqoybTK8lJwvvRrc90h8LvN6R/Ub246ug9lc+/ijUIOiBK/MAvpbtlARRXkNNuJY3zA6G8Xo6p9MlZjpuzTSbGLzrIF2oRjqE7lTkIJOiJK+XBSoeTUYIhfvGQ1nX+WmE4WkpQLiELpxiw659WdYlRpLwzAAqQMwWNI+iCJe1/RXLcxL5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(5660300002)(508600001)(26005)(4326008)(55016003)(76116006)(6506007)(2906002)(9686003)(83380400001)(38070700005)(64756008)(71200400001)(66446008)(122000001)(8676002)(316002)(110136005)(7416002)(53546011)(86362001)(54906003)(7696005)(186003)(66946007)(38100700002)(66556008)(52536014)(66476007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?ZTl2ajRsNGZUTVhKN1UrcnpJcnVWWU43Ung5UU9EeHFjZkVPeWVGSjF4SlFD?=
 =?gb2312?B?L1BZaVhGRWV3SitoUlptdlAwKzdQcUFMR2JzUk5tdzk5NEdQZ016cXNLSGZD?=
 =?gb2312?B?WkxHa1BrR0lJOS9iWXd0WUJZdGh1TVFuWDliUmFWV0J0ck1xM3ladm4wL3BC?=
 =?gb2312?B?UDFwYTUwcUdQV2J2NmpLZTVaTWJUTnhNa0JycHdGYlVIaVZFSXMzdEtSQzI0?=
 =?gb2312?B?UTR1dlNBUmd1TUZkaTUxbTBBdzM3Qmp3NHBmdWR6aUJPVjFOUlQyQUQzcUtR?=
 =?gb2312?B?Y2pQMzVqSDZXMWRNY0U0VElEVzAxVHdmSmRrQTVUbnVlVzR4UXVLbEtjTndh?=
 =?gb2312?B?bGQ0MzkwdmFBWlk1R0pqelA2cDdJaG9nU1pPeTN2d01LcDVLLzhPUHpuSGdN?=
 =?gb2312?B?djFFV1hpRjVrV3cxYTNyM3BUT2JvQXFMUzVSMExTVE5hVkJRbnFodVFWZFpr?=
 =?gb2312?B?OTRUZmZKQ1JCbStsczZORG8wOVFwQXkrTG01WW81ellqdDgxSVRiUXhQYS9T?=
 =?gb2312?B?V0pJd0MyeVNWakdINksvSk16WkU4aER3SnBSTUFyL1hSb2VvZnpqdnVOTTZH?=
 =?gb2312?B?aXZKWWtyb1ZBRG9BaXFNb0x4eE9JQlhITVBMZ1M4cGZrM01ERy95N2t4SnRS?=
 =?gb2312?B?SU9qd1hWNjhsUlFwemFpa1NQWWt0QU92d1FKSE9PUlB5U2RrVUhhcFNqV29x?=
 =?gb2312?B?THFESVZXalVLRy9zTWRKMWNvU281QlF3RGFUMTFFT1A5SGIza3YvSkJMUnlP?=
 =?gb2312?B?OVh6b0hTMFBZRHZTYzk5YWQ4YWs1dXNTTEJKK0FRWjB1Um1vc0VDazluQ3VW?=
 =?gb2312?B?WUc3aG1sZ2VzdjV0ZEZEbzh3THBhTHhYeTkwWVQvV1M5RlF2ZC9xRzA0ajRN?=
 =?gb2312?B?RGwxQUt0aFQySFNTT1VYQktEQnlaZldIVXYrTDcxaCt0UlNOZEpaM01EUzdN?=
 =?gb2312?B?QUNCcjNVNGNuWkdGb0JCcGRhWG9zQ0loRUhBVEFYazVzaFdGZ1dQNFpOWkx1?=
 =?gb2312?B?WUgrZGczWmZsWDVHRVpvT2UyK0FmbjZVcXhDOTBKUjNxT25DaFF4cFh1OUIy?=
 =?gb2312?B?L0NKM01BN3R6ejBUVUtqdFpnMzBEQktueHd3NDRVc2VpbjdnNUlpelhhMlNz?=
 =?gb2312?B?eEJJQ3NJRmdZcDQvc3VFSmR0ZjZvWVRVb1JTVkltTTllS1J2RGMxMlo1QnJy?=
 =?gb2312?B?RUFYd3ZiZFB2U0tGRWVkMGxQbHlNYVJCOEVUbWdLNmJBelVGcWlOZWFrMDBn?=
 =?gb2312?B?OXBoOVE4TEUrNytGSTU3ck1KTXMxeTBuTjg4enh2cVpHZFZ0SktDK0JKamVv?=
 =?gb2312?B?cHdRWXZCYnZoMy9DaVFDRWZVYnh3dHpJbEpmMk5vZkF1U1NNTVhiNVp4VXBN?=
 =?gb2312?B?TDZFWVVsUmxSMEw2UjBUem1WS0VDMDB0ZVEvM1U1bUZCcHV2MXhzMS8wRGNo?=
 =?gb2312?B?dkpBaTJBeUI4cG1qTVRjRG9oZTl5dVlGcnp4UU1PVWhJZ2VyM2E3cVFxaDRy?=
 =?gb2312?B?Ykkwdlg2cVJIcXJ3SXRjU0ZRZFJBMHRlOGJoNExqTW5qT0pVMmlsUTJHSUJZ?=
 =?gb2312?B?UlMzdHlYZVBIRXd2Yy9pV3ZZeWlPNGhJN1dVWUZmR1hPRElpMS9pcXlVQ3dq?=
 =?gb2312?B?NDU1N0Rnd2llQ2Z1Ym9rcUtVbXhBTWYzVjVENHNDeU00VnNFZlp1MlFRK2pj?=
 =?gb2312?B?KzNvRmVZMnFtbmNQNm50cms2NlNoc0sybGNKZ0hCem82dDRZUDM5dEFLT0t3?=
 =?gb2312?B?QTJ2L2lrQ01Sb2EvejlnN2RmYnpSMHdtRTJpR25iNkwveDRhLzdDWUJIUjZk?=
 =?gb2312?B?Rnc5d2JuQ0ExMVMwYVFaR2dQamlGUUxGc2tjbmswakQvdFdFVGpuVm5jMGJr?=
 =?gb2312?B?QXVnK3llcnR0TTRzZ1hvK3d2WXViLzEvUXdxRExYL2VmL3YzaW1tNmdBV0FZ?=
 =?gb2312?B?NnNmRGtlNGpld3RSWkNRWkFxY2FZSW45Ylo2RWlGbVR6aldzZEtsMjI4TVQ4?=
 =?gb2312?B?U1lHK3VyQzRFZ0w5bnFpaFEyYzQzcFVybU01cHFkdkJuMDVXbnB1Mno0N2JD?=
 =?gb2312?B?amlNSFB5NENQQzJnSitwMm5sV08xb0d5cDBDSEJsa0c4Y3V4RnpQQmR2UkxH?=
 =?gb2312?B?WE9ZMU43cDNCN2h1VGRnSHFWQ2txbXBXOS9zeXlKWmMwM2UzbDJYSThvZU93?=
 =?gb2312?Q?ohv7aA2gTH9PQz19BOBSLso=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a55800-a1eb-4fa1-6d83-08d9ae6d9543
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 10:39:52.7572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BXcZAH+T3J6XCaTx2AgCD6JXyRNC9N0LY77hiE7FRvZzyAK4yfYCeRJbUJJq46ppsjaHSMw3Qg5nmoxGNu57Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6970
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBQZW5nLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBlbmcg
RmFuIDxwZW5nLmZhbkBueHAuY29tPg0KPiBTZW50OiAyMDIxxOoxMdTCMjPI1SAxNzoyOQ0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IFBlbmcgRmFuIChPU1Mp
DQo+IDxwZW5nLmZhbkBvc3MubnhwLmNvbT47IHJvYmgrZHRAa2VybmVsLm9yZzsgQWlzaGVuZyBE
b25nDQo+IDxhaXNoZW5nLmRvbmdAbnhwLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFA
a2VybmVsLm9yZzsNCj4gc2hhd25ndW9Aa2VybmVsLm9yZzsgcy5oYXVlckBwZW5ndXRyb25peC5k
ZQ0KPiBDYzoga2VybmVsQHBlbmd1dHJvbml4LmRlOyBmZXN0ZXZhbUBnbWFpbC5jb207IGRsLWxp
bnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0K
PiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZzsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnDQo+IFN1YmplY3Q6IFJF
OiBbUEFUQ0ggMS80XSBkdC1iaW5kaW5nczogbmV0OiBmZWM6IHNpbXBsaWZ5IHlhbWwNCj4gDQo+
ID4gU3ViamVjdDogUkU6IFtQQVRDSCAxLzRdIGR0LWJpbmRpbmdzOiBuZXQ6IGZlYzogc2ltcGxp
ZnkgeWFtbA0KPiA+DQo+ID4NCj4gPiBIaSBQZW5nLA0KPiA+DQo+ID4gVGhhbmtzIGEgbG90IGZv
ciBoZWxwaW5nIHVwc3RyZWFtIHRoaXMgcGF0Y2ggc2V0Lg0KPiA+DQo+ID4gRm9yIHRoaXMgY2hh
bmdlLCBoYXZlIHlvdSBydW4gJ21ha2UgZHRic19jaGVjayc/IEkgcmVtZW1iZXIgdGhhdCBzcGxp
dA0KPiA+IHRoZW0gdG8gcGFzcyBkdGJzX2NoZWNrIHdoZW4gY29udmVydCBpdCBpbnRvIHlhbWwu
DQo+IA0KPiAiIGFyY2gvYXJtL2Jvb3QvZHRzL2lteDZkbC1uaXRyb2dlbjZ4LmR0LnlhbWw6DQo+
IGV0aGVybmV0QDIxODgwMDA6IE1vcmUgdGhhbiBvbmUgY29uZGl0aW9uIHRydWUgaW4gb25lT2Yg
c2NoZW1hOiAiDQo+IA0KPiBCdXQgdGhpcyBpcyBub3QgaW50cm9kdWNlZCBieSBteSBwYXRjaCwg
aXQgYWxyZWFkeSB0aGVyZSBldmVuIGRyb3AgbXkgcGF0Y2guDQo+IA0KPiBJIG5vdCBzZWUgb3Ro
ZXIgaXNzdWVzLg0KDQoNCkZvciB0aGlzIGVycm9yOiBldGhlcm5ldEAyMTg4MDAwOiBNb3JlIHRo
YW4gb25lIGNvbmRpdGlvbiB0cnVlIGluIG9uZU9mIHNjaGVtYToNCg0KVGhpcyBpcyBjYXVzZWQg
YnkgWydpbnRlcnJ1cHRzJ10gYW5kIFsnaW50ZXJydXB0cy1leHRlbmRlZCddLCB0aGlzIHNob3Vs
ZCBiZSBhIGNvbW1vbiBsaW1pdGF0aW9uLCB0aGlzIGlzIGEga25vd24gd2FybmluZy4gDQogICAg
ICAgICAnb25lT2YnOiBbeydyZXF1aXJlZCc6IFsnaW50ZXJydXB0cyddfSwNCiAgICAgICAgICAg
ICAgICAgICB7J3JlcXVpcmVkJzogWydpbnRlcnJ1cHRzLWV4dGVuZGVkJ119XSwNCg0KQWZ0ZXIg
YXBwbHlpbmcgdGhpcyBwYXRjaCwgSSB2ZXJpZmllZCBvbiBib3RoIGFybSBhbmQgYXJtNjQgcGxh
dGZvcm1zLCBpbmRlZWQgdGhlcmUgaXMgbm8gcmVncmVzc2lvbiB0YXJnZXRzIHRvIFsnY29tcGF0
aWJsZSddLiBJIGFtIG9rYXkgd2l0aCB0aGlzIHBhdGNoLCBzb3JyeSBmb3IgdGhpcyBpbmNvbnZl
bmllbmNlLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gVGhhbmtzLA0KPiBQZW5n
Lg0KPiANCj4gPg0KPiA+IEJlc3QgUmVnYXJkcywNCj4gPiBKb2FraW0gWmhhbmcNCj4gPiA+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBQZW5nIEZhbiAoT1NTKSA8cGVu
Zy5mYW5Ab3NzLm54cC5jb20+DQo+ID4gPiBTZW50OiAyMDIxxOoxMdTCMjDI1SAxOTo1OA0KPiA+
ID4gVG86IHJvYmgrZHRAa2VybmVsLm9yZzsgQWlzaGVuZyBEb25nIDxhaXNoZW5nLmRvbmdAbnhw
LmNvbT47DQo+IEpvYWtpbQ0KPiA+ID4gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPiBrdWJhQGtlcm5lbC5vcmc7DQo+ID4gPiBzaGF3bmd1
b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1dHJvbml4LmRlDQo+ID4gPiBDYzoga2VybmVsQHBl
bmd1dHJvbml4LmRlOyBmZXN0ZXZhbUBnbWFpbC5jb207IGRsLWxpbnV4LWlteA0KPiA+ID4gPGxp
bnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gPiA+IGRldmljZXRy
ZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiA+ID4g
bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBQZW5nIEZhbiA8cGVuZy5mYW5A
bnhwLmNvbT4NCj4gPiA+IFN1YmplY3Q6IFtQQVRDSCAxLzRdIGR0LWJpbmRpbmdzOiBuZXQ6IGZl
Yzogc2ltcGxpZnkgeWFtbA0KPiA+ID4NCj4gPiA+IEZyb206IFBlbmcgRmFuIDxwZW5nLmZhbkBu
eHAuY29tPg0KPiA+ID4NCj4gPiA+IGkuTVg3RCwgaS5NWDhNUSBhbmQgaS5NWDhRTSBhcmUgY29t
cGF0aWJsZSB3aXRoIGkuTVg2U1gsIHNvIG5vIG5lZWQNCj4gPiB0bw0KPiA+ID4gc3BsaXQgdGhl
bSBpbnRvIHRocmVlIGl0ZW1zLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFBlbmcgRmFu
IDxwZW5nLmZhbkBueHAuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9mc2wsZmVjLnlhbWwgfCA4ICsrLS0tLS0tDQo+ID4gPiAgMSBm
aWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gPiA+DQo+ID4g
PiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2ws
ZmVjLnlhbWwNCj4gPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9m
c2wsZmVjLnlhbWwNCj4gPiA+IGluZGV4IGVjYTQxNDQzZmNjZS4uZGJmNjNhOWMyYTQ2IDEwMDY0
NA0KPiA+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2ws
ZmVjLnlhbWwNCj4gPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9u
ZXQvZnNsLGZlYy55YW1sDQo+ID4gPiBAQCAtMzksOSArMzksOCBAQCBwcm9wZXJ0aWVzOg0KPiA+
ID4gICAgICAgIC0gaXRlbXM6DQo+ID4gPiAgICAgICAgICAgIC0gZW51bToNCj4gPiA+ICAgICAg
ICAgICAgICAgIC0gZnNsLGlteDdkLWZlYw0KPiA+ID4gLSAgICAgICAgICAtIGNvbnN0OiBmc2ws
aW14NnN4LWZlYw0KPiA+ID4gLSAgICAgIC0gaXRlbXM6DQo+ID4gPiAtICAgICAgICAgIC0gY29u
c3Q6IGZzbCxpbXg4bXEtZmVjDQo+ID4gPiArICAgICAgICAgICAgICAtIGZzbCxpbXg4bXEtZmVj
DQo+ID4gPiArICAgICAgICAgICAgICAtIGZzbCxpbXg4cW0tZmVjDQo+ID4gPiAgICAgICAgICAg
IC0gY29uc3Q6IGZzbCxpbXg2c3gtZmVjDQo+ID4gPiAgICAgICAgLSBpdGVtczoNCj4gPiA+ICAg
ICAgICAgICAgLSBlbnVtOg0KPiA+ID4gQEAgLTUwLDkgKzQ5LDYgQEAgcHJvcGVydGllczoNCj4g
PiA+ICAgICAgICAgICAgICAgIC0gZnNsLGlteDhtcC1mZWMNCj4gPiA+ICAgICAgICAgICAgLSBj
b25zdDogZnNsLGlteDhtcS1mZWMNCj4gPiA+ICAgICAgICAgICAgLSBjb25zdDogZnNsLGlteDZz
eC1mZWMNCj4gPiA+IC0gICAgICAtIGl0ZW1zOg0KPiA+ID4gLSAgICAgICAgICAtIGNvbnN0OiBm
c2wsaW14OHFtLWZlYw0KPiA+ID4gLSAgICAgICAgICAtIGNvbnN0OiBmc2wsaW14NnN4LWZlYw0K
PiA+ID4gICAgICAgIC0gaXRlbXM6DQo+ID4gPiAgICAgICAgICAgIC0gZW51bToNCj4gPiA+ICAg
ICAgICAgICAgICAgIC0gZnNsLGlteDhxeHAtZmVjDQo+ID4gPiAtLQ0KPiA+ID4gMi4yNS4xDQoN
Cg==
