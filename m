Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAC56E024F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjDLXKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDLXKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:10:54 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236EA30C4;
        Wed, 12 Apr 2023 16:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681341053; x=1712877053;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7SAln8k1M5vPt5vKT1VQ0oB8Y2jg9dQw8phWYTxuu6Q=;
  b=RzFW7IDMXouHseF8irn+7benPFJBxJIICsSXnKXLcYOEk7ZE5LYfnt+M
   NUwBALZY2M6RTYnGyDq+8DsPgVQaT1Z7lltzv8NCKYMqQmmH0h3PTXmiv
   XT2IulTLQuYFez9LjL0hryvrkaQHzWU8TbMKklENWic6t4Nqi8YgMQHy5
   6yCDhSvkAfkZrFQrvNxx/zRl4K5m3yxt65mcMxuCBMkpZRzn7S5dp15ID
   trVKXDILdGeAtcZ9BZ+RC/Blun6EXeMT3ACUE4hHjY4gyZTnHtKT9dZwQ
   DGXeDm0OmPc8l9VzryHEhAo82CfpjazW52dhr3PksES92K4IqlOkRi2cX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="409187251"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409187251"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 16:10:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="719583232"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="719583232"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 12 Apr 2023 16:10:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:10:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 16:10:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 16:10:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY7HPlwN6JJH05BpR6Y5p0X0Vhmge9JE/xWeRu1C3th9NoSExzQ01dVOPQBOVKNNDboCgdgDTeBRkbKga4ZGuRpfX1Og5aRBBVkRBvY4n3CLASvazxmQ8dIAHE2EBbMIt62I0dvs4Y+p3JejVnS+gRj+mSmYCJOwKPzzCe1UepkwUPpk2FXsX6Yd3SyZC6qelvBtbS5W1i0b1Ov29t0nw7qgr87yhAJYh0XputSOiEd8J5AdXWcAz9kkfwOIpJMFFMnLRAnd7d+Sv3eIJjqcFy6Kx4oJN+jzUHoSqQUQ/B6LLpXoqKHbsSJWENm3nXwp0H+l7fbo+A2boB1nfCh+4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ogn820Gdej0o41xLDmRyVD3iMlg7kSE+HbxqmHr2FkQ=;
 b=TfIvNCHtkFnCl1y7dwIA2RSaio124ZiQO7REtcRZb0gsPSk4qZnO2hisKJDs7ttVc0zewDxv6NOuJItC0ylvhdY9dQtg3wHfRtKOYg4tPGH/REc2P6rTFLras8sUZoU8O3UQ7C2jrEhiG094OlgvOW/2r2NOU16qYwSGWhaSpvlSrX4MsaxA2ggQMPAJsACNZSzsR6Khh1kgQlS2FnKhf0vs4eObXovo0DlVfMeJOEYj0OmIJjVTquJwDns6RGI0LqDR1u6UaGAIrhJfY9/zIPW5+gFIs46YMEU1cljiq5sg97UZQNr7t8NlEKN3CJuz1WIvOSHwlx1Dqm48qJHTVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB7140.namprd11.prod.outlook.com (2603:10b6:806:2a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 23:10:47 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 23:10:47 +0000
Message-ID: <d01e3e47-9514-f84f-2497-30dcfda6c825@intel.com>
Date:   Wed, 12 Apr 2023 16:10:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next Patch v7 4/6] octeontx2-pf: Refactor schedular queue
 alloc/free calls
Content-Language: en-US
To:     Hariprasad Kelam <hkelam@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
References: <20230410072910.5632-1-hkelam@marvell.com>
 <20230410072910.5632-5-hkelam@marvell.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230410072910.5632-5-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::35) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SN7PR11MB7140:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fd7cc4c-d4ea-4554-269b-08db3bab2628
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qaD0ph9rUi0U1M/FeHK5Rtm/Str68j9mpaveDrLY/s+h0ivFwgfl4v5Aqjdohxz9r1evSYi4D/qKkKAKolX3w6kjjqOif4xR4T4h6vdkuAgwEHE0ZLaTItr6nIimpho+lgmWN64WIRDTiNWEzXEzdbZH/bj31sAiBvOu+cpv6uwIoVcCp8yGdVClBi9Qlb6ShNt5nogi7WGZtXwp5853CR3AYQSHFNdtHqtZ7hhTfoDwFF6UzXxuezJgLodPDsxyeV71bvzf37DFw3VGMoU55g0bMG3WKW3D9vQJEXGnYcZdl7khXU2kEvP3EzBsNEQaw+po7XuH0g0ibEtkc5aHD6QuhmK6Jf6drKEB13UB14Zrl2XvdbYGmIigI4jLfkuvD+9udFsZehp71267OjDFGC6WUYQKwshJHu+BR3Yg2HS1c9ez4EHfXcn2Z2S2n1pOEKW1tc6vjvjkKojiXG0h1KGb3r1F1rRt9B/XrbBstOGAagUJgRe30j7OOmgJF/lZF3ImVKlu6KkARba5kei7YQ/8GrT2y1MUouFZxgkoj4VBkz5NclCrmxZBAOzrryrateO1paFU6ntsZLeu4K0gSG9gPLHyMVYnDaC1s3O4BCcUt1nbcAzUXFXtRgM2gOdNON8cxjXg7n4L3S8e9ol/vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199021)(31696002)(31686004)(2906002)(36756003)(86362001)(4744005)(6666004)(2616005)(83380400001)(53546011)(186003)(6506007)(6512007)(26005)(6486002)(4326008)(66946007)(66556008)(66476007)(478600001)(82960400001)(38100700002)(5660300002)(7416002)(316002)(41300700001)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXhNbHBTVTVxdkVFQVBvY2hRV3NZak5zVENCQmxVTEdXRWx5NjRsd29WMnF6?=
 =?utf-8?B?cUVHYnBaY3I2NnMwNUw3U3hpMW00OHZTeEdiWnZSQ0xkVjB6MmwvZFpRRnBn?=
 =?utf-8?B?WW9mdTlJa0xBRTNpNzRkZW9KZEJqVWxpWDYrb3BFdVlqanZtSkpOZklQWnFm?=
 =?utf-8?B?MTlZVUJ3OUZqekVFR0RkSkw5NXgvY2FMaWtQUFAwdVlVYTFzT1NEeVBMekQv?=
 =?utf-8?B?MjhZNGNvcGxxYU9KZ0gwdUVqd2I5U2RWMmVvclRSZ1haVkpreEJUbmVFMFZs?=
 =?utf-8?B?ZFdmUkFWMi94dHczL3MzbE9idEVUS1czOVZCRjN1aFgvSGRDTFc3dWZCYlFj?=
 =?utf-8?B?cmVHZWZ6ZWkxUVVGQnk5eUhJSnRtRHVPMThmMzQ5Vml5clgzeUJiL2NhWndh?=
 =?utf-8?B?OFBkZHc5V1VDQTN0VkM0b2NuVWdxcmhWNXNvWHBzYThYWFd5UzBNSGI4WktQ?=
 =?utf-8?B?eEs0OXg3NlhzTXdlcDVpbUxQMDMyeDNaaFZJQUE2UzBKTzd3VXlrQWJ1Z2l1?=
 =?utf-8?B?ZUZlbHUrTnYyMU42Unp5dCtiNzFCd1JMeFg5TFRhMWorTDJHek9JZDJ5S1Fx?=
 =?utf-8?B?QitFeVh5cXNSL0ozWWkzVlBzWFp3K29yTWc5a1BQeUszVzZuc0o1bU1LdDBQ?=
 =?utf-8?B?bGo5NVNlL0pOdzhrTzZxYnBQTWkzRDdmdFhSZDFNbHJFMVRxVi9NSUNhckJv?=
 =?utf-8?B?aldTc2JiN0ZhRjBlUDRSOUF4TE5hemd2NE1jY3V1MGNQcDBienRtR0dGc1Ja?=
 =?utf-8?B?YjdMRTZKaWQyVDZoNVRTRXBxSFI4MjB6WEVodndHWkprYmhBN0xtdlJoa1RP?=
 =?utf-8?B?dC9WdkE1bFk1cWRjMVdwZCtQd3YzcHE3TFdMTmZGN2J4ZmJCTWVjaWZldHpN?=
 =?utf-8?B?UlduZUNtTy9kcEE5cVJoeHB6VlB4Qk5WYVpVR2lKVW54N1hneDNMbGlnYW1L?=
 =?utf-8?B?a0lNVGhObmsrQjhpSmdWTWZJVEhObktha0c5OTdlVVpMallJUGwvRk04VVU4?=
 =?utf-8?B?eHp3aUNsTER0cGhOb1RJcHB0OEJWSDVOeExPQUVBcmF3d1ZYU0YvQzIxT0R0?=
 =?utf-8?B?cUI2SWFsbUhBZk95ai9wTnI1SmpqNU44Q2NtMDRrMWJEWmdFTHlDS3REV2k3?=
 =?utf-8?B?R1NGWkdyUm5mbXVkZVNySlNaZWRPcUlYYStmeTFQYy9iK01CV0NTNFdKbGln?=
 =?utf-8?B?dUhJRUNGdmd4YzczR3FBR2lWWVMzQUxPd2UrVFF4T3VCS2F1ajdpRUh6L0Nh?=
 =?utf-8?B?MzV5b2cyVGhRb0NUUDVKTlNYTzBkNlVpVjNIdWpkZTNyU0NJUlZmSGpNb08x?=
 =?utf-8?B?eVBXMU5UQnhUeUxPeVZXS21wQmtxclhHbXRVaG9yRFhHaDZNK3d3LytrTFE0?=
 =?utf-8?B?N1FTSEw4aE83NmdUQlhaQVl3SWdPUEd5TGJYeUkvUk1rTTc3TS9pREJ5bTQw?=
 =?utf-8?B?bmJtM2hKWEthc3Y2dThUYS9xSGpBdnl4OU1kazcwM010TnVIU0tIcy81L2Fn?=
 =?utf-8?B?N2ZJenh3cFVaUGhoZnJ0SmtHNHd2amdiSk03eVZrRWNGcE96MVB6L1Yxc0tn?=
 =?utf-8?B?WXZka3hFTGQrOWY3LzZxbHBxYm56azU4ZUxsRUhud2dwTnZWeDFMcExpZHVQ?=
 =?utf-8?B?RHJFbXF2YThORmUrMEdyMjZBMUhpVndRa3YwT25jRGRYc2xhbGNYVzlSWEFD?=
 =?utf-8?B?YjYzYU9paktQSU9ybnI5TS9CWHFmSXg0c21nZnhKMGtDcFE2NWNXaHFvQWEx?=
 =?utf-8?B?eXNVRmFCelVqU3I5azlTUWZNaU01RnBQTEhicThNODNjWVhHZ2Jyb1dIUUt3?=
 =?utf-8?B?RVUyNkxRcERuZVZVcndBdTFra2tjYmdISEhoRmdRZVhsN3Y1cXdTSzlBbGEv?=
 =?utf-8?B?UlpYbkM5ZkQveEZsR0tRaVF2RE5kK3QzZ0p2N1RPaElyZUFoTFM0NU1pTHNE?=
 =?utf-8?B?ckdGNy81YmVPalQ1Z09tUlhoeDdXZEMyRllXNUJYRE8zRXBoRTNaN01DV1Uz?=
 =?utf-8?B?VVF3RW5UVk5mcEpwOGRCQUU5T2tINVpySmgxMDczZWUrTHh0bnZURVkwWlp0?=
 =?utf-8?B?WEovei9QMTNtbHcwMER2bkVUWlJKdGRTTmtSYm9XcUJjbGs3WmsxRWJ0a0dh?=
 =?utf-8?B?QUV6TW4vazYxZnpXUkhsRWJEb3RIQ1pnK3dWWU91ZVdtOFFiemJuV2UzMHh6?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd7cc4c-d4ea-4554-269b-08db3bab2628
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 23:10:47.0713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bOJTxJ98NuVQs5bp8de99T7/0eT4/GJ6JoTF8zYSjI1138i1CcLIU5sj5evsw0HRxhix+6i+Pg9zSBuE+DtfVMALigLAQMasp+aEqmk+REY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7140
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 12:29 AM, Hariprasad Kelam wrote:
> Multiple transmit scheduler queues can be configured at different
> levels to support traffic shaping and scheduling. But on txschq free
> requests, the transmit schedular config in hardware is not getting
> reset. This patch adds support to reset the stale config.
> 
> The txschq alloc response handler updates the default txschq
> array which is used to configure the transmit packet path from
> SMQ to TL2 levels. However, for new features such as QoS offload
> that requires it's own txschq queues, this handler is still
> invoked and results in undefined behavior. The code now handles
> txschq response in the mbox caller function.

This paragraph is a bit hard to parse. I assume you mean that the
behavior used to be undefined? This could use a little bit of rephrasing.

The code it self seems ok.
