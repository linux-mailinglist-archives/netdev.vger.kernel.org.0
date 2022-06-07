Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B06054010C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiFGOR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244279AbiFGORy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:17:54 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80127.outbound.protection.outlook.com [40.107.8.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1043328;
        Tue,  7 Jun 2022 07:17:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efrs4apccY94e3CaIRSTV92Y/yVqM6j28rxYFIikbF+3lewkM2aYPuL4HXx4einqv1fFkZzRNM+t6PyAuuDdUU5EReOE9z6+M0nKelKekb/Pw4PUyuT99rz4N0vcqmZ2+27GFJoBTLBFVhScLObur5A9k8KORwDK+osFACZejF8vrlpAMq+ipNFWx+qJAr2A15+HI1MeMyciEkizNm2DuNEIfmvUmHzgYn27pkTWT6iqb75z02scmfQLG/KNxyR9WtdttpvzvCuCPxhZfOyffyvd7vSJvdTggRRh6WBHa72AFrreAV4LupaeuAtADdPX/XC4Nsz6SMTp4B7A3Fh5SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/LYFZM3awcSZzULUp99ojipYFmagLAibyVeUZf8iWk=;
 b=AzBHgR5DeXzjdpbgSHExH+O6yPdVKsPqepZ6JuomnFEGAIZlFXYUBwCiuKr2Mo5/KRMhIJuWmIY9WTA6MUOr8f9LJGMlj/KxjZvbImxxVMPerEC8drmxgtfryo6hgBZSXSq5L131A6IxHXVnR7dmbq7fe8Q9b9tf+pEmKaZtMG9Q1WyxLz8oUB8R4HlLBvGBJ0hQFdImaKoCllOM/xJy5uNET8yW3/9A729a5TaHRbrVHIUJ3N9bM1w8/e/6px+J6vqiimxWRVJpztWloNDYNCaeSvyeViC8KGADQSByprh6bwcCW7YsPnKlglyqQsgImIE4MX7LLplHe4sTNuwqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/LYFZM3awcSZzULUp99ojipYFmagLAibyVeUZf8iWk=;
 b=IGpHKp6mn8UF3y70RdUU5/wZB8tEawzXErpKfk6y15j8lfViISwbpdBIhaPopoqyuvYC2zZhbiZvvDX5Hfym7JNYjg1aiKxgyaRJ0WMh9SpGduwVbSwF49AtpGllqf1UaEYlhWa4Z4NO5EGosGg7DIXk9t/BN3xU75uY4ElWSes=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB6PR0301MB2486.eurprd03.prod.outlook.com (2603:10a6:4:5a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 14:17:44 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 14:17:44 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for ports
 with internal PHY
Thread-Topic: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for
 ports with internal PHY
Thread-Index: AQHYeaWWRGyRRdDb9EGDzfVT+zDwia1CYBkAgAAEbwCAAZPrAIAAA5gAgAADXwA=
Date:   Tue, 7 Jun 2022 14:17:44 +0000
Message-ID: <20220607141744.l2yhwnix6aoiwl54@bang-olufsen.dk>
References: <20220606130130.2894410-1-alvin@pqrs.dk>
 <Yp4BpJkZx4szsLfm@shell.armlinux.org.uk>
 <20220606134708.x2s6hbrvyz4tp5ii@bang-olufsen.dk>
 <CAJq09z6YLza5v7fzfH2FCDrS8v8cC=B5pKg0_GiqX=fEYaGoqQ@mail.gmail.com>
 <Yp9bNLRV/7kYweCS@shell.armlinux.org.uk>
In-Reply-To: <Yp9bNLRV/7kYweCS@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0307db4b-aa7a-4f0c-4dbc-08da48907dbf
x-ms-traffictypediagnostic: DB6PR0301MB2486:EE_
x-microsoft-antispam-prvs: <DB6PR0301MB24860B9396D0F17D03BE852683A59@DB6PR0301MB2486.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iHGekF6tg7+nZ6n4bGQEWkhxTg2YIP7akF85QuiKsGGfT5n1F59SynZvalSTwBgz2Ai+NioWYIGODKDnOlHZCkkgAw5pWuossR9OLt3Yh1iLKaoulxcEaNeFyEhsMQfZbqfSccoCzoWZ3ULDxQb8Gw9BoqAWzsg/6FwsF8/JWXxbKUxPPjRn24fYHcuBa9Onplk1JUxxj3XM8zg3an87FemTPKP1qJOmA0nL9XEIo8ZwDRUE50Zpz45SngNw0OiqjDOOZOq8A1VODYEJlHLSv+kvRF0NJIpRc8ouMmtvAPjmJixgL9OWh5t8x06dL88nnTXk3ZQmCiJXHQw0LGOpplYxy1JeNdTNAr2BV/tl8JFhgpt8VA9VT6seG/drxOFMmF2FjjRGNjs8+V3C8CQix7mupKmvgiS6Etf7y0hzrs271tqxqDbQd887X50EJhhdVfGOIHdkjhWPalyZR2UbLV/BgM2M/tWQ5OUiji6lm8+6ep/izR+pK7roWV/VE7McLUXh7FfCrDDsfqivhCbCEfM0b9nFoOFdMWJAFT7B9ENiDY4BD+caVJ+I/XQPXB94zMvA4RcpcT13DLYSLQCVN7PVcYyhUv7IRyiHQcAnjCRi6pzykZrXWLzjkCoG95SAXVaoSg3CnI2ojj4Ppam3N5QQv1xzOU4dmsHNoUeOCKhiLIc6DDlUdhR1VxdljsHiSWOgUduzUbeiw59wqWgbrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8936002)(8976002)(8676002)(2906002)(122000001)(5660300002)(36756003)(66946007)(38070700005)(91956017)(85182001)(85202003)(76116006)(66556008)(66446008)(64756008)(66476007)(7416002)(316002)(83380400001)(86362001)(38100700002)(508600001)(6486002)(54906003)(71200400001)(6512007)(6506007)(26005)(1076003)(6916009)(186003)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDNsRnhDTTUrcGh2VHdEbVNGaVVNWWR4bVF1eG5ORmYrSDl3bzl2bUw1bGpE?=
 =?utf-8?B?QkxkOGt0b0NEbW5nanFKdmZramZ3S1pRbEdYNHhzVmRITEVVcHljWk1mN0Ji?=
 =?utf-8?B?R3ljRUZCVzluWG9hVlU0ZHVsWERlVlJtZEZ4SG9MbXZ5eHkva0pnZnByVlhv?=
 =?utf-8?B?d1VXY3duRkZ5aWhieFp5K1UrMjNkQkhyY3JHK29CVDBpZC9IUFNhTkpiQk1u?=
 =?utf-8?B?VDE2ZnpoNkRQYm1VTDBadnEwQmJVS0U1Q0xtUW1WSVJacFIyMkJEbWM4clFy?=
 =?utf-8?B?T2lUeGEvVmU1c3RqRmJXSU5PUkZTTVpjWnEwTzJJczBTRVZnYlBRWHhSL3Bo?=
 =?utf-8?B?TmxKM0RyVlJ3SFl3OXpPSEpqNmpWam42T2Y3a2xRWGUyVE91QnhYSGtQYVZl?=
 =?utf-8?B?TDVVcklKWGw1dzFCaEkrS243V1oySzJRWVQ5SmJ1TC9CSlpVbGxPam9IRzJ4?=
 =?utf-8?B?dzhaMXlBTk9EVndBVmoxTTVHV0Y0UnhsdzJia1JoSG5oL1dDRHJaTWVwTnBw?=
 =?utf-8?B?K28rV3NxMDVyM3RqRkVlTXJRYkJIQTFFajNWQUg3ZzM0SkFZKzVjUUsybUlD?=
 =?utf-8?B?V3BaU0p4VDl4Qmk4ejdtQW1LWnhPU0ZRREEzTFFsemdnd1ZyUWQzaU8vNkRs?=
 =?utf-8?B?QjN3Tkl2UkpxZmFKLzMvWnp2Mnlsb2F4T2ttZFR2QXVybmZyVjUwRjZYalVC?=
 =?utf-8?B?dVZ4ZCtPVkNiN1pNMW9TalA2Si8xdXBBMEk5bzVkbVlNRitnLzhyVU43cEVB?=
 =?utf-8?B?azZCcVY5S2VzN0RoTE9yQTVBaE1WSVdjZW9ic2k3U3VmU28zL0VEbERRaHhK?=
 =?utf-8?B?UjBoQWJiZjFKZ0ZVOTFiTURYNU0zc0Q2a1dsbkQwbjZ4ZmwvbG5pbzdHclRE?=
 =?utf-8?B?ZjdUQkh6VjBxQWVPTStFOU9ZSDBGdjFKRWgvOW5ucnFuSjhvaWJlNU1WU2Q2?=
 =?utf-8?B?dy92SFk1Z3VkLzRTWnVQR3J0bElzcmdsV2tlZ2prckxxekRMNEpZTU00Slk5?=
 =?utf-8?B?SVFBSW9DdGJmNWpCTEpiZ015eVkyMnNONUpsL3doNjJSNG8vdUhrajE2T2xZ?=
 =?utf-8?B?ZE1qbTI3RlJHSWVaZmVuVk5tVGpreGMzYURVUmdFeXlpUnEyMnkydGFxNlBF?=
 =?utf-8?B?ZVdGeTc5TjgxNGhVeHBYU09vSk50S3RzMG1sdnpKWU1wQmZIbngzK084eWhU?=
 =?utf-8?B?VDJFc0xGVk9DK3AzZVlSS3lQWnlDek1CYjB1UkppaHZPenczMWxyekk1M3BE?=
 =?utf-8?B?S093b3prcHF4ZDdsaHJSOU5CZ1FqSjBkcWtDMEc4ZGJiZWRCN1hBd3czOVhL?=
 =?utf-8?B?K0FFRVhLa2RNUFNNZzlyMEJ3KzBIUTN6a2tkRlpXcEFFY1F2QVF1VkNvQ2FE?=
 =?utf-8?B?enJad3JLT3d1V28xbWVpdDFLUTZYK3I2bG9DMy9wMG4xUWZUTjR4U2ErcTQ4?=
 =?utf-8?B?aFpWTGd5aURzWkw2alpUV3g5d3JTWEVWeStJWi8xVW43dzUwTTFudFkzVXpE?=
 =?utf-8?B?NWV0RWJUMEFZRUtaZWtWM25NNVRUSFliUEs2UFcrL29GL1ZJRC9BUmFYRnF1?=
 =?utf-8?B?WkhlUHVSRWQ4cnYrd3dXbzdGcHJ5bmFCL09sSW9JME1ZZTdmb2gxbzZnRUdq?=
 =?utf-8?B?ZTJyYXorZlhDdVhiSWMyeE5oSW5RQTBxak5rYmdZRkFBTHFuNUFLOHBkejUz?=
 =?utf-8?B?emF1OVRCTG41Y0hsTUkvY2VOY3ZkMVNIRDd6cnV5RXlhTmhwNFB3VFFGT3pm?=
 =?utf-8?B?MFJTbVdsQTl0UkZmV2xTY2lvWGRtVUhadXdQKzk3VU4zSTZZVUpuQTc3VFEv?=
 =?utf-8?B?U0dVdEdoUnJOWmJ3cjdnNll5Y0d3alJETy96d2VRdVhOT1VINzA5Mm5kdy9w?=
 =?utf-8?B?NkhBeUtoTmRHN1dnU3IrQXlwQ2hvTWczZ2lsL2I5T01tRzIvZkRyRC94YzJl?=
 =?utf-8?B?amtRbDhyMEdPamFiN3JsUlhHcy9nTVRnTFJIMThzVGN4WFgrdzBkWjdFd3BZ?=
 =?utf-8?B?SGkwMWRPNytBcGdQaURjYkR4dDB1K1FEQ0V6ckxweG9DUksxaTNtWUp2ZTlo?=
 =?utf-8?B?dk5yVFNEWm1YZ2VLaEhOc0Y1NGJlbkJhQkhGZ2pxaStMcW5yckZ2TjF4cDZa?=
 =?utf-8?B?TXNFZDJZZ2l5RDlMZGRoSlRaVjFtSlRmdGVMZ0g5eitzanBJTjNBa3JHRkdP?=
 =?utf-8?B?VHBURENKYmJWc2RhT00yeHAzdVhkdUJibk9aRXVtY1JLM2lIWTNBSEZ1U0Qy?=
 =?utf-8?B?TG1IeTg5c0VlajI5ZGkvWFNyTWFxRjFvaWdQSFFxK1N4b21DWlhObm1rc21z?=
 =?utf-8?B?Z2MyeU1QMG5QaEsxTzgwTU00eWlPYWR2ejNNSW8zVCtxVXBqU2xEd0FnVWNN?=
 =?utf-8?Q?X2tX+pVf4bDFornY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9377E207C1A23408BDC60024BD1A4CF@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0307db4b-aa7a-4f0c-4dbc-08da48907dbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 14:17:44.8370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6QdT5cBtQKZJ4dT7FHC7kYo58fxRUGbKrIwtvtwtKO/FcLuha4bKv2i+/iw1jLOW9bcZQQYkL8kx2lxhAy/ndQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2486
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBKdW4gMDcsIDIwMjIgYXQgMDM6MDU6NDBQTSArMDEwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBPbiBUdWUsIEp1biAwNywgMjAyMiBhdCAxMDo1Mjo0OEFNIC0wMzAw
LCBMdWl6IEFuZ2VsbyBEYXJvcyBkZSBMdWNhIHdyb3RlOg0KPiA+ID4gPiA+IEx1aXosIFJ1c3Nl
bDoNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IENvbW1pdCBhNWRiYTBmMjA3ZTUgb3VnaHQgdG8gaGF2
ZSBoYWQgYSBGaXhlczogdGFnIEkgdGhpbmssIGJlY2F1c2UgaXQNCj4gPiA+ID4gPiBjbGFpbXMg
dG8gaGF2ZSBiZWVuIGZpeGluZyBhIHJlZ3Jlc3Npb24gaW4gdGhlIG5ldC1uZXh0IHRyZWUgLSBp
cyB0aGF0DQo+ID4gPiA+ID4gcmlnaHQ/IEkgc2VlbSB0byBoYXZlIG1pc3NlZCBib3RoIHJlZmVy
ZW5jZWQgY29tbWl0cyB3aGVuIHRoZXkgd2VyZQ0KPiA+ID4gPiA+IHBvc3RlZCBhbmQgbmV2ZXIg
aGl0IHRoaXMgaXNzdWUgcGVyc29uYWxseS4gSSBvbmx5IGZvdW5kIHRoaW5ncyBub3cNCj4gPiA+
ID4gPiBkdXJpbmcgc29tZSBvdGhlciByZWZhY3RvcmluZyBhbmQgdGhlIHRlc3QgZm9yIEdNSUkg
bG9va2VkIHdlaXJkIHRvIG1lDQo+ID4gPiA+ID4gc28gSSB3ZW50IGFuZCBpbnZlc3RpZ2F0ZWQu
DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBDb3VsZCB5b3UgcGxlYXNlIGhlbHAgbWUgaWRlbnRpZnkg
dGhhdCBGaXhlczogdGFnPyBKdXN0IGZvciBteSBvd24NCj4gPiA+ID4gPiB1bmRlcnN0YW5kaW5n
IG9mIHdoYXQgY2F1c2VkIHRoaXMgYWRkZWQgcmVxdWlyZW1lbnQgZm9yIEdNSUkgb24gcG9ydHMN
Cj4gPiA+ID4gPiB3aXRoIGludGVybmFsIFBIWS4NCj4gPiA+ID4NCj4gPiA+ID4gSSBoYXZlIGFi
c29sdXRlbHkgbm8gaWRlYS4gSSBkb24ndCB0aGluayBhbnkgInJlcXVpcmVtZW50IiBoYXMgZXZl
ciBiZWVuDQo+ID4gPiA+IGFkZGVkIC0gcGh5bGliIGhhcyBhbHdheXMgZGVmYXVsdGVkIHRvIEdN
SUksIHNvIGFzIHRoZSBkcml2ZXIgc3Rvb2Qgd2hlbg0KPiA+ID4gPiBpdCB3YXMgZmlyc3Qgc3Vi
bWl0dGVkIG9uIE9jdCAxOCAyMDIxLCBJIGRvbid0IHNlZSBob3cgaXQgY291bGQgaGF2ZQ0KPiA+
ID4gPiB3b3JrZWQsIHVubGVzcyB0aGUgRFQgaXQgd2FzIGJlaW5nIHRlc3RlZCB3aXRoIHNwZWNp
ZmllZCBhIHBoeS1tb2RlIG9mDQo+ID4gPiA+ICJpbnRlcm5hbCIuIEFzIHlvdSB3ZXJlIHRoZSBv
bmUgd2hvIHN1Ym1pdHRlZCBpdCwgeW91IHdvdWxkIGhhdmUgYQ0KPiA+ID4gPiBiZXR0ZXIgaWRl
YS4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlIG9ubHkgc3VnZ2VzdGlvbiBJIGhhdmUgaXMgdG8gYmlz
ZWN0IHRvIGZpbmQgb3V0IGV4YWN0bHkgd2hhdCBjYXVzZWQNCj4gPiA+ID4gdGhlIEdNSUkgdnMg
SU5URVJOQUwgaXNzdWUgdG8gY3JvcCB1cC4NCj4gPiA+DQo+ID4gPiBBbHJpZ2h0LCB0aGFua3Mg
Zm9yIHRoZSBxdWljayByZXNwb25zZS4gTWF5YmUgTHVpeiBoYXMgYSBiZXR0ZXIgaWRlYSwgb3Ro
ZXJ3aXNlDQo+ID4gPiBJIHdpbGwgdHJ5IGJpc2VjdGluZyBpZiBJIGZpbmQgdGhlIHRpbWUuDQo+
ID4gDQo+ID4gSSBkb24ndCBrbm93LiBJIGp1c3QgZ290IGhpdCBieSB0aGUgaXNzdWUgYWZ0ZXIg
YSByZWJhc2UgKHNvcnJ5LCBJDQo+ID4gZG9uJ3Qga25vdyBleGFjdGx5IGZyb20gd2hpY2ggY29t
bWl0IEkgd2FzIHJlYmFzaW5nKS4NCj4gPiBCdXQgSSBkaWQgdGVzdCB0aGUgbmV0ICghLW5leHQp
IGFuZCBsZWZ0IGEgd29ya2luZyBjb21taXQgbm90ZS4gWW91DQo+ID4gY2FuIGRpZmYgM2RkN2Q0
MGI0My4uYTVkYmEwZjIwLg0KPiA+IElmIEknbSB0byBndWVzcywgSSB3b3VsZCBibGFtZToNCj4g
PiANCj4gPiAyMWJkNjRiZDcxN2RlOiBuZXQ6IGRzYTogY29uc29saWRhdGUgcGh5bGluayBjcmVh
dGlvbg0KPiANCj4gV2h5IGRvIHlvdSBzdXNwZWN0IHRoYXQgY29tbWl0PyBJIGZhaWwgdG8gc2Vl
IGFueSBmdW5jdGlvbmFsIGNoYW5nZSBpbg0KPiB0aGF0IGNvbW1pdCB0aGF0IHdvdWxkIGNhdXNl
IHRoZSBwcm9ibGVtLg0KDQpBZ3JlZSwgc2VlbXMgbGlrZSB0aGUgcmVmZXJlbmNlZCBjb21taXQg
bWFrZXMgbm8gZnVuY3Rpb25hbCBjaGFuZ2UuDQoNCkJ1dCB0aGFua3MgZm9yIHRoZSByYW5nZSBv
ZiBjb21taXRzIEx1aXosIEkgZm91bmQgb25lIHRoYXQgbG9va3MgbGlrZSB0aGUNCmN1bHByaXQu
IEl0J3Mgc21hbGwgc28gSSB3aWxsIHJlcHJvZHVjZSB0aGUgd2hvbGUgdGhpbmcgYmVsb3cuIFdp
bGwgdGVzdCBsYXRlci4NCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS04PC0tLS0tLS0tLS0tLS0tLS0t
LS0NCg0KY29tbWl0IGExOGU2NTIxYTdkOTVkYWU4YzY1YjViMGVmNmJiZTYyNGZiZTgwOGMNCkF1
dGhvcjogUnVzc2VsbCBLaW5nIChPcmFjbGUpIDxybWsra2VybmVsQGFybWxpbnV4Lm9yZy51az4N
CkRhdGU6ICAgRnJpIE5vdiAxOSAxNjoyODowNiAyMDIxICswMDAwDQoNCiAgICBuZXQ6IHBoeWxp
bms6IGhhbmRsZSBOQSBpbnRlcmZhY2UgbW9kZSBpbiBwaHlsaW5rX2Z3bm9kZV9waHlfY29ubmVj
dCgpDQogICAgDQogICAgQ29tbWl0IDQ5MDRiNmVhMWY5ZGIgKCJuZXQ6IHBoeTogcGh5bGluazog
VXNlIFBIWSBkZXZpY2UgaW50ZXJmYWNlIGlmDQogICAgTi9BIikgaW50cm9kdWNlZCBoYW5kbGlu
ZyBmb3IgdGhlIHBoeSBpbnRlcmZhY2UgbW9kZSB3aGVyZSB0aGlzIGlzIG5vdA0KICAgIGtub3du
IGF0IHBoeWxpbmsgY3JlYXRpb24gdGltZS4gVGhpcyB3YXMgbmV2ZXIgYWRkZWQgdG8gdGhlIE9G
L2Z3bm9kZQ0KICAgIHBhdGhzLCBidXQgaXMgbmVjZXNzYXJ5IHdoZW4gdGhlIHBoeSBpcyBwcmVz
ZW50IGluIERULCBidXQgdGhlIHBoeS1tb2RlDQogICAgaXMgbm90IHNwZWNpZmllZC4NCiAgICAN
CiAgICBBZGQgdGhpcyBoYW5kbGluZy4NCiAgICANCiAgICBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxs
IEtpbmcgKE9yYWNsZSkgPHJtaytrZXJuZWxAYXJtbGludXgub3JnLnVrPg0KICAgIEFja2VkLWJ5
OiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCiAgICBTaWduZWQtb2Zm
LWJ5OiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9waHkvcGh5bGluay5jIGIvZHJpdmVycy9uZXQvcGh5L3BoeWxpbmsuYw0K
aW5kZXggMmQyMDFhNzk1Nzc1Li4zNjAzYzAyNDEwOWEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC9waHkvcGh5bGluay5jDQorKysgYi9kcml2ZXJzL25ldC9waHkvcGh5bGluay5jDQpAQCAtMTMy
NSw3ICsxMzI1LDggQEAgc3RhdGljIGludCBwaHlsaW5rX2JyaW5ndXBfcGh5KHN0cnVjdCBwaHls
aW5rICpwbCwgc3RydWN0IHBoeV9kZXZpY2UgKnBoeSwNCiAgICAgICAgbXV0ZXhfdW5sb2NrKCZw
aHktPmxvY2spOw0KIA0KICAgICAgICBwaHlsaW5rX2RiZyhwbCwNCi0gICAgICAgICAgICAgICAg
ICAgInBoeTogc2V0dGluZyBzdXBwb3J0ZWQgJSpwYiBhZHZlcnRpc2luZyAlKnBiXG4iLA0KKyAg
ICAgICAgICAgICAgICAgICAicGh5OiAlcyBzZXR0aW5nIHN1cHBvcnRlZCAlKnBiIGFkdmVydGlz
aW5nICUqcGJcbiIsDQorICAgICAgICAgICAgICAgICAgIHBoeV9tb2RlcyhpbnRlcmZhY2UpLA0K
ICAgICAgICAgICAgICAgICAgICBfX0VUSFRPT0xfTElOS19NT0RFX01BU0tfTkJJVFMsIHBsLT5z
dXBwb3J0ZWQsDQogICAgICAgICAgICAgICAgICAgIF9fRVRIVE9PTF9MSU5LX01PREVfTUFTS19O
QklUUywgcGh5LT5hZHZlcnRpc2luZyk7DQogDQpAQCAtMTQ0Myw2ICsxNDQ0LDEyIEBAIGludCBw
aHlsaW5rX2Z3bm9kZV9waHlfY29ubmVjdChzdHJ1Y3QgcGh5bGluayAqcGwsDQogICAgICAgIGlm
ICghcGh5X2RldikNCiAgICAgICAgICAgICAgICByZXR1cm4gLUVOT0RFVjsNCiANCisgICAgICAg
LyogVXNlIFBIWSBkZXZpY2UvZHJpdmVyIGludGVyZmFjZSAqLw0KKyAgICAgICBpZiAocGwtPmxp
bmtfaW50ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9OQSkgew0KKyAgICAgICAgICAgICAg
IHBsLT5saW5rX2ludGVyZmFjZSA9IHBoeV9kZXYtPmludGVyZmFjZTsNCisgICAgICAgICAgICAg
ICBwbC0+bGlua19jb25maWcuaW50ZXJmYWNlID0gcGwtPmxpbmtfaW50ZXJmYWNlOw0KKyAgICAg
ICB9DQorDQogICAgICAgIHJldCA9IHBoeV9hdHRhY2hfZGlyZWN0KHBsLT5uZXRkZXYsIHBoeV9k
ZXYsIGZsYWdzLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwbC0+bGlua19pbnRl
cmZhY2UpOw0KICAgICAgICBpZiAocmV0KSB7
