Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543CC65F2D9
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbjAERfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbjAERfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:35:17 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12654102E
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672940116; x=1704476116;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fstbOc3r+KCf+H26rhVOb8uWJPuWoUBRmhVaq5FXz6o=;
  b=UUG8bv3cN6HoIC6t3Gbf5p8iQvtCqY++kW2CGPqPGXzlS3lXrXoE+5qn
   11fc2/GVF6UI4PB9Gq9SeeV6XFAkmxYvqwHX/KRpRhhV0tqrMcNb+Xb8q
   qCwKkuJ2Bn853z6x5Oe1Ibv17cRgc9WxBENKNFlXKqxjoeuOIlsU1xIUl
   CLJyAPQwAz6QEhQ2hbBzXzTx5C+rM2kG650zJZ5VRXaLTCTGzhJdrYzi6
   mQlxKR+I1Kx9GBcBz7FpOri3HCZXlmpPgAoyAdY9KGkqr0Rhe3LbcVgVN
   8hDoPHhyLH49qy75DRhr+dLXW2wql+BaM88FB7Y30lgFVcEOGLKlvNxnd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="324291314"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="324291314"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 09:35:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="744344163"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="744344163"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jan 2023 09:35:13 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 09:35:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 09:35:13 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 09:35:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGog7uAJ6dOFnXPZlLXTAX4iT2d3Q1Btu7CVaYdLqYw49Z3DLAFDShTmbTKfbl75Ddk/x3HtAgOwXxRETMNAQ7s3c85PPsYOhOH1tDVYgB6GgHLjOsQJNW3AMyALYWveX2TUQuvo3NNCzNpNYSCEScgbMnkR3h1sMQmH6zBv7ByxxSkld19e9XCHSFOIl9JG+GBqKjCHHWEDyYKnLjjo0Yn3SSy4gC/LFmtGhT27BvtSZgKnNf53qXukYh5WJ3ybYF3kWKFpdqVfvLWwOMVbYuB0WABwClyf4LIP3PXAdF10HzW+ILeFuAvNzmE+qpsUd6zZO90zYzR5L9xtXouRIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7UCFbLAzSPQVYKUK40H8LDjL/nH8Xg3SesW8AT6+x4=;
 b=eSbwuVbF8/ImZDbJ0QEuCBMkO9hXfY5OoALXfvO4uf1o3RRZtWx6+L3CQ3GCLp1BFpoWcc0We1StIuExXQCfvZ++MVm6KVxfQqe4MBoVjOpvrpMh9mHQaWXKCBUFJgRLz9R7MOncPxpMVmXixofC9bCyMSB9OQx2Z4eyKlhbcZEWy1hKUojM+UhtKBWFHrV9iCAc8wwbLVyosMQCGyMkhALjRmdFH6rlfh/0zwGBUNGcJAbL8Rh6WLkulsK9XsEo54wmm9iY9PcgCFCP8AuISyd4WCoSC9iIP7lhJZyW38kCOq29aT8ZHg6U6AXithUwcsTqZ/f0S3ysV8EZcrmhBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB6394.namprd11.prod.outlook.com (2603:10b6:208:3ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 17:35:11 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298%7]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 17:35:11 +0000
Message-ID: <1dbae52d-6aba-467a-a864-24eeb3f96449@intel.com>
Date:   Thu, 5 Jan 2023 18:35:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 8/9] tsnep: Add RX queue info for XDP support
Content-Language: en-US
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, Saeed Mahameed <saeed@kernel.org>,
        <netdev@vger.kernel.org>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-9-gerhard@engleder-embedded.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230104194132.24637-9-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0438.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: f827e888-6396-41bb-462c-08daef433222
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pla4qqjYHKWybbVd6rC0XSpqBIRNlaUPdTqhC09QmFNk0Vz68F/eRcPj9ommW7CjSyYfbI77s3wiLBjINRwDYmwBNlC15sNJoQC8UgVtZs8XfoH6M+mvtUL4N1yeHn7L/B0w6YXsM1S/Ya6z/6sw9dUP6Ef76FcJyRd2+bZ2c5ANM2TXXpCeJQbthqLhuMR9gPFnLE2tDdsgy3kYHndLamdG1jvgrEdgiK1iUOb4cL/CLxYR+Z0g2MJ+0E5W3I5PSCUTiYmROn+/jarVTKJ5TTMGc5CLYZRGtfvMugZFablpgv90djLdFl9m7PO7enG8U5wKgtw6Wsy08L1THu7Ru85yEmXBGJbYF5bF6bFE3jpCtNLAq6vLv3QdsaCicfmOqYwSlfnD8a/j8os1yaIr6oGF3xGReIQ0kS2rlRwGH3U/WFumA7kuV95mF3uuUEFr9Ue/GC1qG+a78o3Fqn5Yr0VdIaezRtmhPD3mNvBn2B1nUkwi9LDoC2n5hUNvUaVgBfvtrAkIYWmwPfwt+iuEv3zF+EbqUIBdhiVBUeMSw2CG0ADGEfe6X+8JH2UKlkEm9XQhBfqGZbSWkc1yvFEQCXYlaC3nKdIFRAfCaK5FHLTqhbOCFK/qV1AwdwRjzWvrZobQ/gmKq9HwaK57rhaZbgG6IN6/0TApHNm8eytoYXfLvSrOgbqjPX9zWYfBRQ5ZUvxUy5SuavAoSZElXCOgvUwdUy6KtIvHmAiHA4qOszQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(38100700002)(82960400001)(478600001)(31696002)(8676002)(41300700001)(6916009)(4326008)(66946007)(66556008)(86362001)(66476007)(316002)(8936002)(5660300002)(2906002)(6512007)(83380400001)(2616005)(6506007)(6486002)(186003)(26005)(6666004)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHljWEZtWUxKbEk5MGdXQ2RGaUZucnh5ZGFkOGdGcEt6TmRzRURZTFkrT2Rt?=
 =?utf-8?B?SnZ0M0hjYzJEZUd4ZUNZVFdsNXQzZDBtR2tyeUJqcVJseDNTZWgvVld5eldC?=
 =?utf-8?B?NlozUzBwVUVOZnA5dlFVbDlUVk81WndpTzZWRy9uYjR5b1dEWnNHMVVYbXE4?=
 =?utf-8?B?M2dQQW8vdkJ0bjFKMDBLaVdSTXNZUFJrZGRzMDRmQlp6azVrNCsycUc5RHpn?=
 =?utf-8?B?Q2VLRFdJT3FoeWFhcis2U1JDd05xQ2dCbGt0QitKOE9BWEdHZ1ViQUZKNld4?=
 =?utf-8?B?b1hUZ0s3Ly9LMnhhSXQ5T0lPcmxXOTFwbnV3U3hvUmxEWGtXNzhGQnd5UStr?=
 =?utf-8?B?ZVYxRENoRGhhdGZQVlJweTA1M0NQK28xK3cvYytGc0VBR2V3aWZTTEtFY3pC?=
 =?utf-8?B?TE9KUHc0OTJmSHlhWk9yREMrRm1jbUVNd2ovRDQvS3Q2ekI1TExiZHgxUEw2?=
 =?utf-8?B?aDdyNWY0aVQxc2wyLzM1QlE4OHhudU9tN0NUWWNvQVMzbVJxdmhKL1VRODlT?=
 =?utf-8?B?Y0poVzNNZFY4Sk1MYlp5cThZdTBvTnpnQkwzZzJUNUZjTjkvNWVsSTNQbCtz?=
 =?utf-8?B?WnBocVd6SjhrZklWSUhhTHR0MHpJQ2VCcE14OVBBR2ZsUUlpdjdSdnhlOTNz?=
 =?utf-8?B?MkpQWjltYTBqN3ZPUHVvbDVUUEI1YWN0Qm1JWmdZTGJyYTNRbGcxMlFvWCtX?=
 =?utf-8?B?MFlXU3REL3MyS0dWcGY4enJ1ZU9KSERvTzFZMDdLNzN1V1B1TTlONnFYUlh1?=
 =?utf-8?B?VHFsWGpYM0Z4dTdFMjR4WGdWZG1LYmRBOW1oLzVNMlgzOHRsZnBSZi8rZ2RN?=
 =?utf-8?B?SU1kZllnVFVXZG9CdmJEV2ttUXpZQ3F5L2ZBcGZEOFVXdDViTHBIS1pKZXQ5?=
 =?utf-8?B?TzY4UnZ0UTFGN3BEWmRGU3hTUVBYWnFzQUx0dWthcE1qQnJjWXJ6K1IrT0N6?=
 =?utf-8?B?Tlltd1NPcFFBY3kybU5hLzZTREwzK1V1QUc0amorNWlEc1NMZndLdEFQbVdz?=
 =?utf-8?B?TmY1ZVZHajBlV2lUZzhuYUpabU9xYlBDUnNRTElhQjVLTng2aUwwYmpnWXdm?=
 =?utf-8?B?ejd2K2J6U2M4M3pGSTFUbWhCZERPK3dzbHphMjIzeXdhdXk4MmJGSnZLcXJJ?=
 =?utf-8?B?Y2UxSVBlRC9aMEEwdG5OVFZhQVg2RFVGb1hoeWNnb0pqRlNDeVpMWmZtSDRa?=
 =?utf-8?B?WnFxTVRTS2dUT0FyelNGaldGVEQycGxKbzBGZkFDVzR4Tll2K0lhVkNLOEpZ?=
 =?utf-8?B?WHpmUjhCVlBtSlN3clNGYjJXZXhGcFc3dkJxM1B6Tzk3VDUremE2L3ltU2NM?=
 =?utf-8?B?QkxKcDVrRHpDWkpBZzVycTBZZVVpYXJlbTk5cGw3OWs3Y3RsV2xkcWg1UWVB?=
 =?utf-8?B?c1QvQy8wR2t6Rmw5VXZyOFBJYlNOVHpSYWdxY2Y3OHZRS3dRMHN5MEQrWU9S?=
 =?utf-8?B?MGdNRU10OXFHc1NLZ0dzY1pPbDQyR2VrZ2Z5Z3BnRHV3VlU2bldxc2s3WnNy?=
 =?utf-8?B?ZjdNNWI2TEY2MHlvTDRNOE1wSTFXUEgwbDFWdmhVbWRyRDAzSzlvUm1qR28w?=
 =?utf-8?B?WjE1VnpnZ2k4WjlXZTNCOEFhN3M1YVpIT2V0RnM5dERTc0lid1puQnFIQ1V5?=
 =?utf-8?B?a3luNEZMaktYUGpyalQvNG5Kc05BM2VTRVd5ZU93RWFBTHQzclVsLy9TYWY4?=
 =?utf-8?B?Vzd4WWdtQjhubHUrbHBTNHB3eGVoQkFzUHNrU3IxbmI4UWNOaXljU1Z1SVVz?=
 =?utf-8?B?S2N1djNQZ3p3TFMxUlpOZmVTdUVEa2Y2T0hHME9OblVISHR4UWVVVFczWjFO?=
 =?utf-8?B?WDVmVHp1OWFtS0lhVndGZlBmbkRGNzNQSHpOZjF3Tk5YdmZmNlVnNUdkRlFq?=
 =?utf-8?B?VDRGUVZ4MEtDUzIzSXd5Uzl3dzR6WnZrNnhubUkxNmwyZFcvYklrQ2k3Lzlt?=
 =?utf-8?B?RWs5SWh4ajlvd1VodjFENzlKVlpGWndrQ3ZsZ0lCS0lLeDNSRXJhcXVOS2Vy?=
 =?utf-8?B?Vk5Remd0My9yMDJKQjNvK3hOankxNGlpaGFiWnZUTGQ1dUZxblRZeEFJS2M0?=
 =?utf-8?B?TG9FakJFenlwOTREY2QxZnlyTnAySFh5aXk0UjJjUmIxS1hMWlNGTFdlSzBr?=
 =?utf-8?B?cUVjNmw0dlk4dmhCd3JmWWtuT3QxQlhEL0RYTHFNY0IxZ0ZsbTdpaUFKVldE?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f827e888-6396-41bb-462c-08daef433222
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 17:35:11.1175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5iyMgnIQZ81zw/z1+eEjvkvrNjvh3YnxIsMKg0tHeNgFqvKflHJicW2JBP/o/sOINXwza81jqV0l02pI3O5tDFrUF7tsfApQnqgznEYfs9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6394
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
Date: Wed Jan 04 2023 20:41:31 GMT+0100

> Register xdp_rxq_info with page_pool memory model. This is needed for
> XDP buffer handling.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |  6 ++--
>  drivers/net/ethernet/engleder/tsnep_main.c | 34 +++++++++++++++++-----
>  2 files changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
> index 0e7fc36a64e1..0210dab90f71 100644
> --- a/drivers/net/ethernet/engleder/tsnep.h
> +++ b/drivers/net/ethernet/engleder/tsnep.h
> @@ -133,17 +133,19 @@ struct tsnep_rx {
>  	u32 dropped;
>  	u32 multicast;
>  	u32 alloc_failed;
> +
> +	struct xdp_rxq_info xdp_rxq;
>  };
>  
>  struct tsnep_queue {
>  	struct tsnep_adapter *adapter;
>  	char name[IFNAMSIZ + 9];
>  
> +	struct napi_struct napi;
> +
>  	struct tsnep_tx *tx;
>  	struct tsnep_rx *rx;
>  
> -	struct napi_struct napi;
> -

I'd leave a word in the commit message that you're moving ::napi to
improve structure cacheline span. Or even do that in a separate commit
with some pahole output to make it clear why you do that.

>  	int irq;
>  	u32 irq_mask;
>  	void __iomem *irq_delay_addr;

[...]

> @@ -1253,6 +1266,7 @@ int tsnep_netdev_open(struct net_device *netdev)
>  {
>  	struct tsnep_adapter *adapter = netdev_priv(netdev);
>  	int i;
> +	unsigned int napi_id;

Reverse Christmas Tree variable style is already messed up here, maybe
you could fix it inplace while at it or at least not make it worse? :D

>  	void __iomem *addr;
>  	int tx_queue_index = 0;
>  	int rx_queue_index = 0;

[...]

Thanks,
Olek
