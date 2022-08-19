Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA31599362
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 05:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346177AbiHSDNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 23:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245469AbiHSDN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 23:13:27 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20079.outbound.protection.outlook.com [40.107.2.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A96139BAC;
        Thu, 18 Aug 2022 20:13:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCiDsGZVs1LpGg+khxwscwdzyC5tJx6lqgic8HXjVwpqVA4HPSaUteXfi8KID97i3pi+RVtbizPp4uJlD+fVHKu55oG77SKQo1r1z6h3BfrVz8hoe3+OFPgfCQOpSAm5VI/hPGwEAYEfINuUONNRpYUpl07oYjljn37TM7n77lcgfvac2sLPvpK7YjYw7vRHMeG2wjYWvSVe7uzmocsgqn2TL82rfa7+rLr+rEYI0PbdrfcEkBqqLFN6RfKWpFlGoiKZj+QgVYDK5o/8mla97keYaMe8s/oCJgysAilRFXbrfMNmawF9Rk5+5tVPHYlI8bB7z2jt4HSspCb8eXoISA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WBQOD90erznvP9IlXvvax25PRlM+CxmYOki10d935/E=;
 b=I0t6H8tkK2rPRKBYfBXd1l+TIv/2sUhCq+sRiKNtqZUvdO7sEQz4OuzinfyfTKT2NShd0bwuV8FNRgwIExGJT9uDzEpImNPTK/NoheHMg+yFIwdlzHpqQHio1v/JSa2zzBwdGRN3oMjhNS+UkRillySxK3/PCL08bv8jFyK8VKStblLGKjc8RWdHM9vLnj+u0Fr8LKhbNUL9LYHYbbnzlIm5VapFuQq14NEhye67GlQMEJD02ewNoPXOdj1KJlsnHBmL/gFHemUORuhVjAvX7YR52h8rRsZHchPiL2Bi4hFHmAHvKZN2J+cd9XAsz0YfNkweyveojV4HrpS7DLAWmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBQOD90erznvP9IlXvvax25PRlM+CxmYOki10d935/E=;
 b=OAtrLegFW3GDX0rSGocRqcVUWeMzLDuEI5BlJmAV3N1Xk44E6wpimqMjQSRl8u8PhG/nFGZMNcsmlfflkb78NJMeweozh6IIMPSfCCfc43k8l2aiMn6YsRHcmhYpnV4Fbcmft55vjI3SAYknLULDAw+DJWYeMMoxX+uPSoj1vKg=
Received: from PA4PR04MB9416.eurprd04.prod.outlook.com (2603:10a6:102:2ab::21)
 by DB6PR0401MB2311.eurprd04.prod.outlook.com (2603:10a6:4:49::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 03:13:21 +0000
Received: from PA4PR04MB9416.eurprd04.prod.outlook.com
 ([fe80::6da9:774d:eb1d:9ad5]) by PA4PR04MB9416.eurprd04.prod.outlook.com
 ([fe80::6da9:774d:eb1d:9ad5%5]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 03:13:21 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
Subject: RE: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Thread-Topic: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Thread-Index: AQHYsqKWB05voik5OEuTGHWf5ln2Hq20SUAAgAAZr4CAAAaYgIAARhqAgAAB7ACAAMVhgIAAFaYg
Date:   Fri, 19 Aug 2022 03:13:21 +0000
Message-ID: <PA4PR04MB9416C0E26B13D4060C2F50A9886C9@PA4PR04MB9416.eurprd04.prod.outlook.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
 <20220818013344.GE149610@dragon>
 <fd41a409-d0e0-0026-4644-9058d1177c45@linaro.org>
 <20220818092257.GF149610@dragon>
 <a08b230c-d655-75ee-0f0c-8281b13b477b@linaro.org>
 <20220818135727.GG149610@dragon>
 <00614b8f-0fdd-3d7e-0153-3846be5bb645@linaro.org>
 <DB9PR04MB8106BB72857149F5DD10ACEA886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
In-Reply-To: <DB9PR04MB8106BB72857149F5DD10ACEA886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 658a1a7c-fc84-46e2-94b6-08da8190c568
x-ms-traffictypediagnostic: DB6PR0401MB2311:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j0i1UB2GUSEiKRSk2thFTkvQT9j31W+7HMJSMEKK5URQjZqQ+iJjQsduuWPbdZEUK1Qr1tOaOaudvQOkENqBujJXa/u9fvP4D65kTf3byvpZ3uXzgmbLLXYGEQGsIOk00bS7L8NmrY0VN3r5hynwOjEHvxlx+qDGtcnbKmK83l9J9PTayl4gFKgTyeUsv3v3VOxYANLMekYv+cFmoceVCLjBgmlbDl3smQSWOjX1/8//uHo4sYmJNeeZKZciQ3FZ24Euj+TSLy9yfLtoemZrXvZnWtNMc+hw6RfBdv9/mI6D2cDk2kmo3KtJBFHjpUXTcHqI3R2zYkplBMnG1/v4KWViI/e9rReu1EYwDKHaE7oCuzlqOy0zXUJDsG1S7LMv8TGywJHayAYISAuZJBIHuniCwSfUvkQBxXklaa/qSQv6mUl+X1iUmGOB44fOafcC5ImLNcLuH2PvNOtiQEG6lP0zqSdQ+sZwyVdziJM18fbq9dvg8RNcQ7n1NNA+Dp6wEvQLZOaX4fvYdJOdnbg9CBn6VJEVLgRskbeW4TLfPWRoOaW0f8J6Zn3yEgW8emNfesGvyZ7d0KtE8JtUITyHvweHWuL5YOAV1i006wZgQOBAEKwJuTZh7+qzjru6QHKSp7cz8AtFwS/S6md79FhN92KxZrtorNIzH1tU+4t8xpJJO/gcqjBCNoeT9xCxuf5ByVMiFwHzr1cIbrkqbiiIz9ObuaTs4qPTJ/UPwxH+X8SMRoJ6LyTQUyhZiosnz07ehEq3OrhJocz6G+dn9UNx8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9416.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(38100700002)(33656002)(86362001)(26005)(83380400001)(9686003)(6506007)(186003)(38070700005)(7696005)(53546011)(478600001)(55016003)(110136005)(316002)(41300700001)(54906003)(71200400001)(8676002)(4326008)(66556008)(64756008)(66446008)(8936002)(76116006)(66476007)(122000001)(7416002)(2906002)(66946007)(15650500001)(5660300002)(52536014)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NURMaTJNVmovcXE0TjdsQ3hESTIyd21KWGJpcGgxYjdoV2ozMXlNNnBnOUIy?=
 =?utf-8?B?d0NjcXBDOWpIOWFOQ2xwTEwzMUZNK3RUQUhJb0hqcmllSERCMU0zWTRydlJP?=
 =?utf-8?B?VGxvRTJrbDZvN2J6TXYzTldYNVd4bEtja0ZDM09QWmxpdG81SUtvaExNS3Nv?=
 =?utf-8?B?cnkyc0MrWUg1U2hKVE9ySDh6QkRMSWVkSDBWZXlRR0xMRE9vNmoxOG1VbFg0?=
 =?utf-8?B?V1lIdnlNT3hYbnVtbXprUHZkb01GUUQrak00YXlkM3RxTlpxM253dDYrTnZo?=
 =?utf-8?B?dVNSblNEUnd5Y0ZzTFQyOFNrZTVHOStuY1N1Nnd3Z2dzUFNVVGtHWExsTm9m?=
 =?utf-8?B?Mk1MLzM1MHpHSEV0NG1NRHFrNVp0UDBDcGs0QWNpOVU2VWpUK1JhUDhqOXVH?=
 =?utf-8?B?RWRRc1ZBK1hmRkZHSE1nMU9nQzVYN1QvNk43N25MVjJYY0JxYVEzNFMweDZz?=
 =?utf-8?B?cmg4RnhqQm02UGgzVHJtL0JYRFBuQ2MwejVIYnRFdnRpdmxRbmMxUk1ZSmxS?=
 =?utf-8?B?U1hQaVk5Rll2V1hDc2EyVGcya1JnZHQ2d0QwWGhqK21ZcW1IaXJTd0FidjhD?=
 =?utf-8?B?OE1tTjFQMDkxdVhxYjBWRzhJT3AzcTRYTWZYMkxRR0lYdnZkMlNhdnEzQ2dt?=
 =?utf-8?B?ZXBtZExJRkM0emhSY2Npa0kyMTdYQ0V2bU1xbGRWRll0V1RPQmN6V0FRNzM1?=
 =?utf-8?B?SVJqUWtIdGcrSXBYc3NOTFlnZklhSUtqNVNLQlFzQUZDVHlzQmVQVVVFRktI?=
 =?utf-8?B?RllSWUVYK0w4N1FXMTIwVTVkWTFRWlRBcURjOFozUzVBVUpoSS8yazFIZGRB?=
 =?utf-8?B?QVlOcjU3Nk1yRkk0dFJpU00ybnUxT05UWUxQcmFWUXhvUUc1cEpRQ2VhR1hE?=
 =?utf-8?B?cW04SGRKOHlyRi9UdlhuMkNOUWY4Zm4zdkNyT3NjQkd4aTRmWHNjWGpXZ1ly?=
 =?utf-8?B?RDZMRC9GdExyQTlXdFlzZUsrTGZMLzE1VlNSY1J2SFFzTUVwd01CaFRNbnV0?=
 =?utf-8?B?WTNvbDNGUnlSVCs5L3o0RU1FRzB5djRmSWdPYW80QTNTenQzelBpN1RZajEv?=
 =?utf-8?B?M082RXZQNFl2NjdUYnZPQWhYdXhvTDJ1Z080RmxrUkp6c282OXA0b0Njelpy?=
 =?utf-8?B?NHR0M0xadDljQ043dEhrYkdJcVF2WUs0NDVXa0tlbTlPcDUwd29ubmRMaHhj?=
 =?utf-8?B?bXVWVXhHT3p1QmRyYS9Ecit4T2c4TUR1OTNsRW1RemVJNjlobHBFMmRsMU9h?=
 =?utf-8?B?N25ZdCt4eGRDV2JpNDNvV2hQWFI2WkdXd1pXRDRZTXJrcDdVMnlTWWNJUWdm?=
 =?utf-8?B?cm1mbjNHKzVrbEZrdzNSdDJKR29hdThIbmlBV1Z0Z0VqVEJvWWlRSUI3ZDU0?=
 =?utf-8?B?MFhOZFRXSUlLV2NVN0lGQW9YYkVqT0dZUndVNFllUktINjJ5Z2lJMXpWSndZ?=
 =?utf-8?B?TDU2NUp1NFlHbEVpYk43Z0RuQ2tSRUptbm1oTFhERnkrdEZWUFQ5U1p4aDMw?=
 =?utf-8?B?SDJqejlHQTg3ZWVpaHE1ZVlRUzJPNngzb3J0Mmh2NTlPa1JiUU9lbnplK0V6?=
 =?utf-8?B?Nm1LcUJMbTIxbGo0M2VVYllEemZ5SW1XSHhXb1RxWlZFcEh5WnZTLzBldCt1?=
 =?utf-8?B?V3FjMGVhWnBlUy9jSDBVcUN2aDlKbjVxcytqUWNja0RES2ZVY0Zna2kySURs?=
 =?utf-8?B?MGk3VGo1ZVo4K0NLdzNZYkEzYmxJRThVbnd0TnVNbk81bFB6M2VvUGtmZlMr?=
 =?utf-8?B?cTZyUEZDY0ZweE5LS0pVQlowelJ2WEM1a3hEVmVma1V6eGdOUE9UZzRMR0NH?=
 =?utf-8?B?OUh5Q2dubThBTllLWCtmTDUrUVdvQVFFVFFyQ1M0MHN6YndFczBaSUlmbEts?=
 =?utf-8?B?aDRHazQ2NklQV0d0eDA4dC85a0FlU1dLS1Z5alh3MzZvM1B6TlNDSmxCNjF2?=
 =?utf-8?B?aEcwY0dDZDUzR2NtWUFnaDRsNG9oSWp0UGM5V0F6KzZ2QTFEOHk0Uk1hN0xR?=
 =?utf-8?B?a24rZnZzQVB0RHNBZFdwYmJrL3BSOTVQTW5aWlVCOVhlcHVZeENYeVlLZUtM?=
 =?utf-8?B?c3ZxTUNUbDRMS29TMHllN1VUVnJyT0lYdzkvdU9oTjBRQVBGTTk2QS9jQ0Nk?=
 =?utf-8?Q?xq98=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB9416.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658a1a7c-fc84-46e2-94b6-08da8190c568
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 03:13:21.3116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DWWQRzG9UE3TXlKiCxmEqmJYaStC1lvssCIBjrmIYLEKKAZ4BdmOyWwQJuFbMpCNBrHWVrffk6HsI3hqHizVCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSRTogW1BBVENIIDEvM10gZHQtYmluZ3M6IG5ldDogZnNsLGZlYzogdXBkYXRl
IGNvbXBhdGlibGUgaXRlbQ0KPiANCj4gDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQo+ID4gRnJvbTogS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBs
aW5hcm8ub3JnPg0KPiA+IFNlbnQ6IDIwMjLlubQ45pyIMTjml6UgMjI6MDQNCj4gPiBUbzogU2hh
d24gR3VvIDxzaGF3bmd1b0BrZXJuZWwub3JnPg0KPiA+IENjOiBXZWkgRmFuZyA8d2VpLmZhbmdA
bnhwLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+ID4gZWR1bWF6ZXRAZ29vZ2xlLmNvbTsg
a3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gPiByb2JoK2R0QGtlcm5lbC5v
cmc7IGtyenlzenRvZi5rb3psb3dza2krZHRAbGluYXJvLm9yZzsNCj4gPiBzLmhhdWVyQHBlbmd1
dHJvbml4LmRlOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiA+IGRldmljZXRyZWVAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiA+IGtlcm5lbEBwZW5n
dXRyb25peC5kZTsgZmVzdGV2YW1AZ21haWwuY29tOyBkbC1saW51eC1pbXgNCj4gPiA8bGludXgt
aW14QG54cC5jb20+OyBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT47IEphY2t5IEJhaQ0KPiA+
IDxwaW5nLmJhaUBueHAuY29tPjsgc3VkZWVwLmhvbGxhQGFybS5jb207DQo+ID4gbGludXgtYXJt
LWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBBaXNoZW5nIERvbmcNCj4gPiA8YWlzaGVuZy5k
b25nQG54cC5jb20+DQo+ID4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzNdIGR0LWJpbmdzOiBuZXQ6
IGZzbCxmZWM6IHVwZGF0ZSBjb21wYXRpYmxlDQo+ID4gaXRlbQ0KPiA+DQo+ID4gT24gMTgvMDgv
MjAyMiAxNjo1NywgU2hhd24gR3VvIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBBdWcgMTgsIDIwMjIg
YXQgMTI6NDY6MzNQTSArMDMwMCwgS3J6eXN6dG9mIEtvemxvd3NraSB3cm90ZToNCj4gPiA+PiBP
biAxOC8wOC8yMDIyIDEyOjIyLCBTaGF3biBHdW8gd3JvdGU6DQo+ID4gPj4+IE9uIFRodSwgQXVn
IDE4LCAyMDIyIGF0IDEwOjUxOjAyQU0gKzAzMDAsIEtyenlzenRvZiBLb3psb3dza2kgd3JvdGU6
DQo+ID4gPj4+PiBPbiAxOC8wOC8yMDIyIDA0OjMzLCBTaGF3biBHdW8gd3JvdGU6DQo+ID4gPj4+
Pj4gT24gTW9uLCBKdWwgMDQsIDIwMjIgYXQgMTE6MTI6MDlBTSArMDIwMCwgS3J6eXN6dG9mIEtv
emxvd3NraQ0KPiB3cm90ZToNCj4gPiA+Pj4+Pj4+IGRpZmYgLS1naXQNCj4gPiA+Pj4+Pj4+IGEv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2wsZmVjLnlhbWwNCj4gPiA+
Pj4+Pj4+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2wsZmVjLnlh
bWwNCj4gPiA+Pj4+Pj4+IGluZGV4IGRhYTJmNzlhMjk0Zi4uNjY0MmMyNDY5NTFiIDEwMDY0NA0K
PiA+ID4+Pj4+Pj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9m
c2wsZmVjLnlhbWwNCj4gPiA+Pj4+Pj4+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvZnNsLGZlYy55YW1sDQo+ID4gPj4+Pj4+PiBAQCAtNDAsNiArNDAsMTAgQEAg
cHJvcGVydGllczoNCj4gPiA+Pj4+Pj4+ICAgICAgICAgICAgLSBlbnVtOg0KPiA+ID4+Pj4+Pj4g
ICAgICAgICAgICAgICAgLSBmc2wsaW14N2QtZmVjDQo+ID4gPj4+Pj4+PiAgICAgICAgICAgIC0g
Y29uc3Q6IGZzbCxpbXg2c3gtZmVjDQo+ID4gPj4+Pj4+PiArICAgICAgLSBpdGVtczoNCj4gPiA+
Pj4+Pj4+ICsgICAgICAgICAgLSBlbnVtOg0KPiA+ID4+Pj4+Pj4gKyAgICAgICAgICAgICAgLSBm
c2wsaW14OHVscC1mZWMNCj4gPiA+Pj4+Pj4+ICsgICAgICAgICAgLSBjb25zdDogZnNsLGlteDZ1
bC1mZWMNCj4gPiA+Pj4+Pj4NCj4gPiA+Pj4+Pj4gVGhpcyBpcyB3cm9uZy4gIGZzbCxpbXg2dWwt
ZmVjIGhhcyB0byBiZSBmb2xsb3dlZCBieQ0KPiA+ID4+Pj4+PiBmc2wsaW14NnEtZmVjLiBJIHRo
aW5rIHNvbWVvbmUgbWFkZSBzaW1pbGFyIG1pc3Rha2VzIGVhcmxpZXIgc28NCj4gPiA+Pj4+Pj4g
dGhpcyBpcyBhDQo+ID4gbWVzcy4NCj4gPiA+Pj4+Pg0KPiA+ID4+Pj4+IEhtbSwgbm90IHN1cmUg
SSBmb2xsb3cgdGhpcy4gIFN1cHBvc2luZyB3ZSB3YW50IHRvIGhhdmUgdGhlDQo+ID4gPj4+Pj4g
Zm9sbG93aW5nIGNvbXBhdGlibGUgZm9yIGkuTVg4VUxQIEZFQywgd2h5IGRvIHdlIGhhdmUgdG8g
aGF2ZQ0KPiA+ICJmc2wsaW14NnEtZmVjIg0KPiA+ID4+Pj4+IGhlcmU/DQo+ID4gPj4+Pj4NCj4g
PiA+Pj4+PiAJZmVjOiBldGhlcm5ldEAyOTk1MDAwMCB7DQo+ID4gPj4+Pj4gCQljb21wYXRpYmxl
ID0gImZzbCxpbXg4dWxwLWZlYyIsICJmc2wsaW14NnVsLWZlYyI7DQo+ID4gPj4+Pj4gCQkuLi4N
Cj4gPiA+Pj4+PiAJfTsNCj4gPiA+Pj4+DQo+ID4gPj4+PiBCZWNhdXNlIGEgYml0IGVhcmxpZXIg
dGhpcyBiaW5kaW5ncyBpcyBzYXlpbmcgdGhhdCBmc2wsaW14NnVsLWZlYw0KPiA+ID4+Pj4gbXVz
dCBiZSBmb2xsb3dlZCBieSBmc2wsaW14NnEtZmVjLg0KPiA+ID4+Pg0KPiA+ID4+PiBUaGUgRkVD
IGRyaXZlciBPRiBtYXRjaCB0YWJsZSBzdWdnZXN0cyB0aGF0IGZzbCxpbXg2dWwtZmVjIGFuZA0K
PiA+ID4+PiBmc2wsaW14NnEtZmVjIGFyZSBub3QgcmVhbGx5IGNvbXBhdGlibGUuDQo+ID4gPj4+
DQo+ID4gPj4+IHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIGZlY19kdF9pZHNbXSA9
IHsNCj4gPiA+Pj4gICAgICAgICB7IC5jb21wYXRpYmxlID0gImZzbCxpbXgyNS1mZWMiLCAuZGF0
YSA9DQo+ID4gJmZlY19kZXZ0eXBlW0lNWDI1X0ZFQ10sIH0sDQo+ID4gPj4+ICAgICAgICAgeyAu
Y29tcGF0aWJsZSA9ICJmc2wsaW14MjctZmVjIiwgLmRhdGEgPQ0KPiA+ICZmZWNfZGV2dHlwZVtJ
TVgyN19GRUNdLCB9LA0KPiA+ID4+PiAgICAgICAgIHsgLmNvbXBhdGlibGUgPSAiZnNsLGlteDI4
LWZlYyIsIC5kYXRhID0NCj4gPiAmZmVjX2RldnR5cGVbSU1YMjhfRkVDXSwgfSwNCj4gPiA+Pj4g
ICAgICAgICB7IC5jb21wYXRpYmxlID0gImZzbCxpbXg2cS1mZWMiLCAuZGF0YSA9DQo+ID4gJmZl
Y19kZXZ0eXBlW0lNWDZRX0ZFQ10sIH0sDQo+ID4gPj4+ICAgICAgICAgeyAuY29tcGF0aWJsZSA9
ICJmc2wsbXZmNjAwLWZlYyIsIC5kYXRhID0NCj4gPiAmZmVjX2RldnR5cGVbTVZGNjAwX0ZFQ10s
IH0sDQo+ID4gPj4+ICAgICAgICAgeyAuY29tcGF0aWJsZSA9ICJmc2wsaW14NnN4LWZlYyIsIC5k
YXRhID0NCj4gPiAmZmVjX2RldnR5cGVbSU1YNlNYX0ZFQ10sIH0sDQo+ID4gPj4+ICAgICAgICAg
eyAuY29tcGF0aWJsZSA9ICJmc2wsaW14NnVsLWZlYyIsIC5kYXRhID0NCj4gPiA+Pj4gJmZlY19k
ZXZ0eXBlW0lNWDZVTF9GRUNdLCB9LA0KPiA+ID4+DQo+ID4gPj4gSSBkb24ndCBzZWUgaGVyZSBh
bnkgaW5jb21wYXRpYmlsaXR5LiBCaW5kaW5nIGRyaXZlciB3aXRoIGRpZmZlcmVudA0KPiA+ID4+
IGRyaXZlciBkYXRhIGlzIG5vdCBhIHByb29mIG9mIGluY29tcGF0aWJsZSBkZXZpY2VzLg0KPiA+
ID4NCj4gPiA+IFRvIG1lLCBkaWZmZXJlbnQgZHJpdmVyIGRhdGEgaXMgYSBnb29kIHNpZ24gb2Yg
aW5jb21wYXRpYmlsaXR5LiAgSXQNCj4gPiA+IG1vc3RseSBtZWFucyB0aGF0IHNvZnR3YXJlIG5l
ZWRzIHRvIHByb2dyYW0gdGhlIGhhcmR3YXJlIGJsb2NrDQo+ID4gPiBkaWZmZXJlbnRseS4NCj4g
Pg0KPiA+IEFueSBkZXZpY2UgYmVpbmcgMTAwJSBjb21wYXRpYmxlIHdpdGggb2xkIG9uZSBhbmQg
aGF2aW5nIGFkZGl0aW9uYWwNCj4gPiBmZWF0dXJlcyB3aWxsIGhhdmUgZGlmZmVyZW50IGRyaXZl
ciBkYXRhLi4uIHNvIG5vLCBpdCdzIG5vdCBhIHByb29mLg0KPiA+IFRoZXJlIGFyZSBtYW55IG9m
IHN1Y2ggZXhhbXBsZXMgYW5kIHdlIGNhbGwgdGhlbSBjb21wYXRpYmxlLCBiZWNhdXNlDQo+ID4g
dGhlIGRldmljZSBjb3VsZCBvcGVyYXRlIHdoZW4gYm91bmQgYnkgdGhlIGZhbGxiYWNrIGNvbXBh
dGlibGUuDQo+ID4NCj4gPiBJZiB0aGlzIGlzIHRoZSBjYXNlIGhlcmUgLSBob3cgZG8gSSBrbm93
PyBJIHJhaXNlZCBhbmQgdGhlIGFuc3dlciB3YXMNCj4gPiBhZmZpcm1hdGl2ZS4uLg0KPiA+DQo+
ID4gPg0KPiA+ID4NCj4gPiA+PiBBZGRpdGlvbmFsbHksIHRoZQ0KPiA+ID4+IGJpbmRpbmcgZGVz
Y3JpYmVzIHRoZSBoYXJkd2FyZSwgbm90IHRoZSBkcml2ZXIuDQo+ID4gPj4NCj4gPiA+Pj4gICAg
ICAgICB7IC5jb21wYXRpYmxlID0gImZzbCxpbXg4bXEtZmVjIiwgLmRhdGEgPQ0KPiA+ICZmZWNf
ZGV2dHlwZVtJTVg4TVFfRkVDXSwgfSwNCj4gPiA+Pj4gICAgICAgICB7IC5jb21wYXRpYmxlID0g
ImZzbCxpbXg4cW0tZmVjIiwgLmRhdGEgPQ0KPiA+ICZmZWNfZGV2dHlwZVtJTVg4UU1fRkVDXSwg
fSwNCj4gPiA+Pj4gICAgICAgICB7IC8qIHNlbnRpbmVsICovIH0NCj4gPiA+Pj4gfTsNCj4gPiA+
Pj4gTU9EVUxFX0RFVklDRV9UQUJMRShvZiwgZmVjX2R0X2lkcyk7DQo+ID4gPj4+DQo+ID4gPj4+
IFNob3VsZCB3ZSBmaXggdGhlIGJpbmRpbmcgZG9jPw0KPiA+ID4+DQo+ID4gPj4gTWF5YmUsIEkg
ZG9uJ3Qga25vdy4gVGhlIGJpbmRpbmcgZGVzY3JpYmVzIHRoZSBoYXJkd2FyZSwgc28gYmFzZWQN
Cj4gPiA+PiBvbiBpdCB0aGUgZGV2aWNlcyBhcmUgY29tcGF0aWJsZS4gQ2hhbmdpbmcgdGhpcywg
ZXhjZXB0IEFCSSBpbXBhY3QsDQo+ID4gPj4gd291bGQgYmUgcG9zc2libGUgd2l0aCBwcm9wZXIg
cmVhc29uLCBidXQgbm90IGJhc2VkIG9uIExpbnV4IGRyaXZlcg0KPiBjb2RlLg0KPiA+ID4NCj4g
PiA+IFdlbGwsIGlmIExpbnV4IGRyaXZlciBjb2RlIGlzIHdyaXR0ZW4gaW4gdGhlIHdheSB0aGF0
IGhhcmR3YXJlDQo+ID4gPiByZXF1aXJlcywgSSBndWVzcyB0aGF0J3MganVzdCBiYXNlZCBvbiBo
YXJkd2FyZSBjaGFyYWN0ZXJpc3RpY3MuDQo+ID4gPg0KPiA+ID4gVG8gbWUsIGhhdmluZyBhIGRl
dmljZSBjb21wYXRpYmxlIHRvIHR3byBkZXZpY2VzIHRoYXQgcmVxdWlyZQ0KPiA+ID4gZGlmZmVy
ZW50IHByb2dyYW1taW5nIG1vZGVsIGlzIHVubmVjZXNzYXJ5IGFuZCBjb25mdXNpbmcuDQo+ID4N
Cj4gPiBJdCdzIHRoZSBmaXJzdCB0aW1lIGFueW9uZSBtZW50aW9ucyBoZXJlIHRoZSBwcm9ncmFt
bWluZyBtb2RlbCBpcw0KPiA+IGRpZmZlcmVudC4uLiBJZiBpdCBpcyBkaWZmZXJlbnQsIHRoZSBk
ZXZpY2VzIGFyZSBsaWtlbHkgbm90IGNvbXBhdGlibGUuDQo+ID4NCj4gPiBIb3dldmVyIHdoZW4g
SSByYWlzZWQgdGhpcyBpc3N1ZSBsYXN0IHRpbWUsIHRoZXJlIHdlcmUgbm8gY29uY2VybnMNCj4g
PiB3aXRoIGNhbGxpbmcgdGhlbSBhbGwgY29tcGF0aWJsZS4gVGhlcmVmb3JlIEkgd29uZGVyIGlm
IHRoZSBmb2xrcw0KPiA+IHdvcmtpbmcgb24gdGhpcyBkcml2ZXIgYWN0dWFsbHkga25vdyB3aGF0
J3MgdGhlcmUuLi4gSSBkb24ndCBrbm93LCBJDQo+ID4gZ2F2ZSByZWNvbW1lbmRhdGlvbnMgYmFz
ZWQgb24gd2hhdCBpcyBkZXNjcmliZWQgaW4gdGhlIGJpbmRpbmcgYW5kDQo+ID4gZXhwZWN0IHRo
ZSBlbmdpbmVlciB0byBjb21lIHdpdGggdGhhdCBrbm93bGVkZ2UuDQo+ID4NCj4gPg0KPiBTb3Jy
eSwgSSBkaWQgbm90IGV4cGxhaW4gY2xlYXJseSBsYXN0IHRpbWUsIEkganVzdCBtZW50aW9uZWQg
dGhhdCBpbXg4dWxwIGZlYw0KPiB3YXMgdG90YWxseSByZXVzZWQgZnJvbSBpbXg2dWwgYW5kIHdh
cyBhIGxpdHRsZSBkaWZmZXJlbnQgZnJvbSBpbXg2cS4NCj4gU28gd2hhdCBzaG91bGQgSSBkbyBu
ZXh0PyBTaG91bGQgSSBmaXggdGhlIGJpbmRpbmcgZG9jID8NCg0KSnVzdCBteSB1bmRlcnN0YW5k
aW5nLCBzYXlpbmcgaS5NWDZRIHN1cHBvcnRzIGZlYXR1cmUgQSwNCmkuTVg2VUwgc3VwcG9ydCBm
ZWF0dXJlIEEgKyBCLCBUaGVuIGkuTVg2VUwgaXMgY29tcGF0aWJsZSB3aXRoIGkuTVg2US4NCg0K
SWYgdXBwZXIgaXMgdHJ1ZSBmcm9tIGhhcmR3YXJlIGxldmVsLCB0aGVuIGkuTVg4VUxQIEZFQyBu
b2RlDQpzaG91bGQgY29udGFpbiA4dWxwLCA2dWwsIDZxLg0KDQpCdXQgdGhlIGxpc3QgbWF5IGV4
cGFuZCB0b28gbG9uZyBpZiBtb3JlIGFuZCBtb3JlIGRldmljZXMgYXJlIHN1cHBvcnRlZA0KYW5k
IGhhcmR3YXJlIGJhY2t3YXJkIGNvbXBhdGlibGUNCg0KUmVnYXJkcywNClBlbmcuDQo=
