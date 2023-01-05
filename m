Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FC165EAD1
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 13:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbjAEMka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 07:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjAEMk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 07:40:28 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D163F104
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672922426; x=1704458426;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PVO3kw5DzwMvVypPVY8gLQ+HVcE6Hv8OPUdpw7tqIc4=;
  b=OV2F2o7wM6NMffo+4Ul4V8oXvruHmO103MdNA0W2fikH4x38FArveEJS
   ouHTErub9JTR7UGh6rkyIinfD4K4EyDFN+Ltlyf9J16iur9JWpRg+A6qR
   rTJtvvS3ILaPGgSI2cEUTTHYIw++6wWctxjiLCcplBZv9q18NGUZ31bwE
   jVu0rBPwKrt21tCfKuhHKEACVBakvo2BZ2StEJsnTv21bo9jprJs4abEJ
   HQUs2Z8Pqr46tToy7SSur5Vxge0ODMpiakrzIudsWCXrdr8cXLu9cZDNL
   vubKjScE/DheBTXz7DtWJmQTkYxoRM5IcVqjX6ChHSn/oypAZGR3phndF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="384486422"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="384486422"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 04:40:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="984286225"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="984286225"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 05 Jan 2023 04:40:25 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 04:40:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 04:40:24 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 04:40:24 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 04:40:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PExTNjEauIqOxBlwWftIr/3Hx0UUPFYs4U0GmKzSHWjHkGvsZTQo/+nga/5V8jAayNA0PeAeOPr5ZD0A73IKe4GdpWjN8X8TPMiO+NhrPdIn/owm6iU6GlzF5Ys5DYsL8WvHwBl6+NgzkiYErSZVE+zRJ+BJ7jt3SFZhiCxkkN3XNLqDuqDoB6jj9aeL5gQ5/CYkvavpu/T4KctXsbDPfLsha6MJ6LNI7ZFUNmG/gZSa9q7Bd/ew9Rc6EAVb3Eqz7xvinCv4C/+WtI7+/AlD4lVGTQbClOGPpOA4BPfl9xdKv9UXFMWVlP+DviWS/MS0fnGZ3Y9v9ayWcm4VI6Piug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f87Bi+qUuPP1CznyOfZ1LfJ0qp2cydeCGVE5ciXhH44=;
 b=MtFr8HSoT0hvGx6nKQXhbwmk1rksr05nUCVrCT8m7Wncl4TFtGGcQS1gt+diGjjs0n083kAx4tNEDCTLPjmCUgh1Lvv7ceCTqWV8g+Fo95e3XngWjjqucobsko+62ZF20FqTIJ5aKNT37/y/pNXABqaMpCJ3eztWpwxTPTtR09mPYWvONbmSa/AqEtQE51LtEZMJkzHLDtkhIjwbVfN6XQyGglQz7NoYis7AKIrwS2pJTYwc0wZw1ntgNBqN6mRML4F9kGmxWMyu9JWLnF+XACKgCQ1CDKemo9sNmd9tiwRAtcvGX8hNv5rzaK1L7Wpc38MpIzt959j4M8khxnqRrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB7121.namprd11.prod.outlook.com (2603:10b6:510:20c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 12:40:22 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298%7]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 12:40:22 +0000
Message-ID: <79d2e66a-3633-ff3a-bdfd-656c735c85e0@intel.com>
Date:   Thu, 5 Jan 2023 13:40:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 1/9] tsnep: Use spin_lock_bh for TX
Content-Language: en-US
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-2-gerhard@engleder-embedded.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230104194132.24637-2-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB7121:EE_
X-MS-Office365-Filtering-Correlation-Id: cea1f0a3-bfbc-4cbc-24cf-08daef1a02e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fkWujwU05rhk3AFEhw61nl8HHVlkfSCCIUHlrPVZMhVbQ2PK9tfCZnmONpAh1z0c8eRnxAwOLd4QIsBA+GC3toI9QpZ3SHsOwdcIqwdzm4JumerYkSKoi0C7sUyAkxhiPI0hSHuYLDGWcddObnvwNtvhSEg76TZYZJItH7Wz+bSzjp83Ua8bVT/J4TVwKgdM+roBREoAivyIR1b6PiqPsMFakIqsE+16ZBEUPcd6dJKcnL7OcbhfsTmTEmnz6PHrWNDAyqir/6APG+iVTshdffPD2oLiIyHata5Hm4frDish8KpPAHrv79dNN490orVEnK3y7i3sXsvF5LAWKGy2wznR6T5QqMsl7Tc+bGB9o853g6Z0ettatZPD2+/Ue9090CGIVQIJFAyUKfvWVDNAiog5v6hKPflNmsUasSnnP18URQ/HrmZ7aHsd6bLbkBm2b2s8MMVsuFVGgRW+Essy71eHWp/5SiGmV6njxAoPxOcMY5PjOjN68yRBrAzuM/pjXNWtlNsNIjTajpTpvWFfFhdpvFjkg089gDTPqGTSgg9Lo2MK+NxlzMVGyMpE39H+goZVx+ZKnGMKW/5AqBUbAs6I+/ce4YTq++8F5WJNKndTWIXFsg7+Otc7C100wKigydcFXtoQU4ZCXwuVIHvV0RO9Z015l0PAd6ZzdhNgmCtSCtjrkuUqxvD++N+h/JfLEHyQjntPKOECnc+feYd2PUjl0a03Q+pTlx/TBQEk3Z8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(5660300002)(31686004)(2906002)(41300700001)(8676002)(4326008)(8936002)(316002)(66556008)(66946007)(6916009)(66476007)(478600001)(6486002)(6506007)(83380400001)(26005)(6512007)(186003)(6666004)(38100700002)(82960400001)(2616005)(31696002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmphRFB4aWR4QjBMYStqSzVQVnhPM2hzdVYrWjZoQU9Qc2xwMW40U2tGbElY?=
 =?utf-8?B?b2tJNTFWankwdkx5ZkNiTEhNVkpWK3ZCdjJBa2RWQXdsWHVLWEhGNDlrN2Vo?=
 =?utf-8?B?S3dVSjV2TTZQMUt0NUhKVGI1NlNFSkxDbGJwUFg4bEdLQVJ1bmg2aW1ZV1Ry?=
 =?utf-8?B?Z0VlaGF6ek1wRjF5YnlReWxrd0NJL2FZTUhXcUtMKytWaHhGTEdKNEY5d2FE?=
 =?utf-8?B?ZjJuSWcvU29ZL2JOWEJuSW0yZndqL2pNejRLYit5Zzk1SnRCTS9OSkdEdkdK?=
 =?utf-8?B?aUQrMEpPcmk1RkhGYWtQclcyR3IxRnNxemNxOHFMUzM4YlcxMjZPVkZDb1Ny?=
 =?utf-8?B?WTlDVUd6bE9vYklGQlFNc2F5M0lkRHZwL2hvM1BNaEtiaUpKVE9zNWRNZjg3?=
 =?utf-8?B?MThVL2dnSmVvZjlIM0t4RDVyTDhGMkU5SnFRS20wMWZXcnltOEJsZzdFOUFj?=
 =?utf-8?B?UXdvckExWHhsZVQ1dlY4OU1HYjRaV3hsRkoreXp2Z0FzTkdsTTNoVmxPaEFo?=
 =?utf-8?B?MHNnenl0YmI5emM3RXJDaEZNeGVrZ2pXT0haQ2NaZG9RZDJYaWg0TElGZFk5?=
 =?utf-8?B?RzFGUWRRUHVsOHFUSmpFeFc4eEZPOEorS0x3bFJreUFCYnZKRDQ2NTBUenVl?=
 =?utf-8?B?czM0Sy83aEI3dzRibVpLa241dllPekJPSk5zUjhHako4MElLTE1NZG9Xd1R6?=
 =?utf-8?B?TWgyNEdneG8wZXo5RUlYeUtWWmluNlkzQlJyYlVFODZYK1R6WExvVFlpTDBw?=
 =?utf-8?B?QzF3Y3ZRUExpUUR1VGJQeExmNm1GNU9EMTRiVlhKOTRWcTVSbU1JdWxUWjAy?=
 =?utf-8?B?c01qb0dIdmNORmJXSzZlMHJRem9aK0Vwc2Y4WTVtbU9aMU1sajYyOWdZRGdR?=
 =?utf-8?B?Q0cyY1dOaUtyWUd0ZU0vWDNlNFczYkhFNHZEQUhKTE5ySVJ4bGx4d1VMODJZ?=
 =?utf-8?B?bHR4VjBONDlJUW1JcTBzN0w2N1NsdUxzZWJ0TTN0RDZXcW4raXBZd2RiYWZs?=
 =?utf-8?B?ZGw4alRoRW02cmZBUHhIS2FBRFkwc01XK2hKWFV5RTRNYmxNaEhEWW52Y1da?=
 =?utf-8?B?eVczVW9MU0c5YWRaemtQc2xvYmtNeEhQUmlXblNNcVRJcE5nY1NlcEJ4Q3Ft?=
 =?utf-8?B?dkpybThYMFdTM3ZKdHUvOXJGS09sUkRkRlQ1OS9HeDRTaXBpaGo0ZnpNTC9U?=
 =?utf-8?B?SHU2SWFzUGRjTDJNbHM0MHJ2aUdPUHpaRVhTMVgvQmZnU0lUcU9mQ3gybUhX?=
 =?utf-8?B?TTdscU9FQVJza0NIUmp2WlZ0K0o5bWJXa3g1M1Vsd3NGSHFMeXZ6NEZ3VGd4?=
 =?utf-8?B?cklyWm5zMWtlR3o0ZzdzMlc0MS93Qk1sOVFIUlNPOFdsZFEzVlJkZnFUbnRO?=
 =?utf-8?B?ckJiaFd0QTNRRFRKRHBiS0V3andJYXEyUDRSSXRmZWdEM1lucjhERlZYQnM4?=
 =?utf-8?B?M3BWaGpjSWJFczFDMUhGdDhVMlZySndCV2hVY1duYTJlTWtqOUxFZExhNkNM?=
 =?utf-8?B?d2VlUTdaQ0QwZWg4V2UwYUFZcEpiSWI2REU1RnpoaTlaeDdCRDdHc1JqaTB0?=
 =?utf-8?B?dU5lRmFwZ05GeHMzVFhsQ0I1L1ZBNDc1ZnQrNnYyRm9JOW8rdHY4THdhaHk4?=
 =?utf-8?B?dXNDTU0rY0VSeTdsdWVZTUpYdjNpemZDMWFrc2V3YVNHVi82UExuSHZmcUJF?=
 =?utf-8?B?cGtHdG05YWRYc1VIQ3Bra2duTkpsWVloMlNyYUcxMGM3VzRsRnk1L2JXTHhD?=
 =?utf-8?B?WkFNb0s0SmJEbGJJSnYyRTJWc3p0Y2VJbmlMSU1hcmd5N2ZiaFA0cjNUejc0?=
 =?utf-8?B?a2tjbDhkL2FUblFJbGNxSG5IZlhyQm1vZzBmWjFUWHErWElLMXAyTTFMZTM2?=
 =?utf-8?B?VysvNzd1ZGFHalhyVzAvYnlWeWUyVUtJMzFaSHRrcXlaSFc0dEt1TUFYeGVC?=
 =?utf-8?B?SElWVHpNb3h5NFM3K0QyNVVCdVVoUFh4L05Idlh2a2xpSjJUMXBpZ25McWV3?=
 =?utf-8?B?SE9WeSsxWUc0ODMvR2wwVFQxdmU1cm9IbzZtRVh6SDkrelE5a3FYY2E0elpQ?=
 =?utf-8?B?U2hjbkVoSy9icWc0ZC9WZWhTbms4TlgrQ05HM2Q5QjQ0eGRJOGVxN0pHdmgv?=
 =?utf-8?B?YVBodlhpSzZVbTQ4dkxjelJFVkZHWjZ1QnZBS1NYQTJBdm9CVDVPdWcrWFIx?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cea1f0a3-bfbc-4cbc-24cf-08daef1a02e7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 12:40:22.5893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eb+hlrLfyIDVmnfF9chRyAGRpNhuwEg2KTFjTKUVYYC2ZwIOl2hh4I/69LYu6yifxfi9X7SsuEvXzQRLF5Vzc8D04BEpri9DBsFTPYtEp8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7121
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

From: Gerhard Engleder <gerhard@engleder-embedded.com>
Date: Wed Jan 04 2023 20:41:24 GMT+0100

> TX processing is done only within process or BH context. Therefore,
> _irqsafe variant is not necessary.

NAPI and .ndo_{start,xdp}_xmit are BH-only, where can the process
context happen here?

> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index bf0190e1d2ea..7cc5e2407809 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -434,7 +434,6 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
>  static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>  					 struct tsnep_tx *tx)
>  {
> -	unsigned long flags;
>  	int count = 1;
>  	struct tsnep_tx_entry *entry;
>  	int length;
> @@ -444,7 +443,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>  	if (skb_shinfo(skb)->nr_frags > 0)
>  		count += skb_shinfo(skb)->nr_frags;
>  
> -	spin_lock_irqsave(&tx->lock, flags);
> +	spin_lock_bh(&tx->lock);
>  
>  	if (tsnep_tx_desc_available(tx) < count) {
>  		/* ring full, shall not happen because queue is stopped if full
> @@ -452,7 +451,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>  		 */
>  		netif_stop_queue(tx->adapter->netdev);
>  
> -		spin_unlock_irqrestore(&tx->lock, flags);
> +		spin_unlock_bh(&tx->lock);
>  
>  		return NETDEV_TX_BUSY;
>  	}
> @@ -468,7 +467,7 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>  
>  		tx->dropped++;
>  
> -		spin_unlock_irqrestore(&tx->lock, flags);
> +		spin_unlock_bh(&tx->lock);
>  
>  		netdev_err(tx->adapter->netdev, "TX DMA map failed\n");
>  
> @@ -496,20 +495,19 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>  		netif_stop_queue(tx->adapter->netdev);
>  	}
>  
> -	spin_unlock_irqrestore(&tx->lock, flags);
> +	spin_unlock_bh(&tx->lock);
>  
>  	return NETDEV_TX_OK;
>  }
>  
>  static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  {
> -	unsigned long flags;
>  	int budget = 128;
>  	struct tsnep_tx_entry *entry;
>  	int count;
>  	int length;
>  
> -	spin_lock_irqsave(&tx->lock, flags);
> +	spin_lock_bh(&tx->lock);
>  
>  	do {
>  		if (tx->read == tx->write)
> @@ -568,18 +566,17 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  		netif_wake_queue(tx->adapter->netdev);
>  	}
>  
> -	spin_unlock_irqrestore(&tx->lock, flags);
> +	spin_unlock_bh(&tx->lock);
>  
>  	return (budget != 0);
>  }
>  
>  static bool tsnep_tx_pending(struct tsnep_tx *tx)
>  {
> -	unsigned long flags;
>  	struct tsnep_tx_entry *entry;
>  	bool pending = false;
>  
> -	spin_lock_irqsave(&tx->lock, flags);
> +	spin_lock_bh(&tx->lock);
>  
>  	if (tx->read != tx->write) {
>  		entry = &tx->entry[tx->read];
> @@ -589,7 +586,7 @@ static bool tsnep_tx_pending(struct tsnep_tx *tx)
>  			pending = true;
>  	}
>  
> -	spin_unlock_irqrestore(&tx->lock, flags);
> +	spin_unlock_bh(&tx->lock);
>  
>  	return pending;
>  }

Thanks,
Olek
