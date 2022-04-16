Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66965503655
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 13:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiDPL3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiDPL3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:29:49 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2124.outbound.protection.outlook.com [40.107.22.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0327F3E5D2
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 04:27:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3tVFRpRuwggR5IRc8IWxdAXksTB2peh1cWNXvUE06nZSHnuKn74n79kU+oS7I8YFD0bdgK7uGEfowAy/nKdEVGucSXkzZkVLcDNnjQ4iO05WTZ783E/kr5/qswPbGN2teBFIa9tFPRwC2u5a+K7kRd79RQ/wo4pqyBQaQ/86epwn1/SCMh065Wp7uKoGJ++YOManSoweX97bmrUj29kHzibd79Pwgusx/LQ/Br4X1zslHm+u8UfrnYi1T7b44Iipcogh/Dwe7/kDPHM886qUHK0rbDYGVlv+Uy2CjijaVa1bMs4NoAlQuKJrgRzlvJyDJlXtRk8vEPveBDPhBEWIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MDkOgCg8ViEohAZ/EpXqnc1ou/VmBUQhvBG30NZB9SM=;
 b=B4Do0hz87U89H9fBzI5PhdmZCTEjXB7VNgeILDv+yAifX9S8QAUjDyCjTmDs3v9OaReVLRqXgsSEtvoUWA781PBZWK8mJQBf5DhsgmjW9Doq9hV/M/uG4RJ0TZd7JPMyrq5PjqdX660wLbhl++ius1XmmqUdK2CNHoUBRplvLBCT15XpKO/KL7Ps8QsG/3q4BuazaWD7nCLEOiU6OS69Jqk3L4GhM5jQhhBCZfZgpxAJQ0SUNOICE5HA/YRPIkPf4POf2V/kPIzV6z0K32GU5PU1StId+mzokh5t5rK/fGDIjNz1Qr36OjkrpTpiRye6e6INU+2//ZqxVZkgzZ1WEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDkOgCg8ViEohAZ/EpXqnc1ou/VmBUQhvBG30NZB9SM=;
 b=EtQ32te5pkBPhrpWPTgIt9WtSxSqT6hR+I37aqR0svbr+wUa5FMtI7P5fifg7GShWSr+eEsLRUdADbPLb5OBX/w6ifDQ2Z5mKFP7MfcJw8Y4oDJlMlcKufAUZYWUQc9d/j/4rlV/dtcA6I2UeHbVwnul7QU+RoplaOcAU3Nvoiw=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM0PR03MB5507.eurprd03.prod.outlook.com (2603:10a6:208:16b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Sat, 16 Apr
 2022 11:27:16 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5164.020; Sat, 16 Apr 2022
 11:27:15 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net 2/2] net: dsa: realtek: remove realtek,rtl8367s string
Thread-Topic: [PATCH net 2/2] net: dsa: realtek: remove realtek,rtl8367s
 string
Thread-Index: AQHYUVrGcLWk0Ay/8ke6f3aeL4IEcazyYZcAgAAFjIA=
Date:   Sat, 16 Apr 2022 11:27:15 +0000
Message-ID: <20220416112715.pw3vdijenrskbxs3@bang-olufsen.dk>
References: <20220416062504.19005-1-luizluca@gmail.com>
 <20220416062504.19005-2-luizluca@gmail.com>
 <20220416110724.4f33mudec5toyam2@bang-olufsen.dk>
In-Reply-To: <20220416110724.4f33mudec5toyam2@bang-olufsen.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac4f4050-35c8-4034-3e74-08da1f9c0f5e
x-ms-traffictypediagnostic: AM0PR03MB5507:EE_
x-microsoft-antispam-prvs: <AM0PR03MB550771497BB6C15B7A0DEC6283F19@AM0PR03MB5507.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WB5pMcBUH9pm9Kztfb5dUOI0dBU4OwXTkWJjmtChSR0LrKMVqCk3Y8s9DJLIWThLsh3LC28hOY8S1RNfSmOR0cQXxwCpzF9tiaZMYU1p0Z5opJRI6AKtH5Lh40B3Ah66SMBEdn9QuxzXnDIK0QO/CNff1h4rAtkRyMEhEgM9vep4CbePBpnPhXEyNG6QTrY6l6f10VvdY6uc3Y7LDsoelbFUDb2ski7vInecyYR2O5lGkBy5t+D1MSWDvY6k9rXl9lHSJ0AWVDpem7WkkUIxNMiJ+8SwoWwZxJx5qlaWxBg7He1doymHXP+BqdqnZuflNcLSMY01q2zKqMmCgcapmfJNB/4NxWFFTyRL02AlSCKkiwXjCCokMWurskIpCu9MPkZwxEIKVFtxzJUkjfNQb63Dzy5pRuRRkudj63xVGHol84OCs//rjCnbNyPgEt5xwhFvLBeeScAxjzXXh/zSDT+K3UksfSnrKxJZZSf7MoeEiwxct8NTDIhKNUZbM6nev5xjzdtib5ab37GMnP1u0q1whiKcXSxCoiuin0/sgv7/tU0GVMy/MjJTrcOhwlAxD1azQQJqjazVjk/ao7Cu2VNFDr4Ix3GKA6dk+PNoTKR3rghM4fBndOPSSaTsS+U31MiASbloZKcVir+WFxN5cV53aAh27dLBeAI4AMn/YJbEVDKn8owN1uq3wyhjFtCOhGB0H9pJ0pYc0suptyV/0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(66446008)(66946007)(8676002)(4326008)(66476007)(64756008)(66556008)(91956017)(5660300002)(86362001)(38070700005)(8976002)(8936002)(122000001)(38100700002)(6512007)(26005)(2906002)(6506007)(316002)(54906003)(6916009)(76116006)(71200400001)(6486002)(508600001)(1076003)(85202003)(558084003)(36756003)(85182001)(186003)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTFuazloa2REOHYvV0JvYkg3enY4cGZEUENrU0dyNEFwb24xZmZOMEJGU2Q4?=
 =?utf-8?B?K3RuTTJrQmpHZlVDU2YxQklaeDgyazZGYXA2cnMwWlEvbzVqNVFDR1pFc1VB?=
 =?utf-8?B?Yk1vV3Jhc0YxZGEzbGV3K0F1VDJ0bVVYNnhNOEJRVktZUjZRUEZPV1ZBVU93?=
 =?utf-8?B?cGNTWWNSUjdONEpuVFZKME5SbFhFOHAySjczYVZWaUhqYXA1VGlXU3JXQjUx?=
 =?utf-8?B?a0lEUG5tQnlIK3Z2Wkk4Nyt6ZXI1SU5UWUlsQ2pnRm1kZC9tWDNGQ1hCTWJR?=
 =?utf-8?B?OTBjTFNKWXNpZ1FrVjAvcjBINFIwZmViSjlVbjJXbW9MYWJXMmpsQUo1SDgw?=
 =?utf-8?B?cVZ3MWJXNHd3TWgwQ1VxQmsyRXA4V2RjcWFmTSthQjlrQ0JTemtvREE3emFj?=
 =?utf-8?B?RE96TERpeVVlZ1lQNlZRY0NNWW1MZUVOVWVWWFJpbmh2Q2lJN2FuN1NkWndM?=
 =?utf-8?B?eGczajE5R0NPYTZDODUxb282SEEvNVBUNU1hQ2VIR2pjNk9qRmtlZ0hMZjR4?=
 =?utf-8?B?OE42YUJVaXpvSWJZNE4vVnlYQnZsaEZNSzIrYk9yTW1PRVRhVWN0TVg1M3A5?=
 =?utf-8?B?MzFmTUE3Y0V1Y3Y0N1RER1gzbEJKZG1uNm56WDlBVUxZWVQzei85cjA3d0pN?=
 =?utf-8?B?RzR5aWhKdFhVS2xqbzRDUG5iR0pXc2pxWGg1ZC91aHRCSCt2OURjb3hva1o1?=
 =?utf-8?B?K01NZmtVb2N6cnVRVGthblFxVS9PMXF2eGxVZHhqZTdpbFlaV05rTFlqZ3pn?=
 =?utf-8?B?eTFsVWZnVHdUaVdocVc5SitEcnpQMGhGbDBiVGJOeGFvQUtTQjg5TjljU20w?=
 =?utf-8?B?R1VjMjZPM09KMkxWNC94UUNwMmg4bDNNeDRQeW1PVklUblJiVW5BRUExanU4?=
 =?utf-8?B?YVhiWldwZzhaK1ZHOHphN3V2UUNKSmNEM3RXSG9uRmltUy9RRU1peldrRmlM?=
 =?utf-8?B?MmhiOXVaL1JZazNyaERabHY3YWhXOE8xcEFwL2pvS09NUERoNFY2MXY0K3Zp?=
 =?utf-8?B?WVpmSWNLL1drclN4V2syWlY2VjZkdllhNE1PSGZJNUFFaTB4aUtvRVhOYVNV?=
 =?utf-8?B?YVc5QXFsN3l5a3ZZd0JMU1UrZ01zemdRSjlUaWtRUXdHSGMvbEVQUnoySUZL?=
 =?utf-8?B?R3lOWUdtY24yNk1YR2hPZVhaZ2FlYnRNSk9ja3FlWFRod3NWZTl2YTgyZDRL?=
 =?utf-8?B?MWtRWllrazYwbk41bFJOMlBqSDl5ZzE1bjZ6NkdHTlducDFmZXdRb200eWtw?=
 =?utf-8?B?cTlCSFNHRjhydmkzSUhaUTNLMDQyOWtDWk5pTFFqckVJbm0wZnVVdDB6YWlw?=
 =?utf-8?B?emdFNDU0TFZkeUY1dzZOQTF4WGFNcmZUV1krUDJHS05manoyNnM2M3FaY1BR?=
 =?utf-8?B?dEMyZ3d1dThpOEVveE4xM1hkMnNxSGRibjdRTWJsMTJGMlNiblVFNmQ1WEpH?=
 =?utf-8?B?Z0NXcjgrbzFYZmVJNWJ2MTFsbk96WE1jS0VJaUtNbC9xUy82TjFNSWQvRll5?=
 =?utf-8?B?MmQzYmQ3NUxOVGwrMXljZ2FZY3hUTExtYkUweG1ObUNVTGJZK2d1YjVBLzRK?=
 =?utf-8?B?NTZjWU1Hc0FrMmpCREVMLzVHbjBGNzdzY3lPaHBCa0VSOUcveWlXWXJUekZy?=
 =?utf-8?B?Kzc4ckhEMnBZL2R1MnQxT2Y2NmpobVhySnRqaG5xWXg1Z0xGWERXMnFVVWxx?=
 =?utf-8?B?bkVaOGlhUCtJN2tmVHRNUU9kK2FYUkczU0FOU3QvZjNtTmc1QmtlOTJzcTZy?=
 =?utf-8?B?ZU0wSTVacVRMaGt2KzF2OEFwM29sWUVQcUlsRkxxcmlnT1AxTkF3VzdFZ1FG?=
 =?utf-8?B?bnVrcmRZeWVIUmorQ1NpL3lEL3ZwUStuMjRPc2ozMC96OWdDNFRsZEZCK2FF?=
 =?utf-8?B?d3hndVBMY0VqaGt6Y01YYjlDY1JCa0ljaHdmZGx6QVNONDhGdmhpOU1yY3pR?=
 =?utf-8?B?Nnc2TVU2enVGOE9jcTBFQ3pvWnFsNUhrUnhrYjVSOGJrK1ZnbEJ5TzA2YnJu?=
 =?utf-8?B?SDFWcFdTb1ZkT3pWYXdBOFMwamVUaWVvaE1kbllhMlpZT1d6aVpvV1c2R2ls?=
 =?utf-8?B?RXBGWlNrM3VhRmVlYVBPTzk0N29OaDNFOUtlSlExUWQ4VnArTTRUZkR4S2tC?=
 =?utf-8?B?NUlsTTRWbjczRlRkR2RCbzNyRzUzMnhLTERTK0VGVXZPeTg3L3dQYXN2Vnlj?=
 =?utf-8?B?ZlF6UjZFNnN5QUhWblczcndOYlV4MS9ybno0V1RzTXJ1ZlRsZzY0TENtYUJz?=
 =?utf-8?B?UXpqaDRGOUpPNzBxVUtpeTd3QW1YanFEK2twQXAyM3M5UEFjZlU1ajIxSmtv?=
 =?utf-8?B?S1plV2VJaEFmamtyMEQvODc3cEtGZUkzOXVIYTBsQytXbXQ4ODF2VTdDbldM?=
 =?utf-8?Q?35QtybAsKFTtlWz0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2FC8CE6AF5E0F438DF4D64AA6DC6644@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac4f4050-35c8-4034-3e74-08da1f9c0f5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2022 11:27:15.8759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bd6WEKxC7YNj3eXEpmUkHgke6GAWnYQdA1Q5v1c0halgx6LXw9r4bhwdSlu/17CZrwGHlYu2XDUkAVowdMThdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB5507
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCBBcHIgMTYsIDIwMjIgYXQgMTE6MDc6MjRBTSArMDAwMCwgQWx2aW4gxaBpcHJhZ2Eg
d3JvdGU6DQo+IFJldmlld2VkLWJ5OiBBbHZpbiDilLzDoWlwcmFnYSA8YWxzaUBiYW5nLW9sdWZz
ZW4uZGs+DQoNCllpa2VzLCBsZXQgbWUgdHJ5IHRoYXQgYWdhaW4uLi4NCg0KUmV2aWV3ZWQtYnk6
IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4=
