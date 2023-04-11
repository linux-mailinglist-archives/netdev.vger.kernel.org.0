Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C24F6DE826
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjDKXl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDKXl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:41:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE52540CA;
        Tue, 11 Apr 2023 16:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681256509; x=1712792509;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fk+FDkE9GWJJ81CbN35ppfKCD3VKAUQEtTyLCIx8EWo=;
  b=GG+KZc3BF+mgkfDZ8c0O33M5CEy1jVOWUfOeBIuiPURldvzKYwx1gc3E
   wwyQPC/N/5X1r7pbH+l/SHhyxLCI0iu40fAe3ThxEam27vAeNqz5GKUXp
   aTWhfNLf1m8Ru6eq+yJ3Gvz8hajI7FiyzEDxY5kZjVa4UQbWiLpuUXVqg
   YBebvVCI7eJipUK+70pBGqEvkJisGZQSM8aHTGDvxI97BgKwPyvCqiI3g
   7SSATxu/vYmwRIegZcolKYAjGIYW4NooqTTY4U5R3hh+c3bnIJXvjv+7Q
   UipcfjaAQf13DCB5A6LGj812Y9UvPrTgoiNeYQHOQJF1OXVSURd9SFiYW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="323389036"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="323389036"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:41:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="832516607"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="832516607"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 11 Apr 2023 16:41:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:41:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:41:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 16:41:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2AVM5pBx5f3FsPyIWFgDbSW8PdN5U659xCGim+PTMI0PTxv5NK87sFrIpHLtNYyzJWN7YAAHmWtwgnqppkmQi2sYmZ5G8UlfdLR4FSD+2yOnDFsNt+SenkLxXwOUN9feo0gCQURtO56HOxV/QC59DyUPhzJYs00jFJz3G8QWCdqqec4Ts4Vk9CHjtzMSEmeXfpjM7PcKLSM+uYTwvaQ4oZo1YvvVKmlSPz/5a2t8fMRlNJfs9OQoefzAsxQg2ttCR3x9XWGN2uUPrnhqQDVmaLAApnGzpNRO0xXzgqXIPxifoJ6ZCpLQBSVDhDljTz8BT5f8T/SEdPTz3/Nl7bJBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjRW1dulsXOY+/E10hIquW87P4izIFB7KPTPV4Am/4g=;
 b=PxlQZSYag0eUuBFm99ZAEmJDyeeCgpHdZU3+Mzh6URnS76RAXC8O6HXIw+2E0hyPsrR/l351ek+/v9assvdLIfG16tD92/fDOQEsx/KPWjz9w5LspHu9F1kqlCIkqPZj6J82A0IBBaGhJNpsh+K8lYMw5K1k2FmvZxYM/oWOAcjOXfg+iQ+UgefMw34H8W0IsO0RKu+KfKcVNmytq6ndOcd3Iu0mRewl/A3FNH3D5JT71rY6gKagD9nsUNRlx0xgGKNGjCdOZkTInVjz+XJb+JaJIRBAe4KdqPP9gzFEMNugtJqAK55cAs2HngaOeEhBXnTkFYZmaTl5ubHkwvuodw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SN7PR11MB7044.namprd11.prod.outlook.com (2603:10b6:806:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 23:41:01 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:41:01 +0000
Message-ID: <60c358d6-f6c8-c80c-ad58-7dda6ef3278c@intel.com>
Date:   Tue, 11 Apr 2023 16:40:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v4 06/12] net: stmmac: Fix DMA typo
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC:     <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <vkoul@kernel.org>, <bhupesh.sharma@linaro.org>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <mturquette@baylibre.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <mcoquelin.stm32@gmail.com>, <richardcochran@gmail.com>,
        <linux@armlinux.org.uk>, <veekhee@apple.com>,
        <tee.min.tan@linux.intel.com>, <mohammad.athari.ismail@intel.com>,
        <jonathanh@nvidia.com>, <ruppala@nvidia.com>, <bmasney@redhat.com>,
        <andrey.konovalov@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <ncai@quicinc.com>,
        <jsuraj@qti.qualcomm.com>, <hisunil@quicinc.com>,
        <echanude@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
 <20230411200409.455355-7-ahalaney@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411200409.455355-7-ahalaney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0163.namprd05.prod.outlook.com
 (2603:10b6:a03:339::18) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SN7PR11MB7044:EE_
X-MS-Office365-Filtering-Correlation-Id: 676df896-22ea-4f0e-bc60-08db3ae6349c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jI5tzeiwDH03upXOzJsw8kD/K+iE5DKXMBdwZr/5gZyPBe0QIfO/sOXmvKUwwJkTy8LB0Iahp7jmpApHbMpSU7wfGKBdCm+KvdO4Jo/Ogf04wb8aqsFjx363zRi0MQL6mH/HRFA+ACmUkLptnb8WgBdrTxPaa1v/hWnSmTKowDURCa8/Q5NSS8jnJH4zf9D+gXxEAtkAK13Hx1R4hOP8P12PlAZSHFD/x7V2HHdw8+2N/Vchweo/yucjb8pomEJ4chnTOkMx5OmZyGbX8lLvbEPxGhwMhF9u3GDMJn1syWplxmjcjvvRoPcnrgbOedWhwCLkkPuNPdm5JnKhd6GchCVpnZH9MX+EUIKD8gUh0+fHli1c4kKf9aKt+YGtMcqyDana0UYq1GVE+8UT7OyAcmmKtHsAQRXZUiyTxsHYwIv4Z5DeFu1YQTc9pQb5uJM98auzsNJgbv0JlFo5qgt3bnpjcALkUc5RhOwTS6ySS4BcNl9SwL0GoWJ0TiQdx+LuoZjOdVHz/5Ij/87CkubI4ZPSZBNc6gxxu+AtWW8FjmhGtQd1pD/LMzN/i+k2Gy5xu6UbjS10oPuLXWCK6i1hfoVwd+CLDfTZO9K+hIhKgsl8JowoeXXofg+zExPcrJGFVamYawJ/8JsvJzcvU3Ltag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199021)(4326008)(86362001)(2906002)(7416002)(7406005)(5660300002)(31696002)(31686004)(66556008)(2616005)(66476007)(66946007)(186003)(44832011)(82960400001)(53546011)(26005)(6506007)(6512007)(6666004)(6486002)(36756003)(558084003)(38100700002)(316002)(8936002)(8676002)(41300700001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckRDNlZycktDYTlxNlhKL0ZKVVMxQkRGL0RUaGZhbjJVeWdhR1ZvWm9MTzU4?=
 =?utf-8?B?WVFoaGF1Unh0eVRQYzdEbkdkSFVWY1dJckNmK25jaFYrT0JCY0NPYktmUDVx?=
 =?utf-8?B?RDJ3QVNKeUpjbXBod1RxYXRmL0puc0F0cnNmRmxiTENyUmladk9BSklZVHEr?=
 =?utf-8?B?Z3E1a0JDSzRKRFZrSm9QNDVUTEZVQXRRK0o5cmhXNW94bEZ4ZHhRSGVPN2hw?=
 =?utf-8?B?bU5ZMkRSQVpQd0VlYWpPb1BjaWRUN3kvbzBIalYvSUk2Mk9uRjJ2cVM0RHYr?=
 =?utf-8?B?Tyt0bk9aL0ZSMW9tSEZQU3FsQ1hJYmpydUFTTC9MYy9IWk8xZUQvMzg5K1JV?=
 =?utf-8?B?T0xrMWl4VlM1T2YzdEpXMEd4ZGJieUpBWkMzRUdGQmpWYU1KbUgvZTltU2Q4?=
 =?utf-8?B?OGsrN25TbW5YOCtQMjRLblI2Q1YwSUxvbGJ1WXlDcHJYM015d2lQTWhrcERX?=
 =?utf-8?B?TlZ2L0VUam1GdlpJMGdFSGE4c1dnaVNBMHVaWFA4RG0yR3dOY2UwSHJ3V0NB?=
 =?utf-8?B?a0VIejRINkk0aW9jVmNiM2c2MDdYR3o0NU5IQmhRcnhxcWd1MGtvdkp1cFpB?=
 =?utf-8?B?RlU3ZDRDR1lXejdLOWJyVmJkdmlVcGIrRDJyTCs4clNhNHhGUGoxdUFSVHFk?=
 =?utf-8?B?cUI5Mml2clM3N2xadzlOaTJnd29pOFFMcnpkZFUvbUN3WlVLR251VUZreFJE?=
 =?utf-8?B?dHdlL0ZZVldpVy9GeGg0YXoyMUh1N3MrRzBZNWxDckd3RFRYd3BCMnZDeDh0?=
 =?utf-8?B?Zk1qMzY4WDlSVk9IZWVpZWRFdnhZSEhOdjNtbUZxK0NVcE84VTdGV1R2Z0tZ?=
 =?utf-8?B?TUtOTEN4R1VHbkJFQ3c5WkI5TVpBK2hBRndiVHhGOVRjdU1rZDlLNitja3Va?=
 =?utf-8?B?K0diU21XbkZyWVJVNWZ5b1Z0NmM5YU1tc2pTa1dTTnBuQzRjRERwMDR3R212?=
 =?utf-8?B?Q3ZuOUxwT0VUZVZlbGhQbDlqdFozZm5qTS9jSXVKNjd1djgraEtwUmZ6SWlK?=
 =?utf-8?B?UU9EMU5ZVmRpaTlyeCtNNlNEb016ejUwSEdoL0tMc3pxQitYeDM4M0RvWFkv?=
 =?utf-8?B?a3RJOHFQQmYwYWhIYlUvUUpwWDJoaTAzZFZNV0JmcEUrRmhGaS8rM0ZQNjFB?=
 =?utf-8?B?b0ZldEhOY3hDbGpudHJIRmg2WlJRRzBEU3k0d3o3TXVJVXBHcThZUnJ3M016?=
 =?utf-8?B?dnM1ZHRQMEJnQVdNd2l4OTJFdkJOa1kzZWRkMWZUZWZicVczV3p4SHJaWnh1?=
 =?utf-8?B?a3ZaTlNCWHEzbTk0TVlwWjdXcmdMRE9HYVk2N09KaVVkeVdLSmw4RnlIb2Fs?=
 =?utf-8?B?emdMWERCejhWVDR5bm5hek5ObFRja0xFNmdzcnJYb0xaK2wreVcyejJ0R2xI?=
 =?utf-8?B?Y3cvcGRXdmcrQWgyajI3NG4zZ055UEttYkgzdnVmQzVGOW1FMG5VVFZoM2g2?=
 =?utf-8?B?aVM0STJZV3E1aXkyNGQ5YVRlUzloU21ONXhVRWsxQng0NmNtaVU2RFBBSHI1?=
 =?utf-8?B?K1ZraFNzSXlJaVo4eEFtalV4SVIxaktkZkZMbmMwYnFyZlRXck0vSVZUSytL?=
 =?utf-8?B?NUdPVXRINURLWUNtSHY1S2FtZU45aU84K3JKNFRLejJpeHBSNkkwYjhMTzBU?=
 =?utf-8?B?emVTKzFTZmZ5RDdkSzVHRGNPUFhKc3VGS2daYXQ1NlB0V2d5SGs4cXQ3UGlL?=
 =?utf-8?B?ZEZucHpPSjMrdVY4L29SL2hiNy9vcXNjdHU0MmhCQnp0aDFNVC9LVnFaL2RK?=
 =?utf-8?B?dFNTQWd0Qm9zL1hXUlFyMEhPdGdqUGtXdlUxNUhueHI5Z2RjeElXY0RWaG1G?=
 =?utf-8?B?bmRpQnlLT2tWbHdEdzVzdW9HelQ5TEJTWEZiS3JRM2daV0hhNVV3WGRhd2xM?=
 =?utf-8?B?WXQwOEs0U2xBaGhHL0k4QlU0Wm16U2RCZFViaXFQQndOU0VPSUZZanFWWnFG?=
 =?utf-8?B?NGQrSDE5TUJFOC9TUkNwN1hDblRtUUJuNmErOTZaY0xIWDRBSDFDYmNVendh?=
 =?utf-8?B?S3FJeDBpV21Sb2hNU0o0bXMzN1puUGFrVFFrd29OMUUwUXBXeHhWVlAzdi8r?=
 =?utf-8?B?a2VVNnR1UzVkdU9sTzd0RWlqZWZWcnJWT1hla05hWWlPYVB6WVhSUkwrSjcr?=
 =?utf-8?B?R0dFVnBwUzRvRVQvdVl3MkNFTEovN2Zlc0VWMTU4V1BTQi9BalM1ZVYrbDhm?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 676df896-22ea-4f0e-bc60-08db3ae6349c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:41:00.8604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KM+jVTrzx+liadCEFEITjKFgM8V50pYb0vGpRelRu8CZ+ftuP9hFZF8EFXUSGk8+R8o3y8TXZeOpbPiZe5mUKRCXz3ZDXvvnMKV7y+Hy0Wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7044
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/2023 1:04 PM, Andrew Halaney wrote:
> DAM is supposed to be DMA. Fix it to improve readability.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


