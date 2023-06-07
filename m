Return-Path: <netdev+bounces-8942-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57D377265EC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:29:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF3FA1C20864
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FFF37338;
	Wed,  7 Jun 2023 16:29:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CDD370F8
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:29:42 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D161FC4;
	Wed,  7 Jun 2023 09:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686155351; x=1717691351;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uiWOkkqIzGkCJMgDhvDq2wSbSlJLZWD5ApSPZflFJD0=;
  b=jtjijuVRVER/S12kK1b2Bu+g/UIGdDcBWucFPVSKs9/mee/zqhHbcp3Q
   12ibDqSgCheEHy9314pUGwXwFHxsse7ujqUJsi6TL9LssqqS5Ew6TtH66
   qeo9EsVr13eNbjMrz3g8+Q+Ocu9b0sHY67DUxBE3OwTPFt3BDirsDKCew
   PyzASrv1jcPXQ2Vn/9TgCRZPaPuf/Wuk4epriREE5JaBinLlLrK4mKk1m
   G1DCst9Y7cUaXrPwvCGXJPA+OZnRMN+kZCxHkpxH0AegCWKd0iZmL78qq
   80Ziki9ysumg9cXwZX0ckCQ8vNCBb2m4HR1wvzWFLDnnntl2yS30DavAQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="346651322"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="346651322"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 09:26:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="883860355"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="883860355"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 07 Jun 2023 09:26:42 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 09:26:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 09:26:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 09:26:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 09:26:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOwLAtD4y4nlHaaV94dMWJ+UcZhuJrRcsBwbZRmdAZgH+vOAqA8Ss+BKi6eOpWKpGH6ns7FFDOf2Nhu1YqAxtPGto7fFnmUTqOZVyJXmWlvY4lVK2NG3V2zAey9Zw/TdkerCvJ/f05Lsur4jKni500uVDmpLcrVLUz3/1WoISo58UmMVr7Cmd2OLGJeobHGAYXLn5bWdV4FFY1P0i5OYu5/aAsjmQZHsxzojIQjd43iK+92Rlcv6tcvJAbh/GN2CB/77gu5qLTcG1fBWHTz+fqGvMaYAz8HVvQka6NfSCbnQcUcm9kXGyZ22tn+VVA47fe47jr3TaHy6ajE6lWH/Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vz/zYJKJy+5n3H6NHiOd1k6lV5nH9PC0RevfHwNc/28=;
 b=XteTZy26J1yziKVpPbXVVF96jI7Um8vD0C+ZVpTDsJLrHxLdo/A/hp9zBIlhlTjfVb4HY8dN5Qqj7Y76j068Ocu4l3x0oKY7ieJeIMLvU0dmMxc3oj447iurf22K1JjdvmFBW1R0lfUZ8Tv1hDWRI7aQlC926JLajYuKslE+OTuiy5rNOb/BkMjBeCRNVWDsdp7KONnADWaAUkgL0a2ANQDdG0glgiq4CJNy0WnW6GIwr0Ie2JjxZMJqX7GhK6QHvH2fFEHQc6Uk5Ph9PMoyfcDmXrRcVZiFdpoB/Wo+u+vHuPvXXlpjvf7l4I9wraSj4+nPFHs2ebWOzszK3dnTww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB6567.namprd11.prod.outlook.com (2603:10b6:806:252::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 16:26:39 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 16:26:39 +0000
Message-ID: <e7b3ebac-21ab-ad3b-7906-6eb4b81ec985@intel.com>
Date: Wed, 7 Jun 2023 18:24:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [net-next 09/15] net/mlx5e: RX, Log error when page_pool size is
 too large
Content-Language: en-US
To: Saeed Mahameed <saeed@kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
	<linux-rdma@vger.kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>
References: <20230606071219.483255-1-saeed@kernel.org>
 <20230606071219.483255-10-saeed@kernel.org>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230606071219.483255-10-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0379.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB6567:EE_
X-MS-Office365-Filtering-Correlation-Id: c4cf948d-40fa-4db0-7a67-08db6773f880
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DamCn3dg+tsfQN1/M00pf+2564BNQWhHP9tEcSqD0tR4DqGH9TFu9b62m0mmffPmdyNJi/A8nw76MMfIrkBQPQA92I8t5+Prczk+6J/fV0EFDgC222ZNhXx2YY0jb0l3ysnj+EOOLIHQBXBKlsD4JS8cQqc6hC6eCHSsJIjlDu10Pb0t3Gllw3cC7/cOQhe/9U/7CoJrIqARuVVEMtpA8va/KHf7V+eOi1kZg7YiumhCbx7xgjZgTjj0Ygen5hx02nMfZjE3ZQFnx2HgqmnbS0etfQ1WjQpqi5NnLPz2GvTjX2SRLTE2Qe94Yz7ZDXcPgOev+c38g2xVsWf6qvXdkSmu9mzBvvaO9LM2peqaBapYWEThtl3/DCu/VZg9dm8PF28Jed5TP6RDL+j35EiZBnXi+GEY2+bfJ5No260YgKOWUecvJOpVic/7F+v9cFUDYLQdKKoM4s+c+OhLS45Fw6MFIzfaqkn7v9+rOXKtWgCC5eomuatbjcTh83Q6SkgKUrOKaJOOnoisiunPr8GLO2b3teLx++hawuQOV7jmyjHOg/OhPLwJS6kpMRwJVx8T8DR88K/dcGw+POueZreG32dCxTuqPltW8wPwrimphIp8drXBtPAXvhV62hrYmAVbH/pAtdd4Fl3yFEdbuMHU9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199021)(31696002)(4744005)(2906002)(83380400001)(2616005)(36756003)(86362001)(38100700002)(82960400001)(6486002)(41300700001)(5660300002)(316002)(8676002)(8936002)(54906003)(478600001)(66556008)(66946007)(31686004)(66476007)(4326008)(6512007)(6506007)(6916009)(26005)(186003)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejE0My9pSldKeElxaXVrOVV0NXZQYitqanpTZEhnK1VQOFpvOTVEeXRQSVlO?=
 =?utf-8?B?eHo3SXRpcmp2cWdLSGtObjR4cDdLYTRCcXh2UTArOGd5cmNXRVNiR2plUXdl?=
 =?utf-8?B?dVBtY2RZVWpza3pUUzZ0V3FzTVlMcE5lTTRob21SdWpIMCtXSlJ0aCs5YXNC?=
 =?utf-8?B?QXpLMTJOMklacHpPcEdjVnJVamFRZUtrTWs1ck82VHZpeStYODlpRGNyWE9V?=
 =?utf-8?B?Y09NaHRKdklsMnBFNmZ6amYvdWY2N3JNcWpQbUdGdmdncGZHQlF3YTdqZzJT?=
 =?utf-8?B?SDA3ZXB1NGhnL3hhU2RmUm1mU0hVNFMzRTdERHBJZ3VEd29qWnE3YlQyZXlQ?=
 =?utf-8?B?cjRpbGtxZU50NzBPZVNnQzRHL1ZGQ1NlYUpPQ3N1bTJOVGRIeFdhZmR6b3g5?=
 =?utf-8?B?TmhtYmN1STFTWUk2bUFlWE5TaUpla3BKajV4bGxFRldlbUxEYzVrblpUdCsy?=
 =?utf-8?B?aE90ekpTcGE5WmRiSUNTblZaeURGeHRiQTNHMlFnUzBxQkFBS25qUnl5U2xL?=
 =?utf-8?B?RWs4UmhRaEQ0TkswdTJuejZQWDZQeWI1TG5BUUUvOUZ6VHg5TUgwWUhrSEk3?=
 =?utf-8?B?bWgvcjlGbzRnTXhDTDM2cjNtTnMwRzA4eTlia3N4WG96T0tpSHJqRThVb3ZO?=
 =?utf-8?B?Wk00ci9MaTBiREoyUXEwTURoakRWTzJmUEljZG5CSjJYcU5ablFWclE4K2Ev?=
 =?utf-8?B?dXkybUZSNmJ3UEdTWlhuNlZEMkxYa3NiNWdBdy9DMGxGVlEraStYd0NoNlpi?=
 =?utf-8?B?Qm1nODdvYjFUK3JVZUNmcVRZQ1hhTTNNVWJDS0dWQnN5elB0WFRKTGhiVEJP?=
 =?utf-8?B?RnVvK2ZmNzZkdThKYVM5TDV3bkI2NzFpTUp2cHRNQ1dZL0t0U2NmLzA3alZK?=
 =?utf-8?B?bi91SzBNSE1XNGlJaUZqSkNQdFE3MjFrbXVPNFpHemdkZWV5akpmY0dXS2Rq?=
 =?utf-8?B?N1BzMEgxMTdYais0THk1TzNqRmtueUhvSERsbWE3cjg5MnZRUFZoa0tobHI1?=
 =?utf-8?B?eGpwa1NlSFBNUEJBazRsbmpmRmRETkhIVlZmSVhNTVhHRjloWFlmMG4zVk0x?=
 =?utf-8?B?bnMyMGFxNnRpV3JxZDNYR0NjTEgrS0k1TXFNRTd1UW5jSXc1YmtMeStuY1Vp?=
 =?utf-8?B?UkhxYlpkRzU2YzdIVzd5L2lWdGNUc05UZ05YeTVhZlN1bkZRejV3bkVwR1Ba?=
 =?utf-8?B?MVJ6RTJaTmEwRzF6bFRyTFJleml1eWZUcTVrVklGb3p3UWwvUDlLTXhIQnhs?=
 =?utf-8?B?WHc3cnhhZHJUbDMzVm5FV1BBcTFVaXFuWVNPd3duYVFQSU5CUkJxZ3Z0cG56?=
 =?utf-8?B?T3o0czFpbEJPRUd0cWNpYkFoOE9NeVNzbjRBZTI0dlViZ1A4MGwxZTF5cnhm?=
 =?utf-8?B?YWxmYS95cTlKTjR4K2xTQjRZQzNnN25oZUh5Tkt1SjNZQ3ZhT3JJUDRSN3dU?=
 =?utf-8?B?OXZXeHZNZTBQTlJ3dlNYUmlvUVRyM1RaNWV4ZTd2SEV3TjFHVVIrQlBBTHlp?=
 =?utf-8?B?MHI4eHNXUVJkMDJBMW1jN0dZMmp2UTNYQTNJcEZ5Y01JS2tEdXlGWW5VQmZz?=
 =?utf-8?B?RDJqMjBpSGtXbGNta1YzV3g0Mk1LZXZ3TU9TSk44Wi9tYTFySjdnRXo5Zlo1?=
 =?utf-8?B?U3VSL3NzdzhqYmdoSWxySUw0ZUtiVG5KNDQyT2lTQzErc1dwOXgvNkhZdXVZ?=
 =?utf-8?B?ako5dXRKcTM4TjVraW14NWhDbGxFL3dtcnYxd3dvcERlanNtNUxBb1h0VlBw?=
 =?utf-8?B?bUhhYW8zaGFabDlXcmJQU2lVVXFQWndFNDYyaE9pUFl0eHlEOVZlVE5DeE9k?=
 =?utf-8?B?N0I3WTF0NW5BNVNZWlVheVpibEt2UnR0dHJUSEkzUXQ1R0k0K3JqYTFabkdl?=
 =?utf-8?B?UmJabUtIR2JCSXY0YTRmYXd2Y2svbmF1dEVMQmZnbTkvREMxdDNHKytHYWg3?=
 =?utf-8?B?SHFIUWhIRzRkbndhb0RGeUJYZThUMXVicG92b0srWXk5QllnODZ5UGdER2Ru?=
 =?utf-8?B?WUMzQW1mWDMwQm1ISnNFUnNKWjdwa2gxYVNpaVBCTWg0dVBiMmVtOUgzVTJP?=
 =?utf-8?B?N1d6UXVNTzd5dTNIMXdGTG1KRkhPeVh0TE44RlNCVkd3YXF6Rm1TZjV4UFRp?=
 =?utf-8?B?Q20vRUxtK04rdVA0NnBCMWhrVHhrcDZKc2YrOE1jTjQyaDVJNjBkd29hWWZv?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4cf948d-40fa-4db0-7a67-08db6773f880
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 16:26:39.3693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tX+NAYM2QcNzIExCOa+YSy1ZxVPsTz9J9pE5n8vYrCup9Tg9/34ZJ5MOOSlw+gaiNCStTrlC1ECNgNToWNbdUxDW5NEd8rm5xJ6GuSPgJY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6567
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Saeed Mahameed <saeed@kernel.org>
Date: Tue,  6 Jun 2023 00:12:13 -0700

> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> The page_pool error message is a bit cryptic when the
> requested size is too large. Add a message on the driver
> side to display how many pages were actually requested.

Why not rather expand Page Pool's "gave up with error" into detailed
error messages? I thought we usually go the other way around in the
upstream and make stuff as generic as possible :D
With this patch, you'll have 2 error messages at the same time: Page
Pool's one and then yours.

> 
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
[...]

Thanks,
Olek

