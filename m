Return-Path: <netdev+bounces-8946-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA374726612
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44F121C20E33
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C1273AE47;
	Wed,  7 Jun 2023 16:33:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DEF38CBE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:33:44 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060EF1FD5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686155621; x=1717691621;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YTHSAuTutDzopJcwgwAr0710KAsCnRX45xLjCHFvneE=;
  b=dYOfmCkXJeHIEb8XQO5s/jAExDEmxIeyulg5wxFkrlxip2XRBdb/QupT
   7EJoNdwXZKPnSAJK7i4iYlQrr9OvMRrwDLp5m3y+qPLaeJHswO0kgzmR0
   m8J/UmcV8YlbkyGAcnj5/xQx/l+Xd4Yf0hBdEX4L/3V2Z75sn48t1/dnV
   +QiXcOwR041iOtOCe/2v7u99g2s5EJvSrtX6y5K6VAet/XaWAmWXNfjhe
   9H+RFBa33WZ6PCKuW0zZY82uK77l4OWCJrdbY7X9hVQNBlsDa8dFxq/cx
   Lrl2xw9r7Ta8FPFS35XL+pQsUN7dyN+rv+3YZjHFxYxpmpF/dfXAUriXo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="354528817"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="354528817"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 09:33:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="853988906"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="853988906"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jun 2023 09:33:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 09:33:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 09:33:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 09:33:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBdKQIdar//GUKZffkS8amGrf0BS7D+ydxwuvIq7RNhl2Qw1ek2nMYfTJbKCrgUcfvXk2UGbH/SuKAStedhw1Io9XBS/FHb4s5hYVKffPATgt19I67Yg2MWEWVxtrZU7e+s9iVyKhX8fwRxS/+8BOh4s4kyIdZLbeciR8u7gmnRuExptA73sO/BfZnt38jbQWnngSoUjE761wQgqzPzmFtIHHIetKuhv/wMHETov3R1l7L7EmJ+nrmZhnLHrRuZX9WpLHfxwzaBwWDbzJvQcj9Ve31491TZgF7D8muxYSFAOfB1BPKCX+3+ZO8s7Uy4kKAEjcsOxGYmAMEVrxmGkyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiyG0+KYozxHAXP+T7w2ykL1JnF8h08ir5o25ryi49A=;
 b=eoqSHq97H92nuSQGpi3v3MvHDH+MI6VBjHAQ34Wb8Fhjd8OYggIIqSX9TQMeDu9Px4HzU8Om8LanBkUg4Xq37sz9bAyIYo55Xss2Ar7AJYEw8tXOBBLkKlAuzdBF5cXMn+Pa8AcTqNdvCGyMj3VzPk1HcvVAuVk18N+iFgoM68Yx9ea4f/8chHI72MhCQe0gU/M77CDQP3+vidS8y6WdRFPItksrpbS6FUfCk8HFmU/oR/oEJXWCAr2UN80lmzTOP7XyNDdU6dexsxJ8i01yh5YpWYqOaSBaiBKlUpsJOW6qwzCoAnY4G55XbEK3frHb7aXyXZKMUdXhvfKpQyx29g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH0PR11MB7615.namprd11.prod.outlook.com (2603:10b6:510:26e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 16:33:18 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 16:33:17 +0000
Message-ID: <73c192f9-59b6-77c5-922c-2222b660623f@intel.com>
Date: Wed, 7 Jun 2023 09:33:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 2/2] eth: ixgbe: fix the wake condition
To: Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
	<jesse.brandeburg@intel.com>
References: <20230607010826.960226-1-kuba@kernel.org>
 <20230607010826.960226-2-kuba@kernel.org>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230607010826.960226-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::16) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH0PR11MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a67295f-d85c-44d9-ac3d-08db6774e5f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xRXVmnSMNvKRZoxcinwsokXT/1m5/wFxDKE0L5b9gSLU5KroCg01Jts9bSQ+Vm8px3mN2Pvr2j0Tf9UyLFm78Mnm1VllimBoWebE2lkmvtBDmYpSm0hbbVi16luLkkY9I5eC54TkcM+ypIJuJ6A2VrNDSRmux6+rfo5Ts54mPIL12kVY4r6uYJ5ODGa8FC89rdRRL3hacKhkvgedH6LOyLjSEbSGCn4uNH1mVrT/BbNIYwMhz/0uh8t2UxrVuHII0CmgJM6wftmifN9h4c1mTi7ORN6KvITPyxwpsCrWeNAHswgCr0E6QRsqdMqf0kdD1AT6+uEmx0yBicWO96ALDnRPkGIFANJQkNq3oysMufhm0Y8bp8YsAmvm9hOhkrIaCh+Uq5GeHdXnTTwZUSL/GmQkVd+EJGnyrAQUrF8R1rABZOlFMiKQp4EdA01F4nJFlnEyjxy/R0aWZploevgeyGuUxKqQ930PppbjFiEMNGKFY5li+uXyrAnkQUodh5cpIeQfP5Wu9wrvlUH/iFLQWBhrbyANkZTBcNB8+TrQnFUIfP9OXjD+EW7bVCRWS3na38GHTENUytZ4PudT6bciTNMZebE6bCM6eUusN/FR3UZh11FyU6mxRKgZO4my5cBQ59OLvX2PDFqo0+rAg+DCiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199021)(36756003)(478600001)(5660300002)(6666004)(8936002)(8676002)(316002)(4326008)(66476007)(66556008)(66946007)(41300700001)(38100700002)(2906002)(4744005)(82960400001)(26005)(6506007)(6512007)(31696002)(107886003)(53546011)(86362001)(186003)(31686004)(2616005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3B4RUxZQTVpcTN4azlIRmNRaHFaMHdiT25leUpMS2dxeFI4Z2RoUU4zT0pU?=
 =?utf-8?B?dE96ZVV5YWJuQVN1Vlc3cUNvdGFHTHBXOWIxTXJOOTBHKy9jVDF5eUVwWVIx?=
 =?utf-8?B?N21rS3JaV3lPRjBndVA3QzhrQ2l5eDZhQ29ISFdtd0crN25OL0xsZ0dwZjRZ?=
 =?utf-8?B?M01YQ2pHdEhXeDBiK3hRT0RBdlFGTEVOSjJzM1NCWk5INVhSeWFDL1BNcGha?=
 =?utf-8?B?K1pCRDVzeVZ3SmY0VlhkTXlWMjNwenIzTGZmWE1jamVzam5RVWNBRFlLSy8x?=
 =?utf-8?B?alllWU81TmlScEJzME5vcjVVTExFUDlHNUFkRC9xNjg0ckNVaDArVTNJdXox?=
 =?utf-8?B?QjRMZWphbnRTRGdmVWdGWnlUTDV0d050S011czZ2U0VvV3ZoK2o1ZEFObUpz?=
 =?utf-8?B?L1RFK3VRcHQ5TXFWNXl0ekhVd3gvdmlMa1FaT2U5djNXZDNnR1pDaWZrb2N5?=
 =?utf-8?B?aGxmME5uNHVwYUxkU0ErOFJmejhFM0YxTXdpcERNblA0TjZaOW56VjVoS0Vw?=
 =?utf-8?B?SHc4WGV2QUdyazI0bGRyOWNlWkpWRVVWQm5UaDFEWWpiMTZpcDZoeUJxYllr?=
 =?utf-8?B?bEh4VEdqc3VQak1rY0NBcGlOcVZmY1A3UFBQdUtzYzdYazlGZnZBSjJsbG9z?=
 =?utf-8?B?ZE1hcGIycWpXczNlbjI4WmsrUi9zMXFBbnQ2d01uV1VQSkFTSTJNVzZwR0Ju?=
 =?utf-8?B?ajgwUTlYYytnQmIxMEZoRGxQSHRCbStoKzl0WEh3WVZtRkNQakc5QmlQZWZE?=
 =?utf-8?B?RE43a0VibVNZaTc1NHovUXYxZTY4ZFlVMFcrQTg4elNhQXJucWJOZGhyckg1?=
 =?utf-8?B?WjY4dW5reU54VmUrQzVWcisvTVNWRGYzU1dBNGpPd1JWZGJRVHZuWG5JaENk?=
 =?utf-8?B?dDBjMHRmeVlxUFdhdWw1T3c1UTVLdUp0d3ZLZ3hRSjlmU2dseGlsVVp2R1pm?=
 =?utf-8?B?dC9NL3NueTRNbHZWMnQveWlhdS9GM1FPb0hlN1pQSjhBdUYySnNJaHhDb0xz?=
 =?utf-8?B?TVJFdWNvZElUMldCeVo5SzQ1TGRuQW5Lbi9lUUVrQ1VjM0J6aGF1Z1BvQnAz?=
 =?utf-8?B?djVRekhSbTdCbFhUZG5FS2RiMjV5eko5M1RsYVNlRmZzdWZpQmIrZk92akZl?=
 =?utf-8?B?dXJucjZ3emFhRWtFOVJTSXFvN2lvMXNiQTVUdWJqbXhSblM3SU80YzFKYWNT?=
 =?utf-8?B?MVhoY2UxaDVzM3VreW5NNjA5YjRWUzlYUENYNzVGdGZKbTJVTkJ1NXZpbS8r?=
 =?utf-8?B?dEhYSnJvcEpCKzhqRzZHdTJqVE9Cemp4N1VLUFdhYkh6NWU0eFFzUmQ5U0Yx?=
 =?utf-8?B?dlFveFMxRXJ3NnZrVUVvL1YwZ0VyWTJYVHVxbXloVVpVYmJNTHUrODBrVHl1?=
 =?utf-8?B?akM4QWVuZmVnemc5MCtreGRBNndlMTFHTWhlbFVOZi9RbS9KQTdnVWJZQU1y?=
 =?utf-8?B?ZmlRSWF6bWJxaHNkakFIOVY0emVuajFPaW1JUE5lN1dzd1BYcXhuUWdLTVRw?=
 =?utf-8?B?bzVhRWhzM3pkWHI5Qkx1Z3luMnVxUjNJbk1ieFBYZ3F1aWFSTFFzUm14eDly?=
 =?utf-8?B?VEhhYTBuNGFWalFqWHJNY0l4M29mRG5YcGFiRXplcGVJS3FSNTRHOVlscTZz?=
 =?utf-8?B?WEJDNG12Uk80OXZBbHd2K0wyWDNuU2lwVDhQTHZtYXNDcXVZUm1yLzk4SlRS?=
 =?utf-8?B?aFBwcmdybVBnU1h5T3cwelFXQTQ2ZVhiNVVCSCsyeFE4ckQvbzkxTlRNZXVY?=
 =?utf-8?B?RHd5YXpsZ0IrOXZlZEliMW1nMGtCdk0vUlh0QjBzeDZJdG9RSHgrVUh1dlps?=
 =?utf-8?B?VzZlVWY3Rm5jQWxOMXJIZXhiOG5RejRyVEJZSEJCQXphUE8yNkZzM0tqQSs1?=
 =?utf-8?B?RVpnNXRYbXMrYmR3ZENPdk5rTk1UOVlQMCt4R3hsQkYvQmJONGpjQm10Y2ox?=
 =?utf-8?B?ZUxEWWRCUlBKZ1M2UHhzVkl4NW1lN1NnVWFWc2EyVC9ldE42TTlLQlpLYnpz?=
 =?utf-8?B?NGNVMUFGeDlOYm9LNEtGc1hKQk83L21acTV3V3ZZbXRIUTMwOUxneXVkeUtM?=
 =?utf-8?B?R0JKb3JpazQ5ZjBpQWw2MGNuakxTL2UzZ0lYTUx2QjRYN2dHV2ZOZHMwWE5G?=
 =?utf-8?B?OVJ5b3RuOTNNQjVTVWxZWlJVOHFxcCtQV0pkNk1veXB3RkxjM1FCb1oybFRH?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a67295f-d85c-44d9-ac3d-08db6774e5f4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 16:33:17.7043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dpDtzJh9Xh4QTeYABq/VEauk/cI8SXI3TtTKoU2iu81KSXZz+A2DTyYYOJL7HJDAJKS+qW75L3SZi9ry1k2J/jXs11nT1vA7Tdayur8Eb6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7615
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/6/2023 6:08 PM, Jakub Kicinski wrote:
> Flip the netif_carrier_ok() condition in queue wake logic.
> When I moved it to inside __netif_txq_completed_wake()
> I missed negating it.
> 
> This made the condition ineffective and could probably
> lead to crashes.
> 
> Fixes: 301f227fc860 ("net: piggy back on the memory barrier in bql when waking queues")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

LGTM

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>

