Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F53B534A6C
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 08:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbiEZGk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 02:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiEZGk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 02:40:26 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140059.outbound.protection.outlook.com [40.107.14.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44489ABF6B;
        Wed, 25 May 2022 23:40:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCRVBU7PXjPSJ3tqKKcPCtkmYwLtCThsYFBpbbVMHqZUN6U9MajYPGkQ541fyDwQ2Iud8QXM2HGiSYzcPtMEa7fUHvmdcOfDimCvk6YedYEi1IqogQ3tvfacy8mEjXu4gooizEHVw2RyyRolA1qBCfEDGKu9P83l2Vr8BCqOKx+Tq4B1Yx8Su5370H90HP15qz1iSWX8yoZFZu/cd/pHvf+xBn38Ezmeb8uWZCLp1LK9j5tBBSrECQ4LrmpazYJoEuzSxTBVSfPJMEQ0ee26+CgdANHCeIc5PBPs6a8U0LeEzsSHRay98ag0wDKXZHXfxgfVVIElmoCUkZ+ULLqatw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFXQ6Yhjj6j3B22rn6Q7X+3/q2n/+ko09Yst5LEvGic=;
 b=Oz6jMlQBCsFWYoMpSfScTmQCQqU2jwhZmilNp6IqCQommdclXJ0DsLFjeXEPsMIxoE1SSsrE9FlS+IPlHPC32+8B0GmCxEeVyWO/+n5Y9T6MImkcMMEf/WdP2pHufVE3i+GD8IDF7HnHqzfMPEYEEyEhMwenBcxV2TsrYxGfIByPtTRIO8RMZ6IEE9Vo4MAsMrF48QSHEOTW0YAp2ERGdM/ACTtVr/0Vu2/ZzBq2cQMxG6gPnVHIVtYrv9YBQSIPmPqbRg16ca8LJivt+Xg0j+AVXdnSZcGe2icNCKUNpTFdz0J3opLFLS4duqIj5mJ8G6hyoqjKb1ATJgAWVVWMcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFXQ6Yhjj6j3B22rn6Q7X+3/q2n/+ko09Yst5LEvGic=;
 b=JoFbDwz7VP2xhMRZwuUF9UWBCsucEAQljxzidj2ee/fzk+GKskLb5m7sczfWPW08yPMcvewn84ch4J0yNOEqbHwP4zN8rLvn3bUD0jkz9IqRsOHT/Hccd++nlZyMunuDSMUixtPKFlzVA9XSP0Ytw3RFTv5FqF2k9Rbwci3xSZU=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by GV1PR07MB8335.eurprd07.prod.outlook.com (2603:10a6:150:1e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7; Thu, 26 May
 2022 06:40:22 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::d4db:2044:5514:6d25]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::d4db:2044:5514:6d25%7]) with mapi id 15.20.5314.006; Thu, 26 May 2022
 06:40:22 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yannick.vignon@nxp.com" <yannick.vignon@nxp.com>,
        "xiaoliang.yang_1@nxp.com" <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "rui.sousa@nxp.com" <rui.sousa@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Topic: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Index: AQHYYR3WrsP3fgIutUOWZHiGk9ZeJK0Rv+sAgAAGWACAHqypAIAAYcmA
Date:   Thu, 26 May 2022 06:40:22 +0000
Message-ID: <cd0303b16e0052a119392ed021d71980db63e076.camel@ericsson.com>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
         <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
         <20220506120153.yfnnnwplumcilvoj@skbuf>
         <c2730450-1f2b-8cb9-d56c-6bb8a35f0267@ericsson.com>
         <20220526005021.l5motcuqdotkqngm@skbuf>
In-Reply-To: <20220526005021.l5motcuqdotkqngm@skbuf>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dd06b46-f5e6-42ca-e92d-08da3ee29bbc
x-ms-traffictypediagnostic: GV1PR07MB8335:EE_
x-microsoft-antispam-prvs: <GV1PR07MB8335CD9A9084376547FBBB3BE1D99@GV1PR07MB8335.eurprd07.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PnUpQMm9U5hGWvwIdED6j8SPkmaDz+N7ydiiKZOaObBxiRqQG90oy2QiND5Sa6rg8nNSflXu5dmD2kOlL76JZqpTwKSJo7TYfBPQIfPmj/RCaTXhJdSUmJJhHo6fT0ahVTsh5AoE2uRzpWEAP4hdDAV2xShQ3ILnlZqrVGpID6MQNs8NZOOemnotQZTCIa7MkrD7+EiBNPYREx0j3qcbgzY2jYTWMzj/vffD+EvEN5/YFKxE9to0h7Y+yqDsm54mfcosnZUt6mZsRzxvuGXJNmAIKi8kUoK7AQbb9RqugHuqxsw4viqhxFT8XjftjuDdxqQhO3QO4iC4S0Fp7h08W+EpCsLjYoAEwVJLjvorZ7mnUP1GMsszYiEZfC2sRlZXy//Hy0X+pGicgGinowVFdZPyWoRIuBxhiOqlBaG76+nLy722kplxUFkiRBYBUStZ13sxjjcJjcThiw34bcVyIecpUvf4USS6MWNfnQo0X1MJ8KW7jJ7C8bxNcCt3kptXTIJt6l98EEsjF+vUPrvFvCzdNhHS1e4e0fXZcz/DuNzEIkrXPQVKlKpA3fq0TOmxADUKtld1nNmhEUyzPgTNYzPhdftL6zZymdUVwrJFNtCgWEkt1T7cF6r4cfiyVxZstKfGbmE2q6QiBLNukrhua22I8vMP56rL2wWD75XCA9MCkQWEkk8jiXaBo/XA+jpCiM2OKjyz7CbSfqZN08UmMWxoW8SHJNYZAYTTS1k2NHDpyEYI9qAP1aFnSl4Iljg/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(4326008)(5660300002)(8676002)(44832011)(7416002)(8936002)(54906003)(66446008)(6486002)(66556008)(508600001)(82960400001)(64756008)(38070700005)(66946007)(122000001)(2906002)(83380400001)(38100700002)(2616005)(36756003)(316002)(6916009)(186003)(86362001)(76116006)(91956017)(26005)(6512007)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1JKcUZCY0plWHVwY2d5UEQ5MUN5clNDaFFaVXU4bHF1QmIweWtjRW5tMU1q?=
 =?utf-8?B?aXBlTmptbFV2dFd5WjltcFY5clJvcHRwcHBnbm1LTUovN3hKclZ3RWl6ejE2?=
 =?utf-8?B?NDMxRnJXbkhuTjZiRDlVSnNXV0o3VUtjWEFPWnZ6WU5wN1M4a0QwcFRnY05W?=
 =?utf-8?B?M3AxRWM0eVRVemE5UDJTZ2Rmb1ZBdFh1VmNMaHVoUk5JZk5kQlpXMkxLN096?=
 =?utf-8?B?UE4wWEphTWh4RisrdHcwT1JhYXZHWmh0Nll1R1NVa3JaRU1iRVRVL2UrSzZL?=
 =?utf-8?B?VkFBd2VuTzByWWdEMXNTOExodjc2czcwVnJSVlZjdzllbUlmRzNxNFFnU1d5?=
 =?utf-8?B?bFNpT2QrRkRMWGlvRm81Rm1adFpUZ2FiWTZPTnJLVWxIZmphVGl2T0FwV25O?=
 =?utf-8?B?UGtzK3M3ZHN4YWpVZjNjSmRUbUxlK2cwaHZuZXR5MWRsMUJXUm8wTEViUmlz?=
 =?utf-8?B?cHlINlhzTy8vUzdwV2NxY3FTc0Y0ekhNWmNTQmJhcTNLNExZRmdKTzZPYUE2?=
 =?utf-8?B?L21IamhaQ205a2pralZiWm9ZMjFINnArZDBuTm9BWDVvZUtORFE0ZmpReVZN?=
 =?utf-8?B?TzBjK2xwWStnREh4Q3ZUeC9paitTWThLbFB0aitHR3RaZ001dFpjanBuL3hk?=
 =?utf-8?B?UENJejhrcUNETEY5ZlAxS0NqTWxLNlNVWUI5U0lnREo5THVFQnpXYjE4b1pi?=
 =?utf-8?B?dTUwMFljZ3RVVDdKNVRLR3dPZHMwUS9yN1BtSEYva1dSNUFWYldOQ09yMitm?=
 =?utf-8?B?cldTeVN0MHJNMU4wR1pjc0doSkgrclZnVkJWRUFUd0ZLMndSSC83WkpPMVRh?=
 =?utf-8?B?bFg4ZU5GeVVLcDdSRGVKS1pmUGVzU3Rta3phRHN0RHd5djhKdk9raHN6c0Rr?=
 =?utf-8?B?Y1NTMTVzVWJNVkwxODdueFpjZEdWUm1XMlFPSDMrZE8vdzZ4alo4TXZOQVFm?=
 =?utf-8?B?akVEV1U1bWszcFROZVlkYWo4ZHNUMWJiUlNXcDRqVE5aTmdMN2lqU09mRzdj?=
 =?utf-8?B?VEpFWUFtbjIxSVVsai83VmlqZHhzOXltWFBmajBnMHVRcTZDTENGWGtXZExW?=
 =?utf-8?B?VDlWNm53dktvMW9WU2YxeGxvRFNaVE85WVhBUm9rYWhBMHBYSVQzOGZ1aElK?=
 =?utf-8?B?OTdYSG1SNjlEcTlJTmVzUzB6MWRJME9iVDZYV3YwSFdQOUdIMnBobzhnVDNI?=
 =?utf-8?B?bUl4SnRWZ0NGaDhCdHdYeDFNZmVYQmhqakZvMW5uYXdzbEFIQ204NHE5NEs0?=
 =?utf-8?B?VG9JZlljbWdsUndGTDNrTlhqSVFPeWN3REhGVGtvYTVqcThOOS9vYm9yQnFp?=
 =?utf-8?B?bVZQOE84YnhBdG5lR0s4S1dMaFVJZXhBeG8weFNOVHBIVmtWQ3VJZWU4RUF1?=
 =?utf-8?B?TUFvL2p3dk9HM0V6RUYyWWIvTXdhcHdtR0IwVGFIaCtoL3d2UXh5MmIzTlQv?=
 =?utf-8?B?ekN5cG5ybTdQT09uaE1lQ243V1Y1Snh1SVJlVktuYkE2RUZJdW0zbkEyZEZh?=
 =?utf-8?B?azFGMDFwMHYxTVMwN3lzNkdyNWwxOTdEeWlSZjhwMGhGNDZEYk5CejJRWnY0?=
 =?utf-8?B?d0gvZ0FVUzE3eEJtR0J2b25GNGFYeWZ6SnNnZ1ZrY08wSjVmWFdzeVlUVExt?=
 =?utf-8?B?d2kreDVQeDVOSjZ0VjhRM0RKVzd6MjRUT0U2VXozaGtsTlZRdER0cDFUdHIv?=
 =?utf-8?B?VitWODFyYmxpUzNubUtHa25nVjhJTWp0THlhd1loVWlsbTlGdEE2dlJxMjlx?=
 =?utf-8?B?OS9wQnhyc2FoMjJHRkk2cEE0V3NWRzZUM2hEMXBRbllYeVMyeW10cVJQTG9z?=
 =?utf-8?B?cVdZVng3eHJPazUwaVJsbkk3dHJycUtFRlRtTkFPaTI2R0dpSUtnRzMvNCt3?=
 =?utf-8?B?SlZVWFV6MjdpbDFTWHJSUThwOW9ENDVHQ3cvKytybVllSjVLZGtveFN6eFlG?=
 =?utf-8?B?SlZwU0lSVWFCVW1td1Q0dHluUTZLTm5SOVE0a2VhK0tHUVdQd0QzUkluWkxI?=
 =?utf-8?B?WU9La0YyWmJHczZ0U1UxQ1c3c3p6QVJiZ1p4Y0g4clhhbWI0cGdqaEt5cCtv?=
 =?utf-8?B?Q1JkQWZEMW5ONkhPTVlBbHRmQXF1aDJyc2kzd0s0VnhualdDOGNoSEdVbGpI?=
 =?utf-8?B?ZksrbEF4cit1am1maUlac2NBUVlKd0lqMGpBYTBBdmxWWndQd2xiN3E5SUx2?=
 =?utf-8?B?S01ZUk5qWStmdlJia1puSDkwYnpsYU94SDhpc01WVDdKeTZmNnlvUnB2VEJP?=
 =?utf-8?B?VnpuNmlyem9uUTRBZmZjT3JPSlhUcWUrNitFUXNHUUhWV1dLY1poNHREUnhl?=
 =?utf-8?B?RFZsTExMTk04UWtKbHl4VzNrUFdRanV4aHM0dkZFNDN4VEwwZnVBa1gvV2Ev?=
 =?utf-8?Q?e03baJDh9LbnaSOIZRhSMQE1ziz1SUYZygSal?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <656054F722096240A99583B70656A01D@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd06b46-f5e6-42ca-e92d-08da3ee29bbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 06:40:22.2257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /YjdNpXFMYwOYXJdPXYpTl1rhvPyJ+EkeeG6RSiVjyqnv1PuaUj3xpPA52J5aKCIXTfTuwhpUmOkvqgf55JwztejDr/jSnGVjJsYfZOivuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR07MB8335
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIhDQoNCk9uIFRodSwgMjAyMi0wNS0yNiBhdCAwMDo1MCArMDAwMCwgVmxhZGlt
aXIgT2x0ZWFuIHdyb3RlOg0KPiBPbiBGcmksIE1heSAwNiwgMjAyMiBhdCAxMjoyNDozN1BNICsw
MDAwLCBGZXJlbmMgRmVqZXMgd3JvdGU6DQo+ID4gSGkgVmxhZGltaXIhDQo+ID4gDQo+ID4gT24g
MjAyMi4gMDUuIDA2LiAxNDowMSwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiA+ID4gSGkgRmVy
ZW5jLA0KPiA+ID4gDQo+ID4gPiBPbiBGcmksIE1heSAwNiwgMjAyMiBhdCAwNzo0OTo0MEFNICsw
MDAwLCBGZXJlbmMgRmVqZXMgd3JvdGU6DQo+ID4gPiBUaGlzIGlzIGNvcnJlY3QuIEkgaGF2ZSBi
ZWVuIHRlc3Rpbmcgb25seSB3aXRoIHRoZSBvZmZsb2FkZWQgdGMtDQo+ID4gPiBnYXRlDQo+ID4g
PiBhY3Rpb24gc28gSSBkaWQgbm90IG5vdGljZSB0aGF0IHRoZSBzb2Z0d2FyZSBkb2VzIG5vdCBh
Y3QgdXBvbg0KPiA+ID4gdGhlIGlwdi4NCj4gPiA+IFlvdXIgcHJvcG9zYWwgc291bmRzIHN0cmFp
Z2h0Zm9yd2FyZCBlbm91Z2guIENhcmUgdG8gc2VuZCBhIGJ1Zw0KPiA+ID4gZml4IHBhdGNoPw0K
PiA+IA0KPiA+IFVuZm9ydHVuYXRlbHkgSSBjYW50LCBvdXIgY29tcGFueSBwb2xpY3kgZG9lcyBu
b3QgYWxsb3cgZGlyZWN0IA0KPiA+IG9wZW4tc291cmNlIGNvbnRyaWJ1dGlvbnMgOi0oDQo+ID4g
DQo+ID4gSG93ZXZlciBJIHdvdWxkIGJlIG1vcmUgdGhhbiBoYXBweSBpZiB5b3UgY2FuIGZpeCBp
dC4NCj4gDQo+IFRoYXQncyB0b28gYmFkLg0KPiANCj4gSSBoYXZlIGEgcGF0Y2ggd2hpY2ggSSBh
bSBzdGlsbCB0ZXN0aW5nLCBidXQgeW91J3ZlIG1hbmFnZWQgdG8NCj4gY2FwdGl2YXRlDQo+IG15
IGF0dGVudGlvbiBmb3Igc2F5aW5nIHRoYXQgeW91IGFyZSB0ZXN0aW5nIDgwMi4xUWNoIHdpdGgg
YSBzb2Z0d2FyZQ0KPiBpbXBsZW1lbnRhdGlvbiBvZiB0Yy1nYXRlLg0KPiANCj4gRG8geW91IGhh
dmUgYSB1c2UgY2FzZSBmb3IgdGhpcz8gV2hhdCBjeWNsZSB0aW1lcyBhcmUgeW91IHRhcmdldGlu
Zz8NCj4gSG93IGFyZSB5b3UgZW5zdXJpbmcgdGhhdCB5b3UgYXJlIGRldGVybWluaXN0aWNhbGx5
IG1lZXRpbmcgdGhlDQo+IGRlYWRsaW5lcz8NCg0KVGhlIGN5Y2xlIHRpbWVzIEkgdGFyZ2V0ZWQg
d2VyZSBub3doZXJlIG5lYXIgdG8gYSByZWFsaXN0aWMgVFNODQpzY2VuYXJpbzoNCkkgImdlbmVy
YXRlZCIgcGluZyBwYWNrZXRzIGluIGV2ZXJ5IDEwMCBtc2VjcyBhbmQgb24gdGhlIGluZ3Jlc3Mg
cG9ydA0KYW5kIEkgbWFya2VkIHRoZW0gd2l0aCBwcmlvIDEgZm9yIDUwMG1zIChnYXRlIDEpIGFu
ZCBwcmlvIDIgZm9yIGFub3RoZXINCjUwMG1zIChnYXRlIDIpLiBPbiB0aGUgZWdyZXNzIHBvcnQg
SSBhcHBsaWVkIHRhcHJpbyB3aXRoIHRoZSBzYW1lIGJhc2UtDQp0aW1lIGFuZCBzYW1lIDUwMC01
MDBtcyBjeWNsZXMgYnV0IHJldmVyc2Ugb3JkZXJlZCBnYXRlcyAodGhhdCdzIHRoZQ0KImRlZmlu
aXRpb24iIG9mIHRoZSBRY2gpLCBzbyB3aGlsZSBhY3RfZ2F0ZSBvbiB0aGUgaW5ncmVzcyBpcyBp
biBnYXRlIDENCmN5Y2xlLCB0aGUgdGFwcmlvIGtlcHQgb3BlbiBnYXRlIDIgYW5kIGdhdGUgMSBj
bG9zZWQsIGV0Yy4NCkZvciAidmVyaWZpY2F0aW9uIiBJIHNpbXBseSBydW4gYSB0Y3BkdW1wIG9u
IHRoZSBsaXN0ZW5lciBtYWNoaW5lIHdoYXQNCkkgcGluZ2VkIGZyb20gdGhlIHRhbGtlciBhbmQg
ZXllYmFsbGVkIHdldGhlciB0aGUgNS01IHBhY2tldHMgYnVyc3RzDQpzaG93cyB1cCBhcnJpdmFs
IHRpbWVzdGFtcHMuDQoNCj4gRG8geW91IGFsc28gaGF2ZSBhIHNvZnR3YXJlIHRjLXRhcHJpbyBv
biB0aGUgZWdyZXNzIGRldmljZSBvciBpcyB0aGF0DQo+IGF0IGxlYXN0IG9mZmxvYWRlZD8NCg0K
Tm8sIEkgZXhwZXJpbWVudGVkIHdpdGggdGhlIHNvZnR3YXJlIHZlcnNpb24sIGJ1dCB0aGF0IHdv
cmtlZCB3aXRoIG15DQpuZXRucyB0ZXN0cyBhbmQgb24gcGh5c2ljYWwgbWFjaGluZXMgdG9vIChh
ZnRlciB0aGUgSVBWIHBhdGNoKS4NCg0KPiANCj4gSSdtIGFza2luZyB0aGVzZSBxdWVzdGlvbnMg
YmVjYXVzZSB0aGUgcGVyaXN0YWx0aWMgc2hhcGVyIGlzDQo+IHByaW1hcmlseQ0KPiBpbnRlbmRl
ZCB0byBiZSB1c2VkIG9uIGhhcmR3YXJlIHN3aXRjaGVzLiBUaGUgcGF0Y2ggSSdtIHByZXBhcmlu
Zw0KPiBpbmNsdWRlcyBjaGFuZ2VzIHRvIHN0cnVjdCBza19idWZmLiBJIGp1c3Qgd2FudCB0byBr
bm93IGhvdyB3ZWxsIEknbGwNCj4gYmUNCj4gYWJsZSB0byBzZWxsIHRoZXNlIGNoYW5nZXMgdG8g
bWFpbnRhaW5lcnMgc3Ryb25nbHkgb3Bwb3NpbmcgdGhlDQo+IGdyb3d0aA0KPiBvZiB0aGlzIHN0
cnVjdHVyZSBmb3IgYW4gZXhjZWVkaW5nbHkgc21hbGwgbmljaGUgOikNCg0KQ2FuIHlvdSB0ZWxs
IG1lIGFib3V0IHRoZSBpbnRlbnRpb24gYmVoaW5kIHRoZSBza19idWZmIGNoYW5nZXM/IERvZXMN
CnRoYXQgcmVxdWlyZWQgYmVjYXVzZSBvZiBzb21lIG9mZmxvYWRpbmcgc2NlbmFyaW8/IEluIG15
IGNhc2UgcHV0dGluZw0KdGhlIElQViBpbnRvIHRoZSBza2ItPnByaW9yaXR5IHdhcyBnb29kIGVu
b3VnaCBiZWNhdXNlIHRoZSB0YXByaW8gdXNpbmcNCnRoYXQgZmllbGQgYnkgZGVmYXVsdCB0byBz
ZWxlY3QgdGhlIHRyYWZmaWMgY2xhc3MgZm9yIHRoZSBwYWNrZXQuDQoNClRoYW5rcywNCkZlcmVu
Yw0KDQo=
