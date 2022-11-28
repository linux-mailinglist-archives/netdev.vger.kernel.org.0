Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5B563A525
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiK1JdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiK1JdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:33:04 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2101.outbound.protection.outlook.com [40.107.22.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413D61901D;
        Mon, 28 Nov 2022 01:33:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWMU7MscvQFQdf6onackpwBMs7UBhWvgzexqWMe36cJDTdZFVZdXJ2kRk0rOl4DnmqIyjvt/OcqLBL28dR7+2j9P9PtV5aa3dMGt3rD+5zD6uWmg05IEv/KqvmriGT4V1x6hHpTX8+sPZ3A+FSb2nNSacbyGvfTraTQLrqB8CqEK241gMcBdQAajr9TuDo9o9rG6+9o2l23C2D8LGVSCKKO0McnXkjwcuyjO5HRBqT9VjXIBMfkfOAiuZVIUm/1m+gxp3UoGpnWLB1fs0Quh5foY6Wwyr4bogLLyQ2xPYZSVPGw8rfMq+XjCJc8SNvX3GSdz2Txbgc5jKH3JQb3YpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ocM9Ujec6YNVJ8Y0ZjnnpsT4Jbm6VieD8Kb52J182Q4=;
 b=fQ5Tvu1a51iqSaakGLbfvoo05C+bblsTltqLZipRVLBQIi2mnEOh0tVvKmTL1coP8rbwtqklEPNosjAKhtOvWrN/szsIM5UQ7XRB5dkoVvK2MGtDNMsPHkDDRZfqBZFcsIMEARTWj5X0TXsukNOMYwpg8s0AZsoW4jljCse7z6S9CD+fZQ9clu5HCPkNXs4IK/9fPhC7cGE8UFs23BpLR6Gs3ti5cXFoFTr48QQTym0z9oq9n1LnNXBHMyxvqF9PQ1wu5JlUl3lcGCtrmTgB1cBXZXzZJ0ROGQHVf96twVMlO/bQQs4aCCNOaKDqH6wdfNXYv5v9gZTj1YTToUaNXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocM9Ujec6YNVJ8Y0ZjnnpsT4Jbm6VieD8Kb52J182Q4=;
 b=Z0tdkaFjQOmQZ8zoaaxB6bpoecqsjGcw0zu3qmR3KPeu8iTIjYkUcfjxuVk5NvSQu+ScqDC8E8BWMcpo0NLSVX3t9gV0oD2VPYlKc0Gv+e3WsG9aKN88F+b2abJnk+nj4PdJQj9/x99hNzkeCcwEL7KEakGguakrQ4GzOMRO+yE=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PR3PR03MB6460.eurprd03.prod.outlook.com (2603:10a6:102:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Mon, 28 Nov
 2022 09:33:00 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::fda3:95f7:e93:d112]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::fda3:95f7:e93:d112%3]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 09:32:59 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 net-next 03/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Thread-Topic: [PATCH v3 net-next 03/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Thread-Index: AQHZArJJxYAL9Bub8Uaiwr2q9GCOAK5UE2sA
Date:   Mon, 28 Nov 2022 09:32:59 +0000
Message-ID: <20221128093300.nuug3vfkn7apu7o4@bang-olufsen.dk>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-4-colin.foster@in-advantage.com>
In-Reply-To: <20221127224734.885526-4-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|PR3PR03MB6460:EE_
x-ms-office365-filtering-correlation-id: 68c9c34e-bdc5-4f4a-bf0f-08dad1238a35
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wEo1R/LFEdj20mkgv4+pBH2L42oVNVvA+yLFHdsi6dALdDor9U3fDzacb+SKgR2sIoQdB5Wgci90Y0MjrSo0GQNFNBR3wwHgxoO6fStEx/d6GJJP7nbNgZr1THyeaM2lSnQcXOjZbQGoPVWcVoYQTYoNBj5fy8bFD+GzSbalWf1y46aZQ6KX4Zv4DYBXMvPmr/soJqLX/353TxkVbt8U9Z6Pdfc4fckSSbp6PSAHXbQ/C4C3H/5+cjskcgWcFxzySbodjCYVBffld6S2mFxxHt2Who43KW2rFQ4OSvEJoCQwBC3TkcX0mPOkf+jM6xG1FQBgegLC0sQAuc2CbpvssHlPlA4uxXQlAoIpkpCnxl5vhJdIPrKTUCfqXe5rXNLEuAGNQp5ihjrD/iSoYj9bL+6UALgRX1WtwjABipBKbHqnB9tEh8NNSR0qn+N+738rzzsmctU3cSv+UevjKK+iXc9J2MBuZ81XQGau/VbIDMuE8jhzVhcEF9uUvefyuo6EFf/fJhHwKdfrWCZm8pvhSTQhBuraIV9p/oo3vqBzJgDT7U5I9P5oZlhRJHQMfTsZQ3vufE0Gq5BLW+/aIDrdTDquzHIVUTBEPy+EOatM5RpjNivWyduJj5YnSr5S7SlRCbXrP/yWIc/41hPRUq9fsVvNiuDqAz93Ai06yzjxJ/gDgAbOW+r01pzw8HlMxt+2r30so41+dvUYw4hnWCG8Vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(346002)(39850400004)(396003)(451199015)(85202003)(38070700005)(7416002)(5660300002)(7406005)(122000001)(71200400001)(85182001)(38100700002)(54906003)(6916009)(91956017)(76116006)(6512007)(26005)(186003)(316002)(8976002)(1076003)(8936002)(36756003)(6506007)(4326008)(66556008)(66946007)(64756008)(86362001)(66446008)(8676002)(66476007)(2616005)(41300700001)(478600001)(6486002)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkdST2VkRnNjekYyMHovOVFyczhxMUdqSVBqM01ad2lROXdqTUN3RlhueTJV?=
 =?utf-8?B?R3VsTk5KUHhDVGVkblRLK0k5WDdkVDFoZWs1VnN1MXkyTC8vMWZDNlJuZXV3?=
 =?utf-8?B?bkVJbkxLeThkWjdZOHhndVpNZlAyR3VkNW5Vd2k3eVhjcGo5bGY3UUJjSFVB?=
 =?utf-8?B?aWxnanNIU1FhZVEvOUQrZS9JYkJnTnhHeHBxWlRBSGZtaWRFNXFTVXJNSTg1?=
 =?utf-8?B?SGZqelNRZGJidm5jaFNLeWUrL2FWTE40RE1vc0FJYXF5Rmt1R1QxcmZvNkpG?=
 =?utf-8?B?MjBLcXBodFdjekxVSFo0OWQ1RExWYlBDcnQ1MnlUU1pvdUlhVHQ5ZjFDUEZ6?=
 =?utf-8?B?Zi9BN2QxSEI3R0Z3c0RibXFDRzlZalhKV3NraSswcTZBVGNsdWsyZjQyTjhT?=
 =?utf-8?B?VEJkY1cwUTgyY0M2S285SDhJRDNvcVYxT0ZaSk1GZzZSUkdmZG5LNGtaYnVN?=
 =?utf-8?B?Qzg0Y01KalFueFdjNC9WQktWL1dGeGl2eFFoWHI1NjlyMks0UDkvTk1zVTJW?=
 =?utf-8?B?NnFnYTZWSmZrcUlmb3pTVjRIMEZXUFh4cjQvNk11UThjVHdMakYxT0gwS2Ns?=
 =?utf-8?B?L2NyUVJwUDh4cGxBMDRJaUI4RjAxU1BwZEpKUTZBOTZNaFhqcXR0NjJaczF6?=
 =?utf-8?B?bk1hdTNOWDJQL1dhTTU5cWg1Y3ZjakE4c2hWbFBVU1JkQXlTMlZzWW9lK2NY?=
 =?utf-8?B?T1VpV2JESk1Cc2IzbFNPRVFMeDR0Z0lpWjBna05UbGZIcGJ4Z0ozQWV2aU4w?=
 =?utf-8?B?OGV1QU0yajRFdTZIWlFlSzhDUVIvamxVWjJ4Q05Zb05aSlVhVkVlaGg4YUZp?=
 =?utf-8?B?S0w4cXp6S3RrQWs1MzZFZkVsczd1VlJqSnFKd3E0NzNWUWdBY0dyVWl4RFZs?=
 =?utf-8?B?Smx5WDlRVWtqVWhnaUcwUmFZVTcvczBxMGYvZlJUcTNxdDF0ODF3dkgwL2lm?=
 =?utf-8?B?Uk9TZHhwbVdFYXBnK2pvaW52MzQzVWlMcXp5Vy94Z2hCTHg2akZXS2k2ck5H?=
 =?utf-8?B?bjZzWHJXa2c3dUV4NFQwWTRqck0zVkJybHkxK2hGRmZSdHF6aUxMVitFMy85?=
 =?utf-8?B?aklWSGZiMG1ITFpqaHg2K2xEdTczU211b0tMcWhkQ1gwVmhBSDhlNW14cWpD?=
 =?utf-8?B?SS9NQVVlS2N3eXJoSHZtam1Hc1VDRHdHQ2Nvb3IwMWJ1dUN2MEVqU0tueTcv?=
 =?utf-8?B?eXJ6dGxITk05V2RnTEpIdlk2TENJS3A4ME1aWlozR1MzZHBrVjZsQWVPUGhM?=
 =?utf-8?B?T3F5SDBabWRlN21ucS93eUc4Sm15QTdWVmsvZStaWEFWb1A1YytVb25XMjZT?=
 =?utf-8?B?UWZuNFFsa0pMK05GbzRsUFhCVGxMNnJnenhsZDU2RWFGbFNoTVNQWUZZUlhL?=
 =?utf-8?B?WWsySG1YMDV3eThQa3o5aUVGb053dlM5MGlBRlFXeWpKeE1IZVJFREliZUw1?=
 =?utf-8?B?TFhVNDZZZzkxK3NQRGVhZVhCUUg4V2ZxOGFKaG1jdXgrR0R6ODMrcmVSNDI1?=
 =?utf-8?B?S1FqeERXWEgrZ1NxeUZJZmtIY3Y3OUNMU2Z5VHlaN2k5cldWbWI4ZzRXOHVa?=
 =?utf-8?B?ck9FajRLTnR3OVV4TmRXQ1FBQWl3SUNvckM4R0JhUlQ0MVlFdmx0LzF1M0Fa?=
 =?utf-8?B?RDhvZFZKblFHdU02VGIxd3hQOFhPV2p4ZVhCeHJqT1JqbzNXaWRrbTVDWkN1?=
 =?utf-8?B?Q1RES21zdG1VbTJYUTFGUmEwSG1IS3dxYlBaVDRwZVEycFFoOTlCWnlqNTFn?=
 =?utf-8?B?dU1hQzFkd3RZT2dBbzVSUEZWWElaMHF4dW1CNm9RRXJIVVhndHZJMDYvak5x?=
 =?utf-8?B?YnBya2xxZ3p0SmN3T0MxY2Z4TElaVFFyWWNsZzFCZkFjYUdHK1VqdC8xWVJO?=
 =?utf-8?B?NEIxMm5wRkh2b0Q1OWRCK01tWkMxNDdyVFFnNE1CRzYzd3dBa2ZCdlNFbHk2?=
 =?utf-8?B?am83WnpkdkQ1V3l3dWJOZGR5SHZBUk9rQ0FBNW9pdXdRVnZ5Q09FQVQzaEYw?=
 =?utf-8?B?U0kyQmVlUGkybEJjbVZJY0lYbVVsdjBWaVZWdWxqamFRZHJkWlNHaGRvcVQ0?=
 =?utf-8?B?cS83aFEwTlFwZ09uNWNpcUc3N2hadXdLWnU3TlNJc0tiekN1bjR1ZkVpa1hs?=
 =?utf-8?B?WWlsaUFtOG9LZ3JndWx6OW1Ba1RUU1F3bXBSUHM3RTVWYklxamd5MjRMWWNn?=
 =?utf-8?B?T0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01720F201F03F740A602E625672FD08B@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c9c34e-bdc5-4f4a-bf0f-08dad1238a35
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 09:32:59.8716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YgFVapikS2gtW78lWappHGstxMV5x05Vscc4l2r5/HT+6yLlXBpnVj7ZashlKP43bkgJ6hH9QNc5T4gxbCUX9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6460
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCBOb3YgMjcsIDIwMjIgYXQgMDI6NDc6MjdQTSAtMDgwMCwgQ29saW4gRm9zdGVyIHdy
b3RlOg0KPiBEU0Egc3dpdGNoZXMgY2FuIGZhbGwgaW50byBvbmUgb2YgdHdvIGNhdGVnb3JpZXM6
IHN3aXRjaGVzIHdoZXJlIGFsbCBwb3J0cw0KPiBmb2xsb3cgc3RhbmRhcmQgJyhldGhlcm5ldC0p
P3BvcnQnIHByb3BlcnRpZXMsIGFuZCBzd2l0Y2hlcyB0aGF0IGhhdmUNCj4gYWRkaXRpb25hbCBw
cm9wZXJ0aWVzIGZvciB0aGUgcG9ydHMuDQo+IA0KPiBUaGUgc2NlbmFyaW8gd2hlcmUgRFNBIHBv
cnRzIGFyZSBhbGwgc3RhbmRhcmRpemVkIGNhbiBiZSBoYW5kbGVkIGJ5DQo+IHN3dGljaGVzIHdp
dGggYSByZWZlcmVuY2UgdG8gJ2RzYS55YW1sIycuDQo+IA0KPiBUaGUgc2NlbmFyaW8gd2hlcmUg
RFNBIHBvcnRzIHJlcXVpcmUgYWRkaXRpb25hbCBwcm9wZXJ0aWVzIGNhbiByZWZlcmVuY2UNCj4g
dGhlIG5ldyAnJGRzYS55YW1sIy8kZGVmcy9iYXNlJy4gVGhpcyB3aWxsIGFsbG93IHN3aXRjaGVz
IHRvIHJlZmVyZW5jZQ0KPiB0aGVzZSBiYXNlIGRlZml0aW9ucyBvZiB0aGUgRFNBIHN3aXRjaCwg
YnV0IGFkZCBhZGRpdGlvbmFsIHByb3BlcnRpZXMgdW5kZXINCj4gdGhlIHBvcnQgbm9kZXMuDQo+
IA0KPiBTdWdnZXN0ZWQtYnk6IFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+DQo+IFNpZ25l
ZC1vZmYtYnk6IENvbGluIEZvc3RlciA8Y29saW4uZm9zdGVyQGluLWFkdmFudGFnZS5jb20+DQo+
IC0tLQ0KPiANCj4gdjMNCj4gICAqIE5ldyBwYXRjaA0KPiANCj4gLS0tDQo+ICAuLi4vYmluZGlu
Z3MvbmV0L2RzYS9hcnJvdyx4cnM3MDB4LnlhbWwgICAgICAgfCAgMiArLQ0KPiAgLi4uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9icmNtLGI1My55YW1sIHwgIDIgKy0NCj4gIC4uLi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvZHNhLnlhbWwgICAgICB8IDE5ICsrKysrKysrKysrKysr
KystLS0NCj4gIC4uLi9uZXQvZHNhL2hpcnNjaG1hbm4saGVsbGNyZWVrLnlhbWwgICAgICAgICB8
ICAyICstDQo+ICAuLi4vYmluZGluZ3MvbmV0L2RzYS9tZWRpYXRlayxtdDc1MzAueWFtbCAgICAg
fCAgMiArLQ0KPiAgLi4uL2JpbmRpbmdzL25ldC9kc2EvbWljcm9jaGlwLGtzei55YW1sICAgICAg
IHwgIDIgKy0NCj4gIC4uLi9iaW5kaW5ncy9uZXQvZHNhL21pY3JvY2hpcCxsYW45Mzd4LnlhbWwg
ICB8ICAyICstDQo+ICAuLi4vYmluZGluZ3MvbmV0L2RzYS9tc2NjLG9jZWxvdC55YW1sICAgICAg
ICAgfCAgMiArLQ0KPiAgLi4uL2JpbmRpbmdzL25ldC9kc2EvbnhwLHNqYTExMDUueWFtbCAgICAg
ICAgIHwgIDIgKy0NCj4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvcmVhbHRlay55
YW1sICB8ICAyICstDQo+ICAuLi4vYmluZGluZ3MvbmV0L2RzYS9yZW5lc2FzLHJ6bjEtYTVwc3cu
eWFtbCAgfCAgMiArLQ0KPiAgMTEgZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwgMTMg
ZGVsZXRpb25zKC0pDQoNCkFja2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZz
ZW4uZGs+ICMgcmVhbHRlaw==
