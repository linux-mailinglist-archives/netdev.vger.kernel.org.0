Return-Path: <netdev+bounces-11018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B53073119F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD1151C20752
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F02A4431;
	Thu, 15 Jun 2023 08:01:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6315B1C29
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:01:01 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A66D2D4A;
	Thu, 15 Jun 2023 01:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686816055; x=1718352055;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UlLduwuUrGmy7UyOZ6HrNNpN2hyiFcjrgVn0e6+tgEE=;
  b=unxUVYp/rkeeA5Wk3L3lZfU9TBYlMOyoXjDOCxuZ6BleZ6r2wHgRoNip
   HCOqyQNs5iZUXJuTqO0IpCFSrh08Ij4i8VimD02cWeQhihwnZ4usFbX7I
   PtrgDBVft6E0aBGLsJHFa36YI60pcwmtkrvGmyfsMQuq/umwcsDXCUi9o
   T7nern960sax0+tV9uCfvdG/747yfa0uiLvCNhvQH0w2Wz9l/XkmjkBoh
   eKZDdinGCoYe85ZCyOsz9UX7fTvOQgYpUMUjsw6SvOe0tE8Pk5FTQjSp9
   9hUD8fGCeYUTNvb6h6u59L1db18Qem0MMwQHAienvntUP3QZyOOMqvaPT
   w==;
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="230252039"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2023 01:00:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 15 Jun 2023 01:00:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 15 Jun 2023 01:00:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LnGkrzMrGubei3znMdEzdff93MlIMb66Ga2ryraXzYlaTGeUjd/3DVcaj+ccpaFmgSwlKN/YOx46GtEHvY8w5gajxdIljuoKcXoWUcG/u2pS5rsH5Re5/xyIUtzkYpEW+D2rIySNM2hjn+kYyxBYtc/rLKuCCngMzj8ulyHuAv8q7xeoLLkTV8xX45XrIPElxOVsIGM5NW/cKeUFLYSH5jP/bT5Jwc+ZfYwG+D40VNEFyYRt1ZMsDDsx3mo9iKQMFa75IYcvLKwsmxi5Tam/fOebpEtuEL2sZbI85snwFBEovRjqg51ZibkemxMXe+h5nrC7rz+WU3rWW/XgI8/fZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlLduwuUrGmy7UyOZ6HrNNpN2hyiFcjrgVn0e6+tgEE=;
 b=EpCIdaqoYgSWEySxvGr+gKqT8ePvtm/dHAK3BQqYo3aP6omqVON6eK1FZ7dIWOdL3vRdilqQfB2koeVbnQvqlQxdo6H51S+tL7evyb3z6u1wep+F22fSr6OpGOLPoYm2k/ObIHEPhurlqi047I38QeTCxDH7jrB4ON4h4MacvYwXZ5OJ0JaKopNz5vdKToppT2mtHbf5FJs1seXdN7o0yKednuPp5ADFmJnQSaCZJl/qnbhzk7IZBxGdi4QDyU38YtuAYOUU7jd7IatTQ4bSGftksxd7XSqPqjtZnkcmnppsY/6fybxW6zZFE2qu9X1MJlmlaHdzYDgO4rP/X2J7zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlLduwuUrGmy7UyOZ6HrNNpN2hyiFcjrgVn0e6+tgEE=;
 b=AVKT3X67Wvp1rh6LVllFG+dGX80QyFTPTCUXtM2ighFjc14brjo6F7Uo7NJ0YOHFgyuuQiwoyo742Rr0Re26h2CYE1r+mBVSEm6hU6oAxyFAaN/37kNdFdPn2gWCDo7+MtyvxxaxA8zHXksxZXQ0f+khIAkO8DI3opwYrij75kQ=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by CO6PR11MB5665.namprd11.prod.outlook.com (2603:10b6:5:354::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Thu, 15 Jun
 2023 08:00:46 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6433.024; Thu, 15 Jun 2023
 08:00:45 +0000
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
Subject: Re: [PATCH 13/21] clk: at91: sam9x7: add support for HW PLL freq
 dividers
Thread-Topic: [PATCH 13/21] clk: at91: sam9x7: add support for HW PLL freq
 dividers
Thread-Index: AQHZn198fBB9K0qgYUecT+pwgePU7A==
Date: Thu, 15 Jun 2023 08:00:45 +0000
Message-ID: <71d6e453-16bd-a5ce-bb95-8e615a944fb2@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-14-varshini.rajendran@microchip.com>
In-Reply-To: <20230603200243.243878-14-varshini.rajendran@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|CO6PR11MB5665:EE_
x-ms-office365-filtering-correlation-id: 6d23e002-9ec5-4268-593e-08db6d769fdd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GgQi8MrdYaWgEM2W6fhhREhNkxaZ7PIY7sK74KxeyYsOCLDyEtegSxAxfUkWm1SMZJJeg8sQ5RTm2iRPDIIXWOcO5cfjSpTgr0dwA7EEeMfRnrKOh3oc988Sw2p2EyMxST1PqzE5bVKwb1/geyfjwek2O/TlThmJtJPCzIC1qVPm41SHxNzaFiPBCkfgpbf+MSSHL+6QpuynQ/u/z0zHUCxNL5FO1A9fqXd3tdtYP6FO3m2ARDfOSm95RtOTOM+o6LRSwNDruBe036QiGHv2chEDT3+ed4pOLKE+tTdjC5e8ZHYz3KyUZCUxKYsYUwmtLMp13UY3KXSbVjyxEAKIQJ0oYI3BuOP1YOFZp8gLueEew+cyVLw6hS+Rb9XCG6SzYofkqAMZUe85+UEDDqRzbza8vwkJn6kngDoqABOUxSLctgPE3HrPX97SO5ns2Gk1VyonOSZvU89A57+pY1mvjfaM+LbcEXNR07MSEZfP4x/BXj/xasA2GNZbA1mlFT6Fw5NIF9g65ki0E/6v20NsxWAZL5T1RayW/HfcQ3T6jXjWETMyCVsPCgS/cBf2lU3Rrv5XokL0cSw/QDZrDDkaTQDJQimyjo/+s8xvjNVEhvkS2kznJuMoWGKvs8NYGCAAswbUC8hmfYeBnwUHAVTucqNP7n9Q5zJLOV1L+ZuccLnshm1WfGNXG7CO4woBTy8w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199021)(2906002)(26005)(6512007)(186003)(83380400001)(2616005)(66946007)(76116006)(66476007)(64756008)(66446008)(66556008)(71200400001)(91956017)(31686004)(4326008)(41300700001)(8936002)(8676002)(6486002)(316002)(110136005)(54906003)(31696002)(86362001)(36756003)(38100700002)(478600001)(122000001)(921005)(38070700005)(7416002)(53546011)(6506007)(966005)(5660300002)(107886003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFBqVXFtdllzZzdJWHY4Y2Y1cHJNWWI3Kzh5blF1d09wdmxKZHpwckhZQ2tr?=
 =?utf-8?B?VzdETVZha284ZENsdlhMdk5GVmV5RlJNQWFYSTRCTU9kTEJneUhnNEFSaGJz?=
 =?utf-8?B?MTUyZFh5aW9VRTd4V0lVQVpxMWJ3TTJJWlhCSUc4U2xlbHBZL3l4ZHRaTWc4?=
 =?utf-8?B?Y0NqNSs0VGQwR0NUOHp4WVc0WGRIQURhcDM3WUowWkYvaDJWczYzcXZyeFRY?=
 =?utf-8?B?SHE0M3M1YXk0RDhBbEJKWEtVa3VTOHFNWU1LR2g4d29OK1VkVFpVcjhFem16?=
 =?utf-8?B?WnBDWXRQWjBUQndKQ1pjVGlxWmZCOHN4WjBnR20ybkVTZG1RWlZNVkhPRUQ4?=
 =?utf-8?B?c2p2dkdTVzJUcU13MnZBbEgveTZiV2ZLTkx4MUlFaDRmUjZZZ2hPTllBWE1M?=
 =?utf-8?B?dmZmOG1qS1RQOGY0SUFsUVk0dnp6TzRCeTN1RlpRQ25XdjNUb25NRGpHdFE2?=
 =?utf-8?B?dm1VbHhsYlpDY3dSa0ZhVmNZZG43ZjZxU0hpTlNHMTAvODVxMG9RZ01QU1p0?=
 =?utf-8?B?ZFdPWE1kSGtDd2ZsbE5RWGxqNmtvUWg4VVFxZFU0dUtnckpxWS9qT1pJQkhz?=
 =?utf-8?B?OERISkE4RGJGVHhPL25oTG5JMURRTlE2SFkwV3VBTUJ1SU5WZExZcksycVAy?=
 =?utf-8?B?WU5NUjNZcHRIRVBWaEs2WDR1cnZiUzB6aWllb0N6R2RhQnVxUkRFVHlXaDAv?=
 =?utf-8?B?M1VtTnpJb2pWUzJJdTlNdkhuMDMzWkFraUJwZ3FhcTdtNzF4elFmQnRKekl5?=
 =?utf-8?B?MndnYjRzOThTdk92dDM1MHlVTlVpR1VTVHAvaVBSd2tNRXNnL0xLVVo3eitY?=
 =?utf-8?B?cUFjejJWV0FPYkhMUXhmdGhyY1N1bGYybktROTRUQTZQTVQ4Syt1WEsvZ3U1?=
 =?utf-8?B?dGNnNFFnRHpGK1NwT2pxakNKQlZ6WXh0ajQrajlBN0xTTjExWEdoTUVDTGlT?=
 =?utf-8?B?SVN6VXlEWEJBdGtlajVGNE1sWUcwZ2N3TDAyeHpxMmxPR2J6RThVbllla2xP?=
 =?utf-8?B?U1h2cm0xZFpxaXQvMFFxNkFST0dnaWpNODV2c05yMVRkaEtjYjZ3KzRqdHFB?=
 =?utf-8?B?QVVpaVhDNTl0Q0dQcllaTWhSUW1Mc2RtU3pKYWhnMWl2ZC9SVDNiTUVQYmk2?=
 =?utf-8?B?NzRUVHRFclBqR0JSMXRydWIyenE3YmxGamtQY3BkMCtBKzJNOGZySkgyOGY3?=
 =?utf-8?B?R2VrVnB0b2lQclJQZGI3VU95bGdXN29rdnBkZlVmVGZUNGVpTTA2UDdOWWMr?=
 =?utf-8?B?V1N2VmtzYW82LzlXcGJ0SHgzVGhIc3diN2FpWGNHOGZ4dlI5L2lsbkNEdXcr?=
 =?utf-8?B?WnE5VEJFazJ5Y0tSV3BJOFVVd21UNjhkOXd6VkFPanQyTVRrMUNBSUtkV2pJ?=
 =?utf-8?B?RkZ4WE5ERGUranluVE12V1NscG1TSTd5am8rY09lVGsxWVFPakc1VmFncERm?=
 =?utf-8?B?T2xUNEhaK0JWZWF1cVRwY0w5ay9DNEg2UXZuWTJrcmhycGMwRUczY1RTYVFS?=
 =?utf-8?B?c2V3TWlnOUxZUWU2ZWhiNXFkMHFwdUtEckpqVkpOY212VWkrRHNyTHpRcXAx?=
 =?utf-8?B?QTVmWDA2Unk4S0NhL01hWnFwVFh4RUNYa3BjdGxsdFlld3p6NkF6SVpGclJl?=
 =?utf-8?B?VEJybmMyb3hDNW1JaC9MOWwwbWRQemlVblZ4aDd6aFJjWFNWekhOcmt5T0NR?=
 =?utf-8?B?Tm9CMVVmRlAzWHNqL0ZSL0gzNEhmTmwxVnRnZHg5SGZMaXpJTkJiRHFXcThC?=
 =?utf-8?B?SzhqRHVpN3o2TTFYZVRLVDBqRUtDZzg0aG9pZThzQy9DWUhldmxuWjg4ZnNi?=
 =?utf-8?B?Qk82MUhhYWIxcXhLakNmaFliN081dnVkdlQ3L1BXeTFsWnJjdDEyNXcxV0lP?=
 =?utf-8?B?TjFabGRWZVdCNHQ3TWQwNmhQdkhWWWhXb0RhRWRFcUsyTW9yT2FWOXRTTFpZ?=
 =?utf-8?B?cUZxQnVrU1c5ZzBMYkJjVWltSnV2d2JtcXdXS0RxdldHeWJaRjVDRUQ4c0s5?=
 =?utf-8?B?SVF4anU3UmkzdEFQcGtYRGpyL2RBRjBRTzlDMmVqbVcyNzNSMW1CQjlTVDdy?=
 =?utf-8?B?aFl5RXFVMVZkaXNvSFdLTzZkZEFpVDN0VHZyVmtKMFlTa3BueHVqc3BuVHVM?=
 =?utf-8?B?UlFUUjJvakdodDdoNkxraVUxL0wxejNFUkRkRnIwR3pGYWJzZ29FcDRLZytq?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <590194D03585B34F9173E35B987003AA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d23e002-9ec5-4268-593e-08db6d769fdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 08:00:45.8159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SK9teYCbHir4p7fbmADzBPiK7WcXueOwlBucxRcme47D+TsMNF4SDkPiNa2kgljc0zNwrQQLKxfFIBQpTX4lXilULKKQp6eDT7qcSpnNyGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5665
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMDMuMDYuMjAyMyAyMzowMiwgVmFyc2hpbmkgUmFqZW5kcmFuIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEFkZCBzdXBwb3J0IGZvciBoYXJkd2Fy
ZSBkaXZpZGVycyBmb3IgUExMIElEcyBpbiBzYW05eDcgU29jDQoNCmRvdCBhdCB0aGUgZW5kIG9m
IGxpbmUsIHByb2JhYmx5Lg0Kcy9Tb2MvU29DLiBBbHNvLCBwbGVhc2UgZXhwbGFpbiBpdCBhcyBj
bGVhciBhcyBwb3NzaWJsZS4NCg0KPiBQTExfSURfUExMQSBhbmQgUExMX0lEX1BMTEFfRElWMiBo
YXMgLzIgaGFyZHdhcmUgZGl2aWRlcnMgZWFjaA0KDQpBdCB0aGUgdGltZSBvZiB0aGlzIHBhdGNo
IFBMTF9JRF9QTExBIGFuZCBQTExfSURfUExMQV9ESVYyIGRvZXMndCBleGlzdA0KdGh1cyB3b3Vs
ZCBiZSBtb3JlIGNsZWFyIGlmIHlvdSByZWZlcmVuY2UgZGF0YXNoZWV0IG5hbWluZy4NCg0KT3Ro
ZXIgdGhhbiB0aGlzIGNvZGUgbG9va3MgZ29vZCB0byBtZS4NCg0KVGhhbmsgeW91LA0KQ2xhdWRp
dQ0KDQo+IA0KPiBmY29yZXBsbGFjayAtLS0tLT4gSFcgRGl2ID0gMiAtKy0tPiBmcGxsYWNrDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8DQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICArLS0+IEhXIERpdiA9IDIgLS0tPiBmcGxsYWRpdjJjaw0KPiANCj4gU2lnbmVk
LW9mZi1ieTogVmFyc2hpbmkgUmFqZW5kcmFuIDx2YXJzaGluaS5yYWplbmRyYW5AbWljcm9jaGlw
LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2Nsay9hdDkxL2Nsay1zYW05eDYwLXBsbC5jIHwgMzgg
KysrKysrKysrKysrKysrKysrKysrKysrKystLS0tDQo+ICBkcml2ZXJzL2Nsay9hdDkxL3BtYy5o
ICAgICAgICAgICAgIHwgIDEgKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAzNCBpbnNlcnRpb25zKCsp
LCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL2F0OTEvY2xr
LXNhbTl4NjAtcGxsLmMgYi9kcml2ZXJzL2Nsay9hdDkxL2Nsay1zYW05eDYwLXBsbC5jDQo+IGlu
ZGV4IGIzMDEyNjQxMjE0Yy4uNzYyNzNlYTc0ZjhiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2Ns
ay9hdDkxL2Nsay1zYW05eDYwLXBsbC5jDQo+ICsrKyBiL2RyaXZlcnMvY2xrL2F0OTEvY2xrLXNh
bTl4NjAtcGxsLmMNCj4gQEAgLTczLDkgKzczLDE1IEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nIHNh
bTl4NjBfZnJhY19wbGxfcmVjYWxjX3JhdGUoc3RydWN0IGNsa19odyAqaHcsDQo+ICB7DQo+ICAg
ICAgICAgc3RydWN0IHNhbTl4NjBfcGxsX2NvcmUgKmNvcmUgPSB0b19zYW05eDYwX3BsbF9jb3Jl
KGh3KTsNCj4gICAgICAgICBzdHJ1Y3Qgc2FtOXg2MF9mcmFjICpmcmFjID0gdG9fc2FtOXg2MF9m
cmFjKGNvcmUpOw0KPiArICAgICAgIHVuc2lnbmVkIGxvbmcgZnJlcTsNCj4gDQo+IC0gICAgICAg
cmV0dXJuIHBhcmVudF9yYXRlICogKGZyYWMtPm11bCArIDEpICsNCj4gKyAgICAgICBmcmVxID0g
cGFyZW50X3JhdGUgKiAoZnJhYy0+bXVsICsgMSkgKw0KPiAgICAgICAgICAgICAgICAgRElWX1JP
VU5EX0NMT1NFU1RfVUxMKCh1NjQpcGFyZW50X3JhdGUgKiBmcmFjLT5mcmFjLCAoMSA8PCAyMikp
Ow0KPiArDQo+ICsgICAgICAgaWYgKGNvcmUtPmxheW91dC0+ZGl2MikNCj4gKyAgICAgICAgICAg
ICAgIGZyZXEgPj49IDE7DQo+ICsNCj4gKyAgICAgICByZXR1cm4gZnJlcTsNCj4gIH0NCj4gDQo+
ICBzdGF0aWMgaW50IHNhbTl4NjBfZnJhY19wbGxfc2V0KHN0cnVjdCBzYW05eDYwX3BsbF9jb3Jl
ICpjb3JlKQ0KPiBAQCAtNDMyLDYgKzQzOCwxMiBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBzYW05
eDYwX2Rpdl9wbGxfcmVjYWxjX3JhdGUoc3RydWN0IGNsa19odyAqaHcsDQo+ICAgICAgICAgcmV0
dXJuIERJVl9ST1VORF9DTE9TRVNUX1VMTChwYXJlbnRfcmF0ZSwgKGRpdi0+ZGl2ICsgMSkpOw0K
PiAgfQ0KPiANCj4gK3N0YXRpYyB1bnNpZ25lZCBsb25nIHNhbTl4NjBfZml4ZWRfZGl2X3BsbF9y
ZWNhbGNfcmF0ZShzdHJ1Y3QgY2xrX2h3ICpodywNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgcGFyZW50X3JhdGUp
DQo+ICt7DQo+ICsgICAgICAgcmV0dXJuIHBhcmVudF9yYXRlID4+IDE7DQo+ICt9DQo+ICsNCj4g
IHN0YXRpYyBsb25nIHNhbTl4NjBfZGl2X3BsbF9jb21wdXRlX2RpdihzdHJ1Y3Qgc2FtOXg2MF9w
bGxfY29yZSAqY29yZSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHVuc2lnbmVkIGxvbmcgKnBhcmVudF9yYXRlLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyByYXRlKQ0KPiBAQCAtNjA2LDYgKzYxOCwxNiBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IGNsa19vcHMgc2FtOXg2MF9kaXZfcGxsX29wc19jaGcgPSB7
DQo+ICAgICAgICAgLnJlc3RvcmVfY29udGV4dCA9IHNhbTl4NjBfZGl2X3BsbF9yZXN0b3JlX2Nv
bnRleHQsDQo+ICB9Ow0KPiANCj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgY2xrX29wcyBzYW05eDYw
X2ZpeGVkX2Rpdl9wbGxfb3BzID0gew0KPiArICAgICAgIC5wcmVwYXJlID0gc2FtOXg2MF9kaXZf
cGxsX3ByZXBhcmUsDQo+ICsgICAgICAgLnVucHJlcGFyZSA9IHNhbTl4NjBfZGl2X3BsbF91bnBy
ZXBhcmUsDQo+ICsgICAgICAgLmlzX3ByZXBhcmVkID0gc2FtOXg2MF9kaXZfcGxsX2lzX3ByZXBh
cmVkLA0KPiArICAgICAgIC5yZWNhbGNfcmF0ZSA9IHNhbTl4NjBfZml4ZWRfZGl2X3BsbF9yZWNh
bGNfcmF0ZSwNCj4gKyAgICAgICAucm91bmRfcmF0ZSA9IHNhbTl4NjBfZGl2X3BsbF9yb3VuZF9y
YXRlLA0KPiArICAgICAgIC5zYXZlX2NvbnRleHQgPSBzYW05eDYwX2Rpdl9wbGxfc2F2ZV9jb250
ZXh0LA0KPiArICAgICAgIC5yZXN0b3JlX2NvbnRleHQgPSBzYW05eDYwX2Rpdl9wbGxfcmVzdG9y
ZV9jb250ZXh0LA0KPiArfTsNCj4gKw0KPiAgc3RydWN0IGNsa19odyAqIF9faW5pdA0KPiAgc2Ft
OXg2MF9jbGtfcmVnaXN0ZXJfZnJhY19wbGwoc3RydWN0IHJlZ21hcCAqcmVnbWFwLCBzcGlubG9j
a190ICpsb2NrLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICpu
YW1lLCBjb25zdCBjaGFyICpwYXJlbnRfbmFtZSwNCj4gQEAgLTcxOCwxMCArNzQwLDE2IEBAIHNh
bTl4NjBfY2xrX3JlZ2lzdGVyX2Rpdl9wbGwoc3RydWN0IHJlZ21hcCAqcmVnbWFwLCBzcGlubG9j
a190ICpsb2NrLA0KPiAgICAgICAgIGluaXQubmFtZSA9IG5hbWU7DQo+ICAgICAgICAgaW5pdC5w
YXJlbnRfbmFtZXMgPSAmcGFyZW50X25hbWU7DQo+ICAgICAgICAgaW5pdC5udW1fcGFyZW50cyA9
IDE7DQo+IC0gICAgICAgaWYgKGZsYWdzICYgQ0xLX1NFVF9SQVRFX0dBVEUpDQo+IC0gICAgICAg
ICAgICAgICBpbml0Lm9wcyA9ICZzYW05eDYwX2Rpdl9wbGxfb3BzOw0KPiAtICAgICAgIGVsc2UN
Cj4gLSAgICAgICAgICAgICAgIGluaXQub3BzID0gJnNhbTl4NjBfZGl2X3BsbF9vcHNfY2hnOw0K
PiArDQo+ICsgICAgICAgaWYgKGxheW91dC0+ZGl2Mikgew0KPiArICAgICAgICAgICAgICAgaW5p
dC5vcHMgPSAmc2FtOXg2MF9maXhlZF9kaXZfcGxsX29wczsNCj4gKyAgICAgICB9IGVsc2Ugew0K
PiArICAgICAgICAgICAgICAgaWYgKGZsYWdzICYgQ0xLX1NFVF9SQVRFX0dBVEUpDQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgIGluaXQub3BzID0gJnNhbTl4NjBfZGl2X3BsbF9vcHM7DQo+ICsg
ICAgICAgICAgICAgICBlbHNlDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGluaXQub3BzID0g
JnNhbTl4NjBfZGl2X3BsbF9vcHNfY2hnOw0KPiArICAgICAgIH0NCj4gKw0KPiAgICAgICAgIGlu
aXQuZmxhZ3MgPSBmbGFnczsNCj4gDQo+ICAgICAgICAgZGl2LT5jb3JlLmlkID0gaWQ7DQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL2Nsay9hdDkxL3BtYy5oIGIvZHJpdmVycy9jbGsvYXQ5MS9wbWMu
aA0KPiBpbmRleCAzZTM2ZGNjNDY0YzEuLjFkZDAxZjMwYmRlZSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9jbGsvYXQ5MS9wbWMuaA0KPiArKysgYi9kcml2ZXJzL2Nsay9hdDkxL3BtYy5oDQo+IEBA
IC02NCw2ICs2NCw3IEBAIHN0cnVjdCBjbGtfcGxsX2xheW91dCB7DQo+ICAgICAgICAgdTggZnJh
Y19zaGlmdDsNCj4gICAgICAgICB1OCBkaXZfc2hpZnQ7DQo+ICAgICAgICAgdTggZW5kaXZfc2hp
ZnQ7DQo+ICsgICAgICAgdTggZGl2MjsNCj4gIH07DQo+IA0KPiAgZXh0ZXJuIGNvbnN0IHN0cnVj
dCBjbGtfcGxsX2xheW91dCBhdDkxcm05MjAwX3BsbF9sYXlvdXQ7DQo+IC0tDQo+IDIuMjUuMQ0K
PiANCj4gDQo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
DQo+IGxpbnV4LWFybS1rZXJuZWwgbWFpbGluZyBsaXN0DQo+IGxpbnV4LWFybS1rZXJuZWxAbGlz
dHMuaW5mcmFkZWFkLm9yZw0KPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2xpbnV4LWFybS1rZXJuZWwNCg0K

