Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8364E5137D4
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348871AbiD1PNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348382AbiD1PNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:13:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC38D22535;
        Thu, 28 Apr 2022 08:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651158598; x=1682694598;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Mdu0HDCa454v0JSbLllG/yJ05o/H67m8jKDnwG69jxY=;
  b=2SpHC3E/ojKgl4hVulKdiEAWDNDk3SZlMoSbnb4FYSIBpAblWlmiwjq1
   ZfwHIYFhguFc4ZgvFIoZzgIy1lfyGLvxmdi2M74EHTgsmSO1X/mqhJDNh
   3rG5Lt0f9oEpQoooBl0M0MLjscVwOjE6u0bQo8fhQJUxKmryQ0x8XUl2t
   cnyqskVzYtB7PMYSXljuuUJWS0cizcnhtDbynSRrxcSw2j6PU/s3Zc5Jh
   WlSt2QIpuuCCzOPTE2hQ8RR0DTp9vwgP/PNBaiVBb8HYMfUdiZIIZ8EQ4
   tP8XwHs+28u23NNTzuT4qYfy6g63jF+IJlGJmYq1FHyMe56NKTBc9TxDn
   A==;
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="162091538"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2022 08:09:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 28 Apr 2022 08:09:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 28 Apr 2022 08:09:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4l7LhSh5l2uVRYfQ980VUPfq8KkwsopiCeD719EYfyNSh5DfqV3XRYr65t8gX0OI+YmqrKzcucgW+Qe6xoUsq7eSM3bGvnCagHvtuw50MAni+G+KKEIUAx1GHPlC8yY8dRz6zvLpg3icxPJjFm3iPmKDoIBtZXPNMvrIGIUaTdMRZlDgq+/bMJ43cnf7zTC2A6RzkmWsGijRspld9x/tlULBLMaW1wv9LmXk0AAwnoT3yNJWjC8Rpfh0Xb766+omd7fltNpmus9Y7DP/+crylisTNl+fpPdPlVsWp1VD5wOLolw1psV7ukslUZ87KptvPcMmN6/S5nuVMw/Hu9/0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mdu0HDCa454v0JSbLllG/yJ05o/H67m8jKDnwG69jxY=;
 b=dchTInmhzgltKZgZ214dU6S4AThowQ+oaA6JPkEHkEQfK/pHQSpR7uNfqJgBDTo5Tbv4ZM7rATeJQUKWjUFuTPeUaBz+wl5Gn3TJqhUC9KZZQAk+OHBLcIcaZ20vZQXpViUjm46aAtyGou9x0E9A17DaeZGHLjzgONNoWj9eCLVRUldsM3w+iuFBPjqDtEVNpaKeotFTxY5GiNIUS688pokirIAketpsR9iPqSawt5yoPY855KeyEsNu9eSsqEbk6zVVfI9auidosD1e8vBl0+IO7gyiCpKYZ6tzu05wBHL9YwMHKyzdzhEZ27W7FeUfbfzHhnwbS/W9Qx+zEwWR/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mdu0HDCa454v0JSbLllG/yJ05o/H67m8jKDnwG69jxY=;
 b=CbaxdLISjnkSSRuGludu/+/WotDBdbaGin+pheXUwBOpxtQ7ctvuY8YCxJOkaqeAoOiHYts2UmpFENbCh4vHFhC36DHQ1w5CAQlngHoTHoTjEanQH5WPUjjY3n1EkatpULlFWPYcGEZ+woIQWH4h5yYROvKusGMSAe9pDebV260=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA2PR11MB5049.namprd11.prod.outlook.com (2603:10b6:806:11b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Thu, 28 Apr 2022 15:09:50 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3113:cf18:bdbc:f551]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3113:cf18:bdbc:f551%3]) with mapi id 15.20.5186.021; Thu, 28 Apr 2022
 15:09:50 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC patch net-next 3/3] net: dsa: ksz: moved ksz9477 port mirror
 to ksz_common.c
Thread-Topic: [RFC patch net-next 3/3] net: dsa: ksz: moved ksz9477 port
 mirror to ksz_common.c
Thread-Index: AQHYWlNaxCafaAnnVkiLtvq2xaWdqq0D+xIAgAF0RQA=
Date:   Thu, 28 Apr 2022 15:09:50 +0000
Message-ID: <a6760b49fae3df27d2b337f5212a3f967a015064.camel@microchip.com>
References: <20220427162343.18092-1-arun.ramadoss@microchip.com>
         <20220427162343.18092-4-arun.ramadoss@microchip.com>
         <20220427165722.vwruo5q63stahkby@skbuf>
In-Reply-To: <20220427165722.vwruo5q63stahkby@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: feab8fb8-a06e-4ffb-9a6e-08da29292440
x-ms-traffictypediagnostic: SA2PR11MB5049:EE_
x-microsoft-antispam-prvs: <SA2PR11MB504986CA5D3ED5D67BCF828AEFFD9@SA2PR11MB5049.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2CMhw1LlG9J6uROfZIX6EQ+zlHQFgfLl/pqDhFBBrVlA3SK8DUG0M2tT6PcuZOxquIou9MCshpb++vT38t2WPyCPNDP/B9WGMBB04OCTBeconi+7j4KNbucH8howoo4Oyhxv5HzAThLhwF4XCShIjiVnS7F4D9hdldwhD7jiqtUOLw5entchmqLNj7Pgkhy6BNP9WUdOPE4F4NQImp0e+GuyTPg1ChSWxZB6sit9wxQqz14Zn0m3XN3V90Gelwb3Spmw9jviAeNPfaxY0Buwgly/UFKUAPETSKHd8ZCxlLRZigw3VPIeqXHsgUVzBD3wQs+sMp0F8iCZk0vuMvZ6XPkv1+c9FYmRaIDVdPMlG+9GIquEjpSunVdNaA7WBt+8Jx7qwyL8IQtAuZYdHAFViWAyoENCydC+MlaM5ZzXR3Z3k+kbKEGJ+Piw+sXl1ep8wXrs1LVVqwfCFTLIve2iXM0Qz4kGl1vz/DfbuxEmb5rioZ6R5vTH+e9ncMd55/5QnlFJ6o58VmTp/vmlqsiA269efuvH/iNPsQ8TpBfwfbhRPdUqMfH+YqDY9IoJtqm0leSfr7+rEOsU8okJyWtctTXjOKQgj52CMIP8Dpw8669qwcgpRnTgUWa0bVyU1F5dXRuwVkMw1SaBwbQMP9IzMFE66BZl33WrzodnDXk+aSYkqztnjuxARnoHESmiwi1HZJmXfxre1Jx3OB9kFo3aOFPHUQ9MvPKz8l+UkE6KaHo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(8676002)(54906003)(4326008)(76116006)(64756008)(66446008)(66556008)(66946007)(66476007)(8936002)(316002)(6916009)(83380400001)(186003)(71200400001)(55236004)(6486002)(508600001)(26005)(38100700002)(122000001)(5660300002)(6512007)(36756003)(6506007)(86362001)(38070700005)(2906002)(2616005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXNmc2x1NzdrTGZ5Um1TdlF2SU83MGdVOU51ZjNMTy85WHU4SVl0Q3JsQ2xh?=
 =?utf-8?B?dzlxZjlmbEJzT2xsSWdhMjdEcmQvenFFYWpLbUVQWTVWU3V5YmpFVVVRSnJR?=
 =?utf-8?B?OS83UERDdXNDamhpT1puVlF2TFBlMFBqekVuZjdXYVNFNlV5aUthQ3VWeUhP?=
 =?utf-8?B?L010NklmTVZSanhMbWtGeHY0UGwwQXZ0TnNsS252TUMrK1ZLajJIb1diYlNs?=
 =?utf-8?B?c0E5Lzh0VWk0WjBDM1ZpMzFZc2x3NjBBWllXV1M5WlNmYzR6SzVmS1FXRHpP?=
 =?utf-8?B?TzczNm5RSER2N0xhNE9GVzdOTTlwNXlNVUFibW9wYVgvTW1WR3FaQnRSVDFU?=
 =?utf-8?B?eXpFMCtkK01hNm5aamZBaSs1NlVhbHl5aS9mWGdTaG11ampPZi9peWFEQjhw?=
 =?utf-8?B?cS9FYzFjbEpvQ3FoQllVcnNhc09JbW9kb2lEaFp5RnF0Q3dMUW9pVlR0dWRX?=
 =?utf-8?B?K1FqS1VMS3UyQ096NU4wQmQ0czRJSkNGd2FYMWgxbDN4VXZrSlZsV3V2TkF5?=
 =?utf-8?B?RUNpOWF4bmhHSXpYSi85NllsTkZySlJEMVR2a3ZDNVBBelhaTUVEc2NBM2x4?=
 =?utf-8?B?b01Jd1BZdGsra3VSRU5HNDVlb1M5aTRDbGpQZ0kxZUkvVlljR1RaMy9ZTjNB?=
 =?utf-8?B?UW8ydVNCRHZRdDFGeHd2Rm1wZTBWY2R2a3VVczE5a3Vuc2hSZERVMHdjdndN?=
 =?utf-8?B?RDF4Y2p6cXpiQk03c0lOcVl2V3hsa1RWNklQY0dYWitxcFhETFBSNDNWSmpo?=
 =?utf-8?B?b2pmYVV0VE84WkxIQlVzSEtIV3BOR012VVlZeE12V1RVT01rUWsyUmg5MmRm?=
 =?utf-8?B?Q0VlUEtoSzNJQkFyZ3RlaGVSeWhoVzg1NWhmVldHVjhjam4vVy9rSW9sRTJ6?=
 =?utf-8?B?YTBXdlpmYkgzRFRuTXpEMW8yMUZGaWR3bkZZMm04VnZYdjFaWG9kZE9VZHM1?=
 =?utf-8?B?STM5NmxhdFJuUUJGNEl5SXh0QXZ6OWR4MEd1cUUyTGZTSERnbUtZa21UVW5B?=
 =?utf-8?B?Qyt6U0gvcDgwRjJyZFFCUDFUWHlSREExaWFCOFU5Sm1nemNMRU5NNk96YTdl?=
 =?utf-8?B?cU1OTnRJMHh3NWJ3RDF3VTBVRlJ6RlVxaEZXQ3paY3JYRDdEQjdCalYzZ3BY?=
 =?utf-8?B?NnBaUEk3UVNkZmFGMlc4YU1CM29zV2JwSE15dTYrak1UY1MrTTBUOWZUTmZI?=
 =?utf-8?B?L3ArUldWejRvNWJNeDBwUlpkd3EyOHg1MUE0L29xYVovc0xYVTZ2S1FROHVP?=
 =?utf-8?B?MGVNR2tZY3FlVnhzVzhzeEhkYzlZMHF6eDUxWHYyb3AyUCtxQWRnTUpzWmY3?=
 =?utf-8?B?YnNsVnE3blpRcXVhYlZZa1d4a3N5SlRKRFRzMmVCY09SWlNyVS90bU1JNFFZ?=
 =?utf-8?B?U3FpZnJ2NlVBaWFmekEwbGNkOVdJc3ZVQ3NpRHZYRmJCNHFjSnN2bklSZGlz?=
 =?utf-8?B?UzRQZnlNYU9CZE05ZWNQYWdtQ2hLSU1VQjkreUdxbytjS0RzQ2R0YWppemRm?=
 =?utf-8?B?YjI5RXN5THRpVEZ3WlJxanI3WlFkL3kwM2FzUjZ6YTdFUEFZL0kwbktJZktn?=
 =?utf-8?B?T1BRK2pFK3JkVnZIVitCOEZtK3lWd0hsRDgrZkhIRURiQkFyNVV3YUhIVTl5?=
 =?utf-8?B?elA2bXIxMHNCRFF0QTBtenNVQ0dzVUtQSUJES1Z1enh4b0ZQSktpT1AwblZ4?=
 =?utf-8?B?YWh1NWZUOG4rUGlXMWdUTE02MHg4VXNJakJsV0wwRjlCVEJzZUE0N3RmckxD?=
 =?utf-8?B?WUptNVppZ3ZVUkQ4a1RjSG1oM0VUOXlSQ3kyWEpUQWgxNGhxU2hyVU5CZEwr?=
 =?utf-8?B?bGErNGwxbjA1ekdIYXRDNUpoQ1kwT3EyWVNOYkJrb1AyeUszMkU3Undxblpk?=
 =?utf-8?B?Y0t6dWJkTDJIbFczVUpYMm5SVXRVNmcxN2xQZjV5djJlVzlGUTlEQmVjMm5p?=
 =?utf-8?B?L2xOa3phbUg0QUdYamVJK2RETnMwaE84MktJTndaV0l6VUViT2JrQkNiUnRt?=
 =?utf-8?B?ZkNwdGcyazdRd2Z0UnBkWFQ5RVc5NXVhYzd5dnlWVHpyM2dtamJ1SkhSOHlv?=
 =?utf-8?B?alo1ODVSaHRXd3RzTXlvN2g0NEZFbzdDczRFd204blZpR1hHTnNVaWZyc2dm?=
 =?utf-8?B?OTZhMFRsNjZRV0JpZkxaL1hxOWtPcUZRRytZendWeUV3OFJ4S0dUWWwrc1Nj?=
 =?utf-8?B?ZTRFTmMwMUNkMFNvT2VmQ3lXTm9IT2xvWUV0YkpqdERUdVJ5NVZIa3p0dzY1?=
 =?utf-8?B?VFZPOXZPeHUyenFMY2dsajNpVnVYSUQyb1RUeFIxbzYzcnVoYTRJR2xEdnNq?=
 =?utf-8?B?cDJqUzA5TTdBUmJhNUlla1hycTMyZWt1cHd2SGs1Zks0czlCZ1lhVERpSWxQ?=
 =?utf-8?Q?1MuBf1rXIiu4EYwJb+M43pZARvY8OQdTiXbTf?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65271D495BC78340B2E5FE1DE8ADCF88@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feab8fb8-a06e-4ffb-9a6e-08da29292440
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 15:09:50.4333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9QfUcek9A9cI9lWVeE3aW2uowQ+M868uITwuv6AxFIs7wm3giFhGVFWeuHGofp5cqMWqUycwgrQy73iO1pDIyIIJ2WYs9qrcVekE/jiBIgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5049
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KT24gV2VkLCAyMDIyLTA0
LTI3IGF0IDE5OjU3ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gV2VkLCBBcHIgMjcsIDIwMjIgYXQg
MDk6NTM6NDNQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4gPiBNb3ZlZCB0aGUgcG9y
dF9taXJyb3JfYWRkIGFuZCBwb3J0X21pcnJvcl9kZWwgZnVuY3Rpb24gZnJvbSBrc3o5NDc3DQo+
ID4gdG8NCj4gDQo+IFByZXNlbnQgdGVuc2UgKG1vdmUpDQo+IA0KPiA+IGtzel9jb21tb24sIHRv
IG1ha2UgaXQgZ2VuZXJpYyBmdW5jdGlvbiB3aGljaCBjYW4gYmUgdXNlZCBieQ0KPiA+IEtTWjk0
NzcNCj4gPiBiYXNlZCBzd2l0Y2guDQo+IA0KPiBQcmVzdW1hYmx5IHlvdSBtZWFuICJ3aGljaCBj
YW4gYmUgdXNlZCBieSBvdGhlciBzd2l0Y2hlcyIgKGl0IGNhbg0KPiBhbHJlYWR5IGJlIHVzZWQg
Ynkga3N6OTQ3Nywgc28gdGhhdCBjYW4ndCBiZSB0aGUgYXJndW1lbnQgZm9yIG1vdmluZw0KPiBp
dCkNCkkgd2lsbCB1cGRhdGUgdGhlIGNvbW1pdCBkZXNjcmlwdGlvbi4NCj4gDQo+ID4gDQo+ID4g
U2lnbmVkLW9mZi1ieTogQXJ1biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9zc0BtaWNyb2NoaXAuY29t
Pg0KPiA+IC0tLQ0KPiANCj4gTG9va3MgZ29vZCwgZXhjZXB0IGZvciB0aGUgc3BlbGxpbmcgbWlz
dGFrZXMgaW4gdGhlIGNvZGUgdGhhdCBpcw0KPiBiZWluZw0KPiBtb3ZlZCAoaW50cm9kdWNlZCBp
biBwYXRjaCAxKSwgd2hpY2ggSSBleHBlY3QgeW91IHdpbGwgdXBkYXRlIGluIHRoZQ0KPiBuZXcN
Cj4gY29kZSBhcyB3ZWxsLg0KWWVzLCBJIHdpbGwgdXBkYXRlLiANCj4gDQo+IFJldmlld2VkLWJ5
OiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29tPg0KPiANCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfcmVnLmgNCj4gPiBiL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6X3JlZy5oDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBp
bmRleCAwMDAwMDAwMDAwMDAuLmNjZDRhNjU2OGUzNA0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiAr
KysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9yZWcuaA0KPiA+IEBAIC0wLDAgKzEs
MjkgQEANCj4gPiArLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgKi8NCj4gPiAr
LyoNCj4gPiArICogTWljcm9jaGlwIEtTWiBTd2l0Y2ggcmVnaXN0ZXIgZGVmaW5pdGlvbnMNCj4g
PiArICoNCj4gPiArICogQ29weXJpZ2h0IChDKSAyMDE3LTIwMjIgTWljcm9jaGlwIFRlY2hub2xv
Z3kgSW5jLg0KPiA+ICsgKi8NCj4gPiArDQo+ID4gKyNpZm5kZWYgX19LU1pfUkVHU19IDQo+ID4g
KyNkZWZpbmUgX19LU1pfUkVHU19IDQo+ID4gKw0KPiA+ICsjZGVmaW5lIFJFR19TV19NUklfQ1RS
TF8wICAgICAgICAgICAgMHgwMzcwDQo+ID4gKw0KPiA+ICsjZGVmaW5lIFNXX0lHTVBfU05PT1Ag
ICAgICAgICAgICAgICAgICAgICAgICBCSVQoNikNCj4gPiArI2RlZmluZSBTV19JUFY2X01MRF9P
UFRJT04gICAgICAgICAgIEJJVCgzKQ0KPiA+ICsjZGVmaW5lIFNXX0lQVjZfTUxEX1NOT09QICAg
ICAgICAgICAgQklUKDIpDQo+ID4gKyNkZWZpbmUgU1dfTUlSUk9SX1JYX1RYICAgICAgICAgICAg
ICAgICAgICAgIEJJVCgwKQ0KPiA+ICsNCj4gPiArLyogOCAtIENsYXNzaWZpY2F0aW9uIGFuZCBQ
b2xpY2luZyAqLw0KPiA+ICsjZGVmaW5lIFJFR19QT1JUX01SSV9NSVJST1JfQ1RSTCAgICAgMHgw
ODAwDQo+ID4gKw0KPiA+ICsjZGVmaW5lIFBPUlRfTUlSUk9SX1JYICAgICAgICAgICAgICAgICAg
ICAgICBCSVQoNikNCj4gPiArI2RlZmluZSBQT1JUX01JUlJPUl9UWCAgICAgICAgICAgICAgICAg
ICAgICAgQklUKDUpDQo+ID4gKyNkZWZpbmUgUE9SVF9NSVJST1JfU05JRkZFUiAgICAgICAgICBC
SVQoMSkNCj4gPiArDQo+ID4gKyNkZWZpbmUNCj4gPiBQX01JUlJPUl9DVFJMICAgICAgICAgICAg
ICAgICAgICAgICAgUkVHX1BPUlRfTVJJX01JUlJPUl9DVFJMDQo+ID4gKw0KPiA+ICsjZGVmaW5l
IFNfTUlSUk9SX0NUUkwgICAgICAgICAgICAgICAgICAgICAgICBSRUdfU1dfTVJJX0NUUkxfMA0K
PiANCj4gU21hbGwgY29tbWVudDogaWYgUF9NSVJST1JfQ1RSTCBhbmQgU19NSVJST1JfQ1RSTCBh
cmUgZXhwZWN0ZWQgdG8gYmUNCj4gYXQNCj4gdGhlIHNhbWUgcmVnaXN0ZXIgb2Zmc2V0IGZvciBh
bGwgc3dpdGNoIGZhbWlsaWVzLCB3aHkgaXMgdGhlcmUgYQ0KPiBtYWNybw0KPiBiZWhpbmQgYSBt
YWNybyBmb3IgdGhlaXIgYWRkcmVzc2VzPw0KDQprc3o4Nzk1IGFuZCBrc3o5NDc3IGhhdmUgZGlm
ZmVyZW50IGFkZHJlc3MvcmVnaXN0ZXIgZm9yIHRoZQ0KTWlycm9yX2N0cmwuIFRvIG1ha2UgaXQg
Y29tbW9uIGZvciB0aGUgYm90aCwgUF9NSVJST1JfQ1RSTCBpcyBkZWZpbmVkDQppbiBrc3o4Nzk1
X3JlZy5oIGFuZCBrc3o5NDc3X3JlZy5oIGZpbGUuDQpJIGp1c3QgY2FycmllZCBmb3J3YXJkIHRv
IGtzel9yZWcuaC4NCg0KPiANCj4gPiArDQo+ID4gKyNlbmRpZg0KPiA+IC0tDQo+ID4gMi4zMy4w
DQo+ID4gDQo=
