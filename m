Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A025A9269
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 10:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiIAIv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 04:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiIAIvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 04:51:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDE7A7221;
        Thu,  1 Sep 2022 01:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662022311; x=1693558311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HqxFOYj73EG/SExJeSwamBd4EF0BLF+dNzJs37zvqxo=;
  b=aV+jueLjYkNrTaAgzDPqwmyNpouQs9xVTweCWbsHmWpNdbEiwkTUG1jq
   B7ltPgRun36Vl1HY8yjG6QHb3Qfm8CAqYVvEHJXDtdgI+mKUHMIY6wRvh
   YMdPYWptEUGvQ/VSohkk2mA5SJWNMBgXDm0DAFIFazZFeHRFJcuovZzzz
   iKYNAqysDODZb+YVYqzjcOb3X345nYrpsBmsFZVS1Iz5P5WQc20aHfLbs
   e2hXdPKS5W5O4SgeBKc0zmTc3XTDx5UzsbWbxqCWreMKrdTaVnogqDUTj
   NtxSf/6y84nxFnM8+ya+Y1MNjhr1r/y6Ak0W6NSOM2b0czHBPU5QjPlwu
   w==;
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="171930791"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Sep 2022 01:51:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Sep 2022 01:51:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Thu, 1 Sep 2022 01:51:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKH42cDGQXmGiFImsdFXqCOJdgdPOOPUZarG6kkDkBZ2LlPXxoChBjnuw7bM4t6siTgSYt7IvVjcdd6GGJS0JsWzey/jX4U6BJK4HVSYqGXMuZGi6vnKb+rZCxjTeYDwiwAgho5xSL8s1JHE9zO9ed3rzjFch5VDMaqb7QpSmKG9x3/EmUD+0E/h/rcq8oIufpMdpxxh34OudDUGaFNGS0TAbOO8ol/1xAt/yNQecrzI4LGSdqVqY++G9IVNuLpXvsGg+7FBfVww5BfB7kd/Vk8q7YVSUjJoxJaNujjsbPmD/OzzMYvMMvWFIAcUs1ur1A0XS6wnY8N+eggi3gsgKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HqxFOYj73EG/SExJeSwamBd4EF0BLF+dNzJs37zvqxo=;
 b=OtkM9ZWJfQkDWmi21cyQqeFkTbdidiH+7sEOghHhnPvZh+NlTt9Q5BNW883/RXZrO/QNDtD4PFE3ZJr4KjGV1dXYeveUB+lqmw9lPyPNcbrLm2EVO9gKPwJowGIfgZZUOmNNkqWjD22R6LNrAIHVEwMlmgvV9hmBBDpFBFZxD0zFMZ0LVKKno72spy3+13ozPaOhnA8abbVIHa+EZzlk2NEAyWUKNVNbx2Lr4/p23dFtOy1O0dNEMGCrANl/9OaaFzp0dhS3vRTccwMFQaQ3KocLAYFeij2w4xPlWphLGIx50UiXNnFZ9jrxbV5Tf5kNAV+tUwJ00kvAi57sqnwhpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqxFOYj73EG/SExJeSwamBd4EF0BLF+dNzJs37zvqxo=;
 b=XX/jqby4iKcz7MsL4mbsCJm9z8swdz12KZc3qredjIRQIZQQQ4i4nk8Wzmy07fhBB9RfWYttKyuivH6Z/SYJzbaVyGVMReBoJfL8yE5xFiYun3Tss4VfjXfnDJbaEuoMTzU8RqJaA3dLMiC1lbfntqGAaCXp++axdV+J3uoLYaY=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BN9PR11MB5258.namprd11.prod.outlook.com (2603:10b6:408:133::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 08:51:45 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::e828:494f:9b09:6bb5]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::e828:494f:9b09:6bb5%7]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 08:51:45 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <o.rempel@pengutronix.de>, <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <san@skov.dk>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Thread-Topic: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Thread-Index: AQHYnz/JPjfPUKMERUuEDcRFWSApta3HPH+AgAAWeACAABymAIAAZp0AgAEF+QCAAH9KgIAADoKAgAEXoAA=
Date:   Thu, 1 Sep 2022 08:51:44 +0000
Message-ID: <6c4666fd48ce41f84dbdad63a5cd6f4d3be25f4a.camel@microchip.com>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
         <20220830065533.GA18106@pengutronix.de>
         <67690ec6367c9dc6d2df720dcf98e6e332d2105b.camel@microchip.com>
         <20220830095830.flxd3fw4sqyn425m@skbuf>
         <20220830160546.GB16715@pengutronix.de>
         <20220831074324.GD16715@pengutronix.de>
         <20220831151859.ubpkt5aljrp3hiph@skbuf>
         <20220831161055.GA2479@pengutronix.de>
In-Reply-To: <20220831161055.GA2479@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d80b751-b645-40bd-2c96-08da8bf732b7
x-ms-traffictypediagnostic: BN9PR11MB5258:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rM2EZAaP1kjUUZfm2bklX5FV840HvN4wZChH1vtjoDMbKcKGjgpTGRad7CvCnP9u/mzXvRNoYi6La2RdEp6cPdSlGugsiaCIDnYAtU+UpUwx8Bk5KB59qavSNcNPouhrczrUg8ACccdG4Eyg5YwBRl6z86qsn4oiWfiBbJlC4QtOLdXDpejtKfP0dvadmhEnkT0ZhEIES93Hemo0Mgl7qU6nAzO/C+Jsvsykwxyz3pDGZAHIR8/OeO1Gz/e8VSVZxt/NbvndjMJNKVF+T/Ro/CLrGsN0MrEd9sTLlYzTzvh/Uzs1ghcAPgbkF0lTFGWXr+i16+9vXJDP9dYKppgq+ko0GNDMKQCRSxEdZXTrYkKgb+MDvYObzdTL0lvjrfLazG62B3eDZmn4MtZXekCmifX5rnDtaKps9XAJPJK8R7H6EbqoMpQ1fkJfMu8x1erD27AmLL7c8kkAjTZhT9bDqUioo4viArjpmAtvWkEAxfLdC+nqgZvI78/c99PYOWluKqI668Yss/G104TEdL0Q55vDBSJ9YoENmr3rkvKIWa+hjIXEfTX6qdFQKHTvcxrTTH4QT3T3YpsskJcFHRn+xVnI0fzbWmobf6cvu3kiPiJvcML+tXcmcaeE1MglktUtPuKtIz4KjaG1El7NYgT7HONxISl+fiCwcuArJ2JG8+IfcfBLAQbLnvo7LchTTYeB31ErVg2wZEhlAlaS4hq6MzlAFrYy4ftFdrjTeF9UYZzPQtIcy/SO+IfZMGHdgXam1d9auz1nRYXFDLP+RP4oABlweHUQdaxkUGPzRBmNnFz2cTq/m5gp+cUFvPoK9qG6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(136003)(366004)(39860400002)(186003)(2616005)(41300700001)(86362001)(316002)(966005)(71200400001)(478600001)(6486002)(64756008)(6512007)(38070700005)(54906003)(6506007)(26005)(110136005)(38100700002)(5660300002)(66446008)(8936002)(122000001)(7416002)(2906002)(91956017)(36756003)(83380400001)(8676002)(66946007)(76116006)(4326008)(66556008)(66476007)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0E4UGRMaGdGVTk2ZnlXOWE2S1krdEpBSjB4VU5vVmtua3RwWmpMSGdNbzc5?=
 =?utf-8?B?VWtOd3lYRDM3QXptSHdCTkVtMGpnUXZQWElrd212ei81U3dicnVlNzdFWlBX?=
 =?utf-8?B?Zk5kSmd1UUFhRGo3TFRZWFcvMFFidkJRKytYa3pGUmFKQitmMEFpZHRDRjVF?=
 =?utf-8?B?SjBMbUhHS1BNaXVPZlJNNzFQb3hSZElJVXRMUmE3V1R6d1ZEcE9VUURBOWts?=
 =?utf-8?B?aUxRckpVQWxIOGxRQlhCVXBtbmdNQStRTWp2ZWRCRW4vWXdOTTdFTGt2MWZZ?=
 =?utf-8?B?c0J3bVVUZXl1L3JRVFZ0Zlp2UDVIMS96QTYrNmZHd204MmNhYXd6OHUwcWhZ?=
 =?utf-8?B?cmJWM1ZjNXUrcU9rbG5zZlpQK0RwdU40TFV0WUlWNEFsbFZRd0VoU01DLzhX?=
 =?utf-8?B?Vnkxd1hBOWtBWWE4WnIrSWtKZ3JjWGJ5V3Q0S1ZIZWtqOVZLRHZqMjdsNkk2?=
 =?utf-8?B?NDlCMDkwckZVLzVQbjZUS2U1T1J6bFZzM1V0eVg1eWE4MEpGSm9rOXFJUjZ3?=
 =?utf-8?B?QUFUbXQ1T3NuWHRpQUprOXBJWVZob3BFbHRsbTBqeHIrY1ROa1ZRUW5mZFpp?=
 =?utf-8?B?UjU3aUNQd1plRGJ1V3A5Wi9WY3MrZ0lnNjBQSmFYamRreHJwSno5SHRUb1hJ?=
 =?utf-8?B?cVJyREhVdzRkODk4K2Fnak1ucC81MXlSUU1ISk1KMURUaERmTjdlaTZmRmw3?=
 =?utf-8?B?c0RMREcwa29xRHE3aG5kd1FwV0lUQVJKaUhyZmJtOE9QYzJsa0hENUJ2WkVD?=
 =?utf-8?B?c1B2KytxRi9GNmZORjZRd0ZCL3hSUEg4VEFlTTFObXBGa1krNysrZSs1ZjNp?=
 =?utf-8?B?K3dZV0gwNU5wUWVaRVJSK3p6YXhwdTFKU2VjY1ltaWhzM0RISWpwbEdxdG9l?=
 =?utf-8?B?czBmSGNHaXU2NGM4UTV0WXhKblFoM21tVkw5aXRqeDR3TXpOMWZQZ3lDSzVM?=
 =?utf-8?B?RUorbW5JWC9DV1VIN0JjQW9sUVFTZWJ3Q3NUZUE4N2NCT01tK0lhZkJsVENs?=
 =?utf-8?B?TFZObFczMmtxVXFxWVA3SlAyTkN3Q2FNQnYwQlVrRmg1emtZdWphUm8rc3M2?=
 =?utf-8?B?ZnJjM0hIbXRqNWhhVTRTVG5ueUZrdEQyS2p6MlI2aUZKY1VvVjk4V21LT3dM?=
 =?utf-8?B?bFM3TVp4d1RTbmxtbHhZUHNqYzZ6YTYzRy9hWWlRQ3ZoTitXREQxSEltMTJN?=
 =?utf-8?B?ZUtyLytQMkFlN0htTzkreU1iQWNNRFhmTFhCK1J4Y28xWE5pcXY0S1dSQUU3?=
 =?utf-8?B?SWpCcWJZWFM5OWY4YUdtaEQyYit4OXRKblpqVUM5aHBEVUlKWHZSZFE0WEEv?=
 =?utf-8?B?MUxhUHlYdDBUWUFpM1lXejBEbFlyY1RWNDMyL2pON1FidCs1Q3JucWh0UjBQ?=
 =?utf-8?B?cUUxRWNXUDhXcjc3bE5hRTdpQmdzUmlyRjMxb0lwNFhWMStLbWhCYUQ1R21Z?=
 =?utf-8?B?V0VZK1FoTm1LVWtjYzZXSCsxWUhWUEZyOU9nME5mVmVVaHc2bkhnS1AvY2NX?=
 =?utf-8?B?MSt0anpmQi8xTE9VZGVqa0s1dk5QYkJtelltbncvSGQ5UlQvWUtrNW80U3RT?=
 =?utf-8?B?bldkaXlUV0I3bEkyK0l1UitVS2IyeG1KRDZNeEhPVFNqcDFkdkY3TFMxOHg3?=
 =?utf-8?B?a2RSb2ZRc24wS0JEZXlURUlXd0xGRnNuVm1DRUl3L1BqU3dOOXovNDhYcjBB?=
 =?utf-8?B?UWZVN0gxdnhRcHZ4Z3NQaTY1c1dGYkRYaGhmdnROaWFGdWdqOW82K0lHYTJN?=
 =?utf-8?B?RTZ0dkN4TmFQM0xzNTdxbmtzZWtsWlBsZ284ZUgwN3RKWmdyb21KTllKVTJK?=
 =?utf-8?B?eUlrZVJ2VTUyNEFaaVhwUSthbHgwNnEwOVFVNnQ2VEV0c1NLalpESzFieFc1?=
 =?utf-8?B?ZkpKOFdwbWx4dkgxV2c1WWhDdXczL3NiRzNhY0ZFbFZ4NE4vL3ZycEFCR1Fx?=
 =?utf-8?B?TktmZXNpWGZZK0pIN2ZHNm9EQ3MxeTV1U2Z3cWpFZVBqVDdrNXU3aXB5c3JE?=
 =?utf-8?B?eU1nYktQUThwOGRERTFpRTFsc3Qva09aVEt6dWVjbXJ4OHl3VUZsc0FmbGk4?=
 =?utf-8?B?Y0h6K1NzYTlUelA4am4yci81WlgxU3FyaGZmc2dtR1hpNjdONEJDaDBEK2Iw?=
 =?utf-8?B?R1ZDTVZIdm5WWFhBekFhVnpOUzhvcHpoSW0yWW1WZVJ1NFp1MjM5dHRtL3lL?=
 =?utf-8?Q?ErrzeIXxQr+BnIsiVtl9JJM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B6C8AF6F68D1F49B757B1E1DD9A4A49@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d80b751-b645-40bd-2c96-08da8bf732b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 08:51:44.9926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yHpuX/KJww2zabArDpgnFCOMosTq4TJBKPBrbnjrpJWaLW7sJhWIUI+CUO1UWfU7nsIHEjwnHa/FZBBZrG9pEZoE2sC1bxcnNksmtlZhEJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5258
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA4LTMxIGF0IDE4OjEwICswMjAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBXZWQsIEF1
ZyAzMSwgMjAyMiBhdCAwNjoxODo1OVBNICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+
ID4gT24gV2VkLCBBdWcgMzEsIDIwMjIgYXQgMDk6NDM6MjRBTSArMDIwMCwgT2xla3NpaiBSZW1w
ZWwgd3JvdGU6DQo+ID4gPiA+ID4gU2hvdWxkIHdlIHBvaW50IHRoZW0gdG8ga3N6ODc5NV94bWlp
X2N0cmwwIGFuZA0KPiA+ID4gPiA+IGtzejg3OTVfeG1paV9jdHJsMT8gSSBkb24ndCBrbm93Lg0K
PiA+ID4gPiA+IENvdWxkIHlvdSBmaW5kIG91dCB3aGF0IHRoZXNlIHNob3VsZCBiZSBzZXQgdG8/
DQo+ID4gPiA+IA0KPiA+ID4gPiB4bWlpX2N0cmwwLzEgYXJlIG1pc3NpbmcgYW5kIGl0IG1ha2Ug
bm8gc2Vuc2UgdG8gYWRkIGl0Lg0KPiA+ID4gPiBLU1o4ODczIHN3aXRjaCBpcyBjb250cm9sbGlu
ZyBDUFUgcG9ydCBNSUkgY29uZmlndXJhdGlvbiBvdmVyDQo+ID4gPiA+IGdsb2JhbCwNCj4gPiA+
ID4gbm90IHBvcnQgYmFzZWQgcmVnaXN0ZXIuDQo+ID4gPiA+IA0KPiA+ID4gPiBJJ2xsIGJldHRl
ciBkZWZpbmUgc2VwYXJhdGUgb3BzIGZvciB0aGlzIGNoaXAuDQo+ID4gPiANCj4gPiA+IEhtLCBu
b3Qgb25seSBLU1o4ODMwL0tTWjg4NjMvS1NaODg3MyBhcmUgYWZmZWN0ZWQuIGtzejg3OTUNCj4g
PiA+IGNvbXBhdGlibGUNCj4gPiA+IHNlcmllcyB3aXRoIGRlZmluZWQgLnhtaWlfY3RybDAvLnht
aWlfY3RybDEgYXJlIGJyb2tlbiB0b28uDQo+ID4gPiBCZWNhdXNlIGl0DQo+ID4gPiBpcyB3cml0
aW5nIHRvIHRoZSBnbG9iYWwgY29uZmlnIHJlZ2lzdGVyIG92ZXIga3N6X3B3cml0ZTgNCj4gPiA+
IGZ1bmN0aW9uLiBJdA0KPiA+ID4gbWVhbnMsIHdlIGFyZSB3cml0aW5nIHRvIDB4YTYgaW5zdGVh
ZCBvZiAweDA2LiBBbmQgdG8gMHhmNg0KPiA+ID4gaW5zdGVhZCBvZg0KPiA+ID4gMHg1Ni4NCj4g
PiBXaGF0IGRvIHlvdSBtZWFuIGJ5ICJnbG9iYWwgY29uZmlnIHJlZ2lzdGVyIj8gVGhlIElzXzFH
YnBzIGJpdCBpcw0KPiA+IHN0aWxsDQo+ID4gcGFydCBvZiBhIHBvcnQgcmVnaXN0ZXIsIGl0J3Mg
anVzdCB0aGF0IHRoaXMgcGFydGljdWxhciByZWdpc3RlciBpcw0KPiA+IG9ubHkNCj4gPiBkZWZp
bmVkIGZvciB0aGUgNXRoIHBvcnQgKHBvcnQgIzQsIHRoZSBvbmx5IHhNSUkgcG9ydCBvbiBLU1o3
ODk1DQo+ID4gQUZBSVUpLg0KPiA+IFRoYXQgZG9lc24ndCBuZWNlc3NhcmlseSBtYWtlIGl0IGEg
Imdsb2JhbCIgcmVnaXN0ZXIuDQo+ID4gDQo+ID4gRGF0YXNoZWV0IHNheXM6DQo+ID4gDQo+ID4g
UmVnaXN0ZXIgMjIgKDB4MTYpOiBSZXNlcnZlZA0KPiA+IFJlZ2lzdGVyIDM4ICgweDI2KTogUmVz
ZXJ2ZWQNCj4gPiBSZWdpc3RlciA1NCAoMHgzNik6IFJlc2VydmVkDQo+ID4gUmVnaXN0ZXIgNzAg
KDB4NDYpOiBSZXNlcnZlZA0KPiA+IFJlZ2lzdGVyIDg2ICgweDU2KTogUG9ydCA1IEludGVyZmFj
ZSBDb250cm9sIDYNCj4gPiANCj4gPiBJIHdvbmRlciBpZiBpdCdzIG9rIHRvIG1vZGlmeSB0aGUg
cmVncyB0YWJsZSBsaWtlIHRoaXMsIGJlY2F1c2Ugd2UNCj4gPiBzaG91bGQgdGhlbiBvbmx5IHRv
dWNoIFBfWE1JSV9DVFJMXzEgdXNpbmcgcG9ydCA0Og0KPiA+IA0KPiA+ICBzdGF0aWMgY29uc3Qg
dTE2IGtzejg3OTVfcmVnc1tdID0gew0KPiA+ICAgICAgIFtSRUdfSU5EX0NUUkxfMF0gICAgICAg
ICAgICAgICAgPSAweDZFLA0KPiA+ICAgICAgIFtSRUdfSU5EX0RBVEFfOF0gICAgICAgICAgICAg
ICAgPSAweDcwLA0KPiA+ICAgICAgIFtSRUdfSU5EX0RBVEFfQ0hFQ0tdICAgICAgICAgICAgPSAw
eDcyLA0KPiA+ICAgICAgIFtSRUdfSU5EX0RBVEFfSEldICAgICAgICAgICAgICAgPSAweDcxLA0K
PiA+ICAgICAgIFtSRUdfSU5EX0RBVEFfTE9dICAgICAgICAgICAgICAgPSAweDc1LA0KPiA+ICAg
ICAgIFtSRUdfSU5EX01JQl9DSEVDS10gICAgICAgICAgICAgPSAweDc0LA0KPiA+ICAgICAgIFtS
RUdfSU5EX0JZVEVdICAgICAgICAgICAgICAgICAgPSAweEEwLA0KPiA+ICAgICAgIFtQX0ZPUkNF
X0NUUkxdICAgICAgICAgICAgICAgICAgPSAweDBDLA0KPiA+ICAgICAgIFtQX0xJTktfU1RBVFVT
XSAgICAgICAgICAgICAgICAgPSAweDBFLA0KPiA+ICAgICAgIFtQX0xPQ0FMX0NUUkxdICAgICAg
ICAgICAgICAgICAgPSAweDA3LA0KPiA+ICAgICAgIFtQX05FR19SRVNUQVJUX0NUUkxdICAgICAg
ICAgICAgPSAweDBELA0KPiA+ICAgICAgIFtQX1JFTU9URV9TVEFUVVNdICAgICAgICAgICAgICAg
PSAweDA4LA0KPiA+ICAgICAgIFtQX1NQRUVEX1NUQVRVU10gICAgICAgICAgICAgICAgPSAweDA5
LA0KPiA+ICAgICAgIFtTX1RBSUxfVEFHX0NUUkxdICAgICAgICAgICAgICAgPSAweDBDLA0KPiA+
ICAgICAgIFtQX1NUUF9DVFJMXSAgICAgICAgICAgICAgICAgICAgPSAweDAyLA0KPiA+ICAgICAg
IFtTX1NUQVJUX0NUUkxdICAgICAgICAgICAgICAgICAgPSAweDAxLA0KPiA+ICAgICAgIFtTX0JS
T0FEQ0FTVF9DVFJMXSAgICAgICAgICAgICAgPSAweDA2LA0KPiA+ICAgICAgIFtTX01VTFRJQ0FT
VF9DVFJMXSAgICAgICAgICAgICAgPSAweDA0LA0KPiA+ICAgICAgIFtQX1hNSUlfQ1RSTF8wXSAg
ICAgICAgICAgICAgICAgPSAweDA2LA0KPiA+IC0gICAgIFtQX1hNSUlfQ1RSTF8xXSAgICAgICAg
ICAgICAgICAgPSAweDU2LA0KPiA+ICsgICAgIFtQX1hNSUlfQ1RSTF8xXSAgICAgICAgICAgICAg
ICAgPSAweDA2LA0KPiA+ICB9Ow0KPiA+IA0KPiANCj4gU3BlZWQgY29uZmlndXJhdGlvbiBvbiBr
c3o4Nzk1IGlzIGRvbmUgb3ZlciB0d28gcmVnaXN0ZXJzOg0KPiBSZWdpc3RlciA4NiAoMHg1Nik6
IFBvcnQgNSBJbnRlcmZhY2UgQ29udHJvbCA2OiBJc18xR2JwcyAtIEJJVCg2KQ0KPiBhbmQNCj4g
UmVnaXN0ZXIgNiAoMHgwNik6IEdsb2JhbCBDb250cm9sIDQ6IFN3aXRjaCBTVzUtTUlJL1JNSUkg
U3BlZWQNCj4gLUJJVCg0KQ0KPiANCj4gYm90aCBhcmUgYWNjZXNzZWQgb24gd3Jvbmcgb2Zmc2V0
cy4NCj4gDQo+IEkgd291bGQgcHJlZmVyIHRvIGRvIGZvbGxvd2luZyBzdGVwczoNCj4gLSByZW1v
dmUgZXZlcnl0aGluZyBmcm9tIGtzel9waHlsaW5rX21hY19saW5rX3VwKCkgZXhjZXB0IG9mDQo+
ICAgZGV2LT5kZXZfb3BzLT5waHlsaW5rX21hY19saW5rX3VwDQo+IC0gbW92ZSBrc3pfZHVwbGV4
X2Zsb3djdHJsKCksIGtzel9wb3J0X3NldF94bWlpX3NwZWVkKCkuLi4gdG8NCj4ga3N6OTQ3Ny5j
DQo+ICAgYW5kIHJlbmFtZSB0aGVtLiBBc3NpZ24ga3N6OTQ3N19waHlsaW5rX21hY19saW5rX3Vw
KCkNCj4gICBkZXYtPmRldl9vcHMtPnBoeWxpbmtfbWFjX2xpbmtfdXANCj4gLSBjcmVhdGUgc2Vw
YXJhdGUgZnVuY3Rpb24ga3N6ODc5NV9waHlsaW5rX21hY19saW5rX3VwKCkNCj4gLSB1c2UgZG9j
dW1lbnRlZCwgbm90IGdlbmVyaWMgcmVnaXN0ZXIgbmFtZXMuDQo+IA0KDQpJbiB0aGUgb3JpZ2lu
YWwgY29kZSwgdGhlIGtzejg3OTVfY3B1X2ludGVyZmFjZV9zZWxlY3QgKHdoaWNoIGRvZXMgdGhl
DQp4bWlpIGFuZCBzcGVlZCBjb25maWd1cmF0aW9uKSBpcyBjYWxsZWQgb25seSBrc3o4N3h4IHN3
aXRjaCBub3QgZm9yIHRoZQ0Ka3N6ODh4My4NCkR1cmluZyByZWZhY3RvcmluZywgSSBpbnRlbnRp
b25hbGx5IGRpZCBub3QgYWRkIHRoZSBQX1hNSUlfQ1RSTDAvMSBmb3INCnRoZSBrc3o4OHh4IGlu
IHRoZSBjaGlwX2RhdGEgc3RydWN0dXJlLg0KSSBhZGRlZCBjaGVjayB0aGF0IGlmIHN3aXRjaCBi
ZWxvbmcgdG8ga3N6ODh4MyB0aGVuIHJldHVybiBpbiB0aGUNCnBoeWxpbmtfbWFjX2NvbmZpZyBm
dW5jdGlvbiBidXQgSSBtaXNzZWQgdG8gYWRkIGluIHRoZQ0KcGh5bGlua19tYWNfbGlua191cC4g
VGhhdHMgdGhlIG1pc3Rha2UgSSBoYXZlIGRvbmUuIFNvLCBmb3IgdGhlIGtzejg4eHgNCnN3aXRj
aCBjb2RlIGJyZWFrYWdlLCBpdCBjb3VsZCBiZSBmaXhlZCBieSBhZGRpbmcgdGhlIGNoZWNrIGlu
IHRoZQ0KcGh5bGlua19tYWNfbGlua191cCBhcyB3ZWxsLg0KDQpGb3IgdGhlIGNvZGUgYnJlYWth
Z2UgaW4ga3N6ODc5NS9rc3o4Nzk0LCB0aGUgb3JpZ2luYWwgY29kZSBoYXMgb25seQ0KcHJvdmlz
aW9uIGZvciBjb25maWd1cmluZyB4bWlpIG1vZGUgYW5kIGNob29zaW5nIHRoZSAxMDAvMTAwME1i
cHMgc3BlZWQNCnNlbGVjdGlvbiB3aGljaCBjb3VsZCBiZSBzZWxlY3RlZCB1c2luZyBpc18xR2Jw
cyBiaXQgb2YNCnBvcnQ1X2ludGVyZmFjZV9jb250cm9sNiByZWdpc3RlciAoMHg1NikuIEJ1dCBp
dCBkaWRuJ3QgaGF2ZSBwcm92aXNpb24NCnRvIHNlbGVjdCBzcGVlZCBiZXR3ZWVuIDEwLzEwME1i
cHMsIGZsb3cgY29udHJvbCBhbmQgZHVwbGV4Lg0KDQpBcyBwZXIgdmxhZGltaXIgc3VnZ2VzdGlv
biwgUF9YTUlJX0NUUkwxIGNhbiBiZSBjaGFuZ2VkIGZyb20gMHg1NiB0bw0KMHgwNi4gSXQgZml4
ZXMgdGhlIHByb2JsZW0gZm9yIGtzel9zZXRfeG1paSwga3N6X3NldF9nYml0IHNpbmNlIHRoaXMg
aXMNCnRoZSBwb3J0IGJhc2VkIHJlZ2lzdGVyIG5vdCB0aGUgZ2xvYmFsIHJlZ2lzdGVyLg0KDQpU
aGUgZ2xvYmFsIHJlZ2lzdGVyIDB4MDYgcmVzcG9uc2liaWxpdGllcyBhcmUgYml0IDQgZm9yIDEw
LzEwMG1icHMNCnNwZWVkIHNlbGVjdGlvbiwgYml0IDUgZm9yIGZsb3cgY29udHJvbCBhbmQgYml0
IDYgIGZvciBkdXBsZXgNCm9wZXJhdGlvbi4gU2luY2UgdGhlc2UgdGhyZWUgYXJlIG5ldyBmZWF0
dXJlcyBhZGRlZCBkdXJpbmcgcmVmYWN0b3JpbmcNCkkgb3Zlcmxvb2tlZCBpdC4gDQpUbyBmaXgg
dGhpcywgZWl0aGVyIEkgbmVlZCB0byByZXR1cm4gZnJvbSB0aGUga3N6X3NldF8xMDBfMTBtYml0
ICYNCmtzel9kdXBsZXhfZmxvd2N0cmwgZnVuY3Rpb24gaWYgdGhlIGNoaXBfaWQgaXMga3N6ODd4
eCBvciBhZGQgZGV2LQ0KPmRldl9vcHMgZm9yIHRoaXMgYWxvbmUuIA0KS2luZGx5IHN1Z2dlc3Qg
b24gaG93IHRvIHByb2NlZWQuDQoNCg0KDQo+IC0tDQo+IFBlbmd1dHJvbml4DQo+IGUuSy4gICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8DQo+
IFN0ZXVlcndhbGRlciBTdHIuIDIxICAgICAgICAgICAgICAgICAgICAgICB8IA0KPiBodHRwOi8v
d3d3LnBlbmd1dHJvbml4LmRlL2UvICB8DQo+IDMxMTM3IEhpbGRlc2hlaW0sIEdlcm1hbnkgICAg
ICAgICAgICAgICAgICB8IFBob25lOiArNDktNTEyMS0yMDY5MTctDQo+IDAgICAgfA0KPiBBbXRz
Z2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiAgICAgICAgICAgfCBGYXg6ICAgKzQ5LTUxMjEt
MjA2OTE3LQ0KPiA1NTU1IHwNCg==
