Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9641F5752A3
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiGNQTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGNQTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:19:40 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A5455081
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 09:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657815580; x=1689351580;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ykYrYtzoRpUOeJQ7miWNnKl1jF2lnXN/rE8pe5ed90w=;
  b=QaCaGeflXmFq81D/rW74jFYcb6/QaoLeAK7g87u3PtmBQDbSRfAq6T3a
   3reHx2vbSA6A6hHI7dlyFihObPNdv/GKi1eLS61FZNLwoO6wiuyT8Wyxa
   a25dbzYHIpF7KbY5P5t37323tSwgS9UhIBH/3ZHr9wSLWzQoJ+Lax72Vl
   Z9rhEcA38db4K4mXOauVgPSJ/B7AzIOgyZoY8TG41L73kBuEOJL6ud0CM
   15N6MrZx6mzKAr2KbxAFo7rHMljA6XghZa8PKT5dK7PDmeF7ig1erXTXS
   OgUMspaCFviFqo+qsaAcVwceXjM3BH35UcrmHs2hgK0q1cMuAzXBupMak
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="285584433"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="285584433"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 09:19:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="923133466"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 14 Jul 2022 09:19:39 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 09:19:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 09:19:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Jul 2022 09:19:38 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Jul 2022 09:19:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvgBrHKMSEb2LSY6C/BdcXgsDGMrdtQEs879tFU7qlNYr7gsUws7mdSTJMbNOfHU7kqa+fDgTnoKCdEi8kmflT74y2MA8ffVKoxi35gjcB1+xlzhbZelcmZSwpUR+Qaw4nGciewe09foIQB0QjeJRbb9Jk7izoDLeFxEuK4HCOrHINps9hhtrWnei/homV6zJYXF+ty7ZKWvsP4H5qlcpT4bYgVxINcenRWze7jobUSiY9CqaLI9cNyFVGzTF4BKl2u9hIESPWbaay+3df/+wZoPlQypAYeYPgm+D5sus3rKyMlLwd3mDYmkW0KbKwHzdvP/0tzxfGGccbo0XuIv3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uALMQ0rSi9+Gb4tGv3QsyXO2OHuBSfjRh6GxyYUEFGs=;
 b=IVdX/sSsxiXzyTkdSfB8hZiw4i3GliLHjRuRFl/KcWhNmh/W7znhREKaHhTOhIU+1+EGNgvwzdyiRacdStcCWUShzYRT8TWMCUYe/+0bZw4cQHk92ug2ZfsFXVbMSLwpqsLU2j3dDy7eQ7+An2YhcDMq/QFSid1qKX39sCiVf466ysjoKE/EXpkmE9qiZSg2dR0AaHIVU/5iZwsPLSug+Zw2Cbl+Wwpp3PFtWxFtkqWutXnF75RmoNy9pd/yu4q3pLw2pwXEVXT4drQBQ17I7g55qpXAbkHDNaEUhjqJBbaIWD/SNOnklTYyCWYNiEM3avPCzFbiG9MgGnrzyuR4WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MN0PR11MB6181.namprd11.prod.outlook.com (2603:10b6:208:3c7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Thu, 14 Jul
 2022 16:18:59 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f864:3e02:f509:5783]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f864:3e02:f509:5783%6]) with mapi id 15.20.5417.026; Thu, 14 Jul 2022
 16:18:59 +0000
Message-ID: <8f29588a-6c4c-2e0f-8392-71f87e07958a@intel.com>
Date:   Thu, 14 Jul 2022 09:18:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net 4/7] iavf: Fix NULL pointer dereference in
 iavf_get_link_ksettings
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        <netdev@vger.kernel.org>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
References: <20220711230243.3123667-1-anthony.l.nguyen@intel.com>
 <20220711230243.3123667-5-anthony.l.nguyen@intel.com>
 <20220712182636.53a957cc@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220712182636.53a957cc@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:a03:40::47) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e74e93aa-8a2f-4362-3f21-08da65b48e9c
X-MS-TrafficTypeDiagnostic: MN0PR11MB6181:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wzJyU4w9QO5TF9SOZP+35+PIRY4hxtEpy0m52UdA7mav0PmqxH0jmr//s8+7m+YqI8Cr8fzTxfkbQTX++B2IUbjb3xJfxUWMMF/REQJdxaKcg/oJSyXUQIh8Ta8ZnWjBzRDJXLgB8CYjjIuqALh4tOomlSpA7pBctvrGi3VP2U3NQa8lvmab1Y9IY1YN74KMORranl9crdFQqr6cGCuwDCo3+6PFIM4oIT2lz1kFwTAkyEkVYNwUeUum8hy/6yAErzhZwfdhbnJm318hLWZ2QmtKmNquN82Iy5d19ktdvrOL6mB1jfnhD8SOBWwb3N75Pj9WbUswg+53AR8F/EMCIxjw59pYm+u9nqIUWhXsgizFSyk2AvWxpGzVq38VP+tW5EvLZEHGUtfn4WqnciWo231ohMQukqwQWnYbbxf3xcir/6wVgwuhiSM+H7U7zGwBHoNEmRI5QmY4ihPfbDDIDUyGJ+zKQv5xURY7aEhJksrlEzg8S6aNeHJhcsK0gnvIsguFuQGeKeEEmQML/HicC9gUnPrAol6etUIDlkMzTBv4PaCFPNphMVbMxratFf0/T0oHON68fGqLmCodpiXu1vQmyPrDJIz1W9OIA7YGztnJJ4vX4cyaxOS01rczlx0DbjAXNn6krTHeySyLzUOviNptE6zIcMjjZa72ho4PkRG+6keax6IV9oJ4dMz8lgxUmiOI1N93VlF1DIiulvKMp3MZUdhGzIpMu+6M4iruw+COxM+sAOfAoSW8Ib7yBjHJ/mbvA+503oovi5axg3O07tH1G881bsEOjwbeOl0ZFgr1FBjqP5tp55Yb7GceZiKHjltFFpV72QID+OECHKdqow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(366004)(136003)(39860400002)(5660300002)(478600001)(186003)(2616005)(8676002)(4326008)(31696002)(86362001)(66556008)(316002)(82960400001)(66946007)(6916009)(6486002)(2906002)(54906003)(31686004)(38100700002)(41300700001)(6512007)(66476007)(8936002)(36756003)(6666004)(6506007)(4744005)(107886003)(53546011)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2hJY2NTL3ZjejJ1YXF2RlM3d3hmQkpuME5UbnB0bkVWMkhwdWF1SkoxekdK?=
 =?utf-8?B?OWF3RWVCbXE0Y2xRSUJWMUU2eWJEZFFHOXdkM0pVbEVUZWxxSk9EV2lHTVkw?=
 =?utf-8?B?MnBvSDRzVUE2TCtuMkNTTEEwUHJtTkVReCtjRlRCZ1gzQXRjVmYxbU9Ec1lR?=
 =?utf-8?B?ZE1nZmhuZlJNVVh6YmlhN2VhdGs1WFpXVXhsampsR1ZGL2NWN3ZXZ3UrSkY3?=
 =?utf-8?B?U2E5U3hvYkt1ejdnRlE1SVE2KzBhWG9na1FUa2I2UVdTb0c1c0lDK1FEWjlU?=
 =?utf-8?B?M20xZjZZMXg0QStEV0VhUVZpVGFQQ1NydzhYTk9QY1VCaUpZMENUelBEUmxr?=
 =?utf-8?B?bkN5bFE1dGhGYzRRczZJLzJHYnc2NFVRT1JJR05xaDNvVG9DaGZPWDBXY3F4?=
 =?utf-8?B?ME1mVnNGSjBpRFcwTW1tbkM4aEJBOHFETkY2dE9UTi9VRkx6UXg5Qk1EZmFk?=
 =?utf-8?B?RXZZcmU4ZzJadFRuU05UQStIcWQxNUplYWJDWld6bkN4WmJJSVYxb0d5V1M5?=
 =?utf-8?B?dERpWFlXNXRCckhOUmVEcUlLTkVkcnRrL01RVVhma1hEUHd2bU00NWZKc29x?=
 =?utf-8?B?cGdMQ0Vycit2cmhwRnZweHRIdzV4Rk01RWQ4UHY4NUtUY21KM0Vyb2V2OGJk?=
 =?utf-8?B?ZWxoMHNadCtKR3huM2huaXcrTGRhRlUxanBZVkdCYnFGR2g4MDIxQWRsZGZ6?=
 =?utf-8?B?WU9jNEZUWkxjUmdiWXI2SE5aWlpuUnNjOWJDRms5TW05Tk9YMzFWSzZEdDJr?=
 =?utf-8?B?bWhEZjFHNHFUN1RFdzJlTmJNRDlRanVSaGU4WGpUMjJWYXpBbGhPSlpxN013?=
 =?utf-8?B?TGgxUktXOGg2cXNEL01lcytINWJ2QktHczR2WE91UEZYOGsyMmdEMytZemFV?=
 =?utf-8?B?c0N5N2Y0MGMvSzBVdUREKzRwQUo3NE5Edkc2bzFJdHBNeExwMjB5WEdBdzY3?=
 =?utf-8?B?R09vREZGZGJ4b0RSK21CR1hST2Y5aUF2eDYzL1VpUG9adlUxMnJZQmVZNTFR?=
 =?utf-8?B?MGtVRzZPajY5WnE1MDdtS2J1ZitmRkxiTVpqL3dHVUlteEgrNExHTExhbG8r?=
 =?utf-8?B?Nk9IeDlhMkwzUEhjQlhLQ2EwSG0wMkNBOHB5dE5GTjRWSHhlY29QTUlnVFJl?=
 =?utf-8?B?cUM0MC9CNGhsckRPSU5ZRkNLdzlCZzBCcm44dll6Wm9YUTV5M3B5NnFPNXh6?=
 =?utf-8?B?aVZlajJDeS9ZOUVRVkpCN210cFdhdFF0NFZSRERIMFVmSFo0bGVaQkdWNGsw?=
 =?utf-8?B?dXloK0gzSjZKYjFFcmE1UEtUb05WU1p5RFVpMkdRN2dhNmp1K01oUFpQL3dY?=
 =?utf-8?B?cXNuQ2wzR3dWSFNZYWdhdEhkUFlaaDU2cmZqMFN1anMyYjJNVWlQK1grTVk0?=
 =?utf-8?B?R2pCU1M0U1NrQ0NVMG9yRklIelNGRE40ZVdsakRMamhZWUNWQ1NwckRxdm9M?=
 =?utf-8?B?c0UySUM3SGZETFltWE43dytPNk9qQVdiYTdqMzBjMkR6Z1VySWZZb2FTbGJT?=
 =?utf-8?B?bHpuWlZUTFFpMzhsejk5b0t5K3JXaHFIVG5NS2ZWZC9KRzcyNlRMYnlKUjNS?=
 =?utf-8?B?dzh6OFo1VnMveTNRUUlZcitHK0VyMUpaNXdmY1o4NWdFOHg5QTJJY1NmZmVW?=
 =?utf-8?B?UUU3ZjBIU3FFOC80NjBmaVM3TlZTRjcxK3FHWm5HWTRxVFJrbXA4dWtSTU91?=
 =?utf-8?B?TFBnZGI3SHNpZVVsVTk3ODF2UHVTVEV0NlpYSDRwaDVLc3RLczVueDVpVUhP?=
 =?utf-8?B?KzdoMDM0WjBWUytiS1h4ampjR3ZiZUcrMjdmcEZ1Vm1rT1dGZlFYSG5oQ1hW?=
 =?utf-8?B?dFcyV0xRNTBtSytTQUxocS9GaGx3RDlKU3hMb1doZmNWdXdFTUJlUEFNVkpo?=
 =?utf-8?B?OWgxbFRVOEdhT1Y1ci9oa3ZrY2MyZk1VU1BTUXlKTVZaYllPUU1XNlQzNm5m?=
 =?utf-8?B?T1Z1RHVxd0owaS9rK1JmTE5uUGI4aU94R1dxWUpDOVlQMkVLd09iY2VGZGJO?=
 =?utf-8?B?MWpXMUhmUlBKN2E2Z1ExdStlZUFjRldOaEtYZmQxTk1GQkpFMUlqQUN3VDlt?=
 =?utf-8?B?TlNjSDJyc28wS3lPOVhJVFd4TzU4eHljMXRjVkV4eDVwNUlVWnB0V1pWUTlO?=
 =?utf-8?B?TE1ydEhjNjM3eFgvY1FGL0pCWmZTN3Z2dXd5L1Z6MXNVa3p5WEwxKy9qV1Fo?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e74e93aa-8a2f-4362-3f21-08da65b48e9c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 16:18:58.9500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSpg52kCO1bfk0ZXFrxPnV1FiDFEkx18ZCh4Vy87eU/QpnfWa1jjjY/vmrjjYN8JnUBugME/Xtcd9Be6FM4BR7m/p09to4cv6IL1XgOcHDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6181
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/2022 6:26 PM, Jakub Kicinski wrote:
> On Mon, 11 Jul 2022 16:02:40 -0700 Tony Nguyen wrote:
>> +	/* if VF failed initialization during __IAVF_INIT_GET_RESOURCES,
>> +	 * it is possible for this variable to be freed there.
>> +	 */
>> +	if (!adapter->vf_res)
>> +		return -EAGAIN;
> 
> I think I already rejected a similar patch in the past.
> 
> ethtool APIs should not return -EAGAIN, if the driver needs to wait
> for some init or reset to finish -- it should just wait, we can't
> throw errors at user space and hope it will retry.

I talked to the author and he doesn't believe waiting in this case would 
help; he is looking to see if there are other alternatives.

Thanks,
Tony
