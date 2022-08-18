Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD32598758
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343523AbiHRPZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242310AbiHRPZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:25:14 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10090.outbound.protection.outlook.com [40.107.1.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1540BFE85
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:25:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPuTFMuR9XTvIIiaoUzb3sbmECxnMsQ3FESlCN9WHxj4sNyRi1CUlClmGURibz2yq0i7rV3oTQrQqWC7Hkx4reM27RNXEDqtcthgYiW9hlPuxfMv6breKmkQusN/XpVC4sMM0MxmI67T6zmDbomyPYurFhgybxDgNVTOZmi4YalrpqlayBFGsIQWv/721H/OPCiTCAVoLtahHbCvx5QbqzKdA1okNw9gIhxL5M9QKymQ2lCgmmmPzEa2plclwT59bBijuTZHsa+cY8044d2+9T2+m7Mrgjn1AET/11rAD8UJHN2mny0XbtkWmsdzE45Ysuy2qIpyGbnVBOU6copfBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urrpQKGngsxy5xpkhnIL/sRwc41lV6Lm7Pox6e7JVYg=;
 b=XL/o6cD32/8IW6m+wqNl8lIjLF9ABhulKlxyFuzS/lb6FaJwYpJoU9Pviqn7F4+mSGjRjYPIoUslyrLm0Ym++IQO9hLcKfHzF6LufdMFDa4TfStey6w+44QZYhkJ6KduFbKSEBCeUgviu4zWm8Ha4vB4XD8mDUxYjPfF2GWHH4zMdsczyVia9xKUdhmrjXD5drXSBPK3zbKUe6MjeSNFFAhofhL9P7u+TpgUVF+Za+cq8IDeE5/IUNqTMqHKqWrfcs9jka+yALl2mFQ3ZIZrnn7ZZudO+s6YmJsnUlzbUxNHohnT+GhWrLOQ35fzmnwC+JEkjf5ukAu658v1NxwVsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urrpQKGngsxy5xpkhnIL/sRwc41lV6Lm7Pox6e7JVYg=;
 b=CW5/B1p2sowqiKxHHRU/dN++jYhHfDDdKabbfTS8NGVHpt22dAjPZjzecPGfAHX3JQN0wSt/3IkZAT+DWr6DvN8lwx7isDG+FqwWy4Y/6IgQrfz+OSalP5VMWq6q+mc84hXotbyoHd1pYQtCkYhi3o8lydRkwI+HPi2Q3IDfyfM=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by DB3PR0302MB9233.eurprd03.prod.outlook.com (2603:10a6:10:43f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 15:25:09 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e%7]) with mapi id 15.20.5482.016; Thu, 18 Aug 2022
 15:25:09 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Topic: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Index: AQHYsw9zHhN3dtpaN0uEx4R4ZuVmoa20wiIAgAADLQCAAAH3AA==
Date:   Thu, 18 Aug 2022 15:25:09 +0000
Message-ID: <20220818152508.enkl4dyywt3klqyq@bang-olufsen.dk>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
 <20220818150644.ic6pf5arbh34lr5z@bang-olufsen.dk>
 <20220818151806.yv5crkdab6tpkvph@skbuf>
In-Reply-To: <20220818151806.yv5crkdab6tpkvph@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e56a142d-bbcd-4808-7cb7-08da812dd638
x-ms-traffictypediagnostic: DB3PR0302MB9233:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: idjkAfSyPTQNgzCejzpUTYV/aLC0b1962U48tNK+UcGuC8AhbrXkaUAWN2Gh4jbLo/AxKbhkpvZ54bTkaHwii8qafsdoj9HBtFpnvd7r5XMlKzMIkbqaeaLvmenHImbQpLbmkpLrd3zKnIJ7GJ2ljAH8kkqKO+03WkEm0bwWueP0XJ2L6dMez2ZTstyUK9efzQ2/+yCz1njGNkkkhIVxHG7gVb6aA0qs0lp154KjPTYrc0WGWCuBHIS419Ex+id9u/QaXF3HJ125+UfFoODYlXaDI9kXE+nZEmdB1GRQueUzhKsXnsGGcV0NOEvhEQk2icAiPM0oimCP2zPPsu//5NCGv9EW39JgpukDflwutWxtGIS+eJ9DyOhjqLreNByK7AKL+oWRqYxpnJCN12QMBKBVCJC12z9rhYXPq+hrlco34OQDW7D7qbyXYCt95zvXxt7dPwToEYNh+4ikF1p3YVAMqvbsZOucBIY1mr7wwSuyiAFJdPWHdZtRatJI6gPFoO/E0hYEe4+yiCQ4UYT00m9I7ctlvNZCQMQHrEsMbkXxhMq+uDWzYeT3GQokvVxy9yZ9366+H91G0etAwu+a14VMuzlXrUPoqaAM2jpDqMiYhB/uRdztTeI1Ze9lSHD7zItqNBcpl5Ci1lcgByjeG9W2tn6ZzTCiO2eUTBso0cuAMLqk1amN6RTTM6rG6sC/WMil1fe+diKarxJxcsrombdV7L7G2pGO93KWtQzTbS0peX41VzM692nWIFYuIkK4ucb5E68U7+Asv465Safn8e93pxHgjZJwv/2o7ZC4SpY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39850400004)(366004)(346002)(396003)(136003)(376002)(86362001)(38100700002)(76116006)(66556008)(2616005)(91956017)(8676002)(66446008)(64756008)(316002)(66476007)(122000001)(4326008)(66946007)(6506007)(7416002)(966005)(38070700005)(6486002)(478600001)(5660300002)(8936002)(6512007)(26005)(8976002)(85182001)(1076003)(36756003)(41300700001)(71200400001)(186003)(6916009)(2906002)(85202003)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rk1SbjluQnNzb2JVZ01tQmh6M0VodGdwRlB4U3VKdjJZakY1YnZaU1dqOTE5?=
 =?utf-8?B?d1JCbVVaNU91dm9Hb3VkWHRwRTlxSXk4Z3NBNjVOREFQTUw2RDhZWWVDSHI2?=
 =?utf-8?B?eEdrVHJ4NWkrV09kREJVbENuZWtIc0w3SnNSTVBIWTVUNGxGQnRhckU3anh3?=
 =?utf-8?B?VGU0aTlKRTdUU1p0WDJHQUpHVXZxait0eUpRdXFBbmVHL1cvTnhWNXU0K2RB?=
 =?utf-8?B?cndDT1E5S1dKZkpOTGgxMWpYc1RQdUd1b0NtQ1U0ckxaYk16UWFmSDcySDRT?=
 =?utf-8?B?RnRxQ2RFRnZIM1NzaXA4MkJCU0M2U2dNVXBNZDRweG1DYWNleXN3OXdhTU5X?=
 =?utf-8?B?L1Fkd0w4U1R1YldsMEpkanQ2YjluRU9TaGx6WGM1UE1zS2czaXI4cFg0TWVM?=
 =?utf-8?B?Q1duaXVvazIvWitMQkxGOEE4VDNtQzlKU3YyM2pLRnExbDd1czlQeUM1Z0t5?=
 =?utf-8?B?Tzg0aWsrTWlLYzV3Mk81dDNQbDMrWGk1ZEJyVWZEeXBVZzRXNnZKckdtOFhz?=
 =?utf-8?B?N2F4dlFmSERCeGs1RmhwOGJBN01WWmlHUmE1YWpab1M4dkx2M0swYmhneHBv?=
 =?utf-8?B?cWhaZm5wVXRCbkFQNm45clR2RUM3WnhIM201Vi9tMUVaZWZUN3o5cjN6MnFa?=
 =?utf-8?B?RHVTdmFaaS8yRU14c0NvVXFvQ0c5L29OVk1Sa1RvQ2JsL0JYbDVVK2VNRGZ5?=
 =?utf-8?B?cVo4WnZKdWpKTVVYWVo0dVFDaUxLc1FaNyswdFVjQzE0eGsvME5ubUhscWQ4?=
 =?utf-8?B?ZnNBSHZwb0ROZVRiQkRYOEtCdDcyb2dyOFE2QW0yQTZTKzZnSWtXelhLKzNO?=
 =?utf-8?B?L2hQd09aR00vY1VPU3pvQXBwcnJ6OE1sWTF5QlpkclBZdHpiYUl3NFB5bnUr?=
 =?utf-8?B?MWVPbDFBeVFubzdWRlVHQ0FxWW5pQ1IyamZGNjF2VXNxZERXSDdDNGlGSVFv?=
 =?utf-8?B?N2FzY2p5Nm00Z0Fzalg2VThBekVLd1FUNFJkUkM0eDZKVDZ3aWdGMEVIRHVZ?=
 =?utf-8?B?anZ0d3BSVkkrYmpLYU1GYjdNYXMrNjArWjl1M0dGMU5mcTJOVW9NWmxjVFhN?=
 =?utf-8?B?RnAzWDRsck5rRGozbGlNWTRVSlNBMUpTdFRMWmhSZE5DeWNqWGdqQ3BWRlhs?=
 =?utf-8?B?Q1g2TUZvYldHc0JMVXBkZHZ6NUpWeEJKWFp5MUovVVFmeTZYZDBsNVkvaE4z?=
 =?utf-8?B?R0txR00xeERzL2hRS0FWSEo3RThqVUN2RXlaWGw0MnR5R0ZOS2ZkeVpPcFhG?=
 =?utf-8?B?ZnFKNnJNcDlCWno4RnNpL21tL0RLR3RyVmhvNHZUU1B1SGQxM1hpS2JWejYw?=
 =?utf-8?B?MHNkdHpqL0JVZTgzL3psc3MrQ1J4Tzd2RE8vWHYzSzFvb2QrbE8wNXhQak1s?=
 =?utf-8?B?UGZnSkVDWnlzdU9Db1IzYlIxRWI4dVNxWVdEeVhpRDNFVE9UYXBEVEdPUm9h?=
 =?utf-8?B?Z1ZkZDBHNVQvZ09oakFIV2UrVzA5Y0w4SkIyNU5nbENGaE53dVhXMHpyanJt?=
 =?utf-8?B?cFVmeEppM01rNzVvVEhmZjRFRktHNjVERUppUkUzVWNpZ0Zza2NYTkRZZTl0?=
 =?utf-8?B?Q1FuWWkvYVIzK2RjQUZ4RTZUT3ZLS2piMklIOXRLaUhBMk8vVG94dTJnQTZ0?=
 =?utf-8?B?WkxXRlpjK3ZRZjN2UXZtOXl4YkkxQ0lDTlZhTzZZTnhFY2FtSVE5aDJYRHA1?=
 =?utf-8?B?SUcrUnl5Y3JJVlRTZ04yaURDdkRLblljbTdieVdIOGdPaFpxUS9tWFkxbEN6?=
 =?utf-8?B?eHhQN3lmdEdMV2VadXkyb3ZPU0E1amxTSDc1dFlhVzJjNHg3UmVyaUp0N0FW?=
 =?utf-8?B?Z0U4c3o2MU1IUk1uSzh5MVBmNFAybmpSd2VIY2pDYVV2L1FzelZFWWJQSzJN?=
 =?utf-8?B?UlFqR214SXEwam10aEI1ckd2SjArOGlIWW9yQ2tvN2ZJQnlHN2F5a0loN2k5?=
 =?utf-8?B?OURQWEkxUFNXRGNmRXBNdEc4YTBKcmkzWWtCYW9iS2tiaytkK2QxaW1BTk5s?=
 =?utf-8?B?QTFTOUVHMi9DUzkyVXoyQkFJUGZkRXh3R1ZBa3BhQlFyZ1VmR1Z1RjJRWUxS?=
 =?utf-8?B?UEVuUWt4R2tlSlp5QzdRRU54cjNJZWtwdXpLZTBucFBKSmZsUU1VMjJHRWFj?=
 =?utf-8?B?bVNicTBiUnNtNFRJbnliVVRDTkhCVWx0N1JFUHBKMFFicjRJMWtMam11VU1W?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D960070C492314D9AA7787553F8B5A7@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e56a142d-bbcd-4808-7cb7-08da812dd638
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 15:25:09.3727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eF3pDfzDKhijlvCbMrbOircS+i/8SxjO2hhkb7qLVfeOtQi6jLbKo62VbMm1P07tdGHiecbRI/lKszdCk5TZ+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB9233
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBBdWcgMTgsIDIwMjIgYXQgMDY6MTg6MDZQTSArMDMwMCwgVmxhZGltaXIgT2x0ZWFu
IHdyb3RlOg0KPiBPbiBUaHUsIEF1ZyAxOCwgMjAyMiBhdCAwMzowNjo0NFBNICswMDAwLCBBbHZp
biDFoGlwcmFnYSB3cm90ZToNCj4gPiBSZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lA
YmFuZy1vbHVmc2VuLmRrPg0KPiANCj4gVGhhbmtzLg0KPiANCj4gPiBTb21lIHF1aWNrIGdyZXBw
aW5nIHNob3dzIGF0IGxlYXN0IGEgZmV3IG90aGVyIGRyaXZlcnMgd2hpY2ggZG8gbm90IHNldA0K
PiA+IFBIWV9JTlRFUkZBQ0VfTU9ERV9HTUlJIGZvciB0aGVpciBwb3J0cyB3aXRoIGludGVybmFs
IFBIWToNCj4gPiANCj4gPiAgICAgYmNtX3NmMg0KPiA+ICAgICBhcjkzMzEgKCopDQo+ID4gICAg
IGxhbnRpcV9nc3dpcA0KPiA+IA0KPiA+IFNob3VsZCB0aGVzZSBiZSAiZml4ZWQiIHRvbz8gT3Ig
b25seSBpZiBzb21lYm9keSByZXBvcnRzIGEgcmVncmVzc2lvbj8NCj4gPiANCj4gPiAoKikgSSBu
b3RlIHRoYXQgYXI5MzMxIG91Z2h0IG5vdCB0byByZWx5IG9uIERTQSB3b3JrYXJvdW5kcywgcGVy
IHlvdXINCj4gPiBvdGhlciBwYXRjaHNldCwgc28gSSB0aGVyZSBpcyBhY3R1YWxseSBubyBuZWVk
IHRvICJmaXgiIHRoYXQgb25lLCBzaW5jZQ0KPiA+IHRoZSBuZXcgdmFsaWRhdGlvbiB5b3UgYXJl
IGludHJvZHVjaW5nIHdpbGwgcmVxdWlyZSBhIHBoeS1tb2RlIHRvIGJlDQo+ID4gc3BlY2lmaWVk
IGZvciB0aG9zZSBzd2l0Y2hlcycgcG9ydHMgYW55d2F5Lg0KPiANCj4gTm90ZSB0aGF0IG15IHBh
dGNoIHNldCB3aGljaCB5b3UgYXJlIHRhbGtpbmcgYWJvdXQNCj4gaHR0cHM6Ly9wYXRjaHdvcmsu
a2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9jb3Zlci8yMDIyMDgxODExNTUwMC4yNTkyNTc4
LTEtdmxhZGltaXIub2x0ZWFuQG54cC5jb20vDQo+IG9ubHkgZW5mb3JjZXMgcGh5LW1vZGUgcHJl
c2VuY2UgZm9yIENQVSBhbmQgRFNBIHBvcnRzLiBXaGVyZWFzIGludGVybmFsDQo+IFBIWXMgYXJl
IG1vcmUgdHlwaWNhbCBvbiB1c2VyIHBvcnRzLiBTbyB0aGUgcHJvYmxlbSBpcyBlcXVhbGx5DQo+
IGFwcGxpY2FibGUgdG8gYXI5MzMxLCBhcyBsb25nIGFzIGl0IHdvbid0IHNwZWNpZnkgYSBwaHkt
bW9kZSBidXQgcmVseSBvbg0KPiBEU0EncyBhc3N1bXB0aW9uIHRoYXQgdXNlciBwb3J0cyB3aXRo
IGxhY2tpbmcgRFQgZGVzY3JpcHRpb25zIHdhbnQgdG8NCj4gY29ubmVjdCB0byBhbiBpbnRlcm5h
bCBQSFkuDQoNClRoYW5rcyBmb3IgdGhlIGNsYXJpZmljYXRpb24uDQoNCj4gDQo+IElESywgaWYg
SSBoYWQgaW5maW5pdGUgdGltZSBJJ2QgZ28gZml4IGV2ZXJ5IGRyaXZlci4gSSBkb24ndCBrbm93
IHdoeQ0KPiBzb21lIGhhdmUgR01JSSBhbmQgc29tZSBkb24ndCwgYW5kIEknbSBub3QgZXhhY3Rs
eSBrZWVuIHRvIGdvIHN0dWR5DQo+IGV2ZXJ5IGRyaXZlcidzIHN1YnRsZXRpZXMgdW5sZXNzIGEg
cHJvYmxlbSBpcyByZXBvcnRlZC4NCg0KWWVzLCBmYWlyIGVub3VnaCENCg0KS2luZCByZWdhcmRz
LA0KQWx2aW4=
