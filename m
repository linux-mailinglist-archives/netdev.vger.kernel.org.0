Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F326E7E3B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjDSP2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbjDSP2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:28:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3379EFE
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681918058; x=1713454058;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Zrt/WE+pi6+qyFHrYH899FCg/AV979My/8SufAmi9E=;
  b=bioHRUTEbf5iYC2leS3bC6eSl9JKEq1DvG2qWx6P9/x4qJJUjl1u28tT
   GprG2R9+eUl7k5WL1kSbBfeK8XlRQlqddZXJif7XQ8xeDtVeyyBR1tFxH
   VhPE/AC7gQ3ZNaNhSw9jvNk5rMADVIygtdwx7NjFKn/oW9oa5IBtm1ZtB
   ggB9LNSkFslhZJXuGGabERNuoPuGaJgAMgu0ZsgJJjP/yntEWPrr/xNai
   8ZsYraZTvDD2BcLFnrHQYj72nySJgILO0B7OsCl9q0AXUCbMFtMU55PmY
   C1RDPPzFhaqBQdzH+nY0KecnjCcA4KAdBMTEF+qZlOmtMdNNPndB627OP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="334290646"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="334290646"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 08:25:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="780885701"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="780885701"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Apr 2023 08:25:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 08:25:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 08:25:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 08:25:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 08:24:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXdpPNYwZod78Fs1C5lEFzxCXhD61v6Cw7msi5pXX1Kcbf5wd0B1mnjnQvUTE9GlksulLRzwBnZgFRFGbr6zppZnLey8HBIOPaMysOaeOOrVCyDIxpXGtOzfCaP5HIH//naTHrmxLlCTsWTHIA/Cn9VdBfC+/BGacpIXfF89athLQwPdND6lte5Gb9gqoUI8GTZF3igvyooON4oBIjvEPyVjB+D+zFjMn3Zqnjm/2H/jYiZzzlyxSErz9rEoYwL/C60/lVZqUOyJeQ5VqLVhsaqbqzsvREA4G0Xk9S6TCrhVrJjjq0nYUqyeP2apkA/nXVm3hT9xZtnHYItjAzUGIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11VjioeoGj5IpN0YOyqgu2B3k4eJKRJZktsy9ve2pn4=;
 b=eAyBypDc7u/ZtSNms6TFcG0MP3nnYsACKmLZKueqGVuxwthiiaJDhtDpU6pdKkgUsyQISvXFaNmKEVrKPZFQmM1LTMRM0zMv7HI2Tvz3IT1MTagj4JMM5QTQ4WzJK5RKm3OSwdqoUdkQN9kdAxqJvzccJnJ972HFo0H4r+hUKURcB8B/rvsdMexM5AY5sTndxFSlv71KEg5PSjGh+6+pnU1HnhIlFM+FQu0+NYHg9Wec22ymq/4PKKSXDE+gR2zZ/llT33EgvNvdLFtErAOOEOCGKbpIlfaVJAoynbbIT5zQgK1EBPLvqJFW0QkUDCFIeIjLK82PL8kM6b4q37cYvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 15:24:50 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 15:24:50 +0000
Message-ID: <4a293c46-f112-e985-f9ad-19a41dd64f01@intel.com>
Date:   Wed, 19 Apr 2023 17:23:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 04/12] ice: Implement basic eswitch bridge setup
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <david.m.ertman@intel.com>, <michal.swiatkowski@linux.intel.com>,
        <marcin.szycik@linux.intel.com>, <pawel.chmielewski@intel.com>,
        <sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-5-wojciech.drewek@intel.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230417093412.12161-5-wojciech.drewek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0282.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::30) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5276:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ae3e684-c163-4b9f-f299-08db40ea373f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1BzMlD3useawnGRWVzJQ0B38B8j/g0aOj2AeRDF8HHocSwUyZDjS2f9Ji9l/Kl+h+hXDAK5cQcspBbmxN6TUYGu1k2djtPAHmw9Fovg6xnH32CiVxpgxu3eElp8TtyXQb7hXwlBm5XZ/UysaM4q3gazwIyP8oZJSanxeEtNGkFzeYIhFf1DyTHIJFmvg9ioyIT5IBmk7AvQ9ZxYNTI5g2wlR0Nt7JUpLiqSxI3nEv4ux4RDGm+bquBWPyEXqgZpTHdbc+fs+CeSsDpcxvcimx2YKF5tqUPHXygvd+//TZPSiO/UXhjxzS0h7WE0ktUfWTGJHns1W2Uv1BGr+NGhUZnDTyDZ6HwKJSFwm52tAhw1pVkvU34F6dHGqmDT+NmuyRQai5t6pe7fEF7buOcOBBdnr/AEnemEnnibTVfFSZaOJh4+AEzed0zQpN+osopjLum4yHyy1Vh0czDTi7nOWIbnzejFIUkgEPLunmoeUI6VL53J32jmT3bm3FO/JmCm38e8l3tQ/+JKm+kLwNI7mAvPaGKg9fCEz5jkZFIjzkcKQ0yp2kCVLVfq4vO1E6KqmS+CSIkAjTs/IzTfcJnrgJjGC8A5+/O9uDaIrTkWBRzyh1twil4qV+vcDMfknMkf8EUT2zEcMHk3dKA1QmIvpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199021)(6666004)(6486002)(86362001)(478600001)(31696002)(2616005)(26005)(83380400001)(6506007)(6512007)(82960400001)(186003)(38100700002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(5660300002)(8936002)(36756003)(8676002)(31686004)(6862004)(41300700001)(37006003)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3FSQWI2TkFaNGo3akRUZTRMbU5LZ3hRUmJFcTUwRUgweEdoMlJvSTUvMko5?=
 =?utf-8?B?TXRkbHFPSXlFbm5ybzJjRHFJWThkTUoxYytBWUZyS091ZXVYQUtDL2pGWWZ5?=
 =?utf-8?B?enNzeVV0a09GZEFleldFYWpoMGthckYwTFMvV2NqM2xCa211RUxkZ0pjdzhx?=
 =?utf-8?B?UmRGU0hmVkVWQ1lTZjJqRXFHYmhmMkhCa1FxRmNSUG1mTUJNZU92aitiVk1n?=
 =?utf-8?B?Mlg1dnJ0R3RvTVNJRjFITjZEY1lGV29DMk1sSUtOcXN3cjJZRmFwalcwbk5R?=
 =?utf-8?B?cnlNTWRlRGhDOGlDK3BjQzlhRGFlbkhIdUIxRGd0VUh6bzRVdkxROWtTNHFm?=
 =?utf-8?B?QUYyUkNsUWhFNk45TkhlN0w2bktYemdmQldPaWJVQzZUM0djNzRMdmhKWlVC?=
 =?utf-8?B?RENmTjRudjFlNU5lL25ESDlLYlYwcFZHYlFySTBMRThCQ1RiY1hxQWJ4TWkr?=
 =?utf-8?B?eUhlbGUyZm1WeWttb2V3bngyQmlRcmxyS25iRThFRXRGVVF6bEs0cUZoRkYy?=
 =?utf-8?B?OW5lbVM4L2dLZXZtNG9hRG1uVmh0TXlSVnpQUUVYdTNTU3hKNjNBTDdTWXBo?=
 =?utf-8?B?enhWY242YXdKa0VtWFZUUjFXU3R2WG9GeGs4UTlBVWxzZUpWYUVUTUw4OFVw?=
 =?utf-8?B?eStaMWNEWXltTThMdzhpTEs2dDdwMXVDcG1TSlFKSU9BdzhtM2FwK1hBNmRh?=
 =?utf-8?B?RFVMU0g5YUd3R09oNGNlZ1UxOEE4cERFTWhFczd6YkEyckFaT1ZJYmVtcFds?=
 =?utf-8?B?RFZCZ1phNk5FR2xrY3N2Z0ZBaDdLVFV4MzBIbzlyL1ZjYktRRmx4QjVLNnZM?=
 =?utf-8?B?dTE0SkJXMmcxL25aTlNIYWhablJ5d1dYV3J3VVNSWUM3WWdJdWJ6ZVhMR3NC?=
 =?utf-8?B?dFpPSTRJUXFWdGttNWJkRktyTE1lNnBXWE9oRnEyMFpweW1Cc2FlQnlvZWRP?=
 =?utf-8?B?TGJncSs2TDJvcSs4WVd5ZGtsNzFmbUd2Rm9uUU8yK0lNYlg2UkplK1UwNFRu?=
 =?utf-8?B?VmE5blY0c2lDMSt2dm9BMi9FSkd0bE5WcTRWNUYra3VkbXJVVlRxdkwwUzJi?=
 =?utf-8?B?ZkI0QVBVUFdRTmUwV0I5M2RubHRWb1g5OUNlbzdiOWY4WmRaQ2Y1UHN1cW5T?=
 =?utf-8?B?dTQ5QjdBbmVqNllMR2EwcmhrTDkwRzhOYVZrM1h0czgrMGE3Z2luNmJGaFFF?=
 =?utf-8?B?ZitqVC9mdXFQaFJnK3VKZUJ5TDJDWnc0dHBKWFJ0NmcweTc1a25JRVowRldz?=
 =?utf-8?B?cDdSNlZYRXcxQkgvRjVXWWRLVE9xM0ZOdkR3VFRBc3NMZGVaT0NEdlprb2Zr?=
 =?utf-8?B?UUpqd2wycWQ1K2lKMkgwNzE0eGErcmVqWUZES1dQcmhHaGxJaG5tR2RlYVBM?=
 =?utf-8?B?cFA3ZlI3R0xPTDZ0NjVhSzZyUmIwREZHb2JqUW45WmpkeHNFbGZUQkxzcjIx?=
 =?utf-8?B?VzNiTXRGeUhPZ2lqcnh3czR2RFFCMzRXbDVIQzd5aGJVczdYb1Y0ZERuYi84?=
 =?utf-8?B?YjBRTHJ1SGQ0dTFTdWtFY0tPY2dDZkJyZXh1c3RvQXFmb3hsNkZsbFRzUk1y?=
 =?utf-8?B?NVQ1d3lhU2wwQUVMNmw2YVJWUnRHd2dRK1ZkbEtEd2JkWmtHclVYYWs4Kzcz?=
 =?utf-8?B?a2NLVzhJQzBPMm1nQlNpSmtXYzBVdmFZdkVhZjk2dlVISm9ZT0o4UXhYMjM3?=
 =?utf-8?B?RENlcnNZL2pzQTZrcHBiSHAvV2ViRjREVUtGNWFVcTdhM1Jtc0JuZWd1bjdw?=
 =?utf-8?B?Q3ZXTUVFWDhMN0FBay9oeVdidCt6NzZaVXVGRmFuV3BpanVvQnM5LzYrZDhG?=
 =?utf-8?B?NzJCTFNVNENnTUY4VVRCVkFhN1hpTlRyZEhLSVN1ZDl4Qit2N2hpYWtiRFFV?=
 =?utf-8?B?QWNiV3g4RXdHeW9CV21hZnUwWG1JNU1WbDNqU2R4clI2K0ZPVFBqVFJIbUth?=
 =?utf-8?B?akw3Q3BZaGdYSitMMFFrbUp2VUp6bjlMdFBBd2tweEZ0OHQxM05FbmZNOGpB?=
 =?utf-8?B?OW12VDB6eWFjMGF1bVhOWjI0LytMVG93MmY2bVFCYWxKRFZaQmRBYUo2OVd0?=
 =?utf-8?B?ZUJqaDArQjFjWWMvZThrRHBVZDJtS1NLbE5lOUhzYTh5dnEzU0ltaXMxd0VX?=
 =?utf-8?B?bXovZ1VSU1VnTkcvQlEwdm1KQVkxU0FIcWw3bWEvNDQ5QzV3UUJoNVBWNkNm?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae3e684-c163-4b9f-f299-08db40ea373f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:24:50.0065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /7aRFtY9biMUTkwt7xgjilv1hbNUKGHjsX9NPd/N1Q+8Lp+Uipl56JACy17lefvOmO0W9/XX9ZIri8QxFzufdVemiVu9S5YNQb1I7E26S7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5276
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Mon, 17 Apr 2023 11:34:04 +0200

> With this patch, ice driver is able to track if the port
> representors or uplink port were added to the linux bridge in
> switchdev mode. Listen for NETDEV_CHANGEUPPER events in order to
> detect this. ice_esw_br data structure reflects the linux bridge
> and stores all the ports of the bridge (ice_esw_br_port) in
> xarray, it's created when the first port is added to the bridge and
> freed once the last port is removed. Note that only one bridge is
> supported per eswitch.

[...]

> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index ac2971073fdd..5b2ade5908e8 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -511,6 +511,7 @@ struct ice_switchdev_info {
>  	struct ice_vsi *control_vsi;
>  	struct ice_vsi *uplink_vsi;
>  	bool is_running;
> +	struct ice_esw_br_offloads *br_offloads;

7-byte hole here unfortunately =\ After ::is_running. You can place
::br_offloads *before* ::is_running to avoid this (well, you'll still
have it, but as padding at the end of the structure).
...or change ::is_running to "unsigned long flags" to not waste 1 byte
for 1 bit and have 63 free flags more :D

>  };
>  
>  struct ice_agg_node {

[...]

> +static struct ice_esw_br_port *
> +ice_eswitch_br_netdev_to_port(struct net_device *dev)

Also const?

> +{
> +	if (ice_is_port_repr_netdev(dev)) {
> +		struct ice_repr *repr = ice_netdev_to_repr(dev);
> +
> +		return repr->br_port;
> +	} else if (netif_is_ice(dev)) {
> +		struct ice_pf *pf = ice_netdev_to_pf(dev);

Both @repr and @pf can also be const :p

> +
> +		return pf->br_port;
> +	}
> +
> +	return NULL;
> +}

[...]

> +static struct ice_esw_br_port *
> +ice_eswitch_br_port_init(struct ice_esw_br *bridge)
> +{
> +	struct ice_esw_br_port *br_port;
> +
> +	br_port = kzalloc(sizeof(*br_port), GFP_KERNEL);
> +	if (!br_port)
> +		return ERR_PTR(-ENOMEM);
> +
> +	br_port->bridge = bridge;

Since you always pass @bridge from the call site either way, does it
make sense to do that or you could just assign -> bridge on the call
sites after a successful allocation?

> +
> +	return br_port;
> +}

[...]

> +static int
> +ice_eswitch_br_port_changeupper(struct notifier_block *nb, void *ptr)
> +{
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct netdev_notifier_changeupper_info *info = ptr;
> +	struct ice_esw_br_offloads *br_offloads =
> +		ice_nb_to_br_offloads(nb, netdev_nb);

Maybe assign it outside the declaration block to avoid line wrap?

> +	struct netlink_ext_ack *extack;
> +	struct net_device *upper;
> +
> +	if (!ice_eswitch_br_is_dev_valid(dev))
> +		return 0;
> +
> +	upper = info->upper_dev;
> +	if (!netif_is_bridge_master(upper))
> +		return 0;
> +
> +	extack = netdev_notifier_info_to_extack(&info->info);
> +
> +	return info->linking ?
> +		ice_eswitch_br_port_link(br_offloads, dev, upper->ifindex,
> +					 extack) :
> +		ice_eswitch_br_port_unlink(br_offloads, dev, upper->ifindex,
> +					   extack);

And here do that via `if return else return` to avoid multi-line ternary?

> +}
> +
> +static int
> +ice_eswitch_br_port_event(struct notifier_block *nb,
> +			  unsigned long event, void *ptr)

[...]

> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
> new file mode 100644
> index 000000000000..53ea29569c36
> --- /dev/null
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2023, Intel Corporation. */
> +
> +#ifndef _ICE_ESWITCH_BR_H_
> +#define _ICE_ESWITCH_BR_H_
> +
> +enum ice_esw_br_port_type {
> +	ICE_ESWITCH_BR_UPLINK_PORT = 0,
> +	ICE_ESWITCH_BR_VF_REPR_PORT = 1,
> +};
> +
> +struct ice_esw_br_port {
> +	struct ice_esw_br *bridge;
> +	enum ice_esw_br_port_type type;

Also hole :s I'd move it one line below.

> +	struct ice_vsi *vsi;
> +	u16 vsi_idx;
> +};
> +
> +struct ice_esw_br {
> +	struct ice_esw_br_offloads *br_offloads;
> +	int ifindex;
> +
> +	struct xarray ports;

(not sure about this one, but potentially there can be a hole between
 those two)

> +};
> +
> +struct ice_esw_br_offloads {
> +	struct ice_pf *pf;
> +	struct ice_esw_br *bridge;
> +	struct notifier_block netdev_nb;
> +};
> +
> +#define ice_nb_to_br_offloads(nb, nb_name) \
> +	container_of(nb, \
> +		     struct ice_esw_br_offloads, \
> +		     nb_name)

Hmm, you use it only once and only with `netdev_nb` field. Do you plan
to add more call sites of this macro? Otherwise you could embed the
second argument into the macro itself (mentioned `netdev_nb`) or even
just open-code the whole macro in the sole call site.

> +
> +void
> +ice_eswitch_br_offloads_deinit(struct ice_pf *pf);
> +int
> +ice_eswitch_br_offloads_init(struct ice_pf *pf);
> +
> +#endif /* _ICE_ESWITCH_BR_H_ */
[...]

Thanks,
Olek
