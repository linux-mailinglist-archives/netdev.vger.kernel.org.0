Return-Path: <netdev+bounces-11007-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6802F731124
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C0A228158A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E54220E3;
	Thu, 15 Jun 2023 07:46:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680801C29
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:46:30 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A07C5;
	Thu, 15 Jun 2023 00:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686815188; x=1718351188;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7rVOK6tKvS1b/1PwqPkygBZvrS9SmYs7vaed/VtdqM8=;
  b=l5XMYt/gvhXa94Y8qU2olGn2i5BPQudJG7TrNlN8WUqwZfd1r3fhAHy8
   3+z2N3DAIjefOKEF3dVzpTCMPemeOl+Y1LtAkPIsA9qw6yts9NEPm8NNZ
   Vcw2gZ3PutQweERmWJ9O9nEFhzSIDjK909iQRlVzXPTE/Ieg51O1w8FT8
   U+A3IKS/4g0piIENbtuQE0v30CxPGk5Cansm4mwT3IgDVcfUP+QdISbGn
   5LsITfWEcHzb38ZDVE8VftxH1Jga9XAxaslMyFgeivknKUx7kSBgt7q6E
   sv13daG2rks1clxhzlftwGurdzJBjk0ctOz5tHXOKJvtYtzDiHqvydJJR
   A==;
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="217974321"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2023 00:46:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 15 Jun 2023 00:46:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 15 Jun 2023 00:46:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRmiDBIs/y39rFbnwKrt0nFu+hc6b9a8v4aSfhNQcLs4X3lz1I3r+tYCgnz7vVjSltuDOBfvk/Hpx95FwJzrZIjc7Cn5WJWUJn8C5OhCAh8dCPhzGNpeagBsBxfaXqpBDRmvlSZ9xvxmCEkotDBZjfJF1Y4oVUZSI8ODXd0evgkwlwBUwnB14NEn5sqWF/NUnCJaEkaW/vqvWprEyhxBSC0aNJ7EH7VxMi1kqEzabRYMe+9qD+SyzfUwrcFkFGip3+VbpeLCrlNXVlaTbQlqKrShrt8QxtQ+ynuXbuOe8xS3qKnMdoilTdN+GN2Um/ljuFWNG8EG8Nmlf1wgP9JjMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rVOK6tKvS1b/1PwqPkygBZvrS9SmYs7vaed/VtdqM8=;
 b=EMWe2HjJxCPTOsDBqXHGS4BSn1lT+Z97flLJsEGqtnZFu6gXfOhmsDBPLVp0EbY22GCb+yWJPbxj8N+JHZAY3C+AoIbqsqGfQF7abujfkoKyI5/zISMCAYgNj5fKOL/QdDX3J/N1PCQ2D2aoa9n2viJ6wEnsg1Snc18G0OEJTdZ3dOTpY6o+Mh7OJRNTT7ZLGj5pZbJDnjAuvWLh0Urd4hSm+zxDyCNcvYug8+TlwgTQwGh0IQFGTVYpbYQVVuE8XyjZ3Lj63r5bIDZHUo/+NBKdz1lKEpquwYxQWPELKciICr+NwHrWKtthTThB6grWhufyuMzsNZs6nBZBCYv66w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rVOK6tKvS1b/1PwqPkygBZvrS9SmYs7vaed/VtdqM8=;
 b=EuofBU3//6BifKqWALoCMjlF7VA50GGrqO+ds6r/PswHLp8rmB382CvBT6aZ3nxtgA/ZeDni+pbfu7mpjw4E0m3AWJHuAgmhj8zzMUvRvblkMUdHF+9LX1hPTukN00azOPcmXp565NWx+cafGTGZW1j4LY34uVAjc0I0Jih+hbo=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by MN0PR11MB6256.namprd11.prod.outlook.com (2603:10b6:208:3c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 07:46:18 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6433.024; Thu, 15 Jun 2023
 07:46:18 +0000
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
Subject: Re: [PATCH 10/21] ARM: at91: Kconfig: add config flag for SAM9X7 SoC
Thread-Topic: [PATCH 10/21] ARM: at91: Kconfig: add config flag for SAM9X7 SoC
Thread-Index: AQHZn114YArU28ur0kGhbYn4M6iklg==
Date: Thu, 15 Jun 2023 07:46:17 +0000
Message-ID: <fed4244c-445e-b05a-fbe4-4a70d236f9e0@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-11-varshini.rajendran@microchip.com>
In-Reply-To: <20230603200243.243878-11-varshini.rajendran@microchip.com>
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
x-ms-office365-filtering-correlation-id: 63fd6135-9b0b-4732-ab06-08db6d749a97
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qP//6yk4JWj6elafbPrHqBIktkR1bTXZzb1x6jf0uCJzDH0J6oeFuffxKV9ngGRSb7wsgUx1sfkjpC1zneQYwKYsrmtYLebGgEm7EaY9xFQJfMurNif9bmaWhEFsUpvbzTTfuAPguG47t56L7V8moTtLDhSqatPiqzuHD43y3pRlSchw2Xxvcr9I0w45NqU5psrA7mUHwLGJXOQAWKxffs2ieOa3dak3jygpnVKCGiKtUyaLJ708WtI5amKvI6tuuFj4dYxelHwvktMsyNpIhIUVA5mjDdFFZoVIYzdXuu3r8lHjFhon2y5ghU/ySb7Fo7ifAS1/jbSjDGUQBntNAMsAB5TJq8uyKaoolpnEJqEd809pTD2axnV6lVdzcnKpdB5n/2sLI63udc+A4Pg1sR9epEq9BWnIyLhHoVPESiDRbJesxkjbnLGydulMAm6hW5efiHYUODhKYlDIgZk+TQNxWWJc3T9zgw6utcTCHLkHIVgKFeREBy+nD3G2QF8/OtK63EInRVHuXo2NgF4TAPnn4ucmLPuWgKqktgkDim9VttJvs+92kRTplDdO9BzRDn+Tzj0F6FAvQ7uvxpintzS4lbHoQ//XX8J2feYUEkOHngWdN/Iv/uJBKqaNgsji1pH8YndOqZUI+QRxyhs61D4a1PH5/TYhHx+yUs67DZ36paURKyAGGAZvJzC50AXeI01zviSUfBgT8QevGcdM8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199021)(921005)(122000001)(38100700002)(38070700005)(71200400001)(478600001)(54906003)(110136005)(6486002)(7416002)(316002)(41300700001)(5660300002)(8936002)(8676002)(64756008)(66476007)(66446008)(76116006)(91956017)(66946007)(2906002)(66556008)(4326008)(83380400001)(6512007)(26005)(186003)(107886003)(53546011)(6506007)(2616005)(31696002)(36756003)(86362001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3VjbTVLbmIrRW12dUZ5SzlLWVRTdGk0aGR5dTBQS2QxTEVYK3BtK1RCNjZk?=
 =?utf-8?B?ejlCSGozMDFpWm9zeFh2OFZ6anFBTEI4VFB4dTFhRXlFZjZ0RkhFc2FKWElL?=
 =?utf-8?B?S2NZVlJlUmtLVS9DdGsxbHdQMlZrcFVTRnJTck1od2Z5dWJYOTk2ajNway9S?=
 =?utf-8?B?M2RtbXYzTmpxWExDbDRmbUhzekpCaytYbTdTRU1YWmYzNzN6WnRVUUhPYmk3?=
 =?utf-8?B?UVJ0dTUvMVhPVnFFUmxRcWg2NnpFY3BTUXh1UkF4ZzJ3STFNbDZVd1RYSDhx?=
 =?utf-8?B?TmErSXU5bEd5dUs5L2VranljNGhGZmp4anpqY2ozMzB5c2xrQ1d3dHpPNGR6?=
 =?utf-8?B?TlZFSy9XeDA4algvcllqLzdEUVlML29TblowTTlidUFqU0xxbjl0NjNUb2Vy?=
 =?utf-8?B?bGVkVG0wSG5FVmd1QkowOU92Q2QyZXNPaFZ3VjlKejU4N2lHdFU0Uk02bnEy?=
 =?utf-8?B?NXZjdExaV2IzQVNzWWdjTVFzc3UyMmNsRHNzcFpwdFhESk8vSjlVbFJrZDB0?=
 =?utf-8?B?S0xvWC9sSlk0YllxaEhlVE1zeG15K3dBUTE3NW9JajFJbmxWSlpUdEhZeVE0?=
 =?utf-8?B?aG9xRWw2MW9CZ29IVzRtbVNjODRuWDdZMk1IY0F6MVlsV0Q5UDhFT1pMNjlm?=
 =?utf-8?B?M3VoTFFEUUNCRjdSSjE1VDhURTB2RnFyWWFmZFQ4VmYxc2trVmJ0RTNiWTZp?=
 =?utf-8?B?NllaVkZJeHpDRTh3Q0JUcnJNYnl6NGZjQXdHZ29yQjN6MUt6dXFtVVo1cm8w?=
 =?utf-8?B?MzVic2NzcFhuUVRrbXpTZDZ4YXJjU1pFMlRabjJxNksrMEtCTGMvSmUzYjg5?=
 =?utf-8?B?cDduZVpGbXlKQ0ZZblRzTDdCS255ZHZncDRyTGpJMTYyZVdiOUVqcWxJYWFE?=
 =?utf-8?B?L1VWYitFSVJlZDBVSWVuMWxydWpoQndvQ0JjeDlzdW9lVTd6NmRkOUFQWnBV?=
 =?utf-8?B?UGZ4bHZBNWR0U05zNk1FajNDUEt4MllNcS9ac1kwK0huTlZ1R0FsdWkxTW1q?=
 =?utf-8?B?NGUwSTNEMk5DSHlLQ3BJMVF2amgwN2lpWWRtMEd1UVFuenFUMm5Zd3VENzM0?=
 =?utf-8?B?VUgxcm1Za25uR3poc0NJNXFtN1NiUytYYlBJbnRKa2l3azRRVytjZVZFSS9X?=
 =?utf-8?B?ckI1KzZreHJIbUFRYllIM1JJaklNQ2tmb1FxQzhLdVRyTTRPMGt5Y29Wek40?=
 =?utf-8?B?RXFrWURXNlJMSVFRd1pweDdleG5scFhOMnVWQmpHa2tpYnluRzdsTW11ZDJx?=
 =?utf-8?B?NzIxS1RFazBJdzFUZ2pYR3BBZklWZ3hEMURwRVV6WVIwaDcvVzBueEMzbmZo?=
 =?utf-8?B?V3ByV2tuVS8vRVNOKzYxVzJhbGlTeC9CS3dKREphZitkNzhJV2Vma3pWeTkv?=
 =?utf-8?B?clJ5Q3NlbXVDOW82UEQzM3lQdHpzbEUxMUt6elBsSnVEOGpBVklqeTRIS0xx?=
 =?utf-8?B?S1g3dTNFcnZTTDJ6d3VrREJUZHpaRlB1Y0tVL0FDM2hCN2JSdEVTQ2h4Y3dT?=
 =?utf-8?B?WVF6QUQ5dzIyd29CRTdSUFA3dndGd1FBWVVzaVI2S0I1SERnU1BtR1Z6MXNK?=
 =?utf-8?B?djhuR3BrOU5QQkljZ201dkN2NlRvdm9nTG52d2dMUGVwaCtTblVLcXJnL29G?=
 =?utf-8?B?L2UvU3dYSTY5amhEWHJtWi9QeGxCaFp0RWd4UjkyTGg4Rmk3NjhVcUxGTWxm?=
 =?utf-8?B?VktjQ2RkNEFqZ2R2dzB4YUtqcjZWUCtWc1hDM0ZXbWg3UFdLV3YwamRNS3lq?=
 =?utf-8?B?V3lkbVFNWnYvQUdzQ0JrOUVUME9sYWFlUmlHR0ZqOGtoSjBmYzJoRmVHL080?=
 =?utf-8?B?WWo4aDRiMlJ1eWUyQk1kY0xwM3M3MHVoTkZSVU0xTnNKWWtlTkhNT1NmQUNh?=
 =?utf-8?B?bnRHdi9oZDNMRlpXQjkvWjVpWjJaL3lKajVTMHJpRmh4M000MW5ackpGVFRF?=
 =?utf-8?B?aCttU3E5d1V4ejFCRXJBL3c1bkc3NCt3SjF2Z0JmYUlBN2lIR1lVRTc2UTJs?=
 =?utf-8?B?dEQ2cEdvaHpQNmIrREtqdy9tMTd6M3RGWGw1VlR2Tzg5RU10UjBkWWczU0Uv?=
 =?utf-8?B?SzhwWVpITzNMQmhVa2xmKys5SVpvSWY3ZjlSN1V4UG9YU1JuVG0xS0gyZlhl?=
 =?utf-8?Q?lij0zDotbqjGumBkGR1GmvJfv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD9F4400C0741F4CBFB25B86F9125334@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63fd6135-9b0b-4732-ab06-08db6d749a97
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 07:46:17.9739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U7b9N8MIK5sfqcFGiKxjhkj54teNVHx1w0zHalntCbrSZkistueM3wpOy0Twfnn9GZRc5Innb8rdDsqHaZFor5Eg5Rl1/j6EWhueoxGpSnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6256
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMDMuMDYuMjAyMyAyMzowMiwgVmFyc2hpbmkgUmFqZW5kcmFuIHdyb3RlOg0KPiBBZGQgY29u
ZmlnIGZsYWcgZm9yIHNhbTl4NyBTb0MNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFZhcnNoaW5pIFJh
amVuZHJhbiA8dmFyc2hpbmkucmFqZW5kcmFuQG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgYXJj
aC9hcm0vbWFjaC1hdDkxL0tjb25maWcgfCAyMSArKysrKysrKysrKysrKysrKysrLS0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtYXQ5MS9LY29uZmlnIGIvYXJjaC9hcm0vbWFjaC1hdDkx
L0tjb25maWcNCj4gaW5kZXggM2RkOWU3MTg2NjFiLi40NDYzYWZkNzI5OGEgMTAwNjQ0DQo+IC0t
LSBhL2FyY2gvYXJtL21hY2gtYXQ5MS9LY29uZmlnDQo+ICsrKyBiL2FyY2gvYXJtL21hY2gtYXQ5
MS9LY29uZmlnDQo+IEBAIC0xNDMsMTEgKzE0MywyOCBAQCBjb25maWcgU09DX1NBTTlYNjANCj4g
IAloZWxwDQo+ICAJICBTZWxlY3QgdGhpcyBpZiB5b3UgYXJlIHVzaW5nIE1pY3JvY2hpcCdzIFNB
TTlYNjAgU29DDQo+ICANCj4gK2NvbmZpZyBTT0NfU0FNOVg3DQo+ICsJYm9vbCAiU0FNOVg3Ig0K
PiArCWRlcGVuZHMgb24gQVJDSF9NVUxUSV9WNQ0KPiArCXNlbGVjdCBBVE1FTF9BSUM1X0lSUQ0K
PiArCXNlbGVjdCBBVE1FTF9QTSBpZiBQTQ0KPiArCXNlbGVjdCBBVE1FTF9TRFJBTUMNCj4gKwlz
ZWxlY3QgQ1BVX0FSTTkyNlQNCj4gKwlzZWxlY3QgSEFWRV9BVDkxX1VTQl9DTEsNCj4gKwlzZWxl
Y3QgSEFWRV9BVDkxX0dFTkVSQVRFRF9DTEsNCj4gKwlzZWxlY3QgSEFWRV9BVDkxX1NBTTlYNjBf
UExMDQo+ICsJc2VsZWN0IE1FTU9SWQ0KPiArCXNlbGVjdCBQSU5DVFJMX0FUOTENCj4gKwlzZWxl
Y3QgU09DX1NBTV9WNF9WNQ0KPiArCXNlbGVjdCBTUkFNIGlmIFBNDQo+ICsJaGVscA0KPiArCSAg
U2VsZWN0IHRoaXMgaWYgeW91IGFyZSB1c2luZyBNaWNyb2NoaXAncyBTQU05WDcgU29DDQo+ICsN
Cj4gIGNvbW1lbnQgIkNsb2Nrc291cmNlIGRyaXZlciBzZWxlY3Rpb24iDQo+ICANCj4gIGNvbmZp
ZyBBVE1FTF9DTE9DS1NPVVJDRV9QSVQNCj4gIAlib29sICJQZXJpb2RpYyBJbnRlcnZhbCBUaW1l
ciAoUElUKSBzdXBwb3J0Ig0KPiAtCWRlcGVuZHMgb24gU09DX0FUOTFTQU05IHx8IFNPQ19TQU05
WDYwIHx8IFNPQ19TQU1BNQ0KPiArCWRlcGVuZHMgb24gU09DX0FUOTFTQU05IHx8IFNPQ19TQU05
WDYwIHx8IFNPQ19TQU05WDcgfHwgU09DX1NBTUE1DQo+ICAJZGVmYXVsdCBTT0NfQVQ5MVNBTTkg
fHwgU09DX1NBTUE1DQo+ICAJc2VsZWN0IEFUTUVMX1BJVA0KPiAgCWhlbHANCj4gQEAgLTE1Nyw3
ICsxNzQsNyBAQCBjb25maWcgQVRNRUxfQ0xPQ0tTT1VSQ0VfUElUDQo+ICANCj4gIGNvbmZpZyBB
VE1FTF9DTE9DS1NPVVJDRV9UQ0INCj4gIAlib29sICJUaW1lciBDb3VudGVyIEJsb2NrcyAoVENC
KSBzdXBwb3J0Ig0KPiAtCWRlZmF1bHQgU09DX0FUOTFSTTkyMDAgfHwgU09DX0FUOTFTQU05IHx8
IFNPQ19TQU05WDYwIHx8IFNPQ19TQU1BNQ0KPiArCWRlZmF1bHQgU09DX0FUOTFSTTkyMDAgfHwg
U09DX0FUOTFTQU05IHx8IFNPQ19TQU05WDYwIHx8IFNPQ19TQU05WDcgfHwgU09DX1NBTUE1DQoN
CllvdSBzaG91bGQgYWxzbyB0YWtlIGludG8gYWNjb3VudCBQSVQ2NEIgYXZhaWxhYmxlIGluIHRo
aXMgZmlsZSBhZnRlciBUQ0IuDQoNCj4gIAlzZWxlY3QgQVRNRUxfVENCX0NMS1NSQw0KPiAgCWhl
bHANCj4gIAkgIFNlbGVjdCB0aGlzIHRvIGdldCBhIGhpZ2ggcHJlY2lzaW9uIGNsb2Nrc291cmNl
IGJhc2VkIG9uIGENCg0K

