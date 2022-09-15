Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225425B9EE0
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiIOPeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiIOPeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:34:08 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2098.outbound.protection.outlook.com [40.107.21.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0AF4F193;
        Thu, 15 Sep 2022 08:34:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVLei1/1a1NbM2RNrHaw+duZ9L062FrV5JlfQsMsAQXPETq4fJ9m8NE1MrU4jgdbJDj3gjbDdxNhes4kZULA9by8kMZtZActsuZLcUE/RRPJPqDJ3Qp3i1ynpC5QHZxBfjxiWEZlsAklnTkAlxihf7c14l5dvQXA9x/N2Nxd3bCS3rlaROlDr0x9FaRCzitIj6UHcjrvZdHMcPlQwdPg4gi0QSIE5Lo5upN6q7FOLuOsQ9WQLGYZeGZ3F52wWqVojtQVYnUJOF6t4SOLIjS4lueKyklnw1cfMWoHnUPj8/JM6xPi2dYhwMP4nfnsDqMdX0le8yyFVxxeDYGlIixnaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVTRQYwK9xKi2TT3+BIr1l27lHSp915fSzr6IFnGWU4=;
 b=NJ0262h1wm3/0ine9dRWriW/JkPCl8p+Me+qzLGaD4cGxtxf9c8wk23KhQTGim9CFGDBAnwFY3bRNNWF9DrY8+IG5gaUUdQNjvGtPJsjBJzSwTYn/jK/8QcXVX/VTYp9IkUm6a74zOXZ98VhiXP1Mt8b6BLJjHfIHa30PjUaXWTEisRP3rhatGkI6CrihwU9i49wkSQCcAT8vgdGHmderHc8E1Jj3MblBX2mtwNDBFTAxjcSxrfbS3PBuDyII5B5yDAnGsxo+MYgGpP6h61mN+FWctBeJ2XUT/UMxT7ucMdPbWGU4TAyh1Rw6v9uppIwQRqF+kGJE/m1xNFTK9OLtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVTRQYwK9xKi2TT3+BIr1l27lHSp915fSzr6IFnGWU4=;
 b=GbqdRO02jZfU0Nd//DVhWJ1WwQZa2Fov3HbF/CLGNq29aADtwbugbwWsqtykVJewGyMSS9j500qlY7jy/JgXOnVtZ2y7dUXGbmMYtt42aUMznWZqUnYch/hjN5u/MHNtwvlM57VTbVYEwdKZUB76Mtc5TW1sGPRzBZnJOf3v0TU=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7567.eurprd03.prod.outlook.com (2603:10a6:10:2c4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 15:34:05 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 15:34:05 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 04/12] brcmfmac: firmware: Support
 passing in multiple board_types
Thread-Topic: [PATCH wireless-next v2 04/12] brcmfmac: firmware: Support
 passing in multiple board_types
Thread-Index: AQHYyRiWXP1vmZTi80WvEwkXsbmnVA==
Date:   Thu, 15 Sep 2022 15:34:05 +0000
Message-ID: <20220915153404.46whbydgfvqqbnmb@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7c-0064uy-Q9@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oXg7c-0064uy-Q9@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB7567:EE_
x-ms-office365-filtering-correlation-id: 0aa2cd63-3f4b-4cdc-bce9-08da972fb91c
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZRp7VlRXNLBgyl4FrVf7aoWJLtumgE/sbFY+wofnbNY5A8rgcekRDS89vRYK0SSEHsuBaTZFPGhRz3/n4af8rXxmYsMs8UoIrX3CEacrIH7FE4iFu47KQ8SydNKRbJrlXGExCGG4xblM2kbiikmUSIcetmuynn6mCPHtCGai6Xuj5IDTlNJz7lnPyH2YSp2v7CIESDIucVlEWP+JcEnJDK+g3GfVhCsEeRev3F8YOPtvIq7aRnbMT3nvTbgkj7jlQ3Tr7y3Py/H/8Bsq18Suw4WkcX9cGw9V1zeY21gTJk7KDEAitQONXc0c45eg2EyBIubTRtw0HNG/uKf4EbjHg+LVf8DiK7+broqIEFPxdzt10O8CVF6AEwZkfYC35JLp7bYSbpx+rEmHYcYvB3HJEIfy6n2GBrunmLIE3zPrBP6cQeayRTJGwGMkY4KezmHVR2x00d/KHvMNwne9IIlsOuV18mO18+UjltFMpmtUw8iTbAt8aSkNfI2aBPAzhDM/Wgq4OTu/cS41MXaNg4XgVxJ/HuShI6GimWcd4BhQS1bzzrn6ogcKCNQ6w24pzk+KTmYZtRukEBE5Y63HqqI58TIvKlURljWWYdveaSzOkPKAE9QpTD0LTq/R97WG/VU6hYzRPc7KQn7ZK87PZUpfLldM7Rh2N8oI00XgaZ1w1bT1UhlUwRqC5tXy11/2Mo0ytTjZnXXtzY41T722ssXS6qk8lx6C6oE3l46NQekCgZNsfXzyqFqZJLib6vIPz8hknZklDTHjvNJBoKmgx/UgqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(122000001)(5660300002)(4326008)(91956017)(8936002)(4744005)(8976002)(64756008)(76116006)(2616005)(8676002)(66446008)(2906002)(36756003)(316002)(66946007)(85202003)(6512007)(71200400001)(41300700001)(86362001)(66556008)(54906003)(6486002)(66476007)(1076003)(6506007)(38100700002)(38070700005)(85182001)(83380400001)(26005)(478600001)(7416002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHBqcXJnWFRwRHdLZzV2RkwvMlVQNWlKVlpNZ0o3bEtpMmhsenRFdm1GSGQv?=
 =?utf-8?B?bDJnWXlQM005djZQWGhuWHVOYnhXQUI5UmdDc2d4MzNzckpBUmdWZFRzR2h5?=
 =?utf-8?B?M1pIOTFWR2s4QitYeGYwT29PekJ2M3FvWWRRVjlzZUtrcWtKYWoyWnd4bkFz?=
 =?utf-8?B?MFBuS2xtbFJQSlZ1Wi83RWYxYVVBaGdINC9DTGtETSt2WWVScDJGTW1pSUR6?=
 =?utf-8?B?Y3NwWC9rUjB0UmVVcURUbit2MzFxTHZxVmlUQ0RpSGhVQS93bTRiTkNmd1lM?=
 =?utf-8?B?R3d5QWF1K3QrZjFDV012WDY4a3J2c3YyeTZpRVNMeklhSFZ3ckpyUndkTmg1?=
 =?utf-8?B?VzFFVzJGemNNL09FYjZ6allpSG5nblY2RERXaHRIQ1pKenljRWJmUGxlbGo4?=
 =?utf-8?B?WWZPalhWRmo1ZUZhTG4xU1BDcVprcHM3UWRXSHpFTFF5T1ZydExBUUdEWFA5?=
 =?utf-8?B?eTZTRHlQc2JKcEhFNFBTQzAyY3lOUkFTaHdmbXRES0I3UGZ3cmxFOHc1K3Rq?=
 =?utf-8?B?QklaYld0UzQ5OHNYdDUyWG1zYm9IVE55RW8wZmpQU2piMCtSL1hPdWU4ZDBo?=
 =?utf-8?B?UmpPYkZFWmhXTkZnbE5sVmdJVU1Xcnl5TlRRTXFIVlh5enpUM2tTNVRlV1Ju?=
 =?utf-8?B?WXc4VHh6R0E4TDdRWVYxQ1d1UzhwdXUweWNQci9FOVI5clA4YUlCZUpsanRZ?=
 =?utf-8?B?TTdUN3orU3JSMExheFlhQmNnaVFTdEJtd0xTUUxiTHlOYlVGZkllZ2NlWFIv?=
 =?utf-8?B?YmNFcW9ydmY1MDJyYnBpeUM5Ni81OVdGdW1FQUVvU0tGN0paWUE1OXk2ZFFB?=
 =?utf-8?B?RCtRRVpDVDZJODJWaitaSlRscTJkMklVT2czWWpkQjNqdXRkK0dYTm9qY3Y1?=
 =?utf-8?B?UUtSV2UyV3U4bDErOWZpNXV1S2dKTXJ1UzQrU2dxeHNOOGNDMUViUldwSmtu?=
 =?utf-8?B?b0N5WGZnc3BoeFJqTFpEL1FVR2dMYVc5WkptM1JkUExYbE1CajRxczRqczRI?=
 =?utf-8?B?U0E0dU9JYVM4TFFvK2J1QUlVMmdsVmtpVk9hVm54RTExZFFsWjgzSTkyVUFt?=
 =?utf-8?B?WGxMZy95L1NTMEx0M0N0LzRsQXZLTmdGUkIzUWJ1MXY1cEU4bmFVdlN6dm0x?=
 =?utf-8?B?UFQ0K01jOEpSMW1JM0Z1eStYU1RCa3NhQWI4cURBVXNIM2ZxaHFJcTNiajZ4?=
 =?utf-8?B?T1l0THNhdzZmWHVMY1VFdmdJWVpGdms3ZkZ0MmYwN0NHcDVUYjcrdU1jOW54?=
 =?utf-8?B?UUtHekkyM0NGaXh1a092SjBCc05DSHRoZk5IQnRSNXN6MjBUaXJ5MU8yejhW?=
 =?utf-8?B?T0lVS2wrY2xHRnNlWGpucFdSTzdtR290aGIvNWs4emFvZEhwZEVsOEpONGo0?=
 =?utf-8?B?a2RmZm9yam90RmdhY2M2UjNEZG05azg5SVBQd0hGKyt1R1JUekU0d014bUZO?=
 =?utf-8?B?ZGVnQ0tBRzA5YkpMMGFKVU8zVVNzc2hXa1hBNU5tZERpV1U4cEhWLzNjVEM4?=
 =?utf-8?B?Si9reXhYSGh1VVFFclVkb2pLTGV3YUxCeVVyc0p0Rk5tNnYyYWQ1MjVVdjZh?=
 =?utf-8?B?NmhrQnVJQ21SWlVWcDdaeHBxNUplWVdMNDVLMnNwWFpxcTg3T25vRXRzaE82?=
 =?utf-8?B?WVhDS1hUeWZPSUJhWG1EaytEWitYV2dmUGgxM25jU3ZyZXFJTXZGOU1USGh6?=
 =?utf-8?B?Mk1mYzcvaURFNjlmVGNJUC9uSlVSTmlkbGZQMlg5YXAxejhYTlhxTDV6ZHdv?=
 =?utf-8?B?akNjeGI0bmR3WGdCYjJzdTZDOVhmRitFck5IY3ZnREhLTVVvVFJ3Q0NqSmFh?=
 =?utf-8?B?cEQySUpnc2ZRU0Q1YTVoaTlteWpRYUxTcXRXWW9wS2s4YVpVSHFCZTVWQWx3?=
 =?utf-8?B?cW1iM0lvajZENS90K3Q0Tk5Ma3ZPcGszcEtmTHVxNnphMlZ4dnpmdTBKTkJT?=
 =?utf-8?B?MW1wT3pMMUt5MC9lb3VTZTZxdTdyTnI0dUhycDJlZW03NUhKMkN2b2lXVi8w?=
 =?utf-8?B?b0NmRVFvdlhFYW9yTmZOQm1iTHR6Vml4ZmVWb0FyZDN3RGRHQnZ4VjR4eE1t?=
 =?utf-8?B?RlljOUk0UzhiRU50a0dkUVg2MFJOZnd1SWhIVkpvYy9ULzMxNjVSMTU2UEZG?=
 =?utf-8?Q?A48yFYGpWYFk5KZxpaRDniQBe?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFD86E40E9CE0740923A4E85A7E3F989@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa2cd63-3f4b-4cdc-bce9-08da972fb91c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 15:34:05.0959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lx0Kakm7AJwY5ic38nS+V0gV3fdAtOxKCnJkTBJeWwrJH0ZR57sRc6n5ecivzA6ya92zy566q9yope0vWJuJ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7567
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTI6NTZBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdy
b3RlOg0KPiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiANCj4gQXBw
bGUgcGxhdGZvcm1zIGhhdmUgZmlybXdhcmUgYW5kIGNvbmZpZyBmaWxlcyBpZGVudGlmaWVkIHdp
dGggbXVsdGlwbGUNCj4gZGltZW5zaW9ucy4gV2Ugd2FudCB0byBiZSBhYmxlIHRvIGZpbmQgdGhl
IG1vc3Qgc3BlY2lmaWMgZmlybXdhcmUNCj4gYXZhaWxhYmxlIGZvciBhbnkgZ2l2ZW4gcGxhdGZv
cm0sIHByb2dyZXNzaXZlbHkgdHJ5aW5nIG1vcmUgZ2VuZXJhbA0KPiBmaXJtd2FyZXMuDQo+IA0K
PiBUbyBkbyB0aGlzLCBmaXJzdCBhZGQgc3VwcG9ydCBmb3IgcGFzc2luZyBpbiBtdWx0aXBsZSBi
b2FyZF90eXBlcywNCj4gd2hpY2ggd2lsbCBiZSB0cmllZCBpbiBzZXF1ZW5jZS4NCj4gDQo+IFNp
bmNlIHRoaXMgd2lsbCBjYXVzZSBtb3JlIGxvZyBzcGFtIGR1ZSB0byBtaXNzaW5nIGZpcm13YXJl
cywgYWxzbw0KPiBzd2l0Y2ggdGhlIHNlY29uZGFyeSBmaXJtd2FyZSBmZWN0aGVzIHRvIHVzZSB0
aGUgX25vd2FybiB2YXJpYW50LCB3aGljaA0KPiB3aWxsIG5vdCBsb2cgaWYgdGhlIGZpcm13YXJl
IGlzIG5vdCBmb3VuZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhlY3RvciBNYXJ0aW4gPG1hcmNh
bkBtYXJjYW4uc3Q+DQo+IFNpZ25lZC1vZmYtYnk6IFJ1c3NlbGwgS2luZyAoT3JhY2xlKSA8cm1r
K2tlcm5lbEBhcm1saW51eC5vcmcudWs+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogQWx2aW4gxaBp
cHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg==
