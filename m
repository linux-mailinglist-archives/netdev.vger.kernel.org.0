Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9D0468838
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 00:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhLDXWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 18:22:23 -0500
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:64270
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231811AbhLDXWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 18:22:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UY4u/EXNTbp5vQTy7jBbefkeHeEYMrmtJAmo7eh1wEy2wKE5K41cSUM5r9ivR0bKHvzLzO7hpQo3NWX1LJUcFhoeDZxnkiNWrX84MaZ4zvpIJHYuITqpZowlTA6Nn3hzPHaIJyCFWJTp39D23ZyKIsDEHxaCPqbybGwpUf70Az+vuH4GOf10K5B8i/pwFV+S8VkMxhJm4TSuUBPXSv6ts5ORAD2mwsSOmcK06jyBsGUKv49km5SQLZBZOx0h3svfKiDVM+uR6SyGY2baR7HEv7zy4I+XDA2msXcdPghIZF2SFtUUoNZeOgWoZdEURr7dumcFkgnV3FY7/csWOBYC1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZGT6GxhR+UoX148Yz3+yFGvLP7BaL7OWvZDs/XcdGc=;
 b=CtvTHaslYyVeW4sUAiXvlbRmg+OVGFBujaqt4JudQBOhWcu2Q35v9xj9oe412E8QEAnYz5xWNutFqt0O2tyVOJbOi6OOkyJ3CnqKl/12zxFhmXcF2CmhsJ1wd12Gk7eUhgp1e/QJH1l4eG7bxB92pAxu/btuZ49OwZG2ksPgF1P14Fn9z9uQ7vDe/9tQwe6oqffolOnYBEfHGA36oh6Zd9oXNPCJSDocKbBkkyrIHl3767233hQvMuDiqW0/nFwX7iBcfWUyckq5ZUUWwhrqTheqpiq7ZKyMI4Kp3O6/F+LTcBY277kyp4+CcTXemQs5Vw3IjKEdWvt+m2VFICnzfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZGT6GxhR+UoX148Yz3+yFGvLP7BaL7OWvZDs/XcdGc=;
 b=N/iQ06NX/yWlWu11XQqIwYg+NgeCzEDU/o7BtYiKJDlJbwneqHHDhsffgV2G67/HBfB2uUAEAQwWlqFQ5ZzEBCupBKvI84/5ueLlo7wbexggBc4WVsKyMXhEJdK5jBFhComw/N7l/4SKLvNMbFLxqkqC5Mfwu2Ggd6QHKcNuFow=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6638.eurprd04.prod.outlook.com (2603:10a6:803:119::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Sat, 4 Dec
 2021 23:18:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.021; Sat, 4 Dec 2021
 23:18:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v2 net-next 5/7] net: dsa: keep the bridge_dev and
 bridge_num as part of the same structure
Thread-Topic: [PATCH v2 net-next 5/7] net: dsa: keep the bridge_dev and
 bridge_num as part of the same structure
Thread-Index: AQHX6Us0rGOGVx7TCEmiIGAh5tQZfKwi+ASA
Date:   Sat, 4 Dec 2021 23:18:54 +0000
Message-ID: <20211204231853.a4z2p3vv5jor4nxx@skbuf>
References: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
 <20211204201146.4088103-6-vladimir.oltean@nxp.com>
In-Reply-To: <20211204201146.4088103-6-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 509c6d84-2b92-4e71-ce81-08d9b77c70a2
x-ms-traffictypediagnostic: VE1PR04MB6638:
x-microsoft-antispam-prvs: <VE1PR04MB6638B5655EE1B282940C9874E06B9@VE1PR04MB6638.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BP2olCD24kfKtRnhIGJhvF3YPe64I5oAYkIoVVwkIIDC//irSPVpbtsC6oPT/SXkJ0HpJ3AQyYX6yNt6RBySkPBtnr1ptBLXwqAWcl9jUFUnj7gRpuAZKJjpIzL5a6YSndsqryE2Vj04wwZfszwzEeKJBDqePsARg/fOpAhqPedaN9y7IMI+Yfe/o60iCs9nsm21yR3F+0+yMRLBR46ygyok721cdd3FpHMLQfKx1i8QQAUdqz+/T41FdgNYFOk6tpgD87mXNdCsPmEzXnl0aldShqSeCAjZiGBRuIEJTx2CSuJDoWLnAKmmDjOzj6fi0n/+s4Nmh9GkhApvy5g5dcw9cCIXf3RdQoMFKyoojyMELaZpHktDj41IAs68uXTQJfVwDq54SwDcEGUpKFTeZwmiye+8M7VyAfzEvSP1lqvfJ2cVRi260YrgsOjKdldbuAePOw3QVYaar/DO/R3GZORJBa1B4QpQvO0VpgA/O5Bms90N/It73E8H/t0wSC5+h6l+uhUmLeRdBDlV3EdySY50PziSlXE+XWNaSAl4TYzUw4lTcHlCNdbnAi4NLcbRKh1xMqtXNlRrN6EDEhijOtHDGkntU+WRgtv1BMa8WH0b2fomTxW3PYv2s6WQWbTUZdJwaTDF91NyUAy4ubi5pRAihE4v+VIoSOsUhQWAIinibUljahiHCjO2Z74AIi08NgcRzpfP5q13jTLN4Cuumw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(1076003)(86362001)(6486002)(38070700005)(508600001)(83380400001)(44832011)(6916009)(9686003)(6512007)(33716001)(316002)(71200400001)(122000001)(4326008)(66446008)(8676002)(186003)(2906002)(26005)(6506007)(64756008)(76116006)(7416002)(54906003)(38100700002)(5660300002)(8936002)(91956017)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?UGZIcGhOTTVpQXNYdUJSS0JXTllMcktIR3Z1LzZRNzZIQ2pqNlhRUHZkS2tu?=
 =?gb2312?B?elVuOE5BNHhINnRRT0JVL0pXdkIxRkZXOWpUNlpoUm9EQ2h1MHRBcWI5Ykln?=
 =?gb2312?B?aDlKTDFlZGw2UXBaL2NNWTdrRC91RUNDVjBUOCthWld0QktOV21ERnloK2Q1?=
 =?gb2312?B?cTVpWXVNdCtBRE9rSEtMY1ZOd1lXYTNDZWtKWDlFUU1GbmlxUWlBZ3kzUVZt?=
 =?gb2312?B?ZUwvRDR1WWRTRGJ4N1QraUpJSjN4Nk9LaVZrOUdlSUhoeFVrMlAyTktFdWxp?=
 =?gb2312?B?aDNwd1FUTGx4dWxtMkF2RUROYjZhb0NNOXlFRW43WG9YN3VsUDhkd1BpMVV0?=
 =?gb2312?B?T2RxQVhPam9BVnJ3RlRqZFQrZWxsQ3lOMmZBUFJUUHV6UUx3VTlnT0JVY0JP?=
 =?gb2312?B?KzkwenJ0WG9UN1dGS2gzM29MVnZGMHNseDNOTzhQTXBMWk9udG84VFFsdWVT?=
 =?gb2312?B?eVJUZnlaS1FqcFJYdE91SElnM3ZWbFE5TGRJRUI5cEtVa08rRzFHQVNqU3pV?=
 =?gb2312?B?SEVzUDF5NWF5TURaODZ3K2h5aDgxeWhHQWhNRmNYSjd2ZUVJakFBL1ZiOXNz?=
 =?gb2312?B?WVRHZGlxSFlFeFFBUFFtVHFyODRFenlMN3NaWHlnRFhsV0c1cCtwUU9lTHUz?=
 =?gb2312?B?cXd5eGRwTzI1RUptaksvV3dlc1REVy9uekgvNzF6aERtMHJUckFvMlVwSUxS?=
 =?gb2312?B?MzNTSFRFUC9YMFl6Z1VUZ3JmUXpNYTJ5TDFNSnpScC9WWDZtdW5TWlZtTkp5?=
 =?gb2312?B?VW5GR0lnVW5NK29UZmE4YjBOUExBZm5YdXZJOEcvQWU4YzZrd3UxN1Z1QzBW?=
 =?gb2312?B?Q2szNUVmZzludWJsdjV1R3A1UW1pREtOM0VIakRRcDZESmYyVWszNHlNU21D?=
 =?gb2312?B?bVNMalhTYWorQ2hRS211aUFodGdGYWlrZ2dwU3RDWmd2VnhwK2VCMWdwWlg3?=
 =?gb2312?B?QkNxUE96S0lkWFczV2hVMEhxcDR5N1pKK3UyeGw5SEcvbjNRNU8vNUt0aEVC?=
 =?gb2312?B?bGJmVTNOc1dLbStpVitNNGtSd3JBMDQ1aGdsK2RSV3dpemZDUUV5TGU1NlFj?=
 =?gb2312?B?VkNDWkNjZkZWbC8wVG5WUjJTMTAzb3VEQlJzZmMyWU1BRnIyY3AzNE9UZm1N?=
 =?gb2312?B?WEtYS2NoTTNaK2hEQnJYbklZc0hxK2hKN0tGNTljZitFNFE1RytHcEJ2ZXlF?=
 =?gb2312?B?azQvcDlIcTU1dG14S2hoVGxqeE13SERMeHFVbk9Bcm9kYit0SFUweWJ0a3U4?=
 =?gb2312?B?TWtudytOOGs3cDhpbmxXTHBJQ2M0NXpXUmtJODR2Y1VGLytsZGwxSUpnYVU1?=
 =?gb2312?B?b0RNVXgwSHNOaFBpSTEzV1lYNThZQTJhZ1YzOFhFaU9pVDlqM1lmVS92d0Fz?=
 =?gb2312?B?VG5MTjM1ZDFEV2t4eG1NUzlKcmtDRCs5bXo5a0NHSmtVUGdvaWNsaGw3SlRl?=
 =?gb2312?B?WmZ4SXozYTFVNEtOajNIdVlFaUo5OXpDOHp4eFBsVXZ1cjlwQ3V4NHBuU0Ri?=
 =?gb2312?B?dG1hdHJBS0labFJmWXg4ZngvVjJIL1RhMmFleThGTlc0MkVSbTF0TmhqM1d3?=
 =?gb2312?B?UWQvb05BU2RFZ3FmNGlxS09DZlJsaEcwQnFDQWRKQ0I2VngxaEFVRm93YnBp?=
 =?gb2312?B?QXlLMzFvWWFkYXRDMnIvZDdQSFU0UGNkY2RBZE03RVZjcHBuaWQyUWFHbjZu?=
 =?gb2312?B?RmJHOHBLdU9pSjRxdk1mMnpLZGFNcnVnQm1xZ3lhbjRtbFQ2emFaTk1XK0Zt?=
 =?gb2312?B?b29LKzNyQW0xZDBES29WbmovQzI1QVhNaFJzN0swcWxLS3Npdko5N2NDeWln?=
 =?gb2312?B?ajVLWUJ6VjBKa3RsYm1qQWVYTEkrU2pyK0l1dkdXT3dJZmpJcXhJMnBLcXhR?=
 =?gb2312?B?YXJlNmdSajdaSzQ4alU5RFpZSXUxaTUyNWR0WlNtbmlteFcwMXFLZTErTVVI?=
 =?gb2312?B?cFBJWW1EWmNrZzM1MVFFWFlJYTNyUndCK3VFTTJ6aGxZb3pSWXJIdzZzTkV2?=
 =?gb2312?B?NXVjc1NrSzVLdHBEaWZFUEdDdjJRRHhLME1FRUdraWJDQkpjZ0dMZzRhRUFR?=
 =?gb2312?B?ZVJBTzlvbE1xZHgvektoNXhRRWtYRGlTaGR2VVp6OHZtako1ZkJzbmptZFM3?=
 =?gb2312?B?WjZoa0hzYVRvcThlNkRodFYwMzlaMzJXTDliZXh0WDg3RjJtcTA3REkvVnNT?=
 =?gb2312?Q?zBduzKdIRT4Co0lY9gKPigU=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <4B3DA40D8A6C9041B8FA1AA0B7147427@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509c6d84-2b92-4e71-ce81-08d9b77c70a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 23:18:54.2556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KLTJ9SXKOnA//RHSycydymIyhPgjBLKVRlAthrTvwQU3hSvqYK3PEPkLXxibDdaQnSyDjnv4AeJUGEadpKwamg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6638
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCBEZWMgMDQsIDIwMjEgYXQgMTA6MTE6NDRQTSArMDIwMCwgVmxhZGltaXIgT2x0ZWFu
IHdyb3RlOg0KPiBAQCAtMzEwLDIxICszMDYsMzEgQEAgc3RhdGljIGludCBkc2FfcG9ydF9icmlk
Z2VfY3JlYXRlKHN0cnVjdCBkc2FfcG9ydCAqZHAsDQo+ICAJCQkJICBzdHJ1Y3QgbmV0bGlua19l
eHRfYWNrICpleHRhY2spDQo+ICB7DQo+ICAJc3RydWN0IGRzYV9zd2l0Y2ggKmRzID0gZHAtPmRz
Ow0KPiAtCXVuc2lnbmVkIGludCBicmlkZ2VfbnVtOw0KPiArCXN0cnVjdCBkc2FfYnJpZGdlICpi
cmlkZ2U7DQo+ICANCj4gLQlkcC0+YnJpZGdlX2RldiA9IGJyOw0KPiAtDQo+IC0JaWYgKCFkcy0+
bWF4X251bV9icmlkZ2VzKQ0KPiArCWJyaWRnZSA9IGRzYV90cmVlX2JyaWRnZV9maW5kKGRzLT5k
c3QsIGJyKTsNCj4gKwlpZiAoYnJpZGdlKSB7DQo+ICsJCXJlZmNvdW50X2luYygmYnJpZGdlLT5y
ZWZjb3VudCk7DQo+ICsJCWRwLT5icmlkZ2UgPSBicmlkZ2U7DQo+ICAJCXJldHVybiAwOw0KPiAr
CX0NCj4gKw0KPiArCWJyaWRnZSA9IGt6YWxsb2Moc2l6ZW9mKCpicmlkZ2UpLCBHRlBfS0VSTkVM
KTsNCj4gKwlpZiAoIWJyaWRnZSkNCj4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ICsNCj4gKwlyZWZj
b3VudF9zZXQoJmJyaWRnZS0+cmVmY291bnQsIDEpOw0KPiArDQo+ICsJYnJpZGdlLT5kZXYgPSBi
cjsNCj4gIA0KPiAtCWJyaWRnZV9udW0gPSBkc2FfYnJpZGdlX251bV9nZXQoYnIsIGRzLT5tYXhf
bnVtX2JyaWRnZXMpOw0KPiAtCWlmICghYnJpZGdlX251bSkgew0KPiArCWJyaWRnZS0+bnVtID0g
ZHNhX2JyaWRnZV9udW1fZ2V0KGJyLCBkcy0+bWF4X251bV9icmlkZ2VzKTsNCj4gKwlpZiAoZHMt
Pm1heF9udW1fYnJpZGdlcyAmJiAhYnJpZGdlLT5udW0pIHsNCj4gIAkJTkxfU0VUX0VSUl9NU0df
TU9EKGV4dGFjaywNCj4gIAkJCQkgICAiUmFuZ2Ugb2Ygb2ZmbG9hZGFibGUgYnJpZGdlcyBleGNl
ZWRlZCIpOw0KDQpUaGVyZSBzaG91bGQgYmUgYSBrZnJlZShicmlkZ2UpIGhlcmUgYmVmb3JlIHJl
dHVybmluZyAtRU9QTk9UU1VQUC4NCkknbGwgd2FpdCBmb3IgZnVydGhlciBmZWVkYmFjayBiZWZv
cmUgcmVwb3N0aW5nLg0KDQo+ICAJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gIAl9DQo+ICANCj4g
LQlkcC0+YnJpZGdlX251bSA9IGJyaWRnZV9udW07DQo+ICsJZHAtPmJyaWRnZSA9IGJyaWRnZTsN
Cj4gIA0KPiAgCXJldHVybiAwOw0KPiAgfQ==
