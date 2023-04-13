Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD26D6E1520
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjDMTYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDMTYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:24:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46855B9A
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681413876; x=1712949876;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t9lVm97h2E0pQNd1DE//Gp39nPvnB4jtUXNs4TDEHeA=;
  b=k0T7hA+4EtoWt4IcPRUygZAKKY/se32Y1wozsxvlO/YG65slD+3IuBnZ
   kE4aUSTvQPhmLNfVyinlDEtsZzF8PctNMEbcug0y5FQnCk8Q7f4pc8xSu
   p6DVHj9YInQk+zyaDoKGUcMtzK2DJgwBMlR3v4VykAB5+oAKiYjsEP9Bt
   YEPLmDXxH0aKsSjQnbU9Il/TkI5ifsUsEpN7YGTKBhAt3it29UmvNcLQ1
   y6RVjVNTXoGvKbRAXYHYyRjQIR2ZHCobxRls9qjziHf0KtYV2+BrTDo4W
   8oKu1EkKR+rYsLS6dnffVAyHPQO8DLH+kI4G5G48l4TzBKza8OXCj3k1f
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="324634526"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="324634526"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 12:24:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="800914594"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="800914594"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 13 Apr 2023 12:24:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:24:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:24:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 12:24:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 12:24:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iU/KiXFL4FP0xf0figPB0UvOA9tx/KdzVMeY2wcPGI+ut2ZFP5Se4pq7Y+kLYbrk4MZxEzEZu40BKIq/Dx4sdb1alCZ12bLeWhtXyYX781jSBuUptv8o7nybY/EmTJ/Ok6geNRvrYf0ZOOlJpgVEUVJqg2CYKSEHHw0FcsPUZ+VaxI4QKWuCtSvVoWvaiqpeeqU27wl4fBS9gu9DxJ2WPWx8VPoDMfYSLVQapAlvD1hIXiGCwLxMeiCsfNDNG0jK7ZM3GzWI/voubaTcAUZ57M2aU8TpOGfmqekGi7B7dM/iuQrzyl0HW1FS3KgkBR6H4rb8ofiP+njzfpFJzW5A2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/boUbTQ1BsBQyWvQiz+JDj76ArVDrNrYvmEs7t6bqzw=;
 b=nbvHzxLPkEhUQEoOFb1xe3hGePPYWGK1HZXTbrTyawUgW+mvwPdIJ1AGZeXa/ewJgQYBE+OKJcic1VrF88sNDfFhL0PwuhkG3Thoeoeqac+4iEaUCa5Zwta0P/QeUM6W60dNyekTNKv9iyiQrTSjrhLRDK7EnNk5gU7lochro12agTKkNARqYV6GyDw3MX3G0ZJ1mZZa7UaVedZblBdc54es6WDVJqgGAK9iaz5kwKc8x/a1KWfqIYF+IV8i0pD3EeZ1SqQuzJKQpC6sCCxHD66XH63RUOtzfSoXx2buS3tiG/BeLEOaXgItRDj6gHptWgb4iet+5B5N0RBRnS9PTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW6PR11MB8365.namprd11.prod.outlook.com (2603:10b6:303:240::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Thu, 13 Apr
 2023 19:24:18 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 19:24:18 +0000
Message-ID: <1a8ee542-f309-4106-818c-fe380cf33266@intel.com>
Date:   Thu, 13 Apr 2023 12:24:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/3] r8169: use new macro
 netif_subqueue_maybe_stop in rtl8169_start_xmit
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
 <ad9be871-92a6-6c72-7485-ebb424f2381d@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <ad9be871-92a6-6c72-7485-ebb424f2381d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:a03:80::20) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW6PR11MB8365:EE_
X-MS-Office365-Filtering-Correlation-Id: 7077aa56-2544-4699-6ab6-08db3c54acc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tu2zySccDkzEU1qJkRkyCj7CxSyHjr9vlf69Rqa3taw8fnR/UT/R3D4BAMxHpTJvmLjDGXXZ8Zvwh/d+q+/Jml6oaoGGFq+pPS8j/EBZiA7zVBVZp0IINvaTMAN9XJIu6W+j921NiSc5+UXN6wyo2CZvbbpXozfMckotck1m1RVaQVDHa/yPKDWGU/Lz5h7FkGOWsHgOJ/4uhvhHCc8087pV3wj1SsOr1Ov3oHYUh5unKUnXAOBok9SagQQvo6Qq0Dl0A/qvVztoN1P/FfzjJzGbYRVBf3YMar4StofA7MqIA2qiFp8FrkTQvcy2cv1a6RBbuqZ3a4XCun7X0VNB+gyuiDwCwAWOumYsdDuiZtX6lc9APclN23e6DrY/XoqRjHlcNrU8Y3R5gjBuLszv49OkT0+3N8QOrrfLEAmKka223WYifHafB1HfAyyyA7Saf0T2GUqOvOm40VQZuLzDrhwDKq1adsf9vWn8a6DkJvj2POefPGWBQyofoBPB4GHmj5/MoFijNX3tb2XFSjL/mimX+XdebhDQqY2WKUXUuH7ZYy4bObg+ZUTWxsDAKlgi1FRK4Xh2Ur5kGu3FLHzmOyZK8TqpIPu6MjGtBLSiZfRlqiAJnC7Ibw2+uA6Bfwol3TvYa+NBLs3GryS0NkxSoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199021)(31686004)(82960400001)(6512007)(6506007)(53546011)(4326008)(6486002)(86362001)(5660300002)(31696002)(8676002)(36756003)(316002)(8936002)(41300700001)(110136005)(478600001)(66476007)(66946007)(66556008)(2906002)(83380400001)(38100700002)(26005)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnNHRnVaMzE5MHBmV0RpTFRlUS9JcFArOXBjNS9YTVAwd1FpMjVXWW1PN3py?=
 =?utf-8?B?MkxwQmNNK1NKTlBIS01DVm9lcGoySDF3cnpkRUNGelUvUnorbmtEeUxieVBS?=
 =?utf-8?B?a0Fac0xWK0dxREpSQ0RUaGMzc1d6Q1RONDNOT0dFUy9ucXJEbzgvVlliWDVm?=
 =?utf-8?B?NkpHUW1iUHErVTlBNis4TTljNmlnYVpDS2FPZEdoOVE2Tmxsc2ZiamJVZHRD?=
 =?utf-8?B?NUJ4Y053OG5ZOEVIZzBSOXpvT3NyUmlTeG4wNldzV1l4SW9qbzdXWm9OWmdR?=
 =?utf-8?B?d0hvd3ZkcVVncDVDaVlPclI4NHJ1Z1Fhd2VnaEdnc1hXUmhtMGJac2QvalpN?=
 =?utf-8?B?ejQ3THpzdUhHTGpuMHVWaFVzVHZ4RUxMN05GbkhaYk5IdUZqMWdKRVlxQWhB?=
 =?utf-8?B?dEVmMHUyWXc2ZzZZbWM3TEkzMGpydmMvaDA1cGw0QS8xbXlyeFdFOFBmZkcv?=
 =?utf-8?B?S3ZoSEpaUERXem1vbjJpV3FGeVJGMDdOWGVDTXZ2cXlGV0FTYWU0aERqMnoy?=
 =?utf-8?B?dkMxUGFNUHJtSm5RY0N2UENXTXpjZ0U3cXY5aU80YitzdklhSmthMWhkVWhu?=
 =?utf-8?B?M3d4NEVrTmxCcVdoSUxsSWRtcTRhbW4rVGEwRm1jdlZuMnRSUWRDNDVQUXBl?=
 =?utf-8?B?L0ZQdXQ1bS9DRm5OL3RRRUk0MEo3dHJndmVUemNxajZCUXI1MkZkQ2kyZDR4?=
 =?utf-8?B?eFJqeHZNS2thRVo3S0xpMFJaUjQxWitvZlEzd0lkYUNUd0s1Z1Q4UVhSdXp3?=
 =?utf-8?B?djhDeGxSREJ6K0pUb1dac2xVNm5nTDlLeUV6dU9CZ0Q4RytpREkrbzk3VmJE?=
 =?utf-8?B?RS9EZzNlODRLV01ybDFnY0VWREFzQTVzS1NWT2dFZFlIeWdUSXhVbEFHMlp1?=
 =?utf-8?B?YnBzWC9Zd0FJZVNPbkw0blFYeUU3amtHOWk1Ui92UyszWXFRSHNvTUpmald6?=
 =?utf-8?B?OVVra3Blc3F4aDRHb0RlVnBsUGJpTlM5UWVqZC8za1l0dFF2L2pqaWNLMDZK?=
 =?utf-8?B?YWM2WURvaFd1VkhRWFlFZWh0WDAwMVlKdmk4OGViSWVINFNqR0hnWkpqWk83?=
 =?utf-8?B?aDVHbXF5OVRsL1JDN3lHQzNVRmlKcTNZYXNCbnMvbXlGczFHeStFRUVueXVo?=
 =?utf-8?B?N0ZzMnBCbzRWUVlzMnBxeldjUUZSUEFnMUE4NmE1OUNGUE56Q0NMRW9CVTB3?=
 =?utf-8?B?WlVWdG5qRXhvUURoNzdPbTl3L05UbXFHUE1PczJkZWE4QzIvQ0FWUCs5QmVy?=
 =?utf-8?B?RnVtbUNtblMyUmN1eFpjSTBkUG1CMFFOTmkzNzNKSDkzNE5yczdkN3hKUWZq?=
 =?utf-8?B?cnlHQm9GZ1VIL042R1MxU2RuZHFPOGdIQUJDU1JkYkNmVjJDMFpIbVgwUlZl?=
 =?utf-8?B?aUx2SVczUnk2SEgyNTZZU2czanIrUmlQQWd5TU14eTZybHhrbUFsVjV4YXZt?=
 =?utf-8?B?ZHBJQXpBVFFVdHB5S3NFd2ZGcU52M212M2FEekdENCs3b3V6akc1eWFNOFox?=
 =?utf-8?B?ZHkxSnpjdEJkcGxtb0FtNXh2d2JNck05TWlxOGtmc294bGRWNVplbFNZLzE2?=
 =?utf-8?B?emhyWkR2Wkpzek5BVGY1ZUdSLzNuUU9hYmJ5Ykg1VUtyRHNpb0V6Y0dTVHg5?=
 =?utf-8?B?WnhlUzE1NWtlYmZoVC82TlpEOSthRWpiMXZqeXM1aXdwOTFkT0thRU5oRnVG?=
 =?utf-8?B?QVYrTkVMMlN2dU8zNERtM0MzWHVZTFUrSVBQVi9WTzFMS1BDV3NZVDY1UmNo?=
 =?utf-8?B?ZEdZQmJEUzlnb3gxUFZET0hoV3pWek8ySXN1dlA5ZXBUTzhqSkZudUJQMkF0?=
 =?utf-8?B?L0dGVHpCNGloTEtydk5QWVM5cFI4S2NpcTgwZXdCV0dHZVpRT2JzdHJNeDh2?=
 =?utf-8?B?cWJnYUIyUzU5Y3IzUHI3eXpUeTF2UmJvb1RFQVlPMWNYRmp6L1A1VVBOMVVR?=
 =?utf-8?B?Ukg5aGpCRklXMy95cVVkT0ZpeDhtdEllcHBWekF6c1NFR3ovSUwzNzdqbGFa?=
 =?utf-8?B?RDM0dDMrY3JnQkc2U2lRNFk5RThGSUtzc0FhRHd1NDIvZm9SRm5xamlzK2lr?=
 =?utf-8?B?YUhLWSt2cUdyVFRQc1hKT0VQUmhnWkZpUVR5dTVLTUd3d0lmN0pqZGhpcVIy?=
 =?utf-8?B?TGxEYWk0ZXJXQTlwNHVBY1F5VlJpZVIzS3Zkc29VQlkwcXJxeWo1Uk1yekVP?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7077aa56-2544-4699-6ab6-08db3c54acc7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 19:24:18.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1pJ+kppfJtt6Tg24GONUPLC1QsYPGBQ1xmBvFvFT0z9ayKRA8In63kplXqMy5KwA2fkrjLD+shltdg2ic1bFg1MHoIsxTiUqp87f3umXTa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8365
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



On 4/13/2023 12:15 PM, Heiner Kallweit wrote:
> Use new net core macro netif_subqueue_maybe_stop in the start_xmit path
> to simplify the code. Whilst at it, set the tx queue start threshold to
> twice the stop threshold. Before values were the same, resulting in
> stopping/starting the queue more often than needed.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---


Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  drivers/net/ethernet/realtek/r8169_main.c | 42 +++++++----------------
>  1 file changed, 13 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 9f8357bbc..3f0b78fd9 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -30,6 +30,7 @@
>  #include <linux/ipv6.h>
>  #include <asm/unaligned.h>
>  #include <net/ip6_checksum.h>
> +#include <net/netdev_queues.h>
>  
>  #include "r8169.h"
>  #include "r8169_firmware.h"
> @@ -68,6 +69,8 @@
>  #define NUM_RX_DESC	256	/* Number of Rx descriptor registers */
>  #define R8169_TX_RING_BYTES	(NUM_TX_DESC * sizeof(struct TxDesc))
>  #define R8169_RX_RING_BYTES	(NUM_RX_DESC * sizeof(struct RxDesc))
> +#define R8169_TX_STOP_THRS	(MAX_SKB_FRAGS + 1)
> +#define R8169_TX_START_THRS	(2 * R8169_TX_STOP_THRS)
>  
>  #define OCP_STD_PHY_BASE	0xa400
>  
> @@ -4162,13 +4165,9 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>  	return true;
>  }
>  
> -static bool rtl_tx_slots_avail(struct rtl8169_private *tp)
> +static unsigned int rtl_tx_slots_avail(struct rtl8169_private *tp)
>  {
> -	unsigned int slots_avail = READ_ONCE(tp->dirty_tx) + NUM_TX_DESC
> -					- READ_ONCE(tp->cur_tx);
> -
> -	/* A skbuff with nr_frags needs nr_frags+1 entries in the tx queue */
> -	return slots_avail > MAX_SKB_FRAGS;
> +	return READ_ONCE(tp->dirty_tx) + NUM_TX_DESC - READ_ONCE(tp->cur_tx);
>  }
>  

Ok so now we just directly return the slots available. We used to check
MAX_SKB_FRAGS vs now we check MAX_SBK_FAGS + 1 (or double that for the
start threshhold). Ok.

>  /* Versions RTL8102e and from RTL8168c onwards support csum_v2 */
> @@ -4198,7 +4197,8 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
>  	struct rtl8169_private *tp = netdev_priv(dev);
>  	unsigned int entry = tp->cur_tx % NUM_TX_DESC;
>  	struct TxDesc *txd_first, *txd_last;
> -	bool stop_queue, door_bell;
> +	bool door_bell;
> +	int stop_queue;
>  	u32 opts[2];
>  
>  	if (unlikely(!rtl_tx_slots_avail(tp))) {
> @@ -4245,27 +4245,10 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
>  
>  	WRITE_ONCE(tp->cur_tx, tp->cur_tx + frags + 1);
>  
> -	stop_queue = !rtl_tx_slots_avail(tp);
> -	if (unlikely(stop_queue)) {
> -		/* Avoid wrongly optimistic queue wake-up: rtl_tx thread must
> -		 * not miss a ring update when it notices a stopped queue.
> -		 */
> -		smp_wmb();
> -		netif_stop_queue(dev);
> -		/* Sync with rtl_tx:
> -		 * - publish queue status and cur_tx ring index (write barrier)
> -		 * - refresh dirty_tx ring index (read barrier).
> -		 * May the current thread have a pessimistic view of the ring
> -		 * status and forget to wake up queue, a racing rtl_tx thread
> -		 * can't.
> -		 */
> -		smp_mb__after_atomic();
> -		if (rtl_tx_slots_avail(tp))
> -			netif_start_queue(dev);
> -		door_bell = true;
> -	}
> -
> -	if (door_bell)
> +	stop_queue = netif_subqueue_maybe_stop(dev, 0, rtl_tx_slots_avail(tp),
> +					       R8169_TX_STOP_THRS,
> +					       R8169_TX_START_THRS);
> +	if (door_bell || stop_queue < 0)


Nice reduction in code here :D

>  		rtl8169_doorbell(tp);
>  
>  	return NETDEV_TX_OK;
> @@ -4400,7 +4383,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>  		 * ring status.
>  		 */
>  		smp_store_mb(tp->dirty_tx, dirty_tx);
> -		if (netif_queue_stopped(dev) && rtl_tx_slots_avail(tp))
> +		if (netif_queue_stopped(dev) &&
> +		    rtl_tx_slots_avail(tp) >= R8169_TX_START_THRS)
>  			netif_wake_queue(dev);
>  		/*
>  		 * 8168 hack: TxPoll requests are lost when the Tx packets are
