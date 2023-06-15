Return-Path: <netdev+bounces-11015-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D08731170
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 106921C20E47
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A1B211A;
	Thu, 15 Jun 2023 07:55:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24141379
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:55:07 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CFFEC;
	Thu, 15 Jun 2023 00:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686815705; x=1718351705;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XaS4v+A9DbveAmhcLDjOLdRIM8L3Dn0OBuNc8HcoZCw=;
  b=xV1E4r3X7BQYTeaB6VLvHfrVqfNauAR+sXqtNSf5I7uwfJPcCELb6KNc
   e+Zs8SyvxKMDyxWISj7Iyx2gONXGQzOfBPQXCdgyS8owAvvoHKxdgQIbQ
   jMGbIpGPwDBoQNeovp+fClRbVoDPYOprmlpYDaXrCWvZrbAh81Wqoyr6A
   K8ntaWOw5aE0y/YIwN01IeMCm8nyBYYnAttG4sek6X1j2meFrF2vcXjaO
   l1Bkq32r+BWV323sAb3CjWFZU+paJM25QHriMx66P2/8dFP0zMVSl/kxg
   74zIZjKMR8X267KD7LM4mNmMF4PSrv9i2tJDB2s8gpbEuO2UJNAKOUx8j
   g==;
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="157074426"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2023 00:55:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 15 Jun 2023 00:54:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 15 Jun 2023 00:54:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEjk+8o3tSs1r2rj/Iwi+m9sSIH8hhRfcVaWDZl60q0iq3ZsGcpYsxsQnRma2jm+IC4GxaG/qyf3Kr44DA9rVvc2eRGOkWC7669/Efb3mjiiddTYvVnpi8BjmStwD+DkmRx1z5z0zS0g8qW4dz9C3Al1MkpDw37FXXG4bHzNAkIVxKUbKIT5TVUidNyg6iJ+lr2xemIro02MY+EkqcHOrIgD2B6P1gCB5Akz/66+iaYAuO6IvCTRxwsQlhqwnHI9oTRDH5AvvMYvkrOdhAKCh//zaY4Jvhgif2N5Rin7+x5f/uk3PIlstZMCAst5y/S8HGYIfPb24pC/wov+A0YYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XaS4v+A9DbveAmhcLDjOLdRIM8L3Dn0OBuNc8HcoZCw=;
 b=ofu7Dns39xrwFUFNbLnrXm75j708EsvdfgadeoEWsZ1vZ86G13WqNbaMe59GHCgG2bv3iv9oS9XaZA3V09rH1slaGnpVe+5eEVImjs+FNx6PwZCzf2sPuIxBbi5opYTYhpxer4+RBjrOAutRAXblwWYA/8ZQugKsfM2sC6xZ2HirifGxVGFRJzDLIbateyCyxfgNdmvo2gh8MplQ+rsbmvG7IRrxp/8oDjiNMwszsj3/LPy0xB8++RPSPEGdc3K5YUislwhLx766AXDQ4efI9ykW8NfYiPZD/+r9+bfm4Nuw/k/tc8+fbUZaO8Si3TBuEOOUkjZG6z4BGeXlTGUnoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaS4v+A9DbveAmhcLDjOLdRIM8L3Dn0OBuNc8HcoZCw=;
 b=LCKX3sF5gvuNmgQq4kpJ6y2XxkoohzDJdlY24dh0b1Z+NOP+u3JnNLj46xTUezJU3CGQQrAwca1glk/ADFtC4g8a7q5zg7d5upCSiGEbImyeKhHmabzUaKMjw7mq/K5bRP4gKnBKQ1CXots63nwq8GtNNg6Sd1TgR0PoJlcutq4=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by MW4PR11MB6912.namprd11.prod.outlook.com (2603:10b6:303:22a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 07:54:47 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6433.024; Thu, 15 Jun 2023
 07:54:46 +0000
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
Subject: Re: [PATCH 12/21] clk: at91: clk-sam9x60-pll: re-factor to support
 individual core freq outputs
Thread-Topic: [PATCH 12/21] clk: at91: clk-sam9x60-pll: re-factor to support
 individual core freq outputs
Thread-Index: AQHZn16mwihaeYrez0y9isB+eNsEWQ==
Date: Thu, 15 Jun 2023 07:54:46 +0000
Message-ID: <49840bbc-99a9-4e40-d409-0f8216ed76dc@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-13-varshini.rajendran@microchip.com>
In-Reply-To: <20230603200243.243878-13-varshini.rajendran@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|MW4PR11MB6912:EE_
x-ms-office365-filtering-correlation-id: 84cf8b0d-d877-4071-ee04-08db6d75c9e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CgcpU4p/w1c4HDW1FU8vdpaGF3eAAt1X/9wsTT8DjOg/QNUew0Kb1U0cvInMcJ0zzznkRNfTSKJlzMeyUFhDKMbCJQV7WPW5D6YM2D1vWQ8I6fsC3+k1NopXGxjpccyrDdBQdE5r1w5UWxBaIeAh2EAQQ0tfqS9fpxWMLSYe5oVuPat8wDy/He7qZqv6MxcSaja+VOP5GGIhj5fN7i1JT/oY4hNncxpWXxfRFVEATBQePSVUM0q+90v8h6ryjQTR7m2SMBweCmYHEIkGyb544qiGfQSLuyMk3Op38ul21X033NKtkWS3PRqbtyvaGMbO3K+5HsDK8z4z9USyZQkFKfO0h9gV2jGKEfJFsW0+BSWLNkOYFnU5dqJ7ckzpc6aOKXIb0V/Ipf9oWpxyEsU12pKtg9XdWNX41JquHFseo8IKDOchCzKYmmxuWfu4cEo04i2iHUXXt3V3jz0Ob0/WdkStuew2jRtl5IkX6AtIyMDdbDpO2MExAg31R5WeTNAIX+tQJ21QWg1XAUYDkXnI0INNzPY70VDXOvyhMMiJf+9tc8J3t8bZVmNN/8hrTm4huo+7ortAiyRHEKQ03pWEwSFZXbV2ICK1kbVKcRNTyQ4STdFcDc1JhV/cGQhrzosNtSCnkQTlDSdrRWfWXqReXOoTLDLknY63mSVr8lleObcSoyu5TGI8G5sUoGUQUKJnCJjCFfzUW0FVCzN7Im9OyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199021)(53546011)(107886003)(6512007)(6506007)(26005)(36756003)(186003)(478600001)(71200400001)(6486002)(2906002)(316002)(41300700001)(8936002)(31696002)(86362001)(122000001)(31686004)(8676002)(5660300002)(921005)(7416002)(83380400001)(38070700005)(38100700002)(110136005)(54906003)(2616005)(64756008)(66556008)(66476007)(91956017)(76116006)(4326008)(66446008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czM2ZEZ1d0l0M3MrQkM5ZDRLVGlyYzU3WWJOQTNjSnYzQlNFWGtLRkZUSkR1?=
 =?utf-8?B?RTA3UnFTN244TEJnUmhHOHdjYi82a01Lb1ZScGhQVlNlSHIwZmJpSnJqQmEx?=
 =?utf-8?B?MW5WdWQyb28wRG9OWG5ONHg0RTYrUU4zLzBNN1gydjI0TlRBdER6bTZTbnBt?=
 =?utf-8?B?dzRzRmpOMWQ3VVc4ZjBNTTcwclF6M08vSTdXRkFhMVAzWjUzWHZ1TFdxSmlr?=
 =?utf-8?B?RlBKUHdnWXFFMGFYd0psSVBBVjVlVk8zWGhoenN5dEJUQi8vcExFaEpUZnp1?=
 =?utf-8?B?dXVhc2lxQVY0TEcxalltQkhONzFaOEdyZldqeldYTk9rdXEreDRjMHJHdVh5?=
 =?utf-8?B?ODRUMVFoSHRxeVpVSERkQWxJNlROQ3FBVk5RcWQ1VksvNDZsSE5namk5Y0l1?=
 =?utf-8?B?V0xrWTBPQkRtcUJHdWMzUzZZdGl5aFNBdWJrZTREVmQ0ZXAxR0IxRXFxWjk1?=
 =?utf-8?B?WHpLQ2ovYVI2UzUrOVRNeDR5WUhZbCt3VGxyWE1BTmp4bjBZWDY0b2hLdnFo?=
 =?utf-8?B?czF0UzBoREdlZTIvaEQ2S016UTJhdkxuNEJkMmQzS0xIeGZvMCt3eERYL2Nu?=
 =?utf-8?B?S3diVEJ6UjFKNFZENnRjZFMrSDFlMUFQNC9XVHBod0lLTlJMYmJBVGlCM0lL?=
 =?utf-8?B?bXRzTWZxbm8zTEtCUGRDWVpvS29NZDVJc0ZFSXRnY292M0VCclBVZzFacmIx?=
 =?utf-8?B?bGhreXBZcU52LzJ1ZXY3VXNvRW5sdTVFSjdZK2ZKK2N0WkxKa1hRY3lEeE5U?=
 =?utf-8?B?Wk1TMys0aEdwU2ZqMmF3c1kxTUhkdWVYRHdUWC9wckNhMmh0MzZER0VEemZa?=
 =?utf-8?B?aXFjY1J5Ni9laVkxWkI1YjlpZEFzaTdlemtpbUFTY0p3MTQvWVdkbThHWHlp?=
 =?utf-8?B?UFNDc3RuM2puMVlvS2duT2JCY0pDMnp2QlU5RE1mUjdNaTR1MHU3R1Z0bm8r?=
 =?utf-8?B?QVpMS29rVHVWOUJQekhXaDVsK3dGTDdad1pnMlhyTUdDelVodWVtcGV2ZFl3?=
 =?utf-8?B?VjlWeFBUM1lYaVJDeWJyNEFIM3IwMTltc0N1NmY1MHE0YnhGOHl6NDdUNEdR?=
 =?utf-8?B?ZGNERmkwTVBwZUYxUjVZVmtjSDZMbmUrUzZjNWhJanZVbDhwQWtKdjJZbmt6?=
 =?utf-8?B?bEF4TVROenkwNjhyMkwrNlQxSnhNZGN0QytGQ0VCanB1OC9pazR4UFU4dGJH?=
 =?utf-8?B?QmNuaE9CQXJtUkRydEU1QmdUOVE3Wk1QS0ViUnpwTEE1a2dIN1JjTm9NU3ZQ?=
 =?utf-8?B?TXA3Z1hNVFpkS0Q2dkNENWZJNXhMMVYvS3pORm84cXJzMGFjZHFOczcwei9s?=
 =?utf-8?B?blV6K1hhWEhzWldjVzc2cWpZeTRGNmxnaXpXQmRsUTFBYm9GY1BTQkJoOCtu?=
 =?utf-8?B?M2ZPZ1BvTUcvOElCTi9XNHVwMTRUUUFibkZRd050TzlwWm1RTWsyRWhSKy9R?=
 =?utf-8?B?NFo5aHhLbkhTMWlGeUg3S0pDMFQ4SEV6N3F5V1VEYU1ZbjQrMDdCOExXQUNH?=
 =?utf-8?B?MFY4d2J3NU1UWGhqcHBPUm53a2tPUTdqNG1ZSGVQSDdoYjBZNmRnVkppM3ZW?=
 =?utf-8?B?VWNMMWg4SXFXNEdPcE9YNTNib0dYdEYxTWs4WlhzSU1yb3Z4VXJsMkJyNFpM?=
 =?utf-8?B?cThhZFlOaEo0V1lIbS9sbUc4ZnRkSjZ2WTZlQzB3TjltQ3d4TTNpVTBMVlBr?=
 =?utf-8?B?VjFzcVd5djZ4UVJZczl4d1lpcmZGMDRCYXNGbGF6ZmZZalkyd3lXZUQ4anJI?=
 =?utf-8?B?Um5SbGQwQ2R1bFJvWklXbjhyS1g2aXQ5c1BvSGNDUEhhd0kwcVRteExtMDJB?=
 =?utf-8?B?RDVweHFlUmRuNk1LNzM1MzFNdVlYajBldk5lQU9uRGYyZTVEc3ZXY3dzTWZz?=
 =?utf-8?B?bTkrQjFoT3JGVVVmeGg2OUZZdTZ4cnczY1BneEIwOWlYUEFCS2ZtYk0yM01y?=
 =?utf-8?B?ZDZ6Zmdxa1FBcXllV0lHclR5bEljWFZ2R2szMUJoVmtPRmsvdjZlSmw3cnUx?=
 =?utf-8?B?d0xOUnA3TjZFZ0RtRkQ4dERXVmx3Zk5wbXErSDhqbTRidWZpcG43Z01DM1Jl?=
 =?utf-8?B?WnQ2bHBCSnZGVFdpNFUzeDRRVnplQzRSSDZwd1llcHFhd0RFYUxpek9YSDlr?=
 =?utf-8?B?MHoxc3lXbUMxS09jVzNJMFh4UU1aYVZEUEdTMWkzTU5LRTNzQU92UjJockRX?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8204A04563DCC44797031736EA592D8E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84cf8b0d-d877-4071-ee04-08db6d75c9e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 07:54:46.8347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CEuP+lBPiZSiRuWMn/lfqu9C94+QunU5NhcZ6Ojw0hOM5Oz1U+dgq3b9Npt2R+UKxHNiUNpId+HAYvYvGln9loJw6F1CHddjFC8VvBcL2Og=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6912
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMDMuMDYuMjAyMyAyMzowMiwgVmFyc2hpbmkgUmFqZW5kcmFuIHdyb3RlOg0KPiAtU3VwcG9y
dCBTb0NzIHdpdGggZGlmZmVyZW50IGNvcmUgZnJlcXVlbmN5IG91dHB1dHMgZm9yIGRpZmZlcmVu
dCBQTEwgSURzDQo+IGJ5IGFkZGluZyBhIHNlcGFyYXRlIHBhcmFtZXRlciBmb3IgaGFuZGxpbmcg
dGhlIHNhbWUgaW4gdGhlIFBMTCBkcml2ZXINCj4gLUFsaWduIHNhbTl4NjAgYW5kIHNhbWE3ZzUg
U29jIFBNQyBkcml2ZXIgdG8gUExMIGRyaXZlciBieSBhZGRpbmcgY29yZQ0KPiBvdXRwdXQgZnJl
cSByYW5nZSBpbiB0aGUgUExMIGNoYXJhY3RlcmlzdGljcyBjb25maWd1cmF0aW9ucw0KDQpIYXZp
bmcgdGhpcyB3aXRoICItIiBoZXJlIG1ha2VzIG1lIHRoaW5rIHlvdSBkaWQgbXVsdGlwbGUgdGhp
bmdzIGluIHRoZQ0Kc2FtZSBwYXRjaC4gUGxlYXNlIGV4cGxhaW4gY29tcHJlaGVuc2l2ZWx5IHdo
YXQgeW91J3ZlIGRpZCwgd2h5IGFuZCBob3cuDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFZhcnNo
aW5pIFJhamVuZHJhbiA8dmFyc2hpbmkucmFqZW5kcmFuQG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0K
PiAgZHJpdmVycy9jbGsvYXQ5MS9jbGstc2FtOXg2MC1wbGwuYyB8IDEyICsrKysrKy0tLS0tLQ0K
PiAgZHJpdmVycy9jbGsvYXQ5MS9wbWMuaCAgICAgICAgICAgICB8ICAxICsNCj4gIGRyaXZlcnMv
Y2xrL2F0OTEvc2FtOXg2MC5jICAgICAgICAgfCAgNyArKysrKysrDQo+ICBkcml2ZXJzL2Nsay9h
dDkxL3NhbWE3ZzUuYyAgICAgICAgIHwgIDcgKysrKysrKw0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAy
MSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvY2xrL2F0OTEvY2xrLXNhbTl4NjAtcGxsLmMgYi9kcml2ZXJzL2Nsay9hdDkxL2Nsay1zYW05
eDYwLXBsbC5jDQo+IGluZGV4IDA4ODJlZDAxZDVjMi4uYjMwMTI2NDEyMTRjIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL2Nsay9hdDkxL2Nsay1zYW05eDYwLXBsbC5jDQo+ICsrKyBiL2RyaXZlcnMv
Y2xrL2F0OTEvY2xrLXNhbTl4NjAtcGxsLmMNCj4gQEAgLTIzLDkgKzIzLDYgQEANCj4gICNkZWZp
bmUgVVBMTF9ESVYJCTINCj4gICNkZWZpbmUgUExMX01VTF9NQVgJCShGSUVMRF9HRVQoUE1DX1BM
TF9DVFJMMV9NVUxfTVNLLCBVSU5UX01BWCkgKyAxKQ0KPiAgDQo+IC0jZGVmaW5lIEZDT1JFX01J
TgkJKDYwMDAwMDAwMCkNCj4gLSNkZWZpbmUgRkNPUkVfTUFYCQkoMTIwMDAwMDAwMCkNCj4gLQ0K
PiAgI2RlZmluZSBQTExfTUFYX0lECQk3DQo+ICANCj4gIHN0cnVjdCBzYW05eDYwX3BsbF9jb3Jl
IHsNCj4gQEAgLTE5NCw3ICsxOTEsOCBAQCBzdGF0aWMgbG9uZyBzYW05eDYwX2ZyYWNfcGxsX2Nv
bXB1dGVfbXVsX2ZyYWMoc3RydWN0IHNhbTl4NjBfcGxsX2NvcmUgKmNvcmUsDQo+ICAJdW5zaWdu
ZWQgbG9uZyBubXVsID0gMDsNCj4gIAl1bnNpZ25lZCBsb25nIG5mcmFjID0gMDsNCj4gIA0KPiAt
CWlmIChyYXRlIDwgRkNPUkVfTUlOIHx8IHJhdGUgPiBGQ09SRV9NQVgpDQo+ICsJaWYgKHJhdGUg
PCBjb3JlLT5jaGFyYWN0ZXJpc3RpY3MtPmNvcmVfb3V0cHV0WzBdLm1pbiB8fA0KPiArCSAgICBy
YXRlID4gY29yZS0+Y2hhcmFjdGVyaXN0aWNzLT5jb3JlX291dHB1dFswXS5tYXgpDQo+ICAJCXJl
dHVybiAtRVJBTkdFOw0KPiAgDQo+ICAJLyoNCj4gQEAgLTIxNCw3ICsyMTIsOCBAQCBzdGF0aWMg
bG9uZyBzYW05eDYwX2ZyYWNfcGxsX2NvbXB1dGVfbXVsX2ZyYWMoc3RydWN0IHNhbTl4NjBfcGxs
X2NvcmUgKmNvcmUsDQo+ICAJfQ0KPiAgDQo+ICAJLyogQ2hlY2sgaWYgcmVzdWx0ZWQgcmF0ZSBp
cyBhIHZhbGlkLiAgKi8NCj4gLQlpZiAodG1wcmF0ZSA8IEZDT1JFX01JTiB8fCB0bXByYXRlID4g
RkNPUkVfTUFYKQ0KPiArCWlmICh0bXByYXRlIDwgY29yZS0+Y2hhcmFjdGVyaXN0aWNzLT5jb3Jl
X291dHB1dFswXS5taW4gfHwNCj4gKwkgICAgdG1wcmF0ZSA+IGNvcmUtPmNoYXJhY3RlcmlzdGlj
cy0+Y29yZV9vdXRwdXRbMF0ubWF4KQ0KPiAgCQlyZXR1cm4gLUVSQU5HRTsNCj4gIA0KPiAgCWlm
ICh1cGRhdGUpIHsNCj4gQEAgLTY2Niw3ICs2NjUsOCBAQCBzYW05eDYwX2Nsa19yZWdpc3Rlcl9m
cmFjX3BsbChzdHJ1Y3QgcmVnbWFwICpyZWdtYXAsIHNwaW5sb2NrX3QgKmxvY2ssDQo+ICAJCQln
b3RvIGZyZWU7DQo+ICAJCX0NCj4gIA0KPiAtCQlyZXQgPSBzYW05eDYwX2ZyYWNfcGxsX2NvbXB1
dGVfbXVsX2ZyYWMoJmZyYWMtPmNvcmUsIEZDT1JFX01JTiwNCj4gKwkJcmV0ID0gc2FtOXg2MF9m
cmFjX3BsbF9jb21wdXRlX211bF9mcmFjKCZmcmFjLT5jb3JlLA0KPiArCQkJCQkJCWNoYXJhY3Rl
cmlzdGljcy0+Y29yZV9vdXRwdXRbMF0ubWluLA0KPiAgCQkJCQkJCXBhcmVudF9yYXRlLCB0cnVl
KTsNCj4gIAkJaWYgKHJldCA8IDApIHsNCj4gIAkJCWh3ID0gRVJSX1BUUihyZXQpOw0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9jbGsvYXQ5MS9wbWMuaCBiL2RyaXZlcnMvY2xrL2F0OTEvcG1jLmgN
Cj4gaW5kZXggMWIzY2E3ZGQ5YjU3Li4zZTM2ZGNjNDY0YzEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvY2xrL2F0OTEvcG1jLmgNCj4gKysrIGIvZHJpdmVycy9jbGsvYXQ5MS9wbWMuaA0KPiBAQCAt
NzUsNiArNzUsNyBAQCBzdHJ1Y3QgY2xrX3BsbF9jaGFyYWN0ZXJpc3RpY3Mgew0KPiAgCXN0cnVj
dCBjbGtfcmFuZ2UgaW5wdXQ7DQo+ICAJaW50IG51bV9vdXRwdXQ7DQo+ICAJY29uc3Qgc3RydWN0
IGNsa19yYW5nZSAqb3V0cHV0Ow0KPiArCWNvbnN0IHN0cnVjdCBjbGtfcmFuZ2UgKmNvcmVfb3V0
cHV0Ow0KPiAgCXUxNiAqaWNwbGw7DQo+ICAJdTggKm91dDsNCj4gIAl1OCB1cGxsIDogMTsNCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL2F0OTEvc2FtOXg2MC5jIGIvZHJpdmVycy9jbGsvYXQ5
MS9zYW05eDYwLmMNCj4gaW5kZXggYWMwNzBkYjU4MTk1Li40NTJhZDQ1Y2YyNTEgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvY2xrL2F0OTEvc2FtOXg2MC5jDQo+ICsrKyBiL2RyaXZlcnMvY2xrL2F0
OTEvc2FtOXg2MC5jDQo+IEBAIC0yNiwxMCArMjYsMTYgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBj
bGtfcmFuZ2UgcGxsYV9vdXRwdXRzW10gPSB7DQo+ICAJeyAubWluID0gMjM0Mzc1MCwgLm1heCA9
IDEyMDAwMDAwMDAgfSwNCj4gIH07DQo+ICANCj4gKy8qIEZyYWN0aW9uYWwgUExMIGNvcmUgb3V0
cHV0IHJhbmdlLiAqLw0KPiArc3RhdGljIGNvbnN0IHN0cnVjdCBjbGtfcmFuZ2UgY29yZV9vdXRw
dXRzW10gPSB7DQo+ICsJeyAubWluID0gNjAwMDAwMDAwLCAubWF4ID0gMTIwMDAwMDAwMCB9LA0K
PiArfTsNCj4gKw0KPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBjbGtfcGxsX2NoYXJhY3RlcmlzdGlj
cyBwbGxhX2NoYXJhY3RlcmlzdGljcyA9IHsNCj4gIAkuaW5wdXQgPSB7IC5taW4gPSAxMjAwMDAw
MCwgLm1heCA9IDQ4MDAwMDAwIH0sDQo+ICAJLm51bV9vdXRwdXQgPSBBUlJBWV9TSVpFKHBsbGFf
b3V0cHV0cyksDQo+ICAJLm91dHB1dCA9IHBsbGFfb3V0cHV0cywNCj4gKwkuY29yZV9vdXRwdXQg
PSBjb3JlX291dHB1dHMsDQo+ICB9Ow0KPiAgDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGNsa19y
YW5nZSB1cGxsX291dHB1dHNbXSA9IHsNCj4gQEAgLTQwLDYgKzQ2LDcgQEAgc3RhdGljIGNvbnN0
IHN0cnVjdCBjbGtfcGxsX2NoYXJhY3RlcmlzdGljcyB1cGxsX2NoYXJhY3RlcmlzdGljcyA9IHsN
Cj4gIAkuaW5wdXQgPSB7IC5taW4gPSAxMjAwMDAwMCwgLm1heCA9IDQ4MDAwMDAwIH0sDQo+ICAJ
Lm51bV9vdXRwdXQgPSBBUlJBWV9TSVpFKHVwbGxfb3V0cHV0cyksDQo+ICAJLm91dHB1dCA9IHVw
bGxfb3V0cHV0cywNCj4gKwkuY29yZV9vdXRwdXQgPSBjb3JlX291dHB1dHMsDQo+ICAJLnVwbGwg
PSB0cnVlLA0KPiAgfTsNCj4gIA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvYXQ5MS9zYW1h
N2c1LmMgYi9kcml2ZXJzL2Nsay9hdDkxL3NhbWE3ZzUuYw0KPiBpbmRleCBmMTM1YjY2MmYxZmYu
LjQ2OGEzYzU0NDliNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jbGsvYXQ5MS9zYW1hN2c1LmMN
Cj4gKysrIGIvZHJpdmVycy9jbGsvYXQ5MS9zYW1hN2c1LmMNCj4gQEAgLTEwNCwxMSArMTA0LDE3
IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgY2xrX3JhbmdlIHBsbF9vdXRwdXRzW10gPSB7DQo+ICAJ
eyAubWluID0gMjM0Mzc1MCwgLm1heCA9IDEyMDAwMDAwMDAgfSwNCj4gIH07DQo+ICANCj4gKy8q
IEZyYWN0aW9uYWwgUExMIGNvcmUgb3V0cHV0IHJhbmdlLiAqLw0KPiArc3RhdGljIGNvbnN0IHN0
cnVjdCBjbGtfcmFuZ2UgY29yZV9vdXRwdXRzW10gPSB7DQo+ICsJeyAubWluID0gNjAwMDAwMDAw
LCAubWF4ID0gMTIwMDAwMDAwMCB9LA0KPiArfTsNCj4gKw0KPiAgLyogQ1BVIFBMTCBjaGFyYWN0
ZXJpc3RpY3MuICovDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGNsa19wbGxfY2hhcmFjdGVyaXN0
aWNzIGNwdV9wbGxfY2hhcmFjdGVyaXN0aWNzID0gew0KPiAgCS5pbnB1dCA9IHsgLm1pbiA9IDEy
MDAwMDAwLCAubWF4ID0gNTAwMDAwMDAgfSwNCj4gIAkubnVtX291dHB1dCA9IEFSUkFZX1NJWkUo
Y3B1X3BsbF9vdXRwdXRzKSwNCj4gIAkub3V0cHV0ID0gY3B1X3BsbF9vdXRwdXRzLA0KPiArCS5j
b3JlX291dHB1dCA9IGNvcmVfb3V0cHV0cywNCj4gIH07DQo+ICANCj4gIC8qIFBMTCBjaGFyYWN0
ZXJpc3RpY3MuICovDQo+IEBAIC0xMTYsNiArMTIyLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBj
bGtfcGxsX2NoYXJhY3RlcmlzdGljcyBwbGxfY2hhcmFjdGVyaXN0aWNzID0gew0KPiAgCS5pbnB1
dCA9IHsgLm1pbiA9IDEyMDAwMDAwLCAubWF4ID0gNTAwMDAwMDAgfSwNCj4gIAkubnVtX291dHB1
dCA9IEFSUkFZX1NJWkUocGxsX291dHB1dHMpLA0KPiAgCS5vdXRwdXQgPSBwbGxfb3V0cHV0cywN
Cj4gKwkuY29yZV9vdXRwdXQgPSBjb3JlX291dHB1dHMsDQo+ICB9Ow0KPiAgDQo+ICAvKg0KDQo=

