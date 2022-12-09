Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC96648A9B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiLIWJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLIWJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:09:41 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7111519A
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 14:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670623779; x=1702159779;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Djbl5OAE735ttZuc9aOK5HGMFsZsGzcZDcQe0ivLxO4=;
  b=LYF0EBPv4aURgDOcjHRBHAlLAVmB5awjGhbVxtE0Z+uK+UOEIAVCQzKK
   yJYD6F/9ORZLfRjtG00caQKt+12zVYFFkLKUBOH+3A08uOjDghfdnKU8i
   VVBA9lZDSzp7CkbM9Zh/ehm5LA9ISKqfIcv/nCOGIh8FZ8W030218+jiX
   GDIx1U7Yzono2XtK6tdDtS+pwY++48wmvmrMDvPB5tYWBvDA61+XsCYUE
   94TIjpa00WwdTJda56C50x8HnzoAYcGJQfx3byLIJPzlhjvXhbUIRDHJn
   ibDNVLqrVzmP9RnYjOQeHr4CbU91OTKC/Id0pcVW7p9n1zlJ2Kzez2Vwv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="403812974"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="403812974"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 14:09:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="892813997"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="892813997"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 09 Dec 2022 14:09:35 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 14:09:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 14:09:34 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 14:09:34 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 14:09:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxZPeLHVh512RkfB2WDDx4RiMQHfUSLGwH7ssP5ehBVeeLBrM6vcUeBL+49PySjq/3ZX/fu3p2dGUNbkvAERsaDYMMso+pz4H+8HBKu5YDt6Y+a+a3q3Exlg6veV1DMAxjOshJG2cAxHMpPS3AVslwFfJDhv6NJIHXSrD6GI/01CNXOUBca/jOC90Z4MlrJDUbzKZebwZ0WVzSeJ7MzA/MKZwNJxg4gAnLUKzi6Vv5o3zE1M9knVJF8l6JafYZUoNhK2ihOoOX08OG5xpzI+Pened4lHwEip/Pw0S3BgfGLLI4dEF2sQOidpEwMiJHZfBXKtkLZL9ulx6ZzAWDG/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOkQeAggLxFscnCTzyRc83j0a2boj5D+KdD1B6FgyD4=;
 b=aazhg7df1+YvNRBkwhWdOcrY0Zr1Os1dplzFEZOZ2qpNGTMqY+sLCykaNKdg7SaE67x/x90xVKPswuNToejn1Hkb9YvdUZq4vkmk/PEzwvWAF50bgPLciJg6Hkwm7ENszCrHa8dTDD7r5VzvZqNKfj9ByGmbwctsZJaBUx3t2zBw/SsaEydGVHANh6/nlsMljdhHJdctBa96IHrWR17Yba9gYRUowJERjSEhTDHPC253um3kMNGOscHi/uCsXYftDWf1MwjmwxQHBB32ewzF96ivmAeWQMFmOLVhzgxbNhj9TPD5FXOOUzM7jU6KiYIm5VKVKuwgtKhcy+wcx/8Djw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DM8PR11MB5688.namprd11.prod.outlook.com (2603:10b6:8:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 22:09:32 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%4]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 22:09:32 +0000
Message-ID: <dc08b6de-4bef-6439-ef6d-a8d667621963@intel.com>
Date:   Fri, 9 Dec 2022 14:09:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH ethtool v2 08/13] ethtool: fix runtime errors found by
 sanitizers
Content-Language: en-US
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-9-jesse.brandeburg@intel.com>
 <20221208063432.rt3iunzactq6bxcp@lion.mk-sys.cz>
 <52408830-e05b-03bd-3c3c-4195af1efbf2@intel.com>
 <20221209180934.cknkbvdr7gkphenf@lion.mk-sys.cz>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221209180934.cknkbvdr7gkphenf@lion.mk-sys.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:254::6) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|DM8PR11MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: d7f407c1-3463-4b30-7a2c-08dada320cb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Np0ido8lxoin2EOJ92B04uooffeL2osEuERsChwoOhp6IYSczPY+N4EsTuA/5Ue4Amw5F5JHc6KIGlt5tSkYhXbED0KS0AyGVRvUleITd5Pv0vYywimlqOsAcs1HdjI63Q72DruIzcruth1lPzAaHDfFbNbIZ8Z8DmxycG1+k4YgOUotojiaLvPe5Vv1+ggjL7AUcOk7Icax8no0JzPZd/TDwyl5UVLwJlRenMJgkzN7/dOhKh6he0GoyrQ+hzkLklT8J6DDu+HUKJHm2Smlz/3Ifepsre15oX1I5KdPCLvSgkCrbjijdmrBfjzHOxndIgPCjHYZTzHusGwQn0I9jhjPW1u2RsnOkKpH+JqxrlwyWDCHgjmaNLT5yOwwCg0MoxuV9uA7zsCL8664HaqnrqGIUKybWVsuHgoeYxv8VmZrySoPDoceYcmlpgmVlLIxc2sBorAu7o6O3Obt/dfxke0Qx7RLOcfLzAczy3obP+aR7a/Myyv61ZZNUEd5LxbgMgP2USW5q09/FvpU1l8u5Q1Zn1vXj5XKO+L+qFZAiRFqk/yuN233EOv1uPI2vLNGeOCK0Vnz7sxodPhIBQQqpTvDWsmMd0YrII4Jt2CC3Yf0DdIW1vwGWedqkOWGZPy7yRJ5o8SIdtm60iSsoUJvQoy7eeoc5CDuThPj22D96wAQmZOJR2EVzsbs1w2P4VYPibGHOLUbLYA86c/g4y/HN0lTiypPHvHXaubQ/8vcN9k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199015)(31686004)(66946007)(66476007)(66556008)(38100700002)(8676002)(4326008)(82960400001)(6486002)(478600001)(186003)(2906002)(26005)(6512007)(6916009)(86362001)(6506007)(31696002)(8936002)(36756003)(53546011)(5660300002)(41300700001)(316002)(2616005)(4744005)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDRFRXdhTTFscXVRYWdBSDVsSm43N3RXdk8xU1haN25zY0laUHVXc0kweFBi?=
 =?utf-8?B?Mk9pSWJnMDg2dm5GK0FFM1YvYTFnNTVxa3JlU3VwOEUwblpzWGFZaVdXZWcz?=
 =?utf-8?B?RVpmQ3hYRlBIYnBib0hVeldtTUtlNGViVVBKTC9qY3piNStBTWxEWUVrYkdL?=
 =?utf-8?B?SXRRYWxhS0NGSCt3czBnU1dVQldrL0R5Qm5IVHRsUnFENmZnK1NGT1gyZHRM?=
 =?utf-8?B?a1hxTDBmdFYyMm11WDZvQnpDbHh4b254ZkFJWmR6M1dISCsxOEgxUG1HbVJW?=
 =?utf-8?B?bG4yVWEzd1NLcFZrNE5JUkZkR1NDQ0E5V3pJT2ZoS2ZwcElRWFdJMmNPWFlG?=
 =?utf-8?B?aEVsT2NlcWZKQmViQVp6emxWeGVzdVd0bE9NRGpEVHFhbmI5L2lvZlQ5Q0Rs?=
 =?utf-8?B?TnY2K0RTakFnaDBLL1Mra0krU3VDSWFmenZ5NnM2Q2ZISjdQaVZWTlhqWnR3?=
 =?utf-8?B?YVg3UHZZY0NmeWVkc0J3L0J3aHBGQWlYU2VrTFEzejUyb2NQN0R2cTcweEVK?=
 =?utf-8?B?dFFOV2YzUU5VdEJ4aGpNV0hkRXlWYmh5UDcvOUFPMWh4VlBNUU5SN0k3cnNC?=
 =?utf-8?B?ZVljdnpGRUp4akgrb3ZERlpHelY2K2xRVGp4ZndjcEpsc1pBTTF2dE9UOFRJ?=
 =?utf-8?B?akx1SzJDLzVyMlZMWnU4UVl2bkNOb0l0RzUwOUM5UUNiUDB6N3hPczFRaGR0?=
 =?utf-8?B?VmxwZXFsVnE2WmVrWDNQNGxGMytiREVoTnkxWk82TTlzK1hXUHFTTmFGMk1h?=
 =?utf-8?B?c0x2SUp3Z25XUkJkczFLMklqTWd3TmU4SmEyZyt0aDliSy9LU0tSYUxTdWN0?=
 =?utf-8?B?eVV6K1h5QzE0eGpvUExsTE1LbHM1KytOUG9LM2toTm9nVUdleVUyTDhRU0FN?=
 =?utf-8?B?WTlyRmFqWFVQUTNab3RiM3NJZnIraDE2ZEJHMkdWd3ZNL1lmQVZnM3ViYm53?=
 =?utf-8?B?eG5hTEx1T3d1Q0RhQ0Y2MmZFK0pIWkVJamhJUm5wcHBDUExKYnVvaU9LcTY0?=
 =?utf-8?B?V3BkelBnK0ovOStDSkg0TXVRS0dMd1BTLzJobXdHNWdpZjdXK2VCSU5GTlNt?=
 =?utf-8?B?WmtIbEpzUnpPbXVvNWx4b3MzK0U5UGJ6aXRnMm0ybzdaL0t0YkFGWVN4TTJi?=
 =?utf-8?B?bHRwVG1haTJRYzdwUWNtN3lqTjJ5Y2luRkhTK0hYNTZJd0VqNWc4YjF3aHNp?=
 =?utf-8?B?R0xLdndqVW9LZFVmR0NwcUpCb0M1UzFYMFp2QVFKK3d4WVpVeW1SVnlpMUc2?=
 =?utf-8?B?K1VrU3BTUm5mRW9QQkM5QnpJdkUvSmRTbkhQcDViZWJ0eFpLQTdZdnZENjI0?=
 =?utf-8?B?Z1J5YmU1QlRVQnJDL1ArWURLTHY0cHVLN2FBS1RHNEdUeCtwTFNRa0lQWVk0?=
 =?utf-8?B?MWNKbTVTRktwUytOaDhmLzBuTUFraGtEZkc3V3pacnR5QTI5WnNocFBvcnBG?=
 =?utf-8?B?V0JDamhpdzBkVE4rU1J2ZHdvaCtVcWZJcE9JeVJHZ3hEeUpDWmk0cDRuN0pH?=
 =?utf-8?B?SGRJWE5qNnRIcnBmWTN4ZlFNY3VYdEpoNkVVWUQrcVhGbnNDZmo2bFJZMWxM?=
 =?utf-8?B?T0ptS0x6UU5wQmdUcW1FSGJnR1MwaktCb1BCMi9JeENMQy9HMFVIcEFwdUNN?=
 =?utf-8?B?QkxwY2c3YWtPb2RrUnlVRStuQ2haRU9scFdYQU1HVnRya0pnTnVzcUpWVDlq?=
 =?utf-8?B?MjRyUU9IcG9wVllmdGpQMUZPU3BFeU1FTWJNejltVVVRcHBmLytyR2VPcmRM?=
 =?utf-8?B?eGwydWNsU3drOU1CTEFWVzFpN3UzUDdQaGpJR1JTeEZ1Y0c3Rko2dDRNZ0lw?=
 =?utf-8?B?SUFaNy96SFJVOGUzYTBTSnhBN05tMXZHcHVFRVdjVWtZUXQ2dEc0UVEwNG16?=
 =?utf-8?B?a3lYM3ZvdFgvKzQ3TEQzbG5adlNSR3hIbXYyVTJHeWFFTFFMcG92TTBTQURX?=
 =?utf-8?B?RG15NENDTFJCV3cyak1JQ3ZzZlJrY1dSQk5tSWpKQXI4TytmRDRUVnYvMXRH?=
 =?utf-8?B?SFRBbDdZQUFJM3B4YkpmU0JGWk1tMlRtOFNZV1dBdnZucnVwcFJQRm5salgx?=
 =?utf-8?B?eWxWK0dwK1N3V3gxMFRlOGxUK2E4TkRjQ1VxYTdWMHBXYThtZ0tlSElYVk9V?=
 =?utf-8?B?Tk5xVXViejBKeUhoWlViRkNvUUtVVlVEK1ZhK2c2anpFNjlJK0g0SHliNkxQ?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f407c1-3463-4b30-7a2c-08dada320cb5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 22:09:32.4661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +jzBKNp4Ruk6jJs9uAYCJXT6tyrEztrrHPnN9Jl5b05cVDBlGxsHqcqi0lEECdY89LMjE1RMG2pg1jPfT5Tzm5cVIw6n/STaJVVEeAgTj5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5688
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

On 12/9/2022 10:09 AM, Michal Kubecek wrote:
>> I'll do it whichever way you like, but you're correct, later in this series
>> I fix up all the BIT() usages. Maybe we can just leave this patch as is,
>> knowing the full fix comes during the refactor in 10/13 ?
> 
> As we end up with BIT() everywhere anyway, I'm OK with either option,
> leaving this patch as it is or dropping it. When I was writing that
> comment, I had seen 09/13 (introduction of BIT()) but not 10/13
> (refactoring everything to use it).

Ok, thanks. Also Jakub pointed out to me there is a UAPI compliant 
_BITUL()/_BITULL() function in include/uapi/linux/const.h, which I'll 
switch 9 and 10 to using. Wish that function had been a tad more 
discoverable.


