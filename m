Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD926C7193
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjCWUKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWUKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:10:52 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2098.outbound.protection.outlook.com [40.107.21.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F51302AF;
        Thu, 23 Mar 2023 13:10:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iL0tKiKCFqRbRkaxCLZyron1iNWFnKzyfHbOSnBNaYU3dBhqDCxhdJNqOLdmBgZ2xe4fUONM9am9CsLIBAVVHNNI5rmD3r72PC4wiULkVg2hEY+XieY2LrjZPtPwai8cQBTJfGx5TyEGFs/V0rAxlm3IQfbqcUH9uOSQZKJmjg7LtURkYHhxXCc2cmpR7mf+iqlka0LbGdCdFsSJWCX2or78T0Ed43aHw6u10vimaQnjAuJl81xmda1vJAZeA2pTtXHXn5ML6SrSbK6pv/pmYDf8HM+DeX07rDaEDHvcbjVIyW9ra4nIP90kPdMQzPvA+d0szsOLv1GIm2RQ8a4gnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRvSokWAyW/MH1BWOVMLzBkVTtmMhBE7UZsxKuSpU1M=;
 b=fuy1LYkQjRGeXRBu6dTVUcl51M8j7jKHfIoK99r8zkD1L7W/qIidZ4FWjKjNYLdTWo1HRTd0C7yVWTx7t63qlalOOop8VbWfWCNguPnbOYf84h85JyM95iIYGvM3ieusGPwOyOlNLP47OCLqHqEkkUGaCVlbOwJZ1LjWL7wL2aVdMgOXgmsTtpzibeVXZsraAa6dw39XmHoy8A6tudw19D1QRGn/BKThcwnoioYqeONwla9QLTgOJmjtnGsaZZFq46u4btmZUb2Y9oCraqk+fcRe8+KkMoMfLY/vbvuTRkcIaT0GpvsxX4tNGYRwJqfii6NcEn7vwim3b0zKN3gxjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRvSokWAyW/MH1BWOVMLzBkVTtmMhBE7UZsxKuSpU1M=;
 b=Lw0X/7fGr2z6rvIYAKWvM1RFKmkqRNMzmZ3TlWe/kR5/QQvCgZPHZeNWik2MuSR96GMrTCFzOhh/7ey0iDGWzMvqbjPHjF255C9O+8RIZBlheSCy2pePElMslewjKEa6Y9oKchfGKDuzym8mYXHuGpwYY1vLBt9f7Xy5bx0WNyw=
Received: from AM0PR02MB5524.eurprd02.prod.outlook.com (2603:10a6:208:15a::12)
 by PR3PR02MB6346.eurprd02.prod.outlook.com (2603:10a6:102:7b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 20:10:47 +0000
Received: from AM0PR02MB5524.eurprd02.prod.outlook.com
 ([fe80::b0de:8e68:fc8:480e]) by AM0PR02MB5524.eurprd02.prod.outlook.com
 ([fe80::b0de:8e68:fc8:480e%5]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 20:10:47 +0000
From:   Paul Geurts <paul.geurts@prodrive-technologies.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>,
        "jonas.gorski@gmail.com" <jonas.gorski@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
Thread-Topic: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
Thread-Index: AQHZXYGKZkP5DojDLUOZ1w48EuKvyK8IkhcAgAA4scA=
Date:   Thu, 23 Mar 2023 20:10:47 +0000
Message-ID: <AM0PR02MB55242C94846EE5598CDA44A2BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230323121804.2249605-3-noltari@gmail.com>
 <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com>
In-Reply-To: <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prodrive-technologies.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR02MB5524:EE_|PR3PR02MB6346:EE_
x-ms-office365-filtering-correlation-id: ea4bb82e-08f7-4dce-d523-08db2bdab0e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cixSdQB+8I7aA/qQp40FCvoD+wZV8iWFo9zz+gFxWAp76rxYNiUkkQMaRvWBIEVmzzMHGpmVQyiJOGRIYVWUBDXzdd+R5rRXOwybTZKNQHYiceRJpJk+6JuJ3rDNABi9JCtTheEo8wsa74X3ChRYdGDxaIZtmVDW4rrpK99q6pYNBd3WelOi6Z/BNX0RdDjrjZIcCF1sPrSGSczXuPhaoyOikkTctGhy0pGGrVft1P9fvIUplhydHZh0tOitUTdJQv+x4Wg1eY5fr3LnFl8czJhqsZqS0K6ylnTvpvSKRgb+kIfcEVdzkbG6Yx8Iyr9DycKtxmTkMFvCP2454TB0OY0YkWXyKksAlupnRETZWy4JHJmUgvPAS4Fldt53YX1mZvfs0tr5qwYFKEdyGZcZb/usT6hzk7OFoqctyzD8BDgANTWkvF0ay4Qd/xV/r8dNCu8dcXseKdbFgFtIof+uSw62nH9eqU9RG1xYjQamq+E6VUeGa+d3uRF8dulEI1TItLomBF4vPDyBTCm5ZNCHD2xs/XnzRV5VEewy9XkhfGU/t8L3WjWNzEsmyC33tyLLM33WvHkl66ZOvrSxGUyC2K9irxmNPMExFiGlZlMVXWoZ5FPh39qeS6o3bzcd6KGZtgyv7lmdXH3/DOK9bWc6EJCtxQMuT5NcDOv2PAsUN9oj6TOZ+D9WLFDb5fIf5ofsEbbTcNIt9mcubK3tNrQvGVPLFKOlxCwVrUxVwBw7bDI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5524.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39850400004)(136003)(366004)(376002)(396003)(451199018)(26005)(316002)(83380400001)(53546011)(9686003)(186003)(86362001)(122000001)(38100700002)(38070700005)(921005)(55016003)(8936002)(64756008)(66476007)(66556008)(66446008)(52536014)(5660300002)(41300700001)(76116006)(8676002)(44832011)(66946007)(7416002)(2906002)(7696005)(6506007)(110136005)(33656002)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzB1dUNhUnlPMzN5YjBRajVDZWt5N1I3cEtNVTlvNmNqTWdnR2UycUQ3RWk4?=
 =?utf-8?B?S1BFYmt4eHZhSXBIMTdMaW1BMmNNQy9udjY5KzFObytEOFg4THc5cUtVazFl?=
 =?utf-8?B?eGlydlZmNzNRWlN4MTBmRjJraWwzblFocUZmQVVKVm1ObW5kMkxBVlZEV1NL?=
 =?utf-8?B?OTBBRDNZUm4xZ09xODFwUVRjRjZySDN2dnVyaXZZdXY0RktHalYyV1FQcExP?=
 =?utf-8?B?a295enp2VERLanZVUkVLT0QzMVNkd3lzMG5COS82TVhXTTRLVExjaUVDRXVC?=
 =?utf-8?B?MjhvUnRvREs0YmNmVUhXbHRqaUtFZzVWOHg3dFVhS0RWNjVEVklPNlBTUkZk?=
 =?utf-8?B?aU5CSGtOKzllSUNrRnA5bkVMS254ZThGS1V1eCtVN3NvU2lINWJvVkVxMXF2?=
 =?utf-8?B?bHdXOWNhMlBwRHBRVnpyU1ZVVHVYOG1neWYrSzNGQVNGd2lOMjY0RXlHTk5j?=
 =?utf-8?B?aHJ3ekZ6anVmRUdVWDRlOEtEVXNNc0ZacGFweFFoQ1VhQ3NsZEtjYUFLeENq?=
 =?utf-8?B?bVpDbmlHU2pscXROU0NIZnpJRGtPeU5wM2dzWUxEM2ZxOWo3VEtzV2YrNER2?=
 =?utf-8?B?OFFIelVGTEx3WTcwaENtaERoVlNuRnJSejhBc05vZjYyaFRRS1RiWWVHS0dJ?=
 =?utf-8?B?Y0Y1ZTVualFrRWhoZXUwSkQ1WjVmVHBPZlhkQWU5R2FqWlJLN2ZaaWxXZUR6?=
 =?utf-8?B?UWt2cVlRSVI0SklQVXRGSURYd2IxOTloa0RuY3hRamVOcTd0SDJMNW5obXE3?=
 =?utf-8?B?YVpHQWRSMWQ0cjFFVGVzdHZXbWRMSXJOMFhDZEpodHU1Rkl3RXVkQjVRems1?=
 =?utf-8?B?MkMyRmhBNUszNW9GR0dHeDI1QmhoMU9KZjFNUElnMlg2QkFZejhCeUlMZzcw?=
 =?utf-8?B?dlNXaUVFM3dvZ1dYS0pLQ29VVitUak1pUldMVFZCKy9nTzQ2TzZRYWhHNFpn?=
 =?utf-8?B?RjBSK2o4Y0NNcUZYR2NnTjR1QklvdFJJNXZ6SmJobFhycDZjOGFIZmh3OFhE?=
 =?utf-8?B?cjgzTytzc2RGN25PMnFoaEhiREZTNlYxbHNFamxGWDR2cVNFKzZVTUpoZFY4?=
 =?utf-8?B?a3pkelJhZW1qTzV5L2NUNUI1azZTMjJaY0wwQ2NaaHpmY3VEN21McVZXM1cv?=
 =?utf-8?B?MmVtOElnMmJobXBkNHY1RE1kbFcySDRKQ3pQOVZadTd3MFJQajdFZTUwQWEx?=
 =?utf-8?B?dWV3aWV4Y09DWWtCM1BjSjdYUjZPZFNYWTQvemZPMjYrYWpTNVU4ZkZCT1R2?=
 =?utf-8?B?d0pIS0ovdGkyajR0dmVqcjBrVHFuR0F1UXREaFNkM1NuNk8xcXdmekxZZWJ2?=
 =?utf-8?B?VktJdjR4dHdTTHJxNWVoUmRxbm1uT3Q4SlZnbWQrQ3NZUlpUakNDU3cvODJp?=
 =?utf-8?B?NUdqRTRnS0FQd2ZkLzVUcllUL1dLUlAxSStoQ3BMWHBqRUgzRm1iZ3ZsNWNI?=
 =?utf-8?B?VDQzQUFtS1h6bEx2OGUvY2FSWnpaWjJMcDM1NExtYUlVR1lPb0p1d1ZRZUdT?=
 =?utf-8?B?WlVpRURBQzlEMVRHTTFudFp4TFFZYXpZZm1uc0plQlh0NU1qc2VuTmYrUWVX?=
 =?utf-8?B?UWVjbnZac1llaU1NVnVKR0xGL1dhWVRJdFFOQ1k5N2dRRGlCVkFvTHFwa3E4?=
 =?utf-8?B?dzNVWEhFOHlCa3VZbzBqbnVzNld5NStZbXFsNkdHcjZMN0VzVWJyM0oxQ0o0?=
 =?utf-8?B?YzdzRHB0eThQRjhvSi9IMzhZdUp0SW1LcjZOdDZGNXoyekYzaEJvK0FTdFNT?=
 =?utf-8?B?OFVFWHZoMkVSekJ5VzRiblJNSnZzMFNDMzdCZWRJb3FsQVFDaHpWNmxnRzdF?=
 =?utf-8?B?TVRlN3gwNjBCWWV1Nnd1aE1Rd1gyK3RhTWUya0FpdzdBcFFXR0JmYjI4cndF?=
 =?utf-8?B?OXI1OWVZOWVyRThFYUwzUlRqTEhTR29Sdm5nV3B1ejhPUk13QTY5TW5EWGFm?=
 =?utf-8?B?Yy8ybDNGaWxyQWtaa3BsenBpazBPS251RnRMMVJrNnhGMFFQMWdLakY4blRV?=
 =?utf-8?B?WEU4VTlmTENiWkVYcEZ1RHFjUXRoN2Q2Z2dMN3pNSkI2R2tFN0FBeE5wUEhq?=
 =?utf-8?B?NFZuZzNqL2VHaUdLNVJ5YnM2SksrQ1NZUkRHallKUFVpMThUWmk0YnFOeFo3?=
 =?utf-8?B?bU04dkhiaEt0R3FLSnpXTjI1SXdnUmFPUkRHZWsyVlEzZC9vc29Td0VCcE83?=
 =?utf-8?Q?gVE+436NWfmawkwQQsCbjYU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5524.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4bb82e-08f7-4dce-d523-08db2bdab0e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 20:10:47.3567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v7gNdQJbbfcax4h+VwDzD4Qgp1i2C4eLTg79MDhaKfkXujEuq3RgVj5hBqFC+ACVfwcAG+Jt8pFjUieGTUU8RjrmC5p2TOJ678ml2KpSLaKBxotSX+LEFYi133kLkEyq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR02MB6346
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDogZG9uZGVyZGFnIDIzIG1hYXJ0IDIwMjMgMTc6
NDMNCj4gVG86IMOBbHZhcm8gRmVybsOhbmRleiBSb2phcyA8bm9sdGFyaUBnbWFpbC5jb20+OyBQ
YXVsIEdldXJ0cw0KPiA8cGF1bC5nZXVydHNAcHJvZHJpdmUtdGVjaG5vbG9naWVzLmNvbT47IGpv
bmFzLmdvcnNraUBnbWFpbC5jb207DQo+IGFuZHJld0BsdW5uLmNoOyBvbHRlYW52QGdtYWlsLmNv
bTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJu
ZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gcm9iaCtkdEBrZXJuZWwub3JnOyBrcnp5c3p0
b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRl
dmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDIvMl0gbmV0OiBkc2E6IGI1MzogbWRpbzogYWRkIHN1
cHBvcnQgZm9yIEJDTTUzMTM0DQo+IA0KPiBPbiAzLzIzLzIzIDA1OjE4LCDDgWx2YXJvIEZlcm7D
oW5kZXogUm9qYXMgd3JvdGU6DQo+ID4gRnJvbTogUGF1bCBHZXVydHMgPHBhdWwuZ2V1cnRzQHBy
b2RyaXZlLXRlY2hub2xvZ2llcy5jb20+DQo+ID4NCj4gPiBBZGQgc3VwcG9ydCBmb3IgdGhlIEJD
TTUzMTM0IEV0aGVybmV0IHN3aXRjaCBpbiB0aGUgZXhpc3RpbmcgYjUzIGRzYQ0KPiBkcml2ZXIu
DQo+ID4gQkNNNTMxMzQgaXMgdmVyeSBzaW1pbGFyIHRvIHRoZSBCQ001OFhYIHNlcmllcy4NCj4g
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IFBhdWwgR2V1cnRzIDxwYXVsLmdldXJ0c0Bwcm9kcml2ZS10
ZWNobm9sb2dpZXMuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IMOBbHZhcm8gRmVybsOhbmRleiBS
b2phcyA8bm9sdGFyaUBnbWFpbC5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL25ldC9kc2Ev
YjUzL2I1M19jb21tb24uYyB8IDUzDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKyst
DQo+ID4gICBkcml2ZXJzL25ldC9kc2EvYjUzL2I1M19tZGlvLmMgICB8ICA1ICsrLQ0KPiA+ICAg
ZHJpdmVycy9uZXQvZHNhL2I1My9iNTNfcHJpdi5oICAgfCAgOSArKysrKy0NCj4gPiAgIDMgZmls
ZXMgY2hhbmdlZCwgNjQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvYjUzL2I1M19jb21tb24uYw0KPiA+IGIvZHJpdmVy
cy9uZXQvZHNhL2I1My9iNTNfY29tbW9uLmMNCj4gPiBpbmRleCAxZjliMjUxYTU0NTIuLmFhYTA4
MTNlNmY1OSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvYjUzL2I1M19jb21tb24u
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9iNTMvYjUzX2NvbW1vbi5jDQo+ID4gQEAgLTEy
ODIsNiArMTI4Miw0MiBAQCBzdGF0aWMgdm9pZCBiNTNfYWRqdXN0X2xpbmsoc3RydWN0IGRzYV9z
d2l0Y2gNCj4gKmRzLCBpbnQgcG9ydCwNCj4gPiAgIAlpZiAoaXM2M3h4KGRldikgJiYgcG9ydCA+
PSBCNTNfNjNYWF9SR01JSTApDQo+ID4gICAJCWI1M19hZGp1c3RfNjN4eF9yZ21paShkcywgcG9y
dCwgcGh5ZGV2LT5pbnRlcmZhY2UpOw0KPiA+DQo+ID4gKwlpZiAoaXM1MzEzNChkZXYpICYmIHBo
eV9pbnRlcmZhY2VfaXNfcmdtaWkocGh5ZGV2KSkgew0KPiANCj4gV2h5IGlzIG5vdCB0aGlzIGlu
IHRoZSBzYW1lIGNvZGUgYmxvY2sgYXMgdGhlIG9uZSBmb3IgdGhlIGlzNTMxeDUoKSBkZXZpY2Ug
bGlrZQ0KPiB0aGlzOg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9iNTMvYjUz
X2NvbW1vbi5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL2I1My9iNTNfY29tbW9uLmMNCj4gaW5kZXgg
NTljZGZjNTFjZTA2Li4xYzY0YjZjZTdlNzggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2Rz
YS9iNTMvYjUzX2NvbW1vbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9iNTMvYjUzX2NvbW1v
bi5jDQo+IEBAIC0xMjM1LDcgKzEyMzUsNyBAQCBzdGF0aWMgdm9pZCBiNTNfYWRqdXN0X2xpbmso
c3RydWN0IGRzYV9zd2l0Y2ggKmRzLA0KPiBpbnQgcG9ydCwNCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHR4X3BhdXNlLCByeF9wYXVzZSk7DQo+ICAgICAgICAgIGI1M19mb3JjZV9s
aW5rKGRldiwgcG9ydCwgcGh5ZGV2LT5saW5rKTsNCj4gDQo+IC0gICAgICAgaWYgKGlzNTMxeDUo
ZGV2KSAmJiBwaHlfaW50ZXJmYWNlX2lzX3JnbWlpKHBoeWRldikpIHsNCj4gKyAgICAgICBpZiAo
KGlzNTMxeDUoZGV2KSB8fCBpczUzMTM0KGRldikpICYmDQo+IHBoeV9pbnRlcmZhY2VfaXNfcmdt
aWkocGh5ZGV2KSkgew0KPiAgICAgICAgICAgICAgICAgIGlmIChwb3J0ID09IGRldi0+aW1wX3Bv
cnQpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICBvZmYgPSBCNTNfUkdNSUlfQ1RSTF9JTVA7
DQo+ICAgICAgICAgICAgICAgICAgZWxzZQ0KPiANCj4gT3RoZXIgdGhhbiB0aGF0LCBMR1RNIQ0K
PiAtLQ0KPiBGbG9yaWFuDQoNCkkgdGhpbmsgdGhlIG9ubHkgcmVhc29uIGlzIHRoYXQgdGhlIEJD
TTUzMTM0IGRvZXMgbm90IHN1cHBvcnQgdGhlDQpSR01JSV9DVFJMX1RJTUlOR19TRUwgYml0LCB3
aGljaCBpcyBzZXQgaW4gdGhlIG9yaWdpbmFsIGJsb2NrLiBJIGFncmVlDQpQdXR0aW5nIGEgaWYg
c3RhdGVtZW50IGFyb3VuZA0KcmdtaWlfY3RybCB8PSBSR01JSV9DVFJMX1RJTUlOR19TRUw7DQp3
b3VsZCBwcmV2ZW50IGEgbG90IG9mIGNvZGUgZHVwbGljYXRpb24uIF9ob3dldmVyXywgYWZ0ZXIg
bG9va2luZyBhdCBpdCBhZ2FpbiwNCkkgZG9u4oCZdCB0aGluayB0aGUgZGV2aWNlIGRvZXMgbm90
IHN1cHBvcnQgdGhlIGJpdC4gV2hlbiBsb29raW5nIGF0IHRoZSBkYXRhc2hlZXQsDQpUaGUgc2Ft
ZSBiaXQgaW4gdGhlIHRoaXMgcmVnaXN0ZXIgaXMgY2FsbGVkIEJZUEFTU18yTlNfREVMLiBJdCdz
IHZlcnkgdW5jb21tb24NCkZvciBCcm9hZGNvbSB0byBtYWtlIHN1Y2ggYSBjaGFuZ2UgaW4gdGhl
IHJlZ2lzdGVyIGludGVyZmFjZSwgc28gbWF5YmUgdGhleQ0KSnVzdCByZW5hbWVkIGl0LiBEbyB5
b3UgdGhpbmsgdGhpcyBjb3VsZCBiZSB0aGUgc2FtZSBiaXQ/DQoNCi0tLQ0KUGF1bA0K
