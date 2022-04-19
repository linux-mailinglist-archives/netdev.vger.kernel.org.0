Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5610A506D3E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243674AbiDSNN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344620AbiDSNN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:13:27 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20094.outbound.protection.outlook.com [40.107.2.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BEB2E9DB;
        Tue, 19 Apr 2022 06:10:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRqoINRO3cy6QfSItL9mn/NFfHgeVomUJxmAGpxTrdvFSSxjQ52VQpeIJOoTl/V7XMMY8f2Rob/Kk/SyHZNlG5Bp9WNR9P405Y7opREe/pOsJWrtEbmx9Hb8Q612ZjEIyix+bKVNmmSMsSkzAMqfST2EJ0eTWUFpeqSE9NsaFLppeEsKscX7sGLqRIAIJ5RFF+dHyYS1rPoDp4c/uk9WmCBISCA57rXKwMK9hjKixdG88WIsHDB6fvkLIWpcNzG1kssNbPM4fw2TRapxIr+zQ7G+XvNirCosOVmVUB+pk2zD8gDPAi7spGfKGvHFcL3CIwQ4kFzVP5ZgelYkYpXP0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cOBDgAFnkE7FeohmhnEWwYPUU3FMOg8YTvkcj1Hewo=;
 b=mJSazzLViiIQ48BEGAm0QHPo5WR1sTn5RTR17h+hKoo3UxqVuc8YenPjVuAFrIGE1HO9t0Xz2hd2bo5iI/yOg/D6QHJNQZ6N4OzWUUnhZ6GVwo65VNA4+dvkDRFfCK385HgH/K9kg4P3xERmk+ItaBbteBKPFYw2urtiF/VtaYmIcQJKbpivFkhk0x4Z3yoAzfHQkjzQDelht4h4QqrlAok1cKsheUEGEPk5q6uagnY5PaCHs6UWEbv+ITUZ5u8rukECragWTBCiQyhYN0ggtCsDIELB2b7poOPGk2JLfK2Ehnqrn2/zRcG92hm3E7us+1peqZ3Uo+Xo1/16oB4eHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cOBDgAFnkE7FeohmhnEWwYPUU3FMOg8YTvkcj1Hewo=;
 b=lpe1n83X9mAcoiwtbWrHyW7//uyD5d7wOiIwd8Yaom91CbrS8lREDkZf22chxl8bhiBcPuiaIjrtGkIj9GlPNaG6VNr1u1AvosN9ZLW9L0xnwlV93FnBMoH+3ESqCbNug7V/rwPrIMFQeDmzWW7VFBO7Cb+iNni1e6HGycCNpSE=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DBBPR03MB5160.eurprd03.prod.outlook.com (2603:10a6:10:f0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Tue, 19 Apr
 2022 13:10:40 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 13:10:40 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Thread-Topic: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Thread-Index: AQHYU30cVvAvKL/RyUaWN8kP+4vAsKz2ZyoAgADPlQA=
Date:   Tue, 19 Apr 2022 13:10:39 +0000
Message-ID: <20220419131038.7fb2f4pthsiyugho@bang-olufsen.dk>
References: <20220418233558.13541-1-luizluca@gmail.com>
 <41b4c9c7-871a-83c4-5df0-24b85ce0cb24@arinc9.com>
In-Reply-To: <41b4c9c7-871a-83c4-5df0-24b85ce0cb24@arinc9.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e57d478-11de-4e2f-927a-08da220600a1
x-ms-traffictypediagnostic: DBBPR03MB5160:EE_
x-microsoft-antispam-prvs: <DBBPR03MB51601AC69C3D44FCC4CDD1CE83F29@DBBPR03MB5160.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OofbdBASOPrMUXiqn075ipQTmwMuoxD+3Rz/2Gh+K0/BNCksPhDyn9N+pjdwfjOXmzIM1ap6+93NQUjrQTcPDxHt0p4mXJzW79Sw/bD4+QTQ1ytSmQ/I2RSvKzJHi7O8fLNpKBhEduzks4IQWEzKYiz+HuT/ow12HwyulseZfmD7nsJvDmukBvSeyH7uOvjlQYn2AzvH53XBevM8aZd93Twm/bIHxe7TGxQxJz3NuPQLMKPM9hog6L3XOPrtjyLQIUXb6nK4oDnuc1NP4x7GgXwDjo+d1RQ6cjTIU3d0AVqoVI3/XLRuuUsoamdfOHD111WKDTIftz78XabMyMxYV/ly4E/TYo7kqgsetM+W7tCnMM7Q/qs+G7zIn13Qaut+0vwHeuc+nwM6sPqXRLpoojQ/e12tfA09Tue0kYhqH/FTGincs60h1XmgTjR5ty74mWIzcmzKZ14rKD2TDQX17OVQqGCyXEprSUimuCLqh/7FEgonx0OKdoB3PAXR6CQPWAoAuFex185ZqPr3DG29n5OPweMzP6GZbcFq/BHCpQh/4L5LBE4nfDTa6XV3WXgZoC6Kn2rWxaJmW/nRcApazTpjE+LSU9NO6nayX48gLab++sBvTbkUQ/bZ7zBu1kN/jxqDYW8ijUsdncOiZKEK8eY7lsyo+EurTBrjViyZN5yrCrYtgkn4jR2mj/BGU3cpQzCtHE+NeTk2q6z89ibGi55zFRGq0buCOSlBoFbPLPKzR5WTpBl/VCETBeJ+YQppWi9GCTe41D+QvHKine9qfrYPdkrkfvd6StehNtotEYc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(186003)(64756008)(66476007)(66556008)(66446008)(2906002)(83380400001)(38070700005)(38100700002)(122000001)(8936002)(5660300002)(7416002)(8976002)(76116006)(71200400001)(54906003)(1076003)(66946007)(91956017)(508600001)(6506007)(53546011)(6512007)(316002)(6916009)(8676002)(966005)(4326008)(6486002)(36756003)(85182001)(85202003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEcvdllPR3Q5UDVRSXRSUzY3TFVBUEFTVVd5TzNndmVWSjIwZk5tODBlanhT?=
 =?utf-8?B?bWkxckJsallLeW54dXVOOWcxTS9tQkN2S1g5bUREdzBNaXhLR1NCczlHWUtT?=
 =?utf-8?B?VlpoNGhOT3BqbzJqeWFzd01KV0FrUHdRVnNvdW5QOVFTOGw3dlhDbmpiRkd0?=
 =?utf-8?B?WnR2UTJwdGYybDBYZkxsN0NnRkt6WDdYcjR1WEtUYWlLZXBNcHZFOGt5TUtY?=
 =?utf-8?B?OGFtRDhFOUtkamNnV1hEeTdnRCtDckgrRUdsay93Wnh0UzdlZTBZb2tvbnUw?=
 =?utf-8?B?NTZBbXVybEt2ZE9rUy83b2NYcjhHRnB1U3hWd3NvWU5rNFJpQy84UE51UmNF?=
 =?utf-8?B?NHM4RnNOdDM3Sm02bGRTVm5XN0xkTG5CYWVnTVdGT1NGOE1tSFRJTm5mUDZT?=
 =?utf-8?B?TWRyTGI2bWRTUHRjbVloOVFQS1dUMnFCNnhEd2F3d1YzaWxHbVk1R0txNDJK?=
 =?utf-8?B?c0M1SEU0aEUwM2hUcWZneDlpNHpXS0wxK3RNNWFqRVdnblRzOWVFbko3Z20z?=
 =?utf-8?B?dzZhcUpkT055Z3RxSnY5YlVOVkpXMnAvUXVXMFlxS1JBSkxvOStmY2ViTTZZ?=
 =?utf-8?B?amZQZlBoMmthUnlvUlczc1RCUWg1Q0x3RUdqb2VCQ3BUeWRSU2VzU3JVT0di?=
 =?utf-8?B?a1N5STV0OFl3RGNRa2ZnSkdxSVBPNUlsMmtyc0QzSFE4OWd3M0JPNzB2ZWxD?=
 =?utf-8?B?WDcyME5icVJ1V0FmQTNuaGcyYVhFS2dMdUlURWxUMHFKdXdlNWN1dUtPeUdv?=
 =?utf-8?B?NXRkdnZ2a1JsNm1MT1h4aFB2SVgzdW1yUGMzeHBzS0hud2RXUHR3Y2xLaS9E?=
 =?utf-8?B?ZGhtdGIrVk1mVTdrUVVMNFU3djgveWw1T1grdFVJSk93OUM0Y2k5NU9hVFl2?=
 =?utf-8?B?bkZIYkpwQVJqeEFwcFBEY21PQjAwekl6QmQ0UVp4R0tqOVg1bkEwaEpWUnQr?=
 =?utf-8?B?UjdCZVdpRDVCQWhrejl5K0N5SE1TeFhhU1RscGNPWG1kWFdKT2ZCSmFCd2px?=
 =?utf-8?B?b1ptL2ZpK3VnUzBJbWhqVGhGbUhZMm9OeFR2TGMzSzcwUnRDS2kzL0p0dWNM?=
 =?utf-8?B?Z1hBblRoMlVyTWthSDNVSVJDWDVuWG5aWVJUUFlHZFR0cVVITjBZVmhnNkN0?=
 =?utf-8?B?Rmx5TWFPZHVYQzVubjFlR25aRlhxcndFa1JZaVM4OUVtMUR6Y2xnTDBMc29S?=
 =?utf-8?B?RjA3QXl3Y2xFSkZlL25TVzFBYkVMTjc5L3Y0dmFxVTlrdFBwUm1SR2ZvMHA1?=
 =?utf-8?B?MzR3V2pIT2I2UEZ5b2I4UTVXNC83ZGIrMjMzZWVvdXhXa2FFSnR5WmtDcjV6?=
 =?utf-8?B?eGF3THRiNDhReGtEUFh6amVDb1ZrMVpXdGQrb0g3QUMvZVRpUXlrNXBrNmVQ?=
 =?utf-8?B?cEw0SWF6SWQ2V2Q1TGNZd0hIWFY4aGhoQVd0M0xlVlhQU3htVWlqc0YzU3dE?=
 =?utf-8?B?aElXZFlTVit1bndZMUdxYmtRTzlNOVlZT2FRS2tmU0VTMGV3cS90Q3l6bitP?=
 =?utf-8?B?UGlieWJkQVUvV280SkdPV1RtaXM3aC9SMmtVYnhQeTFPNm5NVWcxWjRUWW5D?=
 =?utf-8?B?UWd6dDlHUklIdUxOS0YxZDRvTWNEYnBuTkQxOEYwSGJqSWtlVndNcUJmRXZC?=
 =?utf-8?B?TU9mQjNNM1pZZXRvakNLazdjM0t0aHJrWm9Da0dSNHcwMkphMUw4QzBuaGZl?=
 =?utf-8?B?N1JBUHRGYUNncWJZMnZESDRSRFE2bzhEMUJ4cktSYnVyTUFlV1p5U0t3M0RQ?=
 =?utf-8?B?MjZudm1pTFZGRHRIbFRHdHZDeUY2cVJ4NVJGdGVLcDVhaFJPZUVhTVkyQkVG?=
 =?utf-8?B?d1ZMSkZxT0RUOVZDMGc4TGlWSThxZi9PR1UxTnZmd1d1NjA0RFZmUmpiTnRL?=
 =?utf-8?B?a1M1cVVhN1ZMYTFjNGRicnBtcEo0K3FHRG5CQ0JIZGxtcFpEYmVZRHhCNDk5?=
 =?utf-8?B?TG82UXJ0L1d0THNzcG1ORzdkZHV2MDNUK3BDNjdreFo1N1AwYm44bElJOVRj?=
 =?utf-8?B?NGVDelJEK24xSUtBUWNlZkVVUmd0bHdrOUVMY1BWZGw2T2I1VmgwTlErRDlk?=
 =?utf-8?B?OUVuL0l5NnlaejF5ZmNGbmtCMFErNEQwV1NZckVIV3V5Y2E5RVd0SWpXSity?=
 =?utf-8?B?R2hNOW05dFRKNjNmTVpTSVdsMzRLT1NNTm51YWRaL3pBdVc3VVZabU9nendX?=
 =?utf-8?B?bUIxbGh1N1p4ZEYvc3pEa1IwSC95OStkWUR3ZWFmVkZ0OHZqNm0zaGUraGd4?=
 =?utf-8?B?OVhNd2phbkx3MVJ0Z2gya2UrK1JpaDA5aE5hRFA0RjlPUjk2VnFZRFR0N0Zn?=
 =?utf-8?B?d014NnE1OXRWRnpRclhOVDRvbGo0NDhUNDBYblVDQkZIZkFhUUFpU01GR2Nk?=
 =?utf-8?Q?EduJMZmAQJGQ+qk0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C51B7360D753EB418CBBC98ABF4D83DB@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e57d478-11de-4e2f-927a-08da220600a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 13:10:40.0989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9iupjUMIB8uEXEO3eotQO7IWMCVhV3OxswxkLZoiWOtsBmMIa6F7OUarmbJOBIL2QaqGKGChvsxt0w4b2N6jaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5160
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBBcHIgMTksIDIwMjIgYXQgMDM6NDc6NDBBTSArMDMwMCwgQXLEsW7DpyDDnE5BTCB3
cm90ZToNCj4gT24gMTkvMDQvMjAyMiAwMjozNSwgTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSB3
cm90ZToNCj4gPiBDb21wYXRpYmxlIHN0cmluZ3MgYXJlIHVzZWQgdG8gaGVscCB0aGUgZHJpdmVy
IGZpbmQgdGhlIGNoaXAgSUQvdmVyc2lvbg0KPiA+IHJlZ2lzdGVyIGZvciBlYWNoIGNoaXAgZmFt
aWx5LiBBZnRlciB0aGF0LCB0aGUgZHJpdmVyIGNhbiBzZXR1cCB0aGUNCj4gPiBzd2l0Y2ggYWNj
b3JkaW5nbHkuIEtlZXAgb25seSB0aGUgZmlyc3Qgc3VwcG9ydGVkIG1vZGVsIGZvciBlYWNoIGZh
bWlseQ0KPiA+IGFzIGEgY29tcGF0aWJsZSBzdHJpbmcgYW5kIHJlZmVyZW5jZSBvdGhlciBjaGlw
IG1vZGVscyBpbiB0aGUNCj4gPiBkZXNjcmlwdGlvbi4NCj4gPiANCj4gPiBUaGUgcmVtb3ZlZCBj
b21wYXRpYmxlIHN0cmluZ3MgaGF2ZSBuZXZlciBiZWVuIHVzZWQgaW4gYSByZWxlYXNlZCBrZXJu
ZWwuDQo+ID4gDQo+ID4gQ0M6IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnDQo+ID4gTGluazog
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjIwNDE0MDE0MDU1Lm00d2Jtcjd0ZHo2
aHNhM21AYmFuZy1vbHVmc2VuLmRrLw0KPiA+IFNpZ25lZC1vZmYtYnk6IEx1aXogQW5nZWxvIERh
cm9zIGRlIEx1Y2EgPGx1aXpsdWNhQGdtYWlsLmNvbT4NCj4gDQo+IERvIHdlIGtub3cgdGhlIGNo
aXAgSUQgYW5kIHZlcnNpb24gb2YgYWxsIG9mIHRoZSBzd2l0Y2hlcyB0aGlzIGRyaXZlciBfY2Fu
Xw0KPiBzdXBwb3J0PyBTbyB3ZSBoYXZlIGFsbCB0aGUgc3dpdGNoZXMgYWN0dWFsbHkgc3VwcG9y
dGVkIHVuZGVyIGEgc2luZ2xlDQo+IGNvbXBhdGlibGUgc3RyaW5nLg0KPiANCj4gVGhlIGNoaXAg
SUQgc2VlbXMgdG8gYmUgdGhlIHNhbWUgYWNyb3NzIGFsbCB0aGUgc3dpdGNoZXMgdW5kZXIgdGhp
cyBkZWZhY3RvDQo+IHJ0bDgzNjdjIGZhbWlseS4NCg0KU29tZSBvZiB0aGVtIHdpbGwgaGF2ZSBh
IGRpZmZlcmVudCBjaGlwIElELCBidXQgd2UgaGF2ZW4ndCBoYWQgYW55b25lIHRyeSB0aG9zZQ0K
c3dpdGNoZXMgeWV0LiBDdXJyZW50bHkgdGhleSB3aWxsIGJlIHVuc3VwcG9ydGVkLCBhbmQgSSB3
b3VsZG4ndCB3YW50IHRvIGNsYWltDQpvdGhlcndpc2UgdGhvdWdoIGJlY2F1c2Ugbm9ib2R5IGhh
cyBhY3R1YWxseSB0ZXN0ZWQuIFRoZXJlIGFyZSBzbWFsbCBkaWZmZXJlbmNlcw0KcGVyIHN3aXRj
aCBidXQgaW4gZ2VuZXJhbCB0aGVzZSBkaWZmZXJlbmNlcyBkaXNhcHBlYXIgaWYgdGhleSBoYXZl
IHRoZSBzYW1lIGNoaXANCklELiBUbyBnaXZlIGEgbW9yZSBwcmVjaXNlIGFuc3dlciB3aWxsIHJl
cXVpcmUgYSBsb3QgbW9yZSBkZXRhaWwgd2hpY2ggSSBkb24ndA0KdGhpbmsgaXMgcmVsZXZhbnQs
IGJ1dCBpZiB5b3UgYXJlIGN1cmlvdXMsIHlvdSBjYW4gY2hlY2sgaG93IHRoZSB2ZW5kb3IgZHJp
dmVyDQpkb2VzIHRoZSBkZXRlY3Rpb24gYW5kIHdoYXQgdGhlIGRpZmZlcmVudCBwYXJhbWV0ZXJz
IHRoZW4gYXJlOg0KDQpodHRwczovL2dpdGh1Yi5jb20vb3BlbndydC9vcGVud3J0L2Jsb2IvYWFl
N2FmNDIxOWU1NmMyNzg3ZjY3NTEwOWQ5ZGQxYTQ0YTVkY2JhNC90YXJnZXQvbGludXgvbWVkaWF0
ZWsvZmlsZXMtNS4xMC9kcml2ZXJzL25ldC9waHkvcnRrL3J0bDgzNjdjL3J0a19zd2l0Y2guYyNM
NzEyDQoNCj4gDQo+IEFsdmluLCBjb3VsZCB5b3VyIGNvbnRhY3RzIGF0IFJlYWx0ZWsgcHJvdmlk
ZSB0aGUgY2hpcCBJRCBhbmQgdmVyc2lvbiBmb3INCj4gdGhlIHN3aXRjaGVzIHdlIGRvbuKAmXQg
a25vdzoNCj4gUlRMODM2M05CLCBSVEw4MzYzTkItVkIsIFJUTDgzNjNTQywgUlRMODM2M1NDLVZC
LCBSVEw4MzY0TkIsIFJUTDgzNjROQi1WQiwNCj4gUlRMODM2NlNDLCBSVEw4MzY3U0IsIFJUTDgz
NzBNQiwgUlRMODMxMFNSDQoNCkknbGwgYXNrIG15IGNvbnRhY3QgYXQgUmVhbHRlayBpZiBoZSBj
YW4gZ2l2ZSBtZSBhIGZ1bGwgbGlzdCBvZiBjaGlwL3ZlcnNpb24NCnZhbHVlcyBwZXIgc3dpdGNo
LCBidXQgZ2l2ZW4gdGhhdCB0aGUgdmVuZG9yIGRyaXZlciBpcyBhbHJlYWR5IGRvaW5nIHNpbWls
YXINCmF1dG8tZGV0ZWN0aW9uLCBJIHRoaW5rIGl0IGlzIHNhZmUgdG8gYXNzdW1lIHRoYXQgd2Ug
ZG9uJ3QgcmVxdWlyZSBhbiBhZGRpdGlvbmFsDQpjb21wYXRpYmxlIHN0cmluZyBmb3IgdGhlIHN3
aXRjaGVzIGxpc3RlZCBpbiBMdWl6JyBwYXRjaC4gVGhlIHZlbmRvciBkcml2ZXINCnNpbXBseSBk
b2Vzbid0IGhhdmUgYSB2ZXJ5IGdyYW51bGFyIGNoZWNrIC0gcHJlc3VtYWJseSBiZWNhdXNlIHRo
ZSBzd2l0Y2hlcyBpbg0KdGhpcyBmYW1pbHkgc2hhcmUgbWFueSBzaW1pbGFyaXRpZXMgLSBzbyBp
dCdzIG5vdCBwb3NzaWJsZSB0byBpbmZlciB0aGUNCmNoaXAvdmVyc2lvbiBJRCBwZXIgc3dpdGNo
Lg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg==
