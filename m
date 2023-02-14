Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC1B696A83
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjBNQ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjBNQ7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:59:02 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B642ED53;
        Tue, 14 Feb 2023 08:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676393913; x=1707929913;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=871mND1wzVvExNfFHuTMdU7OINrgs7wQUShR1z8AjUU=;
  b=AcvSSqoIC9oXaMwl7pLR2C+tKU2mPcq6/fRnaBO9PwSq9c+xNVFJ/XXm
   0hrJ8DfyXRvFbmAC3W8kNYZFSDMHY0/plEYc4Y4XXO8eWs+whoepxZvKC
   nRu7QoKLnKsdnUzsFMFSFoy9n0AxW+CV0vx+2hfYmTWJtDoB9GSWBXcF8
   NqX7TtfpZ+1CCynWXjK6FK1D1LZZStIEK7AlLO5JSPwNJ0Od8I2gxSfmc
   c/cpZhvtg/wMPX4Q4fxvgR7EB2FXLaiFbSEpNmCF5M1DmOfZUJ/z5HjtD
   KmAcXexDxKl1uu3YvbW/tO2lkBTidMLiCM6sgiXXpZ/LlMgHyh1MmmVQN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329833600"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="329833600"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 08:58:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="646820720"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="646820720"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 14 Feb 2023 08:58:09 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 08:58:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 08:58:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 08:58:08 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 08:58:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxCk4Vbkbro/u2dbPAdsjEP1ywcsHf4ptMovskmYtxu24HVcB9xrNp1Px2i7t8lRx/hBOfsmNPGkcLTAOvziwZDUlvSR75DKC4Xx55RQ8AKLh6DnxfvvVZmvm9BD7k8e2zTXhLK4i38B8QGE1De5TwALjplGwdG9OYlQL6EqscN/DXRFLey85ZjsZ3a4sgwZcpCQOBhfFG7RHWhuqWP98f7NZ4TxesegxJwnVDfuDJE4s6RWQskYuvmFtUZKNX0klOhPTDnlZnNqInQcycYnukxs5OSTsNVbXtgQu/YkaYekj4vfIqs7Mc9wmxylkN/aDICH1BIf42cBNNRQZXDH+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Orj7WkKdfpvjz/ZN//x++EzUVhTZToh5uFS6YR5pqT0=;
 b=HqE9ZLy4oZQnrRuQGmlcvv3ZPX5kHt9PDXi++HnJUklCPSafyCqeCfI7GfZa/a2mvw7llNHcxfkcxp7sHDUL+GbPR6qMVzmldlwmwlK+T5qO1n6S18+PSNhyR9ADzp/PGy/Z//qwZZfwQTRUtxKv5thw0cqQ31xkbtD1lmmH/1s/tZZRPQpv+VGpcR999zcgzecKLUsoexK8QLsyWJYswTRwMRm4gttunSaRbQTqmt8dKtFrHEic0UH2MZThGOPq63CZqIhbzBigWsK0pnAcmckduXaZoKeOLYsxRvlgN7vLCY3K6Er6q+8dH+90tgv7l9ZYu7SbF00gu+L+0/LYsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB8214.namprd11.prod.outlook.com (2603:10b6:610:18e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:58:06 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 16:58:06 +0000
Message-ID: <cac3fa89-50a3-6de0-796c-a215400f3710@intel.com>
Date:   Tue, 14 Feb 2023 17:56:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v7 net-next 2/8] sfc: add devlink info support for ef100
Content-Language: en-US
To:     Edward Cree <ecree.xilinx@gmail.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        <alejandro.lucero-palau@amd.com>, <netdev@vger.kernel.org>,
        <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <habetsm.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
 <20230213183428.10734-3-alejandro.lucero-palau@amd.com>
 <Y+s6vrDLkpLRwtx3@unreal> <ef18677a-74d0-87a7-5659-637e63714b15@gmail.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <ef18677a-74d0-87a7-5659-637e63714b15@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0003.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB8214:EE_
X-MS-Office365-Filtering-Correlation-Id: fb5d9177-db81-4262-ba9f-08db0eaca448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KwUwqQwWY1dBLnJjvlhHh1zYSQC9v3As9MhH/okVe67hy9sjw2dZ8nzX2mdSWtcew73/83ebDZnIvBCoqJ6F4erf26ZCRXx6zlxUL5ZH6ajNVpkteEXMuTrxfkDYbzmAUaZ5LCjn73doldaiz+WVsrk5z2zc9mS+JdhE8jCgILsB8C0NO8PjZN81sTE5f+7OK1Hnx80Ti5bbI+24TxkeiXkHY2twHbSGq7mlUFsN+BUyveL2XHkCEJyBXAx8Duc91BmbBQMe26YnI1O2/COSNFEgxWvXnRp4dBzGIao6lUmYzBY0rEx0+R+kwoYLGibH/PvqHI3S2mjZDkenTraNTK+6/oP8pRXxwPP5xrBKMd6f8pVHXTmFg72Ev2CbdVJwW0dEZ73zpXeMNYZ9wG+pQ4LxPJy3RMmH6c29b7Cm82QrqXSlUvLMXzVofuuswRQjGyNquiJpPEAmQV18cbm6LZehm3bA4iub8yuDfWLPir6kLlasfMaKXA/71NO3hdfUHKs8hHhhkbxxgXiiDcO3ARIVMpHGokn4yWK5K1kk+N3cpLG7dy0k09fLEr/qMISXuScXN1T/9L/O3BMfwwe/vmCCe0cE+co8wkBjz13ZapPVDObKIXLqy9R4e02vb2JuFRxvZx40PMCuvDESk0YVVGWgysHjQFEC9dGOLzNqRBsC36RXNuQJZcp65Jl32LSfE7egV8Xfx2g9Uy+X0XlmjdAM0FIVp6+mcjQf7t/D4Pg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199018)(36756003)(38100700002)(316002)(86362001)(83380400001)(6506007)(26005)(6512007)(186003)(6666004)(53546011)(2616005)(6486002)(478600001)(31686004)(5660300002)(82960400001)(2906002)(8936002)(7416002)(66476007)(8676002)(66556008)(66946007)(6916009)(31696002)(4326008)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TktDTnYvY1VvMmg1MzljTHNRU2Qzd3l1cGxtTVBnK1lXVGVneU9xZmpGMFlW?=
 =?utf-8?B?aXNsNi9VMzFXS20wZ1FYbGs1VXRweWorU2Z5U2NVWVhNRGFIQlFqNVBtZmFL?=
 =?utf-8?B?VHJyNmRWV3FVS1A1NDYrRTVoRDNQa3lJVWZtMjNCaEtyWU5YVXZNbHhIaUNZ?=
 =?utf-8?B?SG4zOEtuZ2ExRktGb3pkb2dmRHRLOFA4MWFjbFFVMUdOWWdCSXR6cys5TmNU?=
 =?utf-8?B?RHVob2tZVHFJTzNnYlN2VHAvT3V5cE9JZTErZVBSVDc4K3RYcDZFbGZmYU1M?=
 =?utf-8?B?QitRbHJSRENTZ2UvNmY2SDE3eGRIdnd5SExyTENGUk1INmxzYXVINHBIUUwz?=
 =?utf-8?B?ek5rYlNRLzZyOGUvcmVLSTlBRkFFMkJOTUtldEdpV05nUFg3c2hHRzJnZGxG?=
 =?utf-8?B?cG11dkdOWkJoMGV4RkUwa2F2ZnlaOUFGR24rT2p0ejNOLzh2cWRBWUJ6aTV0?=
 =?utf-8?B?THkwU1ZOd2sxdUpkKzF3RFE2MXZCRml3WjBNM3BCa2M4V242MEFObFo2Y1lR?=
 =?utf-8?B?WWYrcmRRQURtMmVxQ01vWVZEOG9nTmZnUUpvb3lMajk1NG5vcGNBcTkraHMz?=
 =?utf-8?B?MUc4ZmZldEJOU1pRWXhERFcvNEI0SDJHQ2FrdjRiQnZyTDA2YngvUmdJMDJI?=
 =?utf-8?B?bnNvUFlranBPMndkMXRISjVXL3VRVWFuODJtYjcrdXJUUHNJeHlTQ2o3T2pJ?=
 =?utf-8?B?MlFER3dyL21Ua2lzNUpwa0EwZjVLRWcrRmc0clBXaGNGbmNtREdjWERqZW8x?=
 =?utf-8?B?cEtWZVR3Mm9iWlFMOXFrK3NxKzQxdm5yazFvSmx4aGczTmlKbXZONjQyVTVM?=
 =?utf-8?B?YkFwMEJZYW5HOTJaVGM3WlpwYVExN3FDMFJHRzU0QXd2aXRjZDdYeDhzV2M5?=
 =?utf-8?B?WFNRRkozaktKN1Y3b054RGU0SXVsYW5oUDAyYVdQMUdiSFQzZmQ2WHRadFF4?=
 =?utf-8?B?eTNMKzRkcVhGS2dKQXo2MlpZcnM5UXJ0RUxNSHYwbURJUHMwY25hc2c2Ylo5?=
 =?utf-8?B?MTJKcGRMdjIzaWFPbytTYnNDbjZmOG5kWElNY0htTDZsSjVDOG5GVzNLVzRG?=
 =?utf-8?B?Ky9uK3kwc3RWVW5BWE0wOWEzWVJXZFpKUWt3dGs0aGZHb3VMb0xZWUVGYzJX?=
 =?utf-8?B?N24yN3VwSkcwUWllSlJ2QmdJaG16Q2c5MHlyNkxXT3p2V0FvSjRuWjQzbXpx?=
 =?utf-8?B?Nkp1QlFrSkw5TWtjUXUvbHg2S0E5R0w4aklLVFRhVTFJcnVZSFEvSERUYmI2?=
 =?utf-8?B?TGU5K1B4VE9aU0V4VkVHYktwc1l0bzdlNDc0aWZpV0hiTVBydmpmeTVSdGx4?=
 =?utf-8?B?Skc4dW1zWERpRmxsb2JsZEM4aFU2N3prV1FucERrNDRXZG9ERjRkd3FwYzZq?=
 =?utf-8?B?OFhQdVdwR293NmZjSWgxZnVlY2FubUNYZHVrWU41UDBBVkZlbDVWMFVEK0p3?=
 =?utf-8?B?YWJ0RHZIVWdPcmd6NlRZMHNxRnhJem1sK2cwakF0MGxQcjRBTFMzVXBwcGJr?=
 =?utf-8?B?aWhXbG44Y1dvaWRvS0lRemRSQXc5MHFwYnhBazBmRjdpR3lEcTkwd2xJVW1F?=
 =?utf-8?B?ekNybTRGOUhGNGl5c2Zhb013Y25ra3Z1V2x1c3VMOHB5dUhJYU9QOGYveDJU?=
 =?utf-8?B?Vllwd1g5WEMyWTJzVFNFQ2FuZG1BdVN0UGkvQnlMejVKZmJtS0wxNVQ5Z2FX?=
 =?utf-8?B?dzFBTTFEVmNkWExmbHRNc3lPbGs1T1dldzQ2RlJoc3NVNjlaS3FmSzloaCsw?=
 =?utf-8?B?cFlpcWVtdmhLVllzV245SXNzemg4emdVWWtyUnRvTW43T1pnQTNSVnF1ZDVM?=
 =?utf-8?B?WUUyRDFqTTE1YWUvUFBGbjl0UmYxcnZHbHhWcnE4elh3eHFpTHRvRmNoQzlO?=
 =?utf-8?B?cDBHM0YzVzFOcUpHUGg2TW1lVkFvallEdlVBWjVyZGNTNEd5NjZ2clN4RkNx?=
 =?utf-8?B?M1d0Y1JmT3JXVFhzWGpGVXlvNkZTbDhTSDlTNXJHbGVSKzRXd29TRzl3REU3?=
 =?utf-8?B?Zjg2N2V5ekF2OU9qMHNDeWdGbVJwRkhuNG53L1pXNSthWWUvZWh2Rmo5S0dv?=
 =?utf-8?B?WWl3Tm4vUUlJbEhmZENBNkdrUXhnVU4zM3JMczBDQ0VqdlBGT0swRU8yemJv?=
 =?utf-8?B?a1JkRXp5NjQ4Q01vY3JrTUNiSmtlTytmd2dqU0tFK21HbWlaWXNNd1lNWi9U?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5d9177-db81-4262-ba9f-08db0eaca448
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:58:05.9263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPIBNsbtmwcMi/OjwdhGaqzTyRN6nzyWlnD0ukL7yR2243xlSdRb0/JfCwLoCTUlDwFu7WP4H8VGu770BpvazFyw5qosf4S7F/KzHE1QIno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8214
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

From: Edward Cree <ecree.xilinx@gmail.com>
Date: Tue, 14 Feb 2023 15:28:24 +0000

> On 14/02/2023 07:39, Leon Romanovsky wrote:
>> On Mon, Feb 13, 2023 at 06:34:22PM +0000, alejandro.lucero-palau@amd.com wrote:
>>> +#ifdef CONFIG_RTC_LIB
>>> +	u64 tstamp;
>>> +#endif
>>
>> If you are going to resubmit the series.
>>
>> Documentation/process/coding-style.rst
>>   1140 21) Conditional Compilation
>>   1141 ---------------------------
>> ....
>>   1156 If you have a function or variable which may potentially go unused in a
>>   1157 particular configuration, and the compiler would warn about its definition
>>   1158 going unused, mark the definition as __maybe_unused rather than wrapping it in
>>   1159 a preprocessor conditional.  (However, if a function or variable *always* goes
>>   1160 unused, delete it.)
>>
>> Thanks
> 
> FWIW, the existing code in sfc all uses the preprocessor
>  conditional approach; maybe it's better to be consistent
>  within the driver?
> 

When it comes to "consistency vs start doing it right" thing, I always
go for the latter. This "we'll fix it all one day" moment often tends to
never happen and it's applicable to any vendor or subsys. Stop doing
things the discouraged way often is a good (and sometimes the only) start.

Thanks,
Olek
