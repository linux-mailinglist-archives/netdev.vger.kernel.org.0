Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A24E6E397C
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 16:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjDPOqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDPOq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 10:46:28 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA291FD7
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 07:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681656386; x=1713192386;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hfqDIpkQib/DKFThzaD/dqV+VdMjEQJbIOEwoBEDnWg=;
  b=dYpS0jXmwmukny0O8eAwcRSadqENODVmpG5B1dPWWjiU07YNjU/kKMcQ
   yf1DxiWeZdM9WonyQI1dNFrQbBipm9TIh+IhAeRu/KA5kgzDFWFuFcNS2
   CQngkUwzZJNrpwAQXRrlkVNBTOD0P1NZZGs2AnsthQwbn24PIOXq2fVKE
   ClliFOwiPHOCBJcHKezU2RdOK5WuCUgEI4Pu88Yw1EUt+neIsnamh+VVt
   EmwV+8kzP4COXIrsvoPW1EBfL3dJDvEce6BgIV542kMzMN/OV8HDkGVAs
   M2qmBgT69+0m02ZnQ1bEKSLkACpdY/WkHCFK4AZUmPWqGGRwtdoAKuNwf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="324363448"
X-IronPort-AV: E=Sophos;i="5.99,202,1677571200"; 
   d="scan'208";a="324363448"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 07:46:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="936567577"
X-IronPort-AV: E=Sophos;i="5.99,202,1677571200"; 
   d="scan'208";a="936567577"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 16 Apr 2023 07:46:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 07:46:25 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 07:46:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 16 Apr 2023 07:46:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 16 Apr 2023 07:46:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0liK2+L8Sqg22+8T0+DdndKN7/KdtOESuMOOQHSAtL5GyaE0qNR3SuyZnqbkaP6p2Q48NUmeauvxkQcYzU7cBpH2GXybA/sBrvnXwXdMyyzX2rrlzoLWdhbx0NEo7f/RB91X3T9I+5XGr0rFcSQr56ZyFvXJHIPfeU75r8Dkut10pzl/fCq2IYE9MJ4LUpmPfWHLmCMgYTXvDtAW7O1KbWrfRqAxabyoqHecd6Pz83//vrBt8tYMGmp5fK9cpb4v4ES8yH15BgnHutMGEG7JfJH8465K/XGlB4aqUj0fbzWUWAPGMESHNViauvrsl8M4fTYzh+lFn3u8LuZTsZdFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miUoU6zwTtcO1Mly8GRQMoRSQ6M02FGM9HsWH9XDxeo=;
 b=dsxqHf/3bbgFPqtXrSHT9ZYzt60jAFGdJ9x5uV9kQJprXit/axO8h4T7MC14iroHz1BeFwP7NOlkqxwSHkmOBiiy5I/UzPuUKVh+Jv0gXgONQTm9RCPKxZGrSnLChXfFRpRLQKqhbZwNeyjN1XZAsS9Joe7h8EG8rWyNGipaWzxKX2cVLRss3Ed5MMolZh+JqVptAKF0MTt5s/R7BzI8BidV02ijdCclimh11HRD+6LpXLXTKk5v0MIazIWB3EhE3dJcgGVpZ5vMy9bwE3Mo2gu+30NHfrb0MJLHJWwQUJUedgn1hCL6H1R5Hgfs0PeO6FcpuQMFZ8A6f7b8lyyQYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by DM4PR11MB8179.namprd11.prod.outlook.com (2603:10b6:8:18e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Sun, 16 Apr
 2023 14:46:23 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3%5]) with mapi id 15.20.6298.045; Sun, 16 Apr 2023
 14:46:23 +0000
Message-ID: <956d4e12-9c9f-3602-77dd-0757d7809bd3@intel.com>
Date:   Sun, 16 Apr 2023 09:46:19 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 1/2] ixgbe: Allow flow hash to be set via ethtool
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <kuba@kernel.org>
References: <20230415054855.9293-1-jdamato@fastly.com>
 <20230415054855.9293-2-jdamato@fastly.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230415054855.9293-2-jdamato@fastly.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0096.namprd05.prod.outlook.com
 (2603:10b6:a03:334::11) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|DM4PR11MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: d8c874cc-1fb6-4f8d-770d-08db3e89590b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vb/7L6v7zXD9o4cqWw+Zh5sJM2bf8OxJal/VYM6MzVSHkphNdIJarAriUE1YTWF8MItzj0ljVWFuBlUiHdjdDmV0ZUgPM5ZZFET8vRZJOUfRghpQJ8PJsMW/qFiwi/1VwK9WOk/iY+O5YcFBp/TFPOXXcKf66dse4xbv6UTHJsjPSHeE+oN7Mu75fgVa6Irl0Zd93DwCLCmxBcRGZGSjMcsgSXXlDOlS5kILgY28oNG+FPxR8v35Y/TLgxLyuA6E5/DGySUGohRE4r7rrslXXgqUj3G1Pfl8znmF9YQcIjPuCAEr/CgQMt+S18JfHVFyBPltHx9gdd/HRkjO8fx6Vwt9z9pax0UJ+roFpYsllzfxYFq/zMua/bBwiCb1i+ASMMqakUeoNrc45g2albmSCsBsltOpI5CXpTL950Op0asrTqbaoVRRv9itE4nQKt80nRN+zOfUiw/Iij9RvWn1Wmad6QScmnnL65WVCQHVtM+An6Jq0B2MO+3h66SabUJqzeJsE+ttVjBon1hbHD/UqUMs+3ilw8udaq/mYxYHQ+hdDX6b6k1GV5DKS8a6QZVhWM0CPwO1mgq4pWGdhMdl6gNJn6fbze2MJbDklUYJE3OoCcJJxdz3P9Kg5BbquV6/qTV9OpCiTU3EUqawuLGeMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199021)(31686004)(6666004)(478600001)(83380400001)(36756003)(38100700002)(82960400001)(4326008)(31696002)(2616005)(86362001)(316002)(6486002)(6512007)(8676002)(6506007)(26005)(5660300002)(186003)(41300700001)(66476007)(2906002)(8936002)(53546011)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEtWSDB0RllqV3g5cHpBL3FnWUlqV2FBRzlMaVhCV3FIbVNJOXRqc1pzdDRE?=
 =?utf-8?B?MkZqUk1hOEFyQ3RoZEhNd3dSYTBZM0V1bUFDUzVjUmZQOFVabHo3U0ovNzZq?=
 =?utf-8?B?Um9QOEtTT2lJb0FrNHY0dzBWSXo1aVF6VDdBL2hEZ0FYeDloVFZCcXdyM21P?=
 =?utf-8?B?UG5sUFZaZ1lZNGlCUlZZeHNvM0JmZkZUMDVoS1docFEwZmR4eXBscFFBaExN?=
 =?utf-8?B?QkFKMnl5c3ozVUUvUjREc20yaVVUTnpSUnRWUHcrNnJOTnlTc29QVDArMCs2?=
 =?utf-8?B?WUFGL01hb3ZnUkhGdXc1cDJlaXFLb3NLcTJmUmcvRlA0cmtpeXBPUE1xU1Zm?=
 =?utf-8?B?MjJ2bGFyNVgwWFpYdWZYQmkzNm4vRm9CblVkWFV2TzBtRkVRZ1gya1BGTjhW?=
 =?utf-8?B?bEZFZWpPTHhLdWdTTS82OVN4QjloeUZNbHRuLzJxb0FKODdwMjBPK2FCNmlR?=
 =?utf-8?B?Y0Y4UXMrZ2xIZC8rVmM0RFA2TVIvaFRBWVpMbDd3cGhVc1FjRjliZjBwR0Zx?=
 =?utf-8?B?VHJwTGZQRitod0dGSjlJT25lYzhGODRzYm9USUpIenUreXhHVVBrZkJZZWFw?=
 =?utf-8?B?cDhZUitCSElKSU9LWFRJamIzQWhNNXl4V09MWWxjTmpSMzNURS9wTm9UMU5s?=
 =?utf-8?B?YU1CZ3Z5dDF0bHp0NXJNSnNCR3pXYUp4cWlta0lFY1laVC92c2dIQUtROUdp?=
 =?utf-8?B?K2dYVDNmYUVISXlUbGhOOU80aVVua0dFVmR2M1F3bmNlMXZyRVN6ZFFXWk9Y?=
 =?utf-8?B?VWdJdnorQVhaNUw1anVqRldZY21CRzZNdWVCL1hQTDNuTEhIeGxaN0NUaVZZ?=
 =?utf-8?B?bGRKbWVZNEE1a281YzgvdXh1a09zbjEzbFVGVDNNT3ZQbTBna0NHR251M3kr?=
 =?utf-8?B?MXREWTR1emRUZitZaGJQcmpxYk1iSnhWcmZ2RFk0TDQrLy9XSkx6YzFPTEo5?=
 =?utf-8?B?ZURsS1daVWoyYllJM0s1T00xL2pYaXBxOWtCTmNEOE54RTRjQXF5OFh1RG5Y?=
 =?utf-8?B?TFFJQTFhZkwvbklhZzBVWlNPUnk0cHNoQktjU2FUbmlqS2QzOGlTQWpqdGJs?=
 =?utf-8?B?bFNzcnlaRXRkaG40NElIeXh2bm4wMVJRYi9HcnVXYjVRcEtQSXRaS3hOTHkv?=
 =?utf-8?B?MnJEZEhNaE5rT04yNkFZNHpKREpMcU1ERTc4ZFZXS29ZT1h1dzFtdU1GSXVO?=
 =?utf-8?B?ejB2L1R6d0V5eEJhbDNjS0lZOVYxVE9OV3NyZk05eWtLMTk3S0xIT3pwNE9k?=
 =?utf-8?B?MUpkRFE4WXIvbTh1Vjhscll3MmJNVS9iSU9HY0hMR0FKTEd1c2h1WUMyQWNE?=
 =?utf-8?B?SUlvRTMwcm5BSExUQ3VJbXhRUCtlZTltR1duUlh0Y2kxNzVPclVqM2pHa1lR?=
 =?utf-8?B?QW82SkxmVnhrSUxrTnhJaC9Nd2h0eVl0dWliZjZtRkQyL2sxdTlPQ3FXZVZ2?=
 =?utf-8?B?c0lFdHREeU55bkJMLzR2QW9aT1lmU2VHSmErWEYxTUIwN2R3UlhCb2t0RGcw?=
 =?utf-8?B?aWZVWHhQbzNEUFVkaGhWTlVEYm02NUV2bTVYOUwxb24rQTZ2SEdCVCs3eUJy?=
 =?utf-8?B?VXdIbll2NXA4bXlxSzNsYkNWc24yYWRPRjN0WHNCK0tCcWtRZWZDR3kzMjRn?=
 =?utf-8?B?ODdEWHloLzNTYjB1RHY1UWo4ZzBRMjZiT3p0NDg0Wk5hNE5Wd2grUkk3UjNJ?=
 =?utf-8?B?UFF0Q1hNcm5oTk9wc3pLei9mWTRFTmJSTmx6MDRXTWZjRngyOExRenA0MEFI?=
 =?utf-8?B?YjN6Nkt3LzduRXhhWHg4c3lXQy83WkZrVW9XVGc2RVRvUGtuRDZuVXZjV1Yv?=
 =?utf-8?B?RzI2dFZSL003ZlRpUUt3MTRGWGcxREFOa1YyRHVXeWhCMlFFQkhMOTZxUmRK?=
 =?utf-8?B?VzVUbzFuY3R0VGZiYm4vaVFnSkZscFV4dm1zTmFCYW1FRktPL1dOYWFtUkh1?=
 =?utf-8?B?eUphRFk5WURZNmR2ZkNvM3dXOFpwcG9rQVRSZFpYcVZIRUNWdUsyNHpJeXJZ?=
 =?utf-8?B?L2VDemZscXdLTWxKc0VTdWgvWlhaU3RZaHhkTzQrVGRkekhsc0VUUkhLWE01?=
 =?utf-8?B?RWJGOXFQcXNpblZCZGdZdWNtTXVteVNlem54WHk0dDFzT1czdUhodG50SnJT?=
 =?utf-8?B?QklFL1hUYy84Z3k3VnFHREh1UVhmdlM5NmpLTFFjQWFjeGN3eElsam9XdFBP?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c874cc-1fb6-4f8d-770d-08db3e89590b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2023 14:46:23.0281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rPYAZ4wNV+FzuuJEfC2P2G3teUvG3DjrM2E84XlUtgO9EHv5PYSiGzeNZGRbsrJJqLZ0caDjEyUvZogtiVosO+BSawemEegcNUKjeJ21m7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8179
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2023 12:48 AM, Joe Damato wrote:
> ixgbe currently returns `EINVAL` whenever the flowhash it set by ethtool
> because the ethtool code in the kernel passes a non-zero value for hfunc
> that ixgbe should allow.
> 
> When ethtool is called with `ETHTOOL_SRXFHINDIR`,
> `ethtool_set_rxfh_indir` will call ixgbe's set_rxfh function
> with `ETH_RSS_HASH_NO_CHANGE`. This value should be accepted.
> 
> When ethtool is called with `ETHTOOL_SRSSH`, `ethtool_set_rxfh` will
> call ixgbe's set_rxfh function with `rxfh.hfunc`, which appears to be
> hardcoded in ixgbe to always be `ETH_RSS_HASH_TOP`. This value should
> also be accepted.
> 
> Before this patch:
> 
> $ sudo ethtool -L eth1 combined 10
> $ sudo ethtool -X eth1 default
> Cannot set RX flow hash configuration: Invalid argument
> 
> After this patch:
> 
> $ sudo ethtool -L eth1 combined 10
> $ sudo ethtool -X eth1 default
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 10 RX ring(s):
>      0:      0     1     2     3     4     5     6     7
>      8:      8     9     0     1     2     3     4     5
>     16:      6     7     8     9     0     1     2     3
>     24:      4     5     6     7     8     9     0     1
>     ...
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> index 6cfc9dc16537..821dfd323fa9 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> @@ -3131,8 +3131,8 @@ static int ixgbe_set_rxfh(struct net_device *netdev, const u32 *indir,
>   	int i;
>   	u32 reta_entries = ixgbe_rss_indir_tbl_entries(adapter);
>   
> -	if (hfunc)
> -		return -EINVAL;
> +	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
> +		return -EOPNOTSUPP;
>   
>   	/* Fill out the redirection table */
>   	if (indir) {
