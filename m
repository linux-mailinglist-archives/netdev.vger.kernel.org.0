Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338506B7E62
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjCMQ7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjCMQ7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:59:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3B023305;
        Mon, 13 Mar 2023 09:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678726729; x=1710262729;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eYIk+GLGDcvFe9KtQLyLcxCJOJYomTnMp9KgKAibZ24=;
  b=Y4Ai47WwdMgkXM4w0qd9rWxH/53Lsdr7K7xEwLyBSek6W//cAfso/Avv
   /sdpCpzFl6QgA8ngQDPlHId2NOh/tpplu3lgTGkWrtyKPXo8sYbj0Pcbw
   npFbY002XiqWyM3Kpb9s4ulu7R9xunVfDsLa5NW1xWM3CX5VGtNoTNP1v
   QLGy59lrMsiCSdg7d9351Ew5HE6Gju7E1mbmGo0S+s0GC3ZS7mKp92UdL
   QJAnZxoL1/ixVbKC3zeIRk1sTaBGwRx5SjH4sJ70PtBjgKgiR2yeq6j7k
   dQPdDIGxO0YV5FUxKLj15WohcCPYNxn+a5964YAZ1krnvLjoWLlJxTawQ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="334677046"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="334677046"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 09:58:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="628705488"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="628705488"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 13 Mar 2023 09:58:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 09:58:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 09:58:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 09:58:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtSWjZZVMNAAS8KUNqtaKaPX/CxSL4wxHtq36FTaFa2xyS9uJnn5sXfoGIetSufFrczyqViEHPhsPRDnvHkSc/vfwFePe4lKlUdbhbVu9qwreS5CK73N+McisMfcrtyQn/QkAqf6u6Au/XJ1/zKUR2VkGG/MTf18CJh2W3hxnN3LBj6PJVhxOqGUBgnpsAwUlq4fj1m0/nvpWbOdMUSbiZCx7hdMpJKqcPFpFQIUrRihu/oxsEn5M6r7OgFs/UZcTaLx/mFWoFw0WjqRaIaNbyKO77e0Qb2KwwL8mn0uLXaWh2i2r8cXkl23SZsr8rm2gn7uKVokRZ9XfXoCHn4yzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XELMW7Xbcw9vkyq5sMOaUj6GYc85iYW2Hxcrid3mU34=;
 b=hqts8gdEOkSIFgzPUvnkGcu7uPdeqNNQgpLsZLWapcN5yuACHAwmlskGNZFO7PZE+FAat6bvAVgGvyopTgSPuZyjbQJxJiTwWuVzsqPUKBJly01NVIlM5ZYqYrZx4NTMpBIb9NLsEnBogLAScnAlKjCj6W83NfcNdD6J3S9JngiAZyEZgQLadzMOyNnaW3fZSDOxjQYjaGpufpsCS/d2EHNPxHnPnr2PyhFv5m46fd8SiTB2C9Xcwi2pJrhgyttJkxOmqKdTKxWBzSmBxLazdHfrkWiVCAsDxgMubNuv0I67V5FimrlZGp4VuIHGobSp3v+oKqrdIiQGCvrEXBEddQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SJ2PR11MB7504.namprd11.prod.outlook.com (2603:10b6:a03:4c5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 16:58:07 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:58:07 +0000
Date:   Mon, 13 Mar 2023 17:58:02 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Jaewan Kim <jaewan@google.com>
CC:     <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@android.com>, <adelva@google.com>
Subject: Re: [PATCH v9 2/5] wifi: nl80211: make nl80211_send_chandef
 non-static
Message-ID: <ZA9WGhHRqdZKBI7U@localhost.localdomain>
References: <20230313075326.3594869-1-jaewan@google.com>
 <20230313075326.3594869-3-jaewan@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313075326.3594869-3-jaewan@google.com>
X-ClientProxiedBy: FR3P281CA0082.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::8) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SJ2PR11MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: b5ac6b0e-475d-42d8-7269-08db23e41e87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YIvn+lyhdOKDCxRxSdZy3NpZf07FSI3CLRqP6ksZuiG1uTJsgSwX7phiDC/Bey6WgZZ8SttwvG5vXwhmaJkAPrKNV5sCi+WbNNq0LSp7MzPxAIm1sHC/82qKkk1sU6ZGHhcCa6Bog4BK8jdYFXy4kZ0w3IQZgRv8oQItZSUPB/Bsi7MxxqDHmC4+92ICdmbEdQ+AH6fnEKYTQeQIRzK5lh+Oi8lKvvvIsYw4ADViYcw5lrsm1nLfAbyKwGRDfDEEA3W3LW7OnGIiwgikvYfd8WPQyOEYupl2uVsOIAVCxp/w7raKvTpQ0UwGyjXExPDhIsZiupiLbWTPY7VjC0avAit1CCHk3uLUmmr9NhcHx4i3hNtXjJXqs6T7fuBZ2QmfYefMwEuVGj9CpL8f6XAEmRq6EBzs/v1BnKC0IadZ8Jw9FbdFxzkQT4b4uXFozXRx3fWn4pFvjK09t0fEY4JLyL5tSbS9zptzohYvnmFgGiuOpJFuo8hU9pJ7VwlrY+ZbHHHCZHAKMiuzu2LTgFsMhr0sm1YT5+z4FSTDcO29wz/r5K8Kisa3a3ZB6+NeO9S0xJaoImlJ9cdVqcFd11HlVtPv1yURrGN7uxpTmK66zBYNZsymeN2vwSMCXYSU2RPd97xwcvT866TwDW3omWsWrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199018)(41300700001)(8676002)(66476007)(66556008)(66946007)(6916009)(4326008)(5660300002)(44832011)(83380400001)(9686003)(8936002)(186003)(6486002)(6512007)(6506007)(26005)(6666004)(316002)(478600001)(86362001)(2906002)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UmqvOmZFdCafFOeUInQiZkWdTza+DE0NxJdMndx6sbFskps0xFErH7wUshfc?=
 =?us-ascii?Q?NoJGaRnO20NkHrxItX3FXiosKy/8ky2mK/EvDJmpWARnTFKhyI6mQn90qlGo?=
 =?us-ascii?Q?D25zQn14bEgKRIXZ0UlTVM2Gga9oB0lLIZJ3JQzZHBJFxgQJBtaBss49tEZq?=
 =?us-ascii?Q?YK+O1gb/HTjgZoPLmaMqJ/54rJlDEzqWtmeQYWnLXsju3FNj6hrcYEjJPffI?=
 =?us-ascii?Q?7Lv2SUL+IszfniuuJ1x8jXfYMzuT+ZbAXWsJtLqcnImrz4XXpcHRug5VsWKO?=
 =?us-ascii?Q?ITjdXa2pnKaYxPpmLSTw3v3fmFZCwxl1iJgn+U9WECnLsj3SnlEutP9C0LNX?=
 =?us-ascii?Q?hoH6Om755FF06zhnZahbWfGHY2JnPVgBSrFbWDaYLxm/HPGDQX7/kiQ0rijJ?=
 =?us-ascii?Q?cignax0lG9rs/ktLF8D4/oGeEvpuK3NGg4ubg2UMQXZstuNC0nvjMooZXLV4?=
 =?us-ascii?Q?FemK74rX0o+fwJskkMebVkwDAWzfFkyCyUwS2O11P8iKe4qCeUohNl+zo4Fc?=
 =?us-ascii?Q?XyRdR8BQhqxYuZiXI4ucsT9xy25BqFMEd1ruy1d6ksadL6jPlwcffwXDe83D?=
 =?us-ascii?Q?Hu2vMxePqH9sDu8dE7kS4bAp/BVdLKj3fkCvEt0BapPScxbB4PlWpe/qPtJH?=
 =?us-ascii?Q?00kNaHCwK8IA1Si/VS6FnCtvqjLdldlMLjXzpKh/93mY6ZNeoGWiIEeULb76?=
 =?us-ascii?Q?GC+t6ak/mVy4AJHV7ZOUYb1oiB0z3+NFi8ovyHY2+JGZmNPkmAY59/eDBR59?=
 =?us-ascii?Q?M+p+zrBT2TWZPn1Gbpc5HojHTxAxdq5v4KCA5+B2uAsvmXTMuw2+gkG/gB0g?=
 =?us-ascii?Q?yA1j1ZKo0Mnyxmfdt9bQ9gpYANmWbGPoAZC+2V9dNphqwTzU6IYj7WrCaqvs?=
 =?us-ascii?Q?l5NRd8pos5CgQcGU+TlIxEdnrq8E/vdGeuszJFGNosRdwSpZxlWle6nsQRDy?=
 =?us-ascii?Q?vsM80z8wD+sb2OJpRGCZLEO6tfI+Irtc2hbjYXpVFRbdBCOc3paIREHo4vV0?=
 =?us-ascii?Q?Ry0nPGv4zL2MKtSipRTYYBjW+zQHXtuITz/hwUvBjK32omCrnfmQyxSX5HGO?=
 =?us-ascii?Q?6zO3NY+5TWBP4w8FamdZnxxeWkERmixBQUm2n6J2lBGSVnKLcAy+eDTrTjr+?=
 =?us-ascii?Q?jtsZYosDMOXWyOQGJSyVEnHyGtRAVLCSB8XvIc9xutvmv8I9ckCBEkNaQ1mF?=
 =?us-ascii?Q?k7RtWoRUsPQkcJ2SMhyekX+kGq2bC7ie9nYzluDlgDvdoN3rnRATpWYiv95+?=
 =?us-ascii?Q?nq88Z/bD2XCCuGmaHPUL6N8GMmlEtzHSrhQj2BiKPd2MP2jKKKScCdYvB1Ga?=
 =?us-ascii?Q?zmUoWm+HTWcbEc+0NficF2rZXsoOHRhNoZO5zRf3kEuuuHCzGE8mxeNCy8qa?=
 =?us-ascii?Q?7pouatXYBA55dYE86ORON5ECbms6GOH2cuutTZO9p5ZfKqSZ93ttyAie9KTb?=
 =?us-ascii?Q?CpdqloDJ2zISVN6U6Sc0jtHZCqppipqqBc3KHlfsLg3UG1+KcKOKDdTzQIei?=
 =?us-ascii?Q?HgWYpPQJ95cfjhv+Ax4M0JRljMUVlqfOBs1Ou7srXhBXI+ehAJrHYAGchU/d?=
 =?us-ascii?Q?taEJcweucc05gCAZYOC3aPzM4QJ+ZcT5K08nBrJRE9Nr+fUIGlu1Sq5XeNVG?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ac6b0e-475d-42d8-7269-08db23e41e87
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:58:07.6172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k353RCso8qyCbXI0YfS83yfVVPhH5f9XBwDIq35vQfvwbN+eCt/2IE9Eh3Yd+1Rmvzald+SQAPL40DuB8BbN9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7504
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 07:53:23AM +0000, Jaewan Kim wrote:
> Expose nl80211_send_chandef functionality for mac80211_hwsim or vendor
> netlink can use it where needed.
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>
> ---
> V8: Initial commit (split from other change)
> ---
>  include/net/cfg80211.h | 9 +++++++++
>  net/wireless/nl80211.c | 4 ++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index f115b2550309..bcce8e9e2aba 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

> @@ -938,6 +938,15 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
>  				  const struct cfg80211_chan_def *chandef,
>  				  enum nl80211_iftype iftype);
>  
> +/**
> + * nl80211_send_chandef - sends the channel definition.
> + * @msg: the msg to send channel definition
> + * @chandef: the channel definition to check
> + *
> + * Returns: 0 if sent the channel definition to msg, < 0 on error
> + **/
> +int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *chandef);
> +
>  /**
>   * ieee80211_chanwidth_rate_flags - return rate flags for channel width
>   * @width: the channel width of the channel
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 112b4bb009c8..1fd9e6545225 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -3756,8 +3756,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>  	return result;
>  }
>  
> -static int nl80211_send_chandef(struct sk_buff *msg,
> -				const struct cfg80211_chan_def *chandef)
> +int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *chandef)
>  {
>  	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
>  		return -EINVAL;
> @@ -3788,6 +3787,7 @@ static int nl80211_send_chandef(struct sk_buff *msg,
>  		return -ENOBUFS;
>  	return 0;
>  }
> +EXPORT_SYMBOL(nl80211_send_chandef);
>  
>  static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
>  			      struct cfg80211_registered_device *rdev,
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
