Return-Path: <netdev+bounces-6631-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC8E71722F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EF971C20D8F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B434A01;
	Wed, 31 May 2023 00:01:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91388A21
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:01:27 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2075.outbound.protection.outlook.com [40.107.7.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B22100;
	Tue, 30 May 2023 17:01:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIVFANyQ0hn/tFb15sZ3vHd8OWjJVGSLSkeeh0DFTFjiPe9A5qLtyxLxS2f8bMZgdlrL0GvWMUOf/1mqxE+zG+sQDHovXRkKbncIeo+EQFYqwCrAUocb19CAR/aaG8noLu1eDpCO82cbZuSLjT2NXOZIohGtIqm6md+wKei0KnV3SV/aFUU1dZmDQYfhLh/YV5+uc5OBSm/WecIe9/i7jm5qlzH3VrGMQwvlhJ01QFXgjjvBPvkwOpaqnormrEcqquDEus9jbJchY29hFV3lla5yq/V+hE8g+X/2fzbJLaTk0ZDYdksiBuS4FUwYA2fkMPch85pOjeDG3PDjXA58aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/T8lPD2tqoKp5LWHKJfQTixF0/skrKt/7E+JS92MVE=;
 b=mbRaA6UGwivWqeXSo1xMBl9ZMyjsbBsfn1LNn7FHYW3n1PFOaMSc1rQqNKXUjb3Z4N1MiSs0+XAWyGxQ9ofUL/a60kEPjedtgNKmsv6zcMPlVIyDWZsaejfX/mc/6CsSdxNSUvOK9hKtzzQ9w4I5YgStmWqpPIq6Gz2Eprtu+BpxA84UnEUxDIKONkhLG92xFw7NGIFR3Mp874/K8QXn0t0bK+PLkDWhvm6h81RiuNWknHO6Q4JaFJQB7uynFg4dbPwbyqvE5o7Ig8pbiM6eXYmjp5fBcQI3t49ukRiLus61/czlXyvGef4IllC6FhhUpnzfYbvPQTKu/vO9KHJm7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/T8lPD2tqoKp5LWHKJfQTixF0/skrKt/7E+JS92MVE=;
 b=gcPWY6o0Ybe1JbcYe35qLKhGluQqFf1u8KBAozZ6sN4TeS2QpnUR419cIhgmOcoWEPg3IJwkDiVnxzwvMmM9U4Pt0XCuOmTDDFq7cDjeXgT8+e0QHuC7rTX4sNHnrGbzX3JU/bT68cMbkzGAZKh4YM1OcPGYjqGPK+WXpjRHJZk=
Received: from DBBPR04MB6298.eurprd04.prod.outlook.com (2603:10a6:10:cf::14)
 by AS5PR04MB9825.eurprd04.prod.outlook.com (2603:10a6:20b:672::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 00:01:22 +0000
Received: from DBBPR04MB6298.eurprd04.prod.outlook.com
 ([fe80::7f38:7a90:a479:1d25]) by DBBPR04MB6298.eurprd04.prod.outlook.com
 ([fe80::7f38:7a90:a479:1d25%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 00:01:22 +0000
From: Leo Li <leoyang.li@nxp.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>
CC: Stuart Yoder <stuyoder@gmail.com>, Gaurav Jain <gaurav.jain@nxp.com>, Roy
 Pledge <roy.pledge@nxp.com>, "Diana Madalina Craciun (OSS)"
	<diana.craciun@oss.nxp.com>, Eric Dumazet <edumazet@google.com>, Ioana
 Ciornei <ioana.ciornei@nxp.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Horia Geanta <horia.geanta@nxp.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Laurentiu Tudor <laurentiu.tudor@nxp.com>, Richard
 Cochran <richardcochran@gmail.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Alex
 Williamson <alex.williamson@redhat.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Vinod Koul <vkoul@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>, "Y.B. Lu"
	<yangbo.lu@nxp.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "David S.
 Miller" <davem@davemloft.net>
Subject: RE: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Thread-Topic: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Thread-Index:
 AQHZU6GBM20rPir9q0ygz08QWqv0C68oHDoAgABHrACAAI84AIAny6AAgCKVmauAAKoyYA==
Date: Wed, 31 May 2023 00:01:22 +0000
Message-ID:
 <DBBPR04MB62980227407485480858ABFC8F489@DBBPR04MB6298.eurprd04.prod.outlook.com>
References: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
 <20230412171056.xcluewbuyytm77yp@pengutronix.de>
 <AM0PR04MB6289BB9BA4BC0B398F2989108F9B9@AM0PR04MB6289.eurprd04.prod.outlook.com>
 <20230413060004.t55sqmfxqtnejvkc@pengutronix.de>
 <20230508134300.s36d6k4e25f6ubg4@pengutronix.de>
 <CADRPPNQ0QiLzzKhHon62haPJCanDoN=B4QsWCxunJTc4wXwMaA@mail.gmail.com>
 <20230530135046.oovq5gxzbjfqgzos@pengutronix.de>
In-Reply-To: <20230530135046.oovq5gxzbjfqgzos@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBPR04MB6298:EE_|AS5PR04MB9825:EE_
x-ms-office365-filtering-correlation-id: cd9bcce6-72d0-475e-617e-08db616a2b73
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 zxLo+U/r4XjRPvLt+w7wCeXafWnbiqfUWY8p3hqo3aALMmFEr8ZsWrcwaekt5CsfxBmiHkz9wc6HhFP3an/tNGmb8N8wtOE169iuEO/eZeLca1OStmOHFGh6U9oILl+Fso1wkkJh3OIGYoELiamg2sZqwgkqtf833fL09Z6hUYDPxrNnnOHwNw6wWBXprzqqUx/K7iR554NYYfEbjo7bILWakgFSVEblOPnFNciXaVyQWhwhe8A51+oB5uc5JZrrcTzGMHrVhnOEnGdPgxh+SvejVqilB1bZsrc18L8Clp4NGgeJS0fJrfWgbKhLYL+Qtg5dvkHZ1TI2UWOH3YWdNWxEU5M58BDjsAfyfCsBDf82+laTNAuw5ZxQmurKj7S0F98ia34KWza1cigNdUQ/GZ+Wys0RAJOpbl3OUJeik7sfPF8YvFC44n0ej4D0SmL+bN+f3Rw4HJlc6JyQZJaGdnSxcGBUvIL/AKWRV9Aue9D2F/TIoyHBz+C5cotNfcpkb258XF0pSl63nV5uPdiZy6QqQpGy3Vb6p4/JYItuRIJSPnRq25HF0XK9EnyFXrm6tLG4RDn+M4U6TeW+9rrpobBisQJTJy9tijLZ+oKjT9vH+2wznsy4a3UwcJcYHywR
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB6298.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199021)(71200400001)(478600001)(54906003)(64756008)(8676002)(8936002)(7416002)(52536014)(5660300002)(86362001)(2906002)(33656002)(38070700005)(66556008)(66446008)(76116006)(4326008)(6916009)(122000001)(66476007)(66946007)(316002)(55016003)(38100700002)(186003)(41300700001)(6506007)(53546011)(9686003)(66574015)(7696005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YmRzTTlqQ2RnbzRVWmVnYU5NN3E3dUNNaFdRMnBrUkN6ZFFUZldBNXVoRHVY?=
 =?utf-8?B?NnBwV2NwRlN5aUFHWVlqZWd5YXhUTW9SWW5SblhqNXZ3OWZidHJ2YmtyZ2R6?=
 =?utf-8?B?VS8yT3BLTGpBZ3l0RUw4bCtRN3hBd3hjYVFFdHgwSTBFV0J6ekdUc3c3T1Jj?=
 =?utf-8?B?MmEza1RQNTdjQU1DMlMwcmJXbzFPbnZuVTJOdFhCY0svQXU2emFtV3BRV0ZQ?=
 =?utf-8?B?TTVaUWJaUkIyVWpEdGdhS3RXRTV3THZQblRkVVM4dnpoNk9KSjdsdjlUYWla?=
 =?utf-8?B?b2E4NmN4U2ZwM0pXLytEUEQ4NGp4NkpvOEhJK0lHMnpNUWQ5ZlBTcUdSOGl3?=
 =?utf-8?B?OWduYnFkK1VlcjNzbnY1N0Z4TEVjc0hza3ZBWjBmN2NrQWUwRitiRjVPL2xv?=
 =?utf-8?B?ZzE3bURJb01Ia0NpbnRUay9CeFNtRmhVdFhucStsZ3B0YnEvS05YblNPYTc2?=
 =?utf-8?B?T3FPMnlBZlcza0lIWUNwWnBnQjJtRDV4RFVEVHdHYmtEWnY4R3RYM2FLeU1H?=
 =?utf-8?B?SDY0YVQvclE5SmFFWFkvdGlJeHBFNzdXL1lGSUcrK0owU2JHbWl6dTgyM2M3?=
 =?utf-8?B?YjRncmdoc21CdEF5ZzdWVzlKdERWb3dpTkRTOHRGWVVqc25vclNSMW4xNmFt?=
 =?utf-8?B?VkZIVGVCdnY5cHQ4a2paQkJzYlVvTWg5T2hJd250ckowa2NkU1JnVU9MR3hS?=
 =?utf-8?B?QWdaeDBtZmRSaHRnVGx2MUovZVVKaHU2czlMOEhJZy9NRTJHUXU4M1Ywd2Vk?=
 =?utf-8?B?TWgyZUFvVWdnRndqbTExdFd4SW5rTGVEZHRXWXFSY21mZ1V0OGJnVDJRb1c5?=
 =?utf-8?B?ZGtZRDRHalBUcUpESkduTFdQMEtaL2JXTGF5NmtDUmVkZGNmZEtueXkxTXpI?=
 =?utf-8?B?NG1jUE5uV2ViZGZQczg2Qmc0YUpLRUZKa1hQR2R3bmtZNGZIU0xwQXNiNEFl?=
 =?utf-8?B?VXhvWjdzdENib1ZhTForeEVhbmt0TmJzRFhxZGhaZFVnaGV5QksxVzVOZlNF?=
 =?utf-8?B?cFZnMkRENFVmaGZzNmJWMkh5dWs4b1V4MWNJQkluL0huSWhxRldOS2VGaWxE?=
 =?utf-8?B?cmMvRXBXWXhKbTdNTmlzUnhVRHBGbFFYdDU4OVB1ZGZxdm1lOWlxTFlkNzAv?=
 =?utf-8?B?dnRaMWp2R3ZIbFd6eWUvN1JHVHpDbDIwOXVSTjY3UFIxSUFuVmJPWWx4cWJk?=
 =?utf-8?B?RUU0SnNZZmNSNnozN3BjZU9UYzVGZ3RFU1cwd0k3ZmJ6VjJ3c0pyTFBYU2R3?=
 =?utf-8?B?L0V5cXUvUmFBSk83aUZpaGNCeXRwK0NJY1dwMDgxWmU1ZkIzMVVTZjBmdG1o?=
 =?utf-8?B?MFJKZjBQYWw2R1Q5ZkJOWVBvNnJwUDhqaFVMRVJDQ1FjRlNBRkdTbU01dk5J?=
 =?utf-8?B?MjRBWnFjM3dERHZlZkZjcGE0T2dWWXFVdXlFMnR5elYxZHNXREx3SEZTR2FV?=
 =?utf-8?B?Qi9pbzI5d0diNnhrcmREL00yUFZNazZva2ZHSjE5OUJMNkUxeFMwR1FuSldy?=
 =?utf-8?B?RlYxa0dPQjdyckgzYlNneG5lSGxTQlliZldlL0VJQVFCSWJSZ1A0RmNLbTU3?=
 =?utf-8?B?ejJiWGx0VFpZWkZNMEgyaHJ1S2pLSCtVc0h1T01jMTF4OE5ncmhEd1BkaERL?=
 =?utf-8?B?bHFJZEVkbDV0TE5pVjBJaVdiMTVVYmtJT0VZa1VmbUZ5b3FLN0c1SmhPckZl?=
 =?utf-8?B?VlNEUTJqakd2cTVjYzdRdnh3cTUzR1FGYzhpWHVMOU04amF3MWk1WlZZZ054?=
 =?utf-8?B?ekowU0FrK2tidGJ0Nlo2Wko1UXRlZ0g2TEw0TzA1T1hITHd0V3Mva2MwUkNW?=
 =?utf-8?B?T1JJTHh5dmN2MEgzeFNXOGo2NFZna1ZNQVJweEpMUjVxRkxkdTdYdEZoOS9z?=
 =?utf-8?B?cUJsOThqTjhYVU1TMCtuWSswaVFuV0ZCWTVERFEwRHJSbytXWUxUQTBhbUVq?=
 =?utf-8?B?MkZIN20zVml6bEhRUi9ndHo0bnpoM29mbWJXNzJCMjZsSnY3MkdHUlRWb2pW?=
 =?utf-8?B?RjR5R01XTlc2Q1k0UGIvRWpvVGdGSnlhcVJGbEpZcVNCSXhzU0lQZGlEU29j?=
 =?utf-8?B?dkJUc3R5c21CYzNFMkFVWTZvdS9pWkxsV3ViUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB6298.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9bcce6-72d0-475e-617e-08db616a2b73
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 00:01:22.6327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 61ZrNNIQDMr2kvbKhAXmTAsU/RWZVWKAmvDqpKfduQH0PwioqH2C+qcdF4w6r9kJda4c5InoWjpPmmfeMuScpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9825
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVXdlIEtsZWluZS1Lw7Zu
aWcgPHUua2xlaW5lLWtvZW5pZ0BwZW5ndXRyb25peC5kZT4NCj4gU2VudDogVHVlc2RheSwgTWF5
IDMwLCAyMDIzIDg6NTEgQU0NCj4gVG86IExlbyBMaSA8bGVveWFuZy5saUBueHAuY29tPg0KPiBD
YzogU3R1YXJ0IFlvZGVyIDxzdHV5b2RlckBnbWFpbC5jb20+OyBHYXVyYXYgSmFpbg0KPiA8Z2F1
cmF2LmphaW5AbnhwLmNvbT47IFJveSBQbGVkZ2UgPHJveS5wbGVkZ2VAbnhwLmNvbT47IERpYW5h
DQo+IE1hZGFsaW5hIENyYWNpdW4gKE9TUykgPGRpYW5hLmNyYWNpdW5Ab3NzLm54cC5jb20+OyBF
cmljIER1bWF6ZXQNCj4gPGVkdW1hemV0QGdvb2dsZS5jb20+OyBJb2FuYSBDaW9ybmVpIDxpb2Fu
YS5jaW9ybmVpQG54cC5jb20+Ow0KPiBrdm1Admdlci5rZXJuZWwub3JnOyBIb3JpYSBHZWFudGEg
PGhvcmlhLmdlYW50YUBueHAuY29tPjsgSmFrdWINCj4gS2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz47IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IExhdXJlbnRpdQ0KPiBUdWRvciA8
bGF1cmVudGl1LnR1ZG9yQG54cC5jb20+OyBSaWNoYXJkIENvY2hyYW4NCj4gPHJpY2hhcmRjb2No
cmFuQGdtYWlsLmNvbT47IFBhbmthaiBHdXB0YSA8cGFua2FqLmd1cHRhQG54cC5jb20+OyBBbGV4
DQo+IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPjsgbGludXgtYXJtLQ0K
PiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3Iu
YXBhbmEub3JnLmF1PjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsgVmlub2QgS291bA0KPiA8dmtvdWxAa2VybmVsLm9yZz47IGxpbnV4LWNy
eXB0b0B2Z2VyLmtlcm5lbC5vcmc7IGtlcm5lbEBwZW5ndXRyb25peC5kZTsNCj4gWS5CLiBMdSA8
eWFuZ2JvLmx1QG54cC5jb20+OyBkbWFlbmdpbmVAdmdlci5rZXJuZWwub3JnOyBsaW51eHBwYy0N
Cj4gZGV2QGxpc3RzLm96bGFicy5vcmc7IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAwLzZdIGJ1czogZnNsLW1jOiBNYWtlIHJlbW92
ZSBmdW5jdGlvbiByZXR1cm4gdm9pZA0KPiANCj4gSGVsbG8sDQo+IA0KPiBPbiBNb24sIE1heSAw
OCwgMjAyMyBhdCAwNDo1NzowMFBNIC0wNTAwLCBMaSBZYW5nIHdyb3RlOg0KPiA+IE9uIE1vbiwg
TWF5IDgsIDIwMjMgYXQgODo0NOKAr0FNIFV3ZSBLbGVpbmUtS8O2bmlnDQo+ID4gPHUua2xlaW5l
LWtvZW5pZ0BwZW5ndXRyb25peC5kZT4gd3JvdGU6DQo+ID4gPiBPbiBUaHUsIEFwciAxMywgMjAy
MyBhdCAwODowMDowNEFNICswMjAwLCBVd2UgS2xlaW5lLUvDtm5pZyB3cm90ZToNCj4gPiA+ID4g
T24gV2VkLCBBcHIgMTIsIDIwMjMgYXQgMDk6MzA6MDVQTSArMDAwMCwgTGVvIExpIHdyb3RlOg0K
PiA+ID4gPiA+ID4gT24gRnJpLCBNYXIgMTAsIDIwMjMgYXQgMTE6NDE6MjJQTSArMDEwMCwgVXdl
IEtsZWluZS1Lw7ZuaWcgd3JvdGU6DQo+ID4gPiA+ID4gPiA+IEhlbGxvLA0KPiA+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gPiBtYW55IGJ1cyByZW1vdmUgZnVuY3Rpb25zIHJldHVybiBhbiBpbnRl
Z2VyIHdoaWNoIGlzIGENCj4gPiA+ID4gPiA+ID4gaGlzdG9yaWMgbWlzZGVzaWduIHRoYXQgbWFr
ZXMgZHJpdmVyIGF1dGhvcnMgYXNzdW1lIHRoYXQNCj4gPiA+ID4gPiA+ID4gdGhlcmUgaXMgc29t
ZSBraW5kIG9mIGVycm9yIGhhbmRsaW5nIGluIHRoZSB1cHBlciBsYXllcnMuDQo+ID4gPiA+ID4g
PiA+IFRoaXMgaXMgd3JvbmcgaG93ZXZlciBhbmQgcmV0dXJuaW5nIGFuZCBlcnJvciBjb2RlIG9u
bHkgeWllbGRzIGFuDQo+IGVycm9yIG1lc3NhZ2UuDQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4g
PiA+IFRoaXMgc2VyaWVzIGltcHJvdmVzIHRoZSBmc2wtbWMgYnVzIGJ5IGNoYW5naW5nIHRoZSBy
ZW1vdmUNCj4gPiA+ID4gPiA+ID4gY2FsbGJhY2sgdG8gcmV0dXJuIG5vIHZhbHVlIGluc3RlYWQu
IEFzIGEgcHJlcGFyYXRpb24gYWxsDQo+ID4gPiA+ID4gPiA+IGRyaXZlcnMgYXJlIGNoYW5nZWQg
dG8gcmV0dXJuIHplcm8gYmVmb3JlIHNvIHRoYXQgdGhleSBkb24ndA0KPiB0cmlnZ2VyIHRoZSBl
cnJvciBtZXNzYWdlLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFdobyBpcyBzdXBwb3NlZCB0
byBwaWNrIHVwIHRoaXMgcGF0Y2ggc2VyaWVzIChvciBwb2ludCBvdXQgYQ0KPiA+ID4gPiA+ID4g
Z29vZCByZWFzb24gZm9yIG5vdCB0YWtpbmcgaXQpPw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gUHJl
dmlvdXNseSBHcmVnIEtIIHBpY2tlZCB1cCBNQyBidXMgcGF0Y2hlcy4NCj4gPiA+ID4gPg0KPiA+
ID4gPiA+IElmIG5vIG9uZSBpcyBwaWNraW5nIHVwIHRoZW0gdGhpcyB0aW1lLCBJIHByb2JhYmx5
IGNhbiB0YWtlIGl0DQo+ID4gPiA+ID4gdGhyb3VnaCB0aGUgZnNsIHNvYyB0cmVlLg0KPiA+ID4g
Pg0KPiA+ID4gPiBJIGd1ZXNzIEdyZWcgd29uJ3QgcGljayB1cCB0aGlzIHNlcmllcyBhcyBoZSBk
aWRuJ3QgZ2V0IGEgY29weSBvZg0KPiA+ID4gPiBpdCA6LSkNCj4gPiA+ID4NCj4gPiA+ID4gQnJv
d3NpbmcgdGhyb3VnaCB0aGUgaGlzdG9yeSBvZiBkcml2ZXJzL2J1cy9mc2wtbWMgdGhlcmUgaXMg
bm8NCj4gPiA+ID4gY29uc2lzdGVudCBtYWludGFpbmVyIHRvIHNlZS4gU28gaWYgeW91IGNhbiB0
YWtlIGl0LCB0aGF0J3MgdmVyeQ0KPiA+ID4gPiBhcHByZWNpYXRlZC4NCj4gPiA+DQo+ID4gPiBN
eSBtYWlsIHdhcyBtZWFudCBlbmNvdXJhZ2luZywgbWF5YmUgaXQgd2FzIHRvbyBzdWJ0aWxlPyBJ
J2xsIHRyeSBhZ2FpbjoNCj4gPiA+DQo+ID4gPiBZZXMsIHBsZWFzZSBhcHBseSwgdGhhdCB3b3Vs
ZCBiZSB3b25kZXJmdWwhDQo+ID4NCj4gPiBTb3JyeSBmb3IgbWlzc2luZyB5b3VyIHByZXZpb3Vz
IGVtYWlsLiAgSSB3aWxsIGRvIHRoYXQuICBUaGFua3MuDQo+IA0KPiBFaXRoZXIgeW91IGRpZG4n
dCBhcHBseSB0aGlzIHBhdGNoIHNldCB5ZXQsIG9yIHlvdXIgdHJlZSBpc24ndCBpbiBuZXh0Lg0K
PiBCb3RoIHZhcmlhbnRzIHdvdWxkIGJlIGdyZWF0IHRvIGJlIGZpeGVkLg0KPiANCj4gSSBoYXZl
IGFub3RoZXIgY2hhbmdlIHBlbmRpbmcgZm9yIGRyaXZlcnMvYnVzL2ZzbC1tYy9mc2wtbWMtYnVz
LmMsIHdvdWxkIGJlDQo+IGdyZWF0IHRvIHNlZSB0aGVzZSBiYXNlIHBhdGNoZXMgaW4gbmV4dCBm
aXJzdC4NCg0KSSBoYXZlIGFwcGxpZWQgdGhlbSB0byB0aGUgbmV4dCBicmFuY2ggb2YgbXkgdHJl
ZS4gIFRoZXkgd2lsbCBiZSBwYXJ0IG9mIHRoZSBMaW51eC1uZXh0IHNvb24uDQoNClJlZ2FyZHMs
DQpMZW8NCg==

