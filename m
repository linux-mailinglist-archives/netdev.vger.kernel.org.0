Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969D359AD72
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 13:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiHTLYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 07:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiHTLYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 07:24:20 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80084.outbound.protection.outlook.com [40.107.8.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C5E2CDEA
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 04:24:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tc1rxERAiBWPiRNjNo1388I3EOq8bzK3MX0oMmg3L85Mx8kBvi85lW4s3uMXpZqcpibWnxP3JKWKyr4/FM8QESD1b5hlynQmy0vSVhUkKtpqdWZUczcoGcNRlZylfrckr45xS+05MWFu3fBmPmsSI0hUaMnKwlmYaZFzk05Fu+xY2k8VlhBI3dGZFR9cU9CUeNoLM4p6UROgfXoujsqApkcF0NJKMtk2ebQBISqV1vSXWaMP33tOgkE0KGrawzUFCh8+i97vJBO3eJjNShC0FOK1KQwcZHiiKL/exatwD1yjGWu5QnmpaQ5RA8gE59Ct3lio/a4ZAG1IgKVBhuBMYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmS14M2znCQee7Pp/rlSjIniDcdV9B/8AE/R0fJz2gA=;
 b=ilm9PQvrk6HryGPNvQltc9JrgliLkmgmRuuQja26iKSiT5qcA3Sz0GUbWVpUQF+X15MuSTwfEbbBzJYiZkkinNLl/DFoGyuTZmjavZ1ZGUFvdkDjM74WXIOYvXCoPHL9q8AgdnS3WgAjlEwEFfaejGruFHUJ60Z4vi7x+5F+NwspjAKfn8UU6uje/wRoVu3FZB8Q57rH1caiCrnFLwolKsukntHo3GqWrIre7iwgbgSJvCmr0KQSyNxx2lA4NudJUY7toUb+THR+f43V7E7Dy52XeTFEZQFXocVv8vIetdDDjY63fHieUiQV7bBw2tVX1l1YO1+CZtQ5dwakNcZA4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmS14M2znCQee7Pp/rlSjIniDcdV9B/8AE/R0fJz2gA=;
 b=Ik5Y2sHauFNHF09uCLF9oD+Yh4gV4wiDzBTUhRfkkcwcdn6yJXK999ED2SipPm4Fs58Zd6xu8EYtHIW9Y9vn+tYJa+8ZH6UcffnnOrqTpuVLr9Cu7SF3V1vMIBSW3x8geAnqJm6VOS71x+2VsoOD67XC+bHz6tryRN7yHalmUe0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8291.eurprd04.prod.outlook.com (2603:10a6:20b:3e5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Sat, 20 Aug
 2022 11:24:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Sat, 20 Aug 2022
 11:24:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <alsi@bang-olufsen.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Topic: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Index: AQHYsw9wTPJvcSDZh0qzuivUfmRwaa224bCAgADG8IA=
Date:   Sat, 20 Aug 2022 11:24:14 +0000
Message-ID: <20220820112413.ea5abtd2hegpk6kr@skbuf>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
 <20220819163211.633bafc3@kernel.org>
In-Reply-To: <20220819163211.633bafc3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c224d080-15d1-4562-93f0-08da829e8358
x-ms-traffictypediagnostic: AM9PR04MB8291:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sV+HpWVc5NEqmCtnygkccZPulUHdr/hgEV2C10h7m9LaoeDyHKOoA3TSC3cP2Qf5MXBr/Z3LpzZ8ln2P2lY6mBg8aDCK89/bCSUc9rHEFFF3zsLf4dz4wfueYFgUHYj8LFRey9Lqjsa0arV3t20MV6GS4dlk1tf29+zfi9weIli4p2Gk/DNIuXvZMiStlyEWe1Dzt5tI4dZ2wHra/H+HrPGDpSqn/brQlltlavz3xkOsfB5LzZsUC09tLha19UuDFTdxlODtk4YTdU/hlWHqad7tGHWH8ePj2lLFraqr1Bj3dHUw+UlbKjIMjGu9JWO4IvMDsRmueMjzTQq9KIF15n0x1XKtbwuu7YsFy5VWz35jLetdgNbXKKqT4hCvEM9atacXHx4XKsax3gWop07ZERZitAZ8eizvDO6jgodWeQdidJKgetQStuZ5UGuy+yFwtAJoA4CYN5L+W1tLJHiQWkPcNNF40tmux38gI0IHlu56a+gBXw4hK4G4KeIVd1PpglI5y/LODIZI2B9BJd10MU401TEgTk1NWI3Ek9Uv7bVaxF3wkuZxI4tqdQVcT8dy4/mjvM2GTH9tATBEnHXiH9JvGKm8Ob+LBXEd463xqoBTeWRiiFDABTw5naBfhOOcdJsT8p1d4PpixOwJA6AwwP4FZ/jTuD5avuLgjxchTegcjcJcCrHqkfbRm2ocl/ylGB2D0YlO3YVQUK/sMdM6nXQBbmDVkgo8GbGLcBZSCsANX8k5gCEr1l0Sxdl8VPl7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(376002)(136003)(366004)(396003)(346002)(33716001)(2906002)(4744005)(44832011)(6512007)(316002)(91956017)(4326008)(7416002)(8936002)(54906003)(5660300002)(6916009)(71200400001)(6486002)(478600001)(9686003)(26005)(41300700001)(6506007)(186003)(1076003)(38070700005)(38100700002)(76116006)(8676002)(66946007)(64756008)(66446008)(66476007)(66556008)(86362001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?U1B1eVlHZ2VYSlBOa0ZsUVNZL1hmOXpTMy9iYjBTVVpqS09YSVBxL2c3cW1Y?=
 =?gb2312?B?UHJHZkh5Rmd3ZlM3NDZFT1JHSzZUSjBlVlprNUZyWVViN3U4UUU2cW9aN3V2?=
 =?gb2312?B?V1ZRYmsxa2dnWlpGNFlmUnF4YXZnd3pKZUFlRHllbnVDREZ1SExnM1VibTF3?=
 =?gb2312?B?UXZiU1g3dG90Rm9vSWFaSGR2Nm1qWnVMWHcrbG5hWExrZTJqYWhHYzd6clIx?=
 =?gb2312?B?bWQ2TUM2eFpvUzQwUXFvc2YvUllUMEVjZEtaUUdocWVoenllZXpCTU5nR0R5?=
 =?gb2312?B?OXV1MWNtR2dURWVlQktLWGdwOU5RU3dmQ2RTaDB6dlRjTlpjT3hjMFRHQVps?=
 =?gb2312?B?NWFmV0Fub01ZNGpNMGZEZ3h0a2tSczR6a1drYzBkYThXL2JpWmdDcjZNUy92?=
 =?gb2312?B?MjVIVHc2MnhQN0YrWitQeWx1Nmp5YWtIbTRHQkllRjBkWGNVVWNKSnp5YTE5?=
 =?gb2312?B?MFlkYXpjdFVBeTBwemNKQ1EydW9aMC91ajdxeFpteExhbFVvWit4NU01a0Ju?=
 =?gb2312?B?N3ZnQnpRVjlXTFByZlV6cEw2aHhLNkdoRlZBZXpTUFl4RzlGc2Z4YzRrU3Jh?=
 =?gb2312?B?YkFYK285SDZRQzE2R1Q3eC8zbWZEem5hbWZyMlBmMTRMbUFSWTA2VnFVV2hG?=
 =?gb2312?B?MXlNYzBzOTFRb2didjUyVzBUNnlDQThEWENTaG9lWGE5VEdjSHBYSEFGdEpY?=
 =?gb2312?B?c1dIL0QrbHRsRG83SnpqbGxmL0pSVkhSTEE3NWN0VWtBckxpQWRJWENsbkNM?=
 =?gb2312?B?aEtnWDN2T2VVSW5ieEZVRkptd3FmUGNnWVN3dEpSR0prRzBwaWM4Q3BHMVdO?=
 =?gb2312?B?amlkVlA3emtHUXVnelFYMjBsOTZFWnhxTHZBRUpUbGd3Q3dEdFYwcXlWb0Vp?=
 =?gb2312?B?ZDNCZy9ubkU0VEUzTmFKWjhVMEIvb3ZHMGNvOGRCM00xaVJFMW94dmErVGZy?=
 =?gb2312?B?Z1cyeit0WThibm13Y1Bxa3ViWDRCOW9IeVhvYktVVmoyTlpwMG5GblllSXpq?=
 =?gb2312?B?UFc0eFZiR2JvY3QzY2JWWm1YSk5ieDF2cVFvS1BrdUw5UjF1RDdpQ1VyVmRr?=
 =?gb2312?B?aC9HTFZqbjVYOTZ6N3dHZWRkZ21oL1hONGVMVmdDeVdiYnhzd2x4SFZTcUpm?=
 =?gb2312?B?U0NndEdRL0NQc2lKMkQxOUUrN1JYdDBQbVQ3MHVKQjVvb0lLR3MrREUvWW5h?=
 =?gb2312?B?QkdlWTJ6cEt5OHFtOUJlTnhJOGYrN0NYamlCSEs5NEwwTFMvTHJoSjdqL2Ro?=
 =?gb2312?B?am1zMFRUU2VaTE5aNGFET2laTU5BZDM5Z1hPL3Yxa2xLTVF1TE0ybDZkUmxE?=
 =?gb2312?B?ejhKT0E5ZHAyOXlWT0xCMm5HNFRUTjd6RDllWVdBSWl2dm9DbDFSRVVYR0lG?=
 =?gb2312?B?TjVoTzgrakJMTXd0Y2QvK2pGbzd5T2pad0sxZTFSdUZhbFdzQ2R5bnd2Qmhy?=
 =?gb2312?B?Z0hmRFlVdEMzcmFnRHNkMVNYNFVsWTZXV0d3U2cyMk84bTFWUlpnWUY0aldy?=
 =?gb2312?B?OVJCWS94UkozL0NoaEx6RlcwOEdoMk56N1E2NFgyYjArRnhwV3k0QUU4ajdy?=
 =?gb2312?B?alROU3FxZ2djTmRFZW9QMUJ3MWw3Vmp2cCtQZE5pZWNIVUJtbTdrQUdQMlFL?=
 =?gb2312?B?TDFTM3lZdVJmcUpiVHFnc0VTUnhHdjdxVjRJWTM4WG9Ua0F0dnV0Vkh5SXNK?=
 =?gb2312?B?RXIwUWFBZ2htR0ltRVRLbEQvSzFVOUdKOW9jc2xWR0VzZGtCWXJDNEp4OVZ5?=
 =?gb2312?B?QTBBeWIxNGg5ZExsVmpsajRZUDA1Q0t4ZXhkRnUvdjFpUWZ4dm85b3h6cE1P?=
 =?gb2312?B?WDJUN0VKTDZzaUFwOU9lRUNTL2ZpNFAyRnpscERyV3RpWG9EU0M4NXYwYmNP?=
 =?gb2312?B?VDVKckJwK1dmc0N1UHNiWHp3YSsvZ1dEbS9OTG5HaktCY0tJNmJqbE9Rd3Uz?=
 =?gb2312?B?TlZDRUI4NENpc2wyWVN1QnVoMWVFeTBwcFN3Y0V6Z21Fc2lQbStlTU8rTjVa?=
 =?gb2312?B?SWRpbFNCMUs0RTBNNitMYVdwVnljbm5ObGFPcVBNZ0llVEY0UU1uSzlGaUxm?=
 =?gb2312?B?bDJBRVFmejlnNzd0MDhLdkx4SXJzY1NHaXNvUEFyNjNDeTBxYzFCTjRIZlRM?=
 =?gb2312?B?YkFXUFN1L09tRHJYUDdKdmxRQmNoT3pvL2dVTWc3bVN5UHdpUDMxRUp4SWt2?=
 =?gb2312?B?U0E9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <8BA888F4B5ABFF4B98DFDCFB8B22406B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c224d080-15d1-4562-93f0-08da829e8358
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2022 11:24:14.5629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2HDSySx/0icppNm+KjoTEdyxF8otJ3xYxpkAVNkI5j44AWijHi131wOwuHURxHu9ex5PTxm9b71VI4lnXJE6mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8291
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBBdWcgMTksIDIwMjIgYXQgMDQ6MzI6MTFQTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+IE9uIFRodSwgMTggQXVnIDIwMjIgMTc6MzI6NTAgKzAzMDAgVmxhZGltaXIgT2x0
ZWFuIHdyb3RlOg0KPiA+IERTQSBoYXMgbXVsdGlwbGUgd2F5cyBvZiBzcGVjaWZ5aW5nIGEgTUFD
IGNvbm5lY3Rpb24gdG8gYW4gaW50ZXJuYWwgUEhZLg0KPiA+IE9uZSByZXF1aXJlcyBhIERUIGRl
c2NyaXB0aW9uIGxpa2UgdGhpczoNCj4gDQo+IFRvbyBtdWNoIHNpZGUtY29udmVyc2F0aW9ucyBn
b2luZyBvbiBoZXJlIGZvciBtZSB0byBncmFzcCwgdGhpcyBpcyBnb29kDQo+IHRvIGdvIGluLCBj
b3JyZWN0Pw0KDQpBZG1pdHRlZGx5IEknbSBub3QgYW4gaW1wYXJ0aWFsIHBhcnR5LCBidXQgeWVz
IHBsZWFzZS4=
