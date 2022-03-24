Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093944E5FDF
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 09:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345901AbiCXIER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 04:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238719AbiCXIEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 04:04:16 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130091.outbound.protection.outlook.com [40.107.13.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC88099EE4;
        Thu, 24 Mar 2022 01:02:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDs0zNSwXqDL8iEPXfIOvT2vnfA/7mO3jWWq5FXZwhUbznEwaZQ26qaK4UsrPTmyGryHON7LbN8RyXdK53j0FK59HgYoFcCbRymWSPQdvwZtLTbtyJ6xp3g3fYQdyjoCCd27LRm5Ywcf+1g5vmWAMt5de4ZiuM32bTOilPfkj7rIvgSn2pzMejVmOyVr9hDfoGhepYSI8828TieOqH99ApPkAiC+L06fJi2JRx/Nmrws8Fqsr78Y9vHITqqf/a2g6jvb38Bddi9XdcRYFDWreK9i3fy6gWNzkEmloHe4kxVr9FY7bkscwVvl9WYgaPw4H4EdaqRHHGkN/UbRY5KYaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEf7kiyWngoQG9T9AGYG+Hv23pmD/M11NEI0QpM0pdo=;
 b=R1jRlVOMBUVZg+b4F7Gm9ympx/Q12UcTGf3TdivbVzpmoVH5J0rPx+qMucemDYioF9kNowK4CsUWaAq0QodoWFIkam00Inm1DmLpHLlznRr1wJeIod8v6hDrDWVFxkcM+WXWG6FtdNPjFbnBYZ9EnIExFV7BEdyfFYYArCk4VNHhJ3RV7wM1fa61Xq/CEubqx6dqyEbLIRTU3Ql+2VecqnosZ5cfnDRSzLKHHBYwaG49wsRg/ES6+f9nN7Soyz0AL7pXM+yAqOYbns21STr5r1C5TDLYgaKXCqHBr0DP4KVK8iJSDPbbRr2esdeNlJqwed1DiOoTe9PjTJRRo794kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEf7kiyWngoQG9T9AGYG+Hv23pmD/M11NEI0QpM0pdo=;
 b=m/7IJ3Mk34xpcgEbJw4XekshU9KZU8hnkCBGsyVliupko3pBcgbqbfFp1oYij5tfGiYDgf1seLDQsuxQ3OkYuvipT1KvosZU/WSJEaBlNGQXTAB3SjL7dPa7j3Gsngcp5c+ZoOapqah4pZVeaHhx0XFFOyQJj7s5OTQ3yI8eZrw=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM9PR03MB8011.eurprd03.prod.outlook.com (2603:10a6:20b:43e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 08:02:41 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::3ce4:64bf:3ed:64c2]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::3ce4:64bf:3ed:64c2%6]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 08:02:41 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: realtek: make interface drivers depend
 on OF
Thread-Topic: [PATCH net-next] net: dsa: realtek: make interface drivers
 depend on OF
Thread-Index: AQHYPrNz45zCE6bCjEaBGmJXraNsLKzM7dWAgAAOeACAAB7GgIABEvgA
Date:   Thu, 24 Mar 2022 08:02:41 +0000
Message-ID: <20220324080402.wu2zsewgqn2wecel@bang-olufsen.dk>
References: <20220323124225.91763-1-alvin@pqrs.dk> <YjsZVblL11w8IuRH@lunn.ch>
 <20220323134944.4cn25vs6vaqcdeso@bang-olufsen.dk>
 <20220323083953.46cdccc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220323083953.46cdccc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87092250-4786-46be-dc2b-08da0d6cabbb
x-ms-traffictypediagnostic: AM9PR03MB8011:EE_
x-microsoft-antispam-prvs: <AM9PR03MB8011B4EA4635B669CE16DB4D83199@AM9PR03MB8011.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HACo2hcfg53HbtBA614i04olYocTmdc/KgkdLzfEsbsosSyl4vdv0Z881yE3r4nYAGsAAJ+SmFPDRzs5ILO5sBOcR17iC3tzsYWnh/0oXpvTPPIZD8sz4P9ZW16R0a6K8lyHHBpmLOV8EkOJfBaidapQiyzhefSVtlOKewjdHd4+jCzw5iC5fuTKQNKRV2W7gj4WJfi/l6Cn8D9l70/n1OBIzvAhUR/Sf670Fya9vJZFKQRm8a/LICdlwh1xwyc4cyKf7+nj/ei9m2BISMaKvq+ICIGB2lBrYfjiaPvtd8LVM8mMsAqaGiCDJcYYoIlSIVB9Ac0ECGU958HjcHR9UTiyXXeQMSPBR/00AvFPRAZx3Br/7yjq/VyUyejqi4ejaoYmVQd0Q5y0ih2IzkohCtVcEeE1AOZ1WVzvhoaqggoXKGNirU7Xr8qMDqVZoY53rWXC2ZCscnD4SAjFiSnGbIKnczLTY0pZUi/HN/5o4FX9/NQt76IWGM9w7HTmbLAAdVCzcmdaSUn0kEylnqDb8T2SsHScKv1PlrHEPdB00it/uqsL2onhW+ON2JvDoVhNJfkEd4Wxgh3sGUp6n8hxGbA8bqvo1zTB7yeQlqVwbT8MhgQwfMVappBus/RGraAWucFMcDRn/PPOpZiHEMX2nCJlVikO9VI3tecALAD4w39dGXJuVo16MysgWO/sQ0OQdwbsZi1UD3vkCkvTfE4vag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(122000001)(85202003)(1076003)(26005)(2906002)(38100700002)(6512007)(186003)(2616005)(71200400001)(86362001)(8976002)(8936002)(6486002)(508600001)(7416002)(38070700005)(54906003)(64756008)(66446008)(4326008)(66556008)(66476007)(5660300002)(8676002)(85182001)(66946007)(6916009)(316002)(76116006)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MU56VjlkVXl0ZE9LYUNQRXFLRVZiNWY2b3l3UzRTTlZmcVNRVXFXRjVDbFlt?=
 =?utf-8?B?ZFFJcHQrZ0s4MWJGMUZOV1Q3Zm9LWHpPRXRPV1dqTVkySmVseUFZMiszT1h3?=
 =?utf-8?B?UndsQWEyemJ5Uld4dk9kd2VSODR6VGVScXVWSkwwNEJyRktNampXT2loODdw?=
 =?utf-8?B?M3NRVkwzaVlTL0F4eGtBZVZlZEVlQllITEVNb0tPS2lDM2xBdmIrL0Q1VS8y?=
 =?utf-8?B?ZEx2clF3NEJrZXBwTVI4UE8wcGdWSm9OK2VVU2I5MHVSZlRlOXFnQVRyZUxo?=
 =?utf-8?B?eEFZeE0wWFRGSHdsL3lUMlVvejBINmN2cGQ5U2NJaW5nWjZtMlQrKzJKR2Ix?=
 =?utf-8?B?M052NUIzdEVsMzhEYUwvZU0zejBoNmJMT3ZWcm1HT1p3UzYrbC90aWUyeUs1?=
 =?utf-8?B?YTZLTVdaTVFPWDM5cnBvYmdLbDRBL2lZaEphNnIrcFVXb3FMM296K0xGYnVy?=
 =?utf-8?B?ZEJ2aXJpVjBDTTd2Zm1OMk1JRC9KR1dmMjBtbGlITFdhd3RFTzZ3VENXakhw?=
 =?utf-8?B?d3g1SmdRR1ZOOHF3RzZJVVFOc05yZ0FEM0Z0dUkyckVDODdzZlNXbmVQMUEz?=
 =?utf-8?B?bExjejhocmpyMkt2WVE5c3JRL3UzaVVtejc4L0ZIWnJ1Y2phR1pGd3dqQ1Na?=
 =?utf-8?B?LzFjWm9UUjRHK2ZUQTlpS0QyS2xsMGJ6V0orNml3bzYxTnNrZUcvV1FkWXBl?=
 =?utf-8?B?aGppZGhzSDRaRzVJR3Vva3U3MWl5cm1sazUrbjg2NDN5MnVoYjIwM2NGTVRB?=
 =?utf-8?B?TGZNWml1alFEaWZ3VVhCc1R5QVZaZmtRTWNEQ0JtZm42b3UwNVVsZmlMcjkv?=
 =?utf-8?B?Q21SU3hxOEJQZHhOdzZia1hBekxPNFl4QlJQLy9mMkJLa2M4TlV6eUNZbjhN?=
 =?utf-8?B?ZEo1blp3K2h4dGI5OHBWcEw2WTlHQ3BleGNKOWlBaFluNlJEeTZRQXBMSTQ4?=
 =?utf-8?B?WUxzVlRCQm1WdTJzNy9GZCtDL29sYWoydEszSURUY3BBUC9HSFE0MGNWbmQ2?=
 =?utf-8?B?V0xwQ05yay9KRDY3SzJKT2dJcUJZWHNzQXJNVTE2TUQ3Y0hJTFE4M2RKV1dX?=
 =?utf-8?B?a2svOURNUzN1NHhEdTg3RmIzaFFEaVhjNTcvR0lDcGVocEtlZ1BTSmRuMjVZ?=
 =?utf-8?B?d2dFRHVRNFNBOWJBT3VkMm12RS85NTBWZlJGMmI3NTFhMXBRSExBMXA2OTB3?=
 =?utf-8?B?Z2pJdHBDZlpRTFc3Rk5XaTV5cmd2Vk04Q2NkVUs4djFPTENjUzZ3bmRZZWdJ?=
 =?utf-8?B?NXI3Q0UvN2JLcGh0RkVwbG50UG03UHRkekFNeFBVZ1U0aXRXOVJuMFpFbnJa?=
 =?utf-8?B?WlBGTE5sWUErWkdQSVRBcjdWbG5YL2lXbmFBb1BqSXlIbUlzd1FRQXM3VUxh?=
 =?utf-8?B?VkxXczBkdi85UUNaQXlRYmtHS2hVUEJRNVlkOGg2SjBwTTNXRE1zR25PMUE0?=
 =?utf-8?B?czZwK0tKS0l1MmR3dlhRdU5TbHk0K0xRb3M0aUIxVGptaEdvU3Q2ajU3WmlJ?=
 =?utf-8?B?MFBiMjE0VFExcXZuMTFxTXhzbll1dVJzaDZvOFRXai81OENCNW0yeEZuWUVt?=
 =?utf-8?B?VFBxUDRIdFl5eEF2Y1R6NWFubndjcGNwdUpjaGVjd3pncDI2aHV5WVhBcE82?=
 =?utf-8?B?dzBDK0JKZmt2L3ltWGpieFBmcWhNbHFMQ2RRL3l5eHRQWWlzMzU1VVZaTEZ6?=
 =?utf-8?B?REk2a1oxV2NYOUZRWTNYdkgwMUJYL3FJY0pzayt3dEdoTm9xQzBFR2dyRERU?=
 =?utf-8?B?Ujg1WTZqeGIvSExwdHM1Yi9LZG5PV0xUUWo3UlVVYnZqOXlaK2FBYXhlczZn?=
 =?utf-8?B?SUJ3MXFISkQ1MkJzeWQ5L0pTeDNSNGpyY1c5SWIxa2s3cEZJZncvOFJYMzY1?=
 =?utf-8?B?VXdzc3IySmp2QzZUVXpVd203Ung2bllnWFVlZC8vMmJkNkpnQmxHY25KcUhi?=
 =?utf-8?B?cSs4a2g5U2V4OENKakhVSnNwa2FINlR5VjVnbnYyQ0owSkp1dXJLV05mL0Y0?=
 =?utf-8?B?akFnQjJKenBUMlMvVXJ3V0poU0JNU1RUVW5nWnJtcWJzVkNaY0dUWGZjclNj?=
 =?utf-8?B?Y3JOOG1jQytqMVBBVm55bi9tdU1wZU83UmNlOFQyajExbnVyVlMwczdvVTg4?=
 =?utf-8?B?MzNmZ2h0UllEQ011NnB2K1AxVllpZmMxd0NBQmlOdVFEWWhIL0tlUUhFTTlV?=
 =?utf-8?B?WnJDQmxTRTVFMXNKQUxUVDFobzg2M09QamNUU0ZhUTViaVhITXl4QkZKdVJG?=
 =?utf-8?B?WE1MdHZvbDI4RTMyekRicFVkazZOczRhTE4ySHZPMTRQa1BWMmd5VnZIRzFH?=
 =?utf-8?B?VXgvbnZGQ3kwa24zSG9VT1JkMVZ5cVlFclBMWEUzYnVtUkZFb0k3MHoycFM1?=
 =?utf-8?Q?HwcWp3sdy/tD/Uhk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FF66B55BC7C8D4F8E4165C1A77B3A0C@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87092250-4786-46be-dc2b-08da0d6cabbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 08:02:41.4097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5b3w+qIHuL7KzTOIub7wYDDc77QUd6hVQw1uaL+EMbw8ZaXBI+MyIEluOHd0XkA+1m8n+FT1geG6309e85v9dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB8011
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBNYXIgMjMsIDIwMjIgYXQgMDg6Mzk6NTNBTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+IE9uIFdlZCwgMjMgTWFyIDIwMjIgMTM6NDg6NTYgKzAwMDAgQWx2aW4g4pS8w6Fp
cHJhZ2Egd3JvdGU6DQo+ID4gVGhlIGRyaXZlciBoYXMgYmVlbiBzcGxpdCBpbiBuZXQtbmV4dCBh
bmQgZGV2aWF0ZXMgc2lnbmlmaWNhbnRseSBmcm9tDQo+ID4gd2hhdCBpcyBpbiBuZXQuIEkgY2Fu
IHNlbmQgYSBwYXRjaCB0byBuZXQgYXMgd2VsbCwgYnV0IHRoYXQgd2lsbCBub3QNCj4gPiBjb3Zl
ciBuZXQtbmV4dC4NCj4gPiANCj4gPiBWaWV3IGZyb20gbmV0Og0KPiA+IA0KPiA+ICAgICBkcml2
ZXJzL25ldC9kc2EvS2NvbmZpZzoNCj4gPiAgICAgLi4uDQo+ID4gICAgIGNvbmZpZyBORVRfRFNB
X1JFQUxURUtfU01JDQo+ID4gICAgIC4uLg0KPiA+IA0KPiA+IFZpZXcgZnJvbSBuZXQtbmV4dDoN
Cj4gPiANCj4gPiAgICAgZHJpdmVycy9uZXQvZHNhL0tjb25maWc6DQo+ID4gICAgIC4uLg0KPiA+
ICAgICBzb3VyY2UgImRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL0tjb25maWciDQo+ID4gICAgIC4u
Lg0KPiA+IA0KPiA+ICAgICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9LY29uZmlnOg0KPiA+ICAg
ICBtZW51Y29uZmlnIE5FVF9EU0FfUkVBTFRFSw0KPiA+ICAgICAgICAgLi4uDQo+ID4gICAgIGNv
bmZpZyBORVRfRFNBX1JFQUxURUtfTURJTw0KPiA+ICAgICAgICAgLi4uDQo+ID4gICAgIGNvbmZp
ZyBORVRfRFNBX1JFQUxURUtfU01JDQo+ID4gICAgICAgICAuLi4NCj4gPiANCj4gPiBJIGFtIG5v
dCB3ZWxsLXZlcnNlZCBpbiB0aGUgcHJvY2VkdXJlcyBoZXJlLCBidXQgc2luY2UgNS4xNyBoYXMg
bm93IGJlZW4NCj4gPiByZWxlYXNlZCwgaXNuJ3QgaXQgbW9yZSBpbXBvcnRhbnQgdG8gZml4IDUu
MTgsIHdoaWNoIHdpbGwgc29vbiBoYXZlIHRoZQ0KPiA+IG5ldC1uZXh0IGJyYW5jaCBtZXJnZWQg
aW4/IEhlbmNlIHRoZSBwYXRjaCBzaG91bGQgdGFyZ2V0IG5ldC1uZXh0Pw0KPiA+IA0KPiA+IEFz
IGZvciA1LjE3IGFuZCB0aGUgb2xkIChuZXQpIHN0cnVjdHVyZSwgSSBjYW4gc2VuZCBhIHNlcGFy
YXRlIHBhdGNoIHRvDQo+ID4gbmV0LiBEb2VzIHRoYXQgc291bmQgT0s/DQo+ID4gDQo+ID4gT25j
ZSB0aGF0IGlzIGNsYXJpZmllZCBJIGNhbiByZS1zZW5kIHdpdGggYSBGaXhlczogdGFnLg0KPiAN
Cj4gSnVzdCByZXBseSB3aXRoIGEgRml4ZXMgdGFnLCBJJ2xsIHNvcnQgaXQgb3V0LiBJJ20gYWJv
dXQgdG8gbWVyZ2UgDQo+IHRoZSB0cmVlcyBzbyBpdCdzIGEgbGl0dGxlIGJpdCBvZiBhIHNwZWNp
YWwgc2l0dWF0aW9uLg0KDQpUaGFua3MgSmFrdWIuDQoNClN0cmljdGx5IHNwZWFraW5nIHRoZSBG
aXhlczogaXMgdGhpczoNCg0KRml4ZXM6IGFhYzk0MDAxMDY3ZCAoIm5ldDogZHNhOiByZWFsdGVr
OiBhZGQgbmV3IG1kaW8gaW50ZXJmYWNlIGZvciBkcml2ZXJzIikNCg0KQnV0IHRoZSBwcm9ibGVt
IGV4aXN0ZWQgYmVmb3JlIHRoYXQsIGp1c3QgaW4gYSBmb3JtIHVuYXBwbGljYWJsZSB0bw0KbmV0
LW5leHQuIFNlZSBteSByZXBseSB0byBBbmRyZXcuLi4NCg0KS2luZCByZWdhcmRzLA0KQWx2aW4=
