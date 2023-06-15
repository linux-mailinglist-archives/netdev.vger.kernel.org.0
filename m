Return-Path: <netdev+bounces-11005-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2249B73110E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAEF51C20E46
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDE41FD2;
	Thu, 15 Jun 2023 07:42:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DDD375
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:42:45 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7C4E69;
	Thu, 15 Jun 2023 00:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686814962; x=1718350962;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=S3/2LE9/5M97nhVWXmIfbJcmsCqTenQiT0Whwkoc5Dc=;
  b=JqqG7ggXHRIrbJ+gYqo1gPgR77/dWeT/T+0M2hkAIVfhQCXGi4gLLwzY
   xLf9x0noKrgbiRP5BcuBJhf1Udcb3emSgY+9oVTbsaKhd0cAk6iOsHErL
   YiB4bKZFBjbV4AK9WMd+jROp9nhh3+AUarV5ANx1/taiNFmZlX8Pi8Ykl
   BghT4J/l13VfiM/qhZdErDz3D+IXQmhFMQp8bsX5WuD0e74KpghrDYlEe
   Jq0do3+5Sd//WPwrcNYtWVb31Xlrpm4ilEO1uu0vg5Hf4pqH6Pn6bTkwH
   4arZQYFetzbf4bwbAhKNRuRG+myymsmh7K2Q45ZWa5oog/vu/SsFEQW5e
   g==;
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="218607971"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2023 00:42:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 15 Jun 2023 00:42:33 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 15 Jun 2023 00:42:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XES7xnssY1uH9UI2jSe6ZtGJ3SqFyDtQ4OiRWzsrFDy26CgNnipD962c3yq5QCuhSQb3c8nMfLsBOsmj7VCAGRLyDShv38YGDEJAAPH9SIyK/ReVEazSCtVJb5E+2ArK48XTqRTqJayT98wrQOsW06PwbBgfcb8juo4PbZn6TwMT5iuRkvXsQAUx2JkNvcCq5EyKdD5ZMKvM4EJnSDDqCVpFPm+irDlJvS4IRYmGiZCoylKMXl89X6jZ2RNwUzcxN7TuAVgu6Ag3gw1fh7lfvo7R4IwJj19V6xA1bbwDgvIZA1+GEuwo4keegqAHVoywDzsDDKNvbygaybdqI4SbTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3/2LE9/5M97nhVWXmIfbJcmsCqTenQiT0Whwkoc5Dc=;
 b=Htzqg/eNFE86Z9JPQwNlUAx7rDr4ijZm37ioSbDhSHRm3jAsw5a8OO8JbgTYfGa8kEBa6H/rQkN1udfwV9oRJewfIADakOzDoxNeGCid4mP/nZkoET0ojdvpCgKwZjgW/2uC/mGK6a0fFPZpZ6fuDz3d7gjK+JKn6KMN01YdULq6VaQRJm4K0aB1Rn9WSL512vR81cRniQgkNIL7/Yx/c5AIQvJ9RV36+82pYjlaG5F9FivDCiYrO3VmEHS9k95ua70JKyJQ9gfq1Lsd3yo2nmuDkO/gr9l8hafzTYhuMohq0SIju6BrPtjerQGZ93+tGyTCqfkKE5n8Aqp/uHFF0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3/2LE9/5M97nhVWXmIfbJcmsCqTenQiT0Whwkoc5Dc=;
 b=dhpiWAte1Eb/qQxsA4Cs1eoe9y4GCE1f3asVIaY4GtMtHxs4lF0TnvAcJVRBfgoOLzP9EcnTRXgxBTDjnSbRs0mFv5k4Xp7u30O34WTpPIy53YK37NFfKH2NIeWI36pEFRz+XQWEz69NKUxVxy3GWuexxv4H3rTMaVRJERf3qvM=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by BN9PR11MB5243.namprd11.prod.outlook.com (2603:10b6:408:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.38; Thu, 15 Jun
 2023 07:42:31 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6433.024; Thu, 15 Jun 2023
 07:42:31 +0000
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
Subject: Re: [PATCH 08/21] ARM: at91: pm: add support for sam9x7 soc family
Thread-Topic: [PATCH 08/21] ARM: at91: pm: add support for sam9x7 soc family
Thread-Index: AQHZn1zwZf3YQoLLEECJsidQeGyD8w==
Date: Thu, 15 Jun 2023 07:42:31 +0000
Message-ID: <76b3a9b1-b410-d861-1824-f644a3fce7de@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-9-varshini.rajendran@microchip.com>
In-Reply-To: <20230603200243.243878-9-varshini.rajendran@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|BN9PR11MB5243:EE_
x-ms-office365-filtering-correlation-id: 45914fb2-8d0f-492e-cbb8-08db6d741376
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Vbx1uirK7wALlj08k0npDeObZIl1Xj+SCm3idf2mxlh+E4aJYKrOxyqmmdYtuRDiVEQ0GL/M30wu/u5LMHVw9k15RuiAdbwWplotihStSbpNEIa8AJFpsk1PGYheLCYIgOWPrcexBTqVkWgqMpCNE6tX9sSIthoqN+7DCED0Q7Mu/To8cV1FSAovcs/2kvKikBP0OkD3EhhNtXHcbAsq0HoJzepLQXO3UbeE7bK3/S2F5hDGim1Cf0MkSzwxIpIA+l0fVqbWIDqFq8H/3EaPh5Np+kmVTd2i6GUOZc5Idd82yklWOlUGVMpNOWeSeb7C1sTmxuuN10Sq3lE0T7yZLPzcec1Rk/uEteqILkU8xz565I1Y0mfwsvYIHtfNe0Kq3SvfGKXG/A6+H1kM4m8kmSWP6H5geTdevZ3JZYa8gM+2B4iheOTYTsbx+gghDZcN8kSYEQV1AbZG582YyusJ1BkWwJoYYyJUasHZlki57LYdYAAfDmQKiTCcWFM71iWOXB5ncedOufq3D7csCmleZg20oreS0SC2EYOM/TiLhCqHMWXjtY8xcjcvIjsPxdCXN3SlBrYvU0dIrz8TR/CP3hm1EFYzgzgxA7eZ/7D6HrdLGOEIRyPJ3efXjV5UG/jHtsERd0ogF4YlhBC2JyItdiBMwGXCYeMvi9IVQYBBqmN0IXSGf7c0azRUguW7KSWppjyO3AGB/SBdoNOQ6wJpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199021)(4326008)(66556008)(91956017)(66946007)(316002)(66476007)(66446008)(64756008)(76116006)(6486002)(71200400001)(36756003)(110136005)(107886003)(8676002)(5660300002)(31686004)(8936002)(41300700001)(478600001)(54906003)(31696002)(53546011)(86362001)(7416002)(38070700005)(186003)(2906002)(38100700002)(122000001)(921005)(83380400001)(6512007)(26005)(6506007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N013SHY5RGpHVHdORzdUY3ROdVN0SDFGbUJUS2RnMnRMSm5EVEhjZGhuNjhE?=
 =?utf-8?B?SHVwK3Q3cWlFcjBIUHFOcEwwYi9mcm56MWNZZndjekNFSC9uenNTSWNQWXBy?=
 =?utf-8?B?V3JabCtKWjlzTVBFRzM3N1RqTTdiUXZBc3JtVFV0QmszNTZJUk14d01KdU1R?=
 =?utf-8?B?TnVhWVVnQU03ZS8weU14TW5KYk9udXowdkkybGNXekhnc2p2Y2VpWjN5UHF4?=
 =?utf-8?B?V3BIc3V6bEJlUjVOVlFmMlJ6ckJVVkowSUl2a0ZUNEdaNUViWGVyWlByTEVl?=
 =?utf-8?B?cGx4YU5VQ2FWdjNVUFNNQ1hUSnV3MDNHamcydHAwS01mbERIQXVIeVNaVHk0?=
 =?utf-8?B?SVFDVmExMWFDY0NHd0lhUzFUclZaeTV1TGw2MUxZOUNTUi8wcWYzcVJ2R0tJ?=
 =?utf-8?B?alkwcjdlZWpzM0RsTWtXR1NjTFJ6eEo3Z29Demo0N21RcjE2WUxOWEM5L21G?=
 =?utf-8?B?NmFGcWYxV2lkdUYwQVBnV1ZqR3dNcXFjcnZUSU1WMVNydTExc2ZseHE4VDNk?=
 =?utf-8?B?a1FEcjNRSlJHVmtBcHZCTm14UDVGZkpDMUthRDlMc1FiUmNIZFI0SnlyODBR?=
 =?utf-8?B?NkprT0w2SDNqc1JJMkpDeDVjclQ2OXhvMXNDNmpITmkwVGtVT1Q3MTJ4eEdy?=
 =?utf-8?B?cmdIbG5MOTlxMThiT2xCWUdKcDJsbEZ5cC9STWU0REYwZ1VPNXAwQk9BQ1c0?=
 =?utf-8?B?YWtHcFVub2dVSXB0SjZCWFZDeUd5VW1vRENlVlVHKzVDaUQrSmJmSkxoSWY0?=
 =?utf-8?B?dUh3UCtMSndOQk5CaTZBWDdjZGdqaFJGVmRQTXJhVnA4SGlwZitEa2piaUEy?=
 =?utf-8?B?K00vNHM3bHZiUFc5aEY5OU43OGlGdFFjMUltNnZkMnlKcDd5Y0hqck1waHkr?=
 =?utf-8?B?d1c1NW5pdm1OY0xKajBza1lCN3ZiVXJ4SDNxYWN6YkdFU09mSVQ4MUlIR3ZV?=
 =?utf-8?B?M1FyR3JyWFUxaDk4Yk5NR2M1emxnbVdWdm9Ycldtc0UvTE9qeElQdXhtQmlr?=
 =?utf-8?B?d05pMHR1MmdDd3dDV2w1dHBGejZiTzVYTmN6eWxqdmU0eGIwMFI4Sm9tSTlO?=
 =?utf-8?B?U1R5T1prZnZIY0Y1VjJFU21mVk5VRjJNLzlHUDJDMEFwWGVMQ3F3R0lpeWNi?=
 =?utf-8?B?N1lCcGdGTXd5bkkxTXFsUW5NNytJMWZ0UUN1UDJtWUNWbWtuSkEwV1Z0eUFF?=
 =?utf-8?B?eHpEUkJ6RmYwYzdWV2hSY0tzQzc5SkwrZksvamUvUlBSNXRaNWdZSXBWNWg2?=
 =?utf-8?B?ZVNnVVNjNlVtQTZCN1JidllMd3dRbXMvdnhrbzVUMFBDSmxTS3Y1R2VGOFZz?=
 =?utf-8?B?TXArbDVNR1R2clFNM2dOTlZRWG80Q2pvTzZSQzRxb1JjSEZMVUFzQ1ZKOW5M?=
 =?utf-8?B?cUp0aHB3cTljUjZxQytqYy83eTZObm5sVWE3K0V1QWtQLzFxRkZKNlIxaXBk?=
 =?utf-8?B?bkpGWWE0eFRHd3QwM1h2YWFpQy90Mm9VTDI3ekowbGpIUmZWUEVhUVNHMVJX?=
 =?utf-8?B?ZFpVendGUllLY05udnR3R3hrTGtPbTFpNmI4WWVpY2FwcUJPc3FnRHR0ZkxT?=
 =?utf-8?B?QnZwK242bVVEaUd1OTMrYjlmUXg3bFl3ZWF1bWc1R2RXMHk0Y0lZT0N5ZDRR?=
 =?utf-8?B?OEpoQlVLTDlzcEVLM083cWI0NFcxSU1KK3E2WnhRK05vWkF2OHNMVDZxZDg2?=
 =?utf-8?B?UGtPOUY0TFRKaGlzb2NNYWY0Sk9USDNxQlQxcWpCenNEaDcxRmppdnhpZjJT?=
 =?utf-8?B?SWFqY3NXaVFGdE1YOXJ6eDNwRGM1RXN3Y0dxaXd4c1FKUENBS2kwZjYvTkMr?=
 =?utf-8?B?b2pxUVBZOTNrTjRFWHJQdjJtckFLM3hROCsvcFFVeTVzNytmSERTTWEvUnVi?=
 =?utf-8?B?QmFnMVpHcDJTUkpCUFh4SlBlQ2lkODJ6R0o0SkljZUlNcGl0ZWpoa3JMVkxJ?=
 =?utf-8?B?R09KRnExbGJDSlRCLzEzNHJ3R3B3SEVrd3k1Z3ZDNnZUcU1pWmZuL3dveGNI?=
 =?utf-8?B?aGR6enBwRkJ3NitycFRlQUhNMFVqVEZLUXhhY1lNQ2YzbEdwcjY2Vm5iNEdZ?=
 =?utf-8?B?VW90M1FpWVc0Tmt5SHYzNFVPUk5oTFgrTVdkZFFKMTY1SVBQdFh1RHc5NlFj?=
 =?utf-8?Q?zr6JstiZ9DvN0f98C4MCCxvgq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A42A9EB61821454691C15F6EE7790B15@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45914fb2-8d0f-492e-cbb8-08db6d741376
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 07:42:31.3095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P74mCe0fC1evHdpuNnD1aGTZAv9bP6KxQ2F4vdEtgquY/tpCpbbNo/hwyV0l5IHvfHvXx/SgkiOqlCdBgfKNMNP54iPI34A/w7TFluZZ7jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5243
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMDMuMDYuMjAyMyAyMzowMiwgVmFyc2hpbmkgUmFqZW5kcmFuIHdyb3RlOg0KPiBBZGQgc3Vw
cG9ydCBhbmQgcG0gaW5pdCBjb25maWcgZm9yIHNhbTl4NyBzb2MNCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFZhcnNoaW5pIFJhamVuZHJhbiA8dmFyc2hpbmkucmFqZW5kcmFuQG1pY3JvY2hpcC5jb20+
DQoNClJldmlld2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlw
LmNvbT4NCg0KDQo+IC0tLQ0KPiAgYXJjaC9hcm0vbWFjaC1hdDkxL2dlbmVyaWMuaCB8ICAyICsr
DQo+ICBhcmNoL2FybS9tYWNoLWF0OTEvcG0uYyAgICAgIHwgMzUgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMzcgaW5zZXJ0aW9ucygrKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtYXQ5MS9nZW5lcmljLmggYi9hcmNoL2Fy
bS9tYWNoLWF0OTEvZ2VuZXJpYy5oDQo+IGluZGV4IDBjMzk2MGE4YjNlYi4uYWNmMGIzYzgyYTMw
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybS9tYWNoLWF0OTEvZ2VuZXJpYy5oDQo+ICsrKyBiL2Fy
Y2gvYXJtL21hY2gtYXQ5MS9nZW5lcmljLmgNCj4gQEAgLTEyLDYgKzEyLDcgQEANCj4gIGV4dGVy
biB2b2lkIF9faW5pdCBhdDkxcm05MjAwX3BtX2luaXQodm9pZCk7DQo+ICBleHRlcm4gdm9pZCBf
X2luaXQgYXQ5MXNhbTlfcG1faW5pdCh2b2lkKTsNCj4gIGV4dGVybiB2b2lkIF9faW5pdCBzYW05
eDYwX3BtX2luaXQodm9pZCk7DQo+ICtleHRlcm4gdm9pZCBfX2luaXQgc2FtOXg3X3BtX2luaXQo
dm9pZCk7DQo+ICBleHRlcm4gdm9pZCBfX2luaXQgc2FtYTVfcG1faW5pdCh2b2lkKTsNCj4gIGV4
dGVybiB2b2lkIF9faW5pdCBzYW1hNWQyX3BtX2luaXQodm9pZCk7DQo+ICBleHRlcm4gdm9pZCBf
X2luaXQgc2FtYTdfcG1faW5pdCh2b2lkKTsNCj4gQEAgLTE5LDYgKzIwLDcgQEAgZXh0ZXJuIHZv
aWQgX19pbml0IHNhbWE3X3BtX2luaXQodm9pZCk7DQo+ICBzdGF0aWMgaW5saW5lIHZvaWQgX19p
bml0IGF0OTFybTkyMDBfcG1faW5pdCh2b2lkKSB7IH0NCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCBf
X2luaXQgYXQ5MXNhbTlfcG1faW5pdCh2b2lkKSB7IH0NCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCBf
X2luaXQgc2FtOXg2MF9wbV9pbml0KHZvaWQpIHsgfQ0KPiArc3RhdGljIGlubGluZSB2b2lkIF9f
aW5pdCBzYW05eDdfcG1faW5pdCh2b2lkKSB7IH0NCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCBfX2lu
aXQgc2FtYTVfcG1faW5pdCh2b2lkKSB7IH0NCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCBfX2luaXQg
c2FtYTVkMl9wbV9pbml0KHZvaWQpIHsgfQ0KPiAgc3RhdGljIGlubGluZSB2b2lkIF9faW5pdCBz
YW1hN19wbV9pbml0KHZvaWQpIHsgfQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vbWFjaC1hdDkx
L3BtLmMgYi9hcmNoL2FybS9tYWNoLWF0OTEvcG0uYw0KPiBpbmRleCA2MGRjNTZkOGFjZmIuLjQz
YTc3YWUwYzM4YyAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm0vbWFjaC1hdDkxL3BtLmMNCj4gKysr
IGIvYXJjaC9hcm0vbWFjaC1hdDkxL3BtLmMNCj4gQEAgLTIzMiw2ICsyMzIsMTcgQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQgc2FtYTdnNV93c19pZHNbXSA9IHsNCj4gIAl7IC8q
IHNlbnRpbmVsICovIH0NCj4gIH07DQo+ICANCj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2
aWNlX2lkIHNhbTl4N193c19pZHNbXSA9IHsNCj4gKwl7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hp
cCxzYW05eDYwLXJ0YyIsCS5kYXRhID0gJndzX2luZm9bMV0gfSwNCj4gKwl7IC5jb21wYXRpYmxl
ID0gImF0bWVsLGF0OTFybTkyMDAtb2hjaSIsCS5kYXRhID0gJndzX2luZm9bMl0gfSwNCj4gKwl7
IC5jb21wYXRpYmxlID0gInVzYi1vaGNpIiwJCQkuZGF0YSA9ICZ3c19pbmZvWzJdIH0sDQo+ICsJ
eyAuY29tcGF0aWJsZSA9ICJhdG1lbCxhdDkxc2FtOWc0NS1laGNpIiwJLmRhdGEgPSAmd3NfaW5m
b1syXSB9LA0KPiArCXsgLmNvbXBhdGlibGUgPSAidXNiLWVoY2kiLAkJCS5kYXRhID0gJndzX2lu
Zm9bMl0gfSwNCj4gKwl7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW05eDYwLXJ0dCIsCS5k
YXRhID0gJndzX2luZm9bNF0gfSwNCj4gKwl7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW05
eDctZ2VtIiwJCS5kYXRhID0gJndzX2luZm9bNV0gfSwNCj4gKwl7IC8qIHNlbnRpbmVsICovIH0N
Cj4gK307DQo+ICsNCj4gIHN0YXRpYyBpbnQgYXQ5MV9wbV9jb25maWdfd3ModW5zaWduZWQgaW50
IHBtX21vZGUsIGJvb2wgc2V0KQ0KPiAgew0KPiAgCWNvbnN0IHN0cnVjdCB3YWtldXBfc291cmNl
X2luZm8gKndzaTsNCj4gQEAgLTExMzMsNiArMTE0NCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
b2ZfZGV2aWNlX2lkIGdtYWNfaWRzW10gX19pbml0Y29uc3QgPSB7DQo+ICAJeyAuY29tcGF0aWJs
ZSA9ICJhdG1lbCxzYW1hNWQyLWdlbSIgfSwNCj4gIAl7IC5jb21wYXRpYmxlID0gImF0bWVsLHNh
bWE1ZDI5LWdlbSIgfSwNCj4gIAl7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW1hN2c1LWdl
bSIgfSwNCj4gKwl7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW05eDctZ2VtIiB9LA0KPiAg
CXsgfSwNCj4gIH07DQo+ICANCj4gQEAgLTEzNjAsNiArMTM3Miw3IEBAIHN0YXRpYyBjb25zdCBz
dHJ1Y3Qgb2ZfZGV2aWNlX2lkIGF0bWVsX3BtY19pZHNbXSBfX2luaXRjb25zdCA9IHsNCj4gIAl7
IC5jb21wYXRpYmxlID0gImF0bWVsLHNhbWE1ZDItcG1jIiwgLmRhdGEgPSAmcG1jX2luZm9zWzFd
IH0sDQo+ICAJeyAuY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsc2FtOXg2MC1wbWMiLCAuZGF0YSA9
ICZwbWNfaW5mb3NbNF0gfSwNCj4gIAl7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW1hN2c1
LXBtYyIsIC5kYXRhID0gJnBtY19pbmZvc1s1XSB9LA0KPiArCXsgLmNvbXBhdGlibGUgPSAibWlj
cm9jaGlwLHNhbTl4Ny1wbWMiLCAuZGF0YSA9ICZwbWNfaW5mb3NbNF0gfSwNCj4gIAl7IC8qIHNl
bnRpbmVsICovIH0sDQo+ICB9Ow0KPiAgDQo+IEBAIC0xNDk3LDYgKzE1MTAsMjggQEAgdm9pZCBf
X2luaXQgc2FtOXg2MF9wbV9pbml0KHZvaWQpDQo+ICAJc29jX3BtLmNvbmZpZ19wbWNfd3MgPSBh
dDkxX3NhbTl4NjBfY29uZmlnX3BtY193czsNCj4gIH0NCj4gIA0KPiArdm9pZCBfX2luaXQgc2Ft
OXg3X3BtX2luaXQodm9pZCkNCj4gK3sNCj4gKwlzdGF0aWMgY29uc3QgaW50IG1vZGVzW10gX19p
bml0Y29uc3QgPSB7DQo+ICsJCUFUOTFfUE1fU1RBTkRCWSwgQVQ5MV9QTV9VTFAwLA0KPiArCX07
DQo+ICsNCj4gKwlpbnQgcmV0Ow0KPiArDQo+ICsJaWYgKCFJU19FTkFCTEVEKENPTkZJR19TT0Nf
U0FNOVg3KSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJYXQ5MV9wbV9tb2Rlc192YWxpZGF0ZSht
b2RlcywgQVJSQVlfU0laRShtb2RlcykpOw0KPiArCXJldCA9IGF0OTFfZHRfcmFtYyhmYWxzZSk7
DQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJYXQ5MV9wbV9pbml0KE5VTEwp
Ow0KPiArDQo+ICsJc29jX3BtLndzX2lkcyA9IHNhbTl4N193c19pZHM7DQo+ICsJc29jX3BtLmNv
bmZpZ19wbWNfd3MgPSBhdDkxX3NhbTl4NjBfY29uZmlnX3BtY193czsNCj4gK30NCj4gKw0KPiAg
dm9pZCBfX2luaXQgYXQ5MXNhbTlfcG1faW5pdCh2b2lkKQ0KPiAgew0KPiAgCWludCByZXQ7DQoN
Cg==

