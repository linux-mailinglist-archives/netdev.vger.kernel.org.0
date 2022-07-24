Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2ED057F228
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 02:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiGXAar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 20:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGXAap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 20:30:45 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2092.outbound.protection.outlook.com [40.107.22.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C96F60C7
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 17:30:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlAG3nB5pcFR83TCxe1pVDZB/TpMxl5cF9hg0m3M3vZHe+8Xh5aNWoRavH6rQ5IFA/gEhWhr8GS6E9an1WW0YfU3pJKu4mRpK4PLao+YaNFIqRZuyaS0bIFPBnROzm661loJBsH39aD+ahJ81GNIe/xtr1mQC/DFb0wNnU+wNFuXh8iDaZ0MSjmblgtmZQmZPnqEhjF0xXjsqwUi6WHHLk2y2Xfj8SknJJMHKjVkYY722GBs9hl3QwzWscmTZ411FgLcm6T3in8WgY6IgaXfKTwpZpsVRC0K+A33bkkLi8L3NrFIQZVOHA9QMB3DARiIxjmhdfj869CMEHNHrz3Hmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m4zZjKOBatkPPIBcUAqBB9Flh1W+LLmxNf3PKu/cc94=;
 b=WBKy5g+4rA2K2cSIMwbMxeumPvOQ9m4LXikc8HL5O1tW1koMbRSffr8asQj6iw5iiAX8tiSyN3HHcTQ4/BFGKyvugH+dxACbdngjx+bzqdOB/Q/SvyXMkV64jqa+97ENaL8HU8TDtT4cADO4/8HpWtE0OzPsGbwIBX8HbjdWOGDI/qQg/jnNfE+bMskxbplVPEa8lCfBBnJ+Kv/f7nKB3FxkdQ3YDf419Klxv7XQ43xtYmFiQqGt7arivMV8JMgTDD94o7ZyRBFlebL4FmL8rLfeYmYKOwbAr7t3uBDwdvFspcJDe1yBGxOyu5+wUzBpnCyYcxmmJzaMLLBTHVTYHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4zZjKOBatkPPIBcUAqBB9Flh1W+LLmxNf3PKu/cc94=;
 b=Upceb5qa5YD1q7ql4vpON1vrb+35f6/G0L//5/HbrOigituEt4nQ7Jybnm+Uq3R9Jh6XtIeWoEXQa9iYB0c+06WNq51/mE5m4zM40uFlOMZL/zOKV9sMY07AF7o048llbIkoaMndn78qkJJeR3mutndQ+J6xProk6jjo7KS78GE=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by PA4PR03MB6895.eurprd03.prod.outlook.com (2603:10a6:102:e7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21; Sun, 24 Jul
 2022 00:30:40 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::de7:d0ed:2d93:9f78]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::de7:d0ed:2d93:9f78%6]) with mapi id 15.20.5438.023; Sun, 24 Jul 2022
 00:30:40 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared ports
 have the properties they need
Thread-Topic: [PATCH net-next] net: dsa: validate that DT nodes of shared
 ports have the properties they need
Thread-Index: AQHYnrPhKO7bzaVYIECMXoqJxTcRT62Mq8uA
Date:   Sun, 24 Jul 2022 00:30:39 +0000
Message-ID: <20220724003039.462iuanyzcx7gsr4@bang-olufsen.dk>
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08e32ec6-5ccb-4eb3-723a-08da6d0bbc6e
x-ms-traffictypediagnostic: PA4PR03MB6895:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qttV2OVpGCJOLT7WplMqiN9E8AqI3EDvF0dEHzgFjCB43PBJzPJAvRF6AZbcknhSBI7PX7EQAdOfoij5UyQtUEjkEda5hd0S/mSSOpQeJOZG58tJVbefJsoxMSxTYjkHHB6Y6kMRUfb+RxR3563u1nVajHAk0XvCZA+nfOwO83neaIR5j+gyLBvvR8WmETxDzTZvrd78OKIK3SPkY9QECmZWTnCGCE2yzwPVnHM9iS5FigPkLat+GEPNIR+T9R956M4ETzaljtMvnIwSPWFlRY5oK3qbFsICzQd5XzBy3Z42Bz2KqgUUftrOjNqqtGhnk3jSYiv2d0aoB1F97s7BlQQ3dhhLf3gk5rOqn9NT94CQoQMsDjsrPZPrHJHkNilgoeTs8fNgxXREB3boWE9HNv7dB9lhvHrYqvZHC/P6DT983JjTSEqFa0PoEX/6p2JN52fkY060TI6bqewebS0egOnWjxoi7WiLmcahbkzfh4VU9G95JeRPxARTu2NSAvJySFWnmmYwpdmcji3AXo6YrA2sIis2MTqA1rYm5pHgm3+QACrmqF6w6CAVvte/ZpqFBZF/K8ltviV9Mtze1eQd8XWy/AwOBNvKURS47vhEfUTZw3P5vXqE5+3hW2E5iEYqX2ONLmfBe9MtylFF2Adgqdv17JQvN51cuo0+Fr4lnJBdDZb8DJlCpT4RpXB2YTrED9tyWAJU47FMc67SRHne9TJ806w6IwYqCB2pLBkps/Pa/LLNmgIrYDUtPtwk7ZvV3zadIpJp+ZBpkXjCAdnVIM2cZHQswFM4ewpBSVtTc7SiquXP4z7z7wnftKmfIaDs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(346002)(39850400004)(366004)(6916009)(54906003)(38100700002)(122000001)(36756003)(186003)(316002)(71200400001)(91956017)(4326008)(38070700005)(76116006)(85182001)(66446008)(66556008)(66946007)(66476007)(85202003)(64756008)(8676002)(86362001)(2616005)(6486002)(8936002)(8976002)(5660300002)(478600001)(1076003)(4744005)(2906002)(6506007)(6512007)(26005)(7416002)(7406005)(83380400001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U05QWVVFZWRLc1RzbHZNN0dhU0RMT0xBNENhdXFVeS9OT2NDZnQ5NWw1Vjl3?=
 =?utf-8?B?cmtlcHFURjd4dzYxam1KanMxcE10cTlQNzBqcFlpUy94aXFqc3prYjRidy9M?=
 =?utf-8?B?MmJNY0lXeGU0aHRXYWhmMVYwVGJQU2tYODVpNkFIalcwaW8rUlpSdUk1Mll6?=
 =?utf-8?B?dGxwc1k5eFFNbGRlQUNGVCtjWkJJQlM2UHI3Q2lZdSsxUHhoZ3IrZUp5bkkw?=
 =?utf-8?B?Ky92RHI2YlJMNlNNNHdDaDI0N21ySk1ZRStqR3VEL1d5K3hub3J2QzRZMTVl?=
 =?utf-8?B?WGl3ZWE2dWk5NTVHRjBmOGtGRmhvWGdwWkJPSTJ6WVE0YUlNNVR1WnhHV2dI?=
 =?utf-8?B?TTcwTHN1cGJCWm1RWEpjNmY4YjZKd2ZuQ0JCTjFMU3ZOeWxqQlJPbnRVM3NY?=
 =?utf-8?B?WmhlcUxscXBOV05lajZ6YkhQNmd2ZmZoTFJRMzRuRG5GU1dFT2ViQmtDbnVh?=
 =?utf-8?B?Z21UQXBFb1BXbFB3WXZkdzQyOTR2UkpiUVc3OVI2Nk15MHZBdDRvMzAxYlhV?=
 =?utf-8?B?SFNpd1FXQURoNmgwMDRDM0p3V0tiY0pXaFVIQXpwL2F5b1ZhQjloTmtZUlRH?=
 =?utf-8?B?dmU0VFY1N00rK1dZT3pHTmJtb2Q4d0wrblNONWMvZHJReXRZYkpoM3A4cU55?=
 =?utf-8?B?ZkJSaTFPeDFzaUg2Qjk1MnNaMHFLMm5EWHIxRHZVdnRhdE80cjIvSVdTZHNi?=
 =?utf-8?B?bzJzUEltK0ZjenY0NVVjSEgwRjFlUnhYQ29jL3dZWTRnRFQyNlp2cEowQ0JV?=
 =?utf-8?B?VEl1bzhxNE9nT2dBcXBCUStMMjhqQzN5azZPT1ByelAwZ1dha3BkcGJiY05a?=
 =?utf-8?B?eWgxQlFibzB5ZkRpQUNRSkZuaDNDTEp1ekVJZE1kU2FIcVh5MnFwREFEVTFG?=
 =?utf-8?B?N0VqMkVMQ3dYTDVEKzF4T0Q5RzRDc2lZM2t3V0ZnUUtOanNMbEpNVkdEWGps?=
 =?utf-8?B?TUI5TnpIWmo5c2xQR3dPeGQ5dDBFZS9ydDNSbElEUXFoVFhxUzFQMkpLRHV6?=
 =?utf-8?B?aEppcVkyUTBabk5EZlRVajBUdWM0YXNVZm1WT29IWTloYU5EcDhMVG5rZXYx?=
 =?utf-8?B?dk15SzV1OUpLOUJVY3JRdFJkNjNlaHlHNGZoK0I2M1ZFRDM1bTRGeEhSS0JR?=
 =?utf-8?B?RzFMQW15SEJ5VzkvY2tDR0V2eFdHdEI3S0Qvd24yc1RScDIrMmV5aUFkYnh1?=
 =?utf-8?B?YmtZcjRkaEhZMG9PZW9MbXlXRk1yU0NNQXJGUWVBc3pxaEhYQWdMa01PaTdX?=
 =?utf-8?B?OFFsdlNYdjEzUzhQRWtjS2NLcDhnQmg5TDhBQzliZUtyZUx0cGUweEExWHhB?=
 =?utf-8?B?OHFNenhncmJxRzdrb29QY2FLbUpUNWFna1R1Q1VGTThtZitoT2hFb0pTN3d3?=
 =?utf-8?B?T1B4aWx3Z1FnQS9GTVpFZGZ4OG5MOFJEZ1l6ajZkTUxzMEJnU1dOdVF3djdj?=
 =?utf-8?B?NG16MEZKam1rN1pjL1JBZGh5NVArN2lpU2thQWNVWmwwRkIxWjNZMUc3Vk5y?=
 =?utf-8?B?R3B3ZnNtNHZVZER1TlJkRCtWQnI4aWhpTkhMWldMTVY1SE80aFZBY09NSkJ3?=
 =?utf-8?B?N25PMG9QVzdweDJnTUNyNmRZdGd3WnNxZlhtZGV0YjI4Vk1vU1IralJwUk9H?=
 =?utf-8?B?Vm9Ya2VrMjRGN29lN1k3RWxNcU9lbjVwQ0ZrQU82cmtueHpZSE9wQ1N3SmlP?=
 =?utf-8?B?aks2VzZyVS9hbXdJTERFWnFhYXdZQUIzWGVDMDc3bjVDTnZpSmdDWklMcVps?=
 =?utf-8?B?Q2FOelVWeSsxaXVvN2lTOGNUdkJaK2FPYko2akQ4YVhCQjZSYkMxK3E2S0x0?=
 =?utf-8?B?Yk9NamZoak96Szl1Mjg0OFZycGhrRXRkOUJvUHdUd3pGL1BTNDZjUkdWSHNP?=
 =?utf-8?B?a0lQM0EyR0hPaS9OQ0RlYVlrdUE4Uml6a0FEZFdJVXhSL3NUV0U0bENwUkdl?=
 =?utf-8?B?MGRpajBENnpmbk5XN2pweVhOZWpBZVJOR1IyNSs0aGlxVFZ2NlNwdWJ6ejZ0?=
 =?utf-8?B?R3dJdmJHdEZsbFdweXBGSnZmL3FPUkNDalpwbWc3NGtocTZrMXltVHhMSmFr?=
 =?utf-8?B?b0ZKdEY3RGFuQ0JvVnRIOVJwdEZhNGJHelVzUys5WGN1UDJOcDVudjNWRXV4?=
 =?utf-8?B?TGhqVXppS2hFdytZZzlKeHd4bE5mWkc0YzR3MzRwOWFwYkl0OFJ2Qjc0TjlX?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FAB6FCFEE284945BE9D4DD2186ED90E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e32ec6-5ccb-4eb3-723a-08da6d0bbc6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2022 00:30:39.9300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o0m0RQXr33bdkgU9lccJp+oLZYJTQzHDV7jMOpYDJqxZs2Z1rAy4/s2aMTZ/X1PPeuPzV46ngs5CQYkldpPMBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB6895
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCBKdWwgMjMsIDIwMjIgYXQgMDc6NDY6MzVQTSArMDMwMCwgVmxhZGltaXIgT2x0ZWFu
IHdyb3RlOg0KPiBSdXNzZWxsIEtpbmcgcG9pbnRzIG91dCB0aGF0IHRoZSBwaHlsaW5rX3BjcyBj
b252ZXJzaW9uIG9mIERTQSBkcml2ZXJzDQo+IGhlIGlzIHdvcmtpbmcgb24gaXMgbGlrZWx5IHRv
IGJyZWFrIGRyaXZlcnMsIGJlY2F1c2Ugb2YgdGhlIG1vdmVtZW50IG9mDQo+IGNvZGUgdGhhdCBk
aWRuJ3QgdXNlIHRvIGRlcGVuZCBvbiBwaHlsaW5rIHRvd2FyZHMgcGh5bGluayBjYWxsYmFja3Mu
DQoNCjxzbmlwPg0KDQo+IEluIHRoaXMgY2hhbmdlIHdlIGFkZCBjZW50cmFsIHZhbGlkYXRpb24g
aW4gRFNBIGZvciB0aGUgT0YgcHJvcGVydGllcw0KPiByZXF1aXJlZCBieSBwaHlsaW5rLCBpbiBh
biBhdHRlbXB0IHRvIHNhbml0aXplIHRoZSBlbnZpcm9ubWVudCBmb3INCj4gZnV0dXJlIGRyaXZl
ciB3cml0ZXJzLCBhbmQgYXMgbXVjaCBhcyBwb3NzaWJsZSBmb3IgZXhpc3RpbmcgZHJpdmVyDQo+
IG1haW50YWluZXJzLg0KDQo8c25pcD4NCg0KPiByZWFsdGVrDQo+IH5+fn5+fn4NCj4gDQo+ICAg
ICBjb21wYXRpYmxlIHN0cmluZ3M6DQo+ICAgICAtIHJlYWx0ZWsscnRsODM2NnJiDQo+ICAgICAt
IHJlYWx0ZWsscnRsODM2NW1iDQo+IA0KPiAgICAgMiBvY2N1cnJlbmNlcyBpbiBtYWlubGluZSwg
Ym90aCBkZXNjcmlwdGlvbnMgYXJlIGZpbmUsIGFkZGl0aW9uYWxseQ0KPiAgICAgcnRsODM2NW1i
LmMgaGFzIGEgY29tbWVudCAiVGhlIGRldmljZSB0cmVlIGZpcm13YXJlIHNob3VsZCBhbHNvDQo+
ICAgICBzcGVjaWZ5IHRoZSBsaW5rIHBhcnRuZXIgb2YgdGhlIGV4dGVuc2lvbiBwb3J0IC0gZWl0
aGVyIHZpYSBhDQo+ICAgICBmaXhlZC1saW5rIG9yIG90aGVyIHBoeS1oYW5kbGUuIg0KPiANCj4g
ICAgIFZlcmRpY3Q6IG9wdCBpbnRvIHZhbGlkYXRpb24uDQoNCkFja2VkLWJ5OiBBbHZpbiDFoGlw
cmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+
