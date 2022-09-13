Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B00A5B744D
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbiIMPVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 11:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiIMPTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 11:19:44 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-he1eur02on0607.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe05::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A5A79EED;
        Tue, 13 Sep 2022 07:36:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPyFo/yG5YFw/LpSWg4fTxefiL20m37yyVpq4u85jeNHsXF4Bh504Hz6DApDhnte/8ZykpZA/tH61t4uPXQwbBNeWby7hjWLWWXQ0v2gqA2cOJ4CtXpgt2MJl+D3Zzel/u2J422lYr/Fl7ChHbR2/aDR5Uq/4xkP4nG54nQZAv2c6Y9nKzu0qS+GeyOaMyEXlIf5FqofJIxTRm/WWgeAS/gr02LrXZ+1eOcfk+7M2lAhLn1SKSQU40+wHFLlaykyf5XDRjGXGPJisBDctbIF9h3M6Lyh+o6u5HAom7AoUdva6v4KgiF+vmWeozR0/s6hcL0VO5O+bVqNmfXQMYh4nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hcqwtd2+mYcf7CmY79H9YC9GT8cTaKmtLpKkPrGfjzw=;
 b=E5MAKM0419oAtWrbiitGPMSId93MWS+csC9BFKGl9lRlCn6Foto8bq8yPVYUze8SoEUJYxisOHx+rcDXxr1UP5FOipHH3AeRkmxCG66Z+eqWeFfGvDXw4ahYKZlXIdnHXoXsCSh0mvfrXIhjKrrDpt3gB3YznbV8gmuUcZwNqEixJ1D3xyRt2ItAeM0obroMMKS/HDLN93PBHm9Dm4UaCOIKjr/L5rIignWgPhq+3hYviOBte5OLW4zQORzpukYqjBzPEDIV6CiIHn8OLXPYd7y25DfcABcKYCPziIRv3VM3uiKPt09e8aM6fN1euKnXwxYxUVo17o7i4SUCIdKg8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hcqwtd2+mYcf7CmY79H9YC9GT8cTaKmtLpKkPrGfjzw=;
 b=Ttb3pDpZm3IsKbIhyW/emstYkxPBEnYW59jq88FAuPDeqXFrmBxtyUkqDxPxmKf/ABP4LxaQGkPn13yWxRmb4K6OY8ri6TDkoKvRPbdwQ3GmiDkrrRkR+yu69u2rmxf2FcGVyQujXjl/LC8RJwtGHiMzbMIonYG1UKNh+bU68d8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7017.eurprd04.prod.outlook.com (2603:10a6:10:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 14:32:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 14:32:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: remove label = "cpu"
 from examples
Thread-Topic: [PATCH net-next 3/3] dt-bindings: net: dsa: remove label = "cpu"
 from examples
Thread-Index: AQHYxtBCZhrlfLn9yUSG8exS6G8zpK3dBZ8AgABW+gCAAAwAgIAABS8A
Date:   Tue, 13 Sep 2022 14:32:53 +0000
Message-ID: <20220913143252.xfajlh6v7aqznakw@skbuf>
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-4-vladimir.oltean@nxp.com>
 <b11e86c6-ff35-2103-cebe-ebe5f737d9de@arinc9.com>
 <20220913133122.gzs2uhuk626eazee@skbuf>
 <8a323fc4-bf98-a808-899a-957438b0d792@arinc9.com>
In-Reply-To: <8a323fc4-bf98-a808-899a-957438b0d792@arinc9.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB8PR04MB7017:EE_
x-ms-office365-filtering-correlation-id: 665aaf4b-1847-41f1-c366-08da9594d797
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XK3x6N989qu58UakxWOlPMPKHzMK2yV/4ip8Tz613YhXQbdBtpjjpdaBuZ+SgMJk+mF9h2rPmYOOjWGDtKqVfsdmgqI6h9BhsTFRbP5QzO+h1q4FgHkQQX+wWWI3NNEuMvTE/9H4vBK/F9oLqf9ExCn0kzdTLp/3s7FAPN8UD7zCh2qfGmMCQq/nw1px+u/Rc842LihI9nVN8MAzkLfhQwH1k1W3lRbvzBRaoFO0NBwTwCXJBkVfvAc3gviN7mP4uNJuQ6xqCxwg+06ZC9ReAxg+p345U3Meplw6ILf+/SS7VxMqvVCG/rZY0xAIa5hPUuwS1+k5oio3fT4YoJCIEepHEdJAa5BVeYgBuInmiXvZSVGJ4mrTYbdjMWzwDXbrLydHsv06kB+B4H2828QddNsBZREk3wCc/zoFOFAk9qN+4TFExnbuTsrJg1pQ0BkvEW3birrrKDlzkGpuiGMcqh4hTndudpAgI3uRQbZtC10Ec2e++x6FFOsUXsKvymvLv1V8zJWjTC+5IpMu0rv4KSa2Ab/utZaj8fwv4IkgOFz+35GuIyLwWuNvciJzNhrpSRmzkaD8+8ze67RpP0JfQ4l8Gcj+JzVjDkZwWbus0kzRf9TFrfajDCII/rwZ/NWtqPRtt0Jkh7szq0D73X+n8AziD7WJxJHHfeM7vbU8Hgq/Vw9obIwwVL26gOUKfyA2UK6fgblQt5ag+WyC8DUeJZ6Gi4tjzvTTfHsLN2KskOD4+BINDvjEglexrjxuOYZA99kuMBNggPnDtr+BvlbTWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(83380400001)(9686003)(186003)(6486002)(1076003)(8676002)(6916009)(54906003)(44832011)(5660300002)(53546011)(4326008)(71200400001)(33716001)(66556008)(86362001)(66946007)(6506007)(91956017)(66476007)(7416002)(76116006)(8936002)(6512007)(7406005)(38100700002)(478600001)(2906002)(122000001)(64756008)(316002)(41300700001)(26005)(4744005)(66446008)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlFJTjNNQ0tzODZnZWxVVk00K3pPKzZMVmdiSFlRNGFId3dJOHhrWHpRbHhl?=
 =?utf-8?B?Q2daM2N5N2xjbDg1Mm1kaXBzdXVhdkxLZ09Sa3lScWZHSzlxK2xMYnhZUU12?=
 =?utf-8?B?QmRZWlgzL0hmbVY4RzNpLzNvSzlWQVFWalJmTjB0ZlEzQzJjQi82bHk5QklY?=
 =?utf-8?B?K1B2L2J5d3Q1S2hWeTRBR01YdmpqSS9uRWhSOU9EZGM3S3lobG8vRkxsOUxz?=
 =?utf-8?B?ZFZVYUJka3VsYVJib1N3U29scmI3NytJcDEyUVNoM05hRjlUZlVPZm1FUEx2?=
 =?utf-8?B?NlRlRnh3eG1pTDR1TVhZK0V1TzNkUkUwV1Y5Y0dlcjMzOVpIQm5raWJQRmRE?=
 =?utf-8?B?Y254cDhCZVRIYTJrMFB1ekRRSUZhd2hYTmFySGNJVVhPajF1NnRkKzB4WmI4?=
 =?utf-8?B?S3MybmpHUUxEUWtsM1dJcVRtVlN0bmw1WFh5R2JuaXZUdGhmVVVia3l0TEZL?=
 =?utf-8?B?Qm5vSGlxclNQUGFCdE1IZ29iMnl1SmdmUjFDaE5KMERUak1kc1dUUVNEK1Zr?=
 =?utf-8?B?U0xuSzVvM2lTWUt1aVVwR216M0I1MklGWmp1d1BMcFRvK0NjM1V2M3o4c1Vk?=
 =?utf-8?B?YzRTSkhqZHdWSTBSVGtjd1ppKzRlZi9sam1mazc0Ym1pRGc2cG1wM28rTXZI?=
 =?utf-8?B?MEN5RWkrWDVoazRCOUUyUVhvQlJZb2Y0YTI5YWJqMUJycXFuS0tGanJ3VjRO?=
 =?utf-8?B?aGh3cG1jM2gzWEVielZqbWZaNnBJYk9KOGdWNkJQK3FuZTZDVk1neDNaNWsv?=
 =?utf-8?B?dGJXemJqRjc0cmFnMHEzOWhyUCt6T0ZkbkVOVEhvek1UeitWOGtYNkJqUkZq?=
 =?utf-8?B?YkNyRThIT0dRWUxiOTAzRWxta1RiYmt0RUhHMGthMXJMaEw2ek1XZElkcVZX?=
 =?utf-8?B?NHBNeFp5TzlvVmtMNlZWZ2FuM0c0aWY4RTNESE1PeXoxVlJiQ20zNVg2U2li?=
 =?utf-8?B?aUxJQkpnVlJ3eGdwRGh0Nm5yU2dXTW4xL1FPWURIbGUyVXRLYWRJSjV0TVR4?=
 =?utf-8?B?dHpOZUlTUVUveHZYcG9PLzM5ajc3UWh4aDVrUk54eTJiV1MrOGVyVlRCYWFn?=
 =?utf-8?B?QTJaK2lPMTE3R0xHdDN6NmpydEN4dm9PVjF2NVFNejBYM1JLVnYwWVRDelNq?=
 =?utf-8?B?SjhmTnRwU3RhSFA0RjZDV25mQnI3eW9Sa1F3RXBYYVB1ejh0Z1hrWjlDM25u?=
 =?utf-8?B?VG9MelF5UWsvVWVZR01kcVQ4aUR0cFBaK09GUnI3Rkd2UFhOa0RaNldzWnBl?=
 =?utf-8?B?c0VKMjVlZm1ybHpzWEpxeXBHc2gzQkttN2FGZjZEOVJ3S2VmS0hDSnFFOUhk?=
 =?utf-8?B?WWo0Q0tDS1FxR2o1K0Fxd2p5dE84RGZid3c2YklJeUc1TkhPNStPUzlsNWpV?=
 =?utf-8?B?NktwdGNWdlRRaUZGM2wyS3haU0tGQTFBNzQ3TDBJZVp5WlNGSlpMb1FoK0Vz?=
 =?utf-8?B?SzFZKzI1aWZFQUVxSXJKWU53eks5eDlidFF6QytJR2Z1bTRTYW15RERkQWpC?=
 =?utf-8?B?Q25oaE1BZTlCNGJUbHprcnZJZUFkbzNFbTR5NVJVTUZCS1lzRDJJWXRyNG1P?=
 =?utf-8?B?VkYrQ3lKVVl5R284Z0FsN1N0ajBqZjlKem1SSXVTaktpdG1zMEZMNTJ3UUpa?=
 =?utf-8?B?dDBGS092cG43ajY1UC9La0g1VjVrVGRRYW1LWDhwMUx5c2FzTDg3TlBtWFEw?=
 =?utf-8?B?T1B3d0tRb3BYaXZ6ZmVZKzEzeFlvR2dVYVhHdEN6QkJxSHZsNTQzeEV2VjhP?=
 =?utf-8?B?eGdqUVR5T3hIOVN1cjYyYmNERmhib0tYTkRzRUl0QkJTWVlPZFYwZ01NRldW?=
 =?utf-8?B?VE81djdDQTNuOVlncXk2M1lCUmRPcnV5UVU2SDVRYU85dWdMakk3bG5oZkpD?=
 =?utf-8?B?Q2h4bWVmSlpsY2Q2b3ZyMUhwSUVySGd0QlFVMHhJazZWTFdsVzdRVm9NaEkz?=
 =?utf-8?B?QkkzelBQNTJabUxWVjNXUTBUc25mYnA1eEVRQ3NTNUNvMFpWWWRwWEZGenlR?=
 =?utf-8?B?ZVR2Tlc3d3RDVTh2RUdjUExTZjZhSVMwdXdqelAwNEMyeFh3UktGN2ljZUVz?=
 =?utf-8?B?Y21UNEovY1Q3SzJ5TitPcWMxRi9zeGFzTmt0VUNTeHdUd2M3OVcyYVJDeUdM?=
 =?utf-8?B?M1prRUpnb2l6dmFOUFAvUXJwemZGQW1YbjR6TWRSaGtoQ2d4TEhsOWxLTHVa?=
 =?utf-8?B?dWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1C4BE2AC48FC2428505F0DC45FF84EE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665aaf4b-1847-41f1-c366-08da9594d797
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 14:32:53.0467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: no++1b4STivhV20hzVimH45SrxA19lNLOiMIBBg5C8uDORxCWg8eskHDlzpfB3vQP3nj+V9ufDi2zljm6aUbuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7017
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBTZXAgMTMsIDIwMjIgYXQgMDU6MTQ6MTlQTSArMDMwMCwgQXLEsW7DpyDDnE5BTCB3
cm90ZToNCj4gT24gMTMuMDkuMjAyMiAxNjozMSwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiA+
IE9uIFR1ZSwgU2VwIDEzLCAyMDIyIGF0IDExOjIwOjA0QU0gKzAzMDAsIEFyxLFuw6cgw5xOQUwg
d3JvdGU6DQo+ID4gPiBJcyB0aGVyZSBhbHNvIGEgcGxhbiB0byByZW1vdmUgdGhpcyBmcm9tIGV2
ZXJ5IGRldmljZXRyZWUgb24gbWFpbmxpbmUgdGhhdA0KPiA+ID4gaGFzIGdvdCB0aGlzIHByb3Bl
cnR5IG9uIHRoZSBDUFUgcG9ydD8NCj4gPiA+IA0KPiA+ID4gSSdkIGxpa2UgdG8gZG8gdGhlIHNh
bWUgb24gdGhlIERUcyBvbiBPcGVuV3J0Lg0KPiA+IA0KPiA+IEkgZG9uJ3QgcmVhbGx5IGhhdmUg
dGhlIHRpbWUgdG8gc3BsaXQgcGF0Y2hlcyB0b3dhcmRzIGV2ZXJ5IGluZGl2aWR1YWwNCj4gPiBw
bGF0Zm9ybSBtYWludGFpbmVyIGFuZCBmb2xsb3cgdXAgd2l0aCB0aGVtIHVudGlsIHN1Y2ggcGF0
Y2hlcyB3b3VsZCBnZXQNCj4gPiBhY2NlcHRlZC4gSSB3b3VsZCBlbmNvdXJhZ2Ugc3VjaCBhbiBp
bml0aWF0aXZlIGNvbWluZyBmcm9tIHNvbWVib2R5IGVsc2UsDQo+ID4gdGhvdWdoLg0KPiANCj4g
VW5kZXJzdG9vZCwgSSB0aGluayBJIGNhbiBkZWFsIHdpdGggdGhpcy4NCj4gDQo+IEFyxLFuw6cN
Cg0KVGhhdCB3b3VsZCBiZSBncmVhdCwgdGhhbmtzIQ==
