Return-Path: <netdev+bounces-10432-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C69F272E6D2
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BC6C1C20D3E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EB473AE76;
	Tue, 13 Jun 2023 15:15:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C4E39245
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 15:15:29 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75843101
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686669326; x=1718205326;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eX9lT9aPdpqKauFk3QJTLt3/uTq0McBmWp/N5fShDS0=;
  b=gELZcG3gs1l1i9bGNR5s/IxnGO+NSvfbBKXwrrjgMhCX8jN15NvMB3f9
   +BG5BoGq2QWJE4LB15ijcYJmERYK/QA2KLJ+jnJybgoBRKZ4bVe9cu0Px
   2WtFXHAkFClPowGx9tJWtHIzNfXW8mU52LQ6E6dXYFtulEQf92Bm/eMjH
   U/k+oyIFayD3Ee+Syx1YNBxGYkw5khJPr7Q73npTIIOYTAgLYiYAa10Xx
   RfaKAzEzK3znE+45CgBR2kyzuxN1TGikJmuXN1cWzy9h2UMdE8TEeRAc6
   0dCdY+o14vMl8woN7ockDCFhW8KTdLzZPZzlnAHarlXCBfVinG0vLB/Ab
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="444733850"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="444733850"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 08:15:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="662044688"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="662044688"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 13 Jun 2023 08:15:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:15:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:15:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 08:15:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 08:15:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhI4WRNfrTA95VvM6sfQWov5z49WLgJ380vXrjwVPjQ8TCkiGdj3HzsNPzcVi1JWvRWvKnG41uU5bUsYqjmiHvG0n9hRM01GdOQdt67RMuwFnF/NtO8gx35sux1mL8xKHtPoftWPDIqrgDlBHqIkjKJaDJZUWmRDNQFF4Kpv2lGURCPcvHomm4dUnHc+fYvvFrKqDezo9Wk+/Z3DJnWiaWGKd9kyJmfAoRG+rIKUtkibZyCrOFoSKFBYG/csVkvqQCqisWO5HmyiHWaKQuDHFuE7rO6yNZlV29FGOb9AQSJ85rayDUP/TvIKN35mix9GfsGNC2Fwxs+DptMrU+kLuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DXFDXvqW8wA7SYqibIjFpEuwmkj/iErQJ5Q2kmDUDE=;
 b=isTAduN8stMSvO6uxpOD7EjAUnEywG3qj/k2QIb52Y4qO0b2htqgwnjpK7NNWBMABLr+FDIP8VEhT00PQ+is6fWA+cMlwH3PLAOJp+nWDmYW3bRy+XD1SlPSrCvFY50J1aSj8bMe2yxqlBnP/KFjvlXymDHMnjtn1TEcpfOTjFq2jbLkXBgATNHu4jNQcCR1MxKBaHax8uYxSidtsXGifuij/pqrA6BfaAQ7MulCtJRH7HC6JD6sbJB9c0VGkJ5OEEuWDm0KQI1+DDoU1FocjjxRaKODAXE3khiN4nB+SF4L6OFOHlzrq2+VFqWgXBhHOUfOPr0UIVRLxzA0xj7kfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5290.namprd11.prod.outlook.com (2603:10b6:408:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 15:15:20 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 15:15:20 +0000
Message-ID: <9eee635f-0898-f9d3-f3ba-f6da662c90cc@intel.com>
Date: Tue, 13 Jun 2023 17:15:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: allow hot-swapping XDP
 programs
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<anthony.l.nguyen@intel.com>, <fred@cloudflare.com>,
	<magnus.karlsson@intel.com>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0171.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5290:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b42dee5-a661-4493-6a98-08db6c210034
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CHzZ0ceLdRaAQwc+8dcdPdC/P+gCi++SJpIlZJbMnB5oGCEaQgUd7l5s9u/T6YSWvpxY/BSWdiJ8OXq0iJHguCu4sxA775Rg/WISnbq46KffsWvoRQQz6y5ZD5DL4tJhTy9M9oJF40UvA0kMlMI8+GMcJ5PBYMnGAqpkbGi/9QirJr+AWU6kcuHPVaqctRom5u8TsGM9qWUGExnn8gieDTVNx5QbqOGm30jubgx56j7967DUYXmwd2mICuxrexDbn5AsIGAYCmOFdl3QP49ud4Y/0/H0WiaM7a/XltbygDTmehje9F5xF0xgdpa8sZGbReQH/U634s/mVyF6OBN6sbPmMKMEXHg3nhTlmJT9alx4H1eU7F1I5M/SdfYN9Wd6HZJtOYnI8QxZPg1ogt/FJxLnLm1tQpAYsf99nn9ldV1J4kb+wexJoIhM+Y+kxoS92KaC0kYxKuA2Yc6xu0UOZHRKyOtsLI6/GeS0BPKKf2E34EeZIcVHrWxw5QCnB5J3yy3sZmhczbr/1PGrk+F+G6olmcSQOxB2u8xTpTX5cQSUYC2yLTGx2XHIuckmwn7GKPJeiRroNFPaKY/kMX+oF0Rf68LEG96v7yp1iPgLhr/avUIgHfv973wuVSHc8WPPeJ/t4gXrRocCMDOfahzMQ48VKl1Txq4elVxT7VAkTcE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199021)(31686004)(66946007)(4326008)(66556008)(36756003)(186003)(6636002)(478600001)(2616005)(2906002)(66476007)(37006003)(8676002)(316002)(966005)(41300700001)(31696002)(107886003)(86362001)(6486002)(6862004)(6666004)(6506007)(8936002)(83380400001)(82960400001)(26005)(5660300002)(38100700002)(6512007)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUMwTlE1OGR0Y2hXRGVRNXFVTkJKNGtVc1BGRGhhV0xPd2MxaHhOOUYrYnB6?=
 =?utf-8?B?Nmt2eGlTZm1lUU10Q2JZVjZWaFpOYUQ5ZmlESWVCdHRUR0JzT1RDa2hUNHlj?=
 =?utf-8?B?MUdKZFBZSW1PUldzRzVQWFRnRStDZzVra0dDOG9LWkhjb2hhRlZyVGtGMER3?=
 =?utf-8?B?bXoyT0ZNc01VeFp6dW4yWnRxVzFqNGxBWFV0TXNqNzFOaEdheGZlMGlDVFNT?=
 =?utf-8?B?WkRsUmhVUGVtTlQ1c0FsM1kra3lSVEZyU1hDRUVUTHBNSXFmblMxaFBPSnZR?=
 =?utf-8?B?WUgycjVlbFczdWxhQ2xNWU5Yb01uSStYTDkrZU9CN2FSSGFDcHpUN2tKNDc2?=
 =?utf-8?B?UWRZVitHc3FLNU1MRDlIdmlTQ0R5cTgraEozVUxyeEJqd242K3ZqNDZWcE90?=
 =?utf-8?B?SnRkaDVNUWRpbmppeUQyenhzMGJ2MGMyQ1IzbDZyYkw1dVdPcXUwemdJbDla?=
 =?utf-8?B?NEsxSFlUb3hmL3NNQ0FJZml3MHdWUThTS3RUWVJSa0dPWVh5dnNwWGRTWS91?=
 =?utf-8?B?R0xXd1lVcDMrZHluOGZ6ekRaWXNlQkY5VmlvQWFCbEFJcVJYdWxVeGhpdEdi?=
 =?utf-8?B?VkluMFdqanFhSGZ0aWdjNWZEZ3VoUzEvczI5ZzJLMml6aTJsbXpRdjZZOWVn?=
 =?utf-8?B?Y0V0Y2hWTE5UTWNQeVltTVpBMHdQeWowSnpIY2VTd1ZzSVFVUnR1RXE3cmdX?=
 =?utf-8?B?SEVoZEZ0dTc5Ly9HUWJkOFhrcDFvbjd1aXJwQThhSFgyNVVXVEhXYzlEMTRr?=
 =?utf-8?B?R0lrNWVLMFZKSldJWGRRdVM0R1VqRkc5VUhwMFMxTldrblh4SlIxUTlybkVz?=
 =?utf-8?B?REYrS2Z6c3B6d2JzMEpialMzQ0xkcCt2NVdSajVuOEdnR3VieUNnZ2RacHU4?=
 =?utf-8?B?amxjUDRmZVNHK1BNb005cExCeS8rOVYzOUZ3WWFRSFlVVEJOOEZZeXdBdkti?=
 =?utf-8?B?Z053cVp2NHVtZjh2N0VQNlRlUGRYakpRUGQ2QTRCQjVIZVEzTFNXYmM5dE1U?=
 =?utf-8?B?NlVuUHJNZkNJa3ZRU1VZbUx5ZDRKN2JETXNMckd4azJENUR4UWdvTXdaLzRr?=
 =?utf-8?B?c0VKUnY5eGVVL1k2RXNyMitNc3FOaXJDd0h4REhkS0ZqMEJ4c2gxVG8xWTAw?=
 =?utf-8?B?Yy8xRXdlY3lBeEVsaVRxZXpaRGtRQlZQNHBVdThOUlZjUEdIL2MvNEtqQ1E4?=
 =?utf-8?B?c2VvaGsrREZLdW43eW9DdmlId01mTmw0bDZ4bUVodkw0N1lDdmRvWUJzZFF1?=
 =?utf-8?B?TnNzR09ER05UYlEzenIrV2NBODI1a2NDQ0dsMjJlOWJiNFErL1A1UzgrSG8y?=
 =?utf-8?B?cDVYMStQa1I4bHBNZ0lrbUp1ejBIb3N5NWVuUGJTRUtNMWhhM1p4SmU0U0sw?=
 =?utf-8?B?WTl1QmswOVNMR0pBSVZMN0JkcVBnc1JEejhQQUVhUTY4dnRweFp0ME42aWNu?=
 =?utf-8?B?MmhWV1VwZnc3dGtLTTUrZWF5a015VUhkWVp3cEJOZUlXaTVFVUxtRGp0TE16?=
 =?utf-8?B?NFlaK2k1Tmk1WFRtazZUd2NpVUZ2SFdyck5IVWZSWFZaTENPRk5zeEx4dUtD?=
 =?utf-8?B?dHBVdEZjdU0vcTEyMWFUaXMyUzkvdGhxSzgxY3NzcUMrL21qVXhMZGNUbkhq?=
 =?utf-8?B?K2tkUEhnclFDSHN3U2xobFVybE5RZ3h3NGZwZDMzWElIME05bTRZdTgyWTVp?=
 =?utf-8?B?Ri9JYXFGRXQrZFFTMUZwS1VmWTgwSm41ajkyVFVtWTBPdUFMc0tzN2c0d1Nq?=
 =?utf-8?B?c2lpZlhhV3NQdFR5YlkzSlZTN3haY1VjeTZIZFFua1BzODZPYjNFM2JFK0dU?=
 =?utf-8?B?cEFlNlYrVVlHSHNSQUY2YlZoNUdoSWxZL1VINklwdHFSODlQUW8remhtS2lJ?=
 =?utf-8?B?K2Z1UE51K2RlRjI5SHYzVldBMjhWSExnQWdlMCsyMTRHc3p2WHhrNWRmMzNo?=
 =?utf-8?B?cHlqZmFMb1ZzcU84RmpLVzFOOHF4TUhKajdKaW1JdlNaWk40R01BdzZmaHhr?=
 =?utf-8?B?eHlUZEtYbG80bnlyS2dXbFk1T01VNzhTQUlnYkpWRSt6L2JBNU1EVzllY2tE?=
 =?utf-8?B?dlpsT2gyYXBEQk5ZeTU3NUZ3ZWhzUHcvdG5uQ2dqL0Vrd2IyenVNbm1vTk9m?=
 =?utf-8?B?Zk94RkJldUxQUlRydHVPOEptdThLRUxUbXpGY09QbXJFUXBPT0Fqamd6bjJo?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b42dee5-a661-4493-6a98-08db6c210034
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:15:19.8619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VtLMniE65KOBXsf61L2uy6/KSDZ35cl4eCf1W9ZMXRgPqFJEKBW0mGFLBW8uC8paa8SbyQtQE2imZo2d4qcNISVm/0J4FQw+zHO37Wpwq2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5290
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Tue, 13 Jun 2023 17:10:05 +0200

> Currently ice driver's .ndo_bpf callback brings the interface down and
> up independently of the presence of XDP resources. This is only needed
> when either these resources have to be configured or removed. It means
> that if one is switching XDP programs on-the-fly with running traffic,
> packets will be dropped.
> 
> To avoid this, compare early on ice_xdp_setup_prog() state of incoming
> bpf_prog pointer vs the bpf_prog pointer that is already assigned to
> VSI. Do the swap in case VSI has bpf_prog and incoming one are non-NULL.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[0] :D

But if be serious, are you sure you won't have any pointer tears /
partial reads/writes without such RCU protection as added in the
linked commit ?

> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index a1f7c8edc22f..8940ee505811 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -2922,6 +2922,11 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
>  					   "MTU is too large for linear frames and XDP prog does not support frags");
>  			return -EOPNOTSUPP;
>  		}
> +
> +	/* hot swap progs and avoid toggling link */
> +	if (ice_is_xdp_ena_vsi(vsi) == !!prog) {
> +		ice_vsi_assign_bpf_prog(vsi, prog);
> +		return 0;
>  	}
>  
>  	/* need to stop netdev while setting up the program for Rx rings */
> @@ -2956,13 +2961,6 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
>  		xdp_ring_err = ice_realloc_zc_buf(vsi, false);
>  		if (xdp_ring_err)
>  			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Rx resources failed");
> -	} else {
> -		/* safe to call even when prog == vsi->xdp_prog as
> -		 * dev_xdp_install in net/core/dev.c incremented prog's
> -		 * refcount so corresponding bpf_prog_put won't cause
> -		 * underflow
> -		 */
> -		ice_vsi_assign_bpf_prog(vsi, prog);
>  	}
>  
>  	if (if_running)

[0]
https://github.com/alobakin/linux/commit/5645adb0943dabeadfb9f6d00202c78fb9594fbe

Thanks,
Olek

