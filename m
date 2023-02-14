Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34CC696AD2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjBNRJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjBNRJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:09:11 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ECE3A8C
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676394550; x=1707930550;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TI3Frj1el+J8sq0JdhZRkZXJCLd76341akNqwuHukC4=;
  b=Tqw9osNicvhbe3Z0Nbiri9kBFSmhUAvwttZnepmtTjMWIvXgy3tCQOkK
   LKbbZp0TVOZa/o8v/mA7QCejLhGRbut4ZN/u6P94vclinEvBoCfQ9ACDG
   tT2E7yU3v0XO9c6y94kh8ENyWYtNq/LWI315LhCspIvLJA4Uq7gsSQQRF
   fA2k+xeO39nEBLtHUcXRknTRGbM3bEOq3kgM2eBcgDQ5nfZkAnUuLy7PD
   XyLpWcdaXWxhej4uoEDB083zWrYkuHhazZ3JeXy4XY86xUuvx3tBl4ARk
   rOQ2g9yS1uCNwtsRDQl/PK7j9mu7+gYLs33jxlkXL55ULk2jomC5fsq73
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="395823656"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="395823656"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:09:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="701700514"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="701700514"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 14 Feb 2023 09:09:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:09:08 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:09:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:09:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYCeBieSyyDYypp/jQJutKia+3EsrTkhrk3f3E+FQSAMhKKYLqcOxrrLVJwWqHcPxbE2NuXoRJjD6D+7eDutoz+xC/DYAVF2FD3pWh+2vSMVyvPZQClZM40ZAoZ4ch3oADJiYUPbC1X0v7545w+At7aTP63FHwElo+eRYOu4aZWJDRrSqulc7o1JY/qkYNe4szqL0Qln30ZbXaIASc7otIh509tVUKReoVS2g9hbITFBAAs2Pfkjo24YwjdeStI+Jc7JtUsfLoL+IsUetmz9nOwJptAtySCIZrX2eReYzPPrIBymICyJ23FCOxtGMxmQTeNpLCyHQAB6MTL/yMOgwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUNxl7AcX/M3GiboejQU/ZjGv7KZLW5Xza9jmj+5y3U=;
 b=TT/KbhXVrprKPhNTKyvHXz4B24nMwtwcFsDqAEj+7s7Oru1OYqjSqEYeeubEIwswJ4NKMvGTATUF2XGFMyhgNRVoevSN7u9d9i28q0rBN8CCSNl6iBg0LaDiqiB35oexyK3Ovok4+ndYokwK65L4VkSmr3qTLRqg3x9SrubQF+RJwfdpcYcDhk3hEPiZBvMoV8u9PX6PF5WLEB83cWcVKlVJS8dtO/CM2dRrflba2OgtDxYPKte0ZNqWXrXTTBflQA+YgWeCJLs/fHja+TSnBnvWsvS3OBbVgbOx8sMy4wY0E4M/WM7iFpuWbHcSVsZO0PjlayS6O9sCAjOLdBl18w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB4983.namprd11.prod.outlook.com (2603:10b6:510:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 17:09:06 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 17:09:06 +0000
Message-ID: <23c46b99-1fbf-0155-b2d0-2ea3d1fe9d17@intel.com>
Date:   Tue, 14 Feb 2023 18:07:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20230210221821.271571-1-saeed@kernel.org>
 <20230210221821.271571-2-saeed@kernel.org>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230210221821.271571-2-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0040.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: b2667183-7a00-4b46-2312-08db0eae2e21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dXUAY6z2zzYz1sdrsK3lqRkd47x3aXfmmi86100uv7x1TSl9Nuip/UFwVHPDnpvYSzzOhm5rCdNUc1fOLdNko8iPq30OowFUGwBkPwntnhE/PUsLehkpF58c06Dr4xDgbFmaLXo2WKSGheS+nD49qhyjxOh/6ze7g3sZqF/AcG47TxJfQQer8ZFzYJEXpDYD4PygodYuo+hB8f5lwtDjNVnFqgk6Dip8uivB+BmACqyaWVhXMs5bqf7gt0TAsPVYGYDqF6f7Vlt+jUxZ4NdiiWOR6pL31i/Ql6/zz0kdXrCvgvZJ0ORRxcDUk+0Nk+/FgI/5JhTCaWOc4IT6GB5kzl/O7JayU2UfVPm/McSS8FxN8pTe9okTD9ldKFKkqkqaD21kYpN/CVngjuzRHaDbXMPKhn0v5T42BKky7PTaq4xw8ImbR0mRKHkAXwjAKHYHqF6Zhjmi+koC5YQrekO4V55d5ur++FMopYItu7zk9x3NHYUQ4udtkIG+3AdsqeU3pktNqDvOJVSsWEoSCAETuOp7bIllIlq+UPpnxOEqic1Ldwj2gtZijp2VieR76pofGztXCUzcvLoZYteJD79qBognI6XRM8E9aXMVboPSBlrGy1QaM7Q/w9g1QY54M2SwDL48P6jy5PhY/4R/6wDciyuUwpnzjjpnMxEBkYpbPQaQ5cDQcW3An/9mzPDX6y/JMgrMENhJQhA8JVl3miaEjTQFaWUXNj9oqjKwG1c5X68=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199018)(31686004)(36756003)(6666004)(54906003)(316002)(83380400001)(6512007)(186003)(26005)(6506007)(2616005)(2906002)(38100700002)(7416002)(8936002)(5660300002)(478600001)(6486002)(66556008)(8676002)(4326008)(31696002)(6916009)(86362001)(66476007)(82960400001)(41300700001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXlmZzhwQUM3Wm9DV3UzSmxSWTBKTjRmWWl2bkg4TDZHZ0JvMjF0Yko1eEl5?=
 =?utf-8?B?NUVWa1ZKRnJYYmRRUlVqRHZ2aURLS0E0REgyUXlMdm1rYnl2bGt3ekdwM09G?=
 =?utf-8?B?WkszTHVIWDNLRmlUSnl1UGlWaUpMRGlJTTBGU1ZIUGRXR3Y5a3BIRzM0RXZ1?=
 =?utf-8?B?bVlOcWxCZjB1QzMwQmJZME1tTFByeGEyMmZ5NENBNEovZHdXUVFIYWc4a3lQ?=
 =?utf-8?B?RVhyanBqZmJNc3JqTnNUTC9tNEUyam9VN2MyNEFLWWFXV0IzR0JnajBGS2Nv?=
 =?utf-8?B?eVBXNDBDZkVmeEVXOG4xNm15eXNRMUQ5SWl2RUZtVUtHNE5YUkZmUmIyM0hL?=
 =?utf-8?B?TDJ1b1c0dEE0Sk9lN24wR2J0RjRnMFZEaXJDakhpdm5BdHhnOGU0TEp0ZnVt?=
 =?utf-8?B?bmp4V1dEQ2FqNzN1SFlla3ZLNjRTcVpFNFdPTEltT0FyT3ZOYndVdHM2RWVX?=
 =?utf-8?B?R0M2bFJzQllOb3BKMnRXdHJ3K1pVdnB6dDl0dE5ra3J0MTRxdHQ0c2lFcjgw?=
 =?utf-8?B?eW5Ma2laY2NKam0xcnlvOTlXaWQ3K2tqWjMyaUZxVysvZTJ0djVYU2V2TVF2?=
 =?utf-8?B?eEE1T2NRRmlYR2FKbEczSXpNYkJ5UDFrNFlvTUJ0NzJtK0loQ3BXaWFkOFJ3?=
 =?utf-8?B?VXBXZVgveVhTMU1UMGFhU3N0ZjljditJMnNvc3FJYzl3cDVidGFLa0hQd3Vu?=
 =?utf-8?B?Mlcydk56MzhjaEs4TWNkeFQ2RkNpUE1oaDd6MWl0S2poSHgwS010SEVpaTFH?=
 =?utf-8?B?NEdGOTdrT2QxRDBXd3VkeHZwb2JpK3hsbll5RXVjbG5hU2FuSzZmZi9BLzA2?=
 =?utf-8?B?ZFF6a0pvZDhNcGx0RFYzbndMVHBkOElPRjNyQTc1SFc3alJ5VTEvRjNPN1A1?=
 =?utf-8?B?OGllOXUvallISmp3NHJRZDQzTUdVUXNxbXJYQUxUeGpZT2NZZldXZWNHZGRk?=
 =?utf-8?B?ckdlZ1RxOC9MSlVRZnEzS3IyaWVkekZUODBJL0plZDV3enM5eUlPU1hZSVZv?=
 =?utf-8?B?QVBZWE8rTHJvaWRCbjF0ei9wMTR2NGo1NXFwSmFLZi9uMzNMNUhJam1HbFJo?=
 =?utf-8?B?Vkt0UlVGTGJQek5VUjNrWndLUjZuT0tISzc2QTR5Y3BiNElVMmJ1aDBteUlr?=
 =?utf-8?B?UmNpaklHd3A0Qm9WQU5qR3VmM2lvWTJXTWthc3lTQkEyamVoUGtaTlJualUy?=
 =?utf-8?B?aG9xZEpxUzBNNnZtL1JkcGhmQXNJeXpNZTF6dDFEbWptZ0lObWIvMkFjVFF0?=
 =?utf-8?B?UHhuRWp3SHJMRytENXJBS1cvQ1FPVWZTQlR2MmpMYXRrYXROUU4yaDA0bUJZ?=
 =?utf-8?B?YnZkamdzRitXNDJKN1ZxejEyZjhtT3hTTlVpY0d6SDhaV054K2t1QUZ0ZDJn?=
 =?utf-8?B?RDRGMW8rbEw1MUF5ODZGNmdWcWZjZi9oVW1vSXh0RFIvZWJUUE1DOTFpSHdv?=
 =?utf-8?B?c1hiL1FpMHo1a0EyTUNKSlVLcmZhY0ZQNnRZYXpRaERyK0w1b3ZiMVIyN2NH?=
 =?utf-8?B?cDNrQi9rMTJWT29iTENhMHZkU0J5dUFnMnhQTmJSQlN5UDJ1T3JsZkdvZkd1?=
 =?utf-8?B?dCtUcTZ6SHpqRXVvSi9jbDVNWlVhSVRSYzRCeCtaaVgva2FKK2RGWWlDYW40?=
 =?utf-8?B?UFZQUnFJZ1ExSy9JdnJjd1RMZUttbDlDK2ZKeitCS1VsWjA1eVdkaXBRbGtI?=
 =?utf-8?B?RGFPWVNXVVNHMGhvMDQvNGtnZlV4NnVCdFRvQXljTkhGeWZ3VWtBMVBnaE53?=
 =?utf-8?B?c1Z5VjFXTmpTMzJEeEoyZWd4eGVSaXpoRlJUMzgybWlRNTNqdTJ1SFY0V1pN?=
 =?utf-8?B?WEhickI3ak5jWGJGOXZvaHgyUlFJTXE4WmNNVHdrSURNbERxZHJwNjFsSnVo?=
 =?utf-8?B?T0J3eVhseERTVjBDdXkxbHVMRlBISGJKTE9xNmJDRG5ZZ2lTdzViNHFIVXRJ?=
 =?utf-8?B?cGQ1amR3UDVCSGdXQVRuVkxsSWN6dzlXY3dkK3d2cFpJZGU4T0w2N3ZCaThY?=
 =?utf-8?B?dDYwY2Zjam5RSlNsOStzcGRtdEhURFh1MVphcmFLOUVPSFpLK1RoNWRPcFp2?=
 =?utf-8?B?Uk1qaCtPRHlOcXdpdGdUZlc4eFRGRkZ4SG8rRGU1ZnNiVUtQckphR29FcXFr?=
 =?utf-8?B?S2JhYU13WlNFZHFtcXd5WlR1WkswNkE0QnhkOWtOKzk2Ni9JQ09zeEp1UGVK?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b2667183-7a00-4b46-2312-08db0eae2e21
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:09:06.5641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MeKHBCRq1Urpuzz/SaQ0f2AJI6O1738a0r0XT29MF1YFNtFJxyfdEnTwk5wLmQTuNiZTcUaL6QtLgoTEP6RYyJreE5duhjNXNK36y4VqLOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4983
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Fri, 10 Feb 2023 14:18:07 -0800

> From: Roi Dayan <roid@nvidia.com>
> 
> Instead of activating multiport eswitch dynamically through
> adding a TC rule and meeting certain conditions, allow the user
> to activate it through devlink.
> This will remove the forced requirement of using TC.
> e.g. Bridge offload.
> 
> Example:
>     $ devlink dev param set pci/0000:00:0b.0 name esw_multiport value 1 \
>                   cmode runtime
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  Documentation/networking/devlink/mlx5.rst     |  4 ++
>  .../net/ethernet/mellanox/mlx5/core/devlink.c | 56 +++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/devlink.h |  1 +
>  .../mellanox/mlx5/core/en/tc/act/mirred.c     |  9 ---
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 22 +-------
>  .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  6 --
>  .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  4 +-
>  .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
>  .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 46 +++++++--------
>  .../ethernet/mellanox/mlx5/core/lag/mpesw.h   | 12 +---
>  10 files changed, 87 insertions(+), 74 deletions(-)
> 
> diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
> index 29ad304e6fba..1d2ad2727da1 100644
> --- a/Documentation/networking/devlink/mlx5.rst
> +++ b/Documentation/networking/devlink/mlx5.rst
> @@ -54,6 +54,10 @@ parameters.
>       - Control the number of large groups (size > 1) in the FDB table.
>  
>         * The default value is 15, and the range is between 1 and 1024.
> +   * - ``esw_multiport``
> +     - Boolean
> +     - runtime
> +     - Set the E-Switch lag mode to multiport.
>  
>  The ``mlx5`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> index b742e04deec1..49392870f695 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -7,6 +7,7 @@
>  #include "fw_reset.h"
>  #include "fs_core.h"
>  #include "eswitch.h"
> +#include "lag/lag.h"
>  #include "esw/qos.h"
>  #include "sf/dev/dev.h"
>  #include "sf/sf.h"
> @@ -437,6 +438,55 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
>  	return 0;
>  }
>  
> +static int mlx5_devlink_esw_multiport_set(struct devlink *devlink, u32 id,
> +					  struct devlink_param_gset_ctx *ctx)
> +{
> +	struct mlx5_core_dev *dev = devlink_priv(devlink);
> +	int err = 0;
> +
> +	if (!MLX5_ESWITCH_MANAGER(dev))
> +		return -EOPNOTSUPP;
> +
> +	if (ctx->val.vbool)
> +		err = mlx5_lag_mpesw_enable(dev);
> +	else
> +		mlx5_lag_mpesw_disable(dev);
> +
> +	return err;

How about

	if (ctx->val.vbool)
		return mlx5_lag_mpesw_enable(dev);
	else
		mlx5_lag_mpesw_disable(dev);

	return 0;

?

> +}
> +
> +static int mlx5_devlink_esw_multiport_get(struct devlink *devlink, u32 id,
> +					  struct devlink_param_gset_ctx *ctx)
[...]

Thanks,
Olek
