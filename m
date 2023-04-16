Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3FC6E3971
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 16:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjDPOmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 10:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDPOmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 10:42:17 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE753599
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 07:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681656133; x=1713192133;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TfforhyYoENgiY4HqtyOwuvHfJH9xsWfITFaegFxaa8=;
  b=SOp5ijgzQe1uQOUMZV3i39I6O/jZn2e3NMmiMgyLngqvcKa2KS5Z1hlO
   XGcUYQpvF1dh5X/bmyNW2B4FHPOQn/QCtzHoGsTYtmEa3SNd5vmc8zH7g
   PgUhgfKrAjdfokOw8WuqmMLsmPdigK6f9Oe4vMrN4kXB17UbwCIPEkBja
   +E9FQLM8MfoB1LrQjE7yX8MUrRTbQc85Jqpttr3FlnTelZwVVktVxe133
   WUlQoI4ba9+VRjPXNPtIu2Tbki5hoA/DrYXxo0+bN/yW1CpX8XZzPkWbJ
   2JV4JNX5RB1hIUv1Os1ZTM1ezZgr7hm5E+HdUqjCKYAe6IYxaPCG8oT4X
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="346581639"
X-IronPort-AV: E=Sophos;i="5.99,202,1677571200"; 
   d="scan'208";a="346581639"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 07:42:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="683896079"
X-IronPort-AV: E=Sophos;i="5.99,202,1677571200"; 
   d="scan'208";a="683896079"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 16 Apr 2023 07:42:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 07:42:12 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 07:42:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 16 Apr 2023 07:42:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 16 Apr 2023 07:42:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1MWrRPCq4Tg3MZtEQZSnRTm0sOg7/CRpE3BkeYg8jfBj238tZ6PrFIkG/FlBwROQJeGFq3JGGwALV5UZpICuaO6o01OLjqpDgovj7/1LNDdnzMXUm90PivKm5xqBx9R08ggbXuVqmeiNFuJX94W75gjBgjDq3lT4fF+v0zMvVhaNqFYHaw2XVSBoYoYxf36RWLP/WYwXxA2OQUj7LfJX4TJAaOJeaVEdqCd8VDLKD8VrLfZf1O/xyI2iTT0g3gL5NXio6eBpNRpczF85rg5+Qw6/o19XO9PT5oz/WKwhAHLySptNQN++fJIU7B7Bhh2LvOY3k3u4m1PDaHniE1Pmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcllO6u8jN12AEgHI/P/I+ZPuAT0ajvhYjAzi6Hoae4=;
 b=fJxeD+B08NDHzMH/Se/orOX1HGEyHac3J/UHnKMp6udfxjkclm60unPc/OFtbJzcO5eFqZIGdh0y2906FARuggc05wLpvGvws/gbuQ6Jh5kzzlthXnVFfnnqC2KyuKNI9AvVTEW8In5LiBaM6yAGqkqljBGHCok4wvlyE03l5jF8Hv8ZCDExCO7v0qSQ38MpDkj3+gpDc8pRsoEz2gUCxA+DfRCeWvRD26jUeOzZhsz0lEOdcKwk0Fd1TajpPwg0WsD4lMXa0Jg85fM3rVQzAEcWKYsX0OQ5q9y9PtHz/Td0oWGALrtjwDDMrsIE8SixmM2xeBq+O4x0eoXPtH6H2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by DM4PR11MB8179.namprd11.prod.outlook.com (2603:10b6:8:18e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Sun, 16 Apr
 2023 14:42:02 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3%5]) with mapi id 15.20.6298.045; Sun, 16 Apr 2023
 14:42:02 +0000
Message-ID: <6518afc0-05a2-0c55-75d9-ccd5a1529842@intel.com>
Date:   Sun, 16 Apr 2023 09:41:57 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v1 00/10] Support tunnel mode in mlx5 IPsec
 packet offload
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
Content-Language: en-US
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0286.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::21) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|DM4PR11MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 7406f164-53f8-4e32-2fc7-08db3e88bd7b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 46vflMwbqTK49BdQZCGipPEYxkhtiLezpErTaNCJSVA/UGfkbKPRgCGQQI16TQeYEtMAfQppzAcbGO3j9QAKWYuybaDaw8qW1fHKXIoLmYvbLN1+xVY2CBIZc2jupBEQ6kKlxpfH4dGHjfV/LiAr1/+XkTXzwqzG7FTWn5YgZSwOU90wHxizYG9ux3Ag8SB4/PkLgKI2ZOdG+epo1YEMW+MrwgkW2gf6cfyyKedlJW//qBRbN2Zhc5PKchGIBDrDKqifAzChzhoXJNSymT6CotxoqUDA1qpxiV6uF+cZ+1DeIJc5mNDX9MZwrUsbX21Rvg/luehfu0DVATiQ4uJjP2hdMDSOblkOB/spFjrgeNOPRbUSrGMh1QFpimrQALnxL78j3rKkka/UWGt01xD/5JUWNOudIJ23Y5OOjasN7Xx8TfKlpOpt8t4rHvtIdXIzQB9EdN7LdBH+SysslVe36UbqWoC/sn7PaXwPtFBFeLazuN6UTyMLH9rTqKoNtgPw22tIK05uvg4q5HxbSGQ4bE3T9ejd+fJWGDOqhSm68U3VvszIw447jsX6GytAZ1iCdz1AecxPoXGtLQOzONWKoQ3DpWb9ACFGU4U64g8CXJdcwIvLLXL6tIHM60/U7IUd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199021)(31686004)(6666004)(478600001)(83380400001)(36756003)(38100700002)(82960400001)(4326008)(31696002)(2616005)(86362001)(966005)(316002)(6486002)(6512007)(8676002)(7416002)(6506007)(26005)(5660300002)(186003)(41300700001)(66476007)(2906002)(8936002)(110136005)(53546011)(66946007)(66556008)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTdwSlhaOXV4dExPSGNZR1dObzV2dVVsaVMvRDREZlNmRURESkNhZWh4QUFQ?=
 =?utf-8?B?c3NlbmxXQTR4K3FTV3dpd2lOdFQ4Y1lWRDlTenRPK0xkdm90cmN4V1JJeFZY?=
 =?utf-8?B?ZnJTTmd2NmkzMXZmeHMxaTJGNENPajNNYUd3dFlqMmlqRnZCWG5SRlNxVmU5?=
 =?utf-8?B?VGxzQUdpa01KVSt6bTZrRmV0WkF4SUQ4TmQ5UzdnRHZoTFMwY1BOQzlRLzdP?=
 =?utf-8?B?Vjl2UmJHRkpybUgvN0lTUXA3RmlHYjZhTll3akJ1dWd0U0lJd1l4Wk1yRTFU?=
 =?utf-8?B?aVlCK01iR0xrVDZsTDFuT20rc2lFVVJWNnczdDVOd1V0bVZsajNyV0tRbXIw?=
 =?utf-8?B?dHdleURSQUZqS3FielNqNk5adTUwKzVWeGxXRkt4djJZVGNlb09kM05zRFFa?=
 =?utf-8?B?Ym8rb1d1cTVvMkljVk5WNWVFTjZESHM2QjVqMS9jdTRDR083K2NMNVJVbHl3?=
 =?utf-8?B?amtiaHNxQnliYlB1elErbE9KQ3hYZWMrOUhKZVJLS1NSQVlGY25jQlpKcFZD?=
 =?utf-8?B?MWs3RmJUVDB2ekgyMnV6dGJQczR4dUJ0SGRJV3IzWXUwSGpVUU9Gb1IyLzBx?=
 =?utf-8?B?YzAzRVIwK2E0amFqM0hiZWFqNERmRWFXSDdKYmMyRDIzeXNISTRvVDE2cW1M?=
 =?utf-8?B?R29oOXVzbVA4QmhTZUFiUGVEdm05ZkxML1ppdWRvUnI0WFNKU29VbWZsbCs3?=
 =?utf-8?B?Zll4RVpNY1kwZXZUUEZGQWx0ZmxQY1Y3UUQzL0lEbzRxMkZNM0h6ZERpQ2tZ?=
 =?utf-8?B?eFRoWFN0RDNmREhlQlVYMnJtQlRGZ012dVFHR09VbU9KLzBHVCttMnhJQTFT?=
 =?utf-8?B?d05teGp3bzhXVnh2NUFIdnl2YU1JS0p4V0FtRjR4enBONWNUWVhTS3hJR2tL?=
 =?utf-8?B?MS93WFU1Slp6RDdobWdkZ1FsUCtUTGtqeXBIdXhSZkVWYnh1NXBVNmUzTlBH?=
 =?utf-8?B?SGxJbHlJLzlCOVJYWmxLZkZvV0RwTDVEd1JwNWM1dlloVEVWUHMvcjhxbmU3?=
 =?utf-8?B?elJJOVlOT1JYZ0lzYzVvWTBYeVVBZUJuQXBjenQ2OWkyTlhwT3BMaUk3NVRB?=
 =?utf-8?B?VDlNbUdvbXpWVjZPV2pyQ2I3WUdGUFJ5RDRBU3VhaGkvK050aG1pc0VhMFNK?=
 =?utf-8?B?VlZFT2gxTUFPOWlDa0FseXNGdWMwZ09HWVQ1OGtneldQOUdaVUFGRHJWUDZ5?=
 =?utf-8?B?N0JDTCtIdFR6QzYxb09UbFNHN2ljT2JLQVZaTHMyR054NEpOMEhPVTMwZFE3?=
 =?utf-8?B?WjVOMGhNc3Zjelk0eGU0a3o1VW9VRytGeFNYT0VTRHhnTVNsbkN3ZkZkZEJQ?=
 =?utf-8?B?MG5mUDBJM0lUVWt3RlJrNnBNRWhYa1Vyd3pHQXZxQ0swL0VDNmh3c2VkRnAr?=
 =?utf-8?B?NVkxcEVGUWVWeFE1aGMxMnVUSjc4dmZpQlIzWXp1eE1XczkwWmo2cHd4WHJq?=
 =?utf-8?B?YUpFWmYxd29LRzBJbDlrYjNvQkVnRE45bUw2Nk1kNE9nT1dvWFBjMFg0YTNp?=
 =?utf-8?B?VlF1Y0FWUGdhc1JaeXdnN0ppN3IwMkJGS0VMZTZCY3FmWXB6M0w5U2tZWHNo?=
 =?utf-8?B?RjlxUmlNamVQZnFKL2JIcHk2S2VlN1lLdlluZ3dFQ25VZ3dNMVRtdzlpYWhU?=
 =?utf-8?B?bHhZM3NqUzY3cFU0OUl5TmROdXo2eTVuRWljdjhyTDFSYkdiM0VoNjFtME1i?=
 =?utf-8?B?VzZCbGZOdFlXeEhSV2hlaG4xQmd1SHpZY3VndHN3QnJDV2tDaHVPTmt3Vlha?=
 =?utf-8?B?OENBR0N1V3U0NUdYOWR2ZEI3SVg2eWRmanlKbkVBWFJHUUFWLzVienRBV1Fm?=
 =?utf-8?B?Zk5UNWVGL0JuZTNZb0VUSDk5T0NwNnRvaHpKK1AvWTVkMWJpUjQ4R1ZtbkE3?=
 =?utf-8?B?akx4NzdtV0xmNGN0OTB0TC9xYkF4cWxwSERRYTJwZDIySlBJcXBaMmE3dVVk?=
 =?utf-8?B?MGdPakQ3MTlCS3N5c09iZEdhWi9uRlNkWkE0aWJabWc3bzBtejdFTlJMcWFG?=
 =?utf-8?B?L200TDdlMTQrSmlOQlpvNzFlUXZYS2syT2d4N1pncmNYUzQyYTVXckhjWjlO?=
 =?utf-8?B?VDl6S05hcks3VldMUGJwQUN1Rk12VFZEejF3bG8reXB1TGlYMkRXWWpIYkM0?=
 =?utf-8?B?ajJkRzFDbnkzSVo0ZXZ4Z2JuaSt2dm1pM0xUcUhhOVdpQ0Z5RFp2b0taemxm?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7406f164-53f8-4e32-2fc7-08db3e88bd7b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2023 14:42:02.0527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rc/ePYKes2MD2KbB9gpeLAiroVKjqMNJU4zdUPTjADk+G16MGFP7kgqmiFWPOa3nlisJUVTpj9fgLcF7X05QBryv1MM9T/qaSQ7RfBynqf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8179
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 7:29 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v1:
>   * Added Simon's ROB tags
>   * Changed some hard coded values to be defines
>   * Dropped custom MAC header struct in favor of struct ethhdr
>   * Fixed missing returned error
>   * Changed "void *" casting to "struct ethhdr *" casting
> v0: https://lore.kernel.org/all/cover.1681106636.git.leonro@nvidia.com
> 
> ---------------------------------------------------------------------
> Hi,
> 
> This series extends mlx5 to support tunnel mode in its IPsec packet
> offload implementation.
> 
> Thanks

For the series

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

> 
> ---------------------------------------------------------------------
> I would like to ask to apply it directly to netdev tree as PR is not
> really needed here.
> ---------------------------------------------------------------------
> 
> Leon Romanovsky (10):
>    net/mlx5e: Add IPsec packet offload tunnel bits
>    net/mlx5e: Check IPsec packet offload tunnel capabilities
>    net/mlx5e: Configure IPsec SA tables to support tunnel mode
>    net/mlx5e: Prepare IPsec packet reformat code for tunnel mode
>    net/mlx5e: Support IPsec RX packet offload in tunnel mode
>    net/mlx5e: Support IPsec TX packet offload in tunnel mode
>    net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel
>      mode
>    net/mlx5: Allow blocking encap changes in eswitch
>    net/mlx5e: Create IPsec table with tunnel support only when encap is
>      disabled
>    net/mlx5e: Accept tunnel mode for IPsec packet offload
> 
>   .../mellanox/mlx5/core/en_accel/ipsec.c       | 202 ++++++++++++++-
>   .../mellanox/mlx5/core/en_accel/ipsec.h       |  11 +-
>   .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 239 +++++++++++++++---
>   .../mlx5/core/en_accel/ipsec_offload.c        |   6 +
>   .../net/ethernet/mellanox/mlx5/core/eswitch.h |  14 +
>   .../mellanox/mlx5/core/eswitch_offloads.c     |  48 ++++
>   include/linux/mlx5/mlx5_ifc.h                 |   8 +-
>   7 files changed, 481 insertions(+), 47 deletions(-)
> 
