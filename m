Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4CF6EAF4B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjDUQhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbjDUQg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:36:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784DD15457
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095015; x=1713631015;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H2GjLtEwAjB3PBC2jqURIhjwOIdE2mp4UQhMNnT3r+g=;
  b=BviT4aDJgf5k8YiFiFjlB1nEbmGESgpvh60yTf8cOp+avCdjnEFnMEBw
   d4+dY2TnSG+L3iTgw/PP4hXrnnBZKAHQQio4odo1t173aSstJN05c+Nzj
   6JlVkNzlqEkA9KM6uYTE12OjQRNksZ1ZF3HVPfQ/8cBqzSoVYVaJDmMXH
   YSBtMpBJbJsaDya4KCjN7Q6cFT/Ynr3GzvsSc77liEMh10N53GPWBsMhI
   r4cC75AIZGRtnjwrFE1RldkGzObJ6QO+wm1+jhTxfj4teT5IUlAi/q9TU
   BvVh2h29tw2f8n/BZYLurQaGM4U+ANnBKtRP9o5vSKfjxwdBsheyHYmMx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="326363102"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326363102"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:36:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="724896815"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="724896815"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2023 09:36:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 09:36:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 09:36:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 09:36:54 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 09:36:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rv18O0vl3auxlJ3x4eS8luNmdq0ulT5jeJ1y+NotwkH/v9wvORDpnNzSqEgpnwX/4wa2uGqA3yLiSLVPgd4rjCULn6ifoPouBW4HAhMTdBKDqd5piHHxaQkRb59mYMRhdYZSQBWym1p5FeCt8IXGE7YGZOt7dM+yIZXyhe5ga4FlvIxZ9cpYe65OqLVQCmuVRZog6c9Qp97CLwiIysDZE98q4am4QAzAg868PO9043g8M5zcuojUa7a9QETMLjpxvfwgBZj9HzDYHl+sHe7ibS9/lo/2AZL1X/ePOSZCIRzOvj46pSsOz9KJoYny1MbvBohYiQPQ2wbWFvei7aUQvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/G/C1vXuSIaHMs6yluxtOuqSmoiWy/JAjDdei7IvO8c=;
 b=Nf+FCdboqwKro4qzyH/oriJ3uqqZAu2i+O66+CMjwtyBuWvT+c+FBh2F5SmRCjMVBbOdvLseb5BRVxWMvh9/zVoBh3fOW3uWyBeue6b/hAJRctojN+7KCn2VQnq8jtsgK4FIb+6SPDYS2Mav9Ue+8jVqmrktKYYFd3t+Wymit3amxFKA5+s9r3/506kyb4CihZwYJ9J4s5IFJTDUEsSLEy+zG4/y3U8brmK9z5+uCD9RlnjKLUyXG8g9M2BpbIzAyKp3gc+4j6CwZkLAH/c9zm8SAHn4VVxq9ZOxWGDDx/tpJUEvfiaULC9COmJ6o65nKtdYVQhpQ7vOg9iUfI/KOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5255.namprd11.prod.outlook.com (2603:10b6:208:31a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 16:36:49 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 16:36:49 +0000
Message-ID: <72f95cf5-d922-1f3d-2495-e8bdea6de247@intel.com>
Date:   Fri, 21 Apr 2023 18:35:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next 09/12] ice: implement bridge port vlan
To:     Wojciech Drewek <wojciech.drewek@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <david.m.ertman@intel.com>, <michal.swiatkowski@linux.intel.com>,
        <marcin.szycik@linux.intel.com>, <pawel.chmielewski@intel.com>,
        <sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-10-wojciech.drewek@intel.com>
Content-Language: en-US
In-Reply-To: <20230417093412.12161-10-wojciech.drewek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0120.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5255:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f21f94-592d-4e52-fd66-08db42869a61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zq3AjJHbOGDAF+JmV+DOrB8s1FpSrJy+dVGpHqfNXyEkqmwNwwFweZEHh7vRXJxqwwAi7S9MCYgE/xMJN4kLXqALtcLdonhKjajBCiB2+bNbUhi/cn+yGlWUCavm4WyKHRgFoPRINcfRKzXKRdt/FhOebTvmue/9iAZ8+vJpfEFz+pwry+9pHvX4bLvUcw6ssH1ArPTaI0tSYJLQKk/iEH7Wt8lhcvflIpYnMHVNSUB8knJlU2wGrWv+6BGD/4VAirLes+hPizYloiDIrJFZE1tdMUPIosogvrCYcSFqmW9pRgC9e73MlU0/dPi2GWbR3sOskGIsZc7HORSyu7EzKYr3Qkt2Ndi0HABX1ABwSinjWwsjWYN7ogiTH5btnNxWnsT7BdgSN5Mhi5Sb3Zrth+gTjQosepjbLd5Z3WVYcLxgnhBIZCBLzkcH3xHfI/XM7fgp68HE7AJDIUAEHpBexvGeIdaGsMTZPzvmotHSVcfvKsARxfxbrt88VbRvM9UdgedpzcR+2lqx8ldKN0ZK1nwCbokGMyy2nLWt0xlTYMBc/o3OFJ0NmdNMNMwVyFUxrAnxoh+YnoBrGC4M3ey9SeJs0pQVLP+SgXo4Nb2X2ewljMTDSDHKj1mNM6S/QWAgy5VLtJHdqK8tH4JIvNmKFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(376002)(396003)(39860400002)(451199021)(31686004)(6512007)(26005)(186003)(316002)(6506007)(4326008)(6862004)(8676002)(31696002)(36756003)(2906002)(86362001)(5660300002)(66476007)(6666004)(37006003)(6636002)(478600001)(41300700001)(83380400001)(2616005)(82960400001)(38100700002)(8936002)(6486002)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlI5QncwL1R6ZDBGcVpJWmxNbjRNYjFCRVJBMXU0b1kreVdHbTlNL1h3YVJn?=
 =?utf-8?B?L1dGdFIvaVZjOFZUdFpjWEx6K0VabWozUGNVdVJuRm0zemtnMllUVzNUbG8y?=
 =?utf-8?B?cEh1T2NEZjFDUUZvYlcrMERxNHM4aWUrOStNdUJmRHA5SDd0WmVuYjlQRmlP?=
 =?utf-8?B?RkpYbEhHekI3S3JFR09NcnQweEFNckF0ZTVidjN6dHY4d21FUkp6TXBCc3U0?=
 =?utf-8?B?cjFodW5TWW9xcWlSZUVGdjBwYmJEMTk2ZGFMcVZ5Wi9jRUZKMG50RWNseCsy?=
 =?utf-8?B?aE1NQmhRSTJkV1BGK2grd25JaG1kYkF2enhsM3FWNlRLZDhHTkpOSS9OZytI?=
 =?utf-8?B?V3hzQTRxVHJrdFZTTmRwRHY2ekNpY01WeVRMTmptbTk1b1NUZ2lFT0hYd21x?=
 =?utf-8?B?U1ZSa3NEZFlaeWRtMjdQR2tETjdndDAzdFFRWW5lQXFrL2dGTHJHNEl3OThQ?=
 =?utf-8?B?eWY3cng0elpvR3FaKzN3aGh0N21sbG8wN1ZYTndQRmx3QzZONnRUQ2ZyN0xK?=
 =?utf-8?B?ZlRGMkFsTlc5b3U0M0o4Wm45YnZqNXdYOEphSGQraXVCc1Mvc1hyMjZyc01Z?=
 =?utf-8?B?Zmx0OUxDMld5b0ZaYTk2RXo3S2VsTStxdUJyeGg2VndicHNvZWtDR3F1ZWF1?=
 =?utf-8?B?OWFHSHUySVJiR2VTTjJnU0tveUNpR1NNdmxqTE1HSnFNWmFBdzNzeFZqSlRV?=
 =?utf-8?B?UG16OURST1Y3SFVHZ0EyUDU2QWFaRWVZcE1WT2RLWDNLK2hBeUZtUGltcTM3?=
 =?utf-8?B?aUxsQnl3WFZQMmYzNW9ycC9LUEtxeVRJM2JaaE51ZUMwbnRYN2ozeFAzV1Bj?=
 =?utf-8?B?YVdrR2VGZFhyaGVoZ29zVzZ2ZUVGTTcrUElWbENpMEhTckhLNmFwR0lSa3cz?=
 =?utf-8?B?VHFJL25EblJDcTcyYklldm1ROVIxR2FidW1DeFlWVUU3aDNqeXV4S0hlZm5S?=
 =?utf-8?B?WGpEQmN0Z1VvaUlUUm1JTU9Hb2RFc3lqZ0tpS2ZEZzRLMkRDRml6cEZaaGdM?=
 =?utf-8?B?Vko1bWFlNXlCdWF6RGdoUzNZYUIwOFJ5TUtHUVozWnc5RFg2MHVxRzRiVEZH?=
 =?utf-8?B?dExQWXY2Zy9jM0tncVU1S1hyL05mUk8zSzVLWFBPTFM3UFExNStNYk9PZUZy?=
 =?utf-8?B?UUxOK2dNY3V5SjJXZ1VqMTJVT1BFd0pLWFZtS0xZYmpMUHdRVDBvS3NJbVo4?=
 =?utf-8?B?WXNabFh6WjBZeGprdkNqUkM2NUg4V1B0QjhSa0JtUFhQZVBZZ093Q1NNUUlk?=
 =?utf-8?B?bms5ZkhHNnE3OVQvcnIydmErRWNUVmZ4U0tqUXNkOTQxWFRJVS96UzVVdGVY?=
 =?utf-8?B?QlNPbE4rTHZsdzd2L0tXbEgraEVqQ0pzVzFtR3p4aEZna21oT1ZBQ1dRQVNv?=
 =?utf-8?B?V3Bub1IvM2s3a0FENWQxaTFTQWczZXpBQng4TGt0Z0ZJYUdWUXRsTGZVTzFJ?=
 =?utf-8?B?WTJPa2hmWURoRHlDLzhKN3JEaFJaMWsvVDJYL1NZeTFPRkxaMVR4QXlDTjFL?=
 =?utf-8?B?eUF5aWRhazZjVEFxVHFGN2RPSzhmN1ovcUxDem85bndTWG1BOERFZ05uRUZ2?=
 =?utf-8?B?UnhMVG1vczlhNVdVN3ZpR28zME01WTBoYmxHbnpTWlc3RVNCZFAwVEVnb24x?=
 =?utf-8?B?c2RRdXVhc0V3TXR0L3pVcTZtZHJicEJwRS9hb3NodyswMzJXc1lGNk1tRWpa?=
 =?utf-8?B?Q1h1N01ubmdkL1VRMnBpOWdVQnNxSmlJYzF5bEJKcDArdGRpZlEreUd0azJQ?=
 =?utf-8?B?bS9OQ1ZTWWNSMUpYVjJ0VFNjRnpkVUpBeHMxbXladVNvdDhXblUyY2RrNG13?=
 =?utf-8?B?REt5a2Mwb1ZiNGNLWmhrTDBRb001YTRCeHBKSjlpcUduNnZQNlpIQTllcmhI?=
 =?utf-8?B?Qk96aDJmVkNHdG1HTDNUOHBzeml2L3hSQnliVWF3Y21rZXBXanhSbTBrS0ox?=
 =?utf-8?B?QU9lczEzVlBZUFBaVDAzOTloKzNmSWFDRVMvK25nSUFsK2VKUmptYkJMd3d3?=
 =?utf-8?B?c3N4cjZiTVZOOGhpTE9UcWFrVkdCcmNMK0dHaHg0NnJIL0UrRWl6S3lZUWd5?=
 =?utf-8?B?L1ZpZHNFWEtNU2J2MFZtU3FFYXh5VFUweEN2OU10NzU4dEZlYnNJWkg2MHhY?=
 =?utf-8?B?ZVJtUnZya1JNQ0FKK3o1aHJJc2xSKzJTUmtUeUIwaGplQ3lsM0xEMlV4WkVD?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f21f94-592d-4e52-fd66-08db42869a61
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 16:36:48.8829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FE4krq4bZv4SnDRHZDRiZn8SevZnwKoKsO4LniLo6Q5zSN45SAdosyq9O2HxcvZpyrXrnhiagD7RkoZoHEdoJ0KMKakhxZXspUwbpGvLxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5255
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Mon, 17 Apr 2023 11:34:09 +0200

> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> Port VLAN in this case means push and pop VLAN action on specific vid.
> There are a few limitation in hardware:
> - push and pop can't be used separately
> - if port VLAN is used there can't be any trunk VLANs, because pop
>   action is done on all trafic received by VSI in port VLAN mode
> - port VLAN mode on uplink port isn't supported

[...]

> @@ -610,11 +612,26 @@ ice_eswitch_br_vlan_filtering_set(struct ice_esw_br *bridge, bool enable)
>  		bridge->flags &= ~ICE_ESWITCH_BR_VLAN_FILTERING;
>  }
>  
> +static void
> +ice_eswitch_br_clear_pvid(struct ice_esw_br_port *port)
> +{
> +	struct ice_vsi_vlan_ops *vlan_ops =
> +		ice_get_compat_vsi_vlan_ops(port->vsi);
> +

Deref in a separate line to avoid breaking?

> +	vlan_ops->clear_port_vlan(port->vsi);
> +
> +	ice_vf_vsi_disable_port_vlan(port->vsi);
> +
> +	port->pvid = 0;
> +}
> +
>  static void
>  ice_eswitch_br_vlan_cleanup(struct ice_esw_br_port *port,
>  			    struct ice_esw_br_vlan *vlan)
>  {
>  	xa_erase(&port->vlans, vlan->vid);
> +	if (port->pvid == vlan->vid)
> +		ice_eswitch_br_clear_pvid(port);
>  	kfree(vlan);
>  }
>  
> @@ -627,9 +644,50 @@ static void ice_eswitch_br_port_vlans_flush(struct ice_esw_br_port *port)
>  		ice_eswitch_br_vlan_cleanup(port, vlan);
>  }
>  
> +static int
> +ice_eswitch_br_set_pvid(struct ice_esw_br_port *port,
> +			struct ice_esw_br_vlan *vlan)
> +{
> +	struct ice_vlan port_vlan = ICE_VLAN(ETH_P_8021Q, vlan->vid, 0);
> +	struct device *dev = ice_pf_to_dev(port->vsi->back);
> +	struct ice_vsi_vlan_ops *vlan_ops;
> +	int err;
> +
> +	if (port->pvid == vlan->vid || vlan->vid == 1)
> +		return 0;
> +
> +	/* Setting port vlan on uplink isn't supported by hw */
> +	if (port->type == ICE_ESWITCH_BR_UPLINK_PORT)
> +		return -EOPNOTSUPP;
> +
> +	if (port->pvid) {
> +		dev_info(dev,

dev_err()?

> +			 "Port VLAN (vsi=%u, vid=%u) already exists on the port, remove it before adding new one\n",
> +			 port->vsi_idx, port->pvid);
> +		return -EEXIST;

Hmm, isn't -EBUSY more common for such cases?

(below as well)

> +	}
> +
> +	ice_vf_vsi_enable_port_vlan(port->vsi);

[...]

> @@ -639,14 +697,29 @@ ice_eswitch_br_vlan_create(u16 vid, u16 flags, struct ice_esw_br_port *port)
>  
>  	vlan->vid = vid;
>  	vlan->flags = flags;
> +	if ((flags & BRIDGE_VLAN_INFO_PVID) &&
> +	    (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
> +		err = ice_eswitch_br_set_pvid(port, vlan);
> +		if (err)
> +			goto err_set_pvid;
> +	} else if ((flags & BRIDGE_VLAN_INFO_PVID) ||
> +		   (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
> +		dev_info(dev, "VLAN push and pop are supported only simultaneously\n");

(same for dev_err(), as well as below)

> +		return ERR_PTR(-EOPNOTSUPP);
> +	}

[...]

> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
> index cf3e2615a62a..b6eef068ea81 100644
> --- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
> @@ -43,6 +43,7 @@ struct ice_esw_br_port {
>  	struct ice_vsi *vsi;
>  	u16 vsi_idx;
>  	struct xarray vlans;
> +	u16 pvid;

Oh, or you can just stack ::vsi_idx with ::pvid here to avoid spawning
holes.

>  };
>  
>  enum {
> diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
> index b1ffb81893d4..447b4e6ef7e4 100644
> --- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
> +++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
> @@ -21,6 +21,108 @@ noop_vlan(struct ice_vsi __always_unused *vsi)
>  	return 0;
>  }
>  
> +static void ice_port_vlan_on(struct ice_vsi *vsi)
> +{
> +	struct ice_vsi_vlan_ops *vlan_ops;
> +	struct ice_pf *pf = vsi->back;
> +
> +	if (ice_is_dvm_ena(&pf->hw)) {
> +		vlan_ops = &vsi->outer_vlan_ops;
> +
> +		/* setup outer VLAN ops */
> +		vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
> +		vlan_ops->clear_port_vlan = ice_vsi_clear_outer_port_vlan;
> +		vlan_ops->clear_port_vlan = ice_vsi_clear_outer_port_vlan;
> +		vlan_ops->ena_rx_filtering =
> +			ice_vsi_ena_rx_vlan_filtering;
> +
> +		/* setup inner VLAN ops */
> +		vlan_ops = &vsi->inner_vlan_ops;
> +		vlan_ops->add_vlan = noop_vlan_arg;
> +		vlan_ops->del_vlan = noop_vlan_arg;
> +		vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
> +		vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
> +		vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
> +		vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
> +	} else {
> +		vlan_ops = &vsi->inner_vlan_ops;
> +
> +		vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
> +		vlan_ops->clear_port_vlan = ice_vsi_clear_inner_port_vlan;
> +		vlan_ops->clear_port_vlan = ice_vsi_clear_inner_port_vlan;
> +		vlan_ops->ena_rx_filtering =
> +			ice_vsi_ena_rx_vlan_filtering;
> +	}

->ena_rx_filtering is filled with just one possible value, so it could
be done outside ifs.

> +}
> +
> +static void ice_port_vlan_off(struct ice_vsi *vsi)
> +{
> +	struct ice_vsi_vlan_ops *vlan_ops;
> +	struct ice_pf *pf = vsi->back;
> +
> +	if (ice_is_dvm_ena(&pf->hw)) {
> +		/* setup inner VLAN ops */
> +		vlan_ops = &vsi->inner_vlan_ops;
> +
> +		vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
> +		vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
> +		vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
> +		vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
> +
> +		vlan_ops = &vsi->outer_vlan_ops;
> +
> +		vlan_ops->del_vlan = ice_vsi_del_vlan;
> +		vlan_ops->ena_stripping = ice_vsi_ena_outer_stripping;
> +		vlan_ops->dis_stripping = ice_vsi_dis_outer_stripping;
> +		vlan_ops->ena_insertion = ice_vsi_ena_outer_insertion;
> +		vlan_ops->dis_insertion = ice_vsi_dis_outer_insertion;
> +	} else {
> +		vlan_ops = &vsi->inner_vlan_ops;
> +
> +		vlan_ops->del_vlan = ice_vsi_del_vlan;
> +		vlan_ops->ena_stripping = ice_vsi_ena_inner_stripping;
> +		vlan_ops->dis_stripping = ice_vsi_dis_inner_stripping;
> +		vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
> +		vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
> +	}

The whole ->inner_vlan_ops is filled with the same values, the only
difference is ->del_vlan, which can be left in `else`, the rest can be
set up unconditionally.

> +
> +	if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
> +		vlan_ops->ena_rx_filtering = noop_vlan;
> +	else
> +		vlan_ops->ena_rx_filtering =
> +			ice_vsi_ena_rx_vlan_filtering;
> +}
> +
> +/**
> + * ice_vf_vsi_enable_port_vlan - Set VSI VLAN ops to support port VLAN
> + * @vsi: VF's VSI being configured
> + *
> + * The function won't create port VLAN, it only allows to create port VLAN
> + * using VLAN ops on the VF VSI.
> + */
> +void ice_vf_vsi_enable_port_vlan(struct ice_vsi *vsi)
> +{
> +	if (WARN_ON(!vsi->vf))

I'd use WARN_ON_ONCE(). Otherwise, it may be possible to flood kernel
log buffer (-> CPU) from the userspace.

> +		return;
> +
> +	ice_port_vlan_on(vsi);
> +}
> +
> +/**
> + * ice_vf_vsi_disable_port_vlan - Clear VSI support for creating port VLAN
> + * @vsi: VF's VSI being configured
> + *
> + * The function should be called after removing port VLAN on VSI
> + * (using VLAN ops)
> + */
> +void ice_vf_vsi_disable_port_vlan(struct ice_vsi *vsi)
> +{
> +	if (WARN_ON(!vsi->vf))

(same)

> +		return;
> +
> +	ice_port_vlan_off(vsi);
> +}

[...]

> +	info->valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID |
> +					   ICE_AQ_VSI_PROP_SW_VALID);
> +
> +	ret = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
> +	if (ret)
> +		dev_info(ice_hw_to_dev(hw), "update VSI for port VLAN failed, err %d aq_err %s\n",

(dev_err())
(+ %pe)

> +			 ret, ice_aq_str(hw->adminq.sq_last_status));
> +
> +	kfree(ctxt);
> +	return ret;
> +}
[...]

Thanks,
Olek
