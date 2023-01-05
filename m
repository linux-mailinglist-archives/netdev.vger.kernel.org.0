Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172FC65EBB0
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjAENBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbjAENBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:01:25 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97EE51304
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 05:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672923683; x=1704459683;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RprvZuxhw8MVtgZtpF0A417RBVonc8kk+MO3xa4eBEU=;
  b=cllYAfkj9Gt4qGt+dxGCWWp/QloO4kT5KoefB0eg9ScQnDCkAMldqs0J
   oZyR2DW+AQyCBOa77QBamfgLh4A9RJPvzx3YiOkVfsr67mTlM7slWl7Lt
   afSPQRqc40lzo+Qp8Fq6l2sP7MuFv+iXvJMD4Or/1eWDj4+Hkx9HZyBF7
   +QHmo4ZTU6rqZfc3ZEzevc98Y5W3a03mrcBEz8fr3rF13TvUYHdX7P9Gs
   D+nTWIusjUOR0I4mvOK66/NjxBL9D9OJsM9LVwLeAGNnHTWDtx3S1v1fM
   /0cYiQyeoa5Xb7GAkwyI3FMMKzX/jSVKwH4ZpAOdsPig/PVWpTG0iMyke
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="320905302"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="320905302"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 05:01:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="763124892"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="763124892"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jan 2023 05:01:22 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 05:01:22 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 05:01:22 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 05:01:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4/IWBNBYbGR+F3NKrx0NUOa83VsvdAnYHrLtjobhTDEnJopYn4I3837eF/dR0c49vPkc3lW9d/hd7Uhcm+fZpFIhabdfvJIz+INBpvPTHZ0iYzbt5AEYwx26Fn14XX1hm0Rp57mOc/Sx0w63nb+Cv8bND46u3NicIT4a1+hXqrnCOfoTejNZQgOHP4yzRun5bvqLcfzjVrD9bmQDALnRDruHoibzT7/YCpgTr8F4p6f6qfCHQFduDT3Jb+KPoagaLpCNzEQUWDtJ679xZzu1BBTwOIXQRhnLKw3bdQo7wTsRy1ulu7XFWns+3zfLn0KIcGjXLsQ2SVgkCGxqB4fLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tkP7IY++VytPgGnrRNILAL2nymIKqeSjVWX/O5FSPRU=;
 b=X3wAsrN0aYyqg4T9bquJgRfeCGJ9EsTfrZG8inWn1t69PgWiC8C0iDIfBH5C6bbwRto2H6BfHuys8dM/TgeK8FLgq5kr7G9ZS+7nslGaO/Y7XWYVUbhr3VouqnjNJVotdkLz6xFOQxnFBWaclBdMRK0ZKVKCucX7OfIR2EJqtLAb1tIHSqsOvxC7/VoKx27pYX6bKHJQ3AF0OpawlnSE3CKdfYMfwZRjhm8IgQAd7LGrdOM2ZWAO72EBV2k6iBKaAdTr2AuS29U+7TtCqtbe9SPbVxEvUA02YmqzuDqgfV4Nol99OUFEYWzh54IkM3gX+KpwjTLoceahAg7bx6KFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA0PR11MB7212.namprd11.prod.outlook.com (2603:10b6:208:43e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 13:01:19 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298%7]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 13:01:19 +0000
Message-ID: <0d4b78ab-603d-e39d-f804-4f5d2f8efab8@intel.com>
Date:   Thu, 5 Jan 2023 14:01:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 4/9] tsnep: Add XDP TX support
Content-Language: en-US
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-5-gerhard@engleder-embedded.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230104194132.24637-5-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA0PR11MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: 769b505b-e6da-4423-c9aa-08daef1cf013
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4k49Xlc/r5Req0DoP1PJqc2R/mMsINrpKrXxmKKHEkc80lF7E6iflzL4qHh6I7cxAj1v0hXGchtKAwtoWXIyUnlJH16nrk2kwA+IdAnJwlpXtTDsm4hE5RoLNDhoZkMsTYA+fsoyVFceS+6XSHqPTEWh12zEJmaZ6FDLhTXmRKcatpNUxLIHblNFHlla1QiaTS+GVPz6vXZ5J+K/VVyfdd578XwF+wwVcoTJMTfqBa8Iv7Q5dMtSadxyORifv5pvYPinOC0DdTlkQA6Yy7q9rT98YwY5MVNfRaVVXUKLqQjmEpKxvF+fJ2G/IoSv2amvr1BvcEO5iye3m3x9hAzpmpIUv9IGRd4+ezObr1HhPUjyVkGf74DPkOiY+aWjPsJ0BY9CV24ciu8TYugmbN0f5a3k+4W7Y8fM15L/1lelopsA+DRHobxPShB1SPA5B2Bebqx5zpLxUSKwJbcn/82WzjSAtueqk4S9rFvbipYWWIdE0xdvWBt3FpmlcCuOI4q5SFFYv1muPD8Z0+Ok10UAUCtCHg9WSGJ+ksr0GaPaAjawftRgEqgkJNmDsBOtKSAEFJzPdgVPThAHLEVNtaI3k7A8DNOT/V2WsBeEHzeXHO0qVUB/DjAT+EpV1QQ8j7V1XtlLX6aCV1EL+xCvUSHyBfhz+rC/Z+K6Efnu5Om4b/EhC/61feT9GO2aKpODQLP56XojMyHoqqDHhs9gSCi/7NHHOtWRhPpzcSQXI9WdBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(2906002)(5660300002)(31686004)(186003)(41300700001)(66946007)(8936002)(4326008)(66476007)(36756003)(8676002)(66556008)(316002)(38100700002)(6916009)(82960400001)(6512007)(6666004)(26005)(6506007)(2616005)(31696002)(86362001)(6486002)(83380400001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHhnaWx5UjVlK081YThlWSt5eGpoRWppNWlPeVVIaE43a0xhUUZiOVRpWWxB?=
 =?utf-8?B?SUdZUE85QnFQMlZvd0FwR0tFVzFHMTRJcUtwRkVXNC8vaFczKzFIY0Y2aFpR?=
 =?utf-8?B?TnRQS015YmdqOGdxUVR2UDNtaVdSamxQbnQrY05WSUpmRTRJWEg2dS9LKzZs?=
 =?utf-8?B?VTlSQThZR3EwbGtzSHhkdEs0UWwvYmdxMXM4ZDRHLy9qeGpuTm9Nc1ByVDJN?=
 =?utf-8?B?Z2tMTmxJRTdVY3RBcXFzeExVd3Zwb2RpM09TUUtSRWI5TEFmMTFndEJsZ3R4?=
 =?utf-8?B?bFN3RExVR2gzbEMwS2d0NHBjQWJUdGpaejVRQzFIZlpJc29MS2w5dThrN2tX?=
 =?utf-8?B?UVB5TTRlblU0aFFzSkNRTTZhdmtxaW4yK1NXclEvbU5MUGw1UlJrcHRHOEY2?=
 =?utf-8?B?VlBhRzN1NmQ4cEtuaitmdmN1dTgydE0rT1BPOVlEOGw1eS9EM0xzRmdIT1gz?=
 =?utf-8?B?NFNacVdwRzhMZGtEU2lUM2J1c1JUR3JpKzZIeld5SHJhNXRQRVFnK3ZWOGY1?=
 =?utf-8?B?eHpDeG9jdTZXbzhrbHQwQllkaUx6ZzVqZUhTakkrNlh0NFV4bkFtV2prR1JR?=
 =?utf-8?B?QVZwb3ZGU2ZxVklJQVZNZ3NkeGJtN2QrNGN6b0NDK2lna3p3bzZBSnJaVlAw?=
 =?utf-8?B?ZXdZVUFKMksyb2NodW9CK3MrcGNlQmhuT0c5em9pUENOL3pnc2UwQXNzM2F0?=
 =?utf-8?B?YnZDQzZ3QTdtTSs3SWxnd2NiWXdsYWNlUWtXZEdjSXl3Vmd4YmVzZjAzUkhQ?=
 =?utf-8?B?ZUNVVWhpOVlkRi9XcEV4UnZEeWt5WWF0ekljenFuQzJtN0hzRlF4VFI5bnlz?=
 =?utf-8?B?N2NSVHdIQldWcXpwZVhRbmRWeS93ZzM3V0xzQzFUeThNZU93aUZCT0wxektW?=
 =?utf-8?B?VnlUM0F1aG05S2Nqa3J5NUFKRitlQVpFTXIxM0w0T21aNlYrVzgxNmswcFNt?=
 =?utf-8?B?dGRWM2htL2g0RW9SZjhzdC9Nd05KdVhselJNaGsxTEk0NWRnWmxGMWRVNzhJ?=
 =?utf-8?B?UWpwSDB4MmEzY2xJYXhMUE4wQi9ITy9VdjF0ZE9VSVlKWWMrODJNNFRlZDNy?=
 =?utf-8?B?RWRrQjBNYjNkSGVyeG0rTUZJN1VjNEhtVWx1V0FPOThhd3VhSlNhTUJHVEtU?=
 =?utf-8?B?MnllOWdtTWVLYitDVVgxUG0wWExGdmRKdjNRSFljdWJobis1SmplVmptVld1?=
 =?utf-8?B?Y3hZN2VBQUNEWUpPeTZtSmQvclY4WVpxRFh5SVNkUFdRNGFocHFaUDBGelBs?=
 =?utf-8?B?Kzl1YkI0c3ZIVkVVaTN4RkxiNm9TSXh2LzM5M3BwUlZWZHJta1lsM2Z4MlhF?=
 =?utf-8?B?emJCdisxOEYzMkJWdnhsMVJ0OTd4S2pwaUhZR3BmN3EwVnNYWnBWUFFBL3VY?=
 =?utf-8?B?NmRrM2ZSTlFocXhyOW5Oa3NUT1IrcjV3c2xCWk5uZnFYQVdlcmQ1aHgvVmMx?=
 =?utf-8?B?RWNoZXBiV1AzWm5ab2IvWFhxQ3JORjZkTlNxQmUvYTMzQVRmZUtoV0Z3RDZK?=
 =?utf-8?B?VUQwckU5QUxTZllNMHBZVlViVEthek1hZVl4YVRQb2lLNWdrUWZPTUtXdXRh?=
 =?utf-8?B?TFhtTjZCT2xtRW5Za1lTQ0tyMUo1cDlXMkFkUnlMU0lHMjVpOFRaeml1bSts?=
 =?utf-8?B?b2hWZENSSHN5bkFPRWpoUGVtTjJkV3dSaTQvTnFPaFN6eUx5TENoVHZwVmk3?=
 =?utf-8?B?YVZZOG1xb290dVg1TGplZzJTOFc5cHFNTVE4em9YdGRGeEJqVEh3ZW1tVCtn?=
 =?utf-8?B?ejhuU2xqNjI3WTBkZ0NuQTdsVXU4K1N5Zk5sSWxFTGdsb2JEQ3QyVXZQVml4?=
 =?utf-8?B?bHo2eHVXMVRqZ0htUWhkOUNpTnM0TEhYOTdXZXkwNEFpbjhaWndJeHc3OUVr?=
 =?utf-8?B?NDJJSWFvbENCNFZmazRQZ05TYmcrbFVLRmJtRTlIcGF5Q1RkQW9EQy9WSDAx?=
 =?utf-8?B?V1NxcVJHNHZiQkkyQmsyQ2VrWmdtQyt3QzhreFFXZEFhMGtXVXo3RGpLQkxX?=
 =?utf-8?B?UDNxNEF4UUlHSHJxbVlNZnR6blN2TFg3UTlZZCtxdEU2cTRxR2dQdW1peFpJ?=
 =?utf-8?B?ZVVoK3d1elZXVTU1c3NISy9pazhyaGN4eDFnQW1RcmY4T1Z5TkM5dENuSWlW?=
 =?utf-8?B?WGMyMTRvY3N5T1RCQkw3V3lyZTN2NFpreUVyblpVbGUzOXp3QWJMYTNaNytJ?=
 =?utf-8?B?S2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 769b505b-e6da-4423-c9aa-08daef1cf013
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 13:01:19.4641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ki6O05yWVUUqa9kO11LAjQh1avXKaFE5UjqiNIg04MfQW0c3Ad769JGeA1fRVe7pC3x/AZ1A1x04Z3UEQBxXRaRjjlP6kfKMffbYmf595s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7212
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
Date: Wed Jan 04 2023 20:41:27 GMT+0100

> Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
> frames is included.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |  12 +-
>  drivers/net/ethernet/engleder/tsnep_main.c | 208 ++++++++++++++++++++-
>  2 files changed, 209 insertions(+), 11 deletions(-)

[...]

> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index 56c8cae6251e..2c7252ded23a 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -310,10 +310,11 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
>  	struct tsnep_tx_entry *entry = &tx->entry[index];
>  
>  	entry->properties = 0;
> -	if (entry->skb) {
> +	if (entry->skb || entry->xdpf) {
>  		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
>  		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
> -		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
> +		if (entry->type == TSNEP_TX_TYPE_SKB &&
> +		    skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)

Please enclose bitops (& here) hanging around any logical ops (&& here
in their own set of braces ().

>  			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
>  
>  		/* toggle user flag to prevent false acknowledge

[...]

> @@ -417,12 +420,13 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
>  		entry = &tx->entry[(index + i) % TSNEP_RING_SIZE];
>  
>  		if (entry->len) {
> -			if (i == 0)
> +			if (i == 0 && entry->type == TSNEP_TX_TYPE_SKB)

`if (!i && ...)`, I think even checkpatch warns or was warning about
preferring !a over `a == 0` at some point.

>  				dma_unmap_single(dmadev,
>  						 dma_unmap_addr(entry, dma),
>  						 dma_unmap_len(entry, len),
>  						 DMA_TO_DEVICE);
> -			else
> +			else if (entry->type == TSNEP_TX_TYPE_SKB ||
> +				 entry->type == TSNEP_TX_TYPE_XDP_NDO)
>  				dma_unmap_page(dmadev,
>  					       dma_unmap_addr(entry, dma),
>  					       dma_unmap_len(entry, len),
> @@ -502,12 +506,134 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
>  	return NETDEV_TX_OK;
>  }
>  
> +static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
> +			    struct skb_shared_info *shinfo, int count,

I believe most of those pointers, if not all of them, can be const, you
only read data from them (probably except @tx).

> +			    enum tsnep_tx_type type)
> +{
> +	struct device *dmadev = tx->adapter->dmadev;
> +	struct tsnep_tx_entry *entry;
> +	struct page *page;
> +	skb_frag_t *frag;

This one as well (also please check for @page, can't say for sure).

> +	unsigned int len;
> +	int map_len = 0;
> +	dma_addr_t dma;
> +	void *data;
> +	int i;

[...]

> +		entry->len = len;
> +		dma_unmap_addr_set(entry, dma, dma);
> +
> +		entry->desc->tx = __cpu_to_le64(dma);
> +
> +		map_len += len;
> +
> +		if ((i + 1) < count) {

Those braces are redundant here.

> +			frag = &shinfo->frags[i];
> +			len = skb_frag_size(frag);
> +		}
> +	}
> +
> +	return map_len;
> +}
> +
> +/* This function requires __netif_tx_lock is held by the caller. */
> +static bool tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
> +				      struct tsnep_tx *tx,
> +				      enum tsnep_tx_type type)
> +{
> +	struct skb_shared_info *shinfo = xdp_get_shared_info_from_frame(xdpf);

Same for this one (const).

> +	struct tsnep_tx_entry *entry;
> +	int count = 1;
> +	int length;
> +	int retval;
> +	int i;

Maybe squash some of them into one line as they are of the same type?

> +
> +	if (unlikely(xdp_frame_has_frags(xdpf)))
> +		count += shinfo->nr_frags;
> +
> +	spin_lock_bh(&tx->lock);

[...]

> +	retval = tsnep_xdp_tx_map(xdpf, tx, shinfo, count, type);
> +	if (retval < 0) {
> +		tsnep_tx_unmap(tx, tx->write, count);
> +		entry->xdpf = NULL;
> +
> +		tx->dropped++;
> +
> +		spin_unlock_bh(&tx->lock);
> +
> +		return false;
> +	}
> +	length = retval;
> +
> +	for (i = 0; i < count; i++)
> +		tsnep_tx_activate(tx, (tx->write + i) % TSNEP_RING_SIZE, length,
> +				  i == (count - 1));

Redundant braces around `count - 1`.

> +	tx->write = (tx->write + count) % TSNEP_RING_SIZE;
> +
> +	/* descriptor properties shall be valid before hardware is notified */
> +	dma_wmb();
> +
> +	spin_unlock_bh(&tx->lock);
> +
> +	return true;
> +}
> +
> +static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
> +{
> +	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
> +}
> +
>  static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  {
> -	int budget = 128;
>  	struct tsnep_tx_entry *entry;
> -	int count;
> +	struct xdp_frame_bulk bq;
> +	int budget = 128;

BTW, why do you ignore NAPI budget and use your own?

>  	int length;
> +	int count;
> +
> +	xdp_frame_bulk_init(&bq);
> +
> +	rcu_read_lock(); /* need for xdp_return_frame_bulk */
>  
>  	spin_lock_bh(&tx->lock);
>  

[...]

> @@ -552,8 +683,20 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  			skb_tstamp_tx(entry->skb, &hwtstamps);
>  		}
>  
> -		napi_consume_skb(entry->skb, budget);
> -		entry->skb = NULL;
> +		switch (entry->type) {
> +		case TSNEP_TX_TYPE_SKB:
> +			napi_consume_skb(entry->skb, budget);
> +			entry->skb = NULL;
> +			break;
> +		case TSNEP_TX_TYPE_XDP_TX:
> +			xdp_return_frame_rx_napi(entry->xdpf);
> +			entry->xdpf = NULL;
> +			break;
> +		case TSNEP_TX_TYPE_XDP_NDO:
> +			xdp_return_frame_bulk(entry->xdpf, &bq);
> +			entry->xdpf = NULL;
> +			break;
> +		}

entry ::skb and ::xdpf share the same slot, you could nullify it here
once instead of duplicating the same op across each case.

>  
>  		tx->read = (tx->read + count) % TSNEP_RING_SIZE;
>  
> @@ -570,6 +713,10 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  
>  	spin_unlock_bh(&tx->lock);
>  
> +	xdp_flush_frame_bulk(&bq);
> +
> +	rcu_read_unlock();
> +
>  	return (budget != 0);

Also redundant braces.

>  }
>  
> @@ -1330,6 +1477,46 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
>  	return ns_to_ktime(timestamp);
>  }
>  
> +static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
> +				 struct xdp_frame **xdp, u32 flags)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(dev);
> +	int cpu = smp_processor_id();

Can be u32.

> +	struct netdev_queue *nq;
> +	int nxmit;
> +	int queue;

Squash?

> +	bool xmit;
> +
> +	if (unlikely(test_bit(__TSNEP_DOWN, &adapter->state)))
> +		return -ENETDOWN;
> +
> +	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> +		return -EINVAL;

[...]

Thanks,
Olek
