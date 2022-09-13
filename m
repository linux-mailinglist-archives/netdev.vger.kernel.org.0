Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EA45B6E64
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 15:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiIMNb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 09:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiIMNb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 09:31:27 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2050.outbound.protection.outlook.com [40.107.21.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5541B78B;
        Tue, 13 Sep 2022 06:31:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYuHjznnzA+pwxfGZvI3PLI12tO78mJTsbYrYR3t1v2UrkJcUODrgo+JG08sy6Er5e6hGne6NiNVO9qrQ3yhWg6qpUVnioTMxJJ8yJQztherAiqglB/cF1MEBb+lAvPtebTeW/kNX4VZ8PcZvWsWYO3dz0UhXzHCAyyk+XwOm4Z6IwQY4mxdWx/bQJ0ja9YWk0jsImw5RXHGgNVrKs5McKbVfz7TcPTl985XphqEwR0d6wT+z67aDSbxBNtaBrjJdpvwlq9XhfdRgCOrMWQkitcHNCCoSu0flnVx3t78r19rHY3YgVRxRSJuhjC1QEzHlp3FZqx6SAuCQ2gnfF0LBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZvLcNIa9VdXhUsxczkDEsL2pEtvVPsobP9yoX/qDLU=;
 b=N7lLcc9A06zVcTZSTrA2l/UONjVZAVpKW/qacGzbZTkG5PR9qSbvsPMcC/ufiUtZg9Qk2C1KtFuD+PH1zhQFWHC4pIAHcz/qXBtgPJn3TpagyUzvKpUZQWNo8ujrtsqi7QUHaM4UhvWaOJjghFB1ICeQJk4ASwg3Rsl5hDJq0kkrMSVQrq7WcUT6tO4xuL2NIiEbhbFXrxpl8PLFtnz25LvHsOuO7w/aZLfVhBBSMFC5+D+IcjLZVErOpLHK2pXNB23DJrA9pcxWD6VX5ZeceO5NPm2QjjY8hm6S5x6sxyvjcYpjx00/rqQ4gxf5AyecQnU9CxtJM/gtAsrigK7MJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZvLcNIa9VdXhUsxczkDEsL2pEtvVPsobP9yoX/qDLU=;
 b=ffd7OTiM0G4NVuMyCg+yXVCM21rMo370V25g+Wa53It7BrYW0DY58uHvnw+cwMBBAH4BB8wZBxMF+JdV/ov8qMR26paX+5gQaZHhuh2jNTtePgqhlKUVYDQ0Cp6juDz9RF9DEQ23h1qqmRIs48sroku2IZ1aSA1JA5PK3UgUZFI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9150.eurprd04.prod.outlook.com (2603:10a6:150:25::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 13:31:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 13:31:22 +0000
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
Thread-Index: AQHYxtBCZhrlfLn9yUSG8exS6G8zpK3dBZ8AgABW+gA=
Date:   Tue, 13 Sep 2022 13:31:22 +0000
Message-ID: <20220913133122.gzs2uhuk626eazee@skbuf>
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-4-vladimir.oltean@nxp.com>
 <b11e86c6-ff35-2103-cebe-ebe5f737d9de@arinc9.com>
In-Reply-To: <b11e86c6-ff35-2103-cebe-ebe5f737d9de@arinc9.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|GV1PR04MB9150:EE_
x-ms-office365-filtering-correlation-id: 4060d515-7ae9-4190-f921-08da958c4009
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6GUCwnowrWRLij396NIUbhWmCyZFr8e6NHLYgxiEpjW8JZ+cMTQxXGR5/XRL25owF4thzSWXT8+UeVo2w9Ig6UWyEws+k5iT12YHTpCXoyKP8eJWgVeZjX8FOyKpJdMc5g8j3gikaCGLwjzNz0HxJbAk0QRr2RPTXCp+a0ctt8uD/yxwelVnLVQ+TF8lsnxxmaofeTkPxGplBC29XHAHiR1y1FAFHQ9yibC7bGUlDe+ZDtO++T97lim/ie72VOQ6QpKyHj46jkeq/GXI79qs/QeQRqbOsNMDJo7pwz/a5lu6lwhVAK8W/GJAbC6SH7aFT7T4Gx6wWALU8yABdvJrrjH5BXgP6G26LmKYCfHzzrFf4VJ7b3rI94Zouzs8C/QKorQtMiLWbO9bL+Otw6xz20v+L8YAjS7Ox4/Ko48oYJAj4gs/I5iID2SSqMIb2KkbVQCWYbiorjT0O4NM7xK40bcOkUYyD59dDbLzFukkd6BMRo9gl3psTn4AKB27kCMRz3wVLPDMsbw+fSBMhYAYp/Api7/iWoJj1+563ZGtWgwxOw2An2S26m0xaYjKG8kZ0QOU9Lgp2UhWxjuPQDhwixvqySmSjU541tUqHgnoxnmeXkNHBYslvBS8AFLFJXKmY+pzEtKigx+UVaSKSK9d00uVX1arCzbraVv4HBeNvLzo68Ud0otQujP7p7/utTRN8n8YK7jfWRDO+4+PsJboeNdUGmVeZVI5EQMZv/aNv/EhbKont71v0HKdKUXdvPpbKt24WREsUG6QSroy9LBAJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199015)(33716001)(66946007)(122000001)(91956017)(8676002)(7406005)(66446008)(186003)(66476007)(64756008)(5660300002)(478600001)(1076003)(38070700005)(66556008)(54906003)(44832011)(38100700002)(7416002)(86362001)(8936002)(4744005)(26005)(41300700001)(6512007)(6916009)(6486002)(6506007)(316002)(4326008)(71200400001)(2906002)(76116006)(83380400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnJhMGk3TzdPdTNITitkQTczUXNQRFBpSFN1SVJzSEpEeGZFKy8wTEg1M1J6?=
 =?utf-8?B?TDVNVTgxZy9PL243VDVEanZtUnhHWTd4R3ROa2JLUGZrTUcyMEZJeEl1U2pL?=
 =?utf-8?B?ZkhxU1RuRERLTG5lY1FhV0Z5MS8vS01DWnluUGZVN1YzOFMwVVBWOXZDeDB6?=
 =?utf-8?B?MDc0SnpSV1BydUE4SFJvb0UwRW8wWEpGQzlyVUZzdFBJa3hTL2JIMXovdFFZ?=
 =?utf-8?B?dEFCb2VwOURwUXM4OTJ1RXdpajJMMWQwczllOFhIaHZ6NXJSdUtqZTR5TS9r?=
 =?utf-8?B?cWFWTFY1UkE2RjRydEV0KzY0aWpWbk5YczZGbWdyOXQxdmhsQ3FkMEdHUEEx?=
 =?utf-8?B?MDdUSjQ3N25acHo4MTBuTWRwMHgwZ1NnbzVrSkRhNmQ2Zk9MYnRxMkJWQ0hZ?=
 =?utf-8?B?NGhOOE1MVzRnWkoyaGZxQnJKdi9SZWJGZVlBWThCR2ZBTUhoUHJPajFXcXZJ?=
 =?utf-8?B?WXUyVWcwWFpRZVpzOHVnNWZVWFEwUHBLL1EybFZFRklaZVRYNy81L3QzdTdW?=
 =?utf-8?B?NWNlY0EvQmxIY2xRWm9aZFJHTm05OGhLY2lqWUJDeEoxaGQzUXdjaWROUXBZ?=
 =?utf-8?B?dWxGbFlWaWcvNHlHaWg4MWxuL2FmUUFBZXJuSWVsdURCSU1YSEEyb2o2S2cv?=
 =?utf-8?B?Qmh4VEF5Q0NtRGJmdVZpdTNSM1FXRC9MV05RMjMvajBxOEhiR3pjWDdpaEJM?=
 =?utf-8?B?RXdRTmI4eDdQTXpMM2x2TUoxRFVEU2hiazhNUHR0RGllL1RqR0J6MFB3SEhJ?=
 =?utf-8?B?L29SMmI0NkhzcDMyWmtiRFJGTnVXTXc3SE5KajBrbDVKUCtWcG5OeGZ4YVd2?=
 =?utf-8?B?eWFXQ3dCN1RQY1JHNFkvV2wxOGl5SjJucklLczBoYUNNbVJvVkY1c00rSkR6?=
 =?utf-8?B?YUdVNEdjU0krcEF0aS8zZlRpWVgzdFJDUnI3aEVabXpoVnN4VERiWGZIdFJs?=
 =?utf-8?B?QWQwNHptR2pMWXRFRTZqdlJnN0VUcEJndTVFenBuKy9lNTJsdEhwd0dOV2dx?=
 =?utf-8?B?VFpIWUN4NWRhdGF6VS9lN0V4UW1OUXUxb3ErRjd0a0swaFF3SFlPOWFycjRU?=
 =?utf-8?B?VVVoQkhnK2RTWEJ6Vk02S1lqeWp2MGt5Y0o1N01CSm5ibzk5THJzcWJONTNF?=
 =?utf-8?B?dy9OVVprbEJySnVnTU1qWkJJaHUrUmtjc1V2cUVlMG94aGhCMEpnSVVodmtG?=
 =?utf-8?B?ZnJ2MWNqM0RNWjQvYXVvaU14bFRoUnNQbkpleUxUV1pDdnJhN0ZLV1JRRUhT?=
 =?utf-8?B?ZkpMdHBhYklQb0JVQytkNE5HYUxIUDV2YlFSUUxyVDMrOFIwQndDcS9DeG5K?=
 =?utf-8?B?SkNVTi9WdUNOTlJYV1lPaXdYTEZJV2swU0c3bzgrb3J5eDc5K1hBc3MrbTRQ?=
 =?utf-8?B?U0MrRzVLOUR6VUh4dnNta2Mvb1hYcGNUODc3bmRFVUxqS1c1c0g5MFloeUpk?=
 =?utf-8?B?R3ZrbGpWbXdCWGNKQzhsM2JKQVdZU0M4RklDcVBJckcva1pvOUlVbUIxTHY4?=
 =?utf-8?B?QndGN25pMWRyMUpSQ2lVamxJQmR4UzljU3Y2VUwrQ2V6cWxsZ1VnSjJ2Wjd5?=
 =?utf-8?B?SXkwallQR3hnckpJVEZvYlREamdybVBrMWY0T1hTK0w2ZVhRaHFEQVFDUXJC?=
 =?utf-8?B?RGo4Qkxqd1huV3ZlNmYzNk5KYXh0NW5pdzYvQTV3ejY4SG56a2N3N1ZYVDdi?=
 =?utf-8?B?MnhmM25ULzYrRkxEMHNDMCs0eG4wWCtIU1N1NmYzcUVaWExlbmgwOTk1a3ZD?=
 =?utf-8?B?aSt3Kys0L3dvV1U4azgzT0RobkpkNU1hMHZOcjNRM0M0YzRMR3U3REJhZ2dX?=
 =?utf-8?B?VFRuWFdXWEN6ODFUUUVpQW4zcmhYNktmczlvbzZseVNvczVRZE8xcHdPZW5B?=
 =?utf-8?B?UnQzMlFpMVcvRDV1TUliWkxpQjNmdDIvbnd2NkM1TkpDeEpTNUdldmF0aWly?=
 =?utf-8?B?dTBuOHpIZEErWS9PdWZFL3JFTlhjV1FFdUtFNndoRzVwa3B0YUhIVEE2Qkw3?=
 =?utf-8?B?Nk4yTm5aT1VPck41MXpMOVl6MnMxV1E1UVBwTUNSMk1pdURJQmw4amoyWFov?=
 =?utf-8?B?UDBGb3Zjbk5ETE9qSWtrVXoyTUlqU3kvZzV3eHdxcEpGcmt1OWY0S0tZQitM?=
 =?utf-8?B?TlM4eENabWRCOExtK0xVckRNVjFUNEs1a0J5d0lsQ3BHVVFPamorNzd5ZFAw?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC7BC06195C1264BB75F9F5C71D9BCC2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4060d515-7ae9-4190-f921-08da958c4009
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 13:31:22.8233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ChRUK3U66oGz853Sh55iDtYPbDy7184ZCZ2GLMGuWxgbzNH4/QjYDNGsHJxv+5FKYHsBx98tOj/Cizr3gRjXiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9150
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBTZXAgMTMsIDIwMjIgYXQgMTE6MjA6MDRBTSArMDMwMCwgQXLEsW7DpyDDnE5BTCB3
cm90ZToNCj4gSXMgdGhlcmUgYWxzbyBhIHBsYW4gdG8gcmVtb3ZlIHRoaXMgZnJvbSBldmVyeSBk
ZXZpY2V0cmVlIG9uIG1haW5saW5lIHRoYXQNCj4gaGFzIGdvdCB0aGlzIHByb3BlcnR5IG9uIHRo
ZSBDUFUgcG9ydD8NCj4gDQo+IEknZCBsaWtlIHRvIGRvIHRoZSBzYW1lIG9uIHRoZSBEVHMgb24g
T3BlbldydC4NCg0KSSBkb24ndCByZWFsbHkgaGF2ZSB0aGUgdGltZSB0byBzcGxpdCBwYXRjaGVz
IHRvd2FyZHMgZXZlcnkgaW5kaXZpZHVhbA0KcGxhdGZvcm0gbWFpbnRhaW5lciBhbmQgZm9sbG93
IHVwIHdpdGggdGhlbSB1bnRpbCBzdWNoIHBhdGNoZXMgd291bGQgZ2V0DQphY2NlcHRlZC4gSSB3
b3VsZCBlbmNvdXJhZ2Ugc3VjaCBhbiBpbml0aWF0aXZlIGNvbWluZyBmcm9tIHNvbWVib2R5IGVs
c2UsDQp0aG91Z2gu
