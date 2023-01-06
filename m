Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6470066054B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 18:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbjAFRGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 12:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbjAFRGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 12:06:11 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598427D9DD
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 09:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673024737; x=1704560737;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zBOsKJ7Ff2U4fzQdlYF7eQS0IyW7ZVXYqWbdTS2/M+w=;
  b=GrIeiMLo0vP1GYf38KWBW3RkHU+5qP2egZl0ZaoufUQZUJYY9mmIcN42
   EZw1hCRXTvJfKeVjOYyzLEMbyBQFDf1YmTLCuQCK60hNuyG5nQ+G+XIKp
   SYPNEK9L8AM12A008H+949GzVNBgKL5N96JgmvABCuYOruMO6rahNFbtv
   JaXd75z7zyQhJWKRC0KTNqhE6Xdl0mN7VPHjyQVlJuL0uapIuHoXeTZ5O
   P+p1EKyrXDDEv0BfuOwmsNs8pprRicc1VwQI6hbpLl6NiUbsKvQxBQ0I8
   xmLUQUZCTsAjR/CND3C4LLZS/uJ7vmhEqxBCOL5b/YknKlDrw3qbgGEtc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="321218533"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="321218533"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:03:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="686523915"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="686523915"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 06 Jan 2023 09:03:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 09:03:23 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 09:03:23 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 09:03:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OV4BW7lVOKtxLf3mENuVB0m2zZcfke3ga9LoG0yUfqF5qFfOZv+1CrYMgxQcZbnqXfnwaEoBGbC9vuIrIdU13qJcgrBDmi/xxX0bJfRwKd9L4FVAKKjVPUAEUtr9HDX6k1BQ1uN050Uc6XvCVHIZ7PgbFgs7MxIUf3tD4Jsjzc9DbEFzP2D7eCX7H8siy2b++WMcDaLwodPDib1+NgFtgsdsf6UbUXtuX66m/fKPH5exfA4hM3ZFVO9LtCd1RcS5iePYTNx3posaNuLsksowTl+7AdkmIl2prvdnRJQ0RTbrs0c5jrpkLPc9CXBm48eRXhzqTcE1+/bZ7PCeI7RlhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2LArFzefYT40moIvbjtHHqy7ujJVlEiFhrF/s3Hbkw=;
 b=CZGPEoY3NKjZxOHk+GdTxRToI+6BWCUM4qcKLtRNSULiU9PDd9VxFj5u+OHk4YSsqE9Tuc+h/qYNXVMyZnpwpqfb034Y3R45bnV1+24gYyl6lgMfQsh3ZQngs0e+1boIpRWSlRMMaEUhNGvS5v6DzXZGpxod0E5u/vuovOMk7//3U8sLVmg0CBqzzPaL21EBX4tSgRWJQdIshElzYWjDh95sDTuwTSoElbxjyYCXbR/56tzsFWog2LSTWpJtiHIodLu20J8XNJ7XvU6xoV2hpNH+a0+lmO7uw1apx8/SgdgA85J0V6iWnSIAVaWAE1hI2bCZ2RJ+9M/qJPvu+M9rgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB6608.namprd11.prod.outlook.com (2603:10b6:510:1b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 17:03:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9%7]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 17:03:21 +0000
Message-ID: <9f408a8c-4e23-9de5-0ee8-5deccd901543@intel.com>
Date:   Fri, 6 Jan 2023 09:03:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 4/9] devlink: always check if the devlink
 instance is registered
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-5-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230106063402.485336-5-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0366.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::11) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB6608:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c8c556f-bce8-401f-f611-08daf007e9fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ewLIHLD9f4eJWKXgU2ZDCcIS0K3jdB7Wu+w3X/Hw7Ae/NXMiVx7OtQhNcrn+uO6DZrLWO4xzGJPioKOaCnsaGala8WBJ+zqVk1HtHjM3LkBAn8XtJV5VwWHoxidUn4DhLt2yHEKyuBX0ZhZZ0bd6jEdc5LmJ8zaRaCC3Ky80AsSEPEJt7Prf5RJayJ0QVcYVVa93IMaQc1dEx3UmI6T9okwwEHoDYJKFO+s42FCxFY6aKFUO3INJ6gNFmYp4LqbfrdoZnUOIduFMPxsxcTLsDZmqFuKrQ/BF4oxfbRfTd6MtY3/souUAiGvAmymtrwSIYz5UTCwAoFzcx4NZSNOUhseodQQ32qdeR0LtGKxbURHqgw8aL02XQu10jKDS9BYkIIMmH5gBrUWv8biF7EAZiUIhe4vCGmiibEokbBRGW5pDmzSHbUJVdoUPStw4VbvygipXLekMyWXRx5qIKwwl2JKlzFZNSwipmM9TrXcrnoNahEvv9sGjnJR/7oZ9TqiMpsbaLN8qFjsS1QVGtM7UWG8frgY9UIUIHtVHB5RhiSEY66T5IwHoWnGXCM4HhWJNfWVafI13Gtfnnrk86NkoH8kAqpuuxjYVdFaJRrGdl1gkDbdC5dI2F3alEBPQ+JZvCK42yqCufK6gf1RaOWgP3OZmeI9TQ4x4e3ny8LDaX0Ilgrffaw4xnFTXfFHbWLW3SDlleV5N5tGkTs/lB5xvfdfcP+Dw+tZRJn01gj5XlZY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(41300700001)(8936002)(66946007)(8676002)(31686004)(2906002)(4326008)(5660300002)(53546011)(6506007)(6666004)(66476007)(478600001)(66556008)(316002)(6486002)(86362001)(31696002)(186003)(26005)(83380400001)(2616005)(6512007)(38100700002)(36756003)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlRjdGVYemhFSnduWEFUbzk5V3VtWHl3ZW4xNHV4RmM1a0g2QXRyODZLRWNx?=
 =?utf-8?B?a1ZSRWhjc0YrMFN1NnB6dTBGbWxLUlp0UzE0Rm1IaUFGRml3Nno3RmR4aVA2?=
 =?utf-8?B?amV2UWdTRGtWYlQ2Vjl3TmxzNHJBV1d6d09TeFFWbmJXeVM4QldqcURHS2E5?=
 =?utf-8?B?SXF3YlV0WVorVnhDWmhvTkZCdHlzMzZacVNnWWM5YlFaRHB0OHBWcmFZZ2sv?=
 =?utf-8?B?QmIwYkxkYkM2UGtYTkZVNkVlQlh2eTgvTk9jSHNSbWNMbFhMS2xUMldsVXph?=
 =?utf-8?B?aFRpcGlhTitYb2R4c3U4SE95dTZBQ0pHaXNRZnlqaGJRUWVibTA3TVZ0Q21r?=
 =?utf-8?B?anhqWXA5UVF0WlZTQmlZWnJDN1FHVnVHQ09ncmtnSWRXdGtTT2pLSnZmeTZ0?=
 =?utf-8?B?bHZkU3NhQ0ZjYW9BbEtVZG1Nb1FxWXVXOUNqeUlwN2Jtc0hWbEJyL3cxYlMr?=
 =?utf-8?B?VThRNWRkRE1NY3ErSUlZSGUwQ3JSanlySkNQSUlDWm43MTdydXdpc3U2c2pP?=
 =?utf-8?B?NnRxb0dNRXAwSVd2NlcvYTFjcWphemRNZFJ1OHl3L0ZoTVBBMW53dHQvaWky?=
 =?utf-8?B?UFA5L2pUOWtWUEZTL1VmQllSVmlISS9yT0dSbjdvbDNOUFQrblIyL28xMmRB?=
 =?utf-8?B?NGw2dXJnUm0veTZiSmM4M3p5eVF5U2d4b0Z0dHdtNEQwaG92Mm9TcDhiWkh4?=
 =?utf-8?B?OUFQZnhpY2htanZtM1UwNUM3bTROZ0l6NVkvcWF6VkFPNXVSNDRlTWZGTFpn?=
 =?utf-8?B?MHhORWZITmRtbXk0YmN2Y0NLSGUxc242aHFlVmNQRGMzTXA1Z1F5TEU2azdj?=
 =?utf-8?B?WFlFOUxBa2g1enVBUzBiejl2WUw5RjJnSkF4a2hzRnp3Y1J6TFFCSnFBb3RX?=
 =?utf-8?B?ZVgxd3BySnBYT1FJRkxoa0hFMGdlTGcvWTh0WFhaWjk1RysrbjI2bVBaWTlV?=
 =?utf-8?B?K3dkRlkxcWFGRWFCeEh6N2V5Nk1hNUl3OHM4WkJRVWZ3aXNleUlkZTJIWXpk?=
 =?utf-8?B?OE9KZlFaZEQ4aEpmU3R0N0VhOStRUnNqYVhrSEtVMUp4MDQxQStsUzZPRjY5?=
 =?utf-8?B?LytFN1FIM05HVkV6QWY4QTBkVzB6dCtOZTl5SW1YRGVicU40L2xiWTFCYWcw?=
 =?utf-8?B?UTQvejhKQm5nU2tKK0VZY3U0d3Z0VVNaeEVFSWYzbFVGdjdsekh2SjRBYUVB?=
 =?utf-8?B?N1B1akxub252R3NhbnRiYmJNVGc4TVBhQ1dXeDllZExUNFA1blNqR3RxS3I4?=
 =?utf-8?B?dkk4Vjd6OE1YcUM3T05Vd2Ftc0F2TUVPOU5nUm9sZVpZVm1MWWVkc3lFTVZq?=
 =?utf-8?B?eGZ3Q3Vlcmt3L2UxNDE5cFR4TnlZSkVEcWZ5NlFjMVh2aUQ4aURQZHdzZ3hE?=
 =?utf-8?B?bXVTNVpOYk5RSTMxKzluSitpcm5BNUFRdmJLVG9XS0pwaVpRTzQ0Rno1Rmto?=
 =?utf-8?B?T0drbzNxS1dQMlhtb2ZNM2NSS1h5aVd1K0VaWHBNMkl6TndCU2l2UGdNZEtz?=
 =?utf-8?B?QWF4azcrYThyVW9pRHFZMDExbGVKWmhtOWpWeGdSNm5DeDdIRTNRU09ZZlVm?=
 =?utf-8?B?eHh6cHZ6Mnh2RHB1WVh0d2c5V0ZLWDVBL2hvLzZ2RnpDOUd5Y2duSmE3MDkv?=
 =?utf-8?B?aFBVdThjUlJkN0ZFVkRVdGw5aWNTUXdoTUR6MXFVRjlMVEpsUUV5S0NzWmdm?=
 =?utf-8?B?Nm5SSjJ2akhqUklPUnpSZjdrNW4yS1ZwNUxIWUg4SUNoVFFEWFBPT0k0UkJ3?=
 =?utf-8?B?ODV1U0pxdHRnKzAyZVFZc3hxMHFoQklEMFR4cWdHSlJwNjNnLzlSUE53YWN6?=
 =?utf-8?B?SXJzUmsxaXc5YlRjSUlEVFhyV0tWWXRybXN3Uis5VUtHZ1lVa244WUhWTU5Z?=
 =?utf-8?B?ekNZRjcyTDBnVWJwRGdnZXRNZkFZNzRTYmhaQWdSa0VibVFEQmF5cm9YMU5k?=
 =?utf-8?B?Y1pHQ1dWRWJ1WTVWakxZamlkME5iZkhLYnRha2EvOW1WZjVMSHRGNjY3bHhp?=
 =?utf-8?B?RDB5TVBlU0ZjYnpHR0dPZURvQzRaa1Fxd0UwS3hvZmRVMDFWYWhURERjN1Rk?=
 =?utf-8?B?bjBoSndoS1ZzRkhpcm5mM3JWQjIwOTgwQzl6S2JQbVRuenQ0SFRRNWcxRFJH?=
 =?utf-8?B?eTc3UzczSm51UzBzUXhWRHdKMUpxa2kwdXJicDk4ZExXdHZuVjRwNHFEaWo4?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8c556f-bce8-401f-f611-08daf007e9fc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 17:03:20.9171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtQXcEJJutbWBV5mS5jIPslUeM+znws5Dm19gv2Zb6BQJjWtPwQjvvAzG4MKbKubazRQ29WsNKwNuaWa/LIMzie6zISG9Rxyx3ugAHUYsRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6608
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/2023 10:33 PM, Jakub Kicinski wrote:
> Always check under the instance lock whether the devlink instance
> is still / already registered.
> 
> This is a no-op for the most part, as the unregistration path currently
> waits for all references. On the init path, however, we may temporarily
> open up a race with netdev code, if netdevs are registered before the
> devlink instance. This is temporary, the next change fixes it, and this
> commit has been split out for the ease of review.
> 
> Note that in case of iterating over sub-objects which have their
> own lock (regions and line cards) we assume an implicit dependency
> between those objects existing and devlink unregistration.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/devlink/core.c          | 19 +++++++++++++++----
>  net/devlink/devl_internal.h |  8 ++++++++
>  net/devlink/leftover.c      | 35 +++++++++++++++++++++++++++++------
>  net/devlink/netlink.c       | 10 ++++++++--
>  4 files changed, 60 insertions(+), 12 deletions(-)
> 
> diff --git a/net/devlink/core.c b/net/devlink/core.c
> index d3b8336946fd..c53c996edf1d 100644
> --- a/net/devlink/core.c
> +++ b/net/devlink/core.c
> @@ -67,6 +67,15 @@ void devl_unlock(struct devlink *devlink)
>  }
>  EXPORT_SYMBOL_GPL(devl_unlock);
>  
> +/**
> + * devlink_try_get() - try to obtain a reference on a devlink instance
> + * @devlink: instance to reference
> + *
> + * Obtain a reference on a devlink instance. A reference on a devlink instance
> + * only implies that it's safe to take the instance lock. It does not imply
> + * that the instance is registered, use devl_is_registered() after taking
> + * the instance lock to check registration status.
> + */
>  struct devlink *__must_check devlink_try_get(struct devlink *devlink)
>  {
>  	if (refcount_inc_not_zero(&devlink->refcount))
> @@ -300,10 +309,12 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>  	devlinks_xa_for_each_registered_get(net, index, devlink) {
>  		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
>  		devl_lock(devlink);
> -		err = devlink_reload(devlink, &init_net,
> -				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
> -				     DEVLINK_RELOAD_LIMIT_UNSPEC,
> -				     &actions_performed, NULL);
> +		err = 0;
> +		if (devl_is_registered(devlink))
> +			err = devlink_reload(devlink, &init_net,
> +					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
> +					     DEVLINK_RELOAD_LIMIT_UNSPEC,
> +					     &actions_performed, NULL);
>  		devl_unlock(devlink);
>  		devlink_put(devlink);
>  
> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> index 6342552e5f99..01a00df81d0e 100644
> --- a/net/devlink/devl_internal.h
> +++ b/net/devlink/devl_internal.h
> @@ -86,6 +86,14 @@ extern struct genl_family devlink_nl_family;
>  
>  struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp);
>  
> +static inline bool devl_is_registered(struct devlink *devlink)
> +{
> +	/* To prevent races the caller must hold the instance lock
> +	 * or another lock taken during unregistration.
> +	 */

Why not just lockdep_assert here on the instance lock? I guess this
comment implies that another lock could be used instead but it seems
weird to allow that? I guess because of things like the linecards_lock
as opposed to the instance lock?

Thanks,
Jake

> +	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
> +}
> +
>  /* Netlink */
>  #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
>  #define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index bec408da4dbe..491f821c8b77 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -2130,6 +2130,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
>  		int idx = 0;
>  
>  		mutex_lock(&devlink->linecards_lock);
> +		if (!devl_is_registered(devlink))
> +			goto next_devlink;
> +
>  		list_for_each_entry(linecard, &devlink->linecard_list, list) {
>  			if (idx < state->idx) {
>  				idx++;
> @@ -2151,6 +2154,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
>  			}
>  			idx++;
>  		}
> +next_devlink:
>  		mutex_unlock(&devlink->linecards_lock);
>  		devlink_put(devlink);
>  	}
> @@ -7809,6 +7813,12 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
>  		int idx = 0;
>  
>  		mutex_lock(&devlink->reporters_lock);
> +		if (!devl_is_registered(devlink)) {
> +			mutex_unlock(&devlink->reporters_lock);
> +			devlink_put(devlink);
> +			continue;
> +		}
> +
>  		list_for_each_entry(reporter, &devlink->reporter_list,
>  				    list) {
>  			if (idx < state->idx) {
> @@ -7830,6 +7840,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
>  		mutex_unlock(&devlink->reporters_lock);
>  
>  		devl_lock(devlink);
> +		if (!devl_is_registered(devlink))
> +			goto next_devlink;
> +
>  		xa_for_each(&devlink->ports, port_index, port) {
>  			mutex_lock(&port->reporters_lock);
>  			list_for_each_entry(reporter, &port->reporter_list, list) {
> @@ -7853,6 +7866,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
>  			}
>  			mutex_unlock(&port->reporters_lock);
>  		}
> +next_devlink:
>  		devl_unlock(devlink);
>  		devlink_put(devlink);
>  	}
> @@ -12218,7 +12232,8 @@ void devlink_compat_running_version(struct devlink *devlink,
>  		return;
>  
>  	devl_lock(devlink);
> -	__devlink_compat_running_version(devlink, buf, len);
> +	if (devl_is_registered(devlink))
> +		__devlink_compat_running_version(devlink, buf, len);
>  	devl_unlock(devlink);
>  }
>  
> @@ -12227,20 +12242,28 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
>  	struct devlink_flash_update_params params = {};
>  	int ret;
>  
> -	if (!devlink->ops->flash_update)
> -		return -EOPNOTSUPP;
> +	devl_lock(devlink);
> +	if (!devl_is_registered(devlink)) {
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	if (!devlink->ops->flash_update) {
> +		ret = -EOPNOTSUPP;
> +		goto out_unlock;
> +	}
>  
>  	ret = request_firmware(&params.fw, file_name, devlink->dev);
>  	if (ret)
> -		return ret;
> +		goto out_unlock;
>  
> -	devl_lock(devlink);
>  	devlink_flash_update_begin_notify(devlink);
>  	ret = devlink->ops->flash_update(devlink, &params, NULL);
>  	devlink_flash_update_end_notify(devlink);
> -	devl_unlock(devlink);
>  
>  	release_firmware(params.fw);
> +out_unlock:
> +	devl_unlock(devlink);
>  
>  	return ret;
>  }
> diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
> index 69111746f5d9..b5b8ac6db2d1 100644
> --- a/net/devlink/netlink.c
> +++ b/net/devlink/netlink.c
> @@ -98,7 +98,8 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs)
>  
>  	devlinks_xa_for_each_registered_get(net, index, devlink) {
>  		devl_lock(devlink);
> -		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
> +		if (devl_is_registered(devlink) &&
> +		    strcmp(devlink->dev->bus->name, busname) == 0 &&
>  		    strcmp(dev_name(devlink->dev), devname) == 0)
>  			return devlink;
>  		devl_unlock(devlink);
> @@ -211,7 +212,12 @@ int devlink_nl_instance_iter_dump(struct sk_buff *msg,
>  
>  	devlink_dump_for_each_instance_get(msg, state, devlink) {
>  		devl_lock(devlink);
> -		err = cmd->dump_one(msg, devlink, cb);
> +
> +		if (devl_is_registered(devlink))
> +			err = cmd->dump_one(msg, devlink, cb);
> +		else
> +			err = 0;
> +
>  		devl_unlock(devlink);
>  		devlink_put(devlink);
>  
