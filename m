Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC2067F2C9
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 01:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjA1AJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 19:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjA1AJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 19:09:22 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FCF8CAAD
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 16:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674864531; x=1706400531;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IEcUEETlMG2tP2K1lbgVvB2eYNuWesiACiXsXzJ12Dc=;
  b=Lngl9aEI7K5WBDpYUrlygWPfVTZiCL4TtrL2wIPn2Kf7RvCOhKsK4ffC
   hW6bNNp1BkLfz40RJdfuliItLDDtjIwcmbG4kLZqib83sLmLD7XnZGphS
   gD/eFtixqnApWYBiyFRLby6p8gqZ0JIEKbV66ovDYI5ClgRwJ+Ll9zSPZ
   JHDRGiMUid6udZlnfkiUKuI8Cob87ItxvyVuqARFzMabFbB/zLtL4trSY
   bYw9lld2d4h+y5JF/y3BYwH8RPB4O3EOzS2J+m6vRt4YkL5MqbqIe5OoN
   ch//XY5y5WWgGmffIMcgA1g0Mo4QPhBVPWNVR6uaLW5NUZeTVz/BbplQK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="389607879"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="389607879"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 16:08:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="665429313"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="665429313"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 27 Jan 2023 16:08:20 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 16:08:20 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 16:08:19 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 27 Jan 2023 16:08:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GX/832fLJSlxn78eJixFTZPuvUl8QlZ7YjK8E71draSHGPUX8sxnMmq/wvhGSJNpRFRNsKUSxtEol500ZqlcwsixBscjf5L1WnA70pUrA0tAdzjtCM0Q2CsAVWGdx/CITO06VtoqxbUazkMTZEAO4yFwd3hTA7UE3cY81YOSFyRVePnSvsNhCM/GVC33XXRHrN4zH/E++mnn1iEF99/p+ejIPdnMREuymRhBG9p9ZlRNUuPwKIv0iw2sdJtgkEeYhSV+knZOEdMcSAq3sFg1iADsrRtKMUEul4xuXyl48qFEIzuh4pCHvynMEwBErlaj4CjOyW2BZvkwiFIBjZ3R4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRGXcTFmBqypctlvcDS/4KbwFJk1B7uZjoaEBpw+dY0=;
 b=PCx+atb3w5hhkwOYEoRy+9MBOkm9GZ/2dQ6eDgnW3Gb39b/3kTseT83xGG9fnmfsPs/A9/V60GKkiu/B90bdyg+0yyBZfpRPB5bZUesGaBORpS4fIdrnUshkW+JduwXbkfAIq8wC9whJJbGoA3I94BVIz7gGTNAybZsRETkNQsshQ5UdGAJWwfiuG5/DCD1AkkUvdZcg7wIrzZ+yTF/VTCwHAjpTJCSsJtKzKH/MexMRLfHglI1DLtK53dnRGdWippmySh3ucwKOF/VqzXbRCucX47PdWXPOi9gRvKqxoGsPlZmao/XxNjDv2rlb93SGpqN2bKfdBsnuPkPgYGDOWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB4872.namprd11.prod.outlook.com (2603:10b6:510:32::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 00:08:17 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 00:08:16 +0000
Message-ID: <86152a35-6d56-ebeb-e436-97426ef08e32@intel.com>
Date:   Fri, 27 Jan 2023 16:08:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next 1/3] devlink: move devlink reload notifications
 back in between _down() and _up() calls
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>, <gal@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>
References: <20230127155042.1846608-1-jiri@resnulli.us>
 <20230127155042.1846608-2-jiri@resnulli.us>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230127155042.1846608-2-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::17) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB4872:EE_
X-MS-Office365-Filtering-Correlation-Id: ca7b1ad0-dabf-4bac-41f0-08db00c3c15c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /yUjdkZrizHWG5gF6/axcH+lUxyDi9rXWaMe2WHXfAeQjKHstWp66vKfRITftdtvwPnaIq2tN7CLnLaetcROCef5ypM69ZswqWYF4bbQs8Y+vuYrQmvwQErFsMwqeDmXzTt2mwtExHt5UEt9k/Pd9CtC+NkPPSMIN/DHx006WMsGxM2ZkjQ3iUND93t+iDHVyQuHxzDvTDg6tF1T38FBrUs7FFf1zD94z7aRaq/CrqmrI7lhG9Qp8JBW5tGI9GZZNMhHC5x/R+mzWoK45xoAcMAHqtScSfPMHTZ2AoG8sCrrXaW04JlbPkJbjmkFwYfY90tiflP5HE2QpYZ/CcfPvtS/LI6bGVcTzHOXd0QJCE3BF8fjX7dasYbKeIz24bvp5Rk0nCHOeL7hpwm5GzJHOZA5XYvcAXwRVkDtSTaE9yhO0sdSs5aRnI1rtH7Z5LuFzoo25BRj4lkCM1ZgWq6xMTDIf8W9LvQXR/bQ7KFZ53A2Tf8QULNAXnRqimwFx097/VzhB7j9IInIBULWKexztJsNiHSGx1/0xTYP9FiWGorpBQcYQ7B1E4HsJCSBLekDXqe9tMFgcC5+nRUB+hL7bfdqfCBWcwsIdt02fJr1LXEelJhFvwTdFaYyVug1RqXRMuEjrRNBqvf+xa1vFJN8Dzsb+QDKtM0oyZQNDYsJcE8SSPLnsMCJfPbrlYr6VqbRCXcTDU+r7r640zd2aFUvcLKExgmaxbm9XwdpXHCRn/+3SKYK03SRQbUlLe067dtE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199018)(7416002)(478600001)(6486002)(2906002)(6512007)(15650500001)(26005)(6506007)(53546011)(83380400001)(86362001)(186003)(2616005)(6666004)(5660300002)(31696002)(82960400001)(31686004)(66556008)(41300700001)(8676002)(66946007)(4326008)(66476007)(316002)(8936002)(36756003)(38100700002)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHJTMnZtREVEOUo0amZVSjBnMzNILzRsNDVWZWorK1ZVdllQQlowd1dMNkdG?=
 =?utf-8?B?aGtiMGhrdll3dlcwN0ljYzIxc1h3TWRJVWFmeUFLTzgxN1gxUVpBZkJTemRH?=
 =?utf-8?B?ZFFJY1pTYVAxS09Od0tkdWdjOVhBV05pcTRmdENmZHRQZllVNVhtOWU5UUs5?=
 =?utf-8?B?eUJwbk4vUFNwREtseWMzbFhNRDBTS3M5RzR6eG5tZmk0WnVJOGJmSHBuUGdy?=
 =?utf-8?B?SnFVTXF4UVlXdGpDZk1iMUR0THZ1TlRicEVyN2FlbHFtNUl5elVoeTJma01B?=
 =?utf-8?B?Z1ZGeWNuTHZVaWh4K3dEd3NZWExSNWc3aldlUHVFOXU0UytjSlVZcXVnSHN3?=
 =?utf-8?B?NmpmbWh4a0ZtNktyTnlMTityaHpFanc2dUJBZkxjYmRSQklHTG9XRUdzV0Va?=
 =?utf-8?B?RVQwMXNjS3lsdzVyZDJKbElOQ1JLZUc3N2JEY09LY0tWRUVXMjRJWHlLUnBv?=
 =?utf-8?B?Z0JPL2VVVjZqWHN3elAxUXNVL1N6YUJ4WjlZRFFxR0dIcjdwTGhBRmxPOFhz?=
 =?utf-8?B?bVRrc1NUVEFFL2wrN1Rqc3hSTUZCTlhGVTU4RHRqOEJ1enJTRWNCQkZkTy9u?=
 =?utf-8?B?Z0k5Zld2VFF1SHJ1QUNiVUhyMkljVDBUOVdvVW9oSUxRdVBtMWV1S2lpSmta?=
 =?utf-8?B?ZWUzUGIrL0pVK25pN2oxQll3UFRiR1diWEVnalFGUUJCbnlXNjNyV2xnOXZq?=
 =?utf-8?B?a2ZuYm54RDQyM0xiQlluQ3c5YzB1OUlNV1BzYWZPS1VPZ0FpMTBlSjRSVzQr?=
 =?utf-8?B?SDk4K1hhMnpNYnJpaWNQMWhDR3lZU2wyOE1JeG5YbVlvV3haN0NXM2ZFR1pR?=
 =?utf-8?B?ZTVkYTl3M2VZOVBxNTlNaVRMVXJnUTNkRFk1UEx6aTBlQ08zTy9MZGRJdXdV?=
 =?utf-8?B?OUJuOEdhNnhrS0c4VWF1bkkrbEJoRTRXL2lBK1lvRDFLU1c4aVNDSU05QSsr?=
 =?utf-8?B?R2g4UVNINDA4L1hOa3RpUk1tRTZyTG0yWUhQMEx2SjJBMURuRkZnMGlJbmNk?=
 =?utf-8?B?bXF4elB0a0ZWZkRiSEw1N0U3L01YcGhydkhaRm5WTTk2WEJhdEEvb2NQRFlU?=
 =?utf-8?B?MVROZHVGUFg3TFRkc3diR0wzcUVaU3hVcFBKRUNuaGlYN2VOZWV2TCtSRmND?=
 =?utf-8?B?VGpHYnF1RFA4SURGWlFOdG5abk53SXZCRisvSUg1anl3YXFDcE5wOC92VTFn?=
 =?utf-8?B?UVNJa3FqaHllWm9LTmxCMlR4QUtWSVlUZjdEcHR6WU1nclN0NWNCZkk2UElE?=
 =?utf-8?B?VWlKM1lzNEJ1S0lSNDdhVWRhTVBoaFo4RGhhVmFWS3BhUUM2QllURTlYdmI1?=
 =?utf-8?B?SVo4VmRhWnVHYmEvK1dBeGtiZkZaUlU4MDQvb3EvNGVOaXNpQkJGMFhDeFB2?=
 =?utf-8?B?bVZuWGxNNVZUc0x6bldPaVI0K2JZOEVjUmFJN2hLRmFxWm04MjlIUE04TnIr?=
 =?utf-8?B?bDd1aUVvekM4WS9aazBYOVRuNThwRGV2VzQvaTNWcjhXNzdPeWpvdHkxRFpy?=
 =?utf-8?B?MmNlOUZBWFkwSWtHOXJWVm1kTytveUUrOHV1UmkzalhaOXZYSnVWNmZGZEVk?=
 =?utf-8?B?TTNzQlgwOFJKRUhQL2hYRVBCRTl4Z1R1T0dtQVJIWS8rcVlERDVHVjcycjhn?=
 =?utf-8?B?OFluK2V1OUNyZ1hPR1BOcDJOalcwMTUrQkJLTG9MVktLTnJYbzBCUndYNjlM?=
 =?utf-8?B?azY5cmM5eE9YT3Y5TndIbEtqTjlQQ2IreE9hVzVxM0dHVFJ0ZjBiMkhkNVJT?=
 =?utf-8?B?MHhYa2JCaFlRL3htcXU0aU1PdWQ0SXFwNDA1UWVPbWlSQXA3cURFbDltUUxM?=
 =?utf-8?B?Wm5lVTJIKzVRSWZPbFFESlR4b2NHTlBCMk5WYlUzSElScXZWdzk0MHlFL0h5?=
 =?utf-8?B?Z3B3OG5LUGIzbEZ1MnpIUTdMbWg5UzMzWFgwSUJHdGhnSzkxMU51Z1VUbFk5?=
 =?utf-8?B?NE5BR2xtSXFqL2xDUDMwTllGYTYvbzF5RTRBYVh2Z3dINytLZXdkNzZhdWsw?=
 =?utf-8?B?YnhPR2ErdVlQL0lVeXNTd21rT1ZUQW9HT3NpS2NjakVvYVFkaVF3VU9jNEpW?=
 =?utf-8?B?WGJnQ0NESXBXN0VzUFdKYlhqUmJyUmZVdHpCVlVHYytFdnM2cmJJcHpURXNk?=
 =?utf-8?B?U1lNUmxOeGxFUEZHMmg0K2Z5NmJPdTVLZnBYeng5TXFoZ0FQUTM2NUhySVhX?=
 =?utf-8?B?WkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7b1ad0-dabf-4bac-41f0-08db00c3c15c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 00:08:16.7446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLOqWAM9yd/Xj4bdjlbx7JmoklS9Q1kZ/cePUl2uWVKeLG+Ifs9gFGQC3OxPIkrY2srw2vjugSfU3gXFnPPqIY4aJCZ9u+Y2JRKzPrFlnBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4872
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 7:50 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This effectively reverts commit 05a7f4a8dff1 ("devlink: Break parameter
> notification sequence to be before/after unload/load driver").
> 
> Cited commit resolved a problem in mlx5 params implementation,
> when param notification code accessed memory previously freed
> during reload.
> 
> Now, when the params can be registered and unregistered when devlink
> instance is registered, mlx5 code unregisters the problematic param
> during devlink reload. The fix is therefore no longer needed.
> 
> Current behavior is a it problematic, as it sends DEL notifications even
> in potential case when reload_down() call fails which might confuse
> userspace notifications listener.
> 
> So move the reload notifications back where they were originally in
> between reload_down() and reload_up() calls.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  net/devlink/leftover.c | 37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index bd4c5d2dd612..24e20861a28b 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -4235,12 +4235,11 @@ static void devlink_param_notify(struct devlink *devlink,
>  				 struct devlink_param_item *param_item,
>  				 enum devlink_command cmd);
>  
> -static void devlink_ns_change_notify(struct devlink *devlink,
> -				     struct net *dest_net, struct net *curr_net,
> -				     bool new)
> +static void devlink_reload_netns_change(struct devlink *devlink,
> +					struct net *curr_net,
> +					struct net *dest_net)
>  {
>  	struct devlink_param_item *param_item;
> -	enum devlink_command cmd;
>  
>  	/* Userspace needs to be notified about devlink objects
>  	 * removed from original and entering new network namespace.
> @@ -4248,18 +4247,19 @@ static void devlink_ns_change_notify(struct devlink *devlink,
>  	 * reload process so the notifications are generated separatelly.
>  	 */
>  
> -	if (!dest_net || net_eq(dest_net, curr_net))
> -		return;
> +	list_for_each_entry(param_item, &devlink->param_list, list)
> +		devlink_param_notify(devlink, 0, param_item,
> +				     DEVLINK_CMD_PARAM_DEL);
> +	devlink_notify(devlink, DEVLINK_CMD_DEL);
>  
> -	if (new)
> -		devlink_notify(devlink, DEVLINK_CMD_NEW);
> +	move_netdevice_notifier_net(curr_net, dest_net,
> +				    &devlink->netdevice_nb);
> +	write_pnet(&devlink->_net, dest_net);
>  
> -	cmd = new ? DEVLINK_CMD_PARAM_NEW : DEVLINK_CMD_PARAM_DEL;
> +	devlink_notify(devlink, DEVLINK_CMD_NEW);
>  	list_for_each_entry(param_item, &devlink->param_list, list)
> -		devlink_param_notify(devlink, 0, param_item, cmd);
> -
> -	if (!new)
> -		devlink_notify(devlink, DEVLINK_CMD_DEL);
> +		devlink_param_notify(devlink, 0, param_item,
> +				     DEVLINK_CMD_PARAM_NEW);
>  }
>  
>  static void devlink_reload_failed_set(struct devlink *devlink,
> @@ -4341,24 +4341,19 @@ int devlink_reload(struct devlink *devlink, struct net *dest_net,
>  	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
>  	       sizeof(remote_reload_stats));
>  
> -	curr_net = devlink_net(devlink);
> -	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
>  	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
>  	if (err)
>  		return err;
>  
> -	if (dest_net && !net_eq(dest_net, curr_net)) {
> -		move_netdevice_notifier_net(curr_net, dest_net,
> -					    &devlink->netdevice_nb);
> -		write_pnet(&devlink->_net, dest_net);
> -	}
> +	curr_net = devlink_net(devlink);
> +	if (dest_net && !net_eq(dest_net, curr_net))
> +		devlink_reload_netns_change(devlink, curr_net, dest_net);
>  
>  	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
>  	devlink_reload_failed_set(devlink, !!err);
>  	if (err)
>  		return err;
>  
> -	devlink_ns_change_notify(devlink, dest_net, curr_net, true);
>  	WARN_ON(!(*actions_performed & BIT(action)));
>  	/* Catch driver on updating the remote action within devlink reload */
>  	WARN_ON(memcmp(remote_reload_stats, devlink->stats.remote_reload_stats,
