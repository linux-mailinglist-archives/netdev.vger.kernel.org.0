Return-Path: <netdev+bounces-2474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DC4702291
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:46:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A824F281062
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 03:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E541FAD;
	Mon, 15 May 2023 03:46:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A38E1C26
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:46:45 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B0694;
	Sun, 14 May 2023 20:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684122403; x=1715658403;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pDazObDvJl7BrqkMxngEjC8LOaIIHVDY1NlsELtdVe8=;
  b=lo4GAHYIjow141nt9fX7diZGPbsRYw+uM3ieHQywWvN2TRhvLBFZ4gC5
   az35LRI2c6UPv2ffK4mddQn4KRb8pEnhmhM5P8zHxEWrSNSGfNQHKLkg7
   bQnpsTExWmOLLpBIvFctb9e2ljAPlwJ/FBFwBKlauc4r+avOYrfEjU4Az
   k/jaqVZsWoY5rfoO7W5KcLZAqhq1fjMIMsoYetNhNk3VzG1QMlv/6ntuA
   Nns29RYcpFDJ6NpE1/k9HmiQUm9Dc7UBQSpIr4CzFeOE1rmh/mU8uY1Iy
   GY+oWtHBK6pci/HfpAHo9AaYALmAUo+ok3zdYVeh/2QHj9by1OmLNS0+f
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="335637099"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="335637099"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2023 20:46:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="812787237"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="812787237"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 14 May 2023 20:46:42 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 14 May 2023 20:46:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 14 May 2023 20:46:41 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 14 May 2023 20:46:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIEtAbdfYsJeXsO0lAcjkKO60EQGuT2olAKqw5kMJ3NOPY9s8/s1lVDq7lT1SpAR4AYGwrA4AWFAzmuAWuBnXZMtaXs6EkmOr/whzhWjPGqUcll8O7C5V3hyBhdlk0V2j4cb1bRQ/z0MEB6RV2UVDT6XddEZv4z+qlj2FPDcN/lQrDxpytyErkXZst/0jyqQMid+QVLqg38oRu9qKWo7mQ1+S6UvR7w3XHA/YnTt+dwbGtz1znP9K1sNB2jSrvXTL7BhI99pvYBL/En9aySCjOQEvkLUtraN1KBnd3nRl3vGAUS10wIE6bTRbda90UQKF18/GUVn0GmJnKSjSsEeyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDazObDvJl7BrqkMxngEjC8LOaIIHVDY1NlsELtdVe8=;
 b=iaXtPLchG2Na/z+rhjiQ9pkjY92/50zpL5mtcVDdW2Z1HgCkk+EUhBdS4ROJzMlti92DYMPRcEM8+WN5Hf2NdtM8tMiuoEimWO+wHBOgE89IAeONXQL77ocBXA3OD3wf49IcXCfI/cRMscJY9xYt9KUqQ6knyisb7ObRq9xr/HZ88bj8Q4IIDDigCvAoJYsXPVzItOykQjeEpXt2EM1f12YFSD9Zlt2SUgGreS4eps9uAf4Vd8r4MjpZYttFBVQ3zYmN+j9m7w/EYFqckrOdD6HvycH/oSk8Qvxp7T+Nx2NP63Aj7eqsNhpMNZIaYr2ObUW7mzSHUHjITeOZd2qZIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by SJ0PR11MB4893.namprd11.prod.outlook.com (2603:10b6:a03:2ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 03:46:39 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 03:46:39 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>
CC: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
	<cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "Brandeburg@google.com" <Brandeburg@google.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbwgAAVVACAABAwAIAAMNEAgABhfVCAAGbfEIAADugAgAATvZCAAM4SAIAAWFPwgAANFgCAAB1pgIAAB41ggADEcICAA9Lr8A==
Date: Mon, 15 May 2023 03:46:39 +0000
Message-ID: <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
In-Reply-To: <20230512171702.923725-1-shakeelb@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|SJ0PR11MB4893:EE_
x-ms-office365-filtering-correlation-id: 23d821b7-e73c-444a-7ab5-08db54f6fd69
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v3lPoSALdFkPfHMu0BNwTFxgMHuBjnixosHXI+NXEr+ES/j/vaQmTyAA5g2gKUNWGCLFXT2TcGwczAI6DXsji6WzCeG9O2dvvKptHvfsVn4JVjiE/rEwJJIXjXFmcJM4fYNznWO8Wn92lRAcx/pUKEb9pNh/dkGylVidz65ChHNXOUBex7dK/3uV5vOJAirki3gxCtdN930hySXe1FSSjuYLH3lgaGjRvlPgmkwID2CucKPMyUCeflvGsZ3m09qHg+P6zTTXxpiUF/IVr4v+Y1phMbiavHY/DfIYlBWelKhOyRPssZ/RgZQUKYGfDMTf9w2IE+DCRMhbXaUyFFvIrrCHHgZRdimu1R2XECROZXrNnDh6Yvod0KS70tubTPKMRC7YqUH/7mqele0wrY1X/240hOgXzXZzflV2wzcFZAk8j0Yy2NA5KYe3kGAihLOy6YveZqT3B7BOUBgHNz6hx8hr0dCoC4pmnSxMgbwbUF6JaWg1kR4lWa+OTel8IL0wt29fBBwlJ9+Ha1+fhFaeFzvcLvxFO9PUABrZVKgxwYyimeZbfE5FmGGsL9u1+/iFC/om4vD/9KGFJHkM8bvQPx1vPpJDK1vUCwEjyBGWPQav6VRTGO6HufkVTol+W+Yb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199021)(66446008)(64756008)(66556008)(66476007)(66946007)(41300700001)(76116006)(6916009)(4326008)(82960400001)(33656002)(71200400001)(6506007)(26005)(7696005)(38100700002)(122000001)(316002)(38070700005)(7416002)(52536014)(5660300002)(83380400001)(8936002)(8676002)(2906002)(478600001)(54906003)(86362001)(55016003)(186003)(53546011)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0xzS0NHOUo0bzhIMGdMSEYyOHVrU0ZyT1c2ODlYazNxSlk4NTZhUlZFbHF2?=
 =?utf-8?B?T2NOa0tzZ1BtYUdtdVQvMGZsR1lKTElsOUUzQktubk51U1YzWERxK1FJMjRj?=
 =?utf-8?B?aVJvSEdRRml5RkN3c2RTSWtVMXgvRHFFRGw3TmRISklPUEdQZ3duTWZVL2VC?=
 =?utf-8?B?SjBXemtpRXREWVIzMmV5YjcxT1VtNFhvLzZmZ01mN2NuTFBuZlE1cU00ZGN4?=
 =?utf-8?B?aWVCSE03eGVsVEx3MTEwaVZ0dnM5dXMxQ050ZC9XcnZJTTQ3ZFg0b2NnNVhy?=
 =?utf-8?B?eVljcXhrRSsxdGNxMnlFNlF2eklRWDJReTNWcUlCSjBac3Ftd1lvK1M2UW9m?=
 =?utf-8?B?NXJxRFVuNnR3eTU4dlBIWE9wZUxMbzhtZWlaZmxWU2hKNUM3c1BCQk9FZmUz?=
 =?utf-8?B?alFlL0hWUnJvUE40ZFI4bWpXdzI2SXFMNWxPS09xWUQ2SVduZS9qdzdnK3hC?=
 =?utf-8?B?Ukx1ZlNqS2hFSWg1WE1wNlloaGc0N3BKVkJGYkowa2k1ZVJ5ZndSUTMraWFz?=
 =?utf-8?B?UEtISWxaaCtNRGtjb1c2SnRJdnc0THRVZWcrN0FLMnZUWndVaDJ6cEwvWkRN?=
 =?utf-8?B?czFFSGpCM1FDWExVcmJSQzVQVmJibjk0ei85MlBzaVkvZmdWL2FMd2JKSkdT?=
 =?utf-8?B?VVkzaHZhOW5EbE9ENytaR2U5QXVPby83c1lFOEtTc200aUg2VmFhd0pzOFVN?=
 =?utf-8?B?U1lFbldsM1g4ZlJtZU5UOHN5Z0EvdjF5MFh6andQcXNSQVZSOHdTL0F4OWlq?=
 =?utf-8?B?SFFFc1JtSHh5LzR5U3NneFpoZ2xFOTdpbkpqQnNvQytRU0xtQXMrd2lZQTVS?=
 =?utf-8?B?Smg2UGNiVG1sSG43UlJyeHJRT2U0TmhLUTBmcHZLOFZBeWlrYy9iaGNvMGNt?=
 =?utf-8?B?LzArTldIT1N6VjNtM2ZXSVN2VEJzV3N3L2hVclprcnE4SVVTaFlZbGZsVWlZ?=
 =?utf-8?B?WVZSc3RCUllhUytaRlpuTHo1cTd1aURuNHJGbHlkQzl5V0VJVmNhaHZyMEZO?=
 =?utf-8?B?U1prYlJwQTNTaHcwT1B3b2xiMHlvT0JRblRJUDZDeU4wTm4wZlFDd3ZUYXlX?=
 =?utf-8?B?M0JtZCtkSXhLQUlLZDRNamxWOWh3b0VUTkcrRlB5bGtTWGlzVmc2cTRrTFFz?=
 =?utf-8?B?WU9vMjZuZTkrMURobjltbFp3aVFLdDVpc1RTZFhUMnhoZzdNNmQ2S01sY0xr?=
 =?utf-8?B?YS9HbkhWMlFNMDdRaUJmSkFUa3ZxS1g4cHJFdW1zOGlTTTN5ZE5lRjJBUHQx?=
 =?utf-8?B?dU5PRlhsTFhaWmF5TEppRkdmams4UUZTaUdjSEVHWW9abFdIRlhzN0w3YlM1?=
 =?utf-8?B?dExCa1h0WHcyVHo5U014N2Z2VjRkcXYxREZvWnBFSzkrK2U4WE5Ed3BxODJK?=
 =?utf-8?B?RkNFQ3dES3BOQS9kZEUzK1pvYlZVZzJadUdVa3haU1hvRFVjbmNLNlZDUDRF?=
 =?utf-8?B?WHFhcUs0aHRVRlg3bGI2L05FQytaMEFrYTJVeVVWckthVXEweFpqWXUvQXQ3?=
 =?utf-8?B?NUZmRlZ6WWhSNWJlYzJoTkFrdXRaNGxzMVd4ZmtHNHRySkRVY29NNmZqdDZQ?=
 =?utf-8?B?Tkd5MGRzQ0lEUXRPTi9BRjVCN3BERGU3ak9HUGh1SytSVU9QS2ZDVk14S2hX?=
 =?utf-8?B?bFBKRFd5OWZ3VnlhR2VxQ3dhZVlDTkp0VS8zSVlHTVV2RXNPMElSWEQ1S2JI?=
 =?utf-8?B?RUlDdXBrU0dwcTdkelVScXBZWXZwVFRENE9CU1lWVjBnRFFIaHltYkI0d1Fw?=
 =?utf-8?B?cVNiWUE5NGVGVnI0ZHJYRnBNZktMYUsrSXlTQUVNV2orcTRTdmhqaWZSMCtL?=
 =?utf-8?B?c3NUMjU2TUs0aERJa0hMelh5OVNBTHpWQkpkSXNnZVd5Y1JKdDZxY3Vib3Zj?=
 =?utf-8?B?bXZrYkdlbUhjSlNZc3ZhT1VsYko5QWVoWGVTQ1l5YWZCWlNydW5KYlhaSGtP?=
 =?utf-8?B?am1LaVBUYUdHdHkwZHNYblZDR2Y1dkFaNXN1dXl0bFJ3OTd3RzU1dXVrcWtl?=
 =?utf-8?B?VExiUm1kYTRuZy9ocjZKMTRnZlhaR1BNODdLUFVIa01WYTQ5SzhLdGoyLzFY?=
 =?utf-8?B?QU1YVmRXUm8vaEs5Y1Q1V29rRi92NFZvODZPM1JJY1JaMFdVUWp4YThOakhB?=
 =?utf-8?Q?K7RUZ9s+yyfJGrPiFWCghxwor?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d821b7-e73c-444a-7ab5-08db54f6fd69
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 03:46:39.3208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +PpQUAVB+EmxnjPviFmwAXE4GlqL9oRFuXA1IBVFEl0cofgTO0a1iRFtR4e28D3BY6vIXRDpmAadRVDCyHyGJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4893
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hha2VlbCBCdXR0IDxz
aGFrZWVsYkBnb29nbGUuY29tPg0KPiBTZW50OiBTYXR1cmRheSwgTWF5IDEzLCAyMDIzIDE6MTcg
QU0NCj4gVG86IFpoYW5nLCBDYXRoeSA8Y2F0aHkuemhhbmdAaW50ZWwuY29tPg0KPiBDYzogU2hh
a2VlbCBCdXR0IDxzaGFrZWVsYkBnb29nbGUuY29tPjsgRXJpYyBEdW1hemV0DQo+IDxlZHVtYXpl
dEBnb29nbGUuY29tPjsgTGludXggTU0gPGxpbnV4LW1tQGt2YWNrLm9yZz47IENncm91cHMNCj4g
PGNncm91cHNAdmdlci5rZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29t
PjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBCcmFuZGVidXJnQGdv
b2dsZS5jb207DQo+IEJyYW5kZWJ1cmcsIEplc3NlIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNv
bT47IFNyaW5pdmFzLCBTdXJlc2gNCj4gPHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBDaGVu
LCBUaW0gQyA8dGltLmMuY2hlbkBpbnRlbC5jb20+OyBZb3UsDQo+IExpemhlbiA8bGl6aGVuLnlv
dUBpbnRlbC5jb20+OyBlcmljLmR1bWF6ZXRAZ21haWwuY29tOw0KPiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2st
PnNrX2ZvcndhcmRfYWxsb2MgYXMgYSBwcm9wZXINCj4gc2l6ZQ0KPiANCj4gT24gRnJpLCBNYXkg
MTIsIDIwMjMgYXQgMDU6NTE6NDBBTSArMDAwMCwgWmhhbmcsIENhdGh5IHdyb3RlOg0KPiA+DQo+
ID4NCj4gWy4uLl0NCj4gPiA+DQo+ID4gPiBUaGFua3MgYSBsb3QuIFRoaXMgdGVsbHMgdXMgdGhh
dCBvbmUgb3IgYm90aCBvZiBmb2xsb3dpbmcgc2NlbmFyaW9zDQo+ID4gPiBhcmUNCj4gPiA+IGhh
cHBlbmluZzoNCj4gPiA+DQo+ID4gPiAxLiBJbiB0aGUgc29mdGlycSByZWN2IHBhdGgsIHRoZSBr
ZXJuZWwgaXMgcHJvY2Vzc2luZyBwYWNrZXRzIGZyb20NCj4gPiA+IG11bHRpcGxlIG1lbWNncy4N
Cj4gPiA+DQo+ID4gPiAyLiBUaGUgcHJvY2VzcyBydW5uaW5nIG9uIHRoZSBDUFUgYmVsb25ncyB0
byBtZW1jZyB3aGljaCBpcw0KPiA+ID4gZGlmZmVyZW50IGZyb20gdGhlIG1lbWNncyB3aG9zZSBw
YWNrZXRzIGFyZSBiZWluZyByZWNlaXZlZCBvbiB0aGF0IENQVS4NCj4gPg0KPiA+IFRoYW5rcyBm
b3Igc2hhcmluZyB0aGUgcG9pbnRzLCBTaGFrZWVsISBJcyB0aGVyZSBhbnkgdHJhY2UgcmVjb3Jk
cyB5b3UNCj4gPiB3YW50IHRvIGNvbGxlY3Q/DQo+ID4NCj4gDQo+IENhbiB5b3UgcGxlYXNlIHRy
eSB0aGUgZm9sbG93aW5nIHBhdGNoIGFuZCBzZWUgaWYgdGhlcmUgaXMgYW55IGltcHJvdmVtZW50
Pw0KDQpIaSBTaGFrZWVsLA0KDQpUcnkgdGhlIGZvbGxvd2luZyBwYXRjaCwgdGhlIGRhdGEgb2Yg
J3BlcmYgdG9wJyBmcm9tIHN5c3RlbSB3aWRlIGluZGljYXRlcyB0aGF0DQp0aGUgb3ZlcmhlYWQg
b2YgcGFnZV9jb3VudGVyX2NhbmNlbCBpcyBkcm9wcGVkIGZyb20gMTUuNTIlIHRvIDQuODIlLg0K
DQpXaXRob3V0IHBhdGNoOg0KICAgIDE1LjUyJSAgW2tlcm5lbF0gICAgICAgICAgICBba10gcGFn
ZV9jb3VudGVyX2NhbmNlbA0KICAgIDEyLjMwJSAgW2tlcm5lbF0gICAgICAgICAgICBba10gcGFn
ZV9jb3VudGVyX3RyeV9jaGFyZ2UNCiAgICAxMS45NyUgIFtrZXJuZWxdICAgICAgICAgICAgW2td
IHRyeV9jaGFyZ2VfbWVtY2cNCg0KV2l0aCBwYXRjaDoNCiAgICAxMC42MyUgIFtrZXJuZWxdICAg
ICAgICAgICAgW2tdIHBhZ2VfY291bnRlcl90cnlfY2hhcmdlDQogICAgIDkuNDklICBba2VybmVs
XSAgICAgICAgICAgIFtrXSB0cnlfY2hhcmdlX21lbWNnDQogICAgIDQuODIlICBba2VybmVsXSAg
ICAgICAgICAgIFtrXSBwYWdlX2NvdW50ZXJfY2FuY2VsDQoNClRoZSBwYXRjaCBpcyBhcHBsaWVk
IG9uIHRoZSBsYXRlc3QgbmV0LW5leHQvbWFpbjoNCmJlZmNjMWZjZTU2NCAoInNmYzogZml4IHVz
ZS1hZnRlci1mcmVlIGluIGVmeF90Y19mbG93ZXJfcmVjb3JkX2VuY2FwX21hdGNoKCkiKQ0KDQo+
IA0KPiANCj4gRnJvbSA0OGViMjNjOGNiYjVkNmM2MDg2Mjk5YzhhNWFlNGIzNDg1Yzc5YThjIE1v
biBTZXAgMTcgMDA6MDA6MDANCj4gMjAwMQ0KPiBGcm9tOiBTaGFrZWVsIEJ1dHQgPHNoYWtlZWxi
QGdvb2dsZS5jb20+DQo+IERhdGU6IEZyaSwgMTIgTWF5IDIwMjMgMTc6MDQ6MzUgKzAwMDANCj4g
U3ViamVjdDogW1BBVENIXSBObyBiYXRjaCBjaGFyZ2UgaW4gaXJxIGNvbnRleHQNCj4gDQo+IC0t
LQ0KPiAgbW0vbWVtY29udHJvbC5jIHwgMyArKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9tbS9tZW1jb250cm9s
LmMgYi9tbS9tZW1jb250cm9sLmMgaW5kZXgNCj4gZDMxZmIxZTJjYjMzLi5mMTQ1M2ExNDBmYzgg
MTAwNjQ0DQo+IC0tLSBhL21tL21lbWNvbnRyb2wuYw0KPiArKysgYi9tbS9tZW1jb250cm9sLmMN
Cj4gQEAgLTI2NTIsNyArMjY1Miw4IEBAIHZvaWQgbWVtX2Nncm91cF9oYW5kbGVfb3Zlcl9oaWdo
KHZvaWQpICBzdGF0aWMNCj4gaW50IHRyeV9jaGFyZ2VfbWVtY2coc3RydWN0IG1lbV9jZ3JvdXAg
Km1lbWNnLCBnZnBfdCBnZnBfbWFzaywNCj4gIAkJCXVuc2lnbmVkIGludCBucl9wYWdlcykNCj4g
IHsNCj4gLQl1bnNpZ25lZCBpbnQgYmF0Y2ggPSBtYXgoTUVNQ0dfQ0hBUkdFX0JBVENILCBucl9w
YWdlcyk7DQo+ICsJdW5zaWduZWQgaW50IGJhdGNoID0gaW5fdGFzaygpID8NCj4gKwkJbWF4KE1F
TUNHX0NIQVJHRV9CQVRDSCwgbnJfcGFnZXMpIDogbnJfcGFnZXM7DQo+ICAJaW50IG5yX3JldHJp
ZXMgPSBNQVhfUkVDTEFJTV9SRVRSSUVTOw0KPiAgCXN0cnVjdCBtZW1fY2dyb3VwICptZW1fb3Zl
cl9saW1pdDsNCj4gIAlzdHJ1Y3QgcGFnZV9jb3VudGVyICpjb3VudGVyOw0KPiAtLQ0KPiAyLjQw
LjEuNjA2LmdhNGIxYjEyOGQ2LWdvb2cNCg0K

