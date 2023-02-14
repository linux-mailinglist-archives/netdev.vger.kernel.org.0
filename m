Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7F1696BD4
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjBNRgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbjBNRgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:36:46 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFE0B776
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676396204; x=1707932204;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=45vrtkrK//TYAQieiEfloFaxV2qR9XzR4kakA805gmc=;
  b=Krp3Firf2kb0jlk55yphEs/mIVDy3uGjLD9hXpCojygyOGOScPOuK2ER
   XHWX1cslpKWP5RJ7hE+f2IKwjleqkW8QgGTdAFZxQFSAmLqtbLC5UF/If
   zckStYik8QbjHe7/Y9WKgWM3A+LToly+O94R4z4YRlTlibV67K5AvzRGT
   iaag4DKd9Np4zG16E3qeWF0bltU5tQodaH6IkJSP8r3mS8nkDnBkRKaMU
   JPHwWtG6MTbMIWzsJ9qRBcvkOdVsgI9WJcB37346r+i3tGoUrJgWt4jEN
   l7f9ZuKhRwjs+nJIwyLq8/GSbEiuUALR5t73eUOemCAIeg+kY5Us5cH0w
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="395832260"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="395832260"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:35:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="732954024"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="732954024"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 09:35:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:35:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:35:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:35:42 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:35:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VP7B43fXeG4TjXgjqNxpexCmnWZd7oYK+XeC3bgygPz5TPf7TDcsVFkTvKc09mLnAGTKuC6g3jsZ0RsJufngz7Lgm4zRwJgm4PcDqRxuHcEMclQaoe+vB1IFPvuNYr6pn+BbwajoHwDI8MnK3rDwNJm6IRly/yoHJLbyMvSHJFlRwiHY6kfkFjWDiURhvip8ZhhepZ6QBMUQboL1ImYYdniVDLlUJe/0shhe2d2ldNLRBq0qd9lYOmfu+vfdpgFDXqMogV8DcoiDABNHKCj0bKNvQ+JpqcYnvXJZUr897ESwS1/tCrnyNqAKaVBiW4ULEW6rLGtsYNH6Zf3Um/4JqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cin4PUcZDmHDuujZpdz+anWYro75+QEKdKOdUpsvhD8=;
 b=QnSAqop201bd2gFcIjdtvBS4nvvHvmDjceNbpvn36Xl1pAqyNeTOHilAzsOWSZJcyiHhf1z9OFj/SyUjqIp2uLRXwznVvh2vFyCCTkkVQIcKeaTnmJKkmL6NQ25mNYkjIxQ5OnG7n/+vHPldpg0CuE8CbDOFyGaWHuyk/IM7oLsfqoMrnKOb3cYq+F/wJtP3/i/LMLabhcELkkrNjnA8+gO3bUcM6lkSDpSfCa2xfzI+YTRqmZzwKSPlMgkgqnIOq7JkkMDgzO2LCPAQ/m9vkHz38mQHGKlm13CcREJONmV914bCmC4XIHrzPd3fmiAOfBXySx2ll0WY6fWYdaHhYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CO1PR11MB4804.namprd11.prod.outlook.com (2603:10b6:303:6f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 17:35:39 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 17:35:39 +0000
Message-ID: <6d2a84e9-be27-6707-3d65-b00c8e206d2a@intel.com>
Date:   Tue, 14 Feb 2023 18:34:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v5 1/2] net/ps3_gelic_net: Fix RX sk_buff length
Content-Language: en-US
To:     Geoff Levand <geoff@infradead.org>
References: <cover.1676221818.git.geoff@infradead.org>
 <de8eacb3bb238f40ce69882e425bd83c6180d671.1676221818.git.geoff@infradead.org>
CC:     <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <de8eacb3bb238f40ce69882e425bd83c6180d671.1676221818.git.geoff@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CO1PR11MB4804:EE_
X-MS-Office365-Filtering-Correlation-Id: ed9c5efd-4d85-477e-709e-08db0eb1e370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rub1tux7dA5D8VpjwcTi76Mf2R5pjMP5RMc42LpIwz9KizWUKI5Q+CLvuec+770RW+OcevcWu7CmW59YPzdPrNE194bTxLoMCycw4cQFitd0MCmnE2gtUdb7bRb0VBedN+0vvqZk+7ZTLruO5KjzyVzrJqrdurDuFvmrIpZmB4uqhXEIhj1hhdXo3GvVWUa4+ETixqWVzHQETDb2ARi50pJaTgInmxEm0wr/02umyFbDCLwM6SR6eQPS9QGuKO74JBPM26yKFwFD/n0xYqjPM0ozI3/eGPi4IM5KkFbb+X9kehjsMF6fmsOTvqVOc8c3FiO/ivqm6rOleJ2RBTagup8sLuTkahywIR8aF0zY+Zm8wJYVliXGgo5JfynlTTGw+O4nXoQDLPsQsZVZjewWTib6SVdpgPm5dx3l43YZO9oNrUEqBBUN+peX+minCmFiZiKzjTO8B5i+ZgNe+JfE1MG2xCQIIplHBhsAXeLj37sAIg7WGPvnfTMhS7f/rSr5z8C0H8V0nNu9qPJkNCzFccq7itbHaXIJOKVRTGdFFNN6Ehe+DdWThDZT70RilmlHPtEbq1GveseNpvcBCedAHXaThYAR+Og+q/6qb7bVfY0hau46qYr4CtiNvX/aimPDX7V4TUFlN1lzJq2OHKrdHQMC5rTxScCqYBg1ekRQkEQ0pU+hnfJJhziGygEg/CFDhkAdAoYUmTlvAumWZ2Xi3cVEjMB7T104I52etPQsPsw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199018)(31686004)(5660300002)(83380400001)(186003)(31696002)(36756003)(26005)(2906002)(6506007)(86362001)(6512007)(478600001)(41300700001)(6666004)(6486002)(8936002)(2616005)(316002)(66476007)(66556008)(54906003)(4326008)(6916009)(38100700002)(8676002)(66946007)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cW45THdmeTN5T2ZUK2Q1a3ltWm0vVFVpalljTVoraVFVVGFQejhUNFA2NlBs?=
 =?utf-8?B?ZTBEcmRlZUJ5ZXptalgyRkZjbVFGM1VmVHphYmVsbXZpdHNRNUxScWNzVkRl?=
 =?utf-8?B?YllzRi9mK3Z3ZnNlSHp0VHZCbkNYT1JDbXRMZTNKRkZNUU5ob0xqaHdBUE9M?=
 =?utf-8?B?UlRDSW91NFQwcEZSeWpCMzd4RW1HS1pCKzl4WVhIcE1lVmRQQnBqQmg4ZWli?=
 =?utf-8?B?WUZqcER5YXlhajJvSGxSbXovY0N3ZGhKTjNneEFkRmRzcmxxbXl4NEdNVU5y?=
 =?utf-8?B?Q2xCWmJBMWNXVFlpaGt1SmErN0xsNEx3TkZPdGc2K1JZcGpsZGNxTGh2S1ZO?=
 =?utf-8?B?SnVmTWNySW41eDJvSnZDUUlmWmFYTlg2MEVBbXNjemFndEdzaFpDTk1UZDBK?=
 =?utf-8?B?bzl5TUcxRUtpdEtFK2gvU2k1ZzR5ZUtyeHFHNXE5ZS83eTI5cXY5THgwOGFZ?=
 =?utf-8?B?QWFNa085Y050RTYwbnB3WU5Ic3FWMlZTMTByOG9vdFp3UkVnQk90cHNsR3du?=
 =?utf-8?B?NWRzbzAzc3RKNjVYSTdLTWs1ZkVQVUlheUk1STlIMTdlZUpoTVpBbDV6WkFz?=
 =?utf-8?B?YUsyczlqS0pNc1RPbzFmRUwyMytMcGhKMUF0T3B1U0xvbWZUaitiUU9NLzh3?=
 =?utf-8?B?NmtQWTZJUndEeWtWNnUvMTRYMldtZ0dPUHBxWndiV2dxMHF1N3pLa3JHSFV5?=
 =?utf-8?B?NXU2bmNpUkNuSld2bStZbUx6TWd1NzdMaGhjb2NEUFk5M0I4UDhYUCtlMXpN?=
 =?utf-8?B?RFNESzkya2x3OTlxWjJSMVFFSEEwY281RGVWYkJQQW9FZ0Y2SlNPMFNVZVJX?=
 =?utf-8?B?ZUpRNU50Z1FvUVRKa0R4UlV4Q0lGSVZHclhWVWt6OWpMOHpseEhWUDBVTk1i?=
 =?utf-8?B?WERhdlFIQ3VvQkdQekJsWDFkSTZRZVpnUG5ibU85VVhhTVZkZXVQVlZHNFcy?=
 =?utf-8?B?K3Fldll1QnpyZHNYbGllNGhSUis4bENXUjBFdTE0YXhLNXlaZDdudmNmTFFs?=
 =?utf-8?B?dzNPZUcrVmc3WDNZbWxOSXN2SWtGSm90NUROVm93UVY4ZXNpZUVoVmtaRFlW?=
 =?utf-8?B?WDdKQms2QldpdEtHTUM0cm1ZTFRNRkJOeWl1SjB0NHBYYlR1MkdlUTJBenph?=
 =?utf-8?B?ZVpJc3dveS9Id2RLV0hFVk1UdkhUUmlscnNyR3lRRWkvc1dXNmhYSFlEVjhU?=
 =?utf-8?B?MEphTm5ieUVVWnZ0SDZiUkh5bjVEdkFPekhORm8wMFhZRnhqbnFaQllFRWg1?=
 =?utf-8?B?QU9qRUs0SEEvaFRVdWZMSFFQNE9QdkxPUEloUlNkNm5lanQ5VlpvdDlnUG5u?=
 =?utf-8?B?emRuQ0ZESlJEeGdCT21UMFFaMGs2YXFtaERVRGlmb253RngyS0IxNjVlQXFU?=
 =?utf-8?B?Q3VCS0dJbmZPbVVyejBHYWxwZjV6dmpEd045a3NPakxjNWljNWJnaEU5SW5w?=
 =?utf-8?B?dGNLMEszVkZaMmEyZXpSb2FkQXZUYkFZL3UyMkpSd1hNeHNaOFAyb0Z2UVk5?=
 =?utf-8?B?ZjNCaU54VWpCMU5xQXJCVGJPcTBiTXFQVzEzbmVsa05zMWwrZzQ0bUkzWlQv?=
 =?utf-8?B?OW81ZC9mVnkvY1VFKzZWK1pmWVBvS1ZxS0U1SVRhMnl5eFIvTkFuaHVoditF?=
 =?utf-8?B?UkxvTUdrSkhsKzlURStxZkhGNEc2c25VT3Rad0ZPT3RTQ2VCV2FnUmVuYTFS?=
 =?utf-8?B?Z1psdHY4cmtIVDA0eEc0RG1iVmE5anJyTG1zQ0RtUEF5K2VDMjVBWkFzZWUx?=
 =?utf-8?B?eFBvY2cyamdTZnRmYXoyeHlpWUhVRGxRejRqWU43c3B2cjFOREEyaHU3OW5G?=
 =?utf-8?B?dUVXakJKQUZTSFp1djlpSVJ1ZkpGbHdwY0ZlS2MvUEFaTkZCSFNZRVUrWlJz?=
 =?utf-8?B?OHlGQ052K0dpeFFCVUdLOWhicjdURzdieWlEd3pmbXlHNVQyOFl1K01FR2FL?=
 =?utf-8?B?RmptV1cySHRFNnBnN3RRSE9KYS9ua3NZTXZQeU1jNmVneXZZejR5ZUl4TkVW?=
 =?utf-8?B?Mm41RUhLSlZOdG9CTHg5c1BUdFVlYjd4TnRnSnBPbjYxeSt0TExZVWFLT1Jl?=
 =?utf-8?B?ZnBrd1NrejFUZnJKalNkbDVXeUE1ZHNBNEkwSXRVc3JxeFNSZUVWSlVtR0tj?=
 =?utf-8?B?MTdZTk16N2Z2TXM5eEJySFFNK2FEeGhhclNzK09UeVlUcnRCUlkwZ1RBMEt6?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9c5efd-4d85-477e-709e-08db0eb1e370
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:35:39.3666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZgl/Fxycixf/EwQZjYlYejRkB9AkQRKm0c4gPsEQgysjOYwGQqSCuHgD2hQW2DVWJCG8Tt/OYPCHavg8KKJ3ZH+xwfqw9hlTzUy25ArcHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4804
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geoff Levand <geoff@infradead.org>
Date: Sun, 12 Feb 2023 18:00:58 +0000

> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
> GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a
> multiple of GELIC_NET_RXBUF_ALIGN.
> 
> The current Gelic Ethernet driver was not allocating sk_buffs large
> enough to allow for this alignment.
> 
> Fixes various randomly occurring runtime network errors.
> 
> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 55 ++++++++++++--------
>  1 file changed, 33 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index cf8de8a7a8a1..2bb68e60d0d5 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -365,51 +365,62 @@ static int gelic_card_init_chain(struct gelic_card *card,
>   *
>   * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
>   * Activate the descriptor state-wise
> + *
> + * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the length
> + * must be a multiple of GELIC_NET_RXBUF_ALIGN.
>   */
>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>  				  struct gelic_descr *descr)
>  {
> -	int offset;
> -	unsigned int bufsize;
> +	struct device *dev = ctodev(card);
> +	struct {
> +		const unsigned int buffer_bytes;
> +		const unsigned int total_bytes;
> +		unsigned int offset;
> +	} aligned_buf = {
> +		.buffer_bytes = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN),
> +		.total_bytes = (GELIC_NET_RXBUF_ALIGN - 1) +
> +			ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN),
> +	};
>  
>  	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
> -	/* we need to round up the buffer size to a multiple of 128 */
> -	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
>  
> -	/* and we need to have it 128 byte aligned, therefore we allocate a
> -	 * bit more */
> -	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
> +	descr->skb = dev_alloc_skb(aligned_buf.total_bytes);

I highly recommend using {napi,netdev}_alloc_frag_align() +
{napi_,}build_skb() to not waste memory. It will align everything for
ye, so you won't need all this.

Also, dunno why create an onstack struct for 3 integers :D

> +
>  	if (!descr->skb) {
> -		descr->buf_addr = 0; /* tell DMAC don't touch memory */
> +		descr->buf_addr = 0;
>  		return -ENOMEM;
>  	}
> -	descr->buf_size = cpu_to_be32(bufsize);
> +
> +	aligned_buf.offset =
> +		PTR_ALIGN(descr->skb->data, GELIC_NET_RXBUF_ALIGN) -
> +			descr->skb->data;
> +
> +	descr->buf_size = aligned_buf.buffer_bytes;
>  	descr->dmac_cmd_status = 0;
>  	descr->result_size = 0;
>  	descr->valid_size = 0;
>  	descr->data_error = 0;
>  
> -	offset = ((unsigned long)descr->skb->data) &
> -		(GELIC_NET_RXBUF_ALIGN - 1);
> -	if (offset)
> -		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
> -	/* io-mmu-map the skb */
> -	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
> -						     descr->skb->data,
> -						     GELIC_NET_MAX_MTU,
> -						     DMA_FROM_DEVICE));
> +	skb_reserve(descr->skb, aligned_buf.offset);
> +
> +	descr->buf_addr = dma_map_single(dev, descr->skb->data, descr->buf_size,
> +		DMA_FROM_DEVICE);
> +
>  	if (!descr->buf_addr) {
>  		dev_kfree_skb_any(descr->skb);
> +		descr->buf_addr = 0;
> +		descr->buf_size = 0;
>  		descr->skb = NULL;
> -		dev_info(ctodev(card),
> +		dev_info(dev,
>  			 "%s:Could not iommu-map rx buffer\n", __func__);
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		return -ENOMEM;
> -	} else {
> -		gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> -		return 0;
>  	}
> +
> +	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> +	return 0;
>  }
>  
>  /**

Thanks,
Olek
