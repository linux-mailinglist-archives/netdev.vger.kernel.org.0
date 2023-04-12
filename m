Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8296DFBDE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjDLQw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjDLQwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:52:55 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5564F7DB3
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681318355; x=1712854355;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bsIvAJ2vi20bnTy4N8fr21/D95mBFcdL6wXkhIDRnGU=;
  b=Igwdg4HmAbpXefqvnejNR0dZ+Cpou0EHYpOCca7b7jZAGsBrHSJS89YN
   URMMzvP0Z2bnOWmQZlbaATaN7WHc/H7Ccv5g4lNHkQPc4iuYlsBpjme55
   co4PgH9AQSU3fXALBFwkpJvlBOKPJgwwlEufXnF64NUdPwI+KWHeJda9f
   0bTZKN8pw7Pad7m2CorcPmGPMYGo83v6mCPEmNmQZKqPobHgx8p6PBESu
   Y8jp1ZxorUSGhQc2FrTqajpnheyqAPhBpfY/Q2VCmmLKz4oPk014P2xYQ
   8E5Ijo1XNeXDSsxW8WDv5A5ut65mTYs583LfNwByNa7r/ERGJ0VZE2E6C
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="430242659"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="430242659"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 09:50:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="688980045"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="688980045"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 12 Apr 2023 09:49:10 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 09:49:10 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 09:49:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 09:49:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xzzh9T1d/ZjURcyChhPS3dsrUmuDrf636Z3N8UfFyd9W14jRS6ffnx/XvdiF0Yojj2rfVjxla2iNb/QHN6pArrkfryvOdFRA6J8sYHqP3pLANuCBsjTWey/Hi4qyOrPXSR+Q0eYoI7oXft+9nEgdtQQs1qcon5hdF3gX2vlRohE+0lUYvdRpxUYmcUePcEBebz5QBmrkQW7khjXmViqMGXqsbPiCjUO9+AXJKoIGwRjIQKyV9F2w4wdI2bUu52KiontXxrDpqOyKJE6JfaFt3IsnX9lN8qAxsVM2DUAQqG7DRMF02Qt/6islz5wBlYfCn1BFkvTHZt1FmUm2wGQPQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYnxFAQSXYPXVmP4YoNkWBe0bU/8/2q+bpTERkf8n9Q=;
 b=CUkLO+rFDBzgUZCqLjm/fjvIWalz1VTy05NeiQf++33f1mREsRIGfAKIny8/uuqAt0PTT1ScKcuIQK9RGf1bKls/X51Vh3XKi0c6s+eROZ5UVljZGs7NMKzV1aWD99Aca5bKMxBS+IYm4oZM2SBxi3Y/hAIu61+Q3xpuTD9/6p6fR/N4BUWKguLbEtcJovVa8FBALY6050VcNfd3nTri76kHsZq41jwp1Bd7UV3Q4S/EG3y9DpxHhtZQGcStsGEv+OSZHTUI93lIdYTvb+p6BEvAnMPATrLnbGYx8SVqWseAFl6NOdt2rdJrEgDTUEm/JG1Xk3gkk6AiasHqvcEhmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3624.namprd11.prod.outlook.com (2603:10b6:a03:b1::33)
 by SJ2PR11MB7502.namprd11.prod.outlook.com (2603:10b6:a03:4d3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 16:49:08 +0000
Received: from BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::c76d:8cee:5ab5:4cf2]) by BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::c76d:8cee:5ab5:4cf2%5]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 16:49:08 +0000
Message-ID: <d412bbf7-bfb7-42bc-4352-fd99d38121bd@intel.com>
Date:   Wed, 12 Apr 2023 18:49:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [Intel-wired-lan] [PATCH net v1] ice: fix undersized tx_flags
 field
To:     Jan Sokolowski <jan.sokolowski@intel.com>
References: <20230411073707.19230-1-jan.sokolowski@intel.com>
Content-Language: en-US
CC:     <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230411073707.19230-1-jan.sokolowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0173.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::8) To BYAPR11MB3624.namprd11.prod.outlook.com
 (2603:10b6:a03:b1::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3624:EE_|SJ2PR11MB7502:EE_
X-MS-Office365-Filtering-Correlation-Id: 52825cef-b179-4e60-cd16-08db3b75d542
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Q4gER4ss/UgmHRSZhUTvntldNdOeUWMBoi8saccHIPVf/rNwngmz+4BGvcYzA/XbVrcVyiOqlR7G0D/BqXI4+xj0nD9VWOMvLJsGaLHXRs7YuicEmah/DFn0yC5onbqcL7a+H4KyF915Ni/XUlklVgDyeHqiX77kQVKvbZvkIh7GUgOBDTrmORaSCUaZBFpca/cO0HpmQ+6y+AIew199aqBCq8jYcUDVVUXC5NmIu6air6zMGOJJgYE7tcrKjZSnZXfoes3q2edp2v0rjTf0x5y3Eg/b/Cb8uJhitbFjJYLOSbNnTeIqYFcBuQyo9x+asSM1Ius1Akl+XrPyr0doqwLVdVHHMjxGVphv2EOdGlx6p4bzheeId26QTEXNpn2x2/78Z1J8I1sS8QV+HbxrEPTa/9y+1VUxeGMfyAdaxNRwF7+f1e/HB9Kpg0x74cUPIP2vXstZMQATbj4xcl0an45ruS4YxAyUKIg+oNynaVpo8DhrCCyOPAik2m+JIi7lVBpiJ64kl0vWmKcz/WKI6yQ+MxoGlHxj+mSmYYWMw38qqZEOs91zb57uk0Aq/jKwRpUKNxCWzINKr4KOo0v9J+UDnETCVaImfeVV6DHpOhxGoFmaPZjtwsFYP20ZDkjhKuu+oR2a7Oq76yL0z9ZSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3624.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199021)(26005)(31686004)(82960400001)(41300700001)(66476007)(66946007)(66556008)(6512007)(186003)(6506007)(4326008)(36756003)(316002)(6636002)(83380400001)(5660300002)(8676002)(8936002)(6862004)(86362001)(37006003)(6486002)(6666004)(478600001)(38100700002)(31696002)(2616005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTZVdmlJRVl4bzh5WWtFbDFueTFrOHNkWVZXYXR2QUw4Mm1xa2c2c3BuNm5l?=
 =?utf-8?B?dDdvMlNYNHF6ZEMwODVva0VMdUlpSUpHSThLZ3VkWDBkRHNhSktDdUliRmNQ?=
 =?utf-8?B?R2lCNk1Nc1RFQmIvaC8vZG1YeCtMS2dRQzl3Q01mNXcrcTdzdUpxVTZNUytE?=
 =?utf-8?B?S0hpK2tKN29WL1NPYUNsclJnVk1iak1pQ1NRM2MwQ1R0TS9FZHl0d3pjcVV3?=
 =?utf-8?B?aGlIajJ0NElYelc0eUdZaTAwQ1R2eFJ1bG1LaXdQbHdMRmc4Rmc5U3JJUlYr?=
 =?utf-8?B?YS9NK1NYbHlIakY4bGIxSE9SZU92V1ZwTW9zQTZMSjdPRjNpRkMyZ0hsR3Y1?=
 =?utf-8?B?VjcxSmxmb3pNbFFibjY0SGN0bUw2bFNtZXVwZW1PY1ozc0Y4SkZjZzhEMUlt?=
 =?utf-8?B?RmQ3djU1OUszUFVEL2UxVjVBR2VkaHBubW41dVJBd09vYVpwcE10MzdtcUhC?=
 =?utf-8?B?YjZMTHY5T2VZQloxSHpMRFlwcVh3M0pSd0R4c01sVEJUN3FiUHRhS2hobDFs?=
 =?utf-8?B?RFhGV1RuQlJIR1B3T21iclVlYmhMYWM3S3k4d2pHUlByRW9zcGpyQjZYS0hv?=
 =?utf-8?B?K1d6dWQzZFlXRE5uNW5KQjdPZ2J0alo4anFkeGVtbStsZWRTbjkvb3VMVXRW?=
 =?utf-8?B?SGVXS0IzTmw5RkQvcElrbkViSzNDUW9DRjhsb0NiQzFIQUZ2Y1JIaUNycStk?=
 =?utf-8?B?NW5PSXBHMGZ5REpOd1RqZE1saS9SdzlyTjdMc1Rza1BZRU9CUE50NTNHdzZG?=
 =?utf-8?B?c2ZhVDF6b29FN2xiZ08rTjNCeTgxNEVyWVhqZUU5TmVLcHJ2ckgwMjhtU0NT?=
 =?utf-8?B?OU5tNGxaOGRmbE9YM3ZBOUp4VkRwMFJCQzBNVFp4U3l2UXphZllUVXFaMS9w?=
 =?utf-8?B?SWlyakFFK3VUaEUrZHFWem4xRFU0cWVBbW1ER0pMVkpNZXQ4NDJzTUdyd3BY?=
 =?utf-8?B?dFpiUW1kSWc1WnQ4TXIrRW5ZbHNLNXdmTllhK2lWRVhNTlVTTDQrcmpZYkF2?=
 =?utf-8?B?cjJvS2RjVXhaTWJ3YVV3MHdoTkJwNTdldXJFYWRXamhJUHF6WlBGQjZnOVox?=
 =?utf-8?B?bFNrckdGelE3bS9ESmtqSGp6ZnlCUGovd3Nvd2JHYXVvY1RtM1J1YitqblY4?=
 =?utf-8?B?MklrUlYrcHNueWo5bjN4anVVT1FnZ1ZobVV0RXJWMVpuSUtUVHMzVjhoZERK?=
 =?utf-8?B?K1BlNEM2SEtwL0FRWUkrUmtMcXBZc0hQS2RXb3pSanFPLzJRekZ5YlpndEJN?=
 =?utf-8?B?bnEva2xmd2k1SDFmSkpoQnVONTJackZ0ZUxlb1Y1aWtSZ1EzVTFWQitYSnVr?=
 =?utf-8?B?QU5aeG1TTFRNSDk2RG01clpkdExDSXg4dmNGWkVobllDQjc5WUFMWmZXWVBp?=
 =?utf-8?B?OG9ncnJ2Z1QrcEV0ODRmcUlQNFJ2WUNPOVZ6L3c2NDlLbHgxUFRkWGg4VVhj?=
 =?utf-8?B?Q04veklMb1hFQVBVK2tIT2ZTTTh1bDY0VllLd3d3TXNGVU9qeWNDa0tZM1Q3?=
 =?utf-8?B?R3d0NWM3TlFZdWRlSEMza3A1ZTRMOFhYc1Jab242K0lBeVd1K09KMzg3UVBs?=
 =?utf-8?B?RXBlQ1ZtMmhmQ0pwd0E4ak5DSDlVNFFOd0hjUi95NkFpVFBjQlJMWUZZcVhB?=
 =?utf-8?B?M3JxSnc1R3FYMUxsTXNha1hqWjB0Q1U0R1pRVFE3a3JRNUdaREJHOWdzRnFQ?=
 =?utf-8?B?T3pvc0lpekV3VlVQa0lHMHZWeDNlN0pTd0NWS29RMldlUDY0SHlIR3FkSTlG?=
 =?utf-8?B?em16NGR5ZXhwUEFSWWVPdGF1ZjV6d0hVTGRzTUpEUnhsN1NnY2RxU1ljYkkw?=
 =?utf-8?B?Wlp4elg0VU9USUpaYWJQUnlJZ2U5dWNJazNnbk9BemV0U3dQZ01keUZZSlR3?=
 =?utf-8?B?VTZ2ZTZTOUJ1QVZ2WjVQaWQ1bEdTeDg4TFJVSFBFUEtQZy8yekt1ZGp5WkVj?=
 =?utf-8?B?SEdxTDFXZFhDQ1pIVld4T1EwWTVERURCZ1d3QWRWbUlPZFlpVVZQbHJmcmFM?=
 =?utf-8?B?Unp6eUhKMXVZaGZvdDJueE5OaVZCSkttUnNzRXdqNXdIcVJkelpsUm9JYnlQ?=
 =?utf-8?B?OFdMWU4vSVl3STlEOTA3U2FNYmlnajRLTFZiV1NHWDZmYjFuN2RseUdHUVN5?=
 =?utf-8?B?aFprUWo3Nlc0Nkk4a1Y0YWhXVklsc2kxSEcyOXFBN0FLYlJNNWd2UnRvS004?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52825cef-b179-4e60-cd16-08db3b75d542
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3624.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 16:49:08.1271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4UWc0xisLc8CMUe619tYoVOV2Qsluabka2Qq56jKsWmwDY7+jAMikGmtPbTFh9V5IVcEVd5NDK2sHOg+aPiWn5LZWaoVMczPYfsrrCeS3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7502
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski@intel.com>
Date: Tue, 11 Apr 2023 09:37:07 +0200

Please always add original authors to Ccs when you modify some code. I
found this mail only by scrolling IWL, while I should've got it from the
start.

+ Cc netdev (no idea why you didn't do that)

> As not all ICE_TX_FLAGS_* fit in current 16-bit limited
> tx_flags field, some flags would not properly apply.

Could you give more details here? With the actual definitions and also
how it was found and what's the regression is.
I found that there's VLAN tag which uses upper 16 bits only by browsing
the code, while I'd say you should've written it here.

> 
> Fix that by removing 16 bit limitation.
> 
> Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
> Fixes: aa1d3faf71a6 ("ice: Robustify cleaning/completing XDP Tx buffers")

Your SoB must go last, i.e. "Fixes:" should be placed above it.

> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> index fff0efe28373..46c108cc5283 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> @@ -183,7 +183,7 @@ struct ice_tx_buf {
>  		unsigned int nr_frags;	/* used for mbuf XDP */
>  	};
>  	u32 type:16;			/* &ice_tx_buf_type */
> -	u32 tx_flags:16;
> +	u32 tx_flags;

Please always provide pahole output when you change fields
size/structure. Here you create a 16-bit hole and increase structure
size with no mentioning.
I wouldn't say the fix is optimal. From what I see, we have such flags
(correct me if I'm wrong):

TSO			BIT(0)
[bits 1-7 are used]
OUTER_SINGLE_VLAN	BIT(8)
[bits 9-15 are UNused]
VLAN_S (shift)		16
[bits 16-31 are used for VLAN tag]

So you have 7 free bits to reuse for &ice_tx_buf_type, but you just
restored the before-commit ::tx_flags size =\
I would do the following:

	u32 tx_flags:12;
	u32 type:4;
	u32 vid:16;

* no structure size change (even no layout change);
* ::type range is 0-15 -- more than enough, as the last &ice_tx_buf_type
  value is 6;
* ::tx_flags still has 3 free bits left (9, 10, and 11);
* ::vid makes it easier to set a VLAN tag (no explicit masking-shifting,
  just don't forget to adjust the places where %ICE_TX_VLAN_{M,S} are
  used).

Don't just use "first that works" approach =\

>  	DEFINE_DMA_UNMAP_LEN(len);
>  	DEFINE_DMA_UNMAP_ADDR(dma);
>  };

Thanks,
Olek
