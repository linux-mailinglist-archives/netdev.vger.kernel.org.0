Return-Path: <netdev+bounces-3780-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1954708D54
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D3AE281A5F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF013386;
	Fri, 19 May 2023 01:27:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D71E362;
	Fri, 19 May 2023 01:27:15 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2047.outbound.protection.outlook.com [40.107.15.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA12810DD;
	Thu, 18 May 2023 18:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRWovs4ila+EGZmJ5kU8UfVBJspxkvwO3qkMvUz2UVLEdWWv6kPoeWN6J0+uM4Z4qNrWs8PUpRwKsa45s1UmTN26yQMEy3M8lWfT/pnqTrqI9s8+2NtRVlSj7go1MjebGkilMxk2WwAb9Xa9ah0AOrFj3uYDIqX8JTOrQzCr1f037RdjophkRyGoNATGPpV8zxapnXyNSVFtXjC0Xrj/ND+iXJJHesjVQ0yWaC+Me6Gg7HndF/lT+8rn3YyjKPoJrBAToixeQscXdtGYkAysB8eAAPzX3zHPJYpjCRA89jdBH0OULt2g9J9Iy5wKyEaxSkg8abRxrko4U+KNpXzl4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6AU7I17ARnlmE6skWo+jayQbD/JP6rXXKaJ7GmUrgU=;
 b=XQTGHQgzVzEe0AU+k9FaF9eDHTirpt6s66TT209x3vH7ax9cBdJBL46ofx5mOfFLFjGr35W7HXUqE5Z6q6QLxxczluVVoCqfv8Zug7Vw0QjQwHf67vYSZGXLp5tyI67ANIld6etIu5sj3o7GhDPy8gYGw2HcSjxnXPWnaTeRxyZNszPEqd2d23IhJ4FbnKfsc8hrvqp629uHK2prtnQlE85wsxLxrX27mU2ZTSTV3Nf9zrHMIHUKbJDli6kaVvzkZYiFm6W7mkTL6vyfPywrDf93WxnP0NeipoQJVW9+ycOpW+TSzMJQ3QlW8Zng0Lz6M69Wp8Gqa/hPFLveGgg2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6AU7I17ARnlmE6skWo+jayQbD/JP6rXXKaJ7GmUrgU=;
 b=KHNjEWQZY98stHgFngcLuVGgFpQgKWXuqO9+ch0AD/NYssSNyrhXOjR05uzgolFFDuEZ8TKDxRU/nqJuA1ArCzsioYQ8x4OQIukheRLko8IdT4OoerJE6ylF3AWr5RVnNGHPgj7uzZO7gGchYzO9jBfbD2qhtMOklOcUb01GqcE=
Received: from DB6PR04MB3141.eurprd04.prod.outlook.com (2603:10a6:6:c::21) by
 DUZPR04MB10016.eurprd04.prod.outlook.com (2603:10a6:10:4dd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.21; Fri, 19 May 2023 01:27:11 +0000
Received: from DB6PR04MB3141.eurprd04.prod.outlook.com
 ([fe80::4fc7:994a:43c9:7058]) by DB6PR04MB3141.eurprd04.prod.outlook.com
 ([fe80::4fc7:994a:43c9:7058%7]) with mapi id 15.20.6411.017; Fri, 19 May 2023
 01:27:11 +0000
From: Wei Fang <wei.fang@nxp.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, Simon Horman
	<simon.horman@corigine.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "hawk@kernel.org"
	<hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	Shenwei Wang <shenwei.wang@nxp.com>, Clark Wang <xiaoning.wang@nxp.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, dl-linux-imx
	<linux-imx@nxp.com>, Lorenzo Bianconi <lorenzo@kernel.org>
Subject: RE: [PATCH net-next] net: fec: turn on XDP features
Thread-Topic: [PATCH net-next] net: fec: turn on XDP features
Thread-Index: AQHZiZa5MHJHr9fexEeXiNyvCoMG7a9gTlgAgAApkACAAFarYA==
Date: Fri, 19 May 2023 01:27:11 +0000
Message-ID:
 <DB6PR04MB3141CE3CEC1A59134FE96272887C9@DB6PR04MB3141.eurprd04.prod.outlook.com>
References: <20230518143236.1638914-1-wei.fang@nxp.com>
 <ZGZkmvX0OLI+4fqY@corigine.com> <ZGaHeGUwFdWDthh4@lore-desk>
In-Reply-To: <ZGaHeGUwFdWDthh4@lore-desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB6PR04MB3141:EE_|DUZPR04MB10016:EE_
x-ms-office365-filtering-correlation-id: f3c0e9be-6a3b-4cf2-5308-08db58082b5b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ECrqDyJ/XHEwZ4AHujf/6tyvq+2ILB5GXrmolJxssyf9YZulfs4bPjvbcmuhNouJv4HZzIlFM4sDgC6XNhXuhvszu7hURRXCVGuz2NzYFMoyFaecFV34J1WeHGp+HgKRnqxKZ9LUBg3jQU+tXq40mtRBDhiNuvFQupVbIU8Q0D+yJnLzhafQHZGkZ2CGQlzv/VRVjkQo3BihF3kAhMby7XzxEZrkdJeqZzf1QBgI4Dn/cDy6SbEEg33QOb6IgdB0F+bzT5H2UKf8BBntc+EtvO4BH4ZtQwkdIuXOJXEal3KdcWnyraPlGG95cSW6A/5KWynXpi48zZ6S56JP32uGFYOIje0cBkVxL41xsGAkg92IL5ylKhpSuZq+IbYU8toQu2oorC30EufEcnbi/9LOSa59TCSu3eB/ZCAmIn/V/ESgFOB2tPS1qKKlImcxo1FLOQQQ4VGI5GDrrX8TcWur+vU2i/n7L4coOuxuA5dm+vOa0smIyFrpLEsLi0W4ofB/sMedElznmu6mTib6s2Ny3jq0tE/X7NpxXvqckbExF6oGanN8Y90jh9P7u7729PSxR7jvt4FqXrzVYJFZj1rvzZj0t2u5CRL/1nhu6Nhysx84WAZKwzjhgoF3BMo0xI0b
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR04MB3141.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199021)(83380400001)(478600001)(7696005)(71200400001)(54906003)(6506007)(26005)(9686003)(53546011)(110136005)(186003)(2906002)(5660300002)(8936002)(44832011)(8676002)(52536014)(7416002)(33656002)(122000001)(38100700002)(4326008)(66446008)(66476007)(66556008)(66946007)(76116006)(64756008)(316002)(55016003)(86362001)(41300700001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?SVdDM210TkZPcDcyMkxRU0RRU0VTRldEdzRVRGlIZmJsa0ZkTGl4bFZuUTFD?=
 =?gb2312?B?d2FUUU1EYzR1WHVIbjViemdUM0pWa0dVTkhxd3ZFV2RvT2JVLytwQUIxRWRk?=
 =?gb2312?B?eU9ia2VPb0hqYkJ4YlhpNkRLdkFaSWY3WHNmRDR4ZGl3Q1dOWG9kZyt1cG1J?=
 =?gb2312?B?L0g3Q0tydDlqMDE2Nzc3OFBTWFMxSVI3RHRSWk5iTTZtOUQzeGRoNHRJQmhH?=
 =?gb2312?B?NVluRDBhQTczUGp4U29rSXBoNXN4SDBBWEJwT1RjZkhmbzd5NGk1c1BrS3Jp?=
 =?gb2312?B?Y2V6YjR3a3JZc0huejFvM1BMclJvSlBaTGlZMkpCSFp2YVFBNW5CWlNzZE1l?=
 =?gb2312?B?QWo2M0ovU25UTnVkOUNSYitvdU96Z3orYmtvOU5ZM2h5V0JNSnRvWCtxcmlC?=
 =?gb2312?B?MlZBUE0xZlhyM3QxQkJHRFRxdy85U1NadHA3bk1VWjh4L2Y2OWZQQ3ZtMEVy?=
 =?gb2312?B?UXgxaU9VWm44V2dHVHJ2VytiZ0dDcFFwYlI5dFJWWEZYbkhSTkdOeXNQRkFS?=
 =?gb2312?B?eGMrYUFuVURnejZWMnRJRE9hcFdZc1JLR3l3djhmV0FVejRaYXR3cUpySEJH?=
 =?gb2312?B?OGZoazl6N0lVV0tVSXgyVGF6aSt0NENadmtjdnhJZG5rRmRNUThwSTl4QWdR?=
 =?gb2312?B?eWpGWDJ1bExtbElsSWJOdjd2a0s3ZThydnZkd3NmaDVvaUtwWUJFa1o2TEFu?=
 =?gb2312?B?Y0FnOHBURG5JNjZXblVnVkJpM3I3TmViQXFSeUpYZWRRUkd1NnJSTmE5U0JG?=
 =?gb2312?B?Z0FQdzdJTGhmbjR2QjRiem1lVEtsR25tZllnWUV3TkdibkhPblhHK3BRN3Q4?=
 =?gb2312?B?ZGpBUDhFb01rT2JKTFRXbklsWnp1Q2JmRngxT0lYSFMrMjZDeWdhblJqM1FV?=
 =?gb2312?B?N1crZ0NIQ2d0R2IwZU04dGdhWmdTN2RnQnhvZXpSVHBaaXdmdzY2U1F3dUF5?=
 =?gb2312?B?eWRFajRSMmZKcFIrRXpDZXd1QkVaOEUraXdSRkJ3VEIra1NMaGpOTGlHM2tH?=
 =?gb2312?B?K0JyZEl3YjZGVWVWWlZTT3RvcmQ0TXp2aWdqQytYbDhjVDl6d2ZydkVob3Ra?=
 =?gb2312?B?Rll2UnU3Y3RMZDJta0xZM1k0dnVrcm9rNm9LZXh4M0FWRGFOeFpzSUZLWHRa?=
 =?gb2312?B?dlF4Mmt1cjRRZHA1eFZmcDM1bjFJR2N5dkQ4bkIyaUtnYmZSUW02VTltQVVI?=
 =?gb2312?B?aTNuT3RaOEhxbWZ4cmszL1h6bnFZc2EvMWFWTzRidHpIOWNQNG9Ma3c5ckR0?=
 =?gb2312?B?a2hYOE81UzMzWHhSMCtoTW1wY1A4YXBTSmN6aS9YZVRzV2o0SVNJQi9rZFVh?=
 =?gb2312?B?UzkwZjg0SFdla2VIVmFVUGxuUVhGaXhEb2ZsdUtRVHp1YmxoRnJEejh0TUdv?=
 =?gb2312?B?bUFvY0Z4RGNJc3BwLzBya0VJam5mMzFobmxKMENVaFF1UklxYSsvMi9xak1S?=
 =?gb2312?B?aGNTQU9BVnVPL1RvMFNIVDVudU5iNEc0ZUFHSWNnNFNzMlVwYkRFQzB2cm5j?=
 =?gb2312?B?TnliQlpFZU5KTFNveGZrWGlscXUrY05xeURYSFhULzVSVVhzak1FKy9JZzFz?=
 =?gb2312?B?cnBSUms0dDFpa1hzOXZtdmZZMmF1TXUySWN1Z3h0bzJGZmdkTmwyL1ByVFFN?=
 =?gb2312?B?QXkvODdHc1g1RGhIMFlOb0tFSkpNK01ZYnFldGUvM05sZUlPRE8yQUQwMWRy?=
 =?gb2312?B?YWhaZmFRbXdYK0M2VFJiM09VZTQ2QllvaFI0Tlo2SDFUaC93MUs4cGZhQlha?=
 =?gb2312?B?aFlxbnFnZVFTWHY1U0pZc2NNNGlxZmlVcGtNVGVVcjJUUmtyaEYxbTdDWVFr?=
 =?gb2312?B?OFdRVU5YNlM5bDVMOVY3Si9QMGlRRUw4bkJNby9sMWtCM1BTUk9iL3dUbXNJ?=
 =?gb2312?B?eXN1RXNwc3k2MVphZWFQVlViYkZZNHF2aVBsUCsvQXUxN3BZNVAzVmlpOWY2?=
 =?gb2312?B?QVEwOTJoMXZRWVdxTkJTWTF3Q3ZpcHJBL084TnRyOFA4NnYreVA4NEkrd29z?=
 =?gb2312?B?dEtOQUJENXBmUzhiV2wxb29DMEdOWU1tc1EvamZXSHI2em96a1NXaFdpaC9m?=
 =?gb2312?B?bTNDT0ZpRGRTZHNTYkV2WTFySTY1MDFvSkFNRTl5c0FCR3B1QmZ4UEFjcG9O?=
 =?gb2312?Q?sY+Y=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB6PR04MB3141.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c0e9be-6a3b-4cf2-5308-08db58082b5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 01:27:11.3392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9pKg4nhWTwZGJSD7vVW30h8iHZ062fpHcmH4pjIhhaf+gBgk8+iJZN+TNpZAfDUKgK9hCoCCdtze5QGXHTv9VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB10016
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBMb3JlbnpvIEJpYW5jb25pIDxs
b3JlbnpvLmJpYW5jb25pQHJlZGhhdC5jb20+DQo+IFNlbnQ6IDIwMjPE6jXUwjE5yNUgNDoxNg0K
PiBUbzogU2ltb24gSG9ybWFuIDxzaW1vbi5ob3JtYW5AY29yaWdpbmUuY29tPg0KPiBDYzogV2Vp
IEZhbmcgPHdlaS5mYW5nQG54cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBlZHVtYXpl
dEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBhc3RA
a2VybmVsLm9yZzsgZGFuaWVsQGlvZ2VhcmJveC5uZXQ7IGhhd2tAa2VybmVsLm9yZzsNCj4gam9o
bi5mYXN0YWJlbmRAZ21haWwuY29tOyBTaGVud2VpIFdhbmcgPHNoZW53ZWkud2FuZ0BueHAuY29t
PjsgQ2xhcmsNCj4gV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2VybmVs
Lm9yZzsgZGwtbGludXgtaW14DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47IExvcmVuem8gQmlhbmNv
bmkgPGxvcmVuem9Aa2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dF0g
bmV0OiBmZWM6IHR1cm4gb24gWERQIGZlYXR1cmVzDQo+IA0KPiA+ICtMb3JlbnpvDQo+ID4NCj4g
PiBPbiBUaHUsIE1heSAxOCwgMjAyMyBhdCAxMDozMjozNlBNICswODAwLCB3ZWkuZmFuZ0BueHAu
Y29tIHdyb3RlOg0KPiA+ID4gRnJvbTogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQo+ID4g
Pg0KPiA+ID4gVGhlIFhEUCBmZWF0dXJlcyBhcmUgc3VwcG9ydGVkIHNpbmNlIHRoZSBjb21taXQg
NjZjMGUxM2FkMjM2DQo+ID4gPiAoImRyaXZlcnM6IG5ldDogdHVybiBvbiBYRFAgZmVhdHVyZXMi
KS4gQ3VycmVudGx5LCB0aGUgZmVjIGRyaXZlcg0KPiA+ID4gc3VwcG9ydHMgTkVUREVWX1hEUF9B
Q1RfQkFTSUMsIE5FVERFVl9YRFBfQUNUX1JFRElSRUNUIGFuZA0KPiA+ID4gTkVUREVWX1hEUF9B
Q1RfTkRPX1hNSVQuIFNvIHR1cm4gb24gdGhlc2UgWERQIGZlYXR1cmVzIGZvciBmZWMNCj4gPiA+
IGRyaXZlci4NCj4gPiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBXZWkgRmFuZyA8d2VpLmZhbmdA
bnhwLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9mZWNfbWFpbi5jIHwgMiArKw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KykNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNj
YWxlL2ZlY19tYWluLmMNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Zl
Y19tYWluLmMNCj4gPiA+IGluZGV4IGNkMjE1YWIyMGZmOS4uNTc3YWZmZGE2ZWZhIDEwMDY0NA0K
PiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4g
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+ID4g
PiBAQCAtNDAzMCw2ICs0MDMwLDggQEAgc3RhdGljIGludCBmZWNfZW5ldF9pbml0KHN0cnVjdCBu
ZXRfZGV2aWNlICpuZGV2KQ0KPiA+ID4gIAl9DQo+ID4gPg0KPiA+ID4gIAluZGV2LT5od19mZWF0
dXJlcyA9IG5kZXYtPmZlYXR1cmVzOw0KPiA+ID4gKwluZGV2LT54ZHBfZmVhdHVyZXMgPSBORVRE
RVZfWERQX0FDVF9CQVNJQyB8DQo+IE5FVERFVl9YRFBfQUNUX1JFRElSRUNUIHwNCj4gPiA+ICsJ
CQkgICAgIE5FVERFVl9YRFBfQUNUX05ET19YTUlUOw0KPiANCj4gc2hvdWxkIHdlIGNoZWNrIEZF
Q19RVUlSS19TV0FQX0ZSQU1FIGhlcmU/IHNvbWV0aGluZyBsaWtlOg0KPiANCj4gCWlmICghKGZl
cC0+cXVpcmtzICYgRkVDX1FVSVJLX1NXQVBfRlJBTUUpDQo+IAkJbmRldi0+eGRwX2ZlYXR1cmVz
ID0gTkVUREVWX1hEUF9BQ1RfQkFTSUMgfA0KPiAJCQkJICAgICBORVRERVZfWERQX0FDVF9SRURJ
UkVDVCB8DQo+IAkJCQkgICAgIE5FVERFVl9YRFBfQUNUX05ET19YTUlUOw0KPiANCj4gDQpJdCdz
IHJlYWxseSBhIGdvb2Qgc3VnZ2VzdGlvbiwgdGhhbmsgeW91IHNvIG11Y2ghDQoNCj4gPiA+DQo+
ID4gPiAgCWZlY19yZXN0YXJ0KG5kZXYpOw0KPiA+ID4NCj4gPiA+IC0tDQo+ID4gPiAyLjI1LjEN
Cj4gPiA+DQo+ID4gPg0KPiA+DQo=

