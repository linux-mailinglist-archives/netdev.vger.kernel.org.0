Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B7B4CBEB0
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 14:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiCCNTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 08:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiCCNTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 08:19:10 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85F4148906
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 05:18:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdpGdh4u9pUzjMTfUrLodB6GI2fxdvIFbx3uA/fcjlrnxoluUxGQHcdTpQZUpq8nl68sCnrQVj8e/6kGG2V9c05WGaNCijtEvCq0CriVo+NaqFnVwrk6Tl+kvRGJGk9wg+NarDMNxf/mewd2CTptQtZDChJnJp08yWxxrY3VSI0v7SeEf8bxEgtqjkCD4Oq7tr2oHOYRFFr29zGpUwRPuQHhX19Yefj75hduPuiyYS/hyobptDwdPRN32BPzsEvVTOBYu9CmE624N2apqSdAFNYHUoxu7ApBMp1BaU0emB4veeoIiUDAARHNNZD1YUctJZVk8X1Z8VsB7JlO3pwUng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wr94P/X0khm9CnSlbPwIFTJiRie8N3t5vTaOllSiDww=;
 b=ekD0T3bRF/mmDfL+0RKvHyAJwB9Forcac2RAcoWrXlAKlnYixWjlMfeYXNZ9lEBHU/SNlcO/KoesfNGfBU7iXuMmYdNk2S9lgAhgc13cq/AZYlK2fiksqLwLqJOODwUm+D3cYVet5LhlqAAZFOhJZoZXN/Uv4lletPXlp504YrHKc/qvtmBwHJVBSv5Ywoz7pMQgSfB6Zsdbo4jNfmVk+UiZ/3m4vrjgGivGKDGCvrC3gpUiIj5N1xLANzSvlwBdcgnbRmqp/iUUvJ5caGfD+2Jv28f38+2EtgNq6GLdEf/ddd0iThAcscZZMhV5QZ4/Tw7voljPjxcoH3zf+mLPgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr94P/X0khm9CnSlbPwIFTJiRie8N3t5vTaOllSiDww=;
 b=HJGSNgNpEw0bBQozan8H+eWsxQT/CDWCLuiv6EOjxtCoWezPvgAjjFPq+wWZDZMLHI4wGQtrOVbB7zsEbLYGCWQ/HeMR7z7DN2ijEduRWXWLRXgl2ji+sl8bOBweSIs0Qd+/Sd8TRlQ2DJ2XylwwtVF9e09cS24xGGc+kIWZRUM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8022.eurprd04.prod.outlook.com (2603:10a6:20b:28a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 3 Mar
 2022 13:18:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 13:18:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?QWx2aW4g4pS8w6FpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 00/10] DSA unicast filtering
Thread-Topic: [PATCH net-next 00/10] DSA unicast filtering
Thread-Index: AQHYLmnKbqJ8uFqvo0eudldhc5/zKaytpXoA
Date:   Thu, 3 Mar 2022 13:18:21 +0000
Message-ID: <20220303131820.4qzrcrdtx7tlhaei@skbuf>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
 <87wnhbdyee.fsf@bang-olufsen.dk>
In-Reply-To: <87wnhbdyee.fsf@bang-olufsen.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e6a8bea-0218-48e5-480e-08d9fd184a0f
x-ms-traffictypediagnostic: AS8PR04MB8022:EE_
x-microsoft-antispam-prvs: <AS8PR04MB802279005B8E6B50363C6AFAE0049@AS8PR04MB8022.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yEi5uLf7uZ3ESz2jrsPKeTEWflEcfLLzpg86droakxqi1ltbz7/uFc5bbsUSW4+18/5pYfeRa47iKhrzTs/zfScf5tW+BkIuC1qqJQuE4HXdaGH/8yfX8nSGUHcjTubJuE8YrIiylIQNF6qz3czyuOLIuzBiFsnJB3xuoVw0fUh8qUfIgUcQk5VhOGFXTjtCgQc+ZipQ5cI03TdH67pHOumEy7uHf5KI2VU2JA1oDdoNynnDHEtQmnBWd6mZWlc1nlmE9t7D+grFXAPVeHc2D9B5//inQv8QZmEe8NzBfc2PNYPR6ja94DP7SNFRwboqiYqoY9sCi9R3y/KsHAmqxSzxoahkQnExMDK0uk+OTHhK8d/NW9HuO00hUlKyk+zDJH2XFRu7Ocah/QWcwhyx3e1lQ9tru1BG8aIINp2aX9gfNIUC8MPkjHSS0a6vbz66ToTcNma3MElbihQz7UDhI/nENM1KHnEtleuwd5Q0+seTIDpf5L4KjLJRsTszc1JiI9JLCSP196/cObY1YauvELshTrIqwG6E7Gwn3WssqUzc16YhpIo55fJXVQ4huvpFAHLxm0C1lqrGmHpzMuS+EEhH2rYWGwyDX7g2/cWI25U77sgSJw7qvwlQtIRD3Bqy5bpHApB1tadlWn14fC3dMI637lSvUeQxXXAE7BG0QBlWH/gHoJFByDbhaJe4F7qCJhu8q+bvA+Z0n9p+r4f5nQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(9686003)(6512007)(38070700005)(2906002)(508600001)(8676002)(4326008)(64756008)(66446008)(66556008)(76116006)(66946007)(66476007)(26005)(186003)(8936002)(5660300002)(7416002)(6506007)(1076003)(44832011)(83380400001)(316002)(71200400001)(86362001)(54906003)(6916009)(38100700002)(33716001)(122000001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3NxQkFpbHRvamlweFRVQWR6TTcyaUZmUWZmRW9wZEwwWVZRaDA0NEJ3U296?=
 =?utf-8?B?VVdpcGVQL1FZMzRBWWFRd21sS0dPNElUSnhDeXJCaE5ValNuS1IrY09WLzF0?=
 =?utf-8?B?Y2NIZzQyR1o4cTByZ3NzaFd5U1R6cFZpMzhvYVVVVXpmcHVTdVE3bFN5M0xC?=
 =?utf-8?B?V0ZIMjQ5VGFpOXpjUGNuRFB3QWc3eWF1ZE5PaEdMSWJYNUNyY0dqR3E0NWFi?=
 =?utf-8?B?bmlxSkJjaEdhSjBHMzFsQlU2V1lOejFpSmRlc0JYamNVUGVmblM1WC9hRHox?=
 =?utf-8?B?RVMvK3ZVcEw0S1JyUXF3dUJXY0dDTVh5ZmF3L29sbE1UZTBBQlVtRzFldWZm?=
 =?utf-8?B?Q2hpSDRTRFBnTWdUZktRbjY5NkxpeGhFZUpQWFVrVFdKQVlyZ08rY3VXaC8z?=
 =?utf-8?B?SWZHYmxWL1hMUjJrdjg2WUJ1WFBHdlI3aVhXVkVVYmVRVDdKelBHNFJXMUtM?=
 =?utf-8?B?b1UvYWlMeW82UWZUMStqaFFXTkZZdTEvUWtJWjhWVWk2c2RFdVJqZklPbkhS?=
 =?utf-8?B?TUVjWmh4SDdpTFI1Yy91aTJZMVVBcWF5Q01kbWVBbVdIMEY4a2h2OUU4R1B1?=
 =?utf-8?B?TGx0VVBYdS9XM3c3YnJjTDNrcUVlcWdUdDR6MmFUYTFoR1AxUXVGRGR0a2Vk?=
 =?utf-8?B?SjRRSytmL2ZhK3hKTEFBZ09jUmJYN2VwOTZKQ2hyNlJ4S0tMVkwzVFJDekRs?=
 =?utf-8?B?STJTZ3VaRFdIUmY2bFg5TGZRRmZGVU1KZVBQbXo4eS9obzRrRW9weXo3WlNk?=
 =?utf-8?B?SlMwcGNydVdXdUJjVVJRL3dDeE4vSnBEZHNqYk9IcUsvbFdVUnFKU3NNV0h2?=
 =?utf-8?B?YlhaMVY3QzlUd1JYMjA0dGZHbnhCVENTamEvYVFvMGdwcG0wcDhPOW16bE16?=
 =?utf-8?B?VmRRZU44c2hYZDZHLzhkWG10TzE4VzU4dlpXUVQ4MGlJQUxZazI2NGJhQ2V3?=
 =?utf-8?B?TGFqSzhCZVRWQ29UY0F0bjBUblZnTGR6WFNrY2dYNXFtU1g5bGpxUWpmUWlN?=
 =?utf-8?B?SFBiVHd4UVVoMkhwckN4czhYbnpaakRmeVkvaERnUklYcEp0a1A0OXFmcldC?=
 =?utf-8?B?bnJCcFFXT0h6cWlxNFBtNFdPMy9PS1hDQzVWZlBFY3JBMDhwejkvaWoxUGVr?=
 =?utf-8?B?Vjk0V2p6SmZIblJHT25wMjlBK0owZXlCUkdPREFYWlBGeCtPUHRHUHNZSnhi?=
 =?utf-8?B?UHExSWIvcCtBR2VIY0RXSE5oMHdKd1BlNnpzMHVaRHdFRWxvNmh4amZNai9z?=
 =?utf-8?B?b044VENzRWkybW5KZ0h3VE9kQklDWGhCaFd5U3B6MjVCK1czM0pOcTgyaVJ2?=
 =?utf-8?B?MWg2VzBBcXhwbFBRS0FBMWNZOEdQL3JTQ253S3I1YXhrNUEvZkhUbzUvUmVG?=
 =?utf-8?B?MFJNQ1FrM1BtS0JZY3F1RWw4Qit0SjR6ZFlBK1FkT1dndjVzc1dvY0pkZTN0?=
 =?utf-8?B?bFdSenFjNUtkdk5XQkNoZGdmeDlFbUFyMzMwK3V6VjdaZXpYNmNoT0JUcWpZ?=
 =?utf-8?B?bUR4Qnh0Vkk1dlVzNnp3VXdJc0Q0b29QWkZydmRqbUMwMDJkRG0reHdUU0Fs?=
 =?utf-8?B?aXVQaW5FQTg1WGFhb0dnai9LSzhORlpJc3pXWm9tL2tGWTVpT1V3RURmNmNJ?=
 =?utf-8?B?MnZyVmltNHdubk9Odmx1VE9NMUUwaTl3Yk9HK0czQlRTeEhhYnlyb2xiUGYw?=
 =?utf-8?B?Qkt6Ti95Vit3UkVncUl6dHlXMXE5TVBmcEd4amNucWVSeWRQUExYVHdJenA2?=
 =?utf-8?B?QTRiazFxTHpwUjUzbkc5TnA2RlY5NGFSb3RicFBKMDFENlJjaHJ1RHBaWFdB?=
 =?utf-8?B?aU8vQ1Y0ajZ3MTJsMlMwKzVnd3FvWVJXL2hCeWlTU2s4RnJVZDlvOTJST3dO?=
 =?utf-8?B?RDN2Q213N2RIUVZYVVhFUkd2YzZCVE14ZVBMMUlpVERQRE5QbnBWbHVybjdK?=
 =?utf-8?B?YWdRd3lySEZnZHcvVXRRMjlwbVI4dnJJcmxDUVJvODRaYWRCeFJ0QzlrelpY?=
 =?utf-8?B?VTRIL3RzV3hEZVZZMHE1MHd1N3pNQm1iZUY4S3B0UTVmQS9HbHpDQXJCRlJ3?=
 =?utf-8?B?Zk9hOXlna2VOT3dVd3dZSW9JUy95eU5BREphWk55d0xhZGphZlJkZWlUb1Er?=
 =?utf-8?B?MzEwb0RoejB0Rm5iblRha1dLVitNY1F4QU1xVG9rck43RE51RjdjZXRjcHdH?=
 =?utf-8?Q?VA7KC9xNl6zC6Pm6KpTfpAk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E222ADA134CBD4BAFD68374A0D6B971@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6a8bea-0218-48e5-480e-08d9fd184a0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2022 13:18:21.1631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T1eaEceY4tZyjhgvlxR9dOEkTBWpNfnFek/K/95hHEE1WdqfSDEXPGX1Xv5rY6nY9UuJDKcoAGARxKIUr+zU3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8022
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWx2aW4sDQoNCk9uIFRodSwgTWFyIDAzLCAyMDIyIGF0IDEyOjE2OjI2UE0gKzAwMDAsIEFs
dmluIOKUvMOhaXByYWdhIHdyb3RlOg0KPiBIaSBWbGFkaW1pciwNCj4gDQo+IFZsYWRpbWlyIE9s
dGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+IHdyaXRlczoNCj4gDQo+ID4gVGhpcyBzZXJp
ZXMgZG9lc24ndCBhdHRlbXB0IGFueXRoaW5nIGV4dHJlbWVseSBicmF2ZSwgaXQganVzdCBjaGFu
Z2VzDQo+ID4gdGhlIHdheSBpbiB3aGljaCBzdGFuZGFsb25lIHBvcnRzIHdoaWNoIHN1cHBvcnQg
RkRCIGlzb2xhdGlvbiB3b3JrLg0KPiA+DQo+ID4gVXAgdW50aWwgbm93LCBEU0EgaGFzIHJlY29t
bWVuZGVkIHRoYXQgc3dpdGNoIGRyaXZlcnMgY29uZmlndXJlDQo+ID4gc3RhbmRhbG9uZSBwb3J0
cyBpbiBhIHNlcGFyYXRlIFZJRC9GSUQgd2l0aCBsZWFybmluZyBkaXNhYmxlZCwgYW5kIHdpdGgN
Cj4gPiB0aGUgQ1BVIHBvcnQgYXMgdGhlIG9ubHkgZGVzdGluYXRpb24sIHJlYWNoZWQgdHJpdmlh
bGx5IHZpYSBmbG9vZGluZy4NCj4gPiBUaGF0IHdvcmtzLCBleGNlcHQgdGhhdCBzdGFuZGFsb25l
IHBvcnRzIHdpbGwgZGVsaXZlciBhbGwgcGFja2V0cyB0byB0aGUNCj4gPiBDUFUuIFdlIGNhbiBs
ZXZlcmFnZSB0aGUgaGFyZHdhcmUgRkRCIGFzIGEgTUFDIERBIGZpbHRlciwgYW5kIGRpc2FibGUN
Cj4gPiBmbG9vZGluZyB0b3dhcmRzIHRoZSBDUFUgcG9ydCwgdG8gZm9yY2UgdGhlIGRyb3BwaW5n
IG9mIHBhY2tldHMgd2l0aA0KPiA+IHVua25vd24gTUFDIERBLg0KPiA+DQo+ID4gV2UgaGFuZGxl
IHBvcnQgcHJvbWlzY3VpdHkgYnkgcmUtZW5hYmxpbmcgZmxvb2RpbmcgdG93YXJkcyB0aGUgQ1BV
IHBvcnQuDQo+ID4gVGhpcyBpcyByZWxldmFudCBiZWNhdXNlIHRoZSBicmlkZ2UgcHV0cyBpdHMg
YXV0b21hdGljIChsZWFybmluZyArDQo+ID4gZmxvb2RpbmcpIHBvcnRzIGluIHByb21pc2N1b3Vz
IG1vZGUsIGFuZCB0aGlzIG1ha2VzIHNvbWUgdGhpbmdzIHdvcmsNCj4gPiBhdXRvbWFnaWNhbGx5
LCBsaWtlIGZvciBleGFtcGxlIGJyaWRnaW5nIHdpdGggYSBmb3JlaWduIGludGVyZmFjZS4NCj4g
PiBXZSBkb24ndCBkZWx2ZSB5ZXQgaW50byB0aGUgdGVycml0b3J5IG9mIG1hbmFnaW5nIENQVSBm
bG9vZGluZyBtb3JlDQo+ID4gYWdncmVzc2l2ZWx5IHdoaWxlIHVuZGVyIGEgYnJpZGdlLg0KPiA+
DQo+ID4gVGhlIG9ubHkgc3dpdGNoIGRyaXZlciB0aGF0IGJlbmVmaXRzIGZyb20gdGhpcyB3b3Jr
IHJpZ2h0IG5vdyBpcyB0aGUNCj4gPiBOWFAgTFMxMDI4QSBzd2l0Y2ggKGZlbGl4KS4gVGhlIG90
aGVycyBuZWVkIHRvIGltcGxlbWVudCBGREIgaXNvbGF0aW9uDQo+ID4gZmlyc3QsIGJlZm9yZSBE
U0EgaXMgZ29pbmcgdG8gaW5zdGFsbCBlbnRyaWVzIHRvIHRoZSBwb3J0J3Mgc3RhbmRhbG9uZQ0K
PiA+IGRhdGFiYXNlLiBPdGhlcndpc2UsIHRoZXNlIGVudHJpZXMgbWlnaHQgY29sbGlkZSB3aXRo
IGJyaWRnZSBGREIvTURCDQo+ID4gZW50cmllcy4NCj4gPg0KPiA+IFRoaXMgd29yayB3YXMgZG9u
ZSBtYWlubHkgdG8gaGF2ZSBhbGwgdGhlIHJlcXVpcmVkIGZlYXR1cmVzIGluIHBsYWNlDQo+ID4g
YmVmb3JlIHNvbWVib2R5IHN0YXJ0cyBzZXJpb3VzbHkgYXJjaGl0ZWN0aW5nIERTQSBzdXBwb3J0
IGZvciBtdWx0aXBsZQ0KPiA+IENQVSBwb3J0cy4gT3RoZXJ3aXNlIGl0IGlzIG11Y2ggbW9yZSBk
aWZmaWN1bHQgdG8gYm9sdCB0aGVzZSBmZWF0dXJlcyBvbg0KPiA+IHRvcCBvZiBtdWx0aXBsZSBD
UFUgcG9ydHMuDQo+IA0KPiBTbywgcHJldmlvdXNseSBGREIgZW50cmllcyB3ZXJlIG9ubHkgaW5z
dGFsbGVkIG9uIGJyaWRnZWQgcG9ydHMuIE5vdyB5b3UNCj4gYWxzbyB3YW50IHRvIGluc3RhbGwg
RkRCIGVudHJpZXMgb24gc3RhbmRhbG9uZSBwb3J0cyBzbyB0aGF0IGZsb29kaW5nDQo+IGNhbiBi
ZSBkaXNhYmxlZCBvbiBzdGFuZGFsb25lIHBvcnRzIGZvciB0aGUgcmVhc29ucyBzdGF0ZWQgaW4g
eW91ciBjb3Zlcg0KPiBsZXR0ZXIuDQoNCk5vdCAib24gc3RhbmRhbG9uZSBwb3J0cyIsIGJ1dCBv
biB0aGUgQ1BVIHBvcnRzLCBmb3IgdGhlIHN0YW5kYWxvbmUNCnBvcnRzJyBhZGRyZXNzZXMuIE90
aGVyd2lzZSwgeWVzLg0KDQo+IFRvIGltcGxlbWVudCBGREIgaXNvbGF0aW9uIGluIGEgRFNBIGRy
aXZlciwgYSB0eXBpY2FsIGFwcHJvYWNoIG1pZ2h0IGJlDQo+IHRvIHVzZSBhIGZpbHRlciBJRCAo
RklEKSBmb3IgdGhlIEZEQiBlbnRyaWVzIHRoYXQgaXMgdW5pcXVlIHBlcg0KPiBicmlkZ2UuIFRo
YXQgaXMsIHNpbmNlIEZEQiBlbnRyaWVzIHdlcmUgb25seSBhZGRlZCBvbiBicmlkZ2VkIHBvcnRz
DQo+ICh0aHJvdWdoIGxlYXJuaW5nIG9yIHN0YXRpYyBlbnRyaWVzIGFkZGVkIGJ5IHNvZnR3YXJl
KSwgdGhlIERTQSBkcml2ZXINCj4gY291bGQgcmVhZGlseSB1c2UgdGhlIGJyaWRnZV9udW0gb2Yg
dGhlIGJyaWRnZSB0aGF0IGlzIGJlaW5nIG9mZmxvYWRlZA0KPiB0byBzZWxlY3QgdGhlIEZJRC4g
VGhlIHNhbWUgYnJpZGdlX251bS9GSUQgd291bGQgYmUgdXNlZCBieSB0aGUgaGFyZHdhcmUNCj4g
Zm9yIGxvb2t1cC9sZWFybmluZyBvbiB0aGUgZ2l2ZW4gcG9ydC4NCg0KWWVzIGFuZCBuby4gIkZJ
RCIgaXMgYSBkb3VibGUtZWRnZWQgc3dvcmQsIGl0IHdpbGwgYWN0dWFsbHkgZGVwZW5kIHVwb24N
CmhhcmR3YXJlIGltcGxlbWVudGF0aW9uLiBGSUQgaW4gZ2VuZXJhbCBpcyBhIG1lY2hhbmlzbSBm
b3IgRkRCDQpwYXJ0aXRpb25pbmcuIElmIHRoZSBWSUQtPkZJRCB0cmFuc2xhdGlvbiBpcyBrZXll
ZCBvbmx5IGJ5IFZJRCwgdGhlbiB0aGUNCm9ubHkgaW50ZW5kZWQgdXNlIGNhc2UgZm9yIHRoYXQg
aXMgdG8gc3VwcG9ydCBzaGFyZWQgVkxBTiBsZWFybmluZywNCndoZXJlIGFsbCBWSURzIHVzZSB0
aGUgc2FtZSBGSUQgKD0+IHRoZSBzYW1lIGRhdGFiYXNlIGZvciBhZGRyZXNzZXMpLg0KVGhpcyBp
c24ndCB2ZXJ5IGludGVyZXN0aW5nIGZvciB1cy4NCklmIHRoZSBWSUQtPkZJRCB0cmFuc2xhdGlv
biBpcyBrZXllZCBieSB7cG9ydCwgVklEfSwgaXQgaXMgdGhlbiBwb3NzaWJsZQ0KdG8gbWFrZSBW
SURzIG9uIGRpZmZlcmVudCBwb3J0cyAocGFydCBvZiBkaWZmZXJlbnQgYnJpZGdlcykgdXNlDQpk
aWZmZXJlbnQgRklEcywgYW5kIHRoYXQgaXMgd2hhdCBpcyBpbnRlcmVzdGluZy4NCg0KPiBJZiB0
aGUgYWJvdmUgZ2VuZXJhbCBzdGF0ZW1lbnRzIGFyZSBjb3JyZWN0LWlzaCwgdGhlbiBteSBxdWVz
dGlvbiBoZXJlDQo+IGlzOiB3aGF0IHNob3VsZCBiZSB0aGUgRklEIC0gb3Igb3RoZXIgZXF1aXZh
bGVudCB1bmlxdWUgaWRlbnRpZmllciB1c2VkDQo+IGJ5IHRoZSBoYXJkd2FyZSBmb3IgRkRCIGlz
b2xhdGlvbiAtIHdoZW4gdGhlIHBvcnQgaXMgbm90IG9mZmxvYWRpbmcgYQ0KPiBicmlkZ2UsIGJ1
dCBpcyBzdGFuZGFsb25lPyBJZiBGREIgaXNvbGF0aW9uIGlzIGltcGxlbWVudGVkIGluIGhhcmR3
YXJlDQo+IHdpdGggc29tZXRoaW5nIGxpa2UgRklEcywgdGhlbiBkbyBhbGwgc3RhbmRhbG9uZSBw
b3J0cyBuZWVkIHRvIGhhdmUgYQ0KPiB1bmlxdWUgRklEPw0KDQpOb3QgbmVjZXNzYXJpbHksIGFs
dGhvdWdoIGFzIGZhciBhcyB0aGUgRFNBIGNvcmUgaXMgY29uY2VybmVkLCB3ZSB0cmVhdA0KZHJp
dmVycyBzdXBwb3J0aW5nIEZEQiBpc29sYXRpb24gYXMgdGhvdWdoIGVhY2ggcG9ydCBoYXMgaXRz
IG93biBkYXRhYmFzZS4NCkZvciBleGFtcGxlLCB0aGUgc2phMTEwNSBkcml2ZXIgcmVhbGx5IGhh
cyB1bmlxdWUgVklEcyAoPT4gRklEcykgcGVyDQpzdGFuZGFsb25lIHBvcnQsIHNvIGlmIHdlIGRp
ZG4ndCB0cmVhdCBpdCB0aGF0IHdheSwgaXQgd291bGRuJ3Qgd29yay4NCg0KSXQgaXMgaW1wb3J0
YW50IHRvIHZpc3VhbGl6ZSB0aGF0IHRoZXJlIGFyZSBvbmx5IDIgZGlyZWN0aW9ucyBmb3IgYQ0K
cGFja2V0IHRvIHRyYXZlbCBpbiBhIHN0YW5kYWxvbmUgcG9ydCdzIEZJRDogZWl0aGVyIGZyb20g
dGhlIGxpbmUgc2lkZQ0KdG8gdGhlIENQVSwgb3IgZnJvbSB0aGUgQ1BVIHRvIHRoZSBsaW5lIHNp
ZGUuDQoNCklmIHRoZSAiQ1BVIHRvIGxpbmUgc2lkZSIgZGlyZWN0aW9uIGlzIHVuaW1wZWRlZCBi
eSBGREIgbG9va3VwcywgdGhlbg0Kb25seSB0aGUgZGlyZWN0aW9uIHRvd2FyZHMgdGhlIENQVSBt
YXR0ZXJzLg0KDQpGdXJ0aGVyIGFzc3VtaW5nIHRoYXQgdGhlcmUgaXMgYSBzaW5nbGUgQ1BVIHBv
cnQgKHlvdSBkaWRuJ3QgYXNrIGFib3V0DQptdWx0aXBsZSBDUFUgcG9ydHMsIHNvIEkgd29uJ3Qg
dGVsbCksIHRoZSBvbmx5IHByYWN0aWNhbCBpbXBsaWNhdGlvbiBvZg0Kc3RhbmRhbG9uZSBwb3J0
cyBzaGFyaW5nIHRoZSBzYW1lIEZJRCBpcyB0aGF0IHRoZXkgd2lsbCwgaW4gZWZmZWN0LA0Kc2hh
cmUgdGhlIHNhbWUgTUFDIERBIGZpbHRlcnMuIFNvLCBpZiB5b3UgaGF2ZSA0IHNsYXZlIGludGVy
ZmFjZXMsIGVhY2gNCndpdGggaXRzIG93biB1bmljYXN0IGFuZCBtdWx0aWNhc3QgYWRkcmVzcyBs
aXN0cywgd2hhdCB3aWxsIGhhcHBlbiBpcw0KdGhhdCBlYWNoIHBvcnQgd2lsbCBhY2NlcHQgdGhl
IHVuaW9uIG9mIGFsbCBvdGhlcnMgdG9vLiBJdCdzIG5vdA0KcGVyZmVjdCwgaW4gdGhlIHNlbnNl
IHRoYXQgdW5uZWNlc3NhcnkgcGFja2V0cyB3b3VsZCBzdGlsbCByZWFjaCB0aGUNCkNQVSwgYnV0
IHRoZXkgd291bGQgc3RpbGwgYmUgZHJvcHBlZCB0aGVyZS4NCkZvciB0aGUgZmVsaXgvb2NlbG90
IGRyaXZlciwgSSB3YXMgb2sgd2l0aCB0aGF0ID0+IHRoYXQgZHJpdmVyIHVzZXMgdGhlDQpzYW1l
IFZJRC9GSUQgb2YgMCBmb3IgYWxsIHN0YW5kYWxvbmUgcG9ydHMuDQoNCj4gRm9yIHNvbWUgY29u
dGV4dDogSSBoYXZlIGJlZW4gd29ya2luZyBvbiBpbXBsZW1lbnRpbmcgb2ZmbG9hZCBmZWF0dXJl
cw0KPiBmb3IgdGhlIHJ0bDgzNjVtYiBkcml2ZXIgYW5kIEkgY2FuIGFsc28gc3VwcG9ydCBGREIg
aXNvbGF0aW9uIGJldHdlZW4NCj4gYnJpZGdlZCBwb3J0cy4gVGhlIG51bWJlciBvZiBvZmZsb2Fk
ZWQgYnJpZGdlcyBpcyBib3VuZGVkIGJ5IHRoZSBudW1iZXINCj4gb2YgRklEcyBhdmFpbGFibGUs
IHdoaWNoIGlzIDguIEZvciBzdGFuZGFsb25lIHBvcnRzIEkgdXNlIGEgcmVzZXJ2ZWQNCj4gRklE
PTAgd2hpY2ggY3VycmVudGx5IHdvdWxkIG5ldmVyIG1hdGNoIGFueSBlbnRyaWVzIGluIHRoZSBG
REIsIGJlY2F1c2UNCj4gbGVhcm5pbmcgaXMgZGlzYWJsZWQgb24gc3RhbmRhbG9uZSBwb3J0cyBh
bmQgTGludXggZG9lcyBub3QgaW5zdGFsbCBhbnkNCj4gRkRCIGVudHJpZXMuIFdoZW4gcGxhY2Vk
IGluIGEgYnJpZGdlLCB0aGUgRklEIG9mIHRoYXQgcG9ydCBpcyB0aGVuIHNldA0KPiB0byBicmlk
Z2VfbnVtLCB3aGljaCAtIHJhdGhlciBjb252ZW5pZW50bHkgLSBpcyBpbmRleGVkIGJ5IDEuDQo+
IA0KPiBZb3VyIGNoYW5nZSBzZWVtcyB0byBpbnRyb2R1Y2UgYSBtb3JlIGdlbmVyaWMgY29uY2Vw
dCBvZiBwZXItcG9ydA0KPiBGREIuIEhvdyBzaG91bGQgb25lIG1vZGVsIHRoZSBwZXItcG9ydCBG
REIgaW4gaGFyZHdhcmUgd2hpY2ggdXNlcyBGSURzPw0KPiBTaG91bGQgSSBlbnN1cmUgdGhhdCBh
bGwgcG9ydHMgLSBzdGFuZGFsb25lIGJ5IGRlZmF1bHQgLSBzdGFydCB3aXRoIGENCj4gdW5pcXVl
IEZJRD8gVGhhdCB3aWxsIGJlIE9LIGZvciBzd2l0Y2hlcyB3aXRoIHVwIHRvIDggcG9ydHMsIGJ1
dCBmb3INCj4gc3dpdGNoZXMgd2l0aCBtb3JlIHBvcnRzLCBJJ20gYSBidXQgcHV6emxlZCBhcyB0
byB3aGF0IEkgY2FuIGRvLiBEbyBJDQo+IHRoZW4gaGF2ZSB0byBkZWNsYXJlIHRoYXQgRkRCIGlz
b2xhdGlvbiBpcyB1bnN1cHBvcnRlZA0KPiAoZmRiX2lzb2xhdGlvbj0wKT8NCj4gDQo+IEhvcGUg
dGhlIHF1ZXN0aW9uIG1ha2VzIHNlbnNlLg0KDQpBcyBsb25nIGFzDQooYSkgdGFnX3J0bDhfNC5j
IHNlbmRzIHBhY2tldHMgdG8gc3RhbmRhbG9uZSBwb3J0cyBpbiBhIHdheSBpbiB3aGljaCBGREIN
CiAgICBsb29rdXBzIGFyZSBieXBhc3NlZA0KKGEpIHlvdSdyZSBub3QgY29uY2VybmVkIGFib3V0
IHRoZSBoYXJkd2FyZSBNQUMgREEgZmlsdGVycyBiZWluZyBhIGJpdA0KICAgIG1vcmUgcmVsYXhl
ZCB0aGFuIHNvZnR3YXJlIGV4cGVjdHMNCnRoZW4gSSB3b3VsZG4ndCB3b3JyeSB0b28gbXVjaCBh
Ym91dCBpdCwgYW5kIGtlZXAgdXNpbmcgRklEIDAgZm9yIGFsbA0Kc3RhbmRhbG9uZSBwb3J0cy4=
