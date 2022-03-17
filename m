Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD94DCBF9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 18:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiCQREd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 13:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiCQREc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 13:04:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25997BA32C;
        Thu, 17 Mar 2022 10:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647536595; x=1679072595;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/yY4nSsr+tHhEtO0kKeaFdp4b1tXBAvYFMhlrGTA4GY=;
  b=EpnistuEn+/PI1mrEyjYtKtOYr1DRzvaYcPZj3gRtq2Kfi6jRNdWp8gL
   oQ/GeJihCtkG634WDtQ8vv5Op2KI7HlA/wf5+P11xlh8shb5kgxLE2Qt7
   sea1tx4/WODmqLWy311gFaWMuBk+CoqRli3cYnTjNoCbkka4q0aR66But
   ap2T5eziFARBQX7K9+nbPCF/cs3nH1DP84ZNsaUimZAlp1cRZUTd5DNjE
   is6KJuwOzZrhbd5uZe6vK7Biz5kdH2duiM7HWIyWfmEyXP5VKrh3ysui5
   +mJWDKQl1NNH4SwA+6fVgo5ZgNp4PHSD+DEwYYSNSCptYxOcje2fpMQfU
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="320130081"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="320130081"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 10:03:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541444660"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 10:03:14 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 10:03:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 17 Mar 2022 10:03:13 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 17 Mar 2022 10:03:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QErU82oekntUS6/E/EuSDbZi5Ueotqj+Mr3nbxSm6OKnK/e083Zprc7BNiBEgtYiFATj8bLgo4MZtuU/o9TQYWhZkr+3mMV88Y+cG9Da0+w8gfrpjDNdHp2Vb9B80PNLeOD9c95GkBvYwzh9pDrpBFPFSrTidpQ8bMFCAf22YmtI47qSutIcH9sbS/tSpmqw4x75oMfsHLq5L21gPS3lMtOO3KpBekOmBmhR9B2AtfVV9cE9UgbzbsaCJOgIxgYcnuGMT4ey+80zWA2y+/G52aQfd2sUFrfV6yYXNcRn3sC+ZkD2vPg/1+pcmdvnc/Gzovqs4Mp5MQJdpaaT8u65Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDTz2PbRA18x0d1SJuht57mJk7U7PfEfdpA5Ji7OqOI=;
 b=jGO8zRBGL4pG4ci7CVlXhMHAFf53nvItgIVc7InsEY/hmW0a0lfuGYmtOEX5/yUZwip+e26hG0Hb+CPgksnBCpmFd+SUoeBOZno3xNVYko80HZPCoYISLOBEhLpKGRXQ7SHaC1+j7hIUUSZNmiaQ6JsTmgaMCmWSIsHN0t6+XNOETGTWebqj+RjitOOUgScnVZCL2O5DHX4FmWXnT9tQtilymwd08h2vug7dLY2PVySbwP6tf7jBYBAK7L49NGQBs1dGiocFYXwrj8BjFFncnpRQkgWc32sumsx5UtBDON1TYU50Hij41ya89qW2N6hWUlM9w3xUfAwLd2q2LUizdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DM6PR11MB3164.namprd11.prod.outlook.com (2603:10b6:5:58::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Thu, 17 Mar
 2022 17:03:11 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5061.032; Thu, 17 Mar 2022
 17:03:11 +0000
Message-ID: <cc7a09c1-8e1f-bb72-c9f1-354bec9dec18@intel.com>
Date:   Thu, 17 Mar 2022 10:03:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] iavf: Fix hang during reboot/shutdown
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>,
        <poros@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Slawomir Laba <slawomirx.laba@intel.com>,
        "Mateusz Palczewski" <mateusz.palczewski@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220317104524.2802848-1-ivecera@redhat.com>
 <20220317091104.1d911864@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220317091104.1d911864@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0311.namprd03.prod.outlook.com
 (2603:10b6:303:dd::16) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a63df4c-fbc0-4948-083f-08da08380471
X-MS-TrafficTypeDiagnostic: DM6PR11MB3164:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3164BC73D064AFEBEB41972EC6129@DM6PR11MB3164.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpqyqUXEVUPHlB5tpXTa2UnPJ+zW+EANKQCZpD5GrAHSo4dTr4UWu22sxdeALM5v1nI2MtrV9/Pse9OGcliM5zw3s+tt3nrJkAWto1Jpqi/f7tRG6sHpXOR9ebHcOA6BRzhDYNvKUeAZqEKJ3rdj/9ZfTuvpQ8BGRhNmo31nvtSdJduKhHqgOE/SnKpTMKgo6yZAQBOJjuaTVWDmWqCIt/J+TRhJlG6L5GZIKjTraMfN3nVotLrrHnAsJnB2kt3GK8IafMogp/00HZIap3/UB3uYIOn5pQHo4f+asJ8LrsScddfoiixa6AwSoMHriUPRTlNn5pv2vaO3sddpGpelajD++2hfe74YKKfuaqduzUSpbbDL6gGOPN4CYSzuml/OtpZp3DCMO6JGgKL/1braAZHiWvvTYnyyAqbKZfhycLfvY4d751cFVl0zoBjwl+iCfNq/ibYn1GxiHNYGMMXRvkkurUVsOCQoa656OLKnS0tz9WNGbSf8Qa95nKYqB1ApAdLSqpwpJJl43IDe5Bcfgw5m/E5nNL9Os2nqkc3AHvni33+gozVpBw/BcMBFe0CYSK0uUlyES4Nr5oRU0Ch+npLqr4E/5MwaPcQjzuDok5Co43p9QW9uSNSpCPrhNzrSluPh90EHXgyIW41M9Sybe2gvI3/KbkdIgNbfiJCfX5TXK8IJzTrTMHIdxKXDaa9hR/4ILYPAtrCK87gzMkMmSGJRNF+QgHSbFM1HTzec24/IzokkR9CkwVnltAe3NsFy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6512007)(38100700002)(8676002)(53546011)(82960400001)(4326008)(66946007)(66476007)(66556008)(316002)(6666004)(2616005)(26005)(31696002)(110136005)(186003)(6636002)(54906003)(2906002)(86362001)(5660300002)(36756003)(508600001)(8936002)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTAzdW1IS2toN3JxVnY5N2dZdFFxY1lJYWloNllTVEpSaFU5b1AzVENpODY0?=
 =?utf-8?B?SkxneWN4TEVkV2d2MVhPTmh3RFJTNVl0RGJrOTlSUHlibDFWUDRmd1BKNkRB?=
 =?utf-8?B?QjN5L1A2OGE3eFV1K3BkenFXdC9kUmZGQXJGM21mN2psckpNRU1lUTg0OGxx?=
 =?utf-8?B?L0lYQmcyKzN0b3luSG9TSXA4ZDBmTHJFSWxPSk92K1Nxei9xTlpwbFNZbUd0?=
 =?utf-8?B?ZnZ1U0VubHZuRTF5aUZ5SlVmYmxaSHd4Q1VjN2lGYXRITHZ5QmwrYmdjRktN?=
 =?utf-8?B?T2tyRUY2cWFvTWR3UnRsN3o1c1lYTThCTndzbE1zTmtVZmdTd0JYeTMvMjF4?=
 =?utf-8?B?ajkzbzgxYml3MW1zZFU5cS9yL3Q5QlFOUWE5WUlUZGpXZjhJWmVWOE9CZTlm?=
 =?utf-8?B?azZrUmlpcTd4OGI0KzBtelAzQ3dQdjZXWmNWT0VmL2lERFdWQklXN1VYN09C?=
 =?utf-8?B?YVovdS96d3B6dWNNYXk4aGgvT2JBaUxWdGxRREpmTlY3a2NOTFdFcmNHSjVm?=
 =?utf-8?B?WGVkc0YrRC9TOU5wbXhPV0xTaWVvSjdReFpzalpDWTJrTXRUWjc3bVIrU3Jk?=
 =?utf-8?B?TEZyNERJZCtNQzRvSWxJeDJiOEphVTQydjdTTnl2Z3pwdkZrMnJOd0ErQ01R?=
 =?utf-8?B?Rnc0MXZZd3dvSkNuM0VsanJKQVhYS256QkxmZTA2TVRUbFVLUHpjSEs5TS8x?=
 =?utf-8?B?MGZ2UzhoL0VlMmlER0JpakFYQjhtUlZCcUJuRjBUTFlXeW1BcVN2NmtnUE9L?=
 =?utf-8?B?U05ZOEhNaTF6NVVXRTBOeU1MQWV6YTFabVdxQXk4Z1RhdjhOUGhQTGhnQlU5?=
 =?utf-8?B?Q1Z3M21JcDdqYmJxckhXRFIwdGVwWnVEZmJkRDBwOEVWb1NVcEZaV2FqZmJy?=
 =?utf-8?B?bGhVUi9lVzE5QThNLzBlSDdhV3I4SkNzd3Z2R0w3aXRXWUpPb1JsVEduZGtm?=
 =?utf-8?B?R05VcDExS1ZhcmFNaVUwc1c5b3RDbTZ1SzI3OFlQQldDUkord2ZoOHp6ZlBV?=
 =?utf-8?B?TnE4WDBXL2FrTnZ6elpBUkpyYXc4aitMbmJoL1luQmxaZWZmaFdBUkFhQmlF?=
 =?utf-8?B?czdFREpmTlZXdEgwN2xrK1NnaTU3cjl1cEdLb1Q5TXNncG03ekxrMnlYbjRW?=
 =?utf-8?B?TzAvSFl3cnpSOVBtQWd3Lys1azZIY1JENTFwR0tNbWF5YlQvR25RS1NBVElB?=
 =?utf-8?B?YlhFSHUza1pNSC9PbVRCdGU2YzhrdDExSjZmYUg5MjlZVFRheDJrYXRxelZh?=
 =?utf-8?B?N2huWDBWdVRIT2RZQm9GaU4yVm9TSWo3VXJTTjFPK2lyUG5SNUtzNDVYQy9N?=
 =?utf-8?B?eVIxejl1N3RwaW54ZzF4Ukx0a2xuWUlBUnZGa2NETHArUHI3SXBiMUtPSm8x?=
 =?utf-8?B?aG9WaFpUZ3owMGRjODdWZjdDR1hQbURSYmhKNlJENnFTbHBsV0NrL0xIZXoy?=
 =?utf-8?B?WGxrUWNldXpVMWRCZUIxRnBPYW5wZmNkMlNLdHY3TzhKNEhhR2NhM2JaZzJ2?=
 =?utf-8?B?UDNwVUpOYjRiZWlqeGhQSzZ6dFYwekpUTDBYWEFGa2NhM0JlbDVOSDJGU0gw?=
 =?utf-8?B?OTBmSFd2U3hIazVlRjBhNVI0dEM5WkVsRFlDMWlEU2d0VnQ2b3l2MER2cmhP?=
 =?utf-8?B?YVZZNXpVZlZpM0J4cXUwY1UzbkJ6UXpvaG5JTmNmR2VFWEI4UW1DamNsK3hE?=
 =?utf-8?B?YlNadlZrRndLckN5c2FLMEJSY2lxdWZrSWlYQ1ZEalJYYWhSdFNOVU92enNN?=
 =?utf-8?B?b3ZZaU9RY0w2YUh5aE03Z1ZtOUR4ZGxBZ3cwV0NVMWFZRzU2aFR6eTN1Zk1V?=
 =?utf-8?B?aEZ6Ti9QWWdnR1BWcnFERUQ1SXo3RkJEdXprN0Ixb3MzelpoTEJMTk4rZ1Rj?=
 =?utf-8?B?b1lEYlRIQkk1dE5TRVRjMDFKVHcvMm51WFFwQVc2dzVLVUhFZFRTTVVvN01o?=
 =?utf-8?B?aFV5SXhKdENnUkxvUFVIVUdjSWxCeGwwWU85SmQ3b3c0Nk1qK0pEUHlDcU5E?=
 =?utf-8?B?bzdidFF4K09nPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a63df4c-fbc0-4948-083f-08da08380471
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 17:03:11.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rD24NJ5O0JR/jeMcxHtssQkwcp7OMz3ADh9G2UoV395uB+5+UD/MlvmkqJViT9mRs+l3qG50YxD+3kE5dyirx1IZlJP2e9V5wAQC2E5hgqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3164
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/17/2022 9:11 AM, Jakub Kicinski wrote:
> On Thu, 17 Mar 2022 11:45:24 +0100 Ivan Vecera wrote:
>> Recent commit 974578017fc1 ("iavf: Add waiting so the port is
>> initialized in remove") adds a wait-loop at the beginning of
>> iavf_remove() to ensure that port initialization is finished
>> prior unregistering net device. This causes a regression
>> in reboot/shutdown scenario because in this case callback
>> iavf_shutdown() is called and this callback detaches the device,
>> makes it down if it is running and sets its state to __IAVF_REMOVE.
>> Later shutdown callback of associated PF driver (e.g. ice_shutdown)
>> is called. That callback calls among other things sriov_disable()
>> that calls indirectly iavf_remove() (see stack trace below).
>> As the adapter state is already __IAVF_REMOVE then the mentioned
>> loop is end-less and shutdown process hangs.
> Tony, Jesse, looks like the regression is from 5.17-rc6, should
> I take this directly so it makes 5.17 final?

Hi Jakub,

There are some additional improvements that we think can be made but we 
need more time to analyze and test. This is probably good for you to 
take to make into this kernel though. We will send follow on patches if 
needed.

Thanks,

Tony

