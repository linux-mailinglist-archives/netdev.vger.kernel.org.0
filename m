Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D186DE758
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 00:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjDKWgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 18:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDKWgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 18:36:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1D6E54
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 15:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681252581; x=1712788581;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=m/e9+ONBI0S7KgRs7HRQer1n6JTjgX8MEvyUhR/Art4=;
  b=jJWskciItg6OVkxNBudeuM5ZXUfb2N5kjU+iievFAz/V4BSrPj2faXwS
   IG+1yhYnp4bzkxVKmY9YwXvmaSOD66ky8cuwpUNUU+CB7XbCMsPYa7Mil
   6vacYO9SS7dLIZiVmYjpS0hgnKz7i5Ks+9OZeXSJwnn/httiN0ROfweHO
   wNTr45d9DLS0RTXJMYuJDiI/h2/3CPJbYreorOUydkmOPtC+rtDKv4uaB
   43sH1nGKKGSQ/ebafigvXXWBNpoV5vAXO0KqOlfT0UgPLbOlxa2Bw42XB
   zeXbpw1UmNN+IF/2DZxgFhu9Yfj1MofXnq0YqRTv677/xmGze0MEW+Nxe
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="343755192"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="343755192"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 15:36:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="721351935"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="721351935"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 11 Apr 2023 15:36:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 15:36:20 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 15:36:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 15:36:20 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 15:36:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beaGkeCVK7ll5N2LC+zgMYahO8Mfd89kZ8DlIhxF6qDDVM4vb8VuUM7ywoMa+L6PZTAefUgmsoxblEQoTEbUp4mPtyPNkUtr8M0ixd4enRA32NNmYEeJ/8Xzb3iGcYXmRP3mXflc3hU1h6aCAIOAplOh89jEvgc70Od+BAg23d62WiRh6zw+D0uT6J90kM9O06/L+/o7PtMplsWKz0M+FPoPKRhg8xH/8uKorA3riHDbj8BhV1ByWttbwq4fbnVfjksh1KSDQLplm3gyik/1jawSHeFSGAqaa2OWGoYdPa3NzTHbqJOYB0RKwFr5SEdV9oAp6KK8CQxnokFM13uOaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bI6ke57FuujX2WK6iM814zquky+YTxluBerBTIJFYAA=;
 b=AuiBv89N+3ET2sUnctEuC8z/EOTjiZIpzdDlQ8v/jK6Z+eAh2OfnVKOqxMbJ6zLNrt2iAG6OxS7/Apd9l2UoaxV9uQ5DnKMKJHzQVayVFzg8NuhKeHMjyEijYfdEsG/y2C9szyYQn08l7M5sYpei8RCDX4/NysFmkaYN5y7P/wq5+2Trj19BdXR08oWqR+86zD/9OUsa2QjQhcDgr/Qb+rsKTXRcXqCzI5C2OPrIAR/NSFCDBOT5ffIpYvtsBgp4+sZ6lwYVqbV9/wBMnKIzdBaEqe6ihajCtpk5QdeI59xepO7o6G4mFZgFeGhcEPwgwsTjvboq/bOg68VFJNRKjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB7045.namprd11.prod.outlook.com (2603:10b6:510:217::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Tue, 11 Apr
 2023 22:36:12 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 22:36:12 +0000
Message-ID: <f1e8853a-c510-a898-cb3f-e99f17471269@intel.com>
Date:   Tue, 11 Apr 2023 15:36:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
To:     Corinna Vinschen <vinschen@redhat.com>, <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, Jose Abreu <joabreu@synopsys.com>
References: <20230411130028.136250-1-vinschen@redhat.com>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230411130028.136250-1-vinschen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::33) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH8PR11MB7045:EE_
X-MS-Office365-Filtering-Correlation-Id: dd35a4fa-6e0e-4bd4-c6b2-08db3add26e8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S8ZdmB1EF+zCaTyGAO0ZAinQ3MXY9KVJOt7AbI696ycDtXPesQYIX4MZ0nU4HzlHA8ey0xaOMJgCTXZsCyA61YFRl0qnI7DI4yC89CtI9yatn0F2bW5wWShR4O88mjxdZ+ZkmlPFf//U47ZS4W9+1sAbibM0gQ9pWuwWWUdBTTPLvaun6ORQvwQRp+nBOdIrGqXIHeGupHeQ72T0HXW0JUuDTw6aJYG9ki9T+L0SyEQ4m6wJuH7z09fHnFCnWNS+LNK0rczkYS/GuLv1JrTg47dIYacpNKWypGJNYmb6bHpig5NUvEvdG5gCTqoGiLbMfAdhgYVtZQHbr6gBsf6IwQTXCkdMv8K9zjysULI60rSNiVWHEj4AvkFpbxfZyCjBkptWi/nqtY7DT3kMqcqpXvJR02SpdwIfDDE5fEws+N+TOdjYjMQKrNXUzOVcdGWg8MS+0QZaAfMzfdhJjQz3slARNozeRD9/fjS+efnsyypYQBuaHHknvTH67vgtNkX2Qgp05h54R8ZGID38/2yaySCON6UOnKLywhe6bJF2pbaIixQ1nW+6xNK4uGdzryOSXRSb2kJKn+tUHeMolyb+Rfk3qhnN90eMyQSSIe4WzhUvD3oNxXH8WFqHbvspZFt54XMo9YK+2zoFdQYbvukgZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(346002)(366004)(39860400002)(451199021)(2616005)(8936002)(66476007)(86362001)(66556008)(8676002)(66946007)(31696002)(6486002)(478600001)(38100700002)(110136005)(316002)(36756003)(41300700001)(186003)(5660300002)(82960400001)(31686004)(2906002)(6506007)(6512007)(26005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2E3R1hrVjAyYjlFajRVUmNVeElabkNsQWMwNlczN01ZN2c2Q05ZOVp2T3U3?=
 =?utf-8?B?NkRvTjlRQWpBWnZNTDQ4K3dqQ1FvSFJvWXZrcEVjNmtGWHNic2dscUhUQ24y?=
 =?utf-8?B?YlhhS0k5dDVoRWNvZkRWOFlFaFRVWVpFK0xPSEpjL0thVENlZ3g2RFJQNWRI?=
 =?utf-8?B?RSt3MHBqWkMwT0I5dnMzV2hEUDVRNFd4Z2ZrWjlQODRXWjVBdTg2OXRneXFY?=
 =?utf-8?B?SmFBTGI2ZVVFQno3Y1pxNEUrTEFvOVgxbmpFRWxtZjFQWEpLNUQ4ZVkrUnBF?=
 =?utf-8?B?Qll4QTBSSTNYVytJRjh0WkphSWhOdk1qblVPYit6NWFubzNGWk1oVUV6WUpv?=
 =?utf-8?B?WDFkTUJIQ0dYNE90UVcrVlpYN0xzckhlS2laUHJna2p0Yk9VejJPcTN5aElP?=
 =?utf-8?B?WmIvVDB3K3VEUStBcFNsR2FxSm9lTDNmMllETWNRVm5CQ3lpK3N4UEZWN1pG?=
 =?utf-8?B?UHNqcTBGVDkvVCtGa044K3crQWlsVUNVSXhUUHRtWURkN2ZUMnNLdUxJSEo2?=
 =?utf-8?B?TW9uZjRYaWlvUjAxSDJQMkc4N2VpTk5JU1RLSE9DcitsODdsMFNtNkNkNzhX?=
 =?utf-8?B?RndqS2NYcThxUHRXT1k1UmpJMVdqN1htajZFWDJ4aW1ML3NmVWJPV2Evc0dF?=
 =?utf-8?B?Yi9MZ3A4dzNxZzVLTkVVUGR5NzAzVlVIVzhmY1N5RlpTMm8rTVY1aDFyYmhX?=
 =?utf-8?B?ME85Qm90eDBkdkIrY0dOVHFhdWh2ZUsxcGJKVTF5bUlVdGs3c1dTcmpVc09H?=
 =?utf-8?B?UE0yelU0YzY3eDkzM21zSEtoYjh6cG4rYTFsSERxeDdBK2RvZnFJRDhsYVJR?=
 =?utf-8?B?MStOYnk1ZmN0b3FZVndrLzlqWk03OStpV3BIM0EybERkMnQzOWdrSWZYblli?=
 =?utf-8?B?WVFtUmMvWEJuR1ZPZ3JERC9iTkg5VmpGcWNvVklsaWREN21lS3BubmhkTGVW?=
 =?utf-8?B?bWFIMHFCVkJ0TW1ERUMwb2lQWUVvelBHUzA0ZlVpQkNqcjYwWFJRSEYxU1Fm?=
 =?utf-8?B?Y01FMDBCa1VyOUQ3aHFkWXk1dmlwRWpvWWNOVUVqdTNvbzVla2lvOXhadjRF?=
 =?utf-8?B?b3ltSTZIc0lhaHA2dDZuYlBDSjNRNjV1ZXl4YVIwbk4rRVN0c1F0TGpxeEU3?=
 =?utf-8?B?S0RuenhVRVFNaHVrc1plckp1M2dSTUZnT25XUmhlTGtYVk54RnlrWEx0NU1H?=
 =?utf-8?B?VmFKNTEyd3JzSi9Nam1seWNhSENtUUpGdHZpNEw5ZnMvSXBiK055N2JsdEkw?=
 =?utf-8?B?bkNFZnZiQWRpakxLSndEQnZBQWhzaTBHNlYvSlFhUWR4M1pid2E4T2sva1lO?=
 =?utf-8?B?MFVVVzJ0YWxJMHNqbytGQzhMRUlHNFpQdkQ2TEU1LzV6YzRsY3FLT1hlQS9u?=
 =?utf-8?B?c1g0ak9sWGRTNVdCa00zeHRvUkZ5WTY3VjczUWM1ZjlpZUx0ZndRUndKd1lX?=
 =?utf-8?B?UVJ2ak1pbkFOL3drU2RRV0dKSENyVks1NHRZTHNxTkFzcTdDNFlrc3lSK2pS?=
 =?utf-8?B?emsxbS9LTmtSVEp2ZUNlMDc1NEFFUU90M0Z1VU00UU1ER0NwUTZnTWQvT3ZX?=
 =?utf-8?B?b1M2azRHOVJjbWw3TWt5Y0E2RENoV1JmZ293U3ZYVDUzMHA1NXdGNmQxQ1B1?=
 =?utf-8?B?Vm83OGlNZ1AwcVIxbUpIYmZIUkpSU01CaGR0bEJsMndxbElYbUpXMFYvU0RQ?=
 =?utf-8?B?SVd2U2RWd0xaTVlTOWlaZEVGaEYzWTlCcTFZRTVldGVLZXgxelF0bFBQeDJV?=
 =?utf-8?B?ZU5veGFNZllQMTFDVXBKRWc1YnZnVlVzam95MVRCM202YkQ0bWQzbDZVT0Jl?=
 =?utf-8?B?ZjFmMFp2cjNudHgzQ0tXOGJuZHhkamhrZ3JOWXl6R012bGlYSWFYc2ZDRisr?=
 =?utf-8?B?YURxSVN0dDJiNkxLSUFMVjlvVlJlUnczdjJkbVJEb0ZlNUt6dEtSZng1SXB0?=
 =?utf-8?B?TW5xMTBldmt6Rmx3T2pLVkt3TklNWFhzMFR4TkZVdCszb1AxSWp3M1dLak9S?=
 =?utf-8?B?YTk5TWd0ampTbGowendaMDNlZUE0eTNLOEcvSlI0dmdiVHFqanhQWG0xblg0?=
 =?utf-8?B?Si9DUUhwdHAyZVliUVFLQnpGMitWM2d3T1NBUHBBWm5QV3IvQWdiMnUvdW9s?=
 =?utf-8?B?U0Q5dkNaaXhYTW1UT3BlcmY3QkFKQzJ2YlNlekZnYktwTFM4dEQweFdFTTRN?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd35a4fa-6e0e-4bd4-c6b2-08db3add26e8
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 22:36:12.2007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66bX0RqofjxDyTEemO9W2iO4XVrbqk2hA2H+Win4zklSlQQdzK8FWCFBWHhExad0ID9YbQDxZO2UCM1ZmSxZPrFiY/M4IcyCqG4AVePuaO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7045
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2023 6:00 AM, Corinna Vinschen wrote:
> stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
> like TX offloading don't correspond with the general features and it's
> not possible to manipulate features via ethtool -K to affect VLANs.
> 
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index e590b6fc4761..308d4ee12d41 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -7216,6 +7216,8 @@ int stmmac_dvr_probe(struct device *device,
>  	if (priv->dma_cap.rssen && priv->plat->rss_en)
>  		ndev->features |= NETIF_F_RXHASH;
>  
> +	ndev->vlan_features |= ndev->features;
> +
>  	/* MTU range: 46 - hw-specific max */
>  	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
>  	if (priv->plat->has_xgmac)

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@gmail.com>
