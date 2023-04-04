Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887646D5CA9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbjDDKH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbjDDKH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:07:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F24B1BDB
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680602876; x=1712138876;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Rcm3AUssEvsnqyv5ctHmroFvDEmKxCaeWFv3N44tJkA=;
  b=hO7OOFRvyTYtcpbPy3Hk2D8L4ZD931rYqA1Nacuad/Fm4OzzILUR4R+Q
   JGLPmgZgP3sdA04bVd9RsK6kUbOMM166bM3Y5Ty3WMpKIYyDQb4n2V67o
   EZSBzY+l2fY6jwevLHPuwB37tV8QqfZcuRlFxf0LmIAFt9L7WQOElmVob
   1LPBz/RZjlfv/9i078sYf32LeorIU4GY8PnDb3/JmeJfOyODZf2Hxq+6+
   Pk5KmY5bLEdqGNIOmBb6oNwdSJ0SuYz8N5wfCUsRgUKgk8wS753cZhtbl
   NrVTUA4hlLZs/xKQDGD7NREWuI8sWpSZsVgZQUboShsZ4wD9kwxUAcqA6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="344703668"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="344703668"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:07:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="860541885"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="860541885"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 04 Apr 2023 03:07:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 03:07:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 03:07:55 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 03:07:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePBGGqxRUGnSt0sX5zZFr+PVZ9ZFwujP+oADnPvbLw9fatomhzWIxUpka9r+diDzvPcD0mw5UzBb5JsEweK/D/pzajpEumaVfRMos89LnWa9oeuS6QDVu4kU74qAzuUJOOe9VAYY+LcJYHkIpZufeQO96DJzn1ie5F7kvJ6VoRfK7Me5I1DDSMS1VC6Uvdbb/ctWiem9/L55cajPjMAK9rvb80k4wKF25u58KdL2zyoLmrQQ0hFZ1V7jYt6y218PdCvDodwc7mzUZZWuM3pbm24MbFUeKQ+MByJfPlwoDgjEEtDJ8aXUy5BjfhiRNEp/wsqn7cctvFx/QZ9csSAtfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pL2UhmlCIBFtY3rzD6Jw9vZvqfBlkWcp03EcbIwKaRc=;
 b=jvPC6dWdfdhlXOxZE5WLbYB4JSMhFk4JvfVDhxemAd2/e/8gbVL9m2NZyHpDVRjiJOhcPpQ7v0jSfZgge1hnxkauO8OJfiZfbfaP7vAf/9dxpZ0Ah4be2iURneRxVVtgLoqGi/cKF1ix0PCtxOGkpLLx0YVIcG5TPGQrb84FlxUEUTestSVs51lU54ruLBC+j+FRNGosqnQz9n+gGhpsHvL3YuoHLECIaCgfr0UQpHpg0C4SIGOtLxGurvY5fbpOVPzIQRq89thhyBgVs0GiaDIjkQM5MoYXUVsZ5oNmW9RcofMOcAMoQkp/D6cFBT4+TNcRI/xgXCLH39GI3sFo/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB8123.namprd11.prod.outlook.com (2603:10b6:510:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Tue, 4 Apr
 2023 10:07:53 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:07:53 +0000
Message-ID: <4559a556-9b35-42ab-ae03-391495c0b9f4@intel.com>
Date:   Tue, 4 Apr 2023 12:07:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 2/4] ice: remove redundant
 Rx field from rule info
Content-Language: en-US
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@corigine.com>
References: <20230404072833.3676891-1-michal.swiatkowski@linux.intel.com>
 <20230404072833.3676891-3-michal.swiatkowski@linux.intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230404072833.3676891-3-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::23) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: a00fed78-6fba-4ab8-49b5-08db34f4746b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jUK8b9OHwJq1Za5vg+Mcj7eQlEi5aPBM+xvxeHzGIhHe0xD0TbxzbviyxQBD7HSgw56aUbe+eVBqUASZJ1JouYeUWZ+USF/PZdOk0o4Sns09CAPGFyusFArDjISbKVnMosqzdRH4ib6sz4EI3RLE2W8oBIgCmXS5yHSp5d1S2aAxaBWR1iaBjRbodhyBXZA8jUrbPYUnAeXrHUfghk67YbbFpF9wKObLQ/Cv5euJtUgViKdy+b2fYogIVlccTtxXezfOfCkNXBA5Ts3hw2f+++mwIixsC1o7e7pbMKoKhiCj4S+30Oj0qQ2rS1YVron3HPZRnpDw+05yJM720r8Gutd4MwGfdIQ4IFrnC+iHVB+M8hJIP5E8AahKGBHUtXsfQcAklZ9yaptCdqFxl4ngvWTh+5JyPX8UHCbg1CMhuF855moVdgAJsiCvl16yQUBM7quqy+lesqKVbFyX8+sYAwFiJb0c8WqPJDaLr2svPmlWvQWMP6NHs/UNGayyYb8LcKV45gP6msH+ourookdnIEdpbAkQEWQpwb5C243FnlFesX860aIfmxYgaqkW5NcPMykllLtYVz9aYcLghsZf6+5dVCUfjl7BWC9Qa/JJ9c32qQ+KMI1sDK+UoTqkUmquM9MeRQ53ktH7DhXRoPqA4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199021)(36756003)(6486002)(6666004)(83380400001)(2616005)(186003)(86362001)(38100700002)(31696002)(82960400001)(6512007)(6506007)(26005)(66946007)(2906002)(8676002)(316002)(8936002)(66476007)(41300700001)(5660300002)(66556008)(6916009)(4326008)(31686004)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0ZVL0QyOE9VS1lBRVNraFUxOGhWdUNKeCtUZXJXZGJiV00xS3M4S1BlYjNG?=
 =?utf-8?B?N1VGaWNHc3VObE1WN29UYWh0em05OTIzSU1tZ0pjUDdKWnNyT0NVaEtaM0hL?=
 =?utf-8?B?dTM1bFFPb3c3c1QyNE01RVdSekdwdkdhdnE4U0pOUk0zRWZPSkxIdG9GZlZ3?=
 =?utf-8?B?V25BRVdjVGdzT09RUGU2NkEzditMTUZjUnBrUGdnWnRUVitoMlhubGRFazZH?=
 =?utf-8?B?OG13R2hPTU50Tmg1Uzl2U2dFc3ZrbGVRVSsyOXphVUowVjI3NGgydm01NkMx?=
 =?utf-8?B?azEyM3R1YmR3N0pQOGJ0SUxxM0hWOGRuUGlJTGlnWGJHZnozN0k2TzB0UGhQ?=
 =?utf-8?B?WURBeDh6ODVxbmlDUU03NUhSY2lxTWs3cFNQZnNnUjZYdHM0dERwMU8xeHJj?=
 =?utf-8?B?TXVCdXJYVW5XVFh4UEpsdnVpUWFEYTVGTkZoQ0xYY2huOHhVcFVPeWNhQW9U?=
 =?utf-8?B?SlZCdlNXeUJBMjV1ODNKeURCZ1pVNUQvNk05RjB2MDFlaXBac3ByZUdEckVa?=
 =?utf-8?B?VkMyekRpUXpxOGVGallMU0p4SFdXNEU4OHNZcTJUR3Y1UVplN0tKMk44MTFw?=
 =?utf-8?B?MWkwcFNzUCtNTkMwcUo5TlJtbERjRVBueVlOdmNOR3RDbXY0Tll1Uk0vMGZx?=
 =?utf-8?B?SHRXV2FNTzZxbXVOZGcrRlVzbGI0WDJHOGdpdWhoUU5pd2hpei9qR2F4ZjRN?=
 =?utf-8?B?NjZ0OHcyQk5QQ0hnYzM4SGNUMHJoQzVwbzM0WGR2cVp0RDRDUUVDWm5TZ2ZM?=
 =?utf-8?B?b05KNGJsNzNHNXpYcmltL1RCQUV4cWpEVjNqMGZLdlBqMEl5UXpvT3JvSFJm?=
 =?utf-8?B?b0diNW1DLzczK1dYRVEzWnhmK0RoeUVPbHp4d0xlQ08xWHRkL0k3MTI3cUcv?=
 =?utf-8?B?NnhCc2dSS1Q3TXlQYXU3alhSaTJsQWV2YlU2aXVtNkpyb3dLQzB3aW42ekFp?=
 =?utf-8?B?ck1yczB3OGlYVWpMSFR6RmE1OHB0Q2xCTUQrbTMzUnpneFlmdGNEU0FiOE4z?=
 =?utf-8?B?dVk3T215ZWgyclFCUldkbTNjbWFIeXVOK2k1NmR3VkpTZkFNQjFlZm1ZNHA5?=
 =?utf-8?B?T01JaVVPNUV3bXpLZUpseHBVYWh0bVg3aWxMM0lUUERIdDZLRUNabFFvZFpx?=
 =?utf-8?B?ODF3Z3dTdzZKYkZaUUpoTzlwdkVHY2dxdkhIKzdIaE8vbVQ0UlJCTDRkeW9O?=
 =?utf-8?B?bTB5TXJQNW9mc0F3N1FWYmpVQjltc203MUxlbmcvZFpoWndPS1ZEUk52aVRZ?=
 =?utf-8?B?U2xVc1RKakczMG9iMFRMajk2QkhJM0dPSmtBUHlQN3lDSlZpaWZYZkh6VW11?=
 =?utf-8?B?K0NBb0pHUnNqVjJKVjFndXAyQ2VZc3FlOE5xTFhDY3RSaUtuRnVtSEMyWFZZ?=
 =?utf-8?B?bDVrTHQ3cGdNQzU0QWpoWXJVTjd5d1VkSUhsL0Q3Ny9ybEcwU0N3RGpxRVdC?=
 =?utf-8?B?NDgzUFdqazBnQ1hEWHBwR3JHUHFXeEFxY050UGVrQlI5U0R1VjFldDhMQTlY?=
 =?utf-8?B?QVJHVnQvTE5MNWlva0U1dFp0R1B5azNGNVEySzhqRmxnWm4vUlFHUzQvYWVx?=
 =?utf-8?B?dHB2UUVhL1RWWFJQMmg3RytUcG5DTERoR1ZkSTNjT2JKRGF5bWZaMlliMjgy?=
 =?utf-8?B?TFJWTkE3ZzhRYjJGRDFWTXhLSThja1RicklSRU80L05SVUNaVTNjWEM5L1J1?=
 =?utf-8?B?ejAybWhtcm1LQXVwVGdFL3hkOWhVVlJuOFQ3M3Z2eFU5L2xqRkV4T1o3ejhC?=
 =?utf-8?B?WDlXOWZNa0tZaWlYeDZnbUdydWdEQVR1SmV0MGprdTFEY2ZuYzhpcmlQZG5I?=
 =?utf-8?B?Q0JycWM5dnV3Q3hxaEFrYWcvMlZPZmYzWjRIRHhHYVRici9lU055cnJyOU85?=
 =?utf-8?B?SHQzNTdmcTFiNE9xUEcxbVNMOVljb2xCOXQxN3BPZWQ2elNIR3AxQVpDbnpG?=
 =?utf-8?B?YXBiTWhsb3B2SGwvcUl5WDZScUtlT3RlL2xHZnFyUTJKaGp4bXVGUzQ0KzF0?=
 =?utf-8?B?YkxNTndzbUpwcERRdmlrd0VtMHNKRUc3ckFuUXAwc1p2QzhZdE9pMjNZQzB4?=
 =?utf-8?B?cHEyVmRJTStXcFJkTXhwU1R5TEZ5RXRtVVdQZ0FnTEFoZ3BVT3QzZEtQUlJD?=
 =?utf-8?B?THF2c3p5L0k4M3lIY3lSZ0JIUHZMYVZLODdTMlJDS0RZeStOeE9yOFY5NW4y?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a00fed78-6fba-4ab8-49b5-08db34f4746b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 10:07:53.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvdF1ijGfPqb2H+pTnzI0AGJmNde4b0b7FCbMBSrA+4GkNC3w5cz9sIIullcW8UQaxYaxCgbXJW17aoyIinNO1nz8aq/wmnRNQmAe8eq854=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8123
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Date: Tue,  4 Apr 2023 09:28:31 +0200

> Information about the direction is currently stored in sw_act.flag.
> There is no need to duplicate it in another field.
> 
> Setting direction flag doesn't mean that there is a match criteria for
> direction in rule. It is only a information for HW from where switch id
> should be collected (VSI or port). In current implementation of advance
> rule handling, without matching for direction meta data, we can always
> set one the same flag and everything will work the same.
> 
> Ability to match on direction matadata will be added in follow up
> patches.
> 
> Recipe 0, 3 and 9 loaded from package has direction match
> criteria, but they are handled in other function.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c |  1 -
>  drivers/net/ethernet/intel/ice/ice_switch.c  | 22 ++++++++++----------
>  drivers/net/ethernet/intel/ice/ice_switch.h  |  2 --
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c  |  5 -----
>  4 files changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
> index f6dd3f8fd936..2c80d57331d0 100644
> --- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
> @@ -39,7 +39,6 @@ ice_eswitch_add_vf_mac_rule(struct ice_pf *pf, struct ice_vf *vf, const u8 *mac)
>  	rule_info.sw_act.flag |= ICE_FLTR_TX;
>  	rule_info.sw_act.vsi_handle = ctrl_vsi->idx;
>  	rule_info.sw_act.fltr_act = ICE_FWD_TO_Q;
> -	rule_info.rx = false;
>  	rule_info.sw_act.fwd_id.q_id = hw->func_caps.common_cap.rxq_first_id +
>  				       ctrl_vsi->rxq_map[vf->vf_id];
>  	rule_info.flags_info.act |= ICE_SINGLE_ACT_LB_ENABLE;
> diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
> index 5c3f266fa80f..4d3a92e0c61f 100644
> --- a/drivers/net/ethernet/intel/ice/ice_switch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.c
> @@ -6121,8 +6121,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
>  	if (rinfo->sw_act.fltr_act == ICE_FWD_TO_VSI)
>  		rinfo->sw_act.fwd_id.hw_vsi_id =
>  			ice_get_hw_vsi_num(hw, vsi_handle);
> -	if (rinfo->sw_act.flag & ICE_FLTR_TX)
> -		rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
> +	rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
>  
>  	status = ice_add_adv_recipe(hw, lkups, lkups_cnt, rinfo, &rid);
>  	if (status)
> @@ -6190,19 +6189,20 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
>  		goto err_ice_add_adv_rule;
>  	}
>  
> -	/* set the rule LOOKUP type based on caller specified 'Rx'
> -	 * instead of hardcoding it to be either LOOKUP_TX/RX
> +	/* If there is no matching criteria for direction there
> +	 * is only one difference between Rx and Tx:
> +	 * - get switch id base on VSI number from source field (Tx)
> +	 * - get switch id base on port number (Rx)
>  	 *
> -	 * for 'Rx' set the source to be the port number
> -	 * for 'Tx' set the source to be the source HW VSI number (determined
> -	 * by caller)
> +	 * If matching on direction metadata is chose rule direction is
> +	 * extracted from type value set here.
>  	 */
> -	if (rinfo->rx) {
> -		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
> -		s_rule->src = cpu_to_le16(hw->port_info->lport);
> -	} else {
> +	if (rinfo->sw_act.flag & ICE_FLTR_TX) {
>  		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_TX);
>  		s_rule->src = cpu_to_le16(rinfo->sw_act.src);
> +	} else {
> +		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
> +		s_rule->src = cpu_to_le16(hw->port_info->lport);
>  	}
>  
>  	s_rule->recipe_id = cpu_to_le16(rid);
> diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
> index 68d8e8a6a189..44aa37b80111 100644
> --- a/drivers/net/ethernet/intel/ice/ice_switch.h
> +++ b/drivers/net/ethernet/intel/ice/ice_switch.h
> @@ -10,7 +10,6 @@
>  #define ICE_DFLT_VSI_INVAL 0xff
>  #define ICE_FLTR_RX BIT(0)
>  #define ICE_FLTR_TX BIT(1)
> -#define ICE_FLTR_TX_RX (ICE_FLTR_RX | ICE_FLTR_TX)
>  #define ICE_VSI_INVAL_ID 0xffff
>  #define ICE_INVAL_Q_HANDLE 0xFFFF
>  
> @@ -190,7 +189,6 @@ struct ice_adv_rule_info {
>  	enum ice_sw_tunnel_type tun_type;
>  	struct ice_sw_act_ctrl sw_act;
>  	u32 priority;
> -	u8 rx; /* true means LOOKUP_RX otherwise LOOKUP_TX */
>  	u16 fltr_rule_id;
>  	u16 vlan_type;
>  	struct ice_adv_rule_flags_info flags_info;

That u8 here was really off, was introducing at least 1 byte hole. Good
thing you dropped it.
Have you checked whether there are any holes left, maybe move fields
around a bit?

> diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> index 76f29a5bf8d7..b5af6cd5592b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> @@ -697,11 +697,9 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
>  	if (fltr->direction == ICE_ESWITCH_FLTR_INGRESS) {
>  		rule_info.sw_act.flag |= ICE_FLTR_RX;
>  		rule_info.sw_act.src = hw->pf_id;
> -		rule_info.rx = true;
>  	} else {
>  		rule_info.sw_act.flag |= ICE_FLTR_TX;
>  		rule_info.sw_act.src = vsi->idx;
> -		rule_info.rx = false;
>  		rule_info.flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
>  		rule_info.flags_info.act_valid = true;
>  	}
> @@ -909,7 +907,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
>  		rule_info.sw_act.vsi_handle = dest_vsi->idx;
>  		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
>  		rule_info.sw_act.src = hw->pf_id;
> -		rule_info.rx = true;
>  		dev_dbg(dev, "add switch rule for TC:%u vsi_idx:%u, lkups_cnt:%u\n",
>  			tc_fltr->action.fwd.tc.tc_class,
>  			rule_info.sw_act.vsi_handle, lkups_cnt);
> @@ -920,7 +917,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
>  		rule_info.sw_act.vsi_handle = dest_vsi->idx;
>  		rule_info.priority = ICE_SWITCH_FLTR_PRIO_QUEUE;
>  		rule_info.sw_act.src = hw->pf_id;
> -		rule_info.rx = true;
>  		dev_dbg(dev, "add switch rule action to forward to queue:%u (HW queue %u), lkups_cnt:%u\n",
>  			tc_fltr->action.fwd.q.queue,
>  			tc_fltr->action.fwd.q.hw_queue, lkups_cnt);
> @@ -928,7 +924,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
>  	case ICE_DROP_PACKET:
>  		rule_info.sw_act.flag |= ICE_FLTR_RX;
>  		rule_info.sw_act.src = hw->pf_id;
> -		rule_info.rx = true;
>  		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
>  		break;
>  	default:

Thanks,
Olek
