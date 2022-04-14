Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FE35003B8
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 03:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbiDNBnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 21:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiDNBnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 21:43:22 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60108.outbound.protection.outlook.com [40.107.6.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309EA21259;
        Wed, 13 Apr 2022 18:40:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwSIjL/N3M0+fCpE0RRnvV4rKCdeTPNd99pOnhf4O/os/CFAK/3V6jVbMD8DNaNcpXsWETRFdcT95Y/E8V/2ubkiVkk1EsbzJPRMDTzxOM3F+OLa33zlrMvftnOQBDbwTvzAfmSqMzKCj/uUje5oGAw/svKRqOY5sFFa1f/W0yc4erv4uyitp4szgxWbtECJtxPbegcljYmae/CTiS7Bhqgus3WEPF2/fY1AqPKsLzInySdEJxzhiXPef5rFar0uM9PkM/95jmsra9Y6mg5nRUh6Saw6AyzyI0jG6kLcdxL9ICNmyZFrThmK+f8eprph1WcVdYSDH7q0sfp+1T2fBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4PLw9XDCcwgFPyir5sJOdANxLQ2rNFf0bgfB6Ux/cc=;
 b=A1xYcI2veBHndQgiFFdKVJlWt4wdWjGJcewOlgFvp/LpqImRxwrybWrK45ozhgSb9RqWQDNjH9US3E47JawGH4t3tiudwmKwtKVqaKGileKMuPhok30cwJFUdM3Qhvj7ua0NkHMnHOlN32BOVWX6RNq6PzTYCAfXiS7RClTS7bqJBQ4G9tBendzWs8ad1U7V6revD6LcW287VbDIC8r2r5eEEgZHNP0w+NtT2ojjWgFsZnt0M9IhoDu3HkoiQvLgxqb+6GzGI5LmAeNnLkapy1lytInG+bvagUMq1y9POuAwWNIEBXXh+P0vyehI9t8tkdDIw3eENhENNmlCWwM/nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4PLw9XDCcwgFPyir5sJOdANxLQ2rNFf0bgfB6Ux/cc=;
 b=BHUhVWmj0JmapPXslgPNAMkOQnQMji2lonh9aLgSumYbCJzd4nCiUqMMST0bLeL0dQ8IlTkQJQKbdbzKCAamTUyXZfLCfLpjjcGrT2cUtOAaufLV1pCDlxf8yQCbSjKuZbSJUKdvVSIDEcJvGxDw3Cw3rM2LztGP/5AB0MM+GuY=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PA4PR03MB6959.eurprd03.prod.outlook.com (2603:10a6:102:f0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Thu, 14 Apr
 2022 01:40:56 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5144.030; Thu, 14 Apr 2022
 01:40:56 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Topic: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Index: AQHYTnGJ5PP7ok0nLUG60UBEzGR+wazuLAKAgAADHgCAAHVagA==
Date:   Thu, 14 Apr 2022 01:40:55 +0000
Message-ID: <20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk>
References: <20220411210406.21404-1-luizluca@gmail.com>
 <YlTFRqY3pq84Fw1i@lunn.ch>
 <CAJq09z7CDbaFdjkmqiZsPM1He4o+szMEJANDiaZTCo_oi+ZCSQ@mail.gmail.com>
 <YlVz2gqXbgtFZUhA@lunn.ch> <20220412133055.vmzz2copvu2qzzin@bang-olufsen.dk>
 <CAJq09z4E-HiA3WD4UtBAYm6mOCehHGedmofCqxRsAwUqND+=uQ@mail.gmail.com>
 <YlcZNlrvBXA+6tGk@lunn.ch>
In-Reply-To: <YlcZNlrvBXA+6tGk@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 961b87ae-1577-4127-0b25-08da1db7d1c8
x-ms-traffictypediagnostic: PA4PR03MB6959:EE_
x-microsoft-antispam-prvs: <PA4PR03MB69599F2CB09942CFE3A63E1183EF9@PA4PR03MB6959.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wv84EfjQ9pnTDBjawYuZzNcU+58FKlkpSDVGCntsAkMlxZbn8T4Nd8fqXdnGPifzyIr6zbUC6M0G/PQadIIaVONVqCPx3l+cwg2R1pQo7tE/ElL+5cu1NGpD4lKUmoh+0+9IaSkDSVbvuUvx/IepwP3L8KyrzXL5scnfntZ90TmZa3fneE3SpSMqJY1grnPnlzjvKEikb45jbB8L4ULatDVgy8WzLe6vao/XFajUqbYbyQfEgNFbRRq9QutbldKaJ9by20T6G6QuQpU3TuluIm6FVsvCgDjOECHUpZk7ZRTQN7qq7nqrDA69Yu37MojNs7sT8qkpjb8eW6kjQMU+JHsDeUiE0GFx10x+vf0hG9pnbL+QmxngwsOXVd/wl9QqtZe0J3ClEaSbsjOgdw08+UvpEYDbOJ8bMrFKfVQqQiHhOsC/SIIb2aIejzH1IkJRY2OWZY8nS1VMocz9wgWFpr2cA9RlPlI5wc2lgc7NIlZo0SE7CzC+8JIjJZo8t+OaIAlPNCipm0X4R+A/B5lwpuArB4iFBKZLBRaH2AiHzRsIOJRYJAu0MmDkBUziDo0V7gpp7laiDFDvGJ9kvOfcjjLPJKaRYL6ef1ddabHNHxIsLvQDknnorLIO6EYoVGQv/f7cr+/M8jglzdgL6RZ1P4wVQsoO8TjmNMVuYReYMOUzWqitfYm9NRa5Ip7DgW/nkbs2fgLMSNWGlZSY3FXuCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(316002)(54906003)(6506007)(1076003)(85202003)(36756003)(2906002)(508600001)(186003)(26005)(122000001)(38100700002)(6916009)(83380400001)(38070700005)(2616005)(85182001)(8976002)(8936002)(66476007)(64756008)(66446008)(66556008)(4326008)(8676002)(7416002)(76116006)(5660300002)(66946007)(86362001)(91956017)(6486002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cE8wRmZGWXFjUXNTVWN2Y29xUDFRSmJTUzBYTW8rTG5BWW5ZYitvTEVBL1RR?=
 =?utf-8?B?S3dnOVNsODhzSWM1eXluSzIzZkk3d0RLbVhCVWJCOExKbHNCSnhwaUFNeGl5?=
 =?utf-8?B?dk5DOW9zWDNjdFFDeXhNRDdiSDE1ak9BNUllenFrdGRNWm1QS3hnenlPU0Ny?=
 =?utf-8?B?c2NPZ2lUazIzaWlXZjRCeDZlN2Z1bFRySEpVK0EvbHhSS0dST3BKZzZNTnpz?=
 =?utf-8?B?SzFqcG5GcnJySTZ2QVArK1hyaTdPNmsxTXBBQ3Jibi9nYkFKVjZqNHJNL0sy?=
 =?utf-8?B?a1g0VDNBZmY5cFVEcGxhT0poTnlabEJESzE2SU1XKzJxSlU0WkNqcFh2L05P?=
 =?utf-8?B?bTk1NEVLRU5KTnFZNHc3V0lUL2UrdlMrK3FSRXlEWFRVUlVuMGNjZ1JjbGdN?=
 =?utf-8?B?b2ZBVnJrK20xdHlVd2VKdXRWOFdnNERpQlNQU1N0YU1DaUZ3MDJrU3phanAw?=
 =?utf-8?B?Ty9rTGtTdFVDZkVFelhOUDVIQ1FrSDRnYkkzanRxellsYmFrelNCRXc1bmtn?=
 =?utf-8?B?ODNybEY5K09xcVRjV1dpb092WWtoOUNlT2ppTDZMVmpXVDZvM0U0LzRqSFA1?=
 =?utf-8?B?eko5elY0Ynp2cGt1bGwzbXl5ZnlSYlR5MXZaOElRNzdtSGs1UmJWcUowL3dE?=
 =?utf-8?B?VnFacFBlc0ttd29TeUVhNGMzSVJUbXpaSldXSCtPbXVoS0FpT3ZnTVc3QlNE?=
 =?utf-8?B?dk01blMxWGRsS2ZEU1VqZ2NSd25FRHU2K0Iwc0hMenVkaVR2UkwzWTJzQmNQ?=
 =?utf-8?B?T1l3V1FaYm83UDFZQ1Z5bHJjRzFSNWdReGlrdWhycSt5T1BLUStnMFhOK2F0?=
 =?utf-8?B?aVJqN2llOGI2YTBJc0V4VGU4V1lFVXRkMmZuVzhTMmVOeUJGa2tCOE1HdWla?=
 =?utf-8?B?blQrb1BIODk1RzZWcFk1QTVuWGkxaC90K2RJTlZkSnQ0a0w2MzRxZEVtcWNI?=
 =?utf-8?B?NGQrSXRwM1JDU0lxanhaVmdxTndFTFdrQUFYTmtsZmlZWmdlbUtGOURleEpt?=
 =?utf-8?B?QzgyWTU0OGdLRGd3bWdRUU82RGl4Ty9JVzVFa0U1ZUt5V0pZaURodnM3K3Zs?=
 =?utf-8?B?ZWIxYUJXTjR4MUc0akllZWtrRWNwMmlKbGwxZkpHWjl5ckpvU2EzL0tNd09D?=
 =?utf-8?B?SHJRNGZtc3RUV2ZSU2RReml5SWhiRDdrR1plalcvcnNGV09ZeEoxay9Ba2FJ?=
 =?utf-8?B?c1U2c25LQWhBYTBlR1VhUDFrTVNDWFVzSUZnMjk1elR1b1NjaERhZDhsZ1hn?=
 =?utf-8?B?ZitIL3BJdktlZ1BGUnRQcjdQcTQ0OWtSd1JJMG1KT3RxaWNVb0lSSmZEZDc4?=
 =?utf-8?B?YUdqVXJOcUVVQ0xCWFc2d0wxTE5JaHRqNlBnMkVjZWcyMXpWK0lwaUVUcE0r?=
 =?utf-8?B?N0hVVUVudE1IQmpza3hNL1grZ2JYeGt6eVVpVEZFZHR0NCtzMkxqai9mY1M2?=
 =?utf-8?B?TWhQNWhHQ2Z6a2RQaDVIQWZnOFdnaFIwK2JRNDdvREZNeFdJMWh5a0FieFRa?=
 =?utf-8?B?bXY3TFVOL1FoNzZCeUhYMU9sbjIyQkUzeldnSnkvOVloaTlVeklnazBYSS9H?=
 =?utf-8?B?bHVzUzJLK1JDM2FMcHNjdEtSczIvTElBaEsvMDNlbVJ5THhjb29XUURGc1Bz?=
 =?utf-8?B?RllJNmhJWkdSWnpOVllhMVY5UU15Y3FhNlVqOWtrM3ZkUjg4WFRMQU9VMjJo?=
 =?utf-8?B?OERDYVJNVzNRVWFmSHNUeGFaMXY3K28yRkp5ZHFnSVZ0UHZ2Q0FSUnhvZ3Y5?=
 =?utf-8?B?UWQwcDhyblBuQUZwbm9FbWhxMERjQ2tUOTVvV3NNM3BxOVluRnFlUjM5UGVO?=
 =?utf-8?B?SUk3dlZ2UmdUdlJVTUsxL1Z0MTBCNjIvVDEvUlRKWGVLWFdySFoxdk9GQy9T?=
 =?utf-8?B?OUFJQkc2QUZ1V21MN1R4V2h1OGRTOFluOWdQQ3FzMEl3OHZoQXNuMmYzZWJT?=
 =?utf-8?B?cmdoQnB0bCs2Y2VneUNDY2JyeitzVmpEVUlScjRZenVUZmJ0UFVLUGVJbW1H?=
 =?utf-8?B?ZDZmZ24vNy9LZDFtVHBKbldqYXhkUnhySDVQMXlrV2JFbkxKcHRKQklOejM1?=
 =?utf-8?B?NThNdkJNdlJ4dHN4ZXlIYlhZczZvbk9jOHIxTnZyOVBpaENXK1QxSHBpK1BQ?=
 =?utf-8?B?TllrYnBNMEprbThsTE9FNWRRVzJFQkwzSWdLbld0ckk4RnB5YkpNWHBpVGJn?=
 =?utf-8?B?L21sT0Qrb2J1eXEyQVJVMXhHZWYyeWN1MU1sNTFDZFZZTmxwOGhNNCtxSGJk?=
 =?utf-8?B?RUsySSs3T3FlYTdFUFZ4MGtqTGFKZ3hEODRGc2tGeEw5Mm4vR0JQTXFPUGZq?=
 =?utf-8?B?Mm1DU2Fmb1hIRDJtaEg4SWhEREtGVk1YeHBCMFhxU1Q1ZTBYSnlBVUtMRUdJ?=
 =?utf-8?Q?9fhYFn/mJdn3jzao=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A2F9BBC8D76E941B97C80A4B540D501@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961b87ae-1577-4127-0b25-08da1db7d1c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 01:40:56.0709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hu6hlmuCsY9+gUwHgM8FcBcPzw800xjHlYZ0h0davstEdc4JXeht73RKAW4rMvJQnZAOdT/r06oC1Bsy8wcpUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB6959
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBBcHIgMTMsIDIwMjIgYXQgMDg6NDA6NTRQTSArMDIwMCwgQW5kcmV3IEx1bm4gd3Jv
dGU6DQo+ID4gSXQgZmVlbHMgc3RyYW5nZSB0byBmb3JjZSB0aGUgdXNlciB0byB1c2UgInJlYWx0
ZWsscnRsODM2NW1iIiBvciBhbnkNCj4gPiBvdGhlciBkaWZmZXJlbnQgc3RyaW5nIHRoYXQgZG9l
cyBub3QgbWF0Y2ggdGhlIGNoaXAncyByZWFsIG5hbWUuIEkNCj4gPiB3b3VsZCBub3QgZXhwZWN0
IHRoZSBvbmUgd3JpdGluZyB0aGUgRFQgdG8ga25vdyB0aGF0IHJ0bDgzNjdzIHNoYXJlcw0KPiA+
IHRoZSBzYW1lIGZhbWlseSB3aXRoIHJ0bDgzNjVtYiBhbmQgcnRsODM2NW1iIGRyaXZlciBkb2Vz
IHN1cHBvcnQNCj4gPiBydGw4MzY3cy4gQmVmb3JlIHdyaXRpbmcgdGhlIHJ0bDgzNjdzIGRyaXZl
ciwgSSBhbHNvIGRpZG4ndCBrbm93IHRoZQ0KPiA+IHJlbGF0aW9uIGJldHdlZW4gdGhvc2UgY2hp
cHMuIFRoZSBjb21tb24gd2FzIG9ubHkgdG8gcmVsYXRlIHJ0bDgzNjdzDQo+ID4gKG9yIGFueSBv
dGhlciBjaGlwIG1vZGVsKSB3aXRoIHRoZSB2ZW5kb3IgZHJpdmVyIHJ0bDgzNjdjLiBBcyB3ZSBk
b24ndA0KPiA+IGhhdmUgYSBnZW5lcmljIGZhbWlseSBzdHJpbmcsIEkgdGhpbmsgaXQgaXMgYmV0
dGVyIHRvIGFkZCBldmVyeSBtb2RlbA0KPiA+IHZhcmlhbnQuDQo+IA0KPiBJIHdpbGwganVzdCBx
dW90ZSB0aGUgTWFydmVsbCBtdjg4ZTZ4eHggYmluZGluZzoNCj4gDQo+IFRoZSBjb21wYXRpYmls
aXR5IHN0cmluZyBpcyB1c2VkIG9ubHkgdG8gZmluZCBhbiBpZGVudGlmaWNhdGlvbiByZWdpc3Rl
ciwNCj4gd2hpY2ggaXMgYXQgYSBkaWZmZXJlbnQgTURJTyBiYXNlIGFkZHJlc3MgaW4gZGlmZmVy
ZW50IHN3aXRjaCBmYW1pbGllcy4NCj4gLSAibWFydmVsbCxtdjg4ZTYwODUiICAgOiBTd2l0Y2gg
aGFzIGJhc2UgYWRkcmVzcyAweDEwLiBVc2Ugd2l0aCBtb2RlbHM6DQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgNjA4NSwgNjA5NSwgNjA5NywgNjEyMywgNjEzMSwgNjE0MSwgNjE2MSwgNjE2
NSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICA2MTcxLCA2MTcyLCA2MTc1LCA2MTc2LCA2
MTg1LCA2MjQwLCA2MzIwLCA2MzIxLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgIDYzNDEs
IDYzNTAsIDYzNTEsIDYzNTINCj4gLSAibWFydmVsbCxtdjg4ZTYxOTAiICAgOiBTd2l0Y2ggaGFz
IGJhc2UgYWRkcmVzcyAweDAwLiBVc2Ugd2l0aCBtb2RlbHM6DQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgNjE5MCwgNjE5MFgsIDYxOTEsIDYyOTAsIDYzOTAsIDYzOTBYDQo+IC0gIm1hcnZl
bGwsbXY4OGU2MjUwIiAgIDogU3dpdGNoIGhhcyBiYXNlIGFkZHJlc3MgMHgwOCBvciAweDE4LiBV
c2Ugd2l0aCBtb2RlbDoNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICA2MjIwLCA2MjUwDQo+
IA0KPiBUaGlzIGhhcyB3b3JrZWQgd2VsbCBmb3IgdGhhdCBkcml2ZXIuDQoNClJpZ2h0LCBzbyB0
aGVyZSdzIG5vIHJlYWwgcmVhc29uIHRvIGFkZCBtb3JlIGNvbXBhdGlibGUgc3RyaW5ncyBhcyBs
b25nIGFzIHRoZQ0KRFQgYmluZGluZ3MgYXJlIGNsZWFyIGFib3V0IGl0LiBMdWl6LCBpZiB5b3Ug
dGhpbmsgdGhlIERUIGJpbmRpbmdzIGFyZSBzb21laG93DQp1bmNsZWFyLCBmZWVsIGZyZWUgdG8g
dXBkYXRlIHRoZW0uIEJ1dCBJIHRoaW5rIHdlIGFyZSBwcm9iYWJseSBiZXR0ZXIgb2ZmIG5vdA0K
YWRkaW5nIGFueSBtb3JlIGNvbXBhdGlibGUgc3RyaW5ncyB1bmxlc3MgdGhlcmUgaXMgYSByZWFs
IHRlY2huaWNhbCBuZWVkIGZvciBpdC4NCg0KSW4gdGhlIHNhbWUgd2F5LCBJIGd1ZXNzIHRoZSBy
ZWNlbnRseSBhZGRlZCBjb21wYXRpYmxlIHN0cmluZyAicmVhbHRlayxydGw4MzY3cyINCndhcyBh
Y3R1YWxseSB1bm5lY2Vzc2FyeS4NCg0KS2luZCByZWdhcmRzLA0KQWx2aW4=
