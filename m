Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DACE690477
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjBIKLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBIKLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:11:06 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2054.outbound.protection.outlook.com [40.107.241.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6743582A4;
        Thu,  9 Feb 2023 02:11:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtnSHaFF5aWLxYdAm81/as05QTT2g6txxOIiaj27U1vYwI9qCN/yYjM3gGfS8wy5t6/Jy2E3a2Fj6u5qJDqGWStOjEFfvFFIUh/Q6SzqEepWcw+qlsnY+2UnS5FDBhk6Db0EXmbR2aa3JtWxo1mmrERGIcGg9kwfSrONEBz4kuHCkNV0jZkQYW6zkYLSA1TRcUb7XdL59tXjpf2e9HbLBA0dUP630cHEelSjBfFnPLSBLdIPRXf2tsQnJNXxe7Y+ytkl72ZdH7t2lG+GJLhBvr2fVLdpisJQ0TQUB2Ae8rLuEGFEQIEWVRjKlJVsGoUEOlyeT1Al1x9xIdE1LwK0PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijoUH492Z1LOrNMKMA8nAXIvcXgIcmi4xHTw52o3TRQ=;
 b=jEntUFsVnSZAQxNmxjikqlsE4zPXoXMwfNuS9Z/EN5KXg+4b+ENx2p0HVIfWtzhs5g2VYAiNWhWBV/i990XYJh7/v1+GKqp7Xw/26sWUn20bM7b/BDlBlTirbqpB+9mqlJRbGSiiVsQDV15KQfLKpDsJqOsTEM4t8TS+4MAyNUCi9BpB1/bs6WHXnn+c2vl2o6w6eXVJujivRlY9pYoGcrtz5zruabGJIdNKx2/C2BerG8zHjF/uNuaLBfjuhSR7ul3r3jwAkmEZOVuGvU2aEbPa7F/KFlVVbGQ/u5/+J+DzJaI0C0LeWRvA2ODdmYUQN2Ly3Ybk6ArjKCNNX3fVMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijoUH492Z1LOrNMKMA8nAXIvcXgIcmi4xHTw52o3TRQ=;
 b=Vp56f+2+qL/r3GMVnlw9p02C+aTLrZryQoM9CjSo1VbKovUZmxG6Iuudv+6Om5s7gvN5dIOKT9f/6DEB9wtuDcyyMgWlmfmWQZRGAn2A9y9zSirR8IEQDBEYC8Wh+9nN+wxMcjj9gghmMdKmJe4t1JRR1csUjrMPxpYxLRWKKX1YU8GGwioZ5zjPxemg3H7+pOS7nKVtkMP7k69WHrtFfOf/x1AF9M8oOUxIr5n+mvt5aSuR3aXWNBf0eklmLVvpwy5PM+MUFnkGJ62HhyIGXoHM6gj4aASGlAAMNd3EvwnTTdqneKbLFu9CPMBueGdOi16Jm5PLlGtpKyi/U5Lunw==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by AM0PR10MB3508.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 10:10:58 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::41bf:a704:622e:df0d]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::41bf:a704:622e:df0d%4]) with mapi id 15.20.6064.034; Thu, 9 Feb 2023
 10:10:58 +0000
From:   "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To:     "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Thread-Topic: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Thread-Index: AQHZO6axGn/PBMQQZUCM4xDb48lCTa7FyycAgABtnACAAB6UgIAADvWA
Date:   Thu, 9 Feb 2023 10:10:58 +0000
Message-ID: <60f22dab4c51ee7e1a62d91c64e55205c18b9265.camel@siemens.com>
References: <20230208101821.871269-1-alexander.sverdlin@siemens.com>
         <Y+REjDdjHkv4g45o@lunn.ch>
         <9a520aac82f90b222c72c3a7e08fdbdb68d2d2f6.camel@siemens.com>
         <DB9PR04MB81063375BAC5F0B9CBBB6A0D88D99@DB9PR04MB8106.eurprd04.prod.outlook.com>
In-Reply-To: <DB9PR04MB81063375BAC5F0B9CBBB6A0D88D99@DB9PR04MB8106.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|AM0PR10MB3508:EE_
x-ms-office365-filtering-correlation-id: d1ae7a82-9b78-40b8-eef7-08db0a85f061
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2bRBMSK14fmEodvfWXVziNRHHOvxStcla9xnGdLfepXYBYKE+sLneyfPUULsVw8XdgLohuc9IQ+tUIFJVaUqRVTpCxlmqfmXxIEQxhnTNoVr2mgLFMpyvIp4ijuSyw9nDSWuA4jCpNlegFOFm2kX0lEFlO7ij7uJlGTg8DB42HaW6aVCBpTo2LvzRwPrVJTl3J4jpnIN4sUVYFhzkQqGwP8Ipa4Ysrprc/jEd3ndzn0xhbtLhx/MmYLo+YDNRKN/InWPKrGBlEhUZr0Ib2uvSowl9AoD4tAOtXADIJYX6V+eNgsH3Yl5VMGq2agxewM7LLEzEuT58h/33TE0FJLrwaPunINH9MiQtbmlFAbGRq6rsZMidnU3+MmDoKoYw3YyocaEtovw/VymWVdukWZFGdhW/fqmfh2eYI78dz0i3N/ZYpnoshYW2fobP3zXETboBGISlA6KO5tTUCvM7Q+kfCkD2/kyA1OMyPJ3lxh5OrpgK5X5EZBy1/pQ1gIPm78RJ8KY4tgudTMfmVCdWUAfF2Z6wNNO2mKKpErZ1So4S8121zP7p1Y/M0PxF9zs7O/0lDURUylegmoaZocPuTV/dFsOOmIvo5g/KQ2Rg3T7pDD3owl8TZHGAA79kKP529bbxGcLIb0NIr29mMbmlrlT0CoGJZZn2aJu4DiDYKcK+mvcG1lO2qRBkKckDQzMD3FYw02wthgd/GWuF+3JXqF7NEt+e/H5R6nI+z+/RX0F628rj4J1f349+ZsYtev4BQD8kxErfmVrbTjjsbT7YfHL7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199018)(86362001)(26005)(6512007)(186003)(41300700001)(6486002)(54906003)(38100700002)(478600001)(76116006)(122000001)(64756008)(66446008)(110136005)(66946007)(8676002)(4326008)(66556008)(91956017)(38070700005)(82960400001)(71200400001)(15974865002)(66476007)(8936002)(6506007)(55236004)(5660300002)(36756003)(316002)(83380400001)(2616005)(2906002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDgxdmV6UTNpbXZoQmdqRVcyODYzdnpETUN3UWNsTjBpMWtxanA0MWgwaE5C?=
 =?utf-8?B?aHk2THVIZFJxeHkvOEFQbEF0L1duQzROdWVIVFYrY2FYYWFrZFZQSHBScktE?=
 =?utf-8?B?S0huaWtxZjBXNGV0cUE1TVNoM3A0RTJxZ0NVM3ptanFHMWdXOUtRcFlCRjhr?=
 =?utf-8?B?cEF0VEFHMGlldnJycndiM1V2NWY5NUQrWHpHeGxyZlVuUW9FZ08yVW5vUHp3?=
 =?utf-8?B?a1J6T0lLOXNyREN6NnNrR083OTRBSTF4V0cwWGttMXNRRFRrZVV4dURWNnZ5?=
 =?utf-8?B?Q3ZuNGtiUXRIVGptVjF1WjNPWUZZbkR5UHFyU1kvb1BGdG02Z0xCY1Q1b1dI?=
 =?utf-8?B?dkR1NTA1ajRWSndGd21vdXpVS2hicDZlT3RCRCtRNnlDYWU2bXRiV0pNYWh0?=
 =?utf-8?B?YUlzSlVzbldYcW5VWncxMmxpUnlzeVJWVUZmRElpZi9YaE05STN4VzR0eXJw?=
 =?utf-8?B?WFhBTDQrRXVQYm53eTJLZlZiWnZXNlU1c2hVS2lZNmcwa0VhcXFrNkhvZWk2?=
 =?utf-8?B?R3Q4ZXRwU1BHMFF6T3JuOWUxaHpjTWM1MytibTF1WmZDdjNDaHcvYXJqMzh1?=
 =?utf-8?B?R1ROYytqVUZtbHpRa3laWXJUWHBPQWlLMmh6V3Ewd0NyQXRNclVGemg5QjJK?=
 =?utf-8?B?U0Yxd0tDYkF6Vm5icTY0MmtvTTI2YWMzRTBNbXloY0hwUW9pN01YRUgvNkRv?=
 =?utf-8?B?ajJRYVNQUkVhWXA5RWJXcTYrVTdWNFc0cDAyVmltYzZnNWxuajdxQzYxaGdF?=
 =?utf-8?B?UjVsdnNtd1NSTFRmWWZMY2JMSmZEUkc3cHkwUFkwYmY2ZjcwV0dTTnZNSnVQ?=
 =?utf-8?B?TUhGdiszeTBJamd3b3RlVEJhcmtvV0hlS1BTOXVZSmJWRzNMWTFBQWovV0do?=
 =?utf-8?B?VWtkakZsWGtpK3lxdlRVR0hlU2ZEdk5JNnQ5WENCZkt1cm9KRGVZYVlDeVQ0?=
 =?utf-8?B?YzFQT0tMUlMyYS9vWWxhS0ErSzF2V0JGSW5tMUJ0ck5pUXlWa0hlaEFkbk5J?=
 =?utf-8?B?TWdjNUdVQm9TQzYyZHgzMjlEVEpmYXBiRFM4bnR1Y3BOYXBGZkNzME9ZSHNq?=
 =?utf-8?B?bGVwV2Z6R3NnSFJSK1czVGREQXJUUGIxdExtMFlDc1lmdlNwVWc1MUtDUUVR?=
 =?utf-8?B?QjN5VURod3FkeTFtamllN1lEbmNBbm0vT3hBSzNEM21ZNmlYYXVrdHhhZTEx?=
 =?utf-8?B?VE1VMllZbkpLd3hJZHhSTTlCWjdKMWpKSVM3UzhZTjBFR0JuWXJOTndjTVVH?=
 =?utf-8?B?Rll3ekhkR2h2d1NJSm93Q3QwNkFnT2FxdnpuZ1k5QjdqK0QveFd4N3ExblJj?=
 =?utf-8?B?NWQ4bEVPK2F6M1lPU3dVMjd1NTRYVndmc2wvN2s2SU5hT1ltMm4xZ3g2SHJH?=
 =?utf-8?B?Y0UweWNwT1RhOWVvaWJDV3UvOEtwY01YK2JBQnZRMnM4dVpNRjNuQk52UGhr?=
 =?utf-8?B?dHZtWjE5TFFiOG1mRGVxU0FRUHk4cEs3TkdlRnpvVUdhLzJiYzlaei9OV1Ix?=
 =?utf-8?B?TG9ITWt2QnV1bXFFZmp1RnJWVFhHcFZsUzBDaDh3OElPalczRnBocjhXNzFV?=
 =?utf-8?B?WnFlWXFUY251Y2luTUl1N05MamY4YldZT1JvaHlqbDM4NmgwQkc5OWpPdGhz?=
 =?utf-8?B?QlEvUnJoUmM2T0doQW1VaEpkbVl5WUVHeldaUE5sTEU5azdKb3RGRjMxZHpx?=
 =?utf-8?B?T0d3c2IxaFlXY20rMGordmxtOTQyaEZmWm1sMW9EYzMwR3JmVHRYVTFJQ1FN?=
 =?utf-8?B?KzNneGlDUnQrbUMvWGV6UzBGVjFXZ1dhcFV3R3B1ZXZQSVdpUitIalQ5RUJM?=
 =?utf-8?B?dzhqSDAzTzQ3aDd2Y1BMSFNJTkxXQllBSHFYSDl4dzZTc0ZiWlUxL2FEdzVo?=
 =?utf-8?B?NG1lcEtvNDdxTFl4TG56ZW5rb04wOHdrWS9rek00ZG1TUUJ4R0puWW5ST2Nh?=
 =?utf-8?B?eWJzelA5Nmp5WEQ2NkhMSXg0aDhYTlovdDRkS0gwNzR5aG5IZWJqd3gwQVpR?=
 =?utf-8?B?WnJHTm9mektlUU9WMS9XSUlZdXpMUkE0WkllcWtWY2xzTGIwYUZXSnlpelY4?=
 =?utf-8?B?OVM1MHNmeWxuem1RVVZNL0FST3J4L1I2RmpZSWJjcjV2cEFPRFFTdHhTcU1B?=
 =?utf-8?B?eERXemVTZk9ORlZBYnZFVS9KSzBNdjd2MHdIL0hLVktPR2FrbTh6VHk3MG9j?=
 =?utf-8?Q?1LLgaDsU0sBPpbABcIlOkoU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C5C7E49A9C20A4D8BB41A17EB98657B@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ae7a82-9b78-40b8-eef7-08db0a85f061
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 10:10:58.2466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9RQKlS/lNs604CgcRmJKxnPK4+RkMzjzu2Pfb7+pGaezRFtyUCUKyhLvuJnhiqRJorjmI+l1jeMXkL/2QKglGcOVsq4t52yiG/4jaU3n3xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3508
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gV2VpLA0KDQpPbiBUaHUsIDIwMjMtMDItMDkgYXQgMDk6MTcgKzAwMDAsIFdlaSBGYW5n
IHdyb3RlOg0KPiA+ID4gPiAtwqDCoMKgwqDCoMKgwqBpZiAoKGZlcC0+cXVpcmtzICYgRkVDX1FV
SVJLX1NJTkdMRV9NRElPKSAmJiBmZXAtDQo+ID4gPiA+ID5kZXZfaWQgPg0KPiA+ID4gPiAwKSB7
DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChmZXAtPnF1aXJrcyAmIEZFQ19RVUlSS19TSU5H
TEVfTURJTykgew0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIGZl
YzEgdXNlcyBmZWMwIG1paV9idXMgKi8NCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBpZiAobWlpX2NudCAmJiBmZWMwX21paV9idXMpIHsNCj4gPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZmVwLT5taWlfYnVzID0gZmVj
MF9taWlfYnVzOw0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBtaWlfY250Kys7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOw0KPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoH0NCj4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJldHVybiAtRU5PRU5UOw0KPiA+ID4gDQo+ID4gPiBDb3VsZCB5b3Ugbm90IGFkZCBhbiBlbHNl
IGNsYXVzZSBoZXJlPyByZXR1cm4gLUVQUk9CRV9ERUZGRVI/DQo+ID4gPiANCj4gPiA+IEJhc2lj
YWxseSwgaWYgZmVjMCBoYXMgbm90IHByb2JlZCwgZGVmZmVyIHRoZSBwcm9iaW5nIG9mIGZlYzE/
DQo+ID4gDQo+ID4gd2UgZG8gaGF2ZSBhIGNvbmZpZ3VyYXRpb24gd2l0aCBpLk1YOCB3aGVyZSB3
ZSBoYXZlIG9ubHkgZmVjMg0KPiA+IGVuYWJsZWQgKGFuZA0KPiA+IGhhcyBtZGlvIG5vZGUpLg0K
PiA+IEknbSBub3Qgc3VyZSBpZiBpdCB3YXMgdGhvdWdodCBvZiBieSBmZWMgZHJpdmVyIGRldmVs
b3BlcnMgKGl0DQo+ID4gbWFrZXMgYSBsb3Qgb2YNCj4gPiBub24tb2J2aW91cyBhc3N1bXRpb25z
KSwgYnV0IHRoYXQncyBob3cgaXQgd29ya3Mgbm93Lg0KPiA+IA0KPiANCj4gSGkgQWxleGFuZGVy
LA0KPiANCj4gVGhpcyBpc3N1ZSBzZWVtcyB0aGF0IHRoZSBmZWMyICh3aXRob3V0IG1kaW8gc3Vi
bm9kZSkgcmVnaXN0ZXJzDQo+IG1paV9idXMgZmlyc3QsIHRoZW4NCj4gdGhlIGZlYzEgKGhhcyBt
ZGlvIHN1Ym5vZGUpIHVzZSB0aGUgZmVjMidzIG1paV9idXMgd2hlbiBmZWMxIHByb2Jlcw0KPiBh
Z2FpbiwgZmluYWxseQ0KPiBib3RoIGZlYzEgYW5kIGZlYzIgY2FuIG5vdCBjb25uZWN0IHRvIFBI
WS4gQW0gSSByaWdodD8NCg0KeWVzLCB0aGlzIGlzIGV4YWN0bHkgd2hhdCBoYXBwZW5zIChleGNl
cHQgdGhhdCB3ZSBoYXZlIG1vcmUgdGhhbiBvbmUNClBIWSBpbiB0aGlzIG1kaW8gbm9kZSwgd2hp
Y2ggaXMgdGhlbiBub3QgcmVnaXN0ZXJlZC9wYXJzZWQpLg0KDQo+IElmIHNvLCBJIHRoaW5rIHRo
aXMgaXNzdWUgY2FuJ3QgYmUgcmVwcm9kdWNlZCBvbiB0aGUgdXBzdHJlYW0gdHJlZSwNCj4gYmVj
YXVzZSB0aGUgcXVpcmtzIG9mDQo+IGkuTVg4IG9uIHRoZSB1cHN0cmVhbSB0cmVlIGRvIG5vdCBz
ZXQgdGhlIEZFQ19RVUlSS19TSU5HTEVfTURJTyBiaXQuDQo+IFNvLCB0aGUgZmVjMQ0KPiB3aWxs
IHJlZ2lzdGVycyBhIG1paV9idXMgaW4geW91ciBjYXNlIHJhdGhlciB0aGFuIHVzaW5nIHRoZSBm
ZWMyJ3MNCj4gbWlpX2J1cy4gSSdtIGEgYml0IGN1cmlvdXMNCj4gdGhhdCBoYXZlIHlvdSB0cmll
ZCB0byByZXByb2R1Y2UgdGhpcyBpc3N1ZSBiYXNlIG9uIHRoZSB1cHN0cmVhbQ0KPiB0cmVlPw0K
DQpZb3UgYXJlIHJpZ2h0LCB0aGVyZSBpcyB1bmZvcnR1bmF0ZWx5IG5vIGkuTVg4IHN1cHBvcnQg
aW4gdGhlIHVwc3RyZWFtDQp0cmVlLCBzbyBpdCdzIG5vdCBwb3NzaWJsZSB0byByZXByb2R1Y2Ug
YW55dGhpbmcuIEp1c3Qgd2FudGVkIHRvDQpkaXNjdXNzIHRoZSBwcm9iZSBjb25jZXB0IG9mIHRo
aXMgZHJpdmVyLCB3aGljaCBpcyByYXRoZXIgZnJhZ2lsZQ0Kd2l0aCBhbGwgdGhlcmUgc3RhdGlj
IGxvY2FsIHZhcmlhYmxlcywgcHJvYmUgY2FsbCBjb3VudGVycyBhbmQgcmVseWluZw0Kb24gdGhl
IHByb2JlIG9yZGVyLiBBbGwgb2YgdGhpcyBmYWxscyB0b2dldGhlciBsaWtlIGEgaG91c2Ugb2Yg
Y2FyZHMNCmlmIHNvbWV0aGluZyBnZXRzIGRlZmVycmVkLg0KDQotLSANCkFsZXhhbmRlciBTdmVy
ZGxpbg0KU2llbWVucyBBRw0Kd3d3LnNpZW1lbnMuY29tDQo=
