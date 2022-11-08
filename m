Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52083621278
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiKHNck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiKHNci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:32:38 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70088.outbound.protection.outlook.com [40.107.7.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C696445A2F;
        Tue,  8 Nov 2022 05:32:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INlZFFEAUImZu96c4jm8RdYKfevBzd6Z1ayfc1SgIzrMsRvjrcydHRN3Ps40rkgajtHzmC2BrUGucFxLao758f5qWh8Zbun/95nxDA/JdJM19I6D1A7KiW+Gd9PAZ6SDM2dYAoK/06bjDGFYjejLXFw9t0lErS4GlmIiy2cyrKrpsML5bbU2btdnDV4TXSElVtAcVFCPyDfV2nf3wH4YaYNsBVCmG5QOswsZYt1Aw+1G8VTTpTPHOeWJ4AvjGEb9SeWmEK9AKVwRzZYwyLyMdEz6Hn9O5zN/kntTLom3j+GXMQuVjfvDX6nRQtAbZEVCbt7g7ksH/uVkg+nIjgkD6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1CC/DpMmM+U6puKZ44CSVz8mn1g/zG4w0YEA6fgYkGo=;
 b=XnsDxMhCzsFfXW5uGDgbD3xvaLOR9tvXSDTtxpmrLg3opnWpmD2SEHB+8Egv1Loqnf3S2DA/MBxdWSqoG18Sl70x9RVVMxk8N5tgo4E6yT6q62JhGGuxHkHXsvfp5rOPms1wSZvaC3+9NMZdnt7nVpVhvHLeRh+pp7Nq8BibC6dgomAap2Qy3+N6DhWm3AqsxZZj+GxuCm7hP+5awegiy/ZLTc424y7jgGxNE34CaA2e/OcJNUAj8p4bzdW5aHVft4CIc40bTDgM/p9tmCVeGm3lwNSXvz6ggqPJ2RKBzEZ6MnopOv1f/5nGwwYCwJA8uGNEi9Z6uuv7xA0LmZg9lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CC/DpMmM+U6puKZ44CSVz8mn1g/zG4w0YEA6fgYkGo=;
 b=lH+VBRmgXLrfN45CE3hjEfhZwdjOXdgEUvv/SmOIiXqjFKSEtdB0kDjsP8mdi2Z4GKlvGARjqvNFTEPqmwqKYSIAb74V7ASaPUFVvlPTFLPeq7Bw4dn+IGf/2Kz6C19xfytFEkWlt4qMkmlHq44uAacuSxFWj6/hGMCdCh4me0o=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8539.eurprd04.prod.outlook.com (2603:10a6:20b:436::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Tue, 8 Nov
 2022 13:32:35 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 13:32:35 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 2/2] net: fec: add xdp and page pool statistics
Thread-Topic: [EXT] Re: [PATCH 2/2] net: fec: add xdp and page pool statistics
Thread-Index: AQHY8rauh2VcDLYI7UGwmXA7I3IXAa40TXQAgAC5TCA=
Date:   Tue, 8 Nov 2022 13:32:35 +0000
Message-ID: <PAXPR04MB9185877046A0DCD7CE1CA3C0893F9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221107143825.3368602-1-shenwei.wang@nxp.com>
 <20221107143825.3368602-3-shenwei.wang@nxp.com> <Y2m+OHPaS6aV6GYx@lunn.ch>
In-Reply-To: <Y2m+OHPaS6aV6GYx@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM9PR04MB8539:EE_
x-ms-office365-filtering-correlation-id: 71a0318a-0b2e-4569-aa6a-08dac18db25a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ctRaBP0Pw0L1i5C2WPQOqEmjyRyPTbicPhsD3O4FLrKGxrZntXbvjzVp0g8nJovEhxic/3bs1xGL5wy9kPYG1llAKGEmzv1slAZ7HTTagMDOmU4FTf0aKWLwX3gd6IgmT53Gf4nIs1c8ZDJ/9DIlcwmWNs/ZRU5WSxol5OwkIJEwQl0RV6zvMw6uAS7PsdB78BgKr9+Kg3q8V8tTMGRkQJ0PLQqcOGkLxXdm7XBQa/tNf2Tz7VI0kOLl/6BQCvFGg4smCU4dRHO63UjRybDxJoZlVTHSuo6sk/KZwF51QG6dDTCwnTii1Vuoc7Be/5qSpXaRYLS8yyrwsYsXx15K5rNolLXRlH9hPZJxRAAlaPiiSif8xmzYrS5mMC2Q3nmW85wqWvzRAuB6MtbdTd7ULoZirzPOGxC8tR63IfJ9GslmHmzJ/d8uBs4lh6lis46GBwor3g49v6CInpJ/VVIPs4ueNJ8Qc+jAqTlsmXHCINX2oFMA7i/86gQFER49t7KkB1VGwsZkcdLswkrhDJLkB7ivnEwGcx4mfSEWxz+c9D5Kq2J+TpeWcgi2qUep1fJrLIwYfGTbCy3gupX55ekLeJgZFc6uGCfqISTqEXPE1cNnT6VQsrJdPrDKEq310H0pYnHou0EvzXAkNkFU2J6VUNJ/kLsOK/rq92WQfDj6bikDVATmkpSpW3qL1FsC+xOYAGG6Y5EZcNfQmRRsLzgDf5JyxP4SMo0fyjacWG7nvhETYPFlanUHPDUQN9k9dEBn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(66899015)(83380400001)(41300700001)(33656002)(8676002)(6506007)(7696005)(44832011)(86362001)(4326008)(2906002)(38070700005)(38100700002)(8936002)(122000001)(55016003)(5660300002)(71200400001)(7416002)(52536014)(55236004)(66476007)(76116006)(6916009)(9686003)(64756008)(26005)(66446008)(186003)(66946007)(478600001)(66556008)(54906003)(53546011)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXRRQ1gxQWlTVGJkL0Q5dUN0bG95Q0M5cndWc3phWXI0dnQ5WjZZaFpnUFUw?=
 =?utf-8?B?UGlkNGNFcW5BRHNEYzJWbE5MNFM1L3l1NC8zVFRFZk9Ic0M0b2drRldiMVdG?=
 =?utf-8?B?QWVqK3Z5d24xSTV5dGdaVXNIM1lWaEllV1dkNkF4YW9PREdibVZ1VVB0cXd4?=
 =?utf-8?B?V2NyVGI0Zk1Ydm8yTWF6R2p5a1ovaVBWenNRMWU2eW5FbFVwL1I0ZS9NMVFO?=
 =?utf-8?B?SWJ3bktiQW1MYkRtOXpnUnRaY3oxNllYVUtrZXpzeW81Vk83VXlqQVZsc0Vn?=
 =?utf-8?B?UTFZSTQyNm9xalBNYkNQVGcxVkI2VHB2ZE5wTTFoZHR6QW1saVZpUVkvU2t2?=
 =?utf-8?B?L0ZKdVRPZ2JhaSt3M0VmUDF6bU9zQUdLVFJ6V1BaN1p1R3NyeW5rWk9GVnc0?=
 =?utf-8?B?TXp4NWJOMXJxcUw2L29UWE9JaGM3d3UvWEFkZnJVZURDMklvdi9wQnB6WHRI?=
 =?utf-8?B?dFc2OFRkS3RqbHljWDg2OWNwMEdLMW9iL1VhVHkvVHFVTDJHMlF3Z2M0QzUz?=
 =?utf-8?B?anJINXdreENtYmNudDRoaytMVm80ZjRmRWtQQkRZK0VKaU50Mk4yNWlMZGhH?=
 =?utf-8?B?ZHVDaFdQbncyY0cwY0hoemVOOEk4dFhnTXJGeUw1YllzaHB6QVlyZm5jOCtC?=
 =?utf-8?B?VVU4TU9wTzRlQ3lObTF1QW5nZXN0Wk8rc3BkUUI1WTA1SlVhbzFPb1FqalFI?=
 =?utf-8?B?ZHUvY05wWnl3TnhxcGp1ZkVJMURURmM0d1lHUVVzWmZkdW1qOEIzRXhzbUFa?=
 =?utf-8?B?VUVhcXVBYkt0RGFBc0FsSkk2ZlVpMTBTSDZVMUFJUVR2WkgwUXFHcGtzQUxD?=
 =?utf-8?B?WStld0sxQTdsTFlHTlJjUGdNMDl1NzFsTkVuczlYcGJQanlCR2dRakRLL1or?=
 =?utf-8?B?K2RIVmcwdVkzekNFVktVbENaTmhZdjFuUE8veTYyc2ZZd0RITXF5QUpLMFl4?=
 =?utf-8?B?R21mbFNHS0I0M2ZadmNIVnkwMTZsZ3BUU2RLSDFpcE1qeVhuSm5OSHZjbnpa?=
 =?utf-8?B?K0lpTFdZR3NJRXdrUlFjM3J2S0lrRHF0cWNXZU9MRjRSYXFZU1pQNXRxVUQv?=
 =?utf-8?B?Vi9rcnNwQVZtK1ZtVlQyQ205S1FXaGpqOGJQNzZJMjJ5RXZPZUJxTGxpSHg0?=
 =?utf-8?B?SzlYVnNNY1JyVHFpNVVvTFo4ZEgwaEVEU0I4MERYYWo2OUhveng2aWRmeVdX?=
 =?utf-8?B?RUpiUnFHaEE2S04venRsTFNJV3BOV283Uk8zZjdoK0lZbzNIU2NMaVhZaFJM?=
 =?utf-8?B?Y3JZRXR2bFk3STJSRVdPakMraG5qcWVXRlMwdkFZUU1JdmdGbnRlZGc3NVkx?=
 =?utf-8?B?WXN1cmM4dGpjQ1JpQlF0bEJ1N0ZBdlg2S1d2NVkvMnk2YTg1MTdrZmRBRnZp?=
 =?utf-8?B?eWpobEl4NlZ1TlY0RzROdHdWYUlVWElSZDQvZ0dKVUlYRDFkaFZtdEZjSGl3?=
 =?utf-8?B?T1BzTXVRZ1JDZ21UVDJOdWh6cGVuWThhTXl2eDRNR2pyaVRYK25FMWJraEZS?=
 =?utf-8?B?SG54d1M5d095NDR2c1pGcERnNUtoSmVXZnZ6N1FKdWhwYmEycFhnV285SjZM?=
 =?utf-8?B?ek5HN29aOFpRMkJtWFIvOVVYS0I3azhiYUtaWHlkYUFXTjU5cklnTktEK3ND?=
 =?utf-8?B?U3RnR3hUODRPWDh6eE9EMzUrNkE0dUowVjZvVWZVVEV6NzBYa1F4em4yZDNF?=
 =?utf-8?B?TklrZDZGWW8ydkluOUVDNXJZODJrNXovbU5rV1hXRDMreUV1dzNwWDNtWnlJ?=
 =?utf-8?B?T3hhc1A0aU5kRHF1dEIrd084ejBtWkp3aktWQmladWRZWC9mUFdnZjRYMmhz?=
 =?utf-8?B?d3hVaU1aY2xEeW5QUHhKTDc3VUkwZkZGazVhcFVQTVliSEZuOVNPVUxxRWJB?=
 =?utf-8?B?K0p3Zmwwd0ZRSC81emNTN2FMTmprU1hKc1lnMWluYWxvOXZNNkVuNDduVERK?=
 =?utf-8?B?TFRuZmhjaVdtalBjc1Y5OHpKeVhtV0h0QjkvSWdMSzRZbkRvWHlpMTR6bkM0?=
 =?utf-8?B?SXlRa1lpTmk5UnEzMk5ia0NoWjExVEd1bUVpMVV3Y0x2QWx4dkVNL2RtaVpH?=
 =?utf-8?B?b0ZJa0ZrUSs5bE16RVFVSC9Vc21jMU9WWW92aUt4Z2xRR1lkbTd2ek42Vk1s?=
 =?utf-8?Q?s2fboeL/N/J4nQTp8GbQZwQzn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a0318a-0b2e-4569-aa6a-08dac18db25a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 13:32:35.2557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rBJguX1vbSWXA8VIEn8tLQKafXKa5E3gg0fC6+59Zx94CLQ6PStuwG6oOjZX/CPZR5WVeRyB00P8bDnaYSFDgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8539
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiBNb25kYXksIE5vdmVtYmVyIDcsIDIwMjIgODoyNiBQTQ0K
PiBUbzogU2hlbndlaSBXYW5nIDxzaGVud2VpLndhbmdAbnhwLmNvbT4NCj4gPg0KPiA+IC0jZGVm
aW5lIEZFQ19TVEFUU19TSVpFICAgICAgICAgICAgICAgKEFSUkFZX1NJWkUoZmVjX3N0YXRzKSAq
IHNpemVvZih1NjQpKQ0KPiA+ICtzdGF0aWMgc3RydWN0IGZlY194ZHBfc3RhdCB7DQo+ID4gKyAg
ICAgY2hhciBuYW1lW0VUSF9HU1RSSU5HX0xFTl07DQo+ID4gKyAgICAgdTY0IGNvdW50Ow0KPiA+
ICt9IGZlY194ZHBfc3RhdHNbWERQX1NUQVRTX1RPVEFMXSA9IHsNCj4gPiArICAgICB7ICJyeF94
ZHBfcmVkaXJlY3QiLCAwIH0sICAgICAgICAgICAvKiBSWF9YRFBfUkVESVJFQ1QgPSAwLCAqLw0K
PiA+ICsgICAgIHsgInJ4X3hkcF9wYXNzIiwgMCB9LCAgICAgICAgICAgICAgIC8qIFJYX1hEUF9Q
QVNTLCAqLw0KPiA+ICsgICAgIHsgInJ4X3hkcF9kcm9wIiwgMCB9LCAgICAgICAgICAgICAgIC8q
IFJYX1hEUF9EUk9QLCAqLw0KPiA+ICsgICAgIHsgInJ4X3hkcF90eCIsIDAgfSwgICAgICAgICAg
ICAgICAgIC8qIFJYX1hEUF9UWCwgKi8NCj4gPiArICAgICB7ICJyeF94ZHBfdHhfZXJyb3JzIiwg
MCB9LCAgICAgICAgICAvKiBSWF9YRFBfVFhfRVJST1JTLCAqLw0KPiA+ICsgICAgIHsgInR4X3hk
cF94bWl0IiwgMCB9LCAgICAgICAgICAgICAgIC8qIFRYX1hEUF9YTUlULCAqLw0KPiA+ICsgICAg
IHsgInR4X3hkcF94bWl0X2Vycm9ycyIsIDAgfSwgICAgICAgIC8qIFRYX1hEUF9YTUlUX0VSUk9S
UywgKi8NCj4gPiArfTsNCj4gDQo+IFdoeSBkbyB5b3UgbWl4IHRoZSBzdHJpbmcgYW5kIHRoZSBj
b3VudD8NCg0KSXQgd2FzIGZvbGxvd2luZyB0aGUgb3JpZ2luYWwgY29kaW5nIHN0eWxlIGJ1dCBp
dCBpcyBub3QgZ29vZC4gV2lsbCBmaXggaXQgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KPiANCj4g
PiArDQo+ID4gKyNkZWZpbmUgRkVDX1NUQVRTX1NJWkUgICAgICAgKChBUlJBWV9TSVpFKGZlY19z
dGF0cykgKyBcDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIEFSUkFZX1NJWkUoZmVjX3hkcF9z
dGF0cykpICogc2l6ZW9mKHU2NCkpDQo+ID4NCj4gPiAgc3RhdGljIHZvaWQgZmVjX2VuZXRfdXBk
YXRlX2V0aHRvb2xfc3RhdHMoc3RydWN0IG5ldF9kZXZpY2UgKmRldikgIHsNCj4gPiAgICAgICBz
dHJ1Y3QgZmVjX2VuZXRfcHJpdmF0ZSAqZmVwID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gPiAtICAg
ICBpbnQgaTsNCj4gPiArICAgICBzdHJ1Y3QgZmVjX3hkcF9zdGF0IHhkcF9zdGF0c1s3XTsNCj4g
DQo+IFlvdSBhcmUgYWxsb2NhdGluZyA3IHggbmFtZVtFVEhfR1NUUklOR19MRU5dLCBoZXJlLCB3
aGljaCB5b3UgYXJlIG5vdCBnb2luZw0KPiB0byB1c2UuIEFsbCB5b3UgcmVhbGx5IG5lZWQgaXMg
dTY0IHhkcF9zdGF0c1tYRFBfU1RBVFNfVE9UQUxdDQo+IA0KPiA+ICsgICAgIGludCBvZmYgPSBB
UlJBWV9TSVpFKGZlY19zdGF0cyk7DQo+ID4gKyAgICAgc3RydWN0IGZlY19lbmV0X3ByaXZfcnhf
cSAqcnhxOw0KPiA+ICsgICAgIGludCBpLCBqOw0KPiA+DQo+ID4gICAgICAgZm9yIChpID0gMDsg
aSA8IEFSUkFZX1NJWkUoZmVjX3N0YXRzKTsgaSsrKQ0KPiA+ICAgICAgICAgICAgICAgZmVwLT5l
dGh0b29sX3N0YXRzW2ldID0gcmVhZGwoZmVwLT5od3AgKw0KPiA+IGZlY19zdGF0c1tpXS5vZmZz
ZXQpOw0KPiA+ICsNCj4gPiArICAgICBmb3IgKGkgPSBmZXAtPm51bV9yeF9xdWV1ZXMgLSAxOyBp
ID49IDA7IGktLSkgew0KPiA+ICsgICAgICAgICAgICAgcnhxID0gZmVwLT5yeF9xdWV1ZVtpXTsN
Cj4gPiArICAgICAgICAgICAgIGZvciAoaiA9IDA7IGogPCBYRFBfU1RBVFNfVE9UQUw7IGorKykN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgeGRwX3N0YXRzW2pdLmNvdW50ICs9IHJ4cS0+c3Rh
dHNbal07DQo+ID4gKyAgICAgfQ0KPiA+ICsNCj4gPiArICAgICBmb3IgKGkgPSAwOyBpIDwgWERQ
X1NUQVRTX1RPVEFMOyBpKyspDQo+ID4gKyAgICAgICAgICAgICBmZXAtPmV0aHRvb2xfc3RhdHNb
aSArIG9mZl0gPSB4ZHBfc3RhdHNbaV0uY291bnQ7DQo+IA0KPiBJdCB3b3VsZCBiZSBtb3JlIGxv
Z2ljYWwgdG8gdXNlIGogaGVyZS4NCj4gDQo+IEl0IGlzIGFsc28gcHJldHR5IG1lc3N5LiBGb3Ig
ZmVjX2VuZXRfZ2V0X3N0cmluZ3MoKSBhbmQNCj4gZmVjX2VuZXRfZ2V0X3NzZXRfY291bnQoKSB5
b3UgZGVhbCB3aXRoIHRoZSB0aHJlZSBzZXRzIG9mIHN0YXRzIGluZGl2aWR1YWxseS4gQnV0DQo+
IGhlcmUgeW91IGNvbWJpbmUgbm9ybWFsIHN0YXRzIGFuZCB4ZHAgc3RhdHMgaW4gb25lLiBJdCB3
aWxsIHByb2JhYmx5IGNvbWUgb3V0DQo+IGNsZWFuZXIgaWYgeW91IGtlZXAgaXQgYWxsIHNlcGFy
YXRlLg0KDQpBZnRlciB5b3Ugc2FpZCBzbywgSSBmZWVsIGl0IG1lc3N5IHRvby4gIFdpbGwgY2xl
YW4gdXAgdGhlIGNvZGVzLg0KDQo+IA0KPiA+ICBzdGF0aWMgdm9pZCBmZWNfZW5ldF9nZXRfZXRo
dG9vbF9zdGF0cyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgZXRodG9vbF9zdGF0cyAqc3RhdHMsIHU2NA0KPiA+
ICpkYXRhKSAgew0KPiA+ICAgICAgIHN0cnVjdCBmZWNfZW5ldF9wcml2YXRlICpmZXAgPSBuZXRk
ZXZfcHJpdihkZXYpOw0KPiA+ICsgICAgIHU2NCAqZHN0ID0gZGF0YSArIEZFQ19TVEFUU19TSVpF
IC8gODsNCj4gDQo+IFdoeSA4PyBzaXplb2YodTY0KSB3b3VsZCBiZSBhIGJpdCBjbGVhcmVyLiBP
ciBqdXN0IHVzZQ0KPiBBUlJBWV9TSVpFKGZlY19zdGF0cykgd2hpY2ggaXMgd2hhdCB5b3UgYXJl
IGFjdHVhbGx5IHdhbnRpbmcuDQo+IA0KPiA+DQo+ID4gICAgICAgaWYgKG5ldGlmX3J1bm5pbmco
ZGV2KSkNCj4gPiAgICAgICAgICAgICAgIGZlY19lbmV0X3VwZGF0ZV9ldGh0b29sX3N0YXRzKGRl
dik7DQo+ID4NCj4gPiAgICAgICBtZW1jcHkoZGF0YSwgZmVwLT5ldGh0b29sX3N0YXRzLCBGRUNf
U1RBVFNfU0laRSk7DQo+ID4gKw0KPiA+ICsgICAgIGZlY19lbmV0X3BhZ2VfcG9vbF9zdGF0cyhm
ZXAsIGRzdCk7DQo+ID4gIH0NCj4gPg0KPiA+ICBzdGF0aWMgdm9pZCBmZWNfZW5ldF9nZXRfc3Ry
aW5ncyhzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LA0KPiA+ICAgICAgIHUzMiBzdHJpbmdzZXQs
IHU4ICpkYXRhKQ0KPiA+ICB7DQo+ID4gKyAgICAgaW50IG9mZiA9IEFSUkFZX1NJWkUoZmVjX3N0
YXRzKTsNCj4gPiAgICAgICBpbnQgaTsNCj4gPiAgICAgICBzd2l0Y2ggKHN0cmluZ3NldCkgew0K
PiA+ICAgICAgIGNhc2UgRVRIX1NTX1NUQVRTOg0KPiA+ICAgICAgICAgICAgICAgZm9yIChpID0g
MDsgaSA8IEFSUkFZX1NJWkUoZmVjX3N0YXRzKTsgaSsrKQ0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICBtZW1jcHkoZGF0YSArIGkgKiBFVEhfR1NUUklOR19MRU4sDQo+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZmVjX3N0YXRzW2ldLm5hbWUsIEVUSF9HU1RSSU5HX0xFTik7DQo+
ID4gKyAgICAgICAgICAgICBmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRShmZWNfeGRwX3N0YXRz
KTsgaSsrKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBtZW1jcHkoZGF0YSArIChpICsgb2Zm
KSAqIEVUSF9HU1RSSU5HX0xFTiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZl
Y194ZHBfc3RhdHNbaV0ubmFtZSwgRVRIX0dTVFJJTkdfTEVOKTsNCj4gPiArICAgICAgICAgICAg
IG9mZiA9IChpICsgb2ZmKSAqIEVUSF9HU1RSSU5HX0xFTjsNCj4gPiArICAgICAgICAgICAgIHBh
Z2VfcG9vbF9ldGh0b29sX3N0YXRzX2dldF9zdHJpbmdzKGRhdGEgKyBvZmYpOw0KPiANCj4gUHJv
YmFibHkgc2ltcGxlciBpczoNCj4gDQo+ICAgICAgICAgICAgICAgICBmb3IgKGkgPSAwOyBpIDwg
QVJSQVlfU0laRShmZWNfc3RhdHMpOyBpKyspIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAg
bWVtY3B5KGRhdGEsIGZlY19zdGF0c1tpXS5uYW1lLCBFVEhfR1NUUklOR19MRU4pOw0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICBkYXRhICs9IEVUSF9HU1RSSU5HX0xFTjsNCj4gICAgICAgICAg
ICAgICAgIH0NCj4gICAgICAgICAgICAgICAgIGZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGZl
Y194ZHBfc3RhdHMpOyBpKyspIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgbWVtY3B5KGRh
dGEsIGZlY194ZHBfc3RhdHNbaV0ubmFtZSwgRVRIX0dTVFJJTkdfTEVOKTsNCj4gICAgICAgICAg
ICAgICAgICAgICAgICAgZGF0YSArPSBFVEhfR1NUUklOR19MRU47DQo+ICAgICAgICAgICAgICAg
ICB9DQo+ICAgICAgICAgICAgICAgICBwYWdlX3Bvb2xfZXRodG9vbF9zdGF0c19nZXRfc3RyaW5n
cyhkYXRhKTsNCg0KWWVzLCB0aGlzIGxvb2tzIGJldHRlci4g8J+Yig0KDQpUaGFua3MsDQpTaGVu
d2VpDQoNCj4gDQo+ICAgICAgICAgQW5kcmV3DQo=
