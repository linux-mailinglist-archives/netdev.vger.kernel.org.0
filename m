Return-Path: <netdev+bounces-2333-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B94701554
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 10:51:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 459552819FA
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 08:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201C010FD;
	Sat, 13 May 2023 08:51:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC2610E1
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 08:51:53 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270E149C0
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 01:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683967912; x=1715503912;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=/JPX94ixSFRRkl2xlZrB0Vceq96WnreWTwB5wK2TCSA=;
  b=Qgi7r3U8PvMY2myFVMG3Q852fmzFQAgtvKPf5m2oCOPtDbWVv4WOr/BQ
   t9NbDGmg+HXU2jhBTlWi3tyGu/e5e7yAazO9A7DD7QHywSQGnaE4sWwCG
   rKfRuMYeqQ79TpD5PJ5J8JvWdOoqhTYdq7foMHV1ivnEsP3bHYkjyY5V1
   k0XJiZTzOH4rmwsPmOQDqdtsGI8sj7tLiFotygEYPzV1OcM9o9y3x6ViJ
   J0pTdlF3ATpB2EqXJmuTHrKJo352bduW0LL/nPAbgiP0xl/WnFSTt2BAT
   IV8rGPLdlZ9byz11xuzVIFw6C2xpnPP9CluadeNiA4COXm//ax6RiP+jk
   A==;
X-IronPort-AV: E=Sophos;i="5.99,271,1677567600"; 
   d="scan'208";a="213692149"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2023 01:51:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 13 May 2023 01:51:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Sat, 13 May 2023 01:51:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kk71wS45v5zh7QNcpl41/D6sKZ35RWU5FNa+REj2uFQuliUQbCy+aGuuGboKHm5iaKiURac+VQtZTJutNy2BUTf7kbIElYMCnJBTxWrlv2+VYnHTZWXDzf4Aar0qpBZBd6RSpKhnKB1ZgPDubT+HCAZuL3gt+rUV6IXpiTj+EvgwpYdQzVGFuGuHPnl9V9JOvsiCTUM4TBwwf0jFT4ylSmBljL9lthES2S/D1iJT1RNkVhK67jmU6nb4v+tL/nnzXn0wkyO2Sdei/lcBqpFDUfWqC+oC3wMsrJ0ERd74hkWqSRzBws8xU2tdJ5FPsOBd6Jy2u8AlPkQ03yb2h2w8ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JPX94ixSFRRkl2xlZrB0Vceq96WnreWTwB5wK2TCSA=;
 b=KCpw19qlkywwx/UDGIfPL8L1fSkg2HUgv5qZWfjKxvtT6mvoubheUc+rt3f+8o+203gIHT0gZiOP9eKnEhPHS0CjEqYArYRi9pDjWGE5hP+LtEDVi+2DadGd+cKlgcKADTkWr3No0ijIzJaF7UqDrzvWQqVBqdCkNyWKH1t+Czuvrzk5Q/D8e1DHQEKqqPhQEzS0lQ4Jk40XVAd8WpDzlwKi+Vs1odADEWVxWpmQKOBruPQuPNuDBNGYWHXsvbQNQdgC5GwMkbmllsaR//E7peq6tmKb/nauJn34oDP+xfqIlm9GCQxsJFRKsyFnUahMLnH5OtpNBpNa8DbYgg9quw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JPX94ixSFRRkl2xlZrB0Vceq96WnreWTwB5wK2TCSA=;
 b=SpIwGg8mXKgoHoDag3L26QXZ34AtpXN7zFKD8DuDM6xRPzzLlE688CF1KEt4ydyvoiS+c2XW8k3J7qmIrfPDqhEA9UrxELfee1uf4UrVDG9rqYsnhc6WeRx/++mqgBi5aCfngsLjlq/3TZ75ibBNAWtgavwqNIL4/ekaBmdWceg=
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com (2603:10b6:a03:4c3::17)
 by SA1PR11MB6783.namprd11.prod.outlook.com (2603:10b6:806:25f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Sat, 13 May
 2023 08:51:47 +0000
Received: from SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be]) by SJ2PR11MB7648.namprd11.prod.outlook.com
 ([fe80::27bf:a69f:806f:67be%5]) with mapi id 15.20.6387.025; Sat, 13 May 2023
 08:51:47 +0000
From: <Claudiu.Beznea@microchip.com>
To: <Daire.McNamara@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <Conor.Dooley@microchip.com>
Subject: Re: [PATCH v4 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Thread-Topic: [PATCH v4 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on
 mpfs
Thread-Index: AQHZhXgmnO8gGQdG00W7lHzZaCzsvQ==
Date: Sat, 13 May 2023 08:51:47 +0000
Message-ID: <0b3d54ac-2b74-cf21-eb83-5a7ec58feb83@microchip.com>
References: <20230512122032.2902335-1-daire.mcnamara@microchip.com>
 <20230512122032.2902335-2-daire.mcnamara@microchip.com>
In-Reply-To: <20230512122032.2902335-2-daire.mcnamara@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB7648:EE_|SA1PR11MB6783:EE_
x-ms-office365-filtering-correlation-id: 095e1956-75fb-46ad-2570-08db538f4913
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zf3sCbg4Wejt7qUTBA42iHkHNRgBV5IYa5HTKFH77sDZSU4ZpKSdmSQkumJhyLAcrlPNIZQWmTg6RTREh4id+siRmOOTaPAO14zoMJ3Q6ZAC8nWlOLMibDUkXP3hr8PL1mWM2KIuk8iKys4o3gQXjrfa2JjwwbE+hMdaOh+LrzqO9FPe9aSaL70WfZ122oc+xn/gmDYDWHFIAkTifjM6an3FvZdQde8ADNBgHgNRlFZAKDXLnBuBofuRE4J19sI4ikjoJgoLKZnWKVSeTGKsXbQmUyoWeIOn/ypz1IrMqYQ5MIwMhQCU3eHLprWEvS1EzWXt6MUbFVCKa9qwhuSIr5WbZympr2JDtCZWPm7/F1N1wOhYR5kTmForoYhsfJIGB7LksuVTL1cmSVmOjLYXmjWRAi/0AWXME2MnwCTVU4KalFZ3FsZ0u9JhWeMHnt+jGt2mNIyjqLriAGAG1B+rGasUo5dtPvPMFi9+8eCKgeUKHJ5MNuXyPjRJCAP+3xRAwSQWZ8L8/niBh0PmCoWo7ZVvg3NJpt0Ax0KcuTkYLegK/xuOA282kTQq9JtruFKE42kWq6uDK8LChjbdCpV2LWXq7FRnP83VazJvrWv3UVgwszzeoocu9CQIg5QV6jT9ce/z19frsxLTvAJUiLjzYdT1x84xhl6zaeGi1UWng5ZSv80P6REmGfvEiAeZQcuc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7648.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199021)(41300700001)(83380400001)(53546011)(2906002)(2616005)(6636002)(66476007)(66446008)(71200400001)(64756008)(316002)(66556008)(76116006)(66946007)(110136005)(91956017)(186003)(5660300002)(478600001)(6506007)(6512007)(6486002)(8936002)(26005)(8676002)(38100700002)(122000001)(36756003)(38070700005)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGlJaEtpcTFwQ2FQS1duNDNNN29JdUpxTDZ2MlE2c0NqUTdMYytJT2RTamtM?=
 =?utf-8?B?YmdwV3V1S0ZPNURORWl0bHd5VjhNQkI3bjFIOVJUTEpTTFBSWXc5cTUvaTFy?=
 =?utf-8?B?TWhFNEd6ZllOaVNxSUVmOXNwQnlsMXRSWkppM1dLOVcvUVROYWxlMkYrTmhR?=
 =?utf-8?B?VDBkTFphKzgrVHpnekJWNThvb2RJR3BvaHNMMVNxRU1VQUVZZ0RlZHlqYmtZ?=
 =?utf-8?B?SGw1UjIwcmY0RXVzb0xMeTkreXUyYlVRMHV0amlOeFd5V2NCMkpKanVldUN1?=
 =?utf-8?B?emhxRXMzYlF1TDJXUFBmdG94aHMxd1c2RFM3V0pUWFd3ZUR5UHJVeTl2dGJl?=
 =?utf-8?B?S2N2bFZnRno1KzEyT2xPRGFYbXJBQi9STmd3dVBDendhREx5N2RvVTE0Zno5?=
 =?utf-8?B?WjljOEgyY2FocHNFY29xbmw3YlFkWlJvck9aYW15OS9SenJmVGFqOCt4YXcx?=
 =?utf-8?B?a0dRTjRQOTBRblFscFNLOHlsT09zMU9YcW5jakpWWWlhR1N4cUxWUU04bS94?=
 =?utf-8?B?Y1JlVFBYSmVVeUJaaXRmN21PTWNzMVl1M3dBcHJxaDhJWVRMeEk4TmFWYTBU?=
 =?utf-8?B?dWM4K1F3SEtJRVlGVHRTVlJkODAyc2ZIV0U3Zmx0ekV1QVBQbUZqYjJlL3RU?=
 =?utf-8?B?blIwbThzemRNRVI0eHZabEczcjBla3o4aFM5c09jQ2ZXZ3VKUW54MzV5S0wx?=
 =?utf-8?B?djdMUzB2dmpvdHlwajBLdi9jVlh3a1JaZjVVS21mYXZ5NmphbUNhUENaMFR4?=
 =?utf-8?B?eTVBMDMyZ0xPOFJHTS9CaFMxVnR1amZXTER0TDZjZnJLQnJsYmxRWnV5c0Ix?=
 =?utf-8?B?MDFnWHJ5U3pIVW81cUtiL3drK0tLc1FnWERiek5iSEt3bnFWaTdZRnJFRHdT?=
 =?utf-8?B?UjBVaWNlQVQ4a3dhSmZ2S2UzQlBsSGF0aTFLOXQ5K01xRHpGNlhkMFNVb1pV?=
 =?utf-8?B?SG9hWmV5M0ZWSk5Ua1FWdjZtUTFFeUtRY2ZGTjFhMklYaVhaVjdhN3VuM3pw?=
 =?utf-8?B?Q2xMcFFCak5qeHh4azRYYThUdDdLRUIvMVhuOHVXdDlMM3ZqNkZsM2hOUjht?=
 =?utf-8?B?QVVITDQrekpsejdsYXRMNnZHUVR1Mng4UXk2VXZCSlBGRWNodlBZZXhvNTJQ?=
 =?utf-8?B?MVlyV3NTcE1mQWU5V0M5SXdDbStxSis0NjJyK3l4TlE5MlpHNGNuNDBrM3Fp?=
 =?utf-8?B?dTlBY2RHcTVjMGpaZ0ZjK3gvM0YveVpXcnVIT01yazduTk9meW5TMnhnWGJq?=
 =?utf-8?B?WWFDL2RSbS9Md2QyOEZWdGJsVUM5bzhwN1ZOeWxaNVVGdFU1c2VEYXQ3L2VH?=
 =?utf-8?B?QU80ZDdvYkpjWHRLOW9QeGxOckhtUlozMWtkSG1uVVRMU0lmRnlKUjhKSUhW?=
 =?utf-8?B?V0lkcDR2eFo3eTE5NUN1QklXdGt4TnRXTS9jOGNMTGozay9ndXJVa0V5L3hx?=
 =?utf-8?B?dDR5Z2dLUVpnTHB4bis2dmZBdlIyMU5PK2dXbjlXTVR0cGRaTEZZUWtLM3hL?=
 =?utf-8?B?Tm14RnhvYWNPSFNlc0ZWYzUyVzkwWUwvM1ZZMTByUmFXeFk3RHc1UWpUcXB4?=
 =?utf-8?B?bms5NGxQMUxtTFp0Z09TenBic01qcS9Gd1JqM3hjaG9FNy84cEt4eHlZNjVQ?=
 =?utf-8?B?MWlxNmJ4c3pHQ0R5QU1ST2FUenE3aGo4bzFMODdield6M1RoU0NiT0N4bko2?=
 =?utf-8?B?ZHovVENLTzRjWTJMNDVpTUJFN2dCUWZEaHAvL3R3MFBxdG9WaG03aEJycVRJ?=
 =?utf-8?B?bEVrOStCYU1qU1JKWmlmc2hmdG8yNEZORkVwKzlhSkZGUzJ6QWhRUDZER2Vx?=
 =?utf-8?B?R1VsQ3UrejNBTyttT0Myb3czMzZxVHlYYncxRUR1Z0FGdHVvZ29XalNiL28r?=
 =?utf-8?B?OVNleGVGV2N3LzVzSG5aYlE1bXZyajd4Y3prc2UyS3FGcWFhdi91THdZY2tT?=
 =?utf-8?B?K3EyU25MeFE3OFBUWWJQemRaY2FZb3pNcnRpdjNoU1V2a0tlMlFCeERRK1Mz?=
 =?utf-8?B?VlRuRDdCN1lzNTZETEZlczg1cW9tZ1FnY21VbWp5WHJxZW1USFBTaTQwSytl?=
 =?utf-8?B?RE4xelJVRGtpTE9IVHJnUDNHSEFYbEI3YnZPU1ZVSFdPRzZMQm8yZFpPV1lV?=
 =?utf-8?Q?O3MEZFAfq82WD394io3R8LBGK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9E063258D74894392821BC3BB846648@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7648.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 095e1956-75fb-46ad-2570-08db538f4913
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2023 08:51:47.4093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2o5K5Jj14Sf7x0E9Jj8B4a3My40f71ddpM1yEqWTEk7dC26bpFtjQk2d2yFnLfpamD2SA+ct0ka1Oiyf59tGla2efr4OLpufbR9TH123KOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6783
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gMTIuMDUuMjAyMyAxNToyMCwgZGFpcmUubWNuYW1hcmFAbWljcm9jaGlwLmNvbSB3cm90ZToN
Cj4gRnJvbTogRGFpcmUgTWNOYW1hcmEgPGRhaXJlLm1jbmFtYXJhQG1pY3JvY2hpcC5jb20+DQo+
IA0KPiBPbiBtcGZzLCB3aXRoIFNSQU0gY29uZmlndXJlZCBmb3IgNCBxdWV1ZXMsIHNldHRpbmcg
bWF4X3R4X2xlbg0KPiB0byBHRU1fVFhfTUFYX0xFTj0weDNmMCByZXN1bHRzIG11bHRpcGxlIEFN
QkEgZXJyb3JzLg0KPiBTZXR0aW5nIG1heF90eF9sZW4gdG8gKDRLaUIgLSA1NikgcmVtb3ZlcyB0
aG9zZSBlcnJvcnMuDQo+IA0KPiBUaGUgZGV0YWlscyBhcmUgZGVzY3JpYmVkIGluIGVycmF0dW0g
MTY4NiBieSBDYWRlbmNlDQo+IA0KPiBUaGUgbWF4IGp1bWJvIGZyYW1lIHNpemUgaXMgYWxzbyBy
ZWR1Y2VkIGZvciBtcGZzIHRvICg0S2lCIC0gNTYpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGFp
cmUgTWNOYW1hcmEgPGRhaXJlLm1jbmFtYXJhQG1pY3JvY2hpcC5jb20+DQoNClJldmlld2VkLWJ5
OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0KDQo+IC0t
LQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiLmggICAgICB8ICAxICsNCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCAxMiArKysrKysrKyst
LS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaCBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYi5oDQo+IGluZGV4IDE0ZGZlYzRkYjhm
OS4uOTg5ZTdjNWRiOWI5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2IuaA0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaA0K
PiBAQCAtMTE3NSw2ICsxMTc1LDcgQEAgc3RydWN0IG1hY2JfY29uZmlnIHsNCj4gIAkJCSAgICBz
dHJ1Y3QgY2xrICoqaGNsaywgc3RydWN0IGNsayAqKnR4X2NsaywNCj4gIAkJCSAgICBzdHJ1Y3Qg
Y2xrICoqcnhfY2xrLCBzdHJ1Y3QgY2xrICoqdHN1X2Nsayk7DQo+ICAJaW50CSgqaW5pdCkoc3Ry
dWN0IHBsYXRmb3JtX2RldmljZSAqcGRldik7DQo+ICsJdW5zaWduZWQgaW50CQltYXhfdHhfbGVu
Z3RoOw0KPiAgCWludAlqdW1ib19tYXhfbGVuOw0KPiAgCWNvbnN0IHN0cnVjdCBtYWNiX3Vzcmlv
X2NvbmZpZyAqdXNyaW87DQo+ICB9Ow0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFj
Yl9tYWluLmMNCj4gaW5kZXggNjZlMzA1NjE1NjllLi4zYTQ2Yjc1YWU1NGYgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBAQCAtNDA5NSwxNCArNDA5
NSwxMiBAQCBzdGF0aWMgaW50IG1hY2JfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
KQ0KPiAgDQo+ICAJLyogc2V0dXAgYXBwcm9wcmlhdGVkIHJvdXRpbmVzIGFjY29yZGluZyB0byBh
ZGFwdGVyIHR5cGUgKi8NCj4gIAlpZiAobWFjYl9pc19nZW0oYnApKSB7DQo+IC0JCWJwLT5tYXhf
dHhfbGVuZ3RoID0gR0VNX01BWF9UWF9MRU47DQo+ICAJCWJwLT5tYWNiZ2VtX29wcy5tb2dfYWxs
b2NfcnhfYnVmZmVycyA9IGdlbV9hbGxvY19yeF9idWZmZXJzOw0KPiAgCQlicC0+bWFjYmdlbV9v
cHMubW9nX2ZyZWVfcnhfYnVmZmVycyA9IGdlbV9mcmVlX3J4X2J1ZmZlcnM7DQo+ICAJCWJwLT5t
YWNiZ2VtX29wcy5tb2dfaW5pdF9yaW5ncyA9IGdlbV9pbml0X3JpbmdzOw0KPiAgCQlicC0+bWFj
YmdlbV9vcHMubW9nX3J4ID0gZ2VtX3J4Ow0KPiAgCQlkZXYtPmV0aHRvb2xfb3BzID0gJmdlbV9l
dGh0b29sX29wczsNCj4gIAl9IGVsc2Ugew0KPiAtCQlicC0+bWF4X3R4X2xlbmd0aCA9IE1BQ0Jf
TUFYX1RYX0xFTjsNCj4gIAkJYnAtPm1hY2JnZW1fb3BzLm1vZ19hbGxvY19yeF9idWZmZXJzID0g
bWFjYl9hbGxvY19yeF9idWZmZXJzOw0KPiAgCQlicC0+bWFjYmdlbV9vcHMubW9nX2ZyZWVfcnhf
YnVmZmVycyA9IG1hY2JfZnJlZV9yeF9idWZmZXJzOw0KPiAgCQlicC0+bWFjYmdlbV9vcHMubW9n
X2luaXRfcmluZ3MgPSBtYWNiX2luaXRfcmluZ3M7DQo+IEBAIC00ODM5LDcgKzQ4MzcsOCBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIG1wZnNfY29uZmlnID0gew0KPiAgCS5jbGtf
aW5pdCA9IG1hY2JfY2xrX2luaXQsDQo+ICAJLmluaXQgPSBpbml0X3Jlc2V0X29wdGlvbmFsLA0K
PiAgCS51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+IC0JLmp1bWJvX21heF9sZW4gPSAx
MDI0MCwNCj4gKwkubWF4X3R4X2xlbmd0aCA9IDQwNDAsIC8qIENhZGVuY2UgRXJyYXR1bSAxNjg2
ICovDQo+ICsJLmp1bWJvX21heF9sZW4gPSA0MDQwLA0KPiAgfTsNCj4gIA0KPiAgc3RhdGljIGNv
bnN0IHN0cnVjdCBtYWNiX2NvbmZpZyBzYW1hN2c1X2dlbV9jb25maWcgPSB7DQo+IEBAIC00OTg5
LDYgKzQ5ODgsMTMgQEAgc3RhdGljIGludCBtYWNiX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UgKnBkZXYpDQo+ICAJaWYgKG1hY2JfY29uZmlnKQ0KPiAgCQlicC0+anVtYm9fbWF4X2xlbiA9
IG1hY2JfY29uZmlnLT5qdW1ib19tYXhfbGVuOw0KPiAgDQo+ICsJaWYgKCFod19pc19nZW0oYnAt
PnJlZ3MsIGJwLT5uYXRpdmVfaW8pKQ0KPiArCQlicC0+bWF4X3R4X2xlbmd0aCA9IE1BQ0JfTUFY
X1RYX0xFTjsNCj4gKwllbHNlIGlmIChtYWNiX2NvbmZpZy0+bWF4X3R4X2xlbmd0aCkNCj4gKwkJ
YnAtPm1heF90eF9sZW5ndGggPSBtYWNiX2NvbmZpZy0+bWF4X3R4X2xlbmd0aDsNCj4gKwllbHNl
DQo+ICsJCWJwLT5tYXhfdHhfbGVuZ3RoID0gR0VNX01BWF9UWF9MRU47DQo+ICsNCj4gIAlicC0+
d29sID0gMDsNCj4gIAlpZiAob2ZfcHJvcGVydHlfcmVhZF9ib29sKG5wLCAibWFnaWMtcGFja2V0
IikpDQo+ICAJCWJwLT53b2wgfD0gTUFDQl9XT0xfSEFTX01BR0lDX1BBQ0tFVDsNCg0K

