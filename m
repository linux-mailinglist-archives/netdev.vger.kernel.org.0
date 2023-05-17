Return-Path: <netdev+bounces-3471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E9FA707537
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 00:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BA2D1C2100C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D0610954;
	Wed, 17 May 2023 22:20:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672BAC8C0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 22:20:03 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482F440CE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684362002; x=1715898002;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UU6AyYeMjkgrg15+tcUSt6N6DfDfEMeTgEva+dl5H7Q=;
  b=by94EuOSw/z2dsZi27wWrl1aTkJ5lvrx9CTYc2XxtWu/141RB0DbrOHP
   FN/CYxy5ZXagsKwCP6nE5+SmXZEuRydzLRZRn+rP13TNFYFLi9aRjMPBW
   Kj9kjGJmj3QLkLq/tS8ns3ynSmFpxW9LRttYTecyszy1hEyNmmGA5bfX0
   lCSrWZW0zsIv0ZzcUAJrL4OZXBBYA6IsmVrAkDCF04xupcKZLoXA0W8+J
   gRcPBEucwrBMJkNr2Gu091hw5sIt8JJcNHXbGqZD0AZZNS9p35Wpjv46u
   FdXfqfvXE918rT4hA1gVG1JF6X2MiFzYDyp7r482QywPXlcQmxVBCo4K0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="380093492"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="380093492"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 15:20:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="704969261"
X-IronPort-AV: E=Sophos;i="5.99,283,1677571200"; 
   d="scan'208";a="704969261"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 17 May 2023 15:20:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 15:20:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 15:20:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 17 May 2023 15:20:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 17 May 2023 15:20:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+KUwUhXO4CFPu2JSZDC2tzbWzs8ys8LXNJkrQG7ROIqgbOeXlltTVkC72Ke2Nkm8Dyry9e8oAO3kzsmYj83+fI6yQt0L4Njj76hNSpYvWFHCUoUmPoomVxFY7OlS3XWyRJtdA4BUsB3CrnSqTxPKT5VGmazEHznLuufL/Jj/z7XkKkbUIZfMyCUNdQefaGcaI4pGS5JQSw8h944dC6Frt22yTczrtBtjKJfIqti5ElV3wJGgqQAnxG3jRGPE0u0J7gW4MQiHI92myTpJR6ls4BHyvGcTw3xUUNhYU22pysQkZDs21DGwouTMtTmlCYXRD9i2MaBiBaapQTra5iZTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9+iEYKbmTFIDgn79AlN4LVjt3DBXLSLaXDtyNXSDHY=;
 b=N8VgC+yXkxyJlz3COZSpNBujTWewMC4U9lp40oCq3gjaaDv1wfHoFWOdTOwD6rGXg5b2wprjaPcPSUTDep31jCSj1rBAknT28UNYVh73+TI9zwMxFW1rKUXTCZQYPYUO9ls/1/KuR1403VpNU2EaFqjtpcXys50AWd645s6I/VnCuSx1sNgC3GxKEIjaWYQbyK7n195Gok9md9o82i9h2CnOGVVATCPNz0NanbXBcwfMH9fFzOwIR3PUsGYQgU9OJiCbAR4HqrzA52JiQoxCHh9OFDYekk9tHG7YTrNvLrQ2muDEhbWQ677wyBZy/+QxHH2djcgsJXswPiManEzrgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB6846.namprd11.prod.outlook.com (2603:10b6:806:2b0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Wed, 17 May
 2023 22:19:58 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584%5]) with mapi id 15.20.6387.032; Wed, 17 May 2023
 22:19:57 +0000
Message-ID: <83746b5b-0571-d1ec-b812-908a11502ac0@intel.com>
Date: Wed, 17 May 2023 15:19:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Vladimir Oltean
	<vladimir.oltean@nxp.com>
CC: =?UTF-8?Q?K=c3=b6ry_Maincent?= <kory.maincent@bootlin.com>,
	<netdev@vger.kernel.org>, <glipus@gmail.com>,
	<maxime.chevallier@bootlin.com>, <vadim.fedorenko@linux.dev>,
	<richardcochran@gmail.com>, <gerhard@engleder-embedded.com>,
	<thomas.petazzoni@bootlin.com>, <krzysztof.kozlowski+dt@linaro.org>,
	<robh+dt@kernel.org>, <linux@armlinux.org.uk>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230429175807.wf3zhjbpa4swupzc@skbuf>
 <20230502130525.02ade4a8@kmaincent-XPS-13-7390>
 <20230511134807.v4u3ofn6jvgphqco@skbuf> <20230511083620.15203ebe@kernel.org>
 <20230511155640.3nqanqpczz5xwxae@skbuf> <20230511092539.5bbc7c6a@kernel.org>
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230511092539.5bbc7c6a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0176.namprd03.prod.outlook.com
 (2603:10b6:a03:338::31) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB6846:EE_
X-MS-Office365-Filtering-Correlation-Id: 11372b94-e724-445a-1629-08db5724d501
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qr0fT51VEI/xicz5ieiD1Gm93AY4SwPhn0wrx3h0S5CLpe7ltVrVMpphu3qDVu4X3I0taYIXPFwADjYqkd+nSkBqH/hbGQR1AIeOcuTv+rXBYdMISDL11LCLe5wno5CUxC03p5zatEUq1H9VP6+QHAY/OSD6BdgJ/7cOVSvudNlK7NOBqTMAzNKzkueA46xXV/pB2DFfyAPbdlPLb66OTuWi5NyHj3PR2qJOt16i7z953gSmI+cmrfYAX5v6Ry/ad0QoclHqQO2ZDLGiYEjylofdWIwAcVskoz6zWT9TTm2xt3HYkBAzAd6AmIhyMGgyrJuR7znutGyd1HDAtKV/5IpQVgqEGmZnduAFWxTj5Qo4HMq8himkD8qdilMrHPpgHHNDdSwHZPj6p13Xish0BDWQUtVHSQMfnkKhGMZIYjZGFBFPgwovpAtTogbb3IBISBO6bQQWB5UhoJa6fVzPI/TQlK7dikBP7sdW+IN//1azzB65MhAqAroyBN0WqDfBRLXAnt1FlaNtRsSNAHuQ6I8mjyQQTI7+o481I7TynILuGWGPgmI4GetYC/lUoVEeEwLSGXa/7vWp8rsPWsw9NFyh4pUOzP8MM+Mf6TjcO6vdMOq6c0TslsjMglYK30mZzRTx9JPm0C4JgkDwgLBLpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199021)(8676002)(6666004)(8936002)(82960400001)(66556008)(66476007)(316002)(66946007)(4326008)(478600001)(110136005)(41300700001)(38100700002)(6512007)(4744005)(2616005)(186003)(36756003)(6506007)(53546011)(26005)(83380400001)(31686004)(31696002)(86362001)(7416002)(6486002)(5660300002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGtBcWZqZTk4WlJ0VWhGc1llV0ZvK0xQa2lOOGR0S2dyS0N4Y0hrOTNOYW5M?=
 =?utf-8?B?dEgvcGJYekhIYjh1dEN1aVJrUkhnVGdZUTJIVnNpcjJsSWdoMFZPUkRvbHV3?=
 =?utf-8?B?ZU5Bcnd6M3Y3ODlSckFpbzNjQk5URUxWcXNqRWk3YU8rSmxkQVF1WU5jUkNj?=
 =?utf-8?B?SlBhRDVNTnltSFcrYkt2QlR6aTg0ZG01VHk1eGZzQW8zVHJubG5kektVeE1L?=
 =?utf-8?B?T2QvY1NTaTY3NEs5R3BPcUZRVEJ5Rld0RHk4dSsrVUg4cE5kMUlHUVJPVDVn?=
 =?utf-8?B?bGlxYUNEaHdYOEVOc3U4ZStMdW9CeXMwZzdUNXlNLzV0U0FGRE1EY3FQL2ZL?=
 =?utf-8?B?cU14d0tvTG1MaFRTeTRGa3EwTkgyTzRKejE5RzQwK1Y0eFkyaXFmV3laaTho?=
 =?utf-8?B?WWo0bU9oaVFoVFAzUWRKQzVWd2lvUTQ1VlA0U0U1S0ZtTDJKcjg3VldXZWZP?=
 =?utf-8?B?NWljYUJtWWdPc0E3bzNDTUJGY0xZNEhvUTljMDlEdUVUM1BVcHY1TEt1UTUr?=
 =?utf-8?B?Nk5IOUhDb3U3VXZrTlozaURxazJIR3BQYXIyNFVPcWVJOFNxMEc3dmhHV1lh?=
 =?utf-8?B?UFhlalJZS2tDY3dIMUpCVWJ6WDcwWjNNdVgvK3NPTGxzL2M2NElobStNbEwy?=
 =?utf-8?B?ZmhqaWVSS1p3dTNkOGNGMzQwSUwveEdVaE9SajlsNktpVkI2MmhGK05LOUVr?=
 =?utf-8?B?dFdMRHdJRlVIbm9UNDVhMkpzelJXQXJJVFVJOTVnZ0FoSHlMeHZjVjFtUGp0?=
 =?utf-8?B?NGtORGdONEl2bW50VEVVb21JWFpQZlFuTDAvazRnWnk0TUtvNUNtMit0ZGxl?=
 =?utf-8?B?NktJczdDMnpHblNpa3greEFiYm9SUEpjMHljMUJUNjdwQWhXY3lyN0hWb2kz?=
 =?utf-8?B?ZmU4NmRIa0VqK2ZkMjRMTkZxd0RNTCs3ektQYTVmeXpCSzU2Nm14L0Y2VWc0?=
 =?utf-8?B?UUFLdVpGM2UxLzRRQytSc0IrYjN1UzdMMXZzWk90em82MmZUWDlPbCs4a0Jj?=
 =?utf-8?B?Tlh4aFNZK3J5S0ZMc0VOUkFlOXZHRU15M0J1dlR0NUV3Y1NGdjRqWTZOaVRk?=
 =?utf-8?B?L0t0anJicVo0RENVS0g1bVJ3V0V3QURiMDNhRzJBRHorV1Y1cTBwUzZLbGlT?=
 =?utf-8?B?SGxBanplK1NDUncybzlURXRrL0ZUWXdhY1ZyQk84cTR3SXQxZHBJSEVtS2w0?=
 =?utf-8?B?WExWelNDQkl5ek1QdTVyemw4SXBLU2lod05ZM254KzlpQ3dSYkZJUHFDZytW?=
 =?utf-8?B?blEyUmY1bG9Bc09rT0pQdWdMVjQvQ1pORS9SRnVqQWJhRnlCMVVRSlpXUjcv?=
 =?utf-8?B?OVJHcEhGRmU2SnRVTTB6UUFCYzBoZjN5bFFLTmhzSXBZY0w0clRRZW1Nd0l4?=
 =?utf-8?B?RHNmbnowTHp6ZVBHa2YxSitHUHNUUmVnc0pnekU4eTNvaGxQZjJvUEpTeFNl?=
 =?utf-8?B?cnc2QW1yVTEzY0I0bjIxWW1kdHVVTThlOU90UWlDT0diWFJzUmxZaEtFbW5m?=
 =?utf-8?B?T2d1SlRkd081c2hrSkx6WWpvWXU1TzVPNEQ1cWtISUdjRHNoamlXZGdKQ3pI?=
 =?utf-8?B?ZFBMVHZLSDFsTWRBZjJRT1VtcUdvZGJtUENhYWI2QkpURTJmMExRNWhCcTZ1?=
 =?utf-8?B?TGZ5eU90TDhVY1VQc2ZsSnZUUXNNcDlKbTJzU2Jkc010UEYyOWQySGtSOE5D?=
 =?utf-8?B?NDV3bTR2a0lyMDlWV2hZbVZFRDFKVDhUeXVxWEM4RXF0SG1SVVk0TndRMk1k?=
 =?utf-8?B?MU5UUU5KRkIxWlNaWHNncnpURURFalY1b2p5b2pmWE91d3NkVmh4STYrWDNu?=
 =?utf-8?B?a2x5aGhDZWhvQzNjWk41YjNPY3ZRK2F2UDhYWEN4KzlqSHQyV05sNW8xM05r?=
 =?utf-8?B?VTUzRzRrTXUxYW9nTlMrVGd4cE9lSExEaDlVcTA2alF3MUIwb0dLcDVOS3px?=
 =?utf-8?B?ZUVaT2tuM2ttdGFoT055Q202RnBQUFhXLzRXVXhTY3p4SkdTWk1kZ2VLMXNW?=
 =?utf-8?B?dkJGRXQyN1pZRWdiUXQ0SEVSdmxTeC91RkV2RDFkUXFxK1Q3UkZrbzFzYlI5?=
 =?utf-8?B?UEdVRnBWdkFvSGtrcm92M25vZWkvL0xtN0ZTN2tYb3pHZXN5TFJwSzErWmI2?=
 =?utf-8?B?STZ2N3RwcmlkOExUY053RlJjb1FzbzV5eTlvMWF2Y3Y5TTd3a01YUm1Ebys5?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11372b94-e724-445a-1629-08db5724d501
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 22:19:57.1768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rWRiiTLQUj+1jAwPcqrbZT77tKWcVWJ8jaaI7g04n4MFEzAA0MTDE3LUL/e9cvX+VGHhTbKtCXvnBTDUU0zf1Y5DQP89VB7I26dx4uurZxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6846
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/11/2023 9:25 AM, Jakub Kicinski wrote:
> So we need a bit somewhere (in ops? in some other struct? in output 
> of get_ts?) to let the driver declare that it wants to see all TS
> requests. (I've been using bits in ops, IDK if people find that
> repulsive or neat :))

+1 to using bits in ops for opt-in functionality. I like it.

