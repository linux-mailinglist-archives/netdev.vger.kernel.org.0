Return-Path: <netdev+bounces-11008-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3555873113F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDA922815BD
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD2520E8;
	Thu, 15 Jun 2023 07:48:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFC01C29
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:48:18 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBCF2D50;
	Thu, 15 Jun 2023 00:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686815294; x=1718351294;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OUDyttxw6iDv3yIYpzBcI8KxojZCRWY9Q94B+4CJEls=;
  b=KwccSQYkZ8IhmAES4va26J0Ra/l3q8wya1NngVVdiI7N5pMFfMup4N2E
   4/gZA8V+Cni/xxX0xvDZNjr+9tyRThto4axg0SIGecW4CHy5xiphRHYEb
   ZREl4cnG+LEg0dghRrDR48IhGO67zV9iSZYy7+Jgi30hzNNUkjJbtRBR8
   A9RgxaUb2WPnthBWeN257V0LIL6XzNBY1osBJYdSeOysCHfrvdcn8US3T
   9ak5fG8Z4CCnLd94W2i7hnw0YSFAkdY12axc6TcVUA6L30tdY1AsksSIW
   wZ2AwoJbrRZ61bTLghJEfp+aTlsEgzX2Ylr2p0vdPmhBhCVLuob9TqgKM
   g==;
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="218608659"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2023 00:48:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 15 Jun 2023 00:48:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 15 Jun 2023 00:48:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmaLWRxruYO4lsIDdEiAF8vcomiNBphOmcfLhqwVog2TBKAoaXwKZrZuLelV7w6FYxY1o+h9XESLqr/Q0XUof0hKzWzs5PjElTSw2cxe9v5K3ahbTonK1r3DpiQFDoj4nbvuvnyVH7eniq2BDBtaEPtR6OGCVte23riE3cBDEBqc2SrRAYy1SUzkpSqVRXQWMnIE1YhiL0M4zeWrh7EPw5wZ0Z6u2XESNiFm8JNZ8QOMvEUdtK4xIjcmumgANLqS9a2zGcJ2hNlkGnSaN0MLlNe4VRrNHOEwwK/gRFZpZmcSTXBLkbVgv2+Edk5JFkzc4KDnFSr/uxU9kh1i4sxctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUDyttxw6iDv3yIYpzBcI8KxojZCRWY9Q94B+4CJEls=;
 b=n/Gaczy64mZEp+OFR4t7AmlNZyK+6cSzKaotiL7LD2kXTVYNNorqeN4bpcZrvdm78YinwfAzHIZRot2GKktXLB6SFhN9j4d4IbD1U8b7C60xlCGaEfjgmO2+woMHOsBQpt4lgolO8RnaY8AGVByBNhMnzBh4bdnFuqf1UOkz6/UMieTzHbqABa4JkwnbvToluDhnlyF9yJ4xQNqKUYi8y2g9lbLABnSrwtN3yjwEEpz/S4r+AvM9Ccj0ifzOqpWBzvbtbJ8cQ5ojik3/rmWXpv5sqKISUvhnBRzAhTSVSC0/6WDO2BUWMBOdRQf1WNLgA+V2iwXdlKuFYFg7dXBmbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUDyttxw6iDv3yIYpzBcI8KxojZCRWY9Q94B+4CJEls=;
 b=QvMgkf8WaI3IFNmrJ+BgK3unRqHgWksTSkGnJwaJnMb5Vz6H2G8jEDqnSQkW3DfvevHZBkxEaO7Vzwi93qCGlTG9w0Ui03fc5lqR63sB0dla/cX4yuceRiV4E8NQ1R/62yCoKmwaFZ69Jn7//YTrnC7JLpui94TfpS6gsBo4Ug4=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by MN0PR11MB6256.namprd11.prod.outlook.com (2603:10b6:208:3c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 07:48:09 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6433.024; Thu, 15 Jun 2023
 07:48:09 +0000
From: <Claudiu.Beznea@microchip.com>
To: <Varshini.Rajendran@microchip.com>, <tglx@linutronix.de>,
	<maz@kernel.org>, <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<conor+dt@kernel.org>, <Nicolas.Ferre@microchip.com>,
	<alexandre.belloni@bootlin.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<gregkh@linuxfoundation.org>, <linux@armlinux.org.uk>,
	<mturquette@baylibre.com>, <sboyd@kernel.org>, <sre@kernel.org>,
	<broonie@kernel.org>, <arnd@arndb.de>, <gregory.clement@bootlin.com>,
	<sudeep.holla@arm.com>, <Balamanikandan.Gunasundar@microchip.com>,
	<Mihai.Sain@microchip.com>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-clk@vger.kernel.org>, <linux-pm@vger.kernel.org>
CC: <Hari.PrasathGE@microchip.com>, <Cristian.Birsan@microchip.com>,
	<Durai.ManickamKR@microchip.com>, <Manikandan.M@microchip.com>,
	<Dharma.B@microchip.com>, <Nayabbasha.Sayed@microchip.com>,
	<Balakrishnan.S@microchip.com>
Subject: Re: [PATCH 11/21] ARM: at91: add support in soc driver for new sam9x7
Thread-Topic: [PATCH 11/21] ARM: at91: add support in soc driver for new
 sam9x7
Thread-Index: AQHZn126zB270obSsESHTnBbH8FOYA==
Date: Thu, 15 Jun 2023 07:48:09 +0000
Message-ID: <629022ce-9eac-18db-0a44-eb5acde80d9e@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-12-varshini.rajendran@microchip.com>
In-Reply-To: <20230603200243.243878-12-varshini.rajendran@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|MN0PR11MB6256:EE_
x-ms-office365-filtering-correlation-id: f458b11d-990b-4afc-fb8a-08db6d74dcf6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qLr86cCZMCyIsAOjJ3/t9IMt/QoB8v666Lfwm4/smNvl6iLmGV/Zp3jbG/N+xcXvB1IsJrs3ryhfaLoJbthq5c2RC5zqDXroFIkr+YdSMGuCMf0p/C2gkBYc98jlkAKCk2qIAXgv715kNYNB4iSnHp4S1GejCzhRUur94CEm5azydz34CYN3/tSNLaPJnJoxIn+SIGaf0G1WTPDX9Cnwl5dkAo8GKNgl+FWzR9XGYnLzhz7HJRjjIMbBwYu8CRW2Cp59PzZ2VFKH7hsu1yznj4eZR0zM8NxE+GgtQnsTFDJWNreZ9agsCt2TM/xLrswBcfhK1bvXWzNszHIUWXiwaIVY5PkqkY2gkhs617FYbjxjKrT0D7l2VT9niWAYQp7xkjMK8Y3iQ/ZnGFs+lQ645F2Zp8EfhEcLwMq6HtW87b435hsycF/4KOMZj1C6GM4z/GNHi9WoQyY51UZ8qNjKqMHpAflJ2dBULOaOimhm2T23T0fOeVOaNGEEGnl11fuooxM+qfgoC6r9AFfrg+R/vZ4vSJMukHiojpiWcnh7eepTeCwHknpBZxCqMkj0R3Lo3Ss1n8Wbfewqr+0YZ+Ko1z6dm6gAC5JFvQzL3NUgO2R65wm1vtbDXtYul52vOgzVv3senjN8Yh3IpsgpfhyAKiDXfFqGY4u/XNs5Ftrt59Ui3QyIUVspYnxj/KWscS2FrsM/E5nylNSHdi8M0oTtwJ8oGBL4IQHHVf2yFwrlxoM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199021)(921005)(122000001)(38100700002)(38070700005)(71200400001)(478600001)(54906003)(110136005)(6486002)(7416002)(316002)(41300700001)(5660300002)(8936002)(8676002)(64756008)(66476007)(66446008)(76116006)(91956017)(66946007)(2906002)(66556008)(4326008)(6512007)(26005)(186003)(107886003)(53546011)(6506007)(2616005)(31696002)(36756003)(86362001)(31686004)(138113003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3BHYk9ydDBXc1d1VFJvSHRhcURuZURVSEVxcmxQZnRveHlQSGtBWGwrWGVn?=
 =?utf-8?B?VXlpOHVZc2xQbVNqR21ac1VBSGovM3pKRW1aS0t5Q1Z1RHBOcmdxSG5ycHFH?=
 =?utf-8?B?eUFVb3ZFZzRJTEpudFRZNWZzYW1oWFlseFB5WUNFd1czaWxHNDQ3WFBVRkFv?=
 =?utf-8?B?WWhDbEgzMWl5OTN4YldrR0hqbDk1dkRRZDN5OTdsWUlzVFhXSG1Jbm42UTNt?=
 =?utf-8?B?eHdLbzgvWUJMa2J5WXY0eGtNNDJvMTlRMkdBNGhGOGR6akN1cXBaMi84UnVD?=
 =?utf-8?B?YzFqd0pkSFRaSTAzSTdhdEU0d05pT016T1FxMDBVaThUSVljaXhiSEh0dWJX?=
 =?utf-8?B?RWZLVXlGTGprTmxBUC9nK1pXM3M2bnJFU3cwaUo3aTc1VmttZWFWaGtuVXh0?=
 =?utf-8?B?c0hldlBIL2QwSEkrcFRaQXhWTU9LczYyUUJxMEtuV0FUMElvRVh5dktNVEFY?=
 =?utf-8?B?VGdWRk9JR2pqYXRiNUhlNkxncHZLb3lVY0doQTVMOUJnR1Y1cEFmYk5Kcnps?=
 =?utf-8?B?WGxNY2tBd3JpZkRkOElGM3h0MlhpUmlxRDNGdXFHM2tyWDArakVPTUcwcmpj?=
 =?utf-8?B?aXpIaU95ZU1rMWxKdHlWUWl1MEFON09zUTZWbGZxQ3VvdVMzYUpiaFozV1Z4?=
 =?utf-8?B?T0U4b1hHYnRXempuSmgxcDRTN1NuYXJwNCs4UW0rVmViZS9zRUV3dGJ1SXRr?=
 =?utf-8?B?cHQ3WkEvTXk0YlVyU1ppaGxDZTN3QklvcnRHait5TEhURGc5MnVtcy9qVlJj?=
 =?utf-8?B?alhGVFNNK0hYVU9NWDVDZDhXOG5zUXY5dTBLUTRvUlF1bmRVeGNCRlc5YU5Q?=
 =?utf-8?B?UDFTVzFPWDJKdHlqakk4cW9HeTlMVXd4VE9jWjVFZHhWazRhTFJZRkVEdEdQ?=
 =?utf-8?B?ZTlkMTZVYWlWWnBLZ0sxQU8zemxyaGJNTW1tN3ZYODg3Ri92OEdveFhoKzhQ?=
 =?utf-8?B?UURXdnpSc0s1NTJmTVhWME9zT1E5bWdIOFRzU0FWb0dzb2ZPSVNzNjZLMWlL?=
 =?utf-8?B?eEdSZUlpN3pqajRFWm55OWhKMU1ERnVxcENrRXkzMHdsQU02dVBvM040Vjl6?=
 =?utf-8?B?bHNDbmFqY3I4NHhZWHNxTEJWYmFSYmtZbjlHb1IzbmtzbCtPdXVNMjZ4WFB6?=
 =?utf-8?B?S0E2RVZhSDk5RkRxaStSdDVqM2ZNekNBSjkrb0NIcDV6Z2YycExmMnhnWVhh?=
 =?utf-8?B?cHZqd1BzNUIrQzlBS29KdktneU9PeVFKMm5rczBENThYcmNGeVc3TnJ2cDRK?=
 =?utf-8?B?QlpGWEJOaDVybzZMb2J1TWlmUW5GNWJLZzkyeXFoSGdGOS9iY3YyRkZBcFU1?=
 =?utf-8?B?UzQwZWM1MXh1YW5wdE9UT2thTEhaSmt6dEQ0ZlZKeXBKWkgvdzVLdENUNEVR?=
 =?utf-8?B?VkNMNXRNMlAxa1FnSytmNzh6dWQ3SitOYUw1RDNIVlJDLzhJRi91NkpqWGw1?=
 =?utf-8?B?ZEYvMG9kS0lSNEtPRkJrUURIRVdPOWJtNndvNHJzQkd6T1hQalpwdlpkeUtD?=
 =?utf-8?B?Qlp1MGFWWEk0eXQvbHRkMkpmeFVDMXRNdjU5ekpGTnc5ZWQ2cGt2aVozTDRT?=
 =?utf-8?B?U2tzLzhpa2lpZkxHZ0dWZkFKTGNScHdORExSYWRxT2d3Mng2eWdNMWx2WFQ2?=
 =?utf-8?B?TUdoL0NUMkJhbk5hdTByZFFZZWZDanJzL0tTd0sva0lvUUZubk4ycGJFZnpC?=
 =?utf-8?B?V1B6eUsxZW1tNDd6cC9Ja01lMSsvVGFDUFpHc3RtYTNlNGk4UmFyUnh1V1dp?=
 =?utf-8?B?ZFNrV2tNVVBOeVhpK1E4QitvUEhwRnBkWXJMK3lUcHFZV3RxdS9OeHg0YXdP?=
 =?utf-8?B?Y082L3hlSUVCMVcvVytUNy9DbVNjWVBxT0lyU0NkclRheExLRUQrdjN5OGlm?=
 =?utf-8?B?QkZtOVlWU0t6bWlzN0xsbU16Qm10SXp0NW1DaVBJUHJzTklIL1RKYWVnemxQ?=
 =?utf-8?B?eVd1OWZYSlYwT213dWZJaU9ON01FRHFlZzA1OGhkWEpxMzNDNTZZWndJVTlP?=
 =?utf-8?B?YnlVSU9QeGFNTmpFQWdrZ2NJaWFJdzhqZmdXbEZOS280OXJIY0JPRmxLVnRH?=
 =?utf-8?B?ck8rL2Qwb0lCc0FheDNKWThJZ1p2TXpnOHYydklpalhweThoaEwxcW1IOHNk?=
 =?utf-8?Q?cEsfYyS5apjidFgFVRi3yQjmP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3A934390811EE49A4C3BA8E836CD642@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f458b11d-990b-4afc-fb8a-08db6d74dcf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 07:48:09.3735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xqwGzq9ugqsXH0WtrpgpuZy+n8QtFhrfWh04GdBAin6OYHCWq0LSikH+qZh2f0kTuSg+vuqv/OXAIFKtrclfy//Ce9K4RiRhlIvUsG/UyYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6256
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMDMuMDYuMjAyMyAyMzowMiwgVmFyc2hpbmkgUmFqZW5kcmFuIHdyb3RlOg0KPiBBZGQgc3Vw
cG9ydCBmb3IgU0FNOVg3IFNvQyBpbiB0aGUgc29jIGRyaXZlcg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogVmFyc2hpbmkgUmFqZW5kcmFuIDx2YXJzaGluaS5yYWplbmRyYW5AbWljcm9jaGlwLmNvbT4N
Cg0KUmV2aWV3ZWQtYnk6IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAu
Y29tPg0KDQoNCj4gLS0tDQo+ICBkcml2ZXJzL3NvYy9hdG1lbC9zb2MuYyB8IDIzICsrKysrKysr
KysrKysrKysrKysrKysrDQo+ICBkcml2ZXJzL3NvYy9hdG1lbC9zb2MuaCB8ICA5ICsrKysrKysr
Kw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zb2MvYXRtZWwvc29jLmMgYi9kcml2ZXJzL3NvYy9hdG1lbC9zb2MuYw0KPiBp
bmRleCBjYzlhM2UxMDc0NzkuLmNhZTM0NTJjYmM2MCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9z
b2MvYXRtZWwvc29jLmMNCj4gKysrIGIvZHJpdmVycy9zb2MvYXRtZWwvc29jLmMNCj4gQEAgLTEw
MSw2ICsxMDEsMjkgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBhdDkxX3NvYyBzb2NzW10gX19pbml0
Y29uc3QgPSB7DQo+ICAJCSBBVDkxX0NJRFJfVkVSU0lPTl9NQVNLLCBTQU05WDYwX0Q2S19FWElE
X01BVENILA0KPiAgCQkgInNhbTl4NjAgOE1pQiBTRFJBTSBTaVAiLCAic2FtOXg2MCIpLA0KPiAg
I2VuZGlmDQo+ICsjaWZkZWYgQ09ORklHX1NPQ19TQU05WDcNCj4gKwlBVDkxX1NPQyhTQU05WDdf
Q0lEUl9NQVRDSCwgQVQ5MV9DSURSX01BVENIX01BU0ssDQo+ICsJCSBBVDkxX0NJRFJfVkVSU0lP
Tl9NQVNLLCBTQU05WDc1X0VYSURfTUFUQ0gsDQo+ICsJCSAic2FtOXg3NSIsICJzYW05eDciKSwN
Cj4gKwlBVDkxX1NPQyhTQU05WDdfQ0lEUl9NQVRDSCwgQVQ5MV9DSURSX01BVENIX01BU0ssDQo+
ICsJCSBBVDkxX0NJRFJfVkVSU0lPTl9NQVNLLCBTQU05WDcyX0VYSURfTUFUQ0gsDQo+ICsJCSAi
c2FtOXg3MiIsICJzYW05eDciKSwNCj4gKwlBVDkxX1NPQyhTQU05WDdfQ0lEUl9NQVRDSCwgQVQ5
MV9DSURSX01BVENIX01BU0ssDQo+ICsJCSBBVDkxX0NJRFJfVkVSU0lPTl9NQVNLLCBTQU05WDcw
X0VYSURfTUFUQ0gsDQo+ICsJCSAic2FtOXg3MCIsICJzYW05eDciKSwNCj4gKwlBVDkxX1NPQyhT
QU05WDdfQ0lEUl9NQVRDSCwgU0FNOVg3NV9EMUdfRVhJRF9NQVRDSCwNCj4gKwkJIEFUOTFfQ0lE
Ul9WRVJTSU9OX01BU0ssIFNBTTlYNzVfRVhJRF9NQVRDSCwNCj4gKwkJICJzYW05eDc1IDFHYiBE
RFIzTCBTaVAgIiwgInNhbTl4NyIpLA0KPiArCUFUOTFfU09DKFNBTTlYN19DSURSX01BVENILCBT
QU05WDc1X0Q1TV9FWElEX01BVENILA0KPiArCQkgQVQ5MV9DSURSX1ZFUlNJT05fTUFTSywgU0FN
OVg3NV9FWElEX01BVENILA0KPiArCQkgInNhbTl4NzUgNTEyTWIgRERSMiBTaVAiLCAic2FtOXg3
IiksDQo+ICsJQVQ5MV9TT0MoU0FNOVg3X0NJRFJfTUFUQ0gsIFNBTTlYNzVfRDFNX0VYSURfTUFU
Q0gsDQo+ICsJCSBBVDkxX0NJRFJfVkVSU0lPTl9NQVNLLCBTQU05WDc1X0VYSURfTUFUQ0gsDQo+
ICsJCSAic2FtOXg3NSAxMjhNYiBERFIyIFNpUCIsICJzYW05eDciKSwNCj4gKwlBVDkxX1NPQyhT
QU05WDdfQ0lEUl9NQVRDSCwgU0FNOVg3NV9EMkdfRVhJRF9NQVRDSCwNCj4gKwkJIEFUOTFfQ0lE
Ul9WRVJTSU9OX01BU0ssIFNBTTlYNzVfRVhJRF9NQVRDSCwNCj4gKwkJICJzYW05eDc1IDJHYiBE
RFIzTCBTaVAiLCAic2FtOXg3IiksDQo+ICsjZW5kaWYNCj4gICNpZmRlZiBDT05GSUdfU09DX1NB
TUE1DQo+ICAJQVQ5MV9TT0MoU0FNQTVEMl9DSURSX01BVENILCBBVDkxX0NJRFJfTUFUQ0hfTUFT
SywNCj4gIAkJIEFUOTFfQ0lEUl9WRVJTSU9OX01BU0ssIFNBTUE1RDIxQ1VfRVhJRF9NQVRDSCwN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc29jL2F0bWVsL3NvYy5oIGIvZHJpdmVycy9zb2MvYXRt
ZWwvc29jLmgNCj4gaW5kZXggN2E5ZjQ3Y2U4NWZiLi4yNmRkMjZiNGYxNzkgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvc29jL2F0bWVsL3NvYy5oDQo+ICsrKyBiL2RyaXZlcnMvc29jL2F0bWVsL3Nv
Yy5oDQo+IEBAIC00NSw2ICs0NSw3IEBAIGF0OTFfc29jX2luaXQoY29uc3Qgc3RydWN0IGF0OTFf
c29jICpzb2NzKTsNCj4gICNkZWZpbmUgQVQ5MVNBTTlOMTJfQ0lEUl9NQVRDSAkJMHgwMTlhMDdh
MA0KPiAgI2RlZmluZSBTQU05WDYwX0NJRFJfTUFUQ0gJCTB4MDE5YjM1YTANCj4gICNkZWZpbmUg
U0FNQTdHNV9DSURSX01BVENICQkweDAwMTYyMTAwDQo+ICsjZGVmaW5lIFNBTTlYN19DSURSX01B
VENICQkweDA5NzUwMDIwDQo+ICANCj4gICNkZWZpbmUgQVQ5MVNBTTlNMTFfRVhJRF9NQVRDSAkJ
MHgwMDAwMDAwMQ0KPiAgI2RlZmluZSBBVDkxU0FNOU0xMF9FWElEX01BVENICQkweDAwMDAwMDAy
DQo+IEBAIC03NCw2ICs3NSwxNCBAQCBhdDkxX3NvY19pbml0KGNvbnN0IHN0cnVjdCBhdDkxX3Nv
YyAqc29jcyk7DQo+ICAjZGVmaW5lIFNBTUE3RzU0X0QyR19FWElEX01BVENICQkweDAwMDAwMDIw
DQo+ICAjZGVmaW5lIFNBTUE3RzU0X0Q0R19FWElEX01BVENICQkweDAwMDAwMDI4DQo+ICANCj4g
KyNkZWZpbmUgU0FNOVg3NV9FWElEX01BVENICQkweDAwMDAwMDAwDQo+ICsjZGVmaW5lIFNBTTlY
NzJfRVhJRF9NQVRDSAkJMHgwMDAwMDAwNA0KPiArI2RlZmluZSBTQU05WDcwX0VYSURfTUFUQ0gJ
CTB4MDAwMDAwMDUNCj4gKyNkZWZpbmUgU0FNOVg3NV9EMUdfRVhJRF9NQVRDSAkJMHgwMDAwMDAw
MQ0KPiArI2RlZmluZSBTQU05WDc1X0Q1TV9FWElEX01BVENICQkweDAwMDAwMDAyDQo+ICsjZGVm
aW5lIFNBTTlYNzVfRDFNX0VYSURfTUFUQ0gJCTB4MDAwMDAwMDMNCj4gKyNkZWZpbmUgU0FNOVg3
NV9EMkdfRVhJRF9NQVRDSAkJMHgwMDAwMDAwNg0KPiArDQo+ICAjZGVmaW5lIEFUOTFTQU05WEUx
MjhfQ0lEUl9NQVRDSAkweDMyOTk3M2EwDQo+ICAjZGVmaW5lIEFUOTFTQU05WEUyNTZfQ0lEUl9N
QVRDSAkweDMyOWE5M2EwDQo+ICAjZGVmaW5lIEFUOTFTQU05WEU1MTJfQ0lEUl9NQVRDSAkweDMy
OWFhM2EwDQoNCg==

