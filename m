Return-Path: <netdev+bounces-1289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F5066FD31C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 01:46:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0242B281262
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4779B168A2;
	Tue,  9 May 2023 23:46:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354811990C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 23:46:18 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F3A2720
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 16:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683675976; x=1715211976;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QOFTHuVyhuocrmkfizxWjkjY+DFxxclYoQtkF/SYJXE=;
  b=mDAV0qaOubYL92amVR1tgxBsxtOZfrnIY6o77QJMbKIoRbXcPozIzR0k
   Of0mXy1HtKv2zWvTTJESDrGZWk4yecKtSXOyrxEWX6ndSg58EWO4me/wg
   CA/V9BI21I8TXbQ7APQy/4UFIWKJeK5VKivn2eWP7hod7d8IxQPfKDfor
   V0hysesNadX683MfkyJOQG5u8dOh08BNHmUEX1/zo7OSqu825qSCOFVP2
   l91Es8MzMMnCDVE06PSUJ1tnNuYekF/02MFnFyrhQBhE3dSe4cpasdBRd
   uTWSBemB2PbXp8n4pj4/XRLHNsteEtHHdlTpsVlXirf7JThRTGC1CLjvV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="350118573"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="350118573"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 16:46:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="945473296"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="945473296"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 09 May 2023 16:46:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 16:46:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 16:46:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 16:46:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrEWzsqL19bDUnnq4TWcUyFPNnwFbaaPDx3RRa1NW5l4azq+VZO+zLBoNqlGwnrg+qcf3LhGJiuo94eBzzeNnE81bJILSuD/MnIUuNKCaznb5TvTOy0sX7SgIPs8dAgg6tXhWSAEbcV8yyYCg+QzQYJHXGDfbZimEMAiTOqpMwpyfmD0HXsjNWMy+ESf7cU++WWGsjSuFqfmW8R0VvkD95m7XCGHrLldC+SsVMwhNhicDb30gzR29lfVioBMi3zybJbnjaTMbjaBuwSGOUPeGnytQqTFN290jqildVPJ0Bf5JcKvkPmRRvQGE9G+fUdjSBV15FqFfMXT3wnq/4TfKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DoElZ7dFmziKAyKKpWvotJlbD/yCTownNJ88UaAPTZ0=;
 b=kFOaJQtudDuEpEA/PWvgQ+tjGTyDkvo1B1k8BqWDP3ixEKJ4siA4jEetFbF3oWUTqaqkAzqwVokwbLB48x0U46+BPy0KEhXt1LMZssgOb2CptXdWOP6UbUG0RuS+W9m9bhK02RSg7mCbLVFAQB93gvbgzem7zwmT1fFvNOqIrJE/HS7OcpedazF8IpVAqJGdNwbYmK4EApoLxWyucr+h83Pl7rXioAyxMHz2Dtz13jMo+pY0go8vhxCp/J55VlIFub6rYxrqdocjxB4AM81yp3KmLq7CDoKUvE7JAhFUJNamn2EIFlJE2VB1wmSO3bcY16p5FNaYD4WEUoKhGAK2og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CH3PR11MB7867.namprd11.prod.outlook.com (2603:10b6:610:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 23:46:04 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00%4]) with mapi id 15.20.6387.018; Tue, 9 May 2023
 23:46:04 +0000
Message-ID: <5ec678c0-9f4b-3d38-a0d8-700b5668e9c4@intel.com>
Date: Tue, 9 May 2023 16:46:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [PATCH] net: stmmac: Initialize MAC_ONEUS_TIC_COUNTER register
Content-Language: en-US
To: Marek Vasut <marex@denx.de>, <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Alexandre Torgue
	<alexandre.torgue@foss.st.com>, Eric Dumazet <edumazet@google.com>,
	"Francesco Dolcini" <francesco.dolcini@toradex.com>, Giuseppe Cavallaro
	<peppe.cavallaro@st.com>, Harald Seiler <hws@denx.de>, Jakub Kicinski
	<kuba@kernel.org>, Jose Abreu <joabreu@synopsys.com>, Marcel Ziswiler
	<marcel.ziswiler@toradex.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-stm32@st-md-mailman.stormreply.com>
References: <20230506235845.246105-1-marex@denx.de>
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230506235845.246105-1-marex@denx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::15) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|CH3PR11MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b7b0206-5715-4bf0-690f-08db50e78d2d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7h6f83vvxcXEDqR47znQf6+9usGsArZAH08bMnM7okkyfZ6XfDE9UdFsjms9siRQpcfmDt83p44VB1YhDPHinCOwxs9rArZNi7kGhlDDnhOcWHhjCdDKsguPlq2VQ7w3ISvLiZxQqPBr/Jyg1sFfknFy5fH00eq5sPfIBWpo4wWKqZf0zoxzs+VigB9pAcZOC//clJsckuw4bSVzXST+voDevBAPZ4CriuwcjxV+2A/7DbgVn9Do0eWJCnL1RFL6lVdRoV3FOXA9tH4Kk3Vmgt6M5K1O1Y1TzD2r1A7XjQ6yC8UK9kLFFn38nAe42eN3YUtI+J67rK0OOLGILy8Sgn8YzoQLDpg0vMk+XtEtQAjskUbDaBLvjyvh44By+5EzRocWZIDwnWQbjNgCglBavi7WY/vFi38zXWYd8QqhR1CgHzM9/jJtjsgH7LK1gSCUGlqbLh3Z8BSx5JcI8+eA8uB846MQFQBG9F1Y8blesWYA4/8znqub5Xu+7cYSjBHWekS23w+6N3qyiVI6EAI3kKZL11KO0uSTF/7vBfLPWeTTN8xFNdtLWuIbtaijyo+7psob7honMHG6jBlsxGa6vXxMmZis/exBV2D+eEMvOHDVAdHPu2dpsseczPjHQUfd3TFZrkksyYMv5dJdaDOQDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(31686004)(82960400001)(36756003)(41300700001)(2906002)(86362001)(31696002)(44832011)(7416002)(38100700002)(5660300002)(8676002)(8936002)(66476007)(4326008)(478600001)(83380400001)(66946007)(316002)(53546011)(186003)(26005)(6506007)(6512007)(54906003)(66556008)(6486002)(6666004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THV3cUptdTBicGFOMm5lekxXY0Z3Y1Z4bWhFN0RjYXBrWlZGSzBTQ2Y4OGNW?=
 =?utf-8?B?aXNMLzUzaUU0ejcrZmU1WmRUY3l5eFNEUnpCdXFnUk1DUjZzSXdCRkJ1a0hk?=
 =?utf-8?B?bWtBQ0NGV044WlZUcTJTd3E3dlNWclI0S0ZTUkJSVUUweFFDSytlQ0xmenRJ?=
 =?utf-8?B?SnAzR2lkNGRoTjRrZER4eFovcURHb29sSllTNUY5OXBuUEx6aXo2MDNhLzRp?=
 =?utf-8?B?NXgxeTRPVmZoWG1SamRSYlZTR21MMldZTkliZXplM0huVnF4N1ZFK29NNm84?=
 =?utf-8?B?MFlaNCthbTA5d0dpSmhBUFc4R0hiTDErZFFmcjdLazdZNDZJeFE1Z1BUbitz?=
 =?utf-8?B?TzB2MHMzNGtaOWc4TGcrNnBCQ1dNVHBYa1FoQUE2dTN4bGJMblhuSjJBOG1i?=
 =?utf-8?B?NUUvazdWc0EwWi84cFQxOUZ3TjBmT3c0Sm4yUHBhVzYwOGZrMHIraEQvT2py?=
 =?utf-8?B?OTdZOUxCVTdDK2t5dXNLRmIwN0ZvUHZHb3l6T1h4aWpKRUkzb3Y3VWRVamFH?=
 =?utf-8?B?bVdNY0lPM2UwcEJQejlwZ3AyVExLRXU5Z2kwRmlkbHBFYWhPMkJ1Q2YyeW16?=
 =?utf-8?B?QjhicVc5K3ZIQ2VZakQwM0cvU2RoK0ZTenFaVldoVi9adXlBTndyc2tXVTBm?=
 =?utf-8?B?VjhheGl3N0FBdjZsSSthWnZqeWg5bWdQZUkrL2tKbitaR3dQNjZDOXlOemVR?=
 =?utf-8?B?clJkRGpRZjNGWWgzVnhyOWhHQUxPM0dJbVhYeTBWekxzV3puRlhIbkc5VldW?=
 =?utf-8?B?NWZNT1hWMmxpQ1JHWDA4eitTbWFTd01YUjY1Z0xxV2oyV01vSHZ2YjQ5ZjdW?=
 =?utf-8?B?dFdUblM5VzdwQ0kzMVFDQkNyTTVqcENvSXBuR3F1OExtYjJ3aHBuKy9ZbFJF?=
 =?utf-8?B?Zks2Z1lMcUtoVzlrcXluVGJPOURuS20zUWZWbVM0OGRHcjRDUE16NGRLTzJN?=
 =?utf-8?B?Tk01YlhBUmZqVnBSUm84a1l0dVJ2Y3c2ZEtWaDhPbHVRTnUzeW9VZW1aWlR6?=
 =?utf-8?B?QW91Y0lNMWpYRll2K3c5VEsyZGdSY2JlMDZpUzNtdWpycndQaE5XSXd6eDFS?=
 =?utf-8?B?ZjhwVXYyU21LRW0zRUlpT0p3SFVwNnA5QVFpekJvOWl6U1FxeXBzMFdlQXNU?=
 =?utf-8?B?NWhqdzNDbENGWE1IV0JUb0diUGxPcUpaTjRwU2xOSDVHU2YwQ3pjUFpVVTAy?=
 =?utf-8?B?aWFWWnRlVkR0cDRCSDhDamIwcHN2UTBvNHE4MUdZRWpjVVFaczM0TXJUck9o?=
 =?utf-8?B?ZWRkZmtJY25iVm51U0h2akNpR05lbjVBWkRJMVY0Mllua2dmcnF0aVg3K2Nu?=
 =?utf-8?B?Mm5nbFhkSHhTQnhtZXFvS3QzcnVVQzFwMUszOWl6Z2RUemtOa00ydUVPL2F3?=
 =?utf-8?B?dURHWXVoSjNiRStqaW1UVHhWNi80RUNyaWVmUmhmRU5lY3FLZWVUSGJBNU5j?=
 =?utf-8?B?WjNmUlJ1RTRLUzhQYmo2ZXZrNGRISGMrR3RKSGxSK3gvK1ZPNHczaUhtazN2?=
 =?utf-8?B?MWYxQTExZVFuY294Qmg2S0QrVzRIeWNXUmtZcjYvSElBMkh1VTQ3K2xpRG13?=
 =?utf-8?B?aDhTRjFtSFpEUVl3WGlzSnlZUkZVdFUwZFlKRTJBUlF1RVZKUUJQYmxlNnBv?=
 =?utf-8?B?RnVMVUY2Ym5relAxVm9Id1l1WDZOQTFIdXhTc3gzcy9BODY4T1FnTUdjNU5U?=
 =?utf-8?B?TGFtaGRMUWJyK1ZOb2dGMWlhN1RyY3QrdW02K0d3MGFwd3EwTkJLWHlvTmFM?=
 =?utf-8?B?RklWcUxqdzhtZVl2VENyYjlGWEg3K3d3VkhwMGFra0duTEQrSUQwSEFNall5?=
 =?utf-8?B?TWVTU2hzNDdkdmhNZTJIY2pJbTFxSkRMc242OUJFdUxVTWM3ekVFaUZySkdZ?=
 =?utf-8?B?aEZrL3VrL2JYZk9XTWdxL2tqZTZ1YjZ6MmhYdVNOUXAvL0ZBcEZ4M1gzUjBZ?=
 =?utf-8?B?VkVkZ1VGbiszVHA3MG15a2hFcStOL2Q1UnlGSm1oM1RFMjR6Q1Z4bjNBaENF?=
 =?utf-8?B?aW9BQldJTWdkUmRtRDcyTy9JZ2ZXWklxYXFEbHFZNEl6WUc4OG4xWDM2MmpF?=
 =?utf-8?B?V0ptSDZoYVFGTWgwRFRZVTlicG9FRHk5cEJIaWpHTzcxc2ZNTkpWaUNRcnE2?=
 =?utf-8?B?SE5JTGY1MTRVWTFaS01Rb1drdkVCc01WbHpZMWt3ODN5UXJhK0daV0UrM3B6?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b7b0206-5715-4bf0-690f-08db50e78d2d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 23:46:04.2241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZbilgUS2ciKty6UGyPP9EwWOBF/KVoC/gdRF4ahGlFQ9AjXxiD51/XBZMpbQyBaw0hniRNfdB0AGUnSXkpGq24225UPPMFubyW7etYTN6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7867
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/6/2023 4:58 PM, Marek Vasut wrote:
> Initialize MAC_ONEUS_TIC_COUNTER register with correct value derived
> from CSR clock, otherwise EEE is unstable on at least NXP i.MX8M Plus
> and Micrel KSZ9131RNX PHY, to the point where not even ARP request can
> be sent out.
> 
> i.MX 8M Plus Applications Processor Reference Manual, Rev. 1, 06/2021
> 11.7.6.1.34 One-microsecond Reference Timer (MAC_ONEUS_TIC_COUNTER)
> defines this register as:
> "
> This register controls the generation of the Reference time (1 microsecond
> tic) for all the LPI timers. This timer has to be programmed by the software
> initially.
> ...
> The application must program this counter so that the number of clock cycles
> of CSR clock is 1us. (Subtract 1 from the value before programming).
> For example if the CSR clock is 100MHz then this field needs to be programmed
> to value 100 - 1 = 99 (which is 0x63).
> This is required to generate the 1US events that are used to update some of
> the EEE related counters.
> "
> 
> The reset value is 0x63 on i.MX8M Plus, which means expected CSR clock are
> 100 MHz. However, the i.MX8M Plus "enet_qos_root_clk" are 266 MHz instead,
> which means the LPI timers reach their count much sooner on this platform.
> 
> This is visible using a scope by monitoring e.g. exit from LPI mode on TX_CTL
> line from MAC to PHY. This should take 30us per STMMAC_DEFAULT_TWT_LS setting,
> during which the TX_CTL line transitions from tristate to low, and 30 us later
> from low to high. On i.MX8M Plus, this transition takes 11 us, which matches
> the 30us * 100/266 formula for misconfigured MAC_ONEUS_TIC_COUNTER register.
> 
> Configure MAC_ONEUS_TIC_COUNTER based on CSR clock, so that the LPI timers
> have correct 1us reference. This then fixes EEE on i.MX8M Plus with Micrel
> KSZ9131RNX PHY.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Patch and commit message look good to me.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>



