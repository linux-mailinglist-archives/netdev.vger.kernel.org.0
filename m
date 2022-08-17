Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99A55969F0
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiHQG6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 02:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiHQG6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 02:58:05 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27C17548C;
        Tue, 16 Aug 2022 23:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660719482; x=1692255482;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=55olwJm1+hmKpFG+QTh6M92eyTs6iikSb1Fc93/mYJo=;
  b=fR0/P1CI04nW0rRZ0HeHd9z27oLg+jER9q9t3N/tQ/UjNB6ZRzb8O5pc
   0fH6ELB3KmhfYrwsKpSlxaOOaWzBCHYZ2WVQr0ja00JwE5hztdmHw0/q1
   y3nsx1kno3U4V2GnEKAXisr0jsSi7QBgmning6sIZhIq/F4c6hsxeBksu
   P0UwM9T/p8JYsvo0GV7ll1hWyGmCPooV3ch5W6yrpQT/lmYFur3xpjaWZ
   rs1ExTv9i68LWt56Y99wljTP4vyIAXJXB8n9RnNKEJcI/cznFyPLuU5mc
   hpo++yxkWg7vqh03ZQiAQb3capawG8Fw5Z75FJS+/CacCatD1ZJLsNYQO
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="272813209"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="272813209"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 23:58:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="640339889"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 16 Aug 2022 23:58:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 16 Aug 2022 23:58:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 16 Aug 2022 23:58:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 16 Aug 2022 23:58:01 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 16 Aug 2022 23:58:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQi+yQ7vMrZcz8IQYtsh06ipbz22xgwBXz5uxXuaAQxOZ3Unr91HgeIkdl9WIdtMNvH745GkhEXo2lT2r/qOTugjWgC3Kg4GieS8X0o6oWN8W6P/HSVyRj6Vi868pmnemJWMJojd6e9EOLPC0gWdtHn0t09uqYAPhCNAdcz5Q9Z8HIDSBhO40glKYVfWD330Uk1cg3oUVx9wLRfM/rVFo1plLJTL95LJsMWe35F3P6GAOHHyTgujEHozJcQAddhxPC2A0e5TP5FHy55T7TJnNXao286t1UeVq6wshf6JZ3W0zQkVtmq7mx3WD9vwcm0lBRM33tPG0UWjsiplKgKhag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tr6sL5nhCT891/KbeU50nAsBMWFHohjlsLTe0GVNMP8=;
 b=LT5XmNmzbjq0613HYXvAoDgbbdaVOY/zOd4MBVMgwBpxq/3A3SXWTS1ynvrQ4sPE9mSK9Ru0ygaKiJ3LXmu0S0w6km0H0J19VAjnJT1BshpsYlkWnF/4ONVDLFhIg28ocvjB7ATRtUXSGXiF7U4ZI3MI/MlVTF4JQHTP6PmoFeUqReladqC5lHX0IPlYeHtMa5NC4Pt3Kh1WoWAWUYYSYkf5Ihj3zw8Yfn1acxsveyx4Lvc1fXjcZ+FAmwInf91+0FebV0LPZqYi9hUpnVT33lj/Kiw4AiKJ16ZzY5bEUD8AlYJ1mEg3xqVuHqd0JEZRRR0g5kGhDRYs75CeNUsS/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3413.namprd11.prod.outlook.com (2603:10b6:a03:8c::29)
 by CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 06:57:54 +0000
Received: from BYAPR11MB3413.namprd11.prod.outlook.com
 ([fe80::6423:dab9:c2a3:41d9]) by BYAPR11MB3413.namprd11.prod.outlook.com
 ([fe80::6423:dab9:c2a3:41d9%3]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 06:57:53 +0000
Message-ID: <359a66f9-c8cb-0319-5e01-8a9a54f70d36@intel.com>
Date:   Wed, 17 Aug 2022 08:57:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [net v2 1/1] ice: Fix crash by keep old cfg when update TCs more
 than queues
Content-Language: en-US
To:     Ding Hui <dinghui@sangfor.com.cn>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <keescook@chromium.org>, <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
References: <20220815011844.22193-1-dinghui@sangfor.com.cn>
 <dd4f9e5d-d8d7-3069-21ee-7897b3d10d3d@intel.com>
 <74f0969a-7b15-0ceb-4ae8-08c242cd1f83@sangfor.com.cn>
From:   Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
In-Reply-To: <74f0969a-7b15-0ceb-4ae8-08c242cd1f83@sangfor.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0011.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::21)
 To BYAPR11MB3413.namprd11.prod.outlook.com (2603:10b6:a03:8c::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab6cfcc5-9ba9-48ba-c5ec-08da801dce65
X-MS-TrafficTypeDiagnostic: CH0PR11MB5521:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ROYkJiI9rjiQUP10I55+NjqPnzkxssfDoBoj/CXQ4ofVGa2ltlIZ9ijYJyr5ziMtavXohoyAKahiXBxvvO6DM0JyZWeRNGI441SFh9uLUfhoprnRfE/qOVCI28aPyA0DrBgmAYdurfi1JLULertbjTLNzDHgWyUbmEoYHEEq0qtybC0nBjsIlfAaqZ8hT5ZuPqhPTMrKgVR0ihTG6E6p84M5Fyi5ZrndmkII+BrfhNLXppINOmsJoFiGoHvm/MQE1o7dsiC4aWnceWiVQS+4x30YRNEaFblxrRXqI47Vlg4JJIhT/FBbp+3AEdCgP/Dh38VSFOABq3BVFjEdi7jqbz4127a63ub+22vlVGBGN/FaYOxtcWqCb02bbzkalMh7HYR5wPTORlTsKH6UQA0xKtKNv5geEDwHwArJ5/MXfGllxaFdUnpVa755br9/fHmlc/20F3kpYYyVGKMPZHPNS712woXPh3T0HXBVKeI761grtETIE29s9VG6eJnIFTUziXmAfqwL0RW2bBLqAAZZIJMVCs9mDxaFLc/cO+SjWJedcYS6mSozMYyVZ8z8Zaknq4q1qSmb/wc9XvLFGdEoRO4/XBEEoApWjPFpYH4nvhd6a0EjM+AjXpk9019LcsgfTFuL9i8jinXf4ax6YOPeX4QzNLil6IIiiWiA6sCMRaHzyM8mbRvdiYJAi/m+UOTZhS4lIcJVIB+i426gLeR7XPol6unort1A1BXU+bFNos7JFQqO256/rcCE4gttHaxF9a1aJTPTa45fuiIk9TUo8NtATaCUbns+e7quGPnT5FbYHnSsEvWyETUYUp/4ZUq910+jByt2SKJXqXLmE4/5vg8Mihve9sPbXt25zg9N3jvw9cfWdCak/nnmdzX9Frf9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3413.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(366004)(39860400002)(376002)(136003)(7416002)(15650500001)(2906002)(8936002)(5660300002)(31696002)(44832011)(86362001)(66476007)(41300700001)(186003)(6666004)(2616005)(82960400001)(6512007)(6506007)(478600001)(83380400001)(53546011)(966005)(38100700002)(316002)(8676002)(66556008)(4326008)(6486002)(36756003)(66946007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0lGVTVmV2c3ZkxSNzdnSmI3L0dWajFXYXdHSUYwODAxRkFTb1BHT05WRXNQ?=
 =?utf-8?B?MXFaaDg5WHlYOThzOU5wUmdwaVRRejd4SEl1VTh6ZmZ1WXRpVlhHOUtPc1pD?=
 =?utf-8?B?V2VTVHB4cEZmZE1CUXpOK3ZpMUdYaHNINUpZNkt5YU9HVTUxV3l4Q0oxd2JU?=
 =?utf-8?B?QVMyQVhFdTR5VXZQQU1TTUY3OTNKR29CU05jMDdmaFkvMkk4czhDaUpBUzlw?=
 =?utf-8?B?Mm5aVDc0bVN2aEltYk1lZlF3amVBelRjcGdZZXZnb2R0cDY0UlVDT3hrU01M?=
 =?utf-8?B?Yi9uT0VLTXVVY0NVTWdsTUJoZEo0eUhlNnQxdS80dlExdGxobU9wOHVUTzJ5?=
 =?utf-8?B?dmhWY0NJU2VxajlqVUc1YnJRaDdMeGhHaG1VNDI5ZmM4UFBjMHg5WFUzWkc4?=
 =?utf-8?B?UnZXdWtpTTFHbHpzT2xnZTNVK2ZGNVFnUWdQUkRock1vSVFFYUl3N3lUaFdt?=
 =?utf-8?B?VndHWlluR2xJbGVKNnBoem5TaDNzbHozQUFpbUY2VmhaL3E4YUVKMVJrbnZG?=
 =?utf-8?B?S1JydkV0WGlXQ2g0NmNaUzl3NUhacCtTZEpPb0RrZ25UeWU0Ujh0Y3p0MTh1?=
 =?utf-8?B?ZWg0WVZ3dDB2MDdaT0lid1dYdy92SFVPVlA3a2JOUkFtZ0Fyb1RJQ2Rib0hY?=
 =?utf-8?B?YVhiOU43dUljUW1PVmlMVXM5WUxtUWxaNURmd3hJa1RuNXNZRzYxeDhEK0I5?=
 =?utf-8?B?WlcvTC9SekNZZlROM3FPUkxUOXZyRm5GTFk1bTgxcU41TWVReFUvbzFwTXlU?=
 =?utf-8?B?dWl5TDhnRjBLVWNiZU0xdnlKNFRiaGsrME1acFY4eFRwYlRyanI4YWMwQ0RL?=
 =?utf-8?B?QlZqSFhHbU14eURwQzJVRVlzZ05BcGVYMkwyMi9FbnBrMk9lYjRXYUI1RkhN?=
 =?utf-8?B?bkRIQzdNSExYZTVXZ05FeEpFOFFpUWhia01sTGVaRXdlNStETXZxMzQ2SWhv?=
 =?utf-8?B?L2R6UzhPaVU4U2lkM2dLNVZoeUNKU0NzSnJjYkYrcTVGek9BOXluZWpuNDRT?=
 =?utf-8?B?UXBVQnBLWGJDR3N4Rk9rbHVhS3p1SXY4K2EyQ3RMQmJBdzNZajFNMVFTSVFS?=
 =?utf-8?B?RUM5OWVxWDBLeDdWU3g5WHRXQ0liQkh3Si9JR2huOS9ieFhhbzhSd0dTQnNC?=
 =?utf-8?B?S00xV1NJeUdpY0ZzcEFLQ1cwcUFGQmE3dVMvZlBJWnBaQW1DdHZrZ3NXV0JK?=
 =?utf-8?B?YUFtdFhIYTc2ems4MHd1Mm5rcjczQTZsT3l3L1NqRFMzWHJIbXp0WEZHVERL?=
 =?utf-8?B?SU51Tk1EZG9kZ01PcERrWHp0UG1nNXd6SkR6TzRWMFl1NXlxZGdlSStmWXdX?=
 =?utf-8?B?WU9NaUx2WEwyQ2ZjME1KMTgwR1VyczhjM2tNS0Nua1hSUDdTY1E0M1N6YzEx?=
 =?utf-8?B?THBEelkvQ1NkeC9kOWMxZ0krTWh3enRQWmdBcnBBODY3UEtIT0FZa3AzS3d1?=
 =?utf-8?B?akpVT3laRHBYcWMyT0N6U05jU1lXbnRvRGNNcTZEV1ZPeW1JdGhqVUVheW0z?=
 =?utf-8?B?R0NGczFoZzArMWEzMHNoVjBEcXhsZ2JkdXFtZHkxQ3R6VERTbUZJSk1IaUlN?=
 =?utf-8?B?R3g4YldTdFNaaUVtcXc2dm9aKzRqVTdSYmlmOHVoWEVkL3BBdlhtejMzNVlu?=
 =?utf-8?B?R3Fsa2hTeVUrNjZYTWphN0RWbmtlbkEwWXcyY2o5YWhwdGpXZDdIcU8zeXJF?=
 =?utf-8?B?dk9URmdDUWRGd2R5ZkZ3UTRQWktMVE1NdTNvYjVkYkJ0Vjl5Umd0dXM1L0xP?=
 =?utf-8?B?eFlENVlXS1diR2tMVFRqNHE0a09vM1I1VDZjbkZOMFROZjBmbkozSEowcU9h?=
 =?utf-8?B?dldpL2F4WExabU1yVXl4a1ZhYWFUTnNyOUgwZkkvU3VUSE03Y3VqdGJwdWxC?=
 =?utf-8?B?cHVobWM2S2ZuOWFYYjJ6V0RRYjA0eXdDa2lPN1IzUkx0ZW1FMmJ0S3dBdWhZ?=
 =?utf-8?B?dHM2aXE2ZzZFVXFGeU5jQndkZGZrVjdtZjlRRmlLOEFNMnNjQUVVMWZ6ejds?=
 =?utf-8?B?NmtMNGErWUs3a2FjSnM2d3JSOUtoL0RLVFR4OXFhTmJlRnYxSmF6RkFPWW1H?=
 =?utf-8?B?ZW54NTRpT0JHMUNNSzIyS1phdk1ldmNYT2xwbXltbGh6UmZUNURTU1pDVFNK?=
 =?utf-8?B?c1dQNjYybWJYNW9LaWpsenF5bXNwb1RIL005dkpROWRRRnJBUkNaSndLTGJX?=
 =?utf-8?B?YmorYlY5dEFnK2ZKTHA1Y2x4UDFmeDlha1NUeG5ZV0Npcm93WUQrQ0cvWm1T?=
 =?utf-8?Q?Ogx+k1HhoX6XK3QpUgAAlcYfBW2Xz/oD/1bVisWW3I=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6cfcc5-9ba9-48ba-c5ec-08da801dce65
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3413.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 06:57:53.4341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qn7xm2R9vZ87+d5+v5CZcQMpzZUAf+oYWIsOZem+H6YTnjdATN4L+mpzlaemTWsxPpZVm4NNCK+g4GPM/SJKhN9S6h3lp4hXZf2HimJctw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5521
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.08.2022 14:44, Ding Hui wrote:
> On 2022/8/16 17:13, Anatolii Gerasymenko wrote:
>> On 15.08.2022 03:18, Ding Hui wrote:
>>> There are problems if allocated queues less than Traffic Classes.
>>>
>>> Commit a632b2a4c920 ("ice: ethtool: Prohibit improper channel config
>>> for DCB") already disallow setting less queues than TCs.
>>>
>>> Another case is if we first set less queues, and later update more TCs
>>> config due to LLDP, ice_vsi_cfg_tc() will failed but left dirty
>>> num_txq/rxq and tc_cfg in vsi, that will cause invalid porinter access.
>>
>> Nice catch. Looks good to me.
> 
> Thanks, I'll send v3 later, could I add Acked-by: tag too?

Please add Reviewed-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Thanks.

>>  
>>> [   95.968089] ice 0000:3b:00.1: More TCs defined than queues/rings allocated.
>>> [   95.968092] ice 0000:3b:00.1: Trying to use more Rx queues (8), than were allocated (1)!
>>> [   95.968093] ice 0000:3b:00.1: Failed to config TC for VSI index: 0
>>> [   95.969621] general protection fault: 0000 [#1] SMP NOPTI
>>> [   95.969705] CPU: 1 PID: 58405 Comm: lldpad Kdump: loaded Tainted: G     U  W  O     --------- -t - 4.18.0 #1
>>> [   95.969867] Hardware name: O.E.M/BC11SPSCB10, BIOS 8.23 12/30/2021
>>> [   95.969992] RIP: 0010:devm_kmalloc+0xa/0x60
>>> [   95.970052] Code: 5c ff ff ff 31 c0 5b 5d 41 5c c3 b8 f4 ff ff ff eb f4 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 89 d1 <8b> 97 60 02 00 00 48 8d 7e 18 48 39 f7 72 3f 55 89 ce 53 48 8b 4c
>>> [   95.970344] RSP: 0018:ffffc9003f553888 EFLAGS: 00010206
>>> [   95.970425] RAX: dead000000000200 RBX: ffffea003c425b00 RCX: 00000000006080c0
>>> [   95.970536] RDX: 00000000006080c0 RSI: 0000000000000200 RDI: dead000000000200
>>> [   95.970648] RBP: dead000000000200 R08: 00000000000463c0 R09: ffff888ffa900000
>>> [   95.970760] R10: 0000000000000000 R11: 0000000000000002 R12: ffff888ff6b40100
>>> [   95.970870] R13: ffff888ff6a55018 R14: 0000000000000000 R15: ffff888ff6a55460
>>> [   95.970981] FS:  00007f51b7d24700(0000) GS:ffff88903ee80000(0000) knlGS:0000000000000000
>>> [   95.971108] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   95.971197] CR2: 00007fac5410d710 CR3: 0000000f2c1de002 CR4: 00000000007606e0
>>> [   95.971309] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [   95.971419] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> [   95.971530] PKRU: 55555554
>>> [   95.971573] Call Trace:
>>> [   95.971622]  ice_setup_rx_ring+0x39/0x110 [ice]
>>> [   95.971695]  ice_vsi_setup_rx_rings+0x54/0x90 [ice]
>>> [   95.971774]  ice_vsi_open+0x25/0x120 [ice]
>>> [   95.971843]  ice_open_internal+0xb8/0x1f0 [ice]
>>> [   95.971919]  ice_ena_vsi+0x4f/0xd0 [ice]
>>> [   95.971987]  ice_dcb_ena_dis_vsi.constprop.5+0x29/0x90 [ice]
>>> [   95.972082]  ice_pf_dcb_cfg+0x29a/0x380 [ice]
>>> [   95.972154]  ice_dcbnl_setets+0x174/0x1b0 [ice]
>>> [   95.972220]  dcbnl_ieee_set+0x89/0x230
>>> [   95.972279]  ? dcbnl_ieee_del+0x150/0x150
>>> [   95.972341]  dcb_doit+0x124/0x1b0
>>> [   95.972392]  rtnetlink_rcv_msg+0x243/0x2f0
>>> [   95.972457]  ? dcb_doit+0x14d/0x1b0
>>> [   95.972510]  ? __kmalloc_node_track_caller+0x1d3/0x280
>>> [   95.972591]  ? rtnl_calcit.isra.31+0x100/0x100
>>> [   95.972661]  netlink_rcv_skb+0xcf/0xf0
>>> [   95.972720]  netlink_unicast+0x16d/0x220
>>> [   95.972781]  netlink_sendmsg+0x2ba/0x3a0
>>> [   95.975891]  sock_sendmsg+0x4c/0x50
>>> [   95.979032]  ___sys_sendmsg+0x2e4/0x300
>>> [   95.982147]  ? kmem_cache_alloc+0x13e/0x190
>>> [   95.985242]  ? __wake_up_common_lock+0x79/0x90
>>> [   95.988338]  ? __check_object_size+0xac/0x1b0
>>> [   95.991440]  ? _copy_to_user+0x22/0x30
>>> [   95.994539]  ? move_addr_to_user+0xbb/0xd0
>>> [   95.997619]  ? __sys_sendmsg+0x53/0x80
>>> [   96.000664]  __sys_sendmsg+0x53/0x80
>>> [   96.003747]  do_syscall_64+0x5b/0x1d0
>>> [   96.006862]  entry_SYSCALL_64_after_hwframe+0x65/0xca
>>>
>>> Only update num_txq/rxq when passed check, and restore tc_cfg if setup
>>> queue map failed.
>>>
>>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>>
>> Please, also add Fixes tag.
>>
>>> ---
>>>   drivers/net/ethernet/intel/ice/ice_lib.c | 42 +++++++++++++++---------
>>>   1 file changed, 26 insertions(+), 16 deletions(-)
>>>
>>> ---
>>> v1:
>>> https://patchwork.kernel.org/project/netdevbpf/patch/20220812123933.5481-1-dinghui@sangfor.com.cn/
>>>
>>> v2:
>>>    rewrite subject
>>>    rebase to net
>>>
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
>>> index a830f7f9aed0..6e64cca30351 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
>>> @@ -914,7 +914,7 @@ static void ice_set_dflt_vsi_ctx(struct ice_hw *hw, struct ice_vsi_ctx *ctxt)
>>>    */
>>>   static int ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
>>>   {
>>> -    u16 offset = 0, qmap = 0, tx_count = 0, pow = 0;
>>> +    u16 offset = 0, qmap = 0, tx_count = 0, rx_count = 0, pow = 0;
>>>       u16 num_txq_per_tc, num_rxq_per_tc;
>>>       u16 qcount_tx = vsi->alloc_txq;
>>>       u16 qcount_rx = vsi->alloc_rxq;
>>> @@ -981,23 +981,25 @@ static int ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
>>>        * at least 1)
>>>        */
>>>       if (offset)
>>> -        vsi->num_rxq = offset;
>>> +        rx_count = offset;
>>>       else
>>> -        vsi->num_rxq = num_rxq_per_tc;
>>> +        rx_count = num_rxq_per_tc;
>>>   -    if (vsi->num_rxq > vsi->alloc_rxq) {
>>> +    if (rx_count > vsi->alloc_rxq) {
>>>           dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Rx queues (%u), than were allocated (%u)!\n",
>>> -            vsi->num_rxq, vsi->alloc_rxq);
>>> +            rx_count, vsi->alloc_rxq);
>>>           return -EINVAL;
>>>       }
>>>   -    vsi->num_txq = tx_count;
>>> -    if (vsi->num_txq > vsi->alloc_txq) {
>>> +    if (tx_count > vsi->alloc_txq) {
>>>           dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Tx queues (%u), than were allocated (%u)!\n",
>>> -            vsi->num_txq, vsi->alloc_txq);
>>> +            tx_count, vsi->alloc_txq);
>>>           return -EINVAL;
>>>       }
>>>   +    vsi->num_txq = tx_count;
>>> +    vsi->num_rxq = rx_count;
>>> +
>>>       if (vsi->type == ICE_VSI_VF && vsi->num_txq != vsi->num_rxq) {
>>>           dev_dbg(ice_pf_to_dev(vsi->back), "VF VSI should have same number of Tx and Rx queues. Hence making them equal\n");
>>>           /* since there is a chance that num_rxq could have been changed
>>> @@ -3492,6 +3494,7 @@ ice_vsi_setup_q_map_mqprio(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt,
>>>       int tc0_qcount = vsi->mqprio_qopt.qopt.count[0];
>>>       u8 netdev_tc = 0;
>>>       int i;
>>> +    u16 new_txq, new_rxq;
>>
>> Please follow the Reverse Christmas Tree (RCT) convention.
>>
>>>       vsi->tc_cfg.ena_tc = ena_tc ? ena_tc : 1;
>>>   @@ -3530,21 +3533,24 @@ ice_vsi_setup_q_map_mqprio(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt,
>>>           }
>>>       }
>>>   -    /* Set actual Tx/Rx queue pairs */
>>> -    vsi->num_txq = offset + qcount_tx;
>>> -    if (vsi->num_txq > vsi->alloc_txq) {
>>> +    new_txq = offset + qcount_tx;
>>> +    if (new_txq > vsi->alloc_txq) {
>>>           dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Tx queues (%u), than were allocated (%u)!\n",
>>> -            vsi->num_txq, vsi->alloc_txq);
>>> +            new_txq, vsi->alloc_txq);
>>>           return -EINVAL;
>>>       }
>>>   -    vsi->num_rxq = offset + qcount_rx;
>>> -    if (vsi->num_rxq > vsi->alloc_rxq) {
>>> +    new_rxq = offset + qcount_rx;
>>> +    if (new_rxq > vsi->alloc_rxq) {
>>>           dev_err(ice_pf_to_dev(vsi->back), "Trying to use more Rx queues (%u), than were allocated (%u)!\n",
>>> -            vsi->num_rxq, vsi->alloc_rxq);
>>> +            new_rxq, vsi->alloc_rxq);
>>>           return -EINVAL;
>>>       }
>>>   +    /* Set actual Tx/Rx queue pairs */
>>> +    vsi->num_txq = new_txq;
>>> +    vsi->num_rxq = new_rxq;
>>> +
>>>       /* Setup queue TC[0].qmap for given VSI context */
>>>       ctxt->info.tc_mapping[0] = cpu_to_le16(qmap);
>>>       ctxt->info.q_mapping[0] = cpu_to_le16(vsi->rxq_map[0]);
>>> @@ -3580,6 +3586,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
>>>       struct device *dev;
>>>       int i, ret = 0;
>>>       u8 num_tc = 0;
>>> +    struct ice_tc_cfg old_tc_cfg;
>>
>> RCT here also.
>>   
>>>       dev = ice_pf_to_dev(pf);
>>>       if (vsi->tc_cfg.ena_tc == ena_tc &&
>>> @@ -3600,6 +3607,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
>>>               max_txqs[i] = vsi->num_txq;
>>>       }
>>>   +    memcpy(&old_tc_cfg, &vsi->tc_cfg, sizeof(old_tc_cfg));
>>>       vsi->tc_cfg.ena_tc = ena_tc;
>>>       vsi->tc_cfg.numtc = num_tc;
>>>   @@ -3616,8 +3624,10 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
>>>       else
>>>           ret = ice_vsi_setup_q_map(vsi, ctx);
>>>   -    if (ret)
>>> +    if (ret) {
>>> +        memcpy(&vsi->tc_cfg, &old_tc_cfg, sizeof(vsi->tc_cfg));
>>>           goto out;
>>> +    }
>>>         /* must to indicate which section of VSI context are being modified */
>>>       ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_RXQ_MAP_VALID);
> 
> 
