Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A555B9EF2
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiIOPfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiIOPe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:34:57 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2117.outbound.protection.outlook.com [40.107.21.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C93E2F388;
        Thu, 15 Sep 2022 08:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akrs5q5OKvlPciQSpzONA+K29uCsW9Rcx4JMzvSZAXr3E079Q0ljDtZUx142aimPsrNkICFMeVjoRK7VpoQvLKCsR3NeQp5pYJWBHdQm+YcU3/4wlJGD0mbvxayO1qM0u4nCX2/zhOvYqAYE8ut41q2is8gEi8mYcvrtPBO9d5YtnW7JmCLyyOoOBQpeLSkWcMJG2Bfw35cwhcQKocMAZ6H2jIKmlPz3XGM6wx8wvoc0mevDE/A4FAeeywfdoeDUm7R5Aiy02KSsclkD6l1ATRpVq90+dgkbE8+APM7ZHRRlVm1ywjvvFvGTjhGWGctiaxAEhu5+7yjF+HmZXsGiJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmhQS2z65+HF5Ulz34wGjUkZBR/4coQrpYLWa3C0VRM=;
 b=OD7WdwOShXqLbU16MUgTEClgiN1H2GwX+Nz6fYNExKcyI2EzVN9KL81kATWy8KQW8+tF29lpr+6oE4LIL2XNrwwQAOgdywcJcqITF2055QZYes3r2XAxr/61KV6OO39xu4mB1synUNOHrI1cGU5nSSXJWXEmwpyfemeV5G0nNgjskzLh1kP01U4QvuA/P1zGYgNU9Qoc2V5H/d21DHDnLJxw0fZt/qY2IideP/qOVnRNUhIh7eoBvz9L9pSRSepafk/eXr7GPq8Lpf2GdoR9++VmtcGSsu72kE4pU1KhWJNMhN6SC9FkRvlvCgghG9U4Tv2rYxGO/iYIim1uW1u0cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmhQS2z65+HF5Ulz34wGjUkZBR/4coQrpYLWa3C0VRM=;
 b=aKYveKrOKfntZ9Smeywc0I32/WUCxuaSvD3Z3gGMIF2FLz6OLigUYccSCf/C8TbBiMMGbQV1DRPMhEHxMFKS5qhIdSOVjAQHQaOoCh2JgV09OP4+mLbVgqjatiqnawtQE4OHvbLbUVK+ie3VUfHgyGpa+oED3fBXXvMpjbNV2HY=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7567.eurprd03.prod.outlook.com (2603:10a6:10:2c4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 15:34:47 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 15:34:47 +0000
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
Subject: Re: [PATCH wireless-next v2 09/12] brcmfmac: msgbuf: Increase RX ring
 sizes to 1024
Thread-Topic: [PATCH wireless-next v2 09/12] brcmfmac: msgbuf: Increase RX
 ring sizes to 1024
Thread-Index: AQHYyRivcYQyqM/U0EikX8IuDFPE8Q==
Date:   Thu, 15 Sep 2022 15:34:47 +0000
Message-ID: <20220915153446.auypqpee2luhrlij@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg82-0064vT-HX@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oXg82-0064vT-HX@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB7567:EE_
x-ms-office365-filtering-correlation-id: 505d8966-da61-4629-0da9-08da972fd257
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6DYZK7hDiUCQWJeduWhKXWxAylC5eVcMSqxHRtGjI9+1CFX6RBjAa95VguMtl3lt9CKVn8efY/8v6gMCGfL0woxzDR5qdk1sgw1wdf9k5r5l5gDxHK51IFzUQmmnmBUz7PPjROv8Da/7v9L0row6mvuNOPAKdQn+5ZnA3kIi+43fr5JT5zWJMfWt2af8LDOzvF4mmbR8HvbK7WO0VJGDjpN560pTEjYb6ws0rMpwNHElZxLfP8BfVxa+/x9HujSeda0k1svBtCYQX/auISYZ26pd/UGQWS8Q28vK5sshoprZj3YaLrRdu5HOLWhuA+Wde4oaE5RzhwYWT/iLGbVXHzmxpr7yZJHTGLLldVyuS39Izv2sG8ClG9OCFRg7sxEVU6dTKWn86GXh3ClXTkAMdut3a+5qT4XEPkaTkWKtBCkN5XCDnPir4yxjNet1iNeucU0SI4Qp3rCHJygeNVy2HridwE3KtHrwC6IPl+4LfJ3dxYxP4aNAvqsz2HVYl1aZoWxvfE7+b00FeWP5ypHNfzDhbCQ/+RHHwUhcWJzwJNjtMr9B3TTlghsql3KivVwn1ApEo/ZXSWva3LKpbnDYnvjJ34XHIFWwFDm2iEaMB5H2MJEjBb+GXpgc7cBfFQ2rrwOIcdPass1dPb0H4EoS7QVu4r7j2/MyshuN120444ckfsK+lSpq/Q+upMugCJUY4yTGhIMcFFtvmaHpBe7HBPOAqvirxht1a8hp8B3aYGmuLczsyFBnKek79wzxk4eliXS9nQvBFe6JwJx1WjK6bQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(122000001)(5660300002)(4326008)(91956017)(8936002)(4744005)(8976002)(64756008)(76116006)(2616005)(8676002)(66446008)(2906002)(36756003)(316002)(66946007)(85202003)(6512007)(71200400001)(41300700001)(86362001)(66556008)(54906003)(6486002)(66476007)(1076003)(6506007)(38100700002)(38070700005)(85182001)(83380400001)(26005)(478600001)(7416002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REZLeExTaWdzODduWXlMTHprT3pJRzEzbXhLZWhsM1FPaTg4UjVySld3dTVS?=
 =?utf-8?B?RDVkSkdYYytob0lHOE5xSjNib0tNaXFhUVh3NHlhMFJLK0dkYTRHUWVQalYz?=
 =?utf-8?B?NVZvUFRoSzAzcDZtWWFSUTduMnJSWlo0bzh6akZGaElFRndBTkU1OTl0T21D?=
 =?utf-8?B?WTR0WFNITGZuU2krODg4MFJLVkd2RnVoVFA0Ulp4ZXR1UFZFMFFTUlNRRGtK?=
 =?utf-8?B?Z3BSRkVHS3Z0a1BxZXhmYmFoRkxFbkV3WFZWWEEvcXd1NStpRXlpYnEycm1I?=
 =?utf-8?B?bExJMnFYNXdIZGpJNGZXYXFxZ0tGelFrUVU0TkIzdkN0c0xJQ2dWWjE1YmV4?=
 =?utf-8?B?UUNaM0JkZWVxTzM2b1ZmUFhtUTVGM0UwZG8rZXBOeHdEQzZNRmIxRVl2Nnpy?=
 =?utf-8?B?bVgvMmMxNmQzdWczNU14OEExWU1ZSHRYVjRmUWo4aGJNTWdqb0Y4c0h1aGFa?=
 =?utf-8?B?U1FzUmFxK1B4MzAxVWo0QVV2Ykpnb3lLR2dOeXMvMzBrS1hJVUJqNnBiZFZy?=
 =?utf-8?B?a1JON3d6TDlqVVZsUjBqeG5OZVdLZGxBY0hOa013S0VyNVdCVzdrNW5NUmJw?=
 =?utf-8?B?ZFM2cjYwcG5nTXBBejhOSk5rZ3BVVnk1UkRGUk5SMGt2ZG1SYzhVMlNoYjdo?=
 =?utf-8?B?cWRNcTdwL1lVejk5YmFWY0NkcitZeVFJdVFuU3Nnc004MWJraHFxRGZROXZk?=
 =?utf-8?B?Q0pJd2NvUVhZMlhtektUL3I2M1FCd3QwenpValJGWnNpcm5aSlcyTFpRYzZI?=
 =?utf-8?B?aWlVd0RmQ2I1bnRJSnRMWHczV2xiNlRYTmNNQTF3VHJ4b2NlOHE2SXEwdkFZ?=
 =?utf-8?B?aVdpMzZzY0F0WkxZUStrRnFBeC9lTkk2N0JGeEN2OHdQMHVjTnBvTUVFQVlh?=
 =?utf-8?B?bktzcGJnUVBIUzNCNjl6VXNuMHVCZTFLRE1DcW5YYUgzZmNmTHdJbUpDTVc4?=
 =?utf-8?B?akhYNVZURTdxdzhEZy9XY3lYY3BJaHNOdGU0dUJ4TW5xUmFCc1ErZWQ0WkY3?=
 =?utf-8?B?TkhIQXV1UTZhMUZSTVpnaWFjMkhFOTlCb3pvYWNKeEFTekVPa1AyRlRyKzFM?=
 =?utf-8?B?allna1diRm9TbWRsSFNwNW5FTmpuM3hUMDNXdkxENXE2WVJQclR6OHpPSUg5?=
 =?utf-8?B?S3llQWkvY1llRFR0TktaRHpxcTlQeWVMUmxyd3d5VUMwK1MyVU5ZQlN5RGJI?=
 =?utf-8?B?eUxMOWlJWHRhN29pUjFTK01NK3BSYVBtRjIwR21VMlM2VXZqV2ZWT3RvY2d0?=
 =?utf-8?B?RXpENmtDeDVhNlJFUHJXUVNXRzgyQlVRTG12OEdnRkJVdEkwdDMveU41dTE3?=
 =?utf-8?B?OTQ4MnhhU3VvK2ZTRGxCQVhjbHRTMlFTZGJFQ0toTXpsU0lXaHZzeDZIcm9n?=
 =?utf-8?B?NzVhZWZiVVppM2hJWXlpMjQwN3dIeVRKY3ZoRkJEU0pMaFltbW5wKy9QbTZU?=
 =?utf-8?B?Mzk3a2ZnWmRnR0E3Y0FCOHBCRlROTHNFbVNnME5JdWErS3k3YUFxS21mdEtq?=
 =?utf-8?B?bTVwNWc2RXc1YWoyOVl1bm5keTY1NVVHS3Q0STdieFJaMFpJZzNZQXlmT0NS?=
 =?utf-8?B?N2V3VDBEcFJqZHo5Yy9NWnVHYzE4NTFIMnZVa0RUaDMzQjhqNmZvc3NRTDVR?=
 =?utf-8?B?S3NJbkJiTlhpL29scERHQjMxSWZyS2swakNlRTlvU1ZtWDVaRzhEcGl5Sk1x?=
 =?utf-8?B?Y3hNN3ZwZk9aUzNDazAzRjBSbFZGakoxRHRXNTNwYmNlSDdKOCtrQUZCYTY2?=
 =?utf-8?B?R1g3S0gyVmE2bjd4VlFIeVIvakhkQnJMNGQvbi9yT0kxOGsveEVmN1ZIYmhk?=
 =?utf-8?B?WS9sOTNMWFIybnI2NHhsNHBxYTFHK252SzFKRk4wWU1DUkkzTmtSQ3RxbFk1?=
 =?utf-8?B?Q1gyNitlL2wySWh1YUx4NVhMdXJtcHF0WGFacENRS2JQUUltZTlvRi85ZDRh?=
 =?utf-8?B?MzBXc1BNaDBLd1JVa0MrSDYrWVZubXR1Mk5BZnY5TzdPSUZSaG9UNDI1cS9C?=
 =?utf-8?B?cS90b0Zzbk1LUDlJYVRJQlg0OC8zdXN6V242R1ErVkJFTUdvcGgxQzVqa25k?=
 =?utf-8?B?amVQQjhRWFlFZW9MVGxLQWpNeWRzRTZlUTdReW54NW53ajlMcVp5bFFIUks5?=
 =?utf-8?Q?fwBB7lUchGBGYTtrT1HMR9vRw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21808D52C3CE84488EC156DE11DA3333@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505d8966-da61-4629-0da9-08da972fd257
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 15:34:47.4055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SeTa7oj96Niild4F9T7a1PiG4mVPVy5sfC0EFr5US3uBr7E6PonvtcvhCUpxaC8q+6/U1bCIJw79JG78YyXuLA==
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

T24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTM6MjJBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdy
b3RlOg0KPiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiANCj4gTmV3
ZXIgY2hpcHMgdXNlZCBvbiBBcHBsZSBwbGF0Zm9ybXMgaGF2ZSBhIG1heF9yeGJ1ZnBvc3QgZ3Jl
YXRlciB0aGFuDQo+IDUxMiwgd2hpY2ggY2F1c2VzIHdhcm5pbmdzIHdoZW4gYnJjbWZfbXNnYnVm
X3J4YnVmX2RhdGFfZmlsbCB0cmllcyB0bw0KPiBwdXQgbW9yZSBlbnRyaWVzIGluIHRoZSByaW5n
IHRoYW4gd2lsbCBmaXQuIEluY3JlYXNlIHRoZSByaW5nIHNpemVzDQo+IHRvIDEwMjQuDQo+IA0K
PiBSZXZpZXdlZC1ieTogTGludXMgV2FsbGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8ub3JnPg0K
PiBTaWduZWQtb2ZmLWJ5OiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgKE9yYWNsZSkgPHJtaytrZXJuZWxAYXJtbGludXgub3Jn
LnVrPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1
ZnNlbi5kaz4=
