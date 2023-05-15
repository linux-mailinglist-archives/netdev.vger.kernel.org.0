Return-Path: <netdev+bounces-2508-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DAD07024A4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 648E61C20969
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4614B5226;
	Mon, 15 May 2023 06:27:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1404406
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:27:23 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A17E61;
	Sun, 14 May 2023 23:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684132034; x=1715668034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CmCIEggpwV8oC2008pwKUUtr5UaeKgahoHLyn3ha774=;
  b=PcXOi3ORSzVQCWGs2/6J9TFFb5xVDGgoBs5P9QALIkyHGkZoqXaxoePG
   F/cGdPMp1z1KjjInfYqJjtrvVo1LK13wSMjgFB6hRCJd0ssebvxFI4W99
   89TF8wDnzZJwRJ5kqzv/gPMZ57UoD4t/NPHO88+2EO7wtxWZM0u8GuZ/O
   A5cH3ClQQeUZ6oyLkU1Y2msfJn3tRouNbGpe/uhNONwOc0RohJ4VUsu1V
   2f5J36U+s64rLHKfV6tJY3JiaSCsT8Gsq8DTqrU6pS1HY85mL+bwKtHPN
   6yxXwyoQOuNm0bdbryJV5FfOcRcdkW0GWUrcgOK4kMu3yhzezs4velsUs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="330740916"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="330740916"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2023 23:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="733743160"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="733743160"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2023 23:27:14 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 14 May 2023 23:27:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 14 May 2023 23:27:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 14 May 2023 23:27:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJ8bKbCjAKkAf5OxPF0f6iQvUIiuP1Vbr9xu0tkbM5VR4SyvWIpfLVLAF1WKgSfa7KaW+98qubfHR7ICy9/3QL6/EZilQqbZk+gsNKmV8guWv8UlFOgr4c/xh8cts27C6GD1j1WcBCI6ZDMi7l6fH8P2GXAriOrW0ExoUsv2FUTTlFVfjq68URn7hHfM3KHq/vFWRldKzHrff+/Ff2MbTxGddSPdyTVCZwMhLdDaXuFxohUIlzpDbXFukovr8ApU2RRqQwq2h6Hf9pLoSb+Ez/CM93KxIUhfJ62oT2Kho1k0crwy6W/I12MatPrTYwdbLuZ9aTgfF0fUBYt3BEpx+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmCIEggpwV8oC2008pwKUUtr5UaeKgahoHLyn3ha774=;
 b=EpVnrPIrijFmLCpuwy4rf3qtfl4PdzXFuGRKiiiFRW9tAhbM7OjRpMEhAPzsEmO/cCTohgcdbNNWZ5wQB4OklbO0+Bv2/c6KU+/5+kAMMdYtfxzgrMsFJXYKx4nh/4iuVCc48+XJ08z95qeTsY7+5Bkjmn3XuBjnnXuO9F0lVoz7nKLW4+MQoIaTqCP7QQ1I4md01BpLvG4lDBcoLBZfTvuJqbQ4UUtwqLCOH8Umbi1b/kkaQJoDIsQNg1IfOBhA81UbOlhDeYBfq2MwTvZ4O+gAyId/6Dnhibox3qoT4r+CVhxVC2XbixmN+OAy85N+hTmMP7sMB5g0j8MXyFVn1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by SA2PR11MB4986.namprd11.prod.outlook.com (2603:10b6:806:114::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 06:27:11 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 06:27:10 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>
CC: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
	<cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Srinivas, Suresh" <suresh.srinivas@intel.com>, "Chen, Tim C"
	<tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbwgAAVVACAABAwAIAAMNEAgABhfVCAAGbfEIAADugAgAATvZCAAM4SAIAAWFPwgAANFgCAAB1pgIAAB41ggADEcICAA9Lr8IAACR4AgAAk3qA=
Date: Mon, 15 May 2023 06:27:09 +0000
Message-ID: <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
 <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
In-Reply-To: <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|SA2PR11MB4986:EE_
x-ms-office365-filtering-correlation-id: e9c23184-4a3a-4b64-f4e1-08db550d69a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AAxCHKaliyIKX8i3TiTz8jZkmE6EiNA+1ha1c5OSbm+8qJlPfsKMiderpWDKMkN+GLxE0m0Bz7BaaCr1gg99gF9gNaMVZdVkZ0KoJdpSZJcfCD4MosQ85LqGHpn5ko9R3VZGpAm5Mfv5Dh593EHxxN7d1EFqM1RwhAAjT0taHUgI/RGBHBSWpCGyQ0D97/fYVEVd+cBP8wc0fJHIhA6idgJPZH0mODylmwRZ3x8n5USdrFVQ80s3nSa4jjUv9/zbKZFnmi+h7VEQaJIdWqod1i8tXms7CseJRSaMxbejwatWYFYJUaRwgJJF7CYdegeD3zha7HJbBrLBDY9NKr9zr9KxxpOFIGeruxCiDRtivor+0fcrbT6t2VSxScy9mW7kajctq8uK92nG3MIYD1O6wUpDCRNchdzKzDCTauEfRTMhZAgv1CGXSAZqMjyj0T4fnialOsCJHzWqhBRIWEUp2J/iGr0ffrFnvVOnSs1tPPfKgM7xDF843Y5SjnWSxL7RT8WqLhWOyVTKtFvH7Ia8eid526XJfrKv75aOTkyt9iHS76j3aoZYrZOwKOVPdreIi327xNBISo6Lv8yaQT7xI9KyCFF4rwI4F1GDdAWLI617jcPu3zqXyKPcPkdZRQ+Q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(76116006)(66556008)(66446008)(64756008)(6916009)(66946007)(66476007)(4326008)(478600001)(7696005)(86362001)(316002)(54906003)(33656002)(71200400001)(83380400001)(26005)(186003)(53546011)(9686003)(6506007)(41300700001)(52536014)(8936002)(8676002)(5660300002)(2906002)(55016003)(82960400001)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmZKamxnbWJZdVNLdXpwN0s4UGhZVTJaTWpjWlJLaCsvMmFhMkMvZDBYa3FD?=
 =?utf-8?B?c0pNeGNQU1pmRDlSL2x3ZHI3SDRqWldtbTl3d2tIcW1tTDNEWXBuR05FcllN?=
 =?utf-8?B?VnF3RVFERkM4YldxQ1ZqWHU5M3BjQktQTXkvbmdMN0NNOWhtVkQ2Z1o3Q0pQ?=
 =?utf-8?B?amFuMFk4TXV6cXNYSC9rUVdIVE1mbXVmWEhnWExqcTArOCtMc09aOERIWHVD?=
 =?utf-8?B?RHJnaXRsNEZqYWdXdjVPbmdCdkVhYVZPOFB5ZjdtRVBLV2lrWU0yN2RJOXEy?=
 =?utf-8?B?cUsybnllRmM1KzAzanNJeXJVRXdUaStka3IvQktSMEx2WVNjckduK09XekVm?=
 =?utf-8?B?cDNkZUV1c1pwWGphQ245Qk0vODVNSG81N1RtcjRCTVRyRjYzYitGaEdCRWFh?=
 =?utf-8?B?VVBjU3BWcjQxd2ZCMk1HSHFxMStsWVkxQXdlT1prS2ppNnBBOGpyeVgyKysx?=
 =?utf-8?B?NzlTdG5sdC9jQ0R5TEtTeE1DNDFzS1A1d2p5VlFGYU5VaGQ4czgxdkpnRDNY?=
 =?utf-8?B?dmN3bXcwT1BJRXlsbHZJNkFaWWJQTS9kVDh4anZISVk0VFdzM1E1Y0s2Y3h0?=
 =?utf-8?B?VVl4c21LZlVqUHNtcXppTlp0ZHhZclhPN3Z1SXNDZXFjUTJnL0p3NzZjU0ZK?=
 =?utf-8?B?VnNuUEE0Mm1mcVhxVUwxMWxpMEU5YzBWS1VNQmc4VlNnM1ViZlNwY2RvL3lL?=
 =?utf-8?B?ZTM5WFFRMjU2OW5JVVU1djhTTnQ3RU1uaHNiOEhhNWUyYnZwdFY5V1ZJMlAz?=
 =?utf-8?B?YnA3TFlCL3VhRTBSYldublRKYmpDZ2xOUno5YjVhTStmSGZnZkVDbXF5MVcz?=
 =?utf-8?B?SUowMXZ4eXhCczBCamw1elRGUDdNL2cwaThYaDh2eHVBU2pOb2g1anJJZng5?=
 =?utf-8?B?Rk85bSsvNlZhOEpvY1pjV1lWTFdGSHp1RnNoTm9qZ0RGMU16V05YaGhrb0tP?=
 =?utf-8?B?N2FQNFA0NHU3VkJPWlFlZTdqTjRBOXovQmNjKzgxdzN5c3JqYjhKeWwzVjE3?=
 =?utf-8?B?RGNQMW5Mcm5XRzhGVFYwd25SL1FvVU8xM3IwRzRCbkRlemRmRG0rMEd6Q3dB?=
 =?utf-8?B?OW5NNGc2MFBzaEZ4ZmhjeVlJQml4M0R2VzlRQnNaSmp6Ylg2MElFS25UQjIz?=
 =?utf-8?B?QjdVSllwRkRaV0tpL1lwK1pwdSs3NVBzS2l5WG1ScjdqVkJxcjdCM0RaOVow?=
 =?utf-8?B?UUJTU20vY0Vpd1lkZmQ4UmpQbHRRL1VTa1dvOUt6dlJoM1hWcE0wZm14V3Qr?=
 =?utf-8?B?ck5UMk1yUXBFT04zc1hiVHZCNmlPK1Q2NWRrWk5DczdUWDgzdkJlQWtRNTJp?=
 =?utf-8?B?WkE2cGFsZTdtc281MGRRRm9iUXc5TmRra1BBQ3Z4UVNmQkFtd1hpeGVEOS9C?=
 =?utf-8?B?SlJRQktsVGpiNkN5R3ZYREhFWVZFR2dybU9DMkZNYXFvRkZ0WEdRNEc0elox?=
 =?utf-8?B?ZTZ3VTRkeGY4YlprY1dMa0FqWGFHWjgxVjk5NFN3Zkc1VUJTMGhrN1I2ZnBK?=
 =?utf-8?B?d3AwS0todlc5a3N6dW9rc1B0UnNMelMyT2JPR3FNQUErdFd5SDdkTjNvc0NB?=
 =?utf-8?B?Zy9mZ2RqNDNTbUYrRHVsSjdkRlNZck9zV0VtZHp1c0puSkt5UlBSYndxdGZj?=
 =?utf-8?B?M2dVMjVXTGxxS3ZMVk1OUkdBVHd6QmNZaFNBY08veUFWODBRampPRTJOM0hI?=
 =?utf-8?B?WDRORmpUMWhaZmIwbU5xMlhMZzE0SFVzbzdrVnEwOGdDdmJFR2g2T0NzMUJU?=
 =?utf-8?B?QVBkaWlNNlM2NTFEWlMwcUlrQU5Ga3dnMXVEQ1lRdU1nVnVMNG5ZUDI2cTBv?=
 =?utf-8?B?eThUS3hmNUJqUDlMMkNqU0pXTEZNaEZXcVdIamtmYXNGcGM0czR2d21TaVg0?=
 =?utf-8?B?LzIrUEQ1Mloxa3FGNUtteHVLWG9xNzR0ZU9UNHVkcjF6RVVIajltTjR3TWJn?=
 =?utf-8?B?enpUQ2NWWHBVamNLWHR4VVh3YVNWeVMzZi9NTTdIUnpPY1lxQ3ZQSUs4S0VH?=
 =?utf-8?B?R09SZ1lyQXJmcU9qRVVteE5IcnE5dkE0UWxiWlR1V1F4cmxxOWt4VmNIVGlr?=
 =?utf-8?B?d0FUQ1BvT2ZlSlNvVlJNZVF6QmNuSFFFQXF3STEwT1JyRCsxUHo0T0RnWUxm?=
 =?utf-8?Q?joNeuvjExbqlSDxUj4XvDa/Xs?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c23184-4a3a-4b64-f4e1-08db550d69a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 06:27:09.7978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SJ3m0m1fedFHiNOL4wbcsACkIDoUQOfM3SvnnXHItD3pHAHTWdYKyAuzz6Dvpz8tA0KBtDf5uZAg+AbkImjcTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4986
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hha2VlbCBCdXR0IDxz
aGFrZWVsYkBnb29nbGUuY29tPg0KPiBTZW50OiBNb25kYXksIE1heSAxNSwgMjAyMyAxMjoxMyBQ
TQ0KPiBUbzogWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+IENjOiBFcmlj
IER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBMaW51eCBNTSA8bGludXgtDQo+IG1tQGt2
YWNrLm9yZz47IENncm91cHMgPGNncm91cHNAdmdlci5rZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkN
Cj4gPHBhYmVuaUByZWRoYXQuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwu
b3JnOw0KPiBCcmFuZGVidXJnLCBKZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBT
cmluaXZhcywgU3VyZXNoDQo+IDxzdXJlc2guc3Jpbml2YXNAaW50ZWwuY29tPjsgQ2hlbiwgVGlt
IEMgPHRpbS5jLmNoZW5AaW50ZWwuY29tPjsgWW91LA0KPiBMaXpoZW4gPGxpemhlbi55b3VAaW50
ZWwuY29tPjsgZXJpYy5kdW1hemV0QGdtYWlsLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvMl0gbmV0OiBLZWVwIHNrLT5za19m
b3J3YXJkX2FsbG9jIGFzIGEgcHJvcGVyDQo+IHNpemUNCj4gDQo+IE9uIFN1biwgTWF5IDE0LCAy
MDIzIGF0IDg6NDbigK9QTSBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT4NCj4g
d3JvdGU6DQo+ID4NCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiA+ID4gRnJvbTogU2hha2VlbCBCdXR0IDxzaGFrZWVsYkBnb29nbGUuY29tPg0KPiA+ID4gU2Vu
dDogU2F0dXJkYXksIE1heSAxMywgMjAyMyAxOjE3IEFNDQo+ID4gPiBUbzogWmhhbmcsIENhdGh5
IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+ID4gPiBDYzogU2hha2VlbCBCdXR0IDxzaGFrZWVs
YkBnb29nbGUuY29tPjsgRXJpYyBEdW1hemV0DQo+ID4gPiA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47
IExpbnV4IE1NIDxsaW51eC1tbUBrdmFjay5vcmc+OyBDZ3JvdXBzDQo+ID4gPiA8Y2dyb3Vwc0B2
Z2VyLmtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+Ow0KPiA+ID4g
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBCcmFuZGVidXJnQGdvb2dsZS5j
b207DQo+ID4gPiBCcmFuZGVidXJnLCBKZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+
OyBTcmluaXZhcywgU3VyZXNoDQo+ID4gPiA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENo
ZW4sIFRpbSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT47DQo+ID4gPiBZb3UsIExpemhlbiA8bGl6
aGVuLnlvdUBpbnRlbC5jb20+OyBlcmljLmR1bWF6ZXRAZ21haWwuY29tOw0KPiA+ID4gbmV0ZGV2
QHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJd
IG5ldDogS2VlcCBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcw0KPiA+ID4gYSBwcm9wZXIgc2l6ZQ0K
PiA+ID4NCj4gPiA+IE9uIEZyaSwgTWF5IDEyLCAyMDIzIGF0IDA1OjUxOjQwQU0gKzAwMDAsIFpo
YW5nLCBDYXRoeSB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+IFsuLi5dDQo+ID4gPiA+
ID4NCj4gPiA+ID4gPiBUaGFua3MgYSBsb3QuIFRoaXMgdGVsbHMgdXMgdGhhdCBvbmUgb3IgYm90
aCBvZiBmb2xsb3dpbmcNCj4gPiA+ID4gPiBzY2VuYXJpb3MgYXJlDQo+ID4gPiA+ID4gaGFwcGVu
aW5nOg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gMS4gSW4gdGhlIHNvZnRpcnEgcmVjdiBwYXRoLCB0
aGUga2VybmVsIGlzIHByb2Nlc3NpbmcgcGFja2V0cw0KPiA+ID4gPiA+IGZyb20gbXVsdGlwbGUg
bWVtY2dzLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gMi4gVGhlIHByb2Nlc3MgcnVubmluZyBvbiB0
aGUgQ1BVIGJlbG9uZ3MgdG8gbWVtY2cgd2hpY2ggaXMNCj4gPiA+ID4gPiBkaWZmZXJlbnQgZnJv
bSB0aGUgbWVtY2dzIHdob3NlIHBhY2tldHMgYXJlIGJlaW5nIHJlY2VpdmVkIG9uIHRoYXQNCj4g
Q1BVLg0KPiA+ID4gPg0KPiA+ID4gPiBUaGFua3MgZm9yIHNoYXJpbmcgdGhlIHBvaW50cywgU2hh
a2VlbCEgSXMgdGhlcmUgYW55IHRyYWNlIHJlY29yZHMNCj4gPiA+ID4geW91IHdhbnQgdG8gY29s
bGVjdD8NCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBDYW4geW91IHBsZWFzZSB0cnkgdGhlIGZvbGxv
d2luZyBwYXRjaCBhbmQgc2VlIGlmIHRoZXJlIGlzIGFueQ0KPiBpbXByb3ZlbWVudD8NCj4gPg0K
PiA+IEhpIFNoYWtlZWwsDQo+ID4NCj4gPiBUcnkgdGhlIGZvbGxvd2luZyBwYXRjaCwgdGhlIGRh
dGEgb2YgJ3BlcmYgdG9wJyBmcm9tIHN5c3RlbSB3aWRlDQo+ID4gaW5kaWNhdGVzIHRoYXQgdGhl
IG92ZXJoZWFkIG9mIHBhZ2VfY291bnRlcl9jYW5jZWwgaXMgZHJvcHBlZCBmcm9tIDE1LjUyJQ0K
PiB0byA0LjgyJS4NCj4gPg0KPiA+IFdpdGhvdXQgcGF0Y2g6DQo+ID4gICAgIDE1LjUyJSAgW2tl
cm5lbF0gICAgICAgICAgICBba10gcGFnZV9jb3VudGVyX2NhbmNlbA0KPiA+ICAgICAxMi4zMCUg
IFtrZXJuZWxdICAgICAgICAgICAgW2tdIHBhZ2VfY291bnRlcl90cnlfY2hhcmdlDQo+ID4gICAg
IDExLjk3JSAgW2tlcm5lbF0gICAgICAgICAgICBba10gdHJ5X2NoYXJnZV9tZW1jZw0KPiA+DQo+
ID4gV2l0aCBwYXRjaDoNCj4gPiAgICAgMTAuNjMlICBba2VybmVsXSAgICAgICAgICAgIFtrXSBw
YWdlX2NvdW50ZXJfdHJ5X2NoYXJnZQ0KPiA+ICAgICAgOS40OSUgIFtrZXJuZWxdICAgICAgICAg
ICAgW2tdIHRyeV9jaGFyZ2VfbWVtY2cNCj4gPiAgICAgIDQuODIlICBba2VybmVsXSAgICAgICAg
ICAgIFtrXSBwYWdlX2NvdW50ZXJfY2FuY2VsDQo+ID4NCj4gPiBUaGUgcGF0Y2ggaXMgYXBwbGll
ZCBvbiB0aGUgbGF0ZXN0IG5ldC1uZXh0L21haW46DQo+ID4gYmVmY2MxZmNlNTY0ICgic2ZjOiBm
aXggdXNlLWFmdGVyLWZyZWUgaW4NCj4gPiBlZnhfdGNfZmxvd2VyX3JlY29yZF9lbmNhcF9tYXRj
aCgpIikNCj4gPg0KPiANCj4gVGhhbmtzIGEgbG90IENhdGh5IGZvciB0ZXN0aW5nLiBEbyB5b3Ug
c2VlIGFueSBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudCBmb3INCj4gdGhlIG1lbWNhY2hlZCBiZW5j
aG1hcmsgd2l0aCB0aGUgcGF0Y2g/DQoNClllcCwgYWJzb2x1dGVseSA6LSApIFJQUyAod2l0aC93
aXRob3V0IHBhdGNoKSA9ICsxLjc0DQo=

