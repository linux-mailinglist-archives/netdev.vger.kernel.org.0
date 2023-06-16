Return-Path: <netdev+bounces-11526-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F43073377E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6F451C2101A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FF91DCAB;
	Fri, 16 Jun 2023 17:32:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B441D2B7
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 17:32:42 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BAF26A1;
	Fri, 16 Jun 2023 10:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686936760; x=1718472760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U+B1NZvYnU3qQ/wvJbohavUAoo5fV4hTN1uu8U5XGVQ=;
  b=jwKTIiqFYUpA7ytEbp3f9ypPRnVgUlDKwXzEOB5eU7nwOxLs57sO9t8N
   udoWATXTP1L5q0q68n+kHTQhuhFcIPyDJM95hjVTTPClXD+fc5WGbs1OO
   xkeJ67kjU/SriCt2uRf19IwpNRYATQOZgSrGHtNDWcdA7ph9l1d6D8GsY
   zpf93adKL2Efv2NBZTdEXqY4sZBzjGcA4itO73MmVvOm7qdK8Vvz2pbub
   LLG0qJtWnrKgc/o2UCNsTKZ3OOj5I+i0rkgyB+YQ6hrjk0VlO1YKFguse
   tQLeKz3BuFU96flvMVJgd87uFdeJbe3pOsTO/Xv4HktcbwCyggQ1qyvCw
   A==;
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="218305633"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jun 2023 10:32:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 16 Jun 2023 10:32:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 16 Jun 2023 10:32:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPVDP9AG8rxLDs+DwY3x7f3hOHkOlhvOE91oekG6D5AG6JjIk7ig2bICscSRaLJrShWdmROG21MDC0PE61l3Eo84wGXxsglnYmt1o1Fp+vEwu0XvMogL6arWfi7yOJ9HH8vKqyyCF5WbD1CjvxJjvoTDx74NE8bdr0V8PO5+T9TK+Vsx2XqZFFZogwD4W1M1+dD6AUjpEaNld3b7Q58pB4a9NK7lYpvbEmJt2iLXj2Dl+RpJqf9N9nWPTqwayRaVdbclR1bevwi/Ew2qy2jYnXhl+omMXejHcPboqyXoot6q270O7OnjozitnZ/fdEvRx1WlVRx229qU/LpfIJQniw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+B1NZvYnU3qQ/wvJbohavUAoo5fV4hTN1uu8U5XGVQ=;
 b=Vyj0RP0UL4mhWUm/hKO2ybVmeYtjr8RCZE9mlNzi7sLv5exgnUlCaqrUyEn+108FguIFcLsV+H3yRIMwspZg2zoZdTPGO0anmIAR1W+4TqspJF/qr9TcQaNXHCaBEweTA1qKsD4sNtEanZXH3ikR2BQMGA7NoVI/cme5wmcj4IQBTJoyk9mb3UAhiYZJNT1otsAA20dSQ0qPYR/hXsDC7xpyG1fJfvvnRDcuCgkuOyN52/qPo10xHdAdLBFPPekS8fZhFHZnANF89DcRr142CkukfxuX85L471aZdrl/ji+u+JEjG3Dshj78evLYZc3DvoPK2nokNm4o3NAUkweGDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+B1NZvYnU3qQ/wvJbohavUAoo5fV4hTN1uu8U5XGVQ=;
 b=pR0YxXOUqk94On9j/Z1ESm6QURZCiNzD7mN/v0DbX0DXNW51OVo4PncGvTc+GVaJmRG7jCDwwppHGGOnYKrqHzW3ch86rZwayCTG+T/BI2c/bl4I46Uv8AhxBp/hME0UzTvDdcF4WF/dI0bsBc0d+jKj+6wVfqh7ue0h6mhpz5w=
Received: from SA0PR11MB4719.namprd11.prod.outlook.com (2603:10b6:806:95::17)
 by CH3PR11MB8546.namprd11.prod.outlook.com (2603:10b6:610:1ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Fri, 16 Jun
 2023 17:32:30 +0000
Received: from SA0PR11MB4719.namprd11.prod.outlook.com
 ([fe80::d877:10e7:8c21:e9ce]) by SA0PR11MB4719.namprd11.prod.outlook.com
 ([fe80::d877:10e7:8c21:e9ce%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 17:32:30 +0000
From: <Varshini.Rajendran@microchip.com>
To: <conor@kernel.org>, <Nicolas.Ferre@microchip.com>
CC: <krzysztof.kozlowski@linaro.org>, <tglx@linutronix.de>, <maz@kernel.org>,
	<robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<conor+dt@kernel.org>, <alexandre.belloni@bootlin.com>,
	<Claudiu.Beznea@microchip.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <gregkh@linuxfoundation.org>,
	<linux@armlinux.org.uk>, <mturquette@baylibre.com>, <sboyd@kernel.org>,
	<sre@kernel.org>, <broonie@kernel.org>, <arnd@arndb.de>,
	<gregory.clement@bootlin.com>, <sudeep.holla@arm.com>,
	<Balamanikandan.Gunasundar@microchip.com>, <Mihai.Sain@microchip.com>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-clk@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <Hari.PrasathGE@microchip.com>,
	<Cristian.Birsan@microchip.com>, <Durai.ManickamKR@microchip.com>,
	<Manikandan.M@microchip.com>, <Dharma.B@microchip.com>,
	<Nayabbasha.Sayed@microchip.com>, <Balakrishnan.S@microchip.com>
Subject: Re: [PATCH 17/21] power: reset: at91-poweroff: lookup for proper pmc
 dt node for sam9x7
Thread-Topic: [PATCH 17/21] power: reset: at91-poweroff: lookup for proper pmc
 dt node for sam9x7
Thread-Index: AQHZllcBymqSKFWpkU6pcisNuogHGa97xVcAgABqhwCAAAYTgIARjm4A
Date: Fri, 16 Jun 2023 17:32:30 +0000
Message-ID: <ca473333-efde-9885-1a22-92bda28d1770@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-18-varshini.rajendran@microchip.com>
 <2a538004-351f-487a-361c-df723d186c27@linaro.org>
 <c3f7c08f-272a-5abb-da78-568c408f40de@microchip.com>
 <20230605-sedan-gimmick-6381f121cc0a@spud>
In-Reply-To: <20230605-sedan-gimmick-6381f121cc0a@spud>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR11MB4719:EE_|CH3PR11MB8546:EE_
x-ms-office365-filtering-correlation-id: ca1b3b2f-6d1f-458b-63d3-08db6e8fa95f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AVrNIZicJlHDfazC9VWKjvpsc1r4sxAjb0Bc9xDwLip1yO5MNQ3Ac8BFlpBLffpKGUAIEB5bdqCgmiH8J8AVrmFw0/+i7M+VrFtEl4FIrjKo2czOQII2QpLLHre2inAaKQ28vmfmJh6FNnbt9ZZ/TJH8r7Kg5VQqCRsGm0S7TPjfCVCViC+ArAH/vtFTznnri+1c0XmrxbCXhWnJeG4YYv0UH3FEtRKyOCkJbeOFWumXcf2mSL4QwedxAXrlmiDhd9x3MnuvnGB5x07zP4cA3s7ClZxiRoFQlZnwvAiYkvDVYghvIfMjuueet/CQk2k8LQyIwY0mfTHMbOALfx1gvypPD3Sql5IaUMSSPKLgK37YRo+luLg4ycA5MCfdWDxP5t/2BL21cvNzzCJK/VjEjJc/2LmLAm/CGiKBGTxDEA6XuSWD+4Lu3i65O2WSPMwv4r+w6n66Srql7VBZctYqZmzkmQrabIZOiOwAaJ4i5020kV08ZaQB2JGqc3Xtu5EPNOqAaWsUe8CJUM2Qm6nE/WNme7qZxlD+rtRZEW2S6ryyJo9xJQR56j5qhHH0Zm77ouPkuAWJuTiwz98dM6Uh/R/C0HtqDLcPLrEZRHZZQQiUv3SobWijRC5ye0EApGfh0x8g92Bhv9ctjYkhdaFZWG9Bk7FmvdyIfimj8m3SWRtNCHLz9QiJGCLy87p0f7Zk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4719.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199021)(36756003)(31696002)(2906002)(86362001)(38070700005)(7416002)(31686004)(2616005)(6486002)(83380400001)(186003)(26005)(6512007)(6506007)(53546011)(107886003)(5660300002)(71200400001)(122000001)(478600001)(91956017)(110136005)(54906003)(64756008)(76116006)(66476007)(316002)(6636002)(4326008)(66446008)(38100700002)(66556008)(66946007)(8936002)(8676002)(41300700001)(138113003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEJVdFhYY0llTUlIYzBpcTRaWUpDSjVKYnhWeVVYK01OTkJDSlQ3WEN2Mmg5?=
 =?utf-8?B?eTZUbWJCSC91aTNzYVh3emhOdnllTkhIWS9WTWx4RFE5RnJVcUJsUE1MYXZF?=
 =?utf-8?B?OHlTWUhHWlVzQTZleHVPbUtZVVorc09ZZGR2L2FJNEpEOWhMdlB1WXFXYTdo?=
 =?utf-8?B?Q0F0d2ZpbjUwSDYzVnY5YUxQaGU5Z0ZyNEV3bFhHM3BzczVJTUdVYzFNaTBX?=
 =?utf-8?B?RG9KK3NPMElLY3g4UklVYmJjaG9tU2o5d1hiZmxkN1FXNERkajllSGtkQnV3?=
 =?utf-8?B?ZWRFU016QndTQ21NVTVBcHVLRXZ4V0Q2aG0vai81dWtnYzFtK0FDcmgrdUJn?=
 =?utf-8?B?cy9UNklCTkpkZTYvVTh3K2trYUFuaGdSUVpXaFNzeVlLUGNTYVRmbkFTVDhx?=
 =?utf-8?B?VElWSkRhYlZ5c1M3a2VGVUp3WkR1bXlCWXUzQm5pRmlab0g3MTFydHpjVWlr?=
 =?utf-8?B?UWloUno3Z2dlZjVTMFU5bmZEME84bHh3Ti92K3dFVUthWHFKWTNRajc5Y1VZ?=
 =?utf-8?B?ejg3ZGZicTZTdzkyNDVVSm1FckVpem5xOUN1eHl6elE3d01KZEtIVlg5WkxL?=
 =?utf-8?B?cVovcDY5R0lxWUZFam9MK1Y0V3lkdkducXRYUnd5c2xXdXVsSGh6d1pMTjRX?=
 =?utf-8?B?ZXNFQTlZMHl3K21NMlNsVE02UnhnWXZZWmxmTGNtN3NDVU9DbUxlSDZ3eEpM?=
 =?utf-8?B?NEwrOU5kMWJqaDFGWHVaR2ZVUll3KzZYNzZ3UDl4TWVhNmp2RTUzelpaVitR?=
 =?utf-8?B?V2txbjAzRk1PenAvWmxBZFUwb0hPaTRuZ3hUOFZTU0NCK01sTU5hck9rT25C?=
 =?utf-8?B?RkY5b2MxdGVzaCtHWWFRVmg4RzY0NnJMUWJtcUNGdlA4YUs3MW4wbThqWXVa?=
 =?utf-8?B?L0g5YStER1hLeTliclVVUlV0RlB5OVNnYWFQc05vSDltTlliRHdsTERObXFq?=
 =?utf-8?B?cTFtbnlkbmNYSnFmTHNsNzBrb2paZE5rZGkvblNiL29iYyt5QTZuV3VPd1dN?=
 =?utf-8?B?TUY3NXVENWRQblV0aGEzUjBYL1NXbS9RYzIrL3hhcmc5SFBSVEM4b0hyTEl2?=
 =?utf-8?B?RS9ZNW5xS1hmSlovZWFOaUNvakhXNDkzdjVuUVNDTUoxSUxES1g0ZCtVZ0kv?=
 =?utf-8?B?TGo4eFV1OGtFN1lEdW5LZDU2dnMyelc1QUg2WWc1S2paSlNQQ216QWRhTVAx?=
 =?utf-8?B?MXVpdDVweTVMbC96WFVjZ0QxVFJ3UEt5QjQ0a3BnTkVYdXVoa1pCZ1NJck9C?=
 =?utf-8?B?aHFrd0RTYm93VVF6Y0hUWitXL285Vy82OU9VQXhUUmtFS1ROMitGSm1UQ0g2?=
 =?utf-8?B?b1BQaXN0Yi9id2ttMUZHRDZNeEM0d2s5OVJFTG52R2t0Lzd1dEJwVlZCTmJB?=
 =?utf-8?B?Nld3RDVGNW9VMU1aM3diSjJYNGZBUThnZEZVTzNQOUZOYVRXSmZTU1ljL0N5?=
 =?utf-8?B?UTNScEdxbDRoc2IyOFJ0a2dKUmwwZ0JRQmZXRWFKNWV3Q21ReTVHSmQzc0Za?=
 =?utf-8?B?SE9zMmpVbDJUUGVmYUJUS2hUbHJjOUE5eGVYMVZHRzRSWGMrZi82T0xOZEIx?=
 =?utf-8?B?UUtJWEk4S25WRWZreDBYRnVQQTFqUmZaY0lyV0pDOE5VaktISW1hWERURU1m?=
 =?utf-8?B?VWlBN0MvNzB0dmxVM01GYWtWa3h5Q0M3YTBhL2xLajJObE1nVHE1bDZTRFVm?=
 =?utf-8?B?MFkwRFFhVjZpenR0RFpHT3oyY29FOXN4bGtvYkl5bjJnWHV2Y2t4REZsaDgx?=
 =?utf-8?B?ZDNCbWxwUnh4Y2tzRWl5VE1nQ0I2enVVWXE2WU1ZVHVCY3g5cllGUEE5alFj?=
 =?utf-8?B?QktZbFg1VlNuc1pzT2xXS0VQVzVxbHFYMjM2c3dtWkE0VDBaUmdYbzl0L28y?=
 =?utf-8?B?UVloQXBkNFdHYzhreEhkMDBlY0FHWEtjYXc5cFNsbWkvOFpCdEZlc2Nhbzg0?=
 =?utf-8?B?MDJuYVEralVETmorYkRpRzhEMHN2Y1FPQVZXcU14YlRPWXJQa0U5UDEzYnFH?=
 =?utf-8?B?L01IemphUU0zdVkxRWx5a0M3bWVqaHhuckJ4U0pORzRQK2Y2WFVZTm4vdHYz?=
 =?utf-8?B?R0VJdzVLQlRjdTQ5aUFJRGZqVHlxLzZNdjByenNtR3VoVUlYZWZmcDI2M3lp?=
 =?utf-8?B?Zy82MXJ4R1Q2a2IxWHZERGpHYmhHWUExYk13bWVVMXMvOWo5VCtiUmNDTi9L?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AEDEEF51AC30E44DB9A6796386776ED0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4719.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca1b3b2f-6d1f-458b-63d3-08db6e8fa95f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 17:32:30.3699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sJP75s1hqHb1FFt+ZhCFyxhk0RUB1vNupiACTa8PFghIRNn2S/aOYkXQgLLZ8RHPGzISD6Z0mwGQKE8+0ToQMNuhx31+8S+fmZ6rScWhEbWuwqvZ7BDLffUTO+ugKNCY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8546
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMDUvMDYvMjMgNjo1NiBwbSwgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93
IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gSGV5LA0KPiANCj4gT24gTW9uLCBKdW4gMDUsIDIwMjMg
YXQgMDM6MDQ6MzRQTSArMDIwMCwgTmljb2xhcyBGZXJyZSB3cm90ZToNCj4+IE9uIDA1LzA2LzIw
MjMgYXQgMDg6NDMsIEtyenlzenRvZiBLb3psb3dza2kgd3JvdGU6DQo+Pj4gT24gMDMvMDYvMjAy
MyAyMjowMiwgVmFyc2hpbmkgUmFqZW5kcmFuIHdyb3RlOg0KPj4+PiBVc2Ugc2FtOXg3IHBtYydz
IGNvbXBhdGlibGUgdG8gbG9va3VwIGZvciBpbiB0aGUgU0hEV0MgZHJpdmVyDQo+Pj4+DQo+Pj4+
IFNpZ25lZC1vZmYtYnk6IFZhcnNoaW5pIFJhamVuZHJhbiA8dmFyc2hpbmkucmFqZW5kcmFuQG1p
Y3JvY2hpcC5jb20+DQo+Pj4+IC0tLQ0KPj4+PiAgIGRyaXZlcnMvcG93ZXIvcmVzZXQvYXQ5MS1z
YW1hNWQyX3NoZHdjLmMgfCAxICsNCj4+Pj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KykNCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcG93ZXIvcmVzZXQvYXQ5MS1zYW1h
NWQyX3NoZHdjLmMgYi9kcml2ZXJzL3Bvd2VyL3Jlc2V0L2F0OTEtc2FtYTVkMl9zaGR3Yy5jDQo+
Pj4+IGluZGV4IGQ4ZWNmZmU3MmYxNi4uZDBmMjliOTlmMjVlIDEwMDY0NA0KPj4+PiAtLS0gYS9k
cml2ZXJzL3Bvd2VyL3Jlc2V0L2F0OTEtc2FtYTVkMl9zaGR3Yy5jDQo+Pj4+ICsrKyBiL2RyaXZl
cnMvcG93ZXIvcmVzZXQvYXQ5MS1zYW1hNWQyX3NoZHdjLmMNCj4+Pj4gQEAgLTMyNiw2ICszMjYs
NyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCBhdDkxX3BtY19pZHNbXSA9IHsN
Cj4+Pj4gICAgICAgIHsgLmNvbXBhdGlibGUgPSAiYXRtZWwsc2FtYTVkMi1wbWMiIH0sDQo+Pj4+
ICAgICAgICB7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW05eDYwLXBtYyIgfSwNCj4+Pj4g
ICAgICAgIHsgLmNvbXBhdGlibGUgPSAibWljcm9jaGlwLHNhbWE3ZzUtcG1jIiB9LA0KPj4+PiAr
ICAgICB7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW05eDctcG1jIiB9LA0KPj4+DQo+Pj4g
V2h5IGRvIHlvdSBuZWVkIG5ldyBlbnRyeSBpZiB0aGVzZSBhcmUgY29tcGF0aWJsZT8NCj4+DQo+
PiBZZXMsIFBNQyBpcyB2ZXJ5IHNwZWNpZmljIHRvIGEgU29DIHNpbGljb24uIEFzIHdlIG11c3Qg
bG9vayBmb3IgaXQgaW4gdGhlDQo+PiBzaHV0ZG93biBjb250cm9sbGVyLCBJIHRoaW5rIHdlIG5l
ZWQgYSBuZXcgZW50cnkgaGVyZS4NCj4gDQo+IENvcHktcGFzdGluZyB0aGlzIGZvciBhIHdlZSBi
aXQgb2YgY29udGV4dCBhcyBJIGhhdmUgdHdvIHF1ZXN0aW9ucy4NCj4gDQo+IHwgc3RhdGljIGNv
bnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQgYXQ5MV9zaGR3Y19vZl9tYXRjaFtdID0gew0KPiB8IAl7
DQo+IHwgCQkuY29tcGF0aWJsZSA9ICJhdG1lbCxzYW1hNWQyLXNoZHdjIiwNCj4gfCAJCS5kYXRh
ID0gJnNhbWE1ZDJfcmVnX2NvbmZpZywNCj4gfCAJfSwNCj4gfCAJew0KPiB8IAkJLmNvbXBhdGli
bGUgPSAibWljcm9jaGlwLHNhbTl4NjAtc2hkd2MiLA0KPiB8IAkJLmRhdGEgPSAmc2FtOXg2MF9y
ZWdfY29uZmlnLA0KPiB8IAl9LA0KPiB8IAl7DQo+IHwgCQkuY29tcGF0aWJsZSA9ICJtaWNyb2No
aXAsc2FtYTdnNS1zaGR3YyIsDQo+IHwgCQkuZGF0YSA9ICZzYW1hN2c1X3JlZ19jb25maWcsDQo+
IHwgCX0sIHsNCj4gfCAJCS8qc2VudGluZWwqLw0KPiB8IAl9DQo+IHwgfTsNCj4gfCBNT0RVTEVf
REVWSUNFX1RBQkxFKG9mLCBhdDkxX3NoZHdjX29mX21hdGNoKTsNCj4gfCANCj4gfCBzdGF0aWMg
Y29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCBhdDkxX3BtY19pZHNbXSA9IHsNCj4gfCAJeyAuY29t
cGF0aWJsZSA9ICJhdG1lbCxzYW1hNWQyLXBtYyIgfSwNCj4gfCAJeyAuY29tcGF0aWJsZSA9ICJt
aWNyb2NoaXAsc2FtOXg2MC1wbWMiIH0sDQo+IHwgCXsgLmNvbXBhdGlibGUgPSAibWljcm9jaGlw
LHNhbWE3ZzUtcG1jIiB9LA0KPiB8IAl7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW05eDct
cG1jIiB9LA0KPiB8IAl7IC8qIFNlbnRpbmVsLiAqLyB9DQo+IHwgfTsNCj4gDQo+IElmIHRoZXJl
J3Mgbm8gY2hhbmdlcyBtYWRlIHRvIHRoZSBjb2RlLCBvdGhlciB0aGFuIGFkZGluZyBhbiBlbnRy
eSB0bw0KPiB0aGUgbGlzdCBvZiBwbWMgY29tcGF0aWJsZXMsIHRoZW4gZWl0aGVyIHRoaXMgaGFz
IHRoZSBzYW1lIGFzIGFuDQo+IGV4aXN0aW5nIFNvQywgb3IgdGhlcmUgaXMgYSBidWcgaW4gdGhl
IHBhdGNoLCBzaW5jZSB0aGUgYmVoYXZpb3VyIG9mDQo+IHRoZSBkcml2ZXIgd2lsbCBub3QgaGF2
ZSBjaGFuZ2VkLg0KPiANCj4gU2Vjb25kbHksIHRoaXMgcGF0Y2ggb25seSB1cGRhdGVzIHRoZSBh
dDkxX3BtY19pZHMgYW5kIHRoZSBkdHMgcGF0Y2gNCj4gY29udGFpbnM6DQo+IHwgc2h1dGRvd25f
Y29udHJvbGxlcjogc2hkd2NAZmZmZmZlMTAgew0KPiB8IAljb21wYXRpYmxlID0gIm1pY3JvY2hp
cCxzYW05eDYwLXNoZHdjIjsNCj4gfCAJcmVnID0gPDB4ZmZmZmZlMTAgMHgxMD47DQo+IHwgCWNs
b2NrcyA9IDwmY2xrMzJrIDA+Ow0KPiB8IAkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCj4gfCAJI3Np
emUtY2VsbHMgPSA8MD47DQo+IHwgCWF0bWVsLHdha2V1cC1ydGMtdGltZXI7DQo+IHwgCWF0bWVs
LHdha2V1cC1ydHQtdGltZXI7DQo+IHwgCXN0YXR1cyA9ICJkaXNhYmxlZCI7DQo+IHwgfTsNCj4g
DQo+IC4uLndoaWNoIHdvdWxkIG1lYW4gdGhhdCB0aGUgdGhlcmUncyBub3RoaW5nIGRpZmZlcmVu
dCBiZXR3ZWVuIHRoZQ0KPiBwcm9ncmFtbWluZyBtb2RlbHMgZm9yIHRoZSBzYW05eDYwIGFuZCBz
YW05eDcuIElmIHRoYXQncyB0aGUgY2FzZSwgdGhlDQo+IGR0LWJpbmRpbmcgJiBkdHMgc2hvdWxk
IGxpc3QgdGhlIHNhbTl4NjAgYXMgYSBmYWxsYmFjayBmb3IgdGhlIHNhbTl4NyAmDQo+IHRoZXJl
IGlzIG5vIGNoYW5nZSByZXF1aXJlZCB0byB0aGUgZHJpdmVyLiBJZiBpdCdzIG5vdCB0aGUgY2Fz
ZSwgdGhlbg0KPiB0aGVyZSdzIGEgYnVnIGluIHRoaXMgcGF0Y2ggYW5kIHRoZSBkdHMgb25lIPCf
mIQNCj4gDQo+IEluIGdlbmVyYWwsIGlmIHRoaW5ncyBhcmUgdGhlIHNhbWUgYXMgcHJldmlvdXMg
cHJvZHVjdHMsIHRoZXJlJ3Mgbm8gbmVlZA0KPiB0byBjaGFuZ2UgdGhlIGRyaXZlcnMgYXQgYWxs
ICYganVzdCBhZGQgZmFsbGJhY2sgY29tcGF0aWJsZXMgdG8gdGhlDQo+IGJpbmRpbmdzIGFuZCBk
dHMuIElGRiBzb21lIGRpZmZlcmVuY2UgcG9wcyB1cCBpbiB0aGUgZnV0dXJlLCB0aGVuIHRoZQ0K
PiBzYW05eDcgY29tcGF0aWJsZSB3aWxsIGFscmVhZHkgZXhpc3QgaW4gdGhlIGR0cywgYW5kIGNh
biB0aGVuIGJlIGFkZGVkDQo+IHRvIHRoZSBkcml2ZXIuDQoNClllcy4gSSB0b3RhbGx5IGFncmVl
IHdpdGggeW91LiBJbiB0aGlzIHBhdGNoIEkgaGF2ZSBub3QgYWRkZWQgYSANCmNvbXBhdGlibGUg
Zm9yIHRoZSBzaHV0ZG93biBjb250cm9sbGVyIGZvciBzYW05eDcuIEkgaGF2ZSBhZGRlZCB0aGUg
DQpjb21wYXRpYmxlIG9mIHRoZSBwbWMgdXNlZCBpbiBzYW05eDcgaW4gdGhlIGxpc3Qgb2YgY29t
cGF0aWJsZXMgdG8gdXNlIA0KdGhlIHJpZ2h0IHBtYyBkcml2ZXIgaW4gb3JkZXIgdG8gY29udHJv
bCB0aGUgY2xrIGRpc2FibGUgZnVuY3Rpb25zIGZvciANCnRoZSByaWdodCBwbWMuIFRoZSBzaHV0
ZG93biBwcm9ncmFtbWluZyBpcyBubyBkaWZmZXJlbnQsIHNvIG5vIG5ldyANCmNvbXBhdGlibGUg
Zm9yIHNhbTl4NyAobGlrZSBtaWNyb2NoaXAsc2FtOXg3LXNoZHdjKS4gQnV0IHRoZSBQTUMgaXMg
DQp0b3RhbGx5IGRpZmZlcmVudCB0aGFuIHRoZSBvdGhlciBvbGRlciBTb0NzLCBoZW5jZSBJIGhh
dmUgYWRkZWQgdGhlIG5ldyANCmNvbXBhdGlibGUgbWljcm9jaGlwLHNhbTl4Ny1wbWMgaW4gdGhl
IGxpc3QgYXMgaXQgaXMgZGVmaW5lZCBpbiB0aGUgDQpkcml2ZXJzL2Nsay9hdDkxL3NhbTl4Ny5j
IGRyaXZlci4gSG9wZSB0aGlzIGlzIGNsZWFyLg0KDQo+IA0KPiBDaGVlcnMsDQo+IENvbm9yLg0K
PiANCg0KLS0gDQpUaGFua3MgYW5kIFJlZ2FyZHMsDQpWYXJzaGluaSBSYWplbmRyYW4uDQoNCg==

