Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9C5B633A
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 00:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiILWBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 18:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiILWB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 18:01:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFE7B1F2;
        Mon, 12 Sep 2022 15:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663020088; x=1694556088;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FOtvVcyfkt6giYZV1HD/o+lioyAGAwFHGdgdKsBX/kM=;
  b=mrgmeB42CcUesOuh3tBRsI31CNLDtCu60rlRriHZj4arkFXjR++50+1v
   G8Dis3IdBlyxg+r62vZAnihC/Z9gaRA5sKcMKKKmv3ozACVyk9ruYRho/
   U5bmTS4vZJVSxJ15etPrxZwN+fvsI9wBaetvFuOiaYE+9fCH6VPJSX/pC
   dcYs3vZxjtGvcbB6bTA/M9qK4jk7HRheyQNHAUkBbTU3jJe+hE6htU+/v
   JTsXaMDH122dfyfuLBdRc01fCIoxDxgWbXJ8Gq334RPBMPUpvV+0py2K8
   B6yVpZRJeJ5daeIAbWXaD/UxsRyox0Vyh8YZJscJw1npDOxVIQksWJ/hp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="296715200"
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="296715200"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 15:01:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="646652166"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 12 Sep 2022 15:01:27 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 15:01:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 15:01:27 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 15:01:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHHpgmOjhMcUoR4Cm+Qy5L9MKiEARReE8X0aaGNzcBTDZuD1k//OPKkt+1HWWmElguPGaST3rg7EgJCzAW0/xN8Xkp5sFUg/mdLsa3uf+l7wnhLNBNAbuv8XuXzChx1Wy6BZuXI5OnxXBTrDu8IB56vm6Y1qFY8TqCICzv4nKjKvGS+rTXPGoQ5bV2hJ7ue2i0+gE+qH0payHJIMgIRgeOQ0rlYpgzZUunJkFSSnQGRdPc//fNLCQvowdsNTDXNhEjPxj/0y0IvLWBwlMQaDjFVtYSEBX/8xLjfg27dbCEJGagV2ChCdVvioyOlkvDVINZO+ViecYzDuN6fkXaIMEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htKeQUp99IwIga5iDLnIkN0lWP4+4smk9KbWRKSgFwM=;
 b=RyEoFAOTabDSecTV6+ExdIIsfnuIUKrzouWZgXOabSQXqD8CXGkb14YFqt/cIAgKMgiqxENWzJ42g5L3Qsx1yVKISp/FZGMuF5XsiJBzqijEC9ZB0iCjY7Ia4qJdGTzLbw/Znkf8LQXPiEC8kTxe+zKPpZZ2e3D7NxVXYcPVfdTe3wMF6YPIfZN9B7EkJs9xViXHk5k08Jn2YuuS/wLCJZvaqbEVeHfjI70pWzYApFzRl+4CUF0vKEQEuxUZPWWdDb02XzUP4+vlC+ZDpZi1r3zQ/Kcn6JyI9LfXyS2s++To5LS5GoHaSTXQ+TaWqrfZgdFFT7ZLUf2zyoDnaNzRgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DM4PR11MB5261.namprd11.prod.outlook.com (2603:10b6:5:388::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 22:01:24 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 22:01:24 +0000
Message-ID: <6445a450-d15f-be32-818a-4bb1c11ef429@intel.com>
Date:   Mon, 12 Sep 2022 15:01:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] iavf: Remove useless else if
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        <jesse.brandeburg@intel.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20220909033240.46329-1-jiapeng.chong@linux.alibaba.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220909033240.46329-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::26) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DM4PR11MB5261:EE_
X-MS-Office365-Filtering-Correlation-Id: b72eeaba-d943-4da3-d903-08da950a557e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pL+rRPMU/RdaH98JnP47ecWPwN5r6OPOQkFgrfaGCHfi86MvCcPLKxpRn2R9G4hxolFrsHWBzPkxRjYx67JguOcu4JOQe4Syl918MtVjJw1NverB0M+hv9vSOyRTWc0oYNanjg3Z98AZnF1FJ3kR5vubkJQ8KflbYACnH0YVfuNUpPMlngQLRs125W/l8pFZ5G6H5qLI86EKR7GJSGxFgLfNvtnlMPZXB2UYW8E8w3Wha+x+zH3DI97iAcxnaU10iMA+kw24Vfi4GqBGhb7LrQ24JVISnZqJ26AjkeSVcHkoI8Cydp85k4w4ddW8zHT6Syso/MZHD9hBB/PnOs3ZtlAFl3gE/QkBM0YF1MaZh0E7/33BfR2NGOIgXFtZxLEJ54QtI24VXUuzMm83iNgqvsA+mityoWYyhXL47o9agBz8sZkd21ldjKri/bJ6gnBL7M83mlJV7n04x6dqM22PTdmPLBF+2OSPlFVPxcxiuvi7JZ/EVs0pmRBCZMwV5WaVg/gUTdLh6TFjdUldEbavi0IApd8sa1wDuwfueNbhl0bFro0G+sbsDXn5hoeAO/K4da5TbeQVVwGw+bWN2cs57k0fxKONmq4M/BaBnRx1t50NXh7hP1EjxDVTeoKaGqvzgRPnTPq43olAvTNeOHo+UwXN/6kds+Xhyg2YVZORuQm6J/k9y41HUgT7eDlbHNb/eUjrOU+nz5DI6LKGhjjwm+eNte2YNZ8ICWlYknAhBFf96XuQ17Xt1WS01Qlq5gI3mViZPtLSGAfhGYgU8Y5rUzcN+ERZbkpGmJt7f/PRDxkg84ENElH4q14imVajvbah
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199015)(4326008)(6486002)(6666004)(2906002)(8936002)(478600001)(2616005)(36756003)(6512007)(31686004)(186003)(26005)(38100700002)(8676002)(83380400001)(82960400001)(5660300002)(4744005)(966005)(31696002)(86362001)(66946007)(66476007)(66556008)(6636002)(316002)(41300700001)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXBmOGI5N3ZtTWdhQ20yb0VjZWcwQ1N1VUZxK0hPc09idXNla2dRRkxFd1B2?=
 =?utf-8?B?MkRKTkJKZ3QxYVVGZy9zWnFDMWlma1N0ZElDTGRmY3NRNE1tMy9zOVhiTFd5?=
 =?utf-8?B?VWdkZW00bDQ2NTRxbUI2YzFLbEZIM2NNRlByZExvSHZJT3Zpajdqb3VMbnV5?=
 =?utf-8?B?WHRQdk9ST1N2NEE2Y0ZnanI0eWlhbVlWZGhTKy9FMzRsZEJpU0l5NzNKZ2RC?=
 =?utf-8?B?MjJrYm9GTFpSUjc3QklPVHJtY0wwa2Era1BSL2JJSG5FV3d6ZUJ5YlpQU1di?=
 =?utf-8?B?VVBFcVpMSHFjU0dUL24yVzRhOEJIOWx1d2RFSHZDUmpHdEN1TEd6MVNjNTM2?=
 =?utf-8?B?Y052bVc4RWN4cm05YWVUbnA4VGVWa0piSG8vZG9GdERlVk9KYzZ4dktFNnc1?=
 =?utf-8?B?Z3BnNmJUK0VteWZuZVFxOEF4cDNsUjhEbWFPWG00MlZvMnZUbWViRjFKaHBa?=
 =?utf-8?B?cktPek1VZnBqZlEyNFNSWlpNdTl3QTNuRE56b3d2cjF5Wm1BZXhPWnN2clFh?=
 =?utf-8?B?UExQRkFRZ3EvQU9VOFdXZlM4TENCQlVKUUdScFA1VE1zczd5MlZiM2cwMzlG?=
 =?utf-8?B?clVydzBna01tRFIwYzlkN084RElPVlNWOHY2OGRwTGZIbEdxY29CMktuSWc0?=
 =?utf-8?B?UnF2SlA1TlNiM2tId2tmU2xaZnlNcFJkUmNZOHVlb2hpNjZYMU42YVA5N0RU?=
 =?utf-8?B?Y01JQjZCdzlLY3orT3JQMkxkVTIvRDZ5RTdFK3ZmaXAwSFZhRFpmdGdUeFV2?=
 =?utf-8?B?M3dWK2ZaeTVzcm8zR1NUd09lalVzZi9Xb3I0QjVkQWUvL2N4SEpEU0Eva1B1?=
 =?utf-8?B?NE1BOVluMmlRS1JZMnZ0QURDN2VmWVZTdHQwd0p4RU5qajk5WWdTZGJWNnRX?=
 =?utf-8?B?ZW1FUHY1Y0tRai9JanJqOWI2cFQ0c0liU2JpQ1ZTM1V4RU5Zb0o0VTVhKzJG?=
 =?utf-8?B?L1g2Q1pZNGphUWZCc3Z6Ylh3N0JvS08rTnZ6U3dQeWhRRjE1eXZOeTU2dysz?=
 =?utf-8?B?NXJJN2VuQ2RRU0lBaWE1SWd5a3dZQi9iSUJrcFQ1aDRpc1g2akR6WjRNazdy?=
 =?utf-8?B?UXc4bWdsdWJNZDZVMFoxYlVVL0lYeklhWFZLK1BtcGpybGtWNWg2SW5vV2dS?=
 =?utf-8?B?VGxkN2EyNzVWUVplS2Y2T0lNRTdpRXZwdWpWMEE0M2JiVmNlMWFmWEhPNFlH?=
 =?utf-8?B?cGdHMnFJQ3pkU1dhU1ljUHRBMG1PTG4wMmpDTlNlRVFxSDJCaCtIY1JPWHdS?=
 =?utf-8?B?OVlzMjZEczVmVHlVNDhLRzNBWWVxQlFUbXZOSElKNWEwREpsQVdLK2dpRmFW?=
 =?utf-8?B?N3pEMHloRVB2bElaUk9QM3BORUlCV3dJRUU4aVV2enZ4KzVjMGY4ZFFBTDZp?=
 =?utf-8?B?eWZ4OEpHQUFLYjFtbWtvbkZ2TUdrWmZQckptdjRpdE9vdUdJYzhYQ08zbnRq?=
 =?utf-8?B?SW92d3lHQ25yL1RzUUQ2NllSUXd3bzFocGNhYWpHRzRoeHRTbjlWSVdKTk5a?=
 =?utf-8?B?aVJUTEFzVVlTSUwybERHTE5xMlI3SGxFdm16UWtjaWVSZ2gxMEhRbzdsZ0hI?=
 =?utf-8?B?cjB4azhFMDVEREc0STdqdW9xd25VL0FIdXRwRmtOTjMzZTBqUGtEYlJzT3JG?=
 =?utf-8?B?M1NEbkNtWVp0OU1WTmFDUmNIOGxNdWxoakZndWorZW9TZ1lTejJ4VU5aaDIw?=
 =?utf-8?B?MzlyNUxaeWZaNTdZWTFiZTFHQ3B3R1ZXc29aYm1oZDFWNnM3RC9mVkhwV2Jk?=
 =?utf-8?B?YUVibWJieTQvODdDMFBhVWd0SXp1U2FsK0dScTFFUjFncm9vYWE3bFVSUjBD?=
 =?utf-8?B?OWpHa3JkTzE2bFBoL0lzc1E1Z290VTVhSTVrYmVZejBhZXlDSGFSYVAzRHFh?=
 =?utf-8?B?ZG5WdzAwMjZla1NhLzZPTDFPQkxvbzV1QnoveU9FeFJxam91WXhjMFZZQzJQ?=
 =?utf-8?B?Y3RXZzIvZVcvbWhJOVRQNXdQb2VvazZ5WDdjS0ZmZ1IyUTFUK0xoait6aVpO?=
 =?utf-8?B?azA5UlJuUjhDM2c3UFZFMlZOUks0b3N0eGVHZkQ1VEw3cEI5bm9vUnBRU1VJ?=
 =?utf-8?B?V3ROQVFHSEJrRjlKZjUvUU1OS2IzVmx0cDVCditFdUtZaTVrQllQZnpZOGxz?=
 =?utf-8?B?MXRnM2lwWDNzSE0wQU1uQ215TUlsV2syNi9YbUtNNmVFQXhrNjdrd05UNzBI?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b72eeaba-d943-4da3-d903-08da950a557e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 22:01:24.4653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6HshiyU+Q3GVrCsT31JDeboV6Lf+vkxS1dK1obW/HHaJgJPldGHCHsOC/fe06FgpZQXiV3TN6fJjfKrtAlX2sYWNSABaCe9WevrSCPvgxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5261
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/2022 8:32 PM, Jiapeng Chong wrote:
> The assignment of the else and else if branches is the same, so the else
> if here is redundant, so we remove it and add a comment to make the code
> here readable.
> 
> ./drivers/net/ethernet/intel/iavf/iavf_main.c:2211:6-8: WARNING: possible condition with no effect (if == else).

This was already nacked by Jakub [1].

Thanks,
Tony

> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2106
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[1] https://lore.kernel.org/netdev/20220801091355.6ca23bcf@kernel.org/
