Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75DF6E1383
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjDMRbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDMRba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:31:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B9C8A7A;
        Thu, 13 Apr 2023 10:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681407089; x=1712943089;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dRYa3IEoCQadGXeb+C5TScIzO9XN1dTP08WEo++0yGE=;
  b=HfJGiYwstnKBvlFu7PWMbje5AD1pAd4Cg6Bwy/r8xv/z4CkZ4luo+2Y5
   5jZrx1LqsFbaMySY79LaxraWvuRZ40QNPSsS/XMV2WNOPIrQN5zsU79Ok
   qMVNTN8ftWqBFMUyF3CaiLo1389WMLjBoNFVAcUtDi+dtlRZLtFMIOLAy
   UNVP0SEvywC6ZF81NI/WRoxDOZEzOjKwWRAgSCRcK6PrgF5tnlgkImnSC
   0MWhTqzQcIKe+EkCfcyp13O3NIZRway3VqZ2BBh0bLUl7hpzkP6KGwAFs
   hO3m7ij1dQg8Qb25lcvOyHgQ9kcP19xO8rbAB20A+CbfCcM0+gYbNbw+f
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="430539640"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="430539640"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 10:31:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="719946179"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="719946179"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2023 10:31:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 10:31:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 10:31:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 10:31:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 10:31:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KugZkHD6q43w5JG5x5dwbUuDULJtwDIfdXu5xpChnf9KKNhd+vqpAaRtnn/MmCgCst3+4mo7FOTeD7+G+NN+/rvLVt+kSFGO8UDUzDukLPeOnl0y2RcYCSgKoRQnPG3VhMIirkqUwzJIFvs3GWM1w5dAZfkkE0Dq/eI1ARl7TFUyXFpAb4U9KWpW/R/NLWVPgT6bxbeHxFjfZfTjAF12x40+EpkeJQGd9b267RVrurVTMlq1qUaPuLwXwe5cRH+OSGE+htphHg6lw6xWRh1AsKmbCY8Z4cHBrO3JWFO47i9Y/nkdGVhdUZklJPD4NxNScKET8LjaLQzCSeQUZ9qkrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAJMgZpNIvIWfvPoZAE37teCdL32p76bYax+K1EpubI=;
 b=MNekkveNa6C8Zf2C/c0pnVQs++Lbg42JZgmuHVhn1KuZSYpGG1Fa3B39y8Tg7YUBblWybbn8ih7zmeCTaiFE8NVl02DB0Hidy/nGe+KDldlOOOmN+5i/UGGdvgy+eUeuLixfJDjbn1XZ+Wsl0fw95leIwZdoUOa9vYk9TMwI8IGADiBWXCcyWg4XAxqtZP3MYDhmrEveQw9jIsNzX9ajEPy6Wb+VwupqybEt1zLVAFvFifXbscoQkMP7YHjhHTBcP0u7F2cGmksyNFLpLalhJXxL0r+qz6VNq4MWh/mx6fH1+IS4UNU9UY3HcsWSH1DFMC57FiupFbWfaXMviGPy9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 17:31:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 17:31:20 +0000
Message-ID: <e31dc86a-d546-5268-02ec-140ea64a1981@intel.com>
Date:   Thu, 13 Apr 2023 10:31:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v4] net: stmmac:fix system hang when setting up
 tag_8021q VLAN for DSA ports
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Yan Wang <rk.code@outlook.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "open list:STMMAC ETHERNET DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <KL1PR01MB5448C7BF5A7AAC1CBCD5C36AE6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
 <01ef9d4f-d2dc-d584-4733-798cffda49a1@intel.com>
 <298c045a-5438-6761-46d8-c46c57989812@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <298c045a-5438-6761-46d8-c46c57989812@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0184.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::9) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA0PR11MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: a8035f10-13df-4521-104f-08db3c44e52d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D3f0YiFlripkJY4Ynm+3BlyTfpjuhcl04ADR0Ulfwg3YnnFECwZFdiEotFq5BJgJ1bx6i/SRlMwQ/aX3N7kZyXzmOY+MhlERC6ZTXQWlGFlt6D/icSsIv1OsWQMqVS++FaXMtZNNLISGpVrrNWungDMHENNJ9nga3TCPYgSO6fzA0hVYjFupmRLJDbj/Jw+lReTmmh9PzzlWCEXaulOVJXk08whiVanwvXXiXs4uavcCtKvS7VwGBhiVQKSBxDFKBx9uC2Z59rrq67geJfU9siqmgWCNSd4GqwS4bd422fj+0pGCBTiUGGODU1UY5mkuRrTPQwk1rSgvubjKJgbYezxv6k34o9qOfRyOJHwfRig1w5JLuckNJqYkCphmsE6ZRiFqqP3XoiT22GT/KgCHODn2UJ5jXru2kK9eB004HjkAOAoXkqIwE/gUlQ2LgnoUlqoJLx3mmHv414j9uIoTJOwdE7ottCpBmn65qUiDevyt++jy7+pPKHPC83IfYsVqtzWksuV+gGXywDCaYQm7pJBTvu3ksTcYbhOH8uvksF0fkb4CNLk8yBpClylOyGyGjfuS9fR+mCoe+uhdavRWF22+z2F5ZKUtLd1ANwQWVpIFZ45KJWDSBEBiM3zvU3ZnRuB3YPBAnT5Nc7+U3EJljg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(6486002)(966005)(66476007)(66556008)(66946007)(4326008)(36756003)(110136005)(2906002)(7416002)(31696002)(86362001)(41300700001)(82960400001)(5660300002)(8676002)(8936002)(316002)(38100700002)(478600001)(45080400002)(54906003)(53546011)(6512007)(6506007)(26005)(31686004)(2616005)(186003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enJhYkhMb2Y2YVpWY0JTV0Q3RDBSQWl6Y2NuWC94Mm5QeGNIWFRvc0FMMEgx?=
 =?utf-8?B?S3BRZlA2emh1dDRuUEs5NUZ0VW1jUGhFQWx0M25kc3ZwaWZMdTBNMFhPZk0x?=
 =?utf-8?B?OVVhREV5dm1sbGVESndzQXVWc1ZoVEZVdHJLTll3d3AvYXg2aWpMMXJPYnZw?=
 =?utf-8?B?RDNiZHFlSFRDN1hxRlhIUmpMRjRoR3o0UjV4V0I1TDljaWR1ZzdKbkZGUVc0?=
 =?utf-8?B?V2ZQNnhYM0lLbG1MSzNUOXFqWVFYV2RnaWZMTmFOcmVLMTZFaERIVWJ3R1Jp?=
 =?utf-8?B?SU94UStxcG1Ib0ZuUGZPVHNCWU8yb2JuL3c5ZUFwVmVId1BQYnVmWXMrTk9n?=
 =?utf-8?B?RDlHZlEyU3RPTHd3a1FISEZIQ1QxVzdnS3Uvek5iTERZSjNKVEluUE9nUFJl?=
 =?utf-8?B?WXdSQlZwbWMreXh0bXNuQUNQRW11T1J6MnM1RlR6NVduQjJ1L2xYNUNOc0hS?=
 =?utf-8?B?RzZsUW9hZFozdUVpYmZuQS9TTlhXVE9MdFlFbjBMVWNMK3FSWWUyVmcyQzd2?=
 =?utf-8?B?RXFZbmgrM0IvZUQ1NlJ4czdJVkczdEJ1MjV1WTNFR0hERWVsSGJTTnhLcXlp?=
 =?utf-8?B?SEZROW9KbmdMeGlFbldQVTdiQzAycnVPcVdEMGVsZWNHbUJxZk9Tc0VhM1hR?=
 =?utf-8?B?MTRiQ3QzWEdvemhGVzRYS2xURUEwZWJ1M2tJSjlncXNOVGh1cDhGMWxyRzVW?=
 =?utf-8?B?UVVFUWtGZ004eUtVM1NIVTN6QzVrQ2IzY3hwbUI0MGttbnlRWWZBRHk4aHhN?=
 =?utf-8?B?NFBYSmphZjhIWGFKZmJVblFsdlF2WFlQT3k4UU9DVkM0SVpyNXBWUDJrNzU5?=
 =?utf-8?B?djhYdzdsbmwyUk5mVGpMVHlFV2Y1dWh2Vy95bjl1RXVEaG81N0IwamRNaDRW?=
 =?utf-8?B?Ylpla0lYWWdRdDFvK255MUtCTTZrbXlmVFBQMjZDVXFOMGV5S2FUbTNRUDRt?=
 =?utf-8?B?eGFYZStEc3RHQXR2QXY3cDB3b2k3SjlpL2RwUnBQMEpzdGVUY2M0MTRRdTZt?=
 =?utf-8?B?TlhMdTdiSjgyNnJYYlpzd1FtT0lPTjUyZThVQmtybXJ1RmpKRE1sd0l3b3lq?=
 =?utf-8?B?YkdBZWVpT1R4S2xjRDJzZHA0NytZZlk2Uy85OHp1TnJvSWZEOEpJaVZ6ZDFD?=
 =?utf-8?B?dnUxMmxxeCtVcTdTR21SM01ZK3V5OHhvVm1LWkgwOFZRTWhUd1g1RG8vY3FH?=
 =?utf-8?B?L0pvTkc4ZmV5dTlVdjJPWEU2b1hrNXRGRmFycnZPemNvMU1tcVlxVEsySmt4?=
 =?utf-8?B?RzJEcjRhNTRFbjZVY3VRV0dNNVRua2NGb3AwRkhTRmdGKzZodVprSGJWcHpN?=
 =?utf-8?B?WmY3b0dsVEhYQ1RwMEVwd2xHMHc1c2Z4L2o5T1BhL3RXZW1pL2xhQ0swTE0z?=
 =?utf-8?B?QStOUE04amQ3QUhzbmYrRXVDUFlzQUVWYzJFNUZzbm8yVmxmWWtrOGpsZFl3?=
 =?utf-8?B?eHlOZFY1M0lKYzhlMk1CdkNOSjk3bFR3K0VMVEQ5aGdWcTZBd09xV1pCMytv?=
 =?utf-8?B?My9MNnNTekZQN0w1YnVDNVgwSmZ5WnNydWdyTEJxK2xaS0ZSeTZUeFR6VVpP?=
 =?utf-8?B?NjlPcjdJTjFaY0liUUJRZUdncnpuWWhLYmdEejcyc25SWXdVR25xM2V3a3g1?=
 =?utf-8?B?ZG4rYlFuSEtZeUZoL1NBQTJWK0lHUVdaWFNYREE2WkFiUVdRaVV3dStIQU1W?=
 =?utf-8?B?eHRaTGdsZm1JTzB6cmtYQm5sM25GQ0NOalBuenF5NWxMdXJwQ2JGY0dNUHNS?=
 =?utf-8?B?cXVtTkNkNXc4UktCS1F2bUFycFpZZU5VeXlaREVGNHhQekJHZjFmNGk4WW5u?=
 =?utf-8?B?ZWxQK3dsT3QyYjI2Ynd6MGo5TG5lb1RsbVFpam8wOVZza1NZL1YrZW9RWVln?=
 =?utf-8?B?Y1p4NzNKcFI4SjFkTTVsRWI1dU83ZVZpdUVYSjJ3M3U0dHVFdWt1dTBNMlpC?=
 =?utf-8?B?aU44NEd5eWRPTUd2aDBkajltZW9qUXcvck4wVGVkYWNHaDlWVERXTWtkZmFT?=
 =?utf-8?B?TjRKbzNmZDEvaTEvMVh5d1h4L2tsdEtvanFGeExMOFlmWUEza2x1UHZLTUZq?=
 =?utf-8?B?blYxT080V0xIbVFPQWVwKy9kdWFwTzQ4WVBGV055MHBTOHljemlhZXJHVlh4?=
 =?utf-8?B?Y1k3K3BvZld2VVNaOS8xOGZKMTk2cjJ4ZStOS3lrTmhkT1hoc0ZKMmZmcUFQ?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8035f10-13df-4521-104f-08db3c44e52d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 17:31:20.5455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H8bJnE1CURIJkWwooHvQ7ACWoOIOQYDH0lmKReV3QnOkGKu+ShNBdiBYzIiHU1dWHYfP7Il191ajAi/tkCVUZH7pTJp04bZwKAl+QcU+k2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
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



On 4/13/2023 10:15 AM, Florian Fainelli wrote:
> On 4/13/23 10:07, Jacob Keller wrote:
>>
>>
>> On 4/13/2023 8:06 AM, Yan Wang wrote:
>>> The system hang because of dsa_tag_8021q_port_setup()->
>>> 				stmmac_vlan_rx_add_vid().
>>>
>>> I found in stmmac_drv_probe() that cailing pm_runtime_put()
>>> disabled the clock.
>>>
>>> First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
>>> resume/suspend is active.
>>>
>>> Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
>>> will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
>>> The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
>>> registers after stmmac's clock is closed.
>>>
>>> I would suggest adding the pm_runtime_resume_and_get() to the
>>> stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
>>> while in use.
>>>
>>> Signed-off-by: Yan Wang <rk.code@outlook.com>
>>
>> This looks identical to the net fix you posted at [1]. I don't think we
>> need both?
>>
>> [1]:
>> https://lore.kernel.org/netdev/KL1PR01MB5448020DE191340AE64530B0E6989@KL1PR01MB5448.apcprd01.prod.exchangelabs.com/
> 
> Unfortunately both still lack a proper Fixes: tag, and this is bug fix.

Good point. Yan, please identify the appropriate fixes tag and send a v2
of the net fix.

Thanks,
Jake
