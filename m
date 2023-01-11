Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3433066657E
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 22:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbjAKVUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 16:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbjAKVUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 16:20:23 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EE3B57
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 13:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673472017; x=1705008017;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q+xo9DQpvQBZtxM1h+KzuouM2rZu7yHL18QO5MSCovY=;
  b=ed0z9V0uQ00Mxn2OPrUcXyayJCvWBV08pJznT+uTAPmlNAjufMm2BLNj
   4qwNi4MsZd2zw+lKC0jUFipRTwyM/SmrEKZRbNkliTFZYYNU/CIGRpl+8
   nlH3fO+dG8d1vmH2Fk39Orjs7wgUpe6DpfaP6oBMx8Jq0FTHmOmnQyXFV
   WuyPTGXotNM5Vld9PrXX8oau9BDJ8bMSevhdYQrYA/1EiUL4Lpz7BitOz
   aBr4GAz65xWBlpHzLKkDuGYEIz0Crxx/V3LOEeNei+a26q/EIa1H4Ysmv
   /zJKxUMQH3ntX8Z7nYthvnSQeSKSG7XoPMbrVAg7l7zIPN+G/1hbJpjtN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="303911619"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="303911619"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 13:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="726069408"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="726069408"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jan 2023 13:20:17 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 13:20:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 13:20:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 13:20:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 13:20:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5XmGmAy8Gp9g+NI98x2F4OwuR/PXf/20WaA5I/GPU0xa0igJJFRlLqBCMpz8dm5AJ1W7qY332Gak47SnQ1DgOwLZarcPgNzCTHpl8lQUz+ZvhyS6tVrC9FXjHqp6V7YFYhymjtY0OQs6RFUm6/yYcY+mcfWZp0ugjit/Ljr/BOYX/G3ObYF3LBcA9TRcMETqV0YQrQ2Pak+YlT9+QuWa97ry+aAKdQSo8//kVIkjvCRGreVWknO80m0D8/m5OHvKckZQJ/VcEVjW857VYT0k6fZnoIrTpTk9CqY0bQtx/wmqOUY6UuVDcC4pnehvUskrIpvNLhe6QT2oapo1Ofq3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mkl05wuaeOV+Y+WjdJiD0hzWNnCEHf7aIIeo4Vgwn4c=;
 b=VIkdKNJFLAOhtOSP2ycZ5gLwykPH2k8TABdRcJw1P5lp4SewrWehJ96dPJrB4ZidEpFVVQkLY5C2IgvyhNijFlAO2I0H9/R06sCnoIIlSopOyI1AOIZDz3WRX8lNgwxMx3NN2tIXKliXxCfxcEiBZKHG1Lfw6ZdDGHAMEWFn8rMxmmG1wRfn7qgOR3RsQAX5mJGEr9TmD3U8/nwj51L42MO7Ml+3eRQP/0aOdo6GXT3o4D/NngcAn/tVBj3PQJq9zF1mOzOzxQNFgXCM78P1iw2Ztxh3PWL25GcW3pmZThT4kjIdx8mHg/htMdqn433x2zXhZqky7pI5CRaT4sV9gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by DS7PR11MB6126.namprd11.prod.outlook.com (2603:10b6:8:9e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 21:20:13 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::ef17:4bdc:4fdd:9ac8]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::ef17:4bdc:4fdd:9ac8%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 21:20:13 +0000
Message-ID: <09bdd5c7-b452-5924-e9f0-b32bad4d52e3@intel.com>
Date:   Wed, 11 Jan 2023 13:20:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] devlink: keep the instance mutex alive until
 references are gone
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>,
        <syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com>
References: <20230111042908.988199-1-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230111042908.988199-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::17) To PH0PR11MB5095.namprd11.prod.outlook.com
 (2603:10b6:510:3b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5095:EE_|DS7PR11MB6126:EE_
X-MS-Office365-Filtering-Correlation-Id: 972aad10-d5f2-4587-fc9c-08daf419a0d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cKkD/zzaLcEKWcwUdF36OaLtS3CZdug+75FD2byKs7KuXTReG4tGZnAZdRnS+vgJ6B2ltJuhDsP4952VICX5F7rivg8v5vzwNG1ZafLrasqhIilnu9CO4vV65yOD0kHiYcV3xfs2SGvtCb9a3pBHI525agbikhVCuNQNzFpUdomU3VqHlgWiLFvrwvgGE63ZqJUghDeom0ZUeGTVXMlIvkvLUrGAsgSILP8CNww0drWJkCpKfw5e9wqMHGwB520IxYKz+bIJ9Dk8/rN0NDOahYUMunAsmSS4OcrT52nHSZnGUkYW5Qgh70opyfbz8dPJlbbWu5N+0w2kZsRZxKTzdCLWQxzqpNblN0LBPNhX76ka/bpY7gUJ8bQfxPFKKpVYneKapP3P3eXpHEaq9L5uPfsKTt4m8FTU6MC6AhvNPKoQhK5a7/DRK4t0FjLLNxfchksi6BCaW49+RMIBOl31g4hqCvX/l56hxv6wFVTAti6zzw1NtirpngkI2iIpUGBlgXU7UsSgm1qxvlaPvdr9JZDfXQzQEChFJD57Hc0v7MZhCedd/HJ02UVDUYqlEV6EcCUFl3dQPA54Oh6bo5E5wRYfQiW0pgVBcFn0IAlatbSZp+TEeB/gaLHPXDzNbV0vS+re+fsfoOn+WkEWslRcrFHTeAP7zPcMDxfCPiXSewxA83Ehu34kB/X4otCg8qFH+TxlMhpZuYXvv7H8iUw6N83EPUmnFO+MvFWAsP+k/cw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(8936002)(26005)(2906002)(5660300002)(41300700001)(66556008)(4326008)(316002)(8676002)(66476007)(66946007)(6512007)(2616005)(38100700002)(86362001)(31686004)(186003)(31696002)(53546011)(83380400001)(36756003)(82960400001)(6506007)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmZPa2xXS0lGSVcwWnVmOHhqL2FyaDNoR2NEYTFFV2ZYSklvYkdUK0k4UzYx?=
 =?utf-8?B?ZzFxakcxb0hHZzkxSW9kRkFzSTdPcmF3RG11Y3Q1bXNDb2VENzVWUVh5REpO?=
 =?utf-8?B?U2dveGRIRFltNGMxZ2l2bllQNnVqdXBuNnNMK1haY3B2WklNTmFMOEdvMDU3?=
 =?utf-8?B?N1pLVXhiVGJ1MUpiU05aL2tadThRUlNFamRrbkRiTlpnQ0pST3dQQzZSUTBh?=
 =?utf-8?B?VlA0YjFUTTdDTG5NTVVIekVrZE9FTHQwOXcvZStHVVk0ZzBkcWxqMmIrbEtO?=
 =?utf-8?B?Z0dvU1FRZk9MNjhoMmFFenRhQVdDRk9pMDBBUUZnY0xzMWRPWm9pYklSS1Jm?=
 =?utf-8?B?ekkzSit0YUVtS3FNOWpSeFpwRzVacEx6L1ZSTFBlYlJrMDJJTUJQczBXQnNr?=
 =?utf-8?B?cEJmbXQwWGVVZEIyWFZaRy93UThDenNmWXdRYnkyVFppVGxnUGtleW1PbWo3?=
 =?utf-8?B?T3A2R2k0WVAzQnZVMVBiUkNhK2R3dVE1VndCaXRXRkJuTHhnR2ZmVVlhY01R?=
 =?utf-8?B?Q1BXVVJub2VQaUxpWjFnUHZHdFNRaDA1S3duWWNmUCt5dHc2QnAwNFBQUE5k?=
 =?utf-8?B?ZzV4VGRyMGM2d1dQMmJ3OTB3U3M2YnRXNGl0a29xV002ZGVkMnQzYlNJb2kx?=
 =?utf-8?B?WWlWRjZtMkpJbS9SMlltWXdTSXdrUU5TRG9qOHJ1ZFR6aXB6clZES1JhMXZP?=
 =?utf-8?B?OWZQTVdhRldHaWtXd0phZVh5blNvMlY2VUE2M2ZBSEtvdWZIczd5dStZVWlU?=
 =?utf-8?B?TjFSa29GQVBpcy8xMUN3T28wVEpJdnd3cnJkRDB0dzlOSnJYaTMzREpDS1lT?=
 =?utf-8?B?MUlOQTZLWVE2eUFodlNzbHkwM0o3SUkrTkRSbitTb1JXZTg4eW9nMkNtb21W?=
 =?utf-8?B?VS90WnhSMDZEOXl6TjVyZnhoN2toWkdueTVMakh2L0JIRnp0WnordXJJajZX?=
 =?utf-8?B?VVVrcm12eDlIZWdVaHFhMXZwbURucWdYc2p5bkNYbk9VVUVXbjJWL0ZHRkhL?=
 =?utf-8?B?WHNqenVBN3dRekJWckFUZFBTSmFva0R3TWpTbHV4S25kWWNGcElIWnZERGx2?=
 =?utf-8?B?VXF2dnNxMXYzV3c3UStIRFBLT3hqZzBBNEpGYTkrSk55WlRtQjV5eHRmMDd5?=
 =?utf-8?B?Z2JHZjNVR09yWGZTcHNub1ZGOUFmTDR5R1J4dHNld0RoUVBxdGExbjRqOU4r?=
 =?utf-8?B?bVI4R0pxczdWZjY5M29BR0lwN0JTalNJTkZET2RjUjZlbE4vZHhJOXZCWUNx?=
 =?utf-8?B?NE1LUWpTSjlyQmpVL1lWSjVwNEhQZlJid1RsRExoK3NNbFZuS1l4cFNZM3pS?=
 =?utf-8?B?dVNaUWF4Rm1wUzZpdkkrYVl6ZHNnaGhxL1FBNTFGemtaZzNkVG5KQmszS0I5?=
 =?utf-8?B?Y3kzWjgwekVmVEx3UTdBL3dNdGM0YWhJdk5RVy9Mc0pxNC9CbGllVmxwL1hu?=
 =?utf-8?B?YlE2OVZmL3RtQnMvWENEV0VheUpTd1o5V1NEeWdabHVHbDhLazVPM21qemhC?=
 =?utf-8?B?VVZyTTQ2cElBdnhSWjhhZXpVZ1g2bDRrbGR4OVV0SFBzV20zaEdUc1Q1OGY3?=
 =?utf-8?B?Z2l0ZDJUYU1Zei9aTDlvMksxK2krSk9aZ3hlVFNDZ2t2Z1NsTFpPb2huYmJ4?=
 =?utf-8?B?Z1VPUW5UZlFGY3VYSTh0WGFEeEtzRGY1QTZ3WDVrakZ4SEo1aHhIV1NzOUVJ?=
 =?utf-8?B?KzVPWGdNVVowbTlnZnhQdmc3aTVDcFdGbDlTY0hWV2paODlaOXN5RFlCa04r?=
 =?utf-8?B?N2dxNTM3YW9MeG85NHFOd3dteTBsUWdvbDNWYUs4N05xRS9abXRuOGQ2cUJq?=
 =?utf-8?B?clAxUmVkOThQNis4N3pCU3RJS2xaeVZOWE5LdlZQR2JPRGl1VlhCdGNhUEZX?=
 =?utf-8?B?MnQ4MzZVVmgra1NSNWFuNFNUTi9BbVQ3SzJGRkI3TEsrbnU0eWVxQUJnUTNP?=
 =?utf-8?B?ZlRzbU13S0VIOVk3NFcydWFOeklJSGRPNlQ0Tng0TlJiNDNOdG8vamJkQ2ha?=
 =?utf-8?B?ditXd3JJQWtyNHJ6RWg3UWlxUUgydlR5dGR6OEtET0lOMTFQZFFOUGo2NkVm?=
 =?utf-8?B?cXBqam5ydzJuZmdaQXRxQkdTc1FaVGgxcmMzOWpySW9YbEpCWU5jWVpPcUpT?=
 =?utf-8?B?UDg2aGxQUXVFMURqUW9RNGcydW5IRXBZeWRsL2ovb3JlTnBDMXExdFJRTjBz?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 972aad10-d5f2-4587-fc9c-08daf419a0d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 21:20:13.8402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aeTv6Zip9yVcYZ5OoZqmSZhMCm0uONEYHiE6M48V8VabCwK+7xegn8HjsFCz7xozG8WXAAI+SS4sSF3nb9pt4zv+wveF1ktLvPkywWovFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6126
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/10/2023 8:29 PM, Jakub Kicinski wrote:
> The reference needs to keep the instance memory around, but also
> the instance lock must remain valid. Users will take the lock,
> check registration status and release the lock. mutex_destroy()
> etc. belong in the same place as the freeing of the memory.
> 
> Unfortunately lockdep_unregister_key() sleeps so we need
> to switch the an rcu_work.
> 
> Note that the problem is a bit hard to repro, because
> devlink_pernet_pre_exit() iterates over registered instances.
> AFAIU the instances must get devlink_free()d concurrently with
> the namespace getting deleted for the problem to occur.
> 
> Reported-by: syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com
> Fixes: 9053637e0da7 ("devlink: remove the registration guarantee of references")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Makes sense to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
> Jiri, this will likely conflict with your series, sorry :(
> ---
>  net/devlink/core.c          | 16 +++++++++++++---
>  net/devlink/devl_internal.h |  3 ++-
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/net/devlink/core.c b/net/devlink/core.c
> index a31a317626d7..60beca2df7cc 100644
> --- a/net/devlink/core.c
> +++ b/net/devlink/core.c
> @@ -83,10 +83,21 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
>  	return NULL;
>  }
>  
> +static void devlink_release(struct work_struct *work)
> +{
> +	struct devlink *devlink;
> +
> +	devlink = container_of(to_rcu_work(work), struct devlink, rwork);
> +
> +	mutex_destroy(&devlink->lock);
> +	lockdep_unregister_key(&devlink->lock_key);
> +	kfree(devlink);
> +}
> +
>  void devlink_put(struct devlink *devlink)
>  {
>  	if (refcount_dec_and_test(&devlink->refcount))
> -		kfree_rcu(devlink, rcu);
> +		queue_rcu_work(system_wq, &devlink->rwork);
>  }
>  

You can't directly call devlink_release because callers of devlink_put
shouldn't sleep. Ok so instead we queue RCU work to do it later. Makes
sense. I was thinking if we'd used kref instead of raw refcount we could
just kref_put, except that just directly calls the release function and
we'd have to queue_rcu_work anyways.

Ok.

>  struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
> @@ -231,6 +242,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>  	INIT_LIST_HEAD(&devlink->trap_list);
>  	INIT_LIST_HEAD(&devlink->trap_group_list);
>  	INIT_LIST_HEAD(&devlink->trap_policer_list);
> +	INIT_RCU_WORK(&devlink->rwork, devlink_release);
>  	lockdep_register_key(&devlink->lock_key);
>  	mutex_init(&devlink->lock);
>  	lockdep_set_class(&devlink->lock, &devlink->lock_key);
> @@ -259,8 +271,6 @@ void devlink_free(struct devlink *devlink)
>  
>  	mutex_destroy(&devlink->linecards_lock);
>  	mutex_destroy(&devlink->reporters_lock);
> -	mutex_destroy(&devlink->lock);
> -	lockdep_unregister_key(&devlink->lock_key);

It seems like we probably would want to move linecards_lock and
reporters_lock too, except we know that these will be removed soon
anyways. Ok.

>  	WARN_ON(!list_empty(&devlink->trap_policer_list));
>  	WARN_ON(!list_empty(&devlink->trap_group_list));
>  	WARN_ON(!list_empty(&devlink->trap_list));
> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> index 5d2bbe295659..e724e4c2a4ff 100644
> --- a/net/devlink/devl_internal.h
> +++ b/net/devlink/devl_internal.h
> @@ -7,6 +7,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/notifier.h>
>  #include <linux/types.h>
> +#include <linux/workqueue.h>
>  #include <linux/xarray.h>
>  #include <net/devlink.h>
>  #include <net/net_namespace.h>
> @@ -51,7 +52,7 @@ struct devlink {
>  	struct lock_class_key lock_key;
>  	u8 reload_failed:1;
>  	refcount_t refcount;
> -	struct rcu_head rcu;
> +	struct rcu_work rwork;
>  	struct notifier_block netdevice_nb;
>  	char priv[] __aligned(NETDEV_ALIGN);
>  };
